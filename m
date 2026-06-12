Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E6A04CD98CE
	for <linux-mm@archiver.kernel.org>; Fri, 12 Jun 2026 10:09:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1D7696B008C; Fri, 12 Jun 2026 06:09:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1885E6B0092; Fri, 12 Jun 2026 06:09:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 077E76B0093; Fri, 12 Jun 2026 06:09:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id EA54A6B008C
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 06:09:13 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6F52CC14E2
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 10:09:13 +0000 (UTC)
X-FDA: 84870837786.23.87F2305
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf03.hostedemail.com (Postfix) with ESMTP id 019AE20002
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 10:09:10 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=NXOYlKSR;
	spf=pass (imf03.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781258951;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rLtZCrTqCWSUxUR2OciFR75Mxr1mj0TTxaB5GR/zvj4=;
	b=l56uGlXd60mWnYZfL4MVbfTG/VSmNo3Dpm5wq04nUPojeyBKLKpXHWpFqKAFuf3G6AZNe6
	yk+ogq7L98fQyeY/VysgtfRYK8uyCgUjP5g+qTLLlCtPPsblffEBfiWxoDTwIg+7umGHdS
	e/gOxvi+u+AFk3bB5EWGmNqPANCQtdI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781258951;
	b=F2CA3my58zu44keIYO5YKT0HJtOBEyvC+8FRBtGZeE8X4VN6XgLOsvbSO6oW4BQlAGkrzw
	0gJfRoIRQBQFeI6eQSKjeQtZlnY6K93HX0QR5ygWi1Qlo9dTa1v9wDw4n11Zz4mL3iAivi
	ViOna5ndWdWeWpMGkugKzviXhRbqbos=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=NXOYlKSR;
	spf=pass (imf03.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1781258950;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rLtZCrTqCWSUxUR2OciFR75Mxr1mj0TTxaB5GR/zvj4=;
	b=NXOYlKSRc8s7GoxCLzqfX8kME8/ZrVceOvCjeJh3tPSISdDg3vBYNSyDBnciV5rsih/D3S
	z5HzZZW9LZaBO2e4eDWzJYpBIv0+kfO2cZz77JnlFJbIROmR8bhMAVO315FqsKqzrCWBho
	X/RvOLMGRtJMghpKiurFc/jeftYD9Zw=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-557-BQHd1vB8MVaZOebs4YhcZA-1; Fri, 12 Jun 2026 06:09:09 -0400
X-MC-Unique: BQHd1vB8MVaZOebs4YhcZA-1
X-Mimecast-MFC-AGG-ID: BQHd1vB8MVaZOebs4YhcZA_1781258948
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-490b79e6b94so6265195e9.2
        for <linux-mm@kvack.org>; Fri, 12 Jun 2026 03:09:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781258948; x=1781863748;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rLtZCrTqCWSUxUR2OciFR75Mxr1mj0TTxaB5GR/zvj4=;
        b=o9cupTtIqjZjgdwkcQw4ISab1tEe58XNsc0E7ftyVsSB7D1KxPKuuELSZsSFVL0gZd
         JXzr/cOuvD55PaVavTn/ePcJ1fLD6psCglkuviq9dgnOnZxxWMSlCyq69H89dMn1YyxJ
         PWj7jIfOPLTi9Hq9xHobe7n7hv9sKHxc8GfJ3n2xG++hAB6NSvyLww/vD3FQ2mBtL324
         VXBlJO+wB2+v2gGH1buqspTuS5CZi/yoBGsl0TmD4DRtNGN7yamFq/Cb/6OsH0l+JGET
         7dIjm8zLCFIrhNBRrFYexxj6PMcGgLTUHXWZw5jc1A78Gq0S36xrLsM5SiNfdM5uaHiz
         h2tw==
X-Forwarded-Encrypted: i=1; AFNElJ+n5aq3aLNVlijWq9o3BqDOFn7sbaYgnMKmEM8yBQHkrVeD9JHlbUq91/kw6E/bBIQ7lBhIgseGsA==@kvack.org
X-Gm-Message-State: AOJu0YyCAYGGyHsBAgJy10FCbBMUx/6Li130ZWx+cHyQ35iXQOg9QIEb
	HZ3fgI+j7oYqRyqnbFg4IALGKOfPqovjm5GS9XcWFjIPtaORFlFd52VDrJvV/J6P592O6oVVQlA
	EmCr0cr5YaNvQEGofCzaRxsHh2bQjFSDtiSiJlBWhpXKu0hUFcEqp
X-Gm-Gg: Acq92OEUaQG2NkUPAD+KEmHXrEUhUVABr/LPZVUj2RhU3O1WTFKgNuC57GHVaEQkWQW
	DgF4HOyDJDaT8foK1tmqj5/o0fJDP2DjcXFIz/0bi6ObbGRRsQAU4/cI6jJGHCiqWT+qynIpwTm
	TNildMG16uLx66Zl955NXep+gdCJJ+9YBbm7RFMlks30ptVP5uYnKCSTgoFKIVvudkBFOyuiBn2
	pGizg2mdk3w0QAXMl1R5xRcHMPQF0NUGf25VwHBq3cLCymYVZk9V+LCTQK9aZmpBvAhWD5pJT4f
	xOXfEHyDLdr7VeLfNEHI6c6u2aPoh/3CbWO6or89t8BRicyzDblCj/xX1YUYxlaIO9Nqj6seXR3
	jDG6Cm2UgRC5LIGteS4k6gAXpKI6kdAMl/Vz0pjlPc8oN8Lv4+bFLSm6wM+/Xbp6b
X-Received: by 2002:a05:600c:3548:b0:490:e196:e8e3 with SMTP id 5b1f17b1804b1-490ec501a29mr27479195e9.18.1781258947918;
        Fri, 12 Jun 2026 03:09:07 -0700 (PDT)
X-Received: by 2002:a05:600c:3548:b0:490:e196:e8e3 with SMTP id 5b1f17b1804b1-490ec501a29mr27478485e9.18.1781258947457;
        Fri, 12 Jun 2026 03:09:07 -0700 (PDT)
Received: from [172.31.99.182] (91.red-83-48-118.staticip.rima-tde.net. [83.48.118.91])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-490e2d0fb23sm135494125e9.15.2026.06.12.03.09.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Jun 2026 03:09:06 -0700 (PDT)
Message-ID: <10091ced-d472-4bfe-9cb9-8e7def23c213@redhat.com>
Date: Fri, 12 Jun 2026 04:10:20 -0600
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2 01/11] mm: khugepaged: add max_ptes_none check in
 collapse_file()
To: Baolin Wang <baolin.wang@linux.alibaba.com>, akpm@linux-foundation.org,
 david@kernel.org, ljs@kernel.org, hughd@google.com
Cc: willy@infradead.org, ziy@nvidia.com, liam@infradead.org,
 ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
 lance.yang@linux.dev, linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <cover.1781083630.git.baolin.wang@linux.alibaba.com>
 <2ae023e4c9f5270482c99f244af5d3a40fc49165.1781083630.git.baolin.wang@linux.alibaba.com>
From: Nico Pache <npache@redhat.com>
In-Reply-To: <2ae023e4c9f5270482c99f244af5d3a40fc49165.1781083630.git.baolin.wang@linux.alibaba.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: j1O-PzrcZiN7NMAn5rZPeZM2HWZgbEwvQgQoyQtuLCM_1781258948
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 019AE20002
X-Rspam-User: 
X-Stat-Signature: nc7z17r414ri16datmtk44ez6ngy7b3u
X-Rspamd-Server: rspam08
X-HE-Tag: 1781258950-956067
X-HE-Meta: U2FsdGVkX18Dca5/wBB6/5UdPqDlD5zsBSQdaax1maRaIhThx+WocxnLtg9Zlby+Rl9WIiZ34BGVY7DdCgAWKKqMlZqrb1uyxoyrwKG6J8uqScLhFIYT7T768B3DMBIY8s5LxM+5b7hOIEeIIiTijLiE9xuq94YVaZ47fo4kQs4hVVoV9LDpMqcbZTzrxlRXUEo9BTNe0D/Ix07EfGIFp6bW9vSNydwCw8BS2FvKfBkPNA1aoca8TPT/4IjJV/PkT9pjscPVGOME3a+ahgR/bHaQajVP3LdiNOGpHmJEfnkL/sYOqZQy8DrY92p5IRe+y2ZvhK0ZR1v540NxYh5znqn/MeQh9bN/tfnFxEL0kaBnXq6/HKKffe1iG/4/GhqM62d/s852RTrxr9EUDI3zgIbvYxCgoeOAQ9f+jQJe9nwAeoV6L8a3pf4s7/A8J34Pg/uiJ0hQKF1amd+4h6uJUh0u9ivjhlRLVgEHiKUkU9Be1Y+TxLjS2x0HkOJ8k/tDOROC+cpsfiuJNh13B3arQNR7t86EePbMdnmMoYqJY8tlQCVPsvvVKqw+pCR/wPtA6nDm5uRtuexhvRNALQitMEAbGOcHdPb8lmMNUNe4Y4Z+3ewEc9cjvB1cnodqs869yYgQBubO2BvoPpZqg1KyqNoEtCSa5wv3cRAD3W/BvE9k5NG+RLuxeIchq0wkcfSpmcWlytieLh8++87fPJJEMI2scrDvDTHsWD136XHOyrPmb9cbh91NdRTkkkTkd9/xb1GVSPDhwSuRKgle2UULopmNUnJsYaH37mN41r55NWSffIAKgoGIVHrK0lyoviWmeP2tDOxiFlemeamPnSJcdwQJI+bTIzaWDMtYBfPNpaR5BWHgi0fLaGm6VVnJLj5SZjNkyN7lsg0+c0Hafa6Zqcs70SMqOR/5hwHCL7vO/rP4PLXnJ2RUSxYWteYJKu13h3gk6u1h9fOTSXmiHkp
 KdjpIcut
 Mcc0M8da0OTdVgMI6yp9TUcMJzVwrP//ugYU4WwiAk35iDG/am07w0DsStoAKMpt1GdeZ0uiUKGKb8lL2k+2P3JRwkLBrTXFFdg31EUoCklw5JwvRNsiVwSV53+YmPjKfN7ILNXYgpY6Igk/i/DxG/cYicUSbjgCxpUALoygOqkmpveI4Hdi8tmmXKtYM64amFJu/xOWNh1MkOX4Jw45L/Tx1CnPrus6TdCUUCWJBoFpVVm8664KNUI2d1D95V7FVi55AJ+GOKZIauHH2gvSvRskSrKAfzIpPAahMMdZABet85Psu7h4CAMH0baZBgeQxR4F2o1A7Uxy2kyW4nSKCFKAXhP6VHE8vqUkSddV7gSaE0wQ36fBTTYgA9rtzc4sdacvM6uGby3P7IhQhXmUgRj9VMOcBddY/gHfa9Y76pAYtbSxcmqVkQzrGRw04h44wJV3E/LdBibK2KP3JOyJtRJsnKE7c88YV8Cad9Urwuk4/etk3j4JsCsB5En1y3p0o0fl4WrBtOvO2BC0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 6/10/26 4:29 AM, Baolin Wang wrote:
> Similar to the anonymous folios collapse, we should also check the
> 'max_ptes_none' when trying to collapse shmem/file folios, which is
> also intended as preparation for shmem mTHP collapse in the
> following patches.
> 
> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>

Makes sense! There is the worry that we might have to move this into one of the
helper functions I plan on introducing for collapse_file(). This function is
very long and messy and needs some refactoring... Working on that.

Reviewed-by: Nico Pache <npache@redhat.com>

> ---
>  mm/khugepaged.c | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index b12187709f6d..631459172e19 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -2234,6 +2234,7 @@ static void retract_page_tables(struct address_space *mapping, pgoff_t pgoff)
>  static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
>  		struct file *file, pgoff_t start, struct collapse_control *cc)
>  {
> +	const unsigned int max_ptes_none = collapse_max_ptes_none(cc, NULL, HPAGE_PMD_ORDER);
>  	struct address_space *mapping = file->f_mapping;
>  	struct page *dst;
>  	struct folio *folio, *tmp, *new_folio;
> @@ -2299,7 +2300,13 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
>  						goto xa_locked;
>  					}
>  				}
> -				nr_none++;
> +
> +				if (++nr_none > max_ptes_none) {
> +					result = SCAN_EXCEED_NONE_PTE;
> +					count_vm_event(THP_SCAN_EXCEED_NONE_PTE);
> +					goto xa_locked;
> +				}
> +
>  				index++;
>  				continue;
>  			}


