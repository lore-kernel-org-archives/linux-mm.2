Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CF409D609A2
	for <linux-mm@archiver.kernel.org>; Tue, 16 Dec 2025 15:06:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 23FB66B0005; Tue, 16 Dec 2025 10:06:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1C2DB6B0089; Tue, 16 Dec 2025 10:06:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0CFAB6B008A; Tue, 16 Dec 2025 10:06:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id F2B106B0005
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 10:06:08 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7C8B51406BE
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 15:06:08 +0000 (UTC)
X-FDA: 84225659616.08.3F2D5DA
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	by imf13.hostedemail.com (Postfix) with ESMTP id 6D71A20019
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 15:06:06 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=FIO2oyvD;
	spf=pass (imf13.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.50 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765897566; a=rsa-sha256;
	cv=none;
	b=n1ZLYgiaJQ7s1XcFOdCCUg9IxBzTgMDp4Vg9mnWuFV50DrwVC3AWgjdn4ZNP5NThJo9lt+
	5eZV7EqsO9/3KQ9QSvMl38MWJ++xJOh1W6WNzZjNIQ6F9dc9o5q4lAKwHi+SUca3TWpXRH
	lEqk9O7WraMl6meDwFDHk8aWP3zC138=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=FIO2oyvD;
	spf=pass (imf13.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.50 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765897566;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Lh659XfoCeAo+KdUpmqDXFPgGNRaeAKTqTT67lATSrY=;
	b=ft694R5zB/ZtIukeu9tc+g993VwwbSzy8kDCJKnyn/BLK1Or4VzlOBOwLlzSKFOVf6u/uv
	BSc/+h6gerlYU+WMQvyPm10TPZRxBYndnjIslOq2+g+8rYglBBTRAYDhdOIK9W/ibLKWCm
	DPiZmdxG1sQ9GZc/Ls+rQOWrKueaNFk=
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-6492e7891d2so6415409a12.2
        for <linux-mm@kvack.org>; Tue, 16 Dec 2025 07:06:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1765897565; x=1766502365; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Lh659XfoCeAo+KdUpmqDXFPgGNRaeAKTqTT67lATSrY=;
        b=FIO2oyvDnM6mx5kAoSEAWtrxBJhdpc43gBT0ZF8exO/AQjKI6AHjErXLH5aPFTB/7H
         b9TGBjwpaqlTu+DjUllpjDO6dkqSlkF5Kl4Ih9Ky07zRtTJGLMlCIVWkep2scTmOXE2n
         BxId1Lnt1ts9izmCra0xCKpqLYQAUsI6WGoNmaW8DqwLpm7n/aiSHGezAL42BIGrNpfS
         C+cnMVWnvLrKRrZDCov8D54dNR1MqbufF/9gCw5BwTNA7eDMJ4tDOUqhgWy0KC5sCRoD
         VL7hrIp7PcgMw+ohjoIIi6z2KPp56Q06ym643J0bW71K9mMw2ob3LzrCZv+ZYnzPuwLr
         BQ1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765897565; x=1766502365;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Lh659XfoCeAo+KdUpmqDXFPgGNRaeAKTqTT67lATSrY=;
        b=sjFrWNj9tiB2ipUUmNhRAod2BiLRbxe0TutsngV5miBbNdkOWUesVjgmZZ6cJAS00j
         omSnnUs/k9nzD/AV+UUKRoJ1g1B5WWwhS2b/pUQwWWBQ38iwsjBYVSRZENeg7iiQhEYm
         TcyX9A9iiX61jwDyLkCspMuz4FWRQ/4b6E7O8KI7CrVBW7BLiB3Pa5ahuZLD+fJJQYlL
         49yED7B12wKOHvM+TtMBSQNYlYTd8Sf/asi/O6CamVTPoVA8Jt65dkHJ1htk6GvQBPSL
         yzxgq13096F30ltUL1eqvUAeQhlsF2B8NT/VKR6B/MCjjzkaFuad205ux5TkYfuXmtRb
         IMlA==
X-Forwarded-Encrypted: i=1; AJvYcCXrloNpJK1I5uzHDf+mQRvQNoJPnly+TNA7ffLdAaGy2owRcwaSlsfQqr7fU1jB+K9eSbnbiTDncw==@kvack.org
X-Gm-Message-State: AOJu0Yw/xSqcsqAo+pvXPGTOV7BN9sGfUXySTLmDOrtcfleVZlbRz3SN
	dDQkaspr4TQ80MQrwn15M4nkiWJj6+/EYN14Ry46jnXAlaabKpTmPbDl/P1ypzJjvI3LN2pvqnV
	wTI3cGV+WOzRSVf+ewZc9kkcxtJoGVGkCmIOZ4eKa7w==
X-Gm-Gg: AY/fxX4MJQtjtY+KVL25Wid93lApTUKPxFmSTTl7RAMBThXP2wcgaYQ8nVB+TfkeMrL
	mPEqMcRPBc6R7uRe5x4H++Di12+sdj0Mfwse7Xz2G4LZ/H7OgYxz0gk/Pp+4G9K4qnKtIZT80zk
	8u84UZgTFPknDIOQmRuwy/wVu8KPsXu4j5GTrBN603iVjhA25vSUBqvHy7gcAbJ9mWi9EJMXUo4
	tvUSwlH1h5PAUhvNzd4oMrxDp7Rr5LaoQSJI9W5EBFdHZx6qNruS3YEdSXNLAv04YFTOXgrq2vM
	7UwvO8qm5PNKwybaz75W+TzILuNcevlPBgs=
X-Google-Smtp-Source: AGHT+IF7Gcyw0dR/Mj5s3q1xjJTEdfwQeE3CY9pghDlV87292o4JU329+ZkzRMnXcaagEpzUe2UzPtSwp27MoAuofdw=
X-Received: by 2002:a05:6402:3493:b0:649:815e:3f9b with SMTP id
 4fb4d7f45d1cf-6499b15f4abmr14450484a12.3.1765897564682; Tue, 16 Dec 2025
 07:06:04 -0800 (PST)
MIME-Version: 1.0
References: <20251216084913.86342-1-epetron@amazon.de> <aUFJH9xzJXYOt_X8@kernel.org>
In-Reply-To: <aUFJH9xzJXYOt_X8@kernel.org>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Tue, 16 Dec 2025 10:05:27 -0500
X-Gm-Features: AQt7F2rLiLltujK01JjqfmvwLUCS-mIQBP1haAEc57IK1JW5hrZ7L2WDIqYN0GM
Message-ID: <CA+CK2bDGvgcGJijAtSSa2k_FWjnZXm2jRiFd6Z9-XjEQ-Y68DQ@mail.gmail.com>
Subject: Re: [PATCH] kho: add support for deferred struct page init
To: Mike Rapoport <rppt@kernel.org>
Cc: Evangelos Petrongonas <epetron@amazon.de>, Pratyush Yadav <pratyush@kernel.org>, 
	Alexander Graf <graf@amazon.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Jason Miu <jasonmiu@google.com>, linux-kernel@vger.kernel.org, 
	kexec@lists.infradead.org, linux-mm@kvack.org, nh-open-source@amazon.com
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Queue-Id: 6D71A20019
X-Rspamd-Server: rspam04
X-Stat-Signature: uy8i5o9dgpqezuknumkeqodt49r4pq37
X-HE-Tag: 1765897566-170359
X-HE-Meta: U2FsdGVkX1+7lNAYJbmhz8mjBQPP/FDNWpTcqI58gSmreMyGQIpWlYqNFrP5WP/BgUrx1DgkWpGD5PNPC0ai3GXr4z8qBjnEJ7sg+SlnkAnV3OtTmwVrXVlwz0bWQX0KeSaKVQoVah8ihYPbVgDXt4Is5nyGsMooPtXiQQf4HVu5Bq0Tq6oxvMKOUj2NnApGSja5w1ktvys5yd/aOGeZwnG6q4mxFZHKHw8lB8FElvYCZTMvMuteXa/y807fQXLMHRyIyf6KrPFHS2VIK9BtDxtquAfEsUTidOJsuf9RMMKLn+YANc5OCDu+U2+EVXP31izp0ahakpdOcAN4TfEaNsawHkRbAMRQ5FapAZik0RezmnwOnDVpABn5CKy3A2joZrYcJh2s+nNHexu9e79EVtpDmrrehKKRsXBIoqlo+wZP38mBydwfZiYfFc+S+9CXV74Tj7t3rZTXXVrTfD5hbqTX/T31NnWyzrYV2DqHEup32p5IodbTtgWo9LrfcwUDGnz3uQnGr1G+tMQG6YmAIRgq2aP7Cx27A17TN6BzOZV5w/sKemenmGRi6K7IuZWU/nlVUOJiL9s3bcPu6tC+RzC06z+NJ7axpmWW9gP9iCUjVRo4TEvUvHVVZWVlEuy/ml0inhAiuTM+81GlDjCHRA0CIkD3IKMH6/417p1fD0g8MglfqxhF6Q06NDFW2dyEKrCcu5CwieB+5IaGNSPaKn/7fbjQJ+tgyERwIhslUrRufhxr9UmcT2hnNxoYvhOvLNXwPJTeA8eUQU9Lfp2cczXwvUUeJsp6QCJtP2eLoY5JbBEg239mckBAGmCO7UR5O/XwI+xqW+ZpdBK5UMCWn0pCUm+QRzgCzj7PU7ec2zawQnBHEPi9Bcr5x1hvBxYXSib38P+S+mxf7KT0VNvbVOWEUaOT9FmoDh/6pJwx39tD/HAkeprKnhKaiKrDTBDyQHaaP70PlB4phsY20uC
 9LEJhTHR
 WqIMck1VYIHd6Q8FzN+XQroq0kPN4VUz6UrSqhQUkb8wgXmR0K1ySs4aI7vH2LFB5RanOODYyohs/Zfg3N8nb9NG4q4R09FVCsP2NqqRbl0X8qh75APo1FdXYyGyiDuJUmon7mVph3YMwjVYOk48fIyUc7OjNsj1wA9njC8+UT5BdY3l4b/TTzslu8ds64GLW8orAuXcexKTn/ZS56Fa6N/j31FIumaEhXXB9s3rh8G1AZGPyKWdo7LAmmOO6DGTNq0anQus1e4SjU0hIyfsrSm+fBtwEQBPc68KJo1OzZlQN2iA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> > +static struct page *__init kho_get_preserved_page(phys_addr_t phys,
> > +                                               unsigned int order)
> > +{
> > +     unsigned long pfn = PHYS_PFN(phys);
> > +     int nid = early_pfn_to_nid(pfn);
> > +
> > +     for (int i = 0; i < (1 << order); i++)
> > +             init_deferred_page(pfn + i, nid);
>
> This will skip pages below node->first_deferred_pfn, we need to use
> __init_page_from_nid() here.

Mike, but those struct pages should be initialized early anyway. If
they are not yet initialized we have a problem, as they are going to
be re-initialized later.

>
> > +
> > +     return pfn_to_page(pfn);
> > +}
> > +
> >  static void __init deserialize_bitmap(unsigned int order,
> >                                     struct khoser_mem_bitmap_ptr *elm)
> >  {
> > @@ -449,7 +466,7 @@ static void __init deserialize_bitmap(unsigned int order,
> >               int sz = 1 << (order + PAGE_SHIFT);
> >               phys_addr_t phys =
> >                       elm->phys_start + (bit << (order + PAGE_SHIFT));
> > -             struct page *page = phys_to_page(phys);
> > +             struct page *page = kho_get_preserved_page(phys, order);
>
> I think it's better to initialize deferred struct pages later in
> kho_restore_page. deserialize_bitmap() runs before SMP and it already does

The KHO memory should still be accessible early in boot, right?

> heavy lifting of memblock_reserve()s. Delaying struct page initialization
> until restore makes it at least run in parallel with other initialization
> tasks.
>
> I started to work on this just before plumbers and I have something
> untested here:
>
> https://git.kernel.org/pub/scm/linux/kernel/git/rppt/linux.git/log/?h=kho/deferred-page/v0.1
>
> >               union kho_page_info info;
> >
> >               memblock_reserve(phys, sz);
> > --
> > 2.43.0
> >
> >
> >
> >
> > Amazon Web Services Development Center Germany GmbH
> > Tamara-Danz-Str. 13
> > 10243 Berlin
> > Geschaeftsfuehrung: Christof Hellmis, Andreas Stieger
> > Eingetragen am Amtsgericht Charlottenburg unter HRB 257764 B
> > Sitz: Berlin
> > Ust-ID: DE 365 538 597
> >
>
> --
> Sincerely yours,
> Mike.

