Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 92B05C44507
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 01:11:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A97216B0088; Mon, 13 Jul 2026 21:11:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A46356B008A; Mon, 13 Jul 2026 21:11:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 936926B008C; Mon, 13 Jul 2026 21:11:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6BBA46B0088
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 21:11:09 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E6B5C160226
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 01:11:08 +0000 (UTC)
X-FDA: 84985603416.13.94A7484
Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	by imf13.hostedemail.com (Postfix) with ESMTP id 89AD820006
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 01:11:06 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=g1eB9y3B;
	spf=pass (imf13.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.181 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783991467;
	b=W+Tg7BrwSyPVq+bM5ITNWSBUA2+Dk4b3oheF8etwTcNIK1OMWSL5cM8YHQXfEPjleBVKev
	rwW0JKW/Kztx15PSztUsTzd7GWKATANHiA8hlg9x+62+RfBt3uGA3RRVBE7aELMPcjSRs4
	qsw/u3J+HiUXGRltWeRFKEdzbWZqycQ=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=g1eB9y3B;
	spf=pass (imf13.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.181 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783991467;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QBTuxEtzTYLRVryCNC/UKY74wgwZyisDAh2aK7ZURZk=;
	b=QTUGyLsmkEYSBqM4wMC/e/9kX47BwsxFQ/c1GDZkHIgtYUyP9m8zyKM5fq8ep6jYu28E4m
	ThSpKMh5FARwr1+4s1LY6AaU5cUAlQ32HyU0uuMQUs7iSM2ZJJQxAE4K4cWJE5Si17Pn+y
	ll6qZNqepkNowdP+/BLz95PtKU6rGbY=
Message-ID: <9117db4b-2a7b-41f3-b5e7-db9d6343bc83@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783991464;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QBTuxEtzTYLRVryCNC/UKY74wgwZyisDAh2aK7ZURZk=;
	b=g1eB9y3BOcZwZblAVHaos/wcXy3DKhqfRLmswKAnzYIj7k5fLSyUOp11oj4sbNwb7qZf5D
	OVQeC6Z25fjQDNt934i+E6iM8eKME7IJcaZ32EqXAi0m56nj+UtEEi9MO7YgS4MX3WZ9ml
	YHKg9phMJ74p6SrUNcGJpNitn9lZTMc=
Date: Tue, 14 Jul 2026 09:10:46 +0800
MIME-Version: 1.0
Subject: Re: [PATCH 2/2] mm: vmscan: fix node reclaim ignoring swappiness
 parameter
To: Barry Song <baohua@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>,
 Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
 David Hildenbrand <david@kernel.org>, Yuanchu Xie <yuanchu@google.com>,
 linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
 Ridong Chen <chenridong@xiaomi.com>
References: <20260711091157.306070-1-ridong.chen@linux.dev>
 <20260711091157.306070-3-ridong.chen@linux.dev>
 <CAGsJ_4xGKM3HxXw-mrtyr5HmwZL3L1QVZ27utCyozqSJr1F0gQ@mail.gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Ridong Chen <ridong.chen@linux.dev>
In-Reply-To: <CAGsJ_4xGKM3HxXw-mrtyr5HmwZL3L1QVZ27utCyozqSJr1F0gQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 89AD820006
X-Stat-Signature: pwa4snr6aqgfhbqfyxgrjqd48djyue1y
X-HE-Tag: 1783991466-841802
X-HE-Meta: U2FsdGVkX19HznGziDuhKUlHZ+86CoaM/ckS7/UBD8Or6+kMsyj2Js2RIGv9icJzOyp1TaX8lhEBoWSTmw6pzbrHfzfTjZsR3Mrex7Qm31xRhTDYfk+RsajJgNT88m21OZU2NtJbP52JioCuLgwgu7gGgNGvazmz8sns4lrQelL4WkqPp41P9roI4bjZwie18i/7eayFqaPoDmHIYoN11e80tJPm++TYnMFLnKBwL2kUDzXBQD/vZN8QavQuoeL4QAB4xT+Xx8BdGCpuQF0ZVSfq/aYn7c8Ya6URuxwdCZfwyTfcWp74V3Go2EKLhsnAxqaK2J093J4DnY3Ai2Avc5j3MG0SD3zUTfQCg5vhOIk7m6WpZQWBSo00I6P9+2UNr3MUyrF6EGjd53KvqotvhUCnJE/xP5aBfxMyR0XCUZsEb8d7jKM+vKhl+IkywTcQKc52O1KDCJrnI4nk+jQ56iSRA8UXsQna0PhU8pK1MfeE95N7e9NK0tyos5mhVmU65bAhevDomLeMvi4uR49j/Hrp3YgoZ4piEJZOOOLQ5RiRa7gLE/KBJQ44PPN70SMPgj+MOXnF3zWLLhvkFM3IuCnVYxZ31wZcMyoAygd3DAgXbweD9IJjhmJVCJ/EeS5L630l9uG8gGjWzHVmgTPa+ilgSDYESBgnCm818ckgR3fh4xJ4YT79toOZL1QPw2AjZamF3Mo/mH1cM9H5YydDEa+vkjXEVn6BFl5EiejEjv4KMwCi61ZWDO6ebId17Gh5ABo1VpMpATyLrXK2f3qLH4KHl6cbYzo9fKb8/J95VNw72sV693YsOKnbd58RS5KpTQqKhMz7r6V49SZymNvgjFy2kZVsuld28e1s5BuuhajTKF563fO3avqVQMyuq0WyN51l6yn8AYmjv3/iN0pCHXJui2pzTSnFFDU2tNzL+sj6IohauOAj6ZjxwwPu/BW+5H51oeFAMl5ikfBtmwS
 0cFJc0wr
 fh12S+ct2uXjcHKRACASV6HxAvl8+J6n24QrLbH3L2ajt8EUepSmSq6JZbld9+qpSVh5mSPodRzXxWMtEV7CnpJNx1neFkSeJmnWwQ+VwxrnM/3Q2Inddn6oLR0FbStb8FjBLfepNHGRNhZrrhZlywDDh9qjmpleaYKr6y5Zslp3V4vepfzkBstMr720JVaK6ic7QgqqGuMXqR2AluLfwHqbvTPefrZ1Ckyby/YSdD3qe1VXZ+UytN3KaBbJnrW8h3ce5Ny1toSA4XyhcsnxZfZqwSn+tyJStb68/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 7/13/2026 11:16 PM, Barry Song wrote:
> On Sat, Jul 11, 2026 at 5:12 PM Ridong Chen <ridong.chen@linux.dev> wrote:
>>
>> From: Ridong Chen <chenridong@xiaomi.com>
>>
>> sc_swappiness() had two separate definitions depending on
>> CONFIG_MEMCG. The !CONFIG_MEMCG variant simply returned
>> vm_swappiness, ignoring the proactive_swappiness value passed
>> through scan_control. This caused the swappiness parameter
>> written to /sys/devices/system/node/nodeX/reclaim to have no
>> effect when CONFIG_MEMCG is disabled.
>>
>> Fix this by consolidating sc_swappiness() into a single definition
>> that checks sc->proactive_swappiness first, then falls back to
>> mem_cgroup_swappiness() which already handles both CONFIG_MEMCG
>> and !CONFIG_MEMCG.
>>
>> Before fix (swappiness=max ignored, mostly file pages reclaimed):
>>
>>      # cat /proc/sys/vm/swappiness
>>      60
>>      # cat /proc/vmstat | grep pgsteal
>>      pgsteal_kswapd 0
>>      pgsteal_direct 0
>>      pgsteal_khugepaged 0
>>      pgsteal_proactive 1840
>>      pgsteal_anon 25
>>      pgsteal_file 1815
>>      # echo "64M swappiness=max" > /sys/devices/system/node/node0/reclaim
>>      # cat /proc/vmstat | grep pgsteal
>>      pgsteal_kswapd 0
>>      pgsteal_direct 0
>>      pgsteal_khugepaged 0
>>      pgsteal_proactive 18013
>>      pgsteal_anon 337
>>      pgsteal_file 17676
>>
>> After fix (swappiness=max honored, anon pages reclaimed as expected):
>>
>>      # cat /proc/vmstat | grep pgsteal
>>      pgsteal_kswapd 0
>>      pgsteal_direct 0
>>      pgsteal_khugepaged 0
>>      pgsteal_proactive 0
>>      pgsteal_anon 0
>>      pgsteal_file 0
>>      # echo "64M swappiness=max" > /sys/devices/system/node/node0/reclaim
>>      # cat /proc/vmstat | grep pgsteal
>>      pgsteal_kswapd 0
>>      pgsteal_direct 0
>>      pgsteal_khugepaged 0
>>      pgsteal_proactive 16283
>>      pgsteal_anon 16283
>>      pgsteal_file 0
>>
>> Fixes: 68cd9050d871 ("mm: add swappiness= arg to memory.reclaim")
>> Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
> 
> Reviewed-by: Barry Song <baohua@kernel.org>
> 
> As pointed out by Johannes, the Fixes tag should be
> b980077899ea.

Hi Johannes and Barry,

Thank you for your review. You are right, will update it.

-- 
Best regards
Ridong


