Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C974FC61DD3
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 11:32:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BC55C6B00C9; Tue,  1 Sep 2026 07:32:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B75D36B00CA; Tue,  1 Sep 2026 07:32:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A8A2F6B00CB; Tue,  1 Sep 2026 07:32:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 861626B00C9
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 07:32:21 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0E1C3C03C4
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 11:32:21 +0000 (UTC)
X-FDA: 85164980082.01.89E17A8
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	by imf12.hostedemail.com (Postfix) with ESMTP id C987F40006
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 11:32:18 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b=OkVlHmWZ;
	spf=pass (imf12.hostedemail.com: domain of peterz@infradead.org designates 90.155.92.199 as permitted sender) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788262339;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=In4PIJOfYGktUiKwvOjB/5uZvBatL+sz1EUZz0UG1eU=;
	b=fD1iV6jWBVg/tKAiCPgeC1wjFVO0qUrwq6n2HCmwK2lTgLQObZP7r5bbkf1e7TGrLFm6KF
	Si/p2ljXgLP2TxXBvfeZlrsBJ4sF54ozj4mUVpwP4LIIGESZPdzNGCEHLWBkR1wLeAWUis
	d3gZ30pwbAtkAKlAr1soNYBSnHYzh0A=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788262339;
	b=O3GpL5OsihnNVGSuef73ypo8qNHT7AIbuRUwgtcE+km7QKzrZKzYNTDo1DFDg48GEGgSpc
	f8qZaA5oeYRBZrEzjlHOaFIzeAew5j+Qlsdbv81RRU/qe+UUtW2HpWxRf+fxyxmbeIDXzb
	cX+uLziEq78S0QnT5sndS1GZuLDAUgk=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b=OkVlHmWZ;
	spf=pass (imf12.hostedemail.com: domain of peterz@infradead.org designates 90.155.92.199 as permitted sender) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=In4PIJOfYGktUiKwvOjB/5uZvBatL+sz1EUZz0UG1eU=; b=OkVlHmWZt6wGhGHcsI3AZkVsvF
	zyxIhkA5M798NqwDk0Hev9Fk+C4L++K6gplBOuA28LL1H2RyDuiXG55wrKzSeK6HQ6JrePhoN1FsS
	2GB40JVYSbQKbCpXo7CoVfBnmgG5SJibUvdhf6Rnt3aVIERCiqoTT41tVvRzx3NZmLxGpNJbhMeCl
	ovsbGgs3DEgNSqTj8O5RhWu1QPPOjxmNgfOvc4aMEpm2XCE6r2+o3F0z2EMeNp8uTAu+QWtwpip5w
	uPOiCdbLH0a728RsIMIwGY5+iGkS2LO6UBKHUTLSFhEhzrmXyJ8CS9gNdj868kM0MYG6e2MTupkbO
	bzrYn0Lw==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.99.2 #2 (Red Hat Linux))
	id 1x1Min-0000000AuHS-1FHZ;
	Tue, 01 Sep 2026 11:32:09 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 9D54230031E; Tue, 01 Sep 2026 13:32:07 +0200 (CEST)
Date: Tue, 1 Sep 2026 13:32:07 +0200
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
Subject: Re: [RFC PATCH v2 11/23] sched/cache: Introduce helpers for task
 migration decisions
Message-ID: <20260901113207.GZ687043@noisy.programming.kicks-ass.net>
References: <20260827122816.756234-1-wujianyong@hygon.cn>
 <20260827122816.756234-12-wujianyong@hygon.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260827122816.756234-12-wujianyong@hygon.cn>
X-Stat-Signature: ugwc3tbe4u17zqp8j3o34hr4tgzfpdww
X-Rspamd-Queue-Id: C987F40006
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1788262338-322247
X-HE-Meta: U2FsdGVkX181PeWlTNfCR+EWt/R1n0Xcwo8JXCBc67W5wi+w3nVX65bncWk8nh5G1dujiYvpCyaIRqlyJufp4oVCrHYntuYzZogfOIOmrJ5WrkdGOBFHD7JBnOU5/ufUhBYsjbVoY8WP6L3BAVK+9PQySIl/+J1Pm4fC9rSSa+lGew30NH78wfBJKrQvYqeHpol2yNHjsBkQLIjrhc37dgAGhz8NRk379LH2HALTIlQ4zxoC1dMY6D8nT3jVv128VHpGIkDAeDzLckfqP7bIIkFthQ5gD0l/ojLm09DLw88dWmhRbqL8sUEoC0HFHqTdEUOuixRyptUY+yDHL/ydoI03dLHeMK2EVciP1defkLKOnu118/zhwvh8WklxcJaeKGCc7kEA7GnFWQFm6Fv6gsFh+OTHkERMhhW0hPrFpF4+bNRLe+cO0qp3FFMa61i/4ek5Sgo+d72yz0On1BRPIV64RXwvXCE2RhYtCf+S5suxCSYhWlDt1W5dCF3xKCSNfDLYFeG+TgIYhuNr01vJGBvG34yfRBhMnGnSn1XAtjb+busimwgz5w7bQVD9tlCvZpISB1VBNVcoGbyuPC6iIc4PGnR87yD/Q4ZLbj71sVHXhagWZHIZdc4HrT8lmWcZIa3FO8rycR0c2y52GNMr8lckEapJo++I+AmjGP+dbXwta1I66LOt6bqO2+wVQpori89Dhukdi+I41LaLF8L+o+B8pI9cCVku7mvWEOtQMpBOaWjVp1DTgH8GYjfBBoJfmM5TAlkkMynFnsEEy2B155ckjfXS/ScbC1vxdb9Xc6efu/L01EVze8yDF8tORtJKvLv8coPzEtB+mVoFrV2b4Q2BUO4/SZGuLm4bn6SSLb9vJzXRh1iQnOpgEVdumRIUKCoSPRqVQ2Nu9WJEbFzW0mRT7oLPZN8RZwGPFcSCPs/xlGpHPp5u7ny2ClSyL+WHm84CDW3+5iCkkL8wikJ
 mSJ5ZXuC
 VT75+C3GZthbG5rP6Tpq++VD1UtcQIYGAGPte5sL9lELVYGRgSREtr2L4ccXuj1VUBjQx0OLcFMWM7uy6McQD2g1ARp5STiH4y0AoyYSfiXdRVkfH2eOk6XWXtTlrrfZPy7i0zmFkRveqnmN/IFAb1fh0qP5V1fPLXIYLfDcG+eKsZkklliukrHWv3bOgmo0DjCsXjrXUqN/1Tzu8EAy5kCA1CyDvUo/2XzRnn5oGBVsIdu0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 27, 2026 at 08:28:04PM +0800, Jianyong Wu wrote:

> +static bool get_span_stats(const struct cpumask *span, unsigned long *util_out,
> +					unsigned long *cap_out)
> +{
> +	cpumask_var_t mask;
> +	int cpu;
> +	unsigned long util_tmp, cap_tmp, util = 0, cap = 0;
> +	struct sched_domain *sd_tmp;
> +

We prefer inverse xmas ordering -- where possible. So please go through
the code and re-arrange things. Eg. the above becomes:

> +	unsigned long util_tmp, cap_tmp, util = 0, cap = 0;
> +	struct sched_domain *sd_tmp;
> +	cpumask_var_t mask;
> +	int cpu;

