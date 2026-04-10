Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8B454F44871
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 13:55:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EF5C56B00AB; Fri, 10 Apr 2026 09:55:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ECD696B00AE; Fri, 10 Apr 2026 09:55:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E0A966B00AF; Fri, 10 Apr 2026 09:55:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id CC92B6B00AB
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 09:55:11 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6E8841B8240
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 13:55:11 +0000 (UTC)
X-FDA: 84642792822.03.8E88FB9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id D685940017
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 13:55:09 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PHzl6lDj;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775829309; a=rsa-sha256;
	cv=none;
	b=bKiH8izGo3MelDEGqy4iBUhTi47f+6sapC0dn/eKGdEvDMjBfdck+7sjmtEdhPwU1bFKYD
	v+t5hTajXtEnoHlupIzfhHyhciUKMnwueZFIzuFrSOGnOPZif+A+PWabJC6ETSjyrSnxqX
	d4KZSvh5ZrAJE4GSVZ6Codqzk4GjxDs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775829309;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+T/7wUv595u9IGPEk6THJwqDfjgDw/QDz90BMZgWBCc=;
	b=eHE7yXocaC+LKkSTHBhaTiaLqd+XzCK7c0uWe4/24AM8uBqIiO5DIHIx/pLAEyGW/EPOrc
	NQGmirlz2vkxztJcUVSeDGlAdhX+eTp+EEPxU1lTFIlEKb9RxllrFkP9a5efHdgpF3qoaj
	TeHq2un0fJLdr/RtfrPZk6SuqNYm1M4=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PHzl6lDj;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 402A060126;
	Fri, 10 Apr 2026 13:55:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3222C19421;
	Fri, 10 Apr 2026 13:55:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775829309;
	bh=trKoI4Hn/kEu3b4jFhAlMdwBIggZuH+tnFVJh94uDwg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PHzl6lDj3eE3f7u3YbcqoSb9aDfj+KrMEfAiSaeHoptZzNj/zQZ6d6YAdnJt9CsfK
	 5eWugCDExfoi0HjDhe/1LFhwm5+N347s5dhd991iKEoU4YjMN8eeTKOisC2Mv03uxF
	 hUfswlvGHrHe39K5i9pl4vDLSrTN69uiRCxHlF9o0XlncqaNtqxCKR5G29sK8ICwfN
	 Egfn7/cFvp4mx7KmxWhEGKXwRkfXvlpd51jC+hBgcOuxE7wRs/q5oJPM0M6ORelTR7
	 TU3y1NHmqgqAOHGdsTZuI8CozT9FdSZNl0knYXJeSD7Ri6BUi06/MVzV0K3reMkAX0
	 7z6qe7TnMqdtA==
From: SeongJae Park <sj@kernel.org>
To: Liew Rui Yan <aethernet65535@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: (sashiko review) [PATCH v4 1/2] mm/damon/lru_sort: validate min_region_size to be power of 2
Date: Fri, 10 Apr 2026 06:55:00 -0700
Message-ID: <20260410135500.81989-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260410094004.193555-1-aethernet65535@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: D685940017
X-Stat-Signature: s51wpfm7p5q53w37z3jjeqius89hdw9y
X-HE-Tag: 1775829309-38603
X-HE-Meta: U2FsdGVkX18EupfYOBc+saiEiDKlVO09HGSjDEvWMpZP/Jo6MhnaxK1PA3P1FbQRkIERD6TqSPNx2iy5KmInQT0Z2b1WutMWhZaTQLK+z7t+O6kq2b3Fulw5c8tk2QnuNuzillrweQUsOBjfaMTGzQQtABZLCn0REKG+JatatUyWdJDXmCwtuqSILkvdoBR/WzyoiP5V8ZaLdETxdPAbXZ1+KAy3m5FqovnsPG0pgLePvdfmA85fDFL+PxBDyNlot6Ijq1t/C927bpPFsCxEhuMTlaFIhFJqvWTuSAHou7cItvMz44H6HSAbWYe/Wg10u+x07vXYk1pi9EGKrUJtQKiyYvmwuOPvOX5rxmmFxReUtmNjgaIna1j1le7/LbHwJ8kvWgOgq08pxmnLRwEjBxh73et+WxpX7xvr+iuy14DLlJY41vZDZbVOqPCJj+DNZJJesDTYgD9zYp7nX4R7OEhln6kGTvhzn8zaTXKuqSf0ZPuHM+mKoPA9PwTO/nIhimM0sJDlDHWc1r+A5zspFyItQsdcffSsvCzAeTLwCcJJ+F/jYRbr6HUUZ0sEHaBH49g99kl1hRnJHwtmzbZ8jzEh0eN7/2izE+9b/dpQAezgWv7IITl1dsAV0/WdTGwF5Py/1iH1tyhof08E+PrnI3HsbKhZkpqj4YiqydFOW5hhxA+5sRNHBxzoKVjxuA+PSINqM+heR1tZDezoLD+xZXaiKGWZ4h0eDiXTSdaKpKkvdxMj9nRgd+goUg9WcmcOmreMEuQWI2+1oB2e+TsZQozqRx7FPpCTk6HHXqp3Hbg2bYps91OLqtgpNRj7FzZs0GI90LRd/7eAgJ2Ld0XAeYnHYvdo+UwA5zzCcq39qWvYSNf4fcOYhePHPFg2jNzpg3UYWv86Kr/ysd8j1JXQI8Bfii3WulsrF1ZTg03+xSrr0GRnhOJhsK3feFtV5FlPHsi3yeW86STQh6mprue
 APg68VYD
 lB/CLKErKwHyDp9eDRT5cQOdratqdXquFgLPlTPei8JktsCB0UQdUHv84UAiAGvSQfWd5n3Id1xVfvjbMVIPLfEZ5cVFbMMSW0bSkQF/ucU177Mgzs1aSvsYHbSTQfTm/mWhvg+UVUX2KeKrliafyJ5J2w/rZTVD8yqwht/OqZ7qLMeiE0etgiL1kDzSMg6zWb6/N3ee0D1zhFx+8OKSLdniL7aTCItKiWfKE49c7n2wGWoB2yjk2d/6fwl0ZN6nzd7e/Ee7hpJj2REULjyRechoDtGlWaGjo9KMnYFNnmPFuU5cBFKnrkgArkrRLSAf7l7xSgaKetDwzdXs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 10 Apr 2026 17:40:04 +0800 Liew Rui Yan <aethernet65535@gmail.com> wrote:

> Sashiko found some issues.

Clarifying what is the following action for the sashiko finding would be
helpful.  For example, if you say "Sashiko found some issues, so I will post a
new versiuon soon", and if I'm busy, I can save my time by saying "Ok, then I
will skip or delaying review of this version and wait for your next review".

Seems you think Sashiko found issues are not worthy to post a new version,
though, so I'm commenting below.

> 
> Forwarding full sashiko review in a reply format with my 
> inline comments below, for sharing details of my view and
> doing followup discussions via mails if needed.
> 
> > # review url: https://sashiko.dev/#/patchset/20260410044259.95877-2-aethernet65535@gmail.com
> > # start of sashiko.dev inline review
> > commit bc048f9325d07815d621e80f3c40408c0210af75
> > Author: Liew Rui Yan <aethernet65535@gmail.com>
> > 
> > mm/damon/lru_sort: validate min_region_size to be power of 2
> > 
> > This commit adds early validation for min_region_sz in
> > damon_lru_sort_apply_parameters(). If the user configures an addr_unit that
> > produces a non-power-of-2 min_region_sz, it immediately returns -EINVAL to
> > avoid setting maybe_corrupted and unexpectedly terminating kdamond.
> > 
> > > diff --git a/mm/damon/lru_sort.c b/mm/damon/lru_sort.c
> > > index 554559d729760..3fd176ef9d9c1 100644
> > > --- a/mm/damon/lru_sort.c
> > > +++ b/mm/damon/lru_sort.c
> > > @@ -294,6 +294,11 @@ static int damon_lru_sort_apply_parameters(void)
> > >  	param_ctx->addr_unit = addr_unit;
> > >  	param_ctx->min_region_sz = max(DAMON_MIN_REGION_SZ / addr_unit, 1);
> > >  
> > > +	if (!is_power_of_2(param_ctx->min_region_sz)) {
> > > +		err = -EINVAL;
> > > +		goto out;
> > > +	}
> > > +
> > 
> > Is the DAMON sysfs interface also susceptible to this regression?
> > 
> > When a user configures addr_unit via sysfs and writes 'on' to the state file,
> > damon_sysfs_turn_damon_on() builds the context. The min_region_sz is
> > calculated directly from addr_unit without a power-of-two check, and then
> > damon_start() is called, bypassing the damon_commit_ctx() safeguard.
> > 
> > Since the DAMON core uses min_region_sz as an alignment mask in macros like
> > ALIGN() and ALIGN_DOWN(), can this cause memory corruption or infinite loops
> > in functions like damon_fill_regions_holes() if a non-power-of-2 value is
> > provided via sysfs?
> 
> This issue has been discussed before [1]. While it's a valid concern,
> it's outside the scope of this backport patch. SeongJae Park has
> indicated he will work on this.

That's correct.  It's on my todo list.

> 
> > 
> > This patch works around damon_commit_ctx() failing due to !is_power_of_2()
> > by performing the check early, but does damon_commit_ctx() still have a
> > regression leading to unexpected termination if other allocations fail?
> 
> Yes, unexpected termination still exists.
> 
> This patch provides a minimal workaround for the specific case of
> non-power-of-2 'min_region_sz', which is suitable for backport.

I agree.

> 
> > 
> > If damon_commit_ctx() fails midway, for example returning -ENOMEM from
> > damon_commit_schemes(), it leaves dst->maybe_corrupted = true and bails
> > out without rolling back the partial updates.
> > 
> > Even the DAMON sysfs interface, which attempts to mitigate this using a
> > test_ctx dry-run, could experience a time-of-check to time-of-use race
> > where the test allocation succeeds but the final commit allocation fails.
> > 
> > Since these modules operate under memory pressure, if an -ENOMEM occurs
> > during parameter updates, will the running reclaim daemon permanently
> > observe maybe_corrupted = true and unexpectedly terminate itself?
> 
> You're correct. If damon_commit_ctx() fails midway, it leaves
> 'maybe_corrupted=true', causing kdamond to terminate permanently. This
> is a core error handling issue that needs to be fixed, but it's outside
> the scope of this backport patch.

Agreed.  This was unclear to me in previous disucssions, though.  I still agree
it is out of the scope of this patch.  But now I think we need to let users
force-restart.  Adding this to my todo list.

> 
> > 
> > >  	if (!damon_lru_sort_mon_attrs.sample_interval) {
> > >  		err = -EINVAL;
> > >  		goto out;
> > 
> > 
> > # end of sashiko.dev inline review
> > # review url: https://sashiko.dev/#/patchset/20260410044259.95877-2-aethernet65535@gmail.com


Thanks,
SJ

[...]

