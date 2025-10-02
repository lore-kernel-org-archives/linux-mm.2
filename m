Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 27FF6CAC5B8
	for <linux-mm@archiver.kernel.org>; Thu,  2 Oct 2025 13:59:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 80E938E0011; Thu,  2 Oct 2025 09:59:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7BED58E0002; Thu,  2 Oct 2025 09:59:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6FB418E0011; Thu,  2 Oct 2025 09:59:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 5EA2E8E0002
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 09:59:18 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id F0D3813ADD2
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 13:59:17 +0000 (UTC)
X-FDA: 83953331154.07.4B2DA2B
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	by imf07.hostedemail.com (Postfix) with ESMTP id 0503440011
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 13:59:15 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=X+lmgve8;
	spf=pass (imf07.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.210.177 as permitted sender) smtp.mailfrom=jgg@ziepe.ca;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759413556;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AejVj1pzVa5tMHUAvlwjfMQqAVzkVnwGk/N4H8InPvw=;
	b=e/sD11/cAJkW9tr1YlF2sZNseLhC+qvd4j3BHvEfOp/BmKn8/o+fzx3g8MqyHgv84FqSJ+
	/Qd0eRFD8QWSe0g/ESM532pBo0yqAvIMTcJ612vaExKNqO5y+9meRdIEmDZ1fI7kBaCQib
	ZcU0MCHiiJuHbD28zglxP6RVz6To0W4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759413556; a=rsa-sha256;
	cv=none;
	b=56APFYb3mOfENh6dKB0kSkny5HlqiBIGe6+XpaUc528PresV2rKE4sW1C0khES/Su+Z8Yi
	8r61/+vYtANSVwAoq77oaLSf2zb52yADTtTTIsEA/DqK3LHBHjarf9yFswdNwioeCvZD8z
	K+uAZLP9qupwgSBc8fxB88Lav380w4Y=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=X+lmgve8;
	spf=pass (imf07.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.210.177 as permitted sender) smtp.mailfrom=jgg@ziepe.ca;
	dmarc=none
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-782bfd0a977so1010014b3a.3
        for <linux-mm@kvack.org>; Thu, 02 Oct 2025 06:59:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1759413555; x=1760018355; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=AejVj1pzVa5tMHUAvlwjfMQqAVzkVnwGk/N4H8InPvw=;
        b=X+lmgve8fuh0p26TGghixebalYvPjibBuMbIx/y/XESmHN/mNqvi/NpzRj2wioi3qx
         sy1HjVWFVsz7mJ2Yuz0gLVxWNu6NaI/jc8fq26WB7L+tD/1C5ZSsobhzFIPB1Ua+kPWH
         z5bP1Pn2X2m+Bc3PlX5PgT+E9wOS1NuY+W7h+F9wkbOqToWSZ8nx7/EDeG8MBPZoau6v
         VUhY+cMvlCzYDwoB3NLtNH319AfF7/oaYTMg/sDeWtWRY6wrEMCKmY9nnWNu49tIJwHa
         7/kPnpw+wYT9kG5lSGc+1s6E7FyL16dlhVdaV7pQqKkMZ4dPOO1DhjDLUs5i00giuUGa
         5fQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759413555; x=1760018355;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AejVj1pzVa5tMHUAvlwjfMQqAVzkVnwGk/N4H8InPvw=;
        b=B5wES5pg24bDqFhy6T9s8v7uQsGM96UUdS6XTwTvVz+YUV/ZPPvnSofCJqikOoP7gK
         I6CORRNV7ubmqWD+hlPhgqe4QA8Ep36YwdQAat7orVehC+r/uNgcUAentdgBj5qgqXim
         RGFZKVHuWACo4+fUhafXQYdiwBcN1zwNbQGjyuP5xuMLfu3f63d1YAPsUjCxqergcpkh
         Ne8QKnR+LatHmSQwrM/3XzcnwxMCn+2WWqRgdPL9vfje0UUpN1rpty7T3R82IUr1KKuR
         ggWutnTdaQhRv4xuJQHIlOjKhssMgafkNcAmYzhMrsY7xOCtX2I7mmqqCqpRzT4NqNp5
         fnRw==
X-Forwarded-Encrypted: i=1; AJvYcCUm3oyvAXQ4IkYNw4BbbpUvwwM1PnD6uVWwYBDIjBKQZ2eWmRaHFkdkk217+d0bCSBZY2Q/utnUfg==@kvack.org
X-Gm-Message-State: AOJu0Yx/2FSp+Il1S9NHT86OCXKjr45TS1o52YczKc3fDp6ZaLDMkyyc
	1X+uDXMeE/Y/fT+riyTMaqN/v3HJ6qV50//OAAwR8uetuWvRNmHrDybEp5PVFasq1gQ=
X-Gm-Gg: ASbGncshyOK8TW/dsHE18GY22yfsXe1S4ID2zEUKTgn5O3GMmwmHBOY+2zZ5F8Mg+EN
	ieF0+GWsLVPLLh3t6WYbMAzrNbXrv1rXo9Jgn785plsmtkmCc5xifbmsldoDsnjLDIazADB0q2T
	3iw5uW9h0AiITL7zwdzHkT2fYfzbkm70KsNbX2vZYsZp9QQNl7wMGgEJmY/s3C8SGY/z9mzEoZ9
	/2lkdKeleSYIQ3pryJmoFrcwWRqAdHmIKdm5DEmT8M4z/sbiz7QWVUesqIm50ju8qfACLav4ygr
	3Gu1LDYD0aRMLtIkHddJ/vpfEyzmHhRkvG9WuIzAy34MiTxg8lmak23qH15wsEGCoN3T8m5VIAl
	BhMpL0+pRXF/Rh224JyvE
X-Google-Smtp-Source: AGHT+IFjGtBLlrkcnGT3IwhvYU0siZeeKF1GDGUMbBleUNQJiex5zPfFC6dd5HdcsemvvP6EVFcU7w==
X-Received: by 2002:a05:6a00:17a6:b0:781:17ee:602 with SMTP id d2e1a72fcca58-78af422946amr8738022b3a.28.1759413554667;
        Thu, 02 Oct 2025 06:59:14 -0700 (PDT)
Received: from ziepe.ca ([130.41.10.202])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-78b0208eb5asm2300221b3a.82.2025.10.02.06.59.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Oct 2025 06:59:14 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1v4Jps-0000000DiKt-0OJJ;
	Thu, 02 Oct 2025 10:59:08 -0300
Date: Thu, 2 Oct 2025 10:59:08 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Shigeru Yoshida <syoshida@redhat.com>
Cc: glider@google.com, elver@google.com, dvyukov@google.com,
	akpm@linux-foundation.org, leon@kernel.org,
	m.szyprowski@samsung.com, kasan-dev@googlegroups.com,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kmsan: fix kmsan_handle_dma() to avoid false positives
Message-ID: <20251002135908.GE3195829@ziepe.ca>
References: <20251002051024.3096061-1-syoshida@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251002051024.3096061-1-syoshida@redhat.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 0503440011
X-Stat-Signature: 9d44d181iqky1p88xfpw5djqfdrn9d85
X-Rspam-User: 
X-HE-Tag: 1759413555-54471
X-HE-Meta: U2FsdGVkX19IBpACwnBBdgS7CF/hrdqCxdhqZKxeoIGK9hp5wG1i51g4GbIP6KczMV+P1AhXCEFIXmjmfP7H7I55m0ZTvA9V+F6oIfrP392UQJniKZmC17b+RcQIPqaXfP9FP/n8P2ofWUVQjHKAanWWdROD5B810PNDylKGP4nuvZKY35J4eIJ6vNVh6X/EDwdYGWDESWC341jE2CbKiwc1UI11eIkReiBZNGtSqVMInsqtCEHgCwipYNZGepf/WAymnoESuJlgL2oPt/xWa4JmEWH708utfkf7JJABRomW6AI84+qrPg7PA6gx1gyOHzYh73MgOLWnGHgDH6Gz4D1inpyLZ67xR4peNZ1O3VLA+AW/W13i33D2cBe4D3f1tKDI9hV5apRRA+SRjvlH//9uKvJTg5KQuz6giZa8W8NIsBpVg3pJLtFowxmMJEVDAT7YE6f1x5Q+/fmIgE9TiIoPkZpZ4d7mYGWcTFu+Sr0wD0JmcyHLjyyhWODdUZngZKa/Iw1c2wUeoQXzKXSe8ioTcd1ebME/QnFpuMMG4OxY9QQyDNAo64yrfNCc9/ZHuITneG40VzCpv6KVrBO8Ad0MqmljANXLPYHixe3raPOfIIPLZ4Db7BC/4LLfCDECdCwW5WmUbV+n6Wt9nYYwKtwC1aO9Q+UM5xmA2tmoBzNaphchlmgzcX06j6MVgbnf7swUfhYyz0qmCQV0hwfCMc1ZLCxy+kfItGcKF99GGUh0RpqR2lUYaKPWwLncRyJdGMX1M1pcE0IBAn+sqSh8OHxkqbAerLebytXnIdbz3rOFkHYBykxy95JFchiBFJfJ6+eD4kD6WJqTcl9N1GT5eUQiosR6pwvg1C3fSfxEA3HZWfAPc5ACzpEJmt1tI543WM7M3EbBaFcUa6UQjB/mVLfNJTbWTYxLoDlSUVp1YRl5wQeeYsg/YhHdYsyW5ZNCG287659x3SMhcVx/cH2
 I52jS02p
 zEbhZopMRGsftnm5tGysfvwYCx1NOoau4ZQiElioBj7H5nvQbilaykP1a+rPXnO3es8dWGU7GJMi9+5FnqjarStcITfy64e8/nIXs+iGX8GrcVpE9pV4i0leaGypx8R7atfkpoO4dNaQHSyrb088Rg0CpDar3rGMM0ndjQWkN/ctP/ciiDrXM8yUZgLM10JIxeocGjT2L2gckjdFXkxjBmRn8wES4rsY7oSseTN7o2it/oof2rZWwiPjMC+lNAS9OEOvyY6KX5QkNW8lnbG/r2Qudij5IGQhbAJVlNLfivNbUx0ujIncef9t35qB4DFVf3G3GA60ribHpEX54wCekQ+XAE1jlJk0wGG/6
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 02, 2025 at 02:10:24PM +0900, Shigeru Yoshida wrote:
> KMSAN reports an uninitialized value issue in dma_map_phys()[1].  This
> is a false positive caused by the way the virtual address is handled
> in kmsan_handle_dma().  Fix it by translating the physical address to
> a virtual address using phys_to_virt().

This is the same sort of thinko as was found on the alpha patch, it is
tricky!

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

> @@ -339,13 +339,12 @@ static void kmsan_handle_dma_page(const void *addr, size_t size,
>  void kmsan_handle_dma(phys_addr_t phys, size_t size,
>  		      enum dma_data_direction dir)
>  {
> -	struct page *page = phys_to_page(phys);

This throws away the page_offset encoded in phys

>  	u64 page_offset, to_go;
>  	void *addr;
>  
>  	if (PhysHighMem(phys))
>  		return;
> -	addr = page_to_virt(page);

And this gives an addr that is now 0 page_offset, which is not right.

> +	addr = phys_to_virt(phys);

Make more sense anyhow when combined with PhysHighMem() and gives the
right page_offset.

Jason

