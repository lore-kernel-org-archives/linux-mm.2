Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 927B0606A325
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 13:30:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mGVZ47wI
Received: by kanga.kvack.org (Postfix)
	id 957E76B05BA; Mon, 26 Oct 2026 09:30:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9082B6B05BB; Mon, 26 Oct 2026 09:30:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 81DF66B05BC; Mon, 26 Oct 2026 09:30:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 608EE6B05BA
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 09:30:41 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id EA6B2A079F
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 13:30:40 +0000 (UTC)
X-FDA: 85364862240.04.DD2E17E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 5013840011
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 13:30:39 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mGVZ47wI;
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793021439;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=toIxbZaluxY/csBPcQI9DXYgAKoZ5TBqxydeOi+bj/c=;
	b=n+69HNGacJKCuyx5XygSastodaWf8pN+GbDq+OLY42svzuFXzvt9mIOgVCZhzAxnTWaMJb
	KQAmqS7zwxTKo0zFqN4If4U5/nuhEeouiscA9K9FE0mHcuMRIX3ZbvZRjQhj3nWPdtFj6o
	Dm1PGJS2Ny/xNT7aWUwNrW/PgspdUTw=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mGVZ47wI;
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793021439;
	b=5Fe/P4OYRuEkUweGHRi1iE1qo0xsilA0T0xPMJq6y4wtOLAK4JjsA16ip3P6KXirZlPGvG
	+mEdpIQdMAcdRVUy8Cdh0xAdFBhIq3uqZcW51gT0HDpRT+wF4ONIiIlS3rTBP0cVurdZs8
	+ZOf6tsr+YG84hNQqT4QPpQOByVW9DQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 84DF4601FB;
	Mon, 26 Oct 2026 13:30:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 036271F01825;
	Mon, 26 Oct 2026 13:30:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793021438;
	bh=toIxbZaluxY/csBPcQI9DXYgAKoZ5TBqxydeOi+bj/c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mGVZ47wI25337aHc0NOtWv1yyF4Wr13lGlNU0XG3sGX8znCtezXzr6SETOrGIy4gV
	 i5WKCyfjhnilMzrc6VZxQnvxoqHnZtR8dV3Cp5v5duGQMgSOHt3Bdii9a8O99M+4D8
	 OwPzFtmfewyHhjItkGYU1CeJhM7ZE4noVYUAb7zp8Yh6aUfVDep8hXGd7G4cCYaaH+
	 ZHAjy6jmkKFxeRJmQj7WqJTZFkxCymp2z9q3lQdhrk8G+VQBto3BJX8CL3JTHDQ7tO
	 CdtL8rvP+tCLOF4CAcx5CMh9YpoNG3UoNLMk6c0qptiabQzLy8Rr0FjsbQWrlKRdiQ
	 Wctnd8UfBfyBw==
From: SJ Park <sj@kernel.org>
To: Sasha Levin <sashal@kernel.org>
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	stable@vger.kernel.org
Subject: Re: [RFC PATCH 7.3.y] mm/damon/core: error damos_commit_quota_goal() for zero target_value
Date: Mon, 26 Oct 2026 06:30:30 -0700
Message-ID: <20261026133031.26195-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <2026-10-25-1-daily-reply-0011-damon-zero-target-value-decline@kernel.org>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 5013840011
X-Stat-Signature: xdqsy7y7hkib1hhioin9z9h66d64j9ae
X-Rspam-User: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793021439-426870
X-HE-Meta: U2FsdGVkX18OAHoRf6V1ccyny9Vbj5k803U2kmxuz8kbI+OCRt5khMIoL4ionYstX/ZT8yqfx5H5xtzCdi6/zLhzGrxsVqr0jC4fb6B6HiuhJ3lSxutKWpcgO9na/ucD31HRJnoK4gWMi5wwF2AMAeJXrDbCLGkE1Z8yl4NNvSWTOv5819sBAKGzO7WvVmqOwHdZVl96HuAWpQFakg5y+uODwZX6NqT3t/E4sCTFHfamjU5DzH9w+jTB8BipSBu/bu/qiCP4rOPIOPmOa99b8LioA3rc46JK52fM1dt489gw4ftpGF9rxhRV9aZpVNGwm4SWbFFqnl6MhvZjAqEdgZuHoaCkZMEg1aNoXq4oouHK/bSFuTRHh5v8eT/qEZl0DBEGiukoifr6nwWJZXMzj9WK0p6DcNPea2Ewpc+4cG/p52MprkSK5+uxb9Hb3aQK/RtYNmY1YIOG8V1kTQH4hwVbjmgE/hveYp5BLClsNeJwal0DcG8w6K4yf4AqiRKD0ZaxHLRJQuCS0eUdEkWgePhJzWRtdT2HMpQsEmh4J5J7+c7zvYPtXfe6yx+Ry3nc8SqKh21WxlQO4Oo8DDo6o5Ug1BSgnLKZT/5zeU/UeAIMCnfE2tZkWPOGnjMrUKLK2AoGfF51/Y1V0VaDKf1+37THnoKGT1mu5BUHp20K3VBDs/LJazeBTxSGWn+JRHQH1fkS1o7VEqQe5UkM67g4TxqJ8NZalXOe5ku+chG6IJ8bEVsjKxC2IPfbf/OuYPiaURfYo9JOZDKzecSFU2W/Y0qEQIeAxBr0MSTZdd7QHOF+7x8uyDa0IxMY0cxM/0QBovmDxQxhcMxTlwT8ZIfObJx1s5vGQrmHd3TMySQumwjaA/MwvRkw4FZVkrQz4f2d67zUaBTEWmCgVb50VtiznrZeOmg4wq81ChjRLYdGBvzDQdCWSi72A6WuOkjsVw8jQ+RAmbVV7fYFjdux+W2
 MQKJGXUR
 iU7UuMCsXJDxkC2hYJY6Et4wSRPOcl3i6ixtjUSVc1XVVH2P1p6bzmc1V4GrLPXsMar/fzTT2EesEjy4zy4S+ZUkbybz93fRzK/st0KVkD/PqTlUzFJPT/PPXjb6LmALhlt0AXMpYHudGPxW1FFhfw1T+BLe8racKVrTqihBnTloClJW/eqgXQp53EHDHvlmoaWXoL3T/aFR3ccZuDtNcgpIvXpXRLwnUAz1+TTjXE6SENaAyY5IDrMSu7p4sHdrhylSJ7Ym/Od6zvze8pM20HNVNew==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Sasha,

On Sun, 25 Oct 2026 19:29:57 -0400 Sasha Levin <sashal@kernel.org> wrote:

> > Notes for stable kernel porting.  The upstream commit doesn't have
> > Fixes: and therefore not ported to stable kernels.  It turned out it
> > fixes commit 8b549a4fd3c5 ("mm/damon/sysfs-schemes: commit damos quota
> > goals user input to DAMOS") which was merged into v6.8.  The user impact
> > is a race condition that can result in divide-by-zero.  Hence backport.
> 
> The older trees don't need this one. The callers in 7.2, 6.18 and 6.12
> already reject a zero target_value (7.2 also has 06befa61c427
> ("mm/damon/lru_sort: error out for >10000 active_mem_bp") and a16fd3ad9d89
> ("samples/damon/mtier: error out for zero quota goal target values")),

That's true.  DAMON_LRU_SORT and DAMON_SAMPLE_MTIER are patched to be safe from
this issue.  But DAMON sysfs interface can pass zero target_value under a race
condition.

> the
> commit has no Fixes: or Cc: stable,

I didn't know the race condition when I wrote the patch, so didn't add Fixes:
or Cc: stable.

> and it is patch 1/3 of a series whose
> patches 2 and 3 remove those caller-side checks.

I'm not sure if this really matters.

So, I think we still need to add this patch to older kernels.  Please let me
know if I'm missing something.


Thanks,
SJ

[...]

