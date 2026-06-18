Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B5C18CD98F2
	for <linux-mm@archiver.kernel.org>; Thu, 18 Jun 2026 13:23:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5C22C6B0088; Thu, 18 Jun 2026 09:23:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5732E6B008A; Thu, 18 Jun 2026 09:23:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 461FA6B0093; Thu, 18 Jun 2026 09:23:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 181336B0088
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 09:23:16 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9A22A1A0782
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 13:23:15 +0000 (UTC)
X-FDA: 84893099550.29.67B088A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id AA33BA0011
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 13:23:13 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EVaQzpYi;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of linusw@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=linusw@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781788993;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+Hao5re1+cPlNlzNJBZ4sf1w820eCIPHa6P9dbVUFmE=;
	b=niovVGc8yiH4T0D/2K+jZxiUZbV6A4TVNwEeIhesfHkMidYH31ArgTOLCseN+FnD28GKgS
	OzXCwizD/gtBIGRWexjSC9QJZOmR/3U3PC2flwA2TAEya+xl+YwUfLeO8IV59LCuFKG0i0
	eBqNGEidNr1Gbnb7+9vKxYYz5MFXmlE=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EVaQzpYi;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of linusw@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=linusw@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781788993;
	b=og/aXSFPYvH6enrbELDU8gPeYL0K8MesbyMxv03Bqk+ji1OO1xgPXWxm5RObvNfxDY/J9o
	X0b0dBozp6yVc1EQ7ujAjHyXvjsXf7738tOkNomW//nQw0Ogs3ysiAL5HW8E+SR++vhd2a
	PsmuOf+pbG3AUFgLE6vXvqVi8D5cFzs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C4FEB43F4B
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 13:23:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A81C21F00A3A
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 13:23:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781788992;
	bh=+Hao5re1+cPlNlzNJBZ4sf1w820eCIPHa6P9dbVUFmE=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=EVaQzpYiRqYK5hksirc5nS24Y0fzb4urTSaV/jtRdTqQooIUUArTy1+HgkpKtFwim
	 1+4WlmhNJEAkxfk/lfl5HQjq/Y957Ghxvj8izXGw/06pRWDQPP+ruSGUZgnocnwips
	 nbOIxMtH4SiWbCBweUzm8EhaTU1i0hc0tbBr2uihXX5GFXhUhRfgxP9GVbhs5rMYWN
	 UNGGSkpKbvRFL+6yTa8AVdYBjxBLZUvVNeRIn9og2bs/QNiJX0VZzDE8FhqrkAKrLo
	 Qg38vSG6ryiNQ1C1rfo8rjZkYxReWCmpGf8+iB5xzZqjutTJZyoifdtv8K9wn/4odD
	 sAtImPZz7u1lg==
Received: by mail-lf1-f47.google.com with SMTP id 2adb3069b0e04-5aa6c66e6c5so723014e87.2
        for <linux-mm@kvack.org>; Thu, 18 Jun 2026 06:23:12 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ8daKvf8c8/czn+6F4yGbJLejTErEZbhmva714oqMEQpSfVymbsbh3i+oaGDMALgoyT1lfrfzwRVw==@kvack.org
X-Gm-Message-State: AOJu0Yw5nS0rVjR74D88wPQtzVHyiu6ANRybLinrEANb6zbHlw8HHJlp
	KSfRrXQxhFhhSgH/hX92tgZ7BPG9ARAqRbwBWtfmUaj11vd1F95NCARJSt20kCbVIFZI/cPc7oo
	wu8mvnJe4uySW6xjhEMGwmyPA4UPY4HM=
X-Received: by 2002:a05:6512:6487:b0:5aa:6289:e0b5 with SMTP id
 2adb3069b0e04-5ad50ec7bfbmr700610e87.35.1781788991504; Thu, 18 Jun 2026
 06:23:11 -0700 (PDT)
MIME-Version: 1.0
References: <20260526-kpkeys-v8-0-eaaacdacc67c@arm.com> <20260526-kpkeys-v8-1-eaaacdacc67c@arm.com>
 <70f4dcdf-c45f-47d3-91df-a7897bd86ff4@kernel.org>
In-Reply-To: <70f4dcdf-c45f-47d3-91df-a7897bd86ff4@kernel.org>
From: Linus Walleij <linusw@kernel.org>
Date: Thu, 18 Jun 2026 15:22:58 +0200
X-Gmail-Original-Message-ID: <CAD++jL=km9hqTuTMFUhyx_QPuMEwWqmnUVQtPtMXnp8paHH1_A@mail.gmail.com>
X-Gm-Features: AVVi8CdVd_MSXkJ8x_FXRhl-ZhQK3-a6vu0Q8TQoQCS7OolDkuqw-biJhYguwBU
Message-ID: <CAD++jL=km9hqTuTMFUhyx_QPuMEwWqmnUVQtPtMXnp8paHH1_A@mail.gmail.com>
Subject: Re: [PATCH RFC v8 01/24] mm: Introduce kpkeys
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Kevin Brodsky <kevin.brodsky@arm.com>, linux-hardening@vger.kernel.org, 
	Andrew Morton <akpm@linux-foundation.org>, Andy Lutomirski <luto@kernel.org>, 
	Catalin Marinas <catalin.marinas@arm.com>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Ira Weiny <ira.weiny@intel.com>, Jann Horn <jannh@google.com>, Jeff Xu <jeffxu@chromium.org>, 
	Joey Gouly <joey.gouly@arm.com>, Kees Cook <kees@kernel.org>, Marc Zyngier <maz@kernel.org>, 
	Mark Brown <broonie@kernel.org>, Matthew Wilcox <willy@infradead.org>, 
	Maxwell Bland <mbland@motorola.com>, "Mike Rapoport (IBM)" <rppt@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, Pierre Langlois <pierre.langlois@arm.com>, 
	Quentin Perret <qperret@google.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Vlastimil Babka <vbabka@kernel.org>, Will Deacon <will@kernel.org>, 
	Yang Shi <yang@os.amperecomputing.com>, Yeoreum Yun <yeoreum.yun@arm.com>, 
	linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org, x86@kernel.org, 
	Lorenzo Stoakes <ljs@kernel.org>, Thomas Gleixner <tglx@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: AA33BA0011
X-Stat-Signature: 97naxxzfztxb86kuanae6pey6ibrzw86
X-Rspam-User: 
X-HE-Tag: 1781788993-317309
X-HE-Meta: U2FsdGVkX18uXLW9Umjswz10lDRJEnNpNPKGs03Hbz1b9HXkNKOHmNrO9Rw+eYVYBs5mifqDauTvBYmVhQqVxV0cnvsS+Rllzm3tl9/9wFTc93pMflmC/KyYlDFWKItybTTl+OH//SuCC2FjxbjyBKTasOUw7wmAkwSRMA9vjUHKYoNMEzm7X2bn2VB02UQq/T163b5I8VwqFpY2lCXmmoLPuCnR8HWWvx8rOwvSvRO5ExKuB+YqWIpl7t+eZ6OztfVGDwkftmhYndzN58/MpHmcQ4yVTaRzXlu5wE8JEczetsWfSYzSSJrzx48IbJMzXLG8QeRZ0+chMWRYhq9WxP8kbp6bAAZ1P7MJaAeh8hNL1gxjbAM0csyWiWE7mGL8x8+bfY1CqHhpdmfWXTbojHsEgXzg/UIvbIjUjxJud9rPejfkwGJV7xS35oC/7PtkhpYSVYnOFL/Zim5rYeOtKb4Gm9U9IqN95HysALM1J8WK8Hq9wT4hagse8shNOo5iATs2vdu2pC6c97WFMZeLYblczLTj+hQ+xkATT2gvtsAlsKWI9Nkee0xcmgT18I2uN1YtdcSxBbDH6iEc06aFSYr+JGdI1AR2pM5zg+RYbRRVcQX45SrrqClQXtM5CgNH/qMhd81AoObZmFh04TGT0ACXDkUxSzJ6FPr0qDWtAGDuJTl84NvtTKQ55F1TY0hvWGAWLsbEUb0kzEJQsFoj2Z2bzoVs1kAUwO6SgH8UDp5cTW0DNr/u7wZd9T2UzCVr3dPpOFXC9bPHwMGseneT94OAH/YAhEj3pcHSdQHP3jJyRhjZawmkaCSSmRkvBUrFCgOJxqc9uSB7M3ZKdjqrmN0Ey/2IGdfIfb9AE+wVFFm0RAMjWoZZsFY7mEYaevqtEtnkRIEb82bGMKN07lrr8bTLe8U2Hu00HZlIPQQHpsOqTCRT2X+7ssMpleJWvHp1udrfhrjunqqCuYQmnjm
 WWhVO0rq
 dSJJp62UWOKLkKRAceKB04rp5NkPLNK0rikNKhnxqhrOlqH/JXISPH1WCinZHd3ZZ0d2xB2ooas8L2txwJNLbVaOG8NFIB9qCAkO8euhhg07+UaLVlbP20r6ofycbE3wFsC0BduVEiAVfoJkoj7fUsmZM/sIiucHp3MtlB7czzxNpZjByukF6nN9mjvrvo7OaDFD+DzPgtMhlLwqn8cxO06qEkX8abJrHgwy5wKLIOn6nifoeiIL17gogvLDF9A3RlErcVaO2y3TqPIXT3mVRUulBLg0caVAhZvgKoX8qH6bFS68d2VxgRET9Tw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 16, 2026 at 5:19=E2=80=AFPM David Hildenbrand (Arm)
<david@kernel.org> wrote:

> Looking at this, and wondering about "why do we get registers involved in=
 this
> API" I would probably have an interface like:
>
>         arch_kpkeys_enter_context()
>         arch_kpkeys_leave_context()
>
> Whereby you return a "struct kpkeys_state" or sth like that.

This is close to what I was looking for as well.

enter/leave makes the code look more like generic entry.

Passing some kind of state cookie around is inevitable in
this design and IIUC Kevin argued that it would be inefficient
(another level of abstraction) as opposed to just hammering
in the context we want, where we want it.

But I think the compiler will optimize that out by constant
propagation if the backing architecture implementation is
simple.

Yours,
Linus Walleij

