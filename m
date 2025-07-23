Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E16E0C83F17
	for <linux-mm@archiver.kernel.org>; Wed, 23 Jul 2025 03:51:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 79D066B0095; Tue, 22 Jul 2025 23:51:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 74D5A6B0096; Tue, 22 Jul 2025 23:51:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 63CE56B0098; Tue, 22 Jul 2025 23:51:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 548976B0095
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 23:51:49 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 207BD1DAFF8
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 03:51:49 +0000 (UTC)
X-FDA: 83694155538.17.CE2534F
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	by imf17.hostedemail.com (Postfix) with ESMTP id 2D4F240005
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 03:51:47 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=IlGGTgzP;
	dmarc=none;
	spf=pass (imf17.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.210.175 as permitted sender) smtp.mailfrom=jgg@ziepe.ca
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753242707; a=rsa-sha256;
	cv=none;
	b=yZJS+R/jf6JMlX1xrBy15K1+qVffOUuuIp66nKPTrT1QZUzShskTb3I80EaEGMzXgSKCEd
	fvULT2zhDehFeySdcizY4dNPz+BPad0MV+KDxy6kMTMupF15czZvnqrf2b6v7Btdd1RRBY
	IG1gITdXdbz10lXEGerwg5CyvZAkjfc=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=IlGGTgzP;
	dmarc=none;
	spf=pass (imf17.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.210.175 as permitted sender) smtp.mailfrom=jgg@ziepe.ca
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753242707;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r0yhqhfmgcWd4Boy+yEMxc9KNWgoVjI2gD67+Le01vg=;
	b=lrqFD79mJ53WsOxQyfQepBNxfFhVhdculkxndX6yrqoXGLn+jfLYmdxdsGk/yk0mou2ltU
	Bz6JFEKMiMBOs3KLolZy7ohndfpSAHpFmn5mVNTCbcI/m+t0j0rPp6yoevXIIkIuMD0nsf
	SgUbEwkT9f9wCKPcJQbUggUzvfp8QUM=
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-74931666cbcso5045024b3a.0
        for <linux-mm@kvack.org>; Tue, 22 Jul 2025 20:51:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1753242706; x=1753847506; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=r0yhqhfmgcWd4Boy+yEMxc9KNWgoVjI2gD67+Le01vg=;
        b=IlGGTgzPDa5StV1AG+WyibT2aWxUVXge//sULMoSIMLaW6TdlLnzDhQ5YETf/oE0Hz
         2FGYJH9NqjW6cLDSyE3AzmVSwKNj6gfGl4WqDcLlYqxceNqecYPJqqANgULF3n4B+jWJ
         /2TC/TC9rtWHbZd9X8tNS16PqoxDJTiHYi9OkWqELC/cOZDUesu8EREEiZWeQZTS9X2f
         HfFOidRJHrlRW6zOWaXbdfTWQFZjmIP26DvRd8Pwt1pzAEA/AyOjf7JpdUDhgp5MPMzL
         aWairXMq9Af8GJi5KFufLI8Yh9eqlx66lwBb1d9YOSRUDfdMsWBk43otZssrLZvXNi7I
         xYkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753242706; x=1753847506;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=r0yhqhfmgcWd4Boy+yEMxc9KNWgoVjI2gD67+Le01vg=;
        b=pgj/mxY0RNBjmQwen5/5MyUzCLefL/HvctfUJ/FHSdSu3F2S2fZ8BBAhtlZuTMT+eK
         QVa6RFdvqaXe6GTwqe7JtNle4ODu+bSE8GGJ2lzOCN5UCI1WOIXp9Wp9VWwg+Fo2Y8IB
         EFVadFKmqEpOAnklGCudc7Q6Jo1uuPv2zLeaCm6Ku/SY7myLvfwBY5WKZ4+1CMNDXPzA
         NiCXDffDCClgVNIKrWpiS3kpdm0cRI6wjnaOOLJLmqE0tUwKilSYD7dUhVqG5oGB1ju6
         Tp0Qr8ZnNZB85/NvGIXJ3azLGDExeqnwsaTawSKTdWw6JoKJc+tdodTg4ZX1THHp61aV
         UdIQ==
X-Forwarded-Encrypted: i=1; AJvYcCWwt53SozuqkGWmIdvcemlRztcs/O0yDBUi8afnEfSk2iu4+EwvlS0+n/zkpjcumcFrYyfEPxvHtQ==@kvack.org
X-Gm-Message-State: AOJu0Yz45cdJss158weSvdW7mlKBE6M4aN9CQIUQzKVMx1MAzKfuNHg3
	gIfg2ZEHQli5k2G9JU09P6aud/krHPcyYOuFW7I4SfPwOuZbFPRMKPCmiG5EZZQRRZY=
X-Gm-Gg: ASbGncux+S5MqoT0IniNkO1ALWD8Cwir0bRhZqFTCXIIhj+LLLTBeQTUjuc7+e+61QB
	QCanrD7/bRlTL/2DDmPsquasvVFo+xkRHsna82GL68w3G+QodpzulNeo+M4ZpZYMETcvuqNBTF6
	ZVXrKtlm9PKFWTjfMuSSGjLtz29hIQz6PYZYk3hhh5J4fLFfReWiURTTp4T+F3MSti1tp9oXxlT
	tD1/GrevduSA5sd4YFAD5MrSujApHuf7U3j4VEU+H05FJV2h9AuD2r6hNO60l1T01wIHNGnyCsr
	Fi7VDcCN8OEDtGlaVQjJyaX88bZSLUJIf5NLtQodv0GYt6tcnqIpI1WehnqD8sgWQisRWYjckhj
	w7D6WpoILSsdFDJThHzIk15DzACwebg3cgl8=
X-Google-Smtp-Source: AGHT+IFhuc9YoswnVjbx+w6CW5AJc04rjosHA7fJ9MRqxxtRH8l6eukiOU6gxLlrv7CiSglvAulz8g==
X-Received: by 2002:a05:6a00:1491:b0:748:f406:b09 with SMTP id d2e1a72fcca58-760367de539mr2440550b3a.23.1753242705935;
        Tue, 22 Jul 2025 20:51:45 -0700 (PDT)
Received: from ziepe.ca (S010670037e345dea.cg.shawcable.net. [68.146.128.183])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-759c89d3190sm8518497b3a.39.2025.07.22.20.51.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Jul 2025 20:51:43 -0700 (PDT)
Received: from jgg by jggl with local (Exim 4.95)
	(envelope-from <jgg@ziepe.ca>)
	id 1ueQW6-0003Fi-CT;
	Wed, 23 Jul 2025 00:51:42 -0300
Date: Wed, 23 Jul 2025 00:51:42 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Alistair Popple <apopple@nvidia.com>
Cc: Matthew Wilcox <willy@infradead.org>, Yonatan Maman <ymaman@nvidia.com>,
	=?utf-8?B?SsOpcsO0bWU=?= Glisse <jglisse@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Leon Romanovsky <leon@kernel.org>, Lyude Paul <lyude@redhat.com>,
	Danilo Krummrich <dakr@kernel.org>,
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
	Ben Skeggs <bskeggs@nvidia.com>,
	Michael Guralnik <michaelgur@nvidia.com>,
	Or Har-Toov <ohartoov@nvidia.com>,
	Daisuke Matsuda <dskmtsd@gmail.com>, Shay Drory <shayd@nvidia.com>,
	linux-mm@kvack.org, linux-rdma@vger.kernel.org,
	dri-devel@lists.freedesktop.org, nouveau@lists.freedesktop.org,
	linux-kernel@vger.kernel.org, Gal Shalom <GalShalom@nvidia.com>
Subject: Re: [PATCH v2 1/5] mm/hmm: HMM API to enable P2P DMA for device
 private pages
Message-ID: <aIBcTpC9Te7YIe4J@ziepe.ca>
References: <20250718115112.3881129-1-ymaman@nvidia.com>
 <20250718115112.3881129-2-ymaman@nvidia.com>
 <aHpXXKTaqp8FUhmq@casper.infradead.org>
 <20250718144442.GG2206214@ziepe.ca>
 <aH4_QaNtIJMrPqOw@casper.infradead.org>
 <7lvduvov3rvfsgixbkyyinnzz3plpp3szxam46ccgjmh6v5d7q@zoz4k723vs3d>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7lvduvov3rvfsgixbkyyinnzz3plpp3szxam46ccgjmh6v5d7q@zoz4k723vs3d>
X-Stat-Signature: 3d79ed3oefnzy3qnhgqizoqgmdhkn31r
X-Rspam-User: 
X-Rspamd-Queue-Id: 2D4F240005
X-Rspamd-Server: rspam02
X-HE-Tag: 1753242707-136966
X-HE-Meta: U2FsdGVkX1+bPss7rhggACZfopWhoD07Zlg8uN5YTHdL0bTvOEKiUhjGxV1yEdVAQ8XdTrREoK/gG7Ge8EUl44L0iEiHlfRbZ+bft7Wzc38wWVxzyZ/fQS61WACrJuLFVTerIApNufFFMkqCgPLk/ChXgK2lAY8MvilRmyATiDnd7ybCgB26VA9MZYg60OLH9ThbLawPsMu4Aix8q9O/xrZMbvfAy7mD6F1GD3uVhodd164lKgl0699C4d0xjzpYU4TSnMU1mWILcH14+w8F5PdeB+IQyuqoZaqVgaOw1pvM5a9rv498ZaX2sF4NKOEbjOElRZBcDo6aahM1AOQSm6j7x9IuUe+ombJDJ1xM72ZIirdar3ROtnYW1mGbIOjx1KhLS7/maw63CS5Q20hiKPghLSydPQ/g9DLPSKAExcgFegl9lpan9BQdO0C7Cz8+UPChoaCZ7dugWExa1JT+tUj8jGpDieX+U41u7HR58+t2XrFxo9UdiCqf7WisnQempywogERGCe+Yo88iEBgivrnnub5+cfSt1nJx17hNCb2aLtwrnUy84UjMk/HJ2uXpKJNf9ZmUcjQ/gkZ58K4C9u5OYQXIapqsL6HQgSs4Hycwqpw/SJyM+rXYO6vkbxFnABgRhFlm0DNtZqxAxgeEhXJ0WjxM5NEQuMvI4JmGuYRl8Uz46j6XYdEPq79HYjRUVXEHt43t4eM0ada9h/ohTuZmnTHIoKQ1ST6kkQnRegriy+lCHwNR3cbz43G+8rmpEYxl0uWKkCyett/uoTYf2L65xNhaGafYfcHlcVkO75iuGkoO/fSlHsD8ZYO/o0Gg8A+f4h86q9pXZMLS+SKtwGFoX/xgUgzWLOUcyZeKygYL9slu6IC7MHogZty8h/9KoBZXj9qaVeR93GCo/7XsxaW+fUUoKkYPy918GyaFMPP815dQRW1enUqROaeB/vqXbh7jCWpLV19Csfujio2
 8sleVSmS
 HRWI4X5JSeANG6t3K6xWJm4iQKl6MCKVELTlAzSir/Q72FxxEPOWMH0e40PMioDVCQ0xFa77re+L3v0Rs5VAKrxNjfFqbtUumo9OGIZH4wIT2hJ/Pt0sbYI1WkkroWDxobzJNDeQ39uTUd1lnS6IRcEsVlqvV7urlEKNEim6wZeGwmpjdylA1u0Yob5gMa9DROh+gFCMDeNWZ58N511PGz+jK89J4lOiHTXNj5VqfznTy0zf3+NTH7Xp1Fty96x7oDYdn0NiyN51xop8o3L1d8DRlao5EaHOBHalD
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 22, 2025 at 10:49:10AM +1000, Alistair Popple wrote:
> > So what is it?
> 
> IMHO a hack, because obviously we shouldn't require real physical addresses for
> something the CPU can't actually address anyway and this causes real
> problems

IMHO what DEVICE PRIVATE really boils down to is a way to have swap
entries that point to some kind of opaque driver managed memory.

We have alot of assumptions all over about pfn/phys to page
relationships so anything that has a struct page also has to come with
a fake PFN today..

> (eg. it doesn't actually work on anything other than x86_64). There's no reason
> the "PFN" we store in device-private entries couldn't instead just be an index
> into some data structure holding pointers to the struct pages. So instead of
> using pfn_to_page()/page_to_pfn() we would use device_private_index_to_page()
> and page_to_device_private_index().

It could work, but any of the pfn conversions would have to be tracked
down.. Could be troublesome.

Jason

