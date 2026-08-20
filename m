Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E8A13C5DF85
	for <linux-mm@archiver.kernel.org>; Thu, 20 Aug 2026 17:46:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 28CD76B0095; Thu, 20 Aug 2026 13:46:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 264376B009B; Thu, 20 Aug 2026 13:46:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1566E6B009D; Thu, 20 Aug 2026 13:46:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DF0626B0095
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 13:46:25 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6DA904024E
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 17:46:25 +0000 (UTC)
X-FDA: 85122377130.08.D26A07E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id A3C761C0005
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 17:46:23 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UsCwLrRV;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787247983;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2fIdalCmTaw2AjswTgZRpQgDXscO6AG89u3FfnnHiks=;
	b=EHvUshi79O4PEZpkZGSfsylf8FxabJITacj4F67aloJUdWRDxK/KdSQDKk2kpRKGTXDO4o
	lLksfTCozfAl321dE0bruD/IQJb3180wBrsKzGwjgpXpyKfKR95p3qo+7crikw9MgxjTmZ
	ncbNG6kL+5JIcWC57ylaGUH5DrsrA6M=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UsCwLrRV;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787247983;
	b=tpF+Uor333WV33kCVHywgk0Yfx9G/G9ULWTABOPBN7DE5shyEkwaWsyly/yW4zjEcm6Ull
	UULlDe95pBUZHjN33Aq2KB51G+WTkQIFtLwf5HjbwSRmliRDimSX6gSAqnrH57eUuAAhBG
	1HCQ6QPhRDv5PGYah+iVD2DpSGv0WN4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id AB2F441A7D;
	Thu, 20 Aug 2026 17:46:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7317A1F000E9;
	Thu, 20 Aug 2026 17:46:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787247982;
	bh=2fIdalCmTaw2AjswTgZRpQgDXscO6AG89u3FfnnHiks=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=UsCwLrRV/K35zxbIA/hIc4Id6aozHPhPLOrJUiwPAl7OYQh1taZ1K0yNEOwgg/SUt
	 nYUi3Hdf40wr/zFLSUOd6i/TOIIK06CsD7c76CpQ+3D1YmCqljd8DdsVwbaROCzkoN
	 bENSolqCbH0aTMxV0Uodq/7fc051LdApcEbUX5xvVe+cCt1M8fnsy4r4oEb3MGJB7Q
	 qX5rvlwvW6KxieSCMpPyqv8bCjsxXbYmszXW7B/c4r8xxSanuHoPI9dDZ4o+A2i+7T
	 g0mDdl8HXlxn1gl3V37kQt9jiNDzGue/0Wkgo9odCMX7acV9lcZ2eca4XgFmgikc8T
	 J2E591DIchXmA==
Message-ID: <bf298ebe-55bd-4f42-9339-9567eadaa514@kernel.org>
Date: Thu, 20 Aug 2026 19:46:17 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 2/2] mm/memory_hotplug: optimize zone contiguous check
 when changing pfn range
To: "Liu, Yuan1" <yuan1.liu@intel.com>, Oscar Salvador <osalvador@suse.de>,
 Mike Rapoport <rppt@kernel.org>, Wei Yang <richard.weiyang@gmail.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
 "Zou, Nanhai" <nanhai.zou@intel.com>, Chen Zhang <zhangchen.kidd@jd.com>,
 "Zeng, Jason" <jason.zeng@intel.com>, "Chen, Yu C" <yu.c.chen@intel.com>,
 "Deng, Pan" <pan.deng@intel.com>, "Li, Tianyou" <tianyou.li@intel.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20260818085702.3395529-1-yuan1.liu@intel.com>
 <20260818085702.3395529-3-yuan1.liu@intel.com>
 <ac77571f-4a10-4511-83e0-c6372d5b4a09@kernel.org>
 <MW4PR11MB69369259EB8B2FDF237B863AA3A42@MW4PR11MB6936.namprd11.prod.outlook.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <MW4PR11MB69369259EB8B2FDF237B863AA3A42@MW4PR11MB6936.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: rg5m4db3ckamqujwrsssj4i8ngp48wpq
X-Rspamd-Queue-Id: A3C761C0005
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1787247983-274710
X-HE-Meta: U2FsdGVkX1+FpH7ZbOpyYfPsiQWP8UltAZq+hoCEvfkIK7+krn/NLRbzBa5wqG+d9HaGCBMWaGjJ35sfglkzJGgf4ea5xHtUfQVifEU8nJtxlmRZO/+bCd9PkJFNdHoxO6Vqb+23W0aKjYOhCM8Fu/1MDKB7RkLwV93AbUJmEtqGw4FsnJ0ItxKQzaPzZwgJJVv00WGwJWSS08yZTBTHlRne30hvgq7FOKV/XgJpA9kJElOlOKt+6oIun2XdlqpeUzg1Ohy2FrV+TJ0zJ+WIGBWG8GF+ozGh3UbcuFmHDwKGHomvBxi15g9Yt5QzGUcpukq6HqUQJM2p1wm8gf73bnQsovrT3s+ku3x5gEYCa2gzu5gzYMhxizM7gfewkgTIXycdkP7BdM63Ztto0GH4ONLt1p3SzG6mNFohRAddxVpNQ4c7DN8c9qn7l7rVN9eADW4yWf1aBSfQDkSa2FNo5hXneCKp90k0qVU6ACoH4npaYJHOROrJ0d4Ns6TDbgDomXl0IBjntefAzD95BpmJ00UPLy989ReYMMyiKI2KWLvmE/ROKYDhkWzNGLB2+894vk0lVYK62oEnuY3BaA49qRZBReYqEZxgh819qF41JgW5vONgcDf5uOOjAmevlP0H/STKsmPv0eYc+6Z+U0VQ2r+pAAri49wnc3RPUKhrGQ9yljXgUOLkZ1H4aq16JZgSPxZa4c0PY/F5kZt3rlTkktk82FeQsAS+7wLW+mSTdxEECQvp+gnh6jRxkgUNbDFp2xN7vAX5xvxFaUZEcGyo6pOZBk1E3crvNffRH1oysi11OMplvKfQx5xQxhqkmWVDZGA9QikSWfmWOTJ4W/LqSzd7MFLz4fIFbA3KzlkrrK63cE740W1RIxh1k0G/f78bzJOdZogEiSADxfPTWTS7mSQ9RZt+buIsOn6kjkXcW0J6z8VE1s2OeIeyih70ITsobwsdySyWIvL8HkAfucj
 hUj+0qUL
 0leWuDMWnW9usV7uAzo2yJEktVtJFll6QT3CIfg6uSoQIWMNgRdjeqSZr+zdv7hb4NUZZSKOUhaftVW7zq5NdcrMYGPlNGup1AO3x5eXlK5wOWxHvJlxZ2aQWl2ZqrJetntc40Ce5bGFGtzZi/Wz9o7cOq7vL4McaT3n4ZkV1gZPiuTptpo2yCTDeI6wEBOpYrkor44I2N4OdggS2nn4fGWQyrik6wA7ybXkEHUFfTr7n1/DMQZbmn1wceM2q6xLJhWWwZ7gIl+tR4PAhg6Lwdo6nUKNAq5uEsFOfahPfogV/+TE/6KqcFTRewr2ZwwTpdr4A8J7upSac1my7bETZNyKORp7MaCtuw0kuVlJPL+03pSOFvz9b6XlH8eJPefIxzx8bA7Ct09afde24OX4prchXF2CQpfihpJqJQgDRDMSCvU8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>>> +			online_pgcnt++;
>>
>> Can we avoid these helpers?
>>
>> 		const unsigned long subsection = pfn & PAGE_SUBSECTION_MASK;
>>
>> 		/* We can have section-sized online holes with VMEMMAP. */
>> 		if (IS_ENMABLED(CONFIG_SPARSEMEM_VMEMMAP) &&
>> 		    subsection != last_subsection) {
>> 			is_online = pfn_to_online_page(pfn);
>> 			last_subsection = subsection;
>> 		}
>> 		if (is_online)
>> 			online_pgcnt++;
> 
> I think there may be an issue here: PAGE_SUBSECTION_MASK is not
> defined when CONFIG_FLATMEM is enabled, which would result in a
> build failure.

Ah, yeah.

> 
>> An alternative is an inner loop that just walks in SUBSECTION chunks until
>> epfn.
>> That would probably be even cleaner and faster.
>>
>> I remember !vmemmap always only has early sections when they are actually
>> online. We could extent the comment to clarify that.
> 
> Hi David
> 
> What about the following approach? It removes the helper and changes
> the per-PFN online check to a per-chunk check.
> 
> +       u64 pgcnt = 0, online_pgcnt = 0;
> +#ifdef CONFIG_SPARSEMEM_VMEMMAP
> +       const unsigned long chunk = PAGES_PER_SUBSECTION;
> +#else
> +       const unsigned long chunk = epfn - spfn;
> +#endif
> 
> -       for_each_valid_pfn(pfn, spfn, epfn) {
> -               __init_single_page(pfn_to_page(pfn), pfn, zone, node);
> -               __SetPageReserved(pfn_to_page(pfn));
> -               pgcnt++;
> +       /*
> +        * With VMEMMAP, subsection-sized holes can exist, and PFNs within
> +        * these holes can fail pfn_to_online_page(). Without VMEMMAP, we
> +        * always only have early sections when they are actually online.
> +        */
> +       for (pfn = spfn; pfn < epfn; pfn += chunk) {
> +               const unsigned long chunk_epfn = min(pfn + chunk, epfn);
> +               const bool is_online = !IS_ENABLED(CONFIG_SPARSEMEM_VMEMMAP) ||
> +                                      pfn_to_online_page(pfn);
> +               unsigned long p;
> +
> +               for_each_valid_pfn(p, pfn, chunk_epfn) {
> +                       __init_single_page(pfn_to_page(p), p, zone, node);
> +                       __SetPageReserved(pfn_to_page(p));
> +                       if (is_online)
> +                               online_pgcnt++;
> +                       pgcnt++;
> +               }

I'd keep the for_each_valid_pfn() the outer loop.

-- 
Cheers,

David

