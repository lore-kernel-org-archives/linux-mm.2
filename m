Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CB2A7CAC5B5
	for <linux-mm@archiver.kernel.org>; Sun, 28 Sep 2025 14:47:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 182528E000A; Sun, 28 Sep 2025 10:47:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 132BA8E0001; Sun, 28 Sep 2025 10:47:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 06FE08E000A; Sun, 28 Sep 2025 10:47:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E9BF78E0001
	for <linux-mm@kvack.org>; Sun, 28 Sep 2025 10:47:49 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 85217833DA
	for <linux-mm@kvack.org>; Sun, 28 Sep 2025 14:47:49 +0000 (UTC)
X-FDA: 83938938258.05.762D4ED
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id EFDB2140006
	for <linux-mm@kvack.org>; Sun, 28 Sep 2025 14:47:47 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CvPXqnCr;
	spf=pass (imf09.hostedemail.com: domain of dakr@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=dakr@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759070868;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=e76/sEkLu8XYQWEzrfvHrEYuju5sMDvZ0c0Z+MNAFRM=;
	b=5XZe7psjC3MBO54gqAPkGZIHQ+VTGyfvi7ALxBWmTUlRgm1x9nnGn25l3ITodppOdCLzzp
	q1qHNQhBJ9UNJWcOnfvmiP9tGyWmYdrL1oCWMlCxSj1ufDpJgOtOdCBHaaeRwXCf2Orjp1
	RABBMQR2MmQMoZ65pAkKcj4AmcpijpI=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CvPXqnCr;
	spf=pass (imf09.hostedemail.com: domain of dakr@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=dakr@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759070868; a=rsa-sha256;
	cv=none;
	b=HfLHqCNLLOF6hesvFn0WDVwNgKTeU4FQBFhDx9EDOhl2rQayzcx9dr68z8vTPhxZ7uzkJg
	KeO3/vSZ7WxDDOxPmuIQ1rxaL5Oxm2pjcICXMLsrRxxKjcgPUB/Fgxrxjue4yHVzhNIm/V
	lP0amNKisgTFC4ek5nIboE1OzLBHm8k=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 4B4B562175;
	Sun, 28 Sep 2025 14:47:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C93ADC4CEF0;
	Sun, 28 Sep 2025 14:47:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759070867;
	bh=vvNwfQ/2Efdxogg3wf2Xq+cs+e22mGauJxHdeTezgIo=;
	h=Date:Subject:Cc:To:From:References:In-Reply-To:From;
	b=CvPXqnCrkzZPSVVaZJKnQZOCfXZvPQAiWaz7udbp3rkaHKddCoEDBU5xg6BP9g9sS
	 NEZ8+LLM6bS4O57MhmCgoMguvqYfPXcb3iVLE/LQ0F2T2ESOVD4CIvZYeqah6aNoFm
	 acZdXEQCH5F5SPtOKSxUPXwJ54Xq9m2rZG5gUhwIpg4xADsqrvuNBUQaGpwj08V9Fr
	 1y/4J1PYCL/aCunNd0CmYa0odmBx/ThHY8IBSZKVwSaa33W81hfzZlOXjwn9Z2987C
	 CMAyiKgmFJqbbjmKEkMjX/z3ChWec6QnGiFL61d8LinWqtsT4rYIujULfvBxrm8t1f
	 WHM1yv80HwxYA==
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Sun, 28 Sep 2025 16:47:42 +0200
Message-Id: <DD4IKU7O94WN.2VALE9M80XGQ7@kernel.org>
Subject: Re: [PATCH] rust: slab: add basic slab module
Cc: "Miguel Ojeda" <ojeda@kernel.org>, "Alex Gaynor"
 <alex.gaynor@gmail.com>, "Boqun Feng" <boqun.feng@gmail.com>, "Gary Guo"
 <gary@garyguo.net>, =?utf-8?q?Bj=C3=B6rn_Roy_Baron?=
 <bjorn3_gh@protonmail.com>, "Benno Lossin" <lossin@kernel.org>, "Andreas
 Hindborg" <a.hindborg@kernel.org>, "Alice Ryhl" <aliceryhl@google.com>,
 "Trevor Gross" <tmgross@umich.edu>, <rust-for-linux@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, "Lorenzo Stoakes"
 <lorenzo.stoakes@oracle.com>, "Vlastimil Babka" <vbabka@suse.cz>, "Liam R.
 Howlett" <Liam.Howlett@oracle.com>, "Uladzislau Rezki" <urezki@gmail.com>,
 <linux-mm@kvack.org>
To: "Elijah Wright" <git@elijahs.space>
From: "Danilo Krummrich" <dakr@kernel.org>
References: <20250924193643.4001-1-git@elijahs.space>
 <DD1SGLU4180C.361W5XLH76XNC@kernel.org>
In-Reply-To: <DD1SGLU4180C.361W5XLH76XNC@kernel.org>
X-Rspamd-Queue-Id: EFDB2140006
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: xyic7h6ih1x45thx58iyye4w96bytegz
X-HE-Tag: 1759070867-580581
X-HE-Meta: U2FsdGVkX199lIz9omsmug9orYyAFQdqmhQEceHqZfzoDnDnjRDbX5jWc0nquSIwQhqAgeYec8Bgh15HJTVos7wrre5BhBJjVxbhcNutuCb5v0RiDxvV19ZvOm/M+80inOjWHaRhwpR1p8iPR8oU9eorJQfdkNACEzcj2vdwYXU/5A7eTOgX1RbZkvuFaGNKEP+9cZnvd+RI/i7FPUPUdzl+rIIiXjMSqiL9dmHxGWqgefA1V7ohKx7z9jyaLhtQ4/grQSweGDM+fYi29LyajCDwTjx7zbDakVKUoSP10F397isrEFmA9MpExlUzgwrk4PkiHi4w5HFrZ9++TkunpOb0cp5iMlgJVUu/LdEjGqcCFaLR7Z3zEQGUWESFA/t1/UJOror+F1i63an3EjkXobvDvwsUPbuLe6y/4Cw+XVph0PALEjya8akXwGZGSS3IFq/EXpkIJ12nVtTmfrjUmKuu5ZkOVBZJCThfwbWQ/KFPLFnAXJsL9wYXYioYmWEKLLKMmnRgFN9cBLv4nGbR/GKRkIG2r5dEedbvKxVsRiZkzsOScBnnUfA1fuIP6P6euQ36ty4VmWv24tp2Rhxh1pasEDNSdBODPRebxMuQ9cYUzqROEpVp2DkXvkn6dAJx03h/BesvPXbXbHALI2HjznsVnBhznBKOvAl4fa5o4w4l/8ONFJ2CGlod7XTY2Lwwq5/ljGSFbJO4AP7q5rI9+kqmK4npnWD1PGr5RxFk+T148lEmEUfj3fi/ulm4oi2Hbshiv8+C9S2Vc6D99Mtc0l1+xXwDrZVvz9VKCg6Stwih02/pEJHKtxYqEAlKSmhajGAlRWrEfW133dv4IyIDTZmDw2z3WYL0muEnrOnfHQE8BOY6xca7f37R4UNnxJxRt5uI/G4KipPtlwCl4EejJT5NYAN5yZ4Rh6kSXXb5CgWAZCIOwt0bmg1g8y6QLPb+glsyEjeIdJstwdB5yMe
 B/9ssnl0
 RZbYXIhSjFry5Rm/sW7a7WJPn5yCBV1nvtsK+Psel6THOJK7GkZUauEdM0eEJBaxH3NFtnWG95T5S1HvV95DobDB/tcsxHnVJQKVSEqxJ4I+r/jtRBsewQSEsL1679X3Jwk0Y2lBnnZfL6Q5YOZTN5/jJzRZ2lMQic1syvOm+ZtirTbnyJ11hFZY2tPVuiHNduou9kN5ec3DmRXZgPq6cGmEbWQSOrsIynzi+CVKvR5G4ly1u+bDuEuAuhZwhESoUMPycZaIOUW63+Okh3B8GEt/lSIIgmW0AakvQlsjqUrXa8GN6F5Qu9wFeZPoaZclfnE8UKO69UmMv+DCenSyL6SSZM4ygQF1KHIZf
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu Sep 25, 2025 at 11:54 AM CEST, Danilo Krummrich wrote:
>   (3) Implement a macro to generate a custom KmemCache Allocator trait
>       implementation for every KmemCache instance with a static lifetime.

Thinking about it a bit more, I think we should go with option (3) for now.

With its only limitation being that it always binds the lifetime of a kmemc=
ache
to the module lifetime, it still seems to be the best option, considering t=
hat
the alternatives require additional synchronization in hot paths, may *sile=
ntly*
leak the kmemcache, cause significant code duplication or break dynamic
dispatch.

Tieing the kmemcache to the module lifetime should cover the vast majority =
of
use-cases; should we ever really need something else we can still revisit t=
he
options.

Thanks,
Danilo

