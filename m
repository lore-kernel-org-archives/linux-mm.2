Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A3FECA0EE9
	for <linux-mm@archiver.kernel.org>; Sat, 16 Aug 2025 18:29:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E7C818E002D; Sat, 16 Aug 2025 14:29:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E59A88E000A; Sat, 16 Aug 2025 14:29:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D6A208E002D; Sat, 16 Aug 2025 14:29:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C5C2E8E000A
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 14:29:19 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 420791388D1
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 18:29:19 +0000 (UTC)
X-FDA: 83783458038.01.49868E5
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf02.hostedemail.com (Postfix) with ESMTP id D27488000B
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 18:29:16 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=ExmhwD+n;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=R91vEMK0;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=zzoL5f8Q;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=JWvC2qOP;
	spf=pass (imf02.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755368957;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/3+m47Qj3Eghi4YuXoOVp+BiD93yWyZ2w53q8+M5Kvg=;
	b=gFn8JPwAr05LO19wc9aOiI5e77HuPBOzoeP4HXb3mMtpPc1M1fq7Ipmb5/ucxe8n9nDXs2
	kDsfYlZRE8VYIdvj9rUlCthAnWu2ZEm1ZaBcaPf/RxBvz6VkCKP7Km7fDazwX8vq8sDsxO
	OdBCGpGnFlAnhShtcTflZ4NSIL8+I0c=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=ExmhwD+n;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=R91vEMK0;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=zzoL5f8Q;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=JWvC2qOP;
	spf=pass (imf02.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755368957; a=rsa-sha256;
	cv=none;
	b=0crQabW7m9pX8V4K0BiGtim6OX27IpwYjUyM4QF/wshbL1YlZVj/DSQnEW2DbGkVSPVNOB
	Rk3TkabSnkdghswbW78RMfr8wef628i4V6Z4IMprZn4AXorxpynhSWYU9vlmE9V48+LZoU
	a5N4iJW3JpLudbf9e7bjWS2H99eovsI=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id D9C061F79C;
	Sat, 16 Aug 2025 18:29:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1755368955; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/3+m47Qj3Eghi4YuXoOVp+BiD93yWyZ2w53q8+M5Kvg=;
	b=ExmhwD+nWhBWWHh5eviHhKSfqOusBZNMahfFP0E8bPPqfG09CIxogO7KVsqyHm6Ksoc/yQ
	ouf3NMiWgGniuKkMFIyUcJAYqHT/faNcaiiLDQtHJ9K+fQ/Eu239TS4jzHDLgYB0kJiD/W
	thYhPAUaIzHovwfYk9LkCXDiX3qIucY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1755368955;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/3+m47Qj3Eghi4YuXoOVp+BiD93yWyZ2w53q8+M5Kvg=;
	b=R91vEMK0dxcFTC8N4tVvRlRp6cNPf0JKH37QkkrQMrsbcFPd1YTSMJYusz8ja2gVMOQuSc
	UUe2PZONpN4g1GAg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1755368954; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/3+m47Qj3Eghi4YuXoOVp+BiD93yWyZ2w53q8+M5Kvg=;
	b=zzoL5f8QXUrS0mMGa/ugMZvVCYFoMpJnf6y+EKmaW4xHxTde11bvdKEv1xWETbSkMfSBKq
	a5eRQbk4Dp+N4XDnUC7K7xZr/jkniU1bXV6aKcbxo4lIXRIbnz5L9793RePQmIvGZ6Z5lN
	//q5yqVwIwEU1ELfHmZoz2F31kRwlkI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1755368954;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/3+m47Qj3Eghi4YuXoOVp+BiD93yWyZ2w53q8+M5Kvg=;
	b=JWvC2qOPdKv0r36fNhcic2LyreGXBN/o5M/1D08xzsW6uwJrEEYzJBW7szMhskQbRUzI7h
	ze+rYkQ2Yrl8iJDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 4B4B113432;
	Sat, 16 Aug 2025 18:29:14 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id rcI4EPrNoGhvBwAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Sat, 16 Aug 2025 18:29:14 +0000
Message-ID: <498fc518-d78a-43a4-9196-507891e9b844@suse.cz>
Date: Sat, 16 Aug 2025 20:31:20 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 00/14] SLUB percpu sheaves
To: Sudarsan Mahendran <sudarsanm@google.com>,
 Harry Yoo <harry.yoo@oracle.com>
Cc: Liam.Howlett@oracle.com, cl@gentwo.org, howlett@gmail.com,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 maple-tree@lists.infradead.org, rcu@vger.kernel.org, rientjes@google.com,
 roman.gushchin@linux.dev, surenb@google.com, urezki@gmail.com,
 Greg Thelen <gthelen@google.com>
References: <20250723-slub-percpu-caches-v5-0-b792cd830f5d@suse.cz>
 <20250815225259.3012455-2-sudarsanm@google.com> <aKA7180s0HdLfOKc@harry>
 <CAA9mObAiQbAYvzhW---VoqDA6Zsb152p5ePMvbco0xgwyvaB2Q@mail.gmail.com>
From: Vlastimil Babka <vbabka@suse.cz>
Content-Language: en-US
In-Reply-To: <CAA9mObAiQbAYvzhW---VoqDA6Zsb152p5ePMvbco0xgwyvaB2Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: D27488000B
X-Stat-Signature: fesnbfacuj9r4eoaoq9pyocb4trbh18m
X-Rspam-User: 
X-HE-Tag: 1755368956-559535
X-HE-Meta: U2FsdGVkX19qRCFjIEiDPBYcJGR5FKDveMz+s8v715qCBLuP6EkjyEExBBmrCik+nBAgVLSQ+tcOugQ9CurhZmnfsYGy2TxTs4zZWGxGbDQWEgApuE8C3aUTfWiQTirHKgXZLZ6JN16FeeP3CezqW4g1+efDMhBTXNjskVCo5p/WLPM4ohW6kB1pUilE0Y4qlJLzb3ii0GI24t6/pGvj36U+s245ZvqGlE9fTZ7LkvdA0tJ2hH3MLcy/9ehIeqkP1Dz7J18DwT2uQY0qdO7n3+o88380G8xAf4y3+5wi3vY51UgrAKJbsANyfCFBwV6pZL5KieFbBldsuZgEiAr8QD+D3VMqiDFCN/JBEKfQb9o4eLXhjTzBZON1npFDPL1k+1cElrxyjB9AFtqSfeDpB870pKMa3NGV/C4WvJgfPbeLTSZ3C/aKhZqvHL3/t3ijgi/DhaIC0h5ixc8xqzCi8CpYmuvqeaRzSlHW1mj3zIfRMMXtHtLYigpTzkT7QgZR76RH5qKOTrc/xKGu7B0Ci4K5YCiQlc2vizJ2PM+PznEbGjBUVclVRkhdoS5pJ3t1fhWGC07VwOtKgXxmy1OtV0uCx3HlBmpQ5WMf5mdJjTEzLOll7SOuBwc5+iM17T/w8scwe8W6FxO3QsMgByHyxLpoPJ8DfVMsFLS7KFvOui49THNRTVQPPjZQ+h9MMJzXbjDaCNaVesRRZED1y5Qkuwncn0bxl0sJukOxD8b4c8f6A+5T6hRbom/djbNqqyALKilzE44Up5RtMzVCSIhd1sLqhKXWJjDHGkwFlhx4tlj4CV4dykgu2ND4GJysZWJ+C5/qgni1yb6cARbGv8DOsbupRMfBkwI4ZaXXV0EokA6lJpCqNADlQE9elZc4/Yzdm+YAh/Gb5D4gFdwXqGgW3SEaT3SzMYC4Y/Chcv0Pt8R5t3W5X2wCbfdeqc+oCdBKuQ4tLKZCMbaWNXAvqOT
 h2k8jvww
 6cSOlVSd5O7N9XKgqaPsh/xENIbNf9O39H3eIGYFUPVLvJVU2ETJzN0EEV3fpfFWfyKhuYc7v6bcBD9EorgLDm/6sO6OYgTy7q0YJ9m2KOeXI9Oi1LsHsL9h3jGo3R8m9O28EPU0gBvgGYySArQamTxvR9B0i+R7gg5Eu3Q6TFsDQLj+e3eGOsyXiq8A3FP3ZuQcLYCwKnn5cpRQhVGOPjzihcQwiGkEFTgJe70nJ3FQOAfA1fWtUpW3/iPPDzBIyrezyrUo7Di4gzjKpK5ro+deGQYuRV/AlQxiqY1hwDXk1wkSx/aXRBvgXIPHj29k6ET93ssTSaRibLL0JLufawvpRp4rO9B20EmhOEkiG76UDEk8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/16/25 7:35 PM, Sudarsan Mahendran wrote:
> 
> 
> On Sat, Aug 16, 2025 at 1:06 AM Harry Yoo <harry.yoo@oracle.com
> <mailto:harry.yoo@oracle.com>> wrote:
>>
>> On Fri, Aug 15, 2025 at 03:53:00PM -0700, Sudarsan Mahendran wrote:
>> > Hi Vlastimil,
>> >
>> > I ported this patch series on top of v6.17.
>> > I had to resolve some merge conflicts because of
>> > fba46a5d83ca8decb338722fb4899026d8d9ead2
>> >
>> > The conflict resolution looks like:
>> >
>> > @@ -5524,20 +5335,19 @@ EXPORT_SYMBOL_GPL(mas_store_prealloc);
>> >  int mas_preallocate(struct ma_state *mas, void *entry, gfp_t gfp)
>> >  {
>> >         MA_WR_STATE(wr_mas, mas, entry);
>> > -       int ret = 0;
>> > -       int request;
>> >
>> >         mas_wr_prealloc_setup(&wr_mas);
>> >         mas->store_type = mas_wr_store_type(&wr_mas);
>> > -       request = mas_prealloc_calc(&wr_mas, entry);
>> > -       if (!request)
>> > +       mas_prealloc_calc(&wr_mas, entry);
>> > +       if (!mas->node_request)
>> >                 goto set_flag;
>> >
>> >         mas->mas_flags &= ~MA_STATE_PREALLOC;
>> > -       mas_node_count_gfp(mas, request, gfp);
>> > +       mas_alloc_nodes(mas, gfp);
>> >         if (mas_is_err(mas)) {
>> > -               mas_set_alloc_req(mas, 0);
>> > -               ret = xa_err(mas->node);
>> > +               int ret = xa_err(mas->node);
>> > +
>> > +               mas->node_request = 0;
>> >                 mas_destroy(mas);
>> >                 mas_reset(mas);
>> >                 return ret;
>> > @@ -5545,7 +5355,7 @@ int mas_preallocate(struct ma_state *mas, void
> *entry, gfp_t gfp)
>> >
>> >  set_flag:
>> >         mas->mas_flags |= MA_STATE_PREALLOC;
>> > -       return ret;
>> > +       return 0;
>> >  }
>> >  EXPORT_SYMBOL_GPL(mas_preallocate);
>> >
>> >
>> >
>> > When I try to boot this kernel, I see kernel panic
>> > with rcu_free_sheaf() doing recursion into __kmem_cache_free_bulk()
>> >
>> > Stack trace:
>> >
>> > [    1.583673] Oops: stack guard page: 0000 [#1] SMP NOPTI
>> > [    1.583676] CPU: 103 UID: 0 PID: 0 Comm: swapper/103 Not tainted
> 6.17.0-smp-sheaves2 #1 NONE
>> > [    1.583679] RIP: 0010:__kmem_cache_free_bulk+0x57/0x540
>> > [    1.583684] Code: 48 85 f6 0f 84 b8 04 00 00 49 89 d6 49 89 ff 48
> 85 ff 0f 84 fe 03 00 00 49 83 7f 08 00 0f 84 f3 03 00 00 0f 1f 44 00 00
> 31 c0 <48> 89 44 24 18 65 8b 05 6d 26 dc 02 89 44 24 2c 31 ff 89 f8 c7 44
>> > [    1.583685] RSP: 0018:ff40dbc49b048fc0 EFLAGS: 00010246
>> > [    1.583687] RAX: 0000000000000000 RBX: 0000000000000012 RCX:
> ffffffff939e8640
>> > [    1.583687] RDX: ff2afe75213e6c90 RSI: 0000000000000012 RDI:
> ff2afe750004ad00
>> > [    1.583688] RBP: ff40dbc49b049130 R08: ff2afe75368c2500 R09:
> ff2afe75368c3b00
>> > [    1.583689] R10: ff2afe75368c2500 R11: ff2afe75368c3b00 R12:
> ff2aff31ba00b000
>> > [    1.583690] R13: ffffffff939e8640 R14: ff2afe75213e6c90 R15:
> ff2afe750004ad00
>> > [    1.583690] FS:  0000000000000000(0000) GS:ff2aff31ba00b000(0000)
> knlGS:0000000000000000
>> > [    1.583691] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> > [    1.583692] CR2: ff40dbc49b048fb8 CR3: 0000000017c3e001 CR4:
> 0000000000771ef0
>> > [    1.583692] PKRU: 55555554
>> > [    1.583693] Call Trace:
>> > [    1.583694]  <IRQ>
>> > [    1.583696]  __kmem_cache_free_bulk+0x2c7/0x540
>>
>> [..]
>>
>> > [    1.583759]  __kmem_cache_free_bulk+0x2c7/0x540
>>
>> Hi Sudarsan, thanks for the report.
>>
>> I'm not really sure how __kmem_cache_free_bulk() can call itself.
>> There's no recursion of __kmem_cache_free_bulk() in the code.
> Hi Harry,
> 
> I assume somehow the free_to_pcs_bulk() fallback case is taken, thus
> calling __kmem_cache_free_bulk(), which calls free_to_pcs_bulk() ad nauseam.

Could it be a rebase gone wrong? Mine to 6.17-rc1 is here (but untested)

https://git.kernel.org/pub/scm/linux/kernel/git/vbabka/linux.git/
> free_to_pcs_bulk()
> {
> ...
> fallback:
>         __kmem_cache_free_bulk(s, size, p);
> ...
> }
> 
> static void __kmem_cache_free_bulk(struct kmem_cache *s, size_t size,
> void **p)

I don't have this, this codes seems to correspond to my
kmem_cache_free_bulk(), while __kmem_cache_free_bulk() is just
build_detached_freelist() and do_slab_free() with no sheaves involved.

> {
>         if (!size)
>                 return;
> 
>         /*
>          * freeing to sheaves is so incompatible with the detached
> freelist so
>          * once we go that way, we have to do everything differently
>          */
>         if (s && s->cpu_sheaves) {
>                 free_to_pcs_bulk(s, size, p);
>                 return;
>         }
> ...
> 
> Thanks Greg for pointing this out.
> 
> 
>> As v6.17-rc1 is known to cause a few surprising bugs, could you please
>> rebase onto of mm-hotfixes-unstable and check if it still reproduces?
>>
>> > [    1.583761]  ? update_group_capacity+0xad/0x1f0
>> > [    1.583763]  ? sched_balance_rq+0x4f6/0x1e80
>> > [    1.583765]  __kmem_cache_free_bulk+0x2c7/0x540
>> > [    1.583767]  ? update_irq_load_avg+0x35/0x480
>> > [    1.583768]  ? __pfx_rcu_free_sheaf+0x10/0x10
>> > [    1.583769]  rcu_free_sheaf+0x86/0x110
>> > [    1.583771]  rcu_do_batch+0x245/0x750
>> > [    1.583772]  rcu_core+0x13a/0x260
>> > [    1.583773]  handle_softirqs+0xcb/0x270
>> > [    1.583775]  __irq_exit_rcu+0x48/0xf0
>> > [    1.583776]  sysvec_apic_timer_interrupt+0x74/0x80
>> > [    1.583778]  </IRQ>
>> > [    1.583778]  <TASK>
>> > [    1.583779]  asm_sysvec_apic_timer_interrupt+0x1a/0x20
>> > [    1.583780] RIP: 0010:cpuidle_enter_state+0x101/0x290
>> > [    1.583781] Code: 85 f4 ff ff 49 89 c4 8b 73 04 bf ff ff ff ff e8
> d5 44 d4 ff 31 ff e8 9e c7 37 ff 80 7c 24 04 00 74 05 e8 12 45 d4 ff fb
> 85 ed <0f> 88 ba 00 00 00 89 e9 48 6b f9 68 4c 8b 44 24 08 49 8b 54 38 30
>> > [    1.583782] RSP: 0018:ff40dbc4809afe80 EFLAGS: 00000202
>> > [    1.583782] RAX: ff2aff31ba00b000 RBX: ff2afe75614b0800 RCX:
> 000000005e64b52b
>> > [    1.583783] RDX: 000000005e73f761 RSI: 0000000000000067 RDI:
> 0000000000000000
>> > [    1.583783] RBP: 0000000000000002 R08: fffffffffffffff6 R09:
> 0000000000000000
>> > [    1.583784] R10: 0000000000000380 R11: ffffffff908c38d0 R12:
> 000000005e64b535
>> > [    1.583784] R13: 000000005e5580da R14: ffffffff92890b10 R15:
> 0000000000000002
>> > [    1.583784]  ? __pfx_read_tsc+0x10/0x10
>> > [    1.583787]  cpuidle_enter+0x2c/0x40
>> > [    1.583788]  do_idle+0x1a7/0x240
>> > [    1.583790]  cpu_startup_entry+0x2a/0x30
>> > [    1.583791]  start_secondary+0x95/0xa0
>> > [    1.583794]  common_startup_64+0x13e/0x140
>> > [    1.583796]  </TASK>
>> > [    1.583796] Modules linked in:
>> > [    1.583798] ---[ end trace 0000000000000000 ]---
>> > [    1.583798] RIP: 0010:__kmem_cache_free_bulk+0x57/0x540
>> > [    1.583800] Code: 48 85 f6 0f 84 b8 04 00 00 49 89 d6 49 89 ff 48
> 85 ff 0f 84 fe 03 00 00 49 83 7f 08 00 0f 84 f3 03 00 00 0f 1f 44 00 00
> 31 c0 <48> 89 44 24 18 65 8b 05 6d 26 dc 02 89 44 24 2c 31 ff 89 f8 c7 44
>> > [    1.583800] RSP: 0018:ff40dbc49b048fc0 EFLAGS: 00010246
>> > [    1.583801] RAX: 0000000000000000 RBX: 0000000000000012 RCX:
> ffffffff939e8640
>> > [    1.583801] RDX: ff2afe75213e6c90 RSI: 0000000000000012 RDI:
> ff2afe750004ad00
>> > [    1.583801] RBP: ff40dbc49b049130 R08: ff2afe75368c2500 R09:
> ff2afe75368c3b00
>> > [    1.583802] R10: ff2afe75368c2500 R11: ff2afe75368c3b00 R12:
> ff2aff31ba00b000
>> > [    1.583802] R13: ffffffff939e8640 R14: ff2afe75213e6c90 R15:
> ff2afe750004ad00
>> > [    1.583802] FS:  0000000000000000(0000) GS:ff2aff31ba00b000(0000)
> knlGS:0000000000000000
>> > [    1.583803] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> > [    1.583803] CR2: ff40dbc49b048fb8 CR3: 0000000017c3e001 CR4:
> 0000000000771ef0
>> > [    1.583803] PKRU: 55555554
>> > [    1.583804] Kernel panic - not syncing: Fatal exception in interrupt
>> > [    1.584659] Kernel Offset: 0xf600000 from 0xffffffff81000000
> (relocation range: 0xffffffff80000000-0xffffffffbfffffff)
>> >
>> >


