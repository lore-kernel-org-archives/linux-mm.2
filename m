Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0EFBD606B9B9
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 18:13:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AYDepuBI
Received: by kanga.kvack.org (Postfix)
	id D325A6B05FB; Fri, 20 Nov 2026 13:11:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CBDE36B05FC; Fri, 20 Nov 2026 13:11:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B5C326B05FD; Fri, 20 Nov 2026 13:11:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6366F6B05FC
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 13:11:30 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D05AD40140
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 18:11:29 +0000 (UTC)
X-FDA: 85456289898.05.0090344
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id B68CA8000C
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 18:11:27 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AYDepuBI;
	spf=pass (imf30.hostedemail.com: domain of devnull+gourry.gourry.net@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+gourry.gourry.net@kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795198287;
	b=6LUZYQYKKSv3wlsaW9bJ+S9K4nZCE2pEpGQ+CIZpqxfA2szRvUZEep2t+zK60uI4ZXodmp
	dOkZsvlUewOy3rsUFqC0RVjzu1uJrL8FDAMmR2KVcUin98s6nVfZT3Dw/OryWksLbasWUD
	Bnjkz6zd4qcXQgW8XQkShkdZWDd1zIc=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795198287;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FeMVQLv7GLlhS6IUX7kRUUhFVa1pXNLb+geY1fYUbs4=;
	b=D/s7UtxlfzsM+DbdME6YgYSKnPjC8zFNtpUQ8bjiuh2Bc24UQkLZcWUTXVrZKUyO8M8QXT
	kjs0yoqia4YII/XROZdnBG6yVK2tS3lmDhhkWKW7B6DkYqJMTBEnyX/b4H0t6CeDFfelMS
	Pz+woWmefG7p1TSNG5h7t8Eh0uhzfxU=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AYDepuBI;
	spf=pass (imf30.hostedemail.com: domain of devnull+gourry.gourry.net@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+gourry.gourry.net@kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3FE1A63496;
	Fri, 20 Nov 2026 18:11:27 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1795198286;
	b=QiY6q3DZML2mGCy6vjhBvjNMdHDQRvVlPBi563FEOlsmsRrf3bfV0zyMk/RCXj7Kt8WS
	 tMlwiXlXjOtN34agcv7ceWbNc56LoKA7LDxaXbMhiAHNJmty2n8+hplDDTbArtPD0k3mk
	 4TronGz8qDdiPXqPGWayfHcbG6PiPxZBlpTmVcShLSkvsmUU+dciXSMML5p55UWYqAcis
	 XhM3wb3B3A94CEsvl0+6k8oci+gwBJlrmeWajCX/6weupb7WmBVaxqFlt6ePwsKKLgmRs
	 0aMWP0XqTA7ahgHF0WWXpWMbtafdBqgqFWk+sJ3pn8dIKuVYM9P2lTR5fMjs+W1mOcw==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1795198286;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=FeMVQLv7GLlhS6IUX7kRUUhFVa1pXNLb+geY1fYUbs4=;
	b=FRC0mQpJpHDhDC8TvYHMbKy0iCjxWrhYDoqiUHQUJDxhsVNyi5t0/01uBeKpqgvz3C6s
	 AIuT/4BnY+SRlgxFBN3uZh5l5Ov58wUEUDLRPqudv9LTz3bZ7sSkVWPsAEIKPRnV29Gjk
	 3gqTAUq2fsSWczLEiQTinh9XCnQivWH9ARwHWU5AKPxx6zkJBLQ1Tm/AnyFVfEnVuzxTT
	 DmKLOPgsSWBClInyDzk/76Je2sTAEXm4T8abkxT0sYKShbxhHjtQlPWD2igTY/xEu9AwN
	 Xo7zb33GyuLOFJTMDXIAM7JHdgJLE/LljjvvjebuVDIeUBF2AUYyXIoRN4GWNemecAA==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 3F9C61F000F4;
	Fri, 20 Nov 2026 18:11:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795198286;
	bh=FeMVQLv7GLlhS6IUX7kRUUhFVa1pXNLb+geY1fYUbs4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=AYDepuBIJQc9oFfAnEENBLj3OIfBMGcU7YubEbIE5I4fY9gJQgLUNdpoaBZhp74Yd
	 xQAHP6KsZh9peWqr/XXyhaE4Qp6JJNUej06k4VJCJxK72sTJkZGMojm+DxFy1/mn1Y
	 9WQUksA/ccfLjYFlBJzmzPXlgkXpVJlINcH+6GwTblNsNQQuscJiXmVvqyBHkNogYB
	 yvEUjlPD5mcXlWJ5rXopugG7M4MjRrB8T3WzP4ykVv8av7qZ+JEidyaY+koLjteZYU
	 K4lbl9MkVw6uwGReaVBzQQXGA8XTITPMuiQJjsyrHddyedTrUSME6VcRUf/FJPB0UA
	 ryK8eQPgCS6Cg==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id B5C804B99C;
	Fri, 20 Nov 2026 18:09:23 +0000 (UTC)
From: Gregory Price via B4 Relay <devnull+gourry.gourry.net@kernel.org>
Date: Fri, 20 Nov 2026 13:09:46 -0500
Subject: [PATCH 55/60] mm/memory_hotplug: online and offline private memory
 nodes
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261120-private_nodes_v6-v1-55-74f5f9a115c2@gourry.net>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795198154; l=9476;
 i=gourry@gourry.net; s=20261120; h=from:subject:message-id;
 bh=b3jGnnyWNDUyPQKsXIBVFwBX7ofSFROdnSCpZbbkWAM=;
 b=dURyeucqjPXkJcCpnAWMuH39xYYU9Sy7XUOxE2r8Wwzbf7ANdiCKotrRObSTQ40QuJ0Zf1HzK
 SNlKPBgabacDKodij1dmaphP8727fp4GMxD4DcXEnSyqnVu+FgJGUPW
X-Developer-Key: i=gourry@gourry.net; a=ed25519;
 pk=BZWDlx4htkR5KcvGjGtSDfx1tM0E5dlyBR43FEhjWVc=
X-Endpoint-Received: by B4 Relay for gourry@gourry.net/20261120 with
 auth_id=1586
X-Original-From: "Gregory Price (Meta)" <gourry@gourry.net>
Reply-To: gourry@gourry.net
Content-Transfer-Encoding: 7bit
X-Rspam-User:
X-Rspamd-Queue-Id: B68CA8000C
X-Stat-Signature: fxecyuegi1mzpih4wpenrscr18zj9784
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795198287-826983
X-HE-Meta: U2FsdGVkX1/z41EdSYzD8Zxsj7zcPhS/PQvGYSrJijGjiPqHMRmJZZ7JUGOtKAvy4pVlm4xBTEJLxC0RzEgXE3auJM5FYNGt8ms9yUOfU4uCJyQS3sFunMVmxNy4XJAWQHfOsEYdCf2vshoGJY5vR3k3rXfndULYB2cNi41V+k8k9uO+xIwh/4Bpz3PWogVSulzZY+LHbjv/2i07jGhyZ2u/E3OMAHFQyUzCGmetnK93kdRh7LdZelDNRrMiE5VdUesyiTeRZCto1MYaEtLGZbyC3eqLWQyoQKn5Hb8ScPqEmx9sA4+k2RS+kLVdxaW5RTKZxWBcd/QbZqfARUg43FfH+Wj4Xv6fh7HTOTXGsMc8Me31DDaWCnmJPp5fHDJh8/59jp+rlxWH70mc0bCS6LrnNkyr6jxkKWfuDK6Dho+I00nEu3NkpqgHsI5Tt/FFntnxY/N5Rmw/PJlVXrziXSUzvQ8/SoSj0l2tLN0UeZTHNPJ6wwbmMqAnYfCjsne7w8JRkX65ASoEFrMD2qeBF3vcrb2GcTreW+0qV/YHWKfkFpAmGOHAtWCKZMsdBDjCQxnivFP4D3XFEVxJ0iFVij7V8umFcc39ZgtehTr3YDqKdFGhCmTxL1p5Ll1RZsVSjzjq+25RLX+x0Qs/dYih+6UGAULFmNxdvMjpykdcHXmjtUbRhv1cuhjCoExnXXpLklQQ7ZM3llKU7yCazSkS051Ydqewcyrh5Z5XFE7N0gA45fZwXEaTSJHpbFj+x4d4GbEJty5f902HL+PQ336b08QYWTXWJLXt2MPnqzZX9+x1Tv6XkU5rigkRPipYNDGVUViLwFH2LMZz8hROB7oG/9+AcWikE/0ang2kJS9VwJDNkZQzv7kfufa3uS6AiLXQAH+L/vvS9juPMB7kY11/N1n2orgpitsfJcC3U/e6zqiUP55fzAaB9sZ+6Ltpb9gjcvH72MW47G+7p7R49Yg
 wRUx/2fV
 dHbYvfIIfcemWUxNmlN/T657ONWeu+aUf1M5/Nsa2qpQahUTK93JocIf5UbaAo+xWjEG3r6fQvc8l1lWPBe/dhd6DoO4SIeohlVDma/ej1YjsthqeDKWXngvitEl0oxWn38T5YvtIghem+mELj5XeUStsXAK1NIc71kmt6eolzlHCBjs9FCciWbxdIAmXs9LnnSkQolII1tcM4OkIuPUYWUldgFQ0r7FXzD6bFqnHJhvdAhnL9IL2Z7qqZuUdJR/1wBVFRhkNEVh/1X+J3/rklaAH+aNZfvO8JdMAKYqul9zOQEScy6Fj8whPa2TWcHZzsootiUoqMIY0bR2h22kFme/bGcYYpAYP9Wol5GwywWcfC6S3ZCHUv/C5v4s9yKP8vbKPnBRYRqlK3ZHjoKmYXdrNnu3Q6bu1fzYa6Atk9MJNGgwsjHgdkWeIbf+JFpPlU6mym46JzSWJlBQbNsGBk29cb3iAH1ukq00szlRA4NEJen6uYQaZhtv3Hr8G/p/14vn9CkIq2ne6yRe3Ya3jl73NbvasKsPqEXLZkwKTrejOb8ophxy7rqiZe2yyLUDyagJqn9OQWW71+q6aGkA6RAXx1B3GrJ5tQrQ4nyKacTOqW2poQd4x6HR0wChKoulHYBkiUPlD9R2uEvJjJGVIqnUHbKSGchcQH4QlYkpLEn9mnYig9zhNibE0YakCbMVHc9tT84v6Z832AdpbglC8Q5mIj3l5Y6Zee01ZkYNzElDpQYZye3WlHExGbWhXltgcempFZ31E5jnkSJiTCZsBMdk4RZEsQEQxbFrPUUxN4wlpUKscya9AKvsn/w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: "Gregory Price (Meta)" <gourry@gourry.net>

Allow a driver to hotplug memory onto a private node at runtime.

Pass a feature mask through driver-managed hotplug, and reject masks
that node_memory_features_valid() refuses.

Memory joins a node only with the same mask. The node's features hold
while any System RAM block remains (including offline blocks), and are
reset after the last one is removed, even when ZONE_DEVICE memory keeps
the node alive.

dax/kmem and the other hotplug callers pass NODE_MEMORY_FEAT_ALL, which
registers the node as N_MEMORY_COMMON.

Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
---
 drivers/dax/kmem.c             |  2 +-
 include/linux/memory_hotplug.h |  2 +-
 mm/internal.h                  |  9 ++++
 mm/memory_hotplug.c            | 94 +++++++++++++++++++++++++++++++-----------
 4 files changed, 80 insertions(+), 27 deletions(-)

diff --git a/drivers/dax/kmem.c b/drivers/dax/kmem.c
index a48d699cf344..5ec653bc88f0 100644
--- a/drivers/dax/kmem.c
+++ b/drivers/dax/kmem.c
@@ -126,7 +126,7 @@ static int dax_kmem_do_hotplug(struct dev_dax *dev_dax,
 		 */
 		rc = __add_memory_driver_managed(data->mgid, range.start,
 				range_len(&range), kmem_name, mhp_flags,
-				online_type);
+				online_type, NODE_MEMORY_FEAT_ALL);
 
 		if (rc) {
 			dev_warn(dev, "mapping%d: %#llx-%#llx memory add failed\n",
diff --git a/include/linux/memory_hotplug.h b/include/linux/memory_hotplug.h
index ec71debc0673..ae6046510958 100644
--- a/include/linux/memory_hotplug.h
+++ b/include/linux/memory_hotplug.h
@@ -304,7 +304,7 @@ extern int add_memory_resource(int nid, struct resource *resource,
 			       mhp_t mhp_flags);
 int __add_memory_driver_managed(int nid, u64 start, u64 size,
 				const char *resource_name, mhp_t mhp_flags,
-				enum mmop online_type);
+				enum mmop online_type, unsigned long features);
 extern int add_memory_driver_managed(int nid, u64 start, u64 size,
 				     const char *resource_name,
 				     mhp_t mhp_flags);
diff --git a/mm/internal.h b/mm/internal.h
index 646efc2eacd1..0eefa0df1350 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -65,6 +65,15 @@ void folio_mark_lazyfree(struct folio *folio);
 void node_set_memory_state(int nid, unsigned long features);
 void node_clear_memory_state(int nid);
 
+#ifdef CONFIG_MEMORY_HOTPLUG
+bool can_claim_node_memory(int nid, unsigned long features);
+#else
+static inline bool can_claim_node_memory(int nid, unsigned long features)
+{
+	return false;
+}
+#endif
+
 /*
  * Common memory is available to generic MM services. ZONE_DEVICE folios do
  * not qualify even when their NUMA node is common.
diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index 8146f77919d5..37e64c146b46 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -1494,6 +1494,43 @@ static int create_altmaps_and_memory_blocks(int nid, struct memory_group *group,
 	return ret;
 }
 
+static int check_no_memblock_for_node_cb(struct memory_block *mem, void *arg)
+{
+	int nid = *(int *)arg;
+
+	/*
+	 * If a memory block belongs to multiple nodes, the stored nid is not
+	 * reliable. However, such blocks are always online (e.g., cannot get
+	 * offlined) and, therefore, are still spanned by the node.
+	 */
+	return mem->nid == nid ? -EEXIST : 0;
+}
+
+/* Caller must hold the memory hotplug lock for these checks. */
+static bool node_has_memory_blocks(int nid)
+{
+	return for_each_memory_block(&nid, check_no_memblock_for_node_cb);
+}
+
+static bool node_has_system_ram(int nid)
+{
+	/* Mixed-node memory blocks are always online and covered by N_MEMORY. */
+	return node_state(nid, N_MEMORY) || node_has_memory_blocks(nid);
+}
+
+/*
+ * Whether memory with @features may join @nid. Offline System RAM blocks keep
+ * the node's features until the last block is removed.
+ */
+bool can_claim_node_memory(int nid, unsigned long features)
+{
+	pg_data_t *pgdat = NODE_DATA(nid);
+
+	if (pgdat->memory_features == features)
+		return true;
+	return !node_has_system_ram(nid);
+}
+
 /*
  * NOTE: The caller must call lock_device_hotplug() to serialize hotplug
  * and online/offline operations (triggered e.g. by sysfs).
@@ -1501,11 +1538,12 @@ static int create_altmaps_and_memory_blocks(int nid, struct memory_group *group,
  * we are OK calling __meminit stuff here - we have CONFIG_MEMORY_HOTPLUG
  */
 static int __add_memory_resource(int nid, struct resource *res, mhp_t mhp_flags,
-				 enum mmop online_type)
+				 enum mmop online_type, unsigned long features)
 {
 	struct mhp_params params = { .pgprot = pgprot_mhp(PAGE_KERNEL) };
 	enum memblock_flags memblock_flags = MEMBLOCK_NONE;
 	struct memory_group *group = NULL;
+	unsigned long old_features;
 	u64 start, size;
 	bool new_node = false;
 	int ret;
@@ -1528,6 +1566,8 @@ static int __add_memory_resource(int nid, struct resource *res, mhp_t mhp_flags,
 		WARN(1, "node %d was absent from the node_possible_map\n", nid);
 		return -EINVAL;
 	}
+	if (!node_memory_features_valid(features))
+		return -EINVAL;
 
 	mem_hotplug_begin();
 
@@ -1552,6 +1592,14 @@ static int __add_memory_resource(int nid, struct resource *res, mhp_t mhp_flags,
 		new_node = true;
 	}
 
+	old_features = NODE_DATA(nid)->memory_features;
+	if (!can_claim_node_memory(nid, features)) {
+		ret = -EBUSY;
+		goto error;
+	}
+	/* Set the node's features before onlining its memory. */
+	WRITE_ONCE(NODE_DATA(nid)->memory_features, features);
+
 	/*
 	 * Self hosted memmap array
 	 */
@@ -1597,6 +1645,8 @@ static int __add_memory_resource(int nid, struct resource *res, mhp_t mhp_flags,
 
 	return ret;
 error:
+	/* Restore the previous features while holding the lock. */
+	WRITE_ONCE(NODE_DATA(nid)->memory_features, old_features);
 	if (new_node) {
 		node_set_offline(nid);
 		unregister_node(nid);
@@ -1612,7 +1662,8 @@ static int __add_memory_resource(int nid, struct resource *res, mhp_t mhp_flags,
 int add_memory_resource(int nid, struct resource *res, mhp_t mhp_flags)
 {
 	return __add_memory_resource(nid, res, mhp_flags,
-				     mhp_get_default_online_type());
+				     mhp_get_default_online_type(),
+				     NODE_MEMORY_FEAT_ALL);
 }
 
 /* requires device_hotplug_lock, see __add_memory_resource() */
@@ -1651,6 +1702,9 @@ EXPORT_SYMBOL_GPL(add_memory);
  * @resource_name: Resource name in format "System RAM ($DRIVER)"
  * @mhp_flags: Memory hotplug flags
  * @online_type: Auto-Online behavior (offline, online, kernel, movable)
+ * @features: NODE_MEMORY_FEAT_* services the memory opts into;
+ *            %NODE_MEMORY_FEAT_ALL adds it as ordinary common system RAM,
+ *            and a mask without %NODE_MEMORY_FEAT_COMMON as private memory.
  *
  * Add special, driver-managed memory to the system as system RAM. Such
  * memory is not exposed via the raw firmware-provided memmap as system
@@ -1677,7 +1731,7 @@ EXPORT_SYMBOL_GPL(add_memory);
  */
 int __add_memory_driver_managed(int nid, u64 start, u64 size,
 		const char *resource_name, mhp_t mhp_flags,
-		enum mmop online_type)
+		enum mmop online_type, unsigned long features)
 {
 	struct resource *res;
 	int rc;
@@ -1698,7 +1752,7 @@ int __add_memory_driver_managed(int nid, u64 start, u64 size,
 		goto out_unlock;
 	}
 
-	rc = __add_memory_resource(nid, res, mhp_flags, online_type);
+	rc = __add_memory_resource(nid, res, mhp_flags, online_type, features);
 	if (rc < 0)
 		release_memory_resource(res);
 
@@ -1727,8 +1781,8 @@ int add_memory_driver_managed(int nid, u64 start, u64 size,
 			      const char *resource_name, mhp_t mhp_flags)
 {
 	return __add_memory_driver_managed(nid, start, size, resource_name,
-			mhp_flags,
-			mhp_get_default_online_type());
+			mhp_flags, mhp_get_default_online_type(),
+			NODE_MEMORY_FEAT_ALL);
 }
 EXPORT_SYMBOL_GPL(add_memory_driver_managed);
 
@@ -1789,18 +1843,6 @@ bool mhp_range_allowed(u64 start, u64 size, bool need_mapping)
 
 #ifdef CONFIG_MEMORY_HOTREMOVE
 
-static int check_no_memblock_for_node_cb(struct memory_block *mem, void *arg)
-{
-	int nid = *(int *)arg;
-
-	/*
-	 * If a memory block belongs to multiple nodes, the stored nid is not
-	 * reliable. However, such blocks are always online (e.g., cannot get
-	 * offlined) and, therefore, are still spanned by the node.
-	 */
-	return mem->nid == nid ? -EEXIST : 0;
-}
-
 /* Caller must hold the memory hotplug lock for this check. */
 static bool node_is_memoryless(int nid)
 {
@@ -1811,12 +1853,9 @@ static bool node_is_memoryless(int nid)
 	 */
 	if (node_spanned_pages(nid))
 		return false;
-	/*
-	 * Offline memory blocks may not be spanned by the node yet, but they
-	 * link to it in sysfs and can be onlined later, so the node is not
-	 * memoryless while any remain.
-	 */
-	return !for_each_memory_block(&nid, check_no_memblock_for_node_cb);
+
+	/* Offline memory blocks keep the node alive so they can be onlined. */
+	return !node_has_memory_blocks(nid);
 }
 
 /*
@@ -2347,8 +2386,13 @@ static int try_remove_memory(u64 start, u64 size)
 
 	release_mem_region_adjustable(start, size);
 
-	if (nid != NUMA_NO_NODE)
+	if (nid != NUMA_NO_NODE) {
+		/* No System RAM left: reset the node's features. */
+		if (!node_has_system_ram(nid))
+			WRITE_ONCE(NODE_DATA(nid)->memory_features,
+				   NODE_MEMORY_FEAT_ALL);
 		try_offline_node(nid);
+	}
 
 	mem_hotplug_done();
 	return 0;

-- 
2.56.1



