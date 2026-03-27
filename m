Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F3CDE10F2840
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 15:29:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2AE6A6B0092; Fri, 27 Mar 2026 11:29:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 25F246B0095; Fri, 27 Mar 2026 11:29:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 176256B0096; Fri, 27 Mar 2026 11:29:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 010D16B0092
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 11:29:00 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4E31E5AFAD
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 15:29:00 +0000 (UTC)
X-FDA: 84592226040.29.9707F4B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 58EAA80005
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 15:28:58 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Oja3Aqjs;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774625338;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uw9BC6dEpyU1wwqISopP8z9AFmKQMvNeseOrVz98ZXk=;
	b=rvvRIkpuhVXz3ljruA65RIFkvLdZXwGZME2840cNb7vL97y04fv06xjqioWVu5v0oqnLTe
	QjsiVebGmRrdQbeZ/P7IVqT0g/9xqn99FKQPePWO+riMYaBGxJxHUIg3/1wl1dsOnrgEpE
	1bYaDn0Uv9svPEipkd72ovrgMekEGL8=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Oja3Aqjs;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774625338; a=rsa-sha256;
	cv=none;
	b=sIl/jUg+tTRCd0sKIjB2aCmENOoCT8IJT6u3/Mg6GtLfvB+bWeYiRJB54Rje1Upmt7I8CS
	64xlXTgLmPaCfFXYZFMBS2By+oQKICJ//9kM/W5FOo+Zu0qOBuZZxWM1bwYMzAAJt4tty2
	5pMKIgw7oanIN91AvpzEVqLgqmYoG8Q=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3D18D44138;
	Fri, 27 Mar 2026 15:28:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDB11C19423;
	Fri, 27 Mar 2026 15:28:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774625337;
	bh=J2u6Jqx+FbvWSOw3ohUKrvyOEMc9S5FKrfLPN/czIfs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Oja3AqjsW5GP/6tkHzvlIoS8mBTOp9Du3zT1sP+oFAXBoPJgYZiZlPy6BKP1fIzG7
	 ZrbiiwArmjzPeGpRKKO+KX0PXwNzcbPI1lPt9g29p/qJs5I+gGw1wP8d6BE2g+2+TY
	 aRxl2P6GwL+f9MqYsqf6NmYZa7rro1x+uomRN9XcjvK0uce8+Pa7j3xjQNvV9W5lbH
	 R61z94B+48hGYhgEfqDoW0M01M1NHw9xJ1glcQAGo2buzoSBWJAAgdoMrylMFP42Qt
	 X5uE8II/tBHfCBwVaExiVDj65+4NI8EKHXQFGhQjPQgdiQWimBYxGxnNc1sRTTV/8N
	 8GY3xC5kpoImA==
Message-ID: <c8d9fba0-a001-42b0-b0e3-323235cb652b@kernel.org>
Date: Fri, 27 Mar 2026 16:28:53 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/memory_hotplug: maintain N_NORMAL_MEMORY during
 hotplug
To: Joshua Hahn <joshua.hahnjy@gmail.com>, Hao Li <hao.li@linux.dev>
Cc: osalvador@suse.de, akpm@linux-foundation.org, vbabka@suse.cz,
 harry.yoo@oracle.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-cxl@vger.kernel.org
References: <20260327143823.3063541-1-joshua.hahnjy@gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260327143823.3063541-1-joshua.hahnjy@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 58EAA80005
X-Stat-Signature: t1oy1ct6478dmzgyaekg8tjfqesg9aqr
X-Rspamd-Server: rspam06
X-HE-Tag: 1774625338-944263
X-HE-Meta: U2FsdGVkX19t/GEVs+dLta3HwJSXNbyixfWB8tVe9xxPBLkVc8P5m6jYKWrX6y/fmP89LWI2TUVxvxhAp4fial/ygzMXI65kTbrLQNpbI4BRxxXQe2xsHgUiSvoNUGYhgqK9IDjaQ6qVpwwUM1oD9+J1H1xsBAFnd0fXJz31x2TpjIrUZlB9cssjKsAntoz3AufP48L1GWpWUG8M6n1McgjHSEm1ieJrgQdRV6qFupuzExocSfx5FgJiA99NpimVmQPrZ1+WjrzmfaNX+N4Rv84W8kq+aD71N1heLzfCTK78nP6kP9g3N577yLYQi17pr3a76j9LZjw8v6W6HEfmWxotVML803eJNydE7qOFWKuWyQ+9DnHm1P3KRZ+Y7tA0k9KHHwkNGdN4acW8gEXxd4g8v4QcWM+krrPfNmM4KaNYbQlr6EN+zkAhXtP7HIfY/DXViGtsQjX8D/E4r1gaxBrOzLCAjBamo/gSfvAA5lD2/uqHSkv7IFCNG8FJ8xQa8kWCDzMwyHtcVGUOOWQQOapZwpb2TwBYcfA/Brc10c5FuLc39BLpqJbPRf2i2z8OQg8UR84Uz57b4OjxthZTMHMa1GL4IV5UiaPFDVqDmWgyDnvOhwZKmwgZGUtrfz9LV/tsUzHun1UM7aUZtbD10ZrUstjl9FemUcKWuh+4PXRXtUW7MIjYxx8zp4D/SI7m0e6pRtFzolxrjQ1slsfUi9/yBh51LAlx7+FTw15FmCPIwqPBmy1JwpidZlOnhqgFDl7ubka1gzxlzkbX6HEUH0ng70V0EaD/0r6jNmVuNlcSI5I+vILAwl6XV5QHPJsfD6kYUe98uMeNa2l4J3ycc5J/216nJEgHoxsa7PZeo/iqFRUE6nAqA+R7ALh13+I05z+3okSLk37rMEnuxmX9R8yco+91lx9mzNvGVCGFDXSmksElz44tTT4zmssLwBg+TmgiWgho7Xv6O1cD/Ex
 cd4qIPw+
 tXLA5J35cLad0oui8SwZqoVTtD+Rt5aLvQCTNj6Sse1o2OYihiYgB167SJs2BF37WpkE41spwgdJJYKVWOUEjp+F1sfs/GCCEY5z/9y0vPFV3bQvmSUDkEmkRWKBjTB2Nqyg5o7fmzIPZqfOqZ2U0dy0pFQw9NnSN0Ms9R3I0Edo08B9ZknWkBYeek/kwSZtcZFhm80acpEVnJZC91KHzC4YmkSYI9vYhXMXFfvqdu8mfJs9ZIVa9qovxArUQBrC0E3aHkqYq1sJD4PgPKZmidaLkMeLfQvSH9x6sua4DN2N51Gp2bdbZTTTFkMt0IbKuOpeK8KIMLQtzhWGTQDuQADGdXQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/27/26 15:38, Joshua Hahn wrote:
> On Fri, 27 Mar 2026 20:42:47 +0800 Hao Li <hao.li@linux.dev> wrote:
> 
> Hello Hao,
> 
> I hope you are doing well, thank you for the patch!
> 
>> N_NORMAL_MEMORY is initialized from zone population at boot, but memory
>> hotplug currently only updates N_MEMORY. As a result, a node that gains
>> normal memory via hotplug can remain invisible to users iterating over
>> N_NORMAL_MEMORY, while a node that loses its last normal memory can stay
>> incorrectly marked as such.
> 
> The second part feels more important than the second part, doing a quick
> glance through the code I can see a few N_NORMAL_MEMORY iterators that
> are in some hot paths like shrink_memcg. Iterating over nodes that don't
> contain any NORMAL memory seems like an inefficiency rather than a bug
> though. 
> 
>> Restore N_NORMAL_MEMORY maintenance directly in online_pages() and
>> offline_pages(). Set the bit when a node that currently lacks normal
>> memory onlines pages into a zone <= ZONE_NORMAL, and clear it when
>> offlining removes the last present pages from zones <= ZONE_NORMAL.
>>
>> This restores the intended semantics without bringing back the old
>> status_change_nid_normal notifier plumbing which was removed in
>> 8d2882a8edb8.
>>
>> Current users that benefit include list_lru, zswap, nfsd filecache,
>> hugetlb_cgroup, and has_normal_memory sysfs reporting.
>>
>> Signed-off-by: Hao Li <hao.li@linux.dev>
>> ---
>>
>> This patch also prepares for a subsequent SLUB change that makes
>> can_free_to_pcs() rely on N_NORMAL_MEMORY to decide whether an object can be
>> freed to the sheaf.
>>
>> ---
>>  mm/memory_hotplug.c | 22 ++++++++++++++++++++++
>>  1 file changed, 22 insertions(+)
>>
>> diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
>> index bc805029da51..5498744aa1f1 100644
>> --- a/mm/memory_hotplug.c
>> +++ b/mm/memory_hotplug.c
>> @@ -1155,6 +1155,7 @@ int online_pages(unsigned long pfn, unsigned long nr_pages,
>>  	int need_zonelists_rebuild = 0;
>>  	unsigned long flags;
>>  	int ret;
>> +	bool need_set_normal_memory = false;
>>  
>>  	/*
>>  	 * {on,off}lining is constrained to full memory sections (or more
>> @@ -1180,6 +1181,9 @@ int online_pages(unsigned long pfn, unsigned long nr_pages,
>>  		if (ret)
>>  			goto failed_addition;
>>  	}
>> +	/* Adding normal memory to the node for the first time */
>> +	if (!node_state(nid, N_NORMAL_MEMORY) && zone_idx(zone) <= ZONE_NORMAL)
>> +		need_set_normal_memory = true;
>>  
>>  	ret = memory_notify(MEM_GOING_ONLINE, &mem_arg);
>>  	ret = notifier_to_errno(ret);
>> @@ -1209,6 +1213,8 @@ int online_pages(unsigned long pfn, unsigned long nr_pages,
>>  
>>  	if (node_arg.nid >= 0)
>>  		node_set_state(nid, N_MEMORY);
>> +	if (need_set_normal_memory)
>> +		node_set_state(nid, N_NORMAL_MEMORY);
>>  	if (need_zonelists_rebuild)
>>  		build_all_zonelists(NULL);
> 
> Do we need the flag here? As far as I can tell, we can just skip this and just
> directly check whether this is the first normal memory we are adding to the
> node here and set the bit. Then we can remove the flag and the extraneous
> check. We won't do any notifier work so I think it should be OK.

I assume you simply mean:


if (zone_idx(zone) <= ZONE_NORMAL && !node_state(nid, N_NORMAL_MEMORY))
	node_set_state(nid, N_NORMAL_MEMORY);

That looks m uch better!

> 
>> @@ -1908,6 +1914,9 @@ int offline_pages(unsigned long start_pfn, unsigned long nr_pages,
>>  	unsigned long flags;
>>  	char *reason;
>>  	int ret;
>> +	bool need_clear_normal_memory = false;
>> +	unsigned long node_normal_pages = 0;
>> +	enum zone_type zt;
>>  
>>  	/*
>>  	 * {on,off}lining is constrained to full memory sections (or more
>> @@ -1977,6 +1986,13 @@ int offline_pages(unsigned long start_pfn, unsigned long nr_pages,
>>  			goto failed_removal_isolated;
>>  		}
>>  	}
>> +	/*
>> +	 * Check whether this operation removes the node's last normal memory.
>> +	 */
>> +	for (zt = 0; zt <= ZONE_NORMAL; zt++)
>> +		node_normal_pages += pgdat->node_zones[zt].present_pages;
>> +	if (nr_pages >= node_normal_pages && zone_idx(zone) <= ZONE_NORMAL)
>> +		need_clear_normal_memory = true;
>>  
>>  	ret = memory_notify(MEM_GOING_OFFLINE, &mem_arg);
>>  	ret = notifier_to_errno(ret);
>> @@ -2055,6 +2071,12 @@ int offline_pages(unsigned long start_pfn, unsigned long nr_pages,
>>  	/* reinitialise watermarks and update pcp limits */
>>  	init_per_zone_wmark_min();
> 
> Same here, couldn't we just iterate through the paegs here and accumulate
> node_normal_pages and clear the memory here? We can get rid of the bool and
> also keep node_normal_pages defined inside an if (zone_idx(zone) <= ZONE_NORMAL)
> check as well.

Right, all we have to do is check for remaining present_pages in one of
the nodes IIUC.

-- 
Cheers,

David

