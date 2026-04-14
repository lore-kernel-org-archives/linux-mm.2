Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4FE4AF9D0CC
	for <linux-mm@archiver.kernel.org>; Tue, 14 Apr 2026 12:37:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 820B06B0088; Tue, 14 Apr 2026 08:37:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7D15D6B008A; Tue, 14 Apr 2026 08:37:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6E78F6B0092; Tue, 14 Apr 2026 08:37:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5E3166B0088
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 08:37:23 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 08F3213A9FE
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 12:37:23 +0000 (UTC)
X-FDA: 84657111966.27.43DA732
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 6D0FC40012
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 12:37:21 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ctemzI7j;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776170241; a=rsa-sha256;
	cv=none;
	b=SdQqkMnnJniafmxAnS7XHX3jbdlqL1Z4gMW6MqA6r/EyF7H+03ptM0vTcOEL2bGcxIZjtU
	1xHEqau5/Ty1gMo2156u/jHqbBk6BNjo7JT815JptRf0NpjlIKi8Sc92kL9HEaej4cMu/9
	HcQplONoik3NqV1RBG20tusUiy1uhSA=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ctemzI7j;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776170241;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8rFo1xYQWE7FS9ROERB7PXr7oP0R/5npYjFxEm+/z9U=;
	b=w63llbxaP7qmeVGOlb/z77hA84ypE4LFlLTpW5TpYmpXYTMvSXN4o7fLACkyMw3E7+BlMA
	xr91vZgRHvN9h01G9NKOyHehSwxb1pSrLrgsiby6GUuO9qEFePvrn93clGh7Ny/ffmbdxu
	WM8Umg6grMvEorsbzK8Wh8sbQNMFvnM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id A1335600AD;
	Tue, 14 Apr 2026 12:37:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB928C2BCB0;
	Tue, 14 Apr 2026 12:37:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776170240;
	bh=r3+ciPU+/RnpA67s8aY3C2Berg8zTv2JTDP6XYaZ860=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ctemzI7jCDJfs27xjODFYQ/9/JiX8/3JMfYY/w0+N8fS5e8NzwdMIPMARW5iqPQuM
	 AgBOKnW4ofAAWVzKPN9g7mWhJjKDbrcbnHYazu2jQvOFpO2yTAEaTq1xqmPm+2wOj2
	 fcOK7UtrrpVVLedHG4tY5mm0DNatUD50uAx2pFrn9LyYnNhyoGrsbwjIXuUmjobJp0
	 Su786sfVgxG84DhGFtEBmmL61xirCpoE7/FcS88ViBmOyVCL5uJuw32o2ZKJWUlRHm
	 4nRwvLFLWP4lAQ9doNMcsTuZm6oUEGMCHaSKHNbqQx/zOJekgP01YsAeb3iv3Ip1eS
	 lC1xtaDC6TtUA==
Date: Tue, 14 Apr 2026 15:37:14 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Sang-Heon Jeon <ekffu200098@gmail.com>
Cc: akpm@linux-foundation.org, djbw@kernel.org, mingo@kernel.org,
	linux-mm@kvack.org, Donghyeon Lee <asd142513@gmail.com>,
	Munhui Chae <mochae@student.42seoul.kr>
Subject: Re: [RFC PATCH 1/2] mm/fake-numa: fix under-allocation detection
 logic in uniform split
Message-ID: <ad40-uVPKtaP6wuw@kernel.org>
References: <20260413154438.396031-1-ekffu200098@gmail.com>
 <20260413154438.396031-2-ekffu200098@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260413154438.396031-2-ekffu200098@gmail.com>
X-Stat-Signature: gz86dpeikx3b1xkkw1bmpscw8aw9oc4m
X-Rspamd-Queue-Id: 6D0FC40012
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1776170241-274594
X-HE-Meta: U2FsdGVkX18nZMySY3QFuXx/PgArZOB0bOXbzHqWvkgiuO/Uo2T8GyZZkiPsIM6NfFt3VIiPyEUOfKp3+PzsREaFjz2fRYyOkAsM8TpQvj0bgWUHEg9/EPA/rKc0tiFnBiNXiqXXBmcfN4sg4Tw9xskE3/xaKDuSVf/Y0QdMr0GT6aqW5KJZ4wWNiCfcNkjEQcJ6j5CXbfFxoDaZjQSQLPfCzmr202cd/t4NRKqam0RooNc7FLfVZEfJex08Nm2ott64UYVDzHX9nvDxaIzfze9mQwLXiHFtHvb++AZwIEw0NBbDaEuR9eCCl88Wa+HebiSt4MlyNix7ZNwxJRF+jOMRXCmDzDdTbeM5AWSclxv0P2SjqcJocov43GjAwvBmeK6Ovb5RpaIEH84UWb4WuiU7v/i/VJd8tkePRsjdIHrDDITHxKeDFKMVWTnGUYZ7BMAlKmmKeMHoMlcIWy53tM7tTMKANv5WX5uBnE3OxiCYQbIvqlFEILchEZcagtFMGV4nFf/W5sTMb69eLIH+Fl8jYTZqdjq9pKn9v9+Bn4o/KPm0/UZz7eDCTraM7s/5aG42OK7qEBYkyma0oA2J+O1ai3FWMINS3353gDky9uXeacl62vcZFDFWtlYyxwunQ5p3pTQlJrvN1NDlWQMpGSfnX+/BpjWF0BQbyF6+M8CJXjPzqihNoayfg0CbStlPQTWo2R3sYioKEPUx82bpYkOIZkH2ZkBQflTEUSvGgaDJx4iM85yTlDXgwuICDp53hROB+9OJkRgVRFMMCHsK/6f/WmJEeb8jtlmTm4g/OeXR5kMEA3DxN+2fGv4sK0+SN+K6LUvkHs1QA8FrfVXDFs3Ez56xLTt7dMl1LVz3z+a2I6SQLPZpjeguzNjmyZ3dAIoHWLDy/U4ZVAA3snPTuwBoBjhmTTjHhwn5p256o1EOSLmYjegJ3Cqy55bGuT46QDl34Rc0Km6j+6Zjvto
 MJk5/uhe
 0CGhm4klLcBOtqF0yBDWYc3HrG5w7bSnLGg7vSygHhf/5uKIod4tp0PMXl5M2LltAqebvdRJGaIo7yF9xfMXifJlDY/flBFKJyYLvubf8n/Joz9jC4++xsuEOFk86uWqIs6e7NRwVbKZ6HrwPVyobRVnuMIoZeSxRtG4KP1vTZpUle4IMda9Fo2NqIgeSIl+bR/19XnzE1N0SYNynd4On+R5wsezJtVm7YAh6cTEUXBL7CcwmT0lFtQVODyADOFsg9gt4h7B93KOe9e/Nbw5sung7iCJv2tCCjJEdTPVDZykSO5TTUmVTPHFc5g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

On Tue, Apr 14, 2026 at 12:44:37AM +0900, Sang-Heon Jeon wrote:
> When split NUMA node uniformly, split_nodes_size_interleave_uniform()
> returns the next absolute node ID, not the number of nodes created.
> 
> The previous under-allocation detection logic compares next absolute node

I'd replace "previous" with "existing"

> ID (ret) and request count (n), which only works when nid starts at 0.
> 
> Fix under-allocation detection logic to compare the number of actually
> created nodes (ret - nid) against the request count (n).

It would be nice to have an example of memory configuration and
numa=fake=nU that demonstrates the issue.
 
> Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
> Reported-by: Donghyeon Lee <asd142513@gmail.com>
> Reported-by: Munhui Chae <mochae@student.42seoul.kr>
> Fixes: cc9aec03e58f ("x86/numa_emulation: Introduce uniform split capability") # 4.19
> ---
>  mm/numa_emulation.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/numa_emulation.c b/mm/numa_emulation.c
> index 703c8fa05048..e7f856c8f2a1 100644
> --- a/mm/numa_emulation.c
> +++ b/mm/numa_emulation.c
> @@ -416,7 +416,7 @@ void __init numa_emulation(struct numa_meminfo *numa_meminfo, int numa_dist_cnt)
>  					n, &pi.blk[0], nid);
>  			if (ret < 0)
>  				break;
> -			if (ret < n) {
> +			if (ret - nid < n) {
>  				pr_info("%s: phys: %d only got %d of %ld nodes, failing\n",
>  						__func__, i, ret, n);
>  				ret = -1;
> -- 
> 2.43.0
> 

-- 
Sincerely yours,
Mike.

