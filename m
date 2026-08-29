Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 420CFC61DDE
	for <linux-mm@archiver.kernel.org>; Sat, 29 Aug 2026 23:44:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0A50C6B0088; Sat, 29 Aug 2026 19:44:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0557D6B008A; Sat, 29 Aug 2026 19:44:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EAE326B008C; Sat, 29 Aug 2026 19:44:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CAD076B0088
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 19:44:05 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 32D3C1401F1
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 23:44:05 +0000 (UTC)
X-FDA: 85155937650.25.E0D7B62
Received: from mail-oa1-f70.google.com (mail-oa1-f70.google.com [209.85.160.70])
	by imf02.hostedemail.com (Postfix) with ESMTP id 84A1880003
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 23:44:03 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=none;
	spf=pass (imf02.hostedemail.com: domain of 3wm6TagkbAEk39Avlwwp2l00to.rzzrwp53p2nzy4py4.nzx@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.160.70 as permitted sender) smtp.mailfrom=3wm6TagkbAEk39Avlwwp2l00to.rzzrwp53p2nzy4py4.nzx@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788047043;
	b=pXuu+mn0wuOXbvs3t+yKSr4HapIw1qhkAQsxcDRybOxqsd3oRTXkTFH0pb603Qss8nD7B1
	E/FivRT8aRfRe1BZAK5rZZrpzGvLd5pcCfA5icnV9xI/Aq2fwd4m9SV9BK1YuDObB/GN+m
	KkDYcywCsV+QVS1VqtEscSEl3lQrMVE=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=none;
	spf=pass (imf02.hostedemail.com: domain of 3wm6TagkbAEk39Avlwwp2l00to.rzzrwp53p2nzy4py4.nzx@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.160.70 as permitted sender) smtp.mailfrom=3wm6TagkbAEk39Avlwwp2l00to.rzzrwp53p2nzy4py4.nzx@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788047043;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references;
	bh=DQBWUg9lR1vGNw3aL5E0KsvI5tTpdhTutZWPXYdUw1M=;
	b=JJPMrfh8zn5VNH8UZOjSnyCZrGxg2EjTfFzzcNoKxr8Lzuz5iV4cSmABZjJizz4MrP8adv
	mKgyPAq/qOSQ5L4Z/ZKUqgUoEJZq039oD8NfpxukGaMVfnK4Znb1SAZPYQF861Lm6pezW1
	UNAqL7uIiOMffHaM6b7UQ11Tfk3yJB4=
Received: by mail-oa1-f70.google.com with SMTP id 586e51a60fabf-455ad408573so4133739fac.3
        for <linux-mm@kvack.org>; Sat, 29 Aug 2026 16:44:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788047042; x=1788651842;
        h=content-type:to:from:subject:message-id:in-reply-to:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=DQBWUg9lR1vGNw3aL5E0KsvI5tTpdhTutZWPXYdUw1M=;
        b=dprSGVhewVQdx5cRQrYW0NuYy0KWyE1k2N3YGkxTHpDTAlxgOUXs4UmgCJjZmp0tyx
         n59NLzTVcGTl3jj60l7ve80J5/OAunSVLDKAO8xdOmleigK+NO+AcQ3y5/f03OtTHUlr
         7Njf3J369MaF7KV0VWZDWz/CfUtFOshRAvkznIEqw0SioLR3WPizr1ilbRS5ZCinQr//
         5rYSkSNteSvZ1utGq5DMcKFLyg1k2dOPRMhPyaNb1fdHThnFVaBNUrHupH90cNxLiTRO
         ndCRBpcEczzg4yQrBuIzU7icscTYS0Qo66UeZrhvxplYGB0L7enSIEKPYvpvc8859f4B
         5OxA==
X-Forwarded-Encrypted: i=1; AHgh+Rr/9dciiqDIR1RiQcLfaG2SEVVMwYgIFluJEQdaVNqcVi99+On8EdA2gb1Bd+atkscMcg/52IRihQ==@kvack.org
X-Gm-Message-State: AFuF++nRWgkzAjzOF+eRxP1bK+a8R/22BAFzglSYlzJz0CkQ7t9I92aa
	EMJBcHijHDbvDUtY+3oKGdO++VeLeJVla6NJTbUGHs/RAczYaOfq3FQ/JX18iObWfX99J14Nc9W
	MjwF0MekrKQBpV3qd5j+DbYzw142NXX33S6HoCzDaTLHpiDoEJeWsduEG30w=
MIME-Version: 1.0
X-Received: by 2002:a05:6808:538e:b0:4b2:e9d9:f13f with SMTP id
 5614622812f47-4b3982ee646mr20396784b6e.17.1788047042590; Sat, 29 Aug 2026
 16:44:02 -0700 (PDT)
Date: Sat, 29 Aug 2026 16:44:02 -0700
In-Reply-To: <20260829145838.19351db0a28b30b7ccc1b295@linux-foundation.org>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a936ec2.4d659fcc.734b4.0032.GAE@google.com>
Subject: Re: [syzbot] [mm?] INFO: rcu detected stall in __mmap_complete
From: syzbot <syzbot+e4aa91d7f20c34417d4e@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, dvyukov@google.com, elver@google.com, 
	glider@google.com, jannh@google.com, junjie.cao@intel.com, 
	kasan-dev@googlegroups.com, liam.howlett@oracle.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, lorenzo.stoakes@oracle.com, 
	netdev@vger.kernel.org, pfalcato@suse.de, syzkaller-bugs@googlegroups.com, 
	vbabka@suse.cz
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 84A1880003
X-Stat-Signature: 8o17y8sx1oa6t5epenretuq68ae17rg4
X-Rspam-User: 
X-HE-Tag: 1788047043-731289
X-HE-Meta: U2FsdGVkX182w6K1F6ZySEatBVIE+XvcGMBmX9SMFQYXlpUGOUY9qWDDHA3yp53FQqu4kTDNNSFL3w/3nVoeEzyNVH96Hqknp6fdjbhM4B3IQy6vyTnVxEiWIYdakdbFjzi5nb6Pe2O+62Z1wTa5X7ey9Ah0VqPyVz4/ebfjUPc067y9FqZ4L4APHCxriLa7v71Jvx62PehvZ1GV1xvtHBb6kmwJonQJMZ2B4rrFPUjLzOS44c4U0C2KAfG4PsV1lOoeh0jFi4lxcHN2pYLFiDnkGPF5wjpGBakDm5+RdRRnkvdMdEDyngrtO0AWsYuirLhbgX4ht/wfhkp9Kt1wnC8mYYV1T87o0YgD1FcqUy3CCabrXLn7Qph5r6iC60ifXM0f0Qnl7eHE1aX41meOy6nleB6l/Uq16XwlHe1IIUfpipWvqi87JdKYBNBgSt9k9/Ey+en53O/HG13Dtl4DJRxrS8XNGHxBoZKyhV5aoJbvqeV8wyM7IBIVJrL0OzybFuAw+L9pLngj1tUONi0TIJLYDmcF7s2dKtJs26OFdNU1FTtCnk8/poj5EnMA8zr5jp3f0iZrJcymZybZ6otiSYScTFGuPYrI31iPiBKOHGei9jtzGdKeHvcOE/+qOjHR6pniAKZKIuW2+bXrc2vAVtBrV8X1oD7H1ITw538G0wFbek+8D2UZyotP8JWC5+cnT6C/JcTOBrcgQCbF3pkisN+zFbXc4wu4RPBmFht11S1np8kWE0u5E+KpzYb6W9S48+l4hO/b85ZLIbzw2EHDG+6Ib3UBmi88s69U1dKRf2ZOsOSP1wSjd754171wKYwyyV53V1jg0kUkc+yRC2YjZazhWsJb3ZZlfaGvB0JTtbIFPyWlMvgQsSE8Agt0UTRV17EUaNBZXH3t7hofUrIAdwtAIKcQlhHPga1Eyl/3VsgC0jsv3HO3atE5VAUVsl2AVG/JYUsvnS9WTeN1YYY
 d4a5RG9C
 BA774CkQwaQo1YLyczlNKC1JaCmdp8eY797CHGzWmXM+gcN5FYkAiuEynXu3F/HbRHSGU/gedWpUcjF/4TSh92+hzZ/d84vbAPimL/VbOCfrnilOp7QuZdAnwG2bvLS+gpqI7aarLmZiULe8Ax2r2bQHZ8w4zhy9mBnslgztU3LnIOJlGIPwaboG0IVC74lY3bEX5ug5gSC+ygRrHjGUGWHok3Um8MvMkN9Cq4fv4LZq2N3MDqqpYAgeAWyItTIfLYScFQI+rnIHCKbb7haPKfg/qFPu2RKmWJNMj8iCDZl4dmM8tmO+2AMuH8kOpiOO8Va7P4U86Ce6BXcsuwUAI4le22xXdNS2n6YZypToUFSbazY+hiHqc9UfOwHv25LNWB6R3r2RF/0qAkKNa33TkAjE+L3BrOGGJi5Huv/XlFvQFLKbIttyUQsR0EXF2jYF2JLBWAf/7pmlqjNEJtMy1+FdfOGTk2NbuUeBVkJQt4ZX5cCO8jcRvEOWEHheBayBM0OAgJvQNfN7F3iM+33EzRGzR+XN3rV6T/tOJdd0Ne7y/IpfWuVqjulZlqcHEIsVymvF1ELL1s0Ds6Vibyo8SpFcHNlYYpGIz790N4yvjlNHQxK2NEdSsP435BCwRLLifr0F1XI2Us/uFYxyOY2qnwaw95HElsqARSV2ZGSeZ9UcsC4svho/LP6q5UoaS69aPkfYSjuOvzNN1V7o1AWiwjksL663vYFYQPyTMMtr6EjQ3r9H080wevv/1+XupF+UdwdfLiilSp6TtyhW12/bORCLtLFiGT5LWQHJla0Xq4CPeZFRyaQ5WvtgKv1NG1Sq+qvzNeYqaiauzwDMtxmw36UcqhoPoljWnuVd6gg6no9G3c4RCLJcuJapr9iIcpE6r/dGuW7IpuH8e5/fbCqMWZXo34oIsEZx4xFOu+pxyL69UHCoAP9eSrVXlIMmtygPejbRXLfEvcN2NnTMQaKkUm6i630Wd
 LnC3ihaX
 Et56pBtRfC09gUoV15FwFsNY4M1QZE9H6hx/B4wkC2s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-by: syzbot+e4aa91d7f20c34417d4e@syzkaller.appspotmail.com
Tested-by: syzbot+e4aa91d7f20c34417d4e@syzkaller.appspotmail.com

Tested on:

commit:         1b78070a Merge tag 'net-7.3-rc1' of git://git.kernel.o..
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git main
console output: https://syzkaller.appspot.com/x/log.txt?x=14e12c15580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=5e4e3a0e188a497e
dashboard link: https://syzkaller.appspot.com/bug?extid=e4aa91d7f20c34417d4e
compiler:       Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8
patch:          https://syzkaller.appspot.com/x/patch.diff?x=11f37d49580000

Note: testing is done by a robot and is best-effort only.

