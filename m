Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 645F8CCD184
	for <linux-mm@archiver.kernel.org>; Sun, 12 Oct 2025 01:23:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 799F98E0006; Sat, 11 Oct 2025 21:23:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 771CB8E0002; Sat, 11 Oct 2025 21:23:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6601E8E0006; Sat, 11 Oct 2025 21:23:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 51DA18E0002
	for <linux-mm@kvack.org>; Sat, 11 Oct 2025 21:23:43 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A6B911A078E
	for <linux-mm@kvack.org>; Sun, 12 Oct 2025 01:23:42 +0000 (UTC)
X-FDA: 83987715084.16.50CFDD0
Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	by imf30.hostedemail.com (Postfix) with ESMTP id A77638000E
	for <linux-mm@kvack.org>; Sun, 12 Oct 2025 01:23:40 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=fKI6matB;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf30.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.47 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760232220;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M9pUt0AntXuvLlR5iztP7t7IKQSEW9xSg2klSL9Fwb0=;
	b=gTwrBZP0OO1MzSTYcHC5yJCXT+LykDmU4k5x8AOtf/kzwj3A6nm54PRoth5NJRrLOU/1h8
	XwWeyyC5MFwYXE1AjY+1rDIswKbMePDrmDBKH87xGZXz+ht2fiEGD5Q1lFUuEJRwYgsreN
	3/yUoBRm6+02xaay/MO0VfK2uT4MH5I=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=fKI6matB;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf30.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.47 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760232220; a=rsa-sha256;
	cv=none;
	b=0/MNDXMRJZK3zxfpFVNGWUl/DD7NPT30gXqzVZZhn5XzK29fBsDEVJXuEVNOBmeZKy0Oit
	LjdNRS6SRYxkaOx53ThO008WUwslb2Xla4+MJFYbhdza/xNX2LyrRz5dIGhjkreBo2RTJF
	kYqjyPmSD1AnTmhsInHG6mlZxOOssuM=
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-b3e234fcd4bso528625166b.3
        for <linux-mm@kvack.org>; Sat, 11 Oct 2025 18:23:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760232219; x=1760837019; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=M9pUt0AntXuvLlR5iztP7t7IKQSEW9xSg2klSL9Fwb0=;
        b=fKI6matBA8fXxVkRJxOCVCDk516rwcxVec2FXIm5665SGLB112pDSjNBX/KFpt9y3d
         yry7i7rkbhFH5Df8Mm0EunGMKnzauHlPYVEP2HHBiA9KQe/uTgSGRW+eHYuSglgrKhs/
         aoF2BeiwlTib7mwnzv++MF6Uyd28eec/TVIawfW3GkgzqlefXp7q5LAQEE1AZqF3KXHy
         OnlmKE2PcUZp2ly9Ny42FO3A7Q1tHhhZ7f8AmYfmfjssqVa9HYikYIm9Fy85GrR0bSq0
         9n2UkJQ33eB0A3rD1GXNABQIqppK2hZaV0f/A6c1RiUZh0ZwhUkVqsA9kw8XNmAk2zcS
         NlTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760232219; x=1760837019;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=M9pUt0AntXuvLlR5iztP7t7IKQSEW9xSg2klSL9Fwb0=;
        b=RLwTcG9zruorvhJ4TFVbZOxU9Ia3f6M3zusGECNVfluHS8pG3hGfttvTWaIbbuaFuX
         GTKcCKm1HCwPncbXjm/Zge5rHbjgDV/m6OAJYIfhw0ZhF9MQMvzpX8odeYpjivHkOlAV
         FblNwf4s4TOnlgngQdhGjE0WG+JhOa9qIw1/jC83yoFtyOxnWJ3UA/3+TF7h/DQq7LUB
         fwa3VBhlctGAylnPKqHyA3k0uOJdtG0F/GNKvFy1adkPK+nx6gmOQaip8AfDfCW6KqEW
         Ne+ehpEjj11GDIGa1MpcFTr1nOFm6paoQN5oI7QNHFNu/UlwrEKs7RfPINzbJDtK4m/O
         7zgw==
X-Forwarded-Encrypted: i=1; AJvYcCU/i0eSTUYdkrn2ew7yrciEMMUtVGapBtxsYDOzbWcV9mHc2O/BLWMxMHDzYyyntLtAcYwLl6r8Yw==@kvack.org
X-Gm-Message-State: AOJu0YyxdZVGtmWRj9B2uz8LWszj5etl+S9KuKgV38d+i/c9LEopZFm/
	HbIR93m6dWAWliuB3NyswqyAyvjtJbIAe5JFDoUmyeRpAub015+2iz2Z
X-Gm-Gg: ASbGncsFTar/4q8Ba7tLkByrR4a4ijx/T8DdWqXbnyb7gLqcflUvSIQ9qk7TZyT7xQ2
	TXpsQ9FcuO5i1B+P7SbiPFe+lpIzRwqkrkhjrVAVK13z4sW+42JrjQ94ZutcFIP8OybcThxLf99
	dKkCjfVpUgVxarlyVOkpkemjgOS8SvSrWVAPMF1ARvD/yRiDedvAxokpSCBmOqbhzIEF6JLFErd
	ptFDaSzhg4/iJ9YozHw9OIDtDwkp4n+axCHGoRmZqBpluY+BwODk3qOAu180v2uSpkBeOuE6wFk
	LdJ5hG2GdURkML20R416X/ORVvn7W+87kUwFTbGMHcuvr6IXeFPkeX3joyTX7TpGA4XmPvkRFWT
	eDGtFSqNnFSOxUm0TYgx1yTZWcafGK4RCb5qApsF13xinj8JWzl4=
X-Google-Smtp-Source: AGHT+IF71vBBTgT683rCNca8U2cQqwxYPV3YtliFuu+HnIfiaWNkbjXN5AsySJ/bIvljzSu4EpvYpA==
X-Received: by 2002:a17:907:d01:b0:b07:c5b1:b129 with SMTP id a640c23a62f3a-b50aa69e3d1mr1631820166b.1.1760232219099;
        Sat, 11 Oct 2025 18:23:39 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b55d8c12ce1sm602637966b.57.2025.10.11.18.23.38
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 11 Oct 2025 18:23:38 -0700 (PDT)
Date: Sun, 12 Oct 2025 01:23:38 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Qiuxu Zhuo <qiuxu.zhuo@intel.com>
Cc: akpm@linux-foundation.org, david@redhat.com, lorenzo.stoakes@oracle.com,
	linmiaohe@huawei.com, tony.luck@intel.com, ziy@nvidia.com,
	baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
	npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
	baohua@kernel.org, nao.horiguchi@gmail.com, farrah.chen@intel.com,
	jiaqiyan@google.com, lance.yang@linux.dev, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/1] mm: prevent poison consumption when splitting THP
Message-ID: <20251012012338.p5z2oyyymjxa4wni@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20250928032842.1399147-1-qiuxu.zhuo@intel.com>
 <20251011075520.320862-1-qiuxu.zhuo@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251011075520.320862-1-qiuxu.zhuo@intel.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspam-User: 
X-Rspamd-Queue-Id: A77638000E
X-Rspamd-Server: rspam03
X-Stat-Signature: 747bewz6i4hbgkoa4ruza4nh4mxk433i
X-HE-Tag: 1760232220-784638
X-HE-Meta: U2FsdGVkX19xrSPh2jOqfHW4aExJZ3vayHVP+KD5+WNq+aRc3cgw/B79C4rKJMgCTnvWWpBXQF3ZiBLBxa+CvpzU0zSrpH2mBmDaWQDo8L9lz83U/EBoGBfINAuUGR2f9vIISyimYq2ZadKcQuejJQovxTInYGeXdjm1eLAqn4zT/VTR+oplyJk8LqiUzCn65wLsFZjaA1nHaqyJRFUFr+ywiqlKdTJFIgR3a5x0TZJIthzjtngTiowfLksruaYscreZkJHYc59+OGavA5lfQuZK4UJFqMTsl/y8LJMp3u7c0Jqr7tU2oOa/Rar8nGiHkDKLzy9FCrQM/Io5I2ZAcS6SQmXD3XdZsNO8uAEXe50GMsO9U6/Ur7sALGPBU20q6K3Vr3rG4cHc6MtAVEI7/6Ilo9p8mtUMcIR4S3pVKCp0H//XgRF5oFga4CUvVczAVlWiNKe6pO6ZdRjuGoIsxVgTXr6ygy0Cf+0ZXN0Txr1M7d0Abgis51U+Nwki/Us6cvQuyTB4082Me0w6w0B9hA2kkAoWxcFh/tbDhMSt2hGNiCx6um0NF8+QCL1m2Dvo7e9FSsryCeyeq/k5xLot/n1NWwbczEXv+0KGpiEbqk30jjorIqUTTFFc8B2jL1SnRQzi3i7x7BgqvkRktv+B6m1vgFTqPJ0K/XtjTKT7qyL7lpjnjm2WimMBuwTdbAqgXWdzXUYOsQdOlwXaOXpVRLYXlujJrYGj1TZAqzrWx+Pm4iCsFlExPbtotNs6MoXM9adoi2W/66+zPFSVoPVDtG13dpMtsx+uD/PqpNj6JWRM6OYnXAIncW8b7i6UE14O9LZiogbTGKvAgS511okTzwYR7oC/LlQ8M1PkPprZlgTsBpwFZU2ms5LkZdB+R1uGxbNsK98VL+4mBV94169jVIDpCatTkoON/+PSvdrPrs2EiDgs5gD5XaFG9DJuTih6RQIMru3rEsx/zkI6Yks
 MkVdY/SI
 vn4jywWjIE1mDMyWViIhTIZeoTjjghnZ/gl1V6jLWUNr/5SBPzsWaxOFk1HpSZYBrwtjd3R/t0Wqwg3ThF3v5yohCV/ydKr3kzWXXy3nRXaTUYduEJ8HlauGW+RospGjgmvlIAbwKD+72Odhg4jTJDn6W0VQosfenXGE+suKnCnOhX5DtO84qhGuDShxhmGMEPzYe8L7bEdKyiv0BluLHuLS9iISJILqQ2/a/0vLQLssEnycx8wCgYWSBjEEncfgJfdFe66WcIIki9A1+F+51D7iZVXAShnG0xzYCRK2gcp5WTNg24H3wU5ZDtT2/B0N9wDz74o4suwsr5x5KaU6UXRCUeEGNuL9pHGDF/zDLuTCRyio+HRd6UuNpkTmjAixVIkvPcI5owvzeI34/rA+ZmKc92Wv6osXuxN4l6pRqpwq9G8+qDgnhrWv126bibhxJj+mHlCzoYSYFTvYDjMiCW4n1vKJoL8aoPTgbpLGgOrZOxOmIXQs8WTmnSTPfxrhG5ElK3+nuzFs7aPe/nwSLVr7gr1HDKOMyx0rvnFYV8pjwjLeB6io8wl2hFlYujdd4MHFMZJ0QpypAz8T/iGYcGZqJeuQKZ8BCW47aViFJCXMP9B+SYBv5eUJlQtEo0rn3jUkzn9NM5TNp6vh79oTlu3TseTS5KHA2X8Q9AYNDWpRa4OkLgVtDclzM2YR7tWHtmp3TdrWLxttdYqG+pEbIXMHgnig7JghpnqXXm/E6g7NoFnGm9LdKu6zzttp2sNjku5uWto7k7GdKpQ0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Oct 11, 2025 at 03:55:19PM +0800, Qiuxu Zhuo wrote:
[...]
>
>diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>index 9c38a95e9f09..2bf5178cca96 100644
>--- a/mm/huge_memory.c
>+++ b/mm/huge_memory.c
>@@ -4121,6 +4121,9 @@ static bool thp_underused(struct folio *folio)
> 	if (khugepaged_max_ptes_none == HPAGE_PMD_NR - 1)
> 		return false;
> 
>+	if (folio_contain_hwpoisoned_page(folio))
>+		return false;
>+
> 	for (i = 0; i < folio_nr_pages(folio); i++) {
> 		kaddr = kmap_local_folio(folio, i * PAGE_SIZE);
> 		if (!memchr_inv(kaddr, 0, PAGE_SIZE)) {
>diff --git a/mm/migrate.c b/mm/migrate.c
>index 9e5ef39ce73a..393fc2ffc96e 100644
>--- a/mm/migrate.c
>+++ b/mm/migrate.c
>@@ -305,8 +305,9 @@ static bool try_to_map_unused_to_zeropage(struct page_vma_mapped_walk *pvmw,
> 	pte_t newpte;
> 	void *addr;
> 
>-	if (PageCompound(page))
>+	if (PageCompound(page) || PageHWPoison(page))
> 		return false;
>+
> 	VM_BUG_ON_PAGE(!PageAnon(page), page);
> 	VM_BUG_ON_PAGE(!PageLocked(page), page);
> 	VM_BUG_ON_PAGE(pte_present(ptep_get(pvmw->pte)), page);
>

The code change LGTM.

Reviewed-by: Wei Yang <richard.weiyang@gmail.com>

>base-commit: e5f0a698b34ed76002dc5cff3804a61c80233a7a
>-- 
>2.43.0
>

-- 
Wei Yang
Help you, Help me

