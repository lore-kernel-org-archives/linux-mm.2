Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B30AFC87FCB
	for <linux-mm@archiver.kernel.org>; Wed,  6 Aug 2025 00:40:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3AA798E0006; Tue,  5 Aug 2025 20:40:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 35ADF8E0001; Tue,  5 Aug 2025 20:40:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 24A1E8E0006; Tue,  5 Aug 2025 20:40:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 155D88E0001
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 20:40:11 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9448C81135
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 00:40:10 +0000 (UTC)
X-FDA: 83744475780.07.98B86C7
Received: from nyc.source.kernel.org (nyc.source.kernel.org [147.75.193.91])
	by imf14.hostedemail.com (Postfix) with ESMTP id 2E5ED100006
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 00:40:09 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=L2U9Zsxo;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754440809;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=h/HalD+VWJTaJwsr3U7caliHaIGY9hM+wzU24Osvra8=;
	b=h6Xb2nJir9E80apwXicebhuSSfxf3VTlfAiqxw+8w6gf56lkjTDe1Ima3mywboDuj3Srva
	o5eXY7fUIsbly9hLJi1bvdVVkc+JW6gxzVHp+BbGfXeibK+cRvbVCREkZRGY3gCNJkBurA
	iQSj1VvZTy0jruQGp/L8AaBp2c6t9k0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754440809; a=rsa-sha256;
	cv=none;
	b=N3cX8mwLLc2NnbF8j0N+TK3wZxdLkaJRr52oDyh6TPpLPVd8YRopYuMZapbikv99WdMbsh
	7QDGkjviZc6ZIq6J0Vy8LHJQ6hgaMPRT74Jp2d7k3Zi/7YfojvbFdJXtGFEiEL7KXDt5vc
	Y4jV0Xb4jGH+a6daAPqiniV6JFCAU6E=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=L2U9Zsxo;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by nyc.source.kernel.org (Postfix) with ESMTP id 70333A5675E;
	Wed,  6 Aug 2025 00:40:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8D55C4CEF0;
	Wed,  6 Aug 2025 00:40:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754440808;
	bh=fPjD5D3HDLu3NtemT8rWbSgbD6qYNtA8uvatr0PW7QA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L2U9Zsxong5pC1ZCBOpeRRRkjZSlaDbpCpf36zSl0CRMtDzkH3JiV1H7RrMQP+W0y
	 dzXlMKgr71kVEzpOb0H+dYBsRzNT9MCliE8CVG3YLQbV9E5xbQteffDqRG5aW4Su+O
	 FXvwY/28e0XnP4znopWCug89r5I+cmj7Jfulh+ecw7AMp6eTSy/sKE5/Km96j6crT0
	 qAYpHUTeAK5cHjX5K3hd2hNEZsr/tp/3Uh1qKMOlJem5xYbFs7IMfDjc4Hi1hdkEPa
	 /HgzoMuKAbRn0Z78STDLuptxuBQGfZsGhaQZqHXZXyKM9Z0Se/n3lkMiQQN/Q61tea
	 X68lGEcLgl2hw==
From: SeongJae Park <sj@kernel.org>
To: Bijan Tabatabai <bijan311@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	corbet@lwn.net,
	Bijan Tabatabai <bijantabatab@micron.com>
Subject: Re: [PATCH 0/5] mm/damon/sysfs: Add commands useful for using migration dests
Date: Tue,  5 Aug 2025 17:40:03 -0700
Message-Id: <20250806004003.52864-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250805162022.4920-1-bijan311@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: u5ihhcx1bteyw3jcm5z6gewfq8888e5g
X-Rspamd-Queue-Id: 2E5ED100006
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-HE-Tag: 1754440809-994988
X-HE-Meta: U2FsdGVkX19cGiKF3j2URHTM7FTK2Y3ADuNsgquxgoJI6FzVtmABO518pPL4BDNskjWyD1TTP8Zuj3a6LFMTCFMzkd6rZ35eTfCOJpltDoTDpP3XU5As91048GEQ+A4/7BPfAw/4IEq8niTtXIwxnHJW9Ly1Ii/K84THqyZNQzBw5/0nmSmxjzgr91vnC4y0M6PCOtm1z2zliNdFQN0m2eHIoNruThcOFl9NnldHzCiUZF1y4wes3SVpia105BMDNX/WPsnEXMKHfJqtxrGDveSk3ZzgIrAwppUUAZ0RM7wh0tnmsf9UsQYsxiiZQ6h8XaL6wTcADmCAqEtf2jdNiY4pJOkiLuEZrR/wtdUuqgpbS7JCqHwgEaRHnVYCd3Ag6IB7YN/0yc8HOOte8qiRIEg2yDDp4zxHlWh+7j6JQlb4w3hsJfxwOgyLULI6HD3HMqTbJV36HLlTHDNIN1pyvk7HFYNjE0WT8Tyz/DWHAZLqfwtGqIhdKOlDcTupjOJi4BGHA51241L/x+PMgeWdSYs0VNb9R3MHL4JTuPuStxoxffs8Dso6m6pAlbK5XWXe4tBZO6kzNrta3vUcRI5CSzpu9gmDvtNqmcTXWnaSafpDkPRScRWGOX7vDCwHuH5u/nK9Ft2T2UE2JXHmqeSB2+95HP4Lt0COk22VRlfsF5qgU4UuaWrTMHlRJScbQGTzJVvth6VY/MRKUXGJt4M97PXOu7HTxu1HPGu2FE8iD4xFBIX2VICTBbozudHJHi3OkFWg6Vm6X4A0iPZcusYQ1LOyq0KgyZB9MOv+ljxA32wi1skajBXF6VXUFSGfEKKvIojiaJlEVpYwKnZRtzRJJ0/asoDiAuxg3w+3rgLu3M7dGt3syLr5ZM0Bq4TetgxI60YpnADWxmtpBFf9dN4Z+dWtb93RveXFWZnOuzVjU03EXi1nqaKJzg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Bijan,

Subjects of patches usually be converted into lowercase when be merged into mm
tree.  I'd suggest using lowercase even in patches stage, if those aim to be
merged into mm tree.

On Tue,  5 Aug 2025 11:20:17 -0500 Bijan Tabatabai <bijan311@gmail.com> wrote:

> From: Bijan Tabatabai <bijantabatab@micron.com>
> 
> This patchset adds two DAMON commands, commit_schemes_dests and
> wait_for_schemes_apply, that I have found useful for using a migrate_hot
> scheme with migration dests.

Thank you for this patchset!  I believe we shouldn't be afraid at adding
features, but should also be carefult at making good solutions for real
problems.  So, my main response to this patchset is, hopefully unsurprisingly,
I'd like to better understand the requirements and the problem you are
encountering.

> 
> The commit_schemes_dests command, similar to the existing
> commit_schemes_quota_goals, is used to commit only the dests fields of
> schemes. This has a couple of benefits:
> 1) It is more efficient than recommitting all the DAMON data.
> 2) Doing a full commit resets the aggregation and ops_update intervals. If
> a user sends the full commit command frequently (relatively to those
> intervals) the aggregation and ops_update events will be prevented from
> triggering. Having a separate commit command side steps this problem.

I agree the commit command of DAMON sysfs interface is inefficient, and could
make the infinite intervals delay problem.  But, I didn't expect there could be
use cases that use commit feature frequently enough to make the inefficiency
and the intervals delay be real problems.  Could you please let me know more
details about your use case and how severe problem DAMON is causing?

Depending on the real problem, I'm wondering if optimizing commit command can
be a solution.  For example, skipping the update of next_aggregation_sis and
next_ops_update_sis when the intervals are not changed might be able to solve
the intervals delay problem.

> 
> The wait_for_schemes_apply command causes the calling thread to wait until
> all schemes have been applied. It does this by calling damos_walk() with a
> NULL walk_fn. This can be useful, for example, if a user wants to know when
> new scheme parameters they've committed have been applied. Another use case
> could be if a user wants to record the system state every time a scheme is
> applied for debuging purposes.
> 
> The functionality of wait_for_schemes_apply can be achieved with the
> existing update_schemes_tried_bytes and update_schemes_tried_regions
> commands. However, having a separate command avoids extra work and makes
> user intent clearer when used in scripts.

I agree extra works are always better to be avoided.  But is the overhead large
enough to be a real problem for your use case?  I also agree it could make the
user script cleaner, but adding a kernel feature only for user scripts
readabilities sounds like too much, since the user script could have its own
abstract layers for its readability.

Also, even if the new command is implemented, since the DAMOS schemes continue
running, the system status will keep changing.  If you cannot do the recording
of the system state in a restricted time, the recorded information might not be
that reliable.  So I'm not sure if you really need this strict waiting in this
way.

Could you please share more details about what you want to do with the new
command, and how much problem you are seeing?  I'm particularly curious what
system state you want to record, and why you need to wait the exact time
interval.

Depending on the real use case and the problem, I think we might be able to
reuse the DAMOS scheme stats, or implement more strict and reliable time
control features, say, making kdamond or schemes pause and resume as users ask?


Thanks,
SJ

[...]

