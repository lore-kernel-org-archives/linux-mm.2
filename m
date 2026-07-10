Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2672EC43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 01:58:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 08A116B0088; Thu,  9 Jul 2026 21:58:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 062836B008A; Thu,  9 Jul 2026 21:58:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE10D6B008C; Thu,  9 Jul 2026 21:58:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C9D086B0088
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 21:58:28 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 610181C3419
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 01:58:28 +0000 (UTC)
X-FDA: 84971207496.24.687697F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id CA7151C0002
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 01:58:26 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MGalIMuS;
	spf=pass (imf21.hostedemail.com: domain of pjw@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pjw@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783648706;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=31QGHBL7hL4Fq4DMfqiOa2FOYxi7YJIdv0o6jQ5a0cE=;
	b=e/olGlUdObkihKUR44L/4GWq7jV2qHvF29fc5/kw5j8vUuSrHG6AvB4NP/iqpEr/xInyU6
	JQ1TWzPyti/4zIGmjOJlInGY7btK8RHYHvuTlISMz7ul+8fvz07hxss1wcaL45D3fXI4hl
	7caymieMnuOglRYrbNS45PIg4tpz+y0=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MGalIMuS;
	spf=pass (imf21.hostedemail.com: domain of pjw@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pjw@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783648706;
	b=5aQ6nEKUA/5tw50osMWt5q5stNhvM8q13qNRC6Xqr2k+odpZGJHAnZiYlEhKnX3KxYIDth
	ud/EdD/+krSuAoblmS5ebAevUI9kAardYWT1uJyr/pwn593UPPhTxnZn+7cuWpbNcBmNsF
	LchCoZJVJjkITzzAdQNLNFV+2YP5ncY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id DF53F42CBF;
	Fri, 10 Jul 2026 01:58:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDC281F000E9;
	Fri, 10 Jul 2026 01:58:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783648705;
	bh=31QGHBL7hL4Fq4DMfqiOa2FOYxi7YJIdv0o6jQ5a0cE=;
	h=Date:From:To:cc:Subject:In-Reply-To:References;
	b=MGalIMuSksQjYh3t9v2KG/f3fveZH7k1wlOpxdiQrmVDRZTtwPlcMyaO5qXxQTHo7
	 +yK3DO3g3dkP/103x3fpxGVwvsG0aEUo5o+FfBbjaFsq03/jnJ0SOimJ76IXBL8zjg
	 gP186Lyy7UJQ9xoyIJ6GGR1lBEKONAAn5d+N1Jow/we7QS1mq+9Qee9rGzjgouUqf8
	 +Aqfw0SZrsj02mxky66wvNy2dQQAaOm1zh+QsdwoqO69fsUvzJK8FETbE6o9Xy7bgI
	 F11xwp/iOfKPjg5Qd+PoOeh1VZA5HNR7TXc7XCu3FPfUG18fEDf3cXm4gBFrEdVh12
	 7AcCj1awkMXpQ==
Date: Thu, 9 Jul 2026 19:58:23 -0600 (MDT)
From: Paul Walmsley <pjw@kernel.org>
To: Vivian Wang <wangruikang@iscas.ac.cn>
cc: Alexandre Ghiti <alex@ghiti.fr>, Andrew Morton <akpm@linux-foundation.org>, 
    David Hildenbrand <david@kernel.org>, 
    "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, 
    Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>, 
    Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <pjw@kernel.org>, 
    Suren Baghdasaryan <surenb@google.com>, 
    Vlastimil Babka <vbabka@kernel.org>, linux-kernel@vger.kernel.org, 
    linux-mm@kvack.org, linux-riscv@lists.infradead.org, 
    Muchun Song <muchun.song@linux.dev>
Subject: Re: [PATCH v5] mm/sparse-vmemmap: flush_cache_vmap() after hotplugging
 vmemmap
In-Reply-To: <20260707-mark-after-vmemmap-populate-v5-1-77d1ded3cae3@iscas.ac.cn>
Message-ID: <db0de3be-a6e1-e4c7-6a1f-2f573499a2b7@kernel.org>
References: <20260707-mark-after-vmemmap-populate-v5-1-77d1ded3cae3@iscas.ac.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Stat-Signature: dwr4sjykgzbn3nxcktoyydq3wuri1rxa
X-Rspamd-Queue-Id: CA7151C0002
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1783648706-520986
X-HE-Meta: U2FsdGVkX19xv1ZtSZ3kYM9mgVR0BKEjF7G78fcHdN4XjTtZ8G+4v6QcThYcCkf+tKxSnf+C6WjH86rkg2ZkUD0zdZB8qiW2OJAmo9frHkmrRor/ctSlbZkO6FUwnVvtwPycMS407ipFfNMdx7x3u3lA85Ykbwr/spbFfKYH1QsH5dJOVbEVpsm2b3445IBiLenc6mUUP8PCKFKK4Ga3umY0dAJZbD7R3x0GyZo4Yztj0XU80F+5qb3+paUEqF61GODU7//utwuBeAiWoF/VuK47M6NsYskzFjxcP15VcSR3bMDHBczTYs8Hp6DuC1BS9ILAQ24NErn3rK/37HDZfgBvB8MisSQA/aKSEtQsUOjODUqpswz0aTKvxQht9fJY6IcSWEpwo/zzIHWoWDUGuRvTLU1PKnq45GuzAVF/pHXiYYs5Xx8dSrOaEZwE9NmRza7owuZCTVDfZpjRZ+JuWNUic/Z0dPh6H6h3ZAc7uOBKBWjSqRrUXbhoDQsr3gDwwS67P413cc11edrHvoPAWSCZwhFJjsvOVTSwFOM2U4zMXBNefpW6+By07s4NoEhSoD+RMIGt3vGLctWX92XnmsfhDOTrz3Z4ZiolLxRiBN0fqU7mh8ZZ23fNrV3dsoClo6fwHgm6AthZ+kd0bJ/76v0iSZ5IMT5o3KNtr21Vkv5KOV7EeEGFIgeLmx60iUY8nJdX8jgp6DccC9GZHvCKRrNo7YOswrtfWNIJLieft6oWV03qjLT+HHH560hDvbC5Kd6Kpr9q/sG3F6+pVhLrLSCDQrogFYa9Ly+7el5Y0wW+JAekkjlzsNFDj3EyIhYwF4Xdflt2WXqxuRvxs0HIdwKkHYJuJgrYMxm57LM5IiqSHkm2G3cbWbjUsMfzQ9yyTQPLE9MZyU6u+BaqYaUQL7Na29RCuTKxFc0Ziom8twt2BRR/acHscy6t4pyisPVhFtZyhUbgmI9GFMcrLBA
 HBkMEIQY
 VZ/Efx+ipPm1bjai+zHrRn8m2DAHHw9iG1uUnn6W/eJ0KJfRRpGM6aPZgvS2X1uCpQahpjPKRxtuHT5FwlX4OOGly9NIk+tl+DmaJ6lNcM+7ZcqqIowoWC0sdhgxv/YpLf+O5r2eIBpeHz7BZjTZ/nq2CFOX4LOBBRNvLrVHxgFLg3sNJH1T0fVs+lYtJByN8xs9C669gA3ShnWwDRW1jdM+MawsD+YDf9WPfKg4uPDtxbv8xwK0ea3FcP2MX9J5c2EpZXH5uI9LDGJuQ6icNfl0snnQsDVPhKWKzqyw2k+w4dQQdI9ZBKsJHSrayIP1eENdM/q4rRdp5GjqS93TDuh9NX27s/tPbkxH0PI1aTup5/RkrRbW7YULZ2gS+r8h2ML38ga85KLrdzQzTll9Bqt3RHlud5ZRd706c
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Vivian,

On Tue, 7 Jul 2026, Vivian Wang wrote:

> section_activate() does not flush TLB after populating new vmemmap
> pages. On most architectures, this is okay. However it is a problem on
> RISC-V since there the TLB caching non-present entries is permitted,
> which causes spurious faults on some hardwares.
> 
> This seems to be most easily reproduced with DEBUG_VM=y and
> PAGE_POISONING=y, which causes these newly mapped struct pages to be
> poisoned i.e. written to immediately after mapping.
> 
> Extend the RISC-V flush_cache_vmap() to also handle the vmemmap range,
> and call it after hotplugging vmemmap, which gets the possible spurious
> fault handled in the exception handler.
> 
> At least for now, the only other architecture with both
> SPARSEMEM_VMEMMAP and flush_cache_vmap() is PowerPC, which has a similar
> problem with newly valid PTEs. But there flush_cache_vmap() is just a
> ptesync. So it should be safe to do this for generic code while having
> minimal performance impact.
> 
> Suggested-by: Muchun Song <muchun.song@linux.dev>
> Signed-off-by: Vivian Wang <wangruikang@iscas.ac.cn>
> ---
> Changes in v5:
> - Remove hook, use existing flush_cache_vmap() (Muchun)
> - Link to v4: https://patch.msgid.link/20260630-mark-after-vmemmap-populate-v4-1-febbc15da028@iscas.ac.cn
> 
> Changes in v4:
> - Rebase on v7.2-rc1, drop dependencies
> - (No code changes otherwise)
> - (A concurrency fix for mark_new_valid_map was sent independently)
>   https://lore.kernel.org/linux-riscv/20260629-riscv-mm-new-valid-map-ordering-v1-1-60d8c10c6292@iscas.ac.cn/
> - Link to v3: https://patch.msgid.link/20260605-mark-after-vmemmap-populate-v3-1-a06001ac9264@iscas.ac.cn
> 
> (See v3 link for older changes)
> ---
>  arch/riscv/include/asm/cacheflush.h | 3 ++-
>  arch/riscv/mm/init.c                | 1 +
>  mm/sparse-vmemmap.c                 | 2 ++
>  3 files changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/riscv/include/asm/cacheflush.h b/arch/riscv/include/asm/cacheflush.h
> index 8cfe59483a8f..e935db27f09f 100644
> --- a/arch/riscv/include/asm/cacheflush.h
> +++ b/arch/riscv/include/asm/cacheflush.h
> @@ -56,7 +56,8 @@ static inline void mark_new_valid_map(void)
>  #define flush_cache_vmap flush_cache_vmap
>  static inline void flush_cache_vmap(unsigned long start, unsigned long end)
>  {
> -	if (is_vmalloc_or_module_addr((void *)start))
> +	if (is_vmalloc_or_module_addr((void *)start) ||
> +	    (start >= VMEMMAP_START && end <= VMEMMAP_END))

Is there an off-by-one error here?  VMEMMAP_END is currently set to
VMALLOC_START on RISC-V.

Am assuming you'll update this patch one more time?  At that point I'll 
plan to add it into v7.2-rc, assuming Andrew doesn't object.


- Paul

