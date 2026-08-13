Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 807CFC5B572
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 16:44:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7E28B6B029F; Thu, 13 Aug 2026 12:44:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7947E6B02A6; Thu, 13 Aug 2026 12:44:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 683346B02A7; Thu, 13 Aug 2026 12:44:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3F71B6B029F
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 12:44:11 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id BFB3140225
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 16:44:10 +0000 (UTC)
X-FDA: 85096818660.20.C48E71D
Received: from mta1.migadu.com (out-220.mta1.migadu.com [95.215.58.220])
	by imf18.hostedemail.com (Postfix) with ESMTP id ACA671C0006
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 16:44:08 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=qg+QIEeg;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf18.hostedemail.com: domain of brendan.jackman@linux.dev designates 95.215.58.220 as permitted sender) smtp.mailfrom=brendan.jackman@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786639449;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4khjOWuHqGqWNtccNr8wg8sfuawenwtyjOSKMnV4bxA=;
	b=6MNAriNLedKoY7ZvfNoUwFyW3ofCmw4/lLTZzt9F/zLxEKQY6wmy4JcnpM7AwZZnY1n2nV
	Lgb+Y7JAW5dZftGenlCn8qo/hcGqltEHFNOwD8pCfp8KMEuY0ybxpf63MHJL3Iqu7n0dmL
	7ihMTS8u75FiDKhGXaqXBhcf2updd4Y=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=qg+QIEeg;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf18.hostedemail.com: domain of brendan.jackman@linux.dev designates 95.215.58.220 as permitted sender) smtp.mailfrom=brendan.jackman@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786639449;
	b=7E2+QumikNUm8DahTEiFKg1GN7HC+cSpnp+hgK490oCNi9ZbG0ACQu3z4LY+TTm+pKCV+T
	NVj/jOxvMAmXsE0zu8I61IIfoXeYGkbDPhgH8kmdiPvG3h5R4NdJR8ZPKLtwwpdkQznr8O
	1qJilMOmCq8wZ42/5HYGAXdu0/i9wbE=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=dGeEWnoB/VRmNpMiEGQ7yG96SirN+Gr0AYqUVuvNOK0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1786639447; v=1; x=1787244247;
 b=qg+QIEegBPbxMNd9bG9JqY4tJUAXjUf3sbzIFSWcigcD54camBqi+aKYoeBroGiCZlYK7dDF
 PUYrZP7hXAaQwcOv79kzyEotYQv18hZ07F78J2i1PHznD422ozY2hhE4uOP4EfrM6SSPpNw2AnX
 zNvQnvv85MFJzt98odK1jWRo=
X-Envelope-To: linux-mm@kvack.org
Received: from localhost (77.97.51.77)
	by smtp.migadu.com with ESMTPS id bc8c564863385aad;
	Thu, 13 Aug 2026 16:44:07 +0000
X-Migadu-Flow: FLOW_OUT
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Thu, 13 Aug 2026 17:44:05 +0100
Message-Id: <DKNYTQFARQ3P.1VF9T1FUUS8LC@linux.dev>
Cc: "Borislav Petkov" <bp@alien8.de>, "Dave Hansen"
 <dave.hansen@linux.intel.com>, "Peter Zijlstra" <peterz@infradead.org>,
 "Andrew Morton" <akpm@linux-foundation.org>, "David Hildenbrand"
 <david@kernel.org>, "Vlastimil Babka" <vbabka@kernel.org>, "Wei Xu"
 <weixugc@google.com>, "Johannes Weiner" <hannes@cmpxchg.org>, "Zi Yan"
 <ziy@nvidia.com>, "Lorenzo Stoakes" <ljs@kernel.org>, <linux-mm@kvack.org>,
 <linux-kernel@vger.kernel.org>, <x86@kernel.org>, "Sumit Garg"
 <sumit.garg@oss.qualcomm.com>, "Will Deacon" <will@kernel.org>,
 <rientjes@google.com>, "Kalyazin, Nikita" <kalyazin@amazon.co.uk>,
 <patrick.roy@linux.dev>, "Itazuri, Takahiro" <itazur@amazon.co.uk>, "Andy
 Lutomirski" <luto@kernel.org>, "David Kaplan" <david.kaplan@amd.com>,
 "Thomas Gleixner" <tglx@kernel.org>, "Yosry Ahmed" <yosry@kernel.org>,
 "Patrick Bellasi" <derkling@google.com>, "Reiji Watanabe"
 <reijiw@google.com>, "Sean Christopherson" <seanjc@google.com>
Subject: Re: [PATCH v3 11/26] x86/mm: introduce the mermap
From: "Brendan Jackman" <brendan.jackman@linux.dev>
To: "Mike Rapoport" <rppt@kernel.org>, "Brendan Jackman"
 <jackmanb@google.com>
X-Mailer: aerc 0.21.0
References: <20260726-page_alloc-unmapped-v3-0-6f5729aa9832@google.com>
 <20260726-page_alloc-unmapped-v3-11-6f5729aa9832@google.com>
 <am9y50Lc_pBf4pfw@kernel.org>
In-Reply-To: <am9y50Lc_pBf4pfw@kernel.org>
X-Rspamd-Queue-Id: ACA671C0006
X-Stat-Signature: sbg9sasizis6c53xnegxa75hwuzj6h49
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1786639448-296932
X-HE-Meta: U2FsdGVkX18UkTpkzxjiJOI/d+jWs9f5M1VTfQKVjnW/cEhEvt97kQ6FRfudE5IJU+EDMReaCcOlSufQCnqX6kCRXGzeK9sgbiCuy8/TQA0M5cmcM0pzVK/L+JSADfGDBSedCV2Rkes2U3MZdqxgZYHB7VLat0gSV2UJbkljlZBv7gf/lrBnIX6aOvG7Poh24gE/bjQURg/dJd6YMBR/N9gyKu//qTFRCabs6WTjeJpf3VpQUUHNRtn4S077ueWUrmzRMPnUnZ3BRuGMk2gGpp81kdkPpN5uFDPLkSv3X7ic+9ZiUvFxxxQbqXEvqZLAJ2IdvFJwrWj8kqBaAMd5rNIoYb6U2otUpVxfQMok8ELWulE2uqwjh8sBSLlyDAF4L2gDsO52yCcyUN2opW85lghmFEXNuZUHEsYbcQBe7b8Dehatz5G6xBv1jAcnZaP94LOK5ddhs0mvDyxB/CuM3c27ZRLvHO+tmZcV9z6DdO3XEhGz+M0esA6O61uPPiXJXXuwqrPcQ73BAe4yVz1iMy86vSXkWc1zw4JMVzTKBYMO76YuKB1o0b1g6OBgUQA/0a2HrBghMN5WBZZO0cWNqDEFXjEoYoWKqmuw09PIV8K6R/K022RNWj3Tqb3NtEYoeM30qZmsIvdKx4v9LIcEK5jvt1iViYWq6LOZjqmfG3cpBLsHkhO47y0C+rRL/2AQn1/xPvMwjYEJwkOSNfpFaGytgJf2UrLMG6wbrplBpAb9RNJ9lqhSTuPU28OSob3mKxUDhmhH1YfnwD+cBRIW8Iov0+jcM+dgCPz0TT7zzwREzd9N+tea11O549Vn4YffDG27jXnyb/akb6cCiZfpzsnwAA1MbpyzyvHt4PuxkVrZVDrGs5oeo0cOk7FROydAO4QaoCDPWQdQ49NslIPGM12VCNseJiVxbtNyKJq5hUEfKfPTCvGm5q39aDOYHMI6620TUJUMh4hO/rFapXq
 v0LA8Wkc
 +jBlPygxfuezEQWXArCXZsCGlTdDria3INPHHQsmmGzw2i45rKShWUpulHT/KgrhG3adQq4YtvgBOIGcgVa7/c2Nmm7nZeXbinYfmlkuoJbXvQ9GubLLQNQeQSHgyDZV5/6dVkdkLKASG+LMb4VxpBnHi3e6FPB/R1EybVpyJ6oh0Z4j134wBe0XTPfv4nlBYK3kv7KV7PdzlZxqKouiu57gcRxupd5Zw/F/5kO7gTif7nUcPM/acFuoogT64ynEFlKiW0tGoJ1di5ViMPjDLF6Tj5j52EEdf0ZNN/Q2B3/fN9DBg++WEgaV7+g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun Aug 2, 2026 at 5:40 PM BST, Mike Rapoport wrote:
...
>> +
>> +VISIBLE_IF_KUNIT void __mermap_put(struct mm_struct *mm, struct mermap_=
alloc *alloc)
>> +{
>> +	unsigned long size =3D PAGE_ALIGN(alloc->end - alloc->base);
>> +
>> +	__apply_to_page_range(mm, alloc->base, size, set_unmapped_pte,
>> +			      NULL, PGRANGE_CREATE | PGRANGE_NOLOCK);
>> +
>
> Sorry if I missed that in previous discussions.
>
> __apply_to_page_range() acts only on PTE mappings, and looking forward I
> presume we'd want PMD and maybe event PUD mappings in guest_memfd and
> subsequently in mermap.

Yeah.

> We anyway have a ton of page table walkers, so maybe it'll make sense to
> add yet another one rather than adjust __apply_to_page_range() to the
> mermap needs?

Yeah... I would really like to avoid creating another. This was
basically the topic of my last LSF/MM/BPF session that I pivoted
away from at the last minute coz I just don't really have a clear idea
of how to proceed.

I feel like maybe the way forward is to try and pick one and slowly
steer it towards being generic enough to subsume another one? Like maybe
we could target incrementally converging the set_memory and
__apply_to_page_range implementations or something...

> Or maybe there's a suitable walk_ API in mm/pagewalk.c?

I think that code is all pretty tailored towards _inspecting_ instead of
modifying.



