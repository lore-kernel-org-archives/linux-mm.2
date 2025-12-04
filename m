Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DC4E0D2A520
	for <linux-mm@archiver.kernel.org>; Thu,  4 Dec 2025 19:30:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 42C3C6B00BA; Thu,  4 Dec 2025 14:30:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3DCAA6B00BB; Thu,  4 Dec 2025 14:30:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2CB086B00BD; Thu,  4 Dec 2025 14:30:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 162AA6B00BA
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 14:30:10 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E85CA12B5B
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 19:30:09 +0000 (UTC)
X-FDA: 84182779338.11.FB538FD
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	by imf13.hostedemail.com (Postfix) with ESMTP id 01F4320019
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 19:30:07 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=fKgDvTW1;
	spf=pass (imf13.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.169 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764876608;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=m3/znPoavjBgqqjpUZfnq7wwOL79gjtKqNHBOh+8lvo=;
	b=e+c581I7NOSG7gKNs2/KDT8okLUALKh0ePWu4sl5xmwkyj4bpbgJYbXkLTGmo0ERy7nL/R
	7GdV+3MHPYxv0RoyinWa+jF48myRGvQS0/ip1wFOJxrivFtYRd7u0racyFnvPTDjMkaqja
	oDhB8brm7KI0VT+n201A+dKtepaZQSY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764876608; a=rsa-sha256;
	cv=none;
	b=7E4bfUuSmCyFpRP+B79Rmieax7P3OD4RSPSERkim2dEErRCSEHU2iIHFegJK5cgmm/Qcmd
	psICKdzp90GO7SECql0hkvhneLOcYQ9qqOCETM0FWyegXRV0cMVjS3N9Al0ITUgDD0LDpB
	66Xk/T7Nw6xffhwL5U670XugWd49pF8=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=fKgDvTW1;
	spf=pass (imf13.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.169 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-7bab7c997eeso1687842b3a.0
        for <linux-mm@kvack.org>; Thu, 04 Dec 2025 11:30:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764876607; x=1765481407; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=m3/znPoavjBgqqjpUZfnq7wwOL79gjtKqNHBOh+8lvo=;
        b=fKgDvTW15g3fMJuI6F9Kuqzbav8BSwIhYvHp4F2Do3PNtF+kpH171Sclu9gUufY7Dm
         z4sS56G5N6raGd1aAe6p+2XDTLgQKw6e4tluYAFvrNAzSGpq09ROE9u1TeEjxd9jUqcE
         zMnR/PWOigVxgGv0ADW/g3gze0g8qLnUtVFsztGahyQbCdNkYk6HwHdGnnIqxVnmZE/K
         ojX5idBl90jCmxX3yvlnp4aisEAnyeX8JLJ9OUW/EITQaCB9bWBiZ0VcSYpd+uY0NKnO
         NUTYXA2unvnGlKQbMiDkaHNy9soKB9R+Y1HXFyLPje8s95PDVWVjeF5uDKZstn6TDwOX
         eElA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764876607; x=1765481407;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=m3/znPoavjBgqqjpUZfnq7wwOL79gjtKqNHBOh+8lvo=;
        b=Sai3yiNaj7zs3UlvbJzZ6zAW7s2cB+rNnQA0hGnauv8vOiKiaFwbriCBUy5fuEHHHW
         4+3M9WDwR9kMRz43tAKTrYyOAKfGNrNMlmQ1dlP6H4FDPxXyKa87V5G8xPHfG1kvFqTu
         RLDSUqf/7HSe+vc/biUF2k7VYNdm6dTMXItxWzHNvJoS58X91zD/+hRHQMuifqpfMBwG
         6zoYePTJk5nscvOiyeGCiUCXWL3v0ATqlQ1q63iOstl7gu0u8x/WRD3TR4kEDUaRJatE
         LDr4gJlRHf0rWFWCEeFMRqJjXX+YLteHyU/bliTRP/2+MyDZrwkfvR4+pi3UyWorhGw3
         bX9Q==
X-Gm-Message-State: AOJu0Yy/JnAraRGk8uoSMyg+2GDaywAn9OpUDLRS157m/+uNNTgDwx9n
	Bfew7asfqLRDZ1kvGclsh0eErwWlJy1vt95f+f4EKFki6oDICc75qNWr
X-Gm-Gg: ASbGnctqGxe7aR7s5sIxyYoAj1gXlpFCcJM6by+66FkTVvyCAc/2HNTuse/vSla9IHM
	kzHYQuM/C1aRHW+3Nd0Li+uPM8DBssHyf+T30bMqK5h4YPhMJzQyWutElxHuzGtB4NEZj8ZBBhZ
	tAKxTReBwO4G4t2KODsTENvYgkeFmPu/d7XusoG4ZgNZ5hi2YVllL+5ruI+FcgQZNXxrQgKK7XG
	KrkeA+ioU+WzB0uRSf1ztxyQTTfhuXTj35zW6q95FA/+i8D9ciA9N0sojEocgW6ROvBWc9MOIuh
	Itu4H/cpGURFzLNcvvwA9piieId10ioi8dFglScj890Mjz8ZjEN0I0McwzSvkyIS4f3sLD1Oe8q
	S0VtnR1zxstaE1KSBeAStlO0jmwaMqaoOE3G/4iAeEwQ9xAAmLkTH0Gi6zzCRPro/E9rOGKmeSF
	GUiUXnDNlAMad426bDxmqIOJneWOEDdOqAcJrlU2RD9Zn7KPD/
X-Google-Smtp-Source: AGHT+IHlCihpoml1bURIaE9C5o/lmQI/Qptg1W+OPUZo32rvNPAw+oZIUkYT4BZTK0zq/6gCdjTzQw==
X-Received: by 2002:a05:6a21:3281:b0:361:3bdb:26df with SMTP id adf61e73a8af0-363f5cd95a3mr9195987637.5.1764876606643;
        Thu, 04 Dec 2025 11:30:06 -0800 (PST)
Received: from [127.0.0.1] ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-bf686b3b5a9sm2552926a12.9.2025.12.04.11.30.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Dec 2025 11:30:06 -0800 (PST)
From: Kairui Song <ryncsn@gmail.com>
Date: Fri, 05 Dec 2025 03:29:14 +0800
Subject: [PATCH v4 06/19] mm, swap: free the swap cache after folio is
 mapped
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251205-swap-table-p2-v4-6-cb7e28a26a40@tencent.com>
References: <20251205-swap-table-p2-v4-0-cb7e28a26a40@tencent.com>
In-Reply-To: <20251205-swap-table-p2-v4-0-cb7e28a26a40@tencent.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Baoquan He <bhe@redhat.com>, 
 Barry Song <baohua@kernel.org>, Chris Li <chrisl@kernel.org>, 
 Nhat Pham <nphamcs@gmail.com>, Yosry Ahmed <yosry.ahmed@linux.dev>, 
 David Hildenbrand <david@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
 Youngjun Park <youngjun.park@lge.com>, Hugh Dickins <hughd@google.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Kemeng Shi <shikemeng@huaweicloud.com>, 
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 linux-kernel@vger.kernel.org, Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1764876574; l=2699;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=7ANx1B1sM45AeElSDuuzzNPN1Tv7606509lOkJkHgRE=;
 b=90zPFXqUoIJKzzeQgR2WIpWPnUlFjo51E3igJ0+jxGSHtxP9gmtjHUDBAh8+8WttPBQRL9Ia8
 uE6YjgmVFcuDL4N9jy7qQnDwYpQZ/xV3RYh08HQsk+hxX9t7Xe8KXPW
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 01F4320019
X-Stat-Signature: yiags1m3x8qd45hdbynwo6w4yunm51xa
X-Rspam-User: 
X-HE-Tag: 1764876607-186126
X-HE-Meta: U2FsdGVkX199rUcKcfUEuCSHO/Ev8HqiiqAuQtT4gTeDMT9chNgI3EJxcVcQEpSzygTunHoPgTUj4GDVAzh3Ki4ZRAs4lPsWQ02Bsp52qrAdaKzQSpQ2biQ7WxVWAvSVAZWosbzFdRJ+uZWbNBp0+BW4qHUVVK0V+DGN4bwz/ORV8CY6CL0sFV+Uv7J0BojXEe8kGmqG9L2xXmAIkzGJBnhpR/wtp5BgRbHbGQOD7JQ4JpxXCT222tBXBfkJFvG64P1sZeXgOyXHO+Dqigih0Sah5ZGTXsUt5qXSOQqgtmTbJZRqC/aR6S+/3DvCUNtchaP9l6zfC3zSMZMeZoc7zDhFwGqCIV9zUvQZs8ifrVCGHO9e0UNbay4q8sGAennA2N7OaFQiXob3kx7sv5yx/lJ4uLCIQi4W+4VsEyTYtnudbXA1b3B+gbYWzMDZc7emjSyXLfpxdlL445HVmCB+z51l5jGacnqOolYI9SUxfaYspH79+Vco09bwL4VrZBo5s8plIo+f83DZ2MV/ddMS3P/RGqea+NQZul5i5fK7okvOp0pocIYYopl5gAGjUqb1BtUyM3wt/byyri3WKJMGeo7v5SWipmwQrPLjoUJsURTQTsSUcgmwywtjaMfSOncFuUqadm99NNFkg7EPca9d1bMrn7ON40bUIemCO5sdWzpsFTtz8pDAfGaY46TySDbZ/HAY4moF9mv6nAem3pwZ5B9eGOoRDwOwQP5w2v8Ei6yBRVQoz93x1CmpSGDNgXwxpyKDIrzV/SBreDLurF16MzRs5k7/IqJ+AfJAVFGGycbcXU+icT3XrBlYPKnSj/9TvjvxgDzuv3odzi5U2L6vxrq4RNrtV+Rd0W8sGTCgG6Mt2yZYOTDfxpZNJQ49vZUBEXHt3dUYlyn5VqwkHxotidAMqDrzGIo+Ud6+j7913gSD3umZ6ks5Id9XXaeKMS7I1LHwUpE7aa+8cHOUAZL
 0hWPxWbb
 ouarYiIMzAeDbY5LukYlrEaE8snVI+Q/AvV44um7pldnPcDqUiOnpdM7d+elI7LCN2cN9K6opSV5VAMR14eVGhQ46hA1LyaWNeh+kqPkZfzceDiuhG3l0FsNYYcCDX5+sKfHO1wQtE+5l+TajT/A9emBp3jPzGC3tttxQ7l0P/y6i43vUpvXiwK84hmQmOEwbzhc8Z1gVfe7FB1+pZxPvt1cNbr4B7aEl8wruy2xbDxPALHHUekY5vOEly5Tny+Gt/aL175Of/AO9dKJz0ql7s0a/h1H91uwjso1LoIbtg+A7zjvl61IFMHhAQbryhHsiJwAWny63q3l5cZgWkOY/7Rwhd1aSF/EKPTFJMxG1esfniltPnCI4wzB0kSEFDI1NaEV6i5LETbbmB6CSTR8OAIupploT+E2tn3iv3rM1xP/VkMuhoDiw4CIzvngEAH/m1G9N5j3mSynF87rp4F8roUUg7A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

To reduce repeated faults due to parallel swapins of the same PTE,
remove the folio from the swap cache after it is mapped. So new faults
from the swap PTE will be much more likely to see the folio in the swap
cache and wait on it. This does not eliminate all swapin races: an
ongoing swapin fault may still see an empty swap cache. That's harmless,
as the PTE is changed before the swap cache is cleared, so it will just
return and not trigger any repeated faults.

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/memory.c | 21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index 3f707275d540..ce9f56f77ae5 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -4362,6 +4362,7 @@ static vm_fault_t remove_device_exclusive_entry(struct vm_fault *vmf)
 static inline bool should_try_to_free_swap(struct swap_info_struct *si,
 					   struct folio *folio,
 					   struct vm_area_struct *vma,
+					   unsigned int extra_refs,
 					   unsigned int fault_flags)
 {
 	if (!folio_test_swapcache(folio))
@@ -4384,7 +4385,7 @@ static inline bool should_try_to_free_swap(struct swap_info_struct *si,
 	 * reference only in case it's likely that we'll be the exclusive user.
 	 */
 	return (fault_flags & FAULT_FLAG_WRITE) && !folio_test_ksm(folio) &&
-		folio_ref_count(folio) == (1 + folio_nr_pages(folio));
+		folio_ref_count(folio) == (extra_refs + folio_nr_pages(folio));
 }
 
 static vm_fault_t pte_marker_clear(struct vm_fault *vmf)
@@ -4936,15 +4937,6 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
 	 */
 	arch_swap_restore(folio_swap(entry, folio), folio);
 
-	/*
-	 * Remove the swap entry and conditionally try to free up the swapcache.
-	 * We're already holding a reference on the page but haven't mapped it
-	 * yet.
-	 */
-	swap_free_nr(entry, nr_pages);
-	if (should_try_to_free_swap(si, folio, vma, vmf->flags))
-		folio_free_swap(folio);
-
 	add_mm_counter(vma->vm_mm, MM_ANONPAGES, nr_pages);
 	add_mm_counter(vma->vm_mm, MM_SWAPENTS, -nr_pages);
 	pte = mk_pte(page, vma->vm_page_prot);
@@ -4998,6 +4990,15 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
 	arch_do_swap_page_nr(vma->vm_mm, vma, address,
 			pte, pte, nr_pages);
 
+	/*
+	 * Remove the swap entry and conditionally try to free up the swapcache.
+	 * Do it after mapping, so raced page faults will likely see the folio
+	 * in swap cache and wait on the folio lock.
+	 */
+	swap_free_nr(entry, nr_pages);
+	if (should_try_to_free_swap(si, folio, vma, nr_pages, vmf->flags))
+		folio_free_swap(folio);
+
 	folio_unlock(folio);
 	if (unlikely(folio != swapcache)) {
 		/*

-- 
2.52.0


