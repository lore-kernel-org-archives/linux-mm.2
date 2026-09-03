Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9B2ABC61DD3
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 08:33:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BE1CA6B009E; Thu,  3 Sep 2026 04:33:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BB9736B009F; Thu,  3 Sep 2026 04:33:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD06A6B00A1; Thu,  3 Sep 2026 04:33:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8C1DB6B009E
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 04:33:33 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 375D61601C5
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 08:33:33 +0000 (UTC)
X-FDA: 85171787106.04.D3DA768
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	by imf07.hostedemail.com (Postfix) with ESMTP id 65EB540006
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 08:33:31 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="dPlzS//D";
	spf=pass (imf07.hostedemail.com: domain of kunwu.chan@gmail.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788424411;
	b=21/R3lzXDsksqvsAkWVpGR9wBhmUmJPnrrOyjvD/+v/cC/P2waY0YmGe/va1161JIpdpJF
	enLLkShmaExe63vADCdhT9KTm3pP1o5fIKrXP4qWiyfbY5AO4aQdkh7NgZxXG8QFkhNcef
	80vQt5p9hjl95cJpkVrhva/YciaDRfo=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="dPlzS//D";
	spf=pass (imf07.hostedemail.com: domain of kunwu.chan@gmail.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788424411;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OociqrsBmV/E6a5jpk0qDALr4bKhrSE+A8mgKI0tJ1g=;
	b=UxeZ4HJJfsR0JoC1PUTGgO+CdQ+yTryppW6dos6bLMqR11wkxRSZltxSdBkuMw3Ca5u9CI
	WA+qsXLEw1FmUREEGutfOA/SWYF7HAa1D9ncygD9RXkDRtOg4ncDYKzsJ6n9P36XegC00A
	N1NEvHNsKrCagWxpONYgvPki4fEL/40=
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2d6efd73032so6754945ad.0
        for <linux-mm@kvack.org>; Thu, 03 Sep 2026 01:33:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788424410; x=1789029210; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=OociqrsBmV/E6a5jpk0qDALr4bKhrSE+A8mgKI0tJ1g=;
        b=dPlzS//DCW/+dBqhra8xva+cCLOVaIyI+cKdHAZlGFy+mTr6yzXRwWaEOniZIgFqBI
         WSWQsP98tAoDsKYJPbFymc02nR8ilDEjJXlaPilMqHRrTlVU2BlK9Y9szfyDvlRsg0SC
         2aOKoSAx0y2lvvkHFAzJpX2fCZZxTP4w+pE/8nT9e8coAlaWNdLDckLrEWLgNCciGi1x
         vJVBMKE37G/VdBTPdmETOKm5E2OVes21g01y7Bp8HlLYPbay/k5yNO31BxkisyAa3L9B
         Ot92PICpHzZewBWwO1tfDwn7Ra8aGgb5u9sVXRD3y6i+R7h3xk+LUvVIAhJ3XFsQOxI2
         Eg3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788424410; x=1789029210;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=OociqrsBmV/E6a5jpk0qDALr4bKhrSE+A8mgKI0tJ1g=;
        b=U2AYkW6Abr6UEdEsN5YOY/EOSr6BKU31loUduPI+JNF86qslRnL8Kav4npmXZspijR
         0JAny4QlU5/5kfavOuYfcEAr4w8qyFpX/S5gllZbB7phbvg8bf+guKjbifcZGF4/5guc
         dniYFi/PHVteeAelCWOkZs0+62I5ZYqLqpMXOmpCM8rSzDr7v27/RMV2gDtJhz30miHA
         WT8498L9rXtUkTIWfAUhzx0wYjAAZj9Xe/lDeLlT/Q4D2HnxPZF9qaR/j3wf8OyDO9wh
         rlVxk/CSRWX2gvBeaz9bbBZok2P3ghjWBuWBdwoTj94nFjDcRJzhf5K2EEwlEjNHnN1h
         +roQ==
X-Forwarded-Encrypted: i=1; AKwUvBzrE56JFiA+YjnaxjbhIl/heMKZh2c4v9UCIhUQSJqkIVPKZi4poVXjazTwpDkKqUa8Xyfg80acCQ==@kvack.org
X-Gm-Message-State: AFuF++nQOMDzXhKZIoGtfG3S+H95OE77Jb/7oNJu6mzp6ONTPrhVNhsk
	EcUbDq5gY8arc6V7QlC5rdmVuVaiNMEyNNvw3644yMP7F1cJnWsb0G6Q
X-Gm-Gg: AYBFou2XF6XK641ndhIlqKFb1Bxs7bJ5iqpf80fW6rPXTRh0D/DYvPMVVx6JHgQfMXE
	ReNAi+9rND+fNkWK9eZ323pXyKEL6Moj2XhXVuJDOmCLgS8SzO8lg9iQCUIPnGPHltZ+asX6ftA
	tNe4942omOxE+8+5YsxklhCw629PSk5jDOPTttJEXgQO3F0hrW2KZq05/D8wtOGstK1vz8aUDDI
	DzUTwCVb28s5iSM+Oll9K2PiQmoJqh5SydLLEhjBcAj31vJeYcE3cWfOF6AoxtsA9inEhyovxbL
	yqJZHiliVRqhiJmIx7az1wNXmPKgaA1AFY6BVdN3k72xDCqNsqCu3IGDYHFHJUDGRCzZza7QmwB
	IjxMdcw7CirI/5MIVM5scLpKR4jdjX4ZuDqdifqnJZXWskr2JOecB9IRvSVi6JBE458da+XNY2o
	M/3h7iGXgUzAFYBRTlOwebHN9lEuXA2jsTOgvD0id9KRIo0TA/NWTH6WPJlpFr4g380ZFQz0WP
X-Received: by 2002:a17:90b:3cc3:b0:398:9bd3:d6d4 with SMTP id 98e67ed59e1d1-39b132d819emr1843780a91.14.1788424410133;
        Thu, 03 Sep 2026 01:33:30 -0700 (PDT)
Received: from gmail.com ([185.220.238.35])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39b083e4fafsm4001175a91.1.2026.09.03.01.33.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Sep 2026 01:33:29 -0700 (PDT)
From: Kunwu Chan <kunwu.chan@gmail.com>
X-Google-Original-From: Kunwu Chan <kunwu.chan@linux.dev>
To: SJ Park <sj@kernel.org>
Cc: Kunwu Chan <kunwu.chan@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	stable@vger.kernel.org,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@davidgow.net>,
	damon@lists.linux.dev,
	kunit-dev@googlegroups.com,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	Kunwu Chan <kunwu.chan@gmail.com>
Subject: Re: [PATCH 1/4] mm/damon/tests/core-kunit: test committing psi goal to psi goal
Date: Thu,  3 Sep 2026 16:33:18 +0800
Message-ID: <20260903083319.451754-1-kunwu.chan@linux.dev>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260902002725.108635-2-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 65EB540006
X-Stat-Signature: qqyxfjfyz4ixq75rgtyk9me4d4fua8ao
X-HE-Tag: 1788424411-581537
X-HE-Meta: U2FsdGVkX18df+ixYatHecb48dCPzXJ9ZOYVwLm6sEjkMbywNTfN77Gy0UHa/TupDJ6jQjiMrBw4Od1ExfOsBVdEFJj+4o/ovy6PpXBJQFAD7qiaqIl4AGVtj1p7U6SPwKOHk0Mza8AMxekM56PgYSgNvYhPqijhHPL/IkgxBUojw7fjTDI9XL9+ytKqWhLR3vvvy9WLQ3RO5M8M597luRqAs1ZKHTR9Ds0nDOZcUkWpvHKNkDvdAXRVAsWmPkWscnXGqFjlsqDypOS2lADkNf6kn9Sr0Tl+uBvHufXZfjd1IZckTFhTwns6kYYxHr72aMUY//XI5y7vhg90STW+lxkdgugXAdh/67AA+7SkN0na/xiH9LMLWxb7K/zaKe9hXRpbswT1tZvd81DIaT8nwVffQ1Wq0r7aBaNEyPka5T3Boby1KtWU0GSFPQx24sYmefwjl3gQpVpeACH2x/UvwfpyrOHnLj1hCzn7wHGlRkSzNxUwAOS0yt4AdPJGGeS4pvf1OEhdz0iA4yhlpIavZOKdTpviJA3bnttp3V4EvVoYzNATG6mDKGRQGt52B2BnXZuNn8NMouISR3bhFunBGiNcytDwnaxEvdlsEIvo08Bx/IHBH0S94J/pkSA36MgeiUdAXgQZnQv/ve+r5l3tRh+MPFZ6HmgqaG+yQ6lARocMdtP+8tVOWq2f2MWvd9RkJrapC4/t7bnr7oID3Jmu64ERu4OTIdB3AEmwKFyRa7u8xqMQkyOpVQmMHoZjR7kqfuWiipeHdaXRlp1xGM+vGK5GnimyHp6Vlx0+NmJOvkaZTiYFJOvwgsfkWAo3VeZg703jq5ArH1piUMHlkYuJWB+k+CTrx8R9rO3VCASzEUiC4AodbFXyc4VTFxSq6Red2JGU+yRLlVv9zQu4+/nhsoUMUeJF825Rxk+milBF6ydOWWrDBRTBkac66HbqvyGchUebtaz6atv77hMFIhl
 Lw5oUiNN
 4hsFv8M71r2IhL/fLtq4yegOrFd2tQgjpJvLbYGGc4ojc745HwdTDxwmWgt+ILYn19eZhfoEvA51rKKpSY7YE1k4dLVwTbD4DfFeKGyX4GVNHaYrMoNHTHVrxLi5sDNg211E0Tx2Hjrqf7uBHlj6ev539dKKOVxaue0NU219lmjojxcfwVqtMbtkJrzxdnVWjBHbfFS6Yuc0isAmzdBQJiqsnTVWwQ4JoCFXM9YKrP/LCX+ahj8FxiEmtJ5HBXv7oWtbQZVXh1DEiPZ1nUeZbI8qRHyssObQuW1dJC4GDws7wBIiWmyaDOp8wtlCI40PGTBE1nFcxVdY3/FIdSvXc5el6knpGN+Tlh0ymaiD+HaKe/+AgoFA3cVbIakUSYTXuuqUb84qmdBI/c1rWvM9Cbqg8jWj2hwdztk7UATqg+ftmyTAECkho2+Hr3jwuANfCuJ4NJ/8VZoAcrUQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue,  1 Sep 2026 17:27:20 -0700 SJ Park <sj@kernel.org> wrote:

> damon_test_commit_quota_goal_for() is set to test committing a new psi
> goal on an existing psi goal.  However, damon_test_commit_quota_goal()
> is mistakenly not covering the test case.  Add the test case.
> 
> Fixes: 99f89debafc5 ("mm/damon/tests/core-kunit: add damos_commit_quota_goal() test")
> Cc: <stable@vger.kernel.org> # 6.19.x
> Signed-off-by: SJ Park <sj@kernel.org>
> ---
>  mm/damon/tests/core-kunit.h | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
> index 7071ec277b007..f1e11548c771b 100644
> --- a/mm/damon/tests/core-kunit.h
> +++ b/mm/damon/tests/core-kunit.h
> @@ -793,6 +793,13 @@ static void damos_test_commit_quota_goal(struct kunit *test)
>  		.last_psi_total = 456,
>  	};
>  
> +	damos_test_commit_quota_goal_for(test, &dst,
> +			&(struct damos_quota_goal) {
> +			.metric = DAMOS_QUOTA_SOME_MEM_PSI_US,
> +			.target_value = 234,
> +			.current_value = 345,
> +			.last_psi_total = 567,
> +			});
>  	damos_test_commit_quota_goal_for(test, &dst,
>  			&(struct damos_quota_goal){
>  			.metric = DAMOS_QUOTA_USER_INPUT,
> -- 
> 2.47.3
> 

Thanks SJ. The added case correctly exercises the PSI -> PSI commit 
path before the existing tests change the destination metric.

Reviewed-by: Kunwu Chan <kunwu.chan@gmail.com>

Thanks,
Kunwu


Sent using hkml (https://github.com/sjp38/hackermail)

