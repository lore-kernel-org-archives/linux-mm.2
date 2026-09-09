Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DA7C6C79FBD
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 17:14:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DD2746B0096; Wed,  9 Sep 2026 13:14:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D5C716B0098; Wed,  9 Sep 2026 13:14:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C72FD6B0099; Wed,  9 Sep 2026 13:14:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A6EE96B0096
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 13:14:58 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4152D402B7
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 17:14:58 +0000 (UTC)
X-FDA: 85194873876.21.4FDACFA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 9B75440006
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 17:14:56 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nmB7O9lr;
	spf=pass (imf17.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788974096;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b3vZjZsk+GN++tvViwRlo0oHYVyDxomGvHO319w0GOQ=;
	b=e3glRhI1C9VqZpI3Qo282PoJRljFqpwBfbi12n348sXyDIkILovdNML0OyvP/9iuvJQ9l4
	aLSdFFmg7GMLrCNRv3GIXRiJ9/2uYhHgJdw7xMWF7/TMtJVyXYZ0pqSUT0hgWe7znKkV51
	cXkZFle+MtiUF4Tivo7WQd53MmT45Gw=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nmB7O9lr;
	spf=pass (imf17.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788974096;
	b=VqPED0v4kJCGf5PBrgW8iJ5e6GjFj1s2OzfNmbSz2YaV4I0n28RjjZbWkLctCEZhJAN6ca
	m1NUNvsZPVwIdC/GJsqn4pWPo9GcEthCU79XC3o6Id9p8lfMs3Cmqf4K+zDHyY/D3BzcyS
	zubB7HFpuoMHR5UPy07Kgred7JwGnrs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1B210600CB;
	Wed,  9 Sep 2026 17:14:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CF2B1F000FF;
	Wed,  9 Sep 2026 17:14:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788974095;
	bh=b3vZjZsk+GN++tvViwRlo0oHYVyDxomGvHO319w0GOQ=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=nmB7O9lruhIGjS1BiDxF6ZJyB07xHi0GGmJuIWVfaEcmIhD/hXeiuTRQkzVUgS3tN
	 OK9XESiMepItDGhH6AG4gkdIYIqREa+3xy0IsPhMu52Zh0+A/oSpw5dznMz2ju+Die
	 C6ktbkHMvAuQUyOOS6KhNjaRRzDsUlYtziUHBAbSUqttIApmYOoL3PcWHmPpZbomz7
	 bKjmWE5YczMdZOF4h+6Zrz09AzuUJwm/Av0kANlBd2JrFqYy3Qz3XOTMp/sbwxlpuE
	 GRm93WOrysD2J1RDWmtQv4JzahkIavyGPEn04IxBPSJDHIZoZc+hKAovvelR7A289s
	 Yu2TluvX+7FPg==
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2 1/2] memblock tests: model the low allocation limit
 within dummy memory
From: Mike Rapoport <rppt@kernel.org>
To: Tianyi Chen <hi@tychen.cc>
Cc: rppt@kernel.org, Andrew Morton <akpm@linux-foundation.org>, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
In-Reply-To: <178874362959.1415955.9346611507889046159.memblock-v2-1@tychen.cc>
References: <20260906144011.848898-1-hi@tychen.cc>
 <178874362959.1415955.18132997964995947947.memblock-v2-0@tychen.cc>
 <178874362959.1415955.9346611507889046159.memblock-v2-1@tychen.cc>
Date: Wed, 09 Sep 2026 20:14:50 +0300
Message-Id: <178897409075.1489479.13793114752511118505.b4-review@b4>
X-Mailer: b4 0.17-dev
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 9B75440006
X-Stat-Signature: rph6cb488erhfkwn31knm9k4mfchep8s
X-Rspam-User: 
X-HE-Tag: 1788974096-845051
X-HE-Meta: U2FsdGVkX19NMv54AW105IJYAINfiU6b8UTBg0E05tOR+PLuFZNueNB1mtfKT0DNvpXuTlkVTSLFGtPKGLZ+OeQ/2JwExyQy1B9dtM321EuMgq+UjNwsP5Y+ig/Z1v2U/pBrs8hYpMqgSLDPiNPKrA4mLPhL7nv62r9oPL6X9BGRzT4L8IBGRyEOgEOeofaAwxYAJ1ZTMzwlx1uCzG/auADR+C5GrvTeIWoIgFlYJkvNUYmYZfyFqBuHQcGjufpGTv9lX9pgEIfk7MHOSqnSLm8ZOLL59g2zxVxuT37YrwwbfVXA3Mv5YLTiD7RbDkyITIAZpNIFd8ogWiUqFBgiLqipxJVFBM0+iK3IlgyEzan/C27ZgGzoNJOoRMX7Z+tFmbPZVJKvlx2IiQctOnt+k6BwW7Q3RVbkWeOmhct0dIQ9DdHv9t6+t5oWKRn0vQGifCBVUkEHQCbGONpAPPFywWOp3TO2hYgxTZuigTK0YhUEDvuFed3g3fin+rjXsbnz3clACfbWRHimsq44jKQq+afLqcNiaqZsv0HeOJBwvItsQCiy486wW4d9tMtsOP9rax189OGcE7M1JcqUoZZtVYifCD71ssm9wCYoZyKdOgOSAXYQ/41FRSmDuKKdLVqI9IKq2T83bgBVJ3HPItjtG4FBR7CppzfoABRlKgjM5JKnb1PM+DhborZPjlQghWim669LYkR4LevZW8JvGmK55rj7b65b4aB4yD2uDm4+kZh8oSZiuJ0+rUkS35seOWKFiuzZN/pKKfORudxZ39rzgrujwdTVhCMoS16qE1JGt6T0iBVZco6EH40pg+IUn6DBO8Xlu8FX2VnI7gtgS9GVOQOyzBj1jqDy45NUEYmFdYr2tQ/A7OgaLXoBkmJDAyXQFV+xLExbShEUIfcrnNTrv8Rt7YnUdAdUy81D/S/zizb5WRlJvWRlljKc/wc7LaSKSMuw3Jvx/yRQLsEsjfr
 lfhpq6gM
 zSctsE1TefVLJ1ESHXaaAe43r8rR64BooDhcDQkJh1CRLCG/f+jhysU0KoSVQTbr23sAQ0Y0WsalT368zDl01Rm8mhUsDAK/BHTER4+GllqdBuGpy1r+Z4fsr1Ma+bbqmMjdXuYGYpEqU0NBsDM4EfCso6I8Cw4YBzvsqqi0wYgMUXUU5T3oDU82rkpxV67OvP+ZPtHW4f9ZLK3F7kpS+S98vmQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

> The simulator represents physical addresses using the address of its
> allocated buffer. That buffer can lie above the default
> ARCH_LOW_ADDRESS_LIMIT, preventing meaningful memblock_alloc_low()
> tests.
> 
> Use the architecture override in asm/dma.h to place the limit halfway
> through the MEM_SIZE region registered by setup_memblock(). This leaves
> registered memory on both sides of the limit. PHYS_MEM_SIZE describes
> the larger backing allocation, rather than the registered region.
> Resolve the limit after allocating the buffer. The production allocator
> is unchanged.
> 
> Assisted-by: Codex:GPT-6
> Signed-off-by: Tianyi Chen <hi@tychen.cc>
>
> diff --git a/tools/testing/memblock/asm/dma.h b/tools/testing/memblock/asm/dma.h
> index 13ff8e5d22ef6..6607408dcf25d 100644
> --- a/tools/testing/memblock/asm/dma.h
> +++ b/tools/testing/memblock/asm/dma.h
> @@ -2,4 +2,10 @@
>  #ifndef _TOOLS_DMA_H
>  #define _TOOLS_DMA_H
>  
> +#include <linux/types.h>
> +
> +phys_addr_t dummy_physical_memory_low_limit(void);
> +
> +#define ARCH_LOW_ADDRESS_LIMIT dummy_physical_memory_low_limit()
> +
>  #endif
> diff --git a/tools/testing/memblock/tests/common.c b/tools/testing/memblock/tests/common.c
> index 3250c8e5124b3..17b95af216b2c 100644
> --- a/tools/testing/memblock/tests/common.c
> +++ b/tools/testing/memblock/tests/common.c
> @@ -118,6 +118,12 @@ phys_addr_t dummy_physical_memory_base(void)
>  	return (phys_addr_t)memory_block.base;
>  }
>  
> +phys_addr_t dummy_physical_memory_low_limit(void)
> +{
> +	/* Split the MEM_SIZE region registered by setup_memblock(), not the buffer. */

The comment should not address the review comments ;-)

It should state the universal truth, like "low limit is half of the
memory registered with setup_memblock()"

-- 
Sincerely yours,
Mike.


