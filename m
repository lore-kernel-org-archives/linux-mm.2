Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 42376606A880
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 10:01:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dPjlXGFn
Received: by kanga.kvack.org (Postfix)
	id 2B7FB6B05B4; Tue, 17 Nov 2026 05:01:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 269026B05B5; Tue, 17 Nov 2026 05:01:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 157276B05B8; Tue, 17 Nov 2026 05:01:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D91726B05B4
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 05:01:38 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 43E501C3ABA
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 10:01:38 +0000 (UTC)
X-FDA: 85444169076.28.2A5A8AB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 60960C000A
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 10:01:36 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dPjlXGFn;
	spf=pass (imf28.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794909696;
	b=XNa1jTPfesaIe6VbJzePQLBA1LdEysUdscVPJwPSPNR+uFjjBXIcKOwpBbEJfs1ToiYhIQ
	HC9Qhi69Z4KNR1ub3pnp8pcYtI+6q5+JPaCztwgqdlAmOm3k9wp94HLNDbhapSqEEqMyZW
	z1YMC6d4vWFNks5wLDcDLhih5KsCdJU=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dPjlXGFn;
	spf=pass (imf28.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794909696;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5oABWPCQflLUdKTbaIQUUOlSS1RGm0erDPyxm9dVT7E=;
	b=OdmLnoUsu0tMV47Qm0Idr174SKyUKOjE4nqETgcxuySDGuI56InrLIk3DiUnohcEn5AJOW
	T74yTtkoH1PtnHaRdbsJwLMr29GiU8ehYh1xQ07kMIdVSS3D29pPu4ht0mMWLO6IIoJ+Sv
	eZ/FP1IWvuqYE0uwTGDGcKPoEGBrSOg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id AC50F435B6
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 10:01:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 918C01F000D0
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 10:01:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794909695;
	bh=5oABWPCQflLUdKTbaIQUUOlSS1RGm0erDPyxm9dVT7E=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=dPjlXGFn5f1uNLVj3maDK+PGwOiHUTLKPCiWcOPWQuNfUhLUbp6oxT6soenc0wGQV
	 oWgyb5J4i1Kg0rmJgW2eNt4MpdQ3b4Ahn+Fef0DGpgxVCZLfZsdUw8k4vSie8EbdAe
	 iK+lK9TP8Zd9NvOkly3FuyUY9E4YyrHjK2JgeLI7aENbnoUQglZA9fM48fgqtKTIMA
	 NUhvwDSr5V6Y3tHT9bbaJlSCsu85TLKRmIZjwZVraiNDn+i8Rj+ADMP/fvBx8fjeF8
	 gWcTc91iOVB4TFYWYiQdGhKEIvsdtGUK/w2BVfR9OCuJI7o7iHEc0rTkW14emkxjMV
	 CgqySzLCi3lnw==
Received: by mail-ua1-f48.google.com with SMTP id a1e0cc1a2514c-99e0d9b3438so570883241.0
        for <linux-mm@kvack.org>; Tue, 17 Nov 2026 02:01:35 -0800 (PST)
X-Forwarded-Encrypted: i=1; AL+hErHcTZEHlqdvVmgvkYDpBWxNHluyxZIEyuCPPStFK6Sai66mEEy7czw0HQEkESTJ9ivoEiD7jObAJA==@kvack.org
X-Gm-Message-State: APuU4Z+knHZiS6IpO/K1w9r/joZewIXV8xqVE/khBiqZuvnrbOdb7qRV
	Pj2Ddx9N4wHdzDNX3+VfmuOTNixHkjxCfImPpCGPLdbySqmIewUXM29bijEYOGWeG99I0RNHayO
	a/GvdCU7LZFU9yd6fM3yM/JQVf5RNzjs=
X-Received: by 2002:a05:6102:3eca:b0:7c3:6466:3155 with SMTP id
 ada2fe7eead31-7d64d8da06cmr3888168137.33.1794909694939; Tue, 17 Nov 2026
 02:01:34 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261117-unused-sym-mm-v2-0-2f845e94dd50@amd.com> <20261117-unused-sym-mm-v2-1-2f845e94dd50@amd.com>
In-Reply-To: <20261117-unused-sym-mm-v2-1-2f845e94dd50@amd.com>
From: Barry Song <baohua@kernel.org>
Date: Tue, 17 Nov 2026 18:01:22 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4yteXmuK=UUyBjKFSkKsX=+pOJxRXcCoxf=Xeq8EgCEkw@mail.gmail.com>
X-Gm-Features: Aa3M54p76ruRPy5nC_e2T_VRxviAo5UTb8trf4PyX1lbTffANmrCzu4bfZBZpDk
Message-ID: <CAGsJ_4yteXmuK=UUyBjKFSkKsX=+pOJxRXcCoxf=Xeq8EgCEkw@mail.gmail.com>
Subject: Re: [PATCH mm-new v2 1/5] mm: remove unused helpers from pagemap.h
To: Shivank Garg <shivankg@amd.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, 
	Youngjun Park <youngjun.park@lge.com>, Minchan Kim <minchan@kernel.org>, 
	Sergey Senozhatsky <senozhatsky@chromium.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, 
	Pedro Falcato <pfalcato@suse.de>, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: fcesrrnfnpkhhtheaeo67p96pp5oh3s8
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 60960C000A
X-HE-Tag: 1794909696-62729
X-HE-Meta: U2FsdGVkX181CTBEqa4ecAoJHZxJkzod/I3jYl4jgUhjkgRQPZMSnY3ZeeykeHeAhG3DeqhycMrc/eLiUUh+7/DrkZ9x2TTkWGpFrQgOJIkvmovAzkd5v40I92UWUGmgnXdbxwDqbcfpuCc+hyWQouU5PWzz9QD7+pGTEE9rFnDZxRTQYXHAjfBaSn54w7EAqqTvH6PYdm5BvrZeGciKsBXkDpjhJ1et3rYqL6clIOqwPmYhjJTpEFSFKRCudfdKqRm1oriZtCsaSsHya87lrVsRFPlFrlHWXVBfswbHmhes09VNXM+qCYXorKq4w3MORxd68CuQPb/sVGohr++J3G72CQRzZgJ9PBymsra0Z3pkC4EPteeoHa5E6ie6PbvlybvlnqMNy6MeD9FiXKP3wAY99jn6y4Fr+kzgCRLpbFjoeyG9T/VFKMzyFydsJ+6R+BWI3PUBGcNQ8UzwX+mOACOoUXTbLsE3Evsanwv6pXt7+r4GU1QPU25VPqMwUdxKV47hXOMc88IgPar64Ntuhzkgu+zdglQVH+/uAzkqqSdocME6mb4KPNIPvm5Y+vfINwVoLlepxrXmBKEns9kFGnAHuIKo+gFQT6MKft4cnplQRuV8fPlE+uFHuA1p7rAcvJDBugHpsk9kv2XG2peEK2M0ApQiKwCazBdjXGr1q2TZ3lKDDGGhS3Xhudv0m0mwIfUgLDsxKfadfibUpK2y64iY0OwxgcjA+usTiyIrGuVTyTBRin3LIYUBg07n38TJlwKgIvtxYNzsg2gvirFqWc4uQcyp2OkGK+aGcNQRE0Wq1Y/tVUhY9UYGObT/5U2ditniH/IS1ZGSWJbQ2AaQ3dsvVpFmUL50cpbiigE83WR6eTkqx5SdqMJatIOmDVUZq/AYRWmltZgNzH2cX2R6eaSUW7g9hRBv0fpEi9OTcT9VQKdNRA0gj1f4us6sE7yEegwUDo2IaQJd2IE3HV0
 lQadJdwk
 vLuB1BYIwyF5EXQwuGtmrAy4+8SfgJZU8YxXI6SaHmFIrxJHz96ptZvMMlRovtKdpsIW2hMANM4uXgLu568PbbbRSz+2hY6mQCwct+CUsbMVORym8qaQXEntFMX5OiuGKogtiVQgpUYB9ilWJKh4Epb4mcYrcc0pOHypCQPmhR61qsTfjoAW1K7c2NHt5qCtUo+0tDiW5q2rXpldVTzTXHXOj6EXWfsQKobcJo8Q7/1X4/QlQIXbMi9elsrSstLoBUMGAUJJe0K7k3cKyDRWpldl6a9ktntXN6WJ0EkXBSkjVc7tzFWhaLPB8U+wde3wGZfhus/6ncFdyYtc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 17, 2026 at 3:17=E2=80=AFPM Shivank Garg <shivankg@amd.com> wro=
te:
>
> invalidate_remote_inode() lost its last user in commit d73065e60dcc
> ("afs: Use alternative invalidation to using launder_folio").
> mapping_clear_release_always() has no callers.
>
> Signed-off-by: Shivank Garg <shivankg@amd.com>
> ---

Reviewed-by: Barry Song <baohua@kernel.org>

