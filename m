Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A54B3CD4F54
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 10:38:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CDD1B6B008A; Wed, 20 May 2026 06:38:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CB47B6B008C; Wed, 20 May 2026 06:38:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BA4606B0092; Wed, 20 May 2026 06:38:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AC4C06B008A
	for <linux-mm@kvack.org>; Wed, 20 May 2026 06:38:39 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 57D581606D1
	for <linux-mm@kvack.org>; Wed, 20 May 2026 10:38:39 +0000 (UTC)
X-FDA: 84787449558.04.70DC080
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 813584000A
	for <linux-mm@kvack.org>; Wed, 20 May 2026 10:38:37 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gqaA4sPm;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779273517;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zKHYUkO/I/cBGRIah7HMHfF9u0P/yu4dIBcDhYec6so=;
	b=Dr52JHFYNdKZGXsYmX2w1F2MMoAN93vcMzEoqEIrVZokZhWtH2hrXIGNKyGjDN6zVS84eQ
	52j82UTcu5rakHGlP0vXGn46WZDC+2M5sD+G5NWOqovzBD5y983M42T8lEc86UML1PdEVf
	RZrX6HTeAr1zGhy7Bq+arSKA499L/pA=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gqaA4sPm;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779273517; a=rsa-sha256;
	cv=none;
	b=goZiMkPDk5LYbL1NQlDg8KxmLfT9KVFPu47OUl5bZSVKejTKkD8p5IaMKmU7c7hXrizqAo
	ur715BU+k0lyqU1JVGtKWSXXnh1bGOs1iXOTtVzNe3zP+0FOxGApn8beJLuE34y2yMvY09
	toYf0CgsYIx0tQPDm51hgMVSCFROpQY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A620740427;
	Wed, 20 May 2026 10:38:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C78E81F000E9;
	Wed, 20 May 2026 10:38:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779273516;
	bh=zKHYUkO/I/cBGRIah7HMHfF9u0P/yu4dIBcDhYec6so=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=gqaA4sPm9GiPL95zqAzf4DlwDvm3yps/PysG5LJEvND2TMcMw+YmLTpkKj5M5ppdv
	 JiH7OG3keLXsczoVtlV5VN24CgsHcN9rg0qBeyEj6uB6USshElukhvhlzCoNU63MxH
	 8KAoeawePHuRQibM7kVg911h+NBl3OSQtTPNgnYsenfF+2/N2VOC4gCU51OH3w9hLP
	 T3SIDnCIut8oCzAkqu8FI7MWYd3fqbi1FePFd4FfRyXi1tM5KXVzWoLifEFc0oV/4q
	 RczviGsy0711qdZ6s8Qs1ojsvrLHRL6rCacmAM9ZPE6KUm6mvyofbAJKFWpEXlJcce
	 Wn0HEdDOIAYVg==
Message-ID: <093c0351-9417-4567-b4fb-62691118271a@kernel.org>
Date: Wed, 20 May 2026 12:38:30 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] mm/memory-failure: fix hugetlb_lock AA deadlock in
 get_huge_page_for_hwpoison
To: "Oscar Salvador (SUSE)" <osalvador@kernel.org>,
 Wupeng Ma <mawupeng1@huawei.com>
Cc: muchun.song@linux.dev, osalvador@suse.de, akpm@linux-foundation.org,
 ljs@kernel.org, Liam.Howlett@oracle.com, vbabka@kernel.org, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, linmiaohe@huawei.com,
 nao.horiguchi@gmail.com, mike.kravetz@oracle.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260520020128.3506168-1-mawupeng1@huawei.com>
 <ag1tNtzmjNlrj4Xm@localhost.localdomain>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <ag1tNtzmjNlrj4Xm@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: t1rsrnr6ah9xh6w7w4hi53jpi85ri1jc
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 813584000A
X-Rspam-User: 
X-HE-Tag: 1779273517-865187
X-HE-Meta: U2FsdGVkX19BfkjwPz7v0jea1/iqt1e6jTmGmnQ2/EuWvxuaZnEoRw7w12rdEdpXDTBZ3uA2C9/0FyJMBo/MHrI6d0Ex2Yk7HzaLrtpH9PLExLZeOH29FicWfYZ7lHrqLY1UA3XRerqCJUGhjyY/leAjZshXq7Wed3U9RZW8apoHp+g6sOTqr/1lNFi9z63zPRC8BQ2QxV4eQ55yo3FVr6EfrTA3Ss32mlGaJVObsfeILKzExof9lfosBlIMzvg7Y+NjNuV8PmXax5bmAoGUYhCITBN4LAqyE0FWGeQSQXlncWBhuvOqVqNZdJTTgHz0aIagkHP2Bwp9/cFG7iyLnbU7bokMETENlLqtvzhf18ZIUIbO47X6n1XQUZkEsTXzBKdtZOu1rhjzabIwueIAewNLYv04oNF12s7dMJ5RDOhelUVUJwUSJQKOEiDjyGYSD93TMWq0dEtR4JWB40u8zdDVUHrdDLvLIPpxt7JVbJ+1LDy1rP6z21asjbbAVtHpQsiLbQPNGMlMXrWHwD+tbnLIrJzRCwb73ybb1rxJiedebgOIEhcdHre6OkNP/R4idMCl/3ZN2hxA8vFwzBGjNSOV3ba1/zh8etsY93ojVeeQJaIrDoPArNtmb4cEzqrh7Lrw2tEv4Ihq62n5vqf9NI0eEZTIodmCNjMoHsF92DSqSn8zwQ5RxOpXUVGgF9pAPLSZcXv5xF9+EwJgLJpLozhJNoGzL5rNJ4VuSp1lg5NdFHD6Iy5JySGZjUuvNu1gpuYRSLDG4XlYeldfMndbN++GLqJsOdIi5p33YBrpVHY3t9WCwmjIS/g+//irJ1BZAq2fVIMAnV9xdj+XV4L7lvnP/5DuuXQ8jTo/itthwWOTjl3XtoR7pAofLb28vIxWBx59UfQej6jB/Kw2YIGlg7+e7TdTVLJeoSeHcTpuaLEQGCF1GrCUL/puhzKdi+kRuyIpFy8VDbFbzISNo0i
 vPwOjeUZ
 l6UbwdkZJ6uQm7tKfTIny09Vu9SWjzVZh0GuKOOfh1QTXof+kkAlY2gZzr9gl6F2+3QPbaHY8pp2cTt9R9p91hXArgQP3xLYBYPFR5RHUl4mPKkF7vKg/hewTEN6Rx4vXCVYAmOcP9m3CrmI+nwshXDu3lb7/4Xcku9XFBkttq3JTRk49upv+Xa3NZIsKxKc0mgGfeYx1ok/fk+7tKi9SwzsQGYM1UMEk7x1djv0pDibW1fzLlccVHZTsc9iwUB1Cpy3eJBrhpxeINeINsrP3oV4MifXDrtHl9IE4dppqXUuznFZzpN3M6Xoqr0oDvzfBNmuonA9WcVWBk5IyPkXcMI+rI4gNLA0kO9YIVmZ8/3fZCJ0wO7DZNl4PXzNCbyU+U3U1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/20/26 10:13, Oscar Salvador (SUSE) wrote:
> On Wed, May 20, 2026 at 10:01:28AM +0800, Wupeng Ma wrote:
>> madvise(MADV_HWPOISON) can trigger a recursive spinlock self-deadlock
>> (AA deadlock) on hugetlb_lock due to a race with concurrent folio
>> unmapping.  The race scenario:
>>
>>   Thread 1 (madvise MADV_HWPOISON)          Thread 2 (unmap)
>>   -------------------------------          -----------------
>>   madvise_inject_error()
>>     get_user_pages_fast()  <- refcount++
>>     memory_failure(MF_COUNT_INCREASED)
>>       get_huge_page_for_hwpoison()
>>         spin_lock_irq(&hugetlb_lock)
>>         // refcount == 2 (gup + map)
>>         // MF_COUNT_INCREASED path:
>>         count_increased = true
>>                                            zap_pte_range()
>>                                              page_remove_rmap()
>>                                              put_page()  <- drops map ref
>>                                              // refcount: 2 -> 1
> 
> Ok, bear with me.
> I am not saying the change itself is wrong (maybe it is not), but how we ended
> up in zap_pte_range() for a hugetlb folio?
> The stacktrace does not seem to have much sense?

Right, that does not make sense. Not even page_remove_rmap() makes sense,
because that function is long gone.

Undisclosed usage of shitty AI?

-- 
Cheers,

David

