Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 13519C44506
	for <linux-mm@archiver.kernel.org>; Wed, 21 Jan 2026 17:26:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 636036B00D3; Wed, 21 Jan 2026 12:26:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B9956B00D4; Wed, 21 Jan 2026 12:26:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4C5116B00D5; Wed, 21 Jan 2026 12:26:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3D4956B00D3
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 12:26:25 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D07EAD381C
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 17:26:24 +0000 (UTC)
X-FDA: 84356649888.16.09AFAAB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 427A580007
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 17:26:23 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Nw9NAeAd;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769016383;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=62VOSp1+bOdyw4Ey9gDf5/3EdQgHuQ85o/OWTyOpOjw=;
	b=O9yEO5Tmgbn3WRTAaIlIh3h6Uon647Mh6VNQo5YkQ5QPBSoIxzuhpudlFiypWQqF2mGPpu
	thEAZ3D5oF2UTSEJkIFrR+pV+FNFGeyy0gzuc0Of7iwsnSGnalbRn6eJAjTXukcBmqDAgb
	wYg0u/ck0L2GBdmH6rYdBhALKbpSRfA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769016383; a=rsa-sha256;
	cv=none;
	b=a6AW3J1EHcS96zZAzFjqQgTjUE276ls0akU+ijD3u2tQ/mQESQhLHQodBAJ1GwfIgZt+QE
	hC0ImOxFAE3BAkNEJsLte7GLPt6132nPlxtGhwmCB0sVnuJwcdMM25XUW1O8JD8nHGBs6v
	wadO8Nx+ifmqnPtX9iuPacA4PUDLsos=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Nw9NAeAd;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 513B6600CB;
	Wed, 21 Jan 2026 17:26:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90B65C4CEF1;
	Wed, 21 Jan 2026 17:26:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769016382;
	bh=H2cZyOrU5YaqFRoEWy15WU0X17vWC6wsd1JZ58PmZ0U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Nw9NAeAd2EREUfgIqRkY1OK+LynggE+5VrpuaSFH+0FLUq8/tgJfAV4avkYWL/LKr
	 STN7AVVGJmR/i5ZPxio82Lw8a4gZjCTWd3x6xd+k5/NdQoBN/H2JzVarm0axJj3aiw
	 9F7Y0cX4SagCNN6ZsqmjpoTn2CNVUVy/Zf0908tkrIdkDiqRcp2n1qSmDlJ0RQTI8g
	 u5lCxgf/W3vbGl/5JBDibE8t1IFy0Rj16iZV4/XQZuavtljrI+N7xt0iQYZZR8ofuG
	 GwdX6Tj6th9jhcAcpP4xK7zybBqblc5gSliR7Du/4lt4Vv4B8QGXnBkvCwzq5dfAeU
	 0kjd1AjGSYaNA==
From: SeongJae Park <sj@kernel.org>
To: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Suren Baghdasaryan <surenb@google.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Pedro Falcato <pfalcato@suse.de>,
	David Hildenbrand <david@redhat.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Michal Hocko <mhocko@suse.com>,
	Jann Horn <jannh@google.com>,
	shikemeng@huaweicloud.com,
	kasong@tencent.com,
	nphamcs@gmail.com,
	bhe@redhat.com,
	baohua@kernel.org,
	chrisl@kernel.org,
	Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH v3 01/11] mm: Relocate the page table ceiling and floor definitions
Date: Wed, 21 Jan 2026 09:26:17 -0800
Message-ID: <20260121172618.39532-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260121164946.2093480-2-Liam.Howlett@oracle.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 427A580007
X-Stat-Signature: 6f7sbchb3ijrm5u9jnsu4bx459jkaids
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1769016383-966752
X-HE-Meta: U2FsdGVkX1+t3jWV6F5DjC23hJG5S8YTlnViS/ctKt3L2krw/qTqI5HRnfjkhfzyPeZ/jK81/jtJsG7/4y0yFILdxSb9e8apPKNr1MkASq0dVkP2LW5lU1/xX3d1NkWMMsagY/w3++jLvRxhnCP8/soF/bZ4gZ7Zst86SvqOYJEkDSHx6nXFwEM4FOW0Fmsl3ElynGkoQ9sGyFRHBzvD1M8PZnmSSmkYO8EzS91Aky773wfeWzkgQD2Qt07dklMjJrx05Fp9jCNuQOibr9tiUPpSvGCDMDJH/On6OzxjR6tTTGOffe/jQCGVCYaiRNq+vROZJ84YTZzY1oGmq+StJ50a+ovDr8UyUcnr23+l+ZpwRpSdSUOXW+pG/gTqKM5d9MMLqwM3WKD3zEqHVyZGxrQzSl25wMh8BBwxpFUacuWN020oUWlF6EZtbZySBlQb5PJhKAIe0IiOUbpzoWHbYMYxKaB6XqlutxqlJElw7bwmv9W2+gYpJgLwvsUlHGGxtwlSIgUNG+sp/x+Cc5//IvTyvjejAVwZpHDleuuqhUYBK2WkuGC1acIh9YfJzjJWaZTTPM2Y4TAHFbVODON3q9HSKoLTG0MiveSe35r1U2AcTuoiii/yhsVoZfZnoOZtEyo+A5nOcmDdKjRbbTPuhEeeOdcM95ZmKmIxQ/EVE60MqRPGkgZU+WlNUC5JCX6A3cFLFpOJzX4kSU6YSHFGxgX8y3gGmJ4a4lIiv5g3YesujKUeN61n74T+k4gBF2fhinUAF1j6lHIs1ZtWxHdC7DMEwPgY3hCKWbf5fRLXSWsjMe/rG7gowNNfVoNQbsoSLc/s1jiMx/06isEV+ixX+jST8DNjThNDj+AMvZFvujmjpaRs4PTkkGfs1jXBsTdcwYqn871dI0iGsvKPT8HFusvkPabMHz8iqmuDpqemWa29a/PCiYIexhQX1iBXZh0nCCY0Dy4RIbidLGt6+lY
 StwOytr3
 rrGsRBoSFuKpB3nvIIhRaOykgozvZ/U+XYsDxYw3vZDTaXcBVDSZoZdu+DrHBxs5dfQZlpcxJccL3CnAg4jMyM7nLqCv+inRPBSGrrFW/I1/g+Xhyke/cfSweOyaxJnU/UWvDsegPgIu9JKLy+K+tnpHaenYLHoLQDGNcqQjM0R2gKPDEub89sXiGEVc0vn2sPa07fiUamHCjXgzOtZ9f5MnplERjBWDLqaL7EUMft6TZc86ouORt+Xk6Jk8vDhX6AgDl
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 21 Jan 2026 11:49:36 -0500 "Liam R. Howlett" <Liam.Howlett@oracle.com> wrote:

> pgtables.h defines a fallback for ceiling and floor of the page tables
> within the CONFIG_MMU section.  Moving the definitions to outside the
> CONFIG_MMU Allows for using them in generic code.
> 
> Suggested-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Suggested-by: SeongJae Park <sj@kernel.org>
> Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
> ---
>  include/linux/pgtable.h | 39 ++++++++++++++++++++-------------------
>  mm/vma_internal.h       |  1 +
>  2 files changed, 21 insertions(+), 19 deletions(-)
> 
> diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
> index eb8aacba3698d..557ac918bdca6 100644
> --- a/include/linux/pgtable.h
> +++ b/include/linux/pgtable.h
> @@ -22,25 +22,6 @@
>  #error CONFIG_PGTABLE_LEVELS is not consistent with __PAGETABLE_{P4D,PUD,PMD}_FOLDED
>  #endif
>  
> -/*
> - * On almost all architectures and configurations, 0 can be used as the
> - * upper ceiling to free_pgtables(): on many architectures it has the same
> - * effect as using TASK_SIZE.  However, there is one configuration which
> - * must impose a more careful limit, to avoid freeing kernel pgtables.
> - */
> -#ifndef USER_PGTABLES_CEILING
> -#define USER_PGTABLES_CEILING	0UL
> -#endif
> -
> -/*
> - * This defines the first usable user address. Platforms
> - * can override its value with custom FIRST_USER_ADDRESS
> - * defined in their respective <asm/pgtable.h>.
> - */
> -#ifndef FIRST_USER_ADDRESS
> -#define FIRST_USER_ADDRESS	0UL
> -#endif
> -
>  /*
>   * This defines the generic helper for accessing PMD page
>   * table page. Although platforms can still override this
> @@ -1660,6 +1641,26 @@ void arch_sync_kernel_mappings(unsigned long start, unsigned long end);
>  
>  #endif /* CONFIG_MMU */
>  
> +/*
> + * On almost all architectures and configurations, 0 can be used as the
> + * upper ceiling to free_pgtables(): on many architectures it has the same
> + * effect as using TASK_SIZE.  However, there is one configuration which
> + * must impose a more careful limit, to avoid freeing kernel pgtables.
> + */
> +#ifndef USER_PGTABLES_CEILING
> +#define USER_PGTABLES_CEILING	0UL
> +#endif
> +
> +/*
> + * This defines the first usable user address. Platforms
> + * can override its value with custom FIRST_USER_ADDRESS
> + * defined in their respective <asm/pgtable.h>.
> + */
> +#ifndef FIRST_USER_ADDRESS
> +#define FIRST_USER_ADDRESS	0UL
> +#endif

Looks good to me :)

> +
> +

Nit.  I think just one new line here should be ok?

>  /*
>   * No-op macros that just return the current protection value. Defined here
>   * because these macros can be used even if CONFIG_MMU is not defined.
> diff --git a/mm/vma_internal.h b/mm/vma_internal.h
> index 2f05735ff190c..2da6d224c1a85 100644
> --- a/mm/vma_internal.h
> +++ b/mm/vma_internal.h
> @@ -46,6 +46,7 @@
>  #include <linux/swap.h>
>  #include <linux/uprobes.h>
>  #include <linux/userfaultfd_k.h>
> +#include <linux/pgtable.h>

I think this might be better to be done together with the following change that
starts using the ceiling and floor from generic code, or mention this change in
the description together?

Above comments are for only trivial things that I don't really mind.  Please
feel free to proceed as you want.


Thanks,
SJ

[...]

