Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 300AA606A31C
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 11:57:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=CP6n/5TD
Received: by kanga.kvack.org (Postfix)
	id 5349B6B00EF; Thu, 29 Oct 2026 07:57:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4E4B66B05B1; Thu, 29 Oct 2026 07:57:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3D36E6B05B2; Thu, 29 Oct 2026 07:57:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1A9436B00EF
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 07:57:36 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9A13C1A03BE
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 11:57:34 +0000 (UTC)
X-FDA: 85375514028.05.7C36756
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	by imf12.hostedemail.com (Postfix) with ESMTP id BBDD340004
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 11:57:32 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="CP6n/5TD";
	spf=pass (imf12.hostedemail.com: domain of azpijr@gmail.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=azpijr@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793275052;
	b=EfBUtiTN051XyDV1Q8Y3GsTbFwd5PJQZH2sSxA5fDjWv8dCiQd7zWx8R6fjJ6OYXQTHBaB
	ToxfUyOlXjIEt52uOj2iNwZEJqCKHtjwqUkeh40bXIFb2DUm7uN/j9MPi/R271b8Zn4gPn
	UjLH14x+BeaPkW9rzmIAv7B9EwUN1kY=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="CP6n/5TD";
	spf=pass (imf12.hostedemail.com: domain of azpijr@gmail.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=azpijr@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793275052;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=85WNzndYYnYjdw+c5+YUiQvdyptr/w4CZ44uKXD8zJs=;
	b=LonpoU7oUGfiRtdEXXphPaz0sNvIviO8P6BJGisNMjiBK38fk00dTUFnR31sM0HFOJFG5F
	i2Y/WAoT6dRsexb8xe7m0vZQbCAMtBNvHbWEUb8E1giAcgLc8gWF9ETpXsdQjI0g6pU2aH
	3qnTce2MNbMa5OQgV+3JpF7UvViwSSs=
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-4a35d5d4a20so22290605e9.2
        for <linux-mm@kvack.org>; Thu, 29 Oct 2026 04:57:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793275051; x=1793879851; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=85WNzndYYnYjdw+c5+YUiQvdyptr/w4CZ44uKXD8zJs=;
        b=CP6n/5TDuU5KUGfj/8TJAqqagwkVkDDwasoCI+Jy/4utDWlanIH0i7z+Dfn1Y855Gh
         TaNtonrvZ+I2x/yGNOWa1DFpxUZHzBM6p1l5yVJH5vNSMaN/1SMFD6S6Y13Mnw60ihQr
         i17We7uW4xZettrL+igycRwDtBWx2qR6f2yUeBdtoJKHujHtEMph/D2l55ontBp5Rxne
         8q9SWriCpRxTocyeHPVLE0I97RjhLBMWjfwZqiopiCPznT1d1qcfy6C0EtYv2439fR7r
         WkLMV73GR3lzHFoEwPhgueXfK8KIi/UklJM02BgbqbFFAN2M/cYlT0OrI0dhdWNf0PW2
         BE3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793275051; x=1793879851;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=85WNzndYYnYjdw+c5+YUiQvdyptr/w4CZ44uKXD8zJs=;
        b=ziIvOZiuOzmKRrTkexGQJggQOTuSA4i/s7QX+Kae/jNJH4WEGrwcsu4qSIGJC6thGN
         TiaOrYlR3XtVkbpuUNrQRj+J3OqWXMhT1WAzUBkSTQab9GklkYEF2zYtZOs0wKGzAh41
         HQO6zs8zmIc9aywwhoGsGLcuRoIjc7nqOvVUee8s+OsulSJlpmC7mqIEtWhn5dQUAmGY
         oQQ5h2l7s5ZvnA1a3uCHTQ2SUNEHswjAZmUWpUqrUJxp/HVv3UHRYmnC5g6OF3ePHh87
         B8t9a/LcOKqwQ6f2IFFuvzo3uSm909pMQ3fWwTqdsPjh1KuxDYPPW6tItHiiMeZpZ9ld
         O96g==
X-Gm-Message-State: AFq9FYJT/oMu8bnn9xkYCOx6MDIZrX9bOoZzBBkLBfYKqv2PeLs4M/LZ
	r66heGmIN5Wmw9M0YCb7U2gGXOVsXfU2BAS6Dip2qD8CbtHxGP2mxBST
X-Gm-Gg: AYBFou1U8vb7WxFgHHprd9VhrXuegGH9fKbO8FKFDRAc68yzwwA5dyqbwjM3izTRz91
	FZP+imJrmZ+oOplyhr3lxIM1ndt/Pl8DZLSXAtQLogpKrQ9uZMnd4MOCRaRr6anOFEW429DS4BQ
	XhHvFP9TmqWfl3g0dc3Vokcf58q8I0NIyhMJ9pS1a5cRX7l2jdEQvAL0OM555dPoLRhX6nIgSuH
	5G9w5cQj39BSyEwSF/Vao4ECkNrACJ0lGAzeLx7vhi4w0lRHjTqHVquNtwbSpx+yH6CYCfQOLNh
	3DOJHgot5Bw4w0JZoqDDM//E+AbhwrbxGOnyhNVi6M7gcAsPiL0eE4oMNL/26RBqJ/oWA0YfQ1x
	pYtGltWxfF24KUsyGQHk6Sle9lJNOsUk2WxtdBjNVIGWrG4lRlV2ll5PGFLq1Pa4Pvu98UzIHCg
	wL0XhDzua5JFnSbtau2LqGKSKhV2PfwsU8dDbnA2jWud5gs9kIdDDY5zCLJ2laTv5AdBtNQ+j+p
	wh1egwzViAjatfqCBCNrOiKvbpyI9tYztunuwe60IYa1ycAh4uYDGsj91UMwIwo3Sh8M3dK0LSW
	6isQsrRf9Lr7yj7+GWD3OVgnX0IVJIqaMK8pjCfJrBi5xQ==
X-Received: by 2002:a05:600c:1387:b0:4a4:4d57:8487 with SMTP id 5b1f17b1804b1-4a96667b9f7mr114934065e9.5.1793275050100;
        Thu, 29 Oct 2026 04:57:30 -0700 (PDT)
Received: from [192.168.1.22] ([83.231.69.9])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a966a56abesm79733875e9.0.2026.10.29.04.57.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Oct 2026 04:57:29 -0700 (PDT)
Message-ID: <9f0f96ca-86c8-4732-a6bc-a7f955873ec2@gmail.com>
Date: Thu, 29 Oct 2026 12:57:28 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] mm/vmalloc: drop VM_DMA_COHERENT from
 remap_vmalloc_range_partial
To: Ye Liu <ye.liu@linux.dev>, Andrew Morton <akpm@linux-foundation.org>,
 Uladzislau Rezki <urezki@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Ye Liu <liuye@kylinos.cn>
References: <20261029-vmalloc_remap-v2-0-c4705cbf26c2@linux.dev>
 <20261029-vmalloc_remap-v2-1-c4705cbf26c2@linux.dev>
Content-Language: en-US
From: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>
In-Reply-To: <20261029-vmalloc_remap-v2-1-c4705cbf26c2@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: BBDD340004
X-Stat-Signature: 59wobrp7qq8w5pkbnmzbwq9ypnwrrj4x
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-14.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793275052-662400
X-HE-Meta: U2FsdGVkX1/naLD8vXWrgMK1aQ/vW7pgn+plGBFAhcMB0HKPud/qXLuSUKNUrChII77gbzC2f+IUOAajBQXXozmn3msW8P2wih5ohj4tjMl22aUxlW32Zg6VC2N5LCUYi9iWqbPDrNBBQi4U6LjX//kTdLeWQYSS4S/cVHcivIej5PjeMcTbVyMaXV252Er7PhlCHIhgK1tZtkf+HMi9CwsmBTMZ8x5LudcVOBIqoigFkzW8YsHM2dSPK0vKJO7ixY8OzofnR1aQwq2rLAPnZks/8/ZYIRq9K+qggD5XZfb+pqzMp6kxHTsOVpDm4v6ojbPBGiwL/G5VTqRAGLnq40+PA5qnxL5wl+/j5PYxS/kL8WOl9HRrfcGfyH1JOkBp9Deuh+wnuZnPYDpXziqqBaQHRZgfKVGhEXn65pT5IffI3dIXk6hxcGkkqgtaR6SnFhHXg+uUwuq65XpgIqrl5gj/PF0XNVn5NWssqYVJS02wylHBHkm3KTqEEeqAMDPrO4PHAd5d/oa7DJWTriG4FvqSrO4ECCgesdH7sAEfnl5SmKxLxc/ARWEdVyiGgzBnTiO9XaKTNNCK0vUR9oJVXsky0WdnyxZEHm9gcNOBvxXUvuLIm+k4iNv8htYMytDVLO7177opP6DJMkmW0YG5C0RviYsMqUZxDXiCVMcjlmF7AAnLHphZyIjy5SUBnkgVUu5Re8Z5Web0nN7USBPFhCwXFHyzkSikBTkufSufJUbLD8WkHMtYBaAEGV/Eup8Li31wytegtki3WB/31aPR2iQaG657cJIkf+xg5oykxtdolch1+4Vr8uPtHhrYB5I9bj4J8tZidznB2Sn+dQt540va2ei+qTCcUHHsQ7C0Ip+PuyKPIc4amFvSSJ40asuX3Kuh2j2RrpCEq511bk4hUIcBG1qvlaBgABrnsL5UYcdSPOyeat0BykWAffWXSVWRBYZ8fZu7K2Ma+OmG4Dk
 XjwGigY2
 6gW6t97aLCpQz73U2phxRVIMA4lQAVVbO3uTyUiKx87odSwFH/WAnBg2Fq6l5N8Y2Zb5WpzUHlpUVyQnCUHexFY0Ex+3d8LhxWGIAqdaJO/KWX5NrRW+5OqU42W3STs9nAJAvEnPkZ16ODAuhaVaXq3pnGWWltjrfpOrKdh7FlUcxg9NoAJpn0Qf8OIn8P91xUHWuBObG6PifyOYXBoKtdx1v7cymbH/oZuek04MmQDVschpRLcIkNO0ZnYtjecmHbCvg5ucGkDSWxWwa5SJdYSQriY1OnFkED83/LV9YRatpMXffbSBSAGLNKcM5HKQ4Hfhl/OHc42clkoI8e5hNn79als93cYhv+r4ADKFvMRYSP7MfwSg8cmS5XByoizKhXcrAKyzg2WfsDhVdGJe4d26PL1gACxfaE+q0oL8ypFosguLUiS87Bwxhg0L5O8dgvdYHSNtP/4uWYbb5iCGyDvd2uuroeIAHMgENVf5uNiFuTAqfh8Zy7mhMMV7u4ZPjn7to
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/29/26 10:19 AM, Ye Liu wrote:
> From: Ye Liu <liuye@kylinos.cn>
> 
> No caller maps a VM_DMA_COHERENT area through this path: such areas
> come from dma_alloc_coherent() internals and are freed via vunmap(),
> never through remap_vmalloc_range[_partial](); all 13 callers pass
> vmalloc_user()/vmalloc()-backed addresses.
> 
> The flag was added in commit fe9041c245196 ("vmalloc: lift the arm
> flag for coherent mappings to common code") as a mechanical
> translation of ARM's VM_ARM_DMA_CONSISTENT.
> 
> Drop it so DMA-coherent areas can never enter the path.
> 
> Signed-off-by: Ye Liu <liuye@kylinos.cn>
> ---
>  mm/vmalloc.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index db669103dc66..a888eca016a8 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -4894,7 +4894,7 @@ int remap_vmalloc_range_partial(struct vm_area_struct *vma, unsigned long uaddr,
>  	if (!area)
>  		return -EINVAL;
>  
> -	if (!(area->flags & (VM_USERMAP | VM_DMA_COHERENT)))
> +	if (!(area->flags & VM_USERMAP))
>  		return -EINVAL;
>  
>  	if (check_add_overflow(size, off, &end_index) ||
> 

Reviewed-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>

-- 
cheers,
jose a. p-a

