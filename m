Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6AB27C5AD5A
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 09:27:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4D8636B00E4; Wed, 12 Aug 2026 05:27:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 48A666B00E6; Wed, 12 Aug 2026 05:27:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3A0536B00E7; Wed, 12 Aug 2026 05:27:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 15C596B00E4
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 05:27:26 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 86CE840193
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 09:27:25 +0000 (UTC)
X-FDA: 85092089250.21.5781D9E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id E1F2E1A0006
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 09:27:23 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FosPnie2;
	spf=pass (imf19.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786526843;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IUd4xsss48nguk+w9o+2Ozog63PCl0EQm/3UWwY4hHk=;
	b=C+tFsrMgjoXDBu6AbrwFsrCN4jrIpKiSEU/xG1bN+qHITThN+0VA7Wvne8l3A9B/X9C+Zi
	iXI4Ji0DQqb7Zh3eNLBbDLRzUx/6lhk6BSgxV6VCmA+DsiE3+0+ajfg4Wrf55Z6OhEB6nA
	oKxeMHA2l/7ogeCgJDTVHQdZVcLWmYA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786526843;
	b=fh7M0WqpAyQ1Aby+mBKlhtxIK7CebBjjfa8EsFpK/zsvFB4WuJ/n7hBSu1X9c6GA9OXkv7
	PCWd6bM5sbE0Wk0A7Snb+DtFTca/5eWxKkeT7sQYF5rXBWbEax7++pwaQaqdbO01kP7P5v
	UquURpjwxfdQq5Ac+7LZOsRrE+wWG0I=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FosPnie2;
	spf=pass (imf19.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2308D600E2;
	Wed, 12 Aug 2026 09:27:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BB231F000E9;
	Wed, 12 Aug 2026 09:27:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786526842;
	bh=IUd4xsss48nguk+w9o+2Ozog63PCl0EQm/3UWwY4hHk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=FosPnie2TVYnhXl9SP4H2dqQBZdxucBIRXspPC/8qNjS7GEcpRXuQGCe5mrBI921T
	 yXvENGLsQknuxZFKHVxnoABpxW2XXIdj87tdQ4q/Fd/XLqCRNdLWyJYQiQDmwrRXSV
	 /vORARhOXd5KHeRvnB6WuGqcpVz9cVogeviZ4VQO1mf74lf9D/m8vPEOCA7PSRpTev
	 Mwyd62ydRAxj1hAtwu9Vfcheglzz/r98SpVLcBJ5/+xoLg/DmPjA+OxTba4oyj6PUj
	 1UttBdDYn330bgQWaX07GeRCj+w75GxoBXkmxoR2v0XY9voW4PJGNTR+WdyVGHDlKF
	 M5FQ8SO3IV8Cg==
Date: Wed, 12 Aug 2026 10:27:02 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Song Hu <husong@kylinos.cn>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, david@kernel.org, 
	ziy@nvidia.com, baolin.wang@linux.alibaba.com, liam@infradead.org, 
	nico.pache@linux.dev, ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org, 
	lance.yang@linux.dev, usama.arif@linux.dev, vbabka@kernel.org, rppt@kernel.org, 
	surenb@google.com, mhocko@suse.com, corbet@lwn.net, skhan@linuxfoundation.org, 
	rdunlap@infradead.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] Docs/mm: fix THP policy counts in transhuge
Message-ID: <anw8ASKdPWW9v86d@lucifer>
References: <20260812080313.330413-1-husong@kylinos.cn>
 <20260812080313.330413-3-husong@kylinos.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260812080313.330413-3-husong@kylinos.cn>
X-Rspam-User: 
X-Stat-Signature: mcodkqjxpfjzraiab9jfeetuzokmjynf
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: E1F2E1A0006
X-HE-Tag: 1786526843-76889
X-HE-Meta: U2FsdGVkX1/PLAgssdVreodeFU6pndxCQfWdJlmgmgtEVrJOAofHmL/lgKtQK2ijr4GyaMKak0GUd4klIPcovxW4QGWOFBU6cT8gNa+QxotPX/kVkYKnA0VDUgPVg8eCx9jb+mKEqpJ+hFT2aejugu2qPhvOsTuhKINLOHkeQV4M5l2mh/YJQjd++srxgSxpr4DH6ycpOO3s0VqsaasnUbz45tvtHS8x8CnKxH8WH5ILtIY2atFwGCFU5gxw4vLhLepcChPIkGrS0KSCIB95jX45TstGAagFcScoFXr55noNDfCIpVmi9tuIzOeZ8zfQd8JMgTmp5hQXzL5Ifrdip9ytnmnP3gRBkZioM4I78ahcv93FsBPFekROnBelITvNZPYHy9YVQTofFECIQTi+m1BrjZvGUl2mjdRg6QACOTZQfCu1wF3vTCgM0bY3ah29Pf/7JJIJ8M1BAPBAgq1hMySwTLm7F3i88TwJrw/mfRtxRsv2y+/oJ7xMLkx0uchaNz7ecqo6zxdFCR6wrmOXeTt45gDIqc+nFmDfqL6Q1fTLmQFu49zJiaNIKWvem1e+05ur5/vaY++VumZ5z8D9wO9DN21aor+Xg97RdZS7grNXAyKctqAqC9dL4Aq5KnmPp3bGnib+79JL1vfnRFGafvtAcQlYZe/fS3WM0XiDBD3GAFbzAowAz6vT1NG4DjaaZon09Wb/2VImscvQ4om7oWKrQCY0iThUv0y8Pn4M8T74SGyKvQmlwqOfonjrdX6C8D8olapXhKcKa0KKmZ8SXAJcgSF1ttCMHL2Z8rvEbVliyKxNV709mG5tQqB3a/91cKWlzYdLJj3m0QhE7rcxbj6A7ZwzUHLGtwoDHtdg+09fWx4djwQyWXmUzUOStaQKuYmyUtn0rwdEfFznFYuwuNh4/4Km7BSOSszDdZXksjQaN1mPiP2rYeIxgFRUqcHg7C+Str6ViJgc0Usi/ej
 WgZ6OjFV
 Qmtz5hHm45g+CenyAi79V1Vy9p37dPcYcAi/0xwQzP68+z/MFAh+7vpzOXy39CDimgkEHEan7vHVKeS1XqbJPXGAtECcAEhMOqOdieQLszpqJPHglS8gD1wlYQaVdQV7Wts6aPQcxqsF6TKjWYZvVetO+lwklVinKsWoNK01grRbMUyAEGobJ7o4JTIa4GlIEHSMSBFZ9npa0frw/TOK3K8W6gnBZ1lGcPKJAy6hwHdJ4GZIoomW52x69rXwsDorBhjun
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 12, 2026 at 04:03:13PM +0800, Song Hu wrote:
> transhuge.rst claims seven policies for transparent_hugepage_shmem= and
> four for transparent_hugepage_tmpfs=.  Both boot parameters are parsed by
> shmem_parse_huge(), which accepts six: always, within_size, advise, never,
> deny and force.  The "four" applies only to the per-mount huge= option
> (shmem_param_enums_huge).  Fix both counts to six.
>
> Signed-off-by: Song Hu <husong@kylinos.cn>
> ---
>  Documentation/admin-guide/mm/transhuge.rst | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/Documentation/admin-guide/mm/transhuge.rst b/Documentation/admin-guide/mm/transhuge.rst
> index b187d618452f..72e944f49da5 100644
> --- a/Documentation/admin-guide/mm/transhuge.rst
> +++ b/Documentation/admin-guide/mm/transhuge.rst
> @@ -389,14 +389,14 @@ is not defined within a valid ``thp_anon``, its policy will default to
>  Similarly to ``transparent_hugepage``, you can control the hugepage
>  allocation policy for the internal shmem mount by using the kernel parameter
>  ``transparent_hugepage_shmem=<policy>``, where ``<policy>`` is one of the
> -seven valid policies for shmem (``always``, ``within_size``, ``advise``,
> +six valid policies for shmem (``always``, ``within_size``, ``advise``,
>  ``never``, ``deny``, and ``force``).

I'm not sure we really want to advertise 'special' testing modes like this,
sorry. These are not modes anybody should be using in practice especially at
kernel boot. We should probably stop people doing that...!

>
>  Similarly to ``transparent_hugepage_shmem``, you can control the default
>  hugepage allocation policy for the tmpfs mount by using the kernel parameter
>  ``transparent_hugepage_tmpfs=<policy>``, where ``<policy>`` is one of the
> -four valid policies for tmpfs (``always``, ``within_size``, ``advise``,
> -``never``). The tmpfs mount default policy is ``never``.
> +six valid policies for tmpfs (``always``, ``within_size``, ``advise``,
> +``never``, ``deny``, and ``force``). The tmpfs mount default policy is ``never``.
>

Similarly here.

>  Additionally, Kconfig options are available to set the default hugepage
>  policies for shmem (``CONFIG_TRANSPARENT_HUGEPAGE_SHMEM_HUGE_*``) and tmpfs
> --
> 2.43.0
>

--
Cheers, Lorenzo

