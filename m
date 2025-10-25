Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 92CCCCCD1BF
	for <linux-mm@archiver.kernel.org>; Sat, 25 Oct 2025 10:25:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B4DBB8E0144; Sat, 25 Oct 2025 06:25:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AFE488E0135; Sat, 25 Oct 2025 06:25:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A3B118E0144; Sat, 25 Oct 2025 06:25:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 9057D8E0135
	for <linux-mm@kvack.org>; Sat, 25 Oct 2025 06:25:08 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E47A113C6A5
	for <linux-mm@kvack.org>; Sat, 25 Oct 2025 10:25:07 +0000 (UTC)
X-FDA: 84036253854.19.626B389
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com [209.85.166.200])
	by imf27.hostedemail.com (Postfix) with ESMTP id 3B0A740009
	for <linux-mm@kvack.org>; Sat, 25 Oct 2025 10:25:06 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=none;
	spf=pass (imf27.hostedemail.com: domain of 3gaX8aAkbAA46CDyozzs5o33wr.u22uzs86s5q217s17.q20@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.200 as permitted sender) smtp.mailfrom=3gaX8aAkbAA46CDyozzs5o33wr.u22uzs86s5q217s17.q20@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761387906;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references;
	bh=nl8a1J72AG7zM7SUSNXLORvo2oDk1kEO1fKLciPWKe4=;
	b=xz/9YuPDDYcCR4Luu9wA+xF+kJSYwcmB6ENgkTEhpab3xwku8kuo0IPIiJhxzbc3FI3QyQ
	ZYceZCfnKopAfY63uknmW+Erc5eYJ/d5mEfHWi3NyW4Slji1Xg63fbnNMpmCDBYdLAmG5S
	PQKeWYHPHkt1wCzB7VRG/7ikYbNa2Sc=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=none;
	spf=pass (imf27.hostedemail.com: domain of 3gaX8aAkbAA46CDyozzs5o33wr.u22uzs86s5q217s17.q20@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.200 as permitted sender) smtp.mailfrom=3gaX8aAkbAA46CDyozzs5o33wr.u22uzs86s5q217s17.q20@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761387906; a=rsa-sha256;
	cv=none;
	b=7s8hu4GaXHM304cqrmv3Fl+oYfCare31bPaGZGbevPZ8O0kCFk35G0jpsglzB576jqkt7y
	iPLKA5tYLEF2DI7D0eINYNnP71bbtWj+cNZvEENW+68Htb4x0zikKPzklQ1poQP/JlhnvS
	hjG1xEPuP3KYhUmkJXGk77qIqeUPWLw=
Received: by mail-il1-f200.google.com with SMTP id e9e14a558f8ab-430db5635d6so36978585ab.3
        for <linux-mm@kvack.org>; Sat, 25 Oct 2025 03:25:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761387905; x=1761992705;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nl8a1J72AG7zM7SUSNXLORvo2oDk1kEO1fKLciPWKe4=;
        b=NWvlMgvaiC2v6Yzb8Miqm8pRd6+K1N4ynC4Ors3yKS2XODbv920dYHGtStXUB8DnOW
         oe5yRzp9U4/XmHK4BlEAcB3zElDAy5RkoUNlcNRF3lNp4wbLEmtDENOy1S32TWiaxQaL
         LXhnzFzvCCp49n8rKC6UGKzA336LI6QVjGX4M5DgMiUygqh2kbMBRx2OzOKNoVkxQ7bc
         CcpehruDqQisOAqIoYsBTzlf7gRmvDFJCTn/UfiiRUL9Jf+LgZPgGUCEA0eaMQJSmWyj
         x3QcoqC1jcFbURR9dmoOjE47kXzikrkE6I80uyX5vV5/w06YFE3FlhWVdlUAIrLlRzsu
         JZkQ==
X-Forwarded-Encrypted: i=1; AJvYcCV8wX3ReE+gLvJ6kn245Z1aGdLENrgtrIBicrcdHzqEHW3RKM3qGdfNn0e0NDz1DtkCALIHhKr5xg==@kvack.org
X-Gm-Message-State: AOJu0YwlT+4HuJ+EvB7Ee6hKCUG2uTkTQMPh6sTq9Ao7nvD0aaZRCxmo
	S2f6jPYtdrox65FfDz3rG6Y/xj+x+QYe1TOVzBmcSnKNTQLLHDxIwvc7y+kyZ8sxBrMxZyMy79T
	6LWxC4pHHmNvdnfQV8HW9o/xU3WAie2UmZwb5+IcewtK3yym0h89jUUlMroU=
X-Google-Smtp-Source: AGHT+IGDk2wO2iwRRHP1v8mBXNK6zhyVZ7g0+egqwyL3QpsaqGQXCdh9ghikPo44h1jt7+B6NN48A8ZD1fq2YaU1xMVIaGXcX/o1
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:12e9:b0:430:9104:3894 with SMTP id
 e9e14a558f8ab-430c5318de7mr404688785ab.30.1761387905357; Sat, 25 Oct 2025
 03:25:05 -0700 (PDT)
Date: Sat, 25 Oct 2025 03:25:05 -0700
In-Reply-To: <rdrijfoz5apghwj4zpymigdelzza4l3r5yzrwrpggd3nij3x7y@du4lgss3gexp>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68fca581.a00a0220.1c5a1.0000.GAE@google.com>
Subject: Re: [syzbot] [mm?] WARNING in raw_ioctl
From: syzbot <syzbot+d8fd35fa6177afa8c92b@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, apopple@nvidia.com, byungchul@sk.com, 
	david@redhat.com, gourry@gourry.net, joshua.hahnjy@gmail.com, 
	krishnagopi487@gmail.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	matthew.brost@intel.com, rakie.kim@sk.com, syzkaller-bugs@googlegroups.com, 
	ying.huang@linux.alibaba.com, ziy@nvidia.com
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Queue-Id: 3B0A740009
X-Rspamd-Server: rspam03
X-Stat-Signature: b3irng9n4sdmsrurb79wxgnkhnieip8u
X-HE-Tag: 1761387906-84240
X-HE-Meta: U2FsdGVkX185orS4yh2MqLLcp9Z9S4BPlzptuYPduMUq2Dfdg5Y2zdpqG/x7hlJfWx3BogTBdvYlYlyvHXk5A5+7ZN0UTaecLinBZ7GrOAMpNkS/slrVPjY8xqDLuGxjcj5afwLyBaiAe7rS37KvhLo92vy2WWh43mz6UsAVAubOA0/PYdVWW22lhSOcrPBmZeDqZ7NlfElMUvYJ12gg5nTiZtNIaIO5S3FGzdnSVUUpxdjyWi7ykEbPzi7TBYMZ6Y4uU/JzlFKQrBWTN5PpZ6iTA2vhfTjYtDE2TE17hWJTK7rtTa8ofnfZ3bwsEpVbGW7kI7RufmTM55n48mCJ1hYW2x9AKIp6iyuj7wHlCrkYtB61v3tjHrawPZIDpoROOaHXzMnbDxRpMCQBxpZGtR4KihZ0/EK395oH+qE6Hi53Our/CLT7EVQepHEtP7z/eLZIlL34Pnq4iun/IfhshU7XmS3BXvLJMSsD1GOisAEb+6cEw6D1mNkT/jBHmJOesKLuesO7mSl2AdGtaCcG9Lu5URXLwE+WUTUjag0/ILy5nrSgt6UnF5EhLS4hM+NNO3O/zZWrbuzlQkOKpU9bgfOlbZwlzOJUlG1TnLQ3qDCAC9qSrybz8teZOyJG8BwAitku0Yb7/j3iw6/wUgATtI6nkHPyiSIi/YSPWJIbogt4zh0TgZs+PLwD5TvZJj7yJiG+IL4fnXbkgVKgPi4SgbSzYLj5LeJBovyXVEfYME5NFlpzXRqJozfjxceAnGfgGzgBBrSBVe42cEF7fqqilrUVRZHC7nCdUkDxvAa0LzIXEJMonPofVy59JBzZZhL91BmCZRwO3XHQlvsnawQ1mqh0UjZhCAYHZvKAGy5KRyDKZhknwxU8rqTO47C04kKBONlIjCoQk1GWbfHGJwoAbK20v2sDYXsRVWcBXubPjgprUUMm7aA49nOUklv0s07Dfw5lS5+3LomE1T3qYHX
 CzyQrSBS
 CVOyDkDXDk67sw7hUuWuNmP6A4JQ+9mepoxd0YrIH5ml5i2WpphRh6xIxPhCGFn5VLIIuJAaVJBNYa/mC7NguzafAPfmyd/jvRu0bACjPQIvq4FicVWkhckS+0+XAbGHUK5Gdc/ThwZmrm4wQvsjgsuLT07WI6S+cyHWklWLo+LWaegcDwt13gB7UavgjvvR8NA1BJ2SxhOL7t5obUTOY8Eo+pi5bsf80PJk6AOVCewu+iQ7M/blXBmMd80wtw6ykH6B7vzisXROytH5zO5wwZPMq6FOw5Yrf9b3gHKgHxrrVHwISFiIpuFKPZ8Ep9qE3JrjkdCOxyXtwawUcohb4utPPOQPFUVa4CZIZakx4BdHV7MGyEyO53eWEVHsHwSKIrCbT3WoFM/PvaOnBH7mYipZch+q8VjGzO758P9iddL4HsUcEezNaZRR+/MlJaERmHI/lEcrAkTSUD1qGUVQQ5QJYTeNAlcJW1yJ1ycyKcubjtYBizZvFnqw/FEAJ9Xr9+00+RWhwcIeGunAe/BTBmwNHNLyWs5c7h3/fMPXozHWGtBnaDg0j4VvbuIohDncYU7J4jtEtfB4Kyd+qPGTFE7Eg+kRtS5Q3AFgl5G9zMhOIW0d1S+xuLUubnlDEpk6fWzueMCef7wXB3RC7Xh4jGOSdkQp83/kOywhvSz0bxZpLVMKoU8AniI/BgA1arCD6STQsXsXvEg/dcrIGDCfbptIWkWjNVIxzStQOw5aiDmHomhgRAb0DbjlWmEeg6NUNPWtUFgxluk2riXdxg1NB54F/4Xx+/EOzV4YPucVrJXiDuzM1B0WLSgdrVGWzvFqVJuJpOhJAmKtfvv2soFBNvc0KcFccHBEDx0/tvHq6vvxi/z0fJEO4S2Uw+ZcYatuRtIBtCG/LiB+QcNy0/KSLRNwbHbud6DC5D+anqdwRxMyI9k/aB38sx9wgY7phILJohiyCxoUZNn/IMa0IvtUBZ3uJvyP1
 67+OVATj
 hTV0zmqh+9ZMg51FggsF4eqf4V/0T7NNZN6dApk1CKM+Wp6bCRzX2eDuOxoarwQeGmpWy+LQDkx2mfq5aemV8m3foX8mKR4xhrDEeimiVneLZoQNhNvpk20de+7LPQCFjmHV0+TJS2aRM44KzdZxFAumAu8sT1hhF65oymP9GXC0ENgSuu9Glw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-by: syzbot+d8fd35fa6177afa8c92b@syzkaller.appspotmail.com
Tested-by: syzbot+d8fd35fa6177afa8c92b@syzkaller.appspotmail.com

Tested on:

commit:         72fb0170 Add linux-next specific files for 20251024
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=125cc258580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=e812d103f45aa955
dashboard link: https://syzkaller.appspot.com/bug?extid=d8fd35fa6177afa8c92b
compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
patch:          https://syzkaller.appspot.com/x/patch.diff?x=13036e7c580000

Note: testing is done by a robot and is best-effort only.

