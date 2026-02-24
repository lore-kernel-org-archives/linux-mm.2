Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 72151F3C9AE
	for <linux-mm@archiver.kernel.org>; Tue, 24 Feb 2026 16:07:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D51366B0088; Tue, 24 Feb 2026 11:07:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CFEFA6B0089; Tue, 24 Feb 2026 11:07:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BE0CC6B008A; Tue, 24 Feb 2026 11:07:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A26236B0088
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 11:07:51 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id EA485140231
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 16:07:50 +0000 (UTC)
X-FDA: 84479831100.03.F2EFF0C
Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com [209.85.167.49])
	by imf21.hostedemail.com (Postfix) with ESMTP id E22741C0012
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 16:07:48 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=CWEJDt6x;
	spf=pass (imf21.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.49 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771949269;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6qfUGt/FM7R2rdWgRVoPTD475gsr7cLgK2X8GJMzNug=;
	b=I4HceYZWnekj/D/u+IkrI4yXD7p4C5lpWjaiy95d4kmlDulIpMkc5B13srBcGDLMTsSpNX
	EfS825cYRZSUIxXL7sIlmD36xxuuqWdvkrF3hl7yXmysFzW0W9+qdwERV2wzrIQOgYrxhi
	LCm0gBJ+H6QlYegH2XoepggQPswAans=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771949269; a=rsa-sha256;
	cv=none;
	b=IFP5lRZUXNd+GPrDski2Sp9bcsLxdrB38tY/I7BQLQ0xCeaZedo70pmxB2Fiv45itWzMDI
	nLmCgyLZei01Y09AhsVnxzg/jbMRHr5QK+GsaCG2Y36izo40Ivp2ab6cj8/plV5WILt1Mh
	P6fSApyuthmBO9YDMIqOsMoYAnC3EdQ=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=CWEJDt6x;
	spf=pass (imf21.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.49 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-lf1-f49.google.com with SMTP id 2adb3069b0e04-59e64657f0cso6121193e87.2
        for <linux-mm@kvack.org>; Tue, 24 Feb 2026 08:07:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771949267; x=1772554067; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=6qfUGt/FM7R2rdWgRVoPTD475gsr7cLgK2X8GJMzNug=;
        b=CWEJDt6x8paTkMg8ztwBsHVZkW/6MZMJQFUdVMYyTT6ehujn1bMJvm3NCUF1wubGWh
         CZzwIsYHbu64w3HXruYDlOQUpa2t+Ye4nRcSzJgF29aBH0yOIeXu4/HDqpTDmwYKG0d4
         iqE8llhsk5iiFuG0a3Ho3x+vJFHp2vmJCKi1qfK7mneAfWzorHgHPmYNP06eMXT7CO3l
         Wn5e/35303hO2FoGNM80QsTNf+5PTtcbXLKQa6XNOWT4ziUPUggxAudPCmBwgY3KAycV
         JZIewJlcOYHLFDDAhwoHWT2srKjoLhnWKughAn3qcCDrsL3NTffzlgzYDXU0A3B9kQIZ
         4Sgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771949267; x=1772554067;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6qfUGt/FM7R2rdWgRVoPTD475gsr7cLgK2X8GJMzNug=;
        b=WcnjfdMn2Twv3kE+LqZ6nzvLqR+bJvCelxvYK3wAa0XLZcPVcY6BWBYyhVHmQ//z1n
         ZBFA0aqrfYl6rrYu9ABpVZIKqNc5rblYYKoFNaq1ue2hUPjlk+/ayGQomIox2QXPOR/Q
         alSw1Jhpg0I7xlizP488Oxyc8xzt5+u+FOWUSVLKkALTWK76zYQFp8WBuPnm0ANxsakv
         /QYbxv7TpWOR6OpTHcGusEcp0Ss5XUneid7X/mR5oMn33EwrUwwjFR3mnHAiGyhBspQM
         uiP7fU2pedN6lsWMFcqsq3Zc1gNcUxTGp/YrPVnWftekNxeGzz+hM1wb7dG3u9vPWMgu
         z07w==
X-Forwarded-Encrypted: i=1; AJvYcCXE1Z4hwWs7awbepF4b9xOzH07Sd/188/ta0JxNJNCfkvL1DwXudE1coRgIYAbkmBxptvnGd/iauQ==@kvack.org
X-Gm-Message-State: AOJu0Yz8LjUa0kRin9A2GXBzlPJbQs5yqEOFgMjM3y3TRML/UyH/zufu
	qJjJ9ycou+H1kVGSgXU+16igmCL5FtOOIamJ+xT9s3ALdhZ9dLeCV5B6
X-Gm-Gg: ATEYQzyGuAWmgJgioSdhyojuhp7pET0nRhzRQX2/ZygncGgmg6ozpy66e/6wO6GMePD
	xQhjuC/iuv7zjhqP2w1dCCHR3wrCm9/EsAwPNnCVD9D/a/NIU4/u/4SFTu6MG1gnekReOC0FgoP
	MiWcwVqkEKDEFxbOazdednqyLBNnA4+w+j9gFFTFc63KayR4J0fAMVwvlqu4EQgrjnOrEnsXmk7
	L7APmQgLmPU3elsDqzMAm0OjbMHkrqd3gm+Xl0yUSpqKT/u3j6tMd9b0yfnKO6KQCyYsyD4mL5Y
	Z0CagQ92bT7/0g65lnFiX2mHewIaAN/QWXeU6iCOhgW+B30hwXRKsfVOKoz4cPzT6nRFdLWIFlU
	NdtzoD86Jf33WuIf0t0E+xzfSR0ymJS1LF2JYFMDvbh6hlVlwpBGXVuh9xL0QJD3E3BUPPz6zUL
	iLxCyFkAJ2+wQ4BigJu3GfVfYKkw4hxYvgRqXJEvHt6wHn1+t4JmUdAIiqbseslZ0=
X-Received: by 2002:a05:6512:3d1f:b0:5a0:f3f2:7ca6 with SMTP id 2adb3069b0e04-5a0f3f280b2mr2300626e87.38.1771949266678;
        Tue, 24 Feb 2026 08:07:46 -0800 (PST)
Received: from pc636 (host-90-233-215-147.mobileonline.telia.com. [90.233.215.147])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5a0eeb45a64sm2282697e87.67.2026.02.24.08.07.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Feb 2026 08:07:46 -0800 (PST)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@pc636>
Date: Tue, 24 Feb 2026 17:07:43 +0100
To: Michal Hocko <mhocko@suse.com>
Cc: Uladzislau Rezki <urezki@gmail.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	"Vishal Moola (Oracle)" <vishal.moola@gmail.com>,
	Christoph Hellwig <hch@infradead.org>,
	SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>, zkabelac@redhat.com,
	Matthew Sakai <msakai@redhat.com>, linux-mm@kvack.org,
	dm-devel@lists.linux.dev
Subject: Re: [PATCH] mm: allow __GFP_RETRY_MAYFAIL in vmalloc
Message-ID: <aZ3MzxtMp2OykAQq@pc636>
References: <ff48283b-be21-7f9a-d616-e303a4a1ebe6@redhat.com>
 <aZykWyxLy34o7PKr@fedora>
 <32bd9bed-a939-69c4-696d-f7f9a5fe31d8@redhat.com>
 <aZzPwsBp-Z4XM58U@tiehlicka>
 <aZ2N9a4XgxnurOhz@pc636>
 <aZ2YDD_l5JN78DJC@tiehlicka>
 <aZ3F2cghZpqBi1Mk@pc636>
 <aZ3HaVuIA4Ezu1uY@tiehlicka>
 <aZ3JB5Xm3SCmJW95@tiehlicka>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aZ3JB5Xm3SCmJW95@tiehlicka>
X-Rspamd-Server: rspam09
X-Stat-Signature: w5p49i8fwpiyqycrpsru7kapthyp96qa
X-Rspamd-Queue-Id: E22741C0012
X-Rspam-User: 
X-HE-Tag: 1771949268-952868
X-HE-Meta: U2FsdGVkX18JAhaaEodEPkNIwyy8CCD14thtTGDu7gSobmrakgUcbPpLUQYzADmofyag1VukYz/cW1qzPPKc3Y6GRCMCflXI5i00b83E4Yb/TFDfGh2Zd9LGYD1rMjgGTmw+7m/rjlmmqJUpra6jDgsP/DDYgyeHS3Q2ITBOBvwdyZrvjRk3cW8wUgQwxuGv+Khd7I8IAngodWjNeHiQPC8vDBe4TtnSUQ/pGCH60Y2mvaXImPUTMJveGSTAc3YPKC+n5nCEAdVzbiTCXm+eUy05atTHpNqOWi2z7QMN01BfkJX6iH7CltVCT7zcIkabEoirqf4BzSmsurF9sy80k7b6nmCkPLiokWwxhy2PxkFUAiyTy1vD8Jf8pmAw0mk06nSSAz/gkomnjgVENhv50lh+0rZuVk3ZEXxBYq+V1D7/Hep4H0giKhadXKbH2vTEV4IOP1EzuGs1gMyfHgVj7biRVZmwjedWcyf0PmKt+V35Z69IL7EpdNpno329hUsPcr76+na70IECvVzJOkmKQs/hEMPqeObuCJwW8Ppkt9iqErPqP74Mklpdu5vP2QwuDCFyaoN6IpVuvBzaJ4vsYWtBE1+HieTYi/V5dmpDfvR/Nn2/N+p5bcS44NvQa/O++d1WgGAolGl1unhEDzfN2sueqwLXnGaiA+Eub9QEZT3H6nwWQ38xbKVRnP3X2mws4rGYj6rQTiDX6iza0Z8xjI3/NgmYAd47u4aeZXNOjukWr4yDnIGs2cZUse0xpA2RVFX1HE3q2HuAHbHD8rokyDIP7vnJn6OqstYIrjDvZEr680vIlB2BXOcuw7aykCJ9rK1PB8rK8RujcfAZcSM8NkzVdoUIC2TmNrauPS8IwWgZLl1BPrzN6OYQvkpgJKKLqj9H5QbsAgpWxbMpUTxIQILDLX3yLjFRr/V245bkunuGKWa+UarWglLeQyrnR2R3I9sJqUqnm2XHA5OXYO0
 RyAdF8Yn
 2Ya4m7DmQBewsockmfC+jvYOW56AarTgy4HKIg6esV1/q8ThKx0mpb2QeD3EtnbUgxKxz16xCDNtnHBhxyMlSZbR7Et1W8dZDGOt2I8prGI5XZf6kHkpHBAYJOwmf+SlOX+vhO73PIf6BHiKLacuvy61taxlxRBuEAB9H5Q7ztCAw2azIa7genQCwHNxh5A4gxTrAhP5pxJNaJD2kYVpakHselVnsfl7TRBjhicNBjUbTDY/EHRI/HfnSVW8HC15+b0RUwvAos6LBlSJ2an7Gb0Vlm0UOtOEsMmKCLur95Cg/vTTDHURGXdlixc8/fV9q3ocFy0V8268aj/DVihpPiSp//zsOasKtKoQKP4RdxBCZzB/QlfoJFDpFRTOjrPpo1M4Ff3X7hONaW7az0fEyUlqavjIKk0+W2Ptp06+2YMY4fF6ierUTMY6ChpHvR538oqJQ5VyAGSMhPsvbLGPmHhJXOLEpXGQnzHnF5fzyq0jsTZXsVK/ku1FV6x841eN0MqDSNxLPRyge2bvVw4sau4MJPOZ0179Hs/Ow2IRuSueeR14=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Feb 24, 2026 at 04:51:35PM +0100, Michal Hocko wrote:
> On Tue 24-02-26 16:44:43, Michal Hocko wrote:
> > On Tue 24-02-26 16:38:01, Uladzislau Rezki wrote:
> [...]
> > > I do not have a strong opinion about workaround you noted. Maybe Mikulas
> > > can switch to NOWAIT flag instead.
> > 
> > using NOWAIT for the full vmalloc allocation would be just too easy to
> > fail under moderate memory pressure.
> > 
> > The real question is whether we want to provide some sort of backoff
> > early but not way too easily allocation semantic for vmalloc. If yes we
> > need to get creative in the vmalloc internals rather than expect callers
> > to be working around that on their side. History has proven that this
> > just leads to tech. dept and more work later on.
> 
> Just to make sure we are on the same page I mean something like this 
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index 61caa55a4402..791366fe44e2 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -3798,6 +3798,8 @@ static void defer_vm_area_cleanup(struct vm_struct *area)
>   * non-blocking (no __GFP_DIRECT_RECLAIM) - memalloc_noreclaim_save()
>   * GFP_NOFS - memalloc_nofs_save()
>   * GFP_NOIO - memalloc_noio_save()
> + * __GFP_RETRY_MAYFAIL, __GFP_NORETRY - memalloc_noreclaim_save() to prevent
> + * OOMs
>   *
>   * Returns a flag cookie to pair with restore.
>   */
> @@ -3806,7 +3808,7 @@ memalloc_apply_gfp_scope(gfp_t gfp_mask)
>  {
>  	unsigned int flags = 0;
>  
> -	if (!gfpflags_allow_blocking(gfp_mask))
> +	if (!gfpflags_allow_blocking(gfp_mask) || (gfp_mask & (__GFP_RETRY_MAYFAIL|__GFP_NORETRY)))
>  		flags = memalloc_noreclaim_save();
>  	else if ((gfp_mask & (__GFP_FS | __GFP_IO)) == __GFP_IO)
>  		flags = memalloc_nofs_save();
> @@ -3940,7 +3942,8 @@ static void *__vmalloc_area_node(struct vm_struct *area, gfp_t gfp_mask,
>   * GFP_KERNEL_ACCOUNT. Xfs uses __GFP_NOLOCKDEP.
>   */
>  #define GFP_VMALLOC_SUPPORTED (GFP_KERNEL | GFP_ATOMIC | GFP_NOWAIT |\
> -				__GFP_NOFAIL |  __GFP_ZERO | __GFP_NORETRY |\
> +				__GFP_NOFAIL |  __GFP_ZERO | |\
> +				__GFP_NORETRY | __GFP_RETRY_MAYFAIL |\
>  				GFP_NOFS | GFP_NOIO | GFP_KERNEL_ACCOUNT |\
>  				GFP_USER | __GFP_NOLOCKDEP)
>  
> @@ -3971,12 +3974,15 @@ static gfp_t vmalloc_fix_flags(gfp_t flags)
>   * virtual range with protection @prot.
>   *
>   * Supported GFP classes: %GFP_KERNEL, %GFP_ATOMIC, %GFP_NOWAIT,
> - * %GFP_NOFS and %GFP_NOIO. Zone modifiers are not supported.
> + * %__GFP_RETRY_MAYFAIL, %__GFP_NORETRY, %GFP_NOFS and %GFP_NOIO.
> + * Zone modifiers are not supported.
>   * Please note %GFP_ATOMIC and %GFP_NOWAIT are supported only
>   * by __vmalloc().
>   *
> - * Retry modifiers: only %__GFP_NOFAIL is supported; %__GFP_NORETRY
> - * and %__GFP_RETRY_MAYFAIL are not supported.
> + * Retry modifiers: only %__GFP_NOFAIL is fully supported; 
> + * %__GFP_NORETRY and %__GFP_RETRY_MAYFAIL are supported with limitation,
> + * i.e. page tables are allocated with NOWAIT semantic so they might fail
> + * under moderate memory pressure. 
>   *
>   * %__GFP_NOWARN can be used to suppress failure messages.
>   *
> 
Yep, i got your intention correctly. It would eliminate the problem
with page tables allocations :)

--
Uladzislau Rezki

