Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E9EE7C43458
	for <linux-mm@archiver.kernel.org>; Sun,  5 Jul 2026 19:04:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 575CB6B009E; Sun,  5 Jul 2026 15:04:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5265A6B00A0; Sun,  5 Jul 2026 15:04:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 43C9C6B00A1; Sun,  5 Jul 2026 15:04:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 14A816B009E
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 15:04:15 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 85A99C0A5B
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 19:04:14 +0000 (UTC)
X-FDA: 84955648428.16.D675B5D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id E456840005
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 19:04:12 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=AYsjz1pq;
	spf=pass (imf11.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783278252;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GZxMbMd4ZOtuqkmNi75lsrZtwZDB44oZSzF7qE5TcN0=;
	b=DtUWzfy6sQGqFk+KlPmRHZr31hZNNaJVjgMn0m2x8tlYuhAQwjg1UPyt249j2Oy7nzpM+/
	fYHtR/AsR9paYoAjN/THpmi1oy4EAoi2ivXXDkCD4yBfoCQ99NocyvdJD22ovB9WIrSGtZ
	F+zB8I5iy6tY+HMOniSaNXlrc8kN6ss=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=AYsjz1pq;
	spf=pass (imf11.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783278252;
	b=DQNU9RIMRwepoBeDj/1/OtUc5U1T/WIEBFYu13/woeiF+gBwxJ5lxYyM50jrnqyYXSSBhc
	/KFAoaNDJ+jb2G4vrQ1GUBY4HwLH9ahLcckbKqoo1LKdm26OjRpftTU9DLI9vIMW7BHnH8
	Th6q1J/p7iQpsOEoC2/j6qDxIXbWoRc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 573C160018;
	Sun,  5 Jul 2026 19:04:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B42421F000E9;
	Sun,  5 Jul 2026 19:04:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783278252;
	bh=GZxMbMd4ZOtuqkmNi75lsrZtwZDB44oZSzF7qE5TcN0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=AYsjz1pqlDz7VLoMS+T/hP5o5JJjOW1GiR5eXaBDml23YkCuj7R/7jq0NvXtFppBt
	 O0ZfgKnKcJAO9GHuW8uqQs+k8+kTy7S/oB5OIy4Doa+ebTbmiK9Oci78CvrTrVmND+
	 viqMdnad1t1Dj5Pw+FucWDq3dRjtnubyNN7t4T0s=
Date: Sun, 5 Jul 2026 12:04:11 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Sourav Panda <souravpanda@google.com>
Cc: muchun.song@linux.dev, osalvador@suse.de, david@kernel.org,
 surenb@google.com, fvdl@google.com, gthelen@google.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] mm/hugetlb: Fix null nodemask in
 alloc_fresh_hugetlb_folio
Message-Id: <20260705120411.c7a34ec212cb5ae4e0939076@linux-foundation.org>
In-Reply-To: <20260705175119.440599-1-souravpanda@google.com>
References: <20260705175119.440599-1-souravpanda@google.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: E456840005
X-Stat-Signature: 8o7md9hq9r4bjge65bpa6nwksqg1ehmu
X-HE-Tag: 1783278252-564795
X-HE-Meta: U2FsdGVkX1+pABUeYQwV/DQCcpR9361RbJWamhDWJmv2IoBM6NQ40BCZR4d7LaFWucZS4xEK8YJHNAged263JZSKExdYJRSFOFKvJZOOoClvRad41fs56bEsc/ZJ8rJKSoWqv+OTUiKQKL6cQEa+V9qbVDISfA4feATLPMcG5RYDX+i8TJ65VDlimcVoM80HDowpQ7S1N2IzV9uRUnMTrUvBXf0KgRSsSzkSbe+3q65aonCouIPnvVeDqEPyNtiz5qQt9hD807yX8Ke7lEOVbcGWW6WvAE7ESjddqZ8hGeSf7AohU3WxR3GzOIT5L4eB0xUEbUH9qj4D218lx87RklufudvXlzFfbbWiGkQX/LBTh08bpI7qGo9hBhawdJvYMufqzr9iAgsIoApvs6T57ayjETT2TwM0oXmyV9VIFwfdlOjdKx0Ben9MVP2ajPoGrtEKlaifRi1vnh2aA+pal64QWtyZo5AKyimh3i9GL8Zt9ib/t2XroCVQGt+SSiYyvysiLxypx1RHElHOqHLeD3PjUdoronZQVikcH5h3s09NnAdYv085+u3HVzBhJBDAxgAvilEWQfqRprZbaDlZADk5dPCk4cvw0l2dDWzB/4wm6r59SF32eL+UkuiN+E8ANpaMKFr3j804iKGPfiviUyP96Nf/O3ZYCxIh/4jFSQtyVBHilv84CzgYNdhGwYGtdEETCYOFL0Q6ed+b/AlBICphht8GwOn8Tf1icyM/ctGxFIMRkTPD4lkrm1I4arXtRCtVjtcHsz86Op7RG6egPXXN52MCt14qD8xqqSGlJJacjfU0qyGSNUenhVFQopzvpdF+8HQEynxMD3A1UGhxbNn1LtSWdUidaVPVOyPsrYkBwE58lsKWQM3DNaHki4w6t8KL5c869fGFe1DobcsVAORWB+yxonhX7aoPio/uTmKrBKqq+3SYtN2vmP4dMn1aYYVvDxCLTonuAnYtsuL
 Wyfw6nBb
 6mtjw1ChdXJa85ElnBbHp/en4U9SXw2NnaPWj0qm2t+5uKI4dIN0ZowODATHK8M3ggfs1YaGF6zyy1ChdU7d1ukveMCFIWotAgMl6rEkMzUTFLjDe1V1j77jAgrjtTWuijyXHHZcxD3Oztm8nBAGod7pdahSOt/uWa/5UCRApDxqMXeiasSo/3PM4AeABT9a2tvAhNCGDQBNgeYUfTUEZ4w9kz0Ntbkh++u3sU++HOkoGAKkmKjBMR8YxTakbe4AmaHbxnYEPwc2rqvlkCbgRjM1FxXbgfE1TqgDZ5dphu4QiqW8tExzFbwOF2oGu+91e10iD
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun,  5 Jul 2026 17:51:19 +0000 Sourav Panda <souravpanda@google.com> wrote:

> alloc_buddy_hugetlb_folio_with_mpol() can pass a NULL nodemask to
> alloc_fresh_hugetlb_folio() as a fallback to allocate from all
> nodes. If order is gigantic, alloc_fresh_hugetlb_folio() propagates
> the NULL nodemask down to hugetlb_cma_alloc_frozen_folio() which blindly
> dereferences it in for_each_node_mask(), leading to a null pointer
> dereference.
> 
> Similarly, if the CMA allocation fails, the fallback
> alloc_contig_frozen_pages() is also called with a NULL nodemask,
> which may cause issues.
> 
> Fix this by explicitly checking if nodemask is NULL in
> alloc_fresh_hugetlb_folio() and defaulting to
> cpuset_current_mems_allowed. This ensures that both the CMA and
> contiguous allocators receive a valid nodemask safely using a seqcount
> loop to prevent torn reads.
> 
> From a userspace perspective, this bug allows an unprivileged user to
> crash the kernel (trigger a panic) by requesting a gigantic hugepage
> allocation with MPOL_PREFERRED_MANY on a system where CMA is only
> configured on a subset of NUMA nodes.

ow.

> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -1864,6 +1864,18 @@ static struct folio *alloc_fresh_hugetlb_folio(struct hstate *h,
>  		gfp_t gfp_mask, int nid, nodemask_t *nmask)
>  {
>  	struct folio *folio;
> +	nodemask_t local_node_mask;
> +
> +	if (!nmask) {
> +		unsigned int cpuset_mems_cookie;
> +
> +		do {
> +			cpuset_mems_cookie = read_mems_allowed_begin();
> +			local_node_mask = cpuset_current_mems_allowed;
> +		} while (read_mems_allowed_retry(cpuset_mems_cookie));
> +
> +		nmask = &local_node_mask;
> +	}

For my edification, is there anything which prevents
cpuset_current_mems_allowed from changing after it has been read?  So
we end up with a folio on an inappropriate node?  Or does that not
really matter much.


cpuset_current_mems_allowed is a nasty thing.  It looks like a simple
global variable, but appearances can be deceptive:

#ifdef ...
#define cpuset_current_mems_allowed (current->mems_allowed)
#else
#define cpuset_current_mems_allowed (node_states[N_MEMORY])
#endif


Thanks, I'll queue this for a bit of testing and shall await reviewer
input.


