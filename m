Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F416ECCF9E5
	for <linux-mm@archiver.kernel.org>; Tue, 28 Oct 2025 01:31:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5B5AB800F8; Mon, 27 Oct 2025 21:31:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 58D72800E4; Mon, 27 Oct 2025 21:31:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A27A800F8; Mon, 27 Oct 2025 21:31:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 35D90800E4
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 21:31:10 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id DCF91583AD
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 01:31:09 +0000 (UTC)
X-FDA: 84045794658.14.FA46B7D
Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	by imf29.hostedemail.com (Postfix) with ESMTP id C0301120010
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 01:31:07 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=AZrA9CZ8;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf29.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=hao.ge@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761615068; a=rsa-sha256;
	cv=none;
	b=dDFFWMoq8bOfBJdHNTLg9jGd/e7hy1bpOrdwC83OMYAmh6E7K8G09xGGCfRrCammgBtXsH
	H+XtP/eQBd6hs4+wWDg6TL2boBiibv7Fun3ttOA6iyFnZR8CTGyTGpXdyDrBo1g0vJj84L
	r2SHXYNOou7YDe2WYnLOPbmxBbKv4nw=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=AZrA9CZ8;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf29.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=hao.ge@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761615068;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jaIt633eAP7KGxsK5T68EHA/o2eXULV4yMK/ZNwmf18=;
	b=xxEsij5f5mT3wdfBxeM6vgbVgO5+dC04bs+rymTAL7hzdjiBbsU9qdko3L7nNawppUcGY0
	Z6ASG4P5Z9ZTr0KfC3qFncmMApaRarl9bjlXOsMVkeoEA18u7IPWSC8PfE6MDg7SfTIAnz
	HhqW2hpUVTBC7Bvnfw0Hzx+tvYmOcfY=
Message-ID: <d1456749-46c3-463f-bc28-f465b8ce6ff9@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1761615065;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jaIt633eAP7KGxsK5T68EHA/o2eXULV4yMK/ZNwmf18=;
	b=AZrA9CZ8zaLV3oHH56twk/U0DAo8803bkJYA6VrdkiV3bFvbQD8HKCFQM1W7VZei0WaPWf
	0SsIJ00iE+vNo24UcZOi3/N1k7Qo38RqkXsYCfCtCtEqSLliAQteOxvubK2seYhhHmH/7n
	jgrzqbEmadrOvoUPKJ1eSNYBL5ivPOU=
Date: Tue, 28 Oct 2025 09:30:14 +0800
MIME-Version: 1.0
Subject: Re: [PATCH] codetag: debug: Handle existing CODETAG_EMPTY in
 mark_objexts_empty for slabobj_ext
To: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>,
 Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter
 <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, Harry Yoo <harry.yoo@oracle.com>,
 Shakeel Butt <shakeel.butt@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Hao Ge <gehao@kylinos.cn>
References: <20251027085214.184672-1-hao.ge@linux.dev>
 <CAJuCfpF+0ok85A1ZhbptSzrB-X6CUj=TMj9ZvwzjV1tO5PqFbA@mail.gmail.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Ge <hao.ge@linux.dev>
In-Reply-To: <CAJuCfpF+0ok85A1ZhbptSzrB-X6CUj=TMj9ZvwzjV1tO5PqFbA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: u73wjj5pfpcaty5rx6knztxz45z6hpk5
X-Rspamd-Queue-Id: C0301120010
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1761615067-208110
X-HE-Meta: U2FsdGVkX18jrguj0TMOMFcBluA8ph/8MvSDbgLZpXTSTlhuNsG2k1yeWOYX13unFWtsSGjclqemPJZfedPZZVZ4RvvKkC437WmFKjM4Og1VpFFyJ1ywOrps1JJRt8wReSXrYE+3KULWc+aIORh1BBlhNAj2NQFeNRhxKK0bxWkLx3zz7RjLFtK8leUTkyGjsvX1GZLowzV3p5a4W3rqzYb+xW/chx5q0j/7TWfO1BiOvwKe0pkkdoD6FWPm8PglayVdF8opCV1dKI0T6ta78lDKIMj/XepRw7KUjrLPdodDtPN2aEWR0EAA5JAWn3NrAxH8NEC6CkE8+LfwNlnD2MNzCBNO5uGqCN50oFJz4RLSI/WTrg7zEmPuRfgp0fghdOzY6C7OZz4GtAASDei2Y1ZGUX7Kse7SWSbY/zlR7Xss4DjjfVdeg+sZuPppZY/EFh6x4xZ93kFaz6Iky/FB6D4Feog9+3hOpQfirdnxtoznDvjtQGCVwp4qwALtElgSfeeIELe3wh/Dfl4m0d32/jANhG6chRSPp11T9wHfbFAaET18i14OOVNFzXEg5vez6SokxJ6AD5GONDcEeBLWOSkOgI8fvOiVI+SroFGUotPRuZzTTr3TA7FArXkcqIppPScrQ6xXdHO4L+pXg+KhTBGFR7pietu2c+EdJCF6yH2rFHh9OmxhR7fUfr6zhTEB1ehHtC8nO295q+UPJfdmuBGQHDjuyl7xBqDsgdWD2Y6C4IUd+YOY/Jlmu5OFN0Aq3FV3MjSWeWWIMHUTkEB7o74Y3NnaD3T80U77L3JscQorCOfdde3qUlyu75WpVsdpmcHiIWa4RwLs5wsQSbb6jWes5aXn2mXZ22WsMAnHcVsGyGiia9NarSQKGHcS4jc6kNBOehC9FcEly4AJVWMnNyWEFvGoFA5F8WjNdoLmC4OvmqzqzPH4N7Fxufth618eWRpI7p0hiyl9gtnnsLU
 CdCN+f/R
 yFAaj7s33DVdrEOCFjBy3TAWNVok1LgN81nRdlgv96jOCIgDaYEdqkIx3C43c/ZlHLbZ2bymdCdUa554jMDvCgSMhCTq5bKLWZrEoLQjBMSv2YZ+DdTSug1ZQTQyHDzxTVannq4ctPiN71PjfKfF4BH8iIO7HBRihXbkmATE2eRuZWlMayRT3LNpf/MpYytk3ULfWY5VnxhR/HcIZ05x/uUq8VWauGL3qFd7S886+loCCrpbQfXNKZuJw2hJfkLQtD4T5V5BlxGEZP/RX/Ldu+OQOuQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Suren


On 2025/10/28 03:44, Suren Baghdasaryan wrote:
> On Mon, Oct 27, 2025 at 1:53 AM Hao Ge <hao.ge@linux.dev> wrote:
>> From: Hao Ge <gehao@kylinos.cn>
>>
>> Even though obj_exts was created with the __GFP_NO_OBJ_EXT flag,
>> objects in the same slab may have their extensions allocated via
>> alloc_slab_obj_exts, and handle_failed_objexts_alloc may be called
>> within alloc_slab_obj_exts to set their codetag to CODETAG_EMPTY.
>>
>> Therefore, both NULL and CODETAG_EMPTY are valid for the codetag of
>> slabobj_ext, as we do not need to re-set it to CODETAG_EMPTY if it
>> is already CODETAG_EMPTY. It also resolves the warning triggered when
>> the codetag is CODETAG_EMPTY during slab freeing.
> I'm not sure what scenario leads to handle_failed_objexts_alloc() and
> mark_objexts_empty() being used against the same codetag reference.
> Could you please explain the exact scenario you hit?
>
> handle_failed_objexts_alloc() assigns CODETAG_EMPTY to the elements of
> the obj_exts vector while mark_objexts_empty() assigns CODETAG_EMPTY
> to the obj_ext of the obj_exts vector itself. In what case do these
> two calls operate on the same reference?

This issue also occurred during our memory stress testing.

I apologize for the incorrect description in my commit message:

The possibility of its occurrence should be as follows:

When a slab allocates a slabobj_ext, the slab to which this slabobj_ext 
belongs may have already allocated its own slabobj_ext

and called handle_failed_objexts_alloc. That is to say, the codetag of 
this slabobj_ext has been set to CODETAG_EMPTY.

To quickly detect this WARN, I modified the code 
from:WARN_ON(slab_exts[offs].ref.ct) to WARN_ON(slab_exts[offs].ref.ct 
== 1);

We then obtained this message:

[21630.898561] ------------[ cut here ]------------
[21630.898596] kernel BUG at mm/slub.c:2050!
[21630.898611] Internal error: Oops - BUG: 00000000f2000800 [#1] SMP
[21630.900372] Modules linked in: squashfs isofs vfio_iommu_type1 
vhost_vsock vfio vhost_net vmw_vsock_virtio_transport_common vhost tap 
vhost_iotlb iommufd vsock binfmt_misc nfsv3 nfs_acl nfs lockd grace 
netfs tls rds dns_resolver tun brd overlay ntfs3 exfat btrfs 
blake2b_generic xor xor_neon raid6_pq loop sctp ip6_udp_tunnel 
udp_tunnel nft_fib_inet nft_fib_ipv4 nft_fib_ipv6 nft_fib 
nft_reject_inet nf_reject_ipv4 nf_reject_ipv6 nft_reject nft_ct 
nft_chain_nat nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 
nf_tables rfkill ip_set sunrpc vfat fat joydev sg sch_fq_codel nfnetlink 
virtio_gpu sr_mod cdrom drm_client_lib virtio_dma_buf drm_shmem_helper 
drm_kms_helper drm ghash_ce backlight virtio_net virtio_blk virtio_scsi 
net_failover virtio_console failover virtio_mmio dm_mirror 
dm_region_hash dm_log dm_multipath dm_mod fuse i2c_dev virtio_pci 
virtio_pci_legacy_dev virtio_pci_modern_dev virtio virtio_ring autofs4 
aes_neon_bs aes_ce_blk [last unloaded: hwpoison_inject]
[21630.909177] CPU: 3 UID: 0 PID: 3787 Comm: kylin-process-m Kdump: 
loaded Tainted: G        W           6.18.0-rc1+ #74 PREEMPT(voluntary)
[21630.910495] Tainted: [W]=WARN
[21630.910867] Hardware name: QEMU KVM Virtual Machine, BIOS unknown 
2/2/2022
[21630.911625] pstate: 80400005 (Nzcv daif +PAN -UAO -TCO -DIT -SSBS 
BTYPE=--)
[21630.912392] pc : __free_slab+0x228/0x250
[21630.912868] lr : __free_slab+0x18c/0x250[21630.913334] sp : 
ffff8000a02f73e0
[21630.913830] x29: ffff8000a02f73e0 x28: fffffdffc43fc800 x27: 
ffff0000c0011c40
[21630.914677] x26: ffff0000c000cac0 x25: ffff00010fe5e5f0 x24: 
ffff000102199b40
[21630.915469] x23: 0000000000000003 x22: 0000000000000003 x21: 
ffff0000c0011c40
[21630.916259] x20: fffffdffc4086600 x19: fffffdffc43fc800 x18: 
0000000000000000
[21630.917048] x17: 0000000000000000 x16: 0000000000000000 x15: 
0000000000000000
[21630.917837] x14: 0000000000000000 x13: 0000000000000000 x12: 
ffff70001405ee66
[21630.918640] x11: 1ffff0001405ee65 x10: ffff70001405ee65 x9 : 
ffff800080a295dc
[21630.919442] x8 : ffff8000a02f7330 x7 : 0000000000000000 x6 : 
0000000000003000
[21630.920232] x5 : 0000000024924925 x4 : 0000000000000001 x3 : 
0000000000000007
[21630.921021] x2 : 0000000000001b40 x1 : 000000000000001f x0 : 
0000000000000001
[21630.921810] Call trace:
[21630.922130]  __free_slab+0x228/0x250 (P)
[21630.922669]  free_slab+0x38/0x118
[21630.923079]  free_to_partial_list+0x1d4/0x340
[21630.923591]  __slab_free+0x24c/0x348
[21630.924024]  ___cache_free+0xf0/0x110
[21630.924468]  qlist_free_all+0x78/0x130
[21630.924922]  kasan_quarantine_reduce+0x114/0x148
[21630.925525]  __kasan_slab_alloc+0x7c/0xb0
[21630.926006]  kmem_cache_alloc_noprof+0x164/0x5c8
[21630.926699]  __alloc_object+0x44/0x1f8
[21630.927153]  __create_object+0x34/0xc8
[21630.927604]  kmemleak_alloc+0xb8/0xd8
[21630.928052]  kmem_cache_alloc_noprof+0x368/0x5c8
[21630.928606]  getname_flags.part.0+0xa4/0x610
[21630.929112]  getname_flags+0x80/0xd8
[21630.929557]  vfs_fstatat+0xc8/0xe0
[21630.929975]  __do_sys_newfstatat+0xa0/0x100
[21630.930469]  __arm64_sys_newfstatat+0x90/0xd8
[21630.931046]  invoke_syscall+0xd4/0x258
[21630.931685]  el0_svc_common.constprop.0+0xb4/0x240
[21630.932467]  do_el0_svc+0x48/0x68
[21630.932972]  el0_svc+0x40/0xe0
[21630.933472]  el0t_64_sync_handler+0xa0/0xe8
[21630.934151]  el0t_64_sync+0x1ac/0x1b0
[21630.934923] Code: aa1803e0 97ffef2b a9446bf9 17ffff9c (d4210000)
[21630.936461] SMP: stopping secondary CPUs
[21630.939550] Starting crashdump kernel...
[21630.940108] Bye!

>> Fixes: 09c46563ff6d ("codetag: debug: introduce OBJEXTS_ALLOC_FAIL to mark failed slab_ext allocations")
>> Signed-off-by: Hao Ge <gehao@kylinos.cn>
>> ---
>>   mm/slub.c | 12 +++++++++++-
>>   1 file changed, 11 insertions(+), 1 deletion(-)
>>
>> diff --git a/mm/slub.c b/mm/slub.c
>> index d4367f25b20d..cda8f75b72e7 100644
>> --- a/mm/slub.c
>> +++ b/mm/slub.c
>> @@ -2046,7 +2046,17 @@ static inline void mark_objexts_empty(struct slabobj_ext *obj_exts)
>>          if (slab_exts) {
>>                  unsigned int offs = obj_to_index(obj_exts_slab->slab_cache,
>>                                                   obj_exts_slab, obj_exts);
>> -               /* codetag should be NULL */
>> +
>> +               /*
>> +                * codetag should be either NULL or CODETAG_EMPTY.
>> +                * When the same slab calls handle_failed_objexts_alloc,
>> +                * it will set us to CODETAG_EMPTY.
>> +                *
>> +                * If codetag is already CODETAG_EMPTY, no action is needed here.
>> +                */
>> +               if (unlikely(is_codetag_empty(&slab_exts[offs].ref)))
>> +                       return;
>> +
>>                  WARN_ON(slab_exts[offs].ref.ct);
>>                  set_codetag_empty(&slab_exts[offs].ref);
>>          }
>> --
>> 2.25.1
>>

