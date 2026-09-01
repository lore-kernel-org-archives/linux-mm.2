Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A10D9C624CF
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 09:58:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 550E36B00AE; Tue,  1 Sep 2026 05:58:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 501796B00B4; Tue,  1 Sep 2026 05:58:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 419756B00B7; Tue,  1 Sep 2026 05:58:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1EA466B00AE
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 05:58:53 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7A72416033B
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 09:58:52 +0000 (UTC)
X-FDA: 85164744504.25.17ADCBE
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf12.hostedemail.com (Postfix) with ESMTP id 5BFC640002
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 09:58:50 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=srenq8KZ;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf12.hostedemail.com: domain of peterz@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=peterz@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788256730;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8hcZZuGg5zfIoWr+fssOIfgBGeSQ/Wi7x8gohmj3py8=;
	b=M2kushIqlZR0MzVQLmoLURes/L57wIpKnZKHS1Lp5RX1GhQwNM5X72H3Vnq55qTQg5Q/8q
	Ct2bWyvFL2B3nNidKuNIJbtmxNSfo/mR4ww7NwsLaEypEZJSH2Dw0LLTNv8A8Mq4Q40C1z
	7YEa8OKJtjQ9kIxL2v9a6PLcFUt6XBg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788256730;
	b=zPsqKIb3F7M58vrd/sRyUSFce3B/Qlj2khAapNPleAaZIuuvceJjnDSCe7sHlQoGJk65o6
	3tYSgtck9utSlChUFKLWwBfaufXpoBk1DUM9poXX5OK0OKgJQAFP3lOKHopRwKUDkf4tJZ
	2qOPuCN3TxaM0ZBOEuT6wWoz6Q9JmNw=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=srenq8KZ;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf12.hostedemail.com: domain of peterz@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=peterz@infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=8hcZZuGg5zfIoWr+fssOIfgBGeSQ/Wi7x8gohmj3py8=; b=srenq8KZEkMiu7sLjo+AjDKVWc
	JWGjbodqLNndMUAt5vV1X0QK7XqderFV4bT/xGQvJolaTyqV9m3pgfZ/Sb1FWhHpf3vxwgQ7nBDMP
	yMR61ZW0oBRYxbmBGaAJRmZmTGwN1rveoJxlg86zH2P69RhoWx8FzpkXCGPvVlO8vRXVPaJmzu5K1
	eFDPFy+9V9KN4nfS8uPfHuIG/R66HOg/IAzE0/EWPrV8cCjztYSF0q6KQXRVVVtPI9aFheOuRA6lP
	wrkASIwbBSCEzUathVj0D93Cl0gR5SjKsv/d5sUAv2JpkvzjLWqCbFDYq3rYwUlSk+R2062oEGwzI
	bZkTvAgw==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x1LGL-00000004tKQ-1oqx;
	Tue, 01 Sep 2026 09:58:41 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 895DD300578; Tue, 01 Sep 2026 11:58:40 +0200 (CEST)
Date: Tue, 1 Sep 2026 11:58:40 +0200
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
Message-ID: <20260901095840.GR4120091@noisy.programming.kicks-ass.net>
References: <20260827122816.756234-1-wujianyong@hygon.cn>
 <20260827122816.756234-13-wujianyong@hygon.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260827122816.756234-13-wujianyong@hygon.cn>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 5BFC640002
X-Stat-Signature: r877dx7miikokdbo3s6rojjs4ms7qsxd
X-Rspam-User: 
X-HE-Tag: 1788256730-226918
X-HE-Meta: U2FsdGVkX1+nFehI8kfGwNRvhgfPaHSqauhosNEW5ws7/lKIaJLGKtYZdPg9eNc7A5iZELmpmdTLJNVIPRYG2w9Zfy/KGD/KzhwbG8IBBrtM2xogDvRnkMgWleZ6yvfTrBp8sJ1HUSaBW1GGu4AO3kvOSdA2cg6L9+iu7+YMqhQVTA1NvIja9eo9P82OTFMXifdtz6YcuiScloEN00EfrAn2/F+ykJZgjygtVTMe6GE8OFa2ZSAbAr8bpiJZKJDYMPZNEfW9tXVnBfrvAsl+JE3IuFrnDwVz1I4EkM7N8ZLjs1WoIGZvE6qbOWhYYnSFPDhwoZTYwYQTnC2bw+y4olP/S6GDNpTibhhJlijkRkgy2nPoQwqFNLIE/t/iK6S/F5oxw0oOKWREEn/YDCV7BJTgwtThqSjIpChDvyKY9MGEol3C/CmkOICMY/Ynv1qMNJhDqtCs+huiHk0cKJlE1gJlkcvnggci5sVIIvBSozVc5e2gjt9dLrxzFNcadDwPN1IWhX6kynn3A5DVAocIFG85lU557Obyy5ydVyLDlnR/bblOrBR5XTjEfb/ZtQHy3CShAThz53T/REAuVDKNDXG2e5LYClhOR9Iq3ewW6OXUNXISqbTLs0dIe1CWfffjwB5KsC6jE8Oy0Vf6PIdWm1h73XLh4nsw3mNmFqlf9tcchLCOQnr7GCdlhG2xzWK7zDIeMdU3QAda0q8w6kNWCW9dbL6WMXLvX0zjRK7qllMa5DJVQ1lbRUdieaQHuekmjYZ+zgsPtFaAyxnzzWgT/39imInPQZCwN6sE2DfYtz1gVcfQCaoKcSImKqPhClL3B+A85e0akzUugtOJqpuhM92/Wj1+gT7XXNjcIxOaAw6SGyopubI9KGddFMWEOwk7SgXlAZBmHffDRcvnW7zW1XFz1Wkl7Y87xT0uUE5BpD8t2e0LfViTFFrCker26lPmTQ+1NoGeL0wRU2ovWv8
 8fhw++ub
 /E56WQV6N8f4GwfrLsvgK7MzEg8dBM5L/Wt1DoGpW1h/aOMHiZFw6zvKfS5cBIVY2IOa4QNfqMtlb6n8+Fqi5sIiIbvGICLVRdC7uc49/2Ks2hFs+0DR/+h7wu7RnFQ9NNl3qSBitjaT01BdTgA7OjV04B0aPrmH49CM2xgpM7WedzFcqdEdhOgPxKWfMlNTJOTHlR48X4JFUDSY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 27, 2026 at 08:28:05PM +0800, Jianyong Wu wrote:

>  #ifdef CONFIG_SCHED_CACHE
> +extern int max_lid;
>  /*
>   * Record the statistics for this scheduler group for later
>   * use. These values guide load balancing on aggregating tasks
> @@ -11998,6 +11999,174 @@ static bool update_llc_busiest(struct lb_env *env,
>  	 */
>  	return sgs->nr_pref_dst_llc > busiest->nr_pref_dst_llc;
>  }
> +
> +/*
> + * Get all LLCs that are closer to the destination LLC than to the
> + * source LLC inside a NUMA.
> + */
> +static int get_affi_llcs(struct sched_domain *sd, int src_llc, int dst_llc,
> +			 int *affi_llcs, int *affi)
> +{
> +	int j = 0, src_dist, dst_dist, cur_node;
> +
> +	if (src_llc == dst_llc || sd->flags & (SD_NUMA | SD_SHARE_LLC))
> +		return 0;
> +
> +	cur_node = llc_to_node(src_llc);
> +	if (cur_node != llc_to_node(dst_llc))
> +		return 0;
> +
> +	for (int i = 0; i <= max_lid; i++) {

This isn't safe. max_lid isn't stable, you should use sd->llc_max which
matches the actual allocation size of sd->llc_counts.

