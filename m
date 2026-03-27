Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3B59F10BA420
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 04:32:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 426206B0005; Fri, 27 Mar 2026 00:32:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3D7666B0096; Fri, 27 Mar 2026 00:32:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2ED626B0098; Fri, 27 Mar 2026 00:32:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 19B4D6B0096
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 00:32:44 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 64509C493F
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 04:32:43 +0000 (UTC)
X-FDA: 84590572206.11.CE1F96B
Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	by imf12.hostedemail.com (Postfix) with ESMTP id 5BC6E40006
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 04:32:41 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=IV9g2VyS;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf12.hostedemail.com: domain of surenb@google.com designates 209.85.160.181 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774585961; a=rsa-sha256;
	cv=pass;
	b=sRgsHy1dzTDiHaZX5dUmgLwZNcve/jdpTNfQlFA5urdPaAmstJLLcP0P6coi4iSkt/I8ij
	/WQQxLY5Y0Xr8Btz6GINuNTqwcxHyfU49CY/xxOFy4sOQtBWWeQnYMV9DepZEolaUkKOsj
	e0KL4Y7F8Snl+DKlVfhYZeI/AVEnPpo=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=IV9g2VyS;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf12.hostedemail.com: domain of surenb@google.com designates 209.85.160.181 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774585961;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qU/ZIM2Mcm2RW8IgIxFK50F6kojUkSG/GFHPDhmdkds=;
	b=dvrEVbBJkwax8MNkWbMMiRTtmtBLOb5F0B0JKZDmt2hiA/OAdpebDQXsCY+KvqXNtE6+zy
	B8PWwC9JD4xyD/ZcF/NVr1ESDB5GyqKjoDLjv9b2xBpKBQ7Suc2+V9XVaPFOTKORVF9FdU
	dGiIY6QohwS6HMtpolB8fBbQ7dFQqKU=
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-5091ed02c54so240921cf.1
        for <linux-mm@kvack.org>; Thu, 26 Mar 2026 21:32:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774585960; cv=none;
        d=google.com; s=arc-20240605;
        b=a183R2gPlI/EP8D915jUYRLcPM+7lHOvVdObcGmjvmvoi4JQMJQ2nlPb2cBrOYgi3F
         M9wj8YpCjjNYrz30xKtIo2BMDlSMk0G0+xXJ4GHsxXqZTGEaU9BA3O3l60zTQzkRNqE+
         IOtIHMQPf4YT1mG07UHN4Leib3t9ZV0ymWDnScPXVhPJC6/tucoplnir6jAYkE5z9fFe
         y9QevvcoIh071kMl4eHZMaKFBixGqB4sgtIrGklNmy9/xvKCNbj/CMlKys3CVLUvImny
         7d6lKIjnQ2n/ENe/v5GATn+8frC+A3WhYCLs32kk+47DkXaaKLdr+LxIRy1/9G7RWZTg
         OzvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=qU/ZIM2Mcm2RW8IgIxFK50F6kojUkSG/GFHPDhmdkds=;
        fh=GCrkfgf+DI9LMQ7UK/WuXUuypspnN36BXEUJbNUhNQ8=;
        b=hPhpO2DSkLkV4rbKQH6Ah34VG6r/KnUZCHWSSdacabd+IKMtk7BVV29NT1ZaXfgF21
         iHq1PBOrYZzkfWtu9ISV0aX+ZBMgOV8ptiWsmH8CNRYcI1YaaOpYYq80G/5bqlAWrYgz
         oFCrLzG84ojSlkz375Q9mv976G4Gi/nTazViYaglrQyU6yHEelAg8I2h7fdxbwK5qbCd
         TCKsywdbOF9nokBwwEfn/fq6eYsR/OZRdOyF5LHGerH890rVrd3OJq0ZM/F1oWMGgeQ4
         JWLQUo1fl989MSxBf3WyjV3alv6sHIS3n/AMj7t+jFSoB94AHf37T+s2JWSPcrhyiLZQ
         73Bg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774585960; x=1775190760; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qU/ZIM2Mcm2RW8IgIxFK50F6kojUkSG/GFHPDhmdkds=;
        b=IV9g2VySjXCyAiD+lvMYM4I4X42ajgEuhZW3K3zawb+sf6Zl2n12u26CkldY5MXP7q
         ttbVJqgSJAnYY+m350Q3lS050fjpBxU3X8w/o9a6w+ZTMbO6iG6CCi1CcZT5uioz0iyG
         q//KuVC13uN1GzF6xFvVUcCKMFSeHDvTzUZP2TyWwmp4cWhpyHLCcuwkPr+0gD0Tr6jz
         tbK6lWRDDmIq9Tf4fIAD9vG+yBpDaf0T5ob/7hs8XSpkfr6i89tBmIgXSPFBs8fc7Ad6
         3ovn6j5ObgLxheFFxDFP1ETFsJynk2OSAEirExyrts9K5ehai3YErPWoyHtxOabdEeSo
         eotQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774585960; x=1775190760;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=qU/ZIM2Mcm2RW8IgIxFK50F6kojUkSG/GFHPDhmdkds=;
        b=d7ZnU4mvCbyYjvSAR4VA/ur4e3EQbAtfLTnjzJb3804l62r7Dwux/5OgnfikAwD+sY
         9LMwfyGv2Oma+frXezfgyOYal+Slj8v5anQLrCf4BcV9e9KU9WZ98b4mTvHksILf8q1c
         qyMXVuqwgQtNTZ+lAQbD6SAsnT9qhYZUVNkdypV5mMT34JIuMEin4yBmYabJe1pcoloN
         9dQ/foalkZQND3FpHylSN0BjR5LNiLVnXNsMOq8qwGPHBxuC0SaRPL64so6eTRCQrliu
         NvCVZlCJJoI/nBG7QDjrxYU222a1KBqEhhVb5J9ApQx1Kia7jGV9Yb6fGKJtITjWDtV0
         WnyQ==
X-Forwarded-Encrypted: i=1; AJvYcCXhE9M2jjrdZoBwvMEfJlPTSqG1fZZqCzvHiVAZVTTM9PQF+dwMpotui758dorYskkrAMLCqeDHUA==@kvack.org
X-Gm-Message-State: AOJu0YxtpXdcQ6xvPaNXGLWCIMAmAG/MbQa1qqUTOMxHLSH1NuE60Q1Q
	n+oXKieDW4+lzRTV1Jb2D29ykwNVRY0/TU+XKYBR+Zs9aWT6iAVc6jCTwGTzH7lT+rD+X8NQ9b0
	t4U0whttubQBuuuwFA4yS2R/Xm9j1XOx/lWV5FpvMbLtvAuLhdXA6uyYY27Y=
X-Gm-Gg: ATEYQzxk+2z7GdlRceigBG6Kq2sIBCMdRKJVX2bHKnrWqWshSNiKOM4t1ef/cqr0F8P
	DsnIXqwiPDMxs4d5yCI5jfOfIQTAWzdYfXe4Pui/3/FhwwU3g+bLfmYH942b2J3a64PZzOVZsMr
	jQN/vPwxhajlvhDUuVuPKyatGi/3TlExnE91vL3VQFfAUvB7Q9W/aL9VaQKdQyEyXHU6Is+A/d2
	B21cCQyryHYLRVMGiv9k0TKAz9J8aHZPEVokuiY1cRj7SdE6tnByY788230UTZ5MnjYAz4VKd+J
	5QkQgSXPHMTA2AC9
X-Received: by 2002:a05:622a:2515:b0:506:a3c8:d44d with SMTP id
 d75a77b69052e-50ba3256304mr6475901cf.9.1774585959800; Thu, 26 Mar 2026
 21:32:39 -0700 (PDT)
MIME-Version: 1.0
References: <20260326140554.191996-1-hao.ge@linux.dev>
In-Reply-To: <20260326140554.191996-1-hao.ge@linux.dev>
From: Suren Baghdasaryan <surenb@google.com>
Date: Thu, 26 Mar 2026 21:32:28 -0700
X-Gm-Features: AQROBzA1vsUvCsoI3s1CkGqRVqIvl7oTA503yMiQ7jFmr7VyGsXeK8faAaUveSQ
Message-ID: <CAJuCfpG3w0-m_BAhvRj0Mo2cCeWmD3UaEMa=gd=tvT7hrL=mqA@mail.gmail.com>
Subject: Re: [PATCH v2] mm/alloc_tag: clear codetag for pages allocated before
 page_ext initialization
To: Hao Ge <hao.ge@linux.dev>
Cc: Kent Overstreet <kent.overstreet@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 5BC6E40006
X-Stat-Signature: h45g1wgiw3it3n5tjksbrbu3kykt5k8z
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1774585961-152129
X-HE-Meta: U2FsdGVkX1//WoOSzIdYbD+82UVsHg6WXHL7RDl8apJuMP9TU+l0Flv9fSRL6QOPHQd3FYj1AC4G/diAQ0GB13fsXwk7S4MivUP0j0B0kDmOwUARTAwT/dD9aaUcITwDMIU1RyTzsoFHeKiGBAX9EEkgPWo00/yb/ioyww/d4ucExJOJw0C8UJra2CdSeejE/zy5yfvzI2/C3M8UmQJiGI3mDIt0BRVJKDXprhvPN6Aw4jPu62pmV5TLKUWV5qwlADBIJdN3HDPHnNo9dZ72oIoow6HRGRvJIwm35FqRhuyXDXZDr0CiHAFde0Gisa/WWXtE9tkDd3qtRlAsnHgNUJLKCcoJJGjKQFQNeHAkjN9/A88LSiKQKTPfzoy3TlJeDDl9v9hP24fVzf96Vz7MLO4Be7VOgyo2IGHoMkA2JJ6hjECbWYN1qVGvZRSgsX3S4ZduF0xFf0MbyAAc9x4XJjPM8U6NElWYyOR70JvKHON3gaKD6hToxZYWZ9C1aPC7/EJ8F4zaSbX86hjIf4TNNz7T8hHpnf+TTgWZJ24xbkspaB6LfqQy5Jtzx4uJG67v74xRoo9iWkmBZWTMUEuDTg01rDlP4og33omHLn4Lxs4katOqesn1Yj9WIL9p1zYuxxEwC91IYrrDFiZMysr6rDvO4XLFwTgJmLnNnmeQoxA3/zdOUkp1CVNXlxFSY6B9LKl1FbGoldJFXerAcx89hzUpd3VNQLBakDbSo12gwTvX+G0c0oWLq85jJlW3NQxAsXF+PzxdjRyyjvBuKWuKNmtrNY3rwBnrsr2R5EA42wQOxk/pRGZ/QNdbCcbp6C5ulfuVmEJtXfZVe1/ogYsPxth9WJHX6/WbEujilKYVMHdjuRbv9EPh9FIpm/A7mMddGhGlLNDdd6pwDQqWeeWZxCB6g83mZaPC5TEuIQd/jiq8/8Qs3S691iFHHOmYjWlVmg8tbvHwXl3t59rubRQ
 a9d0nAOE
 /Zri+jq7Qydt6UMfpqrgaOX8VmRWI+x1pjrkzPHckYnjwudBVHRpbQkkZppORjktUaXzQe6Ntm+VnkeFvsSfHeSel0AH2bZ0X//kEz/AsNcJ7hxxrpMCoEpsKBDYty9Ztteu8nGZhmEUDHKnt7C4Bd4QqugqLRZyiW7dBveyxRBAk2km/jyL/n2kxymPyiyS99Q2dMd5Jxi7AicWxwwAw6zUTTfrtZT+mO4yiLbkP4dwPnUCfln9YfrH4Iib4zJn1kmyAQjuIpmZzM+sLpEyLXl1Yfo6C7RGYsekIW1XDSN+acfsDrrEm4IJ4C3HSXf7K7fWuj45dHzHaGx4j2VrRlpE3KkeHN/T6R5ooSGugSB3IVWw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 26, 2026 at 7:07=E2=80=AFAM Hao Ge <hao.ge@linux.dev> wrote:
>
> Due to initialization ordering, page_ext is allocated and initialized
> relatively late during boot. Some pages have already been allocated
> and freed before page_ext becomes available, leaving their codetag
> uninitialized.
>
> A clear example is in init_section_page_ext(): alloc_page_ext() calls
> kmemleak_alloc(). If the slab cache has no free objects, it falls back
> to the buddy allocator to allocate memory. However, at this point page_ex=
t
> is not yet fully initialized, so these newly allocated pages have no
> codetag set. These pages may later be reclaimed by KASAN, which causes
> the warning to trigger when they are freed because their codetag ref is
> still empty.
>
> Use a global array to track pages allocated before page_ext is fully
> initialized. The array size is fixed at 8192 entries, and will emit
> a warning if this limit is exceeded. When page_ext initialization
> completes, set their codetag to empty to avoid warnings when they
> are freed later.
>
> The following warning is observed when this issue occurs:
> [    9.582133] ------------[ cut here ]------------
> [    9.582137] alloc_tag was not set
> [    9.582139] WARNING: ./include/linux/alloc_tag.h:164 at __pgalloc_tag_=
sub+0x40f/0x550, CPU#5: systemd/1
> [    9.582190] CPU: 5 UID: 0 PID: 1 Comm: systemd Not tainted 7.0.0-rc4 #=
1 PREEMPT(lazy)
> [    9.582192] Hardware name: Red Hat KVM, BIOS rel-1.16.3-0-ga6ed6b701f0=
a-prebuilt.qemu.org 04/01/2014
> [    9.582194] RIP: 0010:__pgalloc_tag_sub+0x40f/0x550
> [    9.582196] Code: 00 00 4c 29 e5 48 8b 05 1f 88 56 05 48 8d 4c ad 00 4=
8 8d 2c c8 e9 87 fd ff ff 0f 0b 0f 0b e9 f3 fe ff ff 48 8d 3d 61 2f ed 03 <=
67> 48 0f b9 3a e9 b3 fd ff ff 0f 0b eb e4 e8 5e cd 14 02 4c 89 c7
> [    9.582197] RSP: 0018:ffffc9000001f940 EFLAGS: 00010246
> [    9.582200] RAX: dffffc0000000000 RBX: 1ffff92000003f2b RCX: 1ffff1102=
00d806c
> [    9.582201] RDX: ffff8881006c0360 RSI: 0000000000000004 RDI: ffffffff9=
bc7b460
> [    9.582202] RBP: 0000000000000000 R08: 0000000000000000 R09: fffffbfff=
3a62324
> [    9.582203] R10: ffffffff9d311923 R11: 0000000000000000 R12: ffffea000=
4001b00
> [    9.582204] R13: 0000000000002000 R14: ffffea0000000000 R15: ffff88810=
06c0360
> [    9.582206] FS:  00007ffbbcf2d940(0000) GS:ffff888450479000(0000) knlG=
S:0000000000000000
> [    9.582208] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [    9.582210] CR2: 000055ee3aa260d0 CR3: 0000000148b67005 CR4: 000000000=
0770ef0
> [    9.582211] PKRU: 55555554
> [    9.582212] Call Trace:
> [    9.582213]  <TASK>
> [    9.582214]  ? __pfx___pgalloc_tag_sub+0x10/0x10
> [    9.582216]  ? check_bytes_and_report+0x68/0x140
> [    9.582219]  __free_frozen_pages+0x2e4/0x1150
> [    9.582221]  ? __free_slab+0xc2/0x2b0
> [    9.582224]  qlist_free_all+0x4c/0xf0
> [    9.582227]  kasan_quarantine_reduce+0x15d/0x180
> [    9.582229]  __kasan_slab_alloc+0x69/0x90
> [    9.582232]  kmem_cache_alloc_noprof+0x14a/0x500
> [    9.582234]  do_getname+0x96/0x310
> [    9.582237]  do_readlinkat+0x91/0x2f0
> [    9.582239]  ? __pfx_do_readlinkat+0x10/0x10
> [    9.582240]  ? get_random_bytes_user+0x1df/0x2c0
> [    9.582244]  __x64_sys_readlinkat+0x96/0x100
> [    9.582246]  do_syscall_64+0xce/0x650
> [    9.582250]  ? __x64_sys_getrandom+0x13a/0x1e0
> [    9.582252]  ? __pfx___x64_sys_getrandom+0x10/0x10
> [    9.582254]  ? do_syscall_64+0x114/0x650
> [    9.582255]  ? ksys_read+0xfc/0x1d0
> [    9.582258]  ? __pfx_ksys_read+0x10/0x10
> [    9.582260]  ? do_syscall_64+0x114/0x650
> [    9.582262]  ? do_syscall_64+0x114/0x650
> [    9.582264]  ? __pfx_fput_close_sync+0x10/0x10
> [    9.582266]  ? file_close_fd_locked+0x178/0x2a0
> [    9.582268]  ? __x64_sys_faccessat2+0x96/0x100
> [    9.582269]  ? __x64_sys_close+0x7d/0xd0
> [    9.582271]  ? do_syscall_64+0x114/0x650
> [    9.582273]  ? do_syscall_64+0x114/0x650
> [    9.582275]  ? clear_bhb_loop+0x50/0xa0
> [    9.582277]  ? clear_bhb_loop+0x50/0xa0
> [    9.582279]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
> [    9.582280] RIP: 0033:0x7ffbbda345ee
> [    9.582282] Code: 0f 1f 40 00 48 8b 15 29 38 0d 00 f7 d8 64 89 02 48 c=
7 c0 ff ff ff ff c3 0f 1f 40 00 f3 0f 1e fa 49 89 ca b8 0b 01 00 00 0f 05 <=
48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d fa 37 0d 00 f7 d8 64 89 01 48
> [    9.582284] RSP: 002b:00007ffe2ad8de58 EFLAGS: 00000202 ORIG_RAX: 0000=
00000000010b
> [    9.582286] RAX: ffffffffffffffda RBX: 000055ee3aa25570 RCX: 00007ffbb=
da345ee
> [    9.582287] RDX: 000055ee3aa25570 RSI: 00007ffe2ad8dee0 RDI: 00000000f=
fffff9c
> [    9.582288] RBP: 0000000000001000 R08: 0000000000000003 R09: 000000000=
0001001
> [    9.582289] R10: 0000000000001000 R11: 0000000000000202 R12: 000000000=
0000033
> [    9.582290] R13: 00007ffe2ad8dee0 R14: 00000000ffffff9c R15: 00007ffe2=
ad8deb0
> [    9.582292]  </TASK>
> [    9.582293] ---[ end trace 0000000000000000 ]---
>
> Fixes: 93d5440ece3c ("alloc_tag: uninline code gated by mem_alloc_profili=
ng_key in page allocator")
> Suggested-by: Suren Baghdasaryan <surenb@google.com>
> Signed-off-by: Hao Ge <hao.ge@linux.dev>
> ---
> v2:
>   - Replace spin_lock_irqsave() with atomic_try_cmpxchg() to avoid potent=
ial
>      deadlock in NMI context
>   - Change EARLY_ALLOC_PFN_MAX from 256 to 8192
>   - Add pr_warn_once() when the limit is exceeded
>   - Check ref.ct before clearing to avoid overwriting valid tags
>   - Use function pointer (alloc_tag_add_early_pfn_ptr) instead of state
> ---
>  include/linux/alloc_tag.h   |  2 +
>  include/linux/pgalloc_tag.h |  2 +-
>  lib/alloc_tag.c             | 92 +++++++++++++++++++++++++++++++++++++
>  mm/page_alloc.c             |  7 +++
>  4 files changed, 102 insertions(+), 1 deletion(-)
>
> diff --git a/include/linux/alloc_tag.h b/include/linux/alloc_tag.h
> index d40ac39bfbe8..bf226c2be2ad 100644
> --- a/include/linux/alloc_tag.h
> +++ b/include/linux/alloc_tag.h
> @@ -74,6 +74,8 @@ static inline void set_codetag_empty(union codetag_ref =
*ref)
>
>  #ifdef CONFIG_MEM_ALLOC_PROFILING
>
> +void alloc_tag_add_early_pfn(unsigned long pfn);

Although this works, the usual approach is have it defined this way in
the header file:

#if CONFIG_MEM_ALLOC_PROFILING_DEBUG
void alloc_tag_add_early_pfn(unsigned long pfn);
#else
static inline void alloc_tag_add_early_pfn(unsigned long pfn) {}
#endif

> +
>  #define ALLOC_TAG_SECTION_NAME "alloc_tags"
>
>  struct codetag_bytes {
> diff --git a/include/linux/pgalloc_tag.h b/include/linux/pgalloc_tag.h
> index 38a82d65e58e..951d33362268 100644
> --- a/include/linux/pgalloc_tag.h
> +++ b/include/linux/pgalloc_tag.h
> @@ -181,7 +181,7 @@ static inline struct alloc_tag *__pgalloc_tag_get(str=
uct page *page)
>
>         if (get_page_tag_ref(page, &ref, &handle)) {
>                 alloc_tag_sub_check(&ref);
> -               if (ref.ct)
> +               if (ref.ct && !is_codetag_empty(&ref))
>                         tag =3D ct_to_alloc_tag(ref.ct);
>                 put_page_tag_ref(handle);
>         }
> diff --git a/lib/alloc_tag.c b/lib/alloc_tag.c
> index 58991ab09d84..7b1812768af9 100644
> --- a/lib/alloc_tag.c
> +++ b/lib/alloc_tag.c
> @@ -6,6 +6,7 @@
>  #include <linux/kallsyms.h>
>  #include <linux/module.h>
>  #include <linux/page_ext.h>
> +#include <linux/pgalloc_tag.h>
>  #include <linux/proc_fs.h>
>  #include <linux/seq_buf.h>
>  #include <linux/seq_file.h>
> @@ -26,6 +27,96 @@ static bool mem_profiling_support;
>
>  static struct codetag_type *alloc_tag_cttype;
>
> +#ifdef CONFIG_MEM_ALLOC_PROFILING_DEBUG
> +
> +/*
> + * Track page allocations before page_ext is initialized.
> + * Some pages are allocated before page_ext becomes available, leaving
> + * their codetag uninitialized. Track these early PFNs so we can clear
> + * their codetag refs later to avoid warnings when they are freed.
> + *
> + * Early allocations include:
> + *   - Base allocations independent of CPU count
> + *   - Per-CPU allocations (e.g., CPU hotplug callbacks during smp_init,
> + *     such as trace ring buffers, scheduler per-cpu data)
> + *
> + * For simplicity, we fix the size to 8192.
> + * If insufficient, a warning will be triggered to alert the user.
> + */
> +#define EARLY_ALLOC_PFN_MAX            8192
> +
> +static unsigned long early_pfns[EARLY_ALLOC_PFN_MAX] __initdata;
> +static atomic_t early_pfn_count __initdata =3D ATOMIC_INIT(0);
> +
> +static void __init __alloc_tag_add_early_pfn(unsigned long pfn)
> +{
> +       int old_idx, new_idx;
> +
> +       do {
> +               old_idx =3D atomic_read(&early_pfn_count);
> +               if (old_idx >=3D EARLY_ALLOC_PFN_MAX) {
> +                       pr_warn_once("Early page allocations before page_=
ext init exceeded EARLY_ALLOC_PFN_MAX (%d)\n",
> +                                     EARLY_ALLOC_PFN_MAX);
> +                       return;
> +               }
> +               new_idx =3D old_idx + 1;
> +       } while (!atomic_try_cmpxchg(&early_pfn_count, &old_idx, new_idx)=
);
> +
> +       early_pfns[old_idx] =3D pfn;
> +}
> +
> +static void (*alloc_tag_add_early_pfn_ptr)(unsigned long pfn) __refdata =
=3D
> +               __alloc_tag_add_early_pfn;

So, there is a possible race between clear_early_alloc_pfn_tag_refs()
and __alloc_tag_add_early_pfn(). I think the easiest way to resolve
this is using RCU. It's easier to show that with the code:

typedef void (*alloc_tag_add_func)(unsigned long pfn);

static alloc_tag_add_func __rcu alloc_tag_add_early_pfn_ptr __refdata =3D
                __alloc_tag_add_early_pfn;

void alloc_tag_add_early_pfn(unsigned long pfn)
{
        alloc_tag_add_func alloc_tag_add;

        if (static_key_enabled(&mem_profiling_compressed))
                return;

        rcu_read_lock();
        alloc_tag_add =3D rcu_dereference(alloc_tag_add_early_pfn_ptr);
        if (alloc_tag_add)
                alloc_tag_add(pfn);
        rcu_read_unlock();
}

static void __init clear_early_alloc_pfn_tag_refs(void)
{
        unsigned int i;

        if (static_key_enabled(&mem_profiling_compressed))
                return;

       rcu_assign_pointer(alloc_tag_add_early_pfn_ptr, NULL);
        /* Make sure we are not racing with __alloc_tag_add_early_pfn() */
        synchronize_rcu();
        ...
}

So, clear_early_alloc_pfn_tag_refs() resets
alloc_tag_add_early_pfn_ptr to NULL before starting its loop and
alloc_tag_add_early_pfn() calls __alloc_tag_add_early_pfn() in RCU
read section. This way you know that after synchronize_rcu() nobody is
or will be executing __alloc_tag_add_early_pfn() anymore.
synchronize_rcu() can increase boot time but this happens only with
CONFIG_MEM_ALLOC_PROFILING_DEBUG, so should be acceptable.

> +
> +void alloc_tag_add_early_pfn(unsigned long pfn)
> +{
> +       if (static_key_enabled(&mem_profiling_compressed))
> +               return;
> +
> +       if (alloc_tag_add_early_pfn_ptr)
> +               alloc_tag_add_early_pfn_ptr(pfn);
> +}
> +
> +static void __init clear_early_alloc_pfn_tag_refs(void)
> +{
> +       unsigned int i;
> +

I included this in the code I suggested above but just as a reminder,
here we also need:

      if (static_key_enabled(&mem_profiling_compressed))
               return;

> +       for (i =3D 0; i < atomic_read(&early_pfn_count); i++) {
> +               unsigned long pfn =3D early_pfns[i];
> +
> +               if (pfn_valid(pfn)) {
> +                       struct page *page =3D pfn_to_page(pfn);
> +                       union pgtag_ref_handle handle;
> +                       union codetag_ref ref;
> +
> +                       if (get_page_tag_ref(page, &ref, &handle)) {
> +                               /*
> +                                * An early-allocated page could be freed=
 and reallocated
> +                                * after its page_ext is initialized but =
before we clear it.
> +                                * In that case, it already has a valid t=
ag set.
> +                                * We should not overwrite that valid tag=
 with CODETAG_EMPTY.
> +                                */

You don't really solve this race here. See explanation below.

> +                               if (ref.ct) {
> +                                       put_page_tag_ref(handle);
> +                                       continue;
> +                               }
> +

Between the above "if (ref.ct)" check and below set_codetag_empty() an
allocation can change the ref.ct value to a valid reference (because
page_ext already exists) and you will override it with CODETAG_EMPTY.
I think we have two options:
1. Just let that override happen and lose accounting for that racing
allocation. I think that's preferred option since the race is not
likely and extra complexity is not worth it IMO.
2.  Do clear_page_tag_ref() here but atomically. Something like
clear_page_tag_ref_if_null() calling update_page_tag_ref_if_null()
which calls cmpxchg(&ref->ct, NULL, CODETAG_EMPTY).

If you agree with option #1 then please update the comment above
highlighting this smaller race and that we are ok with it.

> +                               set_codetag_empty(&ref);
> +                               update_page_tag_ref(handle, &ref);
> +                               put_page_tag_ref(handle);
> +                       }
> +               }
> +
> +       }
> +
> +       atomic_set(&early_pfn_count, 0);
> +       alloc_tag_add_early_pfn_ptr =3D NULL;

Once we did that RCU synchronization we don't need the above resets.
early_pfn_count won't be used anymore and alloc_tag_add_early_pfn_ptr
is already NULL.

> +}
> +#else /* !CONFIG_MEM_ALLOC_PROFILING_DEBUG */
> +inline void alloc_tag_add_early_pfn(unsigned long pfn) {}
> +static inline void __init clear_early_alloc_pfn_tag_refs(void) {}
> +#endif
> +
>  #ifdef CONFIG_ARCH_MODULE_NEEDS_WEAK_PER_CPU
>  DEFINE_PER_CPU(struct alloc_tag_counters, _shared_alloc_tag);
>  EXPORT_SYMBOL(_shared_alloc_tag);
> @@ -760,6 +851,7 @@ static __init bool need_page_alloc_tagging(void)
>
>  static __init void init_page_alloc_tagging(void)
>  {
> +       clear_early_alloc_pfn_tag_refs();
>  }
>
>  struct page_ext_operations page_alloc_tagging_ops =3D {
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 2d4b6f1a554e..8f9bda04403b 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -1293,6 +1293,13 @@ void __pgalloc_tag_add(struct page *page, struct t=
ask_struct *task,

In here let's mark the normal branch as "likely":
-        if (get_page_tag_ref(page, &ref, &handle)) {
+        if (likely(get_page_tag_ref(page, &ref, &handle))) {

>                 alloc_tag_add(&ref, task->alloc_tag, PAGE_SIZE * nr);
>                 update_page_tag_ref(handle, &ref);
>                 put_page_tag_ref(handle);
> +       } else {
> +               /*
> +                * page_ext is not available yet, record the pfn so we ca=
n
> +                * clear the tag ref later when page_ext is initialized.
> +                */
> +               alloc_tag_add_early_pfn(page_to_pfn(page));
> +               alloc_tag_set_inaccurate(current->alloc_tag);

Here we should be using task->alloc_tag instead of current->alloc_tag
but we also need to check that task->alloc_tag !=3D NULL.

>         }
>  }
>
> --
> 2.25.1
>

