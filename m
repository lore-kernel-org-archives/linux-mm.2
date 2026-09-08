Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7A3E5C79F9E
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 02:25:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 618626B008A; Mon,  7 Sep 2026 22:25:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5CA116B008C; Mon,  7 Sep 2026 22:25:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4DFB76B0092; Mon,  7 Sep 2026 22:25:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2E2296B008A
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 22:25:22 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A72A3160336
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 02:25:21 +0000 (UTC)
X-FDA: 85189003242.11.1A6DA97
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id C6C91180006
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 02:25:19 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=IPA0AZuv;
	spf=pass (imf24.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788834320;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kyC6PIbuT8dlKX659Wv2R7Hm4MyHFdmpIgRaeCm0t0Y=;
	b=gJSWJ8W6eulXuqWZh+2RpQ+RZ/hx7TzYQbm4TnJNAHBOHx0rHewTI8DOxOj/xvA+vcBbeN
	S5uE6kppTVQbHbSPZpgRA7im7mm77EdbS/hhr5Lo2HJqdDAX5iLrsDAnNSHOEgFbw0Zz7m
	PzrGoIlfGFcQnsKBsSz4zy2zJ1+R17A=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788834320;
	b=bsjSMWcpXFL11NtZIhkebNECKVCFwleJzBOeiZOMOl+S/0T42ARJ3+k92U1PvwhuzGAP3X
	96cWDjyGUNCWQqkpngyMWVeXBLjICooOIsynLi+LBHMuShGG2cKAk2gBnLNPnd1iP1MYfD
	ITVRvKvxls5LsjEV4LiDds3Z3N+90HM=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=IPA0AZuv;
	spf=pass (imf24.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id AD96A40520;
	Tue,  8 Sep 2026 02:25:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F36F1F00A3A;
	Tue,  8 Sep 2026 02:25:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788834318;
	bh=kyC6PIbuT8dlKX659Wv2R7Hm4MyHFdmpIgRaeCm0t0Y=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=IPA0AZuv2jlRq1y4r1GyCbstGQvj1i/43ql3kFZp5AnOXOfX69Hgrr2Bo2b8RhRfo
	 hozPxnQnfO2D65PE8odXXjG8zu/XhnUjjA3gtr5plBy+QJZvL24L7Jg+2sgCKezZvU
	 U1PIitXd6oQNaU2FcYZnDxU/PsgovGsg7HQpWavI=
Date: Mon, 7 Sep 2026 19:25:17 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: syzbot <syzbot+c6879dc677a017f0a21b@syzkaller.appspotmail.com>
Cc: jannh@google.com, liam@infradead.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, ljs@kernel.org, pfalcato@suse.de,
 syzkaller-bugs@googlegroups.com, vbabka@kernel.org
Subject: Re: [syzbot] [mm?] WARNING in vma_add_pgoff
Message-Id: <20260907192517.564ea15aa8c9d47669b3a81f@linux-foundation.org>
In-Reply-To: <6a9f6315.6e6c5f9e.28f11f.0002.GAE@google.com>
References: <6a9f6315.6e6c5f9e.28f11f.0002.GAE@google.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: C6C91180006
X-Stat-Signature: d3w3qjurdgx1iobirrj51kq7ee4hf1q5
X-HE-Tag: 1788834319-308963
X-HE-Meta: U2FsdGVkX1+gXPnchXvO8LkjZiQ//zRxIYPGMVtAYYth7RTqa/BmolsYQAdRdCouNtedhjJaJWqVamlqzxdMiOHNVoHhUDMYGPPUY1CruPL6ye2xzMSmrrXoMCIt8mgDqU1mmkJMqiPrnd7FO2AkK7JKvhJUUrfjTgP8ll1Q5PcqkuXPDK+KWSWxmJ7/cix1I/J03PbYimVw9oqVt4po7J5ravOWbCP4UsGUHMp0us6jmbjWYEBqy/deAvKaFZ95pFYBryuMULG2KkhfXdKaigxlKhwF4zTyyfzDLJ7d8Bf2Wgx5xGII3HiIdSZSlKuuKY/LJg1MJPzSNhz/UVBUSRYqaFnLVyCMQo9aopFKXOown3KKUGs7kdQRytQVjswmfJpHZ6wSydIccBvDA5CFpyJm730vpuD+yPLk/sznzLJnyxcN+9Tdf03rrRs/DeKotZ7pgk68653ic04xVW1klKRhnxh9n8KPovey8yXRYcFbxSsybH9k/fvwBlzT7MrIdXrXzYuDetnz23KYTA/4KYasorC1rGhZ4wIr3sM0PSaRrViRfQP19kPZ8423jNfnoxmShd6U2RgaObDWOm/En6Rybc/nz75E4hocqjQxL4qDyFHzsnaHrb9/01hfdXMjNdKC2vqBZoR0bU/n68tJUy5Q+tUUi28RnvBfCcxGFEWg4HL8YYXe8DYha88JY2sBg2YqmxhiVuKJXVL5f2clhq7+rxuIpPU3vJERmn+EBf8bhvPSvNgPnNZhy/NLmlHAU0D/vcUQyMnIeJ2RAVDmjCRJHg28dJ82BJ4FDBAW0cJ6ClDjaqfJFLiygBs2Jkq2yN84K8m80y44Wk5KQR0LvBfH67jp6lsJHswiGw/fl8+9YjcPsBI1XqaUYTU0bV9YD7ICikUJmt7oZc2SVayoiMAi2jbm4NltPL51DukBN9hcwMRQakkiQPKG7EysHiJm4aMokdv7DqYtsrNOcdQ
 2Jzr5Y1i
 yKd6xGEGhTj8bwmhQTLoHC7JTbbfHxb7vqLSbySHURtDDtk9TBK9Djbm0zUvywqsH+LYxW5T50g2SZtd6xvmM7ZvBI6SejiJ+WxCyuJLmBHH7JKxtRFlhaaA/oHPSPkHK9z5cqo7ov3lzidiwE9I33nMYPAZmY6up2IR1LAYxlqLG1/7XmMk/0ZsO7gbbPXHGlsDxCiU15dnuSj4KD3qshZWGx6U6sx+tQv51i0hqQtyrAODbBJw0EQzhCBudTFq+Apx5jM9TDrorowf+5Uc5PJB0r7TdTsYHiRYWBR7eEVZgqqxewsouAsNLdxICTzVDQ33pA6VJzHqm6wLDthOanrs9HgO9AkpjqFWelCokndsOE4DXpDuvmgbmAFT2vj5oty1Ufyi8XNZtuXncV+/IjlaXXAyzhtO8S4EtVUG2rFfdAhuI+ovMzglTGEPcNOg9GCqb8ZU9X6lwAbbnGxxPBiEpZevX3uxicanTOe+7mI1mz2UBCNiVDBxgzuRRVBPWz1xMAl5vrvit0KhRs8VPYUGCrJdhN6R9V3dSd9Dd6nUorTrKbRZPayP4uyP4ZOrrSc4xwf5BDnaKA9IZnJhLIQeHA8I0XUpdfXAQtwV2sZX0c74jXDDg7AJT8YjeSWFtMdbEZx23Z2W6biw5eBdFRzd3O1H2T1yiVu56IATkPkRgkFuzLP95ye5hfdAuo/vHYJxPP//4NMioBuj81Zrzldql1SDPCapFz0rSuQJ3MzpfS+3QOZ6XzP/65C+qLtkq1ikJphrSIRz239knYBx40/TrgSJhHuxriXYOOH7GC36MqKzLIqYS6cdaPs1mfsg/5eJizFqPwB/NSssJl5dbokFC/s2yrrmU27yDuyE+mRIZs2uNVh918cG5oav5CmgF/VqVeQSaCITNRpvWajkaGSh/4MLDVTUFV8a7iNu4BqX2I8hUMJo50iWcZ8gxLnuN1/dBVXFMi3f8NQWBRMDJZTRkvh1A
 4ybvILuP
 eSMqBKmyIBjjTDpbUv8r3g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 07 Sep 2026 18:21:25 -0700 syzbot <syzbot+c6879dc677a017f0a21b@syzkaller.appspotmail.com> wrote:

> syzbot found the following issue on:
> 
> HEAD commit:    5445d6419962 arm64: Don't read GMID_EL1 when MTE is disabled
> git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git for-kernelci
> console output: https://syzkaller.appspot.com/x/log.txt?x=1517ecf9580000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=56ed23170c168d4c
> dashboard link: https://syzkaller.appspot.com/bug?extid=c6879dc677a017f0a21b
> compiler:       Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8
> userspace arch: arm64
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=147ad125580000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=127ad125580000
> 
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/e8b70e3bd109/disk-5445d641.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/e5227e56ac93/vmlinux-5445d641.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/54905f78be59/Image-5445d641.gz.xz
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+c6879dc677a017f0a21b@syzkaller.appspotmail.com
> 
> ------------[ cut here ]------------
> WARNING: mm/vma.h:277 at assert_sane_pgoff mm/vma.h:277 [inline], CPU#1: syz.0.17/4912
> WARNING: mm/vma.h:277 at vma_set_pgoff mm/vma.h:283 [inline], CPU#1: syz.0.17/4912
> WARNING: mm/vma.h:277 at vma_add_pgoff+0x50c/0x700 mm/vma.h:314, CPU#1: syz.0.17/4912

Thinking Lorenzo already fixed this.

#syz test: git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git 35b0fb391b0df57383bc15985bb769f4555c97ba


