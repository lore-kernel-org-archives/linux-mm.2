Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 71B19E674B5
	for <linux-mm@archiver.kernel.org>; Mon, 22 Dec 2025 15:24:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C1D136B0005; Mon, 22 Dec 2025 10:24:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BCAB16B0089; Mon, 22 Dec 2025 10:24:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AABEB6B008A; Mon, 22 Dec 2025 10:24:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9B7286B0005
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 10:24:37 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 52D78B70B3
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 15:24:37 +0000 (UTC)
X-FDA: 84247478994.18.2EA93EF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id B6EAC180010
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 15:24:35 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="f1Q/QdOF";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766417075; a=rsa-sha256;
	cv=none;
	b=cS80tUnic7ta0nAdmiVoEkOoLcx0rHA4XbRELVo3dTmVHcHfjqfrCCz1LP2AV/2yasBj4K
	RokygQLnb61Z60UtMvCnox4Y4jxOm6vFECzVJ9904Hx66SIfGALoK/kWVmq73zj+4F66Bj
	tqGPT1lhiRwT8LamJsLozVt1exeGq28=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="f1Q/QdOF";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766417075;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TaX98UT+oDYMyPw9Ns1C3ixEbU9xHURLubadIQB4c3A=;
	b=rZoGp4n6SSO8sPJbhlTqzptTDUK0LHkKy9cj4oYUZsaLELVtNgoVKpaPW4AMzr7foeVO8l
	MVvqwU2Kobx6+Sj1eQBx3IFDU3tNLKkTMJ5fI7rkCtv045SCymoGt5JemBwulc/wi+bJBI
	mt25LZD8bCF0PK7swL884Lk8Suvqzkg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 104CB6014C;
	Mon, 22 Dec 2025 15:24:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92D1BC4CEF1;
	Mon, 22 Dec 2025 15:24:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766417074;
	bh=3/Yn5ySh52i/4QJb8bgsJpI/+2imGHs99ervgv9OcJY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f1Q/QdOFS/TkKJ/WE/Xchi4hsGXQb53TMNdXsQYdVeH8kxidKc5XZEjB1ryY6tOqA
	 qF9xZcAAUnLYWQkgYVEIbd51DTH63KYTjOJXJgv5gF1+0NLPIn+jjbpsRmn7d2ibcQ
	 UklKIuKF3uO+MvV82Pj4PGzqEPKhItn1DTO7nk6GGcT7raMY7EsERWWiO9F+dkWrEp
	 /4m9fN3/hxgKICZhk6eMwjDwjv8qAY8bw4lQhITGISrq5q1v8cuWO1db2Ekq8XqMBU
	 WsTZVAL5wNsM0/DYzTO8g5y2jdPNaJZJOLSU7HJFoDd3y9SQGw8ElGGtVR+kq+V9hQ
	 GhtIzMpZNq7GA==
From: SeongJae Park <sj@kernel.org>
To: Shu Anzai <shu17az@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	yanquanmin1@huawei.com,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/damon/tests/core-kunit: extend test scenarios and remove redundancy
Date: Mon, 22 Dec 2025 07:24:27 -0800
Message-ID: <20251222152427.87516-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <a98e23a1-5be3-4c2a-a65a-c33853683674@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: B6EAC180010
X-Stat-Signature: 3szhw4z8hmw3setgw5t3fuj4cah3h86q
X-HE-Tag: 1766417075-731269
X-HE-Meta: U2FsdGVkX18rWrOR4cuBOiqov2GM4+GuWiS/XQau81eaA4bYtD+Z8whtSyG1pra2XFgkodBsdR1mzpfTfdRhkvBrjEZDWPe0AA3werSebs+fFqumNdd69DrtfG2Y3oQwArasbRIg0dTMeVu3DxyTIGOayuqaDYfKogKhohE2hjIEaNrh7GsTNbtrdG4ST3eLGEWaOtXyxwL6MqTZ9BcJJdsmI7i66V9JdiXzjU8T7e+X82P9t8fJE8RVzq1MTnrnjfwQNucCvylRQ+MAE/DAttQERenS7uH9XlZ7sdypHSTqlaAiExcatg5Y/IZtbkeO12rUqOod/7RgHSb2+W6JqskFKCPW51Mi+dARBpLcVx6TvU0GgSN3npW7xIMRWPQuRWBsz+a5vlPFUGxQBHjN5h0scLGbT6uorJiMYxLesuCUGLpNGLDpVm6V//9uxT4gConH1ZTddXpSSdRnXrwOVVctM3U1LtD7G4DyO6E2d1SsBCPYFbC2O8Bv6gk5+hQIawyzOiqcJxn5OExk8fOyu0zFrLPjqa1gp+lMHNp+qwgTcW9BKijbMxyQV2F3sNwrmROeU5X9Qa2AWH9xCREE/HSPs/AcekOI5M2uvR/17UmUUx8pIOuT8NImylKdiWKFHp1dgjlDuYm3eQ+W75hzdzbBzVLQr85XMLxvkMo/erEhtkKemIGsOg3huJzv04NLHvP4nLH7MrEkK6bXQXhNJxF8VggpC6dVZhWBUe57AUdmOYEWit5w918IRon9GfnkCPVOQvZh1OO3Lk93pShd8wBvLBlZ5Sg6wLRVlGyu4XxazcOfmz97eJYYbd0KScBvDirgag4WjZ70heNN4v8JoBtTGPKzVHiPwZMVizwGzABEj5l0d7o7tcvF4NQ9Kz80kvI6rFcJLqt52jdXWmzu3cqr/jh0srVeENnCfsfyqqGOcNttLB6fvQvXV/bMKsjAXOY3YhvkeQ5xfz00iHh
 iaO2KDJe
 7O8xAKX23tcmMoXmHG19bg039xWtOpWNpbaBaQIKStq9TreCks8TM1UlSIWiyCm4y78brAIlpdfWR13I1DgOgqZyuhUN+kK78TkPdUAMhWPiSv4G2YkFscCh94cbge040HuLFNfjtKOpm7RCOn4GpDb+groJpMW3ZMqkUazUtxQgBqshmfhny0i6SyW1W93rmADPy+qXTte7NsYGsz7M9wkOvUyJHE2lkFMbmjmg0j/iDb8Q=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 22 Dec 2025 03:33:52 -0800 Shu Anzai <shu17az@gmail.com> wrote:

> Hello SJ,
> 
> Thank you for reviewing my patch! My responses are below.
> 
> On 2025/12/21 12:13, SeongJae Park wrote:
> > Hello Shu,
> >
> >
> > Thank you for sending this patch :)
> >
> > On Sun, 21 Dec 2025 13:01:14 +0000 Shu Anzai <shu17az@gmail.com> wrote:
> >
> >> Add some missing test scenarios to cover a wider range of cases. Also,
> >> remove a redundant case in damos_test_commit_quota_goal().
> > Seems this patch is making more than one change to multiple test cases at once.
> > It makes following which change is for what purpose bit difficult for me.  I'd
> > suggest splitting this into smaller ones that making changes for each test
> > function, and adding more explanation of the changes.  E.g., a patch for
> > damon_test_split_at(), another one for damon_test_merge_two(), and so on.  Not
> > a strong request, though.
> >
> > I have two questions below, though.
> 
> I see. I will split this and send v2 later. Let me first explain the 
> changes in detail.

Looking forward to the v2! :)

[...]
> >> @@ -232,12 +238,12 @@ static void damon_test_merge_regions_of(struct kunit *test)
> >>   {
> >>   	struct damon_target *t;
> >>   	struct damon_region *r;
> >> -	unsigned long sa[] = {0, 100, 114, 122, 130, 156, 170, 184};
> >> -	unsigned long ea[] = {100, 112, 122, 130, 156, 170, 184, 230};
> >> -	unsigned int nrs[] = {0, 0, 10, 10, 20, 30, 1, 2};
> >> +	unsigned long sa[] = {0, 100, 114, 122, 130, 156, 170, 184, 235, 240};
> >> +	unsigned long ea[] = {100, 112, 122, 130, 156, 170, 184, 230, 240, 10235};
> >> +	unsigned int nrs[] = {0, 0, 10, 10, 20, 30, 1, 2, 5, 5};
> >>   
> >> -	unsigned long saddrs[] = {0, 114, 130, 156, 170};
> >> -	unsigned long eaddrs[] = {112, 130, 156, 170, 230};
> >> +	unsigned long saddrs[] = {0, 114, 130, 156, 170, 235, 240};
> >> +	unsigned long eaddrs[] = {112, 130, 156, 170, 230, 240, 10235};
> >>   	int i;
> >>   
> >>   	t = damon_new_target();
> >> @@ -255,9 +261,9 @@ static void damon_test_merge_regions_of(struct kunit *test)
> >>   	}
> >>   
> >>   	damon_merge_regions_of(t, 9, 9999);
> >> -	/* 0-112, 114-130, 130-156, 156-170 */
> >> -	KUNIT_EXPECT_EQ(test, damon_nr_regions(t), 5u);
> >> -	for (i = 0; i < 5; i++) {
> >> +	/* 0-112, 114-130, 130-156, 156-170, 170-230, 235-240, 240-10235 */
> >> +	KUNIT_EXPECT_EQ(test, damon_nr_regions(t), 7u);
> >> +	for (i = 0; i < 7; i++) {
> >>   		r = __nth_region_of(t, i);
> >>   		KUNIT_EXPECT_EQ(test, r->ar.start, saddrs[i]);
> >>   		KUNIT_EXPECT_EQ(test, r->ar.end, eaddrs[i]);
> > I understand the above change adds two regions on the test input, but I'm not
> > following what logic it intends to additionally test.  Could you please
> > clarify?
> 
> Both cases were intended to verify that damon_merge_two_regions() is 
> called properly in damon_merge_regions_of().
> The first one was intended to ensure that non-adjacent regions (170-230, 
> 235-240) are not merged even if their nr_accesses difference is within 
> the threshold. However, on second thought, I realized this is redundant 
> since it is natural for non-adjacent regions not to be merged.
> The second one is to verify that two adjacent regions (235-240, 
> 240-10235) are not merged if the resulting region would exceed the size 
> limit.

Makes sense, please add the details to the second version.


Thanks,
SJ

[...]

