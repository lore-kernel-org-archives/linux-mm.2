Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 828AA105A591
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 12:21:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C94EC6B0088; Thu, 12 Mar 2026 08:21:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C56EA6B0089; Thu, 12 Mar 2026 08:21:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B62A86B008C; Thu, 12 Mar 2026 08:21:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A5AB36B0088
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 08:21:03 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4F659898DA
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 12:21:03 +0000 (UTC)
X-FDA: 84537320406.01.FE85A00
Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	by imf03.hostedemail.com (Postfix) with ESMTP id 7583520008
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 12:21:01 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=G1aDvRjL;
	spf=pass (imf03.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.160.177 as permitted sender) smtp.mailfrom=jgg@ziepe.ca;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773318061;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Y5rN+Dnt+nngZKc/HxpCY0GaFz9G0vHdC78c5bVshyI=;
	b=pYR8FPJm/5wuFF+lnkjKSJ7VbV1cCmC4/aZ99U9EWogBV48WLuhUxWWlUXaQM0rpM4V+MV
	ttJ56UbMogw+PbnJlgElgDiiazDmQnphXKg/+lqsUuQmSVhviWRTnt/v/LNRfwVYtOOaHw
	OfkqWMVmiCFhG4GGFO1RN2TvgEsvJ/s=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=G1aDvRjL;
	spf=pass (imf03.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.160.177 as permitted sender) smtp.mailfrom=jgg@ziepe.ca;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773318061; a=rsa-sha256;
	cv=none;
	b=Bg1Oh7P2ExezoxTBzLmb8Dok9+YCTJ7DcYdDpvbPo4JT2A7T0VH/tn92nnpcDlmOz7hikJ
	Ys3mqS9rmM9AD2/09EUnXx0mZTXlOJGx+ZbmRe0TNeGsiqPIRgGfOVXOWjroADN6tP4at6
	6ecbiYD0K+ch5xyHrzG3VP1vm1ZLtYo=
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-5090c48de85so11226531cf.0
        for <linux-mm@kvack.org>; Thu, 12 Mar 2026 05:21:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1773318060; x=1773922860; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Y5rN+Dnt+nngZKc/HxpCY0GaFz9G0vHdC78c5bVshyI=;
        b=G1aDvRjLlbhzN/k9u3/D4LxtDwMYZ6RCMd8+sA5ww7d3H4blhhmZUO38RGD/jzPeLv
         vp2AJKXAI3j4KNuIlVDQkY0m1eBBe01LZwsHTtdc6KT1GIHoi8cgd1poGsNpNmxjCA6k
         /PnZOXgkrBlBt5KY2OHkZhwvTtiVpAtUwlupBnk6R7x0qOdl144IRUF+DEuDRajkfeVZ
         +fEs/kYYyCLnsE934t6ewW+mHwugfsh2ra6yx0xJHMcAgcbBYGZKQaoQtAj0ZlNkiYeY
         F6Z3A+VHjcLhLGFGm0f5iU6qaIY5nemS+CCr/xEc67XR4sv5rxWxZ69xzbvy81yveb2W
         iIvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773318060; x=1773922860;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Y5rN+Dnt+nngZKc/HxpCY0GaFz9G0vHdC78c5bVshyI=;
        b=DSq0nOkkvych3U/r6F4eB8AUfUdnoG/a/60C4rmsoRucVa+qmfHI6J5EUYtRHuUyNu
         pW+ll568odlij8vBCxyAlctOSOXfXY3LXCeLeO7Pm8Gbasn4cneZ2oTA8Udk7v6PkkS7
         51yrPMCMK68qmrRMj4kmlSSSy2SXPSyhLIK4R6UfaFVLqEeHiYiZZ/+u28nTMJtpeFsP
         U84B/IYMmDgIa62gsMZd6elMTQa+4vLPNla11DoIpL8y9kIobbHHAswav72nDxiWs98g
         joatwWL7df8+BS3YoVaVWIjGcO/3F/mdNMHQkdu90ei8J+7zMXf0T8vEKIwl5381/48m
         K6Ug==
X-Forwarded-Encrypted: i=1; AJvYcCWRWINBBvhmq14OHm55VM/Om0nwpLSDr8yKpBtJwMmYnUxWSpNOuSOa9CYhjYDGgxZ0Ck7mEXnAoQ==@kvack.org
X-Gm-Message-State: AOJu0YxTQaYUWnYHLbebfSCx2xC5SD8dIVyjhv9RYckqExkHZ3rOroIX
	4lZS1pLR3U5/rWblmbalmvy5V7RXnl0kX/c39M8H6u+FFBfSnfDa+AYnUG6NDItcOWo=
X-Gm-Gg: ATEYQzwpi77XqlZU1x75uatzUXjp+2W2haF6Zv7Nl7dViXxR0F/cIgMUOUglC454jY2
	9z55HGeuZiuHXz71OwEoJL42oWFG+T1+hmHEuxo4CPebhGgs3jMpNWJfRhUA6soDssqwcgMnZA5
	ZPwDLuOT1g6bPYqzOEJxb+HCN66AwmZhnmWk6rsmow7Bcyyhiv78N+VdmPv06nkOIHdmNHT7ke1
	xVFLUDLKSG/eIc85Ph+Al9XU4HL8WMTjVwTPtkzbQbJ6mrADhA28S15sN6I9Q3Z86tDpNJfDCPJ
	IEEEcm+fPBVnGERpPXtgyfL06VbqBpCM87iHXDXDm/8ckQ46jBnt4kKtjGK1QxZNQ0j597c81kZ
	6DSfkWKUHsc9fAlHJeHiYTDTebftD6ZyqOF2nOfdi6xMq+Zl23g5L2JE06CuZaS0Tuhq92yuicm
	wSGecdY7VGQp0Ich0oGuSNwXw0CCkPjDdFDp05Yd1KV4VaZSYGnhAqCdM0gIR0oOW/luLKQd4Ef
	q4yez2bLBN2oj5fUEc=
X-Received: by 2002:a05:622a:11c1:b0:509:4410:4492 with SMTP id d75a77b69052e-50944104900mr62025551cf.22.1773318060513;
        Thu, 12 Mar 2026 05:21:00 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-162-112-119.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.112.119])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-50939ec5017sm30688511cf.8.2026.03.12.05.20.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Mar 2026 05:20:59 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1w0f2A-00000006et5-427z;
	Thu, 12 Mar 2026 09:20:58 -0300
Date: Thu, 12 Mar 2026 09:20:58 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Leon Romanovsky <leon@kernel.org>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Petr Tesarik <ptesarik@suse.com>, Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>, iommu@lists.linux.dev,
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
	virtualization@lists.linux.dev, linux-rdma@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v2 5/8] dma-direct: prevent SWIOTLB path when
 DMA_ATTR_REQUIRE_COHERENT is set
Message-ID: <20260312122058.GE1469476@ziepe.ca>
References: <20260311-dma-debug-overlap-v2-0-e00bc2ca346d@nvidia.com>
 <20260311-dma-debug-overlap-v2-5-e00bc2ca346d@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260311-dma-debug-overlap-v2-5-e00bc2ca346d@nvidia.com>
X-Rspamd-Queue-Id: 7583520008
X-Stat-Signature: 7wo8a9jsqu9dzx7fyxo3fapfz9go1ezj
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1773318061-732300
X-HE-Meta: U2FsdGVkX19ASZP7eZLYt5GisaljOU+VrEGdEVjVxOUzMPiY1AyTAHX36C7LKmjhOYi+jV9MYlCLwvyng6D3vIFT9EZ6zffeFAd2nU9oD4Kz9aoLtrz3LOeP01D2dXTSOGfZkTX8yAQtDwEM7hP6YCil+gXC1A0qM5S4zPIJhThqZAQqu7zz/USpwIjgYGTujWacUEXaWmovnoZ41a+IC+6l+iz4hmh/J1qhBtKYvboLorK7AOwCB9tB1JDBD5cdOCSL5KT23/MbscpbKuWLyf3/KAxYBRzJd69pA4P7XvTlhId8fiFkt3DXMBnzS+IXYxx/AysHO9LnRq1R0Q67p5D4+pv8/4wQevc6ioztdduihiChk4v6ZI27i4cDiUe/xNYXknUwaMqqWbACaPyOm7m1SKteGSg2kdZap35ceHj5bwZgemnNw1IvpEXH3g0Yb9GdRaGscqOk8Su4+0+R2eEv4tLjXaQjrwLjKGLyRJOn4bBCAfltAtpjCpUbI+skNmUZ9D+8RfuNUr67j58TPGZM/tbsZn3KbhnmsB1ASIMDq2QwGBfUgkW/uisB6CRCPdGUzlPLX/qHso1gA/0DC4bIcvZdTUib5lZSgtNp1nGBicnDfABFz8qsmBZ76C+4xmz8dMkZk8dEGeFKecGyZr7tTtzuXfvE2Xw8rraIOFRQLcES7jpxXVFxbOpBrnJLoSFTTU3s5YN8p88Gun7QmUFjmHWjlt0hmYTbtaLNjOHG36l9bRBN1o3qKRK27BiT7tOw6NrpVoUSopw7Q2ktpbGO7vYdXOutXhetM7zMQjGlx4dsaRW7msxUfh6yoyelH+8/S1zNJ1EuVGgyxh45xaN1nJQ0xTwcc/EwpOrFLD5Dw37F5hWQ5/x+alvpHwNJJPm7IT+FzE+0BDGW1MtGEblYXohSxEpuqbNrUEsMFuyyo2j8YQyXW+dn7vnjRAk3xBHYs9X0U0+uM8gkj7+
 N4336paN
 3OythK3wGWvJIJWFASYTSAMJY4GgBZAgGqqnkdg00ReO/3oiyaAry9Cvl52HQ1sLP7kwegOKlAKm+Jq8a3IIPKGTtkD0owPy/JrD7Y5Ew92nmDi9sC8/pgPi0L3MmD83TyrxAV2vLyjnMsFTSUkxwQNp2Ecv+YVy55D8mWLT8xzZRf2yqa1bSReQ9G/6xSxo63BjXlGVPCwC6LdaUtJSzycubaPZcDpJi9UWxxi6Ft+xNOvdB/q2FmIO53leyCxlG/X7ZPfJdyKlUmoByhFU+GVKiY0V49eGrhCYoYjqqIy7HM+N1zDsxOrh8dysFiKbXwo1guANmykVEaOD20rV+kigUnjlRMY+L9lGp0AfuMU0bw4s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 11, 2026 at 09:08:48PM +0200, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
> 
> DMA_ATTR_REQUIRE_COHERENT indicates that SWIOTLB must not be used.
> Ensure the SWIOTLB path is declined whenever the DMA direct path is
> selected.
> 
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> ---
>  kernel/dma/direct.h | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/kernel/dma/direct.h b/kernel/dma/direct.h
> index e89f175e9c2d0..6184ff303f080 100644
> --- a/kernel/dma/direct.h
> +++ b/kernel/dma/direct.h
> @@ -84,7 +84,7 @@ static inline dma_addr_t dma_direct_map_phys(struct device *dev,
>  	dma_addr_t dma_addr;
>  
>  	if (is_swiotlb_force_bounce(dev)) {
> -		if (attrs & DMA_ATTR_MMIO)
> +		if (attrs & (DMA_ATTR_MMIO | DMA_ATTR_REQUIRE_COHERENT))
>  			return DMA_MAPPING_ERROR;
>  
>  		return swiotlb_map(dev, phys, size, dir, attrs);

Oh here it is, still maybe it is better to put it in swiotlb_map() ?

Jason

