Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9C873C61DBD
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 12:32:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AD9236B00B7; Tue, 25 Aug 2026 08:32:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A8A4B6B00B9; Tue, 25 Aug 2026 08:32:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9C79F6B00BA; Tue, 25 Aug 2026 08:32:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7E65D6B00B7
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 08:32:46 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 018B1120422
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 12:32:45 +0000 (UTC)
X-FDA: 85139730732.15.FE547BC
Received: from mail-oi1-f200.google.com (mail-oi1-f200.google.com [209.85.167.200])
	by imf28.hostedemail.com (Postfix) with ESMTP id 63B75C0010
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 12:32:44 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf28.hostedemail.com: domain of 3a4uNagkbABQCIJ4u55yBu992x.08805yECyBw87Dy7D.w86@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.167.200 as permitted sender) smtp.mailfrom=3a4uNagkbABQCIJ4u55yBu992x.08805yECyBw87Dy7D.w86@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787661164;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=mvOpBvtBsshInFjYrolnrvoUE90SgDyR0OR4ayi/pDA=;
	b=PpmS0xrJYYw+6GqzotaCWttH1MS9jVc18/5rI+LHZZU1I7tHtXAEigw131UlhgbvXAr3Ip
	58gVa6wqifV/N3SaPi2rEFmip19sy0XWyOreRK4U+cxOXs37VRpJNSUZdO9mm8eEpdheIh
	5fWvZyHWXtcrHvgDVuwCAbzXJEI3py4=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf28.hostedemail.com: domain of 3a4uNagkbABQCIJ4u55yBu992x.08805yECyBw87Dy7D.w86@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.167.200 as permitted sender) smtp.mailfrom=3a4uNagkbABQCIJ4u55yBu992x.08805yECyBw87Dy7D.w86@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787661164;
	b=icFDg0cWGfJKUx0UrsFRbk38wohhi2HNfYP2B4eJandXsouTQDTAXZfBDC+QsmKNlXHQKj
	4Vfi4uYlFMnSzv2HGgoDKe7PShec38qKgHNFpLKX8WvmwpNP4R2R4XUuXmkIV6wMUPILiS
	43kvsZSyUqsOPyb0YaJdC2hK2qC93bg=
Received: by mail-oi1-f200.google.com with SMTP id 5614622812f47-4afa222912eso3877909b6e.2
        for <linux-mm@kvack.org>; Tue, 25 Aug 2026 05:32:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787661163; x=1788265963;
        h=content-type:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=mvOpBvtBsshInFjYrolnrvoUE90SgDyR0OR4ayi/pDA=;
        b=OsbnThNrLCCA6vtAa0Zn54lyx6rsxqEWwJTU7loHkzLd4jnCzdkgHQQnAapuhORGUK
         kOI50iDZbenE/Jrxq/XLHHxzWTkvnrFLe1w5hO2SiFpQlDJO/b/hHmUyJVtgtCgHghjn
         XK6IZb113cLztcmmnOG6XEVmWuADDZ7odvYlMnOQlU0+C7ljQ4R+F4NR7JE9RZtFaYWP
         mWIGT36WqWeDPXUY7QvAmnMmxDjh+4Roe72OBO7TUifRfeTT+iTPE7aY/b7uKHfy6lDq
         xvju1K4/wnO6cYf04VUlD9fCNzJsToUAA/AmL+8ciDw16sQrqbQ9k5K8nzWzXgKflceF
         rq/w==
X-Forwarded-Encrypted: i=1; AHgh+Ro94ZBEmju97ZLbop8DRHlsCsKq+PYYKun2z8txjgIKgst43bA1DAoIXmtmhlTe4Te1/m2DeK4wAg==@kvack.org
X-Gm-Message-State: AFuF++leoSJKyu9Jm7dSL6AEPNSIInmQgAYKgEkY8FlRlHBLFSqzZC5r
	BkV8kc6lt3h4PXq0BG3KY65Sz2vhg0gXZZqxIsm7qb/FFxmGlcWMcWJN5c2KR6UmjVb08CPfldA
	mJszwdHi2bnC12Y4sz+4nZP9r06E7ql88rn5D4G0lZBZI/9uuD64HW46Jd6U=
MIME-Version: 1.0
X-Received: by 2002:a05:6808:1b28:b0:4b2:b4d3:f919 with SMTP id
 5614622812f47-4b309bc519amr21948782b6e.14.1787661163503; Tue, 25 Aug 2026
 05:32:43 -0700 (PDT)
Date: Tue, 25 Aug 2026 05:32:43 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a8d8b6b.a5a502ce.31d34.0065.GAE@google.com>
Subject: [syzbot] Monthly mm report (Aug 2026)
From: syzbot <syzbot+listbde04f625cf2903c660d@syzkaller.appspotmail.com>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: u11sh4x46sgqmugfjufmge1hn91mrxst
X-Rspamd-Queue-Id: 63B75C0010
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1787661164-38204
X-HE-Meta: U2FsdGVkX1/SRyFyuJmu8w910hybQOrjGIuljBNVYQ2MnXmxDIoIX8/jvmQhMDycMV2+MZ4R4yJ9RutaH/7TbVoj3GMjS0PrhcR6i/R1jbfrvLX9rU5oFZVLr98ae/7ZAUd8T1tr8YUv1lZEPi3h8tfDyuawuHTqxX06oijd0WJbTeovaWBsSffT/N3ePcYQRnOA6aGPVIum2GKNfq8MShaYvP88gN4rhoVt3UzPf9FCKf5BpyWVCSER4JXbseJ6NHTBvDZEB9Rm6AFXs9B9zdRGvMd5DydxCuWzitsA/zu2wWrWcAbUl2/3TXWO511KJ0tLnzcdgT8rJsDSJ9wT8vD/xuaU9/VvWf48QVIoCaQtwLmPlV6F4jy/ZBAr+h73Z/tFvx+LphwtUa+U0aGDHI0IRuzv3TuP0YNn3gedrDMkfHvq/gyXYZS1RQd1u9SHPczk/XTrBKohoRsaXNGhXrDL1epodOmmhptpfDWTVaUFErTzwMxmNQPZYoc1o5Zr34E8COLv+Nt79G9hwWK3rx0lut2P9x66tNz/l2vGy89qs/cGyaTPsrlaok2tMl9PB2iKAdSPKjcg9lnxEbRtikTh35M+It/jNlQkLvweJEEz3X2h2w1dALTsY0Ei7peJEgm3ajRV/geEf2cDaVLFZsXZB35W6Dp4D7RNubC641+2GSbOAWE3byn2EvHt8tak3ceN9IcwAfWxXTvx7j/4HJZ7Aw9WrVydZEXwOjpIv5/VuTSDIT7rIMnVe0kBqW+OarsSe2Klk6etoC7PUIs5iTOXgtiAsmSAFlJoLXx9P8X6QeTsHvbPdrRun6RxF1RuwhvuHUsARkgg3B8PAjGWzhxGOe5r+qdEVMgBZKq6ryEZlSaQ6tZE6T4vLmthhzPVsaMZ0Xmp+CSQP68/oK7pKeL/Dyj2Mar8XGTvbceC86tbVJcCLFgxr+TgpQcVHJTRp4NuZvOQ88Fyk08lgNF
 MtLW3JD3
 Bowft1OMYUSDm2p9vD5MgM29ZkzDDxf1IsCEXpefQSfEXcFn16NAcR2Tq1000S3mQoWnvS6KFEDlV0pcYGl5JA88r4Zjk82cmtBTWDuRq7snaaJZbbO/mmpEQ5V+WopbQR8sJW/8nxoo+XOr2XbfjxEpk+caIzHiDJzAWuRhzpTZlUHvrxwRfrJp765pHDrwo7h7mMx8OWXIlAGEZ+AxncgfccIFSxfs1ohVVSNu0BAmCLJwDXBYRihGZQtYoa/BNuv68sSXIYWEuCarUCrs4CZcfD5RS2DLoUBlwx3A0QdKK1ZVIInzXuyaCzEbN9rPkgNFFj6KCorItY5ixOZ6XBXiG8ft7P0w2yPVX1DZByMQ6CngEI72OOTsnOY8NQ1P5CbtD8POWAXg7GL+NeKhPOk/ccR7yQWEPn2UG3ZG0jFR8k10qmmICJRcTYTvB2vQAGaCU7fTOv/KfY2R14ejYy8Rpi2K2Sn1f1uraSDIhJQ2xi+QLFGsRJVFweB4eJPGldInheNDyddjdOM0SZ2pDwSgzgnuRM/C2tXsARC6sXBdOeHR7nWJiMGA5qPgefKH1FyJwDHxkSJIMjWQQcBEmHbci4KbEBAlWS7WlXGW2ayiDr3XVEfmDQQtmU6/MCoig7geekYs3CmwhhycFPkny2GRajR7E1z3DqiNaslxHVJIZw9zlB28wMDYhRIv2hyYPvZebkxvsfTfyjcisLpMCQtqmCU0kxzqqZ+6gc9U7/tPTDUH2t8XDWkX6zWGFCxJGiPjwSc0ioFvq1tOE2arWmpmImpwR3SyuzqWfBN1EQlN9DYADQ6wKFhQ8+8rkDfudvumdymIho2CAiRtskxlLyyowkdJ/YwXc5cohABPZIxVC2e9U0N5VyNUl2W6G1TX/Ina5Ukq0KIEJwqPs4BVUyUyOFr+VzHPgUBil5cvOiQAV5eh4QU11revRLA==
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

During the period, 6 new issues were detected and 1 were fixed.
In total, 79 issues are still open and 377 have already been fixed.
There are also 46 low-priority issues.

Some of the still happening issues:

Ref  Crashes Repro Title
<1>  34965   Yes   KASAN: use-after-free Read in copy_folio_from_iter_atomic (2)
                   https://syzkaller.appspot.com/bug?extid=6cc93ec9a4035badb85f
<2>  3901    Yes   WARNING in trace_suspend_resume
                   https://syzkaller.appspot.com/bug?extid=99d4fec338b62b703891
<3>  3119    Yes   possible deadlock in filemap_fault
                   https://syzkaller.appspot.com/bug?extid=7736960b837908f3a81d
<4>  622     Yes   INFO: rcu detected stall in sys_newfstatat (4)
                   https://syzkaller.appspot.com/bug?extid=1c02a56102605204445c
<5>  527     Yes   kernel BUG in filemap_unaccount_folio
                   https://syzkaller.appspot.com/bug?extid=17a207d226b8a5fb0fd9
<6>  302     No    kernel BUG in __page_table_check_zero (3)
                   https://syzkaller.appspot.com/bug?extid=2b5fe617654be3d8848b
<7>  290     No    INFO: task hung in migrate_pages_batch (4)
                   https://syzkaller.appspot.com/bug?extid=f523acb98cd782b4872e
<8>  234     Yes   kernel panic: System is deadlocked on memory (2)
                   https://syzkaller.appspot.com/bug?extid=c61d6962d0b7e698439e
<9>  109     Yes   INFO: rcu detected stall in sys_setsockopt (4)
                   https://syzkaller.appspot.com/bug?extid=6e61d59e9d2150c8492b
<10> 79      Yes   KASAN: slab-use-after-free Read in folio_evictable (3)
                   https://syzkaller.appspot.com/bug?extid=4c7590f1cee06597e43a

---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

To disable reminders for individual bugs, reply with the following command:
#syz set <Ref> no-reminders

To change bug's subsystems, reply with:
#syz set <Ref> subsystems: new-subsystem

You may send multiple commands in a single email message.

