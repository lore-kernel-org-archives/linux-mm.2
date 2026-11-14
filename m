Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2DCF1606A337
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 02:04:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cAfxhEwd
Received: by kanga.kvack.org (Postfix)
	id 552836B05B2; Fri, 13 Nov 2026 21:04:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 503316B05B4; Fri, 13 Nov 2026 21:04:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 440896B05B5; Fri, 13 Nov 2026 21:04:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 273D76B05B2
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 21:04:04 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A21831C332F
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 02:04:03 +0000 (UTC)
X-FDA: 85432079166.18.2B2D8CD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 12FF640004
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 02:04:01 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cAfxhEwd;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794621842;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cWS29mplmy+xwtYuaSXuypfaXRQfuscnjAulbCt2rLM=;
	b=y3JG3EByF5Hy/fl/jjH6zAnwwBGG3rNjJan5bGrjeMURGktenaPNoTINhXTf23Ji7cUqxW
	5xftGOuUoVsQX3burKwwfmnjblxvo+VP9ZXTcR/L6MCQvR1+lAjL00BKDd4L4PS7vpDs+s
	aSzm8//Aa+ddOfPb2vvyFp2AUuU3POM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794621842;
	b=AUw+VE8MVulJr/p+z9mi+hySpAoKlOvAcJhJJZfe9Tu4Sgu3Znx2hyUan9LFvS+NApJ2QT
	UfYSQUihubutxWj9JgJYAkVdAtMkmMZBR35Pv4FKp0NJDjgIcJzZolrpER8He5xRKTgphv
	cb7WcC7TJ1vBLHnjUM6iMoa6IQJq1As=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cAfxhEwd;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3871542A19;
	Sat, 14 Nov 2026 02:04:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E05011F000C4;
	Sat, 14 Nov 2026 02:04:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794621841;
	bh=cWS29mplmy+xwtYuaSXuypfaXRQfuscnjAulbCt2rLM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cAfxhEwdXacgTI0o8IQnQE73sfLxkoYOEBJpp4AzoB43TXmvnCjGAi1ycPpFuShlP
	 /AbicOWZqM1VCvQW4VBo9M2rOrJJKspMS1JMwkc6Ooas8FR6gQqbNrVvZoaZjxO+ub
	 a1+z5dk5EXUzONn2RlMcv1wjuhUdEmn7qNYcCSl/bIcLWrO0AJB8liyAuWQ9nvxFND
	 1fj5pLzjZmj4MWDpuN1/E7ppcKX8YV/eY+pNn8zFtIWQRBCPtE0iroDLdBKRxrfXp2
	 /Ul3cOBul46Kk6vdK1I5SB0zfiv4SUiV93NggF9cohPIw/8R32hzfEuYUqj7vK68vX
	 NBJ9PV72yWchQ==
From: SJ Park <sj@kernel.org>
To: Jason Angelov <jasonangelov@ucla.edu>
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] mm/damon/tests/core-kunit: test DAMOS_FILTER_TYPE_AGE_MS in damos_filter_for_ops()
Date: Fri, 13 Nov 2026 18:03:52 -0800
Message-ID: <20261114020353.109736-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261113-test-age-ms-filter-v1-2-b99eab2f71bb@ucla.edu>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 12FF640004
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: y7ag4x6h4xb9mptk576apskwkdh93zej
X-Rspam-User: 
X-HE-Tag: 1794621841-403171
X-HE-Meta: U2FsdGVkX19w6+GbNb5x1AMHb1P7ITWVrqd+pE+0IQVVan14fvg8NvhSZLvXZN0Dj/i3v6qN8Ab+XPEqNgrTOYzsbN5FOsGwiP2cvjUW+WE20MqSdtFjwEDpehUdo4UifvDRd7RdAVDuIGdcHzSpTtWRBi1uV2BR0roqf9Nnq/tkVo2/npxtUrLJBJaKOEdBLrXM2NagEHrSOPQ6AoR7hCPqNN+4BQOWnSBRBh5iX77udX+HKzz2efryx2IX2SegswDmJxZzmTBNkTVt+/rKeArBg58BMiqEOzveBI7sow3+3ybVZNn4Zh/bSODyvSjQMrIDAYO1CRi7wcD2+B8ZZCNPl79cvCRN3MUy5AVElXmSdEdJw+xwTh/B2pBP4lr2S4cAeGJFf5Pp2nI7S0hig/J1T9ct+wh6LbTPG7wV8yP6gH8cDjh++RpSMcFTKWY8Ss0HzOcur/N9yIZKfWkXKfZXGhrvAgL5TLLhvDGswQLCqYnph6T98gSYluyzkgfKo42xt9/q2Cf0Sg5oawpnD4SPgX23J3Oe3Qs7q37XvvIH36KZdwj3NMqnUZ/ZKQQ8tZCpS1mVvIEChLufh6pkhl0nkUQvFNL0T8+HNftsQB1X/6mmoREsqzzuim4k2wcOYWsE/UPtmlbSAUFtaiq9K3lANKnAhxQ+WNIfKogP0Pqz+LEA513qhsd+yleE4aDYXusdiB5l4k4QioLzCMLsk2twEQXJupFAtUmEYgsouZ00+EMpzOVm3o6PICYAb3Y9F8dDp9p1toaTBp0VoF1CGduGSv3dJt0WS7MMwK37p4vcqoYdbHYXZ4hdHaIruX8HM8xqjIaUu1PMTwUFe0hjjzTu4HKedoxZvj58idfUocl5IYiq92jsvkNjMKfUYw/VNavbmPz9zdduGMfu+D5SSJfjhVhpZAqXvZL08x5Mg8vOZmw57TO7iZ8tTg9D1bcrjb51wvXJK2FDx+pPFIN
 KvqLy9iG
 5gVofFsII9XyOKaCbOFhy/+H4hfHRJAPk170mrLHN3IBRnuWS4cZ2cTwjtGO4F1PlDYKtiQ4To0p6ZneedoE0L/42AYUeoSJPxaWF995uEGlr6w+/EeBCmNogqEv1LQMauSsgIaRmxc+LJt5YdJgeUauKrCyHGselNCYnjQ3LSyLKxhV7xpr291cf86fTUOhGO20DDc2t4I+a2Pzf8iGUhZ0nVX+bpBtvpH3z19RVNRvp5HdyaRG1GHVEi/LJdWCVzlmWJ1GBAFuSGXfulvfB8ekg7A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, 13 Nov 2026 07:58:56 -0800 Jason Angelov <jasonangelov@ucla.edu> wrote:

> DAMOS_FILTER_TYPE_AGE_MS is core filter, not ops filter.
> add kunit test covering this rejection.

s/add/Add/ ?

> 
> Signed-off-by: Jason Angelov <jasonangelov@ucla.edu>
> ---
>  mm/damon/tests/core-kunit.h | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
> index 0eb5dcdba0ae..fb84d30a712d 100644
> --- a/mm/damon/tests/core-kunit.h
> +++ b/mm/damon/tests/core-kunit.h
> @@ -1832,6 +1832,11 @@ static void damon_test_valid_probe_params(struct kunit *test)
>  	damon_destroy_ctx(ctx);
>  }
>  
> +static void damos_test_age_ms_filter_is_core(struct kunit *test)
> +{
> +	KUNIT_EXPECT_FALSE(test, damos_filter_for_ops(DAMOS_FILTER_TYPE_AGE_MS));

Let's wrap the line for the 80 columns per line rule.

Other than above two trivial things,

Reviewed-by: SJ Park <sj@kernel.org>


Thanks,
SJ

[...]

