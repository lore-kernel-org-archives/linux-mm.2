Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E6A24C44515
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 16:57:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D94A46B008A; Mon, 20 Jul 2026 12:57:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D45886B008C; Mon, 20 Jul 2026 12:57:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C5B686B0093; Mon, 20 Jul 2026 12:57:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A08656B008A
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 12:57:24 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2AC9D140238
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 16:57:24 +0000 (UTC)
X-FDA: 85009760808.13.5245053
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 86C3B180008
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 16:57:22 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=igrPVqBD;
	spf=pass (imf16.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784566642;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fw+3DqEg6mkspJxmUkbqf+mdDaZyrEi0PQGmGu5K/Sc=;
	b=NyoD3RouPKgLOh+gUo2ztEWj4DFLqpzl3pgh8NO0u1ovL0wqdyd7YJqq3UXd3d05CSPcci
	kwVRvGp2mJ3W+z/cmGsoXaHlyf/1wuQCGv5pe2Bw0ms6lDiPyvvN9pE39JgZljJvZH6xPd
	jDHTOHEh1Bo2R2KSPMPbWV4I6EA+meU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784566642;
	b=XzTywl7lFyDY0gjVrz0GlF6Wr4NNrNmL77oEKv4aFv7QFPo7Xrb1iDAkgZNmpHNFfqsv09
	vrRh7v6ah4TMRN01nXj5eTpaBgQ4P2GCmzqC1R0S5+3wS6r/Bk9g8DIUN/d5uLxHu0mmSq
	I8E/TMBe+ZhMGFdupyC8T6iWf/JRqsU=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=igrPVqBD;
	spf=pass (imf16.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1F7EC601D9;
	Mon, 20 Jul 2026 16:57:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EDEC1F00A3A;
	Mon, 20 Jul 2026 16:57:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784566641;
	bh=fw+3DqEg6mkspJxmUkbqf+mdDaZyrEi0PQGmGu5K/Sc=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=igrPVqBDpEaPBI25WLKbX5c17QyJntJ8rlSrExAtX1F7Ud326aJP1Bq+NdcpBFoMh
	 8OZhdDyFvqi3oN6Caq5pr9rBYe4xyCs8cfzohHGr0QJRL8977tPS/MXhMfv2YQaMBT
	 vz1W+NA0byWf8ZPbClJ0wEhi0v6XmIQuAGI2MvMEOB3rxfEudj3QoCu3hTU1KUu6bT
	 CBBkzA0xx49NS0aU+Cbzipph/pYEKk97u+RRAOyLKzY7Hw3qGwWcx1rWfZin2Ehjxe
	 yFL34AQ9/fIMswoUcdAyvBMDdhENzc4kGZrcdwPP0fiaJQYO547NZ07KrG+442Vwdq
	 HDJh1wEZGE/eQ==
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [RFC PATCH v2 1/2] kho: Introduce a helper to init unsplit
 pages
From: Mike Rapoport <rppt@kernel.org>
To: Pranjal Shrivastava <praan@google.com>
Cc: Mike Rapoport <rppt@kernel.org>, 
 Pasha Tatashin <pasha.tatashin@soleen.com>, 
 Pratyush Yadav <pratyush@kernel.org>, Alexander Graf <graf@amazon.com>, 
 Samiullah Khawaja <skhawaja@google.com>, 
 David Matlack <dmatlack@google.com>, kexec@lists.infradead.org, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
In-Reply-To: <20260713204935.3069000-2-praan@google.com>
References: <20260713204935.3069000-1-praan@google.com>
 <20260713204935.3069000-2-praan@google.com>
Date: Mon, 20 Jul 2026 19:57:15 +0300
Message-Id: <178456663513.143128.13731300065093148388.b4-review@b4>
X-Mailer: b4 0.16-dev
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 86C3B180008
X-Stat-Signature: tik19r7o4xnu5m8d5i6owaoyadwe6eb7
X-Rspam-User: 
X-HE-Tag: 1784566642-879191
X-HE-Meta: U2FsdGVkX1+Q44zr9yACoibGY67OfDsmv2VOLlBqwwvYSZDY7IkOhDRPCTwNjdx/g4kr5QmekwpRgLC4onD9ZBAgaYA226SAjTPLvw7nfxeYcysfC89bhZI52VrRaGhUsnHQrsrbLQ9NZTIeIphhFgVxa4Qu/DEZXXpmbbtNyfnL2QVAH83GlaBEM1bMgrUJcpP7kK7JiWAJonRD8da5uYDVE/zY300DaUPst4NruqLvd0eHLyBwLBlspd67MAtYgcAeG9IotQjZZUTadaGw9zVM0gW4v1DPUynGA262U7wa3ExiuJJNrRQLLJEt1f3hRhb3kQUKIdl3VhSlchS8jOQXSrTPqjEnRytuUP0bgv0aA69p6ydojgNcmATYjY7ext02SEz+frsgVQf25e5frBmc75tNVLyUdfV2CW3YIJ/xFY2ClwGwjI+r9wgzBpcDVLSFLzYc+9y2mesI9Af+GfWkflPYkwu5W2uxDuDN/bHbqnHt2gsgMkCFxmn3gsMyRSVe4gELU/YfrOi+mLIxKceBSegGzTgvaa5V7L4X5KN+t2k96CArlt/fqWzEA5MTPXUBV/hIk2d2tbO4vbx4W/+YkgqhzqOsGSRvEULszZZzZuj5vffHG9+i2o5eLrjsD4d+ScyrltCmzyWJGyrdM06aHllcWWuNjAraHhGMFafmPIvPeQ4XJNG2zinZ4N2bFyDivMJWowwMT85rhQh1TKTENzJRyMa/53vE+F1KXlQHt+hMm4t2FD7lTgBPaQo+Zwk2l1d1OSwbprzaXGcDbgATAz1gofzzm31FKWVOS6cCIFTXvxnTNBm4bFS07xOYQRUH85yr+9HsZoxaM3SXZcYUEChWpfks3jrr3L2s35g/C0sy4aQxq5Vic+qzMvNT6MazGekyNVtzlP3TKU3g/d6hP4Ft7i4izDc73X4lVvDfQQ1KQ73hvtBaONsnZ3sYycJGABc3g7M8vuwSh/e
 1IneN5an
 hQTug25k9cQyybGsb08RH7O9rHW8XkWAzyyB1Jc0hzVsCNlOLLra9EL9BUskQT9g5Zwt2I4jPrPpDuQA81nY7pDyvfwA2qgQg2bJNGGbx0LLpebs18Hnw2k4F3pp+S+XOtW74s0O8wqv/BV2R/qVxbiG4blxINULLuOm4Ym1+1VJRsOxQh+le6U0N2ZWDzV9fdpH1j+vAWsNEboOtjkfl1io3wHYuuVzaNmZq5CQtQbbBITc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> The current KHO restoration logic assumes all multi-page blocks are
> split into independent 4KB pages. Break out a helper to prepare for
> supporting high-order non-compound pages.
> 
> Extract kho_init_unsplit_pages() to handle the refcount pattern
> where only the head page is refcounted. Use the helper for folio
> restoration that requires a similar refcount logic.
> 
> Signed-off-by: Pranjal Shrivastava <praan@google.com>
>
> diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
> index 4834a809985ab..07f6f453cd69d 100644
> --- a/kernel/liveupdate/kexec_handover.c
> +++ b/kernel/liveupdate/kexec_handover.c
> @@ -357,6 +357,24 @@ int kho_radix_walk_tree(struct kho_radix_tree *tree,
>  }
>  EXPORT_SYMBOL_GPL(kho_radix_walk_tree);
>  
> +/* For physically contiguous pages. */
> +static void kho_init_unsplit_pages(struct page *page, unsigned int order)
> +{

Can't say I like "unsplit". How about kho_init_high_order_page?

And whatever name we pick here, it's surely must end with "page" rather
than "pages".

-- 
Sincerely yours,
Mike.


