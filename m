Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7410CA0EC4
	for <linux-mm@archiver.kernel.org>; Tue, 12 Aug 2025 11:07:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2023F8E010F; Tue, 12 Aug 2025 07:07:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1AC268E00E5; Tue, 12 Aug 2025 07:07:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 09B028E010F; Tue, 12 Aug 2025 07:07:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E99528E00E5
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 07:07:50 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 769C2C0260
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 11:07:50 +0000 (UTC)
X-FDA: 83767830300.17.E17203B
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	by imf09.hostedemail.com (Postfix) with ESMTP id 87E07140009
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 11:07:48 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=k0odTsD8;
	spf=pass (imf09.hostedemail.com: domain of miguel.ojeda.sandonis@gmail.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=miguel.ojeda.sandonis@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754996868;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mM1oIijYsTieBVXwDdbk88e2RvtyWnf8BqoF2nILFwk=;
	b=LEqH9pzJxLUpvLIxz0S5K+V0FPbf0kzRrd+ZBWw8YRTduT5Uymap54VYSXmnKMer+2dgTY
	D+eBFf1vcDkB3NPDa6qbm3CdsGziGIQAL2mJZU0gEifn3yIE8b0vMCw9wQOkszKK2SRy8P
	piiAW6iNdRFP7TNk59shj2iNS/nyKL4=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=k0odTsD8;
	spf=pass (imf09.hostedemail.com: domain of miguel.ojeda.sandonis@gmail.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=miguel.ojeda.sandonis@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754996868; a=rsa-sha256;
	cv=none;
	b=05I4/4iuVkQF9FFKeDPFDRebppLRkcyBPEeYIEplEpPCyyJwti/bx/5cMRRqAxWs6P+LYK
	NA7G1CcyywFE230ADJAi7ENT37pPOMDkdj8tvz40L6pQ1L+owx7W9oou5ZzTczP4VmdfsR
	ZTW0BneIHcY75/KAI5QdX987p0g5gXs=
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-242fe140b7cso1111135ad.0
        for <linux-mm@kvack.org>; Tue, 12 Aug 2025 04:07:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754996867; x=1755601667; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mM1oIijYsTieBVXwDdbk88e2RvtyWnf8BqoF2nILFwk=;
        b=k0odTsD8UQs1lG1j5Rx/tXtSQphl+TfpOM5HCMVPSAXJjrILlEGZ+KnVNReDoD6ksG
         n6WdSx1GSVeT0scAIenx3J6/nl08sXUWIdxJBEGixIdbGN4v1wySIBwUHp76XYfR7sXt
         ToZBY8w7mCbMmKggc+ff6YFuMtKiGCMYDlFIqOLtgdJaxU4l7gXqLTOCMfHgejCSyT6v
         O25aukr8vBf0ZrraKZKkBevxoL+YYaiFj76B7YZHj6Q6Zvs9ZMfExbthUx+cTIRc66WP
         uD8Qbbsbf94N7HjE13j4CDyM4LRw9gXeJay42BaBnYs5QNgWqcbni+u+UKZMmySCTyL7
         Rkqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754996867; x=1755601667;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mM1oIijYsTieBVXwDdbk88e2RvtyWnf8BqoF2nILFwk=;
        b=OoqOGNHi2HNBQ4YC0ohOm/g1autHEB28b9rWwShrdVR0ckLhiBJ7iA4fPg2fYX9rdO
         93kejmaupeMGRkd1prUyTOO5rpaWDvx94bhmeU+is74zyqe0rXjuHqr+wyETkpglaM93
         M/zIhxoTZJkDhH0zQF30GNoG9A3FIlh3eTp2onBRNNt7kX2/XNq+60yBpvt+fu9omoD0
         yBkmAkLJZX9C6NlC8BG2dWDQwbu8BGXZVSa8TXDQfGfNjGe5kxWGiNoDcEYBNwKbJIHQ
         z6MmDuTmUAUvEhTxhsS5Dra/XnxkyoDh0c7w38GRfyPVxjHuMSBs4scSOIls4VmHNo5s
         JrFQ==
X-Forwarded-Encrypted: i=1; AJvYcCX9ZGuersVunwMr3LcQ3iOCetoGe06xZjcmQ60MwxF7Iw8V57gmxwpmm5Kh+AGGHyXYdPlnca3mlg==@kvack.org
X-Gm-Message-State: AOJu0Yz8hC+C5djwJZoCt9IKrttEUogPDuFkI4QABG7/sTClJi+mUiRN
	fV33IND8YnmUNaN/cOVESSOAM0La/IoK/ms7fU/6VRs8HN30MebAR71wg82/cXm+Mk02UZf3+R7
	zPme2Z5OHifI9CeLQiEYLll7eiCMfWuQ=
X-Gm-Gg: ASbGnct03AKpXFsGtBuqBiLGI78RJkzXQ8qFl/Tcv51Ct5nzIZ6RbVanQpZJZ88bRJS
	pUWyty4dbbbbOF0cQjjocJdORrsATD3Uj3edMSZZ6gNccVGHEzJqwXJRpk034pNmI/CqkLzNLPY
	oxkVeOH40nr2mDJcGfkeW0rfgvFxNrl1vQArFvfTUIyYm2KDFjVwuUMxabUASn1OrBntSCv10Ga
	oF/RQCgCuNEH2F1wiI=
X-Google-Smtp-Source: AGHT+IGLTgav5Ly0pJQ7DxONlyuqSGpB75/R07ZLvB4KvAdVZt2KEevtP/u+Z9PPdrxzblYTwfgzUXYmCR2PQbfj+a0=
X-Received: by 2002:a17:903:1a70:b0:240:5c13:979a with SMTP id
 d9443c01a7336-24306da5537mr4831165ad.9.1754996867136; Tue, 12 Aug 2025
 04:07:47 -0700 (PDT)
MIME-Version: 1.0
References: <20250812-vdso-absolute-reloc-v4-0-61a8b615e5ec@linutronix.de>
In-Reply-To: <20250812-vdso-absolute-reloc-v4-0-61a8b615e5ec@linutronix.de>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Tue, 12 Aug 2025 13:07:34 +0200
X-Gm-Features: Ac12FXz75fv-5GwEH7lTNJ0yhooMj6nwQ9IaaKPBS7pSI2ZcZDdB8Ex-5Z7LxRg
Message-ID: <CANiq72nV62c8cVBzke73OH-sfLdgerDBGrLKTmT83+OQtK6PjA@mail.gmail.com>
Subject: Re: [PATCH v4 00/24] vdso: Reject absolute relocations during build
To: =?UTF-8?Q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
Cc: Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>, 
	Nathan Chancellor <nathan@kernel.org>, Nick Desaulniers <nick.desaulniers+lkml@gmail.com>, 
	Bill Wendling <morbo@google.com>, Justin Stitt <justinstitt@google.com>, 
	Andy Lutomirski <luto@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, 
	Vincenzo Frascino <vincenzo.frascino@arm.com>, Kees Cook <kees@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Richard Weinberger <richard@nod.at>, 
	Anton Ivanov <anton.ivanov@cambridgegreys.com>, Johannes Berg <johannes@sipsolutions.net>, 
	Russell King <linux@armlinux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Madhavan Srinivasan <maddy@linux.ibm.com>, 
	Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>, 
	Christophe Leroy <christophe.leroy@csgroup.eu>, Huacai Chen <chenhuacai@kernel.org>, 
	WANG Xuerui <kernel@xen0n.name>, Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
	Alexander Gordeev <agordeev@linux.ibm.com>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Sven Schnelle <svens@linux.ibm.com>, Thomas Bogendoerfer <tsbogend@alpha.franken.de>, 
	Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, Nicolas Schier <nicolas.schier@linux.dev>, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	llvm@lists.linux.dev, linux-mm@kvack.org, linux-um@lists.infradead.org, 
	linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org, 
	loongarch@lists.linux.dev, linux-s390@vger.kernel.org, 
	linux-mips@vger.kernel.org, rust-for-linux@vger.kernel.org, 
	linux-kbuild@vger.kernel.org, Jan Stancek <jstancek@redhat.com>, 
	Arnaldo Carvalho de Melo <acme@redhat.com>, Alexandre Ghiti <alexghiti@rivosinc.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 87E07140009
X-Rspam-User: 
X-Stat-Signature: oprdxs8mugw8f8iwgnqwic56nyxqjix4
X-Rspamd-Server: rspam09
X-HE-Tag: 1754996868-634652
X-HE-Meta: U2FsdGVkX1/wVmbBIufSKuroND8IpfDZHK5pMosntBiT7duztS74dsEyYASOwOHJRqY+R5xh7Wu6/dtA0z0fdvVRvu4pVp9WefpGoLxu3pd+IYMIiZktTaahNdjbwV29fAzfTcd2M/drFrlKHl34+MwRHbHnAWIHJmAoLfyQCT1wdfsHoxGFCQNRnBehmrY+hy6VOf5nxI4bnnuXB6pDW0W7UkLLAUbxL63fw9gHYJEvJP/2/jfX+60FSwSIE3ipAmBpHjz4EHUSYbrc0qxjpx1y5dzuQ/2EQhx5rdJX2BJ0icYcsO09Uk74aE5U6Hzq1135JbIMJr22n3Vjc9ZNpzNFLIFIhev9g0TiSLCEs9WEihg0krF6FUzqqwLwE+cHTTwSFC3YdkdzaZnWRD8JAleueXNGXeD8BRh2eG4AfM2mNO73zII0z16oVfjoNg1zd3poZ0k0zgmya888xUpCizN42VfXhtIBUgWhtL8wU6YfO3O5Od+qleBvtHtDVYxVw4wVdaEy0P1wK0xLlBOC86CFmtNRm+0BM2fZCWh3Z7sx7bn4JZGFc3gTdtiYbz5rYCLecdOHYcepFPJ+Uq341tpzDa7IRa1M6mYQmUkMPiJDg0QLHuW05jmb3+t9JWIJHSyaSgmf9lPEJWMSXpqBxinOlIoW2wKis8Z7BTsBqRaeKNvHNpRhWUXIerPw2yvVrmgF6Qd5bPeaTllsKyfzLvTXuobNxCP7A6kLtBPxnMlJkd1KJFxVYwAw3np5Y/HxFUycDTZ/kfNh2ZcFzyj8w6He7m2LEI0/7vxHRfdP9JrNl620r48GK5css2EDCQkpPm+dXDOIaBrvYKhCPiLZt0EAOrVV139rgX4FZymb0aPSq7+YJnM5FPv57d9q7TgHvRCt1mZNraW2fytXlBeXbhRtAWMaLaqWlCDK76FjUD7mW2/3CyNmI99mBQyDszNq7ZFM9CJdQje4GHuyNDX
 mYT8mh0B
 cp/saqTejKmx0hVJ6NIcJuEJomWaJj/LgRsp9K3/rDPKhUoqj7pRJAJF6TSXt58mRrDcm7tNCROFeoPinyswM31e71COV4PsXHdie2EJ0EXZAh+DgnyU+8RmS8Kz1bh3jsuYyFnclRpFrcTsmOzhO23C9CBNt+7+mI+FPemnXmKThaMcHIlOi3rekCzefwgp19vRzyV8KJ/m7jQ9k2Q8P2qjJ+6ZqRYZOlOaliGPRuvRnAY7JMQybUhduKDCnr9MTB2rh0UNOB5oIpKMwxgAzOazhfoW0yQNbK1I++FU4mBqENGYoR+JCyfLqH0HnvAYuvjDat9rM/dzVx/NtpgHBMtxi5qwfV/tpuRaWK5qKSaLxeff4gaeP9icWU9kwnAvdgJHaF6uUlZfrF3YsQoDSloz+berP7uTWpH6m/VBUl7zOYqAXph9AqwwRbZaIIozsQlSXEXDnUszlaTIBbKtloaEQs++JsctHMUtldowoLUNxhOQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 12, 2025 at 7:44=E2=80=AFAM Thomas Wei=C3=9Fschuh
<thomas.weissschuh@linutronix.de> wrote:
>
> Kbuild and Rust folks: This contains custom definitions of hostprog
> bindgen and rust library commands.
> These are currently only defined inside the subsystem directory.
> Let me know if they should go into scripts/Makefile.host.

Glad to see more Rust host progs :)

Keeping them local may be a bit easier initially to land, I guess
(e.g. no docs), and then we can generalize when needed later.

By the way, for consistency with elsewhere, probably we want
`HOSTRUSTLIB` -> `HOSTRUSTC L`. Though I am thinking to remove the `L`
anyway since eventually a lot of code will be "lib".

Cheers,
Miguel

