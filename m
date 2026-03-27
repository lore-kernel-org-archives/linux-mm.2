Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 49F8A10ED67F
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 15:11:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 68C316B0092; Fri, 27 Mar 2026 11:11:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 63C4A6B0095; Fri, 27 Mar 2026 11:11:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 551E96B0099; Fri, 27 Mar 2026 11:11:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 3F5846B0092
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 11:11:07 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 113E9140B1F
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 15:11:06 +0000 (UTC)
X-FDA: 84592180932.28.E283527
Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	by imf03.hostedemail.com (Postfix) with ESMTP id E41D720011
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 15:11:03 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Jrzj+pDv;
	spf=pass (imf03.hostedemail.com: domain of surenb@google.com designates 209.85.160.181 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774624263;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4HufnsF4tQXyTCniPgazYw8KW9RO9W3Fs7XYp80k6f0=;
	b=F/Po3LsMcq9QfJeZN/ExJJn6qe1XsLnkaiURXg6ydo9y+tVpbQVjk9HkBPP5qU1ELlt1YG
	sbQ/646hOvgW2DH5L/6heGXQkFUuewYNgkBOrrZqvLOsR7g9fVvyPRpbyg3rlVg3Czb3Pb
	KyNsFGfPaNxITUte4zAwT9aDVE4KGDQ=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Jrzj+pDv;
	spf=pass (imf03.hostedemail.com: domain of surenb@google.com designates 209.85.160.181 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774624263; a=rsa-sha256;
	cv=pass;
	b=M/7zUlFVAUfPGSC3CrYrXnkW8FPxi+akZHBjREPuTo5uPqnVKxg7oUEWi6yTcc7R0bi19D
	bJuF152tORCMIH5yHPYVvQfpq7oEwurq3SBkQmtI/sUHImulNsN0oJOnd8N5S+V+k3/OBO
	E275+vYYb95KEY609tjRskhdnoya8BA=
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-50b6c45781aso644471cf.0
        for <linux-mm@kvack.org>; Fri, 27 Mar 2026 08:11:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774624258; cv=none;
        d=google.com; s=arc-20240605;
        b=iuDL6Z6iHH3UtDk4R6Qs8t4hzu9u4FKXge6ML1R8+2IR1Ugt16bsHuX91TDfyKMqVi
         hvG2DYeja+ewGuyEnk+vuXupdtZdMvlRFn1ye2k1iibkvPDWA88jSgvr4BV6Mt2ZGJRL
         mLNZu1QNPBxpwifsoNjK+yTrR4eKimqGza2hvxYJXl+3Cp0qkCW7gm5pT/2HC1YT99CC
         HFp8kBfnF+17DPA7GkV9OewVHowmgOuDGBVhNeLr0iRveEfNVfbXjfur/TvW+54IF1y3
         1dYIxpVpQG9IKIkAm5WKDWcyNDRnS4qU+h79ert/QwCBcn/31blQRFpTef9hbShlxDgR
         KsYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=4HufnsF4tQXyTCniPgazYw8KW9RO9W3Fs7XYp80k6f0=;
        fh=FO59Zexa5A0P89feclDGrJJKvvz5UQnwMeOUg6TC/fk=;
        b=G5U3awRbxlFONpGx53GFRoYMDxhZUPt7+ScAg5H0IcMrWHa4AAjK306vwVBT4aY9Wi
         wdmGC/s+wLzxjo1gyebXlOS60bP3Jf0pqv7PVcK+YowhE/7+1uR9a18ILXnaWMeV19Mc
         yZROH8BnUZ53bC2V4XCnOwarYxsCzg9QHiYlvAqCTcexbCuM5tDdGMcb0I/v1EDnZyz6
         loR2AN7FvuSzeyWiOS2tR/y4U3y4BiF8z6RF1hf1YFXvb3B70ac5s+rusif+mgydPUAo
         xB4hvNnATBIrYO5Q0vz6HyaOrzlx4ohiWQoCWfjsE7/caixSoSIKkJgnn9eBH8IcXx32
         AcWQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774624258; x=1775229058; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4HufnsF4tQXyTCniPgazYw8KW9RO9W3Fs7XYp80k6f0=;
        b=Jrzj+pDvsXN/AQWwDOgSHKFHV9epWk1TfhKlPtcrUYMNZbqvmdA/H1RP8ks+LlESTJ
         ju+JHvVNYPz4ujgUL6ohhud4NrXWMOxGVBikm874/Df/pbgdQ8eCPc9jrpqE3srQTpGk
         JH90rSWlcoOB8B/u6FwC29AZpnlKBdHb03gh4GBHHh8Pj/cuhGdVSgvPVcftFwNFvWZ3
         uv/z1tjAyGosKkw7zbjeTbp1Fnzc86Co6FDwEkte+YoqgwWeZtR5jyUV7r2WBVEMj9EJ
         wI7Jwm56plHrmG5Foq7UnaujaMqqO9bA/zW2eERROS/TwIihCVNJhYQ7DffzXwSHjQAZ
         Jd+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774624258; x=1775229058;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=4HufnsF4tQXyTCniPgazYw8KW9RO9W3Fs7XYp80k6f0=;
        b=XRMW0WMaNnEx19qC9hjW7NA+32dbpc9MUhRTtnrk4+z1kQ75fvTJZxJjQoh0ykL6wR
         0LOdcbLvdztlH19jP8mJVmb8XzLnva40SoTll/HQFEI+R7NlnVwcdEO94QXsBJHxD/O3
         PGGEk9qWEAT0JeM/9XI2WJpuEGdFMV1Sf/VwsAiH2WfH9r/gEBpQShV/x2R/drfRtpR8
         1ejBXX+KCNPOW+f7VHP+YJ95NmDctFfaM4kS8Nt7YavdcD8efAQv24JoMTYkzTp8pLtm
         hT20KGo/h5YeLZYNgRN++R97k5AZiGHdUXKP/UbCDpgYTlCwDxD4x2yP6sQr0D7vLAzz
         uIpw==
X-Forwarded-Encrypted: i=1; AJvYcCXs3RGHufDE2SJK8q7LilWUQZEGyuxWa7c5c+4w4MifLFR4k2U8cat0nWLkOwCqlo7jFTZS3015jg==@kvack.org
X-Gm-Message-State: AOJu0YzsTqSCDltubEu20j+27dFqJxtoXjwLyYwn5Cy016vAq52n2WHs
	uuLHILV8onbQB7yeVaZRa37Vltj3yVjffCjQjkDU+QqaJ4qUlVoCqsYkJigyuw/c52LZ7IGEeXu
	cRLpcP3I4jU1/93f7FlcZlKa+kC1zibrbW42jXKni
X-Gm-Gg: ATEYQzw0+bmlUp1R6OH6n1yQ2l1GaMK0ce9DgE74UKyG/esj3GIM5rrxiVa7ZO0AhRg
	PxTi+oWJV4rhybmcIYP8z37HAWYVQGJf/wiM/A2TpWq4lIBVZcdeaV7JwQfyhMR9baDvSngeD01
	hwjT9ssMboMM+MY5aEu2jwbuV1E8UAFT3BouK43G6OpL1xCH+JQ5BVaagmpAwL7Enl2EIjuHc1m
	OxfubUgELjf1JLZg4Q2zRAcsPxDY0/aQpQvf9qqiFPg9KzmG3Y233TPNTojZKujydKFuI797AKV
	iwNieFTR6qpE8cZ7
X-Received: by 2002:a05:622a:40ce:b0:509:14f0:bff2 with SMTP id
 d75a77b69052e-50ba1cc4a1cmr17305191cf.12.1774624257101; Fri, 27 Mar 2026
 08:10:57 -0700 (PDT)
MIME-Version: 1.0
References: <20260327080623.123212-1-hao.ge@linux.dev>
In-Reply-To: <20260327080623.123212-1-hao.ge@linux.dev>
From: Suren Baghdasaryan <surenb@google.com>
Date: Fri, 27 Mar 2026 08:10:44 -0700
X-Gm-Features: AQROBzDDjQx1iCldZDXdhdT8JbttmIeljoh0_3lKem-1ya8m3VrWUsiboGHL1OY
Message-ID: <CAJuCfpGF1Cww08OhwMFNhd1qHpZHWKFUBjFj6LQFM25VZuH-DA@mail.gmail.com>
Subject: Re: [PATCH] mm/alloc_tag: clear codetag for pages allocated before
 page_ext initialization
To: Hao Ge <hao.ge@linux.dev>
Cc: Kent Overstreet <kent.overstreet@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: E41D720011
X-Stat-Signature: qbrdbt7q4c33ys5ckm9m7ddmes3n7ssr
X-Rspamd-Server: rspam06
X-HE-Tag: 1774624263-90444
X-HE-Meta: U2FsdGVkX19SLGeLPKAe2USpzyuIKWajcF1x3scvkId/Ji8xPkA/my4jLT+er5p6N/EeuHHYS1C4qPTxq6Nq17VLfiCrDvW78Bmc03NYWEG8G6ZBiqKaLD+opuAFK5VaBYxuoJYD8qnaSFHm5acglV0rObktPfu3bwm+Wp6cjrEcymKBGBVdLXOoJV0GkhDXys0Uc8pI0PSUi2knH9qnRlYiN46yVGWPirRQFnT6U5y8IJcH9nj6u6v0JXXOtOqC/+LO6JUcAoq+WKmrl9CR63CSgXqpFEzKlHuM2LbtKqRTmGHD5p/EIvopSdYg6QzqNoGIHqw0+xT160OPI53jYdudSLBWOwiBoXQve6+R83jAvmY/qH84RGBaV9AClK22tiyfe1JQeB3+LM2xcLLupQXFxbAm8FCH0RLUveIMbF31EVB5fT7jYK3sFy5i3+uZKK5eQIY+QFQ+pRC6QJurRNg8XXIbMB1afJjZIiyVpEW79rHVX9d+5csAfwEv04Bxs7Npv8uvfBZPgh90TXUZlv2Ndf16ex3jcITDSxy7uI/R5S0uxgpsTeBKUNk5J4eQp1846Aas8JN4S5b9YpObGzAeQ/mCJrpEYopl6mW0lVpcJ+39x12znEQ1fGod77laA32SS7VAVhui3XR8y76Ia/WfK5VwbAcgTSwKJ06XQ0K359wSqbPz3melxHNOuCf+oDbB/oFGpe8eyS+YCS9Xcdn1hFBD9hUHkqzhgfErheh7lT2lFNIXRnnHaB0HRvr7/QckHrtlJMBneA/tjL6Xjx/l2KPk1UgE2gl7Wce7TV/tBaaHqprXAhHHtWDDGTExVUfMs5Pf8XogYwNcc/VEeAwadft0fOUEFSW388SjFj/jr2fNU7LIcbawhYP87NfFRO+4mNJVafdGfMmmKJ7H+6aJ2ZJN+WSZpe9GdFbs+MiLCG4FZrTAijNYVjTIDWKBH+aKDPibHeSCD7fid2r
 zwSIGcsH
 7zfb2F1Ctq7YlmNJJIJpD7VIZpfHC4GkI/AWV7tTCUQUbm5Xu+jzFt2nd+wYdjr7+tJERxbv9ihdAmKyY9c0/x1AzdTK1MUK7xoPnpwwut94hC0ZrNPS27XIUmOkAr3uLzNKwzJAE9R5SUyQ9HGJTn7ohWI3U9uEDQatKRxDr8OOqa23nIlrGkQYVxm+RqgHVUkm7b+G6ylSUbJJyOVNFTdM4RU/N5GhbkIgtNgaT/L9NxQmUD16OaToW0euNyEVUeVT8L9dSxfYI8g/eGS33YRHjxA3r8LqsoqMG4HoF8VyFed+3u5DZidCKhGPsd8cCTShgSpQT1MyxCLyaWMXV7xinGmMtXnYIOtznThiKDz5/k+ac7Mi+NXbjQBi4bw0IB5gX
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 27, 2026 at 1:07=E2=80=AFAM Hao Ge <hao.ge@linux.dev> wrote:
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
> This warning is only observed with CONFIG_MEM_ALLOC_PROFILING_DEBUG=3DY
> and mem_profiling_compressed disabled:
>
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
> Fixes: dcfe378c81f72 ("lib: introduce support for page allocation tagging=
")
> Cc: stable@vger.kernel.org
> Suggested-by: Suren Baghdasaryan <surenb@google.com>
> Signed-off-by: Hao Ge <hao.ge@linux.dev>

The title should indicate v3 but otherwise LGTM.

Acked-by: Suren Baghdasaryan <surenb@google.com>

> ---
> v3:
>   - Use RCU to protect alloc_tag_add_early_pfn_ptr and avoid race conditi=
ons
>     between alloc_tag_add_early_pfn() and clear_early_alloc_pfn_tag_refs(=
)
>   - Add static_key_enabled() check in clear_early_alloc_pfn_tag_refs()
>   - Use task->alloc_tag instead of current->alloc_tag
>   - Add NULL check for task->alloc_tag before calling alloc_tag_set_inacc=
urate()
>   - Add likely() hint for get_page_tag_ref() in the common path
>   - Update comments to explain the small race window between ref.ct check
>     and set_codetag_empty()
>   - Move all CONFIG_MEM_ALLOC_PROFILING_DEBUG code (variables and functio=
ns)
>     together near init_page_alloc_tagging() for better code organization
>   - Add TODO comment about replacing fixed-size array with dynamic alloca=
tion
>     using a GFP flag similar to ___GFP_NO_OBJ_EXT to avoid recursion
>   - Update function declaration in header file to use #if defined() style
>
> v2:
>   - Replace spin_lock_irqsave() with atomic_try_cmpxchg() to avoid potent=
ial
>      deadlock in NMI context
>   - Change EARLY_ALLOC_PFN_MAX from 256 to 8192
>   - Add pr_warn_once() when the limit is exceeded
>   - Check ref.ct before clearing to avoid overwriting valid tags
>   - Use function pointer (alloc_tag_add_early_pfn_ptr) instead of state
> ---
>  include/linux/alloc_tag.h   |   2 +
>  include/linux/pgalloc_tag.h |   2 +-
>  lib/alloc_tag.c             | 109 ++++++++++++++++++++++++++++++++++++
>  mm/page_alloc.c             |  10 +++-
>  4 files changed, 121 insertions(+), 2 deletions(-)
>
> diff --git a/include/linux/alloc_tag.h b/include/linux/alloc_tag.h
> index d40ac39bfbe8..02de2ede560f 100644
> --- a/include/linux/alloc_tag.h
> +++ b/include/linux/alloc_tag.h
> @@ -163,9 +163,11 @@ static inline void alloc_tag_sub_check(union codetag=
_ref *ref)
>  {
>         WARN_ONCE(ref && !ref->ct, "alloc_tag was not set\n");
>  }
> +void alloc_tag_add_early_pfn(unsigned long pfn);
>  #else
>  static inline void alloc_tag_add_check(union codetag_ref *ref, struct al=
loc_tag *tag) {}
>  static inline void alloc_tag_sub_check(union codetag_ref *ref) {}
> +static inline void alloc_tag_add_early_pfn(unsigned long pfn) {}
>  #endif
>
>  /* Caller should verify both ref and tag to be valid */
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
> index 58991ab09d84..04846f80e7c3 100644
> --- a/lib/alloc_tag.c
> +++ b/lib/alloc_tag.c
> @@ -6,7 +6,9 @@
>  #include <linux/kallsyms.h>
>  #include <linux/module.h>
>  #include <linux/page_ext.h>
> +#include <linux/pgalloc_tag.h>
>  #include <linux/proc_fs.h>
> +#include <linux/rcupdate.h>
>  #include <linux/seq_buf.h>
>  #include <linux/seq_file.h>
>  #include <linux/string_choices.h>
> @@ -758,8 +760,115 @@ static __init bool need_page_alloc_tagging(void)
>         return mem_profiling_support;
>  }
>
> +#ifdef CONFIG_MEM_ALLOC_PROFILING_DEBUG
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
> + *
> + * TODO: Replace fixed-size array with dynamic allocation using
> + * a GFP flag similar to ___GFP_NO_OBJ_EXT to avoid recursion.
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
> +typedef void (*alloc_tag_add_func)(unsigned long pfn);
> +static alloc_tag_add_func __rcu alloc_tag_add_early_pfn_ptr __refdata =
=3D
> +               __alloc_tag_add_early_pfn;
> +
> +void alloc_tag_add_early_pfn(unsigned long pfn)
> +{
> +       alloc_tag_add_func alloc_tag_add;
> +
> +       if (static_key_enabled(&mem_profiling_compressed))
> +               return;
> +
> +       rcu_read_lock();
> +       alloc_tag_add =3D rcu_dereference(alloc_tag_add_early_pfn_ptr);
> +       if (alloc_tag_add)
> +               alloc_tag_add(pfn);
> +       rcu_read_unlock();
> +}
> +
> +static void __init clear_early_alloc_pfn_tag_refs(void)
> +{
> +       unsigned int i;
> +
> +       if (static_key_enabled(&mem_profiling_compressed))
> +               return;
> +
> +       rcu_assign_pointer(alloc_tag_add_early_pfn_ptr, NULL);
> +       /* Make sure we are not racing with __alloc_tag_add_early_pfn() *=
/
> +       synchronize_rcu();
> +
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
> +                                *
> +                                * Note: there is still a small race wind=
ow between checking
> +                                * ref.ct and calling set_codetag_empty()=
. We accept this
> +                                * race as it's unlikely and the extra co=
mplexity of atomic
> +                                * cmpxchg is not worth it for this debug=
-only code path.
> +                                */
> +                               if (ref.ct) {
> +                                       put_page_tag_ref(handle);
> +                                       continue;
> +                               }
> +
> +                               set_codetag_empty(&ref);
> +                               update_page_tag_ref(handle, &ref);
> +                               put_page_tag_ref(handle);
> +                       }
> +               }
> +
> +       }
> +}
> +#else /* !CONFIG_MEM_ALLOC_PROFILING_DEBUG */
> +static inline void __init clear_early_alloc_pfn_tag_refs(void) {}
> +#endif /* CONFIG_MEM_ALLOC_PROFILING_DEBUG */
> +
>  static __init void init_page_alloc_tagging(void)
>  {
> +       clear_early_alloc_pfn_tag_refs();
>  }
>
>  struct page_ext_operations page_alloc_tagging_ops =3D {
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 2d4b6f1a554e..04494bc2e46f 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -1289,10 +1289,18 @@ void __pgalloc_tag_add(struct page *page, struct =
task_struct *task,
>         union pgtag_ref_handle handle;
>         union codetag_ref ref;
>
> -       if (get_page_tag_ref(page, &ref, &handle)) {
> +       if (likely(get_page_tag_ref(page, &ref, &handle))) {
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
> +               if (task->alloc_tag)
> +                       alloc_tag_set_inaccurate(task->alloc_tag);
>         }
>  }
>
> --
> 2.25.1
>

