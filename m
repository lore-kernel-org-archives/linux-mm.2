Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 342D9C5DF94
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 06:12:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 09DA26B0092; Tue, 25 Aug 2026 02:12:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 04EDA6B0095; Tue, 25 Aug 2026 02:12:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E80116B0096; Tue, 25 Aug 2026 02:12:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BA74C6B0092
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 02:12:21 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0F23A8032C
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 06:12:21 +0000 (UTC)
X-FDA: 85138772082.15.6EE58E9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 3A3B7180004
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 06:12:19 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HAZBHk89;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of krzk@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=krzk@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787638339;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QLkYwJhSrppDaC75EDNyyo/yPnnKezeIKJ2EQPyFq8E=;
	b=dsRO6b7KRx2WFYl+OpbzEXKpkDGcYziAbsFHILYFzkVVR2xkTXnZp6FyIxpHmXuIZWbeeu
	BkQpmKJ9RxjZhpTQBWMjgZwIy4Y1hlTk+ScnSfO4DNX0e1vggx9jOZmHJya8toeF7dirEZ
	alkvsTOitdA9R4K2nV7foiMa/M1bT/Y=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HAZBHk89;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of krzk@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=krzk@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787638339;
	b=X2/hm9NXz0KcZaSMk5tZEyvPjko+B+SRWIjiUtXX827kgRP28rzUgDCjU5MX6qdB+Rci8+
	a070VbJPN3i5qr0TfZ1Cb+ZGEfLz5ub4uGIb1LvNjVeXmORMnmX7/m4DclmLwNQY7V9Alh
	SEDLSFPKTKGm4Lv6urbRwXfRvdKlLQc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1B93241FBD;
	Tue, 25 Aug 2026 06:12:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87EB91F00A3A;
	Tue, 25 Aug 2026 06:12:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787638338;
	bh=QLkYwJhSrppDaC75EDNyyo/yPnnKezeIKJ2EQPyFq8E=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=HAZBHk89ukFLiZ7HwDBBYlp7iwmWcm5nDfb7ev9uvLuc90LOR5Gyk53GtB4XRWU8U
	 Ud/KyhMuqHQlCAJgsE3nfZI0xPVniyBLc8x/lwnL4ewGL1crxzfAWJpLRtKUNVw4el
	 qTaOflJ2XJToZPwuh4yhyAS5JRAvw1pFPWMvlSm0oUzfTC1CAgi0JaarWWpTT9b1wF
	 A8udn3pTnvX0rx7waalmFnBH9EyeJfGiH4bmpkaWcmDqm3zaEA4zw5AvR0nAAYzsyj
	 7RiaSpdEIaIM6V9PNT1VHaaXJZVouUXY8Je0cY2ZUWdHWNm5Y2A7b/hG4sjH4QIgbD
	 jQvXPCsOErgMA==
Message-ID: <041af2b5-9136-4027-b35a-72e5044c63ab@kernel.org>
Date: Tue, 25 Aug 2026 08:12:09 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/shrinker: do not hold RCU lock in
 shrinker_debugfs_count_show()
To: Nick Huang <sef1548@gmail.com>, Shakeel Butt <shakeel.butt@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Dave Chinner <david@fromorbit.com>, Roman Gushchin
 <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>,
 Qi Zheng <qi.zheng@linux.dev>, Meta kernel team <kernel-team@meta.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Zenghui Yu <zenghui.yu@linux.dev>, Nhat Pham <nphamcs@gmail.com>
References: <20260610232048.62930-1-shakeel.butt@linux.dev>
 <aoxKKXjs3o6jUanE@nickhuang>
From: Krzysztof Kozlowski <krzk@kernel.org>
Content-Language: en-US
Autocrypt: addr=krzk@kernel.org; keydata=
 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
In-Reply-To: <aoxKKXjs3o6jUanE@nickhuang>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: nh76sq448izu1cmyqg8w1oht31175uc6
X-Rspamd-Queue-Id: 3A3B7180004
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1787638339-690397
X-HE-Meta: U2FsdGVkX19GwhiWWhmKe6fsWAq94tPkdnfy/KNXXZn+C6+dWlhECEesDlHqbEDfOV3Lg5WnAKhcjFAcYowMKymbBGRD288M//GEXdTBJaGxLt6H1sd8dmOscVVM7wRRgktRtQS1/Kp4RYZYruOzUxjQqNBnXdLFJxbv2+DImkg8cFvs1r5qIsAfplcqgvqj1g7ZwVy3MgCcCbPggOJrb3U1H5TTeax0PTKkbm9KmPNg+MA4NotbKVVZEI670LyYma6bm1rxTZeHsyAdPyJJ/jUKk2cRM0m9sKyuSfnoIh4WqJFWpIpIaTj1/urcyCmQDPhu3d3xS1E7OHDldH9wTfgVP3DELCSnSl6WAnqQw/+ZWeQqWuoDjpCsMtkMEejAKEGLtKosEIc5oke9i2Pb9j3mQPxNneOUIA3PJGz6y7ZNp7sqWdeO6PlZNytmf3w9Q/oXlGv35EP9nDvblCTa8B9GfqaSDQGRR5E8sNasKHcBU+dEToJEWjkxXnor/UcbzdeXcSm+npkNYl3Zd7xSPJZOlCSZ70F21fSqRR9cj4ecnipU0bP7Oh/PqJ3FaBpcslzcoMKnPabW9DA0tDk2BfjlB3JFPoSatu57WLpLNfcKU6K5KF6onLEfOT4Ehi4tTXtPWGr/IbWGyrBS49KesRCrY5YCNFHszmh9iF0ZrxUNGkFLn0BsxyxrmJQ+/ekyvvEaPJxVSYIXqC+msvrDg1RgB4njCP8ajyOqsZipZV95KnbpZ2PwnOTF+wgIEpYu2GdAG2wKi6pf2FDodha8QwOOX+sqLWpz5J6pM7TWjUCEQO/PW553i1S+BR43XAB1qiWfC+PiQ+0SZ584CZdYwl7nEPOyqDtvN3wJkVewUVQ6DQfdzwu3FFxce4EiwkZiXrpl4stX+3oxZ3bg4mYvOHRCHeyoTRcfXVOj0DTEQ/kpod3GDwWrOOkLlOCdJ6F1OTKrnwr7RapHcDmT9uN
 gmX4cwpN
 SzCmqqh5/t2+Eb3xN8bcIUUrgR+NjKJeI3hqMHf9GqV9XI95QE9g+KvMxxG3qo2YRIKBVEGciVxC72xt5ZN+ndS3p6X9adHRQSR/a4WxY05+2bWIWZTWRVuN0rMlcI6plNEFzLSJntrkXN+AkImvFv2tXj7ZBFp+MmAjhUz6C7J7gYngFIJ3+zbv2m1fXpW4DQ5Vh3gfx7V1Wry0mOSvGHLMGggK4fi3zdqgzeJoVSaruMqgNBngwBQQZ8V3V3B1c3Ftb9gw3xMN+rrDgiUWTgyKms839Viq+eeH1fJKl6Z+ne8v5RzPGYCLOAjr1EQVdNEQn4h7JqhrvIpuND85l1nypt+YJVH5Bpdha
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 24/08/2026 15:42, Nick Huang wrote:
> On Wed, Jun 10, 2026 at 04:20:48PM -0700, Shakeel Butt wrote:
>> Reading the debugfs "count" file of a memcg-aware shrinker can sleep
>> inside an RCU read-side critical section:
>>
>>   BUG: sleeping function called from invalid context at kernel/cgroup/rstat.c:421
>>   RCU nest depth: 1, expected: 0
>>    css_rstat_flush
>>    mem_cgroup_flush_stats
>>    zswap_shrinker_count
>>    shrinker_debugfs_count_show
>>
>> shrinker_debugfs_count_show() invokes the ->count_objects() callback
>> under rcu_read_lock(). The zswap callback flushes memcg stats via
>> css_rstat_flush(), which may sleep, so it must not run under RCU.
>>
>> The RCU lock is not needed here. mem_cgroup_iter() takes RCU internally
>> and returns a memcg holding a css reference (dropped on the next
>> iteration or by mem_cgroup_iter_break()), so the memcg stays alive
>> without it. The shrinker is kept alive by the open debugfs file:
>> shrinker_free() removes the debugfs entries via
>> debugfs_remove_recursive(), which waits for in-flight readers to drain,
>> before call_rcu(..., shrinker_free_rcu_cb). The sibling "scan" handler
>> already invokes the sleeping ->scan_objects() callback with no RCU
>> section.
>>
>> Drop the rcu_read_lock()/rcu_read_unlock().
>>
>> Fixes: 5035ebc644ae ("mm: shrinkers: introduce debugfs interface for memory shrinkers")
>> Reported-by: Zenghui Yu <zenghui.yu@linux.dev>
>> Closes: https://lore.kernel.org/all/c052a064-cddb-494f-a0d8-f8a10b4b1c4d@linux.dev/
>> Suggested-by: Nhat Pham <nphamcs@gmail.com>
>> Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
>> ---
>>  mm/shrinker_debug.c | 4 ----
>>  1 file changed, 4 deletions(-)
>>
>> diff --git a/mm/shrinker_debug.c b/mm/shrinker_debug.c
>> index affa64437302..cda4e86428c8 100644
>> --- a/mm/shrinker_debug.c
>> +++ b/mm/shrinker_debug.c
>> @@ -57,8 +57,6 @@ static int shrinker_debugfs_count_show(struct seq_file *m, void *v)
>>  	if (!count_per_node)
>>  		return -ENOMEM;
>>  
>> -	rcu_read_lock();
>> -
>>  	memcg_aware = shrinker->flags & SHRINKER_MEMCG_AWARE;
>>  
>>  	memcg = mem_cgroup_iter(NULL, NULL, NULL);
>> @@ -88,8 +86,6 @@ static int shrinker_debugfs_count_show(struct seq_file *m, void *v)
>>  		}
>>  	} while ((memcg = mem_cgroup_iter(NULL, memcg, NULL)) != NULL);
>>  
>> -	rcu_read_unlock();
>> -
>>  	kfree(count_per_node);
>>  	return ret;
>>  }
>> -- 
>> 2.53.0-Meta
>>
> Reviewed-by: Nick Huang <sef1548@gmail.com>

Sorry, but what exactly did you review here? In the past you were
sending AI slop:
https://lore.kernel.org/all/aeNGbNyPxJssnkbO@lucifer/

Not even properly following the process.
https://lore.kernel.org/all/20260724143408.175870-1-sef1548@gmail.com/

https://lore.kernel.org/all/?q=f%3Asef1548%40gmail.com

Why suddenly reviewing MM patches?

Best regards,
Krzysztof

