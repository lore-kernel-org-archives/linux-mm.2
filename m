Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D2D75C79FAF
	for <linux-mm@archiver.kernel.org>; Mon,  5 Jan 2026 18:48:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3D30B6B0005; Mon,  5 Jan 2026 13:48:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3AB4D6B008A; Mon,  5 Jan 2026 13:48:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E0F36B0093; Mon,  5 Jan 2026 13:48:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 1F3186B0005
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 13:48:07 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id BBA751A90EE
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 18:48:06 +0000 (UTC)
X-FDA: 84298794972.27.2E4FA67
Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	by imf03.hostedemail.com (Postfix) with ESMTP id D0D0620004
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 18:48:04 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=wbinvd.org header.s=wbinvd header.b=Zz1DE4t3;
	spf=pass (imf03.hostedemail.com: domain of calvin@wbinvd.org designates 209.85.215.180 as permitted sender) smtp.mailfrom=calvin@wbinvd.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767638885; a=rsa-sha256;
	cv=none;
	b=dJF5df5wJBA7hb7TZQ6w7e7AVqe5bQYDCkKno4avvgK1Qrn7hkbzg0o+PG6ZJxVblHD7ks
	bRDHgqlFI2iJyed7HHyO1M74k1nkl6uXtaao7mAASkFNrfTzAlLsOfQhjzUBDloy4m9Flk
	qlIC0B4Fz3KXCN2xn8pbcKNm+Y7nE8U=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=wbinvd.org header.s=wbinvd header.b=Zz1DE4t3;
	spf=pass (imf03.hostedemail.com: domain of calvin@wbinvd.org designates 209.85.215.180 as permitted sender) smtp.mailfrom=calvin@wbinvd.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767638885;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=chMEv5o3kSF09Al45ViWmauA3w2qNYkkLOfYS/tlHhU=;
	b=EgS6UZd2tfKclhTrs1vb5ar4Blr9rh2XqhGCtH23BhjS/N/4aX26YXxJ6f50etVAvvsIAy
	BpihcJ2dYRBChn1HByie1PZDANXrw4esfYupG4NDYmFYQGf5nrAoMxlITXr4fQXeF1MIK2
	H5qReuq5q3g1fmsgvYZiV33x2oi0pS4=
Received: by mail-pg1-f180.google.com with SMTP id 41be03b00d2f7-c1e7cdf0905so148111a12.0
        for <linux-mm@kvack.org>; Mon, 05 Jan 2026 10:48:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=wbinvd.org; s=wbinvd; t=1767638883; x=1768243683; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=chMEv5o3kSF09Al45ViWmauA3w2qNYkkLOfYS/tlHhU=;
        b=Zz1DE4t36bN26rxbV9xEI0peaEaNGlIc6hF5GGQRj4+DKYYpfmIzVB62Ih/9BaVdSY
         86popTHOIGpS+B1gzfYa69Jf4de8phZLiiYHo0QItz92cN4sw2E9KFYPFkDm/CaPaeXJ
         23+abgVzBUzmYge1fzntI3Jz6iWFtPNYPqCmBMv7wieZR4lWlNoyD3vaNc38ez8EZ6ea
         DuwA4FrN9tQLH2UfnN4pnY/OmGYz7h+6CxqhKiO4W6jUdlqZ4dCdjL4QK/BHV+dOv1eK
         HrcRbdpdjm98nq5rDsbZUAMqjMSFPNCI0NOoIIqSfenmRKbzN27UnBFkb7bapuSPd4Lq
         x7aA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767638883; x=1768243683;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=chMEv5o3kSF09Al45ViWmauA3w2qNYkkLOfYS/tlHhU=;
        b=nAH6q/PzaCznnp+vPMJrtNX5SOkUsGWX1Fw1swbvcKRfEj6CSIktzWomkczYXmurCd
         QcET2HgIQ0vegmOVNffWo+bQwmbgwKMVbPoKdqNz33kmb/odoeHvuwvLOHoO9Ukr7BWN
         kZallFSgtJQZcJFKgNcpgg5/hekE2N7LktfizgwBupdWyy61Mt3AHRJk3msq+inSI85L
         zN/Q8Eqjx8Bph+v91+5uN/hEyiQ9n0b2EeDQ6kd3uxd+l+cQ97zDXzFCH9Kw9ITfY7dg
         NhGRaSuX0YWf9zBqzd7VhRPrQkK7qnuOIQi9ij02zAA/X7y4qx0efl7Ibbu1HEFZ576g
         Wx8w==
X-Gm-Message-State: AOJu0YwpU8HF79GwrAl0Fo8At+IG72yaa1gSkynBu6OexCWiwLcmxNEk
	NszThsQkuMZuDBWpPvtGBq/hpkgk1wkSBlfG5y0IK02uElUxdaql6kEpRMIjeM2uj+w=
X-Gm-Gg: AY/fxX7cwyoYkz5KqZ3tqRt15Pir5QyOu0pU0lZJb9TtsQTBxXxrBhwe1sA1juS6Go2
	a8Rcfy77U+ujXF4biktPPU+0wVoJuuHRa5ejqfk5G4tTfylEKaWc2iEbVhKPqRL/r547H0GTOE6
	HHvRABhGHeXAeKC9MVzAhEdL9NzzTbEgJs4VRSto1PdwjXo32bDyX2H+W94D0QYKu3vxCiu4Zci
	WXUnnH0TjC0I6iPweShiWWTIdpG/qzjSgK2iusl8BX+GXQfcyepcc3HXm2hllbR+BtPN0n0uUEa
	xhNRs6FU7lNT//150VIdjl6OQh5sUvasv5tzM85BigWnzxh7MERiQDsRZcEJmQq48Gxa4y4edYk
	q8t+e4kXmF/h7YC2UjAQC9Y5CQlK7lYihI4HJooKqtW2wR8vtc6SaLGbds9Nukf+Y7ECHOZk4qT
	jSCAprkg7YwLaCJg==
X-Google-Smtp-Source: AGHT+IF6tlwdt5uhWGsS2Z4Tcr1PkMoUhwnvi9ygLcKdXTfUccXaiKBlW4osOV2SnY1bDIee0dYn5g==
X-Received: by 2002:a05:7301:6583:b0:2ac:1b61:ae1 with SMTP id 5a478bee46e88-2b16f904d1emr193843eec.26.1767638883456;
        Mon, 05 Jan 2026 10:48:03 -0800 (PST)
Received: from mozart.vkv.me ([2001:5a8:468b:d015:feec:4b73:3a24:90d5])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2b16f2eb216sm622252eec.31.2026.01.05.10.48.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Jan 2026 10:48:03 -0800 (PST)
Date: Mon, 5 Jan 2026 10:48:00 -0800
From: Calvin Owens <calvin@wbinvd.org>
To: Matthew Wilcox <willy@infradead.org>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: Re: [BUG next-20260105] khugepaged: kernel BUG at
 ./include/linux/xarray.h:1441
Message-ID: <aVwHYFesgoSSbKmz@mozart.vkv.me>
References: <aVvz3tYdu49TGkjI@mozart.vkv.me>
 <aVwB3t2wD6Dyt6yT@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aVwB3t2wD6Dyt6yT@casper.infradead.org>
X-Rspam-User: 
X-Rspamd-Queue-Id: D0D0620004
X-Rspamd-Server: rspam04
X-Stat-Signature: k7hr4nbkt1smkjdxrigcn6ayqmgojdjg
X-HE-Tag: 1767638884-780773
X-HE-Meta: U2FsdGVkX1834S+ghVTZWp46GZ+5ngJmZbr5Y8QJDTwg4jsElX/DcHBAVzFgZYTrAH+m+5DWP8qTtDrgnmbj1hqEZl5IxpcB+vocmfwy893D4hnMNqv5G0VgqeE9Gg62glZFLCAOETf0GhRp0p2QGHXv+O/vDcToy+z2R/9fOXowTRo0B2rCSNIeZ4aR6KV7c4cAdJjWiVRmlCgTxzY94Q2GlQrj7vdQYvjhpUP9KFSzA/wCyVjZqZNXG7GikVxGtNkjHgQ/v+jskdadaUXU/7OMLWlJuxlgsj7rS9mie4WyJjL76805FQIrLeFktcvMyotS49ObpcZG1emHUAE7zbDxUYL4E5L4H6ZHk19FfLcOUD9oR6q0EsQEMgqqaJnBKNnjDPszKR3ZAHNCoZzvJRQpRhO3bhocxdnckpUBmFAPuzM/qG3+Bya9uiXegMAIiTZjSiTJlFXUuXjiGUXf0LEDvyhVJYlYQPQJ3OFraITwyLTjceOMARGBh3Rs+w2jGqsblbvxPIkh+zwsubi3fEDORg4axB9NyQ0MUDMWsB1ghng20/17ojqSImaBsH68gvlVuQDFC1as3dd/G7mvD6N8tNuC1CO+gqWKgKFQa7XN+tbjDCAqtdQWSzOtZd9FLYY7ze3snfSCsryIE3zBUu+PhV/0XEKKRcCG+VPjE8M6nA1vCgPekxn+C5Clxr+0qaK52QqFikHhbDB6E7sykuPOHK/oLaY8oeeTkOd2iJyoa845J7vDFcyaaQimPQGrmcTLYA6JWrNdJ6hHwoEKy45yFw9xQAl2Tjb8JklYtyFRqLLEzksaj5ipA6fyuERXpNBtZ4403P12lgKSbMOeLFiyeGu969NXeqna1oTWI6u7C2mf9j6UOUpoInlap6rICkSN+5zn+GYQFc65SWSQ+3jYmY6eXe5RBp8nZ1GbN9INIsrFLrfqk9Lw2965XVWq5pD6AMWfJkVX/W7acfr
 u2/u1Qa9
 R5wBBtS5MbbiKo9n6oGGZ7tHBJfSP82jWngSYy6ynxHZWjj0x27nP9eLVIk0w/cTR8hHorQ57uGFguk+SNZznMr28W19H21GHW/mQkVrqP/N9OufWGiPSY/i4/cWVinbgE1P2mgKa3lseRAX3HpthGeT4vnJ+BDotRPWpiwRwr7QWz5ftfvhhNIdUrueiuoC8pe3QWzl/1wQUjm+03W6Yw0zrr9uWwYysDqFbd6q3R2Eo56/Zv9OgjAQcvO0vKDmm5s/nkMNkN2sEz/PuoaGgGHSkKEg87i4w8YDgMlAhG461yRAAQe2ANDoDZjiorPIFTmVggG732RW3kWCM9y5trjMm3vEIY48FZrcQ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Monday 01/05 at 18:24 +0000, Matthew Wilcox wrote:
> On Mon, Jan 05, 2026 at 09:24:46AM -0800, Calvin Owens wrote:
> > Hello all,
> > 
> > I'm hitting this BUG_ON consistently after boot on next-20260105:
> > 
> >     [   17.103774][   T40] node ffff888102d43918 offset 0 parent ffff888102d42920 shift 0 count 64 values 0 array ffff888107432e38 list ffff888102d43930 ffff888102d43930 marks 0 0 0
> >     [   17.108851][   T40] ------------[ cut here ]------------
> >     [   17.110476][   T40] kernel BUG at ./include/linux/xarray.h:1441!
> >     [   17.112321][   T40] Oops: invalid opcode: 0000 [#1] SMP PTI
> >     [   17.114177][   T40] CPU: 1 UID: 0 PID: 40 Comm: khugepaged Not tainted 6.19.0-rc4-next-20260105-x86-hardened-yugetlb #1 PREEMPTLAZY  a1685c863f468289fb411d1c9b04bc9e336fe015
> >     [   17.118934][   T40] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.3-20240910_120124-localhost 04/01/2014
> >     [   17.122375][   T40] RIP: 0010:hpage_collapse_scan_file+0x1b05/0x1b30
> 
> Could you run this through ./scripts/decode_stacktrace.sh ?  I'd like
> to see which caller of xas_lock() triggered this.

Something about the instruction decoding is broken with llvm, but it
still pulls the line numbers out:

{0}[calvinow@handel ~/git/linux] ./scripts/decode_stacktrace.sh vmlinux < ~/stack.txt
[   16.027866][   T58] kernel BUG at ./include/linux/xarray.h:1441!
[   16.030181][   T58] Oops: invalid opcode: 0000 [#1] SMP PTI
[   16.032294][   T58] CPU: 3 UID: 0 PID: 58 Comm: khugepaged Not tainted 6.19.0-rc4-next-20260105-x86-hardened-yugetlb #1 PREEMPTLAZY  9ffdba64952937e3f0143c6f15435a9a9e8ec86b
[   16.038092][   T58] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.3-20240910_120124-localhost 04/01/2014
[   16.042275][   T58] RIP: 0010:hpage_collapse_scan_file (./include/linux/xarray.h:1441 mm/khugepaged.c:2042 mm/khugepaged.c:2389)
[   16.044711][   T58] Code: e8 d5 b2 ff ff 48 83 c4 18 65 ff 0d da c8 8e 01 0f 85 5a fe ff ff e8 6f 1b d6 ff e9 50 fe ff ff 48 85 ff 74 05 e8 80 4b 69 00 <0f> 0b 48 85 ff 74 05 e8 74 4b 69 00 0f 0b 48 85 ff 74 05 e8 68 4b
objdump: error: '/tmp/tmp.oGg2U9eb6N.o': No such file or directory
objdump: error: '/tmp/tmp.oGg2U9eb6N.o': No such file or directory
All code
========

Code starting with the faulting instruction
===========================================
[   16.051928][   T58] RSP: 0018:ffffc900001ffca8 EFLAGS: 00010246
[   16.054183][   T58] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
[   16.056731][   T58] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
[   16.058926][   T58] RBP: 0000000000000200 R08: 0000000000000000 R09: 0000000000000000
[   16.061226][   T58] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
[   16.063446][   T58] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[   16.065658][   T58] FS:  0000000000000000(0000) GS:ffff8882b4ff0000(0000) knlGS:0000000000000000
[   16.068581][   T58] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   16.070783][   T58] CR2: 000076192552d16c CR3: 00000001398b6004 CR4: 0000000000170eb0
[   16.073466][   T58] Call Trace:
[   16.074591][   T58]  <TASK>
[   16.075560][   T58]  ? __cfi_workingset_update_node (mm/workingset.c:614)
[   16.077556][   T58]  ? khugepaged (mm/khugepaged.c:2473 mm/khugepaged.c:2572 mm/khugepaged.c:2628)
[   16.079077][   T58]  khugepaged (mm/khugepaged.c:2474 mm/khugepaged.c:2572 mm/khugepaged.c:2628)
[   16.080522][   T58]  ? __cfi_khugepaged (mm/khugepaged.c:2621)
[   16.082140][   T58]  kthread (kernel/kthread.c:469)
[   16.083529][   T58]  ? __cfi_kthread (kernel/kthread.c:412)
[   16.085063][   T58]  ret_from_fork (arch/x86/kernel/process.c:164)
[   16.086603][   T58]  ? __cfi_kthread (kernel/kthread.c:412)
[   16.088156][   T58]  ret_from_fork_asm (arch/x86/entry/entry_64.S:259)
[   16.089751][   T58]  </TASK>
[   16.090774][   T58] ---[ end trace 0000000000000000 ]---
[   16.092603][   T58] RIP: 0010:hpage_collapse_scan_file (./include/linux/xarray.h:1441 mm/khugepaged.c:2042 mm/khugepaged.c:2389)
[   16.094787][   T58] Code: e8 d5 b2 ff ff 48 83 c4 18 65 ff 0d da c8 8e 01 0f 85 5a fe ff ff e8 6f 1b d6 ff e9 50 fe ff ff 48 85 ff 74 05 e8 80 4b 69 00 <0f> 0b 48 85 ff 74 05 e8 74 4b 69 00 0f 0b 48 85 ff 74 05 e8 68 4b
objdump: error: '/tmp/tmp.iup3T2wP74.o': No such file or directory
objdump: error: '/tmp/tmp.iup3T2wP74.o': No such file or directory
All code
========

Code starting with the faulting instruction
===========================================
[   16.101366][   T58] RSP: 0018:ffffc900001ffca8 EFLAGS: 00010246
[   16.103417][   T58] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
[   16.106095][   T58] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
[   16.108764][   T58] RBP: 0000000000000200 R08: 0000000000000000 R09: 0000000000000000
[   16.111474][   T58] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
[   16.114304][   T58] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[   16.117128][   T58] FS:  0000000000000000(0000) GS:ffff8882b4ff0000(0000) knlGS:0000000000000000
[   16.120308][   T58] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   16.122638][   T58] CR2: 000076192552d16c CR3: 00000001398b6004 CR4: 0000000000170eb0

Thanks,
Calvin

