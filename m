Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 00E7AF588C4
	for <linux-mm@archiver.kernel.org>; Mon, 20 Apr 2026 12:51:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D388A6B00A1; Mon, 20 Apr 2026 08:51:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CEB746B00A2; Mon, 20 Apr 2026 08:51:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BD7F76B00A3; Mon, 20 Apr 2026 08:51:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AC5776B00A1
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 08:51:04 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 608FE140A3A
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 12:51:04 +0000 (UTC)
X-FDA: 84678919248.27.983D1E2
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf18.hostedemail.com (Postfix) with ESMTP id 277151C0009
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 12:51:02 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=g6qczxgT;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf18.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776689462;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WG7QrmBRTIxkiVXS8Xfp7FbXBMDCD9dVlS0gg72QVn4=;
	b=P40loXHY4vLlYH6y9VY2DKA76/y5sCP+iBaTeSCKTlN2OgMa/e/jX6HHOKzzKItUpmFpeu
	6SNM4DML5I7vIpGnf+NS2kBrqpS23uCJqqs86M7LUw2RtpefVMutOpg7bE9LDL3t+1b2NX
	nxmnMdqRvizObVEbCJn/46+I8E1lBGQ=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=g6qczxgT;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf18.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776689462; a=rsa-sha256;
	cv=none;
	b=1ABkVPZ4Dkp7D0BHC/Dpx+gl+FuADcbMZ9GzOD/m+hEO24hC9htRV/ubO3vXMSUha9w2TW
	d+yjN7vO3ukBzl89RUIitZfezwgJ5UoRSUkJIX3XgTqGNU4ri4Hb5jFTwQBc8lqPZnvYN2
	yG5KFmOK3k2OnmEotf4A28KLY0IY4fk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1776689461;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=WG7QrmBRTIxkiVXS8Xfp7FbXBMDCD9dVlS0gg72QVn4=;
	b=g6qczxgT/5Sr60NHgc3lg4q3VjKY+4QHC850QCWg/qabgYotOViQJq3W5P8W0Giud9zJn0
	MMISMXUx+ImbCENfCaVZSyfKWAL34cRMHtvgQEm9c0Mk6xkbMYVsl9wPD+UOZQtgXUIS5j
	PQ93b44hL8ugzDR/8V3GgwJtcwXAFx8=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-166-9NfRRgWNPwCr0nAKLTHdAg-1; Mon, 20 Apr 2026 08:51:00 -0400
X-MC-Unique: 9NfRRgWNPwCr0nAKLTHdAg-1
X-Mimecast-MFC-AGG-ID: 9NfRRgWNPwCr0nAKLTHdAg_1776689459
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-43d721a4858so2168262f8f.1
        for <linux-mm@kvack.org>; Mon, 20 Apr 2026 05:51:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776689459; x=1777294259;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WG7QrmBRTIxkiVXS8Xfp7FbXBMDCD9dVlS0gg72QVn4=;
        b=YfpOUWYt3XMGJvME1u+RZIzUoSFmcS8qqa+yXqiNm63XRtNDsN7gsZ7Xvx2n7TDcXv
         CBq3/21OO6TL9A9VnQOg/m9ZVmwLrqD/Y/I3zSvT4uR+NZ7MpA1LFo5lkUK+JWFv45Gn
         yrm2znTRjGU6qUoyP5bQpe65lvzJLEY0/JBSq075cv8XV0bZkmGzM4LZdqK9Iq8nrrBI
         DZihHAxlJsYCDWvo/znR3GiUgGhpq54l2SXNvKp5cNwHc8oN7cSPHntmqAUazFx5cGBi
         wj+JicYh5+lEnV96TK82wtWQDVSR4XslAybpPm//ty9+J5S0mjLLh4X5UYBu4A8DYVGD
         uBTQ==
X-Forwarded-Encrypted: i=1; AFNElJ+LTMf4hWkZ7nllHhiF9mJf3wkFRD6x2bLqOvytEOm9g3F3a6GQ1ST8R2JIDCKCNyDZEp3i6hbkTw==@kvack.org
X-Gm-Message-State: AOJu0YxZ+iEvXkNPeEsjiUuAXqgXJ+N8rfkDJ69xxVp5PXFfUuuEQpSi
	Kgnqyd/sNfd+7U8U0Z3VAtiJBT9ctQwWQ3lMJA89NsuEXvGcUPj+VoR8qiPAIw3/hDvdqOql11d
	RYjm9mBwNpsyOKWHMlbw+EkGJUeLD2+eLengEATKlY0NYPfaHhy8p
X-Gm-Gg: AeBDievIuqcOfNB0KlezLvVmQFxnrSdRmD3tEqTgfGqEtF2hha47xNMVTlxNwjeLC4+
	XwpHloz4dRQBEmJC5sR7CJGBvqB+AByZ+buDovz+zG/q0/GAjlAVyRHoXARhOFM/GdgPoL+E6D0
	yVJkrsMC7b3Eo7cdvR0G+Yp+YosWBqIi/+x5gkiUFAho+jPbI+Z0awaDz8aXcalCMqagcz7qaCq
	yVU6EvIhrjb81/Wrd2H3c6hb+x+7+hIdRnuSZHLsAmCFyFojBMowwpgZVtJfDc1GNmXtqgLFukz
	bkRVe3V52Wb1IcbXa+S5aBNKbrF1qO/Oih1GleNsRj3KY8xfmzsWjd3uEah8EUwvL+j+sDujS25
	Ff4IfjOp5YsuLIguigaeybGt0PDMY3Uue34Sqjq7NabaenGOtp607xA==
X-Received: by 2002:a05:6000:184d:b0:43d:e31:68d1 with SMTP id ffacd0b85a97d-43fe3dd958amr21385890f8f.21.1776689458828;
        Mon, 20 Apr 2026 05:50:58 -0700 (PDT)
X-Received: by 2002:a05:6000:184d:b0:43d:e31:68d1 with SMTP id ffacd0b85a97d-43fe3dd958amr21385818f8f.21.1776689458282;
        Mon, 20 Apr 2026 05:50:58 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-25-21.inter.net.il. [80.230.25.21])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43fe4e4daf2sm28270624f8f.33.2026.04.20.05.50.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Apr 2026 05:50:57 -0700 (PDT)
Date: Mon, 20 Apr 2026 08:50:55 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Brendan Jackman <jackmanb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Jason Wang <jasowang@redhat.com>,
	Andrea Arcangeli <aarcange@redhat.com>, linux-mm@kvack.org,
	virtualization@lists.linux.dev, Lorenzo Stoakes <ljs@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>
Subject: [PATCH RFC v2 13/18] mm: skip zeroing in vma_alloc_anon_folio_pmd
 for pre-zeroed pages
Message-ID: <551567632643dc1b5cdf08284039aeba0b296b6d.1776689093.git.mst@redhat.com>
References: <cover.1776689093.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1776689093.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: uBpTsxSRSeWc9XOP_xgIIA9mzngHY1yCEX4xTyHIBdI_1776689459
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 277151C0009
X-Stat-Signature: 5crz3ixqsddermqdce5pyrrq343ctx8j
X-Rspam-User: 
X-HE-Tag: 1776689462-186123
X-HE-Meta: U2FsdGVkX1+8XguqA85rf6FVvkTQ7e6J4ugfjxYAcC+mwiFufL2zriqTwjsR6tITBbh+sl2TouCwQ5xz39FcCc8VicxUZWiL5/7nvtw2L+82ZthD1QaBJ77zbTmKy2F2i953pA2bHX6IvhP1EOktj47M1gXSSb9qSPk/iCtGMXKZIkvc/zlz7BXDka0ZQqe6hfM9gi0RDwnvrEVSv5+J6ygUpMwj9YM7BaYrtIZLgD4dcmRDRn+GGR5iCR5NHA/MBj4Cx6KJItkzue5CEy21pxqvjdEOfPTinI1dBs91OVr4/aGXuZzTg1eKvoFJu0AuN1xzXd4zuy4tv3ghT91gYuKw62psHJQiWy1eObn0tJW2ie2nMhY5JkdDER5rZel7R6qz19a4BxMO5x1YKbQmjwjcnGUiu732vJe05bSZwbCVS5ZYrmqBsFKxHPalS9b3X4I+T/N/VuZYjPNXg2axqTPO0crZmxLHFd+v9n6tT/3iriM/btrCbwuLIt05bMcxDk3JtJZdj1t/2YU7h0s2KIjym4jzg5SKgOi73iP5Ff4ghdOWy+ZXPvZYZkj64usj7JnTb4pkXgA5YrlhvVyym8XkXdwZvPKHWQtpM2akye3MzyKngi6kLYzJQpd3rA5vB//+j75MDU2TlA1tz5O4lK+ayTrU8WbtfRdxEbrULAiIsha+x6Ra2XeRrcibir5X+d3RUp4R1DDtiktZBCCnm/9s/YoozkyKi5np41RRrJr3oWeIJvjmYVcf9xE1gUkE3jRX2MXM5v/+Dud2nGH19pQPjRn8GZJWxDeR1Q61zgkUz3RvMhZVIs0aQCLiHAfKJh3PyS0bu10k/oSCb9HJjh5uunITzQLiwPEiquZa+xfxDcalSfUBNER0wEu0KncTz6vFJaOqMtFYfDPoZ9AzEihEVf04Cj3xqo4FGkr+VdEG/S/NnGyynl8KYMro0SrY+XhS/QYsifXx2OvKIQp
 D9kNiZnK
 WKwMZZZA+UJwiz+w3aOUL9xIIHGtHJ/jS1pzLvi3buZDXukvV0EAd0xMWV+1ym5+2MoKgH6ROSJ8JyAssmz+19ILg/RjXmK20gcPnTq0acDEijaq9Ww2Y1XoGcQ5ZGCzWVnSaLF3naFoxnLpnxRojFQDPaa4DGvUvTCyYwIBYeNgLqVP90onMy74QiE7td7GUEnngZYE2ftqXKjLGkvomUoE3I9lHhui+MidCmwWF/Kcg6KtMROVkp1XBMbBV2DNZBBkfFSMSvG5Carb/02hAWHIpJWV/NrUmrvACvKeL761X90o3nDEZBJ76gxG6os3Pra16eR90rU4P9bQjta7ZOdPl/HKTpYvk7vl5CzZzs8Vp0oVa4FIdS//qsA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Use vma_alloc_folio_hints() and check PGHINT_ZEROED to skip
folio_zero_user() in the PMD THP anonymous page allocation path
when the page is already zeroed.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Assisted-by: Claude:claude-opus-4-6
Assisted-by: cursor-agent:GPT-5.4-xhigh
---
 mm/huge_memory.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index b298cba853ab..243592452ead 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1259,8 +1259,10 @@ static struct folio *vma_alloc_anon_folio_pmd(struct vm_area_struct *vma,
 	gfp_t gfp = vma_thp_gfp_mask(vma);
 	const int order = HPAGE_PMD_ORDER;
 	struct folio *folio;
+	pghint_t hints;
 
-	folio = vma_alloc_folio(gfp, order, vma, addr & HPAGE_PMD_MASK);
+	folio = vma_alloc_folio_hints(gfp, order, vma, addr & HPAGE_PMD_MASK,
+				      &hints);
 
 	if (unlikely(!folio)) {
 		count_vm_event(THP_FAULT_FALLBACK);
@@ -1279,13 +1281,7 @@ static struct folio *vma_alloc_anon_folio_pmd(struct vm_area_struct *vma,
 	}
 	folio_throttle_swaprate(folio, gfp);
 
-       /*
-	* When a folio is not zeroed during allocation (__GFP_ZERO not used)
-	* or user folios require special handling, folio_zero_user() is used to
-	* make sure that the page corresponding to the faulting address will be
-	* hot in the cache after zeroing.
-	*/
-	if (user_alloc_needs_zeroing())
+	if (user_alloc_needs_zeroing() && !(hints & PGHINT_ZEROED))
 		folio_zero_user(folio, addr);
 	/*
 	 * The memory barrier inside __folio_mark_uptodate makes sure that
-- 
MST


