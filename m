Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B1BAEC5DF81
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 09:52:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 899F76B0092; Mon, 24 Aug 2026 05:52:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 823F96B0095; Mon, 24 Aug 2026 05:52:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6EAEF6B0096; Mon, 24 Aug 2026 05:52:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 375AA6B0092
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 05:52:46 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id AE62CC0476
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 09:52:45 +0000 (UTC)
X-FDA: 85135698690.24.28E548D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id EE0DF40008
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 09:52:43 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jRQUE2gR;
	spf=pass (imf01.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787565164;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ncc/ibtwj4XA+xUmAcqxnKb0K30k1jpqLU0IvWTGloI=;
	b=j5hL7Az8Z2jQ0QQzE35VMVCLxS+F+51y5qUBmgFfVHxnHmHbz0jDP3zPPDotyBI2Uv62NR
	2u8LKE4acgIguvre8diKWNtrF/4OWzV6XxA1jR+EK4ou9jMphVPjrBsvQ/M7fR1O/j6tjE
	UFP32sQwNHk8f86N7tg4ArYLbKRaLnE=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jRQUE2gR;
	spf=pass (imf01.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787565164;
	b=VJ4K2W1wEa8R8kXYtuwRmE8XSEgIg/mwZrB72rkupyNEIPBfG2tWPGIV1QwIFMPX260aet
	d3Y8+gWoouiuOoLjBAWcsdWgj0OLvJzPtUHON1TSATRBcMdgx9oCW/dL9+lo1oKcWdH4ZX
	YUeZepwRq47EEICaGGaH01iVjBIN9+s=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 69282600AD;
	Mon, 24 Aug 2026 09:52:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2441E1F000E9;
	Mon, 24 Aug 2026 09:52:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787565163;
	bh=Ncc/ibtwj4XA+xUmAcqxnKb0K30k1jpqLU0IvWTGloI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=jRQUE2gRuRRWrt1yYPty7r4L6TNF+UqtdyMmMhBQ5nkffh2Q7Ab3vvPToUgj7sHFX
	 SIN1ICP7aIlslYtW5vLxqCas7UMP8EtoCyQmCJrhdFKXQaOUcq23/OMVVuBZfFlU21
	 IZh/skIzmfEXGizrl24A+wtA8nEHSBoP6+AvxY8pAZ+CcazFDeX8ja0HeZvXc+jdkZ
	 4Y4oS9P/k1jgtcnLR2M77n7agre7ywoSwRqdPg69VG882ANFUkSjTX5GQkjyG4QOf5
	 63AiWZQLmrPGjYH5uaXcj2dIkecyurc1PWA4DHkQNg+BYZA4HxDwq+9bCuPr3LATwz
	 GLhOuyrcMmswA==
Message-ID: <f4bfb3d6-d69d-4ad2-93d2-34ba1cc424c4@kernel.org>
Date: Mon, 24 Aug 2026 11:52:37 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/2] mm: replace custom ratelimiting logic
To: Pedro Falcato <pfalcato@suse.de>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Brendan Jackman <brendan.jackman@linux.dev>,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260811172156.356053-1-pfalcato@suse.de>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Content-Language: en-US
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20260811172156.356053-1-pfalcato@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: EE0DF40008
X-Stat-Signature: djs464gw8jf9jk8ztisoez7wwnkq6w1d
X-Rspam-User: 
X-HE-Tag: 1787565163-222943
X-HE-Meta: U2FsdGVkX1+FcbKhQdgf7wwCGOocTyGh58xpdEwogL84++zjW4q2XjbJzEMNHTGaqmdVsERIBCXkfQMmUSCwgBejQV6IswEWJPTDD2rns/ZTAJtnBu+4E3/idkYUDnmZdGGZHTdInecgjnUHEF1FQjOHhdGUVmDdflSdolBNB/UtRD3vK+bgoNkdirzXKa8wuxj9uud3Ri6NZGi42d1x3WgGYFW1A2Hg40LrltnAkRMmsneaZYlzpOq1/DRO4ordHFxFXHPMo5c6Wk86MF3IXhw58yWHkB7+EXUVZwgdTb/Zf4fPt43Oba/AHx8H/0vuKrcKklg/ZvsOsyZ0a13HsE+qFyce8NMfryT24UuW2vDGW6tYjH3AlmjdpzjIaNMyZxwZvKK96tG2p5V1oR8+hb2u3jZB9lMKRUk8vqecCGzGUX//YHwLCpCR3jJTFQ1fY8gi81d/6xMF96EYyo1aUTzaVRkh1t2NF1X9QfssZVyUwhvKsCS9CUj2GNyjo0l+ZoGvxBY0tR8vPy1a6qDA2ykzRnMRYkS6PXew71+6wXtalu9wf1tKMQEVyl9nWOGkVsVutJAsP25rFS2YJ6lhCtoxTdU201/kO6cMkRlr6OOtbLdtLlkdgalr92x/fyE1l+Tvq+nSKp8HoUNUJy72Cf9b3H1oFSMt+UA7Ry/7exkXBMP/9Z/vjv/DjsMHiCinlGR0sgcNHZq9IzwctDzGNI7KisIfRgzXMO95NVZhhlsM22GXsz6+CEFx9xovp1H9FUCM9HUUuBZDDkORb9OzoI7kPFI1AYvIbzASPAfW8uMlX0s3J/PbUPiOoquFx/tJvHna8K+GVceRaP4gr6Zmjp8WVV/jkP8Jgw8d4KbainE0tFoMZ3p5mkqPWvfi4yi/jBBmwjk+FuCgDgMJYawUZyXzEpi9Ao0u5MMm1DgRaDKfHphn2XptG30R6WFO/foMKd/E3LjvsX97Fr2yrnA
 ddmGyX3i
 8TUPuAl8F/VqYtp9UR3U0CYH9/xRnXzl2OtGqaoRnhm/XlP7rZpKUlpGZSsXKcEUw5PYsz3Aru6U+hakCW1UI2bz6PBZBoEPyQRQre6nd9lji/r3eCQDfjuty+ALvIdwmRNiLuxxGQ9NYAV95EHS05viJAB4CH4ngQFV2Gb25xr6aRI5hPGvxgHDbBIgEVteRDYilAYvSQXqWoPriSSqZgs/JU86qZ3zRrwpneDlHm/3MIlE0lOBenCyBExdXdqZlrDQFFrroESniF7Q++Fs78sqL5uwAnS8HgK9Ksg7KUDw3UeuIp5P8siJ4fHRQV5S2GYOKpIX7gt+8XEn01BW79EMrRc14St4Gy4yg5eLyI7FZrsJjWjNi/A7SqFevp9kW81utEHGfI7tqinY4JFmTMkQsleQDHJ7AcMNgaeL7PFbtUsNz0gWpJCsL6r9AkGfwn6Ymn+tfuJF4PHldBTuEKcDhZ3Z7drf392ryae7kcCW7GDTeXRgCCzw6CypOpshUlbtvwjk3R056rjjgzG8dLMpFxrAE2WI9RtpwXf5ZpxMFbP8jeu8duGzC+PepazVZbAH/4T0GkRH21kmFB9wPwXaBfx90q0PjptyFHcEdy6QXoEhxY1dpg+1bHQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/11/26 19:21, Pedro Falcato wrote:
> The kernel has a perfectly cromulent and mostly-equivalent variant in
> lib/ratelimit.c that can be used.
> 
> To: Andrew Morton <akpm@linux-foundation.org>
> To: David Hildenbrand <david@kernel.org>
> Cc: Lorenzo Stoakes <ljs@kernel.org>
> Cc: "Liam R. Howlett" <liam@infradead.org>
> Cc: Vlastimil Babka <vbabka@kernel.org>
> Cc: Mike Rapoport <rppt@kernel.org>
> Cc: Suren Baghdasaryan <surenb@google.com>
> Cc: Michal Hocko <mhocko@suse.com>
> Cc: Brendan Jackman <brendan.jackman@linux.dev>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Zi Yan <ziy@nvidia.com>
> Cc: linux-mm@kvack.org
> Cc: linux-kernel@vger.kernel.org
> 
> Pedro Falcato (2):
>   mm: replace custom bad page map ratelimiting logic
>   mm/page_alloc: replace custom bad page ratelimiting logic

Cool!

Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

> 
>  mm/memory.c     | 30 +++---------------------------
>  mm/page_alloc.c | 28 +++++-----------------------
>  2 files changed, 8 insertions(+), 50 deletions(-)
> 


