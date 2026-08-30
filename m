Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5597FC61DB9
	for <linux-mm@archiver.kernel.org>; Sun, 30 Aug 2026 10:57:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 212336B0088; Sun, 30 Aug 2026 06:57:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1C46F6B008A; Sun, 30 Aug 2026 06:57:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0B25D6B008C; Sun, 30 Aug 2026 06:57:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CF4716B0088
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 06:57:20 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 342ED160298
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 10:57:20 +0000 (UTC)
X-FDA: 85157634240.26.63D5710
Received: from mta0.migadu.com (out-200.mta0.migadu.com [91.218.175.200])
	by imf18.hostedemail.com (Postfix) with ESMTP id 05E771C0002
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 10:57:17 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=TeCLhTro;
	spf=pass (imf18.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.200 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788087438;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RXVixBa5sQ/gtHCi6VKVhO3YKDdhIHanYpWeyYjIzWw=;
	b=SwbQClTin60YgLm/uUD5vVMSx4cCy8wx5iFbhC4f7nH1m94iTiF6/UDjA3bmDErF6yWPVy
	f3pDMO8tYmEdbV3jR/hzwDNMU8Gc2H8mFJUzjYwwreKtfUzLgaEZARfwlj8biJscc2WOeF
	LfeTIVAVr5K2fJ1qrBVO0PCoUO9Abcg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788087438;
	b=wrAvf3NzV0/DBgxggEDHuMlXsi3yyJIyglWHJ70TSZ52wsMqY2h8CesbtDzfG0DhO2uhSs
	EMMRrydSq5jMFhG/vyPFtmih9HOK5MFPUeoCV/g11mbYjm/3qwMa+2FkNd8pAyd17Sjrfz
	gAmBUkSTYpry9dMuosw5LsBzfSgZz9w=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=TeCLhTro;
	spf=pass (imf18.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.200 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=yzCS2uJ6tHwcB7fqOOQe9/2KmZ3F1ciT33gbDIVkuaI=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788087436; v=1; x=1788692236;
 b=TeCLhTroa41J58XGdLShIZaU9Qmd75n7b/gevcF+hfbpeIjxZlIXVXxKe18Sv/9GLVgHfvE8
 8WSQT5VT1Ewup6F19wi2JckVfI4rmsjRPnh7zX71H/mCvsa7yQf5RO7LSMUQVg6E3MQ1++4j1nz
 0K/WTuvwEvVVxNS6+fWx0CVk=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id a1b9075004b6ac5b;
	Sun, 30 Aug 2026 10:57:06 +0000
X-Mizu-Trace-ID: a1b9075004b6ac5b
X-Migadu-Flow: FLOW_OUT
Message-ID: <b9494f20-9ec0-45fc-830a-1bc2f92ecff2@linux.dev>
Date: Sun, 30 Aug 2026 18:56:53 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/2] mm/mglru: fix ineffective memory protection for
 non-kswapd reclaim
To: Barry Song <baohua@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>,
 Muchun Song <muchun.song@linux.dev>, Kairui Song <kasong@tencent.com>,
 Qi Zheng <qi.zheng@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>,
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Chris Down <chris@chrisdown.name>, Tejun Heo <tj@kernel.org>,
 Yu Zhao <yuzhao@google.com>,
 "open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)"
 <cgroups@vger.kernel.org>,
 "open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)"
 <linux-mm@kvack.org>, linux-kernel@vger.kernel.org,
 Ridong Chen <chenridong@xiaomi.com>, stable@vger.kernel.org
References: <20260828110919.1324028-1-ridong.chen@linux.dev>
 <20260828110919.1324028-3-ridong.chen@linux.dev>
 <CAGsJ_4ws6edtcToqJQ0azJPTymAYj41nzdGJvBqEM+gROiJtRQ@mail.gmail.com>
 <c0a32c3c-bff8-433c-8552-f0723e3a07b7@linux.dev>
 <CAGsJ_4wvYNV2UMaFW0a3Fb9U09v6bPfXyg4Rzw4B27xo-NVYbw@mail.gmail.com>
From: Ridong Chen <ridong.chen@linux.dev>
In-Reply-To: <CAGsJ_4wvYNV2UMaFW0a3Fb9U09v6bPfXyg4Rzw4B27xo-NVYbw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 05E771C0002
X-Stat-Signature: 7wsm8i9hgg9cba3rehgwa1kr34xraw93
X-HE-Tag: 1788087437-732473
X-HE-Meta: U2FsdGVkX1+kKsheA2YbEpVPhdwR5NqgaNovbvZ0on2R5mL4XrOzAHED0VBs7t3nAZ3ALnL24ulGnCSVV0vf8/QqDtoScFC4qQg144V6005XsBDaFx8L0gRav85dyU9k/sOd/YZzB8sBCmNldapS6jFyMaok36ipSim4XcubGxVARsn8/64t0HOlMS/OBOGjJR6ON+I7JAz7KGKBQzuRfeQpEf0aZB2exy7FD8wMZwT9HK4ee6Tt+xduO18uNNs5jnkzNy6Hzs7l2PWjk1jFgZAy/3JAw7jVWB32greCzLbpGqSMm7KPo3DeKhTNTsLsY/msM6lBzhY6D/J18L0MUzwDCccJzlhWMAeZEhU3LhAbve2HtbSF541Q3itdCCfpxeFxjcKIICGM+BY5IaTbegJHgoVQ2z+1d3RKyAJXAqA2M6YPM3/VjyQBLWQeRSUWzxQMtm4Ofp2ZJD3akiAzQIpnbb2uav0hK2CY6DBELjfnqSd59GmVOBCMtq0XNZrToHK9HJO44fED751ridrRWT8iocd38gjyoixmEpKUFRvWvptaOjkTjkO6ty1qUTM6U/XQ8HVIbRa1qFNHDhycwsvSKkvL0iOe8cFFAHRi0RKrIgI3D44cKrfkWW1Sp6JjE+kONiljv5Q1aoKLmdonb15s4+GyYOzd4eHD9rMUiHePvj64HjbSIcHupujwVWiDv2P6Vwqc9+M3qP94RVL5NECk5FagCX0gON/wr0o2zpyE5Nscai3oxBm2pJTkGqhozHycbhgIj3UQlu7eVnwWSOFnHFUeplFn8uW3Y6KgyagNxuJVwCjPppVkOLtsonVFX9Tgrxw3jIj8AFIEzUapEUsBbQTQ23lDLTwe4GBE4guZuRDvQ5gBSYDIyZhLCoig/BVRHDV0fXWQEAbDKjXGfCzOHxAH9fZp5/wjE2xcqvq8CSCNwZS56owX8kMddEoP2NyuHw3XN2fkUGSndam
 90CQLElu
 Vcez2WxUEl0czhnK9MIF1DcBFcWPccF8yO9flpuODYg4wf9k5B+sLujbqfmpBJEOpXEfqoPdGRyqmHe7n7gZWSRhDRwS+/4Zy5Lsqs0fLUVRAwxxTlIpreTAJ9fu7Fe+cmfyEN4ZM6cP/J0KZfChpqRPZdRTEb3o8wps6nefn6v98uKx6wiorlGV/hg6C/oyKIEeNiXD6pppMcq41LNrIhBtgg9KYnKq4CviQ3ZyOmzJv62MLIKMXiyszXmZJ2Tn36IC/EI70lhfRPizouYIIrUMHc8rpriS7mLdcZywLBieFSKR2dkaj3AxKbN6SbfTEmT+j00aeDb4D4/0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 8/30/2026 6:40 PM, Barry Song wrote:
> On Sun, Aug 30, 2026 at 6:13 PM Ridong Chen <ridong.chen@linux.dev> wrote:
>>
>>
>>
>> On 8/30/2026 3:53 PM, Barry Song wrote:
>>> On Fri, Aug 28, 2026 at 7:10 PM Ridong Chen <ridong.chen@linux.dev> wrote:
>>>>
>>>> From: Ridong Chen <chenridong@xiaomi.com>
>>>>
>>>> memory.min/low is silently bypassed for MGLRU during global proactive
>>>> reclaim (writing to the root memory.reclaim) and global direct reclaim.
>>>
>>> I guess nobody is silently bypassing anything. It's just that the
>>> effective min is stale data. If kswapd has run at least once, should
>>> the protection have been updated already?
>>> I guess we need to update the changelog a bit?
>>>
>>
>> The children's emin/elow are derived from the parent's min/low settings and
>> children_min_usage, both of which can change over time. As a result, emin/elow
>> may become stale, even if kswapd has already run once.
> 
> right, let's just say this in changelog, we are *not* bypassing we are
> just checking
> against stable data. The current changelog seems to be misleading.
> 

Thanks, Will update.

> [...]
>>>> +void mem_cgroup_protection_path(struct mem_cgroup *root,
>>>> +                               struct mem_cgroup *memcg)
>>>
>>> Can we rename it to `mem_cgroup_calculate_protection_path()`?
>>>
>>> BTW, I see that the only caller is in vmscan and it passes NULL as
>>> `root`. Do we need to keep the `root` argument if the new helper is
>>> only used for global reclaim?
>>>
>> I'd suggest keeping it as is. This function updates protection along the path
>> from root to memcg, and could be reused later. Note that
>> mem_cgroup_calculate_protection() assumes the caller has already performed the
>> top-down walk, each level's calculation depends on its parent being updated first.
>>
>> For mem_cgroup_calculate_protection_path(), it can be called in any context
>> without such a precondition.
> 
> I am fine with this -  keeping the root there. but I guess rename is worth it.
> 

Yeah, I will rename in the next version.

-- 
Best regards
Ridong


