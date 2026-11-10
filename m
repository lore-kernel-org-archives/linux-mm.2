Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0BD0C60A2623
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 16:36:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=i1SkZeEE
Received: by kanga.kvack.org (Postfix)
	id 2B80A6B00EF; Tue, 10 Nov 2026 11:36:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 240A46B05B0; Tue, 10 Nov 2026 11:36:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 130836B05B1; Tue, 10 Nov 2026 11:36:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E1FE76B00EF
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 11:36:02 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 344C4A805D
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 16:36:01 +0000 (UTC)
X-FDA: 85419761322.26.4931951
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 84AAA1A0007
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 16:35:59 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=i1SkZeEE;
	spf=pass (imf19.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794328559;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6B8q2oqRr8i13Z8GdT5dzIPKIxv4OsmoKM7uYVudI50=;
	b=0SUFZaYUe4zW9WGO3tqysEsmM/aarcMG2RevDq4OCbSU2WqttfxAI7DvVL7kY5zE7+SFoo
	jKFygx7bXFKKL6DtQcK6m5v2mwRmtSsUw3gpId3515QGn5FPZ8l+oGUw9jQJUwvoCku8EX
	tGSVOfXlyXWxysNPHdgtFORMyO4KCAA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794328559;
	b=b7bbiJFIfsO9oGv8us8tDmotboVAWeIfdEK558R0Uoy6iVusSl2iFEfN4Xhja2SBDnzuxv
	9/J7aXwkfsYZjrVqYhCk9uo/vy+LzqVg7BqpMEFON1/F3CGSjtWxTnlglVQ5oCGfhboz1K
	zlQh2H9rFFsT7Caqo3f9lp4rH+wm0Fs=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=i1SkZeEE;
	spf=pass (imf19.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id BEA2040E0B;
	Tue, 10 Nov 2026 16:35:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 387081F0089F;
	Tue, 10 Nov 2026 16:35:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794328558;
	bh=6B8q2oqRr8i13Z8GdT5dzIPKIxv4OsmoKM7uYVudI50=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=i1SkZeEE/TPAW5CajYVIcy1XUV71QNqZ/NtonNl/JIuGfqXNpd5ZkIpdShFMEMPCx
	 DiMXSUPKxkADORb0WktAtloGnZRbhr+Jev/m0tgRTdTNJ7PdUOwuEP0t3ljK/Qaa2q
	 fo9yav1hYqrRUI6iF6tvMsAcfp1GrsGx0eFuO3WP7FrPWSik4KGbI8artMgSLDspQX
	 mPVcEra8EiNHoueCe6T77cKuNXFZpww1Ypfd1KKFzRbHBpannY520Unq/gAYwfYZnX
	 ++YkJ8Dz0kwAL46lQ4cRe+mlFkudAZ22c+90UEV0FGE+NQNPavpAy229+cAJCJ9tBk
	 iFWkTl3boMCXg==
Date: Tue, 10 Nov 2026 16:35:56 +0000
From: Yosry Ahmed <yosry@kernel.org>
To: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Nhat Pham <nphamcs@gmail.com>, Yosry Ahmed <yosry.ahmed@linux.dev>, 
	Johannes Weiner <hannes@cmpxchg.org>, Brian Geffon <bgeffon@google.com>, 
	Minchan Kim <minchan@kernel.org>, Richard Chang <richardycc@google.com>, 
	linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v2 04/11] zsmalloc: switch handle type to struct zs_handle
Message-ID: <avNHoaIU-RV8_fEG@google.com>
References: <20261110054836.1515030-1-senozhatsky@chromium.org>
 <20261110054836.1515030-5-senozhatsky@chromium.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261110054836.1515030-5-senozhatsky@chromium.org>
X-Rspamd-Server: rspam06
X-Stat-Signature: 4dtbuzxm463e4rk5d5yrhdbbz59i9p5u
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 84AAA1A0007
X-Rspam-User: 
X-HE-Tag: 1794328559-909623
X-HE-Meta: U2FsdGVkX18vaHAjslbVUNf5/Kc58YZlZvDuSB0XWftRG+1Pk9L9XGKY55iqTnWBvWar4J8r03uZLhshkN7CUIVlcKM/jX6XeT4+pZeoPVm6wWeAkTHvZMVqc3E7UQKiumynN0t+ZJ/F6Sx+uTo/n2dcfzmpqlMkFRkhQs5vGnVKxy4J2oxxRfC4hMGVKws8MsFNfKjmISxyKFHABmLiyRu/ImACyjhFhTucPkDdXxaGTynH0jkz+f6BVe7OlnmWw5MWDHOVVeITLQ3DF0d9F2MtOhl6Nm1LcESiejYrW5FyKghJXWP5qSYxs59gSDD27UzflI7uoV40e3/uTmlfU/VNeyG9BSvMyQVw1Wpv5mbOywwLevdcLc1fbUeBH0+HEnKDxdIMtUURsY2K1+w3vqVcaZ9d/iZd5nGdciNEGiBphh6LCpV0EPKqEhri4OStnLwW4x0oJLZ8GcuhTObwJCTJnuB7OVVxL0WXGc3+88/TA9y5t+4Ou6UHe9kP1i/2JVQxv0om+NEZuLJYgUECkqGHFhAzfLWBaFNS0/CX/kp9b+LTu9jiz1Bpa2H/dRpGKfEiVvU+NSNMbR7iV/Bez7S/o3C5HauvOncEZd2W8RL5RINZ++wCJqbDg51ToN44LT5lWEw/23aomvoXRlrXIgRuU01e/CeVqjzjMYNc4CFgovsVWu9CdZze1c3G8TQVmZ50IRdOv3obCCyLP6t/jwMT4pvftRkmxFI48fnigVcPAAUSjGOM44QRW8ZZ0Neav410Qe0i5m8cHAgxUEkmDJOKH3/QYccZ2moaz60rhUUJkfmzacDMsu8PZvvG11XM8/2TKqZZfxs7fNmr4hf3NKbvVgqvc2tB3mqHrNN2zt9I309QaG0YWkjGfGpabqwZG5RFcomGxhgRqdfyHfztrCwVg5pbdYQHuBAPHt7R7KWAXjdCfRzVfxHmfvUG1vusWnyNOnt6ROJ3v/K86f2
 o1teUUTm
 g2Ug93C1t1rtdith6oOxJv6MC1ER+3Isw6xkfzCR+QFqaFWehLkRya34KdSIsHAlWEfJ41LXZDRi4IlycXdP9xui140slK2uWS57/LPzzz9gjOqSu75LrsSqLXuikF6r3HHd25hmmHV/XYm+/NojRMfHGDpCtfkMOQuc3U1cgm5Bv7KCAa43LRrxVGkWnS2fN4D9L0gK/UuAa4PoH+iA+TLPJpGv0G5kSCwDBCMNsR5a0UFY6h+vB1L57Fv1ZtZr1bBoiPUkOKtSahESHMi/f4PIY3HhVQSeBEPi+PdmlbfbZRZeAwOHcTXa6rQI7OIZCRylbQBHAJQrjJ3FAUB41t5TvIw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 10, 2026 at 02:48:09PM +0900, Sergey Senozhatsky wrote:
> zsmalloc handle is an unsigned long that holds an address of a
> handle_cachep object, so zsmalloc and its users have to cast it
> back and forth.  Introduce struct zs_handle and switch zsmalloc,
> zram and zswap to struct zs_handle pointers.  Functions that only
> read the handle take a const pointer.
> 
> This is a preparation for embedding struct zs_handle into zram and
> zswap entries.  No functional change.
> 
> Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
> ---
>  drivers/block/zram/zram_drv.c | 28 ++++++------
>  drivers/block/zram/zram_drv.h |  2 +-
>  include/linux/zsmalloc.h      | 13 +++---
>  mm/zsmalloc.c                 | 85 +++++++++++++++++++----------------
>  mm/zswap.c                    |  8 ++--


zsmalloc and zswap changes LGTM with a small nit below:

Reviewed-by: Yosry Ahmed <yosry@kernel.org>

[..]
> diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
> index dab71f582103..3a6a7253fd01 100644
> --- a/mm/zsmalloc.c
> +++ b/mm/zsmalloc.c
> @@ -264,6 +264,10 @@ struct link_free {
>  	};
>  };
>  
> +struct zs_handle {
> +	unsigned long __private obj;
> +};

nit: Update the definition of ZS_HANDLE_SIZE to sizeof(zs_handle)?

