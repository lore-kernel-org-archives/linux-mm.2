Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E9201606A31E
	for <linux-mm@archiver.kernel.org>; Fri, 27 Nov 2026 04:33:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8B41A6B05B0; Thu, 26 Nov 2026 23:33:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 865736B05B1; Thu, 26 Nov 2026 23:33:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 77B316B05B2; Thu, 26 Nov 2026 23:33:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 50BEF6B05B0
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 23:33:34 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id DA00EA75A2
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 04:33:33 +0000 (UTC)
X-FDA: 85479630306.29.D763068
Received: from mail-oi1-f199.google.com (mail-oi1-f199.google.com [209.85.167.199])
	by imf06.hostedemail.com (Postfix) with ESMTP id 440FC180005
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 04:33:32 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed)" header.from=appspotmail.com (policy=none);
	spf=pass (imf06.hostedemail.com: domain of 3GwgJawkbAK4gmnYOZZSfOddWR.UccUZSigSfQcbhSbh.Qca@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.167.199 as permitted sender) smtp.mailfrom=3GwgJawkbAK4gmnYOZZSfOddWR.UccUZSigSfQcbhSbh.Qca@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795754012;
	b=Z5WnwG7mvuCFGpc1w2YO0crYpXBYKk0YDdWPz47Wv1s+utl97sexZfoWA3X+ZK52cNqqbu
	hlJrfpbnmEa/yhDunzTdJXdeiS21UJ5Ydfy4cWvHMlLtau47gq+JJTukaYX0dPDnUwFBvn
	7ykSJgtWZ639J7353tjCHPcco2QHNBc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795754012;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=RtCl9bLKvCJGn7zLPcTxsOwpUTUjtSTIamyZWGlNDQI=;
	b=TsIO/Ld64ir5HDgaL8KJ/7p/gqOiMlzD+RLik7sxCHljVDW3tSNCIP7iuntP7ELG5xKje9
	y83eQwtC1pm2/IzY4xhcMZOtpJUeIHwXFz9Yoqhz8x2HPZlOlM29RY9eWjh+0Jp+07Otqx
	DXUV6uUAmmlZNnvmSsyr1ijQnxT/UiA=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed)" header.from=appspotmail.com (policy=none);
	spf=pass (imf06.hostedemail.com: domain of 3GwgJawkbAK4gmnYOZZSfOddWR.UccUZSigSfQcbhSbh.Qca@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.167.199 as permitted sender) smtp.mailfrom=3GwgJawkbAK4gmnYOZZSfOddWR.UccUZSigSfQcbhSbh.Qca@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f199.google.com with SMTP id 5614622812f47-57ce46ad0c1so6017843b6e.2
        for <linux-mm@kvack.org>; Thu, 26 Nov 2026 20:33:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795754011; x=1796358811;
        h=content-type:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=RtCl9bLKvCJGn7zLPcTxsOwpUTUjtSTIamyZWGlNDQI=;
        b=1X96g/3LIfBfB99soBbpoVhmUw7d7LCn0eu+JFUsRVGUl1HPMzNb27sPxqJ1EViIUl
         3PLaHVgwP/4L+AcVBAhO3hk9hGcC+YG/M4zyRTPRx0dnSyiVo0BhbNlAXl81En3TzybG
         ZwokHQ0bdStGC4Iuc4V7Xh5WBV4VUaPhYdRyV49KXQovNqMRcERo7ZkI5CoonJnh0iHj
         eM7szGKjRRWldoOp4/Cgi4+TIgqRNHeDYHLB5b50Y6gEgbO2fPfebHuPhALa8o8bNH8X
         nkOhd/bSP9YIDZN60CmrZSWKg0TOI89tMQdi25xTawDNb5jEXFGVmJXkhaNNo/HYct++
         0cHA==
X-Forwarded-Encrypted: i=1; AL+hErFOqu0cuhvPYu1UU691nc9wUGjM41+8bIjnuqBBAUZRRzaHTkVQeiyUhSCQZ52xAn8/pUSu9J8E7g==@kvack.org
X-Gm-Message-State: APuU4Z8fTBickp4Z8He9HIkQioOFlTw+ND7J7pZZq3XJ4grKtDNaEmT1
	6GFRh7PTkW7gs2vAYJnpGhXuoUwlLvJFr4hEU/qb5rrHXFtSC55CRCcpuYjr9M53DD1sZjycexZ
	/iVGZBvkAAy66b6CW+FhehJ2nsjfXjtILRmOH2XOBdR6GL1mM7ciUq184T0M=
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:23c7:b0:4f8:716d:793e with SMTP id
 5614622812f47-57a0bb86478mr22640780b6e.46.1795754011369; Thu, 26 Nov 2026
 20:33:31 -0800 (PST)
Date: Thu, 26 Nov 2026 20:33:31 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6b09081b.904258e1.78503.002d.GAE@google.com>
Subject: [syzbot] Monthly mm report (Nov 2026)
From: syzbot <syzbot+liste51eef8f5d72764a3f34@syzkaller.appspotmail.com>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 440FC180005
X-Stat-Signature: yibxwmsdzrkr5oxakig6c3uoboaf6jwf
X-Spam-Status: No, score=-3.7 required=3.0 tests=BAYES_00,FROM_LOCAL_HEX,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795754012-284486
X-HE-Meta: U2FsdGVkX19s0bBDrF20SNq0OGfVwplIF9KIymhCzoN6XQTAktcaT4XpY/1X6hYD310ZNEaGWlWg02T7XGF4EiJEfegLKDsS64+xPReEb8c22pYGSCFYIqLHaS0Funy+uJw5jri7IBF6EHlddbuFpqalG9EVWLwS4apRioRGghBjfz7LIMAt1YDq38/2LkOa/GS5wqbjEwKFEKW5gzywmDg3AGkF/6FRpxayaFQAcoDW0rp1npXreLLc7OnzBYpr3TN8oH5ZBGpuVEfihgcneg8epcD4eDcIlU9HP8ms4HxgTkb+R9plgzfEbzjNC1C6SJ2z2vU4jeKocGJMOqyjZQpXU5gVuCfCfqF/EzwMdsQj1Je/Wb3lNv05Oesc586uiRyuEviuIEb+ZIuB9uZCiO8jOr27NALTkwCD0/Dwy9yVgL+by+1w+toZTGK73gWMq+s3eskg6tr5UHdioi8eaB2PAuZuzJNUbHJwuauz1ixTUJQqY1FSxEhWz3q1KoiMBacHeqtFJEmYq/LSEeJOiCMwRHbg8mUR1ohJ0R39ORFxY9/WBQ/UQjppCZOHjRvMZth7lyNsQb6MHJ07CCGBrvb+Ew0SH/t9eIoeWAsttKmglQix7q+WVPqXmNIP79uzuebKcea1iOS+hwHSo140VdHrBUzDDmv1ls7C0hxSJ68fGE8aXXT+jH7eWEbiPtC0Pdh3ZdFERcIhESr+aB/Lcgvw/IJiucMA/6vNV2W18WHyg9RGgTVKWnzTggsCmGlRQOT5aVPshVZ3cu9UXVtAIvbJGqkav9aMIMrZycD7WtzAk3+PJQ9HwufVHR5exj7st/YVTfxoeiWBUvUiniSbMrewQuweoLKkebLbezXB+KIz9UzrtdxHjnnHi3sA8CY5lVo5H3jdKu83dZ6z1q5cMcfrrcwpJ0RIjeka91PVLTkaRuCavZEA+YZLjLDyXvZgzraaI4+JV5bJVfztiZ4
 50fq8aya
 EV7MdUnNYIU0ZIR6VN1UBuFxidTUpkDfesDgOqhY8sL5FsZMut/bOSSg1xbmtSvnaGs0NDB35QmJJa6lROchPDQBLpLYUPJ0CNNRxw2oCN3/bcbXZZaRk+sH74hGkGj2hm0qtNFiyuZkV63nIzCCsfvMEYv1hI/U3qPl2t9/Kk80vb0nW5WtMf8sS542uvuwROx+XlZZqPIV0YCiZ2w4m+ZctKqEAf892mRiYOBqbW5VvbndD6etZZyjcCGURUdXd9KCViJVOjN9HQ0PxjhtmH0uPi59Dz7aZQatuQzt/G6dVTNzjiNOSZNrsE3BrqfxeeUmvjNMdAxvBSEmRBNDXevv1tkThbpPX9LUw63gVdZBZlrNxGKEb3o77kQ/8CjHD/E1kxYN5Ialz3Cr+QEo2wOO9tL3w+UsxbwDrEN2K9PFzZlZmJkTxZtGxWBgJ1SHlpirk+SnbQwKHXWUOjdt1wbgyVSXfw91n2rpne02GBeubRfcfatjEVPYSf0xhrUxTkvGD+oOFgeNsbbb8Lcj3IyBqAc3yCZc2Xj0MtfPRBlO59cQ+aI00uomHk02vUCZ5EmhHgzOpyndy2XQ99kGEkoIPv+EKzY3A4uCCxv0OBgre4VXEVDuT5NSf9OT/HDgr+7BWzx3HJdjFmy1wCVlehSVrXocRPJT0bDYCOI9WfdUvwIUiDrANwQGvWd9ceyBOPKhZnCkKUZuvmjatlRjzhP9Bc+0JurGFxi9IEd5R8roJtQ69OFKtWH/W5DkpWMnCXN/Er0rnk55zSujCoyQTng1JoPk066VeE7agq4HlzfreNHxgpnnWeUXD41TE5yES8J+HVimH3sLB6twu0DzXDu9HicKdEQ0zIm4gKq+6MhJoQkG2geiS+m7hwKAa+3Rc7itVIkdEIW40iXWUjk9qXpZ5dKOms4w0HI6Q9DHIELEi393cCp9e+MJzGR4A93J1IEjzb+QUZ3y1yxUqCUXm1FMSIHXu
 o+A+SEKx
 jO5jxzaUCTU9LAWuqhsrOhvM+yp00RDnAMAMDU2zBm/jhQqs2laLuNj0LWnEW4te8Ixp38LA1cJmKSFV+C/OCulvi+uCefU3DrFMLpTrG5gvQgg0VrHbiio0mag54Bufi1n4Fv/4aCMbq4fghlq1+ChNWQ8wLrVb
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hello mm maintainers/developers,

This is a 31-day syzbot report for the mm subsystem.
All related reports/information can be found at:
https://syzkaller.appspot.com/upstream/s/mm

During the period, 1 new issues were detected and 4 were fixed.
In total, 73 issues are still open and 387 have already been fixed.
There are also 38 low-priority issues.

Some of the still happening issues:

Ref  Crashes Repro Title
<1>  50019   Yes   KASAN: use-after-free Read in copy_folio_from_iter_atomic (2)
                   https://syzkaller.appspot.com/bug?extid=6cc93ec9a4035badb85f
<2>  9208    Yes   WARNING in trace_suspend_resume
                   https://syzkaller.appspot.com/bug?extid=99d4fec338b62b703891
<3>  752     Yes   WARNING in ext4_mb_load_buddy_gfp
                   https://syzkaller.appspot.com/bug?extid=fd3f70a4509fca8c265d
<4>  380     Yes   kernel panic: System is deadlocked on memory (2)
                   https://syzkaller.appspot.com/bug?extid=c61d6962d0b7e698439e
<5>  313     No    INFO: task hung in migrate_pages_batch (4)
                   https://syzkaller.appspot.com/bug?extid=f523acb98cd782b4872e
<6>  197     Yes   INFO: rcu detected stall in sys_unshare (9)
                   https://syzkaller.appspot.com/bug?extid=872bccd9a68c6ba47718
<7>  155     Yes   INFO: rcu detected stall in kthreadd (2)
                   https://syzkaller.appspot.com/bug?extid=bb0c3b50c40032b58091
<8>  152     Yes   INFO: rcu detected stall in dentry_kill
                   https://syzkaller.appspot.com/bug?extid=0635dc2e2c3c21a6aa04
<9>  152     Yes   INFO: rcu detected stall in sys_sendmmsg (7)
                   https://syzkaller.appspot.com/bug?extid=53e660acb94e444b9d63
<10> 134     Yes   INFO: rcu detected stall in sys_setsockopt (4)
                   https://syzkaller.appspot.com/bug?extid=6e61d59e9d2150c8492b

---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

To disable reminders for individual bugs, reply with the following command:
#syz set <Ref> no-reminders

To change bug's subsystems, reply with:
#syz set <Ref> subsystems: new-subsystem

You may send multiple commands in a single email message.

