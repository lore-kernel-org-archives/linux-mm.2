Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9705EE6748D
	for <linux-mm@archiver.kernel.org>; Mon, 22 Dec 2025 11:33:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 778C66B0088; Mon, 22 Dec 2025 06:33:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F58B6B0089; Mon, 22 Dec 2025 06:33:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D7836B008A; Mon, 22 Dec 2025 06:33:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 49BFC6B0088
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 06:33:57 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B791213C093
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 11:33:56 +0000 (UTC)
X-FDA: 84246897672.20.7C953DC
Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
	by imf24.hostedemail.com (Postfix) with ESMTP id DB138180005
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 11:33:54 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Lc516zNp;
	spf=pass (imf24.hostedemail.com: domain of shu17az@gmail.com designates 209.85.215.182 as permitted sender) smtp.mailfrom=shu17az@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766403234;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1AF1yX4GwtQvvuuOJCmg3PfUFD/RGUm+qcyOoMqIjVw=;
	b=Cc37hq5U0RPQEBzTr9+MlyWlLxdVKcnR23iE7Nk1fCKSJAr1W9lQGPfJM5NyaBAiO3Qh/J
	UckWJ1SJVcyWKARRohCmgefpMwTSlpwEwR5pIERywPotdNXWcQiogMpg92JedaZM0CnBlX
	JwNOj5RNYhk6KI0hJNAviRvwEoKlNkA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766403234; a=rsa-sha256;
	cv=none;
	b=Qw5AUTvAyqdCIZb0oWynsYjzja7SMfcjY3k6MXwrlT3V+0tindIOUhVAH2v3iWPdump2P6
	EFdFSrQsej+vkNx1ZZdDTiA0tArvxQfYZQHqOWg0jDz7gG7StPzPSb0WbFMZlMY5YjJI+y
	s4uLzuIv5zEQYXQXJuy7DjOOzq4QBuc=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Lc516zNp;
	spf=pass (imf24.hostedemail.com: domain of shu17az@gmail.com designates 209.85.215.182 as permitted sender) smtp.mailfrom=shu17az@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pg1-f182.google.com with SMTP id 41be03b00d2f7-bc29d64b39dso2057346a12.3
        for <linux-mm@kvack.org>; Mon, 22 Dec 2025 03:33:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766403234; x=1767008034; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1AF1yX4GwtQvvuuOJCmg3PfUFD/RGUm+qcyOoMqIjVw=;
        b=Lc516zNp+W7fdLXZxIPV2Ak5PdDIAywii4JrhBiYtgXUS9vCH72hQ4pSgkEiganyV0
         kqMgK0N/oDAQ61JikgyMPfjccQwecGFPpisRriUdULmDCVFuZ7y439mDdz81xKKzXsrI
         5McfrF7mzJbRu37gPUjrFLyJI7g9ldGJaEepmI/yFPQ4fQBKb12jgTdOu63MEy0bWjjj
         lRUQicNpLTP2LoLdedUdLj7RpKUcAj4Lsrn2OcGW5e+x0zPeRL50eJyC6T+onNVy53ho
         gVvNWSmLW+kGN+L2I131LjDzna+P/n23pCW6wFUE8TRyvEv/wSezvzF4MV/2mewpZRpA
         n01A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766403234; x=1767008034;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1AF1yX4GwtQvvuuOJCmg3PfUFD/RGUm+qcyOoMqIjVw=;
        b=Rb0RwvYnHAjfEFvsRcM+rh+bq9Q0YNgo1cntYeBK34Yg04v6KABS4kDQZNPlUL6bXL
         5dvjr9qsiUv27qn4UP7eUyINmybpkycaV9eIvMKoZ218OkZkVp0CpqUGzFxLJQHMpB4A
         WHszlpChgJTIttATBxmr4EmS8h2ayoRUbv2bDcHEdsR8ypOHkmdf95in318ayKuxqNxK
         lC7KOTtOGb33Bj5a9tHS0NSz+QIrpnVIUD2ctK9mC2/hemofZCiPkoOQEIHjjKIJNHX3
         t7mOkqNWEJoSs81TW79kmocEkj0znac2cfbUMaQagCquLtFJWGfr53J8CNT8nZk4Ku1K
         KuFw==
X-Forwarded-Encrypted: i=1; AJvYcCWRmYuurXNYgitH+f49/v6rYMldVDMUQJeh/uCMJiozrw4WWypX/ry+1SaJYPu2FAtf0KnCMmhIZQ==@kvack.org
X-Gm-Message-State: AOJu0Yye9m/8yz3IUWDmSHnmLm6svdznVNb4aMXlQa+y/UeMdHN0q7jV
	dwRUaOSMj5W4vdQD4LLJEL3iz212j+0YhcgDUYos8EsdzVg/4YahQOch
X-Gm-Gg: AY/fxX6vlm6XO7FuQxzdhbmgIJmZyxWOBxtEvo7d4UP/D+K7XwI6gup5m6Zss4x3RcL
	EoeSav8G+9KdROWW4FqApcbIzXcsw2PXExDDTiQLVbMen5uNg5IVOmuwg8sQhHCzqWWb0joC6ZJ
	QwDTMslmYN1cUy3l3Ho8xnhz6FTw8w4GtGFOxmJHdYRXa8LVelwuKarJeUYMVOaHip+laMkENdQ
	pz58lA3ZaEnW0+lPuwSTaFGTEfEfCnR/LwimQBvtWSnjkD2/O4cPVRq4cuuLi5vuUSHnsMiutT2
	lzbjBCDs18JlCQnaI8im5Rlts+3/WYmKqZNMopWv8HeIiF08q2KJrpslaIOffwtsT+mntffqBSd
	8LdBIi1SRdlb2OXjCqpcOxQ7XzWdDNaJoHdDZGHfVdJphQZ5hCEFWzZ3YJMQZIpPfz/U2Mv+XqP
	W0/elJDx7UBfu/AA==
X-Google-Smtp-Source: AGHT+IF9z5OMf2RZbV65D44H9QFHtRDW2pkTFrUb5U1bgAOg1PPjFbvfwWh5UVEkpb/ShGV7F0BvFg==
X-Received: by 2002:a05:7301:508e:b0:2ae:51cb:7a98 with SMTP id 5a478bee46e88-2b05ec6d51dmr6586243eec.33.1766403233498;
        Mon, 22 Dec 2025 03:33:53 -0800 (PST)
Received: from [172.26.241.102] ([131.179.95.234])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2b05ffd5f86sm23562684eec.5.2025.12.22.03.33.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Dec 2025 03:33:53 -0800 (PST)
Message-ID: <a98e23a1-5be3-4c2a-a65a-c33853683674@gmail.com>
Date: Mon, 22 Dec 2025 03:33:52 -0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/damon/tests/core-kunit: extend test scenarios and
 remove redundancy
To: SeongJae Park <sj@kernel.org>
Cc: akpm@linux-foundation.org, yanquanmin1@huawei.com, damon@lists.linux.dev,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20251221201356.43083-1-sj@kernel.org>
Content-Language: en-US
From: Shu Anzai <shu17az@gmail.com>
In-Reply-To: <20251221201356.43083-1-sj@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 613bc9kccnf6ds6tbhjr1wuz93cuicf7
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: DB138180005
X-Rspam-User: 
X-HE-Tag: 1766403234-978140
X-HE-Meta: U2FsdGVkX1/ChZ5ru053uxiJFP2lci5ZzWIGzH4Jix9zg3g7pbWyCE4sRpSFz3gdglKydUwsxf7BR9c7ekfjfxmujcRCbOR8GyHRVuNsHKzr0YJ8KSMBDH/XLb/XU+Y3NVu8wKRboP2/9lyGW03OZwWoYp9F4l57q2wyB27IHPoZbImIck7rSPvfpLdxtV3lGMUSCX4kvLGOJ83+DlmKcgstwBRESh/2A4T/F5jSmwKLbgSp+kscjUC/lPDogiSi8HuHt3rWIKwAH6PCC72VOptYTWRMVJqtTnd24+rS+SKJbtizmtInN4svgWuWt+fA2QiVYgNzYcdvmM0kvh/65Yj2UfINc5vr14JFUulovHo84Eg9oV/uNhE4DdHjE+GMzhIfP6SbAFcWAOavZBoh+5MtmolOgz1L/Aw5UDZC6jjqOvcVG6x477s+0xWGwC4MK35xww52i1fLQgdGLRJGSspOjrbF5PSc6jOyVi2+aUU/Xa3BjKGAGz5ghPcqAfTFJxllokm5R9CfweRFvittIVR0vXH8oZ14buCxYn9VMXmcnH7F894eCeVTsv5/smRD6Oy3fMkhhvxyyfDr4ZCzZgIisdPkn/ZMJLIIxc4c8okD+sqLwHP/v0jRB2hywbh34PKUsnSTIgTS8Mr5RtVGy9rpJ4Mz0xNvhV8tPqqND9lCv/cpST7T9/+6L1bbyqa5ev0NHV4uEb6G0ePVXkRapHI3HII0eG3d7/JQkwYm/wafdPVAph7ocVu5ts7HW3gDRftC1Kt1OpRn9Qe1yNOM/2AfG2CEIDavK+BYpmtevJ+meLcf7dsfJL+1yxk8J/mFmqLhB+ws15bP05Qko3wUIGjDpR4V7n5NCwgSIia62swuXk0Hy+PC03UC15BBSbB9xBrNzqBCPUOliEgRt+7Mriqozex7GdBkVCGLQoKxsutf9Ng5mcN3NGfhIQtPrpSzO838WQm7Tdsu2hLq5cA
 y/mJlJ8U
 zyDrXG8PZDS76by13ewi0oe8BURnMj2m++MrPgrINlMphQva1DA7VLjEzeg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello SJ,

Thank you for reviewing my patch! My responses are below.

On 2025/12/21 12:13, SeongJae Park wrote:
> Hello Shu,
>
>
> Thank you for sending this patch :)
>
> On Sun, 21 Dec 2025 13:01:14 +0000 Shu Anzai <shu17az@gmail.com> wrote:
>
>> Add some missing test scenarios to cover a wider range of cases. Also,
>> remove a redundant case in damos_test_commit_quota_goal().
> Seems this patch is making more than one change to multiple test cases at once.
> It makes following which change is for what purpose bit difficult for me.  I'd
> suggest splitting this into smaller ones that making changes for each test
> function, and adding more explanation of the changes.  E.g., a patch for
> damon_test_split_at(), another one for damon_test_merge_two(), and so on.  Not
> a strong request, though.
>
> I have two questions below, though.

I see. I will split this and send v2 later. Let me first explain the 
changes in detail.

>
>> Signed-off-by: Shu Anzai <shu17az@gmail.com>
>> ---
>>   mm/damon/tests/core-kunit.h | 51 ++++++++++++++++++++++++-------------
>>   1 file changed, 33 insertions(+), 18 deletions(-)
>>
>> diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
>> index f59ae7ee19a0..e9ccc3fb34f9 100644
>> --- a/mm/damon/tests/core-kunit.h
>> +++ b/mm/damon/tests/core-kunit.h
>> @@ -158,6 +158,7 @@ static void damon_test_split_at(struct kunit *test)
>>   	r->nr_accesses_bp = 420000;
>>   	r->nr_accesses = 42;
>>   	r->last_nr_accesses = 15;
>> +	r->age = 10;
>>   	damon_add_region(r, t);
>>   	damon_split_region_at(t, r, 25);
>>   	KUNIT_EXPECT_EQ(test, r->ar.start, 0ul);
>> @@ -170,6 +171,7 @@ static void damon_test_split_at(struct kunit *test)
>>   	KUNIT_EXPECT_EQ(test, r->nr_accesses_bp, r_new->nr_accesses_bp);
>>   	KUNIT_EXPECT_EQ(test, r->nr_accesses, r_new->nr_accesses);
>>   	KUNIT_EXPECT_EQ(test, r->last_nr_accesses, r_new->last_nr_accesses);
>> +	KUNIT_EXPECT_EQ(test, r->age, r_new->age);
>>   
>>   	damon_free_target(t);
>>   }
> I understand that the above change is increasing the coverage of this test to
> also verify the age of splitted region.  Nice.
>
> Correct me if I'm misunderstanding the intention of the above diff.

Yes, that is correct.

>
>> @@ -190,6 +192,7 @@ static void damon_test_merge_two(struct kunit *test)
>>   	}
>>   	r->nr_accesses = 10;
>>   	r->nr_accesses_bp = 100000;
>> +	r->age = 9;
>>   	damon_add_region(r, t);
>>   	r2 = damon_new_region(100, 300);
>>   	if (!r2) {
>> @@ -198,12 +201,15 @@ static void damon_test_merge_two(struct kunit *test)
>>   	}
>>   	r2->nr_accesses = 20;
>>   	r2->nr_accesses_bp = 200000;
>> +	r2->age = 21;
>>   	damon_add_region(r2, t);
>>   
>>   	damon_merge_two_regions(t, r, r2);
>>   	KUNIT_EXPECT_EQ(test, r->ar.start, 0ul);
>>   	KUNIT_EXPECT_EQ(test, r->ar.end, 300ul);
>>   	KUNIT_EXPECT_EQ(test, r->nr_accesses, 16u);
>> +	KUNIT_EXPECT_EQ(test, r->nr_accesses_bp, 160000u);
>> +	KUNIT_EXPECT_EQ(test, r->age, 17u);
>>   
>>   	i = 0;
>>   	damon_for_each_region(r3, t) {
> I understand that the above change is increasing the coverage of this test to
> also verify the age handling of the merge logic.  Looks good!

Exactly.

>
>> @@ -232,12 +238,12 @@ static void damon_test_merge_regions_of(struct kunit *test)
>>   {
>>   	struct damon_target *t;
>>   	struct damon_region *r;
>> -	unsigned long sa[] = {0, 100, 114, 122, 130, 156, 170, 184};
>> -	unsigned long ea[] = {100, 112, 122, 130, 156, 170, 184, 230};
>> -	unsigned int nrs[] = {0, 0, 10, 10, 20, 30, 1, 2};
>> +	unsigned long sa[] = {0, 100, 114, 122, 130, 156, 170, 184, 235, 240};
>> +	unsigned long ea[] = {100, 112, 122, 130, 156, 170, 184, 230, 240, 10235};
>> +	unsigned int nrs[] = {0, 0, 10, 10, 20, 30, 1, 2, 5, 5};
>>   
>> -	unsigned long saddrs[] = {0, 114, 130, 156, 170};
>> -	unsigned long eaddrs[] = {112, 130, 156, 170, 230};
>> +	unsigned long saddrs[] = {0, 114, 130, 156, 170, 235, 240};
>> +	unsigned long eaddrs[] = {112, 130, 156, 170, 230, 240, 10235};
>>   	int i;
>>   
>>   	t = damon_new_target();
>> @@ -255,9 +261,9 @@ static void damon_test_merge_regions_of(struct kunit *test)
>>   	}
>>   
>>   	damon_merge_regions_of(t, 9, 9999);
>> -	/* 0-112, 114-130, 130-156, 156-170 */
>> -	KUNIT_EXPECT_EQ(test, damon_nr_regions(t), 5u);
>> -	for (i = 0; i < 5; i++) {
>> +	/* 0-112, 114-130, 130-156, 156-170, 170-230, 235-240, 240-10235 */
>> +	KUNIT_EXPECT_EQ(test, damon_nr_regions(t), 7u);
>> +	for (i = 0; i < 7; i++) {
>>   		r = __nth_region_of(t, i);
>>   		KUNIT_EXPECT_EQ(test, r->ar.start, saddrs[i]);
>>   		KUNIT_EXPECT_EQ(test, r->ar.end, eaddrs[i]);
> I understand the above change adds two regions on the test input, but I'm not
> following what logic it intends to additionally test.  Could you please
> clarify?

Both cases were intended to verify that damon_merge_two_regions() is 
called properly in damon_merge_regions_of().
The first one was intended to ensure that non-adjacent regions (170-230, 
235-240) are not merged even if their nr_accesses difference is within 
the threshold. However, on second thought, I realized this is redundant 
since it is natural for non-adjacent regions not to be merged.
The second one is to verify that two adjacent regions (235-240, 
240-10235) are not merged if the resulting region would exceed the size 
limit.

>
>> @@ -269,6 +275,9 @@ static void damon_test_split_regions_of(struct kunit *test)
>>   {
>>   	struct damon_target *t;
>>   	struct damon_region *r;
>> +	unsigned long sa[] = {0, 300, 500};
>> +	unsigned long ea[] = {220, 400, 700};
>> +	int i;
>>   
>>   	t = damon_new_target();
>>   	if (!t)
>> @@ -286,14 +295,19 @@ static void damon_test_split_regions_of(struct kunit *test)
>>   	t = damon_new_target();
>>   	if (!t)
>>   		kunit_skip(test, "second target alloc fail");
>> -	r = damon_new_region(0, 220);
>> -	if (!r) {
>> -		damon_free_target(t);
>> -		kunit_skip(test, "second region alloc fail");
>> +	for (i = 0; i < ARRAY_SIZE(sa); i++) {
>> +		r = damon_new_region(sa[i], ea[i]);
>> +		if (!r) {
>> +			damon_free_target(t);
>> +			kunit_skip(test, "region alloc fail");
>> +		}
>> +		damon_add_region(r, t);
>> +	}
>> +	damon_split_regions_of(t, 4, 5);
>> +	KUNIT_EXPECT_LE(test, damon_nr_regions(t), 12u);
>> +	damon_for_each_region(r, t) {
>> +		KUNIT_EXPECT_GE(test, damon_sz_region(r) % 5ul, 0ul);
>>   	}
>> -	damon_add_region(r, t);
>> -	damon_split_regions_of(t, 4, 1);
>> -	KUNIT_EXPECT_LE(test, damon_nr_regions(t), 4u);
>>   	damon_free_target(t);
>>   }
> I understand that the above change make the existing test scenario bit more
> complex, and cover the alignment.  Looks good.  But
> damon_test_split_regions_of() aims to cover multiple scenarios.  Your change is
> updating one existing test scenario, so I'm bit concerned at the fact that it
> is removing one test case.  I understand the updated test scenario is including
> the old one, but I think keeping the current test is also ok, as long as the
> maintenace burden is not that high.  So, instead of modifying an existing test
> scenario, how about adding the new test case?

I agree. I will restore the test case I removed and add the new one 
instead.

>
>>   
>> @@ -574,9 +588,10 @@ static void damos_test_commit_quota_goal(struct kunit *test)
>>   			});
>>   	damos_test_commit_quota_goal_for(test, &dst,
>>   			&(struct damos_quota_goal) {
>> -			.metric = DAMOS_QUOTA_USER_INPUT,
>> -			.target_value = 789,
>> -			.current_value = 12,
>> +			.metric = DAMOS_QUOTA_SOME_MEM_PSI_US,
>> +			.target_value = 234,
>> +			.current_value = 345,
>> +			.last_psi_total = 567,
>>   			});
>>   }
> Thank you for correcting this!
>
>
> Thanks,
> SJ
>
> [...]

Best,
Shu

