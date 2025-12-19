Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F3203E66882
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 19:44:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 686646B0093; Fri, 19 Dec 2025 14:44:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5D47B6B0095; Fri, 19 Dec 2025 14:44:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4E1B56B0096; Fri, 19 Dec 2025 14:44:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 39F376B0093
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 14:44:44 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id DA8BC13AC33
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 19:44:43 +0000 (UTC)
X-FDA: 84237248046.29.62745DC
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	by imf18.hostedemail.com (Postfix) with ESMTP id E7D681C0006
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 19:44:41 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="Exs4/9CN";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf18.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766173482; a=rsa-sha256;
	cv=none;
	b=otywC+Fsru5YidWY5h5kCBGg2o9gNt7VWI8NjCwzVZSc3TvUnqFTqaS17TEDTbvNq+zMSg
	LXg4CU3D6eBhyIkOclYhPwj9DJQFd5OssbFmgPHLXxphNiGi8iJTk5ZalK4urm3mw3ToUU
	Ul3RQbXJwKJZCmtBGXybELkJAkJPMvg=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="Exs4/9CN";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf18.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766173482;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=n1CugCRqzSGuErEPW0UlHPweW7wIaQYDCBPjqUNKIRw=;
	b=CyaVyCJBctmuxguWaNRMRo9U8TWTp7E3lz2AQGIWvh6MMCmucDQdDHM3WSuRNYhON/dRz9
	4z6SCBnOQ9xfl3UHmWpAq+HkO6ZqyLWnN+QslQN4PJYWCp61Q0Q51AkTruXs/gp/9bF7Un
	d1kFbcXyeTx8d/QpCSvc7+5pVGM/aOI=
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2a137692691so24571135ad.0
        for <linux-mm@kvack.org>; Fri, 19 Dec 2025 11:44:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766173481; x=1766778281; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=n1CugCRqzSGuErEPW0UlHPweW7wIaQYDCBPjqUNKIRw=;
        b=Exs4/9CNBHGkSifbhr8GpbFoe7S4yqDQ7PWq5u7d2LFc2NsMUKKtlefyFNiw72PZOP
         Z1qwd6gUXGlCG0qsmRPDYFxfkqRV0Qci27SvK1doNRs+U+TLoAYnoWXckXWA9kzy+9Ul
         gSFVONK3GSiEJLzxfBgWQ6/fKwtT+OI5gtsES7VkeT7QFKK/QIn4GA1kfVcAsbd9FGLo
         avCfKTBbMVLo+nmD1NG8k/qClKcwlje6/DyyFl6VKt2lnFMfdUYoCcd5OeCp3/+XX4R1
         yD3cmiq62STit7msYsw6UG4EjAeftVNkL+DVxeY609dFHPlOzIHcwS0Zmbv07xMKU6CV
         EcTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766173481; x=1766778281;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=n1CugCRqzSGuErEPW0UlHPweW7wIaQYDCBPjqUNKIRw=;
        b=f3mIrN0a+VyQQsVwxfxW3HAtSRqclyQH9O7mFVeESAzwbostmQESbf3h/m6peaJJs5
         l0wk9HQ+CqQmKK6QbrUc5obdl9JvtNhGFHPBA7e1oHOJpoM8d0bRpX8sMMFXUkxDjGfw
         saNvAGdSDjDWNY/Y58x1LocIgp2rK+82x/zbZ8wapUojEHZz7tiofzODY+fNXx26uVyT
         4eKnohxLcQv4pdPm+glwRZTpLQVdnUUTAr/uwzbFs0mJRZA9uHV+SOtnzKTZuDZYpYj7
         +aJRSlOV7ZYeO649Qdbke+xCLJ9Kiss4PlDAdPmI+Odk2JeuNxrDl0GxgaSwB2NLwhxG
         ZPcQ==
X-Gm-Message-State: AOJu0YzAmXaV/ZDrU4G/GN16D5tfZZaiVh2aQDZXpHdwnRbT9Y7i6Lmh
	5uHE9cUyUPXAw/u69ELPaMowbKTuo+K35d4KLUQHt+qPBENhyXGQmRfK
X-Gm-Gg: AY/fxX7hlizpPWIqVmctLqBKBYpOECQk8qS/fdTB/fYUg8DcthJU67YqbCUqPWy+pnQ
	vSToGpNcdS+L9O3ctkNLkc9FKSvu7IFWN90WOuCD3jo76XhKEWbHxWznGCeGNJGGP5hvYAsELcV
	KJLP/dMb4iySepj7c0GDD/MxbNIWB99LWtqXY2TtjhO/e4GoI6SHe6MrmzA9UAP2ly24bxNJPAv
	M1B1qjFuTebM/Ge+ARx2flrulPJaT2cG5lRuzmzW1c2MVaypCLr4qC1ZlQpQBUM1N1Dw/yexDYu
	SpfHIUQOKge0pMIrPBg5BKY2GSx7ShGb3S2DiEHweWbD62x6A4lLvnoKq6Jygx85f7vm3ciiXIZ
	Q6xGHX6I/mh2LOGIfRHyZmhaVO3Y1CeWiOLOwmHXzXbVJE0d797dgCqcFM2TK/lp5ea8uAJssYu
	1wiQ3W0hlbmo4iiY58FlMpDCC1c1BQG5g8DJLzuvkv0JHvzAobXg3g
X-Google-Smtp-Source: AGHT+IHoRYPhD5abNYveYyW3YLlwDZTNlDKwRuJoVUUtpviXATS/D+Nb8OzDpMf9zHneBu9tdTADAw==
X-Received: by 2002:a17:902:c40b:b0:2a0:9d01:c3c1 with SMTP id d9443c01a7336-2a2f220310amr39365415ad.1.1766173480705;
        Fri, 19 Dec 2025 11:44:40 -0800 (PST)
Received: from [127.0.0.1] ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a2f3d76ceesm30170985ad.91.2025.12.19.11.44.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Dec 2025 11:44:40 -0800 (PST)
From: Kairui Song <ryncsn@gmail.com>
Date: Sat, 20 Dec 2025 03:43:34 +0800
Subject: [PATCH v5 05/19] mm, swap: simplify the code and reduce indention
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251220-swap-table-p2-v5-5-8862a265a033@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1766173451; l=4358;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=WUlfqihUv3ek+SR5ujgLz5PJkzf/2opJSuBs8ZAe3co=;
 b=5zhzoyx9NhY5k8vy0xE845tIjN0SJyVbaayX0A9+sCQM/9BpbC2Wev4bEf8+OrAh1BYgpzVEQ
 x+ACNzZBtbLDjPpCsNLDna8i2F8PX7MlhrwS7H0O5mv4yfWltV71Xmw
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: E7D681C0006
X-Stat-Signature: j3gnp5chadrwsk9h9mr3ddapk7sg9hn6
X-Rspam-User: 
X-HE-Tag: 1766173481-816346
X-HE-Meta: U2FsdGVkX18o4XgTT0tHKdErG+D25Q6vb/VQFCYUoDjPP8DkvBbTwu5MT5HatiG6NSj/qKvyP/I2Co439fGlcfLs0fisacWQiVHaoGj/SiUYxMfkwAyeZBRk03OiI9+6704m3synwfS9+d3jWknmm/J96FnbiM8khxnGbbGy2CRdxRA+QTFsvwSuBPXiYBC28WWPYH/wvpf0AejOitbWgcnrGS2TzIlIUJsPNjlBKhXaoJDufGBfPpOTdw8s2QWd9m3XHJ7+Nbn+2NB7RXyjkjk8ighvJ6qyGzl7LSOadvtgFK8qwNLKXz8QtEgOuXzSI/NLbCB+8ZMbrFKcx9iXaXqVDDsnJY2XsbSTc3HPMnV8QpbSpJXkdn6lZndZXtAOH9Dnm1y/EZSJs3uzZZDfqh9bwoeTcBTXszaNF4nZjCxgxXvND14bkMdPYirOij5Vw9wIhFw5+EWPjoDMkH/h6tV2MzNYNNhCgwvgRZioU4trPqGnQGuufV1c+lruN35ez3wu58l+/JShTZw9MxFypVIMEPKm6GKsGc9XRskBgs72Iiw3Vidnr4hSfG852PSTnrZfJu4n1iu9CEWVVpHdES9Rp35GYf4WecECG7RppWvpR4A0tSz/Ay46V1iOdMz91S/KLtboLJAu7LznQOfIX0krWOn2s9+iWq2WCV3FoPTaf+FihgwxxmCd3grkFhEwfF6Yjbccpj89donilCXpLaAvAD2sAsJy0ONPNlzVhKBFV/Pd4LJtDFlcpzANi7CJIxyrqTxjplZj+rfU5ajMedgUzA7Nww2P+SjASFQM3Oai2cNpDGU185THUIIBGggVMuS8n4kfbUfLv30zUTmf+5Ii5g2qOlkqnwd7A16No0yo3jKOo0BWwGnY8QaAjpoKGV7b/YvBtzW7pwINP8Prjs3zodrtwMepCfsd+SZlxiG7bJAhCzKnMs4UTEzBJolizCWQk7vyWC4tzn7e4+d
 1pbrWWVr
 b3Bl0c7/kPIiWO12+CLeGLs6DnI8qUTa0EEPDibyWdL2mMkpt1JxXXX9NC2jkFMEH1xRDJeak1e5QdlwD3ArGKzmXkejwsJ6I0vAYwH7ltlN3/tO7cUpFxBsDRmw5Q94u5J34igW9CaII8D9RG3IyyCTj7Ie7QFPcsPMFpw/YA/MkVpUvlxTXejWNXZ4kY0Ke/I+gjfoJirc/fdqaygLc4zFHRha4gBrenE2erMA6xvy4OHLGFWRkMIn468pgdRubl/B69rf/oyIfs3j3YYBEFG0UCh6FBRWlonbNy+WgYWNd9rUaUDbmHbZKPi/D0wzUHZtw7xZZdhrIXf7HF+stUY8ETJa6DSPZO98Dl0FqD3EYtFgQMRH7qLh/G6mKcU5Sxn2H5Sngv/xB/lA=
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
index 9e391a283946..ca54009cd586 100644
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


