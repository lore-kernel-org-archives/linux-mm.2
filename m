Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 00C7DC98332
	for <linux-mm@archiver.kernel.org>; Sat, 26 Sep 2026 11:54:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8B8BF6B0088; Sat, 26 Sep 2026 07:54:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 869B76B008A; Sat, 26 Sep 2026 07:54:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 75B266B008C; Sat, 26 Sep 2026 07:54:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 420F26B0088
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 07:54:47 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C378C1C35A4
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 11:54:46 +0000 (UTC)
X-FDA: 85255756572.17.3702A5E
Received: from mail-yx1-f53.google.com (mail-yx1-f53.google.com [74.125.224.53])
	by imf28.hostedemail.com (Postfix) with ESMTP id 22E6AC000B
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 11:54:43 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=Qa8yavbw;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf28.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.224.53 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790423684;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ua9n88EZddhkv+bT4vgIw93hWV3VAINF46k/mnf6Wvg=;
	b=RwjEFlLmUsgBXsyXwqIv08E0x+K6y+ztwLyO7m95dcAGeY2IarVD7PtnBvjrWr6k8EfjBq
	VA7vobuaas0gVoSy11Ns39Z4LKKPLyHiR0g96u7HKfPyESjxZJK+hT/FPk5B3AiqXmctsO
	jya5vUNtJeZ941HO+bupU2eC38folYM=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=Qa8yavbw;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf28.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.224.53 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1790423684;
	b=GfiSrBsKCVSjth+l/zxxxVh3Qzo0D3NlDtctjssJFEsgasIVCzR23AKy7BFZKtnc7HiOfq
	RWAt8upQy3IlmrZXRBeShMc4r8/Njq8JmNejShQ/3u9Whe2QhqydrObjxT8gzMVEL0miHP
	gzfNNr/85ZmurdiXhyoBLKW7okwfxWk=
Received: by mail-yx1-f53.google.com with SMTP id 956f58d0204a3-66c9995ca60so1576725d50.1
        for <linux-mm@kvack.org>; Sat, 26 Sep 2026 04:54:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790423682; cv=none;
        d=google.com; s=arc-20260327;
        b=KWIEmuaFAbuoWpNh80qOGtMTAdjdD6NCmOh84KI9vbupynJnRZcammaOpLts+Xq1Av
         qnj8saR1sWiixVu0LDy93eJ7qIURU9UA8DDTDM01oU7y6R3By+L791K3zEah+0IWAHnJ
         Q32Sy7JHzKJJbTYW7fzZ+OYTGUoMoczQJcxQQY2XbqcvtDRV6luGBDPbG7B1ZXCWBBf8
         tqg3aCVS7/kiW++jkRQ4UwT0zItsLhwlktO5cky5P3ZBsV/eIWFsORWRGkxmUhrT2agd
         hO0v3esFAjRhWOFoFUyn35y6CsE5naJpfsGpzLHEOX5vfRTYZ1wDqjKK9QlD4T7rgLVp
         ixyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ua9n88EZddhkv+bT4vgIw93hWV3VAINF46k/mnf6Wvg=;
        fh=MwoW6j/8ogVIOpZsnqm3EUKOvm202M2jiXvQ+czJ3u0=;
        b=eDx9zcm4BbLHUstaG/SscQtCyHgJcXEksEDZ8CpNazdGIOkJP+BFrGBTcbE9mnN0EI
         fDFVaf06SdQ1bPD1J+Lc0mQoiTmQhXgskTYSU9w0uP6aMhpe8hbx+8t0okLF5NI9W1NF
         XFDvmPNKI2C1wFah+RPQ/ySiCsPwEPmQSFmueI/w/pwuAtKqxWqCOfZ3Nn2w1UE1tBjW
         56/AlwuSsAalcU8KTIpV9vCCtuD0W/zn4kkh7FZlLaXR7WeQxnfvW0749UjcYev7MxGc
         rIcCmRfam47fLBSdPFnmreYYKdDUyIqLrjiqCei4vIjPSNLPc18x5F5QPdu0WAovLnoY
         i3Zg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1790423682; x=1791028482; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ua9n88EZddhkv+bT4vgIw93hWV3VAINF46k/mnf6Wvg=;
        b=Qa8yavbwCcn0NCuG1FkyryMnmrdNvu9MB9Z4MWsVR8BvdTRmJrvT2feLz7NT+GM5e9
         uvKMovt6HVD3lP5O19OAt8MWXmxqazEn/e7NQ2trlNL839aIDIbRT4LKE46Gp2vpwxfO
         F8qevZBLx63icIEKMb04Bkj9dqM85PgRGumetBoE9iIhCPuYzlsKXfxcvLXM2G9XY2Lh
         fQKx9YJP4Oa75GcANY/KVt0RcC1mknDTA16upV0TW6YoccC9l9gHz99XXCgCWZ4Sc3uO
         yoqOIjnhsAG0IMr9cQRBt0w6gVsd6gHDgW5WjE8zxB23dTfQZSl0JiborHdNRfTdMSIJ
         Z7Wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790423682; x=1791028482;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ua9n88EZddhkv+bT4vgIw93hWV3VAINF46k/mnf6Wvg=;
        b=AD7lCSHjn1ThlCY3dxt9vJ3UWGXXbCCsB0wXSaH2lvkB3j8NfgrYmjY08HsU5Sc9V3
         Z2k3mlsbHoVCuhEg30LZt/OcxnICgHZnzUlB4+kNuZTxq6592kwEdRtEjthDar+PK2Xp
         uDCi82PcfpljTeaO3RaZd+TjlyqVi1nawgFUuhsY+W8vW2iBfOIAy6hwrRdCG/+6xY8L
         srnBt2gBQxpwaq1M5RGJB0gKckCdaXQ0ccOfXJvtze9usKZl+klPCavAzLKSNwfL5bxs
         M++aYJntuDzvZp2h911mIAxmsR5aX/zwt5lM6dBs3aU7bHDjpEkDtxU73F/9z5AsSIAI
         2g8Q==
X-Forwarded-Encrypted: i=1; AKwUvBySV6XjuOnZa8GJteGQSs8kUBuiM5/ltXPJn4aylXgmjZiSXb0xsfnr9URV2PgEm51EcB8ZTS1OoQ==@kvack.org
X-Gm-Message-State: AFq9FYKc3Iffedw6c9FJlA+Njv6R/EWSV8dK0NYiGuMUptt0B5hde17X
	PKo4Y3tlxjimIwxg0sYjBD26q8+xhLA0uXfVzLDJkb1elRW+sPNdvrLNKoO6zJ2nKzuc69pXyQ/
	rbMv1Uww4u6RxdV/2luEwTp1VgeNzv1RXmVFID5xOEA==
X-Gm-Gg: AYBFou2KSimsazsZHHmJ0JhoqeO2wMa0DW0Tc01zn7kPQXad4k4HIkIoKqRtxDN9FAj
	hbwoZI2wcxsWHIHfYN+mRsOiz/BeFqPo2dhYjrZgEHZKELeTqIuL/WNPNdRxhp83+wBUtLH9cWS
	nDjeU0+BXPv+U0m8BHlWzs0iO6SiueB5MqI9M27lDVMfWoogbN3fyqXp5U8mhgyZpIDif/M8lEJ
	a+1pSGtTF3Aaswbi1pcraBzZchQbQQoRqt4jDIMgLkEX78wCGFlo4qxCLthN1wdPkBSyVRbAfUP
	mKc9ol7Rbjm+UK73cwbdoaaIfIGAjxTxVS1hhwi6VemPUTut/C4Ak1h5IPQ=
X-Received: by 2002:a05:690e:2490:b0:672:bad1:6d76 with SMTP id
 956f58d0204a3-672ed21b01amr3155615d50.5.1790423681747; Sat, 26 Sep 2026
 04:54:41 -0700 (PDT)
MIME-Version: 1.0
References: <202609251257.WwH2kzxF-lkp@intel.com>
In-Reply-To: <202609251257.WwH2kzxF-lkp@intel.com>
From: Muchun Song <songmuchun@bytedance.com>
Date: Sat, 26 Sep 2026 19:54:05 +0800
X-Gm-Features: AclHuK8RE_ZVp9tWBYY7sUp_CXsYQ_TGtg2G0d0TI2Hps7kmVmL0SY5Lc5VsaUA
Message-ID: <CAMZfGtUSPxKtyp6NrR+J1mHpEiYwAJx2wcZfV8U+XpEEt-jq5w@mail.gmail.com>
Subject: Re: [linux-next:master 6102/7200] include/linux/mmzone.h:1160:29:
 error: use of undeclared identifier 'PUD_SHIFT'
To: kernel test robot <lkp@intel.com>
Cc: oe-kbuild-all@lists.linux.dev, Andrew Morton <akpm@linux-foundation.org>, 
	Linux Memory Management List <linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 5pxjk33mg8mk3k5audpg7jewmrzwuok5
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 22E6AC000B
X-HE-Tag: 1790423683-674821
X-HE-Meta: U2FsdGVkX1/b4uzYDBnDhaKXHpaOIBETbi6c1jGTZGkmkNTuo6T+2T7YOIo/n/656VQcepvVm86ay1KYFneoOKlGybafRYg+tMNBY7W3hAIRitNXe+2LIn0KntELnJVqCCWpB81B3Jji2lwIAry/+OcSfL44xkA7DQ9oHkhuH5MDJRhM0kXKyvFCYslr51ENbXkVqrsL3h813SDEpYu2N/vTyaMSqxODI6m0o1fzq+JVizrXyiFPuNZn8oqBXEtWM5aAs17DPd+zKc0ClCirbtr7pqCIFeAUmdruzvDJLC490uTwJQqt5zfqaNM9plurU2LR4jGaQ6Foh/JgHeGwq4lAXhhVLJ1SV9ixczKyXt8YGGFO0zcf2Ibmr4p2l7FdUvU9QJIJScLf/jivat6fWFtN0Hq4QLHAKvnPP7htn8dTq9aukeU0b0OjaNr1iEUeGfIK5POvQBQzIIzJXg+Wmsvbdw/oSceypVjzXUTU41OuJWMfmTN8JCDtT4SWjhZj3OvVvC9gvKpFk59peOzoFuecd7vaQQtUaOCLlhTwFQdu6g3xOXy2OuVEqTBRwwTAPgVzE7pw8OskRu0mXsDVdVp9g5vQz+MK9qNXyaHpTPsRmhQ4DeIpdmah0lu9pE5ocSZss7jwH2wHxHqQ+SsqKwNe2wz8zDjdziDuBdfnoQTCeByrZV6wSWdiPKjfwV1xWxal+S91EBuI6DxYtugkxyPDQ9NSBtJEXp4ola9xPgVj97wGZlMgtihFPpAT7VI4xM1s6ciPb5fg8It+2oMFdK4K5Cg0X3fBjm6umrs9WEi9BxmVoEx0djobpeP1hZy0PPREI+EOrXRVvRjRu7wuOdaT7XunHWNgkqkKHGDcfrnupWLECBDrnlkb0k9LdR49ZKfr1ROA8OC6veluK0aLzMK4P/C0NatPkjnNf6lcI07i2Q0SQrOaBF42UwUhUt+gevtMHMsZXm/FYViAKcP
 EChsOwTS
 /KSEyzMrkHtgciXjMd+El2lB0dHjLV/xVqGf4F8GoF9iIEshW6IcK6vySQD1Vs3tF70dadHUQYbzDDq28/E+SpH/MQgJZa8+CgSh9q/1EylZ215hQK+5ztT5d8yyqDTKhqS045uFNjhe+ZxELqfH47eo9zlDw8mi4+Sl1TsVSLQnzxmYqHl2g389qvzPWuzmIrUoJewqCv/vyLrDVrL/wzwbvYWb4Qm/Crh2ld5mTk3S7KbftRNLUgayZj8sNXnW8FtI91jIE2usX7PME8SMYuC5E70kJfiJ33oszppto4dlE22w/f58KXd+Tb+12VR+/8YbHJMPLSG6fRqdPr7+GA3l3Hsz4wQqAGL9G6Subr7Es63Qi+7rGLQnxudsUe3GLQ+m+9MwOjD1lwkRasbd2x2m9nFk6cjFy2vnotlyEYCRH++pHoSEgqFI1JTO0hrxwY3z6gqT4VTtRSa8RALA3DjvuENnPcsw7uGCcP28fiJI9PyC9orA2nvYnqQjqVG7VI12h
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 25, 2026 at 6:07=E2=80=AFPM kernel test robot <lkp@intel.com> w=
rote:
>
> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.g=
it master
> head:   4c253ac4b29b8c6cc6fdef8f92d4facde62e63b9
> commit: 83c71ba4895fcfd11ec4746d0ef1585c70deb325 [6102/7200] mm/sparse-vm=
emmap: factor out shared vmemmap tail page allocation
> config: riscv-randconfig-r2106-20260925 (https://download.01.org/0day-ci/=
archive/20260925/202609251257.WwH2kzxF-lkp@intel.com/config)
> compiler: clang version 17.0.6 (https://github.com/llvm/llvm-project 6009=
708b4367171ccdbf4b5905cb6a803753fe18)
> reproduce (this is a W=3D1 build): (https://download.01.org/0day-ci/archi=
ve/20260925/202609251257.WwH2kzxF-lkp@intel.com/reproduce)
>
> If you fix the issue in a separate patch/commit (i.e. not just a new vers=
ion of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202609251257.WwH2kzxF-lkp=
@intel.com/
>
> All errors (new ones prefixed by >>):
>
>    In file included from arch/riscv/kernel/asm-offsets.c:9:
>    In file included from include/linux/mm.h:8:
>    In file included from include/linux/gfp.h:7:
> >> include/linux/mmzone.h:1160:29: error: use of undeclared identifier 'P=
UD_SHIFT'

Thanks for the report.

The failure is caused by using VMEMMAP_OPTIMIZATION_NR_ORDERS
as the size of the per-zone vmemmap_tails array in mmzone.h.
The macro expands MAX_FOLIO_ORDER to PUD_SHIFT - PAGE_SHIFT.
However, mmzone.h can be included before the architecture page
table definitions, so PUD_SHIFT is not available at that point.

That said, a simple fix may be difficult to achieve, since the header depen=
dency
problem is hard to resolve. A prerequisite dependency patch is needed to av=
oid
this kind of header dependency issue. Therefore, I will update a new versio=
n of
this series (mm: Switch device DAX to section-based vmemmap optimization) a=
s
soon as possible to fix this problem.

Thanks,
Muchun

>     1160 |         struct page *vmemmap_tails[VMEMMAP_OPTIMIZATION_NR_ORD=
ERS];
>          |                                    ^
>    include/linux/mmzone.h:119:4: note: expanded from macro 'VMEMMAP_OPTIM=
IZATION_NR_ORDERS'
>      119 |         ((__VMEMMAP_OPTIMIZATION_NR_ORDERS > 0 &&       \
>          |           ^
>    include/linux/mmzone.h:117:3: note: expanded from macro '__VMEMMAP_OPT=
IMIZATION_NR_ORDERS'
>      117 |         (MAX_FOLIO_ORDER - VMEMMAP_OPTIMIZATION_MIN_ORDER + 1)
>          |          ^
>    include/linux/mmzone.h:94:27: note: expanded from macro 'MAX_FOLIO_ORD=
ER'
>       94 | #define MAX_FOLIO_ORDER         (PUD_SHIFT - PAGE_SHIFT)
>          |                                  ^
> >> include/linux/mmzone.h:1160:29: error: use of undeclared identifier 'P=
UD_SHIFT'
>    include/linux/mmzone.h:120:57: note: expanded from macro 'VMEMMAP_OPTI=
MIZATION_NR_ORDERS'
>      120 |           IS_ENABLED(CONFIG_SPARSEMEM_VMEMMAP_OPTIMIZATION)) ?=
 __VMEMMAP_OPTIMIZATION_NR_ORDERS : 0)
>          |                                                               =
 ^
>    include/linux/mmzone.h:117:3: note: expanded from macro '__VMEMMAP_OPT=
IMIZATION_NR_ORDERS'
>      117 |         (MAX_FOLIO_ORDER - VMEMMAP_OPTIMIZATION_MIN_ORDER + 1)
>          |          ^
>    include/linux/mmzone.h:94:27: note: expanded from macro 'MAX_FOLIO_ORD=
ER'
>       94 | #define MAX_FOLIO_ORDER         (PUD_SHIFT - PAGE_SHIFT)
>          |                                  ^
>    In file included from arch/riscv/kernel/asm-offsets.c:9:
>    In file included from include/linux/mm.h:36:
>    In file included from include/linux/rcuwait.h:6:
>    In file included from include/linux/sched/signal.h:6:
>    include/linux/signal.h:98:11: warning: array index 3 is past the end o=
f the array (that has type 'unsigned long[1]') [-Warray-bounds]
>       98 |                 return (set->sig[3] | set->sig[2] |
>          |                         ^        ~
>    include/uapi/asm-generic/signal.h:62:2: note: array 'sig' declared her=
e
>       62 |         unsigned long sig[_NSIG_WORDS];
>          |         ^
>    In file included from arch/riscv/kernel/asm-offsets.c:9:
>    In file included from include/linux/mm.h:36:
>    In file included from include/linux/rcuwait.h:6:
>    In file included from include/linux/sched/signal.h:6:
>    include/linux/signal.h:98:25: warning: array index 2 is past the end o=
f the array (that has type 'unsigned long[1]') [-Warray-bounds]
>       98 |                 return (set->sig[3] | set->sig[2] |
>          |                                       ^        ~
>    include/uapi/asm-generic/signal.h:62:2: note: array 'sig' declared her=
e
>       62 |         unsigned long sig[_NSIG_WORDS];
>          |         ^
>    In file included from arch/riscv/kernel/asm-offsets.c:9:
>    In file included from include/linux/mm.h:36:
>    In file included from include/linux/rcuwait.h:6:
>    In file included from include/linux/sched/signal.h:6:
>    include/linux/signal.h:99:4: warning: array index 1 is past the end of=
 the array (that has type 'unsigned long[1]') [-Warray-bounds]
>       99 |                         set->sig[1] | set->sig[0]) =3D=3D 0;
>          |                         ^        ~
>    include/uapi/asm-generic/signal.h:62:2: note: array 'sig' declared her=
e
>       62 |         unsigned long sig[_NSIG_WORDS];
>          |         ^
>    In file included from arch/riscv/kernel/asm-offsets.c:9:
>    In file included from include/linux/mm.h:36:
>    In file included from include/linux/rcuwait.h:6:
>    In file included from include/linux/sched/signal.h:6:
>    include/linux/signal.h:101:11: warning: array index 1 is past the end =
of the array (that has type 'unsigned long[1]') [-Warray-bounds]
>      101 |                 return (set->sig[1] | set->sig[0]) =3D=3D 0;
>          |                         ^        ~
>    include/uapi/asm-generic/signal.h:62:2: note: array 'sig' declared her=
e
>       62 |         unsigned long sig[_NSIG_WORDS];
>          |         ^
>    In file included from arch/riscv/kernel/asm-offsets.c:9:
>    In file included from include/linux/mm.h:36:
>    In file included from include/linux/rcuwait.h:6:
>    In file included from include/linux/sched/signal.h:6:
>    include/linux/signal.h:114:11: warning: array index 3 is past the end =
of the array (that has type 'const unsigned long[1]') [-Warray-bounds]
>      114 |                 return  (set1->sig[3] =3D=3D set2->sig[3]) &&
>          |                          ^         ~
>    include/uapi/asm-generic/signal.h:62:2: note: array 'sig' declared her=
e
>       62 |         unsigned long sig[_NSIG_WORDS];
>          |         ^
>    In file included from arch/riscv/kernel/asm-offsets.c:9:
>    In file included from include/linux/mm.h:36:
>    In file included from include/linux/rcuwait.h:6:
>    In file included from include/linux/sched/signal.h:6:
>    include/linux/signal.h:114:27: warning: array index 3 is past the end =
of the array (that has type 'const unsigned long[1]') [-Warray-bounds]
>      114 |                 return  (set1->sig[3] =3D=3D set2->sig[3]) &&
>          |                                          ^         ~
>    include/uapi/asm-generic/signal.h:62:2: note: array 'sig' declared her=
e
>       62 |         unsigned long sig[_NSIG_WORDS];
>          |         ^
>    In file included from arch/riscv/kernel/asm-offsets.c:9:
>    In file included from include/linux/mm.h:36:
>    In file included from include/linux/rcuwait.h:6:
>    In file included from include/linux/sched/signal.h:6:
>    include/linux/signal.h:115:5: warning: array index 2 is past the end o=
f the array (that has type 'const unsigned long[1]') [-Warray-bounds]
>      115 |                         (set1->sig[2] =3D=3D set2->sig[2]) &&
>          |                          ^         ~
>    include/uapi/asm-generic/signal.h:62:2: note: array 'sig' declared her=
e
>       62 |         unsigned long sig[_NSIG_WORDS];
>          |         ^
>    In file included from arch/riscv/kernel/asm-offsets.c:9:
>    In file included from include/linux/mm.h:36:
>    In file included from include/linux/rcuwait.h:6:
>    In file included from include/linux/sched/signal.h:6:
>    include/linux/signal.h:115:21: warning: array index 2 is past the end =
of the array (that has type 'const unsigned long[1]') [-Warray-bounds]
>      115 |                         (set1->sig[2] =3D=3D set2->sig[2]) &&
>          |                                          ^         ~
>    include/uapi/asm-generic/signal.h:62:2: note: array 'sig' declared her=
e
>       62 |         unsigned long sig[_NSIG_WORDS];
>          |         ^
>    In file included from arch/riscv/kernel/asm-offsets.c:9:
>    In file included from include/linux/mm.h:36:
>    In file included from include/linux/rcuwait.h:6:
>    In file included from include/linux/sched/signal.h:6:
>    include/linux/signal.h:116:5: warning: array index 1 is past the end o=
f the array (that has type 'const unsigned long[1]') [-Warray-bounds]
>      116 |                         (set1->sig[1] =3D=3D set2->sig[1]) &&
>          |                          ^         ~
>    include/uapi/asm-generic/signal.h:62:2: note: array 'sig' declared her=
e
>       62 |         unsigned long sig[_NSIG_WORDS];
>          |         ^
>    In file included from arch/riscv/kernel/asm-offsets.c:9:
>
>
> vim +/PUD_SHIFT +1160 include/linux/mmzone.h
>
> 3484b2de9499df Mel Gorman             2014-08-06  1152
> 7cf91a98e607c2 Joonsoo Kim            2016-03-15  1153          bool     =
               contiguous;
> 7cf91a98e607c2 Joonsoo Kim            2016-03-15  1154
> e6ad640bc404eb Shakeel Butt           2022-08-26  1155          CACHELINE=
_PADDING(_pad3_);
> 3484b2de9499df Mel Gorman             2014-08-06  1156          /* Zone s=
tatistics */
> 3484b2de9499df Mel Gorman             2014-08-06  1157          atomic_lo=
ng_t           vm_stat[NR_VM_ZONE_STAT_ITEMS];
> f19298b9516c1a Mel Gorman             2021-06-28  1158          atomic_lo=
ng_t           vm_numa_event[NR_VM_NUMA_EVENT_ITEMS];
> 83c71ba4895fcf Muchun Song            2026-09-11  1159  #ifdef CONFIG_SPA=
RSEMEM_VMEMMAP
> e1b6218149da3f Muchun Song            2026-09-10 @1160          struct pa=
ge *vmemmap_tails[VMEMMAP_OPTIMIZATION_NR_ORDERS];
> 622026e87c4019 Kiryl Shutsemau        2026-02-27  1161  #endif
> 22fc6eccbf4ce4 Ravikiran G Thirumalai 2006-01-08  1162  } ____cacheline_i=
nternodealigned_in_smp;
> ^1da177e4c3f41 Linus Torvalds         2005-04-16  1163
>
> :::::: The code at line 1160 was first introduced by commit
> :::::: e1b6218149da3f0eef54e9466e3b31ec47d3c991 mm/sparse-vmemmap: rename=
 HVO order macros
>
> :::::: TO: Muchun Song <songmuchun@bytedance.com>
> :::::: CC: Andrew Morton <akpm@linux-foundation.org>
>
> --
> 0-DAY CI Kernel Test Service
> https://github.com/intel/lkp-tests/wiki

