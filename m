Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1A0D9CA5FAC
	for <linux-mm@archiver.kernel.org>; Wed, 30 Sep 2026 13:29:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1FF7F6B008A; Wed, 30 Sep 2026 09:29:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1AFB66B008C; Wed, 30 Sep 2026 09:29:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0ED176B0092; Wed, 30 Sep 2026 09:29:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E1A3D6B008A
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 09:29:39 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 74903A6A27
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 13:29:39 +0000 (UTC)
X-FDA: 85270510878.13.86C022D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id DA6E8140009
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 13:29:37 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FRfgvWHU;
	spf=pass (imf26.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790774977;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Xe3Gyu68rkXUkmZtfF62UzY8eYhNR3uRfFJyFqhsFcc=;
	b=lE+7QJHlFAd7VC0ytlX+AY+n67HUneJxRmQZ74EIbqNQoymYZuyel9mb75TE36E77Mx8hj
	/IhAyphIKC83EfQt1goavJR5jJ/WX93GdnCJ1GJvvAnYYQ3alzr1YN4Bx2yVF8pcZc+ycz
	xOuyk+9iF/xMTaNHQ5ZcsdPtIHphpu0=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FRfgvWHU;
	spf=pass (imf26.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790774977;
	b=Dsa1clnPbTKtvnt/DkgGqQwHj/dlFOpeBBeV20WX/vTW2PgGg5vRePEyOMq7b5opnX6Y8m
	iQibNbnhAgG8QiV7S0vk7s3m2C8C8W6GXc7M3ZSJPPfq9M9ndoq4J6WheyLJiP5YMaTbNj
	N2NA8L0pNmim6I3Ku+keSfS1K4TZFYM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D35EC43D02;
	Wed, 30 Sep 2026 13:29:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B447D1F000FF;
	Wed, 30 Sep 2026 13:29:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790774976;
	bh=Xe3Gyu68rkXUkmZtfF62UzY8eYhNR3uRfFJyFqhsFcc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=FRfgvWHU+AKPzmofszJG2IUPjz23YPt9ioIt4OSSsMpVxnIXAhgXYxcucEhzyLVQh
	 byk/wcgacA7vIk+a6K90cAsKNfjToZHpChI5iJM91+VNPtkcv8u66vFbEaF83QfPR8
	 NLn84mYqHNjwZBaSR1W2ybGHwymC728LhgY6+GO0Ds4PPGrPdNPTRozvFnfp84L+1j
	 sw6GDlUCJXmZgrHOtFnYvt9+xOQG3FYlMbMUm1avl2rKpOAOY9oquJ8Sov25sAIUAP
	 ELXsyty/QbPgnD4PHHHMIoqy0jB6DJFQrNa0ALGMXKlwPmSJu2fW04WuMcGhJEuhyP
	 i8zWCsMdxFA9A==
Date: Wed, 30 Sep 2026 14:29:29 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Alice Ryhl <aliceryhl@google.com>, 
	"Liam R . Howlett" <liam@infradead.org>, linux-mm@kvack.org, rust-for-linux@vger.kernel.org, 
	Boqun Feng <boqun@kernel.org>, Gary Guo <gary@garyguo.net>, 
	=?utf-8?B?QmrDtnJu?= Roy Baron <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>, 
	Andreas Hindborg <a.hindborg@kernel.org>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, Daniel Almeida <daniel.almeida@collabora.com>, 
	Tamir Duberstein <tamird@kernel.org>, Alexandre Courbot <acourbot@nvidia.com>, 
	Onur =?utf-8?B?w5Z6a2Fu?= <work@onurozkan.dev>, stable@vger.kernel.org
Subject: Re: [PATCH] rust: bindings: fix VM_MAYSHARE blocklist entry
Message-ID: <ar0OoDPMy3CetLMa@gremlin>
References: <20260930123645.302318-1-ojeda@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260930123645.302318-1-ojeda@kernel.org>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: DA6E8140009
X-Rspam-User: 
X-Stat-Signature: qx8qdireodnfo57qodwdyxrbhrqtdbe7
X-HE-Tag: 1790774977-42468
X-HE-Meta: U2FsdGVkX19o4F9178mMBZ0ZPhCCkCNnrPkUQf3ka0xAWbiaWXefwiiFvBvZpJ9i7aZMOhYLwgE6LaMsX418zl3vaacPmY5jTv7qDKCLctfmw78OixrWWH1haUKgpN0wOxhgOTUv0oIVdZ8PanTZv/S7bxAVBf/Bx4jz2J8dajoXqbRYyIajaqdrieeBdmmtKMgHP3sKyppUlUfV6x9m0lBbU9VUDGjjhoKmCLMnlyzmFC4Bzg5E9gvFBapwbJFziTwnrXTu4UozqsNed8523joal5LEZmg7NechKij61xF+6t0VZKORR/os9lXvCsB1+aQAIoAjbe6jbc1hedwPfr3v1GGKkOsEHtrX9F5nB3NxQjNl06rSGwMu7JakqKOKydRonB4Y3AJ3Mg5Zk7iurOk6gsfvlAh5aGEir1nT4QfzMKtMZNs1KA53mYrcmEB6jB0WXgv34skj8nNpAsMzuEBY5w/MPO1KTx/y3IxbA6Jdt1m0LqLdyYbLc+Y4scitaf/uhxRymmhFkOo6HBCR0rJiDR5ubcYiV6K1KYmIsuR5xk8pjEveFQm1LIag3SK6Ah/99WDDnTuQ7HOTZZCdnMKGB24sw0GOuTjE06pWmVSnDDfKVz26S5B/cwwn1V9rV4tZ9Lqk31RKYtuPRhsjK0Tc12dOQeeQAfOBrx5VWMjioZSrQSMVgvIn8/bB4m8tyiMh+u9dk1Muo1Pmfw0kUlkija8zQLGoZ4a1qfCDUtuXvHF4pb3KWvrqSDnKhGGFbEenrolKA4EVxZ41DyB+c5KCiTWe+KFhjkUv26ZQS4nCjNsR7/fEdU8l847ysc+eyZPfKrvdUBMoHNgAhfze94l6vD554c4bcQMhm78zOQYFe45gxZgtSW74oFr7IkmlUUfAODADGaVW6kzBwc/hC5Dp9HKSIFtRsic55fJKXam8EloxJZQGBjyzV3/TiisK42xQxKraejPp0eHyi2X
 fp75MXBi
 /yn0kEvFMSGCWvg6VhMX9eNKfI8vd5Yls++QCxszD634DBtf7DG9xsmePYQMLNAG6FHb2EeZis+T4KGjvPbx+OBiOXDo+zC4Z32A9099Hk7L0yzUxUJloHoHfhaw05eaTz4WrKdRMrZBO8fRxNCfof6pvPgl5dsOs34FqAOB96vgXJPnazX31+3Qmm8GEYdPA4cBD6h5XrBxGAKJVJWrqqqxLaKKTTHMpJ90RqcrV5TnxTwo6/rPo7Jwt7p/CWN0oPUVB5Pdh1BWcJTRKwdR5eRZ/nP924aMJAlRhdyA5h90kzmBblEybn8ZkPxwZ1KMZO/Cr
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 30, 2026 at 02:36:45PM +0200, Miguel Ojeda wrote:
> Commit 2b6a3f061f11 ("mm: declare VMA flags by bit") added constant helpers
> for the VMA flags and blocklist entries to suppress their direct bindings.
> However, it listed VM_MAYEXEC twice and omitted VM_MAYSHARE.
>
> Thus fix it.
>
> Fixes: 2b6a3f061f11 ("mm: declare VMA flags by bit")
> Cc: stable@vger.kernel.org
> Assisted-by: LLM
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Oops! :) LGTM so:

Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
>  rust/bindgen_parameters | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/rust/bindgen_parameters b/rust/bindgen_parameters
> index 8402b0c93545..93e622aaaf78 100644
> --- a/rust/bindgen_parameters
> +++ b/rust/bindgen_parameters
> @@ -50,7 +50,7 @@
>  --blocklist-item VM_MAYREAD
>  --blocklist-item VM_MAYWRITE
>  --blocklist-item VM_MAYEXEC
> ---blocklist-item VM_MAYEXEC
> +--blocklist-item VM_MAYSHARE
>  --blocklist-item VM_PFNMAP
>  --blocklist-item VM_IO
>  --blocklist-item VM_DONTCOPY
>
> base-commit: 7b5ba47d845f35b04937748a191a1772ffc1f288
> --
> 2.55.0
>

--
Cheers, Lorenzo

