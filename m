Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4A66ECAC582
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 08:04:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6743E8E0006; Fri, 12 Sep 2025 04:04:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 623B88E0001; Fri, 12 Sep 2025 04:04:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4FAD18E0006; Fri, 12 Sep 2025 04:04:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 57D688E0001
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 04:04:12 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8F179C0758
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 08:04:11 +0000 (UTC)
X-FDA: 83879860302.19.0473FA2
Received: from mail-qk1-f181.google.com (mail-qk1-f181.google.com [209.85.222.181])
	by imf06.hostedemail.com (Postfix) with ESMTP id A6526180003
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 08:04:09 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=UAAg2ZRD;
	spf=pass (imf06.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.222.181 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757664249;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R9kzsA//wpYq4jCc4/cU2xPStiaIfnlqm31u2FS1/80=;
	b=vU8GB+fiWfFydyvjbWFY7kEbupbj3+7oikNd08MhBmdfmwzcYPE6XrYQ/0jkOz+C5pp5GP
	jvF8YdTt7fMq9GzLtbsOyFQ37MiGw58zlwMpBZ7DtlyPQh124ye0dlhYoHHMgO/11p9YSj
	nqCWqt9YqUKcbWRpkoYgEtbfQqWYSqk=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=UAAg2ZRD;
	spf=pass (imf06.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.222.181 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757664249; a=rsa-sha256;
	cv=none;
	b=LdFoMmaNJo2b14bJGRCAjoUyr1PDfVgOJYJq7kIrNzyAT9mZIFcFurCbtHbTWgIWjqFvet
	rkMxU1iBuSMErqWLE7sivR+/J/9oLYpQHD35cLQddZ85vkQmP/UXXxJzwruIpVt3Aqstvo
	dxYZTFGWXdbrcsHDSLwibAjR2XkODIM=
Received: by mail-qk1-f181.google.com with SMTP id af79cd13be357-80a6937c8c6so188059185a.2
        for <linux-mm@kvack.org>; Fri, 12 Sep 2025 01:04:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757664249; x=1758269049; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=R9kzsA//wpYq4jCc4/cU2xPStiaIfnlqm31u2FS1/80=;
        b=UAAg2ZRDyyDL0DZljlZ3PKBO7iJhQM9ZXrt0kaKW9sDgxB7dPT3FkX5nROx9ajlTHP
         slty5dEVXdzGkUV7L00GvOaNO3ae/qbf3a1BmVxFiHzfzTp4jVb8dlVBP+dlw8ojI3Qr
         v1uAagZYvDAX6iJSiOA/pChh4gqy6J/eTVn1j9bggFYWzgVEd38/Wk2Lq6kz2b+VdJ/E
         bwxGl3sB72ag+U/c4VTbaS1gONTo9T9hgkv9zIgcPQ2nDu7cHmsKfhDj2nRTQJpf51++
         DhctjjOF+mwazqLjAgGI3ixxNY+A0R3+N8f1PqjQnK4wV2aNeT3/KpMwYVrnPx4Vh7EA
         T+rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757664249; x=1758269049;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=R9kzsA//wpYq4jCc4/cU2xPStiaIfnlqm31u2FS1/80=;
        b=OOTQbP2EZzNSFofdw/K0YMg6VNwQAKvs+sTdN5Gw8AGClp/uNj+3henyGkOaIDny2T
         +PMGvO/o3UrjLzmgoDKz+8Sw53ps9lie5jTi8dRtTWkLJjOiQXMlWYzG6yydRFJpnqjZ
         cvSuNH4e82ajqh+9MVv/HIZ6UbmfFLaSnIX2XbO3n7bfMRN2Kf7Gje7wyY9BtAmoQT7A
         7eZ4/o/hGgDW8n/8Uhr5E8La0+ltIRChUsPFEIGd5M68fq60NlEt5mpeAjb1vVzopUHx
         eOcjRE7ufAIxYNcsvbE/MYEs+BsJx/ERxPnz2QgCFwbP57zQ3FdjP5i4YJ0GNfq0Np2W
         mVOw==
X-Forwarded-Encrypted: i=1; AJvYcCU/iMR5WT4dyzgZAD+Gxyfq3ZWD4PnUphdYUAjzKqHeiqF3dv1C7MNnL4N3JmLXQ663srtyJcEPUw==@kvack.org
X-Gm-Message-State: AOJu0YzDkc21b0xkHj9qT79s/CK2zWoe/UtcVEc68PRjRq0Aphwt1oUK
	sH26KxXvBEZXlxNABm7m2a/gK0tkEnOPkku0W2YLjeq1LFumjZVX3BJHAdSoqkD8TtUaE6ErOL3
	KLQxMR7reO2siSWERitdn4p9H9H+f6zg=
X-Gm-Gg: ASbGncsCRpwCeBAyLauadrdTaKaejvwMQKJcPRpPzaAq7xCXhWMRKQysphHTJq8eUt1
	LmbBbTp4gxbUufT4ngihdD5wDjtDAqjoBD868XocOVsRTDSKU3/DJ5VM3klQ3JOrgQ8SdMu+USd
	sZH8eMQlanmg8+eMmGLQWPSUxc2gmkpJpCSN2sA5rnHEGUZ5gCLQCxCuFU67l7OnXKtrJxSg47W
	ZkFXOaz/uNSDgpuyGrR/qXT3Y2zmfjEU+rw6kxIixq7tD4RU/k=
X-Google-Smtp-Source: AGHT+IE/rRxj5RfD+jcO6rOLKI2X4Bc67cmPj4n4+LR7XsAcv1UA2oLigMwdjougFZk3BL3ls1kQK8Z3ivxUUHKV+3w=
X-Received: by 2002:a05:620a:a203:b0:800:e534:ea6c with SMTP id
 af79cd13be357-82400c2387dmr234122085a.77.1757664248706; Fri, 12 Sep 2025
 01:04:08 -0700 (PDT)
MIME-Version: 1.0
References: <20250910024447.64788-1-laoar.shao@gmail.com> <20250910024447.64788-3-laoar.shao@gmail.com>
 <c7cc3203-502e-4cdb-ade0-25fb9381d0f4@lucifer.local>
In-Reply-To: <c7cc3203-502e-4cdb-ade0-25fb9381d0f4@lucifer.local>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Fri, 12 Sep 2025 16:03:32 +0800
X-Gm-Features: AS18NWAnNXCrtGWtqD9eMTIlF1-Sphloom2BXF1qQB73hQgvHSaCJsTjlL9fzZc
Message-ID: <CALOAHbDYv5wCj=s3KPWa4DOPhhHLA7Mx8UiHUD3T_bfFQiWmhw@mail.gmail.com>
Subject: Re: [PATCH v7 mm-new 02/10] mm: thp: add support for BPF based THP
 order selection
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: akpm@linux-foundation.org, david@redhat.com, ziy@nvidia.com, 
	baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com, 
	ryan.roberts@arm.com, dev.jain@arm.com, hannes@cmpxchg.org, 
	usamaarif642@gmail.com, gutierrez.asier@huawei-partners.com, 
	willy@infradead.org, ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org, 
	ameryhung@gmail.com, rientjes@google.com, corbet@lwn.net, 21cnbao@gmail.com, 
	shakeel.butt@linux.dev, bpf@vger.kernel.org, linux-mm@kvack.org, 
	linux-doc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: A6526180003
X-Stat-Signature: axqetxsghwruwra3stbwh85mrur6gmn3
X-HE-Tag: 1757664249-615852
X-HE-Meta: U2FsdGVkX18mdMLonwXYJan9miGSDzcuh4Gh7xrgzr9dF0kTLYOysw3aYaUZZ4Hih9TUh2lGc7pK+A0cEfOCoE+cRwIrIs7cjslaq6xhJpJM+2+5dYhuZWmvOXtZe6Xdxrus3qFFSnqDOTvSnQJc+iGDoxoxP7E5DJMxh4wknesLrvuTTzClMkoajNLr2dohcPXe9oyErV/CRNrFlrCU3m1lGHf61tGOXxT/LYNZPob5mXegYoUifNCCYtrXVGbRz6j9VPCbvyr+jSi72xkIdqefipWZw3nXY+dDAo6wzGZc7RYYwriWPh4CZhbE78BS4se05YS6linfRb6/5JaxKRXgq2YSBKnPrRMXimBXKywvrOT1/1im8FwB/EI2Iqnr/vgYhrcrubHGyRrRUpZtBwn0G3F5HH/VDof3nCwrJ+Yh4GioyMmzk3JLElucQpVJEdzCzA6sahMwSNSzBKyV7leT2bmpxr5PBzxEzMO9zOFjh972lWeP3/IulJF+jJDfMIyDNNYgUrKHEyBPVDc5bNM9c/jKBqVxD2td7YUb1Ej09KRnGq260FBLved+EyMRzYFOCiC78Ql/UavdKXj2BMwl8UmZBgHcB4jIhYIOIYAePoZG9vG6UnulRjx1dPpS6tH7y+SDH84eessNlJVlxQRLnPGCLMLjFoZ7vABQHIEiX4U2c2PQnvfGz7u5lR/Dehyu+wAn8W3j/lfFZCMPX31stqtPnTpmMOvmMA6BC2BaG3bg6xPX1i3H6Dm7Ux0b3ulEJjPAhOoo2XZj6XIYuPneKEdAaLUfs4N8pfgpJ1kX1+WRWYNr2LIlgcenRL0/nDsAkkeln9v0HYOcA35N0wzW9jCr43wNWKeYq1aEaO7EFApLdmtag4wSTwGvRcyhrU0/lVRtHPTrBhZLRpZ7mrjKZulffSv9BO+2oZXWzy1xrkvz4bFjtDWAY/5glELA95bImCnGKHtrcKDfZrx
 0Fb9PMgS
 izX21QLIvNvwgR8N348Ibtw8D4j5D/5/KnToA5wUZAyLrpx4lP+8SbKo+CAuO3ZOPHD9XTaG699ecN2mUtHuPvGrOV2M5wIPXnFPzJ3J8RQktRKncVgFvuegNK7IquBVUONgYYLDoYSXwYLiBtNF6dMQtr4ZgoE1DVfK9oxoW4a0ObtTTSDK0Y9TwfkYzg9fsAct6MPQgEHHJvyhppTzBfG3AdJui6KUgFTk79g4zOms0i4oHHphCX4L1lhQC6d8Ym5OT2wzslkDjoHAXuyMDo+LQ5ufmlhqms6ivdgLvxJuSSr64lkcsluNc+ZazBfj5dGbRb+aqm4VTmeak6vWkro7woFylTpamTcdy1nctWkPEA+IMhuB6tSF4zyKaK8c+AbDMVXgUoGXF64eH9S6Vh7yfwZz0QQwcRyS2
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 11, 2025 at 10:51=E2=80=AFPM Lorenzo Stoakes
<lorenzo.stoakes@oracle.com> wrote:
>
> On Wed, Sep 10, 2025 at 10:44:39AM +0800, Yafang Shao wrote:
> > diff --git a/mm/huge_memory_bpf.c b/mm/huge_memory_bpf.c
> > new file mode 100644
> > index 000000000000..525ee22ab598
> > --- /dev/null
> > +++ b/mm/huge_memory_bpf.c
>
> [snip]
>
> > +unsigned long bpf_hook_thp_get_orders(struct vm_area_struct *vma,
> > +                                   vm_flags_t vma_flags,
> > +                                   enum tva_type tva_type,
> > +                                   unsigned long orders)
> > +{
> > +     thp_order_fn_t *bpf_hook_thp_get_order;
> > +     unsigned long thp_orders =3D orders;
> > +     enum bpf_thp_vma_type vma_type;
> > +     int thp_order;
> > +
> > +     /* No BPF program is attached */
> > +     if (!test_bit(TRANSPARENT_HUGEPAGE_BPF_ATTACHED,
> > +                   &transparent_hugepage_flags))
> > +             return orders;
> > +
> > +     if (vma_flags & VM_HUGEPAGE)
> > +             vma_type =3D BPF_THP_VM_HUGEPAGE;
> > +     else if (vma_flags & VM_NOHUGEPAGE)
> > +             vma_type =3D BPF_THP_VM_NOHUGEPAGE;
> > +     else
> > +             vma_type =3D BPF_THP_VM_NONE;
> > +
> > +     rcu_read_lock();
> > +     bpf_hook_thp_get_order =3D rcu_dereference(bpf_thp.thp_get_order)=
;
> > +     if (!bpf_hook_thp_get_order)
> > +             goto out;
> > +
> > +     thp_order =3D bpf_hook_thp_get_order(vma, vma_type, tva_type, ord=
ers);
> > +     if (thp_order < 0)
> > +             goto out;
> > +     /*
> > +      * The maximum requested order is determined by the callsite. E.g=
.:
> > +      * - PMD-mapped THP uses PMD_ORDER
> > +      * - mTHP uses (PMD_ORDER - 1)
> > +      *
> > +      * We must respect this upper bound to avoid undefined behavior. =
So the
> > +      * highest suggested order can't exceed the highest requested ord=
er.
> > +      */
> > +     if (thp_order <=3D highest_order(orders))
> > +             thp_orders =3D BIT(thp_order);
>
> OK so looking at Lance's reply re: setting 0 and what we're doing here in
> general - this seems a bit weird to me.
>
> Shouldn't orders be specifying a _mask_ as to which orders are _available=
_,
> rather than allowing a user to specify an arbitrary order?
>
> So if you're a position where the only possible order is PMD sized, now t=
his
> would let you arbitrarily select an mTHP right? That does no seem correct=
.
>
> And as per Lance, if we cannot satisfy the requested order, we shouldn't =
fall
> back to available orders, we should take that as a signal that we cannot =
have
> THP at all.
>
> So shouldn't this just be:
>
>         thp_orders =3D orders & BIT(thp_order);

That's better.  I will change it.

--=20
Regards
Yafang

