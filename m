Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 30FCCD4336E
	for <linux-mm@archiver.kernel.org>; Fri, 12 Dec 2025 06:47:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 57BF06B0005; Fri, 12 Dec 2025 01:47:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 52D5E6B0006; Fri, 12 Dec 2025 01:47:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 442A06B0007; Fri, 12 Dec 2025 01:47:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 33E5B6B0005
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 01:47:10 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A919A1604B1
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 06:47:09 +0000 (UTC)
X-FDA: 84209886978.18.69E63D1
Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	by imf14.hostedemail.com (Postfix) with ESMTP id B906E100005
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 06:47:07 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=B+XC21ml;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf14.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765522028; a=rsa-sha256;
	cv=none;
	b=eSqIyts4/Nd6oGEi+W8g84mZrQxOBvtyyXU2GH5VkUNygJQzVPIDyWrADrdPIkCUkZE+83
	7zFa7OHZvzAxbwKgbkKZzGeeHEoCj1bUPzFXVF/9ke4Fri50Ruc4L3xvQxPJCCk/rdI3qn
	wjCU5eCC+6ikEXBXsu16ovsmtt4KBmw=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=B+XC21ml;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf14.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765522028;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qLUft9+c7O2zPq9tN76DdeBfT+fs7dXB/08o8SAMub4=;
	b=HlqW82hqiws72AUNIg6+y6BPqM3lxnaYNmrn7uusWaiEkVxoiVs1qMh95OSleIy8nQR6va
	O5bVzbogJAkSy/i7NJ9WmlgTmel5tN4Hc/DXeHn6Emh3ub5+GN8rMflutHJUjmQocSS+d+
	6BWXD+EVW77XW43POiYqfr/CQGaAWhM=
Content-Type: text/plain;
	charset=utf-8
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1765522025;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qLUft9+c7O2zPq9tN76DdeBfT+fs7dXB/08o8SAMub4=;
	b=B+XC21mlZA3Ao1b7UuoXohJSHGGu1NifIskULhjfBIe7T5R8K3CnirKzhW/3VqpzHT3JnA
	CTqOeSY1aFOg/uhT6ThdQ80x/CvebeIykqf5+s0EVh2+N3foEhJkbXCRj/vZspPffHHESb
	kPvzz346KGVc7iCWWtWEuOssKKQgQ+E=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.200.81.1.6\))
Subject: Re: [PATCH 00/11] mm/hugetlb: Eliminate fake head pages from vmemmap
 optimization
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <5twlonzi3rooao7gyp5g4tyaeevemcx6qhuf4xvdtsi2cykuo4@wrhxmxz63wvn>
Date: Fri, 12 Dec 2025 14:45:42 +0800
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 Oscar Salvador <osalvador@suse.de>,
 Mike Rapoport <rppt@kernel.org>,
 Vlastimil Babka <vbabka@suse.cz>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Matthew Wilcox <willy@infradead.org>,
 Zi Yan <ziy@nvidia.com>,
 Baoquan He <bhe@redhat.com>,
 Michal Hocko <mhocko@suse.com>,
 Johannes Weiner <hannes@cmpxchg.org>,
 Jonathan Corbet <corbet@lwn.net>,
 Usama Arif <usamaarif642@gmail.com>,
 kernel-team@meta.com,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <4707A7AE-B8A9-4A56-B292-E590E91A9980@linux.dev>
References: <20251205194351.1646318-1-kas@kernel.org>
 <4F9E5F2F-4B4D-4CE2-929D-1D12B1DB44F8@linux.dev>
 <m63ub6lxljw7m2mmc3ovbsyfurl7hp4cvx27tmwelcxxrra5m3@eva5tqcdjxtn>
 <6396CF70-E10F-4939-8E38-C58BE5BF6F91@linux.dev>
 <5twlonzi3rooao7gyp5g4tyaeevemcx6qhuf4xvdtsi2cykuo4@wrhxmxz63wvn>
To: Kiryl Shutsemau <kas@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: B906E100005
X-Stat-Signature: qp9n1qm8hqekf5zuhamo7xg5nsnpuunj
X-Rspam-User: 
X-HE-Tag: 1765522027-94815
X-HE-Meta: U2FsdGVkX1+JHVg8oijc7rqTNuMgacLl96oEeRZ7jc9cdWM8EdsKSzqm2a2PaPS8jxNXHJWDQT9Al7vHfDmwyp8k/lbVWDzv5owmvprxNUQRu2h7OcT9PmbZrx6mHrUCiAaNISCm8RzRXhwwMgYC14/AMv4FMxA9drPOsSM1YTniiLU52M3LF5CXGk4FBgwiRtsb8l6/2Kq2g3ibgo32pCC/1uMobpGwE0WtZtOxZeUAB7+clLp+418/2a+wizBpMDM3b3epoquHSGbbqja0bPizPpyl3+CkALi2Ingylw6yKIYoL7kaL4M3sl3H6Qr/UvCPJ6d04WK6wkGr3fQRo+NNXaEM5QbC/0fkQj8lca+m4K5AxQJ9V3ujJ/y9wrLmPu1NkeP+IjKniQcqTmdkbBNe0v3MLRHXn3TqRJRn8QWYTgXoQm+2vueMva3Cg0+TZzmpX18S9f1upEL4rYsYZ+YsY68qf2j7fakANOItTXxn7UegOR+dt4SQDvyUtcKrWhRbyiT7bAxgo8bbYkNZSxr7o1/jrbXzmTARIGPuDGg1pIHVzzyF+86q96xO6+P/l2cx6m790TdpKfIyBnipQ1hwlzHxxuCySUFUFhkbdpEzTU6alcQxZqn4D7dfSCy9rPeNpPhg+dJwxpB+Y7ND0FmVxPzoulPgdFLwrl7vTod46P2bEDcuapzeukCBc150SidF+Cn4MTGV3U5X6gcCd1v3qchxBouZnAUCIAUZL59iCLYBz5ZwCmp8PMmtEJPo0SHAzByJZFYx2vCyV4h5mNhtwDb03l/UPyaa4FMg3jL8rJvLDhl87DqNIAA/Zef0ZA1xdh5j6G+SVNsIbAjo2v+AhysxmrbDkz2oddQTl1t8eDIEbcnUZu8Zf2wg+KekuX7K2vJaguz5u6XfOkWS+B+82I6QCp+38cPY3U7TJNsac6Dz9SnGStkCpVh1AZz1kUpbdKEReBiQwIDGNL3
 XUmJSURI
 dv5xliDuBuX+78l3CqtITgrmKiq2K1gqymxNswcqgMDTZQJQHaWLKjUP4lfaOM6Uw8BtsnY7+Er6Da5P5CwzXXZegi7cff+VbKGwpI6mRQpQ0CmqHLziK2ZF7W3XwgJI8ooM0iQedjZAqWrLPmEfpBurfhlZVhGKTDm6Nw9mUvSeaRM2xsW0bo0tTEP2JsYKdOWD8dxsNHrdiQ/w+drE3Q/X0REJbSd8FrJOGc8+SZP9uD9Mxm+w0iXZ9bOZ9T+ZdEvRq
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Dec 11, 2025, at 23:08, Kiryl Shutsemau <kas@kernel.org> wrote:
>=20
> On Wed, Dec 10, 2025 at 11:39:24AM +0800, Muchun Song wrote:
>>=20
>>=20
>>> On Dec 9, 2025, at 22:44, Kiryl Shutsemau <kas@kernel.org> wrote:
>>>=20
>>> On Tue, Dec 09, 2025 at 02:22:28PM +0800, Muchun Song wrote:
>>>> The prerequisite is that the starting address of vmemmap must be =
aligned to
>>>> 16MB boundaries (for 1GB huge pages). Right? We should add some =
checks
>>>> somewhere to guarantee this (not compile time but at runtime like =
for KASLR).
>>>=20
>>> I have hard time finding the right spot to put the check.
>>>=20
>>> I considered something like the patch below, but it is probably too =
late
>>> if we boot preallocating huge pages.
>>>=20
>>> I will dig more later, but if you have any suggestions, I would
>>> appreciate.
>>=20
>> If you opt to record the mask information, then even when HVO is
>> disabled compound_head will still compute the head-page address
>> by means of the mask. Consequently this constraint must hold for
>> **every** compound page. =20
>>=20
>> Therefore adding your code in hugetlb_vmemmap.c is not appropriate:
>> that file only turns HVO off, yet the calculation remains broken
>> for all other large compound pages.
>>=20
>> =46rom MAX_FOLIO_ORDER we know that folio_alloc_gigantic() can =
allocate
>> at most 16 GB of physically contiguous memory. We must therefore
>> guarantee that the vmemmap area starts on an address aligned to at
>> least 256 MB.
>>=20
>> When KASLR is disabled the vmemmap base is normally fixed by a
>> macro, so the check can be done at compile time; when KASLR is =
enabled
>> we have to ensure that the randomly chosen offset is a multiple
>> of 256 MB. These two spots are, in my view, the places that need
>> to be changed.
>>=20
>> Moreover, this approach requires the virtual addresses of struct
>> page (possibly spanning sections) to be contiguous, so the method is
>> valid **only** under CONFIG_SPARSEMEM_VMEMMAP.
>>=20
>> Also, when I skimmed through the overall patch yesterday, one detail
>> caught my eye: the shared tail page is **not** "per hstate"; it is
>> "per hstate, per zone, per node", because the zone and node
>> information is encoded in the tail page=E2=80=99s flags field. We =
should make
>> sure both page_to_nid() and page_zone() work properly.
>=20
> Right. Or we can slap compound_head() inside them.=20

At the same time, to keep users from accidentally passing =
compound_head()
a handcrafted-on-stack page struct (like snapshot_page()), Shall we add
a VM_BUG_ON() in compound_head() to validate that the page address falls
within the vmemmap range? Otherwise, compound_head() will return an =
invalid
head page struct (it is an address on the stack with arbitrary data).

>=20
> I stepped onto VM_BUG_ON_PAGE() in get_pfnblock_bitmap_bitidx().
> Workarounded with compound_head() for now.

I don=E2=80=99t see why you singled out =
get_pfnblock_bitmap_bitidx=E2=80=94what=E2=80=99s
special about that spot?

>=20
> I am not sure if we want to allocate them per-zone. Seems excessive.

Yes. If we could solve page_to_nid() and page_zonenum(), it does not
need to be per-zone.

> But per-node is reasonable.

Agree.

>=20
> --=20
>  Kiryl Shutsemau / Kirill A. Shutemov



