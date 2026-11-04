Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F0AEB606A326
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 15:51:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gff6DAI3
Received: by kanga.kvack.org (Postfix)
	id EF0D36B05B4; Wed,  4 Nov 2026 10:51:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EA0AD6B05B5; Wed,  4 Nov 2026 10:51:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DDD6E6B05B6; Wed,  4 Nov 2026 10:51:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B56FF6B05B4
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 10:51:58 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3DD5F807A8
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 15:51:58 +0000 (UTC)
X-FDA: 85397877516.06.1A3BDFD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 7E936160002
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 15:51:56 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gff6DAI3;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793807516;
	b=Op1pufXlNGErB5CWOIfY7oJoUGj5uuI1XhruM/w/pIyBsRuYRlzmliZk1t4W7+8+XQj6Ib
	/bXyo2vQOZuK3h4/13zNZCpFMvNZS4ZkAoLMnlLPDlNxb+ti1wZ0/4v8/8hp/eMJGzN0g0
	66om0T99YfhvC7EGzvC2033G9l7Ei80=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gff6DAI3;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793807516;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0sBhfxVoPTNwyeJI8hydpBvqTMqtbq2SWkwYzUSeiS8=;
	b=ifUhNEEK5NDOJLa4Mq7F1LQo8Bpz0G4xwTjwBgvIpBsB4m49MS2k/m9RWmjW66xhNnggUB
	AwOneO8LsSb3XZqGD8KlD91t3xQBpIOgOpA5NoSPERUeeVbC60r4a1P7HA4BnHgRKQj/4r
	yx3+OuO9fM9ea8jkNySRCkShhKrvbpM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A7D164376C;
	Wed,  4 Nov 2026 15:51:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62EDA1F000C1;
	Wed,  4 Nov 2026 15:51:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793807515;
	bh=0sBhfxVoPTNwyeJI8hydpBvqTMqtbq2SWkwYzUSeiS8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gff6DAI3lDNr7WYHV7JCx2pC52NmJjHoPQgqc/VkOEq9fdWYQis5DMFvbCzY25Ctl
	 U9pJMb5uIugekGGGmQ3CqC472HfaSwIVObDXyjL9k67p9BNeIdJykNPnKVRLgPhAGj
	 64DqMMdiDIS1KSrbjzumz9znjgaGIuvjMGFKiyHYJnvUCPFPelQvQoYh2VfrjgkjlO
	 mZX8rmADzAohUe0sl9VFGRvIZYndscQmo8tvz+VrOFcpGpFza7QWqVWariHyD1k3Ga
	 TEwnx6odKrb85JrWnBXBFWq7rdHEmiT+6il5ccSvbQZx/gaPMTHT1qIGwBprJEPpnf
	 qbleMZyN3ddaA==
From: SJ Park <sj@kernel.org>
To: sashiko-bot@kernel.org
Cc: SJ Park <sj@kernel.org>,
	"Andrew Morton" <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: [RFC PATCH 2/4] mm/damon/sysfs-schemes: support DAMOS_FILTER_TYPE_AGE_MS
Date: Wed,  4 Nov 2026 07:51:47 -0800
Message-ID: <20261104155148.83931-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <sashiko-outbox-197544@kernel.org>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: qarzoeb88s8mhsiuzojbkk1o3c6bjtuq
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 7E936160002
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793807516-201200
X-HE-Meta: U2FsdGVkX1/Ml/k1DmkeL63GgpDWnegs0OSDFuVGhMlM5pcf1smSX05LVFbb6nWLm1Ue8c8hrT0wtHnLgBHWeqFbQKYyTYygdvaGtfH+HFW2elS2nZTF6/W8a0dvSF+R4NjIBVpDygfmyGmibK2KdJTwN4V8P/Pu00uXRms+CfcKr81HWD0KdzmBz9cAMY86+zrFjk9/jyHN4Efy5tHQ5UiIveu5qlNroI0XvAW8ZTgoSvJR/jPmI7tc7dV7jiQ+m/KX+a8cGRGXInNCHbicgSHnARCImPmiBriUPd2zAIQcWTLxk3Dsz48BqFs8nQ2ks1RewE86INk5In2VpROPYqy+99q8yEJMb2rJDORXvuQb0yp8gEAJHIxO0LA+l46pCMKIU6irNiUd1qVXf67i3O8/aRO2eTwYsapbDx+YP82f8ybpSA0tuevVvAaYWoiZ+MtRdhZwiv0rMfM39bC9RWeOz2dSG4xkHvUfPTeTGwLhFYjAGhe/cVRHrZznMKSyhgYPb8TibUzo6ltx62luZ0Jk0moTeqcWyQ+YKX/xKpDBVlh67d2AbmPa/Vw9UAf7TWZ5ATaGtQV/J8s0e5FU6zSfk5+HpJoCBdYrHccaRkTpzUx8jdMRJCYOTAFcPG+pe8Ol56ffVDgPHBVEtglbsT3KQa0pyL/+X5YWSatfi+vANPavB4ns+6QW+4iuUu7ENbmwSJ0kUv/FBE7puKdDBUWrEljTDkrsnk7am2HwzBoCnky6fFzrlm/Vuan9ngGd/XbSrcfSZvxl3b7QGQzMx5wtVrqsZjmtjUQjE96eAULlYzWefMf6uDNKVWyjBByWpPVtRpOKwORf7Aqov022/61t7B5l3Pi4q/4ipN0uPl/uN/hLiLK8TMwW8FEb9U6M100Jm5tOURTWn7YiWAoPCnJ8IrgSq5qvhgQajQsnj7MVenWvKWnP6jsPvrm/8rlRz7t8MzWbXYGj2cB7rGW
 TunCcLGW
 iafpx5AivY/tE/j4yeBmnjJxMZyG+/h6zkRjnlwizk4QblVe7JCEngJ1/mXMgTGOXsKH4NwTJKfEIW6HVlThho522XXnAkf38PGkNJ20EjTCxs+MUYU88/Lfe3k2OfVMTMnDmH2jUeZPaCJ2lmt8H/NDsMuxOVme/hjqtkEW3P+F1sDWW4DyxXojTcTNti3Ck6aUvsNQ6sbuiErzpxlbvibPYWxSt0yf8RpG702TEF86AVo0SwNiMkEB7R0+L+vF+d8GfvJlvB1G0YaxBzOGFi++zNHpH/cg2EZby87nL/e5evAt53jEBXzjQ0waTlLP1GYquLv6BCd/jKSp+dhatmJ0ZOgz5rsBQegGBv/Gf+k1Lxvb67BsEN97/KA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, 04 Nov 2026 15:50:23 +0000 sashiko-bot@kernel.org wrote:

> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [Medium] mm/damon: 32-bit overflow calculating age_ms in damos_filter_match()
> --
> 
> commit 9c78f1b31239922167bf213c5406c37c05fd310f
> Author: SJ Park <sj@kernel.org>
> 
> mm/damon/sysfs-schemes: support DAMOS_FILTER_TYPE_AGE_MS
> 
> This commit exposes DAMOS_FILTER_TYPE_AGE_MS to the DAMON sysfs interface
> using the "age_ms" filter type keyword and the existing min and max sysfs
> range files.
> 
> > diff --git a/mm/damon/sysfs-schemes.c b/mm/damon/sysfs-schemes.c
> > index 637f1bd0c950b..230987efac3ac 100644
> > --- a/mm/damon/sysfs-schemes.c
> > +++ b/mm/damon/sysfs-schemes.c
> 
> [ ... ]
> 
> > @@ -2875,6 +2879,7 @@ static int damon_sysfs_add_scheme_filters(struct damos *scheme,
> >  			filter->sz_range.max = sysfs_filter->range_max;
> >  			break;
> >  		case DAMOS_FILTER_TYPE_PROBE_HITS_WSUM:
> > +		case DAMOS_FILTER_TYPE_AGE_MS:
> >  			filter->range_min = sysfs_filter->range_min;
> >  			filter->range_max = sysfs_filter->range_max;
> >  			break;
> 
> [Severity: Medium]
> When userspace configures an age_ms filter with range_min and range_max via
> damon_sysfs_add_scheme_filters() on a 32-bit system, can age_ms overflow in
> damos_filter_match()?
> 
> When kdamond evaluates the filter via
> kdamond_apply_schemes()->damon_do_apply_schemes()->damos_apply_scheme()->damos_core_filter_out()->damos_filter_match():
> 
> mm/damon/core.c:damos_filter_match() {
> 	...
> 	case DAMOS_FILTER_TYPE_AGE_MS:
> 		age_ms = r->age * ctx->attrs.aggr_interval / USEC_PER_MSEC;
> 		matched = filter->range_min <= age_ms &&
> 			age_ms <= filter->range_max;
> 		break;
> 	...
> }
> 
> Here r->age is unsigned int and ctx->attrs.aggr_interval is unsigned long
> (in microseconds). On 32-bit architectures, multiplying r->age by
> ctx->attrs.aggr_interval is performed in 32-bit unsigned arithmetic before
> dividing by USEC_PER_MSEC, which wraps around once a region's age exceeds
> approximately 4,295 seconds (~71.6 minutes) even though the resulting
> millisecond value fits in a 32-bit unsigned long.
> 
> A similar 32-bit overflow on r->age * c->attrs.aggr_interval in
> damon_hot_score() in mm/damon/ops-common.c was fixed in commit 0284dff76e87
> ("mm/damon/ops-common: fix age_in_sec overflow on 32-bit"). Should
> damos_filter_match() use div_u64((u64)r->age * ctx->attrs.aggr_interval,
> USEC_PER_MSEC) as well?

I will fix [1] in the next version.

[1] https://lore.kernel.org/20261104154746.83311-1-sj@kernel.org

> 
> -- 
> Sashiko AI review · https://sashiko.dev/#/patchset/20261104153645.82945-1-sj@kernel.org?part=2
> 


Thanks,
SJ

