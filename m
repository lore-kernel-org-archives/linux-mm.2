Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 103A21088E73
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 04:33:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 136476B0139; Thu, 19 Mar 2026 00:33:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E6B46B03DC; Thu, 19 Mar 2026 00:33:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F17CD6B03DD; Thu, 19 Mar 2026 00:33:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E199D6B03DB
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 00:33:20 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7A889C18A9
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 04:33:20 +0000 (UTC)
X-FDA: 84561543360.24.FB3ED45
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id C9E8B40002
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 04:33:18 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=g2eTnLoX;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773894799;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1HA/wokBvO2I3jQRTvWt70R4smjQwwyE31Cx5ADoAuA=;
	b=1Xinexf37K3kHg5Mz189BP1wikNwYWKXmIE5/hC5OrgrA3i4OefnReABiW5r/tgkEU8yTp
	fNRa4fv3heIHZsqnoZ6F7vSoeqvUQRtll6wonKR/q9awSGU8VtBP6LAiQ88iUi/U+a9Uxn
	NrXG61tGeUVpNPC6TdnOeEFEB3V9k30=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=g2eTnLoX;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773894799; a=rsa-sha256;
	cv=none;
	b=u0HhrKmGYPo54o2mo79QSmNQKzfeeKUn+JRL23PZrR2e8HfXEPfr1lioa+HV1eCFr057yz
	ikwXSWyqZpJ/3vsM2coi/GKwLx58M2HT54WFmfLBbT4kxqFQlh77FewDvPCmKUl/FT9nR7
	2gXvwfj9cWfA+jBmh4SZ2p5BLN/mwkc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 954F843798;
	Thu, 19 Mar 2026 04:33:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5363DC19425;
	Thu, 19 Mar 2026 04:33:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773894797;
	bh=mSNgVn5RpvDCA5+rZqK/Pe5nbtq8ZzrNpNEVCWcL2b8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g2eTnLoXM7MeuOic6YYUAIoBIl+CCfhXUeLKJqY8v7eAG4dnZ0VpNaOcq/dNipV/3
	 j6BjO+YeNVCtp7UdgUDzdLxIazTE92++kiFSZQIQjEj6yjCEX0wx8CSnDT3FTx3000
	 qqruIXUHh525AIEfz8fGR72QsW+bMkgJhn4TYPMhk8watPcWFL/I+gLiYix7H1RN5B
	 cvUWBTuhSTLX8YEpeGsaUsqKJk67Qr6DFh+dvx75i+5UsMN9n0Qpg9D2AJSrISpxEh
	 sU5yCcjvrR3LpyvU0eR+5/BsWaA5I6Ewd2R3y3Cp2InlzpE+BQe+ful6NDGJD12d33
	 wDTgLCa2gPkRg==
From: SeongJae Park <sj@kernel.org>
To: Josh Law <objecting@objecting.org>
Cc: SeongJae Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/damon/core: reset nr_dests on allocation failure in damos_commit_dests()
Date: Wed, 18 Mar 2026 21:33:09 -0700
Message-ID: <20260319043309.97966-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260318214939.36100-1-objecting@objecting.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: C9E8B40002
X-Rspamd-Server: rspam08
X-Stat-Signature: cduybp47nndejdwnu39u1dsy5ugueigy
X-HE-Tag: 1773894798-641178
X-HE-Meta: U2FsdGVkX1+Q+d0ERavttLrjPzNbS5y4ndI6LERYLiq94Vs1DNBGm+w9aOxBQZr2nnaKXoEdmhQuMkJtmXOZllrv4dRnNCoP/QxMZiFMzYKof6FUywN3PBIjf1iJiawGrpQ34MEj9sbv17uWQxURE2vctbzaarFG1TyQz1z2tm9RTlXetm4SOpzbNrQjGRYLeqaYNZ3B52YipgG5R00rSPPpoCsRDOmv3X5Nv7B86p62dl4pieZZKyqGDV1TogWLFpurVCFP6wpz8qNVBeenvVqZT/roVD+GkzvmdkYegC3JM/Osgu+fB0riQ58p/bph66pWVmtupkQSvXc/AbqqNL8NusQKKzvVv2Tx5PjJHkR4WOFI03AxsPqutCdWPbDLbrB6mKmki6RbEszrnOV7IVutjdrFjsPbw9+q7EyMlfOVol/dXd4DXU2d/p2S+8OZTW2hsh6HTQBvuo7Rgj9OYSf4j0jSheY8rr/pBajrXFpMzO8Zl6qk/z/hgtjl2RHexI5V8EDTM3B3WcdMotImls1fbuflACPIrLypRzS/QceXcKg0BAeb/VN6n5RXJ8b+W8AdmM7SJM+dQJljjNDZpmtVUFpcgZr5CXdN3eS/lts1rDqBE9HD3DqjuZAi/hUz6R5d1T9ZPTJ3H1rg5rYhGjLXT1LGMwep0Nb9o73AzOQaSoBI3eaDLwcvlBXg1sbpe9aOIOt8Y7kOd5hev6aC1wZlvqsZbCler/LPa8Jzau7BIvrAQarn5U0rcG6XwEaxlYv6rzgPOaZ/XysCpyiYdIU66q0WKTETIkClY5UBWZAlUJFzbFoUpMt/TDQFplN1KN88cN2+K37yBNMuD1z9IN1aAvMIULvWgh8mwqvh9jQ0PP9f2tnEVeGuA3vmO8N6JRE9n5Gp7/kIjBRpMjZnZd1SUz2srAidH/C3CsolmJTUxhdyp1//VBFlrVbCpUZ5hgd1nLc0ZEkmD5iSFjQ
 5IVJypph
 Hf7rLGT02QUjo43NnJxO/vHT3KU4rBSx3M1P6NuvMt4SPrh3Sd00LXbIvY7XqNLlruqaROGU9+nMbgxpjb8VESFnS3jmSGshmuubPn6AgSBCj7+l2W4a1J1MhNMSVYnzvD7UI+ub4WRbh7Bn6hZOkjf1kglO1+bW3wSUxH9uSkK3UHQ1Fzyqj8NHy/0hE638sA7Elt0hkpe+owyVavtxtbHI3FmYn2jNX6Cb/rYmDJ6s1CXuPd2eDd8ToKqfabJheVM2JKpccXX8E73wbcHFVsPUcrSHAtrSH3Rr79mQJDxkszpTSkRtrnwx+Qw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello Josh,

On Wed, 18 Mar 2026 21:49:39 +0000 Josh Law <objecting@objecting.org> wrote:

> damos_commit_dests() frees the old node_id_arr and weight_arr before
> reallocating.  If kmalloc_array() fails, the function returns -ENOMEM but
> leaves dst->nr_dests at its previous value.  A subsequent call with the
> same nr_dests will skip the reallocation (the sizes match), and the loop
> at the end will dereference the now-NULL array pointers.

Nice catch.  But, this is a sort of intended behavior.

The idea behind the code is that, if the function fails, the caller will
not resue 'dst' but discard it.  Hence the function is only ensuring the 'dst'
after the failure can be deallocated using the deallocation helper function
like 'damon_destroy_scheme()'.  For this, the function is setting weight_arr as
NULL in the allocation failure.

> 
> Fix this by resetting dst->nr_dests to 0 immediately after freeing the
> old arrays, so any later call always enters the reallocation path.
> 
> Fixes: cbc4eea4ffb5 ("mm/damon/core: commit damos->migrate_dests")
> Signed-off-by: Josh Law <objecting@objecting.org>
> ---
>  mm/damon/core.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/mm/damon/core.c b/mm/damon/core.c
> index 7f74982535ac..e233eb84a2d5 100644
> --- a/mm/damon/core.c
> +++ b/mm/damon/core.c
> @@ -1060,6 +1060,7 @@ static int damos_commit_dests(struct damos_migrate_dests *dst,
>  	if (dst->nr_dests != src->nr_dests) {
>  		kfree(dst->node_id_arr);
>  		kfree(dst->weight_arr);
> +		dst->nr_dests = 0;
>  
>  		dst->node_id_arr = kmalloc_array(src->nr_dests,
>  			sizeof(*dst->node_id_arr), GFP_KERNEL);

Someone (including a part of myself) could argue anyway initializing the field
is better to do, for code readability and completeness of the data structure.
But I'd argue that might only encourage calllers to reuse 'dst' after the
failure.  Also, the 0 nr_dests could still meaning something incorrect, if the
first kmalloc_array() for node_id_arr success but the following kmalloc_array()
for weight_arr failed.  In the case, nr_dests is zero, but the size of
node_id_arr is not zero.

I think the intention behind the code is not well documented and that might
confused you.  Sorry if that was the case.  I think this could better be
documented by adding comments for the function.  The single line comment in the
function body was for the purpose, but having more detailed comments at the top
of the function may be better.  If you'd like to send such documentation,
please do so.  If not, I will do that.  Whatever is your preference, thank you
for finding and sharing this room to improve!

... And, this patch helped me finding something actually broken.  As I
mentioned above, callers of damos_commit_dests() are assumed to discard the
'dst' when the function failed.  And the only caller, sysfs.c, does so, except
for the final commit to the running context (kdmond->damon_ctx).  It can result
in DAMON running with the incorrect data structure, doing NULL dereference.
Similar issue might exist for DAMON_RECLAIM and DAMON_LRU_SORT.  Because those
modules use only limited parameters, there might be not.  I will double check
and make a fix soon.  Again, thank you for helping me finding this issue, Josh!


Thanks,
SJ

