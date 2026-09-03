Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67EB5C61DD3
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 09:23:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7C97A6B009B; Thu,  3 Sep 2026 05:23:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7A0EF6B009E; Thu,  3 Sep 2026 05:23:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B7266B00A1; Thu,  3 Sep 2026 05:23:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3B4A96B009B
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 05:23:57 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id AC039160438
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 09:23:56 +0000 (UTC)
X-FDA: 85171914072.13.5C9CF22
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	by imf20.hostedemail.com (Postfix) with ESMTP id CD3BB1C0002
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 09:23:54 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Ku5gPzjN;
	spf=pass (imf20.hostedemail.com: domain of kunwu.chan@gmail.com designates 209.85.216.54 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788427434;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=o7qTGz8yA1h581X4DOr85MyyM+WIOFqQrYJ5cYnccTM=;
	b=PjR+c1AaI8RM4qr9p+xeJOIgtO6Dd3jtUgqE9zWerV6J38P2oHQiETfx7XwrzacrfFG4b+
	SiyQSRKp4evybZFy34SYqo5fHeLlLyne9e5NFhguW9YYHV3WNl9GKtuTxfKKkyY4Ox6n8z
	+wIen8TMgPtRDd+UNxDhZilON2ig1kM=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Ku5gPzjN;
	spf=pass (imf20.hostedemail.com: domain of kunwu.chan@gmail.com designates 209.85.216.54 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788427434;
	b=7fTq8QNKO1rLlscfA9bZbC+uz8zPkVVOm/Pla3ZB/uB1l7tp29yKbc4N7Owugf4yxY3SfM
	zLz/A7OD+YM+cxlEfIXY0hJZ0mOThSCUmQanAVe8MJCIylg8n5QARgQAW7qR57xmTiw01H
	WYjMTXRlh3waXkjjSpkXN7KDIacNOBQ=
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-38e041ea211so1972630a91.0
        for <linux-mm@kvack.org>; Thu, 03 Sep 2026 02:23:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788427433; x=1789032233; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=o7qTGz8yA1h581X4DOr85MyyM+WIOFqQrYJ5cYnccTM=;
        b=Ku5gPzjN/4K9vvcGjKKQgItQBKtlQWdSvhHAFqcoodysIZd4GPSUQ1dEpM2GSJP9qj
         ymbwxTyZB2IiYGujPyJvskHUQHXDTk/xomBYx11/ndgIk9svYHAn0ARegvwkIdAeslVw
         ZojqC82Uph+KtYCDokh1N3vO1rPhLQAsUzJoEj5Y1/uCGnvC7WOfalrcTpJCKZsTbS2v
         6VkMqoImknjgTV8jkvQxwvlIc4OoKatNgXmHxpS/576EKdWqNHFrnpWAg8I0lXYAol9p
         CxzW1eZw8lYuVQpy09qlMEixZxRIDUlXSmnT30KRGYtAjn2ubkUvwlV9mfjg1fxKfmdN
         ZUmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788427433; x=1789032233;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=o7qTGz8yA1h581X4DOr85MyyM+WIOFqQrYJ5cYnccTM=;
        b=rmfP2YncHBpA/zdo1l8VSSFudAqqldWvdLNI8g9PK4FhdNfkrqEc65t8U9iHoN+p45
         aN0quQA3zoQ0tQE3uylZ0EQHBFlw3ncqaLJHegPvV5yenSQvanbBY6ce/ftfa+qcZnj+
         iKbEfDrQYJi3tR2heIdKewMvIQfsP8F7LXYhMLcIWGIkP3+lt8BxYkwcGQpXtCV49x0u
         1AXjltvHv5EpZfz1KYkVStdEa4YNYslSyv4szvcjMJCUQ3OT8/1rmDzZOLej63WwSDW2
         0oC9gzu5bHLPL8LDWcdrPq6mFemPqUi77pH6bo8h/faRediy/VcjqdppntxHHM8Q1f+7
         c+5Q==
X-Forwarded-Encrypted: i=1; AKwUvBxTm8GoedJNf258TDfOj0Y4oZViwh49Acjry8B2pE92j/QsW+Y6nKqm5BEWbNiMdC6MwsTRfxclBw==@kvack.org
X-Gm-Message-State: AFuF++mom8LM6dVEtHMWERrXzWeLyQ4hZp3UMzSL2XMXJDtcB+xpHmSt
	bF3Xygz7Qm1YIUZQeSe6AAD8ACHPgCCk0UktLMn57y+LQkOyYvS8+BSl
X-Gm-Gg: AYBFou335WUyLUgjTV3N9rWZ0Eh/TLrxmmAdd+0sRFwX/LiOCvoRwGfJ56un5DOFMuN
	tN88ZLz6t0jBuTJsNb2byweB3cuVQOv3EQu/lOq5ZIoO8MCy1XeEa/0XsmO6ULLpDcrtsajaMbc
	NDejNwQ2zgDjPngEKxLGoH1Ti0wv9bsH3Qlr9ifHtFQNdn5uuvU+Zc+41cbji5trswJII8pBfdM
	oiRmrOVZUw53je46Ey+TH7C2VJWRWZ3ZRPDlwohfCTByYhVlxz/HX0rtQNNTQK+rfiY0JYLcXPJ
	NvuOEVIK9zivaqtEU4/eAcscZ5n4M5IhQuAv9nLJ/rWd6EYfGHRkBYi9Q5OqYBC/FLO16LCH3CW
	syqq1VgkxGHkyTt+s+yuKAZA3hrcCcdHmeMj2PW6VeeylyayX5eceuqY8aQ+RWs0wckm10/sTyY
	6RDVuzn/vndzjFI0t7raeABf+RFRWRd5IzY5fPHO9lYe7CmbV/6z52Ou/Ld2w=
X-Received: by 2002:a17:90b:2d4d:b0:399:1b64:e0d7 with SMTP id 98e67ed59e1d1-39aee108918mr17835573a91.19.1788427432993;
        Thu, 03 Sep 2026 02:23:52 -0700 (PDT)
Received: from gmail.com ([185.220.238.35])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39ae8ccdecdsm2638527a91.2.2026.09.03.02.23.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Sep 2026 02:23:51 -0700 (PDT)
From: Kunwu Chan <kunwu.chan@gmail.com>
X-Google-Original-From: Kunwu Chan <kunwu.chan@linux.dev>
To: SJ Park <sj@kernel.org>
Cc: Kunwu Chan <kunwu.chan@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	stable@vger.kernel.org,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Kunwu Chan <kunwu.chan@gmail.com>
Subject: Re: [PATCH 2/4] mm/damon/core: handle uninitialized damos_quota_goal->last_psi_total
Date: Thu,  3 Sep 2026 17:23:33 +0800
Message-ID: <20260903092344.3079122-1-kunwu.chan@linux.dev>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260902002725.108635-3-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: zm5jh9krqfxgudob13iscwtz8cf7f3k7
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: CD3BB1C0002
X-Rspam-User: 
X-HE-Tag: 1788427434-387595
X-HE-Meta: U2FsdGVkX19hMNLkVQpM4IpfPBbPd/QYj14Vk7JKhmEE4rRqakyA4zCIhgc0eGZhGYe8rrZwGQwMqWamaCZNK6X02PGhg0iiwoRgQYPRrfn9qhfqGV9ceCcOq+rAqyjeyLnJAoRJ5mgmGAU76+QKjD3GlCGuiB+Ws73UMVqHSxvTSnZHL4jtz063Ou609ao4mTZpEvIDDljhuFmZNbz+df8qJ3cNc5v447N9GY2Tlpip7YVWwWnxoATg5QZVZKJe729b3Tr8sQhtUPszPo9T9UKOTx7b1tILzSHNlVv0czLaga4ty9FVGQDJGEepcV1GtMiHhYgTFV4HunBl3IMKbgomTmuON3w6fSkoXf+EWsfo7Op93rXEcSsV/n4H4cV7kRwPp6yOveNq+w4yYnmZvbUqcSe3z3mItK9AYehoWipurk25kHdS7cFN05qAVG2GwxxiWRxBQpzc0b3xqgRRE0GFJ8/v3NGt+e3X1GzUXnbwSBUGXGQJkTkLt8KYT0r6hQ9o2yvVdrGSER+I8Vb4Tt7EIgubZ1cvnDCWRCksjc+uCBHrHzPQJBo7y6HuGZYAT5Jma1WTr4ryqR7lRVm7ypOBs6fy9wh7+1DwSVI5Kx5H5rhKWKSx7/GoAqXet5aA7vGSGAu4Vym98Er0KuWVHu1YVqYDlml7OfoGULF9nPetVBczSTamgErUwfToLu1p0pn4P7RpXPb9D0StsrvgfUj4XE8z1bclyz3vzyhxhEurkn6cBXHz5mxVgMgIor7q0+Z9MA4bKTjZsOwRYw2aC6scj4M8hApzp2CJnDIWzQJoVSRfdiBfavoxkQ2TNY3CfUKDIoEf8erkGSZ8gp+JfRQulnYyilh1Qoq0E0suqpHNlxI+haAjXC/2NMqFZuYMGtLoJWP1k0ByZVVG4rURti6sBbhHoQMmzKnDYyl9Qdt7txky9qkpKUKFxyP1FDVrOTDMEwrUdbShM+cJt3m
 xFLr1wNH
 p7YJbKlwPQH84FuxgiQLKpGrnA6zGGFGKw+py+p7Z5d/hkrYc2bdA+n9XhPzfPWqYMtbxHMfMVCXYKtrNw4SjrqG1ztPdm0oCfzgFUegYm3UdzGc9+o76FHivHqBrSnB86cAclpBiS654bSZEnb8dHIfJTHlvAFNCsCy8e1B/SOTVetYxhcbo3t06iirDSFA/zti+em65KjY7c1++EA/UV+eklaWu+24+uai4jZxaG4Kbgc1wTQLGVbbrTR1oiVPUKRQKK/TPNSI8ABe0fbM30YL7+5wLHkmIzAtaxAU9/S9BNCnrHqqTNFPHVp7UwknDcH8cgttA4GqZRxg8mnmgChdeN90aJ5sE2NVfU11fAcpPlPKPgLKN7EMlk8K57Xy1DgCkKiHZk6ls3QKNdADpa4eTUw0hjBZzMCtF6/1mztj9X5MHjLvj1snxTmy6v6jaYmJt0kWjkUJCO8GopMww0cCROA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue,  1 Sep 2026 17:27:21 -0700 SJ Park <sj@kernel.org> wrote:

> When DAMOS_QUOTA_SOME_MEM_PSI_US metric damos quota goal is set, the PSI
> delta for the feedback loop is calculated using
> damos_quota_goal->last_psi_total.  However, it is initialized only after
> the first feedback loop.  The first iteration of the loop uses the
> uninitialized value.  As a result, the feedback loop can change the
> effective quota in an unexpected way at the first iteration.
> 
> The user impact of the issue is not big, because the issue impacts only
> the first iteration of the feedback loop.  The feedback loop also has an
> internal cap of the quota adjustment.  The wrong adjustment will soon be
> corrected over a few iterations.  For this reason, doing no
> initialization at commit time was intentional.  It is also explicitly
> commented.  That said, nobody likes behaviors that are unexpected or
> difficult to be expected.
> 
> Check last_psi_total initialization and skip the tuning round when it is
> not initialized.  For this, initialize last_psi_total with U64_MAX in
> the goal creation and the goal commit time.  U64_MAX means the field is
> not initialized.  The tuning round shows the value and adjusts it to
> guarantee the current quota is maintained for the round, and
> last_psi_total is correctly initialized on the next round.
> 
> Before this change, committing a new PSI goal on an existing PSI goal
> with goal-only DAMON sysfs command (commit_schemes_quota_goals) just
> worked.  After this change, the tuning round right after the commit will
> be unnecessarily skipped, because last_psi_total is unconditionally
> marked as not initialized in the damos_commit_quota_goal_union().  This
> is an intended tradeoff for simplicity.  Skipping just one round of
> tuning is no problem.  Meanwhile it makes both the code and the behavior
> simple to understand.
> 
> Also update the quota goal commit unit test for changed last_psi_total
> setup behavior.
> 
> The issue was discovered [1] by Sashiko.
> 
> [1] https://lore.kernel.org/20260718005316.89585-1-sj@kernel.org
> 
> Fixes: 2dbb60f789cb ("mm/damon/core: implement PSI metric DAMOS quota goal")
> Cc: <stable@vger.kernel.org> # 6.9.x
> Signed-off-by: SJ Park <sj@kernel.org>
> ---
>  mm/damon/core.c             | 13 +++++++++++--
>  mm/damon/tests/core-kunit.h |  9 +++------
>  2 files changed, 14 insertions(+), 8 deletions(-)
> 
> diff --git a/mm/damon/core.c b/mm/damon/core.c
> index 0df785e72438f..20748b0a71026 100644
> --- a/mm/damon/core.c
> +++ b/mm/damon/core.c
> @@ -636,6 +636,8 @@ struct damos_quota_goal *damos_new_quota_goal(
>  		return NULL;
>  	goal->metric = metric;
>  	goal->target_value = target_value;
> +	if (metric == DAMOS_QUOTA_SOME_MEM_PSI_US)
> +		goal->last_psi_total = U64_MAX;
>  	INIT_LIST_HEAD(&goal->list);
>  	return goal;
>  }
> @@ -1129,6 +1131,9 @@ static void damos_commit_quota_goal_union(
>  		struct damos_quota_goal *dst, struct damos_quota_goal *src)
>  {
>  	switch (dst->metric) {
> +	case DAMOS_QUOTA_SOME_MEM_PSI_US:
> +		dst->last_psi_total = U64_MAX;
> +		break;
>  	case DAMOS_QUOTA_NODE_MEM_USED_BP:
>  	case DAMOS_QUOTA_NODE_MEM_FREE_BP:
>  		dst->nid = src->nid;
> @@ -1150,7 +1155,6 @@ static void damos_commit_quota_goal(
>  	dst->target_value = src->target_value;
>  	if (dst->metric == DAMOS_QUOTA_USER_INPUT)
>  		dst->current_value = src->current_value;
> -	/* keep last_psi_total as is, since it will be updated in next cycle */
>  	damos_commit_quota_goal_union(dst, src);
>  }
>  
> @@ -3039,7 +3043,12 @@ static void damos_set_quota_goal_current_value(struct damon_ctx *c,
>  		break;
>  	case DAMOS_QUOTA_SOME_MEM_PSI_US:
>  		now_psi_total = damos_get_some_mem_psi_total();
> -		goal->current_value = now_psi_total - goal->last_psi_total;
> +		/* uninitialized last_psi_total; make no effect this round */
> +		if (goal->last_psi_total == U64_MAX)
> +			goal->current_value = goal->target_value;
> +		else
> +			goal->current_value = now_psi_total -
> +				goal->last_psi_total;
>  		goal->last_psi_total = now_psi_total;
>  		break;
>  	case DAMOS_QUOTA_NODE_MEM_USED_BP:
> diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
> index f1e11548c771b..af26b3d60957b 100644
> --- a/mm/damon/tests/core-kunit.h
> +++ b/mm/damon/tests/core-kunit.h
> @@ -757,19 +757,16 @@ static void damos_test_commit_quota_goal_for(struct kunit *test,
>  		struct damos_quota_goal *dst,
>  		struct damos_quota_goal *src)
>  {
> -	u64 dst_last_psi_total = 0;
> -
> -	if (dst->metric == DAMOS_QUOTA_SOME_MEM_PSI_US)
> -		dst_last_psi_total = dst->last_psi_total;
>  	damos_commit_quota_goal(dst, src);
>  
>  	KUNIT_EXPECT_EQ(test, dst->metric, src->metric);
>  	KUNIT_EXPECT_EQ(test, dst->target_value, src->target_value);
>  	if (src->metric == DAMOS_QUOTA_USER_INPUT)
>  		KUNIT_EXPECT_EQ(test, dst->current_value, src->current_value);
> -	if (dst_last_psi_total && src->metric == DAMOS_QUOTA_SOME_MEM_PSI_US)
> -		KUNIT_EXPECT_EQ(test, dst->last_psi_total, dst_last_psi_total);
>  	switch (dst->metric) {
> +	case DAMOS_QUOTA_SOME_MEM_PSI_US:
> +		KUNIT_EXPECT_EQ(test, dst->last_psi_total, U64_MAX);
> +		break;

The U64_MAX sentinel approach looks correct to me.

In the first feedback iteration, setting `current_value` to `target_value`
gives the PSI goal a score of 10000, so the uninitialized PSI delta does
not affect the quota score. The current PSI total is then recorded,
allowing subsequent iterations to calculate the delta normally.

I also checked the commit path: the PSI goal is reset to U64_MAX when
committed, which intentionally skips one tuning round when replacing an
existing PSI goal.

Reviewed-by: Kunwu Chan <kunwu.chan@gmail.com>

Thanks,
Kunwu

>  	case DAMOS_QUOTA_NODE_MEM_USED_BP:
>  	case DAMOS_QUOTA_NODE_MEM_FREE_BP:
>  		KUNIT_EXPECT_EQ(test, dst->nid, src->nid);
> -- 
> 2.47.3
> 

Sent using hkml (https://github.com/sjp38/hackermail)

