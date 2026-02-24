Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C2024EEC2B8
	for <linux-mm@archiver.kernel.org>; Tue, 24 Feb 2026 01:40:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8E0D06B0088; Mon, 23 Feb 2026 20:40:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 88E716B0089; Mon, 23 Feb 2026 20:40:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 770086B008A; Mon, 23 Feb 2026 20:40:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 624A96B0088
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 20:40:17 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id EBE60B86E1
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 01:40:16 +0000 (UTC)
X-FDA: 84477644832.14.C13A1E5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 4542AC0003
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 01:40:15 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PoQWqwLg;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771897215; a=rsa-sha256;
	cv=none;
	b=ok3EdmqT6KPBtnt3gCDA/Y8WPIGTbXHrlX9HKVMWvfjnoLPpuHxdlmhhTnT4edBKpBAwrj
	NGyDjrK9Zcp3D6wl4tRN5c+GJO/w7MAUZHi7c9hbb6JI6W+dOxR1jU+1JhZdip9f1t45Ho
	D29uH1m0TwSWvMaE011ZQhlyl6oQpuY=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PoQWqwLg;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771897215;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=X9NK9JK1gwG+J8+Gc6mndPNP7DrAIdl7UDvvK5Sjx6Q=;
	b=P2nH4tgd4nr79ZmcCMRmU3pLmty0JbJNfPtwOOzojc/uW4yReUwgxA13Y18Mc1TAugT0Jj
	d4x1hockBftAWRLALR91yo4NKf+QMNvwJia0zZgARsaaOfNf0fdGPcy0dp9zqjKAp9g6Z9
	zdqWTAiFUC35Y1vxFTKOTLRbeJ0kkR0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D7D67409C7;
	Tue, 24 Feb 2026 01:40:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 666C8C116C6;
	Tue, 24 Feb 2026 01:40:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771897213;
	bh=RVsWdbVmMny33bwfq1wjdOBiqTKHCK+8VIVYGYGqQOA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PoQWqwLgvkqgXt/cw5N8bTjcYP+4SJSOo5Tf7LqZyhmzV1zL5Ag2IPPW2u1CKo/hr
	 CLGERRmA71w1M3MLKaSZvIPGc6x7msQLb3neIq6WzXXebYXILCYZvhvfvRjbiuGvI2
	 BFQemwneuh3RMa6JfhVnuu4urqEiOg7Cn1heC+Nv7VBDT82D+sOmOpfn0fZG2fOMnU
	 t1/YAREVgf8a7XVlyRqg4O0sd2QM1k/ltDHz//HbYi8qASdnzMn4+j/V5NQ4gnk56W
	 oU3v3ZjyJ9F4aDqCz4zDW72iDYttLEFMF3L760iA8jGQJu8hp32e7MdGVfS41ABz2G
	 gaBZoXWDNr5Eg==
From: SeongJae Park <sj@kernel.org>
To: Ravi Jonnalagadda <ravis.opensrc@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	akpm@linux-foundation.org,
	corbet@lwn.net,
	bijan311@gmail.com,
	ajayjoshi@micron.com,
	honggyu.kim@sk.com,
	yunjeong.mun@sk.com
Subject: Re: [RFC PATCH v3 1/4] mm/damon/sysfs: set goal_tuner after scheme creation
Date: Mon, 23 Feb 2026 17:40:11 -0800
Message-ID: <20260224014011.56624-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260223123232.12851-2-ravis.opensrc@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 4542AC0003
X-Stat-Signature: ubikgs4ue9sm5aw7j6wuajcadroch599
X-HE-Tag: 1771897215-778433
X-HE-Meta: U2FsdGVkX1/lKa/NqlhR6ScuWSK0+T+qzKzsOxmIKkGuNHvzFwle2ZRwuHwt2G6hTSUsxg6c0u51ICMsYwy0eZ6PLE3qzHYK8ZwkFc0QW+bEdU8l4iKcF8xUr5AUsOjvPJtuhF6Gt1E3RK0Fsi/xrtToWBOHGofWuazTq38J0s+V5yA91eofVG+0zaq/vcwwqWlGY6ro+j/yRxr1VVL34+eqJEcNJSipRpwv1i9ePoaSl+TwPLKn3NvcxzAwPnzIa8S04JdZS6gyap8BEUzFVkzYyr6dqm4sUfwnHwxxaq56iyJg4GfWORyfmAcP9q0/CxUBmoep0bPeN+0IzZH3Ly0sffb5wixM7n3+0fy/m4FUGc5SD/aIm/JK0DtQ6yEYKlL5YhxEaabF2JuBtjklKjgEVhRdh6lpJDra4mSqVRGhJB5Mxq4PRG12UWCrgkKJy0iEnYVoqWDmSgqmoSloJelpryAubXI9sDEPzgz99ioHi0lfgRXUcitkjlE3PGl9R2laANcxO2WItG1SC+FDOFnNzzmR9kANIe2cSBxeVczDOM+s/pFHtDKBwaf6y8mKGbHbCEuLrvb7SHZ/PBqvESHXpXKbcxDksZRMZMvFXDa4RypQ0FcccrOU9Qgjg81JTbT49cvpyQb5F0j+61IjV14GewGayS+eM3ApzKXj1+FFjCrMJ2zstjuODCOQnQtpKdu67i8vt1bhuMoYX4sX6HYnfOqymA//4sABCVlKOt4JqhEgm5VTlzWkos2AG0mcETXPdx/pyFSipDc5yVktWiQ1kytSOlUeE+KQyRDY/pbrsOeAMsfvpsD6UIJIC7S6nu0e5cJt1WrNzYF7q6ED8Q5OZiOCWPN+YS6RtVWJA0/UajlpmCTvyZ0C5Pzj0oZsOhMmWa5UQJy5WfBItLhpYv2vXH5UI5nmLx7o/HbVP87nxz4uSW8TkQrEWgQKxfq/wA3pemAV9jxCAS7hzWY
 Prl/RI3m
 kAnypGhHUCJHB79rZfrsS8hPB8H2BRJeLafj9h4kC4XIR7udKGRlyEgjP+Odd4e/p6sbf4P2QEn1OwClV3dqMzIB0IrHYZ/gBc8K5JY7jVm87zm67KAzaQTMcgjg13JhiIhpWU6kO3XI0XS5AQ7iawAEN4X5/N5XX2JdbfDeuuUKjMhEPxJ3kW0KiikZgNLjz9dUL+wuEgegDnwxXDo5J9QyO2NWfUi1QqQLQPtUkURQ23VB/CNW6KKqUOkZOJApctwA1MycmNVJdJDCwp7UFn2yjTH4pjZyz26tYSd2K0LGG24DwWXFvTq4mByT7hA6VguYJPFdVXh9OD13KuzmGg7dBuCo4gfgXpAk1IaFWUyv+zcVsb+BDyXc3qw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 23 Feb 2026 12:32:29 +0000 Ravi Jonnalagadda <ravis.opensrc@gmail.com> wrote:

> damon_new_scheme() always sets quota.goal_tuner to CONSIST (the default)
> regardless of what was passed in the quota struct. This caused the sysfs
> goal_tuner setting to be ignored.
> 
> The comment in damon_new_scheme() says "quota.goals and .goal_tuner
> should be separately set by caller", but the sysfs code wasn't doing
> this. Add explicit assignment of goal_tuner after damon_new_scheme()
> returns to properly apply the user's setting.
> 
> Without this fix, setting goal_tuner to "temporal" via sysfs has no
> effect - the scheme always uses the CONSIST (feed loop) tuner, causing
> overshoot when the goal is reached instead of immediate stop.

Thank you for catching this, Ravi!  So, this is a fix for the RFC patch series
[1] that not yet merged, right?  I think this fix is better to be carried with
the series, and squashed into the broken commit to not introduce unnecessary
regression.

So, if you don't mind, I will squash this into the sysfs-schemes part change on
my tree, with your Co-developed-by: tag.

[1] https://lore.kernel.org/20260212062314.69961-1-sj@kernel.org
[2] https://lore.kernel.org/20260212062314.69961-4-sj@kernel.org

> 
> Signed-off-by: Ravi Jonnalagadda <ravis.opensrc@gmail.com>

Reviewed-by: SeongJae Park <sj@kernel.org>

> ---
>  mm/damon/sysfs-schemes.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/mm/damon/sysfs-schemes.c b/mm/damon/sysfs-schemes.c
> index bbea908074bb..fe2e3b2db9e1 100644
> --- a/mm/damon/sysfs-schemes.c
> +++ b/mm/damon/sysfs-schemes.c
> @@ -2809,6 +2809,9 @@ static struct damos *damon_sysfs_mk_scheme(
>  	if (!scheme)
>  		return NULL;
>  
> +	/* Set goal_tuner after damon_new_scheme() as it defaults to CONSIST */
> +	scheme->quota.goal_tuner = sysfs_quotas->goal_tuner;
> +
>  	err = damos_sysfs_add_quota_score(sysfs_quotas->goals, &scheme->quota);
>  	if (err) {
>  		damon_destroy_scheme(scheme);

To follow the order on the comment ("quota.goals and .goal_tuner should be
separately set by caller"), I'd prefer setting the goal_tuner after
damos_sysfs_add_quota_Score() call here, if you don't mind.  Let me know if you
prefer keeping the current order.  If not, I will just make the change when I
apply this to damon/next.


Thanks,
SJ

[...]

