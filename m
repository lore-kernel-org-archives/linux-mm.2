Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B123606A338
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 08:10:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OuicXfmk
Received: by kanga.kvack.org (Postfix)
	id 684C96B060D; Tue, 27 Oct 2026 04:10:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 65CC46B060F; Tue, 27 Oct 2026 04:10:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 54B826B0610; Tue, 27 Oct 2026 04:10:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2A0286B060D
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 04:10:49 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A65931209AD
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 08:10:48 +0000 (UTC)
X-FDA: 85367684976.22.FA0A54E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id E09B71A0002
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 08:10:46 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OuicXfmk;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793088647;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dDmwmjf1rca7vDceLffwmnsnZHqgu7Yv+wtoDgqD3S0=;
	b=Kre6ngk/UjpJgo7WDOWj3JS+95PUNzvvPT342f9BNz3J82pH3Dd1cCWRAsJQAoUyYrSslx
	tE8zZ2ol+zkCptrOayKGF5xdfOqtZazJCX8YRMfm1u/m9YGBZlqbyY5uj4rTP4mc7dr+1R
	Lf5KGo7W3mVe2hr/JJZ4bULJhCe51yI=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OuicXfmk;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793088647;
	b=dgUUOXY7u3UGjjdm9/Y44ZPPf7Bvg6xNWLcH4IbW3lC5ukx/vJJYn3chmg1MBbzSDKsenz
	f7VuOpgqTzCKMYU1Nd9rc9XzlQrlG3O7DMuEmvRx5Fn9Ffx6uuOeKbxrUzYEhu0Mlhvvlx
	ErqMAcrkZPPNhMJJFiiCdKdpT+mw3P0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 25A9743D8E;
	Tue, 27 Oct 2026 08:10:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B40B41F01828;
	Tue, 27 Oct 2026 08:10:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793088646;
	bh=dDmwmjf1rca7vDceLffwmnsnZHqgu7Yv+wtoDgqD3S0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=OuicXfmkCul7MY0Y5pAoKRjE+HsPz/d6Z5LAZ89V6dhsXZuh0FzVVNsxN7gs2PTli
	 jDlNrVoA78k6uChpYYfdukgoWkhsHGLaW0vhy0jgREaMpxP2TtUShAxOKPl3dv09lk
	 qbbFAs1VA9dN7jtTCl9gKRYPdnFlggSd4augInStF/GhJymAwBnL5iS3vr4bPvps7b
	 lznY+CO12tXwJSxLi/rRnjkt9IQ8Hs9cVByOM/tSGc5ThASptgvVlxYLFV6A5E1RPI
	 3fjEE+YfMqB906EBk2d1Z0Ruoz6NZuW6IGGpcf15uzuUT6qSUfUwAUjt89VfmHRBCt
	 cdkqL6kErpc5g==
Message-ID: <16121542-acd5-4727-b64c-f8d519145b63@kernel.org>
Date: Tue, 27 Oct 2026 09:10:40 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/8] mm/slab: Support selecting slab hardening features at
 boot
To: Chris Down <chris@chrisdown.name>, Harry Yoo <harry@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>,
 David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, Kees Cook <kees@kernel.org>,
 Marco Elver <elver@google.com>, GONG Ruiqi <gongruiqi@huaweicloud.com>,
 Jan Kiszka <jan.kiszka@siemens.com>, Kieran Bingham <kbingham@kernel.org>,
 Jonathan Corbet <corbet@lwn.net>, linux-mm@kvack.org,
 linux-hardening@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, kernel-team@meta.com
References: <cover.1793086056.git.chris@chrisdown.name>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Content-Language: en-US
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <cover.1793086056.git.chris@chrisdown.name>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: E09B71A0002
X-Stat-Signature: 9mwrftozh7j5cba4jac8jg44mn8zqsgk
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793088646-833704
X-HE-Meta: U2FsdGVkX1/rkUldk82sm1dNjAfu54ul712wvlXa9UVR4WbgvgiMbR4QnEKrF1VubLWCO86agj2mmH+oN0KlhARgXnrqKfRdcFtRvz1PvkNtdzyjHIn9Q1yXJDj4iJJVYrZbrrqPAA170dAAAwlQEnRsPkl9IRAy0Zgwym9WKh5Nm1qsTJg6L4VuVlGXFcDTGtWQSd7tgQCOZ1tMg4+DCm42O/Z1Bs5zzR3cEkv3Hh7Ve3Wh+Z/ziBT+XJn9KNTlDfaWNdFVBOYJHjxtsmkvEAlGVflcSxfQVbxsxmZ4EriZn6IEdJiEErRjrd8B1vG/CMRD6J31p72BajEch3SRGJYywUv0tLgckTxH73gNy+C4t35+y/iRsfM51w65AU/JPnvIyc9uipoPATU378ZeZ1oT6Xjy7lRYi0GGhs9y0g8/0TvgQI9VfRJm0ahZXBueDOllRGW7MU/0xfsj40o3uxttQdc0IG17ksvMaI57KG4RqBuQodgWUpP92+5aD3UMBHk9bZFs1Gpucvn2Pn78b3ddNCySDISfgmzthuiQ2+xvg1JfBetvrxInwsu9EnmxP+e7G0zd4ZnBuQ/hsffjrS/w9KOOmpGjVbL28nxdUtwjI7jGaHoX4FCzUG6Qi/OL9fsQzLzzQYLDVAzo2ZC/MvNwwW2EQYB9uJ8baKEqSGOcpDc00YcEhAraUK28+aZ5mCfCsq8tKQn23T8aDW71lKlLyLH+euvbZZeXR+nFLjs31J/otOmJtI2iyNXRIkG1Sx83UpGU1JvPI9QsgwwDGxDBZS8zerqf/C5fEVyO2OgnsRSsGvhdSlLVf4ODfPBZnMb4pQlR8/jIIZOE8xrK50IBnuUpM+VENzDIMrkebUUeg7vh9MFw4pbLtI0d+W+RwnPKd1HhH3AeimxbMWk16ICPWnPFZiH95VKYse/musyR/rjY9c+/F+OUeVWwbsBSx6pBTsZwlBvmVIEjGC3
 WahPZHF0
 O774djiJBYk0B37FTZtQ0S5/624c79XzIiWwugShBUgurxSEPZ8WPJlFHIYuiXk6efCk/dZDBCtL9jBNvTLciWd9u6GdoBN0XejztvNyNrZnvJIQeCZ/J+T9dy5fV4GacwllRhydqZNaw0leNzdb6oCrb6BPhsUqZdBuaBaFoIpwqRsvdb0OtWDuaSkO72S2n+nlacElfDx2Pyl8SNuPzt7RYHMkorFW8KEenyvG4XIJOz6kZP0fnyF/TaIxlamZhwdAvIwyRar+OJI3hgch6SwrMgYFfsHCZPGdO8MBuMj1ejass74ZaOmT3pRv2P3nWBboOjIG1MJbsAK6vdYsHpn+UGkaTeQRkXmJkcXG2+o3Is1Y=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/27/26 08:35, Chris Down wrote:
> Slab hardening settings are currently all build time choices. This means
> that, unfortunately, hosts with different requirements end up needing
> separate kernel images. Let's allow those hosts to use one image and
> select each policy at boot instead.
> 
> This series adds four new boot parameters that default to their values
> from CONFIG_*:
> 
>   slab_freelist_hardened=
>   slab_freelist_random=

These two should be only a small cpu overhead, which is why distros
generally enable them [1]. Also the code basically only runs in slowpaths
because percpu caching doesn't use freelists. It's possible the static key
conversion doesn't help anything. You could try to measure the impact, I'd
be surprised perhaps :)

Maybe we should just make them default=y.

>   slab_buckets=
>   kmalloc_partition=

These are more valid as there's a memory overhead tradeoff.

[1]
https://oracle.github.io/kconfigs/?config=UTS_RELEASE&config=SLAB_FREELIST_RANDOM&config=SLAB_FREELIST_HARDENED

> These mostly act at cache initialisation time. For free list hardening we
> use a static key settled before the first free pointer is written.
> 
> Chris Down (8):
>   mm/slub: Support disabling freelist hardening at boot
>   slub_kunit: Add a test for slab_freelist_hardened=
>   mm/slub: Support disabling freelist randomisation at boot
>   slub_kunit: Add a test for slab_freelist_random=
>   mm/slab: Support disabling SLAB_BUCKETS at boot
>   slub_kunit: Add a test for the slab_buckets boot parameter
>   mm/slab: Support disabling KMALLOC_PARTITION_CACHES at boot
>   slub_kunit: Add a test for the kmalloc_partition boot parameter
> 
>  .../admin-guide/kernel-parameters.txt         |  29 +++
>  lib/tests/slub_kunit.c                        | 186 ++++++++++++++++++
>  mm/Kconfig                                    |  15 ++
>  mm/slab.h                                     |  24 +++
>  mm/slab_common.c                              |  48 ++++-
>  mm/slub.c                                     |  68 ++++++-
>  scripts/gdb/linux/slab.py                     |   8 +-
>  7 files changed, 361 insertions(+), 17 deletions(-)
> 
> 
> base-commit: d15d7703166daf7bd62c844a3cb1b3a6279adb4c


