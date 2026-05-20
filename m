Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6ECBACD4F54
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 20:56:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9C8636B00A5; Wed, 20 May 2026 16:56:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 99EA56B00A6; Wed, 20 May 2026 16:56:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8DB7D6B00A7; Wed, 20 May 2026 16:56:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7A7286B00A5
	for <linux-mm@kvack.org>; Wed, 20 May 2026 16:56:39 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 239DEA045F
	for <linux-mm@kvack.org>; Wed, 20 May 2026 20:56:39 +0000 (UTC)
X-FDA: 84789006918.18.33D940B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 5AE5640010
	for <linux-mm@kvack.org>; Wed, 20 May 2026 20:56:37 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="ZVmEYd/8";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779310597;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2AXphWvQV6X4jC/MRKf1KbDWGJMoBqs4UZ3fr8cRQqA=;
	b=2IGffEj8ZRxHZ8Id4uJAKfM1YyqQlqsnrFv7fSNqgln1jUGjXKiBX7h5XyujKqdMAixTGm
	D6fEEts1uxSsX54HeLo9z3meti5mABWcXr4LpGXLcrxQza7EONQD6ir3ZbmOfCdtvZe6uq
	ocBqk1pvMm3hzIfsAC/ftFmxT9CPdi8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779310597; a=rsa-sha256;
	cv=none;
	b=nJB5aBSRWlet+owyi68lMi8OjvAGBVl0fVc1DPrQUghn1nCjoWkJy/kdIyN0dmxj01c7Ov
	+Bn80t4IjxxJ5Nyvv8yzIpe7ueclpy0LEYVlM7YbkSriZyF4IpMqACA09skJGhIGmRl9jt
	N4lSdR08KxG28MzhDZbRxnvTmrvCxoc=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="ZVmEYd/8";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C0D0460098
	for <linux-mm@kvack.org>; Wed, 20 May 2026 20:56:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AB811F00A3B
	for <linux-mm@kvack.org>; Wed, 20 May 2026 20:56:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779310596;
	bh=2AXphWvQV6X4jC/MRKf1KbDWGJMoBqs4UZ3fr8cRQqA=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=ZVmEYd/8zxa4603xK34IC/TbSS8+GsRvpCzgDShciFrGe87PJWckkngN+a0aYuohQ
	 MtOBm8iMX5F2gAT46oduwpmioYZ4W+5330LRHqPO0j95zY/Ei/qSdZIsecMfR5JyJl
	 6twI+HLYUTrBoi7Dm8I1qVyKoT9IG8pZH60197+SfcaABytEzy17y/MSs0UvDWy9RR
	 Sh4H55aixk68FSm3iry+q9jfnx0Ftl9vUGgyaFuWEobiM5nxJQmLG5D0g7pI/kRJTl
	 4WcvjwW/x0e1UdtljpwoMoqp7icRbUOz6VevqHA6UHZY+9B21rAfqdEmDfq8wNygjT
	 ByK8JI1n9DaAA==
Received: by mail-qk1-f181.google.com with SMTP id af79cd13be357-910bb291688so654657685a.1
        for <linux-mm@kvack.org>; Wed, 20 May 2026 13:56:36 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ/6FWFAMpnB2NxVs3HcYRqp8Lkw6jMUwvHNHrAl8BC388K9Vu9WHPP27eoihO8Gj1589Zfe709Fag==@kvack.org
X-Gm-Message-State: AOJu0Ywf8XMw2V9+CpMwDFyavrWFD7hNVOjPLTePL+47D9zlPsic/Gse
	ZwS3ODZoXm2hOOwJ5Fe1KnYrwqxTX3NRkAI/0+UIOBhz+QG7RlLxIjGRDdTJuxnkQ6BqSLCy5WY
	UZ4UU9JoYFqSfYcNDC8Z2M3aPOY2/0ak=
X-Received: by 2002:a05:620a:28d0:b0:90c:a08f:c5f0 with SMTP id
 af79cd13be357-911ce8129f8mr3817766685a.33.1779310595916; Wed, 20 May 2026
 13:56:35 -0700 (PDT)
MIME-Version: 1.0
References: <20260514094108.2016201-1-jiangwen6@xiaomi.com>
 <20260514094108.2016201-5-jiangwen6@xiaomi.com> <177927799624.3551615.1232032128494296554.b4-review@b4>
In-Reply-To: <177927799624.3551615.1232032128494296554.b4-review@b4>
From: Barry Song <baohua@kernel.org>
Date: Thu, 21 May 2026 04:56:23 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4wWV7kA9NZnC1nKLuLEnd+wH7v=7=x8WJMznRNtHKhh4A@mail.gmail.com>
X-Gm-Features: AVHnY4IbJNNziZOusY4XlGaZUjTKeiA_BxxPElnZpTAi1mLurw4T57tnAOPIyN0
Message-ID: <CAGsJ_4wWV7kA9NZnC1nKLuLEnd+wH7v=7=x8WJMznRNtHKhh4A@mail.gmail.com>
Subject: Re: [PATCH v2 4/7] mm/vmalloc: Extend page table walk to support
 larger page_shift sizes and eliminate page table rewalk
To: Mike Rapoport <rppt@kernel.org>
Cc: Wen Jiang <jiangwenxiaomi@gmail.com>, linux-mm@kvack.org, 
	linux-arm-kernel@lists.infradead.org, catalin.marinas@arm.com, 
	will@kernel.org, akpm@linux-foundation.org, urezki@gmail.com, 
	Xueyuan.chen21@gmail.com, dev.jain@arm.com, david@kernel.org, 
	ryan.roberts@arm.com, anshuman.khandual@arm.com, ajd@linux.ibm.com, 
	linux-kernel@vger.kernel.org, Wen Jiang <jiangwen6@xiaomi.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 5AE5640010
X-Stat-Signature: tkaqrj9hfz1uszwjxe5pn575tucqybnn
X-Rspam-User: 
X-HE-Tag: 1779310597-854627
X-HE-Meta: U2FsdGVkX1/J7Y2w+nyoaYyOawdeuDOi0VNBaHGLJL2MUHXr6XBollp63BZ93oJ12W6nNlTlAMWkYReKMWlns/dlpcyjXGX2UrdTC8leSyuL9NpFplgOVOnSDUwX5lxPTxBXDJ3DxFFY/pjPdgTiVs6p5ef4CmtmSgm0iDuOxJhJvA0Kp+YBF+wGIBGixQZ14vH19ut6Wj/MwOAAUUE5FzMiGD84Ck2juvelA5OsvQmH4aHfIOHIPuVO0W7UGPmfud9s/2uKwkVGKXJBB7f0rknkLNI1IE7My26F9LHmCYosU4mrxSKou1Lk9xjKMwbQi0fjwqG2wM0rl6yXyF8K9Bb6TLIKUNY94V7hqkrdhTfyLGE90ttmjgvBAdYM6IJsG4sPd1GQoYo+36RasWPEvaUfR6j3hSqvJSKpy7C1D29uRARED/zfbWxE6EkBK3dJ2nYQlWkK2krYM6AZ2y+NnoZ47uSlGZ5G0hl/tnKEdORKjIWst6Up7YpBda+PP3ZeRWhoLX6WL8/qWMsupN9rEkDPSpylSK+0m6+0Klv0afn1ahZm1g1uqj8hk3tSNzuKSwgD9E73zfk5ZUHRTpI0yHrPpoknfP9VEnut4K89LQJPML65aDQEDinknHxiJR+tN/4O8epVMUZ7wDVPtdP0U7BmAhR8HrDVYnG1LGZAmAuI0xcD9wwb5Y9XLaLenj4Zk6amI525hJelRqKTs3JdK1kZcT30730G4eWXIZfkZSPCJEwhw/GDbIGW4UGE9oPvIoj7j3KNtxPgdd4/vc5rKrL3kYca9YvQ1AklXIK0s/Tmmh+QEIQr0isEvIq/7oP9dzpVErJWPgPDcL2bAVYKs4tim5lDXtDbXFsQurTuH9ajTjQ7rE6fzK/Pvz/qsImSlSzhVbS+3zl+/brkjdudT+f78cXeDxeV16C4VqKV74KV+t0di6IPh/K14Gtn56FOB1imDCdLkg+kEvL0Rtg
 sbt3AAjQ
 2wTgKIBdqioWFG2IsCt/NUnCMf/5ltku4HEM9O08264o+4i12xCt1U3KEAtvYVve6XLaFmed/1auVcYwn5gg7eo+AnWI0YRlTPmEPGQXAtOcWYag9sbkUqCMqPjnRcwsg8BZzx7LyNVsB/Jal8ggQ1MrnprA9tVyJbX/WX5YpU//DH0l/STO9SUBp1GYBdXXm3f8bhWZWSdZEpfF9KmS0MxEW6K04vktiXsoDdkF2VK4Z8jVAysvIOMJ39bavWZH66wp3g8Z//94wZ+bt4ChGbs0PnYtzuUiCN1ZLauwPLCHT28fSh02RJCfIEgs50DieMTRO7Gc64EGjRZwEmLh7pMWTCmRF0gW6QOiQ84NspoC4vbsM4a2rmBbTTMw7JcwO6bNAuxYLJoFmgnGzY6wKfhThUA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, May 20, 2026 at 7:53=E2=80=AFPM Mike Rapoport <rppt@kernel.org> wro=
te:
>
> On Thu, 14 May 2026 17:41:05 +0800, Wen Jiang <jiangwenxiaomi@gmail.com> =
wrote:
>
> Hi,
>
> > vmap_pages_range_noflush_walk() (formerly vmap_small_pages_range_noflus=
h())
> > provides a clean interface by taking struct page **pages and mapping th=
em
> > via direct PTE iteration. This avoids the page table rewalk seen when
> > using vmap_range_noflush() for page_shift values other than PAGE_SHIFT.
> >
> > Extend it to support larger page_shift values, and add PMD- and
> > contiguous-PTE mappings as well. Rename it to vmap_pages_range_noflush_=
walk()
> > since it now handles more than just small pages.
> >
> > For vmalloc() allocations with VM_ALLOW_HUGE_VMAP, we no longer need to
> > iterate over pages one by one via vmap_range_noflush(), which would
> > otherwise lead to page table rewalk. The code is now unified with the
> > PAGE_SHIFT case by simply calling vmap_pages_range_noflush_walk().
>
> After this patch we have two very simalar page table walkers:
> vmap_pages_range_noflush_walk() and vmap_range_noflush().
>
> The subtly differ at what levels they try huge mappings, how they
> account page table modifucations and, at last vmap_range_noflush() is
> left without support for contiguous mappings.
>
> Is there a fundamental reason to have two page walkers?
> Is there a reason not to support contiguous mappings in
> vmap_range_noflush()?

Hi Mike,

They are two completely different cases. In one case, you have a contiguous
physical address range for ioremap(). Since the range is fully contiguous,
many things can be simplified. We already support large mappings there, but
this patchset still improves performance through larger batching.

In the other case, you have a pages[] array whose pages are not physically
contiguous as a whole. You iterate over the pages and attempt to create lar=
ge
mappings whenever a subset of adjacent pages happens to be physically
contiguous.

Best Regards
Barry

