Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0A30E606A324
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 02:25:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=RddVEMc0
Received: by kanga.kvack.org (Postfix)
	id 276206B00EF; Sun,  1 Nov 2026 21:25:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 226696B05B1; Sun,  1 Nov 2026 21:25:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 13C4A6B05B2; Sun,  1 Nov 2026 21:25:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DE33E6B00EF
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 21:25:03 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 35D0340BDE
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 02:25:03 +0000 (UTC)
X-FDA: 85388586486.22.B11FCC4
Received: from mta1.migadu.com (out-149.mta1.migadu.com [95.215.58.149])
	by imf28.hostedemail.com (Postfix) with ESMTP id 19D97C0004
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 02:25:00 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=RddVEMc0;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf28.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.149 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793586301;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2mnsyMY9o09dxT12b5diRUF6Cicg8w6KasRAQlIeI/I=;
	b=UH18FIdw4upPOPTWDFOzMysKF2AI2WG5b0rYwHfG143oM44GpWybnSkHtkrxOcc4rl77py
	IkKbeye4YgJqjgSqpdrv9VgYU5Ru12myBgKLJJKc6TrG2O+SfQSpQ9jHxhEVAQ4lWLIsOz
	7uUE5xRFCexUuMD+yH7fPK0tmDdMJRk=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=RddVEMc0;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf28.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.149 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793586301;
	b=t7i/9dTaYkd+1KMbym//0GZZzRSEyn8h+TE9t7YwxihwKcW3f7KuzkDcq6xqCDGRcOWnR8
	TN9RBkf6vzhu+pb57nOBEBoiwwbwxT280fFMlb03dZhqMcEqRu+mUOeOlEG14nK9PzJIUq
	E0ooNZ9fsqwnAiUl8ejoj7vd1xy5i/M=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=9MWJaTq44xn+tvTxU7mQ3vu6AIJLcPaBU+1NzYl4ghk=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793586296; v=1; x=1794191096;
 b=RddVEMc0Nc6NAvlP05NTHE/hYX6XO7jCA5N64VxWF8G/+V12NHaXseYCOduZ0SctWX3A7uDu
 L+u9fua1pQ5u2i6+Vm7RredncvQPNGs4PAdTii9cVvi5XHeCVlBVbfXRwIe4gik+HI9JdH4yyKr
 KjWpVYrcR93TY51p6/OHadUw=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id 112a86c3f0c26040;
	Mon, 02 Nov 2026 02:24:56 +0000
X-Mizu-Trace-ID: 112a86c3f0c26040
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.200.71.1.16\))
Subject: Re: [PATCH v3] hugetlbfs: move hugetlbfs_free_inode tracepoint to
 ->destroy_inode()
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20261101-b4-hugetlbfs-trace-v3-1-051b716f490f@gmail.com>
Date: Mon, 2 Nov 2026 10:24:38 +0800
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
Message-Id: <6FC96012-76AA-483B-BDA4-8E1C1ABB5FFE@linux.dev>
References: <20261101-b4-hugetlbfs-trace-v3-1-051b716f490f@gmail.com>
To: joasantonio108@gmail.com
X-Mailer: Apple Mail (2.3901.200.71.1.16)
X-Rspamd-Queue-Id: 19D97C0004
X-Stat-Signature: f9tmimgk8otza5csw7d3o8pmo5bj17ir
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793586300-886783
X-HE-Meta: U2FsdGVkX1+I+56u0dZnF7DhQVrxwelnaML0LaLVLNUtnnNTRHoCLSWUF7PTb1kDk2jh4YEX62v+MTGLJRhVeuJHQIEBXqpqJFKkoRJEbDkjyxozyrja3tfDISmD0V+6ZXxQFE92hHXm+xGhGC1CESZwaLPC2PoW70VFMaQe78LRH82zQFgav4tY4fY1m+rEpu9Jfh6ybjlwWlflyDsUookmW6T43rYdTL2ucEHCKlAOxhWTzN3tMvVH92rd1GuOCfQFQbDqVPBDrXu4+pUK+TykMhJxPnhu3Zp1R2Zl8PGe1uPP6ODJdXBKji9xBezAiHMqrdwbGAcxeDm1APSe/5mwPdeVnKQMEUeSSJiCk8/G4zKbjJ+ilg4r3KeWMloef9Y05vbNoR9mcmcRshEPhAAvtUSmNjGZJ/+qo82jV6Fqhvz/Qv0Oj+1pCX1h0Ypg+PZfx2PXCu3lGriFDbGWyrePvyxOauXEopC0bPEzKhkhZh0PPEx3QhoTt+MluwWxTHwIpdDcqT8CKJlSNgoT0fe//8XeuybyqEsk8GTbU4GIC2xVBchZ0Bha0f4fhh0STXi0R1b2znu8IKRqlXhN3BojVeFbUsZCFGbYCykJ6pkWTOxXV8XW3N/J+Z4UhKha9pw18Dh5mFrsYhO+uveajo/JpDPeB4gBIRnkRJgduiLUN/Igb3ZOUZewUO0cZtp3+gooETgZ5Wtlmn62LyKPfd45CfCwjapUAilDiGVBYWoO9DDU9C+BpssGCiHgmhNgFCrx/pHZtoLjmIB+gDFTn5ACUlXdhDSFVQKgBrhkeyu1LTM6x3HTEDBf59QR/orcx40qeqobLq0za2ouv2u6AKw33NL/D5lsF61H8ECHhl2IsF3NdQ55227cYbzVtFASTq1iZF+jEpCJNB7i77GP1hHIbv2KqUCvy1LYq+uFoyUVRa+72H92FjmMX1PSK6B+RZhQrPKKmmNObvwXylB
 qk/n+oxF
 jFdOVwQ+gyhiTdgnXEu8xwhgvPIeSY4Sq9oL2TW/7vPl7iBreOxDOe0svobEMdJlu5uwjK5uaikrpaSh/tffS0YROpcTH4ap3coBAcaWalrjkCWunTNbsFBvRGtIg+kYmx9uy61FPDLte8FglunkmyTsF3DKaxfB3YN/vKeE74FamgDVxOVTQYMlntjj3DlGs/dQ8e62Yr+6VTcfWM31jlNDpgsJEoDLTbtIk4V4zjeqUdCZWcvlW7SWs00NcBI4nqwLPfYaz2j+v4gBH/Zo8D2LluEqcaaD2Mefxlp0jpFGVi2pJ2OE7TI/BPBYhuuQSzw0JKOYOoA9Mx4Lk4z4Cw+xOuRUcxoO7kYwzWlUMWBtQHAwZLXMy0bBeHQUHmOYCJ8KHziO4IOTtChmI+UlUrO8csnrS+tGnGEhlVG3NLjgGAAeNlgQKqD4Uf/tDua/M0WtHsQKIEPMlgYgqtE0gsMVw2xst40Yvk5PJRzwuaRu7SpBqMOmVsbEQ+5Ii3m3aS330T5yqaCq//49nBVKardNLgtr5MHDkcmUUmRAlly9zK5yVSZLyKYdxkNbLlhYnNyhT
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



> On Nov 1, 2026, at 21:48, Joas Antonio dos Santos via B4 Relay =
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
> Since the event no longer fires from ->free_inode(), rename it to
> hugetlbfs_destroy_inode so that its name matches where it is emitted,
> as suggested by David and Muchun.
>=20
> Found by syzbot; analysed and tested with the syzbot C reproducer on =
an
> arm64 KASAN kernel.
>=20
> Fixes: 014ad7c42a69 ("hugetlbfs: use tracepoints in hugetlbfs =
functions.")
> Reported-by: syzbot+91e1fc35f51774c479b2@syzkaller.appspotmail.com
> Closes: =
https://lore.kernel.org/all/6ae27525.5451848c.f7707.0001.GAE@google.com/
> Suggested-by: David Hildenbrand <david@kernel.org>
> Suggested-by: Muchun Song <muchun.song@linux.dev>
> Cc: stable@vger.kernel.org
> Signed-off-by: Joas Antonio dos Santos <joasantonio108@gmail.com>
> ---
> Andrew, this replaces
> hugetlbfs-emit-hugetlbfs_free_inode-from-destroy_inode.patch in
> mm-hotfixes-unstable.
>=20
> Tested with the syzbot C reproducer (adjusted for the new event name)
> on an arm64 KASAN kernel: no splat in 3 of 3 boots, and
> hugetlbfs_destroy_inode events are recorded.
>=20
> Tool-use note: the analysis and testing were done with help from an
> LLM-based assistant; I reviewed the change and ran the tests myself.
> ---
> Changes in v3:
> - Rename the tracepoint to hugetlbfs_destroy_inode in the same patch,
>  so its name matches where it now fires (David, Muchun).
> - v2 was the resend with the Assisted-by trailer dropped; it should
>  have been marked v2 in the subject, sorry about that.
> - Link to v2: =
https://lore.kernel.org/r/20261031-b4-hugetlbfs-trace-v1-1-4ec8d02a30cc@gm=
ail.com
> ---
> fs/hugetlbfs/inode.c             | 6 +++++-
> include/trace/events/hugetlbfs.h | 2 +-
> 2 files changed, 6 insertions(+), 2 deletions(-)
>=20
> diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
> index 01c4d6f44e..095b7fceee 100644
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

Since the trace point name has already been changed, the comment here
doesn't seem to serve much purpose anymore, as there isn't any =
ambiguity.

With the comment removed:

Reviewed-by: Muchun Song <muchun.song@linux.dev>

Thanks.

> +	trace_hugetlbfs_destroy_inode(inode);
> 	hugetlbfs_inc_free_inodes(HUGETLBFS_SB(inode->i_sb));
> }
>=20
> diff --git a/include/trace/events/hugetlbfs.h =
b/include/trace/events/hugetlbfs.h
> index 8ba72c1d4f..a7932e0db0 100644
> --- a/include/trace/events/hugetlbfs.h
> +++ b/include/trace/events/hugetlbfs.h
> @@ -72,7 +72,7 @@ DEFINE_EVENT(hugetlbfs__inode, =
hugetlbfs_evict_inode,
> 	TP_ARGS(inode)
> );
>=20
> -DEFINE_EVENT(hugetlbfs__inode, hugetlbfs_free_inode,
> +DEFINE_EVENT(hugetlbfs__inode, hugetlbfs_destroy_inode,
>=20
> 	TP_PROTO(struct inode *inode),
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


