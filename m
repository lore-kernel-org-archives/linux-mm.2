Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C4F7ACD98C7
	for <linux-mm@archiver.kernel.org>; Wed, 10 Jun 2026 18:45:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 342936B0093; Wed, 10 Jun 2026 14:45:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 319816B0095; Wed, 10 Jun 2026 14:45:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 22F9F6B0096; Wed, 10 Jun 2026 14:45:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 15F9E6B0093
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 14:45:52 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0898CA027A
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 18:45:49 +0000 (UTC)
X-FDA: 84864882060.04.68D0028
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 19D594000D
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 18:45:47 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ffxOLSon;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781117148;
	b=CKIROkYNk6s6rXVtPKKO29sD5lEUqSl0S0X4YVXdSK4QeQxl/j4tNHrLeNDSMADdayQPBm
	xU31/I7+WH5og1mqaCZvlbVpi8MOHi4sAa6OcF+cwdy1SmCjHTMi3r5etdmN1wdkikm0K3
	dMV2vymGL9MzOKMKcMWeNYGaVlp54uE=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ffxOLSon;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781117148;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CdwshvM9ZlryXVSDDelKO7PEGUTQ/phxdGshSPOhRig=;
	b=xbQSy24FiPtnDESHov5T2bfSzYJbXQz7mKux5j+MKn3xEyDzvQhoxJZ3gU57Hv6vPP+toP
	ODk+eByJCatWIqaetlkBSBzaqSEUrUf8RKOtGzFdRWvto0Um/hfoYe1fIk3xmLT4HkKPgs
	9pYdzzxLHMEm68KVosyNrjrTWzRIAh8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1F8C7402BF;
	Wed, 10 Jun 2026 18:45:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BDA51F00893;
	Wed, 10 Jun 2026 18:45:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781117147;
	bh=CdwshvM9ZlryXVSDDelKO7PEGUTQ/phxdGshSPOhRig=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=ffxOLSonZmlgW6xII3PiZD7CERx2Ps3q2e1v0oG69HTGO4OiPSe51WjWmsPgzu8Th
	 Kqh3oxBhjyUEl2P5TlDNGkIQAE9ddoGRhd5fnx+1wyJKmH1H9o0f5t325L9wEF+Bde
	 NxLaJdI8IYFU3NUzKHRIPoTgpENSo0ntah0QwnDPjvG5vRIL29rzUCHFPji7ld4U5C
	 Y9tvZau3HfQJj3Nq3TdvKtowQSyS3IIsccQZ90bUwTCMFm967oidD5+DsLJdEJK65G
	 5LJTZWv9kFEzdHNeJbt4uM530l7EE+UrZzic7klpYSDrGHPfVv9zgIcSi9rhd0MR4t
	 FEp3oANNNH7Bw==
Message-ID: <8c47b58d-9ff0-499e-a629-b9cf76186db6@kernel.org>
Date: Wed, 10 Jun 2026 20:45:40 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC v1] io_uring/rsrc: add fast path huge page handling in
 buffer registration
To: Matthew Wilcox <willy@infradead.org>
Cc: Christoph Hellwig <hch@infradead.org>, sw.prabhu6@gmail.com,
 axboe@kernel.dk, io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
 dave@stgolabs.net, dongjoo.seo1@samsung.com,
 Swarna Prabhu <s.prabhu@samsung.com>, "linux-mm@kvack.org"
 <linux-mm@kvack.org>, Zi Yan <ziy@nvidia.com>
References: <20260608062937.804758-1-sw.prabhu6@gmail.com>
 <c924fb59-be47-4fa5-adbf-a50a831ccd7b@kernel.org>
 <aikBIESiJftxBdfL@infradead.org>
 <f2b5189f-10de-4685-97f3-6ee08d159743@kernel.org>
 <ailLu70plC9WK2dB@infradead.org>
 <d80bb796-3cac-4de2-8bc2-cc799e5bbeb1@kernel.org>
 <aimor-73_1ij8Nbx@casper.infradead.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <aimor-73_1ij8Nbx@casper.infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 19D594000D
X-Rspam-User: 
X-Stat-Signature: pmzbt1xarumetem399uyb4ii78mh6ixp
X-HE-Tag: 1781117147-211816
X-HE-Meta: U2FsdGVkX18BpgYo4I55aKv/mZs3Q0U5+9SK8Rme02JzkXBKzU6vg3wW6v/J5KKMMfzf7Kuyv8fyFuHmMNWDV9pAC1ClIr7hWApaQ2g+vfu6eXyBLwELdQv4zzJjcyhhn6mok0y7oqYUm5tfmBAUHyiOyzo7KlZDibP34HXEwmni3mYCDZqfEY4UgF9GbpgSq8z8ocEDNgD40xlj6fravjb9Ja0Rn/V2B8hIWb51vE5PI5iIYiABVUX8uN5kXjZlx5JVrWgl5O9OS9hgw+dpbABSqkJXuYaXOHAYov3CHV96wKy3gjyJmb8D5fBdvCmHMURV7nXksnI+ZuxK0Id26BzpMaatXdSSvo94I11cCuIV9Hn5CFCFeIe+J+/O9eJDumQH+heR89L0wmkIjkmtj8MT3R1PseInrmbY0DuvtU0VFBQjxG3jRnflI5JfNgVX9S+9VdvHkGozye1Lp6fkz0B7FlkGTjW8CTR9hmyPtJTs9erbLu8G2ICuNce7yAChLktfztpM0YHNhwBbtO5VN8GMVVn+aAUZ7xSlOsDPWF6bKfoZIrHlc3NBGLVx55JO7rVf4CMmB5L0/brnvK2Z/1U8kFnTfXEiAVXGbO6n1HVuNbWPnr1E3U8rCDDnY8/GI9GnRhFZYhqHxwAhin5PeRd27SayOcXgvtzWovQdNaO9i0g0ZoSFtREc++1pGQp4ZRFe/Gg8NekBvzhIt7LSkTSON7LNyXUt1DI8990K9x3aJbR9FomQj0oONTDaCVulm7bYgFdyXl5lWdritHQwWmnM/Tvua3Q18cCP4mJq7MRh8bmPg9XE7834Wk/NGFh5MZDZCwAs/BID2V5N/D+PZogH21H4IyJtxVi8gN1Ui9sBo3wknTBBB168BpFWAxTjr9s4zFpUbWBy27HkDJeGr3cQ6so0PnrfBXZZZ/CQ9OmRjDMX9/vC8Te6NMGkkv4jVWHGn8tE34PNiwDqSgt
 5OPBi5Vg
 lfAI/7DelBtOd+kwTYCZEyiZA+jWQ5C5q2uW/bDRTbnjIwM7ZfnKfE2q9pgAp52EPK0K/6smLJakPwJmClp+j9sMXzxz7x7VR4SjPGIZcoxYiemNpMxRx5M01iDf3HYYeajd0Y4UlgwDwfJ0sc9/24O2x7BFMscqfj60QY8rNm4X7v121GoFwDJpXrv04K+x+2LZJQHOMoWqxp8CcfTSwDYkwIHLmrmkJ1wNdMIkvNysSREcQ31ZjMUTOQyy/fj/g4yFpJFsfT2xXa5bONF64i6pZDKwLLa1siClmVGpPJNfJGcfRRWtMiHF093cbLM9KimKHqawwAQJ7QsZr1pqmInaK9z4tQwkF1QZexITB8bk+rb3BGo2u5rzCVPOBvCe1zpZ265Q4ZR/IVyWQLXhv4BDdcxAf0UN7YOO3fLDmffvXcl6lXO09l7bqIFF1Z3Wo+9u0DczCq8Vkw+EBeAC+2PygUQkBvanpiNJMTqSBBlkND0w8TtYH1pK5qLG0hSHEB91E
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/10/26 20:10, Matthew Wilcox wrote:
> On Wed, Jun 10, 2026 at 03:18:52PM +0200, David Hildenbrand (Arm) wrote:
>> On 6/10/26 13:34, Christoph Hellwig wrote:
>>>
>>> I think whatever we're going to use for direct I/O has to also support
>>> non-folio pages, especially PCI P2P memory.  So coming up with an
>>> interface that support this ASAP would be helpful.
>>
>> Yes.
>>
>> I think we can keep returning pages as long a the unpin interface knows the
>> right thing to do to unpin them.
> 
> This would be the get_user_phyrs() interface I've talked about before.
> 
> https://lore.kernel.org/all/ZbVO2RKhw-dLUMvf@casper.infradead.org/
> and the long thread:
> https://lore.kernel.org/all/YdyKWeU0HTv8m7wD@casper.infradead.org/
> 
>> Would there be users for a new interface that returns page ranges as described
>> above, that would want to still unpin stuff partially? E.g., we give them a page
>> range that belongs to the same folio with only a single pin/reference, but they
>> would want to logically split that range and unpin pages individually?
> 
> Urgh, no, we shouldn't do that.  ranges should be pinned / unpinned
> as a whole.  I'm sympathetic to "for this special operation we need to
> create a new range from this existing range and adjust the refcount(s)
> appropriately so each of the two rangees can be put separately", but
> I'm not sympathetic to "we need to allow each page to be individually
> refcounted".

Yes, me too. I wanted to understand if that a common thing to happen for users,
such that we would have to worry about it right from the start.

-- 
Cheers,

David

