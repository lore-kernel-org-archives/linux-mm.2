Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A741606A321
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 03:01:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=k3Effr/9
Received: by kanga.kvack.org (Postfix)
	id 563286B05BE; Wed, 28 Oct 2026 23:01:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5135C6B05BF; Wed, 28 Oct 2026 23:01:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4296C6B05C0; Wed, 28 Oct 2026 23:01:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0CF6A6B05BE
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 23:01:09 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 85F801601B9
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 03:01:08 +0000 (UTC)
X-FDA: 85374162216.22.FF269C9
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	by imf02.hostedemail.com (Postfix) with ESMTP id A5EEA80008
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 03:01:06 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="k3Effr/9";
	spf=pass (imf02.hostedemail.com: domain of xiaoleiwangxiaolei@gmail.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=xiaoleiwangxiaolei@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793242866;
	b=482rE1++0ppqMGKW0Va9UKY84fuhDVwZzEWbAg/ADQmw9ZxvHtZTYxx0OFSveIKsS+OfY/
	vHD3gry7yEwX4WZH0oY3RtPaghd+UB3AaP+9YqFmduoIE6Cp8wfK4TL9tbzcBigAc9/Vhz
	UgpgHa0w4NuGcwWRYyRDdTJpZYpfOno=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="k3Effr/9";
	spf=pass (imf02.hostedemail.com: domain of xiaoleiwangxiaolei@gmail.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=xiaoleiwangxiaolei@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793242866;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Bkm7zevt2pJ24dJThsCd2BuWJE9RCkG+R9d+KkvdTQI=;
	b=4LB3xy33hPMq20aAwrPJ0/jyXwWrDs0rAguswvhtPBvH/YUzRfuddkNslpC1iYYEv/heyc
	SP5r4Fy96hcfkx4hh80Smgk/BkZLfODw749ddlRFWL2eYu6NOJN4nhWJCZ0dClLazVBtjG
	ncQQZp8CuWVKlcmt0if7qbwTMfVTq5w=
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2e985106c0cso14353595ad.2
        for <linux-mm@kvack.org>; Wed, 28 Oct 2026 20:01:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793242865; x=1793847665; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:subject:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=Bkm7zevt2pJ24dJThsCd2BuWJE9RCkG+R9d+KkvdTQI=;
        b=k3Effr/9ybKIGNh9ntHUn9uP21lUIrFrcB2o9JRrZzbqi7/b7dDT/psGILvC/xMZYe
         24WnlVENeTYNvwCTqtcnT643rTXlh97X4cBnuGusrWh+CzJ0WBSHbPVRY8tgLvfGNwIi
         omN6IQfdGoKr7+BjYzQe8UlIFB0ycnWYOqDocw0nQoPFLQ8/Ds0XObFIgEhTSRVMEmXD
         orblHfS3yB7mIMYHILXssgxEAt7W09nKXKuU+7bxEYRTY7m4K9DLQ52qTqs3XeV8wHVB
         NYCFin+fWvQ5T2HGjjTy2ykPfgozYsXRK21VcTSaLsNXxC7r39SVVBmuzzjtS7LH4hbY
         YYRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793242865; x=1793847665;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:subject:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Bkm7zevt2pJ24dJThsCd2BuWJE9RCkG+R9d+KkvdTQI=;
        b=wkBh1P/NtWarmze+Mwse1rXtGaMEIw7FlQUqjNsIJAG5MdEYnNqbI4b0PwsGaJCYbJ
         5CuRajWOPOzyrLKnbuvbGkanUujG+iH6wmL57RV3FWyqA2oT+dPnFKfojig39IIjp8ft
         erE9Y9lIYjtDWuB4pN5I9/bCxelBIIBQi7CLhSLCIBcgIRV8QnYe5oUxYV5WFI7rlIvP
         ULbc4/i3bvUQG3NUxJkUC0LhRvF5gdybilTdgCaxq4DaP0lqvt0CVMA5xanOpFXaWt0U
         d+ZmnrmcMDmjaGKqKjunvESLTmO20HPi+ou+7sGA7cuY1Pbgdwoxb9yF+noTxWL+Y0AL
         XpWA==
X-Forwarded-Encrypted: i=1; AKwUvBxhuDLc0d3lhCricxU2N3yBVZP2rbDuW2X+x76tv3O5KEN8MwE/jEMdRI1kS+Mp7A7GK1dvcJRJ/g==@kvack.org
X-Gm-Message-State: AFq9FYJUKF9Os32a07bGV596p7axUCFbf/9/RNWfog8qT3GfBP3zAVpX
	QoHSaKoO9zth7wPyEL4hIHIE+h2lE6MNA5P2e1oLwceu1X6EkQc1Ky5K
X-Gm-Gg: AYBFou1Wjv0pMGjo6r7qCpb28MaBQvbnNtkedct+GNutuGp+SQ8zx5cddObS7zsEcUN
	NmyC9JVnHcpVra241e32rSV1XORtJWnwTeZqry3/C7yh/YGKxVuNIynC/Oimmj05218j6sZGYlz
	KQC87RC4pmNjd6oo0WsYjxiaAOVqgBlbyu8ULdrHdEV+vG5h4CHdlrBQvCwVwWxWVIei2LmhqS/
	+PFBKPQjxzuuG+qQ+pj0IaapCjI7FhEDBIO1IsKCKxlPgkNnw/KE9bEn/BMwxu8nN0HCjlas9Dq
	WrMyeNKncXhXS4AcrjaWP+LWvDt1gefBME6MtkPQx3+fdiMPCivw7cMDbXForPT5qGKuklVpIii
	VQrkUP1hrgoNwOK+/cG7aIKGO/q1UN9UjIQ+uDLJ3AaI8mlDyhlaxebAQZqYyyiNgulPOANgy4F
	0W1KNqXJJ9v02U71TDhK2EHDpK4uv4eg/iT5dd+zMkesAQBClGHm/12b8fxgaPb67RfSAOnlfa3
	iLSAhtXTBX9NQno8t/q2kOOtdY7F9cy0b/VFj4pzTXpuopBOnGlsr/CKBvoPvwyVN4TC8xaNgD2
	AE8nbS1dxXylBmyod460Mxhnewo5i67diUc7ryutJr1sMS88bxjrPQ7IgsHcT5BPD3HF8V1cGPs
	y+aKNtzNE5fvZPFRHsCsSiU0G0I6MLw==
X-Received: by 2002:a17:903:2cf:b0:2e8:1f8a:9113 with SMTP id d9443c01a7336-2eb00541fa3mr35157725ad.40.1793242865314;
        Wed, 28 Oct 2026 20:01:05 -0700 (PDT)
Received: from [192.168.52.49] (ec2-35-77-214-194.ap-northeast-1.compute.amazonaws.com. [35.77.214.194])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2eae6b7a216sm26722755ad.16.2026.10.28.20.01.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Oct 2026 20:01:04 -0700 (PDT)
Message-ID: <8f353f85-b8b7-4808-9a18-86a8cfff307f@gmail.com>
Date: Thu, 29 Oct 2026 11:00:58 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/damon/tests/sysfs-kunit: fix leaked pid reference in
 add_targets test
To: sashiko-reviews@lists.linux.dev, sj@kernel.org,
 akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org,
 error27@gmail.com, wangkefeng.wang@huawei.com
Cc: damon@lists.linux.dev, linux-mm@kvack.org,
 "Liam R. Howlett" <liam@infradead.org>, Michal Hocko <mhocko@suse.com>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Vlastimil Babka <vbabka@kernel.org>
References: <20261029015725.17378-1-xiaoleiwangxiaolei@gmail.com>
 <sashiko-outbox-188628@kernel.org>
From: Wang Xiaolei <xiaoleiwangxiaolei@gmail.com>
In-Reply-To: <sashiko-outbox-188628@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: A5EEA80008
X-Stat-Signature: z58s8h6oyybnrpb3jm3am5zkdwb1s3qc
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-9.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793242866-454487
X-HE-Meta: U2FsdGVkX1/ADDas+cD4BrpsREhkobCecrcbmf8TpTzmVJrGCuIVC04euM4DvuNkI3+S+C6sA4dA8Mm0AnqQ0ZDKwPxXs10/8ABD5WfKfGlslfGARnBuUC71S7zXejOK312N+jy/cb8Vb/jiJW9czJy5rE98v0X7nLyKvL/P5zfuQ+xWBcbnmtlcHbWxTNnA4oy3l5SeVWZi8JJsR/24YFMouCaHb8EAg4jTrxjia/wuUl0CEsyAu9iez6ongFU18MmaYEzWeeSRj/SD3PWEWhVC3XB6Ate450ltHbCfsfUKpbZbPu12X/sDMCkPSAVlLrVhFD/6QZW0VVZPdRd3nj29+IBdkd8TAkyjH9ljv5teUcGrllKG3IZu3vH7oy9+tRE7PxVenUszT10mY2IScDidStyhwuXwwnbQcZ8PFROIa3C5V4JNOMl+oP5JC5XQJrMRLMZGasHvphgVd9mj72KG4d1mnEDCa4Lx4dhMizFIJwcuqIJZW0szKe3QZMJp9nzfs75ednEuMicdMVoCeQvfyA9SwpmWIxLbs71ermAgK+DjZeclw5v63zyt3eum1cPI10bVeHHh23wI3eGttf4pA4/r93Tul5Iq7eSdraonNfN8E2YEiJvgTeOQZKLDm+UgzGmncdXu+tkt/m9ryROHzRJJg6/ICfylXZZI8aJoy7nkVz6ph+gEbuA3+wAOvl+LW8QpT4xnE9/Rwg50FY8aX300BGgDQw6fn/ikeT1pdfE9GpIOXgDzYebujO2ZAvCKimNfgTf51ls3HSxcLtG0H62KvTdMQnVSkDPiEsZLk8LhFVsXpq2aixi2nwDl5/o00/AXZZq/fwY1z0fnUaGKjdoYQiU0+W7e2upAtIBiGZJKWZ6Q2MngKUoit9Xz0aGeCWADkPvxactPMr6jpuDFvwJzz6BC/tM6OG9H0i78dSHYbv2wKfv/0nwJr1YeftKqkCTbwGmagw4dHsQ
 1X+iKyP7
 th+8WAthckYdD8l/U+0cyrn/fXKWj4jWEMhhGLXC6l2KXp7RVKU2/RyRUr6C5zSFxL46mo2Jirm/PfXwRWBtm9SszEh+fB7n49Frzog32sCFNwzobcn/kEGBVSNNRlOZHxQMe2ThTVOKiHzGm6en/dGzaR6gdj5heoKHDub2zLGSehoXLb/T15pOPah6g4WIuKbSSnzhEGW4Z9Mypf70ZU/S2SSu+1h6Y2E+K20BjR7tLNu4T11SX3zEsFkG6R+b3WYZZoYZomBC26fkDQo8wO263EpmaVhu5zP4resz3MERhDBOBnZDOaZD1hpJeAk+Zue/oixkH9GeQDlO5MX5ci/9Womfbz8yf1475u0u/ZQWAvoVNXg/hMdVfkG2UV44tmyvyIP/8Q8Tc1CBfOHFKqujd6xdK70JHK0etNZOPXoqkdeKt6MjjAswKXydT+12YzGA7WBtwnlf8lc4NDxEvQsXxL3DkcRTn+Q69+u8VmDXMEerS+eNrXu+ifHnWpxnjos3R0KwtVc1GEmaDuOe70SRNxW04lG5HqyBGzAUbZc6w9i9Qq+akfgHydCukL+D6OUWDE5i6AV8/fW09QUhgzjjzrsbrSjEzKETlynXbKK+OH7f3MpfqqpZu9A43bas9lK7DUBBRfBUia+anTfEb4MEwgQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1


在 2026/10/29 10:02, sashiko-bot@kernel.org 写道:
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [Medium] mm/damon: memory leak of ctx in damon_sysfs_test_add_targets() on skip
> --
>
> commit 15e9d751202cdf7c593524fe7b4266b6f6dd0dbf
> Author: Wang Xiaolei <xiaoleiwangxiaolei@gmail.com>
>
> mm/damon/tests/sysfs-kunit: fix leaked pid reference in add_targets test
>
> This commit fixes a struct pid reference leak in
> damon_sysfs_test_add_targets() by calling damon_select_ops() to select
> DAMON_OPS_VADDR on the monitoring context before adding targets, ensuring
> that damon_destroy_ctx() invokes damon_va_cleanup_target() to release the
> pid references. If DAMON_OPS_VADDR is not registered, the test cleans up
> its allocations and skips itself.
>
>> diff --git a/mm/damon/tests/sysfs-kunit.h b/mm/damon/tests/sysfs-kunit.h
>> index 138a4b8d14e73..634387c6178b9 100644
>> --- a/mm/damon/tests/sysfs-kunit.h
>> +++ b/mm/damon/tests/sysfs-kunit.h
>> @@ -79,6 +79,14 @@ static void damon_sysfs_test_add_targets(struct kunit *test)
>>   		kunit_skip(test, "ctx alloc fail");
>>   	}
>>   
>> +	if (damon_select_ops(ctx, DAMON_OPS_VADDR)) {
>> +		kfree(sysfs_targets->targets_arr);
>> +		kfree(sysfs_targets);
>> +		kfree(sysfs_target->regions);
>> +		kfree(sysfs_target);
>> +		kunit_skip(test, "vaddr ops not registered");
>> +	}
> [Severity: Medium]
> Does this error path leak ctx when damon_select_ops() fails (for example,
> when CONFIG_DAMON_VADDR is disabled)?
>
> Earlier in damon_sysfs_test_add_targets(), ctx is allocated via
> damon_new_ctx():
>
> 	ctx = damon_new_ctx();
> 	if (!ctx) {
> 		kfree(sysfs_targets->targets_arr);
> 		kfree(sysfs_targets);
> 		kfree(sysfs_target->regions);
> 		kfree(sysfs_target);
> 		kunit_skip(test, "ctx alloc fail");
> 	}
>
> When damon_select_ops(ctx, DAMON_OPS_VADDR) returns a non-zero error,
> kunit_skip() aborts the test immediately without calling
> damon_destroy_ctx(ctx). Should damon_destroy_ctx(ctx) be called before
> kunit_skip() here as well?

Agree, fixed in v2

thanks

xiaolei

>

