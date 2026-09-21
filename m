Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9AFAAC982E6
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 17:12:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 76C256B00BA; Mon, 21 Sep 2026 13:12:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F57B6B00BC; Mon, 21 Sep 2026 13:12:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5E4E06B00C2; Mon, 21 Sep 2026 13:12:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 356336B00BA
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 13:12:02 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A04A7C0238
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 17:12:01 +0000 (UTC)
X-FDA: 85238412042.15.E8C3C57
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id E3A3EC000E
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 17:11:59 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OO+iLt0g;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790010720;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HCJrgKklFG9NrB3rZUwyak2ETc3l1jw/ZyTmlKqr9+E=;
	b=QdhwoR1OdFQPkp7iolOpKWB1gT195mJF+vkxizYS/OnnBe7t49npmBb1orggp9yrBk+wFr
	cnm/vxCcKcCp9vIgpWF0xVV/tqgi3n5iTpAnFA0PvAQUNQ9WnHx+qIs2EicEo9stBGgu6j
	nd52c7rXZFPG+5ZwP8FuMOPLg3ZLKPQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790010720;
	b=ZMgNgenCrJvGw5X/Zjj+MeKiNm6G6C1eNlZg9KWqPBsjWgzr+8uaJ/qVwICuYmxBeyuxQz
	a0/h2rQsSgPayPkDH68A1+fJOxA0on34rm9YeLXLGWH6vCX1bO6VzeUbDYtCa4jbRpVZij
	2bpcK/u2R4VTcxlUeFvOtGeOmKZXBUk=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OO+iLt0g;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1815741892;
	Mon, 21 Sep 2026 17:11:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6A5F1F000FF;
	Mon, 21 Sep 2026 17:11:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790010719;
	bh=HCJrgKklFG9NrB3rZUwyak2ETc3l1jw/ZyTmlKqr9+E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OO+iLt0gz5rbr9yReVQPH32/FH65Pz2riHxgOskyIjRboPZHwWbfYbYkO03a5iQjx
	 LMx+2J0FwmZIBae1wpttLvBs1lR8H5+uHxlQWPA/Q5jyZCjSN70jvvcXpdY4f0WGg4
	 vnYmoq09OZTUVkP0FoaShbRGs5d4Oqg9qeg0xdfIhcOoUQfG7/ITxdiX5+Bc9+roq8
	 Nw51j2FIFD5uf06fJwc2J2NbXUcN+20Y8s9TGmb6UD9vkqLvAAPtCT4jJPYgTS3Hun
	 o4J0YOS6eHcDyGWWL+4hi5grUgl4CfuxlkMxmAbFuKvtbkk/zuH28ai5I1FBOT5vk4
	 AOs05+0yvBM0g==
From: SJ Park <sj@kernel.org>
To: Karl Mehltretter <kmehltretter@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] mm/damon/core: preserve the caller's quota in damon_new_scheme()
Date: Mon, 21 Sep 2026 10:11:54 -0700
Message-ID: <20260921171155.3359-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260921003047.12041-2-kmehltretter@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: zrud67czu3z1zkqmhyt4bdcnki5s3jwz
X-Rspamd-Queue-Id: E3A3EC000E
X-HE-Tag: 1790010719-636408
X-HE-Meta: U2FsdGVkX1/WZTGt4aAS2TliNXRFhpJHl9fdCThArNL3lwNV80Tv2YZf9WnDtnW3aegfREfhw75u8nmabfW/jOtosFdVkpzHNlWcKds96zbuGZUuPFubCzIsaqLDOPv0ovzBShiJ6BSmxCdQ3JD01zUa4ot5+fD865/ACeYEBA58cfAlJCXaV/372QXp7N4CsvFe22IzIoiQ1r1eLkCaVvDS9TnYy7k0xQy3UX3uxwzMTGcXXjyxzqgC/XUlJEC8j/M1vrXeWNOLbIRDmg5uO3PJFnFFHsKJwWgpJKuWgfDAcak1nqWSFZInFrlmtGX5mhgbzOfYsHo5VrUwGSb69btpN+B6pstJIN7FwCBf43z9Pg2F1u/T2KyHBBj08iYcZdpe40M3B4PsM1VlQUHixZ8AcUb8oKx6wh8HjoCPq4IQcIhfq+IRhi1w/6tS7VnA49aVwfEtT7mefT1AqTV1ve1xjXr93504KvNCCSy34cRAwOHuoVIGcA6yv/gwODbbQxhtmJCUP6VyepMWCr+PcYuALcRHNVWlAPR+kFXPb15AzLPHeUqL8kDe/Opsa6GP4/bRWYxF+6QNdOluP8sTYb8Y6wSY1N1S3jFDXR4G0NK2Gr++IZO35lsnC8+xs0L7eyEc3R9uWYhk591ktG5gYVH8cuxOjKjCcPdEhIS6DnT5bNZ9oLWBdmKQBk5M+ca/Pu3c/Y6NKJOq6ZXlyNGylmieVolYgLnhw3HGWWNd+KnMGem3NsECU3tQIKy0Q75IeumR/uLYWh7GGzpfzLRCKM4g+yz5rDkoax7cKYtfO3si/ZIAwzpNtwRb7azejmx5/x6kWgPQ/yEBgN2waZvkZU56nI9+jqlXRPG4Wd2fLZXzf2GVGpDDw9N97PMnf2glkSYB2gQl81+HJA0PmtTNczCFudHd7cqhkDb9DIVGG3hxmtlMKCYTLIChdFV0NnYx7BIC30RkEnOyGV0RlGP
 iSqGpgum
 Bgadon5W2ZlpQgsRNgKexNHNK6RW14uaptg2Lo1zCXbctBUPPcJTzKQW4MchzgzeiWC6Fo3mI0WRhfZf0cbve08JKmVnGCYyS1zPK8cY7P1E7pXIW2pZ/dJCo+H2qB5DqYeu5s3pQxJCbDd+/8M90uiXtdZEH0NOYhlXSSwy/cvMJLJ1unW607QM7pmR8IYSlKW82BrDT1RGXu2j04mvuGBkKjCWzF7qJEFmtT4wqhlSSWPDcWc8qv3LONw1oEHVWDEkQ3rgCZEDJf3XN3qc1v31LMuvP4aq2hK+Qwxd5e2tkIZwzut+oy+SOmDvSZuYbghGiHoM1n+UjtsY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 21 Sep 2026 02:30:46 +0200 Karl Mehltretter <kmehltretter@gmail.com> wrote:

> damon_new_scheme() calls damos_quota_init() on the caller's quota before
> copying it to the new scheme. This clears the caller's effective quota,
> feedback input and charging state as a side effect.

Apparently the above paragraph assumes it is called under damon_commit_ctx().
Lack of the context makes this quite confusing.  Could you please rewrite?

> 
> damon_commit_ctx() first copies the running context into a temporary
> context for validating the proposed parameters. When
> damon_commit_schemes() creates the temporary schemes, it passes the quota
> of each running scheme to damon_new_scheme(). The quota pointer therefore
> refers to the running scheme, and damos_quota_init() clears that scheme's
> state before it is copied to the temporary scheme. Even an update
> rejected with -EINVAL loses the running quota state.
> 
> For a size quota, this discards the bytes already charged and allows the
> scheme to use a fresh quota before the reset interval has elapsed. For a
> goal-driven quota, the consist tuner loses its accumulated input and
> restarts from its minimum input. A time quota loses its throughput
> estimate and falls back to the initial estimate.
> 
> The constructor side effect was introduced by commit 70e0c1d1bf94
> ("mm/damon/core: factor out 'damos_quota' private fileds initialization").
> Commit 60bd24f272d0 ("mm/damon/sysfs: test commit input against realistic
> destination"), merged in v6.19, exposed it when
> validating sysfs updates against a copy of the running context. Commit
> b90408ef1163 ("mm/damon/core: safely validate src on damon_commit_ctx()")
> later moved that validation into the core API.
> 
> Sashiko reported the same side effect [1] on the RFC of the core API
> change.
> 
> Copy the quota to the new scheme first, then initialize that copy. Make
> damos_quota_init() return void, since its return value is no longer needed.
> 
> Fixes: 70e0c1d1bf94 ("mm/damon/core: factor out 'damos_quota' private fileds initialization")
> Cc: <stable@vger.kernel.org> # 6.19.x

The Fixes commit was introduced in 6.1.  So the comment on Cc: stable@ line
should be fixed.  Also, at the time of the commit, validation purpose running
ctx committing didn't exist.  So, the issue you are explaining cannot happen on
the commit.  Or, am I missing something?  If I'm not incorrect, could you
please find the proper Fixes: commit and fix it?

Also, are you using LLM for Fixes...?  If so, the LLM seems not good at that.
Your previous patch also made a similar mistake.  Please manually work on
Fixes: tag or double check LLM's output.

> Link: https://lore.kernel.org/damon/20260702212143.0CB6D1F00A3D@smtp.kernel.org/ [1]
> Assisted-by: LLM
> Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
> ---
>  mm/damon/core.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)

The code change looks correct to me.


Thanks,
SJ

[...]

