Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C0E3B606C945
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 18:12:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SjDENAeR
Received: by kanga.kvack.org (Postfix)
	id 4CCEB6B05E6; Fri, 20 Nov 2026 13:11:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 47DFC6B05E7; Fri, 20 Nov 2026 13:11:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 282AD6B05E8; Fri, 20 Nov 2026 13:11:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E30906B05E6
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 13:11:00 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5BCF7C013F
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 18:11:00 +0000 (UTC)
X-FDA: 85456288680.23.83CDA4D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 3A02714000D
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 18:10:58 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SjDENAeR;
	spf=pass (imf09.hostedemail.com: domain of devnull+gourry.gourry.net@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+gourry.gourry.net@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795198258;
	b=Nasp+nwxtSBetQe4OQlYazMn6ZN6K4kpqFKpob5sVNmnOl7vkaBehee/m5CXH/cRnEZiEK
	MzQiPLOKwNdvVVYWWC+vduOrH7O5DVHS61UNyvntWrdGZ61fKLHF1deI/SzR+uZfT1qI6E
	jwexP4BO7xszufQ5IGJlmK8In7jFdVg=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795198258;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JTyqGpLSDZFs+2eYm4pd4otew24ISSwcxMOMw8Mtcoc=;
	b=zOjVvR5m0boIvrdh3K5DegxRT59T0EPmart/xS2U81OcS4mhTR8Kw7dPX4E+RhJPlVxEoa
	WBf2aoGJaUczTgmtGBDdLLDSF5R9MwFOxyewdN/DGxHnuWdU78DXvYEZci1aUi84MyCBks
	iI38VCuBXRftlt9EohvBj6ahiwd/ccs=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SjDENAeR;
	spf=pass (imf09.hostedemail.com: domain of devnull+gourry.gourry.net@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+gourry.gourry.net@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 83FD745049;
	Fri, 20 Nov 2026 18:10:57 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1795198257;
	b=KjT2aUW45N1jJZpuLI01McAAOGWnweXdIKt3HltI4tYe3Vm9ZF4MU5ZDWC+yah8i0fyp
	 VlT6b2d4kuvhMADsKTWO1RCfbS1SiYiRIDcL/EtIqfKuRCeVlXOUQORbYjdf8EkbzybhI
	 qkA4P9ORwok3j3ffY1LkTq5MUiCjtWcXRnO87oiNmfeo8lVpoCD6vzBrmlYEcHJnIAtLR
	 Em6AuZat9nNPig3/BsTdQApxZCThX72KqRw/i1lwJl4Lo1w12G/de6XXkCJ+2BCuPScR5
	 VCepvf5tiK6LP321i6Gr2luPvPZeebq9ZAGTWaYPwi6cpzEs2JGkkBDyLoqg/E+xdfQ==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1795198257;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=JTyqGpLSDZFs+2eYm4pd4otew24ISSwcxMOMw8Mtcoc=;
	b=k5Skpv6Xowdu6Rdr01FFM7WXAvAU8EqWthNHA7YEuaH7tb5+W60hyAgRj5ewOIiefU3M
	 drO7e5k8pcZ2ytcnViLQpgNBBS5OL/negZUCFbvBwiD7K6rKK18BsZ9HkbVhBpCNZUH+P
	 2Ev8DgeO0iD4iNsPBmwhKVYeGEphKn4tfHvbfok+QbIKblZuj2eoctN2u+X3JV9uurpQn
	 hs0z+KM+BcFDw7RpyTCcIt4C0LGy6sOkfO/y1DnwvqSA5vrBdzQlev653QY77YGpxLZ/7
	 MXRebHH77fFT3Kv7ZQsYXt00rGLjcKfeEkwg8igBZ+m6kJ0dvCcVioXTF0ah4DWqKuw==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id B74821F000F0;
	Fri, 20 Nov 2026 18:10:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795198257;
	bh=JTyqGpLSDZFs+2eYm4pd4otew24ISSwcxMOMw8Mtcoc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=SjDENAeRIiZPgoh7IHWDhqPv7/r/x0TEMhyRLTYqY1AVZfOsQNfW76UvxkjYE2zve
	 zVmZ8IKqeLcIDWbII85MFELoRsQreb7Nhp4UPkpJWIQB2IMfMGrLQwAG9dW6pVwiFD
	 2GxFVAGRB//DZ3mu4TkouUXEedQX3N1TU/ok2voNFweJ2pJ8u6FhQ6fnht/ilUjSqz
	 CwcFztlM1rY9fbKTktnqzY2bW2JX9xk5dNWMRuVxKQO/XYfdzWaJy3hsR6kqWVX6pR
	 UKHHqpn4B+VP9hyVsvnysJgzGTdt3UOBDG9BROPOrEfyTXJEyjitFLQZESYemBBdIy
	 QqtWb2mxM4ImA==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 3E68C4B96D;
	Fri, 20 Nov 2026 18:09:22 +0000 (UTC)
From: Gregory Price via B4 Relay <devnull+gourry.gourry.net@kernel.org>
Date: Fri, 20 Nov 2026 13:09:34 -0500
Subject: [PATCH 43/60] mm/page_alloc: fall back when a bind policy's nodes
 become private
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261120-private_nodes_v6-v1-43-74f5f9a115c2@gourry.net>
References: <20261120-private_nodes_v6-v1-0-74f5f9a115c2@gourry.net>
In-Reply-To: <20261120-private_nodes_v6-v1-0-74f5f9a115c2@gourry.net>
To: Yury Norov <yury.norov@gmail.com>, 
 Rasmus Villemoes <linux@rasmusvillemoes.dk>, 
 David Hildenbrand <david@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Oscar Salvador <osalvador@suse.de>, Johannes Weiner <hannes@cmpxchg.org>, 
 Suren Baghdasaryan <surenb@google.com>, 
 Brendan Jackman <brendan.jackman@linux.dev>, Zi Yan <ziy@nvidia.com>, 
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
 Randy Dunlap <rdunlap@infradead.org>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 "Rafael J. Wysocki" <rafael@kernel.org>, Danilo Krummrich <dakr@kernel.org>, 
 Johan Hovold <johan@kernel.org>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
 Rakie Kim <rakie.kim@sk.com>, Ying Huang <ying.huang@linux.alibaba.com>, 
 Matthew Brost <matthew.brost@intel.com>, Byungchul Park <byungchul@sk.com>, 
 Alistair Popple <apopple@nvidia.com>, SJ Park <sj@kernel.org>, 
 Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, 
 Juri Lelli <juri.lelli@redhat.com>, 
 Vincent Guittot <vincent.guittot@linaro.org>, 
 Dietmar Eggemann <dietmar.eggemann@arm.com>, 
 Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, 
 Mel Gorman <mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>, 
 K Prateek Nayak <kprateek.nayak@amd.com>, Kees Cook <kees@kernel.org>, 
 Kairui Song <kasong@tencent.com>, Barry Song <baohua@kernel.org>, 
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Michal Hocko <mhocko@kernel.org>, David Rientjes <rientjes@google.com>, 
 Pavel Machek <pavel@kernel.org>, Len Brown <lenb@kernel.org>, 
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, 
 Dev Jain <dev.jain@arm.com>, Lance Yang <lance.yang@linux.dev>, 
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
 Xu Xin <xu.xin@linux.dev>, Chengming Zhou <chengming.zhou@linux.dev>, 
 Lorenzo Stoakes <ljs@kernel.org>, Pedro Falcato <pfalcato@suse.de>, 
 Jann Horn <jannh@google.com>, Chris Li <chrisl@kernel.org>, 
 Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
 Youngjun Park <youngjun.park@lge.com>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
 Waiman Long <longman@redhat.com>, Ridong Chen <ridong.chen@linux.dev>, 
 Tejun Heo <tj@kernel.org>, 
 =?utf-8?q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
 Dan Williams <djbw@kernel.org>, Vishal Verma <vishal.l.verma@intel.com>, 
 Dave Jiang <dave.jiang@intel.com>, 
 Alison Schofield <alison.schofield@intel.com>, 
 Shuah Khan <shuah@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 linux-cxl@vger.kernel.org, linux-doc@vger.kernel.org, 
 driver-core@lists.linux.dev, damon@lists.linux.dev, 
 linux-pm@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 cgroups@vger.kernel.org, nvdimm@lists.linux.dev, 
 linux-kselftest@vger.kernel.org, "Gregory Price (Meta)" <gourry@gourry.net>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795198153; l=3943;
 i=gourry@gourry.net; s=20261120; h=from:subject:message-id;
 bh=MvCOuLTJrjpaTAmpn2Zbq/KX8f7RvrtAs1ipWbBROxM=;
 b=DVYzRbCZncJFfd8wmeRLbtBkyfuqBe2ViahLjuovjyvk17+NJApfRjBY2nJ50Ht7MFj0Mt9Nc
 RvcANV2Hfw5CWYGgF52KPf58f0DIBcx5qSTyz3t9oWeSeLKVo/t70CN
X-Developer-Key: i=gourry@gourry.net; a=ed25519;
 pk=BZWDlx4htkR5KcvGjGtSDfx1tM0E5dlyBR43FEhjWVc=
X-Endpoint-Received: by B4 Relay for gourry@gourry.net/20261120 with
 auth_id=1586
X-Original-From: "Gregory Price (Meta)" <gourry@gourry.net>
Reply-To: gourry@gourry.net
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 3A02714000D
X-Stat-Signature: nqq8xmrd5i5qbeay677k8xb51c83xjck
X-Rspam-User:
X-HE-Tag: 1795198258-60487
X-HE-Meta: U2FsdGVkX1+TTFCYxEkvy1k9t4weiGib9mD5PDQHxEbVvXwlQMbq7anjjVR9+WwUULnfX/eEaJfsYpnBsTKOdDNIjkl7PKMhX/LT1rR3l57JhId1bpMSi9mUu7oUSdjaf5hln5SycM0sMIAYJCgRjvaewJfqqHtYVU+smMgvEXd/Pv7wpOFub53z1XzbvZMl4o4QToI4Ehk86fyg7aapZWIWwlgvDSCxmqovHMuvQbGlLGXHdg292q6rXgcMIlUZr+uPVJn2lsJ97XUusqjkx/miDJ/RjNjnQUY7csGMz+I4ddgLJcJ3ssDAiZjuANHsUXwbjSUJKxvLKP6pAio9eukeQg2fp2KH3JBRgiWGrjIOTEC58P8wxhpPdgTmmQFX9SDZE/q1xscJ9r0wm3zJ6CUWGZVnGHZtnDE54JVT9rHmr7v9ti1mmNe9Juese+fUoz5Rk+wGtIE3JX1vDCCMuHRmZuVCShysu8K3FxHV1fGHmTFOo2OROF05SUOlxCb0fQtLwzYnKB1NSn93LH2grCtfbLiVGgei+XjiNvoSxhP8ouLqXrnH3Ci7SVIx2TtqQqh7eerSwonTowmtBhZ12y8NLZlNluPcKFwDIGByokBVUn4LxgqIq7EWGxwIwAgxgg6uwKUpraqiC5k1cC3Mr54F3ajhbJrNTJkRzo9RJ6ekJjRvkVNZ4GIYOBagxx9yD32Lv9vrgrZASFsySK7qqE/Q0xIXS5ro41uxKTUG1EVaYXTjKptzrthVoJxduwlJ4INp1BAbht46BOBCYdndKPxAk3F53esAykSXM1tze6TFjDG1SOhDwKD7ajyH8AUuhQH5VF0IXMt+0zE3feMmHEoQ8b7sU4yqidNs4YANLZzDVHFwByoK3xY2JAl4xXwOc9/nkPBHsWmebrM90AE9xH8IFXDxui4Yjo2MVp1etPTeSdQmqopqgIal1Tv2Cn7KivuGz+RW19/HpUr2BLb
 ZOsdqXHl
 c9hJUEm/YFmjZqD/4I+TA/2WxI6ptUH83krixrSpfguerDHp1dWE3zb1xtI/zPwoiirotj7ZlrHnqZeITTTrJNyGqaThNYii6s8U56E4HfJmZ2SkrsLtwpF4GuilAgIP2ytqs+cnY1xWSMVyZ3tdcNOT1/kisupPrGwn7XIr9MBaG66eDgPiYxLWIEd6H4L9gUenCQFnwEu7LwJKAkNEjbHS2wyacyJKWJQB1lmoKV151GyHsZbhlk34Wm18oRbPNZ4wbVbJX4wsPV+HMNtPEPVJkrScaty/AiMpdHqFBS0ovyY5EO/necFLAYq3E3HRs4LKn+BWSsF5SxvzKgO/GoK4G27XCjP0RY8PS7fK2NFC2qoLz0y3AO8SspIKRhgX+6zrwcmEcvvF5A5W50JrJgpwOiTMTsUJ2Aesz3CuxnSCUbVMTxut2UW1Du4PxHY6LYb/Gc8uj60h3w4boipRJWTB9JkXh1M0FeWgv4m5dPe3FKm4sNmbfUO/Tm3dQvYYUZwhElDa0LSaLMFWeK69AnxKwd3kGX+jzwBlJY4LNGZl3NB1H3O3piuuEjjxpwwUHOVGBDkndbEF5eyb2kb91o+oprLIPwH9kmRFQ3im8b50zd7HgJ59LlAC0/6PxEGOFC3xDaDBT+1PhQSrCcT6fx9Hf8V1zvOpFMjDRL1kI09dwyYeE8ppOTSnN/8xIvP8rtby0imX5DfATThWPT0GZAR0OfzDI9/+Mr/KMYmMU3Jkc0AKkbUILNSrRXqkhHxCXCzyWv9ui5o7cdtNuzcFqxziRBg02F+PtYs49cChW5pYBpr36POk3ApgWSsS/DACFazXY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: "Gregory Price (Meta)" <gourry@gourry.net>

Memory hotplug can make a node private after a bind policy naming it
was created. A static bind policy, a shared memory policy, or any bind
policy without cpusets is not rebound when the node's memory is
removed, so it still names the node when the node returns as private
memory.

The common zonelists hold no private node, so a policy naming only such
nodes leaves the allocation no zone to use. The nodemask still
intersects the cpuset, so check_retry_cpuset() keeps it, and a fault
through the policy is retried forever.

Let relax_private_alloc() treat a nodemask that names a private node
like a private request: once no node in the zonelist is in the nodemask
and allowed by the cpuset, drop the nodemask and allocate from common
memory. Only a request on the private zonelist keeps __GFP_THISNODE
strict.

Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
---
 mm/page_alloc.c | 31 +++++++++++++++++++------------
 1 file changed, 19 insertions(+), 12 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index ea48991ef589..b7339bc634d5 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -4078,16 +4078,20 @@ __alloc_pages_cpuset_fallback(gfp_t gfp_mask, unsigned int order,
 	return page;
 }
 
-/* A request on the private zonelist. */
+/* A private request, or a nodemask that names a private node. */
 static bool alloc_is_private(const struct alloc_context *ac)
 {
-	return ac->alloc_flags & ALLOC_ZONELIST_PRIVATE;
+	if (ac->alloc_flags & ALLOC_ZONELIST_PRIVATE)
+		return true;
+	return ac->nodemask &&
+	       nodes_intersects(*ac->nodemask, node_states[N_MEMORY_PRIVATE]);
 }
 
 /*
- * Whether a private request can still allocate: some node in its zonelist is
- * in its nodemask and allowed by the cpuset. Any zone type counts, so neither a
- * GFP zone restriction nor an exhausted node makes the request unsatisfiable.
+ * Whether a request that names private memory can still allocate: some node in
+ * its zonelist is in its nodemask and allowed by the cpuset. Any zone type
+ * counts, so neither a GFP zone restriction nor an exhausted node makes the
+ * request unsatisfiable.
  */
 static bool alloc_private_reachable(gfp_t gfp, const struct alloc_context *ac)
 {
@@ -4095,7 +4099,7 @@ static bool alloc_private_reachable(gfp_t gfp, const struct alloc_context *ac)
 	struct zone *zone;
 
 	/* A strict local private request keeps its allocation domain. */
-	if (gfp & __GFP_THISNODE)
+	if ((gfp & __GFP_THISNODE) && (ac->alloc_flags & ALLOC_ZONELIST_PRIVATE))
 		return true;
 
 	for_each_zone_zonelist_nodemask(zone, z, ac->zonelist, MAX_NR_ZONES - 1,
@@ -4819,10 +4823,11 @@ check_retry_cpuset(int cpuset_mems_cookie, struct alloc_context *ac)
 }
 
 /*
- * Relax a private request that can no longer allocate, because the cpuset
- * revoked its node or memory hotplug removed it. Drop the nodemask and allocate
- * from the common zonelist of the preferred node. Called after
- * check_retry_cpuset() and check_retry_zonelist() found no concurrent update.
+ * Relax a request that names private memory but can no longer allocate,
+ * because the cpuset revoked its node or memory hotplug removed it or made it
+ * private. Drop the nodemask and allocate from the common zonelist of the
+ * preferred node. Called after check_retry_cpuset() and check_retry_zonelist()
+ * found no concurrent update.
  */
 static bool relax_private_alloc(gfp_t gfp, struct alloc_context *ac)
 {
@@ -4830,8 +4835,10 @@ static bool relax_private_alloc(gfp_t gfp, struct alloc_context *ac)
 		return false;
 
 	ac->nodemask = NULL;
-	ac->alloc_flags &= ~ALLOC_ZONELIST_PRIVATE;
-	ac->zonelist = node_zonelist(ac->preferred_nid, gfp);
+	if (ac->alloc_flags & ALLOC_ZONELIST_PRIVATE) {
+		ac->alloc_flags &= ~ALLOC_ZONELIST_PRIVATE;
+		ac->zonelist = node_zonelist(ac->preferred_nid, gfp);
+	}
 	return true;
 }
 

-- 
2.56.1



