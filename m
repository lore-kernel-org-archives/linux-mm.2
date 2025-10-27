Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CEB64CCF9EA
	for <linux-mm@archiver.kernel.org>; Mon, 27 Oct 2025 11:42:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 14A4F80039; Mon, 27 Oct 2025 07:42:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1221A8000A; Mon, 27 Oct 2025 07:42:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 05E8A80039; Mon, 27 Oct 2025 07:42:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E37C08000A
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 07:42:14 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 980AC59114
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 11:42:14 +0000 (UTC)
X-FDA: 84043705788.24.BC3D62C
Received: from mail.8bytes.org (mail.8bytes.org [85.214.250.239])
	by imf30.hostedemail.com (Postfix) with ESMTP id C249C80010
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 11:42:12 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=8bytes.org header.s=default header.b=UBWAu1Le;
	dmarc=none;
	spf=pass (imf30.hostedemail.com: domain of joro@8bytes.org designates 85.214.250.239 as permitted sender) smtp.mailfrom=joro@8bytes.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761565333; a=rsa-sha256;
	cv=none;
	b=JNS1jwcejWHZHsPCNnE7y4cPBsdWSfzky7EeMkimNOgFTE3rOpMieptAPO/2g0IMNdhRSH
	4vQV9Y8MMxhnQP9hYwK1zKK75hLYNLl9QFAw8OVQlpfgcBkbHSYeZ2h3NVGzjRBRWYQSDE
	INJeRiZy0PEXcIX/91rAvDtXbc3jJ1U=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=8bytes.org header.s=default header.b=UBWAu1Le;
	dmarc=none;
	spf=pass (imf30.hostedemail.com: domain of joro@8bytes.org designates 85.214.250.239 as permitted sender) smtp.mailfrom=joro@8bytes.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761565333;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YDCmvnSs4xT2X+2cTaY85eR41T1BDfzqEf94xbKwp1U=;
	b=rmQ8rt8HmNu7p0v7FwbiPDFMmMzR5Wps1h3HqEOO4HUjI9lrWS9A+caemtpSj+euTRG2Qp
	eNbGsYXiOBRWXJ3KnOFUHx2mSixosJiZti1w0WWEf8NduIln9AW0MpUFnhg59nniNucEAk
	jkJEQ4Bv6z6qZuohwxLk6/W4VTwdgbU=
Received: from 8bytes.org (p549214ac.dip0.t-ipconnect.de [84.146.20.172])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.8bytes.org (Postfix) with ESMTPSA id 11C1B598D5;
	Mon, 27 Oct 2025 12:42:11 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=8bytes.org;
	s=default; t=1761565331;
	bh=yqzIBFJW1n+nS1+66mDfajB+nxaPKXUzfOcuF+B4uPU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=UBWAu1LednunpDwWyA6dN/T5o++Ac0xIHSNyHI2q6aNwwGBoDzmOu5fPBEFc8ArbW
	 /tt8/W2BQ1vmQ4IAz1Nyb104x9b2KteD0nGMUiIeCt12QtQa7PBYD6YBCnrGAnBc3/
	 Qn0JhNAhnoCOhZV98otZjkfHLqNDdxzdtqE+wUKrNuac+jsIeeqfsfsGAH/ne5A61+
	 fJVgnYxkRNIdWQ6FVublLLmG5wjH46QN/ie1gMaNbSwwI4m4daasyct7wC0Ne/pUUf
	 lpUvTiLRC205Aa4QBlQdiUIjcR8HkRzg6GlsEj28ZWB+3Gdl+rXI9orww+F0KE4FtQ
	 tusBXnMM4yTlA==
Date: Mon, 27 Oct 2025 12:42:09 +0100
From: =?utf-8?B?SsO2cmcgUsO2ZGVs?= <joro@8bytes.org>
To: Mostafa Saleh <smostafa@google.com>
Cc: linux-mm@kvack.org, iommu@lists.linux.dev, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, corbet@lwn.net, will@kernel.org, 
	robin.murphy@arm.com, akpm@linux-foundation.org, vbabka@suse.cz, surenb@google.com, 
	mhocko@suse.com, jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com, 
	david@redhat.com, lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, 
	rppt@kernel.org
Subject: Re: [RFC PATCH 1/4] drivers/iommu: Add page_ext for
 IOMMU_DEBUG_PAGEALLOC
Message-ID: <uwznrzdsbfpbalzf5jxxpguf2ykslphfs47u7gf66ssiwzpqju@dh7nw3van6sr>
References: <20251003173229.1533640-1-smostafa@google.com>
 <20251003173229.1533640-2-smostafa@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251003173229.1533640-2-smostafa@google.com>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: C249C80010
X-Stat-Signature: mouijbbrz87y9311x3tufzhwnqcddcbo
X-HE-Tag: 1761565332-938334
X-HE-Meta: U2FsdGVkX19ek+pumU39ZtnIyMCwsO8qz7JMFZBfqjoDGKpep7vYo6YV3SwaTTNzWaKWQToQBgIR3uPEXu1/vt8k3isEFvY4czqzPm9hxZoDrC7b203lqaIC8NhZ371QFz5H1jlMN970p0K+Z03cp4lBVcY6P2QxPVEUELrCz/zqAsa1KXFH5CKHbLjcMXRQhneZCkwfvzOp4CnredIjDFGMixqNCO0zLY4T+aLNQ9KyXwZz3QRzp1w0Dr+noZ6Eu27W3HKYnpPh1u/+3kbUeSDkyKeHwIaj+payrAcMBDIqOuypwFGrrnSp8Zh4+5B+sAfQmlUB9K6UgyRPDnVKmJcBA5M2P0KLxCy3WT/GuIylE/IuqNskLu57dKTcoxKJWwDkn3vcpyhiKRBx5kvfOGj5WQBL01+v+R1XTlM0WfMWhplr6sx8koiSo2SmwvbKy4EHWMTlYAGBro8WmnNYO+l5Ke5wC5mrgrgKy69r9hkH0KLBI6YBiRZ1fmMt1XwrLYzNZINLxAfWjM+nar2z31KCp128yIkbHOQqYEJuO0HoS4pVeGoUEjXkDRNiJOMNws/522dmPD+uwhVSHEeWrBHoH5d9RArpeouzLdGlxgzUu5ALRmbno+7H6W0euHmZWW5GTGlMeraEUjAaJmZvbacAWmcq51esxdhiAl51SbLiQ0Fh86u10lBdGugzX8qh+1y2m4BeebU/FYPCG0sfi9tzr4Xk+VXT70u96MNkxxJBi8cIR3Z5nnWhnPuHNcBiOCkFAUupt5i3I7RCJ1wl43pHVXCjS84yg1VPaYNIxCidEpdLVlne93v8q8IOq/iTyjBOtkfIS17Off49ikk7/xpAK/9aBwyhg07N/SctJo+ct4meqoobHrcPdusBex0CYoxKup4Jtt6MqiM/2Lmv3yviA2DrlTJk/2pRTYRFJyD2FklwYMvn72cUxY1e7WFJr12yLfeQ/0EjF+RRvci
 gcYRyvQ/
 hp+e2jF4vJuVLnpVIUCAC4MLv1A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 03, 2025 at 05:32:26PM +0000, Mostafa Saleh wrote:
> +config IOMMU_DEBUG_PAGEALLOC
> +	bool "Debug page memory allocations against IOMMU"
> +	depends on DEBUG_PAGEALLOC && IOMMU_API && PAGE_EXTENSION
> +	help
> +		This config checks when a page is freed by the kernel
> +		it's not mapped in any IOMMU domain. It can help with
> +		debugging use-after-free from driver doing DMA.
> +		This santaizer can have false-negative cases where some
> +		problems won't be detected.
> +		Expect overhead when enabling this + enabling the kernel
> +		command line iommu.debug_pagealloc.
> +
> +		If unsure, say N here.

Expected indentation here is <tab><space><space> and not <tab><tab>.

> --- /dev/null
> +++ b/drivers/iommu/iommu-debug.c

Is there a plan for this file to contain more than page-alloc debugging? If
not, it should get a more specific name, like iommu-debug-pagealloc.c or
similar.


