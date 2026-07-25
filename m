Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 434A2C531D0
	for <linux-mm@archiver.kernel.org>; Sat, 25 Jul 2026 04:32:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BD6E96B007B; Sat, 25 Jul 2026 00:32:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B881C6B0088; Sat, 25 Jul 2026 00:32:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A9E216B008A; Sat, 25 Jul 2026 00:32:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 80F306B007B
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 00:32:36 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id DC199160263
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 04:32:35 +0000 (UTC)
X-FDA: 85026027870.16.9BF6AA4
Received: from mail-ot1-f71.google.com (mail-ot1-f71.google.com [209.85.210.71])
	by imf31.hostedemail.com (Postfix) with ESMTP id 4647020007
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 04:32:34 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=none;
	spf=pass (imf31.hostedemail.com: domain of 3YTxkagkbAMQ289ukvvo1kzzsn.qyyqvo42o1myx3ox3.myw@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.210.71 as permitted sender) smtp.mailfrom=3YTxkagkbAMQ289ukvvo1kzzsn.qyyqvo42o1myx3ox3.myw@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784953954;
	b=eo2lLzdLv2tcRXSXhYvh/YOjguwxfZh709conZkQM4UAONuD04Ki2gKl/uozhzGZfjcb2N
	dBwxAfEetqgBsm0BNQ7FMoAPLjgmJHPisbzowChysc0K0Ju8C9aZ0M4QdmqRg3IOFQWWxA
	U+NwzvEPkIZdl40zKe9hKx8zIUHPMN0=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=none;
	spf=pass (imf31.hostedemail.com: domain of 3YTxkagkbAMQ289ukvvo1kzzsn.qyyqvo42o1myx3ox3.myw@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.210.71 as permitted sender) smtp.mailfrom=3YTxkagkbAMQ289ukvvo1kzzsn.qyyqvo42o1myx3ox3.myw@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784953954;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=LiVGmaeeFRXjqPL4tRh1qrOg6P3LftulYA2XqVQquYw=;
	b=RG/dWXAwZIfeKnzTXLDbAqrMrqM+2wo5OS+r64CNh/8fH4SqdzqW+mJrES0V2ZQ16qr6/I
	cUmBnY00Ks2iD2otMJKc6o4lU4CHnsvQ+kE7xFg3Sh94yQgwbkoASShS7uuOlf5qsy0GGr
	d3Q/Kz3Juh4eg06wqRGjE0IFJx4dq70=
Received: by mail-ot1-f71.google.com with SMTP id 46e09a7af769-7e9dee2f7b5so1427458a34.1
        for <linux-mm@kvack.org>; Fri, 24 Jul 2026 21:32:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784953953; x=1785558753;
        h=content-type:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=LiVGmaeeFRXjqPL4tRh1qrOg6P3LftulYA2XqVQquYw=;
        b=bSjnNrXC3GWsi+qqlGDP7qjRtIBNPpu3yC9Xl3RTZSzI7ftaIhhQzI/KVm5Pzj55Xd
         jSEsNBUotvCc8LqL38Iw0lMNJp4O7yc5kQz91c2GzJtLkhON66KY3/tjEOdFNq0E26DG
         tt2uWWQ9ei4Q6ll33+ZefWDDCoJsUhE+SLorf0jLO117FSdJzUq2iMJSrRqSJspl0xZF
         CHQS3y2kg4v5OLpNxo4zwtUTzrmxED4XdFOUqpRSxSr8KAKBC1G7GD+znhgyU3SLh5cD
         OvcyyirC18mg9ZxPp+FK3dZn6bYCLKWJoAEC2gTohR/al6W3Rs+fbNCS4bOjt4hKmL1v
         O1sw==
X-Forwarded-Encrypted: i=1; AHgh+RpRZWvrytCSva4y3qqcJ+W+SMztSNwsmmUvzunRPGCRzVr2FvnV8D2qRBpz1P+eZSEhxgc7Yyh8zg==@kvack.org
X-Gm-Message-State: AOJu0Yxp2f5kL5KR+G6f14GUXnLXyIl/yLn6PvOu2BQKrPw0Ab+6kmap
	jyNnEOrmXWoQtBwAJ9u4gNgWuV/ZcSIJNyqqsLX3p46J+6s5Jer9P9iDyG41qT6Kk6U1wfG2pwJ
	wbYLbEyCsEzS5b7VJrSDiUege56QXF2g1PefAHiaMsms4q77hQdH7Zofy2CQ=
MIME-Version: 1.0
X-Received: by 2002:a05:6808:1456:b0:496:a01:458b with SMTP id
 5614622812f47-4ab69f8a83fmr1366237b6e.2.1784953953423; Fri, 24 Jul 2026
 21:32:33 -0700 (PDT)
Date: Fri, 24 Jul 2026 21:32:33 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a643c61.a2ea2cc8.fbad6.0010.GAE@google.com>
Subject: [syzbot] Monthly mm report (Jul 2026)
From: syzbot <syzbot+listbe3110d878037a751c37@syzkaller.appspotmail.com>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: ucfqwmndzan8pqbemkmwfrusdd18cfdf
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 4647020007
X-Rspam-User: 
X-HE-Tag: 1784953954-271971
X-HE-Meta: U2FsdGVkX1/CdzrJjyEtrKwZNdXn7p0Njx41aiyrvSm9tO8ETYYG+R0HqFRP/Va2izxlLYUxO4XuLmOrW/lwcJHahkKDa4SX2Ia3UwDmjsJU+mXukibIWt2fRa7iHyogI9lIUqHDd5m6kZPSkjHxHYSLGcmCWWzJH1d4VioOlcxvbS0JhvCLy2Maj+/6Qtsj53HD71Z99gFMY+4BDen/f3dnzTJMkfD4jHwYIIXAQa6AFFBhI+jSeSG8AkhnnJ89DuZ//Q5kzV83OjxXb3bFpTAzOkWi2VMkE4MlWwgbyv0DqnkCvF7LwCJ2CUxneylybCd9crZnXBm4OPIcoBBmm1J2mMohSZEU5p9S3YjUebGHPXVQiZMcCbw5MeBRqHQ1YeXwQBYkSny7EcTVNxCBmH/Km5mSf8Zt9HFQEQm/B9Fuger+Qikr85LvqMFqJ4Tr5a7aSL1iBs0ztLSPt8INsKeO2mTXuJIcAEjblgwyP5dKCuRaL6Fgpq87RXeh83Sq/QMgAWsAyOBvh6+5djVbdeP0Hd/rSpT/2bnllrmF5AEIp76hwGeRykGzR2xzt5zwsT6h0dTG5CUDn9VKTUvG8zu7XGyG7Y07Ssf1QEFxQH9N5LxGNSSv5bS4yo5JoJOqEpAKLwnZagM30PQlvHvr/gqAj7Dc3rViQsgbaYa7zUbPtGlPmD4iCuTPxbNd6hdKP9C0fm1Db/g0s+6hfUMTduksx6hQMTbFeV8KjmlbkUDwUtUMfOY6vevRzDCu/crnWOLaH9RfXhUNE30X3xSNtsKzu8DYtEwEJ4QBfURr6aP8YDwtLP424YnfTiwZCl0VTgc9CbfASw9dg1MtS+tt26YaTQpQ3jRUCljxaBX/rXpcmXOftXm0TKekJ4jOndEBebCcsxBqrKWpOadHQ69frfFN3xbPq4vsnpQJ1NsLr93uQo/bAXNktxuyzufO4nvDcXFrzJPVDskHlCT4Lr/
 B/Qj5j6R
 7m8gJsNJ57aVDNEhOojRvPdOOq3KJUPk7w4YPXmVPrtTk6TRg5CXWfD2HSp6wRW77k7E5ACRoYR8Q+lWCTbGUEstWsCbzrTL4jpRZzcP+ZCkYC1dJunz0iyx0Cbd1BKFhhSG6LKdU7bAb96jCEutFSrhH5uq5REec2uDsCmsJFRzXkdFKV12TuXvoRnpiJdjV/7R393kDbpQmnkaXL7cwCj1Ae6ddbgOjE7CENmngtwJakPb6OBORotwc6fSponolSZM2TdtzS0VOMsxmKvy/Ln2M4J/I8SeOdXT5wu6QCvcE5PE9ipBEHCRFJzAOuCrczltiKGvQ83Am49LBcrBAdNC6nwrRLZN1pw7U686M8c3NgeFuO7tRcqUVZHGVwtRd4JO46ESP5zeAU65DzAMgJap2HawAVCo0ek0FV8hTh89STKIMN86BDb1X0W/6xwa4L99zWLjA3YcOPSvEGPcMcAH/f8j/ROgAUQ4jAynMYIfYgjXSf2ZfGrBFazEkJ9t+za+jeIqLPaIGgfVvfbzeRsZrGBjvh8nXeZ6GfPc721BTivFHhRk5uHg2KPoYDlhKqE7pesIGLc3Nvifh3kygFhVEtLXEptZ5cYK+j2Rt8J8j/qMiDG3irquAgv5gPVb85KDdM7eTe0WczrsAHSYYhPfmpmQrsLdb17uUA+Lq7ZQDof84nifw7hloJdrAmN5crsXahhDptQ0dBBlPeVO7wxKgSww41BM+R/eYzi/Jgqs+EB2QONs/xpVTqmovwdbNXzPwsiJIlq6Crbd16i2b2ImL+n8oPGaUSgQA7XGAKetLJiuBVKkJioWxfpl76ckI5XeuoRMzdo5Th6xMCDNXfmAv4X7WSA37rlq+ZrhWdrEBgzuPGAhMoxoPkrSHiFc7OZwc4FTxiw/Ka0/okUCcpEpv9sIkPwlxc0kkPvhsVShjCL7TMs7Q1oz1HQ==
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

During the period, 1 new issues were detected and 0 were fixed.
In total, 78 issues are still open and 373 have already been fixed.
There are also 42 low-priority issues.

Some of the still happening issues:

Ref  Crashes Repro Title
<1>  29106   Yes   KASAN: use-after-free Read in copy_folio_from_iter_atomic (2)
                   https://syzkaller.appspot.com/bug?extid=6cc93ec9a4035badb85f
<2>  3862    Yes   WARNING in trace_suspend_resume
                   https://syzkaller.appspot.com/bug?extid=99d4fec338b62b703891
<3>  3102    Yes   possible deadlock in filemap_fault
                   https://syzkaller.appspot.com/bug?extid=7736960b837908f3a81d
<4>  588     Yes   INFO: rcu detected stall in sys_newfstatat (4)
                   https://syzkaller.appspot.com/bug?extid=1c02a56102605204445c
<5>  497     Yes   kernel BUG in filemap_unaccount_folio
                   https://syzkaller.appspot.com/bug?extid=17a207d226b8a5fb0fd9
<6>  283     No    kernel BUG in __page_table_check_zero (3)
                   https://syzkaller.appspot.com/bug?extid=2b5fe617654be3d8848b
<7>  264     No    INFO: task hung in migrate_pages_batch (4)
                   https://syzkaller.appspot.com/bug?extid=f523acb98cd782b4872e
<8>  132     Yes   INFO: rcu detected stall in __dentry_kill
                   https://syzkaller.appspot.com/bug?extid=f8ccdac0a7eede0e1ae5
<9>  96      Yes   INFO: rcu detected stall in sys_setsockopt (4)
                   https://syzkaller.appspot.com/bug?extid=6e61d59e9d2150c8492b
<10> 57      Yes   memory leak in xas_create
                   https://syzkaller.appspot.com/bug?extid=a785d07959bc94837d51

---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

To disable reminders for individual bugs, reply with the following command:
#syz set <Ref> no-reminders

To change bug's subsystems, reply with:
#syz set <Ref> subsystems: new-subsystem

You may send multiple commands in a single email message.

