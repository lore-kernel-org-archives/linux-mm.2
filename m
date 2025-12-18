Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B12F6D6ACE6
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 11:30:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1E39C6B0088; Thu, 18 Dec 2025 06:30:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1912C6B0089; Thu, 18 Dec 2025 06:30:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 090876B008A; Thu, 18 Dec 2025 06:30:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E9EEB6B0088
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 06:30:01 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 977ED160DEF
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 11:30:01 +0000 (UTC)
X-FDA: 84232372602.07.E92DB1D
Received: from mail-lf1-f43.google.com (mail-lf1-f43.google.com [209.85.167.43])
	by imf29.hostedemail.com (Postfix) with ESMTP id A238D120012
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 11:29:59 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=TiI0kICG;
	spf=pass (imf29.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.43 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766057399;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9UwTmTndjxNkRU+xQueVbhSu5CbtS/JqDANe5YwnyGY=;
	b=t3gdGtQ7DWcinE04ZoyBlMHciljzVq1CykAkuFJzkqgV9Ps8YB8sBlirlqJxtY+QBvwPkl
	uPSSxRBVVyjQh74h4zrfyBlGDe+sdROHr1Jo39fNZ67h9A3QBFwG9W0ZGvMwQtcUmfPgvz
	Bog1ffUmf52aYpu3mE/ncadhCUM08bA=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=TiI0kICG;
	spf=pass (imf29.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.43 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766057399; a=rsa-sha256;
	cv=none;
	b=6pm2G1ln/SwmooKYkacV4/DyArk6mXhyP6A0lRTFMxQBCrE0D5/i8ZfDul4M+nkLgAq/mB
	DoBF3du9X1dk5Fhp2dH6hiew7dXsXTVBTHS6vacUg+VasRb0epcAoWBVoDF/G7tbDxKRDb
	B25gvI1whMgsEwpRzQcru6mjG5cup8g=
Received: by mail-lf1-f43.google.com with SMTP id 2adb3069b0e04-59445ee9738so363364e87.3
        for <linux-mm@kvack.org>; Thu, 18 Dec 2025 03:29:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766057398; x=1766662198; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=9UwTmTndjxNkRU+xQueVbhSu5CbtS/JqDANe5YwnyGY=;
        b=TiI0kICGbIlR4mLJpe8ERu6uwLA1qgVEunaC23CMwGx5Rjv/Uf4A2hk9qcFNTxZZsj
         1PX9MKQdnkhJ7IObcDCxGtXstIeS3LyNhz0B31wemTkFwYaBl/txufgLi60MEosw7Pmm
         1Fjjygu3tsX6sjbh/t/eo3rgIdKTXmM3jVYIocUvSyqEjaueNZouFKk+a+Sp/y1Uxaa2
         OTZXXg72k0vmeXO1nuk75KoHkVitR5CXUMA/Z79vmw8hQaeHysWvteXH1/+QTHZtQNTm
         vgHHlT+RNaarT1BgtrwLBPexnXOFsSfHE/GV/zCJjlqXV0J+7BgZgrOA1f/QQVo7B2SE
         CDQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766057398; x=1766662198;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9UwTmTndjxNkRU+xQueVbhSu5CbtS/JqDANe5YwnyGY=;
        b=vaMM53s+FONf0fYmjhPgEftkZKEpIsKL8s/v9cKbZYezl6EVmaNetbf+YYg+d755b1
         OOIiJOgVF7WmNXodcQDf3y+5ZU3GcgluP/tqPq2Ela/HvWa/keflVQwuvDRxqD72gjib
         KaYcYi8aSEkFaBnecOM3q8haZR8dXlJAvzjHhS6ylVyBuA4dO56LxpMWMLksPFhM4OJA
         ZnsHzUWXm6GdNU3M4WWZ5NtYTFXP5IY2ZRU4b81o45VQU/6OfmLx/Y0jrHXe41ekQ2lK
         jwERje69/2NsEqjaLJ1Ug5GJYomlb+11K3e29gjvz8NVeMxNKZE2DlRAZrq97GiHSs8W
         yDWQ==
X-Forwarded-Encrypted: i=1; AJvYcCWgrd+wT+FvISMRaVZEzK/T+jZ42PEDD+F2d0z1qQ0YtgT+kC8sKJ62rrLkSATMOOZVEsiTGhy1FA==@kvack.org
X-Gm-Message-State: AOJu0YyDgLkLF9Rw8AZ/UgEcVTHx9seXBR71zZchopbYJynTqU5OR2ra
	OxvZHZkMomnWH3lv5qsHGyBBLIvLsc6JTi/r2g4oMS6hnRQgGcERt53NscRU6M9F
X-Gm-Gg: AY/fxX5MCxRvO3GwG50iMN7GczzFHe3z8NZv5dJ6++V6N+NpJFqVaRGn0ug1lf87iBK
	Pc3XN+01X4jhEba2vr/MEGmR4XyrVlrvWaWNVOv2wlBWr7rMvSVNFVZw5DEz4tQnXvNZDeCfRP5
	VSEy6A0e51fxncRgBYbfTW6AJx6SgucZ5mAxaDjn8Va/4XnSSJcPxcdusxZxKjUDV4fAnLSj+mW
	v5mHhruYr5isATgzR9DApbebwrIbkbO90ghUW8BYwLP9EfYFBKIJuMpmrnm///wuVDjQn8x2u0w
	0HJ0L8zshbz+4I60SLoNhF3iVMTYAv1YFi3BgU72H50XfK5LJuorcjxCE6BWCavILCWGuqyQrbR
	kAjMPx/AZTboyTQbxgE9gjr/RW93txLLkZT30a91cW2XgdtJxzbcN
X-Google-Smtp-Source: AGHT+IGAcvXAxC1K1JbJVoEe3yEvZVZGQ4eGCpaeh9EQIqjv95XqmV+JDnbpGIIgvUkK6AnnC9Uxsg==
X-Received: by 2002:a05:6512:1191:b0:59a:10df:3599 with SMTP id 2adb3069b0e04-59a10df3775mr1346403e87.6.1766057397481;
        Thu, 18 Dec 2025 03:29:57 -0800 (PST)
Received: from milan ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-59a13405dd7sm1039432e87.66.2025.12.18.03.29.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Dec 2025 03:29:56 -0800 (PST)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@milan>
Date: Thu, 18 Dec 2025 12:29:55 +0100
To: Ryan Roberts <ryan.roberts@arm.com>
Cc: Uladzislau Rezki <urezki@gmail.com>, linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Vishal Moola <vishal.moola@gmail.com>, Dev Jain <dev.jain@arm.com>,
	Baoquan He <bhe@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] mm/vmalloc: Add attempt_larger_order_alloc parameter
Message-ID: <aUPlsxpYJz6u75Kv@milan>
References: <20251216211921.1401147-1-urezki@gmail.com>
 <20251216211921.1401147-2-urezki@gmail.com>
 <6ca6e796-cded-4221-b1f8-92176a80513e@arm.com>
 <aUKb1bL7CUcCWi8V@milan>
 <0f69442d-b44e-4b30-b11e-793511db9f1e@arm.com>
 <4a66f13d-318b-4cdb-b168-0c993ff8a309@arm.com>
 <aUMNyfeoEh_tJHpT@pc636>
 <026b42f6-2f83-448a-9b45-cc8740dd8d50@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <026b42f6-2f83-448a-9b45-cc8740dd8d50@arm.com>
X-Rspamd-Server: rspam02
X-Stat-Signature: uckwpyeb1mjx4qc89sw8k7kj4fa7p6qu
X-Rspam-User: 
X-Rspamd-Queue-Id: A238D120012
X-HE-Tag: 1766057399-135358
X-HE-Meta: U2FsdGVkX1/UXPk68vJdoy5ZICcy3IGxfyL1QXJolgWXaeEiQyy9eDb1nOd68WFtxPDmaKziP4pVSN5H9L1+mjAYypkEL0Yjt2GWBNWtLTfK/Po4tYOt0U4OUP/nAb3tReMtJwsfo6iHgxN+zoR9cuPcnnY60qIDMRVnuln04PiuHrqzkJc/MCnHymkRtPwijkUGCzM5cj0mhshNT8AN9YkpzhT6IDyHYyG89syWULNJmg7uMd6HDLSV+pS3ja+pOrtjLpUWpQmxSx/0bESy2r+6oCZzxrh/n7K04KK7HTUB8FayNVusoH+3ew2zG8EjxIg0UAc0i24OAJAXgp7hD1mFsBKqX9mk9jcJ9+rd5wkYXLT2i8QZzQPqd6Iq9/e3akSr8NYaemQIV1mGvGYd++wQx/BHXjB4g8LnZIcjrw82GQGDYSc1yvn2KzCbs+D6huRvqqiu8OzXCroTX4BU+ISHLP3hrA/XcH9SEO3WnXdPvOeInEVgC2gxVUgB6OMt2VxLc++C8vNXFqGzR4Ky9ghX8diSVgpKmf1oC7safb7fbZMgWf4KCy40B3xAR1mwos5b5NoF61NJHgBNFZgRzYJ1F2Ovp0k/z4GxYIvZRKH+AKeCMVNuSG0y3ncMu/vq4NjiwXMDSd2LaK93iYbHI21pqKKHy2tmcddXFEg4DEn+0N9mV358FIvwZMIgYCZlRH1PID59TrGMLddk3QLjLawQ10JvU1ITtPt7cClaI7MFmmjFz9n60bIASyGwJPgrKCOAK0um8ZbuzErsRPmsr3rNBQNhHintQcc5IBDlzKuJe2HsZ2acEXBO98J0Ta+8O8pF5HtEPUDfitiDIh6v4+Au6Ps5uQJ26Hg50P6s9gOKJLiP8wL3kB7vbqEnJX2ufZQHeaVfzjcmE5xVEraMfY4+KY4LdbaZslEdVE5fZAlguxoOhJil9Wd9GTzegy2/1/mpv4mDcKtaXG9Ck3w
 H/KQ1umi
 pPzS3KveSV9TwtKrDMvARuAGOVdc4Xh7XdSVxCDfk89l/akNn/7uh1YovdGFswdyLEKHPiZaoQGtT9H1MWDBzvAqVd31K8v17M8YPJyn1GIKkmBmOlFA6QLc8q3tEyg+rr2giO42MGUqqfNfnUUDKMLfplXypUvqKobWA3u2vCZOwKtr8w6eKNTc/PXeHB8FGZu859UhNF9ajC7hk+EEnMuBz2TCZA5zq90x+55Sz0EzOGpoLtH4bFZKJonY5UmZeq6FjlrxnfuABNTXFW9NseVChNS9Qbfboe64Lnk4TvBz5vGMB3blKN5eAkj9TWThWjQFjAV+8GL2kRfV40btXWu+79ggS/j9ZTrILLw5mZzdAnab+v6q4cqf2+wzTQwXEaOeEOa7UfpmdObPoPXOWXi6HBzw5uL7vm4GSzICLBdB1on8uUr5ncLVzQIU08qRcMB+n5cdtKbkcaAHYnP8CcBwzDGee8EZyvAD7AAZsHxBNay0QhIb94c4lkgKDR0sZW5yiAbuuu4CClKqsO9zwzOkrB1f+gzAKFONkg6rOny8DgK7f/xO8Av/Pc3/XRCkHOS5VRZeXQOFINDZ7ArfqGOzOxg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> On 17/12/2025 20:08, Uladzislau Rezki wrote:
> >>
> >> What do you think?
> >>
> > I think with such big improvement we do not need a configuration knob.
> > Your change will fully complete Vishal's work, i.e an idea to allocate
> > using high-order pages.
> 
> Yes agreed. How do you want to proceed? I'll tidy up my patch and post it
> properly if you like? (likely won't be until Tuesday though). Or if you prefer
> to work on it, that's fine by me too.
> 
I think it is worth you proceed with the change. Also i forgot to
mention that allocation path is improved also. If you have a look at the
perf figures you will see that a pressure on the buddy really has been
reduced. I think it is because the state of the buddy is much more healthy
now.

> Personally I think we should aim to get the fix into 6.19 to avoid the
> performance regression (even if we think the allocation pattern of those
> benchmarks is not the common case).
> 
Personally, i do not mind, let's see how it goes and what Andrew says.
 
Thank you and i am looking forward the patches!

--
Uladzislau Rezki

