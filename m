Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C919C107BCEF
	for <linux-mm@archiver.kernel.org>; Sat, 14 Mar 2026 02:10:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A056B6B0088; Fri, 13 Mar 2026 22:10:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9B27B6B0089; Fri, 13 Mar 2026 22:10:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 894666B008A; Fri, 13 Mar 2026 22:10:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7A5636B0088
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 22:10:22 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0B30B1C283
	for <linux-mm@kvack.org>; Sat, 14 Mar 2026 02:10:22 +0000 (UTC)
X-FDA: 84543039084.05.E3B6398
Received: from mail-yw1-f169.google.com (mail-yw1-f169.google.com [209.85.128.169])
	by imf05.hostedemail.com (Postfix) with ESMTP id 0CB1D10000E
	for <linux-mm@kvack.org>; Sat, 14 Mar 2026 02:10:19 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=hev-cc.20230601.gappssmtp.com header.s=20230601 header.b="D/o8os7Y";
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf05.hostedemail.com: domain of r@hev.cc designates 209.85.128.169 as permitted sender) smtp.mailfrom=r@hev.cc;
	dmarc=none
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773454220;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7ejtXFezvM4/MIrV0ExVdbB3cmL15fMSqz8fjmYgx6o=;
	b=F6PufaRe5ZY7kL75ZikFP6JEv+AQgOtgx3IZIizc+HQwrcnHkcpLFa8ij7UORm6lri4b/x
	zmKsatahnEBzBL94rL266coi0D7/KghDCZmM/kStqMbJTkUPckTRmVz/I6tZXPY7V74Gy3
	IqNmiOP9aqQ69bcuSKnLvaDhItmao+s=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773454220; a=rsa-sha256;
	cv=pass;
	b=F84DfZ6RKJsX3I83AoR5wH5wSJpUnzUqZqDR5UjMzKIFeI76rFfn3XIm/oUGExluWaFjyg
	wQmTs5GTO4Wi3/RdQaEPQOz2BVcEnb4pw8dH8rzRRfbx56qadamPexWoPfEBJZqTIdxLUl
	iu6/FW/rAvapumsU2p6WSmBULKMEmEY=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=hev-cc.20230601.gappssmtp.com header.s=20230601 header.b="D/o8os7Y";
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf05.hostedemail.com: domain of r@hev.cc designates 209.85.128.169 as permitted sender) smtp.mailfrom=r@hev.cc;
	dmarc=none
Received: by mail-yw1-f169.google.com with SMTP id 00721157ae682-799001d73bdso21852967b3.0
        for <linux-mm@kvack.org>; Fri, 13 Mar 2026 19:10:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773454219; cv=none;
        d=google.com; s=arc-20240605;
        b=Hb2AFh/IfyVX5hOhb0Wx4svTA+gNEc3TUhCUje13R6IPfURKuDXD9UavojqhN4ClST
         tR+JAk+0ZnB5riXH3ijtKYJyKeqZrsVeGbqN4UWAnMKN1Uut5LryIDqzWG5ZVAOWWXb5
         7gxfJxPUfdgbINkd59DvetMvFjh5CC2qONr4klnOnFbQ0mrdDi1g2uGLYgWkXqWWnpdN
         tF4tKtkNFImbvAEjrOgBZ3LVjdEfLEHP/yFCjYptHuL+FvSh8EDaCnyINBpKgqmVFf6u
         5GXP2vX28T3KMoXZz0Ny39sQGBOzdXEXRuhkli2Dk5iqi2ne2t5lQQDb1tpNifkBlDgs
         PCjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=7ejtXFezvM4/MIrV0ExVdbB3cmL15fMSqz8fjmYgx6o=;
        fh=sslgnfzPzyx4H9vr/QSr3mvJMVQ4Px0FzfyPYuTQXuQ=;
        b=XriFysaPaIHrwhB2NV4WED6RILp7dBF8mRuhZkU2U/QnJltA/3tie3VR1pAGrj+spC
         E9GUys8F1FeEhwQm74hgcY8o3nuiUvGHej28TYaQmVDY/FroGaKFovldU7k4zBB2Mdij
         dhEy9QJL4msdLbdV1EDko/ai25jRx/fPRXGcHUyDcBqob9dj7qzpKwkW0UJks9Atnyw2
         2gh/4W+YzVEZ9gsgvXpj4qjnvzLZdNeBBCe31lLHwYVP5O9BgKZeJIwwCseaSMIGIwmN
         pchk6gaBuf5lVmCfvkr24elM1/hldogB92zjXrZj4ih8/WNMxYPO40ZxcN1fE8+XGkvE
         6YPA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=hev-cc.20230601.gappssmtp.com; s=20230601; t=1773454219; x=1774059019; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7ejtXFezvM4/MIrV0ExVdbB3cmL15fMSqz8fjmYgx6o=;
        b=D/o8os7YymJeMq/KrHASj/0hMZpdZlK89O2XQ0fdjRqySIhWX++Vzk/6y+RGGujHFF
         TQTgb0RKi/fggYJL8myAqbJPAkqfIPIv66kDWVYd3XLLTAOSuzkV+NVhYJvEMr/CSl33
         krCUivnAv7noqNvEqZWCDxEL74/c1o9sBF7wgfNlXyWiuHcrj/nr6GxTz9aEH8rR+plG
         79MVLLxvOGkHWBQu4VazoVZqQejCL1222/wOEb2poJ9N3mEfTwGkQM9/kjul+XTskHPk
         DYfUNMG2plS3hxVcYrF0pZ6VjjNynBt6k8ttl1ELxNHy3NCS+D2/I6OOqC/XyPA6+qKd
         ondA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773454219; x=1774059019;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=7ejtXFezvM4/MIrV0ExVdbB3cmL15fMSqz8fjmYgx6o=;
        b=hTEh13wvBRNF0yI5q/ksB6iUuYpBTn2AVp9aHDySnwfhqEyBgtU/ru+ofPRdwPdKeq
         b1KukE+eSKeNXgxXxwj/moT7gfNOMCGRQSrCeoU1ocxID8dyEIF74HYwEGi/sOSb6hQv
         ls/KLxJ9WQXzUOJd4A0lxtcdLBQkcenxU6hP+MY8siIsxtNxOUHWROe87eMuuQccc/xq
         SKXf2LTWbMN9F86DgoaXY4QyWZ/6N06gMbJmtZpi8Gl5m3wzWfU/tQwOY1iY03Lf6gIr
         ZErOzdTl4Qsk8wCM70G+g09NQ2nNeaVXF6N3E2m/cpbNIHhnM/KJy4rZiQwEzUhSDGmp
         wPlA==
X-Forwarded-Encrypted: i=1; AJvYcCUNfjXILZd/iTmrLghICoePFyIQxYfRcncDjADR9vnQQu/ZD3oQQ200r4ifzDS+9ym/oPcop5J2dg==@kvack.org
X-Gm-Message-State: AOJu0YyRi1jTmKbKJNtlv4maRbz37Kwpe0MMktD7MeiPEb1Q5cSOjrVY
	aSQLJPF9FiHQfvwCM9dpxpvk05Zv0sEdpbQN/BB+VzxEBd+df0yb7jgVgrqn0TkYzJE64NpSPfD
	5MoP1P4G7xpmlj4MzNVczKhvUOPGNcE8N7ibIqZf04g==
X-Gm-Gg: ATEYQzziXO1AxUi9Es3Gei8WZB1opiJdkeSwtxdvNyChT8RCXMIi+XNAW/InqmKH3Rg
	6BxIlZKwTDasW5UcDWYDGSAhGT0WleOG2aQroKpk0EHD3rdyp/5kFw6kgCrX3g9zF/QA5FwU9ym
	zfGX6o1ZtqbP53OPk43L4UvbjSXCEMx3CC0YIFGJplPuk0Q+clZdNeZwlLBM8Ci1cIfQBPYfuzP
	3dT9xBl12n3et3ZoADyks8/gBrxNioV/dDfnCk6JQiNe47N3mRn99LIdyhvX7LosG/j12RTGR3N
	mB1kdDISBJ6Ar21dc5XmjsURczRBYSIzfS/9PEomX+NUrymkRZPU
X-Received: by 2002:a05:690c:6e08:b0:798:7498:4ae4 with SMTP id
 00721157ae682-79a1c1c3f38mr54139577b3.53.1773454218867; Fri, 13 Mar 2026
 19:10:18 -0700 (PDT)
MIME-Version: 1.0
References: <20260310145406.3073394-4-usama.arif@linux.dev>
 <20260313144213.95686-1-r@hev.cc> <d3f60289-3ea1-43ce-9271-58c8b79bf7a0@linux.dev>
In-Reply-To: <d3f60289-3ea1-43ce-9271-58c8b79bf7a0@linux.dev>
From: hev <r@hev.cc>
Date: Sat, 14 Mar 2026 10:10:08 +0800
X-Gm-Features: AaiRm51ZT-5Id2ShpKb8C4cESB_JJ6PpokKQgHEX0HKVk-NcE-akKpRzUvPAXoE
Message-ID: <CAHirt9g=drGaeNN7C1hbND4=zXQifhQyP4cUaCz27=tYpHYgfQ@mail.gmail.com>
Subject: Re: [PATCH 3/4] elf: align ET_DYN base to exec folio order for
 contpte mapping
To: Usama Arif <usama.arif@linux.dev>
Cc: Liam.Howlett@oracle.com, ajd@linux.ibm.com, akpm@linux-foundation.org, 
	anshuman.khandual@arm.com, apopple@nvidia.com, baohua@kernel.org, 
	baolin.wang@linux.alibaba.com, brauner@kernel.org, catalin.marinas@arm.com, 
	david@kernel.org, dev.jain@arm.com, hannes@cmpxchg.org, jack@suse.cz, 
	kas@kernel.org, kees@kernel.org, kernel-team@meta.com, kevin.brodsky@arm.com, 
	lance.yang@linux.dev, linux-arm-kernel@lists.infradead.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, lorenzo.stoakes@oracle.com, npache@redhat.com, 
	rmclure@linux.ibm.com, ryan.roberts@arm.com, shakeel.butt@linux.dev, 
	viro@zeniv.linux.org.uk, will@kernel.org, willy@infradead.org, ziy@nvidia.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: ba71jo1fat7hxcgd53rzynsixfig7ug4
X-Rspamd-Queue-Id: 0CB1D10000E
X-Rspamd-Server: rspam03
X-HE-Tag: 1773454219-467125
X-HE-Meta: U2FsdGVkX1/pRs3V41RuL4C9R3G4FTrIg2TEMv7LP8wCn1Hf3wE79rodx5DFIhSlWm6uSE1qo89MKaY+TZmy+DuH85HtSMT2coqwMwdDs8DUiPytXGLOWvg45IWQc633nTRYt9RI+yg/qXu9I21tdQnCybl3+iN7eI70jWkak1h2MACznagszigopt70Atzw6VW9w/JaObfWPZHHFGzyDqu2cO0WVkZwUmJYTYM/X4xYSEyy6E1ucnRzpTNLj6SQhAUZyN8tuI8+45+mhwDiOpJV5KCaaPEEIvyxT280yCirwiwTyZH8XyW9ylAFQrAlFde7ounhZGL2F+twff6EhJq5W9tbaRvkajV0hsLJ3sO60LH5yb7b48VIAgLjQGBi6TthpYiOUwTV4ckdSh+4198DBvD1DM2S/7as27UbVHWHz2sjb94AbTR4kGLih734XuL5/Ap0HgnYf4toj1wZjDUVgFT1QXW4tLziJk788vejByoGbV/GCfYTWSkvfIzLbOkmlxBie4ibXLBXUiPMZrnD3pUOWtzfJWVlw+2T1QRA+csRznk5f8hoBYBlcTO5HXabGU9GptqD0TKdMQ+WrpXXryzMZOpNA6rtcunP4qXdUu6v1ihrodnG0lD7If6Y0gEIaQi4AtM4PuvQu07ddQ+HOYQt9C73Q/oBRjkY2JTSJYu4iG1VdFBEnjChIrnZbpmwJC+G4A59RoM100rcVPn2ovFs04jSEr5ablnaaYyn8xaxY5Xjlq147tFroPCAoYp/AyRWsJzmJMSfZbrT9maXgdYxwm3+HRguyOaLAhqzw6UzVI8jSgSl2kf9Y7+o1J9kZu2crUn5040jhOMJLSB9gm7zb27kRlIH2xHkQgSfMSXoyTfAqrdH2PjSw1M0fqOO7zB5/YAu1nDfLAUkSKHaoJ+baXqVtl8lrhsGPGwLOrxyWfnJwAwpd9Dvwz2EEq8BO9rWo2jyVKvGJTE
 FiB1Fzli
 8ZOTTuxL3TNY2maKqFnthDEwVUIr+1xG2S6cdUlkAnmu6EKF94V+YbPBm1pMiZ5SuuWE7Cdd5Dr8rHvdt3tQAh2FmPeMINS1vV1YZ0TxgmDg//YDrGtIzVji+tSfdcSOErojA61n2QWeAQU/tR9BCkREb0TorJ23tEAYuGYaXivD8LIKL9eNRDyViDhCM6x4PXRlg8ehyVGDA0CdYXiZEo/OsVBh1dbXTvNHCyVARwbtL4LmAE1v/drtiiyGE/tDunI8xMTFHovKdF6ThOjIuLYToaWu6TKYN9nGfEC5BiKWlZjDmYqOUw6kZwcXcw3TqtvwSekkUPsd9v6DTrmO672m4ZoD3wcDod1QaxY+wIx8TTSe7kh9ZgmDlOQkUe6YveZs8GMHgVTmTYq2Xr9ceaTsKERgL/q8uXTaBq9DMsFnA5rLlAPkLKub3laOKVl0eCLulRArB/CBVi27Wi8aFO2OF855zdVsSQIwhxvv5El3wNmNpceBjLzgqqA/AC3aRQr8wFMGlSmprouBQmSbzrGxRJLiaz8rydVBa
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Mar 14, 2026 at 3:47=E2=80=AFAM Usama Arif <usama.arif@linux.dev> w=
rote:
>
>
>
> On 13/03/2026 17:42, WANG Rui wrote:
> > Hi Usama,
> >
>
> Hello!
>
> > Glad to see you're pushing on this, I'm also following it. I first noti=
ced this when rustc's perf regressed after a binutils upgrade. I'm trying t=
o make ld.so to aware THP and adjust PT_LOAD alignment to increase the chan=
ces of shared libraries being mapped by THP [1]. As you're probably seen, I=
'm doing something similar in the kernel to improve it for executables [2].
>
> For us it came about because we use 64K page size on ARM, and none of the
> text sections were getting hugified (because PMD size is 512M). I went wi=
th
> exec_folio_order() =3D cont-pte size (2M) for 16K and 64K as we can get b=
oth page
> fault benefit (which might not be that important) and iTLB coverage (due =
to
> cont-pte).
> x86 already faults in at 2M (HPAGE_PMD_ORDER) due to force_thp_readahead =
path in
> do_sync_mmap_readahead() so the memory pressure introduced in ARM won't b=
e worse
> than what already exists in x86.
>
> >
> >> +                    if (exec_folio_order())
> >> +                            alignment =3D max(alignment,
> >> +                                    (unsigned long)PAGE_SIZE << exec_=
folio_order());
> >
> > I=E2=80=99m curious, does it make sense to add some constraints here, l=
ike only increasing p_align when the segment length, virtual address, and f=
ile offset are all huge-aligned, as I did in my patch? This has come up sev=
eral times in the glibc review, where increasing alignment was noted to red=
uce ASLR entropy.
> >
>
> Yes I think this makes sense!
>
> Although maybe we should check all segments with PT_LOAD. So maybe someth=
ing
> like below over this series?
>
> diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
> index 2d2b3e9fd474f..a0e83b541a7d8 100644
> --- a/fs/binfmt_elf.c
> +++ b/fs/binfmt_elf.c
> @@ -1116,10 +1116,30 @@ static int load_elf_binary(struct linux_binprm *b=
prm)
>                          * the hardware cannot coalesce PTEs (e.g. arm64
>                          * contpte) even though the physical memory and
>                          * file offset are correctly aligned.
> +                        *
> +                        * Only increase alignment when at least one
> +                        * PT_LOAD segment is large enough to contain a
> +                        * full folio and has its file offset and virtual
> +                        * address folio-aligned. This avoids reducing
> +                        * ASLR entropy for small binaries that cannot
> +                        * benefit from contpte mapping.
>                          */
> -                       if (exec_folio_order())
> -                               alignment =3D max(alignment,
> -                                       (unsigned long)PAGE_SIZE << exec_=
folio_order());
> +                       if (exec_folio_order()) {
> +                               unsigned long folio_sz =3D PAGE_SIZE << e=
xec_folio_order();
> +
> +                               for (i =3D 0; i < elf_ex->e_phnum; i++) {
> +                                       if (elf_phdata[i].p_type !=3D PT_=
LOAD)
> +                                               continue;
> +                                       if (elf_phdata[i].p_filesz < foli=
o_sz)
> +                                               continue;
> +                                       if (!IS_ALIGNED(elf_phdata[i].p_v=
addr, folio_sz))
> +                                               continue;
> +                                       if (!IS_ALIGNED(elf_phdata[i].p_o=
ffset, folio_sz))
> +                                               continue;
> +                                       alignment =3D max(alignment, foli=
o_sz);
> +                                       break;
> +                               }
> +                       }

I think this logic should live in maximum_alignment(), so we don't
have to walk the segments twice. It might be better to move it into a
separate helper, something like should_align_to_exec_folio()?

>
>                         /**
>                          * DOC: PIE handling
>
> > [1] https://sourceware.org/pipermail/libc-alpha/2026-March/175776.html
> > [2] https://lore.kernel.org/linux-fsdevel/20260313005211.882831-1-r@hev=
.cc
> >
> > Thanks,
> > Rui
>

