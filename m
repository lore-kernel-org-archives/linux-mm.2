Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 83760C79FB7
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 19:28:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 270ED6B008A; Wed,  9 Sep 2026 15:28:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 248566B008C; Wed,  9 Sep 2026 15:28:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1381A6B0092; Wed,  9 Sep 2026 15:28:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DAB346B008A
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 15:28:52 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 62086802FB
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 19:28:52 +0000 (UTC)
X-FDA: 85195211304.08.56A551E
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	by imf27.hostedemail.com (Postfix) with ESMTP id 3D9354000D
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 19:28:50 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=zytor.com header.s=2026082801 header.b=KGmenuJ4;
	spf=pass (imf27.hostedemail.com: domain of hpa@zytor.com designates 198.137.202.136 as permitted sender) smtp.mailfrom=hpa@zytor.com;
	dmarc=pass (policy=none) header.from=zytor.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788982130;
	b=hmvzrjfrYcBrtUhlyVF9FDJE4gIB1suJYvfKUW4C1emlMjn/iP4MfIwQjKDlYuWhuIPRfz
	Rb8loeamnNX29NG/QkOKTUWhLLdwUMvs4uhJ5iGUXeoAzDcv47TuHYpDixxYdfZCR8cYef
	TgMFt+95g+xOD+cfH+hliOMuRC3bN40=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=zytor.com header.s=2026082801 header.b=KGmenuJ4;
	spf=pass (imf27.hostedemail.com: domain of hpa@zytor.com designates 198.137.202.136 as permitted sender) smtp.mailfrom=hpa@zytor.com;
	dmarc=pass (policy=none) header.from=zytor.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788982130;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dm9wpz4h++ofzecnaqGunBw1Zr0gciiuIEIuRKgM8Ow=;
	b=ntnKVSX1WGiMwzTCDUQkofHiUwUfwkI683H0EDNjyCWw9mMynmewn1yeHBs7lAXIMHKq7p
	zSEAcC687TTWOhT/n7qqE2JuPmVVDrcMHnKQ8dAgJRCvPkoqwx110IKGOCwmsDhOxLgqeY
	IS6tdc2IOmlDTB3F91kCI0h9CU3k6Fk=
Received: from ehlo.thunderbird.net ([172.59.162.201])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 689JRcBm234939
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
	Wed, 9 Sep 2026 12:27:39 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 689JRcBm234939
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2026082801; t=1788982063;
	bh=dm9wpz4h++ofzecnaqGunBw1Zr0gciiuIEIuRKgM8Ow=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:From;
	b=KGmenuJ4WDEIJmD1OjtLBCTBIwmOPf5WXdqCO5NhxzNk/PRMxxRdYtCQ/e9LiQrbV
	 5nqhJq3gZmxqektEkouPM43IJ+O+eLEDDnkzku4OU8RnhJdWNoOzbcM86CqUSS8cda
	 TGHj1Sj2JK1rzrE8/0GlItXDBmcjxoplXEs2uNG488VNDWTtxr1RHdwo+/ZC/5FRv+
	 Wy6lT+Qfy6Lh4xU4ePky/daoK1IUOfrPNaz0BFP5rM0ouPsB86TVM+rt/GpXFp601e
	 VoZGbeqZhFA9YU7x21eyffmZrBwUa7PfRZVyvemk05/BdqUB6bb3V5JxF/PsdotOYc
	 tTrjTgSh5/hig==
Date: Wed, 09 Sep 2026 12:27:30 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
To: Borislav Petkov <bp@alien8.de>,
        =?ISO-8859-1?Q?Thomas_Wei=DFschuh?= <thomas.weissschuh@linutronix.de>
CC: Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>,
        Alexandre Ghiti <alex@ghiti.fr>, Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
        Bill Wendling <morbo@google.com>,
        Justin Stitt <justinstitt@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        Kees Cook <kees@kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        Richard Weinberger <richard@nod.at>,
        Anton Ivanov <anton.ivanov@cambridgegreys.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Russell King <linux@armlinux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Madhavan Srinivasan <maddy@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Nicholas Piggin <npiggin@gmail.com>,
        Huacai Chen <chenhuacai@kernel.org>, WANG Xuerui <kernel@xen0n.name>,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>,
        Gary Guo <gary@garyguo.net>,
        =?ISO-8859-1?Q?Bj=F6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>,
        Benno Lossin <lossin@kernel.org>,
        Andreas Hindborg <a.hindborg@kernel.org>,
        Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>,
        Danilo Krummrich <dakr@kernel.org>, Thomas Gleixner <tglx@kernel.org>,
        Christophe Leroy <chleroy@kernel.org>, Boqun Feng <boqun@kernel.org>,
        Nicolas Schier <nsc@kernel.org>, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org, llvm@lists.linux.dev, linux-mm@kvack.org,
        linux-um@lists.infradead.org, linux-arm-kernel@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org, loongarch@lists.linux.dev,
        linux-s390@vger.kernel.org, linux-mips@vger.kernel.org,
        rust-for-linux@vger.kernel.org, linux-kbuild@vger.kernel.org,
        Jan Stancek <jstancek@redhat.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Alexandre Ghiti <alexghiti@rivosinc.com>
Subject: =?US-ASCII?Q?Re=3A_=5BPATCH_v5_02/24=5D_x86/elf=2C_um/x86/?=
 =?US-ASCII?Q?elf=3A_Move_relocation_constants_to_UAPI?=
User-Agent: K-9 Mail for Android
In-Reply-To: <20260909144930.GAaqFx-mjH3-u6jLjw@fat_crate.local>
References: <20260908-vdso-absolute-reloc-v5-0-3a93791af1cf@linutronix.de> <20260908-vdso-absolute-reloc-v5-2-3a93791af1cf@linutronix.de> <20260908135513.GAaqATwXHcQD7plnH-@fat_crate.local> <20260908161740-0d79e592-87a6-43c5-9174-84ce1904e639@linutronix.de> <20260908151238.GBaqAl5iKb64meuPJl@fat_crate.local> <20260909075156-06ff671c-ab7b-47d8-aaa3-588b570888bc@linutronix.de> <20260909144930.GAaqFx-mjH3-u6jLjw@fat_crate.local>
Message-ID: <F9786718-8378-443D-A21E-77E057B62BB2@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 3D9354000D
X-Stat-Signature: oz8kpwe98jtjazwixuaz1om488w36qfy
X-HE-Tag: 1788982130-606242
X-HE-Meta: U2FsdGVkX1/izYX83XCLZLo+RMfUcJ7oOA8Ah6//SMlTf9KY/mblCtenzyR+kvo9npoZJamcdg0Ta6w3bx4k6I+RHt3wp1UJg4j52hVHZuF6jH+vf+QjkAeKEADnwWsv9T0P+JJPIOK62F6U1a4IhplBZjxcYvIMWjgaoitWtSKzNAErp4vHKNuyESVv0X852HgGbEYc2mvf44+fmEdLOjURrBO1BiTQ8mtlidj7R+CeatDNzXAWXxWrFXm/HEDWrKI1wbq39/G7Gnv5K9Y4LVR1M7bpfm0DK5GIfAssXIMGAIwC9rh6ibfoZccd+wxQkAxRzHu29xBro9kf8tS48dnoyuLEwDQkhU/vCIo56JP7GhP2Py8n25qAGaGpYkndfBN3BsJgBfvaWDFvscZvwUMeufB8XcI9j1LwBvslz4x8v7LOmGagsXDI//aH1hG4Fe8ohwGZn2/aN6Jtv3gQf4rhtiZaUIuFJIh1GaVSDfrY6dUPOas5QkkNUNQKHtlD+ECSnsmoYtUR9oeMlHaY1Kl2zq436oQSjSzPCMfDNra75MdZBATeGNOAJWWAnqqzVpIAlxboi/A+K9mXOVQ9xWwF17Whvj01iHgpp2Nxu/Qyr+JC7NIMt9oQ6GpXOWRB/h8RK+uVwf64mO8405mffNL0HjX8r8uxnGn7GXFp9fcIt0ygfrdQgXBxNjxTT6d9qTdFGnehZuyEnHpWk5vgXOEFW1zdIPR+qJqG1jf7mBQIaQ8xTZ3nqjq9dih7ZAi4z+ioycMMiE+W+bS3yFq7PKVD0Hf6xuchHJ6SJ1aenatn9N/lsGYqEs2rsBfjDR07ic6N6tZW0iYjFX8p6PMTBdb0XTgXr5O71O2fL8v5BwuRZ3Yb+glFBBYO0TDPm5E4pRIfAtQPUn+cNei/ZZoL3cUJJgJDdsGajPDyOCydlY2Kdnb4/PCj76KIXVRinLfvKeA6LlrgKS3ERSoHBz8
 eL77fH3z
 fa2mRiG2rx3M/FuRok+9u9UwC+qBYfkx5GroW3md2VmoIUo8zfMNqxw8+D4dJ5hsga8Z0sWCDcnmkIGG2lQVyj9ZQFuoj3ggY7GIkoqKZY4V2HRcbwvSz2CAG6bA/nE2XVxbxxznnn+s7Pu5TCCpXO0HXJ4Vu+3ulaRd7qu3cXl/mGYb1jvY02apMKmpqU4EdIdLZ6BpsbG/Je8qe2ma+9ixsNVa9g08vRIEgUKLqcT7Srd6yNrstv8kgIyuGaJeqUM1Qy1PYAA79ID1gKGbM9Xj7KWaeHm8KfShNiiDZX4uBvQixS2z+axYB3ScDbtvFmJSjLxUy069yPgqzxcFFSABn1LKy5+6+WtHdKklBOMV+eb738MBgfcXfO4g3Vs2krX6q3BZ4IogPWxsL9FznrogokCj0eJHIcxfb
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On September 9, 2026 7:49:30 AM PDT, Borislav Petkov <bp@alien8=2Ede> wrote=
:
>On Wed, Sep 09, 2026 at 07:59:51AM +0200, Thomas Wei=C3=9Fschuh wrote:
>> These names and numbers are defined by the architectures' ELF specifica=
tions=2E
>> They are already cast in stone=2E For example see Table 4=2E9 of [0]=2E
>> Changing them would break compilers, linkers, loaders and more or less =
every
>> existing ELF binary=2E
>
>So?
>
>Your goal is to provide them to tools/=2E You want to provide them to
>*everything*=2E See the discrepance here?
>
>> That is the documentation for the tools UAPI headers=2E
>
>Did you even read that file?
>
>"Why we want a copy of kernel headers in tools?
>=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
>There used to be no copies, with tools/ code using kernel headers
>directly=2E From time to time tools/perf/ broke due to legitimate kernel
>hacking=2E At some point Linus complained about such direct usage=2E Then=
 we
>adopted the current model=2E
>
>The way these headers are used in perf are not restricted to just
>including them to compile something=2E
>=2E=2E=2E"
>
>Just read the damn thing before you reply=2E
>
>> Also we already have other, closely related, ELF constants in the UAPI,
>> see {,tools/}include/uapi/linux/elf{,-em}=2Eh=2E
>
>Srsly?!?
>
>You moved them there:
>
>commit 626fd35278295fbb21f2da331cd8028e9738d965
>Author: Thomas Wei=C3=9Fschuh <thomas=2Eweissschuh@linutronix=2Ede>
>Date:   Wed Feb 26 12:44:46 2025 +0100
>
>    tools/include: Add uapi/linux/elf=2Eh
>   =20
>    It will be used by the vDSO selftests=2E
>
>
>Looking at the rest, it looks like some elf bits got exported, you added =
some
>more and that ship has sailed=2E I still think us providing headers is
>completely unnecessary and it will come to cause conflicts eventually but=
 hey,
>not my problem=2E
>

I do believe there are *some* headers that would be reasonably to export t=
o tools/ beyond what it is in uapi; a major reason for that is that the too=
ls are suffering from a crazy level of internal inconsistency right now=2E=
=20

Basically uapi =E2=8A=82 treewide =E2=8A=82 kernel, but also treewide =E2=
=8A=82 tools common =E2=8A=82 tool-specific=2E=2E=2E

