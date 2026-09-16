Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 65E4CC88E77
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 09:36:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 757CD6B0099; Wed, 16 Sep 2026 05:36:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 707846B00B5; Wed, 16 Sep 2026 05:36:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5F7736B00C0; Wed, 16 Sep 2026 05:36:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3DEB56B0099
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 05:36:08 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8E703120683
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 09:36:07 +0000 (UTC)
X-FDA: 85219119174.04.A4A7105
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf15.hostedemail.com (Postfix) with ESMTP id E9310A000E
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 09:36:05 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=FG+PhcCJ;
	dmarc=pass (policy=none) header.from=debian.org;
	spf=pass (imf15.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789551366;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lQusxUCZOg61iBhz+gh2H7namnoGRC3noT9Nzn5HIqQ=;
	b=D/70+sdPwiUcr3/nyUQivNZslZ3feKUZl4mxiWZAd5jvbYeB9+kPEVZZkDeZqNd2sxpyxj
	/rwuIYPKEHkQyBh+Za3gufdq+iD0XBf6cH8oVV3fCceCuqBdszrWnUxS8gM7rNNlr2rkWB
	8zZbBhiaL6D35CNQTpLkggduwkqlHPw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789551366;
	b=Go7GZj7fv131qifgg/KKInFSNJyUg5oY3Jfe7iiS4MWxx/mtm9VNDGFXy1EWbebzTdG+7S
	rIpE6GgCU1CR21scczA0D3fwKke+jSZib1bdbI5MJ0FL85CrQuWRo/iq2ktznJ3D/H8qvn
	RRNoN6NAhd9hP/J/Rtfuin1u3vLX5+Q=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=FG+PhcCJ;
	dmarc=pass (policy=none) header.from=debian.org;
	spf=pass (imf15.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=lQusxUCZOg61iBhz+gh2H7namnoGRC3noT9Nzn5HIqQ=; b=FG+PhcCJdohk4nnU98iT/zoR5N
	BCgB6P043DOhKlGyArs7g31LKrnMGQt2zWbGrRVZDTebMTiVX0hrOpMLGDYK9SjK4Nbhr1XO9Z/oe
	9kYRquCRmoHMSfDt5RL9ZF+HqohR7f9iO3YfQb2nxLasS8aJC+6WBFFBZVtfu5594dMAJdGAlSEor
	T//McaeWE/JqURKCLjDalwcD9SxGNYRZ1Ndf6cU2qsZSXzppknaqswzTmRM1m9nMELechoHJ3sF6b
	SPpSFa5JtX7hBI+K/IGPBKSM0MEmySJV5UgazfmjiDgO8UjZf6aP6k+M7p32sRjJG2WLJIf/ZesHH
	AEqfN1nw==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1x6m2s-0054bo-2i;
	Wed, 16 Sep 2026 09:35:15 +0000
Date: Wed, 16 Sep 2026 02:35:06 -0700
From: Breno Leitao <leitao@debian.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Ard Biesheuvel <ardb@kernel.org>, 
	Ilias Apalodimas <ilias.apalodimas@linaro.org>, Miaohe Lin <linmiaohe@huawei.com>, 
	Naoya Horiguchi <nao.horiguchi@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, kas@kernel.org, 
	kexec@lists.infradead.org, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Thomas Gleixner <tglx@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, 
	Brendan Jackman <brendan.jackman@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Oscar Salvador <osalvador@suse.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	"Rafael J. Wysocki" <rafael@kernel.org>, Danilo Krummrich <dakr@kernel.org>, hannes@cmpxchg.or, 
	shakeel.butt@linux.dev, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, rmikey@meta.com, riel@surriel.com, harry@kernel.org, 
	linux-cxl@vger.kernel.org, driver-core@lists.linux.dev, kernel-team@meta.com
Subject: Re: [PATCH v5 7/9] drivers/base/memory: count inherited poisoned
 frames into the block
Message-ID: <aqpczrtIwSG948iv@gmail.com>
References: <20260915-hwpoison-kho-v5-0-3bc7a57bd503@debian.org>
 <20260915-hwpoison-kho-v5-7-3bc7a57bd503@debian.org>
 <de41b78a-8471-4832-be0c-35d410a4499a@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <de41b78a-8471-4832-be0c-35d410a4499a@kernel.org>
X-Debian-User: leitao
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: E9310A000E
X-Stat-Signature: z9qz4q89nywiy1su8mh4jmbw4jxjgno7
X-HE-Tag: 1789551365-509175
X-HE-Meta: U2FsdGVkX19g23YTr2G1gMWV2Yagu8OAcz+0yIiOwG2qzksITv5HMM6ONLiIInn2RubU/iW4PTEY2pj9LKqBiMJjbjpU1AC5CuMR7FRUzm7UUachXWheeHcyhk38qwk2DfHihbIsEzZS0r3DwCWNS2llInaaT+BjzsseVJMbF//fO7uiY7IJw4Es+2Aa2IVkuFgyQGtMnK1JAFmmdgWDFGutDvVNTE9SQzb/19XGo4d5wvdvzZydPHpoa44IhFsf2O0PIMiLw6MvNCDNAe5WxdDocypqSGSYcM9hgjbVkzkf8YSbfWfeBOfJ/fhBZaiVCPEO/JU25FaKf/5bgfTnqNnM7Wd7wy9U0dAhIRZSfMRXbHd4ws2i6WvyEfecBYMP1R5Plbklz5SjCpfNBtADmVhdx0emsfjVeD+3EgsjQD6v7QcsN52FiowBRo3IGdngzXONMIKUkv+7wbkFmCi9nERqfh3E64n2Kn+GkeR4JcHjgCxzvS1vqEV63lEUt+BwortJDE5lle72uGYW0aGcSUs3AMa1fAbUMnQdGKNoWv/UAS5MfxElRrBZsH52Xqa88lu8yobGLsxnwJLR+626DPnDFRXmlv3q/N0pjSv9lx9Gwv3JpETO9Hp0BT8jFs+BqH8djXPo6P7fMdS0E0cD1bILKat61Rkk87HODj00RsMAG59HnJTS47Q2iDsPFZVN8gv/ky/nbwhaC4cyL/mxmG5yZx0UHlD5ElBO6HG+sSbQPIaZzfILAJ039YrYwXsSWokHZ/mdegEaYhSUxcALfB9GT0x9EqySIBz/FzqqGA9OZQ8swQ+v2yw6P/WBpiiApa/rMPRuy+JvWL8qaY5ByRba1h1emvYPWCEr159R6M4LGGvuzRH0TrVJRWQ65WT+eKwgF3gccLIgSNTuwoNZIKXbHm0XHR9PjeClSNczC13ndN7yBsf4GoXhTO7hgGMsOKQaOKLzPNjNd+UiWyv
 XL/Eex6U
 UYp0erZqnlvv9sUz7NyqIPYwNwMT4i4GIryHl5+FmG6WxoNqzsNGllWSXNLMLulBaLHxmh0dxiNs2maMAK/ox8mswCkS5QULMT7Wao8LEq6v36M1h7rAqmaQoVxfCVKpy3vejBUG2lN8IMXdIDBRcbMiCm67llZ5SfKd1nx1hlq6Rh/pHfIW1Nzl2PmcS5MP63pZ94W+7OrizZJLOPPBMNxanZUnVoiAmrMFqYDtE+7TGU2ogZjYTO42lFqvmRpooKgtnDSVYpKe1wgkjXmPnA5ILbD85Uudl+fPoSEahQQ05LEJGR5Rbdm/IV+QdvuU5CrTe16OJqnjtvc9PqxSQQ5mBDhrlpEA1BTAu
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello David,

First of all, thanks for your time looking at this patchset.

On Wed, Sep 16, 2026 at 08:48:56AM +0200, David Hildenbrand (Arm) wrote:
> On 9/15/26 14:53, Breno Leitao wrote:
> > +static void memblk_nr_poison_init(struct memory_block *mem)
> > +{
> > +	unsigned long pfn = section_nr_to_pfn(mem->start_section_nr);
> > +	unsigned long nr_pages = PAGES_PER_SECTION * sections_per_block;
> > +	unsigned long i, nr_poison = 0;
> > +
> > +	/* A hotplugged block is created before its pages are online. */
> > +	if (mem->state != MEM_ONLINE)
> > +		return;
> > +
> > +	if (!range_contains_poisoned_memory(PFN_PHYS(pfn),
> > +					    nr_pages << PAGE_SHIFT))
> > +		return;
> > +
> > +	for (i = 0; i < nr_pages; i++) {
> > +		struct page *page = pfn_to_online_page(pfn + i);
> > +
> > +		if (page && PageHWPoison(page))
> > +			nr_poison++;
> > +	}
> 
> That just slows down boot unnecessarily on 99.9999999999999999999% of all
> systems out there.

hmmm, I am not sure I see it that way.

The loop only runs for a block the bitmap marks. On a machine with nothing
recorded the bitmap is all zeros, the range_contains_poisoned_memory() check
right above it returns false, and the loop never executes.

What every boot does pay is that check, once per block. The stub installs
the table whether or not anything was ever recorded in it, so this is not a
NULL test: it is two 64-bit divisions by the unit size plus a
find_next_bit() over the single word a 128M block covers at one bit per 2M.

The real cost (that "for loop above"), comes when you kexec (not on cold
boot -- given the bitmap is empty), and you are trying to init
a memory block that has poisoned pages into it. Which seems the right
trade-off, no?

That said, can we do better? Yes. The silly win is to let the table say
whether anything was ever recorded in it, something like a
linux_efi_poisoned_memory->empty that the first recorded frame clears,
and return on that before the bitmap is reached at all.

Is this what you are looking for, or something more drastic?

Thanks for your review,
--breno

