Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5854CC624C6
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 07:45:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 343466B00C1; Tue,  1 Sep 2026 03:45:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2F3516B00C2; Tue,  1 Sep 2026 03:45:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E2C86B00C3; Tue,  1 Sep 2026 03:45:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E19216B00C1
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 03:45:05 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 42C3F1A01D6
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 07:45:05 +0000 (UTC)
X-FDA: 85164407370.09.62B42BB
Received: from mail-oi1-f197.google.com (mail-oi1-f197.google.com [209.85.167.197])
	by imf01.hostedemail.com (Postfix) with ESMTP id 981F840005
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 07:45:03 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf01.hostedemail.com: domain of 3foKWagkbADkntufVggZmVkkdY.bjjbgZpnZmXjioZio.Xjh@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.167.197 as permitted sender) smtp.mailfrom=3foKWagkbADkntufVggZmVkkdY.bjjbgZpnZmXjioZio.Xjh@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788248703;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references;
	bh=cO+IF/roQ735VVx8QXTPGBRUMv96ABeB97I7jAxa+8I=;
	b=VZHHcv5Mgp82DVrx4SJAVIwv/ElYr8PsDSrw4617hYH0EACJm5z1ee3pY+QoSIKtl1I5AW
	KYHv9ZKt4cePbAXmwlSydJtSPoxStJrL9nN2n2o5XLlqkyJ/m4GaMr3ZDQQHTa9mhBAYwz
	MABBzXMJSNQuttsEFGR3lER2APDVVrE=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf01.hostedemail.com: domain of 3foKWagkbADkntufVggZmVkkdY.bjjbgZpnZmXjioZio.Xjh@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.167.197 as permitted sender) smtp.mailfrom=3foKWagkbADkntufVggZmVkkdY.bjjbgZpnZmXjioZio.Xjh@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788248703;
	b=YAXNRjfQqvPDVqalXzn0SvnjKnz2e0JbROk9QbMO1fSgSvHwVz4ypJIB1ffcjBM3hniEcD
	9gE8cOV+l9ux8Mvs5nwisKWhXsvH/F4OFS0yBFEjW2q6lGCWyMRkVLF6wrRcOHcmIpTzAI
	axFrp1/7faiXxUN8NM8gm8rCuDc4ujw=
Received: by mail-oi1-f197.google.com with SMTP id 5614622812f47-4b37620eb73so9098918b6e.1
        for <linux-mm@kvack.org>; Tue, 01 Sep 2026 00:45:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788248702; x=1788853502;
        h=content-type:to:from:subject:message-id:in-reply-to:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=cO+IF/roQ735VVx8QXTPGBRUMv96ABeB97I7jAxa+8I=;
        b=URKaAgIyCSfVipD3VVLKwraHhKorQB2t/Yz8PWWNiEgI9rI7FCrPyLGsHqk8emHSX1
         cLgIOy6M4I34/Ht+2L1qdURYEyvt4l3cLDA4+cIdhutRRBna34whXPmgOTxCOIHlcKVh
         kVdRPreeKq6iFNavZ9Vd/T/iqxs14BRCvHA14GrcL308b4eAnD+Iy5+QU+XoajnWS/t0
         L0TrEPPNsGiqJQbKQ/k2xzFIAR8GQnIqBXMzLjEOwJc/JVvammw/rqRRShochxBedlKZ
         iNAQqmsZbg2/57tNSGgkQu08NJ1+gQVxXGbdFDuKMKwuQZrDWF2K4uWklcz7YUCF09H1
         dmng==
X-Forwarded-Encrypted: i=1; AHgh+RqSmBNm4qE3nYyMWUaxpeLhhMSydTnYQ42c/i+C4IHs7LiaU/TazxJRlvdpiFC7GOSWfpzBY6XN0g==@kvack.org
X-Gm-Message-State: AFuF++ln/uFojOLB9lLGRodyZvkM6xF1Gh/jOGu1bL3HKGKVlpsEfeeP
	o7GzeICFekMz3iKvG+Rzki3dOUIf0bWUGx0ENZ7PBlF46ZwXqbmtLiID9uCsiD4enCBw1aAFyPu
	qbULC5COFvy8oGHCJ+ffv5l8auDVeYMIY3kKr3eJQi6XnPZHnaIonHUObabM=
MIME-Version: 1.0
X-Received: by 2002:a05:6808:1a11:b0:4b2:8d9e:de11 with SMTP id
 5614622812f47-4b5b837c725mr6942194b6e.19.1788248702670; Tue, 01 Sep 2026
 00:45:02 -0700 (PDT)
Date: Tue, 01 Sep 2026 00:45:02 -0700
In-Reply-To: <20260901014117.416981-1-junjie.cao@intel.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a96827e.04428c52.29b18.0003.GAE@google.com>
Subject: Re: [syzbot] [kernfs?] INFO: rcu detected stall in kernfs_fop_open (7)
From: syzbot <syzbot+19d01f6082ec61dd45b2@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, davem@davemloft.net, edumazet@google.com, 
	gregkh@linuxfoundation.org, horms@kernel.org, jhs@mojatatu.com, 
	jiri@resnulli.us, junjie.cao@intel.com, kuba@kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, pabeni@redhat.com, 
	syzkaller-bugs@googlegroups.com, tj@kernel.org, vinicius.gomes@intel.com
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: m4e4je7nymhcxbaaxrggp6gn1qn1wgde
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 981F840005
X-Rspam-User: 
X-HE-Tag: 1788248703-373815
X-HE-Meta: U2FsdGVkX1+Go6Gq9qnsQFjKMwPYl75Z4mFDRao3CMOcxtAdUZBdqbiv8YtRgEPGqt1eI+LTmUML44AdAqAPCWzqZzMjOnYXtzwbfG2vDmTSdTjq0uSfNcax+9rM0O9KMNryt9d7zEMqdM/VeU9uJQ4AN/BMgcErIy3OWONr4+fClRO6/RiILu5vNJ9ZZsu1ohESmkn5XMSxfEvGztgCSuOpP2Mk8uR0bepxrFEhHGG48b0iGTdrLW7j/RgoBJ//0liCWM5P/dYSCfT/nX7TTVh9vTV8aU27AAO0E86Vz0OVqQYz0NmDoCK7ZTvhyAfEAJVsghAilpHn1wGwE9ddtMMP25YB6mUmGu+dO0N8P43/VJqVqscexiav8BPm/yobOk76vqCL5tWp2Jw3H2cs0FMcQr7fLn7+POFdJgQMUvQm9wdq5wSfQ2YG736BPtFUrnIk6OtOVfHB7NWnB9dQ1kB4WMeJOlFKMMN7bww9Jxb5oI6aWlVBa1quhXyep6PIRC6IJeN+uwJ7v0Jgl6yB6H04qV+dIVfBluMXLTAmbdUa651CCXQAkzPxqZZcKWN+BTBy7PMyNmP5Qbooz+ZOZHUYvLvCwIk68lcnz9zLa324r3+stYYDRJ5RbtClkgjCRixTSBNMTh2MaNVi0kMprLII1ClmpdqS/gpXIAxo2F2NZIsRdW84h2InrW8s+cRcSbGhEnpJskxFX+Zb9xTXEk2CkkKO1gMFTga8U5AHwTZsmPRv/f7ZNgdVL64sbryyEI5hvowV4I5otfUYrngDJoQtYus3wV577EVIf5WN+r9/kDbxsZTtwuu+7sixjFjSWZxvdow32vvbnolQbcH/jVACjMD+FlfOZMs10YkHFyc7evA9vrhbHdYE73avnh6YzUJGFnKo3EXWX5ZGRh8BsF6wAKQHor4GaZgGUMEG7EjrYhiHQyvFdGru9k7OrrttX91KflifbVwcJlTqB0/
 nb5JsS9T
 7iNc98hXN8+kMghTlGE73HVJHJCt3XdbfvxMD4rse++Jc2eggAdgKTusCzikVmgrM36d+We+T7boPOJ50YJZ5OqJ2k/J+OZyrpqZm+Kckrcll/Hd6FG1Lo7XCtiTSy79nm6Rr4AlxnNvfovI3dAYLFrBtGY2Y5/2hhu6Mjo9sbu6tWfkAJqwmPs+yXCnLFP7PwXS+0ipMtZLtL3GjmrEailQINID33gRxt6NcrislbV6GfqOxlCUt+FxN8uZu4EDg2Ggjba4f73Fzzu2YHvoO7Uni1S13OIlyx/EfVY6Hghn+wcvYPFQKPc59brtTnwlryLr4OUybwCUqJFIbhuRD3/3fmz1Fcjgg8id5+oOb+EP6X5muI3LipmPR12DeF7aeL7VnpsfjfW+31/QwNht5Hz3yj71vz9Btsz0Eg9VJF9IQS8GFnly+XsSoFGW6AvMh5yJjsTkvrMPa5uADvXM+dXtLw4/hrPg7Lvbpm2V1Urj8Lp/zSSm2YpCNwxN3+AW05zXiiQkn34W8UteelVUwm3g8ZQopOQxQb8/hzTh3nU4GTD4xRdiQEThgiNhW6RoMgLOSGSf3kMtOfNAq1OvcFqj1A6fo4Y7sjcixm9bbRXx/lr0quFe48PNJFZ9A70c+lVkPx3+oFhphnk7vRjeLLYeiiDZh4fbhNTWuKtvI8eX1QqVvDzqVzmaSMCg+gKJMr101thkmnwguT849XyYzPLUcp3Bcz0TwpOYFWrTVnmHaX6rweyGMyzKxi9zfWvvMF5tAZpcz+mDfznYG/76YmnyuKR1ZAYbxD5TXLbqI5wtTjaQCbMQP4kkvo0dQHacQ/AQgsep5oluDHlZmPLZI5mwKwcYCZo7vD4cXC72G7/ib8zXfa6d2qEE3nfRd8LucJNvU5HAkWin9Oqw20j0WZ25sHKhCDqWd54fpEXhMkuYmxDASfPBePl1Jb2NIu6qtA5H0GUUZ4KPvw7gaJn/sxFifBdtM
 N2/E3gU2
 nmUErlfDGKPBSbo+KVT+AZOoGh+tkv+q2CDdtVb1wJI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-by: syzbot+19d01f6082ec61dd45b2@syzkaller.appspotmail.com
Tested-by: syzbot+19d01f6082ec61dd45b2@syzkaller.appspotmail.com

Tested on:

commit:         abdf623d Merge tag 'wq-for-7.3-rc1-fixes' of git://git..
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
console output: https://syzkaller.appspot.com/x/log.txt?x=12f51379580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=d7588e5a39260ad2
dashboard link: https://syzkaller.appspot.com/bug?extid=19d01f6082ec61dd45b2
compiler:       Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8
patch:          https://syzkaller.appspot.com/x/patch.diff?x=14a46d9e580000

Note: testing is done by a robot and is best-effort only.

