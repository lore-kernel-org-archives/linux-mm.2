Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8ABB1FC9EC0
	for <linux-mm@archiver.kernel.org>; Sat,  7 Mar 2026 02:23:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B92DB6B0005; Fri,  6 Mar 2026 21:23:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B404C6B0089; Fri,  6 Mar 2026 21:23:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A42216B008A; Fri,  6 Mar 2026 21:23:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 928156B0005
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 21:23:51 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0ADE71405F3
	for <linux-mm@kvack.org>; Sat,  7 Mar 2026 02:23:51 +0000 (UTC)
X-FDA: 84517671462.01.58EAB59
Received: from out30-110.freemail.mail.aliyun.com (out30-110.freemail.mail.aliyun.com [115.124.30.110])
	by imf18.hostedemail.com (Postfix) with ESMTP id 4D8641C0008
	for <linux-mm@kvack.org>; Sat,  7 Mar 2026 02:23:47 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=x6FS0try;
	spf=pass (imf18.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.110 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772850229;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Lw0B4A0Tge8dNKKTRFvubRt7KamBtESq34Gr8317Kv4=;
	b=xHqiyt37lL9TALHtb2yDLQybgaUbJmcZ5jWu7eDNwWLbfnKcR3zFSgdG4G1K4ZVWjhFbQM
	fhqWkcCsZvEaSZRc5R6nyhnMAiECD8iFBWiknagCmzLCJLCdgfSLa2Jgvv3i8CKIa1ZIYP
	g4zWKPCb7ulTFzVDjUsQ7bAz1AssV+M=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=x6FS0try;
	spf=pass (imf18.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.110 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772850229; a=rsa-sha256;
	cv=none;
	b=7hcAT8czH9bf2wm3D38xcpPhH3v3MYgfHQhCf+INWwSckr3F3H4anHRcSatZNSQwpwuNGn
	Mym+cKTwYrVlGBfvdXXQQ0cQinajqok1iHpjnS9WkDkyV+oxw9yQxDaRSFsFfso9D6nPBD
	oh+9vW82N33gBi1AZ48sIPKwBRn+5kM=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1772850223; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=Lw0B4A0Tge8dNKKTRFvubRt7KamBtESq34Gr8317Kv4=;
	b=x6FS0tryw8ZxkUeZMw5s5+tLmqJcSczLt4J6O/tFaERTvQefnB9qyXkDn5x2fQA1jmNnwSsWXr3zC3J+WrfPG4kfGqHnj29gd8OWmA7NrvlLcY7vEHy6xSdmu2V3D4BN3KQjll0De1I99FGaGiPypZ/ViQ6QGi/LArPQlu3+QPs=
Received: from 30.42.98.36(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X-Ob681_1772850220 cluster:ay36)
          by smtp.aliyun-inc.com;
          Sat, 07 Mar 2026 10:23:41 +0800
Message-ID: <41a26cd4-f11e-472c-89a4-3418f338f97e@linux.alibaba.com>
Date: Sat, 7 Mar 2026 10:23:40 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/3] mm: huge_memory: refactor anon_enabled_store()
 with change_anon_orders()
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>,
 Breno Leitao <leitao@debian.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, usamaarif642@gmail.com, kas@kernel.org,
 kernel-team@meta.com
References: <20260305-thp_logs-v2-0-96b3ad795894@debian.org>
 <20260305-thp_logs-v2-2-96b3ad795894@debian.org>
 <8b238664-4375-413c-a8cc-105d98430362@linux.alibaba.com>
 <aaqr6n3X-KRP_tTp@gmail.com>
 <789df8d5-7d03-4e3d-90b6-08f27af330b2@lucifer.local>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <789df8d5-7d03-4e3d-90b6-08f27af330b2@lucifer.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Stat-Signature: eq4fmri6yb89fbpez4o5zoieqq5m5kkh
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 4D8641C0008
X-HE-Tag: 1772850227-186597
X-HE-Meta: U2FsdGVkX1+a9Y9woU3vJ3QMVR2eNqJTKVDgE1vKd+c69OLZnEIGiMD1x3bIXD+IXrY6yCAfdKyrQDSyntwpyibmt2ESP5yKSPGv+Ds8GDpL5oRFFncacVN6zhnc6v8al+iMTtNouyhKUsoYpSBF402N6cLgiZXVqHyAaRrTVwJ2Wt6xSYo1dqMGnTtSxjjB0wjfi0JYp+gzQ3DQLfgLGdOmm1urwYa84SpCgpfTLOnArOQFbYG5ESOFbnJY+ovnajoRV2trpzkEFA22bT77MziNQwuydU6jS6R4KU4hnHLbPfHej5ilk4FqngiVnPhzeDIH716UnJtQRP61FTezMwK2QDc4Fa4HhBNFRt9Giwp2gOlCeRVMeigTigpr0oPClGzKFN/mAE0r4C0CqL2DtgjIPs12+V1B18ozVrC6RG038DayuxnipLjVwfabX7vmZZfyBjAsUcgbZV/Wu7pHFIZzqB2AI4nFVeJEAa1iC1ArA+0SOD4ZnbXPnNanL+ZISB5dRwxAUdtc91TIgDgBRyfRkxjlX8V+O1IMcG86fJnyGK/2lVb05KV/ZRLnqmPoq2iHSYFVRJYfactxoTUk0pycnkMSMr5H6gJOs7m2BGeFiaHFvybpIQpboxb+7DLanvkxftH2UT5CteVHSMA7P/cucSeZchtc6NFaVpwdbuwsSVtf+A/ltUZrTcLaeJrVyu7m66/c6Z1qoKwY9oNcYtXd03Ulj9m1CZgi2Gy/26K9xI++dZsUp7xZ37dzEMqpdrgZItmR4tfJRQ4PpDdqCPGCnvXsD8GD8+Hm8D4Bu5v9nvqmtMZ53/3SE3lH8xBfRs4br1B02/lhak9s09XzLvelnrFo/vn63r1eVkFbHwnwc2/y7LktJafAfnjxquA0FvNlDJ5w3j5hoV1XO3uMtDVMS1CH17JOvQEZ9R5sOaF3S0yhfjRfhN8rzlDwG+bBf4lcht6v5LGNYFcin+n
 92EzZZly
 ad75iHcc0NQbLgxNDn018dyUW7TR0wVSAcZfIFY0qmSLbcpFOoaNIi0U8aCOzPEW6kEeAhvhqTTNdy+XIgG+uQXvnx5mABxDdqW1VS4ZtRWLP7SlzY9C7Lg70yiW402IYe+LRFFMG6jOfFXQc+p26D1tK2XvLzYUlLa8HRwVLMVMz6ZWIZgarGKPLKYqdmGjcDZIB2yGOE47sLgpSGoUR/Fkmm6eiGoscJphqd1G5IYsO8fxqdt+KhwmjA8kH5okSB2o2sJXG+un2ln3Y0X9Dhz3gg1nzKhWlf8vXg4sLKJsUFATxzTJnNmm+XWBkGCJGSjAvsyPLA3rxQl+vjBmNK4T+5NT3vMetYhIUE5q8veZNRSa2T4/NdU4yqnYqg2OkSdT6
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 3/6/26 7:22 PM, Lorenzo Stoakes (Oracle) wrote:
> On Fri, Mar 06, 2026 at 02:30:22AM -0800, Breno Leitao wrote:
>> On Fri, Mar 06, 2026 at 02:07:50PM +0800, Baolin Wang wrote:
>>>> +	mode = sysfs_match_string(enabled_mode_strings, buf);
>>>> +	if (mode < 0)
>>>> +		return -EINVAL;
>>>> -	if (ret > 0) {
>>>> -		int err;
>>>> +	if (change_anon_orders(order, mode)) {
>>>> +		int err = start_stop_khugepaged();
>>>
>>> Thanks for the cleanup, and the code looks better.
>>>
>>>> -		err = start_stop_khugepaged();
>>>>    		if (err)
>>>> -			ret = err;
>>>> +			return err;
>>>> +	} else {
>>>> +		/*
>>>> +		 * Recalculate watermarks even when the mode didn't
>>>> +		 * change, as the previous code always called
>>>> +		 * start_stop_khugepaged() which does this internally.
>>>> +		 */
>>>> +		set_recommended_min_free_kbytes();
>>>
>>> However, this won't fix your issue. You will still get lots of warning
>>> messages even if no hugepage options are changed.
>>
>> Correct — this was part of the earlier discussion, where the suggestion
>> was to retain the set_recommended_min_free_kbytes() call even when it
>> is a no-op.
>>
>> As for the warnings, I see a few possible approaches:
>>
>>   * Remove them entirely — are they providing any real value?
>>   * Apply rate limiting to reduce the noise
> 
> I think rate limiting is the sensible approach.

+1. Make sense to me.

