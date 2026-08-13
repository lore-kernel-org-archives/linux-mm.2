Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C6873C5DF65
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 07:18:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B985E6B03D7; Thu, 13 Aug 2026 03:18:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B703E6B03D8; Thu, 13 Aug 2026 03:18:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A60B96B03D9; Thu, 13 Aug 2026 03:18:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 81E876B03D7
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 03:18:55 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 08E4A12056E
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 07:18:55 +0000 (UTC)
X-FDA: 85095394230.06.20B6820
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 443F7120003
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 07:18:53 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LQoW8GUU;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786605533;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FRu9n4mjHkdLoh1auc0+F0uq9mi4uQgSH6ITAa/iuvU=;
	b=a45ibDYILKyz33h402YR8EPZ1rlifncA1wYjc2dcTRh9gLlJ0vlIaqiDjexE0ksZxmiH9Q
	YnuR/nDEKhMSEmo98XllcVE9bKId90UcSfmoxJJJh8uQGRLsZdp4k+ROYZRfmzX9T59kVb
	mIs+XeAsRWbOX/TmL12lqr0o36zZ01s=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LQoW8GUU;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786605533;
	b=TslFh+6ccf5jhK8ShKtl7kZIr6c5w/x6ylXczSzM9oSmcdxp7dJSF1NNNmij7Sbdz8y6/V
	ebPWsWrEoJ+3MaaZZaSLqkuSbZL2ldPA/SOu9hImDgwA4fbWf3+3ALpXp4LEE3vfAScM7y
	+bGEEZmw/wbTp30jzsx3zDyqEQwuces=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6A282600AD;
	Thu, 13 Aug 2026 07:18:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF6D91F00A3D;
	Thu, 13 Aug 2026 07:18:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786605532;
	bh=FRu9n4mjHkdLoh1auc0+F0uq9mi4uQgSH6ITAa/iuvU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=LQoW8GUUyQqsjsyMSCymikLCl0K/PpYaTCtOqE8smOcqa2DMyAwkHJlcjWeM1J3S+
	 p7F7YTHDWjjGCL63HV5xpWRhAdsFHo0ku3RZp+dd7ECs9spcYVoBm+vyaaylpUF+PD
	 H22qTcfvj4D5oNy89mJR0hbJjegsfONgrwhHmtzF+bBi+aGhDM9oGd0P2xzEDI2kou
	 1E0HF2+DNVjJvv6cBBocYB1eb2SJm99VpExDuZUltvNNZREs8uFacDqc0tyd8Vhkzr
	 RtyNl40a3quN8bMMpCL9V3232v/KWwZovejB57bX78GVNpy/nQciclUW97AqYJJX/W
	 0jrUTV5cHJu/Q==
Message-ID: <fc404670-7194-4ae9-8646-b543869738f3@kernel.org>
Date: Thu, 13 Aug 2026 09:18:43 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC V2 6/6] mm: Drop pxd_ERROR()
To: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org,
 Yoshinori Sato <ysato@users.sourceforge.jp>, Rich Felker <dalias@libc.org>,
 John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
 "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
 Helge Deller <deller@gmx.de>, Huacai Chen <chenhuacai@kernel.org>,
 WANG Xuerui <kernel@xen0n.name>, linux-alpha@vger.kernel.org,
 linux-snps-arc@lists.infradead.org, linux-arm-kernel@lists.infradead.org,
 linux-csky@vger.kernel.org, linux-hexagon@vger.kernel.org,
 loongarch@lists.linux.dev, linux-m68k@lists.linux-m68k.org,
 linux-mips@vger.kernel.org, linux-openrisc@vger.kernel.org,
 linux-parisc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
 linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
 linux-sh@vger.kernel.org, sparclinux@vger.kernel.org,
 linux-um@lists.infradead.org, linux-arch@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260811042119.3652929-1-anshuman.khandual@arm.com>
 <20260811042119.3652929-7-anshuman.khandual@arm.com>
 <1fb9ed88-67d0-4ac1-878d-0dc8e1135d19@kernel.org>
 <2ys7apbnfuj3ugfoqgbptgej3jjcyfpmdgbv6qbxupmwg6mefc@h5p33ua2nzlu>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <2ys7apbnfuj3ugfoqgbptgej3jjcyfpmdgbv6qbxupmwg6mefc@h5p33ua2nzlu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 443F7120003
X-Stat-Signature: q68ow9nwzqrsfoxshqc9efzmfwxnmfg8
X-Rspam-User: 
X-HE-Tag: 1786605533-52822
X-HE-Meta: U2FsdGVkX19HFUMHl/nBKvlryxi6JNbJDGakaeuCZtpkHiCWdh0QAI89ODFYX5iDKFrWR5mUbmwm98rgGr14UIukQMTr/hExPKdy1iHIUQ45uSUVVOdswrxgjKUjMyxdR9DKc1PJ2zfwDPrauEYpY7qeF9Im0M4tq/COtfbb1vf64ufC/LcJdVgRJXM4iCzT76+gRv5FbRZpKGqYv58EBXM+XwvXLMSc/28E6Upz37M2QVIPEQxnHKle9A+5Gu2WDcjnvTlw2kViaVk/hjVgLa4Ebaz6F4VDnRmQafxeAb1GW4qwUfUcYhnPekdgluIaTHDYbRVJIuwxT4JoI0ozHFGU0DGcXimkdKXxvTBTYP3YZb6wG2bmXUNC8hUKpy3mkyTDY2ThRufystPHAQ5KqHszwxKUxVSkIYl+yj+X0iM7azZUdA+sA2VMzOcXK+HeWUSbB4WDevKx8jEhR8V75UXI/5tU34FqpGF8A9yT93RIkbF11aVTah6/ZxZkumf8IWRDr163y0KunPNBzBYidvXqDsT3X5QqkCAOfPzyZ8ksY2rjVBZjBbHtOn+ax+dvDZmb84NRi0SWBCsWUQ5Y08px2vuIW1+4vVHLPv9minvC6VrPt6cvbqo5rQcs94en3kMFagOblZ5C/6+NQPinqvlREHXj8HK5oUHFH8KgUkKHz21BgRBpyw2bal5x+1BtTqmR7c3mML4GGiQw/xmgoPgTSORZ4niyWZ6BrbgcpM263VEoBvuolSbLpOYXr3g2jLP2NDlPeSLvHbiLWPkyO65NM0LmYMwyfdw/0aABuOW7xm93uFXOn1oMr/geeel9uieqxqt8F0XXbtWjaXjUJ0KWlYORu8/h2OK7/YtLNsD/F2cezVRsxQlPUsd+TiuWyZ6oBMdCJ2S4NzBAlQ7NZdmXr6jBVfEm4tXdJu9wcygn9UKk8P7kvYcShcAnk2uQy17g83DH0/hlWsM/QHM
 i/eQOC/4
 4yxaRt0ZbXLC9eOGz+hbUAgl4RvAWnJJaU61mnhMpgnlViqrWc24iSB/JyWYn/4eZSSioPrxpw+66totX1L6VRgNfNn8TrM/R3sLdVPeZxdPkIbkzzFtOBy7IkZi4CgCk8SnD7IOsHqSVjbgj+xOuTkaeXNYvqu+Gt1EqM1uYpEQ6GbVbAkqkdvCDBQa6RwM8x4R575r+7QLKv/BynjduCfdNNetvh5Mvy+GMKcTQSwinBzHltGk7kPwlkdnoXWyNl4gSX98jQMlI4B5WNb3DA4tgx7DyqfTe2o6mwnsIzLfSHQOHiZ5oqsuronLpR4vYm6GYb6o6TuLPKJsaiYCYTCk9RFazB0X7jkpZb+UrmwSJtYL7Q2krZymrg7aoUw4RQpbM
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/13/26 08:03, Anshuman Khandual wrote:
> On Wed, Aug 12, 2026 at 01:33:14PM +0200, David Hildenbrand (Arm) wrote:
>> On 8/11/26 06:21, Anshuman Khandual wrote:
>>> pxd_ERROR() has been used in generic mm just to print the page table entry
>>> in pxd_clear_bad() before clearing those out with pxd_clear() later. These
>>> pxd_ERROR() macros have been provided by all platforms which basically did
>>> the same thing.
>>>
>>> Make pxd_clear_bad() use recently added ptval_to_str() instead for printing
>>> page table entries thus completely dropping dependency on platform provided
>>> pxd_ERROR() macros which can then be dropped off. First move all required
>>> helpers in core MM into a header file which could then be used else where.
>>>
>>
>> It might make sense to split this patch further up to ease review:
>>
>> Patch 1) provide ptval_to_str() a header.
>>
>> Patch 2) Stop using pxd_ERROR() and friends in common code, converting to
>> pteval_to_str()
>>
>> Patch 3) Remove now unused pxd_ERROR() and friends from arch code.
> 
> Sure but the intiial platform changes which now use ptval_to_str() as well
> will probably come after the Patch (2) but before the Patch (3).

Exactly :)

-- 
Cheers,

David

