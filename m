Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9BC28D78770
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 19:44:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 148866B0095; Fri, 19 Dec 2025 14:44:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0D24B6B0096; Fri, 19 Dec 2025 14:44:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F16D56B0098; Fri, 19 Dec 2025 14:44:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E23E36B0095
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 14:44:48 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id AE12D1603A4
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 19:44:48 +0000 (UTC)
X-FDA: 84237248256.27.EF30619
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	by imf28.hostedemail.com (Postfix) with ESMTP id A628AC000C
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 19:44:46 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=BSOCV+cm;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf28.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766173486; a=rsa-sha256;
	cv=none;
	b=WuOzWxdf3/9Epjt/nsm4SYwl/Fk88OX5cmVlH5VsyHIjoiEXepjwKf6qSuWyac6pm0IrTJ
	j/zdkeE1r0fIMRTcoFs/nbNeBdaV1L6Yc6JZDZ9jOpmeVdWK2Y2zh4FqHaMLEsPKZf5fh6
	HU3LkWfJFm9z9uomct60vxwgRhCg62M=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=BSOCV+cm;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf28.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766173486;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2PwOG+0/dDfbVzV+wkf5kACnPNuyGcuNjwmqxxfojog=;
	b=y8KL/MQP1MMQB+PX4nLynzX9FAug7IQozbEewUlYCEzZ9lopqepg0dGrAD1BONuKYH2ACQ
	p0cN5a7MJu6DneZD1uoQwsqFvY8XY6795xP13KpNdhH18GZ1CxdnhVgi/Drjr7FoAI2jnV
	BZ4SzWbgoN2Dt8tVWu0QcwToT+eIQMg=
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2a2ea96930cso21677665ad.2
        for <linux-mm@kvack.org>; Fri, 19 Dec 2025 11:44:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766173485; x=1766778285; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2PwOG+0/dDfbVzV+wkf5kACnPNuyGcuNjwmqxxfojog=;
        b=BSOCV+cm2SvNDy20oLBeyJeXUU54O7VaCxj4nq9DsPPN8pC42GwuS8KEAwL//DNTxg
         lDvwnIIeMgfhpH4BlH9ffvAxKr7Q7gEa2w42BH3IO+nU7xz/VE6NxPYkOKNbxvPZt9YG
         0ddWxaZ4Sj6blYcJe+oqH6ZQMaXbamGJHA7mpyZMGlunBa1bEY/3L2iZMoo4fEcLq2V3
         z3uRVYQlHtmtSB45GWX0dTmp34CztNuOdKbAaCv/MrA6LFNEfHFcWi8ksNdw2UcNeFIJ
         ckWPWj+ywaGPph6oLC1CAJZnnYglGhE8AvXEbdJNFPXDF/c2B9iZ3tPUNg9S06okBW14
         chFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766173485; x=1766778285;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=2PwOG+0/dDfbVzV+wkf5kACnPNuyGcuNjwmqxxfojog=;
        b=uSzVfcXWDEYqWvP9YRWoWC1y0K7zmogUYCiHPKyxdR2UJWsZOD6BYBfzNf64PwpxU7
         6IK0DYs94bH5rx+Gj3UIWhnXUyyfherMpO+2XmwzOLmjHN/0/qCBaZT5xkWTPgJyVBQ0
         uXZmIgIhs43trfOipDkzvjw/ar/Kk/OuWzt6RTapNCeq1BmCTv/B4++scCIaR89aL+x5
         EbefIzSokp6dpmWddmUVvSwZVWEEK7F+zgAJx1UP2BB0rlxQxVEzWa9ab3tnuWIJybyl
         +aeBslLMSthqt1Z3CcnT29YBXTiWbEAGIqdat9mKrQLS60QMKTSic0QDCQK+C7Ie2OQD
         GEkw==
X-Gm-Message-State: AOJu0YzuWAKbr9GmJ9C/uo3eJXyJBsgQMlVg9nd3FSoCTNRkfd1xb2RQ
	wt6XVadmAqs9MAwZelgVFWkHvzF9rq4Ud7Y0peo9bEv1O3YH3NRPWOZJ
X-Gm-Gg: AY/fxX5dQiZV+31R180nbf8AvDOFZikjb71bjmyOob9AFpmye4Oka4XWkM/UTWLafGn
	j5OMK8dsJZwaAQ/wAaBihqMl3I/O6vYLbUfZlQ+huy2dVQNijCMaNzSnekFxMwYF0yhFP3uPfrC
	5uiD4HzVJpIQpOycD8yMPnYuPi5vhN3v9y1iIqI8jCCFBrvoi3umWtTQaxi3VA9CHkryaAkOY5T
	EFzNvlaNLRgSJHcM821fbdI9IM70I8YgwhZldksjPSH7Dxm/EUihD/yCkJuZpRIGXO/gzxFmgPE
	zFq/Z8HkUWninhrTnTFQgNDLuH3pAQ31dBNHJ4wRQqVCy5lggcaIUyDTNUGpHfTPr3CE+Q+pejD
	Etm8O7lzkk9tEqFtsFnRXB/FBZIULO6MinHBXpXU+E+Z7iPXIILdYYT6z2UH74je3pCVQHTA9Yv
	QrEKuqaJJFvM5glJwYIdnP+JP1xOW5sqaYysSqhyf2Px3Nfu6V1fnA
X-Google-Smtp-Source: AGHT+IHC+QiRfT/V3IsfLeampt1WZNrkqY8SV6SNTZa+PJQAQMNi/BGbD8+RMWj9AP3Mi1F0hxikoA==
X-Received: by 2002:a17:902:f552:b0:297:c71d:851c with SMTP id d9443c01a7336-2a2f2736bc0mr35603795ad.36.1766173485468;
        Fri, 19 Dec 2025 11:44:45 -0800 (PST)
Received: from [127.0.0.1] ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a2f3d76ceesm30170985ad.91.2025.12.19.11.44.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Dec 2025 11:44:44 -0800 (PST)
From: Kairui Song <ryncsn@gmail.com>
Date: Sat, 20 Dec 2025 03:43:35 +0800
Subject: [PATCH v5 06/19] mm, swap: free the swap cache after folio is
 mapped
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251220-swap-table-p2-v5-6-8862a265a033@tencent.com>
References: <20251220-swap-table-p2-v5-0-8862a265a033@tencent.com>
In-Reply-To: <20251220-swap-table-p2-v5-0-8862a265a033@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1766173451; l=2894;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=DGUAHHjNQalSID/K5uxKfa/hQdCPpXKKV/GQ5H67nAI=;
 b=CDTHqPhaFFt2+4Tu5lSmCzajCWzjr28S5y0RnqGspmj7eJ4qBH7rEslT01td9gvFD3pUzEkUQ
 Lx1LHAWT4GaB28yMAHGHOd+0+mCTNkmNgPMlJFsm26nwFwTkmdOKri2
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: A628AC000C
X-Stat-Signature: duhiiizeqe4pujngbanugpnejwf7c6ah
X-HE-Tag: 1766173486-769696
X-HE-Meta: U2FsdGVkX19ft560ThqyCr5grntRPP/mx06xANJ61JBB7Dw4YvLvOB+/Ax0Yal2DFH364xqdfPU67VA0Vgjj472jcnZ/UGs07DYzKLyKQ3tyHma60tV6ys8lUltomrWL/T6cQtuCVBxuSq7ntjMFkINVvNpXS/jDbG6E1dTcOLSBgH65sRyalJoC1KN6wGPhyr3oBBDURVByI2EFksqJJwvFtgsSthSPBeeGWCovvbi/W0s3DiTsjRJgNEb2wRpSb2WWbIc7PQCHxn6CnExxLQ8WgG/HjQpQSVunRY1iJMhlqWpK7bZ5Q/288Ezu56O1iROHGFqjrB2fnY1rtR3ybhBWVD1IOl54SwaaRJMSlpPo3/7xpRpg2fjNFeu13lvjfgKDv1Pe2W5CCYJC+VeWhyjdSqtUWsnRb7lAQEztqyHx3BsI6Qmxh8I6Cysv6m3uaHi81Ot1bW5uVqb50hwxzg8SsVHrzM602ICNNLmekSbm0Fg1q4oH7WitVe5rrRNjIo4cCw03b8A/bX7vOyJi4g6jNGICwJa4YrBCnqNTAm82h2xYv+0Sf8ROMUMOLBFVgTFY8Qr2AEZGBkj4rZU7i0iXMuirHNCqOabBrUlgIcRIRhVn3oEzauYLaG5CXgwD8iqV95LEcC1TjDR/zenrqiPrAXlXca1LHEB2dpfK3Mv+u/AZKAXnYDFeo/F1c1NkK1hO0TnSKhXELToEyWo1LGX1SQvTBNmU4VYzTF6Ni6FBVwbH5Up3sQjWcKBkyk90QP5xL02BG3dCGhU/X1F12KA9J+F83hJRC7BMrDP68nLe0qFdBV+FzB2N/ocANHD7ioufojKpST3bpES6U6IRIdwKO0dv9qhgAkeA1Luz3NlyM3Fu5jAhzK95efj82i2Wkm8gFyDSQeC68Kbv+1hmIH+VNaIf3PcbUZNLlSZi/JFMpwzKT2y2rcXtda+T3JUGG3GqVu74HqzFFRIUUgJ
 K64x5wVN
 l7uBLFM6fFgGjAAVWXoWGKUabKGpH0UpfzAPzdRxE6KeW1PjquLGqUfRMu9KFkfF6d1cfM0fg2XmKyTHyEEy08xgmrAJeUeop89ejBwsyuZ5yGl01IotTXnVpvKJiVoApyuo6HAwJcOjFuGf6oesQ7rTWBW3eDS2/ok73UETAPEkIasa24MKdSFyzGjqna0gTe9hIdcUAswfkr+NO5okef7nS2Kn6CR3UA+m7tCNerPKEzmtnmvgJVgtbaxVVpEQmQ+15fDFNwK2dJXfCRVswy9Kp9q06CZJa4BQpXnwTc+nBD5SzQXpBC5/5lGcR8P0p4W0R73gvdwIJLT+W8tDjiiQl71SeIh/7mHF7sHcoBQ8YsbKfUHophBp1g4Q3lkepwJj9OzsaVepR4BXKpgKMvUJ8no9nM9sge+nvHexgXX6xbnUQBMJPmVbWkk/Vbv3/O4xjiREpUQ6xBmiWNbDq+xFDcoIr84FwgYalt2+t8cGjDKc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

Currently, we remove the folio from the swap cache and free the swap
cache before mapping the PTE. To reduce repeated faults due to parallel
swapins of the same PTE, change it to remove the folio from the swap
cache after it is mapped. So new faults from the swap PTE will be much
more likely to see the folio in the swap cache and wait on it.

This does not eliminate all swapin races: an ongoing swapin fault may
still see an empty swap cache. That's harmless, as the PTE is changed
before the swap cache is cleared, so it will just return and not trigger
any repeated faults. This does help to reduce the chance.

Reviewed-by: Baoquan He <bhe@redhat.com>
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/memory.c | 21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index ca54009cd586..a4c58341c44a 100644
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


