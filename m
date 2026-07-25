Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 45AE4C531D0
	for <linux-mm@archiver.kernel.org>; Sat, 25 Jul 2026 05:45:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0EFDB6B007B; Sat, 25 Jul 2026 01:45:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C7C16B0088; Sat, 25 Jul 2026 01:45:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F22A86B008A; Sat, 25 Jul 2026 01:45:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BF0F56B007B
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 01:45:08 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 38A0CA0EF1
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 05:45:08 +0000 (UTC)
X-FDA: 85026210696.03.4A57139
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 363F140003
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 05:45:06 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LmBJWFAb;
	spf=pass (imf12.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784958306;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t3qBjNX9IGmyjU2kexl4//bO2wn+DnODKQrpG0AjYwc=;
	b=1W9YgyEG2RfoiSxwelSwOEPnVCAIR9+HcT+js3bnL4y/XgcMx/RJLthIXgfIvdjLSZOFR1
	CYkXQwGRgMWYU9bTWTTBmhR6nSw9YDMwqvvvVV5v2UsToF49ERrEmh1bM8z5CrrY/8ZPSy
	DLBTSegG/UiBhKsfzWZ2KBsGEeuaYu4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784958306;
	b=yDGehxN8VRxTXVkzXPkhtFJTTTIPW95XDSzKIJfwEKL09PK5BsHCOGSC3JEpQPkdM5FHMT
	+RHw/f7ufqJ9/FBFMEJ6laVsgPnWnGBkK3+P/pKApJhHQUPacx8kf1myIwtkIcKNK4Q6iB
	YLyVUG9gzKJCjmiy0jUKUENqL+5Ylww=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LmBJWFAb;
	spf=pass (imf12.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id F0DE64503D
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 05:45:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7B5D1F00ADB
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 05:45:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784958304;
	bh=t3qBjNX9IGmyjU2kexl4//bO2wn+DnODKQrpG0AjYwc=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=LmBJWFAbLlQ7K5WSuxkohr0/P2tyJac1WkR4DSSqYH41/0xJD2A8FU0uZvVfHJ/km
	 ehzxvQgwpP8bx54m1Qj04j+bAYbgD1R/zHOfckfIJMnfsv+TSsdZtlEqU9YALD7aQm
	 r2xeabZnFOGriOinu46S5bRnUgQF0zvXm13twtYpnLLQLixvrBnsDWK2cDwRkO8JRA
	 35xSlyPLDSspkFga2wtiw2pWxB2yPmVoYdxMGRVtvDcNUe/MG2J/Ak/xFbCzT4UgJN
	 SAWfxQ4EmNH/o3L1nqfTt7T+4H+m4uJ/TR0xJh7wkmNMmL0dtoXV3vlYRWHCE1UAOY
	 +iEudIuj6qhMw==
Received: by mail-qk1-f178.google.com with SMTP id af79cd13be357-930f4e5eed1so92871085a.2
        for <linux-mm@kvack.org>; Fri, 24 Jul 2026 22:45:04 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RrVZXo2rhZmd7urung3vu3W5n+YJ3cSmQ8luOZpTo84loJ24H0o79fojdrJqB8jovjWpgJPOpQqNQ==@kvack.org
X-Gm-Message-State: AOJu0Yzp/pUZiSsm/quVplKcD62hUael0SqwWwHAjm678QwmnxLlrbd3
	JUqeUsUevJkeA9ltIGG1cp6vF7fJ8WHsp0+cb+xzVacjO7mfLjDABjcjSPwwLsfu5AX03tP+fAq
	9kEJpAj10dgb4GGkhi0xzt5TrnZmiWns=
X-Received: by 2002:a05:620a:4008:b0:92e:5856:bdcd with SMTP id
 af79cd13be357-932df708b5amr90245385a.53.1784958304055; Fri, 24 Jul 2026
 22:45:04 -0700 (PDT)
MIME-Version: 1.0
References: <20260722142936.3287702-1-dev.jain@arm.com>
In-Reply-To: <20260722142936.3287702-1-dev.jain@arm.com>
From: Barry Song <baohua@kernel.org>
Date: Sat, 25 Jul 2026 13:44:52 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4wetarsg0fFvNdeWrCa+Ka97jjmgdRsmPJJZbUFyUxjEw@mail.gmail.com>
X-Gm-Features: AUfX_mxNkc16w4WJcIVQZjkpKej00po33fTMdmd1bQ675RV-4AjKTHcthRpmOqY
Message-ID: <CAGsJ_4wetarsg0fFvNdeWrCa+Ka97jjmgdRsmPJJZbUFyUxjEw@mail.gmail.com>
Subject: Re: [PATCH] mm/usercopy: harden bounds checking for vmalloc allocations
To: Dev Jain <dev.jain@arm.com>
Cc: kees@kernel.org, akpm@linux-foundation.org, gustavoars@kernel.org, 
	linux-hardening@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, ryan.roberts@arm.com, anshuman.khandual@arm.com, 
	david@kernel.org, urezki@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 363F140003
X-Stat-Signature: p5k664wqqqe7j6gyn3zhg8rgbpgtynnd
X-Rspam-User: 
X-HE-Tag: 1784958306-961083
X-HE-Meta: U2FsdGVkX19eEJj4kifMQeddgiry3p+g93FmSVJ12W12RxMMPEGhol2gUuNUqQA4DsuATTIwLocmJbiWRxCyHMbdChukeK5fIarugeR1vl39DlULkEPlgfQTZCYye5jHqtvBiL8JIbiHP1KHoajJbf/os1czqQL8jdaiwoRO7rjp9Csl7BqoBL9rO/r1Pv11XPbFLvwUEAF4mmomrIRAJtwH+3U1MPUV4T66AvLTycvOXVU/JwI1TdVOoPuR4dFMHrEWF1qzz7yEBXc4xnKn+MXt2lg8lwQLv8ItOBc1GFMc+3tkC7YVazdXSUkpauKLJN71kBbZTZgoQksWNfekLKazIKk8UiE5D5bGAY5CGO1CeqUMX4lurWNGrqIlAYoSG6GcJ6W2OwfzSbRrSeSJTHXv+Z6X7UVggQRp4cE3sn1yhV4yZjoZ5xjrNZV+WDLLSKv34X+IFGv6AF9P3Tg+/KrZEtrbje/uZbmwLOHY+fklTQkB6ZIxuEwh23gfYg8yFVa7b6VTm6iKPan3BX/DpRjsSyMhH//zaExIRfbUWcrhozWN4JA+sr1uJvJoJH2YMqB/tpq/83Mnt8ngSN+EAv+qCJtQgnp3Ym1lc1JGsOlmt/7Fvk2W1k/9k5I8u91/2Zn/brI84ZJjsSbYuMsLSE3DY/WUv0CWz8JEQ1gtHKvQJKVIcBcLJGKSr9wc1//BEx3FI917EFEvQjRcVea0EWlxveMHx7HK7b/eESvgPAygDn1gRJuX0TDoQt/A0uaq0F7086DikhQht0A+T9k/1roefGfefTLbZsjOkhpiXVBwoeMQ0TOCaTk8UaxFbvjNxeY59rA5FltP71J/qtA/u5u96RQ3K1xhWTTC3BccCpnMvmZ4aWfywVXhfKLaC2YimNCI3pMy0fMtDFPvsDWYdNFcfcZL9ES4wdq/iHNwiQm9SaRsM/vaBd2BlrboCxsmFUgAtjxqthaeA5Y6hLG
 CzS0jAJ3
 q4Mm/2gKB8OcEe9SECp+3VH4akxq4Mwc1WCWN8t7c9z5QaIOQmNbmu/VUKj0oVxvN+N6hArV6rAtOMlzxTTAlqfUd5f9aZjbSBSKTI1GS5ZCFFc4XD1AgOgv8YsWF2R0XJ05aNORw7ul2a4MmkRw1RVaLDK3HXBXYjasR0z7pEKui67r6jZWQX2+HzLgcb7JQy98mrLYJOQItAMGMXMWQDEugvKSWRMWq31k/s1Mo3JIPVQ3GodqdZJB56M2Xbn4AB59mGGLT33F2WJqpAQ7hGr4sBST10ahPJiiCdX2/IRoE/TfTjkkkMLwxR0gFmHT59lOLe10Za8VMvpjx+fCE2YbayuhLNBk+vrYtpzk3LnXZyw+ZBOHJ0fkIBg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 22, 2026 at 10:43=E2=80=AFPM Dev Jain <dev.jain@arm.com> wrote:
>
> The vmalloc allocator stores the actual allocation size inside the
> vm_struct structure. We can use this bound in usercopy instead of the
> page-aligned va_end to catch usercopy beyond the actual allocation size.
>
> For vmap, the requested_size field is always page-aligned since it maps a
> certain number of pages. Same for vm_map_ram (alongwith, not even having
> a vm_struct). So the check is only relevant for vmalloc mappings.
>
> Because there are early vm areas registered even before vmalloc_init,
> requested_size may be zero. So also check whether the requested_size
> is set.
>
> Signed-off-by: Dev Jain <dev.jain@arm.com>
> ---

I wrote the test module below to verify the impact on user-space behavior.

#include <linux/module.h>
#include <linux/kernel.h>
#include <linux/proc_fs.h>
#include <linux/uaccess.h>
#include <linux/vmalloc.h>

#define PROC_NAME "copy_bug"

static ssize_t copy_bug_read(struct file *file, char __user *buf,
size_t count, loff_t *ppos)
{
        volatile int alloc_len =3D 5 * 1024, copy_len =3D 6 * 1024;
        void *kbuf;
        int ret;

        if (*ppos)
                return 0;

        kbuf =3D vmalloc(alloc_len);
        if (!kbuf)
                return -ENOMEM;
        memset(kbuf, 0, alloc_len);

        ret =3D copy_to_user(buf, kbuf, copy_len);
        pr_info("copy_bug: copy_to_user returned %d count:%ld\n", ret, coun=
t);
        vfree(kbuf);
        return count;
}

static const struct proc_ops copy_bug_ops =3D {
        .proc_read =3D copy_bug_read,
};

static int __init copy_bug_init(void)
{
        proc_create(PROC_NAME, 0444, NULL, &copy_bug_ops);
        return 0;
}

static void __exit copy_bug_exit(void)
{
        remove_proc_entry(PROC_NAME, NULL);
}

module_init(copy_bug_init);
module_exit(copy_bug_exit);
MODULE_LICENSE("GPL");

without the patch:
/ # cat /proc/copy_bug
[    6.517711] copy_bug: copy_to_user returned 0 count:131072
[    6.655611] copy_bug: copy_to_user returned 0 count:131072
[    6.783372] copy_bug: copy_to_user returned 0 count:131072
[    6.912167] copy_bug: copy_to_user returned 0 count:131072
[    7.039019] copy_bug: copy_to_user returned 0 count:131072

with the patch:

/ # cat /proc/copy_bug
[   11.298890] usercopy: Kernel memory exposure attempt detected from
vmalloc (offset 0, size 6144)!
[   11.299246] ------------[ cut here ]------------
[   11.299276] kernel BUG at mm/usercopy.c:102!
[   11.299616] Internal error: Oops - BUG: 00000000f2000800 [#1]  SMP
[   11.300458] CPU: 1 UID: 0 PID: 74 Comm: cat Not tainted
7.2.0-rc4-g6b5aeb5cf21a-dirty #1033 PREEMPT
[   11.300730] Hardware name: linux,dummy-virt (DT)
[   11.300940] pstate: 60000005 (nZCv daif -PAN -UAO -TCO -DIT -SSBS BTYPE=
=3D--)
[   11.301088] pc : usercopy_abort+0x94/0x98
[   11.301190] lr : usercopy_abort+0x94/0x98
[   11.301280] sp : ffff800083643c40
[   11.301358] x29: ffff800083643c50 x28: ffff000004373700 x27: 00000000000=
00000
[   11.301994] x26: 0000000000000000 x25: 0000000000000000 x24: 00000000000=
00001
[   11.302152] x23: 0000000000020000 x22: 0000000000000001 x21: ffff8000833=
a6800
[   11.302298] x20: 0000000000001800 x19: ffff8000833a5000 x18: 00000000fff=
fffff
[   11.302440] x17: 2820636f6c6c616d x16: 76206d6f72662064 x15: 65746365746=
56420
[   11.302580] x14: 74706d6574746120 x13: 0000000000020000 x12: 00000000000=
08000
[   11.302720] x11: ffff800082271138 x10: ffff800082181534 x9 : ffff8000801=
2842c
[   11.302878] x8 : ffff000004373700 x7 : ffff80008012782c x6 : 00000000000=
00001
[   11.303024] x5 : 0000000000001297 x4 : 0000000000000000 x3 : 00000000000=
00000
[   11.303162] x2 : 0000000000000000 x1 : ffff000004373700 x0 : 00000000000=
00055
[   11.303378] Call trace:
[   11.303572]  usercopy_abort+0x94/0x98 (P)
[   11.303744]  __check_object_size+0x1dc/0x360
[   11.303834]  copy_bug_read+0x9c/0x1a0
[   11.303910]  proc_reg_read+0xa4/0x100
[   11.303986]  vfs_read+0xcc/0x2f8
[   11.304064]  ksys_read+0x74/0x118
[   11.304134]  __arm64_sys_read+0x24/0x38
[   11.304212]  invoke_syscall+0x5c/0x120
[   11.304288]  el0_svc_common.constprop.0+0x48/0xf0
[   11.304378]  do_el0_svc+0x24/0x38
[   11.304448]  el0_svc+0x58/0x3f0
[   11.304518]  el0t_64_sync_handler+0xa0/0xe8
[   11.304598]  el0t_64_sync+0x1ac/0x1b0
[   11.304814] Code: aa0003e3 d000e3e0 91378000 97ffec92 (d4210000)
[   11.305138] ---[ end trace 0000000000000000 ]---
[   11.305390] note: cat[74] exited with irqs disabled
[   11.305542] note: cat[74] exited with preempt_count 1
[   11.307308] ------------[ cut here ]------------

So:

Tested-by: Barry Song <baohua@kernel.org>
Reviewed-by: Barry Song <baohua@kernel.org>

