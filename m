Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EB543CA0FED
	for <linux-mm@archiver.kernel.org>; Wed, 27 Aug 2025 21:50:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ECC926B0007; Wed, 27 Aug 2025 17:50:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E7DB36B0088; Wed, 27 Aug 2025 17:50:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D6BDB6B0089; Wed, 27 Aug 2025 17:50:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id C11046B0007
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 17:50:53 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6521A85071
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 21:50:53 +0000 (UTC)
X-FDA: 83823882786.05.903C0AD
Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com [209.85.215.173])
	by imf12.hostedemail.com (Postfix) with ESMTP id 7C2E140010
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 21:50:51 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=mHAOMX0o;
	spf=pass (imf12.hostedemail.com: domain of andrii.nakryiko@gmail.com designates 209.85.215.173 as permitted sender) smtp.mailfrom=andrii.nakryiko@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756331451;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KeDfts8gt4wnyCuEYOnb6uV1ppW7WiK7TkBvoIpFoX0=;
	b=5gMiL6nSkf6lHhciTCMPo2WWON3VPEZd7kfzFv0bM1tLKhtMkxUVGWK4IB8IHuDUjjcfyI
	iDXTKK9RCm5hi8v+euch45Tus/2Y1hV4KFSmODaCyAGgNktP251DKb093Ta6h/F8TY7dzR
	Vlq3dW3RClL8a3zM+RkJPSP0yyV2bGU=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=mHAOMX0o;
	spf=pass (imf12.hostedemail.com: domain of andrii.nakryiko@gmail.com designates 209.85.215.173 as permitted sender) smtp.mailfrom=andrii.nakryiko@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756331451; a=rsa-sha256;
	cv=none;
	b=ixcHW1RKld9vlQhKlw591JsvHUGL/CCBOjQuG6pcwokYpLda0MP0qXmGsgwZosvHeUDIsC
	UGJdF+kIyssN6NRKm2swX32s1iUre8rtNz+PdtYaSxWbJFSY66EiQow+Fxfs7WZflQ6+R3
	LUG4k7EzM+2AVLFEJ4SWu0EZ1KMF7iA=
Received: by mail-pg1-f173.google.com with SMTP id 41be03b00d2f7-b4c21867cceso321753a12.1
        for <linux-mm@kvack.org>; Wed, 27 Aug 2025 14:50:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756331450; x=1756936250; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KeDfts8gt4wnyCuEYOnb6uV1ppW7WiK7TkBvoIpFoX0=;
        b=mHAOMX0oyHCzKrhl47Q4Wgp4U0UDnSCwoNhS03U56vNDxFYzv8+uRr+rHxGRwOjcIY
         WK870OMh9TfkxqeBGzHrzQMcPJJz+e2/oaaXYZC7/Vntebn6dD5KgZ7kuvDS4mFgPnU0
         XziBDsGEZgV2MOLE40pK8QJH9TlmxPicrhoxEwEa4sCabHh4Vqv87Z3DpUlcuppdYLph
         hKcAg2CBeol0sOEWFIqQkQ5Ap88nnZob2yCiuzmgmCk+kcPGQXqDKKnX2++eqCVZzkLt
         hZWOZhgi0FWENx2EammBz7bLYz6z/D6tXuw5WOOIZ2zQw7T8HmHF9wpsHAtRKt89vYIj
         93CQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756331450; x=1756936250;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KeDfts8gt4wnyCuEYOnb6uV1ppW7WiK7TkBvoIpFoX0=;
        b=pywA1xlVU+VzUA3+Z46bqZkZVxbrNfHO3I0AP3LDtOnA3H0ESCnWRXGa8I7zhUoD+U
         n3AYgV4mD916sboz0niA4S7Zs1ZlpN6RRXgjY5Iu4kaLk2JgIHWH9zb7wqlBQZmK3w8M
         +cZ5IUrZAUc96Kg0w564BruW34xu3TBVyajgHVeQG0ZgqRyZUcofZ63c5N4rNbUbH7s6
         Ynqnrk+dXR/xohS52vMIfyHA7bzmjr5m+ltA2tdMYsWGQzujSBQ+6yH3MdUHqqmeGtqj
         9dR9hLA4Tca3Xp+gLABCh+8vjzP04TdJyJwouHJWYDAYNWnRYx9/cKwukJU+vkO0awFG
         IWeg==
X-Forwarded-Encrypted: i=1; AJvYcCVFw4PColXz+KAb1s5PiD2jgriTPE/LUZfkwr+mg7AweWhzwdtQoSbVKHDG2H0O4Kk9FSvNaNaFfw==@kvack.org
X-Gm-Message-State: AOJu0YwezeyWci8G4JhNqJHoSpnXVr+3KSI80sI2ZxSpiRPZJJkXWWxT
	nqFZh5Iqa0Yz5JD5JODiWoWSr3VlLXiZLdtz6by6aIkhJyl+vOJb97YQzl08YvZQoWF+/Bh3wsk
	MI4dBvDb7LpvOLlP+24f1Rah+2XQ87GU=
X-Gm-Gg: ASbGncud33BzJE9OQ3eEsW+NLKtq1/grWArPxFNLlRDjmYOnc9sv92feVg9pc+Vsy9f
	WUuDBu5KT6hJ/H9uFa9K3MwuntaNJTdu4Gzpo7G4ykNGiRmgEyvif1ZxdMWg7zZuM1yZuA6rk5M
	kc+2hijkNkMGmEnI0d2radM+Nt02QQZ26Z6CnvWhT8+m66GgRq5/ZLVBKwcctgOev5ABbqXW3VC
	OMqvfSPG5erO/Wl6r3KWuIfgvnH0KLPxa4COVCB93FR
X-Google-Smtp-Source: AGHT+IGCNb6BmtHpaPHoBHQ6Ipo4VK78lwnolII4TMwisljYP5RNaG/tzMn0ir2zw//Dsg5YMx96cEQPYpz8ClVCC38=
X-Received: by 2002:a17:90b:4d89:b0:325:3937:ef93 with SMTP id
 98e67ed59e1d1-3253937f1bfmr25183524a91.20.1756331450213; Wed, 27 Aug 2025
 14:50:50 -0700 (PDT)
MIME-Version: 1.0
References: <20250826071948.2618-1-laoar.shao@gmail.com> <20250826071948.2618-4-laoar.shao@gmail.com>
 <5fb8bd8d-cdd9-42e0-b62d-eb5a517a35c2@lucifer.local>
In-Reply-To: <5fb8bd8d-cdd9-42e0-b62d-eb5a517a35c2@lucifer.local>
From: Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date: Wed, 27 Aug 2025 14:50:36 -0700
X-Gm-Features: Ac12FXx81PD0lPnzpRyp5ouxJbY2sXvnz6hd1oTpKhVDJte3eFVatPHa4qbmTxo
Message-ID: <CAEf4BzaOA-3NtwTmrPgveqbW16m3KZAAA1E_xn_qjtiJBGsE4g@mail.gmail.com>
Subject: Re: [PATCH v6 mm-new 03/10] mm: thp: add a new kfunc bpf_mm_get_task()
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Yafang Shao <laoar.shao@gmail.com>, akpm@linux-foundation.org, david@redhat.com, 
	ziy@nvidia.com, baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, 
	npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com, hannes@cmpxchg.org, 
	usamaarif642@gmail.com, gutierrez.asier@huawei-partners.com, 
	willy@infradead.org, ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org, 
	ameryhung@gmail.com, rientjes@google.com, corbet@lwn.net, bpf@vger.kernel.org, 
	linux-mm@kvack.org, linux-doc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: o4j5sxy5rjenpqbwndcr8jrobqf5us1p
X-Rspam-User: 
X-Rspamd-Queue-Id: 7C2E140010
X-Rspamd-Server: rspam05
X-HE-Tag: 1756331451-453127
X-HE-Meta: U2FsdGVkX19yRALcR88LlRr7qz/sqxO4QM/56rplaZ9Gt/hGVmdzqp2iR5RdMbWubnnVRVDKW3BR5B7mM0X9JVLAdhvvkBT1PjYsxwcpG1T5WFwQ6NjHiG/lv9ABbP6oJFOtiBBa/4fE7Ajuau/u1Sd7WOXiR2/+DindJtAEuJoIe6Ok6q2Pa1qB4iiGBbkYxqAVi6Qm69eIuhV8kwPyPTM/JZadDfY2SnTc3S6mcFUnPPof/Z3+OkDo+OTH1Ng8ZN6sy2hw1c9kzTgbocVwqj4qivEdUddiX8/gDm6Kuppr+QVRvy2Vz70/cSiYikfaMPTgaQDTH03r3fmfnmejCXUq2LzvQ0/3DX7taXejfRQ4I42MyAeZ4abA5u13EFwlK40lNoAMTGlCgUyhjruxIqb20G90onZ/I3656vHrK59j2QlLhdmr5SOIp52wQw0iPKzP+cFlqkuylN80piTjVQzTmNPIDTUAVVIICY/gUOT+rixIyakM+9X8sWOTTpByuIMACtVMPyZ43WDg9xsjquHDVgHurPoQLtrZYQWtmYAj+zuBvpQZP8Foi1EvwUSs+EdnQDBcj35Qj7b9rgUk7jZrahyCU7+zTT6OW+/TNmwX1vhc7iIK23+SijpLIPsmUw7RqytIlP+nPgHDE3sSmsDbc4dUa2xOPLHIjt3lvZaK+E9LtDl3Z2et2Soo3QQDMdUfxf9EHnTPc6LUjQQt3olJJckIrtCHjA9k+LAe1Z/1iQ7cvfMDjDpiteXtwQmsHGbToYZgLkz52ggn7611wg6Glu2mS8fUD4kPiw+Q45HLLouvrfhKguY4b1zDVRZx7YvANYihCTF4D8T2xkPhE+XFB+PlAyhgBc16l3nRBgAtNt0yuSAoK8neHuyUI6D2Gq7fIJBnugDnh9PbZz/8sV17pYgdPMOs6DaeM+Vmh+Eqb1G7yOO7rfDdTf2Zt+kOt79YZfImLXMLIv/5UGp
 MaDie0dY
 9WORgvaK7MHHg55sDLyq2NCPAY56n3fDfVJnLicNu3RoE9t8SroZ/uRAooglv2sea9VLYfvw8ep9791+V8nY2IeP5Lo+hnfU5fX1jXkkhDraghOT00mwi7UYAzZjIV3NrrzHXLstWsefe8FUSNiF0Gk95gpkbrB0K+wqQFFeI7QtcpBKWh921Z4JjWdUFZUckhkOyFofTvApcqY5psl17QTZfWkK2kqEAjIkaIaSFke152UAAX3RjDTqU56I5aFecdXzkKvq6yX8dNCBX7KokMkomCdp2vtKTzdPnksa+Fapmbn1BL751Vr2D/EtQksELadSRMr5fCewTa0iXOzLDsMVS45R5AQ6kwPnZhXI6CwQgvqH5ediicvqp/+N5P3eaTQNlLEXT1mPN7vKLaU5s+neOS5BCtieBqDRaBxzYAC3YCqFcu8SAGqJ3CO/3YvSh2JR/TwJ+uvDsEYIo/fcZvUFehPsJUDNe+mVd2BCgKrJcJMM0GR+CAFCtldmkZAVTCIzpV+hGfbhfxBBPjOdz2J7gjZHhcOQeC4Ps78Zr/lqgqPM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 27, 2025 at 8:48=E2=80=AFAM Lorenzo Stoakes
<lorenzo.stoakes@oracle.com> wrote:
>
> On Tue, Aug 26, 2025 at 03:19:41PM +0800, Yafang Shao wrote:
> > We will utilize this new kfunc bpf_mm_get_task() to retrieve the
> > associated task_struct from the given @mm. The obtained task_struct mus=
t
> > be released by calling bpf_task_release() as a paired operation.
>
> You're basically describing the patch you're not saying why - yeah you're
> getting a task struct from an mm (only if CONFIG_MEMCG which you don't
> mention here), but not for what purpose you intend to use this?
>
> >
> > Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
> > ---
> >  mm/bpf_thp.c | 34 ++++++++++++++++++++++++++++++++++
> >  1 file changed, 34 insertions(+)
> >
> > diff --git a/mm/bpf_thp.c b/mm/bpf_thp.c
> > index b757e8f425fd..46b3bc96359e 100644
> > --- a/mm/bpf_thp.c
> > +++ b/mm/bpf_thp.c
> > @@ -205,11 +205,45 @@ __bpf_kfunc void bpf_put_mem_cgroup(struct mem_cg=
roup *memcg)
> >  #endif
> >  }
> >
> > +/**
> > + * bpf_mm_get_task - Get the task struct associated with a mm_struct.
> > + * @mm: The mm_struct to query
> > + *
> > + * The obtained task_struct must be released by calling bpf_task_relea=
se().
>
> Hmmm so now bpf programs can cause kernel bugs by keeping a reference aro=
und?

BPF verifier will reject any program that cannot guarantee that
bpf_task_release() will always be called. So there shouldn't be any
problem here.

>
> This feels extremely dodgy, I don't like this at all.
>
> I thought the whole point of BPF was that this kind of thing couldn't pos=
sibly
> happen?
>
> Or would this be a kernel bug?
>
> If a bpf program can lead to a refcount not being put, this is not
> upstreamable surely?
>
> > + *
> > + * Return: The associated task_struct on success, or NULL on failure. =
Note that
> > + * this function depends on CONFIG_MEMCG being enabled - it will alway=
s return
> > + * NULL if CONFIG_MEMCG is not configured.
> > + */
> > +__bpf_kfunc struct task_struct *bpf_mm_get_task(struct mm_struct *mm)
> > +{
> > +#ifdef CONFIG_MEMCG
> > +     struct task_struct *task;
> > +
> > +     if (!mm)
> > +             return NULL;
> > +     rcu_read_lock();
> > +     task =3D rcu_dereference(mm->owner);

Question to Yafang, though. Instead of adding new kfunc just for this,
have you tried marking mm->owner as BTF_TYPE_SAFE_TRUSTED_OR_NULL,
which, if I understand correctly, would allow BPF program to just work
with `mm->owner` (after checking for NULL) directly. And then you can
just use existing bpf_task_acquire()

>
> > +     if (!task)
> > +             goto out;
> > +     if (!refcount_inc_not_zero(&task->rcu_users))
> > +             goto out;

nit: just call bpf_task_acquire(), which will more obviously pair with
suggested bpf_task_release()?

> > +
> > +     rcu_read_unlock();
> > +     return task;
> > +
> > +out:
> > +     rcu_read_unlock();
> > +#endif
>
> This #ifdeffery is horrid, can we please just have separate functions ins=
tead of
> inside the one? Thanks.
>
> > +     return NULL;
>
> So we can't tell the difference between this failling due to CONFIG_MEMCG
> not being set (in which case it will _always_ fail) or we couldn't get a
> task or we couldn't get a refcount on the task.
>
> Maybe this doesn't matter since perhaps we are only using this if
> CONFIG_MEMCG but in that case why even expose this if !CONFIG_MEMCG?
>
> > +}
> > +
> >  __bpf_kfunc_end_defs();
> >
> >  BTF_KFUNCS_START(bpf_thp_ids)
> >  BTF_ID_FLAGS(func, bpf_mm_get_mem_cgroup, KF_TRUSTED_ARGS | KF_ACQUIRE=
 | KF_RET_NULL)
> >  BTF_ID_FLAGS(func, bpf_put_mem_cgroup, KF_RELEASE)
> > +BTF_ID_FLAGS(func, bpf_mm_get_task, KF_TRUSTED_ARGS | KF_ACQUIRE | KF_=
RET_NULL)
> >  BTF_KFUNCS_END(bpf_thp_ids)
> >
> >  static const struct btf_kfunc_id_set bpf_thp_set =3D {
> > --
> > 2.47.3
> >

