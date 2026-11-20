Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF4A9606A325
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 17:04:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=P+ZucOlp
Received: by kanga.kvack.org (Postfix)
	id DC0AC6B00EF; Fri, 20 Nov 2026 12:04:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D71A46B05B0; Fri, 20 Nov 2026 12:04:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C87CB6B05B1; Fri, 20 Nov 2026 12:04:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A8C0B6B00EF
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 12:04:10 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4C15A1A0FFA
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 17:04:10 +0000 (UTC)
X-FDA: 85456120260.15.8CBDC24
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id A55094000A
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 17:04:08 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=P+ZucOlp;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795194248;
	b=Hk+JuDOWF3fNHG3j3ywymoywZUCmNTJLp/uUR0Xbh0l5OgnZ8SL0QALurGHkuj08ZFb7S9
	S0AaPMNvZIrA1KqNpk0LHWQthctmmfSU3kFM8JmImq29LEkJXryij+UqPtgLN/pNmHZWah
	PZXsZYEHx2iTTkH3T8Lv4Z8LMZshOgE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795194248;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f+2wNTUBSA/04ZrCAiy9BSOqwC0m9fwLJ+M9aO+5qKg=;
	b=XOufGLZ8InbWQz3DZ41ntv+Fk+JGKf5PZ0lT61HBs3z7eAOsVFFjWc14fFiQoGlADM5K/Z
	FqKZ2WrriLE2tKkNXxXb+ekhRwgwiio2RtS4edEV4ggNhVbVWKLWyGWte+TXSOYP1Z89BZ
	JYp/QUd5X3hagcriWqzrr1zTH2ye1zI=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=P+ZucOlp;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id CE897402D4;
	Fri, 20 Nov 2026 17:04:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A00A1F000C6;
	Fri, 20 Nov 2026 17:04:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795194247;
	bh=f+2wNTUBSA/04ZrCAiy9BSOqwC0m9fwLJ+M9aO+5qKg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=P+ZucOlpL1tiTypkl4VdVmeDNO4Y9+CIEUauzG4ph97TqCklyeBA84+zMtbF0CqIE
	 3cLzL1IO4qVFc6QDPt6zeifep/EIi3NhnNRBOngkxUkZm9eCqbE4ERF7oicHYe9jYs
	 mZ2DSivOxfMTCxLkGkWaO7APVh3Rnlw3vd4wGrDMLO+KGsLaNGZsqwCuHDupRZjYIS
	 R+gyIVxDSr5TGKWEKD18lSY1JpLbLipQ0vRtBoVWU66g8MGNv4Mz70dG9CPM+O1ATA
	 x3x9AWcrCf7IN24i4mqokmp6hU8eiyskVPLzStUClzFNR935/Ed1q/vVkO/AgkOjrz
	 ep287wn529UlA==
Message-ID: <sashiko-outbox-225620@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2] alloc_tag: Use __ prefixed ELF section names
Reply-To: sashiko-reviews@lists.linux.dev
To: "Ard Biesheuvel" <ardb+git@google.com>, linux-mm@kvack.org
Cc: "Ard Biesheuvel" <ardb@kernel.org>, "Suren Baghdasaryan" <surenb@google.com>, "Kent
 Overstreet" <kent.overstreet@linux.dev>, "Hao Ge" <hao.ge@linux.dev>
In-Reply-To: <20261119170353.1835737-2-ardb+git@google.com>
References: <20261119170353.1835737-2-ardb+git@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 20 Nov 2026 17:04:06 +0000
X-Rspamd-Queue-Id: A55094000A
X-Stat-Signature: jyahrqm7wkunga1d1rmrrogqqzsfbaha
X-Rspam-User:
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam01
X-HE-Tag: 1795194248-731387
X-HE-Meta: U2FsdGVkX1+akne6wKIGu/ArEwEqy9cfwFUb8jHwwq4EI7yP1CdSR+rEmuCbtqO4vjRlGDLVgy+uzftUnyvwEW5SyaItFbr0MgSDTAoiyBH+pLSSBWdj5JSNdH47SiydrnxzoQWC/OgD9k7XJqtpEIOlU8udm+ynMX5iZxurhwkoSz+wXx3Iwaq3tHTiMlT9lHOXqnNjzcMCO1NtRQ2AMRIJVi4+KAsLqLdX5XPWUDfboXzUCR8U7d+tiiS4WSCnGuBkjrJOnMfvAVD8TgmlO0hhqEcESdUEkYModTqDxf3Nhr0S8k7VjTlngnX3Ag8s7azOdW7/3ANFsus05h43YaiS4/ErcURMloHBZtq1XDhLGoQYOiNclLkg2IcR/DiYjG1p8v6TwnRFsfs1grBTvm1yikH4+kPAcr1qu6LFscz89qwxwjmECzzutspp6SFqNQUlXkB2kmK1+uJAfzkkRrZ8keix/+Fq5kCwDxehsegrlumZAwWUqgwCS9h4SFC7jo+g2qafUGlXNEv/f4Gw61CkTbahx/p3DugWBjTPbajFDFZhBRlzwojgQ4/AZNyEHujz7Lk1LaLP0wOg4UcEEaD1Q/dmfP5938gxmOD8OgpYhOkWTftnblrcYqA2KZUIWRAZzkkVmRx98Y2/u4sJLxIFrhgcCcGtfz0Uw2JknXopjfVJO4HriDNQ8EfZJDRl+SLGKmkGSMPpL0mc/eYGp+RodSQU+359V0twZrQwCObvFPuEUTvTI8HNCUj5fI9LsLcvj4RFgNQZbl1XvSA0aXQG7bmPXPcXCaYmG/THE8/GMXo8zQrF1WjdkjJ2Lw7C4yH09Esldr3Gc3hCD9SCf+aoMALrFNanDUdSas57MciKaSq3bZqJKjBeqfXHCZU71F+jUokJqa7hcjOFXTRnpxwe53jXQzL62aFtcO34aAR35fKxekMk0RsLrIIl4mGElKRjlI+s0VT5bIJz7Vn
 ZR+HKo8+
 KRfPGTehwjWNN+XPFl8BTxO/ow7/qyWS9nugLszJpRIHF2Bna3+0KXYKappHDYdYhLbwaquVQTCQrF7+p8QMiznZOvnIGbEYlt4ZnQgs1FJiFeuoDRZvNVlIPEtbDy+D/3XteHzZGLPy5NAcP54LkcHZhvN+BTk51jW/Yc7ptRFAgnyNLgXbxmcTr+xu6f1wdcUVqARdRM3ZYb/pBsdK0RUYQoUVWdOpEzC9rzGvFBPftgnLDzk6F7eknlU5RxonxWEwh15rOl5hl6T5+R9pFDRJTD7U0Ne3OeVeihL5JPCKPvRFx2Cz+4tTFR/12gL1bc4Ow0W1j99nrvn29SgZplKLMKGKTGiirTdQo5B49CGsM6sjZRQg5OoXpyMvkYnRS6UgUlcwMO1ATepkBEl6PXh3jrWpc972U/UGwZJ14THp1Z5aP3DVwUuJowjbTn3hOTaNjVBOtZd4+wV+yEOjWsbe0iwO/pGPTbwQTH3vTekoTD91xqzBJEEFCdUIcqErgInLvZm9SYUvYFM+kaYpy1Xjw43dHUd6w5H0tsm85DKhSsst5St5AXqZjGcdWtEZNH5IZE0uaPA0YQXyRGPoavDT75zWFhqCOCp4Slk2hyuFvZ8At/kpAY4rP9DVtI6OosRWY6nhiejF4cbgwuiJAz6rsmWt+QzbcesQCVvBCsmXiNUbBxWKu+NAfcHSSPSH0HrWiyNudfwkx9y1f9Q+akB7gXDxudo3U4Mw1TiBd9cgTQAfL8ZlKxv4v/6/pQo9M1f4y0MKshopbavGWzYY3hrk0KONDChXt/+2hvn+6AST06S+eMvLf8IFnT9kmkcF7gDxFhkpOb1Mv5so1zNaJQpB1DmXpno3fhZxDenXMgfjJyj9aGY0wbr31v5AEIobWjaOukTWEj5N6X/A3xzUgArjSfv9dFENjPGNDF9IY5Bnrgfx8v5afbn9Tc3KETVEolu4tZrEfku0MucglT6RdZgEtdqOx
 KcapenC3
 UF9DStIdZLw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Low] alloc_tag: missing Fixes: trailer for unprefixed alloc_tags
  section name
--

commit 72a9298bf692412bdfb714d9d138e27a153a508b
Author: Ard Biesheuvel <ardb@kernel.org>

> alloc_tag: Use __ prefixed ELF section names
>
> The compiler will emit static relocations related to a section .foo into
> a separate section called .rela.foo, i.e., it just appends the section
> name to the string ".rela"
>
> When section names start with . or __, this results in section names
> that are correctly matched by the various pattern rules in the various
> linker scripts across the tree.
>
> Without any such leading delimiter, it may lead to spurious warnings
> such as
>
>   >> ld: warning: orphan section `.relaalloc_tags' from `init/main.o' bei=
ng placed in section `.rela.dyn'
>      ld: warning: dot moved backwards before `.rela.dyn'
>      ld: .tmp_vmlinux1: section `.rela.dyn' can't be allocated in segment=
 1
>
> Fix this by renaming the section to __alloc_tags. While at it, tweak the
> headers so that the definition appears only a single time.
>
> Cc: Suren Baghdasaryan <surenb@google.com>
> Cc: Kent Overstreet <kent.overstreet@linux.dev>
> Cc: Hao Ge <hao.ge@linux.dev>
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>

[Severity: Low]
Since this fixes the unprefixed alloc_tags section name that causes
orphan .relaalloc_tags linker warnings and build failures, should this
include a Fixes: tag?

  Fixes: 22d407b164ff ("lib: add allocation tagging support for memory allo=
cation profiling")

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261119170353.1835=
737-2-ardb+git@google.com?part=3D1

