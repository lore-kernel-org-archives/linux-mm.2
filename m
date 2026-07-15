Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E6AA5C4450A
	for <linux-mm@archiver.kernel.org>; Wed, 15 Jul 2026 14:04:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D665D6B0095; Wed, 15 Jul 2026 10:04:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D14D16B0096; Wed, 15 Jul 2026 10:04:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BDE566B0099; Wed, 15 Jul 2026 10:04:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 976AE6B0095
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 10:04:02 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6EB9BA0016
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 10:26:19 +0000 (UTC)
X-FDA: 84990631278.13.43A68EB
Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	by imf28.hostedemail.com (Postfix) with ESMTP id 4B98DC0004
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 10:26:17 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=hx4OibK1;
	spf=pass (imf28.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784111177;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kEd62YpRlYzH7ddXxgaLtMBL/oT0lPJiUJAY2FiEygY=;
	b=5ArBDY/EBJRGBiby+0xKue1aJWzHGFtMUSbkb6xneQDmW8lc+Yp2EhBxTi3cL7i9+cCwi4
	/f9Nt0MrmAydqPSsknxFVrvgMT+VD6wmz5DEZ76oF4XsqmGgOkJw+3v2H8sS4MqTAyr9r2
	hIJ717/ESEagN/wrNQBU66fjl8ufw4Y=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=hx4OibK1;
	spf=pass (imf28.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784111177;
	b=l171dp5wmIJXQNlVlzhcGZLnFbQJtJ77/LXlysXFfojeliRXJFggpaRCgMXWXKlXOxZCBt
	CwzSNLd5jKuAEixQ7fe2hiwjCLeR98fveU0eA+yerGF0c3rS7BLAv8afs1zk1pvikceg3E
	pV2RqlMk9rT2Ww02qpVhPWt3MrygKtU=
Message-ID: <44bf7cd3-8083-454c-9419-d377061e31c2@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784111174;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kEd62YpRlYzH7ddXxgaLtMBL/oT0lPJiUJAY2FiEygY=;
	b=hx4OibK1fXVjDH6lWemesdKXKAAp8ftOERwPW2o9fu+hyp2uu+GzE3hSdBoXrCoRdTdWtf
	AVHlJUwVDD5uhg+HbwYA6G70/DEf8VD+cV4zliNOWad5kMQ1pCHY0BnbWdEMFYlu4O6nRA
	pIYP/tCPGwtoKeOapGthO5rvafaKxRI=
Date: Wed, 15 Jul 2026 11:26:08 +0100
MIME-Version: 1.0
Subject: Re: [PATCH] fs: push nr_cached_objects memcg gating into individual
 filesystems
To: Dave Chinner <dgc@kernel.org>
Cc: brauner@kernel.org, qi.zheng@linux.dev, jack@suse.cz,
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
 Al Viro <viro@zeniv.linux.org.uk>, linux-mm@kvack.org, hughd@google.com,
 boris@bur.io, clm@fb.com, dsterba@suse.com, linux-btrfs@vger.kernel.org,
 cem@kernel.org, linux-xfs@vger.kernel.org, shakeel.butt@linux.dev,
 hannes@cmpxchg.org, riel@surriel.com, kernel-team@meta.com
References: <20260714101454.1202449-1-usama.arif@linux.dev>
 <ala2rDHrFDjql3Qg@dread>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Usama Arif <usama.arif@linux.dev>
In-Reply-To: <ala2rDHrFDjql3Qg@dread>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: skf3d937w4yyyhtes36hbgop4fexcpcb
X-Rspamd-Queue-Id: 4B98DC0004
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1784111177-597043
X-HE-Meta: U2FsdGVkX19lzIb/jZjokMPY7Wh8ohuYu1ezuPTPjyffT9Enh/E6z6/yiAaWiMwAYiKLhjQfr5tE7Z8xtTMkwJhjoDuxgyFbg7Ux23dnaEzfmp4bEuLXeeKEt7gZoYC2AzygUdgqEckxeZCQp9Rknf7tyzkD4at7KszJoOo6r+iqpz360b8ey+WkIebjt1wBtlJJeY5i+iMaTiQpNE5QO6br4Q/qYdwr+IToMoCIl5z0zVEAEGmGOOkYV0/YgIyLkke9PTchfYFQM6ZMdyUuJ7/V8bzXY2uIdt6C9oBYHyEqtcFAQ7+ULvrL1oHaPvGBk62lTCHlQEKDC1/+fM0RSMONHVu+APtifofLP4ktxnoJQj63rDkzgddJE/HYvZFIgOEpPK4oCZibmoDbASEU8SqMlfn6cCiqjCrvl1Wf9V7Cg3+OjtCz9k6KzRzjnj6IqaQHsPqyhCWmsjSv4F0DOaDGPaUv4H0z1bKWxBx6waYSj8VroyQU++aElVStTzxbUdkO8Gkl/k14nja2qsj3AYXcSbnEavJvTDptSEy7dJ+a5rzLkRTux3L6u8x0/u0PCQHJzxgg25k3qSyLy/DkLI4+exjgmw4k4yZjpkF6LXC78wcuSnh3Zdv3OKEqPdMErFLeHXpSRV5fGx7bN6R9kUILqqMVLEiC92vrQH83H4/V6hT2CtyML7q2GCVxXojjbJEsZVt61E0SY2xVK6xw5/+m7fJaBRnnEOlbDp4yjgw/Xv/FTYTKXUr6XoVr3CNw0A+UP9fYlot9oQWoGYMQs44+2ypTWAtBfVmrAZtJblmmubdLMkdlXXBRlWVZGjqZSaH1ReRgULngwTrLnjcron8VfH8/fe/zE0e2xhNQxHU6EUITLDMu8NpabStsgsd9qUXwjlnW+fuVr3gnE3hOjAE5G8/PkcEdGhluCpGRSxvywOFNBNeoNeQglqW22P0xLmgUfp1cunkQ4RecJvk
 /r0dCsaL
 miL9MTM1b0a2DGIE07E1j4rmBokEhHfnNFlmgDkERPdIUGaRY3G5L57ad5CDbs3O7OPJY1jcYMqyxog/mnQy3jJr1TbuPisIwO+QD03Low2Masrqlxhvszsn0NtPbJFViqaV606+2t2HPAQNN6t7TtlXfSxGxEGsoZWDEJ/3g6UJy5cUG4PQ+9UGD79DpsdVnHNmKDqxi+qQKuoGrl0llKElug4Am1w2rVFnh5taxtAYtoq4EhbsiH3UhyrMyCSRV89sc8kgmHop2m5JCymOh8mgIx8PgogxCtIX5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 14/07/2026 23:22, Dave Chinner wrote:
> On Tue, Jul 14, 2026 at 03:14:54AM -0700, Usama Arif wrote:
>> Commit 0baad6f9b997 ("fs/super: skip non-memcg-aware nr_cached_objects
>> in memcg slab shrink") added a check in fs/super.c that skips the
>> ->nr_cached_objects() hook whenever the shrinker is invoked for a
>> non-root memcg, because none of the current implementations (btrfs,
>> xfs, shmem huge) honour sc->memcg.
> 
> I don't see that commit in an upstream tree. I'm guessing I wasn't
> cc'd on it, either, because I don't recall seeing that as a patch,
> either.

Ah sorry about this, I just ran get_maintainers.pl on the patch, plus added
shmem, btrfs and xfs maintainers on it. get_maintainers.pl didn't report
shrinker maintainers (likely because the change was in fs/) and it didn't
come to my mind as well :(

The patch is here: https://lore.kernel.org/all/20260609123047.1948242-1-usama.arif@linux.dev/> 
> However, if anything is gating the fs_objects callouts to the fs
> when memcg is being srhunk, then it is fundamentally broken and you
> are correct to fix it.
> 
>>
>> That policy is really a filesystem-owned property: fs/super.c should
>> not encode the assumption that these hooks are never memcg-aware,
>> since a future implementation might legitimately filter by sc->memcg.
>> Move the check into btrfs_nr_cached_objects(), xfs_fs_nr_cached_objects()
>> and shmem_unused_huge_count() so each filesystem can lift the
>> restriction independently once its underlying counters/scans become
>> memcg-aware, without needing a coordinated change to fs/super.c.
> 
> However, your assumptions here are incorrect.
> 
> That is, the XFS fs_objects implementation is intended to be called
> even when memcg shrinking is occurring. I architected it that way
> all those years ago when I introduced the fs_objects shrinker
> callout. i.e. XFS is not aging reclaimable inodes via this call - it
> is purely an expedite freeing of recently reclaimed VFS inodes when
> there is memory pressure of any kind.
> 
> Reclaimable XFS inodes are still charged to memcgs, but we don't
> track them per-memcg because it is extremely inefficient when their
> lifetime after being released by the VFS is usually less than 5
> seconds. Indeed, this low level cache is not for working set
> retention; the VFS inode cache does that. The XFS inodes need to
> through a GC state before they can be freed, this takes a little bit
> of time, so we don't hold up the VFS inode cache shrinker for that.
> 
> The VFS inode cache shrinker is memcg aware, so it only pushes
> inodes that are being reclaimed by memcg reclaim into the the
> reclaimable state at the XFS level. Hence we don't need to track
> reclaimable inodes by memcg - we know that memcg owned inodes that
> are to be freed have already been pushed into reclaim by the VFS
> shrinker doing memcg reclaim. Hence all we need to do is sweep them
> and free them.
> 
> This is what the XFS fs objects shrinker does.  It needs to run in
> conjunction with -any- shrinker context to immediately free the
> clean inodes that the VFS shrinker released that pass, and to
> release any of the recently released VFS inodes that needed GC and
> are now clean and can be freed.
> 
> IOWs, the XFS fs_objects callout is not "memcg-aware" in the classic
> sense of "it tracks objects by their owner memcg". However, the
> -combined superblock shrinker algorithm- is memcg aware and that
> results in XFS only seeing objects from the memcg being reclaimed
> transitioning to RECLAIMABLE state which it then immediately sweeps
> away.
> 
> i.e. the architecture of the VFS and XFS inode cache reclaim is
> entirely memcg aware, and that is why I implemented the fs_objects
> callout for XFS all those years ago. It works efficiently, it works
> correctly with memcg based reclaim, and XFS doesn't need to care
> about memcgs in it's low level reclaim code. Win, win, win.

Ack on above, and Thanks for explaining this!> 
>> Behaviour is unchanged: calls into these hooks from shrink_slab_memcg()
> 
> Behaviour was broken by the above commit, it needs to change.

Ack.> 
>> still early-return 0 for non-root memcg contexts, keeping the shrinker
>> bit clearable in each memcg's bitmap; the global (kswapd or root
>> direct reclaim) path still drives them as before.
>>
>> Signed-off-by: Usama Arif <usama.arif@linux.dev>
>>
>> @@ -170,19 +169,6 @@ static void super_wake(struct super_block *sb, unsigned int flag)
>>  	wake_up_var(&sb->s_flags);
>>  }
>>  
>> -/*
>> - * The s_op->nr_cached_objects hooks (used for example by btrfs and xfs)
>> - * operate on filesystem-global state and ignore sc->memcg. Driving them
>> - * from per-memcg shrink_slab_memcg() invocations only burns CPU walking
>> - * per-cpu counters and queueing duplicate work: the actual reclaim happens on
>> - * the global path (kswapd or root direct reclaim) regardless. Restrict them
>> - * to that path.
>> - */
>> -static inline bool super_fs_objects_eligible(struct shrink_control *sc)
>> -{
>> -	return !sc->memcg || mem_cgroup_is_root(sc->memcg);
>> -}
> 
> This wrapper should still exist (with a better name) so filesystems
> don't need to open code memcg cruft.

Ack,

I am going to send a v2, which will include Fixes tag and follow above.> 
> -Dave.


