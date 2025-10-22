Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2BB2ECCD1AB
	for <linux-mm@archiver.kernel.org>; Wed, 22 Oct 2025 10:22:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 75D478E000B; Wed, 22 Oct 2025 06:22:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 70DDC8E0002; Wed, 22 Oct 2025 06:22:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5FC718E000B; Wed, 22 Oct 2025 06:22:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4C6DA8E0002
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 06:22:44 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E51CC140785
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 10:22:43 +0000 (UTC)
X-FDA: 84025361406.27.D02D196
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 81A4B40005
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 10:22:42 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Q1Dr+lJ7;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761128562; a=rsa-sha256;
	cv=none;
	b=qq8PgTDYkeO0ravRYHwQ/IVdpuSdp+pEYgJIdIStUimbmi1KObp2UYFErGLG0o/IeLzaB9
	buB1jupgH9mShKiVFfZAzqiKP5LNEOqcWw/ZqAxfdS7df6hRaZl2vmiuDNGRERgzUS2/z2
	liodS1Fia+jlUHhiNlNdXkBFmrHg46M=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Q1Dr+lJ7;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761128562;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W9hqLfyExGvSye2P2NoK7JKeJBYJLYQiJf6K/UoBfbQ=;
	b=8MT7P+OG5l29wwNdpWjoYYN67+MAXG1318oOZQG6+LwKYE3Q6hEaGbI5pbc7ZIXsLgpQIN
	EO0OJ0uWdUR8hiXCqFPgZmJnJSd8OTpJjdNIYkf3J8/06TqSQMls1uyYB4bZnaaURAn49A
	t+FXk3/wrsr8kXKTuf9NXv1PNI6qLeY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id A9D006249A;
	Wed, 22 Oct 2025 10:22:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F379DC4CEF5;
	Wed, 22 Oct 2025 10:22:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761128561;
	bh=6AdCRUuNNCz6wSJ38vTty69zF0P+UjCkFsweE0IXYnA=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=Q1Dr+lJ7vBVYUS3XgbZreqF4ZRbVcHTpEQX9hPSuKZpvS7LwhYeZXf6vrTXLe1SMi
	 6Kx1vT6oK6UH/nrp39CW3QirffvrkhheptDffM61T9n8B4X0uARwv7BWBJ+s4F4d5+
	 8VZN6f7wvT27Q0kkHgg7OIhJjeRwe1dnaK+AM75YfMM/g32TZdxiJdHmpzGIIemtDt
	 Mj9oOzakKjuFWH8DopyDG/JcwmKyBHc1DNtSdJWG5yI/x3wW+Frll24pssh8xjV024
	 E9EiZAW/kYLpd4C7E1VPSK6gQqBhL7pNrn9xAQ3aFTHRhxJzaybPZFWRNRx9B7a4uU
	 TnrzvIsU8QuhA==
From: Pratyush Yadav <pratyush@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: akpm@linux-foundation.org,  brauner@kernel.org,  corbet@lwn.net,
  graf@amazon.com,  jgg@ziepe.ca,  linux-kernel@vger.kernel.org,
  linux-kselftest@vger.kernel.org,  linux-mm@kvack.org,
  masahiroy@kernel.org,  ojeda@kernel.org,  pratyush@kernel.org,
  rdunlap@infradead.org,  rppt@kernel.org,  tj@kernel.org,
  jasonmiu@google.com,  dmatlack@google.com,  skhawaja@google.com
Subject: Re: [PATCH v3 1/3] liveupdate: kho: warn and fail on metadata or
 preserved memory in scratch area
In-Reply-To: <20251021000852.2924827-2-pasha.tatashin@soleen.com> (Pasha
	Tatashin's message of "Mon, 20 Oct 2025 20:08:50 -0400")
References: <20251021000852.2924827-1-pasha.tatashin@soleen.com>
	<20251021000852.2924827-2-pasha.tatashin@soleen.com>
Date: Wed, 22 Oct 2025 12:22:37 +0200
Message-ID: <mafs0v7k7fd76.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Stat-Signature: 1yik7cqxwub5awk4eq3m5787wgu4k1ms
X-Rspamd-Queue-Id: 81A4B40005
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1761128562-425149
X-HE-Meta: U2FsdGVkX185L5YEJbKBZrRzZjEEldMSKQSH/bnT58Xy0psVOxNQFuMvBCopt74ovks6063lTeFTperkPQ6qoxT6PTBJXWyZWh+tNXL/R52rlO2IA126844gbHhXAzkJw8Ig5hI00IU7A+xh/h+M4g7v2GtM0BdYoz2s8Lq1U3lHy1BHzTRS8HGZvTGj2Cb/UOK3auXXhliIWnRNcVKFrHTf80J1rIBoYtpAN4qO67O/mrXHocmauWi318eByCiAT2wWY9wXeprckTJZSxh5Ppmpwu4XO35PIX9DyMQ7C3Vr/Irh16FDotrzzLnJ6gt3k1AeCiP+uUZFeQc5/KIG2krilx1Wk33taXxZ1XlSmrRFSJTjjDHk6NPDd7R8phWGo8y2mryYxVez2907DsXZabC+6ksi/BcuHf16lfE5a2kEdF+r+xYyafyQet/N0u2m6DSCY5G3ewiFSWakFjtaFRH2eMR8A6pDjLnSc3CyaCjBArOfEyEjy+tLtmXOl4NdAFxVi/QTaLhlCLr832MKhhFSaeDbEgaIx0MFGENuQpP+KUGdFHFG7L5gaPbdIj5lJuKocgx3bVsvHl5x5PjuJrgFrtGkQa9u7+Xp8+RdO1mhSL0/7S5Bby0FXViFoQwMqzI22iywIUgfLtgmlH9sWcgwuW9VG3141lnmctVqg00ywQzMN2PwyP7bvoxsuMEvP6BiQTAuGBEdWhp29aURkD5HDEdZI3P3ahn0wjsYTr6dsXPjQK5B09CsU8K+lu8GhwnxgS3pT5e/UCy8MY+olbvtD9kMqJDH8Gh+m1RUlwLyySL3QzCXvLhQqVLKNm13bR7bB8BNvUbsj9Ci6h1KUFYtoQ6E6GVeVjKfAY0kaEk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 20 2025, Pasha Tatashin wrote:

> It is invalid for KHO metadata or preserved memory regions to be located
> within the KHO scratch area, as this area is overwritten when the next
> kernel is loaded, and used early in boot by the next kernel. This can
> lead to memory corruption.
>
> Adds checks to kho_preserve_* and KHO's internal metadata allocators
> (xa_load_or_alloc, new_chunk) to verify that the physical address of the
> memory does not overlap with any defined scratch region. If an overlap
> is detected, the operation will fail and a WARN_ON is triggered. To
> avoid performance overhead in production kernels, these checks are
> enabled only when CONFIG_KEXEC_HANDOVER_DEBUG is selected.
>
> Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
[...]
> @@ -133,26 +135,26 @@ static struct kho_out kho_out = {
>  
>  static void *xa_load_or_alloc(struct xarray *xa, unsigned long index, size_t sz)
>  {
> -	void *elm, *res;
> +	void *res = xa_load(xa, index);
>  
> -	elm = xa_load(xa, index);
> -	if (elm)
> -		return elm;
> +	if (res)
> +		return res;
> +
> +	void *elm __free(kfree) = kzalloc(sz, GFP_KERNEL);
>  
> -	elm = kzalloc(sz, GFP_KERNEL);
>  	if (!elm)
>  		return ERR_PTR(-ENOMEM);
>  
> +	if (WARN_ON(kho_scratch_overlap(virt_to_phys(elm), sz)))
> +		return ERR_PTR(-EINVAL);
> +
>  	res = xa_cmpxchg(xa, index, NULL, elm, GFP_KERNEL);
>  	if (xa_is_err(res))
> -		res = ERR_PTR(xa_err(res));
> -
> -	if (res) {
> -		kfree(elm);
> +		return ERR_PTR(xa_err(res));
> +	else if (res)
>  		return res;
> -	}
>  
> -	return elm;
> +	return no_free_ptr(elm);

Super small nit: there exists return_ptr(p) which is a tiny bit neater
IMO but certainly not worth doing a new revision over. So,

Reviewed-by: Pratyush Yadav <pratyush@kernel.org>

[...]

-- 
Regards,
Pratyush Yadav

