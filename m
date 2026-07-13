Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 43CC5C43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 12:32:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3A71C6B0093; Mon, 13 Jul 2026 08:32:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 37F296B0095; Mon, 13 Jul 2026 08:32:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 297DA6B0096; Mon, 13 Jul 2026 08:32:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 071E56B0093
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 08:32:03 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8471E8723C
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 12:32:03 +0000 (UTC)
X-FDA: 84983690526.27.71A5B15
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id A7B272000F
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 12:32:01 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BJTA3fsA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783945921;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f2s4QpjmJAAS/52b9gJSrF4I8uuV84Illo1iNwaFgkA=;
	b=gnZJOJxx/DOgCGZsVqkBJk4ZFqe5yambITCGKcqaaFKpHZakl+G+kGAPuDuE5/u8qRtUCn
	4ndyyonlAzXj3AYoMKYmBtaxSRtpn90jO//as0O7tz3bMeUhZWUO3klH6CwC0NoyZdfLK5
	Ggmk98lYNslkzp4juJmlXpw8LbnW87g=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BJTA3fsA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783945921;
	b=f1El5FU0S1zzSk7wgmmiHCFFFEijOooqDdEU6HEQdl6BDzzb+h9jt8IBcsewIe+cu2HXZI
	57tcgFwYVbchA8iSyeqqP7YvQcbDNNmITv0wtEarninsbUS/l71OCGfJuLil859YNUV+Cf
	gpFFrMPy4YJHKMz0b4mpup5ZMlARxEw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B04C441F95;
	Mon, 13 Jul 2026 12:32:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2626D1F000E9;
	Mon, 13 Jul 2026 12:31:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783945920;
	bh=f2s4QpjmJAAS/52b9gJSrF4I8uuV84Illo1iNwaFgkA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=BJTA3fsAogCtMFbBSK3XGA2W200R+QerBbI3i6PL3ilh4IZoyUNvFRBaszTcTVvfM
	 HGNK4ClG94WUL5lro/i9ndO0K5Xq4LjJ8omIdzIiLkdNjzTMydYu3LYuwh9r3HGWic
	 fwcG2OmZVTPFQU+Zci35fgGZbRHBok7JGlv6X2TPPetILIu9lhxR3SzTlZdxNjtXoq
	 uxfbaSoKPZDQH39qvab/0v65iWtxzOwQ8cVT0ZYSQCPIz9EOd8i5NW9DPgzx7j1ChT
	 e7u2vvauVyCz7c6sCiWVbQ+vBACxpSIUX0/KR/YX+qZws1dOr9B3LPZcQQMqn1YQ63
	 BvW3RdarMWObw==
Message-ID: <466def52-4662-46d3-8787-8b7cd8a54288@kernel.org>
Date: Mon, 13 Jul 2026 14:31:57 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V3] mm: Standardize printing for pgtable entries
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>,
 Matthew Wilcox <willy@infradead.org>, linux-mm@kvack.org,
 usama.arif@linux.dev, hughd@google.com, ryan.roberts@arm.com,
 Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
References: <20260709044334.1741263-1-anshuman.khandual@arm.com>
 <alHNjbiWFYXSPZtY@casper.infradead.org>
 <5ee8783e-4deb-48fc-a4c4-96b02d79a6cb@arm.com>
 <e0421ba6-82a5-4c88-b5db-23231c265142@kernel.org>
 <alTN0i6XgnI_eDoh@ashevche-desk.local>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <alTN0i6XgnI_eDoh@ashevche-desk.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: A7B272000F
X-Stat-Signature: yuq5jkajbnme7yi5z9snspwhfwuhykb1
X-Rspam-User: 
X-HE-Tag: 1783945921-258953
X-HE-Meta: U2FsdGVkX1/Xf3t4l1PkjsAy4XI4PTFVGe+FG9t9Cg6uQDHrF57sDlorVx8av2xfjHblwZMfS7WMHAmSICS4QBqBQikc6UKlmhyEPfpUdURboahq/1fyV5Kk7qYowEm+RcdOOFchJM8bDwsGr7Z88a/J6K1We3nSM/xlfEo4Zc7DNTazFc2d5k1u9efuN55tWg0auPcOq/2ytrleH1cd6oS32rHeTmqDa9hBxPYUoSm2812rALz2Dpem356Rpe9Raa86LDvu6w7JMC0xX56TNrowvQqy+7CB68HZ9PLbPREcpp1SU7yYQS+dbNwqWUaqLwyylak2uiCNJyoXirvTeGaWhL5Y+NwhoVdef3n8w9sLKcCjniGZHcwVoVk3zAyVo/ZAOpzqICksStFRlKnXBOfWEk9DoiaaAbth0wR4WfmPDm2w4Yz1YOpDTHbF8R2INoTHINrmL7M2wAqDgPi9hGNYvrpHH+zpIitFCOmz4UT4v06v0rG+gFxm7lL9IzTK77QaaSsmuUCGQFfkD5rqVO7V2uCcGgwZyRFCYh2TGyIfXZCUObGrwSlhgzwrHtc8knMTgbmE3DnxO0jZ3Dr27J7TzlKE74C/nfKq8Wp+EP9ToGDcxdSCGjdAwv+w9F1IPMuLI5bL4M4/8c5qpTfovLawAmYHahRDHbJ/x0tgIPzgadhvk04efIzJJy6tv2zXw1xFkqSHWKQ50mQWN3tdQjz0QCi1GTu0PimsMDxKtoqlJb7+Pmb1GML+jFbwD4Y/zVLtWjuUmy3+jr/ElW2yQDdQCxpHPREv4A6zvgmQSgcKN8tO2yyT2DtM8JASbr/7fpf87F7ukkr/L260SV1nC9NNk9uQc+ciBYjqlcvNLPZkyPTmkauVXCQ/KzNhSylxrm2SIj5F2BxOcjFDPcGqSa4TUO3aZbJzNHsNlreHcCI+OzNt4ZJT9qP3K2Cb7n49oL1g+xDMxtclBVC46JB
 9vyIAJMe
 +4IV3ZEMUpaIm3CXjDLp6dNye1tzkS5aaiMFhdpKG0bPvuPeksePURbXRTQjHQvYC7rKXJEZ0MIM8K0Uy09jGzlqF8hzbvjsPrhCRdbSjDnXw2cKE4YqBdZCqnx2B3Nq8cbS76w2nK31Cw/7x1QSqjOEm6GJs/f3UyXG2WJvCJ+d4EkwGxa2NCnbmQUchJXZBlFeQqr6Hfe5hnnkDWcLWx5dvbEzds8Bc+/e1LqM7lxhr+uPo9toyTNxg8LPfQa/bV6o2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/13/26 13:36, Andy Shevchenko wrote:
> On Mon, Jul 13, 2026 at 11:30:08AM +0200, David Hildenbrand (Arm) wrote:
>> On 7/13/26 04:37, Anshuman Khandual wrote:
> 
> ...
> 
>>>
>>> %*phN dumps raw memory bytes and will have different formats on little
>>> vs big endian platforms which is not desired here. Debug print here is
>>> expected to report pgtable entry canonical value where various platform
>>> specific fields can be inspected.
>>
>> If we'd want to go that route I guess we'd have to add a new specifier that will
>> print the pointed number in the size specified by the second argument. We could
>> start by supporting 8/16/32/64/128 bit only, no weird stuff in between.
> 
> FWIW, we have hex_dump_to_buffer() for that already.
> 

Right,

	@groupsize: number of bytes to print at a time (1, 2, 4, 8; default = 1)

Does the trick and would have to be extended to 16 if we'd want to print 128bit
pte values in the future.

-- 
Cheers,

David

