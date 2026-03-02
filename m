Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 434DFD58E7A
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 09:06:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AB5836B0005; Mon,  2 Mar 2026 04:06:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A62D26B0089; Mon,  2 Mar 2026 04:06:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 964EB6B008A; Mon,  2 Mar 2026 04:06:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 844056B0005
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 04:06:34 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1D9A7C317E
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 09:06:34 +0000 (UTC)
X-FDA: 84500542308.01.3260051
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf07.hostedemail.com (Postfix) with ESMTP id 4336840005
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 09:06:32 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=none;
	spf=pass (imf07.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772442392;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/+l9L2S+nKgITOxtBLBgCw1ASgJIlDtgIJ1rboK87DM=;
	b=ybr3V8WLeeIxnFQDg3G1FWdFoomHHHdL7GMULOTnx2w7rvoB74PcH+eac6y7VYv7baQFcn
	STj6dbilEvmuvZ0Ta6ZETUuKaRnYRVx4y9CL2Ko5YlxP5UsAmicyye93MEEUcKXXpixEQm
	mu8UxIdcvJWL1lPQHM0f/2hv3AJbe4o=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772442392; a=rsa-sha256;
	cv=none;
	b=2o2JLAlRw+VDwErYjB8SMCMCAB6MDrGSXJKQ8QcO9Jg8vez+HUwP4xe6BOeI0KqDb81MZj
	RSIQfXLcdBjb0+JGEF0rI8IiX+YipkNlixH4xiah24wEbnvzhHffTBnBaBAoEYfd50fWRF
	tKSw7kl1WOAGmTjb5EYp9WPNJVq81Ys=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=none;
	spf=pass (imf07.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9832B14BF;
	Mon,  2 Mar 2026 01:06:24 -0800 (PST)
Received: from [10.164.19.52] (unknown [10.164.19.52])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 881973F73B;
	Mon,  2 Mar 2026 01:06:26 -0800 (PST)
Message-ID: <99e4c72f-dc2f-4b26-9b32-0dd716789060@arm.com>
Date: Mon, 2 Mar 2026 14:36:23 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm/rmap: fix incorrect pte restoration for lazyfree
 folios
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 Barry Song <21cnbao@gmail.com>
Cc: akpm@linux-foundation.org, lorenzo.stoakes@oracle.com, riel@surriel.com,
 Liam.Howlett@oracle.com, vbabka@kernel.org, harry.yoo@oracle.com,
 jannh@google.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 ryan.roberts@arm.com, anshuman.khandual@arm.com, stable <stable@kernel.org>
References: <20260228140540.1774748-1-dev.jain@arm.com>
 <CAGsJ_4ynq76B+qJmtJayB44eRehviCbhBNKu0sdU1NcdiSDVJw@mail.gmail.com>
 <2703daae-3854-492a-a3d8-8bedd6a58aaf@kernel.org>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <2703daae-3854-492a-a3d8-8bedd6a58aaf@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: y7fy3y6x6m6e8aa915t39sfhd6tcyst4
X-Rspam-User: 
X-Rspamd-Queue-Id: 4336840005
X-Rspamd-Server: rspam12
X-HE-Tag: 1772442392-465209
X-HE-Meta: U2FsdGVkX18DbGufA2Cq5z/vMQjHROKnRZM7wwdKtm+9tpIgoY6fxuQsUToYJg40Z8d4zTSfLZzfmILD4b211bizaUbfMOjvyaSgcLndV41azhnnp7CACqwUn0iVDnwOX1IAIuhFv5UYvjMQSbNJRZV+M/b2+5Blec4MHaNR3I7A0/RnCTz2cf1BqDu4KoKjIBnT82elHKzvrP3iYkLhoIgMqstOhDceqoh7o7pAjLTTVU60ayw1/zAYu41XEmUcAvuGNXa+MRMOjwOk9Pmhy0gB6Sk1czxtm9BzDf5JlDPAbr6aMDIjpXFc0zEuS0k7aOwuD5buPHEJftcSpIKJVz8ektMQBo6iuirUvg58P68LBcMUAWBdlmT/ChnnTdRC/mbX8KAhsSHaBEfNHSOJr2lqccgDaZU+4LJ7l51xFDWTuwKxVvkVt/I70OL/qIrmw3ydLFvH5s+/AMCorxae3iL1AQKam55eslY/9P8PBmH/uJSWEtOmkCaXYWRyhVvicU8QeZ/cDK1Ma0cQx52RswzvZUjY4I5zRZbtWYzcAqgebx2sufclQUzTYEE9HE1siwTnrD0fT99xe8yHjg/sWDPasPSKky0eZvYd3mMFEZBt8gWOEXdf+kRzqqkI+/ZFsfKpO8EdvW0kTnL31WVPT5B4w9XRLUFLH6otYVQhhcWKfnTkuDFio3VoTORIsxLpoQvLCtF4turfpIEXH3zFGU6+aAMDB2lFMiqP4kLTeL5E670wbuci8DFRDnXMtS0t/bEftqUsHeQSI0hMn3VBN3jNMT5aV3Mwov+ez1j9d1Br7hhEPhoCuf4L7EGkw2oRFlYgNwVkkxpYG/E5f6L/0wLGJl3+yFI1YhZOPh6oCfx5CySTYXssy4JzfdqBTefz4ziPrpPxUREzVAFIs0B32EvORQzsEAjNgb8mxQ7lghfsUduwSt4bc6jdtETWeMJowd8h14x5l0v+4FzJ8QR
 q52ryc3V
 bszLPZop6xUPlT78QU90HhA/51S/CopgtIAYSB8xg1+4ppGWyGVk1QsaUoq84M+N65qZq/FZKhD22CWoRvE02FXiOAVOtIeORD7G8g9gN8xGPG3pExPejablCcSjvGpzWdwMWhJkQd+x5Pb8bb28i5afVrB7NVp3xyCDz08cIJFZq1TjOQEpkHddXr60ILYdzganDQKEWM4SsXsLUDZJlgsx80QnYI57U+MpQ+6CXz4pIoEQhcaGn1YUUvLFuGVfq9xaL
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 02/03/26 2:14 pm, David Hildenbrand (Arm) wrote:
> On 2/28/26 19:34, Barry Song wrote:
>> On Sun, Mar 1, 2026 at 3:06 AM Dev Jain <dev.jain@arm.com> wrote:
>>>
>>> We batch unmap anonymous lazyfree folios by folio_unmap_pte_batch.
>>> If the batch has a mix of writable and non-writable bits, we may end up
>>> setting the entire batch writable. Fix this by respecting writable bit
>>> during batching.
>>> Although on a successful unmap of a lazyfree folio, the soft-dirty bit is
>>> lost, preserve it on pte restoration by respecting the bit during batching,
>>> to make the fix consistent w.r.t both writable bit and soft-dirty bit.
>>>
>>> I was able to write the below reproducer and crash the kernel.
>>> Explanation of reproducer (set 64K mTHP to always):
>>>
>>> Fault in a 64K large folio. Split the VMA at mid-point with MADV_DONTFORK.
>>> fork() - parent points to the folio with 8 writable ptes and 8 non-writable
>>> ptes. Merge the VMAs with MADV_DOFORK so that folio_unmap_pte_batch() can
>>> determine all the 16 ptes as a batch. Do MADV_FREE on the range to mark
>>> the folio as lazyfree. Write to the memory to dirty the pte, eventually
>>> rmap will dirty the folio. Then trigger reclaim, we will hit the pte
>>> restoration path, and the kernel will crash with the following trace:
>>>
>>> [   21.134473] kernel BUG at mm/page_table_check.c:118!
>>> [   21.134497] Internal error: Oops - BUG: 00000000f2000800 [#1]  SMP
>>> [   21.135917] Modules linked in:
>>> [   21.136085] CPU: 1 UID: 0 PID: 1735 Comm: dup-lazyfree Not tainted 7.0.0-rc1-00116-g018018a17770 #1028 PREEMPT
>>> [   21.136858] Hardware name: linux,dummy-virt (DT)
>>> [   21.137019] pstate: 21400005 (nzCv daif +PAN -UAO -TCO +DIT -SSBS BTYPE=--)
>>> [   21.137308] pc : page_table_check_set+0x28c/0x2a8
>>> [   21.137607] lr : page_table_check_set+0x134/0x2a8
>>> [   21.137885] sp : ffff80008a3b3340
>>> [   21.138124] x29: ffff80008a3b3340 x28: fffffdffc3d14400 x27: ffffd1a55e03d000
>>> [   21.138623] x26: 0040000000000040 x25: ffffd1a55f7dd000 x24: 0000000000000001
>>> [   21.139045] x23: 0000000000000001 x22: 0000000000000001 x21: ffffd1a55f217f30
>>> [   21.139629] x20: 0000000000134521 x19: 0000000000134519 x18: 005c43e000040000
>>> [   21.140027] x17: 0001400000000000 x16: 0001700000000000 x15: 000000000000ffff
>>> [   21.140578] x14: 000000000000000c x13: 005c006000000000 x12: 0000000000000020
>>> [   21.140828] x11: 0000000000000000 x10: 005c000000000000 x9 : ffffd1a55c079ee0
>>> [   21.141077] x8 : 0000000000000001 x7 : 005c03e000040000 x6 : 000000004000ffff
>>> [   21.141490] x5 : ffff00017fffce00 x4 : 0000000000000001 x3 : 0000000000000002
>>> [   21.141741] x2 : 0000000000134510 x1 : 0000000000000000 x0 : ffff0000c08228c0
>>> [   21.141991] Call trace:
>>> [   21.142093]  page_table_check_set+0x28c/0x2a8 (P)
>>> [   21.142265]  __page_table_check_ptes_set+0x144/0x1e8
>>> [   21.142441]  __set_ptes_anysz.constprop.0+0x160/0x1a8
>>> [   21.142766]  contpte_set_ptes+0xe8/0x140
>>> [   21.142907]  try_to_unmap_one+0x10c4/0x10d0
>>> [   21.143177]  rmap_walk_anon+0x100/0x250
>>> [   21.143315]  try_to_unmap+0xa0/0xc8
>>> [   21.143441]  shrink_folio_list+0x59c/0x18a8
>>> [   21.143759]  shrink_lruvec+0x664/0xbf0
>>> [   21.144043]  shrink_node+0x218/0x878
>>> [   21.144285]  __node_reclaim.constprop.0+0x98/0x338
>>> [   21.144763]  user_proactive_reclaim+0x2a4/0x340
>>> [   21.145056]  reclaim_store+0x3c/0x60
>>> [   21.145216]  dev_attr_store+0x20/0x40
>>> [   21.145585]  sysfs_kf_write+0x84/0xa8
>>> [   21.145835]  kernfs_fop_write_iter+0x130/0x1c8
>>> [   21.145994]  vfs_write+0x2b8/0x368
>>> [   21.146119]  ksys_write+0x70/0x110
>>> [   21.146240]  __arm64_sys_write+0x24/0x38
>>> [   21.146380]  invoke_syscall+0x50/0x120
>>> [   21.146513]  el0_svc_common.constprop.0+0x48/0xf8
>>> [   21.146679]  do_el0_svc+0x28/0x40
>>> [   21.146798]  el0_svc+0x34/0x110
>>> [   21.146926]  el0t_64_sync_handler+0xa0/0xe8
>>> [   21.147074]  el0t_64_sync+0x198/0x1a0
>>> [   21.147225] Code: f9400441 b4fff241 17ffff94 d4210000 (d4210000)
>>> [   21.147440] ---[ end trace 0000000000000000 ]---
>>>
>>>
>>> #define _GNU_SOURCE
>>> #include <stdio.h>
>>> #include <unistd.h>
>>> #include <stdlib.h>
>>> #include <sys/mman.h>
>>> #include <string.h>
>>> #include <sys/wait.h>
>>> #include <sched.h>
>>> #include <fcntl.h>
>>>
>>> void write_to_reclaim() {
>>>     const char *path = "/sys/devices/system/node/node0/reclaim";
>>>     const char *value = "409600000000";
>>>     int fd = open(path, O_WRONLY);
>>>     if (fd == -1) {
>>>         perror("open");
>>>         exit(EXIT_FAILURE);
>>>     }
>>>
>>>     if (write(fd, value, sizeof("409600000000") - 1) == -1) {
>>>         perror("write");
>>>         close(fd);
>>>         exit(EXIT_FAILURE);
>>>     }
>>>
>>>     printf("Successfully wrote %s to %s\n", value, path);
>>>     close(fd);
>>> }
>>>
>>> int main()
>>> {
>>>         char *ptr = mmap((void *)(1UL << 30), 1UL << 16, PROT_READ | PROT_WRITE,
>>>                          MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
>>>         if ((unsigned long)ptr != (1UL << 30)) {
>>>                 perror("mmap");
>>>                 return 1;
>>>         }
>>>
>>>         /* a 64K folio gets faulted in */
>>>         memset(ptr, 0, 1UL << 16);
>>>
>>>         /* 32K half will not be shared into child */
>>>         if (madvise(ptr, 1UL << 15, MADV_DONTFORK)) {
>>>                 perror("madvise madv dontfork");
>>>                 return 1;
>>>         }
>>>
>>>         pid_t pid = fork();
>>>
>>>         if (pid < 0) {
>>>                 perror("fork");
>>>                 return 1;
>>>         } else if (pid == 0) {
>>>                 sleep(15);
>>>         } else {
>>>                 /* merge VMAs. now first half of the 16 ptes are writable, the other half not. */
>>>                 if (madvise(ptr, 1UL << 15, MADV_DOFORK)) {
>>>                         perror("madvise madv fork");
>>>                         return 1;
>>>                 }
>>>                 if (madvise(ptr, (1UL << 16), MADV_FREE)) {
>>>                         perror("madvise madv free");
>>>                         return 1;
>>>                 }
>>>
>>>                 /* dirty the large folio */
>>>                 (*ptr) += 10;
>>>
>>>                 write_to_reclaim();
>>>                 // sleep(10);
>>>                 waitpid(pid, NULL, 0);
>>>
>>>         }
>>> }
>>>
>>> Fixes: 354dffd29575 ("mm: support batched unmap for lazyfree large folios during reclamation")
>>> Cc: stable <stable@kernel.org>
>>> Signed-off-by: Dev Jain <dev.jain@arm.com>
>>> ---
>>> v1->v2:
>>>  - Just respect the writable bit instead of hacking in a pte_wrprotect() in
>>>    failure path
>>>  - Also handle soft-dirty bit
>>>
>>> Based on mm-unstable (df9c51269a5e).
>>>
>>>  mm/rmap.c | 12 +++++++++++-
>>>  1 file changed, 11 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/mm/rmap.c b/mm/rmap.c
>>> index bff8f222004e4..fb64829913052 100644
>>> --- a/mm/rmap.c
>>> +++ b/mm/rmap.c
>>> @@ -1955,7 +1955,17 @@ static inline unsigned int folio_unmap_pte_batch(struct folio *folio,
>>>         if (userfaultfd_wp(vma))
>>>                 return 1;
>>>
>>> -       return folio_pte_batch(folio, pvmw->pte, pte, max_nr);
>>> +       if (!folio_test_anon(folio))
>>> +               return folio_pte_batch(folio, pvmw->pte, pte, max_nr);
>>> +
>>> +       /*
>>> +        * For anon folios, if unmap fails, we need to restore the ptes.
>>> +        * To avoid accidentally upgrading write permissions for ptes that
>>> +        * were not originally writable, and to avoid losing the soft-dirty
>>> +        * bit, use the appropriate FPB flags.
>>> +        */
>>> +       return folio_pte_batch_flags(folio, vma, pvmw->pte, &pte, max_nr,
>>> +                                    FPB_RESPECT_WRITE | FPB_RESPECT_SOFT_DIRTY);
>>
>> Do we really need to differentiate between file and anon?
>> I’d rather just return unconditionally by removing the
>> if (!folio_test_anon(folio)) check above.
>>
>> If we do want to keep two branches, why not use a flag variant instead?
> 
> I suspect Dev's code might generate better code, as the compiler might
> not want to provide two variants of folio_pte_batch_flags() where it
> propagates all constants; and even if it does, we'd end up with two
> essentially identical functions in the kernel binary.

Interesting.

> 
> So if we want to special-case anon folios, I think we should use Dev's
> variant.
> 
> But I also wonder whether we just want to keep it simple for now and
> just unconditionally check FPB_RESPECT_WRITE | FPB_RESPECT_SOFT_DIRTY.
> 
> I'd vote for simplicity at this point.

Fair enough. I'll do that.

> 


