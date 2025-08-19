Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6CFECA0EF5
	for <linux-mm@archiver.kernel.org>; Tue, 19 Aug 2025 09:23:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5B3858E0026; Tue, 19 Aug 2025 05:23:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 56B3E8E0002; Tue, 19 Aug 2025 05:23:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 452FB8E0026; Tue, 19 Aug 2025 05:23:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 30B578E0002
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 05:23:00 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A98AF1DCAA3
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 09:22:59 +0000 (UTC)
X-FDA: 83792967678.02.88CBDB9
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	by imf05.hostedemail.com (Postfix) with ESMTP id AD3F9100006
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 09:22:57 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Wx7lzj+A;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf05.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.53 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755595377; a=rsa-sha256;
	cv=none;
	b=RsRWShlXeFqBzhBSoHImYTJAu5AkbtFM2Ye6cvNzWFVTIpMpbn1K8EnJzG0ttJVI7Wzjvk
	JWMysUA3mwZvySmFZAsVW1RcUFqZkRWvuusn37fVz1Fl7nU5BTmb7GpwSW5eQ7AMrIBCCd
	XgthLr329cazSelDkyNPmtg9k6yf4ZU=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Wx7lzj+A;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf05.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.53 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755595377;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/PiTmIvcXIWmnCk2bi7fdSkP9CO3hr2liu1TEw3WtOs=;
	b=UVtsv4IaVufwO/HzUA0HfBAHQ0GnIXZjohlTTfglJ9HfISF9AAG7/6SsL4h1FVKn11Yw3Z
	T/WYoGylMa48bXjFqYoc6j0Fyx/v6qKwpnS53hkBMJ/DgGUarMOH4SKORkhOJ74e3XoCKc
	Gns995sWhFYdKrNRm1UPtAVM76ctL/g=
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-618b62dba21so4704658a12.2
        for <linux-mm@kvack.org>; Tue, 19 Aug 2025 02:22:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755595376; x=1756200176; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/PiTmIvcXIWmnCk2bi7fdSkP9CO3hr2liu1TEw3WtOs=;
        b=Wx7lzj+Ag4rsJ6uEwmNO5qiGNU94Sv7ToI9pw5q7C3aJPg8jH6kysEgF15VQsUOBHF
         5Qe2dSMfh5153+RMmvxOske1KV0F3an4e9H/DfVzLLOeyUBzajmAOY7WVUeUnQSzCvR+
         WPH5Vjhl8e9PRaQxQ2ByLtBKTfMTyVG3hVCBNyj/PfWaZX1ugO1DsoX87hnTJ9qUiMnm
         A37oLLQfcyl0gUBOQbofopMNk0eoB+YLrSICiviCsG40ES51FeAqBF7AAmHDUkmxirci
         hH06s+WqTx0DYpcwWtwol2+quiYBkzr/fcuCz3oW0XVYbMXFn3zvA+sbd7I3V/NTD51q
         IWig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755595376; x=1756200176;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=/PiTmIvcXIWmnCk2bi7fdSkP9CO3hr2liu1TEw3WtOs=;
        b=bYvqkesqPCfY5TaWBCAV1euSBVKL8lSznlWA4yUQ7DIPBw4tjd+veJgvhp9Lzy1+TO
         WrGf1z9mtOs/axYKPRf6xZbraMoW3kLmY4d835m+3oRC5mPoGi1hRQsS+wCV/t1hEt85
         Nhc7DExduz9KFO3G0AY7o19N6P/+w8X4GCN3jV+2J9VUAf3bPuCPAPSthugPMuk82D5H
         4OLX6qgCdqIvsNikvhJYbaf5bPmmvAMwv8IFZJ7VCgyRyhX6YVA81WsTNA5mEaL6KZiZ
         HW+GFlxrV4xpctf0AtoV2f5qmB+9eexhguBhQJiMn2MFzGZki9PNhPewrbDNhzbTGSaq
         ckZg==
X-Forwarded-Encrypted: i=1; AJvYcCVgdO5TLvGMFl7dvmL9Pg3ssLq6Str/wfSaSbgQqMoRkIw8Mbn9wFIFJLt4Drp1C1uuvmfwD7wuHw==@kvack.org
X-Gm-Message-State: AOJu0Yx3t5drR5FuzP6oIXQ01FnwIWTV6ApELZP4WmW1JdpjOmgIcp2J
	NR2cfzE4xGmOXhMvQsG5wMsuTnEuaweasscyC9WDeY1JFMtCADS+vP+4
X-Gm-Gg: ASbGnctF/NKM8Za0am92v0cAhGWbCsd2/kPZS/vGpOdbjavlc4cKjJiYGeKR8S2dCnv
	LuIhbKvUg40q4HpFxpFDI4tbIxY9wc2zItP9PNkknHtjvkOA12H6SUaE2N9fyiSJ/mMPyA6957y
	rRZL0Rwem8YvYZxSKu7zsPgyw9W3+jVOcGL/q6EBDY5d+NJOMdt15QbV4KdPKHwXhhxQC1UND3E
	tXJF4aO5TkF5VUEKgu4zqQ3jz+eSLGcWh1gHSJ8yx/N7DbOlm8/J/AO2fRNy8g0jZRBltjMMUOF
	RWLTITfE21qm6M0d2vcl2THWKYa6iJ4dQeUdA3tf8goRF9awx8DRC9J5KAyKld7xSF9mGKXsLy5
	p6U4uw5IeU+zOIOFwX2s6BQ==
X-Google-Smtp-Source: AGHT+IGWpnAEgDV2y4INDQK6XxsdDqFMGmNPUYQ0xXd1Cp2WxE73D3UX/rFS8w2LlQ8JvhzNRZ03EA==
X-Received: by 2002:a05:6402:3494:b0:618:3a9d:53da with SMTP id 4fb4d7f45d1cf-61a7e765e7bmr1296928a12.31.1755595375783;
        Tue, 19 Aug 2025 02:22:55 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-61a761f2599sm1333486a12.5.2025.08.19.02.22.55
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 19 Aug 2025 02:22:55 -0700 (PDT)
Date: Tue, 19 Aug 2025 09:22:54 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: David Hildenbrand <david@redhat.com>
Cc: Mike Rapoport <rppt@kernel.org>, linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Bill Wendling <morbo@google.com>,
	Daniel Jordan <daniel.m.jordan@oracle.com>,
	Justin Stitt <justinstitt@google.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Miguel Ojeda <ojeda@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
	linux-kernel@vger.kernel.org, llvm@lists.linux.dev
Subject: Re: [PATCH 3/4] mm/mm_init: drop deferred_init_maxorder()
Message-ID: <20250819092254.cddlg6npwl75fvbn@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20250818064615.505641-1-rppt@kernel.org>
 <20250818064615.505641-4-rppt@kernel.org>
 <408d7eaa-5aea-4490-9fd0-978c4eb94d32@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <408d7eaa-5aea-4490-9fd0-978c4eb94d32@redhat.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspamd-Queue-Id: AD3F9100006
X-Stat-Signature: h36ehwji96bmd6mct9iqt4uuruo33of7
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1755595377-335620
X-HE-Meta: U2FsdGVkX1+OJrvoo9YxmgUjtnbts3qSxjdOvr1uBklGrgjiOsJs0Zzycts1xZpLp34SUPsachbO2/VtRl6iBjxaWha7kOxtkNwc4S1GFG8pxwt2aPOH50luVFEkm4jMS6MajV5aUvI4nj+I9pS6nV4V60cFPZo70Xg5CTrKVYkDwTgz48eQcCMgfojY0vDrWHYPSHKeF8SjDOtQphEc75y6W/er3NqGJ1G5rxl4holoi1l+bBnYwUK3td9rg9wiZabDjKv0ZtvhKRuCbKK1MFjlbg8a2CTaxnjeBiElsqRKcCrJKfCUkYSP8qg+CXIFLe+iNST1QgYbSbrCIHsv8D8yfuPH1mPlWsjT0beKjCjAXcFBY2eFK+8iV/V5DWTXzzfs/neVnOQWZ+hhJhUHn0wJYsKm+8tIUacfnwWUa2u5abHIJGnQU7hbv0E7UMNr3obn6vj18Y7eUWl+zJeCg52doGJnz0QmeSHJbwzyzdUFh1IYz93Z4vYtiKd87+A1koTJtLIiapLHudDCdy+nu0ox9RC34kQNgo/VkBayHsL62QOrA8n1w1CWRsuIWJNsXJgKBc5MpTDt+oUprHYO5fsWW5RLUfywQcAejdnRQnlvno7clYjHQTRYygWXv5e+eepBsjZ41ylu6q/7byfdWB/OOzxj7wIZ8VIAzZrRYymaNKR5AcWTSJimzWQGBgK+wlpWuXxhQ7NqmGJd2cZBfCMO55DWZJ7HeRElZpLhI1f641Z/wtNL7PLrUqbW2ExICvQLw/boJL5TplwrfvTgPcHBKTRcSASBgnhLzl2cODrIrEnXbPlxcSrfSKWmLMR8nwjNAA/lxWRvlYEqqpT6aiBstYTnOYgyAchvYljwu21JER6fnjkC3/QI2aoYd1j2kFZNW5/PE4e3/JjFvmhIDSQlK2f9XYmeYRWaAALP001NKpzhG6vNoJ2mfjO2woQ+0L+/VBJycehB1W3WJZp
 3DIk1a4g
 Fl6ufaKX5hqF2Kfs14wLyzHmRnTBipjlhIRxB88BI/B1wRRpcbpIY0l3zCihM3ELhKfN50yMIP2nCtZVx/kqFOuurE9+CkcnpQ7z3Qakf/2cqGBYPRdiKGGkWQ3VMf2PR1PChS+uJejvyNASD1kVWch3RMPIhl5GQ6eA7FJVc2pOjC4j4F/VLoU9Qzd3YvCTmhAp04pi/T+fd3+nPnHfU/9pYfyz8atXZkCxbJTfs8MRSb1b5uH9je9C9nKjVS26o9OuV/NM9n8x9HoJF8XLe391krmpfpcvdRwnAVvOdqb90L8aTUjl2m2xj4yqlOctZudP56qK2UC3gVOanmqrvNMt0UgaLJscZhBrNKq288+Z2e41doJyWpznhTaAOmndyXD0nYNFLpd2voIXzPp9Jmsyab9eiz4nQjAPFHTuUKbeOAh/3so4BxQJutl0E7c7ngjs74+YCb8LFNuwDRZ98ZWGgdylSRHXLIn69oGYbowRgdyc8QLNIPDl7KyMUs5bpKFhoDpjiKEisPNM5HvaMuZqDUW06m3aF9jnYJAgrVOubL+KG1KhiTPbRfVfOUF62pzZ4KMAsyF3RWDYQBsuJa2tdrViFvX5HkvijM1kCDL2U2oJxZcwDi/foOZNi4wb68RL2ALAYVeSRv6JhTG1PL4zP8/8fG4qzeJrTqq9XvbKrlF3ZHrSNVDIaPk09Um6yo/3Yk4QDqfMtMQk4fe5hUD/Niv8EDaB02WJeJzljzL5AU1i/dyYsdFRavCtguCPxK8oV
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 19, 2025 at 09:54:22AM +0200, David Hildenbrand wrote:
>> -static unsigned long __init
>> -deferred_init_memmap_chunk(unsigned long start_pfn, unsigned long end_pfn,
>> -			   struct zone *zone)
>> -{
>> -	unsigned long nr_pages = 0;
>> -	unsigned long spfn, epfn;
>> -	u64 i = 0;
>> +		while (spfn < epfn) {
>> +			unsigned long mo_pfn = ALIGN(spfn + 1, MAX_ORDER_NR_PAGES);
>> +			unsigned long chunk_end = min(mo_pfn, epfn);
>> -	deferred_init_mem_pfn_range_in_zone(&i, zone, &spfn, &epfn, start_pfn);
>> +			nr_pages += deferred_init_pages(zone, spfn, chunk_end);
>> +			deferred_free_pages(spfn, chunk_end - spfn);
>
>
>I assume the expectation is that all PFNs in the start_pfn -> end_pfn range
>will go to this zone, correct?

I think so.

defer_init only apply to the highest zone in one node.

>
>-- 
>Cheers
>
>David / dhildenb
>

-- 
Wei Yang
Help you, Help me

