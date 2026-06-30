Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 99FFAC43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 12:31:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 77DD36B0102; Tue, 30 Jun 2026 08:31:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 72DF36B0104; Tue, 30 Jun 2026 08:31:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5F60F6B0106; Tue, 30 Jun 2026 08:31:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 37E996B0102
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 08:31:55 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id ACE8716811B
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 12:31:54 +0000 (UTC)
X-FDA: 84936515748.24.7813B19
Received: from mail-qk1-f171.google.com (mail-qk1-f171.google.com [209.85.222.171])
	by imf24.hostedemail.com (Postfix) with ESMTP id C16E218001A
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 12:31:52 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b="am4z45/1";
	spf=pass (imf24.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.222.171 as permitted sender) smtp.mailfrom=jgg@ziepe.ca;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782822712;
	b=7lFUqFG39YQCbgK44BjhEeoSDuCB6k/wwBUP7iGyclytJapfAUl5YFa2uC0vt3IMTdnQD+
	QMXVWzB7xMgoN9Z+Ocwy0fURl+LGAR/zQHNGgbQ/hX/1pR8x7MKP/kcuKrsHPsyDzvC9MC
	oGCQKrRkRrHjmBvx4qLCWSHRHd7nVfQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782822712;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=K6zzVV0af8xAaoAtSqcQxD8uDRZmwf0GT2DpjrnXsAg=;
	b=yUGtm8GfkxNYpbD20IKwvvv3dCJ6hlSNghWxDICO3XXMI/MR688y1PeFPFR1gFEGOgEaMl
	ujU4Bvj2b5iad/HJjvHSB1FtVn++OFm48MERHO+zC/ndbr5CnieYjxq7WKTrVTIxwxsCu0
	SJ4AGIapknfik5qFTT2N04Ae1V1+HvE=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b="am4z45/1";
	spf=pass (imf24.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.222.171 as permitted sender) smtp.mailfrom=jgg@ziepe.ca;
	dmarc=none
Received: by mail-qk1-f171.google.com with SMTP id af79cd13be357-92e6c4a867cso16457285a.0
        for <linux-mm@kvack.org>; Tue, 30 Jun 2026 05:31:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1782822712; x=1783427512; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=K6zzVV0af8xAaoAtSqcQxD8uDRZmwf0GT2DpjrnXsAg=;
        b=am4z45/1OrIqVkCx3amfsFtOx9DmoPcJGZJihTHpBcr3ZOwNbRb7mf2bWkDbbw4Vo8
         J5LbEhmZLG/95HzMqffSRQ/VLoHId7cXnJUzcjZWCaRY+hSqfiJ/xtwQqR2OainmWED9
         SXl7r2WTlCypceprtPj/vKzez7SZIe6jM6gb63qV2WNSpWaL8bqcoOuoVVCDvSnr1pBx
         PQKmJ4G/0DRoy9i7D0UhVBAevfmsDGTG3MFLw6YySTkIZuo4oM4uH3FkgPecDjSxfcMl
         ubtwCTqx4b25rJ87MSxtO8fxh8aM4cZGKn2ExIqFMu6CSUSi6B5jA1P4nj/J24bff/ck
         ucHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782822712; x=1783427512;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=K6zzVV0af8xAaoAtSqcQxD8uDRZmwf0GT2DpjrnXsAg=;
        b=iN3Hfo7oPhkoEoz8t+L8EfiH30MT/mkKCk10J3Fo59MwQGiIw2zy/Cq/CDj+N2wlUs
         CbeqPq2UPs5qdfvm4v+xLJKwjC+3XxFx3nTQj+bDQKrZl0KOHap/WDKbxahSvZlJDYd/
         wLHB15J21985SqVZJYf2hMX+qy4uQLM5m0kIG7F+EdOvcTKuFFF4cDkP0kMHy3PFxt0p
         l4nB+dU4O5HedWhkSQVOY3ngXZNhHD8hChIEnent8mUt40Ati8aru94gCQccP59+xren
         slcJL+pqNP4PZQhXV+HmvfdD2WZ0Pi6LDpMNDgvvqykGJnQo16JuMmRv8EcB/H2p2LtE
         v0cw==
X-Forwarded-Encrypted: i=1; AHgh+Ro4Pe9kML3VyB1uJJS0aWL+B2kWkSJJ8YEYAclEjVJaXoe95z/gC9wlVfq9GH9HbKbmjSFwJQWXUg==@kvack.org
X-Gm-Message-State: AOJu0YzMIuksUUG1Z5SE7JuGNkjtlmzAbcIRIWiN2nC7m2QSDhaMGGTk
	c3KfjBuesl6PpQspn8l/mKogvHK2BuU9a7f0sfxZ1Djss/CKHA0yhszOl4ex5gNacF0=
X-Gm-Gg: AfdE7cl/c6MOHLNFiukmLBixiPfLqTARz7pFpeFtuDU5S89/+8dO0ti3163YcYMzoFp
	LoThl1cSuXT6K0NF7y5lZCIFdWhh/+NTDWIO81hsjz674nY3Cx/XCoHhD7BNorNQfwtykcw0oS7
	9lVWaqW1mvamiOWJSVNbzVZ/BmuQc20z5ExVFr3IbqSKyZONit1O61/cRmje7428fNqjvGyg/Vj
	+mPBYhuQI8NpJggpwV7lQa8F4o57h5t1lJMMOXBcKax1ZXOawNpWt7Co8hxVFBgeoNZEBNf0L1j
	P7yqLG1LSCznLSLklW0pqOcpg7TIsXJ89O4EdiawGJ0lRHqz5WdelHO/tO+x+9qoH5np2/klxKM
	FdAFVIsCM48uCoHTbLrridTkrb9ROIGy3XcfiWBM7d9cUG6QTARUC4r9XPFa9FgIO/mhJvYacN/
	eBxzhD86FDZVTw+/ekkNYFtczfokaoNksa7IkdodMd3Gu68K2fKgtKX9V3SFFnwYMCUbk=
X-Received: by 2002:a05:6214:31a0:b0:8f0:275e:8b3a with SMTP id 6a1803df08f44-8f1be38d9f0mr47693926d6.48.1782822711717;
        Tue, 30 Jun 2026 05:31:51 -0700 (PDT)
Received: from ziepe.ca (crbknf0213w-47-54-130-67.pppoe-dynamic.high-speed.nl.bellaliant.net. [47.54.130.67])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8f1a328fed8sm22758066d6.16.2026.06.30.05.31.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Jun 2026 05:31:51 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1weXd0-00000001ppa-1Uxh;
	Tue, 30 Jun 2026 09:31:50 -0300
Date: Tue, 30 Jun 2026 09:31:50 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Cc: Leon Romanovsky <leon@kernel.org>,
	Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-rdma@vger.kernel.org
Subject: Re: [PATCH 1/5] RDMA/umem: ib_umem_get(): use kmalloc() to allocate
 page array
Message-ID: <20260630123150.GB7525@ziepe.ca>
References: <20260630-b4-rdma-v1-0-ab42bcf0de92@kernel.org>
 <20260630-b4-rdma-v1-1-ab42bcf0de92@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260630-b4-rdma-v1-1-ab42bcf0de92@kernel.org>
X-Rspam-User: 
X-Stat-Signature: q7yh6n8mic35gfqqucz5ca6384g7f38u
X-Rspamd-Queue-Id: C16E218001A
X-Rspamd-Server: rspam06
X-HE-Tag: 1782822712-661250
X-HE-Meta: U2FsdGVkX1+6uJM9mzUKC+/F0bRuLKGHAoks89gLogOLCWIqzX2a6nUqRNJ36RTGMkFDNlr00Er63sowNurolZk5xw1SZMnqm0sSWhqJPluK3nrh2JsMLnD5KPsZXEG2D1fMZOZ8I9HMTfMl1LZeaSJ/Zt4fblTk4smr2yOY+FMdLUOf3si2T8WOySRcp1XtS0I1iEXJuqjiQl6iR3n/V/nqGykCi0RmLJqzKg7UxvDbevdKzy5Nrxwjk2MFQqY1ZASHZBQBdvgYXHtwUiFWg8s0CRNixHrLK2hVNgwhP85QrVWnLGmt7RL6O7XJ6AB21rOwFav+znJ8WIi9TSwxJGXG1yiOspFvzDl1wzTaIIk7YLul/UF8gDFkoxWqOmVGfuQfnwtmX6kfCqljHOFyQkIth0L9DduMDfBrusG8/XmHf7I4OZG6WwtYUyMCh8JZxS5SCHQVa7mLdphdVS2dG8k4eGjzx3P58o7ErthRE91GGplo1OkN5XIgqRSnhIrK8IQCXdYKcV1QUd6+d1V8VYpRS5Cvl7DoC91/CMuK9CQvvm7Ry2nx1kvffOwemmfvnetSZDH4Pwj903/sRH43jhYop8ig2wp2xFuyNBJAnCRPafdCBfGXqllb4JK5JhheN0+/NE3naid/G3VeEfmt6nAGfubTz8W1/I8rwKopgkpL7Tw8J/6SpdbIU0GVmfk392CVDmndXARlk+O1xN/SNOBWDKWEYsH1+tSeC5mkOLbRmbhEJlNf1BxABcXLs1flimKMOVXTk86ODe4F2iiNmrP6k6SVQ4V9DTzxTvMR2xxUQgvvdPy2wWZbBY8UcJc13g0Ms6+rgtJVAbwOK1SNa0YiRs0RWE5v6vpOvh6fh6dMLlyuE8kAgJBNNz9navGWdUx0LULZwcgMe2kq0tORtDMyxpSbQSF8rvFvWt9PZNBEAt528cxeEjLOGFmx6tNjbvc/3eOTFZg5Iz1f0mb
 tkRL8eN+
 yji4tFU/E+S+602b2z50xI9yyHMpJts3mV6rmO9uhEpO3NPyo3HUtXgBWjOLNRs2w19EjIgiE4bojjHmVIiFdOfYtsxY2xiVLrDx/pfmF3OS1SR/5RcSFyP7U9pVC9F1GUokeP7DWEz92QgQWAEaY4HpoXSJ3Iebudihrw1fKwK2YxkxIFIa6G+Yzm5TM2ixWZqwopTTuOoMwnoho9oKCNjPsjNi/5TXuRmB4RAAp6WxbLvV3wAlHlo4S7pmUhvnx/2gP3YiCT39J/4QJ7x8bEQUYOrMtrs410KjJ+ZQZ5f3p9w+1v7+xjvFY1UlT9eST+XfjK7t8JcNH8n4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 30, 2026 at 01:52:29PM +0300, Mike Rapoport (Microsoft) wrote:
> ib_umem_get() allocates an array of pointers to struct page for
> pin_user_pages_fast() calls during memory registration.

A whole bunch of these use cases in rdma are really "give me some
temporary memory, I want it fast and as large as possible. In a
syscall context I will free it before returning back to userspace"

eg we'd be really happy to get any kind of high order page here.

So, how would you feel about a new API?

 void *kmalloc_temporary(size_t min_size, size_t max_size, size_t *actual_size, gfp);

I know of a few other cases like this in the kernel at least.

The implementation could try to find an available high order page and
immediately return it, otherwise do a small reclaim allocation?

Jason

