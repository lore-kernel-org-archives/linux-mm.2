Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A3823606A320
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 03:34:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=KtBSZ/vF
Received: by kanga.kvack.org (Postfix)
	id 7C3E66B05B1; Sat, 21 Nov 2026 22:34:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 74D6D6B05B2; Sat, 21 Nov 2026 22:34:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5EEA66B05B5; Sat, 21 Nov 2026 22:34:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2610D6B05B1
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 22:34:56 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7B1EA1402AD
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 03:34:55 +0000 (UTC)
X-FDA: 85461338550.18.790DFA7
Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	by imf15.hostedemail.com (Postfix) with ESMTP id 7E091A0002
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 03:34:53 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b="KtBSZ/vF";
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf15.hostedemail.com: domain of surenb@google.com designates 209.85.160.180 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795318493;
	b=4oZduJwObqJowNlXzpiKHsCQuEF2eJCATJzzm1F2+4YF766q98uJxFjfKrtOTKxYHu8YML
	cprYai1xBTXO2UiTblvR/bklJUN2m1CrUIY2/3EdCQtT/0LDOv11YWntucgExQIx5GJRhe
	QIJ8bL0SdVSFANX61bembtP8gCu5WA4=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795318493;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+arqdc7YBoB64Vn5DbGyaeiFfyImnvCCTd6+VOMToaU=;
	b=ISOY6oPcphi7q+J3hHIgH3rH2VbafJanvDC8Upj0CItJEiY7SYjdWmbYMEHwX1Gm//GKqD
	23Q360fdj29jLnwqoLjnbE0IyrgkPlIgxMsP3IXU9fiSzFksF+cMXKPEW6bya+VtG9/9d8
	7HAuuqnAdDUqKTFqzDHWzrYBnr3MRQw=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b="KtBSZ/vF";
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf15.hostedemail.com: domain of surenb@google.com designates 209.85.160.180 as permitted sender) smtp.mailfrom=surenb@google.com
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-55c7445cf85so152781cf.1
        for <linux-mm@kvack.org>; Sat, 21 Nov 2026 19:34:53 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795318492; cv=none;
        d=google.com; s=arc-20260327;
        b=fXOZZIt212L7x+0D6QzW6nAlNSTInuYJBq86DQJHpqkv8yAbPQ0dwkrFKF97MNv4LI
         hUg5Lv8s7uKDgScUNa8VCVfGfTsAnfCHlbQl42Gh5Rlft0iODY/QasVq1qXoiqPv8HMA
         CWtsk1kwVqmgxzsiKtz/tDHmBARWkVYelf24djGe0b6C8PuduEB1tO244RwWy2SaSAcE
         Tw3DaDMIQtZqmUwHavbWD6RtFBG7FCdeI4MGLk4CHErbp3skKdyGgGsZqqGzlY3ZP7SA
         Q6Wvee+mK8nbvjR1IAyO9ghYbvv0QD6NWc2EADnRoCv/pBq9PtnoENcnZY7/HJ16EAPd
         DBkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=+arqdc7YBoB64Vn5DbGyaeiFfyImnvCCTd6+VOMToaU=;
        fh=6PZJRMdpQhGiO/TVFynvrhePC7TlahwVyP3Ap/ojT5A=;
        b=EqiC4eZe+RFTJuVVMJ7HJMeJhaKgGsXSr/CQplL2BpZMCu/OC7mbXG0btuaHOq2hD4
         1M2IQ5ZuzkRrRuI77V0zNTySm9U81Yl8NQZr41PaGATPIpjS3TiLXoiWbBiQwchK530I
         dfbIOAwHNM9njWe3memqk2Ucb38PVqHDnTDeIld6CoQx2S4sUMoVqm1vWLnCxyNfvwQK
         tF5qfclh000A9Q/Zi8vgl3j1hxBmNUnehCe/CvTorN6hfS15AjsRN1rd7lL/wxbDFBQM
         5xTCBBHlT8lDfq7JEI6N3FomsNPuNYGYth0k23kVZ7GK86vufSYfDE+pDz5EJuCogpY0
         lYWw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795318492; x=1795923292; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=+arqdc7YBoB64Vn5DbGyaeiFfyImnvCCTd6+VOMToaU=;
        b=KtBSZ/vFUkIrVd6aBNzEsaI2AVrOHsoim44wmf6rGR7huJskuPougc+AXtL2ai/+Hd
         7hVpcOB7h50zN4JwFotv5HPZVXQfXjULNMxHZiztUYUxlTAZDCaI7bfYmdX3gD3+Fe9j
         otH+Ct0a4kyWPc2jL4gNgN5thhUNs1S2uxoD9DIFyHfbcjX/0KdXSENuks2RatovKqTm
         /5n98EHXjsdHQWBDA34P2Tf1KPLygxEx6bHuyG2YB3kkfSjQ3CkHoTmRSC85UEtf7b9y
         dq0HujngweqGmtGnDUfGXxqFnPBiP2JZDucEr/PasNCbBvOh5OzxKfIB1mBlI68V4poU
         6VdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795318492; x=1795923292;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=+arqdc7YBoB64Vn5DbGyaeiFfyImnvCCTd6+VOMToaU=;
        b=qEwa1HF7+tXgdVX06w3t1pFB0ekHLGirkgXwHtNLUVgN5KaH1gzgR5Pdn4TfD6vOA1
         60ldtFw7eSciF9iRPWsG+wDdz7Bn0QQ7dGTlxoaeujM2JzluMPnMPN1+J79MmglD1wRr
         dMRya0HT/B/Q1xNpjozrgYOAnHCfkuFIjZmlc5cMcyztSlJ8g4WkzWYx49jj3e4wnfl+
         2wIQuHNs+04SwHVPfWxwNUzwKDd9rPJ6F+aHg3vOYhjLuS+K/dvR36l/mhDrq9ZemQ7J
         AIRSxvBV+IygbWo2vd1/TwKXGZdLOQXuuNKGmas1u+XPvHEW5OQSsag5JXH5Si2RbXn0
         7bUA==
X-Forwarded-Encrypted: i=1; AL+hErEkcb/ZONv/MQut1myTXxaMMA6+zyAjjFeyEEZJB5On5filLH4Ie76ufOABpSTOeSWYbPvL67wDeg==@kvack.org
X-Gm-Message-State: APuU4Z8v4Js9LD3e04/B4XGwTEZnOPIf6p1FqazHtgipCrMPUxRKBIoF
	92oObdvIokFkFfcCABLZBMf31J1zHe2ceS/2e+kuLLc2cLaP3LJfpM1A6P0vrM+IznQK9xxhWlk
	4VpAvF06ienrWUNgJpwIR1Vc77U/23IEdQBSr192v
X-Gm-Gg: AZFdTZe+XhTTLImn8my6/XYE74tuHppOXqWCf+lj5BUxXJh5TElNoxJKNiMSfrZfikU
	mxn9s3pIuFQioSc73HEZSAfhIl5QgdBtTyLb5fXpqEkpehPruXzDRNTSC4s3s3O7WxAkcA/Tnkl
	mvDYmzPPh/imH3xEZQ/tk2y2sY5Z1vkrYaxTRjnTEX3UqgfUHrvFhVAcEGG3qzWzKzlj/1SNDG4
	ceggVmQNq1zMr2kcSXnhLNlCGx9qdM7U0+nAfos8008AvZpEwz6/PdZAta4QXDDqSBpQj2jYPtM
	OIqQnvdkSDn3f+F/ILFyyTxoqKEVZgR8EZviViLruTE/et6TMAmSOBs5LaklJPyCFOjMqyuhLb5
	4rmTzUWdx1DIMfNoYpTY8TGPq+7ZkOENPh4ZV05a2foNCRtV6c9SnXBa4Zze8f65J3c9rJ+s=
X-Received: by 2002:a05:622a:1f17:b0:52f:9ed4:8d76 with SMTP id
 d75a77b69052e-55d890644camr16243611cf.14.1795318491908; Sat, 21 Nov 2026
 19:34:51 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261121-some-more-ai-fixes-v1-0-236e925d9b64@kernel.org> <20261121-some-more-ai-fixes-v1-4-236e925d9b64@kernel.org>
In-Reply-To: <20261121-some-more-ai-fixes-v1-4-236e925d9b64@kernel.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Sat, 21 Nov 2026 19:34:41 -0800
X-Gm-Features: Aa3M54pDb_dgj_Fs32ZEZae2DuXiVzBHiwxoPTSr9uOCmICIMPOaQKf8n_YO330
Message-ID: <CAJuCfpE8Vz2sM=q7gjAjk3V5fboqKUA--ohLYmA4ffE4VWM4ag@mail.gmail.com>
Subject: Re: [PATCH 4/7] mm/vma: fix uncharge after failed stack relocation
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Pedro Falcato <pfalcato@suse.de>, 
	David Hildenbrand <david@kernel.org>, Jann Horn <jannh@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Kees Cook <kees@kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>, Ollie Wild <aaw@google.com>, 
	Adrian Bunk <bunk@stusta.de>, Xu Xin <xu.xin@linux.dev>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Mike Rapoport <rppt@kernel.org>, 
	Michal Hocko <mhocko@suse.com>, Hugh Dickins <hughd@google.com>, Joey Gouly <joey.gouly@arm.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, linux-mm@kvack.org, 
	Chris Mason <mason@kernel.org>, Josef Bacik <josef@toxicpanda.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User:
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 7E091A0002
X-Spam-Status: No, score=-23.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no
	version=4.0.1
X-Stat-Signature: jf8bfu4kwscyf56qrd9f35rkh9ot8rxt
X-HE-Tag: 1795318493-868508
X-HE-Meta: U2FsdGVkX1+tTszMk1S1u0FCxhQcXRAqnR7pVEa+UmD1Cymw0Vx/r3G20vwM/XM8OIqhg8YQuf1F39BvwjBiR7fBX9sve3LozswekYy7ae+YdD2C58z5t7zskAjmkemD/QvELKrpadDUC8Ei8jBxzXRoHTuxJfge60AntcathczlBFUrhFRNbLgvIBrAB3X1Z2bgKV7EgmI4e/LJAn5WqX+Pv1WvIbNspT93+AWar8DwnxcOE+WMKQv6umlCOjJ679WcDPWf8ocnoGECZDf8dSTABKv1yBq//CbCG+WlBQmLn0dLOjfnK2hRgkxQX4Gpa82VR5ZG7+tkawuEkEk3DpVqJaTXRr49pGlHBXXxQZtmtZbZzlH4809Ohu7mqmZGY+evODBQx0DNciWbZk+gzWRT9y5+kXNRnFyvuOwNtVnXlAmYJRurc87ZjfOjeLeboeFDREVhFMpcTona2yYOtE127a9ThHdzXi1TVhsjCJq3D75qvWx3ndjzFUZAbtvS1yV78r+flX0ZuLOKKYlCgWFPx/Tor4wV9NKZ8BzI1e+AirVPPcxvV8fcfqWOZfPAuzA535KsQsc2ESXWHZQ06p2hMcNa/r7+6xPtbCdrNepfAJANzRYg+EzR/wSBNBlBri1guW3TuGcmI6M8l+EdES52n2ioXbuwYtRD2Wnd4irEcU84f7zLuu2JEDpDaF23IUitUQxoiMa/ZsKKBP0fpLzvXNrXkX7+zn3qLR6hW/dgzFiTALUpdoJJu4UTj4z253ujPD3jWGdUmx2eo24zrbd2+6+EroYqhdiSd6ERHLaqll3JkYRKMRQagrZAFsCQLTIah+zMo5Zw2XKfsN9m3rYtTQ5vHFTq7ulQtrYgcB2XPNHfo/XAq4wmK1fx03PGiyHi2br4d3yCo9fWjdFVVYAfVftkjn/y9dj1iOY3yZ3H6OwFczvUqzgy0uzWzhCgRyAKarCJg1b8/k3Rw1e
 Ht8xc3GZ
 XdGQ67BbFdJzro60qZuve08pHGpbLV6XJaKjV1XuxN+jbBkVGWRaXGdafpeH47ckBsxugq16Tbdzi4CJT0Iy+iGsvG39/Z9RsQZ/KfjcRtzrtYqsvkQU2ry+WLNRiHwyYOaZfRrh4rXgZeNS24HHpbgepB2bxCC0WtitERAo1LK/dmlAjyWCaPQ0YgP6SBMOND7Q7NRMrp5uoiFXsMTKcaoazfBI5b2B70254SPB1r1cSwwZ31sUcGjdJGcmKZ1/3K3HeMVzWCUGNT9sTsVSwidlDMNgweCsxCMUf5NwzsfTTTNuBQdIV4Ecr/sQYKk49+d312nUMo8H4WAMmbgz59iUJuFKAnIhXgUdkOC/prh3k+t8OXp/8rE8PNB9p78g8j04kAhjL0Db+HaRK6PnoI54tclHsO7EoBuaiqbplkyhDPEOuQaKclTDKMfvMXtp9CvtB9h0i6Uvr8+WaUxuPh8Q4TirpiiGREKuvXHW/mxuoMQAELxMgufzkfoTSjuD/xN/Z
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sat, Nov 21, 2026 at 8:03=E2=80=AFAM Lorenzo Stoakes (ARM) <ljs@kernel.o=
rg> wrote:
>
> From: Chris Mason <mason@kernel.org>
>
> An execve() that fails to relocate its stack can underflow
> vm_committed_as, and the commit limit of vm.overcommit_memory=3D2 then no
> longer holds.
>
> exit_mmap() uncharges vma_pages() of each VMA with VMA_ACCOUNT_BIT, so
> the charge has to match the size of the VMA. relocate_vma_down() expands
> the stack VMA by the relocation distance without a charge, and relies on
> its vma_shrink() to make the two match again. But it returns with the
> VMA still expanded if move_page_tables() can't allocate a page table,
> for example at the memory cgroup limit, or if vma_shrink() fails:
>
>     relocate_vma_down()             charged    vma_pages()
>     =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D            =
 =3D=3D=3D=3D=3D=3D=3D    =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>                                     L          L
>     vma_expand()                    L          L + shift
>     move_page_tables() fails
>       return -ENOMEM
>
>     exit_mmap()
>       tear_down_vmas()
>       vm_unacct_memory(L + shift)   -shift
>
> On x86-64 with 4-level page tables, the distance is up to 16 GiB for a
> 64-bit program, and about 128 TiB for a 32-bit one.
>
> Fix the issue by giving back the charge of the stack VMA where its
> relocation fails, and excluding the VMA from what exit_mmap() uncharges.
> The argument pages of the dying task are then outside the commit charge
> until exit_mmap() frees them.
>
> Fixes: b6a2fea39318 ("mm: variable length argument support")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Chris Mason <mason@kernel.org>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Reviewed-by: Suren Baghdasaryan <surenb@google.com>

> ---
>  mm/vma_exec.c | 22 +++++++++++++++++++---
>  1 file changed, 19 insertions(+), 3 deletions(-)
>
> diff --git a/mm/vma_exec.c b/mm/vma_exec.c
> index 586c52155942..84b98f1a201d 100644
> --- a/mm/vma_exec.c
> +++ b/mm/vma_exec.c
> @@ -45,6 +45,7 @@ int relocate_vma_down(struct vm_area_struct *vma, unsig=
ned long shift)
>         struct vm_area_struct *next;
>         struct mmu_gather tlb;
>         PAGETABLE_MOVE(pmc, vma, vma, old_start, new_start, length);
> +       int err;
>
>         BUG_ON(new_start > new_end);
>
> @@ -68,8 +69,10 @@ int relocate_vma_down(struct vm_area_struct *vma, unsi=
gned long shift)
>          * process cleanup to remove whatever mess we made.
>          */
>         pmc.for_stack =3D true;
> -       if (length !=3D move_page_tables(&pmc))
> -               return -ENOMEM;
> +       if (length !=3D move_page_tables(&pmc)) {
> +               err =3D -ENOMEM;
> +               goto err_unacct;
> +       }
>
>         tlb_gather_mmu(&tlb, mm);
>         next =3D vma_next(&vmi);
> @@ -93,7 +96,20 @@ int relocate_vma_down(struct vm_area_struct *vma, unsi=
gned long shift)
>
>         vma_prev(&vmi);
>         /* Shrink the vma to just the new range */
> -       return vma_shrink(&vmi, vma, new_end);
> +       err =3D vma_shrink(&vmi, vma, new_end);
> +       if (err)
> +               goto err_unacct;
> +
> +       return 0;
> +
> +err_unacct:
> +       /*
> +        * The vma now spans more than was charged, so exit_mmap() must n=
ot
> +        * derive the uncharge from its size.
> +        */
> +       vm_unacct_memory(length >> PAGE_SHIFT);
> +       vma_clear_flags(vma, VMA_ACCOUNT_BIT);
> +       return err;
>  }
>
>  /*
>
> --
> 2.56.0
>

