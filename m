Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0352ACA0FF2
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 07:35:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4D5BD8E001B; Thu, 28 Aug 2025 03:35:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 485BE8E0001; Thu, 28 Aug 2025 03:35:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 34D198E001B; Thu, 28 Aug 2025 03:35:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 20B758E0001
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 03:35:33 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D669CC0A06
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 07:35:32 +0000 (UTC)
X-FDA: 83825356104.06.3C72CC4
Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	by imf11.hostedemail.com (Postfix) with ESMTP id D0E2840017
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 07:35:30 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=MS43MPmF;
	spf=pass (imf11.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.49 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756366530;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7wdLKdu3gRydbgkaOExgCyxr/LuNr8ANanTK9VurXYA=;
	b=Nvchs1Z2HccuVBPHo3sAs3VhPffiGcSp01cNOpCpO3nuVbPFsIceCVpDkUcmnsoQU8rbJ9
	RZHXympB3gyUlTFE+6L/iJZi5eCYvpXITrDHAkCwK6I6m5gm1/UnrNgdr/1t1uyavJIAM6
	z0lmOAhl93pPkap0hSbwXzUlRW8PjN4=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=MS43MPmF;
	spf=pass (imf11.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.49 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756366530; a=rsa-sha256;
	cv=none;
	b=n7BpryLWd/4NHh2Yvjrnt8p/xCBSduqc13kBZVHJ93MXiS5YID7jEuGkhP+qtahy0Ef6h+
	bjDbqvcNy87HdUy+bUWqsvQfLdfChW4sBiOHlYywncouq7DLn+GPB34vLLyKMImjdoXJ9V
	zXFXqPQPo7dOf5eAPX2wHT3tLB/zJY4=
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-61cb9e039d9so1215483a12.1
        for <linux-mm@kvack.org>; Thu, 28 Aug 2025 00:35:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756366529; x=1756971329; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7wdLKdu3gRydbgkaOExgCyxr/LuNr8ANanTK9VurXYA=;
        b=MS43MPmFGNEjC397hp/iDyNlUGKpzWp1M2FuNac7KujtYVSGapcOhx8DHvE8MYdYTJ
         DdXsn9fa9+Vq2LuEGW8WolX/E8UBcx9TOxWvasLv2CT7C0FLZ5WpvlQhpIF/hsQbfqdt
         W7vIT++lLWzAPPhTbriZou9feDPr/bngyjADc4tgn0d/ZQsPOWdD/laaQ6Fqg+5e3sOf
         2Ai5sWpRVqocZPoo4ReSU2wx4ETRcwUyXmBgwBL1eqvdUKqBtp7gY6py3Y34yR4anzHj
         Yx69nKHlYJEtiMHxdy/ZQZDJ5Ay+lYrRHrtOOYedkhOFnvtSJsSKrUoCZmiP2fOj8xda
         PeLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756366529; x=1756971329;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=7wdLKdu3gRydbgkaOExgCyxr/LuNr8ANanTK9VurXYA=;
        b=glMgs52MPUjXOgYBBYVvak+Ynairc4sxJkRi7R/qY5enz/TWJkv4Aze130CSR9es7X
         fgTCp16+sICisEhwsXCw48BymC5/6Ofi+Dp002ltMm3tF3SeyxamRNinpDVNYj55lhNU
         hGqxk/TQgLJjhCKf6iUFa1xGBiOEVCfrgz4g/CoWrexsbLQAOzbGHjI1aLz0ZvDwxgbI
         vJWHW+isLzmvWy5iG9wzC1LCIgD0VUrvcf+x3z8IMKOdWeP6PbeS59qMNudBddtq365x
         WshW1ozr77q/Nm7TJ0QDGNDC2xm29731MMHs+Ov0Wtv64xEKtr5Q6+kDkvdC/2dqGraE
         fSiQ==
X-Forwarded-Encrypted: i=1; AJvYcCUeB0gKgOrwlzkx/mRYKT0l2ivCSZyNa3Hz0sBaZ3eLv2OQkMretyrAuBPi8zN5z39dgXDQt6RnKQ==@kvack.org
X-Gm-Message-State: AOJu0YwyEainOtdrB82ZkFWy1bEpXAlAtl2JihFXRn0pxUakciMe130e
	3QDwivMt7yd+YjiNC5MDm/jSk30N6/muarH5Io8bdlaFO3Mxf/16e45S
X-Gm-Gg: ASbGnctddJLCeHD11g8olU34jyWHHGMfQaf/tLetlf/qkrZqzXD4PTtSYzGH5BZkTzl
	EKXSgKqD9qnvfeuGHX2US/aPEJlA5UHTr4uUiiz5OW+LO0EKDnS4qgY7AFajk6zV6hYp/tmk+9f
	ddUWic5J0c35CcDSwT89DBJ/5g6QQDup45bRyxS/HK8QDa2PQ7fB0FjnUuW+zc8j/tE1QoD2lrR
	rFXms+XDZGAh6eckAU5ng7Nf/cjer8X+4gQjTlXbiKJrFXOG/kIxo/oLXmoecLusQ70l34O08bp
	dLfM2xF/Im/XyDV1de0Y4L/X9cWzzLqYVdaTEZreiUAnBDoBxqcs9VNSbQu3YGh0/VogPAy1JXX
	g2d1u9L+8dDW9KUedJcXnY/9g3g==
X-Google-Smtp-Source: AGHT+IH+/HdQFSXw/W0bPc1NEIz4PAWk+piUx/7dt/vdSor64JcoeKILsFtoJ4Brv3+pRvjO+XdeaA==
X-Received: by 2002:a17:907:3f0a:b0:afe:d590:b6af with SMTP id a640c23a62f3a-afed590c109mr310258266b.20.1756366529084;
        Thu, 28 Aug 2025 00:35:29 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-afe77c2b758sm886311466b.84.2025.08.28.00.35.27
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 28 Aug 2025 00:35:28 -0700 (PDT)
Date: Thu, 28 Aug 2025 07:35:27 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: David Hildenbrand <david@redhat.com>
Cc: linux-kernel@vger.kernel.org,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	Alexander Potapenko <glider@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Brendan Jackman <jackmanb@google.com>,
	Christoph Lameter <cl@gentwo.org>, Dennis Zhou <dennis@kernel.org>,
	Dmitry Vyukov <dvyukov@google.com>, dri-devel@lists.freedesktop.org,
	intel-gfx@lists.freedesktop.org, iommu@lists.linux.dev,
	io-uring@vger.kernel.org, Jason Gunthorpe <jgg@nvidia.com>,
	Jens Axboe <axboe@kernel.dk>, Johannes Weiner <hannes@cmpxchg.org>,
	John Hubbard <jhubbard@nvidia.com>, kasan-dev@googlegroups.com,
	kvm@vger.kernel.org, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-arm-kernel@axis.com, linux-arm-kernel@lists.infradead.org,
	linux-crypto@vger.kernel.org, linux-ide@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-mips@vger.kernel.org,
	linux-mmc@vger.kernel.org, linux-mm@kvack.org,
	linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Marco Elver <elver@google.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Michal Hocko <mhocko@suse.com>, Muchun Song <muchun.song@linux.dev>,
	netdev@vger.kernel.org, Oscar Salvador <osalvador@suse.de>,
	Peter Xu <peterx@redhat.com>, Robin Murphy <robin.murphy@arm.com>,
	Suren Baghdasaryan <surenb@google.com>, Tejun Heo <tj@kernel.org>,
	virtualization@lists.linux.dev, Vlastimil Babka <vbabka@suse.cz>,
	wireguard@lists.zx2c4.com, x86@kernel.org, Zi Yan <ziy@nvidia.com>
Subject: Re: [PATCH v1 09/36] mm/mm_init: make memmap_init_compound() look
 more like prep_compound_page()
Message-ID: <20250828073527.u4k47fohaquzf3pg@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20250827220141.262669-1-david@redhat.com>
 <20250827220141.262669-10-david@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250827220141.262669-10-david@redhat.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Stat-Signature: 5n6qydaatok5z11ifh4ytueeee8nwf31
X-Rspam-User: 
X-Rspamd-Queue-Id: D0E2840017
X-Rspamd-Server: rspam01
X-HE-Tag: 1756366530-165964
X-HE-Meta: U2FsdGVkX1/u3OSy5tgz0HnguBkbtPrapu6GWLsNa8CXcQvEEzmat46+W0uhSvf+tQ3soKnp2nlCKy51H615VyQ0X3vi82gYl3BhBHzpLpkCFnTJoLYA/pGexbSHDfC1g+nmCLkmnbrYunUDN9JSevTwfixVDj0dsYwIiVNGoKpQmuFLO2lHm+BSZBruflKDxfPnxd/X6UWHUE3+a6ng0/4sIcHjdzrq9KTs9sjQlvm5rUibYXZDwKaUXmWU977sogP24H4I+BlVpUjekg0sSIQRaUNU6tNcEEiLdPwfV4tqTHA7Y+BxrBd+7f9GvXyCETOd+2gHjo0rVnewYTXzUNAXpxQld0qz0g53tGkhwMXtPDkhPkTZ6cVZ3WfyzLMaobLy7GOmhvTWvwlo4zShIH65aP8ELMatafmZEKTYitnIAgleiXsl0P+zr2lz/TaRLdRG9Ij+VHhglRM+JcfGgnM5UwaMq83gFGuKmUi6aH46CM7hgVmh+SwjqPGO/CJNWtl4doEc+RqTfD+nvcZWkD4QMOAkNZpCor50zCgGurStgDMW92z4rGo+iGC2MjHWYIOmUPQMThJNw0a4qs4iXoRv6flL9aaUcJ8C9hbAPZmyddPrKcfaQs0mn+8OcrL7sqTwqxGUxZtBuf9HbiV+arzCnvsCRN9JtnMEmtEm/s4sOkzsUcLWyExUFGfHVWEwX4N32JEVp1whTzCtSKnTdsDzn7vNIS67RBYCRRgYlke6pgFbZNYqDccKeeahP2kfDYtkHUwwVABZNHZJqmS34dAzm8DO9v+6jJg+wMErKQL9EtcYhvjeBZmU3xSL2sWPa+ekLDa+LQDoGsHfT31djGtznG1GW2gt8AchQ6ctglSloIMy3Pt8hDb+V+Aao6EBq/ZrxAxKA6uk4NP0r/GFV1t4Ne+mtWjmTFa7oBTObLTHrnG5rLkB/K4X8Eb8kxXTztU/rC1WIF/sDOSAVJS
 q7sdgoZU
 CS2g6uWrLo7MqbFiBfGkvY+KwT1L7YW32n2zLEVTEdVjxj0Lnex7kbq8Cej/bDsy0bSjirZgFNPfMSZTpjCsCv+AkZhbMeGZtv6wPP+4wSNRxiC9FnozNLRM0mxBqu37+nlsrDs0vXYr5dsl9RYQ4HD7jTD0adbGMhSD7srEPVy1FU+ql40Ns2joDK+u8D3H2yA56F0RI96ths0pWr1k3/T1i9hxe8TGEQYUGY7xagCXWrEqhtnY6fkRqktb9x0HIUcj78sUa8gij6gk1TCE6HzLrQvd7LuaTEmuiwcrMzloBCRvZEOhBChg3LI4v2tV3LuDhnBYIlmpX2UQ9TW2niht46/WStvcC3ePFeumpryjgz4kZXljqLvMIRcjyJWxWfq23Ypnv7kddCOohfW+8TV6vAjSytQvE0AJZNz5OV7Q7OH20Ek0a6esAmBMCuGgzi5ZHk4ua8DoVj+WLlsgQqK6nVdg6CfSxze4s71yceBUe+fqPrRaYDj+lS/7d7viF8HEiMaQgKEi6U5E4baD8ZaqNFdIvmXfItDYPOb5P7/4qHFF3OTJqgC0WgpcVRpAcYbhmsHFezSbYOzLtC+pjYp4jSQ2/ut9jNQh9fRj+4cWSemEdim2k+la3h4Jbx7EXwm/45e9alD1vz1ul2aTBUySdBoP1/UKYPAlTsVHfyClBVIapYREQWCttUlLR+xDXNGO4/ZX50v9NaQPeJfo0KDn1LZVg8UUM/d+C87Q1wy25D29syE7kjvNyHg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 28, 2025 at 12:01:13AM +0200, David Hildenbrand wrote:
>Grepping for "prep_compound_page" leaves on clueless how devdax gets its
>compound pages initialized.
>
>Let's add a comment that might help finding this open-coded
>prep_compound_page() initialization more easily.
>
>Further, let's be less smart about the ordering of initialization and just
>perform the prep_compound_head() call after all tail pages were
>initialized: just like prep_compound_page() does.
>
>No need for a comment to describe the initialization order: again,
>just like prep_compound_page().
>
>Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
>Signed-off-by: David Hildenbrand <david@redhat.com>

Reviewed-by: Wei Yang <richard.weiyang@gmail.com>

-- 
Wei Yang
Help you, Help me

