Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DA922EEB573
	for <linux-mm@archiver.kernel.org>; Thu,  1 Jan 2026 02:00:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 49EAB6B0005; Wed, 31 Dec 2025 21:00:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 44C2A6B0089; Wed, 31 Dec 2025 21:00:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 32DB86B008A; Wed, 31 Dec 2025 21:00:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 227836B0005
	for <linux-mm@kvack.org>; Wed, 31 Dec 2025 21:00:39 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 71697C8B1F
	for <linux-mm@kvack.org>; Thu,  1 Jan 2026 02:00:38 +0000 (UTC)
X-FDA: 84281740956.14.DC3A704
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id C096A80007
	for <linux-mm@kvack.org>; Thu,  1 Jan 2026 02:00:36 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IyEuIJMM;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767232836;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+tGzFox4owIurHIzQMYvWLfVAtFtId2uhkJxlPDQmU0=;
	b=0UDUawvoFfiOku2l0LSg2Q69BUuQsOhy/CQ6ITAPvasJ5nUJLlrMz+qmAKfadPFEOIkoW2
	2CUdlzVOMZAcbaJMa1GaBtnyqFWTBWRYgUSujNwQ0Qn7p0YW3cuIpQakJXl9CXffwwcmgj
	rv8uk5zTTQ1Vho6lvxo4liNMUESc28Q=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IyEuIJMM;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767232836; a=rsa-sha256;
	cv=none;
	b=yq7SGwC3/o+/se2Dx3X6Gq/SRR8SLwwYhwJekOD7NAAMfMvFx1XYHehkR1FIHOISof/pDa
	MMiq6e+YSvbu3cZb18ehgTkxXqG0R0qtY2uaVLO/CrefZ+3HBi4YUhEhE0AZ4XJngekuRE
	TQ+SZs2b2Wdq1jUcbtoHToYktTOOtgg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 24A7B60008;
	Thu,  1 Jan 2026 02:00:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E0A4C113D0;
	Thu,  1 Jan 2026 02:00:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767232835;
	bh=SfUd+VIYbA5tyDlhKz1PyHaZjHMxYtaNAXFMWqOAQws=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IyEuIJMM5hM3OgqjM6myvFfoDMfB+64kXLBnhjT6N0VxJijiH5bYzArVhLmcKxOgL
	 UfqyCYpeTqi/EMwNXZgwZd2rfOgWiKSSzFIWWdpWrnK62VmRLCkY3FSexzkEE8mZip
	 qn033Qg7cmiVldfoGKW6cBWV0qCQpmaiJUQ+nDi2Htxvoo3HJ3zKF/VRhlk2cJc9TR
	 uy3yGLrh1iDtpf4zWBJJNIpmSW0pgCOpjiVtVdbJYwUnG2hkzOnICEggYdMVfxHgVs
	 93mT3FhFD0xMBrtJSv22bM0g7aVgnQKWYl//I1I4YgIHShS3YVzssBK4Kmc7hlFXz5
	 n7o0wOj1RE0vQ==
From: SeongJae Park <sj@kernel.org>
To: JaeJoon Jung <rgbi3307@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	Asier Gutierrez <gutierrez.asier@huawei-partners.com>,
	akpm@linux-foundation.org,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	wangkefeng.wang@huawei.com,
	artem.kuzin@huawei.com,
	stepanov.anatoly@huawei.com
Subject: Re: [RFC PATCH v1] mm: improve call_controls_lock
Date: Wed, 31 Dec 2025 18:00:27 -0800
Message-ID: <20260101020028.88096-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <CAHOvCC6or4a5YM-byNFkB4q8v8YO=ZrT0VymYQfSXEx84wgeZw@mail.gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: C096A80007
X-Stat-Signature: fdgkktrri84ci7gk37incmzujipfx77w
X-HE-Tag: 1767232836-37687
X-HE-Meta: U2FsdGVkX19DKOErlLk8w46tc4i5iSJvMmupXA/kotJiWbWMPnYMtYleJFl6/SdSzuipBv7lA/c7fnloHUl2uvB8xf+IpcRVU3FsVVeV58HfpzKYB5dAB5hvTx1KqoSAUQJbMEi7fbpU6YIsYyew4O3qTZV0dcf5/I1Lc5hHpy3JQiZtEUlC2rt67ysuHWv4RrvZZgtMPcK9xNUIT0PzyGzhxDGLjGfXQib/12H6XdTv9CwuOmmW4Br+vYX+JfDx3wfPvJScwdVj0H9a70mDE6C4HHIFIdvP6xAnUohiN2v0ugbxwkpHrEC8qBjfqTr45EA7ZjbaGpDfaXzMgLagwzmWF7RtUkRz9kCNnILge+CYV77+baaBzADB5+CNFwSes0z/8AaRxWATD29IZqnmnEy/hfx9L9kOXZuicS903/dcNMvyjSBFNx8kCcC7AdGAI/V09Enehl7q8ZyF2VILz1Vbn7uitTXwuAy3Cb3CYWREDbKvBWEFdJPco/FiRTpSIUvBbnQSwSEEUDS/iG5KAOFISYzcjI9+HM3+i1UKAxDGA0Z/XV2uNy/G6yszZZvW79FwUqOFic1IayXUkG8SimRVXJFxd3eCY+ykJ+CEsvP8U57Wp6S27eQ0y+DKiMze3fGGbp5/BWq4ao+ZevkH+ElFARKEivp3h3KYOeswlPT7WQaV70X5fAYKTa4vUhKjUd5IaqE4BiLCYI7ypIHeERc551FIkof9KXo2Q9fY9mJTOzLcKu+rewThXpin9d7yMsY5MfbvCbkEB/lWB53vnUaM269SdHOh0hRHR39MYzX8u2HC+mM5Iu0/ck7vyj+C/ldua836McPMth/g7SlUzp2T9/IFHdL1R/Wj3SSQ4S1BkjzL6MSuPp9uW8GJVutcASvCoeZQeZIjOhOJzsyOUk8jbjpER8cSQ/j7pjcpiKQUosJDwkNd740BB7t1s2NnJMgFvyGXKCzweifsGlR
 Cn6hBBA4
 HqDEAvKzzPS+XlowsT88jrIs1H1MVKFTW9RVp0YM0WaaP7Vfi0wfj5+uyvKwvLcTPXKlx2zwrsr8la25kufFVmNWwaQ23qaTQBQOBFqlChvNGZhHok1hAzMLpJDh4mxnirEmIrrKgeGNfPJgG7jPl/eBMADlXXEoNMHnn3NndKtW24YIZAqsGLdIa5T/mS2ip//Uxxu5A+D/c+LvXLx7P0hJlxQwfi7l/Duf4P4N7DpYWrHT8CknDb8EhoNRC90TskyvzbSkebUrWRAyZ1gYHOp2nh4SOwnOyi9dqJrtH1I3gcfPOXVsWbz1YsnEtvmrcMl3X2R6HBNIyjZ0U2W1VEhBT+Hjj460QG6YlfYgyC66UXrY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 1 Jan 2026 10:11:58 +0900 JaeJoon Jung <rgbi3307@gmail.com> wrote:

> On Thu, 1 Jan 2026 at 00:32, SeongJae Park <sj@kernel.org> wrote:
> >
> > On Wed, 31 Dec 2025 15:10:12 +0900 JaeJoon Jung <rgbi3307@gmail.com> wrote:
> >
> > > On Wed, 31 Dec 2025 at 13:59, SeongJae Park <sj@kernel.org> wrote:
> > > >
> > > > On Wed, 31 Dec 2025 11:15:00 +0900 JaeJoon Jung <rgbi3307@gmail.com> wrote:
> > > >
> > > > > On Tue, 30 Dec 2025 at 00:23, SeongJae Park <sj@kernel.org> wrote:
> > > > > >
> > > > > > Hello Asier,
> > > > > >
> > > > > >
> > > > > > Thank you for sending this patch!
> > > > > >
> > > > > > On Mon, 29 Dec 2025 14:55:32 +0000 Asier Gutierrez <gutierrez.asier@huawei-partners.com> wrote:
> > > > > >
> > > > > > > This is a minor patch set for a call_controls_lock synchronization improvement.
> > > > > >
> > > > > > Please break description lines to not exceed 75 characters per line.
> > > > > >
> > > > > > >
> > > > > > > Spinlocks are faster than mutexes, even when the mutex takes the fast
> > > > > > > path. Hence, this patch replaces the mutex call_controls_lock with a spinlock.
> > > > > >
> > > > > > But call_controls_lock is not being used on performance critical part.
> > > > > > Actually, most of DAMON code is not performance critical.  I really appreciate
> > > > > > your patch, but I have to say I don't think this change is really needed now.
> > > > > > Please let me know if I'm missing something.
> > > > >
> > > > > Paradoxically, when it comes to locking, spin_lock is better than
> > > > > mutex_lock
> > > > > because "most of DAMON code is not performance critical."
> > > > >
> > > > > DAMON code only accesses the ctx belonging to kdamond itself. For
> > > > > example:
> > > > > kdamond.0 --> ctx.0
> > > > > kdamond.1 --> ctx.1
> > > > > kdamond.2 --> ctx.2
> > > > > kdamond.# --> ctx.#
> > > > >
> > > > > There is no cross-approach as shown below:
> > > > > kdamond.0 --> ctx.1
> > > > > kdamond.1 --> ctx.2
> > > > > kdamond.2 --> ctx.0
> > > > >
> > > > > Only the data belonging to kdamond needs to be resolved for concurrent access.
> > > > > most DAMON code needs to lock/unlock briefly when add/del linked
> > > > > lists,
> > > > > so spin_lock is effective.
> > > >
> > > > I don't disagree this.  Both spinlock and mutex effectively work for DAMON's
> > > > locking usages.
> > > >
> > > > > If you handle it with a mutex, it becomes
> > > > > more
> > > > > complicated because the rescheduling occurs as a context switch occurs
> > > > > inside the kernel.
> > > >
> > > > Can you please elaborate what kind of complexities you are saying about?
> > > > Adding some examples would be nice.
> > > >
> > > > > Moreover, since the call_controls_lock that is
> > > > > currently
> > > > > being raised as a problem only occurs in two places, the kdamon_call()
> > > > > loop
> > > > > and the damon_call() function, it is effective to handle it with a
> > > > > spin_lock
> > > > > as shown below.
> > > > >
> > > > > @@ -1502,14 +1501,15 @@ int damon_call(struct damon_ctx *ctx, struct
> > > > > damon_call_control *control)
> > > > >         control->canceled = false;
> > > > >         INIT_LIST_HEAD(&control->list);
> > > > >
> > > > > -       mutex_lock(&ctx->call_controls_lock);
> > > > > +       spin_lock(&ctx->call_controls_lock);
> > > > > +       /* damon_is_running */
> > > > >         if (ctx->kdamond) {
> > > > >                 list_add_tail(&control->list, &ctx->call_controls);
> > > > >         } else {
> > > > > -               mutex_unlock(&ctx->call_controls_lock);
> > > > > +               spin_unlock(&ctx->call_controls_lock);
> > > > >                 return -EINVAL;
> > > > >         }
> > > > > -       mutex_unlock(&ctx->call_controls_lock);
> > > > > +       spin_unlock(&ctx->call_controls_lock);
> > > > >
> > > > >         if (control->repeat)
> > > > >                 return 0;
> > > >
> > > > Are you saying the above diff can fix the damon_call() use-after-free bug [1]?
> > > > Can you please elaborate why you think so?
> > > >
> > > > [1] https://lore.kernel.org/20251231012315.75835-1-sj@kernel.org
> > > >
> > >
> > > The above code works fine with spin_lock.  However, when booting the kernel,
> > > the spin_lock call trace from damon_call() is output as follows:
> > > If you have any experience with the following, please share it.
> >
> > Can you please reply to my questions above, first?
> 
> I have answered your above question.

Are you saying your reply [1] that posted today?  Unfortunately I was unable to
get all answers to my questions from it, so I asked your more explanation as a
reply to that.

> And, since call_controls_lock has a
> short waiting time, I think it would be a good idea to consider spin_lock.

This sounds like you are only repeating what you told so far, without
additional explanation.  Hopefully the additional explanation can be made on
the thread [1].  Please keep replying there.

[1] https://lore.kernel.org/CAHOvCC65azs4BU2fyP-kxvFWB3ZPCfyZ7KCO8N1sc0jtTENmNw@mail.gmail.com


Thanks,
SJ

[...]

