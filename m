Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E5C24C61DE4
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 02:28:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8DECB6B008A; Sun, 30 Aug 2026 22:28:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 88FC46B008C; Sun, 30 Aug 2026 22:28:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A4DC6B0092; Sun, 30 Aug 2026 22:28:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 42BAA6B008A
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 22:28:11 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id BDCAEA3EE1
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 02:28:10 +0000 (UTC)
X-FDA: 85159979940.13.31402C1
Received: from mta0.migadu.com (out-41.mta0.migadu.com [91.218.175.41])
	by imf10.hostedemail.com (Postfix) with ESMTP id 00686C0002
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 02:28:06 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=BvFuGzIJ;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf10.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.41 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788143289;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=a3Uwv8zZU574WVcBxVZa/eFOQp4S/xguwfbO7/7JHR4=;
	b=LEKdm1Gwds5Hy4pJASbZX+gEUpEVLttJP+IGSrllKHMJFFwdVm/vaCfY2DLYG3W0n8rBb0
	9U1JvndC5YZi/ROhWlqbEZNhJ3fp4FIbuDdIKPSGFGePg1vJqtPTATcgYGgdjJI59cMDDs
	wsFnZ6cXU78YN4n0CTssmTME3T3Lzfw=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=BvFuGzIJ;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf10.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.41 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788143289;
	b=Ty7h2fEF9QUD0DWAJnnn7tRQTc8/EXn2Oprq54Cco/2aPRiEt/O3VpQrAKKf8UbSOzixwq
	PikcblRb2Q1j5aA1mbAgX59cPR/MY6UnOg0fpJs7lHOTCusZJO5/UebbRs1RIWJzUzZ+eu
	bsOWf4PgAaHeKtxyqi0Kjtdt0XdhQ+E=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=FlD54LcSt+NZlq7D9GrYKYXHGNdn1dwZ5TEhIQvteAM=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788143284; v=1; x=1788748084;
 b=BvFuGzIJlzHlq5jIgaq3nm9pD5tQNA4ct7HCULgnD2uT6HPu+77HbmLa0LOi5eXG0VXvkVNE
 jSLZihiLyuLHtvP8IgryUP/bq81/r+LpTyGkyv0E83LXP+NiiSc6v7b8XDNAB09u4wLLCb6uTS4
 xOQ8ZreoEshKzEAYc//1D0Oc=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 5a4496ccf4f994c7;
	Mon, 31 Aug 2026 02:28:03 +0000
X-Mizu-Trace-ID: 5a4496ccf4f994c7
X-Migadu-Flow: FLOW_OUT
Message-ID: <c1ad6e39-3b21-413c-ad02-f90cfc4102f9@linux.dev>
Date: Mon, 31 Aug 2026 10:28:00 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 1/4] fs: fix missed removal of
 super_fs_objects_eligible()
To: Andrew Morton <akpm@linux-foundation.org>
Cc: hughd@google.com, baolin.wang@linux.alibaba.com, usama.arif@linux.dev,
 brauner@kernel.org, david@kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Qi Zheng <zhengqi.arch@bytedance.com>
References: <cover.1786955972.git.zhengqi.arch@bytedance.com>
 <3b038d373c70ebac7cdabfb0035bb91d1d6e6cfe.1786955972.git.zhengqi.arch@bytedance.com>
 <20260828114129.909edbfb7e42b36af2da6a98@linux-foundation.org>
 <eeae0d48-4d50-4dd4-9e16-b4f9902d84f4@linux.dev>
 <20260829162350.1ee9e17d71a297b06b171941@linux-foundation.org>
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <20260829162350.1ee9e17d71a297b06b171941@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Stat-Signature: q84h7keuj8ozmz1w43nypu4981onm3jy
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 00686C0002
X-Rspam-User: 
X-HE-Tag: 1788143286-504805
X-HE-Meta: U2FsdGVkX18pqShmr+1/WcTC992ikGNNaszEfdaOwNpzhpBNPmD9dXhfKc1kIjSNb+jXIoRpMhWAwqHax1mUtd17r0W8EqaywP5ScQhC9Tf3qN1dhr6mv57/QdSCG4wfPJDvyZcwyFLrElZq2tVepbyTxcdK8jM3j3wrgXl/Ld+V8er+bAuNFG3hrkM/5x+LuCCQDU/HVQnhUKyPYNnlnkfpCW3SfPa1gSbY9GFI5X4JkWpcHFBKFm4IolwgONFFL2+Br2b4F/2aVHfAIkfGXbeKSxfHQCQe/CVfVmzTOQBe9Sxxp3MUhuRcMXGcb4wtQPL3/rlhWiyPMUly7GBoAIHRWnEJICGvwgRKwXiwEs5qBXmmyA5aEA+cW8vzOnoFWFRyQe9Hkx0DBSwZZeQtO/HKPajdqa/AQRgOKe8F7XK3jnFug6hFQeqi3YOc1Bc5AEgIQmEUA6jqS9bssa3TXWGOAtnZYJieOCELkY0uBD9jkLPXE9MpBSoRnmvZe8JIzwLElPqj1OLGadFTvGJ2JrDrI2vJjQD3qe7jbYlx47jnaxUBnwsMGvH6sdDhmfpOuL+K0V5/CVtapdv/fOXB3cDz17b3Qqp0ev/6d77YtA8D7W1IC4aIqJDyTd6KGmwessrxT3baK4Jxyuk5CsSi9qX8DUmrNU4irJoq0QwnFAhsggctbnwc+MFeJlYT8HPmB8kyvKNKub8e7xP88rExo4drQxr1LRzdNhPRTHpu6MSnZcGcdd0N0DifzSGhqQ8tC/Ekq4RMcq12SfL8QXcRriGFALCPnTSewlZyzoL9siGw07Hj2y6ZTCasv0MiIsEwG6kePPvJInABh2W3MNtXUL9BGI5Y376xZvL0QZVU5QrlYcvUmR093WGcjuH29DAQKX2TYg8k1lWJLrxUJVjfX5hWcanuselytvZyHktf9CfMUwxVp2ULoAoh5sEykpglJtsSaUzdInweMPFQVDb
 wx0ZXfov
 fohtESBYjOZVxBOJglNoQkuvq4h7fSdwDe0rKUc2B3APwDdsmghYj0w6HblHiLMQS1v67jjT3jPD9k2wF6blTIhlN0OjcLkzGZ4os9t8HedHcaA17q7m9sGUMyuZodnD5t2HZwauWbPeIAywmSlL3W3ZzRkoP/pdqJdYbHSxmHXTLQ8QNRigMBT7fGVrXZC7nIE7ARvoag4FMFrCrrC4ONcOIxaeN0iO0Vn3gd0b8JbH62Xy6YzYTSuP0nvr4ft5DVo4YxXKUekZp8FCPb9NW0Y6in6ueqAompgOw7/RsrSlDrM/sAu1feFeMiJ0ZMYPOB97hePWyC90LTAfCmJmr/5N7yHcLin83L2t7oL6OUoOXtsNe83SDCJChM2wa7VVEjA/i4VYSm0CwUjc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Andrew,

On 8/30/26 7:23 AM, Andrew Morton wrote:
> On Sat, 29 Aug 2026 09:49:44 +0800 Qi Zheng <qi.zheng@linux.dev> wrote:
> 
>> Hi Andrew,
>>
>> On 8/29/26 2:41 AM, Andrew Morton wrote:
>>> On Mon, 17 Aug 2026 17:03:25 +0800 Qi Zheng <qi.zheng@linux.dev> wrote:
>>>
>>>> From: Qi Zheng <zhengqi.arch@bytedance.com>
>>>>
>>>> Commit 0ef8faff490be ("fs: push nr_cached_objects memcg gating into
>>>> individual filesystems") forgot to drop the super_fs_objects_eligible(),
>>>> just fix it.
>>>
>>> Oh.  Why?  Please can we have a description of what's wrong with the
>>> current code?
>>
>> As I replied in another thread [1], this fix and commit 0ef8faff490be
>> together make up the complete patch originally sent by Usama [2], so
>> they should be squashed together.
> 
> 0ef8faff490be is upstream so they can't be squashed!

So sad.

> 
>> Without this fix, all memcg-aware
>> nr_cached_objects() will be skipped during memcg-level shrinking.
>> Besides the newly added memcg-aware shmem huge shrinker, XFS will also
>> run into issues.
> 
> OK, please add this info to this patch's changelog.  Please also decide
> whether a cc:stable should be added and if so, ensure the changelog
> makes clear why we're recommending a backport.
> 
> As part of this, let's expand on "XFS will also run into issues".

How about this instead:

---
Commit 0ef8faff490be ("fs: push nr_cached_objects memcg gating into
individual filesystems") was meant to drop the blanket memcg gate in
fs/super.c and let each ->nr_cached_objects() implementation decide
for itself whether it is meaningful in per-memcg reclaim. However,
when that patch was applied the removal of super_fs_objects_eligible()
and its two call sites in super_cache_scan() / super_cache_count() was
lost, so the helper is still gating every ->nr_cached_objects() hook
and 0ef8faff490be is effectively a no-op.

Consequences of the leftover gate:

   - XFS's inode-reclaim hook, which is intentionally driven from
     per-memcg contexts to free memcg-charged slab, is still
     short-circuited in fs/super.c — exactly the regression from
     commit 0baad6f9b997 ("fs/super: skip non-memcg-aware
     nr_cached_objects in memcg slab shrink") that 0ef8faff490be was
     written to undo. Memcg-charged XFS inode slab therefore keeps
     piling up under per-memcg pressure until global reclaim kicks in.

   - Any future ->nr_cached_objects()/->free_cached_objects() that
     grows memcg awareness is likewise blocked before it can run, so
     filesystems cannot opt in to per-memcg reclaim on their own —
     defeating the whole point of pushing the gating decision down
     into the callbacks.

Drop the leftover helper and its call sites so the intent of
0ef8faff490be actually takes effect.

Fixes: 0ef8faff490be ("fs: push nr_cached_objects memcg gating into 
individual filesystems")
Cc: stable@vger.kernel.org
---

Can you fix up the commit message directly on your end? Let me know if
you prefer me to spin a v5 instead.

Thank,
Qi

> 
> Thanks.
> 


