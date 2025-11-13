Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 11213CD4F2F
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 03:48:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5D3BE8E0006; Wed, 12 Nov 2025 22:48:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 585068E0003; Wed, 12 Nov 2025 22:48:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 49A2E8E0006; Wed, 12 Nov 2025 22:48:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 351428E0003
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 22:48:14 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D48364D1D0
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 03:48:13 +0000 (UTC)
X-FDA: 84104200866.09.45B3C48
Received: from out30-101.freemail.mail.aliyun.com (out30-101.freemail.mail.aliyun.com [115.124.30.101])
	by imf08.hostedemail.com (Postfix) with ESMTP id E7766160008
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 03:48:10 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=EJqmmKf3;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf08.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.101 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763005692; a=rsa-sha256;
	cv=none;
	b=6mc+Sx+ftPuek5Ug7m1t5g9J3htPvR8mREL4SH8XCtxdS02B2Dx/AmQzL5dfSza0xo96mG
	txyRn1hKYj12pmIEFFFQRXM7cVmbxxjZKacixcn8P+9Wi/6mxqD7TfKHjnqEs8fMgdcyGA
	35/EgrMMtpmNtXBsN52yiTjfqNM3NuY=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=EJqmmKf3;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf08.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.101 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763005692;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NQ0cb143Fk6+kUWaeT8PET+2Q8tlg6Zp5AevuF4vT2M=;
	b=10R8OowcuFaoKp+nvWIzwYZTxE7U8orLUM8Dv4Tv6t6S6NMDsenziQsPdv4mwRx8hhIkJT
	OiEioAnbOivC6z4sORtq5QcQDXm5D0yP4Q1cBkQpSOZmHmyElXp/UaT5eayyFCAA/saEEC
	lRBPqnkjyQEyyMmSYRNsTVhmrX31MeU=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1763005688; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=NQ0cb143Fk6+kUWaeT8PET+2Q8tlg6Zp5AevuF4vT2M=;
	b=EJqmmKf3QookOou5tNTsO634YhVgLofRWtlh31XJfhK5wnjzgALB0N/USFXp1qJ5mn8IWQNJJ3tRpHEFpp59txcTBKqZgb7DkhcaUqR5/DrFmspTi20nmuxOtnzcjaJlrs55v0taZc9ZcbN6RF+UOAYCGKYcPGJYTQ7dy3WEOsc=
Received: from 30.180.123.14(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0WsI3wdv_1763005686 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 13 Nov 2025 11:48:07 +0800
Message-ID: <e1d26f84-7ea2-46de-8ab9-31e49b485832@linux.alibaba.com>
Date: Thu, 13 Nov 2025 11:48:05 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/4] make vmalloc gfp flags usage more apparent
To: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, bpf@vger.kernel.org
Cc: Uladzislau Rezki <urezki@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Christoph Hellwig <hch@infradead.org>
References: <20251112185834.32487-1-vishal.moola@gmail.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20251112185834.32487-1-vishal.moola@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: E7766160008
X-Stat-Signature: od1aa3bwk47cbfak99opop51zskcw3s7
X-HE-Tag: 1763005690-563683
X-HE-Meta: U2FsdGVkX1+hLcaM9G7FdrJleHO//CR2bkXx5cIk2nBJmlbkYwP3cfzV8gGjc8OhIzs76aKy4XclN/NDZIDtUpxzTHuqFHxGvjceJv0Ibh7+wjnUWefjrIiHg5KCGhMBqOaD7vZDhgah0aLxpkteuehV8hqO2E6OWgKylZLbLNSQDJBkgvV+xPuqk+wtnaaell4CQTj8Qilwg94kvQ62r79OHojs2VkvxJ7v9d39p+CSnzQwQF9BaAIvNeVLE1+hmKcHJ6vwJ+fufCJfmEvYOG81GrEc0I5DRgAHbDeWfyOG/gSPRKdGqN8REQVo47IrlJHHZUN2ndEoQmwoVUtdTDXhlNe2G3Xv5Rl0I/tBpQ5RX/PVoPc+zIkzSa2DaaEUIANczjl4uXYsB53Ed/r5xXSd9UQDp5n4YC5mOpRaLluD5dwRXbQtKUmj0vDB0HMGxysrHnrFXwyeCxiRJalznvA6EJ2R7zUuIeMviz+BmgycpSGbrsU4hfxOD8HxWuH+PTtJeGRXmrfc+zNWawu9vCLQqeH1/rJAODIfXwvOK5Ln9sWTCsV4/zDj8J0vsy3WFtGMNRE6MbXmi+jFQQ8S2oXUcfNwZSLJyZ30xo3+FvY1fsJFvlV9Yf+pVwmTNmVC9pwewKTlBKBho3JTI+0Qx61+wY07Xb6Ez9WJT316TqgBFT8cuOQIKmHFoPMBUJJi7n6ZhpKkAQLyzdlDBuc785gGc3ETLH81HdtRzZNeH+pQYqoSfqgLnqRmVf9UFkT58J7pm0LFc+8osC1Qur8gbEHQVmjEnfbSGxwCCujeK1R9TJXrTmTzJdEQKrRLPi/r75zxrdQHwfGHmayZ8aQ9UooLwSRVI8XYLTst9B9N243WB2B43QPY5tIuKFOMZJZlfWnOXuSEqj1OHoPCs8gJ1EmAs/DKlBd9expL1kKEv76vXEjNxxSv6LvCowGP6CtEBFtCYff9tdi1bHYTtH8
 MZuBXH+u
 5bVAUT5sVakPm7MVFCYPuJxEMDfq3osbUgCMQTXdJpXy4Gxzfwdwz8Lhm9YdeMRv8t1aJrtypVrKeo00RUeexrpoNjWoWTuk9XJBAZCRE+t3OT9P44cLo/Vng5cNHOvxEULVNX1BNVqBZbvFUc2vKMJuY/j/Ez7J1OTSts6WUWS14Md7FIYCZb+jJ5al+FGTD4481p8n5IMyFhm8YIzHAF8M/k9PjUiWG05pPPGZf/93s4I5XThJ2223+cymO/nYDdyC1Uai4gBNh4l0dm1ossmH6MDQh9am1EDuQQXr5aP0T1thFdJ8PaXPYIsaV4Ui0qRc7N18clMmzY0sMy54n7NahNN9GLEaVWAp8h0O+OO56+ROxFfskWrgg6lkJwdpPAl/h
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

On 2025/11/13 02:58, Vishal Moola (Oracle) wrote:
> We should do a better job at enforcing gfp flags for vmalloc. Right now, we
> have a kernel-doc for __vmalloc_node_range(), and hope callers pass in
> supported flags. If a caller were to pass in an unsupported flag, we may
> BUG, silently clear it, or completely ignore it.
> 
> If we are more proactive about enforcing gfp flags, we can making sure
> callers know when they may be asking for unsupported behavior.
> 
> This patchset lets vmalloc control the incoming gfp flags, and cleans up
> some hard to read gfp code.
> 
> ---
> Linked rfc [1] and rfc v2[2] for convenience.

Just FYI, I hit this warning when booting today's mm-new branch.

[    1.238451] ------------[ cut here ]------------
[    1.238453] Unexpected gfp: 0x400000 (__GFP_ACCOUNT). Fixing up to 
gfp: 0xdc0 (GFP_KERNEL|__GFP_ZERO). Fix your code!
[    1.249347] WARNING: CPU: 27 PID: 338 at mm/vmalloc.c:3937 
__vmalloc_noprof+0x74/0x80
[    1.249352] Modules linked in:
[    1.249354] CPU: 27 UID: 0 PID: 338 Comm: (journald) Not tainted 
6.18.0-rc5+ #55 PREEMPT(none)
[    1.249357] RIP: 0010:__vmalloc_noprof+0x74/0x80
[    1.249359] Code: 00 5d e9 6f f8 ff ff 89 d1 49 89 e0 48 8d 54 24 04 
89 74 24 04 81 e1 e0 ad 11 00 48 c7 c7 68 b0 75 82 89 0c 24 e8 7c bf ce 
ff <0f> 0b 8b 14 24 eb ab e8 f0 61 a5 00 90
  90 90 90 90 90 90 90 90 90
[    1.249360] RSP: 0018:ffffc90000bebe08 EFLAGS: 00010286
[    1.249362] RAX: 0000000000000000 RBX: 0000000000001000 RCX: 
ffffffff82fdee68
[    1.249363] RDX: 000000000000001b RSI: 0000000000000000 RDI: 
ffffffff82a5ee60
[    1.249364] RBP: 0000000000001000 R08: 0000000000000000 R09: 
ffffc90000bebcb8
[    1.249364] R10: ffffc90000bebcb0 R11: ffffffff8315eea8 R12: 
ffff88810aac98c0
[    1.249365] R13: 0000000000000000 R14: ffffffff8141abe0 R15: 
fffffffffffffff3
[    1.249368] FS:  00007fbc9436ee80(0000) GS:ffff88bec00e1000(0000) 
knlGS:0000000000000000
[    1.249370] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    1.249371] CR2: 0000562248eda010 CR3: 00000001028a8005 CR4: 
0000000000770ef0
[    1.249371] PKRU: 55555554
[    1.249372] Call Trace:
[    1.249373]  <TASK>
[    1.249374]  bpf_prog_alloc_no_stats+0x37/0x250
[    1.249377]  ? __pfx_seccomp_check_filter+0x10/0x10
[    1.249379]  bpf_prog_alloc+0x1a/0xa0
[    1.249381]  bpf_prog_create_from_user+0x51/0x130
[    1.249385]  seccomp_set_mode_filter+0x117/0x410
[    1.249387]  do_syscall_64+0x5b/0xda0
[    1.249390]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
[    1.249392] RIP: 0033:0x7fbc94f4c9cd


