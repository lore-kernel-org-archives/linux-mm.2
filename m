Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B98EC109E53D
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 02:30:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 95D416B0005; Wed, 25 Mar 2026 22:30:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 90E276B0088; Wed, 25 Mar 2026 22:30:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 823D96B0089; Wed, 25 Mar 2026 22:30:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 702BB6B0005
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 22:30:54 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CCAE3BCB43
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 02:30:53 +0000 (UTC)
X-FDA: 84586636386.05.5CBE734
Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	by imf12.hostedemail.com (Postfix) with ESMTP id E48C740006
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 02:30:51 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=PojcR6lX;
	spf=pass (imf12.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774492252;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9sZcKKartCLEcGbdRuk8RU9rrHH+1C3boMhyXvYq+RU=;
	b=7VWCZPFfgBpLz6seadiQiAfKvWM0YnnvV5rb+aRzsQMDyBuuYHx+e4FIDumWgXwjwfwMYd
	D8aihJUVIN/8npzctcmmfYkDgn+YtZojBr+gq82I2d92vDYuHnTz76dawRfhG4GXIdaVq9
	2V9NMKb3vZEIbsR7sIXtjNJ+5FZ16NM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774492252; a=rsa-sha256;
	cv=none;
	b=UTcJCmR0g1DHBSHKAWPJnxZZ22mRCUu4KY2l8pD3a5wBfwr/D9t1D4Q9NhC6qqUWB7K4yZ
	sa+EtEezgaZZAnVa6cvXc0BIBk/9JJRsjqic/Oy4CqgGcGT/BhbdWII+zBb4105GY9iJZk
	dgfxYs43UkNBWYTpHFNxhWLgAAXOjcM=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=PojcR6lX;
	spf=pass (imf12.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <c95c2542-34df-435e-85e2-bc4e5346b65c@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1774492249;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9sZcKKartCLEcGbdRuk8RU9rrHH+1C3boMhyXvYq+RU=;
	b=PojcR6lX910Q62jsSKfarzUo+MopTCDJjRkHWIFggMJ6nHYM7fKsOt6mdJXMi0msGNb5h2
	w5GvUF2aXHLDoX+SyTl+jMG7vZ3XjYp4hcWzQt/Z89RmVxHlnGmuLREi0RHO+8/SUcWOo8
	q5DtLI74uMtl7SgbHpf1hLk2dyGAUdg=
Date: Thu, 26 Mar 2026 10:30:29 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v2 0/4] fix unexpected type conversions and potential
 overflows
To: Andrew Morton <akpm@linux-foundation.org>
Cc: hannes@cmpxchg.org, hughd@google.com, mhocko@suse.com,
 roman.gushchin@linux.dev, shakeel.butt@linux.dev, muchun.song@linux.dev,
 david@kernel.org, ljs@kernel.org, ziy@nvidia.com, harry.yoo@oracle.com,
 yosry.ahmed@linux.dev, imran.f.khan@oracle.com, kamalesh.babulal@oracle.com,
 axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
 chenridong@huaweicloud.com, mkoutny@suse.com,
 hamzamahfooz@linux.microsoft.com, apais@linux.microsoft.com,
 lance.yang@linux.dev, bhe@redhat.com, usamaarif642@gmail.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Qi Zheng <zhengqi.arch@bytedance.com>
References: <cover.1774447069.git.zhengqi.arch@bytedance.com>
 <20260325165716.5d63522ba825f25a63e74e3e@linux-foundation.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <20260325165716.5d63522ba825f25a63e74e3e@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: E48C740006
X-Stat-Signature: ayxmi4ttnurontuf8bto9hdyju4omnyk
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1774492251-301258
X-HE-Meta: U2FsdGVkX1+beZ0Tb9ePJwVS2fywmmhhMhTgZ9XQLDm+pfFvBQRIxdoz1MjoquXtyS9+OQV2MhcvMN6dViRr26ssdFPaRnY0ZNpPJ9xDLQKQIMkYVS3Radrss33XzgKe3CwNb5Mhu/RHK3SPjgV+MOuSHQrvykW1CAb8I8NATdkr9HHL/1qNKKEWDZmHMDxDCQEgbqUb6HvQdEiBUifc+nvesSyANI+cMqmtjXpZaQDTsZXy3Dq3Svy6BhxgjkjpJVgZs+AktMChXY09qF6n4YLcRNquFnu0c/KI4cB0Lfwdn2shFx9JqTl2l9dm33td+BCZL2sPfoXn1lgeFWZAPOGuOCANBDMUma8xifzAwX0WkjE9CMkUlrCWcwzQK6RH/xVexGOH1fE9gdWYA6CZpKgYxU7SE5eLcLcwXkYbIw5rGV0c5p/KjlCSSBk0zefiZS/NctpuysukeUqo0MW0qkFgIhpAouVWt/pZ9EYaIC1KJnDsxC8kiwshaNFD2DY5y/NYbfgvyJlOmD+Ct70WMEpPpkBCSGjfb0+MQhaH31EdQLuSP5Pvzl9ZfvlZC8+mMQg4HUiDkSBIuKGgMm35h60Z7zuk/kycEdrKXdNcicNo9eL3UmHncGNtQCNJxHncZbQyLkai1Z+cbBitzdTZfplaBkIa9rLuykTl4OsdB/g3gCYdOTJc3NIUZwO6TbAaRM6k4OBljsbZW06B/I6jnVbb6e+Qzj4tuN9/IFUi+OlnH6jqIg+p5vjGRezwnxkLY8vqsL+nwftpkqTT+q8ddjV7n7b1eLpxAnlSz9j0wtKSoE3jR+E8qJrEUValR1iT4RJfmBb3+cY14WpnE/K6qrubcQpmuGUgg8wKedj6olfAlOqtAcGLjKyV7eVBLSaQnKNns8mCs1NZUjVGqXsyzpWjJHn9A+P3Va/wl8FYL1mctG4J/R3k3+ZeE+W6bqvnWZpMqx5G207XjyAvIvY
 NC1qMZjv
 VJxe24WjWZWKmsdOUrPmpzUJX5/noyebueJEirsJ+88wYjRmr8IGvqzxDAGkQuTahwLnazbAtO0TxrcOv3v2UqzVVhBxoheCKp8hy71914CwjX6yHwaiZx3aPMf61IUpr61KPc51oRa4BpbmHjXRqyEXYrDrVJc1LEyaWUOEDc/WT31S932AMlPGx8xpcdmwbzWiNRwK2LA7dIP+GJlo6Es+RFmWlIqYBEffWVQkpdjE4fsmzPtlhlogUM8QmtsSJ0pD77bs0Qy28fHtULBexdzE9luu7zhKLGnH0vYYrb58GubFKaBY7UDvcasWYy+KVCq7pS6JcsMToesc0k8L7LCcbHw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 3/26/26 7:57 AM, Andrew Morton wrote:
> On Wed, 25 Mar 2026 22:13:21 +0800 Qi Zheng <qi.zheng@linux.dev> wrote:
> 
>> As Harry Yoo pointed out [1], in scenarios where massive state updates occur
>> (e.g., during the reparenting of LRU folios), the values passed to memcg stat
>> update functions can accumulate and exceed the upper limit of a 32-bit integer.
>>
>> If the parameter types are not large enough (like 'int') or are handled
>> incorrectly, it can lead to severe truncation, potential overflow issues,
>> and unexpected type conversion bugs.
>>
>> This series aims to address these issues by correcting the parameter types
>> in the relevant functions, and fixing an implicit conversion bug in
>> memcg_state_val_in_pages().
> 
> Thanks. I'll add this to mm.git's mm-new branch.
> 
> AI review
> (https://sashiko.dev/#/patchset/cover.1774447069.git.zhengqi.arch%40bytedance.com)
> still points at the problem in [2/4], now describing it as a bisection
> hole.
> 
> In
> https://lkml.kernel.org/r/5fed0611-434c-4fd4-956c-39f23e0459a1@linux.dev
> you said you were going to address this by using abs(), and I see that
> being done in [4/4] so yup, runtime bisection hole.

Right.

> 
> I'm inclined to mark this "don't care".  But if we decide to backport
> [2/4] ("to prevent potential overflow issues") then we might have a
> problem.
> 
> Also, if some downstream person decides to backport [2/4] into their
> kernel without [4/4] then they'll have a bad day.

As Harry Yoo pointed out:

```
Let's look at an example (assuming unit is 1).

val = val * unit = -16384 (-16 KiB)
val * unit / PAGE_SIZE = 0xFFFFFFFFFFFFC000 / PAGE_SIZE = 0x3FFFFFFFFFFFFF
max(0x3FFFFFFFFFFFFF, 1UL) = 0x3FFFFFFFFFF

Yeah, that's a massive positive number.

Hmm but how did it work when it was int?

val = val * unit = -16384 (-16KiB)
val * unit / PAGE_SIZE = 0xFFFFFFFFFFFFC000 / PAGE_SIZE = 0x3FFFFFFFFFFFFF
max(val * unit / PAGE_SIZE, 1UL) = 0x3FFFFFFFFFFFFF
(int)0x3FFFFFFFFFFFFF = 0xFFFFFFFF = (-1)

That's incorrect. It should have been -4?
```

this can already be an issue even without [2/4], and
[2/4] just amplify it.

Before LRU folio reparenting was introduced, we wouldn’t pass in such a
large value, so this wasn’t a problem. Since LRU folio reparenting is
still in mm-unstable, so I didn't add a Fixes tag in [4/4].

> 
> So perhaps this issue should be addressed within [2/4]?

Because they fix different existing problems, I previously split them
into two patches.

However, since the issues are all quite minor, I feel that combining
them into a single patch is fine.

 >> Actually I can trivially do this locally if you like - just turn [4/4]
i>> nto a -fix patch against [2/4], squash them together later on.
 >>
 >> Please lmk if you'd like me to do that.

That's fine, thank you!



