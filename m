Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3340C87FCA
	for <linux-mm@archiver.kernel.org>; Sun, 10 Aug 2025 14:50:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4145F6B00B1; Sun, 10 Aug 2025 10:50:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3EB756B00B8; Sun, 10 Aug 2025 10:50:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 328916B00B9; Sun, 10 Aug 2025 10:50:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 2143D6B00B1
	for <linux-mm@kvack.org>; Sun, 10 Aug 2025 10:50:06 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8759A160329
	for <linux-mm@kvack.org>; Sun, 10 Aug 2025 14:50:05 +0000 (UTC)
X-FDA: 83761132770.23.91A58BD
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com [209.85.166.71])
	by imf14.hostedemail.com (Postfix) with ESMTP id DE709100003
	for <linux-mm@kvack.org>; Sun, 10 Aug 2025 14:50:03 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf14.hostedemail.com: domain of 3m7GYaAkbAKweklWMXXQdMbbUP.SaaSXQgeQdOaZfQZf.OaY@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.71 as permitted sender) smtp.mailfrom=3m7GYaAkbAKweklWMXXQdMbbUP.SaaSXQgeQdOaZfQZf.OaY@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754837404; a=rsa-sha256;
	cv=none;
	b=0GbUGJ5Fs0susOuiFErlZaSJCicxw88HLs5o6D3loRysNVY9Ph1Pd5vEcfwRikZHtRvK8A
	cHbeQsnDrrnzqiPyka5mwSuydOWrw7xum17mZ4qzlQup3FmQ+LfI0cLfzkgqANdXnX8G/P
	rULrwtj88ZXrp3GHDhd2eAnWodHHgu0=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf14.hostedemail.com: domain of 3m7GYaAkbAKweklWMXXQdMbbUP.SaaSXQgeQdOaZfQZf.OaY@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.71 as permitted sender) smtp.mailfrom=3m7GYaAkbAKweklWMXXQdMbbUP.SaaSXQgeQdOaZfQZf.OaY@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754837404;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references;
	bh=60eUBaP4S1YM8bshFqm4Sr3laTofYKn/0WXOd9xAoMg=;
	b=AR+RRx4uT1s2opR3YSWwesfAKRFO5CurvRJv9IYYROnO7IiloJSb7jkqlR3cuhMvecrsRt
	sXhpDVRRQZrr9CRVsenhK+4DgoyoO9p23W9XDgMb+2FjHQwYSHlWS5U1xnkPV/XutMLO8u
	3M+3rnCDUaEWMnhXxjsnK3OPQYUCbj0=
Received: by mail-io1-f71.google.com with SMTP id ca18e2360f4ac-881814e7585so900824439f.2
        for <linux-mm@kvack.org>; Sun, 10 Aug 2025 07:50:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754837403; x=1755442203;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=60eUBaP4S1YM8bshFqm4Sr3laTofYKn/0WXOd9xAoMg=;
        b=btXXL/bhwCbNT0tYiHKy99/fVIlgR07StLACyVQswVwQG9EMyNsFLhHCUTR4x7p1ob
         nlOBY6DX3mllq7McUOEUkDR6qyTMAOEBfmypBqEYvdNac4fdbK0BOwgZM0m8gsk2RP0g
         GVt4gKaVwROFvb2r0p0mNat0xzC8XD8emL7DXyzxNkwgEEZwQ2fFY3VzSQEJgQvXjWGB
         O+En4eqxkU2hCcsupcbG/zjGFYo29ABNNWnqlMUZGAi1v/6Mv4SO0AC6oA03CBnksKp3
         AIr6C5y6jQlgM1MggFV5x9Sn9GyUUwBnVKiCMz1a7+86Ygcu9x8t77F2l8vl61pivt/i
         pbLA==
X-Forwarded-Encrypted: i=1; AJvYcCUWZCoOSjCuzK++gYiGAgmoiGx58zzEsqWxNIZvL2wdGl0rXAFtZ0QsnY+Z9LRO68/Qq+2+C7Xx1w==@kvack.org
X-Gm-Message-State: AOJu0YyjAKk701rq4HPaImj8S4V4H+aXiT9DuS4QewXAUJzyx6rvdbcm
	XlbM2Ej5NChv+a1kNZmLrhS9kQw+uGM4FbYZOnlwrDJ6Aj4qM7oCl+z7AA72BGJwYEpR7tU8W0P
	YpiKwrRSIE6o2qLb6bWlAnp1+2jjVHkPMfrjXBDlmGxfcx0TUHIpkHjNdI9g=
X-Google-Smtp-Source: AGHT+IGf9Dq1NnHv965MWqAJj5twYpG+w/zwXyElvrhHtv8GVEAHg8eBNnkmhJP75MeCWIFzQEBVoBse4UZb0smPCb1kIzGobyZe
MIME-Version: 1.0
X-Received: by 2002:a5d:9ac1:0:b0:87c:49fe:cafe with SMTP id
 ca18e2360f4ac-883f1255323mr1470374339f.11.1754837403031; Sun, 10 Aug 2025
 07:50:03 -0700 (PDT)
Date: Sun, 10 Aug 2025 07:50:03 -0700
In-Reply-To: <6897b156.050a0220.51d73.0082.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6898b19b.050a0220.7f033.00cf.GAE@google.com>
Subject: Re: [syzbot] [mm?] WARNING in try_to_migrate_one (3)
From: syzbot <syzbot+63859a31071a369082b1@syzkaller.appspotmail.com>
To: Liam.Howlett@oracle.com, akpm@linux-foundation.org, david@redhat.com, 
	dev.jain@arm.com, harry.yoo@oracle.com, hdanton@sina.com, 
	liam.howlett@oracle.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	lorenzo.stoakes@oracle.com, riel@surriel.com, syzkaller-bugs@googlegroups.com, 
	vbabka@suse.cz, ziy@nvidia.com
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: puetjat5ihthnwrq8yu7fb87nq8yiqfe
X-Rspam-User: 
X-Rspamd-Queue-Id: DE709100003
X-Rspamd-Server: rspam02
X-HE-Tag: 1754837403-57970
X-HE-Meta: U2FsdGVkX18k4/oXfcrKEE47f/DC4Mh0c1gLkCOGZFGr7YhV/FK+BzHXXf7XGM/mCbLAbFS6mCWe8Z3vsIi7+MhPYYhHgk4KLY+sixPZHGLSm5Fi5QxClxBSU0pIJnzgVBsGoYmzzRhGepILwPUa3wNS/1kckNxiCR/3rBgR3tcIocn0B0OXy7iwSu8ALRr6hURrLM/h/W02j4PibEFy2ccy0u9x+EQ6SUZ/PJ9WZfwydjvBLj7CW9LPAmjD9EejNy3CSaH97yhm8bKZqgU1VcWUaT1tYyMNZiAS/IpdF7nxmr0/Z/Dyf+R2taku8MEUDEN0xwfq/auu/DfrY7Dykv0Q8DTvn4s1bQn75A82//0NHoZ0yEYH8yArNA1gXqnUFaVPtUDDcerEnOLkbPSWNWHqEkN0h+BGVI2yaZ3YfPHBaQiXhSQs1iEB2V45AotkGdNZjTVVYT+uOlWEFJ7io5drrNwLeaOhEZPvLvXhhy1ZWpev2bTOuSXwXMW78547TRw3g3OrdmfdAd79ktXRdOEIY5TDK6OPe71edcRXtIlfsDOMAV+dvVdjs3lKwX8HWIySLq6Gw0iETDWBUao/XiMEUM5mmdqp+QnR+XfHvo4+egHNRFRQ/TmRfIr3NzpwLanTJzFxlQEhHPV8fCNSSJMvYU43dcyZEAHlq1+bMtMyEABEU/tVp6KKki62dNRIpTvfIsSIZ5sZSou7LLcH2fcwJih6E89XdcA8VEdq4NaHsXpviJx3aEcPRmlMGDquSa0vjSi2lxQ2wxnl8kwuTL8PTGFubUvEDPUwIMMWvL2xK7WZZ1luXKyzz8dlc9nbxOrglnBlU5B5BFrJw5Ax0gUJqZ3Pfl3mTJbW+f2EnnKGfvpbo5+rGrgHglyyUHdzXTomR4UCHhaUtOkA/qn0/HJ4n4OYNodMFGXpBvJFAHj17s9S3r4RyPq5kcfF58/hJbg/+tg/fHwVz0Pey3c
 98LakwG3
 VwUd1R2B8WrEX4/fONF0p41XrhdR8e7tOuvauQn7ro0zUu2QY8J68QNtJrSpULg9FzUfFTk6ELLT+m8pvhuLvb9OSuEsI6Wlo2H65BYjSdlz8+DiqKuqD3S8Q0CZaOQyV+xXhxMATyrxjUMLQUiEkOMCfJKA0CoKONgwl6QXTsx8nee2RQcI7Mnjla+tPOwGfjJVGkq127/7ZA6RnjFljOzZBeosPCXrfAXHAQdBWSJ9b4OE/flKO1ydYk+BdOEdPHS3D4mf3m0qjarwUIj4MBLpnbzZGNLxEyeTSjbXXLU0cwdjKVl6gfhCNgbO1ReUL/4e5i0ISoLDxS83bU4hgYa6V9lDVs+JEB4wDhUc4Ov0hHXD9Jb7kVg7ecr/9GFCQmtnLWbogUmm1HWnvNoooEkPdz5PdlWVajs8LeD51ZgS3VtXOQ/tXiPrgdvrdTnB246GLxZ/Ygv/fwUajzhtZkEPXr2jv30xkYhT/NK9pBjUE3th43VJZBInSof4K8rvqTEAAj/UWbHrhMJJCSoGgKHzXKk/B8z2nubD8tFKzoCdathjyfdkhcyzI+duY3JtDaDHJru2qjNfPVF8JcnuudpROeHnPNA0EVrnFrIeyC+tEbQ9XXA3jSvwwhcbqQDFQpE/duMyu9/NyhZozs7TFAhfzER/fIors5Wfn
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

syzbot has bisected this issue to:

commit cac1db8c3aad97d6ffb56ced8868d6cbbbd2bfbe
Author: Dev Jain <dev.jain@arm.com>
Date:   Fri Jul 18 09:02:43 2025 +0000

    mm: optimize mprotect() by PTE batching

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=12ac8842580000
start commit:   0227b49b5027 Merge tag 'gpio-updates-for-v6.17-rc1-part2' ..
git tree:       upstream
final oops:     https://syzkaller.appspot.com/x/report.txt?x=11ac8842580000
console output: https://syzkaller.appspot.com/x/log.txt?x=16ac8842580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=2ae1da3a7f4a6ba4
dashboard link: https://syzkaller.appspot.com/bug?extid=63859a31071a369082b1
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=117c72f0580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=17ab7ea2580000

Reported-by: syzbot+63859a31071a369082b1@syzkaller.appspotmail.com
Fixes: cac1db8c3aad ("mm: optimize mprotect() by PTE batching")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection

