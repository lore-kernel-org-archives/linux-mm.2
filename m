Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 11C88606A31C
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 01:34:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jh3rk3Xp
Received: by kanga.kvack.org (Postfix)
	id BFF016B05B1; Sun,  8 Nov 2026 20:34:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B87586B05B2; Sun,  8 Nov 2026 20:34:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A4F716B05B3; Sun,  8 Nov 2026 20:34:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7ADA46B05B1
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 20:34:20 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E8A4AC0555
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 01:34:19 +0000 (UTC)
X-FDA: 85413860238.15.F7EC07A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 380E880005
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 01:34:18 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jh3rk3Xp;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794188058;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P9mIQUIH1/VtE8KssypL0uyUPENa+cPXNJRrVIDQBdY=;
	b=5mpidLarX5nirR2QG4qGNkVfRSj20iDOGqGDAU4YnHCi6xKeCEN8xDlnYWPQy1BvEypS8D
	obOi8d1NR/lhD8MITf1QnhYRL/X8aqaWdYo+r4Z7BTCF9dIkgGkzmsGnpUp2ZqcBLuiyhg
	reDtPOn/yGTyvEPA+7VUoPAQSYviA+o=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794188058;
	b=k+bzx1MtBC8eh29STlvwDQb3/PfBZKLIKseYH/CFzXJW5z5ophmfw+o3qTYpiAc5ofuNkU
	FN1/j8rLzuQIdoV13f5PyGS1TJoBeAKmgIlitHLx8ef4k+LIPukv2BwbCJrDJIEN8bO1vU
	5OvrAPtorcuNZ3sSEN6LuVjbYMh3T/0=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jh3rk3Xp;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 64D1041632;
	Mon,  9 Nov 2026 01:34:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9E351F0089F;
	Mon,  9 Nov 2026 01:34:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794188057;
	bh=P9mIQUIH1/VtE8KssypL0uyUPENa+cPXNJRrVIDQBdY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jh3rk3XpcSN7vU4AXRgZkgo8yoWHwTmboSdc6Nyng88WPf7hzBQdEYoNFXwuSobIL
	 cHceujZMIuWsYUi/UMNS/aqVOSWoWIQjhM+Cqo3IL7WVWUwOm68jySBJApVBGOdLMW
	 1Yn+krmFbsI5UiVo4mkGvex25kezmH7uC8dX8LpqCJJXnPIdFDu7asazWtxwJFxFJY
	 bmolrphjMZ7ZVtZWxa04UqHr05FhRMfvb6Kj5644DlI57GxUJ+WgjUE9rAStpsqHHm
	 HzKpdDf/HeFAMdh1ei05mJfyvFK1ToO/mwEjFSI4EGXCCqeo6dN4Xnq6C3F6BTW5sc
	 f+GDhSl2Uc49g==
From: SJ Park <sj@kernel.org>
To: sashiko-bot@kernel.org
Cc: SJ Park <sj@kernel.org>,
	"Andrew Morton" <akpm@linux-foundation.org>,
	"Brendan Higgins" <brendan.higgins@linux.dev>,
	"David Gow" <davidgow@davidgow.net>,
	"Quanmin Yan" <yanquanmin1@huawei.com>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	"Lian Wang" <lianux.mm@gmail.com>,
	"Kunwu Chan" <kunwu.chan@gmail.com>
Subject: Re: [PATCH 6.12.y v2] mm/damon/core: handle uninitialized damos_quota_goal->last_psi_total
Date: Sun,  8 Nov 2026 17:34:08 -0800
Message-ID: <20261109013410.93127-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <sashiko-outbox-204294@kernel.org>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Stat-Signature: ywsh6f68cs5n6zgpss8sggiomj6gerxo
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 380E880005
X-Rspam-User: 
X-HE-Tag: 1794188058-942432
X-HE-Meta: U2FsdGVkX1/rafxH52UMziC6rX34fWmN0TtHXszByBpsYWNM8tLIzq1eoSijqURRlnKtH+4MojqmHCdclqKrA7sRj1sqlTZfiuv2c/1aKvUXwZ/8jn8yJxYsib+1uIBRRNUBpMEfsQtcI6w7BSTMwuuv6I2pMhEsCil2hyGLyTXyHPcuHRBSA8yXA6sr5YyJRw1SfVmcDECIFsvr5LxzcKK+h+NCuzmcG2XAWix7mRfrgKAxcqjnwgyudkRz9tMzfzZy9Tmqi5hp9LzgUCpI/GTN9C/dCHamNKfsm0LKkI+8Tswnwz21F0Mgtd04tY7MQePrV2Xqmh8oQPAUHzh0tMqlWOIGFCj7/LBZCIxfUPyMpQpg0gC1AbR/q3IBTVMslG00mHNihlp4vykW0mYDG94n8MphUf/YTU37W/psfR2FYjd0BhyHc0F8YNuF1/I+n5bVXiuVF0MPlgk1O6CAZxom67y+iE9GhsddCn+ZEFv/TmxsiRwWtbHysypxCWhcYzFrNenYj0w80v8KccBH3eKgdo+as4Y1rDOGe/c8RuNgtxaDh/laRxKL1P3phUQSR7doeeSRgNaNcCmOCsNDxYwKz8Be7jILuELEIbOlinBO59LFeMCi+UhLn+wMOKxxejdm2q8UlFz2rhYSK4VCpgS0PC5obFMDpxXwmFY2BSRWXMl8Ga7yi4B5MCnuL+VUZdzWlRHZJGRe0z/SXJgcky6eNlbNG1EmPS1QXO/cpESj36rttuu5ANCrc0nD+MxH4Ez3c0X9KjoS9WsWNvyIS3mpJC9ScNr2Uz0n33J5GDkXnVORgSzUmB2DgIY9TUAV3A5PfVsYvYc3b8ufJmtHOgHnh3A7LcZvJKWJvtbmRJsDwYKpRWBskKIkNoImAupoLuaP5XoeIRFIOv0XZ2mLhGzodklqSyJb70YL0rUQoT/ytc0xaj7e/pOdR+HSQLTAw/zdhTYc7ccQaSB00IU
 c+cN19NV
 UVSpZkauH+VwoF6svxZqZIaERp8/yQPI/BXqtR/e/4PishAWssVkj/3f7fF/HDA7GG6AgtpAPpCgzA0rbdzqk3zJyESNPjccyj8EOeHilt4cVisDH09j5Ocp0Dk9In8w+MEvDUHafsfA6odiCUYcDYXF7/fYCj0OA97iET77+0h3HkFQ+9ISVJuNCPAPMsZb4qaoT+7tjJ7MQZXdHJ4TJAht7C/gQhN1kYCDk9pSRRVCwduxMASd7iRKT1Xbd/vRNQlw2CoddDpP/F0C8lOGgwdZt3tvo0OrOwccmJnih+CudSh3qin3qGWuDaDJDsmVN9uCBT2uDfsf+dODGZp3h8tE102E64Wh48dS+97icTL+ZbzgBdcjWlOzDuD6+7MYrmivibZ6Mr0hG1IoIfA7RCd3LOybkOjhwG3SFUBA4RTaWsHkptIg6Mz9OfPMnuVKZEnu9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, 09 Nov 2026 01:28:24 +0000 sashiko-bot@kernel.org wrote:

> Thank you for your contribution! Sashiko AI review found 1 potential
> issue to consider:
> - [Medium] mm/damon: integer overflow in damos_quota_score() on first
>   PSI round
> --
> 
> commit 5e9b1f636c184ecf41e05d717ad5e0116b0fca20
> Author: SJ Park <sj@kernel.org>
> 
> mm/damon/core: handle uninitialized damos_quota_goal->last_psi_total
> 
> This commit initializes damos_quota_goal->last_psi_total to U64_MAX when
> creating or committing a DAMOS_QUOTA_SOME_MEM_PSI_US goal, and sets
> goal->current_value to goal->target_value on the first tuning round so the
> effective quota remains unchanged until a baseline PSI reading is recorded.
> 
> Link: https://lore.kernel.org/20260902002725.108635-3-sj@kernel.org
> Link: https://lore.kernel.org/20260718005316.89585-1-sj@kernel.org [1]
> 
> > diff --git a/mm/damon/core.c b/mm/damon/core.c
> > index 3142776e2e0ee..420ef0adaa7e3 100644
> > --- a/mm/damon/core.c
> > +++ b/mm/damon/core.c
> 
> [ ... ]
> 
> > @@ -1616,7 +1619,12 @@ static void damos_set_quota_goal_current_value(struct damos_quota_goal *goal)
> >  		break;
> >  	case DAMOS_QUOTA_SOME_MEM_PSI_US:
> >  		now_psi_total = damos_get_some_mem_psi_total();
> > -		goal->current_value = now_psi_total - goal->last_psi_total;
> > +		/* uninitialized last_psi_total; make no effect this round */
> > +		if (goal->last_psi_total == U64_MAX)
> > +			goal->current_value = goal->target_value;
> > +		else
> > +			goal->current_value = now_psi_total -
> > +				goal->last_psi_total;
> >  		goal->last_psi_total = now_psi_total;
> >  		break;
> >  	default:
> 
> [Severity: Medium]
> Can setting goal->current_value = goal->target_value here overflow in
> damos_quota_score() when goal->target_value exceeds ULONG_MAX / 10000?
> 
> Unlike mainline where damos_quota_score() uses mult_frac(), this branch
> computes the score with direct unsigned long multiplication:
> 
> mm/damon/core.c:damos_quota_score() {
> 	damos_for_each_quota_goal(goal, quota) {
> 		damos_set_quota_goal_current_value(goal);
> 		highest_score = max(highest_score,
> 				goal->current_value * 10000 /
> 				goal->target_value);
> 	}
> }
> 
> When goal->target_value > ULONG_MAX / 10000 (for example, above 429,496 us
> on 32-bit architectures), goal->current_value * 10000 wraps around and
> produces a score below 10000, causing damon_feed_loop_next_input() to
> increase quota->esz_bp on the first round instead of keeping the current
> quota unchanged.

The issue impacts only DAMOS quota auto-tuning quality under certain setups.
No blocker for this patch.

> 
> -- 
> Sashiko AI review · https://sashiko.dev/#/patchset/20261109011347.92467-1-sj@kernel.org?part=1
> 


Thanks,
SJ

