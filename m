Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D2245606A31D
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 17:10:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=HWK8m1XM
Received: by kanga.kvack.org (Postfix)
	id E08256B0857; Tue, 27 Oct 2026 13:10:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D91E56B0859; Tue, 27 Oct 2026 13:10:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C59526B085A; Tue, 27 Oct 2026 13:10:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9F52E6B0857
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 13:10:13 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 35352120ADE
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 17:10:13 +0000 (UTC)
X-FDA: 85369044306.14.2B2F797
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 5F647100008
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 17:10:11 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=HWK8m1XM;
	dmarc=none;
	spf=pass (imf05.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793121011;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6z1Q2FnRPqUpv8sUMbKaLkx2bL6vjkoG2SyuClqSAmw=;
	b=zz9NmAfGPE9YR+UYMKjllAVIQmvEWwxHprdKlW1a6RC4fXdiVoGrOyHAgsPojazBtQTkaV
	2mDpmWEJU+7dVxEFPIy0gDBTHRB17hJDcLYusBttXCguBgmyw+46ISPsmAuL3DL02Y2+M4
	0s3cmL91VX71MdaQIcCWallHfJC2a5k=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=HWK8m1XM;
	dmarc=none;
	spf=pass (imf05.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793121011;
	b=iPwFVuLU3rEMuK5qp5vbDLf/qcuJyVSf+nSauAWVEB+YkWYmSGHaSQeDJD/PZzsRoQbkG1
	7A6w6BFaOfja7aP1Lq5RsTsjomsJ7JxDDR1KjOeaJCAMn9HjFr889QY8pUwt8h97fey8+k
	pvUr2cYjEYlb9Cr9+lHkdkFSY5vEeIY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 981A7601FA;
	Tue, 27 Oct 2026 17:10:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B89321F01829;
	Tue, 27 Oct 2026 17:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793121010;
	bh=6z1Q2FnRPqUpv8sUMbKaLkx2bL6vjkoG2SyuClqSAmw=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=HWK8m1XM89Z1t2ZqEzF0wRXMZCN9YZF/stXxZmx4P5l48J3KslfwBTpVL1ZkY5d3L
	 cFvF95td4+ABHcQ5gNSdxOOvGC2DaMLIdn9qCisjLWSWqYS2Hu0bLOOfjFyE4JONkm
	 3yjLt1FT3xNx6nJCxFHXlGgb9Rl8NYHV9oLjIDEg=
Date: Tue, 27 Oct 2026 10:10:09 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: syzbot <syzbot+9fe09db3795456e0b442@syzkaller.appspotmail.com>
Cc: cl@gentwo.org, hao.li@linux.dev, harry@kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-usb@vger.kernel.org, rientjes@google.com, roman.gushchin@linux.dev,
 syzkaller-bugs@googlegroups.com, vbabka@kernel.org, mchehab@kernel.org,
 rohithmatham@gmail.com, hverkuil@kernel.org, duoming@zju.edu.cn,
 linux-media@vger.kernel.org, linux-usb@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [syzbot] [mm?] [usb?] WARNING in corrupted (4)
Message-Id: <20261027101009.18e9136537144533915008e4@linux-foundation.org>
In-Reply-To: <6ae09458.f0fe5aea.79aa1.008e.GAE@google.com>
References: <6ae09458.f0fe5aea.79aa1.008e.GAE@google.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 5F647100008
X-Stat-Signature: 1uqyjbayp99xpt8dq3tkffzppn3ccodi
X-Spam-Status: No, score=-7.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793121011-444313
X-HE-Meta: U2FsdGVkX18o4/zbXN0IdqYL5zpxvV61afmDKfxRi37pe9FytIWzL+jxdCNhrprNAmZ0iZ6CWEyjlLK/4TlSDI5Q/DScY88hor3UtMmsr9uzjXwUY3suvp+FeVJxULRFA6Se4vTJnffksBpjm49YWFO3pywrLekk/pCDPrLzT4ApPRfDXKqJPvyvX7Dccs4ob/Bj95X3DI1QYnbBWYFie/v3pV4nHUICfO2wns03gO9eps1P2IMt1n0r801w5RYBwwPv8XtFKjeSNvjagtDe8cYhSz8X5s0kmn3z0DKnA7bOZKUmmviD30oXS0LTeclaf0XUn2Z0z6kFrZuzEGmqiQga65h6qPmcyr0u/b2Booge7oLiC5k2zf5Bd42owFMCmv9GfHqcfsnbHvt1Ot9BBGomS07ORPAJmVTqft3EgB9R30wW15Nvd56W8BiquMs3DmdVwMg/fnBq2uJmIxOtpq7mkFPENXL/x14tr94JzzUBpaiC+Al8Nwv5UkseekNew4OoxM/cf2XEQQfN6oppHDVZkHSwsGpYyco8SAuwHcFZM4tIjg0j5wt/4hcBlvGFKZJMxm9RPG4MNd4+TOEQt2Qq/RlYIzOxJFuFtvSN/Ry9crzhdP1JzDqQa8sa99zF5JtcvUzFLmYg6BoiivWmLUJ5UkbaaudLUo8/lLPtG42nO6B5N/RvcEt2RGdPKuEUhfCdh2Cj6GQUe1oj6mnrA7aH/veLeVm/+m8BALk+b9ih+Qmg1kE4bf8vh0uCd9JnAkYyzQWjHIvV4CzCxmpQ4nxb6LXUVeqTVZr2lmCAhBR1LOZvD/BIHBeidzuBw6de9D5WGHAKpV9A9xQkhgmYNX2vIj7r0nZv/6JUZ0tlrvyOJHjpAbC4bubPngfyqC0DKmZdyZWuajHX6faZ5Kw1S9aec0YKt8F2s9clYKkl/de8wgh1CpIrisXBU03S3SZ86thA4LpGGJdqRAHYqCx
 8nNkjlYp
 0xlYQy8ZPV3bQUGggIooVfm9fPDh57C2kBFI8FjAoI56EGPve2/PoX4BH9OhrnE2VkHK31GkZQkvFTEc0wpZWX7yDsXaxGOix/dsU/szldB75QyxzkHjAOZupIGcMlz03OrlcGm1hit5HXUCi49UVw3/xwyp3HajuYpTsRbeuOa1fTi1w6ltMn14NSZYxxFiNEpBzlOhNeYU3S7yBDbIBXQ5HMhsYoVdcHdrwgbKQgyRf/nDFyhrBIdnflf4sN81kVsFbunDMqIhhfAUHG2xXUrU1nlNDI+ORK3xuL52sg/DKc9h6xQxBsW9/aI7gKRqzzyVBq8zOa0kh4CJMPJ7et+g1cj7UdBYU0l0f//bR8KIMv7tFA1Zk0X4/tK1bvsRRwGftjlIaB73bMDqYn1REC0deoFHXnHBjs8RkfFJpySuCcEP1y5a1xIpBw5o7tPj7axvoWVqLfNmYzpgpEP4yN5AqCCJF/KseHnZ9dB4Oo0zTQwjm4eaZ9/fdiTDyE4NmDDsDYI4Zh7wVJVUgd/sy0AIQ+BN0txoLGoL4+w3a6SyPuzDjwN2vY6HdtTAZ8NpXYOWgDGI5cbP7Hr2mmghX4p84G4eGxvHr+h8I/dtei0fatDz0EtkeYPzkGJSuQRDQK70HzHdwcucZBc2L7qb77eXBBi7ApfY5oBNIPBZYRiSjwuMZ8SeddzfsPXHhK7+Uw1mf0D9E0C2SWEwKG9lvIHeawepBAcx2bMuZ8ArXx558GgFJGO9HDbOqcU0pejFaydBMqYfUvcMBDHhvFY9MEhPUll9pD2z889mQKcaKZ8buAdgl4bL6H6lAR0gRQnSVX4jnKS//khsEByFgBw9AkIitqbE+i413xFPLPzlHX4GWg4Cg1wp72py8jH0I1eRl062kYTbd8/4NNOZDSYqeLfa58gdpkeRXz9b+Lj5rMm0V1a9ZEI/98JcerjdX25C+zgh0QREhVkqNsvvGDPIFoYjbdESC
 EnPdwes3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, 27 Oct 2026 05:08:56 -0700 syzbot <syzbot+9fe09db3795456e0b442@syzkaller.appspotmail.com> wrote:

> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    5b0764a53235 Merge tag 'drm-next-2026-10-21' of https://gi..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=13739fc9580000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=fd1433abd362f255
> dashboard link: https://syzkaller.appspot.com/bug?extid=9fe09db3795456e0b442
> compiler:       Debian clang version 22.1.8 (1~deb13u4), Debian LLD 22.1.8
> userspace arch: i386
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11cb9b0d580000
> 
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/05ac8658d211/disk-5b0764a5.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/9cfb73243216/vmlinux-5b0764a5.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/fc45c7faf785/bzImage-5b0764a5.xz
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+9fe09db3795456e0b442@syzkaller.appspotmail.com
> 
> ------------[ cut here ]------------
> !PageLargeKmalloc(page)
> WARNING: mm/slub.c:6855 at free_large_kmalloc+0x97/0x110 mm/slub.c:6855, CPU#0: kworker/0:1/10
> 

Thanks.

> This report is generated by a bot.

So is this report ;)

This looks like a double free in the Siano USB media driver, rather
than an MM bug.

The failure occurs during USB probe error recovery. The allocation
comes from smscore_register_device(), and the page-owner records show
that smscore_unregister_device() has already freed it. The USB core
can then attempt to free the same memory because smsusb_submit_urb()
sets URB_FREE_BUFFER on a buffer owned by the Siano core.

Rohith Matam posted a patch in June which removes URB_FREE_BUFFER
and fixes several related URB teardown races:

https://lore.kernel.org/r/20260601201639.63171-1-rohithmatham@gmail.com

I don't know why that patch hasn't resolved this problem, but it
would be worth revisiting before developing another fix.

This doesn't appear to need any MM changes.

