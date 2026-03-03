Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AFA17E67A60
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 04:32:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F1FED6B0005; Mon,  2 Mar 2026 23:32:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ECCE16B0088; Mon,  2 Mar 2026 23:32:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DD8FA6B0089; Mon,  2 Mar 2026 23:32:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CE0B46B0005
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 23:32:13 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8A0A3598AD
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 04:32:13 +0000 (UTC)
X-FDA: 84503479746.14.F7F1966
Received: from mail-yw1-f182.google.com (mail-yw1-f182.google.com [209.85.128.182])
	by imf17.hostedemail.com (Postfix) with ESMTP id 7B39B4000A
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 04:32:11 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=hev-cc.20230601.gappssmtp.com header.s=20230601 header.b=wVE4qXrQ;
	spf=pass (imf17.hostedemail.com: domain of r@hev.cc designates 209.85.128.182 as permitted sender) smtp.mailfrom=r@hev.cc;
	dmarc=none;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772512331;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vGFounTaPfTh3BSvvZSUHOsDY6NUzCCD/Stg39Oh89o=;
	b=JRRkC+fa3LL2/yS3V+r3GKXMDJEg29OW6ITO8Gg2JV5e+FU/taibm5wzubj1d/7NrUpEwR
	StuzX+JP2SLOX5K0N7YRV7h29c1OVuNey49FurbyxFlp5a75JhRiS7/6T0CYXz5/HS9Yla
	lBPgEZsl3NS+DXKxKEwhm0luuRkaW0s=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=hev-cc.20230601.gappssmtp.com header.s=20230601 header.b=wVE4qXrQ;
	spf=pass (imf17.hostedemail.com: domain of r@hev.cc designates 209.85.128.182 as permitted sender) smtp.mailfrom=r@hev.cc;
	dmarc=none;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772512331; a=rsa-sha256;
	cv=pass;
	b=HnhwzQZq/SRNj9cUtHgXY6VS/ApZS+/P61Epw3SzXz62snaK5Hdzg7p1lav8JBNHHurvJ3
	jwboXgESyWceD4IsqkmqL8tA3GJTfk6uXQ4WfJVRKx6DafuSTsHeDuXvvpDbDE4cloMMYV
	7121rywd3K3y2oT9BVM0iRHkM5XrcZw=
Received: by mail-yw1-f182.google.com with SMTP id 00721157ae682-7982c3b7dfcso50612837b3.0
        for <linux-mm@kvack.org>; Mon, 02 Mar 2026 20:32:11 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772512330; cv=none;
        d=google.com; s=arc-20240605;
        b=TXGP1AWdX9lLQoF9fEUVZ6Q6k4OBoRnDoDB6nD4+s1bl7yz78ZUZnvVxLnH+JnG1P4
         VjBHRx/j27rhZ3B3Fj7+ZaYG+LbFXyMGV0wIkC4jvoE7AVvf5fReo2Pxr5NP3+JIvsAL
         Pfrv03zaCCTIz/QfyVW+uf3kOzKNwrJUiE1CyjBDPXAvXTJTjMch9F1Hyo2gXN6JA4nZ
         8Nxz2WaN79hnU8a5zpEUaWvw5R6pREtYWg0Y9NaJ9ZedboXF2RGGjx9srx3JwAwsYc8q
         jTBQT0aAIOyKeuoz3KcKOdVQGB+0m7ERUV2Q6mhp7QzTftZ4YRpnOG+2QHLjGwRiBaxk
         r1qg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=vGFounTaPfTh3BSvvZSUHOsDY6NUzCCD/Stg39Oh89o=;
        fh=6oNY/TApmiFBzMs4cU6ST8JmuiTxH2KN0IEq6xHsdgA=;
        b=Sc6kd+SPZsqTa9l2jNYcy5LKRx/ld39LLJC93OR9rOR8E861BFRkkfNgJX5aLrAEax
         iSi34KThspbLrUAvC/m4Tuj6B3SKaSrSC1Hc4VueOxJwwJ6MbZ+ATo8U4oorGa32x6v0
         2m3UFFK99dUxLlCzxkXghd9ASiY6byYKomhtiCfGjqf1fp5WNWmSUsvwy1mBa9XiDc2a
         uNS9imy31aTMescR+YwvtK/oIxIL4KqCpYem6RFE3LgxMqTaIXQTHWib372LUrCEoXdr
         dZJx2cxmXS4FmMOtS0erDB21x25uqjmQxTDDdVzoMMpVTQiQmVN3R/UDd50H/WRiL5d+
         /xRA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=hev-cc.20230601.gappssmtp.com; s=20230601; t=1772512330; x=1773117130; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vGFounTaPfTh3BSvvZSUHOsDY6NUzCCD/Stg39Oh89o=;
        b=wVE4qXrQYtqLIvKdloPwSZiSCSfZLtQbrqONTBnkoAg0D4LULXR5bA0vXYQGn/n7Vb
         qnJ5kijRN5OHpDrpwbI4ac7KxfHjUhe75i4P6nENZJXidnP7ha2PuvpKH5ykkSMmDP0b
         qgjJaXSvJauV1lEH66C7s7WNoA5o7VET87jgONeXeROuAkKhGJZ7H+VCDtoRU4xBosX+
         XNERMIoyEvWIpyzVYdNOb3xW5CWNF5b6mb1VIBU2VwQhB61H2tpaAuq6TB6hQc81ND1w
         fAWJTqF9Ktk7FlOq+TrSjvAVCcG0yhb3G1PRV9sQ+thzNoGq/r70q0ORNvrqECAKRoZ3
         zY6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772512330; x=1773117130;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=vGFounTaPfTh3BSvvZSUHOsDY6NUzCCD/Stg39Oh89o=;
        b=kMz9CcYm65iMrmUvpWQBafbCvlQ5Ty+OdoWGxA24U5XW/2ZxIol53NRQPDnr7+z5dR
         RSRncZ7jh2B4a3LMoYNbyGd2wnNEVhnxr+AercRED6JwSuaYW0yv92j1Q/7EpG2YwtOB
         VdUp2iJch5m2aetNFuYSO3n15rgQ10qbQU+3oKj8FvtJETYaGqhupDZHjNNli+JqCmmE
         Hnoa9U/lts/hRQ5O8WF+/yYXDsiJInWKCAvH+bjxh/58HD0EXxk1gNdEfbrRbGyMhBmr
         W8mOPblTLIHaCPpFh5WLIY8vdXvmiaXA26Ak2tZ3Dm9L1V3y//r6RbP6fjW3eN9DtePH
         U6PQ==
X-Forwarded-Encrypted: i=1; AJvYcCVjPRuxL6mtxSCVTM3QanHhxoiNDrgrYeHPXUcwIBRmrXwHNDQI9kM9EUS49o/0fMaN7B7BIIRA8A==@kvack.org
X-Gm-Message-State: AOJu0YwcVAsjWvijclxCj9CtekHWf313jz7yU3lxKC3qwWDsJL0i+XVj
	bylUpGNKnjX1kmKjnWG+tTIp4b3vG8lknsSe0pQcKQlj1pdY2CV2hGpqn8s1Sw4nfybmA39eVR3
	bU4uMbTpbuBoT2cGScV1bF2UWq1XPkBvtrpzXpGs7eA==
X-Gm-Gg: ATEYQzz3RYH1Y84bESXWU23BYADLgZWDKiPgZvJi/xu/v30KAi4XHsFqpQWVaBhuOTc
	gmLAk2tleN68ii/KGSNvIM9gHh+gjNzWFKmsgjs3epB7JeYZ16W+hZ790FVrefqwQixIkkXmYvf
	XB/HFQuRsnEF55XGZvL5PqYyojRKExGgNvUVjCJbK8cLoLJYFS7xxDrOl73HIomWmPV3OTpdA4r
	L91TWp4BJvx1ld+paHlzqCZc7ioPRbGAIHyoy+whzVC34lmrpoYnAdQkcT/T0TU8GjJyKsJ3Tb/
	pzO+fMae72BRHcu3LZpbuOk+sJReTea4+ENd+PH1Lg==
X-Received: by 2002:a05:690c:6612:b0:796:31ce:6026 with SMTP id
 00721157ae682-798854c24aamr125016587b3.16.1772512330401; Mon, 02 Mar 2026
 20:32:10 -0800 (PST)
MIME-Version: 1.0
References: <20260302155046.286650-1-r@hev.cc> <aaW-x-HVQpSuPRA1@casper.infradead.org>
In-Reply-To: <aaW-x-HVQpSuPRA1@casper.infradead.org>
From: hev <r@hev.cc>
Date: Tue, 3 Mar 2026 12:31:59 +0800
X-Gm-Features: AaiRm53mvWIuAt2Ru8-fwHAqfutzxjaU88asfjV6R2vdeAh35ONU4AEXTH4oT_I
Message-ID: <CAHirt9j-appZ+Mn=8AoG=SW3Lrqi2ajdZDGp8yYWiBWkzBbQ9g@mail.gmail.com>
Subject: Re: [RFC PATCH] binfmt_elf: Align eligible read-only PT_LOAD segments
 to PMD_SIZE for THP
To: Matthew Wilcox <willy@infradead.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	Kees Cook <kees@kernel.org>, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 7B39B4000A
X-Rspamd-Server: rspam08
X-Stat-Signature: p4d7jsqpp89enbkdwub8je7a9teewfjt
X-HE-Tag: 1772512331-114062
X-HE-Meta: U2FsdGVkX1+6FCuzQeX3OjCfzx/PDYehWvwFdkpg+RpCGIV2WrSmJsUI4OsIbmbZwNynTQlrYSrWQKgggQRiQYe9vDE3iMhzsknG7uKzhr6QCllAn6FeNDX2EMVgLqC8TS4ejCMyk/qXms86l7sf8EaNrRjwyJGr5Ydry6GKjwQ9Fjzjja+X15+5HDs3khH0rT8qh1yuYhr8Z7iivYohbRAWz3JAQ8GVLjB6bchS45sKEt+0xeco775Xu88eW2iVLHFsSgm0K6/dmLd2SGbYAtCxDk+vKmfVNx6dfr/Pa+tTVjIPTxaByveJSLPAaMbcohOIz9D5U5AlRxadArh8BmugBb8vyvFgRFHCL32JbSXAzHsB+Z32pSxi6/5el23hL62gUtFc1XIcyNdUTq6gmJjqMZVLy2iRIzrAYWO4o3Lqbp4z3iNLHfmudTdkSXcHh2cOsAkiWCXSqrBr8uZ8QCtrpi/WTIQNnZ47hFjlM8DDUqWVPD/AaQ+wqG+a5eeuFq4aC4cwONsbtG4PVqC+nEYcx9bHhavXJRj9R1t+nSJCF7znVxTquKL+8XoBqljyO6Wc8e1834UXjMdzXwwrFCl/3uD7UGu0crTBeiDQKW0k1pOcD7HkcRrLo59XGX7cYAXqAuZvnVKhxrKZSD9iIxvCRo4DdhqOa1Ef23LQk80aaPjYbdfWzLJr/ZoM3aWuV8NXXwIQhduQn90H9235v3etTFot1ytlAxBopekKZBZ2/+xnbzWuMuuVM/79vhFZg/rFfNOr+NyRRXEb/wqRr4PQGEs6ukA7FLMlPFFpUsRRqqGI359dQtOLpndOrdxSvE/A0nol3h53xflXzRCZAeQiQlNiaUjZCvPJanICOz5E0lYEXCd7fbnYVSiQP5+WgXXD7/+whRGktjlX6Q8OqcF+2vFe/9zVUIxR2jvA+tP9d3Tl0fBNbJZOLXUxCV9Sll+gPvuBK3N444CoEqT
 OjdVrIa5
 FwyW6tTFVN3Tw5YqLYVOOGhF7YKmi++1Ee1VyzVVtbQ2M7BSie7qIOu/UxD0LXTOjn0c+lAIDukbzWaFe/vL8DoY9LyLqx/EMyD/TKmo5t1hjFpCRHyhRdRFrMoNHt/7++rmOiYfSEV9r6cIfR5s0yic9mPuXpIiE1kmBf/smfuiWBqzRyrf4VOSmjcMzuQG6cEWSRe5V4K8ci+3lkq8zmLDv/9IhRRnZsXV5Fdl59QuqTeodBD/rJDTua868rMIvAS282VXlird+bMZmF1i4BtNM8aU7a1VdC23NJ24ai2bRFRFi3BjhDn/QWmQBPfTyjvmkZMToMJzLL5N7uEw9VZqMu3ol0kDVJk2ISZAuraxzZwljB+8mZxKulqyKywU7LCBi4SffhJIhxgLjTQz/2R5G6vBbDbZ1sPiT5/tudrwd7i/hgFB5XninaQfKxIYWPCfUnBB+/IvZJ7iz5yfv8NL/cjao417bLczsys6T3n1M+1xPt4BFmOjUPA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 3, 2026 at 12:46=E2=80=AFAM Matthew Wilcox <willy@infradead.org=
> wrote:
>
> On Mon, Mar 02, 2026 at 11:50:46PM +0800, WANG Rui wrote:
> > +config ELF_RO_LOAD_THP_ALIGNMENT
> > +     bool "Align read-only ELF load segments for THP (EXPERIMENTAL)"
> > +     depends on READ_ONLY_THP_FOR_FS
>
> This doesn't deserve a config option.

This optimization is not entirely free. Increasing PT_LOAD alignment
can waste virtual address space, which is especially significant on
32-bit systems, and it also reduces ASLR entropy by limiting the
number of possible load addresses.

In addition, coarser alignment may have secondary microarchitectural
effects (eg. on indirect branch prediction), depending on the
workload. Because this change affects address space layout and
security-related properties, providing users with a way to opt out is
reasonable, rather than making it completely unconditional. This
behavior fits naturally under READ_ONLY_THP_FOR_FS.

>
> > +#if defined(CONFIG_ELF_RO_LOAD_THP_ALIGNMENT) && PMD_SIZE <=3D SZ_32M
>
> Why 32MB?  This is weird and not justified anywhere.

The 32MB limit is intended as a practical upper bound. With 16KB base
pages, which are commonly used on some 64-bit architectures, PMD_SIZE
is 32MB. Larger PMD sizes (eg. 128MB or more with 32KB pages) exist
but represent relatively extreme configurations where alignment costs,
virtual address space padding, and ASLR entropy loss grow
disproportionately relative to the expected THP benefit.

On 32-bit systems, this issue is even more pronounced: PMD_SIZE can
reach 128MB or 256MB depending on configuration, which is clearly
unreasonable as an alignment requirement given the already constrained
virtual address space. The cap therefore avoids these pathological
cases while still covering all realistic and widely deployed PMD huge
page sizes.

Thanks,
Rui

>
> > +                     if (hugepage_global_always() && !(cmds[i].p_flags=
 & PF_W)
> > +                             && IS_ALIGNED(cmds[i].p_vaddr | cmds[i].p=
_offset, PMD_SIZE)
> > +                             && cmds[i].p_filesz >=3D PMD_SIZE && p_al=
ign < PMD_SIZE)
> > +                             p_align =3D PMD_SIZE;
>
> Normal style is to put the '&&' at the end of the line:
>
>                         if (!(cmds[i].p_flags & PF_W) &&
>                             IS_ALIGNED(cmds[i].p_vaddr | cmds[i].p_offset=
, PMD_SIZE) &&
>                             cmds[i].p_filesz >=3D PMD_SIZE && p_align < P=
MD_SIZE))
>                                 p_align =3D PMD_SIZE;
>
> But this conditional is too complex to be at this level of indentation.
> Factor it out into a helper:
>
>                         if (align_to_pmd(cmds) && p_align < PMD_SIZE)
>                                 p_align =3D PMD_SIZE;
>

