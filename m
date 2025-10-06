Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CF96BCAC5B8
	for <linux-mm@archiver.kernel.org>; Mon,  6 Oct 2025 17:44:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E6DB08E0003; Mon,  6 Oct 2025 13:44:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E1E2D8E0002; Mon,  6 Oct 2025 13:44:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D5B738E0003; Mon,  6 Oct 2025 13:44:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id C79FD8E0002
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 13:44:16 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 60F9487CE1
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 17:44:16 +0000 (UTC)
X-FDA: 83968413312.21.863D727
Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	by imf15.hostedemail.com (Postfix) with ESMTP id 67067A000A
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 17:44:14 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ZxqVh7It;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf15.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759772654; a=rsa-sha256;
	cv=none;
	b=bHk3jyKMAZt7H7Yl6P1AAS++0KLqJ3V10EIOMNlNRrqubYxALOprU22vXiQKeRQu+Ofb/K
	TDz6M3Bp8nWo+9jWdWQ4gON1qoK7BpGqfom19SIfVR/yC685I9sQAakStB7e7EegBk54wS
	0ztK5ld5Ji+sc2CseKLznTqEQqRpP3E=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ZxqVh7It;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf15.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759772654;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QcosD5rlzA4TE7AntBZPfeAW0/FnSxIJ3VMLbX62WUE=;
	b=ITGnlPx8SU27r5vWLIH8e8+z+hN1KeWvCabdFji0MAR/q0S/Q9oVo8OxTIom2o/RepkEyQ
	Fd5ulfI6g/qlmcFe4MuvmmibfK8Ul852EJNMKl6DxhyXWnB7RSZRwZc/PngCSfpNBpaAxV
	JT4rjovJ/EATuN83jl6wtjUflnIGyGM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1759772652;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=QcosD5rlzA4TE7AntBZPfeAW0/FnSxIJ3VMLbX62WUE=;
	b=ZxqVh7ItL0Tel/7B30RzqqAsLAe9Tay1fWGS1l5VTeYoHM2MLnWp5pZaEFzgsOB+TSCK1s
	Ny80HiVfF9LMmEhag8nyFNiq/lRp0oFmHHyA4xV+enn3M8SmbIoUmrZ1ni8B3iabRROqIu
	1TW2ECx5W1zO0B8tZwGI3KQxozwH1cw=
From: Roman Gushchin <roman.gushchin@linux.dev>
To: Jan Kara <jack@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>,
  linux-kernel@vger.kernel.org,  "Matthew Wilcox (Oracle)"
 <willy@infradead.org>,  Dev Jain <dev.jain@arm.com>,  linux-mm@kvack.org
Subject: Re: [PATCH v2] mm: readahead: make thp readahead conditional to
 mmap_miss logic
In-Reply-To: <e2zblaknfnzjtlo3df4aozoxuir6zgnycdjj4ywbu7rsnpw6hr@ocemkpucjd2d>
	(Jan Kara's message of "Mon, 6 Oct 2025 14:31:06 +0200")
References: <20251006015409.342697-1-roman.gushchin@linux.dev>
	<e2zblaknfnzjtlo3df4aozoxuir6zgnycdjj4ywbu7rsnpw6hr@ocemkpucjd2d>
Date: Mon, 06 Oct 2025 10:44:07 -0700
Message-ID: <87qzvg6i3c.fsf@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: 4iri74zyp834s8j8q74q75tbf7df6mrd
X-Rspamd-Queue-Id: 67067A000A
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1759772654-516648
X-HE-Meta: U2FsdGVkX1+o9sI5qRRGY0e3n1WHYFt+t6yN360CfTTrnbBEAqaJcU1ZGHp6vlEeYbI5WnoPZU7xDtwrl8L2FOfjucPi3kRuYRiOhjWG/PdXKavSW2u1f/nFGEIX5y9SloVUDCYkH0hD5Do5I9eJGOEJMwBcOiZGpnMMSGUKL7fOcFDh/5bYEl4sOw1+7bfYSIUr0MS/fGeKRE333CXifo/BeX5wO+aGFjHVX5DymB/12o/YbZt2X57kUy22X4KbiC9RybkdzIopcRsk8wwtm4YXZaEFcsU8ReoIyvjpe0TrwTRI6NBndWXq4BDBpBk2fC94ktE9tgSTaCVdsOsqlmwgpvngVGxSJPCfigpJyUMXXvQW/esfQyi0QrgEtXtdHclpJzKbXpT95ha+ItAgQAarJfUjRUufybau9h3Pf3hspJ6kAMfi6PPEagugBhEtbKku8HmIpwE9FiulsyUrKC6zZXojIpwEAA12DFdWRla3YlXwMxFxQcAKii1lng0piPG1zA2e/JtxjTzl71U3a8YLpc30nhaffE8zNVhbD/03TMh9MFGpb315iLD8PPDLzLqJeY38kYHIFxatUTeeaWTqc0NfYjdgMRUJsDiZjS2k9u8o9ai891ijuqyjh3+a92nBoQES8S73V9O3GCGSIH25RAMtM9MFBx8GBU7ewEG6AecYYsaW9UyKcfrXkDZqWJokwW6iQYRyiLRs61r6QQq/B0utwNnc6JplHSf66FfN0L+Y8zmtXwpTHK99ZGnq4mnakrGQR/nSyUmGhrMcA0/P7J3Qlw0xMuTAyY1uxK+ffmbmYfNpKSb2t7VVMyS5idToqGOB1YH4dWjtOCNWWdWs0L4NDVXrzHyxQ9+sUaf/6Tv76Kq9upcIljtFjB45c65/9pg82RFW5jT1EkXWaCL0kkmlID5//J3XCATBxMnauOaqgh/ePfADq0ICEE2j+/HMYz9LH38ksDfJlQW
 g4r5LYYo
 JGvZw6t1iL2IKR2v0XJ4rxm7iDPf3JQ6v2Esq8vy3TBNZ1SuNXXyCq8eMGgiIpkT7RugTQw7fOJAza6UCj+h7w8OO/Y6UFkxDRpOak8Ks7N7u4VewIfqf21PjU9XoxEPp3RtblIJgu7DH0kQ4ARZSPV4nWzKkK8CS1scsXFAeaZ83LhKsYIvnFh0qz0BvjamWJH72soc92bohnE7M24TCpO1xhmG2vk3y3t2ZOn+6nFkuaFg1X1ynyJC700qhBDF01wtvG+SY7PceqnBaifUZb/+SuxYP4f00i11M8UKrxFG/1josneBvsqvZLRp4JGfzm4ZlIHBFKvTr7SRwQzNICii6epOsbkHlFFlfyr+s/bV+nnG6Blf4UjX3SEC9Jw/U2lHF
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Jan Kara <jack@suse.cz> writes:

> On Sun 05-10-25 18:54:09, Roman Gushchin wrote:
>> Commit 4687fdbb805a ("mm/filemap: Support VM_HUGEPAGE for file mappings")
>> introduced a special handling for VM_HUGEPAGE mappings: even if the
>> readahead is disabled, 1 or 2 HPAGE_PMD_ORDER pages are
>> allocated.
>> 
>> This change causes a significant regression for containers with a
>> tight memory.max limit, if VM_HUGEPAGE is widely used. Prior to this
>> commit, mmap_miss logic would eventually lead to the readahead
>> disablement, effectively reducing the memory pressure in the
>> cgroup. With this change the kernel is trying to allocate 1-2 huge
>> pages for each fault, no matter if these pages are used or not
>> before being evicted, increasing the memory pressure multi-fold.
>> 
>> To fix the regression, let's make the new VM_HUGEPAGE conditional
>> to the mmap_miss check, but keep independent from the ra->ra_pages.
>> This way the main intention of commit 4687fdbb805a ("mm/filemap:
>> Support VM_HUGEPAGE for file mappings") stays intact, but the
>> regression is resolved.
>> 
>> The logic behind this changes is simple: even if a user explicitly
>> requests using huge pages to back the file mapping (using VM_HUGEPAGE
>> flag), under a very strong memory pressure it's better to fall back
>> to ordinary pages.
>> 
>> Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
>> Reviewed-by: Jan Kara <jack@suse.cz>
>> Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
>> Cc: Dev Jain <dev.jain@arm.com>
>> Cc: linux-mm@kvack.org
>> 
>> --
>> 
>> v2: fixed VM_SEQ_READ handling (by Dev Jain)
>
> OK, but now we'll do mmap_miss detection and bail-out even for VM_SEQ_READ
> | VM_HUGEPAGE vmas. And without VM_HUGEPAGE we won't do it which is really
> odd. So I think you want to make the whole mmap_miss logic conditional on
> !VM_SEQ_READ...

Yeah, agree, good point.

Thanks!

