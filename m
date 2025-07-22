Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD136C83F27
	for <linux-mm@archiver.kernel.org>; Tue, 22 Jul 2025 16:22:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7C3606B00A2; Tue, 22 Jul 2025 12:22:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 79B4A6B00A3; Tue, 22 Jul 2025 12:22:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6D7EA6B00A4; Tue, 22 Jul 2025 12:22:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 617C66B00A2
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 12:22:07 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0CF3C80484
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 16:22:07 +0000 (UTC)
X-FDA: 83692417494.12.33E61AD
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com [209.85.166.69])
	by imf15.hostedemail.com (Postfix) with ESMTP id 57EF8A0008
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 16:22:05 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=none;
	spf=pass (imf15.hostedemail.com: domain of 3rLp_aAkbAGsbhiTJUUNaJYYRM.PXXPUNdbNaLXWcNWc.LXV@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.69 as permitted sender) smtp.mailfrom=3rLp_aAkbAGsbhiTJUUNaJYYRM.PXXPUNdbNaLXWcNWc.LXV@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753201325; a=rsa-sha256;
	cv=none;
	b=8oeguRetAm8KjifSrUDdzKpvufNxpJLXfaYJLA46lUSiNqUmZOIzG5TN553CJIxCm/+hUC
	795t6McoJ0znXyV1YxKPex1tlFU9qoL/fsKIRSXJACs2m3DwFL/oo7saXIdTOoNADbA9la
	faB7JIWtwOgXe+EhjSG0duEEJGHEoa8=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=none;
	spf=pass (imf15.hostedemail.com: domain of 3rLp_aAkbAGsbhiTJUUNaJYYRM.PXXPUNdbNaLXWcNWc.LXV@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.69 as permitted sender) smtp.mailfrom=3rLp_aAkbAGsbhiTJUUNaJYYRM.PXXPUNdbNaLXWcNWc.LXV@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753201325;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references;
	bh=qKcb9d5VYbBm3vwRPDTQMq9UG6EGDzgJ2Zl3aeuMVAo=;
	b=ddtnEw6H7k2+e+Mwv8v7bOV3+zf0x9Ftw5/YYK/l+FGY+RHDTWUuuzIwyk+nt4k70nUxPp
	j/WKWOKi4bdr4zcYGHJkgk80E3GNUDLx51GR60u/Wxc1plN6trqoIv4xzqeyyHkBxVUDyN
	DVdS+vCc9+J1VPsxnc+UcSkoXVe5VzU=
Received: by mail-io1-f69.google.com with SMTP id ca18e2360f4ac-87c13b0a7beso397707939f.1
        for <linux-mm@kvack.org>; Tue, 22 Jul 2025 09:22:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753201324; x=1753806124;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qKcb9d5VYbBm3vwRPDTQMq9UG6EGDzgJ2Zl3aeuMVAo=;
        b=LLQcV8MOcAo8IZrV9uySveOsgR2ifAurfmWF79opIpaa0liUGP0Ribp+VXbZRoxM1i
         8Po46C0Hm27GhNC+w/XSCjTZk055mz6BeXBfw/+oC+PxNPj/XqHbspux8HpBqjnEo1I7
         bndfoLPZw16MAeo08RYeuSIVBj4RCL4KLP/J6m+1vy/ODLob/9sJ3By3Ynfmw2jYrTvV
         ZRmI74B92xtqyYaIk0sdRWnqJ0ChNTLh3tNrPEXOfRDOxQaf3pZMWUYCBIpt1eb55Q9N
         DJ172+5IoGnYfi0bPM6izcXQH4SQuwCXTWYZOwjBdYNySmDPzs/3Enqut/LsRTyOA3vf
         UPsA==
X-Forwarded-Encrypted: i=1; AJvYcCXY7UnhpOV603La4dluL9eGZdLP4dmN+D+i3AAhNpb6IBWU1iNKNs4ezGvKr01WFiRPUg5dHwASKQ==@kvack.org
X-Gm-Message-State: AOJu0YxPjaClbV/SIMFu/AIY1VqNJzloNvV99j7WsrBbQfhGco2RYehw
	kl1pH1d9IG3iPC1ZgjWAKuL2n0VxfscwBQSB9/6h+hW47j1pt4a/S3kFq8S1xUnGFXESwgxxPhd
	LfSRwplIeZoJbu2RDqOLeDhEga4l0qIlQZcRtvZ7Kmge3Twd2eib5sHlmNz8=
X-Google-Smtp-Source: AGHT+IEjL1mozCzBJQRzAzQ5dF6Q5DIYhGWoBlkJ4tgme0WaCm0pYazgz+pZKutlxb0ZteK9vhhdO0FWAt7myt02kxDMYp52slTN
MIME-Version: 1.0
X-Received: by 2002:a05:6602:1348:b0:879:66fe:8d1e with SMTP id
 ca18e2360f4ac-87c0138865bmr3099989639f.8.1753201324361; Tue, 22 Jul 2025
 09:22:04 -0700 (PDT)
Date: Tue, 22 Jul 2025 09:22:04 -0700
In-Reply-To: <4ca54a2c-46c8-435b-af72-7f871236eeb2@lucifer.local>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <687fbaac.a70a0220.21b99c.0010.GAE@google.com>
Subject: Re: [syzbot] [kernel?] INFO: task hung in exit_mm (5)
From: syzbot <syzbot+1c6607097b258f18065c@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, brauner@kernel.org, jannh@google.com, 
	liam.howlett@oracle.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	lorenzo.stoakes@oracle.com, mjguzik@gmail.com, oleg@redhat.com, 
	pasha.tatashin@soleen.com, pfalcato@suse.de, rostedt@goodmis.org, 
	syzkaller-bugs@googlegroups.com, vbabka@suse.cz
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 57EF8A0008
X-Stat-Signature: pgj6tp14gmtfg5cy1mtw73dhs1d5jhyd
X-HE-Tag: 1753201325-44581
X-HE-Meta: U2FsdGVkX1+1dQ1IKmCn7L0rdNqZIQ86o/qfKEdrUlynm5wTstg7QJjyjCgqcnILbe0RIONfHLn+Wy5vpy8IOTvzCN0YpWGetsRH5agzQx5z84Q7o2j3CjUFbcKUhV0RAzEO1AuUyOoPkn3C4d4lMdG0FuLhUeF1tmEG1lSCeQH7nzrK4/DFJwZ+fMr7EEr50p1QIwa7DQMe77J5Xugf2QZA5y7sqi2KxmyMcwJ6a+0nE7RzOCAo8hitAoXBe/JYnZuWLcJL0irLXMiPq8zRalJT43weMMyMHBYjAkHi16g1vh6Xqbsh/uVz6CJiBbB2CBDFRYE05oNncdMVlczehMY9CSmfvn107SYY8Y2FZkA/5ApcB4RmE3TPKtbSwjlmB3C7lxmfVU0RfiWRQiza0uRrfm0CQLqyJTHaStEnshGiQYATinEzWnj6BBAVzqES9/scQ96py1ghL514er2ubLET57HvEQ4Cgxc8vGOlUJDT3ZN8rRZ1L3a9rm5ANFUKZs5bRltFtxy9umAPiMFsYtIBaGzgYFJs7oCmsbgbCyfjwhHtpt8I3Ua2MKJ/kVECrA/NzKSFyE3s5Zso3heZxsXafsSgVvnT9fcbieULNf7aTA63P8eKO2BA6WxWBiYro/Pcj0EMqGUp5eTTsEeLCXIIuLpNbWSAFE2tDuDG4Lcj7HoMquA7FyZjlyU2B60y0JydvRAdph4+N1qlvwd46xvbu1eRvjCYSWtTFIyanmSTpzkX2tHUF4kHwmsnBoax52KYtqyH9jXRmF59KIiUjCMqIn+vLmS1e5uJn36ilYPnxZYvdM0Tb96nudumdFt+we1+bGfaC8xxww3lB7WX6dj4X5eiJw26L670u3KVM+OSdceHENJVjxEEKydcO1N42d+kMgaCPampQKD8hiEP9cxOuTv4QGUOPwcO9JPhkTthU85cW1cTCdPEyZoGMiGx54M2PqxHNcVsJYbmIwy
 cj7ckN8s
 74DOqBvAnWSVSeUwTnqFTaLMR526lSlTLekIvli9WXFyt4/ktPGoxY5Z5DNUCvGje/Ky0RNC7bsfLQgciMUxqgdJTjldHZEa3Lv3yvhPBjJVesVGnu9Wqi1R4ygYlUAe5AqjiM+AQPfg4Yy6bo/WCyOB9+Jn2MigRmgREZ8o2kpQMdxZ7ZLzVYIMRbkEfqWNREHwtqY3eml4q9479gslyud6JsuwzNLBzKh+4eZS/SA1Xkrd6QVeWp5hPFwaMRLR1hp2K3hNzLnVYZsMhFlnXUuvcYIKMEfjtFJgU2chgqma3rPf6x9xmeetdc6mXTYVpFT6QfJyEU+ZyWws1RBJoUtpIVHZUN/6cCL0fqK7aLDDxkiWlAaAExsGaXhz/WXy5rxe3WEHwhZ++3eTTZh9X+uaVi/PL+VZpWV099O/74hPKIaVby7GGFh0GnqDPXcB/8GV2q7tGXADWuQ9xAkfS2lnqA0vw/ibWDWiItigruATyxyavpkN5jRVPxkg598xvXWql0y/r9kkKm/MYcf0qxzf64ESMZxSpDoprzEVVEHy6qq1Duidn9fmGq2Dy7DST53Nm5gbKdUCD1k7Cgo4PkMxjslaQCrJCJTh9OPfENh4unEMV6RDjC8AOcglsuVyYJNLoAUcJXaubKG6hvdc2aI5Ev3J5vSMN3FS4lpZ1LQD/q5QicZbbAXdJfFNk4FSIR62xQI4Qg0cfrzEQJCs0LTdTrwLcODYD1AKtzA0UT05SPTHvxkik1uL5mcWkbqyLi+9XnDA6HcZSmOljbHq9gtn/8WaDu12AioNRFNKHBxuGE5Ds022/jFrPB1MJ4+/mPb7i+PPgNV661OfhcphaYYNDHQ5mAwICWFu/XTeRXIs8cpV4MY1zcD682rVWkoPZWvu9ZEXVCGHTKpe+kkOWXchAxn2iHx3lF6cI72Xyxcbs1+2ytSUDbzBGNZQMpo4vzcIVLb0hTimOOjALxBZcFdgxcpCl
 Ojw5SKsX
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-by: syzbot+1c6607097b258f18065c@syzkaller.appspotmail.com
Tested-by: syzbot+1c6607097b258f18065c@syzkaller.appspotmail.com

Tested on:

commit:         b659a6dc selftests/damon: introduce _common.sh to host..
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-unstable
console output: https://syzkaller.appspot.com/x/log.txt?x=171ecfd4580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=7e150e8ba2089ab9
dashboard link: https://syzkaller.appspot.com/bug?extid=1c6607097b258f18065c
compiler:       Debian clang version 20.1.7 (++20250616065708+6146a88f6049-1~exp1~20250616065826.132), Debian LLD 20.1.7

Note: no patches were applied.
Note: testing is done by a robot and is best-effort only.

