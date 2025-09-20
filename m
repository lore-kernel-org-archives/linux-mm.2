Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 40822CAC5A7
	for <linux-mm@archiver.kernel.org>; Sat, 20 Sep 2025 12:30:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 684438E0003; Sat, 20 Sep 2025 08:30:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 62E078E0001; Sat, 20 Sep 2025 08:30:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 51D088E0003; Sat, 20 Sep 2025 08:30:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3CAC78E0001
	for <linux-mm@kvack.org>; Sat, 20 Sep 2025 08:30:04 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E5F441A006F
	for <linux-mm@kvack.org>; Sat, 20 Sep 2025 12:30:03 +0000 (UTC)
X-FDA: 83909560686.02.555E034
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	by imf09.hostedemail.com (Postfix) with ESMTP id E281514000C
	for <linux-mm@kvack.org>; Sat, 20 Sep 2025 12:30:01 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=QY5Nj2Vl;
	spf=pass (imf09.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.46 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758371402;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3N4BauaosZSVdkvwzu/EQglPsomIFk3vHZa8La44Tjo=;
	b=PmOW5OO9IHsjJpstTgqx+MP5ZyEDend02NdlgjELz4Xqg0hiGM91aLGuTSOcviekK+HwGO
	TNbYQu99SLo4q4vfWw4jLtBNZByejgp8yWu8IoBo56XUDcLa80WWNr56swNY4DxZLMXyOD
	VcKqXxh7hCz5aEADKVkcfr58187DVwA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758371402; a=rsa-sha256;
	cv=none;
	b=NKsa8iR6IX8SrAjt4J9G9d+SCiloWZiw9PT3IldMiSgr8nLBdb3WkDDIR43g8kZLJD7nlM
	baLsQJXWcTyO4/KF0STTVZfHVRCadOC4lhazlkoxEOmSSsaC4ZAxr/z9CsdKZ8n3dIROWX
	OeWIl5UdJUf3a3/rP+nLE/tHpBjHZ4Y=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=QY5Nj2Vl;
	spf=pass (imf09.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.46 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-62fa0653cd1so3477628a12.0
        for <linux-mm@kvack.org>; Sat, 20 Sep 2025 05:30:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758371400; x=1758976200; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3N4BauaosZSVdkvwzu/EQglPsomIFk3vHZa8La44Tjo=;
        b=QY5Nj2VlqxMufIhfXOU1nFjFSth/SD62rZmFUMthtZctATHV0PwW+1tyPtP1Df/w8E
         XCp0XRKzupqajE4Y4bElQgk6HTz9ePRfwPGlo7fMRK0RgDMJLrMxmL91yMQtjqdW+LuL
         6Y/pISYQi+EZp3vk54tAKIaDzLdRaRaPuI3a4ETq02nSzMYErwNxyb6cVcZiYXseGVeP
         O1c7WAfeD7EZR5djY7qQpCiNs2o6NnO+OtlAwWUpUSnqM1NJYO4GSLREPN/XVZ7MMD5J
         gxVHZOBiq8yI3164UY8pZSD3VHxkXEt2OnCRAz8IrPtZA3j+E9mDot874/E5Hs3jtAvN
         XG6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758371400; x=1758976200;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=3N4BauaosZSVdkvwzu/EQglPsomIFk3vHZa8La44Tjo=;
        b=cykO46h/Drek8pWTochI5apchozhWUIRsG2XVZEcRtPQWNZNddzkbD3v8KR9o18Zv3
         l436viZLbMjr75Y45RC+UlfZCLcnnaRcfFfqQnK1Uxm6Er5ezdPVZ25YL/sMDKfhg/GV
         RUd6iG84LTNteP5cCpjNRC12vc+Utij/d4NbWLePJah245Yz9yowDeXp9XCDgrPCzH+H
         hKT7PsO1hjBJCMxB2sHjeBCa049OK35/Kj5pmNdrBKAl0C/xhLy5RMhVwOnqvvOQz5CI
         GHKIYj0/pJKY9CrFYKPjFSUOnhnXoniZpelnk0Emd0PbQeuxPCs1xXnj23GG4caWoBWL
         bymA==
X-Forwarded-Encrypted: i=1; AJvYcCVUeLi6BTP8JBaqORRKREFmSZn1AcPuDArE0J8rG3woKZuK6+QoTmGZL2NWFczkwn7NSYa+GNuQcg==@kvack.org
X-Gm-Message-State: AOJu0YyKmqORxYetUgOsju+5Juha/C1WXZfNM4jKfhJqmStVwT7twFfc
	rsHA6LjZG3NQzI63xE8uQmpIn8ReCGlnfTAL9AOaixK1KubA4sk25wr3
X-Gm-Gg: ASbGncsyy+lpdtisQtU3bkWaPY4y0xdW4j8kQJShJc1NBar4dvXH3vh0e0MRTv+eoUH
	RvgpYfWWOLpQUfcV3fgjrVB6WY6LRPzw4oc/0/0uc+3X5lk03k7ccAwgc27cJ0FeXoJ0aneYh8g
	QsPTw46UmYBXL3+yH4wZ5dp8tz/OrZ1SZ8GeGJTuToS/GAbCzZkw2Mzud+LbKBI4OWH00ppVLmo
	/ZfbU0S0e7oHhrUfeZKpMr/WBSXBF8SPobXJI7SxJg3ktw6NpviOZg62Xdtiih8XyF6QfDOs2GW
	EKdIZuJ/77I7q0I4DM8BTH9We5tKfOJCjOP5mDER+5mMOF9MZDYU5IM/KpSTKZT+toeqmh802CF
	OZhKq21cR0gMwpkEUjLUnmw==
X-Google-Smtp-Source: AGHT+IFik3SdY4y0y7nnOGteAls+/0Lryrq/+kDWVzKYBFJPr7TgTAuKKZzGNCAcll7AuZpMuE6FFw==
X-Received: by 2002:a05:6402:2083:20b0:628:5b8c:64b7 with SMTP id 4fb4d7f45d1cf-62fc08d4bafmr5829920a12.6.1758371399788;
        Sat, 20 Sep 2025 05:29:59 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-62fa6f03008sm5026759a12.7.2025.09.20.05.29.59
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 20 Sep 2025 05:29:59 -0700 (PDT)
Date: Sat, 20 Sep 2025 12:29:58 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: SeongJae Park <sj@kernel.org>
Cc: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
	david@redhat.com, lorenzo.stoakes@oracle.com, ziy@nvidia.com,
	baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
	npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
	baohua@kernel.org, lance.yang@linux.dev, xu.xin16@zte.com.cn,
	linux-mm@kvack.org, Kiryl Shutsemau <kirill@shutemov.name>
Subject: Re: [Patch v2 2/2] mm/khugepaged: remove definition of struct
 khugepaged_mm_slot
Message-ID: <20250920122958.nf6vcm6iyl2wz3bj@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20250919071244.17020-3-richard.weiyang@gmail.com>
 <20250920115233.81851-1-sj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250920115233.81851-1-sj@kernel.org>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: E281514000C
X-Stat-Signature: y87gcsoayazf9psjdriobjir93tsjizh
X-Rspam-User: 
X-HE-Tag: 1758371401-18622
X-HE-Meta: U2FsdGVkX1/AipVILDIZCYe8qW2LCYhO8onRIq5rqO8MpxDYc3WvRaG9PbwahEoLYD+3dpy+VuhVbWyOtB2NPKlgmdcvPkWL5BK1kgTE+awSN6DfAEFDdrUzgixwqUdx9UEKQXRGUMLCjSiKrKvZ48VAPZeWOq+VQSGpvpWigR1QVFD/5GzhVkXfoKTO1jA8jnFYDcrjt/Bek2xgVQo/CfO2EC1888vBh31nxOpnYquWGS0XlGERgCFsyGb2O2u+a54KmHrKCHLXre3JFE7+1dTbevGwI8ZOYa+kCAUTqKuebAYocMzSV3Mk/S7cid1cZ6k7B9bkmjA2b5QGk6vl8wdU+yd6mzNSzoahk3MK8Mor+Ykrc6bpxP3zd31pq0hzIg3rzhWTP7el4ktMNqZxG+6KUpve807dRTBHjXF6c/IELB5nQvpjE59NrZb5Vm3kweXi1bBsLJVNB8PxwAOC8gh2zCWOKHyNGhzMpEQTJmBushZ4/6U9M8R4RFpR+pKphR4e/Y+MLh3+vFjSiS+/DZUiWyMf32btlcuxjGjA4CGsXBlycwNHJCet/4C+hR6Sjn4WjDiHcH7tC95rRNL540EbS2SbOfi4zqsAJc2MKBVvHGagtpIpG3zaUd6tmEVa2IJiWjpEJXvM1RqppiAIE4WRKZv5FtNfQXxfixk1LEBzfO2c6c0bV1qX1wiL2Nocdwg0RNxx8iMi2j0PODmbrrmHMNo2ppbHUKll9eZoLuLcMknG1zuMZO33wI61XfeFRMk1p7StjSNvX8DmeYa7GswMLNC85Dedu+URO5otyO5DaL93o1r4Xf7QXci858u/4wSHxWarCRAS42mqTyUOooLH8ofoxG1w1MxDfZLxmIIFlK+rt9toWB14JQRO6ByXDcV9WNp1MkgWtj176Xj5X5s3roqHZj5cXz0BrTcwk7AFr/YWoXDL97MFoj4edNUiAmayDkk8Itjs5l+/ew4
 bx9jR+1i
 uGlL4HoLO6TFj5HbKKywA9HbgLIyTYzkJghJlzP0lGrr2qhTMtiU6lEnNb87QuFKx+xViHsmYwg9a82Hxwhd/Y9hGWgo9u6QiPX/H+f0OjiyImCSfjmejrEJR0wX/rTpJLxLEnYBG/MZRwM26axH8ife5doZ0EdyCAnGP92o9PEYsY2G6Q3/Vb4fKKrvE8xKKf34rkpM0WFnhTWpDy2dwC06dO2/eTL8uJC0Dgm+oqiiEivIvzLYu5ltpA0WDyzy9gmVD3vpMnS++bhowUtYQ1RzZybM/rfLCdfzfu5FdvTqBaGNV32GXc0AcbJEMlTFIYOs3rg0KYNRqm1LCcN4tlG3bpS+vqQ6TKxX8hO5HFMLY371ESmYkBq5+aEPkm8H59qzhgtgyJVWao9j23AaXDRdEWBTYpDXkju/DvBjueffwC3Wp2NgEOopl/XMFORVJev8RVNhPxJWAncqSOtoTFIVHP9LycyaBv1oMOnN1C24y1nqe6k2Z/zT6aqkZN46rUGpky2tY00CiRvqkQouegOt/dvVL/D/c6gLCdPrUUSX93olN9DWhglGDA4uP3tbzHFPcoF6NVjDbvMV0uo4KPEnw2/FkjdDbzOn3dZu8txZmIU6cZf2KBkJxZb8IJT0TBsxO/lrjNKI949fAVK0naoAvGuP0e6cdi0IBNKmfUFV6uzIJiKBpqsXMRG7rTRyaIXX3zrdRRFoNjnaWT7Fa+pbErk2y5J2+9UR+PjWfKf01XqxG1qwWmmyjJ9haE9JuJ4lI
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Sep 20, 2025 at 04:52:33AM -0700, SeongJae Park wrote:
[...]
>
>On latest mm-new tree, I am getting below error while building UML mode kernel
>for kunit.  And 'git bisect' points me this patch.  I'm not familiar with this
>code and have no time to dive deep for now, so reporting first.

Thanks for reporting.

>
>Oops: general protection fault, probably for non-canonical adI
>[  356.456907] CPU: 34 UID: 0 PID: 309 Comm: khugepaged Not tainted 6.17.0-rc4+ #370 PREEMPT(voluntary)
>[  356.457702] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.3-4.el9 04/01/2014
>[  356.458484] RIP: 0010:collect_mm_slot (mm/khugepaged.c:1427)

If my understanding is correct, the error happens in following code flow:

  khugepaged_scan_mm_slot()
    mm = slot->mm;                (1)
    collect_mm_slot()
      mm = slot->mm;              (2)

Looks the reason is slot is NULL at (2), but we have already accessed it at (1).

Not find the cause yet.

Would you mind sharing your UML config and test step? So that I can reproduce
it.

>[  356.458904] Code: 48 89 df 5b e9 1a 29 f3 ff 66 2e 0f 1f 84 00 00 00 00 00 90 90 90 90 90 90 90 90 90 90 908
>
>Code starting with the faulting instruction
>===========================================
>   0:   48 89 df                mov    %rbx,%rdi
>   3:   5b                      pop    %rbx
>   4:   e9 1a 29 f3 ff          jmp    0xfffffffffff32923
>   9:   66 2e 0f 1f 84 00 00    cs nopw 0x0(%rax,%rax,1)
>  10:   00 00 00
>  13:   90                      nop
>  14:   90                      nop
>  15:   90                      nop
>  16:   90                      nop
>  17:   90                      nop
>  18:   90                      nop
>  19:   90                      nop
>  1a:   90                      nop
>  1b:   90                      nop
>  1c:   90                      nop
>  1d:   08                      .byte 0x8
>[  356.460685] RSP: 0018:ffffb61a46e37df8 EFLAGS: 00010286
>[  356.461115] RAX: e1bca96613f6fe2b RBX: 0000000000000000 RCX: 8000000000000007
>[  356.461692] RDX: 0000000000000001 RSI: ffffeba0443b2600 RDI: e1bca96613f6fe2b
>[  356.462269] RBP: 00000000000000f2 R08: ffff8ea80ec9aa00 R09: 0000000080150001
>[  356.462842] R10: 000000008015000e R11: 0000000000000000 R12: ffff8ea80ec9aa00
>[  356.463574] R13: 00000000000001e5 R14: 0000000000000001 R15: ffffb61a46e37e60
>[  356.464249] FS:  0000000000000000(0000) GS:ffff8eaf13dd1000(0000) knlGS:0000000000000000
>[  356.465070] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>[  356.465578] CR2: 00007f8e913e2a1c CR3: 00000008cb022000 CR4: 00000000000006f0
>[  356.466185] Call Trace:
>[  356.466398]  <TASK>
>[  356.466576]  khugepaged (mm/khugepaged.c:2519 mm/khugepaged.c:2556 mm/khugepaged.c:2612)
>[  356.466869]  ? __pfx_khugepaged (mm/khugepaged.c:2605)
>[  356.467284]  kthread (kernel/kthread.c:463)
>[  356.467592]  ? finish_task_switch.isra.0 (arch/x86/include/asm/paravirt.h:671 kernel/sched/sched.h:1531 kernel/sched/core.c:5105 kernel/sched/core.c:5223)
>[  356.468068]  ? __pfx_kthread (kernel/kthread.c:412)
>[  356.468480]  ret_from_fork (arch/x86/kernel/process.c:154)
>[  356.468849]  ? __pfx_kthread (kernel/kthread.c:412)
>[  356.469223]  ret_from_fork_asm (arch/x86/entry/entry_64.S:258)
>[  356.469591]  </TASK>
>[  356.469778] Modules linked in: binfmt_misc ppdev parport_pc parport pcspkr evdev joydev button serio_raw sgn
>[  356.473304] Dumping ftrace buffer:
>[  356.473618]    (ftrace buffer empty)
>[  356.473966] ---[ end trace 0000000000000000 ]---
>[  356.474506] RIP: 0010:collect_mm_slot (mm/khugepaged.c:1427)
>[  356.475142] Code: 48 89 df 5b e9 1a 29 f3 ff 66 2e 0f 1f 84 00 00 00 00 00 90 90 90 90 90 90 90 90 90 90 908
>
>Code starting with the faulting instruction
>===========================================
>   0:   48 89 df                mov    %rbx,%rdi
>   3:   5b                      pop    %rbx
>   4:   e9 1a 29 f3 ff          jmp    0xfffffffffff32923
>   9:   66 2e 0f 1f 84 00 00    cs nopw 0x0(%rax,%rax,1)
>  10:   00 00 00
>  13:   90                      nop
>  14:   90                      nop
>  15:   90                      nop
>  16:   90                      nop
>  17:   90                      nop
>  18:   90                      nop
>  19:   90                      nop
>  1a:   90                      nop
>  1b:   90                      nop
>  1c:   90                      nop
>  1d:   08                      .byte 0x8
>[  356.478405] RSP: 0018:ffffb61a46e37df8 EFLAGS: 00010286
>[  356.478935] RAX: e1bca96613f6fe2b RBX: 0000000000000000 RCX: 8000000000000007
>[  356.479763] RDX: 0000000000000001 RSI: ffffeba0443b2600 RDI: e1bca96613f6fe2b
>[  356.480722] RBP: 00000000000000f2 R08: ffff8ea80ec9aa00 R09: 0000000080150001
>[  356.481703] R10: 000000008015000e R11: 0000000000000000 R12: ffff8ea80ec9aa00
>[  356.482402] R13: 00000000000001e5 R14: 0000000000000001 R15: ffffb61a46e37e60
>[  356.483060] FS:  0000000000000000(0000) GS:ffff8eaf13dd1000(0000) knlGS:0000000000000000
>[  356.484027] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>[  356.484861] CR2: 00007f8e913e2a1c CR3: 00000008cb022000 CR4: 00000000000006f0
>[  356.485559] note: khugepaged[309] exited with preempt_count 1
>
>
>Thanks,
>SJ

-- 
Wei Yang
Help you, Help me

