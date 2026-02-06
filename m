Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D5123EB28D4
	for <linux-mm@archiver.kernel.org>; Fri,  6 Feb 2026 07:31:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2B49A6B0093; Fri,  6 Feb 2026 02:31:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 262F86B0096; Fri,  6 Feb 2026 02:31:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1366E6B0098; Fri,  6 Feb 2026 02:31:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 002646B0093
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 02:31:34 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 936CF1B1A36
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 07:31:34 +0000 (UTC)
X-FDA: 84413211708.09.CCCB55D
Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com [209.85.167.44])
	by imf28.hostedemail.com (Postfix) with ESMTP id 8FFC5C0002
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 07:31:32 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Nu2olTHb;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf28.hostedemail.com: domain of dvyukov@google.com designates 209.85.167.44 as permitted sender) smtp.mailfrom=dvyukov@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770363092;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AzhRNn4TRcoUApoouAvvxIqUSyjUpCRjRf8yuPMUqoA=;
	b=f5VgbgZCxkSv69sx9jiGhXA90yXgA2bGuvbl7KKRhlgwv0i/Tz7be6UjOnrp1RnmH8wpX3
	mb/LM3eBwtkf3Okk+iiBDcdLMGKWtCzYlpNQGY4URkoKNoIIfQQxAv3g4YGoCfKZbe4QAY
	OghHis5YJVs/hNxn00abJyZuq/BUdOk=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770363092; a=rsa-sha256;
	cv=pass;
	b=ESuiuLeRY6tmDJOJ2rwGVJan/NlBohCymZeD6xnnYdBZbfXCJ7ZBT8LqAA/VhlLepm+Hj/
	efHrBhEHQf2AfF/KHU14kjhCEnSKDpSE+UIwiE9DduecEnAbWED79LXC7fMfoE0JeN26w9
	tT4BVQTBGzWB86STdTya4xXUeg7NQwI=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Nu2olTHb;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf28.hostedemail.com: domain of dvyukov@google.com designates 209.85.167.44 as permitted sender) smtp.mailfrom=dvyukov@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-lf1-f44.google.com with SMTP id 2adb3069b0e04-59b6d5bd575so1857710e87.1
        for <linux-mm@kvack.org>; Thu, 05 Feb 2026 23:31:32 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770363091; cv=none;
        d=google.com; s=arc-20240605;
        b=bGwGRYo/Fn6sXqedpWwNYP/m3PVXP4bUU+5E++21t+pqmCB+TRZkm5zjR51tYcRTwL
         +M3AasEoind7tJ6/ZfYjFzceK2GJtrWR1fg9+OBFPIfacQP7iHPk1/vEiohCDvHJBKoI
         g2rf6dXYxVppPOrjJUPtwOvuDaUzweu0Q7DksiBUp5KeChRfZKo5UmJK0EjcVfrVPr18
         Ja0ttDLrMnlDaLWfwSFZZJdAJPZHjlb9qt+rfgDKV86DHW2zaGtXJPyWtGq6CyHsF1wG
         EMUQcdwITrLqACKdfe49baQXSswOtnrRq0kVTfUi4MkWA86hjteB1KM8QYeMuW1mLtgg
         tT0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=AzhRNn4TRcoUApoouAvvxIqUSyjUpCRjRf8yuPMUqoA=;
        fh=5csbgBAAfvFKrlkXM5ZT0f9J4/MBs0UHjLJ21ofYXN8=;
        b=YPJUQucE3q5pP6uRXoKiiGQf3y+YT0SIsQ2UV1YGUbFzJq9ZG/2AfBkrOvUVviYweJ
         KzGJAerxPlYYQOV5fhFmu/oD75vZqqA8xD47lbzezFT1JLPxMA+SisgzEgqlkccwnkR6
         8d4Xt8Y1kpKHaQcCHzsapnKVPj9S7jqpR6aDfagTuFcFYl0rQuQbyDsZuJNaMmvX7RJ4
         keZhGxZHQCeyayK4zwCD553KG5rWZm/pvV4zFT507rX22eO0C1993oEm0jqfAZryjlM9
         2FIpkzNJ8gQT096JAXFe3li0V9hwwva6DqBmK96VRKF9CygJj8696ZU5niR+gvHLrPCM
         7xbg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770363091; x=1770967891; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=AzhRNn4TRcoUApoouAvvxIqUSyjUpCRjRf8yuPMUqoA=;
        b=Nu2olTHbO0Bg03uUhOXFUyD0JhgOuq5EhrEvW0gxyJ9XTPHXA+3NnFkY1f81CtSrSe
         zuQHgv15DHW1g8Lo5PLBYTeCE/YuXA5P/ehky2j4sbov65Qj4r4m9zKFLu/tgvU4mnjW
         dhWXHXqpkWri9k0CTHood66J7JIf7fliU6HWpy1ebLrrYLs0BP++gKUbhaTH+zC6PDXI
         RO6bRSkDWUzMmrbF4wBnBgBDKPC5oMRODDSlFfqa2hfUtZ6/yoe5ytrP7uwPkWFfCpUI
         w509fs5mAWjzP8XwnZt5ZMujKLEZz+C1Bg5Gm7UFyP8mqnMPRXLfkSoyOyJSfmNup0lJ
         ElSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770363091; x=1770967891;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AzhRNn4TRcoUApoouAvvxIqUSyjUpCRjRf8yuPMUqoA=;
        b=LdiO/aaS96O7uhWj8cDVZyFU06Tf6AbJSuFZgfg8WOyGZEBKA55a9dM/n3YxP9UnUG
         0eAOfrjTwXKjy/CDH975VpjJfJMJheWrXDksJfKtv9SNDxjlAqE6FJnzSb6XsDV+e7OZ
         J7yLKuQtU8BzB+5SQ+OvWqpnfzyhgbXVoouenBIW8tKb4kZO37aQhb8r+PVD7o6JDTe5
         wLmcRJ053P7QIvx/5p7thF/aflIcRMw6weA2u/T2fots95ouIXiX6hhB9uY+I7NvPzHN
         svxZrvWzeMhrFRQHcuwD2GAyeiuNpfdDf7Zl0ah123/f6OwWG7arV0THnSrebc/GGCJR
         eHHg==
X-Forwarded-Encrypted: i=1; AJvYcCWzsrkFEG0uIfEiA8QNtJ4ZeWkOXY5V7OH1QFXkrzAmm85+WfLv9ErdfR1K1w9ULVOre9STjM8vqw==@kvack.org
X-Gm-Message-State: AOJu0YyBvmb5gJLSB1lrK8ZvIcFCKovfa2/KOYdXAefhA/W0/tTOOIuF
	0Vl7jAl0iUXWY7x/40IesvCXySIGVfGr34fZGDDwxV/YD7Wyb7YfW5RfMpvILCVlLU7v5WKckDx
	QW930/MJx2FV5oL6W66FkDASdv5wpwGAtmSioqtao
X-Gm-Gg: AZuq6aJZZK6SPhIoq2baA25FPA+SmOfPWL5BWDHKXGiLjn+wrwWFi9XzHHqjZq4HutB
	aJfb+GjKlA+xNEB0c0XMTl5rZZZX/11Fw/Ml3DnarNJiCUqGhVzspTvQz2rd82vZoJji2NrEeBb
	bWIN85zErKVEXzfvYGiVN2f8zuhQDlOJra7KXmu6VFHHgLSIbUijRu7WxzFJD5UlgOGi9zlGVN+
	OARigUO/eHboUiXgyyx6IbE2n+UwVuc7XO6dFidvc16R+EigKpLk7lkAEEFIGjOn8kdcifRS4C4
	I22feukdNtexwETN2wWMGtlCHOOO+VnUIdMUTJA=
X-Received: by 2002:ac2:51c3:0:b0:59d:d1f0:a76a with SMTP id
 2adb3069b0e04-59e450440f3mr515122e87.7.1770363090363; Thu, 05 Feb 2026
 23:31:30 -0800 (PST)
MIME-Version: 1.0
References: <69859728.050a0220.3b3015.0033.GAE@google.com>
In-Reply-To: <69859728.050a0220.3b3015.0033.GAE@google.com>
From: Dmitry Vyukov <dvyukov@google.com>
Date: Fri, 6 Feb 2026 08:31:19 +0100
X-Gm-Features: AZwV_QhOFdnB0m5Ad97mbhbaY-W6xpdlp3ux9BAVJiSy8vSV-fBjGk_XoVNPMww
Message-ID: <CACT4Y+bd+PcL=XzkehM-bmsfAB95UA2y9jr5JY2ov8zVOp1DWA@mail.gmail.com>
Subject: Re: [syzbot] [cgroups?] [mm?] KASAN: wild-memory-access Read in
 lookup_swap_cgroup_id (2)
To: syzbot <syzbot+e12bd9ca48157add237a@syzkaller.appspotmail.com>
Cc: akpm@linux-foundation.org, cgroups@vger.kernel.org, hannes@cmpxchg.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, mhocko@kernel.org, 
	muchun.song@linux.dev, roman.gushchin@linux.dev, shakeel.butt@linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 8FFC5C0002
X-Stat-Signature: 9rchuhbkwqckski5f4ptyna5xyuuob7q
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1770363092-84255
X-HE-Meta: U2FsdGVkX1/8k7k7pI6BHMTzBvW4HZkAjvrQKojKmBFs9GjG0xhhTweh1d8QWb3fVfrZ0OpCQWra9yn9YIH7bBSOJYdp6lUtLrSUMDgkXZYolDNsumUD+DxQE+AtpqXyfJvI+aHupaN8HzOrXrb4W8DTcbVLX+7dte2DzeaUvOy948Sq2s2b5eBVxN36MDuKzfgnnCXiUZwEd4f19DsVlDgMxQVm0zN0vrulAIPFie1Q7phCfS7wvBWuES17VN2j6D9XW/qz5qSyYlIzUrtDkAhqPTL9vYOnvgCy//f+3hpqXPEVAu3mPhHZeXzYjK96ESXIEDfCCP7zWmSDzBCAXaGxw26bixZV32CPeVAKOtzIThIyKFGR49/aXX2x6x7Dl/xiGUfBZj2AMq1snfsJfXx+FGmmqWDxEPX8Veyh3KP8Rzelkd+bBZOQIjEoMu41QlD49I7cHJErK9MZzalP2TqxYvHyRkbufkz7bYJNo0kkEkR0C/tdfbo23+NEU2vW91/hNTfkOnIXgsEjXExuzOZMphb3DPm0HSgrzQ0J4lMKJXb7V7JDw/SHqMRxl3+UqiAYHymlShPZCiwtZgI1Cb6Hag2ZMij2NpRr6oz3V0khIjUNm8PZ7XhwsBb6R9saRmglgvH6Lr54C9eWZCLw3ECgHIJDqEZB9GD6aMXo0sRynQq5Q6vi65Nlt/26BreIaz8ypsulezfXLLZnp48KFs6LMq9Zb5nER6/p5+nugdiwQQn5oMH5z+9NnuoJQmRMWCvsHRKroLzzlHV1s79DtR/mAEJ3kvH4EMmssD6+htscCBSMHrGfwaVOT7Nw2vaJvKYLLHIixM9QiIHhCKD0j8n3Qo6L2xQSLoUJQI9sm0VFmwW+vqH28jwmkulUmVfyVZJNBWco8A6D7XdCp0LOnD8zfCOYt+Oqk03sNv6lg56M524dFF1hpXJyH7EFRciQQR4xJxMY8PtzyOBvftJ
 H4/8LryG
 Hjn1THezIw/WscNPFz9ZAq4ofoQeNjOYXjlbe76I/9iAsfNwjX2bJ3rPJlsk9+9Vkxi8Ys+6VYX7XRcSVZPLYtjFINnm/DrwZLywP/7nT5h/Xe/HCo96Ax7OJQEjR4zl8e9X7AqRvcGQG3E2w08cFVVml1FoOOiXglrVQuWSfug20b+Ww71JXaYKlsdnfiiJ52cDO+g9tGOazNuiLypkP6wjkeutbc0LjtMOaXPANbGSG+cLL+cAaUaBaXgTdxPMM+gPuy3HDC2ajRSnNYGR49tCM33OotHcA3E8cMgGYQWLl2vPm7iQPIm7bthFo+bR+tOXYwdLkBIU3Yh3LhCz1oS8x+HWryTK4rjQCCMzazgWBSCi26l97XSGLTtOvH424pvlrmJyJBl9ErsnsRr8BgLcsZ6qtcWpHBvAf3hdqBhLsgNoNbX2pGRujlx7gkttMnwgJu1c3OgoYj9DFxctUv/tjnLXuwlpCurBb4wedwwKvZWMxWwDxM93Zy1exkXKS4F9wfB8+MvKQeoOe4t643vUaT7VrTsySWq9q4iXpURqFA9qb1LdIgqiIZ2JApylyvPl6UO7+wYlp0YYFXRaDe6fk8WJ5FRJ8ia4hMfhE3diI+xVjzJ+M1YXsw/iSx0eoxc4t5FUcgJvPQFrg+V7LlpbeW7MktwtQM7hkNAFCFPVdX3JXSoNzLvxvHqtAeno16wdCL2xj7baPOlpJpb2TKdHrvd9EPl1iH58Po4WyEt8fddvZr6FNJEmRbmT9fHWPHBn7OZH0AI/sCgBl13y8uk9EW5aeKcCSKc0kgjEVpgKaWtZnnldp/2iQW2r4zjx9cG2bQJDkPSPrsXIb7ykumXyI8jlJpL/P7b8R7teelwbnQddiTJPjjLoMLDMUlJPN6r/kP/9zFLmfGVlb8M7uSOwdFjEemveZHrnSh2+cECfvF42Sp1QSqgQD2DVFNflPAdfzpe7Gx89G9ctpBaPRjzuC9RP8
 +mL4cbyx
 DwFQhO4kz87F0tPOzAkXjhOP4pKKgs6I
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 6 Feb 2026 at 08:24, syzbot
<syzbot+e12bd9ca48157add237a@syzkaller.appspotmail.com> wrote:
>
> Hello,
>
> syzbot found the following issue on:
>
> HEAD commit:    18f7fcd5e69a Linux 6.19-rc8
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=1428fc5a580000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=f1fac0919970b671
> dashboard link: https://syzkaller.appspot.com/bug?extid=e12bd9ca48157add237a
> compiler:       gcc (Debian 14.2.0-19) 14.2.0, GNU ld (GNU Binutils for Debian) 2.44
>
> Unfortunately, I don't have any reproducer for this issue yet.
>
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/2c19d9acc149/disk-18f7fcd5.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/02cf07c94e58/vmlinux-18f7fcd5.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/84011cec9819/bzImage-18f7fcd5.xz
>
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+e12bd9ca48157add237a@syzkaller.appspotmail.com
>
> ==================================================================
> BUG: KASAN: wild-memory-access in instrument_atomic_read include/linux/instrumented.h:68 [inline]
> BUG: KASAN: wild-memory-access in atomic_read include/linux/atomic/atomic-instrumented.h:32 [inline]
> BUG: KASAN: wild-memory-access in __swap_cgroup_id_lookup mm/swap_cgroup.c:28 [inline]
> BUG: KASAN: wild-memory-access in lookup_swap_cgroup_id+0xf9/0x1a0 mm/swap_cgroup.c:127
> Read of size 4 at addr 0007fffffffffffc by task syz.5.3598/20029
>
> CPU: 1 UID: 0 PID: 20029 Comm: syz.5.3598 Tainted: G             L      syzkaller #0 PREEMPT(full)
> Tainted: [L]=SOFTLOCKUP
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/24/2026
> Call Trace:
>  <TASK>
>  __dump_stack lib/dump_stack.c:94 [inline]
>  dump_stack_lvl+0x100/0x190 lib/dump_stack.c:120
>  kasan_report+0xdf/0x1a0 mm/kasan/report.c:595
>  check_region_inline mm/kasan/generic.c:186 [inline]
>  kasan_check_range+0x10f/0x1e0 mm/kasan/generic.c:200
>  instrument_atomic_read include/linux/instrumented.h:68 [inline]
>  atomic_read include/linux/atomic/atomic-instrumented.h:32 [inline]
>  __swap_cgroup_id_lookup mm/swap_cgroup.c:28 [inline]
>  lookup_swap_cgroup_id+0xf9/0x1a0 mm/swap_cgroup.c:127
>  swap_pte_batch+0x3c3/0x720 mm/internal.h:390
>  zap_nonpresent_ptes mm/memory.c:1749 [inline]
>  do_zap_pte_range mm/memory.c:1818 [inline]
>  zap_pte_range mm/memory.c:1858 [inline]
>  zap_pmd_range mm/memory.c:1950 [inline]
>  zap_pud_range mm/memory.c:1978 [inline]
>  zap_p4d_range mm/memory.c:1999 [inline]
>  unmap_page_range+0x1f6f/0x43e0 mm/memory.c:2020
>  unmap_single_vma+0x153/0x240 mm/memory.c:2062
>  unmap_vmas+0x218/0x470 mm/memory.c:2104
>  exit_mmap+0x181/0xae0 mm/mmap.c:1277
>  __mmput+0x12a/0x410 kernel/fork.c:1173
>  mmput+0x67/0x80 kernel/fork.c:1196
>  exit_mm kernel/exit.c:581 [inline]
>  do_exit+0x78a/0x2a30 kernel/exit.c:959
>  do_group_exit+0xd5/0x2a0 kernel/exit.c:1112
>  get_signal+0x1ec7/0x21e0 kernel/signal.c:3034
>  arch_do_signal_or_restart+0x91/0x7a0 arch/x86/kernel/signal.c:337
>  __exit_to_user_mode_loop kernel/entry/common.c:41 [inline]
>  exit_to_user_mode_loop+0x86/0x4b0 kernel/entry/common.c:75
>  __exit_to_user_mode_prepare include/linux/irq-entry-common.h:226 [inline]
>  syscall_exit_to_user_mode_prepare include/linux/irq-entry-common.h:256 [inline]
>  syscall_exit_to_user_mode_work include/linux/entry-common.h:159 [inline]
>  syscall_exit_to_user_mode include/linux/entry-common.h:194 [inline]
>  do_syscall_64+0x4fe/0xf80 arch/x86/entry/syscall_64.c:100
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f2f8f19aeb9
> Code: Unable to access opcode bytes at 0x7f2f8f19ae8f.
> RSP: 002b:00007f2f900350e8 EFLAGS: 00000246 ORIG_RAX: 00000000000000ca
> RAX: fffffffffffffe00 RBX: 00007f2f8f416098 RCX: 00007f2f8f19aeb9
> RDX: 0000000000000000 RSI: 0000000000000080 RDI: 00007f2f8f416098
> RBP: 00007f2f8f416090 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007f2f8f416128 R14: 00007ffc0c8cc050 R15: 00007ffc0c8cc138
>  </TASK>
> ==================================================================

This happened before:
https://lore.kernel.org/all/67d04360.050a0220.1939a6.000e.GAE@google.com/T/
and now 2 more times.
All reports look similar: exit_mm -> zap_p4d_range
And all access addresses look the same: top 13 bits are zeros, then
some garbage (0007fffffffffffc).
I am pretty sure it's telling us something, some kind of tricky race,
rather than a previous corruption. Swp entry is somehow invalid?

