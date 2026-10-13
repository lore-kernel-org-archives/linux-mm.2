Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 57B14CC6B03
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 03:33:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 37AA66B008A; Mon, 12 Oct 2026 23:33:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 32B426B0095; Mon, 12 Oct 2026 23:33:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 21A866B009B; Mon, 12 Oct 2026 23:33:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 025A66B008A
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 23:33:01 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8D3F8A8D42
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 03:33:01 +0000 (UTC)
X-FDA: 85316181762.04.532AFEA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id DCF7120006
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 03:32:59 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=ZUm3UzW4;
	spf=pass (imf31.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791862380;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=81fEEjV6Pw59jq+VLLeeVEQCDO76zTf5RtbeOlr3HpQ=;
	b=FfivaVvGFL2omGo8GEcPvzlui2x0tdCLGADXOIlLohYrYydaRjIYtTScZhM9Staz98ijtE
	EYF9I8Ym0DGipdfE+9xFJ8dcXa9rKa7Qa7hjpA4hBdD4AYpZM6pFZgAH+eZe0ZCdq48xrW
	JCanA6Ef/iwy6p2dW2b3cAs4qGQRZwE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791862380;
	b=CncDEp+oNKR0ZgKgLu7fwCRSdxMpumgiJYtbHlgl9B6Mu+IrZ69m0iRRcTgtD4LiYk8anH
	lQEqHx4fRIAZEQLTPqloWCT3rMdubpnT25yOtt12OgoyUvCEV1G/pg2k4zJz520vOSkew9
	596cuwimAIAfLyIiCETj9T3jLAMvKC8=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=ZUm3UzW4;
	spf=pass (imf31.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id BBE2F601E4;
	Tue, 13 Oct 2026 03:32:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C8791F000FF;
	Tue, 13 Oct 2026 03:32:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791862378;
	bh=81fEEjV6Pw59jq+VLLeeVEQCDO76zTf5RtbeOlr3HpQ=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=ZUm3UzW4c/NlvVoZhyu2MgDxUbbhAr8AJrAjLwu8YXKO8/RSaAa6qwYHsOJ3md2hW
	 iOZKBXnAVv0Z/fbcMuZD3b6ZaMA7FWHpGOnyax6hMrIuPOvxFxlp5Sdnf1vH/Bc+vh
	 fqvRK3Y87Emfm37vddpqp8py8sBhpx6cR2snUENg=
Date: Mon, 12 Oct 2026 20:32:57 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Biplab Raut <Biplab.Raut@amd.com>
Cc: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
 <hsiangkao@linux.alibaba.com>, <terrelln@fb.com>,
 <yann.collet.73@gmail.com>, <guoxuenan@huawei.com>
Subject: Re: [PATCH] lib/lz4: add software-pipelined prefetch to decode fast
 loop
Message-Id: <20261012203257.614d88c12146544aa6487b4d@linux-foundation.org>
In-Reply-To: <20261013032010.2453893-1-Biplab.Raut@amd.com>
References: <20261013032010.2453893-1-Biplab.Raut@amd.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: DCF7120006
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: iiewmhejbda8h34zdfxywddqxtrsk1p8
X-HE-Tag: 1791862379-59083
X-HE-Meta: U2FsdGVkX19FLlymobJA+vq1Xm2YS94s6D07D4Yk/jk/af0d+hUXpBXx34fxHCb9/tX0MmeVH9kKEaGuEMC3I+k7ZwpKyl3bDfmXy0Rg5PKZEzOOkp7E+1VU2T2ios4EOVEKwmov873A7tx+FZ0h8mAj0Df9YYP1FzNioN4QzcL2tvNGEqYgtBV/eMwdv2vy7qdyYjXD+xQrjGFPgTGavdBSEeFHasPu2gMu+VlB+565jAZP0T6z8/igfsD5hQiRddtGMYbZKpdzYTNAH4IgQJYN5NlvAhy/V+X18cjjsStMwnrnw6z30chfPd+AJNWaEHlMZ2/7OzqlRL47Wm5kWV7JNC7uLAewONMeIxP0TQN/B3yZqlo+Sn5AYS6HRBkG8NmPxVv50EUyd5dIc28TZ9MBhmPWt9ZBHKRn0lVpRjug2hkoHgLiHEiwlrvqGuXUsAlOO+701afj/M/Zd4y+G4CT72qdKjDPKa0WO6cO0MGhbok4ewt2aq7abdL6Ry1wtlmYEsJlgveFI1j83nVJyoG+PN/yrBASex7n6fSYIH6T7wUmOwTv/qeigAV56tNIzt/o4a/HfCLnv8iJnw6VxAy52j6rjwPgRwm0tqYUu4Dt8YITWpSv4vmW4vRc3eftYEJ1KYK/fvcwbdb9FPS7TpKrDTUCoHBZTcrln9lWnwqT168WW41/72eQ+/MEPWK2yjsAmkL1KgB8qtPSQpeTeEabCFbBo4SFqLYjONo6ye7kb5qdO+DS9VVDeERiSSt9Q3z0B2xWXiajbTE1ccxJ4WdLSfEyqGXV4lNGiEOTPaX1LY+hrvJYyEET7zZz+HZh0lEWAS/BCR3sJ2x1iQVx/rCvJsV+veDurCAs2ksOh3HKchxFCB8dm5CpPE1cpqz/pR7pbPnflk5qsxWf6+/B3cLKppkvN0KTF1HzAfNGohdAf63HEURtjVYwSBJQtfkP04EfiD3BvpAaK1zojjM
 2OXDNAh1
 te70ApvN2Egj4Lw19bkwJULgKIeDiFrhktb+HSQ/4JLwaCaRjkO2Un0Fsuvc+/VsiTbHTgVtnRUDV7W4KZGdL0vcOSrtx5P/fnRbJd4o1F9xk/oujVEXO3nwwrnSRcXcMrOTmruQvDFNG6r1ZtCcdtnDFqc8ahvf+vuoP+G07LF+ti90ydd8UPG3FbqXRPqxsxFnNtooeBU1IEpJgrw4q9qiaBKCGoGfhv5XsuHztIYmAhy3CgyJzEGITzGX5jddZHZZ9JR5efHueSTCWkEGZgkeg/BxrsWDyNFrSNmI4x2M1zA182HB5nKsgFzQ4e6e0J/La2eBiH+ILfoWoeMRgI0qPZIe9GF82Cda4hKMo9daw2s43FHXPLAB51w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 13 Oct 2026 03:20:10 +0000 Biplab Raut <Biplab.Raut@amd.com> wrote:

> From: "S. Biplab Raut" <Biplab.Raut@amd.com>
> 
> LZ4 decompression of cold 4 KiB pages (the zswap/zram hot path) stalls
> on cache misses because the input stream (compressed) and output buffer
> (uncompressed page) are not resident in L1/L2. Insert read-ahead and
> write-intent prefetch hints at the top of the decode loop in
> LZ4_decompress_generic() to overlap memory latency with decode work.
> 
> The prefetch distances (96 B read, 128 B write) are tuned for the
> page-at-a-time workload where both buffers fit in L1d. Prefetch is
> architecturally a no-op hint on all Linux-supported architectures;
> it never faults, never changes correctness, and compiles to nothing
> on targets without hardware prefetch.
> 
> Measured on AMD EPYC 9755 (Turin, 2S×128C), Ubuntu 24.04, kernel
> 6.8.0-90-generic, real zswap path (cgroup-constrained MADV_PAGEOUT +
> full scan-back), Silesia corpus, 15 paired rounds:
> 
>   Kernel LZ4 median scan:  1.0994 s
>   Patched  median scan:    1.0472 s
>   Median paired speedup:   5.09%  (range 4.19%–6.99%)
>   Patched was faster in all 15 rounds.

Well that's nice.  I can't actually recall a case where prefetch made a
measurable difference, although I'm sure there are such cases.

We used to use prefetches often (10+ years ago) but it seems to fallen
out of favor.  This code is a prime candidate.  mm/ barely uses
prefetch.  Maybe it should,



