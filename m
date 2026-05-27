Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 519AACD5BD5
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 13:03:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 867D36B00B3; Wed, 27 May 2026 09:03:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8192C6B00B4; Wed, 27 May 2026 09:03:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 72EDE6B00B5; Wed, 27 May 2026 09:03:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6124B6B00B3
	for <linux-mm@kvack.org>; Wed, 27 May 2026 09:03:53 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0D381405CD
	for <linux-mm@kvack.org>; Wed, 27 May 2026 13:03:53 +0000 (UTC)
X-FDA: 84813217146.30.8EE5C49
Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	by imf06.hostedemail.com (Postfix) with ESMTP id 24F81180016
	for <linux-mm@kvack.org>; Wed, 27 May 2026 13:03:50 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=M9e8XYxE;
	spf=pass (imf06.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779887031;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JzRQ9atpIDul4DCdro+GP47BAZ96ySMQWDM6TJI6jOY=;
	b=aCEx7aD9TSEPeXd9BDsrYi8/wf4qmlzBXcaDmVDUd4wrBy3E2oa5IeorB8yhNZWNvvaBbn
	AQxEY3QkqeNggUVYPuF96O+s/VWhsJxJG/uwP9PyYbYIouh3NcB8KRv1HGRYt4WulQ0Trr
	E1JvvrD+YuNQmiKi8Qt0316ErYEkaPA=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=M9e8XYxE;
	spf=pass (imf06.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779887031; a=rsa-sha256;
	cv=none;
	b=pjDvp+/N8896bWTfudzL5qB4dEnKQX0EuQVIdFYWAzri98Jirfq+HdtYhHIAcjiK93DvLy
	q1HEqptnDThLVqSC/bnS5Sdu6Kllk+L6xR8aAJLFq8BeRpSvwkDvy97av9YQ9XSPK8pHii
	QO4V84AG+nHx+t8eps3It7pWVwbFqW4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779887023;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JzRQ9atpIDul4DCdro+GP47BAZ96ySMQWDM6TJI6jOY=;
	b=M9e8XYxEJR7vKK9og1Edl2s0AdkjYZlrkyUgAxf/mEzX1dBqu8+xAJlqA+VjFx8UAvWsUQ
	lz+x0EK/QFZNTQMq7phe0s15PQUqGrcXcpJO2q//CxCWwLYT9gcJ2PQc6Ie52H4e1vf6cs
	tCFi62D1hnDx7NifVk1PBWPfGsuyJgI=
From: Usama Arif <usama.arif@linux.dev>
To: lirongqing <lirongqing@baidu.com>
Cc: Usama Arif <usama.arif@linux.dev>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Harry Yoo <harry@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Hao Li <hao.li@linux.dev>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH] mm/mempool: use static key for boot-time debug enablement
Date: Wed, 27 May 2026 06:03:36 -0700
Message-ID: <20260527130337.983366-1-usama.arif@linux.dev>
In-Reply-To: <20260527104634.2434-1-lirongqing@baidu.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 24F81180016
X-Stat-Signature: 1kxht9iz4w39g5npa4d5zk8xbh8na7qp
X-HE-Tag: 1779887030-344011
X-HE-Meta: U2FsdGVkX1+Jvs43isOH3m+h2ISTWFRpd7EGGdvJwJ1Aq/lkn1XnYtA6+81ql7yoVdKGsTLWNW1Ysc4IcPCiV2mTkb73a5UOn+ktseQNH0wCysrVmQjo6+HernE1MwGCdcSWAHwBEwiKldMAE+j+fBFwSHT4YZMeLCpRO+adAypNP/2eYTXs5lOPqSzQapctZgOc0r1OJMaAa6utmWjdcev5cFmCaz+H09LPn97Aazbp8jKckO7aVIrITlIlkaoiOP0vagalPu02vzuFPSR38ZITFJMe5kUrk/WiKVu/yj4SrSmMHCDF4kBkCyyy3r6Ysz5jFeID/d2SDkyodNWyBVLozfsQRQU9DanuzHZBIl36XAaO8wVXZ7Sv03Q/eAJeArz+qetAr3xPizHyiFMEJIxewIgVlfVVxs8gBOSJP7hfi3cCwho8E8qrGQhVOtMumjZbuQRoTJxJD3bUo4fBRJlHoYqdBExN0VsvV4I5B1MvOMuk3v/IxHu9nurIxsy5cnpMeVX0KE/CvA/cM6AAuYs3qvZdJM6R0Kw3/ANIGRMYHta3N+gWX/jCpPHGXB6KSvgCJ59Ab8Go7pMxG9tF5f9Eor+B9TDbaoCrtr/YWTlCii/dZf+rCb3+oH5fZOz8/ogbqAmF+8Ovn6kiUT++rLF5u6Wfmgp6O5Pg+b09uzZftrvC68wYCMazzNjp8dmHIo61i8MtWFDYjPvnQxNyTGw6ZKOhGzwG/v4gN+5kpobwyb4uFsTz0F3oexlVaas3fCPCrD63LBKpsmRUkYyFlKlsWl7wryq9YCsGMz16VYzpyeSimSPCLkV7F0zcakcXV7FVkXxsH6OjCRgAwejr2rWICeozMO9eOesioIkUC7Z+Cy2xuS3KgxZbDr7b+ZAAX6Znq2tMu+WUfmmq5nUtTU08ee3j/iMSmsKnQfxVJjKpawHFpLg0+UsUANjIrPqaH6UhQYWg1IFh2fcvilN
 1LN9gUQD
 icI+R6wyq8zlyq48vzZPmI7oxFkZoOTY4Cft0S800dgdm94L69ONYTCEpxukHOyhFtk6OEMese8tna5XtIFrz/fLjk3Fn4KlkGdSwrncuQZl+9QEFKlbdMnrmxTK4ai1jNwJCodTU8HQdKIUIklposoP3zR3DxWSmhPGNUzLFK3Xl5yNiBImK+X9lHg+x/f0ZRNrCYPvrjl5vCWK23ojwPNB4bmQ0gO34Jrpxl8NST7fQb6QRBw0VoonORtdfwinm90k5OZLv/pK4qtgOXAduzRdH2Mvmp1KLup4JkEccuBL9P2elQfkEmRUnIWsksZSuDJFEec2yfii8NNGvF3IdXHrmpM4eYld+zVWpNZq1o0sm6jDNBi8dKrCgBAgE2rDgBVhaiTrt887xqWI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 27 May 2026 06:46:34 -0400 lirongqing <lirongqing@baidu.com> wrote:

> From: Li RongQing <lirongqing@baidu.com>
> 
> Replace the #ifdef CONFIG_SLUB_DEBUG_ON conditional compilation with a
> static key (mempool_debug_enabled). This allows enabling mempool debugging
> at boot time via:
> 
>     mempool_debug
> 
> Instead of requiring CONFIG_SLUB_DEBUG_ON at compile time. Benefits:
> 
> - Debugging can be enabled without rebuilding the kernel
> - Uses standard kernel static_key mechanism with minimal overhead
> 
> Suggested-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> Signed-off-by: Li RongQing <lirongqing@baidu.com>
> Cc: Vlastimil Babka <vbabka@kernel.org>
> Cc: Harry Yoo <harry@kernel.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Hao Li <hao.li@linux.dev>
> Cc: Christoph Lameter <cl@gentwo.org>
> Cc: David Rientjes <rientjes@google.com>
> Cc: Roman Gushchin <roman.gushchin@linux.dev>
> ---
>  Documentation/admin-guide/kernel-parameters.txt |  5 ++++
>  mm/mempool.c                                    | 32 ++++++++++++++++++-------
>  2 files changed, 28 insertions(+), 9 deletions(-)
> 
> diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
> index 35ed9dc..5a070e6 100644
> --- a/Documentation/admin-guide/kernel-parameters.txt
> +++ b/Documentation/admin-guide/kernel-parameters.txt
> @@ -3998,6 +3998,11 @@ Kernel parameters
>  			Note that even when enabled, there are a few cases where
>  			the feature is not effective.
>  
> +	mempool_debug	[MM]
> +			Enable mempool debugging. This enables element
> +			poison checking when freeing elements back to the
> +			pool. Useful for debugging mempool corruption.
> +
>  	memtest=	[KNL,X86,ARM,M68K,PPC,RISCV,EARLY] Enable memtest
>  			Format: <integer>
>  			default : 0 <disable>
> diff --git a/mm/mempool.c b/mm/mempool.c
> index db23e0e..4f429a1 100644
> --- a/mm/mempool.c
> +++ b/mm/mempool.c
> @@ -16,11 +16,28 @@
>  #include <linux/export.h>
>  #include <linux/mempool.h>
>  #include <linux/writeback.h>
> +#include <linux/static_key.h>
> +#include <linux/init.h>
>  #include "slab.h"
>  
>  static DECLARE_FAULT_ATTR(fail_mempool_alloc);
>  static DECLARE_FAULT_ATTR(fail_mempool_alloc_bulk);
>  
> +/*
> + * Debugging support for mempool using static key.
> + *
> + * This allows enabling mempool debug at boot time via:
> + *   mempool_debug
> + */
> +static DEFINE_STATIC_KEY_FALSE(mempool_debug_enabled);
> +
> +static int __init mempool_debug_setup(char *str)
> +{
> +	static_branch_enable(&mempool_debug_enabled);
> +	return 0;
> +}
> +early_param("mempool_debug", mempool_debug_setup);
> +

Can static_branch_enable() in mempool_debug_setup() run before
jump_label_init() has set static_key_initialized?

Looking at start_kernel() in init/main.c:

	setup_arch(&command_line);
	mm_core_init_early();
	/* Static keys and static calls are needed by LSMs */
	jump_label_init();
	...
	/* parameters may set static keys */
	parse_early_param();

This will trigger the warning in include/linux/jump_label.h has:

	#define STATIC_KEY_CHECK_USE(key) WARN(!static_key_initialized, \
	    "%s(): static key '%pS' used before call to jump_label_init()", \
	    __func__, (key))


mm/dmapool.c registers an equivalent debug toggle via __setup()
rather than early_param():

	static int __init dmapool_debug_setup(char *str)
	{
		static_branch_enable(&dmapool_debug_enabled);
		return 1;
	}
	__setup("dmapool_debug", dmapool_debug_setup);

I think you can reuse that.

>  static int __init mempool_faul_inject_init(void)
>  {
>  	int error;
> @@ -37,7 +54,6 @@ static int __init mempool_faul_inject_init(void)
>  }
>  late_initcall(mempool_faul_inject_init);
>  
> -#ifdef CONFIG_SLUB_DEBUG_ON
>  static void poison_error(struct mempool *pool, void *element, size_t size,
>  			 size_t byte)
>  {
> @@ -73,6 +89,9 @@ static void __check_element(struct mempool *pool, void *element, size_t size)
>  
>  static void check_element(struct mempool *pool, void *element)
>  {
> +	if (!static_branch_unlikely(&mempool_debug_enabled))
> +		return;
> +
>  	/* Skip checking: KASAN might save its metadata in the element. */
>  	if (kasan_enabled())
>  		return;
> @@ -112,6 +131,9 @@ static void __poison_element(void *element, size_t size)
>  
>  static void poison_element(struct mempool *pool, void *element)
>  {
> +	if (!static_branch_unlikely(&mempool_debug_enabled))
> +		return;
> +

Before this change, building with CONFIG_SLUB_DEBUG_ON=y compiled in
check_element() and poison_element() unconditionally, so the
poisoning and corruption checks ran on every mempool free/alloc.
After this change those checks are gated on the mempool_debug boot
parameter even when CONFIG_SLUB_DEBUG_ON=y.

Existing users who relied on CONFIG_SLUB_DEBUG_ON=y giving them
mempool poison checking will silently lose it on upgrade unless they
also add "mempool_debug" to the command line.

Would it be worth defaulting the static key to true under
CONFIG_SLUB_DEBUG_ON=y, for example:

	#ifdef CONFIG_SLUB_DEBUG_ON
	static DEFINE_STATIC_KEY_TRUE(mempool_debug_enabled);
	#else
	static DEFINE_STATIC_KEY_FALSE(mempool_debug_enabled);
	#endif

so the previous default behaviour is preserved.


>  	/* Skip poisoning: KASAN might save its metadata in the element. */
>  	if (kasan_enabled())
>  		return;
> @@ -140,14 +162,6 @@ static void poison_element(struct mempool *pool, void *element)
>  #endif
>  	}
>  }
> -#else /* CONFIG_SLUB_DEBUG_ON */
> -static inline void check_element(struct mempool *pool, void *element)
> -{
> -}
> -static inline void poison_element(struct mempool *pool, void *element)
> -{
> -}
> -#endif /* CONFIG_SLUB_DEBUG_ON */
>  
>  static __always_inline bool kasan_poison_element(struct mempool *pool,
>  		void *element)
> -- 
> 2.9.4
> 
> 

