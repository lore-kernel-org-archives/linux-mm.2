Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DB0A9C982C1
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 22:40:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DB67B6B0095; Wed, 16 Sep 2026 18:40:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D675D6B0096; Wed, 16 Sep 2026 18:40:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C7DAA6B0098; Wed, 16 Sep 2026 18:40:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A65776B0095
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 18:40:05 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D2706160163
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 22:40:04 +0000 (UTC)
X-FDA: 85221094728.29.0FB62AF
Received: from mail-oi1-f198.google.com (mail-oi1-f198.google.com [209.85.167.198])
	by imf30.hostedemail.com (Postfix) with ESMTP id 2AAAB80003
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 22:40:03 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=none;
	spf=pass (imf30.hostedemail.com: domain of 3whqragkbAAEtz0lbmmfsbqqje.hpphmfvtfsdpoufou.dpn@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.167.198 as permitted sender) smtp.mailfrom=3whqragkbAAEtz0lbmmfsbqqje.hpphmfvtfsdpoufou.dpn@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789598403;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references;
	bh=eWbhpWk71ccWdwuOVmq402NHgmE8BaqjoYuvIsrzF3g=;
	b=giiW+GdZbooR6EepEaXjt7JY/GguD8WoD/I4NojkgXtUm3Bo4lP/9haT1sm1uQU4/KE5pp
	ctf1/iZDo1ESsi2XJBxHrq3Hr3o2W4SxchehDcWfDtaQSegDEoDQLg9Be4SL8GP0UtP1H3
	Fv5MBWT0a/8fhDgAQB8UiJscyMktxVE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789598403;
	b=aUtQVJbWDWXx2Snr0CoVWr+8igtdL5D/QA+t0JtsOou/lpLg7+ZUsSUoAltBTGoCJQtf5I
	bjvnTF2Is7c16/YLArnL/eC20G4Vv4REMSx9J/5SCV2VPncnIj/dBN9qaEO9FDkLtHNQ4F
	hGPEPKUAefjNN9mCLWV0oVTMwLDnoEw=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=none;
	spf=pass (imf30.hostedemail.com: domain of 3whqragkbAAEtz0lbmmfsbqqje.hpphmfvtfsdpoufou.dpn@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.167.198 as permitted sender) smtp.mailfrom=3whqragkbAAEtz0lbmmfsbqqje.hpphmfvtfsdpoufou.dpn@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
Received: by mail-oi1-f198.google.com with SMTP id 5614622812f47-4b28d7ffab1so261521b6e.1
        for <linux-mm@kvack.org>; Wed, 16 Sep 2026 15:40:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789598402; x=1790203202;
        h=content-type:to:from:subject:message-id:in-reply-to:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=eWbhpWk71ccWdwuOVmq402NHgmE8BaqjoYuvIsrzF3g=;
        b=f5ryO7Z9L7WwGtBqIC6xHMz8aPUqFeisHrPltcRGOFge20/5AvbqJ6bhFJ5Sh36LBN
         ydkePBqou7qUuWQKNI+NXGk92ynFgtr0HiDynzAUsZTos110zVRx6/SZn0519+qNqQNk
         bct+toxPOY9v6fzTxjjHORuE2GLWXsFl7znESB9edzUkHC7Ea3EiS3svIXgeBgehzcoG
         DNzZed+FsotSWcjdr8RX74pGvbmt3L0csnMwb3m7c2NTYRo2LKnawP+VLXxwt3VenR7i
         lt7u2joVDwpisP8n3QwrT+6IarTLkm+lWYo/U4WrX15HfpKfVkVif3/C0FCOohoDvfWV
         cOZg==
X-Forwarded-Encrypted: i=1; AKwUvBxhYi2CNML+4w/bPjlM0gNBrt1rvsOLWz/7dNZ2JQf5utSkayH0TPGJXDbj9quC2WYXV7aCzQb9ow==@kvack.org
X-Gm-Message-State: AFuF++mO2P7VNKz2hyzMdihTXoE+D1haF94uahnV0FSPLoAMGy9EyLl0
	GCMXpyC6MPf/vtn/CsOMHysLg+hO8v9YDUilQon/OdTlviWSvMnF30lB1Y/KJfwdfUPJRQZ8VPL
	AxweETXvuQ186kQQjCzRSHbFfuICDv2hJcdSalgWoOZQabKoLudwczUzPe+U=
MIME-Version: 1.0
X-Received: by 2002:a05:6808:5087:b0:4b8:4703:db8b with SMTP id
 5614622812f47-4cb69b976f2mr1049869b6e.20.1789598402258; Wed, 16 Sep 2026
 15:40:02 -0700 (PDT)
Date: Wed, 16 Sep 2026 15:40:02 -0700
In-Reply-To: <6a1b9770.fd5edf16.2e7427.0008.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6aab1ac2.71f81b7d.278072.0000.GAE@google.com>
Subject: Re: [syzbot] [ntfs3?] possible deadlock in page_cache_ra_order
From: syzbot <syzbot+8bd419f88e25ab12cb75@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, almaz.alexandrovich@paragon-software.com, 
	gality369@gmail.com, jack@suse.cz, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, ntfs3@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com, willy@infradead.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: zr7976ihmf5grg6mx1sasr3c5jdi9diu
X-Rspamd-Queue-Id: 2AAAB80003
X-HE-Tag: 1789598403-996104
X-HE-Meta: U2FsdGVkX18R9Fk/Hx0v0viKrpgLV63DjE2VgYfiIgU1TdLPGaCuwdAC7a/G6sMySer5KUo6PadjDBHsTNiWvTP/ydr1h5Hyg4WjKSYr32/CZ2fsYV4ARmejXmIRlS/kOzvhB5WXBKdh8wIC6l5P6mIZ727Hbfv5OiET+nKlNp5ovRBjdM2/3le5aR7t2agmAeuwwcaZEeGg9YL1m1t3FapDFBJdN4SRjz0iKwA6w5rrtANkv6oNeIReCYAKzSr4hMIovAwwZGNJvpfaQfNVJhu6sOg4r5DYWwuvC+AxUJDCtzU0FBS7wlp71vobDDb+FIW420hnk1je6UtUZ1LwBBflXW8vOhJAa82lgwUOh1UKJwCn3kEMBXvcRwqloco+sFwaMGWwTdTZ5ArmpUVscImXSgf435dVym2b54dG1u0gFKizt0d0zGONfa/akhBLFYc3hUqkwlBx+sBILNL7WibL299PIBb5NIOpXmqBmhWJ0wuxt2H6424q8rDbVUlJHRJK7BTP6YcArM+OvSbX/fTNJaNq9OaRiVmyre2oeM2QHiii+euzBbkBrj/gjmp7rL40AHfmSLDaFe1zjDqNxvs7VUHEuVabuIytL+y+PYEnumcqR1JCFoeseYurwE7uAeXExhk8jDFUNDJ8AGDP9kUJckBfVYulpHAUzRgPhYJ2/N0QwRazV30hZsWgF2wyttfppOQ+TfuMYB1M/gvUQQo/hBaQ5Vwpj88Z04xGWE5sixYOwITniFdEugcqGJ+jXAdrghilM0k3fJ+zsQk7KhMBGmwvHxRrPl5F5Zzrq0Sg/BT4CT3al8OaBvIg0i0ql54i24CQ1BsHkJRXX45ZZM4YWQtgGzcBPl7K9cW2cPWAThLw9lGW+ZMz0le0gHB4kgyx+xLZhvuLgQhxXJsUOYLz+vQKnVYRkAGNGW+hShqEsh8qkwO5X9/Gxw32WeSABeYQCFzSAv51DD9bqDU
 Y8u7EGOI
 QhVlLIZRETIvPBxr5dowIo001FziatNQO8LAO6YBLhIXzQvHWdBPWpvvdtJv1n12Pq/wzmeKw0p7Egc3A8t4rLyBedT/0u/n5hEhtoeBHPKnT+p+KUnXeguTxJEFblNiOaYE+6OdHSWtWdk//lfFP1XXZSN85Bl96i+EC7Ry0LKWbbXEscahZcE6NwQf19YQwM17nRNzAQqb3Di5sKxMsqvkCxz4VZIqD/bNPcAygInwp48T3GuIf+m4XQYFozwW924i1KYjRwbVnnvxosE12/pWy9cnBaW+FsXoXTjY0m0rbVG1INYybEVz5hEbobf43WOFUQuT3q+7Pj+3RJDDg3gHJS7XgcQT0n12bAZAAFkLn6G2a/6aziUzRrrTytw3eMpmBfi/SItTWcYwdzIKnkAcxA+yiB2ObLYMWRV5VxkbOVpBtZYvvIhU22elxWHH9YkfEQn7zTQfrkPr2vxK7cnvBCriO/uquPIpkuVQd24XSwDGYiCT4KeupwJ7GwfAs5i/glBenv5CnHUR9/Drg7SkH5ydiMPn/yMgxpm40COCQrYo9cC9S2zLjmE5rim7HkmPRvE1LP0/tAUmA6hSPibhpYpKH84Z8ONcH5AB8b60nczkv3g7B5cXihimzjoQKxTl56WFM5c+JL8OK1bl4knZ+RMUl1qWhtNsRXV+IT13PqQwv2lneM1X1mT47pYMGRNakb2ll76j30l+d7jCTYBCz3eYTyZ7UL+JVBMON2ZeP62Trn6LJhqhIKn5iTbCMPg7rPJjZ0Fm++Ls0Bhn6nmO2Oly+oLvqCf2ZguoE7nrWlSaU+597sqENzWfFEU+EnONw8bdsTkZ/4t9wHQQGK1+lgfHO1+r6exZMV46kgnaiWZdCfm1uwbVR5LERFs0uquAV6vDnFSnL2jf+3J51kzq/bbT84xFHVk/UjMU+TkuwLaJa77pU8Qqv8YAHCEhi6Gf1fgql9QAGWjdymPC9oSo7IPCy
 ksgMsbk0
 7wqAViDaNg0M2L3nd5euEhkHPJvbg/5oCAee/msJT2D8uad2v05mcDmj3q9l/GGoZIv0BcL+SJyxM4ijakM3UxiN4YPnbE4qfenmlO/GJKMqsRbe1mPHFa4VftyY2Iqp0m6ixjwRqcbGQtxpJTAIKg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

syzbot has bisected this issue to:

commit d62cf685d12e95cc0a4122c43cd9f0eb8bba0b4c
Author: ZhengYuan Huang <gality369@gmail.com>
Date:   Mon Apr 27 07:26:50 2026 +0000

    fs/ntfs3: hold ni_lock across readdir metadata walk

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1540dbf9580000
start commit:   704340f1cd0d Merge tag 'x86_urgent_for_7.3-rc4' of git://g..
git tree:       upstream
final oops:     https://syzkaller.appspot.com/x/report.txt?x=1740dbf9580000
console output: https://syzkaller.appspot.com/x/log.txt?x=1340dbf9580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=b454dc6b1b7acd30
dashboard link: https://syzkaller.appspot.com/bug?extid=8bd419f88e25ab12cb75
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=154788c9580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=134788c9580000

Reported-by: syzbot+8bd419f88e25ab12cb75@syzkaller.appspotmail.com
Fixes: d62cf685d12e ("fs/ntfs3: hold ni_lock across readdir metadata walk")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection

