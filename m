Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C30E2C55ABA
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 11:10:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BCB206B007B; Wed,  5 Aug 2026 07:10:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA2D06B0088; Wed,  5 Aug 2026 07:10:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ABB606B008A; Wed,  5 Aug 2026 07:10:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 72B986B007B
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 07:10:46 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E222D1603F7
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 11:10:45 +0000 (UTC)
X-FDA: 85066948050.26.4798731
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	by imf21.hostedemail.com (Postfix) with ESMTP id 0FA4B1C000B
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 11:10:43 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="Qyh7OF/0";
	spf=pass (imf21.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.221.47 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785928244;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l1aFJjHBLKOsulK9V02wzpUBZ/ZdGfqsLkqV9m5vRjA=;
	b=YgEsPSjU+giZoxzk83cf+EE8ywKc6QOGKVEkmCTjzxfoLjrNuhrPnIwS5PM5TLBB/c3XOW
	frEjqwYh7PPHuC8lyAy27/G9NOdnqDmKxxW+vJRXnf2F7/r8d+Ndt6a4EO19ULbRazJtI2
	Z+cdzlPAUlo1O0R5jWa0VX9wUfghXlM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785928244;
	b=Qsr6I7dFrkU+tueGW1BZsQNJWMazPTnf+p2TIszuV1JWNiOM47tKeMWY2fN2gZyhMOgolt
	hGbIUxOa/rjveKJ/3ZMcw0Stwk+wHoNQrVPl5yrGodZcUuii8uN4D2VGgr6vaJAdARFORf
	lJJpfD7BpNYf+MO2yDZqst8GHVE6BCI=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="Qyh7OF/0";
	spf=pass (imf21.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.221.47 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-47fd4531020so521576f8f.3
        for <linux-mm@kvack.org>; Wed, 05 Aug 2026 04:10:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785928242; x=1786533042; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=l1aFJjHBLKOsulK9V02wzpUBZ/ZdGfqsLkqV9m5vRjA=;
        b=Qyh7OF/0oEaxj6qNiqyHe17NP3EwEaI0DYWZHA0CQgoEm+UCpS5R/yXCPGhQ2hyxYA
         GlD18ConANya08SOuQu7IuCazr3uMrFOOppxyqhKeXLA5RaF7qH7/djJHWuDM/O2O3Nx
         uktk/CP/7dlOrmTi06fx6M1SnRZ3qRQrOBmN9PdbnGhdHkXpvIq1vmpoauVXBQEKEVmY
         aW4qEd9XZxKmO0lMAxiTv4MPFDSjNg8C8gIXeRLxpm6V6dDSJ/fhZMR/2e/jtIkg/VGE
         LM1GxN8JItxXflngfGhmPGtSim246/E5O5mppN0yOfGl1JRV8bbmOykpiA4KTiVzYzgu
         9jPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785928242; x=1786533042;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=l1aFJjHBLKOsulK9V02wzpUBZ/ZdGfqsLkqV9m5vRjA=;
        b=JgrfCwigyWSn2/lcjt/tJssYpYiRTCNWP1BhATRC7naGx2RkC/HB8lexK5oGlMAN+X
         8tQZNkVd8fU8O985MTQPX7qVNcgFM7d5U7z/nknkXcy8J5OAK/gSdzOED8tueTBfIQNu
         gohICKXu2iIzgk5mcIU3NepsH+FMfS9NbsiFISl7ZD2AqwzscCqrrdRxnxGnaBp/4TQj
         P8iKHjLZTcVAT3xwKjjZ2fhWxBmwRV5qxuO4V+vJGkgtQsxNYlqKLLPm24m9sWsTWMq7
         8D8BToQjq2Gxw8Fdl5w7qSLLsNiTG0dg5l7YdDXTKxRL61ihcI5ZtXR9bvxhVuP/yN2l
         UfWw==
X-Forwarded-Encrypted: i=1; AHgh+RrZjqdaR4V/wPHtFtIHK8x/1yDMnqcbf0fCkjSfLa5PPP2aeCcX69pmff9IReNyTEjEgwxnQ5wO0w==@kvack.org
X-Gm-Message-State: AOJu0YwA4OMWqwXTvDhpxNBxhIjqVAeNF+WZZ77yIRg2F5wBs6jutj/E
	XgsoW8BEMKCG1kOPd/YeQYJRH/+yQLRqvgLg+X/XEMaT3+XFAUg2Qsvw
X-Gm-Gg: AR+sD11BDK4yTGMNrj8gnYsJWSjWAy0rdgPb8+Kz/hg9K6HGD8LEpayitRBvH6+I9qu
	G8jVaVe2wht6eDU0zcNdqSxdOLY6Qk52DhXTRLbssvFTc9l/3ZTevteG0dQFV9sqqyh97Uol8ck
	WusnJTCHUWbVVfIBnhV6we0WyWHFrOs66hulsIrBtw7W9NspOcI81O27uhq5TpQr58hTOrL9jEt
	AMC38ENrzf4JmuA5q6NnF75MN/UvnFfbrN49aZ+L6rxFFau9N8W3ImRg9lp7DZQoBsVoH5+KY09
	1XId2dPv5fpZMYYlldzTG9FU/8i0eE2ZELzPAwCz/klLgeiKx2axSo2EjyYln6qlgqwYcN6wXXp
	FCbbSkqilxR8KILRjZ0nN9MzMm7PKFTzdVEpqWroAOL97ow9qp4pRc1p4oPSi2iiABG1ixbXen/
	kTkBa9Ljhw0adMXC2/2lwuj1CNhjLGxz8dpw0hW4y68Ph2NCsbRjfrrWmz/0n7/Wx70xHG0DSAT
	lrYZUOPiljOlf+OrETGHkbRxw==
X-Received: by 2002:a05:6000:29ce:b0:47f:93be:dabd with SMTP id ffacd0b85a97d-47fec634beemr6891249f8f.28.1785928242185;
        Wed, 05 Aug 2026 04:10:42 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47febfdd383sm7437135f8f.8.2026.08.05.04.10.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Aug 2026 04:10:41 -0700 (PDT)
Date: Wed, 5 Aug 2026 12:10:39 +0100
From: David Laight <david.laight.linux@gmail.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: "Christoph Lameter (Ampere)" <cl@gentwo.org>, "Lorenzo Stoakes (ARM)"
 <ljs@kernel.org>, Mark Rutland <mark.rutland@arm.com>, Yang Shi
 <yang@os.amperecomputing.com>, Ryan Roberts <ryan.roberts@arm.com>,
 dennis@kernel.org, tj@kernel.org, urezki@gmail.com,
 catalin.marinas@arm.com, will@kernel.org, akpm@linux-foundation.org,
 hca@linux.ibm.com, gor@linux.ibm.com, agordeev@linux.ibm.com,
 linux-mm@kvack.org, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, Linus Torvalds
 <torvalds@linux-foundation.org>, Jason Gunthorpe <jgg@nvidia.com>
Subject: Re: [RFC v2 PATCH 0/16] Optimize this_cpu_*() ops for non-x86
 (ARM64 for this series)
Message-ID: <20260805121039.471c7340@pumpkin>
In-Reply-To: <84b31836-1d10-4bec-a469-468b91fd4645@kernel.org>
References: <20260715180455.515692-1-yang@os.amperecomputing.com>
	<0344c559-1959-4531-9265-d5a5180eb7cd@arm.com>
	<fc21c840-1584-4844-963f-80cea7f2e674@os.amperecomputing.com>
	<amCPBrdltFSE_fEf@J2N7QTR9R3>
	<25d1e09b-53e4-7cd5-87db-b58437e4e690@gentwo.org>
	<4887267b-dc26-4c33-96ca-8dff054a0d1f@kernel.org>
	<anHuLy52o5S9Nlwp@lucifer>
	<63ea8156-a109-b2a2-6d35-1c17ad7f1a9d@gentwo.org>
	<84b31836-1d10-4bec-a469-468b91fd4645@kernel.org>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 0FA4B1C000B
X-Rspam-User: 
X-Stat-Signature: 5cdgncihb3pm51u47mfxgzr7fnyrzt9t
X-HE-Tag: 1785928243-619349
X-HE-Meta: U2FsdGVkX18tb0Omg9zFuJJCycZiR/etG6oq3sdmruFZ3wrMQzESqeCfaUFM8EkwmNFd3YbMM459TNJUB4V032H5cyfr7h89sZrZD/dUsVI186BurFk5Zp2AL0Cn+D+XOLYdNTHek2OO8MjO0LW7kwZ6aRURrkA9UwJVvPHbUtQmSeJ85CU7raW5BX4XxU+c3vyhQlR36qoa6sXqCxb7dcNOLTtApengMdAjH7+8OSCvcINiswzBHBzeTa8b04zZ/JQht8iF51wU/XXZQUKOPGGxNGqFXPsjphZg3SIwZYyPA8GOJWKKnn3BVenQGSnPDo8wMbTC4FuGkvr7KFejkQdrMgxj6fYYE/nnTXOStVdIyHTxkCWE16/KO3Lpp8rLkiZgWLErD5HGEkcRaFGpW9JwvbIy1RiEqjapzzh+5Bd7mLyHs8ndqAlgBIPe1s2Gfci5770WGEHd6lSPVoLpIRw16Md1Ut2DMNeKFaVPiu/zg1PzeuP/CCnn7lH6hKJxTE8aR9hrdNR/0H/0lZY9MDLwkSwc+16K0dzPX4A0kE4NThH17lOvpVA7Z4QVg9Ikjeg+UJXBX2SpH2utIGr7KBwX2J++85xY0xwq7NzK85Pxkb8L/B7SCmaD8JhAl4USTqD+nbywGwX9mTT2JY9IEHmMHVGH54yDSOuRAe9AdArOkwvFL0WTf1mq42kI22arfjhbHfhrsLdsewARxl6Q+QXBNqHxS3xRCqPFnj9raPJa69FdgLfz0SZZHP3WNCMT/onyh0Tbqx15pNS1BTz64HhWfsqjJNXGIfqVDp1VDDSp+XavYsfBqFKsbmxU+xRe0r9LTaXdEM/xwjT5wylK5UsMQTZmRfmsjqBDNuZyh8shqvUmvkSud8oyZRjIFOA/PIp7sKGaTUSZoFp3IpzLHzceezJqGgqQv5nkggcA+YRE/MtEuxYsvzM/uJl5Fsg3fMvGoNzkX6QjOM9Y4tN
 Dztx3UEC
 57/VoYeGXnBBmoEKchenfaVWCWebgkRlXXkls6FmtgVHO7WDbOjdreTjlVuNMUnoIvrFS/fLMgiYa4B3G/vHy3wdCA8jkP/YQt0vJJ+R5FAJpele293k9fCvB7iecI0+nJBM7fXUbmnSWAwVTKkmTy9ZJXYIloabWL6Y7+ae8INdFprR6X010l5IzW1AHuIIbb0UOkEX2QOXzx4C41HylUn/83IqrSqFseSysqpMj1UJzXrI9dtquWEE9ZVoeh674Xv4cwnXKCNWorEFf8HJcbwmAVqYZoPh7WN8O4S74kkSwdpFtLvAP7tVpG2HyeGiTRxq6kRFEttfzLc8QiB9Zt+rVu1+Le7cPN0hEu8gQPpw2j4okuypEhgDBJ72JgK2BYgbpcG4mLzzK3MX5dOT2fjCvje16EKTeByLi9lndwAw9J1UUIIlASbKY7NGD74v88tTWykddArkp4ev4WNNePeotU4AFBNkk1c+ePgW6tOJSZIwhpIFxdzA3Ew==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 4 Aug 2026 18:47:26 +0200
"David Hildenbrand (Arm)" <david@kernel.org> wrote:

> On 8/4/26 18:19, Christoph Lameter (Ampere) wrote:
> > On Tue, 4 Aug 2026, Lorenzo Stoakes (ARM) wrote:
> >   
> >> Since this work seems to be very much arm64-focused, perhaps it's therefore
> >> worth looking at an alterative solution that's specific to the arch, like the
> >> one suggested by Mark ([1])?
> >>
> >> [0]:https://lore.kernel.org/all/CAHk-=wire3dzhHx=KiL_f5Rj0=1u9ustsa33QoR-F9-v-NU9Ng@mail.gmail.com/
> >> [1]:https://lore.kernel.org/linux-arm-kernel/al_DpFJFcmVhxpvW@J2N7QTR9R3/  
> > 
> > Mark's solution does replace the preempt_enable/disable sections with a
> > rather hacky restart logic. It relies on a long preemable and postscript
> > to each per cpu operations.  
> 
> Okay, so 3 simple instructions of preemable is "long preemable"? In which universe?
> 
> But I am sure you did you homework and have data to back up your claims. Please
> share that data, because I am very curious.

The proposed sequence is:
>           // Prologue. Enable fixups for <off> and <addr>.
>  1        mrs	<tsk>, sp_el0
>  2        mov	<tmp>, #__VAL_PCPU_GPRS(<pcp>, <off>, <addr>)
>  3        strh	<tmp>, [<tsk>, #TSK_TI_PCPU_GPRS]
> 
>           // Generate cpu-specific address
>  4        mrs	<off>, TPIDR_ELx
>  5        add	<addr>, <pcp>, <off>
> 
>           // Perform access sequence
>  6        ldr	<val>, [<addr>]
> 
>           // Epilogue. Disable fixups
>  7        strh	wzr, [<tsk>, #TSK_TI_PCPU_GPRS]

Think about how that actually gets execute by a real cpu.
Instructions will be read from the I-cache in 'chunks' (maybe half a cache line).
They are then fed to multiple decoders that generate u-ops for the execution units.
The decoder is unlikely to be a bottleneck.
I've numbered the instructions:
First clock can run instructions 1, 2 and 4.
Assuming the mrs have no extra latency the second runs 3 and 5.
The third will then run 6 and 7.
The cpu then probably has to wait for the result of the ldr.

If the access is a write then there may be a stall waiting for the value
to be written to be available.

The only real effect of the extra instructions is likely to be code size.

	David


