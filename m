Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3AD12CCD184
	for <linux-mm@archiver.kernel.org>; Sun, 19 Oct 2025 08:00:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 510E08E001C; Sun, 19 Oct 2025 04:00:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4E8588E0002; Sun, 19 Oct 2025 04:00:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3FE408E001C; Sun, 19 Oct 2025 04:00:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2EE468E0002
	for <linux-mm@kvack.org>; Sun, 19 Oct 2025 04:00:22 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D4B9F13B422
	for <linux-mm@kvack.org>; Sun, 19 Oct 2025 08:00:21 +0000 (UTC)
X-FDA: 84014116242.12.37368E4
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	by imf24.hostedemail.com (Postfix) with ESMTP id C74F2180009
	for <linux-mm@kvack.org>; Sun, 19 Oct 2025 08:00:19 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=iI4XPXk+;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.50 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760860819;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3I2g9EOqV3eXFKExtx63puEn8xP28gnfGls4tglvgVs=;
	b=IFDwmlQdcwrrMOV62nb/5Oh9kARtKhdXR6YD9eyAuXk6gyNxqV8FFmEBERDKCit1sT4+Fe
	fBHGPnxrE9wXSE+nw7Gr+N4HNX3FCdt7Oj0UHoRJj3qS1Ztyy/mP8bszDro6f/Tg5jgDNS
	gexlzDCNQK3CF5ElVYX+xEgqFuufXDo=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=iI4XPXk+;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.50 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760860819; a=rsa-sha256;
	cv=none;
	b=qkLwyxi4+YuRPlIJ/p1ik6No4lq2Mzy5sZrxYTjALQ1MJSE/XrJa3u/qyE5uTfASwnicGC
	F/CYQ1h0JQVdXMTZ5GfEYx3oXPdWCQpLQGj66LTLoXO8WU1oMFopzVLRMGD296c0acr4bU
	F8nGHDw8E9mwVlrIj1GBHEIwi/1f5WU=
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-63c489f1e6cso2238243a12.1
        for <linux-mm@kvack.org>; Sun, 19 Oct 2025 01:00:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760860818; x=1761465618; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3I2g9EOqV3eXFKExtx63puEn8xP28gnfGls4tglvgVs=;
        b=iI4XPXk+woiExAkMIHNUiP0MzhollNe4b6ECmUIH+feXga1HJISoILIASPqAO57gZm
         C2TuG+i7K3USG5zMMqe+Us8oiWe7Hvq8g7WEwPuPXDqw8pFiLtj2IBBBfXPKwNpBgL3R
         nPpF2A045MAL5QjPf2DY5jDg53RO4wgHKw/gi0FaqLgzIHohz+L/EDAc4437/l5atSVC
         AoEQT+01AF1SLJzMUlD4JEevEMbg9c+hCuFIH/M01A8K4H1FBM8Cwb+1wv7eodGbcwwq
         gC+ADWRyja9wJhSQUD3asDC+9FWwWfg/1+ASN2DqXPuBOssWqbWuiWTz8ivwML1hEk5i
         2xqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760860818; x=1761465618;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=3I2g9EOqV3eXFKExtx63puEn8xP28gnfGls4tglvgVs=;
        b=JTe2FYH2ksCQjKbwXCATF2e9wseJGUlLoaNtDd1udhCC5/1lReDsEnl3j6Cqgtb9lB
         spXQcM7HbIeKGWrXqZGRi2Aj463HjgX2W2e8ZMlq9Xw8ay+hKYWeTfVaqvIAp4TUKmkM
         O7oPTdSiI4iCAPlG6RVmf4eFV2LAxb02/LpH8CPJ2EqiwmAWfysG3KjTH/srKRG0BIIe
         zbeXQ1aypRy33iMc29QxRVNV+jrf04K52+RN7nM2/A1DHT4fTrqGotyn+PqSbhwJtUmn
         YZ2D821Rtvg11GaM6UjmmDzCcvpkEnsHPpOkaPwSSrxDvYPKCAc9Al8BlbLZdB2CVQXI
         XymA==
X-Forwarded-Encrypted: i=1; AJvYcCUw/MnWySxtxoKk7RbzJu/Fko5TsSao4OPuubpTzpg0rl+2nWy92og1ptKIpV2B35M8fr4jk7HWUw==@kvack.org
X-Gm-Message-State: AOJu0YzRbR4bR7lOQpatc5K5V9dOcbutLI/daQlC8s7+c3sNGF1VmGv+
	OeMLcpOTM/NqFkyGrtmv858VjXx4ootStGE+Z8EiLaeSrha7dBk84aFD
X-Gm-Gg: ASbGnct8GLtq0gUiKKHFJRl8+eo6ygc7f6qNedFNx+i8cQg5ipxO6a8B/RFjkW6QrMB
	wIXaCLPZAWRkU5VwLxPkJYhr68FcNfbEgoETuD2cWyUlZ4p8ncGjp8XNYuBRP3wH2trlNCVRgTR
	yyi2MLXagSYtt2AYUPvvw/HG6fNlgAGxb8c/e58DeY6ERBvDvV5FGjl3dJTmga7KgvCK0fz0p/R
	QMgdVjxj1TAP0FxShfcWRu9CAC8zImvHzYcKXPko+q9FS1YW0JnmtohCtYYAoN05NYd6uPpYLq2
	WXUcGq521WJiIn0XLfpRW0iEi2xLkDFI3+4JrVTbykOwWmarE+loHhFxOrWI+fiZrHma8OzLM0q
	ReVhzx4upgBE+rFEIir90e9IIzvYpTbwrUrAJCOgmprSvOAg2XgOcB3nqlidfOB1PpwIRa8VooE
	Q6w7Q=
X-Google-Smtp-Source: AGHT+IEQKJALq7UfBR0TLARN7l+4hYZgdqqVSXNpKtxH1qT4P85awLDCJ07fn2O8CmlK2S54Ib6P8g==
X-Received: by 2002:a05:6402:1d03:b0:63c:1031:7c60 with SMTP id 4fb4d7f45d1cf-63c1031816amr8085796a12.19.1760860817988;
        Sun, 19 Oct 2025 01:00:17 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-63c7267319esm948765a12.36.2025.10.19.01.00.17
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 19 Oct 2025 01:00:17 -0700 (PDT)
Date: Sun, 19 Oct 2025 08:00:17 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: David Hildenbrand <david@redhat.com>, Zi Yan <ziy@nvidia.com>,
	Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
	baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
	npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
	baohua@kernel.org, lance.yang@linux.dev, linux-mm@kvack.org
Subject: Re: [Patch v2 2/2] mm/huge_memory: Optimize and simplify
 __split_unmapped_folio() logic
Message-ID: <20251019080017.oewm4744rvdtcmzx@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20251016004613.514-1-richard.weiyang@gmail.com>
 <20251016004613.514-3-richard.weiyang@gmail.com>
 <7ed84d61-0a7b-4961-82eb-fc8d38b77162@lucifer.local>
 <154924ED-0CD0-458E-B760-F9F0A92CDC89@nvidia.com>
 <d0a2c81b-a0e0-4457-b355-2363f30ecfb8@redhat.com>
 <cdd37933-d2e7-4675-82fe-62b7f0ccdd80@lucifer.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cdd37933-d2e7-4675-82fe-62b7f0ccdd80@lucifer.local>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspam-User: 
X-Rspamd-Queue-Id: C74F2180009
X-Rspamd-Server: rspam03
X-Stat-Signature: bnjxc6chfqb5udj3tz14aq85w9pyoo8r
X-HE-Tag: 1760860819-918594
X-HE-Meta: U2FsdGVkX18lGfnKBhaasm2RAbi2SfPsON4fqi+PD+R76E+zmyMseptNfog3/OChmMvk4qdwWLvUqis4CkM/c0N1hNj89uf6mFA/LunqYQ+7x56I6AKG0XWicbeuj/bjwTcAEJrx5DRnIFgti5TE/vX8hfNu6hfTJq0FmRBOui0st9VQfBEMZZZqRDOLPRay/FgwpBCLtS8JnLYZGzX8pUrPWZ5K93K1Vn+5s8Jz8/bu54z4ctZwDlokZ7pFAGzfUiCdmIA3weuFjSg+yDIGk+JD1wp/mn2LYpaNNvPqSJNssPqagP8L5TKFyVClGLJcAPY6IA9i5a1j3PoQNE5ORAzjf2F2ww5Ea5LOjUJOAzTOpICC0z0sKiSyL4nOTOM34+XYJKNSNKaZAD1maj2DZZ5lH4b9F8ea4VGqyNpdjxsxEA9HNKDUKK8w+v0xlDljHbHyBFQjqULwDqpk0acIVk2EsOQOuLV+mpHsev7MyaxnwaEcQpswHJV0qYF7Xx3OZX7kuh1PMEOrUZO4SrxNHmydbeXu8cHYHAn45kNJTtW42iKcjd87WRANzER/JBf2THcxbWI5fHYSMbxXEHkEBdYx7RhztdHmtjjUVR/1zQihq+LgdTTj+/YzYRLexXjeKJ07wUUZCPRoxikZKGOzf5goys8QpFvhXev4hQ1/pbDpIKgAFiW56DAom2gJlIr6vXjWoyoNTL6EFTBA62POnP7oU/7nxeOXScwGj9KdONGThWX2SATVeiVQmMe4+hbRJnDRDebgCjKViZClRTx7E3BfFR93HtnUg9r/skRb2lvYMf4t43je6/yhBBnn+KaWJ5GD4wSwylKEffj4aJHWPzSgEycDeotZ2QZD1eeJLW8wwQW1zWJU1p5hhoRnvlxeVgPOR6bCU0kB1aQKyFhXX7/DWGkIIFZ7FWJ58JphxSmQi3D4bMmujQBKmYfo+QR4QMkuNnGAsIaTV0TlOQd
 3tnuf1FM
 prZHfOZxyH5KLn4tiwe/N1YICaDhSrF9h0mSK9qgVc9FJQbEZirvuWJWkXIJNT6nn1MiiryumsX2HqdDVOLvVAdQFdakCS+3A+oZxI/C3x5gy0xF50deVQxRJlGbBdy9M80rj515XiPDqm+vOjyWQPN7Xz0OA8brFHza+2hKqcOyls4eUbYcs7QylOzh3hKyQ2o071BB89DkaHq2++TflnPHO7UTuXmKt5+5ZpH34ZuQNpizkLUfhoSVhI+LG45Pb+SiletrEuPhhMB9cUZACPtiEaihd32akk0HpzUbQ3zl+CtstaglJOtKEJTgvplV9+QNelpPyibqjz7rzvrtIzDaRLtm3E8oC16SwCtVw+tAvozF1cftlNkcE0B4sftr7q8aHK+XAWr1fNqkoCgtwHHw/lXJwIxWOCaqxD1QGANu+mTOEx8iFcFTzu8MwkHz6PLwBmAcBNLP1zBQLf8Tr2zQ20kSQ1dX9I5H1/44xRul7jqNqaLUr7XfsXAqvoxYTIL0mgXA9KuZMw7fD82ZD6Q0avg2+yJLpAA3xEpLhrZBRKbCCCuoIvwIr8gIGvxj4f4em5Z8J1fJu4XdlGQs5DM8BINeP/kqJGRcyvL5nmYpSesfJ0gsxokBoCU98pzPn+fE+xryZdvAkwUlO8UzS8XQRRuVDby/xfKzYPBGwTOP6onVjE7mp24eWMoMc4GlDxGrKJ6nbkW5mYgrWwaTWP8QY2siZWYByNrNU2qHIhRfeRDgK2IJdRgRG8gRkuQVD7h6NNZVDHDqnR19DO5xbukDYm7KljBKRjJ7O
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 17, 2025 at 03:55:16PM +0100, Lorenzo Stoakes wrote:
>On Fri, Oct 17, 2025 at 04:45:17PM +0200, David Hildenbrand wrote:
>> On 17.10.25 16:26, Zi Yan wrote:
>> > On 17 Oct 2025, at 5:44, Lorenzo Stoakes wrote:
>> >
>> > > On Thu, Oct 16, 2025 at 12:46:13AM +0000, Wei Yang wrote:
>> > > > Existing __split_unmapped_folio() code splits the given folio and update
>> > > > stats, but it is complicated to understand.
>> > > >
>> > > > After simplification, __split_unmapped_folio() directly calculate and
>> > > > update the folio statistics upon a successful split:
>> > > >
>> > > > * All resulting folios are @split_order.
>> > > >
>> > > > * The number of new folios are calculated directly from @old_order
>> > > >    and @split_order.
>> > > >
>> > > > * The folio for the next split is identified as the one containing
>> > > >    @split_at.
>> > > >
>> > > > * An xas_try_split() error is returned directly without worrying
>> > > >    about stats updates.
>> > >
>> > > You seem to be doing two things at once, a big refactoring where you move stuff
>> > > about AND changing functionality.
>> >
>> > No function change is done in this patchset. The wording might be
>> > confusing here, it should be read like:
>> >
>> > After simplification, __split_unmapped_folio() directly calculate and
>> > update the folio statistics upon a successful split, so An xas_try_split()
>> > error is returned directly without worrying about stats updates.
>> >
>> > David suggested a change[1] to make it clear:
>> > Stats fixup is no longer needed for an xas_try_split() error,
>> > since we now update the stats only after a successful split.
>> >
>> >
>> > [1] https://lore.kernel.org/linux-mm/518dedb8-d379-47c3-a4c1-f4afc789f1b4@redhat.com/
>> >
>> > >
>> > > Can we split this out please? It makes review so much harder.
>> >
>> > I asked Wei to use a single patch for this change, since the original
>> > code was complicated due to the initial implementation. After my
>> > recent change (first commit 6c7de9c83)[1], __split_unmmaped_folio()
>> > can be simplified like Wei did here.
>>
>> I think it was too much split, agreed.
>>
>> This patch was a bit hard for me to review, not sure if there would have
>> been a better way to split some stuff out more logically.
>>
>> Most changes just complicated way.
>>
>> Not sure if splitting out the stats update change or the calculation of the
>> number of folios could have been easily done.
>
>I mean as I said to Wei/Zi, my objection is both moving code around and
>making complicated changes that require you to really dig in to figure them
>out _at the same time_.

Is this version better for review?

http://lkml.kernel.org/r/20251014134606.22543-1-richard.weiyang@gmail.com

>
>It's perfectly feasible to send separate patches for non-functional
>changes, I've done that myself, each building on the next to make it clear
>what's going on.
>
>I'm a little surprised at the oppositon to that...
>
>But if you're convinced there's no other way this could be done (bit
>surprising as you're asking 'why this change' several times here) I guess
>I'll sit down and try to decode it.

-- 
Wei Yang
Help you, Help me

