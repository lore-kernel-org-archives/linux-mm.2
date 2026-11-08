Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 57FD2606A31C
	for <linux-mm@archiver.kernel.org>; Sun,  8 Nov 2026 20:13:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=j8H96QFs
Received: by kanga.kvack.org (Postfix)
	id 36DE76B05B2; Sun,  8 Nov 2026 15:13:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 31EB56B05B4; Sun,  8 Nov 2026 15:13:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 235B56B05B6; Sun,  8 Nov 2026 15:13:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id EE1A66B05B2
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 15:13:24 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 678A4C04DF
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 20:13:24 +0000 (UTC)
X-FDA: 85413051528.19.67166F5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id C1D5C1C0002
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 20:13:22 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=j8H96QFs;
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794168802;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=j8+c5Xbh3DzXpViCvYHZV/a1sIh6FK99cPDHc6wG5Rs=;
	b=FyOcDQINPE341zJFM+OnQL6fO+UWwK26KdqDn6l0GLHMN7s0KGa79iTch3rx6F8AcgqzjQ
	MqmwDhU9vZKYkC9BpX5gU6t4Z0U+OVn38jzmjf192t5Wmt8o2pOEpJ4YvrMuE79r3IjGiQ
	7WO0nI+bwBpADc5LDzFV2qteyY8SuHo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794168802;
	b=GTytfpiMeWWcxx31lthuCxuG4TPg0EfvAcoWI4xuOEerpDofRti+t2pJy7+F9qI/Q3kjbZ
	xCuLWZDD68pELVaPZ0SogYPxaHMGj44mtzsylTWr3DXsK0/HztgEeJCCSy+UDAqKn7pi5g
	uqQJwA+ml5ljywHd4Aar8WBwK6OuWUQ=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=j8H96QFs;
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0EE61609F5;
	Sun,  8 Nov 2026 20:13:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 704D31F0089F;
	Sun,  8 Nov 2026 20:13:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794168801;
	bh=j8+c5Xbh3DzXpViCvYHZV/a1sIh6FK99cPDHc6wG5Rs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=j8H96QFsFu0tIe1dXcGE9/ihf6kXtPI52ctqXqM3F9q457AuZPP6RPCrdWWxNGMHA
	 f8/afim4JGWPvGLum9RWkAvDCKI6oir9nRD52Lugnqo5fkSlcHPHOvab/yh5GDnJgv
	 Mf7H6AuUleQe+k91199kTRalcMA7jQ6dHLdvK6ZrsG1RvLeZUtGM30BcJ7ra0WIurd
	 ho5EQsL3SaFEqpf/rOF4tKgRLSVaB5fjIYsAQkuuWkJjL8e89npGW+3NRDNtA8i8I0
	 OGq7YAPgNmot1TmPso8FbH/hmt2+m7x2eBU3CrhQS7Fv0TJGQwv9ocHXpn4ZCKmPgu
	 iBuu0OIJ5EBlA==
From: SJ Park <sj@kernel.org>
To: sashiko-bot@kernel.org
Cc: SJ Park <sj@kernel.org>,
	"Andrew Morton" <akpm@linux-foundation.org>,
	"Brendan Higgins" <brendan.higgins@linux.dev>,
	"David Gow" <davidgow@davidgow.net>,
	"Quanmin Yan" <yanquanmin1@huawei.com>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	"Lian Wang" <lianux.mm@gmail.com>,
	"Kunwu Chan" <kunwu.chan@gmail.com>
Subject: Re: [PATCH 6.12.y 3/5] mm/damon/core: handle uninitialized damos_quota_goal->last_psi_total
Date: Sun,  8 Nov 2026 12:13:12 -0800
Message-ID: <20261108201314.116356-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <sashiko-outbox-204001@kernel.org>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: tnateo9u4q5a5nshznx1x4i9efqx9o36
X-Rspamd-Queue-Id: C1D5C1C0002
X-Rspam-User: 
X-HE-Tag: 1794168802-371641
X-HE-Meta: U2FsdGVkX1+D4O2hxsKiE/kZMaAkGRC1tDQ+JT6pukJiB34ReUhbTLUF+5jL8GTPwiWcKlUK9wedR1o5OSAhV9rAsez7t8sSsFU1K18rQDmom/S8nc1wtc/ZVRNwXZ05FmiQfGR0xK5gf60I1a1jO91BDNT6TGIq4OBPgKB6rBGPTe/lSDBs152Bl35vDG6sPDzBBPRHGtToruBpFck6jK7mn0j6fjm8oxv8h3zZEGIInMMqCaZO70f74J23D0LOwE2xY2ff/QgiKl/6hHN5gZHZT/wwjtUKNIses+GLJtMh0JKipY7+5vz0TZ54ljxWB4gxt9RnbqIS+hz88bh7p2W4Ke9Mb9vMp4Hs0JwTtQxRd5vOv5l5yZ+eHc6BGvgYb2kPgW7AaDwaKL2jjMIL9UmPsXIq91/O7ff2sKLE9dG2xaR6jab8oQc8hUXzytl3+pJqMgRTe2egXoMxQmhP8RcKkEJwU91/HUxvxYBVHxcQAbiZlnwCut8466I7agGFEQnA/+682BASkQ2t/4IiytIuqcj4bdzdYs1lVVpEqUdp896f8RRCRD5Fzc5DZZUAGlT51pTxb+I/ltegrT+zkDpyhfpThtrl9kGNXk/8sTYmbZ83/yljY7KEc6Z//Lss383QNF0ipZzGv308e6vyx9iXFByhH3lvkgtixb+lCs059pwdG1iKtXOOV1YKiClG68+Rv6P9saPeMHBN/Z38vijp6bfNXQAZAHiqaAyoDMEmsZ0HRr0UwxpgiX7dnD8UKbAK3n/ZNTTH12+1gnmMw0fs0GcvLDt7XqIli0E9JdepkfTkioQylno1/6AMjHY8tBX8F2cCXtxq55JhBBTv5CymxRkq80aIaIFCMARWiyUIRcto69ua9TZooBkTId0qbbyHoopndvT9vRCjTSY5yS4k4lZagVpqARnAeG4aS0Yc/L58kZ0FkrYo9K1f8MVb0qcj4uzLPmD2BuWJud3
 xyPqXyWW
 dqGzeGOdIClk8JreabMk8hBQB0ukBLa1ksQfm7GzOJP0JO+ZS4ZLl/VOhp0sknxDC9zqoqgZOVEuRdXVHzGEYY2pbSVMCPbCwoUP306R6LwFkV9XSEOgEv40RKhbN+IX9WYOwQyfAAbVU+aNo0mQRb7i2VpZ86/2p+dTRQ+s6+fwTGUOcW/LaAHJ0SmYcuuUZKXEOO99UKHKY1Qk2FonaoZeSSw9WCRIHjYAuimWwHxBSrvB6J9tToxSvrLaLKjMpNukrBOW4YTLiUmXRdsixqDGvBZXwOqHUXosa7KlKro88k4YOPyWaslEJqy3S3mlpKn67FflfwN+7bY3Ez5lugqSQV1e3UT95m3oTuhQsmLxEELIeqFvSW/MKBrylL0gswCB4BCLubh7s8SpHzU4Tmg9GBoV3wKlr5wS0jFik2PRz+cmzmdTXHqKEFFnHTBl2MoAK
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sun, 08 Nov 2026 20:03:27 +0000 sashiko-bot@kernel.org wrote:

> Thank you for your contribution! Sashiko AI review found 1 potential
> issue to consider:
> - [Medium] mm/damon: integer overflow in damos_quota_score() on first
>   PSI round
> --
> 
> commit 6456f90a0b14251a6d548d6849beb9dd850f55e6
> Author: SJ Park <sj@kernel.org>
> 
> mm/damon/core: handle uninitialized damos_quota_goal->last_psi_total
> 
> This commit initializes damos_quota_goal->last_psi_total to U64_MAX upon
> creation and commit, and sets goal->current_value to goal->target_value on
> the first PSI tuning round so the effective quota remains unchanged until
> a baseline PSI reading is recorded.
> 
> Link: https://lore.kernel.org/20260902002725.108635-3-sj@kernel.org
> Link: https://lore.kernel.org/20260718005316.89585-1-sj@kernel.org [1]
> 
> > diff --git a/mm/damon/core.c b/mm/damon/core.c
> > index 6ef77741b783b..52f01a6508b66 100644
> > --- a/mm/damon/core.c
> > +++ b/mm/damon/core.c
> 
> [ ... ]
> 
> > @@ -1608,7 +1611,12 @@ static void damos_set_quota_goal_current_value(struct damos_quota_goal *goal)
> >  		break;
> >  	case DAMOS_QUOTA_SOME_MEM_PSI_US:
> >  		now_psi_total = damos_get_some_mem_psi_total();
> > -		goal->current_value = now_psi_total - goal->last_psi_total;
> > +		/* uninitialized last_psi_total; make no effect this round */
> > +		if (goal->last_psi_total == U64_MAX)
> > +			goal->current_value = goal->target_value;
> > +		else
> > +			goal->current_value = now_psi_total -
> > +				goal->last_psi_total;
> >  		goal->last_psi_total = now_psi_total;
> >  		break;
> >  	default:
> 
> [Severity: Medium]
> Can setting goal->current_value to goal->target_value overflow in
> damos_quota_score() when goal->target_value exceeds ULONG_MAX / 10000?
> 
> Unlike mainline where damos_quota_score() uses mult_frac(), this tree
> computes the score with unsigned long multiplication:
> 
> mm/damon/core.c:damos_quota_score() {
> 	damos_for_each_quota_goal(goal, quota) {
> 		damos_set_quota_goal_current_value(goal);
> 		highest_score = max(highest_score,
> 				goal->current_value * 10000 /
> 				goal->target_value);
> 	}
> }
> 
> When goal->target_value > ULONG_MAX / 10000 (for example, above 429,496 us
> on 32-bit architectures), goal->current_value * 10000 wraps around and
> produces a score below 10000, causing damon_feed_loop_next_input() to
> increase the effective quota on the first round instead of keeping it
> unchanged.

The issue impacts only DAMOS quota auto-tuning quality under certain setups.
No blocker for this patch.

> 
> -- 
> Sashiko AI review · https://sashiko.dev/#/patchset/20261108195145.115792-1-sj@kernel.org?part=3
> 


Thanks,
SJ

