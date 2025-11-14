Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1F700CDB47B
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 03:08:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3C7158E000C; Thu, 13 Nov 2025 22:08:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3785F8E0002; Thu, 13 Nov 2025 22:08:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 28F208E000C; Thu, 13 Nov 2025 22:08:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 17DE78E0002
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 22:08:17 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id AAB59140206
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 03:08:16 +0000 (UTC)
X-FDA: 84107728992.26.59F163D
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	by imf17.hostedemail.com (Postfix) with ESMTP id BB5784000E
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 03:08:14 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=FoKqgP5A;
	spf=pass (imf17.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.179 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763089694;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YIB9sVFAZ4r1CL2qSAT2AmYZKBmONBzhrUY9z+AGXrs=;
	b=PLl7KgRKWWPCVArRPZDk/xY32jgF0cCKOOncu6FkCkgzwU4zXvgk1JMJcxVurlBOvFDjoM
	FTO815Rgvopm832CwbTxROVyOCaD006Y5e6+b5ECJoeCoQuFNwFzt/3ToLslzk4wRwcK9a
	xEsEYEagHbjPSmm1dgyifIRZPfU/WAY=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=FoKqgP5A;
	spf=pass (imf17.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.179 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763089694; a=rsa-sha256;
	cv=none;
	b=cX7N6BkSNW/2K+3jikM7f+tFlADNlaMvd1k+6sJsqeodxQdyYOrJmAUHA5WKvjS0rxE9zs
	rmFszjm1bXSV4Tk7S8aBl0QZc2QTUz1IHrfOL2MLPFEw0u37IhEF2kYeB9d2EW1yaJEsnF
	+ejXCD4xalWKiAGps6DVPv9AM4Nd9aw=
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-298039e00c2so18691535ad.3
        for <linux-mm@kvack.org>; Thu, 13 Nov 2025 19:08:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1763089693; x=1763694493; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=YIB9sVFAZ4r1CL2qSAT2AmYZKBmONBzhrUY9z+AGXrs=;
        b=FoKqgP5AuL6ynu4ghAucOLgQ6RtiCsBBqZv4nPGFOsdhiFoenJ6ZCEAORqVjJZgEQU
         dyJcdhaGpmS8kTJy5VrJkdB1k6PJHgIhYjWIxIIbjrs1dYUjuXsz8+y7tpBefX7/gPIr
         UTBXSb+7Gvfg0nn2Gv8Ea9E46Mcukgonyh1cY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763089693; x=1763694493;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YIB9sVFAZ4r1CL2qSAT2AmYZKBmONBzhrUY9z+AGXrs=;
        b=tyzr3G7cJKBix16juvhAF5ESIiB4edBNQSvb859la9SkuhDRhjfTXe28TvAnGfpC4D
         nSY0W6M2Il+bYU/VyYdqaLvMLp9DO9gdq5c8GJO4CQJ4gfftBl3APHNWh3Zy8atnNjb2
         lbBt3dQVXV6ldDZTRp/ILajsSBskrz5mc2eIVWVMVD5GrsYK4mOPJN9aCalQqSgd+t8G
         0T7/pTBedgYTgI0zUtKxQRTBbDT2DkFqm3Oh1TuIJFN6EMMMMsYCXCyFvC7cK+QAoXHL
         gBVQT5uIV27JF9qV8JG3HIMGaXawO6vYcStMjZXGd/r+armPJXg7Aw4wG086+qIOsBcL
         RVJw==
X-Forwarded-Encrypted: i=1; AJvYcCUYgKOEUBJs4o6ymWMLn8em7WgOCM2yPbwHFQnI0WfWYxCsxALIo0db9ooaf1TyPZPeckIjnRwWmg==@kvack.org
X-Gm-Message-State: AOJu0YwCw/AQUM2NgPNXaUALtrTcGbQlwHRWR2KMbkSwJ3t9KyV3T8AO
	A6TzvFeYBlI2S2+2hrVHLaO/nGTsp+ukr/o0gA8aXchFiqfNuSW0G13qaXUMi3D9aQ==
X-Gm-Gg: ASbGncuF15/opeE7+gjXEJjJ0VzXMkBBFr4uG3b+X++mycwXhgLW3eKa2T6JjUBFyth
	otfB+MwvWfVDjL9adRRmnqlwv+Afhv4VlWCn6nn1cAW9YvV53x2wLPvfaZvFe9knGf8XhiLtWeQ
	+2gKB/QRJHozig6M+MLOR+v1JKDHDgmX0waG5SwXZjiWD3H+R4pAP7+Cakq9kzoRggrIJzT64ns
	i7xS3VYSmTvQValSJtt3+xyiQP7GLVGKrFWQTScW4WpR5LQ2Z0DR5xXH9FtlYh7HRfnDqjGCMDy
	k7Eh5P6xhJEnhtqQrH4JYmMyEhU4iS4842vTwUXoLRTXN1NV+p9EPMxWzuQDhACUbzh1sd64T60
	g6vfn0PH05PN7NaCS+4db6Dv9LcvPN9+vYrk7uTTz/IatnzLBIZJ4+hb3o7NN73WtkF/0HH9bPL
	JkPzq3MYcIlo++DxRONp5C7Ou3
X-Google-Smtp-Source: AGHT+IHh41/ZcRo9qIekYBD3OLGDCWUcF227dtgzH8Svbd49yvbPTWE1o1kN6DltieX08rnQbG5c8Q==
X-Received: by 2002:a17:902:e548:b0:294:fb21:ae07 with SMTP id d9443c01a7336-2986a6d692dmr15139705ad.21.1763089693528;
        Thu, 13 Nov 2025 19:08:13 -0800 (PST)
Received: from google.com ([2401:fa00:8f:203:8e2:bf91:1dd0:a9c0])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2985c2bf0d8sm39740115ad.85.2025.11.13.19.08.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Nov 2025 19:08:13 -0800 (PST)
Date: Fri, 14 Nov 2025 12:08:08 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Minchan Kim <minchan@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Yuwen Chen <ywen.chen@foxmail.com>, Richard Chang <richardycc@google.com>, 
	Brian Geffon <bgeffon@google.com>, Fengyu Lian <licayy@outlook.com>, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, linux-block@vger.kernel.org, 
	Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: Re: [PATCHv2 1/4] zram: introduce writeback bio batching support
Message-ID: <uzmauds6u53bauvwcycu4uphsrb4fg7rvm2b5x6uqyukqq4wwp@vhugu2qv3uaa>
References: <20251113085402.1811522-1-senozhatsky@chromium.org>
 <20251113085402.1811522-2-senozhatsky@chromium.org>
 <aRZttTsRG1cZoovl@google.com>
 <rjowf2hdk7pkmqpslj6jaqm6y4mhvr726dxpjyz7jtcjixv3hi@jyah654foky4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <rjowf2hdk7pkmqpslj6jaqm6y4mhvr726dxpjyz7jtcjixv3hi@jyah654foky4>
X-Rspamd-Queue-Id: BB5784000E
X-Stat-Signature: zoje8rdkn7qw6bs4odrafxtopyxtqohe
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1763089694-798906
X-HE-Meta: U2FsdGVkX1+SjU0/RGcCYd/BXb7JaLGjugQTkeMmzz5oR8HE7D7m8ECK/GElN78kPPwMkUS2z9BasbxR79+IeM9AaJRjap+dRzFcG1cfl5wdQvNkFlsebZqVM2C5dgDOlvfWWcUVj7xMJjE9cbOnn9tAblk5KpOZ5gXEo9FPoPmz/bT3GP1GMejIbVHV+gy+i3BAxgfNzqztWXeIO/aV1VzHBojO4F94LASQ6auoM9r39ycx/99N7ERzTEOhEr3tvrGy6Ib93Bp+pvvniUcCgmrS2iVPfAu+QrLjWI1xBAajUKL0pdiQxnn+e2Z81S9fOc/uglnAv++C1O4CWn6V04v1kyWKgArViPGcRKO7BE9a02P1pHhb36FRvNiJ/iCs6i2X1xxyvGT3EgJC5Kb8iI4Tbp6/0WkmzV52HfjPcO89UNoLQ4j+1YfcQbylmjbEx+riyHBp2B9oO2Ns6EJV+dV+a8rMbE0EVHM3U4d1AgrjHV/XqamWCKeHffQxP89lGHRyOvdYycqKC6k3PKrbWJ6eR+h+tTxLqDRvILe5VPQkcsIyeedwXhjaMLjzevEPrDd6iAwVOjWa29EWDDn+yXQvxcno0OhcvgV1eKRAelvXHlRG4E0SSZRZbtyWcAUyL37Ez8OC7H8rQ5/ozRMIZ5kKIigXhnSAIpAfeER9otM1Jb+GdayvobCBXRSr7F4FlUVCNryBhD6pgY3tzW4KNtsVDX0N0hdg3almeGsYhLVBuauyNJK+qyri8XcFI/0+Nvs5JgB17tstYuZmyNrKRnbADkPBT1OyyO+qW7f5x0ikWthMWrflYZ8j+TvTkNhI6QP17rQr7Cjz6mLulUpGvDtgnvpFaFkI4i9m4g9hd0McjWCNymwm4y1yUQst9YfzT1wYY6gZ5y6Ir68zQoJeYU20zqyCukia73o558+meRABYdOXncQ4EZdcqJ4dtnmi6EJ+nuZCPgtiDplFT1m
 d8ARNz1L
 OmsA7SeN16E6GsbXAo4KMd70w6cu3+fDHscT6vWa0FzG65XrufWauqq8FMlEtQ1sgfFEFNCRbM51F1VMScs6XHsJO0ZZJrKUDOz1OhYQgWKV29prDTKyefi7PsObG/yyKdADLN3Px6nnMEtPWqS+YZa8i7pdJJ8cUI0telUopvQKyYNSIMXS4qT217WM39Ukgc8p2HlCIhgLvetk2yMPNFcODaCAqqQEO4UVolXNu062Sqxk9h7InitAiP5Hjj8kvMQhVSnCCY21saapQFUGrk1xsw/iVnqJVmcVb9rV1DHYSJjYowRbytYpht8djkUVZw0CY1tixKuangRyA9hM0Are8AAWM0vu9lI6Lzu+c+lhSFfc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On (25/11/14 10:53), Sergey Senozhatsky wrote:
> [..]
> > > +struct zram_wb_req {
> > > +	unsigned long blk_idx;
> > > +	struct page *page;
> > >  	struct zram_pp_slot *pps;
> > >  	struct bio_vec bio_vec;
> > >  	struct bio bio;
> > > -	int ret = 0, err;
> > > +
> > > +	struct list_head entry;
> > > +};
> > 
> > How about moving structure definition to the upper part of the C file?
> > Not only readability to put together data types but also better diff
> > for reviewer to know what we changed in this patch.
> 
> This still needs to be under #ifdef CONFIG_ZRAM_WRITEBACK so readability
> is not significantly better.  Do you still prefer moving it up?

My intention was to keep structs definitions together with the static
functions that use them (which are under big #ifdef CONFIG_ZRAM_WRITEBACK
block).  So that CONFIG_ZRAM_WRITEBACK parts stay in one place and are not
scattered across the file.

