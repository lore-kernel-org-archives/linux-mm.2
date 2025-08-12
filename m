Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DD12CA0EDB
	for <linux-mm@archiver.kernel.org>; Tue, 12 Aug 2025 18:37:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1F02E8E0187; Tue, 12 Aug 2025 14:37:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1C84C8E0151; Tue, 12 Aug 2025 14:37:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0DF928E0187; Tue, 12 Aug 2025 14:37:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id EEC6E8E0151
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 14:37:30 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7A2D280C41
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 18:37:30 +0000 (UTC)
X-FDA: 83768963460.01.3173125
Received: from outpost1.zedat.fu-berlin.de (outpost1.zedat.fu-berlin.de [130.133.4.66])
	by imf21.hostedemail.com (Postfix) with ESMTP id 968311C0011
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 18:37:28 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=fu-berlin.de header.s=fub01 header.b=YWfd335d;
	dmarc=pass (policy=none) header.from=fu-berlin.de;
	spf=pass (imf21.hostedemail.com: domain of glaubitz@zedat.fu-berlin.de designates 130.133.4.66 as permitted sender) smtp.mailfrom=glaubitz@zedat.fu-berlin.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755023848; a=rsa-sha256;
	cv=none;
	b=pRBrHL0IqAZza8P7HBZj+386VdJJWJt6erWE/yl+Lz4iSy0WT3yU4F8vqZJQr35RHJpPlt
	4UfvXCDK1u0XEl6kIfO7P2mEBD3rPCDiI7nv3HfyoMlnGhI2JDX3DhZgOh7lsqWmkqCc7g
	/OROL/9dCB2opPUa6pS9XSP2Fcoezks=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=fu-berlin.de header.s=fub01 header.b=YWfd335d;
	dmarc=pass (policy=none) header.from=fu-berlin.de;
	spf=pass (imf21.hostedemail.com: domain of glaubitz@zedat.fu-berlin.de designates 130.133.4.66 as permitted sender) smtp.mailfrom=glaubitz@zedat.fu-berlin.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755023848;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tCXf5eAPOEB1mU7Sfj6ozuynE635YDXwwF3ucaUJytk=;
	b=oJt/tCtY5gdM4JF2tNkk007T8lDMIEljLZ0Y9EiJC/luQCN8g4gyteu3V1HUe0deES/N41
	/qavij/SXJTt4k4vzRo1fxxrx+ysR/DIQR8OGmtIps/P0bPVJlyGoA0hj3Lwl1iZlV2N3L
	WPB8vF1kFchZV5Jxprb79Qu9trvI0DY=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=fu-berlin.de; s=fub01; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:From:
	Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
	Content-Transfer-Encoding:Content-ID:Content-Description:In-Reply-To:
	References; bh=tCXf5eAPOEB1mU7Sfj6ozuynE635YDXwwF3ucaUJytk=; t=1755023848;
	x=1755628648; b=YWfd335dUoLUY9pwnVKfHEJDLHz76iDOEVEOM5Dmd8fmauyigWh5FlAFEqxiy
	RI+nGIkZoF5wGfpkov686zReVB+NBRTCzhQBoxaanQ5asg8R7g8DFJuX5ShLMkp6ornjb479aiwAi
	4OC4X+qrCR32PZrKcf2Spo5QxbL/92WpFO+aJEhw2fu8Zbb5uIkCZzXrOyfudua7plSPJJ2GPVYRw
	Ic1Tn4MedWWhWa0YYVOGeeuFQ7jvHic3d/G5Ug0k5t/kBA+FSeCVnbZb0vrIrWNAE/BhXu4ZzHByf
	Cz9jJvIqddEY1Cgp1S1kNk6V9d9Qd6MUKSypHn0BaQG+03Uneg==;
Received: from inpost2.zedat.fu-berlin.de ([130.133.4.69])
          by outpost.zedat.fu-berlin.de (Exim 4.98)
          with esmtps (TLS1.3)
          tls TLS_AES_256_GCM_SHA384
          (envelope-from <glaubitz@zedat.fu-berlin.de>)
          id 1ults4-00000001ygC-2Asi; Tue, 12 Aug 2025 20:37:16 +0200
Received: from p57bd96d0.dip0.t-ipconnect.de ([87.189.150.208] helo=[192.168.178.61])
          by inpost2.zedat.fu-berlin.de (Exim 4.98)
          with esmtpsa (TLS1.3)
          tls TLS_AES_256_GCM_SHA384
          (envelope-from <glaubitz@physik.fu-berlin.de>)
          id 1ults4-00000003t27-0yiV; Tue, 12 Aug 2025 20:37:16 +0200
Message-ID: <49b112b80b211ae05b5f3c36a55f67041783f51e.camel@physik.fu-berlin.de>
Subject: Re: [PATCH v5 18/23] bpf: Use vmalloc special flag
From: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, "peterz@infradead.org"
	 <peterz@infradead.org>, "mingo@redhat.com" <mingo@redhat.com>, 
 "luto@kernel.org"
	 <luto@kernel.org>, "bp@alien8.de" <bp@alien8.de>
Cc: "sam@gentoo.org" <sam@gentoo.org>, "andreas@gaisler.com"	
 <andreas@gaisler.com>, "nadav.amit@gmail.com" <nadav.amit@gmail.com>, 
 "dave.hansen@linux.intel.com"	 <dave.hansen@linux.intel.com>,
 "anthony.yznaga@oracle.com"	 <anthony.yznaga@oracle.com>,
 "akpm@linux-foundation.org"	 <akpm@linux-foundation.org>,
 "linux-kernel@vger.kernel.org"	 <linux-kernel@vger.kernel.org>,
 "will.deacon@arm.com" <will.deacon@arm.com>,  "linux_dti@icloud.com"	
 <linux_dti@icloud.com>, "deneen.t.dock@intel.com"
 <deneen.t.dock@intel.com>,  "linux-mm@kvack.org"	 <linux-mm@kvack.org>,
 "tglx@linutronix.de" <tglx@linutronix.de>, 
 "linux-security-module@vger.kernel.org"	
 <linux-security-module@vger.kernel.org>, "sparclinux@vger.kernel.org"	
 <sparclinux@vger.kernel.org>, "hpa@zytor.com" <hpa@zytor.com>, 
 "linux-integrity@vger.kernel.org"	 <linux-integrity@vger.kernel.org>,
 "daniel@iogearbox.net" <daniel@iogearbox.net>, 
 "kernel-hardening@lists.openwall.com"	
 <kernel-hardening@lists.openwall.com>, "ast@kernel.org" <ast@kernel.org>, 
 "x86@kernel.org"	 <x86@kernel.org>, "kristen@linux.intel.com"
 <kristen@linux.intel.com>
Date: Tue, 12 Aug 2025 20:37:15 +0200
In-Reply-To: <1738e24239cc0c001245fdd4bd3811175c573ce2.camel@intel.com>
References: <20190426001143.4983-1-namit@vmware.com>
		 <20190426001143.4983-19-namit@vmware.com>
		 <14437e403ed8fceacafe0a89521d3b731211156e.camel@physik.fu-berlin.de>
	 <1738e24239cc0c001245fdd4bd3811175c573ce2.camel@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2 
MIME-Version: 1.0
X-Original-Sender: glaubitz@physik.fu-berlin.de
X-Originating-IP: 87.189.150.208
X-ZEDAT-Hint: PO
X-Stat-Signature: adwwnan1biwxm4zbnehn7anmpb5i3ehd
X-Rspam-User: 
X-Rspamd-Queue-Id: 968311C0011
X-Rspamd-Server: rspam02
X-HE-Tag: 1755023848-615162
X-HE-Meta: U2FsdGVkX182mkcdCGMc1hq58bgUvvYVvkcvKuzt0q4MKGbdeNKJ1bNlJwNxQG8zoZ+kgRYqClk0UdSzLQBrhZO1N+pF7Zbr3NGh+YrKryB9ne3/s4stRrnfMV/owSauqcg9x+L6w3ouNDHlXey089qCqVw2DD87PR7ijY7/g8B/uHgDswhDI4c4Vrb1Hsb01ZIG8K09nNn2F3Q1Af2Qmp6HLw79DoOMLQNZmiBirk9aP4xSfDFLSZjIImRuCQA/HDtkZ4E3Jy6lLdJCD9H7Wu+F1bqllB6FD6URhT5rKT12oNKFXxOguiab9lKbgt5ufBzMdXGy32oHRYyXWrg0fcUcYW0AdaMkqrFPwjEX2bnuWa2MyymyKTJ2434kYp6CQMrwQXxpuAjQ81/2mIQX09P0z4A/8U+LuVp/6Rr8aykxiERGQVA1J2Umg7jPvDjpnCWmyemkyKGm9/I+tiH41i4/F/XItNXgvWdPty6Scg8dC9a5p2hl3U9kvdfOsJoOmndqXR0Pzbad4XwgcteAvkkd6XVOXewCECI+4OjVb0qrEFzQ7tupq+Dnoq3czJ4tFsayuAFdKWaXIYX43dEL1KcRFyq0VMZh/zgdb1jKaImbNTes4J++atLU1b3HF1pP1d/4VgbRqYBoi87JO3iyA9RmkHdh0OoJu1zCO+iq71+xrXtM8IAdaHiH29d+JYpykros+SnhoY7MqPFYYrustG7qFJbeJLQbBbOBlufQi4D1Kb7yRHRgxGbW4UIIedLUSydbmt9YcJHVwoWxbWjqN2/9VbCexHOiewoR/W5gN2ar7+IaawDu8/mxRX8BD+FgR2cE99LW83c97kl1+0GkS1NBBi8L2elnAR4tMELpr4MNJw3r0cne0m2eLNmKOXeEMkQZGepkHl/h7SpnYTNfd+G083D7/viOKrfYJ5il7jA11FiT5nKl0qw8nPra2PEg0I0zicHTKF/E1Qra0zG
 ehYcEgH8
 qenyOoR/kgAXzMGAzx5VHAsgHV9TiA5bCDMtfTXzwDHO4aaTdK+RodYqxbNj5gyd2hObEJyt4DWhFO/+C4HskmkNPjhCXdmkFjA8HJ7XIySepfCXZlnf/XNs7YBfxHxJocqni624YBbok8V8kMGVn9VN4cq/opGbxI3QJnTWlYOGMaVm68ypYuc9OuHBUt45nZGXauAvFWdGHOHzzNJFAUBJzoLtTfh4ih0H5wQxgxhUQ2FdlIXc3F+nXcnN7Jt6K+4eOR8cx/MBGiLMugeVcObb4m3w9anhN61Gi
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

On Tue, 2025-08-12 at 18:03 +0000, Edgecombe, Rick P wrote:
> On Tue, 2025-08-12 at 18:43 +0200, John Paul Adrian Glaubitz wrote:
> > I suspect that the main issue is to be found in the following patch whi=
ch introduced VM_FLUSH_RESET_PERMS
> > which may not work as expected on sun4u SPARC systems:
>=20
> I think the problem we found with VM_FLUSH_RESET_PERMS was that the sparc=
64
> kernel TLB flush implementation was broken. Since VM_FLUSH_RESET_PERMS ca=
used
> kernel TLB flushes to happen sooner, it just showed up sooner. [0]=20
>=20
> This other issue seems to be about userspace memory. So I wonder if these=
 are
> two separate issues? Bisecting to the original VM_FLUSH_RESET_PERMS would=
 have
> had the known sparc kernel range TLB flush issue. So to bisect the other =
issue
> you might need to apply this [1].

That could be true. I knew about the patch in [1] but I didn't think of app=
lying it.

FWIW, the crashes we're seeing on recent kernel versions look like this:

[   40.992851]               \|/ ____ \|/
[   40.992851]               "@'/ .. \`@"
[   40.992851]               /_| \__/ |_\
[   40.992851]                  \__U_/
[   41.186220] (udev-worker)(88): Kernel illegal instruction [#1]
[   41.262910] CPU: 0 UID: 0 PID: 88 Comm: (udev-worker) Tainted: G        =
W          6.12.0+ #25
[   41.376151] Tainted: [W]=3DWARN
[   41.415025] TSTATE: 0000004411001607 TPC: 00000000101c21c0 TNPC: 0000000=
0101c21c4 Y: 00000000    Tainted: G        W        =20
[   41.563717] TPC: <ehci_init_driver+0x0/0x160 [ehci_hcd]>
[   41.633584] g0: 00000000012005b8 g1: 00000000100a1800 g2: 00000000102060=
00 g3: 00000000101de000
[   41.747962] g4: fff000000a5af380 g5: 0000000000000000 g6: fff000000aac80=
00 g7: 0000000000000e7b
[   41.862338] o0: 0000000010060118 o1: 000000001020a000 o2: fff000000aa30c=
e0 o3: 0000000000000e7a
[   41.976728] o4: 00000000ff000000 o5: 00ff000000000000 sp: fff000000aacb0=
91 ret_pc: 00000000101de028
[   42.095768] RPC: <ehci_pci_init+0x28/0x2000 [ehci_pci]>
[   42.164394] l0: 0000000000000000 l1: 0000000100043fff l2: ffffffffff8000=
00 l3: 0000000000800000
[   42.278768] l4: fff00000001c8008 l5: 0000000000000000 l6: 00000000013358=
e0 l7: 0000000001002800
[   42.393143] i0: ffffffffffffffed i1: 00000000004db8d8 i2: 00000000000000=
00 i3: fff000000aa304e0
[   42.507517] i4: 0000000001127250 i5: 0000000010060000 i6: fff000000aacb1=
41 i7: 0000000000427d90
[   42.621893] I7: <do_one_initcall+0x30/0x200>
[   42.677931] Call Trace:
[   42.709953] [<0000000000427d90>] do_one_initcall+0x30/0x200
[   42.783158] [<00000000004db908>] do_init_module+0x48/0x240
[   42.855214] [<00000000004dd82c>] load_module+0x19cc/0x1f20
[   42.927270] [<00000000004ddf8c>] init_module_from_file+0x6c/0xa0
[   43.006189] [<00000000004de1e4>] sys_finit_module+0x1c4/0x2c0
[   43.081677] [<0000000000406174>] linux_sparc_syscall+0x34/0x44
[   43.158307] Disabling lock debugging due to kernel taint
[   43.228077] Caller[0000000000427d90]: do_one_initcall+0x30/0x200
[   43.306995] Caller[00000000004db908]: do_init_module+0x48/0x240
[   43.384772] Caller[00000000004dd82c]: load_module+0x19cc/0x1f20
[   43.462544] Caller[00000000004ddf8c]: init_module_from_file+0x6c/0xa0
[   43.547184] Caller[00000000004de1e4]: sys_finit_module+0x1c4/0x2c0
[   43.628389] Caller[0000000000406174]: linux_sparc_syscall+0x34/0x44
[   43.710741] Caller[fff000010480e2fc]: 0xfff000010480e2fc
[   43.780508] Instruction DUMP:
[   43.780511]  00000000=20
[   43.819394]  00000000=20
[   43.850273]  00000000=20
[   43.881153] <00000000>
[   43.912036]  00000000=20
[   43.942917]  00000000=20
[   43.973797]  00000000=20
[   44.004678]  00000000=20
[   44.035561]  00000000=20
[   44.066443]

Do you have any suggestion what to bisect?

Adrian

--=20
 .''`.  John Paul Adrian Glaubitz
: :' :  Debian Developer
`. `'   Physicist
  `-    GPG: 62FF 8A75 84E0 2956 9546  0006 7426 3B37 F5B5 F913

