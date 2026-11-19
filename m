Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3CFD9606A320
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 11:35:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aj5juQwK
Received: by kanga.kvack.org (Postfix)
	id 362BD6B05F6; Thu, 19 Nov 2026 06:35:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 313A16B061C; Thu, 19 Nov 2026 06:35:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1DBD56B0608; Thu, 19 Nov 2026 06:35:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E0DAE6B061C
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 06:35:06 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 65044120A5D
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 11:35:06 +0000 (UTC)
X-FDA: 85451662212.15.5C0A972
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id AC22B12000A
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 11:35:04 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aj5juQwK;
	spf=pass (imf29.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795088104;
	b=CYPfCeLPPzTe4c117SkfrsOH9S5/OQ5b/j3KzeZrLvacL15U3ZPjdb4Ta7vuhA6KtsYqx1
	VF4WERqFiUFJOTyqhbZX///ezcEy62qzGInSqrj/JjERdvFgtjfBuQZ88axxuUHBPuVhrX
	5W30yq5ACBvHHcFPykCXZLm4Gb5+WTk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795088104;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8h0AQ2AaFUfn65GPUCjEobw3d58HZ4RkTCU34IcUc0E=;
	b=c7CtbZUTHmvX8K/C60wQVdgZaIiWXM0OOlsbiHTWmaMYUZqUiU3uu/qjvQqEcZTm7DgqAh
	xkhRID4cjRWdx9a9J+JL5sVdvjSeQRWdC1HgqZ1MDr46iMzbGPtNrn27CY5Y34eEZTwokY
	mGavOUg9hGgehaCwflpC22vQTryPBfA=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aj5juQwK;
	spf=pass (imf29.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id DE70C430A9;
	Thu, 19 Nov 2026 11:35:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BC121F000C4;
	Thu, 19 Nov 2026 11:35:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795088103;
	bh=8h0AQ2AaFUfn65GPUCjEobw3d58HZ4RkTCU34IcUc0E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=aj5juQwK5Tgh4ZyrABmScWfWYkyDllKaiWJc/WSAIrRzPaQEUXXSl2RvmoRjhZlgy
	 Iwtn0ulXet4XcF/wTvrORPsbhOWbPQpVB/wt9sRwP53deYja0GZ9btePG2rbbIfUja
	 AkflxyqSNtC+oEu4dIxOhCiKeBX9v04kGl1kd8Czpo1EUkW4yagb9WFHMPukIxMq+N
	 dUEWIukb9n7jR+4545FyhdRgfbBgxQI3vl6Iq8vdWQ9CzD+m2FGgRAjymygKWwtZuM
	 2o/koWq1DPJ6g4Ezf/GHR/xoXEus43tWf0Sz8RzCRwNTVqbExTGqsdCBmhbEJcG/WA
	 kFT8/Ir1NGT1A==
Date: Thu, 19 Nov 2026 11:34:58 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: syzbot ci <syzbot+ci7e1f981ab411668d@syzkaller.appspotmail.com>
Cc: chengming.zhou@linux.dev, david@kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, xu.xin@linux.dev, syzbot@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot ci] Re: mm/ksm: clean up scan_get_next_rmap_item()
 initialization
Message-ID: <av7e0B-1GCyk6sDs@gremlin>
References: <20261115075832.132109-1-xu.xin@linux.dev>
 <6afe9e8e.92f98041.20636d.0002.GAE@google.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6afe9e8e.92f98041.20636d.0002.GAE@google.com>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: AC22B12000A
X-Rspam-User:
X-Stat-Signature: y6bc3ir653w5rzss7etboufuifa7o5y3
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795088104-947254
X-HE-Meta: U2FsdGVkX1+9d5T+RF6Tk/spumAIcCuJFMt7JwHzN24Afoqr+GnnH9ylkQz+A41CYnbcRLF7JecwnzUi5sPw92s5dk6qAi/SAcmm4hmA9sglk9sMiu6q65fM5pgImva+I4fcS3ahEf5bNLjrZUqTaKpiROPj2kmdzPSs/8vn7E/wW7DyPa066QKMhCOgSbhOE/Lr5gBzCFa9DUCtDRzxvQdfDlnaJUcC8bLw2S47b2ylKH6ajHGIvmT808YgMshb8pxur1Gl/YuwS6qb/P6r5Kqh+mc2Q6S6hDeRNLbK3sH0aRDTh1jRk2lOQHp/B/diX3p9OMh492xdlpVpoWrkWn6xa2nPZuy8hxUOhrn4Bf/SvYCIw5qlaTszFCfnR77JbUqxGR81hSFshp09PrFu97sZRkew+xxuPJGiICO6sI+07Up9TUhISS53LrOYTpHte/iJ2dyX79PLmDPXV1Fju0cORYTn0KLJcx71WdQ8mtS/WTmaYVNtNiXvQHxWdel8KdEE1h14Zse41UuKUBtr+j59tqC9ykpfciwWln1UZZPrH34Xj0zzxEGTtqGHcj3r5J4LrAYymbWKuci+pG1QUAH3GmF91tkbttbFzThSU/7v3vwPtvVmMxXJnMlLbgBAr4kvXYf4J0fsY4P+7+I3W98EZg31y5ijbnnNhgpOmQaIVRg2J8tu7ABNd3FcONSiFuPoAIDLCvZF1zrGNO3suOKpF9Dq5QAC4Z/ArPmf7BR0/msbBFWYjyam4VOY3YLp8PkwucEoH7Y9w3VCji0d1NSqoUEXperDlChqazvzb49a5RKTYJrc7s+5cvZ41iZx4WSDJbmhzjqLiGaK5YL433LVCnsmHu064Mh7yFl9pZR2GOs5UxPa5905r8NWeFW12UOHpIZkapXwr+GM/ZpzTYWFXVAgRRtpAGeJs1pJDOlLaebWkj0V5VJkkUT6APMXAy0NbK4MVGuftcz59SO
 Fqb8gvFC
 pJLXzwmFo4saQeWOV64Xez55En8TxKxCg7HKxT20G1W/W7W4aCFm1BxmQDPTWMYecAUFpENBcq5kVxF29Mny25eF2Es1+z5O2H9421nmjAU2bAb1Ib1tOkqDdWBymCQW5EWnFPq3UZXE2hQ9Stu3G6pUg+psJzOK8eZ0olHblTKMwkyeCQ6/DMwe0jVv68tTqjcqz7tHCW/aZf+Ju02YiFZvOyx3v7SyCBKdtzRAYDiXsPG6O9cCgMFYyTpGCcp+K65tdSCf0jdN9L+0i/HBVMMT92uv5ECk/wMBxST5to9oD25HxizeomkKfhQs4zNUYBgAXhk4I25SeCbYJtaiwzdtXzIVDn/FLFZzhOejs4+Gr7GkjhpKAGwAX9WShQR/xbN8i47OrSUjdiLkdBT6NeSLRrmrlNlIGuZ+yu7HBr67Tg5TaaS3xiXa6srhffNrBqTj6rIed+GVcnBdMbLS6seXcLIit9jNBZ44GNBEu/5WYaZYD6KrcQTuor93S/7u1fxhXqG8bz/Z0/4yCJHlgNYkenI69lyax8XbD64+4Dw0181A/T+kdln6cUQg5jGgyaOO6JrYrqjBSCMzc+jzj6Ie7wzW9pCslSPo0rpyHxevkCGZGlf/e0ooWdgbZRYw0RTJyjf9Erh/yBWDjogN6hv8cLMoz6DEf/NKAgnzv7Jj80sBRIWaY8B35kOA2XqQqJCgjzy9tDmcC+d091Qafj4SuhWTVtynbCVv/TFT//6udVKpcVDKT2qEY3h51mgeJRXaxqcAh5cETTAZzAgUZOUYoIfp9PG+aDUXZg7LNmuNKgX4Kf3muzH/Qr30qWLp24zv9zjMMDulr6eljIl5D6JlLrA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 18, 2026 at 11:00:30PM -0800, syzbot ci wrote:
> syzbot ci has tested the following series
>
> [v2] mm/ksm: clean up scan_get_next_rmap_item() initialization
> https://lore.kernel.org/all/20261115075832.132109-1-xu.xin@linux.dev
> * [PATCH v2 1/2] mm/ksm: extract helper functions for scan cycle cleanup
> * [PATCH v2 2/2] mm/ksm: add initialization helpers for scan_get_next_rmap_item()
>
> and found the following issue:
> general protection fault in ksm_do_scan
>
> Full report is available here:
> https://ci.syzbot.org/series/cc51d824-2b5d-4c6d-bd56-c5bdb2bf5e12

I guess it didn't see the v3? Likely this is the sashiko thing, fixed there

>
> ***
>
> general protection fault in ksm_do_scan
>
> tree:      mm-new
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/akpm/mm.git
> base:      3dfc09a9493ddaa5e7722a29165d8450b55b4d3f
> arch:      amd64
> compiler:  Debian clang version 22.1.8 (1~deb13u4), Debian LLD 22.1.8
> config:    https://ci.syzbot.org/builds/6f9c12e2-f68e-40ee-bbac-84e33b709dfb/config
>
> Oops: general protection fault, probably for non-canonical address 0xdffffc0000000004: 0000 [#1] SMP KASAN PTI
> KASAN: null-ptr-deref in range [0x0000000000000020-0x0000000000000027]
> CPU: 1 UID: 0 PID: 44 Comm: ksmd Not tainted syzkaller #0 PREEMPT(full)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
> RIP: 0010:ksm_do_scan+0x5da/0x6f40
> Code: c7 05 86 a2 b1 19 00 00 00 00 48 8d 43 28 48 89 05 9b a2 b1 19 48 89 4c 24 40 48 8d 59 20 48 89 d8 48 c1 e8 03 48 89 44 24 78 <42> 80 3c 28 00 74 08 48 89 df e8 47 3a 01 00 48 89 5c 24 30 48 8b
> RSP: 0018:ffffc90000b47a60 EFLAGS: 00010202
> RAX: 0000000000000004 RBX: 0000000000000020 RCX: 0000000000000000
> RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffc90000b47c08
> RBP: ffffc90000b47cd0 R08: ffffc90000b47c07 R09: 0000000000000000
> R10: ffffc90000b47bb0 R11: fffff52000168f81 R12: 1ffff92000168f68
> R13: dffffc0000000000 R14: ffffea00046aca00 R15: 0000000000000000
> FS:  0000000000000000(0000) GS:ffff8882a77fd000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f15aa3f8c38 CR3: 0000000170aa2000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  ksm_scan_thread+0x114/0x520
>  kthread+0x38b/0x480
>  ret_from_fork+0x514/0xb70
>  ret_from_fork_asm+0x1a/0x30
>  </TASK>
> Modules linked in:
> ---[ end trace 0000000000000000 ]---
> RIP: 0010:ksm_do_scan+0x5da/0x6f40
> Code: c7 05 86 a2 b1 19 00 00 00 00 48 8d 43 28 48 89 05 9b a2 b1 19 48 89 4c 24 40 48 8d 59 20 48 89 d8 48 c1 e8 03 48 89 44 24 78 <42> 80 3c 28 00 74 08 48 89 df e8 47 3a 01 00 48 89 5c 24 30 48 8b
> RSP: 0018:ffffc90000b47a60 EFLAGS: 00010202
> RAX: 0000000000000004 RBX: 0000000000000020 RCX: 0000000000000000
> RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffc90000b47c08
> RBP: ffffc90000b47cd0 R08: ffffc90000b47c07 R09: 0000000000000000
> R10: ffffc90000b47bb0 R11: fffff52000168f81 R12: 1ffff92000168f68
> R13: dffffc0000000000 R14: ffffea00046aca00 R15: 0000000000000000
> FS:  0000000000000000(0000) GS:ffff88818bdfd000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 000000110c27b575 CR3: 000000010233e000 CR4: 00000000000006f0
>
>
> ***
>
> If these findings have caused you to resend the series or submit a
> separate fix, please add the following tag to your commit message:
>   Tested-by: syzbot@syzkaller.appspotmail.com
>
> ---
> This report is generated by a bot. It may contain errors.
> syzbot ci engineers can be reached at syzkaller@googlegroups.com.

--
Cheers, Lorenzo

