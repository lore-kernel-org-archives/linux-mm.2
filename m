Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C8186111227A
	for <linux-mm@archiver.kernel.org>; Thu,  2 Apr 2026 03:02:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EC2FA6B0088; Wed,  1 Apr 2026 23:02:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E99DB6B0089; Wed,  1 Apr 2026 23:02:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DD6C46B008A; Wed,  1 Apr 2026 23:02:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id CE2996B0088
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 23:02:57 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6F02E160169
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 03:02:57 +0000 (UTC)
X-FDA: 84612118794.04.4646215
Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	by imf10.hostedemail.com (Postfix) with ESMTP id 24EAFC0008
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 03:02:53 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=qAG3p++B;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf10.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775098975;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+Bm/iZ2SZCt+AC99FFO20xgoljQ3GBYc4xpX0mliCyE=;
	b=7sBeXYoDCkgBJAsCMTNcXMyep1AZ+wKigEWqAYqqszQX2k/IoN396qESGph0U241a0QHz8
	KSy5wUF1P6rVeIhdeK/nzRL9/HoGKgjotBL4dfnsHteLIENLIZ2wZBeAgZfhw8gtEgoYdb
	/1ARgZb6DzvutiRRIjWkVPUsyaN+Q5Y=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775098975; a=rsa-sha256;
	cv=none;
	b=Qi7guNeOeZ/IdnP7ODs+YeE8a/WlWj4ZMb9ZJWxdgMRe/9wqgBZZPo6xk/RiTSk4gDhtlM
	68bQCK/dS5W5sOU4dGeRutIkokpwatfgMwegcMAoFrVpI28kuKpGO+30TjqNHVBqyLnWpy
	7AlkObq5bsMY54Vg8BaMFqRlsts5arU=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=qAG3p++B;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf10.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
Date: Wed, 1 Apr 2026 20:02:44 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1775098968;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+Bm/iZ2SZCt+AC99FFO20xgoljQ3GBYc4xpX0mliCyE=;
	b=qAG3p++Bsn93CJPXaIZuqnQ12F2PgI1xcdGvaWN9uz51Wg/uVQ+KMak2x006Ut5RGPdaEA
	6rUxxQD1zapneZCktFQMnMPeqR6jhY599/Ohfe0J90Lup/dUWK7w6fyPdgaEjd6j2St2kH
	K0DDzCKAdWK3cGmrWYb3ayXGCBfAd/I=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: "zhaoyang.huang" <zhaoyang.huang@unisoc.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Michal Hocko <mhocko@kernel.org>, "T . J . Mercier" <tjmercier@google.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Zhaoyang Huang <huangzhaoyang@gmail.com>, steve.kang@unisoc.com
Subject: Re: [PATCHv3] mm: remove '!root_reclaim' checking in
 should_abort_scan()
Message-ID: <ac3cKKNhnFH72nw9@linux.dev>
References: <20260318011558.1696310-1-zhaoyang.huang@unisoc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260318011558.1696310-1-zhaoyang.huang@unisoc.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 24EAFC0008
X-Stat-Signature: 4heh86dnbq9164qb43radgh7ttmo64gc
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1775098973-136765
X-HE-Meta: U2FsdGVkX1/cdsFEYRlWDlq1KzUuUBXto3vhZ3FsXLzjUBzDl1vpTr7aGmi4fOpkcCNV3uf2FKU4+s4w5lp+r36/HP83Fj6KmaFWUWkOqBiPeKAioUBucWq5a4ah/c8eouXQBs0dyxlQpDEKjB2DKigGmi68rsYNLN/UVNDCTdAuPPFZYe+g/9YVTmAJKBRIpNbOnBcP7/KSCAzYgUnN5+jpkYJQFojL22S960ZmBN8JsDCHprrvtO1azyHfLqPrsPKVTR317K50ksTH7yLTzirE0u2BqU+Mj1z2hcOeZgKX6ZFLzF1fcO73rm+rxfyEcwN6TuMxcaLmJyM9pVAJ6jqWGGrnrPSQph9HwRHa/0EpoTY20GT1GlTEars5pBwg/BnjyVfvPd63iOTV+1YBsXtVbWRficUHL2XS17plDHDeF1X+uYptF5ghGpX5cgb8qmLk9ExyRoaSpkNAkFb4xIIZvf8O4wfe29Ye0eLU2Z5MStfKqsIloQDZVwgTJfqlWTLXYhLoo/pSRyNqVUNV33xd2vVxJkrygqMOALzMfAtL+/Z8N/Jzm8k4Ioygwqd7uIEu7O7m4m+l4bI4hUSGAe7nEGP+jZ9ayK5QXEHo/KU71heH+8Uhz+y0PT5WstorVqEeO81Wx9mES6N320hnku7w+mH85uznmtPumz2O33/9nDyRd8xVvaDz3wWbV0Q5+wwBJp+cRErnuv2dzNy9+q4cJpyk+evdGXDq2WPDxhwYAIDothOjZhTAgr9kakD6H4d6oQKnSqUfDD9mRPDBOISJyS0aYgCRJ7MK2gv+LjrfmEvNyFw9hp1GmUHEeM+IurCtr1dq1MK4aG8G+A2xVF92K17HyrTWxWJpFvkJTdqZ1lXtvZBxr0q+12w28ky4IYqD7V7Nx//yyIGZZlbGA1UZsgqB+fXEOlfjnfYfT8uY+fB2mOaVC9o3e26b6f4cF8n3moKQQZdvJx/7J9D
 Rgs6TRMm
 5HSmq7bWckTYNVoSU5lPQHGX0Ql4tidC4ott3iMW0wKJAPcKxa5ufKQI+Ooa413Opix8F3h6xZFB8q6YsUavEv0B5cFuxehwEukTKuQdxPfyMXs4KaKluPxvzcScBmzx2egqBy0XDWXvuB778CebaOqxrrWA+t/wxUX3jr4LWnVRH+Ro0LVc3FlCWp4Eh/ZrOqUYttVA0FTZgtkf1jsbvWW+4NPB/hWHdNq0wPW6vnC/wPo77loTpNxxBky4G8cb3LwcAaLdAivrhPfPtJ6DOuhpj45QaAEEKTJwBrWmIXU2/W0vC9BazrnHaDXc9kbNkYfgI2K04+mHVB0yS1cmHbiU/BOXrDchq7TNrgV/DnCeY5RzNZbGNJbd2ehTFJnw75LPk
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 18, 2026 at 09:15:58AM +0800, zhaoyang.huang wrote:
> From: Zhaoyang Huang <zhaoyang.huang@unisoc.com>
> 
> Android systems usually use memory.reclaim interface to implement user
> space memory management which expects that the requested reclaim target
> and actually reclaimed amount memory are not diverging by too much. With
> the current MGRLU implementation there is, however, no bail out when the
> reclaim target is reached and this could lead to an excessive reclaim
> that scales with the reclaim hierarchy size.For example, we can get a
> nr_reclaimed=394/nr_to_reclaim=32 proactive reclaim under a common 1-N
> cgroup hierarchy.
> This defect arised from the goal of keeping fairness among memcgs that
> is, for try_to_free_mem_cgroup_pages -> shrink_node_memcgs ->
> shrink_lruvec -> lru_gen_shrink_lruvec -> try_to_shrink_lruvec, the
> !root_reclaim(sc) check was there for reclaim fairness, which was
> necessary before commit 'b82b530740b9' ("mm: vmscan: restore
> incremental cgroup iteration") because the fairness depended on
> attempted proportional reclaim from every memcg under the target
> memcg. However after commit 'b82b530740b9' there is no longer a need
> to visit every memcg to ensure fairness. Let's have try_to_shrink_lruvec
> bail out when the nr_reclaimed achieved.
> 
> Suggested-by: T.J.Mercier <tjmercier@google.com>
> Reviewed-by: T.J.Mercier <tjmercier@google.com>
> Signed-off-by: Zhaoyang Huang <zhaoyang.huang@unisoc.com>

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>

