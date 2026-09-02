Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B9BC4C624D3
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 15:15:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C33436B00E1; Wed,  2 Sep 2026 11:15:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C0AC06B00E2; Wed,  2 Sep 2026 11:15:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B23456B00E4; Wed,  2 Sep 2026 11:15:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 952086B00E1
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 11:15:58 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 30589120255
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 15:15:58 +0000 (UTC)
X-FDA: 85169172396.04.2FE4A8E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 9C39AC000B
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 15:15:56 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="iKE/XKpp";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788362156;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vE/Cggwy78pImngvxsbAxzUqhSZmdOdF6pnB66mIkJk=;
	b=pVMLNLhfLeW0zd/gt5I3O4Q+NH1bpaLixyR8PF9gO81PisZaR83Ydoa4YKbDPAft0Oqo5f
	WJJ5GLP7zonb4w82/ZrpNsdztGUNj4mhCdR9SHELA8x243PjJYBcUCWe1pYxe7c2gk0sk6
	jPUSYCnZ/aEmPmzziBIJMJYcWJvWigk=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="iKE/XKpp";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788362156;
	b=wrBEAmGktgEBbTMUoeKIClomiOp27+GZn34NwvnW3Kff3OIpOq5TI4Jo4NlREfjrWGEahO
	9ZGF19i/hWhym4eaO7N0384wwQyGaMUN9UgdJCN3BvViSTk40ICLr7dM2D4EzgYvSrvD2f
	kZVjLcorYT/xOvlMUK2lBSlhgBuRshs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2A7C4600C8;
	Wed,  2 Sep 2026 15:15:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99CEF1F000E9;
	Wed,  2 Sep 2026 15:15:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788362155;
	bh=vE/Cggwy78pImngvxsbAxzUqhSZmdOdF6pnB66mIkJk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iKE/XKppWbSzjEt/knKYntQMNUjU3xxyGzG/qqWR+NjqD77xwNrloFoFmpEUo0H42
	 roqpGnzg/ZLZSqyjVveOpTZCbABjNrSjLZSWz7qyeQNTfHZT+bzmgpID1DYDQ/kCtX
	 aehIQzFzOxyaKZX8vE86cvy1wKe8GVf2THmdarEShk9FErMaLsEroyi1y7nSTrZGkM
	 mTb6qKQSPEah//6s9yXgPifJZ9QYU7LkeavHkqOkGj1b8M2cOMO5TmoUkoyR0pt++p
	 wiPnM9goFqsFH7vGYwOKMYLBeb1N6bnbPenlz7dGCKZxumg8CeTDclFwx39Bk33cAp
	 16Ex83MlBaJiA==
From: SJ Park <sj@kernel.org>
To: Gutierrez Asier <gutierrez.asier@huawei-partners.com>
Cc: SJ Park <sj@kernel.org>,
	Lian Wang <lianux.mm@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH v4 1/3] mm/damon: Introduce DAMOS_QUOTA_HUGEPAGE auto tuning
Date: Wed,  2 Sep 2026 08:15:48 -0700
Message-ID: <20260902151548.88735-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <9ac2a10f-1551-410e-a9c0-173a1daeb1ab@huawei-partners.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: tm6g3gxkg45xkpwf6mq5u75i5wsz19ni
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 9C39AC000B
X-Rspam-User: 
X-HE-Tag: 1788362156-642630
X-HE-Meta: U2FsdGVkX1/zUxvLQUZX4T8gqIWYu0DpLcOkH4iHNheEi0ifdhPhpEobnwDnwhAc5zjxoF190D6fBRTy8T2NLOKf+T86z0aCQc01ugy887vEdWaLDGIk4YKF+I8tJM9eYoRBfALkS8axu0Nr4I/vqFj7YZwkan4o0oBu3f74cO2zhXHSK/43h+pYXmIIbU8gqNG6nSamuBGgpSHjfWILV9reizp/EmcIUk0bfkTGH405Y/M1RUXl+nzDZj830h2sta0CoyZz4LNCl6CVVPqJYda3kALVpWymV7uup6EFGwE7TchFrXYsq9jobtA0u+iOGa7CavTlVGMr0/IFHQ2mfPEzk4Dq1X3XwCHnuC/cVVTGSY3R2WLbvcxgFD0w99+tOW8HKg9Gr4hPALTg6q24/ycMoUWFeDTc6gXFA3hYyuC9oIqK3Md2fWrqDZt9/8ujTyBXYZuQBgBjdDX00hTtsoO4QVzt48u5SeAcRlgfvfoCVTUDdTQaLG0P0YXGyG6qR5V2CXQY4gmRgjapU8W4JzQGH9iIPhakna2r5FZU1oVITQxb7f1Pdn7r8dtuSOVKlmeKVAo7lv66DBDz0hxvhG1OvTBryzTpB65jH1BksVCw4VrF7n/aS16faV07Or54X+bAnFCXosGgvlzKR2XYk4Hps3lnme3RqjTMIMzHtP/QlFIZo35xJe0ObxbqE9CqLcwnFFbRcPsjQUuSSThT8Q4ExO7bAgC7L5nUc00+wxZeFyA3z15iUaoDsnB1pxJACbHRgB8QtWFQYYZqHRqUjay2vNqxqYYB3WjVDq65egvTOHTeZPBEG3oeuKYKTU9CYjfS7rFgkDviTrp8MeUd2z+eiJCh1MMJpNWwT4aBw05OdgfNL2LwPUKLMyuMLGowRM3Hn436CCzUKUjaLnRn+CqAnVL+QFWOENtIMB2p+HjxFAu+hY+P+ZvUnSsh12O0xlOjM0N481+wAhtsHOk
 iNwdI/1P
 CHvezZrsRxopUj5dz6/boGXRNmNx8RwB+INNpIzBGsX84FAt6VfJjqUNsMb91y6JRiJ6ji7Wtm36DGzwmgwq2y5BzE/EOPv3029p2cx4Lhg2YpNvzAHC2N/L7ktjRQHIIXPvziro8VJAfpe/8ryCkPoaY9GuVa7aU5ebz1k/rH7qorNRJ5S/EGQ7+t+JhUHNbQoqGUijwmqcQ3xwrfO3sEvwoi1+NocxCP6h3PM4oOBwpMgvcY1ACZhPWTJ/zQHXIwTyQbIcfryRGRAOduj6iqTHo/odbi80N0mSQLz5ZCSE2iaZpW5xYeTTNGZ0f+b+c1Dy2G7clCEv2LFsxNPUf0YCOoXR1r09OFmjpEhqyooi4VLsPAPRaF0dfz3zVssKLzzL8kDYtcuGDmLBff0GqUGPiVLBqTEmgvcjOFukqroURbAKeCep0D0bjuYDubMKUeke8qqcz02nfZs9FfHhCmbVQHhCrXYS/KK7RACqylhf2HkFilnrJzvy6JRyFiRa0rrA1l6xel2nwHaU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 2 Sep 2026 18:03:39 +0300 Gutierrez Asier <gutierrez.asier@huawei-partners.com> wrote:

> Hi SJ and Lian,
> 
> On 9/1/2026 5:23 PM, SJ Park wrote:
> > Hi Lian,
> > 
> > On Tue,  1 Sep 2026 14:58:35 +0800 Lian Wang <lianux.mm@gmail.com> wrote:
> > 
[...]
> >> Second, the metric is global while a DAMOS scheme can target one process.
> > 
> > Actually it can target multiple processes if those are in single DAMON context.
> > 
> >> THPs from other processes or NUMA nodes can satisfy the target or dilute the
> >> monitored process's changes.  Is this intentional?
> > 
> > I think it is intentional.  The user should have the control on collapsing
> > hugepages, or believe the uncontrolled collapse mechanisms.
> > 
> >> If so, documenting the
> >> scope and testing a background THP workload may be useful.
> > 
> > More documentation and testing are always welcome :)
> > 
> >>
> >> The temporal results approach the 10% and 25% targets, while the consistent
> >> results overshoot the 10% target to about 20% and 45%.  I would describe this
> >> as control-response data.  TPS, latency, TLB, fragmentation and collapse CPU
> >> data could further show the workload benefit and cost.
> > 
> > Yes, those would be helpful.  That's not mandatory for this simple change in my
> > opinion, though.  I would let Asier decide whether and when to make and share
> > such data.
> The idea of this patch was to introduce auto tuning. I think I submitted thebenchmark results when I sent the DAMOS_COLLAPSE feature.
> 
> Anyway, it shouldn't take long for me to get more data. I think it may be useful
> for people to know the actual results in real application.
> 
> SJ, what's the best place to publish all those data? I believe you have more
> experience sharing this data and which platform is the most useful one.>>

I'm never an expert in visibility :)  But if I should recommend, I get three
places off the top of my head.

First, you could simply share the data with plain mail on DAMON and wider
kernel mailing lists like linux-mm@ and linux-kernel@.

Second, if the data is matured, sharing those in conferences like LPC,
OSSummit, FOSDEM or DAMON (nano) Conference would be nice.

Third, if you prefer text, LWN or personal blogs like medias could also be good
places.  I also maintain DAMON porject blog [1].  Kunwu and Lian actually
contributed an article to the blog before.  If you want to submit an article
there, let me know.

[1] https://damonitor.github.io/posts/
[2] https://damonitor.github.io/posts/tlb_flush_policy/


Thanks,
SJ

[...]

