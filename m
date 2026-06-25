Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 54426CDB47F
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 06:11:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2AA856B00A4; Thu, 25 Jun 2026 02:11:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 25AD46B00A5; Thu, 25 Jun 2026 02:11:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 171086B00A6; Thu, 25 Jun 2026 02:11:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E78B36B00A4
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 02:11:47 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5C79E1405D7
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 06:11:47 +0000 (UTC)
X-FDA: 84917413854.20.0226E71
Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	by imf26.hostedemail.com (Postfix) with ESMTP id 6FDCE140003
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 06:11:45 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=iPGBHwrr;
	spf=pass (imf26.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.185 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782367905;
	b=bwdLH2zZV/rKdKjclkclHrWBTNeZNqHzpJ2yEQmDgd2K7f1XD2yMne5hXES5PSzUFMGwGa
	Vs67Ov/y7fsO15rBT5aoLhXeZDdb13EaeabE/Tbdyyl9Ycg42Et9VC/VCGsi1Gh+CbmoNu
	y1rZTW/UKkpvY6xHHtC5dOTzrxSOYH4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782367905;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xUSTBB1mth+fzw/4QWCYM0WAsrU6UvEDP/rElXqwnzw=;
	b=Qs5cyYqABTZUg9tEfpsOC0bc2vbwllaJg2Mk49dsvkjsVxIPvaOxt27GTUmbBVJScjhyZO
	N8QUhJ62jTHUO3MDLxNBWwA0nfJ7t1GW/avAj/ytAUig675w2TPGu/KKuoBNPhrJBNlbJj
	XeT84LpP7GvpVRsto4cr4S73OLPsIBg=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=iPGBHwrr;
	spf=pass (imf26.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.185 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <f18bf1b1-ccf7-4d77-9389-07311d2d1613@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782367902;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xUSTBB1mth+fzw/4QWCYM0WAsrU6UvEDP/rElXqwnzw=;
	b=iPGBHwrrH9Djk0Ix8CjAt1/PVSBSALGaCFIEyhK2JpKUjjK5oqL4Kvv49azNzeQj1p7opV
	AvvGRxc4A7tCrGXQeM9eUrYiqoM4c3Oxf9OY2OwHdnLR5DDX1qI4+bWRL0tkPtH6eDuH9m
	urj5++hBAxg8aHMFtF4rsCCPvANwrXM=
Date: Thu, 25 Jun 2026 14:11:22 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v2] mm: mglru: fix stale batch updates after memcg
 reparenting
To: Harry Yoo <harry@kernel.org>, akpm@linux-foundation.org,
 david@kernel.org, kasong@tencent.com, shakeel.butt@linux.dev,
 baohua@kernel.org, axelrasmussen@google.com, yuanchu@google.com,
 weixugc@google.com, hannes@cmpxchg.org, muchun.song@linux.dev,
 peiyang_he@smail.nju.edu.cn, mhocko@kernel.org, roman.gushchin@linux.dev,
 ljs@kernel.org
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Qi Zheng <zhengqi.arch@bytedance.com>, stable@vger.kernel.org
References: <20260623024237.45990-1-qi.zheng@linux.dev>
 <e74b0808-3bcc-414d-a037-41e479210cc0@kernel.org>
 <d97128c0-7d89-4b5c-b891-84f9af702fee@linux.dev>
 <8a76aefd-629c-41f3-b365-aefd4cc1411e@kernel.org>
 <7946da94-dc1d-4cf2-986e-466c378665b6@linux.dev>
 <dfe5d773-2992-448b-a6cb-ef633714a08f@kernel.org>
 <1d638906-6d64-4e57-a181-4b77683652b5@linux.dev>
 <b5c85cea-5daa-4690-ac41-a6f5aebd1555@kernel.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <b5c85cea-5daa-4690-ac41-a6f5aebd1555@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 6FDCE140003
X-Stat-Signature: cutwac3p8jeik1aros166utcjck3dj84
X-HE-Tag: 1782367905-808195
X-HE-Meta: U2FsdGVkX18y9626Mwda1O3X3MEmJ+MXaMMr4uA0kUDUhi2f/9dUI6WjQzuwMKAHg1KcgphjoULlarA4PRw1eu4NmeJ0dgnb9MAQh0FiFLDL3JvkK30XcJlpiAIrfP+OC6JBM1/d5omTwrC8s8gYxkyvIlnefPpchV3DOuxZGHTOp6HEQS6/NYIuMNLL8deNA+GYg8DznpbwZJCdUvBRiPbiCxzWL8075v2E0L52EP1dlFQAWYq07hT/fyJ1EL/QqFwGh4O1UE3y05Z33nzBAKc8E5Zdf68/gtHig+InuCh8NJUHAuRZWTQDlXsyNs0we7O3xFiytm9MOAIZYNW4dXhne61yK21rh4ExeyPsA7KNGZ08jFzghsxPSNE7s7C62uO2IM18JviRMAh9yMFysbyvPrlH4i+NzmG9pM0WWGluVQ4FVrdpS6BzI3e4thDgGqU3D4sUwMd5fK7aXNjAkZs5W3Oav8pn7wGMdm0q/TK0lxZuhodhQJcZkA6mYjcJ1WqpbVkIQ6Y/pIdy0XVz07PO1nYuFvAcCYw/caPeKmxABPn2dFqY30FkJY8z0kR25+cZNFJT+y8Pzb+uqQFN5ymnn0ivBRVC4QBkIXMadTgNEsFAeMhkG/J04XWw2ZkRelTwDLNkxcFciIzj4aCLCXQhFMe5YRmJto0rhvciVaPPMzEUf0E4f7c0ubhFrtz46f/WqYv1QAxKs/iFoZ2slICSNXsA6sLOZJUohcGDVfgXyB+7P7CP6yiKNZFrl4Ivbmk0TG5udbRZpDmL1Aoeoy24Y8czk80yAFX3a7z/YbWkzvFQJ7LN+A5W1ZqedKbNEK+VJKJ3Iawv5kKzIsZpApCJyZWThf7POJse2DsVHJaDeijUicgB5YDpvLV4xcwL96Ylp0Xy/ep30WrKO+B/nXRGWRaMGr3k7GBTfwLDdzI0O4cikI+MhFWROcfvG+CF8BaLTYGlZxv/Na99JEA
 NSO+03PZ
 GRp/q7Po+pTav6mM+QsOSugWfAkpPQ7AMSs102Vh8/+TKH0cjBNwmAh7fbNw7XaYlSmDIirVpdgZAVYAwazb3gTHaZUHXtaF+giIchkrR+DLutpXKpsIM4xiU352Of6F2/C/p+wHqX6r9JX2rjbL5BIEPgr86+saEc7U3PmluVbLm++q+U78tBq7x9XOFXhjmy/m2Z70qni8Vvx2yeq9Gd6tfAA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 6/25/26 12:16 PM, Harry Yoo wrote:
> 

[...]

> 
>> So lock_batch_lruvec() can be implemented like this:
>>
>> #ifdef CONFIG_MEMCG
>> static struct lruvec *lock_batch_lruvec(struct lruvec *lruvec)
>> {
>>      struct pglist_data *pgdat = lruvec_pgdat(lruvec);
>>      struct mem_cgroup *memcg = lruvec_memcg(lruvec);
>>
>>      rcu_read_lock();
>>
>>      /*
>>       * The memcg can be NULL when the memory controller is disabled.
>>       * Otherwise, the caller keeps the memcg owning @lruvec alive.
>>       */
>>      if (!memcg || !css_is_dying(&memcg->css))
>>          goto lock;
>>
>>      do {
>>          memcg = parent_mem_cgroup(memcg);
>>      } while (memcg && css_is_dying(&memcg->css));
>>      lruvec = mem_cgroup_lruvec(memcg, pgdat);
>>
>> lock:
>>      spin_lock_irq(&lruvec->lru_lock);
>>
>>      return lruvec;
>> }
>> #else
>> static struct lruvec *lock_batch_lruvec(struct lruvec *lruvec)
>> {
>>      lruvec_lock_irq(lruvec);
>>
>>      return lruvec;
>> }
>> #endif
>>
>> Does this make sense?
> 
> Yes, looks good to me!

OK, this sync method makes more sense as it doesn't require adding a
new lrugen->reparente. I'll go with this method and update v3.

Hi Barry and Baolin, what do you think? Since the sync method has been
changed, I will temporarily drop your previous Reviewed-by tags in v3. ;)

Thanks,
Qi

> 


