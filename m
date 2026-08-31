Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 74549C624A4
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 13:17:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 88C616B0096; Mon, 31 Aug 2026 09:16:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 864986B009D; Mon, 31 Aug 2026 09:16:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A12D6B009F; Mon, 31 Aug 2026 09:16:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 58A6F6B0096
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 09:16:59 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id AB2CA160115
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 13:16:58 +0000 (UTC)
X-FDA: 85161614916.19.3EA02D5
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf22.hostedemail.com (Postfix) with ESMTP id 4CAE9C0014
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 13:16:56 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=r3i6qXUL;
	spf=pass (imf22.hostedemail.com: domain of peterz@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788182217;
	b=20nTEqTYmrsEU6IVxooxilnMSDyP3MH8zh9hxMBKZWdIWcc79dYwPdhu35O5EpBWDSTU/J
	19Asuwzy3XsFEvb6l73Ibjm0iwDTtaGrOgDQUzqWVqk9jJB2FSJSMOBigSDd5DrOnEpK+Y
	67LC+vEU8BoZ+o7Wxh4G+uTGk4SZDNc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788182217;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iS+QKvUiauQ5ltYL6rGwKb7rRjDBV+mGGCSvRrum6wo=;
	b=qNOiK/1nZh6c6PWksr6HlqIxPEXXs1CTlKifcB1NNSQs/DF1mo2T8SP0PWmD9eQGcnYvk3
	igj1F+p0LKXZbTUvAcgSYjYAk8Wh5CCygvnqscLxsYgvINsHcCx1RrKQDzMqVNBWYgCIXS
	5HpQ85CA4SNWEuipKan5hRs01BHiDN4=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=r3i6qXUL;
	spf=pass (imf22.hostedemail.com: domain of peterz@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=iS+QKvUiauQ5ltYL6rGwKb7rRjDBV+mGGCSvRrum6wo=; b=r3i6qXULGg1E0EIB2oBQ+M/rh+
	KeM2V/bYv4Du8XK2HmhMsYNwvjSSlkBYncDfmYXAUSbRTCJnCQJ2TliZVqOrodewx+vCa0HAle5Ab
	mc/lj54rQf09d8BzVYn+LH5Np9EPowx4cIT8m7KWmYvShP05WIu/ti2q9YalC9QJLrogHAeSsSAOz
	lTdNy/0znqJWf6uzC59DOEUQAs6cDxKUPnjhOrRbUB0f5n8Qd/Oy9oR2A5hihfvOkZNBuz8eaihKp
	oq5kX42FbDVhfrQERs+ox0eRJmEi6h6AeUG/L2RYO7Cj+HG2Y8MlllQS8qYtVU7PYj+BBYePh5+sh
	vJNjq/7A==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x11sT-00000003ISb-3xLT;
	Mon, 31 Aug 2026 13:16:46 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 0CA6B300E7E; Mon, 31 Aug 2026 15:16:44 +0200 (CEST)
Date: Mon, 31 Aug 2026 15:16:43 +0200
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
Subject: Re: [RFC PATCH v2 07/23] sched/cache: Prioritize preferred NUMA node
 selection over LLC selection
Message-ID: <20260831131643.GK4120091@noisy.programming.kicks-ass.net>
References: <20260827122816.756234-1-wujianyong@hygon.cn>
 <20260827122816.756234-8-wujianyong@hygon.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260827122816.756234-8-wujianyong@hygon.cn>
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 4CAE9C0014
X-Stat-Signature: 7ykt4ifjogawxjgx9fro94jdiui8zdok
X-HE-Tag: 1788182216-537355
X-HE-Meta: U2FsdGVkX18BJqgpHunIHVHicKq3jatVHfo1K3qrXYYmAiJA64Opo4z5hjD2le63q/BXUu9uqKbRgpiqz34q2v68U5VQIe/5E2tC38xrvUofGMFpv6771n8r71jkX8B9UKA1n1H3QLAHgVwBRC+bRbr1LnR4QXj+40Xh81W4kejFGtwgMiB30R+McXrWgzABU8FAmAddywKEZMB2ptd3VnEwgRu/Xy8MVbHxdYslXIppoTLEJ/f/jCP8H9C5otePLVD76pd5BRt28i7XD2WzXRzRh52BaMawbMstkwb62SRdNfJ095IeuQh/zGZxIaai3WKBCzLevXvR/DcIqRQpEhi5mbjpM0WBN7pHggbxaQCcapXgLyb21U04sYb5ZY/JeiWwF2mNBTQQ+MrJAsmsqgPBlpWhX/NW4fJ0tdMv7k0+/PgV4fzGHrnsCddI3qxpfM5GBOnYW77ec/TXUuGJk1MGkBB4VAEhRfK29ZSsLPIz+uWCEcqj/3QjiM7RPWwbIecv2XfZrHw9IUT8NT5B4IQlVbWNIdR2nG0RddDzKx/R7gSo8hXptc3uHyYoCXjkCxDe8pXF2UBVyXcP5N6a6jS8OBE7OnR4WPYTcnlTZDVUIbi3PugHssAaYrH3IU0iR7L11AgRhVz+ruscpsM5Y/l8Y4H8e+o5JtbZ1TwK5Gj6l9BqsULgWyeZJaz/rfzT8YTtkUde98BAAbfjJOvV3K61osaUNyWrVqTALrpYUIo/C4Ii6Mi8K7nX3K+NXlaRlZqu65+qm2IxGJO3uC9b46DZdijOjgRnfOwqFl7kdxrnRhqbBx2W9aOrk99VgZc8iQWl+gDJpXpXUE7A3g1pGQe4bToBjZoqi/Bl71gHgZVsRwdVV99qy9j43OxrxVv4qLW/QRf56HEBM28vL79CQ8VKNVHRzz+MndNGl59ibOhJD7gyDKspwiLw7YqxBh69iNtKAn6n29JtM/vNkZh
 +cWd6Tel
 7vDkUFR/wr29k2ptPRs472eJGEDMMzM9CU5rwhwwb/glJ2yexMfD9WFdxF34L+ewF+5T29LJTqaW69QRN5EudjsLoEdl3HMyVVg2gdH6tPhxCgYGXNE7DB78NLDZ1Cnufgx57ahaSFBkTGGJNOVsoYrni1ox9V5WHCkwSWv6V3GpR0ER8QQsGQsCC8gtEa4Rn8Hdw2gA6jcPxI8asjiB6W9fskfdJhDne1EaIboMOQW6vzpc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 27, 2026 at 08:28:00PM +0800, Jianyong Wu wrote:

> +	/*
> +	 * Avoid switching sc_stat.cpu too fast. The reason to choose 2X is
> +	 * because:
> +	 * 1. It is better to keep the preferred LLC stable, rather than
> +	 *    changing it frequently and cause migrations
> +	 * 2. 2X means the new preferred LLC has at least 1 more busy CPU than
> +	 *    the old one(200% vs 100%, eg)
> +	 * 3. 2X is chosen based on test results, as it delivers the optimal
> +	 *    performance gain so far.
> +	 *
> +	 * Moving to another node takes precedence over moving inside the
> +	 * current one, as it did when the two updates were applied in that
> +	 * order.
> +	 */

Comments should never refer to old code that no longer exists. Comments
are for the code as it is now. If you want to expand on details of the
transition from one implementation to the next, that's what the
Changelog is for.

> +	if (m_a_n_occ > 2 * curr_m_a_n_occ)
> +		new_cpu = m_a_n_cpu;
> +	else if (pref_llc_cpu >= 0 && pref_llc_occ > 2 * curr_m_a_occ)
> +		new_cpu = pref_llc_cpu;
> +
> +	if (new_cpu >= 0)
> +		WRITE_ONCE(mm->sc_stat.cpu, new_cpu);
>  
>  	update_avg_scale(&mm->sc_stat.nr_running_avg, nr_running);
>  	free_cpumask_var(cpus);
> -- 
> 2.34.1
> 
> 

