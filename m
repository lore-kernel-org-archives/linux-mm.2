Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A59FC87FCB
	for <linux-mm@archiver.kernel.org>; Tue,  5 Aug 2025 12:19:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 20E478E0003; Tue,  5 Aug 2025 08:19:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E6468E0001; Tue,  5 Aug 2025 08:19:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1235A8E0003; Tue,  5 Aug 2025 08:19:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0581C8E0001
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 08:19:42 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C3A3A135483
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 12:19:41 +0000 (UTC)
X-FDA: 83742609762.06.85970C7
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	by imf21.hostedemail.com (Postfix) with ESMTP id B0CF81C0003
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 12:19:39 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=U60i6eFJ;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf21.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.221.41 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754396379; a=rsa-sha256;
	cv=none;
	b=rO9egE+o5wIGzAQZ6xlxIP8GICQ0DLqDUrd8PVDGPwzKNxxYbgTf+vnowAH7ohS5yTikSS
	3PtxiorT65f7bXtDe05lAlihVB4fLw/q0ocS7HVsCzVMLpPQQ0pGMwhekidrCBIft2vYjr
	tgcowP+y1TTW0hKWz4WdqpoXgdV0EIA=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=U60i6eFJ;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf21.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.221.41 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754396379;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=78HKa+a6ttLBuyJSrEIeZC/Gs73gWB6HpOEqp8Bqj2U=;
	b=T1QWPYk7GdPI5vg0KpoPr+fHYj9GPUtdPlxe0B1fgggEbCmDeilfL015vhaZfaIHlwSrME
	VktnGvoHmO6N7LGo9lbvE8A6gXrLOlr5b7LdaP5B98PCQLzFLo4Jn6M0sLYbLV1DXQ1XDU
	0E/+hVebLzsVUagi9/xHJh1Q2SHCAPY=
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-3b7920354f9so4903719f8f.2
        for <linux-mm@kvack.org>; Tue, 05 Aug 2025 05:19:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754396378; x=1755001178; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=78HKa+a6ttLBuyJSrEIeZC/Gs73gWB6HpOEqp8Bqj2U=;
        b=U60i6eFJ/N0xU7p37E/LKcCfl/79cXpMtQSTUMiHON3Fqq9Lr8dLzJcC44IIJNcwOK
         f0BOBXlnYlb7d4BFXiumBGIOWjCTFP1Xjb6qpnhBdt5UGk/iqkW1KnA5GWtmg4L37UcZ
         Xlg99OZJ/ffgLt4v+es4Y0DF6vwropDFcxNhNeFVggn4526PciHLFywb5Xdkdh6T+mMM
         f/VAItS3Jc5UeppBt7ifFF10vQF6hYDQgpHf8FkoTuPNSwkiJ0OUY+F+8veD05btb+1x
         vx4Tn2d9zAALFcFUn07xa2cPnS+VuglFau4SotvUDYnzFc2gWb0gW3Y5mtXSZHL745n4
         icMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754396378; x=1755001178;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=78HKa+a6ttLBuyJSrEIeZC/Gs73gWB6HpOEqp8Bqj2U=;
        b=C04hLkbVTZp87nbkCZTwHDn0eK0WOp27cJs2n+Pat0Ec0LBA0FFUOIw4idgSkJcgSm
         UjMQDnALoL/MeYmgOSArLpF5idimVFew81vKnYIwZJZ2jmSY2noYoJKGzWXJDIaLZQSH
         VYYkPsr/NV0fdOUb/ljaipHNgexsvU180AJdnGpvONL3vrfRGG0qPiW3vV94dvcSG1TI
         +6YPfSvuGEaKbMa/IojxMTzHBvCx843EJLh4Ydu+ls7qrCmrHTE9yAvdm4iAVbQ5PiaL
         UqU3UW+dg1268ytr+3Eq8jdjZ+bPdVeyEgBtBzRD49lqXLqCo5ZYm2yRlDcAE6GxfaG8
         SAoQ==
X-Forwarded-Encrypted: i=1; AJvYcCUWRuCbh4IRsN0gEQZHY5DF60x6GadYFdGERUZZD9saCT/OxysoAIhIxRKkHP40ibUPbJo9Ja2gqQ==@kvack.org
X-Gm-Message-State: AOJu0YyiL9ivIcC9QQnBe9dPYRjydKZPlo0XNYIrwG5/Mkorytk+TEYy
	N545NmJ69ZMR6sVYg0LL6imqScbUruwh4j3uwaM0p6liGtaCkfGzeNpW
X-Gm-Gg: ASbGncucY5vEYZIcD0Z8oSMW7OVvdyOfJYSHE1vxq4mMDjdhMp9z25olPQ/hT/cmFKo
	f42nkufRmy0gZP4iS5l4qOU+di69Vj8J4t0PoQ3/oeebQgIhQ9Fd3pdd6RhIh3L8atUP+lbK6Yi
	hmZWM8EAs3CxWEHvpfgOCRn9gII7TZh/y6BaR8cdRMr4oTfrJb2ghHCAeXIdznUEUUhnBEviUVN
	MN0qLuIdHd8cDSj79FiqfNymztiNjJUFVXyPt5TvgmiH5HyMYkqgJRWwo7Z2ohpGupzFjkUDGwH
	jP3IoR5+oSbKj2sAhG1lMBf9iY9ZTTld4bjwYYkNQXuobm8eD5nXRZsPbkHyvBpflkZb4EEvqdQ
	dokvv3pRZ8UgpYgPuaLaosCrFKMDs3wdaIrDLohA40pVnKt8TmaEGGUWvjTZCu+QXCHIUKozl6F
	Is81Y1cw==
X-Google-Smtp-Source: AGHT+IHTS5vcJBuFiQHZY0njOLPtazgxkIpzBiBUdWqiYuGyDBX2gvjL41xBxww/IULLy/qEhfp7NQ==
X-Received: by 2002:a5d:5f4d:0:b0:3a5:2ef8:34f9 with SMTP id ffacd0b85a97d-3b8d94b9fb6mr9421147f8f.27.1754396377752;
        Tue, 05 Aug 2025 05:19:37 -0700 (PDT)
Received: from ?IPV6:2a03:83e0:1126:4:14f1:c189:9748:5e5a? ([2620:10d:c092:500::6:98ea])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b79c453333sm19744940f8f.45.2025.08.05.05.19.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Aug 2025 05:19:36 -0700 (PDT)
Message-ID: <5dc09930-e137-47ba-a98f-416d3319c8be@gmail.com>
Date: Tue, 5 Aug 2025 13:19:32 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 6/6] selftests: prctl: introduce tests for disabling
 THPs except for madvise
To: David Hildenbrand <david@redhat.com>,
 Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org
Cc: linux-fsdevel@vger.kernel.org, corbet@lwn.net, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, hannes@cmpxchg.org, baohua@kernel.org,
 shakeel.butt@linux.dev, riel@surriel.com, ziy@nvidia.com,
 laoar.shao@gmail.com, dev.jain@arm.com, baolin.wang@linux.alibaba.com,
 npache@redhat.com, lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com,
 ryan.roberts@arm.com, vbabka@suse.cz, jannh@google.com,
 Arnd Bergmann <arnd@arndb.de>, sj@kernel.org, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, kernel-team@meta.com
References: <20250804154317.1648084-1-usamaarif642@gmail.com>
 <20250804154317.1648084-7-usamaarif642@gmail.com>
 <9bcb1dee-314e-4366-9bad-88a47d516c79@redhat.com>
Content-Language: en-US
From: Usama Arif <usamaarif642@gmail.com>
In-Reply-To: <9bcb1dee-314e-4366-9bad-88a47d516c79@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: B0CF81C0003
X-Stat-Signature: morye81xzwh97kyiznodriswso7pdghq
X-Rspam-User: 
X-HE-Tag: 1754396379-562789
X-HE-Meta: U2FsdGVkX1/qoaHpqf4j4a4rMiF3kk3FLxInbe5q1GfMNOwky+Wty7qhu1reJYrvB+ldUL/WaFujOVW4HzEm9OviioTYm+BmDySyEKYgCuYcPnRVeiWNVViICA9+0EivaV2iTz0uJH5JzOnfGEpqexkuMbHgoGMmgP3AWWJwK0jimwBdfQ/iBGGiyxhVg+WQU26XA65+JpfrTVby8Q5pO6YErJLP9iI2l1j9VyZbl73qhZXxIOtkyFSypZC32ma6ude9BMFQ2XfRtE6NUiAtUSza9z+/HnL+HZWqcGcJB/4uRl2Ay5vwSHLiQQ08V9mpA9xaysiwiaKY40waGkLTEahA6qC8uschHKzLsurZ4KpBKMov8sMJ3w37E7+HyCpDqzaSv4rcFd0KoMi4++/eI0z8NqfCkgoDoCHuxiAEPCDcWQri6HjQSXwyZjgf/YzWwbTnO+E/DZmkgBhhev0Boo+DXm4ip46fV787zsTm/gmIFje7Thm07mOT2of8S4bCQ0KGyO7WGXXTSFbL38hmEfXhh2CS0ua/L3G1XPTI5iMPFqwp1YsNoaOx6O+ADmRowgT1GpMgieWbdKCuPOERteNkby3AC24YtPKqGc3S8UGihXY81jr3ApmdhlccCKUKhWXrf3OZEarORAGNR7KqbaSMhyV5jfFRYAiX3aySZ6wc1+87ykdQEgh8xUUwoTCTzSO1AEmIssS1K1lNX7sJk8SFVHIwjXNTh4O5XaHtqvW9WxP1byGN/XmoyNJ2Ru0id8rkA0PSE5/FEVd8VAU7J+jPcLByfPrnKZiOB4I851ovF7E3a/zbVlNDDC7Jx8kIZss4Slhj0bry5XamgFaK0KrZ+lzuxhGRl27pijv09IBGj7P9beyoC0DDCPh7Mj02v/xS/7zFUTKcbO+pKCxCPcs6v3K+54lWjhYn1bNiVtXQwhKbY48gyN4FZ7QEBTl07LzUGEdAeONhWyPKk7c
 TzbmTx9O
 L3ipLqEWgxR21yv/ZoNOYx13RaWSRjtaZpHvLYxCMUUuZxTUniViU15DAYyuQmCQU6KPSgKAwnnzGWjgRdqfKHzkI+ucL9rne9YUnggP+C0I+AREfPQKK2VxwiVNYMPY/MDpHGo7UBCscFBTmdydgyUIrTHq0uE6r1ESQo97B5aly1pv+iYq7PLNHzKMp2AepVORj4SPBQaYnRxN6P7pnaPwYs7Tp0r/TkV5IAlIEi5+PO2ZnhMPGwG4tnCreyh4DOqV49UoNhRpVtbIx6n7Q2sJ+UCPZmyWc8AebSt4x10AIPNR0yF5tL3IytR+DHbzDOVq9T4BIJ2baGSEUJcElrUikQGpmxtUs5OApbDLhdbwGFwyc80cEQI6pRWAP3URfX1FUdaqskdyijxO4bYni3tmLTf2WgILSLU0OWhiOfqxVwmzr8iZ7OlnvWQVxD9RKSFEZD37wT5BAhz4EyXf8tUhCXa/q5tu+wjo136Rme1inUdUEfCJ2DnkmqPiPjzgfLpXt0lvYXzwd+Fjz1iwKEowYJeXh8D3g/DuxEfWAkjhm+2E4YW7iWkFfOVeE1+KOrUw5WNKNANFS63geL/KgRUkhcA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 05/08/2025 11:36, David Hildenbrand wrote:
> On 04.08.25 17:40, Usama Arif wrote:
>> The test will set the global system THP setting to never, madvise
>> or always depending on the fixture variant and the 2M setting to
>> inherit before it starts (and reset to original at teardown)
>>
>> This tests if the process can:
>> - successfully set and get the policy to disable THPs expect for madvise.
>> - get hugepages only on MADV_HUGE and MADV_COLLAPSE if the global policy
>>    is madvise/always and only with MADV_COLLAPSE if the global policy is
>>    never.
>> - successfully reset the policy of the process.
>> - after reset, only get hugepages with:
>>    - MADV_COLLAPSE when policy is set to never.
>>    - MADV_HUGE and MADV_COLLAPSE when policy is set to madvise.
>>    - always when policy is set to "always".
>> - repeat the above tests in a forked process to make sure  the policy is
>>    carried across forks.
>>
>> Signed-off-by: Usama Arif <usamaarif642@gmail.com>
>> ---
> 
> [...]
> 
>> +FIXTURE_VARIANT(prctl_thp_disable_except_madvise)
>> +{
>> +    enum thp_enabled thp_policy;
>> +};
>> +
>> +FIXTURE_VARIANT_ADD(prctl_thp_disable_except_madvise, never)
>> +{
>> +    .thp_policy = THP_NEVER,
>> +};
>> +
>> +FIXTURE_VARIANT_ADD(prctl_thp_disable_except_madvise, madvise)
>> +{
>> +    .thp_policy = THP_MADVISE,
>> +};
>> +
>> +FIXTURE_VARIANT_ADD(prctl_thp_disable_except_madvise, always)
>> +{
>> +    .thp_policy = THP_ALWAYS,
>> +};
>> +
>> +FIXTURE_SETUP(prctl_thp_disable_except_madvise)
>> +{
>> +    if (!thp_available())
>> +        SKIP(return, "Transparent Hugepages not available\n");
>> +
>> +    self->pmdsize = read_pmd_pagesize();
>> +    if (!self->pmdsize)
>> +        SKIP(return, "Unable to read PMD size\n");
> 
> Should we test here if the kernel knows PR_THP_DISABLE_EXCEPT_ADVISED, and if not, skip?
> 
> Might be as simple as trying issuing two prctl, and making sure the first disabling attempt doesn't fail. If so, SKIP.
> 
> Nothing else jumped at me. Can you include a test run result in the patch description?
> 

Instead of 2 prctls, I think doing just the below should be enough:

diff --git a/tools/testing/selftests/mm/prctl_thp_disable.c b/tools/testing/selftests/mm/prctl_thp_disable.c
index 93cedaa59854..da28bc4441ed 100644
--- a/tools/testing/selftests/mm/prctl_thp_disable.c
+++ b/tools/testing/selftests/mm/prctl_thp_disable.c
@@ -236,6 +236,9 @@ FIXTURE_SETUP(prctl_thp_disable_except_madvise)
        if (!self->pmdsize)
                SKIP(return, "Unable to read PMD size\n");
 
+       if (prctl(PR_SET_THP_DISABLE, 1, PR_THP_DISABLE_EXCEPT_ADVISED, NULL, NULL))
+               SKIP(return, "Unable to set PR_THP_DISABLE_EXCEPT_ADVISED\n");
+
        thp_save_settings();
        thp_read_settings(&self->settings);
        self->settings.thp_enabled = variant->thp_policy;



Will include the test run result in the last patch description. Just adding it here as well:

./prctl_thp_disable
TAP version 13
1..12
# Starting 12 tests from 6 test cases.
#  RUN           prctl_thp_disable_completely.never.nofork ...
#            OK  prctl_thp_disable_completely.never.nofork
ok 1 prctl_thp_disable_completely.never.nofork
#  RUN           prctl_thp_disable_completely.never.fork ...
#            OK  prctl_thp_disable_completely.never.fork
ok 2 prctl_thp_disable_completely.never.fork
#  RUN           prctl_thp_disable_completely.madvise.nofork ...
#            OK  prctl_thp_disable_completely.madvise.nofork
ok 3 prctl_thp_disable_completely.madvise.nofork
#  RUN           prctl_thp_disable_completely.madvise.fork ...
#            OK  prctl_thp_disable_completely.madvise.fork
ok 4 prctl_thp_disable_completely.madvise.fork
#  RUN           prctl_thp_disable_completely.always.nofork ...
#            OK  prctl_thp_disable_completely.always.nofork
ok 5 prctl_thp_disable_completely.always.nofork
#  RUN           prctl_thp_disable_completely.always.fork ...
#            OK  prctl_thp_disable_completely.always.fork
ok 6 prctl_thp_disable_completely.always.fork
#  RUN           prctl_thp_disable_except_madvise.never.nofork ...
#            OK  prctl_thp_disable_except_madvise.never.nofork
ok 7 prctl_thp_disable_except_madvise.never.nofork
#  RUN           prctl_thp_disable_except_madvise.never.fork ...
#            OK  prctl_thp_disable_except_madvise.never.fork
ok 8 prctl_thp_disable_except_madvise.never.fork
#  RUN           prctl_thp_disable_except_madvise.madvise.nofork ...
#            OK  prctl_thp_disable_except_madvise.madvise.nofork
ok 9 prctl_thp_disable_except_madvise.madvise.nofork
#  RUN           prctl_thp_disable_except_madvise.madvise.fork ...
#            OK  prctl_thp_disable_except_madvise.madvise.fork
ok 10 prctl_thp_disable_except_madvise.madvise.fork
#  RUN           prctl_thp_disable_except_madvise.always.nofork ...
#            OK  prctl_thp_disable_except_madvise.always.nofork
ok 11 prctl_thp_disable_except_madvise.always.nofork
#  RUN           prctl_thp_disable_except_madvise.always.fork ...
#            OK  prctl_thp_disable_except_madvise.always.fork
ok 12 prctl_thp_disable_except_madvise.always.fork
# PASSED: 12 / 12 tests passed.
# Totals: pass:12 fail:0 xfail:0 xpass:0 skip:0 error:0

