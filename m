Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7F171108B912
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 12:23:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 934EC6B0088; Fri, 20 Mar 2026 08:23:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8E7136B0089; Fri, 20 Mar 2026 08:23:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7D4AD6B008A; Fri, 20 Mar 2026 08:23:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 690126B0088
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 08:23:30 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0F2C5138FEB
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 12:23:30 +0000 (UTC)
X-FDA: 84566356980.11.CA80C6B
Received: from mail-dl1-f51.google.com (mail-dl1-f51.google.com [74.125.82.51])
	by imf26.hostedemail.com (Postfix) with ESMTP id F108B140010
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 12:23:27 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="gxWsucT/";
	spf=pass (imf26.hostedemail.com: domain of mclapinski@google.com designates 74.125.82.51 as permitted sender) smtp.mailfrom=mclapinski@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774009408;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SYv24HC7LrXJB439CdGZLPTD4jOYoGyK5TH5q9G2jWw=;
	b=3XrR/bb7nSIFZaVxP4+qJVdYGAJAZcJJW0Et60iZ4gmje9bDkrsXwU0UYSkdebW1RcmUHc
	AxvzBmsH+DGvJx8g/vOV2NsBjJPfHjTW5SauOpaAgcDw9IBWGHLS0P5sIp1v6htWwVQdg/
	/4vr6xtzwlL9iWO3u3G7Et+HNn+TM4o=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774009408; a=rsa-sha256;
	cv=pass;
	b=UDnl6SI2Iubm6/DTAcIKZl4pCMErSgSAUDYmyw/cCPALmSA4S2YItoIJJcd+gzaTELTAXX
	SIBwrPpOwVh9MG8/9QcRlAoho2SlgjVG2lECqGt/X2A3a7UJIX9yGBsAvJOZGheujMDyY1
	N2z9MHuW03wGVoVg9qlCjCXhQpBj9Ag=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="gxWsucT/";
	spf=pass (imf26.hostedemail.com: domain of mclapinski@google.com designates 74.125.82.51 as permitted sender) smtp.mailfrom=mclapinski@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-dl1-f51.google.com with SMTP id a92af1059eb24-1270f10a774so6446c88.1
        for <linux-mm@kvack.org>; Fri, 20 Mar 2026 05:23:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774009407; cv=none;
        d=google.com; s=arc-20240605;
        b=QkiQ0ks0bl6H69RpG6ZoEw3Vrb1ipuQfPUO3Unw+nFVUZDOeMMUs6iX2jdKGMC7yy2
         bbb1z/S4acytonR1TKwPBoWA71GpYHrR5TN4r+NRlxSl2552uCkQKUOlDfhqFMwzsrJY
         cndZJNALHWN4kl6eyXIZW5mUcmWP/p9RoLdGUMroiIeSO3sQNEsiykU66U1cdF41PUwf
         TmK6Cr0QjvQiJGqgSZ5KBjPezzaqjkXyRpsaNk+tUoWuJ5hln8+fuctgDaLPULxPeJLH
         fVBRD6qa5OunOqkDKuEEOsqQKeH8uCUC/z46HcfTrm2F/TB9GCXg4gRz+8R4k41yMOYu
         jlkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=SYv24HC7LrXJB439CdGZLPTD4jOYoGyK5TH5q9G2jWw=;
        fh=uDyguMb7yX1hxfWAnx5KQ74m78mxrNuUgsRHBTWydCE=;
        b=ZPrILGwbRyVOeqMzKOiVpSDst8P8qdAVIb0imp48ZZIE2Tmmyraot3Fy1IFmGzhPUa
         s9jXFkA8oL63qL7C4oEWOlw2IuWz7kDG0GCBkNgIh3uLSyRag8mDnWqeAPoJdEMkCk5g
         VbG85Ogr/6ftWAufTyKd9baj2fguNYMtu+4u/QbCAo44EdFbDFO3kKRclrWyFCbzvCPm
         u3siSxpoQr0aXHo3I8kKJ4PjW+vDhX8AkAZL+3EzJK8wJCQAy32CieUVIa3bYEo16KQj
         /L87FrxLE4K/xzxUnX6348hUQQwCzHMENjg/lC8aU9k5W6272esAs1ZvG3iMui3TufjR
         CROA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774009407; x=1774614207; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SYv24HC7LrXJB439CdGZLPTD4jOYoGyK5TH5q9G2jWw=;
        b=gxWsucT/bEmCGM+oa03gqSsmVmXlTYvZ6yCencGHLvXeblRhvvBMnc1dCROoa2TtNQ
         CqEVRL43a9bO99pB/tctjtHnMvak9mJpQ+fbO/Qqm0PGrT79f3dyF3wi2ISERGCm3Czt
         UtTebJEYh4/62QTI4r/0EQblau51SLbUxIDAYnfETkxihB0gIYSR1uN1SdTCP2WwI9yG
         sX8A3WCTflBIqg3WHwHKvG4QZJa1VjfN6x8tGMo+yqO7YT87e4AqUIuRgwjFAaRSFDmt
         AolroWvfA1KbrtqcXV9V1UtG3W4geq7uOPeNpPluqknZccAcyCmC2wssvWKeEh5DIeqs
         n5og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774009407; x=1774614207;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=SYv24HC7LrXJB439CdGZLPTD4jOYoGyK5TH5q9G2jWw=;
        b=AbEvZeSlaacmn5B4UPltaD/wA2L+NFZfUoGcn1TdokQqKKLnVnw2rpo0L0DtqzXyec
         V4Ghy9quSHq97EpYwqxipRK2Ky3XupYo1nNHRR5ZiTkPKyyq6G3ZDV9Xf+VVSF8VY7zo
         xxmvkAWggulcKVGi0U0fuR79p2as9Sn7ng4IS/F6TD0ry3AWNqNGuPqBFBelg49k3Kmj
         uc8yOQNMzroRXYiK4FK7dIkzOUDgX9UqTUDl5qPVJuttrcpPCrl3fGzZ5kCqID9uyQnj
         8MHWmsPTsOMWPo8IeeW8g/vPbGn5rUErgif2EjP/b0oq/5z7+9CPj9IklNF04+TURH+d
         R49w==
X-Forwarded-Encrypted: i=1; AJvYcCUr//7cjVAKvkxSBbpzyHkMezX4htjPuSrzbatRBz4ZSVsnGTmlrRpEwkl+smJyQIb+iEyuWAgBmA==@kvack.org
X-Gm-Message-State: AOJu0YxrqhL9TMt6v5FrRFE4IaN1KEAuDi52c9WDtErMVyMVwcodZeYx
	4w8cU5GhgGlsVO4KsmHNRoOPBWhBGPBUIhS4oritmAzxUUicJSdv39GA7yBitQUKOEsKWKgoBk0
	gvwPrr8+7LVGuZtmKm+QQzDvvP7F10RWoBZb7l16o
X-Gm-Gg: ATEYQzy1551AMj7Gg66Q3r2zpkm4UmtY0xPq/3PA6p4dp11qyQC0QdC4eKn/+R40uH/
	IEE29w1uM0Vm1n3dKIRUnn+WsbH+6/8wRVHImM7ie5JKprETVzFxC2g4eiqRTDfhjlPmIT2fXU7
	rbQwRfWozbaMYvdLw/ipjwLUzkbVbyslgXNNGkwUBe8DTy9FLtqtUKXXqBQ+chHnKsA7fm1ddIn
	bLUUt/P8/7a6DQ7+hGQ8dDkg3dd8IqjdwRzOK+oPQlJHmruEvuaKDqX2PbY3mUjTpsMgDp+/bpZ
	8L3OlA==
X-Received: by 2002:a05:7022:1609:b0:124:9f86:aeb4 with SMTP id
 a92af1059eb24-12a73085652mr80229c88.1.1774009405841; Fri, 20 Mar 2026
 05:23:25 -0700 (PDT)
MIME-Version: 1.0
References: <20260319233745.GA769346@ax162> <abzKcGiRSR_E8lLN@hyeyoo>
In-Reply-To: <abzKcGiRSR_E8lLN@hyeyoo>
From: =?UTF-8?B?TWljaGHFgiBDxYJhcGnFhHNraQ==?= <mclapinski@google.com>
Date: Fri, 20 Mar 2026 13:23:13 +0100
X-Gm-Features: AaiRm50sj-DgG9yMW7k7QcDOnwzXZwETClua3TnV03iPZLva549LNtSM_gJ_Q5c
Message-ID: <CAAi7L5fqc-DZOO4F-VTbV8_=A1KFmm6qBaXjP=QenjLwiVLwuA@mail.gmail.com>
Subject: Re: NULL pointer dereference when booting ppc64_guest_defconfig in
 QEMU on -next
To: Harry Yoo <harry.yoo@oracle.com>
Cc: Nathan Chancellor <nathan@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	=?UTF-8?Q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>, 
	Andrew Morton <akpm@linux-foundation.org>, Thomas Gleixner <tglx@kernel.org>, 
	Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>, linux-mm@kvack.org, 
	linux-trace-kernel@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: F108B140010
X-Stat-Signature: 9jmo6w4dr6z79tsp7g9cjtiwehedezww
X-HE-Tag: 1774009407-875725
X-HE-Meta: U2FsdGVkX19oP9BagRJg0SsYBXpSOMkXvZVGLLHJ1G1Y4P2HhgCdnhwxAAA7HsgVBjkE2k6BFDtD+AzrF7kSAyMTBUCA8JXpprscxgkTnMvg1EZ1aYjsb0Vp4x5XlnmXsZ/HRxCBemXri8pyjxkcf8XxNJ5XXPTIo/KDU0rZ6ZT6+JAmeYJhyZSCMhKIRRlOf5wynaKr20Q9A/+jkl7aN7huwO2hkU+qYi0DrhZJYcGor27f5kbafwV3nUI+x1UnsYQAh1quRBmC3wUsOjMppOtaZ2PzV5Tahf4VoSvc/ZkfUkA8Vf5BrlnewC7hGhX64O0bxlBaHI3rbKSnNfYNh9PprHJZ3chAO8CEIUkEnV7L03VpkNF4Shhrpjf+XWQnqGNckTLsQYIw5h9G5RvOkIo5Q5mQFApyC1Xi0RaKM0dblnzSkCDw9HLHmTYH0tFI5lwof80NBk1a+X+7kJsc/ldBvBJxRgTAt4xO3e32jnQYdIhWJNeC94SgTzv58ztsJ3m3ZXLAl+bmZ68MVK6hs+8f9ZHLDZV2Xiky+MnnS9dgtTDq7UAMRF4af+GF9V4VCrYl2RX0bDQbSasOIocWn+C4+aSvU6GBXJuF/LM9uo+/uGZTGqsbF2P3w5lTcgDVvdERKzoHERh92rjYhupgc3pNSBsYi/CaLF6HFriOxfwBp8uNb60fVOvrnE/oyBmPKeGwhKgUD5ACz+9LEGJCgjh0tEVMjh61t5Um2uYr3BCUmCpjggz9SFXvx1dJrOGbRRGa394Xx5ey2HLxwzF4LBvYD5EiOQpe7bZxbdmhoMiBxRyAY5ncqG277+c53sayFunzCy3OI29OwNTU6WG0hF9C2i14Fjw6z1tp6l3sCzdRKM3KIK9YLVANo44Xajkc5bQEoTjNSyPaWOorp+VFO2zZryVoQjEu7U0UBLohBTFTyxO0KIJDJGnjbBtkXCyh2jZ2QMLq3t6sP1vetyQ
 cgg6J0Kf
 B727UQaIHBz8t7EuQivUsS4E2iIrw/foADYqmIo7yJ6m61iI22VNtclFBUp9/Ix8en/uw47pxxA1NxdXHlEZSSF9cQMo+R5MMwH5VsGFZ5CzW7ZeaSAWBwwVmbuxvbwoJG4tfvxkKLDVHiN87OpW6QIskvSCZQCXIV+5hig3cWqnEPfxOYxBgZn732MiaVR8a/LWhmuSqZspx+UsTgq2QB4Tdr4WRxamBU58NsXyy7xfZwrNsy1FIhFg+Zw+LgJt83kqEADze6HATcCLb7oTGvPCiGzlHpW/BkzVCEYKu/tDXY33o+1VXEgK/5J5hzE4P2QK9JcAcwRGwXWa+sF/HLGdoU5EKuCIAT4PNNM+Kb2OdzvDA7kPEBKJsBYtkaddDooTWmLAVq+Cnzts5aoe2kwco34j0ohGB4ijYBWeduUdVztRsUMeVb+2yGpKlet7jxuegElkPDCHLzclPxSbJ30kJPSigLnLnZUSH1UcluOnqbbwZ6nJInjS30AHIAiDhhQHbnID9zC1m5h4UspLfdVDNQwNTdSVOyllHUvY83V66kE39LQzUWfGlhQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 20, 2026 at 5:18=E2=80=AFAM Harry Yoo <harry.yoo@oracle.com> wr=
ote:
>
> On Thu, Mar 19, 2026 at 04:37:45PM -0700, Nathan Chancellor wrote:
> > Hi all,
> >
> > I am not really sure whose bug this is, as it only appears when three
> > seemingly independent patch series are applied together, so I have adde=
d
> > the patch authors and their committers (along with the tracing
> > maintainers) to this thread. Feel free to expand or reduce that list as
> > necessary.
> >
> > Our continuous integration has noticed a crash when booting
> > ppc64_guest_defconfig in QEMU on the past few -next versions.
> >
> >   https://github.com/ClangBuiltLinux/continuous-integration2/actions/ru=
ns/23311154492/job/67811527112
> >
> > This does not appear to be clang related, as it can be reproduced with
> > GCC 15.2.0 as well. Through multiple bisects, I was able to land on
> > applying:
> >
> >   mm: improve RSS counter approximation accuracy for proc interfaces [1=
]
> >   vdso/datastore: Allocate data pages dynamically [2]
> >   kho: fix deferred init of kho scratch [3]
> >
> > and their dependent changes on top of 7.0-rc4 is enough to reproduce
> > this (at least on two of my machines with the same commands). I have
> > attached the diff from the result of the following 'git apply' commands
> > below, done in a linux-next checkout.
> >
> >   $ git checkout v7.0-rc4
> >   HEAD is now at f338e7738378 Linux 7.0-rc4
> >
> >   # [1]
> >   $ git diff 60ddf3eed4999bae440d1cf9e5868ccb3f308b64^..087dd6d2cc12c82=
945ab859194c32e8e977daae3 | git apply -3v
> >   ...
> >
> >   # [2]
> >   # Fix trivial conflict in init/main.c around headers
> >   $ git diff dc432ab7130bb39f5a351281a02d4bc61e85a14a^..05988dba11791cc=
bb458254484826b32f17f4ad2 | git apply -3v
> >   ...
> >
> >   # [3]
> >   # Fix conflict in kernel/liveupdate/kexec_handover.c due to lack of k=
ho_mem_retrieve(), just add pfn_is_kho_scratch()
> >   $ git show 4a78467ffb537463486968232daef1e8a2f105e3 | git apply -3v
> >   ...
> >
> >   $ make -skj"$(nproc)" ARCH=3Dpowerpc CROSS_COMPILE=3Dpowerpc64-linux-=
 mrproper ppc64_guest_defconfig vmlinux
> >
> >   $ curl -LSs https://github.com/ClangBuiltLinux/boot-utils/releases/do=
wnload/20241120-044434/ppc64-rootfs.cpio.zst | zstd -d >rootfs.cpio
> >
> >   $ qemu-system-ppc64 \
> >       -display none \
> >       -nodefaults \
> >       -cpu power8 \
> >       -machine pseries \
> >       -vga none \
> >       -kernel vmlinux \
> >       -initrd rootfs.cpio \
> >       -m 1G \
> >       -serial mon:stdio
>
> Thanks, such a detailed steps to reproduce!
> Interestingly, the combination of my compiler (GCC 13.3.0) and
> QEMU (8.2.2) don't trigger this bug.
>
> >   [    0.000000][    T0] Linux version 7.0.0-rc4-dirty (nathan@framewor=
k-amd-ryzen-maxplus-395) (powerpc64-linux-gcc (GCC) 15.2.0, GNU ld (GNU Bin=
utils) 2.45) #1 SMP PREEMPT Thu Mar 19 15:45:53 MST 2026
> >   ...
> >   [    0.216764][    T1] vgaarb: loaded
> >   [    0.217590][    T1] clocksource: Switched to clocksource timebase
> >   [    0.221007][   T12] BUG: Kernel NULL pointer dereference at 0x0000=
0010
> >   [    0.221049][   T12] Faulting instruction address: 0xc0000000004494=
7c
> >   [    0.221237][   T12] Oops: Kernel access of bad area, sig: 11 [#1]
> >   [    0.221276][   T12] BE PAGE_SIZE=3D64K MMU=3DHash  SMP NR_CPUS=3D2=
048 NUMA pSeries
> >   [    0.221359][   T12] Modules linked in:
> >   [    0.221556][   T12] CPU: 0 UID: 0 PID: 12 Comm: kworker/u4:0 Not t=
ainted 7.0.0-rc4-dirty #1 PREEMPTLAZY
> >   [    0.221631][   T12] Hardware name: IBM pSeries (emulated by qemu) =
POWER8 (architected) 0x4d0200 0xf000004 of:SLOF,HEAD pSeries
> >   [    0.221765][   T12] Workqueue: trace_init_wq tracer_init_tracefs_w=
ork_func
> >   [    0.222065][   T12] NIP:  c00000000044947c LR: c00000000041a584 CT=
R: c00000000053aa90
> >   [    0.222084][   T12] REGS: c000000003bc7960 TRAP: 0380   Not tainte=
d  (7.0.0-rc4-dirty)
> >   [    0.222111][   T12] MSR:  8000000000009032 <SF,EE,ME,IR,DR,RI>  CR=
: 44000204  XER: 00000000
> >   [    0.222287][   T12] CFAR: c000000000449420 IRQMASK: 0
> >   [    0.222287][   T12] GPR00: c00000000041a584 c000000003bc7c00 c0000=
00001c08100 c000000002892f20
> >   [    0.222287][   T12] GPR04: c0000000019cfa68 c0000000019cfa60 00000=
00000000001 0000000000000064
> >   [    0.222287][   T12] GPR08: 0000000000000002 0000000000000000 c0000=
00003bba000 0000000000000010
> >   [    0.222287][   T12] GPR12: c00000000053aa90 c000000002c50000 c0000=
00001ab25f8 c000000001626690
> >   [    0.222287][   T12] GPR16: 0000000000000000 0000000000000000 00000=
00000000000 0000000000000000
> >   [    0.222287][   T12] GPR20: c000000001624868 c000000001ab2708 c0000=
000019cfa08 c000000001a00d18
> >   [    0.222287][   T12] GPR24: c0000000019cfa18 fffffffffffffef7 c0000=
00003051205 c0000000019cfa68
> >   [    0.222287][   T12] GPR28: 0000000000000000 c0000000019cfa60 c0000=
00002894e90 0000000000000000
> >   [    0.222526][   T12] NIP [c00000000044947c] __find_event_file+0x9c/=
0x110
> >   [    0.222572][   T12] LR [c00000000041a584] init_tracer_tracefs+0x27=
4/0xcc0
> >   [    0.222643][   T12] Call Trace:
> >   [    0.222690][   T12] [c000000003bc7c00] [c000000000b943b0] tracefs_=
create_file+0x1a0/0x2b0 (unreliable)
> >   [    0.222766][   T12] [c000000003bc7c50] [c00000000041a584] init_tra=
cer_tracefs+0x274/0xcc0
> >   [    0.222791][   T12] [c000000003bc7dc0] [c000000002046f1c] tracer_i=
nit_tracefs_work_func+0x50/0x320
> >   [    0.222809][   T12] [c000000003bc7e50] [c000000000276958] process_=
one_work+0x1b8/0x530
> >   [    0.222828][   T12] [c000000003bc7f10] [c00000000027778c] worker_t=
hread+0x1dc/0x3d0
> >   [    0.222883][   T12] [c000000003bc7f90] [c000000000284c44] kthread+=
0x194/0x1b0
> >   [    0.222900][   T12] [c000000003bc7fe0] [c00000000000cf30] start_ke=
rnel_thread+0x14/0x18
> >   [    0.222961][   T12] Code: 7c691b78 7f63db78 2c090000 40820018 e89c=
0000 49107f21 60000000 2c030000 41820048 ebff0000 7c3ff040 41820038 <e93f00=
10> 7fa3eb78 81490058 e8890018
> >   [    0.223190][   T12] ---[ end trace 0000000000000000 ]---
> >   ...
> >
> > Interestingly, turning on CONFIG_KASAN appears to hide this, maybe
> > pointing to some sort of memory corruption (or something timing
> > related)? If there is any other information I can provide, I am more
> > than happy to do so.
>
> I don't have much idea on how things end up causing
> NULL-pointer-deref... but let's point out suspicious things.
>
> > [1]: https://lore.kernel.org/20260227153730.1556542-4-mathieu.desnoyers=
@efficios.com/
>
> @Mathieu: In patch 1/3 description,
> > Changes since v7:
> > - Explicitly initialize the subsystem from start_kernel() right
> >   after mm_core_init() so it is up and running before the creation of
> >   the first mm at boot.
>
> But how does this work when someone calls mm_cpumask() on init_mm early?
> Looks like it will behave incorrectly because get_rss_stat_items_size()
> returns zero?
>
> While it doesn't crash on my environment, it triggers a two warnings
> (with -smp 2 option added). IIUC the cpu bit should have been set in
> setup_arch(), but at the wrong location. After the
> percpu_counter_tree_subsystem_init() function is called, the bit doesn't
> appear to be set.
>
> [    1.392787][    T1] ------------[ cut here ]------------
> [    1.392935][    T1] WARNING: arch/powerpc/mm/mmu_context.c:106 at swit=
ch_mm_irqs_off+0x190/0x1c0, CPU#0: swapper/0/1
> [    1.393187][    T1] Modules linked in:
> [    1.393458][    T1] CPU: 0 UID: 0 PID: 1 Comm: swapper/0 Not tainted 7=
.0.0-rc4-next-20260319 #1 PREEMPTLAZY
> [    1.393600][    T1] Hardware name: IBM pSeries (emulated by qemu) POWE=
R8 (architected) 0x4d0200 0xf000004 of:SLOF,HEAD pSeries
> [    1.393711][    T1] NIP:  c00000000014e390 LR: c00000000014e30c CTR: 0=
000000000000000
> [    1.393752][    T1] REGS: c000000003def7b0 TRAP: 0700   Not tainted  (=
7.0.0-rc4-next-20260319)
> [    1.393807][    T1] MSR:  8000000002021032 <SF,VEC,ME,IR,DR,RI>  CR: 2=
800284a  XER: 00000000
> [    1.393944][    T1] CFAR: c00000000014e328 IRQMASK: 3
> [    1.393944][    T1] GPR00: c00000000014e36c c000000003defa50 c00000000=
1bb8100 c0000000028d8c80
> [    1.393944][    T1] GPR04: c000000004ddc04a 000000000000000a 000000002=
2222222 2222222222222222
> [    1.393944][    T1] GPR08: 2222222222222222 0000000000000000 000000000=
0000001 0000000000008000
> [    1.393944][    T1] GPR12: c000000000521e80 c000000002c70000 c00000000=
000fff0 0000000000000000
> [    1.393944][    T1] GPR16: 0000000000000000 c00000000606c600 c00000000=
3623ac0 0000000000000000
> [    1.393944][    T1] GPR20: c000000004c66300 c00000000606fc00 000000000=
0000001 0000000000000001
> [    1.393944][    T1] GPR24: c000000006069c00 c00000000272c500 000000000=
0000000 0000000000000000
> [    1.393944][    T1] GPR28: c000000003d68200 0000000000000000 c00000000=
28d8a80 c00000000272bd00
> [    1.394355][    T1] NIP [c00000000014e390] switch_mm_irqs_off+0x190/0x=
1c0
> [    1.394395][    T1] LR [c00000000014e30c] switch_mm_irqs_off+0x10c/0x1=
c0
> [    1.394519][    T1] Call Trace:
> [    1.394584][    T1] [c000000003defa50] [c00000000014e36c] switch_mm_ir=
qs_off+0x16c/0x1c0 (unreliable)
> [    1.394676][    T1] [c000000003defab0] [c0000000006edbf0] begin_new_ex=
ec+0x534/0xf60
> [    1.394732][    T1] [c000000003defb20] [c000000000795538] load_elf_bin=
ary+0x494/0x1d1c
> [    1.394765][    T1] [c000000003defc70] [c0000000006eb910] bprm_execve+=
0x380/0x720
> [    1.394796][    T1] [c000000003defd00] [c0000000006ed5a8] kernel_execv=
e+0x12c/0x1bc
> [    1.394831][    T1] [c000000003defd50] [c00000000000eda8] run_init_pro=
cess+0xf8/0x160
> [    1.394864][    T1] [c000000003defde0] [c0000000000100b4] kernel_init+=
0xcc/0x268
> [    1.394899][    T1] [c000000003defe50] [c00000000000cf14] ret_from_ker=
nel_user_thread+0x14/0x1c
> [    1.394946][    T1] ---- interrupt: 0 at 0x0
> [    1.395205][    T1] Code: 7fe4fb78 7f83e378 48009171 60000000 4bffff98=
 60000000 60000000 60000000 0fe00000 4bffff00 60000000 60000000 <0fe00000> =
4bffff98 60000000 60000000
> [    1.395420][    T1] ---[ end trace 0000000000000000 ]---
> [    1.526024][   T67] mount (67) used greatest stack depth: 28432 bytes =
left
> [    1.605803][   T69] mount (69) used greatest stack depth: 27872 bytes =
left
> [    1.667853][   T71] mkdir (71) used greatest stack depth: 27248 bytes =
left
> Saving 256 bits of creditable seed for next boot
> [    1.926636][   T80] ------------[ cut here ]------------
> [    1.926719][   T80] WARNING: arch/powerpc/mm/mmu_context.c:51 at switc=
h_mm_irqs_off+0x180/0x1c0, CPU#0: S01seedrng/80
> [    1.926782][   T80] Modules linked in:
> [    1.926910][   T80] CPU: 0 UID: 0 PID: 80 Comm: S01seedrng Tainted: G =
       W           7.0.0-rc4-next-20260319 #1 PREEMPTLAZY
> [    1.926990][   T80] Tainted: [W]=3DWARN
> [    1.927025][   T80] Hardware name: IBM pSeries (emulated by qemu) POWE=
R8 (architected) 0x4d0200 0xf000004 of:SLOF,HEAD pSeries
> [    1.927091][   T80] NIP:  c00000000014e380 LR: c00000000014e24c CTR: c=
000000000232894
> [    1.927131][   T80] REGS: c000000004d5f800 TRAP: 0700   Tainted: G    =
    W            (7.0.0-rc4-next-20260319)
> [    1.927179][   T80] MSR:  8000000000029032 <SF,EE,ME,IR,DR,RI>  CR: 28=
002828  XER: 20000000
> [    1.927253][   T80] CFAR: c00000000014e280 IRQMASK: 1
> [    1.927253][   T80] GPR00: c0000000002328ec c000000004d5faa0 c00000000=
1bb8100 0000000000000080
> [    1.927253][   T80] GPR04: c0000000028d8280 c000000004509c00 000000000=
0000002 c00000000272c700
> [    1.927253][   T80] GPR08: fffffffffffffffe c0000000028d8280 000000000=
0000000 0000000048002828
> [    1.927253][   T80] GPR12: c000000000232894 c000000002c70000 000000000=
0000000 0000000000000002
> [    1.927253][   T80] GPR16: 0000000000000000 000001002f0a2958 000001002=
f0a2950 ffffffffffffffff
> [    1.927253][   T80] GPR20: 0000000000000000 0000000000000000 c00000000=
2ab1400 c00000000272c700
> [    1.927253][   T80] GPR24: 0000000000000000 c0000000028d8a80 000000000=
0000000 0000000000000000
> [    1.927253][   T80] GPR28: c000000004509c00 0000000000000000 c00000000=
272bd00 c0000000028d8280
> [    1.927629][   T80] NIP [c00000000014e380] switch_mm_irqs_off+0x180/0x=
1c0
> [    1.927678][   T80] LR [c00000000014e24c] switch_mm_irqs_off+0x4c/0x1c=
0
> [    1.927715][   T80] Call Trace:
> [    1.927737][   T80] [c000000004d5faa0] [c000000004d5faf0] 0xc000000004=
d5faf0 (unreliable)
> [    1.927804][   T80] [c000000004d5fb00] [c0000000002328ec] do_shoot_laz=
y_tlb+0x58/0x84
> [    1.927853][   T80] [c000000004d5fb30] [c000000000388304] smp_call_fun=
ction_many_cond+0x6a0/0x8d8
> [    1.927902][   T80] [c000000004d5fc20] [c000000000388624] on_each_cpu_=
cond_mask+0x40/0x7c
> [    1.927943][   T80] [c000000004d5fc50] [c000000000232ad4] __mmdrop+0x8=
8/0x2ec
> [    1.927986][   T80] [c000000004d5fce0] [c000000000242104] do_exit+0x35=
0/0xde4
> [    1.928028][   T80] [c000000004d5fdb0] [c000000000242de0] do_group_exi=
t+0x48/0xbc
> [    1.928072][   T80] [c000000004d5fdf0] [c000000000242e74] pid_child_sh=
ould_wake+0x0/0x84
> [    1.928128][   T80] [c000000004d5fe10] [c000000000030218] system_call_=
exception+0x148/0x3c0
> [    1.928176][   T80] [c000000004d5fe50] [c00000000000c6d4] system_call_=
common+0xf4/0x258
> [    1.928217][   T80] ---- interrupt: c00 at 0x7fff8ade507c
> [    1.928253][   T80] NIP:  00007fff8ade507c LR: 00007fff8ade5034 CTR: 0=
000000000000000
> [    1.928291][   T80] REGS: c000000004d5fe80 TRAP: 0c00   Tainted: G    =
    W            (7.0.0-rc4-next-20260319)
> [    1.928333][   T80] MSR:  800000000280f032 <SF,VEC,VSX,EE,PR,FP,ME,IR,=
DR,RI>  CR: 24002824  XER: 00000000
> [    1.928413][   T80] IRQMASK: 0
> [    1.928413][   T80] GPR00: 00000000000000ea 00007fffe75beb50 00007fff8=
aed7300 0000000000000000
> [    1.928413][   T80] GPR04: 0000000000000000 00007fffe75beda0 00007fffe=
75bedb0 0000000000000000
> [    1.928413][   T80] GPR08: 0000000000000000 0000000000000000 000000000=
0000000 0000000000000000
> [    1.928413][   T80] GPR12: 0000000000000000 00007fff8afaae00 00007fffc=
a692568 0000000133cf0440
> [    1.928413][   T80] GPR16: 0000000000000000 000001002f0a2958 000001002=
f0a2950 ffffffffffffffff
> [    1.928413][   T80] GPR20: 0000000000000000 0000000000000000 00007fffe=
75bf838 00007fff8afa0000
> [    1.928413][   T80] GPR24: 0000000126911328 0000000000000001 00007fff8=
af9dc00 00007fffe75bf818
> [    1.928413][   T80] GPR28: 0000000000000003 fffffffffffff000 000000000=
0000000 00007fff8afa3e10
> [    1.928765][   T80] NIP [00007fff8ade507c] 0x7fff8ade507c
> [    1.928795][   T80] LR [00007fff8ade5034] 0x7fff8ade5034
> [    1.928835][   T80] ---- interrupt: c00
> [    1.928924][   T80] Code: 7c0803a6 4e800020 60000000 60000000 7fe4fb78=
 7f83e378 48009171 60000000 4bffff98 60000000 60000000 60000000 <0fe00000> =
4bffff00 60000000 60000000
> [    1.929054][   T80] ---[ end trace 0000000000000000 ]---
>
> > [2]: https://lore.kernel.org/20260304-vdso-sparc64-generic-2-v6-3-d8eb3=
b0e1410@linutronix.de/
>
> > [3]: https://lore.kernel.org/20260311125539.4123672-2-mclapinski@google=
.com/
>
> @Michal: Something my AI buddy pointed out... (that I think is valid):
>
> > diff --git a/mm/mm_init.c b/mm/mm_init.c
> > index df34797691bd..7363b5b0d22a 100644
> > --- a/mm/mm_init.c
> > +++ b/mm/mm_init.c
> > @@ -2078,9 +2082,11 @@ deferred_init_memmap_chunk(unsigned long start_p=
fn, unsigned long end_pfn,
> >                       unsigned long mo_pfn =3D ALIGN(spfn + 1, MAX_ORDE=
R_NR_PAGES);
> >                       unsigned long chunk_end =3D min(mo_pfn, epfn);
> >
> > -                     nr_pages +=3D deferred_init_pages(zone, spfn, chu=
nk_end);
>
> Previously, deferred_init_pages() returned nr of pages to add, which is
> (end_pfn (=3D chunk_end) - spfn).
>
> > -                     deferred_free_pages(spfn, chunk_end - spfn);
> > +                     // KHO scratch is MAX_ORDER_NR_PAGES aligned.
> > +                     if (!pfn_is_kho_scratch(spfn))
> > +                             deferred_init_pages(zone, spfn, chunk_end=
);
>
> But since the function is not always called with the change,
> the calculation is moved to...
>
> > +                     deferred_free_pages(spfn, chunk_end - spfn);
> >                       spfn =3D chunk_end;
> >
> >                       if (can_resched)
> > @@ -2088,6 +2094,7 @@ deferred_init_memmap_chunk(unsigned long start_pf=
n, unsigned long end_pfn,
> >                       else
> >                               touch_nmi_watchdog();
> >               }
> > +             nr_pages +=3D epfn - spfn;
>
> Here.
>
> But this is incorrect, because here we have:
> > static unsigned long __init
> > deferred_init_memmap_chunk(unsigned long start_pfn, unsigned long end_p=
fn,
> >                            struct zone *zone, bool can_resched)
> > {
> >         int nid =3D zone_to_nid(zone);
> >         unsigned long nr_pages =3D 0;
> >         phys_addr_t start, end;
> >         u64 i =3D 0;
> >
> >         for_each_free_mem_range(i, nid, 0, &start, &end, NULL) {
> >                 unsigned long spfn =3D PFN_UP(start);
> >                 unsigned long epfn =3D PFN_DOWN(end);
> >
> >                 if (spfn >=3D end_pfn)
> >                         break;
> >
> >                 spfn =3D max(spfn, start_pfn);
> >                 epfn =3D min(epfn, end_pfn);
> >
> >                 while (spfn < epfn) {
>
> The loop condition is (spfn < epfn), and by the time the loop terminates.=
..
>
> >                         unsigned long mo_pfn =3D ALIGN(spfn + 1, MAX_OR=
DER_NR_PAGES);
> >                         unsigned long chunk_end =3D min(mo_pfn, epfn);
> >
> >                         // KHO scratch is MAX_ORDER_NR_PAGES aligned.
> >                         if (!pfn_is_kho_scratch(spfn))
> >                                 deferred_init_pages(zone, spfn, chunk_e=
nd);
> >
> >                         deferred_free_pages(spfn, chunk_end - spfn);
> >                         spfn =3D chunk_end;
> >
> >                         if (can_resched)
> >                                 cond_resched();
> >                         else
> >                                 touch_nmi_watchdog();
> >                 }
> >                 nr_pages +=3D epfn - spfn;
>
> epfn - spfn <=3D 0.
>
> So the number of pages returned by deferred_init_memmap_chunk() becomes
> incorrect.
>
> The equivalent translation of what's there before would be doing
> `nr_pages +=3D chunk_end - spfn;` within the loop.

Good point, thank you. This patch has already been removed from mm-new.

> --
> Cheers,
> Harry / Hyeonggon

