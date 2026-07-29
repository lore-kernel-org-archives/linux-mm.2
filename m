Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 578D7C54F51
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 14:12:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 668FA6B008C; Wed, 29 Jul 2026 10:12:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 618ED6B0092; Wed, 29 Jul 2026 10:12:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 52E216B0093; Wed, 29 Jul 2026 10:12:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3314E6B008C
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 10:12:45 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 98A2AA0654
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 11:42:49 +0000 (UTC)
X-FDA: 85041627258.21.D255EFE
Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	by imf23.hostedemail.com (Postfix) with ESMTP id DE006140004
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 11:42:46 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=vuyvti+8;
	spf=pass (imf23.hostedemail.com: domain of brendan.jackman@linux.dev designates 95.215.58.182 as permitted sender) smtp.mailfrom=brendan.jackman@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785325367;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cBInP0G7hBRjYIAsJ1YuS+3Ld12NRw9QSsq6YAtF1tA=;
	b=eZ+CXKtpkKoxYTw1pURx3q7hAOqii3A9ToNxXarM5WeDZ+ysHNRZx433W+OwYi0CGT8/oX
	6jh9I0UJqX/+W7cFfxCkgEDyo9bKPecZAvxlov7HjKIOYkq8zHcTQ/iUGdjXu0lC4zaKnh
	57E2e7Puv+CnHIVdVwX5dN833GAxTqw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785325367;
	b=8i059RO8QyEPjWobqGjBfngtdZm15fb+dpyBv2Pjn6uyPszMcUuxrX9YCCbwABW0LIav+p
	s3aO3Fp6IFmCxpOfzjkwaAjn27Z8QOytGt/VytbfopLoJTMRmxv+ltkj1BO+rnMKP0BYwX
	idu6KuOI/85jFfTZ35FzjZPFPwmNtN8=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=vuyvti+8;
	spf=pass (imf23.hostedemail.com: domain of brendan.jackman@linux.dev designates 95.215.58.182 as permitted sender) smtp.mailfrom=brendan.jackman@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Mime-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785325360;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cBInP0G7hBRjYIAsJ1YuS+3Ld12NRw9QSsq6YAtF1tA=;
	b=vuyvti+86m2ZmsFyuTHQDzcvgRE/uB3+UDJi+y3Zr5XD/vSK0aJ8xQfSK0i1AMButhsI1s
	WXThiwNHX2ilGaSVPW7nttHZDCNZEg+cBlgxGt+AEG7GH74wuOfXncBC/1rrz3o6TzWyW2
	iH6yGk5/Ni1vp2Rm44hnjNUv73HzH0E=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Wed, 29 Jul 2026 11:42:27 +0000
Message-Id: <DKB10LXNA3R5.1GQ8IYT1OHR1W@linux.dev>
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
 <reijiw@google.com>, "Sean Christopherson" <seanjc@google.com>, "Nikita
 Kalyazin" <nikita.kalyazin@linux.dev>
Subject: Re: [PATCH v3 01/26] set_memory: add folio_{zap,restore}_direct_map
 helpers
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "Brendan Jackman" <brendan.jackman@linux.dev>
To: "Mike Rapoport" <rppt@kernel.org>, "Brendan Jackman"
 <jackmanb@google.com>
References: <20260726-page_alloc-unmapped-v3-0-6f5729aa9832@google.com>
 <20260726-page_alloc-unmapped-v3-1-6f5729aa9832@google.com>
 <amcz6OxsJPjr5hIr@kernel.org>
In-Reply-To: <amcz6OxsJPjr5hIr@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: DE006140004
X-Stat-Signature: muxc3dmq4mkq3jusghpqhf51by5dmiwd
X-Rspam-User: 
X-HE-Tag: 1785325366-167407
X-HE-Meta: U2FsdGVkX18b/pK1tiM3RfLf3qH/ZEkLIhLQR/gJ5dOD9YgefdlBTN5YWaltvDdehymKNNTu5JQnujYrNanRcgzfz+BX+Q0cWwzvyP12LLFpBQFgF4euxOmlP9qXGJEEGOWsZ6xfR6ZYjx3uCBSomnO3FgGQMRRqHQfiJ4phQ+8A6+odplHiUO7+Ngtsev9Syp5wDAyCtFsikmT3hcjNlhpNXsCebMcT6D00zf/hajVVd+dgSP+xOG9P2S9WN1lap4qpczQVc0wtud4xMJQsnE2QBAQpSpgpl6mDTxyHtKzPxHUGusFRuFzS8hzuIXywiQ3TffVtYBHaK/RJul0On3tn6PZjliuB2Emh56AEOYhSObdtgiEPzZznrZiapZl6NVhpc71sFeIHweAW6TvIOAcHUqLDczLiAMqxyW4z3eFFwY2OD93MrrSjV16YZl5gH3lIkduIkGDWsHJ32W4WullrcLKYhhbHDF/92Pmv5RCB5n9sHTdGLY56w504TUtl3RYJ+L7xisMOyM2QYkH3CbzfSinvoZyY+wd1wScx/C2ZfKzfg4rJe63vyBRy/c48H4BJj9stpAf2mPuQrm+HcgVCIHdVB2qXLGulUQZJpWimVZBVP0jtEsqwISw1eSKSD99le23dGyRduS7LneSH5a+NCrefQdA29QJxYdddWshSLAJagltE8CCfYo1E3NXhoUQeOlQ5Rn78Dr6GyCgwBpp/Cuk120h3qBWsGyDaMTxEYhhgoDt76WOI9+kXu9Tc/T8/yLdS2Z/Q+3U7F/CLtlp66QhkVyOZ9VG8/R/Ez9mlPrEOBr3WEoKinIOT2pGSyRnIaOxJiw/kZzrD+sJ7nD8vJd10YG9YUKOaKo3EtzFSywVi56xReowCmoYJ0l+j2jP8SzD1XUXmSSNREtR1WGJ3LNUoyNFziWg4NxA5PEfBtAQC1RiMJj9InIBeGZhyE6CWKnkjXKyHoM6l2PR
 hb45chCO
 7UhoQ2lGqzWzijVjS+1CNNOE1RhaHEOiWWHB/RbFfrpAN0+9N+SaEVjnLW+cHPUfeIQHdaBsoN+lupMsW219gmmSxDns1Gzx8Wyus5Ak3LIXgRPClDx+TE0xGNeVfi8epm98HuZu5zhBASKh4XWGKagmCZj9v7Xq8qmZ60H0sgmGaEsb+8+lOjpoL5SqVVMhIuNGBv2HFNqksOOBB2B9H2sanRyRmBjkR4j0HJNnH0EuFFJ0qwffkPO/xMNkZrxK9ZVF0T3sAKGEY52dhPFgywKhajIel3QwtHXg8Al9TWCTgbdtl+gSBnJqSbQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon Jul 27, 2026 at 10:33 AM UTC, Mike Rapoport wrote:
...
>> +#ifdef CONFIG_ARCH_HAS_SET_DIRECT_MAP
>> +/**
>> + * folio_zap_direct_map - remove a folio from the kernel direct map
>> + * @folio: folio to remove from the direct map
>> + *
>> + * Removes the folio from the kernel direct map and flushes the TLB.  T=
his may
>> + * require splitting huge pages in the direct map, which can fail due t=
o memory
>> + * allocation.  So far, only order-0 folios are supported; this guarant=
ees
>> + * the unmap is either a complete success or a total failure.
>> + *
>> + * Return: 0 on success, or a negative error code on failure.
>> + */
>> +int folio_zap_direct_map(struct folio *folio)
>> +{
>> +	struct page *page =3D folio_page(folio, 0);
>> +	unsigned long addr =3D (unsigned long)page_address(page);
>> +	int ret;
>> +
>> +	if (folio_test_large(folio) || folio_test_highmem(folio))
>> +		return -EINVAL;
>> +
>> +	ret =3D set_direct_map_valid_noflush(page, 1, false);
>
> There was a discussion about  slight differences in the semantics of
> set_direct_map_valid() on x86 and on arm64 and that execmem should
> apparently switch to set_direct_map_{invalid,default}.
>
> Maybe for this series it would be better to add a patch that adds numpage=
s
> to set_direct_map_{invalid,default}_noflush and use
> set_direct_map_default_noflush() here?

Um, I think probably we need to clean that API up a bit overall, and I
think that's probably best handled as a separate patchset?

I think with the API as it currently is, the current usage is correct in
this patchset, and I'm a bit reluctant to grow this patchset any
further (and I didn't want to block v3 on yet another preparatory
series, but potentially blocking v4 on one might make sense).

> And maybe also pick another Nikita's patch [2] that makes set_direct_map_=
*
> to take address?

I deliberately omitted that, I don't think it's a good idea:

https://lore.kernel.org/all/DJJ2QJQQ73CM.2WHKW4AT6QT1D@linux.dev/

(If we do want to change the API we could use PFNs as I mentioned in
the last message of that thread, but I don't see any need to change that
API).

