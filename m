Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CA56AECD993
	for <linux-mm@archiver.kernel.org>; Thu,  5 Feb 2026 18:11:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EB52C6B0089; Thu,  5 Feb 2026 13:11:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E63166B008A; Thu,  5 Feb 2026 13:11:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D3B1D6B0092; Thu,  5 Feb 2026 13:11:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id C609B6B0089
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 13:11:08 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1928713B557
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 18:11:08 +0000 (UTC)
X-FDA: 84411194616.17.F42D014
Received: from mail-dl1-f41.google.com (mail-dl1-f41.google.com [74.125.82.41])
	by imf03.hostedemail.com (Postfix) with ESMTP id 1D7EC20009
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 18:11:05 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=giCBmpO5;
	spf=pass (imf03.hostedemail.com: domain of usamaarif642@gmail.com designates 74.125.82.41 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770315066;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KEFZK9p8JGnqg23JFNHQNyKGsNmNXJQuyv1VdR0V//0=;
	b=a3+dBkTY52dMKCP8o8NNokdwfoaCCZu+ZRfR8txlyiTov9m6dBTey3FkmsexjnnWmMWmxr
	EN6OCWg0BKpKjjX8hkkUZrzILqB0eNzzx53yJ6vG7wn7zwFiskkubOkkLWv3IrIWPJowqQ
	491VZhUtdoimJj/C+g3yPk3JqbAM0H8=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=giCBmpO5;
	spf=pass (imf03.hostedemail.com: domain of usamaarif642@gmail.com designates 74.125.82.41 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770315066; a=rsa-sha256;
	cv=none;
	b=YGt0N5VWT9EYcsZYD8Wvq3OsGmfs+OBVt4HqrxrBMFsdV/+naK/nM0UjIL5WrKyyYRvpki
	5jx7Qa1dKUTeOmYG3lwW78jJ4Ao6+B2UaqU8VokDb/dKd6Ah18lxkkIAHJ8Ls1oR3swCoR
	32M0tJ07DY2pbsUpoLCku1S1+RWIhzQ=
Received: by mail-dl1-f41.google.com with SMTP id a92af1059eb24-1248d27f2b9so1417170c88.0
        for <linux-mm@kvack.org>; Thu, 05 Feb 2026 10:11:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770315065; x=1770919865; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=KEFZK9p8JGnqg23JFNHQNyKGsNmNXJQuyv1VdR0V//0=;
        b=giCBmpO5M0ioxrIAJEMeqJWP66XWY3OJXjIDxRTgXXdvLmpwEYRVq2eke6peR87TTm
         kbDjwRlBuY0OHY7v9osOJ7wrU5eoZCjBhfsUXOB+Ajl3AttlRLPqpF9NoHc77pGidB/8
         LMPoB4yiBCaniHCgUjItuRzuy7bFgYfuj7re9F0PK2QC3P0v6GUtF9jP1dF5bxNENjQS
         +4FTbLfDcxnOAkp0ABMTu1LhOGRba1JrpKXqNgOxTWOlJyPy0zuaEPioa7RbqGIDY21f
         kCzpSIYFAacfpK3tpMIuPby4tZhOXD/oQtnB3jnvOyljVD229n4xDg3YF5yCxST/Y0vo
         GjnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770315065; x=1770919865;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KEFZK9p8JGnqg23JFNHQNyKGsNmNXJQuyv1VdR0V//0=;
        b=Z/hO86rPgQCgp9SaNFixXoXJTWjONDNsYonlaJAZ6McCtKpOY+GXiVMO1iJCU0QonZ
         oKY1EPFPRiHfolEhqgF3enuttaW4/RcKQ5MZG4Dtr4KOnj17Bz5VdkLTQcJO/s8xmGsG
         l5XN8BkEoeSpLTMT1Q+9tjXUY0Hs3Z9PWJb5hJb0zsowe0tRuRcjmZUi4DPdtos86IbZ
         Z8EypK+MMsFNqn6riFe9zwY0+3TFcj0wjhf6RokK+0VEYrzaGrM7PUa8mA/NoESYwv2V
         YjdUmHkQQfkjcgH5vM7vmj2NNgRkKqprZW3427Ol7Ab39PFDn/1H2JS/bL7gX/W9BvWl
         PTHQ==
X-Forwarded-Encrypted: i=1; AJvYcCXxDwYfcJXNImdP/eNXbkjBFvm5kBdXqBEKTt6rvHSX4q4wjgaPdm3fM94ctd/ZY1o3F2zJ6Y8A4Q==@kvack.org
X-Gm-Message-State: AOJu0YxdCMIytt9OdNPPWc1S06UKP03xb2Xok9v3TaK9TaUgv7a4K4zy
	Y7MH5xdgKKH5Rhh2hn2eyJWxLFvZIEA3dlR1mzrgCpDtEtsGwv5D9sNa
X-Gm-Gg: AZuq6aKOySQRd1TpKjw4fJ/4zNEehCqkRTNoHF8fNIhLyyNiFMI3gcKafpplKfYaYCI
	uJd0aeuP2qBqQN/Yzyo131BTKa7Oqv+/+vyvUFJqss1I11X4YSxI9atQB+YaCT6HVmTySp1FMpk
	Fvv6KotZjrA2sxKAxRWGJtnpM6leuQmgidj2Te4USqcPKGDnotcuXTW7ehaA704DYs3g8QW+/x+
	186SO+TXV2s8ELEoNN3efmO/NycHNb5yDhrGNJ5UD/f0Tkv8fSM5ZIFitZrSZjnbCTB98wY3/Gd
	XiWs8fuwvo9KRR1Q76sBWnPnYylnhHOMcpQEryfiuXL5fz1RSulWrMiasYEUpNyoV4mBuME00wm
	jkLko10xmyMT39VXek9ylB93na00LZGXvpVUowcC9XSEOFJE9OLXseAUKPmQfHFw0Smiv4ZjgL/
	HfqhclGoxgUbqEQsVb60MC5bFoD4tO+NE6CMljnQpOkjagAOCEd9fCslpV6mZZ9IBkXg==
X-Received: by 2002:a05:7022:b95:b0:11b:78e6:8323 with SMTP id a92af1059eb24-127040195fbmr50654c88.37.1770315064759;
        Thu, 05 Feb 2026 10:11:04 -0800 (PST)
Received: from ?IPV6:2a03:83e0:1151:15:1cc5:26fe:6b00:bcef? ([2620:10d:c090:500::3:b30e])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-126f503ea14sm5364457c88.16.2026.02.05.10.11.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Feb 2026 10:11:04 -0800 (PST)
Message-ID: <6c93932a-6adc-48bf-840e-f8ce8b56391f@gmail.com>
Date: Thu, 5 Feb 2026 10:11:03 -0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC 01/12] mm: add PUD THP ptdesc and rmap support
Content-Language: en-GB
From: Usama Arif <usamaarif642@gmail.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 Matthew Wilcox <willy@infradead.org>
Cc: Zi Yan <ziy@nvidia.com>, Kiryl Shutsemau <kas@kernel.org>,
 lorenzo.stoakes@oracle.com, Andrew Morton <akpm@linux-foundation.org>,
 linux-mm@kvack.org, hannes@cmpxchg.org, riel@surriel.com,
 shakeel.butt@linux.dev, baohua@kernel.org, dev.jain@arm.com,
 baolin.wang@linux.alibaba.com, npache@redhat.com, Liam.Howlett@oracle.com,
 ryan.roberts@arm.com, vbabka@suse.cz, lance.yang@linux.dev,
 linux-kernel@vger.kernel.org, kernel-team@meta.com
References: <20260202005451.774496-1-usamaarif642@gmail.com>
 <20260202005451.774496-2-usamaarif642@gmail.com>
 <aYB75cWO2nnTx2ch@thinkstation>
 <63D23D5F-AF35-4199-B52E-DFFC16DFDF91@nvidia.com>
 <05d5918f-b61b-4091-b8c6-20eebfffc3c4@gmail.com>
 <aYQZzw8kJFsy1mMW@casper.infradead.org>
 <aYQar8YiejRNCqE4@casper.infradead.org>
 <945064a3-b6ae-4257-afd7-5229cf8267a9@gmail.com>
 <ee5bd77f-87ad-4640-a974-304b488e4c64@kernel.org>
 <b2947260-becd-4f17-8822-b4c7325a176d@gmail.com>
In-Reply-To: <b2947260-becd-4f17-8822-b4c7325a176d@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: ehfth6m94g7pxn3c1nfqumdtmtupw9dr
X-Rspamd-Queue-Id: 1D7EC20009
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1770315065-394430
X-HE-Meta: U2FsdGVkX19inzhIsoNMg33bkavG14fqaVwTw/sbDlXgyY9tso3WtuZ9Q7GBD7y43tRufaGKL5hP3N8pSKClpTm/M1AHYo7YAxeqTHTr2Qrr9+KnwO++Ti1RDsuqF6spDHn4LkriaSbSD35KjU1vXyZKW5iCDRBcX10f80/jxsD9MUD43L1FGbCyFwHsargHWUe1Jt8MMN/1LC4tw0cQdIbGVDfboA+TjQdKujRumjMZ0Gbh5oXWNQ5fUPL6BHkjfK2QUI0th7jFDTO1MWm/sjJi/pbzOVq0YPvFg4GdFEQIf/p1x2gqEY2xT9raBSb2a80dwvnqFR7zjmDFgK6J18V+2qeGfV17AwWunsaP2zT6pFxRkd1sT4dfYshHajhmBqf9cqkfoHevpic69ZZXg0glKTzo1CMNMSgz+XYuKS28PXpHiHclatsDuZX6OGrYRCm6vbcyHaepzZHJrEh1FjZrp5H7DNt134PQ5tGM4elV3ai2Wei0r8DJuDY9/7Yxmz8b+nRqOz4Guny+6a+ZWwRtxznu/PEgaNr/D5kNRB3qdGQBZ3O80HXIYdYDvlNfx4Mld7quOXimi54bKS1dDByD5iRnhpBdlmPy9KiCw5qZVhHFByTWWuoT144DnSgUkd0IU0eYCKvDrdr2cj2sDqVdy9jyvYLn4IlXBIDwlXU9BSO32TPwhnaQfN8CDjXAy9ygW9dCdUKKWyn8Bxx95BLNwjtnrCnLO/xxmr7vk/g5Nv7ZZ7J8ccCh6i83hRZLoX8zUkyLYLmaeq0gBwQLf3VN1Y1MWZr+Qp4mu9Iwn29nYT/xGMOIpt+L0mnmuQtq8fhoiOMOK8Euc5yFPaqIm1vOa5PyyiO9feKgEeN1JiT42dOk9H6/qvmk0agIaQ0yRPnZNK/k5laoYpTt7t7iWxdtNFWOxcfV2I8L/SC5kIcdmhu4ovbpe1B3zuAbac1/KSdlNBoCplpPI4DGD6z
 FaSAAO2M
 KeYDnfdk+2oYgK21LX9b/Nyk/ZWCJJGb44J0eJYmybFGH1fgPf7QxbDby+mxM4uvb6fTmIAhzA6KC/QAtpHqrIEmZsZqVI186M4u2YBiBFVE4xh18gM23b7zRcUQdGFQlBWnHbL+s0wFQuCSfX3SwnsHGVHuVIU7GjwjHi83XOW7mb6q63Nf54fiOojq5nkp1uLxTeoEKhUDbBH+LZSrUhAozlgO7hKdO0u7hU5jwdmEQnAJsSmbOnrKx/w4Ms8TCprjQiKeKnxuUIgQ5oZD/HhNWAb6+dvxhXC9/RxNJxsaLkH9Ax3H9JQDF7x74lGs1ROf1E8mb+kA5fG4D3iDhVC1wsb+niwExWmMQsNgvxeqsgazJO+A/nWp1AnC9PjdXaZpI5lRVzbpuMrfmXq2tYH6jD7cxywX6Cw4UTMD6TftltDoGtX+2jrRy8HUXS0fnAhsYFCSj2v3I50OuIRj5lMoBA69QOLxytRjp+smOkE6edLoQ0TYdCjmPlxt5Y3soNM0ZYlRSrrkVkk8ydTjpaw3LOQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


>>
>> (as raised elsewhere, staring with shmem support avoid the page table problem)
>>
> 

Also forgot to add here, I will look into this before PUD anon THPs first.



