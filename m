Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 31F8DCDE021
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 08:02:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8A7528E0009; Fri, 14 Nov 2025 03:02:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 87F1E8E0002; Fri, 14 Nov 2025 03:02:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 794B08E0009; Fri, 14 Nov 2025 03:02:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 684F68E0002
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 03:02:37 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D607412CB5E
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 08:02:36 +0000 (UTC)
X-FDA: 84108470712.13.D56FF82
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	by imf24.hostedemail.com (Postfix) with ESMTP id 08EC5180017
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 08:02:34 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=BtyFPHuv;
	spf=pass (imf24.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.41 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763107355;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4KbiNU5yCfEN4FXal09etJPtHEak6Phh1dFiA4B8zJk=;
	b=7QFb5g0MatLJrlAGNHIG+e1tKMk5vS6tjQWkdDd5HMCZ+WpRKuhthEw1L7g6D1N2Yva6SB
	YwA2GcszGlzY1cUHF8XYDubnLPeCzjRciHdFssbleHh92qpPu1+SWuUNURpcX1TVytp7jn
	AICsivsG4kU6Q/HvbBBBEd0hXDjF31c=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=BtyFPHuv;
	spf=pass (imf24.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.41 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763107355; a=rsa-sha256;
	cv=none;
	b=Gz5+fmQlxWNQ9JHjmWEEhjQJCad4Uqqt9gYeEba4q7nCN2EnL2369GDJtCiqfJpmJbMr+f
	kDu4SUBpK1HzfUyU5QbK1UP11gh2TvsesvNIQHHqYRO/5Fm4/uF6Siyb0b3V1KV1uB4hSi
	EOePayBH0MYPcFS03Gsml26JLu6w/Rs=
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-64149f78c0dso2700414a12.3
        for <linux-mm@kvack.org>; Fri, 14 Nov 2025 00:02:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763107353; x=1763712153; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4KbiNU5yCfEN4FXal09etJPtHEak6Phh1dFiA4B8zJk=;
        b=BtyFPHuvV5qqLcw0hHhdcB3cXMq0goSGGW1fXSktNO2auLCqayB38bLy0YSHW0NSFX
         RuDtXkDFoaVmFvzLt9KwnhK+8He3AARoQexlo0rRRSmK5zBMdYNnJbKkyOmgBaSoeBO8
         JIkfY6HaCKR45fkl8KaEev13h7+Rt+YdURZ1aT6WSmPSizRlADKnB9pNbyFnd+X9sSYw
         qD9siR9fljFzK2zmMe2w8K5473Z2Qyjwe8YMfnyOixGXCZCW/ihsdu+8wXIHTBZdM6C8
         bLiFOo17IK70i8BxCFWkpN2H0AECwFM7S+Bz3kLP2Zrzv1mY5+pJHRN9xgvHNcVRNw+z
         jbRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763107353; x=1763712153;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4KbiNU5yCfEN4FXal09etJPtHEak6Phh1dFiA4B8zJk=;
        b=CvDa19qX6oKhkkl+/MvbWSHS5VfRNyeq1GMtvLhtU6XDhYIn4wG7V5VQo50OU3m+LW
         zjDnYISgtRm7yMGbPJbqyLY/6ryZFn2DCb43tBnKS4rVR8+Y2Nuo2Jxx8lnCALn7Vj12
         0Q1XNOcy32LfCKb+L2fMP/31P3WtCz2NNOggGVEMv0RP+TQMB24ueF2TH2wqx8UFgnbj
         uv/d9yro5oPYWzUlD3uUPcIfBZdxsWFgxXt2GMOyIbiqBTq9vUYUPRhsmtcdKgIMuVvt
         q/on3bgdLP8ezoPTPJviM4m1jGhx/FJmqn5T6uUjoPU7PZb2HTqczN1KHnrvFhgKlfPZ
         z0mw==
X-Forwarded-Encrypted: i=1; AJvYcCXO+XUZzkO80XAXBmUdV/nDPBfSmUeAvxbNes+FI68o9B18NyspksBmwp7QwfVBUNJ9n6viu0AGrQ==@kvack.org
X-Gm-Message-State: AOJu0Yw5EWULTj+qKft6CZeGJZNjiPZjwCecyhhUuL70wGs79XYXts91
	kQaARkzry6LM9rioXBFvZA9KEmUzSq3bG5TtQsuSrkponp33elX4QkmX
X-Gm-Gg: ASbGnctIAw2Al6b9sdZfpJXst/xOI/9gU4CRWCGCtC4bNpzwwtWlwl3VlqRe0/hGQE2
	TUT+2y250hdQ42BSPjbk+ui6LYQvbzR1fyBz+yjGA8v50bzDP/2UjtMEWjU0Irf1FXM1QQsWlRc
	PUxAiSMYVONXbcVy6KYyhV1i8dhnV92EMQht+YDt7UpG/OZVaE4nS4muZ28uiQ+JBF1E59Ov6DY
	XXJ4mzFV9KhP7vL4wuHtYxWaDiZsO++I1HPACsBrxF/LJlH360oDg1NQQ5l2HXppWSk6ahIYUxy
	CsZEZsBvsuzJsBU4sPjCvOxB0VwkhOdTXjRUK2lBObs/GOGeWMfoD1aQ+AC75gBzCHYCWWfnhRP
	EOm7HgQvoLCAFs+2HCnT+Q+H9x4dsjqrI2aeWTZIrupvlJsGSE6yIikPV3jSFi0cdItd9YepHUE
	ka0VrwtQXnpb4P3w==
X-Google-Smtp-Source: AGHT+IFHp4R0zTwE4dMochE8kl4UmvqdsH7ba7lQ82B8UAtO+/J0teWF71l9ELhwzjeYKUxsrmiq1w==
X-Received: by 2002:a05:6402:3592:b0:640:7529:b8d3 with SMTP id 4fb4d7f45d1cf-64350e2321amr1683582a12.9.1763107353191;
        Fri, 14 Nov 2025 00:02:33 -0800 (PST)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6433a2d746bsm3123759a12.0.2025.11.14.00.02.32
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 14 Nov 2025 00:02:32 -0800 (PST)
Date: Fri, 14 Nov 2025 08:02:32 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Balbir Singh <balbirs@nvidia.com>
Cc: Wei Yang <richard.weiyang@gmail.com>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, dri-devel@lists.freedesktop.org,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>, Zi Yan <ziy@nvidia.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Oscar Salvador <osalvador@suse.de>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Lyude Paul <lyude@redhat.com>, Danilo Krummrich <dakr@kernel.org>,
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
	Ralph Campbell <rcampbell@nvidia.com>,
	Mika =?iso-8859-1?Q?Penttil=E4?= <mpenttil@redhat.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Francois Dugast <francois.dugast@intel.com>
Subject: Re: [PATCH] mm/huge_memory.c: introduce folio_split_unmapped
Message-ID: <20251114080232.kxms4vjlkiiuxqpl@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20251114012228.2634882-1-balbirs@nvidia.com>
 <20251114032105.sdkjaoiwpdmpynew@master>
 <870151ce-ca90-4cd4-8f21-35f4da329924@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <870151ce-ca90-4cd4-8f21-35f4da329924@nvidia.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspamd-Queue-Id: 08EC5180017
X-Stat-Signature: 3ic1mno3d9tgeswij8jqfh7mg4aamn9u
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1763107354-354695
X-HE-Meta: U2FsdGVkX1/Fs+sBbxqgyb60EdHElfwvfJutAfre01ztmSE8ZMbpi3AWVVDJDbcrrf5eXRQhZfP4fSxm/rLij6YGHGG2RIh5PAaCJk3hTDUFf3yqUnhul83ahw11R+eaYktIAm5LodTa3LknYWW5e1y36SclLCX4Uim7nnxbOlbypcxlq6jFK3GkW1mMHQ1S2BcKwoUmU1VVFXTzDhl7Sjv1H6C6hNCB6Sr2BILj2hBzaZIepOJ3d9pzSEOJlLNj2bCqnMtkN6TDtOGqVWZzTYNE+/dHPNN/ry0ruTRNCOkMqI3kd5mZq9JijgExF9TMiwGBSI7r4mD7vw2M0j8XVawh/fuAeBZ5P0nICe0yennGEftOHeUdsZpmeP3vj449low0Umv7nETQrvBq465BSFyAehos7U6slASo0605/lEEiPlcCq6w5k8ZOW1P4kieB05Q8WyK/7I80KuCxxyic7Xq2TrswxxOEOzDL93naycll7paE7n5eFLXTcZnSrLrK0yKqJXX0qS71noisWm4awcnYj1iqY2X6DZWYriUNESn3PYLXcrQb9xcKibui2oHsVuCeXQmIC7pP/1yMGuw7891/TZqs9FwzwGOtidW0QikH0YrM1WKWfFalv8ZX8KouG8nu30AcOHfhE4xS7jOkkKETSVqT8Z232cLHSELDvWbLd8FwAhwiCGJW667bwkSZEwBaGlkt1CkWaGkAYVY9JjWhIuacpGTKf/X97DanU2oYnBxpH1RsyKd/P+gbHRb1nie7Daa9AEJ5UMR8dL2sxy7tVK8xp2FRo9YG/W7kL7xNnEwFMk4LYlfQ/l33GMyHNZpQ5u67UQ6AiIE0KRzEiYJt2+quHaxVw9/jgcVmXsLG4r9TuSQXQZBDcwGioPcuPRbMp18lBLYrpe08JelQXL9yibxPtpXiHX6zOatlk8+On8U/6xpx2CHU7n7SulgUb+4MxjuQjRea+BbaTn
 FZVBsNmL
 0GayeeKfufFzmu+BApuqcZPJGRlGgZY34u3HH4sxtITnlcW/PTkVLeGkR0BYoCeteJuoWF1YEYtxd9EbNyeU0mJLtqMrYtJRPyEk4Xf1LzL6ZKPVoUmF19LtBYbv1aCSxKH3zN9eJhKJRujdg8mcir7Ad7DDFRUBF29pxnX4JcWfVV2+1kiXuIWdxLJUf1Bz8Ajiuuk/4WktK5fQuQVwJTTre9o8FtuemAtB++a4NCjhgLAEDavzXVybjjWzMf5Fq8HfsARTu6UVav7ZhBVJjv0UCMf6ZSyaNvdL1mCsd7o/52Rert80A1/kd3/gN1f4MNWCO
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Nov 14, 2025 at 02:30:03PM +1100, Balbir Singh wrote:
>On 11/14/25 14:21, Wei Yang wrote:
>> On Fri, Nov 14, 2025 at 12:22:28PM +1100, Balbir Singh wrote:
>> [...]
>>> @@ -4079,6 +4091,36 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
>>> 	return ret;
>>> }
>>>
>>> +/*
>>> + * This function is a helper for splitting folios that have already been unmapped.
>>> + * The use case is that the device or the CPU can refuse to migrate THP pages in
>>> + * the middle of migration, due to allocation issues on either side
>>> + *
>>> + * The high level code is copied from __folio_split, since the pages are anonymous
>>> + * and are already isolated from the LRU, the code has been simplified to not
>>> + * burden __folio_split with unmapped sprinkled into the code.
>>> + *
>>> + * None of the split folios are unlocked
>>> + */
>>> +int folio_split_unmapped(struct folio *folio, unsigned int new_order)
>>> +{
>>> +	int extra_pins, ret = 0;
>>> +
>>> +	VM_WARN_ON_FOLIO(folio_mapped(folio), folio);
>>> +	VM_WARN_ON_ONCE_FOLIO(!folio_test_locked(folio), folio);
>>> +	VM_WARN_ON_ONCE_FOLIO(!folio_test_large(folio), folio);
>>> +
>> 
>> Compared with original logic, we did check folio_split_supported() and
>> check whether new_order is supported for the file system.
>> 
>> Currently folio_split_unmapped() only pass 0 as new_order, which looks good.
>> But for a generic helper, it looks reasonable to do the check, IMHO.
>> 
>
>This is meant to be used in the middle of a migration where the src/dst do 
>no agree on the folio_order() due to allocation issues. When mTHP support
>is added to device migration, order support will be added and checked.
>FYI: This routines supports just anonymous pages ATM
>

OK, I don't see these assumptions. Not sure it would be abused.

Maybe a comment would help? Or remove the new_order now? We can add it when it
is truly used.

>>> +	if (!can_split_folio(folio, 1, &extra_pins))
>>> +		return -EAGAIN;
>>> +
>>> +	local_irq_disable();
>>> +	ret = __folio_freeze_and_split_unmapped(folio, new_order, &folio->page, NULL,
>>> +						NULL, false, NULL, SPLIT_TYPE_UNIFORM,
>>> +						0, extra_pins);
>>> +	local_irq_enable();
>>> +	return ret;
>>> +}
>>> +
>>> /*
>>>  * This function splits a large folio into smaller folios of order @new_order.
>>>  * @page can point to any page of the large folio to split. The split operation
>> 
>> 
>
>Balbir

-- 
Wei Yang
Help you, Help me

