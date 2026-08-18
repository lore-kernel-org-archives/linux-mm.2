Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9FA85C5DF7D
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 17:25:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 84F306B0734; Tue, 18 Aug 2026 13:25:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8008C6B0735; Tue, 18 Aug 2026 13:25:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 67CCF6B0737; Tue, 18 Aug 2026 13:25:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 324156B0734
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 13:25:45 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A26671401D5
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 17:25:44 +0000 (UTC)
X-FDA: 85115067408.19.9B8EA22
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id D2CA7160008
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 17:25:42 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KKnREi4q;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787073942;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/tRX5gadGxF2TDYvvyHApdMb0Nud4dCL15xxVLvrQqs=;
	b=ieC6VsPQkJJEDNuoMMV+rSQzERre4I09KUd3uzXiSBQqtvD3p5NekqkG/5PrVQIevvxA1i
	xTkNAA43BcPDl0TUS8Sl6PPQObo0r3EkcU2A8WcsoyJ8nwMObZOAVi7Haa3pTLF3aTYPgK
	q8lYqQYYJRZ2LK7CX/jcmcUL6iia/b0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787073942;
	b=hV5EkMBzvS6UV9bE5+Si+jaUafSsH9CWgJU8ttqGTN6RBlSQbcZ/nH/UbwKCdxKOOQeVBw
	x8PRSoIvwkbhKZqDJzaFk9MEfo2mTIuV2deEDhDYEvYCgNrCONe7UDQb8Cgb69iHaNGuOx
	J4B7gQ7lApttKKFJ35BmG+fGy5iv1Fw=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KKnREi4q;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1BAC0434E2;
	Tue, 18 Aug 2026 17:25:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE5371F000E9;
	Tue, 18 Aug 2026 17:25:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787073942;
	bh=/tRX5gadGxF2TDYvvyHApdMb0Nud4dCL15xxVLvrQqs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=KKnREi4qVhs1cPQdDtJRXNlNIIncHan3KC3+WcJvTRXesZ3TH9rRU+AWP9o/oNQFs
	 84EN3gCly/2lP52XrRxXa1qYmuDx9pw6ENIhBrPcvWTYd0pbpgmxCS0C+tcYK8+4C3
	 ET/WibVzGpu1HEF0tcPFrhW973ScvbeeQjiUrk/GaODsKh8hTeTIhJpKjwg7vWSh1F
	 G87Nz/h1O/fLChNcDf4BKW2aleDSySJSp6StLJjzJ+pM5Yjter/WD50Dh3WNP/GnV3
	 59faTBhguy6JJXCyJpd6kTBJVxLJPOHtnW1HjFbm02talOyJARmlStEWzG7OXfrxqt
	 aqVzSoiBKdy5Q==
Message-ID: <a467da8f-7a84-47c0-8172-4f2e23093f79@kernel.org>
Date: Tue, 18 Aug 2026 19:25:31 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC V3 2/8] mm: Stop using pxd_ERROR()
To: Anshuman Khandual <anshuman.khandual@arm.com>, linux-mm@kvack.org,
 akpm@linux-foundation.org
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>, Rich Felker
 <dalias@libc.org>, John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
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
 linux-kernel@vger.kernel.org, Lorenzo Stoakes <ljs@kernel.org>
References: <20260818040041.1891769-1-anshuman.khandual@arm.com>
 <20260818040041.1891769-3-anshuman.khandual@arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260818040041.1891769-3-anshuman.khandual@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: smyafzoyzy56qtkez6or4q7kohfcnymx
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: D2CA7160008
X-HE-Tag: 1787073942-199294
X-HE-Meta: U2FsdGVkX1+QHzDNMv7SMAc2rRAyNyU/U9QNtgEbLDR9FwKSe54AssZ6x9lMt7EeBEu22uxF92UTFQkCSW1hUJczyv+Z1mzOlf9DkZ6M+rZwugKKYy01Ay8fZR1NP5VisNU5zILUWrrVgnmKRJWB+aOwRnnJiuTuU8bBxOB8S9C00JtY8QXtlGZECJzdmxmCc6MTM0DBUfoINYe/PcoJZtmOQdbF90rlQpAa4G1UIKIc/AuMWbsYRfZp+IpT7QVwpdhN7lPM9XhoTF+gfQByMmKcPlmIEY0eOIPOt6uXb0MPEcJ4uhh7l49N0EzpxMW7iGq7QLfPT0TGTx8FA818nZFBWkYUj+CcIy6Ru43hSnWhbHBWm8oHfhOXwvS8sJQl5FIkHsy/8m8Z5S8VrU7LfzXQ7BRJxO0Y7TaW7xmnfmB4+oLawzsoEDnQjic+ufHt4cSKbWVus/B+hb6wRds2Ki2a6Cwpnjz49GjoHgI+tfUwjdd/3u++vY9NwhUtAN35At6l96s30pRj+jHruD9d80axpJM8kcYB26QrhDgymCcEWT4xB+nPd3gj8KoVVvsyGHfbO+bDvZ9ex+vi+XPsgj3mQP73eavMyqo6IuPUefS7jy2+37ke0oaR1AZ2acI0tbB8OYLnItEpZWobmOpFvkEqSqA/gcAeYMtbX+xPX/tkfJM9faiDPMX/2xuvHv3z5jHeTZ4SkqiLOeSAw5p3vfFNZUte5Ump/Lk9FXvWKE/lK0FAX7oWu2mEg/V0/H2+h05BM9OLAIPYrUhneEaaQd4N/hrdQR0qTvgDEeE9+wNMdLEyBEEA1peg0XHdZaO+w9oAj4cCsgnO4EhFnGyZdAN22BUsa0yEMRttBGq8YniCDCgRVSWqwtoDZqO7cvoJqAkU133uXYmQrSR++oiKycr6bkU3n3U52yasa/eTF9U5adbvSY4pSWVLDU6bxB4asN0S/LtR3oCYsf9aS8s
 zCEVrLg8
 d11QxfxnZrI59XAN5e6z0MZm1QQZRZDCLEBM8e0t7X0nVNOxVXKNxLZe9ZZYMWqBs3A+uXN3uqytqwsaBCNko4Y6cN9sOEVdQr+zTFlqS0XCqy1TY4i8SJOvM2HTba4uXvrlyOhCqWW0w6Yozb6oIxdkfQdzar2Ye811OTwgS2DyKd7GNdyhCytvi1VGbCTQRWKfZaSOYBB64XZC46/32UZtnli/hYm+hBhsumRBOyx3f8FTEAIKu/j7j/pD69MAMoO4Fe5PwHt38YCJEARvNXaZDh0SBMDl3BkfZ3udbBk/LVT6YlRrhHMXW1D33GdGf2MhQvEUjGnfnjDsG6FMQAP4xKJ6YaOk8BSLM0kQntievZ5NVtTCKDsPK3VWk8mrqEZLlG/y01Y06zEDImgIRhKAFQVoeJDcHORpYE8nIs+T/yk9055Pu1cKGo6LQnkcNasS5HzNdPZQ0Ki9jbDCKKugLpQDI891x1XcBmwXV0lWLZr21dC977X7zrbLdwoXO2f+PPMUvLtjhTGsb2XbQwEFTc6WvOzov0a/tHOBTQfeOqvVk0bNFCzfioTFjfRpRK9+JsO6kVJjJjzw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/18/26 06:00, Anshuman Khandual wrote:
> pxd_ERROR() has been used in generic mm just to print the page table entry
> in pxd_clear_bad() before clearing those out with pxd_clear() later. These
> pxd_ERROR() macros have been provided by all platforms which basically did
> the same thing.
> 
> Make pxd_clear_bad() use recently added ptval_to_str() instead for printing
> page table entries thus completely dropping dependency on platform provided
> pxd_ERROR() macros which can then be dropped off later on.
> 
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: David Hildenbrand <david@kernel.org>
> Cc: Lorenzo Stoakes <ljs@kernel.org>
> Cc: linux-mm@kvack.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
> ---

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

