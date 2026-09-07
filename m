Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D58C7C79FA1
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 16:33:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DCC5D6B008C; Mon,  7 Sep 2026 12:33:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D7C556B0096; Mon,  7 Sep 2026 12:33:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C92AB6B009E; Mon,  7 Sep 2026 12:33:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9C34D6B008C
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 12:33:55 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 233B9401E3
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 16:33:55 +0000 (UTC)
X-FDA: 85187512830.20.4EE876C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 84E08120004
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 16:33:53 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=i5wYc8By;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788798833;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cAuFkVwr+DWI2V4wrox0xZCJB/0hu3m74aTo0dee8I0=;
	b=MDgT4LAXGLlJbdJH+iumbvFb4+FAGzgfsKiO2tzKXTH53T/nu7MR6W2iI95NS7bX+gNlz3
	bSBQMOnFYAL81a5x3aD8QNHjuXfX860VVBV4O+QEnXON8oqe2DuFPE2rGaTIVh4Yg9l+Kj
	KxzWtupXche3+56Q29Rzpki1HMNh7Ak=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788798833;
	b=J1lwe/ArAPF0rNU4+FSnuEaFW6EttOzMz3OAEw2ApeTQj2TNLZkXxWjmBg1brzKkIyBG+P
	tLsubFKvDsms9i8OFIsQ3o6RoEJlBpeLgfDF1nFAAf5KhcCVC+RLnocHiuirsX3oe+49fT
	Kwm8QM6oiQ6Ipx6V9BexHbos8mpbOfQ=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=i5wYc8By;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3C28D601DB;
	Mon,  7 Sep 2026 16:33:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABCF51F00A3A;
	Mon,  7 Sep 2026 16:33:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788798832;
	bh=cAuFkVwr+DWI2V4wrox0xZCJB/0hu3m74aTo0dee8I0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=i5wYc8BysTLjWIl1VZMisAs6qq70fofF+8/cz4NAB0r9TF8ieAzpbP2DsOXRCdYPs
	 h/OAHgy169+b1CuJ8FoTJPYCFcuobmAA83xbEl5HsAtmh2DgNO1LaFmCflDfzD30hv
	 ZBKpii018dEnIpP6ts7o8tlPIs8xXjKxmZhUfRujTGOO3v7A6fIZb7xR/H1eU5wzhj
	 54x6CLqyDPNStPOVx9pj7VdSDCz5FeIJZA7TRfvq/M4GnVeN0mCsVuk4BehIK+nDPQ
	 v7aYdvHltnPnINFV6eQ9PkxGIW95GK6TA5BTBB+9fxbWdMc/r5ZQuG1CKQhZI1Qn2Y
	 /cpt8yAFkCgUA==
From: SJ Park <sj@kernel.org>
To: Liew Rui Yan <aethernet65535@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	stable@vger.kernel.org
Subject: Re: [PATCH v2.1] mm/damon/core: fix false positive in damos_quota_is_full() when esz is zero
Date: Mon,  7 Sep 2026 09:33:44 -0700
Message-ID: <20260907163344.87006-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260906222633.4227-1-aethernet65535@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 84E08120004
X-Stat-Signature: 3skiswyjde1w7mi6quyq9c48f6k1zbxy
X-HE-Tag: 1788798833-94227
X-HE-Meta: U2FsdGVkX1+Kf7sjoIEFCW0qhKaXZwnyOJsc/WfcxnXi29JG329wl2y9crUd+40Pu77cQcK1iHPzB+71JSbYAOlfJe5qoUxzZi0lK9cH+2hQaWlHe9/sWpPWMJ8x660eGmb/PI/G1NUQk//Ok2cC+6DLaPSdbUdQDE+I8bzecJVMR4vfJMDGOni5KVO4CulZcI0xgbr5QP82hwKPz0+aTF3GUvasN2cKwGYK1EctYntEfM22Oewd7oscPf9/RnaIiiPw9ujjjnsTf4Z7gbTlMAtnyaQzEBGs55w6rWCvQP26wmnpbbiZHrFGL6a80PwUoL95HeGhtpcDM38hB3NozyH2Tz+VvPZWLOk9Eb4X6Qi9fNtf0cHgnBOxGaeNXjmR/qYD7yTODUQGBN1aitm0KF5VheKe9ntJ1J3Bwqk3mQ9exB+fAhKS0FLzDppoUQrxEw2p7ocyk7TrW7Vtodq3b3wUkfiENLhTLVgVi0g9BRPkhw1WuDi/312eeaEC/NH5tHPgU0JGzCPgTsvwWsLk8X912fhkeNPcR1TJfF6CQ7/M6F0RNr3sZam0DkgKjgwHpZ3qmFh67Ja5kGXbxaeA9N0eyJQJX8MMoGe56W/DM80EFKqZg+UKHUeuTb3T4SSkEIPgqp0pjkT8+NOmYUmt9SEvv26kwkiKRiDmzrBDJkMhwfQNf+pR4yZfiW/5Z6ZAqA3PYGwq8XqeTVgBNTops5zBDjgHoWTrywHn+6369Wo17xXlSEpZsOxIPorDbmGZZoxxq4AAMd9qWBl59X6CWbf/yi9I3x3XYndJxVm1H0CUEQA5U436cUwxWEQHVn1Se7XOiP1lmqXbcQpJnL6m7f0KYhrpJTVL4f/EyUWOCOEpkD9VymxPv89/M+bloVyGwR72AdUJECKN9mhY/2Np7b5Of0I3MfB0bEabhNv651TSD50soRt7G2IK6iiDycbLC5UJZsUJn6E3WOemHNQ
 nFF8xs3w
 47xPGGjoeai0Y4qznrQuDhnaGBbYoWKzBvJLU7fBVEmvi3jlQJwUvnH3iPbwx1LxF6OqtShjQvzALuM+9V7bT3WHFjGowoLbtLVmy/WOBIkg2T2Ff40FHJlgyQhjZoKFDgj4VkzfLFwBICDcndbkKc5k6PT9KpJlcN5Kk3Rmsv1elZgucEHb4UfBRGlqqStuQDCE6IyE2u0XnGzsn/G38A+Q7UQEPnJBuXlNYJBjplITNa7WBpxstXgI80cKAptUad5zCB9EbZIy8sggL73arq0WpGhCuPh3ia9GOF2WLwKy+Mag=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon,  7 Sep 2026 06:25:28 +0800 Liew Rui Yan <aethernet65535@gmail.com> wrote:

> On Sat, 05 Sep 2026 09:12:33 -0700 SJ Park <sj@kernel.org> wrote:
> 
> > On Sat,  5 Sep 2026 18:36:58 +0800 Liew Rui Yan <aethernet65535@gmail.com> wrote:
> > 
> > > On Fri, 04 Sep 2026 17:25:34 -0700 SJ Park <sj@kernel.org> wrote:
> > > 
> > > > On Fri,  4 Sep 2026 23:35:38 +0800 Liew Rui Yan <aethernet65535@gmail.com> wrote:
> > > > 
> > > > > That said, it's not important for me to add explanations to the
> > > > > document, but may I know why commit [2] changed the behavior which
> > > > > introduced by commit [1]?
> > > > > 
> > > > > Commit [1] Behavior:
> > > > > 
> > > > >     if (quota->esz && quota->changed_sz >= quota->esz)
> > > > >         s->stat.qt_exceeds++;
> > > > > 
> > > > > Commit [2] Behavior:
> > > > > 
> > > > >     if (damos_quota_is_full(quota, c->min_region_sz))
> > > > >         s->stat.qt_exceeds++;
> > > > > 
> > > > > Before commit [2], qt_exceeds will only increase when quota->esz is not
> > > > > zero, but after commit [2], qt_exceeds also increase even when
> > > > > quota->esz is zero.  I'd love to understand the rationale behind this
> > > > > change to better grasp the design evolution.
> > > > > 
> > > > > [1] 6268eac34ca30 ("mm/damon/schemes: account how many times quota limit has exceeded")
> > > > >     (Fri Jan 14 14:10:20 2022 -0800)
> > > > > [2] c7ec7d5f6b3d1 ("mm/damon/core: handle <min_region_sz remaining quota as empty")
> > > > >     (Mon Apr 27 18:33:50 2026 -0700)
> > > > 
> > > > Seems commit c7ec7d5f6b3d1 didn't make a behavior change that you are
> > > > describing.
> > > 
> > > I actually wanted to point out the behavior difference between commit [1]
> > > and [2], but I've understood and agreed with your point.
> > > 
> > > > 
> > > > '''
> > > > $ git show c7ec7d5f6b3d1
> > > > [...]
> > > > @@ -2601,8 +2613,7 @@ static void damos_adjust_quota(struct damon_ctx *c, struct damos *s)
> > > >         if (!time_in_range_open(jiffies, quota->charged_from,
> > > >                                 quota->charged_from +
> > > >                                 msecs_to_jiffies(quota->reset_interval))) {
> > > > -               if (damos_quota_is_set(quota) &&
> > > > -                               quota->charged_sz >= quota->esz)
> > > > +               if (damos_quota_is_full(quota, c->min_region_sz))
> > > >                         s->stat.qt_exceeds++;
> > > >                 quota->total_charged_sz += quota->charged_sz;
> > > >                 quota->charged_from = jiffies;
> > > > '''
> > > > 
> > > > And I don't think there was a behavior change.  Hopefully commit 54419bbd0ee3
> > > > ("mm/damon/core: allow quota goals set zero effective size quota") will give
> > > > you some clues.
> > > 
> > > Thank you very much for your clarifying :>
> > > 
> > > Now I completely understand why there is different behavior
> > 
> > I told you I don't think there was a behavior change.  I still think so.
> > 
> > > between
> > > commit [1] and [2].  Because in commit [1], esz==0 only means quota is
> > > unlimited.
> > 
> > No.  Commit 54419bbd0ee3 says "DAMON core assumes zero effective quota means
> > the user has set no quota."
> > 
> > 
> > > After commit 54419bbd0ee3, esz==0 also can means do not have
> > > quota at all.
> > 
> > That's what the commit is describing the before-commit status...
> > 
> > > But the qt_exceeds should just not increase when quota is
> > > unlimited, that's why the current implementation is completely correct.
> > 
> > There is no unlimited quota.  Hence I don't understand what you are saying
> > here.  Please carefully read the commit message again.
> 
> Thank you for the detailed explanation, and sorry for my confusing
> wording.  Let me confirm my corrected understanding:
> 
> Before commit 54419bbd0ee3, esz == 0 appeared only when the quota was
> unset, i.e., the user has set no quota.  DAMON core therefore assumed
> zero effective quota means the user has set no quota, and the code
> checked quota->esz to tell whether a quota is set.  Commit 54419bbd0ee3
> decoupled "quota is set" from "esz != 0" by introducing
> damos_quota_is_set().  After that, the temporal goal tuner
> (af738a6a00c1f) made it possible for a set quota to have esz == 0 as
> well, for example once its goal is over-achieved.  In that case the
> scheme is intentionally deactivated,

From user's perspective, it may look like it is deactivated.  Technically
speaking, however, it is not deactivated.  Everything keeps working in the
normal way.  Just one difference is that now it has very small (zero) quota.

> and counting qt_exceeds is intended,
> not a bug.
> 
> Commit c7ec7d5f6b3d1 did not change the behavior I asked about; it only
> refactored the check into damos_quota_is_full().

Seems you fully understand that now :)

> 
> I will send a documentation patch in the near future.  Thank you again
> for your patience.

Thank you for your patience, too.  Looking forward to the patch!


Thanks,
SJ

[...]

