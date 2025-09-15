Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C49A8CAC592
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 17:16:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 18C7F8E001A; Mon, 15 Sep 2025 13:16:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 164298E0001; Mon, 15 Sep 2025 13:16:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0A1318E001A; Mon, 15 Sep 2025 13:16:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F0C658E0001
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 13:16:55 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6370D11A794
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 17:16:55 +0000 (UTC)
X-FDA: 83892139590.30.77827BD
Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	by imf19.hostedemail.com (Postfix) with ESMTP id 6A79C1A0009
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 17:16:53 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=TaXxouBW;
	spf=pass (imf19.hostedemail.com: domain of mhocko@suse.com designates 209.85.218.50 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757956613;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RAiJK2ZmQHbf+XsggTwiJACjPN/xnPzz5AX7w8mTZs8=;
	b=D/xmxrjjVJ6h5y8gNWvEWcNDz+oovIK/KWoAhkEzcKQ4at8jWqif474V2NGpnoZr9L43XM
	YdPyQuExnSbPXn9H22wJ8esYNC/0L40N7Ox0/MKIQAvI/HjY/SGA+bN/jGt3BpBuZb+fdC
	iVzsV2zLDztJSaUcW+B9dlttdha7f6E=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757956613; a=rsa-sha256;
	cv=none;
	b=pbynINrS74rm96mjLNT6obaY/64eofrxVE6/mdemS+ZXZuZVZ0bTj/g3BFgg3f4CvT6gnb
	29iWbNt8AXkkzwOPbu2iGjZ3CYaPlS+3r6MHd4SnDYPVSs/HpUnc8a6QpWRnpvNbmaFvdR
	PUrQCcQoUV1pQ4PrjIagKXQBf1cNMlU=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=TaXxouBW;
	spf=pass (imf19.hostedemail.com: domain of mhocko@suse.com designates 209.85.218.50 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-b03fa5c5a89so706220866b.2
        for <linux-mm@kvack.org>; Mon, 15 Sep 2025 10:16:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1757956612; x=1758561412; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=RAiJK2ZmQHbf+XsggTwiJACjPN/xnPzz5AX7w8mTZs8=;
        b=TaXxouBWN44/nwMtgzCmwYooxv0R9hQcv5WhI6jsRGWX/CiCsHzfgZWkJ/MUb3fc3N
         WiG+DpTr7k1ZB1ulCEpIcUp/njnNFiaMGt7CPDYVDwFhq2+MN7dX5w1sYyAp4fS9p0Bh
         halcU/I6vrPHoLJzNsghViuu1p3/m7OD16XpcY8Zgjj92/xVnukH3S2AMqZXgxJ+Pg1M
         nLI8MN7wfM2pMS4euOJ7gSHjJjyB/DYX7EaD6arQIgPYtKs0MyZsqzlIwcjZJbpYq6cc
         dHCHemHy49+yg/cG3zH5N9S8nOQzov9vcaCbtjJO/vkW6ti8itQRVeowtjxzCkoyBHt7
         CMwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757956612; x=1758561412;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RAiJK2ZmQHbf+XsggTwiJACjPN/xnPzz5AX7w8mTZs8=;
        b=c5+0EsyzpHKqq9D7p0kdVASKvjbonKyFoys/7jUJKyEYZgRIpvN8Q80d7i6HWiGBDm
         DoLTRo4j6VzJiqoQI4RdC1nzCZB9YNO6j645BediWZZI70ubSUVLVwxt64Frb+Ga/QYx
         0FNwobnPWqnrfLRSaqWIctlLHkg2YBriE2O6Z6rZ94d5Qol/Jc9H1s61c+eDZa8f8wuc
         cuFWXtckK/6umTWM5bpdbo2kVu+cnjkik5NvDXMRY6TtyF3cRp4spFIBqLJNVflyvoYH
         o4zWvpIk8+IixzwtO5E+fL4RR1qWlbsTk5/TnJdFR/Q943GMrfYXQjtV53/gUOiQdpMK
         TAZA==
X-Gm-Message-State: AOJu0YwsZHfGSW5zBhwa8Q87piZOvoAZ0XIz4CAPGX+c++Ya1m7I7IKj
	FGo/wwu7SjObD/bS1uW0FgOOvFcWsy42taMhTW1hBwPDnJKtHPBoBfmDsYEm0NnVVtk=
X-Gm-Gg: ASbGnctr7YE2Fd4W9pJ77KU1yOJw99tg/g6mt1Z45sK4qWDReu+rW19gFQ2ZeXOAmAk
	dlFkU769ebIkpyA67XvQ4gRDCDFT/j8RAFZAHsCH6cT0UqTltlVEgO7/eZUFBactovGPay+mNPP
	Ure6s//QjJEeHcU63IvLWWXFnE9juM2TW5ns3ZOtig1KqAqYzMl74Cz4AP1yB7uV81B/vosSKIV
	jMgy2jdGAErlKslkeiGI9D697nohUzKQL2DS0Z51Xp0ljDCYaxaDW0gaEC7qofgjTimKfagHDX5
	KMufnt/v0AHGaM1Q6No5o3xyhcq+ANTyc1AeDO5i+o0IVX4kWsUS6/Npp5n/fG0PvWO+yMLsOLu
	EiR7JuQT69P3PIViWALrEvle3UTPVqlgjJg==
X-Google-Smtp-Source: AGHT+IEPlhCgQvXW5ecZ05x3+ZOUWzRhnk1+vdpPKMe6IRBsIEOhPs7lQfUxpzPTmduP+XwEQYObNg==
X-Received: by 2002:a17:907:9301:b0:b0c:6cae:51b9 with SMTP id a640c23a62f3a-b0c6cae670fmr760718166b.45.1757956611928;
        Mon, 15 Sep 2025 10:16:51 -0700 (PDT)
Received: from localhost (109-81-31-43.rct.o2.cz. [109.81.31.43])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-b07b3347b6fsm990538866b.111.2025.09.15.10.16.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Sep 2025 10:16:51 -0700 (PDT)
Date: Mon, 15 Sep 2025 19:16:50 +0200
From: Michal Hocko <mhocko@suse.com>
To: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
	Baoquan He <bhe@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 09/10] mm: Skip might_alloc() warnings when
 PF_MEMALLOC is set
Message-ID: <aMhKAnO1MmkKHTO-@tiehlicka>
References: <20250915134041.151462-1-urezki@gmail.com>
 <20250915134041.151462-10-urezki@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250915134041.151462-10-urezki@gmail.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 6A79C1A0009
X-Stat-Signature: rnheqpfeue4s6yktofe1absut3ahjtj5
X-Rspam-User: 
X-HE-Tag: 1757956613-585569
X-HE-Meta: U2FsdGVkX1/vKEeC5PGiOvkOf7+4lem9q1KheaktjWpq2kHVznS8NLSzHXBot6dLLgULraZrIP1v0tLVXXeg6IkK4deylbZb/YnWl00Krymbzgg4TV3osSQG7RAUuzQ6M4egFNOq5fk6LV8fCrbEwhXp3RjDvyazuXq1L4uLyiEmKjBlNGckpy3Ws2E4dtDaOxA9N4AOl//KAzUZohqMdN0i8LtRCjw8l8y8+/IIZQqeE+tCPpfcQ59d/JzBPk4P6dfEeL6B5zLrVMJJeI3F+gUZx0vsWYsmKvL3vmOX3hjXECxHtFInTdeP2jnJvUgofnx3ogQ6/kZSdRPj4Ynzfb2eTxuVCCJE5yRngnRIOcFPUPxOJ1K8SdS9BQKJyjzxGJqrl8gzGiP+CQKNox+yCAZPj6UHH8QyYbHdAAbF+v19gWTwsymLk+3Xj5Vu3TivUb02upOD75EYM/a76V75rDFhBuBPuDUz1wTXBRGLnB4Q2RTwhjaz4K4VnfA/kYNyinXQ4nVYOivAdIXkfTyD8yQKfVmWfa/0YghKMMjR/wUt+BuarRMsMFethyJmvxjBjDPlomfKOlugq5BqiKKhK411fI62Z2kTlv7+1pNuFwplgCXkkclSajV6poWK2tvzdVKa4iigcIxqqmIm70UwNfoLLy2SDrzl/kl1cob87l7c413obBX4lSeW5G2t3g3PejF2fhjaXXzUiFpz/DGGLa+MIz+IuaA6VONqsC7UFNSssBkKDfiUlScsIQlOuuqVgwQIi92vpcyJS6rZZCslwXZ9SDbLvOL2eZPpyT8JBOEmeKKi2NEzZQO35d/pDYmj4ZjYEbMH196nubveOlaWrWlWZYP7GT2xNVEDFr+q9ECYezHJPo2gkbeE58JzgItERICkzOgLmxMdxjxhMXgbZCRHpOXCLGDuU3fHxSFs6y+8/Rd4TUZdQABg2fl4JBFMmN7C4Jkg6eqA3UEfxXD
 BQlZgE+5
 ed9LsRPQzuHfqGIT1ewOpAvw12ufAo1h5TWy8KB1CYtR7LqyB1pc3CFgWWCIYTJLCS115lNGjENUtUbslh+uSJ71zW3tqjjOU6zx/Abug2T62xd4ZUA+9pfLYY1tbWh8sSC6EftEDvsfXuxlzYvsj6NgkT2Faix86qM3Mo1IKD4Rsj0irKbqOivZJH/rRPAosWFPBHSBt3ZQSogqK8Lx+pfhLZc29uGs2p1EoKsmBYu2GF/2f5acSia2XXNXn02CZbRDWnf0IoFtNBmUFZz8isEhsdNyffigQ+nELb8DrxDvuVBeKoOM63up5KhTI3wCtMHrIcqFPpc9Qg8Gvqqus/fW/t7j8SKnLfuT+OBgm0vAo7UHQbfme4VbY7HC8hCsyUgBLXv3/BZUj5NCoTEqXRpe2DrkrQT14T5R9WzXXjqPAsfAYN+cjQRlJWiwVIoahoJvX
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon 15-09-25 15:40:39, Uladzislau Rezki wrote:
> might_alloc() catches invalid blocking allocations in contexts
> where sleeping is not allowed.
> 
> However when PF_MEMALLOC is set, the page allocator already skips
> reclaim and other blocking paths. In such cases, a blocking gfp_mask
> does not actually lead to blocking, so triggering might_alloc() splats
> is misleading.
> 
> Adjust might_alloc() to skip warnings when the current task has
> PF_MEMALLOC set, matching the allocator's actual blocking behaviour.
> 
> Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>

I would probably just bail out early for PF_MEMALLOC to not meddle with
might_sleep_if condition as it seems to read better but I do not insist.
Acked-by: Michal Hocko <mhocko@suse.com>
Thanks

> ---
>  include/linux/sched/mm.h | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/sched/mm.h b/include/linux/sched/mm.h
> index 2201da0afecc..dc2d3cab32ef 100644
> --- a/include/linux/sched/mm.h
> +++ b/include/linux/sched/mm.h
> @@ -318,7 +318,8 @@ static inline void might_alloc(gfp_t gfp_mask)
>  	fs_reclaim_acquire(gfp_mask);
>  	fs_reclaim_release(gfp_mask);
>  
> -	might_sleep_if(gfpflags_allow_blocking(gfp_mask));
> +	might_sleep_if(gfpflags_allow_blocking(gfp_mask) &&
> +		!(current->flags & PF_MEMALLOC));
>  }
>  
>  /**
> -- 
> 2.47.3

-- 
Michal Hocko
SUSE Labs

