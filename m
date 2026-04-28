Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 71E87FF885D
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 11:30:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B1B246B008A; Tue, 28 Apr 2026 07:30:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ACB8D6B008C; Tue, 28 Apr 2026 07:30:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9E29F6B0092; Tue, 28 Apr 2026 07:30:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8DE046B008A
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 07:30:48 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 38EA6C1F16
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 11:30:48 +0000 (UTC)
X-FDA: 84707747376.07.B3B071B
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	by imf20.hostedemail.com (Postfix) with ESMTP id 63CF21C0012
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 11:30:46 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=nrAy4HtB;
	spf=pass (imf20.hostedemail.com: domain of enderaoelyther@gmail.com designates 209.85.210.180 as permitted sender) smtp.mailfrom=enderaoelyther@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777375846;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=g1Ct8Le8BV/CkL7dz/X4QUOvjolhlSF4pzodVhQ1Ejs=;
	b=uUbAmoxL9SP8HMSzh3ZLWJOSZGj5v15oA0U4IDG5M8HqeVXRk+vt7M199u+6MFzQhiEqnM
	awl6K3OezIOI2QrQkf+LG1xVnmnQPO6oFcXYmDoTSaZrHw7+AbGa66/PnSs21mh+hlonr/
	B4DmR8Al2uZI+WmZJemGhMqJhi9Mdss=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=nrAy4HtB;
	spf=pass (imf20.hostedemail.com: domain of enderaoelyther@gmail.com designates 209.85.210.180 as permitted sender) smtp.mailfrom=enderaoelyther@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777375846; a=rsa-sha256;
	cv=none;
	b=Eg/5z62ospd/K9FOj9SivsTPlrb/n+M5hF1s50/D17N3qZVkNmWoqAkbq1HDUhvbi8cGrL
	wACfDI5CpGu1uwZwjlQY+zJPfYg19PS3UABGBXMBf9cK4wtnM+nrURpx8iAmIlXkYQzVJh
	heHfhPweVQQXcKA2qu0ukN5IbKB/FH4=
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-82f8893bff3so5281101b3a.2
        for <linux-mm@kvack.org>; Tue, 28 Apr 2026 04:30:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777375845; x=1777980645; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=g1Ct8Le8BV/CkL7dz/X4QUOvjolhlSF4pzodVhQ1Ejs=;
        b=nrAy4HtBEVd/NMQm4TRdjzlsWgWhFb+x4IeW4CC6/J5JKw1jV/4dT7cQttgaH4o6kK
         T9kS6LWRmjg9Hb7MH5SqSgGNNuNd3ON22sXfSMjrDC9kOaj/M5jEAQ4P2oUO502umkU3
         A865HUTDdP31tu8Rum3iyuqib+V25juUyxrGf/A3gRUZ8rD8veMqTKzN31YxDI574MJQ
         GYwR5kHoWszdQ53nX0n+MwzSkfM+4+Ye7ha5HSNkcwym16rqzq9f3oOQy+U1yOuWoNbH
         LwMRYhcVjXA+ZcqCD38MoEKQCNv4uA0fHp/znKzxnFLPBO6YM/xnxY3vDEWYD2B1xoHx
         7fIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777375845; x=1777980645;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=g1Ct8Le8BV/CkL7dz/X4QUOvjolhlSF4pzodVhQ1Ejs=;
        b=dkX6i5ztLTTQgbkb/oWUg6TA4qZAVwaCNbyvPpUviMCc2pTTyEk/9nOoGlWd65fHVR
         i0kjzWe0uHpJG/KWFXG01LFaP7dkAe5gWtzwF2ngtmpQ9kOnnhcuS5bwneFL42hlnz3s
         d5io5hZhB4ulC1J8rk6hH9v8iN1u85JkJ+M4UF8NG9lRiCIJ3i9w7Oyw0lUd9SeKhM6A
         ivUNq1QEMsVMSznyDETgCaQ8wqW8Rx2Egd/wPavb0rRjtMV26Fkkc8qLrmht4AniU3Ho
         P443ffM6kVCFoF/LEbcZGVQqPKVJlQqqcOEpsZkkZ2zlJjT4vh9IUyXw/EugvJvhUNia
         r7YQ==
X-Forwarded-Encrypted: i=1; AFNElJ+3DmC86FwwRxo0niRlRfPPyZuHnFOIWckl+HYV8BACJS5T8V9FpfanS+vGMr1ZhNAEANecJDPtZw==@kvack.org
X-Gm-Message-State: AOJu0YwHphK9D9fC3Vu24vgjdoMMjxC0tv44dxdy2XEyH0Cic45d5vHU
	+U4RBJbeQBldUZIFKYHZm2IQ3mZ0CCfwpfR9i3oJuXZmA4uX+pmgeLts
X-Gm-Gg: AeBDievmcsyDt4ZVk/sOffFs2lKp095q9HR2tj/AzRs/ktuZfqf0CYsYeS2t47DpJcM
	zhOIKnchZyscjJsNsQkUV4/2L19Ba4l/5gDZfJ3dQgqL0rRxiQ++mqPJ0shRJr3/orIXZ7AIjIi
	lj53G/myQ4/DFKujw5ktpUYWu/jwQPyXxuC4xG5SSmRMnuUy1GiyXDAG4V/Cy5dzhlSbCAEfV/r
	aqZJgmylLConEOhQP35oGME+7fLBOm3WL/2Lcp1VYahPtoK0bgl0a5TeVxw+ZDpEyz7LL+VoaPI
	/LSOKWvQb3aZokrYrlGGpOxBNPpEt99h8rSkfTLbVAhseKHVEiGJGkBtomGRdqhbbdSUoZypm05
	iD0OQ9BHaSa1J7AOHXFq0o+clnCdmidfDV26VANFZJuc2n6oWW0PZBi92qkRYWB2+lm1lTnRU+h
	wyAW93gITTBq5Ynqn3TauHQVP6dPXogkxt8Knrag1LsOwTf/wDWMVycraSaSlpQQbaimpnKpAJO
	Syn
X-Received: by 2002:a05:6a00:181b:b0:82f:4191:da10 with SMTP id d2e1a72fcca58-834ddae0572mr2816395b3a.6.1777375845004;
        Tue, 28 Apr 2026 04:30:45 -0700 (PDT)
Received: from KRHW1CJW23.bytedance.net ([203.208.189.8])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-834daf6b111sm2455545b3a.52.2026.04.28.04.30.41
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 28 Apr 2026 04:30:44 -0700 (PDT)
From: Zhao Li <enderaoelyther@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mawupeng1@huawei.com,
	Zhao Li <enderaoelyther@gmail.com>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH v3] mm/hugetlb: fix max-only subpool accounting on alloc_hugetlb_folio failure
Date: Tue, 28 Apr 2026 19:30:38 +0800
Message-ID: <20260428113037.88766-2-enderaoelyther@gmail.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260428030712.66256-2-enderaoelyther@gmail.com>
References: <20260427145247.84157-2-enderaoelyther@gmail.com> <20260428030712.66256-2-enderaoelyther@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: hanhwi7a1hpesqzcxid17fdexukrjacw
X-Rspamd-Queue-Id: 63CF21C0012
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1777375846-462178
X-HE-Meta: U2FsdGVkX182wUIUxtVxsIa+JH4dDd02//56ycIi3kfNufIM7ONxBzBuJTkL1n5pV6v9RSxQ91TcVheBrgsH/+9mKxoBzp7Y0vI0HmUZwJnqXw9kZb7iRDxjMLfwxXBreBJHLLGFprV66tY2jM0aZRstK/Kh+9tDa/5V/ZkpbLxulhhPsJ/tKaYvxYhWdxUZ/Ij/JZJA1byJBfQCcsK5hm6dmOKOdO+rOFCNZtMzqH6sOJcUVFf63y8D2Oe2QtTxZI7gj3mwxMNAEi3gDAGnLYoXz8/LqC3XNjiWWwWrpQr0o+kNA31HrRWGrzUsntr0CJJgtQe1AXLMfK1W3BgWLabnIsBgjmRineTICgn8hywe2UdMVsDfeaUWYBADmwtaOWNl3iedd0tc5EpZMb93lWJCLCh4YczhIqJ0gLZLwRROzdCtV+ves5OfUDMhmzwsNCTkOf+AzhtPwu/a0V2zIydpeQGFl9/I5gPVVq8Qm6YOjSthTMjwEBhCxh16zBADmQOmoF+QICr2K8smOCnAVj8lNxG9JHY58qJVSi6RMiVFhaNy36wVDvF7vogQ/cNWwghTLtN0G0Wd9EDosrMleu3tDxceyrqLO0w3X50h/PXUhgJ77GUBDGOng8BuVRvFIINGvI/G6PsCD2ggQEiWNP25PLZMk79U8VtkLYE6ThU5OXk2/fIcwyRj3mzYwqB9yXxsknDdUQzQsH1l+9RXb9Spct1L6ILYT9ywIFyt81+nu8nRiEDZAb91lVMJ0IJ+ODkRtmX19jxvMQ7qlFZPgJf6P7b/+FcY+OqD5Mkc2UMQ0ZdK4WYmPoR7s0ar/n5/B+eYChW7d94hj02zh2Gwrqgk4IDDGT5QZAMzWHw9P7fnM2EDV0mMvaYUACVaqEkcZsvQfx6Vpg/C7TYo8v31DAqvS9BcFKW+UguC3dtgJp6SW2BUFnzaulVRUu6kmcp0Qs62ra5IB/1BqGlBCMD
 i371s06e
 uthMHPrTmS/GbfbGu+mYSzosjTU83HiscEmY1EHSNiGK8yLbjGToOoBVpzGdla/ZRnjJERYjK5qdCUoiZcqt6LVigTnWPRaDwscefqgXcemwqr3ENS8bEwhnxQblS/AQmF8Yw7Hqr928rfzM09Lc89xmia8To+X70kZSEBvlESQFUXuuDFFoASmGvOSu+pXCyTyf1qvNznaC8W8FhJf05MunRPOcQ88HIc7+YBPZ4l+kBNTW/29slcTmxj+4PUxSWgfZtMJ+hPt9/jFuBW1synfcIJ8eDiN1fQIgwoc955UtiOVeiqqHJhZnyxvwMLVkfEU3wejxVgafduPeKLix2m+UTXGikrrjbUIEm85C26moj0tzPWE5GCZZw/D44alWJfeWzDqlEbO72IhqAOEcOF+nW5QiBezNDDzFXBb+WWgYWBxlY9zQFkikYu/Hn1EG5e1L6O7aOFkiaTsjA3P78j63DsBHPIRcg82Aa0vEli7JT00I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

alloc_hugetlb_folio() calls hugepage_subpool_get_pages() when map_chg
is set.  For a subpool with max_hpages != -1, that bumps used_hpages
regardless of whether it returns gbl_chg = 0 (rsv slot consumed) or
gbl_chg > 0 (used_hpages slot only).  If the allocation later fails
before a folio is returned, the unwind must undo the used_hpages
bump.  The old cleanup only ran for !gbl_chg, leaking used_hpages on
the gbl_chg > 0 path.

For gbl_chg > 0 on max-only subpools (max_hpages != -1, min_hpages
== -1), hugepage_subpool_get_pages() took only a speculative
used_hpages slot.  Drop that slot directly under spool->lock.  In
that configuration hugepage_subpool_put_pages() cannot restore
rsv_hpages, so the direct decrement is the exact inverse and is
race-free against concurrent puts.  This matches the used_hpages-only
part of hugetlb_reserve_pages()'s out_put_pages cleanup, but
restricts it to the max-only case where no rsv_hpages restoration is
possible.

Mounts with min_hpages != -1 are left unchanged for now.  v2's
approach (hugepage_subpool_put_pages() + h->resv_huge_pages++ to
back a restored rsv_hpages slot) double-counts global backing under
concurrent free_huge_folio() and creates phantom reservations under
concurrent hugetlb_unreserve_pages().  Safe cleanup of that quadrant
needs a coordinated fix across multiple call sites.

Reproduced on size=20M hugetlbfs with the faulting task in a hugetlb
cgroup whose limit is exceeded.  Vanilla leaks 6/8 hugepages of
subpool quota; this patch leaks 0/8.  Verified under QEMU.

Fixes: a833a693a490 ("mm: hugetlb: fix incorrect fallback for subpool")
Cc: stable@vger.kernel.org # v6.15+
Signed-off-by: Zhao Li <enderaoelyther@gmail.com>
---
Changes in v3:
- Replace v2's hugepage_subpool_put_pages() + h->resv_huge_pages++ on
  the gbl_chg > 0 branch with a direct used_hpages-- under spool->lock.
- Restrict the cleanup to (max_hpages != -1, min_hpages == -1) where
  the direct decrement is the exact inverse of the speculative bump.

Changes in v2:
- Skip the gbl_chg > 0 cleanup when max_hpages is unset.
- Add hugepage_subpool_put_pages() + h->resv_huge_pages++ on the
  gbl_chg > 0 branch.

 mm/hugetlb.c | 25 ++++++++++++++++++-------
 1 file changed, 18 insertions(+), 7 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index f24bf49be047e..cfdeaf6394c5b 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -3025,13 +3025,24 @@ struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
 		hugetlb_cgroup_uncharge_cgroup_rsvd(idx, pages_per_huge_page(h),
 						    h_cg);
 out_subpool_put:
-	/*
-	 * put page to subpool iff the quota of subpool's rsv_hpages is used
-	 * during hugepage_subpool_get_pages.
-	 */
-	if (map_chg && !gbl_chg) {
-		gbl_reserve = hugepage_subpool_put_pages(spool, 1);
-		hugetlb_acct_memory(h, -gbl_reserve);
+	if (map_chg) {
+		if (!gbl_chg) {
+			/* Full inverse when subpool_get_pages() consumed rsv_hpages. */
+			gbl_reserve = hugepage_subpool_put_pages(spool, 1);
+			hugetlb_acct_memory(h, -gbl_reserve);
+		} else if (gbl_chg > 0 && spool && spool->min_hpages == -1 &&
+			   spool->max_hpages != -1) {
+			unsigned long flags;
+
+			/*
+			 * For max-only subpools, subpool_get_pages() took only a
+			 * speculative used_hpages slot. Drop that slot directly.
+			 */
+			spin_lock_irqsave(&spool->lock, flags);
+			if (spool->used_hpages > 0)
+				spool->used_hpages--;
+			unlock_or_release_subpool(spool, flags);
+		}
 	}


--
2.50.1 (Apple Git-155)

