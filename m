Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9047ACAC5B8
	for <linux-mm@archiver.kernel.org>; Mon,  6 Oct 2025 21:07:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 97D4A8E0027; Mon,  6 Oct 2025 17:07:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 92D2D8E0002; Mon,  6 Oct 2025 17:07:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 81C7A8E0027; Mon,  6 Oct 2025 17:07:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6D3108E0002
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 17:07:09 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 44371160739
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 21:07:09 +0000 (UTC)
X-FDA: 83968924578.07.ED1F246
Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	by imf22.hostedemail.com (Postfix) with ESMTP id 65C95C0007
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 21:07:07 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=mJ6cQcHP;
	spf=pass (imf22.hostedemail.com: domain of andrii.nakryiko@gmail.com designates 209.85.216.49 as permitted sender) smtp.mailfrom=andrii.nakryiko@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759784827;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ycCXn7HCBHZVIgihBYyqRnShLRsn7MlEdfR5jY2NQjs=;
	b=HEVDyPutvtBgfetoINY/XEmdCNTihr2QsmEpm9JlycnfsAL38vL0Hgnzh7JeWHkJlDJdow
	qQT9MSzdKpxVkjVlp+8WYuo8VaHnr3IzcCaxxI0/nfEkocIcwDt/aQo4EqzbV4+eM+/vKR
	inQ2u1JNk07+fRxTNupqspn5UsCFxIE=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=mJ6cQcHP;
	spf=pass (imf22.hostedemail.com: domain of andrii.nakryiko@gmail.com designates 209.85.216.49 as permitted sender) smtp.mailfrom=andrii.nakryiko@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759784827; a=rsa-sha256;
	cv=none;
	b=IA8unKY/KIyhqjwi3LQ1Wf0EbKSz9xGvo9h63dbUd4NF40g+73qUXo5A6GZGDRcur+Zxa5
	LMp2nRmUK5PHJilcENl/D9zsZoGahdvihroimtn6c3UcIR/q4JuS0ozOH8+XU+rsoqsF+h
	sojldwmcQad4aAIfIpnuK0+0l+8DPSQ=
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-339e71ccf48so1515066a91.3
        for <linux-mm@kvack.org>; Mon, 06 Oct 2025 14:07:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759784826; x=1760389626; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ycCXn7HCBHZVIgihBYyqRnShLRsn7MlEdfR5jY2NQjs=;
        b=mJ6cQcHPDe1Z5XOvxjgpXkBHl+l1/ZLvj9O49csWBEU28/uDdy9na3TcBM+7SXlqG2
         ARqtDk+GjLgFRB+lXlB1H74nnt2mqb3z+Ke89CslWDupxfomG/zhOOLTR+ORxBV2xCSs
         E8zCIbiXaeMfpGS6nAzmgJaoCE7WRmO3YDXrkh2pSYax9ubzUBUxxQ19vUVOL4ASVK77
         8Vg9L/fCq6fnjoUJIoPCIwLNzoYgLzjWj6XN/7/wokCv/KQJmFtj8pEOaoKvFNrJATix
         i9XuBsvSD78C9xorYr3Ivthb0hnh1HYYHxI7gU+C0gpv854SNe3ojV8v5qhqLYQzpuKc
         p5OA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759784826; x=1760389626;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ycCXn7HCBHZVIgihBYyqRnShLRsn7MlEdfR5jY2NQjs=;
        b=JMIcFUslvr/iqV6v4CQBEapZgqO2oVdrAT6PnbC/ggLe8NEqJjBSUa0louEqjEiCnJ
         3Ff54iJ4/bTG4wkotyKpid/Rs0Gdj7jliBZko7Mb4z+l1ZacyKuyAtTjHH/QHe72SM9t
         vnna4jj4A0Xc1s7BpgKgwCdVTSemNoBz9Z6KgjqceKjpNo8U0YnHCuppcH7A/JzpQhRi
         QR//bb85h4HorihrVj4joU5ABasw5WEauOJ8ttw2OQOBRD3j0eXeHlFGWrjHAZKvptED
         ZjMB8hBH/m9767CiWLm+wbBdRzvxhyC46b4A6El8cPu9bKCjb+fb6QeNZLfcVhTN/T4s
         Uf7A==
X-Forwarded-Encrypted: i=1; AJvYcCUkk53sjkaC99rBAbL+Glz8293kvmvNT67awQtMvh+ye2mel3HiV2fK1WyQnzdYGvS6XGiEPkbIsA==@kvack.org
X-Gm-Message-State: AOJu0Yxrp1ripX0RkKyR5sgH7fat80gX6AOcV7cVEW1YnhLARuxI/ror
	Y80XrBCWDCHIXpJJ8OaZBIP0vflq12p8t/escNKznNraSd0J2amtZEMoBR304N8+uOlybn8lg1H
	/pyPuIMLqg4WWuy/cmUBajGlCd69a5sU=
X-Gm-Gg: ASbGncuB7JLLZDvGY068NxwfdNf0Pq/EqHgI/9nNcldf/r1aFKdqued3P6PJsTd8MiX
	pJrn2jX7YpFIskoQJ4a/CFIbyrjgiWs1ONylPasG1OT0h0y/tLpmFFJuh1GrmhY0JqVz8dIPnqx
	kw0srixU4K701POe+DcVfqn4jwlw7WWAnDjCFCzxyJJAyCjUK8O2B/FF0Zxi3alyGYSVo7pdBrJ
	rN3DEDeomiqoEPYHPd4OGx65XSCVL8OXh69LXGG/G9SUwA=
X-Google-Smtp-Source: AGHT+IFwvar+wsG4FBl5vSzTKtvzzcZSSsUwcJKm4NYVGJjyCTw+UOVFKL0QtUgf1sIodiucxXoPhufdjxE1FCU+EnA=
X-Received: by 2002:a17:90b:4d0b:b0:32e:43ae:e7e9 with SMTP id
 98e67ed59e1d1-339c27a50ffmr18199311a91.17.1759784826013; Mon, 06 Oct 2025
 14:07:06 -0700 (PDT)
MIME-Version: 1.0
References: <20250930055826.9810-1-laoar.shao@gmail.com> <20250930055826.9810-8-laoar.shao@gmail.com>
In-Reply-To: <20250930055826.9810-8-laoar.shao@gmail.com>
From: Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date: Mon, 6 Oct 2025 14:06:50 -0700
X-Gm-Features: AS18NWA5h_LyhLDePhUuadn5dRHPb5TmltG_t5VK7dL6TJb8Nc89-wJV0_TukYU
Message-ID: <CAEf4BzaGRDiW3fRt3i+7vvRB+oQszKjaLWVMSU6JrfmXHsJ45w@mail.gmail.com>
Subject: Re: [PATCH v9 mm-new 07/11] bpf: mark vma->vm_mm as __safe_trusted_or_null
To: Yafang Shao <laoar.shao@gmail.com>
Cc: akpm@linux-foundation.org, david@redhat.com, ziy@nvidia.com, 
	baolin.wang@linux.alibaba.com, lorenzo.stoakes@oracle.com, 
	Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com, 
	dev.jain@arm.com, hannes@cmpxchg.org, usamaarif642@gmail.com, 
	gutierrez.asier@huawei-partners.com, willy@infradead.org, ast@kernel.org, 
	daniel@iogearbox.net, andrii@kernel.org, ameryhung@gmail.com, 
	rientjes@google.com, corbet@lwn.net, 21cnbao@gmail.com, 
	shakeel.butt@linux.dev, tj@kernel.org, lance.yang@linux.dev, 
	rdunlap@infradead.org, bpf@vger.kernel.org, linux-mm@kvack.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Mykyta Yatsenko <mykyta.yatsenko5@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 65C95C0007
X-Stat-Signature: mcjpokf4di4rgczb9bewdnptmmma3t7f
X-Rspam-User: 
X-HE-Tag: 1759784827-803463
X-HE-Meta: U2FsdGVkX1+n5Ftzt6j31WU9WbL1/ohaq4vMF37fvE4D36cn4qzb9iK93k525Hh+udLvnCUiN+aHgqeWpRtQp+qcL92VoViOHrVjMyNzaxqC+eJOwiACE4wWWKGZZxknLU811F2PzXlRu9vTy2gvczfjMwtZZpGbd0cu89ZUhmwiDn3Ir7aWuRiauFvvl21z/rpVUDuN2Lvvfact/7aKZTOCtgW46gBGfDtx3rlcrm3LhRcIbJMzqYegdAA3nqQV7dJT6NQtp0wujYdBRAwghfLY+mExNENQnmEq9fy1GzjiylvhG0gDt5jJl+NeMr9VvVpsV7YfLGuH+Gn/heOL+mF1ssdXUmARgxdpI8b+H0k4c+vhkwbZuBGHoJOEW99z+zDegpjmAswNRQ5e3niRRXHErgLIloD/04ThKJpSXgeMSFUUdivLVFG/x1fe0zNiEbpBRq4qn81nlG7Hu2Hp1OPmSDvhor2UqjUJk5k7L4xKe6rglhdEhNG8EFaxVoVb4r2jGBRzwaSuM2TYGDaux2hh80UC1up3LWuSIcfsoULZ57S4+o49nIuItvLP/x3C3LqmxeReas001gTCWzKagnr6fJzbXG4B38prsMYQ/VqMgvRIG5P+SQap0k29sI5EbmwhlUBRXhhSJRLn73YF7a1tL3o8i2FQK3obMpjGRHmMScAcybNQ8BVv2QfC7f3Chv51uO8ekrbiefF9LlzeSIf7oZzExHL86/1toM0yXTTYXXOuUYmoHQ/jhb8pd2anxJYbGuwWzBSodej1JTs+5s/djh3wiAG3dH3NyInbEHpXFLlJRikfdCBed6Q9+xa2ydn4rvq9ZkqdWOBm+j9UGpmpcWyQRrQPR3N793D4Pk6mPQXw3TrUw2Fdkk0csxwQCRLrXvmRsv9ZuH07ikSveAL2Rtb4Uo2OM7dkIL6ju5o1CB5JjxnuvGtNWpuduahEeNR4hUcXSJQvqMnIJP6
 ZbljatgX
 5nj4oNligFJp7mAHUt9+ivirKKukphVkVVkBJl4XqI7w6T65JlIHqY+qdtvYUHqZ1FvX7/51jGOTL6uhKA8nnymp7APlNKKJ0nrjbyxq9jujPAtBL2jhuoBP3zmAZ/2E4SI+DuiXEgzZdBrc2eqSM2Gte9VMCMtRAIjadABqgoUVObghFY6b0Dj7Jz1QiTymIQmtQCDj+spzR8UPpjnNXL1mofIV7fhLZniI/w5G3Wq2MXV6INdujgFE6vs7k8KM+56w70o2XZqqcXmh/hKo+bgA12zKg+peBLRMIxW/tJA/AEgHN2o17cm61u7FPdbbjMLBQjOzLJ8HoS6THr1kle1ow901lS1QeC+Amx9J4OxHpdVIBerreWPb1yFzkl7SAIHtQCajOB3q2zPwbkrcNwUilBHGRBHgEaaJirSnLfd3EMAqhzXmI3dnmuCt5PQQUYL89rOlJRPhCi8dkm+3r/Xi9GKnXPzEofjwhDI8rM+EQ6QnMAYDb8daHmZJBgFdT3jjF66+3UkadF/1hfkQRgxb7ss4sRDBXWuw97cBCmlpvQm8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 29, 2025 at 11:00=E2=80=AFPM Yafang Shao <laoar.shao@gmail.com>=
 wrote:
>
> The vma->vm_mm might be NULL and it can be accessed outside of RCU. Thus,
> we can mark it as trusted_or_null. With this change, BPF helpers can safe=
ly
> access vma->vm_mm to retrieve the associated mm_struct from the VMA.
> Then we can make policy decision from the VMA.
>
> The "trusted" annotation enables direct access to vma->vm_mm within kfunc=
s
> marked with KF_TRUSTED_ARGS or KF_RCU, such as bpf_task_get_cgroup1() and
> bpf_task_under_cgroup(). Conversely, "null" enforcement requires all
> callsites using vma->vm_mm to perform NULL checks.
>
> The lsm selftest must be modified because it directly accesses vma->vm_mm
> without a NULL pointer check; otherwise it will break due to this
> change.
>
> For the VMA based THP policy, the use case is as follows,
>
>   @mm =3D @vma->vm_mm; // vm_area_struct::vm_mm is trusted or null
>   if (!@mm)
>       return;
>   bpf_rcu_read_lock(); // rcu lock must be held to dereference the owner
>   @owner =3D @mm->owner; // mm_struct::owner is rcu trusted or null
>   if (!@owner)
>     goto out;
>   @cgroup1 =3D bpf_task_get_cgroup1(@owner, MEMCG_HIERARCHY_ID);
>
>   /* make the decision based on the @cgroup1 attribute */
>
>   bpf_cgroup_release(@cgroup1); // release the associated cgroup
> out:
>   bpf_rcu_read_unlock();
>
> PSI memory information can be obtained from the associated cgroup to info=
rm
> policy decisions. Since upstream PSI support is currently limited to cgro=
up
> v2, the following example demonstrates cgroup v2 implementation:
>
>   @owner =3D @mm->owner;
>   if (@owner) {
>       // @ancestor_cgid is user-configured
>       @ancestor =3D bpf_cgroup_from_id(@ancestor_cgid);
>       if (bpf_task_under_cgroup(@owner, @ancestor)) {
>           @psi_group =3D @ancestor->psi;
>
>           /* Extract PSI metrics from @psi_group and
>            * implement policy logic based on the values
>            */
>
>       }
>   }
>
> Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
> Acked-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
> ---
>  kernel/bpf/verifier.c                   | 5 +++++
>  tools/testing/selftests/bpf/progs/lsm.c | 8 +++++---
>  2 files changed, 10 insertions(+), 3 deletions(-)
>

Hey Yafang,

This looks like a generally useful change, so I think it would be best
if you can send it as a stand-alone patch to bpf-next to land it
sooner.

Also, am I imagining this, or did you have similar change for the
vm_file field as well? Any reasons to not mark vm_file as trusted as
well?

> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> index d400e18ee31e..b708b98f796c 100644
> --- a/kernel/bpf/verifier.c
> +++ b/kernel/bpf/verifier.c
> @@ -7165,6 +7165,10 @@ BTF_TYPE_SAFE_TRUSTED_OR_NULL(struct socket) {
>         struct sock *sk;
>  };
>
> +BTF_TYPE_SAFE_TRUSTED_OR_NULL(struct vm_area_struct) {
> +       struct mm_struct *vm_mm;
> +};
> +
>  static bool type_is_rcu(struct bpf_verifier_env *env,
>                         struct bpf_reg_state *reg,
>                         const char *field_name, u32 btf_id)
> @@ -7206,6 +7210,7 @@ static bool type_is_trusted_or_null(struct bpf_veri=
fier_env *env,
>  {
>         BTF_TYPE_EMIT(BTF_TYPE_SAFE_TRUSTED_OR_NULL(struct socket));
>         BTF_TYPE_EMIT(BTF_TYPE_SAFE_TRUSTED_OR_NULL(struct dentry));
> +       BTF_TYPE_EMIT(BTF_TYPE_SAFE_TRUSTED_OR_NULL(struct vm_area_struct=
));
>
>         return btf_nested_type_is_trusted(&env->log, reg, field_name, btf=
_id,
>                                           "__safe_trusted_or_null");
> diff --git a/tools/testing/selftests/bpf/progs/lsm.c b/tools/testing/self=
tests/bpf/progs/lsm.c
> index 0c13b7409947..7de173daf27b 100644
> --- a/tools/testing/selftests/bpf/progs/lsm.c
> +++ b/tools/testing/selftests/bpf/progs/lsm.c
> @@ -89,14 +89,16 @@ SEC("lsm/file_mprotect")
>  int BPF_PROG(test_int_hook, struct vm_area_struct *vma,
>              unsigned long reqprot, unsigned long prot, int ret)
>  {
> -       if (ret !=3D 0)
> +       struct mm_struct *mm =3D vma->vm_mm;
> +
> +       if (ret !=3D 0 || !mm)
>                 return ret;
>
>         __s32 pid =3D bpf_get_current_pid_tgid() >> 32;
>         int is_stack =3D 0;
>
> -       is_stack =3D (vma->vm_start <=3D vma->vm_mm->start_stack &&
> -                   vma->vm_end >=3D vma->vm_mm->start_stack);
> +       is_stack =3D (vma->vm_start <=3D mm->start_stack &&
> +                   vma->vm_end >=3D mm->start_stack);
>
>         if (is_stack && monitored_pid =3D=3D pid) {
>                 mprotect_count++;
> --
> 2.47.3
>

