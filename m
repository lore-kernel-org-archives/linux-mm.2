Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 66CE1FD0058
	for <linux-mm@archiver.kernel.org>; Sun,  1 Mar 2026 16:42:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 70CDE6B008C; Sun,  1 Mar 2026 11:42:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6BAAA6B0093; Sun,  1 Mar 2026 11:42:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5E3CC6B0095; Sun,  1 Mar 2026 11:42:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4B5E86B008C
	for <linux-mm@kvack.org>; Sun,  1 Mar 2026 11:42:36 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D9A478C2B9
	for <linux-mm@kvack.org>; Sun,  1 Mar 2026 16:42:35 +0000 (UTC)
X-FDA: 84498062670.26.431ACBA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 2D898180002
	for <linux-mm@kvack.org>; Sun,  1 Mar 2026 16:42:33 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Wnd70n6j;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772383354;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RGAtYVRhCsU5LGplnVktp2m9ZcvAPL+TqLxVnM8dY0k=;
	b=fmFGvwTBI7ueSSkVKCqDfR8M2VWdkyS47wI++KVOIpxy7CzeIJAdemBitVF9zLdzEMUs97
	FDBAmhjBHXrvVVanXqNrI8+UYsb8JEqUmKCXtqqDkEDRHsg/XH5w2Pf1Rl8TeXC5vMF0Kt
	SDRNv+A1mGt7jZRx93v+UpFdmYM3JOc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772383354; a=rsa-sha256;
	cv=none;
	b=c6a/g/3mPzcblFu7CsVTY/jkP8VHp8O2Oo3QEeAUgettJnflwwxcxpyGiX1Ob3yOMntdIM
	oLkfMt+aVw5DEP6xL9rAbsthnHdFKESIRN+c5dow/26TO28/gATZSgwZnRpbCljlTYyUEC
	HYGaQP2oga/vA+fkpDHaqhidwRVOqwE=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Wnd70n6j;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 2FB33440AC;
	Sun,  1 Mar 2026 16:42:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBF7DC116C6;
	Sun,  1 Mar 2026 16:42:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772383353;
	bh=2gPoW7S6UrtEjGc6IJ81tfoCTpZblLaI9E7KswG3ITU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Wnd70n6jiT0ymJ3bZwNy8tt0sM37n3DbyG9rBZ7/nDH0Xx01Rpu9ecDXBPcQrSwQH
	 8+pui6ei6kTqKPaMFYKOjbUVLcf7AzzlJ5ysP3ASBSfbP+Gz093exPm/ch2k/UxPxJ
	 UiasMVnDPx2N6m64OSFAX6ympGAKUGikcLoaQ4z9/gvU5DfhE8o3ycHdfoDwI4xsYC
	 EiL+G1gUgq4z3/meX3wghqQzPqdkAQMBgGZNIUoVqzgsLqhBHYkyU9D48mgDUm0VkJ
	 UG5+O4WQza1TH/DTcTOjq+OE+Uo7j6lALf/9RF/MrPDF84xeyqhNBzX5Gh2EAmvRct
	 RExOjJqdBLWLg==
From: SeongJae Park <sj@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [RFC PATCH 06/10] mm/damon/core: add damon_merge_regions_of() debug_sanity check
Date: Sun,  1 Mar 2026 08:42:25 -0800
Message-ID: <20260301164226.93108-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260221193629.19332-7-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 2D898180002
X-Stat-Signature: 4m6bujinu9jrn5yuanzi9n1pd8oke3ut
X-Rspam-User: 
X-HE-Tag: 1772383353-935630
X-HE-Meta: U2FsdGVkX18/M2/DQc4zG/oYwI9AhYm2DdyTRt6papVEdrB8T2Vkh1WYw16kKDvJAl/JgTv4ukmb1MWMji1bIfxY/sjcxlKtZ/WUztuSAawWKEZzgsDxsSfU+jf5zZz8MW0tIMyCwpoKUN46w4lYOgO9JTaFsvx0UuxznZ614Qyj+Pt+jP76E0/J0NdLiY7gx9ANm0Kv4cYoB//7gX2iECfwnrh17Wd6Qfi2mEVnuncS0K8C3BC0pF2Rj5bcyOMGgzP7qPX/WhbOkGCM91ESpkjlPWTBrzIIsyylPDmchaT3l3MT5d2+PFWWWwq/BRDpEH9JnZyh+/79ztAEnfY1xniElnjRvdU0hliGTZlG6OQJ7heg4C3oeI7shWf0W7OlCbWSgYQTICj3o/mzs1ZL/tsHLiQlF+ULx7d/jbCMtMx/fQUFd7bpsc+PhhAbNR98tXG5m61/aYFyy3YgomxxIjNTk7lV0IgHLaY2vpb6Vs1pUY+uG20xC+srbcm4wifFCEMovHvkVSSkVwQO+fAvbucVJrIcD9RiLl0st5fY9z9LVP547bSZ2/XKPIKdqpYE3wOwOONPisXP5wt4ut3ujV1MMwpaVTYXK5j0BUhNkjPX4jMF0drUufcaDLTLx0mr0PYrf+jvTzKJsecr3JF22LYtGsiIxdIItQkrbdSiAh4zsf8PpuxqPJxeJt9hMqqv9KagfBoqS1cT2L0JNBZKRWZ7tc96ehv0nTUIq5otdcjkl3VtAPqiQ6qx1/y6VQHeRreEdx9agInXyrYiSWrQuQXiLEkVQJOYMCqYwj9AEBFrQ27pdPLouudqYS0J+2tQF6XCv/0lONIjO9DEvs+Pz0fy6Oa5FJLfZnzJkdX6HtPTZAC8c8araR2PL4/aYVwFhLY6bvM0sTYosVjNXT5t5VDi94BAY/mCPflCRVtYPnWLmKxD5xA2o1eC8dOTA7t5CL6QMisi+nIr7An4+tF
 Zeec6HSK
 6n3AtqPAaqYl4x7ANwsZNKPjgaPTHIp5O3GxDVtQ8SadUcJKYEdVpdtc61oRnIjV/csf5McX8PIlx4r6kq59pJn1mF3w0En+y+Fsvl8vMfGpCt/y4lYzhooHLd4s4EBHev7NM5b/put1DnGy46eRDHRD4zO9PAi+bPo/WWYf5tBuXxWcc1DS8sojMOnZBz6yWsBNQQZm7ua44AVYTyOb9C2TYktKcDAMr1pJEPPHzu94MGHnvze70x02Qzi1cFYCyXO5Qt4WKv3TEVM/WDBQSVCEVzg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 21 Feb 2026 11:36:23 -0800 SeongJae Park <sj@kernel.org> wrote:

> damon_merge_regions_of() should be called only after aggregation is
> finished and therefore each region's nr_accesses and nr_accesses_bp
> match.  There were bugs that broke the assumption, during development of
> online DAMON parameter updates and monitoring results handling changes.
> Add a sanity check for that under CONFIG_DAMON_DEBUG_SANITY.
> 
> Signed-off-by: SeongJae Park <sj@kernel.org>
> ---
>  mm/damon/core.c | 18 ++++++++++++++++++
>  1 file changed, 18 insertions(+)
> 
> diff --git a/mm/damon/core.c b/mm/damon/core.c
> index 291a847a8c9bb..94be598cafef1 100644
> --- a/mm/damon/core.c
> +++ b/mm/damon/core.c
> @@ -2545,6 +2545,22 @@ static void damon_merge_two_regions(struct damon_target *t,
>  	damon_destroy_region(r, t);
>  }
>  
> +#ifdef CONFIG_DAMON_DEBUG_SANITY
> +static void damon_verify_merge_regions_of(struct damon_region *r)
> +{
> +	if (r->nr_accesses == r->nr_accesses_bp / 10000)
> +		return;
> +	pr_err("nr_accesses (%u) != nr_accesses_bp (%u)\n",
> +			r->nr_accesses, r->nr_accesses_bp);
> +	WARN_ONCE();
> +}
> +#else
> +static void damon_verify_merge_regions_of(struct damon_region *r)
> +{
> +}
> +#endif
> +
> +
>  /*
>   * Merge adjacent regions having similar access frequencies
>   *
> @@ -2565,6 +2581,8 @@ static void damon_merge_regions_of(struct damon_target *t, unsigned int thres,
>  		else
>  			r->age++;
>  
> +		damon_verify_merge_regions_of(r);
> +

This verification doesn't need to be here, after the above 'age' updates.  I'll
move this to the beginning of this scope in the next spin.

>  		if (prev && prev->ar.end == r->ar.start &&
>  		    abs(prev->nr_accesses - r->nr_accesses) <= thres &&
>  		    damon_sz_region(prev) + damon_sz_region(r) <= sz_limit)
> -- 
> 2.47.3


Thanks,
SJ

