Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3036BCA5FDD
	for <linux-mm@archiver.kernel.org>; Fri,  2 Oct 2026 15:08:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 36A416B0088; Fri,  2 Oct 2026 11:08:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 31BC86B008A; Fri,  2 Oct 2026 11:08:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 20B3B6B008C; Fri,  2 Oct 2026 11:08:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 00E2D6B0088
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 11:08:51 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8CAEC140738
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 15:08:51 +0000 (UTC)
X-FDA: 85278018462.19.D4A8BEA
Received: from mail-dl2-f31.google.com (mail-dl2-f31.google.com [74.125.229.159])
	by imf21.hostedemail.com (Postfix) with ESMTP id A224B1C0002
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 15:08:49 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=Fd6L117N;
	dmarc=none;
	spf=pass (imf21.hostedemail.com: domain of jgg@ziepe.ca designates 74.125.229.159 as permitted sender) smtp.mailfrom=jgg@ziepe.ca
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790953729;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ENyCFbokdLWAmAh2KCAVPVZPtiPMjF2AJu3KZcFQdKM=;
	b=MUve+g8Ig/A31DpAHhQxJEpLDnFHBW+4wibJ8toE1C3Qdw75O90UnKMh1qB25wWfcCBwfm
	oFAQEkOPYuKgrEJdfhiu1W/+LA0hp1t9WH71NlXuKBLqVLiSAY5KSai1+lF+0MCcnhXPy1
	MSAjXrPoPV6xv9LcMal6b9NRCmZ8QCM=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=Fd6L117N;
	dmarc=none;
	spf=pass (imf21.hostedemail.com: domain of jgg@ziepe.ca designates 74.125.229.159 as permitted sender) smtp.mailfrom=jgg@ziepe.ca
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790953729;
	b=NtMpyQviSmy2UJzFY9sLYPgga6NLfcvJFL3VQHyu/urjXMTLYre9EUcgbD4Zcc2+f9Kru5
	0Bov2mwg8h5yemGAkZsO9h32IkTCLU2Xvzk1LlbiJfn3Wg5ggZv/oRUd1tHXK3h2eOTwgT
	K42XuHLaUyCqd0cQi84RNJ7wpS075fM=
Received: by mail-dl2-f31.google.com with SMTP id a92af1059eb24-149d5ec8e96so2154347c88.3
        for <linux-mm@kvack.org>; Fri, 02 Oct 2026 08:08:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1790953728; x=1791558528; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ENyCFbokdLWAmAh2KCAVPVZPtiPMjF2AJu3KZcFQdKM=;
        b=Fd6L117NwLjUWesvdASREy3Cv/C3TrfHLnf+neNGu/yBrVoqslqW9Ucbohq19AfSlu
         BA3Kcx3nl6un6///FTFykunY9saQox0mNRw98BClvL/8hdIm2XbHr0uVSh+EHqTw300r
         gaL8jP+QUhwHeTrr9ZLggH+PR64QQpibbfey0l98kqXx+zNfuqDn6W/D/RPeN1tDuhO/
         yjcFuxOQ/ErnqF+WNU+6VCMfYSAgU+coNgn0RVcLdS6t0RuiHoojcWT+u0NS/CwBrCL0
         9IJ8YGU3dmUnk1vO1ESA7L7prQqI2zGnztMem7AHoqBovwDovaxCWC7DOi77O89PfhRj
         /Z0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790953728; x=1791558528;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ENyCFbokdLWAmAh2KCAVPVZPtiPMjF2AJu3KZcFQdKM=;
        b=zc2YnV9NmwhLInTSU3YFAmjzF8DQPh9+GDgW/d+YAPVUnWpKRXOwiIVHuuci5fsLKf
         L0Ppi7FBrbDPYKYYZbHc/h/398YiCuqMV8wh+3N6Fiztf0U8yutzeJWIlfMj+fgRnJIf
         4EGTAU5Fh//0sxhfUaXLVuiCtxrYo16hA0xSsHeipb5+TCTRlzZS5KppCdjNYiHECtdW
         qC/MAPtJYIgTl3B9+gJpweMkJXEMnBJqP3DbaaRd7f6fn8ZipaME/hHcG69QjNlfJSFv
         ZJT51q2hRZ2HhP1+mKI3OE8qUjAMIviLKO6T520Ii3XOJJmxc0BfJ5QMmwdPi64In9nX
         Z97g==
X-Forwarded-Encrypted: i=1; AKwUvBzwZ03Y4XI87Vl7vdEjyoYZUq4AOzxmjGX9GjaGqTGiW1abxy5lAZaQVueEg/2FAgnQ2x2bmS4zRA==@kvack.org
X-Gm-Message-State: AFuF++lk9GwyfdoPLRlCDWiUd8/Ikhc3+VSkfVtQ77Gk1B6/j3RsQkCP
	xBI3Z/ffhrxRKGsxgzDAB+KB/g+ljXExJrLihF9Zs7CpkRfX2gLTgVy6lnBw+ujU3jE=
X-Gm-Gg: AYBFou1JJUloln0NuS2L/ti6GNFQLE+F9jG3V14pimBjUTK1wEjGfojJFALm4PXH9UE
	g5UpdY8Zmrh92mpNdj7UIdoctDm6pKxhlbcjVbZQAf62k80QP7RTXuFoW6gNt1DsJCY/imeLwbo
	ahBXeRQMAPZ9yO/OUqDriEuKcOouLMVq7wIDGihc4ObssaF8/3pO49QgLkVfE4zAb6ST9aSG+Ip
	sNM23S0h58q/REc7Qaf64+wyYKdmyXWKI3EMd/NDJE6rMQ6z56RnigmjRHGUSvCePRjl8Hq10oe
	PkPf19Qr0VVNtkJS0KHHCdF5kL3YD6PlB18yEZb6bJDHhAl0EBfTQVgVP9Q2eNToM8LJRMLn3R8
	W6G5gbViSUmUZwekLX2VvigcySx1FoeRm1aOiK5+S0TkZFEgkQRgG7mwG8JqY8/Dq/Tx0b87bOQ
	WtL6WV0Y5wPSuvjQQ61eVRRRyzBbCtIFJe/5J9U1Qj46mN
X-Received: by 2002:a05:7022:ed04:b0:14c:d8d9:94fb with SMTP id a92af1059eb24-14f5c3f1c17mr2903275c88.23.1790953726759;
        Fri, 02 Oct 2026 08:08:46 -0700 (PDT)
Received: from ziepe.ca ([130.41.10.202])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-14f468c08absm6704330c88.8.2026.10.02.08.08.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Oct 2026 08:08:46 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1xCesO-0000000Gmdt-3ju7;
	Fri, 02 Oct 2026 12:08:44 -0300
Date: Fri, 2 Oct 2026 12:08:44 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Pranjal Shrivastava <praan@google.com>
Cc: Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Mostafa Saleh <smostafa@google.com>,
	Daniel Mentz <danielmentz@google.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Logan Odell <loganodell@google.com>, iommu@lists.linux.dev,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/5] iommupt: Introduce IO page table shrinker
Message-ID: <20261002150844.GC3481470@ziepe.ca>
References: <20261001230219.818128-1-praan@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261001230219.818128-1-praan@google.com>
X-Rspam-User: 
X-Stat-Signature: zc5p6wjqyazmbwureefi3zypwaz1sqzu
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: A224B1C0002
X-HE-Tag: 1790953729-773430
X-HE-Meta: U2FsdGVkX1/w5b3bq82v8YAjEqNHcGpcBNjMQ5J4d7/a69iftMQo1MvRLvfdEfp4khB5cdoMiwIv/sxqVbGNwy9gsvWc17PIuKwxZESJuZTk4eAHhwJTVNa5fwABtR3cNy1D1GhwRlGxk1b8FdydZNVmAgZzsmnTjwWM1vzF96Txh/r7aRCcDKqVVZqfUQuhplNi2pUuy+FM+fddwmix7x4GfwgsiXUCcIF+vkpMUB7iW1amjnLO1hfCuv5pkclpbU8dKMF86zyqAj5/07bA8PFQwGxdDAb9bxB4KJOfXsKpgZHXoBn3grgJTrFxLfISA4E2KS4JE90Gt6BplEmJ+tZEs446yb6H8vd8p3cXkIyjmpHUA5F4FpWbqK2Uyzo14XVSwfAxEpOzE3PKn8oScozqxtVAr4CRpIhmpaKIJy1/r48XDYEp/nrU9/NwAl/jRI2Fu95t7NI/CjkDsSm5nvpCYWhf+YplXaPzUal/TRHUght9GKk/ON4kYB7UMJWJ6AEAk7gxvq/jdFOBmpaQCpbU6rP0CQ1n8UY3LbpB4ZD+cciqJuXEoEGIiZY3AVqIlX9ZimxQGL16cpvcCLcru2fAkX5zTX9bWDaXyy143It1UMQLMhSKd6/90Qb2FfxY5kNb9KvkhKV+nGJozpYqyljluNXVBJaXH0bVrrTFOHv9Iu+GWBTQojE0rEy0gr2TiLPVx/Kap9R9PMeaN+ssohPBp4u1pKNSmLgRnyvp+7RSngQpwJD1g27BSWGxAsxvDV8XUWjXvMIFBFRGd3/k/oxFaA+mMXYPxUGuqMaNvBDT8zh5B4OLvqKRZhucQDnB2ODo3B887cyaC1+jjK4gtOkQSK73envJzElYb19XqXG4zJWumr8cOSnpxeOBC7WxGkaNfPAcWD+sODYqdcA6qidJu9esI6UOBv7J8xV/zagSRZd8ROpDaTaHjN1mHj+LmupgZM9Aja3u65tbXmt
 D2cujbAE
 FwJklVo56Z1+NxFiAQcZWkz0LiRvqxLJIjkQUuusRVxlURUSteUSMYwEudm0AUsLG4BxORAi54n48gvQTsz8axhDs7m8uA0twOBShSbtMP5aWUzXjDaTCbw31QPQS7nO/3lgxP5RC/W/ZxgpTneRqoJLiz73ggEz5rQmQD2Ic204ZPkh6rOez++/y6zsRnLLvcfdldgjv9O8JpDbjcnIzO3P/ceiEL+oX7ZcEEls5TS2/SpoGns5mbNgORjVybd+CgzeswgJ4AzUtVNPLQrI/0Xkn3eIs2XaDkykW
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 01, 2026 at 11:02:14PM +0000, Pranjal Shrivastava wrote:
> Introduce a lockless, deferred reclamation framework for IOMMU page tables
> built on the generic_pt library. As VMMs and userspace drivers map and
> unmap large, sparse IOVA regions through VFIO and iommufd, page table
> directories are often left allocated but completely empty. generic_pt
> frees a table when a single unmap covers it entirely, but tables that
> empty through a series of partial unmaps stay allocated until the domain
> is destroyed. Under memory pressure, this *stranded* memory cannot be
> reclaimed and has resulted in OOMs.
> 
> This series refcounts leaf directories natively in struct ioptdesc and
> registers a domain-aware MM shrinker that prunes empty directories under
> system memory pressure.

We had talked about doing it this way

But I had proposed a different, and possibly simpler, solution that
addresses *just* the iommufd use case.

After unmapping something have iommufd compute the gap in IOVA that
contains what was unmapped and then issue a 'clean(gap)' operation to
generic_pt.

This is the same operation as unmap, except we know now that the gap
has no PTEs so all it does is clean up the table pointers.

This requires no special refcounting or anything difficult beyond
some locking in iommufd to hold the gap stable while we clean it.

Would it work for you? It seems substantially simpler, but I never
tried to implement it.

An alternative version is closer to what you have here, somehow
connect iommufd to the shrinker and have it lock and walk the gaps
cleaning them on shrink requests?

iommufd has no trouble walking the gaps in the interval tree, there is
a helper that does that computation.

Jason

