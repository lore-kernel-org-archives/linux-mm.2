Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A6794C531CF
	for <linux-mm@archiver.kernel.org>; Thu, 23 Jul 2026 13:26:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 55BF26B007B; Thu, 23 Jul 2026 09:26:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 50CD86B0088; Thu, 23 Jul 2026 09:26:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3FE576B008A; Thu, 23 Jul 2026 09:26:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 196EC6B007B
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 09:26:25 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 91F381404A3
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 13:26:24 +0000 (UTC)
X-FDA: 85020115488.29.4A33646
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf04.hostedemail.com (Postfix) with ESMTP id DD16A4000D
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 13:26:22 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=ZBI7Po3M;
	spf=pass (imf04.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784813183;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XVvr4lvzSBINbdNbGS1serlGFMjFjvkzIEReevjxqGM=;
	b=3SqJ48ebKYC60UYS5z7Pp8G9ZVbRcJHK6kRv7sd8Ww/WJ6GZpWZnW6Ro4VLXmAtwT/ck3n
	iguQrKgAhlnfzrHG1uebtfZwc9Km/NHUZnLsnqRxq7pLIJkgcCqKfff58bwdwlOcn6b3k1
	kIxoJdeV+px5NUhW7kS7yPBcyNmWINs=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=ZBI7Po3M;
	spf=pass (imf04.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784813183;
	b=FTS49k85cDtS6wPd45MDvm32eTcewoD/lY8Q6pLNnGLm1ApRjD+KhahCIm26+8F8bhtINH
	3ymR6wz2WPeankv2VdALb8vszffz6xZUMd0Xcx/nnlBJTrnJ1qXWhtt9XbVauzsbAVdrcA
	pUpGBGRlit2TE5LKvRFTHutj33ojmGw=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=XVvr4lvzSBINbdNbGS1serlGFMjFjvkzIEReevjxqGM=; b=ZBI7Po3M8vlmyjdMI+5EAnUcm1
	BtdcBZWbjta0MQoOcU7hd9BXwRVc3X20IgHoq+909L8OJ2fZuKuFDDKY3u5UGhhoilHnSqrVJA8jO
	HDl6k0dk/hvR7+VNeA01o1lqTuE3fobEgpnGWQQzkt4yY9R8W+pYS8rdsN8fx/oGB6TzyotVwijtr
	yJohn68p9UvLuMhj6QLblQpMnv+Rcwj/ZQD9sIBXOf+NrPGWyG8dq7/Tz9uI1/TD5iHyYOfU88x5Y
	USxcIRvVdP+3GfcT4KfLV6d2oFCGJGKAzbNrgg4qJvlkRsLWJG7oufQ2qazeRnjx1viDAR/h3lgmJ
	M/O8ReKw==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wmtRI-003oFU-1p;
	Thu, 23 Jul 2026 13:26:16 +0000
Date: Thu, 23 Jul 2026 06:26:11 -0700
From: Breno Leitao <leitao@debian.org>
To: "Paul E. McKenney" <paulmck@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Catalin Marinas <catalin.marinas@arm.com>, puranjay@kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, bpf@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH] mm/kmemleak: report RCU-tasks quiescent states during
 the scan
Message-ID: <amCT9QEgJRsLIb_y@gmail.com>
References: <20260720-kmemleak_rcu_task-v1-1-5b460ade777d@debian.org>
 <20260720153917.2e428e489cd0873ac6d4e6da@linux-foundation.org>
 <5b83b0a0-708a-458a-bdbd-41c6d4610349@paulmck-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5b83b0a0-708a-458a-bdbd-41c6d4610349@paulmck-laptop>
X-Debian-User: leitao
X-Rspam-User: 
X-Rspamd-Queue-Id: DD16A4000D
X-Rspamd-Server: rspam01
X-Stat-Signature: y6ghbsictj7nm8tmkwk3oa48nua79yed
X-HE-Tag: 1784813182-382917
X-HE-Meta: U2FsdGVkX1+670KzoB0AllKJWE/hjxheymIT/1L8ib7zFDDw5TJRqMOht5rYUxsgaN78wU2Pf2076a3YLeGufQO2GNQu4mOP8YGvDqcgdDTSHmGLzeAvA6tbcUKZ+W+7zqFccw63SweRP8UerDcueGNtXQa4K+HMj83IcRnMINBmjyZK9Kspt7mrj8Id6z+RzG5KWL91EZw/SkuQ1XV4GMXsc0uqyb7UAdxSbFGVc1Laxc3x4ZYt7ktLui3ktlMBix2hf/PPebKNmBq7LeFkaA1M4SFb99ZLDpJ5aCQOuvBWhVeNTJYtvE+9NIkRHlctCtORy+5inX88WXtPDxdP7s3dxOALAEZ8s91FQXL9qW6XuxPx4g/MSoDVEdWOWu3egbMzaWr80HJClf8JrBjvw+49nSyAEUaFRwJ3daf6VrWqzy5N8piZoiS9rVEMpFqxyzs164sYsmLDOcJxCHmWy7T9hpiQJTwMLngU+W63PAZSkpmv6JTgJO69WD86e9g1ICxagnjeup2FaxZHjLMMvEpRBfcZtL8S6bY2kyyHsRgEy/hjRKjsNBIurfhVEfX1huumFG9zRyZqFxIJNlBX5yk2zZd76zF64u8wUmsYspD7rgJWuATh7DEtpDlkJU9lW6yNF896Z+/afSARh+wVOL0OXd6Wt6XNc+2os4uZ6BmZg/Lo2eTCf0CMD6LUCmqKmR71spGlszjiZekFx3R+fdiikFCDi0A7wWdcaDb2gnkUY00h/qXOopGMha2toZgig1yDCE9tkE7zM5ZrTHEYULAbXLnvdqDs2ulWKsSzC1nzS+GyPA3/46upsc1NNm3n7w4lMGX/AugSPPMnRLfj0yBRmdIA34S6vWkb0W4Ft9vpgBZ6fAdCA6lIeM2kXNsg9KJH1I0jdWWxY0h+38GlyaXJe91q3r7EfawLoLbSFa5ynG2LNakGUU4LXXHY3QK5K8/aK2JqTeO1wLYHdgM
 BxUL3NMB
 g+GgCve6hjRA6IE7P4/O9ILtE7FKAfatHMPkJ/t7EGveStSXrPS8vFHV65FU5HHVclPlNrerlFduFYfS/kbDsejp/IwQjGYfRuR19wXVR0Dul0O7d05CgaAr7JU9JkM56P+NeV1N7hAtQYv35qp7xFN4pFVgyIivm9OEtq4yVvWBcqnAg7/ZkkqYB8lliybAnnw7Nl0hCv+UE7mUVVbSj0ErfovQd/9jrn/Sxv9fAgv3FlK4hJYJOYIq1H94j2DWvbcFDmxmlnG5foP7WoR06nrMtpCDMF/xdy4PXwuC2hhJTQJUBp2E/2WfDkIQ4kmhFc1L0osjz0eMrUKA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello Paul,

On Mon, Jul 20, 2026 at 09:21:17PM -0700, Paul E. McKenney wrote:
> On Mon, Jul 20, 2026 at 03:39:17PM -0700, Andrew Morton wrote:
> > On Mon, 20 Jul 2026 06:23:45 -0700 Breno Leitao <leitao@debian.org> wrote:
> > 
> > > kmemleak_scan() can run for ages on large debug kernels. It was
> > > causing some soft-lockups which I got fixed with commit
> > > 3175fcfec8b16baeb ("mm/kmemleak: avoid soft lockup when scanning task
> > > stacks") with our beloved cond_resched().
> > > 
> > > I've got the fix above deployed in the Meta fleet, and now I am seeing:
> > > 
> > >   INFO: rcu_tasks detected stalls on tasks:
> > >     task:kmemleak state:R ... nvcsw: 274/274 holdout: 1 idle_cpu: -1/3
> > >      scan_block
> > >      scan_gray_list
> > >      kmemleak_scan
> > > 
> > > and, worse, blocks the callers waiting on that grace period. Here a BPF
> > > struct_ops map free, which waits via synchronize_rcu_mult(call_rcu,
> > > call_rcu_tasks), is stuck long enough to also trip the hung task check:
> > > 
> > >   INFO: task kworker/...:bpf_map_free_deferred blocked for 122 seconds
> > >      __wait_rcu_gp
> > >      bpf_struct_ops_map_free
> > > 
> > > Then I've learned that cond_resched() is not an RCU-tasks quiescent
> > > state, so, we need to use stronger primitives.
> > > 
> > > Use cond_resched_tasks_rcu_qs() at the scan reschedule points so the scan
> > > reports an RCU-tasks quiescent state as it proceeds.
> > > 
> > > Inspired by commit b96285e10aad ("tracing: Have osnoise_main() add a
> > > quiescent state for task rcu").
> > 
> > I'll add
> > 
> > Fixes: c4b28963fd79 ("mm/kmemleak: rely on rcu for task stack scanning")
> > Cc: <stable@vger.kernel.org>
> 
> Thanks to all three of you!
> 
> This adds fewer than ten calls to cond_resched_tasks_rcu_qs(), but still
> more than doubles the number of such calls outside of the RCU subsystem.
> 
> Which is most likely just fine, and in any case absolutely should not
> get in the way of Breno's patch, which after all solves a real problem
> in the here and now.
> 
> Nevertheless, on the off-chance that over the next few months or years
> we start playing cond_resched_tasks_rcu_qs() whack-a-mole, I figured it
> would be good to get a head start on writing up alternatives.  An initial
> draft may be found here:
> 
> https://docs.google.com/document/d/1s3fn29SCTYVw9jak4iraNIVQR59Wk5C6_I-_eu-MfQA/edit?usp=sharing
> 
> TL;DR:  Should we get into a rousing game of whack-a-mole, alternatives
> include continuing as we are, making the existing calls to cond_resched()
> in turn call cond_resched_tasks_rcu_qs(), decoupling mutex-induced
> hung-task warnings from synchronize_rcu_tasks(), and various
> not-so-practical alternatives to RCU Tasks for trampoline synchronization.
> 
> Thoughts?  Especially thoughts on other schemes?

While debugging this issue, I was surprised to discover that cond_resched()
doesn't provide RCU-tasks quiescent states. That led me to
cond_resched_tasks_rcu_qs(), which is the stronger primitive needed for
long-running kernel threads like kmemleak_scan(). Is this the common
case for cond_resched()? I got the impression that kmemleak is the
extreme side, but, I have no data on this.

Worth noting that commit 7dadeaa6e851e7 ("sched: Further restrict the
preemption modes") continues to narrow PREEMPT_NONE, so the future of
cond_resched() itself may be uncertain, no?

