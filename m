Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A8C36E63FFA
	for <linux-mm@archiver.kernel.org>; Sat,  4 Apr 2026 20:58:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 961586B0088; Sat,  4 Apr 2026 16:58:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 912B56B0089; Sat,  4 Apr 2026 16:58:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 828056B008A; Sat,  4 Apr 2026 16:58:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6D4E86B0088
	for <linux-mm@kvack.org>; Sat,  4 Apr 2026 16:58:50 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C9C598C066
	for <linux-mm@kvack.org>; Sat,  4 Apr 2026 20:58:49 +0000 (UTC)
X-FDA: 84622087578.14.1DC55CA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 18C152000B
	for <linux-mm@kvack.org>; Sat,  4 Apr 2026 20:58:47 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="DBEMj2I/";
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775336328;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QYnm88zSlahlGErMVOdJmjriRYRfslPMNiLPV+n56uM=;
	b=WDrfQ11Y4FzHgIF33AdTIdBPdGHX3+bwHlRXJZZKlmLdX3TNDe6yWyhEuJDI8fNoI4xiuh
	PxqYd40AbfpvWw3yPPHHPa+IIV6sq3+KRREJpEnuNk2zFjF2PSMWDjs6qRh/57YeLP4egR
	bGI6WcWpOeCN1CSGVQkmwdkMrp8tYBk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775336328; a=rsa-sha256;
	cv=none;
	b=8PSLrmqaN4//rOduDUlC678HTd5Lq/O+g3tt+6V4A+pgHIn8z0xBAmgwv9ELSsyGOhmANJ
	1Y5WDulOyAK/Nr4/3NlKY70toC5yOMVSgbKYA/iqgxsgkmw7VP4KrX2VZgU1YsMiuMS1WQ
	kUUH0Q6xASuEtf7+1tUAVXyY39oPxHc=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="DBEMj2I/";
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1C11D4093D
	for <linux-mm@kvack.org>; Sat,  4 Apr 2026 20:58:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2251C19421;
	Sat,  4 Apr 2026 20:58:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775336327;
	bh=JjuMIdaMEdHQJUEtMAZ1M1peq0Edg56ahCnVKrCmJWM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DBEMj2I/xb5UVjhrDP+WtqhL8610rRzEFHBaQ4FiiURHmjaHAGZVcdmKgatJmT7GZ
	 8LdCLO1tNKZ3IDEcLD11AmZbUR8zQM7joWvk31sVOaRQnXxW0nY0C+nyrbdPlOi0h0
	 Dw8dOjexIprwCdfLrHlcB3NqzPA31V+p8x79Xg5Ox5Jwq+KhNZyyTHgsa+qpHwqDhG
	 KlkGxgwGq2P5Hi2fRZJ64JODvz+6j1KMkPDd5w8xKlJqEoRLh6gBC0EXg49EEGIE4L
	 SMC9MHhd3ckYgqHh+cTK/BHNzI4GNVRrkgAHm8ZGH8+aPTF7g5Ch+wUfRu1dSi/EN+
	 yaCI/JVKXBcRw==
From: SeongJae Park <sj@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: (sashiko review) [RFC PATCH 3/9] Docs/mm/damon/design: document fail_charge_{num,denom}
Date: Sat,  4 Apr 2026 13:58:35 -0700
Message-ID: <20260404205837.87382-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260404163943.89278-4-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 18C152000B
X-Stat-Signature: y5jbkg1pf4zo5k66eird4bxzdgyspnnj
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1775336327-429702
X-HE-Meta: U2FsdGVkX1/irbc8YYXJkFRtanbGW23YBEF+R9X7gPHRYtGYvmTyVSzoXEULefCIqYwjHac1W5ONqc5L7/y06gVjx9XCU9ojqPmh+4iJoTGOoM7cM6JDlY4vS0cuMzoipvXR1m78SdNJLU3R/N2G66JtsHQ7YWnDje5KKAqFWGmkzhuybNCLo7pW14LHfyqzdCE9Cq6l311ZBe6oWlH2bScgCx1+Ewc2yXDuF+REWxqhDvirCLwQnmNrum6tkAn81Ks0U3DRdqsHp0+Uh3pRcp665I6UF30lZAU6NNiJZMu+btxBA+jwPJxHVBZXd1dzvLww8sly4gCP9IxnDKtt4CZOYtNsdZfwiF127apYBkCy8uAp7j4bItPdd4yzlAaJxHOTixWp2TGKBDXImRZPO1pRpH42xFTqvX7zm77gR4BqdSOABgc0R1+ckS6Uh8EA1NorQwMUS+5Bts7Bo26Q4ZrE81NGx3MMSNW90ZxpX8YtQfqWY5Bf0QxAHXD1D0G+aq/7Ibt/83lTWTmpqTJsMqaGqJqUudBwGI1x9n2fQsf6zOkSWUVocTLsYqEf0PuUqKBQPq4REpPT35xWTgDvhKdH6qtjwQh6J3ozCaTDLsRnsgI0j9bTg3sqVmtMhlFBPCdD+aLoIIc2IaL2CUHH5y4LUu6wXKu4uMkxA+sJdIDPC6W3WLN5Mn3zNqzM5MiJ1d5CCXO2fPYdUbqjaAqnLvnNmaHzieSNaqCVRwYg8S10aPStr314c2BpS4SDcrFuIdhDacmoq5AX9ygxBEaxets47gRddsiaJooK0Lt/IR4nGLZa1H3WxrOQScjhHgNZ41H/6OwUjCQeG9hrahD5tyvW4U4+zdq7r6u2vRwXYLUNL4kJhOGnUW07hJjO7dygRszuOae57GsFtgCcCLuLr5ktsTSrziQVfqYBKQak0Yv4qkvAMmF3ii6OLVrTX65bHIUMEmHssjmvaZnW/Ak
 bJC4GaR0
 qlCHtZdy4b48cbukEyMxygbMWdORsJ8j1qf6srbuTHvKe85KkFt4zelMohGelzj/LhNnWEZQFggpCvJqqr8h062/A1l08oGvhwKKwKCqrr7JwnApuqMZ+vUxyzDul4C0yAXrHwmQyOCjwInVmz2egEfki5dQKHqmdRGPeg2iXz/Ee0/BHk2WS6h46SagbtMWPuD2wvF7gNtndCoK8IVZVp/U97zbV17+S1q2Cfu63Bg8V7vdFcDwyhOPbcfA/1FN32Wv0Mvmhr2oLrDyZqqWN0cy0stX5nv3CQ6sGw2+DRofWowmdwmdHoTAA3+jH6uGnSlAhQBOhPgvLctrHsyfy3FED2LrpKt0HOZk/hRISKPt+3WWCjNSWzx8wuK5ZT96D8xOKUb1S5RvMLdOdeXuGgRfOcMZVmdwVUCaEAfmEvzujLFA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Dropped individual Cc's except myself to reduce unnecessary traffic.  I
initailly thought it would be good to keep Andrew in the Cc list, but even
Andrew may not really interested in each sashiko review for RFC patch, so I
dropped him from the list, too.

sashiko found issues.  I will fix those in the next revision.

Forwarding sashiko review in a reply format with my inline
comments below, for details of my view and doing discussions
via mails if needed.

> # review url: https://sashiko.dev/#/patchset/20260404163943.89278-4-sj@kernel.org
> # start of sashiko.dev inline review
> commit bab641e86f0e9820b2ac0a7d4ae493d23c4c50f4
> Author: SeongJae Park <sj@kernel.org>
> Docs/mm/damon/design: document fail_charge_{num,denom}
> 
> This commit updates the DAMON design document to explain the action-failed
> memory charging ratio. It provides an example of how to calculate the
> charged memory when an action fails for a portion of a region.
> 
> > diff --git a/Documentation/mm/damon/design.rst b/Documentation/mm/damon/design.rst
> > index afc7d52bda2f7..01047e8431d17 100644
> > --- a/Documentation/mm/damon/design.rst
> > +++ b/Documentation/mm/damon/design.rst
> > @@ -565,6 +565,27 @@ interface <sysfs_interface>`, refer to :ref:`weights <sysfs_quotas>` part of
> >  the documentation.
> >  
> >  
> > +.. _damon_design_damos_quotas_failed_memory_charging_ratio:
> > +
> > +Action-failed Memory Charging Ratio
> > +^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> > +
> > +DAMOS action to a given region can fail for sub subsets of the memory of the
> 
> This isn't a bug, but should "sub subsets" just be "some subsets" or
> "subsets"?

Good eye.  I will fix this in the next revision.

> 
> > +region.  For example, if the action is ``pageout`` and the region has some
> > +unreclaimable pages, applying the action to the pages will fail.  The amount of
> > +system resource that is taken for such failed action applications is usually
> > +different from that for successful action applications.  For such cases, users
> > +can set different charging ratio for such failed memory.  The ratio can be
> > +specified using ``fail_charge_num`` and ``fail_charge_denom`` parameters.  The
> > +two parameters represent the numerator and denominator of the ratio.
> > +
> > +For example, let's suppose a DAMOS action is applied to a region of 1 GiB size.
> > +The action is successfully applied to only 700 MiB of the region.
> > +``fail_charge_num`` and ``fail_charge_denom`` are set to ``1`` and ``1024``,
> > +respectively.  Then only 700 MiB and 300 KiB of size (``700 MiB + 300 MiB * 1 /
> > +1024``) will be charged.
> 
> Is this calculation accurate? Since 1 GiB is 1024 MiB, if 700 MiB are
> successfully applied, the remaining failed region would be 324 MiB rather
> than 300 MiB. Does the example intentionally use 1 GiB = 1000 MiB, or should
> the remaining portion be updated to 324 MiB?

Nice finding.  I will fix this in the next revision.


Thanks,
SJ

> 
> 
> # end of sashiko.dev inline review
> # review url: https://sashiko.dev/#/patchset/20260404163943.89278-4-sj@kernel.org

# hkml [1] generated a draft of this mail.  You can regenerate
# this using below command:
#
#     hkml patch sashiko_dev --for_forwarding \
#             20260404163943.89278-4-sj@kernel.org
#
# [1] https://github.com/sjp38/hackermail

