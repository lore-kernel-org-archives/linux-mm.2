Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BEB81CD4F54
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 23:40:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1DB6D6B0005; Fri, 29 May 2026 19:40:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1B3166B0088; Fri, 29 May 2026 19:40:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0F0BF6B008A; Fri, 29 May 2026 19:40:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 026466B0005
	for <linux-mm@kvack.org>; Fri, 29 May 2026 19:40:48 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id AA4391C1063
	for <linux-mm@kvack.org>; Fri, 29 May 2026 23:40:48 +0000 (UTC)
X-FDA: 84822079776.25.FBAB062
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id CD22FA0005
	for <linux-mm@kvack.org>; Fri, 29 May 2026 23:40:46 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Doa2M2Qa;
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780098047;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wqG+2yJQhX3QhV/XJDjT22cZXnVygwf7uv1jGGIA8wo=;
	b=byHwXw5lr5yl69jfTf2nlwNnli9neSt/DjFt1T3QPupQ8LnG+pJJyVXkrip+CCKRwmZMkV
	230E2humOTOYs/YZMrNvjcp/zLk54Vj/TlUZm2scqgDjJJ7OCy43ctLSBJmsVck35TGMyk
	cb3Hgp8hixHacWzwxJTAz/+ReC2XcMQ=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Doa2M2Qa;
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780098047; a=rsa-sha256;
	cv=none;
	b=qWOymx+//ZJkVAMC83wshZ7ak/R5pwbfiulK2Tohgtc+0fjyAuQGcFrf/uraIUVNfEqE3Q
	WIrZzZXewwkt8MCMtRVRTKo2DJxohcsQmmhup975iyhL/R2t/6DFTvhC/lSnk65B//lKFY
	xJHNdXqXamd/GO+E9GpIdpX7ZSj4JZo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 595A044590;
	Fri, 29 May 2026 23:40:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 864E71F0089D;
	Fri, 29 May 2026 23:40:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780098044;
	bh=wqG+2yJQhX3QhV/XJDjT22cZXnVygwf7uv1jGGIA8wo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Doa2M2QaJTMnV1NU8nm4lmlz/+tfEfm+WuMuK1PKUAmocD+JvBdI2ZbJ/Ro/t+oS7
	 tGEYZwT7b6a5pUC/wWo0nkhtuXq+rMLVMX0UaYp48QHiikO/nkdIBrIKnvHDe+/28b
	 S5BgB76t5PisQaYK55ECIrc2dOwPbhSI+mOZXuW7op5xec1xe+XW27hvjUIVWWRoQY
	 3jfS8lVNRIezTsNRk1nbXCqEktLkl4Cbj9kpS5JHn6FxkK/fzYes0LvjbfvVKopgon
	 Qib4FHagEy7N0GLDTlpJKm+5zdfgWbmfaOOhw/yT45bjbVuEIRbw/ZjYmAsi2iulNz
	 Ix4Lm/p0JOMPQ==
From: SeongJae Park <sj@kernel.org>
To: =?UTF-8?q?=EC=B5=9C=EC=9C=A0=ED=98=B8?= <dbgh9129@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1] mm/damon/stat: roll back context on damon_call() failure
Date: Fri, 29 May 2026 16:40:37 -0700
Message-ID: <20260529234038.87184-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <CACrCO_Xend-ivqq6TZ3GDhfTm-JsyoYJQjgNa5pdeU+5sFwKrg@mail.gmail.com>
References: 
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: CD22FA0005
X-Stat-Signature: wprp1gzce1umazzobr8fd8qzz1rd95xp
X-HE-Tag: 1780098046-444006
X-HE-Meta: U2FsdGVkX18RJKQAKnpJxbm94H6hvhsyxB203zkQgVvOMpGUZ1uBr0WSItJj2MPNlyRiMAXAgyH26bNwbUeRB8tUlOKWJE5KAkSL4UUx8RTMPsdQA0sMw9UOMGoyCoWIqDCe2IDH1Fg+2Rz3A1y7UL3mrDJuhDjKAdamPBSMEsHjOi1uTDEjYVcA+zEDOaYM6al1gsuvl9RvoZd6dHaCXiQyP721+xpYLvx5izHmUHRePCwJUw8VeAuCAioqHBEqNKtrWR57Y0oaIm5YkQ1wDJbinuMnczxlkqqJhU/9A2HnzbQHdRRXHZjfWZ9kkf9EEEUT17VCmwqkQ6HclebUM2aEXDhpd7uIJGpS6TERLdQoPBmrhNYms9njZDwZY4uJ/QZq2m8Zdwx8WXEYHL1DheSHzfCUtySNS0PzRbHQmg51icTMKdgDW+RRSm7fvnm9127cRY6FaBZdiqhh6Bw1wjqXe1c0m4wAe52oDPIxuk3uUSxL8ti592g8fkdsOSxdjkJPERI9IBnGS+N5BtoTT7bKgQx5+8acK0nAM51LEHH9Og3N5gsRSdfI3UDDO6qqzwcX7mnlm01W4c4AnY4kN4mml9gKVXnkfdF3CE9A3+VwF7qoqZo+LYbrGmpVLt8GL4MutueQ3rSoZEjHaqABsN0dh91oBWTlJW8trieiEr+kRsE/AeKW/G1VzdRh11ZBdVT2ZIPuuzyBmaNjbqkBFJ6OxHs1Bn0ek7YDDuuyO9ONjFy58LPO+43u0IspcLS4RFgBSnrzWB3z+9OjbZ5zlTrpkBxYpIYDtrrnIccSjrBH/MRek+lZvQcLsg6w3YFNbEWHEQM9mRKwbGks2I6oEsoRNypLBVGujpP2AG/VDrhudFGdZ5KMqr0pG8puWaJM7h3AonW+LuCLAylQr4VIqlKW67TXUY1AbkP9g/cbtFI9/bvdxSOPS/dxP/FhUJ135EegHGw5E8M1PtAawz1
 vxb8aani
 y8Ux9q+7nt2ws1Ex/9BkP6nTVNqJrVXGKwkBEKA5OHeHIMElOC0DIUEzzRL1lghXib7LtAzSTKaAPVaLt5oB8EihV4w2Cimj1a78siyIhcHAzXju6bHbvv2+/F44p6LVS3I3ZxwJ7ty/2Meuw5xh42l85VKrPMJRI+WudfbRj2ffCehrhCtseyEn4H0N7xkJ2eQG5K0WAVe6PG0xArKmhksPTCV7TKqiKH9pzTjE1PBD62jM7q880eoyEvKqdo2b3n5fwsB2ratKXgPDaHpAXG+ePTDKY5Thi0NaLwx+xlJbR1FlcXrCwrrwcZh9mRKI6ZOMVIrYUxdh3YdDDrrptMffRNQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 29 May 2026 16:29:44 -0400 최유호 <dbgh9129@gmail.com> wrote:

> On Fri, 29 May 2026 at 12:00, SeongJae Park <sj@kernel.org> wrote:
> 
> > Thank you for clarifying, Yuho.  I think the current cleanup is ok, but I
> > understand it is confusing to read.  Apparently that confused you at least, and
> > that's not ok.  What about adding a comment explaining the context?
> 
> Thank you for the explanation.
> 
> That makes sense. Looking again, I noticed the same retry-time cleanup
> pattern is also used in lru_sort.c and reclaim.c, so the behavior
> seems intentional.
> 
> I'll send v2 patch adding a comment explaining deferred cleanup and
> retry-time handling.

Sounds good, I'm looking forward to the v2!


Thanks,
SJ

[...]

