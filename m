Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 90F2F606D82B
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 16:27:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=bCWtbtkE
Received: by kanga.kvack.org (Postfix)
	id B3D256B05B8; Thu,  5 Nov 2026 11:27:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AEE2C6B05B9; Thu,  5 Nov 2026 11:27:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A062B6B05BA; Thu,  5 Nov 2026 11:27:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7A6E96B05B8
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 11:27:21 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0C4391C4574
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 16:27:21 +0000 (UTC)
X-FDA: 85401595482.24.7DD3D88
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 15D6C4000D
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 16:27:18 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=bCWtbtkE;
	dmarc=none;
	spf=pass (imf04.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793896039;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yNEceuVF4+1dEHMso5FiTKoIIlIwJZWRYcUiC/JkgOo=;
	b=qVuhukgood4baFQHHKZfIDxFFVlUlbjjJ/Ajwr0TSkH7u5j+BXy0dpmEOskH5ZhhFAAuL7
	nmFR8OVLT1feLFz0V4dgzFcT9kqw2z6VRhtOP0PLr5LGhqEP0R+UQZ9LIr/C+POhb56htn
	VLLXzIVg0TjuQB26rVTc/TMpBDGuc+I=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793896039;
	b=1uUN/bmQCIqUVLsntoqvrr5KOUSr2YCA5cU/TklXiBQlEaxarCYQFacHOfBRZaUgF1oFDG
	K3D3HCfFPW5l+m3pJ6Hetz95DVA8RNP6pyDmsx5J+iyyJbel8DASxMPPEGHN3YyvgA/Wme
	At8hS4wsDFHRDZpsy1Q6t8RrE3KCFXU=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=bCWtbtkE;
	dmarc=none;
	spf=pass (imf04.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8FF07600AA;
	Thu,  5 Nov 2026 16:27:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0156D1F000C1;
	Thu,  5 Nov 2026 16:27:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793896038;
	bh=yNEceuVF4+1dEHMso5FiTKoIIlIwJZWRYcUiC/JkgOo=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=bCWtbtkEDpyTUbwzvxe6MGZwVSKfAqoj503Jn568t34yc39Fe9sgjWVscGfykg1r0
	 j1PwfEeAdKwqlS5XJPr/3Z8clpnlSYMJz97Zk4kZGpJ2xqQINseX9gnXJTMqQfLg2J
	 MK+hifwQuNYe+Rc/y0DKuB01mvfolNPPjiLxAmr4=
Date: Thu, 5 Nov 2026 08:27:17 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: syzbot <syzbot+4324f771847cecb27c54@syzkaller.appspotmail.com>
Cc: baolin.wang@linux.alibaba.com, fuse-devel@lists.linux.dev,
 hughd@google.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 syzkaller-bugs@googlegroups.com, syzkaller@googlegroups.com, Miklos Szeredi
 <mszeredi@redhat.com>, Christian Brauner <brauner@kernel.org>
Subject: Re: [syzbot] [mm?] [fuse?] WARNING in shmem_initxattrs
Message-Id: <20261105082717.c459bb33778fcf27e5675082@linux-foundation.org>
In-Reply-To: <6aec6433.0ce67c00.35143.0001.GAE@google.com>
References: <6aec6433.0ce67c00.35143.0001.GAE@google.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 5wuckypi49r98kp5dshm4jzom743pt7r
X-Rspam-User: 
X-Spam-Status: No, score=-22.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,NICE_REPLY_A,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 15D6C4000D
X-HE-Tag: 1793896038-887861
X-HE-Meta: U2FsdGVkX1+awtsQKuZb61AGEngQgJCoLQZrqhU/rq5uDtP+F3Jr5NKFgQASH01XeLEPXqA50TQRP7F/Dmf7nZ/ZGFo0Wn/6R3C11oWLRfb5qfu+kkb7k2GbSFFnkxui8Z7R4i72gHWQ9c68DlMygHa2zyL9hP6Il5X8xb8S9FFy+uSQ3sq2Gsdq27xTd2w6iYcT6LzVLJjrsqosEWqSXf8dBxC+yMBFuWFQVkaFzckjXL6mKbJXhViFvAXwcVB/fgiR4fNgZchegTKGo5ZAoIhDmq6RGY9HE4BPEqh1Wjbm77ZOUZGR+21t0VRuTt1UHMAdDj4HTcV0aRKxQjpIOAeU5EPHe5If6qnZG3l0V483GcA3dXmPf/LTAPr9jf2fYQOwGyYDDN9ZRX+foGpkwaV7eD8AUBLaidUNlSMj7gBRRdLsC4CrsiQN3F2Z1g5QF9tA3dpFGTeiMo1udqU50tY/VaRYpmOY1Yz6vTuCocQtvKo6q7gGNUljOZLNDFgjX5NOWJbQrxYGCl6JBHfLpBYQnERwhtuI0I09BZmFaaMgtvMuWd4exnqPqlLgfQlyzdgMtlaEzG3ONQkeJFWXjgoyRGfJKvQw4amYJH8BukCU0AsVxeUuYc5feTVcgpQAIW+afzGrEBCHrEi+rAIOcGObdsyLuO3SzdSkkXwtH4Rk97F2rCKYZD8z6orKeyIe6d5adOTCVmOJzYnTGs3HVrzfcXXQK20a0SXyZUoAR2OaAw6234qNOBJip5I6XfwHwTpBCSioiOyGTFypkMPkWBr7Z4Ga5ClsACsTOHzlV/Q9fwmXwz6fO0vde5fkYGQ/qVaPtJ2XAR7Z15/x5wcjq6SzYyPYnIbcu4w+I8kKXXfUb4UmSKDjBv3ImAwCMHPrtGgeT3PEMbNYndblT1vFwSn3EBuB0JTZDFB6WIf02P5r9nsOBppjJkzMhBniku4ar8z+GOlamUJ+0UCR1cW
 szDzN7h7
 xjNeL6khxjaZg1PKmVSGQJ0bwZ+9dVfyNwomFWGwuJ9OXY9MZupsX7jMtHYSYLOF6GP91FkOgd4LXCcFR0P9u4nG2Uhlj3qEylc4epdCV3muAmehq5djbCR704OZIpPTnLJmYLE1wk/wZNhi4BMY2W1d3mHZmgEH/bd1tMEwy6KnwPuhcnfyP4I5Nv345R8xuRWXxhnWPFGxaUXi9rmFO/KoyO/ibE8hvo3q3OxNdA837xO643O6fonOz9nGrGItK5BgY0C19AVfrXXnWUENJYQFsOZnyMePe/rl+UstjrMZEZT3+Y4IwdF6CM6zHu8fVgaluJXeKBA1WAUmJNPZjEAaSNLMYGtXz16nJ/t8odAPWFxPCt7Mh/KGwTehy3qiZ6cs99XDOVoNMVmt3EBgnp0ZwKF3/5i7pHGuYHmlLsXW6KcpJh0a5Ws8mEIDPRu6SFskZDmFh0ey6Gbhuk+7q5sH4lmWBmItDcPxTsQgISv6iEAzY/dZwwy0quARYc+eTPcyzelS2zw1Xi5xAtBWM1E15CjevbrZuWkclQG0HONlMRRNmjx8LLCuTJzmwX2B12p68hN/TMmtWPUYL31zAmg/fOlvJy4dz7TN2pYF/MMIV0M3gccM4UutuVhe83oiJhw99+YcZGoNaStT8lmH9JMcN1uLhRkRSjJbapTBsPoqy7gmf/JbCH5vcJJ0DhXQqizbytaKd6GYhoiSI5936admaCP8lO/03aE1/nytOJU/j80VQiOJZvHqpErErkwKLihdnQZh6vf0RwjZxY2z8FlP7hFL6cxUJIxwPBWvbQa6kalXMzUWi2oicmquYKGtEN9y/fODkMqWggzx0AjtwD8s2zej0KKDFOfUNG68c5eVF1n5bGA00zJjXDfN8p4In2BNqL+lzH6NCxXUdg/Pb46Tg6R8w5VPqtl1tOmlhx0M8vunk2rm+kboprKyZMRzXqBZofipLMA0csNff3VGSs/x+QtJO
 a1Z4dtVO
 NJK2TGRBiuojGbxdGzjecypV70fzBnNSjgGIfwv54aT+hmW8gOMxXHgOXOhZ2Lj1LkgJmAPEkcIaCEFUn10lxggdyp8Lg+kGJxmV3XniuD38isvlzi843oQDQ5cY18Kw5IwGGALO/sJ/SbwWxNqMrVnd9cmLbkw4uMfsMPD4D4kU57SBdRsHaXuDDaO5GUUsGLoRqbVl09kbEi3ebVU/WQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, 05 Nov 2026 03:10:43 -0800 syzbot <syzbot+4324f771847cecb27c54@syzkaller.appspotmail.com> wrote:

> syzbot found the following issue on:
> 
> HEAD commit:    05441d697f7f Merge tag 'cocci-7.4-rc1' of git://git.kernel..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=17bcaca1580000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=1cf189394a856f11
> dashboard link: https://syzkaller.appspot.com/bug?extid=4324f771847cecb27c54
> compiler:       gcc (Debian 14.2.0-19) 14.2.0, GNU ld (GNU Binutils for Debian) 2.44
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14423cbe580000
> 
> Downloadable assets:
> disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-05441d69.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/0edd3964be19/vmlinux-05441d69.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/84d6d8dd5648/bzImage-05441d69.xz
> 
> AI-generated root cause summary:
> In mm/shmem.c:shmem_initxattrs(), the initial reservation of inode xattr space
> (ispace) from sbinfo->free_ispace is gated by 'if (sbinfo->max_inodes)', and
> subsequent per-xattr subtraction from ispace is also gated by 'if
> (sbinfo->max_inodes)'. Because sbinfo->max_inodes is accessed locklessly and can
> be concurrently modified to 0 during a remount (shmem_reconfigure() with
> nr_inodes=0), ispace can be reserved when max_inodes is non-zero, but fail to be
> decremented when max_inodes becomes 0. Consequently, after all security xattrs
> are successfully allocated and added, ispace remains non-zero, tripping the
> WARN_ON(ispace) assertion.
> 
> full analysis:  https://syzkaller.appspot.com/x/ai_root_cause?x=4324f771847cecb27c54

Well that's convenient, thanks!  Two additional suggestions:


- The Subject "[mm?] [fuse?]" can be tightened.  I told my thing

      figure out a Subject for this bug report - identify
      the kernel subsystem which is primarily affected

  and it responded

      Subject: [BUG] shmem: xattr accounting warning when remount disables inode limits


- Use your LLM to figure out who to cc on the report:

      figure out who should be cc'ed on this.  Use the
      MAINTAINERS entries for the affected files.  Also use git to
      figure out who has recently worked on the affected code.  Prefer
      to choose developers who have recently shown significant
      involvement in kernel work.

   and it replied

      Cc: Hugh Dickins <hughd@google.com>
      Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
      Cc: Miklos Szeredi <mszeredi@redhat.com>
      Cc: Christian Brauner <brauner@kernel.org>
      Cc: linux-mm@kvack.org
      Cc: linux-fsdevel@vger.kernel.org
      Cc: linux-kernel@vger.kernel.org
      Cc: syzbot+4324f771847cecb27c54@syzkaller.appspotmail.com

      Hugh and Baolin: the maintainer and reviewer listed under
      TMPFS (SHMEM FILESYSTEM), which explicitly covers mm/shmem.c. 
      Baolin also has recent shmem fixes and substantial review
      activity.  

      Miklos: the most directly relevant developer.  Git
      identifies him as author of 076e5cef28e27, "simple_xattr: change
      interface to pass struct simple_xattrs", from June 2026.

      Christian: committed that change and authored the preceding
      rhashtable-based shmem xattr conversion.  His involvement is
      directly in this code, rather than merely elsewhere in
      mm/shmem.c.  


and, of course "fix the dang bug",  I'll test this later.


#syz test

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

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: <syzbot+4324f771847cecb27c54@syzkaller.appspotmail.com>
Closes: https://syzkaller.appspot.com/bug?extid=4324f771847cecb27c54
---
Test candidate against 05441d697f7f9a927264f4058cbbc6a03dfcac9d.
Application checked; no kernel build or runtime reproduction performed.
Fixes attribution and stable-backport scope have not yet been verified.

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


