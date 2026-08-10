Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E0CC1C5AD4E
	for <linux-mm@archiver.kernel.org>; Mon, 10 Aug 2026 08:06:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ACA046B007B; Mon, 10 Aug 2026 04:06:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A7A876B008A; Mon, 10 Aug 2026 04:06:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 942866B008C; Mon, 10 Aug 2026 04:06:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6B3316B007B
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 04:06:47 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E4D624069D
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 08:06:46 +0000 (UTC)
X-FDA: 85084628412.05.2963EC8
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	by imf25.hostedemail.com (Postfix) with ESMTP id F150AA0003
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 08:06:44 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=OQW7PitU;
	spf=pass (imf25.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 209.85.128.48 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786349205;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lb84MTARn8U7o4c1RHhqcBiYy05PvlUptLl1sMIzsSE=;
	b=vI+8kcjcmnectKWGcj7fM+yVXU99q/DD2s58O+1t5xpKJvS6GN6iVZnT4v/8JT9gCsiHR6
	rYp03ecTcpjAKmyEBzkOCb0f0zYUYu+j+EyNBeflhUFHgwhAA2TxPwa7yvjRKjMm3Q8+i2
	hAsKV5I1FPaak+casqh3ka5+X9COwSU=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1786349205;
	b=3O9a8ATd3n+Mlexd5EU9sl+2yp9vieFK1lJZW84AgFk4eEWTMKl081txrueruy7JElK6HJ
	Fz2K8/hmvIBdmk7FQghNqFWeOGK1nZI2klIH3KAT9jxm3v3sjJuJYqyToobmcchqoA9DOS
	b68t2XlAp0fv6Q/g3E9LhJ4I7zNmqNc=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=OQW7PitU;
	spf=pass (imf25.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 209.85.128.48 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-49967f24eedso2074175e9.0
        for <linux-mm@kvack.org>; Mon, 10 Aug 2026 01:06:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786349203; cv=none;
        d=google.com; s=arc-20260327;
        b=V//HgOG4FUbOTP4BP2T8ciOGLADubsrnfPcAB/+b7MHic0LogyuTLuVtXkcSuybSKU
         sgC0XbGFQmMwxqLDAozrlxRZ5JDuuI2Vtu/bkW11RP7JU94pmdHRaYl/wyMcJNJ+AKWZ
         tHsdXq1LBeDw9Hdf7w0sF6dC/3KjpkNPMGoCjfWgAnw0W4V9sXaoJfnfnWn/jTsHUQXw
         fmhKrLAzJxWr1kBVIUOYxVRgDNGlaSAuxRsstumsrkHZni+ARuyiEQ9407+2HnKgY7dp
         U1kv+sHhWP0vKfjxDsPeDSAGpYsm5noIZvfA0OohVpPpuz4ZH6pncmwkuZvgYkyFNl9Q
         9v7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=lb84MTARn8U7o4c1RHhqcBiYy05PvlUptLl1sMIzsSE=;
        fh=/zaawmd4J2YChvPWfAcp+nTMKixGt+G2bYhgteIC/Is=;
        b=Pncv5rfiWzoqkgO/fHelfIYaYN+iaJtMGLXBC3Kote4H5iYONCUlD+tr9Px/g13JYl
         OUXJrHP/DAdDFjUCad1hv470JEZ0PnjI39R834iPGU8iIpZXsxDhlfRNvuZpnDzAk8gG
         jYIAnT/GGUm18Hqc1vuXYyy8PsGfeaqJ991gFhUp2SfUG18dCTZl2RPOxBtceO8eqB1V
         jLzFz6bUVHYNMi5JM9ObMOISlsP9vqXZOZqKPuaOIrujoXlbPxmsb/X5Gg9zOjJ6vzwx
         KH/67wLePmviEWPofrBZgffU03D2izkWSJnmVmuzfy3JOW5aQ3gs/6zzwDTh/hi6ubf+
         dfjw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786349203; x=1786954003; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=lb84MTARn8U7o4c1RHhqcBiYy05PvlUptLl1sMIzsSE=;
        b=OQW7PitULWXqcKZSxYN6in48hXI+WOzZtBsY88pOu4TdIkDAfLwipp7Xour5IwjSuZ
         /t7UCo0XP/ViZgyOPHFWxpZkx3e9j0luRzkozPk1Q9XVH1ZhqyY7e6KvR1GzdjYNFAq4
         mZMts7J1xDZLW8IBIJJ20Gdh1g9eZiri1e/QzoTFAkjtzipp9oLWxcrNcZDnmztiGFMX
         3Gb09mYWSkXTgIyjc4lnvrm4NgOXQwx9xqO1jR70wa7GBp9E5+lwnS8AIBSEkGoi2hoc
         9ZtpAF1TlRX27j/NmAmy3J/NtdQBlArOFvmSsMRwcidsqi4boN2OugatfBdE2fPF6Hob
         nH4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786349203; x=1786954003;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=lb84MTARn8U7o4c1RHhqcBiYy05PvlUptLl1sMIzsSE=;
        b=pGf4WfOrBvI+X7vaUzd1YkHk+HVnLoy3kk2We5WM/CAePVVNjaHkOYaYgDJEPRcGGH
         pz0XKYFkdkFEPqixoCjbzKtrh4OSon6Bb1Duz3TFEun3Dnv70sYLRPYTjywp6HanuKk7
         752m5OUNJy7dJXZjrNJR0HpLGi1yMQNTjdscmtUyOeGZMULJD+F5hRSsIaYHf6JiU6Si
         oMf8LgsNmrF7VaHae+iSJvayLh2so7tf2n5QD4Fv+3RQUPPRM3Wel+2ygkDeyuhM1m5Y
         8qA/RV3K8kewsBGH+l4Rgx+5I5FEgGUDdwtZbExZm0J7Z4XB1+pOk2CZ/kjvl1JWVUeh
         NM6w==
X-Forwarded-Encrypted: i=1; AHgh+RqSNyifxC0ntc3MFxn4HkWLJp7GSyDwpQYMeJReoyHuadlsEC4jHGm2cCRs0wIh0odejFaEGXV3sw==@kvack.org
X-Gm-Message-State: AOJu0YxqkE+GaDi7nxVlwRp1RQhzngpi5KVz00XUDNrhJUNBWezneyPG
	XLEolLkTU075aZKZlMpjgQU+KTyePuisYpRxoRI2B0msyqkvk88T9115Y8lRS5lHwJkjBJY06De
	trKl7JHcLunmRZIVR6gCq5aMEgxOUmG8=
X-Gm-Gg: AR+sD11F6KgxdEtrb5e5JkUxrp/N/wVRHxDhEsS/epWZYKXiozAdI0YSTyJUqFW9TK+
	9oEyMBASjD5JiABezb/3lxcjXLCxI4nSBaBCNU7s9fo9m8mOs8dpmY1LlJ8mLOxjqs/u1S072Fi
	p5hVTAcD0tYxtyO9HmRJyxgyj9x5NrPM34yYg/XU4EqdxLV+qiHsDIWdHllJVd9ozOWf9xNMfb/
	rFY4q/RQr22pOskNpmPdStRfnf1yPnJBYMBvgpMooRk7ZAsmLjqzXFIOITkO6tzvXamYo+8hZia
	EoCUqavCFnw2QHbPgsJr38rSreC3sq/yq+XBeS4SzV5UOF+n3VABYSCmOzIegTU5CwPt8YXvSE6
	L4AlQOicxVg0UmcszIRt1v0qbru2oJRILrynKBqWL5m8=
X-Received: by 2002:a05:600c:4514:b0:493:f42e:1b3f with SMTP id
 5b1f17b1804b1-4994e7c7360mr265158745e9.3.1786349202901; Mon, 10 Aug 2026
 01:06:42 -0700 (PDT)
MIME-Version: 1.0
References: <20260730122304.2496440-1-xueyuan.chen21@gmail.com>
 <20260730122304.2496440-3-xueyuan.chen21@gmail.com> <anWAZ3T6Sz8bsKSo@KASONG-MC4>
In-Reply-To: <anWAZ3T6Sz8bsKSo@KASONG-MC4>
From: Xueyuan Chen <xueyuan.chen21@gmail.com>
Date: Mon, 10 Aug 2026 16:06:29 +0800
X-Gm-Features: AUfX_my1zKS9rRfeQVRR_iYgHii3BkYqDGS35o7i0XrAqVeAoQI09AAC_0cvR_0
Message-ID: <CA+qSx6yzyOYT8OzFRjya6=N9FFwGkc_nyytku7i5B46dO-MYaQ@mail.gmail.com>
Subject: Re: [RFC PATCH v5 2/4] mm: distinguish large folio swap allocation failures
To: Kairui Song <ryncsn@gmail.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, zhaonanzhe@xiaomi.com, 
	baohua@kernel.org, hannes@cmpxchg.org, youngjun.park@lge.com, 
	baolin.wang@linux.alibaba.com, hughd@google.com, chrisl@kernel.org, 
	kasong@tencent.com, shikemeng@huaweicloud.com, nphamcs@gmail.com, 
	baoquan.he@linux.dev, mhocko@kernel.org, roman.gushchin@linux.dev, 
	shakeel.butt@linux.dev, muchun.song@linux.dev, david@kernel.org, 
	ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, 
	surenb@google.com, qi.zheng@linux.dev, axelrasmussen@google.com, 
	yuanchu@google.com, weixugc@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: F150AA0003
X-Rspam-User: 
X-Stat-Signature: kdgqtnd6ycnzyoc3tsgc9z18oz1fuicr
X-HE-Tag: 1786349204-57158
X-HE-Meta: U2FsdGVkX18ypKFCJsSUDEKYe31fS8Xpztw/KhwZxK1LbGpGmVsaM11raRNxbbKtu79X+vNBsQNOApaVD0wrCWcSNMehNf4e7MRc5FTl1hu11qhsrOH2rhl3EFtFO3D1O9uA5KYPXNV3KO/ACfsJh0cw5jUC6ThxKDIx/zs5o9JSnxHQHF6YDgxhYbjL4sHW1Dw2GH8lDg13udqtvH7OoHZOSPS6TYx7llB+VBNm8FQjT8LEdXpp2W7VWN25KTOrlDTr1b5dpECLrElAQwhXWP7pdPEX2GR3jK8BXxDlAUPxA351HA4O4cYSBSlpy2TV9A6soW9qtmYOOykOyK546aYtk0KcT6nlYIsLqgiRl/9h/w+0xMxSxiSErWOTTasnOKyqd0wbODthO/bdRc/SWWeDP9X76bDXq+5evN7cdw+Ga8OjcVnoRgF6sxkAnahxFZRgFIhyd98AkHtIBTwN5tsNyC/BuRIj9flwuY5k0KDkFdG6O0IfKUPphnx7kXa1qpVWDOhJ0jryC4oZwzop5RB5yMiC5y0wZyHwe+bSxOPZZh+t4FGZlTWGhBx3gJ/q/aIvShIjgI1YVuhEdF0UmKwujN9ip5BRdgz3QkRJ7iCi4NfPNqQsuBbaR5niP8cDiI7Kh9qvnSszrTiwpvZKpG828hHFfPNM/SEmpPQNhH7hBC6030k5D39jE6m1ikw8Jxa0zRcMVk2bFNm4ZnRyG7aoz2Rut1cluWAHJL8gC/Do5UEuyH5ibvLjvPursL/zk4dUTSBu0zshUsavbiYIRPp3lBUaX7oiVjLD8ZLYiF387grVY/7dEutbLYFHOtj8J331M63rzyBtmFiAGDyfBpoU469oc22upphYuYpFAw1S1/jEConSeIpopmyzXekYrHtfEVNacMA1QBy5uzZDOdoU5j7LnXwe5AV6bTU9AV2/RwqdhUKJBjPJf4hDYIgcISyUnspbiXV+Oskagta
 LaauNsYC
 r3tSIy88G3ZzWWIoG7qk13+Xdg2hM3HqieC0TRg+iJfnu9PYPUgBsZ3W4FdXTiF8h0W535EqbzpapX/xTItLKzVoEIvQuzHiK3VWzc2V+tBroTQapnHzPsNNkM3FB++tt0Fjtr5Ty6oJ0hvuwvO0htA1+WXM2FghP6nZrm+sb5OgHI/5qstwPObP4J3G7sPEiPz0fz0I4I3fROovtrxk6OtHZO/0pCutzgH0BJFvUXdtMyKL3PCUovGk+CvE9FtwC3dW7ivt/70XqIw12zzzIm5yCXlzAzgkNiMzglEykTfRdsjw80Lrt+58vnc5rYyxx3qL6Fd3vC/KIJ3Kiml8XKDDTZi6jSXXooEgeEuiKgCuLEzrCn3Gi1V6xOYJuCk6pCb0WTlYg4pds3fTalO0gOSmVBWYHELsS9wMStCtAf8XiG+ObLU/Q2g9SUDgnEDkSv+ty5HXIh3Llxo0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Kairui Song <ryncsn@gmail.com> =E4=BA=8E2026=E5=B9=B48=E6=9C=887=E6=97=A5=
=E5=91=A8=E4=BA=94 16:29=E5=86=99=E9=81=93=EF=BC=9A
>
[...]
>
> Hello Xueyuan,
>
> Thanks for the patch!
>
> > diff --git a/include/linux/swap.h b/include/linux/swap.h
> > index 0544b2ec4c56..7d12058174ae 100644
> > --- a/include/linux/swap.h
> > +++ b/include/linux/swap.h
> > @@ -509,12 +509,13 @@ static inline void folio_throttle_swaprate(struct=
 folio *folio, gfp_t gfp)
> >  #endif
> >
> >  #if defined(CONFIG_MEMCG) && defined(CONFIG_SWAP)
> > -int __mem_cgroup_try_charge_swap(struct folio *folio);
> > -static inline int mem_cgroup_try_charge_swap(struct folio *folio)
> > +int __mem_cgroup_try_charge_swap(struct folio *folio, long *swap_margi=
n);
> > +static inline int mem_cgroup_try_charge_swap(struct folio *folio,
> > +                                          long *swap_margin)
>
> Am I the only one that feel this returning argument is a bit ugly? See be=
low..

Hi Kairui,

Yes, it does look a bit odd :P

>
> > +/**
> > + * mem_cgroup_get_folio_swap_margin - get a folio's memcg swap margin
> > + * @folio: folio whose memcg margin is queried
> > + *
> > + * Return: Remaining chargeable pages in the folio's memcg hierarchy.
> > + */
> > +long mem_cgroup_get_folio_swap_margin(struct folio *folio)
> > +{
> > +     long swap_margin =3D PAGE_COUNTER_MAX;
> > +     struct mem_cgroup *memcg;
> > +     struct obj_cgroup *objcg;
> > +
> > +     if (mem_cgroup_disabled() || do_memsw_account())
> > +             return swap_margin;
> > +
> > +     objcg =3D folio_objcg(folio);
> > +     if (!objcg)
> > +             return swap_margin;
> > +
> > +     rcu_read_lock();
> > +     memcg =3D obj_cgroup_memcg(objcg);
> > +     swap_margin =3D page_counter_margin(&memcg->swap);
> > +     rcu_read_unlock();
> > +
> > +     return swap_margin;
> > +}
> > +
>
> Will is be good if we just always check the margin use this helper
> on alloc failure? Alloc failure should be a rather cold path I think?
>
> >  bool mem_cgroup_swap_full(struct folio *folio)
> >  {
> >       struct mem_cgroup *memcg;
> > diff --git a/mm/swapfile.c b/mm/swapfile.c
> > index 70b90fa9c2a0..ae62c9f9c0f2 100644
> > --- a/mm/swapfile.c
> > +++ b/mm/swapfile.c
> > @@ -1735,23 +1735,28 @@ static int swap_dup_entries_cluster(struct swap=
_info_struct *si,
> >   * swap cache.
> >   *
> >   * Context: Caller needs to hold the folio lock.
> > - * Return: Whether the folio was added to the swap cache.
> > + * Return: %0 on success, %-E2BIG if splitting the folio might allow s=
wapout,
> > + * %-ENOSPC if no global swap space is available, or %-ENOMEM if split=
ting
> > + * would not help.
> >   */
> >  int folio_alloc_swap(struct folio *folio)
> >  {
> >       unsigned int order =3D folio_order(folio);
> >       unsigned int size =3D 1 << order;
> > +     long swap_margin =3D PAGE_COUNTER_MAX;
> >
> >       VM_BUG_ON_FOLIO(!folio_test_locked(folio), folio);
> >       VM_BUG_ON_FOLIO(!folio_test_uptodate(folio), folio);
> >
> >       if (order) {
> >               /*
> > -              * Reject large allocation when THP_SWAP is disabled,
> > -              * the caller should split the folio and try again.
> > +              * Reject large allocation when THP_SWAP is disabled. Che=
ck below
> > +              * whether splitting and retrying can make progress.
> >                */
> > -             if (!IS_ENABLED(CONFIG_THP_SWAP))
> > -                     return -EAGAIN;
> > +             if (!IS_ENABLED(CONFIG_THP_SWAP)) {
> > +                     swap_margin =3D mem_cgroup_get_folio_swap_margin(=
folio);
> > +                     goto failed;
> > +             }
> >
> >               /*
> >                * Allocation size should never exceed cluster size
> > @@ -1759,7 +1764,8 @@ int folio_alloc_swap(struct folio *folio)
> >                */
> >               if (size > SWAPFILE_CLUSTER) {
> >                       VM_WARN_ON_ONCE(1);
> > -                     return -EINVAL;
> > +                     swap_margin =3D mem_cgroup_get_folio_swap_margin(=
folio);
> > +                     goto failed;
> >               }
> >       }
> >
> > @@ -1775,13 +1781,23 @@ int folio_alloc_swap(struct folio *folio)
> >       }
> >
> >       /* Need to call this even if allocation failed, for MEMCG_SWAP_FA=
IL. */
> > -     if (unlikely(mem_cgroup_try_charge_swap(folio)))
> > +     if (unlikely(mem_cgroup_try_charge_swap(folio, &swap_margin))) {
> >               swap_cache_del_folio(folio);
> > +             return order && swap_margin > 0 ? -E2BIG : -ENOMEM;
> > +     }
> >
> >       if (unlikely(!folio_test_swapcache(folio)))
> > -             return -ENOMEM;
> > +             goto failed;
> >
> >       return 0;
> > +
> > +failed:
> > +     if (get_nr_swap_pages() <=3D 0)
> > +             return -ENOSPC;
> > +     if (swap_margin <=3D 0)
> > +             return -ENOMEM;
> > +
> > +     return order ? -E2BIG : -ENOMEM;
> >  }
>
> How do you think if we apply this on top of this? (Not tested)
> Should be no behavior change but outside the existing races, the margin
> read moves from charge time to failure classification time, a small
> TOCTOU, which the original also has but in a different way.

Thanks a lot for the review and suggestion. I'll simplify the code along
the lines of your diff in the next version. :)

>
> diff --git a/include/linux/swap.h b/include/linux/swap.h
> index 7d6216c8b830..dcf01d4c5e1b 100644
> --- a/include/linux/swap.h
> +++ b/include/linux/swap.h
> @@ -490,13 +490,12 @@ static inline void folio_throttle_swaprate(struct f=
olio *folio, gfp_t gfp)
>  #endif
>
>  #if defined(CONFIG_MEMCG) && defined(CONFIG_SWAP)
> -int __mem_cgroup_try_charge_swap(struct folio *folio, long *swap_margin)=
;
> -static inline int mem_cgroup_try_charge_swap(struct folio *folio,
> -                                            long *swap_margin)
> +int __mem_cgroup_try_charge_swap(struct folio *folio);
> +static inline int mem_cgroup_try_charge_swap(struct folio *folio)
>  {
>         if (mem_cgroup_disabled())
>                 return 0;
> -       return __mem_cgroup_try_charge_swap(folio, swap_margin);
> +       return __mem_cgroup_try_charge_swap(folio);
>  }
>
>  extern void __mem_cgroup_uncharge_swap(unsigned short id, unsigned int n=
r_pages);
> @@ -511,8 +510,7 @@ long mem_cgroup_get_folio_swap_margin(struct folio *f=
olio);
>  extern long mem_cgroup_get_nr_swap_pages(struct mem_cgroup *memcg);
>  extern bool mem_cgroup_swap_full(struct folio *folio);
>  #else
> -static inline int mem_cgroup_try_charge_swap(struct folio *folio,
> -                                            long *swap_margin)
> +static inline int mem_cgroup_try_charge_swap(struct folio *folio)
>  {
>         return 0;
>  }
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index b4c65ccf3538..d89054dd96a8 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -5650,13 +5650,12 @@ int __init mem_cgroup_init(void)
>  /**
>   * __mem_cgroup_try_charge_swap - try charging swap space for a folio
>   * @folio: folio being added to swap
> - * @swap_margin: remaining memcg swap margin if allocation or charge fai=
ls
>   *
>   * Try to charge @folio's memcg for the swap space at folio->swap.
>   *
>   * Returns 0 on success, -ENOMEM on failure.
>   */
> -int __mem_cgroup_try_charge_swap(struct folio *folio, long *swap_margin)
> +int __mem_cgroup_try_charge_swap(struct folio *folio)
>  {
>         unsigned int nr_pages =3D folio_nr_pages(folio);
>         struct swap_cluster_info *ci;
> @@ -5675,7 +5674,6 @@ int __mem_cgroup_try_charge_swap(struct folio *foli=
o, long *swap_margin)
>         rcu_read_lock();
>         memcg =3D obj_cgroup_memcg(objcg);
>         if (!folio_test_swapcache(folio)) {
> -               *swap_margin =3D page_counter_margin(&memcg->swap);
>                 memcg_memory_event(memcg, MEMCG_SWAP_FAIL);
>                 rcu_read_unlock();
>                 return 0;
> @@ -5689,7 +5687,6 @@ int __mem_cgroup_try_charge_swap(struct folio *foli=
o, long *swap_margin)
>             !page_counter_try_charge(&memcg->swap, nr_pages, &counter)) {
>                 memcg_memory_event(memcg, MEMCG_SWAP_MAX);
>                 memcg_memory_event(memcg, MEMCG_SWAP_FAIL);
> -               *swap_margin =3D page_counter_margin(counter);
>                 mem_cgroup_private_id_put(memcg, nr_pages);
>                 return -ENOMEM;
>         }
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index 5d8d04576c13..09760985b911 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -1756,7 +1756,6 @@ int folio_alloc_swap(struct folio *folio)
>  {
>         unsigned int order =3D folio_order(folio);
>         unsigned int size =3D 1 << order;
> -       long swap_margin =3D PAGE_COUNTER_MAX;
>
>         VM_BUG_ON_FOLIO(!folio_test_locked(folio), folio);
>         VM_BUG_ON_FOLIO(!folio_test_uptodate(folio), folio);
> @@ -1766,10 +1765,8 @@ int folio_alloc_swap(struct folio *folio)
>                  * Reject large allocation when THP_SWAP is disabled. Che=
ck below
>                  * whether splitting and retrying can make progress.
>                  */
> -               if (!IS_ENABLED(CONFIG_THP_SWAP)) {
> -                       swap_margin =3D mem_cgroup_get_folio_swap_margin(=
folio);
> +               if (!IS_ENABLED(CONFIG_THP_SWAP))
>                         goto failed;
> -               }
>
>                 /*
>                  * Allocation size should never exceed cluster size
> @@ -1777,7 +1774,6 @@ int folio_alloc_swap(struct folio *folio)
>                  */
>                 if (size > SWAPFILE_CLUSTER) {
>                         VM_WARN_ON_ONCE(1);
> -                       swap_margin =3D mem_cgroup_get_folio_swap_margin(=
folio);
>                         goto failed;
>                 }
>         }
> @@ -1794,10 +1790,8 @@ int folio_alloc_swap(struct folio *folio)
>         }
>
>         /* Need to call this even if allocation failed, for MEMCG_SWAP_FA=
IL. */
> -       if (unlikely(mem_cgroup_try_charge_swap(folio, &swap_margin))) {
> +       if (unlikely(mem_cgroup_try_charge_swap(folio)))
>                 swap_cache_del_folio(folio);
> -               return order && swap_margin > 0 ? -E2BIG : -ENOMEM;
> -       }
>
>         if (unlikely(!folio_test_swapcache(folio)))
>                 goto failed;
> @@ -1807,7 +1801,7 @@ int folio_alloc_swap(struct folio *folio)
>  failed:
>         if (get_nr_swap_pages() <=3D 0)
>                 return -ENOSPC;
> -       if (swap_margin <=3D 0)
> +       if (mem_cgroup_get_folio_swap_margin(folio) <=3D 0)
>                 return -ENOMEM;
>
>         return order ? -E2BIG : -ENOMEM;
>

