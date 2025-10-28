Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F059ECCF9E5
	for <linux-mm@archiver.kernel.org>; Tue, 28 Oct 2025 00:17:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5A7B1800D3; Mon, 27 Oct 2025 20:17:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 57F6F800C9; Mon, 27 Oct 2025 20:17:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4BC00800D3; Mon, 27 Oct 2025 20:17:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3B1FB800C9
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 20:17:05 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C62B113A6E6
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 00:17:04 +0000 (UTC)
X-FDA: 84045607968.13.9F29EC8
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com [209.85.166.197])
	by imf02.hostedemail.com (Postfix) with ESMTP id 1FF8E8000F
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 00:17:02 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf02.hostedemail.com: domain of 3fgsAaQkbAOMXdePFQQJWFUUNI.LTTLQJZXJWHTSYJSY.HTR@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.197 as permitted sender) smtp.mailfrom=3fgsAaQkbAOMXdePFQQJWFUUNI.LTTLQJZXJWHTSYJSY.HTR@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761610623;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references;
	bh=Q+BxjPTeay4IQJxgholECUU0/b+Vf640R7FfR9OqLCc=;
	b=KZWNgn6wSlKAOFsThBcrKj1hDc4UmxqzQ/31S2BPBZHAYEjxSywsZPclNEnXRts5fi+aTQ
	soX0TkU2jmWFfDGc15vpcBwFJjFmGrjObJC5t6PwU+xROoyv28B4ojKrIMVYJ5aY2pVvm8
	U87KJjIKDcWIhIh8zRO1CZViTWBmChA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761610623; a=rsa-sha256;
	cv=none;
	b=kznmiKqSN7izFzrxjLwJJoA7PLkbzRwycUlQ4PXDzyUA99M5f+dPo0E5odoD5arYlOauiA
	MxD+k/5W+wYWd4fRfmFDm/Nriy9pa3TekgGs7GHieup3riBUl+Z/4zGcPLE/gVwUcYAANH
	DNXjwMsLF9EkSA74qSTiQwfH09PiQLE=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf02.hostedemail.com: domain of 3fgsAaQkbAOMXdePFQQJWFUUNI.LTTLQJZXJWHTSYJSY.HTR@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.197 as permitted sender) smtp.mailfrom=3fgsAaQkbAOMXdePFQQJWFUUNI.LTTLQJZXJWHTSYJSY.HTR@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-430ce62d138so66945885ab.3
        for <linux-mm@kvack.org>; Mon, 27 Oct 2025 17:17:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761610622; x=1762215422;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Q+BxjPTeay4IQJxgholECUU0/b+Vf640R7FfR9OqLCc=;
        b=VUznPlO/8TQbQM+N9NqSlZWx4QRbAgFF2Q1HYYrxHNnSseLTLahdhbvI4tUyoIHGZd
         HINp9qbvoYA/cWY/D166YDxlnFc99yDzXYxIoni8NrP0/HGYo4G8oJyrXnecPvGzVUXF
         w/66k6jSM9pHDhJG7Ve6PSCUwpxvUdcQkJrNqFmqtB5kStFqfit0N9xjM5RjjnHVVkSJ
         xZ8if1Ganod+44q7V8feC0LLmz34edpWMPS1BIM3yhBY1h6pXddIeFBG2/kdpMD5S88s
         UgXQd/E33OBlkrfeZzR7W6mwgZ2yH2FD7VkQtQyu8WXht7isdCcfcCliChS6DJmcgsuz
         lpKA==
X-Forwarded-Encrypted: i=1; AJvYcCUH004EfbpelcLi01RX6We0xu0DqLRSa8JTEt4SVyIB7crIgyhqqEkgqnUlGHjBlMbd3nhpxvMM4w==@kvack.org
X-Gm-Message-State: AOJu0YyViWQ5Mhz6GYRDFAiv0OqSJkz/Tv2fWu7l5KmvSXUnH4Pv4P6E
	m28HxdmK1LZ/Et8u8nJ3xkThI81747oE/xn+lPakynNMcBo/vaL3di1u4UdMplPSJxEdo4AZqxP
	oF45gtpzXNI/4XXc+x39+cthZOZWTRbO7+Wd6izzkaH1bjW9Wvl0kjio1w2g=
X-Google-Smtp-Source: AGHT+IHdV4hJ9MsxTO9lThudEXMeDmJmS7gRscZENNGnQ8fX706qkGKCmrQ9S9unumIWqysBZZuolAbCiElvh75tp3uFtbmW5NhR
MIME-Version: 1.0
X-Received: by 2002:a92:cd8d:0:b0:430:cfe4:6e61 with SMTP id
 e9e14a558f8ab-4320f7dcd73mr30898485ab.14.1761610622187; Mon, 27 Oct 2025
 17:17:02 -0700 (PDT)
Date: Mon, 27 Oct 2025 17:17:02 -0700
In-Reply-To: <z742ziobbolobstu2ljazsv3hkp27pdpfghrtzj3vfr46w2v2s@jqdpqtdgy5qn>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69000b7e.050a0220.17b81f.0004.GAE@google.com>
Subject: Re: [syzbot] [mm?] WARNING in raw_alloc_io_data
From: syzbot <syzbot+a894fe5447d0543e89c9@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, apopple@nvidia.com, byungchul@sk.com, 
	david@redhat.com, gourry@gourry.net, joshua.hahnjy@gmail.com, 
	krishnagopi487@gmail.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	matthew.brost@intel.com, rakie.kim@sk.com, syzkaller-bugs@googlegroups.com, 
	ying.huang@linux.alibaba.com, ziy@nvidia.com
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Queue-Id: 1FF8E8000F
X-Rspamd-Server: rspam02
X-Stat-Signature: thuwy47tt39khhyoqnnwjohbn9rppgi9
X-HE-Tag: 1761610622-661862
X-HE-Meta: U2FsdGVkX18xooLXGWm3qZUJ49BCH7as4zPuTQZEEtYNTbJZBmWBAZSvadrV/Bnq9SEtDN55OCtgz0ryl0dIwAozgfsk2WH2DifDqfeWklORtZn+Ko3uei4vDutnkM4d/Q61zMdpLehb3dp+Lu5FdmJES+kUO8kF8FE7g0LLtTM0QxZ44M/HcNVFkCYLHzf7sdNI4NshVitstW4WzVp7nPq+5XbBDbp7uS4Q9cOHjSXrXI2Wsm0ODHKTY/E0PGJV8Tf+LGNvVfxpj8gnRX0/+YlO76yAXztGqDeUCU/D6M20WLxVZ207sdO3amuDqlvld7qmmTwUJ7Fni+Oma/m+z6v61+OmTktuZ0ty9m9is+JAKduLDm1PsiBfh/aMh+gXmTIsJveG+61nDd7DNLrjlo/RytHGKqktbNqgv4t/qLrf1FhQVGoHFsaV2IRNYmINMVuaTNyci5Ba3lX4HF5wFcN1AqPu8XAqG91WD2sC0/W7s4qawvT0SfBOW/WUCkkoUi3AUHDeca6i5mHeloRnDk2R7gJwvwJthfvFR5zvwp6LQvEumPmhLJ/kXkaRfiD06+vjqsnDEYWRFpHkDWvAA697mW5T1qDDFiDx40l80p5fZwN0AXqYv4Fg5H7RIniddV45qJ2N+RdKGj/Qt2P2Os5ibT+SWuwKCfL6GNG621xQO2Bgs7fUGQpgZ4zH46fjC6fG1J5jnKDIxF1ZvV6zdMLAoA59fADJGGRBw2fOj12/tw/5s8XmoRKfThFfi8uVZg9cn47tHL6V/GkFkryq49bSd4AYPuaZ4K74yy8f7uP0wMDTygwx2GSd07g+2cPuIqvZvYy2FLiRAZXxpBHiqpLoF8i/BQdsGRyXmmSk7+nwm19yw7J5hgH/VMjYMhUBy47XTKZx3XNpExyz4ZvteJfQjC2OLht7LfxJ/eGsfl1W3VFEi9V3jQY/iQkaQNsv+2kWBFVRsplJ/nik+mK
 3K9gqRQ6
 aNF6zK3dDHXTmCBlacu22DCajC5vba8hEQ4fkz85rI/naM2Zbkvn2xVfnPNQLMHvSjaLUcxUe7DtZ1I9+xqeqqidh9B9zYAODngaVOtNDdUmHPzD200Ke+rcE5u9notfPDM2Fiyg+/zhZOg0Bx/a6YAvAomj0uzIV5I1QkfnK7XUO9qmMLWuM2dgN5TdEpVN/ol21NMNvqjCq6EoR0n/A8wXTOXqXK3XJIyvz8kjGEVAV+jNyJ+sMvqCU34ls1wqQ+OkcHCZyxpXmWVlJu+fh6XIEoem5QhmL5U6Ee4798kpYO+p2/rDTr4Lmgo098tHFxv1s3LxBBOXqjeSUmoVbxppZxfVmoTYnzOxrOJPTKkntP82KYiO/CmaKfLCanBWqfg/1DjE0zNYiDVnLP8YrTyLTOtUnFT1NNzESRQGYxzdlER5aFH08yzwniggGbtxYotDUuTBntA9+cavYc9zGSrjx8kfEsVUWWmzU9L/SFnthrl9DtQhzVIOwsveVDhAdR0GxboYoBg4DTp8Ojy8whyNqQd+1JFM2YvlFvNPM/Ts5wuzi2EQ9/Zj/efHuQhkBPpaoqvaIEEvrMIsk3Djj5OjRtrum2HrylNZj10pfl4p5WVYpDZ3A8w5uBAv6TN09t4rYAsyjhmXei8AGKdcLDSgpMtgynshqykWMZN0Gobq73QBfrJsBANqL3qQMbrp8dc363HsAIgpMee5s+8yXPWaT/aEmg9clfe4Pxjv1L7geDkBwhB6/DS4dG9eXG3BjA3HctGgj2ZOaDMhKLY3IvFganG7tdIsl8NYgOa6evmxVTGm3XAt2gkPrlt6Y0B329QLG3cqQDJW2WhDx1lYxmXDoDA1Eyq0jPF4SzW4/GWsBDslM6DRJpLgy6mgqxNuvnv2Oph9aiEUazJ8FvOWQryitGagds9XBzz9N4HcWCcufkuDjBq0tcCZrzdMVl1rAqE+vD4MaNJyqlshBoeLR3BYLBnuV
 JQuAXq6p
 LKxtegZPolQtgNbY8gs011zjitSLs9oKIH3w6kIjUxzxg40qRWW8oQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-by: syzbot+a894fe5447d0543e89c9@syzkaller.appspotmail.com
Tested-by: syzbot+a894fe5447d0543e89c9@syzkaller.appspotmail.com

Tested on:

commit:         fd575722 Merge tag 'sched_ext-for-6.18-rc3-fixes' of g..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1077d614580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=609c87dcb0628493
dashboard link: https://syzkaller.appspot.com/bug?extid=a894fe5447d0543e89c9
compiler:       gcc (Debian 12.2.0-14+deb12u1) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40
patch:          https://syzkaller.appspot.com/x/patch.diff?x=127b9e7c580000

Note: testing is done by a robot and is best-effort only.

