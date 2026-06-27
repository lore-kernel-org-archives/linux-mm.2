Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B8ACEC43458
	for <linux-mm@archiver.kernel.org>; Sat, 27 Jun 2026 22:26:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 929396B0005; Sat, 27 Jun 2026 18:26:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8DA5F6B0088; Sat, 27 Jun 2026 18:26:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F1A66B008A; Sat, 27 Jun 2026 18:26:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 555116B0005
	for <linux-mm@kvack.org>; Sat, 27 Jun 2026 18:26:53 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B9439120278
	for <linux-mm@kvack.org>; Sat, 27 Jun 2026 22:26:52 +0000 (UTC)
X-FDA: 84927128664.04.F803BF9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 141C416000A
	for <linux-mm@kvack.org>; Sat, 27 Jun 2026 22:26:50 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BiaMHCNE;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782599211;
	b=X4WMbCbw8RPD4TcRkr4e8z/x64dThmSXbogAgHb7qEjksGpLCDdUiusCC4DNJ+nAProjUy
	360QQ6IQz/xJxb4LIuz3D/Zt0pmRBIaW/HNvEyAdVIzQryUPl4iUzHz3TPe7JajIq9w8g1
	GUVFKe3Y8TufEWsu9hoJViscbwAIzAA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782599211;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZNhuZf4EzNX+x+mPYeLipgASXqtM4sleYQ2JqrvbmuU=;
	b=kOl3DMeezi12Mx8x1WMJUqkjqcOsOjIM+B+fW6pJoHeCQ9RJihK6ebk38loMevIZ9rKl6a
	i2P9bgYkVUgCfxPJgoAIvNFcu87ZEHZ0StkgT+nTvlapmVaEvXux0KqsvJHlf2YRdErFcF
	pCDhSXZ4OgIHDYGts4DOkh6qw1NIjyM=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BiaMHCNE;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E46F04179E;
	Sat, 27 Jun 2026 22:26:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 966F91F00A3A;
	Sat, 27 Jun 2026 22:26:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782599209;
	bh=ZNhuZf4EzNX+x+mPYeLipgASXqtM4sleYQ2JqrvbmuU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BiaMHCNEgYRSLBK49xOzbr4x3ibBYZBjeim+jIKiXM3UaUyp59DAKUYWwC/JD4zHl
	 mEwhkniH8sqzOjM0s3PMVz/gl7DOCrN+83gtMKfKPz8lET3hQt/l31n+oHMpyeplxE
	 ePie9HaSLTJ6tKUQH8NFey5Zn4HLTU89UE3y/3cLAmzg65o7QE0FRBDiyEiE82E3W2
	 Ijg9mLfBH9lyevCUComaEMRSXPi4zIxLt6DsVlEhILgXiiN/3HUqAUc+HXG8oIFttJ
	 vOAO4L51ePXIoIUGWXNhBci3cUBtcD4exLgXR5c5TBjrCz5PNvX53F9WAEG/K0TjKj
	 Z8IM+G2iKaXnA==
From: SJ Park <sj@kernel.org>
To: Liew Rui Yan <aethernet65535@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: [RFC PATCH] mm/damon/reclaim: add 'available' memory as an optional watermarks metric
Date: Sat, 27 Jun 2026 15:26:43 -0700
Message-ID: <20260627222645.26834-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260627213651.19000-1-aethernet65535@gmail.com>
References: 
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 141C416000A
X-Rspam-User: 
X-Stat-Signature: 6zxzrambhhq4p3ncfuu1m5poowj35q1r
X-HE-Tag: 1782599210-163783
X-HE-Meta: U2FsdGVkX19/kSO2ozN0hI/0dwzNPHcXXzKU/v0Y6Rnm5aulkLcYuBH21/74zL1+XCsv6nUuJ8m/gzIQ4/HzTuahu/ME6nOcrCmESz/TztgaYGSbi2z+fdGu2KSgLV/5zOVaepib0g3MelLklNkMQiqNEbiSgMh1J9ulHFEGJDu9CZDrB4973rVADm0FuhFZt7vFirD4eeYVb61znh2Pq243XkokmlqaSpZchXgmMKF/7b5+fAjwZZFSzFVgwpD/SarlG/F/8wudVYY5ZJsMeQk4dmow+iG/kjziI6bfj+OjJhbzKS8rYOXrQj9OmuCRoIvUVn2pSUCIztjcad/HPnj9VsOleqX8NBITEGV08I63RMF/3Z0e0BIvG0ukgv4IcAi9M8lYcQZmmCaKsDsAdLgEP0V8kemlX8LwasdNu1NZPvBYy5WWGWSPzIH/UHjzGLharUlxvI7HXw+oRescFY0swv8fvPZ+npSD7xsL6mIP7OncueK2ep8PnlyjaHPmrVzXLhdBGI9YaszXPYqkz0DcD9t6pIpSNFbkEwsfyNFkTqG3IZ5BC6LjwGjFgJOctSFDiFxwKOcExpYK2K5z/egRxmAmMYipkrrvdspw4yc77YjcAoJ+03cNxDTgg4r7251af8iXqP3HIZwgkt+27vc56YG2MaT24QGWi94UJ0AkX9BKLgDcMcVTolJ1DMJqlxT4L2Egj3eoKKwzQYNXfbtlOoXJCSRAC4HaeI8/It49AVh1KZwCCOv32AVnYT01W+VtKZpn9N83ZW0Pp9zDfx4QciWrGzccctNliPD3sBLii9FcaN4DslYB5kdWlFD1fLUu/T1KvA0KEuNmXLYa7IMx7AWXnS7+zV+iZXSF2Kpme0diC4leX8KcNPUXmsEqxikX/o6j6QAgWeNG/Sgy6/pLVmS6n2JGDml9jjnxY2bB7B8bfVx+ay6KbS650UStPlcnd3LJUCHremg43VF
 +0+gpoPx
 Pv5zlhxJ0zCa8Wxlmz4Y4x7iS6hw+8ikR8Wf5voO+Lm8kvhAQ2XUUErfrNFs2LrEguHKi0sPsjLfn5IZ1paanJ4GSEI3rzC24shUHxChI1jfWY4hsY9pEiibjYsQCWDgs9pUszbDAaqiYqZR20bJaCv2sMD4GZ0wTGSOsxq7a3R4vvgCaQFridhfrkNbVU68C7Z4QwDK50Crm56hbD9c+JZJNnq3eA3VFWXnHntxYxIm0KG3TuCu3JxBb2a7Qi0XiElP9L84Kx7PWmQYt8U1U5i7gOy49RWNPuGXZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 28 Jun 2026 05:36:50 +0800 Liew Rui Yan <aethernet65535@gmail.com> wrote:

> Hi SeongJae,
> 
> On Fri, 26 Jun 2026 07:18:18 -0700 SeongJae Park <sj@kernel.org> wrote:
> 
> > How about using DAMOS quota with its aim-based auto-tuning, instead?
> > 
> > I developed DAMOS watermarks and quota as safe guards of DAMOS.  In more
> > detail, DAMOS quota is for restricting only resource usage of DAMOS.
> > Meanwhile, watermarks is for restricting resource usage of both DAMON and
> > DAMOS.  That is, when the watermarks condition is met, not only DAMOS but also
> > DAMON is completely paused.  Also, watermarks feature was considered smarter
> > than quota, because it is a kind of auto-tuning.
> > 
> > However, it turned out completely turning DAMON off is not a very good idea,
> > because it drops monitoring results when the watermarks condition is met and
> > therefore completely stops DAMON and DAMOS.  It drops the region shapes and
> > 'age' information.  Especially, 'age' of some regions commonly cumulated up to
> > hours or even days.  Dropping that was a problem in production use cases.
> 
> I looked at the code and noticed that kdamond_wait_activation()
> doesn't seem to free the regions, the data remains in memory.

Ah, you are correct.

> By "drops",
> do you mean the age information becomes stale/unreliable during the
> inactive period rather than being literally discarded?

I was just wrongly recall the detail ;)  But, yes, your representation is
correct and much better.

> 
> > 
> > Meanwhile, we introduced aim-oriented DAMOS quota auto-tuning (a.k.a DAMOS
> > quota goal).  It made DAMOS quota smarter and easier to extend than watermarks.
> > Nowadays, users can also pause and resume [1] DAMON/DAMOS without losing the
> > monitoring information when they want.
> > 
> > So, I personally don't encourage people to use watermarks.  Of course, I may
> > missing some problems in alternatives.  Hence I'm asking the question to you.
> > 
> > How about using DAMOS quota with its aim-based auto-tuning, instead?  If you
> > cannot, could you share more details?
> > 
> > I'll hold reviewing the code until this high level discussion is resolved.
> > 
> > [1] https://lore.kernel.org/20260427151231.113429-1-sj@kernel.org
> 
> Thank you for the detailed explanation. I now understand that watermarks
> pause the entire DAMON monitoring loop rather than just gating DAMOS
> actions. I agree this makes watermarks unsuitable for the Android use
> case I described.
> 
> I will drop this patch. I think controlling DAMOS pause/rusume
> separately might be better suited for execution in user space (such as
> controlling‘quota_ms’ and ‘quota_sz’).

For explicit DAMOS-only pause/resume, you may also be interested in
max_nr_snapshots [1] feature.

> 
> By the way, I sent you an email about three weeks ago (Fri, 5 Jun 2026
> 20:28:00 +0800) introducing a userspace auto-tuner program I wrote for
> DAMON_RECLAIM's 'min_age', and asking for your thoughts. I am not sure
> if it reached you, could you please check? I would really appreciate
> your feedback on that as well.

I don't recall that mail.  Did you send that to damon@lists.linux.dev or other
public mailing lists?  If so, could you share the message id or lore.kernel.org
link of the mail?  If not, could you please resend?

[1] https://lkml.kernel.org/r/20251216080128.42991-8-sj@kernel.org


Thanks,
SJ

[...]

