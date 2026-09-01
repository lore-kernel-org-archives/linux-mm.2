Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 154A7C624D1
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 10:29:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 059596B010E; Tue,  1 Sep 2026 06:29:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 00AA26B0110; Tue,  1 Sep 2026 06:29:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E42E46B0114; Tue,  1 Sep 2026 06:29:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CB0836B010E
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 06:29:28 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5C7A61A02F6
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 10:29:28 +0000 (UTC)
X-FDA: 85164821616.05.F9DB9C1
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	by imf28.hostedemail.com (Postfix) with ESMTP id CDA28C0007
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 10:29:26 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b=CclhBcNQ;
	spf=pass (imf28.hostedemail.com: domain of peterz@infradead.org designates 90.155.92.199 as permitted sender) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788258566;
	b=5ZR6atjD2PtloFo9kStqy8KRlzVXMmR/ZCSKaQv7ejEnDjkZY6tdMoNGzc+lE3Ie2ecKBj
	a4evz9ey92B3h8s7AgeYd0ajWY0lE972+GeobLKRLf6B1VScrz53maz4wWrnZhYfbXUpqq
	siomh8+2//5GE7XE9NjirDR3mbrQ1dA=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b=CclhBcNQ;
	spf=pass (imf28.hostedemail.com: domain of peterz@infradead.org designates 90.155.92.199 as permitted sender) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788258566;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PUus9S9MODT/QuFwH6nooYCoD+hdaIxSvabuO+GXl/k=;
	b=v6mbvS5LYp3BLBQ63G5wW4kSPHY/tQyQzlLlMTNoqP198KoUqjdcat1wH7a6F64stWQwkJ
	cq1J9V/k0VbUWDcErrv9h5ocNIH90xTo/AkSyYZXW9qr9UFpmLZ3pjikP+bgXw7D11jbBh
	VfV6UnCN1/grZ7FOu5soYa6sqt14+xQ=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=PUus9S9MODT/QuFwH6nooYCoD+hdaIxSvabuO+GXl/k=; b=CclhBcNQzW+aMW35635m3dmmAU
	2cFyY7FteXJwlQUjc1icaB5jJpLE5ys9V2+Tu7k53qyaIyixvmg/uaYnAtf23/6yjEAoPXfEFWpAd
	aZRzJK/kqv7lKTKSS6OYdgL6vUUrFBqnp9ydWsBFxDPM40mia1kL7SRCv+OeFB42E1adHOOE0QDsC
	jhl48QBWzZteHxI89jYEmDs3M0QDoncSX5T914/ia/x1QAxpasclWAvGxv6KXA7fSaHuqssx2IMb6
	xFG9APm7JP5pxdAXorXZxmk5nN+9k++VhsMsfFWPQL2hrSuUEhyF/Smit7koRsizy8GzDoX2Lk8wg
	SOmCyBIQ==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.99.2 #2 (Red Hat Linux))
	id 1x1Ljy-0000000Ar4c-1mv8;
	Tue, 01 Sep 2026 10:29:18 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 43DED30031E; Tue, 01 Sep 2026 12:29:17 +0200 (CEST)
Date: Tue, 1 Sep 2026 12:29:17 +0200
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
Subject: Re: [RFC PATCH v2 14/23] sched/cache: Drop prefer_sibling
 restriction for llc_balance
Message-ID: <20260901102917.GH776954@noisy.programming.kicks-ass.net>
References: <20260827122816.756234-1-wujianyong@hygon.cn>
 <20260827122816.756234-15-wujianyong@hygon.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260827122816.756234-15-wujianyong@hygon.cn>
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: CDA28C0007
X-Stat-Signature: zximq91mpfd3u44eq9wb5ehkn3hbi9q5
X-HE-Tag: 1788258566-289570
X-HE-Meta: U2FsdGVkX1/LuJDmD3jN9OcIjkFGPrV7/FBm2WO+G64GK35LMfe+2urN3tPrF6dJDfj7rphgMIKLIoDc8/K3WVqDmWx7YuoyC2uRwcbrml+sMYnw8Zagy9SiYXjA22W46mjnaWnHt+YEUEtFOe5gFZ8UuL60OxmT91LIl+BnBaYiWNCt+VGgTXZusdQnwJlL8mbeTXMp8AGFDKu++Y1yt//8qO/bwpDNnBR+pJMb8qNVNprierRB65itbeDZsrjmtYiNS5tze0FKjwqAzWKyFav/xVI11EKG2KFZWiThIkyjXJqM1AwbpUWxej+NNtQ9kvFC2PJRR2p/lgtg1A6GJ+q+3mo2yikGVB+tOTCoIYWAECzE8E6cBk45S96IpdFoRYzXHcvadWglzHo9T1D128ixuGUmYkn3f5NGGKVvlPrVrKZ0NGPCLc5HCbi1e2xB3fFdS4WOcQQ8ENs0bmehh/AB4Nvwq6q2a8Wanv+ZCLOqeqYvOobG2z43Y3hEvHUXc62pmjPmp06FPFScX8FkP1cIYWoSbHR0LbDB3TJtWk2E3RSTbsMO1gv9CyTZL8VZ5u0u4fO2Qvn5+SaCzu+mGaZ+3A0axElAOF1VeQCUlJjUqbIdQmAv11lVyx/kM09BBSgj6/Z7buAO3Bs99h1D7+oqkKuxvzmUPiTDtcbRtAsvTcGfrvOuX10bsCk0dZUOmqD9SEpVDaJPkwhSxKl+WojbSJC8ue26Qk0R9RagdZByrfcjb/LyCF7wb4o5QGTcvhTZta+Epdm1PkxKWg1p0CKRZvJ29FjFgy4N6OQPK5ri09gIpntyJxmoyP/HcSfkLjiKNToqkE0pjfXwcgPXBd7E95xTl7K6zOvqGIKBJjPO+xPzwoqrr7q+PooxRzQJe3UTiDJN53cgRSosFwoOlXYfgYzJEf7kzTx297jsWeVT6vUERqTlobV+xS6W341fS7eFqc0mOCoDquUQ+lb
 MRctIp9Q
 eud1r/uBSloB70xNm+kl/+mqFcAUw6u8nP7S7VDo3b9rahbUz7vXxJuRHZVwPyGwi3rz54eNUu9sR/4uSsOC4lUUpBo771OSJT3QbAooN3MpC6YAyp6D0WN5gL5/Jsa63PChztEOVCPb0vZHvR7WZ7mZ+vkO7qbASPSC7+y6F7zLT6go72Ci8TnatFBTNDyET28PweQxuYyHxwAXPR3X0qEY2h8dztdyCUUm+CLY7CFKTfWH4A7AyFxE/PlpXQGVD0N+T
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 27, 2026 at 08:28:07PM +0800, Jianyong Wu wrote:
> group_llc_balance performs balancing across LLC and NUMA domains.
> The prefer_sibling constraint unnecessarily limits its scope, so remove
> this requirement entirely from the branch condition.
> 
> Signed-off-by: Jianyong Wu <wujianyong@hygon.cn>
> ---
>  kernel/sched/fair.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index 584297528a9e..5c35a43e5e38 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -13274,9 +13274,9 @@ static struct sched_group *sched_balance_find_src_group(struct lb_env *env)
>  	 * Try to move all excess tasks to a sibling domain of the busiest
>  	 * group's child domain.
>  	 */
> -	if (sds.prefer_sibling && local->group_type == group_has_spare &&
> -	    (busiest->group_type == group_llc_balance ||
> -	    sibling_imbalance(env, &sds, busiest, local) > 1))
> +	if (local->group_type == group_has_spare &&
> +	    ((busiest->group_type == group_llc_balance) || (sds.prefer_sibling &&
> +	    sibling_imbalance(env, &sds, busiest, local) > 1)))
>  		goto force_balance;

Not sure about blanked disable. Maybe only disable when cache aware
scheduling is present and enabled?

