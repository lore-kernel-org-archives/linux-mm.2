Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7968CC982D7
	for <linux-mm@archiver.kernel.org>; Sat, 19 Sep 2026 15:53:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D917D6B0088; Sat, 19 Sep 2026 11:53:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D43306B008A; Sat, 19 Sep 2026 11:53:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C31816B008C; Sat, 19 Sep 2026 11:53:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9D0FC6B0088
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 11:53:53 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0C1BAA02C8
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 15:53:53 +0000 (UTC)
X-FDA: 85230957546.26.30DF48F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 5E18240006
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 15:53:51 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iTIX4ZY1;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789833231;
	b=Uo1Vdesxs5fMlWgWAzw4Dn4T6y7EmFxu/O/gu2BuO2Pas5tfQhwBZL6gZqE4UL6FC/+G7t
	Hl/tv+rpW+uC1j9mP8oEOykPeBJa88oPsRWje12V7aiHwr3Fpim9/s/ddmr5aoG76iF2VQ
	chZ5kAlH/zBmBntWkrix7fDzeit2OTM=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iTIX4ZY1;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789833231;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=i/uBEdJPm1aQswNq4LdASQ6ufGvoxHbey0sIvh1PP5Y=;
	b=NC0viv3X1brH2j0tkTjJoQM2QEOUWTjBfX25+G0tueRpSM+yxHPJglfOdqpu3dChpTjVo+
	d0LozbjV3uaLski6cb/KNWRpG8l5PSZzaKSLcYuZukHcnR2G9HxNudPsN3Bx3riFHmfT4G
	V8X05KlL+wOVz3KjL/PxqAXXwR3ZZ1Q=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 93A6A43BF5;
	Sat, 19 Sep 2026 15:53:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 226951F000FF;
	Sat, 19 Sep 2026 15:53:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789833229;
	bh=i/uBEdJPm1aQswNq4LdASQ6ufGvoxHbey0sIvh1PP5Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iTIX4ZY1UjG0u1Zijb/Prirq3sF+j0Y0tqKsLQ1PigyMCQNg8c0mDUATHMU/NO4xq
	 6gGUsAFfRMEv8ttEzoNmOr2oYHgxLKR9ttRGg1U3259Ts8Zf2p8f/dilzHKhN19wx5
	 ji2RWjLuZC2b07j1knyz5qze7vla3heqSBwT0VuzYQYZHyT1vxdYGwVtPNfrp7Xrc1
	 f2dQoh6/ZDQvDv8yKGjZP2KIj8ju7DsGK3cVC+ILV3JIVHGTnuf4h3ACIXxI7HRFcS
	 F5EC4+lp9wKpFGO8ev1jEIZY6jQFaxemzW5IbpGUiu24EjYcUPEl3X3XWAzhME+8d4
	 0oes1c7tWCfNg==
From: SJ Park <sj@kernel.org>
To: Karl Mehltretter <kmehltretter@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lian Wang <lianux.mm@gmail.com>,
	Kunwu Chan <kunwu.chan@gmail.com>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] mm/damon/core: score an unmeasured PSI goal as not achieved for the temporal tuner
Date: Sat, 19 Sep 2026 08:53:41 -0700
Message-ID: <20260919155342.85699-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <aq4g5W58PgWLqJ8p@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 5E18240006
X-Rspam-User: 
X-Stat-Signature: qgkcc8iw9qbiihe33mxo1bfgk3per6cf
X-HE-Tag: 1789833231-337034
X-HE-Meta: U2FsdGVkX18zvBy/3xCpu6vpn3/vMih9Ssfxsx62Qe9+5afhrkO+b43SbZCWNBf0EXURJWHYGbppCBfqFnkr6UBPYc6jIFaXAuiZXw56wKbiP7XpGm+r9P2GJFiop+bzbHbFLvso7En8YvCKh1VmlHoEKnth/AWDnS5U3NwiRU2gy2/+BuG4uGcog3WHB5j1WKbktDgUBqozcH7twMM6WUgnxcxtNhJIZc+UukrzVQRa7n4O9URhuL3j/b99um0JzuT/+MZZOyycPfm8eK+nXdxI5GaeqvuHENm2vXfRPCRdaSTs9DwP9r1ollXYrh3cf/61An2g5UZZFzNj66q9dfXKVzGtLZ8URUwE7dzewE6oa7n4GNGF5DRQE0Lv9zqeF0osQx8c/kh0UkitI46pod6Tj/OB003CHasHgMZuzxDlrZ49RzbmPriBADESC0Co1WEhjvc1mebqDp0I2ugree1N0f9G1qmCP7DuzT99T0dFea0am4/ZIgsP1Da7eB1bWj/ho+SEZ2uiK90RrnTgwDsMKV5/D5nTBU//Z7bvgn8aBq0xgtHdV0uhEJXOahXiRDLt7hR5ki+qoZJ0Dmgps0wYddTx87flqhafOoalDXfnwbom8R7pZK2nUMjxT4b1Ub1iD6MFTX2iZQ/NBueuabpQlegAs1gM5TTWYkIV5SQg2lpWGG09hjs+IE9QxxXP+0VDLUjZamn7Zax3B4amdakSxTi4utO4+EsFm6d+8oKtMR22p0URMSN7F5r1NOybt+bzsgzYEpxMRmaGh5P2G929ab11Oe3x4Hno5pHsFxKyUf7GfM24SA9xjXL6bzWw1r6YttL8A/D0aaCnNeotg2F6M3Ki73uJwJIJyfy2U1OMsci5qCbHAGhrZhWR4kp6jdLTK4a7AAT/0t4W+p2eK9/kBGHMndOhude+A3o2v9/PxvhdR0mMO0JUvfZUKGaPm/o/VBXvVCt0VkdVUrA
 CdP0viem
 jPCuzijo6dKTMMtq6DYGR4epW9LgMsI2iFFMzs5oRT1jsUPdFzXgI5kKVLqxvU77HiJkDnbajrOwC4ARJxApJQXveZzXH7nJjrwtLRS4titWaUQ2xyNyI8A/E8QXtZ6ch7bhc2fZHLy+/GjupW+A1KXg3d0+flU0V2X9Ck+gN0NDgjZOoeQZvjc0oMvTnf2u0qrDoio1hRkyTa5TxqPn4VzXS2ixOVInSvmjZ5Z3T7lfJbF9JmnSY20xZWOVhh5T37rGgLYXOZWy1PtCY3N2fE5AO8Rj2WzNwmGfRUM8J49kZCKmMZ0Q5O8+JTxthBtV1rMwkKMzcjtCskKBMmfgRsVlX9oJKTX5Xo23nXK/5mKN7/Ug=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 19 Sep 2026 07:44:11 +0200 Karl Mehltretter <kmehltretter@gmail.com> wrote:

> On Tue, Sep 15, 2026 at 05:13:11PM +0100, SJ Park wrote:
> > So I'd still prefer to just making no effect this round.  And my commit was
> > failed at doing that, because it didn't aware of temporal tuner.  Maybe we
> > could show whether the goal was achieved or not, using esz and let the tuner
> > show same achieveness?  What about something like below?
> > 
> 
> Thanks for explaining the two concerns. I am still new to the DAMON
> code, so I may be missing something, but your suggestion looks good
> to me and it is simpler than what I had. I have prepared a v2 this
> way and will wait for your comments before I send it.

Thank you for accepting my humble suggestion, please feel free to send it when
you are ready!

> 
> One note on the first concern: as far as I can see last_psi_total is
> updated in every tuning round, so commits in between would not make
> the measured time longer than the reset interval. But I am fine with
> your approach either way.

last_psi_total is updated in every tuning round, as you mentioned.  But the
tuning round comes if both the scheme apply interval and the quota reset
interval are passed.  damos_adjust_quota() has the quota reset interval check.
kdamond_apply_schemes() has the apply interval check before calling
damos_adjust_quota().

'''
static void kdamond_apply_schemes(struct damon_ctx *c)
{
[...]
        damon_for_each_scheme(s, c) {
                if (time_before(c->passed_sample_intervals, s->next_apply_sis))
                        continue;
[...]
                damos_adjust_quota(c, s);
'''

'''
static void damos_adjust_quota(struct damon_ctx *c, struct damos *s)
{
[...]
        /* New charge window starts */
        if (!time_in_range_open(jiffies, quota->charged_from,
                                quota->charged_from +
                                msecs_to_jiffies(quota->reset_interval))) {
[...]
                damos_set_effective_quota(c, s);
'''

And the apply interval (or, next_apply_sis) is extended for each commit, in
damon_set_attrs().  Hence, the problem can still happen.

> 
> I would also move the last_psi_total update into the new helper, so
> that the helper is the only place that touches the field and the
> unit test can check it.

Sounds good!

> 
> While testing this with damo I found a second problem. A full
> "damo tune" still gave a zero quota for one window, on the unpatched
> kernel too. damon_new_scheme() runs damos_quota_init() on the quota
> of the caller, and since b90408ef1163 damon_commit_ctx() passes the
> quota of each running scheme to it for the test context. So every
> full commit zeroes esz, esz_bp and the charge state of the running
> schemes. Please correct me if I read this wrong. I can send a
> separate patch for that.

I don't really understand the problem.  Could you please further elaborate?

> 
> In a quick QEMU test with your suggestion and that change, the quota
> stays at 1 MiB over "damo tune" and "damo tune --quota_goals_only".

Sounds good.  Looking forward to your next patch!


Thanks,
SJ 

[...]

