Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B9010CA1013
	for <linux-mm@archiver.kernel.org>; Fri,  5 Sep 2025 13:43:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 085E08E0008; Fri,  5 Sep 2025 09:43:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 035D98E0003; Fri,  5 Sep 2025 09:43:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E671B8E0008; Fri,  5 Sep 2025 09:43:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D58518E0003
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 09:43:19 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7EAA11A018D
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 13:43:19 +0000 (UTC)
X-FDA: 83855313318.17.8D4CA7D
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	by imf24.hostedemail.com (Postfix) with ESMTP id 7FFE4180011
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 13:43:17 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ijY9cQaC;
	spf=pass (imf24.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.43 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757079797; a=rsa-sha256;
	cv=none;
	b=XuNZg4xg3ZZrecWbBc7EAM1FIYCd4iRSM5TZaTuZdB67sV9uphfg8INTdU+pRjpRjUgBwy
	XXhUeN4Hn21PP5+GXhZrV1sGHuoWfoIiXB8FcciihNofv0XJShS0/vFUpKmiqjYScleAW3
	zG6lqu0KHlIltqCjtp57rtckBkltI9U=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ijY9cQaC;
	spf=pass (imf24.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.43 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757079797;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=juZ+7zdFswSCV5MJ/mR3oqW01fzlnWz0KXmck3Yb0Yk=;
	b=nzekcGC9rWr68syyExzKhwXLAi2qvj4P6yXp8JMEMw8s0y55DhgkbN4Fi6pbkJzNFYf1XS
	uBn8i6aGnIOYaW4Y8SFB+0WtnTVFDeSGv4PSZCs2rIqrEMwAyFgVKst8on2sZi7N9IDzuv
	lSqW+hQdgMpJwKc2BlYAayHtzh8WGlA=
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-b00a9989633so394963366b.0
        for <linux-mm@kvack.org>; Fri, 05 Sep 2025 06:43:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757079796; x=1757684596; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=juZ+7zdFswSCV5MJ/mR3oqW01fzlnWz0KXmck3Yb0Yk=;
        b=ijY9cQaCjIpAaYoppaYD/+gltiX1a4iTj6L3h+3cfWu8Zxx59RJirl5rTrceDkkXSs
         uXUSGVNPsUOPimVnA1CPHosFi51+U2QSJ+UhGySBDeO9kCGeoVB0aRNr9/ATaq1P+zBV
         KxyVC98nX58pNVlKqPpkTjnbatar9SqbVaVmP6JUIOvk64u3WYJsSSVHfZJK1RXg+A98
         UeL3a0o8Wq3hiOCDXamH4JI5D6NQ5wUugZNVqJ1arolRSaSfg1z8JCOfIAc7nY+Kf6Av
         4yN0VpRx8/AHzyO+xjC0+KyowT+EuZTW5fOQsu7u+jPlNGCX5Ok+MwFQaJ2QHMdAg2we
         jaiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757079796; x=1757684596;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=juZ+7zdFswSCV5MJ/mR3oqW01fzlnWz0KXmck3Yb0Yk=;
        b=GffiL5Sjfo1KCTAY1uZ7+xXkyAqxgTZFp/OzD+PpPoSp+wSdczcyXlFxiZRrNttRQS
         6XhbVCNZYIeJOrmQPbbIZvwynZgh6UzOU4G67omu0A/rljhwIulJF+cGSjX9qXqMMZ1o
         arHr6d+v9xU4OTMGJLgfOZIS0KCQDh4hZosXwmKG3vSVESBi8y5e73UGUV/yw83k7v1q
         WDYptk2zEuP8bxamHGGptk8LC+GYeHTb+u3o3VhVmqfJ30Qwo73xSgHn2yR7mdwUtmhF
         JqguK6AMPED+1Isz+xIMr1ceVayZT7lvjzht14+QmU2/lFrVjGQy1T8StViirbaLmSqw
         c6+w==
X-Forwarded-Encrypted: i=1; AJvYcCW2nO9muWqiqGwhisjJDWa42VRj5Izuz4FPCGUBLnNMNojn9F9/Pb3WNxxv/SkgCmm62Gi7MCdl5Q==@kvack.org
X-Gm-Message-State: AOJu0YwMWMVvY3PBEwDc8Co3MGdnH7qbKJRzow/egE0jgmRiXp+gNqSm
	aUn1xwDiDE8HeeIKhZ6vwNpXZmMp53nV4YaqZ8ogC/BtN8vqSa9wC0Yy
X-Gm-Gg: ASbGnctzJzF0GtcGo+qiDlbOvMB/7ibQKRcrH8yaIs7dCtFh6IDg7E5yT83ituBUuaJ
	M4jqDT2zV3eqyccP1Phl/2NXxKOpdje12LFnVoO7mA6M8co40TrRzm56oxwWkvtq3xLSFNVN9dy
	rtua0LdL5YXN6WG4K/Lwp/f6Plrl55QztgnZnhPPVpJJGzoGKgQEfPIwD6mApaSZA1T0vZlznU4
	cyX0RHNGpNgy0z4bsMsQunzAlUBwwpVvzkx8LSmrRXy1b9EflUkgAzI68IzOxBms34bcFrq9pmk
	qXINj6IcpzrIkpJQS8wubMY4H33sqB1vgLe4xz8wnjb0eX3apckCjJjXwRRvw9w+7fGqXwgg5/p
	zPACejsD0NheeQ+lugiQn6ovW1wd1t4cVRxl6
X-Google-Smtp-Source: AGHT+IE5JMyQqUwpkPg8CFFCWJMeKbw0x/igK+7eH4dTNlZp1hUIn7oWePKMUt4WxHLfW/MktPRWMw==
X-Received: by 2002:a17:906:3457:b0:b04:2c2e:50a5 with SMTP id a640c23a62f3a-b04930fcdf3mr340136366b.16.1757079795706;
        Fri, 05 Sep 2025 06:43:15 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b0438102debsm1132302466b.66.2025.09.05.06.43.15
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 05 Sep 2025 06:43:15 -0700 (PDT)
Date: Fri, 5 Sep 2025 13:43:14 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: wang lian <lianux.mm@gmail.com>
Cc: richard.weiyang@gmail.com, akpm@linux-foundation.org,
	baolin.wang@linux.alibaba.com, david@redhat.com,
	donettom@linux.ibm.com, linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org, ryan.roberts@arm.com, ziy@nvidia.com
Subject: Re: [PATCH] selftests/mm: refactore split_huge_page_test with
 kselftest_harness
Message-ID: <20250905134314.vtc4qspuyfjp4oah@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20250905032431.22179-1-richard.weiyang@gmail.com>
 <20250905091029.81259-1-lianux.mm@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250905091029.81259-1-lianux.mm@gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 7FFE4180011
X-Stat-Signature: yd1kxjts86dajp4tkwws94eyycnob4ef
X-Rspam-User: 
X-HE-Tag: 1757079797-71607
X-HE-Meta: U2FsdGVkX19Eoaae3/mOPbPo5spcaRKPW6vh5lyy75ZStxLxUGSg1fkTcHKhTSYgZnu9KzmbmY7cDISmluPF3nu9hqXTD0WmamBuXlunAKaC/hfYCa2irk7l4VJnpAgOwwl1ms2dlRvDcHvxdIrbmXNxr83RfizXtDjUPy4tCoi2Iw7fH4WGjdFe5S8X/QpWhCVSH36PN1mzar1pJW9WRmSbE7JNCtAxnS1wm58nxzVfN8y/S5lCBFdGpRIxXbqyeTHexvMdv4yjcfQVfC5PjQXlbEkf+TjX3HNXufAyNFN7bFBdSOZwqVttsJ45Gu4bFkrO71YIFYguHxOljkLjh+foiQOdVg/N6T1BAkGDmngfMN3u2a1MdOnxBU67w9EPjSLZF5ahV19TIM8wGLrkFomugwnEzIXZZZhnT5SuuJNtAPqtEYkSHl1Iv1VYasKEagNBEQe+Es20a7jYkPAX1k12PQCXw0AYq9BHrJ5XBOXoIOTh8GJIwZk+QTBtJdFiOrG+ZRqTTHbA77sS3yZdVBJkfFbptvRFD1vZbYrVmYCNdpzhwKkCOXOtvfeRwuBmQCwSKHqV/P0ZK7NdBTdtCRve9g4OpgbnUcS3FTEfKbP+51NN997zEc6IXGC1tqmE7NXgufjovXFQCFG+qNvH8hEBX/7NUjTdXa6uxlenSsiHHe3GYbfaQ47zeNsh16Th2kxiM+eaE6+kcKteMWZRc8iogimywwhkHUzJ8p0pMPaECibN/0BcM5WyLIehHcPaEGJUxXZTHfp3KC7ZXrWHbIbn9T6NNmlcK3Xq0EKx5V7F1lS5w4SCsi+mLQU230GJCP8Tk03Pc9HCdSluJedNkoSJScs8qwZxJWXvL4EM7jkwMM6GQHt+aLx6xKA2pRoimFMK9bGPeTxw1OYEfhMkaUoTCDVewocx+VldlLBCG/dTEa5ckRa3l/ZZYPUo/ffmoLryhEBioHSVj+5BAcc
 5IU3WFJM
 8y7ZEMQqbJQZYwyAKTl5RAV6m7M/OQoZDwm31e+TyjsaorKECkkNSj62Q5qZFlastjLlsZ7UesBQiRhW64SZNSZyPWPNJzfZs/jrjLpPMJN2RHyPifpNk+aIW0+rtLHqXMN+eqss31rtNhY2nqoSVYRmi5HAOekrAPGRicXznkGTBN/hKkMh74a49Wgi0a99MT2SsNEogLOZiiL7rANM5Lk13OvCpVTdVG+GzLAiR+m63qdv8rwmZFnfiA5M8RACrt0xh1dMOApwl9OULhjoOSumtAamKMbHuZn/OYTCiDlfMPkVMd2UYabaAewJ/wlYxO9wSGm83v9iGuzedSdQvHTLvzB8Bq6pSPpuG1YYDXGLWsapHx6nu0Bd13I0rZ/8qsVuEwynjnKDmP7XzvbJLsZmqGeNARV0HnRqJ/SkzXmPHaueaGLkWoPt2HM8KQ0JSDoOVP4pPd8XpS+4DtR6JNkHlBlg1nw12v6va08isL2u3keeFKmK0vmywfBrtuMgjwee3iju72cvIE+pTPZOmjGevsZqll/DueBCuHI6OpYKaLaBA+74mMlgqTBxY9XMjnUMXnsFDa181BctbLxEEsZyoA7WylLXdkU4eSqNMcakQ/ZCsy13JTMyMFr2URoQRvhEJbeF7E7KBZeskqP1mNBwSfTG0Cb9bFzNwZeQqMGoS5TPfzP1iruGSn6KOs4um7yu9gTj8BIlGxK8s7r8QcAeTJpzpiJ9ssNamzNjyuFdnDzcTP/Te31PSVQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 05, 2025 at 05:10:29PM +0800, wang lian wrote:
>
>> Refactor split_huge_page_test with kselftest_harness, since there is a
>> magic counting about valid tests.
>
>> The idea is simple:
>
>> For standalone test, put it into TEST().
>
>> For tests iterating order/offset, define fixture and variant with
>> order and offset. And skip it if order/offset is not valid.
>
>> No functional change is expected.
>
>Sounds good.
>
>> -static void split_pmd_zero_pages(void)
>> +TEST(split_pmd_zero_pages)
>> {
>>  	char *one_page;
>> 	int nr_hpages = 4;
>> 	size_t len = nr_hpages * pmd_pagesize;
>
>nr_hpages and len appeared many times and 
>david use nr_thps and thp_area_size rename it.
>and maybe we can unify it and make it into FIXTURE and init.
> 

Thanks for your suggestion.

Let's see whether this refactor is reasonable first.

The first step is try to preserve the logic to make sure there is not
functional change. After this, we can have this refine in a separate
patch.

>> +	prepare_proc_fd();
>> +
>>  	one_page = allocate_zero_filled_hugepage(len);
>>  	verify_rss_anon_split_huge_page_all_zeroes(one_page, nr_hpages, len);
>> -	ksft_test_result_pass("Split zero filled huge pages successful\n");
>>  	free(one_page);
>> +
>> +	cleanup_proc_fd();
>>  }
> 
>
>
>Best regards,
>wang lian

-- 
Wei Yang
Help you, Help me

