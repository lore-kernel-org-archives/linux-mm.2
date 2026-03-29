Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6EF44F3D5EA
	for <linux-mm@archiver.kernel.org>; Sun, 29 Mar 2026 04:37:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D70A26B0095; Sun, 29 Mar 2026 00:37:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D4DC46B0096; Sun, 29 Mar 2026 00:37:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C37266B0098; Sun, 29 Mar 2026 00:37:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B864F6B0095
	for <linux-mm@kvack.org>; Sun, 29 Mar 2026 00:37:35 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5F74D5889A
	for <linux-mm@kvack.org>; Sun, 29 Mar 2026 04:37:35 +0000 (UTC)
X-FDA: 84597842070.08.7F32E48
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	by imf13.hostedemail.com (Postfix) with ESMTP id 7D8D720007
	for <linux-mm@kvack.org>; Sun, 29 Mar 2026 04:37:33 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=hev-cc.20230601.gappssmtp.com header.s=20230601 header.b=EhYF5OQE;
	dmarc=none;
	spf=pass (imf13.hostedemail.com: domain of r@hev.cc designates 209.85.216.48 as permitted sender) smtp.mailfrom=r@hev.cc
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774759053;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JR9CUyvApmvn0yWA7JOocQfIYBlfpLLyGv3hbHiybeY=;
	b=efiGuKb+p0sSt19TsSuSxyG76yfcE53b98rRod0jw8RAvD/NCmUvAtIF7mpGcpQP5e46gj
	snH36y2TPlBDe9jDegnRjt/epXrBHlXa5pXTYTPXdNV/N8qT/7rDMZA7DH2AMSChYmi9dc
	nqLT6tQADAnv9LtD6kWx1mMHHuhMHdg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774759053; a=rsa-sha256;
	cv=none;
	b=x5OKy8cJiqntaxc4jTeirA54ybB6Uqs5p9c9uqjzhDT8U1wbn5mvYlhVRyXedZuPfeAXHk
	7wVEqRTPZufxzaBkRCXSjEUO3cxoAN8xBR+lqW9ftY5FgFLXSDzQUtYjVI/DXH+5jFQbOB
	k9E5wUeLEWibWekklEJb+kHfjXhVFEk=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=hev-cc.20230601.gappssmtp.com header.s=20230601 header.b=EhYF5OQE;
	dmarc=none;
	spf=pass (imf13.hostedemail.com: domain of r@hev.cc designates 209.85.216.48 as permitted sender) smtp.mailfrom=r@hev.cc
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-35d95017a68so431812a91.3
        for <linux-mm@kvack.org>; Sat, 28 Mar 2026 21:37:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=hev-cc.20230601.gappssmtp.com; s=20230601; t=1774759052; x=1775363852; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JR9CUyvApmvn0yWA7JOocQfIYBlfpLLyGv3hbHiybeY=;
        b=EhYF5OQEcFZGgUyAqEXo5jrVIjAbkPoZ3ipvPYkBNQnofzIpsDWc1R0h/7TXwhsuSu
         P2gA5zeTL8aaLxf0d9eLGs3jevGl2GgvSHOJn9gAT035kUT8rudczaI5dypG/Ssu3Sc1
         OGIdLAuchKpFrMgwPwdBB+NbM1A6BtLmtKq7t9UbMpHWsX1GJWAISNTEurVmroRU5JeX
         Hs2Y2/RqxuIY1qZh0/lud651sZduiOXK2yl3QOp6I0+S8VLu+viA6v0nJYhYZ6GCvZDA
         nfkSaIAe7zQM7KhxRMoAB8aQGxEZ+zfcXJva53awAFKRv8wzTaPeVWSYadb+kIryO8TI
         Jpfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774759052; x=1775363852;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=JR9CUyvApmvn0yWA7JOocQfIYBlfpLLyGv3hbHiybeY=;
        b=KmtGS/AERbU6AIAqBi+xfVxkHKCDZEPexEopV3+AYM9PuqALKFSADud7ajRgUUOIrJ
         HqGFvi6cYJmnxtH3hcKtVic3Ncrl6WxnB9M2QS1w6Ik7bTUwwHSjHq+7j7OArV/vi5aC
         3ttZU8b4Ebr89yYjggsZyvzqvl2FYwKR8dwPm1rcRK943lX9FmLgKYnAwxHHY73l4oeC
         gCBQCiT/o/timaKdGAL9k6dMn4EA5QkAn0H2rsRE005+zEO+w51mu42lF4auObb1Hwfd
         3WeFInid8pBglBQ9DTDgXMDQ1eLOglb2+q7zkarwt1BCyp2S//h26dhCws+W3nzteH2z
         B3jA==
X-Forwarded-Encrypted: i=1; AJvYcCX5Fg4x53epToLMiFowKeeidZtN4mm2BMWDT1oMzPUjrcreQrA0RpvFcolnUWMqtBtnbI6SF4gUDQ==@kvack.org
X-Gm-Message-State: AOJu0YzjqU3iPuc9n3ASoseDIu0byzAJT/cjg9b+RQCkpLfEumbRD8wv
	X/UC3VPjjV0b6NHeF8eo+pMBBv0KuqaBsC2OLNne10iZOUJTe4vEJpWRg2hqTix9Ads=
X-Gm-Gg: ATEYQzxAeU8cLlzYf8b+g66dUeYX20mnLPPajikLyNKleyQMr5Qu6z+bQtyu2fVzed/
	/2d8qSZQLsskZL7j63d0//ZUpZbYeDLpC9D/UyImp/OnnJG1ywaJWE1XUuXIYRvEFSjUxZeK8QZ
	aBD/olJhMZHpR6fxEfiK10GkNlYyN0WEDr+7vV5TMtoS7ocAjmXwtLhZXMEfKXqLGUWQKALtfyk
	HPItju4BKuywZD1eXILic5NFiBk84uf6H97GFf57s31DWkVBLEee4ayb4d994T3OMUfUvfOyLlU
	zCN9VDk9qJYsMkeUEQlUcxiY2SHefwQsEScXx8yiZizOGkj2UrvtrwK7O1oVLvzSG6z2J22gTKf
	myTCuCqhqWK1BWO+iwVlFoW8MYgP8lT3YDZN+NZU4iesYU1ViQOC7QGtZ6ktOwW5Lz0XCFEUViT
	l5
X-Received: by 2002:a17:90b:28c7:b0:33b:b078:d6d3 with SMTP id 98e67ed59e1d1-35c3007ed0amr7400264a91.23.1774759052247;
        Sat, 28 Mar 2026 21:37:32 -0700 (PDT)
Received: from gpc ([2400:8902:e002:ded5:78c1:8178:95c1:6ca3])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35d94d057bbsm3385004a91.1.2026.03.28.21.37.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Mar 2026 21:37:31 -0700 (PDT)
From: WANG Rui <r@hev.cc>
To: usama.arif@linux.dev
Cc: Liam.Howlett@oracle.com,
	ajd@linux.ibm.com,
	akpm@linux-foundation.org,
	apopple@nvidia.com,
	baohua@kernel.org,
	baolin.wang@linux.alibaba.com,
	brauner@kernel.org,
	catalin.marinas@arm.com,
	david@kernel.org,
	dev.jain@arm.com,
	jack@suse.cz,
	kees@kernel.org,
	kevin.brodsky@arm.com,
	lance.yang@linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	lorenzo.stoakes@oracle.com,
	mhocko@suse.com,
	npache@redhat.com,
	pasha.tatashin@soleen.com,
	r@hev.cc,
	rmclure@linux.ibm.com,
	rppt@kernel.org,
	ryan.roberts@arm.com,
	surenb@google.com,
	vbabka@kernel.org,
	viro@zeniv.linux.org.uk,
	willy@infradead.org
Subject: Re: [PATCH v2 3/4] elf: align ET_DYN base to max folio size for PTE coalescing
Date: Sun, 29 Mar 2026 12:37:00 +0800
Message-ID: <20260329043700.19355-1-r@hev.cc>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <0725ce97-b8a3-47c9-952f-7b512873cc35@linux.dev>
References: <0725ce97-b8a3-47c9-952f-7b512873cc35@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 7D8D720007
X-Stat-Signature: jjfugt54pru4u11thefurg6ojgsqcy86
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1774759053-78893
X-HE-Meta: U2FsdGVkX1/MsyzZj3ZrZd7Pu85mJDtfYuVJnBo8PyP/1KPvRzfyVHZseOCmj/kB7NuFUN2qoReV4dD3WwE/jcvja3yAyh/obscwekQL/YHTQuP1HQpW1wZu9OqFisrjftv8uSR0M5iIqfxBdgbUzX5/1xQRY8vl6Vt/LAK1JW6mXhnUNaUjL/Qjl6Yr/olo9lYUJNPHbpul13Tx8LAa4uQhzCZ599OWuY47sREl7eokEIq9/9XXFYhnnanrleVJyPU4O6nNgisxxSicuPsGiHUg0riUG8gq0KN77gTKIwDeYQhHKDdC7D+d2Q4LqDBTcMfAGW5ps+DGva0Yr0USUpvKWapFMDZxxi5ub1NuJhm7nUY5GOnbV4YkS+R7rSWBmRO4tjEiSm+1qXUE5umGu48tE+rdyJztdvnJoBNvUzJwg7ra6NzhE+sxvhfbubwSKBf+NXDKBLXKMMLiPx7iQ9OztjmW5cEyrZAarFSvyKK+TDtvE4UjAK7mY2Vdf9PIHxRTT3ZxB+gnoEumv7/4nehQ/9Fpzuh2FFZIza3EqY5VSVMhhi0cZ03ksKgpULZgOE0/P7vw4Ox0ANWndz+DYiDIo/wPFtiLlsk52Hz5d1wAI5uyH5nCCIrVqYfjQI4yBzd14wDADabjV09yrk7XNDNXv0XNHuHJgG93wE7IiJyOcHG5bMh6GNxjKqITENwjw8Ab0JDOQcNefHPbRWGxT56yitlbsipZLYTPiEf7+TkKmoypw9hAiFQwSiEAnhEVFv8fQt2SgtvEGytsSIddjgROrnbi/OW7d+szFHaAVw/nNLn2nslksb4rvBnWy5z7WlbF8iU/rFd6Sxr/BGMR7xLuJ+UUqH+Vpamk+NuYer3JEFTvuyN0/VukxhDUCKtr/TqQiktfMqQR1U2Y3HkI1wWw/Nh1p+z5rB8zVchPL3E+hE1RDpvkZMPz1k6qbBkrKndA+DiM4bBZlCcwvBI
 zBSEY1mQ
 05Oxxckrdx/zVL2Wmge6s3Q1F+mtMlkGHJAOtQWSjv1/CQF1U1k1beSHtC6v26IsxDXPehTo2jziy9W/8rnnNlnS+KRe5PuDXsxab4QYfyLn/SOU81+5wntgl22bnroDIjLXj4Y7+ZgmjXD/3LnRek6+UMPKly2A80K3gLFpicpaAWOaPSB7Ju8a1JuGM4ENyRw4UiLV1TR1/m+etbWmikzVYVnnuFNk35v+3fh32cKnR3rSPnBPk8Ow4h2RpCAMdC61INqFnSE7F7gv2ajsCoU0do+8lTjEr2mAVT4/ZlI42Hj4klr+YcPdm/4bKltNtl5k/XatbK9S/ciAesmFVMRekr3ZkLT/p6YMsLVDEAq+7u2tJCFa8lrNrhgDlIlzLUmyGT6e4Y9GigtGbt2aycw1oQkGijNsE+CwLhb24LRKhBvbsGuHib5uhXaNCsxb7doVN7XLwvNeXXZLLd2tPQJn4Kh6knhDpdAMj4e7OEkruV0OvL2OZc1aTnfFchlH+toUsjz+X5jGHc0SnQPBRswfmTUopQ+oUxF/naQRlirW3hciEj6/IucAIcpcEMpdghZt3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> mapping_max_folio_size() reflects what the page cache will actually
> allocate for a given filesystem, since readahead caps folio allocation
> at mapping_max_folio_order() (in page_cache_ra_order()). If btrfs
> reports PAGE_SIZE, readahead won't allocate large folios for it, so
> there are no large folios to coalesce PTEs for, aligning the binary
> beyond that would only reduce ASLR entropy for no benefit.
> 
> I don't think we should over-align binaries on filesystems that can't
> take advantage of it.

Ah, it looks like this might be overlooking another path that can create
huge page mappings for read-only code segments: even when the filesystem
(e.g. btrfs without experimental) didn't support large folios,
READ_ONLY_THP_FOR_FS still allowed read-only file-backed code segments
to be collapsed into huge page mappings via khugepaged.

As Wilcox pointed out, it may take quite some time for many filesystems
to gain full large folio support? So what I'm trying to clarify is that
using mapping_max_folio_size() on this path is not favorable for
khugepaged-based optimizations.

Thanks,
Rui

