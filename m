Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 33310C5CFDB
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 22:58:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ED1026B0336; Wed, 12 Aug 2026 18:58:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E82186B0337; Wed, 12 Aug 2026 18:58:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D9AA86B0338; Wed, 12 Aug 2026 18:58:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id AEB786B0336
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 18:58:34 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1E64AC01CF
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 22:58:34 +0000 (UTC)
X-FDA: 85094133348.28.4D777B5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 559C3A0003
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 22:58:32 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="pw4B/tZv";
	dmarc=none;
	spf=pass (imf25.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786575512;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Xs9kYarR6shzvLO/ONqDC6uphwPH8pJQ2AhMCAQ8C+8=;
	b=tZEA0wMn1G4IyowHQAJ+x1FtRuesQ8eCdOS1Ur2P3uCqO31tGPrWM7NyDUM1/d84lRGEio
	pjy3DuzoiRTRbNgBRwcsoTM3bGmkeb82zROmxdPpnwg3icJZ5rapDsYDNZo2wCysfAdDMp
	9L/4Nb6P8T1G6Pfh5vdCkqUvLJTC1L8=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="pw4B/tZv";
	dmarc=none;
	spf=pass (imf25.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786575512;
	b=TuizAAYIO0b37OZjkJmZucJu74C0wRFZxl9eJ3C9AYsgttfaNIiYpJf2v8ITH5itIIxs7D
	HBjvgab9C+ZUsnkfY9VxaHzJBWpCI0yFh8oC2+CBkkUL2LPjI1963Cl+uerawk16wyKBvn
	1NO93A3hMFoYmErLoPdpQG2x0JSEgdc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7152A40444;
	Wed, 12 Aug 2026 22:58:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28B831F000E9;
	Wed, 12 Aug 2026 22:58:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786575510;
	bh=Xs9kYarR6shzvLO/ONqDC6uphwPH8pJQ2AhMCAQ8C+8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=pw4B/tZv7K+RDI7ncSfjgc7Xoms5biqKDoIU6JHPsU017gpdwrF1fdqRBvNZ3xhaA
	 9D53P3RktGoUn1C64cj31m5I+GDEkbCHE5Y49Z6o6U1yellQZkMngVS+R/qhccSKBM
	 5aHyOgxcnaHBPcBncentvbCUzc8rxjSxGdo8RiC8=
Date: Wed, 12 Aug 2026 15:58:29 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: liuqiangneo@163.com
Cc: jgg@ziepe.ca, leon@kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Qiang Liu <liuqiang@kylinos.cn>
Subject: Re: [PATCH v2] lib/test_hmm: fix garbage pfn and wrong direction in
 devmem fault debug
Message-Id: <20260812155829.43ebf2838420b8dcab83f55d@linux-foundation.org>
In-Reply-To: <20260812092856.55296-1-liuqiangneo@163.com>
References: <20260812092856.55296-1-liuqiangneo@163.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 559C3A0003
X-Rspamd-Server: rspam07
X-Stat-Signature: 3am87fcq5tp1g9h1dgaxzsxnyxtzxz4h
X-HE-Tag: 1786575512-575389
X-HE-Meta: U2FsdGVkX1/HbWLKanZ9PF46BXC242sGFvW/IiFskQh6TGHVxrbe6czBkWehr+x581rhj0X39LiIk/BVADTpndOOZV4Hocif8dEGY/WU8NQHEMYjwOE0igej9PDmLKJORi7HOampm7jc4xL8CpplRuGUIklZPZgttJugyHZ0oHhb0MyNOF/OlXhkh0FTnSBs7Vaev8sk+P2hZ0mysM/DpuvjfgaZwMm195qmzj9IEf35M6+6MyckhrM34FK3gLurbgVA6BlFlTzspTqvLo3tAgwoFZri+4ACZz0ERTyzhG0GKs/UKpX0udv5I1Q2D4WYXynbnwghWbSLFJMg4lpK4Cud1PWlymHRxvBvtc7iTaEbTU+TqMY5kCIc0BVjjK5ePN/2V+qAmaooNBYHwQXkMjicZhMpw1hTogbSkyc3IROwjw2DAWrmAPP1H6RMASMcDM142ocNkjGVyqO9yvZzU+4hNFB1y5HAPGg+57cwRGLtNBxm3zK3KrLuBTl6pywMxzY2JliO/Qi+Fsv2LC9p3Jf3tFnUjJKAXBfJOKT7l9UbTwmtg0n6kuT/LAkne0+kZWGeSsqU1UGcbekqR0g26723dhGnMIIU3PGpulzSh+puXbo1OLMGw+qAnnVpOmzSSHIO8O0ZEeTpXxhHhQAwoFXPyNx6IPtrhstdTo5siID//Ce7btx/z4WA9vB2TBNtGirtxtMbdt4Y95hbD8ADeqF3zoHEh7RHidpCYfvCyjg4LlGX5i2vx0xJc9mTE9Cn6fBbGe4FuVNDRR4jrHuqjLapbPDCQuODcdpIkqxYAorQbLCUcviLBEk8QV0yZc7Dy0k5+Bg9Jy0p65s10iAp/zymojJl/4Nq4eWjEOSiV/6Ng/KYfZWNt0X8bC9cUYJZIZPyLfC9ujxnItA8KpZgMlJ2tyeGrDX2/lDsUKAVpv3ufszSZJq04fji24PfQ9V7C1JAGpIt5ZxOUcZ8O5o
 YCbl+qMq
 4h7bICEg4NHJixhSmHDeUkXxTQbB+EjO2NAUshIsyDP3EoN8MesN8uae5Wkaah2f+LCxq1XeGsifhKcgju1uVOJHRtvduvpukEUOwMn3nW7heKm8G8ojRMkHw/SkDA4c1kWGpeIVXK2eS5x796zpV5Cv25zEomKKzpbsIXbI3HupcpNSfdHLEXLb6Gt3kX3Aq387ARrxsXsFFh3G/Ue643YKS/ChK+Xwl+o0T2ZJ924NWAtItQeKiUgOZbKZipEboKGxWmDAeb1ZGvTtxy8QJ+qPWzaoa1dkAFUoxK0cwxESIw7mb/GrQjzUqm6kVlI+jbOt0pTkVO64P4H2odK70YXEcr1hbGwgRMOw3K/0DeR8fKKKsNiRXlGaRJXNxH2maeo9e
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 12 Aug 2026 17:28:56 +0800 liuqiangneo@163.com wrote:

> From: Qiang Liu <liuqiang@kylinos.cn>
> 
> Move pr_debug() inside the `if (dpage)` block to avoid
> printing garbage pfn for NULL dpage, and correct the
> direction label from "sys to dev" to "dev to sys".
> 
> ...
>
> --- a/lib/test_hmm.c
> +++ b/lib/test_hmm.c
> @@ -1151,10 +1151,9 @@ static vm_fault_t dmirror_devmem_fault_alloc_and_copy(struct migrate_vma *args,
>  		if (!dpage && !order)
>  			return VM_FAULT_OOM;
>  
> -		pr_debug("migrating from sys to dev pfn src: 0x%lx pfn dst: 0x%lx\n",
> -				page_to_pfn(spage), page_to_pfn(dpage));
> -
>  		if (dpage) {
> +			pr_debug("migrating from dev to sys pfn src: 0x%lx pfn dst: 0x%lx\n",
> +					page_to_pfn(spage), page_to_pfn(dpage));
>  			lock_page(dpage);
>  			*dst |= migrate_pfn(page_to_pfn(dpage));

Looks OK to me, thanks.

We could just remove the pr_debug.  I suspect it was a development-time
thing and nobody uses it any more.

Your patch prompted Sashiko to find three possible pre-existing issues
in this code:

	https://sashiko.dev/#/patchset/20260812092856.55296-1-liuqiangneo@163.com

