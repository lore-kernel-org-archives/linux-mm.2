Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A50F0606A6C4
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 19:32:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=Fsh4bQYq
Received: by kanga.kvack.org (Postfix)
	id 916806B05C4; Thu,  5 Nov 2026 14:32:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C6EC6B05C5; Thu,  5 Nov 2026 14:32:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 768366B05C6; Thu,  5 Nov 2026 14:32:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3F6F36B05C4
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 14:32:48 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id BE3AE1A0C47
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 19:32:47 +0000 (UTC)
X-FDA: 85402062774.01.2B213CC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id DF9FA1C0004
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 19:32:45 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Fsh4bQYq;
	spf=pass (imf21.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793907166;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9JYvchWNYP7Qhse19z85hXzOJjhHmC8E+HAVLm+92M0=;
	b=I21N2AUfHv+x+ni86YepAWmTVyb51tH8HQ8qzbVUfnukhlAxW0su+aYqOZn1j43nlHv/+Z
	R6yOiONXTfs9B/d/jbjzKfSfFIjGHWQcbVdb+uDiqUuFm8T+Raf6cyLTaHjDGbLVuH6Boh
	BPu+DBb9m2DJg4tA8vzcdVlpvmiqqM4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793907166;
	b=mSR1w6GFFCKLv+8W8KyK662sEXrjeo7N7f4aBwBn38JTJtXkKj2BiUk25zAyRQF7MQ7rK6
	QaUFFxOJTtbSNT5ETU/IPRlRekcjizHUgX5Xn2Py4Ia5aR4Jy4IAvZLkgy3P7k7dYOoVAM
	djbs5/hZljj+tKr1Oua9rTa1UFtV8OE=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Fsh4bQYq;
	spf=pass (imf21.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2580F40791;
	Thu,  5 Nov 2026 19:32:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B47911F00895;
	Thu,  5 Nov 2026 19:32:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793907165;
	bh=9JYvchWNYP7Qhse19z85hXzOJjhHmC8E+HAVLm+92M0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=Fsh4bQYqMWs7carasWGDuHRy4Vk/lJrPAI34OneO9HrTG2V1O8i5xUeFVX1yYbl+I
	 ZNyZyt/Ts+sjd3gO77ODfqyUhpNY6s+mf9lDYESl+MvTxE5P8sWgQuglBvGHq1fwHT
	 FLTCbyVVxaegRwIhVxhoszJ+XaI3i/Y2wOLcYpy0=
Date: Thu, 5 Nov 2026 11:32:44 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: syzbot <syzbot+4324f771847cecb27c54@syzkaller.appspotmail.com>
Cc: baolin.wang@linux.alibaba.com, brauner@kernel.org,
 fuse-devel@lists.linux.dev, hughd@google.com, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, mszeredi@redhat.com, syzkaller-bugs@googlegroups.com,
 syzkaller@googlegroups.com
Subject: Re: [syzbot] [mm?] [fuse?] WARNING in shmem_initxattrs
Message-Id: <20261105113244.274cfd420b666687f37643ec@linux-foundation.org>
In-Reply-To: <6aecb307.a24d9935.80af2.0019.GAE@google.com>
References: <20261105082717.c459bb33778fcf27e5675082@linux-foundation.org>
	<6aecb307.a24d9935.80af2.0019.GAE@google.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: n84b6p1sxtug7ihmxmriiuwkdzwi8ce1
X-Rspamd-Queue-Id: DF9FA1C0004
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-17.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793907165-614920
X-HE-Meta: U2FsdGVkX19+h50UsmSDBZQUJrIH+wVdL1ydU9zyJY5OUiXbENQDSefnKgYjA0CFcZYG51j005cdzxItoZ26kUaMqGHZgX+8NyfKYjECtkwnimfVFyIYipRvJrr1BfNmYMgYLVd6Zcgz3SbSf9mInnj8qhUZL60N/H4beuU/lQPS1Bt+LyWqK0TGSpuNPAtvcbiAnZqwh4O5x0R4HxX87LD1mGRMvmS8TvJ0GGQy5IG6Rz9RX7LnJ7lwMgUhAq/NUiNj3HjqSXUynlccfPYWPvspVnYr4qGWLXfj29lPUsFfROrCzoTRxRlAKXIRoCE49srFs9QzOW2SLQSszrFqjibK6AYinXi7FNYbbWRCaPSXlvi50orGas4rptByicCFBmstW58p6ulYYGN9zln8f6fMCBP315Qyz1kAAqj4zBKui/LNmUP6qDcEQXB+MfT8vlHEiDnYoZOcwUUhyjafHphcyNjXjzQZTWumbCbSVZyiJHBHuUUFfy2KhFPlUSAdmpSdb+mwZHN5Pmya19Uo01PSo/fFE5gRc7VRDzvq21Qo3cLTze0ufaSIiBeAL3O/JTpSd4IV/BmHW+xhZji7MmiJvDo6XVGtcwOJFIIYFYHYyJmb0zhEbLpz49v0Hu5vJByqyT11QyU8YeSWQYSjG8mx2aAEiEQ4kJwwf/zlTkTb3hn+pwZqpQXi0geTPJ0aX+GMlRBSHmj592ACJ/NHq+ibruHwoLC+oBpo9jW5RSXCJPYGNPRTsUBwjLGI++7hNHqFoFS2+ND00vAI/LVAlw1BeCdKcQiiSgj1YgD/EDF/ED2pdea9zkiYNgVRJbZ5p02AiUivbqqV7GRTeOdrQw5iIWH1pBe7zaNEI7EtYoymUvd7uv5fzTdayRHp8nGKQ/sOoWDXWL5gif7UE6uslVz2pp4mj/K8t74Jsad2uRqjklPyUPjH77+EKhgId3lyzUqd82neE7hfCJgi5oY
 VgOE25fZ
 o+99o1nhRxVGaErp0shADmjdlNRVhK9DDcKoc8/1TA33xtcF+/KqCKF/WmSSQyvEOU6l12tD7YnfZmDAQNONL0G4yVuXmsi9HXLgCXMRdXPy/3UC2RxTSXmUsA3mulxooMwU3oM5y3FmDULXfXzyUtMGQr6Cx6FMbpHiGt/+zr6XBS2kgqmLoy6+mi0r0r/bmR9wIRSpVxQbMCfihZ6T2WOUGY84TEuDSbYAs/LaT6Eq6io9rSa+UexTNCr+0nzsiwEO3+PH5Xe3ugB++3eYoOlOx9mKJ9BmmXApzmKbwtoosZtNFtWaHufct9fWKXKyAIFh/exwdFoPzmfKywQp8iHgKhf3XvL4XQcboYoLXVOC5f+1ZnDvJBc7vWLRvmEDgySB3xdCaGCwT2uPKbbWz8/czzSef3CalOOvimPjwUse2QpydTyJ06XfCiNAit27FyKxZRJIsRVTLtLuzX70HnTZ0VjKAMQ5OIdSTD1I69EPJhVhV43opYFnskOhYKtl321PaXZ/c5UkHgOFM/QNt8B77SKf80Cbi+gHbubakr8oo21Ar6yuqIC8OwbEW8yR8TLYQVyRj9H2nYB4aCD7SN8glaH1dj+9ro3gjRRAWMnFLuhgZBKlfSOGdtNqDXTQi979uAVjYVYczaPDpYOvHDh3yBONslLqpngyPS/fyFs7xELRadoNdXqWp2RmDzDcTMPEqjxtceS8JXDrPz7xlLxCj5FizY45hf607+kHG5Lv1p9DX++D7mNystw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, 05 Nov 2026 08:47:03 -0800 syzbot <syzbot+4324f771847cecb27c54@syzkaller.appspotmail.com> wrote:

> Hello,
> 
> syzbot has tested the proposed patch and the reproducer did not trigger any issue:
> 
> Reported-by: syzbot+4324f771847cecb27c54@syzkaller.appspotmail.com
> Tested-by: syzbot+4324f771847cecb27c54@syzkaller.appspotmail.com
> 

Great, thanks.  My LLM-controlled live-kernel testing setup liked it
too.

Christian, I'll send this over soon:


From: Andrew Morton <akpm@linux-foundation.org>
Subject: shmem: consume the reserved xattr space despite remount
Date: Thu, 05 Nov 2026 08:08:06 -0800

Creating a tmpfs inode can trigger WARN_ON(ispace) in shmem_initxattrs()
when a concurrent remount sets nr_inodes=0.  With panic_on_warn enabled,
this warning can panic the machine.

shmem_initxattrs() reserves space for the security xattrs while inode
limits are enabled.  It later tests max_inodes again before consuming that
reservation for each installed xattr.  If remount disables the limit
between those steps, successfully installed xattrs leave a nonzero
reservation behind.

Use the remaining reservation, rather than the current mount policy, to
decide whether to subtract the installed xattr's space.  This also leaves
the failure path with only the unconsumed reservation to refund.

An initially unlimited filesystem cannot acquire an inode limit through
remount: shmem_reconfigure() rejects that transition.

Link: https://lore.kernel.org/20261105082717.c459bb33778fcf27e5675082@linux-foundation.org
Fixes: 076e5cef28e27 ("simple_xattr: change interface to pass struct simple_xattrs")
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: <syzbot+4324f771847cecb27c54@syzkaller.appspotmail.com>
Closes: https://syzkaller.appspot.com/bug?extid=4324f771847cecb27c54
Tested-by: syzbot+4324f771847cecb27c54@syzkaller.appspotmail.com
Cc: Hugh Dickins <hughd@google.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Miklos Szeredi <mszeredi@redhat.com>
Cc: Christian Brauner <brauner@kernel.org>
---
Reproduced the warning before the fix and verified its absence
afterward in a Debian 13 guest with SELinux enabled (permissive).

A temporary hook paused file creation after reserving security-xattr
space. Another process completed a real nr_inodes=0 remount before
creation resumed. The unpatched kernel left 94 bytes unconsumed and
triggered WARN_ON(ispace); the patched kernel consumed the reservation
completely. File contents and the security xattr were verified.

Ordinary creation on limited and unlimited tmpfs mounts also passed
on both kernels. No additional KASAN or lockdep reports occurred.

Tested Linux 7.4.0-rc1 with GCC 13.3, KASAN and lockdep, using KVM:
8 GiB RAM, four vCPUs and one virtual NUMA node, backed by a
Threadripper PRO 3995WX. Both kernels had the same diagnostic hook;
the ordering was forced rather than left to random stress.

 mm/shmem.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/shmem.c~shmem-consume-the-reserved-xattr-space-despite-remount
+++ a/mm/shmem.c
@@ -4451,7 +4451,7 @@ static int shmem_initxattrs(struct inode
 		if (simple_xattr_add(&sbinfo->xa_cache, &info->xattrs, new_xattr))
 			break;
 
-		if (sbinfo->max_inodes)
+		if (ispace)
 			ispace -= simple_xattr_space(new_xattr->name, new_xattr->size);
 		retain_and_null_ptr(new_xattr);
 	}
_


