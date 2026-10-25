Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 094C7606A31D
	for <linux-mm@archiver.kernel.org>; Sun, 25 Oct 2026 17:41:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gtTWEkq6
Received: by kanga.kvack.org (Postfix)
	id 23EBE6B05C5; Sun, 25 Oct 2026 13:41:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1EEFB6B05C6; Sun, 25 Oct 2026 13:41:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0B70C6B05C7; Sun, 25 Oct 2026 13:41:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D92326B05C5
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 13:41:48 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 72401160602
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 17:41:48 +0000 (UTC)
X-FDA: 85361866296.07.96BB1FF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id C02BA80006
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 17:41:46 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gtTWEkq6;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792950106;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=I2WtUHFl6q3jEaDUWNmi7N1mxbLsBs8YwHkyGeQMjiE=;
	b=eDUE6YBuuYnhBSKW91kDUOBP2jYcuby4z5PIrHCFTkcHQULZZS7wCJRijKONX6+Y+amRJP
	iE3GA4KCTu+1FhRwNYbCygkHfZ9fEL2e+WJurp7Db963Ik7nfwIJMfJk5haVyupVjSKX6b
	iiVaZfj9ruEPrs2VLF9wz6gdMfWVUPI=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gtTWEkq6;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792950106;
	b=caOmYq27n+SuyjRQkQlXx2wn4Hhk2zLcSiwp+NL0hxwZwnnA85Q9uXs2F1yZ+JDEI6X5GF
	6IKvnSedxFLtxkynUtCI1SZM43IipUIIhyqVitoIpOeghDU7wSpINTeOnGzaUG+ZCDUcYz
	p7njgP9Euf2Hxn1SzFPDRj5Tqt6ySZs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id F2A4D4061E;
	Sun, 25 Oct 2026 17:41:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8CE81F01825;
	Sun, 25 Oct 2026 17:41:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792950105;
	bh=I2WtUHFl6q3jEaDUWNmi7N1mxbLsBs8YwHkyGeQMjiE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gtTWEkq68BRCPoTIMh/xO2jcf7f4SPpTFGWwXwq3E+wsK122kGaF8zXok9jR/4ZwW
	 8jXUegn9aA4my0YZKQ+VoLwvuP1ySGFzRlsL8J/ySPK+lzgeHn7mgyVbnJDY/uq3vh
	 ALqs+4RkE0tlxu4sirGRTyN324EqcvRY3rZoGoZGFSAzSBqX2wi0/64q50XKiX1azK
	 Z3Y26TYLpi60/C9QUi2isC42QrXulVGNLUtcuMbSvW3A3zJqGEkNZOCDSNDdN53i63
	 1L2CLZBqaO4H9ECs5Gyh+6rBXisrCM69tNZyEIBz6Jk2RLN4FfyP9xgrx5prhIcnEz
	 uazf+MjPeZO9Q==
From: SJ Park <sj@kernel.org>
To: sashiko-bot@kernel.org
Cc: SJ Park <sj@kernel.org>,
	"Andrew Morton" <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: [RFC PATCH 6.18.y] mm/damon/core: error damos_commit_quota_goal() for zero target_value
Date: Sun, 25 Oct 2026 10:41:37 -0700
Message-ID: <20261025174138.165096-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <sashiko-outbox-184295@kernel.org>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: C02BA80006
X-Spam-Status: No, score=-14.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: t81pehjfjnc14ww18yjg8ppy89xc5idm
X-HE-Tag: 1792950106-489287
X-HE-Meta: U2FsdGVkX1+2W4OwlxYeZrW2L9jqKIAtukWPZdiblZHJyhPsTxfQGu8bDQxyPQwzHZ83uvUFPp4i9233xj8cT9A/I2qWMCUcreIPGuTfga4B5qFjeVWRoobGExPFnXDENA4oKn5P90sDL9r77/B7zjwpaK34ch0xC7S1h30qGNnaFkAYr6mj4g/qbH2WnBEPaRCsoSb1VsU4cqEPsAsRVZPPsTlzE5N0WNhbHaVx5o1gZ9US5MrABrYAC9ygWqOwkDCKcblQrTYI2spvZAx5nl2diy08nC8EL6RgfQTOB1vp2HpY9+ljiOe4P9dhEJoXHctuS1H8KgyHOd7vWOBNOQNcrdrb5MbpBp7qCdfgwFaP2RIpConCiiOevgw3UGkq8378l6SD/dtzStqdBxE3Nm/8lql9J/pcdk3uyiy77qQ+kd627eLQRiM9+ifDSsqUqt3Rzvo/Ag4tCE0JelYhDZDUHcG2/YEULifHqPUmAEZNBb/DEmqBFgaFeEXpmB4NKffV5X9+dqFc8d581l9dyin4EKs0G4gQnsQdYJeViMZBlvq+7i0PyHluTQ+3lmP+s4ooeIpt/U9KtzTTFoxbOiTfttMWWCkUNUCiEkJl58Jipe+Ngzd5B3BpiMnKEs3YwErIIE6C5i1CI8u7mDaLO7tnAilARZZ+RFvfRCqrCTWtIQKbtlgeVSczQI02YfiyWRYPTH6MX1ztyGp7vwnKXHyygQY3wqH0rlC9psOzu+k/AJyj6FTe06yLu7iFt91MDs8Pvj3BtHT3dFSNWr/ALzVcNAowZru+3nHphdtfPh9WCq/RhP6b7QfKTQe0TtjoATDjvEa8Qd/haN5k/5X4lYU03j3nFLpRi6J0YCjp18+NWv+I+wuswyKU2Ds4WgHY9w12DJM5lDwcY5AUzVFz741EMBju49d106ZlIrIwlgdmVWBhq5COos9zVEz8MWvHkckf9fBAuqgPUVwJZYO
 IrHoWf5I
 Y64vn2P7aLjMoJyNepxO7GBoj3HuDe4yb1A3Imh2YY0gl1eMFFacV6tCPNaLZ9pPfl6G2rkqptbBflUEFxAGCUqTFHEINOeUNTsJkQQ45OCMDUcMMKQ4OxyytdtzWJKhFEo3jEUdqiOO53ZhVtOPZao9kxGLe7JrVD3vLfTtG1Aokf4sC7Fb2LGBVyJKK9Ulqz+KpB/OIiXBamjIQRRUIe/8+LwmGp+KZzUdKzYa6VLHH+Zqp58RADyLdSVdP8zz4Tny4JIxKP/+EPBGc3kg8X3iKL9DtSzcysT/Y3BEyKBEm7Dl/UGdO0yOCZXVrAELozNbHzFwQuK85G2eM/nn3F2JpyS/HLCRtD7ViEIrHEStaj9yq5Am5GbUgMA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sun, 25 Oct 2026 17:37:55 +0000 sashiko-bot@kernel.org wrote:

> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [High] mm/damon: incomplete zero target_value check in damos_commit_quota_goal()
> --
> 
> commit ea716ea29282ef733822096401c5c8d92eaaef58
> Author: SJ Park <sj@kernel.org>
> 
> mm/damon/core: error damos_commit_quota_goal() for zero target_value
> 
> This commit validates that a DAMOS quota goal's target_value is non-zero in
> damos_commit_quota_goal(), returning -EINVAL and propagating the error through
> damos_commit_quota_goals() to prevent a division-by-zero in
> damos_quota_score().
> 
> Link: https://lore.kernel.org/20260903010722.94244-1-sj@kernel.org
> Link: https://lore.kernel.org/20260903010722.94244-2-sj@kernel.org
> Link: https://lore.kernel.org/20260803134034.15217-1-sj@kernel.org [1]
> 
> > diff --git a/mm/damon/core.c b/mm/damon/core.c
> > index 4e6e3d7d0a5c0..8fa788b0d709c 100644
> > --- a/mm/damon/core.c
> > +++ b/mm/damon/core.c
> > @@ -807,15 +807,18 @@ static void damos_commit_quota_goal_union(
> >  	}
> >  }
> >  
> > -static void damos_commit_quota_goal(
> > +static int damos_commit_quota_goal(
> >  		struct damos_quota_goal *dst, struct damos_quota_goal *src)
> >  {
> > +	if (!src->target_value)
> > +		return  -EINVAL;
> 
> [Severity: High]
> Does checking for a zero target_value only in damos_commit_quota_goal() cover
> the path where DAMON is started via sysfs in this stable tree?
> 
> In mm/damon/sysfs-schemes.c, target_value_store() updates goal->target_value
> without holding damon_sysfs_lock:
> 
> mm/damon/sysfs-schemes.c:target_value_store() {
> 	struct damos_sysfs_quota_goal *goal = container_of(kobj, struct
> 			damos_sysfs_quota_goal, kobj);
> 	int err = kstrtoul(buf, 0, &goal->target_value);
> 
> 	return err ? err : count;
> }
> 
> Meanwhile, damos_sysfs_add_quota_score() reads sysfs_goal->target_value twice
> without synchronization against target_value_store():
> 
> mm/damon/sysfs-schemes.c:damos_sysfs_add_quota_score() {
> 		if (!sysfs_goal->target_value)
> 			continue;
> 
> 		goal = damos_new_quota_goal(sysfs_goal->metric,
> 				sysfs_goal->target_value);
> 		...
> 		damos_add_quota_goal(quota, goal);
> }
> 
> If target_value_store() writes 0 between those two reads,
> damos_new_quota_goal() allocates a goal with target_value == 0 and attaches it
> to quota->goals.
> 
> When starting DAMON via state_store() -> damon_sysfs_cmd_request_callback() ->
> damon_sysfs_handle_cmd() -> damon_sysfs_turn_damon_on(), this branch builds
> the context and starts kdamond directly without calling damon_commit_ctx() or
> damos_commit_quota_goals():
> 
> mm/damon/sysfs.c:damon_sysfs_turn_damon_on() {
> 	ctx = damon_sysfs_build_ctx(kdamond->contexts->contexts_arr[0]);
> 	if (IS_ERR(ctx)) {
> 		kfree(repeat_call_control);
> 		return PTR_ERR(ctx);
> 	}
> 	err = damon_start(&ctx, 1, false);
> }
> 
> Here damon_sysfs_build_ctx() populates scheme->quota.goals via
> damon_sysfs_apply_inputs() -> damon_sysfs_add_schemes() ->
> damon_sysfs_mk_scheme() -> damos_sysfs_add_quota_score(), bypassing
> damos_commit_quota_goal() entirely.
> 
> When kdamond subsequently runs kdamond_fn() -> kdamond_apply_schemes() ->
> damos_adjust_quota() -> damos_set_effective_quota() -> damos_quota_score():
> 
> mm/damon/core.c:damos_quota_score() {
> 		highest_score = max(highest_score,
> 				goal->current_value * 10000 /
> 				goal->target_value);
> }
> 
> can this still divide by zero if the race occurs during
> damon_sysfs_turn_damon_on()?

Nice catch.  I also just found this issue while working on 6.8.  Same issue in
the patch for 7.2.y [1].  I will withdraw this and that, and work on the next
spin.

[1] https://lore.kernel.org/20261025172434.161597-1-sj@kernel.org

> 
> -- 
> Sashiko AI review · https://sashiko.dev/#/patchset/20261025172712.164385-1-sj@kernel.org?part=1


Thanks,
SJ

