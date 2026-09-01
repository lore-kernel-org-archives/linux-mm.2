Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7BAF2C61DD3
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 10:16:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 411E46B0114; Tue,  1 Sep 2026 06:16:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3C29B6B0116; Tue,  1 Sep 2026 06:16:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 28D066B0117; Tue,  1 Sep 2026 06:16:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id EEC146B0114
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 06:16:18 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 58181A03B7
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 10:16:18 +0000 (UTC)
X-FDA: 85164788436.29.30B4EE7
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf06.hostedemail.com (Postfix) with ESMTP id 04997180004
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 10:16:15 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=vGcnOMDe;
	spf=pass (imf06.hostedemail.com: domain of peterz@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788257776;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=G5jvN6YRvxNquzzcBmcxTrfd9PTx/7jSkn0g8m6DHYo=;
	b=7CImXlueayyEjJ++RcKNNbXgdMkpkgEy8cvck8zrpUYqWc/+PPiQAzgDXf7B6qmwl586f1
	rSycabRPI1W3CWiLwU4vttDK0sWC2yMds9afYnG9tlL4nvLvn4QEzZOIb+vMi8nmOziNoq
	PJkuNdJfxTC0vfsu0R8LFXSXz+zF/Yo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788257776;
	b=e2Se9tRWJPHkF35ro1HubWDhHkIh7+eAlP+6RA856mHtcbgkVk6hIPlucaGmEnj4HXCWTT
	SWY/ytIv0pKcNJpfGyDoZHG1n4JfAwHJ5Ub9W8GctuuZSWNapiQXFo2q+BuiHg+0a0F58j
	chH3zX+stGiuXwbOLWBWEN+QVfZuTto=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=vGcnOMDe;
	spf=pass (imf06.hostedemail.com: domain of peterz@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=G5jvN6YRvxNquzzcBmcxTrfd9PTx/7jSkn0g8m6DHYo=; b=vGcnOMDeA3NpwZyI1OsXCeZXPD
	rOfAwAo5TklKxNAGwRANCSJUYSdbjsuPNbF3xxfcm4XNJwR1Zmrbn9yiGeUWi7cZjMUhv5sf6hjnZ
	zwjVDHxOIvRHYhLJSdoh99OoJjzu04iznqIo68Ep0cxDHEjSmUaD/GlZIN6xIoTnHAiDcdamXmlC7
	9A9YmBri73tuNPBoTiegfLhiSw8YUT4MM4Cp9RQem3OvXLThWKFcYjYQSZ/ALuk+zJ0rUHLJZ++Ao
	a1m4hITAhkPrRCLgBXpIORnpcoQRPOQehmH4x7HwcRnrwuowVFONrT33c+5EtOj8kpWouERO1EXQu
	PxjsUK/Q==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x1LXD-00000004vHy-3aGj;
	Tue, 01 Sep 2026 10:16:07 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 1AC9430031E; Tue, 01 Sep 2026 12:16:07 +0200 (CEST)
Date: Tue, 1 Sep 2026 12:16:07 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Jianyong Wu <wujianyong@hygon.cn>
Cc: Ingo Molnar <mingo@redhat.com>, Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Chen Yu <yu.c.chen@intel.com>,
	Tim Chen <tim.c.chen@linux.intel.com>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	Phil Auld <pauld@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, jianyong.wu@outlook.com, zhongyuan@hygon.cn,
	huangsj@hygon.cn, wangfengyu@hygon.cn, yingzhiwei@hygon.cn,
	justin.he@arm.com
Subject: Re: [RFC PATCH v2 12/23] sched/cache: Introduce rq affinity gain
 calculation
Message-ID: <20260901101607.GG776954@noisy.programming.kicks-ass.net>
References: <20260827122816.756234-1-wujianyong@hygon.cn>
 <20260827122816.756234-13-wujianyong@hygon.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260827122816.756234-13-wujianyong@hygon.cn>
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 04997180004
X-Stat-Signature: 4pu56jay47kh7wt9swqwes86p8scyzhb
X-HE-Tag: 1788257775-699704
X-HE-Meta: U2FsdGVkX18/toXW/ikN1G16/KPUobbiQddaXvAXJDOvGDBWf7ctdADUD22r1ebTTE6jLixRgsFkwLHzE5DFw5pM0MzXDof5pvG0jf8mnj5hZWTAdqjcly5aT2knj01ifbpUORnV0VFq+G1tqEOpjlX9HATA3trvjhyCG/gk77cp8rOdTBSlrIhuncwbTYQM7RsSmrY/+kGQqJBoaVGAuEmSWgs5EFt43tFRbNfEIJ0YQyuZqjsVK8tjTdMycNva/9h9yFAi8zLAus3txpPp06Hagsos5wm1yYRGj0QbRM9gteEvKH4bXJx6eKdA1BX5H+29wejNO+9rA7c4wnEsjtNiwTILF6tHuo4PSskWgc2CGgP34+u7PaPHKlrZorxz/oS3BkIuLGs+kTPY1jY8piQMit/eEcuFzKnkYmySsCTMe9M01+F8ge5IPuHW+nokRHqStT0raoE3TanLAqKZu62Y9t9Qonclu+TPrPNCj7kVNvnzaoEkVYscIn2ahM8jaGqmYhLHcuGBvWaLdf7Hjnuu8g7WydbgZ2kduriIah760ah7Ne/bwIWPPmvphYXMZwu0STEh3oGZWMepMoLk6eV3JAw0wdg1ukKzMpaNM53dbid1JblDyfn5e1/simvv/vhYQf0HtGVrOf8OekQ1HJr1RKGwEfK8zW98YL2Ze+VHNgTdC54zrrfbWh42kFpIbPsBicN54Z/9UYf+mP2AcRRy4ngFOSbtXGq8RJhUy/LtkAW/eDHrHIdbSIgNd31IWeSEy9rFYEQIG82Eujf4x7zKf8IPomjXdM76odQlD7jU7hJw8TNEPAXRg32qRyEcJnwS5ldI5bgrCjqOXuVK6A87wwvM167uRejoR0+x1ZycSgZNDh0SWLOYylseZYs+EIvudk8NZR30xoplOCu4Pk9rIkq3rEckfQYhs3Z+CHtgEShYoZCVpAHeCeo/MgRK3WbuV+Lohm0Ml5XFWGY
 UCBPnydD
 y2fd3wvSyQLEJsSAoXhHbZYMvMUTag/rEj/AOsseb+3MuySqnsvXLKUvCH+hweHg22bi5hOTZf8zoH0AHeWdDgBj8PnrvwO3oYTW0wPuMaJUgw6GqznnI6nv8krrVG3vO5HiMcuZOTGiDjL14rkq9PWMrPpiH2qJyr9F89rxtysGt2KzJ8jvOxfSFtZhEVMo7xbTfei4FG24APFg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 27, 2026 at 08:28:05PM +0800, Jianyong Wu wrote:

> +static int get_affi_llcs(struct sched_domain *sd, int src_llc, int dst_llc,
> +			 int *affi_llcs, int *affi)
> +{

> +			if (src_llc > dst_llc) {
> +				affi[j] = clamp(src_llc - dst_llc, 1, 1024);
> +				affi_llcs[j++] = i;
> +			}

> +	return j;
> +}
> +
> +static int get_affi_numas(int src_node, int dst_node, int *affi_nodes, int *affi)
> +{

> +		if (src_dist > dst_dist) {
> +			affi[j] = clamp(src_dist - dst_dist, 4, 1024);
> +			affi_nodes[j++] = node;
> +		}

> +	return j;
> +}
> +
> +static int calc_affinity_numa_score(struct sched_domain *sd, int src_cpu, int dst_cpu,
> +			int *affi_node, int *affi, int *last_node, int *num)
> +{
> +	int src_node, dst_node, score = 0;
> +
> +	src_node = cpu_to_node(src_cpu);
> +	dst_node = cpu_to_node(dst_cpu);
> +	if (src_node != *last_node) {
> +		*last_node = src_node;
> +		memset(affi_node, 0, (max_lid + 1) * sizeof(int));
> +		memset(affi, 0, (max_lid + 1) * sizeof(int));

This and..

> +		*num = get_affi_numas(src_node, dst_node, affi_node, affi);
> +	}
> +
> +	for (int i = 0; i < *num; i++) {
> +		if ((unsigned int)affi_node[i] < nr_node_ids)
> +			score += sd->numa_counts[affi_node[i]] * affi[i];
> +	}
> +
> +	return score;
> +}
> +
> +static int calc_affinity_llc_score(struct sched_domain *sd_cur, struct sched_domain *sd,
> +			int src_cpu, int dst_cpu, int *affi_llc,
> +			int *affi, int *last_llc, int *num)
> +{
> +	int src_llc, dst_llc, score = 0;
> +
> +	src_llc = llc_id(src_cpu);
> +	dst_llc = llc_id(dst_cpu);
> +
> +	if (src_llc != *last_llc) {
> +		*last_llc = src_llc;
> +		memset(affi_llc, 0, (max_lid + 1) * sizeof(int));
> +		memset(affi, 0, (max_lid + 1) * sizeof(int));

... this. Why do we need the memset()? AFAICT the get_affi_*() functions
use direct assignment and the sum is limited to the number returned.

> +		*num = get_affi_llcs(sd_cur, src_llc, dst_llc, affi_llc, affi);
> +	}
> +
> +	for (int i = 0; i < *num; i++) {
> +		if ((unsigned int)affi_llc[i] < sd->llc_max)
> +			score += sd->llc_counts[affi_llc[i]] * affi[i];
> +	}
> +
> +	return score;
> +}

