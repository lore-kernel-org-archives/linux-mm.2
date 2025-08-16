Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47597CA0EE4
	for <linux-mm@archiver.kernel.org>; Sat, 16 Aug 2025 00:34:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9F3208E0227; Fri, 15 Aug 2025 20:34:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 92DA48E0008; Fri, 15 Aug 2025 20:34:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 77ABB8E0227; Fri, 15 Aug 2025 20:34:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 602DF8E0008
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 20:34:01 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id DA1DB1174D8
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 00:34:00 +0000 (UTC)
X-FDA: 83780748240.11.537CEF3
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	by imf14.hostedemail.com (Postfix) with ESMTP id E2630100006
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 00:33:58 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ORWIENlO;
	spf=pass (imf14.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.54 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755304439; a=rsa-sha256;
	cv=none;
	b=3fyw9UKyTnT3xj6v1O3B/mEO+BLxG3OpKFQttlA72Rc6SREmy+uZhl5Yu8pZuL7+7LsH2A
	Cn7YPBp1VDq5enKP9I5hShMCL44Un3lljG/KslfM6d5zZPztHqq95/6eoOA2DZ2MA0hbfX
	VaXFK/txdDkNSbRaJLccaOBUFeHM7V4=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ORWIENlO;
	spf=pass (imf14.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.54 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755304439;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D5aliKGPsEk2kGTfzow9n6tqR8UrND7u5k7VIkgXzV4=;
	b=N0/O/rx/ZOqSwZm5hLfSgOckY3lCacSkWK+ppWdc2HQrzL+PY3gSLrJYCgHq6HKNXMA3YA
	AgKlPXaOLg+M0I9HxaGDp/QPxxKWt064yEvPJvTzU0312wmS2+vEx4iv7C2N+pKngEKjs4
	yrc2Xs5kRrMktTixTu87JUKnQ3Aql1A=
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-afca41c7d7fso562681066b.1
        for <linux-mm@kvack.org>; Fri, 15 Aug 2025 17:33:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755304437; x=1755909237; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=D5aliKGPsEk2kGTfzow9n6tqR8UrND7u5k7VIkgXzV4=;
        b=ORWIENlON/jAn2OhrGBC5M45+KrQdRJJbM8Q6y6rGwRGfmGrngYlIU+DFPosETv3ge
         XSFLHA9hoHMHT61XsNXOw/BoMp0sGaTaoVWrETnBzgQ5V2H+Q11Cngj5X/c7sAcC/uLo
         nKq+5Gk+aXEfJ1Dq5jeX5UFD/6TUB4cSjBKYShONFCyGWt3EZIMIYTogMKM7SNnNLSdF
         jKuC7wvWSZg5Eqnwaf9yu5rsac7XhqHN64tV31NxmV9SIxp+x3A2nk6RIhXiG3GH505B
         qe/elAXyB5NT6WnYXMqfLJtt958rHcqUQ4RhzH/q8UzVW5pFolMDPKBqWozJ9GekmVVH
         5J1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755304437; x=1755909237;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=D5aliKGPsEk2kGTfzow9n6tqR8UrND7u5k7VIkgXzV4=;
        b=GRoxNN+rHVHe2cuykMMlENBkdVRq3HLI+J2ILhkMdm374Img7cGk8a2mmrkg4/KGm+
         3hhAJKid1X+eLM4G7+m2HRcIGPBNBSYw2q0t1AQu7F7R15XFluqTUBUmLTlo3aiLWHVs
         UWMCv+pQtB8GWh/9NuERVzHxWhqO9XPKNAySdn2xxaoY35eqcVmmp9OARmCpJAqKS/Pu
         mPCsYpvhFwGBLqgQiukGFEywT0O1+EJp0r0BQH8bT0Sy+TOzlPMPl1J32kp0J6bpIPPT
         rf5HZkAmNHsOJKCNzmPdHPjgzQXxnM87ioLIVJ16xkMugFsfqxx3evUyjVQdBZooKnO/
         pdDA==
X-Forwarded-Encrypted: i=1; AJvYcCXTodg7810NgchJv8Egtd7S/63BkQAn/B7xLBkQ1DLXdDz+1d6qtvtuE1uvEzpmfCQN8h4Nxrb3qg==@kvack.org
X-Gm-Message-State: AOJu0YwiuvwLmLaePYAwFD7Xo8spadyFqaj2/TcCCR4xOiY2zlwB7D5g
	MO1M6gOUxMkJQzuJVEP207h/ULdtAtKD/34Y2P8GhmVNB/igMocV1lsY
X-Gm-Gg: ASbGnctqYCA1uScyRBaR0SeKzYXt5K+hoS/BM6iW6i5y+dQo/iBAHgYONISg6xgFm7j
	iT6b+8e79kt4tGgvOuYVvSyxF3gBsSZZrC6LSWkHo2rWB01m43IrmKBhiO+PB1eEOGLTOLzx2uJ
	1C6wvrOdXq9hGLErSiGsTmBNwS0xyD9L5NZg4bKX0oPnlxw0/RIvZb9l41QwzLN94cNHEZy0Miu
	TKjkYzJjoS8Ers5e/37YadkkmvVC6Cs0UB/UkVjm18CgsvCVyGidxcf2TmdVcoqoDtX2LleC91s
	JeeciMv0es99st8HxRco/W+1KGhHOqhPS3UHZX2ligEFYHStUkqU3xqsuKpxULX2wAXDyl1PLNO
	Ye98CVhCP/7Q/36orsdBFUg==
X-Google-Smtp-Source: AGHT+IGRp+J9DbJqL4RicHtwIxclMmd2zEIvkHCcjv/6PA7CfgNcRVu19T6ddckk8pR9SCWczYMilA==
X-Received: by 2002:a17:907:1c1d:b0:af9:3f99:1422 with SMTP id a640c23a62f3a-afcbd5cbd9fmr807342066b.5.1755304437046;
        Fri, 15 Aug 2025 17:33:57 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-afcdce53dedsm250584566b.1.2025.08.15.17.33.56
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 15 Aug 2025 17:33:56 -0700 (PDT)
Date: Sat, 16 Aug 2025 00:33:56 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
	david@redhat.com, riel@surriel.com, Liam.Howlett@oracle.com,
	vbabka@suse.cz, harry.yoo@oracle.com, linux-mm@kvack.org
Subject: Re: [PATCH 1/3] mm/rmap: not necessary to mask off FOLIO_PAGES_MAPPED
Message-ID: <20250816003356.l24hortwyttve57n@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20250815084943.23063-1-richard.weiyang@gmail.com>
 <20250815084943.23063-2-richard.weiyang@gmail.com>
 <d1800d00-b983-4a14-8338-f1f30c330ab1@lucifer.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d1800d00-b983-4a14-8338-f1f30c330ab1@lucifer.local>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: E2630100006
X-Stat-Signature: pjccf1mxxam69stgetzk1we4x6s4sjjz
X-Rspam-User: 
X-HE-Tag: 1755304438-248092
X-HE-Meta: U2FsdGVkX1+Ln8Z4D5m1HgTuBiaD8Fg6dcgbIAFbgYLxpEnGR06xl6Uq2ZlCHwjuZkvA9+WYwZwZaNm3H4YIUVvlJ85+Rpn3/UwJd7Do7azGibk/FYpffhvKIq42qDMtICqQtsQHYSBsAp9PMq/J7vUuQryRiR5oMXQNj5d9dBMMtyWFjxRiOHQEseepgWxfDoUh5/aCF+X9eSPsMi53p94ufVTy56UQOwyQdHx7H7vVSfWIQvmU7IZjdLxstBV8Kr1O0Kajl0uSgBxJYSKe7pbHG4+mdkwsZMpYRsfROl4aSeUGHYEYs6XDyUF2SdadEpHVjVkS5GmAafNFS2Ny4QU2fDv9MM6zlhtriCZYr0VshPFJHFnQdmWn19a6l/cOKJ1w7lVz6l1g4PJEMwh/t01c52gsv0Egk5srh09/FFHog1qvhw5jsAS2gpTdvO5FUxtltVwqlpPtGp4SkoyzlIQCInjxB6ouzrWYpekX6NujMwm2xnZj/1K+gy0oz19Qe3RKiuklNMAZYtmWZychHB5Lq9snU08WrRov4Ayp3QLS9V4MhaahRf5mPDqQ4phAt/RF/noCCC0xwpJrGHR/fYd4aizaYmEtoguPtLQwX4T+tarGMKi3M6o5P8cnl6dS7qkyZBRuP7d1gFlSMjUZxBOlPAmPeBRZT4iiz1aiXomLnoc2uG440rEOoMZS6WUz+ppXCibMNU2N8OXC6Ytwo2qkdKkIMS7OKXs+JgIZ+PqydriwVeXSyvmdinvJo7dCF9p/9tTTlwLKT+JVNwEe3ahUYmT88Qp+Hos97G1L+D3ZLxgg0ZQFd37ZM7UgftrS5erGQPIkuF8U2ZKpAbOz7byYDLgYnhJtotTWtm+uv9m0dThAVCxRv/cq6Z73ejCW0gImktGLyBNKlZdtvJ4Lmc4b4gI9T0SzUuJKnJiLEszAZlGRp0nOq/SPM82AmQzTiu2Pl2N/nMmp23T2qUI
 rJz6ijUB
 sE1uJZHNmudxjKxgVIoo+jBYTCda/4/SUV71LP5x4A6VecnOm1U8fUMtg+hNye8qP0EX+bz2A9algTBS0fKjMOGv2iJvm4dgg5LhlB91+WAbn1F4LpVT1jjrVs/5mMXug+T2rxQjg9KZ845u8mLWzkzVQBeUW6LTQGIedMN3rdKvxDviaB7iAvknk4kMQabThngzBFPlHKOHlWS9prlRQvlL6nsPz/7oSm2TnH+GzmlP0kJSX7maWHTuq3lHo1GESbd2QSYJ8B8fjCi8K7TVgEQxriA+f4GYdhVb80oTTWWLDRwgvbSN34tCT3RsHuR1lKsWrbLjgMTac2cl+GJGOvlWJCrtHh9aWjSSZZ03Tmi5fmNXvHqiPE+U0ihAxmzYVI1Oe3JBicKrITYMeMaxWDCDbp6Ja9ux2bOqaStmFzPvhfP6WO06iYbwGWTidDw0quL7MtJSZPKA6gW3usC+4y8dvR54ja++0I5sDvsqi0c/JRpmPE6y48FxMclKbu8Yk581DcEPC7/UGrZQNGILPBWABGsFNAFM3IIP8sE3qIxnaIKyfsVT4yJS6gxNdD5v9tFIr9Fp/Z2AlwqU/I5tpwIaF8gnMuCQJs2ZZlHtPp7Oob2GlRNJLr+RhhPi96spdU1Dplp2JSeLFDUmkfvQz3eRsA5f9RK1ns7wfWoLJUe9oRRnAgjFrViaGqkezky+BeIBVd8Bq/GRISFlLFYWklXV28DR9vQqz+kk7QtmLwfOfF3qV2TY/4iaKrkWeUcrkdJ0uEMA7As+zJho1/ubt0pIyZHn3wbbAYSYBzD1AKNgwR3c=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 15, 2025 at 10:38:32AM +0100, Lorenzo Stoakes wrote:
>On Fri, Aug 15, 2025 at 08:49:41AM +0000, Wei Yang wrote:
>> At this point, we are sure (nr < ENTIRELY_MAPPED). This means the upper
>> bits are already cleared.
>>
>> Not necessary to mask off it.
>
>Worth saying it's because we are in an if branch conditional on nr <
>ENTIRELY_MAPPED, and FOLIO_PAGES_MAPPED is equal to ENTIRELY_MAPPED - 1.
>

Will adjust it.

>>
>> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
>
>I suspect that this is copy/pasta from __folio_add_rmap(), but it may also
>be some way of asserting we don't underflow nr.
>
>Anyway I think this is fine because the branch implies this is ok so:
>
>Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
>

Thanks

-- 
Wei Yang
Help you, Help me

