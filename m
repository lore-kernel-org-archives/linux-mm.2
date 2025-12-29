Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F3A9CE92FD7
	for <linux-mm@archiver.kernel.org>; Mon, 29 Dec 2025 21:03:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 625E56B0088; Mon, 29 Dec 2025 16:03:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5D3996B0089; Mon, 29 Dec 2025 16:03:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4E09A6B008A; Mon, 29 Dec 2025 16:03:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 402AC6B0088
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 16:03:38 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id ECAA3160951
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 21:03:37 +0000 (UTC)
X-FDA: 84273734874.03.6E5E9EF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 3772A4000D
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 21:03:36 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gcteyj3A;
	spf=pass (imf12.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767042216; a=rsa-sha256;
	cv=none;
	b=5mfgEoatJDeu2zEw6SdJVeo3rzHm/TFAnoYbBdkIAyvOOZh+nPifAa0A55ZMDPC03F4rA+
	gynz+3UYI7LaQSkGenAWd7mHZp1EcdSNh/oZY2RDR9FHwPG/Vlr3t/rkT4eLv6/sHBXiuQ
	AwQWwHxFcBlXi+Z5pXNPPRsGhLoyXdQ=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gcteyj3A;
	spf=pass (imf12.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767042216;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rMhW+yvu6/id7BU+qbP/QMxlZM8OS62LLd4CPdduSgM=;
	b=N5j1aFSTiVwFVLghjbjcPb7fdiueCizwXaX1OsHAw3xRePeeDeFJkTf2iblc2xKm9Cl8CC
	R91IOELH5skE519+h52iNLq012vcTFad7BkDAOSM6O0LPl+epNA8Z7xjhUtVS3PSeyAEkm
	72BLzUplG06jVRNiA43Sqv2vDW4nWT0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 42B7242D96;
	Mon, 29 Dec 2025 21:03:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4CB9C4CEF7;
	Mon, 29 Dec 2025 21:03:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767042215;
	bh=St9yHtoKNuj5bzirR5MFx8mFlGV9iQWRLtL5pw8U1Rk=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=gcteyj3Aoc5PX26BhXK+qvnvHIoGLumGj7KNLWYAS9qrMZaTabT3TzDsz1qmvaNR7
	 gHgb0Vq/WkeSwQRlePt6owfLz6Tpv/cJeX0ly0fJppDzVresb9CrJpFaZUSfqd3/jD
	 +AICONZ9pdTfnghCwA1keMfK0XLuFas7tmBh1rGbXg0bT0QlePOEo2WRWkuZsTETiG
	 eKy2+Hn0Ig7lDRMr/YieSPY7P3loWFk3XmCCG8eiQWHkTpC2GwbWNzMFTQr00d0GQk
	 GRA3RAPioimWdTRIYKe3OZ63IQVNkKrhc3EdgM+ZJ7s0504aeEaST4qKerm+3nt618
	 JrUsV0mI+ZWXA==
From: Pratyush Yadav <pratyush@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Pratyush Yadav <pratyush@kernel.org>,  Mike Rapoport <rppt@kernel.org>,
  Evangelos Petrongonas <epetron@amazon.de>,  Alexander Graf
 <graf@amazon.com>,  Andrew Morton <akpm@linux-foundation.org>,  Jason Miu
 <jasonmiu@google.com>,  linux-kernel@vger.kernel.org,
  kexec@lists.infradead.org,  linux-mm@kvack.org,
  nh-open-source@amazon.com
Subject: Re: [PATCH] kho: add support for deferred struct page init
In-Reply-To: <CA+CK2bCjJWZG_rPoPsHWSxirmUCTOuFQzTCss2AKf9UqpThrdw@mail.gmail.com>
	(Pasha Tatashin's message of "Tue, 23 Dec 2025 12:37:34 -0500")
References: <20251216084913.86342-1-epetron@amazon.de>
	<aUFJH9xzJXYOt_X8@kernel.org>
	<CA+CK2bDGvgcGJijAtSSa2k_FWjnZXm2jRiFd6Z9-XjEQ-Y68DQ@mail.gmail.com>
	<aUF4fsWwD9BswkFh@kernel.org>
	<CA+CK2bB2mn5b0N9gs1UavYLUQhbpVvdo702oHZa15E9OaZkKWg@mail.gmail.com>
	<aUUYprAotKYMiEs0@kernel.org>
	<CA+CK2bD101cSC_7+OWkMei2QvUVjSaRLy+LboLe8Sz7KS3by4g@mail.gmail.com>
	<861pkpkffh.fsf@kernel.org>
	<CA+CK2bA1kYCf0BwhX3Sg9Ur82nK-7HPzs0sg6xbVWFAJaZLhpw@mail.gmail.com>
	<86jyyecyzh.fsf@kernel.org>
	<CA+CK2bDxnTEe9Ohq5zLuyF-jqgD0DPhfdq6z=yztUsXU5p5fSQ@mail.gmail.com>
	<863452cwns.fsf@kernel.org>
	<CA+CK2bCjJWZG_rPoPsHWSxirmUCTOuFQzTCss2AKf9UqpThrdw@mail.gmail.com>
Date: Mon, 29 Dec 2025 22:03:29 +0100
Message-ID: <864ip99f1a.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspam-User: 
X-Rspamd-Queue-Id: 3772A4000D
X-Rspamd-Server: rspam04
X-Stat-Signature: yf3rqubkdkxm8chb7narr9cnygwpa1z9
X-HE-Tag: 1767042216-195586
X-HE-Meta: U2FsdGVkX1+81zFKSqDUnF43TnwcKwyiVXiPun1VYkybhmTnntRyp3fdFAacM4PQECEQwfP62UkO2AQamsOboK1Dr+sisxvbhqd2Gp/UPRl9jbtR2ITxxErMi0NryF6mdaaEBa/BWH1WtHfi2oXRdnoQf/dRneeANlQFMVLyvj6xYinayK1AS7w2+QR/vlCV7U0/xuhnFzMRs2nHsNyVPlzFulhOz/KROlSbzKUdGAF4MztWmjS5is+wpzL/umJdiRI6+x8upoccVO7LYc0o3UeTeO3lQBW8ZXpLM9ziTGkeNRKyzLSaj2FORawEPeoY2Lw29LV766hEmbsCC5Tt+pxUmLeE4SAoEqwJLThdmVl/AGRkTLyWLiROkj8tb5xHJgzPfITOzcqWpPdlm6HExfmSkIH/1PxlMvkLTK58EVWftd8XJx+rSkhhsZHvSlcB0z5tW38jRzxoZYKbqoSsGO1KN/4uxkrZJ7UJt4ZwCjdMcYcMqknh4js356G5cIJzFIrAksS7JakmEWTF8othOF/LOp8uNdqxLC1YFyc50g+qYeDMLOvUdyG96U0XAohiS2i5UUNeeI5RWdQzR3DcTwK8bzdWuJpmpZrSZmISkr7YWhPF0mRTNFO25r783x5WoVbOF6b3o0KbeQYXOnRMPARXLWz+XPr+K3jZQzz6+4kABdMkBtC3mmp8m3adq/8HCEsspNgwjhU88H7qbEUSEKnhOBCn3A3/jvTbsUkOYP54nUieFJQnwMSnjvA75d8kuvc1WNSPD0Uew/el0Gjbg9SSoozsEhhc3eupUZ6Aayaq5uuprXYnDaQ/o/HBEVbycKg2QqP0qmSV1ZWNvzaXQdR2Vl5TUP3pXNvn63wmv/x4F0LTQQbPoYLJGe6rK/gjE1TWWXwDqSFcU7W8ipDKFy00XH02UjjrykNKy0hdJI7ntVijm8R28Z0mj+7s3kGvPEk+jP4PUSTqIiLOG1O
 ZPqxA9Mn
 z8d8YAuVtrIFHZtrNKXJc4rqWHRZJ/FukOc1eU7NLz67ZiCgRhfLOrls10JABa46CAgRrvEkui2mJBZO/MpfpUzFi/+m9oKC1BROklPCBt0oDajm2cfpioyMU7HDHn1G7UDwiaFtaLxxqrTenOP3bXcs4ipRnVSb+iE2TjbyjdAAXKKBk7T2zunl4iq9ZkJpr8skw
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Dec 23 2025, Pasha Tatashin wrote:

>> > if (WARN_ON_ONCE(info.magic != KHO_PAGE_MAGIC || info.order > MAX_PAGE_ORDER))
>> > return NULL;
>>
>> See my patch that drops this restriction:
>> https://lore.kernel.org/linux-mm/20251206230222.853493-2-pratyush@kernel.org/
>>
>> I think it was wrong to add it in the first place.
>
> Agree, the restriction can be removed. Indeed, it is wrong as it is
> not enforced during preservation.
>
> However, I think we are going to be in a world of pain if we allow
> preserving memory from different topologies within the same order. In
> kho_preserve_pages(), we have to check if the first and last page are
> from the same nid; if not, reduce the order by 1 and repeat until they
> are. It is just wrong to intermix different memory into the same
> order, so in addition to removing that restriction, I think we should
> implement this enforcement.

Sure, makes sense.

>
> Also, perhaps we should pass the NID in the Jason's radix tree
> together with the order. We could have a single tree that encodes both
> order and NID information in the top level, or we can have one tree
> per NID. It does not really matter to me, but that should help us with
> faster struct page initialization.

Can we use NIDs in ABI? Do they stay stable across reboots? I never
looked at how NIDs actually get assigned.

Not sure if we should target it for the initial merge of the radix tree,
but I think this is something we can try to figure out later down the
line.

>
>> >> To get the nid, you would need to call early_pfn_to_nid(). This takes a
>> >> spinlock and searches through all memblock memory regions. I don't think
>> >> it is too expensive, but it isn't free either. And all this would be
>> >> done serially. With the zone search, you at least have some room for
>> >> concurrency.
>> >>
>> >> I think either approach only makes a difference when we have a large
>> >> number of low-order preservations. If we have a handful of high-order
>> >> preservations, I suppose the overhead of nid search would be negligible.
>> >
>> > We should be targeting a situation where the vast majority of the
>> > preserved memory is HugeTLB, but I am still worried about lower order
>> > preservation efficiency for IOMMU page tables, etc.
>>
>> Yep. Plus we might get VMMs stashing some of their state in a memfd too.
>
> Yes, that is true, but hopefully those are tiny compared to everything else.
>
>> >> Long term, I think we should hook this into page_alloc_init_late() so
>> >> that all the KHO pages also get initalized along with all the other
>> >> pages. This will result in better integration of KHO with rest of MM
>> >> init, and also have more consistent page restore performance.
>> >
>> > But we keep KHO as reserved memory, and hooking it up into
>> > page_alloc_init_late() would make it very different, since that memory
>> > is part of the buddy allocator memory...
>>
>> The idea I have is to have a separate call in page_alloc_init_late()
>> that initalizes KHO pages. It would traverse the radix tree (probably in
>> parallel by distributing the address space across multiple threads?) and
>> initialize all the pages. Then kho_restore_page() would only have to
>> double-check the magic and it can directly return the page.
>
> I kind of do not like relying on magic to decide whether to initialize
> the struct page. I would prefer to avoid this magic marker altogether:
> i.e. struct page is either initialized or not, not halfway
> initialized, etc.

The magic is purely sanity checking. It is not used to decide anything
other than to make sure this is actually a KHO page. I don't intend to
change that. My point is, if we make sure the KHO pages are properly
initialized during MM init, then restoring can actually be a very cheap
operation, where you only do the sanity checking. You can even put the
magic check behind CONFIG_KEXEC_HANDOVER_DEBUG if you want, but I think
it is useful enough to keep in production systems too.

>
> Magic is not reliable. During machine reset in many firmware
> implementations, and in every kexec reboot, memory is not zeroed. The
> kernel usually allocates vmemmap using exactly the same pages, so
> there is just too high a chance of getting magic values accidentally
> inherited from the previous boot.

I don't think that can happen. All the pages are zeroed when
initialized, which will clear the magic. We should only be setting the
magic on an initialized struct page.

>
>> Radix tree makes parallelism easier than the linked lists we have now.
>
> Agree, radix tree can absolutely help with parallelism.
>
>> >> Jason's radix tree patches will make that a bit easier to do I think.
>> >> The zone search will scale better I reckon.
>> >
>> > It could, perhaps early in boot we should reserve the radix tree, and
>> > use it as a source of truth look-ups later in boot?
>>
>> Yep. I think the radix tree should mark its own pages as preserved too
>> so they stick around later in boot.
>
> Unfortunately, this can only be done in the new kernel, not in the old
> kernel; otherwise we can end up with a recursive dependency that may
> never be satisfied.

Right. It shouldn't be too hard to do in the new kernel though. We will
walk the whole tree anyway.

-- 
Regards,
Pratyush Yadav

