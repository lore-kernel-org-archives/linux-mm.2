Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F2699CD98C7
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 20:35:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 353846B0005; Thu, 11 Jun 2026 16:35:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 304546B0088; Thu, 11 Jun 2026 16:35:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1F2E06B008C; Thu, 11 Jun 2026 16:35:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0DC3B6B0005
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 16:35:46 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id AF4D51C363E
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 20:35:45 +0000 (UTC)
X-FDA: 84868787850.13.FBF63EB
Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	by imf20.hostedemail.com (Postfix) with ESMTP id A80921C000A
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 20:35:43 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=QNzdtjVZ;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf20.hostedemail.com: domain of surenb@google.com designates 209.85.160.182 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781210143;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rTG2eVgH5EFpBrpxCMtRpc9OUYBRrWqg91YAZm7sJjo=;
	b=ECiPoDdwHPBi58f9NW8m7UcLjourDW4AzssNv5yUNxDB2x7iJqiTXEnNdJk0pjdglaZDGF
	d38e1cHGjws9R9wGURohEYSodALlznnx3VUJJ/l9ggIl1JHJ33d+Uc6rL/E8UYVjppGK1I
	pAenQcM4HqsiXPhCqquZ1m3CZrT2r/U=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=QNzdtjVZ;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf20.hostedemail.com: domain of surenb@google.com designates 209.85.160.182 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781210143;
	b=Y35Ibt/xFbjAn08AHquMhc5X6aYWQYN/DaA23W5Lqix35mExpeegXIXqgyUlYamQLpzvAU
	00uWg2094+bteu6UJ1mYusEHglusB4RQXBJp9MxcA5DqTlgjy/L2TUJidEMT5G/pcy7Wt4
	IQaE0ZITP74+nr32xIe8o/19zbIiTQI=
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-5175d339e8bso152971cf.0
        for <linux-mm@kvack.org>; Thu, 11 Jun 2026 13:35:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781210143; cv=none;
        d=google.com; s=arc-20240605;
        b=gVzQQNORyCM8HrjBhGLkOvzNF4/+iOIU/16MNGzK60QTK3ZmssdZVoEKNHKdO7/tzB
         T497BT++81vT1Ks6Jd6r74VzhXxT7OqrgP4fKkKuqS/yIkg3j4jkx3IQKV+30YvM2hQ5
         WKl0fMzKq7MxLWnHL8ffrYTqATILoJVL8eSrgM0mHDt26qWnxLR8+QLvlf2zNTqKIoAF
         Pn1cm0X/kTlc8jUXb0wxmokZxYWLq42lwDEKePiVLWjm2hN0fimsZuW8fI9EtyKmWbfh
         0fzA/EU1YUuYIjFULjPK2ERCqRotWTHCqAZNLDAIq9p40SDKANCOOJqG+0/g6s4rtDvI
         JaMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=rTG2eVgH5EFpBrpxCMtRpc9OUYBRrWqg91YAZm7sJjo=;
        fh=0CZobOlw3L43t5HmY2NvFI5s2wYiz4GU/1oRAPiLI+o=;
        b=N4ILAIdz+MCaXLL2GxL0/01SlNLzCn2p9H1SZGArT0dB6tZCd0g+B2aDfses72oV5B
         10fhZEUmoQ/Ze67L7riLmog3BIW5b9rtZwLaTckxiOpfO87NoSThnb6oGU8CBxJs2u6p
         AUgtp7WT/gYDjLvwh1k/U7PdI5GAI8GDmk8EwAg3nzSlkS6l47sK2hIKJj0fSUhoLpfQ
         ILtR6qYkl7IF9EpaUN/sj4QbQty9tVC/PBWgpzy63euhoxi2aYLCr+KBwIZEnXBLgzEb
         Z0mdIRwyd3k9dUxbkSQyTMjIa9w2XzbhEFx7/u0jz5v12giFjsu6NUgBKA4TFMYw8cMi
         roNg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781210143; x=1781814943; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rTG2eVgH5EFpBrpxCMtRpc9OUYBRrWqg91YAZm7sJjo=;
        b=QNzdtjVZcAdzcEZGmckKO5VKOzxBxmGZ6KKkobp4KEgIGRismmzF5z0hRb2uOIpc/S
         xPOxEIwjVLZlcV1xwthBNuHddN9kxDhAb88Ta1YSlWssiYOmC8Ljtld8+BhDAScnti/8
         IronMmjIjUoHq89RhG3N818ysRDdyyLcf1ytwXwCbGk+ODcfb7f+w+ppbiF0+dG67qzL
         9qkJjUFmgN1iW9sz8DSX5SK9bL7X4iT2D1dZTd9DgReQ/hoWhtygS1fF9xpdaTD4tTKJ
         N6b9Ic3Vt3UkGwjw6BNsRIDpRVIWxTXs6Qd5NA+Ef0ecrGRNXFIA9izlH1EH6d2wSX33
         jGnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781210143; x=1781814943;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=rTG2eVgH5EFpBrpxCMtRpc9OUYBRrWqg91YAZm7sJjo=;
        b=jYd0dmIO33bJ4Ggqz2J8J/kpmpGA60D5HJu2BaKnV9y7VRDZtf4PRp7Y0XidHBDSMf
         Z/LNcuIXJLLhMOaaJZlb8GnbyOic+nGZ2MHQM376aaDB4Kdcy/408809QmtBOnYFnEli
         XDVRS1BR9QAnhUYD9dqBEng3GbNzSSGYKc9xZd49vll2sa0FM/SrXNRMNzvO1+a8Ay88
         haOEc16fp6z19Uug5LzhmMGwNk13gaXCwCtJFAi6v9Ehk3PD6B58szDVP5GNXWcDk2Ld
         65VQW1I62mzTXp6nvB6Iv5ChsAmBdX8frigoMWNXPO8yucbpFyJuczqe+lwU6CQMfSMD
         cP7Q==
X-Forwarded-Encrypted: i=1; AFNElJ/grhkso+3EBN4aG1KV1bvDRU/VvuBEaMBnMHO9hgrCNJM1QNI+3KwfPlSAOGGmy73Fm323KNPC5A==@kvack.org
X-Gm-Message-State: AOJu0Yy2AyroMq3pv2skYLExLPR1XbVLNjAZXjvyLMwyrQOYXgI/g1d4
	OnO2Zl9LfgQ3gqtxHcErUakb+3FqkSQoqoSDIdGjJChbHp0EZkwXegbYUr3oRBSVyzHEWjJHX9F
	Z/X2Z6TOQXZ1kfttR3eoFb8lxxOpO/y6oubKGQJCr
X-Gm-Gg: Acq92OE5I4JoKiJl6eNFtYAfpkhZ7j5Kpn28YagUqhXwb5jIJvy/MRmhQf7OFpJhTRl
	n/a72SyuV4tixy0r9HMgLJfhfPYK6yTly+q+S8dBG9BqEsw+Xjx+B7AB73iRfV+YZNH8jgSSDZi
	Bbx3If9mE3hcJRuVkgTXRtq3Blb57ib57H20kHYPJqvyfLLh2fr2UOOuRo7If4bZw2BEBpJexwn
	EfElb2B4haopBuWi0MLsTXUMm2Tfnqn7uIw6ZOi4ZaP/TGnCLulYFxd4B7dk+T+itrbfAyOlqvJ
	XxUvvqE5PM79qO3inxfomh7IkZ09xs1WQpCG
X-Received: by 2002:ac8:5a48:0:b0:517:5f1d:9f7 with SMTP id
 d75a77b69052e-517fc506a8dmr436611cf.7.1781210141994; Thu, 11 Jun 2026
 13:35:41 -0700 (PDT)
MIME-Version: 1.0
References: <20260610230409.A44D29FA@davehans-spike.ostc.intel.com> <20260610230415.C0521C88@davehans-spike.ostc.intel.com>
In-Reply-To: <20260610230415.C0521C88@davehans-spike.ostc.intel.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Thu, 11 Jun 2026 13:35:29 -0700
X-Gm-Features: AVVi8CdN4TFi21bTDduKLyadU8rWfGxctdFy54TtZGcrA-1-JxHz0WBnpM-4hE8
Message-ID: <CAJuCfpEu4HfUOVd1dTGdDNxq91Ts59ab_LiVPQEnxRUWUi3WaQ@mail.gmail.com>
Subject: Re: [PATCH v2 3/5] mm: Add RCU-based VMA lookup helper that waits for writers
To: Dave Hansen <dave.hansen@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Alice Ryhl <aliceryhl@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, =?UTF-8?B?QXJ2ZSBIasO4bm5ldsOlZw==?= <arve@android.com>, 
	Carlos Llamas <cmllamas@google.com>, Christian Brauner <christian@brauner.io>, 
	David Ahern <dsahern@kernel.org>, "David S. Miller" <davem@davemloft.net>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, linux-mm@kvack.org, 
	Lorenzo Stoakes <ljs@kernel.org>, netdev@vger.kernel.org, 
	Shakeel Butt <shakeel.butt@linux.dev>, Todd Kjos <tkjos@android.com>, 
	Vlastimil Babka <vbabka@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: 1887dq6jxunfw8c4sy4craecr6hqr5bo
X-Rspamd-Queue-Id: A80921C000A
X-HE-Tag: 1781210143-288512
X-HE-Meta: U2FsdGVkX1/WF3x9oJcbEKJ1mk0ds/QyOEeCDXayI0D5BxgAeovbhIb0oh5UKl/jYH3zAVqdDtcVIrCfV4p39BkyknHX6C6Ve7NuXIj78N/PDi+JAqR7yn6EAeOvy91qoTJsUFZH65lTftMeSc9vEv7sX+LFFiJdqG9sYZRqWO3q/0K1f9wycGyy2i149eUVDwpbQGcrzOltyudD6Sq/3WkyX9uXYpgmCba2gkN4wP4L38gsC8Pk0U6lTKwvBIwKnl7NBCY/dizzUcjiW/NeV3doB4DDZltEhPG5CJ0B9FrGWUavk3CM4+YWOBZJRi0LAorH0/0HRCOJJM3sEaAVE6Vf39GUqhlzoy1V8oE3odBXyMuANJpqOH+t8gIXWxqz7qDdt+7JF/6u/EjJNX5s9zBOMXILTXT09oLN8mURBvg6Zrzhep4+sGoLGf4tegLxBXjwWl8vTz6UpLAiQli2TTvEg+z5CXDt2PuPkxeIrWlF/Yj1VySI17kckLeGux6oBL1AD9pIlOTfahyrD1I+GZhsA7tyclCfG3fQ6tss/vZpJf290PTZpxk+KL28qOQroSMA3ovFTKXIxsTf5K4H6paINnY6yyDO62A7lEuocPhe0k/EsIvexRygtlumYHVpBimmRTyU2bw70L4FWQ2eYkBQ+u50AE9rdpTy3pVBFgyYLXKEIScwmY9emhw4MNX+ILki4/nCYMBag6f+URL2sXjLoiJ3F6n1245zlEbUhdzVDiYetMnbL5aZUW2YXMqg+h+nJ7ZxW2oNBoEewbOs5R05JiGO5Er4m8yjIfBm4RDHtNEaVoQy+sY77nYlfiB9OTYDSibFl6rvQA9hsfF2w1csuU8/ED3TrQuZcvjxOUxewxhITGSbYGX2qd/tD7fjL2HKAPOHgNVuBWeWFt9WWH7JuhmYxAASlFcAZPUjjwr/enfqMhOL2J3Fv3v6RKZZV1zOnC/6r1+3ZRs3/7s
 22ANVDit
 /Xea2BfAhfpB1aTVj93zjF2kyjQO9Cfx9Z5M+bpHuLTqxhPGD5pf11wKnS9UDZlZLfxr+ir8HekZqFYRRVdFqBr5K4V9kwsWVY9iudDwkbSe/GyZk4YoQ4BGV9+wLr/I4cP7psLTf5oyxzc5KfWs08AFawqRkCjaXC5U75PExD3krAvW93V80q2fS6XNe4LHJeyo8Qw+jqrwjFq/nTlXA1t53Hp1lrltiUixvzekwR6LkCx7IhPpgPyJmy41Gy4/T67bj2n4dR8NVcUuIhflHGmgN4Nw7aFHxIEWJc55J4o53UpiaPtJYwEhtRf8IBc/EToP3GtvFApZ8OdWFIzPdpyFE7ohj1p8NVBKl2sxOQ1+dNvmyPqkPuPQEcf9ts4DfWdu+goSNevntBS4x8E7k84MwLYr2QqsWUorJjhIxUPm/LeNiOyCM3bqMS501bXuGXpQuKoScXxl8OwntXPtyDP5QW0ut0WC+QIzzI83KBT2/tocK0eCBq9+N1K3+ENRsWYRSW6c6ogXNGgCcuThw3mCxY+2s1xnt721Rukp7Eb3ZQC9OWY2ss8cYsAvCVfpO5/Ss4MUplVFZrxLpW/vKh9krRQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jun 10, 2026 at 4:04=E2=80=AFPM Dave Hansen <dave.hansen@linux.inte=
l.com> wrote:
>
>
> From: Dave Hansen <dave.hansen@linux.intel.com>
>
> =3D=3D Background =3D=3D
>
> There are basically two parallel ways to look up a VMA: the
> traditional way, which is protected by mmap_lock, and the RCU-based

"which is protected by mmap_lock" better be more specific "which is
protected by mmap_read_lock".

> per-VMA lock way which is based on RCU and refcounts.
>
> =3D=3D Problem =3D=3D
>
> The mmap_lock one is more straightforward to use but it has a big
> disadvantage in that it can not be mixed with page faults since those
> can take mmap_lock for read, which can deadlock when mixed with page
> faults.

"when mixed with page faults" or "when mixed with address space
modifiers that take mmap_write_lock"? I think that's what your example
shows.

> For example:
>
>         mmap_read_lock(mm);
>         // Another thread does mmap_write_lock().
>         // New mmap_lock readers are blocked.
>         vma =3D vma_lookup(mm, address);
>         // This deadlocks on mmap_read_lock() if it faults:
>         copy_from_user(address);
>         mmap_read_unlock(mm);

Ultimately the problem here is calling something that might require
mmap_read_lock(mm) (in this case copy_from_user()) while already
holding mmap_read_lock(mm). Normally that works up until you throw an
mmap_write_lock(mm) in the mix.

>
> The RCU one can be mixed with faults, but it is not available in all
> configs, so all RCU users need to be able to fall back to the
> traditional way.
>
> =3D=3D Solution =3D=3D
>
> Add a variant of the RCU-based lookup that waits for writers. This is
> basically the same as the existing RCU-based lookup, but it also takes
> mmap_lock for read and waits for writers to finish before returning
> the VMA. This has some advantages:
>
>  1. Callers do not need to have a fallback path for when they
>     collide with writers.
>  2. It can be used in contexts where page faults can happen because
>     it can take the mmap_lock for read but never *holds* it.
>  3. Its fast path does not require taking mmap_lock for read.
>
> Basically, when applied correctly, this approach results in faster
> *and* simpler code.
>
> Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
> Cc: Suren Baghdasaryan <surenb@google.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
> Cc: Lorenzo Stoakes <ljs@kernel.org>
> Cc: Vlastimil Babka <vbabka@kernel.org>
> Cc: Shakeel Butt <shakeel.butt@linux.dev>
> Cc: linux-mm@kvack.org
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Arve Hj=C3=B8nnev=C3=A5g <arve@android.com>
> Cc: Todd Kjos <tkjos@android.com>
> Cc: Christian Brauner <christian@brauner.io>
> Cc: Carlos Llamas <cmllamas@google.com>
> Cc: Alice Ryhl <aliceryhl@google.com>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: David Ahern <dsahern@kernel.org>
> Cc: netdev@vger.kernel.org
>
> --
>
> Changes from v1:
>  * Add a comment explaining that this can not be mixed with other
>    per-VMA lock or mmap_lock users. It is prone to deadlocks if so.
>  * Add a FIXME about making the mmap_read_lock() killable
>  * Add more chaneglog bits about the possibility for an infinite goto
>    loop.
>  * Adopt vma_start_read_unlocked() implementation from Lorenzo
> ---
>
>  b/include/linux/mmap_lock.h |    3 +++
>  b/mm/mmap_lock.c            |   27 +++++++++++++++++++++++++++
>  2 files changed, 30 insertions(+)
>
> diff -puN include/linux/mmap_lock.h~lock-vma-under-rcu-wait include/linux=
/mmap_lock.h
> --- a/include/linux/mmap_lock.h~lock-vma-under-rcu-wait 2026-06-10 15:57:=
55.828431712 -0700
> +++ b/include/linux/mmap_lock.h 2026-06-10 15:57:55.834431925 -0700
> @@ -257,6 +257,9 @@ static inline bool vma_start_read_locked
>         return vma_start_read_locked_nested(vma, 0);
>  }
>
> +struct vm_area_struct *vma_start_read_unlocked(struct mm_struct *mm,
> +                                              unsigned long address);
> +
>  static inline void vma_end_read(struct vm_area_struct *vma)
>  {
>         vma_refcount_put(vma);
> diff -puN mm/mmap_lock.c~lock-vma-under-rcu-wait mm/mmap_lock.c
> --- a/mm/mmap_lock.c~lock-vma-under-rcu-wait    2026-06-10 15:57:55.83143=
1819 -0700
> +++ b/mm/mmap_lock.c    2026-06-10 16:02:50.723860779 -0700
> @@ -338,6 +338,33 @@ inval:
>         return NULL;
>  }
>
> +/*
> + * Find the VMA covering 'address' and lock it for reading. Waits for wr=
iters to
> + * finish if the VMA is being modified. Returns NULL if there is no VMA =
covering
> + * 'address'.
> + *
> + * Use only in code paths where no mmap_lock and no VMA lock is held.
> + *
> + * The fast path does not take mmap_lock.
> + */
> +struct vm_area_struct *vma_start_read_unlocked(struct mm_struct *mm,
> +                                              unsigned long address)

It's harder to review a function without a user but I guess users will
be added later in this patchset.

> +{
> +       struct vm_area_struct *vma;
> +
> +       /* Fast path: return stable VMA covering 'address': */
> +       vma =3D lock_vma_under_rcu(mm, address);
> +       if (vma)
> +               return vma;
> +
> +       /* Slow path: preclude VMA writers by getting mmap read lock. */
> +       guard(rwsem_read)(&mm->mmap_lock);

guard() is nice but mmap_read_{lock|unlock} has those
__mmap_lock_trace_* traces which we lose with guard(). Not sure if
that's a good enough reason to keep using older primitives.

> +       if (!vma_start_read_locked(vma))
> +               return NULL;
> +
> +       return vma;
> +}
> +
>  static struct vm_area_struct *lock_next_vma_under_mmap_lock(struct mm_st=
ruct *mm,
>                                                             struct vma_it=
erator *vmi,
>                                                             unsigned long=
 from_addr)
> _

