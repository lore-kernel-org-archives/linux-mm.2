Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1C0EBCD4F3C
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 11:24:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5CEBE6B0005; Wed, 20 May 2026 07:24:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 57FB26B0088; Wed, 20 May 2026 07:24:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 46E876B008A; Wed, 20 May 2026 07:24:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 308DE6B0005
	for <linux-mm@kvack.org>; Wed, 20 May 2026 07:24:39 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8E4A98C84D
	for <linux-mm@kvack.org>; Wed, 20 May 2026 11:24:38 +0000 (UTC)
X-FDA: 84787565436.21.95BCE2C
Received: from canpmsgout05.his.huawei.com (canpmsgout05.his.huawei.com [113.46.200.220])
	by imf22.hostedemail.com (Postfix) with ESMTP id 60815C0006
	for <linux-mm@kvack.org>; Wed, 20 May 2026 11:24:35 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=VcRZLygb;
	spf=pass (imf22.hostedemail.com: domain of mawupeng1@huawei.com designates 113.46.200.220 as permitted sender) smtp.mailfrom=mawupeng1@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779276276;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uX2NCnOWaG1eWrQ7d3fMoAhNcynHoN+Nh013XLu1TqM=;
	b=EPFIKG1VJnzyBFe86HHBQ4hFLQ7nusA3ejWbht9AhYHOUDU9vrKoNJfBEIDVa61/xrbDt9
	dwrwnD9XLo4NV6DUUFYmgzeQdsiWj6JCMSdCXVDwwgZdLnt3CjdzCa8+DrW1OPziZs1nSH
	9qNx7JgyOJBX9JXzuetkRzf1vrudANk=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=VcRZLygb;
	spf=pass (imf22.hostedemail.com: domain of mawupeng1@huawei.com designates 113.46.200.220 as permitted sender) smtp.mailfrom=mawupeng1@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779276276; a=rsa-sha256;
	cv=none;
	b=4DEEP8FGGdAdXr5/v+shBCU3zSzX/67r0PnWTcHn3B1yWiubfSiPnAe36zEtnWZmIFKToh
	i8rreq1iLSAu+WGwCKzeffhpLMcPJt6WI7w81Bz01n8aMq7AEEueSNxPqyMDwSCI/0z6Vn
	1DTTFxBcKQTc+r8DExaOzjv9Ik1xs00=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=uX2NCnOWaG1eWrQ7d3fMoAhNcynHoN+Nh013XLu1TqM=;
	b=VcRZLygbY8zULWBa0AKd7nI9xoWEJP0J91DuhiyLj/4hwB2sKzIxa3r8bpwxYxpw/53OQVXFw
	K2/eXJJSqhvy6WcPoX+L5XlZ1YKOg+KUMlsLGuJYwfF4BYcecx/jH2HM0aekPdm0ab2XJhshnXX
	9Z27G38owT/ItD+e+lHUg9c=
Received: from mail.maildlp.com (unknown [172.19.162.140])
	by canpmsgout05.his.huawei.com (SkyGuard) with ESMTPS id 4gL8CD5Yzxz12LDy;
	Wed, 20 May 2026 19:17:28 +0800 (CST)
Received: from kwepemj100016.china.huawei.com (unknown [7.202.194.10])
	by mail.maildlp.com (Postfix) with ESMTPS id DDF032025F;
	Wed, 20 May 2026 19:24:29 +0800 (CST)
Received: from [10.174.177.15] (10.174.177.15) by
 kwepemj100016.china.huawei.com (7.202.194.10) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.36; Wed, 20 May 2026 19:24:28 +0800
Message-ID: <4ffe8dd7-86b6-42aa-a979-a9ae941e068e@huawei.com>
Date: Wed, 20 May 2026 19:24:28 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
CC: <mawupeng1@huawei.com>, <muchun.song@linux.dev>, <osalvador@suse.de>,
	<david@kernel.org>, <akpm@linux-foundation.org>, <ljs@kernel.org>,
	<Liam.Howlett@oracle.com>, <vbabka@kernel.org>, <rppt@kernel.org>,
	<surenb@google.com>, <mhocko@suse.com>, <linmiaohe@huawei.com>,
	<nao.horiguchi@gmail.com>, <mike.kravetz@oracle.com>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3] mm/memory-failure: fix hugetlb_lock AA deadlock in
 get_huge_page_for_hwpoison
To: <osalvador@kernel.org>
References: <20260520020128.3506168-1-mawupeng1@huawei.com>
 <ag1tNtzmjNlrj4Xm@localhost.localdomain>
From: mawupeng <mawupeng1@huawei.com>
In-Reply-To: <ag1tNtzmjNlrj4Xm@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.177.15]
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 kwepemj100016.china.huawei.com (7.202.194.10)
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 60815C0006
X-Stat-Signature: 6akepsoz5eue5fpydp6afaft9ygsbp4n
X-HE-Tag: 1779276275-793663
X-HE-Meta: U2FsdGVkX1/2ZBm2oN2iswsZl/Dxp7clmR9SM10jnfo1zP6keOhHtXmnj/VGWvLAPq1ni9LtgJsOpvnOy5fKKqXD7J4TxO09jqWzdC503pVBSA+GQydjWJLY3pwcvkiyPYMJ1mxmjclT+aqUdrjgBManExtHO3ZySUFWD3wAqgu3FeH3jz13Xeupl32qLviFUQlMovi0/Zde4/BCiDcNgNWuj7mraFgAW48eIz86A49Rz3vXCtSVujQbuYJMQ02YaFZzgfRrJQH/xfJbbRBddOjzwU1kNy79TbtcW2mvXeeZ+oPIF1R94y+F/MD1j8tPiOBtnNkhFqvAmaBKNnqyNE0XniCQc7uXJjAUHtZZg/bgqKW3oBgRgDmFdpO/zF3oPsq5VwQd8vlF65LQN3sTcGzp7vWN+uatCZIyRkwX8doZg0LaO1mCG04O+wXGtlsldM9Y584om1mF+gP9PNZ5XGeg1fEAY09SYR5D+i+UJhV+3TqZeee9Fs+FpFcOBHDmYyqjIyewXnYj1nevoPuw9TLnklF3u2Ijb6pAB8pjYT7tOYYyY3ywcacbx9i840NQNs2dEUKw7OFgzc82s+sPsroptF+5AQf5ru+1YJSBcIJ3cP3+jXXobS22Q0/hGFdJphZoO7QTl8Jk5AsQsF7C5GGHIX9vEaQUkZa30VHcWkvdcqeJl6Tt1GH2JabJQSpWl4+OVktLRu0wNfbSTkh2l/YYWw5rdKSCKQNxknO0jqROY1r0RFzP1BFI2BEk7WS7LFOq2Ex/eusTSlfxWqMASN7W6ql/mYTaDG5GOwg0sCRHHMqyt+EoTOPor7TyKOLgiut65ES9jdEgH+28p+PWY4R/no2msEHw2NLa6FvIWpJoX8Yoy4xWPerwsGPFREqDkin/NFbN7J9IvttekTf3n4oENj8SPBkSRsvU6wEbjB28vpHcNwYhaSoAJAh1b0lzN+SbuI9cYQ7+ko9zS0c
 nQg4PciC
 eqK6CG0e54tjk0Z4+X1x8bVFGvID2xyysQPhuLjEpcq5pXTLXgWPalkHdzlUHnnHhX4XT6kbq9sqH5QAluQbtQk09jyAAHjeJOw0LrrVDhf4VPLLI/qWcsLCGIOGVNngktSAvTxEMRxj8yu32tk/Wey1oLw1KDLclUE6HWQpVSslcVhsRoeE55lh/U6iHv96AuDI4xZzxsNuLzZ8GPfvAd1F8BBrsuGnskmmU0CGF/v55Yl+WEKvkPiK7tU70eQ4w/gIb9kwdjbmy2FK0Zsp/WsxGGxl0GZNuN+iCm73xazmxdd49YdIIyVlVQv5yDdalMdzOp62aJ7uavlgxqw2FR4azR8DEVD0A/dqueVYvRHRb8FCW1rZGvbg56q+YHVXNl6lHmZ8vEJJGZi9y5AyHh3qAFS911htcr48T+qNRbwXfibksj6B+awQpZ/v7AdwzhOcROQF+fh4Ywn4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 周三 2026-5-20 16:13, Oscar Salvador (SUSE) wrote:
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

You are correct. The refcount dropping logic in the `unmap` path was indeed flawed. 
This issue was originally uncovered by fuzzing. Based on the initial stack trace, 
we diagnosed it as a recursive locking (AA) deadlock on `hugetlb_lock`.

We initially suspected that `unmap` had prematurely released the folio reference 
count, triggering the free path. However, after a thorough analysis of the refcount 
state machine and the actual execution context, we confirmed that this hypothesis 
is impossible. The root cause lies elsewhere in the locking hierarchy, and we are 
currently tracing the exact call path that leads to the nested `hugetlb_lock` 
acquisition.

The deadlock can be triggered by injecting hardware poison errors on a hugetlb
page while concurrent unmapping activity occurs. The following minimal userspace
test case demonstrates the race condition by spawning multiple processes to
widen the timing window for the lock contention.

/*
 * Repro: hugetlb_lock AA deadlock via consecutive MADV_HWPOISON
 */
main():
    // 1. Map hugetlb page
    mmap(0x20000000, 0xa000, PROT_READ|PROT_EXEC,
         MAP_LOCKED|MAP_HUGETLB|MAP_FIXED, -1, 0)

    // 2. Inject hwpoison twice on same page
    madvise(0x20000000, 0x4000, MADV_HWPOISON)  
    madvise(0x20000000, 0x4000, MADV_HWPOISON)  

    // 3. Repeat in a fork loop to widen race window

Here is the detailed AA deadlock stack with lockdep enabled

  ============================================
  WARNING: possible recursive locking detected
  7.0.0-g0eba4942ce53-dirty #335 Not tainted
  --------------------------------------------
  repro/742 is trying to acquire lock:
  ffff800083702958 (hugetlb_lock){....}-{3:3}, at: free_huge_folio+0x194/0x3c0
  
  but task is already holding lock:
  ffff800083702958 (hugetlb_lock){....}-{3:3}, at: get_huge_page_for_hwpoison+0x38/  
  
  other info that might help us debug this:
   Possible unsafe locking scenario:
  
         CPU0
         ----
    lock(hugetlb_lock);
    lock(hugetlb_lock);
  
   *** DEADLOCK ***
  
   May be due to missing lock nesting notation
  
  2 locks held by repro/742:
   #0: ffff800086f942b0 (mf_mutex){+.+.}-{4:4}, at: memory_failure+0x6c/0xdd8
   #1: ffff800083702958 (hugetlb_lock){....}-{3:3}, at: get_huge_page_for_hwpoison  
  
  stack backtrace:
  CPU: 2 UID: 0 PID: 742 Comm: repro Not tainted 7.0.0-g0eba4942ce53-dirty #335   
  Hardware name: QEMU QEMU Virtual Machine, BIOS 0.0.0 02/06/2015
  Call trace:
   __lock_acquire+0xe7c/0x1e38
   lock_acquire+0x2b8/0x3f8
   _raw_spin_lock_irqsave+0x74/0xd8
   free_huge_folio+0x194/0x3c0
   __folio_put+0x124/0x130
   __get_huge_page_for_hwpoison+0x138/0x358
   get_huge_page_for_hwpoison+0x48/0x78
   memory_failure+0xb4/0xdd8
   madvise_do_behavior+0x39c/0x660
   do_madvise+0xe4/0x158
   __arm64_sys_madvise+0x2c/0x48


> 
> 
>  
> 


