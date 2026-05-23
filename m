Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 85E49CD5BB1
	for <linux-mm@archiver.kernel.org>; Sat, 23 May 2026 12:11:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CC7DD6B0092; Sat, 23 May 2026 08:11:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C51696B0095; Sat, 23 May 2026 08:11:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B3FC06B0096; Sat, 23 May 2026 08:11:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9B75E6B0092
	for <linux-mm@kvack.org>; Sat, 23 May 2026 08:11:05 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3886B120B34
	for <linux-mm@kvack.org>; Sat, 23 May 2026 12:11:05 +0000 (UTC)
X-FDA: 84798568890.08.276BEEC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 8EEAD100003
	for <linux-mm@kvack.org>; Sat, 23 May 2026 12:11:03 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZIgrkQz2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779538263;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jjoXD8XwhLty3iY7UWgSjV13en+BJQVZoZqE9+402Ks=;
	b=FR2Gqn+YDaniT4sloIbJvJls7NEcrvQgBFHwDwu3+9+k1I+BgTlxSKD0l2n7sffYM3gBRy
	DOQLnk5dCyyvInrzzB9OSPLb07ih8zP8OnFWkje8kIhVg2cZYkdQY3qTjAmeQV0SB/y0Qi
	gaWAluPBdFZwzU3HaDAxWUlq8KzrfcQ=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZIgrkQz2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779538263; a=rsa-sha256;
	cv=none;
	b=nmLrxKiSWJFd/B8N0i9lIVWkvGLTB2DxiKWRufuHxNIkiH2IPDN4l1+MbBzLTqijB2zF2o
	jEIZWUYgaGYpppfas92lsKtZaDMTsmbFpiVKhttnRiLb45BIAtdxk5jUvejkGo1NQdcZ8J
	es1P/y8hGyfUB0dqboSqK0Sblq79Ofc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 812AE40A61;
	Sat, 23 May 2026 12:11:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F351E1F000E9;
	Sat, 23 May 2026 12:10:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779538262;
	bh=jjoXD8XwhLty3iY7UWgSjV13en+BJQVZoZqE9+402Ks=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=ZIgrkQz2lnkHB+TNWttFbCvJGShCKoMk5IY1X4wPFKyUjwXNFaFY+Bw8prdihmpqY
	 b9Nz/9AC0aws6sHoyg9vWmk2qHY939xawthSJIQmjvIwVhwGvyyB0kuAkKSX/EWbxU
	 5Y7MvM3a5Qblu0eCwuDNgDCxvfvCOmHPcwXWBUg7O3c4GPGPTbyfyjOQ55D0qk3AYv
	 QMMsldFXbvqBDp2USR6fesd8k2RIt4cMQcqTcEcc0EdTXOBIWeUvoM4cmOjWB3RDim
	 WM1fwq74KhEYDcmKAkF92xgqnH17JX6QadRz05EHdjxvpoQS+UT6Jv+6V2Znk+Cl9o
	 pxijT3mbp4Njw==
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2 1/7] mm: factor zone-device page init helpers out of
 __init_zone_device_page
From: Mike Rapoport <rppt@kernel.org>
To: Li Zhe <lizhe.67@bytedance.com>
Cc: apopple@nvidia.com, akpm@linux-foundation.org, arnd@arndb.de, 
 bp@alien8.de, dave.hansen@linux.intel.com, david@kernel.org, 
 mingo@redhat.com, rppt@kernel.org, tglx@kernel.org, kees@kernel.org, 
 linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, x86@kernel.org, linux-hardening@vger.kernel.org
In-Reply-To: <20260521040124.10608-2-lizhe.67@bytedance.com>
References: <20260521040124.10608-1-lizhe.67@bytedance.com>
 <20260521040124.10608-2-lizhe.67@bytedance.com>
Date: Sat, 23 May 2026 15:10:52 +0300
Message-Id: <177953825215.3959652.4404326127425239303.b4-review@b4>
X-Mailer: b4 0.15.2
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 8EEAD100003
X-Stat-Signature: tipem4ps9obfr1n8juiptp193t38fuga
X-Rspam-User: 
X-HE-Tag: 1779538263-802144
X-HE-Meta: U2FsdGVkX18XxrPILfiqVkRiqVEqrvQClpzWItRiyCAGge/ijSbjvVbZwQwXcwEs2YoFnmTd1pu3WOzgUl+8JMmX6dscnxB9cdbGFKOqWXwpxsX4/m1kaXaiIMopnhXpKVpqNVKP5V0Yw9+XgftXAFg05UNx0ulE3fOIsftL+MLf9X1bPD8LOnONi04yWlV/aLN4x8bM/iJCQTUgjM4iui/yE7nmukAkTgFlHEFqOdW0FyXBh4ku1n7+9BsFX8zLWqaPNRk8BYIWcWwEce4czCdvwmkIk22U26/CsXg+vvu+golmHKJtisyfOqvJshGAYtpM6M+zMoaW6BY6F+2POUC3GskmOz9siJ074sn7JYIg0JMYC+qF1n4PDdRqewG3MkRZnWkrBKI8BrOlTsRMhbpGAU9WqO5iJiUkVwZXNpW4zhbgzBnH/n/PE4u6QZQR24PaIXHuQsgDngpC+jyUJreJctLkPiiiER3iq5NAajQmY9Cbg+vZ9Su9FcduPHlfeUWRENFS/FdWT6CG+cuhp0acEJzRcjOL6Gp6YudAuCZAAFFeTbyJF/2vrj5z5HAxlDJzd4fzk3H/Htx45VUAcFoLiaLm0wpG4nU8NsPM2FIklWiTqHWF+fX3sgjM5TEamZGKVtZ0CWvugD+iFyPcJKCsUuhGYKyent9Faqb3th2G46cNJ16TrqiOCuyMHHYSBfWNHXxpIHPbN3G2JZ78BRCCAVg4fojKOVXiL8//djt00YaSqjM/wL150geBaqSxxkQMFKFcdHF3wNysE0VJd0wbMQBMdUT5DnCZwfKjGAKxDVcD5a93EwiFXGf/6JyMrI9L18ljD7+PFArT5sHmGre0X/UCssOkfePsfuROskCjag6/rEc+xLs5SA9zhyLvMY6Bi6ILnlVpJVcn1K1rrKXrUlvGCfAdZLpWv/rNCCnualwnpK+hGFfznLpaJ1qpV4kYLL/tUr/GbTzEBUU
 3+YD3i/C
 7ACUIAE4BNpLTM5zstBJ6Ty40oVL8NBDnNJhJjct2IcuVFlzX1v8DZQhJ87RBgWSD9FKEnGYJBJrYx5EpizLudlBEX1i2p5JDoD8iVqLppLclMFpJ74BBfGYlHfTBZ/IHf1qpaXD+zXNGJlD7jd2mbspSWWfqknd/J6epuvLbe5l1BiKSZW8mJt0UyIoneTT58sTcOmoHqSvjQ6rxwq6b7Au+oCSNZ0EswvSVEncs/WpnutUbFA9aOzg4wBx+TxX5wQNvzKGz+tjXlX4tiSdo7gCyQg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 21 May 2026 12:01:18 +0800, Li Zhe <lizhe.67@bytedance.com> wrote:
> diff --git a/mm/mm_init.c b/mm/mm_init.c
> index f9f8e1af921c..4ba506df93bc 100644
> --- a/mm/mm_init.c
> +++ b/mm/mm_init.c
> @@ -987,11 +987,36 @@ static void __init memmap_init(void)
>  }
>  
>  #ifdef CONFIG_ZONE_DEVICE
> -static void __ref __init_zone_device_page(struct page *page, unsigned long pfn,
> +static inline int zone_device_page_init_refcount(
> +		const struct dev_pagemap *pgmap)

The name zone_device_page_init_refcount() implies that this function
actually intializes the refcount, but it's actually used as a predicate
based on pagemap properties, so let's make it bool and name accordingly. 
How about

static inline bool pagemap_resets_refcount(const struct dev_pagemap *pagemap)

Other than that:

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

-- 
Sincerely yours,
Mike.


