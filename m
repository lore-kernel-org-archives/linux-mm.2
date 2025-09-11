Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5BCB0CAC58E
	for <linux-mm@archiver.kernel.org>; Thu, 11 Sep 2025 15:54:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A51896B0011; Thu, 11 Sep 2025 11:54:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A01D66B0012; Thu, 11 Sep 2025 11:54:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8F1426B0023; Thu, 11 Sep 2025 11:54:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 789B66B0011
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 11:54:07 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0C29A55EAC
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 15:54:07 +0000 (UTC)
X-FDA: 83877415734.20.903175E
Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	by imf01.hostedemail.com (Postfix) with ESMTP id B749040009
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 15:54:04 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=jk9cn2Lo;
	spf=pass (imf01.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757606045;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uGts6uY/eXXZ4jOhJeaDgu9s/XIV0Y179Z31AUQ/R3I=;
	b=8HIZnqvlfWMNzpGw7nPlxTxml03k+P3HaOhg3Qq9Tt8kUrVptaYV0t+oLdbMXw5JiZUwEj
	4S1/cOmtLwapYIG4Pt787pCcc7ZKMDPkzDx4ijOHVxwcSBb4ZdUFd9aWzHU6cx9ofOO9Nx
	zRKDCTivvI9MldXaUpxSRoXuecgn8uY=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=jk9cn2Lo;
	spf=pass (imf01.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757606045; a=rsa-sha256;
	cv=none;
	b=aROzfWdYn2byIJWfUIEpc9j5W7iQxBiFhv0i4QlvYdGz9asgnBeWp1iE4FiFyTukq1z1S0
	TDn2Ys2So7NtsdCUZarg+pE/cxlvB2eY8UOUqywWpxgdRP8CkrqncYe4E/Myvst3bWueoG
	LAHfn39uQ8h930R3WoLM8+fxiHDmhqA=
X-Forwarded-Encrypted: i=1; AJvYcCW8E/qDcrgM2SQywdeVKjIYhozfzxiLrpOIlIgH5IDZCCQLrF6PpGsck+w6eR6oQG/x2UfcS6HLfw==@kvack.org
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1757606042;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uGts6uY/eXXZ4jOhJeaDgu9s/XIV0Y179Z31AUQ/R3I=;
	b=jk9cn2LoLVjLxO6RLNHaiNINj8YoOx8ZhjxkuHf91KOkmtn0OSZKUSX51HoKtS//NqPHTp
	S7Zy6dUVyujwPNUgfVrJZPeX3gzLWZ+G7ngKSHLFVdGK1zwTrjIxHEX34alPnOwQ0J9kiL
	tMgs7ECJ5TVZeR4YTE1MpKsU3VBypHI=
X-Gm-Message-State: AOJu0Yw/Kwd1dPBGOyRFIT/fNdOIBAw+CEJPtPBR+E7HJYPUHZlKWFDZ
	272Q6ooj1IAAbHWOouWeZMMrFlGMfcqMCZC9iWSYtVvJODcGc1T8LQtDqGPu0sOKFMxaOJi2E88
	2bdtdFL78WIsME5C7mG/OPF90wZJ22tg=
X-Google-Smtp-Source: AGHT+IG8RU5WUTbItIq64fMUvoQl7NiAmvFL95+B7zkbK88FTqWjmJTl8UIuRNKQ8Vgk15ueCOMsjt6KmiQM6iVjSCY=
X-Received: by 2002:a17:906:dc8d:b0:b04:4de8:7c70 with SMTP id
 a640c23a62f3a-b04b140d189mr1986469666b.14.1757606035821; Thu, 11 Sep 2025
 08:53:55 -0700 (PDT)
MIME-Version: 1.0
References: <20250910024447.64788-1-laoar.shao@gmail.com> <20250910024447.64788-5-laoar.shao@gmail.com>
In-Reply-To: <20250910024447.64788-5-laoar.shao@gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
Date: Thu, 11 Sep 2025 23:53:02 +0800
X-Gmail-Original-Message-ID: <CABzRoyZQMDodwBEJwNOoJNASJBP50xMhLdvo+kKENyDKWcRAfw@mail.gmail.com>
X-Gm-Features: Ac12FXxOxggsu2EceF8FpAM16vMzK0st5G8fBe8c1465wRynAe4bps1_2BSr7P8
Message-ID: <CABzRoyZQMDodwBEJwNOoJNASJBP50xMhLdvo+kKENyDKWcRAfw@mail.gmail.com>
Subject: Re: [PATCH v7 mm-new 04/10] mm: thp: enable THP allocation
 exclusively through khugepaged
To: Yafang Shao <laoar.shao@gmail.com>
Cc: akpm@linux-foundation.org, david@redhat.com, ziy@nvidia.com, 
	baolin.wang@linux.alibaba.com, lorenzo.stoakes@oracle.com, 
	Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com, 
	dev.jain@arm.com, hannes@cmpxchg.org, usamaarif642@gmail.com, 
	gutierrez.asier@huawei-partners.com, willy@infradead.org, ast@kernel.org, 
	daniel@iogearbox.net, andrii@kernel.org, ameryhung@gmail.com, 
	rientjes@google.com, corbet@lwn.net, 21cnbao@gmail.com, 
	shakeel.butt@linux.dev, bpf@vger.kernel.org, linux-mm@kvack.org, 
	linux-doc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: B749040009
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: f5fapdozg1hs5cdypgr7snwrtcyr6y3a
X-HE-Tag: 1757606044-930646
X-HE-Meta: U2FsdGVkX1/g603/IeKXJZk4LhxBrO+eYOCZDu8cdlNS46bNUOlEJpPSPwSselxWbm9iz+ifDHs1aJkUQAqBuLWWZ3dIKt8UqGEUCtc2mE0JwoWaUSDOTGAAXC7E4lYjkd5E9cW0hdIHndDLJs7roYq94dbqt2dL+PFRyV93eg0zkOM+ny7+OCm1jvyZRsbl6XtfuvRzL94Srd7tdqlHyWjxuckGObEeDMn4UPYJRiB1y4d1/kMneck7VAgyj2EhWWm3lLlH98AIuchwIbGsk1pjzgcqrKbquokcxFly4cPiGEHlNuXpgN2D45lXUVRRSemCnIG9ZKvZAAA6MmZHGptHKRrTk/Jc+N8U2Z8ZJnKDxvVZjz41j7XPYS1sTZVOuWIar1jLPVw5U6dmoKDgKseHtUWaDlGCf4ZGAI4HlJ6I/NylbpmJWc8JzOYeZs7m4MheeP+kAuRG5x/cONd8TYu3uuPCgDz6PSvHx+8vuQ3Kt1xKlqWumZ+4uuDrl0JIqRK8J8bDEx5zq/Wz7f6Sr0J1jkUwhoEQC1BIYGvcpYfRXDgukubyqyM4CFEMxR63Lkgms52lQrMSlvWu63PxLHj8+MRfISzkeGBGb2IT94pYUCIVk6EUmdYKcm89GPQW/1dbRsAtGJwtZ4/YgcSwVId1Y7bFoFl1eD14L2VmQc8ivRACqeSBGnzHfdw81OKz3ZpGjkamR04XreS1OQAuxsT25c/zogTg/ZAnea1lpgAgVPZaRppq1deS58fHXCZVvCOUupkc9ICq8+EZVpwvvx1J5DnMAeqTGc9GxxanFZRW31ir/rJW2d7Tj/aBTyamFX+0yXYbdJNbGpu3jyovjw7E4rsF/amk+nk5FCSsJQE3hGVmNfehYVchUfE8yPaJpDROPlnGIWV2zCOSl5e6U2VcdVA+q/Dvbyrntpbm1jcPGu1BWjdHyUFYWPI24XlB3XnKuhXFqvY3IqWzL4s
 B0Y0Y8bG
 qhjjymJ2MP33KXqsXerMiNylW7yngVeWpZA5yEnZ41MwcXb9Zm0LUZKxLtEHXUo1i5mG7kn3SJ5UAxh75M3Rm9Mc2DxNrJb7YoIP3e0Uafg2nkvRJl5R2pSKDcnGSkZpSNKzM1YPv2yYYUnfdOQ5zF3J0HMkk7jTShQ3v3t1nMqsFFfoNRRTVDdJMdzLvtbIy2MeKk2g4HgxoC52uVSbb0SxptGvYZkwT/hkW
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 10, 2025 at 11:00=E2=80=AFAM Yafang Shao <laoar.shao@gmail.com>=
 wrote:
>
> Currently, THP allocation cannot be restricted to khugepaged alone while
> being disabled in the page fault path. This limitation exists because
> disabling THP allocation during page faults also prevents the execution o=
f
> khugepaged_enter_vma() in that path.
>
> With the introduction of BPF, we can now implement THP policies based on
> different TVA types. This patch adjusts the logic to support this new
> capability.
>
> While we could also extend prtcl() to utilize this new policy, such a
> change would require a uAPI modification.
>
> Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
> ---
>  mm/huge_memory.c |  1 -
>  mm/memory.c      | 13 ++++++++-----
>  2 files changed, 8 insertions(+), 6 deletions(-)
>
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 523153d21a41..1e9e7b32e2cf 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -1346,7 +1346,6 @@ vm_fault_t do_huge_pmd_anonymous_page(struct vm_fau=
lt *vmf)
>         ret =3D vmf_anon_prepare(vmf);
>         if (ret)
>                 return ret;
> -       khugepaged_enter_vma(vma, vma->vm_flags);
>
>         if (!(vmf->flags & FAULT_FLAG_WRITE) &&
>                         !mm_forbids_zeropage(vma->vm_mm) &&
> diff --git a/mm/memory.c b/mm/memory.c
> index d8819cac7930..d0609dc1e371 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -6289,11 +6289,14 @@ static vm_fault_t __handle_mm_fault(struct vm_are=
a_struct *vma,
>         if (pud_trans_unstable(vmf.pud))
>                 goto retry_pud;
>
> -       if (pmd_none(*vmf.pmd) &&
> -           thp_vma_allowable_order(vma, vm_flags, TVA_PAGEFAULT, PMD_ORD=
ER)) {
> -               ret =3D create_huge_pmd(&vmf);
> -               if (!(ret & VM_FAULT_FALLBACK))
> -                       return ret;
> +       if (pmd_none(*vmf.pmd)) {
> +               if (vma_is_anonymous(vma))
> +                       khugepaged_enter_vma(vma, vm_flags);

Hmm... I'm a bit confused about the different conditions for calling
khugepaged_enter_vma(). It's sometimes called for anonymous VMAs, other
times ONLY for non-anonymous, and sometimes unconditionally ;)

Anyway, this isn't a blocker, just something I noticed. I might try to
simplify that down the road.

Acked-by: Lance Yang <lance.yang@linux.dev>

Cheers,
Lance

> +               if (thp_vma_allowable_order(vma, vm_flags, TVA_PAGEFAULT,=
 PMD_ORDER)) {
> +                       ret =3D create_huge_pmd(&vmf);
> +                       if (!(ret & VM_FAULT_FALLBACK))
> +                               return ret;
> +               }
>         } else {
>                 vmf.orig_pmd =3D pmdp_get_lockless(vmf.pmd);
>
> --
> 2.47.3
>
>

