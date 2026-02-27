Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EA97AFD9E34
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 06:35:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0EF7B6B0088; Fri, 27 Feb 2026 01:35:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E6106B008A; Fri, 27 Feb 2026 01:35:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EDF566B0089; Fri, 27 Feb 2026 01:35:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D41306B0005
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 01:35:12 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7AE071A0543
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 06:35:12 +0000 (UTC)
X-FDA: 84489274464.16.708D122
Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	by imf02.hostedemail.com (Postfix) with ESMTP id ADC9E80003
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 06:35:10 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=oNbNFsGT;
	spf=pass (imf02.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772174110;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hREgDO/GK7fxVC17BP0cTvROrp7Ox8m3TEHSHQrQs4c=;
	b=sbyH16hARtP9dpNO3WGmgNMongp1v5xA2KAG0Wof1mVyPPZeM2KJiAaG/3ljkZIY5ss4GU
	3C1sQiTvxKnaWajrH6VNjXPPIG3MyTPpA3IwAA5eYOTtZc97QU3KrCrkFiVeLuxmMWj5H8
	wQtBqseFlMh96N18GOwJ6FYnw9xmu9Q=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772174110; a=rsa-sha256;
	cv=none;
	b=NL7xnbrIUSyb0zRP1jy/Nr7BBRmfN+iOoOxscJZHT0TEDK2bBXDSvK6xANRksCbw6IGeus
	HYYy2WoydpT/qYwhcezJGi7v5TdiAQpnaHEQ9duRPfw9G73GtbH10gcTpcN0ESZZlTkSTf
	1R0AlqR3tYDyRswqAVmVry9UifQgPzw=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=oNbNFsGT;
	spf=pass (imf02.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <42d6bf96-21e8-4fb9-8ab9-5487d55a6969@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772174108;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hREgDO/GK7fxVC17BP0cTvROrp7Ox8m3TEHSHQrQs4c=;
	b=oNbNFsGTVjpV6/ijMYJ698tZxULUU3RWR3ZSUopIVvclQd+ODAgTXTQF2HQ/R8Db/ytri0
	Q26gOTbCPNsPOXNXMP6CFMvTZu0Jvyaouz7i5nLZKwrGWkoKrn1f2sQiJ4Mdwx8VSMtZrJ
	UFp1KtBLBWFlpE/p6YeUxCbErwtvnaw=
Date: Fri, 27 Feb 2026 14:34:49 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v5 update 30/32] mm: memcontrol: convert objcg to be
 per-memcg per-node type
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: hannes@cmpxchg.org, hughd@google.com, mhocko@suse.com,
 roman.gushchin@linux.dev, muchun.song@linux.dev, david@kernel.org,
 lorenzo.stoakes@oracle.com, ziy@nvidia.com, harry.yoo@oracle.com,
 yosry.ahmed@linux.dev, imran.f.khan@oracle.com, kamalesh.babulal@oracle.com,
 axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
 chenridong@huaweicloud.com, mkoutny@suse.com, akpm@linux-foundation.org,
 hamzamahfooz@linux.microsoft.com, apais@linux.microsoft.com,
 lance.yang@linux.dev, bhe@redhat.com, usamaarif642@gmail.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
 Qi Zheng <zhengqi.arch@bytedance.com>
References: <0f915487ffc653cf6ea19335c21c01aa06004641.1772005110.git.zhengqi.arch@bytedance.com>
 <20260225094456.74145-1-qi.zheng@linux.dev> <aaCmpSNRZU1wIYxq@linux.dev>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <aaCmpSNRZU1wIYxq@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: ADC9E80003
X-Stat-Signature: yxnwu9gz1tm6x16d91gpstyo91xurpn9
X-Rspam-User: 
X-HE-Tag: 1772174110-605393
X-HE-Meta: U2FsdGVkX19klF9BAQdDaKCLrAXFgBDZFQqEH+3QgwUCDDBYklJH9yP4K7uAeRh72Zh9Bw9gCg5Gyi4Wh/VNq1alRXvycV4oDLgOIdek09l9Aai4JGhLPMQNUH+TVNxQGwxgUTmIvbt4pkhJOFTA6gnFYdqzN95JgE9deJdKnHYayB1jBvp2L/iACuhS6riaO8NM/QrPTlyCcx0WOZeDO3Yyy8ri7SKyakbcF2QjMK28qn8uRygFZzMkjV7tJIu2bYxXstzay8pB2IlzGH6siD0dwAkj480btA+h1jqog0KcCwgprnKAFqLi/SNljMH8au+++B3ApJJeuf4k/jKSeCwsemHxleOWlnzEB83GqifpAjjMn09koYROxgjR/kzp79onD2GpoefLs1HcgiYBt8v3jkk1QWMok/V0rFravmC4ZIdfZURTMURcd7VpWRhzPlNd3WAVhka75ilMvGJosNc8AUaOl1pbNyIebh4zaE6g1Ibr9ExIxiOY3EJvij6o4PR0VzZN4DbOjxWpJAV4mMC0TeGyE/yTX++DRb4XjdSv7+S8LRhQFoKPCb2zRzAfKCEG+A8tQvpi4dcrREbpSKlH9G8ly1TZ6BGyrznLr61J6ZuLwGhbgDDsRqsztQ43FA8Eqpd6Wkd8qAaaxNIaFP5u8JH6fvOg7i+EoT32krJawKl+sY/dDaK0eao+RrvEzDhS8CAI7BleIoQ4gE70MlNLIOTMGMH6uoYfHpdiwe+eyl7L/jOLlrgKAZhC2zV37lXJ/IZC9mgOc+zfIo3lFblUhvHLofvuECpFFupu5+E7dKj7eYUZI6Oo3WrsLHO3Qysoj/BI/FOshjAOvq8kvOLtWyPwOBY36J7nABS9HuR0kd0ucaIuvWnMaQW6uBbuqsVxeyML3ud7Yx0WXzrscWtBF8NlODkkm6hK2Eq20ju9APLo8MrNEeoQOOgmSVzDc10Z9NfZrwVwVANNLpJ
 1J7R9K3q
 gNt5CsjpRXuEccaUWCvegm3/y87j3XW29Nc3oUZ1BUpLr3+4KCRCqUdvXj6CNIMzs+xS5HrTlCPLi++1ZsZepPBpKJUNJnhvxefbwD6aXFJ1pMxXxqWrTvD0HTVWn7k09Ja/qyIHEP4cJXAfMQmnZZUJUQ6HFUVLxyXQTVtXvQhst+g7rKp2HDxvmtpZlbRNQo8Wka4eyP0lIe52JAHuvWMExG1TJ6yRsvdpeZjqUqjW56zi1iU2NAoGagxkj1QB/a43XjMiLHQi1Ov3QRhUbQm/lsYWCK0BOxtKW
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2/27/26 4:05 AM, Shakeel Butt wrote:
> On Wed, Feb 25, 2026 at 05:44:56PM +0800, Qi Zheng wrote:
>> From: Qi Zheng <zhengqi.arch@bytedance.com>
>>
>> Convert objcg to be per-memcg per-node type, so that when reparent LRU
>> folios later, we can hold the lru lock at the node level, thus avoiding
>> holding too many lru locks at once.
>>
>> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
>> ---
>> changlog:
>>   - fix a missing root_obj_cgroup conversion and completely delete
>>     root_obj_cgroup.
>>
> 
> After this patch, do we care that page/folio/slab points to the objcg of the
> same node as them for a given memcg?

Maybe not. My only concern is whether the kernel has a way of
determining whether two folios belong to the same memcg by checking if
the objcg pointers are equal. If so, it needs to be changed to check if
objcg->memcg are equal.

> 


