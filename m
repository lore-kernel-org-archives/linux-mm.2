Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BFB0CA0EE0
	for <linux-mm@archiver.kernel.org>; Wed, 13 Aug 2025 08:14:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EC7C8900046; Wed, 13 Aug 2025 04:14:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E51F9900044; Wed, 13 Aug 2025 04:14:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D1A01900046; Wed, 13 Aug 2025 04:14:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B6A5F900044
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 04:14:37 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 68D18136B79
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 08:14:37 +0000 (UTC)
X-FDA: 83771022594.05.CFEF4BE
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	by imf22.hostedemail.com (Postfix) with ESMTP id 56DF8C0002
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 08:14:35 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=a3Bxb6og;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf22.hostedemail.com: domain of colin.i.king@gmail.com designates 209.85.128.48 as permitted sender) smtp.mailfrom=colin.i.king@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755072875; a=rsa-sha256;
	cv=none;
	b=u8P32bl5gZKc9kFFflIjAq18K04zsSYEplU1vUb0LobtcI2//jACE0al73YTBbX+lxnhXg
	wvtkQ779957iCZ75BQuRhDWea5lmeZU3QqcZZzJfXVxTSvhDe+ggdoJOVdo21IXfuL+TzC
	gntFbLequFrHdqFgaRg+I5BTz8HJWC8=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=a3Bxb6og;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf22.hostedemail.com: domain of colin.i.king@gmail.com designates 209.85.128.48 as permitted sender) smtp.mailfrom=colin.i.king@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755072875;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QK+B4ggIeYqwLfgtAoxtDSY1SouaqW3O+Bn9+7thAC4=;
	b=cVn6o4W8ACiGDVHuH8OkHECfwqhESyQK6r3ImFrDVHTH2jPdjD89IwRe28Y61uJgmG60IH
	4ykwmRXkAGTfIRzDVGEmvTyS5eBxJku107Di/KZFISRsqYVYMmIL/KkxJMsg74900+r2bF
	H+MuACW8rF5zj0xouI1JJ7RQbzVzPHA=
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-45a0dc77a15so16822545e9.2
        for <linux-mm@kvack.org>; Wed, 13 Aug 2025 01:14:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755072874; x=1755677674; darn=kvack.org;
        h=in-reply-to:autocrypt:content-language:from:references:cc:to
         :subject:user-agent:mime-version:date:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=QK+B4ggIeYqwLfgtAoxtDSY1SouaqW3O+Bn9+7thAC4=;
        b=a3Bxb6og9UBoZekqd0xeRvsTu9gZ2zKHMxykXnOo/nFG2imDWGJ8NnpSiYgKr0DIvO
         Qmn0+UIr0H76u7Hwi52BShXSBG+vV9U1sRp3A/+uF/txQvvLUNlTTroftPNtPdD1Bm2Q
         JJ8JbQQxS1RDQCWuiPkHz2iHOH6iheSC4Ol1ZX9HqaYZ3VFe8Mao3jisRrlpuCysKD1D
         Vd4lmncdMO5i4HVAst3ylKhzhaTjaj1zjJYrLoyta2i4XDULPrhupdTOVenawZRvy/F5
         Z5jpKCkBHbk7DcUo5jzZqGNA5ISyJrHU2jzBf7oxaD4XEc8GlH/K67lBkfvrx6dar7Fy
         T+Zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755072874; x=1755677674;
        h=in-reply-to:autocrypt:content-language:from:references:cc:to
         :subject:user-agent:mime-version:date:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=QK+B4ggIeYqwLfgtAoxtDSY1SouaqW3O+Bn9+7thAC4=;
        b=fXXQ+uxbLqQsdi7xax2TGE/r4phRETtlnp4SYHOKLDoZMQYrfnJcDGi4p3FWElvElu
         1wpayL4g55xphQNFgfGR7EWL5V1i0S8qD2e8piIS6c5BY8xezaSQ0k9T6lYpvxgA3/Vu
         IU4CygxKaRpf9YnIXAMVMNYxcO2oU8omFAo0Bo8zIMBxPyILQNBbYU73V6sfqMWrFCWW
         prBdZ4BfyLd2qXDPnSepjaNUg7fRrv75l3YoQfMKE6qaCuX2vZ0w1EElVhqSpk7O806g
         WmS1Qa0u2Rs4qhrcylPkcQUTs7t+lID/joi/vwt0Rd7UDXr9wX5KyfAmeaXS7i/nhJbW
         4/hw==
X-Forwarded-Encrypted: i=1; AJvYcCUF2ZRR5pkEowywLIgc22WZmmjPJ4uJSAxUynYCIm7Wcue3DhP1OTqwFAc/Jt9EfF7ujDvSnmJ4iA==@kvack.org
X-Gm-Message-State: AOJu0YxYtGrbBFqT0/4/sGLxxvIxRF08IY3FoLVzd/PF8GtT2MO4Q+7q
	d59UHE8oZHp+W96djHStrpvlADi+gOsH7dzseNrddOET6VGoF11k77P3
X-Gm-Gg: ASbGncujBlYisAPClDCMtjL64pboAkGrozsmoL/4cAM0VcjG2oJ+bR+URBRKb7aGoDc
	cV06W0ABh9spLs3VQ0v1E2qY9UQ6h1wm3Y6XHXKXMBHV9bA0rRjCkhvePaUPXs+KvWco5ZWFlsT
	znV2Ik0PLJ7vl92Vz+UmPKe8I0Bewwyz/e+sInNxJc/NYMDV/UynQMgtktU6c2yAcGPkrjPnD3F
	fmRkwDcyW4/RBPnXQHzr8Y3YCY9TY4+mtbWvK6cS1iHLjWloGEsjZmsrPBDW17a+124NYswS0KI
	vkByaR79Mc4wflmgPQtQ1GfRznmizfoZNRT7Jwcqnxxbjiz55kGQfEtRrMB6KOgpGSDNkn5ifCk
	RXKXQccnLqlHuo/ZYxh2huhW/9dpO
X-Google-Smtp-Source: AGHT+IGiCfhZt2+h1LjoMjjkJYyGOJ8z07EZ1hFw8yW4zOqMoQdR12QS2QYg7/b6nTNQu0Ht5AEdLA==
X-Received: by 2002:a05:600c:1c90:b0:459:db5a:b097 with SMTP id 5b1f17b1804b1-45a1962e4ebmr1261065e9.16.1755072873742;
        Wed, 13 Aug 2025 01:14:33 -0700 (PDT)
Received: from [192.168.1.248] ([87.254.0.133])
        by smtp.googlemail.com with ESMTPSA id ffacd0b85a97d-3b916394937sm2830210f8f.6.2025.08.13.01.14.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Aug 2025 01:14:33 -0700 (PDT)
Message-ID: <569017fb-fe8d-41ff-ab23-db80a077f725@gmail.com>
Date: Wed, 13 Aug 2025 09:13:53 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH][next] selftests/mm: Fix spelling mistake "mrmeap" ->
 "mremap"
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@redhat.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Shuah Khan <shuah@kernel.org>, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, kernel-janitors@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20250813080156.1977375-1-colin.i.king@gmail.com>
 <5a38db18-494b-4f3a-8ce4-44bab5448559@lucifer.local>
From: "Colin King (gmail)" <colin.i.king@gmail.com>
Content-Language: en-US
Autocrypt: addr=colin.i.king@gmail.com; keydata=
 xsFNBE6TJCgBEACo6nMNvy06zNKj5tiwDsXXS+LhT+LwtEsy9EnraKYXAf2xwazcICSjX06e
 fanlyhB0figzQO0n/tP7BcfMVNG7n1+DC71mSyRK1ZERcG1523ajvdZOxbBCTvTitYOy3bjs
 +LXKqeVMhK3mRvdTjjmVpWnWqJ1LL+Hn12ysDVVfkbtuIm2NoaSEC8Ae8LSSyCMecd22d9Pn
 LR4UeFgrWEkQsqROq6ZDJT9pBLGe1ZS0pVGhkRyBP9GP65oPev39SmfAx9R92SYJygCy0pPv
 BMWKvEZS/7bpetPNx6l2xu9UvwoeEbpzUvH26PHO3DDAv0ynJugPCoxlGPVf3zcfGQxy3oty
 dNTWkP6Wh3Q85m+AlifgKZudjZLrO6c+fAw/jFu1UMjNuyhgShtFU7NvEzL3RqzFf9O1qM2m
 uj83IeFQ1FZ65QAiCdTa3npz1vHc7N4uEQBUxyXgXfCI+A5yDnjHwzU0Y3RYS52TA3nfa08y
 LGPLTf5wyAREkFYou20vh5vRvPASoXx6auVf1MuxokDShVhxLpryBnlKCobs4voxN54BUO7m
 zuERXN8kadsxGFzItAyfKYzEiJrpUB1yhm78AecDyiPlMjl99xXk0zs9lcKriaByVUv/NsyJ
 FQj/kmdxox3XHi9K29kopFszm1tFiDwCFr/xumbZcMY17Yi2bQARAQABzSdDb2xpbiBJYW4g
 S2luZyA8Y29saW4uaS5raW5nQGdtYWlsLmNvbT7CwZEEEwEIADsCGwMFCwkIBwMFFQoJCAsF
 FgIDAQACHgECF4AWIQRwYtqk8AG5xmFnAM9owoffxqgCJgUCY8GcawIZAQAKCRBowoffxqgC
 Jtd/EACIWcaxfVt/MH4qqo5ELsjCFPVp+RhVpQDWy8v9Np2YbTcZ4AY2Zj4Pq/HrZ3F/Bh02
 v85C6mNv8BDTKev6Qcq3BYw0iqw6/xLNvRcSFHM81mQI9xtnAWIWfI9k5hpX19QooPIIP3GO
 MdMc1uRUGTxTgTFAAsAswRY3kMzo6k7arQnUs9zbiZ9SmS43qWOIxzGnvneekHHDAcomc/oh
 o7kgj6rKp/f9qRrhForkgVQwdj6iBlW934yRXzeFVF3wr7Lk5GQNIEkJiNQPZs54ojBS/Kx6
 3UTLT1HgOp6UY9RPEi9wubmUR+J6YjLRZMr5PCcA86EYmRoysnnJ8Q/SlBVD8nppGVEcuvrb
 H3MBfhmwOPDc3RyLkEtKfSTB92k1hsmRkx9zkyuUzhcSnqQnpWGJD+xtKHvcHRT7Uxaa+SDw
 UDM36BjkyVcZQy8c+Is2jA55uwNgPpiA7n82pTeT+FRGd+7iCLQHaryu6FO6DNDv09RbPBjI
 iC/q814aeKJaSILP1ld9/PEBrLPdm+6lG6OKOt9DDV6jPmfR96FydjxcmI1cgZVgPomSxv2J
 B1erOggB8rmX4hhWYsVQl1AXZs3LdEpJ6clmCPspn/ufZxHslgR9/WR1EvPMQc8XtssF55p8
 ehRIcVSXDRcMFr3ZuqMTXcL68YbDmv5OGS95O1Gs4c7BTQROkyQoARAAxfoc/nNKhdEefA8I
 jPDPz6KcxbuYnrQaZdI1M4JWioTGSilu5QK+Kc3hOD4CeGcEHdHUpMet4UajPetxXt+Yl663
 oJacGcYG2xpbkSaaHqBls7lKVxOmXtANpyAhS5O/WmB7BUcJysqJfTNAMmRwrwV4tRwHY9e4
 l3qwmDf2SCw+UjtHQ4kJee9P9Uad3dc9Jdeg7gpyvl9yOxk/GfQd1gK+igkYj9Bq76KY8cJI
 +GdfdZj/2rn9aqVj1xADy1QL7uaDO3ZUyMV+3WGun8JXJtbqG2b5rV3gxLhyd05GxYER62cL
 oedBjC4LhtUI4SD15cxO/zwULM4ecxsT4/HEfNbcbOiv9BhkZyKz4QiJTqE1PC/gXp8WRd9b
 rrXUnB8NRAIAegLEXcHXfGvQEfl3YRxs0HpfJBsgaeDAO+dPIodC/fjAT7gq0rHHI8Fffpn7
 E7M622aLCIVaQWnhza1DKYcBXvR2xlMEHkurTq/qcmzrTVB3oieWlNzaaN3mZFlRnjz9juL6
 /K41UNcWTCFgNfMVGi071Umq1e/yKoy29LjE8+jYO0nHqo7IMTuCd+aTzghvIMvOU5neTSnu
 OitcRrDRts8310OnDZKH1MkBRlWywrXX0Mlle/nYFJzpz4a0yqRXyeZZ1qS6c3tC38ltNwqV
 sfceMjJcHLyBcNoS2jkAEQEAAcLBXwQYAQgACQUCTpMkKAIbDAAKCRBowoffxqgCJniWD/43
 aaTHm+wGZyxlV3fKzewiwbXzDpFwlmjlIYzEQGO3VSDIhdYj2XOkoIojErHRuySYTIzLi08Q
 NJF9mej9PunWZTuGwzijCL+JzRoYEo/TbkiiT0Ysolyig/8DZz11RXQWbKB5xFxsgBRp4nbu
 Ci1CSIkpuLRyXaDJNGWiUpsLdHbcrbgtSFh/HiGlaPwIehcQms50c7xjRcfvTn3HO/mjGdeX
 ZIPV2oDrog2df6+lbhMPaL55A0+B+QQLMrMaP6spF+F0NkUEmPz97XfVjS3ly77dWiTUXMHC
 BCoGeQDt2EGxCbdXRHwlO0wCokabI5wv4kIkBxrdiLzXIvKGZjNxEBIu8mag9OwOnaRk50av
 TkO3xoY9Ekvfcmb6KB93wSBwNi0br4XwwIE66W1NMC75ACKNE9m/UqEQlfBRKR70dm/OjW01
 OVjeHqmUGwG58Qu7SaepC8dmZ9rkDL310X50vUdY2nrb6ZN4exfq/0QAIfhL4LD1DWokSUUS
 73/W8U0GYZja8O/XiBTbESJLZ4i8qJiX9vljzlBAs4dZXy6nvcorlCr/pubgGpV3WsoYj26f
 yR7NRA0YEqt7YoqzrCq4fyjKcM/9tqhjEQYxcGAYX+qM4Lo5j5TuQ1Rbc38DsnczZV05Mu7e
 FVPMkxl2UyaayDvhrO9kNXvl1SKCpdzCMQ==
In-Reply-To: <5a38db18-494b-4f3a-8ce4-44bab5448559@lucifer.local>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------dG5z6K4ZS0u4OAlYP03UPbK1"
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: 56DF8C0002
X-Stat-Signature: 4n57w797849sjrg33aody5f6az6wuawc
X-HE-Tag: 1755072875-323487
X-HE-Meta: U2FsdGVkX1/rkYXr4Wj6eULqs/vfeZ1fOMseUOLb31ToPZQ2j950lsf9sx/H2art29S8gGZTLMLWuELwMRCruwNy4pzpqgJ+omoHVOuF4DEIgXsu5WM7uvRFernG2Hpb1ncgYS9vd3Cdd2vCia7CnNlraEDnRp6w/EvBcq1UynDnrb4LYMUS6/U07eGxsIoLS5jCUM7obe7snTBGN8m/bxmG2AbOrsmR+y/14qSuye/Bc35TxwUGgXpChHQ/W4XUvLw3li3r/UyJS6721bSi63IgGpzL8MRYum1tvd/DXopA6kEfToLGb6Rd9QrtEpyvlgM2MKDZzZxVP5rYK2q/pC/q4EVMdpcNps2dus9MjU7Aol5+C+PYb3bEdBljdevJY7667W8hx9A/0C4k5b6mAuIPBhDBcrKhltNHz9iaGhsCgFGjT2rBCKvfwPZ3oT3sJtHvq3QP/qAez4l1xSb/LBxEztlnUAJUzjPDoXbBn0jbPkIyLtPBJ+5vvuvN18osuq97kEN0tUw9zNSE+rIOD4FY85g0nGohK36kNLC0amVJdebBqpf2UngR8eOJwPOmY1Xzz/vuzQ6lqQyVq4uZ3PMmZEm/zLCoJhzq9k9k5o4sBRFobU7ft4aq93SLnG+ky9O3WUg6BKjv8i2jQ/dJkCoM9M+VM+KrxkOLAvIx2atyYeQ2pjGdjiqsUNYHBdggb/YRN72Kn+dOLJqrFWylblWIEQQ51gfN9huefTMIcHHhPl2Qs3qj5hrQggzZnSXH/pj/1NNMYQw4PKZKTJlwXGRpWeht3pggNmPOqGyp9qh+Jffmlsoz2vIwZpaTUw99m907J+p7RiXLdPEHSLKN9cb+Wo1KZXKvplzx4Tv+3tTBpRfF03qs+zorN5gXCsIHx2MVoucnaD6ORDEWXZqnGbykmwH+tfztMN6zrZ6tPveYChrAtBAr3O0AysPMTTeSoVZGlakTg1rPnsa2CPC
 BF1Z4eH9
 k+bco1QFGb4z38He1BUyPJjkmIKS4RtAp5gI26IFDip4dBUsEl+0VM1Hw0dHM11rVe4V/o25K+dAMz9+NEbgumqLVvOi+A1XEIAT6v+k4U3aiYxp46JC7+EvzWgTAqxLtgWCYd2Ul+Z4qGT6zJumJ5m5zBwssW9+LxbW4pJtKi2matDtHeaBSNhncp3/lITzk5I4+TohC6O/Z6tN9mvc0w20vdbqL1x1x5JPgrXU7Z8LIdVtEPhjv9XO9mVO0KLKcrWybfgr1b/lrbHPeG1O2aqBjG6wl7aTJ5DL4Hy16mcm7H+Du+yBmuIFXLE5AdJ7Vrd6BMTG/QhHUZ9FTgk87buSYJvjGGVwJx8UTNeP2xvGvOu12qXo8/n09SYRIIVCa/qtjFIvooSu4j2bys3fUZyyUcypEjxNOg0IKer3wQZrKLmS6QCLgpLPfmvsk+q6vxhdxVixDZEZljfEDnrOmUOQGXN6SmTglGi9flzRIME/Ahp8v2cD4R7eTrLqYhNNUAldowvqAD8ahaiRQlNkG/cBWG1coaM3A/hOH652uIceHdUG3mdJPY9zO7Xfle8qRnC+/ObA9nBHnhzkKjLm+XRqi6WCjNXS0PXvp53vCMKfpGNPZsg3qpm8ENGJ9s1Hxz5f9jM8vZW++euBnWp5GJ4MofgcyzsxwBP7YM4q0ATg0hcfKjXU1sXY35AzkerkH98IYUcxwWolRbsrSMUx5uzLM29VfFNd0Sbhbel1UD+5t5EAzcOTQGxW6nX/brM9ywpUoviuv9DuT+dAqKWn/F/oDwcEfWcCLEWxL7c+ovBJAI729dRQ96i7BajDOzYTgZaIIjq3OoOYzJV/cVAN8PGGP3AGYbGDdHcKS6xH3HeaxJdKWty28uL/1vBVMN/XVjAOia53GkltRrOKnx8Fo7DEG9BcWR7LEpOL0w25YlM/7jMo70WQRFTO7va3Qq9OIEckkaKZajZM79rMYMgTqR6GX7g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------dG5z6K4ZS0u4OAlYP03UPbK1
Content-Type: multipart/mixed; boundary="------------WvnYaOs0IQyrYmFTW1jlqhLk";
 protected-headers="v1"
From: "Colin King (gmail)" <colin.i.king@gmail.com>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@redhat.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Shuah Khan <shuah@kernel.org>, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, kernel-janitors@vger.kernel.org,
 linux-kernel@vger.kernel.org
Message-ID: <569017fb-fe8d-41ff-ab23-db80a077f725@gmail.com>
Subject: Re: [PATCH][next] selftests/mm: Fix spelling mistake "mrmeap" ->
 "mremap"
References: <20250813080156.1977375-1-colin.i.king@gmail.com>
 <5a38db18-494b-4f3a-8ce4-44bab5448559@lucifer.local>
In-Reply-To: <5a38db18-494b-4f3a-8ce4-44bab5448559@lucifer.local>

--------------WvnYaOs0IQyrYmFTW1jlqhLk
Content-Type: multipart/mixed; boundary="------------K4QPFvVxGPRjcuHYK2Oab8Ey"

--------------K4QPFvVxGPRjcuHYK2Oab8Ey
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

DQpNZSB0b28gYnkgdGhlIGxvb2sgb2YgaXQuDQoNCk9uIDEzLzA4LzIwMjUgMDk6MDksIExv
cmVuem8gU3RvYWtlcyB3cm90ZToNCj4gT24gV2VkLCBBdWcgMTMsIDIwMjUgYXQgMDk6MDE6
NTZBTSArMDEwMCwgQ29saW4gSWFuIEtpbmcgd3JvdGU6DQo+PiBUaGVyZSBhcmUgc3BlbGxp
bmcgbWlzdGFrZXMgaW4gcGVycm9yIG1lc3NhZ2UuIEZpeCB0aGVzZS4NCj4gDQo+IE9vcHMg
OikgSSBhbSB0aGUgdHlwbyBtYXN0ZXIsIGFwcGFyZW50bHkuLi4NCj4gDQo+Pg0KPj4gU2ln
bmVkLW9mZi1ieTogQ29saW4gSWFuIEtpbmcgPGNvbGluLmkua2luZ0BnbWFpbC5jb20+DQo+
PiAtLS0NCj4+ICAgdG9vbHMvdGVzdGluZy9zZWxmdGVzdHMvbW0vbXJlbWFwX3Rlc3QuYyB8
IDYgKysrLS0tDQo+PiAgIDEgZmlsZSBjaGFuZ2VkLCAzIGluc2VydGlvbnMoKyksIDMgZGVs
ZXRpb25zKC0pDQo+Pg0KPj4gZGlmZiAtLWdpdCBhL3Rvb2xzL3Rlc3Rpbmcvc2VsZnRlc3Rz
L21tL21yZW1hcF90ZXN0LmMgYi90b29scy90ZXN0aW5nL3NlbGZ0ZXN0cy9tbS9tcmVtYXBf
dGVzdC5jDQo+PiBpbmRleCA1YmQ1MmE5NTFjYmQuLmUyODliYjExMTJkYiAxMDA2NDQNCj4+
IC0tLSBhL3Rvb2xzL3Rlc3Rpbmcvc2VsZnRlc3RzL21tL21yZW1hcF90ZXN0LmMNCj4+ICsr
KyBiL3Rvb2xzL3Rlc3Rpbmcvc2VsZnRlc3RzL21tL21yZW1hcF90ZXN0LmMNCj4+IEBAIC04
NDYsNyArODQ2LDcgQEAgc3RhdGljIHZvaWQgbXJlbWFwX21vdmVfbXVsdGlfaW52YWxpZF92
bWFzKEZJTEUgKm1hcHNfZnAsDQo+PiAgIAl9DQo+PiAgIAlpZiAoZXJyICE9IEVGQVVMVCkg
ew0KPj4gICAJCWVycm5vID0gZXJyOw0KPj4gLQkJcGVycm9yKCJtcm1lYXAoKSB1bmV4cGVj
dGVkIGVycm9yIik7DQo+PiArCQlwZXJyb3IoIm1yZW1hcCgpIHVuZXhwZWN0ZWQgZXJyb3Ii
KTsNCj4+ICAgCQlzdWNjZXNzID0gZmFsc2U7DQo+PiAgIAkJZ290byBvdXRfdW5tYXA7DQo+
PiAgIAl9DQo+PiBAQCAtODk5LDcgKzg5OSw3IEBAIHN0YXRpYyB2b2lkIG1yZW1hcF9tb3Zl
X211bHRpX2ludmFsaWRfdm1hcyhGSUxFICptYXBzX2ZwLA0KPj4gICAJfQ0KPj4gICAJaWYg
KGVyciAhPSBFRkFVTFQpIHsNCj4+ICAgCQllcnJubyA9IGVycjsNCj4+IC0JCXBlcnJvcigi
bXJtZWFwKCkgdW5leHBlY3RlZCBlcnJvciIpOw0KPj4gKwkJcGVycm9yKCJyZW1hcHAoKSB1
bmV4cGVjdGVkIGVycm9yIik7DQo+IA0KPiBUeXBvIGluIHRoZSB0eXBvIGZpeHVwIDpQIHNo
b3VsZCBiZToNCj4gDQo+IAkJcGVycm9yKCJtcmVtYXAoKSB1bmV4cGVjdGVkIGVycm9yIik7
DQo+IA0KPj4gICAJCXN1Y2Nlc3MgPSBmYWxzZTsNCj4+ICAgCQlnb3RvIG91dF91bm1hcDsN
Cj4+ICAgCX0NCj4+IEBAIC05NDgsNyArOTQ4LDcgQEAgc3RhdGljIHZvaWQgbXJlbWFwX21v
dmVfbXVsdGlfaW52YWxpZF92bWFzKEZJTEUgKm1hcHNfZnAsDQo+PiAgIAl9DQo+PiAgIAlp
ZiAoZXJyICE9IEVGQVVMVCkgew0KPj4gICAJCWVycm5vID0gZXJyOw0KPj4gLQkJcGVycm9y
KCJtcm1lYXAoKSB1bmV4cGVjdGVkIGVycm9yIik7DQo+PiArCQlwZXJyb3IoInJlbWFwcCgp
IHVuZXhwZWN0ZWQgZXJyb3IiKTsNCj4gDQo+IEVxdWFsbHkgc2hvdWxkIGJlOg0KPiANCj4g
CQlwZXJyb3IoIm1yZW1hcCgpIHVuZXhwZWN0ZWQgZXJyb3IiKTsNCj4gDQo+PiAgIAkJc3Vj
Y2VzcyA9IGZhbHNlOw0KPj4gICAJCWdvdG8gb3V0X3VubWFwOw0KPj4gICAJfQ0KPj4gLS0N
Cj4+IDIuNTAuMQ0KPj4NCj4gDQo+IENoZWVycywgTG9yZW56bw0KDQo=
--------------K4QPFvVxGPRjcuHYK2Oab8Ey
Content-Type: application/pgp-keys; name="OpenPGP_0x68C287DFC6A80226.asc"
Content-Disposition: attachment; filename="OpenPGP_0x68C287DFC6A80226.asc"
Content-Description: OpenPGP public key
Content-Transfer-Encoding: quoted-printable

-----BEGIN PGP PUBLIC KEY BLOCK-----

xsFNBE6TJCgBEACo6nMNvy06zNKj5tiwDsXXS+LhT+LwtEsy9EnraKYXAf2xwazc
ICSjX06efanlyhB0figzQO0n/tP7BcfMVNG7n1+DC71mSyRK1ZERcG1523ajvdZO
xbBCTvTitYOy3bjs+LXKqeVMhK3mRvdTjjmVpWnWqJ1LL+Hn12ysDVVfkbtuIm2N
oaSEC8Ae8LSSyCMecd22d9PnLR4UeFgrWEkQsqROq6ZDJT9pBLGe1ZS0pVGhkRyB
P9GP65oPev39SmfAx9R92SYJygCy0pPvBMWKvEZS/7bpetPNx6l2xu9UvwoeEbpz
UvH26PHO3DDAv0ynJugPCoxlGPVf3zcfGQxy3otydNTWkP6Wh3Q85m+AlifgKZud
jZLrO6c+fAw/jFu1UMjNuyhgShtFU7NvEzL3RqzFf9O1qM2muj83IeFQ1FZ65QAi
CdTa3npz1vHc7N4uEQBUxyXgXfCI+A5yDnjHwzU0Y3RYS52TA3nfa08yLGPLTf5w
yAREkFYou20vh5vRvPASoXx6auVf1MuxokDShVhxLpryBnlKCobs4voxN54BUO7m
zuERXN8kadsxGFzItAyfKYzEiJrpUB1yhm78AecDyiPlMjl99xXk0zs9lcKriaBy
VUv/NsyJFQj/kmdxox3XHi9K29kopFszm1tFiDwCFr/xumbZcMY17Yi2bQARAQAB
zSdDb2xpbiBJYW4gS2luZyA8Y29saW4uaS5raW5nQGdtYWlsLmNvbT7CwZEEEwEI
ADsCGwMFCwkIBwMFFQoJCAsFFgIDAQACHgECF4AWIQRwYtqk8AG5xmFnAM9owoff
xqgCJgUCY8GcawIZAQAKCRBowoffxqgCJtd/EACIWcaxfVt/MH4qqo5ELsjCFPVp
+RhVpQDWy8v9Np2YbTcZ4AY2Zj4Pq/HrZ3F/Bh02v85C6mNv8BDTKev6Qcq3BYw0
iqw6/xLNvRcSFHM81mQI9xtnAWIWfI9k5hpX19QooPIIP3GOMdMc1uRUGTxTgTFA
AsAswRY3kMzo6k7arQnUs9zbiZ9SmS43qWOIxzGnvneekHHDAcomc/oho7kgj6rK
p/f9qRrhForkgVQwdj6iBlW934yRXzeFVF3wr7Lk5GQNIEkJiNQPZs54ojBS/Kx6
3UTLT1HgOp6UY9RPEi9wubmUR+J6YjLRZMr5PCcA86EYmRoysnnJ8Q/SlBVD8npp
GVEcuvrbH3MBfhmwOPDc3RyLkEtKfSTB92k1hsmRkx9zkyuUzhcSnqQnpWGJD+xt
KHvcHRT7Uxaa+SDwUDM36BjkyVcZQy8c+Is2jA55uwNgPpiA7n82pTeT+FRGd+7i
CLQHaryu6FO6DNDv09RbPBjIiC/q814aeKJaSILP1ld9/PEBrLPdm+6lG6OKOt9D
DV6jPmfR96FydjxcmI1cgZVgPomSxv2JB1erOggB8rmX4hhWYsVQl1AXZs3LdEpJ
6clmCPspn/ufZxHslgR9/WR1EvPMQc8XtssF55p8ehRIcVSXDRcMFr3ZuqMTXcL6
8YbDmv5OGS95O1Gs4c0iQ29saW4gS2luZyA8Y29saW4ua2luZ0B1YnVudHUuY29t
PsLBdwQTAQgAIQUCTwq47wIbAwULCQgHAwUVCgkICwUWAgMBAAIeAQIXgAAKCRBo
woffxqgCJo1bD/4gPIQ0Muy5TGHqTQ/bSiQ9oWjS5rAQvsrsVwcm2Ka7Uo8LzG8e
grZrYieJxn3Qc22b98TiT6/5+sMa3XxhxBZ9FvALve175NPOz+2pQsAV88tR5NWk
5YSzhrpzi7+klkWEVAB71hKFZcT0qNlDSeg9NXfbXOyCVNPDJQJfrtOPEuutuRuU
hrXziaRchqmlhmszKZGHWybmPWnDQEAJdRs2Twwsi68WgScqapqd1vq2+5vWqzUT
JcoHrxVOnlBq0e0IlbrpkxnmxhfQ+tx/Sw9BP9RITgOEFh6tf7uwly6/aqNWMgFL
WACArNMMkWyOsFj8ouSMjk4lglT96ksVeCUfKqvCYRhMMUuXxAe+q/lxsXC+6qok
Jlcd25I5U+hZ52pz3A+0bDDgIDXKXn7VbKooJxTwN1x2g3nsOLffXn/sCsIoslO4
6nbr0rfGpi1YqeXcTdU2Cqlj2riBy9xNgCiCrqrGfX7VCdzVwpQHyNxBzzGG6JOm
9OJ2UlpgbbSh6/GJFReW+I62mzC5VaAoPgxmH38g0mA8MvRT7yVpLep331F3Inmq
4nkpRxLd39dgj6ejjkfMhWVpSEmCnQ/Tw81z/ZCWExFp6+3Q933hGSvifTecKQlO
x736wORwjjCYH/A3H7HK4/R9kKfL2xKzD+42ejmGqQjleTGUulue8JRtpM1AQ29s
aW4gSWFuIEtpbmcgKEludGVsIENvbGluIElhbiBLaW5nIGtleSkgPGNvbGluLmtp
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
=3DQKm6
-----END PGP PUBLIC KEY BLOCK-----

--------------K4QPFvVxGPRjcuHYK2Oab8Ey--

--------------WvnYaOs0IQyrYmFTW1jlqhLk--

--------------dG5z6K4ZS0u4OAlYP03UPbK1
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEEcGLapPABucZhZwDPaMKH38aoAiYFAmicSUEFAwAAAAAACgkQaMKH38aoAiZV
+A/+KZyA3gOQUberwfiLI9HeQM3oBLDcVxCDsZumFvLeZ6xl/nYSJb3TpJrn+yv8VZDI+lXpPSFw
4wKLzD3omBQLJog4erB3HcC3upiWRht44QHDH3Py5b+q9GITqsGLKDTqvwwlHzvvWevWkOeftVGK
2q8SW8wcJ4Y4BvZF0Q9h+YkN8+nnLmQMWoQRA/xPfGxz1A8r0z6AgV26Jd8yWc3w5UB5fJlMoZfF
lEZ/iLYhUuWo5/fbTnehz1bAuOMTYZ5QE+IXmNZgnne8JGKCmIUW6vqJCFotOBY96ihIZPp9VzYK
5ZtejRn4PGGpXdPxkuItGuEnZIrxeeS7fUIrC/DXoyYrWUtU6TwzIP9P3aFdLHtLWOZtUcuGeSBK
t9ek1zjbDLgLm2WiRKpNBtkbS2hG3RdyDY/T1nRPZA+uYLU7n2SuzT7Be40vQ62i0aqB/X6ipCHd
r6ME4ffxNAcxWZKxVvR7VaQd+BYt+dk661zTdVn8Cd1xAAbduvDe7fCEzQvtyCVgEvzHQJ6opboe
ifGXkSFsny/ALa3j46//TR/0qAkCG83BBZH1ZRhMsBUWTzdXnydNJd8q8lgtNnCxcDHS4ZzzlUa5
DcS+20EbIWJ+AEkQnq+WAL50Fc+x6C8pl3j+OniYk+wCXwLCxHYaz9gqf7RtekFL2betBWDmoHkK
uF4=
=Iu9R
-----END PGP SIGNATURE-----

--------------dG5z6K4ZS0u4OAlYP03UPbK1--

