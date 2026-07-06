Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DFC51C43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 13:40:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9E1076B00BF; Mon,  6 Jul 2026 09:40:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 96A1C6B00C2; Mon,  6 Jul 2026 09:40:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 85A7E6B00C5; Mon,  6 Jul 2026 09:40:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 549BE6B00BF
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 09:40:49 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D7DB61A040B
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 13:40:48 +0000 (UTC)
X-FDA: 84958462176.12.D337B67
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 118A210000A
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 13:40:46 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=j5+hOnlu;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783345247;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KjVP9wNRwuElcHLW8PNyHdq1NQan+oEfxG1mL9o1kI0=;
	b=HKq97GJiRIcg4WxRwuU8Ei0dTgcoZELLUrspBIvG3VhYS/7zhrvliklzVUBd/f+t54kmO8
	48DzCNPI+UQqndnewZNGDGQkBq+jaOJxDvK+tvFv1yxIEpim27xou0HY8Dp5F9bs2ELLuu
	OiI2R6tgj380rLhojz9e+61gRIZ1RRU=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=j5+hOnlu;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783345247;
	b=Nh5wVdhubdOcX7iFe3Z9BsoIImCk9/hLdpo9LNmyPoR8pfHnhiyAv6k/DtR8Ive0Wig/mb
	3zr73nn/9tgHaQuHIHvjxQI/BjOci5HjO7SOckf+m2vwKcN1v2gDd46YMh9E0FWtknyUYw
	8KVRXCckaIXcG40Hvnzwi6JjHbqHaCQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4636E43749;
	Mon,  6 Jul 2026 13:40:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F3711F000E9;
	Mon,  6 Jul 2026 13:40:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783345246;
	bh=KjVP9wNRwuElcHLW8PNyHdq1NQan+oEfxG1mL9o1kI0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=j5+hOnlumBNxZ9I7ESOV0D4gxMh4f7CscUsAtv8E1yh4m9E9Eh3OEKB+BLEhWA5hk
	 745oqBYDgZE13ir5RuW9pg0uf+fQb0iBXgbtykTpHJwaK2Gu7Mi28c7MK8hdTjRQ3M
	 hpPhDKT9Lsck9y/zv650B2eRpvr/hVkygauTYAbf2PvJAYAAAsHxf0ho5uNX0KmOo3
	 oCkF3eAT53iszNkLB9wciHheaN8bJMtTTXtj0LrBnMExxzGdAairyX/063Ouj3vdcb
	 PjYhag5iFiOuSVyhMEd6phJQGU6VD3VZQK9gS1kYhQT4DImguqI9vJ32syvQL6cYkT
	 Db8nxuq3AxTrg==
Message-ID: <6ef49a9f-af0c-4bce-8402-16926424ea7a@kernel.org>
Date: Mon, 6 Jul 2026 15:40:39 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] fs/proc/task_mmu: count KSM-placed zero pages in smaps
To: Jinjiang Tu <tujinjiang@huawei.com>, akpm@linux-foundation.org,
 liam@infradead.org, ljs@kernel.org, vbabka@kernel.org, jannh@google.com,
 pfalcato@suse.de, xu.xin16@zte.com.cn, chengming.zhou@linux.dev,
 linux-mm@kvack.org, linux-fsdevel@vger.kernel.org
Cc: wangkefeng.wang@huawei.com, sunnanyong@huawei.com
References: <20260706121323.1149847-1-tujinjiang@huawei.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260706121323.1149847-1-tujinjiang@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 118A210000A
X-Stat-Signature: icbbd4in8bktaqnuaj4ycqrhdoc3uqpz
X-Rspam-User: 
X-HE-Tag: 1783345246-35852
X-HE-Meta: U2FsdGVkX1+pt/dNloPabcnHthFLKIVmWvHK/5iXdt9b6zMOogNmBBWR/tt+EDJNz+hHRjHULsj/qOw9yq6WMMx7YYKsaqIf0EhfLMkQeHK/N7gY4lZmBhFnbLMzjB1u4wcZgsrQWwwbgEBwNyThgyZSMgf0Aqqv4CTXf1vSnQ1x8bzl9ng3+Cwqbw146CMZuIJMNRBw4/HGcF6fjjI+l3SlAYakenrg8ZW49CnyqnKQ2egJ69VHbyEu+U+oIOr3UsKPfohQTDFRNehOJmEzVDdE6xySw8x/sPndXWcecg9CJcbhgnDZ1zX7021DWj6Z+w/fuigRaf6VmmakPTnnJYY0jFhaQCIgZ2mh/oraVJa2kcD2iri7m14h6jyo0uoeC48eZOW+TjyHXANSJLyDAY7AiDnJ11hWFu/F1b69bih0Xyd5iZppMRj+rAGawTW0HydzbHCt3LuPNVmBiskgvUVjRusrJjuOAvT3cetLFznM2+1LBjWO41/KQnzzttEV+yGGASEQfzlbCPJ2isEY4P1fHBVSVTOzkgTjV07MBXoECIhEhD3Q4HSunBefTpUP3CfIUlmeOb1K3AedKUklU3A4gA3hqYw2jQ5KZgQ9WYr7W++q4pTny7URpveJw6H7O4CFUYTAinfDPgGfOv/FUDPCsFg+OXSeUNOxULpdy16FJw3RLpbaOkWmQX8Fg7rmOWfKtX8BtDjubLtwdaq+jAtU13oyGzYcGwnB0ThbrTYqtij+BrDpczo9dFDpJPW8cqMVcPBc8xkoRnvlTeTbQQPnEagu8LHHZ7wTdjaIFwtqc5pSW6gQQmVxs4O6et7oYWiv29yEDL92UORH5BNkHp1ZXO0uWDg1x2B3mvtTIpLinDYnmoOn0UmweqIdesv8BGcE3rkvlNTIiHPOYExCf6wm6iqZ1RxZjNErYjwbQ1MeJ6j43ughutk6a9+Sr2yKbNYPm1kNWT6UCsTPRd1
 jwmqp1R6
 SH8k2qR0TrvZPnrtg3x7uNWo7jIVKAi6EzzV5PfeT2iG8EM8mpOEr2veqpcgT/P3xIKFGfvJBwFFQHVpdxvzGsW27Xzy4++j1bu3WdCvcN+WoBFity6OIyS/x4TxOE3y8PrWjyMA37G8/Wp4biRaEVMekQ8unYRu4D7utlJi6VndIvMQikCYyir1HFrPvcghMXs8SopGKg3m6204Ywy4Gf34PEthGqjY5TgkOITM1gZXvzRdWq5h3Eji4u5hhFIr0brFkuk57mLurm/0gSds/cMVPtvsuaD5SBPPPrILEi9HxfYc5zNPuYAUFuZiq1qs3pri27TRXspC4k9I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/6/26 14:13, Jinjiang Tu wrote:
> When KSM deduplicates a page to the kernel zero page (i.e. when
> /sys/kernel/mm/ksm/use_zero_pages=1), it places a zero PTE with the dirty
> bit set. vm_normal_page() returns NULL for such PTEs, so smaps_pte_entry()
> bails out before reaching smaps_account() and these pages are never counted
> into mss->ksm. As a result /proc/<pid>/smaps and smaps_rollup report a KSM
> value of 0 even though the region is fully merged.
> 
> Count KSM-placed zero pages directly in smaps_pte_entry() using
> is_ksm_zero_pte().

Hm.

We do expose "ksm_zero_pages" in /proc/<pid>/ksm_stat for calculating the KSM
profit.

Why would we want to expose it here as KSM pages?

An application will notice the difference between "zeropage enabled vs.
disabled" either way because we'll also not account zerpages towards e.g.,
"Anonymous".

So faking that something consumes memory when it actually doesn't consume memory
is wrong?

-- 
Cheers,

David

