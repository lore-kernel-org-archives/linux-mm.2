Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 323D6E67482
	for <linux-mm@archiver.kernel.org>; Sun, 21 Dec 2025 20:14:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4291D6B0005; Sun, 21 Dec 2025 15:14:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3D5E16B0089; Sun, 21 Dec 2025 15:14:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2B77A6B008A; Sun, 21 Dec 2025 15:14:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 19EB66B0005
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 15:14:01 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9810360487
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 20:14:00 +0000 (UTC)
X-FDA: 84244579440.19.1BA99FE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id D403E80009
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 20:13:58 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="kuX/TvQL";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766348039; a=rsa-sha256;
	cv=none;
	b=yyUZfu/EfwHicspBPicYpJEbz6Ez3zVuqSntCfmysxX2AAXXHv0YpgH7zPZ5aQ1WbqyBgg
	a6zkRZt+O5W7gwijwTMynHtlFTtC0RStkDp3mjBuTFPWxdssRvXY+hgCaMfLDn1NEUMwHp
	nr14GohE+si6u0FABCr5kqGmSXgr3QE=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="kuX/TvQL";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766348039;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vbm3z4zslDrScAekO/OwXXraHE47l47wQQeDYgnF+FY=;
	b=J1Q5yIY+WeNoEAd29sPxJ9bwEJzKavbXGiLM4fbNREYOgSlCnTv2EHY2FCywEoTzPDKGDu
	DSJ3busDjmkpp7/rM393hZXcj33A582VFG5j9O6HHMtN8Eb5F/JImo831j98s1lrlJH4Sx
	nhLWeRnYEgRfiGFR0nmgLqxIo7aKV34=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id AC05D432C4;
	Sun, 21 Dec 2025 20:13:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A4ACC4CEFB;
	Sun, 21 Dec 2025 20:13:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766348037;
	bh=L+HwWcueprOkDL5bY7kcoLnxKlOmqZ8wBaIYvEpHcuk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kuX/TvQLnJs6M4/+yEHXi0Kh1zn/tvDGxyP+FaKLIRHkm/dXlUV6+HMfUlkr5ZBgh
	 AhYF/edfKH7iXkes8p6TZmi2R+GH/7wLWpyPeDhUKuM/a/f+oI2ferqyox3fz6pTGj
	 PBiRaO1ROoOYySERM3/+8nFn3wjdhRlPPQkLgLolOcWqWBywEKYZ+qU8jSaQ/0oiqH
	 VCkvuLgk+BDlRdrDHEIS33hx1m46lCqYi96VWgGK5yh/QACqozxMouZ8hYZLRLbaJR
	 uuqeYmlgKQV0W72lDPX5DqnEwBwS9ikpbpN9Is1XMb80/FI6c0xIpIcXHo0ss7Sd6+
	 Y7fKPAcLx3T5A==
From: SeongJae Park <sj@kernel.org>
To: Shu Anzai <shu17az@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	yanquanmin1@huawei.com,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/damon/tests/core-kunit: extend test scenarios and remove redundancy
Date: Sun, 21 Dec 2025 12:13:55 -0800
Message-ID: <20251221201356.43083-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251221130114.1483856-1-shu17az@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: D403E80009
X-Stat-Signature: qzwxajxjnrx9ay7i79m6zag4giy3ctq3
X-Rspam-User: 
X-HE-Tag: 1766348038-383398
X-HE-Meta: U2FsdGVkX187VBBUrs4cAYWC4xZ6JYU32adEKTz8e5IAmOHuo/k1NJMkxx9bWslZRLkR/9Sn+WOYTBaQ4apTZ2D/ckIzJsWnxqe26mJqDvvpVa5/vo3iu4VBouoMNiVSX2aNjQMGfhzGj81GgnqN9jA17b13uDMCNaZDW/sCLlfDa7BFfKgBvuGThVRm2f2fwyMoz70tFB8ts7jdqywn4eGexBsssV245HuMD0Dm7sLzxqm7qNubm/d6B0weg1D2TcYvCahOGP9Rg0tcxzRTPVmhTsDHXcODjk8/KBOAtdadQ9pGGPY7EZjkOyrc/AAznqTWZMCyvpw7CpBfC183syJmaTD6sSHL/Fh76NrTQDgPMffRjhqD88NfHQHQocuTke37asGbC4uIq0F4fNputOv5svmhwF8mweYEvYrgf9Yy/I5UxhaJrbXSk91SchRlRYCnKHBvl2k1rbCODUIKATqut9RYMDArIYMDpYJcaxvibahRruLHXZ8O8qKdO1oKeyZifBTzwHrlfhcQuYOywBQNGcubYBIHOYGU+k27ISwReJdBHKNXnHaHiudrKJ29W69kca6e9yDmsm0/9bvPx1W6UlCRih/TfwaGID8WmHyeuLl2ondl6c6B+gmFYrXD12NTDJtXSfNEDQkxQTs7cySb0JqOdPTyR5htwir/4zmyYgrn5wn0ZBK/3m3B/QReMGPovP38fSG537uKF2sux7IV2jdLqduw+o1WvY2KVRyBuWjrOYACKauXJGsF5s6TAudELQumSkbHAWx+BxwpPrejNZRK+/wa+exEdcVNDS/cyDUASFLacIxxKUPng9NOEaJB0Z4w+1TBYhPb9OVIO+1vmfBHFNQFhU/FAGJFnezrhRsbpT11ZE11sJTLv91X89+gfggqW5kNTXgTCNog5GIdtkRYU5tbtSVtC4+0E6kvmd/28tX0Ov6IYIcwFGE0tGSnhb8TxbBU6zo6xAS
 ZbDRW7Sy
 zsyQo5ZA5RAHbn3lP4L08be7y2p38W92y63UNGhEoRFQk3n9yITRUcE5SdGNeADVeBj0NsVtYbu55dn2o0bAI3TP3Ng0DtPH5OC9U/ZOnGSJGrBclzG0aAHpVYJO6q/skeqvTuHQdvfHwDtRDfzDWw6Rp/gZOB3O8lJ8NkuEQYOVuy0+mKS9Fzklj1oPqCniyk9MOtohsA8gjkEVKKKr6MEuLMyzcLpjtbh+Jp2NYk2V5GNw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello Shu,


Thank you for sending this patch :)

On Sun, 21 Dec 2025 13:01:14 +0000 Shu Anzai <shu17az@gmail.com> wrote:

> Add some missing test scenarios to cover a wider range of cases. Also,
> remove a redundant case in damos_test_commit_quota_goal().

Seems this patch is making more than one change to multiple test cases at once.
It makes following which change is for what purpose bit difficult for me.  I'd
suggest splitting this into smaller ones that making changes for each test
function, and adding more explanation of the changes.  E.g., a patch for
damon_test_split_at(), another one for damon_test_merge_two(), and so on.  Not
a strong request, though.

I have two questions below, though.

> 
> Signed-off-by: Shu Anzai <shu17az@gmail.com>
> ---
>  mm/damon/tests/core-kunit.h | 51 ++++++++++++++++++++++++-------------
>  1 file changed, 33 insertions(+), 18 deletions(-)
> 
> diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
> index f59ae7ee19a0..e9ccc3fb34f9 100644
> --- a/mm/damon/tests/core-kunit.h
> +++ b/mm/damon/tests/core-kunit.h
> @@ -158,6 +158,7 @@ static void damon_test_split_at(struct kunit *test)
>  	r->nr_accesses_bp = 420000;
>  	r->nr_accesses = 42;
>  	r->last_nr_accesses = 15;
> +	r->age = 10;
>  	damon_add_region(r, t);
>  	damon_split_region_at(t, r, 25);
>  	KUNIT_EXPECT_EQ(test, r->ar.start, 0ul);
> @@ -170,6 +171,7 @@ static void damon_test_split_at(struct kunit *test)
>  	KUNIT_EXPECT_EQ(test, r->nr_accesses_bp, r_new->nr_accesses_bp);
>  	KUNIT_EXPECT_EQ(test, r->nr_accesses, r_new->nr_accesses);
>  	KUNIT_EXPECT_EQ(test, r->last_nr_accesses, r_new->last_nr_accesses);
> +	KUNIT_EXPECT_EQ(test, r->age, r_new->age);
>  
>  	damon_free_target(t);
>  }

I understand that the above change is increasing the coverage of this test to
also verify the age of splitted region.  Nice.

Correct me if I'm misunderstanding the intention of the above diff.

> @@ -190,6 +192,7 @@ static void damon_test_merge_two(struct kunit *test)
>  	}
>  	r->nr_accesses = 10;
>  	r->nr_accesses_bp = 100000;
> +	r->age = 9;
>  	damon_add_region(r, t);
>  	r2 = damon_new_region(100, 300);
>  	if (!r2) {
> @@ -198,12 +201,15 @@ static void damon_test_merge_two(struct kunit *test)
>  	}
>  	r2->nr_accesses = 20;
>  	r2->nr_accesses_bp = 200000;
> +	r2->age = 21;
>  	damon_add_region(r2, t);
>  
>  	damon_merge_two_regions(t, r, r2);
>  	KUNIT_EXPECT_EQ(test, r->ar.start, 0ul);
>  	KUNIT_EXPECT_EQ(test, r->ar.end, 300ul);
>  	KUNIT_EXPECT_EQ(test, r->nr_accesses, 16u);
> +	KUNIT_EXPECT_EQ(test, r->nr_accesses_bp, 160000u);
> +	KUNIT_EXPECT_EQ(test, r->age, 17u);
>  
>  	i = 0;
>  	damon_for_each_region(r3, t) {

I understand that the above change is increasing the coverage of this test to
also verify the age handling of the merge logic.  Looks good!

> @@ -232,12 +238,12 @@ static void damon_test_merge_regions_of(struct kunit *test)
>  {
>  	struct damon_target *t;
>  	struct damon_region *r;
> -	unsigned long sa[] = {0, 100, 114, 122, 130, 156, 170, 184};
> -	unsigned long ea[] = {100, 112, 122, 130, 156, 170, 184, 230};
> -	unsigned int nrs[] = {0, 0, 10, 10, 20, 30, 1, 2};
> +	unsigned long sa[] = {0, 100, 114, 122, 130, 156, 170, 184, 235, 240};
> +	unsigned long ea[] = {100, 112, 122, 130, 156, 170, 184, 230, 240, 10235};
> +	unsigned int nrs[] = {0, 0, 10, 10, 20, 30, 1, 2, 5, 5};
>  
> -	unsigned long saddrs[] = {0, 114, 130, 156, 170};
> -	unsigned long eaddrs[] = {112, 130, 156, 170, 230};
> +	unsigned long saddrs[] = {0, 114, 130, 156, 170, 235, 240};
> +	unsigned long eaddrs[] = {112, 130, 156, 170, 230, 240, 10235};
>  	int i;
>  
>  	t = damon_new_target();
> @@ -255,9 +261,9 @@ static void damon_test_merge_regions_of(struct kunit *test)
>  	}
>  
>  	damon_merge_regions_of(t, 9, 9999);
> -	/* 0-112, 114-130, 130-156, 156-170 */
> -	KUNIT_EXPECT_EQ(test, damon_nr_regions(t), 5u);
> -	for (i = 0; i < 5; i++) {
> +	/* 0-112, 114-130, 130-156, 156-170, 170-230, 235-240, 240-10235 */
> +	KUNIT_EXPECT_EQ(test, damon_nr_regions(t), 7u);
> +	for (i = 0; i < 7; i++) {
>  		r = __nth_region_of(t, i);
>  		KUNIT_EXPECT_EQ(test, r->ar.start, saddrs[i]);
>  		KUNIT_EXPECT_EQ(test, r->ar.end, eaddrs[i]);

I understand the above change adds two regions on the test input, but I'm not
following what logic it intends to additionally test.  Could you please
clarify?

> @@ -269,6 +275,9 @@ static void damon_test_split_regions_of(struct kunit *test)
>  {
>  	struct damon_target *t;
>  	struct damon_region *r;
> +	unsigned long sa[] = {0, 300, 500};
> +	unsigned long ea[] = {220, 400, 700};
> +	int i;
>  
>  	t = damon_new_target();
>  	if (!t)
> @@ -286,14 +295,19 @@ static void damon_test_split_regions_of(struct kunit *test)
>  	t = damon_new_target();
>  	if (!t)
>  		kunit_skip(test, "second target alloc fail");
> -	r = damon_new_region(0, 220);
> -	if (!r) {
> -		damon_free_target(t);
> -		kunit_skip(test, "second region alloc fail");
> +	for (i = 0; i < ARRAY_SIZE(sa); i++) {
> +		r = damon_new_region(sa[i], ea[i]);
> +		if (!r) {
> +			damon_free_target(t);
> +			kunit_skip(test, "region alloc fail");
> +		}
> +		damon_add_region(r, t);
> +	}
> +	damon_split_regions_of(t, 4, 5);
> +	KUNIT_EXPECT_LE(test, damon_nr_regions(t), 12u);
> +	damon_for_each_region(r, t) {
> +		KUNIT_EXPECT_GE(test, damon_sz_region(r) % 5ul, 0ul);
>  	}
> -	damon_add_region(r, t);
> -	damon_split_regions_of(t, 4, 1);
> -	KUNIT_EXPECT_LE(test, damon_nr_regions(t), 4u);
>  	damon_free_target(t);
>  }

I understand that the above change make the existing test scenario bit more
complex, and cover the alignment.  Looks good.  But
damon_test_split_regions_of() aims to cover multiple scenarios.  Your change is
updating one existing test scenario, so I'm bit concerned at the fact that it
is removing one test case.  I understand the updated test scenario is including
the old one, but I think keeping the current test is also ok, as long as the
maintenace burden is not that high.  So, instead of modifying an existing test
scenario, how about adding the new test case?

>  
> @@ -574,9 +588,10 @@ static void damos_test_commit_quota_goal(struct kunit *test)
>  			});
>  	damos_test_commit_quota_goal_for(test, &dst,
>  			&(struct damos_quota_goal) {
> -			.metric = DAMOS_QUOTA_USER_INPUT,
> -			.target_value = 789,
> -			.current_value = 12,
> +			.metric = DAMOS_QUOTA_SOME_MEM_PSI_US,
> +			.target_value = 234,
> +			.current_value = 345,
> +			.last_psi_total = 567,
>  			});
>  }

Thank you for correcting this!


Thanks,
SJ

[...]

