Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 93074C5CFEB
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 10:57:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9BEB76B0276; Thu, 13 Aug 2026 06:57:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 96FD26B0278; Thu, 13 Aug 2026 06:57:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B1326B027B; Thu, 13 Aug 2026 06:57:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6EACA6B0276
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 06:57:20 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id F17D14062E
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 10:57:19 +0000 (UTC)
X-FDA: 85095944598.02.963072E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 5D361180008
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 10:57:18 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Ol/Kn2uX";
	spf=pass (imf24.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786618638;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=x3PUUrqbx4pAIfw/w8kq9f3y/Qy+5L/Ufomk1TKExJE=;
	b=4ZALGkh+yE80gdtsErCjPwZoPgWYBTcPnaNWWG96dQYIycRs7fRvRLgImubZ7cV3PYBGHi
	DWwrOLQ67bh3b7zrk/lmbg1chQRG+UmwlH12kmkZh9l0/rlrmj8IGzokHY4DrnrDxe9tU7
	QaKlXMjP19wBKOWFlatjp4Kavpf4NNE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786618638;
	b=oSgVrWSbdWC60GkPycrk6nnkQwLPXnF67m086KyAvMEJVHiPd8wydB7NTlMQjyffOGeyvM
	y91BMvbazxjPK8PcfBzSB8Wo9NjJjb8RG8l9kJJVW/gcuqpTFP3HMnZ3sbyI9AAPucsAO/
	sorDDFFeisdpe5VumjrZU9MIkfRWUB8=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Ol/Kn2uX";
	spf=pass (imf24.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D9280601DE;
	Thu, 13 Aug 2026 10:57:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83F3F1F00A3A;
	Thu, 13 Aug 2026 10:57:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786618637;
	bh=x3PUUrqbx4pAIfw/w8kq9f3y/Qy+5L/Ufomk1TKExJE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Ol/Kn2uXAXCgR27vYXHk10DyHcKN7KT7WISF0mvFFbJJGvravkomKlMF1RIbhZvoY
	 6YmrfCutOUmBb6wwdUqOEyXyD42rfTA1qPMO2kQitiMpNvpj7aGIKWWgYhNUhOFzq1
	 zUY5/0BcxSIarGfjTzcMiUxIXZp7Xt6ZPDfoKT0QBpfXkFaEA/HmZQH9dvDoCtshiK
	 z6PCbhfO7HVn29XPGFeKdJvKWGYhRK/pYBeHbNgIVOwccLNIDEz8z2SPUPZmc96jOz
	 FKMiptdwUZaJRuFGXKPjPJ1LXrW+qBVTxfx4k4rtpaToT7DW/dXxrXUVD1MmYRr1iV
	 xw+kvzWm20rJw==
Date: Thu, 13 Aug 2026 11:56:56 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Jinjiang Tu <tujinjiang@huawei.com>
Cc: akpm@linux-foundation.org, david@kernel.org, xu.xin16@zte.com.cn, 
	chengming.zhou@linux.dev, liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, 
	surenb@google.com, mhocko@suse.com, corbet@lwn.net, skhan@linuxfoundation.org, 
	shr@devkernel.io, linux-mm@kvack.org, linux-doc@vger.kernel.org, 
	wangkefeng.wang@huawei.com, sunnanyong@huawei.com
Subject: Re: [PATCH v2 2/2] mm/ksm: fix advisor_min_pages_to_scan description
Message-ID: <an2g39TIN9v87enG@lucifer>
References: <20260813031722.569983-1-tujinjiang@huawei.com>
 <20260813031722.569983-3-tujinjiang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260813031722.569983-3-tujinjiang@huawei.com>
X-Rspam-User: 
X-Stat-Signature: 319z55tm36bxrnn5u73egjrsxgmtfwnh
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 5D361180008
X-HE-Tag: 1786618638-2971
X-HE-Meta: U2FsdGVkX1817N4buvYaX3ssHJY3OylJfvwy8E99kDEucygmU3LCJYqQa3A4Vk54hBSZJlkODUP1xEamKHm2ylp2UOlNra3Hy7ianinbhZQLreAZdgVXzW52jUGKjSqW/IzAPfITeLAUr0gqjhNZhAV2Dcb3WHPKb4iIvho8UIh27pRhO5qRog+MjnFNTAyvq7xQCfp7wp6qAieVaFPIj3frfPPjDbzWde94WP2dcgqPYa9mYJHA/jjuO/r1eVgpzJTITGhV9/K/8LFpT6slAaNLYPds0IWSPgc+UugA94byTyJKE8DxkCGuCWhNlynC1HiwBnkiq2pYP3TR24hkQK2cNUUSOjfucz3sD2M9v1vRM32gMSfD87UpMjtQzRQ8QFQxkk6FllXm/hzkv0u74l/BnPIo9Fr8oVdZPWzY+cKOyLMSxwVhoCrRWncef2sr5Ogk9wBLuVATQKlWEVpKCPHWGvuiqV/XG575kZ9LNKRAntlJPDho6IvKb6WXxEvtPw52HMxcch4pFSObVJ3BcxzL/59pBGbNr+dNLMbrh+sPnAkAYrHZLMqTFE9qgt9mKVucdC8zvkLUF5jrtBz0BHdeUTBonuK3IKD8VjqvloAy13Spa75v9AsYNnwTv2BU70daQVngzqslFef87VDiEIx28NYL5AcsJug8YXaej98um7jmYZx0REKO9ay9YOwSBDfTRprZgurzWVA9rd0c54W6MBu8HdVQkTWOPf2Ii+ko+BivZVw9LlIlpQUsKf0ffxRS+/eENMob8oRzHTYQkU65CZFPWidPWPccXuTfNiV/GCdxwAgXwHVUEKJrDJzPNnhjqHfHbIHR/UHPQz6WKYzeOAcTPK3F06OJdUi4cb4GJ8fI3z2fYlcZX6viH98t7zfAInbTxr9D9XQzedlkF9trIw2vnwt/lyoHL3RCV9MKohziDSpgC3dpO7XB9Ec+/UGtK7QF0NFNrvoYkRh
 mgQ6hlVX
 7G2LU0szUlDPKIxWRkfSbbQUFheusGlDFAJhGYx/5SZ+xNhnXgW8LNuTkZ303CMA8WP4QySULcRRSidb5XE9ql0JJyOtgLP8En6tSGO6htdRZA02njsy45PCqjig63ih2owOZT8X3WgzKMUPhe1JIV8M+3pIRNmMSF7foIgWsCyJfzru6lDXlPmQLDtxwZm50L3UYQDG+ONlkHN2TvX8kCXrUnNmWjRxJm+xkvKZi2PHARbUQqYabHX58zVTKFcxw9pJ6oj7yQ1WBEhog0JR4dTb7FIy7gjvuPlkY32cEu0Mgl6lNhIRQnsjhRQHKr0fjq94T9kmLkxyusIOwIVuvdN2Gr9jl4Nbe2yR5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 13, 2026 at 11:17:22AM +0800, Jinjiang Tu wrote:
> Both Documentation/admin-guide/mm/ksm.rst and the comment next to the
> variable definition in mm/ksm.c describe advisor_min_pages_to_scan as a
> lower limit of the pages_to_scan parameter, but that is not how the
> scan-time advisor actually uses it. commit 4e5fa4f5eff6 ("mm/ksm: add ksm
> advisor") only uses it to initialize ksm_thread_pages_to_scan when the
> scan-time advisor is enabled. This will mislead the users.
>
> The semantics of advisor_min_pages_to_scan was updated in the v2 patchset
> [1], but the documentation wasn't updated.
>
> Update the documentation and comment to match the semantics of
> advisor_min_pages_to_scan.

Umm, firstly if this were wrong you'd need to change the name of the variable
too instad of documenting it as something completely distinct.

But secondly AFAICT the logic in scan_time_advisor() suggests that it truly does
act as a minimum bound as well as being the initial value for
ksm_thread_pages_to_scan.

So this patch just looks wrong to me.

But in any case, you are making a claim here yet have provided no evidence for
it. 'It is just the initial assignment' means nothing - if the logic can then
only increase it up to the maximum value then it still acts as a minimum.

A brief look at the logic suggests so.

But in any case - the onus is on _you_ to prove that that's not happening.

And even if you could do that, since it is _intended to be a lower bound_, the
fix wouldn't be alterting comments or documentation, it would be to re-establish
the minimum as a minimum.

>
> Link: https://lore.kernel.org/linux-mm/20231028000945.2428830-2-shr@devkernel.io/ [1]

This patch repeatedly states that it is the minimum time. You have failed to
provide any analysis to suggest otherwise.

> Signed-off-by: Jinjiang Tu <tujinjiang@huawei.com>

Assisted-by: ?

> ---
>  Documentation/admin-guide/mm/ksm.rst | 4 ++--
>  mm/ksm.c                             | 2 +-
>  2 files changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/Documentation/admin-guide/mm/ksm.rst b/Documentation/admin-guide/mm/ksm.rst
> index c9f533b10f6f..c329ca747b8c 100644
> --- a/Documentation/admin-guide/mm/ksm.rst
> +++ b/Documentation/admin-guide/mm/ksm.rst
> @@ -183,8 +183,8 @@ advisor_target_scan_time
>          pages. The default value is 200 seconds.
>
>  advisor_min_pages_to_scan
> -        specifies the lower limit of the ``pages_to_scan`` parameter of the
> -        scan time advisor. The default is 500.
> +        specifies the initial value of the ``pages_to_scan`` parameter of
> +        the scan time advisor. The default is 500.
>
>  advisor_max_pages_to_scan
>          specifies the upper limit of the ``pages_to_scan`` parameter of the
> diff --git a/mm/ksm.c b/mm/ksm.c
> index 7d5b76478f0b..4a6cf8cf5d60 100644
> --- a/mm/ksm.c
> +++ b/mm/ksm.c
> @@ -342,7 +342,7 @@ static enum ksm_advisor_type ksm_advisor;
>   * Only called through the sysfs control interface:
>   */
>
> -/* At least scan this many pages per batch. */
> +/* Initial number of pages to scan per batch. */
>  static unsigned long ksm_advisor_min_pages_to_scan = 500;
>
>  static void set_advisor_defaults(void)
> --
> 2.43.0
>

--
Cheers, Lorenzo

