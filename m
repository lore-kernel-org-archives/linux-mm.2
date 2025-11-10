Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 16E8ACCF9E3
	for <linux-mm@archiver.kernel.org>; Mon, 10 Nov 2025 18:34:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 519C28E0008; Mon, 10 Nov 2025 13:34:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4CAD68E0002; Mon, 10 Nov 2025 13:34:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 407F78E0008; Mon, 10 Nov 2025 13:34:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2D8ED8E0002
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 13:34:58 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C847C1A0198
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 18:34:57 +0000 (UTC)
X-FDA: 84095549034.17.8C74FFB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 44DF1A000C
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 18:34:56 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CihK0FPj;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762799696; a=rsa-sha256;
	cv=none;
	b=nTjVJqK9dgSy7WD0UV1PLDZvZFPYWOmXvbducMTKZFKSiJxD5Q7+8Bis+qnronl/Ch/N9W
	0NrOv4w0ZfrJJwYxLoLqg6ta8q8a5NmyPo6P+9eGXJ9QEKF+NNJcrhHSEX/rqzkhj3/UWG
	VQPD9w7CRs5FksimaIPyZUGE4fuv9o8=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CihK0FPj;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762799696;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Hifu5+XTv/PZagj/bNKiI2d8M6e9yZuwOXNQyt1l9bg=;
	b=17usgTAllJEuDt7W7NJO937tg7k+ZAlApPEeFloNSl0RYRqqBxVEqBiQGhPuzc+9vYH/uO
	3ByH7QCslh3vNoi0LrqszKmxy9R0Fo9hPDqpFrSRFxDwPbOnebWzUleIQIJWkAecHpq9bu
	MP9M33W+XdYBabUuOb8CaLIU5YVqgWs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id A282F6013F;
	Mon, 10 Nov 2025 18:34:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6488C116D0;
	Mon, 10 Nov 2025 18:34:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762799695;
	bh=FQjzy3ZKmgutMS5buIYRozIFCGNCd/pVylb5uaoZKQM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=CihK0FPjPD1VMDZ2iA5q9fLWUD+ajedl3qWXAK9vmc92x1+nvCH1jtiC04/W7BU1l
	 6ZRyz9Ve4iGH/jFMw08q3FJqmnZNhXFgpGkViU9Em2lvtFXqXf0lif6zzO9zpUEdvA
	 Tt6obIDeIlS7E8Ks32yfM3q4BaKp/e0PE2kArqXiTpEDM4laHWCyTq4MuH3AIq7FUd
	 pEtPkOFl57dB5ITtBYjz13stwHOhBr3cf7nRFw7w4VNaUQ3pBhPNoTqIEGV6kOWQHD
	 a81ehbRobuFJuPdZK1ZwuRCa4+w/6xZ4B1vPdsZrUWHBH/jde9mXFtcC3HEvy9zU0M
	 JwTPCO/DWYUlA==
Date: Mon, 10 Nov 2025 20:34:48 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: akpm@linux-foundation.org, graf@amazon.com, pratyush@kernel.org,
	linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
	linux-mm@kvack.org
Subject: Re: [PATCH] liveupdate: kho: Enable KHO by default
Message-ID: <aRIwSEF8Y0I6q8Cy@kernel.org>
References: <20251110180715.602807-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251110180715.602807-1-pasha.tatashin@soleen.com>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 44DF1A000C
X-Stat-Signature: a4ssd8cpk7ukm7dfgh46yh6f6is4ttor
X-HE-Tag: 1762799696-272048
X-HE-Meta: U2FsdGVkX1+ajLwHDupMnXmndK2g9f77PZPcd24nibhlafl3d3tFQixjLr1AA3QzkRR8FceQDdRA60gPoQHudpZ3jAiQRaStPQkYg17ssjgfAlmwjfpebmJAijO9b7oM1jep4OCZTBcPb0VnlwKm5vYMWhxyX5A/0wASsYWBMqShfZnmuUUHqK5p+E0vk6RKzM4tiwWV5/fFOSFveATQGGVaIK+kui3VO89eYhUQVloFob9eWjHwdZg5DUg90i3JBeyvVZUHTOp+hvNhRHjSCMEM5OalgxvjBwGTSLrq+acfKVLcYlbNJiwX+WtoDIvf+rXYnusXw8FwMbLKA+uwbfSFbG4SvKrStlBkuQPkWU2eOcHOozt2e18R5YYAj23iuGbAh73Uhm0gwYwHgi9MK/+wYXsMOhFRDLz+j9HEh6HnPiJmb43mfdN5hhH18UY4OJSkuDDLMhdYWBN5UWGIqxTMZMIhqKZeJMeQvBLoRLxVMH7oIsnLsJ9r90MoiNT4B+wetUuVXPF/P5tSFaNzWM0oYGiNmH4QNUh+G9/Wkl4yhKKI4OTTQco5/T737CRyyWy7WYtoKY4REG9qXzxkbI8tCxqGQgGs36y32JkLCjD6O5BW2RyUC84HrBDNhUFZLO5j14jkT+HPp7rvMgXMHbWpxwidRkDzbnVkb+Wtqvue5ytnTJQoBhcCGliGAoic9i36wBo7KgZKe3mvaae8tNfywQX/BTzReZGDXmruZJpDPGT1f68pRQSXO48BYUnRxRBvWJdWrH1JydvMclRFjNJ4JQ1MVcnJ/KLb23puvCnpGld/b4asKfqT4dpZFezmUoSXBHLs+VAY+4rZraf8URx+PHDTGItdoj55Q8V40ZkStecqiqS6hJo1rBcUEvqTbCSwyJjcGQ6FDxoNP++vYXXqTamqiowUEeliyrr7Obq1x9vZaCT03zTpO64jTxSNVH6BIQ94RU4N7JabMHO
 AyitG0iF
 0jmezJJB4mZBonx+GkPVxoCC0PWkLXJuv1xmLenL0XeQa3GyPHUZjVvJAs4isBisvrOjbXiIRMCnbElWxoedPzcKtrSJvHGbo2PDbEEGqqip/I1ridBnwLLPn1wb+nOcIIoS8t5mczbYXA7sHC3u793ODyvLfqMDdbgt1WalNCvvwv5I2IzPElGi1xtgdfsvbOWNi4dv5H2enLz4Q96r7rPCu/McpGRNZ6gsrS3jdv45cv/5Am7nMpy869CKVM3y8fnFcNVUE8V8uWNf4x1LOn84coiluJT+O40mbVaPAudZlpciCrefMHHV2LpMuxnyf2G4t/YtTrHC+nu3m4yOEPadYgQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Nov 10, 2025 at 01:07:15PM -0500, Pasha Tatashin wrote:
>
> Subject: [PATCH] liveupdate: kho: Enable KHO by default

No need to put a directory (liveupdate) prefix here. "kho: " is enough.

With that fixed

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> Upcoming LUO requires KHO for its operations, the requirement to place
> both KHO=on and liveupdate=on becomes redundant. Set KHO to be enabled
> by default.
> 
> Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> ---
>  kernel/liveupdate/kexec_handover.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
> index b54ca665e005..568cd9fe9aca 100644
> --- a/kernel/liveupdate/kexec_handover.c
> +++ b/kernel/liveupdate/kexec_handover.c
> @@ -51,7 +51,7 @@ union kho_page_info {
>  
>  static_assert(sizeof(union kho_page_info) == sizeof(((struct page *)0)->private));
>  
> -static bool kho_enable __ro_after_init;
> +static bool kho_enable __ro_after_init = true;
>  
>  bool kho_is_enabled(void)
>  {
> 
> base-commit: ab40c92c74c6b0c611c89516794502b3a3173966
> -- 
> 2.51.2.1041.gc1ab5b90ca-goog
> 

-- 
Sincerely yours,
Mike.

