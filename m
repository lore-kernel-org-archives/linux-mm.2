Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1A29FC5DF94
	for <linux-mm@archiver.kernel.org>; Fri, 21 Aug 2026 23:43:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C7D026B0095; Fri, 21 Aug 2026 19:43:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C2DE36B009B; Fri, 21 Aug 2026 19:43:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B469B6B009D; Fri, 21 Aug 2026 19:43:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 90BC66B0095
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 19:43:27 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id F2C191A0296
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 23:43:26 +0000 (UTC)
X-FDA: 85126905612.21.5D5A262
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 48B521C0004
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 23:43:25 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gQhON7mO;
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787355805;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Rob2JksK7mVEytmz2auecaZEv9Vwn35NTkatzwt5/50=;
	b=KI3gC/tvnO2smj9w011qGzz8yNcB2dVz/FZQpd53QmU1mvgPLhh/skCi0uLoV9i9/FGOko
	ZsJANHEivmy/VHYVaf/6mrUp5b04P27+fPFOjyKb/qccO3WM48Bk9Dp1KP4zpOWBiuxLzP
	oIcYnfKraBcU5jrXGORuSrSaWeibW9U=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gQhON7mO;
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787355805;
	b=F6o40HkXWZsyxFZ6axZ6JnfYl0eYl5yHENT/U6RcwDDyVlt/yv/GQRi30iQRs7ZNYAMFo+
	Oqoe9bJNg9ozN8r5Hi90xF5vqAXM7DGS3O/ScoCiDRLNqdqvnb1mAWAKUvrIIFdI3EBRoV
	7NKxXrNeUsCLtXJqAkd505JXbVPmeJ8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1C11940BF6;
	Fri, 21 Aug 2026 23:43:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C05FA1F000E9;
	Fri, 21 Aug 2026 23:43:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787355804;
	bh=Rob2JksK7mVEytmz2auecaZEv9Vwn35NTkatzwt5/50=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gQhON7mOck6bYEWCFYCGT72y+meWundyrsOXq+jnfL0RrvexuBbf7AkKfej1ppTF6
	 iHwnv2lUJjA8xyfalqTxTp/xZxu8D8vzNLiXywjhqdGtNk1hBfPHPdDToDVeWILzu9
	 RAoy3zuHcAzs0SY1w9tv1nhOYFzcuoMxNBOs3amwZXDTlaWW0VRein7lyJWTZg8lBp
	 cTmuy3vavLOPIb4A8X9mjptypvgRQK22gsNUIeu4CD99+gTQz+L5RR1xO+hcOUnWI5
	 W8xIUQsS6ho9jemxuqrRNseAz5D46T4dm2rxIzKFLMs0i+4N9vvYtWPHqXFFQmILjV
	 uhaLKgZqhkuew==
From: SJ Park <sj@kernel.org>
To: Liew Rui Yan <aethernet65535@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	gutierrez.asier@huawei-partners.com,
	linux-mm@kvack.org
Subject: Re: [RFC/Discussion] mm/damon: Helping with alternative for watermarks
Date: Fri, 21 Aug 2026 16:43:18 -0700
Message-ID: <20260821234319.87475-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260821141654.203418-1-aethernet65535@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 48B521C0004
X-Stat-Signature: n4mgjpmpma5ubsn6puojfau4busfpaqb
X-Rspam-User: 
X-HE-Tag: 1787355805-348703
X-HE-Meta: U2FsdGVkX18VSnXnguiKuAtOe3y8LSNfMtWZc+04289ogvDXZebDfssc23I91BgTpvfwfW7shV54H/hDzmHcTRfC/dszb0MXlaHLtQyR78+vrvPYIIfSF28V+gwrVC8pK5xPigBBBkJNXo11LQla0LkVa9WHfE+T53Z9ZvNmr9bcdapuyMCiHAupVYj6TLd4xjImmw7IAertxavNQmWx2wXPH52/AFMlwPqEOeMKTfSW9L87OrTqZsgcaFCB09QJ55OImAEVmR1uwGb/uY9WOB/gbdQbDjbzD9jfqQNarV8irbOkjsxiooDd2/OMQb1TX8xxcVIQn75Qi54vuHc1vq8y2Q6SelfkRBLGuiZ+NwrnojGnJoNqtpbaOgFTwh+zAgip+XEjk8O9p+Bkq9zdhZeZZxizUJXzkjymg43uiodzlDsEFvnVi6wd9tUlgLe6ifLlDPERTkzJDAzSpuaZ5l/li0aOXmFGE9e1VnhlSdM5OlvDkwBXG2xkiHeAO+lpJxVCQyBVtlRs1YHSYK1YGQLeDLsrXSwVXG/W2QVG/lQMqDLtCs4P6VCqSDTZdd34iETewZnG+mqv6wdkTnNEjlMLslt7+Qaw+9Dndmqv7tTMiJmeDLN8jjnUGOCs6l2uOsvvSkhWCH7DaTTEPe2DtD3rZBBXt0TfnCykYdf16vC6XKpLE+o0+s6VIEYaU7JlH3xyf1K/Z527Q5zDKlUEsMIpXsu4MbpR7yCbdlj3PBMR/O1TLn78SHBWnRBsLVj1FWJvm+9mqswUrT3tEnkdVvP2XuNQMG+ULR+f0BKCZ9bZi3bn5t+oT1K4PBaNgdRCdUitHMDOm5ab+H6CpoTZ8Q6INzBsD0BPTD5Uf9dWxWBruAz+7RWyaQ6gV2pTyuqwwZxaw33xxQ62VD7AFvbsCv+1eJDShaUruTkWekR75ctrLa1fkCOrIOjJK/FRCTgwTquI6mX+cQLDo7a3Lkt
 GRDSlFDy
 pjLgwY/39BSNxK00IWJc2JWIIqN+fI9CHj4Qn3fe2Pks7+wsiO+x5B56E6aPZqMrzVfgtA+Pq1OcladgLRQ8UXBkMBSnw0axk8w1/BVcNUItLCRUgfMPZTRmJQyKwCTxEwW7KE7rwLo9f33Qz8gEje5VtF1hjD39qW/Qq/6x2cT32TLSdEoANHlMe6yFzt3trKzGMro6ym3ZadJf+Uk/o6rrNjq69kBAEURKQWv+76sxtSG/DMMG4bz+M+WXpsWXZnTlc
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 21 Aug 2026 22:16:54 +0800 Liew Rui Yan <aethernet65535@gmail.com> wrote:

> On Mon, 17 Aug 2026 06:57:42 -0700 SJ Park <sj@kernel.org> wrote:
> 
> > On Mon, 17 Aug 2026 16:39:23 +0800 Liew Rui Yan <aethernet65535@gmail.com> wrote:
> 
> > > 1. Why use Watermarks? And what was the problem?
> > > 
> > > I now understand why we do not need better Watermarks, so my answer is
> > > based on my previous thought.
> > > 
> > > I used Watermarks primarily because it is the only mechanism I know for
> > > stopping/running a Scheme.  The problem is it can only monitor MemFree.
> > 
> > Thank you for clarifying.  I'd like to go one step further.  What is the
> > initial problem?  Why you need the automatic proactive reclamation?  Do you
> > have some data showing the problem?
> 
> To be honest, I have not encountered any problems, and I do not have any
> rigorous data.  I simply using DAMON to try proactive reclamation, and
> see if it would cause any serious issues.  So far, it has not; it has
> almost no noticeable negative impact on daily use.

Thank you for clarifying.  Also appreciate your test of DAMON.  I'm curious if
you noticed any positive impact, too.

> 
> > 
> > > 
> > > 2. How exactly the page cache becomes a problem for you?
> > > 
> > > After prolonged computer use, the page cache can become full.
> > > DAMON_RECLAIM might then mistakenly assume there is slight memory
> > > pressure and reclaim those cached pages.  Unnecessary page cache
> > > reclamation can incur unnecessary overhead.
> > 
> > Thank you for sharing this.  I can theoretically understand the issue.  Maybe
> > you are concerned if page cache is too aggressively reclaimed and therefore if
> > file io becomes slow.  But I'm not really sure if it is only theoretical or
> > real.  Since the proactive reclamation reclaims coldest page first, and because
> > it works for not only page cache, the performance impact might not that big in
> > real.  Do you have some data showing the problem?
> 
> This is currently only theoretical.  I also think that the performance
> impact will likely be minimal.  I think adding a MemAvailable option
> provides certainty, if users know for sure that their devices will not
> lag when MemFree is low, but will when MemAvailable is low, then they
> can choose the option that best suits their device based on their own
> situation.

I understand it will allow users to tune the system for target MemAvaialble
value.  But, I fail at understanding what is the advantage of it, even in
theory.  It would be nice if we can have a clear example scenario that shows
advantage of MemAvailable based watermarks compared to MemFree based one.

> 
> However, since DAMOS Quota already supports checking current_value from
> user input, and I cannot yet prove whether this option can bring
> improvement in any workload, I think we can disregard whether to add
> this new option for now.
> 
> > 
> > > 
> > > 3. Has the MemAvailable based one solved your problem?
> > > 
> > > Yes, using MemAvailable as a watermarks/DAMOS Quota metric can avoid a
> > > lot of unnecessary memory reclamation.
> > 
> > Great to hear that.  I'm curious if you have some data showing the improvement.
> 
> While I do not have rigorous data to demonstrate any improvement yet, I
> appreciate your guidance on this.

I wouldn't say we can never add MemAvaialble based watermarks until we have
proving data.  But, I think we definitely need a clear theory to start a
discussion.

> 
> I will continue exploring DAMON on my end, and I might send out some
> patches later regarding a few logical issues I noticed in the code.

I'm looking forward to the patches!

> Thank you again for your time and answers.

Thank you, too!

> 
> Best regards,
> Rui Yan


Thanks,
SJ

