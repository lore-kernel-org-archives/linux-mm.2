Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9E4BEC79FB6
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 19:38:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 71D596B008A; Wed,  9 Sep 2026 15:38:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6C5C16B008C; Wed,  9 Sep 2026 15:38:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 58E296B0095; Wed,  9 Sep 2026 15:38:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2C46F6B008A
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 15:38:29 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8F2CE16033F
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 19:38:28 +0000 (UTC)
X-FDA: 85195235496.17.1D57CCC
Received: from mail-pj2-f12.google.com (mail-pj2-f12.google.com [74.125.227.140])
	by imf27.hostedemail.com (Postfix) with ESMTP id A801E40007
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 19:38:26 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=iXBi3K9w;
	spf=pass (imf27.hostedemail.com: domain of miguel.ojeda.sandonis@gmail.com designates 74.125.227.140 as permitted sender) smtp.mailfrom=miguel.ojeda.sandonis@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788982706;
	b=cAKTBu6Xwqo6LNI/NKt0txoRUTFnrH5rkBwuoMLkYQZLOaYScXJzq7S5wL+IxW3ch1WjYe
	BW+LBa8PSQoltWIeKYbm5BS9az6egsTkPX4OfLiFFmgPcjg34VfL6h9tPCvgUlwikYfk37
	vG2hw0oc3GQvdsjE1kLI3rNIkzsEuAM=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=iXBi3K9w;
	spf=pass (imf27.hostedemail.com: domain of miguel.ojeda.sandonis@gmail.com designates 74.125.227.140 as permitted sender) smtp.mailfrom=miguel.ojeda.sandonis@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788982706;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1ydOjuoTgA1JS+qa07cHIVSm0i9RHzfwwnuAwNBt4m4=;
	b=MMPD58gCznTPAsTcKu20tKyivh7i9yZrVRWHBloai60n0e3MHqYzJQtFSxzEQYihvp+7J0
	lDjqe8OGpLwsvyDJD/u/JHe6rBqx7RJxXjzipkavUsbKAkCDKpz4xoC8L2rUmGFDklZHXt
	Fpqt2dOm+lPa3RgFLTZ+NP3jkqdMQkc=
Received: by mail-pj2-f12.google.com with SMTP id 98e67ed59e1d1-39666bed442so1074847a91.3
        for <linux-mm@kvack.org>; Wed, 09 Sep 2026 12:38:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788982705; cv=none;
        d=google.com; s=arc-20260327;
        b=mkOOJfVLQ2wxa9nfUJJRXQP3ZeAV8JsPiBl+38lRpjOARQYp1I7Kfj/o0xTiKSq6SZ
         NNdysIjJApULkoP+xafYsAyGyD4uQgxyrq/kNd3wjwKKv7MXkU+XoAtc+l3mLeKs7UO9
         U+BGk7cUfgpHBx914xuq+DkGYBvMo8jKJjIcBo+vAns5tc9Hk8qjM6dFXME8HIwmbt1I
         ipCu8WelbjlTEWy3thPhvgblZZgGyTMBjpJPexL8poV2Cx7WCAG7JLJyRdzATLPoCjuW
         EbMZZafcnxXTfQSa2XPSC/v7oBlXxoHJOpPDK8bjvnEkdKasADpkm7FeP6tSognqzn8n
         Of9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=1ydOjuoTgA1JS+qa07cHIVSm0i9RHzfwwnuAwNBt4m4=;
        fh=hvMCYwissEzTMu5piWLPUbWAEqQhwWkhKFSeMa+RjE8=;
        b=UvSK3Nuf1efDVWy4D8+VhdG27NhvEHQBH8c1O9RWlgiqUY1VAmPT4zJqefCh4SuzNI
         2eGS3zo+5EUl0BlQp+Q1yxnUgCd4TmMBS85cNSRbgipZaJlGXId7hMMW47vf+b1/Hk31
         VyC0Dr6Sx/AnKAAURCMWZE7KKTd92wRDBDzCKH3v6sv5lZNE/XhCxWJ1vUKWpnvF11pQ
         arWbSq+xvIDEJK1R51LCtbSsROWa1nqBGNFJXbrVJ0qJtkgH/+jgwUUK1VacHLZQQFk+
         x5AJSCu4MSzkbdhqtNpG35MUSoqpp0njim4XEb6QqF0DKYfTgvWve1pzZWo55zzRooYI
         c6Gg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788982705; x=1789587505; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=1ydOjuoTgA1JS+qa07cHIVSm0i9RHzfwwnuAwNBt4m4=;
        b=iXBi3K9wwsdHqfa1HrJSTqeUTonKcVmRIP6PsYoJlWVbvi/34vjyV1lOHkD+UveKLy
         heKiQyKIOSySK0O3zWSlzHbhLE4yldOZdgr6qZL4bhqwVnfl5QQ/t3FD4/F8S2LYjioD
         gQGBCoBTnJIpv1BXMDwO+ddbix9eSs8OysQCy25sEyDaav4+W7IgGNqpbOEW935Z5qC6
         5UKBpguDsFpls4GtTxT0FswxJZ4lVgwTTA8Qc/+P5CaKJao+77Fq3jMtjL0ce0tTQXnj
         UqMsnuxD6ejuuFqHw+H6GQadX+aEcPWsTlV+dFHf9BLbZjK2moeaNb386JSzwfqOfXDF
         jvzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788982705; x=1789587505;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=1ydOjuoTgA1JS+qa07cHIVSm0i9RHzfwwnuAwNBt4m4=;
        b=sZ1V/dMnww88rj37VQXvVVg2wck+UstuAhLlGFB7Pz+1KMtA7mZYQx+Fg/3zeEMs61
         2SawWfPvDddkhbq8quHs6SUTis3KXQOI3hc7LpCRaW5zZDi5nIe5sM4cY1/rYNz1DOhY
         TJ/GHWmoFvklTcX+2PCk3mQv7By87fKwZFNT7ZUIxybLchQ3RUJvfR1Rzfu3RrqvGwJQ
         szP3uKmbtHno1igRPcR/7Zynj1RN4JoVrmXMYG4QEcq2yMueIZmTexD7wGpHYiCBrCIl
         3FC1xhr/Nme+p9LK6p0SGwmmyN+ZA2FxHsPi+COEBAVREDjDNhk0hUIm2DiQbISBlJMB
         LZCw==
X-Forwarded-Encrypted: i=1; AKwUvBxWt/XvSb/UJQUT7q9jHKfseqDm//4LQfOKzjsphJctr58uEi+NsInrah5DM7jEU+hO0q9caiFHxg==@kvack.org
X-Gm-Message-State: AFuF++l70bJdCdewrIs8RD/r8KWbF28tU2xLwgJWKrnyVcM5fkWMIaHx
	mDGV4UrrJEVb4NJYptDXxhQ6yWcJjHYiaBK0L9fsL8OWR78TCqjMFRDp297G9NMdo963gepjN1z
	D2IxCJyit/veYyLpBtYzxSfgDvcqCJfE=
X-Gm-Gg: AYBFou1Cvs/HybC4qjaK3oNvRXwOEu9MRq0A9mao7lW93fVcT/YEknyUmhmApUodNDH
	Ext/ICefW3MiPRzeLMHkDzPig269uql1ye8M/5lE6PXcriZIj1JIYzbTjo8nLGuCFvUFsNVxC9V
	HakTu2IEMHC4AcsQlPRfPVoAsru5WaUiXHg5e7CVcv9uqkG/AaXgmhX0qkEYysLbqwAZQiS02uC
	fTvbTb8iCWkEdOA6DZq5rYc2gbPAh5LQVcpV/9SXGFs80QUye7HD7n8gShnTG9jc2cER0PRX4kv
	XGDENvlfVgUXPiwTSmMu27HZyV5KM7UrlxsnnScec23Ao8sPEfSJszFiGbd/X4Bqho6bMDiU8sR
	AOGWo4j6Eo3rid94/g62O5gbi7DutW+YBkHxtYSAG7PGmC7PYIlf1ChPuwclJvr7jSLDAqLhYTI
	tdlMacf4PLJsYc/GISStMqhTAkeOiu7yl9hIzMECtNZ1n3XAakEio=
X-Received: by 2002:a17:90b:3fcc:b0:39b:3505:c72f with SMTP id
 98e67ed59e1d1-39d77b83048mr824934a91.6.1788982705356; Wed, 09 Sep 2026
 12:38:25 -0700 (PDT)
MIME-Version: 1.0
References: <20260908-vdso-absolute-reloc-v5-0-3a93791af1cf@linutronix.de>
 <20260908-vdso-absolute-reloc-v5-12-3a93791af1cf@linutronix.de>
 <20260908071911.GU4120091@noisy.programming.kicks-ass.net> <ABBC0C50-847F-406A-B426-55D0C2BE15EA@zytor.com>
In-Reply-To: <ABBC0C50-847F-406A-B426-55D0C2BE15EA@zytor.com>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Wed, 9 Sep 2026 21:38:11 +0200
X-Gm-Features: AcwNN1V9A4D3jn7pum7crGv8bcA9jfLyy60O95H9hOe-jZGhQ7AzCwKSAv7z5Dg
Message-ID: <CANiq72=T1487Y7TpAa4c2eTJFMLHoe5Qc7+tRkbkmvrDjfmuvw@mail.gmail.com>
Subject: Re: [PATCH v5 12/24] vdso: Add the vdsocheck tool
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Peter Zijlstra <peterz@infradead.org>, 
	=?UTF-8?Q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>, 
	Nathan Chancellor <nathan@kernel.org>, Nick Desaulniers <nick.desaulniers+lkml@gmail.com>, 
	Bill Wendling <morbo@google.com>, Justin Stitt <justinstitt@google.com>, 
	Andy Lutomirski <luto@kernel.org>, Vincenzo Frascino <vincenzo.frascino@arm.com>, Kees Cook <kees@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	Richard Weinberger <richard@nod.at>, Anton Ivanov <anton.ivanov@cambridgegreys.com>, 
	Johannes Berg <johannes@sipsolutions.net>, Russell King <linux@armlinux.org.uk>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Madhavan Srinivasan <maddy@linux.ibm.com>, Michael Ellerman <mpe@ellerman.id.au>, 
	Nicholas Piggin <npiggin@gmail.com>, Huacai Chen <chenhuacai@kernel.org>, 
	WANG Xuerui <kernel@xen0n.name>, Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
	Alexander Gordeev <agordeev@linux.ibm.com>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Sven Schnelle <svens@linux.ibm.com>, Thomas Bogendoerfer <tsbogend@alpha.franken.de>, 
	Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, Thomas Gleixner <tglx@kernel.org>, Christophe Leroy <chleroy@kernel.org>, 
	Boqun Feng <boqun@kernel.org>, Nicolas Schier <nsc@kernel.org>, linux-riscv@lists.infradead.org, 
	linux-kernel@vger.kernel.org, llvm@lists.linux.dev, linux-mm@kvack.org, 
	linux-um@lists.infradead.org, linux-arm-kernel@lists.infradead.org, 
	linuxppc-dev@lists.ozlabs.org, loongarch@lists.linux.dev, 
	linux-s390@vger.kernel.org, linux-mips@vger.kernel.org, 
	rust-for-linux@vger.kernel.org, linux-kbuild@vger.kernel.org, 
	Jan Stancek <jstancek@redhat.com>, Arnaldo Carvalho de Melo <acme@redhat.com>, 
	Alexandre Ghiti <alexghiti@rivosinc.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: A801E40007
X-Stat-Signature: 79m6dghbsiy3xqmjgpkrfyptpeyoggd1
X-HE-Tag: 1788982706-739964
X-HE-Meta: U2FsdGVkX1/L/cmfPhN3EZs3xS0DVP6mOF4kVn90RwyipXmLwyBRVeB4B8/AvdT5rhh+7SQhCWmcaR1aeUVpUb4fDfrXoZm93eRt4gn0yiWBnWg7054PEZ8+P2WCb7zozhME0U3fTKLEI0K2WmblHmUv/LrRCp+Th+cg41LazOstJ/UcAa+ftewgfhjc8ozhTAZgvtcYe9MpLvdPsbywyAvsfTMsQ5nbyyt4znaFuekrVDxBdtHLVgIm/0NkGDZFbKWm2g6F7qhgsPpb//3O7IFmaODMeTxoygrcu24IAkmjeffDDb7Jjg+Ll1sWzF80Vjr7b0l2sLH3SdK/Q7XDWEkYNcIaauSU6Pt5IEEiZeKI6gnWmQAtB3S+uClgJsxjYBPMUz+r4ATCsvjsEDUSz0bP+vmj+If6aaphzEmWBEfJOj+IQrZ9TY9+OY5a8+/Ucl3ZANkp8aTfB3onTC2p5DWwoIjiRIoNlHJpstWpJFzAvK5Eebef4G6XFQSMvqtod5SnG4l5b+PMPkXqOPoKRnFKJaXNHnqTPOdC6dcBJYM5n1qmPNoCXmR85UqA30Y3zJZsAvmoMISGIPd7SY/qOCSbeIAmb/GuvDohWPLM0N9YK+gRWyNzRdsi1YSiG5Ek9T98bmB0toUo9NHDMYxuZ9zOAFBpjD0Cn50yFlJpuslcjAbrRF+Dxz932FT11k8M7o0ipSFcoJvXLMNsmcRBV6DkjZbaay9YZxpCftcWQSET832F3+kiMyCsLhPYsLymjd2lM2n3ZXcLBINMVBSc+L+QE58lZKf7zdHbTYJ9ANHuuEK0rWnyGzmTz8sFpPLwzmWfTLCHEDnxyndmBxJ8Pb/l3fGprY/2ZzmIHqtaDXgP0FvUyZbUib8BtQCMDg1PnwCCvktPC1chIWs9v5gqLiAA2RTGiymGuiUJ4r8usQnL4dQSIDQspPXciSaVM2XgMH35TPz9p0XMNwEotuD
 w5k6q6ZF
 3WzHSd1rJbC9OKVtfcdKcU73noH5Dj4A5PCZOWTmsUyIZhZAMxnAhyi20RLGG1BgsO9Yr27tSYiibwZbhwsKWgqApkf4X6JlrqK/v6k1WaQ7WXyCrVg0NayEtb58+ovzLM1iqH+H50H55ATdtFvTcpL0WkeS28FVeoEud1fAjghc4nuAs8NLC0LyhqSOvfNyhJtQW65BCC3fr+IdGnkNkzYqSZFuGN5vMu5nQK2lMV8QVtnBYOqP3z8y1vaTArXkyQycDSR7yxq65FmAMB9b5VLb1iuwth0ne3X3O7x/Io6mJv3juJMQx22152V6rjbBzr3daSUKOBPEV1SpLZ5qbBOYCOvRUuos2iwbcT9JIPok/ccxoDAwp4FgFAWu3vaIP3D5kxyKIphrJe6Bh6VHxDygmsdu9u1H4m0HqSNQm71m3pqAkyJWp+lJmBdwsHLpJL0FiUtUkIEqmZtHnJrYFL69qqC1sL3ZBIige4CDp0M1j3GHFpRUg8cRoYTQNQztFpweECUXWCqalw7/ZABuAz8hySfZ3CzXzryW0a5dy38glRkr+g4CXIoTqn91T+9T1vetc4PEL9Z+GpmHFTERWnyX+cw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 9, 2026 at 9:33=E2=80=AFPM H. Peter Anvin <hpa@zytor.com> wrote=
:
>
> It was going to happen, and now we'll have to suffer the instability of r=
ust...

What instability?

Cheers,
Miguel

