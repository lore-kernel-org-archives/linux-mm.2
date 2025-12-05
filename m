Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 53F23D339A2
	for <linux-mm@archiver.kernel.org>; Fri,  5 Dec 2025 17:35:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 91DF26B0022; Fri,  5 Dec 2025 12:35:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F4B96B0024; Fri,  5 Dec 2025 12:35:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 80A966B0027; Fri,  5 Dec 2025 12:35:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6B2E46B0022
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 12:35:35 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0D10AC0252
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 17:35:35 +0000 (UTC)
X-FDA: 84186119430.19.CEC814B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 5DAD620004
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 17:35:33 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XJzLIK7e;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of tj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764956133;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4aHnUTAcAwfhIom3WZaL6UvRje53iaslLndPRpEpiIY=;
	b=HuWF8hUMgkq/pnRIOuVmL0CjSXB4NkDKqEvWo1hnjQHYEFR6gg+2Ucdnmjx5R5LjYHSlgW
	jtp14K+w4fG6VOsZeAJcBPiWd8o/3MMeHDNP8AddLmLQ+p5YfdzB6VWs9VvWVY3aGTuYPu
	u0jky5OCwaNAf7GNRuyWHBDP6+YgeJY=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XJzLIK7e;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of tj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764956133; a=rsa-sha256;
	cv=none;
	b=Z24Xsx1XAI6fQIly9BS2gk1Zwpf+LUabZFYkeJGrMeBKuxIEhbgxgk6ItIwurEKRN8SVRY
	MRPLAIFVooPcsVGHI76GhMAdG5h3DhkLWelNSZOQuZ3wQvH+fxo89w5gdlCiFndVHSsxcr
	QBalBYi1WAdKBpq1/3cTKt/7VHsePko=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3D0B643F6D;
	Fri,  5 Dec 2025 17:35:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 026E3C4CEF1;
	Fri,  5 Dec 2025 17:35:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764956132;
	bh=9Jm4Oan9nsLhHItq9sLNPfsHbijlEVqpoSBh7EudzJE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=XJzLIK7eT6vXLmEG/WRda3rNsh1pJ4OHzjKkWVmB4V5ErEAojrGME2XTWIDbUiDKN
	 47i8/dZpsedoqb7iwkBEjeMK3CkdWKzbaJjIrxWULHvZBIeoaL3UW2D22Kk1cX/MqK
	 SLJH5x2I7PWSZf5nHaqlKEr5UwEnnZb60EKniwnUB+BmemMx16zyqGoo5XwA6uJj5l
	 Rl7ZCgdCToicNZWTM9zQa+zohFURWVjgpkZJGq4FRPKM1YDw/TDVh/JW/kvwjmd2Ln
	 3VeH7PScNpU31DgVbSvpc5goE6nh9W++yqZqt+W2wuOLGtaG1TTa2wXRJygYZLlXZX
	 FRcjh1NphzYFQ==
Date: Fri, 5 Dec 2025 07:35:30 -1000
From: Tejun Heo <tj@kernel.org>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
	"Paul E . McKenney" <paulmck@kernel.org>,
	JP Kobryn <inwardvessel@gmail.com>,
	Yosry Ahmed <yosry.ahmed@linux.dev>, linux-mm@kvack.org,
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
	Meta kernel team <kernel-team@meta.com>
Subject: Re: [PATCH] cgroup: rstat: use LOCK CMPXCHG in css_rstat_updated
Message-ID: <aTMX4tycdzKlaqaH@slm.duckdns.org>
References: <20251205022437.1743547-1-shakeel.butt@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251205022437.1743547-1-shakeel.butt@linux.dev>
X-Rspam-User: 
X-Stat-Signature: 7wooofed4bk3tygamofz3bdpfa6e5diy
X-Rspamd-Queue-Id: 5DAD620004
X-Rspamd-Server: rspam06
X-HE-Tag: 1764956133-56728
X-HE-Meta: U2FsdGVkX1+vHx1O8rV3X4ZaJ/jV8bTmlVUC4sfhmEJcwCm4AB2Hm3LzpV2/LPBobC9OaVmKLZMxFtITTiLAuGigEUr18Z7vRU84F2dqQynDF1QmnjvRFIUHAbsHyvfz5P9MMkDDLRrn8MsRstcUFeAwwz/QRNy42VYXjIDOCgKNZuTXGt3/S7L3DPpALSkehSy2TGUkC2PwFHZmfy5pSSoiHrBxlQYDdtRtu3pgUH11ArQ3MTnMNEYuT2+LFgKR+om6e8vR0twMKJDY+u1oWsXqLWNY87nh+LkMLWRKhgJCUKkWoSwKPWeR46qbj647QZXdTYj9DCoWZL+LwjdGfBBhdSI8dmLUUog4o7ek7fJhlqW3wRUoWMHJRdcWepKAp2cHAmaEo/DDH83VgWk3nbV4O9gnjLIxjmvamQH7ixjj55SaNXKiaXtfnc1kXP3BGf7vB6Pwjy6mhqmEDxtjFfL0OxmYf04QiEjhoGIL5fEhNJlk3qK6iIzZclaC4+Z9H2foR+k8faYJ8Mj2KTNgqg368p1dAQ/LPUvjGfBZMFPNyKGfygraHEPU6oWpM8qLGyLixdatacr8wIB0bqnuCVh4+VEvIjEp28hW5gJcnDGP7Q6kP/fAuDiTy+oop8Pj8IZzs9uPZCnGQoM3rkWCphLGQk7fj7G1B+3dMlSx0YuBpouWoP5DeWLvJqJRh9wfy56loAnOD5gQ3kw6ci+UR9G8lNeCDD91YQYgjYcT4Xsbh35Gjh38LeaO5WpVml6Hy8G7derTvRV+4q77mw/ai0fO7ei6myfG6Y1W96uqWf45OB+Pmd1lwuC7EfR01fLhI1N3DumdkxUtZA8ZCGctoUx9mV/4gdplPPYBeD8l5XRCgd2HhyCFZpItEuOqrNo5unY6OfNIJK1BHWZUMfqusAx6SpnPlAP6UvqPjT235MHvMA+4DtlhiRWTBXTAPO3QO39gCmVJjfs5AnWmz6y
 r7KlIBjp
 omvaK7+En18quel/KcOOfwYgjy5t3Nsn7NuSDj0bwcFrbaGypro0neE9YPhg+MO26F2Z/C75A+Ez5t2AhCSfP4XGuUWfpLX9CXO06PTqe8E56HtEFUKIymUSNU6X9k8hV7RGuN4HHYw4HItSiBXOmgobd5vGh22ScimvIq96Rfplk9tY7u0qjM/7cguME2oQLztXovvsLPDzreb0H2tuReoSFyqpaYI582w1K5o0pA/GEkfgo6T/o6oxrlUKf2RwLAniY
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

On Thu, Dec 04, 2025 at 06:24:37PM -0800, Shakeel Butt wrote:
...
> In Meta's fleet running the kernel with the commit 36df6e3dbd7e, we are
> observing on some machines the memcg stats are getting skewed by more
> than the actual memory on the system. On close inspection, we noticed
> that lockless node for a workload for specific CPU was in the bad state
> and thus all the updates on that CPU for that cgroup was being lost. At
> the moment, we are not sure if this CMPXCHG without LOCK is the cause of
> that but this needs to be fixed irrespective.

Is there a plausible theory of events that can explain the skew with the use
of this_cpu_cmpxchg()? lnode.next being set to self but this_cpu_cmpxchg()
returning something else? It may be useful to write a targeted repro for the
particular combination - this_cpu_cmpxchg() vs. remote NULL clearing and see
whether this_cpu_cmpxchg() can return a value that doesn't agree with what
gets written in the memory.

> @@ -113,9 +112,8 @@ __bpf_kfunc void css_rstat_updated(struct cgroup_subsys_state *css, int cpu)
>  	 * successful and the winner will eventually add the per-cpu lnode to
>  	 * the llist.
>  	 */
> -	self = &rstatc->lnode;
> -	rstatc_pcpu = css->rstat_cpu;
> -	if (this_cpu_cmpxchg(rstatc_pcpu->lnode.next, self, NULL) != self)
> +	expected = &rstatc->lnode;
> +	if (!try_cmpxchg(&rstatc->lnode.next, &expected, NULL))

Given that this is a relatively cold path, I don't see a problem with using
locked op here even if this wasn't necessarily the culprit; however, can you
please update the comment right above accordingly and explain why the locked
op is used? After this patch, the commend and code disagree.

Thanks.

-- 
tejun

