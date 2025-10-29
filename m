Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3C42FCCF9F0
	for <linux-mm@archiver.kernel.org>; Wed, 29 Oct 2025 14:36:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 825BE8E0074; Wed, 29 Oct 2025 10:36:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7FD778E0045; Wed, 29 Oct 2025 10:36:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 73A658E0074; Wed, 29 Oct 2025 10:36:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 61BE78E0045
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 10:36:40 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1E99B88CD6
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 14:36:40 +0000 (UTC)
X-FDA: 84051402960.06.90845B8
Received: from mail-lj1-f176.google.com (mail-lj1-f176.google.com [209.85.208.176])
	by imf01.hostedemail.com (Postfix) with ESMTP id 0CF234001D
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 14:36:37 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=SONwl1NA;
	spf=pass (imf01.hostedemail.com: domain of ryabinin.a.a@gmail.com designates 209.85.208.176 as permitted sender) smtp.mailfrom=ryabinin.a.a@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761748598;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EMm3nDEHqh0Duo/pCGz7alBh4a7cGfmIeQ4bIaczRPI=;
	b=VW/oRje7kZhfjneJoCkN3WFU/GC2IWTwOrCPLTncX5QOzKieQFMg0X4NontUwMqQqWBlss
	SVFf/uKAmNRZTrDFBO1Yn8DnRijYDQbhXp2UDeYsTXLayI7gvMlP4sw9XSMNsF5Fxm/TY8
	UFAUg8qoa5L3vO8f0zNFpciVpgzuuyc=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=SONwl1NA;
	spf=pass (imf01.hostedemail.com: domain of ryabinin.a.a@gmail.com designates 209.85.208.176 as permitted sender) smtp.mailfrom=ryabinin.a.a@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761748598; a=rsa-sha256;
	cv=none;
	b=2wWkCAOHnhCunf1B4xJjxkTXIKv7YNjoLXdGjd+HHYSQvUDWRsPwoa/8sIRwOVJI+t0/RE
	vS33vzu3OfNvdd1akyRggfAkUm7J365En52VrHUJiFSX9N45bNz08Be/I9AGhR80ZtVw6U
	j19Vt4bjaDktOFor+oNpmR0iG+tu60c=
Received: by mail-lj1-f176.google.com with SMTP id 38308e7fff4ca-3615d93c3d1so7077731fa.1
        for <linux-mm@kvack.org>; Wed, 29 Oct 2025 07:36:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761748596; x=1762353396; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=EMm3nDEHqh0Duo/pCGz7alBh4a7cGfmIeQ4bIaczRPI=;
        b=SONwl1NAgdA7xXToQITSsWqg+fEnFfMCDaNZNZbMaL2KnSc4Yef+a3hjQs+Mri6WOs
         jT+n78DNm3dVgB7aPYCIIUD2tY5/1ULDENeXoDDWcZmrK07PY1RzU1m8LpCitqlbJfbp
         SbJ79V6RAZRWTCnT4P60uSTdoVfuR/7w3CxbU6m64ASULEehoHXaCDp7JzjPGgXYkQtC
         Iih6GcIkiLYsvOk1tuHdL/nizh/eyA40wbn1IZMyNYXO2bUJD5s6hFJtAqs/GdIUUHm2
         bSOsS+oKc1Ob43MLc5SBhfcpN7mAruV+ySU+xddFDNVl/fXODusSEqUNeMmWCm6s+OgS
         kJgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761748596; x=1762353396;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EMm3nDEHqh0Duo/pCGz7alBh4a7cGfmIeQ4bIaczRPI=;
        b=TGYoJK6h9Z5RIftrnUK4dCEsMhPKjO3Hy8NgkgqIEH3DIWnSoXbJkpNfToWGEbRpNP
         actP7S6GUgDXLOLQeyVEDhvx31FjhRWVMIpGdI1H9+MuEvYlQYNjigzZRokb+CLPkpt9
         4AMvWkyh6MpAGJ9uqkSENAFg4S0i+nuRSRsB+mFqvePI1cuiYOhvGkAG+9RPJxEr8XTx
         W0WAvr88JnaMJKYZzDOOD5dGbWJuWQJ5vN5UdB1qWrjzjn4mE7UkXzPOB+OOWoB/X5wk
         cx7NfwcbngEcVOi3vzR/0jkwrsTRtDigNJFInaW5dLTD6YTzeEoZJzwdHZH5bwM+tFbk
         pUpA==
X-Forwarded-Encrypted: i=1; AJvYcCUajr8Dr6xZkFqlPxLNOqAVwwJ1yvfkWful/qGr7NzBlgVOdptqRsL1jHKNBS1gPkEId+wSi2LPIQ==@kvack.org
X-Gm-Message-State: AOJu0YyK1ajimdkf96RId0kOlP1ORq22dg7ARRAwxU6cJEsY5T+cpWUn
	1DsySzPEkqnws4QOuKA874Di5jD1YpSZGAYqw0g1LZlLiHytGDwgwcZH
X-Gm-Gg: ASbGnctlk8N312pELpTi05Nbp/BaILItdkGUlSy75jQms1wvRCy8tUQSaqUyJs1sNB3
	uhlw0hRsaDh4IKvH10K5xDi+P6L/9YNU+fM/K+n2wNb0Is299NE3ZOMwmjGmhJCelx/KeUw15ks
	32OZOk7NsdRPvYFWfTSHGyA9nM5dH5su2MJtxZhjwjdfpJ9ffVyX0mJMcvWqUGiwffqaZ8RB9xS
	ry4y+ixz8DVIctRsfYLUngRLHRudT/9o/Vg7u9tGsn9+yDsHLJ8roP3/1P3Ttl2RHi0uGD/5uNw
	AaAI29InWrs+HMKJEi0hza+1RgAsFKcFXkxeoSbCbIetzFTASZqC5fsJcNnw5NXYWc+3o9FEHKO
	4KhISvFHWQWmCZbTUXJ7t1IFnc7gd/vVk2lsvsvX+ykryPwXMY0N+XSasVZW+3UVvYGJoRcbciC
	h9w8MIjl9D3JZmplQB
X-Google-Smtp-Source: AGHT+IFLiz5xmWOhoWEAxRsXVnqSuOwatKraLudgPyAUhj3vj9LKZLHRoICq06za6lOxdckgCWiUCg==
X-Received: by 2002:a05:6512:3f0e:b0:57d:720:9eb0 with SMTP id 2adb3069b0e04-594128e00b4mr758281e87.10.1761748595850;
        Wed, 29 Oct 2025 07:36:35 -0700 (PDT)
Received: from [10.214.35.248] ([80.93.240.68])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-59301f700fbsm3962183e87.81.2025.10.29.07.36.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Oct 2025 07:36:35 -0700 (PDT)
Message-ID: <1bc9a01a-24b3-40a0-838c-9337151e55c5@gmail.com>
Date: Wed, 29 Oct 2025 15:36:28 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V2] mm/slab: ensure all metadata in slab object are
 word-aligned
To: Harry Yoo <harry.yoo@oracle.com>, Vlastimil Babka <vbabka@suse.cz>
Cc: David Rientjes <rientjes@google.com>,
 Alexander Potapenko <glider@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>,
 Vincenzo Frascino <vincenzo.frascino@arm.com>,
 Feng Tang <feng.79.tang@gmail.com>, Christoph Lameter <cl@gentwo.org>,
 Dmitry Vyukov <dvyukov@google.com>, Andrey Konovalov <andreyknvl@gmail.com>,
 linux-mm@kvack.org, Pedro Falcato <pfalcato@suse.de>,
 linux-kernel@vger.kernel.org, kasan-dev@googlegroups.com,
 stable@vger.kernel.org
References: <20251027120028.228375-1-harry.yoo@oracle.com>
Content-Language: en-US
From: Andrey Ryabinin <ryabinin.a.a@gmail.com>
In-Reply-To: <20251027120028.228375-1-harry.yoo@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 0CF234001D
X-Stat-Signature: cjdrw7tf6qxnie1esiq5ny1yohhqmg4u
X-Rspam-User: 
X-HE-Tag: 1761748597-19251
X-HE-Meta: U2FsdGVkX19WWRZpqhjbFNn39+QddUMV0oDAjLPeLjbhJ/FjoWPgz+N/gN+Zfget8rO6hcOpWbQuc0NVL5WgKQ4V6tHK6GNefeksGrqu5Hl/9WaCPRtg09lTxIKdYvSMbrg1Kx/PuRxxiLIOFWyPrPbScO5FZqG01UyTwx25mY+wExEsYJD62VNviOxjX20Qud5xSGUwlMJoLhZqfu5jB4aEgvst07Xgd7SeTewts6GmiVjLzifnfK/FKv5bmhSQGzFvdsV/N5/8I4YFeYtDKPzvAFjQ8oCHa9vTKBBehn6Zi17h4XC+5qeySzEuXYkhpvYU19ZtI+/Od/UXYKXEOz0ruqWMqGJ9DbgFKgWz1W4KpvX14Qwk8vntPcsRGidV+KIUE4EdlJqwqJtmTFe1GPpjSQvvZF+yYCwk/pxKmtq4KwhTYZxG/f+L6kCDoukOTI7U6MJBRKxuZGXWOrr8TrUYYMcSGEEi0rbGGij7HOXhzEkAMqHXXxeRUEssSOMsaOjiCatuPvE2WviR2m0SK93JWec+JJf7Vdd8wdtU7kCvAJSajmHAKHP9bMTPublu9lZiQEDKkCHpNV5+R2WE4/Hyu9mriDfoWHZ8DQkDtk4FAOqzA0GgA66SM2XZ1D5WmxHKAgFlCPQeQsb24crP0dIsRyfz3EoiVqQOPsgRZBFv3UxqyPYHv4lf7XejJkO7qg1lbNLB/mcQl36sLeeFt6ZYlzzRsFpNSePhPIKr2q9OOM+/t3LNu7i9qWqzuvlN466FTHbiebHez+S0xWu/6tHNM8A2ixVB1yNlWO2ksoVO5gv/rJYAdcEhUajDlPHpWrLn5rPBVEL/bpkghGcL9WujnliuT4k7HiYHwmdHdgCiZyKMumcP7y8TnwJ/hK/j2LkSN7OgCqGo7s5mSYIG+JxBMW0w+p7MdlUioqDm2hwMcj9Uo/Gx3B3Y1OJIVucu6RANXfwBtiBfu5S9eZc
 /reJSzAd
 wtorAuQCWlSnavnSfowY5feOyAayhz5plyZVj2PlIgBwoyxbQeysOK9rQIWBuGz/37uv4Y/M6HBCuZ/ODc70V8HEU64jutvzesArgaQMwB4+CQNxqkPQ+NnmHsttdNb0FQeaEMGj/cy/XHDvbnJezOATbrEIQpb6/TjiO7QnepXeBzJlufN+StrMNNAMnFQIkpYrYTSPAcdlpWtpWXd+s5hOJJbMC2QgDeV1RRsXb8G2tqeIcnrUeIE0Ir7pzGHdSWyp2VvZK/07+Z/bLH27sGHuWy9B32V7Dxu1nFE5JEEkQK+K6jUIprZHc3J94rxC8LWER7UhPvHr6//MIJGsIMEPwFpSEI6xyhd79wXSXSwVRrGK3iknz8uuEQjrSvyjkrGjKv2BOHMY4t0+P+yV3tuzn5ZipUaUm2YACVNuwMaP+OobkLa+4t2fWRynJRhNX8kbl6z90tV7NsIa1SPuGS0h2d3yJ0zLUKxW6fQDbXHNNrLWa90li+T74zCv0zMgovSmtqAJniaIKESvZSfNEi2Ca2a2KHk//JOrH
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 10/27/25 1:00 PM, Harry Yoo wrote:
> When the SLAB_STORE_USER debug flag is used, any metadata placed after
> the original kmalloc request size (orig_size) is not properly aligned
> on 64-bit architectures because its type is unsigned int. When both KASAN
> and SLAB_STORE_USER are enabled, kasan_alloc_meta is misaligned.
> 

kasan_alloc_meta is properly aligned. It consists of 4 32-bit words,
so the proper alignment is 32bit regardless of architecture bitness.

kasan_free_meta however requires 'unsigned long' alignment
and could be misaligned if placed at 32-bit boundary on 64-bit arch

> Note that 64-bit architectures without HAVE_EFFICIENT_UNALIGNED_ACCESS
> are assumed to require 64-bit accesses to be 64-bit aligned.
> See HAVE_64BIT_ALIGNED_ACCESS and commit adab66b71abf ("Revert:
> "ring-buffer: Remove HAVE_64BIT_ALIGNED_ACCESS"") for more details.
> 
> Because not all architectures support unaligned memory accesses,
> ensure that all metadata (track, orig_size, kasan_{alloc,free}_meta)
> in a slab object are word-aligned. struct track, kasan_{alloc,free}_meta
> are aligned by adding __aligned(__alignof__(unsigned long)).
> 

__aligned() attribute ensures nothing. It tells compiler what alignment to expect
and affects compiler controlled placement of struct in memory (e.g. stack/.bss/.data)
But it can't enforce placement in dynamic memory.

Also for struct kasan_free_meta, struct track alignof(unsigned long) already dictated
by C standard, so adding this __aligned() have zero effect.
And there is no reason to increase alignment requirement for kasan_alloc_meta struct.

> For orig_size, use ALIGN(sizeof(unsigned int), sizeof(unsigned long)) to
> make clear that its size remains unsigned int but it must be aligned to
> a word boundary. On 64-bit architectures, this reserves 8 bytes for
> orig_size, which is acceptable since kmalloc's original request size
> tracking is intended for debugging rather than production use.
I would suggest to use 'unsigned long' for orig_size. It changes nothing for 32-bit,
and it shouldn't increase memory usage for 64-bit since we currently wasting it anyway
to align next object to ARCH_KMALLOC_MINALIGN.

