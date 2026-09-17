Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 36C5CC982C1
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 07:51:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 50D306B0093; Thu, 17 Sep 2026 03:51:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4E6156B0098; Thu, 17 Sep 2026 03:51:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3FC736B0099; Thu, 17 Sep 2026 03:51:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1F7306B0093
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 03:51:28 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 93FB3C021A
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 07:51:27 +0000 (UTC)
X-FDA: 85222484214.28.4B76A8D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id F195C140004
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 07:51:25 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=m3xwywF1;
	spf=pass (imf09.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789631486;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gnTwlE8vXLouBpo3zgoY8WtBR+qNusYyWfPZr7YNzr0=;
	b=xwgZf8RTq50iz4JA6bWW0yIkCuPGaqNA/OTQHWE1gbFuatlB97ZLrWRovrAHji6pSWxlTW
	9lzW9kMfYk/Jv/CZ4dw2UMFfStcTA8A+xpIW7mr5xvTaViinDRUlp3OGyfs9x0A8UpgEjn
	2bZ4g5g/ASEHCIqVTqICAQ71970uZoQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789631486;
	b=1+y0iXJT2rdKpN4FucOjH7y74l7kkr8wVqMKBWAlZKHDeBLtkPyU/aJoB4mRFgfJ7BESxx
	MU/33qTXI1EX3FoatlkPjwbqTusnR3A36De2Y6HujL3TkQM5T7MESKXxMdsv2AgDiL8q9z
	yOUlY+1a2ojXIV6XcnF1pKr6LwodscM=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=m3xwywF1;
	spf=pass (imf09.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 29640402E3;
	Thu, 17 Sep 2026 07:51:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D58361F000FF;
	Thu, 17 Sep 2026 07:51:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789631485;
	bh=gnTwlE8vXLouBpo3zgoY8WtBR+qNusYyWfPZr7YNzr0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=m3xwywF1x2dNxru/88y11Jm0HWHD1B/6Wwuw8lE+KPMVIo+xdkMnfJB99wlL98z1B
	 ycrANUp/YWFNcoeDY49fP27elybl+V3a1ox+5GWpmXlGpPJeR0wWOHn7BrAMM3kKH6
	 AWtvNopbVC/e0fKHODRAI9g5LILH33nLB0Tzu6PZGx1oXeJS9x62xAF6um5MtgkJzD
	 ZAT/+yrU/4+jARQeGadxY4AYcJ4BuEwgduQO0DZNaE6WJWco4iRxYc7zBAg4tslFga
	 a+VQF+h5AK6WplXcMmz4JAaeH4ikbTY/0GgR2pDzxr+JcLElty9iyKD2+ff8+gxwus
	 w+eQBJufdlZOg==
Date: Thu, 17 Sep 2026 08:51:15 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: syzbot <syzbot+c3178b6b512446632bac@syzkaller.appspotmail.com>
Cc: akpm@linux-foundation.org, bigeasy@linutronix.de, dwmw2@infradead.org, 
	dwmw@amazon.co.uk, kvm@vger.kernel.org, liam.howlett@oracle.com, liam@infradead.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-rt-devel@lists.linux.dev, 
	lkp@intel.com, llvm@lists.linux.dev, lorenzo.stoakes@oracle.com, 
	me@brighamcampbell.com, mhocko@suse.com, nogikh@google.com, 
	oe-kbuild-all@lists.linux.dev, pbonzini@redhat.com, rientjes@google.com, rppt@kernel.org, 
	seanjc@google.com, shaikhkamal2012@gmail.com, shakeel.butt@linux.dev, 
	skhan@linuxfoundation.org, surenb@google.com, syzkaller-bugs@googlegroups.com, 
	vbabka@kernel.org
Subject: Re: [syzbot] [kvm?] BUG: sleeping function called from invalid
 context in kvm_mmu_notifier_invalidate_range_start
Message-ID: <aqubuvR_2XCNav28@gremlin>
References: <aqrZMReaQPG0M9oV@gremlin>
 <6aaaecd6.4e05fbd6.392abc.0003.GAE@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6aaaecd6.4e05fbd6.392abc.0003.GAE@google.com>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: F195C140004
X-Stat-Signature: 5zq85pxi3pzkorgry14gujem7saqrrer
X-Rspam-User: 
X-HE-Tag: 1789631485-220776
X-HE-Meta: U2FsdGVkX19N1HSuDAEQvlTt+3hs5IfiAxwL1bwXerIPOfLwUa+sazRAeUidExtY/gSWuTOWve9qsYlkOKdAmXj4cjLjsxGySuT5P84RN+Li8is9lP8nk4om98qTeAEPAvq8yZ8O07zjJPrITodG0BdBK+f+LGrJ9kg7HMUO6HQZiMAEt2k3moSMvaPLsS6G0892VWxPMRr8epoNKtRmFeSuA0yXkUr3+mNBc0F89ZiTj/sKp1pv04yguCX3jZ4h+1PCJwU7MkIdefy5M6URfg1yttbiV4bkKWA6bgSVBP3UNJKFxUYvYzq6Kcck92SAHAukDwLARtGsKzX2Y2TSqA5OZrqvpL7Opt6VZZTwCqNk/JD9J5oD4ZWix2Lio2HNTjyn+h75ikDW1PDPtTA5Fa9dvpQSHbjDR5maIlyaPVIsKGxwrhaIC4NKUjTzkhcy/iWKg6yo7Z5qOnrLUBjxWEMZoOaX9WeDeooGkmEKUmA9uqTEcdQrVyc3suS9fGHGEm9kUTvGdL+LH37C1B/cUQ841xubBPuASRm0WbXpgiacH13X94V5tRTsmeHPeXSVSOYXye3adQlyw/UkLGrVy8GKV+kimHT8x/RjuSdfn9BE6LZFmzuMcLW193yPcwoTYNgy/1Mvv2qlKf1HEDszTu0+ELCIm+OOZfboZYOlh0HZ3zVSD3+Bmu3NZwzIGR8vXMWIOc7xzL/s0LTW91Nh4HpUABDWLj27MsFHGYVr8yL0wuJEwCWNZQiq22lwmBgXPn8dwLOnU6YrtIpshWhF7/nugBsbn71VnbMhtHjjEoWSTHoP75cpIs5QWXqPvaeJ8cMzJlJCIWfHmP7CpSzskmT/JH56AW9AGCKl1YjrEeQF7mCsErd1JOheWIPrn8LTbmzlpVhf5BdxhoIwQfqa+NPAgs3F8hqIcKlcRkB8261FA5C8v9F/QbG5hyAFssy/oFQVq10xAf7kC/65EZZ
 vImg6Hws
 mo6lOMuIDVQd3qmomRE41At8kGmJIb87MwVoTxEqZV2pOE+UtijsDhNgoHcovnjyTpY127nlvWedK3P/4BN3jWRmAuTXRaGIcZEilLmA7Wv706sFs264q8lUwNzV63R4+S5u09PpzzG0WvC/dCL2CIbVMBj2vdTTaaO+IOCNcZbbW+QrGb33BLFVz8jjKmN3l8SJ89uJjWQuXYt2u6jgjj+8lWhXrD1PDSd6tvggKMTdG3tSwcHgJVEKidlBOlmNixCOYCu9rlJtiWmHfLmXXAyUiDZFw1Qm9oSBpsw/j6/PGup4Am0rZKWcoeTdPloXAvZwp95ObLsps8J4E/AGxyq8bpdQCAiFD594X1iYlzVYR04rnoLwE8E91W+/XgVDaaG29RyT85aDRwE629ar0fuFUpBQt+C7DCgY/BIAdQib1InZUeNndfPQlMiHRzvgeeRKZyhLd8wWZhPSkGkYRN7Br83BbxTqx4hsYAXE0MaqjysOZkUSBcFBaj4dNl6R5Z8Io5tZjENQgnlKFg4uOpXyZmKFXu8tZRNCpFkC0b+28DnXTivB/yfkHziPFRJkFWnSX0Od6aAfQb/R4i0Mq7WCqAjqHBvNK0f6NS4Pn0rurnEWYOwwYyEUjb/sgR4yr0FmVCnBmFy/xt+xTDN2E7aoybfoRaYk1MyW9Mb0+rM31yOTpa5cR1Zws4l8Pwcz4ZgGwRXFEOHdKJ2AePINg5ksrHuWgn1eGE/rQ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 16, 2026 at 12:24:06PM -0700, syzbot wrote:
> Hello,
>
> syzbot tried to test the proposed patch but the build/boot failed:
>
> failed to apply patch:
> error: corrupt patch at line 7

OK let's try again, aping
https://lore.kernel.org/all/b434f7828a4d7b24de76aa5609dadda2871a932a.camel@infradead.org/
as I see this branch is still there (David W - I hope this is OK! :)

#syz test git://git.infradead.org/users/dwmw2/linux.git seb-nonblock-rt-test

>
>
>
> Tested on:
>
> commit:         9b87fdc9 Merge tag 'sched_ext-for-7.3-rc3-fixes' of gi..
> git tree:       upstream
> kernel config:  https://syzkaller.appspot.com/x/.config?x=b454dc6b1b7acd30
> dashboard link: https://syzkaller.appspot.com/bug?extid=c3178b6b512446632bac
> compiler:
> patch:          https://syzkaller.appspot.com/x/patch.diff?x=15a16bf9580000
>

--
Cheers, Lorenzo

