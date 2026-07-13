Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C2C7DC43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 17:30:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D39566B010E; Mon, 13 Jul 2026 13:30:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CE8F76B0114; Mon, 13 Jul 2026 13:30:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BB3A16B0115; Mon, 13 Jul 2026 13:30:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 857606B010E
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 13:30:47 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1C9DA1A0134
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 17:30:47 +0000 (UTC)
X-FDA: 84984443334.09.6EC3D8A
Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com [209.85.167.45])
	by imf01.hostedemail.com (Postfix) with ESMTP id 432774000F
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 17:30:45 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=IGhRs+ue;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf01.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.45 as permitted sender) smtp.mailfrom=urezki@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783963845;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=51jkDGqcYSlWtUq0/oF4m7PdKEgEv1ezQg2syRvYV9I=;
	b=ZtDsptrZPVqdGduNMqIQLn/UrTgYPlRy5Sg3A6lMHAyn8zjGLPGq5RSWirBdA3jLKXXhic
	7y/uDOUmmpV8ONEmil/znDIMkN9iz4fGrd+J+ybh0wmX7xoQlOAK5l8RooTAcj/xgUFKN4
	H7iyHBm9twOC5AnAmWvOlLewmfamoTw=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=IGhRs+ue;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf01.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.45 as permitted sender) smtp.mailfrom=urezki@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783963845;
	b=jCOUieol2+RFY+Nf55MQRLbl0Pi1VuimJTIE5lLRPKe+CUdVIGjiBiG6sQ/7vM2jg55kuo
	jQN+09SBEs2J5k16p0rHTPzf/Xn/d7ep7NLUj0qwxlCQ8TBdloP/rmUU57QzAEzPGbxw5o
	vr+qUwILAoYms/X40DdJDCIGXGzfPXI=
Received: by mail-lf1-f45.google.com with SMTP id 2adb3069b0e04-5b015532f7bso4010951e87.0
        for <linux-mm@kvack.org>; Mon, 13 Jul 2026 10:30:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783963843; x=1784568643; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=51jkDGqcYSlWtUq0/oF4m7PdKEgEv1ezQg2syRvYV9I=;
        b=IGhRs+ueXDzBwML45i059CN9vMZ8WbeMIVSyK46C40pq30BuJDCc7VAVvPCQIZQn3S
         Z0F6jK8z9kQT8WV1CwktiKy3yNRpiVlkp/PLgXpWZDhrO0xX1nmP/iRn3aL/jjvasiUw
         MS4+sJMOkPUU74GdTJb+c8vzRJd8aqOk5CflsLn0rAeYna9aPVQGiVF/Lj5KL5TPqHJi
         aNTFkDBKiE7dLEuu0mT0BA4ipbofnl4neRQC7YgM53+8VWSGDG5CRBXKNmw5U9hO2mZi
         XDsvGRh6r9qOD0dlWPcfMyzG+roNTENWMrb/tyKdfaOjeaav8Sdxp0mtOcT7HOd1JLv7
         aV0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783963843; x=1784568643;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=51jkDGqcYSlWtUq0/oF4m7PdKEgEv1ezQg2syRvYV9I=;
        b=Oe2HD85xEQ4t7YNSnErU7vgd+WCapThPrUKA8A6L80C17IVZYimso6FIWkSn+H8NHw
         NdXl1gZCzaf8fZdQJuO7xUWOe9B4opJXbL5EfTSaabCTGmJKVGC2FB+BBsY7rULaN9k3
         XPTaOt77Pv5Pq6N3llogto1bRmjidwkxy9wWu9ZRD5sYxH6ZUxZPpIiFUMH7Tn5m618X
         ow8rj9oglw6d7VRmrsMEl88A2BTDZzgRQb8HBcGqQogvwJTOoH/8cjDBwBp98E2kROmN
         NDqHYQOBHPBHDIO0E5iSJ33G6OpbmSFdVcxXtLjTiIMAOnvKN1PhSCp76zSDg+ns28mH
         re9A==
X-Forwarded-Encrypted: i=1; AHgh+Rr7xDsnsiGHaRTJ38pFkIhCIn5Vf3zSPVzEQEtCKrt08Fy+ShsDxNrx0pwT8PTF3Q3CXUIJ22Cghw==@kvack.org
X-Gm-Message-State: AOJu0YyKL4/XslQeA93L3THPke0rhHSFyqnaqQ+h04tFfRMaedwDw9kY
	XifGb2XHC4XkWHDcZ5S1O1YaBJjHueY/UWsWEq1Ms5fKBTPtCQP+7Ntb
X-Gm-Gg: AfdE7ckZ/AdSZB3SfgiDXsncxpnshyftkCdTKjm31MF0UR4IbvTElYfQvsJv4l81Kqc
	wsl2n8tgYA9iOVkBAGdBVnV2cR02/0O0NY/vFmEphekPuFCgP2u5WGlW3m/O+gaAdDIZSAQnoLw
	ltG0RhrqJSl29R75cGlHn4aJaLJFKSZQauC4HFkB6CauuQiJHn1St4nWkNA+yQoUfQyQolyTITf
	baJM6M7cMJlyjm8OTG7K90EpG6iSdJIU+j87nAPCkF5Ssx7ZZD2Y/oe3INFw0TDf1x0PpW9vOHr
	tGlrdWeRwnTPz7KErvFchx0b8u76BTvrTcOVtQtGIVgfE7N5nC1zATUhKk0k70hfcZUXaka+2jD
	d97Tc0NFSk2iernYWi8YgZOf8YOF5JztBOdEt1phB6NHrJNg5Ze+v+0ydgiojNPHR
X-Received: by 2002:a05:6512:3353:b0:5b0:ceb2:1974 with SMTP id 2adb3069b0e04-5b0ceb21b1dmr2073653e87.14.1783963843127;
        Mon, 13 Jul 2026 10:30:43 -0700 (PDT)
Received: from milan ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5b01ca5559csm2984970e87.36.2026.07.13.10.30.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jul 2026 10:30:42 -0700 (PDT)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@milan>
Date: Mon, 13 Jul 2026 19:30:40 +0200
To: Dev Jain <dev.jain@arm.com>
Cc: Wen Jiang <jiangwenxiaomi@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>, catalin.marinas@arm.com,
	linux-mm@kvack.org, urezki@gmail.com, will@kernel.org,
	Xueyuan.chen21@gmail.com, ajd@linux.ibm.com,
	anshuman.khandual@arm.com, david@kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	rppt@kernel.org, ryan.roberts@arm.com,
	Wen Jiang <jiangwen6@xiaomi.com>
Subject: Re: [PATCH v6 0/6] mm/vmalloc: Speed up ioremap, vmalloc and vmap
 with contiguous memory
Message-ID: <alUgwPT9uh_EWItt@milan>
References: <20260709073823.6643-1-jiangwen6@xiaomi.com>
 <20260709160805.26e63bae89dd03cf2951104e@linux-foundation.org>
 <CAHKocdH5kp5kTtZht+v5j-4-Thh40TGvif3=kRMgErRXr+Q+RQ@mail.gmail.com>
 <54434a84-51b3-4e3f-988b-6bcbac5a2f42@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54434a84-51b3-4e3f-988b-6bcbac5a2f42@arm.com>
X-Rspamd-Queue-Id: 432774000F
X-Stat-Signature: dk848j5w1xijtfwj8p95gdehzhi6n66k
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1783963845-742323
X-HE-Meta: U2FsdGVkX1/YYqrnelbDfrBnw/5i8rd0oPitZpZEXwBYt9HCOXRhliiMSBOZ1VeWvYswEj1twUAyIOTRL+MkAlK0PpPkWyC7e0qPy23qP7+n/qre0Mpk0m0Oe88xAUcL8l7PhFRf7jA5blMLzP6VTejr5F2uk7klZd2qsysczD2enM9264XeKUtZUJE9n4s0fpFpDq51ZheROP3kAr+gDLdkZ2acjza2jqoqAkwCTsb6ZKgwBG+v9nbStiI+rrGzTTPk6yVcwCqO9x4UttZI7WpUnjTqFRTDroGdAYMQ8IuBSMYApZulgpGE+qrBc0uR3MwCujWfq/J0UuqT4ER1vie3YwtvBBy5i73bK3okw1LO5YG2SgtaULc10oZ/CzI1+wMQUDoj1hdd9edBx+sypQhkzyWQBzMP956aZ/vCdK2uqAXqB6a88hcj+9JI7nw/rC7ktldKkMfxGIAKZwxYgRAYgUfU4/6zj/J2iTd+4f1TS7kIczh3Z62vFHtmoSrqEvSf3Q+jYdFzxbguRjJ1iY6XwEByyftdRQUaHLLW/Hj8GYMncdSxv8HqpRMmR9TR83XDAbGPxy/rinkH+EX7E45kqRaFAVOALZFK/Mzp9r954I1YXHxXiSuhTobFutexWmctHAtdNjtk+7xTzO0x2pUfyd/vGfUFSZCtsMHBLe81qPJUNNx0wByR4oCOrN09vgZSCqh/1bbT+/MB9V5qEnk9zr7zMCUAwXGcgkyA0SA+pc4gznvvoaQSFr5NRQhovJcB2yh9yzcsaMyVc52YfSTTZt46c1S/8jfmWArc2GGIAfhU4WF24A0dsX+FS4KSHzOrf9cauaAnWjNUdTUGoZi+QlLEGAkdb75q6Z0027gXPexoz6B107R3vWEB3XqksmJEwAs4WAdQ1gSy3ZMzt/5GRN8DlsoOk9iqjPI06Dus0jTJQtRlYK6hXK0fITEK8rVIZY97daIcgLOrFvi
 t+QXXXRB
 nAi9FQmm9asiVKw0fXOeW6mkUn0oRV0F8OhvYNxyXAKWq30MV4DeJNcwJXVN1D+A9pq89YFL0/IHDfJRcRTg05LteEl0SOxU6k0Q+WSIG3jl3bkguweolZQctlfwa83xOqb5GnScGRoThMp5Ef1IRZzTHd7TlRp5O9re2rkjMMJm80ZMT0MQeS+wLo0AzuQ28j/skFmUvTB0vTRnPoa7rgIxgK20dSizWMTks8x0qU1lGAKca5ZxTdzjBzcDt03aReNWuvU1XtaZkMjFoTwpCzQP4qcxFi2cWz9YD+0xcHArvLI5WQQPkJ+d/SoDmZGaQViRiJWPaftIKkzAMWJm6PMb4qH0KbFoBlNBiC5o5sibf5wBjCz4dGbE94dUmzKmZ+ysA8f1AiiuVT1I+DA9smSoiDTKSw2YHfEpPHWaZwdxGHQyX8V0gF7kgNIDh0ZFlksWGZgl4FcK6Jier8chxxEDV7I0Vm/+P4sgSbMfq1Rlx4vzBZ1dzu9Xt+Z70Qkd57mUB73AohqWxAo+oZEAdXKjZINXOxbnbOeuWgKBIHJis4QIhzHYGWAnPCydIiNjaO3M7nmq3Sx5OQ1HUUC+YNWl8UXJEwL/03Wma4Nn6gcmvAvRMbfO49OzuzDlPSVNyCoy+lma3vE7vw6EoibEkeoca+q7bBN+jkAr5CcV35A79ZXn3EW88J0whKQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 13, 2026 at 08:43:14PM +0530, Dev Jain wrote:
> 
> 
> On 10/07/26 2:24 pm, Wen Jiang wrote:
> > On Fri, 10 Jul 2026 at 07:08, Andrew Morton <akpm@linux-foundation.org> wrote:
> >>
> >> On Thu,  9 Jul 2026 15:38:17 +0800 Wen Jiang <jiangwenxiaomi@gmail.com> wrote:
> >>
> >>> This patchset accelerates ioremap, vmalloc, and vmap when the memory
> >>> is physically fully or partially contiguous.
> >>
> >> Thanks, I added this to mm.git's mm-new branch for wider testing.
> >>
> >> AI review asked some questions, and some of them are new since the v5
> >> series:
> >>         https://sashiko.dev/#/patchset/20260709073823.6643-1-jiangwen6@xiaomi.com
> > 
> > Hi Andrew,
> > 
> > I've gone through the Sashiko findings:
> > 
> > - Patch 1 (find_num_contig): Over-interpretation. No new hugetlbfs hstate
> >   is added. The extra sizes are only used by init_mm kernel mappings via.
> > 
> > - Patch 5/6 (NULL page): Invalid input. vmap() expects a fully populated
> >     array of valid struct page pointers.
> 
> Correct, but vmap_pages_pte_range has !page and !pfn_valid checks.
> 
> I really hate those checks - if those checks have any remote possibility of
> firing, then we already have a bug at
> 
> vm_map_ram -> vmap_pages_range -> vmap_pages_range_noflush -> kmsan_vmap_pages_range_noflush
> 
> because the last function dereferences the struct page pointers.
> 
> It is painful to do the page array sanity check deep into vmap - it implies
> we simply cannot play with the page array before that.
> 
> But since vmap is an exported function, doing a sanity check for the page array
> in the vmap code makes sense.
> 
> So how about the following:
> 
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index afaa14ebf17bb..0c44bb7a45b5d 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -566,14 +566,6 @@ static int vmap_pages_pte_range(pmd_t *pmd, unsigned long addr,
>  			err = -EBUSY;
>  			break;
>  		}
> -		if (WARN_ON(!page)) {
> -			err = -ENOMEM;
> -			break;
> -		}
> -		if (WARN_ON(!pfn_valid(page_to_pfn(page)))) {
> -			err = -EINVAL;
> -			break;
> -		}
> 
>  		pfn = page_to_pfn(page);
>  		size = vmap_set_ptes(pte, addr, end, pfn, prot, shift);
> @@ -603,11 +595,6 @@ static int vmap_pages_pmd_range(pud_t *pud, unsigned long addr,
>  			struct page *page = pages[*nr];
>  			phys_addr_t phys_addr;
> 
> -			if (WARN_ON(!page))
> -				return -ENOMEM;
> -			if (WARN_ON(!pfn_valid(page_to_pfn(page))))
> -				return -EINVAL;
> -
>  			phys_addr = page_to_phys(page);
> 
>  			if (vmap_try_huge_pmd(pmd, addr, next, phys_addr, prot,
> @@ -3663,6 +3650,19 @@ static struct vm_struct *vmap_get_aligned_vm_area(unsigned long size,
>  	return __get_vm_area_node_aligned_caller(size, PAGE_SIZE, flags, caller);
>  }
> 
> +static inline bool vmap_page_sanity_checks(struct page **pages, unsigned int count)
> +{
> +	for (int i = 0; i < count; ++i) {
> +		if (WARN_ON(!pages[i]))
> +			return true;
> +
> +		if (WARN_ON(!pfn_valid(page_to_pfn(pages[i]))))
> +			return true;
> +	}
> +
> +	return false;
> +}
> +
>  /**
>   * vmap - map an array of pages into virtually contiguous space
>   * @pages: array of page pointers
> @@ -3706,6 +3706,9 @@ void *vmap(struct page **pages, unsigned int count,
>  	if (!area)
>  		return NULL;
> 
> +	if (unlikely(vmap_page_sanity_checks(pages, count)))
> +		return NULL;
> +
>  	addr = (unsigned long)area->addr;
>  	if (vmap_pages_range_batched(addr, addr + size, pgprot_nx(prot),
>  				pages) < 0) {
> 
> 
> 
> Reasoning for calling vmap_page_sanity_checks() before vmap_pages_range_batched,
> and not at the start of vmap: I am worried that since vmap() is already very
> fast, we may cause a regression:
> 
> vmap() -> scan page array with linear map pointers -> vmap_get_aligned_vm_area (does
> memory allocation, throwing out the linear map VAs from cache and TLB) -> walk
> the pgtables and again access cold page array.
> 
> Perhaps I am being very pedantic here. What do you think?
> 
Sanity check adds extra CPU cycles and it adds overhead. The concern about cache
to be cold on second iteration looks valid. You can get some perf figures to see
the cost.

I would just keep the original approach. But no strong opinion here.

--
Uladzislau Rezki

