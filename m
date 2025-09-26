Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 55005CAC5AE
	for <linux-mm@archiver.kernel.org>; Fri, 26 Sep 2025 09:36:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B0D708E0017; Fri, 26 Sep 2025 05:36:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AE4128E0001; Fri, 26 Sep 2025 05:36:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A20C58E0017; Fri, 26 Sep 2025 05:36:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8E1448E0001
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 05:36:33 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 67613BA782
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 09:36:33 +0000 (UTC)
X-FDA: 83930896266.30.596FEB4
Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	by imf09.hostedemail.com (Postfix) with ESMTP id 312CA140006
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 09:36:30 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=oJC8G4Ls;
	spf=pass (imf09.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758879391;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1sF3mMFlEeo6+29CxldPU4wUsiArQVg+D2rLhiy93Ds=;
	b=UKhPm8MLmK95nGzV9SIpNsh9PyrtJdD+bUZsuiGs37zGKcBojG02cGBFeXtuGzVV/kp12n
	zsOERtUXlLlgXvqFGEx6qAFOecVD3WdK6GTRKRkca4iOzs+QNeEGENpwNmPbCNUE3XOth+
	HMq1cr5vNyNeTwsGgl56x9aalpdIFcM=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=oJC8G4Ls;
	spf=pass (imf09.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758879391; a=rsa-sha256;
	cv=none;
	b=orfrCMMRUnaVe+wk1TThPWVaUJ2mRbd4L1nWUG5phbAvLDUSIoC5bkzGmJaFk1WgSO39u2
	bPoOb/MHXCtyCEpdcItpdRO6WRxjKgW8VyM1ori2a+yMnyOr9HeHQx5CukTug+D+GIhmdi
	HIT4PdPDA3jReGSj3HRDmTxxbtvcBrQ=
X-Forwarded-Encrypted: i=1; AJvYcCU4TLKK4VIDnAu25IcP0E/5zyt1tTmzMsj/ZHkab3qc7sw8Syb4QRWSq2Yw7bxy8Q2CUn3yxkAy6Q==@kvack.org
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1758879387;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1sF3mMFlEeo6+29CxldPU4wUsiArQVg+D2rLhiy93Ds=;
	b=oJC8G4LsmcpmbIhTFcy61QJ53LJPcfBtV8jcnETGA/Fs0aofTPXkowo07u6AU9j9gmYC/H
	ASRkdeNF4F49LarBVsCZwIRfp2EjjNzY8Cx+us/aoGRJBQ7w6rCpHMgoim3m2QVimc6ge8
	H2B0DiEUFeYavPMYEyDWdBC1QKGvieo=
X-Gm-Message-State: AOJu0YzuLhL7m3Iawf7R1HxeRNU9cDr+71fHQIvlr9VGGRxOXRqJ9VWE
	U6iuLBe6vQou7ehV33poBXsZXniqjT2tTweiwrQXzIePucUEo7Dp/vK00sc8bK1dKT5/CRt/Ryo
	V4ga4PUAGxbvLk0V4BvlYgt4PgDIwbCk=
X-Google-Smtp-Source: AGHT+IE0VoZpyXKMjv4jutuRolFREokOBBoRz0y1gxD6T4hKQcttqKKtNLh4/LwyPCc1DwqCjc/jIZgZwHPfVl/mBX8=
X-Received: by 2002:ac8:7d15:0:b0:4b5:e63f:d5d8 with SMTP id
 d75a77b69052e-4da4c77c756mr81466571cf.59.1758879385173; Fri, 26 Sep 2025
 02:36:25 -0700 (PDT)
MIME-Version: 1.0
References: <68d6364e.050a0220.3390a8.000d.GAE@google.com> <CANpmjNMA4sOXAUdCpDDYz-4D9F_BaTFF8DL3Vkhx=q7vPfYG+A@mail.gmail.com>
In-Reply-To: <CANpmjNMA4sOXAUdCpDDYz-4D9F_BaTFF8DL3Vkhx=q7vPfYG+A@mail.gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
Date: Fri, 26 Sep 2025 17:35:48 +0800
X-Gmail-Original-Message-ID: <CABzRoyZuU6WT_eN_gimpFNrA9cVpmTsKCG1f6Mi_KCmYy03C0A@mail.gmail.com>
X-Gm-Features: AS18NWBk7yoZQ6JxZ96p9n__yfVmWuL-V3XgGu7UllO4xRF8xd7eIwb3A-ueoC8
Message-ID: <CABzRoyZuU6WT_eN_gimpFNrA9cVpmTsKCG1f6Mi_KCmYy03C0A@mail.gmail.com>
Subject: Re: [syzbot] [mm?] KCSAN: data-race in try_to_migrate_one / zap_page_range_single_batched
To: Marco Elver <elver@google.com>
Cc: syzbot <syzbot+60192c8877d0bc92a92b@syzkaller.appspotmail.com>, 
	Liam.Howlett@oracle.com, akpm@linux-foundation.org, david@redhat.com, 
	harry.yoo@oracle.com, jannh@google.com, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, lorenzo.stoakes@oracle.com, riel@surriel.com, 
	syzkaller-bugs@googlegroups.com, vbabka@suse.cz
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 312CA140006
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: cqm47t53brth9wx7oj83oqju64r38xm3
X-HE-Tag: 1758879390-987546
X-HE-Meta: U2FsdGVkX18gMa+ZG5T6Uu2M1iNvLjztmIvNeOYGwXz7lj2s+kT0wGdMlm40nwl8ONRAAZpKwVc+/4ujqHhYQkww4wwG8DKDFZ7bG755AB8QgHJAzKu+q4JckBNnxaavYV91UG7drKB6k+RFoVtI700yvObNPjlV1WDqwu1g0EgfExEGuyJ5MGsJbdmE42rG0COe0ZFT22MP32v6Sbiclm6Xe4PsgfkJ14e0IrRm6Ccj/kiZYu1YsjKoxoMWuvgZ2AxpW/8RI8UqKAe0CPM7bNcXgNBJwsjMaEDL78X2up2dZ05E6dpvFT93L4huPX2sCXg/5/aKOpkr0SGz4gRTEXujwRk+INzklhffYMl32HP6uGanGfrpCUQche8+G2qUMgWqgVhLhqk4lmT+Dm46/qGHQ4rsQjyLYZfMOzYqcnaoJywnIuNemr8RXoO/TvIDFioHPCiGCwctjhlO1HiFwpRcObS15WmMNpaNA/DVbupxB86U0zc0MBV+TFkY4HhnphwvT9O4dcJO5ecUvSR98mrnNVTtNTUK/bAAMi7W26FrDe/A+nQ1bmLaMN2ph2TuzSvfIzU+kBKWG6epwZ7RK5WHeTW9KkFVt4Unt/RjM/DTxRk0hcy7cORLXMQB7zX9ahDiNEHaTHgYKFCYhINhzOPOr95RZMBMstKVlaH0ysqg0gFXaDsrlDEoPSlzEclhs0p1Y8MKTZKm6H8HPbq0I8EbT/oxqAWg03TkhDFHQY3FP3j2mWsUP0Et7Nsn6QeU4yjrsrDgyOShDsa7+xvI1wA2BJyq5xDIT7Dx8ePV8Pax7Ur1fM/klkmZntmhBv0LYLK6xctZ7679JEZmdQLvKULZds6ki60B83fgqdfInbbDA+Dx8fpcVDiYFswh/3uGRORqYOjnNxbvKfDuPkbfe4fcxY7oSOJKfHRPo424Ev0WESp3OTXYkCoe4BY9/zZyTE02nDSNnYns3YdkUjN
 o/fHHnTL
 8TyVS3nzRnCgRZZ+pyEM7CXSPZS1J7DdL5hDuunlCZypXvfayHYe094lRH5h1881mxX1ePk7lRnejp3lalRnoSVApKeoCIHk1mV/5FYCq9alakTu4bw6NpXWNnEt+JNjsy9VGVM7NwKrawknmuvJgEulAqcn1X7A2iw88R+aYnoCazWaRG/yrw6lyHBRXyA2CVqw/isyq5PWYp6SaDi0CLA9Um25kp5EPi1z25B6elttodpJAX9QjyDqlAU+lFxK2dQrcUiniaiAOwhgp1qvH6bAeYG4G3F9hzAfV1vod6OwJ5mzHB8cJfZ5KSf0CN1atOH0WyWWYZXSS26KC9B0LmdnkB8r3rUsLPi0dSEjlBl2t1LAmTIHIGOzyVVBIH6jvARmtwYxbd+I8pec4NuxP0U3Ia4zeVL3Ebu4enjSH3/nsrwGCXri369G+Z8APM9JRFtvfrY7P2Yeroqp7YDlSnPQalWHt3mrFXaFibntpBHeCn5ztzjU0ookuMYJDECYXRdYu7p/x46bFoW/NsI1c2IZE/4ciA/lG6gdBOS/4MacW+YbKVG4W7/jnC1xlq0ZCrhmXAtBGVQsDqfeqTD5o4Ar5znh7lWE1s5UgNGgfMRUU/B5UIGEsQ6yaVcUAGd0lkVqKBw2mdaz43OWGu08XcqEZM4qugWf2E+v5NKm699PIYUT/oMV/y3KP2PeSRUr01+x+5qRew0u1QzWXMJNgjPPagE1PMB+vJm3C9Y2Qh/Hyz5ltDlrbfSeBnwse8EKOOeRAlj4l835kVVzABmfdPNmNC09qz02XKyb50AbNJ9vyriQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 26, 2025 at 2:55=E2=80=AFPM Marco Elver <elver@google.com> wrot=
e:
>
> On Fri, 26 Sept 2025 at 08:44, syzbot
> <syzbot+60192c8877d0bc92a92b@syzkaller.appspotmail.com> wrote:
> >
> > Hello,
> >
> > syzbot found the following issue on:
> >
> > HEAD commit:    cec1e6e5d1ab Merge tag 'sched_ext-for-6.17-rc7-fixes' o=
f g..
> > git tree:       upstream
> > console output: https://syzkaller.appspot.com/x/log.txt?x=3D145d4f12580=
000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=3D6e0c213d073=
5f5dd
> > dashboard link: https://syzkaller.appspot.com/bug?extid=3D60192c8877d0b=
c92a92b
> > compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7=
976-1~exp1~20250708183702.136), Debian LLD 20.1.8
> >
> > Unfortunately, I don't have any reproducer for this issue yet.
> >
> > Downloadable assets:
> > disk image: https://storage.googleapis.com/syzbot-assets/10b7c8fdfdec/d=
isk-cec1e6e5.raw.xz
> > vmlinux: https://storage.googleapis.com/syzbot-assets/cbecc36962db/vmli=
nux-cec1e6e5.xz
> > kernel image: https://storage.googleapis.com/syzbot-assets/214f107d0a3e=
/bzImage-cec1e6e5.xz
> >
> > IMPORTANT: if you fix the issue, please add the following tag to the co=
mmit:
> > Reported-by: syzbot+60192c8877d0bc92a92b@syzkaller.appspotmail.com
> >
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > BUG: KCSAN: data-race in try_to_migrate_one / zap_page_range_single_bat=
ched
> >
> > write to 0xffff88810adfd798 of 8 bytes by task 13594 on cpu 1:
> >  update_hiwater_rss include/linux/mm.h:2657 [inline]
> >  try_to_migrate_one+0x918/0x16e0 mm/rmap.c:2455
> >  __rmap_walk_file+0x1ec/0x2b0 mm/rmap.c:2905
> >  try_to_migrate+0x1db/0x210 mm/rmap.c:-1
> >  migrate_folio_unmap mm/migrate.c:1324 [inline]
> >  migrate_pages_batch+0x6e1/0x1ae0 mm/migrate.c:1873
> >  migrate_pages_sync mm/migrate.c:1996 [inline]
> >  migrate_pages+0xf5f/0x1770 mm/migrate.c:2105
> >  do_mbind mm/mempolicy.c:1539 [inline]
> >  kernel_mbind mm/mempolicy.c:1682 [inline]
> >  __do_sys_mbind mm/mempolicy.c:1756 [inline]
> >  __se_sys_mbind+0x975/0xac0 mm/mempolicy.c:1752
> >  __x64_sys_mbind+0x78/0x90 mm/mempolicy.c:1752
> >  x64_sys_call+0x2932/0x2ff0 arch/x86/include/generated/asm/syscalls_64.=
h:238
> >  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
> >  do_syscall_64+0xd2/0x200 arch/x86/entry/syscall_64.c:94
> >  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> >
> > write to 0xffff88810adfd798 of 8 bytes by task 13595 on cpu 0:
> >  update_hiwater_rss include/linux/mm.h:2657 [inline]
> >  zap_page_range_single_batched+0x182/0x450 mm/memory.c:2007
> >  zap_page_range_single mm/memory.c:2041 [inline]
> >  unmap_mapping_range_vma mm/memory.c:4020 [inline]
> >  unmap_mapping_range_tree+0xfd/0x160 mm/memory.c:4037
> >  unmap_mapping_pages mm/memory.c:4103 [inline]
> >  unmap_mapping_range+0xe4/0xf0 mm/memory.c:4140
> >  shmem_fallocate+0x262/0x840 mm/shmem.c:3746
> >  vfs_fallocate+0x3b6/0x400 fs/open.c:342
> >  madvise_remove mm/madvise.c:1049 [inline]
> >  madvise_vma_behavior+0x192d/0x1cf0 mm/madvise.c:1346
> >  madvise_walk_vmas mm/madvise.c:1669 [inline]
> >  madvise_do_behavior+0x5b7/0x970 mm/madvise.c:1885
> >  do_madvise+0x10e/0x190 mm/madvise.c:1978
> >  __do_sys_madvise mm/madvise.c:1987 [inline]
> >  __se_sys_madvise mm/madvise.c:1985 [inline]
> >  __x64_sys_madvise+0x64/0x80 mm/madvise.c:1985
> >  x64_sys_call+0x1f1a/0x2ff0 arch/x86/include/generated/asm/syscalls_64.=
h:29
> >  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
> >  do_syscall_64+0xd2/0x200 arch/x86/entry/syscall_64.c:94
> >  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> >
> > value changed: 0x0000000000001645 -> 0x0000000000002165
>
> One of these writes is getting lost. Which means highwater_rss is
> lossy/approximate - does it matter?

Yes. IMO, hiwater_rss being lossy is an acceptable trade-off for a
non-critical accounting value. The patch[1] simply silences the KCSAN warni=
ng.

[1] https://lore.kernel.org/linux-mm/20250926092426.43312-1-lance.yang@linu=
x.dev/

