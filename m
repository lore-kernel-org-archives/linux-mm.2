Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 697C2CCFA04
	for <linux-mm@archiver.kernel.org>; Tue,  4 Nov 2025 17:51:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6CE328E0003; Tue,  4 Nov 2025 12:51:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6A6248E0002; Tue,  4 Nov 2025 12:51:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5E2AC8E0003; Tue,  4 Nov 2025 12:51:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4D2A78E0002
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 12:51:32 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0D15B12BDC8
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 17:51:32 +0000 (UTC)
X-FDA: 84073666824.20.98E2FF0
Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	by imf17.hostedemail.com (Postfix) with ESMTP id 17FA34000F
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 17:51:29 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=hjcLhq5b;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf17.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.218.42 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762278690;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9ECnLhPR8GCoIFxiWZs/Z7qt0UeuPLBFqpl/8chixW0=;
	b=qUsqClMx3vJHTxyv9NSNak5hvd+g2fWxw7Lt2H+CB2ZzfzWhtaHz7EGO18LRAtaXspCLwG
	MURQ/VhNQc6TZUwXtmJPyePwWG8OVFY7KzVPkwKHlR9zowfnjGakwV1aFnJQ6LmlPP05TP
	QVTVSj3EJK0vs5zB0/bKwaa3BKb8zoA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762278690; a=rsa-sha256;
	cv=none;
	b=jXX4H0jTvK0MPY4BMCcSOaEC3peH7qOI7fwn+I1bZ4EkT8se8aBr7WRVpOyh/jr25b47jS
	S/yN1NoDjBFZCPyMzpdy9Mn6RMH9emmWLZ7IB0HXBXO6uMkm5e6AZXYpoq4AuO8PtOlyIh
	tMvTp8Qv/+2GZmcVHm8gnuLChuTpi/8=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=hjcLhq5b;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf17.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.218.42 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-b50206773adso14438766b.0
        for <linux-mm@kvack.org>; Tue, 04 Nov 2025 09:51:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1762278688; x=1762883488; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9ECnLhPR8GCoIFxiWZs/Z7qt0UeuPLBFqpl/8chixW0=;
        b=hjcLhq5bT4IcqJiea1ZFtQqUN26ygWWz5hkVV5mggsK69c2Ofj4T078hg4zp0nYXZx
         cOo3OigEOTVX4eTJ+OqHZ2jLn68nVjMKCf2CoYakiudEHtfyMrKxzQG/5DYH+yTBinBy
         6DP66JC3D+bTC3zDXTL9BC3W28z2dOt9snhZVJNUqUKJlANdin10WDqjAmD5lCaYqHLk
         uORWHhd/sE/ubxtMtq5OgeR5ymstBzz2A24VoO9NSeNIvN6nATgeK/ripzELNwshemwE
         /rh0tq+uvfmagmtb6CSm9AM/p1XkWHpC20MT452aON2IRM6HuG55B4znxqVnYCQ6rFpp
         iw4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762278688; x=1762883488;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9ECnLhPR8GCoIFxiWZs/Z7qt0UeuPLBFqpl/8chixW0=;
        b=ump0KDxLObxP9YOwjDz5EgYAHE0lAPF2SV0EoLPcKTarL+P2cjd9FZJvOuFLF7ZXlN
         TSDcbHL/DajHE+uiROjFVPY8fzO1PLyrQGjRzup/CIi70v253h/X9W+YJpTaMTpsH8ui
         Cc5gVCKmnFPzR5nolVY9RzdeBhJiuJQleq1LA7bmPWuiB2HLmoO7V2Zo/rF8TvqRs2oh
         DqLvVsWoBfAnCFnKr9EPMqgAxGLIxAyc5OvKaXBy5UvB9/Go9MBTDs/PbVPeBR4Ufne1
         BNwOA5w23eag6IxADUB3tsFYDG8l5skDOArxmA4JzxEdkOX4zId7LoIJ4ve0qGEddO40
         xMgw==
X-Forwarded-Encrypted: i=1; AJvYcCV5bwCcehJ1qeWEERZjsUOrXoFUIY4N1krb4W81GvPOEY3EDdWQJIKIqAZW7Cl7d3sedIr86tw1mw==@kvack.org
X-Gm-Message-State: AOJu0YxJx4KM6pyWj5bve7o5DKtncIYPba9dKC0Of7acFg0hPWT+ZsPD
	iIZN2xliGx6NUM0DIWrS6mzXERGE3GypY7Y6n8GUsGtAc5tnZ1BAxV9THl8WC3nke1gsCxXdj3R
	ZpOm6O3/trJYbjqCXxMuUBhnxY91yri0n1gIx17LQbhQzI5mCO02YjqnnKA==
X-Gm-Gg: ASbGncsq44UIvGSo6sB2nLqlkz5IEMn5fhk8kn3NugLyhE4/NJfeRPD6UYDCetG3lW0
	Y13qs1VYwkNNJcaKN6YMAFJNKDeEeUdkzVaZjk5VUipaj7U54FkYc4KdUlbNHorEeO4tSzNQZ1q
	OjVlXz118LZ6M1nCvAUF1M4XzcQVOh9E5i1hLOKhAmfFSdUNitZpBYxoOrE7M7UiczCheUYbtdd
	PhUeyEQdTmuDvCR7DdE7PaINyGZGwU+/hrjn29Nz1nWJLhHHtJBC3SKWA==
X-Google-Smtp-Source: AGHT+IEAuECOBfJlEHfnlgCL4CsibRKTRNtnk3GFRgThyXrDwaD6V3R0XSyMkbHHy67fCRj/QzdxZGD1hNnwsDEv3Hs=
X-Received: by 2002:a17:907:26c3:b0:b70:83a2:3f5a with SMTP id
 a640c23a62f3a-b72138aaa11mr559213966b.0.1762278688472; Tue, 04 Nov 2025
 09:51:28 -0800 (PST)
MIME-Version: 1.0
References: <202511042251.paO6f5BZ-lkp@intel.com> <aQod7jDFBjw9T-u2@kernel.org>
 <CA+CK2bBYF5AndNHgqcb5zDbUOV04nE6xiZ0igcTdYf-GOU4aOQ@mail.gmail.com>
In-Reply-To: <CA+CK2bBYF5AndNHgqcb5zDbUOV04nE6xiZ0igcTdYf-GOU4aOQ@mail.gmail.com>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Tue, 4 Nov 2025 12:50:49 -0500
X-Gm-Features: AWmQ_bmyzYjklRdM4fCy26w5o6ihhFCSE_0V8f3fp0iGGrT9x2BXx4iNlGw-DMU
Message-ID: <CA+CK2bBnorfsTymKtv4rKvqGBHs=y=MjEMMRg_tE-RME6n-zUw@mail.gmail.com>
Subject: Re: [linux-next:master 4972/5926] kernel/kexec_handover_debug.c:16:18:
 error: use of undeclared identifier 'kho_scratch_cnt'
To: Mike Rapoport <rppt@kernel.org>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev, 
	Andrew Morton <akpm@linux-foundation.org>, 
	Linux Memory Management List <linux-mm@kvack.org>, kernel test robot <lkp@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: sibo15c5zqcy716munsy3puf1fj7t3sh
X-Rspam-User: 
X-Rspamd-Queue-Id: 17FA34000F
X-Rspamd-Server: rspam10
X-HE-Tag: 1762278689-609496
X-HE-Meta: U2FsdGVkX1+MfK5RZbjdtXR6xlusXOP2fcmG0FCSMZBbF2srPffjQiibil7ul/bLTyvd8KAqKo7dJYJlD/rhDVTBPwGPCmAaMoYYBJzPx1SULohEzUNwBi3P8wHskrsuY9phMy5ZfU/5V2vlBeM1TT+RsV6ZwZ7QwRwTeGIbJcRm7YJNOocbY1TgMxN7G4zv9KL3pJV6N9lg2073FvgGRwBdd7+aOkEYameK01KqJf0jRCbuHH+orA1BB9/kCTw3zeoKJAgdfVfyj/0Tg0lujzIxLs8GCTne2ONckqgnPo4hIxMRA48hGRUED9jaTxPEpciYFbkE1KeXvxzMjChYcbTYjzzy+QmjMuaVSrihIvqLec7LWkL5kId0jD+wS41rZsYFGsmksGyZJ3eCdz64HYdontglJzvADUGqlBOmoUS6qFDi/CzMuunztujjXxKcT7FmoHgKAfu25x7O2L49H09Sfah85XKt2GqBIk6Bn0S33mMqRttjyPSdC2QwMbjFgQbgEpBxdLusxgOUaDRoRshXd81qdi1/v2nt3pSCFuQZJpOYBlkePoeWB2eC10V1C3oSarXCO4G7+gqzoCtiUnNWpz2GI/Gy8VoXqTDzW2pLr2cR/yrmOHwKvaEwJSJ3Io6s5R7f0pHYgeTWidXenah112EU7YO+FcuAeAADURpLrYRtobwfvDfkOe2SfcjGLtL+FzuUtENBWL9D+X7SFeN8MuXXdTrHIEYwZ/hjaK7UGW0MCfJulYRSktX8xHnxZiJhvS2sQzDukdIQ4dWwP5zPzT+3jZKwXjQu7re+KrI3H//QOIGBlLh19T7l/RKqBTiSnlUoeD/eXkUeSo4dUY2o8p/38huaE8Rpys5VmB5FWyggEzumsrPLQgin1jKjLzKp+Vpmp/4Q6CeWruYni93BCfSMhO9xM7lmFMOx/s3100EXxb5g96XF5y63T7yflDpa8tC4zomLqdB2OYl
 gxX5zg11
 mwBossfIt/CSgGPrMESKSdRu8+eYQJlP9/0CWG0StYGucIcYiuC9KKW1Ze7Phfwtc4FPX2DJUtkc45gnVKp5OS/6Hmg/5ja7iHhV0s78IcOoq9GacMIHAXoAF0ckpWWvXt5+54ERZIEtc4Wpkspva972uU2UEvy0YDe9tR+Jd2HfLVYUFqiyZqe4g7MHKmt6w/blbjMYba380J/TCc17iU7lakMyHDrtxB/18mzePW3sdInsH9JWjrCTc8jtQxZeZ9dW5jeLmZmQ4TKr/20pQ7exsS8J4My/jKtk5ZefF3rrElmLWJZPv06HkVbp5BFC8IvLpGCjxJQYMdg/CyRSiStUizqm0Hm9YJ534vXZIAEZaMYF1FoSk3+dWzJTH8/R52ZvKlrTZsL+FN4110SXt4VNNKMYDv07kM9qSgYdRfATbiMQnjj7EJwLCmqFYKo9bjtvu
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The fix looks like this:
diff --git a/kernel/kexec_handover.c b/kernel/kexec_handover.c
index de4466b47455..2a8c20c238a8 100644
--- a/kernel/kexec_handover.c
+++ b/kernel/kexec_handover.c
@@ -477,8 +477,8 @@ static void __init kho_mem_deserialize(const void *fdt)
  * area for early allocations that happen before page allocator is
  * initialized.
  */
-static struct kho_scratch *kho_scratch;
-static unsigned int kho_scratch_cnt;
+struct kho_scratch *kho_scratch;
+unsigned int kho_scratch_cnt;

 /*
  * The scratch areas are scaled by default as percent of memory allocated =
from
diff --git a/kernel/kexec_handover_internal.h b/kernel/kexec_handover_inter=
nal.h
index 05e9720ba7b9..3c3c7148ceed 100644
--- a/kernel/kexec_handover_internal.h
+++ b/kernel/kexec_handover_internal.h
@@ -2,8 +2,12 @@
 #ifndef LINUX_KEXEC_HANDOVER_INTERNAL_H
 #define LINUX_KEXEC_HANDOVER_INTERNAL_H

+#include <linux/kexec_handover.h>
 #include <linux/types.h>

+extern struct kho_scratch *kho_scratch;
+extern unsigned int kho_scratch_cnt;
+
 #ifdef CONFIG_KEXEC_HANDOVER_DEBUG
 bool kho_scratch_overlap(phys_addr_t phys, size_t size);
 #else

Andrew, Mike, do you want me to resend the "[PATCH v3 0/3] KHO: kfence
+ KHO memory corruption fix" series with the fix included?

On Tue, Nov 4, 2025 at 12:32=E2=80=AFPM Pasha Tatashin
<pasha.tatashin@soleen.com> wrote:
>
> Eh, "kho: make debugfs interface optional" makes this variable external.
>
> Let me see how to fix this quickly.
>
> On Tue, Nov 4, 2025 at 10:38=E2=80=AFAM Mike Rapoport <rppt@kernel.org> w=
rote:
> >
> > (adding Pasha)
> >
> > On Tue, Nov 04, 2025 at 10:48:31PM +0800, kernel test robot wrote:
> > > Hi Mike,
> > >
> > > First bad commit (maybe !=3D root cause):
> > >
> > > tree:   https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-ne=
xt.git master
> > > head:   17490bd0527f59d841168457b245581f314b5fa0
> > > commit: 8c211175c3abcebb8bffce8095d78d193e482105 [4972/5926] liveupda=
te-kho-warn-and-fail-on-metadata-or-preserved-memory-in-scratch-area-fix
> > > config: x86_64-randconfig-071-20251104 (https://download.01.org/0day-=
ci/archive/20251104/202511042251.paO6f5BZ-lkp@intel.com/config)
> > > compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project =
87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
> > > reproduce (this is a W=3D1 build): (https://download.01.org/0day-ci/a=
rchive/20251104/202511042251.paO6f5BZ-lkp@intel.com/reproduce)
> > >
> > > If you fix the issue in a separate patch/commit (i.e. not just a new =
version of
> > > the same patch/commit), kindly add following tags
> > > | Reported-by: kernel test robot <lkp@intel.com>
> > > | Closes: https://lore.kernel.org/oe-kbuild-all/202511042251.paO6f5BZ=
-lkp@intel.com/
> > >
> > > All errors (new ones prefixed by >>):
> > >
> > > >> kernel/kexec_handover_debug.c:16:18: error: use of undeclared iden=
tifier 'kho_scratch_cnt'
> > >       16 |         for (i =3D 0; i < kho_scratch_cnt; i++) {
> > >          |                         ^
> > > >> kernel/kexec_handover_debug.c:17:19: error: use of undeclared iden=
tifier 'kho_scratch'
> > >       17 |                 scratch_start =3D kho_scratch[i].addr;
> > >          |                                 ^
> > >    kernel/kexec_handover_debug.c:18:17: error: use of undeclared iden=
tifier 'kho_scratch'
> > >       18 |                 scratch_end =3D kho_scratch[i].addr + kho_=
scratch[i].size;
> > >          |                               ^
> > >    kernel/kexec_handover_debug.c:18:39: error: use of undeclared iden=
tifier 'kho_scratch'
> > >       18 |                 scratch_end =3D kho_scratch[i].addr + kho_=
scratch[i].size;
> > >          |                                                     ^
> > >    4 errors generated.
> > >
> > >
> > > vim +/kho_scratch_cnt +16 kernel/kexec_handover_debug.c
> > >
> > > 4039a00022d42a Pasha Tatashin 2025-10-20  10
> > > 4039a00022d42a Pasha Tatashin 2025-10-20  11  bool kho_scratch_overla=
p(phys_addr_t phys, size_t size)
> > > 4039a00022d42a Pasha Tatashin 2025-10-20  12  {
> > > 4039a00022d42a Pasha Tatashin 2025-10-20  13          phys_addr_t scr=
atch_start, scratch_end;
> > > 4039a00022d42a Pasha Tatashin 2025-10-20  14          unsigned int i;
> > > 4039a00022d42a Pasha Tatashin 2025-10-20  15
> > > 4039a00022d42a Pasha Tatashin 2025-10-20 @16          for (i =3D 0; i=
 < kho_scratch_cnt; i++) {
> > > 4039a00022d42a Pasha Tatashin 2025-10-20 @17                  scratch=
_start =3D kho_scratch[i].addr;
> > >
> > > :::::: The code at line 16 was first introduced by commit
> > > :::::: 4039a00022d42ac3d68b2eea63066bc9f7ef89ce kho: warn and fail on=
 metadata or preserved memory in scratch area
> > >
> > > :::::: TO: Pasha Tatashin <pasha.tatashin@soleen.com>
> > > :::::: CC: Andrew Morton <akpm@linux-foundation.org>
> > >
> > > --
> > > 0-DAY CI Kernel Test Service
> > > https://github.com/intel/lkp-tests/wiki
> >
> > --
> > Sincerely yours,
> > Mike.

