Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ED909C624D3
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 12:47:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6D3CE6B00BB; Tue,  1 Sep 2026 08:47:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 685806B00BE; Tue,  1 Sep 2026 08:47:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 59B4C6B00C0; Tue,  1 Sep 2026 08:47:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 342716B00BB
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 08:47:49 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A8DF71403E0
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 12:47:48 +0000 (UTC)
X-FDA: 85165170216.13.1F9B3E3
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf02.hostedemail.com (Postfix) with ESMTP id 90A5C80008
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 12:47:46 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="LRH/L1Jd";
	spf=pass (imf02.hostedemail.com: domain of peterz@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788266866;
	b=OinDJBd8jxim2wGSjnr1CbDa4zaKKP2hdUvWCrQh640CvItalS44jtzsq17GghNgRqojOl
	bTzqLH2Y0uu35ugbfjwcwTITccrbUhtH1gj1BWAeerIHCKo7Ec6ZsNVTw+kQwZVkTFq0V6
	WeL5xXS4RiBmQ8d7l4MAn8b9/l3EygY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788266866;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sCcI1xDRgy13rJLNRCaipdSq/zHJb80XoO4QrN/D7d4=;
	b=ZQli/wmnvdXFjGU4C9TEkNbDNYNE0IP3TZ+dQNhrBBGoQeOjZvdbZk/NHaNgwBsIRRDB0i
	B6INA/mjuLahbhgODGwzRV6iyMzPFm/2/WwWLX/kR+JyJ6/d7tNVo3jiyt44hZwSnJYqgN
	VNsu3u32DW7VE9XOyeRT+iQcaiMt/IM=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="LRH/L1Jd";
	spf=pass (imf02.hostedemail.com: domain of peterz@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=sCcI1xDRgy13rJLNRCaipdSq/zHJb80XoO4QrN/D7d4=; b=LRH/L1JdeSKQMpoPSr2wSN7WmB
	fzfB+ZCm1SNnodEdvJo3EBXK75+WWQQafDgDQ8yfgf3JgaoNkOEXqPTlUgtMO0HGNWxmYaC9Ku8gf
	aosrdu0gtHg4dwmYEVeALhBdXOWm4Mi/QMQIWtCpcOT1CSMix16u5+Z9SPT8DCXSaLfhcwf3Z0Dpf
	DvLZKPjEnPkW7Nf0rSlqZtcfAVLB2ogBxaNR03gnTSNH/eENs3gRA6EYLzKplJT4DC19r0+zy5oEU
	4wtVD4h0wBReSJV9HSeB68YseXCQPWG2faqwhXNgRU5Rr7KnaPz3lYsfgvcK0Rlz4GYCpMvqOoRIa
	NMFfFyVg==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x1Ntp-000000057uY-2PPd;
	Tue, 01 Sep 2026 12:47:37 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 5EF67300578; Tue, 01 Sep 2026 14:47:36 +0200 (CEST)
Date: Tue, 1 Sep 2026 14:47:36 +0200
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
Subject: Re: [RFC PATCH v2 17/23] sched/fair: Fine-granularity NUMA balancing
Message-ID: <20260901124736.GI776954@noisy.programming.kicks-ass.net>
References: <20260827122816.756234-1-wujianyong@hygon.cn>
 <20260828020731.785556-1-wujianyong@hygon.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260828020731.785556-1-wujianyong@hygon.cn>
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 90A5C80008
X-Stat-Signature: p6116f9dym3mncb9kof17faqaugerxw3
X-HE-Tag: 1788266866-493891
X-HE-Meta: U2FsdGVkX1+z6+MurQCQjZZfSnt5CSqrjzOp9glxBoXCGMIPWL/QdJhk8gPR3JEYsXVIOBK/hxnFdFKBsBnppC04Vime2PV4vnllk8OSRU/nhD/hMECBspoSM9AobZWq1LoCWpOV9zcFccncah5o2qFhs42DS0zAqBWKfX2A7NGyMnoEdQ9IQNoiZFfqkrjg+TFI0DyekkaU5aAFvnK5od7SNaxxXtB+A7+bRJc4hHJhk7wluE1/m/R166sZqiQaZctqgdaTimxsNXoQfrnhNBdA+a6e3eVOlym/5njh1aLh/G1CiVglPlkjTuSYbz8ETKkVcVvVqcxu5mhIJJkj83nKeM8EkEvvbt/PIxXsqewIqJP6DE+Egu4NEomQy9ULVatmXpBoFo3TDl7F5Xl4DGDruT8DzSR20GUe3TkVOuUJ7UHhvKlkZbtW+ztE+UBVhiVm0tAwXhpxbFJ7le2e92Aes3DaUNVef7eBMprUrMf+mZ5H+dhcXg0aWNip/NQc+8J6xly1T8amM4z0stFXh+iOzEb+gPCUCMVrvCR0dn869vPR0o29L4RgSnvyavxEkhc8bEC4RNdRuenzb1gJObJVC5Ni6xurqAi5HDZ75dzX7tkwobwlhYX8U723afbAImjdeYY1CdsgRr7Lsigw5P380wubn5NPhFtSJWirYlXxAdI9cQDzmbT1mzum60EYEHNO/jb3EDfxGML2vC3tWsX3Jk2gDKVprxnXar8GCRFPpZMwXdVU+RoD/FNUz7GrfZ58eEn4zObxK3IARTTBrZ1ax0CBV0OborAPy9mdQlJiSrQp9uvEJ6BBdZE5YJRyfno56pnFmzBsE9UDjbPMROosA/RWYxqb3o9LAs2NZ4Oi6YTobX3fpbVKkPaj8mtcQChQBHc9R+tC8wPvOeMQmkn63Ud58+SdXEXTfNMaKQX+64obIsit7xiXl0k8jLPFZEeaOK7kzndizkUPvtS
 dh7wZ+NK
 gk5+6ZSYTuj4KIDCDWFfT3Y/GlRYDtIRXvc9dk9W2qmKZiSf1obYiHXkhSIa+JcEps6R5fZeaacQB4vdgiqqMaOnel0sGaIVdbMyqJ1xS7LiHfo0TIxhHu9IZ+RmhC5jOfBFvX+vJWpG7gZDHa3BgzofskTDkSIw3y2BfEF/4iBwB6g2aleXSPC+7Z0M9o/RrTAHFb3vwKmz/jITQXQMfqWn9UkWppbeEj/8OSHMyGFw94ac=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 28, 2026 at 10:07:31AM +0800, Jianyong Wu wrote:
> NUMA balancing currently consists of two coupled components:
> task migration and page migration. These two mechanisms work in tandem.
> However, task migration may conflict with other subsystems such as CAS,
> which aggregates tasks solely via task migration. Conflicts arise when
> both CAS and NUMA balancing are enabled simultaneously.
> 
> This patch addresses the problem by introducing a fine-grained NUMA
> balancing mechanism, allowing task migration and page migration to
> be enabled or disabled independently.

Sorry, but this doesn't make sense.

At every point NUMA migration should take precedence over LLC. The
remote node penalty is much greater than the 'other' llc penalty.

It is always beneficial to get tasks placed near the memory, and if
tasks cannot be so moved, to move memory near to where the tasks are.

As a secondary concern, it is beneficial to keep tasks constrained to a
minimal set of LLCs inside this node.

Disabling page-migration or numa task-migration separately completely
wrecks things and you might as well just disable NUMA balancing. 

Now, if the process spans multiple nodes we should go do the same again
as this patch set does for llc, spread/interleave over the minimal set
of nodes that do fit.

