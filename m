Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1D3C8D711C8
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 00:27:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 850AB6B0089; Thu, 18 Dec 2025 19:26:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7FE466B008A; Thu, 18 Dec 2025 19:26:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6DFC06B0092; Thu, 18 Dec 2025 19:26:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5E5546B0089
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 19:26:59 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 154E1136311
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 00:26:59 +0000 (UTC)
X-FDA: 84234330558.20.82259DC
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	by imf28.hostedemail.com (Postfix) with ESMTP id 276D3C000C
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 00:26:56 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=bcO5ryz+;
	spf=pass (imf28.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.44 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766104017;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=G8PBYCo/QeAIMip4Z0up6tB7usLt9oGChXKSBtDDKtg=;
	b=ErcCtAa3AmgCcO/wENEGNAiaCM9nkJE0PfNtd1uVGb3dbx/CkEE77Lh/9yNZ2KIjFaqgP3
	cBfvAFQvaLf3LmEH2Y8nItLr/eQ58u1Nia93VsfS/x2S9H21bL4o+tSv4G6pKykmupI80J
	NIwR6l8MyIU2wRAaD+CCjDbJMjHLjXs=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=bcO5ryz+;
	spf=pass (imf28.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.44 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766104017; a=rsa-sha256;
	cv=none;
	b=sPqv60lKME163e/V18HlpezsiMAdCxQ1uqqDO0fJaGxopRicrBAtQ9cS0adOYasjRErsJp
	C2gRgJKpn/iayx6rxXR3zMRMthofRsrmZF6zYe5Mn3JNvxgXrH43vN+c7yioTR70eCnIVT
	yg6HvifPaTuniSRsqxW6iUmQqYvCWMc=
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-640ca678745so2058943a12.2
        for <linux-mm@kvack.org>; Thu, 18 Dec 2025 16:26:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1766104015; x=1766708815; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=G8PBYCo/QeAIMip4Z0up6tB7usLt9oGChXKSBtDDKtg=;
        b=bcO5ryz+Vhr0S8LalS4wiT5l6POuRr+WlZVbk5Y9hfH1IrjLtq6hhSb0JCQIqC61gf
         MPoCtI2j8tX28w1YG6O/UsBsz+xDlvXoW4MdewvPb5RMUaNdHK2VnXAYi/lX0ebhwd9W
         u+fGDKOJYWbnSBX0Vwz0t6qoBQncMfr/wcbtQ4bcs45+cRJTwrmMWb8wKBEQO5aqmex0
         jW8WlI3lRZxuL5j1NVADK35uofxw+L3zvMz/bjLMsRl8zYVYH7LK/hqMW60/N4Bw1sWx
         80y8cs7Ory/5gTNWXBf+bYNzMmtrZmXoAlh5dJerjuRo/vi+cNOvH4RunRTPWl2LMv5l
         zQDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766104015; x=1766708815;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=G8PBYCo/QeAIMip4Z0up6tB7usLt9oGChXKSBtDDKtg=;
        b=rOZ7Ds8fSX9yRutrhByXFqO1YQVfUWuOlA/N4kj4tA4b3Ev141s8/2ONqh3coQL/bR
         QWwuqMeUUcIiVQYljNTn0nkKJ+QiisSLH0XhQorZ7qSS81XQKDqK1PZXAtaYqWNTy4xh
         laQdBDKD77taWl3IJRUCuPKyPf9yKYuRpNtP9vP29Nhx6C4JovCGbUROIwh/fDnGOYxH
         Lbks7A59rEBV/WRo7MikpAxuFOC9w00kNkhzEJupQTDrttIPprU9m4K2EbnYgXjaO4+F
         AvC/TtJfeDuXHve85gaLDCpkpnpmVMJKG/xMgZZiny0Re+4/YYa0708Qk3ExG+o9l8I6
         Rokg==
X-Forwarded-Encrypted: i=1; AJvYcCXl7/wsc/AkfVu/fdX74SXbE16lEcz96amYpOlrkCQG74l88sD33DlSM0NocJMZmVyCoqe4HalUew==@kvack.org
X-Gm-Message-State: AOJu0YzSwNqWYNYW3/lOahmOIJYu4kqPWWFlv/IfxBWj5mSepdHbHHOF
	gdEouHPcKXei3cnLAXToRUE5Bo+A/lvSOoY5ab1YGYGLydYHJOnmv/vTb/Yf+KZpf2RmTzrR85Y
	2Bf736NP5bzvq4WDTpPalENXnbTQyS6PbxRG2E6Lz/w==
X-Gm-Gg: AY/fxX5NyyJIvmWR+ol1uJ4kiCAxLIZhONjaBRi20yxbAi8S6MqCZ0pJeBwAt5dnA8E
	+RVEStuCw8F4Coggxf6ZrBuz4mqUOpf06GsOr+KLQMa0zfYl2OM+CaF0jgh33fFRetcu7DG49oo
	dbSnvzdEbXjyjs/z9TZgNALOtofhF3kXfnXVae9i9ai8yGxfq8zsFfZ0S1XoORzn6mKyarmRSuU
	godtP9iI8ZdW1INwZxb5z3+SdHSm4wOumrVfIfSaxxf3hk4GRzEsCLTamsQrHQ5441gLaodj8CI
	qucl9X7fq0fbui5152MPiYib
X-Google-Smtp-Source: AGHT+IEPpk2oi2/uS7TbsT+Knx1KIm/oHlK+Lp8k6q7ZVbmt0bRrMa3gJwr+kiCunUZsPNtGYNdDFrt9yuYAx2gGA1Q=
X-Received: by 2002:a05:6402:1472:b0:64b:4037:6f60 with SMTP id
 4fb4d7f45d1cf-64b8e937ebcmr1129295a12.7.1766104015597; Thu, 18 Dec 2025
 16:26:55 -0800 (PST)
MIME-Version: 1.0
References: <20251114190002.3311679-1-pasha.tatashin@soleen.com>
 <20251114190002.3311679-12-pasha.tatashin@soleen.com> <20251218215613.GA17304@ranerica-svr.sc.intel.com>
In-Reply-To: <20251218215613.GA17304@ranerica-svr.sc.intel.com>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Thu, 18 Dec 2025 19:26:19 -0500
X-Gm-Features: AQt7F2qk99QOqFiR7y0dRyUrTTpMomXa4XVxcUeP3udd1thYUZ9s9lUscjpp6Z0
Message-ID: <CA+CK2bDucySNG7QqE87bZndgjKH-QCw61romZVExD63S2iM6og@mail.gmail.com>
Subject: Re: [PATCH v2 11/13] kho: Allow kexec load before KHO finalization
To: Ricardo Neri <ricardo.neri-calderon@linux.intel.com>
Cc: akpm@linux-foundation.org, bhe@redhat.com, rppt@kernel.org, 
	jasonmiu@google.com, arnd@arndb.de, coxu@redhat.com, dave@vasilevsky.ca, 
	ebiggers@google.com, graf@amazon.com, kees@kernel.org, 
	linux-kernel@vger.kernel.org, kexec@lists.infradead.org, linux-mm@kvack.org, 
	ricardo.neri@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam02
X-Stat-Signature: iuhpdcjtwn8z78ikawxwrtrdk8w4co5o
X-Rspam-User: 
X-Rspamd-Queue-Id: 276D3C000C
X-HE-Tag: 1766104016-75586
X-HE-Meta: U2FsdGVkX1/pWYMFRr5jKX2hPHQraozhHhBCAOgmKiAOnPhFO/Bh1PWYWit/imKh8IU6a7f5BPvwJq1PHVnyZ78EN6EWdp26ynsY6hTtxsQwnxHYzOAZD0QWb/EtnMZFnZ0RRWxdWKRDlUTMGvbzesG/LmP7mGdHiDIb3EEnT8OXMhjJg7rPqIdyj15kvsbdRVwMPvE5pKI4Vm3iGtoKnReBbTMt527Nt3fvocS6L2E5Df6bsZy59KKExiW5/vm11koNwHQ6Jh0/brqCa72vj6QHhHUmqRcRbAoS9YpcM3rrm/9XehupxXaWyP4TWKXU4/cR4XbO06bpr2rzJJslcyass6NKjT+QAxoun3B92YW65t1xo3v7kHtevlEMz2ixbtipuQ5Tema017+7XxNnhdF0PPj2ygeqnThyKHyNG0WEzCDLRu72xNWB9C7KYqbbgdskczONHjZhhMpJquMkTP1Axd7n88v/uRk3MvmK5GKtnH8pIpe88ywyYVMKVSUetvyYBvtBIkNe1zRMZkn1s3jKGuMotCX6wJ21Z8pLtH1jbOn/BXrmnZohIPhV+7BtJVCIJ659A1Tk614cakLgXIKXaRhBfjYy5iEqBgU61nCzqgFZgqqHYZGMrv7DkrWRj7CbxhEBNffJYPyWeMuC4dzCx3QgWmJoHCPUUFZ4btUE0YpS/8ULoYOXrZ51ZZAhaYNEOdQfVhq+G1+GgTowyat8AVv3FVpMC8y8FCEGYyjRQQUN4rtdUThdRYWnqcPEODuAdPtCMbGIPaTypagB/sULYL4XFW9jFPt89C1cncczxlZFd4sXy0rC95Z9/x2l9Pc2ayMXTpJtWnjkgRgeNSHijQwXcn8KtLjtgUbFNkU7qCaKOJvsrWbUfeVcPxCqDCMkrrIDxaUE2iVPiXB3OTjHyLnRUSq8g3vw3tnVlviCRsl7FS3oU688/kC+TZvRHQMM1hl1dMCpcKxht+Q
 PShybO2U
 oQ+fARE4ofsGv7Lc0qg0op5YHent0YBN55qzY9CQbBfKbs0f1vnRvlovajcK2Nt/6ieyC8BxvvQxX7zFyIAmBsCrQhFagjRLbmpZ4L7flw4wVWH+lkWZVdwnw5+ereJ6WlXlfO2BYjNhAFmVjj/UspXjrPZw8VIDF2Y5oYd0RlDgkLYoKrDluScaAyjuZ0RtVjpRTeMvvfsU8hfKOLNNV01TkSFBmZPV0oUyNN+Q1oMlyiqDE0I6fLICB5tAsux2W89ZWnfGOUVea8stViO7BqJjF6GI5LWkfDW5NzrrDw1IMp0Q=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Dec 18, 2025 at 4:49=E2=80=AFPM Ricardo Neri
<ricardo.neri-calderon@linux.intel.com> wrote:
>
> On Fri, Nov 14, 2025 at 02:00:00PM -0500, Pasha Tatashin wrote:
> > Currently, kho_fill_kimage() checks kho_out.finalized and returns
> > early if KHO is not yet finalized. This enforces a strict ordering wher=
e
> > userspace must finalize KHO *before* loading the kexec image.
> >
> > This is restrictive, as standard workflows often involve loading the
> > target kernel early in the lifecycle and finalizing the state (FDT)
> > only immediately before the reboot.
> >
> > Since the KHO FDT resides at a physical address allocated during boot
> > (kho_init), its location is stable. We can attach this stable address
> > to the kimage regardless of whether the content has been finalized yet.
> >
> > Relax the check to only require kho_enable, allowing kexec_file_load
> > to proceed at any time.
> >
> > Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> > Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> > Reviewed-by: Pratyush Yadav <pratyush@kernel.org>
> > ---
> >  kernel/liveupdate/kexec_handover.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kex=
ec_handover.c
> > index 461d96084c12..4596e67de832 100644
> > --- a/kernel/liveupdate/kexec_handover.c
> > +++ b/kernel/liveupdate/kexec_handover.c
> > @@ -1550,7 +1550,7 @@ int kho_fill_kimage(struct kimage *image)
> >       int err =3D 0;
> >       struct kexec_buf scratch;
> >
> > -     if (!kho_out.finalized)
> > +     if (!kho_enable)
> >               return 0;
>
> Hi Pasha,
>
> Using v6.19-rc1 (which has this changeset) and with:
>
> CONFIG_KEXEC_HANDOVER=3Dy
> CONFIG_KEXEC_HANDOVER_ENABLE_DEFAULT=3Dy
> CONFIG_LIVEUPDATE=3Dn (i.e., nobody calling kho_finalize())
> no reserve_mem=3D entries in the kernel command line
>
> I omit doing
>
> echo 1 > /sys/kernel/debug/kho/out/finalize
>
> before doing
>
> kexec -l <kernel> --initrd=3D<initrd> --commandline=3D"$(cat /proc/cmdlin=
e)"
> kexec -e

Hi Ricardo,

Thank you for reporting this bug. I created a fix here:
https://lore.kernel.org/lkml/20251219002355.3323896-1-pasha.tatashin@soleen=
.com

Please let me know if it works.

Thanks,
Pasha

>
> After the kexec reboot, I see endless warnings about list corruption [1]
> and from _text_poke() [2] (see below).
>
> The post-kexec kernel finds KHO data but it obviously is empty because
> nobody was using it.
>
> I was expecting that KHO would handle this use case gracefully. What if a
> distro does not finalize KHO before kexec and are no in-kernel users?
>
> Am I missing anything?
>
> Thanks and BR,
> Ricardo
>
> [1]. https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/t=
ree/lib/list_debug.c?h=3Dv6.19-rc1#n56
> [2]. https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/t=
ree/arch/x86/kernel/alternative.c?h=3Dv6.19-rc1#n2506
>
> [   10.730845] ------------[ cut here ]------------
> [   10.734848] list_del corruption, ffffd143c1330008->next is LIST_POISON=
1 (dead000000000100)
> [   10.742846] WARNING: lib/list_debug.c:56 at __list_del_entry_valid_or_=
report+0x91/0x110, CPU#12: swapper/0/1
> [   10.750845] Modules linked in:
> [   10.754845] CPU: 12 UID: 0 PID: 1 Comm: swapper/0 Tainted: G S  B   W =
          6.19.0-rc1-ranerica-vanilla #1440 PREEMPT(voluntary)
> [   10.766845] Tainted: [S]=3DCPU_OUT_OF_SPEC, [B]=3DBAD_PAGE, [W]=3DWARN
> [   10.786846] RIP: 0010:__list_del_entry_valid_or_report+0x97/0x110
> [   10.790845] Code: eb e2 48 8d 3d 9a 0a 5a 01 48 89 de 67 48 0f b9 3a 3=
1 c0 eb cf 4c 89 e7 e8 b6 d9 b8 ff 48 8d 3d 8f 0a 5a 01 4c 89 e2 48 89 de <=
67> 48 0f b9 3a 31 c0 eb b1 4c 89 ef e8 98 d9 b8 ff 48 8d 3d 81 0a
> [   10.810845] RSP: 0000:ffff960b000b3c20 EFLAGS: 00010046
> [   10.814845] RAX: 0000000000000011 RBX: ffffd143c1330008 RCX: 000000000=
0000000
> [   10.822845] RDX: dead000000000100 RSI: ffffd143c1330008 RDI: ffffffffa=
11c0cb0
> [   10.830845] RBP: ffff960b000b3c38 R08: 0000000000000000 R09: 000000000=
0000003
> [   10.838845] R10: ffff960b000b3a80 R11: ffffffffa0f470e8 R12: dead00000=
0000100
> [   10.842862] R13: dead000000000122 R14: ffffd143c1338000 R15: 000000000=
0000004
> [   10.850845] FS:  0000000000000000(0000) GS:ffff8af4bc88d000(0000) knlG=
S:0000000000000000
> [   10.858861] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [   10.866845] CR2: 0000000000000000 CR3: 0000000428c3a001 CR4: 000000000=
0370ef0
> [   10.870845] Call Trace:
> [   10.874845]  <TASK>
> [   10.878845]  __free_one_page+0x2b5/0x840
> [   10.882845]  free_pcppages_bulk+0x1cd/0x2f0
> [   10.886845]  free_frozen_page_commit.isra.0+0x219/0x460
> [   10.890845]  __free_frozen_pages+0x37b/0x700
> [   10.894845]  ___free_pages+0xa0/0xb0
> [   10.898845]  __free_pages+0x10/0x20
> [   10.902845]  init_cma_reserved_pageblock+0x4f/0x90
> [   10.906845]  kho_init+0x1ef/0x250
> [   10.910845]  ? __pfx_kho_init+0x10/0x10
> [   10.914845]  do_one_initcall+0x6a/0x3c0
> [   10.918845]  kernel_init_freeable+0x1c8/0x3b0
> [   10.922845]  ? __pfx_kernel_init+0x10/0x10
> [   10.926845]  kernel_init+0x1a/0x1c0
> [   10.930857]  ret_from_fork+0x256/0x2e0
> [   10.934845]  ? __pfx_kernel_init+0x10/0x10
> [   10.938845]  ret_from_fork_asm+0x1a/0x30
> [   10.942844]  </TASK>
> [   10.942846] irq event stamp: 926677
> [   10.946845] hardirqs last  enabled at (926677): [<ffffffffa04064d2>] d=
ump_stack_lvl+0xb2/0xe0
> [   10.954845] hardirqs last disabled at (926676): [<ffffffffa0406475>] d=
ump_stack_lvl+0x55/0xe0
> [   10.962845] softirqs last  enabled at (926576): [<ffffffff9f4b6383>] _=
_irq_exit_rcu+0xc3/0x120
> [   10.970850] softirqs last disabled at (926571): [<ffffffff9f4b6383>] _=
_irq_exit_rcu+0xc3/0x120
> [   10.982845] ---[ end trace 0000000000000000 ]---
> [   10.986845]  non-paged memory
> [   10.986845] ------------[ cut here ]------------
>
> [   49.243722] ------------[ cut here ]------------
> [   49.243723] WARNING: arch/x86/kernel/alternative.c:2506 at __text_poke=
+0x42b/0x470, CPU#20: kworker/20:0/104
> [   49.243725] Modules linked in:
> [   49.243726] CPU: 20 UID: 0 PID: 104 Comm: kworker/20:0 Tainted: G S  B=
   W           6.19.0-rc1-ranerica-vanilla #1440 PREEMPT(voluntary)
> [   49.243728] Tainted: [S]=3DCPU_OUT_OF_SPEC, [B]=3DBAD_PAGE, [W]=3DWARN
> [   49.243730] Workqueue: events intel_pstste_sched_itmt_work_fn
> [   49.243732] RIP: 0010:__text_poke+0x42b/0x470
> [   49.243733] Code: 21 d0 49 09 c0 e9 06 ff ff ff 4c 8b 45 98 4c 2b 05 9=
a db 7f 01 49 c1 e0 06 49 21 d0 e9 ef fe ff ff 0f 0b 0f 0b e9 58 fd ff ff <=
0f> 0b e9 6c fc ff ff e8 89 9a ff 00 e9 07 fe ff ff 0f 0b e9 b2 fe
> [   49.243734] RSP: 0000:ffffae7dc054bbe8 EFLAGS: 00010246
> [   49.243736] RAX: fffffa9c10d9d000 RBX: ffffffff8ed40a4d RCX: fffffa9c0=
0000000
> [   49.243736] RDX: 4000000000000000 RSI: ffffffff8ed40a4d RDI: ffffffff8=
ed40a4d
> [   49.243737] RBP: ffffae7dc054bc58 R08: 0000000000000000 R09: 000000000=
0000001
> [   49.243738] R10: 0000000000000000 R11: 0000000000000000 R12: 000000000=
0000001
> [   49.243739] R13: ffffffff8ec43830 R14: 0000000000000a4d R15: 000000000=
0000a4e
> [   49.243740] FS:  0000000000000000(0000) GS:ffff9dc10ca8d000(0000) knlG=
S:0000000000000000
> [   49.243741] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [   49.243742] CR2: 0000000000000000 CR3: 000000043803a001 CR4: 000000000=
0370ef0
> [   49.243743] Call Trace:
> [   49.243743]  <TASK>
> [   49.243745]  ? partition_sched_domains+0x15d/0x520
> [   49.243748]  smp_text_poke_batch_finish+0xd5/0x3f0
> [   49.243751]  arch_jump_label_transform_apply+0x1c/0x30
> [   49.243753]  __jump_label_update+0xcf/0x110
> [   49.243757]  jump_label_update+0x134/0x200
> [   49.243760]  __static_key_slow_dec_cpuslocked.part.0+0x5b/0x70
> [   49.243763]  static_key_slow_dec_cpuslocked+0x45/0x80
> [   49.243765]  partition_sched_domains+0x3b7/0x520
> [   49.243768]  ? partition_sched_domains+0x7c/0x520
> [   49.243771]  sched_set_itmt_support+0xe2/0x110
> [   49.243773]  intel_pstste_sched_itmt_work_fn+0xe/0x20
> [   49.243775]  process_one_work+0x238/0x6f0
> [   49.243780]  worker_thread+0x1e8/0x3c0
> [   49.243783]  ? __pfx_worker_thread+0x10/0x10
> [   49.243786]  kthread+0x12e/0x260
> [   49.243788]  ? __pfx_kthread+0x10/0x10
> [   49.243791]  ret_from_fork+0x256/0x2e0
> [   49.243793]  ? __pfx_kthread+0x10/0x10
> [   49.243795]  ret_from_fork_asm+0x1a/0x30
> [   49.243801]  </TASK>
> [   49.243802] irq event stamp: 80
> [   49.243802] hardirqs last  enabled at (79): [<ffffffff8fc513f7>] _raw_=
spin_unlock_irq+0x27/0x60
> [   49.243805] hardirqs last disabled at (80): [<ffffffff8fc45581>] __sch=
edule+0xb31/0x1210
> [   49.243808] softirqs last  enabled at (0): [<ffffffff8eca82fd>] copy_p=
rocess+0xadd/0x21d0
> [   49.243810] softirqs last disabled at (0): [<0000000000000000>] 0x0
> [   49.243811] ---[ end trace 0000000000000000 ]---
> [   49.244076] ------------[ cut here ]------------
>
>
>
> >
> >       image->kho.fdt =3D virt_to_phys(kho_out.fdt);
> > --
> > 2.52.0.rc1.455.g30608eb744-goog
> >

