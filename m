Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4271CCA0EED
	for <linux-mm@archiver.kernel.org>; Thu, 21 Aug 2025 02:54:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 83E458E001E; Wed, 20 Aug 2025 22:54:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7EFB28E0002; Wed, 20 Aug 2025 22:54:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 72E418E001E; Wed, 20 Aug 2025 22:54:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 6098E8E0002
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 22:54:29 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D2FAF8271D
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 02:54:28 +0000 (UTC)
X-FDA: 83799246216.10.F81F2AD
Received: from nyc.source.kernel.org (nyc.source.kernel.org [147.75.193.91])
	by imf25.hostedemail.com (Postfix) with ESMTP id 3735DA0009
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 02:54:27 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gEsqq8BG;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755744867;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0dC90YDZSpJGLiTYkFY6h70+p/yLcbjioipzWBZndh8=;
	b=4J5fmyBkmEtctg9Q1dfTIZWcu/APQE9nbGVqZTvKpRFlrAMLB9lhPjTqGIvHXyEefNYJ7K
	ApvUmEvQIbXtGlmFouPk/LruQqBoRKgsXSLsQeM2dsp/jFNFn8H5cnv2W/AVtb27NruBEN
	SpXyUgRcjXv+WpZz0k8Khuybg4fpolU=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gEsqq8BG;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755744867; a=rsa-sha256;
	cv=none;
	b=duDAqM/ZcqIxqvVqOwKhKr+XICHe9okuZ/P1RlbbUa1gp8OCmOtisJgx6JHV5Fkw4Gxwco
	TA46nRJrt7DPfyreosE6uLI5rSPgFaJPtZixPP8IqEOEQ/ABIz7wdCa03ykkwFJbGz1+ET
	iL8DW7msNMDYikYu9nE0TFAhSskm2S0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by nyc.source.kernel.org (Postfix) with ESMTP id 87F49A4AE99;
	Thu, 21 Aug 2025 02:54:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D86EC4CEE7;
	Thu, 21 Aug 2025 02:54:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755744866;
	bh=P/5DA2YXUnnCAFwd9glDmvY4JJh67YYsK3KUN4QtTFA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gEsqq8BG/DgPqtk+i+MUuoKFnLMBzvPIGS+eX3liXI0zEKyE+EwBb7kc8qDtp6+TZ
	 TphawouewPsfO+JYyZtIfRKk2uZECRPkY35xd2GNLo+gnzHqj+BXJ6CHk6U/D4BSbl
	 ymMIZQOlKTmaSI330015H1ZGnMAe7eMqNSdlA8DvXlxQyXHx4kOzx6QHinfYSL2vkx
	 RCOF0LIpSb5dO9oNvluZFk0/YPlfmWm6C9HYL5youDHjNCN/6wZOOx+lh9FxOLAdLN
	 mqcZtXTic9K+Ka2CQza54k5YBP8Rv3dCEKLPB/r6qevkZmgbKqhDD0oARSx5fGJJru
	 CMuPgNDBMfPGQ==
From: SeongJae Park <sj@kernel.org>
To: Sang-Heon Jeon <ekffu200098@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	honggyu.kim@sk.com,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	stable@vger.kernel.org
Subject: Re: [PATCH v2] mm/damon/core: set quota->charged_from to jiffies at first charge window
Date: Wed, 20 Aug 2025 19:54:23 -0700
Message-Id: <20250821025423.90825-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <CABFDxMGmVgswVoZFgBz=7xqA59M7fMt0jw2QHqWjm-W9tZktWg@mail.gmail.com>
References: 
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: p6fngnxpzr15f6hspb1z3j6e8uz66ra1
X-Rspam-User: 
X-Rspamd-Queue-Id: 3735DA0009
X-Rspamd-Server: rspam01
X-HE-Tag: 1755744867-502903
X-HE-Meta: U2FsdGVkX1/6tyiU3nbMwF3IPgn1Pszjn/Ar9oFRRKLVsbK/okLGAIhiQd186RQnlZP60aQdORhfFVnrzjxDd9GxufAbu4ZTGzlJ/MBkqRptN0wLdr7ih0P6fs5rrsUM4/CUYHQ4ego5jgNbhEH0B6OWqac/y2hyiiiwFKTeH8T7AMuvnY+zngaZ5+h9ApSPsXIv2eKx/PBC4Z0QSpkd9o/Vnwq8WHXLMugc9Rwt/d9whLDCuN77ITPsPGBTckBjokjVJxG7LrTkRkn9u7meWm5Bk3QIDDs5wwHqHycTfCCK+pkBEeMv1fxvMPq5su431gOxADL9X9qRTxnNLVKF/R24ySPc9KX5OjaTXcR2Pbr53AI+9u59JhugYXKrh7rzateuYc4LI6aKnftFVsYXC+agORIUSb8FaabnQ8fZ22tFOquMcod1RZ0CUm4iA8/gOicd8Tjy3lscE8CdqJklQQmhPCIMsJw9pEdt73l4nYTHC6YLqq+KWOi49pueK+lZ/Tho/o6FldcRRwciGYuxDUXSKJmicDUND7CZmHkiX1mBGH3C1IJYkbHsTOM7GIxjHFIaIhqfsvOGdgiBdPKMmBTVVJJkVyjqvPOgg2tQQcXmfdQhyiJHB9fZ/oMrHKJhd/ljvss2H2QWUOR7kFVx+w13Uheb7PUetS3SUSSyYxWwUUsC3BkWdRdNetn3bXWJEh1sktVZy0LR6G57oJyItHDI7ejyzo6/4o1CN6q9uYea42XvP0xl6ucxJd7E7NeLGJf3A14u2ww5hfQmmJxzTJT7XgzWbHfgRMJUMsBFjmq8jwJkbb5DwHdj9uy8GSKyNa626iz/V2G4AN0GSHS2HbDLbHYTq7qf/N+ltiB6FSoLwclWSorOzDV0xamNQHQLufwqHcy0f7jETCMYMxzgKMOImh1qfjrvnEsD7MurPCpiV+YQS1FaaUv+eSahm4d+sXIjFLyKqfRl39iRfIk
 uRsINISw
 XSfcv01roX9O/WyG6jWkWADjYcMJMl9bP9vCRFX74FEL4F8R9byUaqCLhcjq3CUf1Uw9VMAgqZ3IsxBUN9k3wPrapW0ti4/VJu0R0qw3hQ3x1mKHP/bM18H2JVUHeRqyhzfW3/nLE4NcRC1pJ+eVpQj9CBr2EpZzDNSv8bqH7bYsTP2PYU4uhwdqry5IfJ3JG7Mah1G/fpytYqg/iEVacH5tR7m7yURnaPlRCQV7n4WY7OK09tmTRmgLwlqPkxUKZl6rtTsTbwiSawysKHfD4SJNKl+6mvjS3GjnL2FZ728Abfop/bL+wpp09FKYd9KlanVP3u19DxU58X0o=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 21 Aug 2025 10:08:03 +0900 Sang-Heon Jeon <ekffu200098@gmail.com> wrote:

> On Thu, Aug 21, 2025 at 3:27 AM SeongJae Park <sj@kernel.org> wrote:
> >
> > On Wed, 20 Aug 2025 22:18:53 +0900 Sang-Heon Jeon <ekffu200098@gmail.com> wrote:
> >
> > > Hello, SeongJae
> > >
> > > On Wed, Aug 20, 2025 at 2:27 AM SeongJae Park <sj@kernel.org> wrote:
> > > >
> > > > On Wed, 20 Aug 2025 00:01:23 +0900 Sang-Heon Jeon <ekffu200098@gmail.com> wrote:
[...]
> I think that I checked about user impact already but it should be
> insufficient. As you said, I should discuss it first. Anyway, the
> whole thing is my mistake. I'm really so sorry.

Everyone makes mistakes.  You don't need to apologize.

> 
> So, Would it be better to send an RFC patch even now, instead of
> asking on this email thread? (I'll make next v3 patch with RFC tag,
> it's not question of v3 direction and just about remained question on
> this email thread)

If you unsure something and there is no reason to send a patch without a
discussion for the point, please discuss first.  To be honest I don't
understand the above question at all.

> 
> > >
> > > In the logic before this patch is applied, I think
> > > time_after_eq(jiffies, ...) should only evaluate to false when the MSB
> > > of jiffies is 1 and charged_from is 0. because if charging has
> > > occurred, it changes charge_from to jiffies at that time.
> >
> > It is not the only case that time_after_eq() can be evaluated to false.  Maybe
> > you're saying only about the just-after-boot running case?  If so, please
> > clarify.  You and I know the context, but others may not.  I hope the commit
> > message be nicer for them.
> 
> I think it is not just-after-boot running case also whole and only
> case, because charging changes charged_from to jiffies. if it is not
> the only case, could you please describe the specific case?

I don't understand the first sentence.  But...

I mean, time_after_eq() can return false for many cases including just when the
time is before.  Suppose a case that the first and the second arguments are,
say, 5000 and 7000.

> 
> > > Therefore,
> > > esz should also be zero because it is initialized with charged_from.
> > > So I think the real user impact is that "quota is not applied", rather
> > > than "stops working". If my understanding is wrong, please let me know
> > > what point is wrong.
> >
> > Thank you for clarifying your view.  The code is behaving in the way you
> > described above.  It is because damon_set_effective_quota(), which sets the
> > esz, is called only when the time_after_eq() call returns true.
> >
> > However, this is a bug rather than an intended behavior.  The current behavior
> > is making the first charging window just be wasted without doing nothing.
> >
> > Probably the bug was introduced by the commit that introduced esz.
> 
> Thanks for your explanation. I'll try to cover this point in the next
> patch as well.

If you gonna send a patch for fixing this bug, make it as a separate one,
please.

[...]
> > So what I'm saying is that I tink this patch's commit message can be more nice
> > to readers.
> 
> You're right. I'll try to make the commit message more clear. I'm
> really sorry for bothering you.

Again, you don't need to apologize.


Thanks,
SJ

[...]

