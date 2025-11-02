Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4D228CCF9E3
	for <linux-mm@archiver.kernel.org>; Sun,  2 Nov 2025 06:51:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1228B8E0003; Sun,  2 Nov 2025 01:51:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0F8F98E0002; Sun,  2 Nov 2025 01:51:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 035458E0003; Sun,  2 Nov 2025 01:51:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E6E9C8E0002
	for <linux-mm@kvack.org>; Sun,  2 Nov 2025 01:51:36 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 83D354AB0B
	for <linux-mm@kvack.org>; Sun,  2 Nov 2025 06:51:36 +0000 (UTC)
X-FDA: 84064746192.05.9593FB8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id EBF7114000B
	for <linux-mm@kvack.org>; Sun,  2 Nov 2025 06:51:34 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Vco4K2eV;
	spf=pass (imf09.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762066295;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Kmsnrn6KpwkTEPHAtunolJMTlcE7tRcinjuxt+lQrE8=;
	b=aApvf8obfY+HNqNEaGSP/6ysKfdVMsRz0IEKcoukIRGHhIxwhgVlmDbLCUney8w3q2ATst
	luJCEAUPgpdE6197HRhB0LfGhdriQ6jcGYsCWhKHL4XHpi6Bl7wYUwnwYTqHxt7GVmca53
	PzEjWcKXvk0mUGGp/vX9f74R8shJCqk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762066295; a=rsa-sha256;
	cv=none;
	b=wBcRZLaxfTaDys8FzZW6KZ2jgRWnlnDggP35Cg4hpgCn5/UWP05c5teStcspacPuL3yhN4
	SnfKn/vSa5qyyhpeZQ7Eo0MXrEb70XhwvYbNqDtdhTCOY383T/Zf7enBNb/27fj5tvcH3n
	iR2tqx/2GuohnkInmfKRtSHz1PJJyEA=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Vco4K2eV;
	spf=pass (imf09.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A6DAA43733;
	Sun,  2 Nov 2025 06:51:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABC90C4CEF7;
	Sun,  2 Nov 2025 06:51:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762066293;
	bh=LiEsqySHdTNYoNAeeFwBBm/8FtkxDtaFLj1JlFEIwUY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Vco4K2eVYGfYGyg5YaHsmWN+3k6nNiSCNBYy6ngq88ATZov79V6nUDRzIi5gwzstW
	 Xe7q49t6AGV0dD46I6vdQAJAcYLbbMv3RM6KVHqgIHtILpg4//ZwtHtO2eM64ocX/u
	 waAtNhTJ6/rZKk9j1bXufCWyDqAlo2vSH5JRjOVPC5m5FhVh3YZ2CCeUyKe6CR2WPC
	 H6pViBJAdyPUW24cVSC2qToLalSQRX9J6o0/2Dex+E9Bw3upHJxQzt0exEnHFECSUN
	 oWp8B654jSXWaDNW7NlNhsKGOuTWNqowQUgT3P23de8tG70lFk+sAVQcQlkvs8q8xl
	 udORXqwFbHOkw==
Date: Sun, 2 Nov 2025 08:51:24 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: akpm@linux-foundation.org, brauner@kernel.org, corbet@lwn.net,
	graf@amazon.com, jgg@ziepe.ca, linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org,
	masahiroy@kernel.org, ojeda@kernel.org, pratyush@kernel.org,
	rdunlap@infradead.org, tj@kernel.org, yanjun.zhu@linux.dev
Subject: Re: [PATCH v9 4/9] memblock: Unpreserve memory in case of error
Message-ID: <aQb_bJ2et5rO0k5q@kernel.org>
References: <20251101142325.1326536-1-pasha.tatashin@soleen.com>
 <20251101142325.1326536-5-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251101142325.1326536-5-pasha.tatashin@soleen.com>
X-Rspamd-Server: rspam05
X-Stat-Signature: 3zmnpfqy8kajp7m1dj1axh8dnst3isga
X-Rspam-User: 
X-Rspamd-Queue-Id: EBF7114000B
X-HE-Tag: 1762066294-241883
X-HE-Meta: U2FsdGVkX1/VCdFrP56ROepkyJpuiK2AMjZBmAgcGAP3hx7TDaMYWVvtWoVEqN7SQ0vsH750ARXvABNEOHcUlexsQMyj0LPtDqcOk5Bj3N7yzQ6Jb/vtI7X+x9jgHL8wrivl4tNi+dAnCIc0S2cCty5pLaheaM4NIaPG4/6FEbPOdKLlt+9Tsyrm1LRo2yq9WkuJr42hY1TrnyiicGG/aQd8LXkHfkw1DKBvB2o7Z+VVYaP2PFLxV+9/KKH+nIluICKFNhTF7PMPrXplWPv7o+TetUl6fkMDDL8oFy7Rw9sj6Df9d1co0/WlS0FvAjFkyZP9ZcNOuOGOqBB8KrnZch/vH01/CNeZ5QXmNWa6LzPEuag327ll/WdTgmU6on0IawkglkuBOdAcjtSU//mhbRRMJyV7HXuqfYpEgxfMI0nADP5d1sIrWEGreno7n2Wee6fxJpM62C7ZbQhyB56YYHymn98Fx9D0w+ebfbB6bi5i5hFVC+rtae9sSsSPuyvmmn6pQOG3KjsQmyJ+jTFJ3P/xLwg6lwmuL/EH0aTRXad2k7VbS51OfcwmgkmcGODuAAaoXmfj5AVddt96urMNZck0/dgegfVWhQnH+b9diOYMEKTpgtbd8Jr0rsdxw8hzK3lqAv7gcp7ATDIxYm4/kZ7rK2a/wwmVQavnykdDmIUOJF1Rcb5OsoYH8lG9uzJQfr7CfCakmEDC7gC+pOjnB4ZJR++vmJ+dUYG4jgkpALWgnkC96Ar39WMGCoa3/me6CDWUGyX6sFL7pxBSnmGfNHXVF6BUCy5bwZmDLjeLQtgsuBGYzfBiPQ3I2gwgteyCeqRit3+tb5t8r/L3kzmoI9yvxl/+ffinOCcaBBNxj2QLsl2UruUleDH9qfnMplwjZJSyqWSI28zNL6gvFTqTyQSjxyEW8jDPUTlsmy5+7o/59/1LwDun2A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Nov 01, 2025 at 10:23:20AM -0400, Pasha Tatashin wrote:
> If there is an error half way through KHO memory preservation, we should
> rollback and unpreserve everything that is partially preserved.
> 
> Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> Suggested-by: Pratyush Yadav <pratyush@kernel.org>

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

with a small nit below.

> ---
>  mm/memblock.c | 73 ++++++++++++++++++++++++++++++++++++++++-----------
>  1 file changed, 58 insertions(+), 15 deletions(-)
> 
> diff --git a/mm/memblock.c b/mm/memblock.c
> index e3bef9b35d63..f527ad1ca682 100644
> --- a/mm/memblock.c
> +++ b/mm/memblock.c
> @@ -2445,29 +2445,60 @@ int reserve_mem_release_by_name(const char *name)

...

>  static int __init prepare_kho_fdt(void)
>  {
> -	int err = 0, i;
>  	struct page *fdt_page;
>  	void *fdt;
> +	int err;
>  
>  	fdt_page = alloc_page(GFP_KERNEL);
> -	if (!fdt_page)
> -		return -ENOMEM;
> +	if (!fdt_page) {
> +		err = -ENOMEM;
> +		goto err_no_fdt_page;

Please rename the label to describe what the goto does, say, err_report.
I believe it can be a fixup on top after Andrew merges these.

...

> +err_remove_subtree:
> +	kho_remove_subtree(fdt);
> +err_unpreserve_fdt:
> +	kho_unpreserve_pages(fdt_page, 1);
> +err_free_fdt:
> +	put_page(fdt_page);
> +err_no_fdt_page:
> +	pr_err("failed to prepare memblock FDT for KHO: %d\n", err);
>  
>  	return err;
>  }
> -- 
> 2.51.1.930.gacf6e81ea2-goog
> 

-- 
Sincerely yours,
Mike.

