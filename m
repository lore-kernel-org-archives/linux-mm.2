Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A491BC4450A
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 17:27:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BA6B56B0095; Tue, 14 Jul 2026 13:27:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B7E906B0099; Tue, 14 Jul 2026 13:27:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A707E6B009B; Tue, 14 Jul 2026 13:27:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7DA2E6B0095
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 13:27:24 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 01C4040461
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 17:27:23 +0000 (UTC)
X-FDA: 84988063608.26.03A47CE
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	by imf19.hostedemail.com (Postfix) with ESMTP id 3B1EC1A0004
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 17:27:22 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=r2T2H14f;
	spf=pass (imf19.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.177 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784050042;
	b=iC4i4bZTP+h0YaqjS1TBFt6ZHUT0tgjjHQFp5kwlRndCwotBjT3iXwHYHFfomG4BDBb2RW
	PV/CfOtboVskBjnnPexX0zEjPCH6ceryfdGnCQZTXaNnYjfGmw9fB4oe2oSPsMatq5cPOQ
	P3iSHuw9NDX8aNHHU6OhzQdoqU5I2Kg=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=r2T2H14f;
	spf=pass (imf19.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.177 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784050042;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cPBMPvqjLyCw7WlFPS2PjvycvnYwB9f3AC5cSDOIyL8=;
	b=tQnfnBurMePAOdzTndTbh6ctMgg1n2VB9USkXg6toOT2PhxKjL3MlmWKXIdn43bWg+Op6d
	5k4oQNYChf86x4PZdx9jwJHor+61H7b/SPMKGcbyQs960wSYWNOXChxdxn3oRm6BKnpk6I
	xMFgJFPN00CKpIsDMU+idx+HkrzLuA4=
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-84a2dcec51cso2985740b3a.3
        for <linux-mm@kvack.org>; Tue, 14 Jul 2026 10:27:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784050041; x=1784654841; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=cPBMPvqjLyCw7WlFPS2PjvycvnYwB9f3AC5cSDOIyL8=;
        b=r2T2H14fX59BIfdo5QYxianzlGwq///UBM47UqeXidF0SAypjZbwtMBn11DxN3rI8E
         qHgnSQ7YugotjU/pp2kVoDrkbQdL+ArXi7irDziwfdRN8mCq7P1/g1IvCuzZdsEiZJte
         Wsp8byALh3OztOd/ejWkuhGJBE09ZWgqwWRHlia7KHNVakwIMBx+FIPNIdNl66xVg7Kw
         hMRWMS6Z6pNoSP0Nix5vfgabTI6wCjGlp6n9//xRh+hHrFUi00VDfB7smwCmCALTrf6I
         0+NeGisr0Jsg1gcTisP39EhgQYQlupzLXSJbdA/uKvx68ldYU9OOVDwuMCwvi6pogvli
         IsoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784050041; x=1784654841;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=cPBMPvqjLyCw7WlFPS2PjvycvnYwB9f3AC5cSDOIyL8=;
        b=OlBXtz1c/KGitjuizjSE4M9sNuHtukBIoxfbr2HN1M4tzCdA+8vZvQV75aV6oaL22l
         VuyE3faqc2egfX0JrfmRHwfq0BaqoDqQYuDynlFJckDNU3FUBBsEka8AuCKiKv5YfVdy
         9OpqsrbV9igh8fQnozUuse8JHxmkh/NJ69h66rTN64i6Jipt8KJLwN1AoTWAMm+3VnZs
         xWroL+ezOlZRMYU7h5rF6mdLwExxfT6AymmNkjVbnviBdk97OGCCDXOdw3Q29WZ9+LvI
         vojn66Vs795jCBeMwbyIvxRD1E7sw6smyl7cVuvbdICQ7U3/Plw0HrSQ3KN+PVXE3dxM
         F/sA==
X-Gm-Message-State: AOJu0YxE/QQTw5sU6icLuE0h2sEY68K6raX8JhajFUVaFGRzJPoGapd6
	4Z1V7aqfzM25HangAhNWhV9y6E3N5ZTV+69e3ClIkoCpp0w/g5uVLTAHDy6hZVGzzT8=
X-Gm-Gg: AfdE7cl7sMoz/MkfAt57Iyj0O4vqMV1a24cg7+2WJ6viQ6A/LIBxrUl/AHpCcOh/NX+
	b/nPPLV+N6N4UDJAZCQQYViE0hbVheAXzKf3Doi5ghd/RCFDiAT2UK6iq6Fl0aBDLChhwVzQmiM
	seyLavlRMuz6BcJeEsuSmNg7tWuqEfRp7URDpfJ97WCvOpWtP+U8030JPkf03IDPPP0fArRudVn
	SNWubVSL6fNlR/KhIkkZSYeaGYoZKZb44xmUCH2OaDo6kSAM5ykxGr7kkm5plGleAnACT6bQ5Ra
	6Z1/3A8AbPh7vv6FIa2nMmRbAqsmnQCv3fV+V2+AUOyT3b7tY9igsu7AwEztY9hKKjO5yXtFoj3
	CwifUgRiUhn8dCKG28Zb+nLwkGmoSIIkHXzUMebd3Pdme7od8yR2OZ3Q0UKqliwOff2FqRN5zN/
	cqk4wJBzxhfBCmrhG3tcoDMb4SJgq7rWqBWVtw5foFlv22A6v5I1AsivIH9Ew=
X-Received: by 2002:a05:6a00:23c5:b0:848:2a71:a48a with SMTP id d2e1a72fcca58-84a5576ebb7mr3258433b3a.13.1784050040987;
        Tue, 14 Jul 2026 10:27:20 -0700 (PDT)
Received: from KASONG-MC4 ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84a4f6be65csm1836604b3a.36.2026.07.14.10.27.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jul 2026 10:27:20 -0700 (PDT)
Date: Wed, 15 Jul 2026 01:27:13 +0800
From: Kairui Song <ryncsn@gmail.com>
To: linux-mm@kvack.org
Cc: Christoph Hellwig <hch@lst.de>, baoquan.he@linux.dev, 
	akpm@linux-foundation.org, chrisl@kernel.org, usama.arif@linux.dev, kasong@tencent.com, 
	nphamcs@gmail.com, shikemeng@huaweicloud.com, youngjun.park@lge.com, 
	Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: Re: [PATCH 1/7] shmem: provide a shmem_write_folio wrapper
Message-ID: <alZxI0lgMDG9Ri3D@KASONG-MC4>
References: <20260713093350.2154226-1-hch@lst.de>
 <20260713093350.2154226-2-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260713093350.2154226-2-hch@lst.de>
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 3B1EC1A0004
X-Stat-Signature: ckxrr4861fwxysa8e311187u9tymuypu
X-HE-Tag: 1784050042-557835
X-HE-Meta: U2FsdGVkX19aorl+XNRlN0MWm9ju+/CHbElYJqn5mI8+lqdACQkksnbt3zeO0cj/Hdg/rJlbV8k/2kqIMeL1g3wNzpdTIoexbJn90KccOXBRM3kTtZS8ovy54TmCrWz9xkzNZ5YxR9LmygDlnzZmPFuyC++Yz52gnC1x4at8IJipwJt05Gx6JUWwC2gQmNYPYEfPLqmxUclzhQ9R9GtW3ueOFOn39PhREIhKdx/ApiUBFoTw622K7z7i54A4O2EKYDAfWRxibINt48z+azhIUJKIVecISziNSPB91WMgvMBPwo9/PqkqQ1ecTuZ0zisi2jOL034O3CW/JaeU9oPJeLTlVdSUODsArifffvX/u7RvqlUt5+1szpC3OOYlz7tbFtFCMXUrJZXJ7hurfQTSEqbDwjAtwQXwgq3akUDMovOSV2XV2UnJrJs5HcL6m5VvTqEhKazuTpDCOeW2yiOcmtjKlfSVWwBMi4WSPXCAKpCSmICRklPRJy4cIeNvIxyd5UD7ikys9DR1eO+4iWz2uQ9dkeIILaVQxV5eFAKpf+XH5hXwKtZEz6dSxTmT+vtLmns959FLlU0mtUjYzgDLWYGdL+ocdvWOVU+a//QqA0Lp7QCPiTUbQOyo9uAeXThJyJbc4lkKm7REC8aPbGgh/2TopTd0gJhoyrLQ6WxJrhPLfNQr4zNnx2tP+o7sk8XSFFFfJ74bUZE1NAmV2qd12mA++JD+CzXwFxs52FLGaARI14DEPHfCXrQqklC23iAd2F+zf6rheuYiLEpwA0Jdxsy0xlc3EdLmYYVH+LwBeqj1htaFRo/c58OcwH+bJzCacyat7djmK4VxMyCbUfkAFGTYp0Zy3FTE8A4/89+mA8Zieky/Ty2OEYGEEXYVTPqK+WjEzYVlH6+YiKFzUrSZw8qazh5yaUYBm8BjItnOGw1ZNf/PlgdSsz1M0KaU82eG6fC8I1k8/gVcnN/yYxN
 fqYqATk3
 otLSuRGtTXn1DlQEsp9axxPEdb8orqUNUEgP3G66JrN1Kuhqnfj52guicl1WQRNKk1u8XtNiCjZly1ZMDYQf4lGx5FRRbBOvyPgg5O9o6l4RWIKULgZ6P5cPeYfILvPU10k1aAjZs1mgNGK0rzyx1h4liwY0zBtDaFLnFqAKsBpVJFrnjyhncXXR0djpuwfbNN0mx9ob7Tkjh5gc7yg4WygF3peU6wCQidOl82L29cAaqviCN+TSnWJMcUPyEjPvEF9Oz9k8NCRfS6T8tD97QNsgYmUoRsw68+0jaInXca3CzukWWJ8dCsI1pXYw9l2nihLyd9IQz7OzoTX8FWzK/AOTsI9x2hZ4Pxsb39HZ0gs0bbiL0t3BbCDGw/IHGorJCyQSWYW9IXoUlnzWH8LNoZ4gexQj789xBvNaEdH3Z+css2R/s6Ny3NG/qgViw11DXwbheZy78hNXRJviuoL1Hpw8f7CuW6iKM1dYEvsM8tKS9378yrtD7Sa1V1twehuB4QpxEQdMP9Y+wur74EC8ZC6bFz4k0F9q5EIRgalKnOfAJvTbKgsCWOlfZKg9qrXQEfTZm
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 13, 2026 at 11:33:38AM +0800, Christoph Hellwig wrote:
> Provide a wrapper for the shmem abuses in drm to prepare for swap I/O
> refactoring by keeping swap_iocb handling entirely contained in mm/.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Baoquan He <baoquan.he@linux.dev>
> Reviewed-by: Nhat Pham <nphamcs@gmail.com>
> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> Acked-by: Chris Li <chrisl@kernel.org>
> ---
>  drivers/gpu/drm/i915/gem/i915_gem_shmem.c | 2 +-
>  drivers/gpu/drm/ttm/ttm_backup.c          | 2 +-
>  include/linux/shmem_fs.h                  | 5 +----
>  mm/shmem.c                                | 7 ++++++-
>  mm/swap.h                                 | 4 ++++
>  5 files changed, 13 insertions(+), 7 deletions(-)

Reviewed-by: Kairui Song <kasong@tencent.com>

