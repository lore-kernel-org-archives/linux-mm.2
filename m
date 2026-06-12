Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 35E02CD8CA8
	for <linux-mm@archiver.kernel.org>; Fri, 12 Jun 2026 14:09:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2F1B26B0005; Fri, 12 Jun 2026 10:09:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2A1EB6B0088; Fri, 12 Jun 2026 10:09:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 190906B008C; Fri, 12 Jun 2026 10:09:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 070816B0005
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 10:09:27 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 78E5F4013E
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 14:09:26 +0000 (UTC)
X-FDA: 84871443132.24.32F75D7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 893FA40009
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 14:09:24 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bBsjm5z2;
	spf=pass (imf07.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781273364;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TLdV27eWe8bzH9uTpJ3I7eStVmUcSjphmin8eMb7h7k=;
	b=TYRHWz77lN46pMyuF+582FnBS+K/j78LVksD6CCc7a+Ujw1B/72sMJ7qocYguQ9iaa7pWO
	NQcWK04ZSx5/ti4fLqihpFdtcAbuc9YMF0ra/V08vcmCyO4abmPtdHkJdce6QbxaGsfL1m
	ufrBtqHNUjxiNwK6XaNpMbGl2kuZiyQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781273364;
	b=5Zf1jC0DaoGCEqI6LYfTl9dGsQO/yOMLj6+AOhOuvXO0tZXwC2pAAmmDI2aYtln7s4JZ1/
	RKTZdc1SPrdCaeuM00XlahVPEdakGRWMmi7OiwLcoZkgox4TGkIRzterBYagHYGoVSmLpH
	4DVv0wvHsI9+/1SIFr5YEyEV67wPFUA=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bBsjm5z2;
	spf=pass (imf07.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 77F384435F;
	Fri, 12 Jun 2026 14:09:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18AFC1F000E9;
	Fri, 12 Jun 2026 14:09:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781273363;
	bh=TLdV27eWe8bzH9uTpJ3I7eStVmUcSjphmin8eMb7h7k=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=bBsjm5z2YMEwh2gXpTAKz1lQujYcB6slsLx0pXhOaWHKuVZWfe/GgjLDVZHrxdh5u
	 cHQ/J3ApOSMFQ6EFhLGQWszwgQkYFOmhn+5nU2mB40O8sU5JMGXJ6k3fp2HWyiSZiZ
	 nNvcCzO+/GimKw6mzpjQLdMd+xZRbMv6VYio5LLlIapb4dO1vnChun/6ibAiur40N5
	 M3u+Ivyqwsi5b+DEUMQ1S+8I0jh+ZsTbOATU3hde2W2PjVhyA1Df1V/TO4AZcDFDSC
	 U4cEh6LWAGzHpBKmCW25ih5CYJlD1x1AtVhTFsWBlAZXm6GU4tYIKpdO/jDvars0yW
	 VMCDjx4ddpsnA==
Message-ID: <ff850e50-dded-4201-a7d8-a623a81d3560@kernel.org>
Date: Fri, 12 Jun 2026 16:09:18 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/5] mm: Make per-VMA locks available universally
Content-Language: en-US
To: Suren Baghdasaryan <surenb@google.com>,
 Dave Hansen <dave.hansen@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Alice Ryhl <aliceryhl@google.com>,
 Andrew Morton <akpm@linux-foundation.org>, =?UTF-8?B?QXJ2ZSBIasO4bm5ldsOl?=
 =?UTF-8?Q?g?= <arve@android.com>, Carlos Llamas <cmllamas@google.com>,
 Christian Brauner <christian@brauner.io>, David Ahern <dsahern@kernel.org>,
 "David S. Miller" <davem@davemloft.net>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, linux-mm@kvack.org,
 Lorenzo Stoakes <ljs@kernel.org>, netdev@vger.kernel.org,
 Shakeel Butt <shakeel.butt@linux.dev>, Todd Kjos <tkjos@android.com>
References: <20260610230409.A44D29FA@davehans-spike.ostc.intel.com>
 <20260610230411.617DD5E7@davehans-spike.ostc.intel.com>
 <CAJuCfpGbz1_05GkyaoEpnhbd4s6+-U_ksUA=wYfRPivq2iFBHA@mail.gmail.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <CAJuCfpGbz1_05GkyaoEpnhbd4s6+-U_ksUA=wYfRPivq2iFBHA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 893FA40009
X-Rspam-User: 
X-Stat-Signature: 9jhf8dnk7d346si3oz8d5rnxo89imfn9
X-Rspamd-Server: rspam08
X-HE-Tag: 1781273364-485183
X-HE-Meta: U2FsdGVkX19LYjZUXQCiGnhHE7FyRTrn8ftltxth6QzOuTApFZ+iOdt6f97BbCY8r+6RZmW9E5dN3XGCvakrcaF8hTOjQXkPbznxn0SZEoCUnv4jCz48lUIP2cticjFAD2wyDvolqq6yEBiAtWFtu8fbTJVdgb/JLS1xxFRYueou2pT/Tj6U2hgmJYlf3bOwbDds7IO8Fs8/w8tSXspjJstEOkWslFuUuccywksFvWZXUsMSfIiUOxYnR3ki/MC2/cgq82XV1iypEuCziWLs280YjIF+0DpaZdQjsnEmu285O//y2rj5+B1oXMjJHLPtsKDRMXzRlB0nKTSFyXbdKE1Xhdbm4d6WtHUJo+QnXGZdlyTpcLqXhmAghZJFk5nJ5azhmV1wf+BrZrQ0hAzAy9xVpcOyz84wtUAJm7tdoT9gmxa8yvKp1zSgfP4ewPXBn6rkfzWR9WHmAeBTVY72dtcvkuAX6mXR0ehhAh0NtgZSzBBt4Ua3k/e3ckwHYLmBDcBhnhp6AL8c97NAMgyItuiWFUYWYTcrXz8X0hTdp1IwWuTZMBj7ZhsI3qzHkozJncB7svap/OKqsbb7OMK8mUqWo/DQeN5MukPFhmNPtRAV74zerrpYgxKGSJgIUxXWdx5/uf8g2M/otHpzUhBDKB+Uwo58ElxJaOaR+60xZLH6Wu2jC9H4SrUcS/Hwb61HnSpa0RKtjng7gHZcfmmnhKRHOwN3DZ4aQmOAWsJX+rYPQXvAV3hMNFOnRhz5trq0v6FKrbR7gipEavpKPjPzVsDv/RusGAtWkw1H8M/l0Vv5XG5cmvjfah5K1QAzOsngN9juG3jLhiR56BaXhlPE/0t8oUCoXkc8zCaQ3EO+vv8ygvluf5Se5MEhpnuH4zkvzPRJ/BYuzOfPM612NKGrR1qTJ09IL+xuJb335hb52TgnRnGC7hzC/4EFyOz2nVS3RZ7ZekCeFp6oOkT7cfX
 j06xIJVZ
 F28fIIqR0bFTo9KrhxjVtE0ROaxHTHS4bQ4syKOjno3FRLQiskDgHvlrJJbb4nGq5kFxNl4mw0jb39OuDwPjsJp4+cikU/j98x6PTtH8KzybhdLZTnkWVHs4BCPQWS8+7OGFOUcJttHiOM8r3fE4CVdcoCYXhPtv2NV8IJisHtlzhGKijDsvoCqAM88rKhZkDSHJqjjVRW9N2wGm9/GkeTHOzB3TWInKNynQxQALarovOWJXWEopRC8lckxSAh3/slb9Y
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/11/26 21:29, Suren Baghdasaryan wrote:
>> -
>> -/*
>> - * At least xtensa ends up having protection faults even with no
>> - * MMU.. No stack expansion, at least.
>> - */
>> -struct vm_area_struct *lock_mm_and_find_vma(struct mm_struct *mm,
>> -                       unsigned long addr, struct pt_regs *regs)
>> -{
>> -       struct vm_area_struct *vma;
>> -
>> -       mmap_read_lock(mm);
>> -       vma = vma_lookup(mm, addr);
>> -       if (!vma)
>> -               mmap_read_unlock(mm);
>> -       return vma;
>> -}
> 
> Might this removal break CONFIG_MMU=n && CONFIG_LOCK_MM_AND_FIND_VMA=n case?

Seems to me only the architectures that select CONFIG_LOCK_MM_AND_FIND_VMA
also call lock_mm_and_find_vma(). So it's probably fine?

I think this fallback was only for architectures that select
CONFIG_LOCK_MM_AND_FIND_VMA *and* have CONFIG_MMU=n (variant).
It just wasn't guarded by #ifdef CONFIG_LOCK_MM_AND_FIND_VMA as well.

>> -
>> -#endif /* CONFIG_MMU */
>> diff -puN mm/pagewalk.c~unconditional-vma-locks mm/pagewalk.c

