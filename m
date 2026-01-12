Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 498B2CF45D2
	for <linux-mm@archiver.kernel.org>; Mon, 12 Jan 2026 21:36:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AC57B6B009D; Mon, 12 Jan 2026 16:36:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A9DAC6B009F; Mon, 12 Jan 2026 16:36:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9C6306B00A0; Mon, 12 Jan 2026 16:36:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8A8066B009D
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 16:36:30 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 28289160F1A
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 21:36:30 +0000 (UTC)
X-FDA: 84324620940.15.BDDF491
Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	by imf14.hostedemail.com (Postfix) with ESMTP id CF010100008
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 21:36:26 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=m9m5QVTT;
	spf=pass (imf14.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768253787; a=rsa-sha256;
	cv=none;
	b=DgA+S32n8pIXPrQxOAQeBJ6+Fmkvuo5OiOlAGJMAwWUYnG43hUAUJgnHKPNk7RznjCKldO
	z00QYa5AHRNo4gQiHTAp4l0aQHx0dr8d7u9pVWDRRvmYiqLXZHIb3rITpeVfWKiWy188i4
	wOfPYALoQ2ysZe0tbIHh+0KktCNPnBU=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=m9m5QVTT;
	spf=pass (imf14.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768253787;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=T3BjtoAAstlY6b/etRhy75SWXFb2D/YEwMqRuShF6b4=;
	b=OCJsTcf4M/3dQGZ/HhKWSKCas5eQpysPBfQ3kQf89u6Xmvd6QhhLPrU+XxtuXoBpzReUWa
	N5iIZzK6US8CeXRs6aeMzRNAGV+88/vJV6Ilyh4mX/Dn+RsPHa+W+oOEIHHDtyZ/+AwoDF
	fmLrQXSpiDy4EzpZK0sdBCC1LY2PcW0=
Date: Mon, 12 Jan 2026 13:36:20 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768253784;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=T3BjtoAAstlY6b/etRhy75SWXFb2D/YEwMqRuShF6b4=;
	b=m9m5QVTTu18qp8eRE/apJolgPvKzpkMqNnIXlpc3SbPa2JdSjsDVvGS7ImBzThOacvugFB
	MwqB5jlAH93aGBWWWUL7ptUT9Qf8SUsLwB+ebL0V/ezVEw5FPfiB8/5r5ta2NYtf6qsTUN
	XG58PScDJPtcXLX1t8Dn445oIXrPFWk=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: SeongJae Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Meta kernel team <kernel-team@meta.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, 
	damon@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 8/8] memcg: rename mem_cgroup_ino() to mem_cgroup_id()
Message-ID: <flkqanhyettp5uq22bjwg37rtmnpeg3mghznsylxcxxgaafpl4@nov2x7tagma7>
References: <20251225232116.294540-9-shakeel.butt@linux.dev>
 <20260108045954.78552-1-sj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260108045954.78552-1-sj@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: CF010100008
X-Stat-Signature: h5fcc53g6wx3zkcwohbmod7a4czb7snf
X-Rspam-User: 
X-HE-Tag: 1768253786-869304
X-HE-Meta: U2FsdGVkX19LACijtCJgPPIIFIzSX5TrN9IbOt5ugwdM1oeVan2jKY6FQ/nCbHjFDRLK5hNvgorXMhdahWHh2SuxiZ0SoSofZO/DGgF9P5FhFxI4FokafWLIIFfgEHsxjONfd+/HhH7tABTW6D4O3SLwlKlO0rfsHUYJgWxX7CWMtY2R03WZ2YPqRXgZ7Kull9XT4hH88o+kioxnZADGtd8Cgs1OHnapib8v0K/Bfl4WzGp9bTzDRObM70R8/783jkkL6Za4HfCvvQhEqfAv3XlvYxnvJWEKXuO4QrQY9vpcnqWIz+LNBKksKhwD+1BjdTOcOR5IiZ1QT1k7FcIaX5YozVP+tw59gC79EMhknE14XyAWBGH8Feq586llnE4vY/3gWNFl5SsVtVZGRLk12erwmN8nHDbt4PCMfXmbzkosHY2K8qYmxRIG8ZtBPnKWk166clR0UNRTUwR1w6uBOtvcX51yGMska3JnW9FJzw5ukGbUDoxQHnQEx0whfNqnSqkJIPACYnWy2VswsFIC3D9Mqc/h9vyhCNq/UGFuBbeD84HfDIU2uQGSRziKuBkDBVYHxOvx+xtKnznFZYtYYgC09N2LzKt4TqYgGFyTHR29Y1/Z/uo6rUu2gdBfGoPt9CP59G6/BJ5mYJJrXcQ+TCS7j/zt3tAckmeI9zSUU03yhIdVhyE/F1FnyE56e6hjFphkmvj7FWOdf/0uysPTXB6ZS5RprDqfGEhUr9opx3RDfaAUnQi2CTHTdWdlC0K+698LacHDG1HNJRe+Nr9wVPEOKKbzIiJX7qjvWqk/QbuSQPG3G4WxVc4x1OhZViBRjVhpFSnBPTIXtJ5na1K/rbla3I1JIgCVOs3G3XEQVCdYdh/qbfxHfArbnIqiu7vCzFxQTZZ+vpodV6MWZ3ZpACWI3JMmbpisQDxTll/YjrF0LlUSE9M4QEuYDoyt/WUDOwst1XmTOgPIp30Xtyf
 N/PZoY7O
 zB79nRN5vhA7EayADKSjUWdSESh8pZB33UT6x9fUeYEbFtM3f1q+mEekgTClQ84GOeBmb5TegSwbaxndQKaaWjHDub3VfXXShC/X7zHfSqr2W+NMc6sK97v0leaRgNdYr07gJibCzxjnDHuyvgGR3CuGpXX0s8e4zU4+ZGizvWY0lvqaIVbXJ5tz20uQ7H6tMa52H3gfy831VbHlDndahcSAzz48iY83STudqoFyFn09YZPxzVpOwPSTnSCUfC+BgkNbW
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jan 07, 2026 at 08:59:53PM -0800, SeongJae Park wrote:
> On Thu, 25 Dec 2025 15:21:16 -0800 Shakeel Butt <shakeel.butt@linux.dev> wrote:
[...]
> > diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> > index 3e7d69020b39..5a1161cadb8d 100644
> > --- a/include/linux/memcontrol.h
> > +++ b/include/linux/memcontrol.h
> [...]
> > -struct mem_cgroup *mem_cgroup_get_from_ino(u64 ino);
> > +struct mem_cgroup *mem_cgroup_get_from_id(u64 ino);
> 
> Nit.  How about renaming the argument from 'ino' to 'id'?
> 
> [...]
> > -static inline struct mem_cgroup *mem_cgroup_get_from_ino(u64 ino)
> > +static inline struct mem_cgroup *mem_cgroup_get_from_id(u64 ino)
> 
> Ditto.
> 
> [...]
> > --- a/mm/memcontrol.c
> > +++ b/mm/memcontrol.c
> > @@ -3615,7 +3615,7 @@ struct mem_cgroup *mem_cgroup_from_private_id(unsigned short id)
> >  	return xa_load(&mem_cgroup_private_ids, id);
> >  }
> >  
> > -struct mem_cgroup *mem_cgroup_get_from_ino(u64 ino)
> > +struct mem_cgroup *mem_cgroup_get_from_id(u64 ino)
> 
> Ditto.
> 

Thanks a lot SJ for the review and suggestions.

Andrew, can you please squash the following fix into the series?


From 7bf26690649ab9c555d17a2acb7215e768232d13 Mon Sep 17 00:00:00 2001
From: Shakeel Butt <shakeel.butt@linux.dev>
Date: Mon, 12 Jan 2026 13:34:27 -0800
Subject: [PATCH] memcg: replace ino with id

Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
---
 include/linux/memcontrol.h | 4 ++--
 mm/memcontrol.c            | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 538fddd3ef77..b6c82c8f73e1 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -835,7 +835,7 @@ static inline u64 mem_cgroup_id(struct mem_cgroup *memcg)
 	return memcg ? cgroup_id(memcg->css.cgroup) : 0;
 }
 
-struct mem_cgroup *mem_cgroup_get_from_id(u64 ino);
+struct mem_cgroup *mem_cgroup_get_from_id(u64 id);
 
 static inline struct mem_cgroup *mem_cgroup_from_seq(struct seq_file *m)
 {
@@ -1293,7 +1293,7 @@ static inline u64 mem_cgroup_id(struct mem_cgroup *memcg)
 	return 0;
 }
 
-static inline struct mem_cgroup *mem_cgroup_get_from_id(u64 ino)
+static inline struct mem_cgroup *mem_cgroup_get_from_id(u64 id)
 {
 	return NULL;
 }
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index d4ac9b527f91..bd2ab72386d4 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3615,7 +3615,7 @@ struct mem_cgroup *mem_cgroup_from_private_id(unsigned short id)
 	return xa_load(&mem_cgroup_private_ids, id);
 }
 
-struct mem_cgroup *mem_cgroup_get_from_id(u64 ino)
+struct mem_cgroup *mem_cgroup_get_from_id(u64 id)
 {
 	struct cgroup *cgrp;
 	struct cgroup_subsys_state *css;
-- 
2.47.3


