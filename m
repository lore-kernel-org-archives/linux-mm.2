Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1029FC5DF61
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 11:33:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DA8566B0169; Wed, 12 Aug 2026 07:33:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D7F2F6B016B; Wed, 12 Aug 2026 07:33:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C702F6B016C; Wed, 12 Aug 2026 07:33:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9EA216B0169
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 07:33:31 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id AE781A024A
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 11:33:24 +0000 (UTC)
X-FDA: 85092406728.01.CBC92E1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id E1FAC40003
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 11:33:22 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WAfmOkkk;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786534403;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KYWG47sp8qKZimjrJ8C8fF2yBpjkop0LZO2aPuIaAlo=;
	b=Z4SjE1GZyTZV41ZswLJRiks7BcZOsE5TX9rdgrKaCKMT9sI7/ICaZeUrkRE4Bp96UAlBXT
	Em2kU+C/Wg0xCH57CxfrDHbxmftEFsyShjE7WnhB17rUFbswA0OTPCR6tIRSqrBLXXThs6
	jKlONKR4ABHuLO4tTkGe39ZVjv71bys=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WAfmOkkk;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786534403;
	b=df7Nt9DEwEiGLcrVhQD/j4jFDWG2YmN8HPA55jnSleX1cJX1KkhtQlx+af2+xLNRplzIB/
	syiMXJgWisoaj+pKgsN9peU4YAy1feVwZTkqgFCn3ARB5OXPE5ZHUJtvb/vxgKkhdCH8V5
	NHoihwjRz00npyraKWDrWwoBx4nB4s8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 227154168A;
	Wed, 12 Aug 2026 11:33:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01A4B1F000E9;
	Wed, 12 Aug 2026 11:33:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786534402;
	bh=KYWG47sp8qKZimjrJ8C8fF2yBpjkop0LZO2aPuIaAlo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=WAfmOkkk8L6CsdaEyBcNrtXtVZNzObzW4S7aHcGWWKcuSHhZgMshz38NRWFsMIuro
	 iQNzIOLVcCtVng/Y3s/5/8QQm7aRpslgEDM4EaOx+RrrhQu2QK6SJf1mYWLf0u+bIk
	 mHgiI8kvImWzfFTKqNN3Q3uzw8gwmf2aEibx251l3EhnWebAqUXVi2yCauOG2EpYpk
	 qT55BhQsRkzxVJJnOePDFfawyaPzcJ7biVmiXgaHLbICFQsgUR8tlkUIpE02A31EaL
	 b2GxECR3H98e20PTqvhqig2eBGcYR+8QrQPpKISBdK8go4PyjRDC3+9XMOlZC8fnyy
	 vp3RCZx1qSNlA==
Message-ID: <1fb9ed88-67d0-4ac1-878d-0dc8e1135d19@kernel.org>
Date: Wed, 12 Aug 2026 13:33:14 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC V2 6/6] mm: Drop pxd_ERROR()
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
 linux-kernel@vger.kernel.org
References: <20260811042119.3652929-1-anshuman.khandual@arm.com>
 <20260811042119.3652929-7-anshuman.khandual@arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260811042119.3652929-7-anshuman.khandual@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: E1FAC40003
X-Stat-Signature: r7bq9gqda4eh1hy7cwz5g4ctgz4i7npp
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1786534402-529227
X-HE-Meta: U2FsdGVkX1/1atZrRfazTx7GX8o+AwmRapnVx1hy1+jDJz2gv60HoCTc5kNh8y8YMZNUF+HlEx/xUNozKmvXrkCdk8p7yibrx7wO86UMOFT72oJP7A9fLm0b0AE/f+QldAMmie1k8a40K+6uW7svCjtZPegfm9LvECdJ3p9KSiN4tZG5I5cHR/P7pHJFY8xc29NZZQZ4eRIbb4NDzc/HulLXfFZH6aAWJxc+Yk3pPfl1RxC3EcQlpv+ox31wn7GmyB+gdaJH0eqaOM0YoLj9rL8yVkgqHPkCZpZLBQjYAMsgRoWak6CM8pgPnM0EPAa9kSgRLuRPWl0Viuq0lCdMwNB3wZcwwgcqmYvVeUkZDIFUsrL1A1Lj6xU8WRGbSSrLvIWSggSPsANk42IkffBiDBALPoIAfzfAHf9j3ISyD8WngWLQygDN4gXdoeeJeZ5/Jm7vZ1FBvb/K3DeS+MflQmw+ZA0uPUj4xcEAEKsUefW4qMYAAbS+DU4O1Q5q71f718WMdGNOS3ceOK1DqU9v+BSyhuqv77OmPq9CAeYOtGA8JokdL6UhdQOtI+Zkxty6Wd0Y+s955cdXO/O4yg2q/iv7/lg0mhbwp8fACShCAhr04lGbF4IpSotXO0/Z4LAUWVGCVmc9p6TRoSy79RfNDTQ2xErYH+5T6KNaKYmKQRSPsJ7/xMnNiUfviUTBntBFYoLNuXRy/N/zu0RgLttsM8LW9H+lozfvEPx4ayNj1sazA+UZ2XPlOR/YIOJMAqtehWvRlp4sy4zepNGy+XaxEgAXaUBvcSppxzrwDu8ii4lPCI9qOzIYE7vGtJe2yUdy6O3Ot5oRWB8PELlbD/SO2tG1WvqBW9nBAcS8EExbwSFnvOc7lMYOsorVZGzSTsrweWSLahFqtz4kRCNMBWXkEtB9Cq9hMRVIVHqtJ6EUcUwW5zUkXTBgY0Ug9HuLQEghiijBWYjQbITycE/jx2w
 qIWi5Q+o
 ShY8r4ZczwlowyXzOlEebzmAV5siwf2XrKkMW477pY4F41sFC3dahMW9Ksy4Gu8uxLbvu0T1p7svd0dFJX1x08YYrgbXaj97opRR+Uz83kXTl2rVl1zqthSUOvOZOk0H5I03HmudDovkmYVkqgRHIfbgbjQc85LsGcs2iRyE/Xa7wxH5ArGwg9Wr22AvwHogoddMYEHH9MLMNcKiNGIQaqPuZUl5WHfXXHloOs6S+oR7UndPwq2h/eNM42AMW9zxECHBRzoWqros/rIbRVbINY+Dpn1yNZp1cgrtm83R1JSWcegaiJgvY6eTngETa6vIw/+3JWteFeg/iWaOsQ0stpVTPwfKefg/8E1PEWw0F8bVW2M40lfyU6Ammn1D0pxXiHUZv
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/11/26 06:21, Anshuman Khandual wrote:
> pxd_ERROR() has been used in generic mm just to print the page table entry
> in pxd_clear_bad() before clearing those out with pxd_clear() later. These
> pxd_ERROR() macros have been provided by all platforms which basically did
> the same thing.
> 
> Make pxd_clear_bad() use recently added ptval_to_str() instead for printing
> page table entries thus completely dropping dependency on platform provided
> pxd_ERROR() macros which can then be dropped off. First move all required
> helpers in core MM into a header file which could then be used else where.
> 

It might make sense to split this patch further up to ease review:

Patch 1) provide ptval_to_str() a header.

Patch 2) Stop using pxd_ERROR() and friends in common code, converting to
pteval_to_str()

Patch 3) Remove now unused pxd_ERROR() and friends from arch code.

...
> +static inline void
> +ptval_bytes_to_hex_str(char *buf, size_t buf_size, const void *entry, size_t entry_size)
> +{
> +	if (WARN_ON_ONCE(buf_size < entry_size * 2 + 1)) {
> +		snprintf(buf, buf_size, "overflow");
> +		return;
> +	}
> +
> +	switch (entry_size) {
> +	case sizeof(u32):
> +		snprintf(buf, buf_size, "%08x", *(const u32 *)entry);
> +		break;
> +	case sizeof(u64):
> +		snprintf(buf, buf_size, "%016llx", *(const u64 *)entry);
> +		break;
> +#if defined(__SIZEOF_INT128__)
> +	case sizeof(u128):
> +		snprintf(buf, buf_size, "%016llx%016llx",
> +			 (unsigned long long)(*(const u128 *)entry >> 64),
> +			 (unsigned long long)*(const u128 *)entry);
> +		break;
> +#endif
> +	default:
> +		snprintf(buf, buf_size, "unsupported");
> +		break;
> +	}
> +}

Why not leave ptval_bytes_to_hex_str() in the C file for less churn for now?

-- 
Cheers,

David

