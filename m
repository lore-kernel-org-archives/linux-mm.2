Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5A8F0E9D408
	for <linux-mm@archiver.kernel.org>; Wed,  4 Feb 2026 16:28:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8537F6B0089; Wed,  4 Feb 2026 11:28:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8015D6B0098; Wed,  4 Feb 2026 11:28:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6E3B56B009F; Wed,  4 Feb 2026 11:28:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 5A0E16B0089
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 11:28:40 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E2632140257
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 16:28:39 +0000 (UTC)
X-FDA: 84407307558.03.27A2D6B
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf25.hostedemail.com (Postfix) with ESMTP id 5525FA000B
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 16:28:37 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Y2akqElQ;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=PpKR4Mo4;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Y2akqElQ;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=PpKR4Mo4;
	spf=pass (imf25.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770222517;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cIlYwH/D2XFaIR5fnqbXTtiNOYRPKmKUsqMiylg631c=;
	b=dMaA6n2PIGbRS8PGv/UmiTHEnzNLoHhGm0D1tzjjqk2WoIvEcAYbUv9Khp7YXXYBn0DE3X
	Cl8Ar2ptFpeXuVbS+TXZZNhVXcVwGZz9oJb/DEw67NqFCVm7WlNjBO2vIIFff/SS0g+PCD
	HXZKEabSOmy+ScMKmN05u82BHqUm15c=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Y2akqElQ;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=PpKR4Mo4;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Y2akqElQ;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=PpKR4Mo4;
	spf=pass (imf25.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770222517; a=rsa-sha256;
	cv=none;
	b=Syo4WwlOJ06f+1jEYTP9rGh7Mwhhhv1KQxNgWMpiq6mf9ml6WIA/Jz3I/E0cxvMlPOg9Zo
	jQMKWbbb8GgMJMM1Uo5Zz+Htog6osrmlnHqrKYvOS9jLnECyLS6IIwK8J7Aibgpc5kVKai
	gSe1q8OMrnXS5EqrFXKO/WLsw1fJjZU=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 836093E756;
	Wed,  4 Feb 2026 16:28:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1770222514; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=cIlYwH/D2XFaIR5fnqbXTtiNOYRPKmKUsqMiylg631c=;
	b=Y2akqElQVaiH9Djl8xeMVITW6IN4Zz7acRrU2VaYyI4v5Fz70lpiZcPoLCcQZWRs2Sfnyk
	yF4CaHPOJpPmwvg10KrIxXQP5wk38E1itwUyaH76kSSvXq9L9Oezm9f8Zd8IUlBzeB3OL8
	AvbCjYnvtnAA8EykkWeZE9HRAujHbo4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1770222514;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=cIlYwH/D2XFaIR5fnqbXTtiNOYRPKmKUsqMiylg631c=;
	b=PpKR4Mo4oHZ5v/K6/QCDOU+CM2nRgaFrVsrjS0c0I08wO0ciRoZ9itTGKgc5HptjiTNjfl
	BrVM6Hif80ZeiDAQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1770222514; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=cIlYwH/D2XFaIR5fnqbXTtiNOYRPKmKUsqMiylg631c=;
	b=Y2akqElQVaiH9Djl8xeMVITW6IN4Zz7acRrU2VaYyI4v5Fz70lpiZcPoLCcQZWRs2Sfnyk
	yF4CaHPOJpPmwvg10KrIxXQP5wk38E1itwUyaH76kSSvXq9L9Oezm9f8Zd8IUlBzeB3OL8
	AvbCjYnvtnAA8EykkWeZE9HRAujHbo4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1770222514;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=cIlYwH/D2XFaIR5fnqbXTtiNOYRPKmKUsqMiylg631c=;
	b=PpKR4Mo4oHZ5v/K6/QCDOU+CM2nRgaFrVsrjS0c0I08wO0ciRoZ9itTGKgc5HptjiTNjfl
	BrVM6Hif80ZeiDAQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 631203EA63;
	Wed,  4 Feb 2026 16:28:34 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id ZnvZF7Jzg2laUAAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Wed, 04 Feb 2026 16:28:34 +0000
Message-ID: <51489c81-1adb-4582-8564-7c97b6a1060f@suse.cz>
Date: Wed, 4 Feb 2026 17:28:34 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm/slab: Add alloc_tagging_slab_free_hook for
 memcg_alloc_abort_single
Content-Language: en-US
To: Hao Li <hao.li@linux.dev>, Hao Ge <hao.ge@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, Harry Yoo <harry.yoo@oracle.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260204101401.202762-1-hao.ge@linux.dev>
 <75a2obu7fk4t2h5wj54gkbtyie4pdenw4mzecmmsgzwbhvxfmy@7mrdfx5q5p3h>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <75a2obu7fk4t2h5wj54gkbtyie4pdenw4mzecmmsgzwbhvxfmy@7mrdfx5q5p3h>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Rspamd-Server: rspam12
X-Stat-Signature: scr697pugrc1idnkqnq6byk96twk5sza
X-Rspamd-Queue-Id: 5525FA000B
X-Rspam-User: 
X-HE-Tag: 1770222517-859479
X-HE-Meta: U2FsdGVkX1+oRgNVnGPLLif4CHLxF5MZEt38XfJNe5JIOysYK2OOU02hts3EBawbXTYXTAnaU/ZuS1qFEkJbNouijS/tGU4CNA5Ws1uSLZjrNAUpLfzNk1EoZ+oWTMkzHd7xhDrey4ujHBrp4kbPecpSCg0RYPB/ksv3TOo/onKy4IRPUzMwmJe8QyIwRKAL4HYPcW6Wt9VmAwKAvy//yuO23TmXpCMNm1sUuSceoo/kgcDCa+wjC2YGKDO4SyZVgHqMxENxZru47JsfKHjVKUSm57qutg88tFO+M9h8JlGJ0lSH1x+knk1AKjvDEd3YjEzhb6aBBKcvtnCXqrhaLFv7T4xpc7YpJfKgcd5gb0Mt0gcn4fXN8HN3XbhQl0zwvcjzYn29dB5nqxhFcTuS85x3ic8CyJOoisE21jvNdxsp1fX8owyWB5db+zfWT3ku1RpbOugLP9eH3/h6NEaIoSe0Gmb1lBezkzOZIAxKutP9wKirmfSLFRQJoX+NnUNA7S3eHtLM8f2zWCJYy1bMLzn7EEPaPOlHAuJXRoW/++S6y5LgGy56XrzGRI72MmE9KioPpT4AHdFq4YAi6Mm/nXT5oxIMc0RvmiEjtJTWKFYeMz01UwQcA+E38Lgeuc3A7VXSS+2NHD8ayU+4vr71CccVWvM1pZQG+QUA3PShap4D88H7VI400/9bII2OMLJJxE9hbmIAJSBW9BH83B/p8/d4S+ey6ILvhdHELTVku/T3HqLrFmsqp3EQlUaRyOvxeInTZeY8MQpq+zaT5owuul8sf3ccG/dlrAcNyBUYoaVC3t6UvrSJEYMe88M/9CySgGbnkut2xUN+74zXp2qy8tkR3sPnvXfKCMAbgSweMb6VS3ML9GpQg3dInjY0CBclA72zZEeEK78IBX0bkpnbthB2rykMAOk5VvfDsuPcwpyCLZBZgFrfCmMiw6YezRin9ZbW3flxAFJ2UGldTaL
 HoczB0mq
 y4CeNun5z1ncTQERIfRgVH1G+6ypmkTPsrGhVz3zB51HV+h5zoH2tOVwfi/9zbcGo984el0ubEXcVeT4wCWwch6MrGtI8dUYbNxxfBuA/Y5BsxLbooGxYQtY8ggDRZ61NsjWOsvm0cv1IetDsUaw/cxVEXtwD/m9kyGLgKi35IWweARzSOUzFPf2EgjgIS/8jO1jNPrQ/6yrOwN+e9MtAeVwHl768TT78foR2NggDUR6e3yGKxT6jSWjPpRF+bzEz5wF/uIp1mNzZzZj4t3ANAKcPSf2OuShswkrHn6yumr5x5jKQd9DW8lEOSCU+L2ixogEXEgqTf/aZDZ0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/4/26 13:00, Hao Li wrote:
> On Wed, Feb 04, 2026 at 06:14:01PM +0800, Hao Ge wrote:
>> When CONFIG_MEM_ALLOC_PROFILING_DEBUG is enabled, the following warning
>> may be noticed:
>> 
>> [ 3959.023862] ------------[ cut here ]------------
>> [ 3959.023891] alloc_tag was not cleared (got tag for lib/xarray.c:378)
>> [ 3959.023947] WARNING: ./include/linux/alloc_tag.h:155 at alloc_tag_add+0x128/0x178, CPU#6: mkfs.ntfs/113998
>> [ 3959.023978] Modules linked in: dns_resolver tun brd overlay exfat btrfs blake2b libblake2b xor xor_neon raid6_pq loop sctp ip6_udp_tunnel udp_tunnel ext4 crc16 mbcache jbd2 rfkill sunrpc vfat fat sg fuse nfnetlink sr_mod virtio_gpu cdrom drm_client_lib virtio_dma_buf drm_shmem_helper drm_kms_helper ghash_ce drm sm4 backlight virtio_net net_failover virtio_scsi failover virtio_console virtio_blk virtio_mmio dm_mirror dm_region_hash dm_log dm_multipath dm_mod i2c_dev aes_neon_bs aes_ce_blk [last unloaded: hwpoison_inject]
>> [ 3959.024170] CPU: 6 UID: 0 PID: 113998 Comm: mkfs.ntfs Kdump: loaded Tainted: G        W           6.19.0-rc7+ #7 PREEMPT(voluntary)
>> [ 3959.024182] Tainted: [W]=WARN
>> [ 3959.024186] Hardware name: QEMU KVM Virtual Machine, BIOS unknown 2/2/2022
>> [ 3959.024192] pstate: 604000c5 (nZCv daIF +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
>> [ 3959.024199] pc : alloc_tag_add+0x128/0x178
>> [ 3959.024207] lr : alloc_tag_add+0x128/0x178
>> [ 3959.024214] sp : ffff80008b696d60
>> [ 3959.024219] x29: ffff80008b696d60 x28: 0000000000000000 x27: 0000000000000240
>> [ 3959.024232] x26: 0000000000000000 x25: 0000000000000240 x24: ffff800085d17860
>> [ 3959.024245] x23: 0000000000402800 x22: ffff0000c0012dc0 x21: 00000000000002d0
>> [ 3959.024257] x20: ffff0000e6ef3318 x19: ffff800085ae0410 x18: 0000000000000000
>> [ 3959.024269] x17: 0000000000000000 x16: 0000000000000000 x15: 0000000000000000
>> [ 3959.024281] x14: 0000000000000000 x13: 0000000000000001 x12: ffff600064101293
>> [ 3959.024292] x11: 1fffe00064101292 x10: ffff600064101292 x9 : dfff800000000000
>> [ 3959.024305] x8 : 00009fff9befed6e x7 : ffff000320809493 x6 : 0000000000000001
>> [ 3959.024316] x5 : ffff000320809490 x4 : ffff600064101293 x3 : ffff800080691838
>> [ 3959.024328] x2 : 0000000000000000 x1 : 0000000000000000 x0 : ffff0000d5bcd640
>> [ 3959.024340] Call trace:
>> [ 3959.024346]  alloc_tag_add+0x128/0x178 (P)
>> [ 3959.024355]  __alloc_tagging_slab_alloc_hook+0x11c/0x1a8
>> [ 3959.024362]  kmem_cache_alloc_lru_noprof+0x1b8/0x5e8
>> [ 3959.024369]  xas_alloc+0x304/0x4f0
>> [ 3959.024381]  xas_create+0x1e0/0x4a0
>> [ 3959.024388]  xas_store+0x68/0xda8
>> [ 3959.024395]  __filemap_add_folio+0x5b0/0xbd8
>> [ 3959.024409]  filemap_add_folio+0x16c/0x7e0
>> [ 3959.024416]  __filemap_get_folio_mpol+0x2dc/0x9e8
>> [ 3959.024424]  iomap_get_folio+0xfc/0x180
>> [ 3959.024435]  __iomap_get_folio+0x2f8/0x4b8
>> [ 3959.024441]  iomap_write_begin+0x198/0xc18
>> [ 3959.024448]  iomap_write_iter+0x2ec/0x8f8
>> [ 3959.024454]  iomap_file_buffered_write+0x19c/0x290
>> [ 3959.024461]  blkdev_write_iter+0x38c/0x978
>> [ 3959.024470]  vfs_write+0x4d4/0x928
>> [ 3959.024482]  ksys_write+0xfc/0x1f8
>> [ 3959.024489]  __arm64_sys_write+0x74/0xb0
>> [ 3959.024496]  invoke_syscall+0xd4/0x258
>> [ 3959.024507]  el0_svc_common.constprop.0+0xb4/0x240
>> [ 3959.024514]  do_el0_svc+0x48/0x68
>> [ 3959.024520]  el0_svc+0x40/0xf8
>> [ 3959.024526]  el0t_64_sync_handler+0xa0/0xe8
>> [ 3959.024533]  el0t_64_sync+0x1ac/0x1b0
>> [ 3959.024540] ---[ end trace 0000000000000000 ]---
>> 
>> When __memcg_slab_post_alloc_hook() fails, there are two different
>> free paths depending on whether size == 1 or size != 1. In the
>> kmem_cache_free_bulk() path, we do call alloc_tagging_slab_free_hook().
>> However, in memcg_alloc_abort_single() we don't, the above warning will be
>> triggered on the next allocation.
>> 
>> Therefore, add alloc_tagging_slab_free_hook() to the
>> memcg_alloc_abort_single() path.
>> 
>> Fixes: 9f9796b413d3 ("mm, slab: move memcg charging to post-alloc hook")
>> Suggested-by: Hao Li <hao.li@linux.dev>
>> Signed-off-by: Hao Ge <hao.ge@linux.dev>
>> ---
>> v2: Hao Li correctly pointed out the root cause of this problem.
>>     Per his suggestion, this patch adds the missing hook call.
>>     Many thanks to him for the thorough analysis.
>> ---
>>  mm/slub.c | 2 ++
>>  1 file changed, 2 insertions(+)
>> 
>> diff --git a/mm/slub.c b/mm/slub.c
>> index f77b7407c51b..452a92544c6a 100644
>> --- a/mm/slub.c
>> +++ b/mm/slub.c
>> @@ -6689,6 +6689,8 @@ void slab_free(struct kmem_cache *s, struct slab *slab, void *object,
>>  static noinline
>>  void memcg_alloc_abort_single(struct kmem_cache *s, void *object)
>>  {
>> +	alloc_tagging_slab_free_hook(s, virt_to_slab(object), &object, 1);
> 
> LGTM.
> 
> Minor nit: It would be cleaner to store the result of `virt_to_slab(object)` in a local
> variable and reuse it in the code that follows.

Did that locally, also added Cc: stable

> If you end up sending a v3, feel free to add:
> Reviewed-by: Hao Li <hao.li@linux.dev>

Pushed to slab/for-next-fixes, thanks!

> 
>> +
>>  	if (likely(slab_free_hook(s, object, slab_want_init_on_free(s), false)))
>>  		do_slab_free(s, virt_to_slab(object), object, object, 1, _RET_IP_);
>>  }
>> -- 
>> 2.25.1
>> 


