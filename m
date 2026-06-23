Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 74BA4CDB471
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 20:32:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 368126B0088; Tue, 23 Jun 2026 16:32:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 318E36B008A; Tue, 23 Jun 2026 16:32:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 231116B008C; Tue, 23 Jun 2026 16:32:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EC80F6B0088
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 16:32:31 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id EFE461C0608
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 20:32:30 +0000 (UTC)
X-FDA: 84912325260.13.3741432
Received: from mail-oi1-f200.google.com (mail-oi1-f200.google.com [209.85.167.200])
	by imf17.hostedemail.com (Postfix) with ESMTP id 4EE5C40011
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 20:32:29 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf17.hostedemail.com: domain of 3XO06agkbAHsrxyjZkkdqZoohc.fnnfkdtrdqbnmsdms.bnl@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.167.200 as permitted sender) smtp.mailfrom=3XO06agkbAHsrxyjZkkdqZoohc.fnnfkdtrdqbnmsdms.bnl@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782246749;
	b=1M5zqGGoFIWN0pMG5leqkRHm9G1ljlWjwd7InsoJwmZ3Ubttq0JmXD2RVMUDw33WUh9t0l
	EBHdFc3ezNJzX+LifqjvprseLbF2Jv589u5rPLOse662FiD3CrOAS3geszz1aFMK/3onBA
	ToMbEy7WFxdX9TaLW4Futx2tPyPMmU4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782246749;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=R8qO9CYQ4i2Ve+uZGNs0646rmmrEZtQY5ZRuuroPY0o=;
	b=wh8A+3R9yey4MtC4fzn58dz616oauM3eRnjzJlmCVKbp4pZsx1gd0cPoSECFrbbQrOe7XY
	QSXfqEfifJi2gjBdMZVNePZQaPuixJwA/7V44Lf4cp4vqOWET8pxP87JLrO5cgl7OkV0h7
	XddVCiGybr1pfhARty29XZ0KX/LvtDQ=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf17.hostedemail.com: domain of 3XO06agkbAHsrxyjZkkdqZoohc.fnnfkdtrdqbnmsdms.bnl@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.167.200 as permitted sender) smtp.mailfrom=3XO06agkbAHsrxyjZkkdqZoohc.fnnfkdtrdqbnmsdms.bnl@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f200.google.com with SMTP id 5614622812f47-48638069322so368286b6e.1
        for <linux-mm@kvack.org>; Tue, 23 Jun 2026 13:32:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782246748; x=1782851548;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=R8qO9CYQ4i2Ve+uZGNs0646rmmrEZtQY5ZRuuroPY0o=;
        b=H0t/uITWROnXqIZU1jJOGpUl36+DseYJJLsBxakHkG4ox8a4ioHYsjmMHIGGVD8kzr
         Z8wukm2VJagItAcQso+2AQ8qIsMrPvoT7eBYlGlpBkRpDF1r5UnKcW6n5BD8H9uZL0A8
         GOsMEs08GrH2vpNRbo4Z2KsRidNDIVVbJ5mrjeIxHxjOlMDXhDIlCNgVlLrqwy4c+2SQ
         MTmkWIcTDKHtOEMa19sCoTHfMy7M5YcnEmchsZKk8EtOzmK64hqhjiOt+iXUUX668Caf
         lOcP2GAr2ECIs2l8H1evaHBVNenBaThjFkUrd43I7VzxYNSDUDpcdGWyuanXh4aZLdem
         WsIw==
X-Forwarded-Encrypted: i=1; AFNElJ+CADy0L6FN+L/0O+FdiPYqmNbi3/AdPLP2rqfvm4wps8jc+PF2EgGM7S0PUuc3WBaf725UwAhLkQ==@kvack.org
X-Gm-Message-State: AOJu0YxrZyITDCy1RiJdmq38lqjofqH/pUhIITbOZzlfTqDcjvv3EDSy
	tN14JS1sD8LtDOV908EHRA+JznG7oICVduSAUUU6xMAH0B6VEYu0Z54jxb3X5QOk2GAF1xJf0VC
	ds8tSzpZB3uTJGtCz/budx2yhJzd8cOXe3wXeg50x8BUdVr+IxcWhHc/P2CY=
MIME-Version: 1.0
X-Received: by 2002:a05:6808:1929:b0:489:6b3a:18d1 with SMTP id
 5614622812f47-48f29992528mr3167085b6e.33.1782246748463; Tue, 23 Jun 2026
 13:32:28 -0700 (PDT)
Date: Tue, 23 Jun 2026 13:32:28 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a3aed5c.b0c80a11.da7f.0004.GAE@google.com>
Subject: [syzbot] Monthly mm report (Jun 2026)
From: syzbot <syzbot+list5548945be6cdbe1097d9@syzkaller.appspotmail.com>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 4EE5C40011
X-Stat-Signature: etus5yr8s16z6mwh3femt4tr71dsfkcr
X-HE-Tag: 1782246749-408525
X-HE-Meta: U2FsdGVkX18gohj2NaP8fq6L6R+3bIlulNizWD7o9GKYq4Cu1LmaqgWNmeC15MZnRQr//r/RqHp4VSixv5HWeozlX+y5cVMwyOsYvZDXNbetSOSMHbPgnfjoenQVm5QkJ3VvRJfQEDcn7XELvOiPZw4Y2saL0ROKIpgAGvqM7gsHR+TuXmu5B2wtNfn008ZKHqffjna3qS7U5/n200aWA+KL0aDZ8qUaUmU9m8cm17sOQtbAhc7UNDSWTCRf70xFX75aCfsP4o+K4Vvxe4bXLn6px79oA6yXsDFgyNW0iR9H5nFKLfZTLNdf54aVv4LHiSrUKdgrO1wFVepmN1PTqviph9BrLeZ453CNZUm/39IfFNoVM89dO0RePscbGgdksavsHGe+GADZbEeasv03sa3tdKvu6eFIzx4vvjCeT1SoGE9jV/6f6Ydwt2tw9fp4h1gBzGqgkSFGtLq2RsDtDuJH/Fxzd+jntrl/HQ9TMhr0FQ5xhmGUmP9AsmTPFYP1WR/M3kUQtUcQlPZgu/2RazA13mVvo4pQ8EK2y6SmPW0zNFIg0k5bwTVib31/8qRGlRxP37xUXsgRXts2zdJtGu93a1Th/VVd97Irt7ep3hpe3/DdZOMY6a42xxtL4ZONxd6SrDX+htEHZ+mD6BqtcbQ0vtlMMFN4rcohP//udNi3EX2RcIxTUn6bqsfVTw3XwaIcLicUeRFmH5oWsMvj3oGJjkN1VSaejI+8xToPNY//guIXYu2/hqAC/nK1XtjA9XQsdsbl0de0AvVcEZamINJx+SktoteMVX+ULAQG9oGMNffa/vFzTuCrlSJOGR51+s2cFZfx37q6az6B8u1AHjiTQlEDFOvhVyIvfM/+ECQz2AykbuDmNRugHmul0fLVqqJKJR3LjcKAYoejtk0X6BjzAZKbqqTi3LX3kB3H1bM/6z38yauTFG9ksLPGR/olNpyU8x9PpLLkkzJp3VJ
 NYTkgq85
 DbnGKJdn/61bbcTZyIucTuJdegf+0AcmWe/bxKi9pNh2rfzacWiaABb8WUeElv+1b/ANTIDwKCAR7NdIcPKNKdxRxLEwEKbjDkN+EalHQUY7fWLR+YXuTrZhoUbFHFTmZkJADUjA2NAhchMYZgP7BOpNn/YFAj5tAbBpAOqJZkhSuS4UsKeS/M9Vr8uLll65e4TXbeuz1O2aKa0nrNdBqeBAvGXoVJKAjlhOUVtp7lUBxp8xUTY8ldIGzjfIvq0d6xxzZtk3xkHh+yoIGS60OmccrPaQeRMZoI51OX5E8zYyynZCO5Cc5fMrJKcBJIV+/2gqnC5dF7S0ApzkSgflUWQTHzvxrD/mDpa4sWbHuPc7z3BrT0Ryh7mV/dAhEjEOxTMo3SmOvqei/YCZcLXwdDQXzyMz3GaRhCA83eYyoazxDJreiESmsr6r4+IQsRNtHFiOJmvt3Q+R/8OwfmQGDkGYECXk4fSFXIDwjSkmIe3cuE9I82qM+cO4vBahp/zpUa642WRRoWv9rkkbRXQLr3bMfWYBv168AFJB5/nbpbwjRkKJvbsWW1ey0PmNxsBAo8uvLAOnI2RJOen31ms6lugWBLhU+77G5jyFPuDJH8YPh2pKnzZY5+rcXEXfmVWCh1rm/eWyWQCO1JA3adOa+aqmOrZ7hKRU51ArAiH7iCJ2O5U3HNic+8SNEVHJChV6Q6ZSKGNjTHUacCUYED2weyRGVuij9xsucErnPsWMOaEqYDboijBd6yfenGpSQXfSDaFLoXd0cjuu/5tu3hB1Koe6rpDNdZLxdThdxa21I2Q94UOivHphJjvqvPOPpcNdgItGsptY8MkBA1KCKg1oFeNP3VrjkIiAjpYrEyDv74ZWjJuvBDA9hyzQLrB5HQ1lDxrdvBmSDeQM+7y4UwdZJ1R7mLQ+EonjU5m1HY9AikkPc4qkeHiCLl0A37Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello mm maintainers/developers,

This is a 31-day syzbot report for the mm subsystem.
All related reports/information can be found at:
https://syzkaller.appspot.com/upstream/s/mm

During the period, 7 new issues were detected and 0 were fixed.
In total, 86 issues are still open and 373 have already been fixed.
There are also 44 low-priority issues.

Some of the still happening issues:

Ref  Crashes Repro Title
<1>  20360   Yes   KASAN: use-after-free Read in copy_folio_from_iter_atomic (2)
                   https://syzkaller.appspot.com/bug?extid=6cc93ec9a4035badb85f
<2>  10103   Yes   WARNING in hrtick_start_fair
                   https://syzkaller.appspot.com/bug?extid=2cbf10efc23b22ff9c31
<3>  3807    Yes   WARNING in trace_suspend_resume
                   https://syzkaller.appspot.com/bug?extid=99d4fec338b62b703891
<4>  495     Yes   kernel BUG in filemap_unaccount_folio
                   https://syzkaller.appspot.com/bug?extid=17a207d226b8a5fb0fd9
<5>  194     No    INFO: task hung in migrate_pages_batch (4)
                   https://syzkaller.appspot.com/bug?extid=f523acb98cd782b4872e
<6>  132     Yes   INFO: rcu detected stall in __dentry_kill
                   https://syzkaller.appspot.com/bug?extid=f8ccdac0a7eede0e1ae5
<7>  87      Yes   INFO: rcu detected stall in sys_setsockopt (4)
                   https://syzkaller.appspot.com/bug?extid=6e61d59e9d2150c8492b
<8>  76      Yes   KASAN: slab-use-after-free Read in folio_evictable (3)
                   https://syzkaller.appspot.com/bug?extid=4c7590f1cee06597e43a
<9>  50      Yes   memory leak in xas_create
                   https://syzkaller.appspot.com/bug?extid=a785d07959bc94837d51
<10> 19      Yes   INFO: task hung in writeback_iter (3)
                   https://syzkaller.appspot.com/bug?extid=1e3ff4b07c16ca0f6fe2

---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

To disable reminders for individual bugs, reply with the following command:
#syz set <Ref> no-reminders

To change bug's subsystems, reply with:
#syz set <Ref> subsystems: new-subsystem

You may send multiple commands in a single email message.

