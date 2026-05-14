Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D2A72CD4F25
	for <linux-mm@archiver.kernel.org>; Thu, 14 May 2026 08:22:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 42A306B0095; Thu, 14 May 2026 04:22:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 401646B0098; Thu, 14 May 2026 04:22:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 317EC6B0099; Thu, 14 May 2026 04:22:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 222316B0095
	for <linux-mm@kvack.org>; Thu, 14 May 2026 04:22:02 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id BBF70C1F8A
	for <linux-mm@kvack.org>; Thu, 14 May 2026 08:22:01 +0000 (UTC)
X-FDA: 84765332442.14.3117F7C
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	by imf01.hostedemail.com (Postfix) with ESMTP id DAD5540009
	for <linux-mm@kvack.org>; Thu, 14 May 2026 08:21:59 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=mcc4Txr4;
	spf=pass (imf01.hostedemail.com: domain of jiahao.kernel@gmail.com designates 209.85.210.176 as permitted sender) smtp.mailfrom=jiahao.kernel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778746919;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WYXEDQETkSsL5D7C5JReu+GaAzOCViwf5QXVSoBOuE0=;
	b=capj/xMRe4XawjHUhFxTswbYJG5hX3gJJUyX3Q06y+Vz+MII41hatchQvGFVrHeLnnlXSD
	qrrycEnRBqmUnHlPdBa9FLfU1uMLYFTY+c/vXFxqEIC02QzPsh5AqT77A5exM0j5AlZD+1
	4pQbzDubOlETGRTnQKpDLnTfuwEMnps=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=mcc4Txr4;
	spf=pass (imf01.hostedemail.com: domain of jiahao.kernel@gmail.com designates 209.85.210.176 as permitted sender) smtp.mailfrom=jiahao.kernel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778746919; a=rsa-sha256;
	cv=none;
	b=jYl2ICpjbytepRj4UpkrN1hYKotlcBtaBz9viFTpmqsWLpNCH6VTriJNO4sIAHY2nRMuTB
	pj5+vAExpIqWyXm22RbH4Vx7LjqT1+W1Y1gp+ZabZs1zxYkW0oCTvEb5OF66KEVnT0khIw
	UOz3BuIs/oNJ5wsnZilpovFAjEDIEw8=
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-82748257f5fso5565728b3a.1
        for <linux-mm@kvack.org>; Thu, 14 May 2026 01:21:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778746919; x=1779351719; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WYXEDQETkSsL5D7C5JReu+GaAzOCViwf5QXVSoBOuE0=;
        b=mcc4Txr4UYm/Bxm9lYmcSnzldTLuPF4EJm7pwKkOoEFnMQP9DkNhn4ruJDRvcQwzGX
         F5KifIqrg2omEkafdRRbUQVhmUm/3zzuhZ1yYf6cfR+GBfG7yOXkv5KExAbacoeFROSV
         OOQA1rt0hZgMWjYAoC2ZwXuxX50v4Lx6Eqofobf3BVeJlWPMNsDMlwfubxzm9GeFCkgb
         cSkKFW1tnBXPT+WtREKSgfRGZwzfY2GdfWd6BVxwe9neLSOc9Y7C91FZMd5KhdO/yswj
         ApqPgmIcbGseR4TWkc5CGU97SA2ik8+4GCqYTVn72/mh0m6PKie20L7pNr9zSEcVk7fS
         LjtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778746919; x=1779351719;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=WYXEDQETkSsL5D7C5JReu+GaAzOCViwf5QXVSoBOuE0=;
        b=KncZPrmX44Is4i5ky9SkLR1jRjuO28ZKbLs0MRcnrcfaDbq7pBYvJWvoy8rnTq/cqv
         6ONSdOa8LxPgmtkcoz5jFIEoMikNMywi/GBN10c1zSGnq74qS+L1fOtFBgnwBZjZrEuP
         v78xmT0jgAXYt6eLy4NQlfv9Ai+GCyqh8u+UQ7M1rHhZ3RLzeKrhOr24Tv4w4+TZXP6m
         aDcwmK42z0eSh90dkWNG1E+7MxJ9wT4ea7c/hHb0d1rM+RG9MeVnkiguV8dgvm9kEyvb
         BCmIgdX7Mhh+qf4g3ajltLVCNVte/6aFakekpsSFzTafdRBka2tcbGOdOjQG5sT8iN/V
         fQ7A==
X-Forwarded-Encrypted: i=1; AFNElJ+19Dp4c63VSmzAqBP86nJeDVtYh/qFFaQx5ztXEZ6PhCSOhmTr07sq1HCUIXD1CXqYTtjmk8X/fA==@kvack.org
X-Gm-Message-State: AOJu0YznbjRSvojwJUVwaRFSXF6pl24aq5T7WPoB3SGV7vP0hw0C/XVV
	ScS0WRFsFBeXN7k6YAyB1oVLscPgLOTHPOv/PS3l4bIGNI7YvpwyY/ib
X-Gm-Gg: Acq92OGs4xBGZD9NC1nGeTSFLjzYHrVMRRSWpJgai6uIQmQhH9IgbZT5seuAZFtcCRC
	bnnGiv1dYCdOq83Pp2Ut4zILZ8a7Dgrkt7tYm+pxbNWZ41W7fTgOe2JZrA2ZACN/swCI7eC4cs4
	SdHtLH1wjP2T2ricuAU1HsHgUXA5syxhssuHcZz3mEa9LAhukUae+37pg/gKMkzsJXy/MfVlEqh
	wWVYh0Pk8XpHiTo1/vsZG8wbG1XKn/UEUojvAKdii55SGsx8uht9F3TzUaaJ4SQC0LMqg7KoqEr
	6pjAeYYLEsLM+XIov28PzHVaWrQbDA0D93J/blcUf2q6wj/VyLj/NP7daM9rsg8HdwOU4AapLJd
	ZpZZAM8+etNQz4ryDx71vz5sxvCp54j482HWeiXnYBnpGAI2wOeCH5JyOJgrRFSwSNxlqjQOsj6
	kGFSGU6MjD6gQyyKx6uTtc7/d2Ot4eFdC90Zvrj4qZmj22ESGKgOU3ig==
X-Received: by 2002:a05:6a00:10cf:b0:82f:49b5:cfc3 with SMTP id d2e1a72fcca58-83f18e6700dmr2504897b3a.18.1778746918343;
        Thu, 14 May 2026 01:21:58 -0700 (PDT)
Received: from [10.125.192.65] ([210.184.73.204])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-83f1977a570sm1804344b3a.20.2026.05.14.01.21.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 May 2026 01:21:57 -0700 (PDT)
Message-ID: <59a55147-b2c6-c5ff-64ae-07da4792958a@gmail.com>
Date: Thu, 14 May 2026 16:21:49 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.15.0
Subject: Re: [PATCH 3/3] mm/zswap: Add per-memcg stat for proactive writeback
To: Nhat Pham <nphamcs@gmail.com>
Cc: akpm@linux-foundation.org, tj@kernel.org, hannes@cmpxchg.org,
 shakeel.butt@linux.dev, mhocko@kernel.org, yosry@kernel.org,
 mkoutny@suse.com, chengming.zhou@linux.dev, muchun.song@linux.dev,
 roman.gushchin@linux.dev, cgroups@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 Hao Jia <jiahao1@lixiang.com>
References: <20260511105149.75584-1-jiahao.kernel@gmail.com>
 <20260511105149.75584-4-jiahao.kernel@gmail.com>
 <CAKEwX=OigngmcNo1OU-apCFG2hebt5yZwXQxZQHqgC7SwH_HAQ@mail.gmail.com>
From: Hao Jia <jiahao.kernel@gmail.com>
In-Reply-To: <CAKEwX=OigngmcNo1OU-apCFG2hebt5yZwXQxZQHqgC7SwH_HAQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: DAD5540009
X-Stat-Signature: btksxgzgz66uk6ce3k6c5pz61qja3e39
X-HE-Tag: 1778746919-616456
X-HE-Meta: U2FsdGVkX193kKrifv5usKBh4BVqj4BtGNrj1srBtdgDe3j4cofT/xLxv7HZtvY1wbB+o2DjY1h/iHiuijqqzrFkmQmpBAFhQyqhJovslRaAIr4DIH0belJd4cxwWTdD0NB+mLQR10lcAx5rmYsqSf/EKM22tfxJqoqDEkFWb5lh3HWSbI0Y9Cf3+gFVp9leSBtcLvfBDnK0W9g3GbX3bLSvwv23g4V/CyHrBVI6hK7FvUJHK8BzRyDzPhVE6uzallCXPM4EhEYWONiozORrsYmu8T8A4Ru4Ua6VCZwwPtdU4tnPjNjmStjN1t6tob/iDjYGtwOHqYhYNRubRIqDwkwNjyq2BPNSeHElP/RUsASt4sgYTc8KtNvNSSp1tgZcYDfKIpu+ft7khpi0HeZY1kTaKToZZuJxQvndT9deWFUAO5FzD6o/tYyMjs5/fAYtghMpAeiAkO/mViVPixGJ3UUbVGEQ3CSU8DvQUhGebRsR0OmOMIJ6RZO4ikRPleFXrVpMp0e631lKG/ZF+t0xNN5VFgkZ/gVqFVz4+HVZNbud/9ZZCN6Px/pbxhqBjdvDzJJYSNg6Qrr2JeI15jCiROag/C8EmAh6koBiQ53UXEy8gyRprsNrIDyJKYP3U86UDJmeCp9uX/kJx4W6gAjOLCTzgE1sXZiitpGyjHVUUi1h9JtN/JwbxhnSYIvdQmaqySypbwk2oTylDcosbVA/5/o/uXYWQbXpyWNQSrOIihAgtYe5xFyIIPK40W/w3vzg/UschZ6uvyxA12G6RvQczmCnrgrJZIIQO82Zff2e00GcL/ym34Ndifm6szuc/jwVD6kWr893PvSEXaZctPUyMZnVbZAEc2ITiFbIDTtx+NU0pkuBNQ8pr5koO8FDYpq0AUTh8k0UM5F+rRK+B771kvDi6LlcE9Y2xalYlMD/ekOBhyu6xekyjhmlI/Lu46XOnT67qAq37HkyeD9WA0C
 8lafRiRB
 hK8pbjbYlFvEILfSjMPvh7rc6bTsEmEth89ak8Ln+e+7rLblDdeteMKjQuteF8YwtuXQnYsIfKC2beIqLd6w0NtpxNszX1F4BcOKyJDIK0nkPEjvBoR6nejvznIhq9loqowxsrbJz19EAETbUr5AZCkVCaLx7uCWJ+4LIjvnwlS/QOZKXGEAmDnXU1JVx7Q5MFe3gmDbCHW1pM4Ywux0A3lxQhxlTK21uijvJRnSQYv/74kJQBzN3nu62xaQErx4dtloTlu/PvQGNFD8aBs0NXysGifpKST9E+up8H5N0d3sBt6ctgQCUvHtAlc1Q2nDaMYBXdtPq8KwS9TBES1eNw3m+ZZ9ePaj3JvPAy1mdAWTDzlpPxuniJMa9NwUAXjLDYNbPchkBjddMhPc8W4Avh+THFkmJZtmS+woYFGRUziVCpbbk4pJcXgasEc3Op6qh8/BaapxS9P47p8tFXN9BXYYBTfHdxGHQa9H2vxR7gTyV22CuSSy6O2bQdg3iHy8U0OM8tEgKY1jo0bCNihSQlyak7H5l3QV6uoDUllf5XBOuVrVC1rdZ5u7LICas916WD+KGtpoHxvKe0asV738Ou4/NTJx6IEoSBRIVKMbls2R57nNbXNPpVJyDAw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/5/14 05:21, Nhat Pham wrote:
> On Mon, May 11, 2026 at 3:52 AM Hao Jia <jiahao.kernel@gmail.com> wrote:
>>
>> From: Hao Jia <jiahao1@lixiang.com>
>>
>> Currently, zswap writeback can be triggered by either the pool limit
>> being hit or by the proactive writeback mechanism. However, the
>> existing 'zswpwb' metric in memory.stat and /proc/vmstat counts all
>> written back pages, making it difficult to distinguish between pages
>> written back due to the pool limit and those written back proactively.
>>
>> Add a new statistic 'zswpwb_proactive' to memory.stat and /proc/vmstat.
>> This counter tracks the number of pages written back due to proactive
>> writeback. This allows users to better monitor and tune the proactive
>> writeback mechanism.
>>
>> Signed-off-by: Hao Jia <jiahao1@lixiang.com>
>> ---
>>   Documentation/admin-guide/cgroup-v2.rst |  4 ++++
>>   include/linux/vm_event_item.h           |  1 +
>>   mm/memcontrol.c                         |  1 +
>>   mm/vmstat.c                             |  1 +
>>   mm/zswap.c                              | 11 +++++++++--
>>   5 files changed, 16 insertions(+), 2 deletions(-)
>>
>> diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
>> index 05b664b3b3e8..29a189b18efc 100644
>> --- a/Documentation/admin-guide/cgroup-v2.rst
>> +++ b/Documentation/admin-guide/cgroup-v2.rst
>> @@ -1734,6 +1734,10 @@ The following nested keys are defined.
>>            zswpwb
>>                  Number of pages written from zswap to swap.
>>
>> +         zswpwb_proactive
>> +               Number of pages written from zswap to swap by proactive
>> +               writeback. This is a subset of zswpwb.
>> +
>>            zswap_incomp
>>                  Number of incompressible pages currently stored in zswap
>>                  without compression. These pages could not be compressed to
> 
> nit: once we have reached consensus on an interface, can you add
> documentation for the new knob in cgroup v2 doc and zswap doc too, and
> how it interacts with the other interface (memory.zswap.writeback,
> shrinker_enabled sysfs knob).
> 
> A kselftest would be very much appreciated too :)

Thanks, will do in v2

Thanks,
Hao

