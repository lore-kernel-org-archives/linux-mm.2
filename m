Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2B43DF3ED50
	for <linux-mm@archiver.kernel.org>; Sat, 11 Apr 2026 18:48:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 659E86B0089; Sat, 11 Apr 2026 14:48:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 60ABE6B008A; Sat, 11 Apr 2026 14:48:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 520B16B0092; Sat, 11 Apr 2026 14:48:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 410586B0089
	for <linux-mm@kvack.org>; Sat, 11 Apr 2026 14:48:09 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D838F1607A3
	for <linux-mm@kvack.org>; Sat, 11 Apr 2026 18:48:08 +0000 (UTC)
X-FDA: 84647159856.20.AC13987
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 12B89180006
	for <linux-mm@kvack.org>; Sat, 11 Apr 2026 18:48:06 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Jg4KsdLo;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775933287; a=rsa-sha256;
	cv=none;
	b=mOC25NsuBTYglaVRphvFY7mj4Wv305vmoKtEM2352s6Cpvyh0qhoh3cClDQpSltPsueBo0
	MvNrb742fX7Qg+3ktBsM2I/4PvpN/MGUxspaLyvE3uMPimb8WIgnHZnIoIkGxfh8GYQ9PG
	JqlTgEWsYK4Iy/+WyfXC9xhum/fdmAE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775933287;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KqIi1iuo2fdqra1lkUA7izhaNs7t5HkT0XD3gsjPaw4=;
	b=e05CmYdTS4DLl0JYTSkYWExUf1u0Sn5+h84dD/TMqGRkdx2e+ZsUqLN11gdke/sk12qSHo
	d3UTBJefDfQFXE1YOSm6RuA7HtfZlj0MVULmIJXwp+yUgpMWgRn+f5dQ7J2vsACEpoNj/5
	rPI38zXjFaxNYP++yfbOojCCv9IVHZQ=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Jg4KsdLo;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id F2EBE435F9;
	Sat, 11 Apr 2026 18:48:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40770C2BCAF;
	Sat, 11 Apr 2026 18:48:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775933285;
	bh=ApQFbfhxdpo9X8/dqtaLx7tR7B3PkGbN7AFvpjwRHTM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Jg4KsdLosaYZ38/xLC7BatDejmVpM2au1eaG/RqiXeSDDFDSrMmm1YZ5RiRUsfhZY
	 T35gc6vhngU9cdWg0/z6tqgO7dCzHfKQFa0O77kMEs1efQJqw7pcva/1ycYx15L05X
	 JEZFUsaueFS5uxtR7LcakzHtfybB61GQ3e0EthNWbAr+JYJHgT2M2uF8Xmog4ZUYFh
	 aMWHEMhOvmEeBx5LE+5Nw0H+DzUjsP8bl1QFbe2zSgQLWE0b6Z1FsB0nKxeDQK4CkE
	 KlAdMmop84FEXC8NGBL0dIXWYcQJQF0QZQgYNMhLjErjAqxjXEyxIRn+7XJ738zl+K
	 FkOdaJH+ZOVsQ==
From: SeongJae Park <sj@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	David Hildenbrand <david@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: (sashiko review) [PATCH] Docs/mm/damon/maintainer-profile: add AI review usage guideline
Date: Sat, 11 Apr 2026 11:48:01 -0700
Message-ID: <20260411184802.81804-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260411174906.79491-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 12B89180006
X-Stat-Signature: ym6sezposguydnteos3nzj84qzr6x1xa
X-HE-Tag: 1775933286-846784
X-HE-Meta: U2FsdGVkX19FEQW1My4+2l30i2d1R++2GqwRPdNAM/J+H5fvVBqr1OhmrJWGFD1OTKn02OBSDLo52IYl4M2gVzoWobUXIBcst3P5AmLcw9jlS7OwQeYVVtdkGsXvTD9dWoISbzYcafM6E2phD306cvS1G3VcHFuaR7AINtccaeIC5EKO5/cakHBgb3Fmotoyv8G0qOgsEEoBvd6frr/s8nu3G1hC/T/V8PD8j+5osKFasoXU42gtuwIJATlILYXRIOmh3tojjqir/myyCxRoyE00l7USIypMUYk9uCSc5P8wSiqFx0fDMgvjpch5lgVypIFRNYEdV5oj+0DGBMnPzqWNbAIE6/X1p2Fuy6DTH6HswWQv649A3p7kp7Gd4wE57IVoWkTmPYRGWeqvq6jat2hRmA+ad5C2EDUrhAXVrw3vP7Ndue4dUoS76XYDw6Xzcns3eO3cY/ZhF2zK/975DzNjz4Ro21YRqgd0kKFPradaHTpzJe1du5r6icH3Gr3HE41VLQUQdJzN+zZLMQ2gL+rUOv5lj5VccPfFD5oGNEwjPBYOdhBwrhMIDlqiioRM7ex2k4uUACW2ujvZqy+by3tCgImkF/KCtjf0DoPNlb8uQl/M7BE7iwvmfb/aGTma4rnTvnWs1oA4be0HcGpaDIv8qOL+JbkDwU4ElZw8fIvfnSXcu0B3Oa9Z3u3W2ZAflUL7EWKMFj3LvGIPeTYIXo+UEzhY+hEK+VXDaHxnMzxNb+KCD495SQemLriseUJ94J0e2eg9bbixJh679fvgsxSpf4Bo2cItVVoX4IIuZ6KDnL0xJu2jxdOhQ3KKJ6cJTZAJmfVHqqJ84GYSA6AdrsAyDr/K3TFwnmTreGzsa4v7yogjC00uYAEQ/LyXreMoTA0wi8MTrLyPtmlTYNwLaeJpdDifPew9SLGIFViIBHliK31Toe1D5kbmyZ2X0081sDhUwtsMhpBFEuxT7Zy
 6rExOhiF
 14wKMztkl+EXPasRvbkhXIhZnc6UVHQeu7Sfhq8X6Dh8k+Bma7GxiezrcB5rL8FlSgJpmxNmcHFjNQLeg0q0PkRBUn2m1Yx/v3ZD4hf0HO1jx6C7gtlcVLdF+aYJyJDvooS5Ver24Rmj/zeObxmu0Mg4Sau9JldH3PT/fzOW307Jr6Xptb/IrlS5HoCJQOdFR4GubymDMcYW+niq2U7eonxPUtCF5vJQ1NgMJ5zNEQe0TtgLt7iekLsBq5QMynzwHGnUHQp8TxWw5TfEa6vmo27DVd/ovQhuqO5yA6f3tFDtxwGMDi44USqb2+D++kzpggZxRtZJaxEiLm1TnFYGnVPoAV/Bplslmz63yn+VjzXvEs1diW4ahq1WCKnoxQf7+xzYRm8Gaxa73RxpPhqxeC0ZMJUz0Oy1unHAdgiEyblF4RMLJRXo+nHA0/ul20GIIj/maWIIm2615NJ4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

# sashiko review suggestions
#
# 1. Consider reducing recipients.  Maybe the author,
#    maintainers, reviewers, and mailing list of the
#    direct subsystem and parent susystem mailing lists
#    could be a starting point.
# 2. Add short summary of your opinion at the beginning.
#    For example:
#
#      TL;DR: sashiko found an issue.  I will respin.
#      TL;DR: sashiko found no issue on this patch.
#
# Please DON'T FORGET removing this comment block before
# sending this!

Forwarding full sashiko review in a reply format with my 
inline comments below, for sharing details of my view and
doing followup discussions via mails if needed.

> # review url: https://sashiko.dev/#/patchset/20260411174906.79491-1-sj@kernel.org
> # start of sashiko.dev inline review
> commit eaf13e650de39668ddb68467088d425fa3e8be04
> Author: SeongJae Park <sj@kernel.org>
> 
> Docs/mm/damon/maintainer-profile: add AI review usage guideline
> 
> This commit clarifies how the DAMON maintainer profile uses sashiko.dev for
> AI patch scanning and email delivery. It adds a new AI Review section
> explaining how patch authors can check reviews and share their opinions.
> 
> > diff --git a/Documentation/mm/damon/maintainer-profile.rst b/Documentation/mm/damon/maintainer-profile.rst
> > index bcb9798a27a86..5c23b1281c50c 100644
> > --- a/Documentation/mm/damon/maintainer-profile.rst
> > +++ b/Documentation/mm/damon/maintainer-profile.rst
> > @@ -100,3 +100,24 @@ There is also a public Google `calendar
> >  <https://calendar.google.com/calendar/u/0?cid=ZDIwOTA4YTMxNjc2MDQ3NTIyMmUzYTM5ZmQyM2U4NDA0ZGIwZjBiYmJlZGQxNDM0MmY4ZTRjOTE0NjdhZDRiY0Bncm91cC5jYWxlbmRhci5nb29nbGUuY29t>`_
> >  that has the events.  Anyone can subscribe to it.  DAMON maintainer will also
> >  provide periodic reminders to the mailing list (damon@lists.linux.dev).
> > +
> > +AI Review
> > +---------
> > +
> > +For patches that are publicly posted to DAMON mailing list
> > +(damon@lists.linux.dev), AI reviews of the patches will be available at
> > +sashiko.dev.  The reviews could also be sent as mails to the author of the
> > +patch.
> > +
> > +Patch authors are encouraged to check the AI reviews and share their opinions.
> > +The sharing could be done as a reply to the mail thread.  Consider reducing the
> > +recipients list for such sharing, since some people are not really interested
> > +in AI reviews.  As a rule of thumb, drop individuals except DAMON maintainer
> > +and stable@vger.kernel.org from the recipients list.
> 
> Is stable@vger.kernel.org the correct mailing list to keep here?
> 
> The stable mailing list is exclusively for stable kernel backports. Sending
> ongoing patch AI review discussions to that list could result in spamming it.
> Should this perhaps be damon@lists.linux.dev instead?

I mean, drop individuals except DAMON maintainer, and also drop stable@.  I
will wordsmith like below:

'''
--- a/Documentation/mm/damon/maintainer-profile.rst
+++ b/Documentation/mm/damon/maintainer-profile.rst
@@ -112,8 +112,8 @@ patch.
 Patch authors are encouraged to check the AI reviews and share their opinions.
 The sharing could be done as a reply to the mail thread.  Consider reducing the
 recipients list for such sharing, since some people are not really interested
-in AI reviews.  As a rule of thumb, drop individuals except DAMON maintainer
-and stable@vger.kernel.org from the recipients list.
+in AI reviews.  As a rule of thumb, drop stable@vger.kernel.org and individuals
+except DAMON maintainer.

 `hkml` also provides a `feature
 <https://github.com/sjp38/hackermail/blob/master/USAGE.md#forwarding-sashikodev-statuscomments-to-mailing-list>`_
'''

> 
> > +
> > +`hkml` also provides a `feature
> > +<https://github.com/sjp38/hackermail/blob/master/USAGE.md#forwarding-sashikodev-statuscomments-to-mailing-list>`_
> > +for such sharing.  Please feel free to use the feature.
> > +
> > +It is only a non-mandastory recommendation.  DAMON maintainer could also ask
> 
> This isn't a bug, but there's a typo (non-mandastory) here. It should be
> non-mandatory.

Good eye.  Randy also found [1] this and I already promised to fix.  Sashiko is
better than google doc [2]!

> 
> > +any question about the AI reviews, though.
> 
> 
> # end of sashiko.dev inline review
> # review url: https://sashiko.dev/#/patchset/20260411174906.79491-1-sj@kernel.org

[1] https://lore.kernel.org/20aa1471-5257-4913-ae46-7b40ca0aa128@infradead.org
[2] https://lore.kernel.org/20260411183029.81030-1-sj@kernel.org


Thanks,
SJ

# hkml [1] generated a draft of this mail.  You can regenerate
# this using below command:
#
#     hkml patch sashiko_dev --for_forwarding \
#             20260411174906.79491-1-sj@kernel.org
#
# [1] https://github.com/sjp38/hackermail

