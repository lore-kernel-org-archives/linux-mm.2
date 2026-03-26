Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5BEF1109E531
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 00:10:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B48D96B008C; Wed, 25 Mar 2026 20:10:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AF9C86B0092; Wed, 25 Mar 2026 20:10:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A0FC56B0093; Wed, 25 Mar 2026 20:10:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 917566B008C
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 20:10:56 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 36D155C3BD
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 00:10:56 +0000 (UTC)
X-FDA: 84586283712.26.CEBFF7E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 9E0421C0006
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 00:10:54 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lRcY8t+M;
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774483854; a=rsa-sha256;
	cv=none;
	b=MusicBDa8O4ubSRTG+h3A0Rc6xYRxe9pt9fn51CO703Dutoy4mqxR8FzwCTfNx4uGLXnDN
	Vq8V+a6X37wB8Ynky8xveN7kFff907XB+KFnOOzVcn0fbKzoVuUfMf+h/DqmnbMyEJKl9g
	82hFYtMNt1QU+/Dkeynj2E+4R0tMFmM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774483854;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zIkzEcg3JV46r6vMcx0xxcxyU7tRCJld3XnkxZnQRc8=;
	b=xrA1yWhIXiwa809UPN71nEouUOEcp4pq1r/mkj5jibl+gOeVhvdBErR2ts9mGkYus4C5ED
	OFl5IgQpIevyewiP/23EvyIMe7MR6IwXgDIT3IMnJt7xvK6ci1ygxlJ5mc30FGAbGrTGY+
	JTVb5wwGLaayCBeSzbrICaaASFvh/5Q=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lRcY8t+M;
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id EE02E60103;
	Thu, 26 Mar 2026 00:10:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8196EC116C6;
	Thu, 26 Mar 2026 00:10:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774483853;
	bh=H1uJeJjuVLiW2H0lN6tKp4wmh1kXqFB+xJI6QRzxJ7A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lRcY8t+Mgx+XtwOWgVVm+hRYh9cMyMV7cjyfzockwWwAgp/Zq85XQ/qEz/VMgS9Gd
	 LuMvDYEZmXDs5fEBlWfzGWe/3tyyVm/qUEiQJ42RKmgGpVHVy5oKfxtKgqMCsj+v1L
	 3w5UJfPz2aWlMhOMLuMdfdU4UPK3SbLP5iJnTafopPhCnE3lDBWYizkAGZ9lZD6WXX
	 EqPxpzPKHv4SBZ+O3I2uGdDFC04LYYfE6Ni5FbPFYiLQBVwWigjpz+qC2DzvJVhX3h
	 B0XrfvTx/StXzF2gF/hxjvN3qIU8fZK2HaHOJnB22zvkW/EUMgSn5uLhLEb1Lc8Ynj
	 N2Zc4Z0QuDwYw==
From: SeongJae Park <sj@kernel.org>
To: Josh Law <objecting@objecting.org>
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: (sashiko review) [PATCH v2] mm/damon/core: validate goal nid before accessing node data
Date: Wed, 25 Mar 2026 17:10:50 -0700
Message-ID: <20260326001051.76219-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260325155221.202700-1-objecting@objecting.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 9E0421C0006
X-Stat-Signature: u689wjj7u4frqmwimapgefu9xdw77nze
X-HE-Tag: 1774483854-5097
X-HE-Meta: U2FsdGVkX1+RzV53hbhpQqD+xxtQ5El15kS8Sm05yH0vxSW0h4QMAjYzmMCIYQ9ucR/AhDBckQEQuHpLcCu3iHZITBCZPEP/VelmCtoeteJ+GfotSVMcpGtlQTr5YfHzPiJCrSm9SkRmARWii9ASMun/+P5mMMoOaHSfmvchJFuwgJfeQrPDuyHfSR+8jOZwpWz64KK58zZ6OjCoegE/9zgwJ2fkKy57oeu28mQU+yXjJwkAZEuIvw1axYURAs8tBCSkSDYuRS/vHIwFwoIbAzAhgF5yZaZUadolP38F87O3bJuYXBg39KlJiJDuLpi2XDhTVQeyUEHN5n1KZy4sXN5wCExBEmWU83k24t9kWESkjVo5oxMrZjbm5wl8l0fzcAYO6+ehJcwjYNKZ7e1KNcXNWgPGy1ymkDBv5ARzg8LHB+ULS9kB2V9Go9eL+Z9gvxLbdWxn3g5US2iyMiEEL15hbZ6Eqbws7Edx8BVivcO3JKeG7p+G00auxz1m9oPE9Z5yP6kj+t7ZdEaLpmcMmEqorz5vAgbjPmN49zndYuTwEqlDfz18boKDyo//Y/PibjEpenXqjpx05USJUEBONosPgxd4XIvjI1T52FvPocCnbIPirogpVHz5oyyFNnz0cXUozmt9F/lGBVbwK+lNSadk0zHDJXIL3vU/Fni7W+6r36QMiq/NCO+joU5HAc9FnTp67yi5nYbZog3DGQtstxAK0qbf7fZR9VciBzGdNJW8kMxT88YnYfbXAblkHF+XBRFRb7wII4fy4QoalctXBJneOXGTZhy9EyTthtLQIbb5M9UQ0+00d7mSobE9NF8LlAsxbVtXp1y22taORP3FD/7ZC6W/ycRdnE8rtWl52V/q4931nSulp08jjLqfFA4Ug7gZuncoQozV1D7d0ZNtkMk5Mb8u+WlZ2A0hcqAG1c8OzXpnQoRXPccMs83vf4bndrfU6d/3quZi2zMcTTU
 YloTalJI
 sciOcwvPYvWuubsj5blBvZXdWfCEqHFnC0WSsmjw/DkVEoyaWNHEwUqA6YpLGoyPMfraIdt9E+wQP4pk69Of/x/aPcyt+HCN885H1cpJ93blCV0MK9XAVqXigllFUNcoyLVJLzJ2ytzoOnfNKT8VQAKOQFIdudRYH9hIOlWdKW84aSVh5PlSOJnfaIEhuSTb4B1F5TUIk5HS7TRo1qgwzKyZn4t0GB3RD7TSltRawBH7QEPomTnwoz/hLDCTAXUyl4Wg4stSI4YUCMa/fNebdQnS+rt7uZvbyrTZOEdJBZ97z38UedJtimvgLsnmi8nMPWOGwLcKSTb5YvacMm8FoDrUFpm3bUQbGXIYXkwSst+iW9mYIopRjSu+tFA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Forwarding Sashiko review for doing discussions via mails.

# review url: https://sashiko.dev/#/patchset/20260325155221.202700-1-objecting@objecting.org
# start of sashiko.dev inline review
commit 24e25058b8f508495d0b3db33bed16564df7fed4
Author: Josh Law <objecting@objecting.org>
Subject: mm/damon/core: validate goal nid before accessing node data

This patch adds bounds and node_state(N_MEMORY) checks before using
goal->nid from userspace to prevent out-of-bounds access in NODE_DATA().

Cc: stable@vger.kernel.org

> diff --git a/mm/damon/core.c b/mm/damon/core.c
> index db6c67e52d2b..ed45a7443abe 100644
> --- a/mm/damon/core.c
> +++ b/mm/damon/core.c
> @@ -2245,6 +2245,10 @@ static __kernel_ulong_t damos_get_node_mem_bp(
>  	struct sysinfo i;
>  	__kernel_ulong_t numerator;
>  
> +	if (goal->nid < 0 || goal->nid >= MAX_NUMNODES ||
> +	    !node_state(goal->nid, N_MEMORY))
> +		return 0;
> +

When goal->nid is invalid or offline, this unconditionally returns 0.
For the DAMOS_QUOTA_NODE_MEM_FREE_BP metric, wouldn't returning 0 imply
0% free memory?

Could this cause the DAMON feedback loop to interpret the goal as
severely under-achieved and drastically increase the scheme's
aggressiveness?

Should this fallback logic check the metric type and return 10000
(100% free) for FREE_BP metrics to fail gracefully, mirroring the
existing fallback logic used when a memory cgroup lookup fails?

>  	si_meminfo_node(&i, goal->nid);
>  	if (goal->metric == DAMOS_QUOTA_NODE_MEM_USED_BP)
>  		numerator = i.totalram - i.freeram;
>  	else	/* DAMOS_QUOTA_NODE_MEM_FREE_BP */
>  		numerator = i.freeram;
>  	return mult_frac(numerator, 10000, i.totalram);

While not introduced by this patch, since this function is being
modified to handle node edge cases, is it possible for a node to have
N_MEMORY set, but have 0 managed pages? For example, if all of its
memory is reserved for hugetlb or unmanaged ZONE_DEVICE memory.

If so, si_meminfo_node() would set i.totalram to 0. Would the call
to mult_frac() then cause a divide-by-zero panic when it evaluates
x_ / d_ ?

> @@ -2261,6 +2265,10 @@ static unsigned long damos_get_node_memcg_used_bp(
>  	unsigned long used_pages, numerator;
>  	struct sysinfo i;
>  
> +	if (goal->nid < 0 || goal->nid >= MAX_NUMNODES ||
> +	    !node_state(goal->nid, N_MEMORY))
> +		return 0;
> +

Similar to the function above, returning 0 unconditionally here for
DAMOS_QUOTA_NODE_MEMCG_FREE_BP might artificially trigger maximum
reclaim aggressiveness.


# end of sashiko.dev inline review
# review url: https://sashiko.dev/#/patchset/20260325155221.202700-1-objecting@objecting.org
#
# hkml [1] generated a draft of this mail.  It can be regenerated
# using below command:
#
#     hkml patch sashiko_dev --for_forwarding \
#             20260325155221.202700-1-objecting@objecting.org
#
# [1] https://github.com/sjp38/hackermail

Sent using hkml (https://github.com/sjp38/hackermail)

