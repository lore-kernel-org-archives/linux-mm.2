Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C14ADEB5941
	for <linux-mm@archiver.kernel.org>; Tue, 10 Feb 2026 23:41:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A59B66B0088; Tue, 10 Feb 2026 18:41:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A079F6B0089; Tue, 10 Feb 2026 18:41:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E93F6B008A; Tue, 10 Feb 2026 18:41:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 7BF386B0088
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 18:41:20 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 28DE11B270E
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 23:41:20 +0000 (UTC)
X-FDA: 84430170720.09.7BEBA8B
Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	by imf09.hostedemail.com (Postfix) with ESMTP id 3A1A3140002
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 23:41:18 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="rUxqdm/6";
	spf=pass (imf09.hostedemail.com: domain of surenb@google.com designates 209.85.160.174 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770766878;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=udnAXYhV8NVH9LmStk7ouTFsolaMp28MpPWhOY0c84I=;
	b=pGsFPzl+XkMm9ZkJ8j5TjGHYCe5pm0fy2dXcV9r/4/x3vP0XSGcUuvDEwN+9EUNR6DmIiJ
	hRb6favjZMeMipcEySqV6bLtQLxPCYKL8AYeI3qceLcvKqpJhXuNHeWG1Q4VUUhDUgllks
	jhg9RQX5wojwlRzaisKN0Cd6gNyxQHg=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="rUxqdm/6";
	spf=pass (imf09.hostedemail.com: domain of surenb@google.com designates 209.85.160.174 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770766878; a=rsa-sha256;
	cv=pass;
	b=fioVD6rO/rORLeRr1RaweuR9PxXqK+eXeckP8VwHr3+4bjqfM9cUwOapMRvHmjxroVHdp6
	a1De6tqYJJSA8/a/AavXTQuRVyzq3UQZKoJ8Ao5n0hJ0yRJD2lERXrhaNdFN3aRjnBJLne
	dbCPgc+CcOU7k5aqh5YRyCRt88E5028=
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-5033b64256dso103711cf.0
        for <linux-mm@kvack.org>; Tue, 10 Feb 2026 15:41:17 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770766877; cv=none;
        d=google.com; s=arc-20240605;
        b=eg9mhxXwfQK1VLyPq5vFw9Iz2vudOzY+ylQVx0UhfA3fXnM6adyjQZVLpcA6DFhzqp
         CQKe6924e2dHDUM+9p8dM2cDZ0hqyAnM5hxWL266gYO02hUii8bxhCm6LXikAXWZlyu9
         rVFsupiIDSgqJGDGWeR3YCYn6cDC/iRNZpsX4IcNow9zLqHV+etO7zHkmx+WGbQSZO+7
         gTBGkwF6wDRsBszCv/LQzktEbQyo3HT4x+nztdwV8Xl6dln4PFvPgEQkFc0XqAysgLU0
         83s9a+45BKakEgTbcUbtQE0pryAhuObFzeq4LvKfTvMTGgRySMi6QtXx1/LUqLWbYUri
         wdpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=udnAXYhV8NVH9LmStk7ouTFsolaMp28MpPWhOY0c84I=;
        fh=Hj99GUVW3qPjuTRQrtUADc/Mz5npz4VnpBFsecoiUM8=;
        b=Z8SMlDa2zXsc+To45yYZprPHzVl1GsDE4a4HcZZ20kX2sFS77yaIHh4Y6Ogid+Zij6
         vhGf80O5v3e9brYfG3cCw/VvXB3uwVldpbs5tvCIdfO/pDXl3Zb9ZzFZHonVUhq8R83M
         MynJ6P6EREdRPBO1SyCbZlnWOXUv8Dz94V9btjdbxDvmYZlig1tRJmCXp2bBf29cv3hQ
         6NaWKtk4VOUZZToPDXJN5mKcHSeLysuP7ro3xF7X3LxIbq/T/L6AxeSd9pQMnAwCyIc1
         W8XsdtV79cJmaC5pSWCy+z7+LnFIdpnfjP6FF8if9fb45fZWrAIBhxhTWEjuSEq8bBJ8
         jjJg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770766877; x=1771371677; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=udnAXYhV8NVH9LmStk7ouTFsolaMp28MpPWhOY0c84I=;
        b=rUxqdm/62r0+FZoT0Gg2GePbZoQ9vKFTzGkAi/uM75t11A9t43m/JNXUvxtyYaJFdL
         wIH8rcwGV5sCWEy7QY5xBgZq0aMkhu2DpGhhOfcy0+wHZZKqPfpiF68DB+FRaMamTHk4
         OeOvS6z8LZW2rJzypxLH0xPV7kwyZ1/yQxmHzw0qrSrtIVVfWpSNfAcRLRrRM7N8tm/K
         5Xt0KHQepAT9jJXASLES1c9vwC/vTlyksPLXF9b43coMqh2Q5vh+gkdiCwZjEqgLU5T+
         2r2yl1Wk6T+hVfqJiYDF7EiWF+p2kFnHxhcpfpGFhImcy+sOX6mjI5D5KbT6bL8s36x4
         OrZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770766877; x=1771371677;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=udnAXYhV8NVH9LmStk7ouTFsolaMp28MpPWhOY0c84I=;
        b=Z9IzbLpSOfe9njHBp+SVjwRNLl8AwlhhHVo0XTDG6rHEK0bat6cMfZ43OABHzCxQY9
         gE6CZtYE2QTwqBLgEf+XgdP70y/H6DreC+ehWmxxnfs+9SKegcD3HKKp+MmneoPlRua5
         1k5g/fRDavIqMfG55+mI9DjIMNfERGKLMVHIz9VXN/r/nGwZleYzD95qQ7lxmvcelFYi
         4NPpkCmIItPLWHdzOJrcn+nMNypfTnR/wZJHiI/OxWItvuTGunHI0VyW7JDX48xlaAA7
         y6YXHqw8xV9cZA3li3mjUjO0KSbLG9PJwLTTbtkcpfeXL5w8aimbUIn3cic/YDNDEcMO
         PptA==
X-Forwarded-Encrypted: i=1; AJvYcCUmrQFIr2F0YlcNh9bDlJnDTwgUdiXUCj9yvZsoi/q/s80C5TGibNcxrnsUDspxDQRghC+1DpyG5w==@kvack.org
X-Gm-Message-State: AOJu0Yzk6o3Lfsbb6M4gDCfF1M6RqvsqwnHQG+1tdja21SgoVkAKEUB7
	ts1HyrNRuPs1ShGqMCPiN96PhKcnfHhRP24lyDP7mifz/wl2NQGVxXNTopEdMHx4RZQI9RnghRe
	Uz9alh2ffLZ3p3T81pMZPYCSwHEEYcDVeAU9e1p7L
X-Gm-Gg: AZuq6aLap4IPw8MoDzn7paxoN9IP9diLZCqRSp7EQX9zrBIKkFhXP+7TSB1jQ2LG95D
	S44HppR91BVZUQyuA8CKU7PQnabHZtB95JNNZl7zZqlAsPQ3vesseTTcYDGrT7vw+m8Dl2LD9zw
	AWPhXDqFFX9p+WTz90eCLeneT8C55iNeX2yOFsdxkwQZt7hqlfwn85LnZ86bIyyGLYusFsrRv1q
	ZRhaF7MCzdIglTtPoGfGBoTTSx5XX79443WuTdWEN8FBR5EzSm5bZFYEaVG8ITU4kT389+P9Sq4
	SGbErg==
X-Received: by 2002:a05:622a:138c:b0:503:4bc:c925 with SMTP id
 d75a77b69052e-50682758209mr2319781cf.13.1770766876608; Tue, 10 Feb 2026
 15:41:16 -0800 (PST)
MIME-Version: 1.0
References: <20260209220849.2126486-1-surenb@google.com> <CAG48ez2zFfCO7RKhHKaATFge7DWzaTfO+Yta0y4_HXGHZAtkqw@mail.gmail.com>
In-Reply-To: <CAG48ez2zFfCO7RKhHKaATFge7DWzaTfO+Yta0y4_HXGHZAtkqw@mail.gmail.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Tue, 10 Feb 2026 15:41:05 -0800
X-Gm-Features: AZwV_QjArW2JodMN7wRauZ3Ugy-7cBqUa9oRhicJr9JxwV2UIkPUp8XXpXf8gmc
Message-ID: <CAJuCfpGKoy2Aj9f-gfKDmsa5wWvv9=b3mS6hRgaADQGrd8dYEQ@mail.gmail.com>
Subject: Re: [PATCH 1/1] mm: replace vma_start_write() with vma_start_write_killable()
To: Jann Horn <jannh@google.com>
Cc: akpm@linux-foundation.org, willy@infradead.org, david@kernel.org, 
	ziy@nvidia.com, matthew.brost@intel.com, joshua.hahnjy@gmail.com, 
	rakie.kim@sk.com, byungchul@sk.com, gourry@gourry.net, 
	ying.huang@linux.alibaba.com, apopple@nvidia.com, lorenzo.stoakes@oracle.com, 
	baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com, 
	ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org, 
	lance.yang@linux.dev, vbabka@suse.cz, rppt@kernel.org, mhocko@suse.com, 
	pfalcato@suse.de, kees@kernel.org, maddy@linux.ibm.com, npiggin@gmail.com, 
	mpe@ellerman.id.au, chleroy@kernel.org, linux-mm@kvack.org, 
	linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 3A1A3140002
X-Stat-Signature: ih55pq3bn55zzdgbord5afznxu3x8m6a
X-Rspam-User: 
X-HE-Tag: 1770766878-557796
X-HE-Meta: U2FsdGVkX1+3zppGzDXCwC5RmykIUKFZv2D0aYnIc5l9SiVzY83rmr072MeVU2UsvcfG1jSQ1DfkgaPuAlyfXi6rKqZhoWqpA1hJu2WRHv71ZqmPTzBWFRxuOjXfBrXwleIibiAsq0LKG5GiY/dZEbceCzShLqqE4BUTNYOxNwNnEbx+N7QrrJSEr30xCrPcKj+ZBQicPd0I2/CT8D7EKwYdl2MWqrDR4NmB5H1PW/g7ax9PkYUqe7t4JdCDVKQgaenxIQ5CLpj2Psp0UhQxF4QqaNmX11zx1WYAfwH+sRPfr7fzEmJPpdOoji3b5ZbUzz5KBhaMhNXTk1eJjNsEoLc996NpSGv5p5sCS1Sdnha4MGL0+L2kRa3RUP+VRqB4yS7UYMC8H9jSvxJktyEvfKv/XKTpbPJIphaT1NLdv4koGLLmRxYzDb7KaflOV5uzfppZ1BtxD442aOwizDcUYM5485YptrFfNDJ0yhh1t8s2x+y3Z8e9kGQPbh8Nfl/2GbzSV94Rn82zPn2uBDW2//LRkNmvmMbRAvkw73hvbqF3XsnfecnYNhcLLlDW1qdUTDNitE8+GgA5xylFHs7XaiFZyLhzSTVhGBo4lpVpQwasvDGcte7G0Cc2a/mfvLdoL5NKL6bs+bhq3o58XyEdJ6iweMwGyrLPXhRul2QhG3+dJRUp3Ok8Ok81RldxZIQsWCvMwh6uNUk2EvFWI5OGQsFWxhT9yRgXYniSinfJcmCR1R0YO76FUxfRX8WNPS873xK8JC7OL4AjdKKL/r5PXV3kzI7sPaDvzRkcs1AHpHePpKoBiiQDsRFdXiAazNAEkGuVgObDwPlv8aKU8KKdg5AlUjZKfgLaTqv5Oe1Xv9Hj5kocr2XqmhF02eLjv25YSsNE8Gl0JDarI2Vp7v92MGUMe7mbYqJ7hyWnCCnFqsgWaCQyrMdOM3lbyGC/5VIWwEQbBYnpV8ZbtjX26n1
 Nozb37SM
 8quSx1CmpUX0mtx4CLO15RfQ81coSESJwvwcC1XG8Of1W0drNOVzH2k+vCmSRM3MLwDDkyi9m+a+G9wLhF261xiSxByJkoaAoivnLXMXyvopF0ZHaoGuAL1VrQqvGxrDx1Oh5kcZ7a1FZnN2jwPzD9UTEZxHuYwNgq8MTOCGgh1gr1pY6RSHeJbBtdSvJH6+ZRdxakwiZbAFbijSym7F78B5r/FmEy2kwIscohbv8QsmpK9X2ozQ6xK8MTs/0falMOMZ1R5QGbRayURyDdNg8V2LWWSLQ+R5+TwC7JcPK9yi11bu9myxdbSKsPpP6uOjQiKa4evG4CsS/0p6Q64G4pfyOKg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Feb 10, 2026 at 1:19=E2=80=AFPM Jann Horn <jannh@google.com> wrote:
>
> On Mon, Feb 9, 2026 at 11:08=E2=80=AFPM Suren Baghdasaryan <surenb@google=
.com> wrote:
> > Now that we have vma_start_write_killable() we can replace most of the
> > vma_start_write() calls with it, improving reaction time to the kill
> > signal.
> [...]
> > diff --git a/mm/mempolicy.c b/mm/mempolicy.c
> > index dbd48502ac24..3de7ab4f4cee 100644
> > --- a/mm/mempolicy.c
> > +++ b/mm/mempolicy.c
> [...]
> > @@ -1808,7 +1817,11 @@ SYSCALL_DEFINE4(set_mempolicy_home_node, unsigne=
d long, start, unsigned long, le
> >                         break;
> >                 }
> >
> > -               vma_start_write(vma);
> > +               if (vma_start_write_killable(vma)) {
> > +                       err =3D -EINTR;
>
> Doesn't this need mpol_put(new)? Or less complicated, move the
> vma_start_write_killable() up to somewhere above the mpol_dup() call.

Thanks for the review, Jann!

Yes you are right. I'll move it before mpol_dup().

>
> > +                       break;
> > +               }
> > +
> >                 new->home_node =3D home_node;
> >                 err =3D mbind_range(&vmi, vma, &prev, start, end, new);
> >                 mpol_put(new);
> [...]
> > diff --git a/mm/pagewalk.c b/mm/pagewalk.c
> > index a94c401ab2cf..dc9f7a7709c6 100644
> > --- a/mm/pagewalk.c
> > +++ b/mm/pagewalk.c
> > @@ -425,14 +425,13 @@ static inline void process_mm_walk_lock(struct mm=
_struct *mm,
> >                 mmap_assert_write_locked(mm);
> >  }
> >
> > -static inline void process_vma_walk_lock(struct vm_area_struct *vma,
> > +static inline int process_vma_walk_lock(struct vm_area_struct *vma,
> >                                          enum page_walk_lock walk_lock)
> >  {
> >  #ifdef CONFIG_PER_VMA_LOCK
> >         switch (walk_lock) {
> >         case PGWALK_WRLOCK:
> > -               vma_start_write(vma);
> > -               break;
> > +               return vma_start_write_killable(vma);
>
> There are two users of PGWALK_WRLOCK in arch/s390/mm/gmap.c code that
> don't check pagewalk return values, have you checked that they are not
> negatively affected by this new possible error return?

Uh, even the ones which check for the error like queue_pages_range()
don't seem to handle it well. I'll split this part into a separate
patch as I think it will be sizable and will go over all users to
ensure they handle the new error.

>
> >         case PGWALK_WRLOCK_VERIFY:
> >                 vma_assert_write_locked(vma);
> >                 break;
> [...]
> > diff --git a/mm/vma.c b/mm/vma.c
> > index be64f781a3aa..3cfb81b3b7cf 100644
> > --- a/mm/vma.c
> > +++ b/mm/vma.c
> > @@ -540,8 +540,12 @@ __split_vma(struct vma_iterator *vmi, struct vm_ar=
ea_struct *vma,
> >         if (new->vm_ops && new->vm_ops->open)
> >                 new->vm_ops->open(new);
> >
> > -       vma_start_write(vma);
> > -       vma_start_write(new);
> > +       err =3D vma_start_write_killable(vma);
> > +       if (err)
> > +               goto out_fput;
> > +       err =3D vma_start_write_killable(new);
> > +       if (err)
> > +               goto out_fput;
>
> What about the new->vm_ops->open() call and the anon_vma_clone()
> above? I don't think the error path properly undoes either. These
> calls should probably be moved further up, so that the point of no
> return in this function stays where it was.

Ack.

>
> >         init_vma_prep(&vp, vma);
> >         vp.insert =3D new;
> [...]
> > @@ -1155,10 +1168,12 @@ int vma_expand(struct vma_merge_struct *vmg)
> >         struct vm_area_struct *next =3D vmg->next;
> >         bool remove_next =3D false;
> >         vm_flags_t sticky_flags;
> > -       int ret =3D 0;
> > +       int ret;
> >
> >         mmap_assert_write_locked(vmg->mm);
> > -       vma_start_write(target);
> > +       ret =3D vma_start_write_killable(target);
> > +       if (ret)
> > +               return ret;
> >
> >         if (next && target !=3D next && vmg->end =3D=3D next->vm_end)
> >                 remove_next =3D true;
> > @@ -1186,17 +1201,19 @@ int vma_expand(struct vma_merge_struct *vmg)
> >          * Note that, by convention, callers ignore OOM for this case, =
so
> >          * we don't need to account for vmg->give_up_on_mm here.
> >          */
> > -       if (remove_next)
> > +       if (remove_next) {
> > +               ret =3D vma_start_write_killable(next);
> > +               if (ret)
> > +                       return ret;
> >                 ret =3D dup_anon_vma(target, next, &anon_dup);
> > +       }
> >         if (!ret && vmg->copied_from)
> >                 ret =3D dup_anon_vma(target, vmg->copied_from, &anon_du=
p);
> >         if (ret)
> >                 return ret;
>
> nit: the control flow here is kinda chaotic, with some "if (ret)
> return ret;" mixed with "if (!ret && ...) ret =3D ...;".

I'll see what I can do about it but probably as a separate patch.

>
> >
> > -       if (remove_next) {
> > -               vma_start_write(next);
> > +       if (remove_next)
> >                 vmg->__remove_next =3D true;
> > -       }
> >         if (commit_merge(vmg))
> >                 goto nomem;
> >
> [...]
> > @@ -2211,9 +2240,8 @@ int mm_take_all_locks(struct mm_struct *mm)
> >          * is reached.
> >          */
> >         for_each_vma(vmi, vma) {
> > -               if (signal_pending(current))
> > +               if (vma_start_write_killable(vma))
> >                         goto out_unlock;
> > -               vma_start_write(vma);
>
> nit: might want to keep the signal_pending() so that this can sort of
> be interrupted by non-fatal signals, which seems to be the intention

Yes, I will bring back that check.

>
> >         }
> >
> >         vma_iter_init(&vmi, mm, 0);
> > @@ -2549,7 +2577,9 @@ static int __mmap_new_vma(struct mmap_state *map,=
 struct vm_area_struct **vmap)
> >  #endif
> >
> >         /* Lock the VMA since it is modified after insertion into VMA t=
ree */
> > -       vma_start_write(vma);
> > +       error =3D vma_start_write_killable(vma);
> > +       if (error)
> > +               goto free_iter_vma;
>
> This seems way past the point of no return, we've already called the
> ->mmap() handler which I think means removing the VMA again would
> require a ->close() call. The VMA should be locked further up if we
> want to do it killably.

Yeah, I realized this big issue after posting the patch. Moving it up
seems possible, so I'll try that.

Thanks,
Suren.

>
> >         vma_iter_store_new(vmi, vma);
> >         map->mm->map_count++;
> >         vma_link_file(vma, map->hold_file_rmap_lock);
> >

