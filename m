Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 208FB606A83A
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 17:00:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RJjGS4aJ
Received: by kanga.kvack.org (Postfix)
	id 3AA656B05B0; Tue, 10 Nov 2026 12:00:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 381AA6B05BD; Tue, 10 Nov 2026 12:00:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 297516B05BE; Tue, 10 Nov 2026 12:00:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 03DBB6B05B0
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 12:00:19 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7FFB1409F1
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 17:00:19 +0000 (UTC)
X-FDA: 85419822558.24.F03A215
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id B0FC8140005
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 17:00:17 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RJjGS4aJ;
	spf=pass (imf09.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794330017;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=e9tGyPXz9xL70oEPM5OS0/SNYUGPcdfzb2vPyxxeOIc=;
	b=mn/YRjNw0A6mAqlHovnMykm+Kb738z+1zrN1mbbrCO5qtJjvH6Gbx7APq9WbyctjtRFV4g
	ToXfZ8CYIf2EqrSS24ql3FcCxzepX3YOVZWu2gxYLoMmP4hu7p6wvP2ohDE86+hD0QyKSZ
	MFdxENWe9i+FHoJZqT5nQufAybZyr7w=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794330017;
	b=Z26X+g1wpK+O/6LtjB3gQAn+Bl7dELE7GZohGcy0A0J4BbkYONxkE+StIB+W5E7CqQynp3
	cRSedS67kKPVfbX9ip6grxqm+SCSE4fJvmF4QmsloUFnUNNUYBdJx2Z/Liw6uSA1TSdhSu
	rNsa5lWXjFUwUIVatPSsE6AFpPtb9yk=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RJjGS4aJ;
	spf=pass (imf09.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E8E0543EA6;
	Tue, 10 Nov 2026 17:00:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E6FE1F0089F;
	Tue, 10 Nov 2026 17:00:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794330016;
	bh=e9tGyPXz9xL70oEPM5OS0/SNYUGPcdfzb2vPyxxeOIc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=RJjGS4aJgoI4lZen2laaGmqFvmOokyg5KlyFv3ITPJzQK7nQoN1EH0vupyDu4eYdt
	 mcgYPzP/L5UVUL1qt9J5GkXH7Q/3OFYCYebwiXqvEp5tT9oU9WeOwh5SEdlrt8oxfg
	 WlQdNAQN5uJrxTdnbQjrhppykQ47HZ9CXAjKVIDX+aXA1M3OwXAJ0lQ8ecu4d1k7sm
	 zws+3hX3Vq1FRf7CykYhr7msoJeGYx3JKUKxRrfP9USK4VqnBibHsXvxY/dRhoFKoo
	 fNtKn8v0cneOg0aHwztoMu7E2uOUndOA4Vc0YhDLJh/7IS19X5XfwNRbT0Vzsm6JIN
	 vzqxWiif6yw/g==
Date: Tue, 10 Nov 2026 17:00:15 +0000
From: Yosry Ahmed <yosry@kernel.org>
To: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Nhat Pham <nphamcs@gmail.com>, Yosry Ahmed <yosry.ahmed@linux.dev>, 
	Johannes Weiner <hannes@cmpxchg.org>, Brian Geffon <bgeffon@google.com>, 
	Minchan Kim <minchan@kernel.org>, Richard Chang <richardycc@google.com>, 
	linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v2 10/11] zsmalloc: fold zs_obj_write() into zs_store()
Message-ID: <avNNjoQoBs7qIXd3@google.com>
References: <20261110054836.1515030-1-senozhatsky@chromium.org>
 <20261110054836.1515030-11-senozhatsky@chromium.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261110054836.1515030-11-senozhatsky@chromium.org>
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: xfcdidjttt31gz6kxngot9zcfgi1di8q
X-Rspamd-Queue-Id: B0FC8140005
X-Rspam-User: 
X-HE-Tag: 1794330017-696804
X-HE-Meta: U2FsdGVkX19b+u2gxRN9zQrI7flM/3ouot5htP0W4wi9GJAHshJXWUvul12h6l308rl+dGVc0Nn07vQijZxRC+l83p/jn7OS+rO0QJRxiZSMm1LXC/ffV/cGn+7NRmsT4v/c4/q3COvFzlkCr3VoUo2znymVPvMPFtKS1+qlsplo7WB5tnZcDkdYr5WjMyZdfkqDIHzzRs0htNgLdcSPPSF2jZ1Tfqyh5ukvX9Mkx6Ht5T/WKYrqtSbjzMmBEiHA+12ysnYweHxgb0CyfWhMzyasK8xGkS3E2q8HQ+mb2UWu/jBTC28pztx8x8eF8xKJ2hkkL8p5D+e7bBxwexJzeNtHq45ketmjS9ZCz6/vr6rez5032Z96NCpipqqBIZrXaOu3AougWc0f0OZoqPXQTIgg3mNVY3wvqDMCWNHZ5v7OUSvYCbd0bNSrrZof6pUt1eLorLZ4tJXnlMe+SIawK2DpBMW6O8/UlAn8uneHyiRxQRJhd7Z2rmjL8wk/fe9hZgcLMN30/OSWpeiLuvA9KQdBCO1zQAQESpIGOjf5+r0WGHTETX097I/INWp9n114if8aaAdfdWNJmFjL8UIHy3nPDvb0bkCjxpR6TaKPRKNsFnW9pZ38dDA9lPUpLl0F88zXFL4DgxoELsdAuZ1XdYNh/tCtH2wLNcfN29AewbpQGnM8vSqWsmpTxB5fCR59v8x76og6TKgQX4kcM9OxZ6uXa73UMod2qYf8GfOHkhKPyqlbfBxOqKOnO5XapV4yHPXHyQvUnScaKPXp+Ed1dILeZlvfA02x3Q2zRrp3NtCLMS0iilbx1Uc5YWPVBQ4nM73Zgm12naiET/jq+rxbmy8ec1OkjnUaa9d+/SJAC6oUKX8iY58iZSURQTKRQwoG091XQfRqGgTscqMKY7DKaZ6rg/dFR+sglnfpDgLIFIaUdPhIjGe0Gr2E+Xilhj9uUkhzxh9PCtOQr/8oH7s
 rIi/NPzx
 /ybGctuwO7esm2I6gdkEHEiL5cQgOSSw036uOKVD5ycSwTpIJt+t6HwCHkSnwZFcpU0GorjfMrwA+r5MaL2LHn7fu0m9ntVg2MParyAQOAeXzK+uw/a81nnvQDHvYzt3qOn+QVs+0/Y+frIiQSLek7xPQhc72vtm2sySEarA4TtI8yaDSA+Xl1RYmNpTEQy/miGixyAs0q+1gGWhiJ5KDaRcS+fEdO/XM7WG40Mkh8fn/VC6icu6r0YT/p5n6+8L5jMWzdSUALndotf0bN+SX5pOT7bBaRLaBXaI/EN3vLiMSyk/KPQc1Zka8QC5NJ6iRKLMWQpTBhgYKPbp5qpRR0uB9ng==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 10, 2026 at 02:48:15PM +0900, Sergey Senozhatsky wrote:
> zram and zswap always call zs_obj_write() right after zs_malloc(), and
> zs_obj_write() has to take pool->lock and look up object location
> again, which zs_malloc() just did.
> 
> Replace zs_malloc() and zs_obj_write() with one single zs_store()
> call.
> 
> zs_store() takes zspage read lock under class->lock, before it drops
> class->lock to copy the data, while zs_obj_write() used to take it
> under pool->lock.  Compaction and page migration already take zspage
> lock under class->lock, so this follows the existing pool->lock ->
> class->lock -> zspage->lock order.  We don't need pool->lock there,
> zs_store() doesn't look up the object via the handle, it already has
> the zspage from the allocation.
> 
> Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
> ---
>  Documentation/core-api/memory-allocation.rst |  2 +-
>  Documentation/mm/zsmalloc.rst                |  4 +-
>  drivers/block/zram/zram_drv.c                | 42 +++++---------
>  include/linux/zsmalloc.h                     |  6 +-
>  mm/zsmalloc.c                                | 58 +++++++++-----------
>  mm/zswap.c                                   |  5 +-
>  6 files changed, 47 insertions(+), 70 deletions(-)

zswap and zsmalloc bits LGTM:

Reviewed-by: Yosry Ahmed <yosry@kernel.org>

