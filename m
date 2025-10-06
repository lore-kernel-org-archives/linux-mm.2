Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DCDE2CCA471
	for <linux-mm@archiver.kernel.org>; Mon,  6 Oct 2025 09:53:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D5AC18E0003; Mon,  6 Oct 2025 05:53:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CE4218E0002; Mon,  6 Oct 2025 05:53:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BD30B8E0003; Mon,  6 Oct 2025 05:53:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A90258E0002
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 05:53:56 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4050B11A44B
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 09:53:56 +0000 (UTC)
X-FDA: 83967228072.09.1149B41
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf10.hostedemail.com (Postfix) with ESMTP id 93A84C0004
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 09:53:53 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf10.hostedemail.com: domain of jonathan.cameron@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=jonathan.cameron@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759744434;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xG+zNFcVE4tRYEOsRVRHuO48CdoqZIaNaYmmUVpR+7A=;
	b=CfYj7ARSHHySQAwFE65p6XBLYAEDEBbpAz2SPQ3QHRu+GSfNsHmHL84zCYkSAD+py4kZla
	1kj0i51zkVbjM5ntD/aEma24/hDxTLQVyYrHhwMfiosOVz1Mmg7ldKF0I7C82N+za3Mlvm
	Nlh849aI8rcBMivD5DbH1TGD0SquBR0=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf10.hostedemail.com: domain of jonathan.cameron@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=jonathan.cameron@huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759744434; a=rsa-sha256;
	cv=none;
	b=27jggTnyJhbo0A8WmB3/k6FveUhLEAAKfAn6XJxU0/UWgsfSC1Y8JnWNSTokLlSJ+wAt4d
	sST3D6kB8EdxjS6c12YjmV/P/7bTToFaSurOrcUsAC2MyVFR3NU7G+F0+UjG9yRhHq8X8Z
	WOc6GrBpvv6L12/djuM7Ki+ICG8n7DY=
Received: from mail.maildlp.com (unknown [172.18.186.216])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4cgF2P1b5Dz6L51s;
	Mon,  6 Oct 2025 17:53:17 +0800 (CST)
Received: from dubpeml100005.china.huawei.com (unknown [7.214.146.113])
	by mail.maildlp.com (Postfix) with ESMTPS id CFE04140276;
	Mon,  6 Oct 2025 17:53:49 +0800 (CST)
Received: from localhost (10.203.177.15) by dubpeml100005.china.huawei.com
 (7.214.146.113) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Mon, 6 Oct
 2025 10:53:48 +0100
Date: Mon, 6 Oct 2025 10:53:46 +0100
From: Jonathan Cameron <jonathan.cameron@huawei.com>
To: Bharata B Rao <bharata@amd.com>
CC: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<dave.hansen@intel.com>, <gourry@gourry.net>, <hannes@cmpxchg.org>,
	<mgorman@techsingularity.net>, <mingo@redhat.com>, <peterz@infradead.org>,
	<raghavendra.kt@amd.com>, <riel@surriel.com>, <rientjes@google.com>,
	<sj@kernel.org>, <weixugc@google.com>, <willy@infradead.org>,
	<ying.huang@linux.alibaba.com>, <ziy@nvidia.com>, <dave@stgolabs.net>,
	<nifan.cxl@gmail.com>, <xuezhengchu@huawei.com>, <yiannis@zptcorp.com>,
	<akpm@linux-foundation.org>, <david@redhat.com>, <byungchul@sk.com>,
	<kinseyho@google.com>, <joshua.hahnjy@gmail.com>, <yuanchu@google.com>,
	<balbirs@nvidia.com>, <alok.rathore@samsung.com>
Subject: Re: [RFC PATCH v2 8/8] mm: sched: Move hot page promotion from
 NUMAB=2 to kpromoted
Message-ID: <20251006105346.00004634@huawei.com>
In-Reply-To: <b13fc805-728a-494e-93ea-f2dea351eb00@amd.com>
References: <20250910144653.212066-1-bharata@amd.com>
	<20250910144653.212066-9-bharata@amd.com>
	<20251003133818.000017af@huawei.com>
	<b13fc805-728a-494e-93ea-f2dea351eb00@amd.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.203.177.15]
X-ClientProxiedBy: lhrpeml100011.china.huawei.com (7.191.174.247) To
 dubpeml100005.china.huawei.com (7.214.146.113)
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 93A84C0004
X-Stat-Signature: x788dfch64xtk6dujuyuc3byrpp5giya
X-HE-Tag: 1759744433-513476
X-HE-Meta: U2FsdGVkX1/3Hfp3t36kj+B2H2XEPEsi8j2X0bmXwRcDS5nkwRVBg0Yv4flJNZcpYz5WMfZGN3NEO1WwQ06R/kd1VfPi6KLpt1ksiCix1BYiNJVs6koI1nxNdA88MDXGbZvUwxHK8byDoT3IrgpVojo04IDJdnGMOdb0caBUkkehWgbIah+1Ho81eTgR40lAR105PpWt/ybTh54//UYWCk1nst6C0qs2+r4tEuxxAXWD9KW4TQCj9KmlKsWeKhtP6bcZPfO7rilL9jLn7r69MpZT1R89fX1uTsnKmNyI8S0azwsEHQvyphyjd7mFtufVNGPgL7dYL1KGE1njtW3jLZh6DS4c/L4Z9V225MKh5TSV20y5XjMdHOIQ9ZH2i1/p7fxC5NHHLOVgSr1Yhgy5SL9bHre+A42Gkkw8t3rG1ac6fqUJhqhM2euc4Zq+xDeOR8yrJD90ltmu4C6v55rYPnI7qXZZCHKYVwMBE/babzLt2WzSYm8fYaxtskrcYqGj3Unzs0Je5/Hb1CqYaqlR0T9dz4+hGPl5luVMC6HeNrkNMc2d8zqEc8oDO8L5+C/QzlAuLQGbZgJLv68X4f7CntbEJCcJTTWH5roYky19osxY5XMx1wmYqQ7tuZToUIabd5FGgarghSJA1kSZ/1VHG+EZ3JzkZb+uFA98PyjLcbW6saRGEV/7KKKzsjXJL/GVWoo871lTjFX8PMRVh3FpWXjKo0NGJBg376LzByCfK0oN8yGZP+k/JtjELPy4wemVwqJNUj5inA6w395ALZxthwGcz8KUZfupLwO+GsUjtoNla+NNUiGjRPNEjl/ns6HweSKNZDZTStayJEchmKQgPK4vq5pgTSZExsIxG/Y7bk7tMCo/FtFFtvtBuaVNYFB1m/fQvy5fvEPUOn953FM2iaXl80/FvbccxlHrBasKdWfgPfF9fYMRBcRRfV7kqZ7/ySKxeSmyxbPgOF0CAQE
 TiQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 6 Oct 2025 11:27:21 +0530
Bharata B Rao <bharata@amd.com> wrote:

> On 03-Oct-25 6:08 PM, Jonathan Cameron wrote:
> > On Wed, 10 Sep 2025 20:16:53 +0530
> > Bharata B Rao <bharata@amd.com> wrote:
> >   
> >> Currently hot page promotion (NUMA_BALANCING_MEMORY_TIERING
> >> mode of NUMA Balancing) does hot page detection (via hint faults),
> >> hot page classification and eventual promotion, all by itself and
> >> sits within the scheduler.
> >>
> >> With the new hot page tracking and promotion mechanism being
> >> available, NUMA Balancing can limit itself to detection of
> >> hot pages (via hint faults) and off-load rest of the
> >> functionality to the common hot page tracking system.
> >>
> >> pghot_record_access(PGHOT_HINT_FAULT) API is used to feed the
> >> hot page info. In addition, the migration rate limiting and
> >> dynamic threshold logic are moved to kpromoted so that the same
> >> can be used for hot pages reported by other sources too.
> >>
> >> Signed-off-by: Bharata B Rao <bharata@amd.com>  
> > 
> > Making a direct replacement without any fallback to previous method
> > is going to need a lot of data to show there are no important regressions.
> > 
> > So bold move if that's the intent!   
> 
> Firstly I am only moving the existing hot page heuristics that is part of
> NUMAB=2 to kpromoted so that the same can be applied to hot pages being
> identified by other sources. So the hint fault mechanism that is inherent
> to NUMAB=2 still remains.

That makes sense.

> 
> In fact, kscand effort started as a potential replacement for the existing
> hot page promotion mechanism by getting rid of hint faults and moving the
> page table scanning out of process context.

Understood and I'm in favor of the that approach but not sure it will be
a fit for all workloads.

> 
> In any case, I will start including numbers from the next post.

Great.

> >>  
> >>  static unsigned int sysctl_pghot_freq_window = KPROMOTED_FREQ_WINDOW;
> >>  
> >> +/* Restrict the NUMA promotion throughput (MB/s) for each target node. */
> >> +static unsigned int sysctl_pghot_promote_rate_limit = 65536;  
> > 
> > If the comment correlates with the value, this is 64 GiB/s?  That seems
> > unlikely if I guess possible.  
> 
> IIUC, the existing logic tries to limit promotion rate to 64 GiB/s by
> limiting the number of candidate pages that are promoted within the
> 1s observation interval.
> 
> Are you saying that achieving the rate of 64 GiB/s is not possible
> or unlikely?

Seem rather too high to me, but maybe I just have the wrong mental model
of what we should be moving. 
> 
> >   
> >> +
> >>  #ifdef CONFIG_SYSCTL
> >>  static const struct ctl_table pghot_sysctls[] = {
> >>  	{
> >> @@ -44,8 +50,17 @@ static const struct ctl_table pghot_sysctls[] = {
> >>  		.proc_handler	= proc_dointvec_minmax,
> >>  		.extra1		= SYSCTL_ZERO,
> >>  	},
> >> +	{
> >> +		.procname	= "pghot_promote_rate_limit_MBps",
> >> +		.data		= &sysctl_pghot_promote_rate_limit,
> >> +		.maxlen		= sizeof(unsigned int),
> >> +		.mode		= 0644,
> >> +		.proc_handler	= proc_dointvec_minmax,
> >> +		.extra1		= SYSCTL_ZERO,
> >> +	},
> >>  };
> >>  #endif
> >> +  
> > Put that in earlier patch to reduce noise here.  
> 
> This patch moves the hot page heuristics to kpromoted and hence this
> related sysctl is also being moved in this patch.

I just mean the blank line - not the block above.
This is just a patch set tidying up comment.

Jonathan



