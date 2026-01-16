Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CFCCDD4898C
	for <linux-mm@archiver.kernel.org>; Fri, 16 Jan 2026 11:57:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AFA476B008A; Fri, 16 Jan 2026 06:57:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AA8496B008C; Fri, 16 Jan 2026 06:57:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9AA5C6B0092; Fri, 16 Jan 2026 06:57:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 886936B008A
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 06:57:20 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2AC188C22C
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 11:57:20 +0000 (UTC)
X-FDA: 84337676640.30.70EA15F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id BA09E100003
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 11:57:18 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hOcOOVnb;
	spf=pass (imf14.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768564638;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZlOIbNUCEgilbaY1KGaFBHB7qA7SGL79lCxCJaeM+TE=;
	b=BlbBwdPBNYwXgARX9pBmQYVQijnynNNyIYLCo5RmdcD1LGqS4rBUY90C8xQbV7tNGo9NiO
	6yCWlsbhhj9E3r8VrzPmtcEKbKhHGxipHo5MYdkmUEF1u0XgDh1ICc7qbCE8a4ld8sEkKh
	y8+FV3a5JeQy38JX4UvE0Z+LNfYFOMg=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hOcOOVnb;
	spf=pass (imf14.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768564638; a=rsa-sha256;
	cv=none;
	b=qZSTAajYusJYJiCWnmclwzU3YbtHk+Xw++gtymi6zRvG6DT3Ywv0sxRzeBrtwl7QpgdpaR
	K74tsJgyzBnvZicqOWkWlhC/4etLEwtA+CEWsQhsjWIrOdhXgKYgbayNeEKgufjxQ1X4Dt
	naEP7zSuFhnRK4diW1KQG2W51Ut3brI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 0F32D601B2;
	Fri, 16 Jan 2026 11:57:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1146CC19423;
	Fri, 16 Jan 2026 11:57:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768564637;
	bh=6SDIwhdUvWr8ewpLO9jVWgrS1866uQekJSM327jVKA0=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=hOcOOVnbFJZHY+6yr3s6ggGs2USLu/6pg8AM9s1qhAq8dxpyxu2RQCfeWUItuRHIs
	 jt7/yWca2D2fWNieB8Kz8ZrRGE81TvhXbv/ebxDCRHIg373WcldjDR0aRTFwWdWNlq
	 m25R3zKYRoJ0peAIUvrkdciinHFKOZZpNMTlZEX7wqoZ5/pvj6WJmzYZ4sfi6OqWDQ
	 qLbm64nXLy2tfNhp0vIsCU/8ohNsEQyRdoTySUPjkHTSjyqZOSQYfpacLSWzSwNuC6
	 UsyefUb9VlmycNTcU1Wp3Sg5JOw+Yijv7QuVGPmlu010D5zSy/SaA/Z2M0duqyAzBv
	 PBdlJSELC0Frw==
From: Pratyush Yadav <pratyush@kernel.org>
To: Evangelos Petrongonas <epetron@amazon.de>
Cc: Mike Rapoport <rppt@kernel.org>,  Pasha Tatashin
 <pasha.tatashin@soleen.com>,  Pratyush Yadav <pratyush@kernel.org>,
  "Alexander Graf" <graf@amazon.com>,  Jason Miu <jasonmiu@google.com>,
  <linux-kernel@vger.kernel.org>,  <kexec@lists.infradead.org>,
  <linux-mm@kvack.org>,  <nh-open-source@amazon.com>
Subject: Re: [PATCH] kho: skip memoryless NUMA nodes when reserving scratch
 areas
In-Reply-To: <20260116112640.64900-1-epetron@amazon.de> (Evangelos
	Petrongonas's message of "Fri, 16 Jan 2026 11:26:35 +0000")
References: <20260116112640.64900-1-epetron@amazon.de>
Date: Fri, 16 Jan 2026 11:57:14 +0000
Message-ID: <2vxzsec57oth.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Stat-Signature: oafay8p1m45ook39cjh3sgqghs8suzxp
X-Rspamd-Queue-Id: BA09E100003
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1768564638-26511
X-HE-Meta: U2FsdGVkX1+tkrpp77GYAHquN8zExmS+4XHJs5l6JtwE2v+W92N0IIf/+PuLkP2Rg7KIgbCK77PGBYb8Lva88sZIzVbg3c8vOGhi5R+0HhsNTwxgaVJernGsViQdliRRzeO3yUhzzqHEXFIEvq8BhdCJShR/Ushl6vCeXZod+6qo0Z3iSkgWKhVMUgMuWUTlu5r3uZHR1l86EFEROXS4TMLbQMi0vjQdD1N6/MOQdkYoKG8pwI4fIzkp03CCZsRv+oI/9Ydz2ENkQMAIFOOiAHAdB4eDY59jAkQvDNZ/ka9ADTiJKo6SjxZdB23OpzPwsCLud5R2SYo8f2O4UTmPUjD5660RHDekBng5lgY2CvanDVxHFsvPn7aGR43OfbKhlpx7Amfhg1iZsGU5LshAFioHv0MvFsYMwwBVbTvJlCarpycLrgCRACKhWNSTLaaovbrzjfQULJFwXyML6pPJWMA34LW1aQ1NKhcpQUwcLA3GiX1zzV2z6LlC8oRFUc5jq5OMtbOmQX3HDUvuE6vVgdT0RnZAh/jBsjeqZK5OajdmwwbeoW6GkUEpfOn1abW2DQo/Y/82zuSTUq7xkt2T04/mmRjrXZX5rqRh6HP374pe1pyRn8ffYIS7HJCe5hNN/yaj3+9GWpyK62k75+tzV8+/VLzPI9Lnr4EcGrf9taihjR8DmH0drDcd4AmPU6DpzVOxlRpFggKjhVvxeY3Ae2bi/SlyGSxq4BGkafNYzQ7Uy/x4HULeXY8Okiv0KPevqOkaDmT1OxC7s2Vp0Y/lR8mENsTz3fvn7XImoZFcvKlajs5ISgS5+PJuTv6zlFQOGHA4Zac5DdV2AWl/f8732+QVuu+wvMHOnhxqnZtZMruZjySxiRe3+/UJhS8YOQB4gwFuhyihAG8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Evangelos,

On Fri, Jan 16 2026, Evangelos Petrongonas wrote:

> kho_reserve_scratch() iterates over all online NUMA nodes to allocate
> per-node scratch memory. On systems with memoryless NUMA nodes (nodes
> that have CPUs but no memory), memblock_alloc_range_nid() fails because
> there is no memory available on that node. This causes KHO initialization
> to fail and kho_enable to be set to false.
>
> Some ARM64 systems have NUMA topologies where certain nodes contain only
> CPUs without any associated memory. These configurations are valid and
> should not prevent KHO from functioning.
>
> Fix this by introducing kho_mem_nodes_count() which counts only nodes
> that have memory (N_MEMORY state), and skip memoryless nodes in the
> per-node scratch allocation loop.
>
> Signed-off-by: Evangelos Petrongonas <epetron@amazon.de>
> ---
>  kernel/liveupdate/kexec_handover.c | 23 ++++++++++++++++++++++-
>  1 file changed, 22 insertions(+), 1 deletion(-)
>
> diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
> index 9dc51fab604f..c970ed08b477 100644
> --- a/kernel/liveupdate/kexec_handover.c
> +++ b/kernel/liveupdate/kexec_handover.c
> @@ -623,6 +623,23 @@ static phys_addr_t __init scratch_size_node(int nid)
>  	return round_up(size, CMA_MIN_ALIGNMENT_BYTES);
>  }
>  
> +/*
> + * Count online NUMA nodes that have memory. Memoryless nodes cannot have
> + * scratch memory and should be excluded.
> + */
> +static unsigned int __init kho_mem_nodes_count(void)
> +{
> +	unsigned int cnt = 0;
> +	int nid;
> +
> +	for_each_online_node(nid) {
> +		if (node_state(nid, N_MEMORY))
> +			cnt++;
> +	}
> +
> +	return cnt;
> +}
> +

You don't need this. You can use nodes_weight(nodes_state[N_MEMORY])
directly. Other than this, LGTM.

>  /**
>   * kho_reserve_scratch - Reserve a contiguous chunk of memory for kexec
>   *
> @@ -643,7 +660,7 @@ static void __init kho_reserve_scratch(void)
>  	scratch_size_update();
>  
>  	/* FIXME: deal with node hot-plug/remove */
> -	kho_scratch_cnt = num_online_nodes() + 2;
> +	kho_scratch_cnt = kho_mem_nodes_count() + 2;
>  	size = kho_scratch_cnt * sizeof(*kho_scratch);
>  	kho_scratch = memblock_alloc(size, PAGE_SIZE);
>  	if (!kho_scratch)
> @@ -674,6 +691,10 @@ static void __init kho_reserve_scratch(void)
>  	i++;
>  
>  	for_each_online_node(nid) {
> +		/* Skip memoryless nodes - we cannot allocate scratch memory there */
> +		if (!node_state(nid, N_MEMORY))
> +			continue;
> +
>  		size = scratch_size_node(nid);
>  		addr = memblock_alloc_range_nid(size, CMA_MIN_ALIGNMENT_BYTES,
>  						0, MEMBLOCK_ALLOC_ACCESSIBLE,

-- 
Regards,
Pratyush Yadav

