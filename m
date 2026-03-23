Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 238F5FC72C5
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 23:54:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4399F6B008A; Mon, 23 Mar 2026 19:54:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4112F6B008C; Mon, 23 Mar 2026 19:54:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 34DC06B0093; Mon, 23 Mar 2026 19:54:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 242C66B008A
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 19:54:48 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A12E11EC92
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 23:54:47 +0000 (UTC)
X-FDA: 84578985414.08.375A99A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 0EC2B10000B
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 23:54:45 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bEW2HKlb;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774310086; a=rsa-sha256;
	cv=none;
	b=a4L9NloX/4Fu7eezHm03J3mO5YGDU3afaUPWv1vuW2oTotvJk3FDZB2xxiZsqDRgWLhvAX
	EV8gWIHNpy4ZbJHPa0uCPuHN7a8YTQBl/7qLrpFzkPP2x7SWz6TP/gzErCELnNegAXvvck
	dZ6iK4L9HRcMByBTUUcdGHWMD2lS53Q=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bEW2HKlb;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774310086;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TVQFjvj9A0EDgOHvXjNOLmJ7P4vUD2fdkR5BJIP1xEs=;
	b=4sIPKOoSTKSIIPutop8IrR5F66veInPBmrUHnMvoOE638M1nzsuz11/rtVm/7VsyZ1bSKN
	La/5L6W4Vy2o0YsyOUpiS48gwx/KtWF8eKzCGaD7X0uOw8U53V7nr9nE32gGIZZPvGk9Ee
	88w197BVWO1fUFS2HbuVg5sICsV2HrE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 58A44600AC;
	Mon, 23 Mar 2026 23:54:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4527C4CEF7;
	Mon, 23 Mar 2026 23:54:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774310085;
	bh=+j/Q0T6wecgob98wFExGgY24lat6lW97XRFNsp8RiPU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bEW2HKlb2Z5QQzMHbK/Pdm1Mi1c/bF3SbtB7SgiZ/brk5Nl65EWyWHpXfxQjSFQ5r
	 mDHb/G2qM/wGXV6Q3z1wEWc9jG/ujC6BdOws+Ec+LReGHP0HN5YwDE9AnmbrmGVxW3
	 eVO4JE9DjBFllH7uW/yj9MgGGCmKQR0Nro+r/7uUHYRh1LYFzhlY/kcT3shHBXshM7
	 kLoDYvsh72AaxawYyOqFBB4pmRyL7T268KDA9eZukUfTnny45csqfEBK7d1g3JGq2M
	 WOyiJD4mTIvu1EybGVlSnej1G8XSvZnZDvqQ6LPsFKdnsylvsOfWEWUaCRAanIrbMN
	 jeNkqOZr/fBEA==
From: SeongJae Park <sj@kernel.org>
To: Ravi Jonnalagadda <ravis.opensrc@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	akpm@linux-foundation.org,
	corbet@lwn.net,
	bijan311@gmail.com,
	ajayjoshi@micron.com,
	honggyu.kim@sk.com,
	yunjeong.mun@sk.com
Subject: Re: [RFC PATCH v4 1/1] mm/damon: add node_eligible_mem_bp and node_ineligible_mem_bp goal metrics
Date: Mon, 23 Mar 2026 16:54:36 -0700
Message-ID: <20260323235438.85953-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <CALa+Y16i0f5D_ZTVcfVa1DgeZL1btvUJxjOvoyFEYNkT7K-grg@mail.gmail.com>
References: 
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 0EC2B10000B
X-Stat-Signature: biysi1jk575qeamhqmqncrrcaxj6tuem
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1774310085-955297
X-HE-Meta: U2FsdGVkX19nIPBwiWhJOxxQREUkITn1Z+js8r/5hf81WNHdtvwDvgIUJjaU+R04eRcTLr3q5WJ0mC4bsdc/Lct3o3veaPA6hPgC5nTQa6+nA6+Qpjvw9BrS4wGgR0TbfneZmoMh9CZ1Aof0/1ZpoQ9u0m6rpVRNGHGmK6VocrDwz/HQE/34REZlp4wcKjIEesuWlsOcYFJ77l9CgD/R83yklo+oDq+sW0aLFla6WOkw/eXVW//hQWDSdLugCJotbxyb47TrdAhbNbrnToC0eTLmBz/hI07GkAWBKHdkUhSDI1lSs6X7Ur3g3WQmQ8Qf2x9vIOnZiRmeJr3fjy+hODsamLdw44abjus64q7IiYsfinPQg3Vt3UNO+4KpmL5DOh+cT5ASulscvQGu44ZE5UybKrQPCQqDsm9cq77MQTVcMwcbCPHKuzbrG3doZnEYREHHGczTOwcq6kBskPmpkqzv9ZmDk8sm4Z4ph3NxDMIc1vpqZkVa6DUKP0CpdwxERP/CKW88iybhPQxXAKwdzrNSGZXY8Px3K89QVWrt4fV9gqRfWWhDipAEyL2dtt+DcgLNUY7/bG26ViUpMoAn4zOf7DtMRslSxdSuW/YgFbX2pDQ7+NoG24srljjZbPmeUNRVQMty3lQTdT94TTfH3D+W1evC8AgoBl0hnjmVtfo/Qusbav/px2THExZ2A2lsnPL51V0FbBbOvtxAC2OaC5IVla9A6E5A7Ikjp+Bk8tL9J5HaLUd7WGszVeojgJTkl2Iv5y1f8GbhD1co9CrlnTcQLVD0Ka8aYIUWq6xl5yXCkYBTvR3cyFKmTs85pDvVs6SFrGA5NskVlOoJX5b9OYNIJoc9JT0MK1y5H6EuZ/I7wH2Z4pEF6D7fer2l3eMWr0x04aamLPmyq89pSA+eipCZQfcHCQ4weHIJozAA7AEOLiK9pSy7ydpKtys8uEKZxnpWYAsekGS+T0eY3WZ
 Wk28u3Cv
 4XYcUE/OGAuXxitBawyTXrPG0VrlNXDdI52g5MXUNrCvmCCsjwF/4hlSCxd7tmjqZUGueSDkZjqs0CigglgGpnBZegmz1cfGF5HtABgAkDPmvgWxTVbzxCy5dRyfsdo4lytZyMe8WOt8o98LWGE2vypdbrvDIHL96YxM5ulZB2J3Ib34TdmO5MtAhp1FJQuNHc2OZwWkDgqN4i18Npia+3fsUpD52EWUbdzipn8SzWDzTZZ8b5bAWUWFhXpA+qklnWoeokau+M5KO/dZs2W2t4sbY+B2uwVyxoUUVxGwVm4nBfvWPPenjGibZh5i8GAp3PhjtPqS2T1O4MtmZLOFPOjZpuyAmgU2k7Xk4H3D9aOoQ8RR27oRsYiLUayxIiCp3zEc57vBlqHxvu5X48TTxW5N3fxUyGgWKhXHz
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 23 Mar 2026 12:41:42 -0700 Ravi Jonnalagadda <ravis.opensrc@gmail.com> wrote:

> On Sat, Mar 21, 2026 at 9:54 AM SeongJae Park <sj@kernel.org> wrote:
> >
> > On Fri, 20 Mar 2026 12:04:53 -0700 Ravi Jonnalagadda <ravis.opensrc@gmail.com> wrote:
> >
> > > Add new quota goal metrics for memory tiering that track scheme-eligible
> > > memory distribution across NUMA nodes:
> > >
> > > - DAMOS_QUOTA_NODE_ELIGIBLE_MEM_BP: ratio of eligible memory on a node
> > > - DAMOS_QUOTA_NODE_INELIGIBLE_MEM_BP: ratio of eligible memory NOT on
> > >   a node
> >
> > The description for the second metric should be "ratio of ineligible memory on
> > a node".
> >
> 
> Got it. Will fix the commit message.
> 
> > >
> > > These complementary metrics enable push-pull migration schemes that
> > > maintain a target memory distribution across different NUMA nodes
> > > representing different memory tiers, based on access patterns defined
> > > by each scheme.
> > >
> > > The metrics iterate scheme-eligible regions and use damon_get_folio()
> > > to determine NUMA node placement of each folio, calculating the ratio
> > > of eligible memory on the specified node versus total eligible memory.
> > >
> > > Suggested-by: SeongJae Park <sj@kernel.org>
> > > Signed-off-by: Ravi Jonnalagadda <ravis.opensrc@gmail.com>
> > > ---
> > >  include/linux/damon.h    |   6 ++
> > >  mm/damon/core.c          | 158 ++++++++++++++++++++++++++++++++++++---
> > >  mm/damon/sysfs-schemes.c |  12 +++
> > >  3 files changed, 164 insertions(+), 12 deletions(-)
> > >
> > > diff --git a/include/linux/damon.h b/include/linux/damon.h
> > > index b1d8fd88a0fc..490918804f85 100644
> > > --- a/include/linux/damon.h
> > > +++ b/include/linux/damon.h
> > > @@ -193,6 +193,10 @@ enum damos_action {
> > >   * @DAMOS_QUOTA_NODE_MEMCG_FREE_BP:  MemFree ratio of a node for a cgroup.
> > >   * @DAMOS_QUOTA_ACTIVE_MEM_BP:               Active to total LRU memory ratio.
> > >   * @DAMOS_QUOTA_INACTIVE_MEM_BP:     Inactive to total LRU memory ratio.
> > > + * @DAMOS_QUOTA_NODE_ELIGIBLE_MEM_BP:        Scheme-eligible memory ratio of a
> > > + *                                   node.
> > > + * @DAMOS_QUOTA_NODE_INELIGIBLE_MEM_BP:      Scheme-ineligible memory ratio of a
> > > + *                                   node.
> > >   * @NR_DAMOS_QUOTA_GOAL_METRICS:     Number of DAMOS quota goal metrics.
> > >   *
> > >   * Metrics equal to larger than @NR_DAMOS_QUOTA_GOAL_METRICS are unsupported.
> > > @@ -206,6 +210,8 @@ enum damos_quota_goal_metric {
> > >       DAMOS_QUOTA_NODE_MEMCG_FREE_BP,
> > >       DAMOS_QUOTA_ACTIVE_MEM_BP,
> > >       DAMOS_QUOTA_INACTIVE_MEM_BP,
> > > +     DAMOS_QUOTA_NODE_ELIGIBLE_MEM_BP,
> > > +     DAMOS_QUOTA_NODE_INELIGIBLE_MEM_BP,
> > >       NR_DAMOS_QUOTA_GOAL_METRICS,
> > >  };
> > >
> > > diff --git a/mm/damon/core.c b/mm/damon/core.c
> > > index b9e12865622c..3e0ac65e34a0 100644
> > > --- a/mm/damon/core.c
> > > +++ b/mm/damon/core.c
> > > @@ -17,6 +17,8 @@
> > >  #include <linux/string.h>
> > >  #include <linux/string_choices.h>
> > >
> > > +#include "ops-common.h"
> > > +
> >
> > I don't find a reason to include this, and I'd like to avoid including that in
> > core.c unless it is really necessary.  Could you please remove this?
> >
> 
> The include was added because the implementation uses damon_get_folio() to
> determine NUMA node placement of folios when iterating eligible regions.

Thank you for clarifying, Ravi.

> Would you prefer that I move the damon_get_folio() declaration to
> include/linux/damon.h, or would you suggest a different approach such as
> adding an ops callback for the node calculation?

I'd like to keep it mm/damon/ internal if possible.  Maybe adding new files,
say, mm/damon/common.{c,h} is one option.

Just keeping it as is for now with clarification comment (e.g., "including
ops-common.h for damon_get_folio()") for now, and revisiting for cleanup in
future could also be another option.

I slightly prefer the second option at the moment.

> 
> > Below looks all good for RFC level code to move on to the next stage (dropping
> > RFC tag). :)
> >
> 
> Thank you, SJ! Will send v5 with fixes once I hear back on the above.

Sounds good, looking forward to!


Thanks,
SJ

[...]

