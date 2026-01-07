Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 268D4CF6BE1
	for <linux-mm@archiver.kernel.org>; Wed,  7 Jan 2026 00:59:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 53B616B0092; Tue,  6 Jan 2026 19:59:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C87D6B0093; Tue,  6 Jan 2026 19:59:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F56D6B0095; Tue,  6 Jan 2026 19:59:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2C9E66B0092
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 19:59:40 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id BBD4DC647A
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 00:59:39 +0000 (UTC)
X-FDA: 84303360078.15.BC478D5
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	by imf13.hostedemail.com (Postfix) with ESMTP id CE26020005
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 00:59:37 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b="n5dgifJ/";
	spf=pass (imf13.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.210.171 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767747577;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gJ5as4LhzcRllyAELyn/zLo0VkOA5iMY3p1arVVHAA8=;
	b=1au9uM0A0PTlKRnIHibgWUFCQm8rFRJatGaBLJ6TXGmD9VSaRNmtOvGueSmZBIqoY+AW4g
	QcfeBytWxHZOmw214aWpfdR+X0pkVDKSPUzxn6apfjjz4g1HmzO0f8zWa1LXvR6dbvOkQ/
	LrVmBwUzddNfk7chwV8PGHSKkRS7HxI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767747577; a=rsa-sha256;
	cv=none;
	b=zhNiuhO5ahMY1UqN0/cUQWtPD8xAV7pff5V0ZPui2F5ZIls9ZFf2QehlgnJws12KUUNz9B
	ka7F/h3LO8fpw4ML50sIwwmXZLxcvGgMIIE8zTeXQ4DSi2fyZ5sMTSY7/jgmVVAnl9f5vL
	NIvCJa3cUhsLXk/CzFPho3t40C3hmao=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b="n5dgifJ/";
	spf=pass (imf13.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.210.171 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-7f651586be1so184039b3a.1
        for <linux-mm@kvack.org>; Tue, 06 Jan 2026 16:59:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1767747576; x=1768352376; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=gJ5as4LhzcRllyAELyn/zLo0VkOA5iMY3p1arVVHAA8=;
        b=n5dgifJ/+elzXI6YICu4ZtTmAMLKx8ZU44Gup0ETrLmj/RT2fiVZKXH0GA09gTA2ki
         eKhZMdmoFypQ8YOHimJJhAMqL5+LhTY1WQqEPEABPcOa72pUnD8FvXE/+xl+dE8c+DuU
         SlFljvEvF7XLkgdTLHsM1nVes0TV3n7fVcwW4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767747576; x=1768352376;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gJ5as4LhzcRllyAELyn/zLo0VkOA5iMY3p1arVVHAA8=;
        b=OcqJlw1m2+d2nerQRAr/Uu6nptWY15lGf+HjdNI+4y6AxSG7QcqHMMevJN1vp7Wn2C
         fYUfTOk8ExBFqH2N/+dsX/8l5kBAQb+iP4vgH/MoDQV+iFX76PqDj1tRU/WVBs18584c
         JzfbGpkavnQWv64SWwlui4KJZ8GAWKa9GxTzl9M6JL1W4sPRsuDhBfV0uitfJibqYGUL
         gqGxnSM4qpfACXjvfdwSRu+jMntZaX1FyJvqwvMa42FkoWOtfe12ao1iejFuJ3AnKMeY
         45KV11NG0o1MpbqZH4FuhIAfhhbJrfXd+9Joy21fmarf8RZOUqxSNc1CnBrv9UZjwr0y
         t9TQ==
X-Forwarded-Encrypted: i=1; AJvYcCVF205DV/Zab7IYbiDSMHmhUZxi7Ux8be/GBCJNv4JgUOOoCC/sDALZngNi2Sf11YrbmwKBlU1zdg==@kvack.org
X-Gm-Message-State: AOJu0YzuTV+vlpfVb355jt9HU+KCP+w4wr8djoIdfNL3eWH0+sXK5JYG
	NimGF27q2KTpg4XO210jdY+RFYhb89o1eQgGJAOWZW6TExU6Ai6UWUtPG4L9zhYGsw==
X-Gm-Gg: AY/fxX4SDoJr3c2UH24djf8hVxgG/IUlK67X/i7D5cSCOFJ70WfVJyg/bLkzAbU3a8S
	NHa5Pyz7WEH8kQhKPJu4412B0kOL2QVrBRPRxMXIpgWMdGGdfQ/g+GzCxBI8VTGsCgtOx5oGlmC
	bx7J0mpAKvgWl8ldkDdCS/jp+4xRyIAcz6SXMqM1hdjvOnrrTr0ObePNZx4cqJpE4l9Nmt8Idgp
	aLnZxYkdY7hliCAnu3N6r3v2k1UZqwFdEOmSHAKjDf5d1zfDGMqAC6OdZPunAq9UIDeJbuD+06p
	UGWyPXeibAjpHLx5hHpZZeficQJmXcIui2ZwUm39H75DHHlfxY18pC0RxNRKbMs4Q29PTpTc3n8
	SRq+lnrT5E6OdK4C/gCl8a8eNX2O8s8Xr2c8r+6q9PYSQvIN+3u9cnEUCb2y6Bm2xf/0SRnoWhe
	sBVJAFKIQP0zSBbsEdLFG9eGma9O1+EnFfHLrjspLvHeCeazhRgtI=
X-Google-Smtp-Source: AGHT+IHiiFoo/hMdbf/XNJiS7/wHmzPvr2XbFk80T7AIPfNTradLcbzX8li7iFhBVjCO9rReLVFSaQ==
X-Received: by 2002:a05:6300:218e:b0:2b9:6b0b:66be with SMTP id adf61e73a8af0-3898e9ea7aemr960993637.14.1767747576570;
        Tue, 06 Jan 2026 16:59:36 -0800 (PST)
Received: from google.com ([2a00:79e0:2031:6:9f6a:2617:8891:93ff])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-34f6af48d8esm10784a91.8.2026.01.06.16.59.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Jan 2026 16:59:35 -0800 (PST)
Date: Wed, 7 Jan 2026 09:59:30 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Nhat Pham <nphamcs@gmail.com>, Minchan Kim <minchan@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Brian Geffon <bgeffon@google.com>, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org
Subject: Re: [PATCH] zsmalloc: use actual object size to detect spans
Message-ID: <og2yztajena3ywyvus6xgc5vlrrecjaynyezygpsrt64kjkqlv@agceajv57eet>
References: <20260106042507.2579150-1-senozhatsky@chromium.org>
 <qh2p3k5c2ulb5g2zmckhrm4o2eoruatb5lnumkrwrvmsxwcn3s@nh5vx4kjn5in>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <qh2p3k5c2ulb5g2zmckhrm4o2eoruatb5lnumkrwrvmsxwcn3s@nh5vx4kjn5in>
X-Stat-Signature: xptxd4rjruc77szbmqzz6rkwmdczc1rx
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: CE26020005
X-Rspam-User: 
X-HE-Tag: 1767747577-134153
X-HE-Meta: U2FsdGVkX1/TxQd8CCcEOtYni6/SK2ZIFKwRWlBqyzc4+D2rs17pOeU1hj34dUhOw6+mU19ZzI3WuHWhASk5fz4PTu9UcN7E1yYWuThEz0VL0v8kGeXxJOVwf6j1XVnqSo8TDSIyl+VgD4Dhbp4UXNcTLAFYMCgPsLXOl8blUSMTbd3WngZhuIwLelAxvY14uaq0PDzDgt+DbwtIl3g5msH7NHwxbOqOXH447+9UUVZCIZQWLcL+eMTe3wbL2kMECoz6rRUV+O5+8ngVnejSpv0nd189yzPW/2TOH6d+hrH8RMGcQ4auiDW7PNGXb5qVcKQ6ex0aDKCugN4gjnpbjsntD2zpJeRaLBihGDdrClh5ZAcCxHwbo47dod/byYAYeLTThzwXkjZoBq0hOiVL9MdUsHMbBUh/+CJxi92IHfshgz2C4LHAIjBMQqWLVVbw7//rGqFtfmezqTVy/UY5IJxvSb7sSz4GNpDxJT6UKQ/pVU/xkBgOpNixSpzArF8cf3fKbS0ysbNh6He8lGjkOeZc+arVaEOnh2ErbyE2k6zZIwBsFAfb+lPFHuJJkUD6iZSGpBP/eN2Rd3kbUsob324m3FSPcYu+FMxsppUMMo65B9C+ySHbMEU0ROP1STQlX3PIA/UT+TeB2bKwToIy8E+khVAJr20y5uRX4cYZrG0+slDzS9sqQ5qAZMOUnSKZWTut5maiz0f4No5UXUtgWGaqT22eBPwyZSerHyEViCqUOwMqUMnwi0LPKRwbiumEY1K5zEiSnJLXAnzBlvYWCfoNMQyIcGvnNAohOMupydjnNi1Q20jjC2u0nNnqyF3LzWNoQr6RFdsnS+AANyvu2bFGIOps+5lwVMooMeDCaMAGFoq3oQaPLUVL4em+yH6ha3OzVjJVavUr9PX10yZaq2wTs+YBIzAexUzd0jqRbi90Y8V0sHDQ8V5jJvZpXkhCRCJBtSaVZ2Gz3Ro1PPd
 i2TWaalM
 mAxFudYK49cWxNs+kIzW4jNI44XaxcM01qv5cwTuG2/TbKwJ2kORqzeV3y/OOUPb4YrkAZfM/vMSpr/4uzzJZHIyeK+1xkXskcdnVbH3Wajh5mGxx0S/G0hr1rM9OPwKazOd+PXEi+E2ulK6gAo0EvEsMbjD7+HxBIEGNKUzfueqPQHZuEqzG/Ws7BBNaHz/luoPJwePMyHEwbDoFEEA6mS7RNhOY/oJFzoWtiZFiyThYNwpVE7UKERUcbme8k6jug0UgLX5ztAW5kH3OHIwupf6rd0Y3hpzNM4J3jSl72oZOo3jaZkuIfqHTshnXNcX0BrYzyOwPlGe4HYDNgyLgf4OQ8ggBUhLdOhVJ9vVRAN5NM/A=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On (26/01/07 00:23), Yosry Ahmed wrote:
> Instead of modifying mem_len, can we modify 'off' like zs_obj_write()
> and zs_obj_read_end()? I think this can actually be done as a prequel to
> this patch. Arguably, it makes more sense as we avoid unnecessarily
> copying the handle (completely untested):
> 
> diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
> index 5bf832f9c05c..48c288da43b8 100644
> --- a/mm/zsmalloc.c
> +++ b/mm/zsmalloc.c
> @@ -1087,6 +1087,9 @@ void *zs_obj_read_begin(struct zs_pool *pool, unsigned long handle,
>         class = zspage_class(pool, zspage);
>         off = offset_in_page(class->size * obj_idx);
> 
> +       if (!ZsHugePage(zspage))
> +               off += ZS_HANDLE_SIZE;
> +
>         if (off + class->size <= PAGE_SIZE) {
>                 /* this object is contained entirely within a page */
>                 addr = kmap_local_zpdesc(zpdesc);
> @@ -1107,9 +1110,6 @@ void *zs_obj_read_begin(struct zs_pool *pool, unsigned long handle,
>                                  0, sizes[1]);
>         }
> 
> -       if (!ZsHugePage(zspage))
> -               addr += ZS_HANDLE_SIZE;
> -
>         return addr;
>  }
>  EXPORT_SYMBOL_GPL(zs_obj_read_begin);
> @@ -1129,9 +1129,10 @@ void zs_obj_read_end(struct zs_pool *pool, unsigned long handle,
>         class = zspage_class(pool, zspage);
>         off = offset_in_page(class->size * obj_idx);
> 
> +       if (!ZsHugePage(zspage))
> +               off += ZS_HANDLE_SIZE;
> +
>         if (off + class->size <= PAGE_SIZE) {
> -               if (!ZsHugePage(zspage))
> -                       off += ZS_HANDLE_SIZE;
>                 handle_mem -= off;
>                 kunmap_local(handle_mem);
>         }
> 
> ---
> Does this work?

Sounds interesting.  Let me try it out.

> > +
> > +	if (off + mem_len <= PAGE_SIZE) {
> >  		/* this object is contained entirely within a page */
> >  		addr = kmap_local_zpdesc(zpdesc);
> >  		addr += off;
> 
> In the else case below (spanning object), should we also use mem_len
> instead of class->size to determine the copy size?

Good catch.

> > @@ -1115,7 +1119,7 @@ void *zs_obj_read_begin(struct zs_pool *pool, unsigned long handle,
> >  EXPORT_SYMBOL_GPL(zs_obj_read_begin);
> >  
> >  void zs_obj_read_end(struct zs_pool *pool, unsigned long handle,
> > -		     void *handle_mem)
> > +		     size_t mem_len, void *handle_mem)
> >  {
> >  	struct zspage *zspage;
> >  	struct zpdesc *zpdesc;
> > @@ -1129,7 +1133,11 @@ void zs_obj_read_end(struct zs_pool *pool, unsigned long handle,
> >  	class = zspage_class(pool, zspage);
> >  	off = offset_in_page(class->size * obj_idx);
> >  
> > -	if (off + class->size <= PAGE_SIZE) {
> > +	/* Normal classes have inlined handle */
> > +	if (!ZsHugePage(zspage))
> > +		mem_len += ZS_HANDLE_SIZE;
> > +
> > +	if (off + mem_len <= PAGE_SIZE) {
> >  		if (!ZsHugePage(zspage))
> >  			off += ZS_HANDLE_SIZE;
> 
> With the proposed prequel patch, I think we won't need to handle
> ZS_HANDLE_SIZE twice here. WDYT? Did I miss sth?

Let me look more closely.

