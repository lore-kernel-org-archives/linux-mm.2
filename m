Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D90AFFF8867
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 22:46:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E1B646B0088; Mon, 27 Apr 2026 18:46:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DF2816B008A; Mon, 27 Apr 2026 18:46:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D30116B008C; Mon, 27 Apr 2026 18:46:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id BF4906B0088
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 18:46:44 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 35C15A0384
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 22:46:44 +0000 (UTC)
X-FDA: 84705821928.10.1D4C043
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 7050A1A000C
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 22:46:42 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OQu9oUYs;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of broonie@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=broonie@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777330002;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sUOCVCwkDvAsvT4QFe/ve3int+0hAV1t081X52X2K4c=;
	b=DDFnNeRWCCxu38JN+Zz7VcTEmhJJFXnMYs8OiWbpdXWLPE9oEOOUsX2MxM2kY8jU9bCuR2
	/m20UNGrclqeG0ggwUx2kfpvhGAdDXY/xCx8om7eMgwKcm9t5f+QhLGbSF3v1JN4csSk2J
	WfMhQHgiA4QXAmYJyFqV8WYoIo3FE7o=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777330002; a=rsa-sha256;
	cv=none;
	b=OyVvhmFnxcEPUiJgvSM4zlm5dK3hrlf8WBg+45s87SuYGWpHHkC69VZAUL9NCTFI70xapi
	d6TyG/WzOWGqg2IJ2e81TgoFtWmVAULGgLm8lsQbnkYzrHxGaShAOP5VHZWF6hXtJAg4Sb
	Lva2afxYM3mr1Rl56QcMJRjeLltsh3o=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OQu9oUYs;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of broonie@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=broonie@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id CA9AF60052;
	Mon, 27 Apr 2026 22:46:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E033C19425;
	Mon, 27 Apr 2026 22:46:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777330001;
	bh=n5gFq9q37eYKpFEcXLpgRDH09jgbIoc4l89TWPtZg0s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=OQu9oUYsYCA5E4F2chgkBhPx7BhwwQvWhe7SkkMd8nN9Jp2nQZYBy5Mp7TZL7su7l
	 QIhmn/x0nDaH+g8x9rzR2pXfNCE4+W/vkz5f5hqMz6eRoBAHNgQ9oLfpom1md0J1L2
	 7Z8UDRvHteltaywJQMHCXLQDkXUhVCOa1CId1e0lpF4rsaKO7fWYKC0ACqilL0Ru21
	 3clRUMWEFImj9oGoaz1pUK5o1/apmrBAOuuBJw7xkje/103APz4S4LBfkr9xbzdKTt
	 eLEMHQKQVyELeh8Q0t0Ph6ESjvnZ52sCNjhTzzW7sP75xVOQ6+Abvp0kIgaTw37UYp
	 krv+IGQJ5QFIg==
Received: by finisterre.sirena.org.uk (Postfix, from userid 1000)
	id 17CD21AC583E; Mon, 27 Apr 2026 23:46:39 +0100 (BST)
Date: Tue, 28 Apr 2026 07:46:39 +0900
From: Mark Brown <broonie@kernel.org>
To: Kevin Brodsky <kevin.brodsky@arm.com>
Cc: linux-arm-kernel@lists.infradead.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>, Shuah Khan <shuah@kernel.org>,
	Will Deacon <will@kernel.org>, linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/5] selftests/mm: Fix resv_sz when parsing arm64
 signal frame
Message-ID: <ae_nTynMI26GV0PN@sirena.co.uk>
References: <20260427-poe_signal-v2-0-2bd9d6f16ab4@arm.com>
 <20260427-poe_signal-v2-2-2bd9d6f16ab4@arm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="WzzMpVDZUqWGuynT"
Content-Disposition: inline
In-Reply-To: <20260427-poe_signal-v2-2-2bd9d6f16ab4@arm.com>
X-Cookie: Victory uber allies!
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 7050A1A000C
X-Stat-Signature: wz77aqp14ec68wjwnmbzq54rpfztxq3d
X-Rspam-User: 
X-HE-Tag: 1777330002-334742
X-HE-Meta: U2FsdGVkX1/idPCcC/ptDR0v65LQEfUv/UHBSoXaiT1HIVEkK8WobXD5qKQvlzRLHBkZ1woP/o6Y9X4z81LHQrYryhJIx47hP24ug89P2eYu0ul9au+hQIdWCZp8sGe3rqsxLiSKIFw6h/7+YE71VPLxRkLPIwNcGPcLLM+hFmp28zS0h28Uco6/+WlKG00GYncXjzl1qWg+NK7cdCD3f0A6h9xovbzZft2Bn0eIAPOQVk9KWV1FrR8IfkB+APjXT3Q6/t3b2XnCTaRQcjcYqlPofnDqfMBUKAwtENT/5MPmofdyA2fs7fSqu1BywML4MKdS/oVeya8cMtfacHy+KuOx80BUyAiA0vYDg+3YK5iyV8Kr3cxjHlQQ1xhz7hrj8Wb89Ah+zna2G6Ph2JUsX4V5enHMHPxq+trHWhYCq7E6hAZWR7w9ZhHwmcs8dHEzgE55gpHmIg7fGTItZItEzpcnJs1nzkgpg1KB371DVukxC4sKDktDubA+frO/3BGyWvZVw294G2KYXS3wTFKymofRDGEy6mkQxHCsWZgI59vL4k1HMS0GpjW2I7NqoZODxQKjWLc2zxkzM7SgRGuyoQnIfWzhJUysn6qkUcwRcimHhpuZRHfQ6bs9nWF5mB7dkZ/egW0nQiJGIxN/ceUR3JhAxCTIBRhQ0ntZXDHuc1yd228h8WthfXk1C5cxM+np+VtQnno9kZMmvvYLFpe1p2V/sLSmWutS3eqjixx9ELyzOqBLWeF1UN0qhT70wmEFl4Hm8VzQH+7QTSiUahaS5chmyR3WZnRAJ1QAt5l5x7elh6BCYZxS5NO3v74QQ7SldQ/MfO3jk/CSA09YgSqyjcX2enn2slEJOP5EdZpT4tsHPA1892wrfKdn4LId5KtoPrp0ekwZZdVK+QOC/PRRfveOB/jm/zQGvvMNCDTRMalURqNiy5oNvSPVcmbQTKARQxlT7a2PCZpNN+Vj670
 iEEUQ3yh
 +htOfZ3hmaqERJU6OP5qOmChbXumOFbwAQxS2qvAO4HYn6R+5sICRSqNSb4scL6OqCIX1MyuniAF8aTxl4GJqESRmYIH6DyvuFu8O0a2DdqqmmCGptgUu/uUCeWwcsnqRFzZlDY9e7EXJsgUpxK46TRJr1Z1nK94YRFruUaqtCo7BnE4nZSHSzSbSZpoFMUb0XFreaFyQIexddXBbpp2uCrf8rt5w40CCWZlHHBXFrE7h3saE4wOFj/ZqM6GuF8q9OL8R5YN1zms+0RsSl1fLl+tJ92Oj/UY/QGnLG3Fsv+9rBUKATwp9tBnRtsVzbgKCoboELdiuLCotQr2q6Oc0LcdiO6kkCjKxy9t+M41mGtGuGtXyZKmzoLdkeqHpGpoYWsiLQTzUmJiKmdRFCthRKUxh+U31/H3Clptf
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--WzzMpVDZUqWGuynT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Apr 27, 2026 at 01:03:34PM +0100, Kevin Brodsky wrote:
> get_header() wants the size of the reserved area in struct
> sigcontext, but instead we pass it the size of the entire struct.
> This could in theory result in an out-of-bounds read (if the signal
> frame is malformed).

> Fix this using one of the existing macros from
> tools/testing/selftests/arm64/signal/testcases/testcases.h.

Oh, good to know this is peering inside the arm64 selftests - it'd be
good to document that on the arm64 side to avoid unpleasant suprirses.

>  {
>  	struct _aarch64_ctx *ctx = GET_UC_RESV_HEAD(uctxt);
> +	size_t resv_size = GET_UCP_RESV_SIZE(uctxt);
>  	struct poe_context *poe_ctx =
>  		(struct poe_context *) get_header(ctx, POE_MAGIC,
> -						sizeof(uctxt->uc_mcontext), NULL);
> +						  resv_size, NULL);

Reviewed-by: Mark Brown <broonie@kernel.org>

--WzzMpVDZUqWGuynT
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmnv504ACgkQJNaLcl1U
h9A1aQf+L6+uuz3D6N7BR58qAnQN3BS2/tl81soQVMBU56wRidU7GVgf/AtWw2jW
/LVlvMuB8Ap2uzlr5zjxrd3ZTM5XbOcB81WKJIxyhN7hGmivevjwwXvx2suhJhHV
qz196HjM076yvXa4/Rp6AhzjnAfVC6TpxRr6fZEemMOuX9sVnn4DB5dwXI0UQlgj
Rzg/gYKPM8IAAqeXxH+m4sICwgXYfC4WQSn8WsCJMb96EGM5ar84/c1PRqYFAryU
TWLt9PgfB7B0vWGgMWVkLbnx925WhvoD8T1fDz7jOUUURkn9nxrDKSRsHfJG/toR
HUA8Boacpswt9EXt56PfWIC5mySyhA==
=Khap
-----END PGP SIGNATURE-----

--WzzMpVDZUqWGuynT--

