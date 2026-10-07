Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 723A2CA5FF1
	for <linux-mm@archiver.kernel.org>; Wed,  7 Oct 2026 08:06:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 17E3F6B0088; Wed,  7 Oct 2026 04:06:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 12E996B008C; Wed,  7 Oct 2026 04:06:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 044336B0092; Wed,  7 Oct 2026 04:06:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D64916B0088
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 04:06:45 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D5CA01C0166
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 08:06:43 +0000 (UTC)
X-FDA: 85295098686.29.5AC7569
Received: from mail-oa1-f71.google.com (mail-oa1-f71.google.com [209.85.160.71])
	by imf31.hostedemail.com (Postfix) with ESMTP id 31B092000B
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 08:06:42 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=none;
	spf=pass (imf31.hostedemail.com: domain of 3kf3FagkbAAIu01mcnngtcrrkf.iqqingwugteqpvgpv.eqo@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.160.71 as permitted sender) smtp.mailfrom=3kf3FagkbAAIu01mcnngtcrrkf.iqqingwugteqpvgpv.eqo@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791360402;
	b=w2eElKjGhYTfl44wVAAauyKfwPGJSgZd4ew2WkzWzzmaqXybI0ZJhTfMFTovvEgp0D2E2R
	g3IkT0QMkSRvGJIImmKAiP+wVJ/F9PsKGXqvAwirENYcuieyrH4AouhsJzuUn934rdHoRz
	Bctqlvw+QNWSdHpScldu1Wmm9Q76WOQ=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=none;
	spf=pass (imf31.hostedemail.com: domain of 3kf3FagkbAAIu01mcnngtcrrkf.iqqingwugteqpvgpv.eqo@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.160.71 as permitted sender) smtp.mailfrom=3kf3FagkbAAIu01mcnngtcrrkf.iqqingwugteqpvgpv.eqo@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791360402;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references;
	bh=RHmnpq+vWrRC0bgF4lxgVEQsFZIjFzLZS3SzLyOrux0=;
	b=SxjpJn4L8o/vzsKolU1Ti8+32J3Ho/tXevE3fUau5aV2YNotp29/yv+99ks7wDvh1grMD3
	+My9/t26RFqqhaJ7fdcx9phwRlUKAZwR7TN48lPnKwoZ84v00ZNBk5XuuJcGwc6xVTT2rm
	RJvs19JdAtlprvRHI+mu5r6I42q3veE=
Received: by mail-oa1-f71.google.com with SMTP id 586e51a60fabf-482966c4f4fso2510252fac.1
        for <linux-mm@kvack.org>; Wed, 07 Oct 2026 01:06:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791360401; x=1791965201;
        h=content-type:to:from:subject:message-id:in-reply-to:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=RHmnpq+vWrRC0bgF4lxgVEQsFZIjFzLZS3SzLyOrux0=;
        b=F2VDjK+BHxaI6Dkt882/wZoHBZa+M/pfFGzCJq4Hm+oR6HJ5PXSbc6iN7NZqLSF8YW
         Bq+SYZSsjLOIkJ3o4CgOnu47jmb4XuwwoN3x8WyBC4H5uAki4Oeh3yVcWJQGfMhTQOby
         NwCPWqpDh5JZvHrTCzQYyvOyKdJBZYb7CIMGghdLldvZPc55m2nt0Y11nCtVHOvlP/cL
         +KQhy7Tqb5+/HNQ+DWDTaZkzvE5rCaPtff1UrF7hipkfMwDMsYzxaKJRFx/qbDMHmWwJ
         3OR+fhQCwdcbNKrlymCT1BNoFCAP2kc4mG8JIrnQLszTEu3FJqQYnDVtp0rXqC8+JK7K
         dVGA==
X-Forwarded-Encrypted: i=1; AKwUvBwBEZPgTLFTrGzO00tBA8JqxGtiyeOJ54pS+ps6Ej5BQSBU8iM5p0C3B4j63PoKv26V80pO377ueg==@kvack.org
X-Gm-Message-State: AFuF++lMYkcmnYLejlN4RolpN5sbS18AAemvZrXRauddwl7BN/Xp6/H1
	3Lt3tK2LfjEyZjUIfFezK8wTki2GYkUbBNaqnt+ENfpipXXpm3asiUEM1lgG2LPevX4u9qH78kT
	t+X0eq9359DVlFKsISYXPDpjeKtxMLRlAdQlpEzCs5echWSRGGkX3SGsngZE=
MIME-Version: 1.0
X-Received: by 2002:a05:6808:1311:b0:4b8:4703:db97 with SMTP id
 5614622812f47-4faae80f6b4mr4486943b6e.32.1791360401209; Wed, 07 Oct 2026
 01:06:41 -0700 (PDT)
Date: Wed, 07 Oct 2026 01:06:41 -0700
In-Reply-To: <6987d9a1.a00a0220.34fa92.0039.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6ac5fd91.34119e79.8a1d6.0000.GAE@google.com>
Subject: Re: [syzbot] [mm?] BUG: Bad rss-counter state (6)
From: syzbot <syzbot+5981772e2b70777a3b01@syzkaller.appspotmail.com>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: c5bmnf7kt7cgkb7c1s7hcrf4i49i54wk
X-Rspamd-Queue-Id: 31B092000B
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1791360402-423710
X-HE-Meta: U2FsdGVkX18la+2dqZzkuaYf6QAk7A715V+2mYds/OFDk9Jb4YmZdkS9sumOjQnTV6Oz2+ctTOgYhd0EQ8Me7xoZrNVZEiEIkpUTil96cFVIK9RpHg3QYdDuM8Hz6WOnbfr2GgSLY1wo9ZKAIoqnoE12Zs39auxegaSSjgtS1Eq2FPEweuXNZrwjTcfn4xYa561TAPj8SDIjIqUwsbYoNjVbtQK8LYCtAjvdBIyEEkA4trehbePtSb5UgV2ps8aVIU/lghmrBfNCL9e6J7aQC/i/zu8dLZGQVu7KXnenI3Jf/9R4llZphbPyjYeaSumwPDQnrHphfLYxCwgQtWzeYqQDTRtl5lupbWzViG7WsUFdUhvQ51jbhrBF+BSrpg0swIVBKVd/3GVrxiqhIDzZNJrJmkXsRX/439iSMcEShU9rkKYfH0/OEbz9NOOxI9pQq81SZx6ZLdWZUN2s4FVnr8h7FLT3HC5Fb7LPhdIFZrDVGFrwnOtnyIDWYA3z0/fcE1T6fJPvKXY9oQ7065FJBDHkuo0NzaGG6iGrLZES5yVVelnDCN2huCrPgmd3gs2sx5TjrE1sb0QV4lMhRIkX7lHUq+UOctrq/wx9/bWee15sJL48HlfjxeWRPZCyQqNfxEWxL4103IwhL9DhrIGbbTwNvpGPW+vjdRCD1CmQscmiIs1aHFXvan4s+noFaTSxoUhJqXjEtzXlb3nyk6nmSXJnDNkN/oJ9YmkF3lLs/xl7cPk6i+RUdnT7w00ZHS2Ai5LIlShem6FCG3VKEyHieWSTyMNjuY+HXeA68mKnLqLUFeB4M8UpIOlBlcl2qegwrlvPzbJlryS3lCSechITrOL3ehkYDNKjvvdlXQ4uQEKAnjmuR+rk0pDFambmdgOyCl2y0skNi97OkKZ1sWFZSe6lkI+sl+k/WBA5Pec/JF+n5LMrp039BV8k8+Van+ejkaMhXKZKflf/yW5CysC
 jQ/t8O/z
 LFjP4mdkQPc6TQW0cQxOgSFZg93yRM/1DPtnmjQdb5GhlIgPG+xODQKQmMt7DbJQHamN7vXlLWnpWMNyZbK894oYYkRp8hJLXKbu2krxBi0AfUj6N3XTjAn+UcfybLOcSvaN6PDg61yFWBnGMZYcTZvvTHEk8MiRBthh51WnF3PJjEoRaN4HyxMK1nSpoTk/yafqKRZbAxhEEd9RCcqin3OxOIdAF0kG4xyROP+/XRRjid7Mk0n6QLfQjJari9va39gEgtIjNLqpjOq+N9a+VeW2BnSk9EXafQfTuK33eaInqQPZX8V+RHaVL82FPXDh/69MUadl9A+nOhFyq+4Gi0bVOl5eDKrh52avEGBidcYVy/eRKuhPb9A9U0mXxas8Km4nAmXXXI/mACz9P0bOfU1F4eVuoVFGGNZxguZTxICa8xqXgVL2qaZNY7PB0gEYRLX2eWutE0EmuWMTp4Ec2xx6CoU2PmxxbrK0CgNcPEGheKLk1FvNRvRVCSwfUbRXCus8IBYXfvpgBJVxC7loPXe3Ot2UqMjSOVzBKd3PAZW9V2KbJHmCAQmEGSNXcOQOYss+xzsSLMG2u+js6eMA/n7Tn5WT4hHWXQ9B3f7tMc3jE2uS/IFjgwBniYD7khUrl3aFva0WfeSU69ggZq5j/SLcEZYKcSTNMeE43JiWUvCs946Xs6muN46ENrp1yjIyKWrYYlZSiJVbsH7lo1PCrN5/H3QcJruyFDPg3wxdKtPrwc+MhurUREO+SBWqI9JIT+MmQOfMA9W1shdFzV0hnIJrsYmYkFr2SfvpRfjj0sNL2ejFUL3DMiQkK5emWr6F+l1dc+wb7AuTEvhDLCTTvDcgrkTqAklSFSfH9mR6mxx9AVMz32iK3zOfCCbYB51E4XISO3pOYXtfjaLUZqLF+6mL385ifh0nEBxvv7szZ0oOxF8w5W7b11xunLKvcGCkqlz1AOkPplNIXO6kt6e9uZRpIzX6w
 d2brqAjA
 CE8rVBS1y/aiqaxzRHOYPMNOoQXIO+lpRGoMxaTYTsln4v89hARueq+5t0BVT8U6xnpjoAighIC7nLlsXKL52ZXDngWC/INuxzbrGthxN25q3BGD3qlxVYtCPiR59VE2OmdkNXDxIQfyLPrLYB58EvzUi6KhjIls8U3eucZdqQIPROHIN5eiC+oalp0RKHv7f8cgKb8w6NGfJKEL/+mjwjdDv+0osuY/59yTVc0mLoM9p3HQMEjSJal5FF2jjxOMnE+dzedTVDI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

syzbot has found a reproducer for the following issue on:

HEAD commit:    71c3e5409eef Merge remote-tracking branch 'will/for-next/p..
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git for-kernelci
console output: https://syzkaller.appspot.com/x/log.txt?x=137d5f25580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=c7205f05c11fb4dd
dashboard link: https://syzkaller.appspot.com/bug?extid=5981772e2b70777a3b01
compiler:       Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8
userspace arch: arm64
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=177d5f25580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/20ff6159ce99/disk-71c3e540.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/1d6172672705/vmlinux-71c3e540.xz
kernel image: https://storage.googleapis.com/syzbot-assets/923d5e083e1b/Image-71c3e540.gz.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+5981772e2b70777a3b01@syzkaller.appspotmail.com

BUG: Bad rss-counter state mm:00000000950a6f7b type:MM_ANONPAGES val:2 Comm:syz-executor Pid:4828
BUG: non-zero pgtables_bytes on freeing mm: 4096


---
If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.

