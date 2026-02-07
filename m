Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DAE70EE0AE9
	for <linux-mm@archiver.kernel.org>; Sat,  7 Feb 2026 17:37:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4549C6B0092; Sat,  7 Feb 2026 12:37:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 435816B0093; Sat,  7 Feb 2026 12:37:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 32E226B0096; Sat,  7 Feb 2026 12:37:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 209F76B0092
	for <linux-mm@kvack.org>; Sat,  7 Feb 2026 12:37:35 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id ABF85B97A1
	for <linux-mm@kvack.org>; Sat,  7 Feb 2026 17:37:34 +0000 (UTC)
X-FDA: 84418367628.26.A4E0EB1
Received: from mail-lf1-f43.google.com (mail-lf1-f43.google.com [209.85.167.43])
	by imf24.hostedemail.com (Postfix) with ESMTP id D9C2B180004
	for <linux-mm@kvack.org>; Sat,  7 Feb 2026 17:37:32 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=SB+L09R7;
	spf=pass (imf24.hostedemail.com: domain of mikhail.v.gavrilov@gmail.com designates 209.85.167.43 as permitted sender) smtp.mailfrom=mikhail.v.gavrilov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770485853;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OBcixq1sa+YFWzLNdSovpimwkwmojM9gmgxcC+Ozzp4=;
	b=XCxWX6RC3dAYLrjd+GktR+RdtQtwnEYk0D5pqO7LCIfHDY65Cz1VAodZalxHVsQvAz8h4m
	Q0BHmNc4guwfq4/62KYdm5p9wXPNRcTfbLKQPFv7aakdRXG6qO0W/aVhLf0YKu6FjMUhE9
	FbYPQJJDgm5ktuaLDWFH1hUtOsKQR0Y=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=SB+L09R7;
	spf=pass (imf24.hostedemail.com: domain of mikhail.v.gavrilov@gmail.com designates 209.85.167.43 as permitted sender) smtp.mailfrom=mikhail.v.gavrilov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770485853; a=rsa-sha256;
	cv=none;
	b=NRAZJ4sARFtYcSHQmV9DVpOzcMX0cQBxzoZAw+MjUyAYYq5wLgUPXAOyzvxXfGZU3hLDaX
	guOApt6gxLCIDyQqN4fSvcVsqUZdBtOVDR+EbDKSibEH+QJLd1Lztl+4p8AEg3RqAEZ5cC
	TYiM9yipxHpP+O+vWgxQRC+XrPh5F1I=
Received: by mail-lf1-f43.google.com with SMTP id 2adb3069b0e04-59de0b7c28aso3734843e87.1
        for <linux-mm@kvack.org>; Sat, 07 Feb 2026 09:37:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770485850; x=1771090650; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OBcixq1sa+YFWzLNdSovpimwkwmojM9gmgxcC+Ozzp4=;
        b=SB+L09R7I+4D2RyqVdhD8RS+fkKPEdH7wKUU+fK6P+Ld9MhjirJBgAgJPrKjrIXWfw
         e90lLBg3HZojZZl7+82FvuyGcltJdsLfk9FuMPHzfBc7Y2qoBNCf2tNlbr0dm2V2Zgb3
         G6YTTGDTwTal+97ZTqWh8BPm2vCFXEnWgxmo9bPHcppx5oBzniITJwbPZHhs62qY0Qmq
         2laQJgyNnog4y/crcYK7RyKYGlERs2rHTu56VYt1ljcdSBwZs5C75q1u62htWxQ2Bixo
         /LpOAcK2k/m0954kQ+Qun6ZagHyAiZvS+c6tbWyhcdEcYqp9VA5TfGZDCjnv/FMTduWK
         1g8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770485850; x=1771090650;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=OBcixq1sa+YFWzLNdSovpimwkwmojM9gmgxcC+Ozzp4=;
        b=WmodIcfvEWXoQTytuyuHJlSyLQnlGDfAjot575lXnVdFB8CNz2s9KaKvDl8ZKXQawM
         +UagLPBazDbbuHK1k9WBbhyyxh2U/NheeiDfPBI4y747sIuyniceB5Ydh+p8m5JPH2gg
         wvfsPafvZgqXpE9o58HW2owWE0Nn0LicE6FVnHfomjLtxz1tiWyFJP14I9tIHwb7b86Z
         Trv5Yh4RSk6S/4yH3g6QmgrjIUjVPIisNgX8YC8c5WwGvBsZuBhgCEhJ5KAJtoVLCn0m
         xAzGy+zwx3ac4hMKcZeh7B8ck5aPvNdzVoRNtW6Bh9Mk5ZhawXJug5/9slW/IOK+JTn5
         crbQ==
X-Gm-Message-State: AOJu0YypSApU4lJR5uqZGoVMlEAOpwe5o4WEIEM5evUgkY/wu+rb7VoJ
	ku7oTHnWk7TL0zTfGl2P8aa+358pDxRoZTiT73ZcquSkcEz+CNbmQiU4/PQsFc1h1VKr6A==
X-Gm-Gg: AZuq6aI2/dxyced3SGTvtWOkqRnaG5mKen7JBPr09L7CmLzu13oczJsbmwdUd1QVMdo
	GYsXUFOfs5q8/0E/EBxO1AKvGRl9k0YJEZcbeqCdSKU4JoCuOlbzwKCjBVB1FS/1ytV2If5Cb6q
	rPDa51csQOi9RwWlgAG7NP2BZyxQUjt5yWSFlzp3YudyNK1sVjSlP1ClSZj0ETQphZmIUOnMAku
	ixscR7eUrPVPiEgehhtPcsR/x2zfaC3eTbNQ0oT3tLLFqXZQ2Z7oqk+idSaosqmEFadWvpDMJYq
	jrY4PF6fHkHOJQdzKdfFhbYCqw3JjaUwHnNX/Hs4u3qdvCg2otG2SiaSN0QLPu/jfcDjWqyUgib
	+5+ntwIrfmQ72LzIaLYZdBWTGlhJQJvmuJEoA+VK2qeMPlmlvfKOirjRnqFlgenBSh73Z5z4zUl
	Xmz2qDUBOg3h0y0jd2UiI4Rw==
X-Received: by 2002:a05:6512:3341:b0:59e:a2d:daa1 with SMTP id 2adb3069b0e04-59e450438bemr1745187e87.5.1770485850237;
        Sat, 07 Feb 2026 09:37:30 -0800 (PST)
Received: from localhost ([188.234.148.119])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-59e44cfd475sm1405628e87.29.2026.02.07.09.37.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Feb 2026 09:37:28 -0800 (PST)
From: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org,
	vbabka@suse.cz,
	surenb@google.com,
	mhocko@suse.com,
	jackmanb@google.com,
	hannes@cmpxchg.org,
	ziy@nvidia.com,
	npiggin@gmail.com,
	linux-kernel@vger.kernel.org,
	kasong@tencent.com,
	hughd@google.com,
	chrisl@kernel.org,
	ryncsn@gmail.com,
	stable@vger.kernel.org,
	david@kernel.org,
	willy@infradead.org,
	Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
Subject: [PATCH v3] mm/page_alloc: clear page->private in free_pages_prepare()
Date: Sat,  7 Feb 2026 22:36:14 +0500
Message-ID: <20260207173615.146159-1-mikhail.v.gavrilov@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <209207FE-D3A9-4BE2-8DA7-9BE38A19F387@nvidia.com>
References: <209207FE-D3A9-4BE2-8DA7-9BE38A19F387@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: zs47ei1ph4oy9sm9zo4domjrkao93sa7
X-Rspamd-Queue-Id: D9C2B180004
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1770485852-803544
X-HE-Meta: U2FsdGVkX1/VO1KGyvCBtNtvr5NTchPDJUhWFzDSLBGbManvrmzUlLnPCe8BS4Mgtb5nIVm3EWcuG9vCVnESJlyJ/JMZiFYlD7TWnXGaEpeLMtgWK4wdmkZkqCCO9ePSPcoWt70iHMwm3bPQ4+4lu9k81znqSjzLsnrPSKV7UdpgxqBruQFj3AAxkFxCQc4LGVVsvzZ7sAAI+mX9dYStO7PCpUxIhKwM6mfnki79cwVabSmdamPVCKLQeGALpJXKAO9zYU+IDH6bWrkauqgzEdNqRH5LDQuBpHX6w+YILX6P2HSqHaluhOK7vmrMD4MqLko7s+Oo/9him/YTLMYid3nCVgiGzF8a1/oMDWvJywqEHQYu4EWwl9Bin/ANjcGI6n8dcgvuFRWw1sKZoSMkcfzm+1t3s2cxMJmBOUw2bA+VgzhTT3ZzVkNiucbE8HDKWvZcoAa0SOGa4RVyA3vwqI8PrBvqrOq2+uqp3CROnWiU/OrfF9MmvRNBBQTcBbuBSrgNYVQogyViGktkqDXEYcuc3Dtsztl6ASUt/sbcJgnTTSTB5HY4LFpr+9FUMEST8flmPe1gFcoN8Fq7V90lxny8YY9aK4Xgs8K6FuYedNSftplOmcDmzijlErZ6K2VoEJM/mXLn7SLV8T1DR8dIi7nqSA2iuzi7s79G5XTmP4sldrNxC0UxZ1aJ3YJDgh5mhVeZP2cJIozXUQtnxKdupJwEh7xSWQZKfGksCL37yVGgeLhFO4x/kC0owSQFITbtEC0zvZp9MItD6xGr6FEsfIyTwUK5ExfaWUAURoWewrAiXneWimlx/Kcdrdo/ySa+4ASpUOIm29EPjd+mkDuyPGSSTgbdbZsCQrMUlnRQMt6lyiHb/CNf7Dy8y4B/gioCCRePFZJ/kUL1P67FgnmfPFb+m/Zt3kwNOspf2X2QgixGHYm0e65Pp/7HeozKKEO2OZfNjPtiNaxrCIV78Hk
 KA6IJOyu
 bSWkzy+DmR8Sj1qixluNmY87SSWp+W7wQ74DeFmyMGVBB73N5Fg39mfPm0myyIzL6WxIj956yAhRxNzWjoN3zjQaXz157EUTU8rWEXo8/8qvVoSxGAbeK6stpmy3pRBXNniPyKYt23FOGWo60Iy2Mn4lA55ZwrbbOtf0HMh8z0OqSbqJW7RMjE80c7RolV4DQ8Whp8nxO1mL0oWQ6Su7IgMYDfMHnK2kX0qlcQdOlogMxViRmuUDTVLSXAd2owF4zCBR/I5jqqBrnlM56YzPooCwHvT6Zj0h/g5hmzVaZpwgbbqIjFb+XfivRYlieGC8XweloVqyXFWKL4vzj6t1GwBXlqUqtK7Rg2prKShaeMzC+UsurL0UnsFFaQIIwf389XdpPGNQrNEH2D+xhzn8wRc0+Ym0KLOnGogvcpX7vd08APupRIm/ihcRRtPP1CMEvCM/RfuP2Wd3RYVaE0KTltg5jyeaQjmMRKpnSmLgSwNZ5JQRdWHkvjhPcH907io0VS1EwKhwaOpVJvJQbTYc5AtkYZruCr7NWPxeK4voOyfuBQLb3KE5Fe4WvNaBfKFPFrkkuhj2pmzq+Ae4wG1MonvPO/pT0KYfV6iB7R/ZmDYCWQfTvyPW/KZ8ojwrBbA2fEBFjBzpXpB7/irslrI3jxM6HAPv0YXphvNbeU1zNm2tZnvdcwcLmk24xIiyxT7JpDclUscK1nfbmoeUTufGRBHdSVcI0TB2kqTKFuHdWVbMQp7D5RtNvZ8LuvQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Several subsystems (slub, shmem, ttm, etc.) use page->private but don't
clear it before freeing pages. When these pages are later allocated as
high-order pages and split via split_page(), tail pages retain stale
page->private values.

This causes a use-after-free in the swap subsystem. The swap code uses
page->private to track swap count continuations, assuming freshly
allocated pages have page->private == 0. When stale values are present,
swap_count_continued() incorrectly assumes the continuation list is valid
and iterates over uninitialized page->lru containing LIST_POISON values,
causing a crash:

  KASAN: maybe wild-memory-access in range [0xdead000000000100-0xdead000000000107]
  RIP: 0010:__do_sys_swapoff+0x1151/0x1860

Fix this by clearing page->private in free_pages_prepare(), ensuring all
freed pages have clean state regardless of previous use.

Fixes: 3b8000ae185c ("mm/vmalloc: huge vmalloc backing pages should be split rather than compound")
Cc: stable@vger.kernel.org
Suggested-by: Zi Yan <ziy@nvidia.com>
Acked-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
---
 mm/page_alloc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index cbf758e27aa2..24ac34199f95 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1430,6 +1430,7 @@ __always_inline bool free_pages_prepare(struct page *page,
 
 	page_cpupid_reset_last(page);
 	page->flags.f &= ~PAGE_FLAGS_CHECK_AT_PREP;
+	page->private = 0;
 	reset_page_owner(page, order);
 	page_table_check_free(page, order);
 	pgalloc_tag_sub(page, 1 << order);
-- 
2.53.0


