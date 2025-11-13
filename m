Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2A1F9CD8C94
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 16:01:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 43C2B8E0006; Thu, 13 Nov 2025 11:01:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3ECB38E0002; Thu, 13 Nov 2025 11:01:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2DB688E0006; Thu, 13 Nov 2025 11:01:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1850D8E0002
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 11:01:34 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id AF1584D65F
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 16:01:33 +0000 (UTC)
X-FDA: 84106048866.09.897FCB1
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	by imf21.hostedemail.com (Postfix) with ESMTP id BF2D61C0018
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 16:01:31 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=UbINxP58;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf21.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763049691; a=rsa-sha256;
	cv=none;
	b=GrYZ0Y6gfjl/Ui0PRYDW7wvjxxvEu44pYuiXeGagxEe46SSAdyHpR5a1kp3urnpUUYRdVZ
	i09LCOVR1nBGe5Sh+7h6OLbDqv9oQ6G2eRbqniLs2Lw91MgWMnjYKlPZ5RrtSdZhyiTRcV
	MN72e9gBem2zu9t7bIb6HuAKtyKjoEY=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=UbINxP58;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf21.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763049691;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CgH63ny58lKBouubCx45/ogsbkG1mv62vGa6krsx4L8=;
	b=8boyVzzdPgW0dbtYvg0H+yZr861zoK3QWgoi4Yq01yULsSq9f+5aH2yR2l01e9iciEh8j7
	m4RCwyVPO8hdgOSmU6z3Jvv4LxhgxObcGlFx7uQtH0LJOtP++JBoSOgSZ9fokBAgVaHejc
	oqS2zuIebbEPKNhi7MPfbxA5zSJCzt4=
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-29558061c68so12813625ad.0
        for <linux-mm@kvack.org>; Thu, 13 Nov 2025 08:01:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763049690; x=1763654490; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=CgH63ny58lKBouubCx45/ogsbkG1mv62vGa6krsx4L8=;
        b=UbINxP587Gmdwr3kJiO8brmcWjQJ/mW9dAE/LNrz12cNPj8/qlPRQ43fjIYP0jjIDM
         a5aTD1SZuYeLVVhpRaiyJalyosG/EOPrsVey3VWJywh213UHGcG5dGRX38+Anp6l6kbk
         PmYbBfGycyTNPbfOtF0jhVoPe7Apz+Ww4Bkg0Hi6HY0mHvBqJf/iDiu7mxC6AP/Gcqlk
         t+cGtDJSlubMY0o7L6AKMVIfk3F67EVlh2XDSyvKqm1NjpHNcnjfBpfXAOdeXHQTTl3e
         D2Nxvxq68/Ry0S1cFK1mTz0Tn+ZznnX7qncqzj1B5IZNwpPsyOG5TgY6x2NNWrM/zM6Z
         lZRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763049690; x=1763654490;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CgH63ny58lKBouubCx45/ogsbkG1mv62vGa6krsx4L8=;
        b=gTkK1w45UQZDblgGrUZMxjoK32m4QV0Teev6GC9QfLyRz8IH7zt+1E1taCiegfmFl3
         jt/YgG1dUzyt9K2i4bjgHusF6tnTGjeloz1xdbIFzk8+dqNu/ahIR4KHUABu2Y6leOZV
         PXhPKGkM2lzzi9GFos/Icg+bz0sA+9RcZPYsaNS901kAnlYOAhQfwh90LfFBpGahAF0t
         0KuZqu4WmhiQwso8BR0NGkrQJFAimozwZNxZE4c8MknnZTxWfijf53e8ADxXMm9EKHcd
         cBEifuv9kFf17KRlUlScqm7QNPvp6f3zUH2dhnxCCpvn7K549jOs6bkQk4RJlMOK9trU
         CiWg==
X-Gm-Message-State: AOJu0YzakRoh1ob7TLiF4i9RhGmHYDaqNAN/M+FzLhE/cHzvvYruU7Pv
	7HC3mKb0BpENkmscE07gQQUC3qsqvvQ7hbUnb+1bfGwTmj9fbCPsGBaX
X-Gm-Gg: ASbGncsPKCL+LrXPNuo4c4BSr2PJ7i2K+Vqt1lQaYZHPag7pyN62PiqX6sQLvnwvtH2
	+eMZqpUwoVLaVv+/dktjECGC+csE0DYzai0zwraj/caHZYWa6m0m4iN4Er6GTDHhIosN5Z5yOki
	y0a2lQ8UuQvajo6V3wtzr8HUUBXYPtBbdHWMEJ8L6+ap/AVD435ELydFz4K4yU3kT9ohUVyuk9I
	I9b5Eoh2ytbeBy6wqnTMirnfgtUWepnknV5bEXYFz9xoU1zUgG4XU48h4czqosSSn89YyB07Qup
	pC5OwTKUV/MBqsRK9BpjXNbwim6PEdFiEr8wiC3X9yJUMnE6BOgIkwyDKdEuj85q1ng9yQCHZ4/
	cSnRO8DC/REAMBF9vBPwBoi0Z0qgWOqxFz8i8PCxbEFh70teERLrVz9T1/wG+bVTW1DfWG983Ly
	kxQlDYuPEElUzj758eGDXK4povzRKtzck5
X-Google-Smtp-Source: AGHT+IETRHJjMQcMcYq5o8eYmHK9FmtR5njBTdfHhjInmdSK3tsl/WbqH5ZZXE1ALvPDCrvu/La6ew==
X-Received: by 2002:a17:902:e80b:b0:295:fdf2:d01e with SMTP id d9443c01a7336-2984ed257a5mr98424625ad.2.1763049689625;
        Thu, 13 Nov 2025 08:01:29 -0800 (PST)
Received: from fedora (c-67-164-59-41.hsd1.ca.comcast.net. [67.164.59.41])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2985c2b0fe9sm29399005ad.65.2025.11.13.08.01.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Nov 2025 08:01:28 -0800 (PST)
Date: Thu, 13 Nov 2025 08:01:26 -0800
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
	Uladzislau Rezki <urezki@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2 0/4] make vmalloc gfp flags usage more apparent
Message-ID: <aRYA1shUhLeof8d8@fedora>
References: <20251112185834.32487-1-vishal.moola@gmail.com>
 <e1d26f84-7ea2-46de-8ab9-31e49b485832@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e1d26f84-7ea2-46de-8ab9-31e49b485832@linux.alibaba.com>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: BF2D61C0018
X-Stat-Signature: hmusrun61nezfimtxbtapxqhuapyrerk
X-HE-Tag: 1763049691-71176
X-HE-Meta: U2FsdGVkX1/mmcZsv2eVWRDBAiQxd9fgC1y/ymLkGHP+qLax5810ncbp94GWWyjOUN6Z8B62IZa14QoTPjmOqOpaEyN0JlPJJb7eep5z3GXprqmikDzdeYb4E8G2TgGMKQog0KVTx6I1ldLsSLz1WKWVdSjvpApD1kgszCCxWdGAsI2fsyMM97Ay4tjz01qN0YOmQqDCdER95+mw1mfrvXoAycgyXfUJHqexTP/bUAHe2CCeRb9zhRQOOamHm65meI+DcqdBSh5zEeru2O+DdYDhdN0ADjtj5bZdMbCKdT49WdCPQ0KawH+6MQr5YxkBkKiOuZ+oaCCxnyvfq29tszhQIJpppjP8KRd+Nb1YOFlu9GxvT0imGTW5mnMdqJOwFFZYPhhnGSw7BN2rVr1F9yGSxkOM1WrOPq45w120y7/iSfdyvymTZVKbmOnTVHtDbBfMJ8sYoHf6aWYJcKhI7n0dcVLzRAWZZKciCtl5/6gIQi5OB/MOSOFIGYvQnzp6HgA5SaDf0/0h9RF2oWpwP45SJP+txLDzin+rDNQ0S2XWAhgk6uC41+GYAaPTvdaMHeBxmD9LgGm0zY4EMY9G9ZRUxzENLt/7LZmBSYVe1V0JBH3FXjFDcYVUJGc5JMbPIxNR2FNEmu6jMoLbuufetRGZRgJqGp94AP/i54KFDltaNgteCP8tXqZh89wn3jMlKphBKEVwq+xg0c3oYczScEe4lR8NBiYyW1lRBhDF3/1HQl4vjtvRPjESkVO2BRX1JYul/dBJD7CZR5Xz+wSeneFheifW9EKKbcamfcWq0ZRgQ+if3qaY8n+ZzPqWjgl5bMcu4YdffnooyfUn0YEtTctogJ1GkgbcHzJZOeoc52u0JcGql8aN4Jeg+PKWN45gyqSrJ1DKoCDKQeECsHGN9dul3lAWMtbGZPK+743ZKrkvf2Hj9ll/t1o4dOr9iGcNOfKcsyP+Z63ILnxBIav
 ldiKjrC3
 UKA6QNlbfGDseVzCpgGyHciKOsIPYwfd/wLiN/euPiQw5bd3vzfa5ZZNaIKZjvj5RGKdZryLz+CPZh6wGLLDwTXDrThTpjm6YTMDfAt3jDxAKEcHlx0TX8t/uTN1ukaGiMceZRUHAGIeVZfob6Dmm+f+z8O4ByCaDYDQlURyQh81gLI4PPVeUmOkxF/c7IBIC5Db6I3aQkKleB7/KQaA/FS2X75aq+baoCvYUKtVpLSfEWJiBoLCBEi4pWvtG7uJCaJrRvHR8eRitsPUlQHRQTedHqCs+me8guSeAx7T0RfC05vFqLDjAWL5edjloRbvEg7L1px8Qb0S7+cwKVf+RMEQhUic3qmTGtbWrOKIUEo/OYuo1E/X0pdMJlzSv385fhY8SVI4BBZ1CXmLrK/neTi01++H/a/Zy2aQcY3vUUnjLjChOxld//1YFehTeKKzglgatWf7ZwLwj+r3/VWF/Phs25Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Nov 13, 2025 at 11:48:05AM +0800, Baolin Wang wrote:
> Hi,
> 
> On 2025/11/13 02:58, Vishal Moola (Oracle) wrote:
> > We should do a better job at enforcing gfp flags for vmalloc. Right now, we
> > have a kernel-doc for __vmalloc_node_range(), and hope callers pass in
> > supported flags. If a caller were to pass in an unsupported flag, we may
> > BUG, silently clear it, or completely ignore it.
> > 
> > If we are more proactive about enforcing gfp flags, we can making sure
> > callers know when they may be asking for unsupported behavior.
> > 
> > This patchset lets vmalloc control the incoming gfp flags, and cleans up
> > some hard to read gfp code.
> > 
> > ---
> > Linked rfc [1] and rfc v2[2] for convenience.
> 
> Just FYI, I hit this warning when booting today's mm-new branch.
>
> [    1.238451] ------------[ cut here ]------------
> [    1.238453] Unexpected gfp: 0x400000 (__GFP_ACCOUNT). Fixing up to gfp:

Thanks. I'll send an updated version that catches this next week. In the
meantime, do let me know if you find any more warnings for other gfp
flags.

> 0xdc0 (GFP_KERNEL|__GFP_ZERO). Fix your code!
> [    1.249347] WARNING: CPU: 27 PID: 338 at mm/vmalloc.c:3937
> __vmalloc_noprof+0x74/0x80
> [    1.249352] Modules linked in:
> [    1.249354] CPU: 27 UID: 0 PID: 338 Comm: (journald) Not tainted
> 6.18.0-rc5+ #55 PREEMPT(none)
> [    1.249357] RIP: 0010:__vmalloc_noprof+0x74/0x80
> [    1.249359] Code: 00 5d e9 6f f8 ff ff 89 d1 49 89 e0 48 8d 54 24 04 89
> 74 24 04 81 e1 e0 ad 11 00 48 c7 c7 68 b0 75 82 89 0c 24 e8 7c bf ce ff <0f>
> 0b 8b 14 24 eb ab e8 f0 61 a5 00 90
>  90 90 90 90 90 90 90 90 90
> [    1.249360] RSP: 0018:ffffc90000bebe08 EFLAGS: 00010286
> [    1.249362] RAX: 0000000000000000 RBX: 0000000000001000 RCX:
> ffffffff82fdee68
> [    1.249363] RDX: 000000000000001b RSI: 0000000000000000 RDI:
> ffffffff82a5ee60
> [    1.249364] RBP: 0000000000001000 R08: 0000000000000000 R09:
> ffffc90000bebcb8
> [    1.249364] R10: ffffc90000bebcb0 R11: ffffffff8315eea8 R12:
> ffff88810aac98c0
> [    1.249365] R13: 0000000000000000 R14: ffffffff8141abe0 R15:
> fffffffffffffff3
> [    1.249368] FS:  00007fbc9436ee80(0000) GS:ffff88bec00e1000(0000)
> knlGS:0000000000000000
> [    1.249370] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [    1.249371] CR2: 0000562248eda010 CR3: 00000001028a8005 CR4:
> 0000000000770ef0
> [    1.249371] PKRU: 55555554
> [    1.249372] Call Trace:
> [    1.249373]  <TASK>
> [    1.249374]  bpf_prog_alloc_no_stats+0x37/0x250
> [    1.249377]  ? __pfx_seccomp_check_filter+0x10/0x10
> [    1.249379]  bpf_prog_alloc+0x1a/0xa0
> [    1.249381]  bpf_prog_create_from_user+0x51/0x130
> [    1.249385]  seccomp_set_mode_filter+0x117/0x410
> [    1.249387]  do_syscall_64+0x5b/0xda0
> [    1.249390]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
> [    1.249392] RIP: 0033:0x7fbc94f4c9cd
> 

