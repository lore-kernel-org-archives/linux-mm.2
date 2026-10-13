Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8BC3BCC6B0E
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 07:40:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 813726B0088; Tue, 13 Oct 2026 03:40:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7C2A86B008A; Tue, 13 Oct 2026 03:40:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6D8A86B0095; Tue, 13 Oct 2026 03:40:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4707A6B0088
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 03:40:06 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4BDFC120A04
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 07:40:04 +0000 (UTC)
X-FDA: 85316804328.20.ABD5A6E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 8186FC0002
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 07:40:02 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ryr1uyc5;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791877202;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ka4WnGpN0d9oCcVY/MuEpnfOHeYeKtz3o+TrxhSWjCo=;
	b=W6xqEiggxU5WpJDF06cU9spPx2U1y11kJ59Yj/fnisdx94eO2hHUe1fAre0yfFTREGVHPo
	ug9/sNLMHlSCZsAjtOVisKdNdGOx7yBDa7pULimJMKM5kcMk7x6o7tNXxgzsAOlDox2d1d
	3i0whOq/WHRmROaiH6vaPeytV4hgXa0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791877202;
	b=ohgpMiPc1XjfJDwv0pmCbJY5gcD4+qPmR1rDT72GrR6MAElVzC5X2ITxS76veM4RA1D/Y5
	dv6DWWiu+xuhXYL/tTBiPxZdSMdyiEJuXON8uOhUou7DVB+eiy3TpLBaBhIgBt8kqmisnz
	gO5gKmYECB1GXpJjkuZWFhMCHCo3R90=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ryr1uyc5;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A66E4436FA;
	Tue, 13 Oct 2026 07:40:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC5B61F000FF;
	Tue, 13 Oct 2026 07:39:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791877201;
	bh=Ka4WnGpN0d9oCcVY/MuEpnfOHeYeKtz3o+TrxhSWjCo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Ryr1uyc5yP/JYFWgvjsKT+2rhhWZifPokb2ZTKhhSwbk3itoTBEivaDIZj6NndAoR
	 sTy6b2LkupMAxc5rFehpkbjqkfGOIK1+0VJTeO3B0xu7K7Kaktg8vpRlhKRjkMHU+I
	 I4Ph5lYJzyqydt1ULvEPikXSD6eupUTUiKmz3i1klD3tn6GXk8iZe/ojaxL3LxA/UF
	 RsXSRdN+MrTyWzF3a3ZMv1+ZQ+1zrZ1QNxGD/EZ6i9EgKaQ1QsuxnYbq0a+Wxld9jj
	 25A0ZRbn9O95WUGGaXfMfVrnugdSC0OhVzh5JfrkiN3hXzwT8sAuq6H28N7ASZ2XKi
	 FWO//HPmJavLw==
Message-ID: <67c30e4c-3576-4ded-a71f-b49075ed42e3@kernel.org>
Date: Tue, 13 Oct 2026 09:39:54 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] selftests/mm: fix uffd move-pmd test crash on 64K base
 page systems
To: Zenghui Yu <zenghui.yu@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, rppt@kernel.org, peterx@redhat.com,
 ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, surenb@google.com,
 mhocko@suse.com
References: <20261011163527.95988-1-zenghui.yu@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261011163527.95988-1-zenghui.yu@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 8186FC0002
X-Stat-Signature: 5wfqnd673aiozuzjfw83cih8nhbmy7o4
X-HE-Tag: 1791877202-835653
X-HE-Meta: U2FsdGVkX194q9/j5kLbktLhMbR77bsK34aeasm/SG3ukJVPnyZJ1KHXUBZJdkBkqxbxpbtCUTvdGB/4ZYGV7Q0wdnvzmLHiXcBxiVC3WqfIklazSb9pr7uLJx3NK7WTAieZOQFVf9f5DqXoSwjTeaixDAhA83wM81b+A7Wxnw9fiVh9hgusypfcBHm8gsqTI12LHx/Ffx8b35kGbpyAJBKS8aOLfiUuvjq8RXQqiyLhs519rEAt+k9+zcyK8O0Qy1HWhjw4mMfC2LT433PBRe8BYOfEg9zonRmSgyaVZMNY2PiD1WE4DTLJR3eaXCBYwkR4FI9TYx2Y6zYwHEQDVLbYQGwLRakXcloTPO2KA90ak5hhJFWEsEb0yj0xqjV6YpfdH449wPHepIijrfcbmnOCksQyQ948Qnkk8be9uiLBYkL7+WEQcI4ApVbSjBLX5wJqJuWOUYlBuJMnqyOr6yE/souCv8fdb4j+GIL5WRZdkfX2XBcaClEbKjlcP1050L3kdxEZFmWv62qEosjWasLxhY+PsvQQm79jZzP0HZFBlW8ppkDSjfqDD0m6xc6IflX71RyabGSyW9yzpUJb84/Rzsp0d5lWvh/SUUCLR3sfiNUdfv2ZVtQ3qphNQzd+Wo5K9M/I4aWxERkLdyMLfD4dLyF4IYjnUR4PxQUjB87ETtlBJO1bHiZvUpzkxrDqpGEczn4lDuTYDGw/h2VwbpYaMsbgUkAHW703/fhKdozeVaXHkxTmuNJnxn8Yj44+xaqStyqTh0aDwOtJcrIrvAlPRDtFZEqwMu0XSnRfwC0BZIBkCtTycP0U4Pk7GAHbiThIkAzZyInJgW+2VrslVeUldCADSgBiwDLZtzs4s91KCEyZhRTge8WGZ3ny8vutuXiR7v7DzjBHNh+T2foueVGfFHtSWe5dKikObvt8Yk6mD/7hnKKtd3J7VXcvEdJL23lanM6u/++0Qc8st6/
 x/1nuW6F
 aSQkeCU3sXffCA0YDg8lyrt+nEeNDtDcGUqGHr1LEU6yrOZklxopnsf82Be09VUHhuyKVQIARsn05/6uoSIau91uPRJlrtUsrJXiCuyuYPRP+227V2yLIpUosPq1+9HjnXAZMuJ+XomLn77rT6sFKlr0OJuyELn5dtF8JX0A1qzLYwx+nfIgtuSKZ7t9wUIOOQ4kscpLKxbgsgSfbveWdF0w/disZqrOrgFDenPPSEwpwavmnqMSwjZobZ7DyXYuBgU9eb4wYfxSvupZ+ljtSzEjsIql3qDynicXs
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/11/26 18:35, Zenghui Yu wrote:
> From: "Zenghui Yu (Huawei)" <zenghui.yu@linux.dev>
> 
> uffd_move_pmd_test()/uffd_move_test_common() splits the test area into
> chunks of chunk_size and moves them one by one.  On arm64 with 64K base
> pages the chunk_size (read_pmd_pagesize()) is 512MB, which is larger than
> the whole 32MB (UFFD_TEST_MEM_SIZE) test area:
> 
>   step_count = nr_pages / (chunk_size / page_size) == 0
> 
> Because chunk_size > page_size, the test then aligns both areas up to
> 512MB, which points far outside of the 32MB mappings, and decrements
> step_count, which underflows to ULONG_MAX.  The verification loop then
> runs away and the first dereference of area_src faults with a SIGSEGV.
> 
> Skip the test when a single chunk cannot fit into the test area.

That leaves 64k untested, though? Why not adjust the chunk size accordingly?

-- 
Cheers,

David

