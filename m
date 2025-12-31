Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8F0AFEE57D7
	for <linux-mm@archiver.kernel.org>; Wed, 31 Dec 2025 15:32:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E6A436B0088; Wed, 31 Dec 2025 10:32:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E00886B0089; Wed, 31 Dec 2025 10:32:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D0C756B008A; Wed, 31 Dec 2025 10:32:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C13026B0088
	for <linux-mm@kvack.org>; Wed, 31 Dec 2025 10:32:32 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9690A1A04AC
	for <linux-mm@kvack.org>; Wed, 31 Dec 2025 15:32:32 +0000 (UTC)
X-FDA: 84280158144.14.458544F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 0F05C1C0019
	for <linux-mm@kvack.org>; Wed, 31 Dec 2025 15:32:30 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=p5pdPmm6;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767195151; a=rsa-sha256;
	cv=none;
	b=YeN2HmbX/sNXszuhgUINj2UrdSEJXtEhK5oYmNSffrCDhz/N5ka4L/NIfsFA3R+geSoWWg
	RY8FJUzZJmNNYyzMDJJsdEvHBb71POiphOvppg/DJ1sbh9utUqXnS6OGBYPwuAUrnvadgN
	GOR4eZy9lQv8xxS+oNIwzfwg3yuhU1w=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=p5pdPmm6;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767195151;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=//crt95N/7Ddi2TC2G9WkNtDjayFpNENxg96NEAI6EY=;
	b=UTPfdgbQahB9nQ0ZKiakOvqO/RrqAVO/6lFVFFAxkWG4mMBFSIt11xbjm+Z88Z1a+3mHQA
	u4L+qVw7aM9lPboa/VfInLYCggONDYCrjIHm2UTScxPT6CFAR3/FsQTuLz9tRdtwcqfPf6
	gyaAENmH1qvZKt2H8Q2O5QEvfeUZhJs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 6800D60008;
	Wed, 31 Dec 2025 15:32:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3752C113D0;
	Wed, 31 Dec 2025 15:32:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767195150;
	bh=wZSt7/UMXpEBgJcZocMzNkrHh9oTHPi1H+DWNxUfbIM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p5pdPmm6tf16Z03/jVsx9PPzuhDvh0wSBsMhQqPhXgmWs8F9OXA8R/VATda/W+b+D
	 dt4oXj1tWSYiGZ9V3+1TKSx7DLyI+LatmVKvzOlaWaL826Vqn/+rUWsZiMCEzD9XAd
	 55ao3aCn9ULX+Q+bz7tTPeVx+MSuFapxwsy5rz77WPNoecxlNa0aKE07f1XGKsx8bT
	 dtfZ5S89xPLQbcUS9B1KlVCLXAK/4oZH25VuNJX9XO4VvFDnxHOeVm7rJaeaJ2756f
	 zHOkN2gTJVSAJSBWrvq+0N0wHGgKrLvtELfmAov8AW/ae+ICP1lc9JN/AtYpVp0x3S
	 a7T2MY8uoqZXA==
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
Date: Wed, 31 Dec 2025 07:32:15 -0800
Message-ID: <20251231153216.82343-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <CAHOvCC6ZPyi=tMK9YhcuWPEzdnTje1ADCWzhs7uJCwHh3SMHpg@mail.gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 0F05C1C0019
X-Stat-Signature: 56k6obdwp3zssf5hopupkq3yfu4qxjki
X-Rspam-User: 
X-HE-Tag: 1767195150-327213
X-HE-Meta: U2FsdGVkX1+LhGRatNcLJn7Q/OOLK6+V7SwsR4mu6M+YZ/G/px4bibF3Sud5asFw3N5v88gJiqGmD1507JWpbv94P0PYBKgnvljufn3xPW9cl/qTF0W1587Z12bdFJDsacgoF2uTAUgeR9tfSZv9i2SlIq2t8ZOnZGcWHRjgrYDFRtKBFJSF/mrKuFezl0pBzuhJ3ZndGdGBiNmRE0lFfIDV88ce63BhRzseiXgk1CP25G3oaEKoJRipoA3a4yjU6FcnJ6aWYgx5NGebAtTcC7SUMAcNe6VamxWc/TWiIVv0appB7Z7gqMOzHs2Ap7u8KzPYmhaNVOFw7aN+fSjAjeX5ahvxFznMYdQGWdlHDfoIyKi75cus/zIDYlkGBRLKYN1E7d2y+H8pfcYvRZd83EM2VUDQX9sE9KeR0OmajU6fw8nHthXsZlwGX8MMf679gjmc3lLJ3f/9ITKUU5RoPBgE8dALvnYphrlQQEelee3S49cCmpoE+KZ79UpiVxdDc/McCkM1CDvU7apymfmk176ztBZkklOhsTK80Xo4BtsUIX7s+jhOsPN9Pi/KdoDM7FAUJGOkZAK6tL2lNPB2mUziAe28T8r8U3oz4nqXxPhly+2kuMSvFitIUYOfG6mWjWBAN01qSq+mfm6pujkgzJ/qJuMal1HTNBCe4u5KDZJEHys1rB8a73+FJ1uV26kXo+tvpfr4aDFWZWt0IzcDjblPyGr0TCM/WBYe8tWDGtB5BaEdcBaiwZrL1P2stEYi74ybRb8aJFkh9Pk5ZZhmhhS5ILX3eD9W1yNq+MmvNUtJGQ9rbGVr7OHoYSXtRlSPbtG9KML3w/Y0FCmyxyWaLRC+FWTPZ1/d6SVcGluRFn4glWfFxdnQiJs7QoNPpOpKkf5IcLZOM/eRa4+WUI6ghEGSRL29Ze6t4YkNJNn0fmHPcvTWwLZGhxQKqog1nI9W773g8IdDJ4jTMrceEeA
 r6Bxrjp8
 z7RVbifUJ5xueqtbMrQ3O+PGQim7xOHwHTpVURNCVwft8iTiw8dAvpTZWrZ8+XvOSNUGtm894VluVkF2/FiheReqVcr3DstBC5NAtl9i5ZZrCzSzhhYB19U/Rn36MQhgHUi7rgeUx8zJVGK0sTENR23SEdoFMhVIhyoLnYcegp/FkICmHrLsGR3wL3u6QT0M21QSI8GafngFeVfIP3/hQ7bHr5HuNdIbMWfCmbByEmUzMBgmsxKgh6MF7VO7gZblekzZK32m9Yhdx4xTM4mT0HU5ZO+IbpaGQ4WYu4UV6O4cK00duevms1oathj8NwPSr+/B3qswNtJOZ3WCmBXTQ5/HvJPJellPTM8Bu8pCGVQPEdZk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 31 Dec 2025 15:10:12 +0900 JaeJoon Jung <rgbi3307@gmail.com> wrote:

> On Wed, 31 Dec 2025 at 13:59, SeongJae Park <sj@kernel.org> wrote:
> >
> > On Wed, 31 Dec 2025 11:15:00 +0900 JaeJoon Jung <rgbi3307@gmail.com> wrote:
> >
> > > On Tue, 30 Dec 2025 at 00:23, SeongJae Park <sj@kernel.org> wrote:
> > > >
> > > > Hello Asier,
> > > >
> > > >
> > > > Thank you for sending this patch!
> > > >
> > > > On Mon, 29 Dec 2025 14:55:32 +0000 Asier Gutierrez <gutierrez.asier@huawei-partners.com> wrote:
> > > >
> > > > > This is a minor patch set for a call_controls_lock synchronization improvement.
> > > >
> > > > Please break description lines to not exceed 75 characters per line.
> > > >
> > > > >
> > > > > Spinlocks are faster than mutexes, even when the mutex takes the fast
> > > > > path. Hence, this patch replaces the mutex call_controls_lock with a spinlock.
> > > >
> > > > But call_controls_lock is not being used on performance critical part.
> > > > Actually, most of DAMON code is not performance critical.  I really appreciate
> > > > your patch, but I have to say I don't think this change is really needed now.
> > > > Please let me know if I'm missing something.
> > >
> > > Paradoxically, when it comes to locking, spin_lock is better than
> > > mutex_lock
> > > because "most of DAMON code is not performance critical."
> > >
> > > DAMON code only accesses the ctx belonging to kdamond itself. For
> > > example:
> > > kdamond.0 --> ctx.0
> > > kdamond.1 --> ctx.1
> > > kdamond.2 --> ctx.2
> > > kdamond.# --> ctx.#
> > >
> > > There is no cross-approach as shown below:
> > > kdamond.0 --> ctx.1
> > > kdamond.1 --> ctx.2
> > > kdamond.2 --> ctx.0
> > >
> > > Only the data belonging to kdamond needs to be resolved for concurrent access.
> > > most DAMON code needs to lock/unlock briefly when add/del linked
> > > lists,
> > > so spin_lock is effective.
> >
> > I don't disagree this.  Both spinlock and mutex effectively work for DAMON's
> > locking usages.
> >
> > > If you handle it with a mutex, it becomes
> > > more
> > > complicated because the rescheduling occurs as a context switch occurs
> > > inside the kernel.
> >
> > Can you please elaborate what kind of complexities you are saying about?
> > Adding some examples would be nice.
> >
> > > Moreover, since the call_controls_lock that is
> > > currently
> > > being raised as a problem only occurs in two places, the kdamon_call()
> > > loop
> > > and the damon_call() function, it is effective to handle it with a
> > > spin_lock
> > > as shown below.
> > >
> > > @@ -1502,14 +1501,15 @@ int damon_call(struct damon_ctx *ctx, struct
> > > damon_call_control *control)
> > >         control->canceled = false;
> > >         INIT_LIST_HEAD(&control->list);
> > >
> > > -       mutex_lock(&ctx->call_controls_lock);
> > > +       spin_lock(&ctx->call_controls_lock);
> > > +       /* damon_is_running */
> > >         if (ctx->kdamond) {
> > >                 list_add_tail(&control->list, &ctx->call_controls);
> > >         } else {
> > > -               mutex_unlock(&ctx->call_controls_lock);
> > > +               spin_unlock(&ctx->call_controls_lock);
> > >                 return -EINVAL;
> > >         }
> > > -       mutex_unlock(&ctx->call_controls_lock);
> > > +       spin_unlock(&ctx->call_controls_lock);
> > >
> > >         if (control->repeat)
> > >                 return 0;
> >
> > Are you saying the above diff can fix the damon_call() use-after-free bug [1]?
> > Can you please elaborate why you think so?
> >
> > [1] https://lore.kernel.org/20251231012315.75835-1-sj@kernel.org
> >
> 
> The above code works fine with spin_lock.  However, when booting the kernel,
> the spin_lock call trace from damon_call() is output as follows:
> If you have any experience with the following, please share it.

Can you please reply to my questions above, first?


Thanks,
SJ

[...]

