Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E3596FC6160
	for <linux-mm@archiver.kernel.org>; Sat,  3 Jan 2026 06:36:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A3CC96B009E; Sat,  3 Jan 2026 01:36:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9EB5B6B009F; Sat,  3 Jan 2026 01:36:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E97A6B00A0; Sat,  3 Jan 2026 01:36:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7C8106B009E
	for <linux-mm@kvack.org>; Sat,  3 Jan 2026 01:36:57 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id F29FECCAFF
	for <linux-mm@kvack.org>; Sat,  3 Jan 2026 06:36:56 +0000 (UTC)
X-FDA: 84289694832.04.972FFFF
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	by imf07.hostedemail.com (Postfix) with ESMTP id E980340005
	for <linux-mm@kvack.org>; Sat,  3 Jan 2026 06:36:54 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=wk6nqTwI;
	spf=pass (imf07.hostedemail.com: domain of eugen.hristev@linaro.org designates 209.85.210.169 as permitted sender) smtp.mailfrom=eugen.hristev@linaro.org;
	dmarc=pass (policy=none) header.from=linaro.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767422215;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=n009qAjQa1f/gx1JlFPWaK6vp1HVpsaalQe/6LgsF9o=;
	b=DDLNa18O/CtX7Xfnboig+clZGqlDFdylLoaCsy2cV6YbrpH3CdnIJSk3/77pDKrBh1bwDS
	J8Q/PFvPg7ca5hYlgIZMJVcRicwk+UxLYbwRi6gfDX9f2YZEDMCbO3njqo2hh7sOh2S5TJ
	ywyJoVrlfA7bunqvhxhGrpRxk7aaaYo=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=wk6nqTwI;
	spf=pass (imf07.hostedemail.com: domain of eugen.hristev@linaro.org designates 209.85.210.169 as permitted sender) smtp.mailfrom=eugen.hristev@linaro.org;
	dmarc=pass (policy=none) header.from=linaro.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767422215; a=rsa-sha256;
	cv=none;
	b=cyjrK2ulzk0V1W/o+b1kGxF/XyfHMfHa5dQOw+4DZMD1Apx1XANR8TELICucmrD5zwM+Fx
	Kiyz+Ol9OyMa/KRYXUL2foaGX8JyisidNswnb0dA4/GYVTl4s6FbEP+gsR53oMPbnSzQka
	dQus39lZV21cmp6dSVGCPNBEAFgGWVA=
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-7b8bbf16b71so12712779b3a.2
        for <linux-mm@kvack.org>; Fri, 02 Jan 2026 22:36:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1767422213; x=1768027013; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=n009qAjQa1f/gx1JlFPWaK6vp1HVpsaalQe/6LgsF9o=;
        b=wk6nqTwIMTb4Yc88WKvIxkr8Pedvw3gi/5/pa3fZ1L2F7C4S9UUMIgb1QWbumNqGCj
         WC4vmUBt+Yi0WSb0WUk1PzytjT3/02235S1k/GdSXAWS/Xi/KV3DjTU5iZr53aM63Ovm
         tKats7aJHpC5LcQwklou6AFD2XQlWvWGwyYW4ZGWQUQtMqIM+RH/YE+nDOrQO/5O97wk
         d1LW+D8ft/tVea5GIwjWnJYDevUmx+3Vn12oz9ANpy6nhgSAEEYF7s79wEt6l8FnGxCe
         lio5qrpmx+cvvcnOpfX2/iUQsLNShCXyDTJ4shtq4v9Glfkl0fkFcMkOVlUTP7k7vfQv
         U9fA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767422213; x=1768027013;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=n009qAjQa1f/gx1JlFPWaK6vp1HVpsaalQe/6LgsF9o=;
        b=CumLjnbtC/tJlzHxso5SyprZhGEGnC7fSYlKlIc4Stg5Nona1QB9CwsoI+rq5skZPk
         7G/Ndx/++UQ/bNlrARKr0L9J3cWu1kX5c+LX5X8OIDELxJUBNCnXKuzvmOQUa41afHP1
         2ONolljDBjtzPpWSN7ETWU72m9QYulaqz7QXSRM5jyJtihj8oRfUIa+rSzvAbMRpkOiO
         gNBFs3QyPR3vztswc68Ipp0kb/HRVXii5s0QhXUVZOYgiquxvU/q7Ywldk5AVUc8D+Sl
         2/ippGp6F/dOCNeTeTwhWm9I8UKDJwewwCCLFO0Q9W7eSe7zkI9081sOO9fCx/BKnMQg
         FB/g==
X-Forwarded-Encrypted: i=1; AJvYcCWCnyOnceszlDCpTRNO30FL755I1iq6rnY1ZtPOePWNr/FFaDcXpiVbzaM1A+g1/nbFnjdp85fpfw==@kvack.org
X-Gm-Message-State: AOJu0Yy+VVQhXDx36uX9WcqVFECrep3lPcuuCvYe/WPNS6MDR89rEYbm
	kAUxTuKyxDj+x7Vpt+txQMUdN180kHdwp1CiX5CQr0OPlX08Orh4s1oY2j3kKRcVBcM=
X-Gm-Gg: AY/fxX4+S5rr4zb2vO8e0mndLewo+pM0bmcRT817F83x8XauxQwaf2rEdgJ9+V1HQfs
	7B+LeHIwfKfDBZn0TnyY4DkUVegoE5I16td3JORhLtNV1XLb/KMRpWyM8ax2AXyIouot5E04hEe
	1X+rzn6J6Qabhr9VMjlR3sJqTP2TiBg6541RhT4UCg29m5Fh99hvZ/tsgxKqdfBlgIy0osYTm3A
	mFN93MHNaDawR/SXt1SeTOsZ8Lbq1hvuueH7V22zE1/hdD6iGS6KLyCfTn5YJ7x+QDX9TR5pfCM
	66OG5+hZlz0H29duRKwBeAvkas0Q5njn8iURR42/1L3NqiTCX9lLvCsDARwU529GVewiKVsrlhl
	RHnBGXlIUC3cq0B6QEhTeeGz2yDxtzobf+ZLTjy31Lb0mIcq2tTRTuVsTu6vDETpbgsDE2JBGIQ
	2W+DVSLaxN6D9d1Qq21BeVfhHJVsexCCYCg9yQ3TMj+PqgK77fAhav74CHD44cSrJf
X-Google-Smtp-Source: AGHT+IFjVDKmB/xNuLtQKRYfU/ITUXwxCDRtTDnOfIZDb5jRoUr7iNoQ0th445p4ZZcSbNCPgjHtMA==
X-Received: by 2002:a05:6a00:140f:b0:807:c2b9:38ec with SMTP id d2e1a72fcca58-807c2b93f63mr22110230b3a.15.1767422213430;
        Fri, 02 Jan 2026 22:36:53 -0800 (PST)
Received: from ?IPV6:2405:6e00:642:d187:9f0f:f4ff:8fd1:e7bf? ([2405:6e00:642:d187:9f0f:f4ff:8fd1:e7bf])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7ff7e0a2e3esm41753812b3a.37.2026.01.02.22.36.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Jan 2026 22:36:52 -0800 (PST)
Message-ID: <4b8953ac-567b-4d68-9c25-72a69afdf1b3@linaro.org>
Date: Sat, 3 Jan 2026 08:36:40 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 18/26] mm/memblock: Add MEMBLOCK_INSPECT flag
To: Mike Rapoport <rppt@kernel.org>
Cc: linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, tglx@linutronix.de, andersson@kernel.org,
 pmladek@suse.com, rdunlap@infradead.org, corbet@lwn.net, david@redhat.com,
 mhocko@suse.com, tudor.ambarus@linaro.org, mukesh.ojha@oss.qualcomm.com,
 linux-arm-kernel@lists.infradead.org, linux-hardening@vger.kernel.org,
 jonechou@google.com, rostedt@goodmis.org, linux-doc@vger.kernel.org,
 devicetree@vger.kernel.org, linux-remoteproc@vger.kernel.org,
 linux-arch@vger.kernel.org, tony.luck@intel.com, kees@kernel.org
References: <20251119154427.1033475-1-eugen.hristev@linaro.org>
 <20251119154427.1033475-19-eugen.hristev@linaro.org>
 <aVImIneFgOngYdSn@kernel.org>
From: Eugen Hristev <eugen.hristev@linaro.org>
Content-Language: en-US
In-Reply-To: <aVImIneFgOngYdSn@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Stat-Signature: ax4ih87d1jb78nbs8b673d7garwi6ijt
X-Rspam-User: 
X-Rspamd-Queue-Id: E980340005
X-HE-Tag: 1767422214-343696
X-HE-Meta: U2FsdGVkX1/gUlgkh0Va1S7kr9lORLOnO43mFJ+m72TLzjIJYa6OZsSn99eunbqzhNcnYzpBg37pQQpHysflURFJhgn/+/au1LGR7k6fY69XWzAB2r6emc0n3jqYCvciyJ480H96+ImbDaqFjJRkQFXd3AhpPvgtuNY94mRm8bKedewSVl11DoI2VHM96yeI+mt5cdTP1bp2vBCJmJiQ+oXqbjA1gs2lJgxDgWSJpSkAAJuIy4/UyMzli25gSZjCvF+pq3GaihpAu2IcUAU6LT8HsJSBbcaBak5FEwTu5du+OciDEniI/b7s7xBZOZX+u/L1lviSiqSJ7HjUZgkMFksI2V+qOnDKvMJDsHijgxr8SThgvFiBJuQTNDvrtCu1Qcnew7xZ8ot1utkFDMddjByqm+s3zLtu8l3xnrcQRqDvLaYLjffIMOQE8k4obnOIw+i4gK9yxDCAmRwD5s/cwm8zEleTkFPMkXmQxJgPBtKvrn/48yVbUQN9ZLXkZbzcNQVKgpjI5XfP6555b7d269M1BVcLT7PdCTNL2f7B7UBtGevDb93PxQcAcEfzDkhBe65Lw1vyS3KkZ2k9k7Cyq6WkFQImjh+z2FV3sRH132ddyuDf8RsQMT9TFE6g2Y3NgNI1/Lytjgyoff1aZN8GZZwKsyOLyfECoRfeaDrfMPPUeysKjYSASiEzJGkdDnSpx5/G2FlJAeISFB6Ltc7pmqWBMhe8xoxdMdgXZKiv92GDQbVs0kvYpLqpx19H/BjWujSo9TgGQeHKO8+kx5v+Th4GR/+ZLnuav5i+CbVWCtgknNb8/0RApVzjCQr3IFHSD/zt/64eAZAnieqWyPZ8ES5SHxSN6F08GSFnR1+fSW6GVD27SCFJv6PBDNuZ4Hd/XSIHPE3nE/atSTMVc/bDIUlP40ebmowOYRVXxyUijj+krFqdwRev+UNqtJ3c58KYqPQSae0alg5G6Ystm2D
 QzT3ZSYS
 f3VWixmY1lPOYEGTHZQ5f7td8ITKFy8VHaB+jBdQ7IgLD5gstUVpW9/BH/mQeLBPVhb8jgPXc4sfXpET5LlsHHLcCQ/VE57ZqASczVnkuDCz3pNhmW8yWyOXSvWhQOXgxVIugOoP6BbmtMsgwn1VkNbDoc3OWOpufFcMh/DownQuSIf5Rw4RlxJHrNfUZqu+Xrjn0AhJCXOl4Ho3u/RnkbfPGmYfZyu99snuHv4sUc8FXzsQo9TAmrqlcZabRGDCPQVteS/bBftN/cfNv7WS6hhxxNCvEHxnHZZkIyt0J2XAlKldsIDPOct7rAFkuQ4w0DZnqUHuqBLwtTe9+eVsELZUa6PH1XmwQdXm9jPsUWX5ctk/KapHjUM4rAhRlV5U8X4lo9i2TGYYrFjl6zfUBeCMwfOZC8fmd8ZvtexX5X5g9uLRLGFE/lV+upJmHQpileuockckz49xIPXVIWYTxSrKgPQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 12/29/25 08:56, Mike Rapoport wrote:
> Hi Eugen,
> 
> On Wed, Nov 19, 2025 at 05:44:19PM +0200, Eugen Hristev wrote:
>> This memblock flag indicates that a specific block is registered
>> into an inspection table.
>> The block can be marked for inspection using memblock_mark_inspect()
>> and cleared with memblock_clear_inspect()
> 
> Can you explain why memblock should treat memory registered for inspection
> differently?

It should not, at a first glance.

The purpose of the flag is to let memblock be aware of it.
The flag is there to have a "memblock way" of registering the memory,
which inside memblock , it can translate to a meminspect way of
registering the memory. It's just an extra layer on top of meminspect.
With this, it would be avoided to call meminspect all over the places it
would be required, but rather use the memblock API.
And further, inside memblock, it would be a single point where
meminspect can be disabled (while preserving a no-op memblock flag), or
easily changed to another API if needed.
Ofcourse, one can call here directly the meminspect API if this is desired.
Do you think it would be better to have it this way ?

Thanks for looking into it,
Eugen


> 
>> Signed-off-by: Eugen Hristev <eugen.hristev@linaro.org>
>> ---
>>  include/linux/memblock.h |  7 +++++++
>>  mm/memblock.c            | 36 ++++++++++++++++++++++++++++++++++++
>>  2 files changed, 43 insertions(+)
>>
>> diff --git a/include/linux/memblock.h b/include/linux/memblock.h
>> index 221118b5a16e..c3e55a4475cf 100644
>> --- a/include/linux/memblock.h
>> +++ b/include/linux/memblock.h
>> @@ -51,6 +51,10 @@ extern unsigned long long max_possible_pfn;
>>   * memory reservations yet, so we get scratch memory from the previous
>>   * kernel that we know is good to use. It is the only memory that
>>   * allocations may happen from in this phase.
>> + * @MEMBLOCK_INSPECT: memory region is annotated in kernel memory inspection
>> + * table. This means a dedicated entry will be created for this region which
>> + * will contain the memory's address and size. This allows kernel inspectors
>> + * to retrieve the memory.
>>   */
>>  enum memblock_flags {
>>  	MEMBLOCK_NONE		= 0x0,	/* No special request */
>> @@ -61,6 +65,7 @@ enum memblock_flags {
>>  	MEMBLOCK_RSRV_NOINIT	= 0x10,	/* don't initialize struct pages */
>>  	MEMBLOCK_RSRV_KERN	= 0x20,	/* memory reserved for kernel use */
>>  	MEMBLOCK_KHO_SCRATCH	= 0x40,	/* scratch memory for kexec handover */
>> +	MEMBLOCK_INSPECT	= 0x80,	/* memory selected for kernel inspection */
>>  };
>>  
>>  /**
>> @@ -149,6 +154,8 @@ unsigned long memblock_addrs_overlap(phys_addr_t base1, phys_addr_t size1,
>>  bool memblock_overlaps_region(struct memblock_type *type,
>>  			      phys_addr_t base, phys_addr_t size);
>>  bool memblock_validate_numa_coverage(unsigned long threshold_bytes);
>> +int memblock_mark_inspect(phys_addr_t base, phys_addr_t size);
>> +int memblock_clear_inspect(phys_addr_t base, phys_addr_t size);
>>  int memblock_mark_hotplug(phys_addr_t base, phys_addr_t size);
>>  int memblock_clear_hotplug(phys_addr_t base, phys_addr_t size);
>>  int memblock_mark_mirror(phys_addr_t base, phys_addr_t size);
>> diff --git a/mm/memblock.c b/mm/memblock.c
>> index e23e16618e9b..a5df5ab286e5 100644
>> --- a/mm/memblock.c
>> +++ b/mm/memblock.c
>> @@ -17,6 +17,7 @@
>>  #include <linux/seq_file.h>
>>  #include <linux/memblock.h>
>>  #include <linux/mutex.h>
>> +#include <linux/meminspect.h>
>>  
>>  #ifdef CONFIG_KEXEC_HANDOVER
>>  #include <linux/libfdt.h>
>> @@ -1016,6 +1017,40 @@ static int __init_memblock memblock_setclr_flag(struct memblock_type *type,
>>  	return 0;
>>  }
>>  
>> +/**
>> + * memblock_mark_inspect - Mark inspectable memory with flag MEMBLOCK_INSPECT.
>> + * @base: the base phys addr of the region
>> + * @size: the size of the region
>> + *
>> + * Return: 0 on success, -errno on failure.
>> + */
>> +int __init_memblock memblock_mark_inspect(phys_addr_t base, phys_addr_t size)
>> +{
>> +	int ret;
>> +
>> +	ret = memblock_setclr_flag(&memblock.memory, base, size, 1, MEMBLOCK_INSPECT);
>> +	if (ret)
>> +		return ret;
>> +
>> +	meminspect_lock_register_pa(base, size);
>> +
>> +	return 0;
>> +}
>> +
>> +/**
>> + * memblock_clear_inspect - Clear flag MEMBLOCK_INSPECT for a specified region.
>> + * @base: the base phys addr of the region
>> + * @size: the size of the region
>> + *
>> + * Return: 0 on success, -errno on failure.
>> + */
>> +int __init_memblock memblock_clear_inspect(phys_addr_t base, phys_addr_t size)
>> +{
>> +	meminspect_lock_unregister_pa(base, size);
>> +
>> +	return memblock_setclr_flag(&memblock.memory, base, size, 0, MEMBLOCK_INSPECT);
>> +}
>> +
>>  /**
>>   * memblock_mark_hotplug - Mark hotpluggable memory with flag MEMBLOCK_HOTPLUG.
>>   * @base: the base phys addr of the region
>> @@ -2704,6 +2739,7 @@ static const char * const flagname[] = {
>>  	[ilog2(MEMBLOCK_RSRV_NOINIT)] = "RSV_NIT",
>>  	[ilog2(MEMBLOCK_RSRV_KERN)] = "RSV_KERN",
>>  	[ilog2(MEMBLOCK_KHO_SCRATCH)] = "KHO_SCRATCH",
>> +	[ilog2(MEMBLOCK_INSPECT)] = "INSPECT",
>>  };
>>  
>>  static int memblock_debug_show(struct seq_file *m, void *private)
>> -- 
>> 2.43.0
>>
> 


