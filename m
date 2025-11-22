Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 29B47CFC51C
	for <linux-mm@archiver.kernel.org>; Sat, 22 Nov 2025 09:03:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3EF136B000D; Sat, 22 Nov 2025 04:03:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3A1186B0010; Sat, 22 Nov 2025 04:03:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 28F736B0011; Sat, 22 Nov 2025 04:03:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 160B76B000D
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 04:03:56 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B8B5D1A0775
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 09:03:55 +0000 (UTC)
X-FDA: 84137655630.12.215D39B
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	by imf28.hostedemail.com (Postfix) with ESMTP id D7202C0003
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 09:03:53 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=kFlyxrnJ;
	spf=pass (imf28.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.216.43 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763802233;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=gWSIc38wakQFkjPaEOd32h4AOI7qtYUllCcYDLleeHs=;
	b=rcl5/8R5nRLzuXDYntGT8A3grET6v8i3sHqGlJXjZMKL+RyfoR/J4iaaXTNzfK52iGN8XE
	UDeV991eHu2aERm+P8h1Zi+kvQWN7t+dqkJ4txDzn1uZ/3234F7inYewq6iHDUdqHXhTkW
	BKTAZ9dGvJg6vh4W0FsAs2zoGJnVggQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763802233; a=rsa-sha256;
	cv=none;
	b=ZQCADpbeGNlTWG2nNDQAun9zyZmyUy9loFRef9etHnOOeOXcuVXpxlEr1/P0uA64fIkv9Y
	t9pacHgDZ0Fse/mzY4ZiGsx//nZN92zFdDO2b+drAbOo9c/2OTMMB6Jb2XdZ7VWnA65tpj
	L+NOdgj3LdW/A2nh+ilZlhl2OMnHmBo=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=kFlyxrnJ;
	spf=pass (imf28.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.216.43 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-34101107cc8so2481058a91.0
        for <linux-mm@kvack.org>; Sat, 22 Nov 2025 01:03:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763802233; x=1764407033; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=gWSIc38wakQFkjPaEOd32h4AOI7qtYUllCcYDLleeHs=;
        b=kFlyxrnJ1HiI5f0sbrm4WLz0loIQ1R/MjkA0en4yEEN0n/2HsDKTc5crdjEXxcKHMz
         plUYxsDqGOJKTYd6gbbP72CZNU2NunUxju3Hvq9TCY3TClCPnQFCAUOYu+z47MUUQxa8
         u4n03JspuHPmn7L1PYS7UZZfHTcj3lZ3iHoWssMweDH5vd4y+q8xuAyTmMfohD4gQ06j
         kEdb9Irp9RisMTEW7M/TuevCo4cyIp+Jn0adSyRTRqTKtP6FRztPfL2/019EHAArlOig
         0PX4HLCp7O07FFT/wA0IHtEcimdqnxkBmYXOvQcrWl/Ytzahh3/gpYTAVpyLEIYvMNPt
         zdDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763802233; x=1764407033;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gWSIc38wakQFkjPaEOd32h4AOI7qtYUllCcYDLleeHs=;
        b=Oi9wh+JVSLHaeLBkPUmMMoqfXL5TpTQrQwFCPhZNJMngZW3ooV3YffE2fRkcml9pKY
         HKkK6Y/3itKtdRMbqDNVrJs8N13hnCXdAOBUcM0NRnslj3t4wRZ0Ohtr0mcrAQzME7Ux
         RJdb16KepSxc27HLWwKA2ZM+oOuDzyhyHus+YkAZ92bpjpGk++9YOI7o8i1AjcYkFcia
         j2ykAvYxrO1NRJmvxSEqIteGE7AyqbHjf4I82gd/VMVqPwBdq8QZcF7Wz7ysznukEOkw
         +68sqArw8twJDgpBtMTjGjQo+4T5C1gaslh6XilXT2i14xs5KY1sxLrVirLAghAwGHPh
         pnww==
X-Forwarded-Encrypted: i=1; AJvYcCVHYFT+5/dDsr6LHVq/kQFdWMrdePtf/vw70mwJ8pj4gJPlBdFat5nEHos++v6xcy6uSlJxL700Og==@kvack.org
X-Gm-Message-State: AOJu0Yy5wfsDcrkWSrFTaHgH7wIcioe66yaUSF2DwM6ePhJNy8uw6HxG
	T7+RzflKnu/VKVVOCynjKYopddjRRr5Tv/HfPlmEdAGWcHhfFeNtsli2
X-Gm-Gg: ASbGncu/BjTu8CnP82PrcKnEudA7KzrtCLOWRP0W38tiLB3Ta4sBeBmIqVGC4hBp4Lk
	Ox1rnvg1llpZfaQKvEqHqrVFTITzlHtnrngB2scF9i5cy5PtXQypV4e8rE0WzP1iX9iHYOc8z6L
	V7rOZpTSncKFEEj9PkwLowgn9lN9/yrAeZpoVQZY119ac7d2hJNWFTptZBPMAJyDyrmynlGrRzs
	qOiFrbZavy+aZMq3/ygoLaK7tsSA5OXNR1nFHZhACVS5AewJAyOSBqgw1pAbMgSLyJGXR2Y90mz
	V8OmCBP1LpoMfuUNNpTva/dA7kXxOgrdmO/1S9edaFaTQ3sCWgnSE0srAXGtbZlSkTu5N0jZF5Q
	PW1k3KOmSq7R/+QDHZB/tI53niroYFl+mkNqzrXFZLpZQOzjOJFOOpY8vVSPt7YchzqI+wVYpiw
	t7N6DWaSDJIJzdaRDxQndbr/6r
X-Google-Smtp-Source: AGHT+IFEXYWimQk4DcIAFQyt9lEPKtWhsqJCLh0YYLXBxKfxO64RbGZR0X6+cGmFQNdZPcXXMZdWtg==
X-Received: by 2002:a17:90b:540b:b0:33f:ebc2:634 with SMTP id 98e67ed59e1d1-34733e78ea2mr5873399a91.9.1763802232568;
        Sat, 22 Nov 2025 01:03:52 -0800 (PST)
Received: from Barrys-MBP.hub ([47.72.129.29])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3472692e5c8sm7842401a91.11.2025.11.22.01.03.48
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 22 Nov 2025 01:03:52 -0800 (PST)
From: Barry Song <21cnbao@gmail.com>
To: akpm@linux-foundation.org,
	linux-mm@kvack.org
Cc: linux-media@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	linaro-mm-sig@lists.linaro.org,
	linux-kernel@vger.kernel.org,
	Barry Song <v-songbaohua@oppo.com>,
	Uladzislau Rezki <urezki@gmail.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	John Stultz <jstultz@google.com>,
	Maxime Ripard <mripard@kernel.org>
Subject: [PATCH RFC] mm/vmap: map contiguous pages in batches whenever possible
Date: Sat, 22 Nov 2025 17:03:43 +0800
Message-Id: <20251122090343.81243-1-21cnbao@gmail.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: D7202C0003
X-Stat-Signature: 9aojt79n3sy5f3p7od9rw5ja5d8og6ra
X-Rspam-User: 
X-HE-Tag: 1763802233-184161
X-HE-Meta: U2FsdGVkX18Fb8R7gD+dthUiwJ3Fr0E875FDXC5JHpJrr2Z15B91oU2cetprVuUGb63onaLFpxUUxJ1eLFjhCR2maO/KXbmSS9E9DPfN32Zh4mV+xc2HNmKBg6s/0LnBosjWsLbMRFA0IhXJQilrGMKCW632f4M9QENmf/Hxxk0GRfWc8+pBwRTqM3a/tQ1ngcsMnmc7z21Ivyveyf2Cysj4uXzdV15Qf6e7G9VP+E8yEJoy5zyBDj/RvKQqgnsK4TTTzZ430M8gBeydbITks+LIgwhWoG2WtjmhQ/ix9+Q7s2Y+5bpQCI/S1W5XiNRtS6Z3Pa0DTSwS+9pKnxiBcMRYngMKWxo++bgPsUICgsp1wCVhNQB5URxCIrTeemFnFsvXkU0QSoXeEi0VbnKA9XXszAm9ZAvrJYDx73sGKxiHw43xltylaliKnT3J+K33mTGVQXKXZUNvBCW6pDJRyB3agOGp3NuxpHi8JD713jcmRB08uBDcC3oLU/xNJ/uBIojNbw6TxOL5ikzsgPqhadSXIK0TypFzFKIhf/Um/RCB2S0XuAIkc8kymvqLlrDTgFq9ZFIj1q5IQryyVadAOwBDi5s83E8r5QDJx6szY4nZk6TxR2/ipfrXD6QKXbvjUXIKOnhsAcGfbIgbIXzN1SCMTx8HnoiNZHCZTs7cWKfhIY2HHvs7DgjIGSTIdZu9GEs8T2RxXsFC9qCg2ja7RyAoAf2poP3JrwgBsc9siffPGufWkZ6KUcYd4lDqeamaLhsELJgL4CfCyPGer+lbG4kW18XR6RhVchog8h96l7j5YFbkqJp46+uleKtuYGLxrS8l6pK9Pn8NO09tHkNskLGyM+8wBY32I86cK1vldd10lEVNYOOMz2r0EXGeuitzqnTQ9YRtp0ctarBib4liE/9YD1mtNYD9mt1p9VpN9ZGR1bd/0lg1tBviQPGEzbiaslUcmbOZkEVQDJNfrhm
 tbBXuMxP
 BO5BuWQWLXAckREJ6HUKRURLzAekbvc5bVri//BXxO4B0NVbbDkh8Xa//LjFST4hAsBt0jvbSy+1CBp+8k6EbyYzjqGO33rUDF7Tc0iN2mCZ6eqj6QygVpJpDaSOgihiFn1fzIfP33FIL+QxxSnp7KvbzEnmFRTPw9G1PYvo6fgrjnahrK4+y7qBo9nVwZODliiqKubXeP/t02PlnliMFPm8zmmskSRsgeDLjUtjyN4RpncOKzRxJJGrtWDruBNRqKehMYPK8aPPzR8P/1WxcIesmXgehv4zxMQQqoOmdzOyCX9Zb4qDGucXGf4NRZpdMIhxbEB88Fr95eU99FzI+GXdH5yjwZwaah9gDnb72XSeLS0/if37jVy3Busv6NEjgXTsq2Hx8yuXTouwtn1EYyfozeGcenjt+jPZT/73NArJ1iJSfNu0cioXl02cfvViJmUF/N6m15eY31qc2ApFhSNTOSzpvFMdn2vJ+SEeBkovhKPisadYFfMSD7uOujPvfd7Vz3CcG5vJWCak7Mc6xjIyErtsSGxnb+7/SB6ylFmR3y/0cyPH/gihrfT+hHUfXjlPdUaR4rs6k45c=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Barry Song <v-songbaohua@oppo.com>

In many cases, the pages passed to vmap() may include
high-order pages—for example, the systemheap often allocates
pages in descending order: order 8, then 4, then 0. Currently,
vmap() iterates over every page individually—even the pages
inside a high-order block are handled one by one. This patch
detects high-order pages and maps them as a single contiguous
block whenever possible.

Another possibility is to implement a new API, vmap_sg().
However, that change seems to be quite large in scope.

When vmapping a 128MB dma-buf using the systemheap,
this RFC appears to make system_heap_do_vmap() 16× faster:

W/ patch:
[   51.363682] system_heap_do_vmap took 2474000 ns
[   53.307044] system_heap_do_vmap took 2469008 ns
[   55.061985] system_heap_do_vmap took 2519008 ns
[   56.653810] system_heap_do_vmap took 2674000 ns

W/o patch:
[    8.260880] system_heap_do_vmap took 39490000 ns
[   32.513292] system_heap_do_vmap took 38784000 ns
[   82.673374] system_heap_do_vmap took 40711008 ns
[   84.579062] system_heap_do_vmap took 40236000 ns

Cc: Uladzislau Rezki <urezki@gmail.com>
Cc: Sumit Semwal <sumit.semwal@linaro.org>
Cc: John Stultz <jstultz@google.com>
Cc: Maxime Ripard <mripard@kernel.org>
Signed-off-by: Barry Song <v-songbaohua@oppo.com>
---
 mm/vmalloc.c | 49 +++++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 43 insertions(+), 6 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 0832f944544c..af2e3e8c052a 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -642,6 +642,34 @@ static int vmap_small_pages_range_noflush(unsigned long addr, unsigned long end,
 	return err;
 }
 
+static inline int get_vmap_batch_order(struct page **pages,
+		unsigned int stride,
+		int max_steps,
+		unsigned int idx)
+{
+	/*
+	 * Currently, batching is only supported in vmap_pages_range
+	 * when page_shift == PAGE_SHIFT.
+	 */
+	if (stride != 1)
+		return 0;
+
+	struct page *base = pages[idx];
+	if (!PageHead(base))
+		return 0;
+
+	int order = compound_order(base);
+	int nr_pages = 1 << order;
+
+	if (max_steps < nr_pages)
+		return 0;
+
+	for (int i = 0; i < nr_pages; i++)
+		if (pages[idx + i] != base + i)
+			return 0;
+	return order;
+}
+
 /*
  * vmap_pages_range_noflush is similar to vmap_pages_range, but does not
  * flush caches.
@@ -655,23 +683,32 @@ int __vmap_pages_range_noflush(unsigned long addr, unsigned long end,
 		pgprot_t prot, struct page **pages, unsigned int page_shift)
 {
 	unsigned int i, nr = (end - addr) >> PAGE_SHIFT;
+	unsigned int stride;
 
 	WARN_ON(page_shift < PAGE_SHIFT);
 
+	/*
+	 * Some users may allocate pages from high-order down to order 0.
+	 * We roughly check if the first page is a compound page. If so,
+	 * there is a chance to batch multiple pages together.
+	 */
 	if (!IS_ENABLED(CONFIG_HAVE_ARCH_HUGE_VMALLOC) ||
-			page_shift == PAGE_SHIFT)
+			(page_shift == PAGE_SHIFT && !PageCompound(pages[0])))
 		return vmap_small_pages_range_noflush(addr, end, prot, pages);
 
-	for (i = 0; i < nr; i += 1U << (page_shift - PAGE_SHIFT)) {
-		int err;
+	stride = 1U << (page_shift - PAGE_SHIFT);
+	for (i = 0; i < nr; ) {
+		int err, order;
 
-		err = vmap_range_noflush(addr, addr + (1UL << page_shift),
+		order = get_vmap_batch_order(pages, stride, nr - i, i);
+		err = vmap_range_noflush(addr, addr + (1UL << (page_shift + order)),
 					page_to_phys(pages[i]), prot,
-					page_shift);
+					page_shift + order);
 		if (err)
 			return err;
 
-		addr += 1UL << page_shift;
+		addr += 1UL  << (page_shift + order);
+		i += 1U << (order + page_shift - PAGE_SHIFT);
 	}
 
 	return 0;
-- 
2.39.3 (Apple Git-146)


