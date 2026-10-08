Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6E161CA6004
	for <linux-mm@archiver.kernel.org>; Thu,  8 Oct 2026 03:16:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AC16C6B008A; Wed,  7 Oct 2026 23:16:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A99FC6B008C; Wed,  7 Oct 2026 23:16:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9AF546B0092; Wed,  7 Oct 2026 23:16:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6DD756B008A
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 23:16:49 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E1D45A7703
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 03:16:46 +0000 (UTC)
X-FDA: 85297996812.16.A2AAAD1
Received: from out30-110.freemail.mail.aliyun.com (out30-110.freemail.mail.aliyun.com [115.124.30.110])
	by imf04.hostedemail.com (Postfix) with ESMTP id 2760C40009
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 03:16:42 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=lJdtan7X;
	spf=pass (imf04.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.110 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791429405;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gYC58sdTkm8+Fm/Mk5bZ1bqmLj44HUBXCl/MsXafSqk=;
	b=jePly2c+tYl3/2ByleQBGp2WtSPKl7AYypr650W38vGU33J8WxwPHqO+DFH6lnTmbS8ant
	XrV6iQrU7Yd3WXRrWY6/wG6/tx8C2qnbBm6CrT/RyJkdpy0N3bH3ISDuT5Egk2YZgcBKpj
	as8VBd+N4swZchNrTVEhvTYiQQokIdQ=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=lJdtan7X;
	spf=pass (imf04.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.110 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791429405;
	b=NoMlSGQE8J6kVwEtYM1BPHswduPfCvKk4nk6zUw4PK3JDnSA8HgFDjYoPgpJgujmZPRuW+
	RrrDKujAk9hEN7dAMMX9U/doAWcmmW6WrxHos5KqNwDJkakOPiR1wwI3Y7W9dmrXIhF9yr
	+88V25M8bN4lfl+NGTm3p3UuloBB4/8=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1791429399; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=gYC58sdTkm8+Fm/Mk5bZ1bqmLj44HUBXCl/MsXafSqk=;
	b=lJdtan7XmHluQ+X9XUxobhhyzSdYhlvrnkkODs43A2Of3w2E95HGNsdeASz9/MDjFzAEEEAH1UFkyMROieLFPO8F5ws9G81r9JB7Guw4rL4R+O3gARq8wA9DLCU46crwE902lqKpupWlINPHK9Du6zdv6ieivOGgYYJbjkK8A38=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=16;SR=0;TI=SMTPD_---0XCJIB-._1791429397;
Received: from 30.74.144.149(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XCJIB-._1791429397 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 08 Oct 2026 11:16:38 +0800
Message-ID: <b1aaff8f-c4b1-4c2c-939e-7051e7f9b6b8@linux.alibaba.com>
Date: Thu, 8 Oct 2026 11:16:36 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: Make swapoff interruptible when unusing mms/shmem
To: Chris Down <chris@chrisdown.name>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Hugh Dickins <hughd@google.com>, Chris Li <chrisl@kernel.org>,
 Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>,
 Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>,
 Ying Huang <huang.ying.caritas@gmail.com>,
 Kelley Nielsen <kelleynnn@gmail.com>,
 Vineeth Pillai <vineeth@bitbyteword.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, kernel-team@meta.com
References: <ar2YlFYjYUZ49ZA5@chrisdown.name>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <ar2YlFYjYUZ49ZA5@chrisdown.name>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 2760C40009
X-Stat-Signature: zmo8wjmiq3nzqkuro99he9bqq9ry3kw6
X-HE-Tag: 1791429402-750624
X-HE-Meta: U2FsdGVkX18FJimHWZwG7Ho4IAAr2Mhw7jq9HVF3BslUux6+eialtJx+hNHgp8u4HlvOL6GlrZgndBbZ0pZH7bMPyXtIGc6kKmHOYoOvcpUsBryxMbdHMu9wcB7K/LaoONVjlXncLVvVCGDDociv0M/T9Hg3LjJWoaGXJ/CvX1rgXuJv/RRdOZz1Gq+UKyBbJXgsZv5TkJkeTgFXa1fBDIoA0FpwTWPaF9MqNHhVRqweYUchYC5/Zrp81sHs62pf3hd2RNAs7Jg+BKbo1gC/znn54W0ENFj4rhtinAG+xbHkBoA5lFPdqzabGww0Q5GgAlGhJSieFY/mSd/pVK1bzaXmxOBmtA0cD/Ruij4CszuTk4c8xlixmRag++LutewNXAqI14zthITMmvgGeJl2AihfUxWLttRJscFTL95ryJJi5Zxwg6vAC13wiwvS54iljHkfXfIyQxRi2TJO804KSgpb3YPEQpu8tBL8pztZxm89s9VldGFoYzzP+CHbcuf+hg5RxoGJ0YDN7bnoa9EDOK7fwUbw44tEso+i8awZsfj0gaEw3gJR/51+zKfyCBukZzauY55ZHbbGFFzW5/KJloth7+lsEF3ahVwHjB+x6QvWhFuoPM99saRMQ/lxIx+OIX6ndpcjRbNlzI3nvlPC/j+f+iean47ePIA3wpfSe6huSEa6gwwRtcnBCpNj7Gcj9dG9PDd3mzyF9UlaaDI9+ijP6yqNR1uIf5D8KhXNrz12JKMszwIpkGJVR+se+OB0zztMPdIerjqlUAAAKwW1IcaiPMnOzpp/LTyVbGAzU1KhZV8wavWpIYekibgIojj+epIoSUSCPG9VmA5OVWPnBdV2859KgDerNAQpkr4PS38EROKC5uDQ6gdQHvEk+ehoo5xQBLAWwdE1Lzsvjlo6O5Gz3vNfG6x7U2c2HeX3EGQ5H8iMj7cZbARNHfzDTw8+XnyIendVLg2kjEVUPDr
 conyk0wb
 wqrYBH5vR6UFtbfAVOyiXksZJ25c9Y7fbZvu/9RkBpz16RjiSkc2lbvUXaCchB1cJZvuRamCrKTWEDNY58PotTkMUJeDmRGVbyBEgtOG6jqXVOkI2w+K2FL7IlMvoztWA/uYpjyoDcdwiyiqUSJGn6ew9z2UF822aF2zjVnaMJeS6gBsIYyQtpWgTx+z/dqORPXfjh/ulC8lyplFpT2d4t2PGByDRCvdm2RRBQf/k2w1soHYuY4bp/JqbQPFz2p0AScsAfRqvkgTqcWnMHxcIGffpEkUXDG5/Y+2A4SgL7YyeFEoNIdmHvYixrJq51kbb39ePdC5FTrdSXhmtEVipLRV8Gtgc2NTO4TuhWiGonSl3JqXE7ezzdYYVAZq45smAZ0SbH4ju68/8iN5icHAZioCCxMZi9ICCDt/WvOgFf0mZpPiPyCkFJlDxtA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 10/1/26 7:17 AM, Chris Down wrote:
> try_to_unuse() only checks for a pending signal between mms, and
> shmem_unuse() doesn't check at all. That means that once swapoff gets to
> a process or a shmem file with a lot swapped out, nothing can interrupt
> it until every last page of it has been read back in.
> 
> Just as one example of where this can concretely show up, freezing tasks
> for suspend or hibernation has to wait for swapoff to notice the
> freezer's fake signal, and gives up after freeze_timeout_msecs (20
> seconds by default).
> 
> Here's a facetious example where one swaps out 2GiB of one process to a
> swap file on ext4, starts swapoff, and half a second later tries to
> freeze with pm_test=freezer. Writing to /sys/power/state then fails with
> EBUSY and this in dmesg:
> 
>      Freezing user space processes failed after 20.003 seconds (1 tasks refusing to freeze, wq_busy=0):
>      task:swapoff         state:D stack:0     pid:3175  tgid:3175  ppid:2955   task_flags:0x400100 flags:0x00000419
>      Call trace:
>       [...]
>       io_schedule+0x44/0x70
>       folio_wait_bit_common+0x1ec/0x3d0
>       __folio_lock+0x24/0x40
>       unuse_pte_range+0x2d0/0x348
>       unuse_vma+0x158/0x248
>       unuse_mm+0xfc/0x150
>       try_to_unuse+0x104/0x3f8
>       __do_sys_swapoff+0x220/0x5d8
>       [...]
> 
> The same goes for anything else that wants swapoff to stop, like an
> admin hitting ^C in a panic, of course.
> 
> Prior to commit b56a2d8af914 ("mm: rid swapoff of quadratic complexity")
> try_to_unuse() was driven by find_next_to_unuse() which checks for a
> signal before every entry, so let's restore that behaviour.
> 
> Just as an example of the improvements, here's how long freezing takes
> in the same test while swapoff is happening on my computer:
> 
>                        before                  after
>      400MiB anon       8.925s                  0.028s
>      400MiB shmem      1.639s                  0.003s
>      2GiB anon         failed after 20.003s    0.011s
> 
> Fixes: b56a2d8af914 ("mm: rid swapoff of quadratic complexity")
> Signed-off-by: Chris Down <chris@chrisdown.name>
> ---

Make sense to me. But ...

>   mm/shmem.c    | 4 ++++
>   mm/swapfile.c | 2 ++
>   2 files changed, 6 insertions(+)
> 
> diff --git a/mm/shmem.c b/mm/shmem.c
> index ae08cff4500c..72c8a61db76f 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -1742,6 +1742,10 @@ static int shmem_unuse_inode(struct inode *inode, unsigned int type)
>   		if (ret < 0)
>   			break;
>   
> +		if (signal_pending(current)) {
> +			ret = -EINTR;
> +			break;
> +		}
>   		start = indices[folio_batch_count(&fbatch) - 1];
>   	} while (true);
>   
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index 254ce86fa923..c3288910b3e3 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -2689,6 +2689,8 @@ static inline int unuse_pmd_range(struct vm_area_struct *vma, pud_t *pud,
>   	pmd = pmd_offset(pud, addr);
>   	do {
>   		cond_resched();
> +		if (signal_pending(current))
> +			return -EINTR;

Should we return -ERESTARTSYS instead based on the similar issue 
discussed in the following patch?

https://lore.kernel.org/all/20260720044103.905191-1-richardycc@google.com/

>   		next = pmd_addr_end(addr, end);
>   		ret = unuse_pte_range(vma, pmd, addr, next, type);
>   		if (ret)
> 
> base-commit: 2ddb90ee544ae97215afc4698dc223293997cc43


