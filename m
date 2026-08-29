Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D9F50C61DD6
	for <linux-mm@archiver.kernel.org>; Sat, 29 Aug 2026 10:31:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ADAB76B0088; Sat, 29 Aug 2026 06:31:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A8B9D6B008A; Sat, 29 Aug 2026 06:31:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 979806B008C; Sat, 29 Aug 2026 06:31:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 710926B0088
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 06:31:15 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id DD41D1A067C
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 10:31:14 +0000 (UTC)
X-FDA: 85153939668.09.9255A6D
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf20.hostedemail.com (Postfix) with ESMTP id CFC8C1C0002
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 10:31:12 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=amWIdUn2;
	spf=pass (imf20.hostedemail.com: domain of peterz@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787999473;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tFeHJnfiLjvT405YufwKNGK1pvbaUZoRSpVuXj3avro=;
	b=HliVjpjBHwubKiEmehom+2KmAOWxotDQg/vIp4hzr4fkcQRqV9dpjLUhwGIMp9dv4i7GSQ
	w68/tWRiA0YTobkdpnRiXCLc5XZ6qnb77ZC9kJ56gs4wQ3LWd/JwiE/iJbtVTkQOUT3LKu
	fhF1oASXH7eKRxxrez2DogI0IT1+6Ec=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787999473;
	b=cfNy8DOWT3xKFJ9G9ZTVlumShjwjhGIDYohBPHTzLrjtOJ2fxWJ3VXDSEXKpSN0bxmGEnC
	EFrJSRsN+Luhmp7phd7R9+ZQOjMpuRSqdMvj5REchHzbNbQA7cOUAx/N1mXPUciRmYmAgo
	P3dgWyxzIqf871Ff3ZkJycxp8gIPGCg=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=amWIdUn2;
	spf=pass (imf20.hostedemail.com: domain of peterz@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=tFeHJnfiLjvT405YufwKNGK1pvbaUZoRSpVuXj3avro=; b=amWIdUn2IrSzxEW/4ieYFSFbQq
	c4rzA83hgoB+DLp4iZ89dutx/2cbb4Uik5zsjnF38wqKpryyH3awkCkaRlBdx3m8M2h2ZfZI+zvgq
	JTPNWIM51nMK68U1wmM5+0/15Qa80UAI8GKKcQMMQG9nF/qbfbUsr+CzeQSL1qYtx2l2K33ebGyDh
	JufbhLS8tALhNOh6PYDkck4iNOWTkrPOPzVwM4fV0jP8Jg1kNSrSGGZE9fqznCyDIxNmBUq4jKWzn
	L0GXTuBt7fJ3ycBaOkTdJW2DbmDwQknDpqqyw5WCvJqU1QXSeQlpyYuqsk/Ftsro4qgXtyGgioSeG
	Pxpius6A==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x0GL1-0000000GLW0-1waY;
	Sat, 29 Aug 2026 10:31:03 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 5D122300382; Sat, 29 Aug 2026 12:31:02 +0200 (CEST)
Date: Sat, 29 Aug 2026 12:31:02 +0200
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
Subject: Re: [RFC PATCH v2 01/23] sched/topology: Add llc_to_node() to
 translate LLC id to NUMA node
Message-ID: <20260829103102.GE776954@noisy.programming.kicks-ass.net>
References: <20260827122816.756234-1-wujianyong@hygon.cn>
 <20260827122816.756234-2-wujianyong@hygon.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260827122816.756234-2-wujianyong@hygon.cn>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: CFC8C1C0002
X-Stat-Signature: mscbcddm6whm6k6idazak8epgs94zg76
X-HE-Tag: 1787999472-795046
X-HE-Meta: U2FsdGVkX1+PqMOlmg0fNf6qDqxoEv4LFndTu647g8JPUbE2EzFf4U9GN09SBFi7OYL0abCQn0K4MOpckRLpKCXFGGVGrsuLQxvDvfjtJT5GuFL2He9Cj73leA2/KVkWNhY5KwhXgD2QfYYhHX5wlfGxI8WzS57GUo/nk7IwauUS+IZHe3WNeJ55J+rJJwg+D6ZfrhMxK5MPlirvSG00O4bznBBjZ0WyrgTzH4Z8XbqyiGSHl+MXL6eCog17bY/FtijLHbKwoV6aD5D31s8xsPeNisNOByye0fSnF+MMwkwrQP7IVa9hNnrBJsbVPt336t1WUuM1j97J9H+dKQhEP2X6YOdbe3444I/EZL0jKTid2cXg2Ih0gHfVcFNQW25SX9VkRMYQMpzf5hy4fZRMVDeqfV/DTb8X7FLpwJeVseSR8tpx7HW46bZeYNJvgDJojdhLq0l62E2QiKttrtKGQoaFYYq9ud2KC8c/ihVcd0k32OCxI5jRisctBGicy/N7xgstM3mqBEkI29GkcNQWvNxFzw3migmHzJrRoS0rW3H0GwWxplBGUyZywNzGu1z0n3R6bJyP4xLAkG44siqSrlnWg/Wp9sns1bPiR2z83vmDpJCyVOx34pm7XaKWIx+u0IN+NT+0JJdqQ6Rx5TDfpUpZrtGLPJj/x/fhyJMVyO8D0caqN1CGHAHQRC1wdqQyZez3IoDzTrUTAhCeShoR/Uo2VDDosGG809widc9eGkbEQ1xWlvNcXZN+9Rsh76YoX4psXFgqRMssnV2YIA5Kkd2e64C5Kg+r4oJMEy3d+aLA6gh7trS3O+oR0Tz33i/ORpOkzrMZSTR+g9IvEL6GzS91HNu9gOEK4QeV136wbfE227M8BRJPX8MVMSRivawl1Emw8cjUpscxa2kR0fvlTbt4nUxCxAgbLTigJWzmhsRD4x85W5tdYiKyQO6byAskwmAcZ6FZPpPEm7nRwoI
 xI0viUKr
 Ee3kcCLZ1dtxYQrvNVCbS1k4ega/DB3IQd3ygtN4w0Q/V6+ZC7k8fFMkndnohRlZ0CRQ6SbLhnayn4Og8MuG2AxqNC2B+ZeQUlRKaRqAaGpO8uJt7hKHwXEsij/PklawbjJKYWMJhiI0d9K78yhSz2+Q1e4OZYW5hJpeXPcp0z0ArGybXp0Ajb4Bn8duYleG1maKkgJdHGqqOw6jgdwSZYF/pCPBq0CDAuhFntgR73IxiRUGGmSI0/HEcTqO6S4d7V4+z
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 27, 2026 at 08:27:54PM +0800, Jianyong Wu wrote:
> +static void rebuild_llc_node_map(int size)
> +{
> +	int *new_map, *old_map;
> +	u8 *seen_llc;
> +	int cpu, llc;
> +
> +	new_map = kcalloc(size, sizeof(int), GFP_KERNEL);
> +	if (!new_map)
> +		return;
> +	seen_llc = kcalloc(size, sizeof(*seen_llc), GFP_KERNEL);
> +	if (!seen_llc) {
> +		kfree(new_map);
> +		return;
> +	}
> +
> +	/*
> +	 * for_each_possible_cpu() revisits the same LLC non-consecutively
> +	 * under SMT (each node's LLCs are walked once per thread), so
> +	 * dedup by llc id via seen_llc[], not by comparing against the
> +	 * immediately preceding CPU's llc.
> +	 */
> +	for_each_possible_cpu(cpu) {
> +		llc = per_cpu(sd_llc_id, cpu);
> +		if (llc < 0 || llc >= size || seen_llc[llc])
> +			continue;
> +		seen_llc[llc] = 1;
> +		new_map[llc] = cpu_to_node(cpu);
> +	}
> +	kfree(seen_llc);
> +
> +	old_map = rcu_dereference_protected(llc_to_node_map, true);
> +	rcu_assign_pointer(llc_to_node_map, new_map);
> +	synchronize_rcu();
> +	kfree(old_map);

Could that not be: kfree_rcu_mightsleep(old_map); ?

