Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D31D9CFD313
	for <linux-mm@archiver.kernel.org>; Mon, 24 Nov 2025 12:17:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 12E9D6B000D; Mon, 24 Nov 2025 07:17:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 105D26B0011; Mon, 24 Nov 2025 07:17:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 01C4F6B0022; Mon, 24 Nov 2025 07:17:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E115F6B000D
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 07:17:01 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8164258830
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 12:17:01 +0000 (UTC)
X-FDA: 84145399842.29.FA7A5B2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id E21FF40014
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 12:16:59 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Vk41JS3B;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763986620; a=rsa-sha256;
	cv=none;
	b=Oq3iUI71d9xtLRaGVo9wWoDMx5TQ58fP2mHhso47eNuqVmw13NvxGW9fynOL6E/gmtjTcL
	GSe0f2TW9Hjf1iPPe/T6dBHqUKzqKkqDQa77byZSP1N0kICPh4WBjsk/B1njqsSsLjqgDQ
	6Boboih4S73b058EJttTL9fTaV9YKWU=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Vk41JS3B;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763986620;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1Dm/kFOS1zLSSQWJ1ly/EvdynyoLuunfcJ9L+avtprE=;
	b=w4r2KtDvxYstl2lGhg2BBI1qFxmS5DgmRzdxXmJ6XVFjrKhG/lF1M9sdJ9elsMNhofN67g
	C3BiiFljLZJSMoqUf2JQL+TMKjmmVZMVQlqKX8tL+Zr2UOmydNGqKCf8phGbw2gF/6s6G7
	zfRrlHRPwQLk1HDtI3cELRzBV/UyEzc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B0678443FE;
	Mon, 24 Nov 2025 12:16:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1D65C4CEF1;
	Mon, 24 Nov 2025 12:16:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763986618;
	bh=dZiPM1LFz4RF63yPFs4ZgFUL2y/p+IJlKxTQbSlwnNw=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=Vk41JS3BrTpprUfDmHaAWqzmYN5LKPTP0ikZeODbHurhakhmNlbEtrkZ0/4NlNYP0
	 UtTmKaGui+1CuOO9Fc+Am73Tx5ttc9GQMIb6wyR1JPjbWt37ealpc6i2ZwvIaw4ks+
	 IskBvVXpaM256dD32hbqKvx8NITZs2PAXJMTR7mb5vkI/uqgKG/U1gxBrgPxdnUfWY
	 oO7mpKVWZM7yQDfy+uPkrlkPgixJZnkayC7VHnZFnbGELU65n5c3RLwD30onJxBViW
	 QTYAiULrfLWlPgAr1bGaBxZnLYMQtMQKrcVr3dpsU20tbKxrP0F7uz73WMMygGZ2so
	 /lgH1gnK1nKrw==
From: Pratyush Yadav <pratyush@kernel.org>
To: ranxiaokai627@163.com
Cc: rppt@kernel.org,  akpm@linux-foundation.org,  catalin.marinas@arm.com,
  changyuanl@google.com,  graf@amazon.com,  pasha.tatashin@soleen.com,
  pratyush@kernel.org,  kexec@lists.infradead.org,
  linux-kernel@vger.kernel.org,  linux-mm@kvack.org,
  ran.xiaokai@zte.com.cn
Subject: Re: [PATCH v3] KHO: Fix boot failure due to kmemleak access to
 non-PRESENT pages
In-Reply-To: <20251124025943.94469-1-ranxiaokai627@163.com> (ranxiaokai's
	message of "Mon, 24 Nov 2025 02:59:43 +0000")
References: <20251124025943.94469-1-ranxiaokai627@163.com>
Date: Mon, 24 Nov 2025 13:16:55 +0100
Message-ID: <mafs0see3zkug.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: E21FF40014
X-Stat-Signature: izb5eoom73myujnsq4agpp7p1d6um9qm
X-Rspam-User: 
X-HE-Tag: 1763986619-658648
X-HE-Meta: U2FsdGVkX18Yx76o9XL+/13g6M8cQBBp9HdyK1AmgFhYfkrd9yz8gpXIWlDmfz1NmXl7wDCb6joradsx5JRB1aHcLJIHfApbKRsCgmNku+p3LXywc3ztqj8m7Yc1q0VJeqbzweB8r3rFYRg6lSFYEdq0+jm04FRjF6CFqlJFdaPhn9kKYQJTjv+TUseJV1/mhOMzgrt3AK6aD/CX0EniGgvweABXIlPjoUu2fKnumhwpVmTm24LZCcx/8oHSz/JN+0bGuEZgPNmTID7oTLxUH79efQD58fVHKqdC8ySqPYhU/BdSvrJEZyEmfyCO0XS0CrAULEDFKc2Q8kpr3WWSeBw9mh+/d29gvT2QoH8/YQqQZony9O0jVM0/zCuMFz4oj6Z4b+tfHF5V+Y7goApvJehlJ8g+DubvElU2cY+GuxomIMWA/w9EdBeKk0ryceAxSlRfuns96TKM9U/0k5IICSeFSg79r3YSkRHiD70drjHEV024HR5lLPRoNsD08ao00G5ZCxc09UTsr6n3NsMg58bwQUxjsGPwYSSlqSM1oECyYEhzCRYKbGR0Mb0Zh4+h+zJ/CNOgBbpcqx7o40k8Am1KMQLhuzW9oR8Ow0vKf0ozmM/7yjvO7+O8ZNbbCy5sOT22/xa2KQL8HjpPjDGqNMBJFADMpmDv4AGb/RHy6JeLbQwEvWLsCuRxOYLkDRC2xjMqr+p2ZxePj+rseb4FSVBEfAahAFgt0S6WWkEnHIzuI+ozn3LX1mkNEkDFP+4zoencnwkBmVPBtu9XPhJ9c2ZmmiDNkSyqNDtxeDEqlPnGf8bbjgj4MhBANQv/bIMg6QCIYU9IgX4xG+7IMVtx7EfEVJONZiQUhS62N1+P31q8MHuZqoj5VwbBsxyBG5vXhTVr0DTT4CaJzgmGUWmQ1QX6rmob+8e0lpgY6ARxp8pBggAjhApHFK2e9HZYuU/LPi0bTyBxv2U5cNO3Qjg
 pM9tohUq
 k7Ns+8YT6rEienWczHBPSNDjdVrx2ymuw+HaWLpHikirM9JdHbG+5MHT1TQz+A4arwI0SJuNPPR0YTaM75JFfPod9BwUguMKf7i5xNu37CoLHe1bWsJK9TjFJShyHulHXRtmgK05n7QZVHSmha5KCFQZMTlxLAhw/5YNW0a9Vc0e+G9GPojvbxAnv/DtRIWR7CklpQ1sXehnyjiaP+MJrpn75KsD4yfUc0zlNa7HShjkaTbMrBG0BKp5FZ2EE+3KzC6hHaMeUFy+MDcTAJNWxcghC7w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Nov 24 2025, ranxiaokai627@163.com wrote:

> From: Ran Xiaokai <ran.xiaokai@zte.com.cn>
>
> When booting with debug_pagealloc=on while having:
> CONFIG_KEXEC_HANDOVER_ENABLE_DEFAULT=y
> CONFIG_DEBUG_KMEMLEAK_DEFAULT_OFF=n
> the system fails to boot due to page faults during kmemleak scanning.
>
> This occurs because:
> With debug_pagealloc is enabled, __free_pages() invokes
> debug_pagealloc_unmap_pages(), clearing the _PAGE_PRESENT bit for
> freed pages in the kernel page table.
> KHO scratch areas are allocated from memblock and noted by kmemleak. But
> these areas don't remain reserved but released later to the page allocator
> using init_cma_reserved_pageblock(). This causes subsequent kmemleak scans
> access non-PRESENT pages, leading to fatal page faults.
>
> Mark scratch areas with kmemleak_ignore_phys() after they are allocated
> from memblock to exclude them from kmemleak scanning before they are
> released to buddy allocator to fix this.
>
> Fixes: 3dc92c311498 ("kexec: add Kexec HandOver (KHO) generation helpers")
> Signed-off-by: Ran Xiaokai <ran.xiaokai@zte.com.cn>
> Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> ---
>  kernel/liveupdate/kexec_handover.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
> index 224bdf5becb6..c729d455ee7b 100644
> --- a/kernel/liveupdate/kexec_handover.c
> +++ b/kernel/liveupdate/kexec_handover.c
> @@ -11,6 +11,7 @@
>  
>  #include <linux/cleanup.h>
>  #include <linux/cma.h>
> +#include <linux/kmemleak.h>
>  #include <linux/count_zeros.h>
>  #include <linux/kexec.h>
>  #include <linux/kexec_handover.h>
> @@ -1369,6 +1370,7 @@ static __init int kho_init(void)
>  		unsigned long count = kho_scratch[i].size >> PAGE_SHIFT;
>  		unsigned long pfn;
>  
> +		kmemleak_ignore_phys(kho_scratch[i].addr);

Can you please put the explanation you gave in [0] for why this is not
necessary in KHO boot as a comment here?

After that,

Reviewed-by: Pratyush Yadav <pratyush@kernel.org>

[0] https://lore.kernel.org/all/20251122175735.92578-1-ranxiaokai627@163.com/

>  		for (pfn = base_pfn; pfn < base_pfn + count;
>  		     pfn += pageblock_nr_pages)
>  			init_cma_reserved_pageblock(pfn_to_page(pfn));

-- 
Regards,
Pratyush Yadav

