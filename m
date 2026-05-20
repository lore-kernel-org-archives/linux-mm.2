Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6BE9ECD4F54
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 13:00:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8F96A6B0088; Wed, 20 May 2026 09:00:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8AA926B008C; Wed, 20 May 2026 09:00:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7BFA66B0092; Wed, 20 May 2026 09:00:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6AF496B0088
	for <linux-mm@kvack.org>; Wed, 20 May 2026 09:00:29 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D30A2402F0
	for <linux-mm@kvack.org>; Wed, 20 May 2026 13:00:28 +0000 (UTC)
X-FDA: 84787806936.28.0BBE991
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	by imf19.hostedemail.com (Postfix) with ESMTP id BA7F21A000B
	for <linux-mm@kvack.org>; Wed, 20 May 2026 13:00:26 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=jeXOnpJI;
	spf=pass (imf19.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779282026;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VBgKpCt1/7Dv0saCawyTFbR0vQ6ctxhe2NKjIH0ysvE=;
	b=JSn4ClT8nyqxXEQ6BwZLRkk1JODQ7CqWDtE8TnPwCBgUXnVP/ktohS3SH3A+VVvGtXq35D
	uh/+0TL9/tK3EeqGOHxlN1aKJx6N6DjqBcYXU98ekPJEOB60PpS+IKzCCYxMQxeuBniG4i
	fK5yjrvBTGMs0UKVS/H1zDyOJWuTsDs=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=jeXOnpJI;
	spf=pass (imf19.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779282026; a=rsa-sha256;
	cv=none;
	b=ESF/ylcB+9ptzdtd0ywDTjUue+5svW6gdHyLRLKpCNxYWsGdk0SlO0b2b4pE1cT7IiNecQ
	hcJMsV0O7KxmMQJBr1mXfU36NN674EhAtmmZUB+JVZbc4UJyI6CnQfGcjoBRmhae3mVRR9
	z+vfQmVo0XWX+rUk38eYxXM1EMMNEX8=
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-48fde648a71so35627875e9.0
        for <linux-mm@kvack.org>; Wed, 20 May 2026 06:00:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779282025; x=1779886825; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VBgKpCt1/7Dv0saCawyTFbR0vQ6ctxhe2NKjIH0ysvE=;
        b=jeXOnpJIGcfyA78/mJGklZFaxi+zyVn2NLMO4HO9/D+LD1DxKycYoZHSVs5/dqiHJ1
         LyKcIpvBW3J+DWCb94D6uDfNDqsOyvq/im0TRUyOwdSxIwMLjR5ouX4UV3EVdv95NmbK
         vGbrx/TYJQAMCz0JTmARnLziNMjSIvghME8gHGDKNAGGJvieC+4N9CdDpYXTbFr8e3tl
         Gj0p3asBuYeEm13cekbRt5QdN09+0ypAYn4xW9ztaufXmxuNtYcHGK8u0g2izCBnOPza
         01iFmtEmt7SwHmP3p8ThUjtuTeE6gscqfmTcTWNFni5YMgtq/OF5Duopt61CHx1uFplN
         WysQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779282025; x=1779886825;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=VBgKpCt1/7Dv0saCawyTFbR0vQ6ctxhe2NKjIH0ysvE=;
        b=C6bNuspkI4uHKkgK6kHOWy7BIj3HE0gXOlJjHY0vlrVT/Rq6VxVLyEcTr5wY4T7whi
         N1EKQztnhMIGh7VJ+FXVRVtQY0ZaaO04BKYkUO+U+9GwAhq8nRxiZeCYC2ir/KWT3h/Y
         9TCKHjh/4aGilqOwKo6hlEq0uzBUXjFyWtjHSCLZxonJBPWDNHp7EE/YiBer1ZHeH11a
         d87Moaon9rCCF+onVvu2pQ1pWZiwlxjzyCZlGe7IVY7KsUvEKjlNjmd46PEaU/rtq0Cv
         ZRsDWAy2kAUwDBxl2E72B7oweyhMiIBfuKpwbcRDS/zFpFeVipp4wbmkPW9UzRkvrkS6
         7O1g==
X-Forwarded-Encrypted: i=1; AFNElJ+5DXml29ILYh4wGEFHUHp21JDIFSk/zrjjji2+5HQnVBefGDrDOhzLr6yuO+HscmS5T9UoKwGJIA==@kvack.org
X-Gm-Message-State: AOJu0Yw0EGfMnRFikulbRmAqKChODTPFDryf2jmPMeIl8QjgE/hz/Khk
	zl6Vu5kBDheKEx2Cfa1rqwURBrcl2LRy2Dhn5qIO8r8QF+Ene46FWHOt
X-Gm-Gg: Acq92OFtPb7TJ1AJvvt2zna5Iu8tTIX1bLmE8LuLQ0zglggsFNHbg443+TiEQuy55ag
	Ueke8EM5NDHSn5rfL+exnNFpHG9lDHJ8Jdb+y0ZnQuoMf4U53tQRPIsMULYfXGv9mRaQbhE7xtJ
	UQF7MZ2+7D5C1uupAS6eoNRpTsiFX2nfdSkAi1cazGu24OzW3PSHg/HnoVdVO1MLBBUODQyhRyg
	5aeLXnBPIkg91+whfSbiNrKqhmn3koyMhDPvbMsySEcaFJpPo+PK2QG06+b9DtcYCBIg2Nuw9A2
	qXCkaZ7XzqVrdnHGiA3Jb1EcKKRuqEE9SYb0dL5BrLMRP/FUS/xxnmbVhSO7cEBP9QcpSdNmsG5
	kJI3LJLhE4O+ONInPn1IadpWoyVpvML8SQ2Z3mGatZW9BkQ4EQvQDScONGM50FbGueOGoTqUxSE
	Y95dLvwGFnC0zEbupVhcb0zmkv8dwfqrc26E9rFrjdpYPekUaB2CozpPlRDO0JeDBN
X-Received: by 2002:a05:600c:83c7:b0:48f:e230:29f5 with SMTP id 5b1f17b1804b1-48fe53a8eccmr362118815e9.16.1779282023422;
        Wed, 20 May 2026 06:00:23 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48fe53804aesm376693965e9.15.2026.05.20.06.00.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 May 2026 06:00:23 -0700 (PDT)
Date: Wed, 20 May 2026 14:00:21 +0100
From: David Laight <david.laight.linux@gmail.com>
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Cc: Song Liu <song@kernel.org>, Yu Kuai <yukuai@fnnas.com>, Li Nan
 <linan122@huawei.com>, Xiao Ni <xiao@kernel.org>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-raid@vger.kernel.org
Subject: Re: [PATCH 1/2] lib/raid: use kmalloc() in calibrate_xor_blocks()
Message-ID: <20260520140021.1d36c0b4@pumpkin>
In-Reply-To: <20260520-lib-v1-1-cb3045bef2d8@kernel.org>
References: <20260520-lib-v1-0-cb3045bef2d8@kernel.org>
	<20260520-lib-v1-1-cb3045bef2d8@kernel.org>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: nhc5t438siiarcoty76mug7f9zxnwdui
X-Rspamd-Queue-Id: BA7F21A000B
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1779282026-647445
X-HE-Meta: U2FsdGVkX18/QMjdfFn2iUSTEinhts1B7lI3Q9HkL43j+bLMYAvFxMR8g18gCbr5WPgG6OLido7rKIhnde6k2BXQg2cU9w+DUOXl0oqugUYor2dc579ooQINfExEmL7XiPO9bj4lqvJZuDjh0dWInGmXORsw/I8JOBbs6J1D8ZsOVhHL47Gt5Y8d+BGpSfXZ0Ye4mYV9AEyscY9UaHH4PEuQY+d7yzXHSVAGz7CpwtJM0yHfGocR5ze+wWlQBG2pkbA6hl4E0R4LHCtYhJxSxVHr0CBa5Em0qAG5G6R9rWTBYo9g52bQm1HZcMNvDflfAvoFBLPWEQJsUJFtrOgJuUj2hwsGufJsLID0mWIFv92uNtQmbYT2SwR7t4zCPSxlsbqwgTi6LATn0040zDNNvvbnhgifWuu6tPKRzKqkSLUGjw9QAmTDfONZD1VIUzNhDM6UgKVm6QMw3AAHOKAjpf9w57lry8ADld9P0o24WSsHbKggef6Icg4KwNGZZ59wgp1vlTNiU3r1nQFCq/O6fqYfWdZmcWUWoJl27h03ZMpu/ShWYHiXDl4QgNHC7wOrD4j2lAiaFlw6EOQlcHcObnnZFvfA1yrXIRJjX1gKgSciY6XWzXbApiV+e12lBXsVwtFtAMvDIq94/Jv574zALAk/Aaut1jtTm2IZBKSEtZ7LbVkWqHXAa9PMHR1N4i4YvbNtlrmKA2rzeRTBy2+poe8qynp1eWfJ2ke4O0wpJf2BvfV3dilBwbpB3yncx9hpLePQy6LfklZmxqOExIZ/ZskO2KWE3HTJovnEM2r+VmoK0wyK4irQH4o1LO9//b6s1PFkz3nTRBi8ZUx/9Eo3673rQLcQop9nPkJxqCP6D39qoZKRrhm3fjrMxeyHIkfk7NWa8tevNiCdku4Mo3kelMPAqfwTD1boRmrwsBvvdFXCSAdL9EZEfajOkPejdWTSXGCMS4B/SUOhEMWiZim
 n0foLBGg
 q6OCp0EJ+3HP9pPbYv3MF6+XXBRgDjL1FX1ypVERuzSyjtTMTkM9ZRTenqdXMKs5t/VlIr+G/CDIWXhA/eASx4lWkidB6g2YqWxjcjgSEvoRES6ReWigYM1Zd2lKB5BY5h1NjhMB5ahkvVMHZHxxOkv8pXCpAxD9F4H/zeVcQRjGulMI3usdnaEtrdJgVFMNNvTI+zn0/j9I7bi84l1j1RRouxf8+By5rPd4ainOd7pKpYQanQSJawRq7ij7mjJzPd26ISwnaW/f5Osgh8qcMYuvxxQLPu1P1BJCTeH6rtZ+vZtpxDccuJ5JiTzBWvc/bWHJChjjO8q+0pCKZHyKb9KpDcqKuGBrluh3qQ2CrhyRDpNQPc9Xh1j2ULVjC7VuWR/sjOUVqbgFE/Yk5yNG2rDxIFytzAZyoIP22Doou2ztfVjs2nZVJWrhayJoddKxdTDOGBYxUmscvkuthXpitZawypkcTbLo2jk86kYwZz+p0Djo+ujR3J4UEaGArNO4/v+TOasTVaaiMjL/ckNe97DX0xIRa/sf52CYYq9XIPyurbii5vhHgd9xaPdnwYuu481fn
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 20 May 2026 11:17:51 +0300
"Mike Rapoport (Microsoft)" <rppt@kernel.org> wrote:

> The xor benchmark allocates an order 2 (4 pages) scratch buffer that is
> used purely as a CPU-only XOR working area.
> 
> For such large allocations kmalloc() would fall back to alloc_pages() but
> still kmalloc() is a better API as it does not require unnecessary
> castings and may provide more debugging possibilities.
> 
> Replace __get_free_pages() call with kmalloc().

You might want to use kvalloc() here.
It is less likely to fail.

-- David

> 
> Link: https://lore.kernel.org/all/635405e4-9423-4a25-a6e7-e03c8ea0bcbe@redhat.com
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> ---
>  lib/raid/xor/xor-core.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/lib/raid/xor/xor-core.c b/lib/raid/xor/xor-core.c
> index bd4e6e434418..50931fbf0324 100644
> --- a/lib/raid/xor/xor-core.c
> +++ b/lib/raid/xor/xor-core.c
> @@ -8,6 +8,7 @@
>  
>  #include <linux/module.h>
>  #include <linux/gfp.h>
> +#include <linux/slab.h>
>  #include <linux/raid/xor.h>
>  #include <linux/jiffies.h>
>  #include <linux/preempt.h>
> @@ -114,7 +115,7 @@ static int __init calibrate_xor_blocks(void)
>  	if (forced_template)
>  		return 0;
>  
> -	b1 = (void *) __get_free_pages(GFP_KERNEL, 2);
> +	b1 = kmalloc(PAGE_SIZE * 4, GFP_KERNEL);
>  	if (!b1) {
>  		pr_warn("xor: Yikes!  No memory available.\n");
>  		return -ENOMEM;
> @@ -132,7 +133,7 @@ static int __init calibrate_xor_blocks(void)
>  	pr_info("xor: using function: %s (%d MB/sec)\n",
>  	       fastest->name, fastest->speed);
>  
> -	free_pages((unsigned long)b1, 2);
> +	kfree(b1);
>  	return 0;
>  }
>  
> 


