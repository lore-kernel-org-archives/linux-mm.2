Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A9E40C88E77
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 00:13:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2EF7D6B0095; Tue, 15 Sep 2026 20:13:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C81F6B0096; Tue, 15 Sep 2026 20:13:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E6056B0098; Tue, 15 Sep 2026 20:13:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D9BC66B0095
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 20:13:23 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9E17BA05A9
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 00:13:22 +0000 (UTC)
X-FDA: 85217701044.02.1123455
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id F0D7B18000A
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 00:13:20 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=m+bv99ac;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789517601;
	b=mQTfWM0syJP37s55SyTYMUJ/UGSbF6wmUYBJM9Gm869iiZ1AxyfuZ+iKxGTZqkpDeizytN
	njggNUUHjdKy7EGCd1h8xmbPvWUWsecLz9twKuPJ6/9ieP0Ve2WPILlxdS4PxQa7ns7N8F
	xFAJaMYAEIpD7YM9Wo2ZaHJUQBoUDRQ=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=m+bv99ac;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789517601;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=a2lhPSF5A/5CV1Lodrkn/7v4I07Gpj63s01SJKcdomg=;
	b=2Qyib580cA6Jt9vJn7ZH7KPuP82Z5qXWDmYD5BzRVgLE6c8Z/ZLhVW62CyXpc19CDnvCEj
	QvR5kqPy3/MwZ++dv9+80xTedHSE1OYP3TUs5C5K+uWNFLnffQan64++r6boZSmsXXKHm0
	EKcs67yXiLirMmUPoDoGolhnkU+wD2c=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3D34960008;
	Wed, 16 Sep 2026 00:13:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A568C1F000FF;
	Wed, 16 Sep 2026 00:13:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789517598;
	bh=a2lhPSF5A/5CV1Lodrkn/7v4I07Gpj63s01SJKcdomg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=m+bv99acZdpFAL97ydOR3AZHyf7sKcsXCrUMb32kvLoj9H9lyg3wioFfBCZ2W9IT/
	 kOGZVQU5b1C6l+x2Aw/1b5u1wFTrfHkcd49xva39auAfyWtmr2HYbWu9ZPYcTnnxUJ
	 ATikHTEWv66JWjpuPGrP/hbtv/jCMQjVJHsVRMHLvLShOrQr1KZqvFg6+Aysx+aodd
	 stz4cOlw/lVwJ9yBnuP5FPiGz7jWbHMh4ECN9qbTPrRN8ZCbtv0WndhiYcuc5Lzw0p
	 7geGvuPbQHEcWuc+R3wksSse8mHGP1OzZM0XBg7ne91VVvsnzYLeDeM5coZqyzKxNO
	 DSSp0Xy0jBE5A==
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
Date: Tue, 15 Sep 2026 17:13:11 -0700
Message-ID: <20260916001311.101024-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <aqm1ZPUHiXf9PFWq@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: F0D7B18000A
X-Stat-Signature: ry7p3f1rgfwbgu9uhqsfdpksn3zn69nn
X-HE-Tag: 1789517600-745178
X-HE-Meta: U2FsdGVkX19/7nyfzKKI9Y64M5gKY2I+s6jJfKMJlrENC5ES4QuvNUiqNO0xeL7zk5sjyTpSvsc6zgka7n0FGCkVIdIMI2RXpPs6Wfm86eW2uVv+5L2NQ3LPRZkw/ylhpoLREPB0EubgRsi9jpW0JW5HNJbrxMpK5HHJ/h2PUZ8YMFFN0WSYU07S4+l+xSOegri3HlkQJiXa2kyUhYj2T+30EA7myQ1exUVksP7YZsEBPPw+0kH4nW7Qj6Jyogr9aPjmyKF5PQD8UFbqf8eNlfn53/AXHrjbeQKie35qki8UG/iyzKRN8orbmJsPDLdYvzyOjdwDqktgxBgq1iCNY5oMi2IsLkUDDPk+1PvFIv/VnuHjNbT1S1xp4bwIve3SkbwiwPi+fbr2jpx4eG5UDS21OWbLl0qnZAHkIEOUiJiimXAwCacI/IjTL/prSnMGlhn8m0V7o+/WLAlI65Cs2L1iQuC3htGRd4+JMdeLqBZoCMlxufb9RyM9jjU3UyMZeqandlPmHZOcTtUHxnyggRhqIb+R0um7q1OUQSoKMub+T5u3kRd1wysmKlZ//4d/U5C5V7QdxhNhHTFNkcIjN06n+2zCv0SIckWWZHQDS3tO0MGz3vO8tI8rc2i9QaKM9CccZgbt46HDEnE8TNxFbvJD/FXFgdPUFDpLu2n4DtLVGkDG31bM6UtIs6Tp/Gvnql6h95wdu1AcQolJze9OHmTF/yxQBxUGsQUBOoDXWiek2B/ojnPphvOFRyuJovbACjGq2nb0smWTUNqMBVBUo3LTbdbQ53VS94xDuhoV59vb+TAkZiiNqw7BT+IM+UEtTAeO/AljmGY2Z8TqEH0YKJjAwnSuKFyv/CARCo1g0/P4/VUV11pWoLOXgIeruzCyN2sU8a0nlqOdlwtQTkkIhaSSawfoBK/Ae5l3gKYWrIjwglZ8ZVqQGhSzHcrUtVg+GNav6MELGWAz0WXyPO+
 TlOyedap
 Oaxqrpq02DxeuvaaT3k+Ew4bEjmFtRttIdgJX6wy52+YkhPmz+S2IwSQ/hmCOJ17Q8OOnuCzfaeeibKgJOfhovS2oO0D2UBAgUqJcvp3Xq1xOHBzAamQuR+Aqa3nPi++5KxEREVAvEa4Us0eehXRWmuHffHLAz4ieaasiHRemXgNNnTrUig8dr2GAYoGIga4Ja1supATw32YohCZqcGPRZM75p37VNSpxa/8eKdl4b9rPRAGi8fvPUlaXPKpe9MtM1x6x21cqHFCf0FWizP7ialTDDux4hSXgXFNhegf1e+Knxs+/PCmT6w38kR9GE1+6/+7ea3cgQM0QyNc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 15 Sep 2026 23:19:27 +0200 Karl Mehltretter <kmehltretter@gmail.com> wrote:

> On Tue, Sep 15, 2026 at 07:50:54AM +0100, SJ Park wrote:
> > 
> > The intention is to make no effect this round.  Setting current_value to zero
> > to temporal tuner means it will now have highest quota it could have.  If the
> > effective quota before this was zero, it gets an effect.
> > 
> > Ideally, we should somehow remember what was the last esz and keep it.  I have
> > no good idea for doing that with minimum change.  This is a corner case in my
> > opinion (correct me if I'm wrong) so I want to keep the change as simple as
> > possible.
> > 
> > If there is not easy way to do that, I think just keeping the behavior but
> > making it explicitly explained might be better.
> > 
> 
> Hello SJ,
> 
> I believe I have a version that addresses your concern without adding
> too much complexity.

Thank you for keep pursuing on improving DAMON, Karl!

> 
> In short, it leaves the tuners as they are and instead keeps
> last_psi_total across a commit of an existing PSI goal, as the code
> did before a68878f83ae6. The U64_MAX round then happens only once per
> new goal.

I actually considered this option when working on commit a68878f83ae6.  I had
two following concerns though.  First, if the user commits multiple times
before the next quota reset interval, the next tuning round will work with
pressure times that cumulated for longer than the quota reset interval.  This
is a quite rare corner case, but I didn't feel that comfortable.  Second, the
behavior for new commit and update commit is different.

So I'd still prefer to just making no effect this round.  And my commit was
failed at doing that, because it didn't aware of temporal tuner.  Maybe we
could show whether the goal was achieved or not, using esz and let the tuner
show same achieveness?  What about something like below?

'''
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -3187,6 +3187,25 @@ static inline u64 damos_get_some_mem_psi_total(void)

 #endif /* CONFIG_PSI */

+static void damos_set_psi_current_val(u64 now_psi_total, struct
+               damos_quota_goal *goal, struct damos *s)
+{
+       if (goal->last_psi_total != U64_MAX) {
+               goal->current_value = now_psi_total - goal->last_psi_total;
+               return;
+       }
+       /* Uninitialized last_psi_total; make no effect this round */
+       if (s->quota.goal_tuner == DAMOS_QUOTA_GOAL_TUNER_CONSIST) {
+               goal->current_value = goal->target_value;
+               return;
+       }
+       /* Let temporal tuner show goal achieveness same to the last round */
+       if (!s->quota.esz)
+               goal->current_value = goal->target_value;
+       else
+               goal->current_value = 0;
+}
+
 #ifdef CONFIG_NUMA
 static bool invalid_mem_node(int nid)
 {
@@ -3439,12 +3458,7 @@ static void damos_set_quota_goal_current_value(struct damon_ctx *c,
                break;
        case DAMOS_QUOTA_SOME_MEM_PSI_US:
                now_psi_total = damos_get_some_mem_psi_total();
-               /* uninitialized last_psi_total; make no effect this round */
-               if (goal->last_psi_total == U64_MAX)
-                       goal->current_value = goal->target_value;
-               else
-                       goal->current_value = now_psi_total -
-                               goal->last_psi_total;
+               damos_set_psi_current_val(now_psi_total, goal, s);
                goal->last_psi_total = now_psi_total;
                break;
        case DAMOS_QUOTA_NODE_MEM_USED_BP:
'''

The code could further cleaned and optimized, but hopefully that will give you
my rough idea.

What do you think?


Thanks,
SJ

[...]

