Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 76CDEC5CFDB
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 08:29:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7A9A36B00B4; Wed, 12 Aug 2026 04:29:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 75A8E6B00B5; Wed, 12 Aug 2026 04:29:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 697C26B00B6; Wed, 12 Aug 2026 04:29:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3E07B6B00B4
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 04:29:56 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id BA3991C0F93
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 08:29:55 +0000 (UTC)
X-FDA: 85091944350.17.B2A7B76
Received: from out30-112.freemail.mail.aliyun.com (out30-112.freemail.mail.aliyun.com [115.124.30.112])
	by imf04.hostedemail.com (Postfix) with ESMTP id 2994E40003
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 08:29:50 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=d53t9GUL;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf04.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.112 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786523394;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sKaJ6FGtUdSwXT7P2z1g+Pgsj1kf9fIfFELLU/0C2V4=;
	b=4jVCIMnlzpKu+2BUyGrJoinYaxfpXOG2ZFZb4XNhyPV4d24xwAveyun+yIEPKlyrMWqhzc
	XoS2Au3GAVSmnEBzNz8uymtvDmy6zlXGNaizWYZ06XLjXNw9TqkOnjLhhwM+AkQZgjWTeG
	dAbgjyluoZDJ7Jy8W04niHklbdsXqu4=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=d53t9GUL;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf04.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.112 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786523394;
	b=8Q10h0GTObGQsF299/rcToI+KCpKnjfuaMa7fY1putofU5SOjOrVlcFtVaJ3g1Okakm370
	MiD5pvlYeazIUDzyySDDAH924WKdwxKvgaUj7saL4Qrtb45G1LcdACZHhRSlCtHwPTGxgW
	psrIZmcm/bYDh7fdV8kgnjRU4amHtls=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1786523386; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=sKaJ6FGtUdSwXT7P2z1g+Pgsj1kf9fIfFELLU/0C2V4=;
	b=d53t9GULhYnouL3Y68xmmQTG72nCbKxaVw9I0q4gctK25532VORyhxRL6blIUxojnwmzxKiYH/w7X3Hm7FesaLK933qZ75LJIgymdNDUjtj7M1BCgqoStHLQld4Zst7arFLxr8/sq/mg6BqazMe9GECvPupUA4m4YEtx5uLUzHI=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R111e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=16;SR=0;TI=SMTPD_---0X8r1lbl_1786523383;
Received: from 30.74.144.118(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X8r1lbl_1786523383 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 12 Aug 2026 16:29:44 +0800
Message-ID: <88ed8a93-ae55-4281-b99d-ec4a6b6a2deb@linux.alibaba.com>
Date: Wed, 12 Aug 2026 16:29:42 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [mm?] WARNING in set_mm_walk
To: Shakeel Butt <shakeel.butt@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: syzbot <syzbot+12ee2725d5fde63a9c96@syzkaller.appspotmail.com>,
 axelrasmussen@google.com, baohua@kernel.org, david@kernel.org,
 hannes@cmpxchg.org, kasong@tencent.com, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, ljs@kernel.org, mhocko@kernel.org, qi.zheng@linux.dev,
 syzkaller-bugs@googlegroups.com, weixugc@google.com,
 Yuanchu Xie <yuanchu@google.com>
References: <6a7a6929.b50370da.49fe0.005e.GAE@google.com>
 <20260810174852.aca0f73ab7ad71c70dcdefda@linux-foundation.org>
 <anqnAoFUUESi5Qe7@linux.dev>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <anqnAoFUUESi5Qe7@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 2994E40003
X-Stat-Signature: tosph7isfnmwxzyizorkni3enh941emp
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1786523390-479328
X-HE-Meta: U2FsdGVkX19rqfQL0w8jLN2zxbWJ6ns0H6upqXtk78ASZ2Fv3I+X7SQuGvo0Nnp/qE/BPQbeYpugsQas2ldgUDHhmbIRlXsYAXdoxphV3Ij6gs5lRs3MCkAXcxE14Jh4OE12vIU/lRiVb/xzEe61knwHbb2alQrClFq/KePzTJA9Urm77pb8oaTkO5HDtj04Vr+CdCzwat7hRyu0JknhdycCvXEaTtt7NWQtEvK3xsdewPr4vyOccLG62HpDS559Acc3VHSClL4j7W9G+4RnVazbATmGrdz4Re2sL/n6RlNhmUzJTuHeb5jEUwUedRTJvYh81UU30Vqf/P875ct67d54HbXGJwD8EqhO2B9v9CYQ8kc/KQCvWuQ3rnuZKVsF43RQChITW9EIMnSCLSFphs2wIZS/GENGIE6Xi/0DDrOQ7KybMe+sUR98RIveAqYIQPA9yR1FUcZYi+kfa1WbXWIuLyd0jnP0cdwZNBQxGObdR8rg6N2+oxtcXxO5Lk+VUeykNTt+20V0VJL192s3A2TzAwOPLIkMLz7vIRa5EI8R9FMgVxNnLE/KpGLgl+GHHyhon8a88FPaAbmnjaMBWWkaYSmFm1pCVCmsQgmueoXiCc6AMf1r92zg4oeqNEBt6fA5igOuPnYa90WfbkpAQX8mOqxiJRuP0Oiq7IcVv4Vn/lP9KYVUTv9XxtkMnL/6MzjJRCrIZIvvAq/au3OlrZB1yQqyMiTmz/B7w31iU3cUYg48hKiIS2PP0WWo+F/wwd2NzhL7KvJXW4YCTl5L6UONshPFqodPB+V4914M0I6qNRjiXV/ipt2jSWcelLUlzNBzDpCV57AomojnZw2ofuYbed4d8/nmfS7AsIdtBMDLIV2919cqoXyXRAcfGcPbITo2T2NkLg9ZXDWz/DvOO4xOAcEJ2GOKq5gHf20W1YCql6i5nzXIHFeHNsvkhZMmGpGKIAvrTrLZJL1uoEI
 itwqdKI/
 sx3lauYxwpC6vLl4Q5pHg/CHbqn/TVUtKp/TlVXy4UtmnIi9BBNpmmESn66UINjetMblDrEj0H/2wIQl03tllrxE6hDA0CcyELCyv/NilSDHp4ZiCaZR4DFUU4XsqlXw3MGwTIb58SaPr88D7TepATQgj2RcMCOwOMFDREpGzJqhrxGVHTDosipgpADHf+lPfeFFRtXD5tpNGCKwkGKy5id9vcBSV6k3J9Do+IG8uZVJwCfCNFapw9SnifhIwitdoIOahXfaUq6iPzuDBeEyID0wGBhbjjip3yS2HszqC73wCFqJD2XSzR9F0xn4IsWJgdPSR4E22kAObu6FUEseqX5iELinpMp5vus7fD3GI1h4nV8bUvPRimziszlUaCo9w4x1tfJJqCeFuvvwD1Bt89wcU64brUjH3jBYdWAu8erylX20H+4u0eeVHBWusSGau74pNBL5XW8X+pVUh8YgB1fd+XdwJV5uh3vrcIcdAZYBM/osSPeRGudoTCegXuPmuXWGHkfIaD795UWUCtLQCDfPdizA4Fi9NwXojNCS0jmjQaIWxlI8tzNShHerTaPyct5EMc8c/GxZ8CwDjVQjmKuAu+gW4CzzjRKx5OqkazoWdZM0CcHW7Tqok1n5iqORmXgXRk16VuNUW6Z1uxpHOt3qcr8hZIewUEvj8AnzJuUdvFqFXqsimSkoqlur3RRYwKIG73XWd5G8MbF6xEGN2jrrwcZJDCFD8KNmnMoi1luNZFki6Fl4S7YNvJ1t/nI/JynbYGpYFdf1fcW8571z9D9/HgIGFjLZGcTpw7LQLTZQbM7CHOoUpPJHchXxyif4N+31yNKXK0hvJh7zr3lXky4k2QLkHwJT/obDujarGRys0ac4yrt+iYiCld4YRAwLlU/4zHQWUVHeFGK0KxUCreVNWw4b190fr2E7/SqKp4EsnaPXHdc2MAvnm3aC+uaEb11/jNrVuH8RH3pjBG85Al6wMZjOs
 4htNuJ/l
 tJ/N/7WWA4njQB9unsA9nEGib4nvI6Z96LXj3fExf4B24un2bztteQex4mCidZBOCqIFAoaQTx2loWjkXEiEY6wJOqiIq5Rg1s5vtOKGMf3xSP7FH7iS2stiDdcghSfsLpBpNbU67m1ZB1PkBkcfWVKsBXrAjNSjN14Pg3j79YVbKD2w3jxyVg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 8/11/26 12:39 PM, Shakeel Butt wrote:
> On Mon, Aug 10, 2026 at 05:48:52PM -0700, Andrew Morton wrote:
>> On Mon, 10 Aug 2026 17:13:29 -0700 syzbot <syzbot+12ee2725d5fde63a9c96@syzkaller.appspotmail.com> wrote:
>>
>>> Hello,
>>>
>>> syzbot found the following issue on:
>>>
>>> HEAD commit:    562bfb501c54 Merge tag 'integrity-v7.2-rc7' of git://git.k..
>>> git tree:       upstream
>>> console output: https://syzkaller.appspot.com/x/log.txt?x=11a8cbb9580000
>>> kernel config:  https://syzkaller.appspot.com/x/.config?x=145fa60d73086782
>>> dashboard link: https://syzkaller.appspot.com/bug?extid=12ee2725d5fde63a9c96
>>> compiler:       gcc (Debian 14.2.0-19) 14.2.0, GNU ld (GNU Binutils for Debian) 2.44
>>
>> Thanks.  One for the MGLRU develoeprs, it seems.
>>
>> https://share.gemini.google/Wg4a5ns7E0LF might save a bit of time figuring this out.
>>
> 
> This is memcg-v1's soft limit which is deprecated. I am more inclined to simply
> remove this code instead of fixing it.
> 
> I will take a stab at removal.

MGLRU doesn't actually support memcg-v1's soft limit:

unsigned long memcg1_soft_limit_reclaim(pg_data_t *pgdat, int order,
                                             gfp_t gfp_mask,
                                             unsigned long *total_scanned)
{
	......

         if (lru_gen_enabled())
                 return 0;

	......
}

The call trace below likely showed up because the test repeatedly 
toggled MGLRU on and off, which isn't a normal operation and should be 
avoided in practice.

I also agree that removing the deprecated memcg-v1 soft limit is the 
better way forward.

>>> Unfortunately, I don't have any reproducer for this issue yet.
>>>
>>> Downloadable assets:
>>> disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-562bfb50.raw.xz
>>> vmlinux: https://storage.googleapis.com/syzbot-assets/9cbf6ef0490e/vmlinux-562bfb50.xz
>>> kernel image: https://storage.googleapis.com/syzbot-assets/7ee52864c79a/bzImage-562bfb50.xz
>>>
>>> IMPORTANT: if you fix the issue, please add the following tag to the commit:
>>> Reported-by: syzbot+12ee2725d5fde63a9c96@syzkaller.appspotmail.com
>>>
>>> ------------[ cut here ]------------
>>> current_is_kswapd()
>>> WARNING: mm/vmscan.c:3800 at set_mm_walk+0x210/0x270 mm/vmscan.c:3800, CPU#1: kswapd0/110
>>>
>>> Modules linked in:
>>> CPU: 1 UID: 0 PID: 110 Comm: kswapd0 Tainted: G             L      syzkaller #0 PREEMPT(full)
>>> Tainted: [L]=SOFTLOCKUP
>>> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
>>> RIP: 0010:set_mm_walk+0x210/0x270 mm/vmscan.c:3800
>>> Code: 13 00 00 4d 8d 7d 08 e9 f7 fe ff ff e8 79 f5 2a 00 e9 b7 fe ff ff e8 7f 6b ba ff 90 0f 0b 90 e9 d2 fe ff ff e8 71 6b ba ff 90 <0f> 0b 90 e9 74 ff ff ff 4c 89 ff e8 80 f5 2a 00 e9 4e fe ff ff 48
>>> RSP: 0018:ffffc900027772b8 EFLAGS: 00010293
>>> RAX: 0000000000000000 RBX: ffff888024934a80 RCX: ffffffff824ff8e8
>>> RDX: ffff888024934a80 RSI: ffffffff824ff96f RDI: ffff888024934a80
>>> RBP: 0000000000020000 R08: 0000000000000005 R09: 0000000000000000
>>> R10: 0000000000020000 R11: 0000000000000000 R12: 0000000000000000
>>> R13: ffffc90002777c38 R14: 0000000000000001 R15: ffffc90002777c40
>>> FS:  0000000000000000(0000) GS:ffff8880d5ed8000(0000) knlGS:0000000000000000
>>> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>>> CR2: 0000001b31923ffc CR3: 0000000109695000 CR4: 0000000000352ef0
>>> DR0: 0000000000000005 DR1: 0000000000000005 DR2: 0000000020040004
>>> DR3: 0000000000000056 DR6: 00000000ffff0ff0 DR7: 0000000000000400
>>> Call Trace:
>>>   <TASK>
>>>   try_to_inc_max_seq+0xf0/0x1090 mm/vmscan.c:4023
>>>   try_to_shrink_lruvec+0x4bd/0x6b0 mm/vmscan.c:4977
>>>   lru_gen_shrink_lruvec mm/vmscan.c:5128 [inline]
>>>   shrink_lruvec+0x31e/0x25b0 mm/vmscan.c:5888
>>>   mem_cgroup_shrink_node+0x227/0x6a0 mm/vmscan.c:6753
>>>   mem_cgroup_soft_reclaim mm/memcontrol-v1.c:312 [inline]
>>>   memcg1_soft_limit_reclaim+0x2d5/0x830 mm/memcontrol-v1.c:362
>>>   balance_pgdat+0xa11/0x1f00 mm/vmscan.c:7177
>>>   kswapd+0x556/0xb50 mm/vmscan.c:7462
>>>   kthread+0x370/0x450 kernel/kthread.c:436
>>>   ret_from_fork+0x72b/0xd50 arch/x86/kernel/process.c:158
>>>   ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
>>>   </TASK>
>>>
>>>
>>> ---
>>> This report is generated by a bot. It may contain errors.
>>> See https://goo.gl/tpsmEJ for more information about syzbot.
>>> syzbot engineers can be reached at syzkaller@googlegroups.com.
>>>
>>> syzbot will keep track of this issue. See:
>>> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
>>>
>>> If the report is already addressed, let syzbot know by replying with:
>>> #syz fix: exact-commit-title
>>>
>>> If you want to overwrite report's subsystems, reply with:
>>> #syz set subsystems: new-subsystem
>>> (See the list of subsystem names on the web dashboard)
>>>
>>> If the report is a duplicate of another one, reply with:
>>> #syz dup: exact-subject-of-another-report
>>>
>>> If you want to undo deduplication, reply with:
>>> #syz undup


