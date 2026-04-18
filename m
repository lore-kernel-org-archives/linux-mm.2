Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0584CF99C6E
	for <linux-mm@archiver.kernel.org>; Sat, 18 Apr 2026 00:26:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 36A7F6B0165; Fri, 17 Apr 2026 20:26:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2F4BF6B0166; Fri, 17 Apr 2026 20:26:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1BC1F6B0167; Fri, 17 Apr 2026 20:26:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 06C006B0165
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 20:26:15 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A79421A037B
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 00:26:14 +0000 (UTC)
X-FDA: 84669784668.17.6615D3C
Received: from mail-dl1-f41.google.com (mail-dl1-f41.google.com [74.125.82.41])
	by imf27.hostedemail.com (Postfix) with ESMTP id BDE174000E
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 00:26:12 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=bRTw6pLv;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf27.hostedemail.com: domain of elver@google.com designates 74.125.82.41 as permitted sender) smtp.mailfrom=elver@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776471972;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BBYx8lqQFpNN/1Ce068eiQv++zA9wz4NBo3lyxIE2as=;
	b=pKp7BsNHm/spGg8MLrCFTZolc9wlEXsgZZtHrRJgUxS+UvQfE0Nm4x1KcEngrJMfOwcXVj
	QIteznd6btK8FE9Vj9lMwj4iOIQ9xQv/72v+eVIZOWmInwlJscUJCEzSpUGJLZnJoXtj1V
	LAfy7HMuAdBMwx9v80gacDonTn9o0Aw=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1776471972; a=rsa-sha256;
	cv=pass;
	b=aiG+6DDh9mx0tntgn9d5elOzTo5DvPkmq5zwMleZst6g2sJZs/j4WYl3Hp4MbaCNm89RNK
	WaCbt2/j/CdU0MG5JgfXIRRB+MpfwlLowNgDSPfBm6FeoFWckUXGw5WpfBABOk9H9wOXA5
	DJsZK4lhYeKhKTbaGaroWAL2gOuSfR8=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=bRTw6pLv;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf27.hostedemail.com: domain of elver@google.com designates 74.125.82.41 as permitted sender) smtp.mailfrom=elver@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-dl1-f41.google.com with SMTP id a92af1059eb24-1279eced0b9so1861207c88.0
        for <linux-mm@kvack.org>; Fri, 17 Apr 2026 17:26:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776471971; cv=none;
        d=google.com; s=arc-20240605;
        b=PQ0H1PD7/xpcJGS3JVf0F56vRe6pdviNrWDhfS6c8Efo5QcseUka8sheFx9Ws19laf
         VC6fv4GjC30abiozn5f/PMPZs7dp/UY5jRMn/9On5nSHCbybhil2WbD4OvqLN/1Vyc7L
         wwSmINl6JABRGvSMAhz5OzHmGe7tRutxvMpxV1lE2bPQPIb4yo1BZDDnWw+0/psaz878
         4kNBpECUdoJWlZ1RiVZwK9cYvhQy8H8iQS4ygfpUYjp/jvHAeqOzfyVri0kW9So5U8G2
         yJzbWk2GxPghwhUBiOgeRffwgngOh/PvVAAzbbsC2nsoeU/j+5/XgN7Z9k2mX9m5eX0m
         AppA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=to:subject:message-id:date:from:in-reply-to:references:mime-version
         :dkim-signature;
        bh=BBYx8lqQFpNN/1Ce068eiQv++zA9wz4NBo3lyxIE2as=;
        fh=KBxUkQOKOunjwjOv4LrL7jAekovD1eInGrpeahmC7So=;
        b=CSQv88FjC7FessCwaHMr+dpwFBd/Laq851Xe7+19RKqt48mPdqawwwStAq6WUe3t7y
         N/k7A1d8S/6Swe10wauMEZWh68LDb8vIEB2/LuuM88SxDK17PJP/+FhI9/GfAC6XC8c1
         VyzdMz0FUYlmFBdfdJe3wrX4cn9lSGQIklybACYCq5+Ymaw0r4yB671IeV/zdm+JXAcj
         /+YPwEuTitcJMSH5yy468ke3KTNiwnaBmPBsXTTavWUQEPYT91V2reTVydGm4agBMbHb
         TwtCDdCKkraZRv5w/QSaFt87/z0cCGxuTMRWbK8koKO/vdB1N7LBuEiGVoMGwow+80Lb
         8+sA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1776471971; x=1777076771; darn=kvack.org;
        h=to:subject:message-id:date:from:in-reply-to:references:mime-version
         :from:to:cc:subject:date:message-id:reply-to;
        bh=BBYx8lqQFpNN/1Ce068eiQv++zA9wz4NBo3lyxIE2as=;
        b=bRTw6pLvvuBDKv3Mhc3d6aDBS52FLf75tTAgc0+wJohYx+F3zf0aKcUyO6EJGgjtGI
         SFbaKQEo9Epkc+hsX6BfikIxmTEjVv/Ajk4GXkQWjZ7Es43VXhnXXhlwZ5X6lbrz8x2F
         NpdiD6z1ND8ckia+lQdp9mbU3SAQ3OVfaUBZz2APCURlcDnYB20D0IDEwrGJEIqZQMuu
         uVl6GDm6HU323Ebo+29yktU6I5nsFlHRwmgnkjkL8p4TZmIKp4Nv5IR9L63E6cqm4vmk
         eByyDSU8UjT5wMlJ9nCADP5iDgGEyLuhiggYBRtKF/cWHrzEyg3IEKXYuojVYgaBmpbF
         9WBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776471971; x=1777076771;
        h=to:subject:message-id:date:from:in-reply-to:references:mime-version
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BBYx8lqQFpNN/1Ce068eiQv++zA9wz4NBo3lyxIE2as=;
        b=ZsdRGRsoZ9r6qCoUwKRMNQLD4bBEnZGgN38eI6Zbg4urpRP6Iwr/NM+5BtLtf2DsZv
         UyT7EUEyMCu1xQ0l6KqbNaRSmtWtxJuGrK2LhvyULzKgiJufKPBQtlMFkb7eGTpJq5g6
         OFAhN+mQIhE8rspgysu1/DWhp8dGf8sVcdCSfaj2x+OK/p5J2evDSa/vWyT/UvMyOwiy
         UygC0W3LJPZvtovwUeza+MobnTL0zwlbZeyImQ60vr/X57UUaXMU9OstehghJJZz82q0
         WV6gZzngC/jNUW/hYW1k6e7W15U6NTHbF7oQ3tLR0FHJNFmCV1i0+k2KX6pBxNc9IBSh
         d7DA==
X-Forwarded-Encrypted: i=1; AFNElJ9/A1ExrnC6gFmUUj2B2nYtOtjC+fBVGlDI+RyKXjXIGEMllC7O3BBJ88HGfZK0Wo/Ti2jGKaLBYA==@kvack.org
X-Gm-Message-State: AOJu0YziDurQFiK2EjbY1aLYO6kq2fA7jQ9VaorDrQx5dar1ihZOM43g
	SC201Rnz0ESP2iywgpsHAyu8LF7lNnjVtoLEfzB+16GFZJekzotwWlgAVrW4gDbYdAjvFWjCYDo
	6PsbFj8QkK4FpM0woLz2+jPf7pgyITdXyRl6MxiP4
X-Gm-Gg: AeBDieswb69vMcD8RclCKDO6EfL3SdC3G1OS0zXGm0Ic6ZJGXVGahdSJaI2UcTDnUWZ
	OrWkwQQIbbAOcbsSkJgEjLxxRMU0P91D6TR2zVEWHbjLVTnJ5ZrSz3PXsDgbcTrGXtHtphH54Sp
	ncOZLVFOCe6zPg7FLKO7WUXG8GLpdhxEFOZJZUU9m6ba4OFrqvnyk/DXUmGUEcdUlZDNPMOWVJW
	CokRasJ8bsUdAGek9emC5UFOXBDyhMH+Ry/xssXmKJ/IYgQ7jSKtp+8aMymq+9ErhbFOifxL/xV
	ZS8vnlYkconvWHMkwDUI9UMWioR09fHcBrxD92aedCNUUhlGS9uOztUE8xnc
X-Received: by 2002:a05:7022:60f:b0:12b:ed30:5a32 with SMTP id
 a92af1059eb24-12c73f6e183mr2304490c88.5.1776471970897; Fri, 17 Apr 2026
 17:26:10 -0700 (PDT)
MIME-Version: 1.0
References: <69e1f975.050a0220.1de265.0009.GAE@google.com> <twv35g3umuktagxixl7q4upjz6hxf2rkep2ophcwz2qzbschrf@dy7lcxu5wrly>
In-Reply-To: <twv35g3umuktagxixl7q4upjz6hxf2rkep2ophcwz2qzbschrf@dy7lcxu5wrly>
From: Marco Elver <elver@google.com>
Date: Sat, 18 Apr 2026 02:25:34 +0200
X-Gm-Features: AQROBzAmaQamRyo71JarhRb9ZR_1yHH07_eGnWhK7o88Yqt88_1Zhc-bmhyMpuo
Message-ID: <CANpmjNOG4mDJr+LSWWWJXru88yYrxG3wFBSiWzqUgn7Lm28bjg@mail.gmail.com>
Subject: Re: [syzbot] [mm?] KCSAN: data-race in mas_wr_store_entry /
 mtree_range_walk (2)
To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	syzbot <syzbot+38a879f4a73497f2dfef@syzkaller.appspotmail.com>, 
	akpm@linux-foundation.org, jannh@google.com, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, ljs@kernel.org, pfalcato@suse.de, 
	syzkaller-bugs@googlegroups.com, vbabka@kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: 9aas3hbgx1ca3ymo9dicreknjo8z91no
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: BDE174000E
X-Rspam-User: 
X-HE-Tag: 1776471972-408991
X-HE-Meta: U2FsdGVkX18M9w/CyhDRFRrpXYlQi9xRRZIucWZkYzO+9A48jPcKU2Cmblf9Wx7/B9V63pjVWqQlbVtoFfIQiXRx0LXs39Nf4ga63wFKUhEmrV5duQ+y2lKlrWN4puBrY70hyDz3WBaDXfoqZ8iAQBIIvA8Lp1AxjvnFBbB5RXS+PdRBwAk4qZmRRoDabJbQy1O6fTWKSWZlI8RsqBEjA9kb8dCsthiUQg/q7k5KPJpKqZKeDx99bAHK+N3512UTRwfHwTMx13xjQ8zYjdyK7fO+bt2fbfQifidAuqrRbZzHBpgySuXiLcps81oglIO1e6jSr9Ogdh6c5Zag/G/fi+YoMtjqLC5IL3BlUTrY179FN1G9Tb5KVMD2OKcDTGYWIZuhnDvuDLs1gkkvEGwwYeLB3V7gwakZh3g06W59rBQwELVvVbSaKFIwr2i9xLzlpeMAk6hIpOE4LftyUYS7bv2bdIuJyjs+l9xy7KE27Ftl0VppieIx4s85SSWvhIMi1oymxE9kR8rR7rVzUE/9QZ017ahFXmVRSpvnwBy4eyPCn1lMwiJCNSL+qOe+W1/yyT2wG2m8gg2qvVCdtfecTQ13DgDyilOdzvvRc65Ektm2yClE2RuBUabf1b70FXForOp8H8JNHOrUNGYFojIG8EASsIDfAMnb3mBMB9mLvFKfN9CF02xCVATboF5m6Nr1B5VZsbonaUAGe7vFMinkrnP66ucVsCK1lTU3aByhr9YGSJf+xKs/qSIACJWeMRKyeTxR+zoEGjSIFxYX2KeG/rzq0EzdNDMRb9TL7WXeBZoNNMvrr87G7/rKgLJaaHH6V1xbTolNL2LfkVFjSRU0x3jgWa+apC/+JMWBaJWP3iz0kTPjacjqpsoHyTSBTtPveyTR9t43jWaYy+F4B0N809SRCnPpYCOheQrkQYnCDCvVzqeg3SHTu+I5ZVmU5prcBNZtC5k8ynKDupqnT3G
 /y+BjhLR
 uPLTqOoEd/3ms0SALMlBoVJ7EV4AI+iiRvcGyvbRbHsufLqQ5DAkIylJKsO9Q/wZXXkmQ6xwze7jL6md1nK7hzEaWXJrZ97KGxNIbeohQ70SnS7Iu7hKTYWAudHdDanXqD0zUuHvvgT3tGJF7ikPOX8E5OxepyE4ud3qHeAG1gp9dUiEdkwGiJDvNFbi8QlZ5sks1fMhS6p4AHnxe7e48WZX9HCQXl+iCGzLW8YrGnLQtead+HZKr1FUgAAe1o/gbR4pQ2SDrvfiXvaeJ3Gh5KPJK8WHJBhQi2Lican/GUv/KkxtR1A+Xqh6FPQ3hg69dKznjQRT4z8V5mCeqXQKH48o2u5c2qLFyZJZp9Ea/I0VHqFYj394eIh7hZlIx4QxmrocW4UaVXhTLX7EQzn3mH07ZIEnuBnucjWZ7dBOJVJMi9H3iEAf4Bkg2rx7JC+UMe6aHfKmpPulqk1277vDxSHygR6HRLUkaOw8cEXo6KvVsn8tTB+92gayVwwuGToSj/4z0qNQSjOuZ6yDllqmEV4s1pjXBvQlFCa3FMRBAyF5AlD3Xwc9VXEtwYm7AOyfynT1CBMqWP1plhZbn6NrUrlMxJp6VJTWa2FCVXbKgOUqYCTDOY3KCx0/cZApqjD9yq0XewI6rV5mL6G16UEcnXr87S5HVdQtUmJ6TZrXNo5WJwlS5KPa+x2mgK+kJCpEBwhvs4opJG0fOBBjzRr2lhHlWYD92o7jzP5xbGYE3Gsu1y9dd9D+1MQYOGVgeZ5xejHAeierMt3qUfujrmUnM4QbyHeYl0bnXQXU9rYrTHP9MYN8IO1YGKejJEGql34qAaladRo119H/d4dsSLXTzvW2/YOtgu5Ar8sYDrGw+Lce7xVoS+heygdQTLzLlBevxLwi0kviKqTSviM8upGOPMN/LdtWh0fW6gWFmEemutczBYspZQHAb1S9iL3E4saQF0SmPY8BUz49deD2phNDWmps6uNnG
 pMH0xkmY
 tvpH/+3ZGvkHykOj+I/nT1GqYIcToaJoegyUTufo4bVi6473lv5tDYO6oUWiB+jMRnwQ1nrXKeMALl+We+JBCBC8VTc+ogLpOffptQYbBv3TSCcz6uAkmRvUyEyao9l2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 18 Apr 2026 at 01:51, 'Liam R. Howlett' via syzkaller-bugs
<syzkaller-bugs@googlegroups.com> wrote:
>
> * syzbot <syzbot+38a879f4a73497f2dfef@syzkaller.appspotmail.com> [260417 05:12]:
> > Hello,
> >
> > syzbot found the following issue on:
> >
> > HEAD commit:    1d51b370a0f8 Merge tag 'jfs-7.1' of github.com:kleikamp/li..
> > git tree:       upstream
> > console output: https://syzkaller.appspot.com/x/log.txt?x=117dc4ce580000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=7f207c4b1fbf85a3
> > dashboard link: https://syzkaller.appspot.com/bug?extid=38a879f4a73497f2dfef
> > compiler:       Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
> >
> > Unfortunately, I don't have any reproducer for this issue yet.
>
> ... and you won't.  This will work unless we tear aligned unsigned long
> writes/reads.
>
> I'm debating marking these as data_race().  Marking them all as
> READ_ONCE and this one write as WRITE_ONCE.  It seems overkill for
> something that won't happen.
>
> Alternatively, I can move the slot store fast path to need an
> allocation, but that's worse.

The writer:

>   rcu_assign_pointer(slots[offset + 1], wr_mas->entry);
>   wr_mas->pivots[offset] = mas->index - 1;  // <-- stores pivots[offset]

The reader races here:

>   if (pivots[offset] >= mas->index) {   // <-- load pivots[offset]
>       max = pivots[offset];  // <-- load pivots[offset] again
>       break;
>   }

The compiler is free to reload them as written. What if there's a
concurrent update between the first and second load?

> > Downloadable assets:
> > disk image: https://storage.googleapis.com/syzbot-assets/e08ff8d2b0e5/disk-1d51b370.raw.xz
> > vmlinux: https://storage.googleapis.com/syzbot-assets/c11d4b098bbf/vmlinux-1d51b370.xz
> > kernel image: https://storage.googleapis.com/syzbot-assets/6a4691f32e3d/bzImage-1d51b370.xz
> >
> > IMPORTANT: if you fix the issue, please add the following tag to the commit:
> > Reported-by: syzbot+38a879f4a73497f2dfef@syzkaller.appspotmail.com
> >
> > ==================================================================
> > BUG: KCSAN: data-race in mas_wr_store_entry / mtree_range_walk
> >
> > write to 0xffff888104f71d08 of 8 bytes by task 4757 on cpu 0:
> >  mas_wr_slot_store lib/maple_tree.c:3232 [inline]
> >  mas_wr_store_entry+0x3405/0x5ad0 lib/maple_tree.c:3528
> >  mas_store_prealloc+0x43e/0x690 lib/maple_tree.c:4936
> >  vma_iter_store_overwrite mm/vma.h:616 [inline]
> >  commit_merge+0x6a1/0x720 mm/vma.c:766
> >  vma_expand+0x301/0x460 mm/vma.c:1219
> >  vma_merge_new_range+0x29c/0x320 mm/vma.c:1112
> >  __mmap_region mm/vma.c:2766 [inline]
> >  mmap_region+0x1073/0x2110 mm/vma.c:2856
> >  do_mmap+0x9b2/0xbd0 mm/mmap.c:560
> >  vm_mmap_pgoff+0x183/0x2d0 mm/util.c:581
> >  ksys_mmap_pgoff+0xc1/0x310 mm/mmap.c:606
> >  x64_sys_call+0x14df/0x3020 arch/x86/include/generated/asm/syscalls_64.h:10
> >  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
> >  do_syscall_64+0x12c/0x3b0 arch/x86/entry/syscall_64.c:94
> >  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> >
> > read to 0xffff888104f71d08 of 8 bytes by task 4759 on cpu 1:
> >  mtree_range_walk+0x1a6/0x490 lib/maple_tree.c:2032
> >  mas_state_walk lib/maple_tree.c:2952 [inline]
> >  mas_walk+0x1cc/0x370 lib/maple_tree.c:4366
> >  lock_vma_under_rcu+0xc9/0x210 mm/mmap_lock.c:304
> >  do_user_addr_fault+0x232/0x1050 arch/x86/mm/fault.c:1325
> >  handle_page_fault arch/x86/mm/fault.c:1474 [inline]
> >  exc_page_fault+0x62/0xa0 arch/x86/mm/fault.c:1527
> >  asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:618
> >
> > value changed: 0x00007f68dc2a5fff -> 0x00007f68dc284fff
> >
> > Reported by Kernel Concurrency Sanitizer on:
> > CPU: 1 UID: 0 PID: 4759 Comm: syz.5.348 Not tainted syzkaller #0 PREEMPT(full)
> > Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 03/18/2026
> > ==================================================================
> > netlink: 64 bytes leftover after parsing attributes in process `syz.5.348'.
> >
> >
> > ---
> > This report is generated by a bot. It may contain errors.
> > See https://goo.gl/tpsmEJ for more information about syzbot.
> > syzbot engineers can be reached at syzkaller@googlegroups.com.
> >
> > syzbot will keep track of this issue. See:
> > https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> >
> > If the report is already addressed, let syzbot know by replying with:
> > #syz fix: exact-commit-title
> >
> > If you want to overwrite report's subsystems, reply with:
> > #syz set subsystems: new-subsystem
> > (See the list of subsystem names on the web dashboard)
> >
> > If the report is a duplicate of another one, reply with:
> > #syz dup: exact-subject-of-another-report
> >
> > If you want to undo deduplication, reply with:
> > #syz undup

