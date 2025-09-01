Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C9205CA0FF0
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 07:59:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0E4988E0003; Mon,  1 Sep 2025 03:59:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0BCD78E0002; Mon,  1 Sep 2025 03:59:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F3B738E0003; Mon,  1 Sep 2025 03:59:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id DEC188E0002
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 03:59:04 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7FC7A5AF12
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 07:59:04 +0000 (UTC)
X-FDA: 83839930608.08.37441C1
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com [209.85.166.200])
	by imf30.hostedemail.com (Postfix) with ESMTP id C48F780007
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 07:59:02 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=none;
	spf=pass (imf30.hostedemail.com: domain of 3RVK1aAkbAAw4ABwmxxq3m11up.s00sxq64q3o0z5qz5.o0y@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.200 as permitted sender) smtp.mailfrom=3RVK1aAkbAAw4ABwmxxq3m11up.s00sxq64q3o0z5qz5.o0y@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756713542; a=rsa-sha256;
	cv=none;
	b=ZF697hMIJpUDtJp7xwr2YN7fD5igDj8dFZRMUBKra77aWFKSGbblWJleL+L0fqoSnP08QW
	DB3C/wEua+WXfBjesrNrWtmkm3Ajd9imAYQzWWZszBlSLRiSiR7ltaF0wOX3wgJx8IbuMU
	kCXFzziZqDc5bKkWBvRISDzgnT26MFY=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=none;
	spf=pass (imf30.hostedemail.com: domain of 3RVK1aAkbAAw4ABwmxxq3m11up.s00sxq64q3o0z5qz5.o0y@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.200 as permitted sender) smtp.mailfrom=3RVK1aAkbAAw4ABwmxxq3m11up.s00sxq64q3o0z5qz5.o0y@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756713542;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references;
	bh=ncCn6bpTVDHk1ba1TpluJzliVkR7s5GToCEpP4HhJVg=;
	b=0j2pd52eL2McB8KI9r79L1vB9DVvx0amk/zsAXv2izVYE+V1Sk/axYBKcEvDhNTJuhEX4I
	ZzjVpkCHUrMP+BJNob59o2lof8sKRb1mbJn/fYFo3ID4DlNB8/v8xO2fXM6Skbvdg2Ex8n
	L5PkCGGLdPNpsABFHWkYMnnnGWaHVf8=
Received: by mail-il1-f200.google.com with SMTP id e9e14a558f8ab-3f34562d167so30956825ab.2
        for <linux-mm@kvack.org>; Mon, 01 Sep 2025 00:59:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756713542; x=1757318342;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ncCn6bpTVDHk1ba1TpluJzliVkR7s5GToCEpP4HhJVg=;
        b=ShGl08CrG9osvIk5rwp5qMqnsYScu0OI7Sv23RObC5snWTtN0YkVpWALIB07dBuJkE
         azwMWu2E5ckA3Pvy5sQ0ulq5f+fvJdwE7e53IJz2KgO5xRP9v401J8D/7Bt1IwhacYSv
         tDKlaIhY1VWrUwItmzpbOHVyCPDko/HHIb8vle1eir+ep2E8kIwiAOzri6hH+WSIlDdj
         tYbsye60yhZKWUYF39AfyY70ieHQqLgvKPxSWs5rD7B2MnJtUO5c40pmU6B6Zs5HfnXk
         J0Zf2+x+rucNfRYFJeeCKBNhgF0DfSdCOasa191ribOSREjgDYu8HHtc2J7dIzEwzVBV
         Y3zw==
X-Forwarded-Encrypted: i=1; AJvYcCXcVanKXzcl+0ZKL7WNK7j4Q2LQfScKu1Tpho7COb7aoFOec/zEFQphrpY63R6rBL7f1W1ZO3p/WA==@kvack.org
X-Gm-Message-State: AOJu0YzELvnIo/UaIdHTzzIClQMvLgyTnqk8q/AqcSG+X240cq2tzyXh
	ALKk/EYVe6MlifxXSHXSJifwEQIqWGL/qNQjEp13hc5AcbVOrbt59M/qV7cDLh6tv9HIsX0YeHK
	N8TGstBghAHEAuYdlMLGgAwYglxDPmg1Gp212nZ9piaNWRId/BXT9JBzv3oY=
X-Google-Smtp-Source: AGHT+IG1coevK4BPflUC3vJfg3mRNLVwz6bIIweWGs6nW994OKtQhlFQDvA5RRrv/tDtocb6ctTseJaAcH45ebW8YHSROsp0rn+s
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:148c:b0:3ed:6cee:f83d with SMTP id
 e9e14a558f8ab-3f4019f6bd1mr126599275ab.20.1756713541938; Mon, 01 Sep 2025
 00:59:01 -0700 (PDT)
Date: Mon, 01 Sep 2025 00:59:01 -0700
In-Reply-To: <00000000000091e466061cee5be7@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68b55245.050a0220.3db4df.01bc.GAE@google.com>
Subject: Re: [syzbot] [hfs?] INFO: task hung in deactivate_super (3)
From: syzbot <syzbot+cba6270878c89ed64a2d@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, brauner@kernel.org, dave@stgolabs.net, 
	frank.li@vivo.com, glaubitz@physik.fu-berlin.de, jack@suse.cz, 
	jfs-discussion@lists.sourceforge.net, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, mcgrof@kernel.org, 
	shaggy@kernel.org, slava@dubeyko.com, syzkaller-bugs@googlegroups.com, 
	viro@zeniv.linux.org.uk, willy@infradead.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: C48F780007
X-Stat-Signature: b3z3coqb5w17hjjw71mfhmzrtu78xpsn
X-Rspam-User: 
X-HE-Tag: 1756713542-782138
X-HE-Meta: U2FsdGVkX1/UQtE1VIsdXSD55P3ULb/kYIFlelANTlJg1Ojk7w6cnbAAlEf1fffMzUqSxnI1UL919uHhDsCR86/+V6UMuqQ2SE7ioe3qWVz0as7DPkBKZiyM00DURhU/4YXlj3G0x/FVcVzR68xQ/GzAbC1EIKmMhbInppWQ7ySMJf16vfJHvRh1OQ1D1GVNCo9J1Xr8dLSorKCYP4zwQHod4c0EJ8CjFzOz4llCCNfnohRd75tVd+3Qnb9Xr2mb0SHoFuNyMdJfrZx2jTG7I3wm6iNwxs6kPMnLzfQ7/1HrcRUsgCTwVG6i07R3bzfsv7K3nINi94NFPuMioePUbDMiZxg3xGHwYMSqqEfxeyGHjFhphXP1Dl5IWQxtFN3HMLyQyf/jFyElfyuiGk17nFoIXoWHL1Fdiy44cLAlh0DXBxF/ysEp43FzzpSs6XGWPzx7ctGDtpspgp5e322ynkEUtBPr1mmZ4fVWkfnI+toFjfwV/tLzQ3d1OkSfsaSJr0XQlD9Ihh/oH6fWeDfJg21Aie/QHUx1s8KEQtQMvf3RhOztSz67M4O9IoCpnHD6rek+7ZOdwxihyDaNMfyyvDV+P5QKRVgSh+A/EmRPxLWdwLH+oxln1+FsXiUWmtbw6PKP0X1tYOL+mUZ7w8NK6q/2ODBmbTQUQuskVoVTWQbgRCPxzfpx3VIStwGR0Z9UbtBgKXPlLYrMFoKx0vM3ytdLtcMSk4HGCv711q90d1sWLShQmRAY2KfOEGCRWcBhYaMKQZNvMraPbLtxjYOV7pT0Vcx9iW9Ay+fK/NFGQqzJs4sZp2NFnn8ROIX0k912kfXWKrljvltktzqiZrzxMGVXJ/BoVnZZ9BYsor8npKixdNr6bF3PANMoJgpjMHuasxehCi8YTu9esrzUpS7IY0OLXuhT56La8mgWsf5gUUGikbTGdgcd8TmOca41rT1xhJM/F/Mgn/fNMnm9Gz+
 riPrmE+X
 fXzrKQqKO+GTzxF90zBQcl7kGxW8E/4DGySGoqSVyF+Gg7+dMA+8442zx7mCqtms/ybL6ZpuEVciF0KQQyv2JoH95rW9XURa5ianhPPveBH8qtpv7h+IAiy4tJQMKeUGGQh1BRQ8odk118y8u0t62mPh0PIgr7LeOWO+6BuvS+LXbuD0GFNf3NeeQAfBLH43xNTje+75VULBFvzX/deNu41/4UT/22EQy1SEDGKF56ahSLcX5ygV0KVcDGlqKaRlbYdw1zhtiOJDuDvjZ3QGKehS2n/RSZ5WTfpiXMtkqggnJH2+5mgmQs4m83pCrejP7yXhxpOp+89tAjJLBqdBKYpY0FW4dlwPosoaFJ/+cAzQItEtAZFSJmc7cZeUXJAXvdlBkhzMOsc2V538FSY0V4T/eagf/wDHrwMzD3C2+20UYQFiGbXeGv8KKgWp3lfx2Mn1WiYiMLBzRsAlS2bjz6uuHf6RCGutyxJd3a542uzpS/iyzuuUM8ydpsfZ8q15y3jTYjnvl4qHEEPB3diyN9KqLcZuzJU3ColWl0HLv7tnnzQ1wNkRr5RuCm7es1FhJnZqmpA+N6fcRgC4rArqCWkx+tCMLRCoeIA4N4JMOi0qzBDwVTMsjk+0BDHrvoG0rJ50SayvHrH0GsTqDMGc455lPNHLSLG8R/vPZzoEs30npuckCz11BFbg0PgIAZFByiRI5au0gDrymBTSprrBaSUzinvyDwg9z6zU/Ju25bc06Sm9PyRvORItYeL6WzyigrfFC/wmX+33aDSBsyf1LHNyog/Bpp64dkXBBnj1bQqHzb5QnznmD5HC21F7sHIs73e3vwcrcpojBAzMCBspOEj1okocNBobR8touqkVbavC+kcDX6QgR7jl4J6yZZ4hLQAXH04YjnkboNxaNnb7gxfTIkEvWhxP8s8a1oRX2EPNej7dHTpGFnCl9RERgoPnw5NoBhIR26kEedLZg8Nji7Hr7w1EE
 30HZZ1JB
 R4n3ehyjTF1xZHKEGrXtMo9lXujQUAXAUChfWSsHwtAjyZi6YgOBQmKjMJpkOj6JvRkb74puML7ZY7jCYYMTbwfyZVYirAWzeFV4x9jdwhurxmKfCWNTFgAKVqdawlemaXqEYxnW6qyW6lF5ka3DDA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

syzbot has bisected this issue to:

commit 5b67d43976828dea2394eae2556b369bb7a61f64
Author: Davidlohr Bueso <dave@stgolabs.net>
Date:   Fri Apr 18 01:59:17 2025 +0000

    fs/buffer: use sleeping version of __find_get_block()

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=101ba1f0580000
start commit:   c8bc81a52d5a Merge tag 'arm64-fixes' of git://git.kernel.o..
git tree:       upstream
final oops:     https://syzkaller.appspot.com/x/report.txt?x=121ba1f0580000
console output: https://syzkaller.appspot.com/x/log.txt?x=141ba1f0580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=bd9738e00c1bbfb4
dashboard link: https://syzkaller.appspot.com/bug?extid=cba6270878c89ed64a2d
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10857a62580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=14f5ce34580000

Reported-by: syzbot+cba6270878c89ed64a2d@syzkaller.appspotmail.com
Fixes: 5b67d4397682 ("fs/buffer: use sleeping version of __find_get_block()")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection

