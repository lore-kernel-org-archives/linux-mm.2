Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4CA2DD0D172
	for <linux-mm@archiver.kernel.org>; Wed,  7 Jan 2026 20:28:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9CA526B0088; Wed,  7 Jan 2026 15:28:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 974C16B0093; Wed,  7 Jan 2026 15:28:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 880FA6B0095; Wed,  7 Jan 2026 15:28:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 74F6C6B0088
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 15:28:31 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 18AEBC1F6C
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 20:28:31 +0000 (UTC)
X-FDA: 84306305622.08.BDB2780
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 7235D40012
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 20:28:29 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=E5IRqCmm;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of kees@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kees@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767817709; a=rsa-sha256;
	cv=none;
	b=2WXmsKgibztKbrsqBvs0siRWfGgCeTskmciEFEgdsqKLQ2BCyviX3UykeOYT48RdO7zNaU
	4JuyD1Jhl9AermOFvJj14y/ejUyOtITFdW2CrGiWbqeLMyyXRJqYP1cMID3cI0buFR9G1K
	Ad0AdXXUjpaySpIQmCBZP8/XDgwKY3Y=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=E5IRqCmm;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of kees@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kees@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767817709;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=E1HLKRJudO06EHz5daCWcSK6ZEDuvgp2UnlllgnfcWY=;
	b=P4PrHv9ZYVTx1/VmfgYQnFdFuUA8TpBgXyJMDRxy8mY8SJl8CaeBPx2TJnM7weACrau+SX
	983ZtZOzxbvFO9Iq7TJqKK+1JXQfXEqlK40LQA/cBdfnpJ8/p6VhK35UZPIASx2pAGSJp4
	ExrlpULRTeUPzx14k9vtTNgUYKwc4K8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 88AE56000A;
	Wed,  7 Jan 2026 20:28:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3867EC4CEF1;
	Wed,  7 Jan 2026 20:28:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767817708;
	bh=H7h/gH0TCzCbiszMKAa3EWkIHJGcdsYIdjeIZkzHok8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=E5IRqCmm+zy5R+XgK8ZDidOJvdt3UHkdCGBAOeL7OnfRhmgaxSFlYefWNz5osV8KR
	 y6vx7e4wmpU3GBzVgqEckzKbW3yQTl7KI1iQ7c4JF4FnZA/OX9EWGoZn49qoXw+0kO
	 IuecKJX3QYQ4gLPWcI+oe+Q3c0F1y9KBvxGpkHGeI19PDbruice6ImZI8UIvQg5VUG
	 DXOvh3n/Adxu9c14RNXnKZ5jrLcqy/w5X4Ewhhqi1Zfmw9BcjNwyF8lcsX9ccMucT9
	 jFKvmYwcApNLjX3WrRzUTE2DyjsK422/mkXgBUPTr7uAkmG37vpP/39W+Qf405NjlK
	 747IyRkjWg8TA==
Date: Wed, 7 Jan 2026 12:28:27 -0800
From: Kees Cook <kees@kernel.org>
To: Maciej =?utf-8?Q?=C5=BBenczykowski?= <maze@google.com>
Cc: Maciej Wieczor-Retman <m.wieczorretman@pm.me>,
	joonki.min@samsung-slsi.corp-partner.google.com,
	Andrew Morton <akpm@google.com>,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>,
	Alexander Potapenko <glider@google.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	Marco Elver <elver@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Uladzislau Rezki <urezki@gmail.com>,
	Danilo Krummrich <dakr@kernel.org>, jiayuan.chen@linux.dev,
	syzbot+997752115a851cb0cf36@syzkaller.appspotmail.com,
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
	kasan-dev@googlegroups.com,
	Kernel hackers <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: Re: KASAN vs realloc
Message-ID: <202601071226.8DF7C63@keescook>
References: <CANP3RGeuRW53vukDy7WDO3FiVgu34-xVJYkfpm08oLO3odYFrA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANP3RGeuRW53vukDy7WDO3FiVgu34-xVJYkfpm08oLO3odYFrA@mail.gmail.com>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 7235D40012
X-Stat-Signature: grhm6qqxqen5e1sgoufx5z7f1fxzitgr
X-Rspam-User: 
X-HE-Tag: 1767817709-995872
X-HE-Meta: U2FsdGVkX19QHtrDXy1C7g/GioNaGjAeyb6ppLk7EGb6ErfcYvTe1XE+0TJu1pR9/8yhpQpRJaLgLBQ1Ih+eWYb3+LZkcbpMvtEBdYATqAh0UmfZdhosU04dcvRnCv7w6vu9tzCWs5gLUtwba63m9FVpWSt7+iUvvrONxyIvOETAhj2vHRE4B5wiqCuTQwHtTLrQtvb++ScMn2DHirq99gsHYpYV6f5W3xsodXMdIHgcHCjrY3B7LK0Aja+IaPj4U33H3gqQjhEJMs8oOs/TbL/QYKfl9upQRMo+cNwhfBSWxUoTq8uKwPU8ll0QBWf7IRGy5IgcAQeX/88qP0obbz1IWGqJ2CRGmEZtd0ee8XurWV1nOw9TdgcUGCQpXVZ3Ku2fuMnnUyC9gvZYEfbaNh/CV/PVJotUoWJv4MIvx3ZL4/5wTAMSyJJ69yE9n2Q63ocNgMXkpaV61zcR2reOtVqWIRCvNJUSpzrHS6FbdsKdHkR6OpSh/SdJueZ8HX/dKwxZZEtvCBqWrsKLlERESoG+rQUU5A8HGpff6n2XogP7h+ieHLF7IUDeuNBZ4A/5lEELUl5KvvYXn4HdhETd6KQvn1GJdReh3RI7FmXG5ucJjMKPhfpKWBU4Qeehkiak5QPA7Mus+GMLkeR1RzoWsibPB7lZH/ZIB0XcelyETveEEkaDHjmy+ARmna/kKYkqXDo3RdDyexJmeIqnXz/khaFIvzmPmP+tXjuO8L1tJTvR+DerfT9V5JK80OPMcoKL6tQBXf0gZmb8X+XZHDnlK8TR4VsNV91rHR3TP9tW54VyT/7JQkQ7/UdY/FWO9B0OaHkQFqmZl8byJirhYldAIsuMOeysUyMDVW2hfrqqOhRZyLfM7AchprHddGK/JGSXa7XtvBc1XkEsrO7EmWybAVgXjzfa/QXCEv8RT4PXDc4gefn3rAmSoRuLanIKZb1diUaOTCWDUqy8kJgo6tI
 t/7uOHUy
 dS9bCWE/dprypwIyH4OIZpyWEg2V4pBPslt2AL/7Pi3UVXhtifBqqdiyeQGfyMi9m6r0WbW9fcZBKZU+5ZkS5F7JDdWr6pAfl0MR9H8Z80wWSv6HmeOEmfUWAKnCn7xaOn/WoIZO43nLfYG5dCXUuspQq2vcgi/47MuEQaUSoGjs8Gfi2CBCi4m8bFyWOMt7EfNUuCfyAzvcuXLEvbgrD7RDC3Mx6ZhyluvK+5KaWKBY6DAoWJ93WwHPCwzlQeYCL+yO1q2up8Mj6PtBDfU8/98ACIMjS+NG/Z94gILee22TRXSfxPYc8KRG+SMsk4LYdh1XLWTN+XdvXgSISu07gzZxFvC9N1YDLXd4nGyZOqj5uKSl9vX1SxhY2RUeI2d+j83O39wVpe6K0X+u/3C7sKVnLK61wDjuJ03Raqs2b/kvKP+E=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jan 06, 2026 at 01:42:45PM +0100, Maciej Żenczykowski wrote:
> We've got internal reports (b/467571011 - from CC'ed Samsung
> developer) that kasan realloc is broken for sizes that are not a
> multiple of the granule.  This appears to be triggered during Android
> bootup by some ebpf program loading operations (a struct is 88 bytes
> in size, which is a multiple of 8, but not 16, which is the granule
> size).
> 
> (this is on 6.18 with
> https://lore.kernel.org/all/38dece0a4074c43e48150d1e242f8242c73bf1a5.1764874575.git.m.wieczorretman@pm.me/
> already included)
> 
> joonki.min@samsung-slsi.corp-partner.google.com summarized it as
> "When newly requested size is not bigger than allocated size and old
> size was not 16 byte aligned, it failed to unpoison extended area."
> 
> and *very* rough comment:
> 
> Right. "size - old_size" is not guaranteed 16-byte alignment in this case.
> 
> I think we may unpoison 16-byte alignment size, but it allowed more
> than requested :(
> 
> I'm not sure that's right approach.
> 
> if (size <= alloced_size) {
> - kasan_unpoison_vmalloc(p + old_size, size - old_size,
> +               kasan_unpoison_vmalloc(p + old_size, round_up(size -
> old_size, KASAN_GRANULE_SIZE),
>       KASAN_VMALLOC_PROT_NORMAL |
>       KASAN_VMALLOC_VM_ALLOC |
>       KASAN_VMALLOC_KEEP_TAG);
> /*
> * No need to zero memory here, as unused memory will have
> * already been zeroed at initial allocation time or during
> * realloc shrink time.
> */
> - vm->requested_size = size;
> +               vm->requested_size = round_up(size, KASAN_GRANULE_SIZE);
> 
> my personal guess is that
> 
> But just above the code you quoted in mm/vmalloc.c I see:
>         if (size <= old_size) {
> ...
>                 kasan_poison_vmalloc(p + size, old_size - size);
> 
> is also likely wrong?? Considering:
> 
> mm/kasan/shadow.c
> 
> void __kasan_poison_vmalloc(const void *start, unsigned long size)
> {
>         if (!is_vmalloc_or_module_addr(start))
>                 return;
> 
>         size = round_up(size, KASAN_GRANULE_SIZE);
>         kasan_poison(start, size, KASAN_VMALLOC_INVALID, false);
> }
> 
> This doesn't look right - if start isn't a multiple of the granule.

I don't think we can ever have the start not be a granule multiple, can
we?

I'm not sure how any of this is supposed to be handled by KASAN, though.
It does seem like a round_up() is missing, though?

-Kees

-- 
Kees Cook

