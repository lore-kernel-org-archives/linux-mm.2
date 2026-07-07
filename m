Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 81903C43602
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 12:08:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 738E86B009D; Tue,  7 Jul 2026 08:08:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6E8B46B009E; Tue,  7 Jul 2026 08:08:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5B0D26B009F; Tue,  7 Jul 2026 08:08:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2C5FC6B009D
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 08:08:43 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id AEC4C1403D9
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 12:08:42 +0000 (UTC)
X-FDA: 84961858884.11.35C2B60
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	by imf07.hostedemail.com (Postfix) with ESMTP id E60C54000D
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 12:08:40 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=EeNKg15s;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf07.hostedemail.com: domain of praan@google.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=praan@google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783426120;
	b=Yp6TWwXtjb4QFjqQ4BlbVV7oPzCGOBmn0QSLmul5yUJ3pcsLy69E3X4quA3HysVazbMz+0
	ZB9ASyFxjIOnVhWawcrUeSLpyRLZYqYY5LltqNNu5fo+fxB0XrrFQHaGKqbA0GaW33B8AF
	xBA45kwBzyJ0muJWPMhGGmHM3/N64ns=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=EeNKg15s;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf07.hostedemail.com: domain of praan@google.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=praan@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783426120;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4cV7wjZF91JZABaQ5nRkxwcAf75ivPZaWcSLuu/chBY=;
	b=LxUMVpiabt5TF+7BbrlVg/NNdyIUnBbbTWYSPVx+a2dsiyoH/+XfcnM9SzSTs5O2QE0ZuY
	PXp0naedorX76EjUkLGHHtyBlTVvZGg4NPu1NzgpLqRABXJR0XAxs0Eb8nDcCc79Ue0TF/
	14lPWytNkhX0mP0ab2s4bW+ybyrdfy0=
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2cb59f6ba26so71325ad.0
        for <linux-mm@kvack.org>; Tue, 07 Jul 2026 05:08:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783426120; x=1784030920; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=4cV7wjZF91JZABaQ5nRkxwcAf75ivPZaWcSLuu/chBY=;
        b=EeNKg15sGwnLe4ug9sR+pd6lP3/j4YMfUjDi/atMAnN0EZz8KvJo27Kvt0RC+ZB6Ns
         Kgz6SbwaaZYp81HSi/F0Op/xvFsp3fAZPjWZGmTosUKeGkxtFcsN5zcPvIANt/ISA6C5
         67h1Xshs6+is6yBNWxViAn6OH2RT66iqkha6o8Be/NOMN4lw+Kl6RQErd1MYTW4TEUhU
         EXT05qrSkUBe9ex7L7A42ta93b7R9LAGC5e0cszRBTtE7YkfJZWyqQOKFQbiVxFu9ejq
         MZIihv9Bfgw1lEWOz4zwNq/5xOgS++GkJqIDDgXZa2H+ZECM3OlB0ythrIXn+JC1Pm5Z
         m0Rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783426120; x=1784030920;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=4cV7wjZF91JZABaQ5nRkxwcAf75ivPZaWcSLuu/chBY=;
        b=CvXbu9sBD6sf1Qm2SuCRnsmGR0XLbogUOdv1WItsIy7DX+zD9oW6x+8APjeAaplB70
         oObImWRKNsp5tvhxifWxDIh1TFPS78CjB0NoCqopxUYDikQmPTL2PluyR18V7d0DadpZ
         sQrHkYeRIQIubn9yH1PZIq5TcpoZr1kf25tVWK/1KeFAgoOhaz6L2lmickUhBLF3qdXA
         vkHgsEruLN6Z7t/XD115voze+z6ayqCoX4omKH4wmOciMevXUYjf5CF5r8EEfiewa3Ra
         8zaIVr8A9+vH/1CPd+FxiNLwMJijePEudvlwlYXE3dMD5Wu5CpELD12jyxBpSnKBX4hn
         kAtg==
X-Forwarded-Encrypted: i=1; AHgh+RpwYVi9ESuC74C6cA+IHQ/6UqN7fC9E2O8i05JKGt14cA5eJLiv4L9IlVIOQAj04BMu96Sxd5L1Hg==@kvack.org
X-Gm-Message-State: AOJu0YwHp+X85CEjOiwQDHo26msU1/k3giJFjvGIQ6cf+CWGzb1ER00g
	mhcvu/wjS5bI0GsRD3IKUOOOGmcJrsJeEkwRE02mnSj0BJRHppo3l+PkGo2h9+aZkw==
X-Gm-Gg: AfdE7cl7U3nX9I4K9Y96SOLuA3qE8PlDRNPs0mLYYt71gNp1lI+A5BoaviQtidT9Ubn
	aLTZ1LvSn4cLxWZO1xFtrhX9xGETYQBjp8b2pjxOVVHGIchBacbHX80/EnUnk8w8inIh2/+2MS3
	9xtMrDN9tqT8s+US3SLv9RYGedC/ztnQhyt6M5AAPweRtP4GJ4T5A+RAI+gDi4A0rsd/htoSl+8
	u6drXXeaAWhXi/FFSHdysaeNLOYJPoDnj+DhAm0mf2qzYSVCLW94NKHW35ffFtxkjlPuQYv1bu1
	N5ElVWkX3O5TNT6hJgYw7qDt36cEU8nTX7Y4KvRX9pihu5rW9MSDHchtF6mkN1OazeNj1OTefcV
	idpXKzI1ZwvPlY0fImsSRv6npu90izkmmLv2moUMKd88HuB8RAmFK0II2R+QJV91AcSvNMEsL4P
	zNWNdkhDvfdQDnG2w1kL78GET/ef+Lase1hna/tXJbkuVqrmI=
X-Received: by 2002:a17:902:e889:b0:2c7:f688:f22f with SMTP id d9443c01a7336-2ccc9d7593bmr2658275ad.13.1783426119230;
        Tue, 07 Jul 2026 05:08:39 -0700 (PDT)
Received: from google.com (10.129.124.34.bc.googleusercontent.com. [34.124.129.10])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-ca5af7d58f3sm853302a12.1.2026.07.07.05.08.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jul 2026 05:08:38 -0700 (PDT)
Date: Tue, 7 Jul 2026 12:08:27 +0000
From: Pranjal Shrivastava <praan@google.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Matthew Wilcox <willy@infradead.org>,
	Trond Myklebust <trondmy@kernel.org>, linux-nfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, Anna Schumaker <anna@kernel.org>,
	Shivaji Kant <shivajikant@google.com>, linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v2 6/7] nfs: Optimize direct I/O to use folios for
 requests
Message-ID: <akzsO_vmYX_7Umjd@google.com>
References: <20260616134000.2733403-1-praan@google.com>
 <20260616134000.2733403-7-praan@google.com>
 <7ee3bcfdd6126c93cbb1c219bf601182b95c10d9.camel@kernel.org>
 <ajGGpDvzZdkGtSbN@google.com>
 <ajP8ZTTLYkICFTO_@infradead.org>
 <ajQ21kH1ZVajS2Y7@casper.infradead.org>
 <aj4iiD5C_yyLeb3U@infradead.org>
 <akevQfFVteCOD6LM@google.com>
 <akfAgy52s_Gch2KG@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <akfAgy52s_Gch2KG@infradead.org>
X-Rspamd-Queue-Id: E60C54000D
X-Rspam-User: 
X-Stat-Signature: 7pz5imewfdw9whmojd3i4mrya8hsrytf
X-Rspamd-Server: rspam03
X-HE-Tag: 1783426120-256803
X-HE-Meta: U2FsdGVkX1+x5IFqpvxQjda1wF0ZQ0bx0QhdYiXeW4kFDYTBePeI0HWq4qT0kHaEZwBReTpiyKkhV8QrHRXELLVGN6tKUQduzYiC/A00mTY0AURt2Q5Q0RB0DHFDCX2HCaRrzlP+wmOv41/JIOVZGzjGbmuCQEYN9K5H9y1kbIuuDhEWeqmrGD9E61AcNETssNjlXvk+rvlIy+P4JZfFojsNemqRavDkJCLK/wXddTKCmh8eOfjRL9OMCDTJfC+15DxThKJQJMoXEw20ri2xsCYJaZofC6MiFCtfo0l8PvSk3aCaH4c447sS5yXXuVrJHVdc9+2We2K8OW22nFNch4lMqtETRQ+fBI835ry09r5/rlereTKsS8+Zc1jUE978lJGk/IJRq8XcVxPsASksmDUFQDYcKaAwQ8ZX5lg2ecSwADIi0VvhOPqgN0HeXHjpdpIIlBb8yzp1pb/jK/dB1RvuZ2dCPc0/aMG5z7zgdHlIwkLKtfsl9LgiopRVK1+3UVIKBpmmoN1r78DaBW5yuJNmk0mc1xB+qlSKsUfMcUj3ki3S96J6AgdXWqcAh9KBDBZhHsZfb1941FfbSFxRjv+BeX7m9tTmiB6N4lp/Q/+79sDApMAeLiMDdTiXDo0Ieqr3d3WE7wS8AssGlt8pgGU/gfPIpurycb/j8bcLCzQgyDtouSojpmPTM6jJinGMQ/4sc2XeEv7rA0H2ADOLE484MmdEgi/Imgt21blA2mN7GgGldw/guDKEPFQJ1doVddvi2ExbaGCJGdVAYvuC5F+6Wr3WT4xZzyKAjACdmAjs2VXe9r34/gsvGWzGLhKJuj1EDPNbasDOm32JfcNzLqxc4Z1YvNaNGCMUvlk4ssjhrXa0BnT+Si8IJ8gnnjiDvnTU8nXKsUsuMXBbebuWC3OJ7g3tYefLBHjtbNdJRIJBurNKX193OGdnQ3LUUlmJu/gfIMHbMJbmfQ09vCA
 7Nr9DNYh
 Y1II3BPuD0ISDRP4np/sM/k04Ovw61qoaiLbcOf3I1vOYcNTsi7MwdR25vesZlkVaH9K3H7I/1ygkx3RLe3FviyvRhAWSKLedyURAoK4mYhA8blzXX3Q07MDtlsFY0KxgAPGmlXqJu+cEv4LBNMOvzOYypwMUUQDxhAMuGirVBNEtzIsLp6Lzojii2MdCBUL72bN6SOLfFPhkALIKFWzfuQISjMujVe2ytO7jaPIhA5PCCL0GOKv8Dge3/haH2wWozBdzaDAFQHRBp3HBx0zhA/hoHpJiQhsWuLvV4iESmeHpvZtFHxz6pdyB5eJWd8+BhaylcwQQfSYifQ+hT5hk3or/SXb5lSdMXBI2aJK1kAx0WWY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 03, 2026 at 07:00:35AM -0700, Christoph Hellwig wrote:
> On Fri, Jul 03, 2026 at 12:46:58PM +0000, Pranjal Shrivastava wrote:
> > Do we have use-cases for a kernel user for direct I/O ? (Just curious to
> > know if there's something on the horizon).
> 
> Plenty.  Basically any storage on file driver, or storage / file system
> server:  loop, zloop, nvmet, scsi target and nfsd ar the ones I know off
> by head.
> 

Ack. I see! Thanks!

Regarding the page_folio impasse, how do you suggest we proceed? Should
I expose and use get_contig_folio_len() from bvec? Or should I move the
NFS helper into the iov_iter lib? (or both).

Also, do you suggest sending the Folio move as a standalone patch if it
is blocking the rest of the series or do we prefer keeping these in a
single series?

Thanks,
Praan

