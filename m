Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B0F87CD8CA8
	for <linux-mm@archiver.kernel.org>; Fri, 12 Jun 2026 13:14:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2014F6B0005; Fri, 12 Jun 2026 09:14:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D8A26B0088; Fri, 12 Jun 2026 09:14:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0EF8F6B0092; Fri, 12 Jun 2026 09:14:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F3B106B0005
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 09:14:12 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 73B181401E5
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 13:14:12 +0000 (UTC)
X-FDA: 84871303944.25.0E950D7
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [160.30.148.34])
	by imf17.hostedemail.com (Postfix) with ESMTP id 9054440002
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 13:14:09 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=none;
	spf=pass (imf17.hostedemail.com: domain of hu.shengming@zte.com.cn designates 160.30.148.34 as permitted sender) smtp.mailfrom=hu.shengming@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781270050;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3JJiZulxY9+vk5dR4fcuRDM0Y3wTUaL4T51D8xqbk5g=;
	b=Jf2SMZOh9/mGeXgVz2dRUAJl08bzcZLTpDvsXicq273qB7nhffuxSqaFxDWY1y2VrsrRnf
	RUuyTkJ6eywCqDLv0dNFxVbVZoyROo2Dmb4W/0a+/Z4ykfpKTGrPTOlWN4JSgr7CyfN/hb
	AeUeALXX4aJv1gICcNLXVRQ0S49exMY=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=none;
	spf=pass (imf17.hostedemail.com: domain of hu.shengming@zte.com.cn designates 160.30.148.34 as permitted sender) smtp.mailfrom=hu.shengming@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781270050;
	b=sZMnd9Oh1BrVIimllbP8089/RSqlHOCMNIenuoakKYWNtKoLBprvDS8pXBEzOCPhwinDwm
	fMy6k0hZnV5+riEyCuhQUe/brG/Rr7U3a6lCOzPbnaZoKFSZTAYZlwoHJBNky3pc4fOLaR
	veVo1lh5lG38qb2qm+qBg9udIVWi31Q=
Received: from mse-fl2.zte.com.cn (unknown [10.5.228.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxhk.zte.com.cn (FangMail) with ESMTPS id 4gcKjB5p08z5BNRf;
	Fri, 12 Jun 2026 21:14:06 +0800 (CST)
Received: from xaxapp04.zte.com.cn ([10.99.98.157])
	by mse-fl2.zte.com.cn with SMTP id 65CDDxFH053234;
	Fri, 12 Jun 2026 21:13:59 +0800 (+08)
	(envelope-from hu.shengming@zte.com.cn)
Received: from mapi (xaxapp05[null])
	by mapi (Zmail) with MAPI id mid32;
	Fri, 12 Jun 2026 21:14:02 +0800 (CST)
X-Zmail-TransId: 2afc6a2c061af5c-116bd
X-Mailer: Zmail v1.0
Message-ID: <20260612211402764giuZSM5QaiUHZaQucLbeg@zte.com.cn>
In-Reply-To: <eb6e6133-8df8-472d-860f-c54b520ee3b9@kernel.org>
References: 20260612205230395zeZ-tyvcj3PnuOeD0ppp3@zte.com.cn,eb6e6133-8df8-472d-860f-c54b520ee3b9@kernel.org
Date: Fri, 12 Jun 2026 21:14:02 +0800 (CST)
Mime-Version: 1.0
From: <hu.shengming@zte.com.cn>
To: <vbabka@kernel.org>
Cc: <harry@kernel.org>, <akpm@linux-foundation.org>, <hao.li@linux.dev>,
        <cl@gentwo.org>, <rientjes@google.com>, <roman.gushchin@linux.dev>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        <zhang.run@zte.com.cn>, <cai.qu@zte.com.cn>
Subject: =?UTF-8?B?UmU6IFtQQVRDSCB2MiAxMy8xNl0gbW0vc2xhYjogYWxsb3cgX19HRlBfTk9NRU1BTExPQyBhbmQgX19HRlBfTk9XQVJOIGZvciBrbWFsbG9jX25vbG9jaygp?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl2.zte.com.cn 65CDDxFH053234
X-TLS: YES
X-ENVELOPE-SENDER: hu.shengming@zte.com.cn
X-SOURCE-IP: 10.5.228.133 unknown Fri, 12 Jun 2026 21:14:06 +0800
X-CLEAN: YES
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6A2C061E.000/4gcKjB5p08z5BNRf
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 9054440002
X-Stat-Signature: xq6hr7ri4cpd53pza4ipdxfxjgay8jsr
X-Rspam-User: 
X-HE-Tag: 1781270049-14505
X-HE-Meta: U2FsdGVkX1+WDu6iCdybhHcvPOLZNzeeubZleUkxk1HJAL6QtQZ+AI53fiZy8YcoOqoymAFrzEQa512cDWu53r80pDP19LSGcQ8bL2kzuTGQDtZw2z8h8y5v+1kn5RpafvdnOy8GV7/0Wa/jW4GJY4I7GnjBYt0oL5OornXZyinYQNVXCqpJWVNlcGUyCIrtMeDGmFXnTvKYXeKEb4bd6cMcucG9ECo2gvzOYp8BLtSHXib3CbSahkqsWvUYB6TxJsuzdbig806v8Iankhb/Bj4TTE2PUSU9n4kJmGOUx5jIQhpez5NlGUttkgjmXNIg3XR8Z3qOa+NQTngXbYLbtrhtH+YjIaBf9bArjL4DkQa1Quo/m/1ufSK4b2O8DvwZCpnSP07+/kLOxoaS642iTusQsvaduRjlo+Ey8aJDu+nNFt+dKjScnZuYNUxKXXPcSRSX9X3mfVRf3XUk4YMxwyeSmFEMkzhdEEO8H94C6N3GVcCsWzKmw7lPVh7Ub3d4MYumKaGQbDk/M/5HY1jTZgwG5DXWEKTUWiMKtEWi2OygPAi9PLIsOfmMlv1KYwgeFP5wLwZ8qlx8ZkRVYPt2f3XeJMNH+i7KgCglm0mITk6JtAMEODIHB9P0TnmJFa6PAeWCSP+izWER/QjOKjBnchgXZ+HZriPF+6Wm7bsS2McvhiKUvf3elGUIMpLInJuLXzYCtAgZ8uF9pSksHKanaGrCs37v+bR1bBBm06hMOqH1ujzEs5qBG5/7Gj5uamQWopguqOcaMXD5Wuk90YDltPs5AaW8HFs09hlMwZaPVAbd4rqoYfqWW7yvrprGm+j8XU25f5bahaLuOSXAOZm8zQqaXbDfyeJkoThDwW/qP4lS0N9t0rZ4yy0krkG0mBsemS4AtdCvMBHMkxY+rfDwwU+uhXWnzDKwKdixJFw9SkTe6rD9BduETJoi7G8L+mipliROTYeo0rY3D6SNrtQ
 VbyTcrjx
 m+YMtuuMBIMRTxtHYytI9EOrmcesuBIF7DzE/USBvYNyf75v9DzKEKrScucC5m3s3vJjCM0BsQeUMrkDUONqcvNi3ACQcxNWWh9VEpurUhNaShZycFXcRRFQmIxtOtHXR+ldlTpiBEoGTwumDurMklRnr4WUKzMSQk14bNd53d5Is4MJq0OYiB9oPYbWao21cFrpPcIWfMdqMKEHLMuQG7ImKsh2deEjiiI4QM4zLfUCZt6ZCy/stvNBVkqWxUvzXNKCP2KMTWr5h4c0F3cs0jdT18RqhWFB39JYwBlgAe/ff+vfkDSb9fewVJfOYCwL2cnKi5gHHaC8nV6XUpxwY/nyupoft/mEa+OsTC3Om6fPrpiW0sjNLaKHaYybcEQZGe5IPkAJ4X/G7jvCg+ttjBTeKnQDV191ax2PInCb1T/q7dHo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Vlastimil Babka (SUSE) wrote:
> On 6/12/26 14:52, hu.shengming@zte.com.cn wrote:
> > Vlastimil Babka (SUSE) wrote:
> >> The two flags are added internally so there's no point for warning if
> >> they are passed by the caller as well, so allow them. This will allow
> >> simplifying obj_ext allocation under kmalloc_nolock().
> >> 
> >> Also it's not necessary to have the extra alloc_gfp variable for adding
> >> the two flags. The original gfp_flags parameter is not used anywhere
> >> except for the warning. So remove alloc_gfp and directly modify and use
> >> gfp_flags everywhere.
> >> 
> >> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> >> ---
> >>  include/linux/slab.h |  3 ++-
> >>  mm/slub.c            | 19 ++++++++++---------
> >>  2 files changed, 12 insertions(+), 10 deletions(-)
> >> 
> >> diff --git a/include/linux/slab.h b/include/linux/slab.h
> >> index ce1c867dc0ba..b955f3cbb732 100644
> >> --- a/include/linux/slab.h
> >> +++ b/include/linux/slab.h
> >> @@ -1040,7 +1040,8 @@ void *_kmalloc_nolock_noprof(DECL_TOKEN_PARAMS(size, token), gfp_t gfp_flags, in
> >>   * kmalloc_nolock - Allocate an object of given size from any context.
> >>   * @size: size to allocate
> >>   * @gfp_flags: GFP flags. Only __GFP_ACCOUNT, __GFP_ZERO, __GFP_NO_OBJ_EXT
> >> - * allowed.
> >> + * allowed. Also __GFP_NOWARN and __GFP_NOMEMALLOC are allowed but added
> >> + * internally thus not necessary.
> >>   * @node: node number of the target node.
> >>   *
> >>   * Return: pointer to the new object or NULL in case of error.
> >> diff --git a/mm/slub.c b/mm/slub.c
> >> index 6845e15c148a..847cad5203b2 100644
> >> --- a/mm/slub.c
> >> +++ b/mm/slub.c
> >> @@ -5388,7 +5388,6 @@ EXPORT_SYMBOL(__kmalloc_noprof);
> >>  
> >>  void *_kmalloc_nolock_noprof(DECL_TOKEN_PARAMS(size, token), gfp_t gfp_flags, int node)
> >>  {
> >> -    gfp_t alloc_gfp = __GFP_NOWARN | __GFP_NOMEMALLOC | gfp_flags;
> >>      size_t orig_size = size;
> >>      unsigned int alloc_flags = SLAB_ALLOC_TRYLOCK;
> >>      struct kmem_cache *s;
> >> @@ -5396,7 +5395,9 @@ void *_kmalloc_nolock_noprof(DECL_TOKEN_PARAMS(size, token), gfp_t gfp_flags, in
> >>      void *ret;
> >>  
> >>      VM_WARN_ON_ONCE(gfp_flags & ~(__GFP_ACCOUNT | __GFP_ZERO |
> >> -                      __GFP_NO_OBJ_EXT));
> >> +            __GFP_NO_OBJ_EXT | __GFP_NOWARN | __GFP_NOMEMALLOC));
> >> +
> >> +    gfp_flags |= __GFP_NOWARN | __GFP_NOMEMALLOC;
> >>  
> > 
> > Hi Vlastimil,
> > 
> > While reviewing your patch, I spotted a potential GFP flag mismatch along the kmalloc_flags()
> > -> __kmalloc_nolock_noprof() call path. I cloned the slab/for-next branch to verify this and
> > successfully triggered a VM_WARN_ON_ONCE() in the __kmalloc_nolock_noprof() path.
> > 
> > Here is the observed trace:
> > 
> > [   57.283791] ------------[ cut here ]------------
> > [   57.284226] WARNING: mm/slub.c:5407 at __kmalloc_nolock_noprof+0x3ec/0x450, CPU#6: insmod/379
> > [   57.285060] Modules linked in: slub_nolock(O+)
> > [   57.285494] CPU: 6 UID: 0 PID: 379 Comm: insmod Tainted: G           O        7.1.0-rc3-00036-g5ade53586fae-dirty #5 PREEMPT(lazy) 
> > [   57.286608] Tainted: [O]=OOT_MODULE
> > [   57.286941] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.12.1-0-ga5cab58e9a3f-prebuilt.qemu.org 04/01/2014
> > [   57.288018] RIP: 0010:__kmalloc_nolock_noprof+0x3ec/0x450
> > [   57.288543] Code: 01 00 8b 4c 24 04 41 89 c2 e9 dd fc ff ff b8 10 00 00 00 e9 f9 fd ff ff 90 0f 0b 90 f7 04 24 ff de b7 ff 0f 84 54
> > [   57.290252] RSP: 0018:ffffa82840c73b68 EFLAGS: 00010206
> > [   57.290752] RAX: 0000000000000000 RBX: 0000000000000003 RCX: ffffa82840c73bc8
> > [   57.291428] RDX: 0000000000000000 RSI: 00000000002c2100 RDI: 0000000000000100
> > [   57.292124] RBP: 0000000000000000 R08: ffffffffb853c968 R09: 0000000000009ffb
> > [   57.292821] R10: 00000000000001d7 R11: ffffffffb850c980 R12: 00000000002c2100
> > [   57.293485] R13: 0000000000000000 R14: ffffa82840c73bc8 R15: 0000000000000003
> > [   57.294159] FS:  0000000006fa8880(0000) GS:ffff8f4ef9d5a000(0000) knlGS:0000000000000000
> > [   57.294914] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > [   57.295464] CR2: 0000000006fac528 CR3: 000000003f9b6003 CR4: 0000000000770ef0
> > [   57.296124] PKRU: 55555554
> > [   57.296443] Call Trace:
> > [   57.296702]  <TASK>
> > [   57.296914]  ? vprintk_emit+0x22e/0x280
> > [   57.297295]  __kmalloc_flags_noprof+0x216/0x530
> > [   57.297735]  ? _printk+0x56/0x70
> > [   57.298053]  ? alloc_slab_obj_exts+0x89/0x1e0
> > [   57.298474]  alloc_slab_obj_exts+0x89/0x1e0
> > [   57.298876]  new_slab+0x2bc/0x660
> > [   57.299200]  ___slab_alloc+0x2ae/0x660
> > [   57.299603]  __kmalloc_nolock_noprof+0x151/0x450
> > [   57.300050]  _kmalloc_nolock_noprof+0x47/0x70
> > [   57.300490]  ? slub_nolock_init+0x127/0xff0 [slub_nolock]
> > [   57.301013]  slub_nolock_init+0x127/0xff0 [slub_nolock]
> > [   57.301566]  ? __pfx_slub_nolock_init+0x10/0x10 [slub_nolock]
> > [   57.302197]  do_one_initcall+0x44/0x220
> > [   57.302598]  ? do_init_module+0x1e/0x240
> > [   57.302990]  do_init_module+0x5f/0x240
> > [   57.303357]  __do_sys_init_module+0x162/0x190
> > [   57.303783]  do_syscall_64+0xf7/0x550
> > [   57.304159]  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> > [   57.304648] RIP: 0033:0x4b8839
> > [   57.304954] Code: 00 f3 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 40
> > [   57.306676] RSP: 002b:00007ffea38fdce8 EFLAGS: 00000246 ORIG_RAX: 00000000000000af
> > [   57.307376] RAX: ffffffffffffffda RBX: 00007ffea38fe080 RCX: 00000000004b8839
> > [   57.308044] RDX: 000000000062d4b5 RSI: 0000000000002790 RDI: 0000000006fa9d20
> > [   57.308710] RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000002790
> > [   57.309366] R10: 0000000006fa9cc0 R11: 0000000000000246 R12: 00007ffea38fe088
> > [   57.310040] R13: 000000000062d4b5 R14: 0000000000000000 R15: 0000000000000000
> > [   57.310737]  </TASK>
> > [   57.310963] ---[ end trace 0000000000000000 ]---
> > 
> > With "# CONFIG_KMALLOC_PARTITION_CACHES is not set":
> > RSI: 00000000002c2100 -> gfp_flags
> > 
> > Decoding the GFP bits:
> > 
> >   0x00000100 = __GFP_ZERO
> >   0x00002000 = __GFP_NOWARN
> >   0x00080000 = __GFP_NOMEMALLOC
> >   0x00040000 = __GFP_COMP
> >   0x00200000 = __GFP_THISNODE
> > 
> > The root cause:
> > 
> > Previously, the obj_ext allocation path(alloc_slab_obj_exts()) called kmalloc_nolock() with a
> > fixed set of flags(__GFP_ZERO | __GFP_NO_OBJ_EXT). After switching to kmalloc_flags(), the
> > full GFP mask from the upper allocation path propagates through the call chain.
> > 
> > In detail, ___slab_alloc() may append __GFP_THISNODE, and allocate_slab() adds __GFP_COMP
> > via s->allocflags. Both flags flow down unchanged into __kmalloc_nolock_noprof().
> > 
> > This patch only permits four flags (__GFP_ACCOUNT, __GFP_ZERO, __GFP_NOWARN and __GFP_NOMEMALLOC).
> > Since neither __GFP_THISNODE nor __GFP_COMP is in the allowed set, the warning is triggered.
> > 
> > Would the following fix be acceptable?
> > 
> >     +#define KMALLOC_NOLOCK_ALLOWED_GFP \
> >     +       (__GFP_ACCOUNT | __GFP_ZERO | __GFP_NOWARN | __GFP_NOMEMALLOC)
> >     +
> >     /*
> >     * The only version of kmalloc_node() that takes alloc_flags and thus can
> >     * determine on its own whether to handle the allocation via kmalloc_nolock() or
> >     @@ -5548,6 +5564,7 @@ void *__kmalloc_flags_noprof(DECL_TOKEN_PARAMS(size, token), gfp_t flags,
> >                     return __do_kmalloc_node(size, NULL, flags, node,
> >                                     PASS_TOKEN_PARAM(token), &ac);
> >             } else {
> >     +               flags &= KMALLOC_NOLOCK_ALLOWED_GFP;
> >                     return __kmalloc_nolock_noprof(PASS_TOKEN_PARAMS(size, token),
> >                                                 flags, node, &ac);
> >             }
> 
> Thanks, Hao Li pointed out __GFP_THISNODE and I filtered it from nested
> allocations like this:
> https://lore.kernel.org/all/49f1bf1e-fcaf-48fa-a7b1-f8ee78b19762@kernel.org/
> It makes sense to filter out __GFP_COMP too as that's a page allocator flag
> and not useful for (nested) kmalloc allocations, so I'll add that

Looks like I'm a beat behind on this one — this approach makes perfect sense to me. :-)

--
With Best Regards,
Shengming

