Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E5504C61DD6
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 08:02:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E603B6B00AD; Tue,  1 Sep 2026 04:02:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E380B6B00AE; Tue,  1 Sep 2026 04:02:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D74B46B00AF; Tue,  1 Sep 2026 04:02:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B4BBD6B00AD
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 04:02:29 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id BCD2B1A0385
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 08:02:28 +0000 (UTC)
X-FDA: 85164451176.25.240DC85
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf02.hostedemail.com (Postfix) with ESMTP id EC66680005
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 08:02:25 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=aG7jL0US;
	spf=pass (imf02.hostedemail.com: domain of peterz@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788249747;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hIORJwUFUu1xQvcDenW4pwSoxemSIs5615nsSp+Drl0=;
	b=TSp53/wacYq6D/y1d6znSJofL2D1NNujNbEgarMBisgL8/KI25xRQbf/lsz8ZYAh4WApmb
	ptg0eI8/XP2utFKxXBCBEqao8pUFtL1ocUHHjyEJiwarQHVHfgVXSUflE56bcBqN5dXn2t
	p4wTX1D5P62Vy+64zZPyqbaDckU4BWM=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=aG7jL0US;
	spf=pass (imf02.hostedemail.com: domain of peterz@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788249747;
	b=bVLxzQzyzXkSL/bNqHqpPVcj4qtNiv3cn4ts/V1nKWP3U86lN2FQW9G70xPSWVy21FU3os
	NwSy3EtNF7ssMb7qZclHwNP99XHuoPKP69D02E9KX4vqneu01zaPpMqOxj0Lpfd+3dKmk/
	GQSzI5lKEGEv/ksFR1t4fAx7h7IAc8w=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=hIORJwUFUu1xQvcDenW4pwSoxemSIs5615nsSp+Drl0=; b=aG7jL0USdHAN6TCMpSVVc+AW4w
	ASUjnslClIMVHwBGKOckVaM5Mc/uuBbNilYEmnJbIGHNshKJPaP2tRMWSV3fhlovewzXZX7wKhfbd
	LMYm/6KMWd5LqmsGGB/UaUYzBwaCpbi/xO+GZ1s/NnDWj2pOy2dNw90Q+VxMrP5Q/Bj6pRN1UzbVC
	EMwQtwFS99FAbO31C9E5onyJypc+m9WPYmhbzY43IuHm/7xrD/hQ/GYOlBigiwzIF4UB54fZegLK1
	zbKQ6hVR7cGurIhJgwSWJIpt23+NXwOirlVw166bhP3gl8uiOaWPwPNRq98qtrTVXzW89uqxoD+ot
	sIvdbTJw==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x1JRb-00000004hjW-2D31;
	Tue, 01 Sep 2026 08:02:11 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 2285F3002ED; Tue, 01 Sep 2026 10:02:10 +0200 (CEST)
Date: Tue, 1 Sep 2026 10:02:10 +0200
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
Subject: Re: [RFC PATCH v2 10/23] sched/topology: Add per-sd scratch for the
 load balance affinity score
Message-ID: <20260901080210.GP4120091@noisy.programming.kicks-ass.net>
References: <20260827122816.756234-1-wujianyong@hygon.cn>
 <20260827122816.756234-11-wujianyong@hygon.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260827122816.756234-11-wujianyong@hygon.cn>
X-Stat-Signature: ruu1o5qigrm61tgcbnfpy9dch1k75m56
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: EC66680005
X-Rspam-User: 
X-HE-Tag: 1788249745-909195
X-HE-Meta: U2FsdGVkX1+lDV+QRuN7vT0t6i4xsBNOI9jhlKNoSQdKVJOxhwzwBCIv2m78RKI+NzVX9jWK5Lb16ydcZqpWmVcIaW8QvTwbu6dRv1lJNnc9DDvsRHxopA17lcePjkVJ+QutLgGBNfQ251QRZ1FtxXBfQulkFPpLC/SfGwiXZ0N8kOQy1oBz1GdUq0UfumJXKAVKjo3Nk17ja2X4C/4UmU9pxR9epGnTIRvMGnopZeKUhbXrPF9bYFy5NPJk8A+Jsi8IbvuH29n4K0/qCspop8Q6nyft/rvzN3v9iJUyQJmNFhw2+xmpLj8ibpMhO777vMQ1TEmFLMiDaOv2UugOKgJDw/vIu4fS67H5GcQ1LwolbG8wEtVtZveKB6CdH6I8AuYl2zC+BmDakcWkHJkQO2vlQIHzojpRrgWEKmubX0g2hNLMxp6/gvT+wcEWeTf1X4kZ4nDZZNVVXtivb6dVM2mG/XAv9gMS32YJ5XQ4n65AbQ9/7bGhUvL8RW7xVX6C4zXH5YGScU9OX9Kj4VdA0CME8+MQuQWuEViPJjuqV6KFfYapxzKH18PM+C4zeBmZDU52FkGtLVeXlei5V6sjA+DKAPl1J0O2cSm2qgUbKaZDfRRT0tzHSUdlMp5fm3V2yAbdGl2RJSFVcT+oVIvKnXdLOXImrpey+a1wx8I/qCQxXRgA5uRMzYSguhIW6VoK7cujPuskKJDk4F6UmWV1hAdL2fkW6EXxC1LKny46PbRZ/U2DB1AI11agHKcy43O1G8kyMd9WTB2tn4o3UOo74Ie4r3A+HDIXd/Fqv+s/bSFgQYVBub75eRV2E3vgTjZei9kNvhdmXNslU3UTsBomUAK3XQarC3+FSZvBv44vrMg49Lma8is+hq6GIITuetnN2cFhXhZEIJk+lZQgvG3eCsQQCoHFcIWf7f7lLALgPSsiT5G7VBWuc5xpVU9ggH/NfU4MxGiAUAN49zj/SL/
 ZpBsKw9G
 TJIFUFY7mGyG6oS12OmYlay0Xje3Sm9f/kI9XIb8kd3QsBXOKQYCCc9lnNJTj2auSCsTxe6pOuFgW1e1CFoLP9B/wpdACzzwQMkVKE6Gv7iTd1oSAjn1RuloPq8DypZjuv4znX7n013PyFscrn/izAtJTBhb1+hiP8G8eDQbG6KlrB529Xgq1Tj/Zv87uLPraHAT7JwvYUOkD0b6DeeFaCMT1Du286gHyb3vjr2aPsI+J3+M=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 27, 2026 at 08:28:03PM +0800, Jianyong Wu wrote:
> The affinity score computed during load balancing needs two small arrays,
> one entry per LLC: the LLCs that sit closer to the balance destination than
> to the source, and the weight of each. Their size is only known once the
> sched domains have been built, which is why the load balancer currently has
> to allocate them on every call.
> 
> Signed-off-by: Jianyong Wu <wujianyong@hygon.cn>
> ---
>  include/linux/sched/topology.h |  6 ++++++
>  kernel/sched/topology.c        | 28 +++++++++++++++++++++++++++-
>  2 files changed, 33 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/sched/topology.h b/include/linux/sched/topology.h
> index b31d2cf16592..569ff562dbdb 100644
> --- a/include/linux/sched/topology.h
> +++ b/include/linux/sched/topology.h
> @@ -122,6 +122,12 @@ struct sched_domain {
>  	unsigned int *llc_counts __counted_by_ptr(llc_max);
>  	unsigned long llc_bytes;
>  	unsigned int *numa_counts;
> +	/*
> +	 * Scratch for the load balance affinity score, llc_max entries each.
> +	 * Only the bottom sd owns them, like llc_counts above.
> +	 */
> +	int *affi_ids;
> +	int *affi_weights;

Per the below, these should also have: __counted_by_ptr(llc_max), right?

>  #endif

> +		p_ids = kcalloc_node(max_lid + 1, sizeof(int),
> +				 GFP_KERNEL, cpu_to_node(i));
> +		p_w = kcalloc_node(max_lid + 1, sizeof(int),
> +				 GFP_KERNEL, cpu_to_node(i));

