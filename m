Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 286C4CA0EEB
	for <linux-mm@archiver.kernel.org>; Fri, 22 Aug 2025 06:23:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 52C27280010; Fri, 22 Aug 2025 02:23:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4DF8D8E0056; Fri, 22 Aug 2025 02:23:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 419E9280010; Fri, 22 Aug 2025 02:23:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 339038E0056
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 02:23:07 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CFB4A1DDD7B
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 06:23:06 +0000 (UTC)
X-FDA: 83803400772.02.172B686
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com [209.85.166.199])
	by imf12.hostedemail.com (Postfix) with ESMTP id 051904000A
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 06:23:03 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf12.hostedemail.com: domain of 3xgyoaAkbAMs9FG1r22v8r66zu.x55x2vB9v8t54Av4A.t53@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.199 as permitted sender) smtp.mailfrom=3xgyoaAkbAMs9FG1r22v8r66zu.x55x2vB9v8t54Av4A.t53@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755843784;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references;
	bh=3ZHetISihCQ31cAwVL3d64sT4gcaGxsiZd2b+58jwQ0=;
	b=E3809V+J9LYVZ6wRhuLSx5335ZZKezvoXHdEk8MLcRWgcPuz/FuoKdMNwV6wax6WeFrzoN
	PY5W6DeUeH50Yf0fJMpq0Ye1zdYSsy2doW687beIDlIwdMrA40aWjQdL9FS0i/P/cihTbe
	+csHOxfIi8Wrh0gdYiEXUssWID8Sy/E=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755843784; a=rsa-sha256;
	cv=none;
	b=owg7Qy6SsKBoE6QsXeFIOfuM2p1aVhP6ME0zSJjseMmxJkGEXaEtNje1FO+h1uLC8+DEbc
	aO5OtEDwkIRx890nuOLvT8E42whfdS5kAkQW5cOR3bqwYtqkqBHfCjBJXks5pvkahNAnBS
	ZVwXRcAjb4Qhcq5eenZb8bWa95LDBIo=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf12.hostedemail.com: domain of 3xgyoaAkbAMs9FG1r22v8r66zu.x55x2vB9v8t54Av4A.t53@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.199 as permitted sender) smtp.mailfrom=3xgyoaAkbAMs9FG1r22v8r66zu.x55x2vB9v8t54Av4A.t53@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-3e6e61caf71so37026135ab.3
        for <linux-mm@kvack.org>; Thu, 21 Aug 2025 23:23:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755843783; x=1756448583;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3ZHetISihCQ31cAwVL3d64sT4gcaGxsiZd2b+58jwQ0=;
        b=fMOzugvtKUETxe3138yZDzFDHbYaTzgokHfHiKKTF7vbyVifFgaSbdCO0w3C2QlKw/
         Mi5j8Y7WzJ3cVblFjT+tAvfK+DobzaLxAtW+VLjckEUZwJsWLMNkRxXnuDnWHA4Jgxwz
         DhPXsjbDGRk5v4m9375t0UI+PJ8ZCsf7m7Tf7uKn8J7EFyVcSdMSM/O+ORoBcLMKtZcV
         UPKsU5OIOG1p8Pqv+GIOGA4M4j9tt8FKQgTATrDnjgzVbTDgt/24VNB3wd+2+Ct6YGgk
         KKQud/y6S7WtxoBxq5FqcxEvLz+5oPrstOT/slC0DFaA35F7UutRS3PN/q1LMAA7MjhV
         57aA==
X-Forwarded-Encrypted: i=1; AJvYcCUSw0aB+ZMTAvvdyXGWOUKkTO4zTjAaIDoSaFqVCFOXqpbJU3so+GRzWOomDTMBtIY4oeM3H2x7kA==@kvack.org
X-Gm-Message-State: AOJu0Yxy1/QVW/6h2ZAF77DvPwaVzi+494XSEvlV57h6WGXyPgdIiFOU
	Be4l5tgWqibER5SnrjI2OCL4l6gnR/hYEZIyVzXSODL11pWhc7wU/+7nt9Q5J0vl2EQuP6NHnrN
	5pT90xxQ+qU9APypLiX1h2FLh/J5bLDSQYdGpJnV2xQG/2aG3nF+hfSqPxvk=
X-Google-Smtp-Source: AGHT+IGfiTLDD+d7klCLoJzYIf8E+KS4WHtq3xDTk/LZWiWog1RDc4Ab+uSsBgOp1NXv34WmMyQ0E8qXJWMxaPzwl+nkO6k3bol3
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:17cc:b0:3e5:8249:e973 with SMTP id
 e9e14a558f8ab-3e921a601e6mr33646425ab.16.1755843782954; Thu, 21 Aug 2025
 23:23:02 -0700 (PDT)
Date: Thu, 21 Aug 2025 23:23:02 -0700
In-Reply-To: <02587840-3222-4dc5-b039-9084d8a5f37d@arm.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68a80cc6.050a0220.3809a8.0002.GAE@google.com>
Subject: Re: [syzbot] [mm?] kernel BUG in page_table_check_set
From: syzbot <syzbot+49a796ed2c9709652f1e@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, dev.jain@arm.com, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, pasha.tatashin@soleen.com, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 051904000A
X-Stat-Signature: 7ki7j3i9tebgn4753auj9655ai4ihkwg
X-HE-Tag: 1755843783-258900
X-HE-Meta: U2FsdGVkX1+Zi5MwQcBm3bqtnxU6HUhlwz3WBobyeOWpm8Idn8DhXLtS2+gvrKlSOvSx7cKVbGkFWVmFI+L/gjQXRDqv6i6tZTg9FEIZR3RltwbRTUheT2qcF9CSghZod8r6LJxO7X5YWJ2ceZ+t32jbMlQ7c8AQdvppfXNjOG41aSC6jXrISnNC7LLbDhUcYUhyiEy8+7oEAhPl7U2XmtvP0mwOklTB29pH6Jv0ZZI0AsIc3dVURABqmeqP4QcX8OHUHU/H6kOYrNfby5m2jpDG3I3ctk9ltgXVBe9HuRiP2StwCG7nr9F5Oyo4YIZ6JHPO5KB+UBepXBo5AssfP2xQ5CRjXves1CwM/TVFC6jx1s3esn9wpNLF2Vy8D2SvOX2t5RoZWjE1jlrliTXto1j6h73vURLKRr35/GsRBR1II3b+AfJCgtkNbaS6nrY+T86EPGX1IL+0E7fgTyDzHPyxWADAksPPy1sZVvBKAtm6JuERezFCZHsHCaG52LDxM+K3pLekEVkx17UeEqdtIsdddBqsinasO2t7W6jBDaH+zDQPd48jRH8f86bs8pl7eZjrY0Oh+scUXDixbYU69kxdEQbbL2ZfBiWr54IXzx06JBiNbL5f0HEFNTmB1Mafg3bu9z+4zmQWfNXUnGgn3xw9BedbHB6mAHN03H4y3xwtmuBFlumQjgKYFUEkiHzaJaP38A+pOGE+FUwb1JOv/dQti0pgPRi8jqN/Q/AYkAxEFs0Biqxe6fi+aIwILYqij7uVTWTpY3F2ro8MIGatfBPVtAO0ueaWF3CdkUAAdeRv0w5mV6MekMpP+a/nCW7+WvPomtnF+5teNt/awmuLgn7W+vOT3sAe7HQAuy0oG/IDV0lnZ2/KYQbXmS9e3yOttoaZsUQwTxdRR31Krf+D9PdYSA2rT4vSGbx2lOG+ES2YWEAwD78P4DZNdpXGOef8WwO9G6pbPUnqjDsyQ6e
 vdda3o8u
 FjRBQuRXy4+E+Gz01jKCyb6AAJtWmQB5DOGXVdJMDk8twR0KnVmxx0dLxJ36oksKDUxMw+4rHkYzq7IKjp6IvSpYS7cDItA3i97cT68dJ1CtV36buG7HStATokmbgtNgMPO9st3ipR2qoGkjTAtpg42TwZNVxzJHX2hEVoDVK6KHee/cepc88HtaI09r9ddS3DWeQGKHbc9qHPrj+nxoyNYrDMkEgiLZLokKyRXuNarfmOZOL83h+XxA0xX3kI4LjOzIP2lFttaOBOLOUKzJmHw3T3d6hs1qpHT+Uwh/mUrE+CkAoCinAmTKusKAC8vU4NDP5awmLV4H6GgwPj+D68hH3lmBUFSPvEB2cbvncxTRfnOOKMAPeIBSNIUbtfY6L1ctxm01bfVs7ck2ZEmuoLMpAdMtQZSpAW61UgKOK54Y5+Wbi7iy25ecTzU3SoAHe43Me5TdenWRZiNDtParAYmXHpLw1J7eQg1Tl2e2jqqIwmhfhq2j357sxaR/QZmvrPv0FQgW7ylT3LQoTxnXfYw1KHRoGMiME8hhG1MRlsrvn+GyX91njej8HauCBsdh6p4pf4qwsiwK4/KK7TNnkLaUIOgYljn1OjindWvIVEW1OTb2nPHPfZuEIvdhowNMKBi1of0OUTT0HvXeTjaVZk1NesiqYPd5qBS+xNplDrELSV/a/LXe3fl3AN2VWLNYE1d5ztmFnJa3pREc2v0BOWiGhZfxE4glv5JgPsaF7iXvZypY3uSyIpJzuNbuvpAnOVqolIrHoC8dudwnLXSNzGQbO8eEWuPfDUSht8NBuXJhLnvwG3e0mynAp6LzDgrQvLV7ECUlW4lL0xEGELAr/jc039gmNqoAa20qDoNrKvyGBkDO2dXhNPoY347z6gD7OiYCSrLs1Mn3B0t7Ix1S7o3wfvhpdZF5Vp4ubl5IgGdQMWYvaoyOEFNaEefgxFNxMlyf9aM4+7DBZr3Xv7xT5mWxyhHNx
 W7bhnxF3
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-by: syzbot+49a796ed2c9709652f1e@syzkaller.appspotmail.com
Tested-by: syzbot+49a796ed2c9709652f1e@syzkaller.appspotmail.com

Tested on:

commit:         cf1b80dc mm: pass page directly instead of using folio..
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
console output: https://syzkaller.appspot.com/x/log.txt?x=116576f0580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=dd02560acf543b19
dashboard link: https://syzkaller.appspot.com/bug?extid=49a796ed2c9709652f1e
compiler:       Debian clang version 20.1.7 (++20250616065708+6146a88f6049-1~exp1~20250616065826.132), Debian LLD 20.1.7
userspace arch: arm64

Note: no patches were applied.
Note: testing is done by a robot and is best-effort only.

