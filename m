Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DF41BCD98C5
	for <linux-mm@archiver.kernel.org>; Sun, 14 Jun 2026 09:20:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D89476B009D; Sun, 14 Jun 2026 05:20:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D139B6B009E; Sun, 14 Jun 2026 05:20:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C30846B009F; Sun, 14 Jun 2026 05:20:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AE12C6B009D
	for <linux-mm@kvack.org>; Sun, 14 Jun 2026 05:20:47 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2758A1A0668
	for <linux-mm@kvack.org>; Sun, 14 Jun 2026 09:20:47 +0000 (UTC)
X-FDA: 84877973334.11.E58B6B9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 938D7A0003
	for <linux-mm@kvack.org>; Sun, 14 Jun 2026 09:20:45 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Jd0ax0pZ;
	spf=pass (imf15.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781428845;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jfnRHd5Yrh42NqlaThzTMtQX1FZRWVJGBOIMDcQKQys=;
	b=3vEM0OtLTztDrSzB5hKitt096tDzJRIqIt+9hKy/LRIqGaGx1oKET4CoA6Y6WHijsjDz1P
	QQ7egZO2YGitPnNkkCIH0nROKMW+ep6Eab4cw6hfAuPco1B/NTG93bgXmW5bbF7Qcqggxo
	brbBIOFkJY1tlNN8i2+tQSaG6mqhTRY=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Jd0ax0pZ;
	spf=pass (imf15.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781428845;
	b=z2LOfeDs2iy/OjcQSQ7gxwdikBGNz+fsuALJySDSn2OLUs+DSvwND8FYwqHT4HA70O8IzJ
	+zV6Fv/SDK0nr4Mut1H9bXH2VphnBcNffsZwvE6Ul5sJcHxHD+VnAgxI+lCzrq/4Cv0D6/
	4a5RjjJxkDv9LcOotCHPvWG55LFKwFY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id CC9E44058D;
	Sun, 14 Jun 2026 09:20:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 010561F000E9;
	Sun, 14 Jun 2026 09:20:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781428844;
	bh=jfnRHd5Yrh42NqlaThzTMtQX1FZRWVJGBOIMDcQKQys=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Jd0ax0pZos8vM/cT6h3tqmuvBhokhbPiuG78ZaY1Fboi1lHAXCT7PvAWfR5sETJkW
	 a6Le/DUi9vJ4WrNo/RxmMgfx/UiT7IWrO2T9ut+CY/Vsf08qdmihqnZlLk19t04r2L
	 c86xCwlDnrrRKRr2CmFcgSCHmrWIOu5zagFAlLx68u0uX5zdt7fruHcDTCJTRe3EsB
	 WCLiL/cnEpKju4MoCnibYzTLQyeE0gf9brggWwfjVDxfH69HdWWJ/M/nq8Ru8ow0pd
	 2LFTQGCe0QYfL7Sy7b/gszdvkQAvz0WN3s8Uoq7yOVPfeFUfJqppJH9FFq+Tx1s6Nt
	 w634YnFNIj1Cw==
Date: Sun, 14 Jun 2026 12:20:39 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Zhen Ni <zhen.ni@easystack.cn>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/memblock: Remove redundant pageblock_align() in
 free_unused_memmap()
Message-ID: <ai5yZ2AQp3gI21xv@kernel.org>
References: <20260612031105.3350181-1-zhen.ni@easystack.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260612031105.3350181-1-zhen.ni@easystack.cn>
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 938D7A0003
X-Stat-Signature: wuzncmu53trtqkrghw4muhab9z7t8mz6
X-Rspam-User: 
X-HE-Tag: 1781428845-243662
X-HE-Meta: U2FsdGVkX1/wzogXp6rpQPpPJCObP8v7sqm4SAnVeNewOWFNtJP2m1bx4l+B9UQomflHaEsRGzcfUCJR5KTr/TpglkOhBy9Di532ZMsoNsFQIKdO/Dk6uGyqryxSe3MmUj+KgulGXCAUtDMngUQSNc93FNKrmtZpkiUsDECkcvB8YULVFPAsrRbEaGGqUd8Eqpcgbu5RQ2hPviiMcSfRF8oAsjTqKuNP397vzVap+kOvO8T/x7uYWUMvCUDo3r35zZUIcATGGjZz/UvNNc9I1yXuvTVtInscajijrIKWc72eVKeg/qk1b41bAWwEeUl3riQCW0Y6YU8xfNMaJeJXugxr0jmD7dkbPwbdCekFALvHOUZJpgecLSIBBce38AnhH0zNaVfDlQowbm4NXmDoX0sRZIm54Py9rGHWifIP6QWWWFWxr5u+x6q1dzns+VbJ3+pSH9885LuW1P9hOEiFjCAvoAT2qvVIL7hv/7aBLoa+Pg/Vst7mWFDOIaL1GPxJvsW0fCvn5WIP/rd4NfF64Tf9/sKEPdkM7C8nCGD/y8/bnWTrE9v9P2jBbqKqC4jl9U+/yQudWcPLnCLJdpnH1HAkMm5HRyCMMmtu6+OgbfDjLagnj+Mh3rpBDpfcbOoD8Y0LzOThJzn5vktnW9m2S6wRe4CMvAjWWvB2urL6DmSlZu197Yc0+k6gRb8oH/n+ZlWhNP7AGAr3GwVUEGYxj1PBNJMhcz420L7hSozaEyI2TUJdYU7mkEhXN72jIlw0m53almxHD1PFmxaIgevuA8OduY+0Q+7ANDqdhv00lEUtHYqUYGFXrvAC7fqA7XmUWdD5RHuDj30Wh41HvP16KP2Mrv9VAp+m+uBumPZcaxJkHRm2IdJaKIut86X2a65DfAfg0MRpjitijfzLSXapoyN2hVupBHCTnB05gdieiAyrvFENa8lboF6lhSVG+x7kvrJ+gInrj3yu7P0nU4y
 uZSG5vLD
 h4nhVaZNrnj7BeSYCjQlM9sMVyfRj81Fe9nUwHLdt7c81sNif98NbAoGqRoM8IJVlT4xLFLQObJzhUbcf46GfgOZMOo1WWqgSXfYgn+i2e4RBROphswsejPVis+ffFNOM8CzGHaopi2EkNdY1REGd3iLpS1a3a+fQjGGOQ0hmz3rex4GApuvX6ZOyYHYzC0UfoDVCX21l/BTULxYPoK9xXGEhYWVcNUszXCQBFY8n3gIbupuYqXoU6bNSdrID+nej94ht3eQzt3t9w8pBvmnHfCohjKPvFDS2OX6yfRRS/i/RVog=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jun 12, 2026 at 11:11:05AM +0800, Zhen Ni wrote:
> The assignment `prev_end = pageblock_align(end)` is redundant because
> `prev_end` was already aligned to pageblock oundaries inside the loop.
> Since pageblock_align() is a pure function, calling it again with the
> same input produces the same result.
> 
> This line was added in commit f921f53e089a ("memblock: align freed
> memory map on pageblock boundaries with SPARSEMEM"). Remove it to
> simplify the code.
> 
> Signed-off-by: Zhen Ni <zhen.ni@easystack.cn>

I queued it up for after -rc1.

> ---
>  mm/memblock.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)

-- 
Sincerely yours,
Mike.

