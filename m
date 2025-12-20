Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C7F12E6689E
	for <linux-mm@archiver.kernel.org>; Sat, 20 Dec 2025 06:37:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 19AD06B0088; Sat, 20 Dec 2025 01:37:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 149356B0089; Sat, 20 Dec 2025 01:37:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 02A636B008A; Sat, 20 Dec 2025 01:37:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E2C686B0088
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 01:37:43 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 472CA16044B
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 06:37:43 +0000 (UTC)
X-FDA: 84238893606.23.FDD25EB
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	by imf19.hostedemail.com (Postfix) with ESMTP id 415C01A000C
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 06:37:41 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=eW6a5dRa;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf19.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.41 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766212661; a=rsa-sha256;
	cv=none;
	b=3qHQARS0GVjxeE2+D3CJS6mdIQmI6Qknx4ycCAWGyrkRbXFIb1OuYf9f/2mc1JDEzbXvDX
	JG+592eSG+7z7P3CZod4C+i6sLeKNHUOeWPSzqFMopTWcTn4UBXZhEc4YwCnT08AokQQN1
	b2ZKkq1SS3QveffR3wKlziRAfKOsVlw=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=eW6a5dRa;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf19.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.41 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766212661;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FooWQpfOMINmJp+FnpxctjXY4hgx5RbcOIyby+amm+A=;
	b=HIRWnGj5lvbjNBdp3Ij7qiab9YsWrqbKJ8nR4oP/O0FclTWN15zeF+jf7zO+Z45Lp7RiYb
	mychOm87lYGvz/CMl2eQUUty+A5+t0HlJSHE+XXBo/oCKU3dKDl06uNmjKKS0EjO2egIMp
	Bwj/qT9n4sRtA6EdJQ0W7162UnN6DIc=
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-b7355f6ef12so462361866b.3
        for <linux-mm@kvack.org>; Fri, 19 Dec 2025 22:37:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766212659; x=1766817459; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FooWQpfOMINmJp+FnpxctjXY4hgx5RbcOIyby+amm+A=;
        b=eW6a5dRaEec5KcEELaIe9h1uiJbqC17hlWVzfkRsyuZPZgK1mguu6WTFXWWTs+zure
         z4QX93oeAJCTDwqIHnAd08IdCz4mGG0xAnHxzk8a0OOwEf2Y+DEDkcIsCo+I9uywEuRi
         VaFUBRww5CfEBkvzX9G6YHHDqS8Kzpp9Wib94Punyn6lhbhIOhtWg6R1O4h7USD9Az4a
         4aZPkz4JSq0ge/3NnpUQeIWMxTlpuAxZyjJ+rq1kxh1SG0VAn57c97S4MK+n0qFEFoIX
         LNwxcc2u2IKPMWNWBucUOwhBqT5jkJCKbri78Sb73fCk+VSmq82mjvlo2x24lSOZFcVX
         8/kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766212659; x=1766817459;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FooWQpfOMINmJp+FnpxctjXY4hgx5RbcOIyby+amm+A=;
        b=oZv+GzfytJszBfEpgNrsXVWqvOxGCAf+pyMtvW32Iz57OFWy5SwjpyizhAmSlxy422
         IuUEeDU7sfP0sxvlCvL/Cb/nvIaph6rTt3TUzCiHNVkn3YvjnFsJ4gg+wvMEEvSvlkNy
         LTbhD9Yn9JmXVcBnMNMlpzKexknjPnTm1Zx4Hl1GKGliw4KCKF9AA+rfkmkC+IeXJW8K
         Onr6zYliH2zX/abw7OGKx/LVI4Gbb0OQahdxEuGoApUTlG9srAHbE0hytGEKZ7ynqDEJ
         NugXKy7mroDpBWr23deZbybpGPcjV/BJ3m0VvqfaDXOzkYFw1QbwikhiObeFHTWhq69s
         YAHA==
X-Forwarded-Encrypted: i=1; AJvYcCUtvQ+iDwyyueNsfuakl1Tpgmk+orvQw+IWK4mfDkVtMU85FSC9uau8yuhZJs1U9eCDVmc1A+kIwg==@kvack.org
X-Gm-Message-State: AOJu0YzAJc6SvnlYYGof5Zra1ZCFgjysRN+d5eoQJnAAQp/FHu/bT/Ig
	TgF0/0NXumVYFQzHMBggmkTdct9BrKEqBPON0Ls1ISYroCWxdfYebwqP
X-Gm-Gg: AY/fxX5pw2Djc0LDMN/XZ3PxRex5FDeCbGvARHOenDKet8GOR6xeEUgG6oQ+zxB9XuS
	mPgW09hLd5yJ8oo/7QxM53IHdXPAH3mnsryyXEYo7Puc+FvLeQH6i1vwW/iHdLo3pH02HQPjOGP
	obMMnNszhvXrQ5EUppLHdtQC6fOL15yCe/6cskk/zenPBJ8Blf6RQMXybuRk45BMix3qi1KyM5m
	iFPzL5xTaG8BqtgKYs9MnlX5Xc1M8O2EXvbJ5sVqkyWeuoUwOArL8sBN/iUKMRNx9Rt4KRscHkI
	Q8aWlF8tuPYqfwCo794DvQ0NSIqzKK+WG8gbUhjbcXzfYJZ23D8iYsMCpwHPgO4CSstr2wLEnI+
	Dm0qhowdnrMZ1pgTe0/OSNdEy7Vi9J55wcAKrxnK249xq3GiPtOOEmHMrkLWECj/CzQCe8pNS3q
	bvr8cd3dIygQ==
X-Google-Smtp-Source: AGHT+IE52VYLOIWDODLUJLXC/zJ7l+ayf/itcSPoY3h6Eran/g1nN6W0kCqfPtmbO1FwsH4IWYVq+w==
X-Received: by 2002:a17:907:96a7:b0:b7a:1bde:a01c with SMTP id a640c23a62f3a-b8037218276mr487561266b.64.1766212659251;
        Fri, 19 Dec 2025 22:37:39 -0800 (PST)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b8037a604f5sm431928366b.11.2025.12.19.22.37.38
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 19 Dec 2025 22:37:38 -0800 (PST)
Date: Sat, 20 Dec 2025 06:37:38 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Zi Yan <ziy@nvidia.com>
Cc: Gregory Price <gourry@gourry.net>, Wei Yang <richard.weiyang@gmail.com>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	kernel-team@meta.com, akpm@linux-foundation.org, vbabka@suse.cz,
	surenb@google.com, mhocko@suse.com, jackmanb@google.com,
	hannes@cmpxchg.org, osalvador@suse.de, rientjes@google.com,
	david@redhat.com, joshua.hahnjy@gmail.com, fvdl@google.com
Subject: Re: [PATCH v6] page_alloc: allow migration of smaller hugepages
 during contig_alloc
Message-ID: <20251220063738.hbypivj3d34c7ffs@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20251218233804.1395835-1-gourry@gourry.net>
 <20251219000800.tnpqzvcdyeqcwryt@master>
 <aUVgoEiaXj94IBmW@gourry-fedora-PF4VCD3F>
 <7EED2D83-AE17-49CB-BDB6-954793EAFDBF@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7EED2D83-AE17-49CB-BDB6-954793EAFDBF@nvidia.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspamd-Queue-Id: 415C01A000C
X-Stat-Signature: bcnxcyomunjp9neg7sdinkp4nnbnyxod
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1766212661-952487
X-HE-Meta: U2FsdGVkX19w0fhmwfdTJe3eFmdBVTr/YevMhKs2ek1XDRuhuL2VRPjW1QAu/xcQqc/ccWvLwL/d9ON7nmBX2ZM4RIuruK/Jhu+jEqKartqsgQ53yNpqz2fWuHJ37H3BNP2NUaAFKbBbIrEv0NGto0i3fxttQu6uBuSRGhMch0jij46u8kRZkhOb3BG7dBNLIOZOqZbSZdIiacrhabUhtphOM8ZI+muI0Ft7vJlvFKNEjG8flBmRwNO22aVhZUoQb0nKtG6S+zwldgWU/43OkchmmlURuXmEWHY16vX9kHmSYBxeKEb6n28Uy8GQey8r03w/OY8trH2hYQ+FS5ceFh4m9blVpA3vRrBEQqi6s6F5ZzURY8bpB3BjmyoOG5Y7mtI14HEXhusxQcHS5fjeVfBsVcUaaZUcFtB46tVMSpOotOrOAmEvTZxHeCEucroozfKYOIukh9m1sIjxq8MsCFYDZT1D5D2sGfPzPv+tRThLrLojMQ3tg1bqAY1xsl51c7ipbeDDcDiLcrKa50iCnMprJj87uFqmPW0Pj3M4jTZLooZuZpgdQFhR5tR0KeGtkjI+Z6XVfS9naaebiIEEFkR6NhQhWpxFupeP7W4MyDwm5W0U664oet9CKhYqBQOOtbORhjUsBmspYULHuCtfEN8537V8UyKTRWGfg3CktE9xw5m599m6L1pQQnxULT2sWPn/xF8GjAw4XuMan9ffmVZP/Y9swGVvZ8gCm1Nc6s+kM0nJ1VB8ltvq4MyBxsyiIKixix+/pXuSA6Mufm1VbjgGmVBMI+0nVdVaobSW5lyqMOk/QubFTSuAQlFJ6jmcwvr2H/n1AqVtu9tTsWI/fRTUA5upDlIJrPSmAqBhn1DnV723dSjxiwFkkQGqHEFBUT9hEc8eBRV/EqxDm/4bgLCZJnn1ZfmlbQwB9EDsa5JflbiH4bC9ZlzUTG0Kzp/6j/hSAxVeh2ENrLCbdQr
 xdMWAOCE
 yBMH0xzCTQvCcXzUtBXUFGxV2JcZ9fO/Zrma6zLeK8AnrmX2uLcSmYXKN9hPgEtOc72wn2hi/8FPRkGn6ixGt8wq5wf0yA0QxgkAdX/M9LNYHzZo1uq9uat7k4fJG3D7aiVNOV2T07adAbkJY96Gsblou4+q7Zq5u3s3vgIcnI1C3kzVmG3cp3jT8q4kvQSe8+CTu8p4xMTjyYpvaLovcgQegpExaS35Jem8IIC37EqXsTlbwCZFfU1li0LmlueM+VNMHeT/EzFoeIwrpzqDCsBgMOWd5DL4V+naCjduW1ijMoDylf0Lzk8qyENXr/oOFtgWbWWd2H/qp7iYb5FE9dYe+NPWNWKy5LuVpzjong+X1hc+W5G4nEoTF8e/FFmyh+eGlFXa4c8bsh+UakLz5ixEsRaQXvUoe5YpsGZV/qpl6daTf/u91frNZuqLLpHtgwKV3dhsWMn/40lR8lc6p7C/osp+coh0BU1UrRJmBcbIK4R663JwjK08bugNq2Tcrsx6wVseWQ99yCqNmpY27yZcCJrdjz43brwwF+OO52vRfGkbOqOdVoE3OuGqiur2Sc9pzr6T0dYM38tIOoBUJ+muFKRbx8noAWM+qdQ/HyAS7QEfcUuqwTanPNTSybkRotCK3iHYU0K9rRZPYJ85N6A314E81J02rwChSi/HglP+c0lja7e9npGk/SJYdMMNUa0qLEUh8FenvzY4Mny8LQLnvCv+vyKmcHgKqJWmC1IRFdEYm0eXWsDUn78P3S6cqznFaQve2zSJa0MeQa3x3Q0Yt+Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Dec 19, 2025 at 03:46:25PM -0500, Zi Yan wrote:
>On 19 Dec 2025, at 9:26, Gregory Price wrote:
>
>> On Fri, Dec 19, 2025 at 12:08:00AM +0000, Wei Yang wrote:
>>>> +
>>>> +			page = compound_head(page);
>>>> +			order = compound_order(page);
>>>
>>> The order is get from head page.
>>>
>>>> +			if ((order >= MAX_FOLIO_ORDER) ||
>>>> +			    (nr_pages <= (1 << order)))
>>>> +				return false;
>>>> +
>>>> +			/* No need to check the pfns for this page */
>>>> +			i += (1 << order) - 1;
>>>
>>> So this advance should based on "head page" instead of original page, right?
>>>
>>
>> hm, I think the thought here was that since we're moving forward from
>> start of an aligned chunk, we'd never hit a non-head page - but this
>> may not be true.
>>
>> Will think about this for a bit.
>
>The sole caller of pfn_range_valid_contig(), alloc_contig_pages_noprof(),
>scans from the beginning of a zone to the end. pfn_range_valid_contig()
>should see head pages all the time, except it scans in the middle of
>a 1GB hugetlb when alloc_contig_pages_noprof() is asking for a smaller
>nr_pages, like 2MB. But in that case, the if above i += (1 << order) - 1
>would return false without reaching it. Basically, to get to
>i += ..., pfn_range_valid_contig() needs to search for nr_pages larger
>than PageHuge(page) and nr_pages is always power of two based on
>alloc_contig_pages_noprof() requirement, but that means
>pfn_range_valid_contig() always sees such PageHuge pages as a whole
>within nr_pages range, thus cannot see a tail PageHuge page at the
>point of i += ....
>

Thanks, I think you are right. For current use case, it is safe.

But I am not sure others could get it on first sight. For example, me :-)
Do you think it would be helpful to add some comment here?

Generally LGTM.

Reviewed-by: Wei Yang <richard.weiyang@gmail.com>

>Best Regards,
>Yan, Zi

-- 
Wei Yang
Help you, Help me

