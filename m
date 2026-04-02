Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 84335D39410
	for <linux-mm@archiver.kernel.org>; Thu,  2 Apr 2026 11:53:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 708396B0088; Thu,  2 Apr 2026 07:53:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6B8816B0089; Thu,  2 Apr 2026 07:53:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5A71E6B008A; Thu,  2 Apr 2026 07:53:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 44B656B0088
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 07:53:04 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id EDF0C140409
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 11:53:03 +0000 (UTC)
X-FDA: 84613454646.11.E1D0BAE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 594781C0012
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 11:53:02 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=X9zqSrLs;
	spf=pass (imf20.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=X9zqSrLs;
	spf=pass (imf20.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775130782; a=rsa-sha256;
	cv=none;
	b=UuvHVRE2CIFWIL1L8jMsg7oKkb/L9lS+8jOtd8C9S6v79CZhKXzd6OZ2/aFEgV1m5foz1c
	ql3+P9NJgTiqhD7+4EB7KGAu3LPvFJHloDSgkhJiGGg3FTgOXXAnzgZ3T2nhQszkZhswt7
	qz/nrl0JZX0Lk2K8oZEWoDSrakvZG64=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775130782;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FIG+dtjlc50T220cr4UQI1zkSr1M9UCN1q39RH3T4pU=;
	b=CpWIgR8/0E3VEN4Dv2O8c1x074q6ah/t/Dh2qv5d6ityAHdmDh4DU7rFbtNhFgGbhwDelH
	9j0xqIDYwlTQtGXDUzKgbLwttmY7TrDR03dicXMSHWZGHIyl4MyfzeMnvopBMehDGqfoZd
	fmFh6qU6LAOihjg+Up3av/kvs/yu7h4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 808CE61871;
	Thu,  2 Apr 2026 11:53:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 465B4C116C6;
	Thu,  2 Apr 2026 11:52:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775130781;
	bh=xFKo0RxOD1QivUiQP/oktEu9oeMoK1I+zrqYjCUBHV0=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=X9zqSrLsEyUZd4OFf5vWkrzZm96rI5bvpyxzVpqUlDtv53Rg187U9V2FH3kBYTH1s
	 h2blaunJFqigJrhle8d/Lbok4CFqI5g0o4kHisLf/gtQbbN1vA2nNHC7Cp2kt1ifVP
	 wvzju1eD3iugAO5EmyY/JCClKkiTQBPKOZB0TlZqNNKtAviBJ3G98rCk6Lr0wj3L+z
	 kuqe2fhiBqTtDKRVCtxjGyXJm+xjwASQBj8Bl/5O9QlrjwO6f7vtgXaOoWC4XtAacK
	 Rf0qd32dLF0Mzlw/Ux+9A6A/nvbtyHNTnvhQZbKeEZ4PBMhAECMzw760iodLDNqgjg
	 BMxVJk0xvXhjQ==
From: Pratyush Yadav <pratyush@kernel.org>
To: Chenghao Duan <duanchenghao@kylinos.cn>
Cc: pasha.tatashin@soleen.com,  rppt@kernel.org,  pratyush@kernel.org,
  akpm@linux-foundation.org,  linux-kernel@vger.kernel.org,
  linux-mm@kvack.org,  jianghaoran@kylinos.cn
Subject: Re: [PATCH v3 6/7] mm/memfd_luo: remove folio from page cache when
 accounting fails
In-Reply-To: <20260326084727.118437-7-duanchenghao@kylinos.cn> (Chenghao
	Duan's message of "Thu, 26 Mar 2026 16:47:26 +0800")
References: <20260326084727.118437-1-duanchenghao@kylinos.cn>
	<20260326084727.118437-7-duanchenghao@kylinos.cn>
Date: Thu, 02 Apr 2026 11:52:57 +0000
Message-ID: <2vxzzf3lfujq.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 594781C0012
X-Stat-Signature: ofhdfqx75rdreqr6xkmbcqxj1xaceq43
X-Rspam-User: 
X-HE-Tag: 1775130782-823385
X-HE-Meta: U2FsdGVkX1/QvkKmCh9elSIyQpHX+Qn8LWel31+GWs15p3ZFoxeOar0fWP5vRxV0LjCJzj550U/nZ+t5txg66Ww+k2+RY38ID6pWDA7zti+7BxL2S1SELsOtRZvCFbyzJ5TvFOPa4T6d72kbuwgpARTqFp2iaaDprFZU9KLmdqSptMpTxywNgx/QIXL83fFhaOQBMjTggOsM4gA0gSK0B/f9A0rzPfjpVZ63TvEW2Rt9osXzn3emOLZ6Zu/E0MIw5S7nX3anHFupu2/G7SvZCDx0QCF3HdFlR4M4jGPnuDGjzIS3hruXa/Igpyab5x4UxZKxxZ/NC9ItMfCksN88oOeBMrEXMQDGJVUlLctYjdrTRGPQb4CNb6Zzl1DBLez7C6mOtmtux+8kjQD0op4lYU1yLr7DZ34wSdHtC/b0M+g+c7dF8DijA/3KL394VpVuCm23hEoQuCal9TcpWRQ+HhUPX3vIXCBV0Cje5bUr9/A8ToLbbspc2JDFHdcZz/tQQwBybf7ytMcEBRoNS7ukRJHnashqLdkX5G37rFASIuWyy6oPRQvmHtU5GfoAo1H1bolNd7vz6AsxdFOk9UjwtJniXh3BtOMuB5hGv6mSCvURveEBOJGQW68IfnD36HYmZAuy75O9ZqTLjwpcGwuK5/dWb5WjOXkqKwipw9eYtiY7AGOoOGU7/sRZuB6Jek98CRa7i2NUhCtjLHRYFvNCwXWv/o8sbjI7mQmv6jx6u2rTwBk91pdVfHjKVkPU+/couLKtIKioLs5ORt3d/19RdpMstQpxKaio/lOtdeVSLNC53tOZMEJjuRMWlCHXxxx+bKZXoWbCkQJt21tcubr6H1BDSFJRx8mRsPcgbSvcupH1bSLly4PykyD7rYho6++TYip5RUwKutInzref9QctP4nhVRrIBX4AgVR2cHpYY6AwGcEXXuS2hksXur9OHeAp5YzSzkQKIuoX5By0I5p
 7TiX2QcI
 +lnWBSbnRWUX/jsKUm/eIqWJnLOzgbzvGwMLlaJa4WJNrpZJatC8/HIrrNoVScoLuFS/Mzbjb9SQQS0zWXDv5t1dzJD4bIIaqcUgqwppBaDmXgPudnBZvit/bTCnq62oZoch5DxQUrKTaHgj4GVytpNC61iAd6XzmEK8d7AxljiVKx2Wmn0a3K1yAXOa1v+CACTqQiTmeXEuYTclUr1CVhIhSDhHzw98gTAZXJvqQDyecV42c2DjdBIaLfvj+Eo9Lhglt5xbxoFT4FMq2XFXXxHiMUcTXTqQY3HPJEh5v/A3TTSs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 26 2026, Chenghao Duan wrote:

> In memfd_luo_retrieve_folios(), when shmem_inode_acct_blocks() fails
> after successfully adding the folio to the page cache, the code jumps
> to unlock_folio without removing the folio from the page cache.
>
> This leaves the folio permanently abandoned in the page cache:
> - The folio was added via shmem_add_to_page_cache() which set up
>   mapping, index, and incremented nrpages/shmem stats.
> - folio_unlock() and folio_put() do not remove it from the cache.
> - folio_add_lru() was never called, so it cannot be reclaimed.

This is just not true. The folio is _not_ "permanently abandoned" in the
page cache. When fput() is called by memfd_luo_retrieve(), it will
eventually call shmem_undo_range() on the whole mapping and free all the
folios in there.

I went and looked at shmem_undo_range() and the accompanying accounting
logic, and all that seems to be impervious to this type of superfluous
folio in the filemap. Main reason being that shmem_recalc_inode()
directly uses mapping->nrpages after truncation so even if you don't
account for the folio, as long as you get rid of the whole file (which
we do) it doesn't matter.

I think the only place I can see this causing trouble is maybe in LRU
accounting, though I really don't understand how any of that works so
dunno.

Anyway, I do think this patch is worth having. It keeps the filemap
clean and gets rid of the need of this complex reasoning to figure out
if this is safe.

So I think the commit message needs reworking. Perhaps something like
the below:

    mm/memfd_luo: remove folio from page cache when accounting fails

    In memfd_luo_retrieve_folios(), when shmem_inode_acct_blocks() fails
    after successfully adding the folio to the page cache, the code jumps
    to unlock_folio without removing the folio from the page cache.

    While the folio eventually will be freed when the file is released by
    memfd_luo_retrieve(), it is a good idea to directly remove a folio that
    was not fully added to the file. This avoids the possibility of
    accounting mismatches in shmem or filemap core.

    Fix by adding a remove_from_cache label that calls filemap_remove_folio()
    before unlocking, matching the error handling pattern in
    shmem_alloc_and_add_folio().

    This issue was identified by the AI review.
    https://sashiko.dev/#/patchset/20260323110747.193569-1-duanchenghao@kylinos.cn

With that,

Reviewed-by: Pratyush Yadav <pratyush@kernel.org>

>
> Fix by adding a remove_from_cache label that calls filemap_remove_folio()
> before unlocking, matching the error handling pattern in
> shmem_alloc_and_add_folio().
>
> This issue was identified by the AI review.
> https://sashiko.dev/#/patchset/20260323110747.193569-1-duanchenghao@kylinos.cn
>
> Signed-off-by: Chenghao Duan <duanchenghao@kylinos.cn>
[...]

-- 
Regards,
Pratyush Yadav

