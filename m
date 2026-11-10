Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7EDAB606A32D
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 16:10:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=l0OBpzVC
Received: by kanga.kvack.org (Postfix)
	id 806EF6B05B1; Tue, 10 Nov 2026 11:10:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7DD066B05BE; Tue, 10 Nov 2026 11:10:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 71B736B05D7; Tue, 10 Nov 2026 11:10:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 534A26B05B1
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 11:10:46 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id CDE10120958
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 16:10:45 +0000 (UTC)
X-FDA: 85419697650.19.6DA177E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 3A806180003
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 16:10:44 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=l0OBpzVC;
	spf=pass (imf06.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794327044;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cZL1GthlzVtU2QKypsvLAA1E2TIUdiH1wSAT/Ld8YiY=;
	b=mLL4Vh8Pw87WtCGvUkKBL6xRmWklFgnYIgD7/tsB/typvPsc00etl+zzJBzOrgVUSf2WI6
	OMwKDRsYjJZafY5EvsxE2GfQnm4ccEJFwchtvgGpQFW2VZ9qz2Dk5y4ooZw1XYIic/4K8J
	P/l87MKWqH6U2wBxpUcB0QmGuyhm3RE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794327044;
	b=nTGoVEIsJaAP0kXMWtRPvn3rb0y/ZRPDpC6KbcFaDYWTDeDs7fjX369x5UwtD1/9e/ttMY
	sRgkPluMEwE1RUZWH9GlbWkgAVOj7oNuzi1LlblW5rSL/iwHAJDOzY/erz/U+QfVYtQYpq
	tJ+IzR2ja1fJwKUPziRLtyJyNreWyIY=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=l0OBpzVC;
	spf=pass (imf06.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8C53C63A1B;
	Tue, 10 Nov 2026 16:10:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 864431F008A1;
	Tue, 10 Nov 2026 16:10:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794327043;
	bh=cZL1GthlzVtU2QKypsvLAA1E2TIUdiH1wSAT/Ld8YiY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=l0OBpzVCZZWsZt2XAltyVbrbIzt5LGZb+Zels/WrgDajA7VfcwELTAKXHG0z6bsIy
	 EUVRe8qhbce+Y5D1s8r0lqE2ppx/pGp5vaWion6pjrOZnXOzyE5X031rJ27g+360LP
	 GCp32fWpsvktlMh1Wj7KCZ2FVT4KcxntUkPxc3C8mC83LNapHektuVVqCPiP1m0fFs
	 54Jxud/lxeNt8ejpg3FF5lCWK4FzMQc5QZ0RG4Uz83nDrLxHyVzsfDD1ajMdl9T3Eh
	 VP4wxU1bhehp+KZQRCJwImI2v0N00C7XCt7I3BtUeyCM6qg9ETYzjyZpunzWDYmTPF
	 uVz6ALmwcFVdA==
Date: Tue, 10 Nov 2026 16:10:38 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Sarthak Sharma <sarthak.sharma@arm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Zhen Ni <zhen.ni@easystack.cn>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tools/mm: add page_owner_filter to .gitignore
Message-ID: <avNBw8RTBOoEL9Vg@gremlin>
References: <20261109110139.216653-1-sarthak.sharma@arm.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261109110139.216653-1-sarthak.sharma@arm.com>
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: 5jmcfmsufqpfm3tuigk7oryfdxduptds
X-Rspamd-Queue-Id: 3A806180003
X-Rspam-User: 
X-HE-Tag: 1794327044-762842
X-HE-Meta: U2FsdGVkX19a+yyauSekLYPrhfmz7G6VldPR4pxXEY+Um5eZbGulnFyBFF/j1iRjUMWT5juzg/LSmNIKP2ZuI9gC/nYjfPEHuiY+dlKigDeCAOKLW4xAW/CSs6HdYmk5OdJYlRY0UvT5VX7jAdfXPK2gkS23/gxqs4ujaDx9nWmxaTfOA8+HJXT6DKt9J4/PF+LQY62wU4AREUlfLm0VsJtF2gIGGiUwT28v+dyHxKjlwkCjNdZQbuF+zF9pV50XWxB2bb8BM+ZBcBxv0VvWbGW5xMkf6PsfCbKXiBdtUy1DoR2SwPEHwG95+0+hTwo6nTyZh+FkxUb7xe9MjJM8vfdJWVcAyiDewJb8ajGW28G8djnaC3pobHiiUj9cbTWY1zpw5ZH5THaBvwCbPmTAZVYxwNlCbHDOEiHDg5XMD1ucnQ0HwLb/7TemZ7ozH+rErnyRD5k7RLU4169uY0zFA3A9eAbDL0QeFYjrF/U0R2eXmizPmpRL6k9P1K/vDXueweaiZ9fRSebfmtHO4VZKhv8PxttvlMvMVH6a5o7WuER8LbxDoOjtRmmEjojiC+fjLRUaZeKdOkZtJGOV8E5T+kOczXSZeJznl+QJkdrhQewxjWLx4m77/sA97ifu2tlBaIU0JXmnIiqP/hsIvgs4TZNqG/bXo/ev77k0eiqHi2i/Zx+pQQTCTH3ebkQeTxoKFWq3qTRRPG8qSTleuKqdEuG7eyxb8pjScXcovvoRv+zogGTLhZkoxeXXppvBV881gZdwIQBvfxi+cVta15yxfno+gBmQXtBufOQQ7B3p87NoE4KESbuoIkCfXY7eCEMriS8lTfFKGlpEHOWV/cN3VW4IbnQdqy9YWq1RIud/B1nKuHFS993V8ic0Jx+fP/2Q5pp49xpwo9+wV+enamgVhRg7NVpmB52zzXj8+fbLeYsCtlpE9Mi959LcolZEiuMtiiZ1rKEVBq5gWujGMrL
 J3nfNSJ1
 6Mv2M2cHdBu56VhGTba26bkggAJDpI/CpD8CZ4ejwk21vd2kHJVYPtKT5JW3Dk7BTfZLZ10Jy11HMt3MnzV9CRK1zjmy2l95Qtefln9OJHwGWpCcD6BloCiU0XwELKd1rPckIsjln6VFLfBrRKrmmgG8T0IikzpAVokk1zlAMhyZgLVh2Eo3c6DbqJ5qulDNXotXRKuZYaubLnKQINE0rtudQC1krIpEDWvRPXi5HYKL/jTeBMRSRNMPptpWP/KTW/ytle5IPazprorWoFqvMh7ppN8UM14em2ruWESocbkcPOXsUQZsW+MDllsLSe3JgF0h+tmn17hhin1HIoV8/LiWB+jtmN2Px08Zegyrq4kMEl1k4WYOGXEv6lGwZi7i2RuQD
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 09, 2026 at 04:31:39PM +0530, Sarthak Sharma wrote:
> Add the missing page_owner_filter to .gitignore in
> tools/mm.
>
> Signed-off-by: Sarthak Sharma <sarthak.sharma@arm.com>

LGTM, so:

Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
>  tools/mm/.gitignore | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/tools/mm/.gitignore b/tools/mm/.gitignore
> index b4ac68a08e1a..2d08f713b664 100644
> --- a/tools/mm/.gitignore
> +++ b/tools/mm/.gitignore
> @@ -2,6 +2,7 @@
>  slabinfo
>  page-types
>  page_owner_sort
> +page_owner_filter
>  thp_swap_allocator_test
>  gup_bench
>  memory-failure/hwpoison-panic
> --
> 2.53.0
>
>
>

--
Cheers, Lorenzo

