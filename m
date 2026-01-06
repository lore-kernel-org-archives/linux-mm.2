Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1D779C47BE2
	for <linux-mm@archiver.kernel.org>; Tue,  6 Jan 2026 11:38:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4D5056B008A; Tue,  6 Jan 2026 06:38:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4ACBA6B0093; Tue,  6 Jan 2026 06:38:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3BE446B0095; Tue,  6 Jan 2026 06:38:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 284206B008A
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 06:38:06 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id BCB0C13AF52
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 11:38:05 +0000 (UTC)
X-FDA: 84301340130.25.816D642
Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	by imf01.hostedemail.com (Postfix) with ESMTP id B907E4000E
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 11:38:03 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=RQ7HEb5B;
	spf=pass (imf01.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.51 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767699483;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MiPIfmjv3b05N/bw/XvHmU5o9/AUPMqaF5FRtYSnf34=;
	b=Qs9MGmnUcKE3v09K3boDqzbVATgIaAsV99c6v6aF1klyTeIlngOvycRksqjfVuTYiN/R42
	hBaGRNTQByq3YAp1dAnCD4QY9/ePfOaDu8VkbNgOu9DnqdQQx00c63GcyedfaFe8ceNMoZ
	FFIB6kYmfXQxhYB3YFJcWGM2SHGeOZM=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=RQ7HEb5B;
	spf=pass (imf01.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.51 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767699483; a=rsa-sha256;
	cv=none;
	b=KJ0U7WM8T4S9iPY5xcBKul9X/8pbQIxH9eyxjNUXiQ0KPpjrJtAP3n/nEgSHVuJzybJ9ei
	SboWL1gg4yrFeGJTmDxywj5yikhdXIY3HErW35CwzdRTNC8wK2yidpA4lKFrzzJgkMdU5O
	4o0/3C7yobeUn3Zw4FYszVxEW1iCSkw=
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-b7ffa5d1b80so141138166b.0
        for <linux-mm@kvack.org>; Tue, 06 Jan 2026 03:38:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767699482; x=1768304282; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MiPIfmjv3b05N/bw/XvHmU5o9/AUPMqaF5FRtYSnf34=;
        b=RQ7HEb5B4I2iRDI9VwhlNRwypkLL6DYjmMDRCKTxGJJGSp9Oxp+vvLP6J/09HvqJ1W
         vSUfQIst4H7R1dBfg4FX1BF4iGnjVyoiA7aOarCBzshWE10FUtdf1KRSAR8OH/ETMvWv
         C4Jl/GCj6ZYSeNjMpcv1QdVtHWQyUkUAyA81KVZGh8iA50LTcJP/8gHePk+BChIG/Bev
         bP1TVMHX0s0MWp3gdPkTpoS2tiULbCWPfpNqjRwJx7qogIZhiLwuofIXNenllxVnsg4W
         hOqOF7RCBrUAV72BSW8p6VVGo96Zpq7dEYSmYh7YMoXxOVEDgxT29AeyrP3gOLOckr7X
         Z6XQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767699482; x=1768304282;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MiPIfmjv3b05N/bw/XvHmU5o9/AUPMqaF5FRtYSnf34=;
        b=w2gKlvm0PU10gYOsxXsdGOzQZr3rfEmagD9kfey28huddsm9Hui7S1NMh2MPZKDQwG
         XU77N4BS5NAJgQSazjPlIEGoHxvCSJlrsLMZymB8ifDMZWd2B0SlAnRk/56zyNuucB48
         xy650qUeoZoNpEzk3U5UPsy5KYv7taHUyel8KrWqe1U5SQw7KIBx88qN6uWjQlHM62rs
         FesQxKCiea423xRaU0lOOlCZwSesC536t5f75V+mX4ai+ct1ham1ryfBI0gZqLMl+Yol
         e7wF8Zvz7eGAc5T1/qOODeWLER8wv8BMGxZmGfCli5doy5uSLvuNwSowis3zIh2iqfze
         gWBQ==
X-Forwarded-Encrypted: i=1; AJvYcCWCGjClIHJQwe4m7hZ4aYz/zVDQKuaRD85yyN3vsIgebnf4p9DH7R+flMSrODXzwZ6U5GGTapR+ZA==@kvack.org
X-Gm-Message-State: AOJu0YzjYS557PPp+Dw6B7GebneFhZDgfROCsrE8Xu67fKxKJU2ptb+D
	65o3IZjwGFYRyNuTSDgZ158Exlv8JVkvNN5PYI5sbAVnpq78uMbgK0l1
X-Gm-Gg: AY/fxX7LVg2b1h11Tij6SbATzZfbdjDbrOlpaUMA2i6JMrF9gv48s1QvyC7uhWnAQSN
	ZBhwLWmNQh7MT7jhxvCXBE3TKKTdKwJUTfFpzXIyWFpQ/J036HmiyQverc4MooBeYYflsKaTdsU
	2yHx9ulm8rmdgTKnMU8vKAUmyxGLAy7qD18Odj/El4xV5HCC2TxpW32JhmMO4sZo2pK0ylmBvIq
	hLS0iqHIXy2knZgkyar/FG7oo+IWI5L0rAg2UqKnM1Q0wEfyfLnP2+XQkss4kASZufjFTJnua5d
	vzShj2XxqdQ/+I/bME6Rc6tLN/Bw+enqmM75249Ph7/T4T8I3jnoUjYG0O6Jz1/QtBlQ9jLkXu+
	OC8P81kHv6QVvqHKdNZKb+Nk9lzPoDgIx6IG+RbDJOCbmBLUPU1TPfhsw4ruCFGMp16VvHj6fAM
	rjX6JId7mXMA==
X-Google-Smtp-Source: AGHT+IE4vK7Idw33w0dr627IjMwMmN4O113exdBdmGZBRMY89j9Rrr4y7a7t8aNrQBWlB/zASfmhOw==
X-Received: by 2002:a17:907:3f0e:b0:b80:1b27:f2fd with SMTP id a640c23a62f3a-b8426c4e48emr335853166b.54.1767699481671;
        Tue, 06 Jan 2026 03:38:01 -0800 (PST)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b842a2bc6bbsm212937266b.27.2026.01.06.03.38.01
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 06 Jan 2026 03:38:01 -0800 (PST)
Date: Tue, 6 Jan 2026 11:38:00 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: Wei Yang <richard.weiyang@gmail.com>, will@kernel.org,
	aneesh.kumar@kernel.org, akpm@linux-foundation.org,
	npiggin@gmail.com, peterz@infradead.org, hca@linux.ibm.com,
	gor@linux.ibm.com, agordeev@linux.ibm.com,
	borntraeger@linux.ibm.com, svens@linux.ibm.com, arnd@arndb.de,
	linux-arch@vger.kernel.org, linux-mm@kvack.org,
	linux-s390@vger.kernel.org
Subject: Re: [PATCH] mm/mmu_gather: remove @delay_remap of
 __tlb_remove_page_size()
Message-ID: <20260106113800.rilod6iajre7wzxs@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20251231030026.15938-1-richard.weiyang@gmail.com>
 <51e72690-8a0a-4532-b6a2-79a851edc44e@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51e72690-8a0a-4532-b6a2-79a851edc44e@kernel.org>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Stat-Signature: 17qunfkara5yjfycz1qjn4kehxj13b5o
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: B907E4000E
X-HE-Tag: 1767699483-444024
X-HE-Meta: U2FsdGVkX18cG7cEsVimTgg9Occt6xW+sPw8HplFsWNTcDZGGc7i4Y8tABxPEvHjY5pmVgz6yzAStbjHeSIxfK4fo1BcPxwWB3yDk90AeI9KS22gxvqhbkeoBWqe0ALIN3+noU2B0Qq2xUj3a4HHL1htfVCpInkpMMZmStCIvl2c5g5D99b6Di94VhMJk5tIeQO/PxIaCERWaTuPks+SQ1owawdbWWI0ThJlvmM7IO7VuJKort+klGHR+USPho2oh7KFuTTf5U9FKXiTk8FhzR4EI6kE0hlNLBHURohwtbodaxl6HOgiOikLrz2J8poti401a2h9WdoPLzJaYqA6/DBbDuiBZ4AR4JZhE9BblbbTQt42JPKx2BZcC5ib0S8DDy5CpgmsbpeKVhlN13qDVDNOuRw5k0U+EcDmQYn/QkiYyFVnfkgdU1hmQoN5Q5Lkj/e0KC/AmH3x7UTnYQg2ACKz7XgzZ0dxl71aLUUrO4Uwt82LzC1YUsXM6Kl2n8H7qLixEl5EZ+Okh8ZG79edE2R0GWraVsdKXEuFcXynS+l/FCF+WJCttib+XJuxcJmeZ2bxa57D0NuqRKK2GksyrFI6eWrc10TSpJzZ+InLHgkdNmMLYuDBj/B2S/o5tNWsKWiY1Ovmt9o1Whq/20c0UpiY7cUJxZEdqRsYLOphkegxJ8jV2prOL1wV78b1skvQF7/GmGZj6po3CnzmqywoPc8gJ0P3Sa6eIEEM6ONTbC4o/1b7HwTBnBIvnw+TD31QB2mYPQaxmxKonXLB7E/yHcsDNfH1DlBIzBrs0EQuN2Ro6R9eqVpk4Ng6lkBTI6x4Zik0MNOPWpAad3uQSoYJ2gW314TEp5VltmEq5RCAk1KLTHWi5mnLTtEPaznX3/s2i9nMIeGvTdOCgvwa3mcR4AFrbxsIdHpY0EkWWe12tnYCoM59z/0FZS+2Mo9YCO5TAyHfY9bj1uWwBg5WiYL
 E2RndwiP
 uUpTh+MGAhbCDJgklPGC3M1PsAxeCoaW0nHDnNRo9dvl4lS4EYI/pbMjqFAiWIGjDizxdLXxpS9zvozOHDc0ZvGR/53+pXL1PQIqvt7pnEA/6VYwFV6o2o311SwUak67J/72XYG/BozLVhH7OG0wK4A7YeW4golAmqt2KYxuE8kmbv830GBAjs2CkyDwMgp96LtfCcKnIjgonbuLgnyy+EPN/TTYJwJ2JE6ROms3risGcp43u2jLFHe7k9+H1p/wRTeDcwGPCtIwHihDsXdtQLyLqHMKkRRuRMw5jEy8UxO88kJHoQJQmF3xeV4qF/FEvE4HO0ZX8s4KjIe3K2ed3YpT73DM81pNmZikAwk6gKoXjiVSWsodkyuBQuiTQZzpVbSaA2e0utkTHdst89bz4daZly3YiFoH6CaCrcGVYvU6cIk6+Rw1GOnQOnVVB1309CfU+nFq3vbMRYOIxaZContVx8oswcb+k4o9PMbpUuwFSjYa7YyHkTQi4lYEUAUEwCPcx+zgqIxzodm+4jGlRj+aHj99Gn82dew7x2xbwtsiuHm38TVcbqAbHtdnQONpjizVE6n/hIIZ7gvl214YNzArI6kFBlEe7AMZ0HL9GWtEWsAvK1uhAH/HJuMZG+5j1n6PIqAff9UklFQVYKKyo5vMnW2o8WCxtdna9GQwDKmFO4IY0VyJzAyfaLxW5b+q52XsFgSCvWU4NNBM0q9Ec5PjgkgudEQ7vHMlNGnqFtpEs2MRaamqno0frVtLs57YmAWdYcj1t/EZpxuYClpdbJE+u3+QPy1EWIa8lKRmlQC5uZGS0hP5rBKoJsRZ2yfklEsS6DGob5FTb4JwXJ04e0u5aOSNoYuy/pTQA3y6Tfor9E7grb+Fz92Efdzl9mZKjjQlWRa5xXcT5ZNs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jan 05, 2026 at 04:44:28PM +0100, David Hildenbrand (Red Hat) wrote:
>On 12/31/25 04:00, Wei Yang wrote:
>> Functioin __tlb_remove_page_size() is only used in
>
>s/Functioin/Function/
>
>> tlb_remove_page_size() with @delay_remap set to false and it is passed
>> directly to __tlb_remove_folio_pages_size().
>> 
>> Remove @delay_remap of __tlb_remove_page_size() and call
>> __tlb_remove_folio_pages_size() with false @delay_remap.
>> 
>> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
>> Cc: "David Hildenbrand (Red Hat)" <david@kernel.org>
>
>Right, the only code that sets delay_rmap=true is zap_present_folio_ptes()
>where we now only call __tlb_remove_folio_pages() directly.
>
>Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
>

Thanks

>-- 
>Cheers
>
>David

-- 
Wei Yang
Help you, Help me

