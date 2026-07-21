Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 641F2C4451C
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 12:02:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6618B6B0095; Tue, 21 Jul 2026 08:02:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 612D26B0096; Tue, 21 Jul 2026 08:02:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 550966B0098; Tue, 21 Jul 2026 08:02:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2DB906B0095
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 08:02:12 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 93FAB16012A
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 12:02:11 +0000 (UTC)
X-FDA: 85012645662.04.4904B1E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id E7ACC8000F
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 12:02:09 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=F1+rN0wU;
	spf=pass (imf30.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784635330;
	b=tTxVfG3ox8E3mcEci9c+a0q/e48F1X/aPItJj1irMmHc3o4ERNYjRGJOj4QHnGNVH/GpT4
	fJ9JPL2FkeKItuuBrjHgYoa0Y54lJoH4HwEw1KFHvbpqhRtVn3azHdxvoF0CaqRxuS4gyu
	+oDMBULCP/R/GAbTMhWShWPc+uYqa5Y=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=F1+rN0wU;
	spf=pass (imf30.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784635330;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PWQwVOyC4A942UEorwwKgtEDycHHifMWAlNig7s4ClM=;
	b=17X1PencYbeu9uQfFdET6BxxlUCPidpQbXohox/gBvFSrAyhZyP6ZysPeRCmA5JtyZBCwC
	1PfZ8kNl1Fe5dDsKqLN/KaOKDCg8z3dfzIsw/y4on7x8Udj/BXJPvsjoEDkk9PbR5szfr+
	e0NAWxd5RtjM4HdfnFor6or1YFfy1lU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 30D9C436EF;
	Tue, 21 Jul 2026 12:02:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 155C21F000E9;
	Tue, 21 Jul 2026 12:02:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784635329;
	bh=PWQwVOyC4A942UEorwwKgtEDycHHifMWAlNig7s4ClM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=F1+rN0wUrIXL9MXn3HHNV9d242TQOMQ0NHQec6idQplYCrDsVhGGwHp86X5FtMDhB
	 RObxrd7QdZ4ZmULURuFaPBplBR9HtE0M11tCu7LYvvXU9WSNvte8aobhrmMHqqnSX5
	 zv+xQ2G7xIDZ/Yd1dJBWwhMnkqnrEqx9ybjXdePzpuMPG27886bzmKpuAAqjqtKMqS
	 Bar1atYjA5UAG27GzX3AtVShWyRzMpKt9PWECVaReKQ2mydzVRkQlTO3JfZOY73UQ5
	 J9zqPKSDmRsQtHeOEOM7O+7K1VmwzRqkCJ4JUBZ/2hQ/jq6c64MkPhWhmFniu6/8lt
	 S5twIP26gm60g==
Date: Tue, 21 Jul 2026 13:01:51 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Zenghui Yu <zenghui.yu@linux.dev>
Cc: linux-mm@kvack.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, akpm@linux-foundation.org, david@kernel.org, liam@infradead.org, 
	vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com, 
	corbet@lwn.net, skhan@linuxfoundation.org
Subject: Re: [PATCH] docs/mm: Physical Memory: remove deferred_split_queue
Message-ID: <al9fmePMPbxj8ffX@lucifer>
References: <20260721111919.22923-1-zenghui.yu@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260721111919.22923-1-zenghui.yu@linux.dev>
X-Stat-Signature: 8m7i3wwea8hpfdaywymond7q1jg4shcy
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: E7ACC8000F
X-Rspam-User: 
X-HE-Tag: 1784635329-92248
X-HE-Meta: U2FsdGVkX18nZh8YWH50uaMffMhcVkQu7YY+hVitS6r/+wosRslxjVUIPk1JvcZELPGeCGoX/lXMK6ES5YVJwqCkbfu30CGAMbNkcN4Od9hVTvgbdgYN4KDOCSjGLnMd0KiHLt+ZqvXMfcdBB4SMvR4vuBhanr+Dc5mOs3r0BM42iiajMCSA6ttl1dAXfFaJL+MfA+9MAW/3K1Kk5YNDuJBS4PfHFHlVhh2pl5W2c0vOOrex8CtRx94+R290N77dDW9cOwJhZSpjbNerKnU88UHdIwSHurP3ts/HNYaAGdYai1t7yhoCTz7V/6vHYGMmDVdIeeq0ylovGa+HU0eqOX3c478oaGn6xlOtmzqyGUWPaRYqocAv5ma8urOm3a25zFlMUJCbbyqHsJskBVHbJCJXCST3n86KCHoxZXkTGbm8Mh16U5zRmAJmk/8ESbpAWpNvH+nqunzOdfDgNRZsk7+A6BXYCJVwnkh6UV3iYoDBcSZxeKyQLL+rP3n2qCsKGH1T3VDMsYHSuBjWHZy5YdraSkql7vyBvG4j6svPEymKeorr57ioUkfCir2Twy1qob+B7kUSdjjBAy3vsmKu4TWiZsOQBFcU6mqlNvzrf5CX4vNTaeEyIdTWBMTJYB5LYJNK6MnuXE2lbUtU8Km+pq1cCiUuPVvx2bvE0ZvvyHxo38qEMxHF8DbBqa4VIgedxDW1ezRVK+rehJ8myyBNGMmsbSH/i14jfFFsPuoe5jijqN32zeHV48SDL00DqUqq5ifFiyPXuUfaELeaisDRDedHIGShmkKoXBLpusbklrp62dJvudZYxM6EnDk/spDv/3+ffLxcFlFIs5rqvuqjAfcHFBuv/0pDUTrg+biaSvkAqIW984zW9MF3p/SOk6ZZ4NmehAG7ktYYmln/l9kRw6QZlu3HRR5pPkpS/lNIUXlhBwSd6BaOGDqfc3cT1aJuB/DyvknX/e4zAOATOHX
 GD6d6tjN
 o+MzGLw36SABIqX5lQstCL202AfSGfcDaIR3nbM3v/vQOrCsquAGvemyzQKsak2ko10gTXr3Uc3lYisTlt8gR6+s8M2AGOfbLTe9oE/eC1kR36Ux9Pyd3ZwtRDpjT0pb8iyIXCMDJ/AtIJiilbsI2iWbCfFImkd7rHrLk2usKhApBvFA4hNYvY0dfGyYRuC/QqLibiARFB9xkPx1jyUIkhQCsf6eMXXbuc02TRAmZtrTz8jIvZO5F4to/k9nY6vp7dEI2Pp9cxJqXyxqPwh9eBT/X7CPXfi1LNSY2lTfUhaZkcBrUWyQXbPiPHs9Ad/M2l6Ei
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 21, 2026 at 07:19:19PM +0800, Zenghui Yu wrote:
> From: "Zenghui Yu (Huawei)" <zenghui.yu@linux.dev>
>
> deferred_split_queue was removed from struct pglist_data {} in commit
> fafaeceb89a5 ("mm: switch deferred split shrinker to list_lru").  Remove
> its description in doc as well.
>
> Signed-off-by: Zenghui Yu (Huawei) <zenghui.yu@linux.dev>

LGTM so

Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
>  Documentation/mm/physical_memory.rst | 3 ---
>  1 file changed, 3 deletions(-)
>
> diff --git a/Documentation/mm/physical_memory.rst b/Documentation/mm/physical_memory.rst
> index b76183545e5b..a09407d72973 100644
> --- a/Documentation/mm/physical_memory.rst
> +++ b/Documentation/mm/physical_memory.rst
> @@ -262,9 +262,6 @@ General
>    PFN that needs to be initialized. Defined only when
>    ``CONFIG_DEFERRED_STRUCT_PAGE_INIT`` is enabled
>
> -``deferred_split_queue``
> -  Per-node queue of huge pages that their split was deferred. Defined only when ``CONFIG_TRANSPARENT_HUGEPAGE`` is enabled.
> -
>  ``__lruvec``
>    Per-node lruvec holding LRU lists and related parameters. Used only when
>    memory cgroups are disabled. It should not be accessed directly, use
> --
> 2.53.0
>

Cheers, Lorenzo

