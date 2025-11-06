Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 54CA6CCFA05
	for <linux-mm@archiver.kernel.org>; Thu,  6 Nov 2025 22:15:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 855CB8E0003; Thu,  6 Nov 2025 17:15:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 806CA8E0002; Thu,  6 Nov 2025 17:15:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6F5458E0003; Thu,  6 Nov 2025 17:15:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5DC5A8E0002
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 17:15:09 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 14F2E140174
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 22:15:09 +0000 (UTC)
X-FDA: 84081588738.11.7D81595
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	by imf04.hostedemail.com (Postfix) with ESMTP id 124EE4000F
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 22:15:06 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=TmjIroU9;
	spf=pass (imf04.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.46 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762467307;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f81U5/79UyOAGW6VXn6pxFacbUSlx5ZrI8Z3RpSpADo=;
	b=zbhhmAMY9e1lbJfFJ9nVN3VuYx+92OONv6gjiSY3kCOT3TnpHKO3u7wYjGY55ikMZcvF5F
	nXRTF9TlIM1C5nq7tu6tr5gJ9mWQOYZBFj10gKzARTBPFNAQ9mj2JtP2iVYto1r2jGB3rN
	dZuugTuqa6aBoZwN6BUuYwya9Yn/gqo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762467307; a=rsa-sha256;
	cv=none;
	b=G42m9Y+ScQwgZxOwkHZIWmUmHjEVi+9d/aRPdgbreE3QYw1+tJtSQ7iqpkHEEdXmc+QtkM
	Lg3f7+4ZulbmDL/eP4x/VhAV4qghH1n4+n1+VCZOg81TurBSStak3EmBc8f1ubDR/LZFAU
	g20+ZDP6+0Dc9JVrTHn9A50DABmcZ/g=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=TmjIroU9;
	spf=pass (imf04.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.46 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-640b4a52950so188221a12.1
        for <linux-mm@kvack.org>; Thu, 06 Nov 2025 14:15:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1762467305; x=1763072105; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=f81U5/79UyOAGW6VXn6pxFacbUSlx5ZrI8Z3RpSpADo=;
        b=TmjIroU9n6z9UXNA0BCXIfDpFFLvtvNuY9Dk8FlGk+n55XYPZt4yex+0UveOrfrXDh
         42Ef7QB5fewftU1C7q2AZ0zPOXvbZrO1Xj99Jg06tSqhUFDGGThU9ru6kJqLkBJ8kEQl
         XSx3MDvO1OdB/f6YbqrZQNbcQOi3npBNj2MDJ4Ur3aZwh0xh2fYyxTf9QHRE0vWmFhZo
         1kND/SU5DU4hREKQIexHWFomkbmFMvTbaNriKzJocwxvCYdd/45RD2Uls1aJjOxeF8ph
         CvbyXjctwoa2+21A9Hgyi6+EHDc8Cfu/mVJbLN3EK4PTgJHr4FCPwQBrw37YCpWYKA3A
         1YaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762467305; x=1763072105;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=f81U5/79UyOAGW6VXn6pxFacbUSlx5ZrI8Z3RpSpADo=;
        b=hScEfbea/EWryv+h3ux0EV49r/nlEyGuIWVAwaZgtDS6HtI0N7XY39mIuV5iICdgc9
         Q0vfmnmJgtqpgUu/XfHfbnaf/o6rl74U7NU51tGw5qGVBlhp8g7fZsd66KYUYIKj4otK
         vi18jeRMAeAQ462lmRaWOaC7V3Ry2zU8S5kI5TkxD+NRMFnHGtbrBq1jMTcq2CNzoK2S
         1mYd2kAN6J1StVmT0lv9o+HY2MinE2ej4J1AOSsXdEtLn2gTRmAtelsgvfmAvct7MfOr
         gT6EXYb6hZOHJ2ypwWcjB+QNdIIRkAwWrJcaXyJAuj2CjkSkTlDiTpOSgiJ40vT/WWF1
         I1Zw==
X-Forwarded-Encrypted: i=1; AJvYcCWu5APR9juXaNxniJalWFmZ5E8vjUE1DIpRC0jAhF17iRaTuto9V/1PyehPEdlfS7aeQlbSHzdu8g==@kvack.org
X-Gm-Message-State: AOJu0Yz+G3MMS9f6CF4TtbE68Vd/vh59SSxHcDc/p5ICqEpebHlr4hzg
	qHaCZytEj9IBT2mIVsghR/3lVDH2OYsP1KPbMIpVoSxCl7Mn3hz6ZgAf4Adn073csxZKXTik/Oy
	1mbYpRKpy5PuJDfSRmnPazLp8/D7ZtDHcloQBMOk9jg==
X-Gm-Gg: ASbGncvP/83OL4jzN99Gy4RFqNe5g5VPUUQbAMjVhjEuojQBaaTfAsg+VmTRc2NWMOM
	5UG7XMfm9dXUSrHIfUWsHWqDBiI7DjpeSAz6h/Cmw80aD0CH3cvlyQHVnQlj4O7WqRBFtbSIGqA
	WWH25iZQxm3FUPAk7Vj0kuL/jSGuKiKC8xiPkcIEgw+MYipo4aKOCIHckNaRqX8f+oYutadvB1V
	2MC5lyKsRcZ/cDU+LJ68r1USTTzKKcK9Trk+zLkbmuaDhMfJv0iH23rXu7/U5pN4NnQ
X-Google-Smtp-Source: AGHT+IFMNxw/R1yQ2ypKv/nek+CS+Dt0g6lco0tSe4JF0aLBw9GdvNDeY3wOMxlums/5C8vWYWYunbR1HZth+5+nSYU=
X-Received: by 2002:a05:6402:3590:b0:638:74dc:cf78 with SMTP id
 4fb4d7f45d1cf-6413f08ef69mr1005608a12.34.1762467305387; Thu, 06 Nov 2025
 14:15:05 -0800 (PST)
MIME-Version: 1.0
References: <20251101142325.1326536-3-pasha.tatashin@soleen.com>
 <202511061629.e242724-lkp@intel.com> <CA+CK2bCUWuK4fmuz5Us_mS1ByGy5SjaedVEquj1WxN8JUPsJaw@mail.gmail.com>
In-Reply-To: <CA+CK2bCUWuK4fmuz5Us_mS1ByGy5SjaedVEquj1WxN8JUPsJaw@mail.gmail.com>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Thu, 6 Nov 2025 17:14:28 -0500
X-Gm-Features: AWmQ_bkf90cd7vGfxxwFQfOgh84qLMbCwawCMq5n9jVWpcK7oaXbMt6knSHxPMQ
Message-ID: <CA+CK2bCSv99byZ-mc8bdoqfbp7qZTS9anky6oh=5ptg=MWPgxA@mail.gmail.com>
Subject: Re: [PATCH v9 2/9] kho: drop notifiers
To: kernel test robot <oliver.sang@intel.com>
Cc: oe-lkp@lists.linux.dev, lkp@intel.com, kexec@lists.infradead.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, akpm@linux-foundation.org, 
	brauner@kernel.org, corbet@lwn.net, graf@amazon.com, jgg@ziepe.ca, 
	linux-kselftest@vger.kernel.org, masahiroy@kernel.org, ojeda@kernel.org, 
	pratyush@kernel.org, rdunlap@infradead.org, rppt@kernel.org, tj@kernel.org, 
	yanjun.zhu@linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 124EE4000F
X-Stat-Signature: riy6pnkw4r8w44q5ux37sjswcnzdypdp
X-HE-Tag: 1762467306-298649
X-HE-Meta: U2FsdGVkX19Ug3WGejvkI+JnaOAPSMLJWK8QGh+HfgYv3ZUqlUqxziWCcoMf18uCpA0ox4Pl1iziV/uGefSAiwNjTYFwY2dpopy7SU00Vls66hFjVEP9fbhgYQBhC0qoYDeT8fBYZmTocT0qLGzIPtDuptjcy6WUgawru6OUYF/Rx20K5DPC4dngs5lWu2kQfOGYnrOzlOiB267BLDwG40ai61xuu8WQPejwjHPChkGbVy7oGygZ2D/zqLGS06d9SkKry+1y62WTOE/oJyWnndSVk3ee3ul1K7aWVSX7Iw2xyL/BRYOWBIoQXL1FUAMyv4/JK1Tsv6BQ7yP2YBPL8rttLDs9HhMSCp+ENrJOd9Mo/7eU5CpBWH3OEBBLuWHImIjObZwQ9bNX92+xbYQ9nhtaFALZPSJB9szYDwHGPNMnURGMRd7IlzdLE8GqR4h5WSD1LIIWzp9PP3WIlpLD9osbODUoOU9yFUMjlwAtt0ssGzbvx0DECVtjX5I0HhiAwVjuZzhr9f9JFVUObes2mGDhfvQ/BJnd7gB+2hmATyhidr1neIsNFXd4TzrHnXnVICIgAt3kELeIsPEiYFEvaJznRDmX3drgcq60Dudj/MQjR++h50Atv6XN/fEMIftkYiZgTgY/31ydXbrECyOgqJ+dTo46zZjq50ImiH0Utc6EaWEkp26o2+SGzdaSzwvrcINLF7QUd31ryR1Vn894PFrkItygtxyAj5r5zJ36IiPSyC3PTADeZ6klly1gKKaqABm/jyCd7RmYmH1+6IOB9g1jsvkIpUSDycWtkT1QpsRA+a44765W1KRM86Itya/xWnPD2MYRW3kMI4/RUqOzn9kDXewcMNYSXItnzYvr90MhF8fQuxHAC3VHoO/rEDxA/HiVq90OrBNEmXyV0Zp1HzhHzt2N57llokZ8NoUzAJoM1h/3v6LElpa5sVL2L2aY/8h4VLH/ZDaLt+9w8pv
 fS/sC/Ai
 jfmO48x0SuVyKQnGdWCCIZTnsMkZb/1Lv+z3jvASGPz2w0KVc3I9c3BBB0S6J9jnnkubVhlrrXmCT/SMkiiiL4urNuEzEBz0tgzMUSSL7WdQhBj755wTFFv84TkCK9UeL+dSD4Zj+9Djf/uOzcPstTTIrmDjir1TIi0PcxQZJuWwwvspfMHZTlEud1+ETIQWuLSOIUREQ/9a4yOklFn/+aaqlOfGOi7M9CSYH4Z4idM+s0y+LhBEw9LRyzNQI2jpxF/9R5lebFmT6CHoaM5VFyEV+O9+aurtcsxh62xe6EGVhfjcpOTmj0Jt5AHRs0P0Klz1kVfrtjKECIfdq/3b9eKR9TaMO/C9VxgarnGyB171P6cuxQB9QX4kmc3w0q5uSS9US
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Nov 6, 2025 at 4:46=E2=80=AFPM Pasha Tatashin <pasha.tatashin@solee=
n.com> wrote:
>
> The bug is in lib/test_kho.c, when KHO is not enabled, it should not
> run KHO commands, there is a function to test that: kho_is_enabled().
> So, KHO is disabled and kho_add_subtree() which calles add debugfs
> entry, and the list is not initialized, because KHO is disabled. The
> fix is:

Sent it as a patch:
https://lore.kernel.org/all/20251106220635.2608494-1-pasha.tatashin@soleen.=
com

>
> diff --git a/lib/test_kho.c b/lib/test_kho.c
> index 025ea251a186..85b60d87a50a 100644
> --- a/lib/test_kho.c
> +++ b/lib/test_kho.c
> @@ -315,6 +315,9 @@ static int __init kho_test_init(void)
>         phys_addr_t fdt_phys;
>         int err;
>
> +       if (!kho_is_enabled())
> +               return 0;
> +
>         err =3D kho_retrieve_subtree(KHO_TEST_FDT, &fdt_phys);
>         if (!err)
>                 return kho_test_restore(fdt_phys);
>
> On Thu, Nov 6, 2025 at 3:41=E2=80=AFAM kernel test robot <oliver.sang@int=
el.com> wrote:
> >
> >
> >
> > Hello,
> >
> > kernel test robot noticed "WARNING:at_kernel/kexec_handover.c:#kho_add_=
subtree" on:
> >
> > commit: e44a700c561d1e892a8d0829d557e221604a7b93 ("[PATCH v9 2/9] kho: =
drop notifiers")
> > url: https://github.com/intel-lab-lkp/linux/commits/Pasha-Tatashin/kho-=
make-debugfs-interface-optional/20251101-222610
> > patch link: https://lore.kernel.org/all/20251101142325.1326536-3-pasha.=
tatashin@soleen.com/
> > patch subject: [PATCH v9 2/9] kho: drop notifiers
> >
> > in testcase: boot
> >
> > config: x86_64-randconfig-001-20251015
> > compiler: gcc-14
> > test machine: qemu-system-x86_64 -enable-kvm -cpu SandyBridge -smp 2 -m=
 16G
> >
> > (please refer to attached dmesg/kmsg for entire log/backtrace)
> >
> >
> > +--------------------------------------------------------+------------+=
------------+
> > |                                                        | 93e4b3b2e9 |=
 e44a700c56 |
> > +--------------------------------------------------------+------------+=
------------+
> > | WARNING:at_kernel/kexec_handover.c:#kho_add_subtree    | 0          |=
 8          |
> > | RIP:kho_add_subtree                                    | 0          |=
 8          |
> > +--------------------------------------------------------+------------+=
------------+
> >
> >
> > If you fix the issue in a separate patch/commit (i.e. not just a new ve=
rsion of
> > the same patch/commit), kindly add following tags
> > | Reported-by: kernel test robot <oliver.sang@intel.com>
> > | Closes: https://lore.kernel.org/oe-lkp/202511061629.e242724-lkp@intel=
.com
> >
> >
> > [   13.620111][    T1] ------------[ cut here ]------------
> > [   13.620739][    T1] WARNING: CPU: 1 PID: 1 at kernel/kexec_handover.=
c:704 kho_add_subtree (kernel/kexec_handover.c:704)
> > [   13.621665][    T1] Modules linked in:
> > [   13.622090][    T1] CPU: 1 UID: 0 PID: 1 Comm: swapper/0 Not tainted=
 6.18.0-rc3-00211-ge44a700c561d #1 VOLUNTARY
> > [   13.623073][    T1] Hardware name: QEMU Standard PC (i440FX + PIIX, =
1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
> > [   13.624054][    T1] RIP: 0010:kho_add_subtree (kernel/kexec_handover=
.c:704)
> > [   13.624596][    T1] Code: c7 38 b4 ac 85 31 ed e8 01 1c 00 00 48 c7 =
c7 70 5a ca 86 85 c0 89 c3 40 0f 95 c5 31 c9 31 d2 89 ee e8 37 b5 0a 00 85 =
db 74 02 <0f> 0b b9 01 00 00 00 31 d2 89 ee 48 c7 c7 40 5a ca 86 e8 1c b5 0=
a
> > All code
> > =3D=3D=3D=3D=3D=3D=3D=3D
> >    0:   c7 38 b4 ac 85          xbegin 0xffffffff85acb43d,(bad)
> >    5:   31 ed                   xor    %ebp,%ebp
> >    7:   e8 01 1c 00 00          call   0x1c0d
> >    c:   48 c7 c7 70 5a ca 86    mov    $0xffffffff86ca5a70,%rdi
> >   13:   85 c0                   test   %eax,%eax
> >   15:   89 c3                   mov    %eax,%ebx
> >   17:   40 0f 95 c5             setne  %bpl
> >   1b:   31 c9                   xor    %ecx,%ecx
> >   1d:   31 d2                   xor    %edx,%edx
> >   1f:   89 ee                   mov    %ebp,%esi
> >   21:   e8 37 b5 0a 00          call   0xab55d
> >   26:   85 db                   test   %ebx,%ebx
> >   28:   74 02                   je     0x2c
> >   2a:*  0f 0b                   ud2             <-- trapping instructio=
n
> >   2c:   b9 01 00 00 00          mov    $0x1,%ecx
> >   31:   31 d2                   xor    %edx,%edx
> >   33:   89 ee                   mov    %ebp,%esi
> >   35:   48 c7 c7 40 5a ca 86    mov    $0xffffffff86ca5a40,%rdi
> >   3c:   e8                      .byte 0xe8
> >   3d:   1c b5                   sbb    $0xb5,%al
> >   3f:   0a                      .byte 0xa
> >
> > Code starting with the faulting instruction
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >    0:   0f 0b                   ud2
> >    2:   b9 01 00 00 00          mov    $0x1,%ecx
> >    7:   31 d2                   xor    %edx,%edx
> >    9:   89 ee                   mov    %ebp,%esi
> >    b:   48 c7 c7 40 5a ca 86    mov    $0xffffffff86ca5a40,%rdi
> >   12:   e8                      .byte 0xe8
> >   13:   1c b5                   sbb    $0xb5,%al
> >   15:   0a                      .byte 0xa
> > [   13.626370][    T1] RSP: 0018:ffffc9000001fca0 EFLAGS: 00010286
> > [   13.626951][    T1] RAX: dffffc0000000000 RBX: 00000000ffffffff RCX:=
 0000000000000000
> > [   13.627737][    T1] RDX: 1ffffffff0d94b52 RSI: 0000000000000001 RDI:=
 ffffffff86ca5a90
> > [   13.628523][    T1] RBP: 0000000000000001 R08: 0000000000000008 R09:=
 fffffbfff0dfac4c
> > [   13.629330][    T1] R10: 0000000000000000 R11: ffffffff86fd6267 R12:=
 ffff888133ee2000
> > [   13.630101][    T1] R13: ffffffff85acb340 R14: ffff888117a5f988 R15:=
 dffffc0000000000
> > [   13.630869][    T1] FS:  0000000000000000(0000) GS:ffff888426ea0000(=
0000) knlGS:0000000000000000
> > [   13.631727][    T1] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003=
3
> > [   13.632370][    T1] CR2: 00007f586df260ac CR3: 00000000054ea000 CR4:=
 00000000000406f0
> > [   13.633154][    T1] Call Trace:
> > [   13.633506][    T1]  <TASK>
> > [   13.633833][    T1]  kho_test_prepare_fdt+0x145/0x180
> > [   13.634446][    T1]  ? kho_test_save_data+0x210/0x210
> > [   13.635097][    T1]  ? csum_partial (lib/checksum.c:123)
> > [   13.635546][    T1]  kho_test_init (lib/test_kho.c:177 lib/test_kho.=
c:284)
> > [   13.636018][    T1]  ? vmalloc_test_init (lib/test_kho.c:271)
> > [   13.636508][    T1]  ? add_device_randomness (drivers/char/random.c:=
944)
> > [   13.637485][    T1]  ? mix_pool_bytes (drivers/char/random.c:944)
> > [   13.637955][    T1]  ? trace_initcall_start (include/trace/events/in=
itcall.h:27 (discriminator 3))
> > [   13.638498][    T1]  ? vmalloc_test_init (lib/test_kho.c:271)
> > [   13.638989][    T1]  do_one_initcall (init/main.c:1284)
> > [   13.639477][    T1]  ? trace_initcall_start (init/main.c:1274)
> > [   13.639998][    T1]  ? parse_one (kernel/params.c:143)
> > [   13.640455][    T1]  ? kasan_save_track (mm/kasan/common.c:69 (discr=
iminator 1) mm/kasan/common.c:78 (discriminator 1))
> > [   13.640948][    T1]  ? __kmalloc_noprof (mm/slub.c:5659)
> > [   13.641465][    T1]  do_initcalls (init/main.c:1344 (discriminator 3=
) init/main.c:1361 (discriminator 3))
> > [   13.641924][    T1]  kernel_init_freeable (init/main.c:1595)
> > [   13.642441][    T1]  ? rest_init (init/main.c:1475)
> > [   13.642891][    T1]  kernel_init (init/main.c:1485)
> > [   13.643345][    T1]  ? rest_init (init/main.c:1475)
> > [   13.643788][    T1]  ret_from_fork (arch/x86/kernel/process.c:164)
> > [   13.644256][    T1]  ? rest_init (init/main.c:1475)
> > [   13.644703][    T1]  ret_from_fork_asm (arch/x86/entry/entry_64.S:25=
5)
> > [   13.645213][    T1]  </TASK>
> > [   13.645540][    T1] irq event stamp: 132025
> > [   13.645971][    T1] hardirqs last  enabled at (132035): __up_console=
_sem (arch/x86/include/asm/irqflags.h:26 arch/x86/include/asm/irqflags.h:10=
9 arch/x86/include/asm/irqflags.h:151 kernel/printk/printk.c:345)
> > [   13.646887][    T1] hardirqs last disabled at (132046): __up_console=
_sem (kernel/printk/printk.c:343 (discriminator 3))
> > [   13.648253][    T1] softirqs last  enabled at (131286): handle_softi=
rqs (kernel/softirq.c:469 (discriminator 1) kernel/softirq.c:650 (discrimin=
ator 1))
> > [   13.649690][    T1] softirqs last disabled at (131281): __irq_exit_r=
cu (kernel/softirq.c:496 kernel/softirq.c:723)
> > [   13.651128][    T1] ---[ end trace 0000000000000000 ]---
> >
> >
> > The kernel config and materials to reproduce are available at:
> > https://download.01.org/0day-ci/archive/20251106/202511061629.e242724-l=
kp@intel.com
> >
> >
> >
> > --
> > 0-DAY CI Kernel Test Service
> > https://github.com/intel/lkp-tests/wiki
> >

