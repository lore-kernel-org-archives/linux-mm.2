Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 19804C61DD6
	for <linux-mm@archiver.kernel.org>; Fri,  4 Sep 2026 14:05:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 416666B0088; Fri,  4 Sep 2026 10:05:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3C7406B008A; Fri,  4 Sep 2026 10:05:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2DD4F6B008C; Fri,  4 Sep 2026 10:05:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0B48C6B0088
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 10:05:46 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8A4261615A5
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 14:05:45 +0000 (UTC)
X-FDA: 85176253050.25.77A5092
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id C8A3B120008
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 14:05:43 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="OI2bij6/";
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788530743;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cH8whGMhdnYHqnIKF2d9DpiGJu7/VAcxPYFKae9Iiys=;
	b=4qpbrveBviyAqrTtjQIrIk1D+o4F4Ekhkyabdj7QzPdZZFy+f0Aiy7hiCyLWOChG9fR5+w
	BcltP1CfWAxftyHmQ7jPPG9LUrSwb4uKlhTTozO3nJFdFO2BAi/oOfF7VggQEKc4ZPjhVB
	AnO2qpFCrtYwdHQgRONgojWQZH4TMbk=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="OI2bij6/";
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788530743;
	b=sYtH0kIWFWOwOMSCCWaDmU44vN4Yp9b6HmenERK87V/wTSGHUJxvQhzZH9xzQr8l4F3eGP
	kyAzRSrSyXkRV6eD/pxr1aHNkuWuK+fFzYv8BVZoX6k2TLVOXqby4vtDNixTR8kslmtmuk
	f0RkfTHMgLkQi7BVGKCi8GRw3lefgnk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C478F43C16;
	Fri,  4 Sep 2026 14:05:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 735391F00A3D;
	Fri,  4 Sep 2026 14:05:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788530742;
	bh=cH8whGMhdnYHqnIKF2d9DpiGJu7/VAcxPYFKae9Iiys=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OI2bij6/1gcvJdnYRwg/cyz3uX5kjSP1JBWwvg/oXy/cnjpoFRW38hy/3WXhp3E4o
	 gkDSe1ikvNbn5Gnnme5jcrXiUrZ3W5DnbItax3PtobpTXHHwQFIdaV/Uuf9JBIe2yR
	 Iq5xBRFb35PBpoNSsHJP5trJMLfxOxk/oov8YtbdqHIrWBii4jJH5kto7vcXuHNiDL
	 RD76wAeZ0GvM9OGlbqajgQUIs0QDpbugbIx8jb5TTRGqJkyd50ts9To+DFPI3QMRbE
	 e7vyzCcJUqcoKSNSsxRrcS2gUdWAN8TTV3omRwhjxdhpjtyUdMGM+oreQRMPQMN0VQ
	 6pXTR6o4uhmoQ==
From: SJ Park <sj@kernel.org>
To: Liew Rui Yan <aethernet65535@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	stable@vger.kernel.org
Subject: Re: [PATCH v2.1] mm/damon/core: fix false positive in damos_quota_is_full() when esz is zero
Date: Fri,  4 Sep 2026 07:05:35 -0700
Message-ID: <20260904140535.64833-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260904081324.3972-1-aethernet65535@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: jogbze5tw1zgao8s9m3rybhmk799nek5
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: C8A3B120008
X-Rspam-User: 
X-HE-Tag: 1788530743-129003
X-HE-Meta: U2FsdGVkX189KQh+enUbcFIuoWkkq49Rd4b8xJVih4mvwj+5tqOSZSnjqaYKio07t9NsUmEH1+sNXvTMz5JYUBPUYmdTErQgz0dR0TgRNTB0YqptSl6sbEwpAkczBU+XMJhcegW23yHpcW40uRaJOevm4BigeOd6GJC+AI9/riSIpMPbuX9fPJLmVVtI02CFV3PO7MVXa7SlFqqAq11chRi/s0ZkcM3hXuBmA9vVi+55GcvYA4VjNyNMEhebDYBZ66/X9+Q1ftVRt0WKEAtkdxQwItdxds7PbAvMViSgigCEn0vDyRMheEK5QXpbY7JsGauJ8eB7wmUiRYmSILV8Ym8k2QXe6qTyFEJB/KLUy2h74YlKmtwUWqui30nOuFp78U6pf1UStrsibCXerExaOUe2BlfsgLZnZZ+qDpsgv5sHtI/d3/XF9wUAN+baobYhgZW61/scich33iRci0nDsFnmjZVd1IJVAPX16zB5IZm98BKnjTpA8+lWfEwfjY24HbuPfzYjM0zzX0caaxoeUhUMM2ZIPg/qPV42sfOX8j9ShPqi8ZMoLYqRoZGemw54qcxjXEdljHCufUCCGsVgXrHiA4iPENtTCSoROI9mScx5e0uJSlez9D29Jyra+7hV3Un70ZG9QHJmu11anFeNWAeLX5ccD03XdqIEXYbPsy2/i4wvtFCuzm+FvjT8aQNsfm0L/bphHrFNpj4sKHZxqiuxs7VtA+CBZDtl4eCmp3viQQ+5szMIjpNkzS6kvEz8ykowZSEw/DQxkDPuiN6R8N65H96j4gDKFbnI+SnfFl2stwhHM1+fc2fyInDcTIa84drOA3nk8BB+q7ZRKWDIY0yVBDpgq3EAZMcKNBx6mhVTUO2vTb3GRRIzwoOYbN8wf3M4XxTfvgsa+jdKON2QZnxNOySJ2W+cwoAjc7YnPeuQ/UcBFcsIMEpGNVwa1TcaFWU7vkV5T2F0CP1YVns
 9DwP4UMR
 6k3CO3KVOsLiiwOn4U2Hib6pVyeMrmm5rKJFNxEIJ/WvdxLHqYJS7DqCsy7JE52vxQJd89J4BO26knNSQegsm3usm9/iln8qvwMcUOl5aWHSMCHg70l7s4fxxpIUB8PyvCADezOGQFYvaN5dpWrSgqfhHOby1P6U+VwEOc7giwQmlQABtnbi7lsvA8FcAQ+qUYX0JVX8u0yNlYkTwCEliIXq3U1i7HLlof+mc+FYNsRseH5kKl3ZDfvTktYFaon4KwGRvqCpJqoJTIiVgR9bJtH9w2Ati8pfmPst/XHotjdjjWOtMw8g7RtDhOg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri,  4 Sep 2026 16:07:41 +0800 Liew Rui Yan <aethernet65535@gmail.com> wrote:

> On Thu, 03 Sep 2026 07:05:20 -0700 SJ Park <sj@kernel.org> wrote:
> 
> > On Thu,  3 Sep 2026 20:41:48 +0800 Liew Rui Yan <aethernet65535@gmail.com> wrote:
> > 
> > > On Wed, 02 Sep 2026 17:33:50 -0700 SJ Park <sj@kernel.org> wrote:
> > > 
> > > > On Thu,  3 Sep 2026 06:31:38 +0800 Liew Rui Yan <aethernet65535@gmail.com> wrote:
> > [...]
> > > First, I would like to clarify my intention to avoid any
> > > misunderstanding.  My actual goal is to fix the semantic of the
> > > qt_exceeds statistic, rather than necessarily changing the underlying
> > > logic of damos_quota_is_full().
> > > 
> > > Currently, there is an issue with how qt_exceeds is incremented.  When
> > > the quota is set very small, qt_exceeds increases frequently.  This
> > > produces a statistical trend that looks almost identical to the
> > > continuous increments caused by the Temporal Goal being achieved.
> > > 
> > > The original intent of introducing qt_exceeds is to let users easily
> > > notice if the quota is too small.
> > > 
> > > Commit Messages [1]:
> > > 
> > >     mm/damon/schemes: account how many times quota limit has exceeded
> > > 
> > >     If the time/space quotas of a given DAMON-based operation scheme is too
> > >     small, the scheme could show unexpectedly slow progress.  However, there
> > >     is no good way to notice the case in runtime.  This commit extends the
> > >     DAMOS stat to provide how many times the quota limits exceeded so that
> > >     the users can easily notice the case and tune the scheme.
> > > 
> > > However, under the current behavior, users are forced to manually ignore
> > > or filter out the qt_exceeds increments that occur after the Temporal
> > > Goal is achieved.  This adds an unnecessary burden to the users and
> > > contradicts the core goal of making it "easy" for them to tune the
> > > scheme.
> > 
> > Still I feel the problem is unclear.  Why the users need to manually ignore or
> > filter out the increments under what situation?  Knowing specific and detailed
> > case would be helpful.  Are you or some people you know doing that and feeling
> > it is too much?  If so, what is the real use case?  For what purpose and how
> > DAMON is being used?  Why and how the ignorance of qt_exceeds is being done and
> > how painful it is?
> 
> First, I'd like to clarify that this isn't a problem encountered by a
> real user, it's just a scenario I came up with.

Thank you for clarifying this.

> 
> 1. Users sample qt_exceeds periodically (e.g., every 10 minutes).

What's the purpose of this sampling?

> 
> 2. Within this 10 minute sampling interval, the counter aggregates both
>    the real quota exhaustions and the increments caused by esz==0.
> 
> 3. When users notice a high qt_exceeds value, they eventually realize
>    (perhaps by reading the code or documentation) that it includes the
>    counts from the esz==0 state.
> 
> 4. To get the actual quota exhaustion statistics, the user is now forced
>    to perform additional testing and implement external filtering to
>    separate the esz==0 increments from the real exceeds.
> 
> Even if we explicitly state in the documentation that qt_exceeds
> includes the esz==0 counts, it still burdens the user.  The user still
> has to figure out how to filter out the esz==0 increments externally to
> get the signal they actually care about.

Users set the temporal goal.  They can know when the goal is achieved since
most of the goal metrics are already exposed to user space.  Users can also
show the current effective quotas.  I agree that can be cumbersome, but how
problematic it is?  Also, as I asked above, why they want to do this after all?

> 
> Honestly, I struggle to imagine any valid use case where a user would
> actually rely on the qt_exceeds increments caused by esz==0 to make
> decisions.
> 
> If the only purpose of qt_exceeds is to let users "easily notice" if the
> quota is too small,

I agree it could be a signal to show if the quota is too small.  But the real
purpose of qt_exceeds is, in my opinion, letting users understand how DAMOS is
internally working now.  After all, how much quota means if it is too small or
not?  That all depends on the real use case and complicated things including
their SLO etc.

If documentation is saying the purpose of qt_exceeds is to show if the quota is
too small, that is what need to be updated.

> forcing them to manually filter out the noise
> defeats that purpose.

So, I don't agree.


Thanks,
SJ

[...]

