Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 412EA606A327
	for <linux-mm@archiver.kernel.org>; Sat, 28 Nov 2026 09:22:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chrisdown.name header.i=@chrisdown.name header.a=rsa-sha256 header.s=google header.b=a7qL44iO
Received: by kanga.kvack.org (Postfix)
	id 679676B05B7; Sat, 28 Nov 2026 04:22:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 651046B05B8; Sat, 28 Nov 2026 04:22:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 58D5B6B05B9; Sat, 28 Nov 2026 04:22:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id EE9786B05B7
	for <linux-mm@kvack.org>; Sat, 28 Nov 2026 04:22:02 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 75C4AC061D
	for <linux-mm@kvack.org>; Sat, 28 Nov 2026 09:22:02 +0000 (UTC)
X-FDA: 85483986084.28.C50E666
Received: from mail-yw1-f171.google.com (mail-yw1-f171.google.com [209.85.128.171])
	by imf29.hostedemail.com (Postfix) with ESMTP id 9505312000C
	for <linux-mm@kvack.org>; Sat, 28 Nov 2026 09:22:00 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=a7qL44iO;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name;
	spf=pass (imf29.hostedemail.com: domain of chris@chrisdown.name designates 209.85.128.171 as permitted sender) smtp.mailfrom=chris@chrisdown.name
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795857720;
	b=gT6i7n6dV+OQFA0Cdsfg/UGrk4Ht7VPInIAr3wcbwUtwOBUnaLJUUBPUmFWqojnWLNpSlW
	yAB/1XLOqbBXNgm6vaA8Gg96Uhu+ke8j/fOuApYhjCY7pbE2ULEIY7X7PacQY+zznPDghN
	Ikc4mqgqUuEw42pzVmpfcjdhuxXtoqE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795857720;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NrIoMTeuQSSKquJ/B8Dkq51X5h3zUX1txK3GWbjAlR8=;
	b=TJ/N/qfvfhUCzJlAeNdVHHRXu5jIoZEzAdX+rP94/lkYbn3rRwrt3UKNdgut73SFjXd/bp
	9ZMJ9zFFZzFwngSGbiEtAfq9+zTAubakDPZ8rv7NXNH6z4TgjzG4PJN0RfbV8/Qr1RQ9ra
	2vdbTW3NbjdiudWo+gNN780+lALN94o=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=a7qL44iO;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name;
	spf=pass (imf29.hostedemail.com: domain of chris@chrisdown.name designates 209.85.128.171 as permitted sender) smtp.mailfrom=chris@chrisdown.name
Received: by mail-yw1-f171.google.com with SMTP id 00721157ae682-8b531cd9bbaso78302517b3.2
        for <linux-mm@kvack.org>; Sat, 28 Nov 2026 01:22:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google; t=1795857720; x=1796462520; darn=kvack.org;
        h=user-agent:content-disposition:content-type:mime-version:message-id
         :references:in-reply-to:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=NrIoMTeuQSSKquJ/B8Dkq51X5h3zUX1txK3GWbjAlR8=;
        b=a7qL44iOb/jGtdntNYyaZqwKFtjnkFApnSH/8ipidQJXLHb0aYDQhHx+IkZGDDBcyo
         vL1kDbdsmm+fTzNBVLdH7xSWb+fWKjZ59uhbAd9pOnTF+tPcAnOWB0epYKuEapOWOVhl
         u3wILoIyUujAzbZ1z5Xt4hCwKvcSpzcDBMcyM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795857720; x=1796462520;
        h=user-agent:content-disposition:content-type:mime-version:message-id
         :references:in-reply-to:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=NrIoMTeuQSSKquJ/B8Dkq51X5h3zUX1txK3GWbjAlR8=;
        b=vG1+Sc+9QCwsCfn7jDhH2D/QGDIJ9u4rFbUCTEIHcsUA+bxEhoTyAoeDNFEsznMTc0
         HMR/aKMvrMSgHnoJvHgQt2Clm3q6Px1mkeKiMsuqlBv8glP0elHL7af+UAZgGp3AQz0m
         xtVV/Y9SXJnwrYIt8M9VYdTAbBY/zJz1gRadE/QT49YxpfuRwYWa6KU3OWIZSsAfr2Qs
         U9feIU3DngGuMCcq9but97CRRZjhRH1GS7mQXmZ9ErHjuQ+PV/vjZdUQh0oJrWI4JLP9
         3J8eGcHtUWTMUXpLtJJDaNRQEpbWFEr7BeVpihO40MBPOUU8SeXUJuwBfWI5aY5CAuy4
         ywCw==
X-Forwarded-Encrypted: i=1; AL+hErF4Pxf5elq0qbdhNnNRNM17aW/zm8/QOkgmZs/hwKdIKOR+DzLzfPZ7hGU836kindmN9wQgOFCxNw==@kvack.org
X-Gm-Message-State: APuU4Z9xhzJhNxV8Pr4N6VHBTYtjAz4DP+pve3uy04qoiPFFN84luqkq
	yq3o09kuIshSgVDmAwAw8MvoI4g6mtZLB0Ovh5MqUF4Bsk6Pv8QA4FRzqI+eDSciCWU=
X-Gm-Gg: AZFdTZcyodtHdMkFCtdAxmlHFIhfqgSKpXWtUJ5muVNcE8XNdgrjORJO+6NNMul6WM8
	KEOyUUmhmKxBAFU1QVVpOI0MZc45Kh1ju+kI1ar/ih3fBEI5q5ThuZ3W+JQB6sHLBG21ibcj3PX
	PZAA7V/lLZDxehhefpNS2aBX0uKFaLx3rkgcGiAc9IrW03hSnxGOgVm954OiVOIWpy+yJODW7Y1
	av3W19a95qofXSmFdjbRl8ywVz31E6LyAUwNFy/SORarkmls1CLGNxg4HSvV35a5XUlXPiiKDOM
	fTzsxaFwLzuRem+0H90Cm7zM/AnUz+qf+9FepoSxake8p1T4vJ2QB+aWffTRG/AVOPhiAwK3jN6
	c72xIKXa2uZNn4blaTeJKmpsVZE8PgxOaYRimiZaUuLIm30tiJ+8zuPWQB9pBMMx/KJeMxdZ5Wf
	yXPfnaebbzvsAyaRtrvyaPpckukJb4QyAY6nqaB4kuZ4VCMZHlGtTYsMFoFEx3ey4PVP832qXnA
	mr9btP/J0ceYXayHxzupGWm933g/DZ/4DC8USQRgMDAkF0Q82+dXcCm/2gAyccQYlaY6UTO2q7j
	UFC7v8XV6fJe1/M+D8dXPwWb4S00kbM4GQTTCJ8P+QXp/8HRR4aVAv54NjfG5ev0qYXosC5SxNZ
	iCD8tTD3Gd4BkhCCyy95oamSlrlBQ5bApL9BLWSxsbchk5LuNYhW54vd/9e7Bl9dEg6tGm/t1pF
	LPyKEOiYHLZh4kwp7UsOr2/F4B7kvQn1d/LvTSins8CjPrDuqr+36VqryQq1QANtSmVGPyI5BPG
	ZTRG4aTbMVSw+61oHSQak80
X-Received: by 2002:a05:690c:29a:b0:8b3:361f:5d77 with SMTP id 00721157ae682-8b5204a9ea2mr142715807b3.26.1795857719761;
        Sat, 28 Nov 2026 01:21:59 -0800 (PST)
Received: from [172.20.0.3] (c-73-207-185-9.hsd1.ga.comcast.net. [73.207.185.9])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8b5202fb08csm102460237b3.24.2026.11.28.01.21.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Nov 2026 01:21:58 -0800 (PST)
Date: Sat, 28 Nov 2026 01:21:55 -0800
From: Chris Down <chris@chrisdown.name>
To: Mike Rapoport <rppt@kernel.org>
Cc: pasha.tatashin@soleen.com, pratyush@kernel.org, graf@amazon.com,
	kexec@lists.infradead.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: Re: [PATCH] kho: Don't release incoming bootmem areas when kho_init()
	fails
In-Reply-To: <avGb2Trm-C3_YC-7@kernel.org>
References: <au_vQhHAcJbkryXN@chrisdown.name> <avGb2Trm-C3_YC-7@kernel.org>
Message-ID: <awqdM6WBmcGak0UV@chrisdown.name>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/2.4.3 (cc9e3943) (2026-10-09)
X-Rspam-User:
X-Stat-Signature: j1fgxe9reegmjf841g9zuk8thn31piep
X-Rspamd-Queue-Id: 9505312000C
X-Rspamd-Server: rspam10
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1795857720-209790
X-HE-Meta: U2FsdGVkX1/wajwZw3VJCAPvKS223F1107NmOWCxQtgQEYQXXPqDp9zA3w3YJQXJ5qoQU2aZA6W3G/UeTGioCFW88/Q+uv2zJdKSzBurNJej2V1vFiDT3KMW+SKSorcdyiBVKTLpUCdp3BrlwFxZ9jfdzKTk96JzKCvDguT4IdgLNkxgmEQJqnK+ojvUebPCMzTz3F9lhOHWTOD9cgDNhCU494pkcFjpONzsjKfgnkPprdWOBkWRng3LJ8zOgvhTNmOXwCJnb0heiaBmpdRDS1/GEnY7pGAVInbbOMBJajpd2nBSk9EoPA+b2+hQsi+LrfqkQ/e6rwD74GUxeslVtWLbDV3OyGIz6kxnJuw20XJ3Sy7vGZbLhVJl9b8/t26CEXlzqXXmFsgFHiisqxZk1MNHWkSL9K+KRcGlok49FhgaEBKVFhUSMmWum7lQXbT2hbLFQHBJ1tnEYqBbVO2JM8z0+N6aicxtIjdl4Oq39q3tTjSrVapF6LH2X6qkr6QskyfcEToowcpsaRW39WixStLDFnorMOQJy7qMqy/SDsj1huJhXVWR/CMSbxuFgTq9TUvDdeYyW8Xrycz/hI//HJcxDhcymFDc3PEIUEMpG0StBBXjMgTXBfPm3M7gFHWleUUX7e2gRBxsAjMa1atrM1gekWGErbBM+xDd3Aiy6IG/d7CphQEZWva/5Jr0ofXMRcg6GpzOuzhpc0Y0U5lOrnebWQOctFMtevlON1k6dX6flOyrqAeqwp5/JCBgB7ogf+8odFLWLxVsHMu4Q6O+JlqfCH/ft6iAX48CsRx11xlkd3J9wkAXj/Xo2xaGZ9YdOWtuaHBhhJwlJd38Y2ljpYDvJHVTrJBz1WxpRXII2NpIx5d7ykVm/0JvA47F3wdJb6hL3zKd+etMLm081Ej4oQvLLd00BuhSwxlaN6vNYAPDK+CzzkyYJn8PUkW5zmtvQRLXg2XAd7x34Y4O6Pb
 A7Fbzs3b
 jP3nZQaH3uMS5UTJjVnxrP2hyFVQQ7asFKBYrdVAWVoe5PhAyfBJep/lFQ5WnzMxiT/4UPMDii/LkE8bz+qrW9nNGP5IkFVQXINyR6478s1YPytsNgo5QdXN8ivOMcQrNtgfTz8aOTno8Xzi1chROg8G9uaS8QNNM20t52bXHk0FhNIYSLm19+PClhK3b9r9DvwXe9RDMspcbJLV3be6nAF5Q6gba7dNOwe4Hd0cJb2QHxK1IWYLL6uMSm9ePklBkCHTZkZb5Cd4ypzDTR8sKar4b7kt6HM7k2mn7w1X0OJHFvwzABzx1pi576OTSijTyW0W19nqpPxW0t0kl6x5/3pIDAVfZG+R9ojNrSusZyZbLWCd0RxnxedMfgTlb2B3S3pcGOSal8+52CANYoGqIa+Sa1idBEvbnC+urRomcBGztIQ/saxk/otqDaWt+Z9aFN8dUWJiG/2CPVOTiazccGYRijsALSWSMPh3w2FYMlQuxeRH1uHcQFOJ0KbrLhXzwdzOGMCC8BxGXUgpolqAH4c4co6c2GXHZ06ppKlK8531m7AM7ThPWDUEyTwIkQ57wKkWzMPN4qOu85e9r22cPweRivkGo/ABI0g0IZAKxPA9ua958tiMTrXsG9M2UZ35Dnq7CEu/ugOg1V6w28mW86lZ5LxrZnTHAhIQ7aI5S2VpPr07H/uNKBcevEg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Mike,

Mike Rapoport writes:
>On Sat, Nov 07, 2026 at 07:40:50PM -0800, Chris Down wrote:
>> kho_populate() adds the incoming bootmem areas without reserving
>> them. memblock_free_all() then hands the remainder to the buddy
>> allocator.
>
>This paragraph is confusing.
>It reads like kho_populate() should have reserved bootmem areas, but it
>didn't.

Yeah, I can see how it reads that way. v2 will say who reserves the
areas on each kind of boot instead.

>> Unfortunately however, if kho_init() fails, err_free_bootmem
>> currently frees every area with free_reserved_area(). This can free
>> pages still backing early allocations or free buddy pages a second
>> time.
>
>Is this an issue you hit in practice or it was reported by a code analysis?

Just from reading the code, same as the reservation failure one.

Actually, I did find an amusingly simple way to trigger it to
demonstrate :-) With CONFIG_KEXEC_HANDOVER_DEBUGFS=y, kho_init() fails
when debugfs is disabled, so a KHO kexec into a kernel with debugfs=off
added to its command line is enough. From a quick check I did, the new
kernel then crashes in free_pcppages_bulk() under free_reserved_area()
and never gets to userspace. I'll add the trace to the v2 changelog.

kho_init() shouldn't really fail just because debugfs is off, so let me
fix that in v2 as well.

>> +	if (!fdt) {
>
>I think using !is_kho_boot() makes this clearer.

Agreed, will do in v2.

Once the reservation failure v2 lets kho_mem_retrieve() fail and drop
the handover, is_kho_boot() will be false even though the bootmem was
inherited, so both this and the bootmem setup above it will have to
check for that instead. I'll change both in that series.

Thanks!

Chris

