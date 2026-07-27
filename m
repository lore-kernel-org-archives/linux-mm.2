Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DD5D8C53209
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 16:35:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9D9EF6B00A3; Mon, 27 Jul 2026 12:35:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 98B126B00A5; Mon, 27 Jul 2026 12:35:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 828E96B00A3; Mon, 27 Jul 2026 12:35:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4A9DF6B00A3
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 12:35:30 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B6784120118
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 16:35:29 +0000 (UTC)
X-FDA: 85035107178.10.B9AE947
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	by imf14.hostedemail.com (Postfix) with ESMTP id D055610000E
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 16:35:27 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=CKXm3GfB;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf14.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.43 as permitted sender) smtp.mailfrom=nphamcs@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785170127;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MosLzAOb0t5DpeSqUWkjuGhOC/5FMQBcdLSyObRpONE=;
	b=TtAJfUgpEvJG9WzgkP8IQaqDo6noILCSGREPzPfqGVNEjPPLL5UM4c3Y7WGbP8PAjBrcZv
	+WEwBs1on/QNa+rdrCPakhhD4kzbD2EfWXYDjxsQ94hwZHMeXFCNZqpyXVfNS6+yR2qHP5
	wtayhIo2HNdxoJFCDiDVwptXM3ro2GU=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=CKXm3GfB;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf14.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.43 as permitted sender) smtp.mailfrom=nphamcs@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785170127;
	b=xVCo84SiJ5+gZ7o+8xnqnMfjsSNpd+B5TbE3qJ1ByEc2RC5b2+leVW6xb6tybuqFCSWQxJ
	ulXfZ9yv+n2leq5QLa8JXAeXYu6JMjar+/bDTVuc8DvVYVgmUSX5NmB1DwJjrTL6If1dGe
	rs25dMBTNxrKCs6KDhlGDX1g9z2Ug8M=
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-4720f3bf164so42246f8f.1
        for <linux-mm@kvack.org>; Mon, 27 Jul 2026 09:35:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785170126; cv=none;
        d=google.com; s=arc-20260327;
        b=hPI/aftSHUzmSU/lHYQjl/irv4qLsYoo0glu8JASGcmDwb8g5qQ3Eg3O7+KELkKUUz
         pYXjOfdGrZDh01K5SnjVQkopnMC1dnUoUIkfTxmS0aFezJZRtThzzzN3EIq9qaKsIX40
         1bT5p+29Ak0T9BcnQbchWenR0qMYfiAh87hnlKPAdfeAPgCZHHwTt+iTONCPf7bRWotI
         WrZz3+UlU8MCbdlyR6gc5PLRC1kDWcKMT9l2BJyHVnHbmalsJAOHPn9toSC11BJXkURE
         A7Qi83g4BWJVe3JdkjVfeWuZCL7ghkSE32edSf2wRyNvQ37ReaBQunwopimAugPhKEEz
         MsgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=MosLzAOb0t5DpeSqUWkjuGhOC/5FMQBcdLSyObRpONE=;
        fh=Hlj01q9BPOGId+G+wLDoDK8UC7kffznweD75EeaWZ3g=;
        b=WO0Tu9heQPQ6z5tBRYRsOYr1r6Wb7kgmT+Pjxbs+ZS2XgNxcJl0tH5E+zAqpENsRbn
         8kndRestCWH7Yi28Fd0ZxQ06OrQnqdJYxW6WAIJzsTa3BHRGPl0fi/UJDlXDCr5iS7ap
         GozgHbcrF6ECcm8TrxMY7gI1xp1Bc9LFUw3u5tg3Zp0Z/z0RfdZP7xJANml0Mm6pdQ7J
         W/v2SW7cBhLefrax2fnz1eBzNMz6p92cA4EbuRWKXUXkMIHSkhdrpayfnkT+LnHpnBkJ
         0CPTB4u0g3D+CqGmlnKLILtDL+AAKVoybnsotdXYBt1iLnIeNTX2/RdwUZfbyuX4Bsev
         XdSw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785170126; x=1785774926; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=MosLzAOb0t5DpeSqUWkjuGhOC/5FMQBcdLSyObRpONE=;
        b=CKXm3GfBXuZRoiQOgJM77M+1OnqktRvuYWiAWPL8Ah+teCVBZsCT00wucSXOBYvIqQ
         4cc9g0kQi56UjW19NiYHT/RXfnEaa5b8pd6QFUhfnOeacJmr1/Uem+ab+u434q3LG3HC
         V22xTUsA5wCWQQV3x2qstoqp89HnL9XycXQtIh86xLArMYO+6mRvQO5zba4ThLV9WWvX
         mNW/D7w3IB/+mpUS1qdBeXNHrgr7RFCFv/k472Tk6JYN30DPA1HHth26lxpxqywX+Tnj
         u4G3IHdUMfN2dNuVmgtJdLnvUlVGB1cuf1HWbwcw3St4wxscS2olw2GvuX8aoaJ4Dtji
         ZCqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785170126; x=1785774926;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=MosLzAOb0t5DpeSqUWkjuGhOC/5FMQBcdLSyObRpONE=;
        b=bk577TeP2iNtQVGvSVvWqP5u3J1I8lw6FkxQ48dakUhlUSLnvcNIAGSMm+JHY4K9AR
         85fdPQ+dJIqmhr3VLNm6+bLWd4VkiT8etYof6vO2FyLtp136l/X0FdBcEwHJCKf3T1EE
         GNbaeE40sxgzl8KdQvChOF71q7J7tYrvepulFNjOhb+suwB+8wko21Z7Pj3eHAByH9UW
         hL8vys3Dcnauz7jczcx38zTfVFEL6oXhfpZX5VHXEc/0IHiwxzI8/2/m8hghT2dv1lqe
         YtvitYPNVKYpP69FqneB3POPvNMsEtPG8d9eQR6yIVo+0J3Y+L7Sdbkv6v0y9ksXTD49
         LgGQ==
X-Forwarded-Encrypted: i=1; AHgh+Rqbz3XgHlUaSUwWSOWcOkmtVeauwcnYva25G0fKxv6I5S42jyZAb4TDzx7AiMNdxVx0WtrADoPO7Q==@kvack.org
X-Gm-Message-State: AOJu0YzgzMbqyiF8hv5P7DrNX2EGFacFl/LuSLOu+nigBPh3oU5eOBAt
	w6Rc4ZiaUqFPZyFsoz7Ji1q+XBUUyr4Q/xMRVzJ6Pt0nHn/Yhfx704PGfMfWCsWlfgJ8TmRBm6b
	8T+85c0zXZJRwAYmrxOslml4HUhlw43s=
X-Gm-Gg: AR+sD125vVFAuzJxcxLcKnTlm6fBzfqEUgjpjuqQbkOCyBQX/VxoZwUyoPsXvNPRhBj
	1WQ6ZU+paFgxEEfrOjCodIo9LCpREgx63L2c6uj++AmDWVGoZfgDHYnvUiDoDaqq8DPIj/2FwEd
	iEP4Qh/0rp0tnwREagoePW/sqJg/bRZlxiOMjvyzcCuNz1OZBc4vUsNptTrqy8qYTXvXra9bQdG
	fRcFogbA7jGGHkYvOVj8ShFPIFggMytrr11QggwbKG9KP33eWwnNOVfcnk9NwoG5b3b3cBTjsDT
	LOMJdhe6o9JjKzjjVgkz6fWTIihJ
X-Received: by 2002:a5d:588e:0:b0:47f:87f9:6ccc with SMTP id
 ffacd0b85a97d-47faf5b6257mr272808f8f.30.1785170126318; Mon, 27 Jul 2026
 09:35:26 -0700 (PDT)
MIME-Version: 1.0
References: <20260726-shrink_zswap_entry_v1-0-0-v1-1-30957e4d0cb6@gmail.com>
In-Reply-To: <20260726-shrink_zswap_entry_v1-0-0-v1-1-30957e4d0cb6@gmail.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Mon, 27 Jul 2026 09:35:14 -0700
X-Gm-Features: AUfX_my1tbY4sQGH3dDFANLwnXAZgKc7WpJkE1fr0Fyb9I9VWPnfLMnwKKVxpRc
Message-ID: <CAKEwX=NLEmRKbgf7e4mQ8ynwGLhe8d3orc_2U8n-K_W6VjOAoA@mail.gmail.com>
Subject: Re: [PATCH RFC] mm/zswap: reference the pool by index to shrink
 struct zswap_entry
To: Jianyue Wu <wujianyue000@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosry@kernel.org>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: D055610000E
X-Rspam-User: 
X-Stat-Signature: rcsge8opxfo766bfhxmm1zczqeqezzui
X-HE-Tag: 1785170127-809920
X-HE-Meta: U2FsdGVkX1+NjLQ37NACsC9POKWGs1kEEOfjseIU8ulWXP9kZM03wg9IU5zBYUIQ4TVNH2so1T3xPj1xkEQ5dT2MlT3HBDloP2Kq8eHph4A50uZH1LOOgBKc2BNc/39P+PKtszhp7mUnEz6JOris+B5e3d3CmNYXjTC5CLj6enKyHYB7A0BFe7W8qG0DVkxGJWStpWNHGoKQE9dn0mrfuy+eo5gDAbQFi7KPezdUIw8bT5aAaSUM7RIsyy6o9KX1cFsqto2Nj94eeXCc8sCqifggj2qlvPklGM7hOnfMzRhSyJBsUjC0UCyK5HE3bvrj9bYfOamMx6wSjhloRf9YT9n0JSvmSBKASb9GX4/bxGEHn6LDob1E71wuMdgw6JOR7Usv9j3RGFcf9Xe15lsLwG0d9sBTM/sz0aSepnwChEzEoLrZiCciw1o9ABpuufXnCFtAVp09+uBGbj7MegDTc65qsepgJiNZx1K/zxP79OB7Cg+YZh2Fnh22poh16dVyQySvcUHeE0VrMVFAgCl/uKy0DAfLED8aAbqOxjuXp8kvj6ZhvDAi6IMfnJWB8KBGM7U/KACB4SIzWUX+wxR2411dISmjY6Ilr3kDBz7yJJcKVx7R43fb9zYxnWbg1jL1dB/kQTrcqpVs5xtMZIEfDS5G5WGONxO5RkKnODSYlFlQ6Km7mq/6z6VM87sTC9OhjOiDeRpF8UXZvgjDbBllaxme5JWu7xm/4M0+OGUD170ORb8sUKsD0CyU9+0lgg167bHMOIQsGW8QYGwKrcIwRLPoSrqOp17pwr2LOBpjzkJzgAk6LwpS7lu3sohBYxG88VTXvsp0rCyh3Ns1gohcf2uKqVZv6/x4Jw8Ey+8JyuSbNAX8SLQB982P2x5PY3MGIzmYL9OCbt26TTvm/7gQBJz7sItSTd6kvo1r6oIoMGbLciISb3FwW6Xb+EGXZCeJzvT5mmFUV6AWKBcFyK0
 +M5qzmdF
 uFdeEz1NL3uwnl4oJC9Oh5XiAaqmvCRja/Ad8RMVVtPs2J25SWXjmPT0MWUUUX3npYxIvm6IWA7h/yRfJqscdIW6uvxi70QCs7LKjxGjEFNzjqjurj9ovF7yNejKdGjQtK4AZa6bNiRDS/KhqbLgZb40fIy/yfwOQczoANS5wsr4J4+Zky9x8toufRBehuwFEUru6jtoqpOKAemdE9sET1otP9F8dkou5PK2SDWP+cSVoY6tPtooVkvCXoxbMEzP9LFnimO7mpdCYXy+Fwk1j48Xstjr2L09p5BqQ5L0abA09mBoGMhBwOXQU2y92GCMZoD/bLvhWm8M5rvrCh/jlFoNiiCqXnGUTg6Jc7rX6QdbmDzYTf+4vOODZx8tMZe25Hwcv+1zgqnJ7dRvdb+oCxb+vNWlpaj2UEFR2LgbVgiU9Q9HalIAA9HekH31cV4NcoAJmvm4sJ9mTevdbiYOV2JZJ2w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Jul 26, 2026 at 8:18=E2=80=AFAM Jianyue Wu <wujianyue000@gmail.com>=
 wrote:
>
> Every stored page has a struct zswap_entry, so its size is a per-page cos=
t
> that scales with how many pages zswap holds.  It currently embeds an
> 8-byte pool pointer.
>
> Replace the pointer with a u16 index into an allocating xarray of pools.
> The index is allocated with the pool and remains valid while entries hold
> references to that pool.
>
> On x86_64, the zswap_entry slab shrinks from 56 to 48 bytes per object,
> raising objs_per_slab from 73 to 85.  This saves about 2MiB of metadata
> per 1GiB of data held in zswap.

TBH, that doesn't seem that major... It's like one huge page man.

But Yosry might disagree?

On the design aspect:

1. How many pools can there be? My understanding is it's bounded by
the number of compression algos, and most of the time the system just
use one, no? Maybe just add a fixed array and call it a day? :) Seems
like we can probably get away with, say a fixed array 16 elements.
That seems plenty. You can reduce the number of bits it takes to
describe the index to 4 (saving the spare bits for future usage), and
you can avoid the xarray overhead...? Just fail and warn when you have
reached capacity, maybe? :)

2. Note that the zswap pools are also organized into a list. If you're
adding a new data structure, maybe remove that. Or maybe the other way
around - can use it that linked list for your purpose?

