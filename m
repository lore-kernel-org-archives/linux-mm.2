Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71567C87FCB
	for <linux-mm@archiver.kernel.org>; Mon,  4 Aug 2025 20:36:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F1A618E0002; Mon,  4 Aug 2025 16:36:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ECB5B8E0001; Mon,  4 Aug 2025 16:36:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D92F18E0002; Mon,  4 Aug 2025 16:36:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C842A8E0001
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 16:36:42 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6DE9EC0900
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 20:36:42 +0000 (UTC)
X-FDA: 83740233444.19.7CF1852
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	by imf19.hostedemail.com (Postfix) with ESMTP id 898C91A0004
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 20:36:40 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=mWkBTNJb;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf19.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.216.54 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754339800; a=rsa-sha256;
	cv=none;
	b=SirD/Lo5f1teIqG8IADlQ3HINAD+fAX2c6OrC32UkEKbGLW/WMgZPSvm/ly7zyaAYOH1Qy
	yhBoUp+zZTZf7D1+9gWxwGUj/4wyJ77PzviYPlqUqBM0g1BgZqC+i1Ne9xqiGQTHqdneZA
	ozYhQzMMQn9M/6n7EGtojB2HBH9JfzU=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=mWkBTNJb;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf19.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.216.54 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754339800;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eIGP/TYMfErkKMr+9f7De3GNEN2DucNTWzDSIz2HDXo=;
	b=wwcEE7qYSN0ZCJm4qeNoR2Gq3c1U2DtjOR5Xu2kbl0q6TIoSMclF62/SuKmVwwgGbLxnYK
	7TSJ1SG+UAerTZhfuqbe3uN31ofCrS+zH0AdRHVws95UhQK6/4+Tvw6z6Dcjfh0rFoKG+t
	h0yMdMnP38N6wSENDo+qebPGTCQ1URA=
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-31f255eb191so4144094a91.0
        for <linux-mm@kvack.org>; Mon, 04 Aug 2025 13:36:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754339799; x=1754944599; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=eIGP/TYMfErkKMr+9f7De3GNEN2DucNTWzDSIz2HDXo=;
        b=mWkBTNJbZmUIRVfCw7HwaKBhUHGg5mjoDa4ke99bH5YtVvl0iquADErASJsSR3jVac
         nH3t1BaBCA7oiXTXi9HQGyL5wM8cyI0yLOHHNE7EHq5m22YmKzWNNuJOGJxvCtSiddrl
         L2EQvvC3NxTLHkPenk2EaU/N9/Izoy/Ngjrztu4RVSl70NykIwQs9JowjPpzSyvyGher
         FU6AEgx5Oou6q9737GFWQbeg3aSLBG/QcARF/i27EwCLZMgY6g5jX4Rwt++9VAgWkpiG
         NI/vbvZgU/koKcAKC+doHhdcWXJxArmRUZmO0F1Grrh+MX89aUDVZca1J9r1l+SWWiS7
         VNSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754339799; x=1754944599;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eIGP/TYMfErkKMr+9f7De3GNEN2DucNTWzDSIz2HDXo=;
        b=RX2ThxY/6SqcMLuERDYl4NpKa+ONTv2iEHSAAeGFOOQP6Ul6NJUGv6NfiFZW0GV+tL
         zBcVpafix4NlaH8AZmLgibfrCXAQJK6nwxYLh9XJzteUqvKgnK1uuVLMDOyoLJfjLFRf
         i3NO0K9jvZBoaQ5RpsL+Pznqk3mnFjLoSyQu5ZaHZiQoQd/sxBSvyAJqZa768hhgX7w/
         AdSq3jzSoGLHFYTmaCUlsLWLdfzBoEpPnsYv6Lx37JDHYn7kAjKprCwPD+MHhKbd+jv2
         dab9fFJ7ZADeUSX63NGyPU62geMDcXdYZDLoQFfM2ZVFWZWf1PSWWYGXEImamSHr4Uaf
         zZLQ==
X-Forwarded-Encrypted: i=1; AJvYcCWnJX8ePBYB08QNdwfeE2HyCZYMXkpZWfX8iTyyE/bVsCgJLkDlrdbZzDQzikxHTyTPAIHOz+gJXA==@kvack.org
X-Gm-Message-State: AOJu0YxOa7TxnhIaQCVclAJBiZ49QgEG0flqBaL8bbkKhghb+3pLodlq
	SEu2ZMg12BQNOUwdvoU7OV+5znBLDsRqcESydN5KBCVsJ9YPz/9AvSUC
X-Gm-Gg: ASbGncsL3UJ2VaPH4MLfxmtGKZlUQ1vdI/my5KkSQu+lT6kycpJROPkKJF3k0aTyjz4
	aHz8w7/bkKsw0lRA1MMfEJCigpBDtTAKZ8zD5rn9bEY6J+GnU86EKwtZpLxUVmZJ+u4XlY/fkGt
	mFl9h8X3/7AKR1W8vD5l71wm08DZdsevBKMHNw/GrMY3H73nexHDzjGL6ulVSDw2SrTtzDbEHbE
	ElIfDSXMauFLJl/tkzptBLX44TTSreYAM5UhVDmQ7X+XvMecQ/mNmu3vuS+uHZogwwVV+MZ46us
	PA9zcVR5OHjlNwT4r2QkGNvMODPOrG1zPp+zEXb5EXZ2rh4g0qQ5yvBiSWhRlMMdQOk6R72Rgb0
	0P61+kjcboji4XY3EP4PszRMtbYJ3CohkMKfB7jU2jdTe+5E35VnQKA==
X-Google-Smtp-Source: AGHT+IElL3DMsVnqKtYSyKw9sORCZtWkeduMxbK/iEq84SfX2Av/ZpBB3x5O/++9mdJr6utiaduknw==
X-Received: by 2002:a17:90b:3ec6:b0:311:d258:3473 with SMTP id 98e67ed59e1d1-32116202f9amr13301529a91.13.1754339799223;
        Mon, 04 Aug 2025 13:36:39 -0700 (PDT)
Received: from fedora (c-67-164-59-41.hsd1.ca.comcast.net. [67.164.59.41])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-31f63dc167dsm15265582a91.11.2025.08.04.13.36.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Aug 2025 13:36:38 -0700 (PDT)
Date: Mon, 4 Aug 2025 13:36:35 -0700
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
To: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@redhat.com>, linux-mm@kvack.org
Subject: Re: [PATCH 2/7] mm: hugetlb: convert to
 prep_account_new_hugetlb_folio()
Message-ID: <aJEZ08orJ3jrBTH1@fedora>
References: <20250802073107.2787975-1-wangkefeng.wang@huawei.com>
 <20250802073107.2787975-3-wangkefeng.wang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250802073107.2787975-3-wangkefeng.wang@huawei.com>
X-Stat-Signature: nmtsoca4yj3ckmcm7wtnktii8j9y3s7b
X-Rspam-User: 
X-Rspamd-Queue-Id: 898C91A0004
X-Rspamd-Server: rspam02
X-HE-Tag: 1754339800-483337
X-HE-Meta: U2FsdGVkX18uQhxaa5yZaaY/XYPsv0yrVQeZKcyyJOplhb0YmmajCTTY/GQD9fPH/lkHQcX+AqXiZRg9nN7oc2Oq8w+x7uRm3nDiZ4pgRty+VCDXjTn1EdlLT2TqVtJsx34jKxhGyDrNrnDr6HxWCzprf+zaLvdzSPdKHJgZsws7g1cS8Q1OnN5+w2VtcPaANX5TjZB1ES3Bm7CspI1m/Q9Cai34ob0+mWzKFJ2jZnaqIxPrc2dUTvOZ+OjFIdhchDqn4CCiScuVDM7f0ZgNzaoQRlUbuGzsfLdBEAHIoF4OSLoWpKx20h3OT2F9EMBH3mtu57DkgMguNk7jVMRs7QsRmCgiFXhvOAs0Ahuhkt56U382kTouT2ODIDOeGOl6Flu8rbJFGxRNbn3qbzJtBfbzymfA0Qbk8WkVxeiWo2Sxnkc1PnThOnN9xNF3M6e0lQxUJIfRrMrVRYBYqNOIeYiIIvAAJzTDXbi8QW6jh6ABcU9/3D2yyJCwR/Ql5qb8w3ejxyZ2zn7q1ySbHM2JWH4oxTmYn6CLme5nVWaxJ73tedRziSx+UmNRVGV6xyZ0iDhWs1AGkJTdmSVbbq1+93z0Q8zha8zmCrsuDpY5914zVK18a+RZzcDMOo12/vkUnj0p5ujAuGC0EWCciuXI2o7qSVS6mRLnW3A6gTMOIvWBDBef+ccISEilg+zaAe+x96Rb8UGiAzMl/Gd9nboJPR72GKX9UrpOcMzc55nzkW1Hu7iF4OxCroQq2M4s9yKeLVYKo96wAqWbHTN4y0cvSETHwOc/xcnZpZT0nbZHhnFUMBxZ+FQkcSSa4tAIey4b58OVKPOC2p32kNI2mORB10gubPTy6zuuXj2D50WBTeZhZOLN7m3Vcd9S97c3BK8mRqFaGB5Poyvka75p/E3DSzyf9mRmlXHaisep+EMEUFNsWUb3+DwiNmjlmhh5A/7ICycuJhUfyt5djL9Atss
 mrDqKc5H
 +uJAevHSEgR4Dw/Kk7v2+Urbx/bpzsHsFYNu7L/Ywoh+w4a76SVTp79ATPcvHOwOPusphY5S4P8hmtNbjOxKRlsxsh0LRNgAFWrZKaSi/2V0aMdoEIfPBdy7lNnDkKTBnCH6oV701c/37BEKCY+P7D4AfJlKX/7vTBk9RqTvibUjlA9/JEpNWtNJIRoPbfVF8Drn2HX5U2VVLJi/87/c4jPdx6QkNE5/IF3k5qzUOSKhlAb+0FbguVHt3QIyD//Cu14wAizBsaM2ykbK26eVUYtk5dI0IzmM4aZQtYLWoOLxBFPx1boYhyhnZL6my7yUhRG0BkOPDViAdQpQxljX6a+tUs3qUlGB40wmqmjOCG14iHDH+n40felBixmi+UJy0uRWGJCU/Id3+IEfcDIwklwfpA4xJf6kHKlNJidBCnB/VQVU1rURfJS7RxiyKCG6wlPyUfIKwq/GOXJLYlQgigUWNYQKI/n1cuI/MWsyuEVeVtSjOBXgtDLWmLUYUMbl3HLwt6NU2UMoXoXtYuY7uY+BCjMQUHH1/7dpSEDYybHZ0hWFuKCLM+Nfudw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Aug 02, 2025 at 03:31:02PM +0800, Kefeng Wang wrote:
> In order to avoid the wrong nid passed into the account, it's better
> to move folio_nid() into prep_account_new_hugetlb_folio().

I like the patch, but I think we can rename prep_account_new_huge_page()
something better. I don't think we need the "prep" part anymore, could
we go with something like account_new_hugetlb_folio()? 

