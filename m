Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 82457EA8131
	for <linux-mm@archiver.kernel.org>; Tue, 10 Feb 2026 15:45:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BB7156B0005; Tue, 10 Feb 2026 10:45:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B8F186B0089; Tue, 10 Feb 2026 10:45:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A66F26B008A; Tue, 10 Feb 2026 10:45:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 96CB96B0005
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 10:45:51 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 326631C5B9
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 15:45:51 +0000 (UTC)
X-FDA: 84428972502.11.D0D2D4C
Received: from mail-oa1-f71.google.com (mail-oa1-f71.google.com [209.85.160.71])
	by imf17.hostedemail.com (Postfix) with ESMTP id 563004000B
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 15:45:49 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf17.hostedemail.com: domain of 3rFKLaQkbANEFLM7x881ExCC50.3BB381HF1EzBAG1AG.zB9@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.160.71 as permitted sender) smtp.mailfrom=3rFKLaQkbANEFLM7x881ExCC50.3BB381HF1EzBAG1AG.zB9@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770738349;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references;
	bh=umYiyPeqfv4hz6b8WdCAw8Mf6WoinfgY1PV/QiXW0KY=;
	b=RIGwnlErPMp99aUZ7qgR7pX0B7bzX6+q7x8sUav/CEHSI1e91VJT4VnHLQk8FEnZdn+6Zz
	dXl/Mgxj3fEB4Pvy14Rclr2oNHxupGkV2W2aGend2ZkvL4r9GTFd6prp/E+ggPb+iLE0qM
	4P1G8oLVr6pTAn1WnNtIBAC/FGcD2Y8=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf17.hostedemail.com: domain of 3rFKLaQkbANEFLM7x881ExCC50.3BB381HF1EzBAG1AG.zB9@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.160.71 as permitted sender) smtp.mailfrom=3rFKLaQkbANEFLM7x881ExCC50.3BB381HF1EzBAG1AG.zB9@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770738349; a=rsa-sha256;
	cv=none;
	b=3jsibM6BcMMgU8sR0tt14BfkQZkyz7wnVkfNcSBzmZ7J1CfPOySScN+Cm5YGpE+ZxD3qmh
	FI9KC2iarR80bcIdCEtiIviq2deUMiLSzZDw8oxOU+02VkkODR7MGgJ1lyi+GHbmNoE5/z
	MQOxMKfEbLtQsOdti2FshieRQyHttE0=
Received: by mail-oa1-f71.google.com with SMTP id 586e51a60fabf-4097bb790e5so28855243fac.1
        for <linux-mm@kvack.org>; Tue, 10 Feb 2026 07:45:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770738348; x=1771343148;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=umYiyPeqfv4hz6b8WdCAw8Mf6WoinfgY1PV/QiXW0KY=;
        b=AE2Kckw3FXTdHjwJKt38KV/9sI5IX6kTOfuQGGiKDK/yOU42QobntP0jM6BXjZon+e
         wH+INv+H460TxQjOFZ7mIR17fy+25knuKOQVcYnGrAX+67eOYxxUtKGwFttW7qQb2ieW
         sF4XsImiwdjBVsMvgc0BdZueUZxPczkMXKv9cRFRNtnzDFNG1o8dQErrMlHQnCZ8em+C
         uUXEYwsNjcu3clI9Up/Sn+fGQ26ElvERMcQ52u2WTM/Fs4sE4zEDL+GAfDam7X/y+z81
         comy0tVJLu+nibA3IwLg1Vv6HAv98dAv855ypTy3YnejO0H5C/33we5ZNDVF7ZdIMBWr
         pqMg==
X-Forwarded-Encrypted: i=1; AJvYcCXSQhWJ9T0UXLXv0t/m9jYlG95U1z/o8g6VP0KnW7KNEhM8A8/VioMRDcd9hwXVayi9J2G5xan/Rg==@kvack.org
X-Gm-Message-State: AOJu0YyhSwk2YJwt9jWuMo0otT70M6Cr0OGlIDTyXM9F9rScLHlePrWC
	DMYjoxdVKmFw5OrXtwNSpXJJ+2wM0Wby561AmEikC/9LT1UkG6rwwDLJl8jhPkZjkOGxTJz7ZXw
	EmuqQaaaP5ivYoqQTUYDTf9DoSJTEa5ZjBIaFkakk2qDK6lBpEbE5WLIPxv0=
MIME-Version: 1.0
X-Received: by 2002:a05:6820:818b:b0:66d:ecba:b3f4 with SMTP id
 006d021491bc7-672e62cc5a8mr1455324eaf.31.1770738348353; Tue, 10 Feb 2026
 07:45:48 -0800 (PST)
Date: Tue, 10 Feb 2026 07:45:48 -0800
In-Reply-To: <20260208215839.87595-1-nphamcs@gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <698b52ac.a70a0220.2c38d7.0076.GAE@google.com>
Subject: [syzbot ci] Re: Virtual Swap Space
From: syzbot ci <syzbot+ci0e6a00c2d76396f3@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, axelrasmussen@google.com, baohua@kernel.org, 
	bhe@redhat.com, cgroups@vger.kernel.org, chengming.zhou@linux.dev, 
	chrisl@kernel.org, christophe.leroy@csgroup.eu, gourry@gourry.net, 
	hannes@cmpxchg.org, huang.ying.caritas@gmail.com, hughd@google.com, 
	jannh@google.com, joshua.hahnjy@gmail.com, kasong@tencent.com, 
	kernel-team@meta.com, len.brown@intel.com, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, linux-pm@vger.kernel.org, lorenzo.stoakes@oracle.com, 
	mhocko@kernel.org, muchun.song@linux.dev, npache@redhat.com, 
	nphamcs@gmail.com, osalvador@suse.de, pavel@kernel.org, peterx@redhat.com, 
	pfalcato@suse.de, rafael@kernel.org, riel@surriel.com, 
	roman.gushchin@linux.dev, ryan.roberts@arm.com, shakeel.butt@linux.dev, 
	shikemeng@huaweicloud.com, viro@zeniv.linux.org.uk, weixugc@google.com, 
	yosry.ahmed@linux.dev, yuanchu@google.com, zhengqi.arch@bytedance.com
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: 67iwecw5y4ht77j78km68mo9osoh1b67
X-Rspamd-Queue-Id: 563004000B
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1770738349-634278
X-HE-Meta: U2FsdGVkX1+Z5kfjIk+fuRIpfXiOwiO5xsiiY58Ic0wtHsil0QtxktULelDkDT719VfgwTlvulR60nhbrUk0dXes6OnRlK1xZII4077DLPzni1/1Rw9D6RUTKnM1L4nBjeWX2fu4FDKXZmiQy0JBS3IrBhLOZVVd9LudNbdbsKA1bKG5wAWyNvlDEwR7oJi7lo1QiIrje8iX+oLycR7uCC6i8o9OxLz7DXk0w8DOwa+opC9RJTlCx69o00lbDkktpltoLwfJpWZl2dfk0ZN/SQhDE/eyKtWFfs5bO+cmEHYulxmURDld/oKM2/WwmCZrvsUBE8yA6OjC6gTT7anGbcZLRcYH2Ml1dGQzwqxDvPg0xS4pt8ZtnzjTcCOIBMWhP14DL7dVfx6UGhP3pAHHkCH9EKoWd0HFbw8oOWq3751X7QblTj/YDm9yVtNBF+T6Tenxy5+LDnJCtfMhBCfoiUhxbXb8uc1CE+DI0KBhAOJhYtw3pN3SXhPx6yuCxM4dTpXfKqLTCI9UF7D8LMLXKMrYWY9KemkdjaXk7T75E6psJZDMH8JLFfYttCheFK/ASN+bx1zKGIpsezqAnremh7Qfm5vQT/ax4uhHWnIE9exzNk9YFJJgjSyWGrtMNIlD8ueCdHIewzRxL3P+tdSt0ytf2/rqEZNQS/qLe3utNyVPHz1cyo/Rpx/8fIK9fv122sOXSkGQLazvRt3W4/BJbyjribL7+zPln+CvrsKR5f9rI6YoQuYKV+JWnMmJLB+bTH5RlP3ykJc9ke2AtQ7coZI4TuTwQQcFwXoKmIupIbhLhyM7hBmr+zBooGTtxa+EJXIVO7hfQTSz7Tx4uplVD3GtU2ubAwvr9h9CJVl8h16rhMSmPbU5LIMEYz9PFUOAD6NPb5jGR9KHA+OWxqi68kbLOpk+lk4zAgv6zcrHAGzyh+w0zquZ5a6rqA4xrGPreYzam/c2cJ/NR2b03dQ
 iZXfiFBo
 FZV1ZahlVdQHZeeo5bpUz7Bq74wIbnx1fTzzjhxKfQW2g54y//5MJBpweG1zt5ycz0Og+nbOpPrEBoQtxPo2H6LUHWgDQVxQ7sTZ3ZcHEDaPRwL5+OqXlnl1zuiARoeRMw3k0CcINmG26/XDPrgJAvrEzH2D6BF9QN5FIhmokgv6/IcOlrBV31tWhmoN8m7nOdtYMMJPOkIAQkXzXHkCPaiyWYpQzgDcQTAJVPOJR5dDSWnCTLBPR9Q3JMv359iO8ziaXahM62poi7o27cPDsKV415Wza7GqX6DBfOecA8VvcZd3HzsX6b0GXr5etcustomBgRvPsJOzHBo8yuRiofR4UijaBych0g/WrD8fGELwj8wmWDS6PW67u1P4wCxWcFEw07+N/ZFWyJ2jMICrRy+jdge1RAJoL431ApD6A6OoCJ1gCrQyToTU9nTnaRk7GtlPUglSeEL97RaRhLIw4P/Eh2ZsQGytbo3h5FdUBtYI3BE3nt2N9j/SP/1PxFePsGpRxUfd5mBFP2CM8gNE7mLalkbdfb06QHEd71j2nS0xaApXX1KREISd6+ehegMWBclV340uBD3lH8OyJlcTH8dBXmmzxYfSmmc4pKnW34nHyT4KGwt1odGwzsbWLkU2dOhd8RFfGlOQVaquqhAyo305tnJiqoMuYMo0BsbGuVzyBQJ2qhFN2Hy7ldL1F4KovR8vpbnzV3dFJHKMnqNiyZp+a7QXnTIoJw7H5wTEpyjy4Pdi0DyMPRBgy5BGuZMfTAB9lgZuJKyoDX3R+1VyKxvCVZ6rfw1IPNLc9DhLSSglxDF1u+ty3tQOnKrKMkOvF+iu/YgoNLVWmmgN5ST130ycPKnoZyKWzCbUCVRE/JJ66dzS1h33kWKeb+NMeFwxx/WEZTHL4ttzKcdRMhK0D3sW8VUh6AqngG8cmvf5Evl8QwnqjnZC/uiAopps72Gc7lRbXiTKxiDpJDqsEBzZpvG2e4FQR
 P43J7U5D
 1Hal7DS6t64JrScGuaf6DUy8wJ9Ew3iTRp04riu0yAEmeTcvWFVCQv+zJAVZ2iQd6s0/a3p+su3xW9rdl3lrNJtE0sUbvajOoLYQ/i3xnJU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

syzbot ci has tested the following series

[v3] Virtual Swap Space
https://lore.kernel.org/all/20260208215839.87595-1-nphamcs@gmail.com
* [PATCH v3 01/20] mm/swap: decouple swap cache from physical swap infrastructure
* [PATCH v3 02/20] swap: rearrange the swap header file
* [PATCH v3 03/20] mm: swap: add an abstract API for locking out swapoff
* [PATCH v3 04/20] zswap: add new helpers for zswap entry operations
* [PATCH v3 05/20] mm/swap: add a new function to check if a swap entry is in swap cached.
* [PATCH v3 06/20] mm: swap: add a separate type for physical swap slots
* [PATCH v3 07/20] mm: create scaffolds for the new virtual swap implementation
* [PATCH v3 08/20] zswap: prepare zswap for swap virtualization
* [PATCH v3 09/20] mm: swap: allocate a virtual swap slot for each swapped out page
* [PATCH v3 10/20] swap: move swap cache to virtual swap descriptor
* [PATCH v3 11/20] zswap: move zswap entry management to the virtual swap descriptor
* [PATCH v3 12/20] swap: implement the swap_cgroup API using virtual swap
* [PATCH v3 13/20] swap: manage swap entry lifecycle at the virtual swap layer
* [PATCH v3 14/20] mm: swap: decouple virtual swap slot from backing store
* [PATCH v3 15/20] zswap: do not start zswap shrinker if there is no physical swap slots
* [PATCH v3 16/20] swap: do not unnecesarily pin readahead swap entries
* [PATCH v3 17/20] swapfile: remove zeromap bitmap
* [PATCH v3 18/20] memcg: swap: only charge physical swap slots
* [PATCH v3 19/20] swap: simplify swapoff using virtual swap
* [PATCH v3 20/20] swapfile: replace the swap map with bitmaps

and found the following issue:
possible deadlock in vswap_iter

Full report is available here:
https://ci.syzbot.org/series/b9defda6-daec-4c41-bbf9-7d3b7fabd7cb

***

possible deadlock in vswap_iter

tree:      bpf
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/bpf/bpf.git
base:      05f7e89ab9731565d8a62e3b5d1ec206485eeb0b
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/f444cfbe-4ce0-4917-94aa-3a8bd96ee376/config
C repro:   https://ci.syzbot.org/findings/7b8c50b1-47d6-42e0-bcfc-814e7b3bb596/c_repro
syz repro: https://ci.syzbot.org/findings/7b8c50b1-47d6-42e0-bcfc-814e7b3bb596/syz_repro

loop0: detected capacity change from 0 to 764
============================================
WARNING: possible recursive locking detected
syzkaller #0 Not tainted
--------------------------------------------
syz-executor625/5806 is trying to acquire lock:
ffff88811884c018 (&cluster->lock){+.+.}-{3:3}, at: spin_lock include/linux/spinlock.h:351 [inline]
ffff88811884c018 (&cluster->lock){+.+.}-{3:3}, at: vswap_iter+0xfa/0x1b0 mm/vswap.c:274

but task is already holding lock:
ffff88811884c018 (&cluster->lock){+.+.}-{3:3}, at: spin_lock_irq include/linux/spinlock.h:376 [inline]
ffff88811884c018 (&cluster->lock){+.+.}-{3:3}, at: swap_cache_lock_irq+0xe2/0x190 mm/vswap.c:1586

other info that might help us debug this:
 Possible unsafe locking scenario:

       CPU0
       ----
  lock(&cluster->lock);
  lock(&cluster->lock);

 *** DEADLOCK ***

 May be due to missing lock nesting notation

3 locks held by syz-executor625/5806:
 #0: ffff888174bc2800 (&mm->mmap_lock){++++}-{4:4}, at: mmap_read_lock include/linux/mmap_lock.h:391 [inline]
 #0: ffff888174bc2800 (&mm->mmap_lock){++++}-{4:4}, at: madvise_lock+0x152/0x2e0 mm/madvise.c:1789
 #1: ffff88811884c018 (&cluster->lock){+.+.}-{3:3}, at: spin_lock_irq include/linux/spinlock.h:376 [inline]
 #1: ffff88811884c018 (&cluster->lock){+.+.}-{3:3}, at: swap_cache_lock_irq+0xe2/0x190 mm/vswap.c:1586
 #2: ffffffff8e55a360 (rcu_read_lock){....}-{1:3}, at: rcu_lock_acquire include/linux/rcupdate.h:331 [inline]
 #2: ffffffff8e55a360 (rcu_read_lock){....}-{1:3}, at: rcu_read_lock include/linux/rcupdate.h:867 [inline]
 #2: ffffffff8e55a360 (rcu_read_lock){....}-{1:3}, at: vswap_cgroup_record+0x40/0x290 mm/vswap.c:1925

stack backtrace:


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

