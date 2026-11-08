Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 33EC4606A31C
	for <linux-mm@archiver.kernel.org>; Sun,  8 Nov 2026 20:25:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ELqru6Ia
Received: by kanga.kvack.org (Postfix)
	id 531E36B05B2; Sun,  8 Nov 2026 15:25:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4E9BD6B05B3; Sun,  8 Nov 2026 15:25:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F81F6B05B4; Sun,  8 Nov 2026 15:25:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0302D6B05B2
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 15:25:37 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 36FDB1204C4
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 20:25:37 +0000 (UTC)
X-FDA: 85413082314.26.A9D807C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 81CB240005
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 20:25:35 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ELqru6Ia;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794169535;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lUqT5v8YaI9EUU1s6fZT3bdyN4xwYNxjDjc2jWcGBi4=;
	b=VH2ICJeVdStSBM08rVyQ2gfbW4jdRMX2TL8KqUAmk12P9tiW75CW+IrqSggd5KUYnIm7gi
	8UVQkqP9Brc1N8sd8ZcjX1HY88fk02rb1U7Fo80AEFaFRi70sAChavV3bZ7Xt777HfJrCp
	nmKPoDKY7AgBvgJEAaZCF3Il3PEHsnI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794169535;
	b=YY+2sY16ge3Vq/WoJXvzd8HY/tVCxybvwYFZ7k6KOS5Tiba4/a7NqAdQKD4So+xbbnonM7
	xhZ1jfoErllYA3p0+ak8zCNxzY4UbAEt4FRpocO4o1YDWxLdsJRHmV/GgSEm4SjrBMX3Gj
	3L7qP/3cKuGHdqWPVr1+iQY/cHTCA3A=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ELqru6Ia;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 00C6261DC4;
	Sun,  8 Nov 2026 20:25:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E2601F0089F;
	Sun,  8 Nov 2026 20:25:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794169534;
	bh=lUqT5v8YaI9EUU1s6fZT3bdyN4xwYNxjDjc2jWcGBi4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ELqru6IaxAwNIZ8+Tc45OFVN6yyuai77lcJeNDhYMvPWKYrBGu4d41U3I/zY1ol0H
	 WMPcex/20VhBcwadogTDxD8Bl3QS+LC7AjmMucLkiWPdGE3kO16JOiUnU+pdlkn8cM
	 YRS4m0yD53aU2X4dmauwQ95vw053MS5vf45A2p+D/Zn1SvOowPTSpLD5g2AqdD1IgH
	 vSS4uhrgAkqn/16fTmentlt99wBOnieuAnYB/j2JSWf5OqGRUMFhkZQnGBmtoZt9Oz
	 4IbrqQzXlEqy+LzN9+rMAKRZurNCv/9w2LG6XJbbyBGM4wejSOUMOr+NIGlK17YjOR
	 4S0Dur2/QI5dw==
From: SJ Park <sj@kernel.org>
To: sashiko-bot@kernel.org
Cc: SJ Park <sj@kernel.org>,
	"Andrew Morton" <akpm@linux-foundation.org>,
	"Usama Arif" <usamaarif642@gmail.com>,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: [PATCH 6.6.y 1/3] mm/damon/core: skip applying scheme if region split for quota fails
Date: Sun,  8 Nov 2026 12:25:25 -0800
Message-ID: <20261108202527.117086-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <sashiko-outbox-204013@kernel.org>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Stat-Signature: 4ptxtjk5n5q94zd5f3bro4iiokphqjda
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 81CB240005
X-Rspam-User: 
X-HE-Tag: 1794169535-515019
X-HE-Meta: U2FsdGVkX185FcxObotux6utAmXvJZaH/KZOl/o849hyPPO3Vvr8658br0CB86McXGcu4tTd1CvzPVvPn0ePLpgZbQ2a4/Kw1bITxpuMirqXTtGSlSuFohr20GtXs4ePCow33e1i9MchFzKsCWS3aiGOBWzq+6x5Z2LrA4dnVQgd2CTEYNYNDQFbJbtu1d8BVJFerihZWFP3P+Vh0OgoxdzyZx+W4jZI0jlZ6z5Bt4AVcsMrj62kXqK7Qps0NDj8Rre58r9ArljUzj4ey9gNylWewaqDp15TYR4jR6nV4JTg+4WJ97WVUv3KB/rGv303OZYwWrt+2h6Z8/aQOciTd5jPBYABVZ2I5g2B+2ywDOSYHCby6Aad7FNOGr84QFOvHd1EVnR1HLX5hSDM0azJC1jdL+ODxjne+rQr5KlSVVwpQ9RLimim80lebk+2qYVs9K+1qyEJrjaQdABp2DRPUfeaCxVHMmy0mgMefemmzRnnYXXV1AcxjV8DaJT83mD5JOPqBPS7KzneTmiJHEOfrvOpC50/O+wV5/vtyJ6bsLRc6ZFyn52KDEyPF0LFpvEEWiwIP3tB9uGPCn1svi2O50wONeYGv9hlpqegu2cNW6DfaHbRrl2/cM5rx9wVY6y/I9yfGUADJltxvzp/OB0wJqP0TDjWyxM+L9MJ9j02vGdzrDFNu3CO21qw0oJGJwJosrr5Pq3jn20DTWXZtJWzypkyAsqQ+tn0KmPvtcUYEseYeG+nRA+cRyTczkvPpyl6FyeulOXkVblXKJGDqRXtSnXyfjRf1mkyvRcNg83MjpleYUT/EpdwStTyFOME54H5/AxypA2axkXI58WOWoy829jZ3J0fC+Mj81znIuAxT552fRlW/U3+V6BYjORe/JwyH8Sq1b4Dx5CSHsYtv5aJKCUv3qf2SDgwjYZiEdiMimshu+tW/CfWuuqWE/XphydoYBpl+5qeb6e/cEp+QYC
 84S8BJqK
 luDnoa3ledYs3mlLqtF1lG1KkkDAHEqjXWCjx6e7GewHxMO5txn7Z3LEhHlVvDo+q98MB+kPen/3XWfxuvIMjbXZu6895BbVd3r0rmeT27J+KarkLI5jADhwb9H6ms+FoMuBzjr4410/BW+zKScUzHvK4YfjyZ0VrueSgJ2+PmBu6e7e6wuSVV16i6d+kn/qK8vOkmkfP53CyiJefTat3DJvEn3bo6NMm66MsLYXVAsha2MS7ia+VND4mbBGnXNTz5CrDRQn0gRQC8rmV9m3Q1OyLMMUO+NVo1eMCe2xoJUsxkFetqQXUC6baGi1WYga6lEUg
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sun, 08 Nov 2026 20:23:37 +0000 sashiko-bot@kernel.org wrote:

> Thank you for your contribution! Sashiko AI review found 1 potential
> issue to consider:
> - [Medium] mm/damon: false tried stats on split failure in
>   damos_apply_scheme()
> --
> 
> commit 17459070b1916b2d77f607f0fb7f0f9158e6224f
> Author: SJ Park <sj@kernel.org>
> 
> mm/damon/core: skip applying scheme if region split for quota fails
> 
> This commit updates damon_split_region_at() to return an error code on
> allocation failure and skips applying the DAMOS scheme in
> damos_apply_scheme() if splitting a region to fit within the size quota
> fails.
> 
> Link: https://lore.kernel.org/20260901131850.98037-1-sj@kernel.org
> Link: https://lore.kernel.org/20260901131850.98037-2-sj@kernel.org
> Link: https://lore.kernel.org/20260718171523.87547-1-sj@kernel.org [1]
> 
> > diff --git a/mm/damon/core.c b/mm/damon/core.c
> > index b5b6d00d7a3b5..9d4a78deaa06a 100644
> > --- a/mm/damon/core.c
> > +++ b/mm/damon/core.c
> 
> [ ... ]
> 
> > @@ -1004,7 +1004,8 @@ static void damos_apply_scheme(struct damon_ctx *c, struct damon_target *t,
> >  					DAMON_MIN_REGION);
> >  			if (!sz)
> >  				goto update_stat;
> > -			damon_split_region_at(t, r, sz);
> > +			if (damon_split_region_at(t, r, sz))
> > +				goto update_stat;
> 
> [Severity: Medium]
> Does jumping to update_stat here falsely inflate s->stat.nr_tried and
> s->stat.sz_tried when damon_split_region_at() fails?
> 
> At this point sz is the non-zero remaining quota size, and
> damos_update_stat(s, sz, sz_applied) unconditionally increments
> s->stat.nr_tried and adds sz to s->stat.sz_tried even though
> damos_filter_out() and c->ops.apply_scheme() were skipped.  Because
> quota->charged_sz is not updated on split failure, every subsequent
> matching region in the walk that exceeds the remaining quota and fails to
> split will also add sz to s->stat.sz_tried again.  Returning early here, as
> damos_filter_out() does just below, would avoid counting skipped regions as
> tried.

Trivial user impact.  The same behavior exists in the mainline.  No blocker for
this patch.

> 
> -- 
> Sashiko AI review · https://sashiko.dev/#/patchset/20261108201456.116824-1-sj@kernel.org?part=1
> 


Thanks,
SJ

