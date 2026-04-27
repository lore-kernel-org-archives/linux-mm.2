Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E13B8FF8861
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 07:00:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E81186B0005; Mon, 27 Apr 2026 03:00:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E31AE6B0088; Mon, 27 Apr 2026 03:00:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D207E6B008A; Mon, 27 Apr 2026 03:00:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BB6396B0005
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 03:00:03 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 45541140773
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 07:00:03 +0000 (UTC)
X-FDA: 84703436286.17.7D7BB46
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	by imf17.hostedemail.com (Postfix) with ESMTP id 4E5E640007
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 07:00:01 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b="Iw/YiwzL";
	spf=pass (imf17.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777273201;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0Dw+M2mszSXxj+MpurURnwpTg8WWXMhVrolz0Oz4Nhg=;
	b=2pRnIVg2xgscSfc0Y3kEUNXZwlbg5BlN1n0uXnzbVEsEF0RP9hnz0qjFytxOzyiBJkwwxA
	DXQe8mEN/4tYhDr1q74LnaNSU46VVbUCrmql4Y8h2WND5+b8VNNo+u0HaBlYdzjj3AmMUk
	S/zahMfMtGWswPKdFeN/v0sUsvjg1fg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777273201; a=rsa-sha256;
	cv=none;
	b=kKGj9m8l2VIyG/4tbv6qAeWR+RNuwiGWShhwICJTwmYYSgJd/59AqOeJvJ6IBvzj6nFEAr
	xdKyBgRYy9P/dHAyeBRKqrNDShhubF/b7sMkY+kfp+ED49kh7u1c/gsoCZdJ5kUq1ukpaX
	w0LmdncpySCkr2IlKsOOa+08RJ+bBGc=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b="Iw/YiwzL";
	spf=pass (imf17.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-488b0e1b870so165649235e9.2
        for <linux-mm@kvack.org>; Mon, 27 Apr 2026 00:00:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1777273200; x=1777878000; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=0Dw+M2mszSXxj+MpurURnwpTg8WWXMhVrolz0Oz4Nhg=;
        b=Iw/YiwzLB9KIlm51nZFuSb4TMPWBWbwhhmSkwdH2bfR8Mj6Of3rQ95/8aacg4LqUuK
         Y/eFa+o4IH7nb2L3oWRSnPOvdyBeUgaFgBZhYqwLNwczRO1XSFiEj46pK2mebNMg+mhx
         fejvGWbABC/WQcUVvWZZp8lzJCmdpxvi6KrjQP3Kamv2J0A8G7M3YqWIv7n9TnVKbCFF
         tTus2CCEEO50uqCBpT94E59CEtQ57I7nEMUhtZSp2qhK6izhxcXvD+44vHP9+FDB8Oxq
         ZRArvk1Wo02IYseXDOFChyqzJW6jxGzxxAGUYBSdGSbi1sBhCove+sEi3x152fGL90qL
         72Iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777273200; x=1777878000;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0Dw+M2mszSXxj+MpurURnwpTg8WWXMhVrolz0Oz4Nhg=;
        b=s52FgiBwd0nGyfYjiJwvbTT5SNkUqe5YZ1s4zIAlmV0WQRMnQPQBe088dSX0+hjYh9
         V6U6Oo14JtJ143YWk+yGjNQPZrmw7TpRdV3rwnuMENKlZjRzLR46KNULsu1wNS2B+aX8
         gumLjAg8sKFK6HGQwX5Vax4tNMsk+t7B6wmWDSYT03noTXejfaZOClUvwsQfj6+GplAg
         akXuS1M9Du3swmNAiJup47MrQ9Xy42SXGMghnb7yR6Q9wu/wIwRBfxRTofp+38aQiDV3
         TatlZ5c/rrgN4u2y0+ZGlr3xka0+GpVVhkTEu9JVY7trazBZe2MMRTSTpHlNnbh4+OSB
         O0SA==
X-Forwarded-Encrypted: i=1; AFNElJ/g//JxZc2glsPARXmGYKqV8rydiJM/r8apEmGI313b3x4IplBLoEzPjeawEnJyR3z1/7FrhPJErg==@kvack.org
X-Gm-Message-State: AOJu0Yx08yQaKTlmv/iWSg+GkoKZphYCeFtDc09hvtXk8/9DJkm8LPVJ
	EOAwOTyjEwx3s+1Tn90tBdCeqyvfLP15ctlG6pWRMIwCxzKv04ddfT9kiweuZ6cfJ34=
X-Gm-Gg: AeBDiet4OAINZgK+1XC2m+KAAWf4y7OGY89qvCdMDvJbab+XxWU/6yPh/fbsWYOIefa
	YwwInEU1EZtRrYFr/Yex6KhhVzY2nZFuKtWir8odzu9ewtmYdiRpmdW2KdbBZLshvWFMh/9uhoC
	4dZxPzUmJfWx/5aHZqZuJOwBdbTz360RmSWgETJxe4fHElb22unN45d5QmqSj0F5gFFOMtl0mXY
	Q+szSB+pJVXP8UGQYWYGJuya+lbyWl1PNfFEa1zTBJIwtqrAA/ok4Nlq4sNo9sw7oEioOOc2qRP
	OKjA8vPiYxiCskQD3XPToDiSWtmyY/8tfuQxxCb24S5Rj2+/z2QCqb2ixof6im3EqspT25//QAa
	WxU3mN2POUrjOqRr6EMhCD/BnbaLO0jeO7T+PeflJjrkZiZ9NjpNE3jRkx4BX3h12key6XPTAFV
	32OtA438i2u4jwIRISY5hFR3TemctFJbdom4d3kgcxyLUJZYE=
X-Received: by 2002:a05:600c:3110:b0:487:2439:b7be with SMTP id 5b1f17b1804b1-488fb7389dfmr621238695e9.6.1777273199419;
        Sun, 26 Apr 2026 23:59:59 -0700 (PDT)
Received: from localhost (109-81-17-171.rct.o2.cz. [109.81.17.171])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-488fb755938sm329185955e9.3.2026.04.26.23.59.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Apr 2026 23:59:58 -0700 (PDT)
Date: Mon, 27 Apr 2026 08:59:57 +0200
From: Michal Hocko <mhocko@suse.com>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: syzbot <syzbot+5af806780f38a5fe691f@syzkaller.appspotmail.com>,
	akpm@linux-foundation.org, axelrasmussen@google.com,
	david@kernel.org, hannes@cmpxchg.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, ljs@kernel.org, syzkaller-bugs@googlegroups.com,
	weixugc@google.com, yuanchu@google.com, zhengqi.arch@bytedance.com,
	brauner@kernel.org, djwong@kernel.org, jack@suse.cz
Subject: Re: [syzbot] [mm?] possible deadlock in rhashtable_free_and_destroy
Message-ID: <ae8JbUBiV0XLLbmR@tiehlicka>
References: <69e798fe.050a0220.24bfd3.0032.GAE@google.com>
 <aefpEFTg-4KitXxF@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aefpEFTg-4KitXxF@linux.dev>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 4E5E640007
X-Stat-Signature: 4mcwyypkm34ou5yhyush6wbe3gjnoi6u
X-Rspam-User: 
X-HE-Tag: 1777273201-516863
X-HE-Meta: U2FsdGVkX19DZOBpPHcAG5kB/3s3+E5CCmoVDpgrNy9BAclOOkYA8wlTnVA5nqd1ikSoGDF/YKjkMiSM03KftCbvF043oS6aXbEECRgmNIvcuX3XmbR0DkND4TL62zU8IaWFZcqft6Jpr3OYI/udbEByUN9GfMvgBGckAmIOug4WAxvsij7bjPzX7mrOLqk5/st9WP2jPN8szlABOIbUJYDbkqG68mKg8VS6VAsNqafUmTNapPxuS7RvRNTeryI17l5n92WLPt2HKf5mbAA5oqzBh9Mal4wXqFWUZnpTg9u6JFQhPZbEsqll9BLojXZZvHtYWXls5ns/gjD5mnYlzmGhk7xH1e/XmtiJPK5WJLFShVzdznAtPn1OP3s//fmJguNqIxoHia1VycaRvgJo7CvPePY7D0UWNrf16cLVHvMQqVLT4fUy26zq3rw/uwh3EzaXAhCD8BrMHLXbEQ4XFz1WBK/31O8zFn+cBVxb3Ro4ZiLSC2y166gzck/H+DuJjNFHNc2hEpv8M2wDipUahYYvVHUnsxG9NnxRTu7+LSjF1/VIyLn0fOLxKozm9ks9Y8fYr+DtQVfuuaNjQsbyktIxvw1YU5IYOnqIE+aWfWugi3VQyMSGtVVD1wRFtJU84JTat7RhaJiS8zIpphGNOQ1rmOTtaHlX0O7GT0JMrx0o6kmhpS/rBJK/iMExgxEgaQm0ldYTmhrIdz1eKPqwMrAexdo2vvaXHKwfk4I9y2hwM74QP71EQK19ykCooZYFD6+UsRr03YNN7hLIKupoi6l1hTn/dz3Rm7sEKuANF4v2Z+8CnfRq/vNlq+obWQ4gqKW8z54d8uJ7EvY9AEKPKw38w/ACcJwXWsnTBSnZZp5j78Wv8CmdZn+ccqzupKo0SO4DBqk5XzSlTP7hnkpg/s3cwUtwLcAHbUqql1WZGljTfpL4lilJfKjwvD+6CeLwOA5IV0TqI2lG+V30wWa
 ny0d0VBC
 J7vxi/0bRJgTXVzhA0Qkw5o8LaHtQZqdAOqyCQ7c+5Ud2+EWYa3gMrogYJVwmqpfe3B5xrjsch6nuwy8Und7A4PErWook7rGYYGfI6n/Ig3A8UA2ub0ofFRZugQhgzal1spTYusqnCXBsrVimSUxaiws97POZE0ImXcEfw84dx6QcbaumepOGRs7TlAEr4PdeeShczU63lXDwq5VZ9KIYSwEDcrOn2Jwg6AUlOamgU0C5qzKL83UEjmyazgdKu9MJ2+M57hN4xWfLhU6f5VRjm+pDoDlB6fMue9NOxBMjBB6y1C9jpg0Elwe0DORvRXVkE3Do1BV3FEwzWm91G0oEgf7ggUrrqB9X3Pt3hdRsq8LuRwvY99rqs4bykQZ4kyou6Sk3Y8m8XB5OH1utDF8jXaWEGPzr8+9kNpcwRXSBInPgcln8AFtHrvkB4AWtEkguTK6QEPFgxqakR0gtnWY4vFuU5E0hcPEXOdkscrV1RoZxQSMswZyFKRZR2xe3G/Uddac2EYo0ZEZknCxmdjqw3a8MMIRzXd3B7vavaibGjjbrQGlCQ9fQ8OAXwVbB8aK3k2dUtda4za2xwgu9g9NjG5mr8oNYa2m0Khd/9CQeO9MO8qJXYHyEb6vWTZwaHWwWX5ZaglBewppqbYGiHdb3HLDo66/QYVNWkXRNfk6mNVHyP58zli80eHFFvxXS9IkTczXCOSRolcrzQlsrOHw4+Wd2bCB32Os/eAWkSIc1BZYSeZDmdGfJ1c7SrT+YzCxqz73Da4Ch/+eQJmiMuOQiPe0kKyENKlOQSsjq43cyDEUW2+bsexFLQPhfvKaAHexr+yDA+f9/q5aS8HISuvbkdVGab2ofUQgACFvDfJona5uMckpGHHjVRixfvvLf7issibOjxzQa370HuU79R7Fg6EvEpM21lmy9E5QUhmqVNlK5cS/aYam64849jl3TxvsVibDMEtGQfkReVibZ16g3lVopmGZc
 4P5DGCzZ
 tU8wY5TnGT4WEJLCWogwP1H9FV4N7u+hV2nshRJRTMc7KWQHX79v48RhmC2EcXHxEAHDAmOUNtt6ImAuSk36fQ+40Vm/uhLyG1aTGLEmGck4pZ6f69u/tfrwR7Djwal9jsSb6w4MG4mFqIRMSCYYcSvMStcvDHCNNnjGblgUV4wTQrQVLkaD/+qK9kk5QMLKlaCL6b2GzsPqrX2yE1ILGavFlTTnxKE31ovMbKpi5T8yx7ZwKqOCIYeUu8SgV0ZylyOP5JMlEyEIRCutranhGxkI2MC6apDSWyGp8lwdwVmjSVDto0jfE4CjsmRAN1lrVPLTzSNJjLroxe8LUmyA7A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Same issue as https://lkml.kernel.org/r/202604211323.fac1b29e-lkp@intel.com

On Tue 21-04-26 14:27:35, Shakeel Butt wrote:
> Ccing relevant folks as this seems related to recent change of moving
> simple_xattrs from rbtree to rhastable.
> 
> On Tue, Apr 21, 2026 at 08:34:22AM -0700, syzbot wrote:
> > Hello,
> > 
> > syzbot found the following issue on:
> > 
> > HEAD commit:    8541d8f725c6 Merge tag 'mtd/for-7.1' of git://git.kernel.o..
> > git tree:       upstream
> > console output: https://syzkaller.appspot.com/x/log.txt?x=15380836580000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=7e54da1916e8d11f
> > dashboard link: https://syzkaller.appspot.com/bug?extid=5af806780f38a5fe691f
> > compiler:       gcc (Debian 14.2.0-19) 14.2.0, GNU ld (GNU Binutils for Debian) 2.44
> > 
> > Unfortunately, I don't have any reproducer for this issue yet.
> > 
> > Downloadable assets:
> > disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-8541d8f7.raw.xz
> > vmlinux: https://storage.googleapis.com/syzbot-assets/22dfea2c37c2/vmlinux-8541d8f7.xz
> > kernel image: https://storage.googleapis.com/syzbot-assets/e2f93ad68fe3/bzImage-8541d8f7.xz
> > 
> > IMPORTANT: if you fix the issue, please add the following tag to the commit:
> > Reported-by: syzbot+5af806780f38a5fe691f@syzkaller.appspotmail.com
> > 
> > ======================================================
> > WARNING: possible circular locking dependency detected
> > syzkaller #0 Tainted: G             L     
> > ------------------------------------------------------
> > kswapd0/108 is trying to acquire lock:
> > ffff888056f3c4e8 (&ht->mutex){+.+.}-{4:4}, at: rhashtable_free_and_destroy+0x3d/0x9b0 lib/rhashtable.c:1154
> > 
> > but task is already holding lock:
> > ffffffff8e9b0800 (fs_reclaim){+.+.}-{0:0}, at: balance_pgdat+0xb5d/0x1ac0 mm/vmscan.c:7102
> > 
> > which lock already depends on the new lock.
> > 
> > 
> > the existing dependency chain (in reverse order) is:
> > 
> > -> #1 (fs_reclaim){+.+.}-{0:0}:
> >        __fs_reclaim_acquire mm/page_alloc.c:4327 [inline]
> >        fs_reclaim_acquire+0xc4/0x100 mm/page_alloc.c:4341
> >        might_alloc include/linux/sched/mm.h:317 [inline]
> >        slab_pre_alloc_hook mm/slub.c:4520 [inline]
> >        slab_alloc_node mm/slub.c:4875 [inline]
> >        __do_kmalloc_node mm/slub.c:5294 [inline]
> >        __kvmalloc_node_noprof+0xcc/0xa00 mm/slub.c:6828
> >        bucket_table_alloc.isra.0+0x88/0x460 lib/rhashtable.c:186
> >        rhashtable_rehash_alloc+0x68/0x110 lib/rhashtable.c:368
> >        rht_deferred_worker+0x1d9/0x1fd0 lib/rhashtable.c:429
> >        process_one_work+0xa0e/0x1980 kernel/workqueue.c:3302
> >        process_scheduled_works kernel/workqueue.c:3385 [inline]
> >        worker_thread+0x5ef/0xe50 kernel/workqueue.c:3466
> >        kthread+0x370/0x450 kernel/kthread.c:436
> >        ret_from_fork+0x72b/0xd50 arch/x86/kernel/process.c:158
> >        ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
> > 
> > -> #0 (&ht->mutex){+.+.}-{4:4}:
> >        check_prev_add kernel/locking/lockdep.c:3165 [inline]
> >        check_prevs_add kernel/locking/lockdep.c:3284 [inline]
> >        validate_chain kernel/locking/lockdep.c:3908 [inline]
> >        __lock_acquire+0x14b8/0x2630 kernel/locking/lockdep.c:5237
> >        lock_acquire kernel/locking/lockdep.c:5868 [inline]
> >        lock_acquire+0x1b1/0x370 kernel/locking/lockdep.c:5825
> >        __mutex_lock_common kernel/locking/mutex.c:632 [inline]
> >        __mutex_lock+0x1a4/0x1b10 kernel/locking/mutex.c:806
> 
> The cancel_work_sync(&ht->run_work) in rhashtable_free_and_destroy() should
> avoid concurrent mutex lockers from rht_deferred_worker(). Seems like false
> positive as all rhastables share single static lockdep class for the ht->mutex.
> 
> Simple fix would be to move rhashtable_rehash_alloc() to use NOFS allocation or
> we can introduce more fine grained lockdep classes for rhashtables. 
> 
> >        rhashtable_free_and_destroy+0x3d/0x9b0 lib/rhashtable.c:1154
> >        shmem_evict_inode+0x1ae/0xc40 mm/shmem.c:1429
> >        evict+0x3c2/0xad0 fs/inode.c:841
> >        iput_final fs/inode.c:1960 [inline]
> >        iput.part.0+0x605/0xf50 fs/inode.c:2009
> >        iput+0x35/0x40 fs/inode.c:1975
> >        dentry_unlink_inode+0x2a1/0x490 fs/dcache.c:467
> >        __dentry_kill+0x1d0/0x600 fs/dcache.c:670
> >        finish_dput+0x76/0x480 fs/dcache.c:879
> >        dput.part.0+0x456/0x570 fs/dcache.c:928
> >        dput+0x1f/0x30 fs/dcache.c:920
> >        ovl_destroy_inode+0x3e/0x190 fs/overlayfs/super.c:217
> >        destroy_inode+0xcb/0x1c0 fs/inode.c:394
> >        evict+0x599/0xad0 fs/inode.c:865
> >        iput_final fs/inode.c:1960 [inline]
> >        iput.part.0+0x605/0xf50 fs/inode.c:2009
> >        iput+0x35/0x40 fs/inode.c:1975
> >        dentry_unlink_inode+0x2a1/0x490 fs/dcache.c:467
> >        __dentry_kill+0x1d0/0x600 fs/dcache.c:670
> >        shrink_kill fs/dcache.c:1147 [inline]
> >        shrink_dentry_list+0x180/0x5e0 fs/dcache.c:1174
> >        prune_dcache_sb+0xea/0x150 fs/dcache.c:1256
> >        super_cache_scan+0x328/0x550 fs/super.c:223
> >        do_shrink_slab+0x416/0x1240 mm/shrinker.c:440
> >        shrink_slab_memcg mm/shrinker.c:557 [inline]
> >        shrink_slab+0xa7d/0x12e0 mm/shrinker.c:635
> >        shrink_one+0x398/0x7f0 mm/vmscan.c:4932
> >        shrink_many mm/vmscan.c:4993 [inline]
> >        lru_gen_shrink_node mm/vmscan.c:5071 [inline]
> >        shrink_node+0x2673/0x3dc0 mm/vmscan.c:6059
> >        kswapd_shrink_node mm/vmscan.c:6913 [inline]
> >        balance_pgdat+0xaaf/0x1ac0 mm/vmscan.c:7089
> >        kswapd+0x557/0xb60 mm/vmscan.c:7362
> >        kthread+0x370/0x450 kernel/kthread.c:436
> >        ret_from_fork+0x72b/0xd50 arch/x86/kernel/process.c:158
> >        ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
> > 
> > other info that might help us debug this:
> > 
> >  Possible unsafe locking scenario:
> > 
> >        CPU0                    CPU1
> >        ----                    ----
> >   lock(fs_reclaim);
> >                                lock(&ht->mutex);
> >                                lock(fs_reclaim);
> >   lock(&ht->mutex);
> > 
> >  *** DEADLOCK ***
> > 
> > 2 locks held by kswapd0/108:
> >  #0: ffffffff8e9b0800 (fs_reclaim){+.+.}-{0:0}, at: balance_pgdat+0xb5d/0x1ac0 mm/vmscan.c:7102
> >  #1: ffff88801347c0d8 (&type->s_umount_key#76){++++}-{4:4}, at: super_trylock_shared fs/super.c:565 [inline]
> >  #1: ffff88801347c0d8 (&type->s_umount_key#76){++++}-{4:4}, at: super_cache_scan+0x98/0x550 fs/super.c:198
> > 
> > stack backtrace:
> > CPU: 2 UID: 0 PID: 108 Comm: kswapd0 Tainted: G             L      syzkaller #0 PREEMPT(full) 
> > Tainted: [L]=SOFTLOCKUP
> > Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
> > Call Trace:
> >  <TASK>
> >  __dump_stack lib/dump_stack.c:94 [inline]
> >  dump_stack_lvl+0x100/0x190 lib/dump_stack.c:120
> >  print_circular_bug.cold+0x178/0x1c7 kernel/locking/lockdep.c:2043
> >  check_noncircular+0x146/0x160 kernel/locking/lockdep.c:2175
> >  check_prev_add kernel/locking/lockdep.c:3165 [inline]
> >  check_prevs_add kernel/locking/lockdep.c:3284 [inline]
> >  validate_chain kernel/locking/lockdep.c:3908 [inline]
> >  __lock_acquire+0x14b8/0x2630 kernel/locking/lockdep.c:5237
> >  lock_acquire kernel/locking/lockdep.c:5868 [inline]
> >  lock_acquire+0x1b1/0x370 kernel/locking/lockdep.c:5825
> >  __mutex_lock_common kernel/locking/mutex.c:632 [inline]
> >  __mutex_lock+0x1a4/0x1b10 kernel/locking/mutex.c:806
> >  rhashtable_free_and_destroy+0x3d/0x9b0 lib/rhashtable.c:1154
> >  shmem_evict_inode+0x1ae/0xc40 mm/shmem.c:1429
> >  evict+0x3c2/0xad0 fs/inode.c:841
> >  iput_final fs/inode.c:1960 [inline]
> >  iput.part.0+0x605/0xf50 fs/inode.c:2009
> >  iput+0x35/0x40 fs/inode.c:1975
> >  dentry_unlink_inode+0x2a1/0x490 fs/dcache.c:467
> >  __dentry_kill+0x1d0/0x600 fs/dcache.c:670
> >  finish_dput+0x76/0x480 fs/dcache.c:879
> >  dput.part.0+0x456/0x570 fs/dcache.c:928
> >  dput+0x1f/0x30 fs/dcache.c:920
> >  ovl_destroy_inode+0x3e/0x190 fs/overlayfs/super.c:217
> >  destroy_inode+0xcb/0x1c0 fs/inode.c:394
> >  evict+0x599/0xad0 fs/inode.c:865
> >  iput_final fs/inode.c:1960 [inline]
> >  iput.part.0+0x605/0xf50 fs/inode.c:2009
> >  iput+0x35/0x40 fs/inode.c:1975
> >  dentry_unlink_inode+0x2a1/0x490 fs/dcache.c:467
> >  __dentry_kill+0x1d0/0x600 fs/dcache.c:670
> >  shrink_kill fs/dcache.c:1147 [inline]
> >  shrink_dentry_list+0x180/0x5e0 fs/dcache.c:1174
> >  prune_dcache_sb+0xea/0x150 fs/dcache.c:1256
> >  super_cache_scan+0x328/0x550 fs/super.c:223
> >  do_shrink_slab+0x416/0x1240 mm/shrinker.c:440
> >  shrink_slab_memcg mm/shrinker.c:557 [inline]
> >  shrink_slab+0xa7d/0x12e0 mm/shrinker.c:635
> >  shrink_one+0x398/0x7f0 mm/vmscan.c:4932
> >  shrink_many mm/vmscan.c:4993 [inline]
> >  lru_gen_shrink_node mm/vmscan.c:5071 [inline]
> >  shrink_node+0x2673/0x3dc0 mm/vmscan.c:6059
> >  kswapd_shrink_node mm/vmscan.c:6913 [inline]
> >  balance_pgdat+0xaaf/0x1ac0 mm/vmscan.c:7089
> >  kswapd+0x557/0xb60 mm/vmscan.c:7362
> >  kthread+0x370/0x450 kernel/kthread.c:436
> >  ret_from_fork+0x72b/0xd50 arch/x86/kernel/process.c:158
> >  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
> >  </TASK>
> > 
> > 
> > ---
> > This report is generated by a bot. It may contain errors.
> > See https://goo.gl/tpsmEJ for more information about syzbot.
> > syzbot engineers can be reached at syzkaller@googlegroups.com.
> > 
> > syzbot will keep track of this issue. See:
> > https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> > 
> > If the report is already addressed, let syzbot know by replying with:
> > #syz fix: exact-commit-title
> > 
> > If you want to overwrite report's subsystems, reply with:
> > #syz set subsystems: new-subsystem
> > (See the list of subsystem names on the web dashboard)
> > 
> > If the report is a duplicate of another one, reply with:
> > #syz dup: exact-subject-of-another-report
> > 
> > If you want to undo deduplication, reply with:
> > #syz undup

-- 
Michal Hocko
SUSE Labs

