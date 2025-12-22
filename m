Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5643DD711D5
	for <linux-mm@archiver.kernel.org>; Mon, 22 Dec 2025 09:46:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 87B296B0088; Mon, 22 Dec 2025 04:46:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7FEBB6B0089; Mon, 22 Dec 2025 04:46:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 70B166B008A; Mon, 22 Dec 2025 04:46:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 5F7B36B0088
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 04:46:06 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id DC875BC9CD
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 09:46:05 +0000 (UTC)
X-FDA: 84246625890.21.DDC928D
Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	by imf26.hostedemail.com (Postfix) with ESMTP id CD5B0140003
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 09:46:03 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=dxJMTQnW;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf26.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.172 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766396764; a=rsa-sha256;
	cv=none;
	b=CVpZH0h/TQQHbAt5RKk0LHUtc3fOSfHsSbfxOhDrwG/GdKDjvc1xZn5KkrvaMgD7Cw478r
	8+5f4a18T5zP+Mcwd333gthh30eoX37wrKKS/jaMxiDOJelbbZGpbm+EUHF7VIsuq28MVW
	YHeaba9g4b9XStpYwqAf+4JR+bGeSpo=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=dxJMTQnW;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf26.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.172 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766396764;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mqQh9yIE/F3IAbsBdjlJzFZuXWEyXPgfG9BSwkSSIh0=;
	b=OOLeckyBL/MUUwYae2Hib/wUPdCyaAPLXTKKvhEcky/EH1jlD41ExNW555wBonbZtqVWbs
	YEm38/Uu6+H3t2e9wtP6RchIZ6QijqbNi/ssbc3lh/IqlAc0tBpFoJp9BLZOvUjQ2KVXdV
	VMcQ898i6o7GebYfc218lazstk+Zhyo=
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1766396761;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mqQh9yIE/F3IAbsBdjlJzFZuXWEyXPgfG9BSwkSSIh0=;
	b=dxJMTQnWy7525VqqYqZfh9xjZ4zZlAeWpYhDHKN9ylu3y9DAi5fc46LkZOVobA3GPKOn7e
	yV6hiRozKtFavTcAUk6jWMRebaMfnHGH5nJ3vkAU+8Rk/ROojwjuUideiyTwKXGfpIiT9b
	CFt/EGJVEcJBZ4jassS2xC96d8BWCAM=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.200.81.1.6\))
Subject: Re: [PATCHv2 06/14] mm: Rework compound_head() for power-of-2
 sizeof(struct page)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <34BED0AB-22AF-4107-84FB-543D11BCA136@linux.dev>
Date: Mon, 22 Dec 2025 17:45:16 +0800
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 Matthew Wilcox <willy@infradead.org>,
 Usama Arif <usamaarif642@gmail.com>,
 Frank van der Linden <fvdl@google.com>,
 Oscar Salvador <osalvador@suse.de>,
 Mike Rapoport <rppt@kernel.org>,
 Vlastimil Babka <vbabka@suse.cz>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Zi Yan <ziy@nvidia.com>,
 Baoquan He <bhe@redhat.com>,
 Michal Hocko <mhocko@suse.com>,
 Johannes Weiner <hannes@cmpxchg.org>,
 Jonathan Corbet <corbet@lwn.net>,
 kernel-team@meta.com,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <78326B0A-7845-4D80-8BAE-C2191030F8BC@linux.dev>
References: <20251218150949.721480-1-kas@kernel.org>
 <20251218150949.721480-7-kas@kernel.org>
 <34BED0AB-22AF-4107-84FB-543D11BCA136@linux.dev>
To: Kiryl Shutsemau <kas@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: CD5B0140003
X-Stat-Signature: 6thh8d3kibt94p1u1c89koya7ouo6pf1
X-Rspam-User: 
X-HE-Tag: 1766396763-286638
X-HE-Meta: U2FsdGVkX1/ni1qOuGZd9FYg0fk1F5Da5hoK1NirmnGyBsH9Mss4i39tpz41k12RRUjGlFYzlO4u9RarhYB4ED7QdMqFyPw4UjBkcB43vXyH2OaNfDUEDEXVqR/0acQcSC2/Taz2lMFnL8n/Lyjh9x4+U38mmsEJ5l+V16H68Q239YdQywM2Ftu84RvndPHohqVl6KI3iuVpzyTuq5Rk+4ItPWkrMexyrRR+A0RDKG+TLGA6UoVas2lkmgUBg7X6CiE0Lr7vdVspI4jrL9uhJXYFvFvR4eeSDOpcnJTIXnQheO67HcWJkr7Q4yYqxbS6/KaQR63kNhkQL1qYXupdlZVBuGr3xLtOBNM3Bxk3wxrSPYj4GOByf6dGJsREyj84TSb34Uf+qWQhQMpFrvn6Lll6xYf6MtO+vFkd5BDfzZ6qP5mk9qBqyXBOmLf7h82Ftli/LqZX/Lx3I19H1qEl98v1Fodn7FefHhTRznxBuC5DIrdRwcqS72WFXyiDg2LtzLpZZInWcrikgzKFoj2r43W8hdJzDeYbqDBw1MxlHiN6VQbi/e3XfJaftbcyychfNkZiAC0S+ibVKcO2oieEB+5IGphLm13kGrb3Q5m7SzwUGFSGcf8OMGuw4VsnC2dc7NYAhqVsB/AIESgASN2xapCNaTny8aOngkKs0v2iMf+GvYHyu/0JIgUC6FN6sNHjvXxZC+aLjPUBaR4i+NSmvINA0e0ZUcstq0olVCzqFPeGpMNXiWIV5p+t52OlnJzp+1escXm6V4GOt7hZYgqJaW/YAzLEZLdf0nWdzaUzdnvPO9/HY+WO3kxZTISLZuAHI9v7E/Z4KZZ/UV7j20JYePmRiWJQJZAObwll5oHEGhR4wDjHLwIZU6Dewe1FVsibFT19pep1XfPWC58RrcmK5lyNmNAKmm3n6n9aWPdhane8cfcBfV8dZI/7P5qshIz4Lf/KoiUBh36r+JD8q8d
 YZ2byZjA
 MAoIJYPNKV8LEwkcKRUlkOZalhWKDMK/Y5Goe50g31fA558XmigFLJ/VK2IpUNFosy08mvDmQWf8F+U970Bpd+rrgq6yu0AhYnE2awOjMREtww8lwj1vtRA2zJ2PROMaHz7spb11OhwcnP6/5D/t0mBe0c2I28c3B5iaSD11Vs/6YtLgwKzoZIqrfRpziGjpXsmmMheEevNlaCx716+wk40ctrmbH2rNohvDXxsbXeYhYt5mJahaKDWCnR+9ucj07WK4Svp57GTSxnx/sKJ/FeT5bPi7Ax4ZJ0hBYAgov0yA5G28F0rzMHZVbYg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Dec 22, 2025, at 15:57, Muchun Song <muchun.song@linux.dev> wrote:
>=20
>=20
>=20
>> On Dec 18, 2025, at 23:09, Kiryl Shutsemau <kas@kernel.org> wrote:
>>=20
>> For tail pages, the kernel uses the 'compound_info' field to get to =
the
>> head page. The bit 0 of the field indicates whether the page is a
>> tail page, and if set, the remaining bits represent a pointer to the
>> head page.
>>=20
>> For cases when size of struct page is power-of-2, change the encoding =
of
>> compound_info to store a mask that can be applied to the virtual =
address
>> of the tail page in order to access the head page. It is possible
>> because struct page of the head page is naturally aligned with =
regards
>> to order of the page.
>>=20
>> The significant impact of this modification is that all tail pages of
>> the same order will now have identical 'compound_info', regardless of
>> the compound page they are associated with. This paves the way for
>> eliminating fake heads.
>>=20
>> The HugeTLB Vmemmap Optimization (HVO) creates fake heads and it is =
only
>> applied when the sizeof(struct page) is power-of-2. Having identical
>> tail pages allows the same page to be mapped into the vmemmap of all
>> pages, maintaining memory savings without fake heads.
>>=20
>> If sizeof(struct page) is not power-of-2, there is no functional
>> changes.
>>=20
>=20
> Forgot to mention, I believe I stated in the previous version that =
this
> mechanism only applies when CONFIG_SPARSEMEM_VMEMMAP is configured.
> Therefore, you need to wrap the entire mechanism within =
CONFIG_SPARSEMEM_VMEMMAP.
> For other configurations, it's difficult to guarantee alignment to a =
very
> large size (for example, in the case of CONFIG_SPARSEMEM && =
!CONFIG_SPARSEMEM_VMEMMAP,
> vmemmap allocation uses kvmalloc, which only guarantees PAGE_SIZE =
alignment
> for the returned address).

I found that we can call kvmalloc_node_align inside =
populate_section_memmap (for
memory hotplug case), so that we can specify the alignment parameter as =
the
input size. Then, this mechanism can applied for CONFIG_SPARSEMEM &&
!CONFIG_SPARSEMEM_VMEMMAP.

For CONFIG_FLATMEM, we also need similar approach to specify the correct =
alignment
in alloc_node_mem_map().

Thanks.



