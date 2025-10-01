Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EE9B4CCA470
	for <linux-mm@archiver.kernel.org>; Wed,  1 Oct 2025 04:51:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 539D98E000E; Wed,  1 Oct 2025 00:51:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 511338E0002; Wed,  1 Oct 2025 00:51:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 44E118E000E; Wed,  1 Oct 2025 00:51:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 338BD8E0002
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 00:51:09 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id CBEB3C027E
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 04:51:08 +0000 (UTC)
X-FDA: 83948321016.22.A9EC6ED
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com [209.85.166.69])
	by imf27.hostedemail.com (Postfix) with ESMTP id 2D0F140002
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 04:51:06 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=none;
	spf=pass (imf27.hostedemail.com: domain of 3OrPcaAkbAGERXYJ9KKDQ9OOHC.FNNFKDTRDQBNMSDMS.BNL@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.69 as permitted sender) smtp.mailfrom=3OrPcaAkbAGERXYJ9KKDQ9OOHC.FNNFKDTRDQBNMSDMS.BNL@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759294267;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references;
	bh=lAhA4miFvnKiMwYobzKIYJ1viibUSiXEfKDDH1S55ek=;
	b=WIgAECqjNhIPWIcPkSThHA/NNAfVgGscHgJeu6vn4iqT1vAZ3kUGb+mKYbJvOUB7EQ9SW7
	5tT3sNpRqNW3Ukcerdj673lkIOVXuzbz7bhfRrqv9sWyS2QtwU8EDrq/jVylmJkoe+/t+j
	ICye/NW8dwcftGvzDI5Yjd4rk48AOzk=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=none;
	spf=pass (imf27.hostedemail.com: domain of 3OrPcaAkbAGERXYJ9KKDQ9OOHC.FNNFKDTRDQBNMSDMS.BNL@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.69 as permitted sender) smtp.mailfrom=3OrPcaAkbAGERXYJ9KKDQ9OOHC.FNNFKDTRDQBNMSDMS.BNL@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759294267; a=rsa-sha256;
	cv=none;
	b=rhCgNjFMKgSG4q5SthIJRM2GAmsmlCeZUlxQzz8yvyj9apm/vRiPASF07KIUw0m7fxRCWU
	6d4j2BtIjGBYxZW8YxxGpOTPU5R1KISxDjBYhvMnwX/YzmNAmS3U69sCu5Wz81RCaUHzdh
	BP/M4WGPH2qxYjGcRi5JWZKTL7sYAXo=
Received: by mail-io1-f69.google.com with SMTP id ca18e2360f4ac-919d48f1869so894179239f.0
        for <linux-mm@kvack.org>; Tue, 30 Sep 2025 21:51:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759294266; x=1759899066;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lAhA4miFvnKiMwYobzKIYJ1viibUSiXEfKDDH1S55ek=;
        b=qZRWqYR3Pj4JAury7u9JItY2dMoci+5Wk0EO4gH2AfhVA3ZJp7R21sLbVV7Wh2LHVX
         KKR0QFETpoq37dJA9vlr2aETFtH+jZ7k5DzsLKhlKVggj6HMxsq53GM39t4IrvojGpFN
         57k6H2fXbIM8sSCfjBizFAhEZn5LHV1MFHg5r1HG/Ay6WUtfe53/+ebzn8I74u6v2Gto
         OqqC1m6ywDx60vVVGN1d8uw7plA5M/y95GPvUwHyeiRXcxzmWQIjJa5HhrJvhBQlD1qE
         xnBnr/gBAxxd0Rze8EAC5ofMWUv3LvZfuDJSCZKl4XNuOs820aKx+UjEQ94g4nYKhsRP
         Ntag==
X-Forwarded-Encrypted: i=1; AJvYcCVOjGaWP5MWKzzcwTf+x1M9wxvAtAk7jEy6RtrrfuZJFHzBYcOfacL2RCA/94AOclb1UL94ytLf0A==@kvack.org
X-Gm-Message-State: AOJu0Yyj6xgwnNjUecCxQuexQoLtj4ULAsv6mg8YOixGLYs1ioKesT8L
	3B0RgTagfCcegvbOxAhpjgxB+XIFumwGSFjhZgGrK4mSM9q92NjWQaaF6Q60ljT7Jp/Gt7dBeMG
	+b6zuTc7MNItU1DnsLwtom8kuzVQvvJ59W0CS0O2SiDmwnoqevDHBTakZBnc=
X-Google-Smtp-Source: AGHT+IFpxkpfvuq6u6Pm400EcvKPujEmJQ/w8z4AShfju1LNpMJ5s6lt4f2ylZv7zDcHLjEUmHnp7/zBrytIBZr6t8Ia+WLR/RVh
MIME-Version: 1.0
X-Received: by 2002:a05:6602:4a0d:b0:935:a475:d539 with SMTP id
 ca18e2360f4ac-937adb657a7mr362933939f.15.1759294266280; Tue, 30 Sep 2025
 21:51:06 -0700 (PDT)
Date: Tue, 30 Sep 2025 21:51:06 -0700
In-Reply-To: <7F95F86F-F002-4CD1-A5B2-4A261A9D1317@nvidia.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68dcb33a.a00a0220.102ee.0053.GAE@google.com>
Subject: Re: [syzbot] [mm?] WARNING in memory_failure
From: syzbot <syzbot+e6367ea2fdab6ed46056@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, david@redhat.com, kernel@pankajraghav.com, 
	linmiaohe@huawei.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	mcgrof@kernel.org, nao.horiguchi@gmail.com, syzkaller-bugs@googlegroups.com, 
	ziy@nvidia.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 2D0F140002
X-Stat-Signature: cu675aufawi553strib5i7jtyd59b1eb
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1759294266-240863
X-HE-Meta: U2FsdGVkX18dhGsqwDtXXR8dJHXFiGrZvq3DcGGDKHQtR9YkILNx9ohRnvy+TDhGNibDbkNuaxTuhK14/9oPBRv+NdB1KMdfrHGCZtBWzDtVU3WUdhMerLrNiQ40IPOCWVXR5+04qsz7BDN2YzdrS4qtXDEfbnGdeSox2VwBzg6J+dt/EKZENnL8KgqDaNrTcCnXnks02u4adxmTX2PtESe+nhB/LHUVnyu3z88a6TJ2mco/xu01Ij9t9zc5gvjSMgkLpIu9e8ScnDQrUgbLy2xFjU4df2Cb2jxZxHaIMff2JJ+qEBu866xCLarhx1vtx+lmCqm21vslSHjXLVMP6S5aOqmj7u+5iPHHWXy4K8c1FghCa9LKHN5WBTlB62QzzyQZg6woFUne+vApPPZN/2xBs3cIaOauTxZH0z2Z0AcgnckkOewqoy80aSK2GmMDI/wOgNvTCSUWg7MKwnCHLRoHjOWv+rVwGRSFZGFtewQw0WVY2+lBPSAmqBYYtLf4tB5bEQGdYSKtziisW7DKekLTS+Tj+EY5GsyChsqjURpIiDRzi+v9M4R0Ha4oMaDcrfMfbhgQdZMLHMWsPTAeQyTi/1GVliWIS+xEQ7VJJX0hhJWcqqEN39vz1P6XIgLx+R+7ptCYMOdz3fqudddeFjyQ5WiCw8MJNY17ky7KlYz4nJe5HSUCh7Uh3KaLsr68jHDS3EGFtqHhfX+lBDwsK8iNiUllErSe8JKyncnCSigvty7Cz/rVoG3WubTngCe+vrZYZOxurgck8TmjQyRabpnzfZDjhDYZwphZsDQv0g9V2vWLyl4yu82TjiSmxgL9uY6T2IlKmBwZKcZlpm6dosSlwRhBvQ5SmHPu5HZqs29WSbqODrbB0Wnim/X5fDHNEtt6CDxiJQ8MkCjsLzYqVYFwWIbkLcBD8hiCLMNNm4nhoNVnsvU7+FXa8J1fLMEwu6+xfXcsf+Vn0hsn11G
 Y2/V8JxZ
 MApOoMiGROhTahbBoY/veHT/SHvJyVLzmJg/m1uE5Jyr+fbpFjxudLTFjLXwZUodJLz/JA1mHaRqGurLFXoFAJL+anZ/3+twijC6pY40Zb7+yYp6XJ9+ByuzcV8SWMDRE+9AoFpvF22kQy/cKhN1J+nrGbJvdw4QNUS2MjRCzwaofGttEMixXsNAbO1tj0fN9/fXooCFxPkS7Kb1wCtqvOE6jT6tKzi/s5QEuggYP22XTYxQzfGX1gQIiTYbbAWhnFp1RDvYSj4td1SdMrP0+MBLrYXCIxBbzmh61H0XQT4fnH+E7Nzu/bI6RdgDa7t/uK7If+BXW/lWDJwIJdlHJ+NeJFL1W8/MjWxkkuaugGT1ccnZp9gaJguOQz9G/aWGgeBTxha6EvlciaMBwPzKRKV+9qNcoVjUHAiT+D0SVPqhzJqUqRPu6ehpFSfKi4mgc6s7s4NsKfbe8kicPiXf00oxwE7gA47DK8yYovowD1YzgwDn/lymb2QvsIIT/+CSfKbJVnc9RPUYJIDYeJVEY+hFSyHQpvBagOtHjBPaC31zPoBvu3PMMfJDqTXc5azPer7NXB7e2lwzHr+MuszoCkVb12DtxglcWB64jj68PWX/2lEzCuZ1KfCw6cELxgwpxRBYrzIVhGitJKdWqnKtBIY75v/4T80w3N0ZOO2UPMcp2FakD/RyhnVyYECGKfXWsIfSnc7q8C/78pYxJfGuG4xnrJSX0UPepU5L9G+58GspRg7jh8SW1qNCGnBJmS17DYVJEPqAhs1/tv6c3n3eqbWkOHEjRooxcZPnluiS+Xmgd65zXgIiERp3Wy8lYXv5s5EUs+LzXsggN3I20h4Im4VFrZ0iR8ESp/IVf/Ux6fz51qlrJxAAgsNRRectRPWm62ZeS5xvcLYfWxQ7rVrUCvgamrlER+EubZePiE0KwXonn3+b5Sc0tA8CFg45w1EXOsrpYUvCZpagmopWEhB6YdyzY8Obn
 TGAtbMWW
 9xn/9eNInqyPdxNCVMq80vljmf1D5u5nCCQmXW8WkAE6sLEaeAIx84M871/w9ftVApdVFk/MMpUxJoZc/OxjdvEVexFTlPGhwGp9jQIlZ+jXE4wYzMWLc8kli1kYb3Nj8T4JQ1SrbNr4J1HKONxQkMEtprrTs+rUsXz2YopTBTk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

syzbot has tested the proposed patch but the reproducer is still triggering an issue:
lost connection to test machine



Tested on:

commit:         d8795075 mm/huge_memory: do not change split_huge_page..
git tree:       https://github.com/x-y-z/linux-dev.git fix_split_page_min_order-for-kernelci
console output: https://syzkaller.appspot.com/x/log.txt?x=17ce96e2580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=714d45b6135c308e
dashboard link: https://syzkaller.appspot.com/bug?extid=e6367ea2fdab6ed46056
compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
userspace arch: arm64

Note: no patches were applied.

