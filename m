Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B7264C982D7
	for <linux-mm@archiver.kernel.org>; Sat, 19 Sep 2026 17:02:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CDE586B0092; Sat, 19 Sep 2026 13:02:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C8ED56B0093; Sat, 19 Sep 2026 13:02:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B7E4D6B0095; Sat, 19 Sep 2026 13:02:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 954986B0092
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 13:02:04 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1898280282
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 17:02:04 +0000 (UTC)
X-FDA: 85231129368.10.983B08A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id 7F05D20009
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 17:02:02 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="E7+8/d5P";
	spf=pass (imf31.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789837322;
	b=EA/jEU6BDQMMs2yUu7uR+LaCbzF4RhXGAekFW+n87w3tQ5DNXhd9IxmhzRoSs6nT4haTv7
	/+0KBlXwk+2PhefwubbgzyU+wzMsbUEz2Hd9dW6Y6hIpCNq+TNMlI1zwpjOr1Tw0pQSWom
	2cx+sS3oiiJw4hhqJ4dnuOO42LSxOdM=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="E7+8/d5P";
	spf=pass (imf31.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789837322;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yuyxk49VJCC0gfGldxmcbzu2cmMU5n1fpWdo47YM2lg=;
	b=dqG4D599K/guv9saqfEEqgrRtb/YBx2s3s8csP58uc49kYhnu4OYgLVNTN7dg1RL/JtRgv
	CObaCET3gzF7AV6uj4czhchqcLJt8RRHhMWiemGlqoRE0RS2Ei7H3iXY6tyIcH1ivwSVI9
	RKmXczK4zlOzoIvNpVqOdkDDdH6HCTQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id EF023601FB;
	Sat, 19 Sep 2026 17:02:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C47F1F000FF;
	Sat, 19 Sep 2026 17:02:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789837321;
	bh=yuyxk49VJCC0gfGldxmcbzu2cmMU5n1fpWdo47YM2lg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=E7+8/d5P82fP2xzrq+MJOLKng5m/Jh2jBtTdayiM8/U1717rxb8gAdXZwRMhSGA3q
	 hWDSkZwCVpfLauWzcLeGH+WAFpU21KcXzILtXuBWA9pZ25z5CrIpt8HF7TSe6ynH2k
	 Lo1hmEBG5qCMmdKOvd5K9080CKiJdPXT+96nnTFDmQXiF5BQX11WlGYLHEvDac+gp5
	 UcugU0EW5KAGditkMe0HUiCbtn+pPO+jKc0x/rt2AqOjeudVywOOEh509tle86YxbX
	 caEYL7sxB5OHGZ2gLetVhVY6zBS9N7UdMh03hIwwMUDd08Qhjp10/MlW823YM2C6zt
	 1eCdELUbfmQYg==
From: SJ Park <sj@kernel.org>
To: Donggeun Yoo <donggeunyoo.kernel@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 2/2] mm/damon/tests/core-kunit: test the temporal tuner's size quota conversion
Date: Sat, 19 Sep 2026 10:01:54 -0700
Message-ID: <20260919170154.86842-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260919071324.1583280-3-donggeunyoo.kernel@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 7F05D20009
X-Stat-Signature: p76ezp5hzzy479b919kp3x74jsjkzcpx
X-Rspam-User: 
X-HE-Tag: 1789837322-110035
X-HE-Meta: U2FsdGVkX1+bhM+qVxYvc3FaT38PSVNapVaTEKVGdsg+qM+zqwfrCdEnUS5FlEpmbSkadUlT70HywE7JQP0YmX/3P3VUvUmB1Vv6e8xcf8PmB/kYitwixQ8lpysUaxoMZjzFvLn+/bytsSTorjbmmddSpA4DG26foTP8WNkPCSftipg32Fr8rsrzi5MDuUpfayAntMsl9O9rbpTgaXO3PbU/HnBQewIDr8pSVkHqKhN+dl0F3hsZKBzzNtHyQu0X4P6kq8XRwRtWW1f9U2tvEAXnK02yQGF9sqLKw4AnMY5B7M6eKIfMoSBbEjO9njIPIi5ctaZm0TB2lGHFbeU5CmHSE2yKRbrKfjwv7vjoMr1ko/xX6TcG16bRMDk+ZBgLbSR9bjuAtWSnW4Ggi+BnY9Ws77eUdB20LRUtDQb19ESnLqB/mN1fVW37C1cMmrUMNf7G7AIXFSa2FcUQDA5B9ZAal9INIxUqcc3W8yrAKVhQX/JFqUPnp89R6R8jsZCVvNMwRwiGx6oTzKYNweTsg8iM3rmaI4n3axEaItzqpiUg+69y+S5mgSba4Jqvr69u/TrkyWBPNX2qLeG5TX2Dn1lLhsfYV1zJzqQsEiRMNbSM9igbXwMMEqiJfE92LdLhq/T0wtDse4j2F2bbJwYsquHBHO/Uht2Q/DvedYGlq+jSnmc2lfq1XgrrInRBXNJpzCQ3bEjWanGlAlZtKJLgvNaF2YzJHZnVhoKtHt8jvh/J8D5VKJd5uMR2BJURAfCXId0mAfeFlaAoPMHqLs09Zvob0ZIV71NR5kAV/sikGIJNmqDaOCFMHDo1WNDxirezNPEQjZEfQEromF6wE+1CWmr5EwoqYVqA2OTevpogesag5xZIhO1BFmN2DXYdYI4/qALSb1iYRoqsI0AilW1swNdC+y2vSHDuvt/13LeknNSbU8ist/fxelg4qewoR4VGQBj3Bao4O55jzQJ3TLj
 QibOTIrf
 8Sq26u/755DPYbwzkjKLD4WHp8HUe8hIbZx5OsCGtlhkc1LqwqaDU4Cxd15bPuiOij3t44Kf/62RG05O8WWQ0rBeiJo0xO5kFa4OuvfifJkgKHthgMB4CxlW+TaZY3Z42GwfpsT1E2uDrrF0mwbYd6oWh+Rux0bmJMyfQRCMBuuzTx3bZgixJpyC6BspnSSzyCgb+qmmW/L6Dfgi+uTSdNObjGzevT5s+6IbUTJKZTWnrf7Wt1J2cGLRKc4H1E4k+JI2jmDJw3jNm1YR9Fi6qWC2oVKd/zrkzvjKTCXI+ihwppkcA28L3WXBRYQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 19 Sep 2026 16:13:24 +0900 Donggeun Yoo <donggeunyoo.kernel@gmail.com> wrote:

> damos_goal_tune_esz_bp_temporal() encodes the size quota in basis points,
> so the conversion is exact only up to ULONG_MAX / 10000.  Pin the three
> sizes around that boundary: the largest one that fits, the first one that
> does not, and ULONG_MAX.
> 
> Signed-off-by: Donggeun Yoo <donggeunyoo.kernel@gmail.com>
> ---
>  mm/damon/tests/core-kunit.h | 35 +++++++++++++++++++++++++++++++++++
>  1 file changed, 35 insertions(+)
> 
> diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
> index 5ff0436c5844..4460dce0352c 100644
> --- a/mm/damon/tests/core-kunit.h
> +++ b/mm/damon/tests/core-kunit.h
> @@ -1929,6 +1929,40 @@ static void damon_test_rand(struct kunit *test)
>  	}
>  }
>  
> +static void damos_test_esz_goal_temporal(struct kunit *test)
> +{
> +	unsigned long max_sz = ULONG_MAX / 10000;
> +	struct damos_quota_goal goal = {
> +		.metric = DAMOS_QUOTA_USER_INPUT,
> +		.target_value = 10000,
> +		.current_value = 0,
> +	};

Let's use damon_new_scheme() and damos_new_quota_goal() unless it makes code
too complicated.

> +	struct damon_ctx *ctx;
> +	struct damos s;
> +
> +	ctx = damon_new_ctx();
> +	KUNIT_ASSERT_NOT_NULL(test, ctx);
> +
> +	memset(&s, 0, sizeof(s));

> +	INIT_LIST_HEAD(&s.quota.goals);
> +	list_add(&goal.list, &s.quota.goals);

Let's use existing helper, damos_add_quota_goal().

> +	s.quota.goal_tuner = DAMOS_QUOTA_GOAL_TUNER_TEMPORAL;
> +
> +	s.quota.sz = max_sz;

Meaning of 'max_sz' is bit confusing.  Why don't you use 'ULONG_MAX / 10000'
here?

[...]


Other than above, looks good to me.


Thanks,
SJ

