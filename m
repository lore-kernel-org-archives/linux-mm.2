Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 96A1EC61DD3
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 07:51:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 997536B008C; Thu,  3 Sep 2026 03:51:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 948306B0092; Thu,  3 Sep 2026 03:51:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 85E936B0095; Thu,  3 Sep 2026 03:51:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5B8B86B008C
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 03:51:15 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id DA591160423
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 07:51:14 +0000 (UTC)
X-FDA: 85171680468.05.E5A19AF
Received: from mail-pj2-f7.google.com (mail-pj2-f7.google.com [74.125.227.135])
	by imf23.hostedemail.com (Postfix) with ESMTP id 20ADF14000B
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 07:51:12 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=eKgZSF5x;
	spf=pass (imf23.hostedemail.com: domain of jinmengzhou22@gmail.com designates 74.125.227.135 as permitted sender) smtp.mailfrom=jinmengzhou22@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788421873;
	b=41aQ4/HWfJ5ZU8ufPHgilQSv9hbexlZpHbbGhDwKCt3dPzX4ruQ2JeYZgEdUdJLD+jMd68
	wDReGW48KtBFW4AiYRzVYCz2zhOAUMRGHRQSHxq4uyinjYYtPYwdG8KwkFECUSjo1ceCGM
	Mpo5C2SyD/tlQOtLAH4R9Xae/zndTAE=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=eKgZSF5x;
	spf=pass (imf23.hostedemail.com: domain of jinmengzhou22@gmail.com designates 74.125.227.135 as permitted sender) smtp.mailfrom=jinmengzhou22@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788421873;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=ICN4jGrb/nR91jjnghtKbxqLBDgDgvVDNKC+0blsog0=;
	b=lAf0Ze/mdKJMJVpvALEWmVZeYruGlePlN2cDH88e6CQ4QEPrAEQgqCFdXXRmgC0lFKTrWi
	yZML5uy6dBkqhpNAmcj4VJpUdoqoh2XLe5mQnceZEyscma67gKKPBChTuqEVHWWa+ja59l
	UjlwtYEbq1Ww1Aw+C8XOt4TTSy3SxhA=
Received: by mail-pj2-f7.google.com with SMTP id 98e67ed59e1d1-398e03cc38aso892980a91.0
        for <linux-mm@kvack.org>; Thu, 03 Sep 2026 00:51:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788421872; x=1789026672; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=ICN4jGrb/nR91jjnghtKbxqLBDgDgvVDNKC+0blsog0=;
        b=eKgZSF5xtk2rm4xq5pasT4eXg2fCkB2iKdrv+iFRQkm5indoWqtH4wHTi6Wgld0/8X
         ENlW/HuwkPW+gNRPHvbtC8dd1KXaxU0ZzdSF/kXCChMLsN5+SdXHXJ82uxg4CkweKAVy
         i62tvo1NPF5ItNr+Ds+nRvZnBdz8E8CjkUqWLPh/OF/xQMPZ2ZhsPeVxA8TX/V0cAaia
         1FlZAv5G7pfu+Ml38vZNIAFSwwvmxxZiNAFaGlIjLlqp4bVzB8IRIijYzJsUHXntHmK8
         yv5M6PU8n8LNBwWov3dDIarFy2wWfGZzONrApI7EO+kkkDE1fENagFqJPoL9Wf2jcmJ3
         hgfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788421872; x=1789026672;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ICN4jGrb/nR91jjnghtKbxqLBDgDgvVDNKC+0blsog0=;
        b=FdHDc94/y0jaJADRRd575eea38g63+CNCBeEixJ8yMj0gkNLt3F2w5donPZTTkbFuL
         4idtViOvnf9lH5cnh8zPaSsW52fCrKHcKZbM9PKx/b0g7ly2thR80Ho2WTmk4z9dToWs
         EoXrsRBzp67tvjtQf17ZhPcY8D5q/bKlw1FSOQqLQyUPswBmqyMJw/IZStG0x738zstd
         eOP0JOvRpnzuFGGW40WJe9texVAO0MEdcmRWTaGKeHj6xibgnFXMvqQ+4zjaTuwqOcJE
         Gb7bnfitccbEPXEfAtGO2c5PTNfesp49OER+KCTB3fXv48RhhCvPk7deKTkqFUqUqZWu
         zpxw==
X-Gm-Message-State: AFuF++m447U08Uq7+03UGFCHWyjDl+GN/ZkRmaSxyN5PFBMnvD8ni7hp
	9zlytXWzw2cf6wS0MDGbPy6elO+WSeBByUmRwgYbHLMCyrphdHlg5/Cf
X-Gm-Gg: AYBFou0J8NxuAZ6CM9XewisA2WQhEAMEAcR7xCBbbjiINZ6mNvkJpyCGm+6PlZTdSmz
	gRBc7A0cWxWUyVm6cP1GwhGf3VfsrSZ/nAlnHT0jN9vzlP6Zgj6zMd79DUh4Axvx+zdKi7WEBja
	R6Z/vwmiydroCmmtPLGBbrZWVh3awn1ed/Jc8eGJ6QXWvou9PymmQIQ2dMPd7ixaR5sfcN8HKZK
	8HC++3zttL5TqRBmtidbuvM4WCQEWY+heYo9CwUSPi6cxzmH/oMl4ExOmN0Q2JMJ7s64NYPrgUb
	43Zu0IVss5VNVKR4XtuWdl0oEBuRPlcK5YJe72el5n+aX12Q+lVnKMX91piXagGM9/1qiyR55Av
	uRwVhg9fdbIm07vlMogM6vDZ+4GhIv3v25gHj320vs8MezXCwnKS2btejWaSOp75ky6j/KHNo6F
	OPwZuv8ldgpmeHzrodiRiIeHX8wc7F4n7K7bBXYxFjtWek90IRcpoZL2Y2v3xqRa4u7acs3ah/P
	2gRcVZaDAPoHIy8t5uaTxw=
X-Received: by 2002:a17:90b:280a:b0:38e:250b:122f with SMTP id 98e67ed59e1d1-39aee085053mr15681059a91.16.1788421871755;
        Thu, 03 Sep 2026 00:51:11 -0700 (PDT)
Received: from HXDQXTDYHN.bytedance.net ([63.216.146.178])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39b083e6e3asm4021341a91.2.2026.09.03.00.51.05
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 03 Sep 2026 00:51:10 -0700 (PDT)
From: Jinmeng Zhou <jinmengzhou22@gmail.com>
X-Google-Original-From: Jinmeng Zhou <zhoujinmeng@bytedance.com>
To: Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Nhat Pham <nphamcs@gmail.com>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	Jinmeng Zhou <zhoujinmeng@bytedance.com>,
	stable@vger.kernel.org
Subject: [PATCH] mm/hugetlb: charge folios to the target mm's memcg
Date: Thu,  3 Sep 2026 15:50:48 +0800
Message-Id: <20260903075048.3316-1-zhoujinmeng@bytedance.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: yy3rypcx4ye7e7beyxz1ook4r49zcmsj
X-Rspamd-Queue-Id: 20ADF14000B
X-Rspamd-Server: rspam06
X-HE-Tag: 1788421872-950796
X-HE-Meta: U2FsdGVkX18dxHnrsZjUqCtfkH0sAvstuG2RiYef14gjSBxXbH21cU/RWq4DX0d2XeGqcngjzGoP31UZ/jhdCEqC8/YHIwJWBMpgydoOy7Kw8psqlhaOT0M2mAcsiq6UzbWS8LJWURAigaktGdDvpGxSeh6/2zwZHLz3oea2S/3efQ4gxmFHoUi4U2POV88Wl08nFe9AONYgjx+xi7mO+Zk04EZV2750ohjp36wqLGNQpKh3G9QB01YChCYhUS+ZkB8pupdR5qRnuA3oenaHxH9OQhk7wkIT06vieq7K60Sw4RIONrnywPoUrFHMUb+9mg6tDIdufvzLG0GrPmhL9kiO2R6Pez1hqQjx96cDzpdD1rOiJVRz9lNZlO1/QnmB4OBjQt1D6YM6SmLDW/mqDjixA1MvQDkK9/g1KNPyBV+1fn6lc2prQyjIkqGbLuSgQC0Uft1Ij4hNt6dKGILi4SRzY7irWxChVnufO2v9ULPhJ+k2gVDgmOky9Vc7b4C+20fBFhpMphY/bFA4PcuLZ9J5GPPNxiH/Owmn2VUKM+q4YDofuw7HF6kond3IvUvoKbA9ao0eB899eZfhTmmYqRvVKMRRxSxRASBTN70nTkYEa/kTAyUDQuCAJalgz2mD0TNz6C2ZPAVreXIXE9Uz6PCya0wkSw/L3jjMiWTDkkQrzTLS3BKY2/1nq+8KjKNConfsYfnMd+S7P+iy3WJHvLjnRRJVvKP+nvbU0W6YfLAuI9BDzgPdIcbIF36T8COhtfPUYqpl2Z8WuJV1c/XmXbmR3Vw5l2bdiKEv8bcsZHIhGrm2v4lfOm4VKYtjuaWhTd97wr3KqW0bApDdIqumduitCAXAGe2MbWCFrGHGkr7l/29Moqc2pmEdLslC6VILOIt+wAmeBw8Ovsr8kYQv/NCs8G8AXuEgNlU4fH7JjLII1QLPzScXtit8yf8c7/M7JYuD/ytR+k152ewByVe
 aG8vuZX6
 AuA1SSwfsISHd0cAq0zYQUWbC4gf/kL2FTb6FM40ZGUJFLx3qtjHQzj3LLfQrhp15nsbRQiasF9G7aAE4c5PQczGQrq6QhSXUbSvG+yJVCMjFWWzlfp9YU9H9qsbnlW3b4+y593N4n+CMOggHdE5UxrbjXmYWVb/CwQeqgZxlYvTrGKu9cuyAplK19IL94oG5i0JpShHWGYAWKTk1z10oBom3hnwGYTj4m/e/6qB5CxK9rV/H8Wt522Z80WQw8yZV5QITV6zacYJpaKBaow3LuB+eCII9ifKKx842X6JZ/sxaBA+TnmVbprtSdjkI02CMG7tt/bM4Yo1lYqsSf6F52PDym5v4A8D10eYTPjYViKEdG4EwEUnz691jMTzLwMmPJyFi+Fs/ir981qx3gCaX5GI9Lw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

HugeTLB folios are currently charged to the memcg of the allocating
task.  This gives the wrong result when a userfaultfd handler populates a
HugeTLB VMA that belongs to another process.  The UFFDIO_COPY ioctl
operates on the userfaultfd context's mm, but get_mem_cgroup_from_current()
charges the folio to the handler's memcg instead.

This can be reproduced by placing the faulting process and its userfaultfd
handler in different memory cgroups.  Have the target process register a
HugeTLB mapping with userfaultfd, trigger a missing fault, and let the
handler resolve it with UFFDIO_COPY.  The hugepage usage is then reported
in the handler's memory.current instead of the target's.

The generic userfaultfd population path avoids this problem by charging
folios to dst_vma->vm_mm.

Pass the target mm through hugetlb_alloc_folio() and charge the folio by
using get_mem_cgroup_from_mm().  This preserves the existing charge timing
and error handling while making HugeTLB userfaultfd population consistent
with the generic path.

Fixes: 8cba9576df60 ("hugetlb: memcg: account hugetlb-backed memory in memory controller")
Cc: stable@vger.kernel.org
Signed-off-by: Jinmeng Zhou <zhoujinmeng@bytedance.com>
---
 include/linux/hugetlb.h    | 3 ++-
 include/linux/memcontrol.h | 8 +++++---
 mm/hugetlb.c               | 9 ++++++---
 mm/memcontrol.c            | 6 ++++--
 4 files changed, 17 insertions(+), 9 deletions(-)

diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index 16c4c4caa126..45ada75dc04e 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -699,7 +699,8 @@ enum hugetlb_alloc_flag {
 #define HUGETLB_ALLOC_USE_GLOBAL_RESERVATIONS BIT(HUGETLB_ALLOC_USE_GLOBAL_RESERVATIONS_BIT)
 
 struct folio *hugetlb_alloc_folio(struct hstate *h,
-		struct mempolicy_interpreted *mpoli, u8 alloc_flags);
+		struct mempolicy_interpreted *mpoli, struct mm_struct *mm,
+		u8 alloc_flags);
 struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
 				unsigned long addr, bool cow_from_owner);
 struct folio *alloc_hugetlb_folio_nodemask(struct hstate *h, int preferred_nid,
diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 7d1c0ce189a8..362af58e50a4 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -662,7 +662,8 @@ static inline int mem_cgroup_charge(struct folio *folio, struct mm_struct *mm,
 	return __mem_cgroup_charge(folio, mm, gfp);
 }
 
-int mem_cgroup_charge_hugetlb(struct folio* folio, gfp_t gfp);
+int mem_cgroup_charge_hugetlb(struct folio *folio, struct mm_struct *mm,
+			      gfp_t gfp);
 
 int mem_cgroup_swapin_charge_folio(struct folio *folio, unsigned short id,
 				   struct mm_struct *mm, gfp_t gfp);
@@ -1156,9 +1157,10 @@ static inline int mem_cgroup_charge(struct folio *folio,
 	return 0;
 }
 
-static inline int mem_cgroup_charge_hugetlb(struct folio* folio, gfp_t gfp)
+static inline int mem_cgroup_charge_hugetlb(struct folio *folio,
+					    struct mm_struct *mm, gfp_t gfp)
 {
-        return 0;
+	return 0;
 }
 
 static inline int mem_cgroup_swapin_charge_folio(struct folio *folio,
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 785772845795..5ab5a5141574 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -2816,6 +2816,7 @@ void wait_for_freed_hugetlb_folios(void)
  * hugetlb_alloc_folio - Allocate a hugetlb folio.
  * @h: Hugetlb state control block.
  * @mpoli: Interpreted memory policy to use for allocation.
+ * @mm: Memory descriptor of the allocation target.
  * @alloc_flags: Flags controlling the allocation behavior.
  *
  * Allocates a hugetlb folio and handles cgroup charging and global hstate
@@ -2826,7 +2827,8 @@ void wait_for_freed_hugetlb_folios(void)
  *         -ENOMEM if mem cgroup charging fails.
  */
 struct folio *hugetlb_alloc_folio(struct hstate *h,
-		struct mempolicy_interpreted *mpoli, u8 alloc_flags)
+		struct mempolicy_interpreted *mpoli, struct mm_struct *mm,
+		u8 alloc_flags)
 {
 	bool charge_hugetlb_cgroup_rsvd = alloc_flags &
 					  HUGETLB_ALLOC_CHARG_CGROUP_RSVD;
@@ -2881,7 +2883,8 @@ struct folio *hugetlb_alloc_folio(struct hstate *h,
 
 	spin_unlock_irq(&hugetlb_lock);
 
-	ret = mem_cgroup_charge_hugetlb(folio, gfp | __GFP_RETRY_MAYFAIL);
+	ret = mem_cgroup_charge_hugetlb(folio, mm,
+					gfp | __GFP_RETRY_MAYFAIL);
 	/*
 	 * Unconditionally increment NR_HUGETLB here because if
 	 * mem_cgroup_charge_hugetlb failed, freeing the page will
@@ -3020,7 +3023,7 @@ struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
 		.nodemask = nodemask,
 	};
 
-	folio = hugetlb_alloc_folio(h, &mpoli, alloc_flags);
+	folio = hugetlb_alloc_folio(h, &mpoli, vma->vm_mm, alloc_flags);
 
 	mpol_cond_put(mpol);
 
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 1271d390b617..0b795bf1e6cf 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5233,6 +5233,7 @@ int __mem_cgroup_charge(struct folio *folio, struct mm_struct *mm, gfp_t gfp)
 /**
  * mem_cgroup_charge_hugetlb - charge the memcg for a hugetlb folio
  * @folio: folio being charged
+ * @mm: mm context of the allocation target
  * @gfp: reclaim mode
  *
  * This function is called when allocating a huge page folio, after the page has
@@ -5242,9 +5243,10 @@ int __mem_cgroup_charge(struct folio *folio, struct mm_struct *mm, gfp_t gfp)
  * Returns ENOMEM if the memcg is already full.
  * Returns 0 if either the charge was successful, or if we skip the charging.
  */
-int mem_cgroup_charge_hugetlb(struct folio *folio, gfp_t gfp)
+int mem_cgroup_charge_hugetlb(struct folio *folio, struct mm_struct *mm,
+			      gfp_t gfp)
 {
-	struct mem_cgroup *memcg = get_mem_cgroup_from_current();
+	struct mem_cgroup *memcg = get_mem_cgroup_from_mm(mm);
 	int ret = 0;
 
 	/*
-- 
2.39.5


