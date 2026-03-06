Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0174EFCB61C
	for <linux-mm@archiver.kernel.org>; Fri,  6 Mar 2026 16:24:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1C3216B009E; Fri,  6 Mar 2026 11:24:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 19B156B00AA; Fri,  6 Mar 2026 11:24:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 07CB26B00B3; Fri,  6 Mar 2026 11:24:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EA9026B009E
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 11:24:05 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9310E8C0AA
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 16:24:05 +0000 (UTC)
X-FDA: 84516160050.16.42EE4D4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id A254280003
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 16:24:03 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OcMGJfRO;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772814243;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2g0u0YU7losZb/pf8Er5zcLG5Juf+cX24GkK9yShrmY=;
	b=fLUKMPJMMs6N6V0bQC8hMwYMdFCIr1T0bQ2jjLZTlkxNl6g7D9LKRF1ACdBcLJEZ5wyAhL
	GHDRkaWTCplw5GAl97ypNxOjS0PUv5Hx6h+Uoa/WW52eJBCRYmMOqxJyhnIb8bnV6/RZHc
	4Uh5KeRSxDA/PVA73pQVj7YA5GdwW08=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772814243; a=rsa-sha256;
	cv=none;
	b=jV8GwMaNV2hKUH7XcxQtxIjto2kM/oLJFVROC0yWBTM1x2ug0WV+V/Woh21lqPn0hiq+Ol
	EDMstGcaKGDuqglyQ4Ell/3XDdLl1V646h8SJnkkCNR+DwE8XVfw/MQk4AGW+7ptd4V2gO
	wB7UTeHIfi/qEZgdVk2Z3yLXNFxaD7c=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OcMGJfRO;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 156F760018;
	Fri,  6 Mar 2026 16:24:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34E00C4CEF7;
	Fri,  6 Mar 2026 16:23:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772814242;
	bh=9h1lyEgM+GxS6qSq98yQHb8auw7NBPQnSoVt7zW8kt8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=OcMGJfROeAkAi1TOw9J5rtJAw0pKovKAG4Ldl+hW/+sY1kFAGs8x3yWre4Lvy4neS
	 Muvg76OrE4AlupG60VCKZV1KV/8SVY5OiABXbDlA4Xn5sFlS2XVSAymAP47IAJpICq
	 wEdky5z2ghiwYQJ7rOyMek/zUQo0ew3Wa0sI71R9SZQatTP0OYfqgnLlB8PYH4etu2
	 jsN3d1b+elZCOdY8Qz1GVjorHwPikLm/LS0QtoznHuqtYNtlpoXkLASxJhNkJJOHAI
	 2aDORfGNoz2/RvQgbRlzv7SvH+hvEWIw3jMCI5vTMfHnX50072mMTzvGdRV7AfHkCr
	 6jfv5dHkyo3iQ==
Message-ID: <c6fa242b-d29e-419e-939c-d2b311ca5710@kernel.org>
Date: Fri, 6 Mar 2026 17:23:53 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: migrate: requeue destination folio on deferred split
 queue
To: Usama Arif <usama.arif@linux.dev>, Zi Yan <ziy@nvidia.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, npache@redhat.com,
 linux-mm@kvack.org, matthew.brost@intel.com, joshua.hahnjy@gmail.com,
 hannes@cmpxchg.org, rakie.kim@sk.com, byungchul@sk.com, gourry@gourry.net,
 ying.huang@linux.alibaba.com, apopple@nvidia.com,
 linux-kernel@vger.kernel.org, kernel-team@meta.com
References: <20260306133556.2051251-1-usama.arif@linux.dev>
 <ab22e50d-3af0-4acd-9d7a-a0e86d0c4fbe@kernel.org>
 <64051a59-680f-40ae-b291-b884aeb7c77b@linux.dev>
 <993B37FF-29E1-41F5-A1E8-F38B9CD24478@nvidia.com>
 <28e48b47-f215-4e4a-b55a-01dbf293ff35@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <28e48b47-f215-4e4a-b55a-01dbf293ff35@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: A254280003
X-Stat-Signature: mxxqhr56oy1wb8osxcgzukchwwrk3pip
X-HE-Tag: 1772814243-920557
X-HE-Meta: U2FsdGVkX1+gU65X7m9CJ+DIL8UfCIS93v+9PIEEjIY4IhTH1WbVYSam1sWXL8qoYDaMoHxNC5y+26Y41h46zP/MwCpc3uCvxG24cZFohHiyIfa8xn+Gw0rDkTRDqMiwXcAbw/imnWCAoNBgvaI0rtfXBl0lorgr/5l0rYnDTHl1jiVdtc/GdxEZmJN6pvMYVL5V6WV9GRtuC1vUaE4mIM+UoM5rPsXRCsRNRXRLivAst0VuB9LXqhhzlz31FL8S5jMMpG+j9QY9ZiDV07StKaPs1qkKB4TDXqnLGqW1Snf8feKJ99GaN+yGuqKXiPZCSuI6O0+8NheSBAhIGJNd6Jxomto0DtsmQ1ZlsDOl4BYRpGnwiMLIrlEO65fHiwJFR3skb9KLlklrS+8KwdfSymEqSurlOEdCB+uz4e7T2iokAprU8rNPNl8HjaqVvV96KH+rnz62Pixb0YfuIv+TP3GsQVoI6FLO95t1V2JxIYGTb4grXZZ/Cr5qYTI212RaiPrSWCoPVM+A50IIm/KmM9jMGnKHJRu0c6lPZdseIe6T894qJk5N8qgBC9yBVJAxJJvL7Umg+Itz0+UsLMNDxJvxhE+M4qJ6MKqbUrSJPZHclE3DB5Ut8bLwqOQEJJ8KrF7jhKn63t2LRXbfwjVA36AiFbeJKJrC8PxV+P6RkQIvAenOHkkhDXRHl6U3t1TBJ7Nsk86jDSKmra1VnU8lcrpffh/C0eeaRxgK+Hf1ROUwkGkQjwSF9VcPdhiG/5+eOvIkIDzYkoX+kNO8pWGhYV96Ub2Ah05I5WHepLSfnxJD+R/jWX05Q/oVUnGdpA6FdQNJOC8clBlEebpTB+pD1bglmxlRAV7mG4/dyVpH4gxZPkvcWfu4748IuuogesfeUb8lCxXXsd3o57QvA6/xw7idKfh4h+34ggL9VX9OkrxCdZeQ4VZvfOk9fG7dAgu0206m/vewcSE6uOFrpp9
 fklQ93TP
 0necWzLv96L53nmxropoi9x/C9wdaedpSUDKhHyq0tjYCOtNWCSiCIKEjnAvgjScZSQgwnylvsEgDBZ96ZKu+dRrxKN88ZP91ijyJRodlq+Mqq+MOm7/m8QWyyL3yD6yd4YIihLOVpyn73TVVd8ubriZGeM+GHVdjRswR37fnYcsVWxduJxONTfLxiOhBAreOV9U2xZF2KxESKh7f/RluDSS11Qs3FUUh/3UV84f9T8J6bCgUhNEEJNRu2MbVDXKkgNSMcUtQBXtPmdiecPw5pO6U+l3/D1PWNgey6flHvySOGSSCBc6igGxvukqx1n0QxijLzOZ9eqNnJeeOcljpnP7OOe2USFMdJ9jlpnBRAmvDtInIweyv8X4cVnlWcqvAjWYO
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/6/26 17:15, Usama Arif wrote:
> 
> 
> On 06/03/2026 14:46, Zi Yan wrote:
>> On 6 Mar 2026, at 9:12, Usama Arif wrote:
>>
>>>
>>> Yes you are right. How about something like below? We also won't need to check
>>> for anon and non-device folios with this as we only set the the flag if it was
>>> already on deferred_split list.
>>
>> BTW, migrate_pages() tries to split partially mapped folios before migration[1],
>> so what remains in the deferred_list would be:
>>
>> 1. partially mapped but with a pin,
>> 2. fully mapped but potentially underused.
>>
> 
> Yes, thats right.
> 
>> I wonder if you want to do an underused scan before migration and try to split
>> underused THPs.
> 
> hmm, I think we should keep THPs as is if there is no memory pressure (proactive
> or otherwise). Scanning THPs for zeros has a cost and we would also lose the benefit
> of THPs when we dont need memory.
> 
>> Or to avoid this additional scan, find a way of detecting
>> zero pages at page copy time and split it after migration.
>>
> 
> Yeah but I think we lose the benefits of THPs after migration when we dont need
> additional memory?
> 
>> Anyway, it seems that all large folios are in this deferred_list. Maybe, like
>> David suggested in his LSFMM proposal, we should scan large folios on LRU lists
>> at reclaim time instead, since there is not much difference between deferred_list
>> and LRU lists right now.
>>
> 
> Yeah the THP shrinker is a very basic implementation and there are a lot of 
> 
>>
>> [1] https://elixir.bootlin.com/linux/v6.19.3/source/mm/migrate.c#L1840
>>
> 
> Also Johannes pointed out its not great storing this information in page flags,
> we can just keep it as local variable. This is what the patch would look like:

Much cleaner.

-- 
Cheers,

David

