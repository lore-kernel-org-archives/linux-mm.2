Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 86092C61DD9
	for <linux-mm@archiver.kernel.org>; Sun, 30 Aug 2026 03:26:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3C9ED6B008C; Sat, 29 Aug 2026 23:26:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 379EA6B0095; Sat, 29 Aug 2026 23:26:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 295946B008C; Sat, 29 Aug 2026 23:26:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EEA516B008C
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 23:26:18 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 647971A0230
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 03:26:18 +0000 (UTC)
X-FDA: 85156497636.20.FFD36F4
Received: from mail-yw1-f182.google.com (mail-yw1-f182.google.com [209.85.128.182])
	by imf14.hostedemail.com (Postfix) with ESMTP id A0DEC100004
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 03:26:16 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=NESCIl83;
	spf=pass (imf14.hostedemail.com: domain of hughd@google.com designates 209.85.128.182 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788060376;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nWu2JtKNi0WS3R6GCsF0Zx1kqelEWLcREP8bu09AzsM=;
	b=LGDATt32fshX2TOATB5onTYeXitYa7BSRMFYlNQacf/hh64PGOxKR8DVZjpESv6Wd0FXf3
	aXE0OGcuXNGz0PKILt/LlQ4w48rQdILJ2iSC3YkpL0/kyDlKg5L/k8bT8wjHllgw9/fE1o
	OQjpvYQG6HJiYL7ohTuX+JUx1HeovLA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788060376;
	b=Afq2aqfiqZlQ/mFR7uvAv8RbIlysO3zirAU3adbnXGjkF+n64tjAKhhw11w9f9n8RMMuPA
	z2a2VjBxS3dGPKvOetlRr62niY7DJ2aArGLD45htS9ezuFZIUDEpicuzN8Yd52CbekYBCe
	/fRUl3YI+zBMTWvFR0IFdF0uXLYfYOo=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=NESCIl83;
	spf=pass (imf14.hostedemail.com: domain of hughd@google.com designates 209.85.128.182 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-yw1-f182.google.com with SMTP id 00721157ae682-855a66e5b5dso22612287b3.0
        for <linux-mm@kvack.org>; Sat, 29 Aug 2026 20:26:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788060376; x=1788665176; darn=kvack.org;
        h=content-type:mime-version:references:message-id:in-reply-to:subject
         :cc:to:from:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=nWu2JtKNi0WS3R6GCsF0Zx1kqelEWLcREP8bu09AzsM=;
        b=NESCIl83CCJG75pqVb6f9AtyVXO1zPGueQAyf7Yf7jO77s+ACHOh8/FtQ9hhZ+H3VY
         WAKAd7PtZLp/XggJZqxW7FHezAbznXwQDep6A+yyQJ1skbSEab9pwiYHTB58U/wuxHKn
         d50iWYVzylwTxN0vidUR+waVZfMnkcpv3noUqw8IWhIVn/yH1jG34XVzA4AYYDORBusd
         UZ76j9A3+j6MAjlbVF1hF6Wyef32y54RP3vDBG+XIEaX09VUokzxM4/kyyY0SkY+iZ7Q
         fuvHzQVbxDpbE7D9CpCEygyM6QDqjYnuMuwQwRZIN0cNWw6slZh2D+0I03+gEZdTGRej
         tVDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788060376; x=1788665176;
        h=content-type:mime-version:references:message-id:in-reply-to:subject
         :cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=nWu2JtKNi0WS3R6GCsF0Zx1kqelEWLcREP8bu09AzsM=;
        b=pPVrxuRcFUuI9Tg3eiH7dgm6bGaV6BWsCyd0+zdfodiJfROafGuIzx8BsbZ89gzGsS
         KUWm9sIJVqknre64DsJ3knQhb/wSHzobHlWJ2AWi7DHANUHAfNDar3KqNxm3BC+QfQdb
         6LD90PqfhYmk59bwPKZcv/Tf4yMs69fB+g8zkzNdL9QW3w7O8Dzs7qSlJoeGUopDTqXb
         kvnzajJ8qPC3ZmGDPqraLxHJu9NgWQBZM9UMLPlY7dOja2mtpgbgoz5MaudejxHN8YKd
         FS2hqI3t1bXReeEvEGE5nPzBQ6xdRPZRP6aaW3tZn3NJWrLUynQh2WJ2/9WxWX70UIGA
         wJJg==
X-Forwarded-Encrypted: i=1; AKwUvBydHnQ1cIuhZrNzaEQOqaMvGaIoBD1X65sJTa8nHgFZXgwULJSeQrUJMWRtLdhen61UhzawiIxfWg==@kvack.org
X-Gm-Message-State: AFuF++nteK/XHpHV4gd09BA7XOvkYIFgXU/jMDV7qzf1d5BQ+SohRbE6
	b4+cnIYLRgYqQ5vpZkAbraPqi/byK8OM49JbVl6AxPs5DHrEaI5gkuvQqUDyM1lm3w==
X-Gm-Gg: AYBFou2GgkhG3sudarxH5U05lzHxdhyhQLM+JqeB+y4x/m80XD4hxyJyZfkBHMHnTTr
	73xoN3mY8cWJcVEkG+G24CNwuupNK97R/+7ScWf9h/jOWk6eb/LxyxCq/ptef6lurfGE19fMpFU
	5amBPpWaEx+4qMDC7WSxiPdIkqxI/JZ4zAcJuoEfjArZCwzSqRgAIGz37R54o90tsIABHThHsbp
	EryuM/dfFIlJH6uRXN7wT3ApeSRcyniJyTftTRqf7bqBW1hilt0qwMp6VCbJgkGcvRgvoA0S0S4
	+wFX1XBV16oA9yfO4grK0+qjYOVXnOIuIUU6SOpESeax9nq7IRQ+2a3nEW9AW18aQduwR4oc/6n
	5pAb3yCpxI/W9WGn7Jri/CxnoH7eJOjVxsfDczKsn/oHnY6KXdk5GpytdWXOVmqjPxzfjcPe54F
	pxw1fP1LuqUNpZli8xxHjrvF8zUNgx+5oe4H2E3eoM64bEUVb5PWa+jWbItIXK3naE3r9/YDYo8
	EYf494KpTYFCCyPTV0wzbs+B842sVCAAGV14nX2zQ4u/Xo2
X-Received: by 2002:a05:690c:a749:b0:81f:3800:606 with SMTP id 00721157ae682-85d6cfc3b20mr58413507b3.16.1788060375097;
        Sat, 29 Aug 2026 20:26:15 -0700 (PDT)
Received: from darker.attlocal.net (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8646265eb15sm1501207b3.25.2026.08.29.20.26.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 29 Aug 2026 20:26:14 -0700 (PDT)
Date: Sat, 29 Aug 2026 20:26:02 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
To: Shakeel Butt <shakeel.butt@linux.dev>
cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
    syzbot <syzbot+cd2073ee6d958a8d0fcd@syzkaller.appspotmail.com>, 
    linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
    syzkaller-bugs@googlegroups.com, hughd@google.com
Subject: Re: [syzbot] [mm?] WARNING in __mod_zone_page_state
In-Reply-To: <apOAF5CPFWUUH9du@linux.dev>
Message-ID: <a2288e73-5001-2104-1e7a-2b383e7edd61@google.com>
References: <6a931c5a.08e933ee.dbf97.0093.GAE@google.com> <apNjw0HRyr1Oj7q4@linux.dev> <apOAF5CPFWUUH9du@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Stat-Signature: ay4sxrgqojc3ccfnu65z4tqc8sii1p88
X-Rspamd-Queue-Id: A0DEC100004
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1788060376-105989
X-HE-Meta: U2FsdGVkX180W+pNaXKNJrLuEmWpBo7rCNawxREvh8QQEWdIwtEJGa027qiJGcaar6A+YMUJ8CuNjFn9vwZO/pY9J0kKAI7MjHZ2JEiB8OeO6eJeha6tUdFMkxeoiRGHw4uqV6S2ISp+pKz/iLfjvBYWlETXZAK6Z2G81aCShLvlSLccXQmfUynxcP2aUVtqxJ7wxs+sZoJ3sdOwPWz8lCNdSEX0VK3Ru5gdum2iBEoTEx/As4fouHWKbiLNYQKqMpuXq7WUq4EJopn6CK298ExRG6Dkl2yOaZIIIOpYRc44j9LUW+VRVtzj8ClBCYa06HtePuvHrOiw7wyPy5Vu+pdJOieXCy1yImRNiEP5mR0sPaUZLbCNkzWofR4QgeBRwQbgCVtRVsHXD3EO5mrQ47rNL7FtJkNkD4GQGMCCb4aJaDFNapIdEDjMdXBRftqo1DUtU0x/rsjUGDbKzMsTOeaUagcsaPssQG/yFRCoQ6WWYtrACpuHoazAVeciRc05mIrgvoGriN6pQ7WkK87hc+7V4Deh7nyYT8AsXEzOhcnxDlk9omIyJLaHNk41m/ql7Jg/qYYI0PHHMOb/o2QeALBfOEiRXvGgUEH1mJKyJtX11p6rVKpl3ebjT5bZD5RmIcbYcUrq9HTFLb689gai+NouYKYH4eNXk/wyBjyiy+dqggtR6DKYHYZCxATwZfP9Lm2A3xAgljPon39zeSZBR3Kfob1W7rc/MnKiZA7tDXWHjyoWOSPfXjrbfM2X75AMD1mPVqPKZ4wROiOeOi49ZaCnryV9WQbm6w7WD+kj1NsmJ2JWU32giAEeAkvIPbjeyUyGTC2o74nS7YnTQZb+b1h5EvCEVDHK1FQNouy7i8pjVRBEzC/fQJ5O9tTPzXYPlQJtVDoc6GKcItl438o/tgIZmuWP2JXkqJX0PGB1KxvD5Aqg+hwItEDVxQtikDCIfNcp5u8SonUJ+p0FAem
 etcqkKfL
 AGf+EnVCRzo11N7mfT6EIfUPCyr2tZGzZnhY07JOrLftiBYeNIHmw9dCTKSFbOE7/rr4qiEq8fL0XER5ZpoKSvnkfHXEgxtV3jTg/WzWZt8bTkaNZ6az80hoAMc2uhDL2wFJO+aKkAgSzt/Bx9UsuuwPHZzvTiRhE4+MReepF+UuZCE6T8QcMHzFmWCAcJRPmdkmgqwL3+Jpj18T4kWwfqe8NDtqHqmK/sQs4jP9dHN0X+gfPc2bEC8JinAfUTMlboYT9pDx6u1I66FPEkypJY0d6Ek/voMS/3fJ4z6nvnap6a7kLBFHWaCwLS6HXQYUgFYWPPEsMXhgYzwmq+CTAwHGoQUWWbZ8vLz2sliATbbD+c9kWSbck738NUC31SPZNjR/QaL/iUTS6BNnnny+ZFp7P8C7aZzBqHg6+MNgZL8FpCYnP83bmpcNF2bZ2KWo8e5xc9AFt94QHOa4go3qFdg4BXt/xAWd+MIWfvQLphqMtFEucM8TJT9BEtCJ+EXal4t1QyHrz7/8BKzjQRk0NZBmD5n8teM3DlmsuCngTTGyR6V5JCNy0NCT7m7zmgXz9/XtXit/mn+1TLiYuUCmHqWISUsW4n+xeoy5KVEzDbWHyQMF5vLx02XIfDYl6ZZ9gEIQ/Tx0VSg/9vGJwvFvTro+LVTqmvCzhvrtPfHp0Jw4jpg9P/jaavGVwN7qnM0ih9dkN56ClFc6NVUvVslXs9vOF/CDuGkP57D9SThEeofuuWej2X93KfFOjjEmdbJaQbFGuWA2dEVYJLE/oRq5QpMAxiyhs+ha4T7g6Lmb7kBX/r9hbOeOgXCIB1csXfrg8Az/ecG22qOcW2Z1JDgW8lXhgmw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 29 Aug 2026, Shakeel Butt wrote:

> +hugh
> 
> On Sat, Aug 29, 2026 at 04:03:35PM -0700, Shakeel Butt wrote:
> > On Sat, Aug 29, 2026 at 10:52:26AM -0700, syzbot wrote:
> > > Hello,
> > > 
> > > syzbot found the following issue on:
> > > 
> > > HEAD commit:    818bebeb63dd drm/xe: Don't hand out the flat CCS storage a..
> > > git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
> > > console output: https://syzkaller.appspot.com/x/log.txt?x=10286d79580000
> > > kernel config:  https://syzkaller.appspot.com/x/.config?x=ccca94d2c01b9e78
> > > dashboard link: https://syzkaller.appspot.com/bug?extid=cd2073ee6d958a8d0fcd
> > > compiler:       gcc (Debian 14.2.0-19) 14.2.0, GNU ld (GNU Binutils for Debian) 2.44
> > > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=13cf7625580000
> > > 
> > > IMPORTANT: if you fix the issue, please add the following tag to the commit:
> > > Reported-by: syzbot+cd2073ee6d958a8d0fcd@syzkaller.appspotmail.com
> > > 
> > > smpboot: CPU 1 is now offline
> > > ------------[ cut here ]------------
> > > IS_ENABLED(CONFIG_PREEMPT_COUNT) && __lockdep_enabled && (preempt_count() == 0 && this_cpu_read(hardirqs_enabled))
> > > WARNING: mm/vmstat.c:361 at __mod_zone_page_state+0x96/0x190 mm/vmstat.c:361, CPU#2: syz-executor412/6040
> > > Modules linked in:
> > > CPU: 2 UID: 0 PID: 6040 Comm: syz-executor412 Not tainted syzkaller #0 PREEMPT(full) 
> > > Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
> > > RIP: 0010:__mod_zone_page_state+0x96/0x190 mm/vmstat.c:361
> > > Code: d0 00 00 00 8b 05 3e 44 ea 0e 85 c0 74 1f 65 8b 05 87 e0 2e 12 65 0b 05 d0 99 2e 12 75 0f 65 8b 05 d3 db 2e 12 85 c0 74 04 90 <0f> 0b 90 48 c7 c7 c0 e7 ff 8b e8 3b b3 6d 09 65 48 0f be 5d 00 48
> > > RSP: 0018:ffffc9000627f8e0 EFLAGS: 00010202
> > > RAX: 0000000000000001 RBX: 0000000000000000 RCX: 1ffffffff2287150
> > > RDX: 0000000000000000 RSI: 0000000000000008 RDI: ffff88807ffd79b8
> > > RBP: ffffffff9489f448 R08: 0000000000000001 R09: 0000000000000000
> > > R10: 0000000000000001 R11: 0000000000000000 R12: ffffffffffffffff
> > > R13: 0000000000000008 R14: ffff88807ffd7940 R15: ffffffff9489f440
> > > FS:  00005555785ce400(0000) GS:ffff8880d5da2000(0000) knlGS:0000000000000000
> > > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > > CR2: 00005608d531ffb8 CR3: 000000002cb7c000 CR4: 0000000000352ef0
> > > Call Trace:
> > >  <TASK>
> > >  __zone_stat_mod_folio include/linux/vmstat.h:410 [inline]
> > >  __munlock_folio mm/mlock.c:144 [inline]
> > >  mlock_folio_batch+0xf97/0x36e0 mm/mlock.c:204
> > >  mlock_drain_remote+0xe5/0x140 mm/mlock.c:230
> > 
> > So, we are calling stat update functions which requires preemption disabled
> > (because they access per cpu data) an offlined CPU which is fine but we have
> > warning that preemption is not disabled.
> > 
> > Let see if syzbot comes up with a reproducer. We can just simply take the local
> > locks like neighboring functions or something else.
> 
> After looking deeper and it seems like __munlock_folio is the only one which
> have a code path where lru lock with irq disabled is not done before call
> __zone_stat_mod_folio. I think we can easily fix __munlock_folio without
> acquiring local_locks here.
> 
> Something like below. I will run some tests before proposing a formal patch.

Thanks for looking into this, Shakeel, but I don't think complicating
__munlock_folio() is at all the right fix. This is peculiar to the use
by mlock_drain_remote(), isn't it? Which is not taking the usual local_lock
because the CPU is going offline. I would say, just take the local_lock in
mlock_drain_remote(), but (I haven't read the history) for all I know,
there may be PREEMPT_RT reasons why that would be completely wrong.

Hugh

> 
> diff --git a/mm/mlock.c b/mm/mlock.c
> index efa6716e4dfb..9ab8042671f1 100644
> --- a/mm/mlock.c
> +++ b/mm/mlock.c
> @@ -141,11 +141,20 @@ static struct lruvec *__munlock_folio(struct folio *folio, struct lruvec *lruvec
>  
>  munlock:
>  	if (folio_test_clear_mlocked(folio)) {
> -		__zone_stat_mod_folio(folio, NR_MLOCK, -nr_pages);
> +		enum vm_event_item item;
> +
>  		if (isolated || !folio_test_unevictable(folio))
> -			__count_vm_events(UNEVICTABLE_PGMUNLOCKED, nr_pages);
> +			item = UNEVICTABLE_PGMUNLOCKED;
>  		else
> -			__count_vm_events(UNEVICTABLE_PGSTRANDED, nr_pages);
> +			item = UNEVICTABLE_PGSTRANDED;
> +
> +		if (isolated) {
> +			__zone_stat_mod_folio(folio, NR_MLOCK, -nr_pages);
> +			__count_vm_events(item, nr_pages);
> +		} else {
> +			zone_stat_mod_folio(folio, NR_MLOCK, -nr_pages);
> +			count_vm_events(item, nr_pages);
> +		}
>  	}
>  
>  	/* folio_evictable() has to be checked *after* clearing Mlocked */

