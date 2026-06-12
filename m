Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 81A6DCD98CE
	for <linux-mm@archiver.kernel.org>; Fri, 12 Jun 2026 12:52:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9F8A26B008C; Fri, 12 Jun 2026 08:52:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9A77F6B0092; Fri, 12 Jun 2026 08:52:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8BD196B0093; Fri, 12 Jun 2026 08:52:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7B6936B008C
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 08:52:42 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1924A40327
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 12:52:42 +0000 (UTC)
X-FDA: 84871249764.12.389AE2A
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [160.30.148.35])
	by imf31.hostedemail.com (Postfix) with ESMTP id 3834220004
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 12:52:39 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=none;
	spf=pass (imf31.hostedemail.com: domain of hu.shengming@zte.com.cn designates 160.30.148.35 as permitted sender) smtp.mailfrom=hu.shengming@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781268760;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=62Z51I62WB8HEow+r0rzzy9TAJw/X9nvAnQsdZVbyxE=;
	b=kQTM8CKxxeaeJaKVm6v+5caHEMjAXrZviG746TdZwgEF842NLG3Gp7oe5xW/qIgm5JdEVc
	zGY+a0NUvsWQgT0GaJg6rcKi3Iv0IvsdDREZxd/A3TqaRWGXCDmB89+wSthUtfpfRNjMrN
	R6EhE/iX/Gbtu3M5AhtsfQ9j9+ZakIY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781268760;
	b=Ghfvp9eY7b+VfA1TcM35hM5wz1jEmkuSl3pcKkgyCYHddsgVDyIFHxi6HX7F+ah5KzgARC
	txDkCB0Io3AzC1nhdtLgEmhkz4xcYjCTARC6K9j8IIwtdS27jqUna7yTFko4lLJP/MO5Hs
	161Ov6+ejpj87hPqjxmUvQ2WYz5lNq8=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=none;
	spf=pass (imf31.hostedemail.com: domain of hu.shengming@zte.com.cn designates 160.30.148.35 as permitted sender) smtp.mailfrom=hu.shengming@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
Received: from mse-fl2.zte.com.cn (unknown [10.5.228.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxhk.zte.com.cn (FangMail) with ESMTPS id 4gcKDK6ZcVz8Xrrj;
	Fri, 12 Jun 2026 20:52:33 +0800 (CST)
Received: from xaxapp05.zte.com.cn ([10.99.98.109])
	by mse-fl2.zte.com.cn with SMTP id 65CCqTtD041610;
	Fri, 12 Jun 2026 20:52:29 +0800 (+08)
	(envelope-from hu.shengming@zte.com.cn)
Received: from mapi (xaxapp04[null])
	by mapi (Zmail) with MAPI id mid32;
	Fri, 12 Jun 2026 20:52:30 +0800 (CST)
X-Zmail-TransId: 2afb6a2c010e452-03bc0
X-Mailer: Zmail v1.0
Message-ID: <20260612205230395zeZ-tyvcj3PnuOeD0ppp3@zte.com.cn>
Date: Fri, 12 Jun 2026 20:52:30 +0800 (CST)
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
X-MAIL:mse-fl2.zte.com.cn 65CCqTtD041610
X-TLS: YES
X-ENVELOPE-SENDER: hu.shengming@zte.com.cn
X-SOURCE-IP: 10.5.228.133 unknown Fri, 12 Jun 2026 20:52:33 +0800
X-CLEAN: YES
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6A2C0111.000/4gcKDK6ZcVz8Xrrj
X-Rspamd-Queue-Id: 3834220004
X-Rspam-User: 
X-Stat-Signature: bztcp7c5weneymp7bfdhi7he7ko4twa3
X-Rspamd-Server: rspam08
X-HE-Tag: 1781268759-398016
X-HE-Meta: U2FsdGVkX18f9f1N/9kdBYwzQ61uCPotiUXNOKxJkafw7PjOyQF9dzM/nPbgv/FkG1L87hTXt9Z9oeShy/0xVYWG0K7SXri/30KXCUKtL7NHXiPCcjxZDz1lTD9t1NHgDOlEFNIfOzasGQV3Q+ErGO80TCzIi3JzirjtCnf6CD1RqofSr5xsM6WHxDbP/QDCuPkFUTXHXCLRn6a4K3PNZtJR/XL+3zTLukMlO5bN/+Ey9LYPzRa1hogz+h8WncvYmPgKxzfNqTDg/5xj7YMpYAy+rSIsVfS5MhALt+7+DXRBrUGenQHQ1AfW1qDlI+Z3hyKVrSe4Vh6FCpl2C7ipLyBxRkNFHTL6rxvSgJJBPOpSTTjePLZyaw5xEiTrN6ZjMgDckUmAnf5HyWnhfH07cgrB+ZrvYAXClMnNYKDigjenzKltKBfyNa0PwYLfb42viu7oxEs3DmM8A5sUqyAYBLldrnqgXqjoF6r3LFlLvYpoyg1DzrBBAQ91w/VXkw+H5Rq5Iz5GS67poJvJ0mfeYS+jHJzMcxYIkpxaL5IAko9OtZy8kMqSQNNk0mqy6J49GZJ+qnh8cMhmkzfJvXXdJU2GlqeOvTp6oIrP3JUMya7hOR1TYg21A9fO4Hrib46whXumF0+nnl0tym6CjwyXPzZ9Tdaz7gfKXymdtxWZLVm6Y0W4TZHuKs6TLBEd20VINIe7HKMp/nMsHIwtmj2Eihz5IanN3Fd79QPExi3d5wsu+78rZXymMoJAXD3/XbjMA1abMpv7/+lSqHl8dgXzYheZxy48VBAGQvqmV6EDktzYonylrJP2Fmy+CQi0HPyL2i2l5DXQOSpJk7J5lFd1yNRz+RSDi99EhEbJFgfR9jpgk/EjjmpEtydf2BSapX9DlqqC85BUsWPvUPUrVa+SZd6lZS/wgch5OrOn8V4S/Q4wY88HUoSXDIhPMKxI/i0Cjkr+3ZEQkuvNEkPvrnc
 FXpxsSOC
 iCKKrtxoC7uNRBKK3igLCKvnQJT1jP6dmCVZh3J1VTjld/P/F1mw23C/iHjOSxl+3Y4VsF5GIhQdz/d3JPa4M97a9W93HjflAylrJNyV+s12yNqaDrhcXoTEXR0suIYBdxS/dT3cqxQBxfdZ/9odpQqic55EHkHixvRLnp2S+kihukuIBNCbj9Qm+/gVuPNMOy5aF6mfV9V5E4IQVHBwqZFfA8At+V0jxFMip8RGJgVGPRca10hE118JoWalHL7shBpx+71Ay6xXoJs0w2DijEuRc8n3MvjzaAYNGjLiqyNH+EmhdmIIwuwLBYKNQIeU/7FNL
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Vlastimil Babka (SUSE) wrote:
> The two flags are added internally so there's no point for warning if
> they are passed by the caller as well, so allow them. This will allow
> simplifying obj_ext allocation under kmalloc_nolock().
> 
> Also it's not necessary to have the extra alloc_gfp variable for adding
> the two flags. The original gfp_flags parameter is not used anywhere
> except for the warning. So remove alloc_gfp and directly modify and use
> gfp_flags everywhere.
> 
> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> ---
>  include/linux/slab.h |  3 ++-
>  mm/slub.c            | 19 ++++++++++---------
>  2 files changed, 12 insertions(+), 10 deletions(-)
> 
> diff --git a/include/linux/slab.h b/include/linux/slab.h
> index ce1c867dc0ba..b955f3cbb732 100644
> --- a/include/linux/slab.h
> +++ b/include/linux/slab.h
> @@ -1040,7 +1040,8 @@ void *_kmalloc_nolock_noprof(DECL_TOKEN_PARAMS(size, token), gfp_t gfp_flags, in
>   * kmalloc_nolock - Allocate an object of given size from any context.
>   * @size: size to allocate
>   * @gfp_flags: GFP flags. Only __GFP_ACCOUNT, __GFP_ZERO, __GFP_NO_OBJ_EXT
> - * allowed.
> + * allowed. Also __GFP_NOWARN and __GFP_NOMEMALLOC are allowed but added
> + * internally thus not necessary.
>   * @node: node number of the target node.
>   *
>   * Return: pointer to the new object or NULL in case of error.
> diff --git a/mm/slub.c b/mm/slub.c
> index 6845e15c148a..847cad5203b2 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -5388,7 +5388,6 @@ EXPORT_SYMBOL(__kmalloc_noprof);
>  
>  void *_kmalloc_nolock_noprof(DECL_TOKEN_PARAMS(size, token), gfp_t gfp_flags, int node)
>  {
> -	gfp_t alloc_gfp = __GFP_NOWARN | __GFP_NOMEMALLOC | gfp_flags;
>  	size_t orig_size = size;
>  	unsigned int alloc_flags = SLAB_ALLOC_TRYLOCK;
>  	struct kmem_cache *s;
> @@ -5396,7 +5395,9 @@ void *_kmalloc_nolock_noprof(DECL_TOKEN_PARAMS(size, token), gfp_t gfp_flags, in
>  	void *ret;
>  
>  	VM_WARN_ON_ONCE(gfp_flags & ~(__GFP_ACCOUNT | __GFP_ZERO |
> -				      __GFP_NO_OBJ_EXT));
> +			__GFP_NO_OBJ_EXT | __GFP_NOWARN | __GFP_NOMEMALLOC));
> +
> +	gfp_flags |= __GFP_NOWARN | __GFP_NOMEMALLOC;
>  

Hi Vlastimil,

While reviewing your patch, I spotted a potential GFP flag mismatch along the kmalloc_flags()
-> __kmalloc_nolock_noprof() call path. I cloned the slab/for-next branch to verify this and
successfully triggered a VM_WARN_ON_ONCE() in the __kmalloc_nolock_noprof() path.

Here is the observed trace:

[   57.283791] ------------[ cut here ]------------
[   57.284226] WARNING: mm/slub.c:5407 at __kmalloc_nolock_noprof+0x3ec/0x450, CPU#6: insmod/379
[   57.285060] Modules linked in: slub_nolock(O+)
[   57.285494] CPU: 6 UID: 0 PID: 379 Comm: insmod Tainted: G           O        7.1.0-rc3-00036-g5ade53586fae-dirty #5 PREEMPT(lazy) 
[   57.286608] Tainted: [O]=OOT_MODULE
[   57.286941] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.12.1-0-ga5cab58e9a3f-prebuilt.qemu.org 04/01/2014
[   57.288018] RIP: 0010:__kmalloc_nolock_noprof+0x3ec/0x450
[   57.288543] Code: 01 00 8b 4c 24 04 41 89 c2 e9 dd fc ff ff b8 10 00 00 00 e9 f9 fd ff ff 90 0f 0b 90 f7 04 24 ff de b7 ff 0f 84 54
[   57.290252] RSP: 0018:ffffa82840c73b68 EFLAGS: 00010206
[   57.290752] RAX: 0000000000000000 RBX: 0000000000000003 RCX: ffffa82840c73bc8
[   57.291428] RDX: 0000000000000000 RSI: 00000000002c2100 RDI: 0000000000000100
[   57.292124] RBP: 0000000000000000 R08: ffffffffb853c968 R09: 0000000000009ffb
[   57.292821] R10: 00000000000001d7 R11: ffffffffb850c980 R12: 00000000002c2100
[   57.293485] R13: 0000000000000000 R14: ffffa82840c73bc8 R15: 0000000000000003
[   57.294159] FS:  0000000006fa8880(0000) GS:ffff8f4ef9d5a000(0000) knlGS:0000000000000000
[   57.294914] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   57.295464] CR2: 0000000006fac528 CR3: 000000003f9b6003 CR4: 0000000000770ef0
[   57.296124] PKRU: 55555554
[   57.296443] Call Trace:
[   57.296702]  <TASK>
[   57.296914]  ? vprintk_emit+0x22e/0x280
[   57.297295]  __kmalloc_flags_noprof+0x216/0x530
[   57.297735]  ? _printk+0x56/0x70
[   57.298053]  ? alloc_slab_obj_exts+0x89/0x1e0
[   57.298474]  alloc_slab_obj_exts+0x89/0x1e0
[   57.298876]  new_slab+0x2bc/0x660
[   57.299200]  ___slab_alloc+0x2ae/0x660
[   57.299603]  __kmalloc_nolock_noprof+0x151/0x450
[   57.300050]  _kmalloc_nolock_noprof+0x47/0x70
[   57.300490]  ? slub_nolock_init+0x127/0xff0 [slub_nolock]
[   57.301013]  slub_nolock_init+0x127/0xff0 [slub_nolock]
[   57.301566]  ? __pfx_slub_nolock_init+0x10/0x10 [slub_nolock]
[   57.302197]  do_one_initcall+0x44/0x220
[   57.302598]  ? do_init_module+0x1e/0x240
[   57.302990]  do_init_module+0x5f/0x240
[   57.303357]  __do_sys_init_module+0x162/0x190
[   57.303783]  do_syscall_64+0xf7/0x550
[   57.304159]  entry_SYSCALL_64_after_hwframe+0x77/0x7f
[   57.304648] RIP: 0033:0x4b8839
[   57.304954] Code: 00 f3 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 40
[   57.306676] RSP: 002b:00007ffea38fdce8 EFLAGS: 00000246 ORIG_RAX: 00000000000000af
[   57.307376] RAX: ffffffffffffffda RBX: 00007ffea38fe080 RCX: 00000000004b8839
[   57.308044] RDX: 000000000062d4b5 RSI: 0000000000002790 RDI: 0000000006fa9d20
[   57.308710] RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000002790
[   57.309366] R10: 0000000006fa9cc0 R11: 0000000000000246 R12: 00007ffea38fe088
[   57.310040] R13: 000000000062d4b5 R14: 0000000000000000 R15: 0000000000000000
[   57.310737]  </TASK>
[   57.310963] ---[ end trace 0000000000000000 ]---

With "# CONFIG_KMALLOC_PARTITION_CACHES is not set":
RSI: 00000000002c2100 -> gfp_flags

Decoding the GFP bits:

  0x00000100 = __GFP_ZERO
  0x00002000 = __GFP_NOWARN
  0x00080000 = __GFP_NOMEMALLOC
  0x00040000 = __GFP_COMP
  0x00200000 = __GFP_THISNODE

The root cause:

Previously, the obj_ext allocation path(alloc_slab_obj_exts()) called kmalloc_nolock() with a
fixed set of flags(__GFP_ZERO | __GFP_NO_OBJ_EXT). After switching to kmalloc_flags(), the
full GFP mask from the upper allocation path propagates through the call chain.

In detail, ___slab_alloc() may append __GFP_THISNODE, and allocate_slab() adds __GFP_COMP
via s->allocflags. Both flags flow down unchanged into __kmalloc_nolock_noprof().

This patch only permits four flags (__GFP_ACCOUNT, __GFP_ZERO, __GFP_NOWARN and __GFP_NOMEMALLOC).
Since neither __GFP_THISNODE nor __GFP_COMP is in the allowed set, the warning is triggered.

Would the following fix be acceptable?

    +#define KMALLOC_NOLOCK_ALLOWED_GFP \
    +       (__GFP_ACCOUNT | __GFP_ZERO | __GFP_NOWARN | __GFP_NOMEMALLOC)
    +
    /*
    * The only version of kmalloc_node() that takes alloc_flags and thus can
    * determine on its own whether to handle the allocation via kmalloc_nolock() or
    @@ -5548,6 +5564,7 @@ void *__kmalloc_flags_noprof(DECL_TOKEN_PARAMS(size, token), gfp_t flags,
                    return __do_kmalloc_node(size, NULL, flags, node,
                                    PASS_TOKEN_PARAM(token), &ac);
            } else {
    +               flags &= KMALLOC_NOLOCK_ALLOWED_GFP;
                    return __kmalloc_nolock_noprof(PASS_TOKEN_PARAMS(size, token),
                                                flags, node, &ac);
            }

--
With Best Regards,
Shengming

>  	if (unlikely(!size))
>  		return ZERO_SIZE_PTR;
> @@ -5415,7 +5416,7 @@ void *_kmalloc_nolock_noprof(DECL_TOKEN_PARAMS(size, token), gfp_t gfp_flags, in
>  retry:
>  	if (unlikely(size > KMALLOC_MAX_CACHE_SIZE))
>  		return NULL;
> -	s = kmalloc_slab(size, NULL, alloc_gfp, PASS_TOKEN_PARAM(token));
> +	s = kmalloc_slab(size, NULL, gfp_flags, PASS_TOKEN_PARAM(token));
>  
>  	if (!(s->flags & __CMPXCHG_DOUBLE) && !kmem_cache_debug(s))
>  		/*
> @@ -5429,7 +5430,7 @@ void *_kmalloc_nolock_noprof(DECL_TOKEN_PARAMS(size, token), gfp_t gfp_flags, in
>  		 */
>  		return NULL;
>  
> -	ret = alloc_from_pcs(s, alloc_gfp, alloc_flags, node);
> +	ret = alloc_from_pcs(s, gfp_flags, alloc_flags, node);
>  	if (ret)
>  		goto success;
>  
> @@ -5445,7 +5446,7 @@ void *_kmalloc_nolock_noprof(DECL_TOKEN_PARAMS(size, token), gfp_t gfp_flags, in
>  	 * kfence_alloc. Hence call __slab_alloc_node() (at most twice)
>  	 * and slab_post_alloc_hook() directly.
>  	 */
> -	ret = __slab_alloc_node(s, alloc_gfp, node, &ac);
> +	ret = __slab_alloc_node(s, gfp_flags, node, &ac);
>  
>  	/*
>  	 * It's possible we failed due to trylock as we preempted someone with
> @@ -5458,8 +5459,8 @@ void *_kmalloc_nolock_noprof(DECL_TOKEN_PARAMS(size, token), gfp_t gfp_flags, in
>  		size = s->object_size + 1;
>  		/*
>  		 * Another alternative is to
> -		 * if (memcg) alloc_gfp &= ~__GFP_ACCOUNT;
> -		 * else if (!memcg) alloc_gfp |= __GFP_ACCOUNT;
> +		 * if (memcg) gfp_flags &= ~__GFP_ACCOUNT;
> +		 * else if (!memcg) gfp_flags |= __GFP_ACCOUNT;
>  		 * to retry from bucket of the same size.
>  		 */
>  		can_retry = false;
> @@ -5468,9 +5469,9 @@ void *_kmalloc_nolock_noprof(DECL_TOKEN_PARAMS(size, token), gfp_t gfp_flags, in
>  
>  success:
>  	maybe_wipe_obj_freeptr(s, ret);
> -	slab_post_alloc_hook(s, alloc_gfp, 1, &ret, &ac);
> +	slab_post_alloc_hook(s, gfp_flags, 1, &ret, &ac);
>  
> -	ret = kasan_kmalloc(s, ret, orig_size, alloc_gfp);
> +	ret = kasan_kmalloc(s, ret, orig_size, gfp_flags);
>  	return ret;
>  }
>  EXPORT_SYMBOL_GPL(_kmalloc_nolock_noprof);
> 
> -- 
> 2.54.0
>

