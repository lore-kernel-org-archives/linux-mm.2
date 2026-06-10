Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5AEE7CD8CB2
	for <linux-mm@archiver.kernel.org>; Wed, 10 Jun 2026 13:19:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B19506B0088; Wed, 10 Jun 2026 09:19:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AF04E6B008A; Wed, 10 Jun 2026 09:19:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A068C6B008C; Wed, 10 Jun 2026 09:19:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 908D06B0088
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 09:19:00 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2EAD01C2BDA
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 13:19:00 +0000 (UTC)
X-FDA: 84864058440.08.C0EAF1E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 666EF1C0003
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 13:18:58 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OMEHcZsk;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781097538;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zkNtDF+TnhAfuRsb9S+buKNiDb7dsGMnYzfKywwEPBo=;
	b=t5GwCqtGxKttsKpStKdSRC5xV4Ati8lmyDXDX80lxk5TsN305Zd/itVEgIhBafxz2MtWsc
	QGP6Y5cPA1YJ/wwclAEYWGaE47mqKXfZuOTswe4Fd+ZEVxMNYsEAms2uFUF4Lf0RbehZpb
	uIWLOXX5v6uVOPutYaOErKR+/fNIpcM=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OMEHcZsk;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781097538;
	b=kCEHUnznwJGTNpDSLqy6Sy198ZUiMW6Vuq0/lhB7NoBdVkiyCQ4mXHp9W61j9jxHK883+5
	moPR5zZeSylf/7dRV1YMQiwuGpouPaz57HDPdynAbYfPr1w/yOe6h5jZQevExLvWgbdBP8
	sbbWvznR+4mrAoNi1oXN8AkG+8Yn5A4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C7A616001A;
	Wed, 10 Jun 2026 13:18:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E19C01F00893;
	Wed, 10 Jun 2026 13:18:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781097537;
	bh=zkNtDF+TnhAfuRsb9S+buKNiDb7dsGMnYzfKywwEPBo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=OMEHcZskZbsd9sNyePcfeVaP4LOngwAbTIC83XAxZ0tD9OLeeABRkDku2fuk0g+y1
	 vstwxk+/WhMNWC4TKaJKBgVr2tlhJXr8haGlDj+OOWbpwHcqLVLpM2JSWcocgfM36d
	 HLmybkPMy9ZN7sn4pjH3nT3ZPU7em7QOZfiDKF4RONrF1zS36XPL5OKSnUO/ssNOeC
	 pS+ILw0MfO9dd3fEWa2rCS0SnBmB2tQspRAuCzajsGzLB4XsyHpeL5xuk7z/UfLkn2
	 7SuletPW9yxvfC/foN7weNDFmUfGCQLHJqaM3/IweckoYiTFcZQvuwWN4OMOOGd+bN
	 Hfz2vMMkXxzaA==
Message-ID: <d80bb796-3cac-4de2-8bc2-cc799e5bbeb1@kernel.org>
Date: Wed, 10 Jun 2026 15:18:52 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC v1] io_uring/rsrc: add fast path huge page handling in
 buffer registration
To: Christoph Hellwig <hch@infradead.org>
Cc: sw.prabhu6@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org,
 linux-kernel@vger.kernel.org, dave@stgolabs.net, dongjoo.seo1@samsung.com,
 Swarna Prabhu <s.prabhu@samsung.com>, "linux-mm@kvack.org"
 <linux-mm@kvack.org>, Matthew Wilcox <willy@infradead.org>,
 Zi Yan <ziy@nvidia.com>
References: <20260608062937.804758-1-sw.prabhu6@gmail.com>
 <c924fb59-be47-4fa5-adbf-a50a831ccd7b@kernel.org>
 <aikBIESiJftxBdfL@infradead.org>
 <f2b5189f-10de-4685-97f3-6ee08d159743@kernel.org>
 <ailLu70plC9WK2dB@infradead.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <ailLu70plC9WK2dB@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 666EF1C0003
X-Stat-Signature: jm9oj7rugjn85s67t6ecy87asi5rqufh
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1781097538-96232
X-HE-Meta: U2FsdGVkX19+KZWfMvBt5J3M/EU0MtIw9mAXpIMAy1Zug7m/STCs3SQCyZcaYb9Uuv1hh1vdmsjB7OjkBlG1hgvEMIuHbPv62ML5IBl09N720B2RDN2mFdS3QO+DtkLqOxWm9AyMmvhyotDQWP4ylY9h1PE3RMSwvai6BVHEAH6Eu//1Y1zha1XBuvNlveQAVb6gHn0iAtqBD2paTFA0F1iS/08TBTCxfEolkHh3hMbjhIVqiejcydtKOw/lixRl217VlUpG8EnHYAEwQrJcEO84epRDUmG17vsbbszORDe0mWwtYYLb3DikDDZX4RKi6LimLOCS2QVJkvbB9WdSITes6lLqEsajiC+jM75q0afgR15PctQkZpKmXqN9sU9mwnPLdzm+ZW80dYvqU2o3OKU7dT2U3o/7ajretNznR9M7uormuwJqwYba5Ow4ViJNZ6fFxQi+TB4h13ErdezXpyH8H/1LE+QdLfHAJOVtM6KbcCcQlz7mVJj8DJO1kZb6/UPAid5/K4FbL9TGTJ9Jze3GGO+YwRQOzjYgEYe4E2nACdo9tGYHuQFXuWvdK8Wy5eKHw6y29TM2cB4CBYC/54Hp0KxpBIw7SUE5B6k73CNAsa/oe0vNR36o+xORV2lEiLDEUh1t/HqghSZyxxxiQAYEVftAdYKrfCMxp/RDASQjQJy+AZAUClpRdQOM/K8UxtCQnTVZocxVzBMRyBW4k81YFbOs+LQDZxi/s0BqCLBFADu5ZmuOYNBx606wN3y1FPeM2zzZKCriqMFI+QUo79fYvNmmAA7kNky8INfobhrCeRjuICiM+QGiPOktraeE/eBFp14Lv6T79V6FYXYQal+PxdpxtGSY4B7o1q8Oa2c/LevDw3BbxxoYiAYFuwPtIA+OYrymcAVHMXiXkJKpoJm1CgTmjXPa3TPqk6vivDBBl6VmjGV8gDfW3XD5QTLRHrzpiLsUJMqYzDFM2XB
 G1YkdN57
 AZrrIKqKTeFsloyQ/deXyE+PHpyQA0tbiBHCkuq5MKoIcqfvKeLsYlrsTU8OxwFGTZIhfJ8i1erShv/zS2wrY+TRbyb4x+8oFDysQ+rhOFL9Y0pDEQH49yOM3nusnRPA0VdzLq4He7sz26mPEt2z+rxJKUoNNodWNM/p5CSbvzhL/KiizgRvZHaNihP+R8/aB0/lkjfeHsRqxNfxFsH5Co9iB0acU7Yi2kIOSdIExtf7UP8Egk701RgCnMj4XwAKPq7RBb6w/amIHUPEmnLN3OwxqGPaIsdSMIhsHGEcZEAifKIUsLMiiDEjybrG6C+di0F8DfuiwVkHaZU8OSkSpX/w+qTU4rx0kuft9xfPYF5Oz5Y0Kv5dc/vgA9+hurPqFms4uNgXvVeRLgjqQ3AhMdp2n3PcCcAtlzHpiQsWoLe92uqE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/10/26 13:34, Christoph Hellwig wrote:
> On Wed, Jun 10, 2026 at 11:54:01AM +0200, David Hildenbrand (Arm) wrote:
>>> Yes.  iov_iter_extract_bvecs and thus the block direct I/O fast path
>>> would instantly benefit from that.
>> The tricky bit for such an interface is that, soon, some pages won't be folios,
>> but we could still end up with non-folio pages in the address space (e.g.,
>> vm_insert_page()) and have to pin+return them. So using folios is not future-proof.
> 
> I'm still doubtful on the "soon" beause of all the issues like this
> in the I/O path.

Yeah, there are a bunch of very hairy things.

> 
>> There are some long-term plans on providing an interface that would abstract how
>> you refcount something you GUP'ed. (because, some pages we GUP in the future
>> might not even have a dedicated refcount, all still fairly unclear). But it's
>> all not really finalized I think.
>>
>> For now, we could expose a folio+page/offset+nr_pages interface, where we,
>> long-term, would not be able to return non-folio pages (e.g., vm_insert_page())
>> and would instead, in the future, fail the request if we stumble over a
>> non-folio thing in the page tables. That sounds reasonable for now.
> 
> I think whatever we're going to use for direct I/O has to also support
> non-folio pages, especially PCI P2P memory.  So coming up with an
> interface that support this ASAP would be helpful.

Yes.

I think we can keep returning pages as long a the unpin interface knows the
right thing to do to unpin them.

> 
>> Another solution would be, exposing page-ranges (e.g., page + nr_pages), whereby
>> we'd say, that all pages in a range belong to the same compound page, and that
>> we took a single reference for all pages in the range. IOW, page_folio() would
>> for now be the same for all pages in a range.
> 
> This does sound like a reasonable short-term improvement.
Right, and as long as callers don't cast the returned thing to a folio, it would
be future proof. But I guess quite some GUP users cast to folios.

Would there be users for a new interface that returns page ranges as described
above, that would want to still unpin stuff partially? E.g., we give them a page
range that belongs to the same folio with only a single pin/reference, but they
would want to logically split that range and unpin pages individually?

-- 
Cheers,

David

