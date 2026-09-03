Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F0FD3C61DD6
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 00:34:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 999546B00A1; Wed,  2 Sep 2026 20:34:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 949896B00A2; Wed,  2 Sep 2026 20:34:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 860B86B00A3; Wed,  2 Sep 2026 20:34:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5D9206B00A1
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 20:34:03 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5BCD5803D1
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 00:34:01 +0000 (UTC)
X-FDA: 85170578682.02.F7E1324
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id B1C0A40004
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 00:33:59 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CaZJQ5xz;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788395639;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jj8sMkrg0TmM2tvCwEudWj/A8COjYfR/MqX6qZVQG9Q=;
	b=Ymd1g3eTMbmn2HdPl75QGX3hvrxIEnCpgd4rAbTIvbNKRbtXvWATmb1oeeePCGiEVVPgtU
	h+PLsQlwDieFLc4pIKuVfFxx0w9i4u1hugY4jHgRTof7ipqjzmKbhjXlwJ67PigsKQKvuy
	bnCfo/hgeW2x4qU2JdUn5L+u/itFyQo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788395639;
	b=KpXMLcV2qERfC+XTa6RFlzkZn38v6XGZTa+4RiUJ8qMtFbQhev+4E1QbN4qcuP5YZs6Y+w
	rZ/0HHOhMifctzD5wrZwJ59iqgF+NAWp0I2YqwHxi4Qc2w5yPYyBX2VNCbvca/HdGCLCun
	PzMkt4s7X3Mh1NxkwboXQqBJE5IYVOg=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CaZJQ5xz;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B099C414BD;
	Thu,  3 Sep 2026 00:33:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D4451F000E9;
	Thu,  3 Sep 2026 00:33:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788395638;
	bh=jj8sMkrg0TmM2tvCwEudWj/A8COjYfR/MqX6qZVQG9Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CaZJQ5xz8brzL/eyCE4GAKhBZ5wSIUamTyyw8qMXmFUmJhHs+eEK6HGU6isekeDQz
	 IqzxrYkyu66zQaOyxl465+7WD2YFmzh4sx6/TAIM04CNdKj2QsRC9kzo4NAMl9xtEg
	 BlRy9bPuuhy/zICGs+628Gg2xF/7ca4pUi/z20+DR9z1xAsKQ5JFtHcFkjeu4ZA0Kh
	 6Aupy6Oc01aIOQr3o3+RDEIIhPFFFLXO99eEQCR5bnnhUNUTXrHWAp+m9zs51bHTKJ
	 M6bM4tgbLmiHIoqPraQn4B/Ce+KY4XLcnAidkzh2pOnGXOBIpvzNHb9FTi4HCQAjqm
	 MDBXJvEOyydRg==
From: SJ Park <sj@kernel.org>
To: Liew Rui Yan <aethernet65535@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	stable@vger.kernel.org
Subject: Re: [PATCH v2.1] mm/damon/core: fix false positive in damos_quota_is_full() when esz is zero
Date: Wed,  2 Sep 2026 17:33:50 -0700
Message-ID: <20260903003351.91088-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260902223203.14871-1-aethernet65535@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: B1C0A40004
X-Stat-Signature: nw89b7ynax6h3jnqsmxapysky734s6k6
X-HE-Tag: 1788395639-769637
X-HE-Meta: U2FsdGVkX1//MajIJrRr2J60vYSAcsR5q8x8U2MqP4vA8Y1m7w1pQRA0gdqOHfZJWxAHO5C1XfJ+Ps1JkdNWaDv/L8ZJqyppZrK0wsn5ezgkPw10JwELUdyl+/It5VrrlVnj4b7MfJrxApV9aqjgZgihzy6TwsrNYZwfxwWFhFFtiSokz5LMK8wh9FAsHzxFZSZv06gckdPigcmeiFK7xfWPeZUeAttQxpsOqg9Y7S1ZTNzLmDXmlpyDtgLnlIz9ts4k/sflrJdCfEIkfcb0kELXcBgKA2/38oIJw/WBs+KiofdRA5FCiC/lafN34mBs/WAGXVslSFce1otuKwqNlE/gzvF6Ruuh1ISF96+6nlLmXNCkE2Wora+I0NRKa6O2OM7RZdlS3r84mGgbOILNjuORyOC5zrx2J1AP1A8BAnGEIr4a209xDCIZikd/WeZpYjE2kHkuqPSAxtxhFxNdKwJ7PUY6Z01n1JqObL/b9GTmjdJDrOBXoixmy2h+jqqwj+PaQM7DctSEX6RhChk+p50RNkx5+Dz2SPDbxAchLtnAJukaHo1f/IqDTLGeiPYGUIeMYOkT1zuF1HNh61Glk9dsamjlMRDqE6nnNVF7O+4ZcyPySngm7XbIHIZ5Eg3F0sqLU+qSoiI5pxJw6fBKtjVR3K4PxPg8Qs0KaswBZhDeMsmh75j2SM0NPDNPjoI9ij1hI5BbdZKFJIa+p+q7Av2J+GeaB3ZpEhbp0txJ0p430nBgIqcKZzh1mOnfbzIR39ZsA26OCDpj+rM7B4J/dU1R/V03iMr0RJbf6UbOKQ1EwIS0DfBMMAG9HIbZuC2ZkxIWKUuTGAVEkESBwrpMHCWOBqKRWClhYX8YDXuPbm3KRxIzRFtnyjwR4HJ+gB6lBuKtAIBcLnip5/AmhKQpkpag98ciodPObc0MoHCF6g+NWJJcaiYM5b4jJqSltekbLzq2HPtScOORyJJso76
 BU9Igz0J
 eY9L96s+CFf6zi3NDT2bYresaKsmqi0l3tFqFKv+1J3MyhGnz8Svh9VV15oEVLtRJBoM04FgyizKH2J3nuurRtsTsPI8EYQHNWquiRAJQL5GTcE7UIO1rppLfYqn11TKe0AZHV+9qf/C3QcAcLTCcl1Tg+g5p79In6r2x75BzVjt/ts+l9c79DGHQ0Gjp8WIjk0TG60WuN5iExzoj+y+QI7KH0g5x+u7D7+qIXD/R1YEbGWiSqBwwBg8shSWuLn19AftGUcZ1Apx6M/ZeZYO5bdxoYNICgNvmc2URTihbTy3aOKzAvjDs6dHdMw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu,  3 Sep 2026 06:31:38 +0800 Liew Rui Yan <aethernet65535@gmail.com> wrote:

> On Wed, 02 Sep 2026 07:48:03 -0700 SJ Park <sj@kernel.org> wrote:
> 
> > On Wed,  2 Sep 2026 22:22:31 +0800 Liew Rui Yan <aethernet65535@gmail.com> wrote:
> > 
> > > On Wed, 02 Sep 2026 07:10:00 -0700 SJ Park <sj@kernel.org> wrote:
> > > 
> > > > On Wed,  2 Sep 2026 16:44:45 +0800 Liew Rui Yan <aethernet65535@gmail.com> wrote:
> > > > 
> > > > > When setting goal_tuner to 'temporal', if the goal is achieved,
> > > > > quota->esz_bp will be set to zero.  In this case, damos_quota_is_full()
> > > > > will always return true, even if no regions have been tried to apply at
> > > > > all.  This causes qt_exceeds to increase unexpectedly.
> > > > 
> > > > To me, this looks logically correct.  Could this cause any user issue?
> > > 
> > > Yes, I think this might cause unnecessary confusion for users,
> > 
> > If it is _might_ kind thing, please ask questions first, or add RFC tag at
> > least.
> > 
> > > at least
> > > it did for me.
> > 
> > If it confused you, definitely we need to fix it.  But if it is just confusing,
> > let's try to clarify by adding documentation, rather than changing existing
> > behaviors.
> 
> I agree that we should avoid unnecessary code changes if the issue is
> merely a matter of confusion.
> 
> However, I believe a code change is necessary in this specific case,
> rather than just adding documentation, for the following reasons:
> 
> First, this distorts the semantics of qt_exceeds.  It is a statistic
> meant to track actual quota full/overflows.  Incrementing qt_exceeds
> when the quota is completely unused (because the temporal goal is
> already met) misleads users and could break user-space monitoring tools
> or scripts that rely on this metric's accuracy.

As I mentioned in the previous comment, this doesn't look wrong to me.  I
understand some people could think differently.  That's why I think this is a
matter of clarification, not a bug to fix.

> 
> Second, considering its original behavior when it was first introduced,
> the recent changes [2] have inadvertently altered this behavior.
> 
> When qt_exceeds was first introduced [1], the conditional check was:
> 
>     if (quota->esz && quota->charged_sz >= quota->esz)
>             s->stat.qt_exceeds++;
> 
> Later, to handle cases where 'remaining quota < min_region_sz',
> damos_quota_is_full() was added [2].  When this function was added,
> quota->esz was replaced with !damos_quota_is_set(quota).

I don't find what's wrong with this.

> 
>     static bool damos_quota_is_full(struct damos_quota *quota,
>             unsigned long min_region_sz)
>     {
>         if (!damos_quota_is_set(quota))
>             return false;
>         if (quota->charged_sz >= quota->esz)
>             return true;
>         /*
>          * DAMOS action is applied per region, so <min_region_sz remaining
>          * quota means the quota is effectively full.
>          */
>         return quota->esz - quota->charged_sz < min_region_sz;
>     }
> 
> With the introduction of DAMOS_QUOTA_GOAL_TUNER_TEMPORAL [3], quota->
> esz == 0 carries two meanings: "unlimited quota" and "should not
> be applied".

I don't find how you think this way.

> This overlap causes the damos_quota_is_full() check to
> return true incorrectly in the temporal goal scenario, leading to the
> false positive in the statistic.

That still sounds like just a matter of different interpretations.  Let me know
if I'm missing something.

> 
> > 
> > I feel like we also found similar case that people send patches to change some
> > behaviors that confusing them, but not really problematic.  That sometimes
> > waste unnecessary time for understanding the intention of the patch.  Please
> > feel free to ask question first, if you found some confusing behaviors and
> > don't know why it behaves in the way or if it is a real problem.
> 
> I will ask questions on the first in the future when I encounter
> ambiguous behaviors, to ensure we are aligned on whether it's a real
> problem before drafting a patch.

Thanks.

> 
> [1] 6268eac34ca30 ("mm/damon/schemes: account how many times quota limit has exceeded")
>     (Fri Jan 14 14:10:202022 -0800)
> [2] c7ec7d5f6b3d1 ("mm/damon/core: handle <min_region_sz remaining quota as empty")
>     (Mon Apr 27 18:33:50 2026 -0700)
> [3] af738a6a00c1f ("mm/damon/core: introduce DAMOS_QUOTA_GOAL_TUNER_TEMPORAL")
>     (Mon Mar 9 18:05:19 2026 -0700)
> 
> Best regards,
> Rui Yan


Thanks,
SJ

