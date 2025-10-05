Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6594ECAC5B0
	for <linux-mm@archiver.kernel.org>; Sun,  5 Oct 2025 00:09:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BBABE8E0005; Sat,  4 Oct 2025 20:09:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B92E48E0002; Sat,  4 Oct 2025 20:09:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AA79C8E0005; Sat,  4 Oct 2025 20:09:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 999518E0002
	for <linux-mm@kvack.org>; Sat,  4 Oct 2025 20:09:29 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3CDB01DDE18
	for <linux-mm@kvack.org>; Sun,  5 Oct 2025 00:09:29 +0000 (UTC)
X-FDA: 83962126458.18.3B29B2E
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	by imf30.hostedemail.com (Postfix) with ESMTP id 3AB1B8000F
	for <linux-mm@kvack.org>; Sun,  5 Oct 2025 00:09:26 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=RWaA1rvx;
	spf=pass (imf30.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.52 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759622967;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ILory6nQAFzpHa/zvj9oJELdDq7FIvPPiBGgCT8DreY=;
	b=u9AKb7nCjf8PUNA3sKpb+MM1WiOBr5izirACEAujFs6AuCzLKdAFcLAKQebR1eZT4ZfZeG
	dcKNzJDGrDuP/zlr+cRORJyadX5dEZ1pQh6EfIR3xoNtwNikzKnTcd3HiwvqFeqoWaTsG6
	/RGmg/vAeuAbM0/LhsatZv37Yrb82Cw=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=RWaA1rvx;
	spf=pass (imf30.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.52 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759622967; a=rsa-sha256;
	cv=none;
	b=L4YOlRUK6b6zRkeVChNNIkDswXTx3+3HUmY7VnQwDKPf4JMn3f+Noi9lnMbixzIfi7PAD5
	2ST1b34QfEIyBN9nyTZDr+2ahGOnT5ootKB16iBZrI9v+ifbB2tq21DT6TqqFG8TJdG4Cv
	JDkZcUJcbmGEYQ9MzV/P6LNqd4+5Yqw=
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-b07e3a77b72so791303066b.0
        for <linux-mm@kvack.org>; Sat, 04 Oct 2025 17:09:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759622965; x=1760227765; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ILory6nQAFzpHa/zvj9oJELdDq7FIvPPiBGgCT8DreY=;
        b=RWaA1rvxWplZTatsixxQK85O7KIZdBhhhZeP91Hcjv1Y3NNfv5sLnsQwi8BLRVZs4P
         u3apSCK1zD78zqjfekYeqpuwQL829E9ohox/n5+eQGyPrk+5ShO1a0q+eJCTKooQoJ2J
         r84ktf1PMzRqh70Q5cGNax2OBQrXE6n5oXa/83JvjoELCEW0vY+aPgK11Tss21NRLhGS
         0swnNC3sFbc/pv25k2sJr2s3d+xsCipr5X+QlJDH6XUSNJMz6eD+0atsqFX+0Mp5w+bb
         vIEXdQPkDiJr2r7Z7cB/dLA68ixoiMSEZSfOYqqduD2clARmd8AnldBf0k/Fm+OzHl8O
         jJyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759622965; x=1760227765;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ILory6nQAFzpHa/zvj9oJELdDq7FIvPPiBGgCT8DreY=;
        b=Til3HNpiUt3PT3F1dea2U6T4hdxauzGP5fvoMDWshlHjKwfITk5uQ3knrYNnaDJNE9
         ScGaLzxr9p7gijn1kEZRRHKMKM8F/SRRbxOl/+LEdgWjRuiDbkLvh4ewoMWhr5xIj4JA
         UXLYK8U7wWDdEM9Sw0Nv5iEvjvaAFVjhSIvm4cncdKUaiw4r9b/+I14gkHNsYbjkE5h4
         KiPCHv1qWKC4uOXhO4c0AtGJvTfwyqwXcYHIAr4Eo0zJ/6dLdYXpfdVwcBRi1ccXwyRb
         2fQIBQTr7l3iJABBa9PcMJ71EiM57DQf5vOPU6ItmgmloADxwAqfFFrtPSn1nijuyb4A
         sGOw==
X-Forwarded-Encrypted: i=1; AJvYcCVoPjmBSLXfh9mp4KU2UbjyacNOd1G0PcN/sHPf9wLOlyk2HCw4UzkwwW95N8TfJ9KeTgnU8nAEQg==@kvack.org
X-Gm-Message-State: AOJu0Yww1hfufX1sFeWltB8vdg5U6LHaPpjwLJnTEGPj8y+fGK8tW0Dq
	6wOxvOi+C3W2XM/idYvCUPU7YsSNOVjsVK0/GUOAnUYKFG2Vmwrt4W0I
X-Gm-Gg: ASbGnctQscwWmQV/EbSuPH3eDj7JKSHG+JRDwZUNq/ImNTcvSM1XpGRl/PAUlqmZRa+
	bPNwLPDHnGB8hTX3S3juq0AzQpnBIr11iaaR7tMdarWT5E9v9j77yz5JRju5JMp2TkgbHp9r87z
	5W1xF7OI5OrDlctqqSJ/pXTqq5FsL/MBDRWGMmoWq3tED2WP6RWA8GorBBmZkhO+2Ti01TF45TE
	+LtzOJAQGfFbB9IGQlrYekFl1dcH3JRxP1u5YRckXtuNhNATyvb/nkCwzQXnSNN9TsOTivFrsPi
	qBWG7B/Kie5X3bs09I3WNwfqIdR+mCF1bQG6R9jdSeq5wt9QaR8Ev31U6wEZnxbOfEt5JIm2ZeO
	6rUsjwSmbNCSdZ9nr0RbMYo7LDyYbsEp4QmxGeZB7pBCdZkiwE8Ex1FSM
X-Google-Smtp-Source: AGHT+IFSSaw+WA7f+ppkS59hVxMWUv9Shlb4zADNt8mJ106zoE+TuGfAh9ikoKnL6R/erYEm7MiKHw==
X-Received: by 2002:a17:907:1c12:b0:b07:6390:322d with SMTP id a640c23a62f3a-b4859c7a1ccmr1583992166b.9.1759622965466;
        Sat, 04 Oct 2025 17:09:25 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b4865a7c660sm784755966b.22.2025.10.04.17.09.24
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 04 Oct 2025 17:09:25 -0700 (PDT)
Date: Sun, 5 Oct 2025 00:09:24 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Wei Yang <richard.weiyang@gmail.com>
Cc: Dev Jain <dev.jain@arm.com>, akpm@linux-foundation.org,
	david@redhat.com, lorenzo.stoakes@oracle.com, ziy@nvidia.com,
	baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
	npache@redhat.com, ryan.roberts@arm.com, baohua@kernel.org,
	lance.yang@linux.dev, linux-mm@kvack.org
Subject: Re: [PATCH] mm/khugepaged: use map_anon_folio_pmd() in
 collapse_huge_page()
Message-ID: <20251005000924.bo7nxresftryfeqf@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20251004092523.28989-1-richard.weiyang@gmail.com>
 <96dac3c7-c969-4d4a-afca-85341f8a6a6e@arm.com>
 <20251005000413.ogmobshcbsw34b5v@master>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251005000413.ogmobshcbsw34b5v@master>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Stat-Signature: 3e9u1adcsj88cnn88ba48pppcney933r
X-Rspam-User: 
X-Rspamd-Queue-Id: 3AB1B8000F
X-Rspamd-Server: rspam04
X-HE-Tag: 1759622966-861202
X-HE-Meta: U2FsdGVkX18ZOYCvoa+iz8eoTT1v1vhcGoHbt9sMGA1cObQcLdO+/yYsNBLvPbi44HQJJxqsfh3ftVJBeISZdLk0N3+nRcogWIio7RkhJdKwARU95mpFI4gETi7EGc0FuA8/lVVe4Mjk9DkoJ0bKcD4sDFtRxP7/TH5OVFoNILsYlp6SKGStdYcAmaMz+B20zshg4U1ttlyv0Bz+dBlJVFWsTGZjqXad2aNLGuPG0MVn1fZhVh8zKN6HTqM/ZtW6PN8hCyt5LaCvwPp8/eootgEWar1+ReSxm/V5yMdwzMJKlH4djTjKRygABBiGZmCGttERSynlc+/ROnOD1VCni6y9Ms3M1B2kJC1wTJah2xNbKG2Pi7g8O9/5Qzqke4x6dvBVnaqyBedaqmBX8o9GSewUnonrhe7Edhe/EorXnn89vq6EP+D7x6Ago4H0+3LUakD4SDDFs+WrOhh4IpEBGgRs34n+WTHR1Khr6RoQ4R94I2Xtlm31F17fJgQSZ3OirLGgi+DP2hsuEsGYFtc6lYS7GhDEd2783bRmKERsk+Z1zmwtIcjSn48BC7w7JyQ4GtdoYNavsBa0Q4z8HRB7eRJQFwc/QIdfhvN06tID8csoDafH/137XZjwJOkNx6iWRGuo1u1rllqEyaq/MK0S6c1q1RKQiImq7hBhBG/zn0ANd8tCVSCScRemsoFYSxvvHEeC7N5hIV0pyInd2dvPvZdl2GPVGmOElTMqUm+JKKyMLTR8w512UFsdX2tV4X1NU3DasO/07lOQu4nYKjlpFzl/HE7wasUxnkhbybIP+JKvFgrQDzCLTIUJWgvhJs+cZyWKrX7q+5dFx+77MDqMUADNI+C/C05U5gRB5WkcaIm6pUsFJDq5XYDGQ9WkU5ck0KyKG2cx9ynMhlD5i90h1TTMnXTLI1uLvfNcDOz++mWUBjmi2FHyoL1TnQxb9T5oQ5maB4u5dtmv8uFK8wx
 E6aXiJp+
 m6vjy5EOt/5F6O8pdqsaoR00/mGeP8/o+AgytAzTDunVf76I87QB15aGtViFK05jJaJeZfubi/7osGtCq7Gj5//A2716N6eTZcNANOXqdl8wazdFTs2nRbXiVFDrT9a5vfiPnl3ifvgu94DFE/GYReDi5n8EZIUdprrm1cbqLAw+wu9VLUEBrkX1s2DhYAPjaODQGwMpGsMqV2x7rsSvxkuVymAS7TPsQ3UbKiXUOeztSkn8Xm5fDAfHHNNd6udZJNEBUIULF+f4vZFSM9UgDIacgcZ4QWs4qcj96cTmG4Qrh2IXFmzOuynsJhyiTdbltPL4uqwGyq51722cfO7UjYaxw4m8kAVDxTmf8p7FInUcHhx6acKtNpQovdkxq/EN2m0Q/i7wjS209vfG5nnhnIDtWjdFro0FsNgK4zMwRptvixdUimVUKAGZ0m0jq2CKtTlyvBDSR9XwLvu9YXtdXCBNNU+UexxdTaNBjFlwAVs0cGWtFgsW1Tm5Ac62/pj1GWEf8PIDDPj+n4EZ++TmrUIXfKMvpE1E5qWLZRCsVHKPETIuv89SCw/4/PPHdzcGU4hHFcV0ls2L0U8r9FiElD/q/SBfD3ZOVgJcqoqw9xKEkUvg9LPbSgzjuY5qT67gbFxGNqTXOyC51sx6nJ8udPghy7sKPKbl/bjB9QMAD4Dk5fsHOGnSPD3Jml62iYwEdhp4X5U/YEUcKRPvxoX3CkhOCUIXln6cGu8rNv38T8OAMy3QedVqeLhYmujAJknpqxOH+CNslXy1vmYZN1pJcCQJ7ZCiHLSNL7+X8pUbWMARrvbk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Oct 05, 2025 at 12:04:13AM +0000, Wei Yang wrote:
>On Sat, Oct 04, 2025 at 07:56:48PM +0530, Dev Jain wrote:
>>
>>On 04/10/25 2:55 pm, Wei Yang wrote:
>>> Unify the process to install pmd folio.
>>> 
>>> No functional change is intended.
>>> 
>>> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
>>
>>Base commit on which this patch applies?
>>
>
>The base commit is 
>
>696ef26cfef2 2025-10-03 mm: redefine VM_* flag constants with BIT()
>
>on latest akpm/mm-new branch.
>

Forget to mention, with this [1] change applied.

[1]: https://lkml.kernel.org/r/20251002013825.20448-1-richard.weiyang@gmail.com

-- 
Wei Yang
Help you, Help me

