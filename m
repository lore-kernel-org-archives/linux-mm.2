Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D7F4CC4451B
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 04:42:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B9AFE6B0093; Mon, 20 Jul 2026 00:42:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B4AE76B0095; Mon, 20 Jul 2026 00:42:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A14EB6B0096; Mon, 20 Jul 2026 00:42:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 62CE66B0093
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 00:42:56 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C2CC7C070B
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 04:42:55 +0000 (UTC)
X-FDA: 85007909910.09.E2414F6
Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	by imf27.hostedemail.com (Postfix) with ESMTP id EE2EB40006
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 04:42:50 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="JY+o/BAB";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf27.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784522574;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XAnwXaAATsOLEHJoanRaTBrNyT5v1P4RBlA4x0esH0s=;
	b=njFlY1PAk67V+mgZvy8uJHN2y7PV62oa65ldLUWnxaoMv1ocmGZgk9a191xcX22qhAjnr4
	8ndQcKR5rIjCOdieOM6fV2C8TsQMptOWk9HKdvNbkOKR5CkLbnhPHgjrNhfLBUf7fjpLdd
	mZ27Z++O1dy7Feif9AuWHGouYD3hPGg=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="JY+o/BAB";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf27.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784522574;
	b=DcB2yzlVPkhIBEplunS6Rue0IGwHCfRMIiCxJaThM1QAo9wMUwNzxmu5j45dgXqiuAMMSM
	6XoFDRPpTkj8TENEyi5kV0QvUwKln+uOR+Z8bNs9hf8jG580Kfz7fxqNyosle94M6Vq6/O
	4751LKHY7DucP0cAq04h7dHBp2xQJMg=
Message-ID: <bcace78f-987f-4908-9e65-bf0b9a52855c@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784522568;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XAnwXaAATsOLEHJoanRaTBrNyT5v1P4RBlA4x0esH0s=;
	b=JY+o/BAB/uuKPTec0ANjPlAKtGb1z4II6LDbrFoOGHJIiJDulI1oetOHjRRAB4lNzCFZgo
	/rDgLfRH05eM464IXuPzcyv7XSssziWTt4akPGhSqp2z05CEgXgANJousagSF1Eg+KYN8I
	Djdy6CwQvXMax3ducEvX55eKYqbBZv8=
Date: Mon, 20 Jul 2026 12:42:32 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v2 1/4] mm/vmscan: fix anon-only reclaim evicting file
 pages when swappiness=max
To: Barry Song <baohua@kernel.org>
Cc: akpm@linux-foundation.org, hannes@cmpxchg.org, david@kernel.org,
 mhocko@kernel.org, qi.zheng@linux.dev, shakeel.butt@linux.dev,
 ljs@kernel.org, kasong@tencent.com, axelrasmussen@google.com,
 yuanchu@google.com, weixugc@google.com, hezhongkun.hzk@bytedance.com,
 muchun.song@linux.dev, dave@stgolabs.net, roman.gushchin@linux.dev,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Ridong Chen <chenridong@xiaomi.com>
References: <20260718095251.82937-1-ridong.chen@linux.dev>
 <20260718095251.82937-2-ridong.chen@linux.dev>
 <CAGsJ_4yYEaoiTY0vFtqJK5fsXZW2PTkMu-qZ=X7=cqmMVa3YCg@mail.gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Ridong Chen <ridong.chen@linux.dev>
In-Reply-To: <CAGsJ_4yYEaoiTY0vFtqJK5fsXZW2PTkMu-qZ=X7=cqmMVa3YCg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: EE2EB40006
X-Stat-Signature: xq14yy7zps791hca537k6zk8a78yedak
X-Rspam-User: 
X-HE-Tag: 1784522570-72356
X-HE-Meta: U2FsdGVkX1+4a5Fbx5qCI86RyXd41rLBWyOmpZZ8N3fF7YjRVdjT2CTZtTLhvEuOvDb2II6VtF+mJwM1w2tFxLbOWKmoHSsoF7n/ND/tX6K7w7OuRaqZti8Nzh8ljR6EPBEGKuw1M1xlimkCUt3yfdsgmhnDSW854Xv0OsxJsS6k2T4lwNXQyhhdBqmp7fXvHNHaGtKHAUsCPvPznoy7j9hfEytmOykVP5gKaruuIhk47VwZHfaLyJFQPG5kh+v8A06QSTdRuZWS5AJC0hx7LAmUD6tBG7g8M+/isXPnttTu94DAACjEWWUdwTt2N6RLZ45zkDbtzbBgBKOp9xDYhva+1+sSLE39OddCU9Xd/bgRhsYK0RkUk7GyUPsBEO4lAVs8MaDF7D+XCzU4NXBE5N6heBwdktkPddbb+jRHA7Fp1eahe4B0EVymydj4CJIv1xeUzsZnInJ6xRrHcsJErplH9T9tw1kLAYNCszpG7Sia+smesN3XWHbGcHHX+k0hHuzrKAL3FtxqByyLbTtwXoN9sFGDFXCXOXJp0ZAlJ7MpB0fDN+Rr8SA8fSAkUG0cFualVFH0pSTqSBz3Fa/uqXoKf1H0ZgWfRdBfjVwWsr9GFAHtwiAg8u988vrRg5UyIFxE32a9V6T4EPuytdUwWMi6zjo+CuUD7Mr/OVbielKaNE6ZXkqZjcFF2lWOm0s+Q4eH5wU+loEkF89AtWhiujApbBzR8zCJyl2HdnCblMJX4FYvATsk5k2wk9ZQ3adFzfDL32aev8Oi22bSgT80E2DTeLIvYY3Pm62v0SAPC+pQqN/iPn2br3gVDgAXrPAkwzB7tTOYMBqqdpfe+elWRExE77/oZy3dy0nyC+rxvF5jVH58qE1wuSQVXdKmnsrucLP5IsKF0EJInHc915nqkGfarXElmrW95+CzcFKS6OOUhbyTXBE06zocec+vPLctR6u5olNg0hntRGw/sZd
 KRCbSBa6
 Mz4YWpuiv7n2pZr7qa0OWpW2eVXfa+GWK1zzRYfghanH8BBNDPyjN2m6Ug7x62V4EJlGvAZLIikcRFqnaZGcbOnOFMceySWaO/FZf4oTX7PRglIdYyib5GAVjE2zB7fH50GuVdTno2GKfin0zVwMvkGn4HM8ZMf/KGOTIoB4jQUva2pbSd60IrlZiyXQDtNJZ1mYZ0VXFpAiOtjTiSnVVEeCoq6hFYUeRt96YUWTVO7r2/5SvZfQEFSWQ7daz3L1gSiwb7Oj7BcHZ6MrIzXLHOgI08PuvK59QTfEdOHcrR0EY4zRfDNXtaE9zwl/GcLRNebveBqvjJ+E+XNqe8Clt4FBwUw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 7/18/2026 9:34 PM, Barry Song wrote:
> On Sat, Jul 18, 2026 at 5:54 PM Ridong Chen <ridong.chen@linux.dev> wrote:
>>
>> From: Ridong Chen <chenridong@xiaomi.com>
>>
>> As Qi mentioned [1], when swappiness=max (SWAPPINESS_ANON_ONLY) is set,
>> the reclaim logic is expected to reclaim anonymous pages exclusively.
>> However, due to the current ordering of checks in get_scan_count(),
>> file pages may still be evicted if can_reclaim_anon_pages() returns
>> false, which contradicts the semantics of SWAPPINESS_ANON_ONLY.
>>
>> Reproducer in a cgroup holding 64M of file cache, with no swap configured:
>>
>>    Before (file cache is wrongly evicted):
>>      # cat memory.stat
>>      anon 196608
>>      file 67178496
>>      pgscan_proactive 0
>>      # echo "64M swappiness=max" > memory.reclaim
>>      # cat memory.stat
>>      anon 208896
>>      file 4096                 <- page cache evicted
>>      pgsteal_proactive 16400
>>      pgscan_proactive 16400
>>
>>    After (file cache is left intact):
>>      # cat memory.stat
>>      anon 200704
>>      file 67178496
>>      pgscan_proactive 0
>>      # echo "64M swappiness=max" > memory.reclaim
>>      -bash: echo: write error: Resource temporarily unavailable
>>      # cat memory.stat
>>      anon 208896
>>      file 67178496             <- page cache untouched
>>      pgsteal_proactive 0
>>      pgscan_proactive 0
>>
>> Fix this by bailing out early when SWAPPINESS_ANON_ONLY is set and no
>> anonymous pages are reclaimable, before falling back to file reclaim.
>>
>> [1] https://lore.kernel.org/cgroups/7ddf3eee-5fe2-45f7-8614-c8936a039e04@linux.dev/
>>
>> Fixes: 68a1436bde00 ("mm: add swappiness=max arg to memory.reclaim for only anon reclaim")
>> Suggested-by: Qi Zheng <qi.zheng@linux.dev>
>> Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
>> Acked-by: Johannes Weiner <hannes@cmpxchg.org>
>> Reviewed-by: Muchun Song <muchun.song@linux.dev>
>> Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
> 
> Reviewed-by: Barry Song <baohua@kernel.org>
> 
>> ---
>>   mm/vmscan.c | 18 +++++++++++-------
>>   1 file changed, 11 insertions(+), 7 deletions(-)
>>
>> diff --git a/mm/vmscan.c b/mm/vmscan.c
>> index 35c3bb15ae96..d6b383d96a0c 100644
>> --- a/mm/vmscan.c
>> +++ b/mm/vmscan.c
>> @@ -2501,6 +2501,17 @@ static void get_scan_count(struct lruvec *lruvec, struct scan_control *sc,
>>          enum scan_balance scan_balance;
>>          enum lru_list lru;
>>
>> +       /* Proactive reclaim initiated by userspace for anonymous memory only */
>> +       if (swappiness == SWAPPINESS_ANON_ONLY) {
>> +               WARN_ON_ONCE(!sc->proactive);
> 
> I feel it's a bit odd that the WARN_ON_ONCE() is placed here. Maybe
> adding a short comment would make the intent clearer. For example:
> "SWAPPINESS_ANON_ONLY is only allowed for proactive reclaim."

Hi Barry,

I didn't change the original logic in this patch. I agree that adding a 
comment would help clarify the intent.

I'll include that in the next version.

> I'm not sure whether it would be better to issue this warning earlier,
> for example in try_to_free_mem_cgroup_pages(). That said, I don't
> feel strongly about this.

Since patch 4 will address the MGLRU issue and could also include this 
warning, I think that triggering the warning earlier makes sense and 
would be more general. Would it be acceptable to add a separate patch 
(e.g., patch 5) for moving the warning? That way, each patch stays 
focused on a single logical change.

-- 
Best regards
Ridong


