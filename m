Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 588A6FB5181
	for <linux-mm@archiver.kernel.org>; Tue,  7 Apr 2026 02:13:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 845A66B0088; Mon,  6 Apr 2026 22:13:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F7016B0089; Mon,  6 Apr 2026 22:13:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 70C326B008A; Mon,  6 Apr 2026 22:13:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 6094E6B0088
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 22:13:12 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 01E331A0598
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 02:13:11 +0000 (UTC)
X-FDA: 84630137424.11.DEF9BF2
Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	by imf07.hostedemail.com (Postfix) with ESMTP id 25D0E4000B
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 02:13:09 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=p7s78Uy1;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf07.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.180 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775527990; a=rsa-sha256;
	cv=none;
	b=c4ZDcbRyMytkd9fhKb7b3/gpq8pl1sGF2/mZFZX5zWI58j8sxHmuuWbfrBqOyRVjCylzUB
	QZk4+aIQN03ptKtnzHmA82iab9B3g91Z0+Bk1kBa+XJUU9bLV1AcmDtxOjrdy/pq0TInJw
	/DOisSncufdkrbKFAPfuycs+aYvSujQ=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=p7s78Uy1;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf07.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.180 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775527990;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PSDM3Xa9OKTpOqUyJXXJL/N9oKWp7CgjmMDNFGNadDU=;
	b=z/H+VVw73tCDjqt+PU728tJOOzkiigPCLQfBdiVB7fQK05/6RBK4UnfB9odRzRTCDu1ovW
	IXTNKacXoaeECDh0BmXePc0SVG76PU9hacEUynsH6XZnLoLqgvzlHC91ygXj4PAaG90NxT
	SCvXkuduwxMtuZ5lKmPOBif2N9Qh/Uc=
Message-ID: <bb35a69a-5be9-45f5-a557-1902487a1bc2@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1775527986;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PSDM3Xa9OKTpOqUyJXXJL/N9oKWp7CgjmMDNFGNadDU=;
	b=p7s78Uy1xvl6dGGM0H/S2+3LMU53v9/HniExRR/oiOtc7e6yjcBCt4BY01g7CRLXeb2hVg
	zDYw4oa6DyVw23A/EnX5JQIwIHy66z+3poLCY2j74zgp0p/h3vc+2kxmDji382FVGeEmpO
	8CGpM6DUnj+5UagK8/p3VNxy1WNSsMQ=
Date: Tue, 7 Apr 2026 10:12:30 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v6 32/33] mm: memcontrol: eliminate the problem of dying
 memory cgroup for LRU folios
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: hannes@cmpxchg.org, hughd@google.com, mhocko@suse.com,
 roman.gushchin@linux.dev, shakeel.butt@linux.dev, muchun.song@linux.dev,
 david@kernel.org, lorenzo.stoakes@oracle.com, ziy@nvidia.com,
 harry.yoo@oracle.com, yosry.ahmed@linux.dev, imran.f.khan@oracle.com,
 kamalesh.babulal@oracle.com, axelrasmussen@google.com, yuanchu@google.com,
 weixugc@google.com, chenridong@huaweicloud.com, mkoutny@suse.com,
 akpm@linux-foundation.org, hamzamahfooz@linux.microsoft.com,
 apais@linux.microsoft.com, lance.yang@linux.dev, bhe@redhat.com,
 usamaarif642@gmail.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 cgroups@vger.kernel.org, Muchun Song <songmuchun@bytedance.com>,
 Qi Zheng <zhengqi.arch@bytedance.com>
References: <20260406181116.4053796-1-joshua.hahnjy@gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <20260406181116.4053796-1-joshua.hahnjy@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: sbnkkce54uwm1jb7hs9epybeny14khe3
X-Rspamd-Queue-Id: 25D0E4000B
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1775527989-580127
X-HE-Meta: U2FsdGVkX1+AKlUuTCQQEy3ChommKmdniQgdsVlou2ycgAMJGdWYQQYIcGZK6psJQLPZxrfohZmFMk3VFIERgvetaDM737GuJ2/22oVhS5JdMQDERtogaiehI+O0zUeHHqLnYvft+D2knMGXaAyY3ZrQIFOrriDSchd8rzLwrN/VeOVWyAuTDr9t1aKzDpo+kCBOL2CBbmSak2UWA+3Xbb/ZGO6gnz6jrjXPnYZZ1U5hqIGYpB9caFsXqBesUxSR/WMqJAljohRAJPDAOq8+WEa8mPAJbQ19zhQoTjPo+wYyDufidWBqK/O5Crn/yzxOiTGyTwOoqpgWQaxaVrFUKXiUk1Q8+HPMFGMSls5zbSnrOnVgqWqTFKLrLL0mFxLyeQ4hYiVGeluGSO+yIkEzGIKHD2aJwukSFDlsj6Qevc88WGr/ZFzNxyvMmQ5Aeb9QYvLcKyjQVoH4BAGtkG+TdVLH7NOsCzq4/4+26jW6zERau1/AlxAikvpnhNB5CCKXzAgNbk5AjnvUB/qPZqGSCSNnf0cdeql2x8smrsPneinhmQC9cijUKPcwmckThQpSj+YiVKux1paf2jki1N8A8pFONPI5PVLP8zeG5jAlqqFJDbm9WD2a5gAXaX3u2xAIXHRb7oxU2s568FavMzksfCH2rUz5s7EW6/HKOcg83UgfxsHruh1j5or0bbrCsSwsp7lL1w+9dhD5v1RUo/aIdayqDlvaNfcfRHd7bu49amKbS2q638BUc98yxy9iy1AkfNxG753Ze8SD9sFx0T21sIXTgogjhHN3F/XV5h9PRJwNbji/0ajsuA/4tw/wFz+GwyQaxsyWJdXZJU5PVvAN5zJfm7nIcXSiDBIDO+6bpiwVA9zxH7rDLSogqERfEVy/Rn4M8hl3qAHk7zk7BXteVT4jUheib388OOAcxZMowUhKJInEbWSoOUE5yKUkWB3FD3xu8vGM+eh0wUwRpBl
 BOnMZ4R7
 8nuyxR2uXxVprrhExquBzLwix9HNt6eOFUNyLoo4WBtKMmFEyFsQBR/rYGFq+8ZhxWbZubKBZtWI5qmaJzHTOOiXeCGDfQdmi2cMaCVmG1JQj3HNuA+0hcwXgGGi84D/oeu39zkue9nJvFWDNVsPG/cVsq+aYuBhod4KqWYQRpZi3hDYCPkt/Jha8pj6mWiW60AQsuYFxC+Jf6tWwP5XSZzt0TIcwi54F1028A7aXQK9cifr6sJGLYoyWHWZx4DWqIRzR9By2jNMIgqU6oH13taG9ks/5EweoReZAYEP0MHJhAYf6VRaVZMNKsClMiDsSbZLQvCNXwZD6iMMRVV8LWnIiQw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 4/7/26 2:11 AM, Joshua Hahn wrote:
> On Thu,  5 Mar 2026 19:52:50 +0800 Qi Zheng <qi.zheng@linux.dev> wrote:
> 
>> From: Muchun Song <songmuchun@bytedance.com>
>>
>> Now that everything is set up, switch folio->memcg_data pointers to
>> objcgs, update the accessors, and execute reparenting on cgroup death.
>>
>> Finally, folio->memcg_data of LRU folios and kmem folios will always
>> point to an object cgroup pointer. The folio->memcg_data of slab
>> folios will point to an vector of object cgroups.
>>
>> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
>> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
>> Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
>> ---
> 
> Hello Qi, thank you for this series!
> 
>>   static void memcg_online_kmem(struct mem_cgroup *memcg)
>> @@ -4949,16 +4985,20 @@ void mem_cgroup_calculate_protection(struct mem_cgroup *root,
>>   static int charge_memcg(struct folio *folio, struct mem_cgroup *memcg,
>>   			gfp_t gfp)
>>   {
>> -	int ret;
>> -
>> -	ret = try_charge(memcg, gfp, folio_nr_pages(folio));
> 
> While developing on top of mm-new I found that this was the last caller of
> try_charge(). I was thinking that it might be a nice opportunity to just

Yeah, we're already aware of this.

> remove the definition of try_charge() as well, maybe as a clean up patch
> at the end of the series.

Will send a separate cleanup patch later.

Thanks,
Qi




