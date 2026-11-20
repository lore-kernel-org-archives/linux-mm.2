Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 461D260A2614
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 18:10:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XX3ZondX
Received: by kanga.kvack.org (Postfix)
	id DF3E26B05CA; Fri, 20 Nov 2026 13:10:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D2E906B05CC; Fri, 20 Nov 2026 13:10:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BA8686B05CD; Fri, 20 Nov 2026 13:10:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8D0D76B05CA
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 13:10:21 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1CD88A0157
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 18:10:21 +0000 (UTC)
X-FDA: 85456287042.07.CD5C656
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id D0EDAA000A
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 18:10:18 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XX3ZondX;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	spf=pass (imf25.hostedemail.com: domain of devnull+gourry.gourry.net@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+gourry.gourry.net@kernel.org
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795198219;
	b=H9C0nNeMLmoLoWaDdrfS2C+DuUloXcDjOM8vEDiRbRTKvjemXDpLKD+/dTFZIxD0tG1ICm
	RKwoMZ+9mavPpozDtVM+eAvZk7PXxb73s1NM/tOy7yvQipNwBqiac8eyVU9XL8mouXHbXP
	Om8DkGMns9Wkx5vEzbSRgAf6Zld1GTo=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795198219;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=n/y8cFqv5JK+fAMYg6fQX9qejZNWm1aFs/7S7bAs+zY=;
	b=eYj0ChiPUP5HsPdu3J3dnI3NUhR5mA/JSnjSAq2POFYF7PUjtiYN+/P/0j32V1JtJR3a5N
	l7FMOde+6GZghV7GI6N0rh1ql6/M0TDEqUL4JEbsBfGV1wlsNBTpvtFGzl2oiKWRjLRcvl
	dFQFXViJ9FJIoAKIQ0Kl+WABFSKnCD8=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XX3ZondX;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	spf=pass (imf25.hostedemail.com: domain of devnull+gourry.gourry.net@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+gourry.gourry.net@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D2A61414F7;
	Fri, 20 Nov 2026 18:10:17 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1795198217;
	b=3XNe5SChAzDl8VphtnrrC9VkT+stcyXuHQDhNRhTENRcmIp9QvHM2ziTXPajQeczBX72
	 rdQOiyOpBeHSuBj/1v8g0vN0V/bxvjxx0ieGQB86zStn2+ORaIjxOTA5SRfdh6XfrdSuv
	 Q7RjcVar48eAYYD1G15hFc/WG1g83GbrpsBnxV1HqblWIC7RWkvjqkYRrjYctzFKJGRAv
	 XyduNDT92R7r6lc3rv/lvcCtLx99I3/5rjVIWD2+9eg+/7k2xF4sSPGp64xi1WQN5OPtb
	 TV3dYr4RWc3lNjl/lumzkDNkkxeMXH2+ROFUOVuwvncNY6PD4hFEJ7DNp/u1VU5Lxow==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1795198217;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=n/y8cFqv5JK+fAMYg6fQX9qejZNWm1aFs/7S7bAs+zY=;
	b=IxKPk6/kCdqPL1/OUrHBOmn6NdLvKgPD7HF2XUossPO7i6Sk7yjhy5grpdpfv9EYOj5s
	 z5CPPq+MnYMIsencGmFcHTaXXVG0jE2V/Tt0KEbk81mxchbk26f4j03E3gUOlDbYPph2M
	 AdRo3zP6H9he1wpe1MUowf2u3yq3Mmur320QyOahjbS3DhFTlCMxrwgOYqyUOxVho1YHg
	 dCxaGd1aOIm3Ru9sdh9iizU/AgH1C0G0+7LAfaQEeFmhZT+FmpRr2DyIY4vgs9+AbhEld
	 lbVcrrb13rt1vm1j2yFV+UZRYht2DAHlnIlc7FvOxNErzmNNU3qpr5C2rDSWOVmCUvw==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 757071F00A3D;
	Fri, 20 Nov 2026 18:10:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795198217;
	bh=n/y8cFqv5JK+fAMYg6fQX9qejZNWm1aFs/7S7bAs+zY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=XX3ZondXrgxFVbEkemXzvCCyelD1KCzTxc4436sPLSJAueUyw23JfUp/ZPnC+pItp
	 V8DmjXSkUewNAyQflzujyge4Z/LKiJEvP+I0YSZUhYoYNg1An68TCbnai9QqeHpEZT
	 9ubFlt8RfKPs9wXERRFhLNtm34KdaTNjnAR/JSEzdBKAMK2Qp/Lxjh9UjpYycxTtrd
	 aVlrkwV4je2Pg7d/FiPfQM++/iVeFTn9xf+xnHsLrLz4gaTNCHAivgr2Y4GOIfrPc6
	 U7chrwkdzdHukYDU94eRT84bM8j5XqNbeKDSQdNDo+FeePWIa7sXGz1nkbah88+Uhh
	 gZv17WMjDGepw==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 087694B925;
	Fri, 20 Nov 2026 18:09:20 +0000 (UTC)
From: Gregory Price via B4 Relay <devnull+gourry.gourry.net@kernel.org>
Date: Fri, 20 Nov 2026 13:09:16 -0500
Subject: [PATCH 25/60] mm/mempolicy: queue only common memory for mbind()
 and migrate_pages()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261120-private_nodes_v6-v1-25-74f5f9a115c2@gourry.net>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795198153; l=1280;
 i=gourry@gourry.net; s=20261120; h=from:subject:message-id;
 bh=oVUBe3L0N9OzvHIPOvGNp++MFXvEPdYO7K5H5oP/xXo=;
 b=z0Yss6rDFAVA1N5nV8ud28CkhXRAlSaKlLr0ZvA0vfg/FyvOeTLlv0XfslsD2RQQ13WZutKr6
 BXIJh30hlb0DJUOedF94r7a7FARtG2gTQbcL8IzU8HufAGAAA6nYwet
X-Developer-Key: i=gourry@gourry.net; a=ed25519;
 pk=BZWDlx4htkR5KcvGjGtSDfx1tM0E5dlyBR43FEhjWVc=
X-Endpoint-Received: by B4 Relay for gourry@gourry.net/20261120 with
 auth_id=1586
X-Original-From: "Gregory Price (Meta)" <gourry@gourry.net>
Reply-To: gourry@gourry.net
Content-Transfer-Encoding: 7bit
X-Rspam-User:
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: D0EDAA000A
X-Stat-Signature: okq1k7p9c5tet66jb4w3yitcebzezhmp
X-HE-Tag: 1795198218-567314
X-HE-Meta: U2FsdGVkX1/p9gVRGcbKMiUV9FLGKGGY5NXV3ytBmStZsxksghVTNpxDdgPQ1VWGe8b+hvcMXHZIWNe5qS8aybwc9JauuGO+Pj6jHuaow/vsnCMyiCzb1UrfMoj3u0dsE6sV+eYHPPbMF3Eo+yWqx5UO+UrA5f62rIdbEmO/o+Rb9f7gdMi6/ohkYzZklwUEHGvWkXFdmW+yaSoK60sbxSs7LqXZJUt4j1tB2xRxlAlVii8+147nGXLAv7NPzTQZaZ35KHMO28Biv70KVgNuUZ7WYpzNDY/cM5VX7htm6ItynpShr9txtBpAasPEdPVqDe5IkOR2wEI8lnmEXmFYWcXUINdVX6oa04FD/FPsg2BmDwqJJW/0Vo++/Kx8/Zh1H6QppEwPTStmqK5WzUgcCmK2UgQnwOre29W3oCgNRozcYoMNhRItrCqBfMRxsipF4rL0fLe5RyQW7UoYc0bduzdMMjIVtWLzf3qYj2sdc6oSfcNOxna1xnTWTjy11CwoDEM/jHUueq0D5ktgj5I4exCfdpKyNMIC0Ns3piVk8xT4zAYeRLKXZXdVotJ//QMuHj06SAnb8Y1vZ0YqGwlW1ZV2pDbRpkw9G+xwefEQdt9HZLGmIc7XiuyuWsL60FIwg4FjoxksRovSM5y/qSwh/WN7UUY8WVNGOKI5680kju5vNlr54gsqs8RcMXsbUtftLXOtB6oAEcmHo+6RUdmuau79oxwK+SocN1mh0XoAGZyZDh42oR3ELEEncgisZ448KWIMGDu2KmG6uHhYdmoQfnZsC2Z7SuTMT2JiXKXrZsXDTlVoIhHlcfkpzAzSaLWuoPczT8izufay/kHZ5IqQcetcCgOpwuJ2pqXGPRu3L1uQsCmVe38SZdaXSVexW1UkNP4w422mUDT7r9brorrXCgVE6t7uNdhRwcbzKnefoKi+yx3C7e552I2V3dWvHWLc7qqfCzutrQwPx8nWYmj
 3ElnPt3s
 Sbx5BDlCSM9zMaeAMhTHRl425vAGUDSTfKFXhYObscKIXIBz+JDWHkJfHD5O2ALox6OXna/PgoZhOQYbs3UFuBscUB0anjJ1zESTVQhkfn57vVz3075AxWYHq2b3FOQll+43ZoN+//l0YXP1lSoapfwXR3nVsjJ2o9Q+/uDvPsCaOJUbeAsWhH6lZNvauFL07BYlNA8rm6CgB+oyz5gOnZK+TPkA9L9EGHWRRRm5JGxLPIf0Cjz8QpJCxbNIFCuCZE6pLhQy40+0zJuvM4J9fDfLXDp3qg/06QuXVoW9A7+x9fMToPB/keBDVVPGZLU4esPHit+81ET/MWAQ6eZK43kDvZXrx0U9xNnBZlG9yQg6uQGLzyBqViIqdzRRRaOG2qQyw86bOH6uoLH0oJiAE7UEFW3xHkQMLqptRsnNvoeDkfpNTSrhOHWUb3jyVw3CPJkabEC8d3VcfvvIwtHPoPdi5o8zr74JWrBI53kiUK0F2VNOscjOU8b2fHrnRPz08UXKmLDGv3E/8dVyAHcSffMi3ZucOpWEWqK7zKzC2rps6J9UBxVr9jQ3X1kzEdWpZ+sUoFIPRBjOOHT6SgzBcPSe525d/5wqloY9HEj4857W9EsoYq66pi+yPyv4OWI3c71s54mm2lfSKTt252iPrxjv2t66kqBD7NHXTZgiQ2cx/CvqdFWf7Gz/wJqeSENeU6XlmnG5pCZOnXtclvU2QtDLtIRfiFmv1lceMYKnRm2ZQ0LTPJXzLZZAZ39mPErW5gI4yA+QI1hP1M/epXdwjaheINr2UQfp2lidBob/UPKxnNSJZtPNHnwO/9a2cyP+lgLLb
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: "Gregory Price (Meta)" <gourry@gourry.net>

mbind(MPOL_MF_MOVE) and migrate_pages() queue folios from a task's
mappings for migration.

Queue only folios on common memory: convert the ZONE_DEVICE checks to
folio_is_common_memory(). As with ZONE_DEVICE folios, the skipped folios
do not count as failures, so MPOL_MF_STRICT does not report them.

Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
---
 mm/mempolicy.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 07d577aca78c..e208018499d6 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -687,7 +687,7 @@ static void queue_folios_pmd(pmd_t *pmd, unsigned long addr,
 		return;
 	}
 	folio = vm_normal_folio_pmd(walk->vma, addr, pmdval);
-	if (!folio || folio_is_zone_device(folio))
+	if (!folio || !folio_is_common_memory(folio))
 		return;
 	if (!queue_folio_required(folio, qp))
 		return;
@@ -745,7 +745,7 @@ static int queue_folios_pte_range(pmd_t *pmd, unsigned long addr,
 			continue;
 		}
 		folio = vm_normal_folio(vma, addr, ptent);
-		if (!folio || folio_is_zone_device(folio))
+		if (!folio || !folio_is_common_memory(folio))
 			continue;
 		if (folio_test_large(folio) && max_nr != 1)
 			nr = folio_pte_batch(folio, pte, ptent, max_nr);

-- 
2.56.1



