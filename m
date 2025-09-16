Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A62F2CAC599
	for <linux-mm@archiver.kernel.org>; Tue, 16 Sep 2025 16:01:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0E04E8E0015; Tue, 16 Sep 2025 12:01:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0B7CE8E0001; Tue, 16 Sep 2025 12:01:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F109B8E0015; Tue, 16 Sep 2025 12:01:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DFF1F8E0001
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 12:01:40 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 94544160133
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 16:01:40 +0000 (UTC)
X-FDA: 83895578760.03.41401AA
Received: from mail-qk1-f170.google.com (mail-qk1-f170.google.com [209.85.222.170])
	by imf28.hostedemail.com (Postfix) with ESMTP id 829D8C001A
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 16:01:38 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="IumK/EQf";
	spf=pass (imf28.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.222.170 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758038498;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QHfOln/VR8uFzgqsT6uF/KmaET9pjaPTDRMh4vKV700=;
	b=bdPvS8HWTdB6HUgJGiHGcDaz+5Ru6o8giNGQj2EOd4OtHAhYx6tcDq1qo31QLLCBvVUzA1
	0cLMA8Ho4slLEFJYASYyFSWRhVljzmmPKRPea2J/w0iWLD7WKCy4ZvOdOHJ9PEuLa8RQGe
	bfOWrxB1sxCUIoAiJJ03dLIIYPpoHzM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758038498; a=rsa-sha256;
	cv=none;
	b=yOdS8VluCBGSTOx16BPCBmlOxmve70dWFlUHoMSPBEDbGxhC9jzYCPztUiGAMict7olO0X
	GBI7jxYWwGGrQW9IW/z4nDwn09+QtmYJZ2OhTlrKBwObMuF0ZiCicJQyXUKprO7LijXMnJ
	7QLohG9keWs5NoRWEurM50n6npUhW/M=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="IumK/EQf";
	spf=pass (imf28.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.222.170 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-qk1-f170.google.com with SMTP id af79cd13be357-828d8d06630so97785a.1
        for <linux-mm@kvack.org>; Tue, 16 Sep 2025 09:01:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758038497; x=1758643297; darn=kvack.org;
        h=content-transfer-encoding:mime-version:reply-to:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to;
        bh=QHfOln/VR8uFzgqsT6uF/KmaET9pjaPTDRMh4vKV700=;
        b=IumK/EQf23WLaQ+exoJs41dpTc5Z+Y55KG33q2IsfhwFeVx7UdGMIk37f+FRMZPbDc
         DqSpeM8mKgFtIRWUmWX/XNxT89pGbmP81TkiLBZPA+7NL5VB2HJlcPO37lG/lsFeh16M
         OgJ81jXVMsC/3VUTEArnRN0vJ8R2sZMSmpHRL/SzOrtjsav7uKpiS+i0H/F6ppXGoogQ
         mIGXPA/lyXM92zfEgvIrKQj0hS952gMHE9vp2KhXgjzOSR471V0eEuBzLdLsAi/K3p/U
         VlOddFlQfWwJcoOMQtgE9tiEEKxaT1wgdDscbPtTRGEphaE0dtIgnttGf/hlQYnTlsRc
         Yp0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758038497; x=1758643297;
        h=content-transfer-encoding:mime-version:reply-to:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=QHfOln/VR8uFzgqsT6uF/KmaET9pjaPTDRMh4vKV700=;
        b=tk7rMyfsX2K0MoANf35ywhroz8hRSkMdTLI/+oAcU5b1vrGEnMxXgAgP8DhnaSB4Bs
         VoHk/BIs0WHHcwnfAu8ltANM4vugdeu3Fxem4tD5BokkGqMXSGY+NAGoERBeIhH1z0hM
         fS8l/tFq2N3V9i7RrcUJy28uGrOoq6FBq7/F7ecOZsJs/ca2skDrjKrrVPV3ilfnBH/H
         OywVDVzRcP2RGEB+EO00FPbaxsr0YpIq72AomU901o5g6FOJpn9g5CKk9jB5ckPbdJmV
         oFEIQ4DNXNu8IKwpU97s+7hkHcybia0efjMuKGF67/JAIGtqICof0WaOYJPjUQWhpHex
         SwsA==
X-Gm-Message-State: AOJu0YxHefGuGw964yhY7WW4i+BO1Pw4f+xyC1948fvMs2KuYdTktnhH
	2x0x9WGDWy5om4+NNfyenCj4NsvVzG70scXjsLpdYDLZ7pYOyrA3VYI/P8vsscYovWA=
X-Gm-Gg: ASbGnctVE7gYXTU0Lo2w07sgwW44qto/KMKMhT5o3C5N6p8+PyFIcV6WiylW1eI2rIQ
	rtP/nN1kLtnk9l6gGbRlvpkfhgO0WX0eMCTUlqU/vkpcaO0JEWcBJqnchJt7xpcbcUWk95UYCmd
	pd41baK151zzFp4xhAUDyShaH4fi4tZ6Ot8wWdoJpBHYmL5s7LLEpklM4eCOdS4NtJTtTVSYw8o
	tl7UNFNL1vBhodeOfvUHQ9QYHNaD8U2/s1GGZQiWV7cm5KlBpPuG70sfyLctj6h9KpHhMoeVmRe
	eczv14rjAZWrS0gBg7TUYAU8hI/K5B473hvyLWsg6z9xeUNLTZWyXW5n0dR82yLn2YbzB+iyP38
	FARGsjr3YS9wiKnRrjvOtseWsAXpJV7DfKanFy8tTNilmgNc=
X-Google-Smtp-Source: AGHT+IGAZRkBIeKRz5NtoJB/djuVWVXhL/G4pUd3uLXDSdbMDwhCdTxwRhwBYAhwJr9GLp1bon/fKg==
X-Received: by 2002:a05:620a:2a08:b0:81d:9079:3d22 with SMTP id af79cd13be357-82b9c180de5mr320092785a.8.1758038496724;
        Tue, 16 Sep 2025 09:01:36 -0700 (PDT)
Received: from KASONG-MC4.tencent.com ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-820cd703f54sm969765485a.37.2025.09.16.09.01.30
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 16 Sep 2025 09:01:36 -0700 (PDT)
From: Kairui Song <ryncsn@gmail.com>
To: linux-mm@kvack.org
Cc: Kairui Song <ryncsn@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Matthew Wilcox <willy@infradead.org>,
	Hugh Dickins <hughd@google.com>,
	Chris Li <chrisl@kernel.org>,
	Barry Song <baohua@kernel.org>,
	Baoquan He <bhe@redhat.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	David Hildenbrand <david@redhat.com>,
	Yosry Ahmed <yosryahmed@google.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Zi Yan <ziy@nvidia.com>,
	linux-kernel@vger.kernel.org,
	Kairui Song <kasong@tencent.com>
Subject: [PATCH v4 04/15] mm, swap: check page poison flag after locking it
Date: Wed, 17 Sep 2025 00:00:49 +0800
Message-ID: <20250916160100.31545-5-ryncsn@gmail.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250916160100.31545-1-ryncsn@gmail.com>
References: <20250916160100.31545-1-ryncsn@gmail.com>
Reply-To: Kairui Song <ryncsn@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ip8rj7r1q4ohk4sr3y45uk3eqb4apt96
X-Rspam-User: 
X-Rspamd-Queue-Id: 829D8C001A
X-Rspamd-Server: rspam10
X-HE-Tag: 1758038498-407859
X-HE-Meta: U2FsdGVkX19NJ3zT0TBLGV/FJ3ML/cDhOQu7fPhlsg6hH1hPrKkRdgNqEAOoDKSCdeDIZzCRzQul4X5kRrMaeGc/IjgC6N3FQ51AN2mhkea6QMXhHy7Ov4r+0gBShnHx+TdwGuyclcDTU4PZtnYLeCZKsGtxBq0ZGGUIHZefiasBTOXBIIEsC6DEZk34LGr0iKWA3qIzTvfcKDMU3wSvKcVfyepVfZPrSDGqyaQPFu8BcQQodvr/G/DTDXm4tV4Jnro947Wm94qqq+CYWRWFOkgiE2l4ahdRvXSUbXhQpbjE46igG9kzHL0iNRc0yVyoM1HqlGr2VWYdBGsNhFRzqcRMNXjN4kSsNP3LaG5YuPEnOI2O5oiYzbT+iRm0n+EykRbkoavarasXVey3r1qKu9n6MFW4xskeMoHMBKeAHaummcXqVbTzqIXqOkavysxeYE5OzTTUHwB6ylRXtFpmqmccnEYvuRPR58HwK6cWvzG68s6raXcBuL6rjfFw42VotwQB4li1O+LRlm8FrQ/YLyaxJMv4Pa9gHR+Km5RduepFa/h9CAhLj6Z0nn8jBzjHgGvCNIfiwviprM1Ken9/ETPU/IZU9N6WacUWRARpAHy2J6T9Br1oXXJzDOFPJNTwty/GxtwXDXjUFtwJIDI64906z5yTa6osFRhDPfqpyjBQ+M+OZ6TwUBYM5qufi58MWyVr1uzvuPNnEXDWc0Lj2l0RLq4lkiRVzK9TMhtQ9CbGscZJBJ9tT+sUODuK0DdmRvoXvj2RKVNGSOPU4oY8yRVaEQGGvf9wB1o6vn2EqOUO3js3F6ilUCcmjC9V9bLFpX18uBQh2V3lte7HhLLFqP8so9XAN21SGGYgeLkVKreGEEsQg5FfzbfeNCPGQFWPVOWGU2GNmmHZVlD46EWPw2Zwm2F6A3RDZAGbILuEr0bV+/5JJzo3agA67/0cr7d5tG7mb0z57g9M/M3dndq
 J+8nuZeZ
 GqBfYib14nH/kSMAWvErH46AI1dVQJ7FkEPWaKfL43SW+iFw7MuRgNLa+YOtZIzulm2GUbcg9q//7V+doZr1rBvvWVIfnKXM7izTE8sCJji1TBlicYvzQ7fPmV/Q0hWRKvK06V7l/gPVUTZaoftVpcAU7Gs/7+sy3drSaJbALiB0yi+Y0halEJ0KPbfDvYmB3NHcNFpMlEPxXAe2BAcK3HYttA9Whu8vQsOGPMuOpAS9yozaF5ncGFYW9Us/VvXQI+DQv0aJUI1Er3pU79V8oseeOaQUfhqsK6xvlR0w+7LlmitBmNpZCtSIFVsZDYfz18DL6u1vjKuHhdFk0zBdzY3OnXS26UvO1uIs3aJGEEhfgRYRlDpKOegBINYbDhP0SCf2T/dkIFqqHzrrb4CC0U90RBx9tFs9q3lM2EGpResGPUHQVKppZvzzTFNZhV2Lnemu3I74eaqExNnn3+0oFVjXGd/8kqvaDzARnyJC+boyJ77YsXkPg/S0VEAb2VzGD/pYdISWq75ZgHm1oUlC7Ak7CeeF2QKUJFlM9YOR2yA0q4Rcccou1tPVbQmyjzLImW3Dwwlcm5k2dO3dHpWaBSAAB/wnvBQJoEoOQ9ysab2cmDua1Be5g8ka5Yqt1de3kb68a
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

Instead of checking the poison flag only in the fast swap cache lookup
path, always check the poison flags after locking a swap cache folio.

There are two reasons to do so.

The folio is unstable and could be removed from the swap cache anytime,
so it's totally possible that the folio is no longer the backing folio
of a swap entry, and could be an irrelevant poisoned folio. We might
mistakenly kill a faulting process.

And it's totally possible or even common for the slow swap in path
(swapin_readahead) to bring in a cached folio. The cache folio could be
poisoned, too. Only checking the poison flag in the fast path will miss
such folios.

The race window is tiny, so it's very unlikely to happen, though.
While at it, also add a unlikely prefix.

Signed-off-by: Kairui Song <kasong@tencent.com>
Acked-by: Chris Li <chrisl@kernel.org>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Nhat Pham <nphamcs@gmail.com>
---
 mm/memory.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index 10ef528a5f44..94a5928e8ace 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -4661,10 +4661,8 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
 		goto out;
 
 	folio = swap_cache_get_folio(entry);
-	if (folio) {
+	if (folio)
 		swap_update_readahead(folio, vma, vmf->address);
-		page = folio_file_page(folio, swp_offset(entry));
-	}
 	swapcache = folio;
 
 	if (!folio) {
@@ -4735,20 +4733,13 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
 		ret = VM_FAULT_MAJOR;
 		count_vm_event(PGMAJFAULT);
 		count_memcg_event_mm(vma->vm_mm, PGMAJFAULT);
-		page = folio_file_page(folio, swp_offset(entry));
-	} else if (PageHWPoison(page)) {
-		/*
-		 * hwpoisoned dirty swapcache pages are kept for killing
-		 * owner processes (which may be unknown at hwpoison time)
-		 */
-		ret = VM_FAULT_HWPOISON;
-		goto out_release;
 	}
 
 	ret |= folio_lock_or_retry(folio, vmf);
 	if (ret & VM_FAULT_RETRY)
 		goto out_release;
 
+	page = folio_file_page(folio, swp_offset(entry));
 	if (swapcache) {
 		/*
 		 * Make sure folio_free_swap() or swapoff did not release the
@@ -4761,6 +4752,15 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
 			     page_swap_entry(page).val != entry.val))
 			goto out_page;
 
+		if (unlikely(PageHWPoison(page))) {
+			/*
+			 * hwpoisoned dirty swapcache pages are kept for killing
+			 * owner processes (which may be unknown at hwpoison time)
+			 */
+			ret = VM_FAULT_HWPOISON;
+			goto out_page;
+		}
+
 		/*
 		 * KSM sometimes has to copy on read faults, for example, if
 		 * folio->index of non-ksm folios would be nonlinear inside the
-- 
2.51.0


