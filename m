Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 614F3C5AD55
	for <linux-mm@archiver.kernel.org>; Mon, 10 Aug 2026 14:04:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4A2CE6B008C; Mon, 10 Aug 2026 10:04:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 452D86B0092; Mon, 10 Aug 2026 10:04:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 343326B0093; Mon, 10 Aug 2026 10:04:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 033336B008C
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 10:04:22 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 78AFA1C0241
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 14:04:22 +0000 (UTC)
X-FDA: 85085529564.30.8BFDF9B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 9055A40019
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 14:04:20 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=U7pLQunQ;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786370660;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YIKmkhRmsdwnr+7ylV/huXbStSLV7kblg7fBMnJ1NAk=;
	b=4CHaV1I3MqnzvSpPvessMAeMPRMss4h4iRlmF94dy5wCHmY797sap3xWWpYYWjimO/E86O
	PtRivJYFJkqSKxLygKHB8lM0Br3ftDm4Nc80sNz0MH5Si+L91nvEthFyynOornRmSaG0kH
	eK0Tykzhn85NvSrE0XGexviQfQVFeW0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786370660;
	b=oyR3RVI9Yn0L8+o2w0hv9eGQw3CCQVYwrhdNwBbTh2fD4u84mD8bbsxte8jSywqI8ZRpNc
	QaOMIzNexfz0XC8fALS3bcAkHsxtVHBLdzleASiV302C8/Nuj15MJ5JkeGxTh4RAI26ex4
	V3TdcQeankRJUvtI8tGIFqDX8x8BDc8=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=U7pLQunQ;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9285F40BAA;
	Mon, 10 Aug 2026 14:04:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 568F61F000E9;
	Mon, 10 Aug 2026 14:04:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786370659;
	bh=YIKmkhRmsdwnr+7ylV/huXbStSLV7kblg7fBMnJ1NAk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=U7pLQunQoo58oGyCV174iJVpVlk4302aUvaZaF2d2peuHtth5HUV8I9ev9SuUCYQy
	 hLakXm5wQ8sX9oBmEnEiM3Joh/N2VKytNBgq+LRmUqXgCTZvU5j9GqrNZfc+ceMBf4
	 oFd/ZchT19RJxat0qdSbE6SbIQGSUpPzGMPJABjMjiv/MiIdbUEwGTpq3pIH2JD/Mq
	 QHxl6YERvgknA8G+t+/yVPUbmr8sD0YElsyzqqNKvnSryqia+9SxWMYBYTmG7HvZxa
	 x5bnfFnbivosqEBXm68ZYPJ8F2kaFe8fAqhG9XjJkE4HpL1A4JuP7R/MXJtJS7pE7u
	 Qj1QvT5yxu3Ig==
Message-ID: <f0593f56-870e-4e79-8552-1760fad255bc@kernel.org>
Date: Mon, 10 Aug 2026 16:04:14 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 1/2] mm/memory_hotplug: optimize zone contiguous check
 when changing pfn range
To: "Liu, Yuan1" <yuan1.liu@intel.com>, Oscar Salvador <osalvador@suse.de>,
 Mike Rapoport <rppt@kernel.org>, Wei Yang <richard.weiyang@gmail.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
 "Zou, Nanhai" <nanhai.zou@intel.com>, "Deng, Pan" <pan.deng@intel.com>,
 "Li, Tianyou" <tianyou.li@intel.com>, Chen Zhang <zhangchen.kidd@jd.com>,
 "Zeng, Jason" <jason.zeng@intel.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20260723084946.189392-1-yuan1.liu@intel.com>
 <20260723084946.189392-2-yuan1.liu@intel.com>
 <a15107de-ab16-433a-a504-72c3e8dbf2a6@kernel.org>
 <PH7PR11MB6932A554A6D18A4F1A29E90DA3D22@PH7PR11MB6932.namprd11.prod.outlook.com>
 <2cbd42e1-b5bb-474c-b0e7-ce3f46541891@kernel.org>
 <MW4PR11MB6936594CC6B15968AAB781DCA3D22@MW4PR11MB6936.namprd11.prod.outlook.com>
 <0b02ef3e-363f-4b49-a208-54cdfea56c75@kernel.org>
 <MW4PR11MB69363CCE15647FD7D85542B6A3D12@MW4PR11MB6936.namprd11.prod.outlook.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <MW4PR11MB69363CCE15647FD7D85542B6A3D12@MW4PR11MB6936.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 9055A40019
X-Stat-Signature: ednemhhadrmadadonft4w916h8hrz7dr
X-HE-Tag: 1786370660-730113
X-HE-Meta: U2FsdGVkX184crVy5i7DZfu8g8c42zZv3LNca0fZLU0ljY2p6zfpGuvlf8KDKxyxsZ0mk/qqJF5rXi8WFQKgIBRKlL4OIZ/RUeZsmUCL09UK68jh0J5dptVofgqBEu6u1SrjHmDQihUtsww9tcFkWWR4aDBM4o3uJ2o1TzGUUreDh4+VVeXTE9bBrInaIVDkQ7KFjGgvmD5S6o4ZTWM8HDwIaNC8n5/G3yzp/4fJkIHRd7Fk1aUM7jUgl5BnFcKvG8HfiW7+tHcTx6b/U3z4sGuGYdTkVywNBaFg+YvSKXvFDrYbORJLI3sH47JMrCwwQyFDpavWVzN26cvaO6f6kmy6qD0qF1+Oo3oiHa2mNuQ2KS6i8CNBgelbtsdbYYjWe1wjtAHoTJ6aJlSzvbkVQqAxOeTNs9GXnSBduLy3NKHCQRnfrE9Il3SH+wUIHcFbPyfs8AkBJDtWFgPJFLVi0TBrd/6tyGbZD5ui3RiYu2PcH8JjHiClZNyq1S+vr8QbrwUtDzxYWjrxEVeRrQnMzX9PYYcc3GaEkj3aC9FzCEcT3old3JFNXwgiET5G1trWvNuFguH67Akn9CrQlgiL5F+USO88sYqxu4elG3P5BduJU8KSBNZXq3Y4rFr8sn8pIh7HoBgJC+/z+jt5mVW5Lp+VaAPKHFSfXohQLrAKTzpRypwmeosAK37gvDrlAGf0ABU6SzrfyceaSqFWMGfTtuDyAWIWuhi3swV7HGb6AHdOQYY82j3+8uos3lAHw7Q6BI8bXtz60tkzXxm7nayiBs8x4qa8/ShLYgqeVrfcDSkiCvmOiO8lk6FcnuqdiebM20ORNFqeojXH0j6DhAu5zzFvX4bBs5HDwr9UL/wvqiVk8KfNxU6mjaUkL2EVChlOGHGD97e4OchTeG2wBwLF9VGodYASxr8A0WZCNFpaeReAa3bUdee5A8LPwZ0BQiuQp1eJ2+O96hxrU7FfZZ2
 Hd5AMX6S
 qQalhfnvLoKw/40Qz4lhrv0l2RTwI9CnYAq0Yzcbz11wEIVxVPLWXDf7wQ9bq86art6TEtqXsNyrhfsWruntld1T+MsLpC4/zYghGdzL94cF7XrqNLkQaK9HGA6ASV2Q1N65p9UNoPhTUpAYFi01OcqfRMJ7VIn5jOG2t8nnv/FBC7L6zT5BbT3Q+4IzsYfjm01WIgZSxQ5wLqOqJjXfL2ghI/j3GXtkwgvUhzegNi22M5x+k0YTuj688tWTLMefdtyiueai+aRcDHAvqS9Iz7wwjGY+ckmJ7Qtw58/Odc58FU7hsI3Qi4iUW62BXByvw7oMKP3kqix5z5wBSJdXT6QghUjyvt3Ato5LIjlaW1nhNwHTYFhiDcdhO0rfeNC7+bQIn6HYHuHADohVBV6XMeZooKenEDrZmbt0anpzCXNKjH3A=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> 
> Hi David
> 
> My understanding is that init_unavailable_range() initializes all
> PFNs that satisfy pfn_valid(), but not all of them satisfy
> pfn_to_online_page(), since some PFNs belong to subsections that are
> not online.

Thanks for reminding me. I think the right direction is to finally clean up the
pfn_valid() handling.

> 
> You previously mentioned:
> 
>   pfn_valid() says early sections always have a full memmap, so even invalid
>   subsections have a memmap. pfn_to_online_page() says an invalid subsection
>   cannot be online and its content must be stale. for_each_valid_pfn() follows
>   pfn_valid() semantics, and we use it to initialize memmap that is not going
>   to be online and account it as pages_with_online_memmap, which is wrong.
> 
>   The cleanest approach is to avoid allocating memmap for subsections, which
>   also removes the special early-section handling from pfn_valid() and
>   for_each_valid_pfn().
> 
> I also share the concerns raised by Sashiko in the analysis below [1]:
> 
>   Scanners like isolate_migratepages_block() will then blindly iterate through
>   the pageblock and access the completely uninitialized struct pages of the hole,
>   leading to functional errors or kernel panics when reading these zero-filled
>   structures via macros like PageHuge() or page_zone().
> 
> That's why we went with the current approach in v6 instead of your
> earlier suggestion. I'd really appreciate your guidance on which
> direction you think would be more appropriate.
Let me take a stab at just having pfn_valid() / for_each_valid_pfn() respecting
the subsection map.

-- 
Cheers,

David

