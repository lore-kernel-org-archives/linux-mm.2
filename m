Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7D74A105A591
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 12:22:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C7EBE6B0096; Thu, 12 Mar 2026 08:22:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C3ED46B0098; Thu, 12 Mar 2026 08:22:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B4E9E6B009B; Thu, 12 Mar 2026 08:22:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A460E6B0096
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 08:22:23 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5E12E1B6E22
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 12:22:23 +0000 (UTC)
X-FDA: 84537323766.05.CFD1883
Received: from mail-qv1-f53.google.com (mail-qv1-f53.google.com [209.85.219.53])
	by imf10.hostedemail.com (Postfix) with ESMTP id 7FC50C000C
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 12:22:21 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=otgO+d2l;
	spf=pass (imf10.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.219.53 as permitted sender) smtp.mailfrom=jgg@ziepe.ca;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773318141;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TimmS2+Pbosg7L15RHI5hJFu+i/J4kMKaqKEQ2F4CiA=;
	b=E/TqbMsSVbNvAKp9LjPP32IRmE2e4jhXC3ftxdH62PBIaPCX6zqXQh0kqeVgvmC1xRBsX6
	oRVeD4tcde93DZVExYmXNm2+/GUM67VJ7XXDBDJETVmQVcvhOPStK3Zzaf+SPS/S32HVNJ
	P282XK0OHuVJBPrVQbTyVNOi4/l9iV0=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=otgO+d2l;
	spf=pass (imf10.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.219.53 as permitted sender) smtp.mailfrom=jgg@ziepe.ca;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773318141; a=rsa-sha256;
	cv=none;
	b=p+eh4F6W4pWcv7nlZ1/B0c/kkuNV3OkmHbk4I5UVXAn+p4ZR9jWXCSbzkZTIQ0mO5Bd0jJ
	eKJH/6UdLtdPw474uNtahewgOgslxa+42v+wtWnn5YBshCMi5Xiy/Dt0Zjnxw5sHi9Z8II
	EJVxWAyc0Fb1rw8H/npLksPzU16aYJc=
Received: by mail-qv1-f53.google.com with SMTP id 6a1803df08f44-89a0d53f3d1so12665966d6.3
        for <linux-mm@kvack.org>; Thu, 12 Mar 2026 05:22:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1773318140; x=1773922940; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=TimmS2+Pbosg7L15RHI5hJFu+i/J4kMKaqKEQ2F4CiA=;
        b=otgO+d2lfhmCJcGsARp/V+f2TCOcyrFb9RApsjotn+PbOPedpUl8lR3XbMuM93GtVE
         HrtLNS6RtYv1JuPteIoTIZlOXH9B1RMo4IifViDZKBGaJ8dxtfmqfGrI7yqIVuzekicC
         KOTn5e2DvyFRQv8L0Z5//a3T2KRhqYfjUJhPTpg9zm8+0LoppcvyVkZjvk+wxcdpV43v
         lBjrVH+iaEYMm08FCHIiQrYnF6jk6mVKR0X69jUbK+LX8KhlHkzqUBtqNrTz5vLCayLZ
         LVPR+XKP4EJXdO+M4oNVBF0Lr6R536HpkJ1oG8R9u6yFfdcub6KTxnT2C0s93xP4fJdd
         mTGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773318140; x=1773922940;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TimmS2+Pbosg7L15RHI5hJFu+i/J4kMKaqKEQ2F4CiA=;
        b=Euwd5dekwmch9yeE0QffqQeZQoY1xB+Y2hQHcV0u40eA0ivt1wws1cqAvHXIXJR24c
         slolaYLHnjnqJmgO/OVYnx7+86fqIjU7tdFRhhui64i6pgXa6yOpHxaj4cflQTS9kjD+
         kSHzNx3MVVgbl8lC/eJcxF2E/OUKrlE9/bAOInaRlJPir6HivBWtSePOF8IS5WaUtelL
         3y2U37L8wom45EUQnxnASzw4CTLphpPbn6j6KsikYjefFmgRNeSN8VbBfrA6DH6US1vs
         HQIsxVNwup+kcmbUbUAHJUJaeXsA1BU+q6ApnhZdYL9zwTe6wSFP3EUxwk3UQKE8nmAS
         7qiw==
X-Forwarded-Encrypted: i=1; AJvYcCUy/o1oFEbkUGLgadYpVyy8bIo3MQvnMh6R7ngm6BH1xA4zl9pqhdphbkAHPGE/b0nUUF/tBu03Ig==@kvack.org
X-Gm-Message-State: AOJu0YxOqXIqGEjSgohym3emS9pILWbz8zIJ7WTXXqsdfDd2wDgDgok8
	aH4+r7oGF+5SFEEoThcM3CavZ574IC/ByXUr1TpmWip+37eJLVzGswjyzr6adtRcHEc=
X-Gm-Gg: ATEYQzx9I6AaD3jBuSrhfV/WQ+/LaMSvoYZiN26OtHPp85SQSnfQdeGLBg0YSw/l74Z
	fzW/K2hUji0K8Yf0PzdvMkqkYrdAK4Gai09FQPmxXoC1ittE0DQeY8yx6VGgGNAa0zeWFVapWN2
	Q+XM9hEm5esSoYmEKE5ya+Argi9w0UKytttyNF9lkpFMmICaO+EH1krWN5o69V/g3y0iUrEIh+s
	Vxxwe0g5t3+qXjSFgRW/jBSkkcfA8oULVg6LrRtVhPcCaBm/x6mj6KXpnMG3QXT1aP5FNrzkJbp
	s4YNR48Mb6EL1LZYq4YjOoC1VXRUm8gFPTmsDbkvvSSfywe/5FypEjRJqPLvHqAo1SKyAfJuYNo
	okTmsc0PD8iT4pEUr1lJ6l13Le+2U+E6GEUCLBq90lt688JcPl3KLT8KXAsXU34G8wiroAV2cx1
	XvEemv00sjGogMsYIsIYvtKA+nX3eSVE5d5Z9y5qY/rfYxnnMGRvRSuE0tZDpDJOVira6cRAGVs
	OJ/GVbE
X-Received: by 2002:ad4:5aeb:0:b0:89a:149:bef8 with SMTP id 6a1803df08f44-89a66ab8864mr83684736d6.47.1773318140521;
        Thu, 12 Mar 2026 05:22:20 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-162-112-119.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.112.119])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-89a65cfd520sm33832386d6.36.2026.03.12.05.22.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Mar 2026 05:22:19 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1w0f3S-00000006euK-0fs1;
	Thu, 12 Mar 2026 09:22:18 -0300
Date: Thu, 12 Mar 2026 09:22:18 -0300
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
Subject: Re: [PATCH v2 7/8] RDMA/umem: Tell DMA mapping that UMEM requires
 coherency
Message-ID: <20260312122218.GF1469476@ziepe.ca>
References: <20260311-dma-debug-overlap-v2-0-e00bc2ca346d@nvidia.com>
 <20260311-dma-debug-overlap-v2-7-e00bc2ca346d@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260311-dma-debug-overlap-v2-7-e00bc2ca346d@nvidia.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: 7FC50C000C
X-Rspamd-Server: rspam08
X-Stat-Signature: yybhy9xctxpc8oth8se7xuhh7n1qrz18
X-HE-Tag: 1773318141-555877
X-HE-Meta: U2FsdGVkX1/Nkk+f/aaNQh8dFeClE0Sjql2cGkqQhvcnxLPhGQq8G0FznZXBB/jMb1vEsHxz80HpAHz/Lm5HSUJQDgyHoYqxguMjJ1M4MGB5olkKhCRYko1qivbeTHOaPWMSW04SkElwR3a8+38LtHrhowGmtu9tPSOTuQ/+sZuG0yiktzMedjiBaLuPlDqp5AJYBPQtjbJ2cLmNcUAX2HCa67ex5HmuBdAnnYg05h2hUrIccpCvuKGhBLlc/Fd8yOucT+7snM+aAwK1c9cHQ2I/+0P/kBBYUTO/kkTdLsuuZS2AAhEMV7lvB0CZNxlPE4pjaTD2g642+rAWJos4Lcf3qa8zPUdAW7equVHbUEggRMID8L9266N5WrwTuKKqLRwXh9fZ7shCz4jkxJyS9vzMn2TeCszPF5d/A58Kk1CMZ4fnt1FtPqjfLwJOxJvB8l2LAd1R19fABFtv68iqXpi0xLY3OtsDKVwPajI+evAfrWNxIhDpyLpKBOMiXLTP4a0AsX6pXO9qtbR1zCQmNCGDRUZ9qvQfnqzRzx0EXpNDzwkbouAhUrpjI8aiaQjzmfI0mXAjStNt6lRrekh5+rG/6TQ1s2015sldxSH59Fozj/DpZTZXS2SaJ5I7bXvkBcVvHIb4dHcZPrFX8rz6GrKaKZx9gEtb7f4/RNPfwujRyVg4t9xwXTchp96l+pHw1yO3NpukuBFGkai/hOt6q0vSfGaVPU3UThnoquD3BKSSkw/WUYArnX6+8serv0P3DQRV7mYXfRAxXdTvXQGlcRq9Env4Ni3fdKFEFc3RZRlbS2miL8jm0qy7Ty5j4YRUVkSgICPiMyRzuplWr0Uf9xM3xIFleroAKzXExrAMIp/cONgpbaDGkDwytVJRXxlf/y6JPZDJrz+8fFe3xNe9lEoii7TIVswrJWClf0eccAcwCUt5vCpeV3MetosuCsyt9q9OaFvqBYNjIqciYoL
 TkCmNnor
 Eiz3psRsfxDnBKk86kZdvyIxrX2z1Kdjji6oidyH+4miioKQLZcgydZ9pnZYQt+BPL5VFMusp+i7FSSKoCzeizk4MsajjNX28N+nY77f7klRjFTgymS82H1yZoxUIyemLSaJbTbsWY1wuhdrt0I7VDh+yo2+R9O4oenVmH2XUAIDgsUj/Xz1Tdx+92scMBz2dmcQ92Zh9+ePD7bW7HBFN9+dYGhTgVKaW1sVgkCJ1QxYjJAwgQw4fLWomnaMZYJ0FVzLFuKyKzfwh/0bRPgBxgIAHqhQ9Ad/jjFV/ev0wJaUgg4rA/xkrDGyUInS/NiUt1ZCIn7D9+0yaUYM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 11, 2026 at 09:08:50PM +0200, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
> 
> The RDMA subsystem exposes DMA regions through the verbs interface, which
> assumes a coherent system. Use the DMA_ATTR_REQUIRE_COHERENCE attribute to
> ensure coherency and avoid taking the SWIOTLB path.
> 
> In addition, a given region may be exported multiple times, which will trigger
> warnings about cacheline overlaps. These warnings are suppressed when using
> the new attribute.
 
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> ---
>  drivers/infiniband/core/umem.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason

