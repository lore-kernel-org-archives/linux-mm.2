Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D16B9CC6B08
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 09:28:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 92DAA6B0088; Tue, 13 Oct 2026 05:28:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9044A6B008A; Tue, 13 Oct 2026 05:28:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 841D26B0092; Tue, 13 Oct 2026 05:28:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5CF5A6B0088
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 05:28:43 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C71EFA89DC
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 09:28:42 +0000 (UTC)
X-FDA: 85317078084.16.A4936EC
Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	by imf31.hostedemail.com (Postfix) with ESMTP id 1D2E120006
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 09:28:39 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=gondor.apana.org.au header.s=h01 header.b=WfMo1nIj;
	spf=pass (imf31.hostedemail.com: domain of herbert@gondor.apana.org.au designates 180.181.231.80 as permitted sender) smtp.mailfrom=herbert@gondor.apana.org.au;
	dmarc=pass (policy=quarantine) header.from=apana.org.au
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791883721;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6hJ13YiNASF4v9jSRm8CUr3MziD7bZPk/IbsIdHVuFU=;
	b=teDp6gjMWVDTU4ugzfzfeokD+1JE/jR7mf2ghx4B0RPhOFxzhXarq9OtrfEbiIA6LGHfmz
	f59Feq3DC0lWiZtD5HzsSV64HDpE+iuh+QEw9qJNaMDG5UVb90wA59Tj1/JzYOCCWVCfKM
	BRT+V2ceoXBA0iuyQGnQGUWAaj+Yh9Y=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=gondor.apana.org.au header.s=h01 header.b=WfMo1nIj;
	spf=pass (imf31.hostedemail.com: domain of herbert@gondor.apana.org.au designates 180.181.231.80 as permitted sender) smtp.mailfrom=herbert@gondor.apana.org.au;
	dmarc=pass (policy=quarantine) header.from=apana.org.au
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791883721;
	b=bJK9zSupJxwtxFH48JfCE18+fSxJwOt8j66VWW+zMtcfuDFRKXBBizLY6bkgFPVi91CpV9
	1N75Hp80MRSyEdXrmW0wXVwSdAXtDZGC8/pPvL09JLBIb9cgXQbMGFAEq9OMi+K14cUYJ4
	lRVUiTsCc7grnl9HlHMU7PuSawdfOFQ=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=6hJ13YiNASF4v9jSRm8CUr3MziD7bZPk/IbsIdHVuFU=; 
	b=WfMo1nIjEzj7fpCgP4aFArUaV808tG2tyogpXRRg9RJOYydOToeyO7xCsqHucNu/SdxI55N6WyZ
	4dnHOK4CeQfsl3Bal/2OZQawNC7fqfSl/fjRbfb2fQzs3Btoul+qpoFoRXcAcoTgnjyphUNHoyNKa
	scRapRGfZ+rPDTTiZ046p91yb75HXHMPC6S/L/VrmpLMty3xoiXnli3ADscj6CobnvpSQyIFOLL+d
	WvUoAI27XPCA5e/81QBGI9E5Hzz2GZpPH2TJ8FRHCVljToqGwQLh9wImHGfjdxs1XieG7kyAKh+R2
	cqd8zfKJlyb98aeCnaNM/8fr51DA0ilOZwsA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1xGYo8-00000003JrW-2cU7;
	Tue, 13 Oct 2026 17:28:29 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 13 Oct 2026 20:28:28 +1100
Date: Tue, 13 Oct 2026 20:28:28 +1100
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Usama Arif <usama.arif@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, chengming.zhou@linux.dev,
	dsterba@suse.com, hannes@cmpxchg.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, nphamcs@gmail.com, terrelln@fb.com,
	yosry@kernel.org, riel@surriel.com, shakeel.butt@linux.dev,
	alex@ghiti.fr, senozhatsky@chromium.org, davem@davemloft.net,
	linux-crypto@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH v2 1/2] mm: zswap: use separate compression and
 decompression requests
Message-ID: <as35vERorcRxFwGb@gondor.apana.org.au>
References: <20261009163146.83112-1-usama.arif@linux.dev>
 <20261009163146.83112-2-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261009163146.83112-2-usama.arif@linux.dev>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 1D2E120006
X-Rspam-User: 
X-Stat-Signature: kg4kkh1cspfik7jipjhyx9p9pg4wessa
X-HE-Tag: 1791883719-554278
X-HE-Meta: U2FsdGVkX18I7TDCiERQP8bUraAnbXwhhpI80o+H0AE7dq5VNvhtKFJIDkgwwnBvN/0cabeUizhh8Wb1396jkJEgxmZf7TYOMxUEvamMJopzMOngt5stFEs60B0uxmcKDsFolIcwOTU+AdUGgRL06DTR4P2TUFXbOWEuTdn5qbiW+6f2bRamgkcHMFR39A37ebc4D4l6roucpWM6fjsWxUKDVim5CxcfzpKfMj0Aiu6PZkkaH9rg9wcfK064kxSqODTVWyhuj3uEI2vZWrQrUMY5tr7vPbxtYjM/VUlQ3opwE/aJEbDkXpctMI//Q9mUIrtydQcImCTqGuPt01NWyr4CB3VRceifAJaDL1Tp0opLWSxPe8hlsztmNvgyI1K4G5VZee607279+XEu4/+F4pFvMwkz5ZNq+IIlQtDhQQYytMRaHEBbPZudYN4lPCs1hgaqeqNedngL6KLmomEkPz9+HWfUR7JY+eYzBcW87zx61rTAGSbf7aHDsD3UEgAIQzjTtKTYPHCexwl0AABKEIMMsAmqA7eK4Ojg7rFTWT1/eU9i6KiKurnM9qw6Ci76NX6wB6L5UmYEkidjiXwYePKKqbuw8/UlDUbUn47HbIqvURVTM1iRb2Spc4FgcGEylXxlUZ0RlVEgyCANjpXWFuuPljeOEG6jA4VeCpEAB8fy+TIO4yIm4YjLO9/4ffjr3JVwDbaYAr17A78EPaG+OMzTsM7q4vAjsSSCN9O69QuCwenngVLhtiBYzBlb+BLb/vuP8BX/uUrzuvCR79jwDCbtAuCmnbYsGweJa8ox7CgHULn+v+4e6a+h4fCUzyrkihBUMONS1QDr+Ddm/rfdnL+pMi6895sYVxsP8WUVvDAPgHMHKQo/c69fxZT/QZjWVHNMaq199HWfbEvEYBCzJXYyH64D6QuE1RcyUKCRhitnjDTpoMmMgSgMRoOJ0OnRoq0tIBoEjandGOAY816
 YOLn6CBQ
 GKMJB3nhR9Yv3eVKAVRlNPput1iaJlyEzR1ntGFT2vh4MwdCfQhC19GCOrbrk9dxB2aQm+6A6VknL2/KIba10fGtpDg4X3nuNtNPZpoA0G9aK7LGiFiE7FVuGoxRvNLdDY8NxOb/DH8DupdteX7nkCZbDPquLcO32avOf7QPrMgzJewrnXhYiewFYJDLxJIWXrEQ+tv1zb/MGk6/tgmad3aIrz0zkLJ+pYQdMRpGIg3V4aktQGoRP2rdW2KXTcWAuOgynzBAAFapf1gefPc5GG2CiQDWfIKJflngPUGdhXVaM7zVA1vHpba3GVYonEUIx1ALFU47b2JI7AwxT7YvJtsHd7g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 09, 2026 at 09:30:30AM -0700, Usama Arif wrote:
> Stores and loads serialize on the same per-CPU acomp request and mutex.
> A low-priority store can be preempted as soon as the compressor drops
> its stream lock, while it still holds the mutex. A higher-priority load
> on that CPU then waits until the store runs again, which can take a
> long time when other tasks are runnable.
> 
> Give compression and decompression their own request, completion wait
> and mutex. Since commit e2c3b6b21c77f ("mm: zswap: use SG list
> decompression APIs from zsmalloc"), the per-CPU buffer is only used for
> compression, so group it with the compression request. Independent
> requests can share the per-CPU transform; the codecs and drivers
> synchronize their shared state internally. Loads can still wait for
> each other on the decompression mutex, and stores still serialize on
> the compression mutex.
> 
> acomp_request_free() ignores NULL requests, so drop the check in
> acomp_ctx_free().
> 
> This follows the proposal from Sergey Senozhatsky for the same split
> for zram [1].
> 
> [1] https://lore.kernel.org/all/20261005122036.718976-10-senozhatsky@chromium.org/
> 
> Signed-off-by: Usama Arif <usama.arif@linux.dev>
> ---
>  mm/zswap.c | 108 +++++++++++++++++++++++++++++++----------------------
>  1 file changed, 64 insertions(+), 44 deletions(-)

Acked-by: Herbert Xu <herbert@gondor.apana.org.au>

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

