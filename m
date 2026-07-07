Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4C945C43602
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 07:25:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1AD0C6B00AB; Tue,  7 Jul 2026 03:25:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 15EA36B00AE; Tue,  7 Jul 2026 03:25:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0743D6B00AF; Tue,  7 Jul 2026 03:25:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D73326B00AB
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 03:25:31 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 696A340348
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 07:25:31 +0000 (UTC)
X-FDA: 84961145262.20.865AE0C
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf23.hostedemail.com (Postfix) with ESMTP id BB37A140005
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 07:25:29 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=KT0UD5uu;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=+4EDqKFR;
	dmarc=pass (policy=none) header.from=linutronix.de;
	spf=pass (imf23.hostedemail.com: domain of bigeasy@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=bigeasy@linutronix.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783409129;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=C0SVmj43u6l568Vfp1SIbsWqwMiAdzs6ix36MxKXktw=;
	b=X50eQSf5Ca+twjm92JcqucxpbVXgoenP4K611ug7eeFbveX276ZC12vz3Hg7hFINNLxlaD
	xw/uKbrwvSftpiuF38+J6HQM1Etw79uEedn5SaLoDHgJYrJx8x7bcKaM3k2wSIQKG3vTX5
	PfVKO0OaNZ4w1fBfxcb3dssUpFF6uWI=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=KT0UD5uu;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=+4EDqKFR;
	dmarc=pass (policy=none) header.from=linutronix.de;
	spf=pass (imf23.hostedemail.com: domain of bigeasy@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=bigeasy@linutronix.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783409129;
	b=6AE0VbuyXJeZfBNhufRzdGMl3sbe8+0Tt6RO60d/W0KCQZmPq9R2COwY1AkzT8G9yj+WLA
	yzZ4lFIt3FMibRP8NA7aDe8JF72EshtvK5RrBFiQ2YSqdyPD51bOCj3/156fjeGghjhFQE
	RKPE4vS61YyJ0rLlJtVnipWxuxcw3Ck=
Date: Tue, 7 Jul 2026 09:25:24 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1783409125;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=C0SVmj43u6l568Vfp1SIbsWqwMiAdzs6ix36MxKXktw=;
	b=KT0UD5uuroQgmma8e/nNFcR9pvRXjp4CaD73G/T19FB7EWt6R73S74goA7TXZKreWgKiFN
	XRiMV3m/EktH0egO1mL37XT5YGSTEFcp5v/vonHTHQnIR/+6Bc67le1kIZLjAPDCyZu07h
	7LdK9lID3uyN9DEyLDeSDoxew4hVl2boZeEWsk1nKKKwd40+vit75nA1TiEBV/BHXiUOPc
	4pgVV2UuQGK3Wd0tjnur5FU7RrCmmvlO4Y/C8+mQHwuioHRPzl3QC2yhPIIHDMQ+HeD+Rh
	51KltR3mfGzh836zVKO0jztpjVA9lRLxE7z9STG5QWYKHWD3keYMoxen/FbH2w==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1783409125;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=C0SVmj43u6l568Vfp1SIbsWqwMiAdzs6ix36MxKXktw=;
	b=+4EDqKFREOOi3NVU93iHrf7aROCmKVXGt6YpxPmSL3ddlN1J20iHCZLTHuKfZkzE+08Vei
	E1zAi+JCJXG1iNAw==
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	Hillf Danton <hdanton@sina.com>, Kairui Song <ryncsn@gmail.com>,
	Minchan Kim <minchan@kernel.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v10 04/19] zram: remove max_comp_streams device attr
Message-ID: <20260707072524.9IkUhJ8G@linutronix.de>
References: <20250303022425.285971-1-senozhatsky@chromium.org>
 <20250303022425.285971-5-senozhatsky@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250303022425.285971-5-senozhatsky@chromium.org>
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: BB37A140005
X-Stat-Signature: iigd6u8dcsiy7tj4rmjjfakobfyffqdg
X-HE-Tag: 1783409129-31022
X-HE-Meta: U2FsdGVkX1+e4+9uSWR7HCY00aeiiq9AUqPIcu3znX32ssR6SQ50174HacFntamx00TvIyGh6LYlmOKT/gcC1LZT3aWbg8+uCt1LIuKYubsslHuIwQV2VX1dF0vB2tlKclSQ82F1ITIdoie3gBBU6mFM+V8P+19MRY1ezF4yiylpRHERb8rpF00rvXahOtPOdyQoF+IG10m9Lr/TmODPPzoVlRV4Felw2VF8Jd022eSjui0alFx6Fqdc4YcGSFkNrStFPA8IPPL5lGPXZjEvQlRsXjGkcxOXR4jUBYfE/A9KGJIbVtXF2kNQBlP0Kwf6KNTnW1g8imA8VPgsMCjoiUCpYzrJ0q5RaUBhoYhcEfyMIeaDsSSv+QM4xqS8LQ8XRsAKMS5BRE2suIFe6FTRy6E7C8K0Jsl/YBPBSmz1nXDc3J6/fvg58Dg80ymYSZtEjrk+8byNo7YUNci6vVh/dtU3ZClLQA+h03nnVlebdTdAY01/2NES0XDlsGWNrWN90WhzYGedEPnEEusvDT0wSJ9Hi0cUUfNQzkqe1VKqvqgOzfSsZyeHWht9U7cvjrPUZfQ55Dp6gSbKTagEmzA7b9beItVvf0fAIrXbdw2EB2QgWjhD6N6z1EHJhbiWF+DJjdKeMJ95EVzK/FW3Af1SHByWkKT6XZkAPiGsl+blK7tc7imlGARr2rnaC7XV+9l/JTV/MXycboQcZP2GWHEhYAqg8MyDwAGAIfv8OpMlEgcd1opR4sjIiksL/8MUsABzcKcGnYJFjrVeQoQDt6O2DdVGxZwNZmSzw+vZFpUaphvTdb/hvlql86+NAjppB4QOQEdJnjZCUpZX/W/Pbw2oFvs9FkMefsNzwUQe452Zzg6wBitbWwYr+ms8d4ZtA7PVhwFPf+z1logAODlFVFCsZu3AH4LLL03qtRzt/AgeSqL7zn/ft73QThXahGy2jvOkdwdX7SJ/PIphqC1Y1OM
 cz7Nltbf
 haLDe2iCHvmH/lr4uHKmmBzu27vJ7Muv2X5LQxfsmtTh7vWcNzPd6w1Uh2aWMjdo4modpEPqXrYXQKOZR1aId15lHHJ0KF+AGxlAcDEyjh9v2e4s1CQPhF/pVk3VSDs6u8ClkxSkXHCsjR1P3PuKyHvmWtV0be6r5xmfpzyst0f6/kYRe1gckxEs7uIYvTLFjUd83Sh8w/xD1fvoQAD+oBudQKPLAGDxLLZ8NOWDp9DUkPUOfH+RPYKtgWw49gi/05/+A4LiT4nvZb0KJIcowQgNuJ0mgOkmscg5Z
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025-03-03 11:03:13 [+0900], Sergey Senozhatsky wrote:
> --- a/Documentation/admin-guide/blockdev/zram.rst
> +++ b/Documentation/admin-guide/blockdev/zram.rst
> @@ -107,7 +93,7 @@ Examples::
>  For the time being, the `comp_algorithm` content shows only compression
>  algorithms that are supported by zram.
>  
> -4) Set compression algorithm parameters: Optional
> +3) Set compression algorithm parameters: Optional
>  =================================================

You could take the opportunity and remove the numbering. html links work
and you could refer to a section without the number. See
	https://docs.kernel.org/admin-guide/blockdev/zram.html#set-compression-algorithm-parameters-optional

:)

Sebastian

