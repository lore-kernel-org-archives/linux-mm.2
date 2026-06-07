Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2D8FACD8C90
	for <linux-mm@archiver.kernel.org>; Sun,  7 Jun 2026 20:31:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 23A606B0088; Sun,  7 Jun 2026 16:31:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1EBB56B008A; Sun,  7 Jun 2026 16:31:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 101B46B008C; Sun,  7 Jun 2026 16:31:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 032A06B0088
	for <linux-mm@kvack.org>; Sun,  7 Jun 2026 16:31:27 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9F2C9A087C
	for <linux-mm@kvack.org>; Sun,  7 Jun 2026 20:31:26 +0000 (UTC)
X-FDA: 84854261772.14.A81F82B
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf05.hostedemail.com (Postfix) with ESMTP id 97A4E100003
	for <linux-mm@kvack.org>; Sun,  7 Jun 2026 20:31:24 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=tUnZicFS;
	spf=pass (imf05.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780864285;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pbV17znVHflCYA4hpHF5VsEyW/rLnWQIwsr+cO/SJlc=;
	b=32PU8tdfSgszDQ2vp0cWrYyuqN2Q7srGH09YhdXeyCNNLeLEEFBO393j/7C5eDdKiedabQ
	5R+yWyTytyGa5y4TFZ/VC89+yfMpUcTC8NgeZTxkFTOeiAQpfUMQ9fl6tudUy0drpGsRzh
	40X3U6p87QVIiXTm1vBFi5GMOYjg5zU=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=tUnZicFS;
	spf=pass (imf05.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780864285;
	b=0ryWzvGENtp1EUZdCcA8qP9/6uyMTjCzEmWd025qPLODXBV4/jyf5oosXufJE9rzD0Abpk
	ddQeXURO3xAnhbUoMQM+C9jRehYYKts5I9E6Soyq/KCIytI6c7rdpmm1OA6MWnaVsmM+RT
	Vt3vhCXNOFSTdAUEUETgJvWzglMgjeo=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8CF252923;
	Sun,  7 Jun 2026 13:31:18 -0700 (PDT)
Received: from arm.com (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id DA9893F632;
	Sun,  7 Jun 2026 13:31:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1780864283; bh=vedSbHWVWJe0Ke5/QRNqJHVEboPffZIfJ0Z8nUsS+W8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=tUnZicFS6DDHwNp7DB2mtYFmNTdq4Tex2cDVTJRe/IxGJoy1g3goY3hNlCLRaWfIc
	 zl3fvjq3Duh1oUMdlU3D1WJbGPFMB1sv7OryckcWhUBYTL22ot8PfWqXCKv+AbDVo4
	 CBpGXbIjmoScDJVn8NQnl0jwiy7Ex5RIv+iuWHO4=
Date: Sun, 7 Jun 2026 21:31:16 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Tejun Heo <tj@kernel.org>
Cc: bot+bpf-ci@kernel.org, Will Deacon <will@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>, david@kernel.org,
	arighi@nvidia.com, memxor@gmail.com, akpm@linux-foundation.org,
	rppt@kernel.org, andrii@kernel.org, daniel@iogearbox.net,
	martin.lau@linux.dev, martin.lau@kernel.org, eddyz87@gmail.com,
	yonghong.song@linux.dev, emil@etsalapatis.com, void@manifault.com,
	changwoo@igalia.com, clm@meta.com, ihor.solodrai@linux.dev,
	linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org,
	bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH bpf-next] arm64: mm: Complete the PTE store in
 ptep_try_set()
Message-ID: <aiXVFK_qb54is8b1@arm.com>
References: <088f52fd25860ca961449d53f91b214a@kernel.org>
 <5f68f44310d4878185fd5ebc52d66530b99f174c6d04ab1170dc53cefaa54568@mail.kernel.org>
 <1780862659.ccb18e27e916dc4b@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1780862659.ccb18e27e916dc4b@kernel.org>
X-Rspamd-Queue-Id: 97A4E100003
X-Stat-Signature: x3ohbznj84fn3p5wdsow9oa4xex1dfix
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1780864284-627986
X-HE-Meta: U2FsdGVkX18uNqLc0hmpiOSW3HK0zzqTI5vCtemruh9NNFaOdez2hQ5huSAe0m6M6TpsiUeOWc/irR9KV5eG7jtpqLbKnrJRLRK0iuXO66rUBPNHPBosTBCBCk6rIbw7nEE68hx3HWCprURKhWoAtgtLlPe6nS6i4Qm/zio+OHNk/kZRRznL1/q7VJYxkNDq7laTzprgmOKlAZJZT1SLtq8iThG0U66+Gv/UKXJalLkxi29wQg+OMFStivYHaV6FIRKl92pkzKEEcKXs2aFAI/2ih9MR8vTAu7xVhVu+9CkH+tyBAcMjil2F7GpbtEk6cqPtwKb2wKCgGkB2A4OSa31UtFdd7hv6I/9ikpuWLx62KFwcXumpPJtEwLfdfcBK2Wk2eal9pxmJswjUaTUJMBVjykeJ+WpkH2C5gTDsj/uT0/sV4We42vuH5emBgKCwR7iq7MBMtlFWoJ3KDogh7Utwqz51k+VVZt1Mg7dqXfldBHjSbxO1Z0GmGsBDcub6+TBWTZgl3u9H3eulbpkLbMsC/DzGqa1NpBuuxem7lLRLf9CK98hLzxhz0ogY1p+NyrG4YDJIea78H2P1HDYIFp7lYVVvtFr4DSuZ1e0zp1xWY84zOcuHIvI3CIsh5+3/cZi3OZzDvXXDkbNEXMFRsIx9JzUAT4m0icFT4WNtpODISdqqepynTwlp0wX65lyvJGA+5arQmGilQYjBYl9HySCGz2s3sRDIkRfc8axSPFMoT5tySjZ7hnOZVTyMy/3bBPA5Td0zF6wgzUvHYx4qHEc06OIUL4/plJnmAjWgc6puRPznMhzQZVFYi3qnrvQhwij9I1Mihlpy59++dJhCGq11dMgnyR2mbhTRfNJiqBTIx+5yIzk440pM4oLCO2SH0ETNtatsytnbcOzN6ai+J6SFLEf3H4X7n2+oyq/G5NXUw9zgPzp1sQYxuwqRMVglB79VS3X6cqABQ0Ag2Lp
 Ypv9vjKn
 LPCEvaiPaJUmeNZhSVCoohdkXcoziCRa7QLaTxzt8Y2A6zBhUJv4CaLCGYNs8wSFR8gvubYchEbVBRRZgnR7Y1SyWKFl9xRzRYuiLeGUQdprWXs+Od3QWbCTc+ukCsK6CE1ggZCrusaEwTZKM40tdl6YhF19jf3j1PoazXhVbszG9bYhE12y4wPnZcenJvGdMi/PyticUV/Wey8O9ih3tdfFTlC7jhKCmbrDTh11qYFCFA/MfwCzm3BSRu1N/eWSOULwZaSBq6Ee3yabzpMNTYpdXX8F19ym92DPuHlFsFoAwz7j5FZ9Xef0JZAqWUIs2+qcEGU8bukIJFMB4XMifpXX40fRhYnyXLWYItkf2XnNNJh2AyO0KFv2KOPgufClubPZRhljt7c8TWAE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Jun 07, 2026 at 10:04:19AM -1000, Tejun Heo wrote:
> > Can this path actually loop, or is the deferred barrier guaranteed to be
> > flushed before the faulting instruction is retried?
> 
> I don't know the arm64 paths well enough to say. What I can see is that
> ptep_try_set() only runs as an apply_to_page_range() callback, and
> apply_to_pte_range() brackets it with lazy_mmu_mode_enable()/disable(), with
> the disable() flushing TIF_LAZY_MMU_PENDING before returning. The barriers
> would land before the access is retried. It also looks like the same
> queue_pte_barriers() path __set_pte() already uses. I'd defer to Catalin and
> the arm64 folks on whether that actually closes the case.

I don't fully understand the BPF parts but I think the bots have a
point. If a BPF kprobe fires while we are in lazy mmu mode,
__set_pte_complete() will defer issuing the barriers.

I think better to just call emit_pte_barriers() directly. If
ptep_try_set() is always called with valid kernel ptes, we can skip the
if (pte_valid_not_user()) check as well (which was just an optimisation
anyway).

-- 
Catalin

