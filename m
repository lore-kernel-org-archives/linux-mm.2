Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BC99CC5B56A
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 19:47:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9F41A6B007B; Tue, 11 Aug 2026 15:47:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9CB656B008A; Tue, 11 Aug 2026 15:47:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E1126B0092; Tue, 11 Aug 2026 15:47:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 64DDE6B007B
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 15:47:14 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id ECC431A01FD
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 19:47:13 +0000 (UTC)
X-FDA: 85090022346.09.B6DA5B1
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	by imf16.hostedemail.com (Postfix) with ESMTP id 8611918000F
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 19:47:11 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=alien8.de header.s=alien8 header.b=lEWLx2DJ;
	dmarc=pass (policy=none) header.from=alien8.de;
	spf=pass (imf16.hostedemail.com: domain of bp@alien8.de designates 65.109.113.108 as permitted sender) smtp.mailfrom=bp@alien8.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786477632;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BlXSLUlIACbCo1CYAl6qQKtQGar/xLkA/Fwfj1CIbk0=;
	b=CRArAhPfK3zDDGVGz+Ahxqb4E7alfbv9JjUFg/DbzqnIcakUJ9JnM1UCvCNCLRMgRE4P0E
	7MjdaifUpk7KjMwgLrw2RbLd63Y6mj/d/HyN1GZedEy7VJLKxoHE+h14FhRerq0x1sU9r3
	23IHpLEoHd7eLEnFdQm64NPJwEZAZWg=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=alien8.de header.s=alien8 header.b=lEWLx2DJ;
	dmarc=pass (policy=none) header.from=alien8.de;
	spf=pass (imf16.hostedemail.com: domain of bp@alien8.de designates 65.109.113.108 as permitted sender) smtp.mailfrom=bp@alien8.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786477632;
	b=yqrW93tT2f0W/VvpUTj4P0FQK1LAKgJcam9i+zX/Jgb4yNmi2Yppp64d1pAnE3olCbl1xx
	MIqAXw48kWgKgZ8rH/G57DDrpNivl4ueSExTpwic1TtPa9Hk4Wsa2GlGyMmvy+dq+JtSYG
	Y7j1np3NfyeJYjl1cktYrBqpG1enGXU=
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 06C9740E019C;
	Tue, 11 Aug 2026 19:47:07 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id faVIp7MZ5ZKS; Tue, 11 Aug 2026 19:46:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1786477615; bh=BlXSLUlIACbCo1CYAl6qQKtQGar/xLkA/Fwfj1CIbk0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=lEWLx2DJlfcAE+5czMjnyrf2q0Awz3QSjJak0ELLkESNmzfDXZeAL5PjYk+p9cWfH
	 oCfFz9JjsFiDrzBKGbjUkPpqSUZubOPIjb9nsLxUm8uVB/h+z/QHKjuSnNwz4jb0MM
	 tDmJNncyp8c1TZJgw569dgnGERXhq2gFFmX9fLMWhOQ9i4D2jxDmSWkiJIKMzu3OBc
	 /cttvTz4+FIAW/4d8x3b54YWoNE5Bn9asJE0JKcsP4bkkGfLAvjiN3mlXPv82DMVQo
	 aRQUMNM5sRjPbzvdICyXdYVqyUg9FhnRW4veaqXAxj+tiLrWZUQVVMxuiiKAVajPSQ
	 /2DLkSiqAfHNcJRbmYIm55GTg4phm/9H+XMvyxOYoLbpabte9F+gGqqqwuj0GpV/3Y
	 +8jW/BNyqci/op26P4gB6kiN48jXY0WkpLgvvX+E2lbFrbaIHkiMJ6/fCAu1yfpwaz
	 21uL+B563QVnJ0la3I5WiEVbB7C+zKx4nYu7fYxkB4SWtIm6eIWAsgyKfwjrzY+u7d
	 C8gkGKPDNI8btG3UVcWGNvlFPhDkY5ZjemmQFEWlXF/Py1lhDQfZVPvIvOi0WIFZdD
	 vNzuJtdOBfQZhW8fym4rlPJu90+aZIFHJFwSi/0BytlPM17V9lGLUQKQ0wiKSWL0DL
	 Dna5N1+0oKeXM8XRb0JhYfQc=
Received: from stx.tnic (unknown [IPv6:2600:1700:38ca:c00::1b])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 3CAB540E00E6;
	Tue, 11 Aug 2026 19:46:38 +0000 (UTC)
Date: Tue, 11 Aug 2026 12:46:34 -0700
From: Borislav Petkov <bp@alien8.de>
To: Li Zhe <lizhe.67@bytedance.com>
Cc: akpm@linux-foundation.org, apopple@nvidia.com, arnd@arndb.de,
	balbirs@nvidia.com, dave.hansen@linux.intel.com, david@kernel.org,
	kees@kernel.org, mingo@redhat.com, muchun.song@linux.dev,
	rppt@kernel.org, tglx@kernel.org, linux-arch@vger.kernel.org,
	linux-hardening@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, x86@kernel.org
Subject: Re: [PATCH v10 8/8] x86/string: extend memcpy_flushcache()
 fixed-size fastpaths
Message-ID: <20260811194634.GBant8GqpdMeXP5GsO@fat_crate.local>
References: <20260810122057.30447-1-lizhe.67@bytedance.com>
 <20260810122057.30447-9-lizhe.67@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260810122057.30447-9-lizhe.67@bytedance.com>
X-Stat-Signature: 76jm5mimbpff4oqxfffcw6g3jkn41wh9
X-Rspamd-Queue-Id: 8611918000F
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1786477631-965757
X-HE-Meta: U2FsdGVkX1/OeUVqGDn1J1fR+bZDQH0jblj02fTrWlh4H+SkDwfjJsjkxr7dK62J1gQxm+CwiTGdGZZpSzmTYwijQDGyxyJtSxliCIYQ9ysk0DwEsgeRmSpLOYrB2Mq/KRBsC9wk+hBY2hg4L0gI0ZT84PO7Q3SHtbl6MfyFMXb3GB+6TLQPh68vQa+4/FnDEIUCLaufJ0pDD3UKGi4XZ0t2bSizFHY4C9HFoY2izrSFeUauQ36CCzkMv5BkAlZFYf41vKzDWRjKe9UsJDvNPj2cd7F0QCPh/mwenQuHNGp+Bmu9WlTnQRJW33MjqMXh08/vuvUEE38jM52hT/F7m9p8rqB0zjmVtQyMqVfDrGGCHIf/dH4QLbAe9hxYqLjT7qc6Jeimsy2BHSCtb8cYGjmjJ6HM/c4PfYBM2wSUL4coDFteE6kn68xH9DIqrdkkQaEct6cbt9VFEI/ugMKVi90sP9pU6PyFQ+KeK2HUJlLvHF4utb+Ex0relX1Tw/tRXs9G6ak4APZetXZ6cSVnbdpBzjwwrj7Obs4OdvBIocZhG6hg/JBJ3GoR8Fjmjc9eVh0hmM6/uNmu/d0hb9LKKAKpHij/H8wTJ7dTmitQLla/nJr4XERz89Jx7yM7hUSYcawzMTPBlGX/uvyXoYuEgh7JcZZ/UvUjjwDwBlVqqOdx4QWWpvZOWnKzsjS1ma10BRfuGY+E7/2qbr/ITMaDdIWcLJ+npeO0Z4bVQJsVG6oXgsCxPw8rUxCqQiXVuazrWZqThfEBK3E6o4bVdwWVtfEsjLHnyGjtn1IkyHdiDvihS6lGcWaV/92WAZAiNGLHKH1JwjjtB7w9GBQYGa/+wUiKIpZ0DcR95w7uauzT7XUbhNAQMmdV72yK/8rV9Q4m8k2XTSkjwgIKtP1wPUGR7IUCE/1qd4zRbbcz76Ql+bgi2tVZ/UQDRyYfDBy3t6aY2uQif3TjrnLCVF0nSv4
 7T91+1ID
 M8Ft35nox8EvPdNa2zek9SPx36QDocZR+UZn6tZFOQ9WFLAxo84sO/M9LZ5EHNV49VDldrxMU9QAcXwVuGRo3lan2I8DdzZpohJLrZfK0kUIwsFJLKu4s96tVoYPHtXW0xAhsrd3ePJQ9CkKgay9vZddb9g0cLrLOj1ogQtru07f06ipL1tmO/WYZqo2UpP1kaKiFAV1S+IC4hkNCUGU+9h0+z+inSHdp4y56Ijo90/ONYzXl3UfpdAHq5vjF8m0EF4cx00VRcM4UFa7E2BtdpIAi0EYHgkLlY66VZhLgOMoau0SKNXn5qC3zoq7NFZyMIgzHZ7UCKN5hNkEYAPsEO3bN7h+/o3dQQLh/zGcQLzmsS2okXqxjgOi99w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 10, 2026 at 08:20:57PM +0800, Li Zhe wrote:
> The x86 memcpy_nontemporal() helper maps to memcpy_flushcache(), and the
> ZONE_DEVICE template-copy path uses it to copy one struct page at a
> time.
> 
> The relevant copy size is sizeof(struct page). On x86_64, the base struct
> page layout is 64 bytes. Adding either the KMSAN metadata pointers or an
> out-of-flags last_cpupid field can make it 80 bytes after alignment, and
> enabling both can make it 96 bytes.
> 
> memcpy_flushcache() currently only has inline fixed-size cases for 4, 8,
> and 16 bytes. As a result, these constant-sized struct page copies fall
> through to __memcpy_flushcache() even though the compiler knows the copy
> size at the call site.
> 
> Add fixed-size MOVNTI cases up to 96 bytes so the ZONE_DEVICE
> template-copy path can keep these struct page copies in the inline
> memcpy_flushcache() path.
> 
> This matters for ZONE_DEVICE memmap initialization because the copy
> happens once per initialized struct page. For a 100 GB fsdax namespace
> with map=dev, this is about 25 million struct page copies during nd_pmem
> binding or rebinding.
> 
> Tested in a VM with a 100 GB fsdax namespace device configured with
> map=dev and a 100 GB devdax namespace (align=2097152) on Intel Ice Lake
> server.
> 
> Test procedure:
> Rebind the nd_pmem and dax_pmem drivers 30 times and collect the memmap
> initialization time from the pr_debug() output of
> memmap_init_zone_device().
> 
> With memcpy_nontemporal() used by the ZONE_DEVICE template-copy path:
>   Average of rebinds for nd_pmem driver: 150.83 ms
>   Average of rebinds for dax_pmem driver: 153.55 ms
> 
> With this x86 fixed-size fastpath patch applied:
>   Average of rebinds for nd_pmem driver: 96.79 ms
>   Average of rebinds for dax_pmem driver: 119.04 ms
> 
> This further reduces the average memmap initialization time measured
> during rebind by about 35.8% for nd_pmem and 22.5% for dax_pmem.
> 
> Suggested-by: Borislav Petkov <bp@alien8.de>
> Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
> ---
>  arch/x86/include/asm/string_64.h | 71 +++++++++++++++++++++++++-------
>  1 file changed, 56 insertions(+), 15 deletions(-)

Acked-by: Borislav Petkov (AMD) <bp@alien8.de>

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

