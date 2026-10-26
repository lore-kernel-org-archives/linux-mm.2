Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D16F8606A31A
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 15:08:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NCcwr8l9
Received: by kanga.kvack.org (Postfix)
	id D8D536B05B3; Mon, 26 Oct 2026 11:08:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D16F26B05B4; Mon, 26 Oct 2026 11:08:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C05D36B05B6; Mon, 26 Oct 2026 11:08:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A06326B05B3
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 11:08:35 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1BD4A80767
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 15:08:35 +0000 (UTC)
X-FDA: 85365108990.06.1CBBF98
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 0A03314000B
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 15:08:32 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NCcwr8l9;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793027313;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nNXUTVFn4ste1wqd8vmAxSpwftg5otrNRXmIT6BWIlw=;
	b=wa7NqpKgZr+HPOAlDH91/g/+soC3aDzKzHzP4Fen6sI49nLXyGYMG60aNHa4x4pGRN7bcs
	cXruRF21jsDlVdM5+en8dxBd5EWeB15AokRvjJxZyDiugZXIshMgh8D4odp+fNxEB/71rp
	HmdRS9QhADfMbvTtYuRp1sOw4Ubs6Zs=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NCcwr8l9;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793027313;
	b=V3coNJaM52IXtnQtHYd/kZZMGft7y7UeEUOUhXSUA63hi7sySjIXrXysX2hCHGsdJ95TZ/
	IW8sdgkqkU+g1zrDlfncmwRkTw87OqtybYcOB0/AK8CZQfO5cUsAen+a+w+CjuJGpAYZQX
	f6mfVpo6xtXCZO1wBaYJDpvAsMoy7eI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 82D99600DA;
	Mon, 26 Oct 2026 15:08:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B8731F01825;
	Mon, 26 Oct 2026 15:08:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793027312;
	bh=nNXUTVFn4ste1wqd8vmAxSpwftg5otrNRXmIT6BWIlw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NCcwr8l9A+OwZ3fur1MZwljx7AVLXFA8Jfla3QPDnCJBLp8cBIjtUBqz0sgPoIok9
	 YVW9ArL+npfG9DTPxSueUFV2wDO8Xsdvrxs2Bfa60xo8ZvzsAmucH++Aww1gOXNO2g
	 0Ciz21JONsjlHYm/Hw9K1/ctQZElaFVhE7IuHUy+ch43+el9b2pQs6YIFT7kLdFQYy
	 jZOf/QmOA4Ut1EEVxouaHofHQWqOCkP+zqEJDk8cXVq03OOY/p3Jq++BPAD2DdiCyk
	 FlftrmtrdN+TUQqa0ndaC8LvYiwtzKVFAXuT0uNIbLLpiiTSH9rB18Sfe4eZZoO4Sg
	 bWEnz3BRSvR/g==
From: SJ Park <sj@kernel.org>
To: sashiko-bot@kernel.org
Cc: SJ Park <sj@kernel.org>,
	"Andrew Morton" <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: [RFC PATCH 6.12.y v2] mm/damon/core: error damos_commit_quota_goal() for zero target_value
Date: Mon, 26 Oct 2026 08:08:23 -0700
Message-ID: <20261026150825.152576-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <sashiko-outbox-185379@kernel.org>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 0A03314000B
X-Stat-Signature: hko9x6p3jbrwjsau5h19haq4sd9dxkrt
X-Spam-Status: No, score=-14.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1793027312-700802
X-HE-Meta: U2FsdGVkX1+DVaoKlEshss/hl5p9KgNiE8SKyiRddv0zX677psldH9BNInNnS+/yxb5ekLNAFwnawvyEBFQVo/aLLr0DDFNYUwvMWXHe1D94/lpm94TNxrnPXtgmyvmcMaEe7dxjCdup6ndidWHI0QvnFVmATwkXj8pZ8SPrggTrtOqHtHKbmGHQQgXBWNn7JpwkhvTPdcMNWHCgiHfIq/Es0Kglx3Ymhnc7H1KCWU8PT3S1zmIOv86PK9PGrzGaLd9VbUyJpsaEvJ0Z7T1u1yU4gqpZkpCq5LKZIn8+QNYRio+Gt8Z1/aS9avrICcpwHqFq6G7oA4l4uO03OmXpggrtl+VBtXDObhJXF78q4uTOBHTagCjaSWW4w7nUuH+2Wm4/JR9wPLC6Y4D64g+9iTsHoB/VIO97Pg1JEZMKfm1lKTddzcThFBfLDGQmClsJbPT6/MsiW/mWanWqrznuPw9aduQhWCtVprdFhOVrGFnc3UBBF8BWpcGW4OaKQie236qwQHg/khW4CXLm0OpFxOfHQm5OcLiDm6CF47UzY1Gx2s4IQKMQsxwAke85SgMqCsSmuHauNItvaspHAULy8NmcbkkzwLMjba+9rLH7sTC7Lr2KMz9W+CzS2q8r7VUROecyY3c8oY9KrttcUUuCr2gBzODZt8ojmXhSo+VwfeXeK05O80TgfH6ObesfOJ4uxrXhUavYUgv6ishabY5cQRFnEPnju7u2wdyHhRIefr5Tvix/0pipN/WbB+IbKJduLaDpNO5wxkfBi6liy6KAANX+35+3G0ATZRhj1iSiZv3JuSIPwhSuhO2jS7pGDXymhkvxVKt2BJ1bzpkeJLLUv15IM0UkrEDZvvYEXSN57Ir1HKveXOIvFg9F+bD3ytkvfkNSakFohW2l8h3urxDANtgRSf4qAeiFHmEe3np+U/cNQ35sIYYm3kq6QmKohM6Oh+DR9R5QB9a7khR9eUK
 Te/YYv5Q
 bC43fKXh/dEJrK89gwvjpvELwYXcPP9l78/aKzrXSkPY/DwUR5s1RpYbMxK/N0K1wlHdcMeUVdtHbt85mVIjRes536DGb+vh+DuBipncAbhP6TbrXTm2a0TZMpUzpEyGoG7Rg2ncNeqULY+c+e81LSV8kxxz00CjeH1oJNtQXGSgkBraw7t2oZmbLD3PZ7M+/zjz/WBB2Th35xiZRfz3URGyBTF7prSJI2XdKP8tqblX2QshlF25lVSHmM+7S9kJFzI4gQrDlAEa3QRqz2PkS2Dr9xZr5Q3raX+XiaA9v7VNwIjYzViD4TPxpjGglRGJnhRLQd0C6X9119OQAAbigh319sTfU8Ix+KX4UGLQAthhnsbhgs/hZJuLD0w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, 26 Oct 2026 14:11:30 +0000 sashiko-bot@kernel.org wrote:

> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [Medium] mm/damon/sysfs: pid leak in damon_sysfs_turn_damon_on() on invalid start ctx
> --
> 
> commit dc23c827b1a01b5ed768b0a218bb6a67def40106
> Author: SJ Park <sj@kernel.org>
> 
> mm/damon/core: error damos_commit_quota_goal() for zero target_value
> 
> This commit validates that DAMOS quota goal target_value is non-zero in
> damos_commit_quota_goal() and damos_commit_quota_goals() to prevent a
> division-by-zero error. For the stable backport, it also adds
> damon_sysfs_valid_start_ctx() to reject zero target_value before starting
> DAMON in damon_sysfs_turn_damon_on().
> 
> Link: https://lore.kernel.org/20260903010722.94244-1-sj@kernel.org
> Link: https://lore.kernel.org/20260903010722.94244-2-sj@kernel.org
> Link: https://lore.kernel.org/20260803134034.15217-1-sj@kernel.org [1]
> 
> > diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
> > index 5aa23c6545cb8..2c8749b62c621 100644
> > --- a/mm/damon/sysfs.c
> > +++ b/mm/damon/sysfs.c
> > @@ -1497,6 +1497,20 @@ static struct damon_ctx *damon_sysfs_build_ctx(
> >  	return ctx;
> >  }
> >  
> > +static bool damon_sysfs_valid_start_ctx(struct damon_ctx *ctx)
> > +{
> > +	struct damos *s;
> > +	struct damos_quota_goal *g;
> > +
> > +	damon_for_each_scheme(s, ctx) {
> > +		damos_for_each_quota_goal(g, (&s->quota)) {
> > +			if (!g->target_value)
> > +				return false;
> > +		}
> > +	}
> > +	return true;
> > +}
> > +
> >  static int damon_sysfs_turn_damon_on(struct damon_sysfs_kdamond *kdamond)
> >  {
> >  	struct damon_ctx *ctx;
> > @@ -1517,6 +1531,10 @@ static int damon_sysfs_turn_damon_on(struct damon_sysfs_kdamond *kdamond)
> >  	ctx = damon_sysfs_build_ctx(kdamond->contexts->contexts_arr[0]);
> >  	if (IS_ERR(ctx))
> >  		return PTR_ERR(ctx);
> > +	if (!damon_sysfs_valid_start_ctx(ctx)) {
> > +		damon_destroy_ctx(ctx);
> > +		return -EINVAL;
> > +	}
> 
> [Severity: Medium]
> Does this error path leak the target struct pid references (t->pid) when
> damon_target_has_pid(ctx) is true?
> 
> When damon_sysfs_build_ctx() constructs ctx via damon_sysfs_apply_inputs() ->
> damon_sysfs_add_targets() -> damon_sysfs_add_target(), it acquires a struct
> pid reference for each target:
> 
> mm/damon/sysfs.c:damon_sysfs_add_target() {
> 	...
> 	if (damon_target_has_pid(ctx)) {
> 		t->pid = find_get_pid(sys_target->pid);
> 		if (!t->pid)
> 			goto destroy_targets_out;
> 	}
> 	...
> }
> 
> Because damon_sysfs_valid_start_ctx(ctx) fails before damon_start() is
> called, kdamond never runs and ctx->callback.before_terminate
> (damon_sysfs_before_terminate()) is never invoked to release those
> references. Calling damon_destroy_ctx(ctx) invokes damon_destroy_targets(ctx),
> which frees each target without calling put_pid(t->pid):
> 
> mm/damon/core.c:damon_destroy_targets() {
> 	struct damon_target *t, *next_t;
> 
> 	if (ctx->ops.cleanup) {
> 		ctx->ops.cleanup(ctx);
> 		return;
> 	}
> 
> 	damon_for_each_target_safe(t, next_t, ctx)
> 		damon_destroy_target(t);
> }
> 
> In comparison, damon_sysfs_commit_input() cleans up an unstarted context from
> damon_sysfs_build_ctx() by calling damon_sysfs_destroy_targets() before
> damon_destroy_ctx():
> 
> mm/damon/sysfs.c:damon_sysfs_commit_input() {
> 	...
> 	err = damon_commit_ctx(kdamond->damon_ctx, param_ctx);
> 	damon_sysfs_destroy_targets(param_ctx);
> 	damon_destroy_ctx(param_ctx);
> 	return err;
> }
> 
> Should damon_sysfs_turn_damon_on() also call damon_sysfs_destroy_targets(ctx)
> before damon_destroy_ctx(ctx) here?

Nice catch.  I will fix this in the next revision.

FYI, this patch for 6.18 and later kernels doesn't have this problem, since
they have commit 7114bc5e01cf ("mm/damon/core: add cleanup_target() ops
callback").  The commit made damon_destroy_ctx() to do the pid reference drop
by itself, and merged into 6.17.

> 
> -- 
> Sashiko AI review · https://sashiko.dev/#/patchset/20261026135555.149244-1-sj@kernel.org?part=1


Thanks,
SJ

