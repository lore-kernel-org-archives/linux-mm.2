Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 97B5ACA0FF0
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 16:54:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 87F508E000C; Mon,  1 Sep 2025 12:54:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 857008E0009; Mon,  1 Sep 2025 12:54:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7BB328E000C; Mon,  1 Sep 2025 12:54:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 6BBC08E0009
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 12:54:05 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0B0DA5BF6F
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 16:54:05 +0000 (UTC)
X-FDA: 83841278850.14.F0DDC87
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 9DD19120006
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 16:54:03 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=none;
	spf=pass (imf29.hostedemail.com: domain of cmarinas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=cmarinas@kernel.org;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=arm.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756745643;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lx60aYNhHUxGjmY6Dd9VkBXb3EBDBQjnPwbyMtD9Gzo=;
	b=vG+gLdiWF+4HmudW5mvenLo9SIbjVvPtKx6rnaEE08LDGTPzAdwZcXWDLfNGjcxn+UCCB7
	ZsweHj/rPIZ97iMvOwubwBryCFq1XjqSDN4XDjzYFlLPR061A9Yc7AMkMnjriW4kNWe12u
	HgLZLFkfQrzzGwEihiDDGeYeRAgof9s=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=none;
	spf=pass (imf29.hostedemail.com: domain of cmarinas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=cmarinas@kernel.org;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=arm.com (policy=none)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756745643; a=rsa-sha256;
	cv=none;
	b=ty19mwSa4jNZoUIlfnbGRF/yWP4uaAekeqseSqsZbJq0F9CVD6AJrrqL+WtiOtzXFfoYdL
	2tIlv0OEHOM4U6cm/PKWqmgGj+6Qkm6SCj65nNYhf2Q+NZSoRSTIYqENvN21jO/5ULBJkL
	eioRWDAnfp5aWjH2ompgpu3ODsCF348=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id C9CB0601E2;
	Mon,  1 Sep 2025 16:54:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6DB8C4CEF0;
	Mon,  1 Sep 2025 16:53:57 +0000 (UTC)
Date: Mon, 1 Sep 2025 17:53:55 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Yeoreum Yun <yeoreum.yun@arm.com>
Cc: ryabinin.a.a@gmail.com, glider@google.com, andreyknvl@gmail.com,
	dvyukov@google.com, vincenzo.frascino@arm.com, corbet@lwn.net,
	will@kernel.org, akpm@linux-foundation.org,
	scott@os.amperecomputing.com, jhubbard@nvidia.com,
	pankaj.gupta@amd.com, leitao@debian.org, kaleshsingh@google.com,
	maz@kernel.org, broonie@kernel.org, oliver.upton@linux.dev,
	james.morse@arm.com, ardb@kernel.org,
	hardevsinh.palaniya@siliconsignals.io, david@redhat.com,
	yang@os.amperecomputing.com, kasan-dev@googlegroups.com,
	workflows@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-mm@kvack.org
Subject: Re: [PATCH v6 1/2] kasan/hw-tags: introduce kasan.write_only option
Message-ID: <aLXPownoCikoHvZP@arm.com>
References: <20250901104623.402172-1-yeoreum.yun@arm.com>
 <20250901104623.402172-2-yeoreum.yun@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250901104623.402172-2-yeoreum.yun@arm.com>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 9DD19120006
X-Stat-Signature: zx7ojkk5rq5ifii6uikpw7az81adqxyb
X-Rspam-User: 
X-HE-Tag: 1756745643-80327
X-HE-Meta: U2FsdGVkX1/ql2nCgSaZIBgqcn98qelrAzPJvY/NEvAGtiNftgBYSSjmGQF4pzjzg/FTjztR+2POlYgWALIsgw9lQkPWAa74cvDMnsG/Ncr0c90YbONJ2lmfMaXtPHeAbP1rAzUkjbLvH8Dz+Gn16QKyCtcoo15alsjXKuUxoleLbfDZBf7YpIGMnyZ9bhqUFPEn/13OjWoCmzkpQUo8jlCnu9CFmEPOj9Lucafs8ODqyAI+4GEzkLX+SGYzpauGKZQwyfX9/G1pBH2DrkWJnzxd7CVk5WgQz1x/COeGp3jv1+5RGvKsCYkyEw4LDwcXdOJFcD8y+mdKhglJpDvNfdwKsfrrdU4uCrB40tITtnki5UN8iKc/X+k4b/Y1e9m626htfd7TsR4kjuhYyDD3OvWHNj0nc2TMyGLGpA+0Khy0vDZV7QcXRxb78WSZT/IPXFyqLxmOzPpmlGrx23PEI/Me8+dP6GLuOXFYEUJNZTK9LEOLZxSsAHK0unqzHYSAbSzELxOdfLO4XBO9/Rl4j5Qy/O24K4dShv4xKPmb+jKGzWE2wzV9sn9pySVLqguL8/Bx1fOTZ8BvWrRabiQfA+Ivb2ata6SJhkqKc+qaF1i6VlQ+l7yvzJycUTOrKMliOjxTg/ID6d1D/f5QmsUAf5M59iWyCtwp4VQhuE9ilm9GiQlIL4WivBUEBL61oVY50Zm/UWymatgYq5pNv61AoivXyEc98w+d/ZFgbVlBd/jFVHstg3dWl9tunSf9drjkg4UX5eaqaXLqk28k72ga9+MyjFWTxLrUJeBFVnYvHKFdvUwZgJeTPFM/Dlb59L/+S/yiWC9BcQY+ewGEbbx3nNEvtTnyhX0WZ/v4n6Gws/dpMJsyPdFZgxYEg3xp3A41fnC3SDlsLOGIrMzPOd+Y2Wy+ElWk6FIFkNLFky2/4VADWBYweSg9Q2eQzkJJBOXfURv19ejdJNfIni9wqKa
 29d/3vWu
 X/yaV0VhsubZYX1lzwbF/KnBC7COJTMsJ0flsBhw07Uz5dMH/8uJZF4VWQ5DKnLRYzfnHfqCGOblhaVGqi5QrUHqaOs+qAeXu72az0RXQJP+QvRjI8eGSVdcUAfvGqKesFFVo5ZjrKa6JkSffDjDi8qu9w6dhOQzCRUCRDIMpha0xbTjIGsNfMjK04uiYyzje/UWS
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 01, 2025 at 11:46:22AM +0100, Yeoreum Yun wrote:
> Since Armv8.9, FEATURE_MTE_STORE_ONLY feature is introduced to restrict
> raise of tag check fault on store operation only.
> Introcude KASAN write only mode based on this feature.
> 
> KASAN write only mode restricts KASAN checks operation for write only and
> omits the checks for fetch/read operations when accessing memory.
> So it might be used not only debugging enviroment but also normal
> enviroment to check memory safty.
> 
> This features can be controlled with "kasan.write_only" arguments.
> When "kasan.write_only=on", KASAN checks write operation only otherwise
> KASAN checks all operations.
> 
> This changes the MTE_STORE_ONLY feature as BOOT_CPU_FEATURE like
> ARM64_MTE_ASYMM so that makes it initialise in kasan_init_hw_tags()
> with other function together.
> 
> Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
> Reviewed-by: Andrey Konovalov <andreyknvl@gmail.com>

Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>

