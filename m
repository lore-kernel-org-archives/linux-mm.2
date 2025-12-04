Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 34A9ED2A520
	for <linux-mm@archiver.kernel.org>; Thu,  4 Dec 2025 19:30:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8E6D56B00B6; Thu,  4 Dec 2025 14:30:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 896CC6B00B7; Thu,  4 Dec 2025 14:30:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 785F76B00BA; Thu,  4 Dec 2025 14:30:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 66B886B00B6
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 14:30:05 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 16AB71A0372
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 19:30:05 +0000 (UTC)
X-FDA: 84182779170.03.1D95153
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	by imf09.hostedemail.com (Postfix) with ESMTP id 4652B14000B
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 19:30:03 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=AUxxrsTg;
	spf=pass (imf09.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.216.54 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764876603;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uX9WKXwPMUhDf2nsEW9hz+YtSdKaTQoicE44/0zqUlg=;
	b=gykJOFXRmoRg6lT2bg79OwhDsux3qLGmd/7seS8yZdsHWoJK9mmybpmnn4bbYWY++8MTTF
	TmPWhJEmrrAmE0utg7AHVQlDJAMPMlMwAPYCooD9W2aOrcFgzdjzboBEViNeDHTFhsoRo5
	kUARHNGXKK4K5I3qXjxWGylch8jZbnk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764876603; a=rsa-sha256;
	cv=none;
	b=YjMmNu5QFHT+y0UoiLtdRWCd7iLbLx2qICgmI0Ic5g/iCbctYHIyfjk6dneRVamJK5ipWN
	JrwsnrGfxFIGsa+e95J7QMM2mZlC8CsVhGW8ycdyleGvF+Dxwq/5v6gg+vBRxddeiPKN76
	T7Vk+jaP4MUstNSptfiWRXX3WZtuaZY=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=AUxxrsTg;
	spf=pass (imf09.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.216.54 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-3438231df5fso1595692a91.2
        for <linux-mm@kvack.org>; Thu, 04 Dec 2025 11:30:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764876602; x=1765481402; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uX9WKXwPMUhDf2nsEW9hz+YtSdKaTQoicE44/0zqUlg=;
        b=AUxxrsTg9arJyrqTByGqns5R1+clxBlu1p/IgEePamjCTeiL2+9I+4mmqT0LeUGlx9
         WljCYnJkHAe1VTkK0/rg6jkNoyaKF9XWSSZ5GO9DxdKE/SY/mMUF/Vs5datvn19YAHga
         K2tJ5h49BWZJtpePyFfS5XjVk6JMflhZPG4ayU6z1mGfwcLsJUla70glkQoNN+RVnAvv
         1K3QgVlEXKM52hFSSQYpYNM0CLPY0Ia8hUD/VfgCqJdBTISMa/VY14rtUCrCjGyZ2gh1
         qfw7UgFull3ycYwXiiIuGmjMfbdo4QJkP2SL2CQWnEz9slXhqfvI5+zSbcPWrFifCE/i
         m4EQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764876602; x=1765481402;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=uX9WKXwPMUhDf2nsEW9hz+YtSdKaTQoicE44/0zqUlg=;
        b=IPhTg9M4nqt3yL5sizKw+MQ2ZSTSJ+A208DvqdpmQ651MUMpTwfc0YGo41a14oHVNY
         jhVZrwpEYdw/CNFrgXGHpacsCFjATTY+MADxX7eWb8OqNJfMM5HpPwhvisWeQaFXQFto
         lKi4PociZvNTCRAK17pV5DKtHEjxDJoklAg29HeH3gUFmCK9NjjP57ltvqjn+mU2GnwO
         SAvGvZUVimjVoBPBSF9jSHpKTQcpJqNHo99aQNYprW5LaS1R6wDcPO7eDMUkjn+AwV5G
         VzK8AP2qrtZLZjQxsdUg5qVXXgahb8Z/tcmRDHrHEloMQsWbKy82USq9jJ3+YVpVsTsZ
         2CrA==
X-Gm-Message-State: AOJu0Yytj9lOq858TbyjTTyKbo1m63JX0IELMD42TZoKP3wqNbnByiR9
	/NKyvlv58LiAVGNoqAd4o/llJEmkfHG76ZfvAkKbzcX3IWXtfZWozexq
X-Gm-Gg: ASbGncvBlyqKsVIAV+7MykD82z3bdPrRVYX0UFtMSPSpmvu5Stao/vsoa447rxTuBE2
	Z9brYe7e5s4SvPVv+rd4fi5bdX3lUuRHKc/8/tENUESama1TPmqcsiXbakfiESvt+jzjSveDGq8
	PlbUCPzxVXJGwBiNzGOt6Wl8RUGU0yEUlg4iJeJ+9aAh91V9hHEGZktUeH4RA+ir5bKGk0qGyIU
	aDwBPNNeiHld1gEL9VBsTp2UfcRSducUI/MFYRwW44lW/GB1iQPHhaSbmpe/daRMgWLQgLayZOr
	DYhSRKQ+f+O48Z3ns4SGGiO2Sp1VUgHSwGcpzSDVEvPOkqdBCGFSc/X8FYo1OA8O+mS8lVvKH/f
	Nx0q1eWCmh5HBWp7QwUXe35mFH22MIDtOLL/fTQbUjZ71UHs+erWLyYIfbejfoS/oMSjmmqeFOH
	OLHvF3scwzjHFMNCUTD0B0F95fF9e8KRSYMnp+DPcKA1t4omC6
X-Google-Smtp-Source: AGHT+IFnL9Mghpe839LUCxEVjILNs9G2bsHK3lBcPCEC+WiYnmxsRBn7wCZoMetOLy4kczsXt1oQHA==
X-Received: by 2002:a17:90b:558c:b0:340:ff89:8b62 with SMTP id 98e67ed59e1d1-34947efa534mr3503288a91.21.1764876602174;
        Thu, 04 Dec 2025 11:30:02 -0800 (PST)
Received: from [127.0.0.1] ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-bf686b3b5a9sm2552926a12.9.2025.12.04.11.29.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Dec 2025 11:30:01 -0800 (PST)
From: Kairui Song <ryncsn@gmail.com>
Date: Fri, 05 Dec 2025 03:29:13 +0800
Subject: [PATCH v4 05/19] mm, swap: simplify the code and reduce indention
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251205-swap-table-p2-v4-5-cb7e28a26a40@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1764876574; l=4358;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=7VD9T4L1mbbNr1WJIIQ0GVUukfOHNZ1e5OxrzJG+X+g=;
 b=NCunfunLugw6YZ2wKhxtkhq7zcfMUiTcTJ1rfwXb5r7PDZpp2ieRFjcRZRJQ/jqRG7Wa5WzzJ
 WH6TTur95UGDtpuC+5TT7oGvNlBctI8wQp+WkMBLzjLPBgYHKzFyn6O
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Rspamd-Queue-Id: 4652B14000B
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-Stat-Signature: q75dr5p3i3f3ruamcyh431cqsaa51mdy
X-HE-Tag: 1764876603-525078
X-HE-Meta: U2FsdGVkX19ao6XJ8KYtUqDaFzBsoBWOjx1j7MkQMZykRUgnoEmQzOp/wW3xjLLeRmDH+Y1Ht0CMv7rDKwITNXKWEsYABy0QEkxccz3dQuE9OT+Q2Ui1bRJw9okDM/E4yQ3VuzPt99lCQhGy37SDEvu+GGHBONbKDpbpoy/Oy5qeYsSs5fIt47li/tfSnRCMAeO1AvZ2boun9NQ1mJAu9vqKGLkGFJZ7k1vsws1L47KY2OjFei2FoesjvQciaugYBDBGjt8TKOdjaA0ITeKFUlOrM/IahHf9GE8B+yiSOCUsYGLrEo3EX+SOTV3QUawvIdCJ5iFqjDu2c+bOaZ0CcROMkWR09CAdMqOTFWZU9bM7XcHBXideSu6HzME2319V6K2F+o45fZMMnhgBtq3T7aXuQN05mABOENqzsi7Rj2WwAuKOkOcklq2+flJ6I6kNDAF9JCPsCaM4hzU8mTZj8BoRY3By95Tkl0LyPynODB/a+BvNeeE+zJIHl6jBtuWMYSGTNqIt6+NR2z77LCl7yoKh3pBBDLgpbxKW3yNuUJaeRj0KvO5sowmVtL9Kv7QRIbZp/Cb1Idu8XIuNhXNTsksHVuUqUPGtmuk/OcXgOyPbFKFntvj5+W74yOaQLjuIssBjYgVEcO+TXj1pC+00xapO2RaOV+VbvEB+ERBo8U78RGDgd5bsU4GT3M1HBPeNww6W0gf3rg+pd0hIbwe0rttohXCbRCM63YyME6hIcl75YDQeDKqvqAMYuQIgpMd7l0MWwrkHnAo3Dqa1iwIFyLjjDZYFRCaCrtSoX9X0H7aFOGOrRVSvd1jlEZ6w7EBZj20ouTbo7t++TaYa0X7JTzo4JMnvIwpem0c4lp2wO3glM5dQNLydkPOUCd/bIxjRn9HziHRU7fvmtl54UVXu/YQrNFx6P0wNESGYuiLEW2/HQztJbP0uM9gam6CvnNslogMAdtMOeb6Zja0z3m7
 R3unqZCZ
 SOe2adBu/wFntyWgKonOhsAqDPg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

Now swap cache is always used, multiple swap cache checks are no longer
useful, remove them and reduce the code indention.

No behavior change.

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/memory.c | 89 +++++++++++++++++++++++++++++--------------------------------
 1 file changed, 43 insertions(+), 46 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index 9fb2032772f2..3f707275d540 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -4764,55 +4764,52 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
 		goto out_release;
 
 	page = folio_file_page(folio, swp_offset(entry));
-	if (swapcache) {
-		/*
-		 * Make sure folio_free_swap() or swapoff did not release the
-		 * swapcache from under us.  The page pin, and pte_same test
-		 * below, are not enough to exclude that.  Even if it is still
-		 * swapcache, we need to check that the page's swap has not
-		 * changed.
-		 */
-		if (unlikely(!folio_matches_swap_entry(folio, entry)))
-			goto out_page;
-
-		if (unlikely(PageHWPoison(page))) {
-			/*
-			 * hwpoisoned dirty swapcache pages are kept for killing
-			 * owner processes (which may be unknown at hwpoison time)
-			 */
-			ret = VM_FAULT_HWPOISON;
-			goto out_page;
-		}
-
-		/*
-		 * KSM sometimes has to copy on read faults, for example, if
-		 * folio->index of non-ksm folios would be nonlinear inside the
-		 * anon VMA -- the ksm flag is lost on actual swapout.
-		 */
-		folio = ksm_might_need_to_copy(folio, vma, vmf->address);
-		if (unlikely(!folio)) {
-			ret = VM_FAULT_OOM;
-			folio = swapcache;
-			goto out_page;
-		} else if (unlikely(folio == ERR_PTR(-EHWPOISON))) {
-			ret = VM_FAULT_HWPOISON;
-			folio = swapcache;
-			goto out_page;
-		}
-		if (folio != swapcache)
-			page = folio_page(folio, 0);
+	/*
+	 * Make sure folio_free_swap() or swapoff did not release the
+	 * swapcache from under us.  The page pin, and pte_same test
+	 * below, are not enough to exclude that.  Even if it is still
+	 * swapcache, we need to check that the page's swap has not
+	 * changed.
+	 */
+	if (unlikely(!folio_matches_swap_entry(folio, entry)))
+		goto out_page;
 
+	if (unlikely(PageHWPoison(page))) {
 		/*
-		 * If we want to map a page that's in the swapcache writable, we
-		 * have to detect via the refcount if we're really the exclusive
-		 * owner. Try removing the extra reference from the local LRU
-		 * caches if required.
+		 * hwpoisoned dirty swapcache pages are kept for killing
+		 * owner processes (which may be unknown at hwpoison time)
 		 */
-		if ((vmf->flags & FAULT_FLAG_WRITE) && folio == swapcache &&
-		    !folio_test_ksm(folio) && !folio_test_lru(folio))
-			lru_add_drain();
+		ret = VM_FAULT_HWPOISON;
+		goto out_page;
 	}
 
+	/*
+	 * KSM sometimes has to copy on read faults, for example, if
+	 * folio->index of non-ksm folios would be nonlinear inside the
+	 * anon VMA -- the ksm flag is lost on actual swapout.
+	 */
+	folio = ksm_might_need_to_copy(folio, vma, vmf->address);
+	if (unlikely(!folio)) {
+		ret = VM_FAULT_OOM;
+		folio = swapcache;
+		goto out_page;
+	} else if (unlikely(folio == ERR_PTR(-EHWPOISON))) {
+		ret = VM_FAULT_HWPOISON;
+		folio = swapcache;
+		goto out_page;
+	} else if (folio != swapcache)
+		page = folio_page(folio, 0);
+
+	/*
+	 * If we want to map a page that's in the swapcache writable, we
+	 * have to detect via the refcount if we're really the exclusive
+	 * owner. Try removing the extra reference from the local LRU
+	 * caches if required.
+	 */
+	if ((vmf->flags & FAULT_FLAG_WRITE) &&
+	    !folio_test_ksm(folio) && !folio_test_lru(folio))
+		lru_add_drain();
+
 	folio_throttle_swaprate(folio, GFP_KERNEL);
 
 	/*
@@ -5002,7 +4999,7 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
 			pte, pte, nr_pages);
 
 	folio_unlock(folio);
-	if (folio != swapcache && swapcache) {
+	if (unlikely(folio != swapcache)) {
 		/*
 		 * Hold the lock to avoid the swap entry to be reused
 		 * until we take the PT lock for the pte_same() check
@@ -5040,7 +5037,7 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
 	folio_unlock(folio);
 out_release:
 	folio_put(folio);
-	if (folio != swapcache && swapcache) {
+	if (folio != swapcache) {
 		folio_unlock(swapcache);
 		folio_put(swapcache);
 	}

-- 
2.52.0


