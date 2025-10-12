Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B8C50CCA476
	for <linux-mm@archiver.kernel.org>; Sun, 12 Oct 2025 01:37:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CE91F8E000D; Sat, 11 Oct 2025 21:37:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C988F8E0002; Sat, 11 Oct 2025 21:37:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BAF018E000D; Sat, 11 Oct 2025 21:37:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id ABBD28E0002
	for <linux-mm@kvack.org>; Sat, 11 Oct 2025 21:37:13 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2A70913BAD5
	for <linux-mm@kvack.org>; Sun, 12 Oct 2025 01:37:13 +0000 (UTC)
X-FDA: 83987749146.23.6D7E5AC
Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	by imf09.hostedemail.com (Postfix) with ESMTP id 24631140004
	for <linux-mm@kvack.org>; Sun, 12 Oct 2025 01:37:09 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=h51n297H;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf09.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.53 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760233030;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pXcj9t6DXLhYpSPkJydjzqZ2KkeR944EkcDSqKa6hio=;
	b=Bp96g2R4JxYwiRhNq1DFfq8TskyYhia7aWbr01F1rC2/NhzEhca3+5BYDHdjueDJybMBHN
	DApD2rac6RAyqI+Hasm0Ul3yRzuEXMeqesAECmPUuZ9qoks8X8uwrUBCIMss4/i+BLGuGS
	ZI4Sfn2y4Dr5jOTXSoVdveGKDfbyBy8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760233030; a=rsa-sha256;
	cv=none;
	b=IOO2Bn78dCtUZZDmX+qZ7RM4u5rnRRHClF6Wu4S7D7F8xsvRsE557J71JYByQnM1Bp44rt
	GIxdOM8F3kiBM3I9vweNyyiDq+kjvc1UCorR9G06KxBsuFIsdexRNa/7EHDDT4hSch6Jr3
	2yvKxQjOvmuiGYdV5uo2LwRhsRBiQtI=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=h51n297H;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf09.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.53 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-b472842981fso399505866b.1
        for <linux-mm@kvack.org>; Sat, 11 Oct 2025 18:37:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760233028; x=1760837828; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pXcj9t6DXLhYpSPkJydjzqZ2KkeR944EkcDSqKa6hio=;
        b=h51n297HvzQAKaF3qRsaNoeExqgQmtrgmyjnqyCA2XqECgKmOBQEoOfH1MFtygnGhb
         pNcxDG67/mejJlLuEe8WbPK5gLhcll2u96wmm1EZdyUDIewmZ80D1B5YbetdsW+j1qQh
         u71jJS21+bGkuD+3IoXPGH26k0mpk5aT7f1zzHXTvlgPMwHWdFI5CwfJIriLyid0oYng
         y9chIfqsf31tuhhFfXJjBLupfjmgJW3HNeLVDOuGyqejO8ZhHmvF/+Se8UJRta/MJ260
         9XuEiC7CRdI+rbVpudPAHEUCYHbvOs5AfcCsnDz0ObrJxl+XCrIMxm0i0z7dqLHWpQW9
         UBPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760233028; x=1760837828;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=pXcj9t6DXLhYpSPkJydjzqZ2KkeR944EkcDSqKa6hio=;
        b=thYkfYB/cZ/fXdmUJN8AFxtS5/tWn+bU/YmkI112sQBpr8NUEw5N682RIl4R6U2iLL
         E3SXpXM6FbyNNmY69UV4xx7SHr20Svptvh4xSC+8D6UBBh1w+Afufy8vAz8226prPJ0A
         d0RbcYwL/4VXlDaJPoEd5Zj3EBHCVHYW/gQVzWPZX2VDc5skJYQ7W8aZh93RpLxwtp3T
         yYqvl1xOce2hqD5sY+/Ub7SMWPxob0VvWY1943ThmQ9Eukxuu/28lSLR0m1X8T1iDy5Z
         8n6qvWsGbNnss3ah1p0VoraAOojrzu679jED43wZNStsy4L+bFGoDLAdzj0BSGW7ERZx
         pi8Q==
X-Forwarded-Encrypted: i=1; AJvYcCU7ZCfkkKhApxGhsFW/ldLl7AbPm2VNMmWOF3wVSW352ICGdj+nK5aBtmyeyVjNIjnXeKxTgZMVJg==@kvack.org
X-Gm-Message-State: AOJu0Yxgb6H6w3OrA2HumIHDtchLMbKQ+ERPYFcwgTaq7rCp8dZqsyx9
	sqj+KRcebLrfyei5wp1vrmoXkBQDNX6NBgtpuG7RHefpKNWZ2MfZ/dc/
X-Gm-Gg: ASbGnct4IH+IRtNa8+XfA3BrPSqzZtraUDi2uUhMy4yvSOnY7kek5gDZgjHE1jEwRTK
	UN1xk01AqUfRl6dMQq7jMdtQ4iHjroXsMCJAtkjemuquR3tja2Ay1vvOUClWZBsW2xtFyI3pHwp
	fwP3CrFdPptGlgisR820QhT6+AfDymtG/g/LzkLiqU/dmcqlapCdYjF2+/qoKS5/d2SHKdBs+WZ
	4yL2XAHdVWJ7rQ5YAOAOBTg4zAEW/YIfNvCb/qMg6qxuxx0d8xLNNttfp+aNuPE5sfbIFXRwwhj
	fK4YLM5TGKeGMzhybYLfXwX/p8lGhku8PhpQe23dJsLbJOtP7/vmr1DeGGflsc6J/V2ai5xjnng
	Li/QPsKMF3UvLwZHCU7ILb8UTTgeKRxArRTJ2ncRQYke5kVT1m9w=
X-Google-Smtp-Source: AGHT+IF3q3QHUAa+bs+cyKa8Yi9+rXO316YWM6xGdNo1TNDBJUSk4D3Z0NkO1+nlSSwWJkr1ZFVyBA==
X-Received: by 2002:a17:907:d64a:b0:b46:6718:3f20 with SMTP id a640c23a62f3a-b50ac7ee0efmr1825374666b.48.1760233028321;
        Sat, 11 Oct 2025 18:37:08 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b55d952a273sm631363666b.83.2025.10.11.18.37.07
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 11 Oct 2025 18:37:07 -0700 (PDT)
Date: Sun, 12 Oct 2025 01:37:07 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: David Hildenbrand <david@redhat.com>
Cc: Qiuxu Zhuo <qiuxu.zhuo@intel.com>, akpm@linux-foundation.org,
	lorenzo.stoakes@oracle.com, linmiaohe@huawei.com,
	tony.luck@intel.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
	Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com,
	dev.jain@arm.com, baohua@kernel.org, nao.horiguchi@gmail.com,
	farrah.chen@intel.com, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Andrew Zaborowski <andrew.zaborowski@intel.com>
Subject: Re: [PATCH 1/1] mm: prevent poison consumption when splitting THP
Message-ID: <20251012013707.ukkczekcmhntrot2@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20250928032842.1399147-1-qiuxu.zhuo@intel.com>
 <8ef5e3fd-2ee8-453a-b8ae-584e3d606aa4@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8ef5e3fd-2ee8-453a-b8ae-584e3d606aa4@redhat.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspam-User: 
X-Rspamd-Queue-Id: 24631140004
X-Rspamd-Server: rspam02
X-Stat-Signature: 8ti493okgcyirsjyma8e3pty97ugkkzi
X-HE-Tag: 1760233029-625900
X-HE-Meta: U2FsdGVkX1+Gj1iH2r7Dw9X/cZh4X93f6u358vEbBPL+ao5qwEy6HvHQZwTtEODsDLRpnlDvGMMBjoA5pLPZocEsjj7HTWnWalqTaQ5xEV3zkszEK112n8BDN3anps/u0D3qwEoercBYdBtodSdF3PsrsQpKHxeIOIBgEdl7QjLYdnZg8q99PQfAVoEB+gLpjL2sw2rDKMPEBUft8cL8ysX+2g5yuOkSBtD2PJGenhldrP39WUzQHYKS/g79mr6SEEbfxeS4Ar9rIAYG4DPJU7Bravd0LT8ntpSfWU36E4apaS0DB14p9bIsC0QBTbrGLxfmUYfIKSi6aJSdvcW12SaBpyYF1vImjlVMDAUFqhJi83MxjfWaD3sCKYt6SjW2LOUPiuQAUaABe5tf8J/Ocx7VGwG0AkPDpKR8SLYOoFi57gzraeuG2M9dwOnSOB9tVK+I/++qMUIQnELw3kVMtu3JCFJYI96knjFx6YCU7g35tHdILlrIxinJnXpbYiJ7blPu9NKgwIlFRnrmppxGzF5EoUPv7ZTCANGbGaFtGw0sWscuoYDVP6ZUX0FZGtl1vg+dP+NZM85vKYmIwKfV9/BtlRwUIaZcnnk9IvcodQPnbxEqRYXnSNOL2KSKHVXhU7woJalhUOC5BGTz9KchsTiJ4VSfYMNTy2aOnZKLW/A6PTme5ZfYCwVvy5fkYPECx82E+ppUe4+qVeCfpgi92RYItckSeP1O1qev5KpoIpS0H/F5H6TWeSxedtytASU5QcL/TzKmlCiD7pLJAB8KCk5FIsoipaD5IR5j4HnPQvdHo0u8BX098xgkf8JAseWES8ipmEZ2qfO5SqFvxFAfFWw0Z2h+eNqv2BBuCMI1yroDvf2fpBAbHQ5VEuP/+NP/1gFODg7OSK7KgzKxvahjnN8C8BkDX4vF2Y9S0xtQ3IDxXJyCbMFusg2KQNcprC2qhfaS5V2NfVqbCZx1Tt0
 BA+1Tz4p
 P9v1sogTSxCHRRjM1+q22KICDcVtPRfEbOjDGgC21m3C4CPajeeHklJhfHNf2QbP6QawpZt1QbzANc/yU80qNA1bZqp/ecdwM59wzquS/g9xaMEOlxKVWX9/Br2FMALsf6QwGa2VC44XhoUjHe5niNXqVYNO4eB1NX7ZW+6g7+8h+xK5+rto5rU7UM3ESja3Id3D6kO+SGRrllDwSRpeBzL3iHx4ZamRPcSeWkRObSjqE3WhpCCt3tIYYt8lnP3cwknvxLrC+illRXHc3x0tjzlru0xOBM5FXJGVIqOyOfhJnsvp/8YXt1HIalPulul2ClqX4Imi1n6bMDr/LHXALIJ4buHDj+E0I0Px8pu+bGOby1WoA3nRoQWF+BrAFYKo1G9iP6yvmovG2awgkOJpNiJ54hdRQvE/6V0yjZI2tJ0sQzj03vDonj4dZ571hrzb4eGDRY9zyvZ6mFGfTz6njL8s8c6KrXSGLbj9Qc5OP/segk1WMg4YogUZ4sKkyiJ1o5IdATYAFCXfSNn+Xko3Zt6lt4aqoidlpXwxRr2an54D9WGKcNZcf0hNXEFjkDmQotKHL4b3e8YCN2VM0CLOHMI0FqQDkfowOBCnQWjrAJy9Akysi2KSVTER7EI6AVLeikD/efXE7+MjOnKnaMBnIX0HMyjmF8NaPUcc2bRq2M44A1iaZare79+bvc9KR0egX0veSXQJlldsxStnxmHVJZd3XvriU9iuySyy1ZbAC0NEIJUw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 29, 2025 at 09:34:12AM +0200, David Hildenbrand wrote:
>On 28.09.25 05:28, Qiuxu Zhuo wrote:
[...]
>
>Hm, I wonder if we should actually check in try_to_map_unused_to_zeropage()
>whether the page has the hwpoison flag set. Nothing wrong with scanning
>non-affected pages.
>
>In thp_underused() we should just skip the folio entirely I guess, so keep
>it simple.
>
>So what about something like this:
>
>diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>index 9c38a95e9f091..d4109fd7fa1f2 100644
>--- a/mm/huge_memory.c
>+++ b/mm/huge_memory.c
>@@ -4121,6 +4121,9 @@ static bool thp_underused(struct folio *folio)
>        if (khugepaged_max_ptes_none == HPAGE_PMD_NR - 1)
>                return false;
>+       folio_contain_hwpoisoned_page(folio)
>+               return false;
>+

One question.

When hardware detect error, it would immediately trigger memory_failure()? Or
it will wait until the memory is accessed?

>        for (i = 0; i < folio_nr_pages(folio); i++) {
>                kaddr = kmap_local_folio(folio, i * PAGE_SIZE);
>                if (!memchr_inv(kaddr, 0, PAGE_SIZE)) {
>diff --git a/mm/migrate.c b/mm/migrate.c
>index 9e5ef39ce73af..393fc2ffc96e5 100644
>--- a/mm/migrate.c
>+++ b/mm/migrate.c
>@@ -305,8 +305,9 @@ static bool try_to_map_unused_to_zeropage(struct page_vma_mapped_walk *pvmw,
>        pte_t newpte;
>        void *addr;
>-       if (PageCompound(page))
>+       if (PageCompound(page) || PageHWPoison(page))
>                return false;
>+
>        VM_BUG_ON_PAGE(!PageAnon(page), page);
>        VM_BUG_ON_PAGE(!PageLocked(page), page);
>        VM_BUG_ON_PAGE(pte_present(ptep_get(pvmw->pte)), page);
>
>
>-- 
>Cheers
>
>David / dhildenb
>

-- 
Wei Yang
Help you, Help me

