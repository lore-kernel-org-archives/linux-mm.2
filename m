Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C4C38FD064F
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 07:58:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D6D9A6B0089; Wed, 11 Mar 2026 03:58:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D108A6B008A; Wed, 11 Mar 2026 03:58:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C3D446B008C; Wed, 11 Mar 2026 03:58:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9A9AA6B0089
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 03:58:13 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3F997160704
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 07:58:13 +0000 (UTC)
X-FDA: 84533029266.24.02BC129
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 94072A0004
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 07:58:11 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UZ47fYzb;
	spf=pass (imf15.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773215891;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BcPlG6sd6I4c1Dk6IxqFPStSWdZB/sxdxEENtotX4uw=;
	b=Zfqojh+iOEaddU3Cw5uMcD8MjargFC62AY2Q97u7BQuCV1td1cIjLMFIJjL4LE/H9cyIXK
	rb3v+QxBjtXtU3IEwUGkd2E8GI9qw6ezGefiqyJYeW6Ro2Cow4nsWPe+IhOWF3iT/LI0Vw
	vQXkv8GSZIqPL0KLbe5PybctKwszp1A=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773215891; a=rsa-sha256;
	cv=none;
	b=nK9jx6VUCmeV3JsRpTYI3Db6EMrKMFCWp6P+b+CHuUGCVycKrWsaxKbn1BgpX0NGqj6z9d
	z14R5Ly71h5LtxBdjVDnywriyJf7BZJqEa7lYnnUO3CQu3KNgz5V1BAQnd2QDvdGMW+z8h
	u37T0GXHy/j/sFK28f0DCMrpU6PAwAo=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UZ47fYzb;
	spf=pass (imf15.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id F1B656111B;
	Wed, 11 Mar 2026 07:58:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A8BBC2BC9E;
	Wed, 11 Mar 2026 07:58:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773215890;
	bh=E/Ts9ffHw1QTEDk6b85mzgFX+XeGE7mSX0ztncPCZhc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=UZ47fYzbLzv5Twpl9VBd5KCJKi2y9/sKpLbv6GEne7E5LtfMtUy01KGn7gYsLx77Q
	 NjqSJdMwdQcvnwse/iC/an96fMLUMOfvDcI8XdXvaTcp03FhWUORUWHq8rNBjVWYff
	 pBE9IGsAKkJAdSPcTgiQ7RHBaJoEWnOhzQtewGgFppIP49YEv2+09HMeC+0Hz8sFAL
	 z5eXLened+BzuY1aiIEu2mEl0ql8Ryqx5rfse1okUbGzH3AiOcnS16dV/iULqa6gZl
	 VBhT6cjcBaLLLbmVjYIv/u4wnSrcSIhZnGrk7eviNXvWqeVf7pQkliEYQFCJe1iwTx
	 nRzx/fJ4XY3fg==
Message-ID: <26662caf-de09-4f13-b374-dc7f879b7829@kernel.org>
Date: Wed, 11 Mar 2026 08:58:05 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/5] Introducing qpw_lock() and per-cpu queue & flush
 work
Content-Language: en-US
To: Marcelo Tosatti <mtosatti@redhat.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter <cl@linux.com>,
 Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>,
 Joonsoo Kim <iamjoonsoo.kim@lge.com>, Hyeonggon Yoo <42.hyeyoo@gmail.com>,
 Leonardo Bras <leobras.c@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
 Waiman Long <longman@redhat.com>, Boqun Feun <boqun.feng@gmail.com>,
 Frederic Weisbecker <frederic@kernel.org>
References: <20260302154945.143996316@redhat.com>
 <20260302155105.214878062@redhat.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
In-Reply-To: <20260302155105.214878062@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 94072A0004
X-Stat-Signature: 7bugu13rmtpyr7iuoksq68xuf7qhi5n8
X-HE-Tag: 1773215891-863561
X-HE-Meta: U2FsdGVkX18ZhFg8ajTzoe08eTlpsc0y3MrQFYOOgrmqdmsSyfB9RpDCG9TvkHABSeBU4HPe6tSaZldYcPsT3yjN2O1ygGQgOu/4cAo6WIiYJsDAbLBeWXseIIJwtFfTRbUt/PRWihEnyk6dQ5J8279t0iz+a8NGg3tc3/B+kUhDN1VnfaG6CR5lHNQ1mowHTmccTIi2Vi59d9ONsbItLguS7xoLgk9V7jXLFnwWPGuSwSl+xQGn09Yo2wWlzo5btMhkMYNQazy7eRsSX+/lQY3FlTwQ+BGx6Z4qwfT7jq5BH3TZSJcc3kHm/RN+0IjzLXJBdtO0AwEoUFI4XS2GHO9R5BmNgxrdDYPJfB9+Jb3wQ7n3mdsnTT+4juJlB6LtcqJ4ghk6MOmGgnpUL5R67YzbFpv/D2TYclC6tMx80ZpkNS6c6upQs9HCpI+DT3l6yrUwoLmd0LR1eH0njYpOxkAFuzyQS1hsqs4bvvEOeqvL/nVVwhAOpj8SN3DArcfW+gWNyHrMe3x+3E8BndQQ2JSghl7X/18uZIXsLCFXMo638QRiJeK/w/aJFhvPxPA+n8sC9h11YAcyP43mY8Q8QbS2hG4aLPUK5b24zjIRkAlMRAiW8f7PSzX5oK3UC4OLwfVpislZXJKRduX8S3HOdj69GylvNfTWN3s476ToIx1DKgbvBl6VPjNnOX8HIA2lzxEMZ999JpC9ftLbFLI0JcnxObKX5GH06BWS3oOwf+UHTyTjAfmsNe+kvfwnaDbuQcaVkpWdzAbivse+mzqp4rNK4pja9GGS0CNE7ZYyqPKbGnlS99ym84B3W9YmDsWvrmjNzZyMcWPfxxkmpRdZrsJplT+WldNot2D+hon4hKiiAcowkx/kpFC96+q3P9OAATpXB1NfmKV3GoQ1DYeNBZIat3MGcN19O+NjnaIBJCEPNf14mw8c1pTAPGBCqM/RLrxzcJ9jaFehKEaWjS2
 ss3CAn3J
 L8JTJW9P6NUwZ/Qzs8hlUY3d6LRIQxOLVEOd7TRewCQ3pIg5g3veAnN6gSLWcpziWOuvBlPyAxUEJT9MV143fkHtdgh+XTXGNPyCpwH4l1P+k2HpXfsrV8z/CYGVIw/+AEk3ZV+HGR5l95AEYng+hNg6BS+vTWjS8nvZ1ByCBlKHNE7u66Jvjq5kioDw11+bYIq328/NjUUVX/IMgGag5Ztr94AYckA4sDUtHBVKhbKTx5eJhfJWpnGWGMwxvzsIXv6da72ygblIOJdcvu1dSK3a/1l5Ux3MNh8cpl61Ant/ESYSedP7oN/38stgJPrgl3PJAc3FBKTcAjrjd3sr9bgN3jRE2u7saCHaGhfJc4Uq7JRe0FNfx+5NqdKeplArsLDLU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/2/26 16:49, Marcelo Tosatti wrote:
> Index: linux/Documentation/admin-guide/kernel-parameters.txt
> ===================================================================
> --- linux.orig/Documentation/admin-guide/kernel-parameters.txt
> +++ linux/Documentation/admin-guide/kernel-parameters.txt
> @@ -2840,6 +2840,16 @@ Kernel parameters
>  
>  			The format of <cpu-list> is described above.
>  
> +	qpw=		[KNL,SMP] Select a behavior on per-CPU resource sharing
> +			and remote interference mechanism on a kernel built with
> +			CONFIG_QPW.
> +			Format: { "0" | "1" }
> +			0 - local_lock() + queue_work_on(remote_cpu)
> +			1 - spin_lock() for both local and remote operations
> +
> +			Selecting 1 may be interesting for systems that want
> +			to avoid interruption & context switches from IPIs.
Requiring a new boot option is always a nuissance. The cpu isolation is
AFAIK difficult enough to setup already. Could the default be that qpw will
auto-enable if there are isolated cpus configured? The option could still be
useful for overriding that automatic decision to both 0 and 1 for testing
etc, but not requried for the expected usecase?

