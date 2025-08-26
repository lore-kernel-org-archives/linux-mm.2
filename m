Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 77B22CA0EFA
	for <linux-mm@archiver.kernel.org>; Tue, 26 Aug 2025 10:12:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9972D8E00C3; Tue, 26 Aug 2025 06:12:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 96F248E00A8; Tue, 26 Aug 2025 06:12:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 85D868E00C3; Tue, 26 Aug 2025 06:12:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 6E9888E00A8
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 06:12:05 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E26721399DE
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 10:12:04 +0000 (UTC)
X-FDA: 83818492968.10.739AA6B
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf13.hostedemail.com (Postfix) with ESMTP id 474EC20008
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 10:12:02 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=VhHj3jLN;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=FHDP1PGK;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=FRnrljDd;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=V4uN9i5L;
	spf=pass (imf13.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756203122;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mmE9SEYGD2F3s4ICA+kzQeVmgCLv9DYvPz9hobyINKM=;
	b=aEm7GpoxcWiUS/rd7y0RLU/ofch3+Mk9ezIvXms2Ryp9RXTsdMGEvU6k4qo1xbhq05zqXS
	WZe4kyDlvNvok573adpdpNlXn8MlUUVTGm6S5ndr9TLlICftoAnwqv0BQIMdo2MVkYmFpS
	RIXXimonyTqc0Iu2H0bC8SIsKwZN9bs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756203122; a=rsa-sha256;
	cv=none;
	b=an6OcK5G3bTF7jaNAGND7tQHyRqmo+EejuMjA3YRn97dBoufz0YQ7zA2PvXPfCGhFEf3vw
	brIMBIaOBdqumoXxWu82x9c741NmTtOM69VjmU0Z2KxWh0RVMKRCXdPTBU23stXp6PE4pi
	zWw7Lw9Xg9dMNW6o7r1d/7Vz7IWEkq0=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=VhHj3jLN;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=FHDP1PGK;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=FRnrljDd;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=V4uN9i5L;
	spf=pass (imf13.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 9046421247;
	Tue, 26 Aug 2025 10:11:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1756203120; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=mmE9SEYGD2F3s4ICA+kzQeVmgCLv9DYvPz9hobyINKM=;
	b=VhHj3jLNuEqak9vRiJQLJ6BX9DyzonAYtK5MRWGohb4hE5GX0Q7SiSNgY11Ut5cj/ewkdJ
	emhk5DnwJ3yLgWnVCHnIFhuxZpydXz+u8dh/VMrBsxDb6m1qsAlJVCHBIhY2saM2zWGWH0
	GorKOvfsQe1RSvTwJOctsYrnNfCYne8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1756203120;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=mmE9SEYGD2F3s4ICA+kzQeVmgCLv9DYvPz9hobyINKM=;
	b=FHDP1PGKNaRRsS+6/d6SJSr3LF+WI/esNSSMgzpma4Jsb7d/q22LluKCPGrvKHz8olynIK
	1z4pc6DsSPmgJmCg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1756203119; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=mmE9SEYGD2F3s4ICA+kzQeVmgCLv9DYvPz9hobyINKM=;
	b=FRnrljDdXRC7Y1Iv20e7I3f40YzplWMV9xvdLO5CAGFAnH1f+5fgPZvPiYVDhK6k/udszh
	xyf/rhCxxyLa/STM0Pf/l4ETdvV3UjCHeGegHTuscrRjmsq9BZWeizMmgn7s1LwIP189Ya
	84Xx99nk12ymmmpySJCbZQcgbkEmlso=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1756203119;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=mmE9SEYGD2F3s4ICA+kzQeVmgCLv9DYvPz9hobyINKM=;
	b=V4uN9i5LFt9Hrvzh7qquMcNeebUF+sT//Dcz7rPSQOJhaBrR2WRiWP8ynwPQd43ZQB+Nop
	r1dk7l5CBPp0RoDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 7909513479;
	Tue, 26 Aug 2025 10:11:59 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id pawmHW+IrWikbwAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Tue, 26 Aug 2025 10:11:59 +0000
Message-ID: <c57e3da8-93b4-4c4a-8731-efafd382ddf1@suse.cz>
Date: Tue, 26 Aug 2025 12:11:59 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 09/14] mm, slub: skip percpu sheaves for remote object
 freeing
Content-Language: en-US
To: Harry Yoo <harry.yoo@oracle.com>
Cc: Suren Baghdasaryan <surenb@google.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Uladzislau Rezki <urezki@gmail.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, rcu@vger.kernel.org,
 maple-tree@lists.infradead.org
References: <20250723-slub-percpu-caches-v5-0-b792cd830f5d@suse.cz>
 <20250723-slub-percpu-caches-v5-9-b792cd830f5d@suse.cz>
 <aKvzAvgwUyZN5GC6@hyeyoo>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <aKvzAvgwUyZN5GC6@hyeyoo>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 474EC20008
X-Stat-Signature: 7ucm4ufc9xnkimdzcekawucezzeijwwh
X-Rspam-User: 
X-HE-Tag: 1756203122-890611
X-HE-Meta: U2FsdGVkX1//BI+/nJWv+DkFhDMVh9faFH37dMvw7m+Fwk+t6cclPuSiDfQDel7+aKtilc1GHcqSIDG96RAKVCBHOR1oWaEJsvc7ocEKXCy5LNOPbfzSG7UlNiOSams7b35tbbnt1XAY05fHF0z9YYKkm9lIsE7zV5zvxF4YEomlSww/rIj3CWS2oSOwbZzuxnURfwbSXW7oWP1IIWnAPDB4IphjWJR/s9GtbWOZCvEeFln1G+2MgIfomG/HGNnQHIy6HIKUWGVwiQDWOABuE6snQ888kT/C3hRT7NDvxiE2rAEDPo7HbgZsmcUqBvDc5JWM+HGNaipNp8LbkNo+jxVq/wxjWH3Xe6Rj9cD/S+lE7vLMnmvTj45vd9SY5zCjevPfI/fVPjyyGY5s+Ra6GD24gzsElL+udSTNs0R7Z8cxZnFEJMbUfFBuaj4JKTzOSQ6AuRhz9HbIDvXTovgRQA6WERb+zJp7LAqU61FreVgmVgceXnLUwvZqaDjJz5sAA6Sn19DqGcXtEaFrpaUW+JS0oTLYJGm7tyUMe6LVAiRx/yPIdv/u1GGOM/hUhjP1qHvsKevxWN87GOqCaljcpOT4jQ+lMzGNCK8DqXRDifIzlGaGNSK60Yp4LyhxwdKCW20CDA+rNs/Qxobw187uL2NNIbFY3dZJnc3houVxu2/KSLzDk52Uim+n40U/Dw02HOuPVc/iplxj/q3YJH5qozjuEvcLZ4PE53mmMR7qZywJ/J3lNf2kszmb2R8/SxFKuiJaNgm7LplliVB+YeNUo0nAftGi9F8XIaDRhPKw9QjxhMRKDTB0ppcK6djs26PZoaRmLcSoggFwVblcDHvO6s7MZc7OzzoMNknLTIYCnLlhXJnGIA7f1vHeMnAAxa5UnsDvi3Y91lxTx3rFjdr8i3+zr3MYbp2aEXgNVskTf7cxxewh9N8V2bbrlhY8eteCp0h2P7JSUBd8hct0X7K
 ioLHRyFx
 M0gd3X/i9b+NTaN+5fI+fbAdoFaKgFtTA8afjm/uBdP6ba6n3CAa6os3MUK6wlnwQ7MS7z8vUbB7CRtKJ/kAgIPI/3DuGWsSSkINhXr8y+V5IR/a/UTvxYZc6FLECPdeSLCetxXAy2pkagls3eWO1PZkQRRx3uN9hROx5qBqOx+vswWl44b41hm6Bt7tu1M7Lb+0Ho5Hb3JYGZ9ASuiXZ8EqabejLMr6hN53Iez6EEhtnIu6hASX7lfSvsd9WlTQCVywGgoeRpB9InbryTMPGf2ZHzgF+EjRMDQsT4+u6TlBh9gGvk5I8ubOmTktohyZIaXOlX984EoKYaqcb5GQI6u0QggliMw1GV8XD6JbKsK7VT5Juclv9wdRuztMCZjqrvpiZ2RDS2aiT3SA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/25/25 07:22, Harry Yoo wrote:
> On Wed, Jul 23, 2025 at 03:34:42PM +0200, Vlastimil Babka wrote:
>> Since we don't control the NUMA locality of objects in percpu sheaves,
>> allocations with node restrictions bypass them. Allocations without
>> restrictions may however still expect to get local objects with high
>> probability, and the introduction of sheaves can decrease it due to
>> freed object from a remote node ending up in percpu sheaves.
>> 
>> The fraction of such remote frees seems low (5% on an 8-node machine)
>> but it can be expected that some cache or workload specific corner cases
>> exist. We can either conclude that this is not a problem due to the low
>> fraction, or we can make remote frees bypass percpu sheaves and go
>> directly to their slabs. This will make the remote frees more expensive,
>> but if if's only a small fraction, most frees will still benefit from
>> the lower overhead of percpu sheaves.
>> 
>> This patch thus makes remote object freeing bypass percpu sheaves,
>> including bulk freeing, and kfree_rcu() via the rcu_free sheaf. However
>> it's not intended to be 100% guarantee that percpu sheaves will only
>> contain local objects. The refill from slabs does not provide that
>> guarantee in the first place, and there might be cpu migrations
>> happening when we need to unlock the local_lock. Avoiding all that could
>> be possible but complicated so we can leave it for later investigation
>> whether it would be worth it. It can be expected that the more selective
>> freeing will itself prevent accumulation of remote objects in percpu
>> sheaves so any such violations would have only short-term effects.
>> 
>> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
>> ---
>>  mm/slab_common.c |  7 +++++--
>>  mm/slub.c        | 42 ++++++++++++++++++++++++++++++++++++------
>>  2 files changed, 41 insertions(+), 8 deletions(-)
>> 
>> diff --git a/mm/slab_common.c b/mm/slab_common.c
>> index 2d806e02568532a1000fd3912db6978e945dcfa8..f466f68a5bd82030a987baf849a98154cd48ef23 100644
>> --- a/mm/slab_common.c
>> +++ b/mm/slab_common.c
>> @@ -1623,8 +1623,11 @@ static bool kfree_rcu_sheaf(void *obj)
>>  
>>  	slab = folio_slab(folio);
>>  	s = slab->slab_cache;
>> -	if (s->cpu_sheaves)
>> -		return __kfree_rcu_sheaf(s, obj);
>> +	if (s->cpu_sheaves) {
>> +		if (likely(!IS_ENABLED(CONFIG_NUMA) ||
>> +			   slab_nid(slab) == numa_node_id()))
>> +			return __kfree_rcu_sheaf(s, obj);
>> +	}
> 
> This should be numa_mem_id() to handle memory-less NUMA nodes as
> Christoph mentioned [1]?
> 
> I saw you addressed this in most of places but not this one.

Oops, right.
> With that addressed, please feel free to add:
> Reviewed-by: Harry Yoo <harry.yoo@oracle.com>

Thanks!

> [1] https://lore.kernel.org/linux-mm/c60ae681-6027-0626-8d4e-5833982bf1f0@gentwo.org
> 
>>  
>>  	return false;
>>  }
> 


