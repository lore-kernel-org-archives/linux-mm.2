Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 528F8606A327
	for <linux-mm@archiver.kernel.org>; Sun,  1 Nov 2026 03:13:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=b6R/J3oD
Received: by kanga.kvack.org (Postfix)
	id 678A56B00EF; Sat, 31 Oct 2026 23:13:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 62D2C6B05B1; Sat, 31 Oct 2026 23:13:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 518CC6B05B2; Sat, 31 Oct 2026 23:13:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 248146B00EF
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 23:13:46 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A317C4079F
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 03:13:45 +0000 (UTC)
X-FDA: 85385080410.03.B02B1B8
Received: from mta1.migadu.com (out-92.mta1.migadu.com [95.215.58.92])
	by imf26.hostedemail.com (Postfix) with ESMTP id 1FF93140004
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 03:13:41 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="b6R/J3oD";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf26.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.92 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793502822;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=G2Sq0gLLsHldeSIR+epke8YlRr21X/+4SzZkJoBo7gY=;
	b=tB1c3GFBy60hxTWn0BTkrucf5jV4JBnpP/kNf78zpAoOcV8m0qHmKnEFoHzwkwMP8qKh/4
	c9bpopXsQ57bg4EuUUMPIJKioBEj/2+SL2gOCWRUgmJdMTxPBdpvYldT3xBZuPY+aFTvT/
	FoX+803YjoYJ1iMAQtsUHKGMGIOK0nw=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="b6R/J3oD";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf26.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.92 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793502822;
	b=py0XaQyW9g5j02pgbzQRAm2Hih+Ioirq0xSiH+7MJjHIxHal01TvXzhw39FPF08zMq96sY
	ijehRdR52O4VbWkVsPY70mpop+pJ075g8S5GJiEfAZh3weKGVMw72dSkJup0D3LXaBpeVw
	7g74YPEsAe5XHZfi11lkYjdAG0FPL6E=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=9EHwrI8bkAWMARTdLxi0cB28WQ9c8LLtlAJzoaChO84=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793502820; v=1; x=1794107620;
 b=b6R/J3oD9Mt3LlXnLwajFd7+WOQcAce4m3j5KWvdNrmex1E9nerZkVONXfReFMeOrmqWIbQg
 A95yHdAEN0hc45oeIJiicazdWnGLlXXXymdhpsjdI0Ik3/Q48hH/mnCxYMG3Im21SCIrtyQ0CxO
 4ic5vh+KRpfcmwO0mpL0fMX8=
X-Envelope-To: linux-mm@kvack.org
Received: by mta11.migadu.com with ESMTPS id a030bda49eede247;
	Sun, 01 Nov 2026 03:13:40 +0000
X-Mizu-Trace-ID: a030bda49eede247
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.100.1.1.12\))
Subject: Re: [PATCH] hugetlbfs: emit hugetlbfs_free_inode from
 ->destroy_inode()
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20261031-b4-hugetlbfs-trace-v1-1-4ec8d02a30cc@gmail.com>
Date: Sun, 1 Nov 2026 11:13:18 +0800
Cc: Oscar Salvador <osalvador@suse.de>,
 David Hildenbrand <david@kernel.org>,
 linux-mm@kvack.org,
 Andrew Morton <akpm@linux-foundation.org>,
 Hongbo Li <lihongbo22@huawei.com>,
 linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org,
 syzbot+91e1fc35f51774c479b2@syzkaller.appspotmail.com,
 stable@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <ADB13A93-9C2E-4136-B639-742069AF74D6@linux.dev>
References: <20261031-b4-hugetlbfs-trace-v1-1-4ec8d02a30cc@gmail.com>
To: joasantonio108@gmail.com
X-Mailer: Apple Mail (2.3901.100.1.1.12)
X-Rspamd-Queue-Id: 1FF93140004
X-Rspam-User: 
X-Stat-Signature: s4x5676nnzid6e97c1g7mrq7f36gqk6h
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1793502821-211506
X-HE-Meta: U2FsdGVkX18RR9zmshBB/vcAfc5llVJRN4WT3mR5PwZAKGi1RqXDItyQHfWyIo9/kKpw+zOYGCN0uxmbQ9E/0szNzSjypwjC3g+XKh3YMq0QqunYUIWO9I/ZM20s68U//n/35X6A0569lQ2cC919buFwE20KTdj5C30IvwjAZpUCtA56cGr6nRRbDub7gRgHsEanyXPh8vmaCq8zPgjqLDwkpRWPYbn5eQQ5WCFZ5ZshfQrgToiKvRxnpS2hPJalytqL/E4EOJBMdUO3TsH9It5cnU4VuTetDym3/NeXUv4tNvcMMIKQdf2dpDUN/N7wQEawqEtGkZfxYXiks2TlMOjJNIdPR6RY7dMWfI2sra6pRsM7RpQj7nqiai7F2XEeuC6kX9qG840y1YzlnPLOTXnh6Ht/I52WNal7tj+pJHj9EFYUMXXU17PN8+5vRuXGhvU0xhnxPp3sUrP5ZZzndCyIp2nU0xQC9x4bo5AqgeWUfK/bEdg4tKfrhZiTr41Oqa7Vi3J1K5VRwtvzinbQFVmxptIbJJbf6p1CDnL0wriGbYuHRdC5E/qgA+KkUSgozNACqtAx5JuXzVBPma1NrvlY+PmZCzclvJ7rruoBbezZ0IFyVr2KwbniDv6aBSqSipbrl0s0shzSnEfqwB+ygcePZRMApNX12SmalQYXq/5/VyT6OpM8tXGfNdFEChCxsXlDr5vHW5N8W4dAZ5C7zhQt45Ro6yaOrEqGGlqF3uXOyOGl2YYSfk+mhUSIw2fCDLGE/HUZJygW8OVZ7K1TSaP6lJlcFvZgqbFrVvI9qcFocu7k/a1OtxJqCFjDWS9pkK1yP0oqjdUVhMZZOfI2aTYZp5X5imvWUzaxORqKa+P/4mqPJWNc+vCyx0OAxA4J5eUbrXZkmMXHmRTdcpekhtbdwprReHlX1jii2TvamKiZO+uNFWIr8c02JXATXJAR1Pt+NPBsF1g6dk+TZhx
 CMNvsiJQ
 r2egSTpBZfTL+UpOJLkPH/0eDwzbNt+Ut4Y90yHkntQ+m/oavqtoLGl8cj8waY3mmv0Wsv2jk/Y/c1EmSRlLF+vjGsT5JUqbEsEblcpz1yuZhEAZiMfp/Z7OIMOPUbemGpLmNKv001ACxs7gc7z1kViOS/AJJOP5JZiod41Do2DNI5wMQ2TFTk0aETHcGi3Lu50M98+WcnuHXY1PpTPKqLgPeofm88CDqha9len+7WmAuWzUL+btwHwJzn+hUq3f5PUQVBbWV+1KBQfPAb1TBrH/iIYUcGLnej5SMGo9iLMtUm4kjHytNZ7VH1MAvFPGg6toahiw6TrYR5n5on6HV7BND/nQn+OvMT9nTXyaa1QsscexXPzq7BiTr366WP741j1OmG7be1ETOsdGULmpXKXnlj1WoAF71NP5L2KvWYkBvUMzjiGhLVzP1SN9Ey8n92dwvKCQuUtt5hiVML3xPxLuN+maQ3o6T/OTtbKMpKa0pcoZAa/cj2J6MjPS9soXGyctih+O8tNCH0EJueFgiOIncT6IpfjYJ1QGVLYPFvAfbKwk/TD1PLJMpd1Qx9SkbtBFu
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

This is the V2 version. you should specify it in your subject line =
prefix.

> On Nov 1, 2026, at 00:06, Joas Antonio dos Santos via B4 Relay =
<devnull+joasantonio108.gmail.com@kernel.org> wrote:
>=20
> From: Joas Antonio dos Santos <joasantonio108@gmail.com>
>=20
> hugetlbfs_free_inode() calls trace_hugetlbfs_free_inode(), and the
> hugetlbfs__inode event class records inode->i_sb->s_dev.  =
->free_inode()
> runs from an RCU callback (destroy_inode() queues i_callback() with
> call_rcu()), and Documentation/filesystems/porting.rst says that this
> callback "is *NOT* ordered wrt superblock destruction; as the matter =
of
> fact, the superblock and all associated structures might be already
> gone".  put_super() frees the superblock with call_rcu() followed by a
> workqueue item (destroy_super_rcu() -> destroy_super_work()).  syzbot
> hit this with the event enabled:
>=20
>  BUG: KASAN: slab-use-after-free in =
trace_event_raw_event_hugetlbfs__inode+0x45b/0x4c0 =
include/trace/events/hugetlbfs.h:36
>  Read of size 4 at addr ffff888038850010 by task syz-executor952/6134
>   hugetlbfs_free_inode+0x15e/0x1f0 fs/hugetlbfs/inode.c:1182
>   i_callback+0x46/0x80 fs/inode.c:317
>   rcu_do_batch kernel/rcu/tree.c:2650 [inline]
>   rcu_core+0x5f0/0x1220 kernel/rcu/tree.c:2919
>  Allocated by task 6134:
>   alloc_super fs/super.c:326 [inline]
>   sget_fc+0x1ba/0x1f60 fs/super.c:874
>   hugetlbfs_get_tree+0x1e7/0x2b0 fs/hugetlbfs/inode.c:1431
>  Freed by task 855:
>   kfree+0x22b/0x6d0 mm/slub.c:6923
>   process_one_work+0xac7/0x1b10 kernel/workqueue.c:3495
>=20
> Emit the event from hugetlbfs_destroy_inode() instead.  =
destroy_inode()
> calls ->destroy_inode() synchronously, before it queues the RCU
> callback, while the superblock is still alive; =
hugetlbfs_destroy_inode()
> already dereferences inode->i_sb there.  ->free_inode() is left with
> only the kmem_cache_free().
>=20
> Fixes: 014ad7c42a69 ("hugetlbfs: use tracepoints in hugetlbfs =
functions.")
> Reported-by: syzbot+91e1fc35f51774c479b2@syzkaller.appspotmail.com
> Closes: =
https://lore.kernel.org/all/6ae27525.5451848c.f7707.0001.GAE@google.com/
> Cc: stable@vger.kernel.org
> Signed-off-by: Joas Antonio dos Santos <joasantonio108@gmail.com>
> ---
> Resend: my mail provider blocked the original submission to the lists
> on 2026-10-29, so only the direct recipients got it. No change to the
> patch, except dropping a deprecated Assisted-by trailer.
>=20
> David asked whether the tracepoint should be renamed now that it no
> longer fires from ->free_inode(). I'd keep this patch as is, since it
> is tagged for stable and the event name is visible in tracefs
> (events/hugetlbfs/hugetlbfs_free_inode); renaming it in stable kernels
> would break existing tracing setups just to fix the use-after-free. I
> can send a follow-up for mm-unstable that renames it to
> hugetlbfs_destroy_inode, next to hugetlbfs_evict_inode, or fold the
> rename into a v2 if preferred.

At least for me, I think we should rename it, and it belongs to the fix
itself. Otherwise, we will introduce another behavior change, someone
thinks the tracepoint is fired through free_inode callback, but it's
not, it's weird.

Thanks,
Muchun

>=20
> Tested with the syzbot C reproducer on a KASAN kernel with the event
> enabled: the use-after-free reproduced in 3 of 3 boots without the
> patch and in none of 12 runs with it, and the event is still emitted.
>=20
> Tool-use note: the analysis and testing were done with help from an
> LLM-based assistant; I reviewed the change and ran the tests myself.
> ---
> fs/hugetlbfs/inode.c | 6 +++++-
> 1 file changed, 5 insertions(+), 1 deletion(-)
>=20
> diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
> index 01c4d6f44..5bd348288 100644
> --- a/fs/hugetlbfs/inode.c
> +++ b/fs/hugetlbfs/inode.c
> @@ -1179,12 +1179,16 @@ static struct inode =
*hugetlbfs_alloc_inode(struct super_block *sb)
>=20
> static void hugetlbfs_free_inode(struct inode *inode)
> {
> -	trace_hugetlbfs_free_inode(inode);
> 	kmem_cache_free(hugetlbfs_inode_cachep, HUGETLBFS_I(inode));
> }
>=20
> static void hugetlbfs_destroy_inode(struct inode *inode)
> {
> +	/*
> +	 * Not in ->free_inode(): that runs from an RCU callback, when =
the
> +	 * superblock the event reads may already be freed.
> +	 */
> +	trace_hugetlbfs_free_inode(inode);
> 	hugetlbfs_inc_free_inodes(HUGETLBFS_SB(inode->i_sb));
> }
>=20
>=20
> ---
> base-commit: c339f4010dea8b0d754f84ace70cd1b089878ef8
> change-id: 20261031-b4-hugetlbfs-trace-341b338ab57b
>=20
> Best regards,
> --=20
> Joas Antonio dos Santos <joasantonio108@gmail.com>
>=20
>=20


