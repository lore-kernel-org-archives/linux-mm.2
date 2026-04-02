Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B6A6A111224B
	for <linux-mm@archiver.kernel.org>; Thu,  2 Apr 2026 01:10:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EDC866B0088; Wed,  1 Apr 2026 21:10:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E8D936B0089; Wed,  1 Apr 2026 21:10:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DA36A6B008A; Wed,  1 Apr 2026 21:10:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id C8F996B0088
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 21:10:47 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 660A9C17B3
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 01:10:47 +0000 (UTC)
X-FDA: 84611836134.07.A386B66
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id C0BB840002
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 01:10:45 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=meaZjrOh;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775092245;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5EWMcOClGYNw6CWaujIRYUWzaolUZRP+Tz3ypo3zjQ8=;
	b=XJrx9oC4jFrYQAw30jbZRLN0jPzy0qm5bIDS2/5rjD5fnb27A60eQSve5L3NIUa0qpAmIX
	iLs8mkPWQwx4wVtVSDuld+7vR+2g4ugLfnePbbnu+SyYpUn1uZYstDdvoGHMSLaxNosR6/
	oDR32d4xfZNm2x+YKrh3aSG9iFyVZlo=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=meaZjrOh;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775092245; a=rsa-sha256;
	cv=none;
	b=iek6OUeU0WMDRsPojS011feyjRKQTAxwwvqYNJjhgkFf/o+E/cakorOkk6ZoQloufNrSBs
	238vGfZ8taTmo6/Rooi9W9YeFoALDLyLm3F9sPlspbMwFj2m5aUFGhDzjNC30G+QX3rXCR
	nwCdmyoNKQHr1C5jGlOQxLPlPhXaICI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C5007403C4;
	Thu,  2 Apr 2026 01:10:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CE64C4CEF7;
	Thu,  2 Apr 2026 01:10:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775092244;
	bh=RBpqhqYUfZvqMnoA+utE1x4KPKxI9AlOpwMFYWzsTxk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=meaZjrOhfaHbVXagdnwXKdjt8y13+v/FqQJIAbTACpaJYGd+ECjtZh2twMbsV6m3A
	 dWQvGU7v8LH8IGdYISW0u06wAPhHU8HQrmq76hq4p0sZqG6LdBDOAGAFqJeNy4FtSo
	 MYC5/u9fkCJd8LDl/XtkNOIazZgn25f9wHFjq+22i3CFyvPzZ0BGWWOdPtkU1wkvIl
	 +/9GCGQz59s0y5+I11u8gMKwodBbd/rR0dmRK3Y7zLqg6r5vxwMH0zeoK6x+wjhBD+
	 KIKNe6bo5knI8f2YAWf9TSMHySvpBZlx9b368fLGygqRM1sfyenxCArlAhJXJlqmIa
	 G4KbEh5kO8wFA==
From: SeongJae Park <sj@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: (sashiko review) [RFC PATCH v5 01/10] mm/damon/core: introduce damon_ctx->paused
Date: Wed,  1 Apr 2026 18:10:42 -0700
Message-ID: <20260402011043.67218-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260324040722.57944-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: C0BB840002
X-Stat-Signature: x5p98a68h8363nm4fyiwxbmwutminkah
X-Rspamd-Server: rspam06
X-HE-Tag: 1775092245-35559
X-HE-Meta: U2FsdGVkX1913ADDnn9NpY3xSTgd23kZ37z8Sk9zW1sQDGDoiaexUABz9QjdaQJCxTv4sQ1kXzfdI2fJMRI7SUklg2BSFDe+iT/d2g0KGpd6hS3jcbiLsENR5xz+8DzkSI/BFfOjdyDjKD66sNXdJuhDtgU5Ea0vOTmnM0pJoLXplkOg+mwcuxJpHf8sNbnSanznM4wKsXpSvO5lhwwCNuXcCelrhOGl9sdEx6rGMvMscDa5zNVP2JZKYUYZbXCT2rkhNUMQ43AVjlg8QBT94lAlut/sedk6j1a3QBIqc3rmnWXzfsTlRM1eN7XmTzqGC9LP7kshbWRaTaBNgX57Dn1oIImVSvUej8UHL4eHtJI87ySAAT50D4t02R9eKHRr72uMFmrwJXY5fs95EEwHkVOE0YgC00n98NdemV63T4EulwZxREpUPXED8Xc0MVjRQDDDH4HC+pNEUmcgnx5nI8nEXSyUyxuh4XXWH/e3Fmj3d/1sIxZkP58Wphx/lmIRGuxw5CbL4tgX+cLS+EYKNGANcKFc251mO+TFgcJQvbIlbh7KcXzhFaosFpnQ919QVgnZ9DdfnH6xSNfusAiBeu2RfniF6oEdFdD5tJf7TeYla+LqJ6iqMcuDpfNnGGnHqv01leQap7YpG7xR0BxngMxzrTp0e+N8am/vBlhb0j5pN0ZAlIfl5dgu0mriGkRnu+DEP+HwlRvgvQBkI/vzIXN6IJx1YxriP7KcHm3a1/7BTNen3RLGI7gKjf36EtD/jbhjluc1U6apawMJXtJzII5NAELaMahr/4PdGCQN4kuLYrFBtasAY7qkArwA+vuiCRydkFKVl/rubi0EHfusdB1jAvfO1yhutD/HxlUSlA8eD94puJ82a/xG/fupmXWPbat07hF/hSfOZg9SgdUOm66BIBKH7S5e/LWa0MJNI7c32uh+xDzvYkySSbJsKWdtGrEgKelnXRHKQ+/6gsb
 sAt5gzAt
 yJl4K9CWKxPmWxT2J18j3ZTNPix3IC6noZBN06c3sF8LYVGflUtLbmjyQPRyw4DJLRpI2aw+lAqpQGvkFktBiIS0Zmk6HyWYhlKuCUqlHXNUkhrA+JjhyRQjDzhFchyMmDVmBqEc++BStyJYWBRaS8xgUbffvHh7W9C3gCt8Mmov5TjoS5AouG2vHE/ABpDSla/PTDH+oYO5HAWK9n7gnIRESbSTfGz/zpufMkM0Tb5LjRGrRqWhI/f1bX52kWj6ucEA+bM6squUihVUmhUchXlvjKA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 23 Mar 2026 21:07:21 -0700 SeongJae Park <sj@kernel.org> wrote:

> On Mon, 23 Mar 2026 18:28:00 -0700 SeongJae Park <sj@kernel.org> wrote:
> 
> > Forwarding Sashiko review for doing discussions via mails.
[...]
> > Additionally, when the context is paused, kdamond_fn remains in this sleep
> > loop and skips calling damos_adjust_quota(), which means quota->charged_from
> > is frozen.
> > 
> > If the pause lasts for more than LONG_MAX jiffies (e.g., about 24.8 days on
> > a 32-bit system with HZ=1000), will system jiffies wrap past the half-range
> > limit of the unsigned long type relative to the frozen timestamp?
> > 
> > If this wraparound occurs, time_after_eq(jiffies, quota->charged_from +
> > interval) would evaluate to false when unpaused. Would this cause the quota
> > window to not reset for another 24.8 days, accumulating charged_sz and
> > blocking the scheme from being applied?
> 
> That's a wild corner case, but I agree it is better to avoid the problematic
> case.  I'm still thinking about the good way for that.  Anyway, I will address
> this in the next spin.

The root cause of the issue was introduced before this patch, so I fixed it
with another hotfix [1].  So next spin of this patch will have no change.

[1] https://lore.kernel.org/20260329152306.45796-1-sj@kernel.org


Thanks,
SJ

[...]

