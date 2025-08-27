Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E92BECA0FED
	for <linux-mm@archiver.kernel.org>; Wed, 27 Aug 2025 18:34:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3A3F48E000D; Wed, 27 Aug 2025 14:34:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 353F18E0001; Wed, 27 Aug 2025 14:34:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 21CC38E000D; Wed, 27 Aug 2025 14:34:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0C2A18E0001
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 14:34:38 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B3AD9BB84D
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 18:34:37 +0000 (UTC)
X-FDA: 83823388194.03.604B5C0
Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com [210.118.77.12])
	by imf02.hostedemail.com (Postfix) with ESMTP id E88C780005
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 18:34:34 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=GfOCaaj9;
	dmarc=pass (policy=none) header.from=samsung.com;
	spf=pass (imf02.hostedemail.com: domain of m.szyprowski@samsung.com designates 210.118.77.12 as permitted sender) smtp.mailfrom=m.szyprowski@samsung.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756319675; a=rsa-sha256;
	cv=none;
	b=ktqcpbekN3HP2D2M9TYSI5xIUFOI0DvZaIBZtA7UkNjgB2iWl7BKxmElpIs0N8tCEcGQjJ
	9k2zMZ3tpEQTfyw9X4xPmjDO/mbT9tJBP21A+gTE1yDUreDVQYOwJ1b5sScEQ/V1Ftifqd
	r2oYMCKMg7WRyjNkIMgSDs/X5ChE3F4=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=GfOCaaj9;
	dmarc=pass (policy=none) header.from=samsung.com;
	spf=pass (imf02.hostedemail.com: domain of m.szyprowski@samsung.com designates 210.118.77.12 as permitted sender) smtp.mailfrom=m.szyprowski@samsung.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756319675;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0vmdefCDmyt9ywh+yymejY1N8ERx9TnrKiWiAjIj7Kg=;
	b=U+01E379BV8kWUG7e2kr238Fa8KIm6eVbipMAvPBR0GLEOLr5AG3l13MqoMem+2ukqJwei
	TzeoDHtYarmi0847pHI3/xiYaBknVKFOOCu+6BSdoYZJlAi3bbrLlwJUDnz5p6h7IMAbsd
	nIR9Yd/2tqz2oiqhUpwUsN4P61Lezw0=
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
	by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20250827183432euoutp022b1a1341cce3de2bc24c4e4e98066082~fs2-Lut0V0097500975euoutp028
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 18:34:32 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20250827183432euoutp022b1a1341cce3de2bc24c4e4e98066082~fs2-Lut0V0097500975euoutp028
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1756319672;
	bh=0vmdefCDmyt9ywh+yymejY1N8ERx9TnrKiWiAjIj7Kg=;
	h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
	b=GfOCaaj9iz+LW9wShqGApHa6/ZXQqOzHlqMklQXcYYC4w2as50eHruUBxlDoQeKd8
	 DY/qvufuUXCjNJZCjcFtYZOg42voEjT8ILaKIyRgs5ZzcIS53QnL52Zy2vmMoiK5eP
	 O2zDW8gyof+yqtT2zRTYPNi1no0gLH3CNcPp47nY=
Received: from eusmtip2.samsung.com (unknown [203.254.199.222]) by
	eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
	20250827183431eucas1p18406106ab84b10142c924ddc8afe26ba~fs2_wamdm0942609426eucas1p1k;
	Wed, 27 Aug 2025 18:34:31 +0000 (GMT)
Received: from [106.210.134.192] (unknown [106.210.134.192]) by
	eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20250827183431eusmtip29186bce2444aa1e212b09f3beb37a98d~fs292QuJH0603806038eusmtip2h;
	Wed, 27 Aug 2025 18:34:30 +0000 (GMT)
Message-ID: <8f6aa9a5-54bf-4884-aaf8-d2e3cef6ec78@samsung.com>
Date: Wed, 27 Aug 2025 20:34:30 +0200
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [syzbot] [fs?] [mm?] linux-next test error: WARNING in
 __folio_start_writeback
To: Joanne Koong <joannelkoong@gmail.com>, Aleksandr Nogikh
	<nogikh@google.com>
Cc: syzbot <syzbot+0630e71306742d4b2aea@syzkaller.appspotmail.com>, David
	Hildenbrand <david@redhat.com>, mszeredi@redhat.com,
	akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-next@vger.kernel.org, sfr@canb.auug.org.au,
	syzkaller-bugs@googlegroups.com, willy@infradead.org
Content-Language: en-US
From: Marek Szyprowski <m.szyprowski@samsung.com>
In-Reply-To: <CAJnrk1Ziam4ZqqyzOpbUD8j=RwJOK22Uz3VMqWZsUNiJ5bkBrg@mail.gmail.com>
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20250827183431eucas1p18406106ab84b10142c924ddc8afe26ba
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20250827164428eucas1p1e184d31f56fbcbb0d0526d2354d730a5
X-EPHeader: CA
X-CMS-RootMailID: 20250827164428eucas1p1e184d31f56fbcbb0d0526d2354d730a5
References: <68a841d7.050a0220.37038e.0051.GAE@google.com>
	<CANp29Y5zWmwXDq1uuzxi43_VXieykD2OOLF12YvBELCUS_Hibg@mail.gmail.com>
	<CGME20250827164428eucas1p1e184d31f56fbcbb0d0526d2354d730a5@eucas1p1.samsung.com>
	<CAJnrk1Ziam4ZqqyzOpbUD8j=RwJOK22Uz3VMqWZsUNiJ5bkBrg@mail.gmail.com>
X-Rspamd-Queue-Id: E88C780005
X-Stat-Signature: yrbbzrmk6ih99xhinigp71h4mrpno3rj
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1756319674-186196
X-HE-Meta: U2FsdGVkX1+WtSAsavC3zdPsg2kOr62NQoydNsIYP/sTyMvyWRKbayHzuTF7khg4rW0H0otArPNt6ltkdWRPOmt1p3j1rVTEdZUK+PbS88/R0ttsLJUWAeUt161MZmqo50o0I68OsuKlBVUbbFb7q1esxIPoq2SCRyPSQ4kID6gGLEq/iuTHgKDJajJfGXjloeXmqeoxmwJu65anT2bSr0aHsd3l3rBqeREmpRzfB087Ck4UjJy5tTK4gNJcGUKrLZCkNMZaTHk25MUADO8p8Hm9medBwnZ0J+S76ie1Pk+tEGE45/icKXchg9Qrc0Ar/HMUBBTib0f+z5DuMnHkCxCL81M6HbvmLNd9faJeqAlE6rqEXJpsTCNkkt8f2PHEzPD+etrvIoNMBl0VdGotzZcbMOelDkbWitPPB9o2mNzq/qaRW1v5qkXbLrTn8mx7ovZzxlemhwPj9tZwc2wGo+Eq5obPYglwSrClXyUJn3hyRGhrGICaJtUUnBI4oViKAK2gefzxuaL2f14c/GRsYPOPjUAypdMbVbDOXb0mFCVlfhU92NoNWMecNj2NZX30dq/j3NUF/7/plMuHJI0900LimhMQLP/6X0idqgB/3mexqasVPPGZlyPEJIaveRXcFSNJO4fBwT/bCN/vm3S8MzYDOw9xPfhh5Jj8raJQLz3+sJyinXJuS16n1usEzC2Vzf/SYw2Lfje4lbgTGpmo6oOKJTOsBfyXnhrHe0Q/oOnELF2o2NG5H0C5qQBGcR3a/X2pMa4rhryQLIv/i+nBwt6eqCwH8A8ysL3csVIHmpgQO+kP5kPkAljtpDhuZ326rp4FjRAAE5aMIEZmTPmcfqd/lf8qdulMcctawiwODM1EqXql49BGSXfQQ/O/DWPj3aaRv6jOE6zP+U2tFW2khwJiZ2w03TZb2uyB/5FDccm/5IFK1yrkxLPy03LAe0cZhian62Q5ePmTz6Zler0
 wHhYmIfR
 TDi6cT+Dy7yWNwVQIFFeZhQF6pPfOJeg9fC6SKQPh12OX2fwnFAoFKGsbVjH1vTVUtkFWhgDprgpRArMMdb+5V1Km3q8TNOkiVSuAirAZ4IevO8rx5uk1sAFgQYAcw9iVXRFcjOtHq/OcDgrlahtvgQPEx3RmMHIWI4P6N1u/wdaFBUP9y53sgFl1ilA8NB7KHszCwAl07ASZzjc6qrazWeIVrry1fPybXc15qnRDYD0Is9ge8KpaBFiMYLPltkVArqSrBrgZ2Fet6d+qmhefI/AFN/Fh9TNJSCyEiH4H8/iF3QLLIa/9jI4PyzbQAiql4B3Oa0VoPkj9s/PBjHe93QqDaFgdq9zFvH56s9O8HDgaSwCmiZRdh+d2hsTdPb1o35VY4QQunh40wqL8owEmpDfVdQJgQ0BcOIwRDl/DsAnE0dxrbaJyLOVyga5bAmORAW/bDa0zdkXlgWtiFJno1mFje7WyV91Fc4VL0W88koaUgoxz6+SNvl5kwkQViCUN8pBP
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 27.08.2025 18:42, Joanne Koong wrote:
> On Wed, Aug 27, 2025 at 6:45 AM Aleksandr Nogikh <nogikh@google.com> wrote:
>> I've bisected the problem to the following commit:
>>
>> commit 167f21a81a9c4dbd6970a4ee3853aecad405fa7f (HEAD)
>> Author: Joanne Koong <joannelkoong@gmail.com>
>> Date:   Mon Jul 7 16:46:06 2025 -0700
>>
>>      mm: remove BDI_CAP_WRITEBACK_ACCT
>>
>>      There are no users of BDI_CAP_WRITEBACK_ACCT now that fuse doesn't do
>>      its own writeback accounting. This commit removes
>>      BDI_CAP_WRITEBACK_ACCT.
>>
>> Joanne Koong, could you please take a look at the syzbot report below?
> Hi Aleksandr,
>
> Thanks for bisecting this. This is a duplicate of what Marek reported
> in [1]. His patch in [2] fixes the warning getting triggered.
>
> Marek, could you submit your patch formally to the mm tree so it could
> be picked up?

I've already did that:

https://lore.kernel.org/all/20250826130948.1038462-1-m.szyprowski@samsung.com/



>
> Thanks,
> Joanne
>
>
> [1] https://lore.kernel.org/linux-fsdevel/a91010a8-e715-4f3d-9e22-e4c34efc0408@samsung.com/T/#u
> [2] https://lore.kernel.org/linux-fsdevel/a91010a8-e715-4f3d-9e22-e4c34efc0408@samsung.com/T/#m3aa6506ee7de302242e64861f8e2199f24e4ad46
>
>> On Fri, Aug 22, 2025 at 12:09 PM syzbot
>> <syzbot+0630e71306742d4b2aea@syzkaller.appspotmail.com> wrote:
>>> Hello,
>>>
>>> syzbot found the following issue on:
>>>
>>> HEAD commit:    0f4c93f7eb86 Add linux-next specific files for 20250822
>>> git tree:       linux-next
>>> console output: https://protect2.fireeye.com/v1/url?k=1fb70741-7eccadc9-1fb68c0e-74fe4860018a-55254c3abc8830cc&q=1&e=3aa7e54d-e6d6-43e9-ade0-0a94ae0545e0&u=https%3A%2F%2Fsyzkaller.appspot.com%2Fx%2Flog.txt%3Fx%3D172c07bc580000
>>> kernel config:  https://protect2.fireeye.com/v1/url?k=7674b464-170f1eec-76753f2b-74fe4860018a-dc792d3947085adc&q=1&e=3aa7e54d-e6d6-43e9-ade0-0a94ae0545e0&u=https%3A%2F%2Fsyzkaller.appspot.com%2Fx%2F.config%3Fx%3D21eed27c0deadb92
>>> dashboard link: https://protect2.fireeye.com/v1/url?k=cc82c51b-adf96f93-cc834e54-74fe4860018a-15cd3914e26f6b7e&q=1&e=3aa7e54d-e6d6-43e9-ade0-0a94ae0545e0&u=https%3A%2F%2Fsyzkaller.appspot.com%2Fbug%3Fextid%3D0630e71306742d4b2aea
>>> compiler:       Debian clang version 20.1.7 (++20250616065708+6146a88f6049-1~exp1~20250616065826.132), Debian LLD 20.1.7
>>>
>>> Downloadable assets:
>>> disk image: https://protect2.fireeye.com/v1/url?k=e6bff250-87c458d8-e6be791f-74fe4860018a-800b933a7034a696&q=1&e=3aa7e54d-e6d6-43e9-ade0-0a94ae0545e0&u=https%3A%2F%2Fstorage.googleapis.com%2Fsyzbot-assets%2F669ede8f5d66%2Fdisk-0f4c93f7.raw.xz
>>> vmlinux: https://protect2.fireeye.com/v1/url?k=2603018e-4778ab06-26028ac1-74fe4860018a-9b89a99c7853c7f0&q=1&e=3aa7e54d-e6d6-43e9-ade0-0a94ae0545e0&u=https%3A%2F%2Fstorage.googleapis.com%2Fsyzbot-assets%2F50feda89fe89%2Fvmlinux-0f4c93f7.xz
>>> kernel image: https://protect2.fireeye.com/v1/url?k=420b962e-23703ca6-420a1d61-74fe4860018a-a965e5c8c6b4614a&q=1&e=3aa7e54d-e6d6-43e9-ade0-0a94ae0545e0&u=https%3A%2F%2Fstorage.googleapis.com%2Fsyzbot-assets%2F317a0d3516fb%2FbzImage-0f4c93f7.xz
>>>
>>> IMPORTANT: if you fix the issue, please add the following tag to the commit:
>>> Reported-by: syzbot+0630e71306742d4b2aea@syzkaller.appspotmail.com
>>>
>>> ------------[ cut here ]------------
>>> WARNING: ./include/linux/backing-dev.h:243 at inode_to_wb include/linux/backing-dev.h:239 [inline], CPU#1: kworker/u8:6/2949
>>> WARNING: ./include/linux/backing-dev.h:243 at __folio_start_writeback+0x9d5/0xb70 mm/page-writeback.c:3027, CPU#1: kworker/u8:6/2949
>>> Modules linked in:
>>> CPU: 1 UID: 0 PID: 2949 Comm: kworker/u8:6 Not tainted syzkaller #0 PREEMPT(full)
>>> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 07/12/2025
>>> Workqueue: writeback wb_workfn (flush-8:0)
>>> RIP: 0010:inode_to_wb include/linux/backing-dev.h:239 [inline]
>>> RIP: 0010:__folio_start_writeback+0x9d5/0xb70 mm/page-writeback.c:3027
>>> Code: 28 4c 89 f8 48 c1 e8 03 42 80 3c 28 00 74 08 4c 89 ff e8 ce a2 29 00 49 8b 07 25 ff 3f 00 00 e9 1b fa ff ff e8 7c 04 c6 ff 90 <0f> 0b 90 e9 d6 fb ff ff e8 6e 04 c6 ff 48 c7 c7 a0 f8 5f 8e 4c 89
>>> RSP: 0018:ffffc9000bb06ea0 EFLAGS: 00010293
>>> RAX: ffffffff81fad344 RBX: ffffea00050de8c0 RCX: ffff88802ee29e00
>>> RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
>>> RBP: ffffc9000bb07010 R08: ffffc9000bb06f97 R09: 0000000000000000
>>> R10: ffffc9000bb06f80 R11: fffff52001760df3 R12: ffffea00050de8c8
>>> R13: 0000000000000000 R14: ffff888023060880 R15: ffff888023060660
>>> FS:  0000000000000000(0000) GS:ffff8881258c3000(0000) knlGS:0000000000000000
>>> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>>> CR2: 00007f7354907000 CR3: 000000000e338000 CR4: 00000000003526f0
>>> Call Trace:
>>>   <TASK>
>>>   __block_write_full_folio+0x75f/0xe10 fs/buffer.c:1928
>>>   blkdev_writepages+0xd1/0x170 block/fops.c:484
>>>   do_writepages+0x32e/0x550 mm/page-writeback.c:2604
>>>   __writeback_single_inode+0x145/0xff0 fs/fs-writeback.c:1680
>>>   writeback_sb_inodes+0x6c7/0x1010 fs/fs-writeback.c:1976
>>>   __writeback_inodes_wb+0x111/0x240 fs/fs-writeback.c:2047
>>>   wb_writeback+0x44f/0xaf0 fs/fs-writeback.c:2158
>>>   wb_check_old_data_flush fs/fs-writeback.c:2262 [inline]
>>>   wb_do_writeback fs/fs-writeback.c:2315 [inline]
>>>   wb_workfn+0xaef/0xef0 fs/fs-writeback.c:2343
>>>   process_one_work kernel/workqueue.c:3236 [inline]
>>>   process_scheduled_works+0xade/0x17b0 kernel/workqueue.c:3319
>>>   worker_thread+0x8a0/0xda0 kernel/workqueue.c:3400
>>>   kthread+0x711/0x8a0 kernel/kthread.c:463
>>>   ret_from_fork+0x47c/0x820 arch/x86/kernel/process.c:148
>>>   ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
>>>   </TASK>
>>>
>>>
>>> ---
>>> This report is generated by a bot. It may contain errors.
>>> See https://protect2.fireeye.com/v1/url?k=d9d7c080-b8ac6a08-d9d64bcf-74fe4860018a-5a4a20c239e4ea82&q=1&e=3aa7e54d-e6d6-43e9-ade0-0a94ae0545e0&u=https%3A%2F%2Fgoo.gl%2FtpsmEJ for more information about syzbot.
>>> syzbot engineers can be reached at syzkaller@googlegroups.com.
>>>
>>> syzbot will keep track of this issue. See:
>>> https://protect2.fireeye.com/v1/url?k=03a49fa8-62df3520-03a514e7-74fe4860018a-9a57f917485c2c59&q=1&e=3aa7e54d-e6d6-43e9-ade0-0a94ae0545e0&u=https%3A%2F%2Fgoo.gl%2FtpsmEJ%23status for how to communicate with syzbot.
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
>>>
Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland


