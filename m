Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3E76FC43602
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 17:01:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 72C426B00AF; Wed,  1 Jul 2026 13:01:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6DC786B00B1; Wed,  1 Jul 2026 13:01:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5F4FF6B00B4; Wed,  1 Jul 2026 13:01:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1E0AD6B00AF
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 13:01:41 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9C548C22FD
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 17:01:40 +0000 (UTC)
X-FDA: 84940824360.05.36FEAED
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	by imf07.hostedemail.com (Postfix) with ESMTP id 8355D40010
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 17:01:38 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=TwnFzjvp;
	spf=pass (imf07.hostedemail.com: domain of ecree.xilinx@gmail.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=ecree.xilinx@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782925298;
	b=nSHIOt3ehFD0hzGBvjWu2HwRCo2Iwm9HPyvfxJJ+sjZJXoPPZ6OCswOj0mlcUNA0pNCbpS
	pQ8ijkvi5XYCbVe0PPDA2NpF6XnJxXhVEfrqMk5d/z66PoW13L0Qi7X1YZQRROlqUoGPAu
	2ykNSBFRV8VmpnQKsNjx9rkjLHg3JdQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782925298;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9CayLh9sn6SyGJSkLYj3J5jM0EP4cWj8SDd1cZ9x18Y=;
	b=Tg8/fBuvFFYpOjg/b0kpfjPYou/s9eDIGkucdECdx5KH5hHqeuhOMwHe5dmKUJ5ry0HVQH
	XO5DSblbZi6Hgcm5KgaaLvw376c6WgHOwy7MfBigQLuHYYSSyJctAns49GCpVIqYNtIlgV
	9289JkLiCjFrr4ZJFPWb5axSK6QDp9o=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=TwnFzjvp;
	spf=pass (imf07.hostedemail.com: domain of ecree.xilinx@gmail.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=ecree.xilinx@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-493b27c7451so20719755e9.0
        for <linux-mm@kvack.org>; Wed, 01 Jul 2026 10:01:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782925297; x=1783530097; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9CayLh9sn6SyGJSkLYj3J5jM0EP4cWj8SDd1cZ9x18Y=;
        b=TwnFzjvpEd7VMPEW7IugfU0rytAIN+9DwLvhvXYkfeoDsb6RHe63VYVHWAWQu8IExT
         c1WYPbNgWQSGBJjJytTPEVk3HyUjEKv9ChruUSlBGMLG6gGJzZCHsdaJ+3J1D/7OV2dG
         Qmt9a5CDz4Ui8RaCTvfDFXnypTkE2Ur3KpIwT2Jl8vRrvXvvOOUImarBrms8gBdpuJFs
         Zo9ebnealfPQgYvHZHFjS5U5mkCrcXNyBqs8De7lW/aEWwjL7o3haJTWEys7U06GzXrH
         8S+LWbdupqE3pRz8OgmtYY0IuJ0nLM10ZD9UsE0KU8bGUbHPVFYxkOAf1DBieLI/vfbl
         cK5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782925297; x=1783530097;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9CayLh9sn6SyGJSkLYj3J5jM0EP4cWj8SDd1cZ9x18Y=;
        b=IdcJvyp1MOxZyh8PoOaWQ2Di33KO7bIxric3Kz4+d5sn+IeHs5DFf4CsTFQZZnEdzB
         xy5LwqxAdGmK5K/fKDn49D6eHuovwsmYM3wSkMSwyeaQS8qNDW4H6R5Y5ClXdKs8qCrK
         n9XAKibXEALojgp58P4czbEHCFR/vH6ENWQ3++a1Oqu2o49Tk+2HtZQp4UkQ5tFLO3CG
         OCFGp45mtDaSa/QdrccXmhhcuck6kXwNknxjPH5wbu8ePJx/NH+gpoeWq2a4VEVcx1Cc
         bqlVLoNUpnvpJrF3kmb3u5fgHzKrs2hGuou3MrvBt0mXRXmmtR19NkpIk4kSGqSQgVZn
         xQcg==
X-Forwarded-Encrypted: i=1; AFNElJ+FU58a7+/k8XyYB8E1gwF2tE3dmLykan+KrF7rS2X0WFqkUjEawidbvEJr60R0xAecRvAddOIPpA==@kvack.org
X-Gm-Message-State: AOJu0YwZzQ1YmYEIH0MbZg4wZBJDJ/SadtHFgNtLqd+8HBPurnChhm1S
	sXWOUdjLCi9szzEi+c0bfzjOFgtthUevHWVTbkK5cLNSH+xbLE2XR26J
X-Gm-Gg: AfdE7cmjoh3+UWDtUP3t7IC0+4k21j541olqT5qdM5qztzhtYTfQ0+MMPB35VOhuZfX
	agQ/CHGHsQ6idrvI+XQ8173x9mTPaW4hAhW7VBkefV+5pV1WQ+v9bH3sO/Xb/UujGpEeC1S3mNE
	R0WghhfKApvACAi+RZ/GKWiqHGqSZzUTxwFmlcJkzITgmAfNh2Qt31pXbfVY3xwSWrgRYzQxwsy
	2UVGXQ/xn6wS8RATQezhuD6gv5yVxFW2+5YwXYAPtfan2B0WbXZwqb/82mpx6X9vZJOIWlKo3qT
	2DYCLO5flRGiUOKomrPQICZ2dfXARmcARhzgSrq9RVlUYn5O0ryV/WYEJhfF+IfaECLZvZ4BcYC
	fRt81n3OAsItP0A+bCLFlb3bVJh982ghRKue/iCeg2zBsdeI+S4ZoHOMCRA6LV0Wz+jyAHfEFPe
	pPv7Il0bc9akC/3v2q/+Z0l5/Vtd2dZOcJdrI/kfup27rRtkmmZhbeiL22ovoftHwJe9Ftnddtj
	6w=
X-Received: by 2002:a05:600c:4685:b0:490:af63:2cb1 with SMTP id 5b1f17b1804b1-493c231f913mr37259535e9.7.1782925296780;
        Wed, 01 Jul 2026 10:01:36 -0700 (PDT)
Received: from [192.168.1.122] (cpc159313-cmbg20-2-0-cust161.5-4.cable.virginm.net. [82.0.78.162])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-493be4bfd47sm122822645e9.2.2026.07.01.10.01.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Jul 2026 10:01:36 -0700 (PDT)
Message-ID: <d069d958-e069-45ea-87b6-95ad4a5fca29@gmail.com>
Date: Wed, 1 Jul 2026 18:01:35 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/4] sfc/siena: use kmalloc() to allocate logging buffer
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>,
 Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Manish Chopra <manishc@marvell.com>,
 Paolo Abeni <pabeni@redhat.com>
Cc: Przemek Kitszel <przemyslaw.kitszel@intel.com>,
 Sudarsana Kalluru <skalluru@marvell.com>,
 Tony Nguyen <anthony.l.nguyen@intel.com>, intel-wired-lan@lists.osuosl.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-net-drivers@amd.com,
 netdev@vger.kernel.org
References: <20260701-b4-drivers-ethernet-v1-0-58776615db6e@kernel.org>
 <20260701-b4-drivers-ethernet-v1-3-58776615db6e@kernel.org>
Content-Language: en-GB
From: Edward Cree <ecree.xilinx@gmail.com>
In-Reply-To: <20260701-b4-drivers-ethernet-v1-3-58776615db6e@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: m4in5jms734jrhez4s9mmxht8y4kwsmb
X-Rspam-User: 
X-Rspamd-Queue-Id: 8355D40010
X-Rspamd-Server: rspam02
X-HE-Tag: 1782925298-30067
X-HE-Meta: U2FsdGVkX18Z4TY6Zyv0bxXJlz5F+k9wBAao7B1i8UqaCkE9Jth1xJKrwagyC7jBf+p9q2sSkIBeMevTd37qioyNCpaisKfy4sdmvfIpRKDo3b385LC/VkXyKByK1OjuhBpJ4QfP+F5nNyTbZ7SSP6PVg6pomPDt7EWsfgxz+dM+cttj5YwgIZPKuSyEhcyu4ccAFDZMZtFXAivpgYtL1BzyjDiDkiHjg91Q1IqKRun4w0/wVquenRXA2dm7wTal+jgmimxny8GkpsyktxMbNVQXwqhDs+krUotNG1b6ptaoA9tRQGwHlv211m3BTCRadjufwUfsklMsHjmwvr8uWJfGIg9yf2lqJ1wFksD6FszljAAqOArbfmA9c2wJCDb/PsKgr/l1/3SfjuDhwzbr97XTDz4Bj/W0hnzxJGszmsvtG3HTDetDIl0G19YEaKUcm0uZNghS8N1I9dTW9pYrIhafEf+pX2D6PJD2/4u4GQOUt+93biPmAjEQlvbunanGgpRtmvRk1hpxl78wFuEOS+2HS+iPa+1wR1l1foBUhcmx6e/ssEyaOEz3gw3Mw0JaeVBnQVofPJ0982KysQo5SBBGuybyPxK5Tb3C0GOGFKMUccb1kv1UCvTKEpNXr3YbdZ7srW36DvHPx1oFpqzX0hvb8CJmstpaOJ+ZyMPPwIikdxVaSeOt57y+0gdsWVluEyd7nedRHPLeN8/WsMn7KPp1BS/wlCQJVHHji9b6zax1kT1bV+iC3v1HlcdGCkdZBoCJv4yeR3xB/3QjHpRnGRI0o+wcKEt533WAjdZaZSY5Gmi4eBg8a5W27dwCxNxpIgc0ccnncj8tOywxkutO30rXezvopRaZjGzOxrOr/RSqze7pjRCeuxfwNC6ADlCK7m7spYAXQXGIR8orUXa76u3ppGJeYzhcTQ80oGe3JrKStOdAfCENf6/arGADoWIk7JOMbmNrZDsTqoT+NTG
 YLbKypb1
 aOj9zwlfER0oqV4boxZTtyfWYN7i0dbeXFruxOFL00ksPB7+wLPxh2+jqo9P00a04ZoPUPI2u+L3LMTBWLRkf1LRM4Czn0ysqH5LipYf4TyBEAbsIPkGnNv3X5IxVIykP3uD+fKlOuhcEnCESZbzsx2oVIurdO9VZYlmbmkFI4Q+rie8KRMCT7vJqjFhP2kSI/QuhFrGicArb41w1Yuwhw7bZKAtY1yvswDLMPkGbne4YpqopOzvJW5l8lpVpwj76nViewGMial/BMjicqsou2N/n3zb4b6ce+9rhnaFwam1Q3OugqOcxJiTRdsyL/6loN8YZbuzDy0XsxvsiYegA4rob62o4uMGh+gzrz87Eeei+Dx3qq8iUJU1boDcmPxhLiQkUnvzlXHAfh4AJqMp7ZJA2a58KTzJqg/BtetG1b3wFAcW5HHAQCu7NtKjImZ/BF6Y2UAaP+CXgmS+a2nNhYtq0/jx/wM+97OGOKT5ZJDCvubx+JAalKNdo/SlqOwNiJRE+Qsjn80IcWCK9qwKHH+Fk3cvWc47bH9qu7tDiH6ForKa+VE+YhwnVUY1ggYc5TZIegaEq9W7NOIvlecUUbJwFkmDLZaYmiFMzN5pWZdap51hPvbb+TQsYnw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 01/07/2026 14:57, Mike Rapoport (Microsoft) wrote:
> efx_siena_mcdi_init() allocates a logging buffer for MCDI firmware
> communication diagnostics.
> 
> This buffer can be allocated with kmalloc() as there's nothing special
> about it to go directly to the page allocator.
> 
> kmalloc() provides a better API that does not require ugly casts and
> kfree() does not need to know the size of the freed object.
> 
> Performance difference between kmalloc() and __get_free_pages() is not
> measurable as both allocators take an object/page from a per-CPU list for
> fast path allocations.
> 
> For the slow path the performance is anyway determined by the amount of
> reclaim involved rather than by what allocator is used.
> 
> Replace use of __get_free_page() with kmalloc() and free_page() with
> kfree().
> 
> Link: https://lore.kernel.org/all/635405e4-9423-4a25-a6e7-e03c8ea0bcbe@redhat.com
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

Reviewed-by: Edward Cree <ecree.xilinx@gmail.com>

(resending since I hit 'reply' instead of 'reply all' the first time)

> ---
>  drivers/net/ethernet/sfc/siena/mcdi.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/ethernet/sfc/siena/mcdi.c b/drivers/net/ethernet/sfc/siena/mcdi.c
> index 4d0d6bd5d3d1..048c1e6017c0 100644
> --- a/drivers/net/ethernet/sfc/siena/mcdi.c
> +++ b/drivers/net/ethernet/sfc/siena/mcdi.c
> @@ -7,6 +7,7 @@
>  #include <linux/delay.h>
>  #include <linux/moduleparam.h>
>  #include <linux/atomic.h>
> +#include <linux/slab.h>
>  #include "net_driver.h"
>  #include "nic.h"
>  #include "io.h"
> @@ -73,7 +74,7 @@ int efx_siena_mcdi_init(struct efx_nic *efx)
>  	mcdi->efx = efx;
>  #ifdef CONFIG_SFC_SIENA_MCDI_LOGGING
>  	/* consuming code assumes buffer is page-sized */
> -	mcdi->logging_buffer = (char *)__get_free_page(GFP_KERNEL);
> +	mcdi->logging_buffer = kmalloc(PAGE_SIZE, GFP_KERNEL);
>  	if (!mcdi->logging_buffer)
>  		goto fail1;
>  	mcdi->logging_enabled = efx_siena_mcdi_logging_default;
> @@ -116,7 +117,7 @@ int efx_siena_mcdi_init(struct efx_nic *efx)
>  	return 0;
>  fail2:
>  #ifdef CONFIG_SFC_SIENA_MCDI_LOGGING
> -	free_page((unsigned long)mcdi->logging_buffer);
> +	kfree(mcdi->logging_buffer);
>  fail1:
>  #endif
>  	kfree(efx->mcdi);
> @@ -142,7 +143,7 @@ void efx_siena_mcdi_fini(struct efx_nic *efx)
>  		return;
>  
>  #ifdef CONFIG_SFC_SIENA_MCDI_LOGGING
> -	free_page((unsigned long)efx->mcdi->iface.logging_buffer);
> +	kfree(efx->mcdi->iface.logging_buffer);
>  #endif
>  
>  	kfree(efx->mcdi);
> 

