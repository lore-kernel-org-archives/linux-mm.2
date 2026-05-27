Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8A18BCD5BDE
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 09:16:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C8FF66B0005; Wed, 27 May 2026 05:16:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C40DC6B008A; Wed, 27 May 2026 05:16:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B7E206B008C; Wed, 27 May 2026 05:16:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A836A6B0005
	for <linux-mm@kvack.org>; Wed, 27 May 2026 05:16:30 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 067881A0586
	for <linux-mm@kvack.org>; Wed, 27 May 2026 09:16:29 +0000 (UTC)
X-FDA: 84812644140.07.24EC7A0
Received: from out30-110.freemail.mail.aliyun.com (out30-110.freemail.mail.aliyun.com [115.124.30.110])
	by imf01.hostedemail.com (Postfix) with ESMTP id 079EE40011
	for <linux-mm@kvack.org>; Wed, 27 May 2026 09:16:25 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="QZ6/mJUD";
	spf=pass (imf01.hostedemail.com: domain of xueshuai@linux.alibaba.com designates 115.124.30.110 as permitted sender) smtp.mailfrom=xueshuai@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779873387;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sBtVQtrG2D+f9Z/sho+DSeJtMa0aOiwSm/AF9v+I85o=;
	b=ZrvlM2s7VxzEzHVso9Szwb7o6qMknY0hUu7dq/28+Md0yrwh3Hc+4e0xxPZAKxYg0XW75h
	A87T58+haY+EV0kdpNPeaktOO+nZ+ujzhOHERiEtEt9wHIaT+W967fc9BjH1Z5XUfJJ7TN
	CQgO7MnjAWj3weVWLxYLLRldUtFnLwk=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="QZ6/mJUD";
	spf=pass (imf01.hostedemail.com: domain of xueshuai@linux.alibaba.com designates 115.124.30.110 as permitted sender) smtp.mailfrom=xueshuai@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779873387; a=rsa-sha256;
	cv=none;
	b=lOnZA4llJjsQB00nHCz6HYz0K2PPCga+lyz2s9/ZoAEvKk0CRU5pJfXwtaUhYlad+v0xLj
	/imNtCXtNtkVatBkHMPN3QuX4iWcgPJyQj/eZRrt03zUTXzal4BUTkgLvsOyFGIfFFsHkj
	8Z65dcC/dugmxJwMxtuG5Ur8Wm0CKys=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1779873382; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=sBtVQtrG2D+f9Z/sho+DSeJtMa0aOiwSm/AF9v+I85o=;
	b=QZ6/mJUDSeJOmUYOGq4rKHanbAZmxdUR5n8JBRrMN5lejUSzb0BPS71uifmRTbnJANSGKLK1weeIL6RDfO1zHTNm1VOIpBQEu7UhlZJ1CICiN80Z+9TfsoY6tbxk46Yw9E2WWnbNg4YkXDKA1RwEC8yHCgkI4NqaPUVSUmsm+kI=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R111e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=xueshuai@linux.alibaba.com;NM=1;PH=DS;RN=29;SR=0;TI=SMTPD_---0X3jFQTK_1779873377;
Received: from 30.246.179.14(mailfrom:xueshuai@linux.alibaba.com fp:SMTPD_---0X3jFQTK_1779873377 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 27 May 2026 17:16:19 +0800
Message-ID: <1cc534eb-b323-4cf3-9301-77e3925c613b@linux.alibaba.com>
Date: Wed, 27 May 2026 17:16:14 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v14 1/8] uaccess: add generic fallback version of
 copy_mc_to_user()
To: Ruidong Tian <tianruidong@linux.alibaba.com>, catalin.marinas@arm.com,
 will@kernel.org, rafael@kernel.org, tony.luck@intel.com,
 guohanjun@huawei.com, mchehab@kernel.org, tongtiangen@huawei.com,
 james.morse@arm.com, robin.murphy@arm.com, andreyknvl@gmail.com,
 dvyukov@google.com, vincenzo.frascino@arm.com, mpe@ellerman.id.au,
 npiggin@gmail.com, ryabinin.a.a@gmail.com, glider@google.com,
 christophe.leroy@csgroup.eu, aneesh.kumar@kernel.org,
 naveen.n.rao@linux.ibm.com, tglx@linutronix.de, mingo@redhat.com
Cc: linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org,
 linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
 kasan-dev@googlegroups.com, Mauro Carvalho Chehab
 <mchehab+huawei@kernel.org>, Jonathan Cameron <Jonathan.Cameron@huawei.com>
References: <20260518084956.2538442-1-tianruidong@linux.alibaba.com>
 <20260518084956.2538442-2-tianruidong@linux.alibaba.com>
From: Shuai Xue <xueshuai@linux.alibaba.com>
In-Reply-To: <20260518084956.2538442-2-tianruidong@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 6ngkidbi6cpryuu97dj6cumnoq5y4dgg
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 079EE40011
X-HE-Tag: 1779873385-231637
X-HE-Meta: U2FsdGVkX19cJKWZkeiP8gS9eJFAmZUqKdaxC/P1LMjXAJq8yWiMNxllQECW34M8kZAsULbSGeXX6wNHGFa8j6m2abQH4aC0k7Cv42tQxL8fTnxCnmOLvPWWnClM0iq1ivwIELcRN60OPB8g7N2pyG6hipSQ0PAgAUSffOTV+iA5kLJ/hyF215PpBk1iHb1LiMerFW3mYokbuDXTdT42UMbXasSZjPjfFZv/r0xXQkWlud1eCp4USl15Oav4o85tIxEu6ae6CgrEjC6EDyzwKOPl3DLQMfMMYAQZILl+QM892bH5seYrGHRdGLMlpFgYHf1G56VVXVpxJH5QBXqVDFwzJs51e6xvTGQEOrIfXy57827AeHxQ28ipYTpy8Xp4YEOwf76nvxkjdRrXLYBcb20cCjG8NZPjXYdOBulyfQ6tp76EJXt6GavIcTKM57ENSMI9R3baiGiGcTOyzli0bSJNnDgl9A3Xw/gSxkrQSRa0Cqs4/Y9xaOW1MLh/MFU6Uw//AfNs7WtoY/zysBHI+r2DygSH+WMKBmiv4VK/j9PYkFbxYuE12K7CC2g7ID4ba8tqLHuEiJdQbB1Vg8yBmmP+5vCOspQN65UyTecgHnRpzbHGHik0+842B1oPiOM3u/0MOPMLpyAbZV9Z6yA6dAm7EDklqy0ForiA7oNxuwrbYosmVSiyH+XMd+tNtJgXSzZwz9fUjFQDHwnBTROH4JdRK/NY3bWoDszJ5Q0I3WkCAuEfbMYLgz/AYUbpZgxGmy561CmBCtl4+/PVKCHYgK2o5J8Z7kc1j9YTfcsFcfXZSz0CIX5ILxG0Mqf6iHq5BoAUGNDhCaGzL/WiFL2zu2W8Xw5f2Am+zWn5hsrnk34+UwisAmefOSpAxcRE8nZp7oCGPOacpuS2k0m7G9lZnQQLbfEI7hnzwGhaTdfIlmMYIbpcq6EI4kTkou5lIgHJOlIfJrNagVXMnb2yx46
 JmKPQAuz
 BgfWuC0cFJ/kw6yW7ipg+48QjSnMDYPV1RH7joy2ADJsGN6QpfEJaB9Few9lLeUMDffa+L869cSRmHSa7+Jh+molkwiS5EYmGehUcTaVOUcPaDRrHV3iR4sJKq4jHV46uop+L0teqijNJmBMtaWPsWtrGhGqUSDOHRaSEKcUsU273srKfyGfZ6LcUXhmlzlzNW8sr2Kl660/b4kxjaM1FHLeiTCmWnoWemwRdBNyfUw7tMC3YhWbMN8QAJ0oxqPalxMMWG32U1qe4TRSvmiN6+e6D5zTY3VYOWvqrvm9EFwGRP63DKI80e11mEXg/PIqnzkGM5ZwfxInd3Acr+bQjs7sxyCtZMPiCFsBUi8KJZ5BXGLte2MREOXhaqURjXLD+TKB+1H/RhwPn36BehAz3OkKqjYgc6kaBEi4cuDNp0OKnJto1klTXKyuD/gYiP5KvbUSJDA+IZM0nZbAXQfMudNqpjQ6VZThEJ+WC
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 5/18/26 4:49 PM, Ruidong Tian wrote:
> From: Tong Tiangen <tongtiangen@huawei.com>
> 
> x86/powerpc has it's implementation of copy_mc_to_user(), we add generic
> fallback in include/linux/uaccess.h prepare for other architechures to
> enable CONFIG_ARCH_HAS_COPY_MC.
> 
> Signed-off-by: Tong Tiangen <tongtiangen@huawei.com>
> Acked-by: Michael Ellerman <mpe@ellerman.id.au>
> Reviewed-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
> Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
> ---
>   arch/powerpc/include/asm/uaccess.h | 1 +
>   arch/x86/include/asm/uaccess.h     | 1 +
>   include/linux/uaccess.h            | 8 ++++++++
>   3 files changed, 10 insertions(+)
> 
> diff --git a/arch/powerpc/include/asm/uaccess.h b/arch/powerpc/include/asm/uaccess.h
> index e98c628e3899..073de098d45a 100644
> --- a/arch/powerpc/include/asm/uaccess.h
> +++ b/arch/powerpc/include/asm/uaccess.h
> @@ -432,6 +432,7 @@ copy_mc_to_user(void __user *to, const void *from, unsigned long n)
>   
>   	return n;
>   }
> +#define copy_mc_to_user copy_mc_to_user
>   #endif
>   
>   extern size_t copy_from_user_flushcache(void *dst, const void __user *src, size_t size);
> diff --git a/arch/x86/include/asm/uaccess.h b/arch/x86/include/asm/uaccess.h
> index 3a0dd3c2b233..308b0854d1d5 100644
> --- a/arch/x86/include/asm/uaccess.h
> +++ b/arch/x86/include/asm/uaccess.h
> @@ -496,6 +496,7 @@ copy_mc_to_kernel(void *to, const void *from, unsigned len);
>   
>   unsigned long __must_check
>   copy_mc_to_user(void __user *to, const void *from, unsigned len);
> +#define copy_mc_to_user copy_mc_to_user
>   #endif
>   
>   /*
> diff --git a/include/linux/uaccess.h b/include/linux/uaccess.h
> index 56328601218c..c53a65394f80 100644
> --- a/include/linux/uaccess.h
> +++ b/include/linux/uaccess.h
> @@ -250,6 +250,14 @@ copy_mc_to_kernel(void *dst, const void *src, size_t cnt)
>   }
>   #endif
>   
> +#ifndef copy_mc_to_user
> +static inline unsigned long __must_check
> +copy_mc_to_user(void *dst, const void *src, size_t cnt)
> +{
The prototype of this generic fallback diverges from both copy_to_user()
and the existing arch implementations of copy_mc_to_user() in two
non-trivial ways:

   1. The destination pointer drops the __user annotation.

      copy_to_user() is declared as:

          unsigned long copy_to_user(void __user *to,
                                     const void *from,
                                     unsigned long n);

      and arch/x86/include/asm/uaccess.h declares the arch version as:

          unsigned long copy_mc_to_user(void __user *to,
                                        const void *from,
                                        unsigned long len);

      With this fallback typed as 'void *dst', sparse will silently
      accept a kernel pointer being passed in, and the address-space
      check is effectively lost for any architecture that ends up using
      the fallback. The annotation is the whole point of __user; please
      keep it.

   2. The size parameter is 'size_t cnt' instead of 'unsigned long n'.

      copy_to_user() and the x86/ppc copy_mc_to_user() implementations
      all use 'unsigned long'. On all supported arches this happens to
      be the same width as size_t, so it is not a functional bug, but
      the inconsistent signature is a foot-gun: when an arch later
      switches from the fallback to its own implementation, every
      caller signature has to be re-checked.

Please align the fallback prototype exactly with the arch versions:

     #ifndef copy_mc_to_user
     static inline unsigned long __must_check
     copy_mc_to_user(void __user *dst, const void *src, unsigned long cnt)
     {
         return copy_to_user(dst, src, cnt);
     }
     #endif

With that fixed:

Reviewed-by: Shuai Xue <xueshuai@linux.alibaba.com>

Thanks.
Shuai

