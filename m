Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A187C87FD1
	for <linux-mm@archiver.kernel.org>; Wed,  6 Aug 2025 04:15:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C74878E0008; Wed,  6 Aug 2025 00:15:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C25A98E0001; Wed,  6 Aug 2025 00:15:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B14A78E0008; Wed,  6 Aug 2025 00:15:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 9ED688E0001
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 00:15:30 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id DC4641DBC48
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 04:15:29 +0000 (UTC)
X-FDA: 83745018378.06.B20DCAB
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
	by imf12.hostedemail.com (Postfix) with ESMTP id 246F040007
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 04:15:27 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=V9tKBhyt;
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754453728;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=F7wWxyyQjlsBojcruZX5votDAaB9l9yG8cW4n7qMu6Q=;
	b=Zr/Mw0NpJPhcLmdPu2Q1qqZK+W8p65KaVsO1i5agAUC0b45+m+R8ZGAyCmRjTKv+Hyos3+
	SAAgaeTXU7nc5TMjbBHYvfXgSKuLynqdaUYcLk51c+TdjGcpT7NhOsujejPoid+RxTgDw/
	J5FlTCqJMPDO+QGTFXOGo5Sxb9GKim4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754453728; a=rsa-sha256;
	cv=none;
	b=FPbMQcQsWoISzhU4gPBKEPdzHeWQjB8J+h3B+zz34JbhabLtQr4F/CFnV7qIOw8gZuBILQ
	NdZt4XG+K3A/njPNziBc1HBqm/umQHOxl6RFh7s7Wqn92AeW6ZcRNPxtxs7WriJq0SWt8e
	m+R3RiAiN/UC3mERIag2E0YMI1M1WNQ=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=V9tKBhyt;
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by dfw.source.kernel.org (Postfix) with ESMTP id 02BCB5C1D0D;
	Wed,  6 Aug 2025 04:15:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7945BC4CEE7;
	Wed,  6 Aug 2025 04:15:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754453726;
	bh=lixsbVjRKbA2M2sbx8UeuLMLOOp/6eUO40vsAH+a5LY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V9tKBhytuodqEZxedPiCOH4+GHEEDTBFk1rnP38/kSvFuoPbRem5F5lhTwjA+7fsr
	 ig6tgd4pRttkI/nmaO33Dzr5D0zL1efo7QPMHVVuimFZciajkMy5af+A0kqvBCB/rA
	 kdJjTUt/M0yLDPOESiXLj3m+t1/jh/mv61xJI7EqLvD9EZQLFm0tmW5QuT9mKObx+z
	 WfMHgAFJ7ErAOkBNG6j5pPFfDPhJL56cXwMOeCmt5Q2c9h/bxpd4rnz4mnL/Iv4azC
	 2KiQctviETGhdXewkqyeJLodwmZUnnvVxbGEMtD9b1JvLWrz+CxEkxWemw3AxxJ8LK
	 w7LvnVKD9lpqQ==
From: SeongJae Park <sj@kernel.org>
To: Bijan Tabatabai <bijan311@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	corbet@lwn.net,
	Bijan Tabatabai <bijantabatab@micron.com>
Subject: Re: [PATCH 0/5] mm/damon/sysfs: Add commands useful for using migration dests
Date: Tue,  5 Aug 2025 21:15:23 -0700
Message-Id: <20250806041523.54394-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <CAMvvPS6hfCRh1fQh5zU5_quswPFVp0zWyS9N-Zikc0K-nSZd_g@mail.gmail.com>
References: 
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 246F040007
X-Stat-Signature: fauwe6bqhiuib7qsnohat3s5q1sm4psf
X-Rspam-User: 
X-HE-Tag: 1754453727-961386
X-HE-Meta: U2FsdGVkX1/bw9G/H65zm2kbhXrtsulnPomI5h5MM36dcO+l/iyPLCKQuEWG6WLOw7lDhLdCqck8F9Via0OVNiDsRr3LfFT+bhyqe/O+27YDaKj3dZ/n4ouLRK2ikFlPcRZ/bNv3HibKA6aH9v+dwRAxNWdnUFFrwsizKP7EKUvLaaAVVE9nKPesYn/L2yykvx5kQ53mkzoRL7z2/83torcEpY6ZQlcgdRMqBxaTdbNGnsNICsCI4ulQcclG3rsJ4eM1X1q/UDM0IDLk6ng+HeLERB+odFGBMXGMsqfxi1ypG/AfOt7DjDDquzUW7Aq/y10bihJ9LJyGu6stSNLbKZPbOI9OaMvPnq/kQEUSGBQg+VLyyVzJ+U7/+961YGeBdjLbPH75N9Iqy2sx1wBKVYaqqqOquQ07yLkSkauNKix8sggphnyqAdDX13/QmEM05CPh9bhXL1OluXg+VwuwnDmnFYAQevc/2IQrPmE3ZJMFSxHpuChpeff4jwRERYqrHV4IGbOmrRqUgoqOExFo1Ak8qwYR3evLHsjJZfuFZCPmSlw2wTvyBFQqN/3bo9f60CETtSn1IcoYoxn44VmBSVRyxG6AIAtfJYte2tzvSi1jnOOzVNC6f3Ri66sml4dclGd280bpBF8olWgrF1oxnsNMClm7RzUu+MJn3NIFiTjBcmDGoz9Wu1pbPahMpj+CjuyJZLwXDfYPs3V7kwacwBiqsAidK6+Su/ZvkxsA+bMVSKlmu6TRZnI/KOYft1mhSuBUCuUJ0Xj3eO4qjvd0Tqp/4a2yHBL4nInEG3BUZMJ6W7LFI7HaVNKA5kF2Jgh1cK7WyMCFIJ3grBncZ3ethZ6i8Mzo6RJ3hauhm9JpRFyrGznQMZ7sqXhPjOnFA6rgNKueceOapUxFHeguNUtMSA1gzlV/xR5/TZK13NxQQ6ghmpS0UX7xnePrxd+86dUlZ7v0CF/O73zrLB2FSnr
 NVchy1nb
 EXihmiB7tj7sSo2M5sYiOW31RtlAN6L9AKwsbPyCLKr4Y5hcRsTXBSKF/ehTrOjtZh1ArQ69Y+tZCp0Xh7eQJPaMrqiQ4WkZW5R7+iVQ+KSEjAZHYTRbxqOqZfInwP2xwNGrMQWQIYM2t75JpksZYHBix3mGynrscNqflS4s8XvFFOfAeVSfCGbgv7V/7tzqN+gCU/gB73Pb01Xmhs2G1zMaxajQxzZvp65KTGeY8Ud8d/hhDL7KZEeRKyimZeOmLir/Mp18vVOcaUCLJMu2DnNLFpaVqqBR1dn9/
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 5 Aug 2025 20:27:52 -0500 Bijan Tabatabai <bijan311@gmail.com> wrote:

> Hi SJ,
> 
> 
> On Tue, Aug 5, 2025 at 7:40 PM SeongJae Park <sj@kernel.org> wrote:
> >
> > Hi Bijan,
> >
> > Subjects of patches usually be converted into lowercase when be merged into mm
> > tree.  I'd suggest using lowercase even in patches stage, if those aim to be
> > merged into mm tree.
> 
> Noted, thanks.
> 
> [...]
> > > The commit_schemes_dests command, similar to the existing
> > > commit_schemes_quota_goals, is used to commit only the dests fields of
> > > schemes. This has a couple of benefits:
> > > 1) It is more efficient than recommitting all the DAMON data.
> > > 2) Doing a full commit resets the aggregation and ops_update intervals. If
> > > a user sends the full commit command frequently (relatively to those
> > > intervals) the aggregation and ops_update events will be prevented from
> > > triggering. Having a separate commit command side steps this problem.
> >
> > I agree the commit command of DAMON sysfs interface is inefficient, and could
> > make the infinite intervals delay problem.  But, I didn't expect there could be
> > use cases that use commit feature frequently enough to make the inefficiency
> > and the intervals delay be real problems.  Could you please let me know more
> > details about your use case and how severe problem DAMON is causing?
> 
> In my use case, I am trying to optimize the interleave ratio of
> applications to maximize their performance without prior knowledge of
> their behavior. To do this, we take the steps of updating the ratio,
> observing how the system reacts to the change in ratio, and update the
> ratio again accordingly. Because we want to approach the ideal
> interleave ratio quickly, we update the weights frequently, motivating
> the commit_schemes_dests. Similarly, we want to observe how the system
> reacts to the change only after the change has been applied,
> motivating wait_for_schemes_apply.

Thank you for sharing these details!

It sounds like you are using DAMOS without any quota, and the target workload
has static memory mapping.  Hence all migrations for the new weights can be
completed after one DAMOS schemes apply interval, and no more migration will
happen until new weights are given.  And that's why you want
wait_for_schemes_apply, since when the command is finished is when all new
weights based interleaving is done.  Am I understanding correctly?

> 
> The consequences are not very severe. The problem can be worked around
> by either updating less frequently, at the cost of converging slower,
> or decreasing the maximum aggregation period, which from what I
> understand may affect the access monitoring behavior.

Sounds suboptimal work arounds for you...

> 
> > Depending on the real problem, I'm wondering if optimizing commit command can
> > be a solution.  For example, skipping the update of next_aggregation_sis and
> > next_ops_update_sis when the intervals are not changed might be able to solve
> > the intervals delay problem.
> 
> This would work for my use case.

Great to hear this, and I agree.  The commit operation internally uses
damon_call(), which takes up to one sampling interval.  Also the migration
operation that you will wait for would also take no small time, depending on
the amount of pages to migrate.  Compared to those, I think the commit speed
increase due to committing unnecessary paramters may relatively short.
deal.

Meanwhile, I was concerning the continuous next_{aggregation,ops_update_}sis
delay could be a real problem.  And this option should solve the real problem.

> Another option might be to have a
> more general commit_schemes command, which may be useful to other use
> cases. I'll defer to your judgement on which would be better.

If my above theory is not wrong, I'd suggest making the commit operation
optimization.  If it turns out to be not enough for your or others' use cases,
we can further consider commit_schemes.

> 
> > >
> > > The wait_for_schemes_apply command causes the calling thread to wait until
> > > all schemes have been applied. It does this by calling damos_walk() with a
> > > NULL walk_fn. This can be useful, for example, if a user wants to know when
> > > new scheme parameters they've committed have been applied. Another use case
> > > could be if a user wants to record the system state every time a scheme is
> > > applied for debuging purposes.
> > >
> > > The functionality of wait_for_schemes_apply can be achieved with the
> > > existing update_schemes_tried_bytes and update_schemes_tried_regions
> > > commands. However, having a separate command avoids extra work and makes
> > > user intent clearer when used in scripts.
> >
> > I agree extra works are always better to be avoided.  But is the overhead large
> > enough to be a real problem for your use case?  I also agree it could make the
> > user script cleaner, but adding a kernel feature only for user scripts
> > readabilities sounds like too much, since the user script could have its own
> > abstract layers for its readability.
> 
> Totally fair. I will drop wait_for_apply_schemes in any future versions.
> 
> > Also, even if the new command is implemented, since the DAMOS schemes continue
> > running, the system status will keep changing.  If you cannot do the recording
> > of the system state in a restricted time, the recorded information might not be
> > that reliable.  So I'm not sure if you really need this strict waiting in this
> > way.
> 
> Fair. That was not something I was personally using the command for,
> just another possible use case I thought of. Regardless of the
> usefulness of that, the existing commands using damos_walk would work
> well enough.

I'm glad to hear we found a way to go.  As you may know,
update_schemes_tried_bytes would be more efficient, so I would suggest that
more than update_schemes_tried_regions.

If the wait is not strictly need to be accurate, maybe monitoring the DAMOS
scheme stats in auto-update mode[1] until any change is made could also be a
way.  The stat update for a scheme will be done only after the scheme is
applied to all applicable regions for a round.

> 
> > Could you please share more details about what you want to do with the new
> > command, and how much problem you are seeing?  I'm particularly curious what
> > system state you want to record, and why you need to wait the exact time
> > interval.
> 
> I mentioned this above, but I am using this to wait for new migration
> weights to be applied before monitoring how the change affects
> applications, but again, this can be done with existing commands.

Thank you again for kindly sharing your use case and participate in this
constructive discussion :)

[1] https://lore.kernel.org/20250717055448.56976-1-sj@kernel.org


Thanks,
SJ

[...]

