Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6CE21C79F99
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 17:06:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 77A6F6B0093; Mon,  7 Sep 2026 13:06:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 751CF6B0098; Mon,  7 Sep 2026 13:06:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 66EE96B0093; Mon,  7 Sep 2026 13:06:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 481F76B0093
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 13:06:19 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id CF2C71201E9
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 17:06:18 +0000 (UTC)
X-FDA: 85187594436.22.B12519A
Received: from mta0.migadu.com (out-201.mta0.migadu.com [91.218.175.201])
	by imf29.hostedemail.com (Postfix) with ESMTP id 49D2A12000B
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 17:06:15 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=VcdN1Wmr;
	spf=pass (imf29.hostedemail.com: domain of zenghui.yu@linux.dev designates 91.218.175.201 as permitted sender) smtp.mailfrom=zenghui.yu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788800777;
	b=lVcQFWLxh8FygMX121cCirgJL/YRaB0QMSI7oKetuKP7n3rXJF9W3EyqNK/20mXJf1cBH4
	DtV4ZU4zmYiL31UGQ9yeHXG7Q9rohBqUdWqeobxyHlTIb5ByLboQMGga7MLKNDeoyXXR4Y
	snr1yeYV10hfkaeJ7uhS0v54MnWzDSI=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=VcdN1Wmr;
	spf=pass (imf29.hostedemail.com: domain of zenghui.yu@linux.dev designates 91.218.175.201 as permitted sender) smtp.mailfrom=zenghui.yu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788800777;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xEUWJ4sRIjPDNIuZ5EWvJo6VIvPBo4FLGjlnaCggPCQ=;
	b=1WOsZaFLVIzkEk8oTA70uO/tOz0UEpd/5cmBirbu/907Hk2mxefRpr51O7pGIS2VUOAWAP
	Lf68p3uOQc3r3Hn4f/kjdHsu/TqWDjgOwR4zpo2nAFAhTbLJrFgnC3J3kXqfzWoX/KJZDA
	J6K1v+xPKnm+E8HsSkfoMEjYtKd2YSA=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=7pByG30llvEWWSce4UCN2bXV3w2mwOr+4zGW6Pv3EaM=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788800767; v=1; x=1789405567;
 b=VcdN1WmrOrPCtLseFfeYX7tkR7IbS93f0Xm0+OxoJN1g4jH8KPa/wbyot+eC4JAEeQYC6ErR
 ugJKx3xs0CIFuLwzrpbmEImHDKIXqI6+3zCkGTGMW4P/bHtUaCsUa1OF9AXOb66+ozr96DjTbOp
 AcCyrfGkAI3tg3JVXoEsU6IE=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 22398892ef57cd52;
	Mon, 07 Sep 2026 17:05:57 +0000
X-Mizu-Trace-ID: 22398892ef57cd52
X-Migadu-Flow: FLOW_OUT
Message-ID: <fe1ec84e-31df-408b-961a-6d79848bff9c@linux.dev>
Date: Tue, 8 Sep 2026 01:05:49 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/memory: fix hugetlb_zap_begin() call in
 zap_vma_range_batched()
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@kernel.org>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20260904000028.149656-1-sj@kernel.org>
 <20260903173540.e8f660dcaf083946417cba3e@linux-foundation.org>
Content-Language: en-US
From: Zenghui Yu <zenghui.yu@linux.dev>
In-Reply-To: <20260903173540.e8f660dcaf083946417cba3e@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: 5hmdcomk3nq5wu8jerou47itj94cic8z
X-Rspamd-Queue-Id: 49D2A12000B
X-Rspamd-Server: rspam06
X-HE-Tag: 1788800775-700112
X-HE-Meta: U2FsdGVkX184dfyHWzx13xraAhNpSvrXNUoxa0+7aK3EqwFiUmQOKKC2p9RPKFTUCX+n9sV8Dtx8pg0FVMaug1JfC4eVwNCX9ZBZCK1KWjlS6LSIHveUaXFXRRvG4bnCRKjA4mE6lo0m7nGBAr7jldxuh4lPB8oNJRlT/2UnyljdVN4Ya6nkeFAdz3X5gofZ8kggT04rK39HV10LtrBrF0wWLg2iKp0WwXuGNjY2rvmok/ne3VJ57X2ABqQeV9pUk3NNHyeF/+MAojlER0nYbVJ0KKvW5lEto1c9pATG6RU6l+ZzoBiTR3cGZvfpCrO95eJtP8qFITXh0sJ8zSTgoOqKBTGLmHk46dA8w9OGcNzzvYL5yUkSZTVXf21pahjnrJSbFvdeNHjHvU3J5gsEvtR5H2wvt7YyR1RnNwul1q24Vwuwtxkxn1AaxFj5iFNBNCID0aPKO2hkEN5N6mfKwhtRmB1za0SqJDnk1IA6DAX3dL+uZ/CwRmqi8Oio2R23TcwR10iUlhG7S8cdT1xpHrPH2kkZBLFqd8+2vDEYOeFdJMp18Vos+GEbp7uxdPUcynZ6BEn2ntgrK3JMjM9r1tSwhodgyhIXsSZexgQ31PZBpxbo/Ps458G7yR/0zIXxpi5TZu0eVj42MlufWxQv/wJX9Mzfr/fg77elMgik5jVlMLDOq3VDCNAyJEiG7I9jUxYTox5gz1t/IKWFV5pffzHBn/avSvNzfsCVComc1efKLQrny2P8Agnp0QcjVlFQ8iwhQk6L9W++2j8Df3DJV7+YQ2Vihm4BEnp+mfndDnv25Xy0j1GidJgDh2jVhu7sRJpm4fV0AlIO1JUGDtSW4PB3KY0d76hTXwRvpp1twn+QuQShluXRorknrdp7Lbu15LJfgwfw2uIdGVkg8r9FpkfIh0xFGmLnjWsCJ03P0SBEqATP8xNdtgMaKT8PcF3nu4IcQGrIJoNkfcfiN0n
 obbE46A8
 BL8xczJvLlSji6w1Y7rZ43Dj9FdGPgPvU6MgV48+LfUbvQw7JXLHqQZsUFjJY8IIFqtVZZwuUq3dCNnsmccdRTX0v92s3JbqImbZcN0XX7SleaUAZES1YF/dhGr4Nj6AmueX8sOhlz7z1rJbAoXDjDthOz0W0inwkfQcENDi+s4/xd+SRz80yv2ARnMmFtSM/gST52kYy5bTm6c6eZUgDWx10xmV7t5mRgG3pIDCmxJ58k1iKTpSH5gIImnz2KgrU40qQL9mcI4xNtyTb49QxO9j1VliKQQJrXzVlGjaq6MJj5QwpgEn90dZdPEmCK0PCPXe6EDsdy1mb2JYgcIVNOcGonSgLHyv4jYggjDqPjavLKEINAsJu0shAef7cwtO0p+T+JQorf06zkdVXRsITeYfEb+ocE2CkvZyqg3Tgb/Jla4azV5tTCaTusyqkP7+9vEAvuGPnHCd1FaOv5MGR+i5L/IBCkDtArDPsx4QyGIaHXHOQvABzSULJsgIDUw0H5a+IqrbmCPCNtCc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/4/26 8:35 AM, Andrew Morton wrote:
> On Thu,  3 Sep 2026 17:00:26 -0700 SJ Park <sj@kernel.org> wrote:
> 
> > I didn't read the broken commit in depth.  This fix is only
> > build-tested.  I wanted to report the issue with this as a temporal fix,
> > but the broken commit doesn't have Link: tag.  So directly posting this
> > temporal and not very well verified fix first.
> 
> Yeah, this is possible fix for
> https://syzkaller.appspot.com/bug?extid=bd6aaf99e8443d8a9034 which I
> had chatgpt create for me.  It's in limbo at present until I figure out
> what to do with it.  Actually I'll hide it from others while figuring-out
> happens.
> 
> 
> 
> For the morbidly curious.  It's really only a 2-line change, plus a bunch
> of changes to pass the zap_details down to  __hugetlb_zap_begin().
> 
> 
> 
> From: Andrew Morton <akpm@linux-foundation.org>
> Subject: mm/hugetlb: don't lock private resv_map during final unmap

FYI this causes the following warn when running selftests:

 ------------[ cut here ]------------
 DEBUG_RWSEMS_WARN_ON((rwsem_owner(sem) != current) && !rwsem_test_oflags(sem, RWSEM_NONSPINNABLE)): count = 0x0, magic = 0xffff8000059ff478, owner = 0x0, curr 0xffff800104a29000, list not empty
 WARNING: kernel/locking/rwsem.c:1412 at up_write+0x1f4/0x25c, CPU#6: pagemap_ioctl/1352
 Modules linked in: rfkill fuse virtio_gpu drm_client_lib virtio_dma_buf drm_shmem_helper drm_kms_helper drm
 CPU: 6 UID: 0 PID: 1352 Comm: pagemap_ioctl Kdump: loaded Tainted: G                 N  7.3.0-rc1+ #70 PREEMPT 
 Tainted: [N]=TEST
 Hardware name: QEMU QEMU Virtual Machine, BIOS edk2-stable202408-prebuilt.qemu.org 08/13/2024
 pstate: 61400005 (nZCv daif +PAN -UAO -TCO +DIT -SSBS BTYPE=--)
 pc : up_write+0x1f4/0x25c
 lr : up_write+0x1f4/0x25c
 sp : ffffc0008903bab0
 x29: ffffc0008903bab0 x28: ffff800104a29000 x27: 0000000000000000
 x26: 0000000000000000 x25: 0000000000000000 x24: 0000000000000000
 x23: ffff800104a29000 x22: ffffc000826254d0 x21: ffffc0008903bc68
 x20: ffffc00081eb6000 x19: ffff8000059ff478 x18: 0000000000000020
 x17: ffffc000800da3a8 x16: ffffc000800d971c x15: 00000000ffffffff
 x14: 0000000000000aab x13: ffffc00081edca98 x12: 0000000000002001
 x11: ffffffffffe26460 x10: ffffc00081edca98 x9 : 0000000000000006
 x8 : 0000000000000003 x7 : ffffc0008903b800 x6 : ffffc0008018bf04
 x5 : ffff8001eeb7d208 x4 : ffff8001eeb7d280 x3 : 0000000000000001
 x2 : 0000000000000000 x1 : 0000000000000000 x0 : ffff800104a29000
 Call trace:
  up_write+0x1f4/0x25c (P)
  __hugetlb_zap_end+0x58/0xfc
  unmap_vmas+0xbc/0x178
  exit_mmap+0xbc/0x4d0
  __mmput+0x58/0x154
  mmput+0x50/0x5c
  do_exit+0x2bc/0xd00
  do_group_exit+0x34/0x90
  pid_child_should_wake+0x0/0x5c
  invoke_syscall+0x54/0x110
  el0_svc_common.constprop.0+0x40/0xe0
  do_el0_svc+0x1c/0x28
  el0_svc+0x54/0x424
  el0t_64_sync_handler+0xa0/0xe4
  el0t_64_sync+0x1b0/0x1b4
 irq event stamp: 0
 hardirqs last  enabled at (0): [<0000000000000000>] 0x0
 hardirqs last disabled at (0): [<ffffc000800ce3a8>] copy_process+0x8f8/0x2078
 softirqs last  enabled at (0): [<ffffc000800ce3b0>] copy_process+0x900/0x2078
 softirqs last disabled at (0): [<0000000000000000>] 0x0
 ---[ end trace 0000000000000000 ]---

Thanks,
Zenghui

