Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 998F4CD4855
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 09:38:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D63406B0098; Tue, 12 May 2026 05:38:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D13E26B009B; Tue, 12 May 2026 05:38:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C02E76B009D; Tue, 12 May 2026 05:38:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id AF68A6B0098
	for <linux-mm@kvack.org>; Tue, 12 May 2026 05:38:06 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 49D84C1A4E
	for <linux-mm@kvack.org>; Tue, 12 May 2026 09:38:06 +0000 (UTC)
X-FDA: 84758266572.30.B3DC5A6
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	by imf21.hostedemail.com (Postfix) with ESMTP id 6D7871C000B
	for <linux-mm@kvack.org>; Tue, 12 May 2026 09:38:04 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=hLEceuB2;
	spf=pass (imf21.hostedemail.com: domain of jiahao.kernel@gmail.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=jiahao.kernel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778578684;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ioBXofrBTXsmAzkxz6qRlweS7q2Y0HlvIwdOsQxLTTs=;
	b=v+tL5KUYha0JGIHuqj7x4rj+puiFXkx4FX9kCFGhazAqrqsTVPGfEAgb8s9tL2B7zX0NXm
	PPbtYPjLHeOeLh7o5dV/+LycoJ50Yr8Ee9tyLoQ6eBaZN/RTPKUbTXoNueAmvIMEeG0+e7
	EGR6KXnGs7BZvbOHaTV9IhYtqQCTReM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778578684; a=rsa-sha256;
	cv=none;
	b=fKKUEQUl4z2+C64E8NEmQMEjPI8IWWaBIIwVZYVOwXShqjliNbeqKEOzs/opQ/IiX2ItGS
	RlZDEe26sM4/AjKkzZH/NCB8o+3vKpRVOjBfLG5jLBqdWiDKYmA7BQPPEbrISk/kzbVdPQ
	h+e5nS6Cdn9xUFMMY1v1Jw04w0tQ9Rw=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=hLEceuB2;
	spf=pass (imf21.hostedemail.com: domain of jiahao.kernel@gmail.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=jiahao.kernel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-2ba17c8cfacso54290185ad.2
        for <linux-mm@kvack.org>; Tue, 12 May 2026 02:38:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778578683; x=1779183483; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ioBXofrBTXsmAzkxz6qRlweS7q2Y0HlvIwdOsQxLTTs=;
        b=hLEceuB2qoTM/AKdUOz2vtZCqat9h6de7N9BcRHrnbIk3GF9WVyO2o4PavpWp0zFkX
         It1uae5mf0aRW8gUt/Bz+Bq3ya1oqvkbon2S8hFYt7NaSlEOJJ2hiiui7e1R1Qbw79AW
         n3jXWe7F6cOq19eKo/INX9F80l0yseOKwmCTxKzGOtIzF0/oDISTdmrHIeOnxGYgJQzS
         sVlYMdVpOTcERPlDAL2Wi3MV5wTFUpm8myN3CKkYVsqGTwNEez7/liiJu9I9S2X9kSr2
         vNC3YO1sYyM4cKmW1jWqtHaJGeJM9ZzmyZEB8tf9pqpyuPYuIVSU22M0bpLfVUCFI1dM
         Zk2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778578683; x=1779183483;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ioBXofrBTXsmAzkxz6qRlweS7q2Y0HlvIwdOsQxLTTs=;
        b=BwnX1Au4r+AAdUAWSsi88oDYeMQM8aRtSqYIGbasIf3KEjBu6OtDakNWM2EczOfCps
         Cn/nTsxTdp37YNzeq2En3crBRBa1OZcJjbBHSxL3z/j0gsmzaMDgqRQiWtdcnmd2g2oD
         CE7HlwXXc7JxDqm/vaO3Gn8N6IEEr/s1VKvM3NbPOxeddkE9Q7BqjPhWYuW7IMyCh46h
         0S0Vbf2vWYwjERbTR9lrW7YavVGmZsnP/16Mgs/Yr0YeAqfb0Lyd9r6jDIVJItoCuSdB
         vmwS6YDf04NN6663sk4R9YNRzcpPZVxxYB1cayMlesFlRv/7uVxo4eLEF7/nZAJ6uBb4
         hbIw==
X-Forwarded-Encrypted: i=1; AFNElJ/RZK1w4K1XsstqPhSMtIHj71ZgdtHn3QHGMQIWZfEQ/7NtnKCuNyj5Wac7DpnqEiyGae11Oykflg==@kvack.org
X-Gm-Message-State: AOJu0Yx3W/RZOuHtZ4A8eKuwcRDwq2uQax2B23ffdOAImDAdWU1eSZID
	hiWTeEb1Ms3THgtYk2g+1rtd6a2LWg35W8JZONN8GgkdYhxuLtZDqL1a
X-Gm-Gg: Acq92OHdapgWtL10jAAtQQ5qNkQafy1POfTcvTO0NoHWb1JMzl/dcBZ1YG1m7D/wcJb
	odaFiaGedRh9PTqR8vFSlEcMxbcHmDmdMXLLW8xIWg5sSGSnIcz09Jea2rvtXDAPF06wYh7As4D
	QJtDpvDPwYnE3CUXqFKHMo8klqWtDIiPZGsksA6UEpoCaylymr3+snWox3Aa2U+bDXDfxr6bLUv
	B8ZNW4fy8jWzV1z84h6L0GJsqul9jtSZNzp6+rpaWGQ7zyE6dQGApw7ktvuagZmYzlFIp31XzGM
	9omgqXSm9UUnOq7PmFGgveok7tN5O5XEsEA70RM7F3VB7wHSDNFLQ6msfomK2yGERcGtkVFVRVq
	UgoGuS8QqS65Xbb02Pzy+WFV2HMQcMqwiPzYmFWRtTArtHPNzxq3qHhvqgx3IVAeBrtWljFozl6
	WkzidOPnV+CfzUDJ83SxGQxhGOwHWgE0h6p5armPtTxZRKgNiK7zT5rA==
X-Received: by 2002:a17:903:94e:b0:2b2:3bb6:fbf8 with SMTP id d9443c01a7336-2bd0116e40emr24451505ad.16.1778578683270;
        Tue, 12 May 2026 02:38:03 -0700 (PDT)
Received: from [10.125.192.65] ([210.184.73.204])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2baf1d52ef9sm129588795ad.35.2026.05.12.02.37.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 May 2026 02:38:02 -0700 (PDT)
Message-ID: <46eb7e35-0f8e-e667-1f86-f518fe699378@gmail.com>
Date: Tue, 12 May 2026 17:37:51 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.15.0
Subject: Re: [PATCH 2/3] mm/zswap: Implement proactive writeback
To: Nhat Pham <nphamcs@gmail.com>
Cc: akpm@linux-foundation.org, tj@kernel.org, hannes@cmpxchg.org,
 shakeel.butt@linux.dev, mhocko@kernel.org, yosry@kernel.org,
 mkoutny@suse.com, chengming.zhou@linux.dev, muchun.song@linux.dev,
 roman.gushchin@linux.dev, cgroups@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 Hao Jia <jiahao1@lixiang.com>
References: <20260511105149.75584-1-jiahao.kernel@gmail.com>
 <20260511105149.75584-3-jiahao.kernel@gmail.com>
 <CAKEwX=PW2+EN41ANutv4cv+iM+JpwV5V+NSp5ukAt0M6fbHFLg@mail.gmail.com>
From: Hao Jia <jiahao.kernel@gmail.com>
In-Reply-To: <CAKEwX=PW2+EN41ANutv4cv+iM+JpwV5V+NSp5ukAt0M6fbHFLg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 6D7871C000B
X-Stat-Signature: 4f8xggaumopf1xbtor8z6gkitdz8rq8r
X-Rspam-User: 
X-HE-Tag: 1778578684-361765
X-HE-Meta: U2FsdGVkX19ujIipqrqstQqBzcc7npc3gQQ0/4qUO/MaZ/5sG00TkhRkCwwVAgBsULQMCgMv97ay6twjh6xK5USwCxhCtibzG8MMWPQ1PD0umEAkhkIi5YAXG6El1MuXbiyxJrHSnKMsJ0IV3GXfUgOLs0lwQAqCrJ2zMMWjyw67cSfdVgkMvUge7eckr95a+zROoojtstb3aOytciNvt0z9vf/gvs0KH4NjmiINouhCh1C5PEfId6CpiMytleLAGl7IZt3WYHaRsZUaiSEIKSg5xhobMK5dMyxZGWWrYxUGA8Njf11lI9zgkxxmSJaFdio7BxdYJBRg9X32ai/nfQMBn6Sc8oZgIR90B5Z48Tgg7rAjIywBZ/jKvDF6H34Kdp6FqWFGupC9AGZ98nF9DyWBjCMO06z1dmzHn6NwpsS1QShVLZv4Kps91muo3gyWIpOAfXp326ILovcMQBZaplRWMAoNFUGwCdgGGBUq7g1roGPTVlYxgMrfjnfynyUSJ0PVDP5W0IwxxnHW5d9Imyjt/F1MMBHU/apacDFHmw/2da3RGm25jRJGeThPuEJKFXd0QfTj6fhKkpxZOx4iTMKq0VOeAh/uUsR1kfEJJ9YuXQDp6+LW9eqszJf0YroCaz9mC+IKTqG5/CHw95PrqEYO3fe77zXSJzLbA/qCdgzuocGpX7ka5CUYBEaeE6EIOURhZSNnKrxmhTqDGJA5OXw+XNg4xDcGlmGkCpW/RbQ6VIXeQII4tAyAHMLJZmXgHXxnazB4NI4KUJi4LW5RK+clOQNRJ/ai+FlDqsVjreBIRZnOkoFcou4TCXAknZFYuEPnxykGzPe6I0Yq9dNoDdAoLNWWOsG6JWQL77XnAitHwjM3eKpUdJihaMiRZZWQ6QYPoXmEVj7GGey4QzafELzIOLOgEhu9MDjW08NTYzWdNkmstMCtuhVqrZJVIzHyIZUWs9cjipjpLXcyQ+V
 Cq6+oE1z
 u5jmSKYPyZmLpk2r+bwRJ5g73opRivtXaCfNRQDHwbiPYUb3Fe6VP2VIwn8zCk+5K7dYxV1AOe9zbadrTSV68DfDztTL0ZJsLFIR1tiqPOK/wbsBzbUJvSotmywkSm+fgopJC9L3PAXu5fgUNnIVVAeQkSIyaq3VCEZ1WnZ/588lSzj1bVbOFo898SmbslWnHI/7CsZD54Nir1PLy2PfOaVoFks1ZcJDRe6YtqCafHO6iMn87rMKgP2QlkFg/ZfOCCDft7da09uv5RJvLlDZpKl3PZOErXEHjkk0wOdMMAU4prM+mmmMHLwLL/UWuiFnxneqS63S5HnP8YFwcSeMtAT8xX+8IzLlzsAq9Tfi6meDi59ijBnHXR/YrkerJmTDp4/+1GK0dadiCCv8+h0g3Ji6f+Gv/GKnioY9dC4vNgTbf3ERTZuGguvxzJUm2qvEZfJT3yLsGQQFVCDebkcJgEbvqcf8EksjORchx0WhnqNtc+MPkPlGGRpcE6ugEDvvT9I7rQyFRekbVG8GrrUDPuxcROdcLW9UVZj7FinosgUTH/bhz8AMTONvXayP3YIzenn7/RuOpWwfEJ5j+0iupc7w81rayZls1sRwx
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/5/12 03:54, Nhat Pham wrote:
> On Mon, May 11, 2026 at 3:52 AM Hao Jia <jiahao.kernel@gmail.com> wrote:
>> diff --git a/mm/zswap.c b/mm/zswap.c
>> index 19538d6f169a..1173ac6836fa 100644
>> --- a/mm/zswap.c
>> +++ b/mm/zswap.c
>> @@ -36,6 +36,7 @@
>>   #include <linux/workqueue.h>
>>   #include <linux/list_lru.h>
>>   #include <linux/zsmalloc.h>
>> +#include <linux/timekeeping.h>
>>
>>   #include "swap.h"
>>   #include "internal.h"
>> @@ -160,6 +161,12 @@ struct zswap_pool {
>>          char tfm_name[CRYPTO_MAX_ALG_NAME];
>>   };
>>
>> +struct zswap_shrink_walk_arg {
>> +       ktime_t cutoff_time;
>> +       bool proactive;
>> +       bool encountered_page_in_swapcache;
>> +};
>> +
>>   /* Global LRU lists shared by all zswap pools. */
>>   static struct list_lru zswap_list_lru;
>>
>> @@ -183,6 +190,7 @@ static struct shrinker *zswap_shrinker;
>>    * handle - zsmalloc allocation handle that stores the compressed page data
>>    * objcg - the obj_cgroup that the compressed memory is charged to
>>    * lru - handle to the pool's lru used to evict pages.
>> + * store_time - Time when the entry was stored, for proactive writeback.
>>    */
>>   struct zswap_entry {
>>          swp_entry_t swpentry;
>> @@ -192,6 +200,7 @@ struct zswap_entry {
>>          unsigned long handle;
>>          struct obj_cgroup *objcg;
>>          struct list_head lru;
>> +       ktime_t store_time;
> 
> On the implementation side - will this blow up struct zswap_entry
> memory footprint? If so, can you guard this behind a CONFIG option, if
> we are to go this route?

Thanks for the review. I'll address this in v2.

Thanks,
Hao

