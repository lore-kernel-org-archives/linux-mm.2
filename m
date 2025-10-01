Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0ECD8CCD182
	for <linux-mm@archiver.kernel.org>; Wed,  1 Oct 2025 08:39:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3D7298E0014; Wed,  1 Oct 2025 04:39:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3AEAA8E0002; Wed,  1 Oct 2025 04:39:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2C4B78E0014; Wed,  1 Oct 2025 04:39:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 168688E0002
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 04:39:25 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9730E13BF1A
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 08:39:24 +0000 (UTC)
X-FDA: 83948896248.13.70CB231
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	by imf20.hostedemail.com (Postfix) with ESMTP id 9A59B1C0006
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 08:39:22 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ELDKBdES;
	spf=pass (imf20.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.47 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759307962;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=k0HOU5ZLfKipiP2BM7dshphxVtDhTQKMoncwDcKICss=;
	b=FhlLhL0PhBGYbAtIpDFqn2Ql2pxF9JiHMGaEG345TkgPkedhLcOlu6Ev7r2cDNu8zHyc6L
	1h1NOvV/2OKeB45TPqtozWQHmO6X3M7RDx5NzED+Epz8IcVcuquuGpX2Yra5xnlOJpQGOG
	KL6qXXJtVG+EMtNfpoXW6w27RGsZpoI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759307962; a=rsa-sha256;
	cv=none;
	b=xNAz7QSGxWEbQdSu1hQ5Msn1AVUk7hEfbyZZkmv/yX7UmCGARISuAJyPzcks4BLR6zUc3c
	xzi1U+Mx14JCtSaCdTnenS81mpkeBJwSv/ta9sqMaQ8JhpnxAI4TEXGBwjhcrm4VRS/6ta
	Hl0+W7Mm/QOnHSDltjuYN7lWdZuP2cM=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ELDKBdES;
	spf=pass (imf20.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.47 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-631787faf35so13864414a12.3
        for <linux-mm@kvack.org>; Wed, 01 Oct 2025 01:39:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759307961; x=1759912761; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=k0HOU5ZLfKipiP2BM7dshphxVtDhTQKMoncwDcKICss=;
        b=ELDKBdESjohtDA8bnnlYVWamuVT/iOkr4VHy7DnUvKzWrp5DYzluj3Hfre9U/2wIeP
         IdLHuAq4FsOcQDHF2cn38mBRDxbsidf2ystqT0eUhwhc0Um4ySnF3thXwp5qB/LW/mcP
         icTB56jrNqscZC0nXNC2NbltmL9nhN9JFUMWcR/YtvFWk/1+/4rcQ2fshAOxzqb+YBmi
         Myh/+URL1MriVZgojPoa/MSscs6S5hrh0eIpMsN9s+iwcDusoOOh2ALoYW1JT8BArWJs
         bzsTDhOEORNB6BiLyc2gADG8BH1EpBmnkXur1CkgJUv1DZ5iEHBXHeUYJCrn+EnoVtc6
         EnWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759307961; x=1759912761;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=k0HOU5ZLfKipiP2BM7dshphxVtDhTQKMoncwDcKICss=;
        b=Y/7IOTJoKKdG2XWvcs9cXSj8GWkiVXyQC7MBf1v8Nm6Am85ss4GPQdeBX7I01QYGS6
         c37FhUBOkMuMyMPE0A/8hCeQd6T/pg6Xovv8uk6hmu94JTukRzFmEfnl5Y0t+wPXcrzK
         z1OM3b6hf6D61r4QD5z8CyuWS1L45t19G+OhghLlIiFZjkR//MVygpjeXWNVTlJLVEv7
         xV5rsokd6pVjTlJuRtLkGHCFEFfVAQQ3szx9pW2XEyG6rDVaLMBbJJ60QZcFGOQ/jK2Q
         Oj3YmEo5bZnBq2/tH1zxZsQ5cpBDIDi6m5W9PjFl4bTc+EvlWoZFieKCkI6qymcxq/M2
         B/Tg==
X-Forwarded-Encrypted: i=1; AJvYcCXtdqQygko+gX94hU35TWLcjkPQJYSLIpY0J3Y7nLPlvEIIq84H9hEFpGpPrcMLKSqn0OCdfoSS3A==@kvack.org
X-Gm-Message-State: AOJu0YzHaG0XcA7OkgYdCRMKZcR1dNi5CoJAt3Lk7AxZrIIMmSpxPHix
	BaXj0z0OBcTYWRC4eYpc3ZjyiGAE5I2Dc5tPdF6lV1G72mG5X9MYODEW
X-Gm-Gg: ASbGnctKlfLo/rEty/ZyHCgI4WXq4nZ4fyC+sBWqs+tQe2PvoXmHjdhTuw/28YQjnCk
	rVxZt8QR1n8hXLtkFGQrhEbG/WqLEQz3aAyIRpFPp2i2IVODusKVFrjPmOz6hbQtplFGn7HKLd8
	XHfd2aGOR/mkveWucnY/HH20hBBaRXJWEdIKS01rlgC17n+27rb73g/V9AXo3InY3BwcLwgL7b7
	4vgiooCKVnnqXSCLtWQzexPo6bRH+2Pz5OApPYpo+/S7eHZpxL2ejLyf6Iz+JDFlLa1bPfsjxgu
	uwN34OWFNKM+a0qG0iED/ODq28mlWDProJed1AIWxgTWpI97QvGJxMffxOmg08kQY8NMXrdrJuk
	TL/7u5HXe4TVEN2E4YM4i1cFy74o6HBwd57x7Sn7k1gRofqRtKJPgNHG3GFke
X-Google-Smtp-Source: AGHT+IF8nGggROX5vKzReOpSUVADbiSFN5w2xEMeH6w0EOMNRLghlofAoUsLTrtfmiHy1CJqQlz0Ew==
X-Received: by 2002:a17:907:3da0:b0:b45:7cb4:7d3 with SMTP id a640c23a62f3a-b46e4791066mr330604866b.32.1759307960664;
        Wed, 01 Oct 2025 01:39:20 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b40d70daf36sm450345966b.81.2025.10.01.01.39.20
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 01 Oct 2025 01:39:20 -0700 (PDT)
Date: Wed, 1 Oct 2025 08:39:19 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: David Hildenbrand <david@redhat.com>
Cc: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
	lorenzo.stoakes@oracle.com, ziy@nvidia.com,
	baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
	npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
	baohua@kernel.org, lance.yang@linux.dev, xu.xin16@zte.com.cn,
	chengming.zhou@linux.dev, linux-mm@kvack.org, kirill@shutemov.name,
	raghavendra.kt@amd.com
Subject: Re: [Patch mm-stable-fixup 0/2] mm_slot: fix the usage of
 mm_slot_entry()
Message-ID: <20251001083919.nuxs7jtv2rgyz4ud@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20251001010651.10543-1-richard.weiyang@gmail.com>
 <f1218a6d-b1ec-460f-afbe-3f88f3cc44ea@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f1218a6d-b1ec-460f-afbe-3f88f3cc44ea@redhat.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Stat-Signature: ohg9nb5ukxtdhmgzmjwy8nqccm4w9x59
X-Rspam-User: 
X-Rspamd-Queue-Id: 9A59B1C0006
X-Rspamd-Server: rspam10
X-HE-Tag: 1759307962-374985
X-HE-Meta: U2FsdGVkX1/MqpRBRLjwGEv+eNO5IqYVYqlK6TNwHdU1KaGujOgeSS7idbAimlMK51yvBCpQkXnMn7doux69SjIcvd3oCP1wywDc/ky//xMaw98XM1beDRYI1lXuPISJ/udUt8Ifv9eA33l/ebMzMfGHzDuzhQiLxJYhh/suC/zQb+19Gp9gpBiS+avM69t91MOOb6cMkrb4vBkumz0dP94p+Wo+01oRBHiDu839s3R84Kc004c3yaC/YiEyp9W11vUhKEiLnWWzlolnC2YjGqQBLpHd4nMyf67izukGwyvKEmCPWLzzOHx+C8eNId1JVQwNs0PbkT3xxhTDog8gyNtZaBBIiuC3AHgaKxy+pVs53SSJWQkAFmUUwc772AC8Eqt5Edp2PVHpYYWnnRtwymQpCkuC3zQpNwnUnck5oR8CjcXEfVNukVtc43JaTakSna64VJqr+BD3RMQ3ehHuIsKc4vC5z+1AS17ngXIZpL6Wbbye1gq8Q7K0nxdUkAVsxIw9JZjKHF0+buyTbhMipTBcueTALyRbWoZ9Y/2tXvylGV9GbDkG5PX6wXL5Pv6z7SLEoBGCCdFDHnPhL6R6T0HgoOWhtj9/8XMFXTN1djJWstGblXmlfUoT3Rk13yVRXNTSu52kRfG4tzzLqLmPzHrRAzc7PSEPTOLaOwWeaRgmggrENOxQRGmoU1Ie7M4hFqlo7+MLsjdq0errg3MoB3TpVfTtTEtrhPpppN8RqhqKuj8OoGtP4Y6Ynfr5wE19purrnW5RO+hmmLiZ8yMG2USQ5rCt3V+LXQ4XHnQgEumTSqyvEcYHQK3mwI90NDd9PHoW3CYokqAopVVYmzpMtf8wpsoTVm9f3hIZdyP4NIelj/0AqUKB3Q1k4HVAqRSXlQGewBXwlemG6QLhpNMnWa//e3xW1v9e2unXTfamqgXHCuQT+iMeoBSzgGSuWBkPeQ5f98Ic1Bc7f0ACwcu
 Xr0gAHw/
 OKSSiqJdROM1kjbqGufMMeoHhMpVbTsKRvY7pJ6eN0kA/Llb+bI/UAsEWvHTFEIHPoWOnWr7K/b4rxmfC8t3CdLSQx9E+E5X53ikQ0ce9cIMYOUSAU20wtkbIb2yiuSdjtJYTndibOpRx7eKUkqJPVBb+B3LRTKW+BlHO3UkeV9EyjeYQ5PeapWY6HaqWOzyL74l/uE1cCoPzvDPqVvDbwabw9rCd5v3wFDTxn92iq3JytnYMikt3dzvaPrEZ3yeAvgOwr3TzDxeAtsNNRkClVYd1IKzD+gEiAe95CIU22n1meoqjfzdw8SsDHcMJbBqqDVd60+ZrvvETgFkGqyVDh2XTh7x1K1gBnlqIUQdvxxr7uy7pBjkzU3KhFHR3eWYGlvS4LSLH+maYV5dI20JWQCn8YA5KCTFjxTLwDvEWHBpmMHgiuUl/aMNExT5RH2xSGJac1TyANMTyAgw7b0FG4+3r8EzHKgYlh0ql3O8JXWogfJ60CKOI0xJ0RptPuljeoXTlhGuQeNbXgjujJIiDMqIYSOztbAFrA4pghkqgbazqNsEqzJUDma6zWJRPSpDdhGgs33YWnlpBcCbFzZkr/VzUut91bxP50OqjVJwBPYtLw6mOPymhSbIwRohHhcY3Bi8TTsYnNyGGwletZKeUNHYvJggI4Q2+PLk2+4yTPiCdzhiXYRhvDZzpPrI5wVPLVPWfR8ZxPYqA0m7xqHBAu8au5KukNs1rYH4REYXBqUWfBsDLe5+IU46lg1oV/DcTUMvK
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 01, 2025 at 10:34:52AM +0200, David Hildenbrand wrote:
>On 01.10.25 03:06, Wei Yang wrote:
>> This is the fixup based on mm-stable.
>> 
>> The base commit:
>> 
>>     mm: swap: check for stable address space before operating on the VMA
>> 
>> The reviewed version is at [1].
>
>I'm confused: why "fixup"?
>
>Usually fixups are applied on top of other patches (to be squashed in).
>

Andrew mention he has merged v2 into mm-stable and ask for a fixup.

Not sure I misunderstand the process.

>-- 
>Cheers
>
>David / dhildenb

-- 
Wei Yang
Help you, Help me

