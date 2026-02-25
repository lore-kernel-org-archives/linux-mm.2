Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9EAC1FD45E2
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 19:32:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E53AB6B0088; Wed, 25 Feb 2026 14:32:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E2AA36B0089; Wed, 25 Feb 2026 14:32:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D37506B008A; Wed, 25 Feb 2026 14:32:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BF6AD6B0088
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 14:32:27 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 64554140522
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 19:32:27 +0000 (UTC)
X-FDA: 84483975534.30.507342D
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	by imf20.hostedemail.com (Postfix) with ESMTP id 5CB551C000F
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 19:32:25 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=hu63u0og;
	spf=pass (imf20.hostedemail.com: domain of tjmercier@google.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=tjmercier@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772047945;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jgvQ9LOkQazsPmWMTTjFvYurOXwrvdriypbs6xoQIpY=;
	b=P3TuLkX3ai4keXWUlYjSPD22lZtzZnV7KYR2eWnUW+Fj5wjmiQCYcJrqdoFtL255128ERT
	ef3uK1ToPc3jHzxwPFFCqkBKopaLGYjdQiUWUrRnEP6zKFfpFexSBD0TEY5o/HGxI+d2eA
	Z8+T666RG2gVdAPDTmdidsaF4oswtXM=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=hu63u0og;
	spf=pass (imf20.hostedemail.com: domain of tjmercier@google.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=tjmercier@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772047945; a=rsa-sha256;
	cv=pass;
	b=tkGAuYlNPylI5+FtAOBKfk3AqERQcA+SSKgawH6/9RxrY6+BCNrpEDQqJgG+7Su440okHU
	m1usWoo/o9PWEswbhtfUAZ7XWtkT7F/1EtXtT9WOzMgVv0kIdS8a8XOa0eLKkrTEzngqn8
	Cfn0zbfKSX5fUVAtPQiQa3bbUqoe5Fw=
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-48373ad38d2so14145e9.0
        for <linux-mm@kvack.org>; Wed, 25 Feb 2026 11:32:25 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772047944; cv=none;
        d=google.com; s=arc-20240605;
        b=cnJVPVL0vP0/JQgWVP4mQJ0J1/3flu2UW/3NCk0/gmr/dzu2ZwvysbVM8M8InMQxgd
         8qjp8aQRYYoNsqngr8vSdnBpZcxE9f7ig9dCqtYPDZ5d/p0YD06y4hImYGPSQfqaZNeF
         7K4wUDpIyRNtrgHaoiZ3YaL3MCV3j9CTVMONdFa6lZd+X6Iffc2DQYwX/97iQORUloEb
         Y3Nx8a/xwTfVjhS/vdbiB82F67cB6luQWMcWaVOdbaDu5fTdOF0ErzYBmgnFeCZu1TVU
         SPnKmAHrnTJWZzCqkEA7YcFvaJgoqe8m/thoUJZAPb2un+6GztglvBvP5FUsnGbtFbWm
         o5gg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=jgvQ9LOkQazsPmWMTTjFvYurOXwrvdriypbs6xoQIpY=;
        fh=8hWUo/gJofeYUQ6pVjVxVr++nTMpIBVaysJomzOt3TU=;
        b=NfPikwnI0+j2KKErRsdvoDCJ+T1AD91UY0gfRHrJ6ziDA5/fKbU6qr9quKZbaCLmJy
         F4HK+ZneZODCd16OqIsInyK61YqbaSctrGyq7UhlLzf+VYfJjXU71WY47+7bNdFWtiU7
         QEKYlLBtI7k/PAeTV2s3OgrDgugFj7bTgJ/bMnq7RYidQHrkyyLqMPapk1eA1gp4RSBD
         LGzLAh0LEZA7AjLMGWicqSHxOhbVNszDKXF1FpQfP/DkQDemxgOImuYPzCv2N3CcX2Yp
         TiDADhf2hdbTLVmCkGSHpDRxGoqh75YxgOjAgQK4wnXkGphtB+b8uKh+lyxoJrMRCBav
         LZjg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772047944; x=1772652744; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jgvQ9LOkQazsPmWMTTjFvYurOXwrvdriypbs6xoQIpY=;
        b=hu63u0oguOLN6tIcocqjhzo5PPDIN6OwctlhPl9wo4uZswpIlnTkrKnc+N4hC/A3E1
         w+8XHX7PJ+we8ukft2AasI+7fhS+tJ50/67PokQzeLihdmGHu8DOMK5Vo8Kvxmwl2j7b
         Cn4ieYlqpCzAaFNS6Z+ZwK+k2xuqh021RMqbsh+xx1AdaPn6VDM1HPui3YdRMHHpD/SI
         ZEQaMDKrYKE//MPfVjmev24B5lU/7Y4yDVy8nrK4Oi+I3lL0rSN9F/PZ/BXDtqVs7QGl
         rfFTDyrPGXLPr7oN+eDmXPA+IteLVL5a9ybqqK3ig3LX88fLY3EJ158RXmTDQBX317QT
         5fng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772047944; x=1772652744;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=jgvQ9LOkQazsPmWMTTjFvYurOXwrvdriypbs6xoQIpY=;
        b=fbcx6h4KCTNxNcBSqMVM3A95gPnuZR0OyqpArQhV+5AYy6PGzSuKfrfCWuSDzgfw34
         74um+sK14y+IcRy7RXZrWEX1hu5Oi/fVRKOqAgAom+5L4wkzwhN4Y1ZH8g3XC2Sh3u92
         O7iP2vhz6xfryPCWF9Hpj6fwKADcAv/F4/t49wCcqbuDns53zo26+dvanTBAQXP8YRve
         flcWCr313/vbH/NjS31x6egVbfrZZd/UdNXuZZ8og4nVc2tbkA7UGFLZ1g7Qys2Q78IF
         F80BJjmHe7x59hIIkai2juX8/bEnKodcwpP1kpLEruQK+lerOksu+Fa9U+aT+9wy8Nl8
         7ruw==
X-Forwarded-Encrypted: i=1; AJvYcCUpsiARlLaA42227HA8eqSD0UKVwEqctOQiB5j6ZR2z/oN0mdJ2k6yfRl5XA9TUtOLGFrEX8oQgqg==@kvack.org
X-Gm-Message-State: AOJu0YxHUtmAb/eDNooZvNBdkF2yPVnrk+XwAppjklo+DJNdyInQoCyL
	lN6H6nNoKcGIGNR1mIXIRIbI5GduC8MOnej4A9/KMCQalP1H39PAGWTsMl1Yx3oIiX9EkyreHFP
	PdM+naVgPaZWZSS1ph7ygqbtu/M5ztqIMMjjgRlLx
X-Gm-Gg: ATEYQzws+lU3X1VB78SBtmHQ0seaaiBmYgua6SsG/L4vz3Om7y7HlxCDisms8Ma/p/F
	rG8QPyDaKLZOqMvFQQgOmeEG5JKgV4Oyt3nEzJk5FaxQZYEJy71BOQ8mK/S7Ii7a5qaGvo7m3V2
	TGk4Dh3ZqnVs/PIwMk3GolQuLZzkoqyjgbn9yvuZURJJ3GWFaRA9qRVXpCgtVpfqlFxFDIdgKAV
	ji6Izk6HFln7JVLvHShgjE2XvX6vBW3dDhVG1iDAbJ9tnO6Cuk5ac4UDHAFFQGumqdk4y6OowS/
	2/WyjLi3hSc+OqNe45ce33Wh2YoPALia2clWuTXS7Gzefs7s8gZoxulhhSdgwnFuLpvkFA==
X-Received: by 2002:a05:600c:628e:b0:480:274f:843d with SMTP id
 5b1f17b1804b1-483c31b00d9mr64725e9.16.1772047943193; Wed, 25 Feb 2026
 11:32:23 -0800 (PST)
MIME-Version: 1.0
References: <20260225-dma-buf-heaps-as-modules-v1-0-2109225a090d@kernel.org> <20260225-dma-buf-heaps-as-modules-v1-1-2109225a090d@kernel.org>
In-Reply-To: <20260225-dma-buf-heaps-as-modules-v1-1-2109225a090d@kernel.org>
From: "T.J. Mercier" <tjmercier@google.com>
Date: Wed, 25 Feb 2026 11:32:11 -0800
X-Gm-Features: AaiRm50SiWoOS9CfY38Fs_M7N-g3DOx_BZCYfNv6nN_YOmBm3wEPmTfvWS_ulms
Message-ID: <CABdmKX2_+zh9jg+Wc9iS-YndB1KefC6+fQZ5G7f1LyyCtuP67g@mail.gmail.com>
Subject: Re: [PATCH 1/7] dma: contiguous: Turn heap registration logic around
To: Maxime Ripard <mripard@kernel.org>
Cc: Sumit Semwal <sumit.semwal@linaro.org>, 
	Benjamin Gaignard <benjamin.gaignard@collabora.com>, Brian Starkey <Brian.Starkey@arm.com>, 
	John Stultz <jstultz@google.com>, =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, 
	Marek Szyprowski <m.szyprowski@samsung.com>, Robin Murphy <robin.murphy@arm.com>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, linux-media@vger.kernel.org, 
	dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org, 
	linux-kernel@vger.kernel.org, iommu@lists.linux.dev, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 5CB551C000F
X-Stat-Signature: tuac9thqax3o6ukqpms64oz6nudgqi4k
X-Rspam-User: 
X-HE-Tag: 1772047945-611256
X-HE-Meta: U2FsdGVkX1/JOKaQphg4a015H2J4ZoCjYGQcTT3FUCOZZB+bC0FQvn41TNbol9sSnszzjJJ4dDpk9KOQWbbyIXJPZiDf1ntiRQ3Cjd+j6awKxZM2q0vUooqwwrgmRDYIZ8TcrEjGHWMe0HXUuS44mPw0+j1K3RTjKQb/ih5zZgOeZJ+/OhCIROrCIxRAk52G1ig0+YJgE+CHMMsrkbelyaGptLSZgLFiQcIRanP0iEIQqbWfPoubJBNrVp7TLLlwNmNc+Sg/oLT7cmIzP9nI05AmBcnXeq8PW8P6N5k6+hX6R1xg6EpeJRrhJ7OlFk7286+pY7kVlRe5qsGdybwZ+Q9VY9e3KbD2DjvklOQ3R0EWkwlHsWWc6wmtFsKYctPteW12BkiquoOR91skR/fcXy01FnyrlAqiqqRy92WgoTkDGUlAPs5GSuWQUmjJzRnObm4Se7WrzhXlJfxsULvRLhV8OFEC6FOq+EVjewtIXcOO9Z1KMzXw6kUMPr6eKhm1+rafODh/jO/katlujGgXYAsUHm1ETQHIbqgnKA42wWCjdtiTrUYdDcV5jgXLqG8bmDWaVIZe3sjQ4TuikwJ4NuxC1NYiGTWZjV5CkdZ+8qT5JmxZFeGMzn35/SjBE5s/rpBVHypVZplkx9YNSSng1/uEXJ75mt0Vg+iOUNIoE7xXXzgn+qJMdzzbJ+qs6sGlBwI27kRXKz4Jo9QNHdv+Oijqhzztb0m4uQyBZL6wjZbvxJ3X7y+4EZ9XOXaoTYFkr8akxyjbkhamYRqXXZMlrrjauJPJ4rSELHjjGAFSOsk3ofQHmQ4aGyP1rXLaoyDsWqR1vKpU4W+Jn7VECXiGrQePpS9jx4fGwhLymGNvEqxhPD8Q3asG+lHsOZPD1Sm7jSGXMIoe3bJdGkLzVdas5VG7vWcAlvbIzjuTbVwZO85SXBw34uPZzy5/oD5ID1+YCTcsqFn0l8aPTGDak26
 Lf/nchs/
 wiq2uCHrupW9swuMKkXZQsQ1fCbJUycp+K9zldnR2uLly1LDxntbBbU/9UT2bZr6ko8NyXWsFVprFP/8W/pPGLPF/kFTlvm9LSUp1lbu82w1mXD3giKp7gJAPREeGMJSMIWUZAFoZWvgUvRy54XHAzDe0yC3NX/fJwpwMvMyUM+RgcL3ZhS+/MOgOujoMQYhSyCZbQyGmUKsb9dzAce5FUdc55DdAJgAo+hKOTpwkKVRkA3T6+ow2dMO9nSWw6P0Ly0na+Z+s9Oo+VqF04wikxk2E/nSNsAMwL/ZA
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Feb 25, 2026 at 8:42=E2=80=AFAM Maxime Ripard <mripard@kernel.org> =
wrote:
>
> The CMA heap instantiation was initially developed by having the
> contiguous DMA code call into the CMA heap to create a new instance
> every time a reserved memory area is probed.
>
> Turning the CMA heap into a module would create a dependency of the
> kernel on a module, which doesn't work.
>
> Let's turn the logic around and do the opposite: store all the reserved
> memory CMA regions into the contiguous DMA code, and provide an iterator
> for the heap to use when it probes.
>
> Signed-off-by: Maxime Ripard <mripard@kernel.org>

Reviewed-by: T.J. Mercier <tjmercier@google.com>

Thanks! I disabled this registration in the Android kernels where we
build all dmabuf heaps as modules instead of built-in, so I can undo
that if this is merged.

