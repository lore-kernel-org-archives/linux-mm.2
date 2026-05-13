Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9185CCD37B6
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 06:06:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CF2BC6B0005; Wed, 13 May 2026 02:06:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CA3526B008A; Wed, 13 May 2026 02:06:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B92236B008C; Wed, 13 May 2026 02:06:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A7E736B0005
	for <linux-mm@kvack.org>; Wed, 13 May 2026 02:06:13 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4F38A40759
	for <linux-mm@kvack.org>; Wed, 13 May 2026 06:06:13 +0000 (UTC)
X-FDA: 84761361426.30.80FFD23
Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
	by imf22.hostedemail.com (Postfix) with ESMTP id 69531C0009
	for <linux-mm@kvack.org>; Wed, 13 May 2026 06:06:11 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=EuBhs2jC;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf22.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.215.176 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778652371;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xJMt9eiXDN18Dn/IZDF5sRaVqP4gFjNnQ5yKAIkeCXE=;
	b=kOj2gLU9IVHY3Bzvx89Uzqr6REWwGxYo/Iy5ZAA2h4XH2top+0K8Y2ISBOx6iWV2aktp0R
	lb9UBdwT2rR+ly5pge/hT/WyEKbrLM09JWxcF5LXPNBvbEz0Cf2BZCrNLbIJKxyeFS2J2F
	aXYq2GUGz/3ss+c8ARntENqztdTbVdI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778652371; a=rsa-sha256;
	cv=none;
	b=W1+bZ9rSkGSqruE7G+lRLrgDM3w0tZjnPcMVpHBmMcc5YTlRAVkrgAaIIBQpO6hyO2gnzU
	h8na0U1rTE7mCvDptWA78ibBbKpDvOilYwmZ/9oSll/M3OYS+nQ3dEW16pSJVzxSAtLKi/
	MxAW4KvtgUCmyGmM28nfHMkj+1d502s=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=EuBhs2jC;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf22.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.215.176 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
Received: by mail-pg1-f176.google.com with SMTP id 41be03b00d2f7-c801b30188dso2768505a12.3
        for <linux-mm@kvack.org>; Tue, 12 May 2026 23:06:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1778652370; x=1779257170; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=xJMt9eiXDN18Dn/IZDF5sRaVqP4gFjNnQ5yKAIkeCXE=;
        b=EuBhs2jCAckwJR3qmhmCs7voUbnev031m3pzGxXAvQUZlph0nTHiKQHDxVM7jYoyT1
         YhTgmVLzeRT2NNvpfCe9nzEw3z/yAd/k/Qmhv9SWwOMk0t95bbBw0wzofyjHsNvs0xMw
         Go93h+vmvO6Z+mZbvLxUeSeTwaZ/V0rVmiCoM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778652370; x=1779257170;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xJMt9eiXDN18Dn/IZDF5sRaVqP4gFjNnQ5yKAIkeCXE=;
        b=Z8WQz6hIzeemYd+dse8RJB4ibrgNjw0BfLNoGcF/JdPjNp5fOAjybxiCxYeFjviNHk
         biPoZd87vrlDICsci4pXrYtqcr1o9kc8ra4Whs1kkhFkw16OUln8StZ+7ugMXqNq1/ye
         4EgJorImotrey3hrhS75yLUzSuR0DUwm6xpEj/rguJys9/RJUoAkB8B86lt9/0OzOltT
         itmMQZ8Nm9DdJFbyaGMU06kcw0Y9k9thru/+ure0dYFJM6j+KpDKMfK4tEY5Q6J83Yzw
         P1YWqNmnLjv74t3YIAChSRKiOynEWattAtnmcwP9vWoDqBDWQVAfnNT7v7nJqxeYG4xw
         I+cQ==
X-Forwarded-Encrypted: i=1; AFNElJ/AvdxaDcoH0yMdqfI5ws08Uoi739jFk+SfEUa7XEppbkvvjIML+4U9Haem646X22NKGwgQzdqabQ==@kvack.org
X-Gm-Message-State: AOJu0YycHbJykeanvUXCC4ZcNGPj5smVrOm2lx/phpZSVErXNbcGoRXS
	B14stWsQBq3qPocyGQGSHjhmYBKgdBYVEWRRu4ujHvSvIcj+kIqPwV3uI80v+Idzzw==
X-Gm-Gg: Acq92OHZEltjFKSJr0sFrtilhAXY318KVYJreblfbxiWvvGXFWXILE1eCgf1qMkmmVJ
	NR46w6pNntYJYHDSVFaHCVMqxp5TOAViIri1WqVGRPoOyNrT2cmyQ1LZTSfLSre5HVDjGQukXsu
	KsGIC7vxUuDRLyahPd8lclJ0i4ikDP8l1qg8+CbZF1QvpYSgNrpD2gPPJwBxB5B4v7r+sTQKL2U
	r1e94Q1IF13ZBZg/gpJC94cARUW/LxqoxdDeZT/T5WnUBaZiw7RVWGg7GrhL+cRMD5lY0Gs154+
	imDeTPchmR/fMAKBHYOo0cBq2Xad7ff+GkCx+8phgTjEeZRa6RVcwDiidoS4mLMQvoAZrFoLh06
	V6zkupkJ8vJz324fxxmjKapfSuz/WlJ2TER5S2/cH9U8yp8pftZ2S3mo7PiaFXnZdcGTngL73e8
	tlarrfAae0OJSbPHlXKcc5D+nm4cAe69W0bMhfvQEWRF8637MdwojG8aGEVzONajU=
X-Received: by 2002:a17:903:249:b0:2b2:5314:e96a with SMTP id d9443c01a7336-2bd276e7a13mr21751955ad.34.1778652370167;
        Tue, 12 May 2026 23:06:10 -0700 (PDT)
Received: from google.com ([2a00:79e0:2031:6:e541:a7ed:e8ee:843c])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2baf1e8df57sm158567615ad.64.2026.05.12.23.06.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 May 2026 23:06:09 -0700 (PDT)
Date: Wed, 13 May 2026 15:06:06 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Yosry Ahmed <yosry@kernel.org>, 
	Kartik Nair <contact.kartikn@gmail.com>, minchan@kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, syzbot+8f77ff6144a73f0cf71b@syzkaller.appspotmail.com, 
	Nhat Pham <nphamcs@gmail.com>
Subject: Re: [PATCH] zsmalloc: zero-initialize zspage memory to prevent KMSAN
 uninit reads
Message-ID: <agQUgD44Azq3PbLe@google.com>
References: <20260511213658.25273-1-contact.kartikn@gmail.com>
 <20260512144733.9132c83e392a109743e92f71@linux-foundation.org>
 <agPjfGO6zh9HLPBE@google.com>
 <agQPnkSH2cdWHToE@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <agQPnkSH2cdWHToE@gondor.apana.org.au>
X-Rspam-User: 
X-Rspamd-Queue-Id: 69531C0009
X-Rspamd-Server: rspam04
X-Stat-Signature: sd7y1skp75xmnjpo6gdk1pyg3t9za116
X-HE-Tag: 1778652371-907519
X-HE-Meta: U2FsdGVkX19UCLk3kmTidJuxukj5qjQce8cpu/pZsl198iAjxnM70ngfADRyywg74+C5uzyIfDwPotI4oxQEQGZSPYTiVp/B5AcqlFvwd6re2VcJLGOD44qqEK8zp/A1y6VIfIPFC9Cbqp6w+EycZHP564vm9mJ/7549/3CkUXQP/ujYgAiXc6GWvk159827ZjQMeDunCWN2xWXG6AScRHLKrvI2nv03gZS/7ofNYsKXKgSaDP1SbruH9OkePZ80QmsGUwXzps6OJYQnsSai71uPCaBVm8q5ULXd5ct87zyoVXQGUg1tUGPjEPHswuRam8IKI2bTdGGs2XsPw8tj7UeqpI8GsjOk8YcWmXftan1nLo5vJSAA+3tHlUXDpm2QJWK06v1uvDQGNOEDYwclECTBFWxngzHcODlAswSpQAEiXy2/d8RH0UYW3/tKX2x+xDiFladnGBVSdQpXpF5IHD9HYc/STH6CpDAxEQyhg16K1aOxig31LLv5fOSNFUjXJb2crK6ldZHClW2YzM/Z8H4O6/xReF03Ao4mMepvSryKo7I9SpUfrwsDR7ijF5KDNXDDFLxAXE/ndv9SlPsKaxu2bdvDYAI3PS3cB+aO1W4E/eNcrflZ9LO+NX3KvBLJ7MQHitDr0ExcD+MIiLASK/prlxM1DQ0QCLgNpbuT+7LrpSPoS7MxlAUUiVyfVzOdoVBXL/yXBY15nN5nfnUMDQU0ROzPpM+q4hA1qMnBG2hwX51LEe9HnDsXvs7dH/2fpc6uWWhgHDR54vFHd5zrqHYpbpYhOe2IhzBKepKZMl05uRGtEle94oluk/nYKB8YQjj07K1ZKn401chi0J8g0W8ZChszV99anVHNNv+mG2/H52JA409/eCqir7o/bibHHwCcQg3HxDsFcyGF8IfBnS+bIdkCah9vh5kXFEwzwQuMDEnCsOLcDdxZnGw9vY6LmikhoBPqBsRjZD/ikda
 79JXL35J
 24el00yghaUc8xdSDggUQf4EAbzFeYE8vkrt1HqCutGn1H1mQC29HCdbN8sLMwrdx8bOEGHsm4oohQuVZwQDVc0pP/is0TylEc6F9AXGRtvF2iXV5EEcSwGl5MgPLWuH1Q8PzDS89BRnrazpm+2HuVs6riuAXgToNeOGfOZ4tEeLTwNyxPBSPzKd2hV4OR8huwRkACS3oGViMH9SoLQqox/regk1vzQwN8z7tIFnwVbqgBBxVSxn6/V02hZVZCrzHP5n2bARESiOimEmGkI2CB8s4wcxHeShYpXXEywrktKqLBQVHV9yHMqMtzimw6kgxYbJ3JGjIhrZSPgo8V5G++niJKqsDHB+t/DZpjOcGVdEoopV6/zcmmE7eeakutELrVucF88JSYd7CdczBdNQ1sf62mJoHtk065j/AKs0MBYxWk1iIDzojJ+IAc/xc31ZFbGw/a1Y1YQeDBh0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On (26/05/13 13:43), Herbert Xu wrote:
> On Wed, May 13, 2026 at 11:47:41AM +0900, Sergey Senozhatsky wrote:
> > Adding Yosry and Herbert,
> > 
> > On (26/05/12 14:47), Andrew Morton wrote:
> > > > Pages allocated via alloc_zpdesc() use alloc_pages_node() without
> > > > __GFP_ZERO, leaving physical memory uninitialized. When a compressed
> > > > object spans two physical pages in a zspage, zs_obj_read_sg_begin()
> > > > sets up a scatterlist pointing directly at the raw second page. If the
> > > > second page was freshly allocated and never written beyond the object
> > > > boundary, KMSAN detects reads of uninitialized memory downstream in
> > > > the decompressor (e.g. sw842_decompress reading the CRC trailer).
> > 
> > I don't get this.  How can sw842_decompress() read more bytes than
> > it's told to decompress.  We first compress and store the object,
> > before we load and decompress, reading past the known compressed
> > object size (which we pass to decompress function) should not happen.
> > Yosry, Herbert, any ideas?
> 
> It sounds like a bug in 842.  I'll look into it.

Thanks!  The report doesn't have a reproducer, that is always alarming,
a big red flag.  Might be entirely unrelated to 842/zsmalloc/zswap.

