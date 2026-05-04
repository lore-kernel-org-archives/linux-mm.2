Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6BFE3CD3430
	for <linux-mm@archiver.kernel.org>; Mon,  4 May 2026 13:46:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D3D0D6B0092; Mon,  4 May 2026 09:46:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CED446B0093; Mon,  4 May 2026 09:46:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C2A846B0095; Mon,  4 May 2026 09:46:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B385B6B0092
	for <linux-mm@kvack.org>; Mon,  4 May 2026 09:46:09 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6140640199
	for <linux-mm@kvack.org>; Mon,  4 May 2026 13:46:09 +0000 (UTC)
X-FDA: 84729861258.01.BE36E1C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 9793840011
	for <linux-mm@kvack.org>; Mon,  4 May 2026 13:46:07 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UonJb0B1;
	spf=pass (imf27.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777902367;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dyA/RJ4WV0ENXukLLJpS9okzJTBD0evXoIqu3rh0Shc=;
	b=KC5xVieeKV/l4kiWQZRwTtdosQG02OoSEg9edMQ11uGxQCYVainSC6Efaqj2bOtwco0Q6G
	mz9FrCTy2cSW/Pl1M/WOU+mgRYDzlDdgaIqTki8KLkQVy2T6zjXdqVMTDNlX6OoxwKl524
	jc9o3wwhcxNuui9wYPkrA18oJ5TVEjM=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UonJb0B1;
	spf=pass (imf27.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777902367; a=rsa-sha256;
	cv=none;
	b=XIPDP8UFotTLHDEXJrnUG+wCAPqV1KSo6Ayk0hUCNfOk2m5LeiUKaSJTvZkasWaZiQjhxu
	KQaww3jFkg3QOV40TxjOdWA6qViDPLNZIw6tXTl+fTCyvw4/SgKUqIvQ53v1b+NhOdAZ0Y
	qYYI1jrOTQ3v6CQ/BCMdGFuwd2EZX9c=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id EFF4960018;
	Mon,  4 May 2026 13:46:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F696C2BCB8;
	Mon,  4 May 2026 13:46:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777902366;
	bh=A2Kpz/bYRNMo3xwXI5Xybf+gUVzqTmb83C93LElGNyo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=UonJb0B1TRkrcXg6tizQ7VvGa/iQ5fa0HgkmFBizZEuYlV7Si6ldbqQSSPxuwVLgh
	 aXrT1fK9D1jC5Hui30t2I3Plnic1NIFcqpoHhRZcgZiNyeKoHD7doe0YOssaac/PZD
	 zXKd3gadcV3bhiCGXofh5LL8+tu+LqKZkhS2WTxwR+eAw6ySY8hJ2DKOs6Gni++9I7
	 Vb2SoKqV+Bwrp/2zPw9HQI/pI0pGrTXQEO6KaYov/0S8UvZMddi8fXQwp0RDkSFPC5
	 WhoKiQMSJ3rZGGbDiffZWQYC9u+YzUBEiRNT8TsKdias98u5QvSUhImK7PRydL6Fc4
	 5OoSxDmoiCVNg==
Date: Mon, 4 May 2026 15:46:01 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>,
	Michal Clapinski <mclapinski@google.com>, kexec@lists.infradead.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] memblock tests: define MIGRATE_CMA
Message-ID: <afijGcl4xgpPwqAI@kernel.org>
References: <20260504102742.3833159-1-pratyush@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260504102742.3833159-1-pratyush@kernel.org>
X-Stat-Signature: c3eimk9dz9em9mcfeagt8rwhqky6zxsq
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 9793840011
X-Rspam-User: 
X-HE-Tag: 1777902367-152532
X-HE-Meta: U2FsdGVkX19tn2mALpQj1xxF61J3z83hv4G3+T1eZsjn2MXKsDP5dTJlJ4o21LS0zfPawrbrezZzanfpUlqaZ30vueXJ6XcMgELYmSK59sGOD/sAgb0ONnQQsM6+JeZJuxZQTrRpkJVON3INwb25xkNcHPYsw0BI9tfvSpzZGSHei9O4Z4AN2hsqhFKym5oFaI0dRksQCoMnPUucJITh8LUFIFmo8MEMZ3qJN/yWYiJWEJmYPErZceT2CXR6kTaYruwJXJ6JQY5Zr1gtDW0TssWSodbifoNsKxOgz77rOQplKR0ESURWxi953WwLn+7ZJHyFRtNJDNNnhgt87Q0nnhh6LeuMM83u2Z5QFBLugJxRj6kjznmhEgrO2xXot2H8wGYxj9eSiHsTACgcMHqwwWwv+0h6lS6lSWppWapg5iop7e+DmpT/xm1EXKKjwua9/c4Px3DgFQvhtCp7N0DqnL7B1JuqeT10DjFNHPTA4PZQQO1ewrGWIBVpSIeGWZ0n4W2xdwDD2eJSG2vUTXPWc/i7MR6PK714dXfYXaI1bNLxYVum4CFVybVX1c4S8jPv3uLSoGHegruJZrdPVcDIlb2FfpX4yiEBjMsZwHBVX4B5Suga+F5sBwD8y78//5/R0zwjSHRPeO7u8/kVCV/4RTp0owO6OSq24L/cZy5exHLy3oXksa+uR0JRBukuP6UNyRNcmrdZXHdHbP87GdvjgClmM9v1RZ7gEUotHxa4dGr4LnCW2YKqMgYkNBVv//40XMHrwteWUW5dfBQLvO/HfoiwX4qDEqlmRRv8LLXBbWoIey+IORCouMf7tZu6Kp9UnVKxLfN45X2m7aIyH049vp0SneEVGGcds/RthwuWv4pcorb0k4oxJCi0VbLKejExXITrcOlWg4dW5WOtkBPOg45kr1WHLwpZvlq9qcNydxkwBkTwjBYGrbcEzQNvLo69L8U9f9sMlPkugiD6/4x
 DJDn/YOV
 42YY4OVH+ucIWumIZJAHoE9tBHTA6y3mo8zIWUinn+FeSZfoFDVeBXi/kjcyKYRvLM0oWOO+ozbH+bK2UCKQczasRT0abbNUgHv+QR6GQ7rQQGgp07GXbspNmisqkP2XS0Um6MITIq4Zi58v5kOAqvjalGeb8bmelZIbbiEfY6K8MXCoIT8gmFNePmOgTY84yv7hIWcMYbWaSRFnH/+R1TDIHCaDr9xgVOXzeb3gmFgEO378038MTzNBDNMvOaME7iaJKpGXpJk1kO4of0mJz+thn+3lIfLW95Sh8FuYhEtRDm7EUv4q5V9QNJ4ix2KweJyja9RJGGZKjigultRcQQJozfw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 04, 2026 at 12:27:40PM +0200, Pratyush Yadav wrote:
> From: "Pratyush Yadav (Google)" <pratyush@kernel.org>
> 
> kho_scratch_migratetype(), defined in include/linux/memblock.h uses enum
> migratetype. This breaks build for memblock tests with:
> 
> ./linux/memblock.h:634:73: error: parameter 2 (‘mt’) has incomplete type
>   634 |                                                        enum migratetype mt)
> 
> Fix it by defining enum migratetype and MIGRATE_CMA. As is the case with
> the other headers in tools/testing/memblock, do not bring in the whole 
> thing, only what is needed.
> 
> Reported-by: Mike Rapoport <rppt@kernel.org>
> Closes: https://lore.kernel.org/linux-mm/afcdDm4aAJvNaQqH@kernel.org/
> Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
> ---
> 
> Notes:
>     I didn't add a Fixes here since the commit hash for the deferred series
>     isn't stable yet. Anyway, I think we should fold this into "kho: fix
>     deferred initialization of scratch areas". So random bisects don't land
>     on a broken test.

I applied it to next as a separate patch for now.
 
>  tools/testing/memblock/linux/mmzone.h | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/tools/testing/memblock/linux/mmzone.h b/tools/testing/memblock/linux/mmzone.h
> index bb682659a12d..8d934ff5b080 100644
> --- a/tools/testing/memblock/linux/mmzone.h
> +++ b/tools/testing/memblock/linux/mmzone.h
> @@ -35,4 +35,8 @@ typedef struct pglist_data {
>  
>  } pg_data_t;
>  
> +enum migratetype {
> +	MIGRATE_CMA,
> +};
> +
>  #endif
> 
> base-commit: 74d1099bb4edfca3ce6edc61dbacbed96720034c
> -- 
> 2.54.0.545.g6539524ca2-goog
> 

-- 
Sincerely yours,
Mike.

