Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E37DCFF6E9B
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 23:23:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 21B5A6B0098; Tue, 17 Mar 2026 19:23:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1CC6C6B009F; Tue, 17 Mar 2026 19:23:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 095026B00A6; Tue, 17 Mar 2026 19:23:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E76126B0098
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 19:23:14 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 64AAAB94D0
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 23:23:13 +0000 (UTC)
X-FDA: 84557133066.22.47AC2EF
Received: from mail-dy1-f171.google.com (mail-dy1-f171.google.com [74.125.82.171])
	by imf26.hostedemail.com (Postfix) with ESMTP id 78791140009
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 23:23:11 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=G7rt3jqg;
	spf=pass (imf26.hostedemail.com: domain of vishal.moola@gmail.com designates 74.125.82.171 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773789791;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XN/qOC5CJ/bhMlRJKWhmjAU6IJC68YMTmoD5LWl17yI=;
	b=dYy/JKQ7iRyblvz78nyhW589HLkuJC6qHy6VBDlA9C+wpR/8QSuhgHnykxeX/rvJJq8Xik
	/ncZVMpKeZty0wEuHbuX7bqiQPPlTFT/dooJr+Ld9AUvduW7/N2ME1cp3UOaajTxXNuA9z
	diB0RBtbpnTa40jaUFHhD6eWQPPfgIY=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=G7rt3jqg;
	spf=pass (imf26.hostedemail.com: domain of vishal.moola@gmail.com designates 74.125.82.171 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773789791; a=rsa-sha256;
	cv=none;
	b=sfTW931hxCzp2ERCTbmQjLBTs0AuZ87WXRIU1UPf8nMlPZOHTfhSe1Y+Mx8NlDMr8XsLwL
	myO4XzB6p0MawdS1B42URULKRo+kq5NEM5zkrVgbJmakOkj8k9KM6x0MdBFlaSNERQkRA1
	nIEGXdHch8gpaHfizHHn7XT+Qs//tz4=
Received: by mail-dy1-f171.google.com with SMTP id 5a478bee46e88-2beab594d8eso1345504eec.0
        for <linux-mm@kvack.org>; Tue, 17 Mar 2026 16:23:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773789790; x=1774394590; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=XN/qOC5CJ/bhMlRJKWhmjAU6IJC68YMTmoD5LWl17yI=;
        b=G7rt3jqgvj9lUy8QY8izvjt6owpgWPWEXj71SHfvKrD1ASIiTzFNDwncdtyiz8x0WX
         dKKnYUCgJMnc3IsbS//Zj2thtUjTpmCBKWZ88WxSmW1m+xPlpM6w9dJ3tzRQrY5IzlZ0
         YfVVj6RwXBm2tlz4GAWeTdiFeuwMo0m9VMpD7HkJH35M+s+VuGxtJ31SiRHLvI4BFH+2
         oGq4Mqs4u0S2rYmrIF1a2+GLbtM2anIOcRwWSNzkzOqAH/dL7I0Ua1FxLtqLWBOLFwos
         CzbSnpL8muGBA6u7d4AH3GOmsAiwvJd2FS4NvLAJdlJkOUpk/KmW8XvLGEvnAHCI0hB5
         C08w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773789790; x=1774394590;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XN/qOC5CJ/bhMlRJKWhmjAU6IJC68YMTmoD5LWl17yI=;
        b=BFAOie8yRDFVIYRJk8jkEr/8RjajS7poBDgkkmKdr1e3A86x1l5epmWqQIABwL+fsJ
         lWaZGGp5mUr+pWmWpBxu18tg+RfILp1G2V1SnbKSbJMPtde/5OoTuBB48IAp589UnKr/
         CXlgYko55T4lfcqBtcF2uyf3f8eODx3+fpYeKPoJ4HeaJCEfqWpxWUCKgIJE+kamiveu
         ZmsEVwY3l9DBcyjSKNtAZr/2JzY+/++xNb9B3W5FH0Gg7IDee8xL8MNYvivGa33h6r+r
         c9x7nhdb0E3r76lRo3txJCZBhBO4YXoeAUoicTZvT1xRS2dIIN8ALqbbs4tjHSHIE5U6
         mRWw==
X-Forwarded-Encrypted: i=1; AJvYcCWFQ2dzLOftvuOu5+De2FcYDaOG1fvZ7NVxUN9YPeO7mOIio9Hrkm7QH1Ju+WqzK36tn1WMttCjrg==@kvack.org
X-Gm-Message-State: AOJu0YxFAV09zgMvn4OyJ9ry4uFmRz8fJWbAM0OVdk4VWeFA+ojNEx9J
	Oygl47OZfW5g4wSrmLYKWTy+G7sFJ8RMxT7FRNUye1qu7qeHbTv0iPpe
X-Gm-Gg: ATEYQzwVhhiXK1FXJCxCVnFASqzLetJgUF1IK0mPb8vjzWDpP9BqQjAt2yjJZYS0kj8
	18lCw73ThaWFFs87UD8RvJEs1P4tq/CTxtuxPHbx+LPcaddnFhLI8k1OUIaSEpmNgGp8ZeIBuIl
	YZlE2datIntJgO1WPlT8WUz44G2v0291yKgtgBAlbtmXDup73ak+tVDN1nkaUpAQCieSazuW9y8
	UTjQQRAyF5AYTtOTffGJZBSKUy83XmMSIOQwhYpVprbRp+wrbSNRo9YlbJ2iMZfryD8VwWZg1cT
	Vt61itDq+l5o9PeXFwlgaP1DBfgnaJihYqZ2zppiJlEU0CiCBvBtzOJ4yL8Rc32p5FdTCMfqgG7
	6BoBPWF/h++/eL48UnTjmnBblQLHROnk5x90aCjTfvHJ7f2Qth0ri6lO+Iong0xY7chMnRTGweL
	IHzBBqfnSMj9gl1IK3yRTTwLTot3xjK7KmZHJXjtmUDNs9O74w6LMy5W37EaAXv696+pVikVGuR
	lQ+CtQKb7wcSig=
X-Received: by 2002:a05:7301:2e89:b0:2be:2f58:2ef5 with SMTP id 5a478bee46e88-2c0e4f5b103mr758591eec.1.1773789790054;
        Tue, 17 Mar 2026 16:23:10 -0700 (PDT)
Received: from fedora (c-67-164-59-41.hsd1.ca.comcast.net. [67.164.59.41])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2c0e55cd9cfsm1356744eec.26.2026.03.17.16.23.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Mar 2026 16:23:09 -0700 (PDT)
Date: Tue, 17 Mar 2026 16:23:07 -0700
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
To: Michal Clapinski <mclapinski@google.com>
Cc: Evangelos Petrongonas <epetron@amazon.de>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Mike Rapoport <rppt@kernel.org>,
	Pratyush Yadav <pratyush@kernel.org>,
	Alexander Graf <graf@amazon.com>,
	Samiullah Khawaja <skhawaja@google.com>, kexec@lists.infradead.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v7 2/3] kho: fix deferred init of kho scratch
Message-ID: <abniW3D8wbGQcB5T@fedora>
References: <20260317141534.815634-1-mclapinski@google.com>
 <20260317141534.815634-3-mclapinski@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260317141534.815634-3-mclapinski@google.com>
X-Rspamd-Queue-Id: 78791140009
X-Stat-Signature: c4aknbde5p8khehn5zxa5zmhm1nhn1ub
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1773789791-499102
X-HE-Meta: U2FsdGVkX189xLMqyz4L7QlZLoXnvKOFnDqA86MsG9mZJME7ChmWVECxVHpJj5HSbBZzJHZCh29E7Ii/TZHw/clXtG6+oGrvfeoQKlD/Wco+A7PJ2guumLB0RI5b5qKH4FQZsArxnMssNH7DkUPoeYugFWs+hNXddC70LnIklaPopHD1w/zYVJJaK8PHS3tTSzO1D/eQP53dc0gKnT/Mo0VygP2pviefwhrZSp8HDYnQRW3eDgr1VqhWtx+GkunN5ww7B1d0oX0/2ydkE40q97bhQHpSUFB0ah2c1ICA/JGl1j6q+khtoWO7Ou+73Y6WuZQ1SnTpmY6+PHYv6otHcYTLVmn+aLxgFjxAKcBPN8d8cdEaUDnsO9plqT6amqweVcjJQhnhcfkDXuUPpau2UOzFPzYpavnY2WjW7Ak6TO1DQAwqQnqQYoz2+/OKJQs9JDH8AMTP6LyTxDzwqFwHsE9lmsRK9yhBaMxmeBVZCmRurN7r8+lFUxux1CAr6P8KvVflHXED7ycyRJ7ToV3D9jNlDOMrrIV2ds7IIyUPjH2mBqyrrIAdHazHKd+6RcBM+x2+zrDtcQGNyUEmm3EShtl5GGLMn3/05o+xJPy3CRFj8K2NZ9Vo6hd4IM8dX+r6qIkGMAWxwazvjdnP9k43tPMa7d1zqtZoZQrBO96Z0+KwpJ2xCAEw6gK1XldcPpFZR6Fuf3iWPnN6S8OoZAxfAQF1SE97PDH3G/A9wjCH7lOwVrNgag3udSFUyt16ZXXSCn7lr7LeuJ6ivkljV7PdWjzn+eeRFos0M6gyQbmm84QMwgUPJF87LMOkOJXlPcegLdyGvLYrMKgBw0cE+sNq40OiMcv6Z9DiXspdUl8RbCDytAVLBwrudHtDB6FwPJKsfijmK8BMFwn+ZRazq6MP9Zk6KFXEUSfvkJ9uHyRiSrkjMaZ3HVA/RAewJhb3NYQ3exalPNEoxt+wL6k2UQX
 LqGFkd9X
 yESe3zUZm8wiYVeYiEt9D3phW4cG5jYJnZGvRG2gAqC2Vctf7RLsUQQMWxgEneUohphXVbmNZ5R/jhmnmVi/6NSrNfYJtLTqSkvKRcippI4wun8oBeIp/xe9DNWPTKprgWXj8O63JciRdBui5d+W/lB/yc0/zgZIc70PHjX16ieZe/hzRc22cfIue/MuDHgeKjKE8mwBlMaaG1lEcU7Sb7UJCgm4FKnDjmptZUrCKDPGDFmYREXIxHBWVtCddmzkWf9qAg8W9Ho8YtUefwgQyLfw3jwtMzNBBQklIyEcyOvIDdaHOPaRg66WA/Ah8rFg7tn4rVTaRlSU89uUke5CCKhvYR/N9isFHRxFCMyamj2j1PQwZ1lIdaCs1kYsaJaZcILZ7z4RKmTrBFwvjQI0Qd2oQZVe0g0YobNGI5P+H2zYjMhkn+nvJ9KULrF+I0hvKn7j/rw2YgwLB1xpP8zGK7o84q+ggKfJSUlGbQAPNggnCMZ9Q36B8QFcYu0xFAD+jdCfedFVxeMzEZNjkyvL5U49lIgSN7v+knfTsVlmHccDoBKcBOGLjyCXjL1zQdHq8QFpfsYRwkN7MavubgM1ET0taBg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 17, 2026 at 03:15:33PM +0100, Michal Clapinski wrote:
> Currently, if DEFERRED is enabled, kho_release_scratch will initialize
> the struct pages and set migratetype of kho scratch. Unless the whole
> scratch fit below first_deferred_pfn, some of that will be overwritten
> either by deferred_init_pages or memmap_init_reserved_pages.
> 
> To fix it, I modified kho_release_scratch to only set the migratetype
> on already initialized pages. Then, modified init_pageblock_migratetype
> to set the migratetype to CMA if the page is located inside scratch.
> 
> Signed-off-by: Michal Clapinski <mclapinski@google.com>
> ---
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index ee81f5c67c18..5ca078dde61d 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -55,6 +55,7 @@
>  #include <linux/cacheinfo.h>
>  #include <linux/pgalloc_tag.h>
>  #include <linux/mmzone_lock.h>
> +#include <linux/kexec_handover.h>
>  #include <asm/div64.h>
>  #include "internal.h"
>  #include "shuffle.h"
> @@ -549,6 +550,12 @@ void __meminit init_pageblock_migratetype(struct page *page,
>  		     migratetype < MIGRATE_PCPTYPES))
>  		migratetype = MIGRATE_UNMOVABLE;
>  
> +	/*
> +	 * Mark KHO scratch as CMA so no unmovable allocations are made there.
> +	 */
> +	if (unlikely(kho_scratch_overlap(page_to_phys(page), PAGE_SIZE)))
> +		migratetype = MIGRATE_CMA;
> +
>  	flags = migratetype;
>  
>  #ifdef CONFIG_MEMORY_ISOLATION

I've just tried to build the current mm-new tree. I'm getting this
error:

 error: ‘MIGRATE_CMA’ undeclared (first use in this function); did you mean ‘MIGRATE_SYNC’?
  557 |                 migratetype = MIGRATE_CMA;
      |                               ^~~~~~~~~~~
      |                               MIGRATE_SYNC

From what I can tell, MIGRATE_CMA is only defined if CONFIG_CMA is
enabled (for x86 defconfig its disabled).

