Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5EFD6C624A4
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 13:23:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 404626B0098; Mon, 31 Aug 2026 09:23:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3DDD76B009E; Mon, 31 Aug 2026 09:23:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F37A6B009F; Mon, 31 Aug 2026 09:23:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 15E116B0098
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 09:23:39 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B3053160135
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 13:23:38 +0000 (UTC)
X-FDA: 85161631716.27.8F911F1
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf06.hostedemail.com (Postfix) with ESMTP id 3B1A418000A
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 13:23:36 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=P0x5Fl53;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf06.hostedemail.com: domain of peterz@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=peterz@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788182617;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1manqhE5SPjOZ0jcw17QGfzE49GZ9i2XHdOv453K6ho=;
	b=At/cL5jKcM5iVkNBcrYKDhAuvJai1yjeOcfGbwQXeBu8Q6j1IoYmU6qn0E4Jtbnii/Dmj2
	EYDWl2YCVU9gKDy3gNtf0imxsD9R9zUJ2cuNIu5LM3AlN6dTell5lZh+R//zlPB/6tMxRM
	KYTAdi0uSowypDJipJpKLoEqo9JRIeA=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=P0x5Fl53;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf06.hostedemail.com: domain of peterz@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=peterz@infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788182617;
	b=6Ds3aHtof5Bn1RdkxUO0AcdXcCqXw8HUkaO0hfces9x7njgAwNu7PJUjoFAvLkTGE/KSnf
	52BPX529pslPggDk77KdZLfuY3kJx0Y9BTRTWO9ka0tcJ/UZdhvC/wXP9ykiKm9/wbdEn0
	vGpvOhmupWiWAwaciM/KiVeHiEX1D0g=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=1manqhE5SPjOZ0jcw17QGfzE49GZ9i2XHdOv453K6ho=; b=P0x5Fl53FWCdvnRNpccMOGEvV1
	nhrGMII0sRZF4KaONQS1HM1mHpD9vfKQLxv26J9M4exvR8DViuXZEjo2PHt7984h0B0MIqbKRTPpa
	cJDl8u5sz0VPXSHlKvXYTt9TS6u0rBlGWBdD2ariI5ta9vDwtYF6d4YL2nmSxHRrF8bbQ4uvIQYT2
	nEu6/DTwZ+peCXibb2ONuhAX/+FTw60po5eyn3b2Ok38QwjwVTdPxB+aZSFH3ckd54V1SKQXQvQP2
	lKIZ3GlKwZV+BdnXF9b4KKjk6176zbJA8Hv6u3ZxT2NkhYUDfVHNeodCBcHX7VoIeWsMbPLbKpPTo
	ct/K5Vog==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x11yw-00000003Isx-0t9I;
	Mon, 31 Aug 2026 13:23:26 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id BEF11300CC0; Mon, 31 Aug 2026 15:23:25 +0200 (CEST)
Date: Mon, 31 Aug 2026 15:23:25 +0200
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
Subject: Re: [RFC PATCH v2 08/23] sched/topology: Introduce a per-CPU tasks
 NUMA preferred counter
Message-ID: <20260831132325.GM4120091@noisy.programming.kicks-ass.net>
References: <20260827122816.756234-1-wujianyong@hygon.cn>
 <20260827122816.756234-9-wujianyong@hygon.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260827122816.756234-9-wujianyong@hygon.cn>
X-Stat-Signature: u733osg9we541aua8dytj9e833ubgstb
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 3B1A418000A
X-Rspam-User: 
X-HE-Tag: 1788182616-435595
X-HE-Meta: U2FsdGVkX1/h9bXiGxrHFwwCpAjGMy/D9Tz6Qdqdcxsg5BHzcLIEIGNGJUImh30E69BtFqaKxursstr59s3JU1x5x5ihJKP6HCaV9IGGr+bj6/1zIpqSQ+qgFnWwRKkLHg3duqrK8CPWyuDnqEer6qVefKd/TlVi7hQPiDAUjV2ltu/GYDSoaiUFNOy5RS07a7+OCI3vOLi4hgO2TYuRYgXHvbrwwQKHmWinIHuOJFi58lff7v/w50wamizNdBeqlwQF3PphFuDedScoZbC21wMbtroVl2meVn6rdG3Mz/WyT60QXOmnkCCDzIwgcAMZxLZ+zL55ezc1T8EG1iL4WX/gUTQXlUi9pWw/NQvVisV4XN1HphRX2RqURaji2kRmOTjOzt38thNo+y9r6ySI+Ih9qG/XQRP0OCeNsN9L8ideki/DJb6WLZTNZIrnbDDvJuwR0cYWQo/kZyRkvHpSsri40xrtabjE2BL47NnUVkCFnOozpvQkk44pSaOhZAhonmFEDKSxRo73ZGzQatQ1DZusLXk01jo6chCDKO+G7O3N7Q653qw2MZKM6q3i5wrgEyk7DMzlu0kH5veOsDUXQBX2EGQ/SbymVrbTiXwKR3QXTGFvOiK2638iyVB9HHPIOt9vV+YGVRSDsEVBq2+JTrX6fhWG0lYrAWfoKU2H3LWjUWlxvnXGqMecMl/7iNuCPKBL+EdzZ38zSUydkucosTt3Zqgug7WSjsnIcgoUHRy/aZCjR4keh4WU0qsCJooeRUsOmEo8oseOFiRSg6vUF617k1/6iHsqTi58LUxwv6eNSZ4NTm9sjgy9txREQmYBbduFz/nxk5QEpJuaormIqR9j9PulRJz8qOQTIcdlqzTkyE2ujOkmdP0ol/OG1LQ2Tu+BTc3CQkHKv5dfrql9nkXlzcx59ir+yFwnfdKW1Z4JYvUZHjSg3U1f1Py0Y3XdNvnY9g9IwP5ygf5lU0C
 O59eRDbB
 JrtlUUTfQWrLAyo9M3aXPFCwoBc9Z//VF4WhicJeOXGLpreNfIoWYwBnB0MPucpfyhroBDw14noLXwI/oS5LkwAb7cq0leIC/h79SL3Pdevs62Ici8tTcbUXcU8tEgZQvZSZcxzrxl0178FE/uNOUYN7Xr4jnJ1CYq9LefE2HnQdj9SftDbbwDaOqof5HVdZ6+IdZhPzgpBBR5B0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 27, 2026 at 08:28:01PM +0800, Jianyong Wu wrote:
> Like the existed task LLC preferred counter, sd->llc_counts, introduce
> sd->numa_counts to denotes the task number that prefer each NUMA node in
> a certain rq.
> 
> Signed-off-by: Jianyong Wu <wujianyong@hygon.cn>
> ---
>  include/linux/sched/topology.h |  1 +
>  kernel/sched/topology.c        | 33 +++++++++++++++++++++++++++------
>  2 files changed, 28 insertions(+), 6 deletions(-)
> 
> diff --git a/include/linux/sched/topology.h b/include/linux/sched/topology.h
> index b5d9d7c2b8ad..b31d2cf16592 100644
> --- a/include/linux/sched/topology.h
> +++ b/include/linux/sched/topology.h
> @@ -121,6 +121,7 @@ struct sched_domain {
>  	unsigned int llc_max;
>  	unsigned int *llc_counts __counted_by_ptr(llc_max);
>  	unsigned long llc_bytes;
> +	unsigned int *numa_counts;

This is missing a __counted_by_ptr() annotation ?

