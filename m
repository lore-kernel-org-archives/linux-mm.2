Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B56F6CA6004
	for <linux-mm@archiver.kernel.org>; Sat, 10 Oct 2026 04:08:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 935536B008A; Sat, 10 Oct 2026 00:08:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 90B456B008C; Sat, 10 Oct 2026 00:08:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 848F96B0095; Sat, 10 Oct 2026 00:08:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5B7C66B008A
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 00:08:47 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C860914065B
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 04:08:46 +0000 (UTC)
X-FDA: 85305385452.13.74A4F20
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	by imf09.hostedemail.com (Postfix) with ESMTP id E6982140005
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 04:08:44 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=j+g7V6+h;
	spf=pass (imf09.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.172 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791605325;
	b=F93mix6fkC/Au3Lasc50OfMWb4vDVhCVWuZ7EX/enK/+cSa1gPhFu/CGzohOU9st3OxFBY
	9EyH8TgnYmqYw3XwcH/q++HAuyfISQWkndBs6uMYWozD5GQq9atlyPSBASSnHyAojWRSl/
	aIrX4I586RfvUvaTFSd5FZvCb5R1hds=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=j+g7V6+h;
	spf=pass (imf09.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.172 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791605325;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0ZUQo/yqUTrPoo5foi8MoXEvjEyvx6Zd1hGuH8gY7vo=;
	b=Y/UJu7v4jvVX1WORwRLCbva7tIYBycKLilDzJ7vnx49U017PrFWNQBC+62ZmvrjuoQTKqh
	3HMiN2RHYe0XeOtrILbzXTCoHlmC3ocNsBbJQ80Yi0SrSLeUGta78QU8dhCRW9A93PaI7h
	vftyZgQgNWLnShX2WDht7IMCZDiITdo=
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2e7006bbf77so2004925ad.0
        for <linux-mm@kvack.org>; Fri, 09 Oct 2026 21:08:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1791605324; x=1792210124; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=0ZUQo/yqUTrPoo5foi8MoXEvjEyvx6Zd1hGuH8gY7vo=;
        b=j+g7V6+h8OmDAnxVsJqVxhJn4adTebIHWraqqBXcL5JIyHg4C805/DPWQ7jHawkjRf
         x7hMtizV+k6tcmImhiYsDtsMpjVQZ4gwVtkCco2uMRODp8Ra/yz4wesp8k8bZTzzsyuo
         qsjlzVUAhffkbqcki4x8awm3Yj+6lTlgvYh2E=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791605324; x=1792210124;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=0ZUQo/yqUTrPoo5foi8MoXEvjEyvx6Zd1hGuH8gY7vo=;
        b=JS84J7vtCO/H8S5nByvcKRMDUl9CWrzDwiWyiY3T6U7rThfoMqKpVMxMcYi+vbr/7g
         AQ1JP5ioiZmRgu7Z5WZ2AE2xL1QchemtnwZXBYf8FMee9BedhqD5AtN7zC/rEk1f/Cfz
         fnJhCmoNyQACiGZhlIVGbPrQOmLt8TEJLbku7PrcwwNIi2qnBjx/KPFxFODPWZbHE2Lb
         aRwplldODn1eItwChj/Hy6ai8IJAdJNWCnL3b1oDm2jdu5cLdHZwfQj9lJy5j20P/gdi
         5hs7WMjfK/f6qmOVdw+PJ6jUbz6+UZgESyT8f/Svt1ppvi+PNNYhSAYG3ILQ0x2XVFoV
         1RaQ==
X-Forwarded-Encrypted: i=1; AKwUvBzemRwA7M7Z5TD8uhcn+OjPP+fiMA2B0DS3Wtc0BJXGhmcetZ2uud2NQJBYxSF83tAJABZMluuD4g==@kvack.org
X-Gm-Message-State: AFq9FYLEsbIa/3B+B/NFefjA+qTmoGmqms0IswAIQHDHPsP8CmZvljF2
	96dA4rHPCp/ZF5TvmpNhIbLXoqgnhIblhqyNHs09J7ulVsK3pgFwyrlXQK6stMrijQ==
X-Gm-Gg: AYBFou3LNNOQLCvHAQAP748WQNZE5O4gN0rqvWPvaL6nfdpdz+FM3mL5eG3rA2AaIF4
	AuTel9Z2VkXrJYvE1fIWJkFOg+mT+mvWnUc267nnMY4mvGDc64mePWlgUjfyH+ij0evxB/KwFLh
	5htEw44ZPOvbHNVQ+JNzMLf1KW0Y51wOUMYsb1w0LU8FaaenUTrqXrfxJSsAoiMxTekphiviwmh
	fOJm+3/HfC8wMYOMzMf+FfnKzZ9hYMKXwTGFsJc6MlB40tWxb1uJkav/insai2F5tL6f+YTduyh
	KMitnC/71I6VN+a8KskW62I4ekaXVB3WVsN3tUQOIxeMZdtUu4aBgTiPLu7lENNO4jwT6Yl1uKa
	KSXd7PewJaeyWHm306w+w4rM7c6H+gAQb1o2sSDvRq6jnj6UEa09a8x/maHwHNYJMSglIp377MV
	uAjrGFtFk0XHwvK9KlfxB4BRSYIigA20lqHnCl9OuQdAQZQvMyGi8q+uvHm+4VMSv57jwLQciSC
	v0lSpNG5IUCnu/Yk9Fut6ggmWe6ZKYFXo2Q3g==
X-Received: by 2002:a17:903:2f8b:b0:2e6:943:39de with SMTP id d9443c01a7336-2e842bcdb8amr31536795ad.30.1791605323624;
        Fri, 09 Oct 2026 21:08:43 -0700 (PDT)
Received: from google.com ([2a00:79e0:2031:6:540c:2d4a:7d35:ee3])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2e8421b16casm19275425ad.40.2026.10.09.21.08.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Oct 2026 21:08:43 -0700 (PDT)
Date: Sat, 10 Oct 2026 13:08:37 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Usama Arif <usama.arif@linux.dev>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Andrew Morton <akpm@linux-foundation.org>, chengming.zhou@linux.dev, dsterba@suse.com, hannes@cmpxchg.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, nphamcs@gmail.com, terrelln@fb.com, 
	yosry@kernel.org, riel@surriel.com, shakeel.butt@linux.dev, alex@ghiti.fr, 
	kernel-team@meta.com
Subject: Re: [PATCH 1/2] mm: zswap: use separate compression and
 decompression requests
Message-ID: <asm55VCYoqzE80T7@google.com>
References: <20261006002307.2669023-1-usama.arif@linux.dev>
 <20261006002307.2669023-2-usama.arif@linux.dev>
 <asiUXpjrE61TLMxQ@google.com>
 <b11ab591-3839-4486-b4fe-77922addbc31@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b11ab591-3839-4486-b4fe-77922addbc31@linux.dev>
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: E6982140005
X-Stat-Signature: 9y65dj79iu4917aop3s97xtizwtjpehd
X-HE-Tag: 1791605324-877578
X-HE-Meta: U2FsdGVkX1/eZQnaDC5vZGPifl743obRac0CzJJzz/LtOxriCVoTGU0zOjEJltQ4Z7CrxlGOtVWHW5I8BMLtQ9v7dgZhixJ4jpzrjZnvFPUqrVvK4s6QsO241j/eLLvGTB7geBj7T16DzaoFfRPwaVzSr2OfM7IIr4zMbd3XM5bj1gWpfv7gmwaWU0MZbcsfrQqeWWJR0EeRaBDxWxd7j3+oL0OiGFLLnfAxCv1jrDEqDRiwBHBrFcE1iJ1/tEP4J6eonW9ST87kcsVnBik3j6IhI3/L/16EMPDDIYIMoKTa4dgm4nR0iby+be87DJKLeun1unyD2xX0SyMlUBs4v8Csy4wc70Wqr4NY24HqygA+oI8ELQOxUGhI65uEUy/wTy8chtxaP9xld9iKAvkFlfspZ0A+cI2qaHw5BXlodryMQmzZSNlyZ2/RAYBRLktwu7DCAKb//tSgc3NYD1/557AXPGxSOz1PB0TjsP16WdRJEG1V713l8Opk1P2LR7IVu+0CTz0ja+Y8aFSvNiuT/k+sKaBKMRbAFoJtsdIMqICx4EvXGRHQw7Z3Ye4lx0JvIyp49tL4Kq8MrnGXnA6SpnPT/mLc17dQuXeF/tngrhNd4P0d6DyG8xo0mvP86qce4Y6HPGgR/nBfug0wiJs7xL71Ai/ZNcYO1HReX8gotlSCtwVOLrPkZOAfWf9tOMhJDMBjUKlWDZAG+lJI6SH6N8w5jNLEHUpHy0DVqDwn6yCehwdg4XmUSgkqz3I/vWA/5yPCjnkxuhKSFSC2+R9SXhjmbH3bTL+nNJeKdiz79GdUmzxH7Lj7ceJXboncBJTamM3Y/ivbGtnv+p1dLvQgIMXWK618vrMoO2yDjtPggJl6cOCUR4SejtYmNQ/DAFahDZ2FUnO5ne5coA3qBfiOyNoX3mGeBGVperChW/xaqobKUePQtDnWMZwoGG8upgYSuyge6KHX0jqVsb6toK/
 44zK9Xne
 LyGVKyD/ZrIH3vdbwxmhfT0+m+nuOdYXMMQ5gHzThmai85EQiR2H4Y35JKUERBeHDi0USBRTS7lZDGsBHcS16zLcfyna5XIBgzqosJautQSNUdRTpPi26G89ee8xwvWDdZS7/FCPPn509SP942vxRxyR4Wd2xgf8sJdDFGqWLC8Wm333vHz+9Ki7Gaoi7ITf/tGOEuU13awX4tjhvRnSZCBRWI2uWNCmhOpCX7xC79nzMsAx0Eyzwqh9uxPEpmVH7r5ckTMLVzaoKnf3Q9/L7seSs8RXDpmIkq/nOoO/8YJnPdp8Qs9bzaca37rLQI0QW24ktnTTxtNZZCQsxXjXAo7BP4cG5gt5zgdxlE5h0HHZgI8y2qfF4dROEHw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On (26/10/09 17:26), Usama Arif wrote:
> Thanks for the inital patches!

Thank you for working on this!

> > Catch me if you can ;P
> > 
> > [1] https://lore.kernel.org/all/20261009071157.3730698-12-senozhatsky@chromium.org
> 
> I think it wont help zstd, right? It would help stateless decompressors like
> lz4 I think.

Correct, zstd and deflate decomp contexts are mutable, cannot be shared.

