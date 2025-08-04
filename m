Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2EE1BC87FDA
	for <linux-mm@archiver.kernel.org>; Mon,  4 Aug 2025 07:38:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AE17A6B0089; Mon,  4 Aug 2025 03:38:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB9326B008C; Mon,  4 Aug 2025 03:38:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A8096B0092; Mon,  4 Aug 2025 03:38:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8B6006B0089
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 03:38:53 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 13E7E13648C
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 07:38:53 +0000 (UTC)
X-FDA: 83738273346.13.F9E633F
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf26.hostedemail.com (Postfix) with ESMTP id 91035140004
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 07:38:50 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=SElCBBdp;
	spf=pass (imf26.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754293130;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CzK+aHI7pV/260UpuhODkvZhd1+LktSEwZyabmfoWcU=;
	b=4Q6Le8264BBB/UnAlDmx5k8tXLTWuHIWRFMcCs6puJ4g5vXq6UKvSARaCl56Bnp7HTFPWe
	2HowaOumP2aMx4krs6KjgPk9grQN0yZy37yqFbwjUmteJW4p2mEM1QccfBd2AiNTnoJtND
	gvpNAlaulHCjkBbUp+/jkRyxplIp6KU=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=SElCBBdp;
	spf=pass (imf26.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754293130; a=rsa-sha256;
	cv=none;
	b=O4cezUgwDInT1DnE+dMPGtAuFczRo8OAmifHMguE7+h4+Y4Ad5tgCqDeoSKH7+lvnfTNKc
	uOqiD9NikSPhsVclhgbZL7PU5GfGNcQQdgwuqjcHG/8k7ZNk5dS5BIxhzerYbvC/S1tSjZ
	YLDVDT2IsRv68OBUg9iVxSEtexZ/yTU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754293129;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=CzK+aHI7pV/260UpuhODkvZhd1+LktSEwZyabmfoWcU=;
	b=SElCBBdpuiV6CDQ/kgy2eN3GKMub9QPBonykVM3h7FEqUlH4uC6Ln0i9f14aFBQ0NF62d6
	DzgTRWdgj1757fVsOQMjS0f24WX5yErqyB64kzHzT0KBRgVMR2IJzARNCSeahgOO3O8AK0
	22Xj354wys7pFbYdfsc78g9UP/zlZCM=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-509-0H3YqNilNoal9Rljf4ioIw-1; Mon, 04 Aug 2025 03:38:47 -0400
X-MC-Unique: 0H3YqNilNoal9Rljf4ioIw-1
X-Mimecast-MFC-AGG-ID: 0H3YqNilNoal9Rljf4ioIw_1754293127
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-3b788e2581bso1773658f8f.0
        for <linux-mm@kvack.org>; Mon, 04 Aug 2025 00:38:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754293127; x=1754897927;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=CzK+aHI7pV/260UpuhODkvZhd1+LktSEwZyabmfoWcU=;
        b=pGq8T2kL1SA2In1/KWyS6hmMgd7PWe1WUhS89WYvPC8/5cwmZWTltv62z0BugU8F0s
         ald0tO7bAwBfGGBFuWKFNgaFC7jteCO0kCbe4821B5r6d4Xy7xFdCD60anD74TDZMho5
         pjVbNU2mPXAncUwCt3JzIfmkyKYP9kNRicxagCwfGrFZ9zklhIjsTlsr4Rv3kS3QaM+N
         yv+47QKvHZMcwBAi5zVLupDQBs3WdhNlaY7l4OPnBfV6lv4tcyQql4FFJwQTlDDzN5dY
         pDF0N4rfF5pOQz7es2laxnjODU8FY/57bhCmbe8v3taGwDBi4nHRj6th3+a1Bmza1mLD
         0jTA==
X-Gm-Message-State: AOJu0YwglBJ1jWvtrVPnqCewbJejIN8r7gZugc03SdcVtd0Ncn/TgYbm
	5sq77bax8V2JDSqJeg4LlsW1o7Iw0veecdPn2/D9TPXFL9EtoFCZWhJOQTp0VthWKEWUmJ9HEaY
	0u/r1gtyJUTL0rEkMZ33yMjCvEyz62zNspWketJxkN2I9Fc7NpGP8
X-Gm-Gg: ASbGncuQC/YtpKpzS4OxzBUsUc66OdVOCn6aKiUwK+htwwrEgrsN0i8bcTtd1LcsEah
	7hfvl7xHDgQa6FgSNRW0CfN2vG5Ci4woov6fwiX+dOhnZ9jlBjbSWZTxUnLJCeFUnYRl6Q24VDt
	xlXA2//rI+goCGIFaTr2a8sFTM/gefI4hAEqubHUTKNUimJc/Syhnpv3nv9DhyQ0S2WSrd8Ey8c
	kO1TMyKX5KZG0LWRbiUIBVDixmr719DHsxK5LM4IN+35FhuiQ41gMdNzz9eMw0mv9QSq7gZgWIp
	/+tlIIYFAHBjwSUHyU+ZGZwV52ZoypiOZheHkOSOmCC80TSB6CbXzIKI9FHuGm2+5oZSr0E=
X-Received: by 2002:a05:6000:26ca:b0:3a4:dc42:a0c3 with SMTP id ffacd0b85a97d-3b8d94ca582mr6319745f8f.56.1754293126702;
        Mon, 04 Aug 2025 00:38:46 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGrMUdYx9Ob46gquQaFnoCtyHDHDuKowbCd8TC5DD9f1A8ghltY2UwuxdLS8+6L1j4QaRuF2A==
X-Received: by 2002:a05:6000:26ca:b0:3a4:dc42:a0c3 with SMTP id ffacd0b85a97d-3b8d94ca582mr6319682f8f.56.1754293126157;
        Mon, 04 Aug 2025 00:38:46 -0700 (PDT)
Received: from [192.168.3.141] (p4ff1f1eb.dip0.t-ipconnect.de. [79.241.241.235])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b79c47b10asm14296055f8f.60.2025.08.04.00.38.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Aug 2025 00:38:45 -0700 (PDT)
Message-ID: <8aa31e69-588e-4c7c-9857-553c2d6a2e11@redhat.com>
Date: Mon, 4 Aug 2025 09:38:42 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH linux-next v3] mm, page_pool: introduce a new page type
 for page pool in page type
To: Byungchul Park <byungchul@sk.com>, Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-mm@kvack.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
 kernel_team@skhynix.com, harry.yoo@oracle.com, ast@kernel.org,
 daniel@iogearbox.net, davem@davemloft.net, kuba@kernel.org, hawk@kernel.org,
 john.fastabend@gmail.com, sdf@fomichev.me, saeedm@nvidia.com,
 leon@kernel.org, tariqt@nvidia.com, mbloch@nvidia.com,
 andrew+netdev@lunn.ch, edumazet@google.com, pabeni@redhat.com,
 akpm@linux-foundation.org, lorenzo.stoakes@oracle.com,
 Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, horms@kernel.org, jackmanb@google.com, hannes@cmpxchg.org,
 ziy@nvidia.com, ilias.apalodimas@linaro.org, willy@infradead.org,
 brauner@kernel.org, kas@kernel.org, yuzhao@google.com,
 usamaarif642@gmail.com, baolin.wang@linux.alibaba.com,
 almasrymina@google.com, toke@redhat.com, asml.silence@gmail.com,
 bpf@vger.kernel.org, linux-rdma@vger.kernel.org
References: <20250729110210.48313-1-byungchul@sk.com>
 <20250802150746.139a71be@canb.auug.org.au>
 <20250804011730.GB39461@system.software.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 g3eXuA==
Organization: Red Hat
In-Reply-To: <20250804011730.GB39461@system.software.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: cLW3Chtl5rd9sOw4NWPJoILBD-wIWnaJqkTTgPp1ajE_1754293127
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: unoz6dahambrnimz4833n98dtyz675tt
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 91035140004
X-Rspam-User: 
X-HE-Tag: 1754293130-457491
X-HE-Meta: U2FsdGVkX19LkcKPGRuawf/X/vZ4x2p085Hj9LCmf5FQeLyIRbL7/yFmgZU82m/11c7WIY14vj6FQrfl7mrg4OYyRqFegNGej4rVjgCbxCEhHon7AC5MXZZpeyY7aJozRV+u17sFtFI9OmwPQvXpiDH19ZRE7wlr3Ipyuvu34yDLTHoPT9A0G8JLS3ZSmSSBVnhqvx968FSq8Xzpby+Qo8giY3TKD1d/xHnkYIFC64d2N5A1WsPNB/AdN1k+0HQua2pb7F8WOU910yk68NJQ/5TMLUq/QHKyyCPk7/lmpssSS72u2AnwpBWw0/eeYR6CCzIlP2vUwwAYvhg+3LilxAvN2pcJMrK+hSxXXy0yRy/lYNk96jGFbTV4s3cZxSs5iVAAeKiXpBEaBN4mjlX8EZsh/yVy68WffFe1LsAe6ZjXKBRaz8wJzJLlB9oPVHPpAgGAnezY27KCNzAmKy5OiyqG2yQ0qQKi4J8INr4JwurTyNhBKssaNUw+wavJOZmgVEDtbgDhvJroIJd8z3xYt/y81UAmIGcB+1ow84CcWXSYtjrdZ4cNsXoizYV0/85VwZ29r3RSP/598JfsqvfnYqpCg0VjMAPEyBU4haIfJ2wP4OAX8T4tVywuSy+wiU2LljkjbptJ3p3QIN8EeOIsS75NrAyP++qGIVpUJn0tkl/t4FmIqxK2TG4VinmK3klYH3H3DWWIylLln+MqH70isaQtYE/pZicazGzBoEa6dytXfVwWrqC91AFdUW7RpC1S+SWxDUOm7XW8PPZoYgPrf//PrP8avgER+AuPIX8uMFB0AFqlE1fXwH8dNASCU6rwpvw64nZ2vtiGJEVqTP7qgZgcYQS3g6hzdrvbpjxVBCwogx4rP4j5YgcIFIh+UqJGDpFMXxF7r8jfW0CNWWHWxberwZwYMD0fICVWBmrRd8ujgNlsniZQjq48IZ6dXe2HL3krHyRoHAwmqOAs/7E
 VfrcL3DH
 0bz67uVDVQugJjQKrSqfU4U33/OEPyOOmiWawALbpV2oO0MRRghm9wGuo4VdVkQ9jfs1G+eRROtmgAReWXEoVAPNGM1CmIrivgjXRKSqgv+U0ndbxDTK1oFPBGRLyPwnByfP2Ki9Bz6XVA+DogE7WA1iP34VqWJOxc3RZTQ0mErpYUoigIhl9y1iy51p1+N969lPIoUIiilcEONCrauZDal5rL2S0ilvL/gR87dgRS0b5o0DNZ5U4dDEkp39iUXVa1fwOZqyhLvOu/3dhT+JEmZeDm6KMochKC3/+1lASUNfO53H3Fo2mjdmbm3UGDfDOL9Gg3+D31LSZHub6vvK/rq0s1iZKtXwOKRVUntoz0MFeDb2vc49KTlUaWkf5mHmlGD2ezFoq1Qpm731P6crYaeQXBLmlNDCDBj22UpogDNNil6WVd3fv5IjegxL+tk7RvTUntyaZO/PUkZhpmGA1Yqi3DXSv7wGowf1EQ3Csxg5nSRDEa/LcNzbmYAhIzj74rQcWJL+xvggotkvOr1f670FWvvOMlq2APXqC/xRcVdfG2zqsmSgp4Zx6Z3toxrAZTjN8eAWEPovZUkPsaufbI2khRIOFIm74SkSuTKV5IiIIRrXVqtEMz7XhIrEb0+e2GaJnnl9sj3FiIlbNCN8ai+cIuScpru/wP2VXUV90BYnAW58jJA11QlfIM1+sf68JWZ7QvT/tpIuiodeqB4rj1rNLjA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 04.08.25 03:17, Byungchul Park wrote:
> On Sat, Aug 02, 2025 at 03:07:46PM +1000, Stephen Rothwell wrote:
>> Hi,
>>
>> On Tue, 29 Jul 2025 20:02:10 +0900 Byungchul Park <byungchul@sk.com> wrote:
>>>
>>> Changes from v2:
>>> 	1. Rebase on linux-next as of Jul 29.
>>
>> Why are you basing development work in linux-next.  That is a
>> constantly rebasing tree.  Please base your work on some stable tree.
> 
> Sorry about the confusing.  I misunderstood how to work for patches
> based on linux-next.
> 
> However, basing on linux-next is still required for this work since more
> than one subsystem is involved, and asked by David Hildenbrand:
> 
>     https://lore.kernel.org/all/20250728105701.GA21732@system.software.com/
> 
> I will base on linux-next and work aiming at either network or mm tree.

I think this is the key part: there is nothing wrong on temporarily 
basing your stuff on linux-next, while we are waiting for this merge 
window to end and relevant patches showing up in either tree after the 
rebase.

You should mention below the "---" your intentions like "This patch is 
supposed to go via the XXX tree, but it currently also depends on 
patches in the YYY tree. For now, this patch is based on linux-next, but 
will apply cleanly (or get rebased) after XXX was rebased."

Also, probably best to indicate the patch as being RFC (instead of 
linux-next) until there is a stable "base".

-- 
Cheers,

David / dhildenb


