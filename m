Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B9374103E302
	for <linux-mm@archiver.kernel.org>; Fri, 13 Mar 2026 00:10:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 27A5E6B0096; Thu, 12 Mar 2026 20:10:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 223CA6B0099; Thu, 12 Mar 2026 20:10:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 150D26B009B; Thu, 12 Mar 2026 20:10:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 02FF46B0096
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 20:10:21 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id BF0431404F9
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 00:10:20 +0000 (UTC)
X-FDA: 84539107800.08.343660D
Received: from mail-yw1-f175.google.com (mail-yw1-f175.google.com [209.85.128.175])
	by imf12.hostedemail.com (Postfix) with ESMTP id ADE5F4000D
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 00:10:18 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=hev-cc.20230601.gappssmtp.com header.s=20230601 header.b="RuWCRJ/c";
	spf=pass (imf12.hostedemail.com: domain of r@hev.cc designates 209.85.128.175 as permitted sender) smtp.mailfrom=r@hev.cc;
	dmarc=none;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773360618;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=62xPx8+aZwJ3Pgb8Nz0+Ol4Bn/gHH5Wgi7mQXMN5Jg0=;
	b=C1LlvyItRbtXx8WMs/dTl4S+TMw581LmhUUHRlqY76ptfZ3sjbafbgSHz5a+H/YdjtMgx7
	/400fIdXt4Im3ljyzo2yA1ettpQUL7cbTEHFWQkZ4mvLYKh6rkf/IwCJ/UqNfC1iUumxv3
	P8yxnKdfLe81oW/zAjTMXLcbLye+v6M=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=hev-cc.20230601.gappssmtp.com header.s=20230601 header.b="RuWCRJ/c";
	spf=pass (imf12.hostedemail.com: domain of r@hev.cc designates 209.85.128.175 as permitted sender) smtp.mailfrom=r@hev.cc;
	dmarc=none;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773360618; a=rsa-sha256;
	cv=pass;
	b=1jElG2VYylDBX39WlP4f21Kg91pG34kcrJ4NgYRY4K4+sivaXy3IaMiPpgAr17K1e4/ELt
	LpgpBOjC3gKMDkH3r6ethW2u5pLAoug7OuhfVMtNndFLaQ18PHf7tJwfl9KFMnbbBYkpIi
	Xl2HnsqHNwT0uLjRXsbpUjfHNg3a6No=
Received: by mail-yw1-f175.google.com with SMTP id 00721157ae682-7986d231b3cso41979367b3.1
        for <linux-mm@kvack.org>; Thu, 12 Mar 2026 17:10:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773360618; cv=none;
        d=google.com; s=arc-20240605;
        b=gI9Ac9ZtAtzZDa8LGDicrbxS4L3vp1QKfOMur+h+0Fyfcgpf/lsu2BO+FaUStksN9M
         mNQ5Xrof0xNNi3LkkwL5xgSH2EdXIRnTjRqiZzxcGjqWgn3Dh1SU9jUJPgQMvGOoeflx
         ppCkfXyNd7nPJEuy1JH3FCfw3WFgS/umxLyt0qwQ7TiV+A/bN599icMT+jDMKDnkgG0+
         +GiFlHKD5f2sIOKwEs9JuR/wp0t61RzdY5GiGlaRNrFvr+Ix+dd+VwMlmdqSaCDHXZjS
         sscuz2YIocGXizAvJdhSyWcaBHM4Jy0tjNsO51CYhwvmuK+e985TN6oKTxhfg6OOz9ju
         qi/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=62xPx8+aZwJ3Pgb8Nz0+Ol4Bn/gHH5Wgi7mQXMN5Jg0=;
        fh=Bxsup95/1VlqPygBx9hwhDEOQI6p5iPIxkTUS0dG8WU=;
        b=fD7hcMHXAfSrA3sGPhGnL9f68k18tz1E0bFw64YqYSMnamKXvh40EQkqik/8Ar/7vx
         sTx4dICbMsNqfuYx3dxeof8De+wvAvaKqXJ8KOrNjK7X+DD0v35/zkoCZFpjaVd6vgZ/
         aItMm1vBPm709BW49oRKsqg2HzMiUGaHQ2n7u/XASyOMuCKoZHvKruT1vDg9Ha0mnDT0
         xh4yB15EIDf6aRwnU2ipMhc4bO5fa50ddM3MUyE2rYNl19Q+XEILqWqyUqf/nDVIElJx
         YvvbdWFNq+a10XNuB5w3quT5lMEChNsIo7/QmvR5rfGbXoX8rXR1G3BAqAbU6nNmkSIL
         Ie/w==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=hev-cc.20230601.gappssmtp.com; s=20230601; t=1773360618; x=1773965418; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=62xPx8+aZwJ3Pgb8Nz0+Ol4Bn/gHH5Wgi7mQXMN5Jg0=;
        b=RuWCRJ/cxf84DlwHl+f68R87jy7wR/DiUmEX4CUh8UxXctyBsoa307TZLh+PpknU8b
         tW/XHgM12nPCUc+3dPZfYE5ySvgY+U+M2bNDiMWMzv/uEXXGBrxavM4HCXGsWRm80Pey
         2Odn8fOj8VIC423uSq0nEbf2yu/x8/SgkWJ8m6L3IF0azefHFK/67yISykhbYnxnuX2w
         tDeX+6/NJa6FNGiOp2G1kptzWePGJ3nO4EEqvX5V9uADuujyUoyXOt9GfQLP/kIOQChR
         RbXHVA8+rZu2FOE2030qoX48Ogje+GLq8u/5MLzgYfLQi452Het1Q99VAYbipt0JePRp
         AbRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773360618; x=1773965418;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=62xPx8+aZwJ3Pgb8Nz0+Ol4Bn/gHH5Wgi7mQXMN5Jg0=;
        b=IEqM5Xu/VhylhfKvPpntrgfarB4cQ1jDxFmCZvWJXmZIuFBJbGSZ4j47n76xGJL2UU
         z+gSV+Z4nNVMTCkt/6HrmMrGHbP+sfgrA4CUOuM4zhPhvQkOPMx0o5vz+xgICSVtTojh
         /kbBwVWTrVZYr/9UYyKK5JJFDM2kAOTPEZfzfeKuCB8pV3UrhRf0SGu/hBKGPQjSUEDG
         vpPXp8nAnnj1Bzd7tFaP3c61/gOLeNPm1YYMqiWEuLyC1sHndyHZWbaAo8mZ+IgFSqML
         T45WLX9Ugw3GYFFpkoVi2SIpLJ3InB3ybG/6EhkSLWqnuCbEbF4KCELdN3SwL7Zzbm00
         Pohw==
X-Forwarded-Encrypted: i=1; AJvYcCUYi2RA6qj+nj6Pf0mwyaGrDysjHrmtWWFM6NnqjdoMiH+dI5eK3COaVd7XkuWLfCHj/pv5QwXX8g==@kvack.org
X-Gm-Message-State: AOJu0YxOeVDuomcLMmn43fRf7gM4/Sns7lQJigtoFOAgngUn8lKicoRr
	HB5KiMLbc9LUji/TQgRmqlba0b4XvbPZ6/5flcVLF/SvvLBuiwIDtjqKPeCTPKniT+FL6vjIc2d
	jQp7UHmfuQHfvwTXhq14G4Qb65BkZGhxsnlbs6G/bdg==
X-Gm-Gg: ATEYQzwm5BIHk6aQyXZfFxHmrlVhDVJqEzf2Zp6c5Fim0z6sTfX+YtOA4n6U4UA02NX
	CCIHc+wOCMjbkwL/PWnq0Ts3Obs2UivA8yKi3MiSzSYGukMofvSIrmr03OqT0CVwDtDaEeMZ/WB
	Ycrda+c/PQNtamzRj6cQKDYAjU0UUspUab4GLouZG3qSb5U7czyywr2OaCFrkTzHOo0PyVP/z2l
	7oxwZdhh967fRg/VmlCkz3eWKCOl4ZGpiMrtsF7X+zMprLDtyDubiQwS+Y3ZJ4og5VXLzHOr+vU
	B2tQURZ9GYkXvpRBrHPdsBcXTeH6qSjsyzxGBewxnQ==
X-Received: by 2002:a05:690c:46c1:b0:792:7745:72fc with SMTP id
 00721157ae682-799475e6f5emr49906397b3.21.1773360617696; Thu, 12 Mar 2026
 17:10:17 -0700 (PDT)
MIME-Version: 1.0
References: <20260310031138.509730-1-r@hev.cc> <20260310031138.509730-2-r@hev.cc>
 <bca4ea00-3052-425b-8f39-729d504fd4db@kernel.org> <7937d789-539f-47db-838f-c153ca6cfc50@kernel.org>
 <CAHirt9gpZ98HQCXStEQMMfe6TEnSzmD04BM313h2LJGJ1K-hJw@mail.gmail.com> <60ba4311-01f8-4ff3-a2df-e1b3fb6db699@kernel.org>
In-Reply-To: <60ba4311-01f8-4ff3-a2df-e1b3fb6db699@kernel.org>
From: hev <r@hev.cc>
Date: Fri, 13 Mar 2026 08:10:06 +0800
X-Gm-Features: AaiRm52jdG3nfACWernvRkLmy2s6N34pUBtBRSkEgJDstHEPy6GnGv9garrc1XA
Message-ID: <CAHirt9gZbKY8ouvPYZh8=i-9Y3honXKApE1Xs+M2RGdNz66nSw@mail.gmail.com>
Subject: Re: [PATCH v4 1/2] huge_mm: add stubs for THP-disabled configs
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Barry Song <baohua@kernel.org>, 
	Christian Brauner <brauner@kernel.org>, Dev Jain <dev.jain@arm.com>, Jan Kara <jack@suse.cz>, 
	Kees Cook <kees@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Matthew Wilcox <willy@infradead.org>, Nico Pache <npache@redhat.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Zi Yan <ziy@nvidia.com>, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: ADE5F4000D
X-Stat-Signature: ftepfygemsrdozsa1f48wqmsug8qdd94
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1773360618-811863
X-HE-Meta: U2FsdGVkX1+db2Te9WoQRGYxkR3M2SIqmtkCuWnL/5GmAtPOQMf878cj9d/3JOH+vQfeH5wWk486TVQBZUXO70dXY9HQtxA3pk3CpRuvQN9d2K6iasinbHw2rEH7Ud940TyuyE6+MkjxfWohm+w/al9bq9NqJLt4QSLTN9SDgl/a9ns3j6xg67aCX+mgdB1QNVf6XbtVjbU4DdjXiE1OBUcs6rti+I3oefJGXm2nT4/VfPt2rjCM/O5twLtIEsRZmbrtJcASRJuNWPfauGSbPykBF+FgW0v98gTISEUHhjyWsEUM4a44i7BBVRWtV5VTQGW9BPoPc/ujR6w4ij9yUkikSGN0If2mmpy+yA31xJOs8EdHb0fFqrqPDXV/VEOJmLRaOY41RrjF1ze0woUvhYA35o/mZxLSBsW9q6rQkP4wYDjaR01wNuN2+c712XD6xtcoEqont5WnVUgx11a8gyO6kp16VtobuON5y3iaC+cs/haoDgBoKhRhxhT8W1WyCWbPvwG8MsJQ9ljwb4SkDnawJRoPhjOgKFz8Lg6WxI7F45bJEICR9YzLjCw4odxCP/aTNn0P2chBzQj3n7ZZIb57TUHJk6HgOoY5HBwrKGmuO1fwZ64UjYhuQsISlfDZacVIBMhszLgnIHMuUtpg+rbrCy+zGScy1XB8cdYL4mFRBarF/t9yBrjWg5+EPTftU7GxHsGAi4w+H+hcJ/U49shjfHscIGgxDxx1L+a7dwJNzppWXitkB8H/Nsy6czcVWNgEDIr+y86p6iua/Mu5W3yclSlK4vUt+xkqBqvJ+FaKayaQKAO/3RlKnCQUNmsn/mHD3V/6SF8lyQI12nkWyoNfyXa+kFAZyBdG5DGAOpjr/MrsPdF9aKjgnViqO8ivbJ3qWu06dfAoQIhSE8fdm9Ci7ZP0hfzKG/rokF2eRIV3Q4vSF40zOCMzc86rjxIHFPCza/qrZgKAOFf536z
 CkB6UePK
 WRjlfPIAxmagWRkEsNw12QrvhaKxH3nG6FJ7RQIr3+kHEamwvZ/emkQ18gJMzCalmk/RgeR9Elap/1OkVvb4wLRA8f1RmCmMTNgr5eS6nXMNDJTXgNKJ7ZFv34GRC0B8zRkFjXGxcpgBlsUrQFxfOdQduLrQFtO/l72Anr2Z84frphPhu9+U5zegyV8MCt/5vZbROb5WSJr+vAxkKGLg2FD0VH9y1lReGAGbytAuNt8bebiiNtU47f0Ks4DUVPnuWGVFtw5ncjK7C63p1hw+1sf/NWbYEWp0SvnT9t17Z6rq1PYXLRsps7d0sJ8d2a1HxgwuSlIP8z5cwU9MeidjRA8qY6zEt2RCoHm/EblfoynY4s54ozJmT2Y5747Nx6DBGou//0NTY+4OQcl8M5eeVjvmIxLX1l7y0ytIbgmV/7Pgt/Ivzx1Fv45xMfqBiAYAiP2aY2BElMBwI+tNBTxlWSoDAPlcGJC/I7twXiDtQoH77xuw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 13, 2026 at 12:29=E2=80=AFAM David Hildenbrand (Arm)
<david@kernel.org> wrote:
>
> On 3/12/26 17:12, hev wrote:
> > Hi David,
> >
> > On Thu, Mar 12, 2026 at 11:57=E2=80=AFPM David Hildenbrand (Arm)
> > <david@kernel.org> wrote:
> >>
> >> On 3/12/26 16:53, David Hildenbrand (Arm) wrote:
> >>>
> >>> There are other ways to enable PMD THP. So I don't quite think this i=
s
> >>> the right tool for the job.
> >>
> >> Ah, you care about file THPs ... gah.
> >>
> >> Why can't we simply do the alignment without considering the current
> >> setting?
> >
> > The main motivation of raising the alignment here is to increase the
> > chance of getting PMD-sized THPs for executable mappings.
> >
> > If THP is not in "always" mode, the kernel will not automatically
> > collapse file-backed mappings into THPs, so the increased alignment
> > would not actually improve THP usage.
> >
> > In that case we would only be introducing additional padding in the
> > virtual address layout, which slightly reduces ASLR entropy without
> > providing a practical benefit.
>
> Well, that parameter can get toggled at runtime later? Also, I think
> that readahead code could end up allocating a PMD THP (I might be
> wrong about that, the code is confusing).
>
> Let's take a look at __get_unmapped_area(), where we don't care about
> ASLR entropy for anonymous memory:
>
> } else if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) && !file
>            && !addr /* no hint */
>            && IS_ALIGNED(len, PMD_SIZE)) {
>
> Interestingly we had:
>
> commit 34d7cf637c437d5c2a8a6ef23ea45193bad8a91c
> Author: Kefeng Wang <wangkefeng.wang@huawei.com>
> Date:   Fri Dec 6 15:03:45 2024 +0800
>
>     mm: don't try THP alignment for FS without get_unmapped_area
>
>     Commit ed48e87c7df3 ("thp: add thp_get_unmapped_area_vmflags()") chan=
ges
>     thp_get_unmapped_area() to thp_get_unmapped_area_vmflags() in
>     __get_unmapped_area(), which doesn't initialize local get_area for
>     anonymous mappings.  This leads to us always trying THP alignment eve=
n for
>     file_operations which have a NULL ->get_unmapped_area() callback.
>
>     Since commit efa7df3e3bb5 ("mm: align larger anonymous mappings on TH=
P
>     boundaries") we only want to enable THP alignment for anonymous mappi=
ngs,
>     so add a !file check to avoid attempting THP alignment for file mappi=
ngs.
>
>     Found issue by code inspection.  THP alignment is used for easy or mo=
re
>     pmd mappings, from vma side.  This may cause unnecessary VMA fragment=
ation
>     and potentially worse performance on filesystems that do not actually
>     support THPs and thus cannot benefit from the alignment.
>
>
> I'm not sure about the "VMA fragmentation" argument, really. We only cons=
ider
> stuff that is already multiples of PMD_SIZE.
>
> Filesystem support for THPs is also not really something you would handle=
, and it's
> a problem that solves itself over time as more filesystems keep adding su=
pport for
> large folios.
>
> So I think we should try limiting it to IS_ENABLED(CONFIG_TRANSPARENT_HUG=
EPAGE),
> but not checking the runtime toggle.

That's a fair point about the runtime toggle. Limiting it to
IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) sounds reasonable.

Thanks,
Rui

