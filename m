Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 66A3F606A326
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 01:13:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=H+44i/oX
Received: by kanga.kvack.org (Postfix)
	id 65E966B00EF; Mon,  2 Nov 2026 20:13:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 636046B05B1; Mon,  2 Nov 2026 20:13:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 573646B05B6; Mon,  2 Nov 2026 20:13:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 30B8E6B00EF
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 20:13:25 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id AB4D1A0307
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 01:13:24 +0000 (UTC)
X-FDA: 85392034728.26.258E0D7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 089B4A0004
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 01:13:22 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="H+44i/oX";
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793668403;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YO+Mas6+Ogs0nMHl3MFFrvvs+CIGukFs8BZM4Sq24hg=;
	b=JJ+WAEX4T9PgwC0cJgsZ7Wx0nhIiB7DB0JxIIjA1fxhWysxbbT5k53vaU6NANGo7U/XAeA
	ubEooWY0w9FtGgFdT0wnLcWlsYLOWrKSHq7XMlL/dk8ZKiyM3oEslEToxK023xr2uNouYV
	FXQRtluYvRFPssojPhSqW56MDABvYvY=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="H+44i/oX";
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793668403;
	b=dPwINaasggeFJv3NwqsgE3y5VwplTHSGj2hvU+rgF6aN5efHFleYxY5zrdgxFr71pTA7uE
	HfFmyYzqGQTdX8FQYGNYbbqNLhNcReaAVgd5guASGEIQw3/ot+6p4epU7+bGy1HXY7qDvj
	0P9JxV9dRm2rDRopeQiGoiBpzI4jzYw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 43CEB40386;
	Tue,  3 Nov 2026 01:13:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A04EA1F000C1;
	Tue,  3 Nov 2026 01:13:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793668402;
	bh=YO+Mas6+Ogs0nMHl3MFFrvvs+CIGukFs8BZM4Sq24hg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=H+44i/oXiSUl+h5xIKQcSgVXzdS+QyrtKaeH+fOgkX9FPTaVPGpAOAz9ICuqQx3op
	 1QoPrg+LRRJFuI1SCp3wvqfBPX6ZSLM7e6GT9Itga/V5cPlAJ66/jbGezZfjkLsrOa
	 MBqZxcA3oDUqceXgbNRfpZVv42juqnrE5+wOfSUm2f4SSNWU1bXxXRgy9HbZRt91Rg
	 YOqz3S+20VfmydxdTtmpbC+R/MD6zQQt5HBygqly5FpxqpDEg/g0AFYfWaWMr3j1Yl
	 kQBBOusp+ck8LWzKZ++nXO6sxtgwDn7M56JqKDb9F5qyuLkIfdBii1NrlY3XWCS7B7
	 60vhOaN1advRQ==
From: SJ Park <sj@kernel.org>
To: Joanne Koong <joannelkoong@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	yosry@kernel.org,
	shakeel.butt@linux.dev,
	hannes@cmpxchg.org,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	muchun.song@linux.dev,
	nphamcs@gmail.com,
	chengming.zhou@linux.dev,
	david@kernel.org,
	ljs@kernel.org,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	damon@lists.linux.dev
Subject: Re: [PATCH v1 1/3] mm: zswap: fix shrinker count for the root memcg
Date: Mon,  2 Nov 2026 17:13:14 -0800
Message-ID: <20261103011314.93358-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261102225030.2743129-2-joannelkoong@gmail.com>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 6s7rpj8z5kgntzswkpxtaedji8q4birq
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 089B4A0004
X-HE-Tag: 1793668402-232810
X-HE-Meta: U2FsdGVkX1/rnFO6rD03UAPlCcjsj8HnH5oggF1uE8xezCFymPG85X51LwB+nlhDlioqUyIQffpX7tEY6DHw/9OkSmyOahJwNu5qA0S6fjxgN106Zkw848fDsy5s93TikQNK/iMpB3kCA+uGnjXggeRSbtyyus/oPCGcnuaxeAFDG3FGUhYlBk3zxUYVxxxteLIxOmmfmyc/FvyyuC+JOixm5kmUDyvBQDEsbSvxFmPKZNBUYjBJJ7n/Ot85mqE52iWLY76RqsAg2l4OSnc/ua5a27UmZg3I47RkkIKRmzYhQTNfJ8FoKX5kuyEhR7XI0EoU19+wU41x1derFaWFCGRubgkO5dC/rRwLEiDuPZo2DmWreAfe81VLW2ASI8/G59zOlqP87JZXHrUOZ+ajsKvcO4VVtN9ODhFMJ0C10hQEyMDIvZBqh0obBOBbNCrcyMoksqp6JCwiqVjB7wzIg2T7R6Mi4pVZTRo7tOkN64179P7LOGjwaSWwQLoR349wRm3jtOSyvyUUyHpb3r87ky8S6qgrjyIkpuboApClNrUhvB0fhHEnJba8cqy5Wd8RKgkr6gqhWagXAMVzP+rvEtYvcghZxtz1EQ8S3kGdstN8J58VVt2RDp5OiLl9HYGKS0ga7KC/1LqL+wrHBdbBZxWFNKWhsIqJs4SKE06tzzGb7jgKkBQVUzWl/Ww0tVeG/JwP2+RuiK8rCk4Nsi/XQhRb5NkVNlepAWj6tdUO/nTCGELnCG3kF+WnGiFpyL96ScZIk2KUBAPBMi+FdqU/erFVcBulvKeeIfbpNvqmoY9kiDwsfDW/1PCPVGLgKXCPv6/qG8k7jDxPGskZ00YxhiyfiWAsKcADyicbKHq4G2pbDB5F2R6q5wdDz696pK0ZSJ50/kgC+fHhPemM0BW5f3u2J7wB+NGjEJGXXNv1lJqqUz1BC4+UkP6jfpy3LS7g5C3/XzDLjtdxmy3hDcq
 /wCs1hmx
 fbuYFlxmtQU73Xa6edAur87ydv5+c6Q+zZVgz9L73gQuGlXXhEj1Q7goWTQT2IwCnjdZyGjLNl8ePj+A8TUCgRT+1w+THMofoX/ryygy8JUy+sOUISuApqvwLp7eDzqRIq4H40bnM41XAXZieY6ATD8cY2zYgw91uEdlWdNstbY9G15WLFkeUy7cav9BztmLmBwKicT55t3i4myu2KZcJh9iRbaTbc5Rtc4kC8tLmWpSmHAN91IN586BeTZ1gobGvNE5a
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon,  2 Nov 2026 14:50:28 -0800 Joanne Koong <joannelkoong@gmail.com> wrote:

> zswap_shrinker_count() scales the number of freeable entries on a
> memcg's zswap LRU by the memcg's compression ratio. That compression
> ratio is computed from the memcg's MEMCG_ZSWAP_B and MEMCG_ZSWAPPED
> stats.
> 
> However, for the root memcg, the zswap entries owned by the root memcg
> itself are never accounted for in the stats (obj_cgroup_charge_zswap()
> skips the root objcg, and before the root memcg had an objcg, its
> entries weren't charged at all). The stats only reflect the entries
> owned by the root memcg's descendants. When the root memcg's descendants
> have no zswap entries (eg when the whole workload runs in the root
> cgroup), the shrinker reports nothing to reclaim for the root memcg, and
> its zswap entries are never written back by the shrinker. When its
> descendants do have entries, the root memcg's entries are scaled by the
> descendants' compression ratio instead of a ratio that includes them.
> 
> Fix this by using the zswap pool-wide counters for the root memcg
> instead. The zswap pool-wide counters cover every zswap entry, including
> those owned by the root memcg.
> 
> This also gets rid of having to flush the root memcg's stats, which
> flushes every cgroup in the system.
> 
> In a VM running a reclaim-heavy workload in the root cgroup with the
> zswap shrinker enabled, the shrinker wrote back no pages before this
> change (zswpwb stayed at 0) and 1016 pages with it.

Nice catch, makes sense to me.

> 
> Fixes: b5ba474f3f51 ("zswap: shrink zswap pool based on memory pressure")
> Signed-off-by: Joanne Koong <joannelkoong@gmail.com>

Reviewed-by: SJ Park <sj@kernel.org>


Thanks,
SJ

[...]

