Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB038606A31A
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 00:52:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=C8rASglm
Received: by kanga.kvack.org (Postfix)
	id E30076B058F; Tue, 20 Oct 2026 20:52:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DE0D76B0590; Tue, 20 Oct 2026 20:52:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CF60B6B0591; Tue, 20 Oct 2026 20:52:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A5B006B058F
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 20:52:44 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1E67712041D
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 00:52:44 +0000 (UTC)
X-FDA: 85344808248.22.07DE9A7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 745DA80006
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 00:52:42 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=C8rASglm;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792543962;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qb7Js6jWEBpRBnpheoU8QyOWSaJyuXRnZgnX25ZrCeE=;
	b=W5fCu96+yLuSxzsg/XnvdlisZY6WhAxHL8Qw/RXV3gYupfnaCmdqVTQSm2WEknYJiltO65
	6XXa80tVhR6uTaxS95btPvCRCBds3Ve6tHXpuFjD+Hgob5ngrLEZ62twY++SIdhYwPuqJb
	2tHs87w+oV2XKnwawXlY2UlSplHxzgc=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=C8rASglm;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792543962;
	b=6H1wE3BXai1KAVivDLvy//0r32vjlPPD327rzr2Q8bJUgLtCbGyZ79HJB3X7Vd5KdWk2YI
	kVlSs2diMEUYB9fWJh+nvvEoV/KOGRQ7TwLHxQC3kqm95Rxli1fA7lTLOUYqjUYDO5MTs7
	dsEwxpKpRc3yLe3cMTEeg0mgmY+lai8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6663140483;
	Wed, 21 Oct 2026 00:52:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B2DE1F000C9;
	Wed, 21 Oct 2026 00:52:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792543961;
	bh=qb7Js6jWEBpRBnpheoU8QyOWSaJyuXRnZgnX25ZrCeE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=C8rASglmwgB/cfgmQpR3BhfADDtX2fNF7GWL6In14mCOE+7W/rqFn5M3uhVDLpxJr
	 6S28YT++pE4ykJTY0DVVUSv1WsetHBeFietptrPkMiJZtpk8SzuRmmvEdQEt5yYoKN
	 uBYX9dN2xveE/0IHIFcPHw9up4OccSABaDGN64neWWm2VvzKYZkiTVgPmgghjnzENW
	 ayrOjrG8ZuyxMLPv/KMvx+OCmp9stf8zU2s5OUr3MjUoVLguMvTUW52jxYcckGHHgN
	 FrJOrAztHPAb9fz2Gryaa2n9u9k2udQ+58y8Yflb2Kvnp4Z7Eiq3l9jM1125SgNBP7
	 BO2ISMCwFpdAw==
From: SJ Park <sj@kernel.org>
To: SJ Park <sj@kernel.org>
Cc: stable@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [RFC PATCH] mm/damon/sysfs-schemes: hold damon_sysfs_lock in target_value_store()
Date: Tue, 20 Oct 2026 17:52:33 -0700
Message-ID: <20261021005234.94107-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261020144726.88978-1-sj@kernel.org>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 745DA80006
X-Stat-Signature: kpijofjrhzhgakjnxr45ys5q58ojx8fy
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-9.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792543962-851887
X-HE-Meta: U2FsdGVkX18JX2TB1bLMfXwaiRuorDXgtC8FfhmS0w5a12igRvRfbEGp9+UxaFdJ7PchCcIdOAqqMZDRDGzHLCzq9/iC74ejSHEBz6rNN0CeqeVxQ8vqRH2GvNNF8KBbGbpvwr+vXI/7wyVKivXacmxCMee1wKqoixRyiYVsgghvSSJgBrU718IGMWTsMiS+hQ1/3kF0zH6rWL1bi1Vt3KfLM/hUmR+Lb4r5RApFintgYon5r+8TPuByO4gddaQMaY387o0ozTzMGkXawMvpr1cwrH9zJBF6yLaHhdm/6kpEg5M1pah8YkublDbT3lBlxruE1YD44q4EsQ68cv8qGCyIZle+G6ekTLHZNkvVuwt0MOG7A3RUrwDRKHLLVKLRSmA8MYscdyol5LSCMOiuor4BZOxx/u5zWMA9cPtJg3ny8R7ehypPof+WueNTg2Rs4ImvxpQq7fGk9pz6Jzoffhut8zj8LAFr15y9joqAmJeUw7++g/Y5pK7USU4IG2OfFxDxI2fcHNq9T2jiF5fODV4xAsaqmxwCKNi67nS690hj9JOrtaPBWpDW7HCAFG4L1H5MTjIK0axTTq0fgmYF0xnTxVzLG2b928y9p0CeFNvENR1D+SjcQJd2yX75Z7jrXp8HGiI4w6zZO/pPJQ0ySRzakBd7A3oWrf+wdpG/9C0Xuge5m3ynrFYUo+gnGWwx6CG2TROOTD75d+kGh5pplm5IZ0cxT56Yf1V7mUxddO/qfA5HF6PWhA0fORNi17u4RzVA+xkCi4E4/RpjuSeA8dU30HRCwXYbUeocmKYRzh/yDGuPYWeI3VRzX+WEG4TzGY0IHgE+p9TThZkutyKmxkYMHjKcM24Q/XjMXlrA6MXqSLfgsvlrMFhdwu9akTbwvc8D9zyup3zC71/MqtANAlhY9R2L9uDRzMfE/JJgIFFvhF7gbt1I49d3v6PRq9hJLrwMEjF0nX05w/VUK0V
 1ah2yeL5
 93DF524v0hYlgTMiyMpRyjdrZJOYIQL+8ca9KfJlxS1Jx0orvuY2VZK1jiixvRlSs0OH48bYlj6Na1aspCYtSSTUWcKdAgjwu1JjjNgf4AzOO7FHggA8Pf9ypvy+WLqRFKG4qQAzL0wjFVYTndFtKq+BoeJby5nroVZp+eMjfOrUrC58h9lXKwh6/WQ0JUOsSzPFHDIm1ALGhh0DZdH7RyXWOpJI7p4oBWMA+qczfWR8SVEsoCpHMWmiD/KTh69ASLsvpsk068OUzX1IN6x+JYFp6GD0O/qzQ4rx8a964LEXXipWR6/Xmk8d9rAqJJYGEfCJJPPBEfAsux0viFndAJ8vsyg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, 20 Oct 2026 07:47:25 -0700 SJ Park <sj@kernel.org> wrote:

> Remove a race condition under certain use cases that can trigger
> divide-by-zero.
> 
> damon_sysfs_add_quota_score() setup damos quota goal as user configured
> and pass to the core layer.  Because it could have a race with
> damos_sysfs_quota_goals_rm_dirs(), which destructs the files that carry
> user configuration, both are called under damon_sysfs_lock protection.
> 
> The damos quota goal setup disallows zero target_value parameter because
> it can be used as a denominator later in the core layer function,
> damos_quota_score().  Otherwise, divide-by-zero can happen.

This is no more true due to another patch [1].  The patch added the zero
target_value case in the core layer central validation pass.  But it forgot
removing the redundant check in sysfs.

> 
> For the zero value check and final assignment,
> damon_sysfs_add_quota_score() reads damos_sysfs_quota_goal->target_value
> twice.  And user can update damos_sysfs_quota_goal->target_value via
> target_value_store(), which doesn't hold damon_sysfs_lock.  As a result,
> a time-of-check-to time-of-use (toctou) race can happen.  If the user
> sets the value to zero between the zero value check and final
> target_value assignment, zero target_value is passed to the core layer
> and results in divide-by-zero.

So toctou race exists, but it cannot result in divide-by-zero.

> 
> Fix by holding damon_sysfs_lock in target_value_store() while saving the
> value.  The read side, damon_sysfs_add_quota_score(), is already called
> while holding the same mutex lock, so it avoids the race.
> 
> Users could reproduce the race by writing zero to the target_value sysfs
> file while DAMON is starting, or online parameters update is ongoing.
> The issue will only rarely happen in the real use cases.  It requires
> sysfs write permission.  The race window is short.  Sane users wouldn't
> write zero target_value.  Especially, they wouldn't do that while DAMON
> enablement and/or online parameters update is ongoing.  That said, the
> probability is not zero, and the consequence (divide-by-zero) is quite
> bad.
> 
> Closes: https://sashiko.dev/#/bug/linux-7f814c9a-986f-4103-a55a-ef9537dcf62b

Maybe Sashiko found the issue before the other patch [1] is applied.


> Fixes: 8b549a4fd3c5 ("mm/damon/sysfs-schemes: commit damos quota goals user input to DAMOS")
> Cc: <stable@vger.kernel.org> # 6.8.x

So this patch is unnecessary for the mainline.  But still need to be added to
older kernels.  Backporting the mainline fix [1] would be one simple way.  The
backporting would be not that straightforward because the core layer parameters
validation was introduced on 7.3 via commit b90408ef1163 ("mm/damon/core:
safely validate src on damon_commit_ctx()").  Hopefully doable.  I will take
time to do backports for relavant LTS and stable kernels.

[1] https://lore.kernel.org/20260903010722.94244-2-sj@kernel.org


Thanks,
SJ

[...]

