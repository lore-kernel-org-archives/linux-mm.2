Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9F599CD3427
	for <linux-mm@archiver.kernel.org>; Mon,  4 May 2026 16:49:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D19776B0088; Mon,  4 May 2026 12:49:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CCB046B008A; Mon,  4 May 2026 12:49:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BE1DC6B008C; Mon,  4 May 2026 12:49:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id ACF566B0088
	for <linux-mm@kvack.org>; Mon,  4 May 2026 12:49:32 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 58A278992B
	for <linux-mm@kvack.org>; Mon,  4 May 2026 16:49:32 +0000 (UTC)
X-FDA: 84730323384.15.461028D
Received: from mx.fmap.me (fmap.me [51.75.121.85])
	by imf03.hostedemail.com (Postfix) with ESMTP id 75C852000E
	for <linux-mm@kvack.org>; Mon,  4 May 2026 16:49:30 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=fmap.me header.s=mail header.b=J0GuFscf;
	spf=pass (imf03.hostedemail.com: domain of ab@fmap.me designates 51.75.121.85 as permitted sender) smtp.mailfrom=ab@fmap.me;
	dmarc=pass (policy=reject) header.from=fmap.me
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777913370;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=stYj82WGH8bA5rmt9vqvvbBBjdMNd6riTWEwiJA6O3M=;
	b=LCLg/JfNS1DsxwlgMBgeH9CAZALBbZxeNID7Q4qzsPT5kMT5JMXbzK9e9ywyPrGSWWVII/
	qd1t5tRwV2Yu4lAXJqd0psoHmwWjrIALsxQB8X9Pnaxtj++1eZLb0nNRHqoJ5lotBlTQfL
	c8e9/wF+ZjUBZ01qVfcpmbg+EwILoNI=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=fmap.me header.s=mail header.b=J0GuFscf;
	spf=pass (imf03.hostedemail.com: domain of ab@fmap.me designates 51.75.121.85 as permitted sender) smtp.mailfrom=ab@fmap.me;
	dmarc=pass (policy=reject) header.from=fmap.me
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777913370; a=rsa-sha256;
	cv=none;
	b=LmjdkPFw81n0Tve8CmxTy8o4t7HWmWh/wdI3M0EuH/SKvVanTdlX6OTY7iKf5a0d6O67Bd
	xQEH9keJY+8BSgw49F0vIqG8vxzCV/YdnzXT+TU0xMPp2w1HARdmwcDaRVC/G+n8W4ddyQ
	zBUSP9QOrWVmizItiYRNJFPgNTV+0Tg=
Message-ID: <9fe5ff50-4c1c-49ee-a8c2-4cacc3c6781d@fmap.me>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fmap.me; s=mail;
	t=1777913368;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=stYj82WGH8bA5rmt9vqvvbBBjdMNd6riTWEwiJA6O3M=;
	b=J0GuFscfOWbUw9bnmsn0vb0yp46l/jaXBHbfblwsfGETOx9KsUAS+9dVuNSPPwfic4gTy8
	NUss1G0pMNHHXtFe5ObhaUBF1zsTNKPlmAyil/sQaNWpjy5J+4Pvkr+K1Wmmpcr3ElRXEx
	r6FXlweKKruMbGkoTh2BELs1/bOkXJs=
Date: Mon, 4 May 2026 23:49:22 +0700
MIME-Version: 1.0
Subject: Re: [fuse-devel] Debugging a stale kernel cache during file growth
To: Miklos Szeredi <miklos@szeredi.hu>, Matthew Wilcox <willy@infradead.org>
Cc: fuse-devel@lists.sourceforge.net,
 linux-fsdevel <linux-fsdevel@vger.kernel.org>,
 Amir Goldstein <amir73il@gmail.com>, fuse-devel@lists.linux.dev,
 linux-mm <linux-mm@kvack.org>
References: <898a4e10-6193-4671-b3b1-7c7bc562a671@fmap.me>
 <CAOQ4uxjoS-PvnZ2poh0bx0C6ocTYwuEpfV0q5md15SjS620OMg@mail.gmail.com>
 <CAJfpegvxF7F+XKFKokSH4eOgCA0V2RNm6B54MS9nr9wG=U66OA@mail.gmail.com>
 <59ab54f6-680e-456e-91f4-0a26889844ef@fmap.me>
 <aeFuarTL7xBbut0F@casper.infradead.org>
 <CAJfpegtAeyMRENdneJkJrMKu8Uwnyk9LYBThjvTrFjHmPr6O_g@mail.gmail.com>
Content-Language: en-US
From: Nikolay Amiantov <ab@fmap.me>
In-Reply-To: <CAJfpegtAeyMRENdneJkJrMKu8Uwnyk9LYBThjvTrFjHmPr6O_g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 87iu7yzboktxfykuu35o1m4hnuwb1jw8
X-Rspamd-Queue-Id: 75C852000E
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1777913370-586866
X-HE-Meta: U2FsdGVkX1/ANmq7c8r8cnWPrOJCJCfC7XObh9IQerqMUlYSu0/Lth5zFtFtmR0TPnxZ+uPuKI+M8PEpUqp7CLQvIpsidrJFkOxwEMszdz77dwZdmDN2cZ8GtSDU6hiZdwF6aGsf+Ukn9zrHL3u9q2Ppkt5nPqhbIuSJDDXR4wkLEIgsKhYNtv83wRNqxsAtxhdg2VQ+fn77LeZZ/8zZ/FBsd0Pc4xO1+leiA3CZFFe2vgQIwQ2UPIvTyrHvsTsTX3ZUEP68PwkyJ6n5SLCb2gYXxQ+Hljs9YZRTJVwpmxalcIOf0lRkSLnYrRrFWHQg/923cLggVMUGQsG6n1kcymNOimdgm15Hdhi2GOQ9ZmbWdbo9P9HoVHp0E2gW8ApXNVMXW5wI4lj3jUogWdoOshWNRMJpiziT2ONWkEe2EMZceS5WJNRQ2MZ7HzLj2f4ICP/YVQ5jDhC+A65EhybBmH/Lh46XIJH8Zc1meYIUgB2IqVZiwOePtRhxX6iol9o4suDdM6qqokhxIDFzyjrim+Ej0yEuVhJTjvzdSi/lqXYMNfZtTV5lGPUr+56m4sz02+Zu9zixyfQBa20cSPozfcpCv2fg+u45vnrXs68We4m1Go6iWEAwvM7INDPUqZw6LKCGQCKJbnsaVF01PiTldEuaHig3aoY3vz2BetfgAYaHf7OmkTT3BesrYpzwwYBiEay1O+LhF4lv60BJgPO9ZH53NKcfn0l0wewqf55NA1KUOpKSce2mzQYWEj2/pzufywkiz0vdfHFTofSUHVn0ENzSeM++25UHjNXqS1LafWQrjmgNGTwLU1H965In2wcwsB+DMFUz5f2L/PVUCI9TvA0XFbG+vABibQTh2uxmCr6kn966DOJ2pLxLRY9G4oqvjaDRnfSEMGF5xMF0poLoz+H1Pbh2z954/mChmDxv9hxz14Vumnc6O52GO/hzdw/5JT020nnDUvqza9zX5Nw
 H+YbtAs3
 Y+20dZ96M4zY105XKKORFPCCtYTEKGsPapu4vr4fIxTwh5PTJaZA53BrPZglAf/2kiixBYxINwlLRrfS0nhTGd6PV56gf5AJFjJkyBSmpMDvHaRgF9eBpxQVNFj9wV3T5DaCV4mIF44eVO4pNz1tBJbLrZd7lB36pznvhvtcYz5Fg1nA2UdXMQos7fr5cO5oAs8vKC4ZXRNczZso4/hLLxNL/7IXkjFfYA/bk/Le6Hw0dmh8pesKVdFGBRuLR3fgtSYM5IV72bG1DpY4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Kindly bringing this discussion up.

On 4/17/26 20:48, Miklos Szeredi wrote:
> Should that code check for a truncated page and retry?

If I understand you correctly, this can be accomplished with a new page 
flag because there's no other way to find out the truncation happened; 
would you say this is the right way forward?

Sadly I didn't have time to try and make a PoC fix yet, but I want to 
try tackle it this weekend; meanwhile, any guidance is appreciated!

Thanks,
Nikolay.


