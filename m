Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C5B2DE7AD67
	for <linux-mm@archiver.kernel.org>; Thu, 25 Dec 2025 20:01:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0E5146B0088; Thu, 25 Dec 2025 15:01:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 093106B0089; Thu, 25 Dec 2025 15:01:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EB69C6B008A; Thu, 25 Dec 2025 15:01:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id DA9346B0088
	for <linux-mm@kvack.org>; Thu, 25 Dec 2025 15:01:03 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6DF6C8B5EB
	for <linux-mm@kvack.org>; Thu, 25 Dec 2025 20:01:03 +0000 (UTC)
X-FDA: 84259062006.23.94260E3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 9906B40010
	for <linux-mm@kvack.org>; Thu, 25 Dec 2025 20:01:01 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QFlJQpLo;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766692861; a=rsa-sha256;
	cv=none;
	b=cf4P3uMMjNR8bDlCLbkohZRb4HupLQiqfFwha+QdIMaNchSmqT7Vgy6MKU6krdpORILLyz
	TXyQbz8ftW5cOs1bM7SOizaZS64I88m/omg6obO5cnp9AbDgcE6LfJlNwMFYchCY+ZFygz
	qFZB1KX7vZNliQxDJj9qDccaFPBP5xg=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QFlJQpLo;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766692861;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Jsy6GbquBWIJw/Ml9E6YLIplQUDYGnpwyVA7tdnDK/8=;
	b=W9Bm2qp7+A1spBSGOroizKIaBXbX1AAfVTDuEbvTLJkIkCTpXbUc0vpiDlmAw53X6wfqWT
	h5NegHML2fecmv2bf0yyKfUHvb+D4PiJYYCH+g6HcjBQX5xc6hJgSSqe4f6FzwCir0j00i
	pqta8tOjdcySNjbaSuMgxcMLxXjLPM8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 6750F400D0;
	Thu, 25 Dec 2025 20:01:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F222DC4CEF1;
	Thu, 25 Dec 2025 20:00:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766692860;
	bh=vKAiaWTw332zPI04HxC+785AxWPKLose8xlFW+2UClg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QFlJQpLoXDfxxH5vI/D5/D9YNXjil7LQmlo9BVZ3SfLYbJe0yJLnejlPbOmRVPhay
	 ZlOyC1O4kke6d55uhtPGAEf9gfhDKY53JfpUQzVy7alBX9J8m6tx8DcAgj3kN1mDPl
	 iHzzVxDXMnzK7HQqyT1vQgumP+6BBjCJ868Lj8T5t/RcF2pUadjj0PWFAYWYm5L9sQ
	 tojYBo5u0S7eIuFdArqJ5Uh/rUKt2dgJV/hOtDuTtmgqruw0FvbofP5kcDtW/1hHYF
	 G579nNyC7Az0LcuRduPMe++lS7aFCKX0hHgrtJRcfbTz1Vqkb3FJgt7XKtbjOlkVS2
	 vVwpOIqsipOiQ==
From: SeongJae Park <sj@kernel.org>
To: JaeJoon Jung <rgbi3307@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	rgbi3307@nate.com
Subject: Re: [PATCH] mm/damon/core: modified control->repeat loop at the kdamond_call()
Date: Thu, 25 Dec 2025 12:00:50 -0800
Message-ID: <20251225200051.1069-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <CAHOvCC4dYGqY2pMQktBbO-NWKGE2XXeA1e+6BrP2QtsjM2Dodg@mail.gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 9906B40010
X-Stat-Signature: qujdgiciwjcexuhb7txq3sgmxm4xfo31
X-Rspam-User: 
X-HE-Tag: 1766692861-617943
X-HE-Meta: U2FsdGVkX19bELuTzNH153ShjqbU2kIgkaITmsERNoz1EWqzYrr7UYaW4oQl4Hv3USDsDMgr8ga1nrl1jgjEcR4HgZ5C19plVt3r0lcvWSiA5kcJDUanFBn3Gwhs+Tv/tHddn3rJ+46lbU7yqiHbuuL42IBa+eJhu1dIoX5GKePBVTd+BTTVkA3jpHAAyoJtc9KH3KdmB/qO3dLTUjNPan03aqzfR0aXT0dR1VakPUi56hKWqu3yUg9J7aYNT//fWP4oH2Pl6fOPSL31l5m8d5NmAGKmmArLyzUuO9+dQO+9Ho6YpVxydGZcVSSH1TwmFEVcqCJYFzmTg4ZrADtiCW2xbUMjBSCe8qmJUDP0cnh6IkF0lyUYRGcJ/gA7DmfJO1ESNa8O8g1BBY6Pbbdxgl0NF8OjpZTo360Wzib5g62g0qMpL47IjYIVdGCufokthMRxhcUs7Yy3ggrTPzYKGoTdF97cQ6hJreVafgDJdHCnYhX38E6NiZHxxCE+iXblXVC7AY56JEUaX4nXFqvuYabSTM2oiuPsHC/ah2UL/hFnRIR5y2dyTJ+xK5RZQIz6kTcLUyz7spUvs//D4XXHOP4x9Dr0/rbu6ipsikzY4k0UDAdx3DYeTX+EombwCCCwBQu/a6RJv4bh+9F3R1pmZIN4c0r+1FoeGJed2Rqy6ZxAkbLNJchORNNFBlIdXC7pxC/NVNZWTdBwQEyGG3S4PQkpEPxCB0uat0e1MRnO1oyk0zOx2eoSNWIqLH7YZ8ZJTKkJwukdRVHNdiqC5rmRiMMvyq0IpXUDeSRLxW5hF3Y8O120ichxvM1fP+7oIWc1mZRRScsc1rZPjVKqggkNYz2V7TPoj2AEn0PxJR8CQATdUooRHGJeo//441VnyDpaoPMYvtiluziiHmy0Qtd9MnEs7wherbB/vl3dmsIQsxKa63YRu61X0wYB+0xyHSAXo2BprRY4iNGbDEJGN3G
 b5OfOYCA
 nbmZaYHmrxyoC2/bb+oIGrDeqQ/I+0eHOxEe1qwoW8pEBOCDyEI8iFI83wtWRWvxNqf8FUBpKsGnQHZT25Ekuo7StU0c5oABXDVvQ7SHz+bNt4KnMGaBXl0fT94qkT4FLKm6689Y3vlrItfsn/lgVFZylw3CH4m38n/XdjPxQaTI2hD0d4E2TxHLTgmWYVh08MMwiPKuP9FKIYSOUg4I2axvageAMhN2uCXN8W7/7yN1NYXVNXC3XQhmQYtS+8OXMXxteO0s9x+ik75US0F7ZViLh5a7z1YqFKC8uUBQR5X30jR4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 25 Dec 2025 12:10:30 +0900 JaeJoon Jung <rgbi3307@gmail.com> wrote:

> On Thu, 25 Dec 2025 at 10:07, SeongJae Park <sj@kernel.org> wrote:
> >
> > On Wed, 24 Dec 2025 21:43:54 +0900 JaeJoon Jung <rgbi3307@gmail.com> wrote:
> >
> > > The kdamond_call() function is executed repeatedly in the kdamond_fn()
> > > kernel thread.  The kdamond_call() function is implemented as a while loop.
> > > Therefore, it is important to improve the list processing logic here to
> > > ensure faster execution of control->fn().
> >
> > That depends on how critical the performance is, and how much complexity the
> > optimization introduces.  I have no idea about if the performance of
> > kdamond_call() is really important.  If you have a realistic use case that
> > shows it, sharing it would be nice.
> 
> This is because kdamond_call() is called repeatedly in kdamond_fn().

Yes, it is repeatedly called.  But, my question is, does it impose overhead
that great enough to make a negative impact to the real world.

> 
> >
> > > For ease of explanation,
> > > the data structure names will be abbreviated as follows:
> > >
> > > damon_call_control.list: C.list
> > > ctx->call_controls: CTX.head
> > > repeat_controls: R.head
> > >
> > > the execution flow of the while loop of the kdamond_call() function,
> > >
> > > Before modification:
> > > Old while loop:
> > >
> > >         CTX.head <-----> C.list <-----> C.list <----> C.list
> > >         ^                   |                           |
> > >         |               if (C.repeat)            if (!C.repeat)
> > >    restore: only one        |                           |
> > >    list_add_tail()        list_del()                  list_del()
> > >         |                   |                           |
> > >         +                   |                       complete()
> > >         R.head <------ list_add()
> > >
> > > To process C.repeat above, we use an additional list, repeat_controls.
> >
> > Your above abbreviation didn't explain what C.repeat is.  Maybe you mean
> > 'damon_call_control.repeat'?
> 
> Yes, that's right.

Thank you for confirming.

> 
> >
> > > The process of adding C.list to repeat_controls and then restoring it back
> > > to CTX.head is complex and inefficient.
> >
> > I agree.
> >
> > > Furthermore, there's the problem
> > > of restoring only a single C.list to CTX.head.
> >
> > I had to take some time on understanding what this mean.  And it seems you are
> > working on an old version of the tree, and therefore saying about an issue that
> > already fixed by commit 592e5c5f8ec6 ("mm/damon/core: fix memory leak of repeat
> > mode damon_call_control objects").
> >
> > Please use mm-new as a baseline of DAMON patches, unless there are special
> > reasons.  If there are special reasons, please explicitly specify.
> 
> This patch is based on v6.19-rc2.
> I will continue to refer to mm-new and damon-new.
> 
> >
> > >
> > > Below, repeat_controls is removed and the existing CTX.head is modified to
> > > loop once(1st rotation).  This simplifies list processing and creates a
> > > more efficient structure.
> > >
> > > Modified while loop:
> > > Not used repeat_controls:
> > >
> > >         CTX.head <-----> C.list <-----> C.list <----> C.list <-------+
> > >                             |                           |            |
> > >                         if (C.repeat)            if (!C.repeat)      |
> > >                             |                           |            |
> > >                           list_del()                  list_del()     |
> > >                             |                           |            |
> > >                             |                       complete()       |
> > >                             |                                        |
> > >                           first --------> list_add_tail() -----------+
> > >
> > >         if (C.list == first) break;
> > >
> > > Signed-off-by: JaeJoon Jung <rgbi3307@gmail.com>
> > > ---
> > >  mm/damon/core.c | 37 +++++++++++++++++++------------------
> > >  1 file changed, 19 insertions(+), 18 deletions(-)
> > >
> > > diff --git a/mm/damon/core.c b/mm/damon/core.c
> > > index 824aa8f22db3..babad37719b6 100644
> > > --- a/mm/damon/core.c
> > > +++ b/mm/damon/core.c
> > > @@ -2554,42 +2554,43 @@ static void kdamond_usleep(unsigned long usecs)
> > >   */
> > >  static void kdamond_call(struct damon_ctx *ctx, bool cancel)
> > >  {
> > > -     struct damon_call_control *control;
> > > -     LIST_HEAD(repeat_controls);
> > > -     int ret = 0;
> > > +     struct damon_call_control *control, *first = NULL;
> > > +     unsigned int idx = 0;
> > >
> > >       while (true) {
> > >               mutex_lock(&ctx->call_controls_lock);
> > >               control = list_first_entry_or_null(&ctx->call_controls,
> > >                               struct damon_call_control, list);
> > >               mutex_unlock(&ctx->call_controls_lock);
> > > -             if (!control)
> > > +
> > > +             /* check control empty or 1st rotation */
> > > +             if (!control || control == first)
> > >                       break;
> > > -             if (cancel) {
> > > +
> > > +             if (++idx == 1)
> > > +                     first = control;
> > > +
> > > +             if (cancel)
> > >                       control->canceled = true;
> > > -             } else {
> > > -                     ret = control->fn(control->data);
> > > -                     control->return_code = ret;
> > > -             }
> > > +             else
> > > +                     control->return_code = control->fn(control->data);
> > > +
> > >               mutex_lock(&ctx->call_controls_lock);
> > >               list_del(&control->list);
> > >               mutex_unlock(&ctx->call_controls_lock);
> > > +
> > >               if (!control->repeat) {
> > > +                     /* run control->fn() one time */
> > >                       complete(&control->completion);
> > >               } else if (control->canceled && control->dealloc_on_cancel) {
> > >                       kfree(control);
> > > -                     continue;
> > >               } else {
> > > -                     list_add(&control->list, &repeat_controls);
> > > +                     /* to repeat next time */
> > > +                     mutex_lock(&ctx->call_controls_lock);
> > > +                     list_add_tail(&control->list, &ctx->call_controls);
> > > +                     mutex_unlock(&ctx->call_controls_lock);
> > >               }
> > >       }
> >
> > Let's suppose there are two damon_call_control objects on the
> > ctx->call_controls.  The first one has ->repeat unset, while the second one
> > has.  Then, it seems the 'break' condition will never met and therefore this
> > loop will never finished.  Am I missing something?
> 
> You misjudged.
> If (!C.repeat), it will be removed with list_del() and disappear.
> If (C.repeat) loops through the loop once, and when it returns to the
> first, it breaks.

Maybe my explanation was not enough.  Let me explain a bit in more detail.

In the scenario I mentioned, at the first iteration of the loop, 'first' will
be the first control object, which has ->repeat unset.  The object will be
removed from the list.  In the second iteration of the loop, it handles the
second object, which has ->repeat set.  The object is added to the list again.
In the third iteration, the loop runs for the second object again.  Because it
is not same to 'first', the 'break' statement is not reached.  The loop
continues forever.

Am I missing something?


Thanks,
SJ

[...]

