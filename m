Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7129D606A326
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 05:09:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WiF92giW
Received: by kanga.kvack.org (Postfix)
	id 7AEA76B05B0; Thu,  5 Nov 2026 00:09:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 75F606B05BA; Thu,  5 Nov 2026 00:09:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 677DA6B05BB; Thu,  5 Nov 2026 00:09:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 414B46B05B0
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 00:09:15 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 35935A095F
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 05:09:14 +0000 (UTC)
X-FDA: 85399886628.22.72EA130
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id C503C2000B
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 05:09:13 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WiF92giW;
	spf=pass (imf31.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793855352;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NVjhKhBJ1oUBAreFU+zkJHpDMRywHm7v/hTjYaL27mI=;
	b=Lq81BdsUP5QkzxpZdaxqN6Fh83OgjuI2n2nJ9Cujf0tV3wqzaaY+M0tDkXL5B7Md0jv0ts
	F9rpNJ7V2q1Co0n45Lj9jTGUZNabMlG2SfckgThs8aj5qLToZZa6On2Bygw2zoH10+1k/M
	dFGXP0ted9G8QRTeMCLQffBTFHuV4/w=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793855352;
	b=v3bO1Hyfa4QBjHBsMDYJIkA0GcNgy4u/s2W4YiXEIxOzsDMArWS1/DLlXw/8Cj6ccn8P6C
	/JbePnIvGEJZFVWY9Fm5pnpFiwMX6yH93WhqvXk5I2zjyHujSAU+88609kSeX95fqjMimP
	8CPFxvU0KuWwxBXEX3innmMRaC0qOdY=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WiF92giW;
	spf=pass (imf31.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C2F7C40897;
	Thu,  5 Nov 2026 05:09:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A8081F00A17;
	Thu,  5 Nov 2026 05:09:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793855351;
	bh=NVjhKhBJ1oUBAreFU+zkJHpDMRywHm7v/hTjYaL27mI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WiF92giW9TXL6Du/iE3M3lfYTBW+q3y9PRiWrFooahhHgbSQB5SAz9omhz8hzzv4r
	 sKCHbBpYWl16qsYw67TSaFspVf0/nF1/sruXsNyBUPVa637zMyIjarq+mzqj1btzZu
	 PJ0YPqmdgPY9xSYJt3Pg5L3Vg1TGnTQdmNOvqc2Z9ppzINCRwZILJ4Vii2q6ObHVo7
	 JL8ypGMuFeVe6oMJYOyFdEsRoM6THDq1xHhOXr1cBzA5XQ+Gfnc0rfkOL/D6KtvW5f
	 wp2Z+2WsV2xV9gU4uoUP3dJC/fztGIO0x2lKjwF54CMrEfsp/idHXDN7XVuwz11dMD
	 CVEgXGoi8DPLg==
From: SJ Park <sj@kernel.org>
To: sashiko-bot@kernel.org
Cc: SJ Park <sj@kernel.org>,
	"Andrew Morton" <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: [RFC PATCH v2 1/4] mm/damon/core: add DAMOS_FILTER_TYPE_AGE_MS
Date: Wed,  4 Nov 2026 21:09:03 -0800
Message-ID: <20261105050904.87870-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <sashiko-outbox-198571@kernel.org>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: kzrypegiaeb9f3i4kj7mkuywdr3b7q4q
X-Rspamd-Queue-Id: C503C2000B
X-Rspam-User: 
X-HE-Tag: 1793855353-343819
X-HE-Meta: U2FsdGVkX1+cei303GcnKsjuiv+pNBvci6JFYO7F42JKj1Y69Lj2tnkqCiasDFW7t0QLgnh8dGWNDRXX+JdBNV7s9jZoySJNtI+QBuHUkFnh7hwhHd//jdtUBZBbSYms5pT+06ntoJ4mKCamnlKks4zhKcRjc85QdxGx895MAVKx3+P4cF+2jY9hj+wCxGS6xrbCdln3bLDizbIevFD3B8hFbIZyNbX/0XB3FtoTOpOpU2Jhq29IKkvdMbzIfXYuN0gljLJ+3cJFmBlTTJVfbwP8BJpWeXtSvBCW4P2odnRdJizcQdSvSXjZnyQPsuuaBHZwmHQ03mJw6W9RnEv9FVy7T7W/pPjmigrFzB6QQ1Uhf7IdRC1pWrUgqfo0QAAye6NynecD+bA9bEltiC/qaIX2DWfduFROCz6EG+kE/nJvQZn8/yw0Aih5rnAdiGeHIoyxVffMXEnOAtZRrhcK08IcrdCE1TNyyvidSN2c2T5aiTT1cwSvwCLnR9tx9GzhGRXXqDH3LA0cjHpSJ81qsAG1YJGTyj9UPJNUwN0f3IYRDXd0WgvChtDDPVl5gySempS2RdlXwbBaNV2w2itPWdYuQUi18e8vL4p9hqAc/UNbPnkI6DJTbcxc9kbwIM01eEdeVW35un/37lyuJ9svHCvm8bGsVHKhiU5jCpSvobJUK6X7akfN3sa5gMvGppDo/ptk35897CwrmiMkyPAgpBlXA6X/opNFMpiQd929EcwliyPNvh6kjMe2T1X67jos1Ag6qUOZjBnvtrBo0fGUeonUsyDhYuQm8Blmiz411JUf/5wRAB/3Uk1Xsg6dgbG6P07Ulz2MGlXk/eBWafYRPtPgZAppqw1ryiI50kiDyBx2m+jdw4f0GPDlI12qmSxfFC91mzdkdtVbBeUOBttLsOM98qbF57e//qwgiuMifgKMxJGuYth7DLhRHH3F7JEZyEN0GUi0BkLzh3xRyWz
 qLaVHVy3
 mMyTbtyULE6VfjSdXEdox/F/MT7umXFS0HQQXop3RhZq4tBNDvZMWBUr7o+1vI9wpomDNRcGJ19PoNmdYKplCxSg4PI6BVjAZhAjyqtLn/5H7fksvn8Nd7a5meI1oBUTsim4KSxT/AVpgbXatUAlfKLbpuQrQ55cgpEqn+fxhIFozZ5PhIGSN0UFlNAao+CNEB1EmpLFvS3k9g1SDon1I3kOce0Gt0I0bK4Eo3o/aAZ+sFhxv8T0kiDlyJWZqxzl/5iAcdNGaNYNV7TPXQw3WaCJrZ985O3oJVlcdwcPFMKP10/qqFhPu9ToJ/B1ewDpWaS6KagVbr7MObEPIC+MPzwAamIj/r7+4oHkY/PWXFLlLiS2mrSL7pyVwwg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, 05 Nov 2026 04:55:17 +0000 sashiko-bot@kernel.org wrote:

> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [Medium] mm/damon: 64-to-32-bit truncation of age_ms in damos_filter_match()
> --
> 
> commit 2459402d4dc794f740b6a5720a69fe4a1a61ae62
> Author: SJ Park <sj@kernel.org>
> 
> mm/damon/core: add DAMOS_FILTER_TYPE_AGE_MS
> 
> This commit introduces DAMOS_FILTER_TYPE_AGE_MS in the DAMON API and core
> layer to allow filtering DAMOS target regions by age in milliseconds. It
> converts the region age from aggregation intervals to milliseconds using
> div_u64() and compares the result against damos_filter->range_{min,max}.
> 
> > diff --git a/mm/damon/core.c b/mm/damon/core.c
> > index d36823f4d0928..0a056949604f9 100644
> > --- a/mm/damon/core.c
> > +++ b/mm/damon/core.c
> [ ... ]
> > @@ -2552,7 +2554,7 @@ static bool damos_filter_match(struct damon_ctx *ctx, struct damon_target *t,
> >  	bool matched = false;
> >  	struct damon_target *ti;
> >  	int target_idx = 0;
> > -	unsigned long start, end, wsum;
> > +	unsigned long start, end, wsum, age_ms;
> >  
> >  	*err = 0;
> >  	switch (filter->type) {
> > @@ -2594,6 +2596,12 @@ static bool damos_filter_match(struct damon_ctx *ctx, struct damon_target *t,
> >  		matched = filter->range_min <= wsum &&
> >  			wsum <= filter->range_max;
> >  		break;
> > +	case DAMOS_FILTER_TYPE_AGE_MS:
> > +		age_ms = div_u64((u64)r->age * ctx->attrs.aggr_interval,
> > +				USEC_PER_MSEC);
> > +		matched = filter->range_min <= age_ms &&
> > +			age_ms <= filter->range_max;
> > +		break;
> 
> [Severity: Medium]
> In damos_filter_match(), age_ms is declared as unsigned long. On 32-bit
> architectures, unsigned long is 32 bits wide, so storing the u64 return value
> of div_u64() into age_ms truncates the upper 32 bits whenever the region age
> in milliseconds exceeds ULONG_MAX (about 49.7 days, or for example
> r->age >= 42,949,673 at the default 100,000 us aggr_interval, and
> proportionally earlier when aggr_interval is larger).
> 
> When that happens during kdamond_apply_schemes() -> damon_do_apply_schemes()
> -> damos_apply_scheme() -> damos_filter_out() -> damos_core_filter_out() ->
> damos_filter_match(), age_ms wraps modulo 2^32 and can misclassify old
> regions as young regions or fail to match old-region filters.
> 
> By comparison, damon_hot_score() in mm/damon/ops-common.c stores the result
> of div_u64() in a u64 variable (as fixed in commit 0284dff76e87 ("mm/damon/
> ops-common: fix 64-bit division in damon_hot_score()")):
> 
> mm/damon/ops-common.c:damon_hot_score() {
> 	...
> 	u64 age_in_sec;
> 	...
> 	age_in_sec = div_u64((u64)r->age * c->attrs.aggr_interval,
> 			     USEC_PER_SEC);
> 	...
> }
> 
> Should age_ms be declared as u64 (or saturated to ULONG_MAX before storing into
> age_ms so filters with range_max == ULONG_MAX on 32-bit continue to match) to
> avoid truncating the quotient on 32-bit systems?

The overflow could make DAMOS behave little bit suboptimum for certain cases.
I don't think that will be measurable.  Regions of age longer than 49.7 days
would be rare in my opinion.  Also, DAMOS resets age of regions to zero when an
action is applied.  Hence I think 49.7 days is practically long enough.  I'd
keep this as is for simplicity for now, and revisit if other human raises
concerns or a real issue from the possible overflow is found.

> 
> -- 
> Sashiko AI review · https://sashiko.dev/#/patchset/20261105044425.87142-1-sj@kernel.org?part=1
> 


Thanks,
SJ

