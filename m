Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 718B5CAC5B5
	for <linux-mm@archiver.kernel.org>; Thu, 25 Sep 2025 21:49:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A3BF38E0005; Thu, 25 Sep 2025 17:49:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A138F8E0001; Thu, 25 Sep 2025 17:49:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 929648E0005; Thu, 25 Sep 2025 17:49:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7FBFF8E0001
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 17:49:46 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3526611A424
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 21:49:46 +0000 (UTC)
X-FDA: 83929115172.20.582C614
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 59A7C16000A
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 21:49:44 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=ysJVlEj3;
	spf=pass (imf08.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758836984;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wiDQFvJAljCK4pp3FCGWtDWjE6mJ7LJZ0uWcIsDBkcM=;
	b=XRuOXFxEdEbZbym1GSop62SMpR1KP4GdKV5geSR077utZ/M8UbSWzVKy1eMjr3enc36KDk
	pMao6mtk5E67YbP1Pg1CN8CR3ejAzJJfO662utv63Wcw9Qz85w2qrHiJOdInvwcvwcINQs
	GKd0+VzrGQ4weiuMA0kzzSpnvOJcESQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758836984; a=rsa-sha256;
	cv=none;
	b=LCRJMd5DI921W+s5WxnISzFhpWUqP06UEgEptO+TE1ZK86ugrDMOuaFO2e/bzSpAKODJZX
	Llajt9E+vyfDToJgkXaGy6aPb10ZAx+BqZfeAlj+WKC/t23zMIU3eaTj3+NthE7Ixd+Vp+
	4CNW5Bp5G5WUYBurWJo0mihI1uqk8/Y=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=ysJVlEj3;
	spf=pass (imf08.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E04BC44B28;
	Thu, 25 Sep 2025 21:49:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6953BC4CEF0;
	Thu, 25 Sep 2025 21:49:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758836982;
	bh=yea2XZBdKd29JLgdM6CX1rrbboEwDzwvwj7Fijsfs0k=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=ysJVlEj3H84pHjMNJYPYrrzHWL47O/50ZHIBr3yLvdWQP/CArhHENoBvHRg4hUOhr
	 IuMlSd3Yf79fPTmvIBPuLXHU6TqBiaI/O2kdPzDzNNEUgvGkt/B9JENnp/7ZFUysCQ
	 AxA7KMh76CjtuPGer/mDvfyPtoSKtoij57MP18Vk=
Date: Thu, 25 Sep 2025 14:49:41 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: syzbot ci <syzbot+ci74a400bb557985f4@syzkaller.appspotmail.com>
Cc: david@redhat.com, kartikey406@gmail.com, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, muchun.song@linux.dev, osalvador@suse.de,
 syzbot@syzkaller.appspotmail.com, syzbot@lists.linux.dev,
 syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot ci] Re: hugetlbfs: skip VMAs without shareable locks in
 hugetlb_vmdelete_list
Message-Id: <20250925144941.125467b7a7717211f6322482@linux-foundation.org>
In-Reply-To: <68d5aee9.050a0220.25d7ab.008a.GAE@google.com>
References: <20250925144934.150299-1-kartikey406@gmail.com>
	<68d5aee9.050a0220.25d7ab.008a.GAE@google.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: wtrne13ip8yboudtzujpi16rpjqr98y5
X-Rspam-User: 
X-Rspamd-Queue-Id: 59A7C16000A
X-Rspamd-Server: rspam10
X-HE-Tag: 1758836984-553084
X-HE-Meta: U2FsdGVkX1+JPQgwkeTpvQZRusHUmK2g/GqFgX/ZU7JpI/cTs5areqIFqpQmv7dR007Lpl7XZ1ShMUnx/nN27T8mGScrjuZ3TTLKiJFW2Ii5bf6g7CqoSXGKwRm7g73BmRg1Qas5Js96+y3bg0Y8jdrINKZrItZbR9Y4rk2ixATdfcaPVcNZQAYFxZ9digvrFBgZ3ISazvzkEtLghoG9sMAwWvltjwXHXZeGrtsvCTsL7JFVzNV1f5ofsm5R4POyHs6i8EF1OCII/EM0ripXw3YlVN4jASrOXj/dW6fiS1y7Q96/rIs1tth/hEiUtzMQUcmh4wT+RdYhg+yND4vSNPbEcFoHIHKvZmYmkgtp/5cYki17BVns6hv6QcSn1hwKI1KnFk7sQWjgGLKmajPLovRzh8Shi8qUGrhyyeQgGTDu8BoraKCEBcJ9mBI2ckgA/3BnLry7ZGrduqt48wLk+AalxKHfVm5q7si4mPQ1sqsR6UfjIKCpgIW/7qinkyO08YqO3TfztCSIVTmqEgHoeJOfG5F1BXrTHqRjbRJ7OIQ1iHVL2HRi233gOFfTk+sImNuy7PawZ6jk6oHnCSz0uGkRmZ2rtAmQdL0Pkh3D2Ol3PrrVF2N79jDdIzWb81rMRcBDeFKchaIfbj7zM8qrFjkzDrnPB025XxuqU6nf1pUASKr5s0VxHOz/yg98tejC7IY1SwT+OF1KlKJZ1bQJ1qLJfgcQPZ5hdhB41eTLcDbYcqs3nFzwspJk0U6mKIkJSHTWtWhNCLkGtQcsZnBHeUEAFIjKdm7aZKOLAqnTqogP1oHWxqgSSRx8R+UU0AnvthWT9CZPbd/hSVBih1XpqVQ/2ZDOn8nUcZRGbGZFoiJUKDyzVymdrJhDlD7TYQi4CYMHtBk+OHnwUl5XYtdtSHHUMjOiQ1k1CiP7dhZ9tJ43jNQQD2tSUPp8TY3Br5snKQf+NBuGZ6sVS6/OxfG
 SnuTeSGS
 pX/AetuTEEc4ySvGbHCoJzk8kHPpB0C1XTiRtLt5g/hH/9cfiGFUVg+LAQEw4DzQi7+6r2rXcYnol1Z7xAxL1F3qyNCBtFtXbQd4q+YlmwYDbiF+Z5Ltk430r1o4YFZU/qlcf2kqYIWCOhFrAvlb7afqoAnhlMkM1m+ducjmcMd28/Zctb2EdnpKuSpevrZ44jSAWbooVuxgBcIW/OfSw267mwBSrZacg5MN7LgWFR/4kPoyxR1idqydRJ09BcCNiJfwJWlWuBaoPqw2bOiajEkZ+Om7IVKeZK8kFD6wSmVpCwDK4+u1QE5pAvdg3orpphWt1iWAueZtRnnaj76wa44yJ5YIyc2EJR3PQ4g9x+si89UyTbKaPncIuAESPvhyeAvCKM/1/ljKWfZxk9gbDybrUVrc89pWANyNbO0dquD+eTweDvanq0i5G1TAsxEP+qiqDaoUtghiaMBLPyT1fg5fC2s7sgz7XM2LRBuZb9NJly9dIFpAGTOWrAefeY7x7a+LL3rpY6G0itWrpn2KOq5oiOQC9kpjwMzv1uWX/cWItoLt2DqUbWtGXtZsxM6R7TEIpW6RKOtg81HSJjzYrVRD9HSuJq322ffncC7amywwFpf0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 25 Sep 2025 14:06:49 -0700 syzbot ci <syzbot+ci74a400bb557985f4@syzkaller.appspotmail.com> wrote:

> syzbot ci has tested the following series
> 
> [v1] hugetlbfs: skip VMAs without shareable locks in hugetlb_vmdelete_list
> https://lore.kernel.org/all/20250925144934.150299-1-kartikey406@gmail.com
> * [PATCH] hugetlbfs: skip VMAs without shareable locks in hugetlb_vmdelete_list
> 
> and found the following issue:
> WARNING: lock held when returning to user space in hugetlb_vmdelete_list
> 
> Full report is available here:
> https://ci.syzbot.org/series/7d3a090c-ec8f-4d0c-8f7b-8797e63f1fde
> 
> ***
> 
> WARNING: lock held when returning to user space in hugetlb_vmdelete_list
> 
> tree:      torvalds
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torvalds/linux
> base:      07e27ad16399afcd693be20211b0dfae63e0615f
> arch:      amd64
> compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
> config:    https://ci.syzbot.org/builds/06671e7c-eebd-4d11-9f0d-d9dae5637c0a/config
> C repro:   https://ci.syzbot.org/findings/75fcdb87-67fc-45ee-a70d-3064e8c1126c/c_repro
> syz repro: https://ci.syzbot.org/findings/75fcdb87-67fc-45ee-a70d-3064e8c1126c/syz_repro
> 
> ================================================
> WARNING: lock held when returning to user space!
> syzkaller #0 Not tainted

um yes.  Presumably something like the below is needed.

I'm wondering how this passed runtime testing?

If resending, please let's add a comment telling readers why we're
skipping !__vma_shareable_lock vmas.

I'll drop the patch, thanks.

--- a/fs/hugetlbfs/inode.c~hugetlbfs-skip-vmas-without-shareable-locks-in-hugetlb_vmdelete_list-fix
+++ a/fs/hugetlbfs/inode.c
@@ -488,7 +488,7 @@ hugetlb_vmdelete_list(struct rb_root_cac
 		if (!hugetlb_vma_trylock_write(vma))
 			continue;
 		if (!__vma_shareable_lock(vma))
-			continue;
+			goto skip;
 		v_start = vma_offset_start(vma, start);
 		v_end = vma_offset_end(vma, end);
 
@@ -499,6 +499,7 @@ hugetlb_vmdelete_list(struct rb_root_cac
 		 * vmas.  Therefore, lock is not held when calling
 		 * unmap_hugepage_range for private vmas.
 		 */
+skip:
 		hugetlb_vma_unlock_write(vma);
 	}
 }
_


