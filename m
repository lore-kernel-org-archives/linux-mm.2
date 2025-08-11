Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5AE78CA0EC4
	for <linux-mm@archiver.kernel.org>; Mon, 11 Aug 2025 16:06:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CF7FB8E0079; Mon, 11 Aug 2025 12:06:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CA8108E0060; Mon, 11 Aug 2025 12:06:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B70A78E0079; Mon, 11 Aug 2025 12:06:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 9E5158E0060
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 12:06:22 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6E1C41DB9D5
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 16:06:22 +0000 (UTC)
X-FDA: 83764953804.23.47658BD
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	by imf21.hostedemail.com (Postfix) with ESMTP id 988991C000B
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 16:06:20 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=MZ3HVFxI;
	spf=pass (imf21.hostedemail.com: domain of rientjes@google.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=rientjes@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754928380;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b4XB7rbDMRDvsKK6fD02IRXzMhRU39sjlSTEErIcNrs=;
	b=bQ73bOXHt1U93rxKxlgIuXYTgq0uFLRLrzmDLNMcFGKEl/LorwWwhxPABFatQe25DUPSZL
	pxzsdroTqj6psh0lUOKfwF+G5cgAvLPvRRx/IQ1RmZeD2KfK3m+AyDsM4noU67LOWeXwSr
	5/59hPXrfwOlZWjoQbn2/jv5Fdj7F7w=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=MZ3HVFxI;
	spf=pass (imf21.hostedemail.com: domain of rientjes@google.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=rientjes@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754928380; a=rsa-sha256;
	cv=none;
	b=nF9yTTrYipvxzWw2hT0j7Za6d2P7Q5hMQ82cb1YpOvp4oGeD4T0YXrtPtq2Fc8ewZrWg/V
	OpQ38BoZy276LR+skbmLCAZHJzf0lYC1+QJYXbzKTDJnVPtCC7RLKMTuZ+7OMSRPlO52Zs
	QZNQ15/xDP2zgJBi6Yo6wUE6weUIJFk=
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-242d1e947feso347425ad.0
        for <linux-mm@kvack.org>; Mon, 11 Aug 2025 09:06:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754928379; x=1755533179; darn=kvack.org;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=b4XB7rbDMRDvsKK6fD02IRXzMhRU39sjlSTEErIcNrs=;
        b=MZ3HVFxIj7NSEKjviegCi44UXxMOPOqMqfFev8y8pGOlWkmGJmG0GOvMBXUg0lLL6Q
         3lYmZDSlfXExuSe1CaKc3dUZ0I6zj9L3/NCQkYU8x9zyaLL41heVzJwSWrLSOoNjr+Cq
         0RQfaCuynRHdqwPdb3Q2ddrMBjcYNcjukWxnWuHQ3tCXoHDyGnnX67cispUvunMocDm6
         RZXjX26o4J1f1C3GvwG//NzviKAnPMlGFQ6bnyuDdLTeETBYnGd6MD8r7Wkhz5WYLxa1
         JguUOQcKWDsz+XkN6ScEM18I5Pdk7rHf0gXqp860JZ6KfsPsg3mC0+TYyeJ8JSZYdcHL
         uj5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754928379; x=1755533179;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=b4XB7rbDMRDvsKK6fD02IRXzMhRU39sjlSTEErIcNrs=;
        b=QRj3pKLoTsX87iTk5jFaWquonEv16UbFceFEMqpeaqrCYd6dngwLAiMPCOQ/chcMGX
         2gNV+R7m7px5CKr54u5O2frPX0QBfKJ2alm+lWD3aLFuxwAAyRkWEoAhy9rQCBf8vS5V
         ySjJasEghO1KIYmNBiMlYeC+A/ulf8/Ax0oNDxOBsD9L9VB4M39IDOpKwRUkP9VhSIXw
         MnYUkcJUGABKSIQhrr5/K8p4UmYT9Gwwx/Z5AAo3Eod/mRNS+lsL65TBSB1DCoh75i5m
         75lrEmeWCxPKkmhRaMUYBOerdVzOpUxcT28DQCFYRH3ncUYfYiCjnGeK1l6Ya/0pWvXI
         MoPw==
X-Forwarded-Encrypted: i=1; AJvYcCW33K5gyhLbezAbL9ICnmBG2d5RZdOnsjRyP5T8BULNW6cVokCKZqSxI3PTgXH34rey/sh5IZHqUg==@kvack.org
X-Gm-Message-State: AOJu0Ywh9MxLdvoHa3MLtcucoU1H7Vo79XI2/kn6lt/q06ayA/yZksaN
	gZEOOpK3J0nZ9JWuUJ+pLZTE1Q9dbzSh2BIBmPsIJAWwjttEfoMAuR48Eg0OSTfygbCKt98alUY
	2YwWVjfj+
X-Gm-Gg: ASbGncvvaevlIxgdNNbRjI1w86LRRKYuApZCyY8CTuoYz2xNhTpg89ZBpGK+p7vT7e6
	xccGlu2p61yj7jlYbDq4u7RpXiQCq9E8ZdUUcFqRlZWqHtMv6RTAuPsY16J0gswJOKG0GeqLXaZ
	BHD0l7Tgxh+XYJv51MlGjj1Cl4xQpRYiteqpWNoUzp26RQUyIUsKvxWKotEOL3bYZL3vg0DhSY/
	PS3AnaFbzqocEkBw7HfuTxRA+AKC2P11nq7AJcqJZ7si6p26fto5tLFZPZ6udXPvRs2TRs/mBv5
	HXDFFidvPi+JWjWBUlsYMoqhl6GuIfxXbqoyysng7Nuy4v16YBnBxTuHLo5PdU76nwL6WFSFRCe
	+Q8MIwMz2h75KRcBJKzgTimiFyTT3oI2JViwL2EOgQYdqPtaUdFrUYBj7juEB49Ostoeh8nTwst
	RNOh2dCw84X6rU4N++
X-Google-Smtp-Source: AGHT+IHfX3J5jPQcjeR7PGp0tVsL7ZVLWcGPT//n+uMiE8TlGUsCOcJGCeSa/IqlMj8LeXBSgpTeEA==
X-Received: by 2002:a17:903:246:b0:23d:eb0f:f49 with SMTP id d9443c01a7336-242d2bc6116mr5965795ad.14.1754928378887;
        Mon, 11 Aug 2025 09:06:18 -0700 (PDT)
Received: from [2a00:79e0:2eb0:8:bf4b:17b7:3044:fe58] ([2a00:79e0:2eb0:8:bf4b:17b7:3044:fe58])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-76bccfbd174sm27194145b3a.63.2025.08.11.09.06.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Aug 2025 09:06:18 -0700 (PDT)
Date: Mon, 11 Aug 2025 09:06:16 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
To: Oleksandr Natalenko <oleksandr@natalenko.name>
cc: linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, 
    Jens Axboe <axboe@kernel.dk>, Damien Le Moal <dlemoal@kernel.org>, 
    John Garry <john.g.garry@oracle.com>, Christoph Hellwig <hch@lst.de>, 
    "Martin K. Petersen" <martin.petersen@oracle.com>, linux-mm@kvack.org, 
    Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
    Shakeel Butt <shakeel.butt@linux.dev>, 
    Qi Zheng <zhengqi.arch@bytedance.com>, Michal Hocko <mhocko@kernel.org>, 
    David Hildenbrand <david@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>, 
    Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [REGRESSION][BISECTED] Unexpected OOM instead of reclaiming
 inactive file pages
In-Reply-To: <5905724.LvFx2qVVIh@natalenko.name>
Message-ID: <199fb020-19ee-89d1-6373-7cc7f5babab8@google.com>
References: <5905724.LvFx2qVVIh@natalenko.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspam-User: 
X-Rspamd-Queue-Id: 988991C000B
X-Rspamd-Server: rspam06
X-Stat-Signature: ahoe53tkuy3q7pdp4qp1b44tk4j81ir1
X-HE-Tag: 1754928380-917458
X-HE-Meta: U2FsdGVkX19t6MWzRQjKO2NYiE/GSyFtTkazJSEnJmVpV5N6tBWHLcv5KVJLEsnMieipEQDtw7UwsY9tpxWLcZ+3VH4zMEcmfjBuuy+ytrtLObBqSta9C6iI+lmJh8JyIgcKnQF4buiTHrsesRunvLrMfxzLsXgmQB2wvC4lx7F5Q1zmPdgrf4cjLtGKhOIKV34h8hbVr6BD52+GcKaCI8Tlfh5nqOQNFK/IQdarH3W98JrYY+pOcQePDeojWl9rPImhNTsfjnZ/cjtGzjUh9QYH+KvJ006BC9/OI8gHVgU8UTq4fUAmFwAmsSMxyEEPnbu361r7cdhaJ9yCCY6pon16isBtHOylWnHdN411qa/eAjb5pE/UPBsIg3sLtCTC2Qe0agDxBHLYUNrDgI5B+dJzkHhp9TbKNV4cqaas+90qkD3lMeVScqxlcUSkkn/K3I2cprMogDd2VXd/q6zHVqaW/ldjMmYjAXww7cAH9TuhwjHRDJjcQO36f+7LWWH43/8PuI/+YeW1AtJNSaXk8vlb0aXaPmTU0oEyWvY6fEkPPpdqwWb502lawNj6MzpzP3mO8sll4itWpO/QE/oRV/BLN7y6j8vo1S/d766DSEchnQeRLdoK2Iruwiya7S6bzvrxy0ARytRJAPeNfwLs2MP0qLBM8NyULTXGaS/RnibmcBEO2I+QTzrb4cxnyp+8cXAQHkYU+4BD7FZs71VGdXapIPR8hFHpwIO+/RrH/qa1qxDa3TPg5YSv86wbpqLpfPpra0Z1m4CNZ9I2XImbbnVfgL/Q1tpJjlu99tBfQH9opav1dS0XA3SPYmga15/ZWOwH8RP1NRjOxPymL3Re+VE7RB2E0vNsn7EcMS3t6fgnUvLqNvaKuJZY/JWeinXglzQ8BcT0jPeZCPm4ffUkuApHj3+NpCe6k8IpNg00oA4XQV+npyHOSC3UasUMpKVQ+TTblN7P3KbBWBTNaCf
 gk0gOr1a
 RCjNBJSsWpttGXY9UpkMveclJotjBkuM9VV2g14kGZzycW9FBiKlvF2OiM8Xw9MT7M/ffb6G8SRUff1nxmrAKTx3Bn6bdOJztQPbyEAgOnCJ89zXMqwjHW8DSs9rSvF2k3hKBg0eH7zijh3OwNh1WSbzHYFsouxPnHsrMUV0sesdFc56ETQ5tdqyFiMoXI+YaPGNjqtnlJ2Kg+YaKU6lxWLkE57KOTHOlAkRTJmG+wiW6NJSdy0QEjGzx5vsyv71TcwL6L61tiV7VjJxN5nfH+vTicA/yrJwBG5yi35v40h0Rz3bd4GPMGXeuoKFTs65GUsxJ7fskcWIhnO6O6hNOz3Qee8YdLcSA94Gu7Gfc4xrO2jwvn81S7lY/VQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 11 Aug 2025, Oleksandr Natalenko wrote:

> Hello Damien.
> 
> I'm fairly confident that the following commit
> 
> 459779d04ae8d block: Improve read ahead size for rotational devices
> 
> caused a regression in my test bench.
> 
> I'm running v6.17-rc1 in a small QEMU VM with virtio-scsi disk. It has got 1 GiB of RAM, so I can saturate it easily causing reclaiming mechanism to kick in.
> 
> If MGLRU is enabled:
> 
> $ echo 1000 | sudo tee /sys/kernel/mm/lru_gen/min_ttl_ms
> 
> then, once page cache builds up, an OOM happens without reclaiming inactive file pages: [1]. Note that inactive_file:506952kB, I'd expect these to be reclaimed instead, like how it happens with v6.16.
> 
> If MGLRU is disabled:
> 
> $ echo 0 | sudo tee /sys/kernel/mm/lru_gen/min_ttl_ms
> 
> then OOM doesn't occur, and things seem to work as usual.
> 
> If MGLRU is enabled, and 459779d04ae8d is reverted on top of v6.17-rc1, the OOM doesn't happen either.
> 
> Could you please check this?
> 

This looks to be an MGLRU policy decision rather than a readahead 
regression, correct?

Mem-Info:
active_anon:388 inactive_anon:5382 isolated_anon:0
 active_file:9638 inactive_file:126738 isolated_file:0

Setting min_ttl_ms to 1000 is preserving the working set and triggering 
the oom kill is the only alternative to free memory in that configuration.  
The oom kill is being triggered by kswapd for this purpose.

So additional readahead would certainly increase that working set.  This 
looks working as intended.

