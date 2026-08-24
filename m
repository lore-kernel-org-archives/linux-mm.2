Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AEF6BC5DF81
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 11:03:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 859576B008C; Mon, 24 Aug 2026 07:03:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 830D86B0092; Mon, 24 Aug 2026 07:03:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 76DCB6B0095; Mon, 24 Aug 2026 07:03:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 58BFD6B008C
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 07:03:14 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B8EB6C04B1
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 11:03:13 +0000 (UTC)
X-FDA: 85135876266.29.A314D2C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 22F4318000E
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 11:03:11 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SzPCSzAJ;
	spf=pass (imf24.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787569392;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UdCOtUzK9WsMiHEbiXYD8f6q2FcIgH+IdV2r7/ydGwo=;
	b=sAzH27z94xULd8K6ul4ILwOjRvAOewbR1HO5Iq+8814vUPL/Wp3LfiJyHPxtcb3hp+It3/
	WSJ1EvJc460OR8qIaPvYrgPOuLYNiDqGD4Dcclhu4E/hhGXdQcBjwTKJO7N5edU19dvf9W
	b8dWqZzXvvYUXU4tpkV7i24M1s1WY1c=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787569392;
	b=nPgVBQsvulkSIROs1zdenqUSMNH6cMJNf1hpmN8Ry6NZDGOsyObCjcgFDynd890WEsWBNZ
	W+qK7TplKbjdxNCr/tCb/mNRRYbEipgKxCdcyeuRMaHKDjro2WpT9myXXB/4+aNm5sbsip
	57Do03Tfhj7qyv8sl4bZ49cVJT4QW/U=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SzPCSzAJ;
	spf=pass (imf24.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5930C600C8;
	Mon, 24 Aug 2026 11:03:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1039E1F000E9;
	Mon, 24 Aug 2026 11:03:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787569391;
	bh=UdCOtUzK9WsMiHEbiXYD8f6q2FcIgH+IdV2r7/ydGwo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=SzPCSzAJGs3UGrpf2l5Ux5IkhIojvbrune2DyFgFdqytpk8KxvGYe4xy0mn9cvJpc
	 kTKyQ431BDuqkXn823kR2GrIbjkA5YAe1Els36lu393h7RjRapU5wFEyLCOoGLYhMW
	 f4PoB9ugcvMcYFUp1hEaBnvhfXG+Ul5AgPhr+hXG5ox0OaE1ExDs0fE8arUZslL4+F
	 mJQVLeXzSeHbrF4NiYc8JvdDxe/+yCIj/132zC6+zLpIeitDTEWvzJNLafHfTAdB78
	 pFgxBJluHzQ0in44PHlF27OJWnRNTy16WwoInCMPZyA3CXaZepPvqKrzQ7uFg0x8VN
	 4TkDhS5adwhow==
Date: Mon, 24 Aug 2026 12:03:05 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Jinjiang Tu <tujinjiang@huawei.com>
Cc: akpm@linux-foundation.org, david@kernel.org, xu.xin16@zte.com.cn, 
	chengming.zhou@linux.dev, liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, 
	surenb@google.com, mhocko@suse.com, corbet@lwn.net, skhan@linuxfoundation.org, 
	shr@devkernel.io, linux-mm@kvack.org, linux-doc@vger.kernel.org, 
	wangkefeng.wang@huawei.com, sunnanyong@huawei.com
Subject: Re: [PATCH v3 2/2] mm/ksm: fix advisor_min_pages_to_scan description
Message-ID: <aowk3FVFNAT1EIsE@gremlin>
References: <20260824061010.3343959-1-tujinjiang@huawei.com>
 <20260824061010.3343959-3-tujinjiang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260824061010.3343959-3-tujinjiang@huawei.com>
X-Rspam-User: 
X-Stat-Signature: ps4ubyofnmw65e1ymgx1wwkijrj9fxy1
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 22F4318000E
X-HE-Tag: 1787569391-137605
X-HE-Meta: U2FsdGVkX1/Ia8SmPqsuwf3QeDTH4aV+79u3a/2qOSeiuykzSPC6UaEySqlylrJGTQDHsA0D484AWrR+qbEGq6b/W2FL6soBRdghDlwPN42C9tBv5MUDoFPNB57g8Z8bRwWIfniF8VwQJkzAMVaZn6endubMjuSIBCqlirteRbw6WVkvjw/SdOUqa/6MfBMnDoTFG16W6CN4AJTo9vqEGl7IDONj/90iEOcL6kvPxtUuN2zKkCCmuT+58LoGbbm3FD5/ljXrP+kkLHF1rLTkCdoDIKlyAurRo9YE0+ZjtqS12R/bD/FOWrEichgHS1PBRAID8Wr8F2tQycYd4Fa/LRFoLhJR0raH6TzzUJR77Ox4mGAFoArLNHwziPWWfFmgyenAIrplFVBf8vX7oHv5O45GfujgGbrgFBQ63mIpAb5kUw6Hm4EOfDNYQQI3ntyI2W/VAkEr0NutYXnBJc3FdjDux1K/656Jb/MtrN+bIMoVA1BsCan08XxsV7fL+JJrL7oXFa1+A2kf0i+m7OUQkrisbz+DE4jDCaQ2MgeYRXG20l0zJJnYPbtyvagAvW+xk6BrEgqG4BMoZQOQbG3wci6yUvPPeRsPOvdNqDyO7G+llO74smcYboH5mJDlKOkSwtj9szkJUou18IYOEHXH66oDra4KhNCUmKQc9hFgJpuyPSpfmwUwDdwoKbyej2qPjHFIF+4duY88Y1thgX4DVA/IwHF2qkQCx3tNMzDw3z/MNbKPXCGy84ORp1fVSyYEixRSgyRxuRwnEnMUBwjSDVl2C+1kL/1zu+CQ7aZ4L9Ejmc3bcsi/jMx4iNPmMPkAX9Z7hHo6ZOAvDfeI58hpRmLmvQ8h/Opjzh7a7hi3vmrlvctqsBmJHvbD4TMeMt/nXq9v3fMCDFxDyPsZFjJRhDsJ7EsFeZAivqwKM1BrXe+EgwB0s+vIVfb8ryrpIYb6Cchvy7osUXqepvmSgts
 iUHnHAOY
 qz8WzlAxKwPQveIgRYOut2iFEYgihMnbriPGaV8H8XTZkg6axfMuPHwllOyUvwZX5aKQSZbLygiy5Fpw8BrSphwPPkfA1llAZRIxXgu/O/TjAcmZMtU7tos92KT01LPEj6slrApVe/EL1As8clwK4K4QtYMPqN6E/dz2NzN+sY2jDhyVCi1tXKp6ki7AXNC/6xDkzwlPRTfQJRq17aeegG4f45acDiU6WBIedF1qdTgzc1gXmQidCmwa1SfGRVQc5x9UqE2xVZct/FACp3cg2lo3pu9NM7/cSVKhen6ZSDZZEVuvlMu/P78nJhqHMDBlPzqJoVyPj5k1Kxobqzp/PB39FZJYMjRd95GWR
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 24, 2026 at 02:10:10PM +0800, Jinjiang Tu wrote:
> Both Documentation/admin-guide/mm/ksm.rst and the comment next to the
> variable definition in mm/ksm.c describe advisor_min_pages_to_scan as a
> lower limit of the pages_to_scan parameter, but that is not how the
> scan-time advisor actually uses it. commit 4e5fa4f5eff6 ("mm/ksm: add ksm
> advisor") only uses it to initialize ksm_thread_pages_to_scan when the
> scan-time advisor is enabled.
>
> ksm_thread_pages_to_scan is adjusted by scan_time_advisor() after a full
> scan finishes. ksm_thread_pages_to_scan could be increased or decreased
> depend on the real scan time is longer or shorter than the target scan
> time. The min value of ksm_thread_pages_to_scan is only limited by
> KSM_ADVISOR_MIN_CPU, so ksm_thread_pages_to_scan could be smaller than
> ksm_advisor_min_pages_to_scan.
>
> The semantics of advisor_min_pages_to_scan was updated in the v2 patchset
> [1], but the documentation wasn't updated.
>
> Update the documentation and comment to match the semantics of
> advisor_min_pages_to_scan.
>
> Link: https://lore.kernel.org/linux-mm/20231028000945.2428830-2-shr@devkernel.io/ [1]
> Signed-off-by: Jinjiang Tu <tujinjiang@huawei.com>

LGTM so:

Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

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

