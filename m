Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CC84C606A329
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 17:31:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jWxQCPN5
Received: by kanga.kvack.org (Postfix)
	id DB1606B05B4; Thu,  5 Nov 2026 12:31:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D88736B05B5; Thu,  5 Nov 2026 12:31:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C9F126B05B6; Thu,  5 Nov 2026 12:31:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A8A946B05B4
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 12:31:32 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B1E5A160B7E
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 17:31:30 +0000 (UTC)
X-FDA: 85401757140.19.5BE3A2E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 16A281A000B
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 17:31:28 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jWxQCPN5;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793899889;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TcMbrvUa/Jn6BjKU7oUBvEJq/dCe8gc8v1fptJk89gU=;
	b=WglSalLnmVzpwoNX0eF7CGmUMGTwhV75M5eYDqL0ecXLyqNvcH42wpKr1ELOrXfNjwSXhX
	yK68KLgwVWOmnQlfENRMG/k5X4pQRq0gp4Rfo+zbtSMrh6q/Q5JXjS1WsJBToNxrTV7wrK
	LEFlr/HLyGS2qzzOuSRrxii57H1MhpA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793899889;
	b=DD6qMVHYNcF2f5wO4Us3SfQOWcr8fO8Rzqgb9GjsxfSaEphkyhzpxbgW9Xccsv8IF4cogp
	CztqqIEd/zQWDLNzWpPyzwVxs0POSW9vGrkXTrSwwYCUgcz7EguQbWQ4uAqEG4tX/89CwP
	MAHPxUVHRXK0pwrmAyPT1IuOIbuBS38=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jWxQCPN5;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8FAC9600B4;
	Thu,  5 Nov 2026 17:31:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D707E1F000C1;
	Thu,  5 Nov 2026 17:31:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793899888;
	bh=TcMbrvUa/Jn6BjKU7oUBvEJq/dCe8gc8v1fptJk89gU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=jWxQCPN55VFFys0nT754bQjrRCw1asZfajfVXdgWkVrrDspEBVBXI/6ArGw5i2i1I
	 oCvAeLM4QUKgS+QsnAvC44mvCYCzDfs94C0QEAbU4L2MWmUjs+QOAIPNe7ZEXDpGHg
	 eHOLgZaDHxULDAbgQf2eJb2pVK2rg+w6NYNqXden45j7vvuHcJvmEsVRY3KsswPP3f
	 pIdgDXsC0r9xESnq7WChd9U/jBCnIHTzRbSRgMcxMgYEShTdLyZPzsXbQId9fvTWLP
	 BIGOfiACG11lPr5e9CIDGnv1vEcVlMuA7YR8MTTOR5x2t6cY2Z+aSAZlkd5js2rp3m
	 rQapNtqIzirjw==
Date: Thu, 5 Nov 2026 17:31:26 +0000
From: Yosry Ahmed <yosry@kernel.org>
To: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Nhat Pham <nphamcs@gmail.com>, Yosry Ahmed <yosry.ahmed@linux.dev>, 
	Johannes Weiner <hannes@cmpxchg.org>, Brian Geffon <bgeffon@google.com>, 
	Minchan Kim <minchan@kernel.org>, Richard Chang <richardycc@google.com>, 
	linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 0/7] zsmalloc: redesign object alloc API
Message-ID: <auy9UfB30AlYabV8@google.com>
References: <20261105044752.1997895-1-senozhatsky@chromium.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261105044752.1997895-1-senozhatsky@chromium.org>
X-Stat-Signature: ncymajgwgzgj64rek7ipyd48yi3d7znk
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 16A281A000B
X-HE-Tag: 1793899888-584266
X-HE-Meta: U2FsdGVkX1+sgSLgo705E49G25anm1X85R1mNOIoUoZj0IYnz1vyhSJnIZsUhJHA3MarHObPIyyMeHpBrWVvxDfsOT39SPE/mhXDfNOHu0LgSh4Wjuc565CKDMtDzKoC9oTSnLLrNfnrDO79znPDTinf0RoAbpcnEJ4KP3RYCriBb2x0MtK4aoS2XNGvDPlWVW2nEeWleXkPjhWXX1RxY4rHsRrTLQmcZCggK72/4Or0zUZpRBrV8/mPZwEiikDkgkeHPV5CM/0qTsd8kxc6zJlTPWwGhkC3s2OPK2HyihoPbU3Nm6wmqQJM+cYhv9pQSh/IB+4PMLmkiWmu8vgQgTOHpSlgR2Gh3UVgMOEntPeteO59ldUgqiLnUgf/T96/7yb09uMf90xTCqic75cPK2Jo5sOm54y+Iey7+wfA39IsxU+hIvSY4jfVnTpyXLS+TdyRAMni3hoHPCE/MkyL8JcpIsmagtnrEEKIMeVjrt/Sm7+2O62A4BItxjv2qFW5xl/78V4aSsNX4FWM3lzcIiMTM2LFZLPOOT3Tn4nhlJ1T9Exac6sUL0+mzPBqEZ9h0C66Gn+YuRKuxvn367Y0vMQqSa9h39x8G6aI8UVUhELUyDQGgxdyDoFEHTqlknNW1udFeqYFiq6gAwaH1TTYlz5TG04TklzL7PooZNjt6AzThAiRKUk/ribZN4ZhQeZ5gKI991VOzEj1LJ6qU5IOq/VOtl644dsr6RALYJFhm8oz2cP61P280oLSWFcIpBq8sXAVlIehmlDBeQm7j+l0GuTBbnfn4G5h2PXEj1wz9Yy3vP3rl9llOJGFqnNBQKX7OVUfKfluMHewR+RcAP/o/2jw8OQa8C7A1ckpAhYTefbPLqHMRBz1TzXeJXzff8fkuXmLcdshDUUHlSArijQ4WrO7017M/hLDbrV14T9E9lxtfq4EFKnNhVvjY2yB3ASo4L4uZF5TED/lWqTd8BD
 fKTPzOcG
 CwrRxhAcEMQAKhvUJuuNdybm1guNW6bPyYxw9+OB7QODPFmFIhJEU4e8wAy0K765hFFnWXcJ7mHKIHurFhPqOKcwpmj+EUJHvCyKHhqeUVRbqSFKDp8e6k3Yc49P1eAU/oabV4Fpot0+P3ea+7zgk00/d5oQLZnAzbTi8gIPlr0Vy9QS5/9OqZVzsDmrdGvshDW8Y5CAFRJ5eOLaTtg8/0R07sZd6GJNzFGmiYnXehPJde9iR9I2CrXKSaP5KvAJmzFWM+gVSangNkHlDModccTOeyd+XKjTAAMRV
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 05, 2026 at 01:47:30PM +0900, Sergey Senozhatsky wrote:
> Both zram and zswap already have per-entry structures that store zsmalloc
> handles, so allocating a separate handle_cachep object per stored page is
> redundant.  This series embeds struct zs_handle directly into zram and
> zswap entries and drops handle_cachep, saving 8 bytes and a slab
> alloc/free per stored object (2MB per 1GB of swapped out 4K pages).

I always hated that extra layer of indirection, thanks for doing this!

> 
> It also folds zs_malloc() and zs_obj_write() into zs_store() so we don't
> take pool->lock and look up object location again right after allocation.
> 
> A simple zram test on a 24-vCPU VM
> ==================================
> 165 fewer kernel instructions and 0.7-1.8% fewer kernel cycles per write;
> lz4 single writer +2.3% IOPS / -2.6% average latency;
> 24 writers +0.9-+1.0% IOPS; no regressions.
> Memory: 8 bytes less per stored page.
> 
> Sergey Senozhatsky (7):
>   zram: drop stale comment in write_incompressible_page()
>   zram: drop get_slot_handle() and set_slot_handle()
>   zsmalloc: switch handle type to struct zs_handle
>   zram: allocate zsmalloc object under slot lock
>   zsmalloc: embed struct zs_handle into zram and zswap entries
>   zsmalloc: fold zs_obj_write() into zs_store()
>   zsmalloc: constify struct zs_handle pointer in read-only functions
> 
>  Documentation/admin-guide/mm/slab.rst        |   2 +-
>  Documentation/core-api/memory-allocation.rst |   2 +-
>  Documentation/mm/zsmalloc.rst                |   8 +-
>  drivers/block/zram/Kconfig                   |   1 +
>  drivers/block/zram/zram_drv.c                | 130 +++++-------
>  drivers/block/zram/zram_drv.h                |  10 +-
>  include/linux/zsmalloc.h                     |  37 +++-
>  mm/Kconfig                                   |   3 +
>  mm/zsmalloc.c                                | 204 +++++++++++--------
>  mm/zswap.c                                   |  21 +-
>  10 files changed, 229 insertions(+), 189 deletions(-)
> 
> -- 
> 2.56.0.398.g882cbad275-goog
> 
> 

