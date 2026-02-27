Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 97570FD9E29
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 02:04:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CBB8E6B0005; Thu, 26 Feb 2026 21:04:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C68CC6B0088; Thu, 26 Feb 2026 21:04:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B67AE6B0089; Thu, 26 Feb 2026 21:04:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9E22B6B0005
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 21:04:48 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 431201C34D
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 02:04:48 +0000 (UTC)
X-FDA: 84488593056.23.B340D0E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 6A1A14000F
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 02:04:46 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CMU1AWey;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772157886;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+AC39pUuq5AMWzYJZrR76LFk2UkETHSnoASsTj8MW7U=;
	b=gL/grvc9ZtHh/frEzbXQR59EGL3ml0th65H+GuHsKFqsVnDmG/SwimgZvwioqeAu+5JZ7R
	PX3sXAA0clJ6uQRLO4AGqEOdQQwN1pRowyjIhCrP8d27QzdEFQiMY3yFbtKOOQRNbo+u/g
	m2ERffVt0ZY+gfdU6NVuLTNRiG0ywqc=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CMU1AWey;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772157886; a=rsa-sha256;
	cv=none;
	b=r29wuNmCIPLr5gTQY58kCM7N8gbl3xUeFZeTWhRHk0Zv++sLzopUtAZEwA5qzltd2Fp7b6
	KuB5sv7gZWXV9zlMSYmHNemHoOe4GUctL7NriXgfhbQ8sZEnFxUhb+rD8ThjRnvKzSMjN0
	1lbrr/pXV8RuT7K+RZYe9dUt8j+084E=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 78AC043F2D;
	Fri, 27 Feb 2026 02:04:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09449C116C6;
	Fri, 27 Feb 2026 02:04:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772157885;
	bh=E21v8cysKSwly9dK9dIK3fxUVDPj0v2xjJ3Mf3w+4+w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CMU1AWeyRFfOGqc+ZHYBu7GVyFc/gjhYGkGUKhA9pTLz0Dfh6UrfNmX7odfzJBQXY
	 x8QmvWP/ufWXiPlOUO3yTTAS3ZueAm1Kp2GUn7SwBz4yT7IUtLVftTU24Rxfzkx7rc
	 TR0YgHb1/TIaT6Fy2LBX60KAI6E7ajDSCDqO/lo1BqVKnef9R2EicaotuaTVHfenr0
	 UGK6vTqq/r5rHjlSEIfD1j9Y7TSdLqLVz4phYu7Di2B7wt2Kclo78nzbDue3avc7k2
	 GVg4P5dMUVyKkO0PVCCczZAzvkYS9O5W0YTrUsB9zJUBgZWpyPEBWL6/biXnpCn9NA
	 GbnbA77LL/hJg==
From: SeongJae Park <sj@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: Ravi Jonnalagadda <ravis.opensrc@gmail.com>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	akpm@linux-foundation.org,
	corbet@lwn.net,
	bijan311@gmail.com,
	ajayjoshi@micron.com,
	honggyu.kim@sk.com,
	yunjeong.mun@sk.com
Subject: Re: [RFC PATCH v3 1/4] mm/damon/sysfs: set goal_tuner after scheme creation
Date: Thu, 26 Feb 2026 18:04:42 -0800
Message-ID: <20260227020443.91984-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260226005350.7612-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 6A1A14000F
X-Stat-Signature: tawsgssmt4gt5jz38wm9num3hybpdhe9
X-HE-Tag: 1772157886-480159
X-HE-Meta: U2FsdGVkX195C9NDLcrUReTCT4U0GXLnw3IpFBdHAvtZX7stF0JBSlogFxl7qbmZAabkQI1yrwok5r08uMykQO1qcj0BdEaoGBXdtxXfrHXrVuV6Ol7biV45gRtyq/5ib7SO/lBHmxdDbf/9WG17D/aWXjcpF6B2RSqA9aKYJvnWqyRyKdqmknj8Nsea+g+k4JN8zrTABtbKv4ed0BpJHb5sZU3PhUoCBJrsFe2kMf7jUvBcHCt9Gl6HmlQbFwI8ZGoXp+PbxhOK1r1MdcdAN8+PEQ29Z7ivWIh5y3mXC5VPWC5JCXU5a5KpnNlXb1WYrXDDpeK2n77/+/WiYYEysUXIEdcieAOJI33boZvxIPl7uIh8Pv4wsbmr+EpiPFXivS9hXW0U9jTvT+VFO/HNY2u/PhbUsHoS7fdTWfKGHestcU2mzM7hJTNt93b7M4I+MyFxrOADdqbiNsr6LLS2ajQ1WBq3NxNHWmLeQoHdo2IJDAPdZn/vuEXbNUpAT2uJ9ZOXZdu01FjyXVNxVsACVd5PUnD7hndm8/nn3aYo9Gq2Rh+7CbJOIrKRaJPVe7ljdVOkxa49bu7jliNhBINjbIZbjsiIg3/cx24vs0ad5qdkdaQQSQcbiHP4KVFc7/E5GX3sCV+30touI9kFxbmnE0Gj5wVMXHylnK/h5xLHCqR5bLupriCIq+X3SXrFdRwB2S/uOTP6PpC36gVwAuMPzM/fl55QxIuf4bPfN/qs3ePmjQyxupnofYuZgTPrnpEyX5s2ZlyuEyxM+tJpYuz+/8L7X1T+P+L7It5XO4RLJV9qLaqgAuDxujhR8XUmjgXmjPKe40tr10dnbGvEyQIpb/fs3jmOucWB6FGDFjN3IafO9HU1UcndORUOOaT/DkvuIDIJmEptS+2qkqZsz5eCF96sYLtMFKNeMRqYX0p3JQriFG1r+/9HeZ0gw+GXPTlf0g8NlZJRsha5gWzJmmp
 oYYrCaD/
 SuCTI7F/RaS2JgHUeB0kW3T5PLOJDAISAx2JRa9ARo0bzQ60Xckg7n8UHG0skfAbVC+2z6TRNNMos9sHo86HSysK/VUzSu0yCod20DWTaz7z7bWKR7QrRxI9H3B34avJLtQEaIzFN2qj7cC5zXmVz4LtuAndq7pj1ebmQJ8Qnjq8r5yon4jYQPoqzwOhHPiNvwgzGXddqolJ5mcMdlboyHZehMQSaQHl/LfFD6u3Djq1uTp/78XSge1le//XXxkHWO6klAUldkGxI8/Obkqs1rGkuDden7Ecsh0d866dkXXwdiUWL7hoUHAirSw0abQKJA4+uIn17i8zWKbRaGZdmvJEG3RBz9pJIxtyHijEuAVGIxfh/JHqcnG9gx9Fc6b4fVy6u0IL29r4f8R/VhIo2JoDlzzXB2kBX03Fw
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 25 Feb 2026 16:53:48 -0800 SeongJae Park <sj@kernel.org> wrote:

> On Wed, 25 Feb 2026 10:23:09 -0800 Ravi Jonnalagadda <ravis.opensrc@gmail.com> wrote:
> 
> > On Mon, Feb 23, 2026 at 5:40 PM SeongJae Park <sj@kernel.org> wrote:
> > >
> > > On Mon, 23 Feb 2026 12:32:29 +0000 Ravi Jonnalagadda <ravis.opensrc@gmail.com> wrote:
> > >
> > > > damon_new_scheme() always sets quota.goal_tuner to CONSIST (the default)
> > > > regardless of what was passed in the quota struct. This caused the sysfs
> > > > goal_tuner setting to be ignored.
> > > >
> > > > The comment in damon_new_scheme() says "quota.goals and .goal_tuner
> > > > should be separately set by caller", but the sysfs code wasn't doing
> > > > this. Add explicit assignment of goal_tuner after damon_new_scheme()
> > > > returns to properly apply the user's setting.
> > > >
> > > > Without this fix, setting goal_tuner to "temporal" via sysfs has no
> > > > effect - the scheme always uses the CONSIST (feed loop) tuner, causing
> > > > overshoot when the goal is reached instead of immediate stop.
> > >
> > > Thank you for catching this, Ravi!  So, this is a fix for the RFC patch series
> > > [1] that not yet merged, right?  I think this fix is better to be carried with
> > > the series, and squashed into the broken commit to not introduce unnecessary
> > > regression.
> > >
> > > So, if you don't mind, I will squash this into the sysfs-schemes part change on
> > > my tree, with your Co-developed-by: tag.
> > 
> > Yes. Please go ahead and squash it into your series.
> > 
> > >
> > > [1] https://lore.kernel.org/20260212062314.69961-1-sj@kernel.org
> > > [2] https://lore.kernel.org/20260212062314.69961-4-sj@kernel.org
> > >
> > > >
> > > > Signed-off-by: Ravi Jonnalagadda <ravis.opensrc@gmail.com>
> > >
> > > Reviewed-by: SeongJae Park <sj@kernel.org>
> > >
> > > > ---
> > > >  mm/damon/sysfs-schemes.c | 3 +++
> > > >  1 file changed, 3 insertions(+)
> > > >
> > > > diff --git a/mm/damon/sysfs-schemes.c b/mm/damon/sysfs-schemes.c
> > > > index bbea908074bb..fe2e3b2db9e1 100644
> > > > --- a/mm/damon/sysfs-schemes.c
> > > > +++ b/mm/damon/sysfs-schemes.c
> > > > @@ -2809,6 +2809,9 @@ static struct damos *damon_sysfs_mk_scheme(
> > > >       if (!scheme)
> > > >               return NULL;
> > > >
> > > > +     /* Set goal_tuner after damon_new_scheme() as it defaults to CONSIST */
> > > > +     scheme->quota.goal_tuner = sysfs_quotas->goal_tuner;
> > > > +
> > > >       err = damos_sysfs_add_quota_score(sysfs_quotas->goals, &scheme->quota);
> > > >       if (err) {
> > > >               damon_destroy_scheme(scheme);
> > >
> > > To follow the order on the comment ("quota.goals and .goal_tuner should be
> > > separately set by caller"), I'd prefer setting the goal_tuner after
> > > damos_sysfs_add_quota_Score() call here, if you don't mind.  Let me know if you
> > > prefer keeping the current order.  If not, I will just make the change when I
> > > apply this to damon/next.
> > >
> > 
> > Agreed. Please make that change when you apply it.
> 
> Thank you, I will do!

I now think it is better to just remove the damon_new_scheme() internal
initialization.  I added the detail [1] to the original thread.  I'll keep your
Co-developed-by: tag with the new fix though, unless you mind.  Let's keep
discussing there if you have more opinions.

[1] https://lore.kernel.org/20260227015613.91346-1-sj@kernel.org


Thanks,
SJ

[...]

