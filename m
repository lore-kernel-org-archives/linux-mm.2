Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C4DC4C79F85
	for <linux-mm@archiver.kernel.org>; Sat,  5 Sep 2026 23:34:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9D03A6B00AE; Sat,  5 Sep 2026 19:34:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 932FB6B00AF; Sat,  5 Sep 2026 19:34:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 849B56B00B2; Sat,  5 Sep 2026 19:34:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 581136B00AE
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 19:34:26 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E2CF0A4236
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 23:34:25 +0000 (UTC)
X-FDA: 85181314890.18.066242F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 484CC100002
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 23:34:24 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=ArrtLe6P;
	dmarc=none;
	spf=pass (imf05.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788651264;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ywBvGvF1QAkmenEsO5AtSwGMCsTkLfBx4RbvcxuGfcg=;
	b=WkDpwvJx/G/z2OTJIXLZsaPLgNeZ+qwP3K56MHLvBGT5N20airyaKfn7BYu+LLoIdmc3bp
	rihb5PQdsbDfgpfDCzJD2lIr6+GANaOOU7D0NdnYnVaC1q8LNtCeEbNfEBnLTwmW+5h6AZ
	VprU5+ItI+pdEPW+sIsdImWsKEIjd3E=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788651264;
	b=lPuoJtJ4tqXe+gd3y2Y4hWOMeFaNUlkOp9V0nOQYvCGJetp/m4lGg6WravoqbOSotJEUH0
	uneCRMqqEch/TnYQn4xA8xARqeqMEUwRQZ3VZ6Ii7zb0d/auwVeckRM/IFr2NXkVI4vTJG
	RHWq2X4uJh6C2S1csP+yXlJgqV6oW2E=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=ArrtLe6P;
	dmarc=none;
	spf=pass (imf05.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 34EC841FA3;
	Sat,  5 Sep 2026 23:34:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDA931F00A3A;
	Sat,  5 Sep 2026 23:34:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788651263;
	bh=ywBvGvF1QAkmenEsO5AtSwGMCsTkLfBx4RbvcxuGfcg=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=ArrtLe6PpOaxcyg+4/KCEC++MSxo/sRI29yTDnnZQC5E1x8aR+0TsMCmhJ8Z4IZ32
	 7meO5w1II8TkhRg64OHpcxWwjweR73aFQo4567+x6ngsAgUfgUxkgTGw2dviGxf306
	 RGc2c5vEsCAYB7sb+Ty2Lr7GE5ZA4xlIl+RMaFHs=
Date: Sat, 5 Sep 2026 16:34:22 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song
 <muchun.song@linux.dev>, Usama Arif <usama.arif@linux.dev>, Meta kernel
 team <kernel-team@meta.com>, cgroups@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/6] memcg: group struct fields by access pattern
Message-Id: <20260905163422.4da655f452c4015cda0d4e3b@linux-foundation.org>
In-Reply-To: <20260905030522.1887837-1-shakeel.butt@linux.dev>
References: <20260905030522.1887837-1-shakeel.butt@linux.dev>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 484CC100002
X-Stat-Signature: g55eoysa664keea658mamkuozdiiqsiz
X-Rspam-User: 
X-HE-Tag: 1788651264-200257
X-HE-Meta: U2FsdGVkX19LBvCrNc1f0utujoi67JWK4JlXVXRBgs2Oe92gEMhe8UjwPKfR0s6hLOOAmnySD5n1ECpcvk6lpFLxZVtICdihojPP48e6H4AaFL8z/ztmqrlRI8yOWz6R1e+FvTnrB5kOSoEqVH8h4zjnrhAoo7Cz761MCwQ1cw3E2wvjfzUenhUJP7RRwbkvteQnFeJmJ6Gxf/2N36Tv29HCcASKv9XgpN6QwmQKIDgnptVj/RYN3B9E/9Q35UH23C84Ui62C5skwLzCCj0iC8FN4trcbE0knf1RMVEqClH0eP5Yb9A3XDMMzgSXyHsm4TO7Iw7hBcvoIpWe+K2aHFkpPN//Ei2JIj3uuDsobT+nxZQuxdp+6x1AuZhIf2QBcUCO76qGU5zw+PvdSaSBNO55qBtg2HylqydJcb77IPdF7BZZI2/WKLXYz2wjjqQCvAJFdH8cicrj7ilO6z6r3/zr0hyLBjv1rCQ+kgfvNx0FPcZtc5zcNbPbG15RIIEjh85+xRUBVelFQG0G55lSfhSzkpYSQy6MvagFg82l7k+X/h1XdhZ9ePyJoNFupDr3uHdQma4H4AINSxd3lU8OmDjShZwxHA80tCE79hLntiUwCDbKdpQJBDaYG98RC3tI1ntV1OUMUVJ73cS69cnEUdd1iMBzHZqKKWpVp5JFObN+ESr99y1C29zzBbiEN/RK3pDnt72RIReYjXtBdCXsyqWHVBuzPyC7kzjLr0efy571Ek7MtUGVAjR3WGchabfMZf+sYVCdgZoiD5OdDaZYMBp0FDDWaFUUK7+jndROUklp66jTdWTVCI6InPxnknOeePUsPj0Sehe4IE+U7Vj/Hd6+EDJU8Yyr/5yIPS3gzz2+RJr1Zx6wkflAJrlnHUtSHoN99TeT1KLlHQtC7PqIIR9FsI1dHlXGtrYdklPuik7T/C2g3oe7CVaVcRsPdnv0j9JG+bVieVI4UrPvTuT
 kFgkrwTY
 cfPXFG8FelEuGCGFsM7G+lkEcrrdKF5Q2a3kckpOZM1fVC/+93m5XXSu6S0rhzoVH0VcxP64xwTrR5SjHGq3GLmvx4hpmg0S6m2okYhdL4oR+hl2rgWsvtPXmfkABgWwxU5i3U/9yRbPECIJPVtQxYHFitWV6Zox6GAJnVrZZcusheD8xYrno8MurYNF2hpskLrj+dfczjysxDUyz16HrYkvFTLY1mHIK4ofwdpSbYUY5mQmxgRq5aQvynjQcdsI6/4jg
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri,  4 Sep 2026 20:05:16 -0700 Shakeel Butt <shakeel.butt@linux.dev> wrote:

> Every so often we get a memcg performance regression caused by nothing
> more than a field moving. Someone adds a field, removes one, or puts a
> few behind a config option. The layout shifts, fields with different
> access patterns land on the same cache line, and a bot reports a
> regression.
> 
> ...
>
> This series makes the layout a contract the compiler checks, the same
> way struct net_device does it. Fields are sorted into named cache line
> groups by access pattern, and memcg_struct_check() verifies at build
> time that every field sits in its group. A field added in the wrong
> place now breaks the build instead of quietly costing a few percent.

Sounds smart.

Significant repair work was needed for the struct mem_cgroup_per_node
and struct mem_cgroup alterations, due to the below pending changes.  I
think I got it all, please check.

--- linux-7.3-rc1/include/linux/memcontrol.h	2026-08-30 04:44:06.000000000 -0700
+++ 25/include/linux/memcontrol.h	2026-09-05 16:31:03.119571612 -0700
@@ -95,25 +95,12 @@ struct mem_cgroup_per_node {
 	struct lruvec_stats			*lruvec_stats;
 	struct shrinker_info __rcu	*shrinker_info;
 
-#ifdef CONFIG_MEMCG_V1
-	/*
-	 * Memcg-v1 only stuff in middle as buffer between read mostly fields
-	 * and update often fields to avoid false sharing. If v1 stuff is
-	 * not present, an explicit padding is needed.
-	 */
-
-	struct rb_node		tree_node;	/* RB tree node */
-	unsigned long		usage_in_excess;/* Set to the value by which */
-						/* the soft limit is exceeded*/
-	bool			on_tree;
-#else
 	CACHELINE_PADDING(_pad1_);
-#endif
 
 	/* Fields which get updated often at the end. */
 	struct lruvec		lruvec;
 	CACHELINE_PADDING(_pad2_);
-	unsigned long		lru_zone_size[MAX_NR_ZONES][NR_LRU_LISTS];
+	long			lru_zone_size[MAX_NR_ZONES][NR_LRU_LISTS];
 	struct mem_cgroup_reclaim_iter	iter;
 
 	/*
@@ -293,8 +280,6 @@ struct mem_cgroup {
 
 	struct memcg1_events_percpu __percpu *events_percpu;
 
-	unsigned long soft_limit;
-
 	/* protected by memcg_oom_lock */
 	bool oom_lock;
 	int under_oom;



