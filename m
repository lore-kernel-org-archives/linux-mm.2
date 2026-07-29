Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1526CC54F51
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 14:22:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0FE0D6B0088; Wed, 29 Jul 2026 10:22:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0AF276B008A; Wed, 29 Jul 2026 10:22:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F2DCB6B0095; Wed, 29 Jul 2026 10:22:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D3A506B0088
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 10:22:39 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5E2C5A06F7
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 14:22:39 +0000 (UTC)
X-FDA: 85042030038.05.165C04B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id B3CA7140009
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 14:22:37 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MFbRzWFn;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785334957;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=z8xkxqpsIVSsEuxMP/4DdUH4R6W+2G5DTJRYXvza3Fs=;
	b=1/UK6SmoNbVPQtfLlx3zqh99BblpeVL4NpCzsyPuTleX5zjX/Yvux4PavQGsO27U0Yebbx
	xMrDltaqrslTYrgycyw0dHFDKis+13g7rSofbglL+KewumQYM1BJe3lQSyByjJo6O80Z9J
	EsMbL0V7SN9MpchYzSoLheFs5y/5kZM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785334957;
	b=PChTkbfkbOt5enfZJP6wjuJ2JW3zeCO5GvDyTAvGXuVBUYQElj284KsgV3taLlEZWNw3wY
	NwDHnbJWv/48teoXLxRhlvMuGUG5AGmEottx93SbFSNQcitHGQUNtScSC0FUTq6LFw5Ixt
	PSdF5t/yuL/V6quZ2QDIR2vget7vdnU=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MFbRzWFn;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E709D4370C;
	Wed, 29 Jul 2026 14:22:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5CFC1F000E9;
	Wed, 29 Jul 2026 14:22:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785334956;
	bh=z8xkxqpsIVSsEuxMP/4DdUH4R6W+2G5DTJRYXvza3Fs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MFbRzWFnbb5hxbpVRoxQ8dn2ZJ4msskGmYyx7jPEtUlx1uxhlSmoup4qM6Qq3DPFc
	 nkDPZJyHw+bMUNt02DXfcPb67Gi08MNITVy9MZVbawGDzD5+t/t8Yv7hD2ZH8y1vr/
	 ChaCdTfILdbupOWM2PIldGFfAStN6Dm6jPFazOOp0zeW1iyJUCRjOeh8ApqnJ7p/dh
	 u0kg+BoBHX/O6H0kpBhzSrtD3IrCBbiFjNTczlxZt8PJpnP/49V8JcntbyDQJWlRjG
	 GtHhFpzuNK7FI969exerP92C0niqhpNd2LTk9J75a9YF9ivrJ1f9gj5lxQft+AryNS
	 3/kirLT25i2jw==
From: SJ Park <sj@kernel.org>
To: Gregory Price <gourry@gourry.net>
Cc: SJ Park <sj@kernel.org>,
	linux-mm@kvack.org,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	liam@infradead.org,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	usama.arif@linux.dev,
	vbabka@kernel.org,
	jannh@google.com,
	matthew.brost@intel.com,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	byungchul@sk.com,
	ying.huang@linux.alibaba.com,
	apopple@nvidia.com
Subject: Re: [PATCH 1/4] mm/damon: defensively skip zone device folios in damon_get_folio()
Date: Wed, 29 Jul 2026 07:22:28 -0700
Message-ID: <20260729142228.88390-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <amlZ_6pnt2AC-Ppl@gourry-fedora-PF4VCD3F>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: B3CA7140009
X-Stat-Signature: nbrnso1uaaoic8ue33wnkzfg54p58d6f
X-Rspam-User: 
X-HE-Tag: 1785334957-191368
X-HE-Meta: U2FsdGVkX1+7MlzCKmP+5UvJXwos9N1rFVwOOm0rBwPU85pt2PWdZGJLXBB/liTPQWzHvBoFsvgCl7MWEzp33UlzenWwEBZ9Vswuj98MGkg1uD592BieZ125ToGfvdmSGBcVwTTzyoFSpETl6u/vk10rnqqA/xlaL/ftWu3gbOPDWbDAVLwIrmVv1uipO/39PKhem4wslJhBFqWvAEtTrcL67poE+d83OwcG+VcC77MyifZSnQCoFzTptLbQRJVRkC1AyQg/XkVUJEcCnSPh2J2KGDQRVAP6nY8hfl8aXQpP+DXW1CMsS3O3Snh4kGcQXDv7Kar5SLVpbttS9qk0LyWin5LT/CcNw26a7iOBBJ3dswXJHPHU1TYghx2A9cnmQrhbJTJ6QeEHTzdEdy8wG1hQiZpLFSGl96qz4w8yDeQzfh1k4cCQh+eC8DDt+etSf4sPsuxA8Cds341aGfTpw+FOHiI8Gzqxoy35UBumTqmnGDWzrLtNanXndI/yIN4ZJ0pnWRuVbtFii0Yx1Bg/3Nmckyzri7cxRwX8NJYNBRQ4WWQG3yIkxXQIzNuAL/kJp6i4KaGr2N+ML1hI8xDH7rmi1/C/PUpC6V3mDn0N3S+yDp6rPxxIx4t9U96RioMMaXQ4qi7Yz42GrIdRSa5ZIqYI1SafF4rz3dXNMjvfP3d7NIg1mhaRFoJxwxoU2NVS/Dd4kEn6ZIvAuJsn8BpCOaWejhdQfl9b4L/3GJDuFCmzRbr7ju3WOK3IYHNVXokTF/KXx61SrCFD/yfIEL7SEnzK4JVz32zGfNksWacEmt0VzGnhzDk5EihepNC9odE1b7R4gtsCa939xjLeJK2n0v00VFf6m/HF4ytJQlBYFBZaBgo6EQIjU2332M3Q31oNzzNm83ieyfzLuNXa3K6KeZzD7vwSi7d4/vO+iz0zVIPxTqTwQTecvGWaEIrlfCfvnhCyyWC59NQJCSBK2cu
 DXk+GWa3
 vHmUqgQepqBjj3zahPMRR9k8+nbQU5bGC+69+f2Ssps+MEbySo39zNm17JohW91cMkO9F9yUGnFK56pJGZdmke5WO6Z71imNfUQO+5mwrIqWFbKZ46pYeMMfq8s+/11AtD+ltkMscFfJzBvlbBWTtpuZ1jVFPJKtTPDmLDLf6Hcl4k6MVNvWYxIGePQp+aucIV4khpUE+Yko64uZlqPTtOnGR+NGhfqvbpevhQXLieJpSBGtOH2ifZyCfeECuxurl5CICcmMPrlxYTqiee5Z1PqlBbRqYmoe9m8GokYBxaAAKS5J3iM9ogCxHOo+5XYuKzOQ6AI2URoWXQH0xk1LBUPGerIbmLXAAiRCJRRLgBvwJYW/rCBrFEySUGDdNmCccUtEbEe4li0EfEqc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 28 Jul 2026 22:01:01 -0400 Gregory Price <gourry@gourry.net> wrote:

> On Tue, Jul 28, 2026 at 05:50:36PM -0700, SJ Park wrote:
> > Hi Gregory,
> > 
> > 
> > On Tue, 28 Jul 2026 15:47:11 -0400 Gregory Price <gourry@gourry.net> wrote:
> > 
> > > All DAMON physical- and virtual-address operations obtain their folios
> > > through damon_get_folio(). That helper already excludes ZONE_DEVICE
> > > memory implicitly via pfn_to_online_page() and folio_test_lru(), but
> > > this is inconsistent with other callers in mm/ which test explicitly.
> > > 
> > > Add an explicit folio_is_zone_device() rejection in damon_get_folio()
> > > so the guarantee lives in one place and covers every caller uniformly,
> > > consistent with other mm walkers that reject zone device folios.
> > 
> > Thank you for checking this and sharing this nice patch!
> > 
> > However, I'm not very sure adding a call that not really required for only
> > making it looks consistent with others is the right choice.  I'm especially
> > concerned if this will confuse future readers including myself.
> > 
> > If this is a hardening purpose, we have CONFIG_DAMON_DEBUG_SANITY for the
> > purpose.  What about using it with a good comment explaining why we doing that?
> > 
> 
> It's actually two fold:
> 
>   1) make zone_device more consistently handled across mm/
>   2) make these checks possible to abstract out later
> 
> In the private node work - every location that we'd need to filter
> folios based on private node membership is a zone_device check.
> 
> Where zone device checks are missing (like here) there's some other
> implicit reason (specific to zone device) that allows it to be avoided.
> 
> I pointed out in the sashiko feedback that DAMON depends on a check
> for folio->pgmap in the hotplug code.  This is all quite fragile, and
> we can see that at least one patch in this series fixes an actual bug.
> 
> It seemed warranted to go audit every service and add the zone_device
> checks to make it clear there's a zone device interaction - even if
> presently unreachable - should some silent, implicit filter change.
> 
> The goal is to come back around and replace these with something like:
> 
>     bool folio_allows_mm_op(struct folio *folio,
>                             enum node_states feature)
>     {
>         if (folio_is_zone_device(folio) ||
>             !node_state(folio_nid(folio), feature));
>     }
> 
>     - if (folio_is_zone_device(folio))
>     + if (folio_allows_mm_op(folio, N_MEMORY_DAMON))
> 
> If we ever get to folios having memdesc flags beyond page flags,
> this also gives us a single mm-wide location for these kinds of
> checks in the future.

Thank you for kindly explaining the motivation.

So, what do you think about adding the check under CONFIG_DAMON_DEBUG_SANITY
with good comments at the moment, and later converting to folio_allows_mm_ops()
together?


Thanks,
SJ

[...]

