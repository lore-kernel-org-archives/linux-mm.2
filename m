Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2EC0BC88E75
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 13:59:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 46B106B0093; Tue, 15 Sep 2026 09:59:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 41C0B6B0095; Tue, 15 Sep 2026 09:59:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 357466B0096; Tue, 15 Sep 2026 09:59:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 10EB36B0093
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 09:59:25 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7EDB0A55C0
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 13:59:24 +0000 (UTC)
X-FDA: 85216153848.28.8AC19EF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id E26B48000C
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 13:59:22 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="X/4120la";
	spf=pass (imf30.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789480762;
	b=k/8d7QsMVyp1k8cpk/nmwlFjNHIg9u+wOWKPIOpWJpUxZ4wOyfi+3tK9ZLgLYzwhburepV
	L6O6lVS8bjFQH26gVUYxqnq3vzAwAyFF+byLOtgwGE9LKX/IrZUKf3NeBqovOQDhTYnq8+
	4KV5SU+KrEZzyDJLtr9mxZj57XnDdZ0=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="X/4120la";
	spf=pass (imf30.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789480762;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ebYm8TSC4CYUtZj4Q5hjjIqj2aKy0owa4swW8JAI55c=;
	b=zoTZv0mCVsdCb65CspQhVA0gQ+OMia8yFfmO2+0sMPCL+6K+uq7AydfEHLLJsivxKHatY5
	2xP5hrDKM3QvAndjpFps4QbdmmKB7q/dS+2bnXHG23nOj7xI9lGClodQn7VkT3dbWayhxP
	ufjKLrdu5QXQsY1ouL6esqHjNEonlhI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1EC84600C8;
	Tue, 15 Sep 2026 13:59:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED2161F00899;
	Tue, 15 Sep 2026 13:59:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789480761;
	bh=ebYm8TSC4CYUtZj4Q5hjjIqj2aKy0owa4swW8JAI55c=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=X/4120la222Bs4d30xrI6T2e2igizjI0fR2kIKouHR8SDHTVn82+yUVGlqeN5q3ZT
	 69wf05F9PrURI1xpqdtwsrnbEJiiw6qHYKmnktgZQKMH+D0HTrQnwxWBmtvAZAwBzq
	 5T+ofFUPcF76KMrVEwqVrbqdM41tzXYzPCW0HxPSz95Cp73YYFRT6E2nwW3ICze+S8
	 s8KRWENXyoy/fkDYiltMZv6BL/kq3mYVE9s1CWhofBRj6ikwYdQ13qN+J7HR7T5Ugs
	 O53AH9t8xLoZ4kjUcjbEODdjIaOjVBewOE24Ev9XyL/Hn8gpWQB1Eh1xFPqy3K8Oey
	 WaiSxWw8jjqwg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 7/9] drivers/base/memory: count inherited poisoned
 frames into the block
Reply-To: sashiko-reviews@lists.linux.dev
To: "Ingo Molnar" <mingo@redhat.com>, "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>, "Liam
 R. Howlett" <liam@infradead.org>, "Mike Rapoport" <rppt@kernel.org>, "Danilo
 Krummrich" <dakr@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, "Lorenzo
 Stoakes" <ljs@kernel.org>, "Zi Yan" <ziy@nvidia.com>, "Michal Hocko" <mhocko@suse.com>, "Borislav
 Petkov" <bp@alien8.de>, "David Hildenbrand" <david@kernel.org>, "Brendan
 Jackman" <brendan.jackman@linux.dev>, "Johannes Weiner" <hannes@cmpxchg.org>, "Oscar
 Salvador" <osalvador@suse.de>, kas@kernel.org, "Naoya Horiguchi" <nao.horiguchi@gmail.com>, hannes@cmpxchg.or, "Rafael
 J. Wysocki" <rafael@kernel.org>, "Suren Baghdasaryan" <surenb@google.com>, x86@kernel.org, "Breno
 Leitao" <leitao@debian.org>, "Miaohe Lin" <linmiaohe@huawei.com>, "Ard
 Biesheuvel" <ardb@kernel.org>, "Dave Hansen" <dave.hansen@linux.intel.com>, shakeel.butt@linux.dev, "Vlastimil
 Babka" <vbabka@kernel.org>, "Andrew Morton" <akpm@linux-foundation.org>, "Ilias
 Apalodimas" <ilias.apalodimas@linaro.org>, "Thomas Gleixner" <tglx@kernel.org>
Cc: rmikey@meta.com, linux-efi@vger.kernel.org, kernel-team@meta.com, linux-cxl@vger.kernel.org, linux-kernel@vger.kernel.org, harry@kernel.org, linux-mm@kvack.org, driver-core@lists.linux.dev, riel@surriel.com, kexec@lists.infradead.org
In-Reply-To: <20260915-hwpoison-kho-v5-7-3bc7a57bd503@debian.org>
References: <20260915-hwpoison-kho-v5-0-3bc7a57bd503@debian.org>
 <20260915-hwpoison-kho-v5-7-3bc7a57bd503@debian.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 15 Sep 2026 13:59:19 +0000
Message-Id: <20260915135919.ED2161F00899@smtp.kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: E26B48000C
X-Stat-Signature: kaakrn5gdgnwmsfcwnhbfnhzin1m3gti
X-HE-Tag: 1789480762-888718
X-HE-Meta: U2FsdGVkX1/1YISrgMa8WKdXtlk3nO3AJDUq+qynqPDu9GR3dDG+5YUP3GSb/b1basgBuFcanbU45hkI1h2WfAfaO2oH9qG/t9VOc5qTIR3tpKJs3FNGnYP3U9ONHgh5offPOw2oJRmdSZd5vvgyUNLXN083yja/UPwqUraLrh3sFCUHuyh/YCQCNF/HgZiT2OuOM+jj+wQjbHQyFwhXgIGJIALT2Tfy5uNa17RHLDdfqEy4D5/nc28GAASLXMxtBnL2aChwUn6Ow6PQzEb1SfoBEf/QpJ4AMTUjgpHPaDwPQCSNeqbxYTKUhgbWW906Ic5CRyfBsgxtisoXCB21RxJS216qDY48q5oT7U5WnAE7v/oTylNI+8W+oq1J6/3XLCkN00zrs3D20vK9CZS1vXE8tyH0bhkGS5u+2JlGTuLZcr0VZ/pJuzRLlaBUr75Fk/YWcKH86PqQOZNLo0Je0gvp6LicRjt6z+GZnAv2JhFN8df3LyqwYpwT9gnfX1NM+JsEH9PJBj3Amx/oWGf9M6iXTfoRnhr2FGHzYcghNHvyM0JybzZR+o70Qt5vnu9/zVOzLMTXHdaPzDChheKacXcdM7Ps7uoOvtQqkIGD4rO93qBBVhWreOvN0KetWQjIqPWVBtTohshTn3CP1EF8Pe+Fu958mL6pW8oR1CT1XXeVkjPgBRBkyj9Vhn7VAxMT8K3/+qhKYC20VI99uN40YhRw3m5NH91muB2Fl9iKSStFdgH/M1MPbT3O178EaWX1XzfXzNFjF4VU25i5DIAOH8ocKxIdJ1QcI8ImjjEGpgyPfW4wHbMr4zgjfTa0EmHFcMTnY0unVwEyiFkGnp6tlloRRHccROFlVGqiKGeHU64BruRReUXvqa4lqWV4DiGj4rt3+QskhhRS5OZBknInS9t0PfLBiRqDYOiYVCaHkKPgQyKIfttbA9P0DA8+kNpPiNa8nGpZaHykEiw9KfG
 YTSikP7f
 ajMTnqf8gzk7SL9cxzNwH+XMGPArEVM2zGU8KOoC5WMqFptFbGLIF9IstZJ7wyJgHKHeQ1OUW7XDpwLA15FLYt70TPMq518Xtvz64D4mZpQrx8MYoE2jzRGEJiHWf8WpOCetg4tzHPTZS6baf3FfiQKJJwZP0c5/Um5D+8IrkagpDf/7Kqy6rsMQokGWo234wPkfsx7/h0FlE9UL42cTRXqcA03nqlXEiY630DnU2kn0zjRauf/P2y9fE9LtgV/MoPOHp7vq+9Mr4i2FtYRbNTl8+nyT+obf/fND2VGpj2kWAjSmjeTb55UaL/z4GW3fyVY7ILTgsoWKf9j0PHce4KbOpZGJeW+oNuWdAHu1U/iCEc6gP+1e+Bs/lfWpXVijzn58ndlv8NlnSRON0Y6rS5iHAZN/Vg9wRAfrHI4YcM7/dTWQ9kJEndkZ5OneQO9XLtQ2ML1XxGfw79QGe8qDDHR+0CjlsEfyK9lAkqJcnjfrNe+vuZyq9envhOwBoDbtpi+6hCi9zk5zG4N2Lo+JOVWRW/f1z6pWKXXM2V8izScmRTKWCt5PcLQ0kkG+ar2UB3HK63hPd9BWKvfi87ZlUu2bPIgzhmioNuQ8T8wEsHa8PyLvjzoVfx8i9T8AjFNeZIXvE9YH6hSQZbahkcWAt8jvVUC1dmREL7Akg
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] mm: TOCTOU race in memblk_nr_poison_init() drops early MCE counts
--

commit a8282f47e9b2f9ae014e9948a2edfc336de13cd0
Author: Breno Leitao <leitao@debian.org>

drivers/base/memory: count inherited poisoned frames into the block

This commit initializes the poisoned frame count for memory blocks created
during early boot by scanning for pre-existing poisoned pages. It addresses
an issue where kexec-inherited poisoned frames would later cause a counter
underflow on unpoisoning, preventing the block from being onlined.

> diff --git a/drivers/base/memory.c b/drivers/base/memory.c
> index 5eead3346f1e3..49a33ddbb2e71 100644
> --- a/drivers/base/memory.c
> +++ b/drivers/base/memory.c
[ ... ]
> @@ -807,6 +812,7 @@ static int add_memory_block(unsigned long block_id, i=
nt nid, unsigned long state
>  	mem->state =3D state;
>  	mem->nid =3D nid;
>  	INIT_LIST_HEAD(&mem->group_next);
> +	memblk_nr_poison_init(mem);
> =20
>  #ifndef CONFIG_NUMA
>  	if (state =3D=3D MEM_ONLINE)

[Severity: Medium]
Could this ordering create a Time-Of-Check to Time-Of-Use (TOCTOU) race
during early boot?

If a hardware machine check exception (MCE) occurs concurrently after
memblk_nr_poison_init() runs but before __add_memory_block() publishes the
block via xa_store(), does the memory_failure() worker set the page flag
but drop the block counter increment because memory_block_get() still
returns NULL?

If this concurrent increment is dropped, could a subsequent unpoison
operation underflow mem->nr_hwpoison to ULONG_MAX, permanently breaking
memory_block_online() with -EHWPOISON?

[ ... ]
> @@ -1251,4 +1257,33 @@ static unsigned long memblk_nr_poison(struct memor=
y_block *mem)
>  {
>  	return atomic_long_read(&mem->nr_hwpoison);
>  }
> +
> +/*
> + * Frames a kexec handed over are flagged as they reach the allocator, l=
ong
> + * before this block exists, so memblk_nr_poison_inc() had nowhere to co=
unt
> + * them. Take them from the page flag instead.
> + */
> +static void memblk_nr_poison_init(struct memory_block *mem)
> +{
> +	unsigned long pfn =3D section_nr_to_pfn(mem->start_section_nr);
> +	unsigned long nr_pages =3D PAGES_PER_SECTION * sections_per_block;
> +	unsigned long i, nr_poison =3D 0;
> +
> +	/* A hotplugged block is created before its pages are online. */
> +	if (mem->state !=3D MEM_ONLINE)
> +		return;
> +
> +	if (!range_contains_poisoned_memory(PFN_PHYS(pfn),
> +					    nr_pages << PAGE_SHIFT))
> +		return;

[Severity: Medium]
Does this check unconditionally return false for a fresh early MCE because
the MCE is not in the inherited EFI table?

If so, would this skip the manual walk, leaving the counter entirely
dependent on the concurrent memory_failure() increment that might be
dropped in the race window described in add_memory_block() above?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260915-hwpoison-k=
ho-v5-0-3bc7a57bd503@debian.org?part=3D7

