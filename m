Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8B7E0CA101F
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 06:54:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BC8FD8E0003; Mon, 15 Sep 2025 02:54:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B79048E0001; Mon, 15 Sep 2025 02:54:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A8EDD8E0003; Mon, 15 Sep 2025 02:54:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 934B38E0001
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 02:54:29 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3CFB21DE63B
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 06:54:29 +0000 (UTC)
X-FDA: 83890571058.25.18A9EE3
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com [209.85.166.197])
	by imf14.hostedemail.com (Postfix) with ESMTP id 8975F100004
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 06:54:27 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf14.hostedemail.com: domain of 3IrjHaAkbAP0x34pfqqjwfuuni.lttlqjzxjwhtsyjsy.htr@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.197 as permitted sender) smtp.mailfrom=3IrjHaAkbAP0x34pfqqjwfuuni.lttlqjzxjwhtsyjsy.htr@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757919267;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=wP9FzrGSo7Vh+PQL9BOeaS4VAZ4FDREP6aI0hmCyut4=;
	b=tInqUC1+/RtNNIDWF1ePeBQSvfBj8LEwg6GbgCzPKL/3FYJLU7C+HzBiw35cPFb6FjQpX9
	8jN7X6yZi46owVmKha3Xj7GH7nf2SihfDfXAscTeBUodwDpsVisEctLxNQEPtYYzThcXLS
	uhl7dfc744gEVIp1+RtIO3IGQLr7y00=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf14.hostedemail.com: domain of 3IrjHaAkbAP0x34pfqqjwfuuni.lttlqjzxjwhtsyjsy.htr@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.197 as permitted sender) smtp.mailfrom=3IrjHaAkbAP0x34pfqqjwfuuni.lttlqjzxjwhtsyjsy.htr@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757919267; a=rsa-sha256;
	cv=none;
	b=Vl3VOBXdHSnURCW4+o1OYQyMQ6l4o5hY3h7yK4VVe0GisIgJP/NwesolEKKj1V5whwcYJQ
	oTCHlxLuJPIrf8PyOKF02n87GoiM96TSdCH2/MHxgAePvEe1v9N3wkIM3qK+TnbF7l8Pt/
	Q2pMSOb4VdT1Tpvihp2kF8N5TzMu/tE=
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-411db730dcaso141596965ab.0
        for <linux-mm@kvack.org>; Sun, 14 Sep 2025 23:54:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757919266; x=1758524066;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=wP9FzrGSo7Vh+PQL9BOeaS4VAZ4FDREP6aI0hmCyut4=;
        b=aKi2jp9iZLbcHH4423jon3TDoYbU08GcnOxA+wYcVCaCjS9gCaudtiN5BhyC1QCcuH
         LMTkkIpdmpQkCbEtntamwn8XdVMhyQkbrjTCIjqPLnc5U9GfVIDFxZ/kan92VC3gxTS7
         UGqnCf5XL+dp5ctzWdCZ1nN4eqwHp5WlAL9XutL7xi6SvqAdhBcbOjQgLyU4oowHrYc+
         2tzu7TRlxDaTXGpwnO4yzpl9Xf9FUwLoGPdN27aDSE8mIt3q8pgOlnlX3Ry2bAAnQCp1
         nRpFnHYO2SEwHE5FuKgEsnS4HwqVOPSqstBZxbiW/lGoVq9DQMWe/hdhmHyPGJ8ahlGl
         XvhQ==
X-Forwarded-Encrypted: i=1; AJvYcCVw6R4JR8WFn+46A8YbI4RZs1r12Ua7DspU374PwaVZBX6IeQzEM/Uny3LBwuMuhbnFyuhO7byTNQ==@kvack.org
X-Gm-Message-State: AOJu0YxQdEdxcvbB9wuyW2LCH9vwR3LiRT2KrjsUxAaE2G+CkJ+RYBED
	sreLek469GD6rF2NUesX3R29u86D/ugg147C5UPcyohKme5UEJO3eIIFV1CpCmLAJ/xfzfkGLRV
	fXB95wR368Sp+OERNdm5mZq+sRWvUa8+v+M5jCcephyRriBJUzPYEdNuLEAE=
X-Google-Smtp-Source: AGHT+IEWOslQcy1qrcT6epS03VdCcVjy3YGkMaj7PjsQjBuB1TotQWPUvyfVPETvtkdErYAVOukNSfaysxNlSaLLePhlJIRtVhvp
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:13d3:b0:423:fabc:67d1 with SMTP id
 e9e14a558f8ab-423fabc6833mr35274165ab.19.1757919266741; Sun, 14 Sep 2025
 23:54:26 -0700 (PDT)
Date: Sun, 14 Sep 2025 23:54:26 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68c7b822.050a0220.2ff435.038d.GAE@google.com>
Subject: [syzbot] Monthly mm report (Sep 2025)
From: syzbot <syzbot+list477ead9e37a715bd2178@syzkaller.appspotmail.com>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 8975F100004
X-Stat-Signature: gzgjxok1y1yjc6rebg9cq6j7fkaaz5ig
X-HE-Tag: 1757919267-61776
X-HE-Meta: U2FsdGVkX1/lkG3kVoVzdvVQQCd+zjA+1SMCmHDpzTz+cFrrf7fZpxzA/p7T7shLnHmqCBJLZg7WkzgO15ku/X8HfFQKFiU194Fec3bqzW81aMLMs3J2VV7cRe8BmS4MYOare7rFtTsOx+CCVscVjojaFVoa0iipnIOY7lN8zU6TSpMRw2lWAeQUBYPV2WcUMTIiGV0kyzYpqi6giuBYMbFtP8kgZ0gqZHpGAPy7co4fYqR0j9u3HMrk5yUjNuIoQRCtfu+TX3uOGAptN8pf099feKxdjtQVHapzk4QNiajDNnBtzPdkBnGv3TALYKvOyR43nB21SY+D+vwdhyjVZY0Gqh6owxpKZ5NBNolPrPrTRiqWEO9FI5u/IzWLCf64EPHgdUcSrIexkMdlxft89BmzPV48AIhkQmCFt9ExmLPohTJp2RFKIJM2WAXMnjibQPYoCD0z1FPUsEv6GqHoE7vH10S/mB9Q+bYfatzhyno4vPBXm3sMXwaC2a6BKiI73BRSSpCXC/VBqRT0oafn8ka2niGqgeu3FH1nhTdKfNjDwcb+002WpeRTy1CTJlvXMKlQGaYiqrervkH6jT/yUChroNprp3Yq4hdNpJm9BlWlLl7pO6KTgG69gYV3r6uvZ72QyRpSPv8WJ41BbmrvpbTf/Ih5tihNiUsKfoY0jo9v0nNXDj/D8HMfsifQh6W5kd8ouwibM33OJnQUMRuyJ45z6/r+pjTGHY6jevemnfLhYOiXZps57AxjFvwfd+bGc0CGFRwslHDgvlS/b6C1GimNnnnntdM7kZyPsQ8jLL4htVI+bV0mYEiuNB/ZGCNvxtnn+eeZGjMyVrD+INCOdtSBwWmivvikDPvL4LB/c81bB8ClrT9PIPrvepKiXsufMyeBmrVRHCNB5/fkwlH4DcGzb8Po/d8vfNSAloy0ESSmNkKLWnEs9KLjeiM/SQ/JhU8f6l9ad2Jg40aavuc
 qOBN/n/a
 Q6RvRWfngxB2kurOcCYJVvAV/wCOjtfLxhmXeohZrhkYzfICnrU4V2LZDJg8Qihkfdk30XQ/TK3CQGOErw1HyhoDzs+yISbyI/+sMAXvr/2C+tvdaraR3TEHwSXpis5lFdvay6vZxqCVioHCpI9l/iDkTYdWl2wubXHQGaJl0i3FGDA/y0hZc9gFcoE/0bSCOvCHQr1H3kNSVmSCZXf4grqH4pSe/Jtww/fKpqVktZmI3O0o/jmK+xOSqfeJ71r6u/7hQIlhhgue6akUQD0Oo+Za9vDyg7EqiEdpMFDYlE+40zywx4XHQY3cTiz3j2hpqSqHFYpbRaRy0ATBmRo1quj0ZzPXergmGvgk4oj8qJK7asJl3vE0QJdybR5YqHuWgfLRTiPZRh5XWrRUKwCmTsGMglFYPwymrzEg35iot6r64srSl/LhnFjv3fXKT54fQkpB5Lv7ivJGELQ/b7+5ltddEsCrlgbM/GPMrSmm0u2P90Z/siqQ1jZhuZPIRHeIHx/G/veyh8O05r/zauM0HCevMqQh+xx5OGznVMXE+I2oXqbFyUue7IjekYYh90QpOWctb9f6zoBxs5ozyWKwlu1Ih7V6mn+ZKpUjzK+tFgfsoYGlRkuo7wUeQHFXGqd2+4JSkODKORV1r7/m575zvxAwpEpYPjLJu7X6w2L9VkQn/i5vaCdR5ODKBUQTe8+VXkFv7vaR8kYbBPPEUXaEGBCN44Ebll6GlXIwWmWr5ceGNvp3OyPKT4sBgi5qfsfUjrzG+iZT3w3mgxUI8bnRIwY418Akkr+1cCvbPRgwdWW7g7Ib7g/nYqg823n0v38X4kxsqSkuFUqqgp0i/E66l+NUsoBlEK4NKJQ2sOUjzZ6FloXMSX4ODzr5n40arEMZIQJeRKwEZUG4DFYA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000001, version=1.2.4
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

During the period, 7 new issues were detected and 2 were fixed.
In total, 117 issues are still open and 340 have already been fixed.

Some of the still happening issues:

Ref  Crashes Repro Title
<1>  7424    Yes   WARNING in ext4_dirty_folio
                   https://syzkaller.appspot.com/bug?extid=ecab51a4a5b9f26eeaa1
<2>  5478    Yes   WARNING in v9fs_fid_get_acl
                   https://syzkaller.appspot.com/bug?extid=a83dc51a78f0f4cf20da
<3>  3643    Yes   INFO: task hung in page_cache_ra_unbounded (2)
                   https://syzkaller.appspot.com/bug?extid=265e1cae90f8fa08f14d
<4>  2919    Yes   possible deadlock in filemap_fault
                   https://syzkaller.appspot.com/bug?extid=7736960b837908f3a81d
<5>  822     Yes   WARNING in trace_suspend_resume
                   https://syzkaller.appspot.com/bug?extid=99d4fec338b62b703891
<6>  708     No    KCSAN: data-race in __filemap_remove_folio / folio_mapping (2)
                   https://syzkaller.appspot.com/bug?extid=606f94dfeaaa45124c90
<7>  580     Yes   INFO: task hung in _vm_unmap_aliases (3)
                   https://syzkaller.appspot.com/bug?extid=fe8f8efd070d727de971
<8>  556     Yes   INFO: rcu detected stall in addrconf_rs_timer (6)
                   https://syzkaller.appspot.com/bug?extid=fecf8bd19c1f78edb255
<9>  464     Yes   kernel BUG in filemap_unaccount_folio
                   https://syzkaller.appspot.com/bug?extid=17a207d226b8a5fb0fd9
<10> 457     Yes   INFO: rcu detected stall in sys_newfstatat (4)
                   https://syzkaller.appspot.com/bug?extid=1c02a56102605204445c

---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

To disable reminders for individual bugs, reply with the following command:
#syz set <Ref> no-reminders

To change bug's subsystems, reply with:
#syz set <Ref> subsystems: new-subsystem

You may send multiple commands in a single email message.

