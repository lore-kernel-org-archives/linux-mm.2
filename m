Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3B21DEF06E1
	for <linux-mm@archiver.kernel.org>; Sun,  8 Feb 2026 18:49:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6A2C46B0089; Sun,  8 Feb 2026 13:49:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 650316B0092; Sun,  8 Feb 2026 13:49:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 54F296B0093; Sun,  8 Feb 2026 13:49:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 425F56B0089
	for <linux-mm@kvack.org>; Sun,  8 Feb 2026 13:49:08 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E704DBA32B
	for <linux-mm@kvack.org>; Sun,  8 Feb 2026 18:49:07 +0000 (UTC)
X-FDA: 84422176734.09.17D0B57
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	by imf23.hostedemail.com (Postfix) with ESMTP id 15A42140004
	for <linux-mm@kvack.org>; Sun,  8 Feb 2026 18:49:05 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=TgGNKR4m;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf23.hostedemail.com: domain of inwardvessel@gmail.com designates 209.85.210.177 as permitted sender) smtp.mailfrom=inwardvessel@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770576546; a=rsa-sha256;
	cv=none;
	b=TOAk4ge2EJ1IRoTWBf8Al3+Ahw882AT0bBg2vD6hmWcOlSaTk+ZZanDJOfW1WvnEYgNavz
	P6x0JAexDQDlHCis2RegwU6xi/fKLa46dRbxsyKpM9UhSuvoXUZWU4HgocalaoreguOU1p
	qU6emOtt2TLzkYraqB6DewTw6F53Obw=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=TgGNKR4m;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf23.hostedemail.com: domain of inwardvessel@gmail.com designates 209.85.210.177 as permitted sender) smtp.mailfrom=inwardvessel@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770576546;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ut1sGkenUeI9BD3BBVG16G8F8nlxjScJIq5pNB0m984=;
	b=xRVur32Ol43tXl5uoWpzLvNcg94YxQSSJDQsPBpTiP5Yf4VybYoKOea7K4VBqHgzFY/O0i
	q0i4oTyXhmwLIgr/y4KpsItkkteUghIqmWrIHll1u0G9LqU39MDguRYdLc18+UsJTRLIjr
	R2NXP+s8GBgIHAxwmbWpyAKdaRWInQ4=
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-823f9f81da5so1908810b3a.1
        for <linux-mm@kvack.org>; Sun, 08 Feb 2026 10:49:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770576545; x=1771181345; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ut1sGkenUeI9BD3BBVG16G8F8nlxjScJIq5pNB0m984=;
        b=TgGNKR4mOC2iUadfaubVQkZUxGd+xgHvHgmLvJ5IT8Ijse3GycUsyV2+OjQtcsDrOp
         LbetgK4HX2sncatdrFIMb/RrdVKbWE0t4bUhf6noCRF8ZExBxW8YPRvZ6Hxn2C16GJ8K
         ga9VRPrgdICJ3zzc0y10VaORNj/k4l2zR17myjEf43o7xO0SerpHN6a8k4gvQ46HAm0x
         hzroNkTnBgZUwDs52YOnpPWExIjEtBP6HlceBOW5mcbUvRTf4vSMUVx/5KS0tj+qR+QX
         gICnGwd1Q/rRuIktkntOJdKV5tb3XKIa2VXXOVDO3jMpCSJH4CUr+drKH/+5g2aXKGqG
         G/tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770576545; x=1771181345;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ut1sGkenUeI9BD3BBVG16G8F8nlxjScJIq5pNB0m984=;
        b=jUqlmwQ9s1d4Q5jzvS6gBumJqDqvcdHmjSjqbHcYwUPScs4UtQRLhFHALvpUocg/+Q
         HWBGNYClfjXhnmmAwoDn/JoC9XAzEOa4HuYudrftWZfjOMXi9T4OC0B0x9M4vxMC3FE4
         d+Loi+pB++pcHbHsxEEhwTf2+q37ILrStx6FfIWbkro3L/pALldOvrhAoninLQMkhFkS
         TjlI/u+EBIgHxAc7Pqohvq80CLd9moohCGITlYtNLefVRTd59szOtWow9D4ay2/zkCQl
         SuVWKFsgjd/7+bQ3iXix1CpOigobouWrfZ6pmDMNQSbk73wDdwNIq+UfzLSRDyXrbj87
         d0oQ==
X-Gm-Message-State: AOJu0YxIxaGq5NAzjypZdCAPJ7y/jSrLEn+66KirFV4KpN0teRIe4uCq
	yLKpl4pNPZaR8sSRlxDvWU/fYesPLXT3fFpboDeEOb5fy1U9lQPnNIVs
X-Gm-Gg: AZuq6aJ/u3VbvvuRo0YcE4ZB6asuocCQR3bcp59K9r3hl/OCVW6vh8Nc0WkFeItMEwM
	aRC3N3Q9fXiC+tJZ0Q1LGQgkM3xSotwZWYdPXCNchp8XT8tNm2+o1lpNwk5GAabbMCYHN0njccX
	K9zO+uD70XBwTZ+FZUevnYOHgKReiYMZJH9Gy8jpsEK38gaeLg5jAEPZMRRV/5c8Mp697faDua6
	8MTsvueNlbb9Bh8PYnIAdv/hqq2mWpBn4TojT41Za7eMQZzeQgWOEBtoF9Q12cUSadROQ6wvZl9
	aenai2wQ527WMuw9zL+6oq2vaqqq6KeaUo5OakbtG/nTLRzOt/PjRMRRNfAjLdII4aB7ohcTfGG
	ZYWsbV/mDMNGwu7DJxjaXao0fUAzxf8eLrow0K3vjT6KvYfouDnGroP5UZ0SoqVEBCuUdwBxmL/
	IeHvG116s3HMj5+kDN8hs1
X-Received: by 2002:a05:6a20:d524:b0:2bf:183c:ac86 with SMTP id adf61e73a8af0-393ad00062amr8537931637.25.1770576544736;
        Sun, 08 Feb 2026 10:49:04 -0800 (PST)
Received: from [192.168.4.196] ([73.222.117.172])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c6dcb3cb742sm7636288a12.0.2026.02.08.10.49.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 08 Feb 2026 10:49:04 -0800 (PST)
Message-ID: <3d7e7e82-594c-4387-8dbd-2b78e888ead4@gmail.com>
Date: Sun, 8 Feb 2026 10:49:02 -0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/2] selftests/cgroup: add test for zswap
 incompressible pages
To: SeongJae Park <sj@kernel.org>, Jiayuan Chen <jiayuan.chen@linux.dev>
Cc: linux-mm@kvack.org, Jiayuan Chen <jiayuan.chen@shopee.com>,
 Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
 =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>,
 Jonathan Corbet <corbet@lwn.net>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>,
 Yosry Ahmed <yosry.ahmed@linux.dev>, Nhat Pham <nphamcs@gmail.com>,
 Chengming Zhou <chengming.zhou@linux.dev>, Shuah Khan <shuah@kernel.org>,
 cgroups@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
References: <20260207013529.69681-1-sj@kernel.org>
Content-Language: en-US
From: JP Kobryn <inwardvessel@gmail.com>
In-Reply-To: <20260207013529.69681-1-sj@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 15A42140004
X-Stat-Signature: cm4puqd9rtmqjnu3sjqf1k7nyxtt9w1c
X-HE-Tag: 1770576545-724464
X-HE-Meta: U2FsdGVkX1891PRtYKtYQ4hVAnkqyAfbKE4J1bfB/SPwgJyEeyexv+bxwZneiNPZ2BJgamOYG4VAVPmIH9SQ0zgmHyEtUoowPHMVYfEn7mFItKodLNUVPaCh2ml3GIcqFyi/uFs4f+fwEbL1N9u5m3xnuKYbKE5Lt7gTBYyfTggGV/CZGnGZlR81HwctRxvBR29TuRDHK/qaQugPHtx/g6yELBfTPZx8H10BbjsEy53ej06w/JJXHGdOJHYlw3trLmRzoxqY6lpo+1G3aWDZ3oJzRExVjWB/Cp06snSuAEPASHSy2nXyrIRQSNKwIzO+8MNDqCphljFWB5y3tx4BWAtJUvECc6kBt0Y6S44Dna2ewf2YSi5F4wmnmiaIzeLjbcWIvZgmJ2/Rfus5rMLi+UEfmzswvIHX/85WttTXMoHSoYBkaQiYidFZlI3yqLz5lztINekekv6k+f1WfAZ5JYlz3edQ4fI2CdSx09pmupgcAjYXp7SSZCmmDE64ZMDa/IATJuB9UajeQU1hkhTvt/GPmK/9qxLq4RJ8e1y63bDWwc0lUTnJKnOn9slUeVjPtGrOoLqGzTUbN5vBkoH4aSryh6KJ36qQAJsfrszmulRfTSEp8oFKhqSUYADP/cvVhac97nUPBuJtyWL0KJZlWAPYOaHawaMKl3G60dCUHv0CJbrZFnzB0bCOPy+vUbuN2OhBanJbJrZyGYwieGndmztfdSaX7NQKjC/kScpc2vfMK8NUXShsq0Knd37VWE0/xmReRIVtHymoZTF348KRodMinO3ZeDUTssDafhSh5XCPplMiiAvbapAAdq0LAG8XLQ1UFReMUeQZD/ZDZKq/Scc2Cy4pGVJ6Nq5E3UV0WPO2WoU2CJmcTi9aC/dKnbBFMDR9YL039Od4K6DGh/tBzr8Ppqv+oAF9NjQtJF9Ma5ZvEdlO7C8cWR+si5YaXGe7ZOYU9gx/Cyx/VVYSiD+
 Op6t++Ow
 gYHzPEYV1IxRZQlPe+Gq3Epkyk5ktLGNyy4Hx4fIilHbhruKjG+jBH4NEWJ5Ka7Eya6ZhknyL80WnuyeJupXwQwRP7GhYgqw/iXZEqWdmfO9tK53n4p7v2Yp0Uax5VgwcEY6bsQrsZ0v10XaVVnChG60uYf9ufWkv1vrZdMLwSgxl7xQaT3sGwqX0TaFJe2nW9UEQV2ORTSbKHvFi+Lz/dXo835V11eh/5aoCrAQey3Bjq5k6wZIjgycJgzWoVv3hN3wJ2DJi8CpbTefrCnTgYMjqbvy10isadyx1lyivhiGnf6vA1p1GqDskvOFIDvWwQs9p6tUR/dnVNBBjU+g3jvipsoS1hR8eUd8gtkdaqROTqOa2kW7pEfHAJAANIf7YUDgDb4UIKoBHRzBPLo8F8wtMfiM+j02TjyRGriUV2U3xl9QBRZqW7999tykRgW+v6i+xaFKGrjzVMkXagVAG/k6kZy8gfTzuXF6LKRE4pypkBy0HKPTWkypCC44y/zxmloi4tLjBhOGs50viEB2y6mV6PtbCRX9uF1j+15MQJYHtdJ7I3iDPBiHsQQskcAE3X5qe2e6AXZXJDpLVSpuu450BOKjRMPuesBG4p/Bq5uSqAh1TWPLLI5EIxw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/6/26 5:35 PM, SeongJae Park wrote:
> On Fri,  6 Feb 2026 15:22:16 +0800 Jiayuan Chen <jiayuan.chen@linux.dev> wrote:
> 
>> From: Jiayuan Chen <jiayuan.chen@shopee.com>
[...]
>> diff --git a/tools/testing/selftests/cgroup/test_zswap.c b/tools/testing/selftests/cgroup/test_zswap.c
>> index 64ebc3f3f203..8cb8a131357d 100644
>> --- a/tools/testing/selftests/cgroup/test_zswap.c
>> +++ b/tools/testing/selftests/cgroup/test_zswap.c
>> @@ -5,6 +5,7 @@
>>   #include <unistd.h>
>>   #include <stdio.h>
>>   #include <signal.h>
>> +#include <fcntl.h>
>>   #include <sys/sysinfo.h>
>>   #include <string.h>
>>   #include <sys/wait.h>
>> @@ -574,6 +575,100 @@ static int test_no_kmem_bypass(const char *root)
>>   	return ret;
>>   }
>>   
>> +static int allocate_random_and_wait(const char *cgroup, void *arg)
>> +{
>> +	size_t size = (size_t)arg;
>> +	char *mem;
>> +	int fd;
>> +	ssize_t n;
>> +
>> +	mem = malloc(size);
>> +	if (!mem)
>> +		return -1;
>> +
>> +	/* Fill with random data from /dev/urandom - incompressible */
>> +	fd = open("/dev/urandom", O_RDONLY);
>> +	if (fd < 0) {
>> +		free(mem);
>> +		return -1;
>> +	}
>> +
>> +	for (size_t i = 0; i < size; ) {
>> +		n = read(fd, mem + i, size - i);
>> +		if (n <= 0)
>> +			break;
>> +		i += n;
>> +	}
>> +	close(fd);
>> +
>> +	/* Touch all pages to ensure they're faulted in */
>> +	for (size_t i = 0; i < size; i += 4096)
> 
> Nit.  I show test_zswapin() is using PAGE_SIZE.  Maybe the above code can also
> use it?
> 
>> +		mem[i] = mem[i];
>> +
>> +	/* Keep memory alive for parent to reclaim and check stats */
>> +	pause();
>> +	free(mem);
>> +	return 0;
>> +}
>> +
>> +static long get_zswap_incomp(const char *cgroup)
>> +{
>> +	return cg_read_key_long(cgroup, "memory.stat", "zswap_incomp ");
>> +}
>> +
>> +/*
>> + * Test that incompressible pages (random data) are tracked by zswap_incomp.
>> + *
>> + * Since incompressible pages stored in zswap are charged at full PAGE_SIZE
>> + * (no memory savings), we cannot rely on memory.max pressure to push them
>> + * into zswap. Instead, we allocate random data within memory.max, then use
>> + * memory.reclaim to proactively push pages into zswap while checking the stat
>> + * before the child exits (zswap_incomp is a gauge that decreases on free).
>> + */
>> +static int test_zswap_incompressible(const char *root)
>> +{
>> +	int ret = KSFT_FAIL;
>> +	char *test_group;
>> +	long zswap_incomp;
>> +	pid_t child_pid;
>> +	int child_status;
>> +
>> +	test_group = cg_name(root, "zswap_incompressible_test");
>> +	if (!test_group)
>> +		goto out;
>> +	if (cg_create(test_group))
>> +		goto out;
>> +	if (cg_write(test_group, "memory.max", "32M"))
>> +		goto out;
>> +
>> +	child_pid = cg_run_nowait(test_group, allocate_random_and_wait,
>> +				  (void *)MB(4));
>> +	if (child_pid < 0)
>> +		goto out;
>> +
>> +	/* Wait for child to finish allocating */
>> +	usleep(500000);
> 
> We might be better to revisit here in future to avoid racy test results.  But
> this seems good enough for now.

How about using some form of synchronization like an eventfd? The parent
can wait here for the child to write the event and avoid the race with
the arbitrary sleep.

