Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3CC45CAC5A5
	for <linux-mm@archiver.kernel.org>; Thu, 25 Sep 2025 12:38:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 898268E000D; Thu, 25 Sep 2025 08:38:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 86FD08E0001; Thu, 25 Sep 2025 08:38:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7AC658E000D; Thu, 25 Sep 2025 08:38:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 677118E0001
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 08:38:05 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 136201401D0
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 12:38:05 +0000 (UTC)
X-FDA: 83927724930.02.A7C8810
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 6692320016
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 12:38:03 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=G1UgG+40;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758803883;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mTflhHg+Amnrc4gmGWdRMi+hJzntvupMEeV0yseBNG8=;
	b=dtqdVk7lpPZUrLutEULNrxwusGzTvB5lgUPX1krxFILR64A8dTwSlIpmRtikw2B8JYr1Qa
	q8ZFakf7yfggv9rR7QganRrL9NmF1uTUd1h4OBrl5M/GAnW+24iudblfKvG+jMOaGmOQYR
	JKVGoz+BSGoeMwqkPAc8PpIKpPG2TH4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758803883; a=rsa-sha256;
	cv=none;
	b=TIeQaCXbfqk0ku6biKbaifLEMPizDMSRpVsctK382jkTWLcyrbgG0oISNMikjbo0MU1deM
	zWCqJEbaSKOiTbJLtomBdmXpmPNuKAxd3Mot7oDyIWBOjyBvq3tAmp/47iueOpe7fb3PxJ
	mQmYEGMtzdXLAWEEwIcEUYkHRSRU8e4=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=G1UgG+40;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 60FFC60555;
	Thu, 25 Sep 2025 12:38:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0488C4CEF7;
	Thu, 25 Sep 2025 12:38:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758803882;
	bh=8WHSnL4BT2wiykQ4IYUSxuEooxYTRYdEQO5KCzBE84E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G1UgG+40AKXpcD6FRJ/1mcUVkTz5uDVnl8ONHDb1dYzKmEKhkBqukKwAgdq18jh7i
	 snn7tcfn8bFIywn3ooYKfVTDEJ2fSQLZxqoZumf0/hs2BE34oR5zeQp+5M4PpIVaqP
	 xrOmZIkEk04yhY7/9no8wUsQQyGUix0dEO/ynvoLAcQSQM7vP/ufo3rO4BhH74uxfQ
	 DgkLkdXBGDx7kDY4v9+a46r97IlQ4WTRZcUckvpu72eMOtRLItVtOZq47W1kWqFBdO
	 rPBdeJaH07koW1hxFVpzAECrS0DjyA20eN392WBd2m7yYVjXt+9HQz0Vn0/3jQ11qu
	 tx6R1hMXpBgYg==
From: SeongJae Park <sj@kernel.org>
To: Alexander Potapenko <glider@google.com>
Cc: SeongJae Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	david@redhat.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	elver@google.com,
	dvyukov@google.com,
	kasan-dev@googlegroups.com,
	Aleksandr Nogikh <nogikh@google.com>
Subject: Re: [PATCH v2] mm/memblock: Correct totalram_pages accounting with KMSAN
Date: Thu, 25 Sep 2025 05:37:59 -0700
Message-Id: <20250925123759.59479-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250924100301.1558645-1-glider@google.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 6692320016
X-Stat-Signature: tr67c1co96rso9xzdyqdte1xqycpgohc
X-Rspam-User: 
X-HE-Tag: 1758803883-572198
X-HE-Meta: U2FsdGVkX18atOd0ErxrZVSVsf5bc2mURVrRkJt63PRCy0k0BAhEvHjPdNb5+dtHJai4kkVe+PdSUnvppCX9VrUE0/zMCmCQzDvyjiGTWNYn8YxVzSWMp0W776FF/PoK9j6AzfYxHj+5IWQK0u5z5TapJW0HcKf1crWEu2BXcJpfubNRkm80WaZOEzrijpi4qP5table/LBHW5IWkJpO5DUBiosL0TAnnCDwm1Z54ExH1s4HVWtm/wVCvviarpl6NpBQRZlSO4YXmby6wFlT62vfyU5yeQ5AyOnp8Nqob7mvsUKmI+j4Qt6kspxguurD/dxt6m8WgzzrywuVNhcD+ahJK/LS1m+SX+/7U7zmBFHOS6gBSyAZB3sWt/YLCTbG0ckqKcT99mOdQ2rw4jBoF/LEzhYdangcaXGCkOQtjpLYLAGJ0V5Ak34R22VKtFsm2NFruP8V7H3NRf+SYHaAbA2VFTNYDiVbDqm371utR7cK637zzFDTui/8ig64ahAB4sj4i/eDfRWKBYAktx48YztJ9SAZs8et9fE2fljUQ772mkmpYUbtodqvj8VZzy4eAfOjX5MVpgSkxLGgYMC+zAbKFYAyo8L0mYhRgeMtK1tImUTzGU2oO1bkteBUb/pnSFg+KmCmXKVlasf0D/YKBeQhRicvoPvuXVaTqMPaaHp/Pyxk+sMk/xiakfql1oDY7b+Xlct4HupGt/9HCtwAgoM523lSFhLO4jy8ZDP6Jtr18wnko0CQcMEmyNGY5mGDveZrAU0ni3ac9F7Sn+II3MhVrY2isWS8IH7YLJ6lBnXViyntQV4ySXLkGp5X1XtI8fwClg4Sk4I2maODvdVBXlirDn2VEgfLPtlAh9F4Bc1f/UDlmmWFWKmPopyiBo6IiLv0y7XrYzmZcAE2D99Vpw0ePU9QP33886TjgGy8aLEMTgiJAPtwCdQZTadCojvykULHoWFq3ZUbMMkPWvI
 8Zm8zyhO
 jMW2OEWFiDpltkSr6iwO4uLZ3E/am4BIBjjloVPEDAnQaAL8UWukhqdSt1qBgska0zT+skMg5dJYfhuIoVcrnLlStw0XhvX3rLD9H+Dt1H/FIUE359NOXH/7NlTeIQaYapxNO9tJCra+b+c2408ZrYZmcIkfyZmjzL2YUsY6ufcqwpbfRlNloB164WcOEy9mQUc4aica+JqdW2KT6X25WTIldZnS39dDMA147X+J6DboVvtsfEXk1WHHu0lypsBWJ7IY8cHFfkGslzlTpNhBhge3LF7sgkrtafYGcD/sesMEUj+nUVO1FgRTkKw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

On Wed, 24 Sep 2025 12:03:01 +0200 Alexander Potapenko <glider@google.com> wrote:

> When KMSAN is enabled, `kmsan_memblock_free_pages()` can hold back pages
> for metadata instead of returning them to the early allocator. The callers,
> however, would unconditionally increment `totalram_pages`, assuming the
> pages were always freed. This resulted in an incorrect calculation of the
> total available RAM, causing the kernel to believe it had more memory than
> it actually did.
> 
> This patch refactors `memblock_free_pages()` to return the number of pages
> it successfully frees. If KMSAN stashes the pages, the function now
> returns 0; otherwise, it returns the number of pages in the block.
> 
> The callers in `memblock.c` have been updated to use this return value,
> ensuring that `totalram_pages` is incremented only by the number of pages
> actually returned to the allocator. This corrects the total RAM accounting
> when KMSAN is active.
> 
> Cc: Aleksandr Nogikh <nogikh@google.com>
> Fixes: 3c2065098260 ("init: kmsan: call KMSAN initialization routines")
> Signed-off-by: Alexander Potapenko <glider@google.com>
> Reviewed-by: David Hildenbrand <david@redhat.com>
[...]
> --- a/mm/mm_init.c
> +++ b/mm/mm_init.c
> @@ -2548,24 +2548,25 @@ void *__init alloc_large_system_hash(const char *tablename,
>  	return table;
>  }
>  
> -void __init memblock_free_pages(struct page *page, unsigned long pfn,
> -							unsigned int order)
> +unsigned long __init memblock_free_pages(struct page *page, unsigned long pfn,
> +					 unsigned int order)
>  {
>  	if (IS_ENABLED(CONFIG_DEFERRED_STRUCT_PAGE_INIT)) {
>  		int nid = early_pfn_to_nid(pfn);
>  
>  		if (!early_page_initialised(pfn, nid))
> -			return;
> +			return 0;
>  	}

I found this patch on mm-new tree is making my test machine (QEMU) reports much
less MemTotal even though KMSAN is disabled.  And modifying the above part to
be considered as free success (returning '1UL << order') fixed my issue.
Because the commit message says the purpose of this change is only for
KMSAN-stashed memory, maybe the above behavior change is not really intended?

I'm not familiar with this code so I'm unsure if the workaround is the right
fix.  But since I have no time to look this in deep for now, reporting first.

>  
>  	if (!kmsan_memblock_free_pages(page, order)) {
>  		/* KMSAN will take care of these pages. */
> -		return;
> +		return 0;
>  	}

I understand this part is the intended change, of course.


Thanks,
SJ

[...]

