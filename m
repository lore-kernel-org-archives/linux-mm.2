Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D6055FEA839
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 09:27:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0EDAF6B00A3; Wed, 25 Mar 2026 05:27:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 09E866B00A6; Wed, 25 Mar 2026 05:27:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ECF8C6B00A8; Wed, 25 Mar 2026 05:27:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D659F6B00A3
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 05:27:05 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7C7D5E0B7F
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 09:27:05 +0000 (UTC)
X-FDA: 84584056410.21.753360B
Received: from mail.ptr1337.dev (mail.ptr1337.dev [202.61.224.105])
	by imf05.hostedemail.com (Postfix) with ESMTP id 7B080100004
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 09:27:03 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=cachyos.org header.s=dkim header.b=J+Y14x9q;
	spf=pass (imf05.hostedemail.com: domain of dnaim@cachyos.org designates 202.61.224.105 as permitted sender) smtp.mailfrom=dnaim@cachyos.org;
	dmarc=pass (policy=quarantine) header.from=cachyos.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774430823;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jJ0Oay0Ddvqtq5h49ewinbwftm2X0gyMiyUqmVphS6k=;
	b=YcyQ9LbT3/v2tg/MUPQ1jyigMJnPHebCaYolb+Xorlttr/GkWlNCVO6KEBHkccGf61y0fA
	UKiVxpv5NW1vq6ph3qvKSYBsY3SHBjrz74kit0CNtEvN7Y7m4ckGDuw5hKJz9OkZ463H3R
	dYzOB/1CJ97NzTYKBrv4cmc0bToPhnE=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=cachyos.org header.s=dkim header.b=J+Y14x9q;
	spf=pass (imf05.hostedemail.com: domain of dnaim@cachyos.org designates 202.61.224.105 as permitted sender) smtp.mailfrom=dnaim@cachyos.org;
	dmarc=pass (policy=quarantine) header.from=cachyos.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774430823; a=rsa-sha256;
	cv=none;
	b=6ACmCpVt9pQs7314LS9ZqWtH1nVMyFXR4uRHx06XqeliKjHsgVKKSyu6ZkrvyJwVKwVVZ4
	Qj0obbXohVbYJVKWbLves543gUCKEHJMqZGGRg9IN0KXSK9wH+KBrG712jn1c8eVaqgxMW
	XJxk7FSx6rwXhFva8Zaz8MJ4lwRQwks=
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 766722860C1;
	Wed, 25 Mar 2026 10:26:47 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cachyos.org; s=dkim;
	t=1774430820; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references;
	bh=jJ0Oay0Ddvqtq5h49ewinbwftm2X0gyMiyUqmVphS6k=;
	b=J+Y14x9qfMHiQBalxiMyaw28F2f9KFOp/2ClRApslKiDAaepkl9Sv+PQphIbscHqjRbmer
	VKPmVFVN/4aDy4pDIQ0B17hGCLhVq6dTxbRl+GFNZQN4Pka+Z9rpeQB4K8c47TBIhS09QH
	ma6cGb7yRy88Da4Z5dKRw/dYtrEFcbCPS7zXPfcwFdq11aD1qQxtfcgPaDXAG3pUikcYT1
	Z9hSAdAcGZw1SXhhWz8YviTz0vQDNrx8dJBGX9jWt2dmLk7ni05BRp0pD9bxYPuyvDeCEF
	jhBpFWqtjeIOtdQ4XlX/WM9xe6bTmkx6g4EC5ZRf7rjkflil4zH9X2Qu0az37A==
Message-ID: <85b4be3c-09a3-4a28-924d-71a20db3fd62@cachyos.org>
Date: Wed, 25 Mar 2026 09:26:00 +0000
MIME-Version: 1.0
Subject: Re: [PATCH 0/8] mm/mglru: improve reclaim loop and dirty folio
 handling
To: Kairui Song <ryncsn@gmail.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>,
 Qi Zheng <zhengqi.arch@bytedance.com>, Shakeel Butt
 <shakeel.butt@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>,
 Barry Song <baohua@kernel.org>, David Stevens <stevensd@google.com>,
 Chen Ridong <chenridong@huaweicloud.com>, Leno Hou <lenohou@gmail.com>,
 Yafang Shao <laoar.shao@gmail.com>, Yu Zhao <yuzhao@google.com>,
 Zicheng Wang <wangzicheng@honor.com>, Kalesh Singh <kaleshsingh@google.com>,
 Suren Baghdasaryan <surenb@google.com>, Chris Li <chrisl@kernel.org>,
 Vernon Yang <vernon2gm@gmail.com>, linux-kernel@vger.kernel.org
References: <20260318-mglru-reclaim-v1-0-2c46f9eb0508@tencent.com>
 <7ab8edd7-381f-4db2-9560-b58718669208@cachyos.org>
 <CAMgjq7CuEYAzZFmS2T7N6je6VHffVkH1hh64YUuShFBnrJJvqA@mail.gmail.com>
From: Eric Naim <dnaim@cachyos.org>
In-Reply-To: <CAMgjq7CuEYAzZFmS2T7N6je6VHffVkH1hh64YUuShFBnrJJvqA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Last-TLS-Session-Version: TLSv1.3
X-Rspamd-Queue-Id: 7B080100004
X-Stat-Signature: yaumyfaiekyhsef8gdawb13neb3t9yng
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1774430823-985002
X-HE-Meta: U2FsdGVkX1+M1ZICOWQlIKtCaFccqd3rWDlqm+VuW0bCJnmPqE3rqwNeDCBteUGGC1h2/IA4mMR9qAzAIZg/iGBF6fd9KngGvi5pFIuR6UOq6vofMFGLuzA/44+NZpU7/d0qu7/HSXu1P1yRm3yejBOBMKdSOGqTxhc2sm1uyvA/5vb1cWKaynRIXMr5VjW3VkUR9QYnKQ7EvGFyOzY2BUuvccnIS/M6/4zwBOJn4Piop0gDez2+w2gKwvQiYTfIj4rZL0tsa7fDmFXiymTqfyrKnV4YROZkVJEIlpI4RRnKKNdmWpNT/jjJjunPV10o/JxP9TUcwBh15JVHRyItb4u/U8xWJgd4G0MYKjpPITnOdAkUJp2Qcq1dcnnMLZUTTOlLf1mvW3+5WS6ImCdeGM8VXNZRMIqwDuso/eBYuCFAfGhMx7Pc7BRR0GDZnNIQlKgVwFE8TrW1ueU74OphcizWrZB02JLE3AKijRU1qYxSkIb4hHLN52IdWC+TgfMwZQBqJ/+lO1Ph6i1I3oTlN28S+ZOmCMyyQjHANhPH+G0zAHY1+FO1lRinH+6MtSVL6Sk7ctX5CVfIeqYPyN5j9TT0RVbmWALmOLHRi5+uAnSmtiqY9dpMSXYUZyErRd5LT0m8UiGiaFSh/ewwhmYRyU/aJ57mP6VZ9+Bi0DPC42E4bSCaJbUaRnQJoafyknpFjSAo+AFgVBQXS9wzuXRi8iQu6NmoZTjmbiJxtZCBmRw1NcGdTY3HeEglOv7yzrouUwzIDadhqM6sn6p80Pq6IYMQnNTAzLgoy0wVPq6RJxq9sakr7Han/IPIUa0A+WClOX/UyGwZnZpsSSywL0RP1PtmhNuMhGKnNI/GgsF52HL7YwqWyUyCL8TZLgnOvwhkoy4OkVahN89tRVygjBPtgWz0CJglj56hvkwUxazwcl8Eqq3cXbtXDktcggJt6HYwQKO78rNZEJLb7xYaUMC
 AXJi3L9e
 wkRf0PRRP1ytxY/qR7b5GgOyYzqZkgKJzkKUwwxs3fT3nfkavTWZtmOCG0gn4u8k/2ZcDm95t1shus18lwHlJ/XgTHpYE+hGUHk+t8L3n+S5UihGruu2myu84Wa2p4htFu0LBfMp/rY32cP2DPiSwrg5H6oRzWHwwxLuT83jlb3Sdjnh8N6Do7M247wz9cpn3iGFQgY/PqL+fIZyGG/ImnTpG8caRXw2uj2zd1ZRUvRU6Gwxhc6j97Sz5E8JXk+0/BZzReINTlqsJcm0L9VCPo/Es5aEddf/KX6foceuFJo+Nm5aqGiG1FJuxp9UBps8Yz4NPkUeDP0bxIFQ0AnMcdMa95kVRJWIdHwpKhehLv8gG8eElknfy0nRqA/gEYsfioZxZQmxbtoBGFIQ8EmXmalb1bUo2q6McE1Gfu2DeGv7IHl0e0T89BoAwjpDnP4qOkdsi3VTJV99nMC8lL6vzUCAPGw7w9mmbGvo4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/25/26 1:47 PM, Kairui Song wrote:
> On Wed, Mar 25, 2026 at 1:04 PM Eric Naim <dnaim@cachyos.org> wrote:
>>
>> Hi Kairui,
>>
>> On 3/18/26 3:08 AM, Kairui Song via B4 Relay wrote:
>>> This series cleans up and slightly improves MGLRU's reclaim loop and
>>> dirty flush logic. As a result, we can see an up to ~50% reduce of file
>>> faults and 30% increase in MongoDB throughput with YCSB and no swap
>>> involved, other common benchmarks have no regression, and LOC is
>>> reduced, with less unexpected OOM in our production environment.
>>>
> 
> ...
> 
>>
>> I applied this patch set to 7.0-rc5 and noticed the system locking up when performing the below test.
>>
>> fallocate -l 5G 5G
>> while true; do tail /dev/zero; done
>> while true; do time cat 5G > /dev/null; sleep $(($(cat /sys/kernel/mm/lru_gen/min_ttl_ms)/1000+1)); done
>>
>> After reading [1], I suspect that this was because the system was using zram as swap, and yes if zram is disabled then the lock up does not occur.
> 
> Hi Eric,
> 
> Thanks for the report, I was about to send V2 but noticing your report
> I'll try to reproduce your issue first.
> 
> So far I didn't notice any regression, is this an issue caused by this
> patch or is it an existing issue? I don't have any context about how
> you are doing the test. BTW the calculation in patch "mm/mglru:
> restructure the reclaim loop" needs to have a lowest bar
> "max(nr_to_scan, SWAP_CLUSTER_MAX)" for small machines, not sure if
> related but will add to V2.
> 

As of writing this, I got some new information that makes this a bit more confusing. The kernel that doesn't have the issue was patched with [1] as a means of protecting the working set (similar to lru_gen_min_ttl_ms). 

So this time on an unpatched kernel, the system still freezes but quickly recovers itself after about 2 seconds. With this patchset applied, the system freezes but it doesn't quickly recover (if at all).

Curiously, I had the user test again but this time with lru_gen_min_ttl_ms = 100. With this set, the system doesn't freeze at all with or without this patchset.

> And about the test you posted:
> while true; do tail /dev/zero; done
> 
> I believe this will just consume all memory with zero pages and then
> get OOM killed, that's exactly what the test is meant to do. By lockup
> I'm not sure you mean since you mentioned OOM kill. The system
> actually hung or the desktop is dead?

The system actually hung. They needed a hard reset to recover the system. (pure speculation: given a few minutes the system would likely recover itself as this seems to be a common scenario)

> 
> I just ran that with or without ZRAM on two machines and my laptop,
> everything looks good here with this series.
> 
>> zram as swap seems to be unsupported by upstream.
> 
> That's simply not true, other distros like Fedora even have ZRAM as
> swap by default:
> https://fedoraproject.org/wiki/Changes/SwapOnZRAM
> 
> And systemd have a widely used ZRAM swap support:
> https://github.com/systemd/zram-generator
> 
> Android also uses that, and we are using ZRAM by default in our fleet
> which runs fine.
> 
>> the user that tested this wasn't able to get a
>> good kernel trace, the only thing left was
>> a trace of the OOM killer firing.
> 
> No worry, that's fine, just send me the OOM trace or log, the more
> detailed context I get the better.

Mar 25 08:24:22 osiris kernel: Call Trace:
Mar 25 08:24:22 osiris kernel:  <TASK>
Mar 25 08:24:22 osiris kernel:  dump_stack_lvl+0x61/0x80
Mar 25 08:24:22 osiris kernel:  dump_header+0x4a/0x160
Mar 25 08:24:22 osiris kernel:  oom_kill_process+0x18f/0x1f0
Mar 25 08:24:22 osiris kernel:  out_of_memory+0x4ab/0x5c0
Mar 25 08:24:22 osiris kernel:  __alloc_pages_slowpath+0x9ac/0x1060
Mar 25 08:24:22 osiris kernel:  __alloc_frozen_pages_noprof+0x29a/0x320
Mar 25 08:24:22 osiris kernel:  alloc_pages_mpol+0x107/0x1b0
Mar 25 08:24:22 osiris kernel:  folio_alloc_noprof+0x85/0xb0
Mar 25 08:24:22 osiris kernel:  __filemap_get_folio_mpol+0x1ff/0x4c0
Mar 25 08:24:22 osiris kernel:  filemap_fault+0x3e3/0x6e0
Mar 25 08:24:22 osiris kernel:  __do_fault+0x46/0x140
Mar 25 08:24:22 osiris kernel:  do_pte_missing+0x154/0xea0
Mar 25 08:24:22 osiris kernel:  ? __pte_offset_map+0x1d/0xd0
Mar 25 08:24:22 osiris kernel:  handle_mm_fault+0x89c/0x1280
Mar 25 08:24:22 osiris kernel:  do_user_addr_fault+0x23b/0x720
Mar 25 08:24:22 osiris kernel:  exc_page_fault+0x75/0xe0
Mar 25 08:24:22 osiris kernel:  asm_exc_page_fault+0x26/0x30
Mar 25 08:24:22 osiris kernel: RIP: 0033:0x7fec4beb43c0
Mar 25 08:24:22 osiris kernel: Code: Unable to access opcode bytes at 0x7fec4beb4396.
Mar 25 08:24:22 osiris kernel: RSP: 002b:00007ffcb348d698 EFLAGS: 00010293
Mar 25 08:24:22 osiris kernel: RAX: 00000000c70f6907 RBX: 00007ffcb348d8d0 RCX: 00007fec4bb1604d
Mar 25 08:24:22 osiris kernel: RDX: c6a4a7935bd1e995 RSI: 4fb7dae88ad99bfb RDI: 000055ee77cc8150
Mar 25 08:24:22 osiris kernel: RBP: 00007ffcb348dd60 R08: 000055ee77cc8158 R09: 000000000000000c
Mar 25 08:24:22 osiris kernel: R10: 0000000000000000 R11: 0000000000000246 R12: 000000000000000c
Mar 25 08:24:22 osiris kernel: R13: 000055ee77cc8150 R14: 0000000000000064 R15: 431bde82d7b634db
Mar 25 08:24:22 osiris kernel:  </TASK>

Here's the call trace that was recovered. Some mm related settings that we set in our kernel in case its useful:

vm.compact_unevictable_allowed = 0
vm.compaction_proactiveness = 0
vm.page-cluster = 0
vm.swappiness = 150 
vm.vfs_cache_pressure = 50
vm.dirty_bytes = 268435456
vm.dirty_background_bytes = 67108864
vm.dirty_writeback_centisecs = 1500
vm.watermark_boost_factor = 0

/sys/kernel/mm/transparent_hugepage/defrag = defer+madvise

[1] https://github.com/firelzrd/le9uo/

-- 
Regards,
  Eric

