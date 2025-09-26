Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A7814CAC5AE
	for <linux-mm@archiver.kernel.org>; Fri, 26 Sep 2025 06:48:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E76288E0005; Fri, 26 Sep 2025 02:48:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E27108E0001; Fri, 26 Sep 2025 02:48:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D3C858E0005; Fri, 26 Sep 2025 02:48:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C5AF08E0001
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 02:48:25 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4EED9BA57B
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 06:48:25 +0000 (UTC)
X-FDA: 83930472570.05.173890F
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	by imf08.hostedemail.com (Postfix) with ESMTP id 78F92160004
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 06:48:23 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=IHCWaIM7;
	spf=pass (imf08.hostedemail.com: domain of elver@google.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=elver@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758869303;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aJgWHabvDduY7CKx07HtPWunby2WlRQjkpPq1jpmCK4=;
	b=r9gLcSOn+zJkFYFRfJckzsLZZimerZjGp808mleuHlXHZtNFL2Zqh3xz6cAv4VBWdP5uTx
	sKYX2JZMPZ+jWnyVjJN+oyMWQUpvuZ0pF7hxk8SfNFVWpQLxcbQWrAYkOeP9y0Y+lT4rII
	1AGfio65z6s1gbk4qrNVGxvwxnnoPLk=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=IHCWaIM7;
	spf=pass (imf08.hostedemail.com: domain of elver@google.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=elver@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758869303; a=rsa-sha256;
	cv=none;
	b=tzmTDxOtDIY5rZCzsmYNOEoYZ+x7UfYQpX0GMZee1X5uKyhzSLvxryfaari2gS8LQuXJ/r
	hhbCBMM4jR2+DLPFUHbwBDbBQ/rdUZW+vl+2X3CtkiA9WiAJTI+4rO2q+re4Fyd8E5FhFj
	eAcpFiJhudEUnLcchIHHI84D1L82WDo=
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-267facf9b58so14015705ad.2
        for <linux-mm@kvack.org>; Thu, 25 Sep 2025 23:48:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758869302; x=1759474102; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=aJgWHabvDduY7CKx07HtPWunby2WlRQjkpPq1jpmCK4=;
        b=IHCWaIM7RNjcou0co7ksdT07uuSEGMfb089XumZlwfkmb4lwzzWj10UPJtR89ZGsOs
         KCYeJHX2wSh6I402KUcbQGto1XUjMDCcBTEtL2zK2j5b1s+U+Vu33w5CuteYW7WzQoqA
         +jaGEbxmb7gTtVaqNBCd0E5D1Wn3ERmPVcbouCpHjZId61+xUknQq/fsnfzi47lUK6pX
         0kwW4fxCe67qMGEfDKLcOi6Gu8IplYIM5bAhJt5Ul8bjIfvQczZjvhqpS1EiY0OuNtGa
         vyzqaufqAjGccFjVewB7BkrqqVA+1DIjr0Z3lBBPEvGWUM9zMqf0vijQsYd0Vta3bzH6
         /pSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758869302; x=1759474102;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=aJgWHabvDduY7CKx07HtPWunby2WlRQjkpPq1jpmCK4=;
        b=era0EeHfaBJU54xZWgEOZJQmTsqqz3/8/94AyDEX7Fr0yTvOMlPnf7zxTIFk5+n4ry
         OgWX3TZq1Qjgl6yP9t30KgaeQaag/NKHrPWgsTbClHBLZYhKG7vMfeUpUE0vA+YmiAqe
         P8rYvK6avw005srMlRgc8A7Ccit0IqVgMmXOg9tk2DOesBrOFVlUGboeGsN/hBAKgO/I
         QaH8coCGpV976Oh+pzeQi+enuRiWKGgpi9QzG5uXh5XyCZhQGI1X4aCD3TZyexPJQ/au
         MFH1D8f+PiI+OlXYu6/T9OTxXtpT9kKu/f/bEvZBB0G9zPyrja3DuxTRAnjg2r1eIh9g
         aNGA==
X-Forwarded-Encrypted: i=1; AJvYcCX0/40Uz4zARPOzjmrf98WthWJPVk6HoAQWNFpE4LwJYNQKyGphoIuYdGpDcOj/IEDtKF0z6oCEyA==@kvack.org
X-Gm-Message-State: AOJu0Yz+kr7C3WabqROq/HkdE/K7S7nnPnYvpStL1n8plBsC9bghkaGQ
	e81V2kyu6+73IQU1FPlDuVsk7ZsFQRIxd5wVGqBtqed/BmCKCuO9yXFBiTVvlCg5c0tdSSN6wLm
	RljYrRc3X9P0a1r+EeH7OXTHm9lwZVYtZe9lpSV7x
X-Gm-Gg: ASbGncvUpjw/6BPZqEDk+TUI0fm0Gokw2J+V5N6JbO6jAJF7ZUmXT4/l+4O3Ni5ZN8P
	HjrBuUFlp8Cqen9ABnM6MLQBNwlgACl416aVGGlZYClhwKQpNeqXhn9vDUfvuIRs0KVGNyD96ww
	sPzbPpXsE39wT56bwdM/jvua5MfqjwoVa2II5FJ52Nfw5vRc3+2BqsIt8A9xe2LjOf54wJzfhmn
	6x2rGfFHqgkZtXGfmMFJrj9LzbTFP6YlLLbwqhz79OMqg==
X-Google-Smtp-Source: AGHT+IFQ5dcE8jI9jLYWO3ZIojoAEp7kw7htpHJSMwq3UBPFdCKdp/gCcYtzso7T+qMu7jMyGkvqB3ynpVlhrrLt0JA=
X-Received: by 2002:a17:902:f78a:b0:27f:1c1a:ee57 with SMTP id
 d9443c01a7336-27f1c1af218mr11140145ad.16.1758869302047; Thu, 25 Sep 2025
 23:48:22 -0700 (PDT)
MIME-Version: 1.0
References: <68d6364e.050a0220.3390a8.000d.GAE@google.com>
In-Reply-To: <68d6364e.050a0220.3390a8.000d.GAE@google.com>
From: Marco Elver <elver@google.com>
Date: Fri, 26 Sep 2025 08:47:45 +0200
X-Gm-Features: AS18NWDuKHZOuTTHwXeZU7Mpq5jZFUp5-2GMJyGgVogYWdeZQykYphkIZQwvd7M
Message-ID: <CANpmjNMA4sOXAUdCpDDYz-4D9F_BaTFF8DL3Vkhx=q7vPfYG+A@mail.gmail.com>
Subject: Re: [syzbot] [mm?] KCSAN: data-race in try_to_migrate_one / zap_page_range_single_batched
To: syzbot <syzbot+60192c8877d0bc92a92b@syzkaller.appspotmail.com>
Cc: Liam.Howlett@oracle.com, akpm@linux-foundation.org, david@redhat.com, 
	harry.yoo@oracle.com, jannh@google.com, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, lorenzo.stoakes@oracle.com, riel@surriel.com, 
	syzkaller-bugs@googlegroups.com, vbabka@suse.cz
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 78F92160004
X-Stat-Signature: 3ycpojqer3mt34ppb4nkgcgqnf71pgpr
X-HE-Tag: 1758869303-941035
X-HE-Meta: U2FsdGVkX18PzJAAc9LNlCRPnm6Ovy6fR6cewwTwLSeliZlsVLbNZi/Q+ycQmFFzKKcCIhfytYyew4LtOFwEeSGdTaj0QEm+cgQ61spPByIJOZ5mG4vfxUA1RfryNFupHbPeIeHsXRUVWYNZPVw8bJ8aHMWaA00z6U+uGaxAV30BsfLZgJeSGUl5Qro5KSyP80fqs2yEQaN/F+cYDymutTXqy1Mz/KMVt/D7c7JIdOqpZWv48gMEbAV2Qj+x7XHpoqPQa0T5rOy0Xt/SX1bB0WW8PtpsmcattfnatZeYrdXHMCerA44zKjEQ1Ed0xjmhLp+5yPo22PEt3Ccx/5fv6/5oRoDZDmoROlh18qjdAaJXH9DkeKWdTobS5HOZhZ8TMQTDo+jxa7Y6V2tKTCaeEILRqU8D9fUDCO1E3M/HdysCgx7AE5+TR1FdiB8n9IySXtbq1FdYZZGoCpNr2jn9fv8AEx5Jczivq32uRXoCC543IhM7bTBDsNvlOVR0t18nwJTx++ZO9VNfTcaDfWRDCWKB7kVTlk4xHnzbnV3iX1yV7jMwsgaidjuORwXR9VPSKBpV6p3AEH2hAaGz4RsjoSS2ClHoAjtK3wiVKnBhM/YtQHm/g7QwQmc6A0pKMouSdCcwUdxq5xixc4hpoD6/0DwCpOUPPnPVwSiU0GXc0jgic3txEaddO5x8LhLGpPA7igZEukqRfI3Ac8msbsMHQOfAaDD5niySbYRIeBC6X9Evkya1j2pL4Ya0Y6XSV3Y0d74/6TcqXhLZm4xzxdmtIphUsNjY5kxvt6RlM6miebmJWMvdEjog4izC8oJti7Sj/JRrfHQmT82vcjveeFP/hspvtsi1LXuukCXTeyXmL4KqwSbvA43wMYxrktfp2G2m/vaxmDePyCKGUx7sNiKJHR5GKUN9JGQnKi9Xx6ogkeIJIyJr3Okbr1fiI7E73SYsj4iZXyn4LOPc1q4ImT0
 m2m13YGR
 KKEkvf99PxmDk0qG/ijGQUWcmgFtI/QqX98EMOgU8ArspUrT4sAqG0wvCrdy5gIXhp+/rxlJ1NQtHbh6PEhT/ivnkpRVhbMllXRKEXwTzZ2QSRGdkRnSyqeN34xnpBKjjERMEZ1akel20Nd/uLMFH+XWbdj9Q6GXcnRTsBLqaaQmXIQXbSGxA/tf9Mw/2LLSzE24XBuBkN6dKjz2uKg2XkH9egEggz0Nz7YBnzGdLyaNnnX/FwhuofYCazjNyOdeIxsMWxvF9lTfWLv6Qpd0jb91ntxjG36TI2ixurjgLoaSO192u4A6LyU0B5Ls6CUOnPUi+KTfeRikPAwWBtbeym9uQIloj29LOCbz342jIouUvmXuVopHAzSIsNNYeZXWv6uzC0Q9wE4386EWH1xRn89J+1+n/waLUL859C6b/BO1U7ykS1R5R+0EZAmaJZAht/EqFrenKa1lQPWdjhTaQQFhHHVDeY3LUBVBOP++XtPONXB7n1ZAaIWKC+arrEzja56BjxCDfbdlyEzcvVxVOlT5FCJVDFq3/Xr1WDMhweuuQIvYxMY6YNpNKw3JlU1JBx+p5NciBcB5OT78pHX54gBHdalo+8S2Vl7HQomFVuygU1EwK33Pp/B6dWsIkAzfh/zg0e/F/eMkRfFHzx94YYPT1riZ+sPghIch7TyXD9DDXcQ9YOa58hy3LpIfG6oJ4nKNhhSukceZ3taZrwI8fKyfGoqcw/SK95aPFv2bqfhTOfEftoPeUCIeRHkiYM3fF4IIDCUCFPXNA1DAXbr810ipLfkKLlL6nJ1XyHcUmBdWTPs61n9GYKjKeVGzEVymMRIDj+Qb4KUnRZUJrc1+5V7SPQg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 26 Sept 2025 at 08:44, syzbot
<syzbot+60192c8877d0bc92a92b@syzkaller.appspotmail.com> wrote:
>
> Hello,
>
> syzbot found the following issue on:
>
> HEAD commit:    cec1e6e5d1ab Merge tag 'sched_ext-for-6.17-rc7-fixes' of g..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=145d4f12580000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=6e0c213d0735f5dd
> dashboard link: https://syzkaller.appspot.com/bug?extid=60192c8877d0bc92a92b
> compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
>
> Unfortunately, I don't have any reproducer for this issue yet.
>
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/10b7c8fdfdec/disk-cec1e6e5.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/cbecc36962db/vmlinux-cec1e6e5.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/214f107d0a3e/bzImage-cec1e6e5.xz
>
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+60192c8877d0bc92a92b@syzkaller.appspotmail.com
>
> ==================================================================
> BUG: KCSAN: data-race in try_to_migrate_one / zap_page_range_single_batched
>
> write to 0xffff88810adfd798 of 8 bytes by task 13594 on cpu 1:
>  update_hiwater_rss include/linux/mm.h:2657 [inline]
>  try_to_migrate_one+0x918/0x16e0 mm/rmap.c:2455
>  __rmap_walk_file+0x1ec/0x2b0 mm/rmap.c:2905
>  try_to_migrate+0x1db/0x210 mm/rmap.c:-1
>  migrate_folio_unmap mm/migrate.c:1324 [inline]
>  migrate_pages_batch+0x6e1/0x1ae0 mm/migrate.c:1873
>  migrate_pages_sync mm/migrate.c:1996 [inline]
>  migrate_pages+0xf5f/0x1770 mm/migrate.c:2105
>  do_mbind mm/mempolicy.c:1539 [inline]
>  kernel_mbind mm/mempolicy.c:1682 [inline]
>  __do_sys_mbind mm/mempolicy.c:1756 [inline]
>  __se_sys_mbind+0x975/0xac0 mm/mempolicy.c:1752
>  __x64_sys_mbind+0x78/0x90 mm/mempolicy.c:1752
>  x64_sys_call+0x2932/0x2ff0 arch/x86/include/generated/asm/syscalls_64.h:238
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0xd2/0x200 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
>
> write to 0xffff88810adfd798 of 8 bytes by task 13595 on cpu 0:
>  update_hiwater_rss include/linux/mm.h:2657 [inline]
>  zap_page_range_single_batched+0x182/0x450 mm/memory.c:2007
>  zap_page_range_single mm/memory.c:2041 [inline]
>  unmap_mapping_range_vma mm/memory.c:4020 [inline]
>  unmap_mapping_range_tree+0xfd/0x160 mm/memory.c:4037
>  unmap_mapping_pages mm/memory.c:4103 [inline]
>  unmap_mapping_range+0xe4/0xf0 mm/memory.c:4140
>  shmem_fallocate+0x262/0x840 mm/shmem.c:3746
>  vfs_fallocate+0x3b6/0x400 fs/open.c:342
>  madvise_remove mm/madvise.c:1049 [inline]
>  madvise_vma_behavior+0x192d/0x1cf0 mm/madvise.c:1346
>  madvise_walk_vmas mm/madvise.c:1669 [inline]
>  madvise_do_behavior+0x5b7/0x970 mm/madvise.c:1885
>  do_madvise+0x10e/0x190 mm/madvise.c:1978
>  __do_sys_madvise mm/madvise.c:1987 [inline]
>  __se_sys_madvise mm/madvise.c:1985 [inline]
>  __x64_sys_madvise+0x64/0x80 mm/madvise.c:1985
>  x64_sys_call+0x1f1a/0x2ff0 arch/x86/include/generated/asm/syscalls_64.h:29
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0xd2/0x200 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
>
> value changed: 0x0000000000001645 -> 0x0000000000002165

One of these writes is getting lost. Which means highwater_rss is
lossy/approximate - does it matter?

