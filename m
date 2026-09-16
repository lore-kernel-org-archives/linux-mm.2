Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 856E9C982C9
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 19:07:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 654426B0088; Wed, 16 Sep 2026 15:07:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 605CF6B008C; Wed, 16 Sep 2026 15:07:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4CCF16B0092; Wed, 16 Sep 2026 15:07:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1E0226B0088
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 15:07:19 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5FE1F1C2F57
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 19:07:18 +0000 (UTC)
X-FDA: 85220558556.29.74C7375
Received: from mail-qk2-f13.google.com (mail-qk2-f13.google.com [74.125.230.205])
	by imf12.hostedemail.com (Postfix) with ESMTP id 5F1ED40004
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 19:07:16 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=CLe7odtF;
	spf=pass (imf12.hostedemail.com: domain of surenb@google.com designates 74.125.230.205 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789585636;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yHbOQrPgVkpK3KZeBIodImpdgvuoykZQvSNB9/nSIAA=;
	b=0F7yWX8TLn40lpAKG/rTiNksOPmRIcj05hhDGmtyiSVN9/wlmfzMQuPYkvHLCb/9A9m/hY
	ea6IJ4zdmnz0FUKngWymZxAfzHXCxzZQItNM5o7Bbuc5JoEEtdsED3kgn23BYz5Lty8bmp
	bfoeKd45mO8axkeyO6M0vr4O8FNlpDk=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789585636;
	b=gFmpji50kdW4RQbuTdc14PDnOtnd98TfAqz1Olp24HODK6QvXHvi4j4s3oov6ArYEfvK8z
	AdDXEFhGg+CXrdOn4h6PV31XTdXs/gEUWUpsANbhhqkERpeVruV5G2y9tMSQCzEeJcoQLR
	KnTWdDCRpqMC+7gqGiFaQ1WxqvJzad0=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=CLe7odtF;
	spf=pass (imf12.hostedemail.com: domain of surenb@google.com designates 74.125.230.205 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-qk2-f13.google.com with SMTP id d75a77b69052e-530d5fc2cd8so7031cf.1
        for <linux-mm@kvack.org>; Wed, 16 Sep 2026 12:07:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789585635; cv=none;
        d=google.com; s=arc-20260327;
        b=Kg31NKakG3JKcQE8LxkosKyldEMIJ+s7L1LcpKRwdjzA6zwjlknYnzFNlQ3rLjMObd
         Kgmh8jwz/hi03GoIMP6i+fj4SyB3gRROyyYs+qL0QvoXhkr+ZL1Kk48ehaV+VxKHXsHl
         sGIKKIJIIV5qXlUBW98k1lWVbcyUFpVfklTv6ME883GbSA8kFSmod5Tc8hI17HoYx4qq
         7wCDi+cRd6/+i1pBZq8UFzVrOFEZmDQN4BL83buOasc95CH10zHpjyIHdGaZm/oNmWCC
         g+Sji0RgBIOR/94HjpIltrOeaYRrV5mfap7ScTzz7/5fLUT6sTQsBSQPOf99Hm75HeZ3
         w+Bg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=yHbOQrPgVkpK3KZeBIodImpdgvuoykZQvSNB9/nSIAA=;
        fh=tDmJIWjdoSuApuqL8zAWs/D1z0HZ96piZXZBaHmROkE=;
        b=G27MrvJ8DOE8nT5CEkXkVAtHx48hbTMRglMGEBec3PCeg8mE6wIBIehc2DOlmyQeYV
         SMeCIcJ66jadj0DSgMyNGsjuC6zXdj4kSiINbZz9ucpzPMMkRExB8gG20xVilIY94RQx
         G1yVjb4uO1DljYXn64VBbvSmq15N9M7iknTa++rvCprB0oI6Xs9GL2oe8sRSH8D400LE
         5noaQZN3egx/aUq+5zlzvBlYNiWVU7X5uPp54NYRATBHAFmYD9xXz2PuOTdTXPzs53N0
         2IJ7iVEE1ItKZQexSuBxaRKD+ijkddGw/A+J/nNqcqMmKIRkGannu7xrWhXJMTIKeC9j
         YogQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789585635; x=1790190435; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=yHbOQrPgVkpK3KZeBIodImpdgvuoykZQvSNB9/nSIAA=;
        b=CLe7odtF6WFMr4CutU6CsK3fmC2keaTSbupdjN9VPMdUVQHcFCqR/mZTT85jY9gy56
         8rb3vIjUffi5sGp8EOOHubGb5VsxUvmW1loTpc0bJvLr95Vy3KDjrW6h3T0SwSIM2uGI
         rgXJVxrEWxvcuzbB4GSnMjkF7QeDCLu2xEfYMBFIHLLy38rHStu43jOKBS4yoHPE2OGL
         NNKLA7AG6fDvdlP50oLM0GgwcNwH0SXi+P2bjF8AoM7sJLPAIDJkUhzpSmKq8i4xKUPN
         AEmN3YtR38WNISKLLY+osG+8+Uq2bwIBIzeh8fsMiVCS8RamvepJmRHiIsx2hubbqrcm
         0i7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789585635; x=1790190435;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=yHbOQrPgVkpK3KZeBIodImpdgvuoykZQvSNB9/nSIAA=;
        b=g1j1Pytg0pB7M93RvTIK7M1MKEi3eDb88heft4mk4Ti2+XKVbm2j5kpkwlFyty18Zg
         eQyv4PPCqbOEkIUyNf1wLb0GatcqrOHDZv4MEWlo78+De9Hi6Lw8WgwpflQ540pD2XlM
         9mudAasT7Sg58eHPQSsDnFqPOJoHCmiGqjcsG60ZeQoA2/fpNAtGdjAsbIBBPQUsZjnk
         IsqAJAzk/7+wtMdFxM82KQblzPagCrRtNY4X4NMdXmHz0/YP/em/NWjXWKQSAO+wjjTX
         WEGKwQx3wG1TCp/YGPYnTYeuqsSIDNTH7MkN495OliXQL2ULYbsjZ1dzMzmlOIbMlE4B
         +7pg==
X-Forwarded-Encrypted: i=1; AKwUvBzfiDO8kqV0wlKTB8vkBU5drT+txK7FdGSq/xNEUVwpcFrOV+NC4cuuS2W7wRv7UPephe/TTFiLnQ==@kvack.org
X-Gm-Message-State: AFuF++kNgJ+fCtTgS87EAg3tzNn/DVRrvD1Pn4xNBC0jFcfL5NFUGy+H
	6bxDI1fJH+H+YWF9v2Wxi8OozfawiHg6rCNZoM/dpLMPUx7VTARuIjl/14n4m1TxNdWwd1m+L33
	J11G3Q+KrRIajWSfluzVYw+15HlEPysO60V9534tj
X-Gm-Gg: AYBFou1XYQZbEFSx3iUhiMyeSZ6dy3//dRn3O3jFDwnIwaTdFPd9RZAFzAcGlccCCzC
	sY3kgshBulZ0TCC6PtrUACRsxsLBOpRet7PzK60MNIbK1QLT8J16MugWdnckc0exxf+rzyjWQ7r
	j4pzeLMDdODyRbTCJXeD9la2+M7wIkr3f17Of+jLBaI2XPoF6W+9gbRyz8FhLNE73Xjxnd+GMgy
	2a/LLE/csFNL025mGzoS5rklPRsvnqIsDPLMQvs+lI07msVA3hJw87VL5KmFMy+H01t9ULttWS/
	0IBpAKiKlii9OIXvctPTG2l0a//F77FivAIaMyjDk+2PuYcFEYWyYhRQh7i5kG8RNQlJ6DMnuhL
	e0H07ygPRhg==
X-Received: by 2002:ac8:5d10:0:b0:532:858d:e791 with SMTP id
 d75a77b69052e-5328dc0bc4fmr2243931cf.8.1789585634800; Wed, 16 Sep 2026
 12:07:14 -0700 (PDT)
MIME-Version: 1.0
References: <20260915070001.113559-1-hao.ge@linux.dev> <20260915070001.113559-3-hao.ge@linux.dev>
 <CAJuCfpHJSwNhgotMVpmjVvdv=m52_7Kvzpztf0WcN0AaoSeGGw@mail.gmail.com>
 <60642a7f-2949-428a-8290-40d69c989a77@linux.dev> <CAJuCfpG3d7n=z5WnUQYZsqvrt1pemF8TFvGiGyZGLO7ykVvqAQ@mail.gmail.com>
In-Reply-To: <CAJuCfpG3d7n=z5WnUQYZsqvrt1pemF8TFvGiGyZGLO7ykVvqAQ@mail.gmail.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Wed, 16 Sep 2026 12:07:03 -0700
X-Gm-Features: AcwNN1U77eJFNHkPfe6Ppe6tyXfOBb0DKmw4ydlFrQQ2j_8G2MzMCljaOX2F-Do
Message-ID: <CAJuCfpGeRdFY6UPF-vXxwHvP2+tN=BKgRkmLR3PMLuWhxgzPRA@mail.gmail.com>
Subject: Re: [PATCH v10 2/6] alloc_tag: clean up the populate failure path
To: Hao Ge <hao.ge@linux.dev>, "David Hildenbrand (Red Hat)" <david@kernel.org>, 
	"Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: Luis Chamberlain <mcgrof@kernel.org>, Petr Pavlu <petr.pavlu@suse.com>, 
	Daniel Gomez <da.gomez@kernel.org>, Sami Tolvanen <samitolvanen@google.com>, 
	Aaron Tomlin <atomlin@atomlin.com>, Kent Overstreet <kent.overstreet@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, linux-modules@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Sashiko <sashiko-bot@kernel.org>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 7yaqiyfs6rthsnfhffo5fgmyf77hym9a
X-Rspam-User: 
X-Rspamd-Queue-Id: 5F1ED40004
X-Rspamd-Server: rspam03
X-HE-Tag: 1789585636-569413
X-HE-Meta: U2FsdGVkX1/4Yoym+W0o+sdDA4fh2WJ3BV2gZx5Ov8lfEP0RPDgtBkCaec80BFtea7IzmMNWKekY7ugNlriMarvp2BP7VugwYaykjqxR2iz0r8IyZNZTer1YO7zUwgT7nKWPFWuUghUIV4yxZM6pHTxQm7W8sj6B02O1r6qQjofP5KgRPOSEJWTCHjmMNmARtEc1LYdCj5d46RtDOy7r+RnidzwUHirQYkV1OPSi57wRRNHBsfbRE4cAAWH4L2PB/ksT+zZcUYNsSyFVHzxySf2En973Bhwucw2Mb7A2EK1cBXCxn214s/hD95+z2IJuC8uAnyOqk7dqc8E31U8NfYCezvJMmuEJndh/2na0LNcPXHu/9C/h/ekjIPmfG/70lAzXNtoQ4ca/J7Y0rzNVC8bi6p64GGy11KQHlH4v31rcvPI1+flywYhAdX7sjVMykd99ScTd6nxU2ReNiy9DcApD1hlwv5yXprbsparzrtG4wFD2pda2fbe4moR8IYZmbcJUwZY/E9H/UeM2AZ6SJ8bxthX8jDdR+6kD0jXVZjlvzmGh6kXw4+bimfQ6LW1rjMZ3+IllioIi0aFkaz/covkk5iqIMmaZMdkV1Be8wAUdrxQlMl6fepDfviKj+9I/5/mfmH7cv114KUBvQiwMkOWti5KRbxHRz2aFrSxF4+gpv6EhhjVzPhzxRSqMHmHFsIs+X2GJNMe7CIDKgFXPRENa7Sqxbgccv9KoBxUA1i56f23FqyCbr8a3OIEbfKwSTQAiRf6guimmXybvgEtsm+1VLwMHkbye09TVqcNz5ogrvxLHdnDgRT7d28SK8VOMzZbcQ5a3KOb8rK9ZAqpw0GByqR1dEph7sIQOVIS1WnWy12c5pqRml5SL8xkDbuMQzY5TI+IGjDyaERadzvTdJe/bD8AewzEp54DDUWbqK2Te7noBReKkWVQBkTg1AV8wo+R9bVCaQrMAYm2lugK
 GSoN/6aS
 IMhi9we3Znuhohx126B2D/5ZQ0EL3Xvdz1C6n0OiomtLluVALpTfo+575hcUL4pwyujsdGkzMWPGZ5/VXgQi+kAqbe8zknp8o5bWM6pTivCBFlYdYIx2g6joBfJzd7iuDIbG2v3jobtznAN+4u51GlJ6pqOjJOn8tpIBpalMz7L0wotlbPs7AloTxbjWRWU4wtdJemCjao98ODnYTJiWO2NE48HKOgUnoEezDOZwvF36A2G49aJpVTS7A6BkVqQxid+NZf00+l8ebkEmyk9nZwCPyc1LOCWaRS2yEFPg04a8rW6OPamVlT7isG7YHmW4mgijgOp4HQ+ru3lciFS0EKlHx8YVT41iWdNLDAKCt0fSY8PJ+H2lpO7T6zlbptzOEYQEbnl0pXhhw3X0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 16, 2026 at 9:31=E2=80=AFAM Suren Baghdasaryan <surenb@google.c=
om> wrote:
>
> On Tue, Sep 15, 2026 at 11:00=E2=80=AFPM Hao Ge <hao.ge@linux.dev> wrote:
> >
> > Hi Suren
> >
> > Thanks for you review.
> >
> > On 2026/9/16 05:09, Suren Baghdasaryan wrote:
> > > On Mon, Sep 14, 2026 at 11:59=E2=80=AFPM Hao Ge <hao.ge@linux.dev> wr=
ote:
> > >>
> > >> The reservation is already stored in the maple tree when
> > >> vm_module_tags_populate() fails. A failed load never unloads the
> > >> module, so nothing releases the entry. Release it and roll
> > >> module_tags.size back. Without the rollback a concurrent load that
> > >> already passed needs_section_mem() can reuse the freed gap, skip
> > >> vm_module_tags_populate() and write to unmapped memory.
> > >>
> > >> vmap_pages_range() may have installed some PTEs before failing. A
> > >> retry to populate the same range would BUG on them, so undo them,
> > >> but only if vmap actually ran.
> > >>
> > >> Fixes: 4835f747d3ed ("alloc_tag: support for page allocation tag com=
pression")
> > >> Fixes: 0f9b685626da ("alloc_tag: populate memory for module tags as =
needed")
> > >
> > > If a patch fixes two other patches, it likely needs to be split so
> > > that each part fixes one patch only. But read on please. I'm not sure
> > > if one of the fixes is correct.
> > >
> >
> > Kept them in one patch because they only make sense together.
> >
> > After a failed populate the reservation is released and the
> > size rolled back, so the next load takes the same gap and calls
> > vm_module_tags_populate() again, and that retry would trip over
> > the PTEs the failed vmap left behind.
> >
> > Without the rollback a load that already passed needs_section_mem()
> > just reuses the gap, skips populate and writes to unmapped memory.
> > So splitting them leaves each half broken.
>
> Yeah, that's why I think vmap_pages_range() cleanup should be a
> completely separate patch with vmap_pages_range() doing cleanup
> itself.
>
> >
> > >> Reported-by: Sashiko <sashiko-bot@kernel.org>
> > >> Cc: stable@vger.kernel.org
> > >> Signed-off-by: Hao Ge <hao.ge@linux.dev>
> > >> ---
> > >>  mm/alloc_tag.c | 10 ++++++++++
> > >>  1 file changed, 10 insertions(+)
> > >>
> > >> diff --git a/mm/alloc_tag.c b/mm/alloc_tag.c
> > >> index 2070e682fe10..95ddf5b743d0 100644
> > >> --- a/mm/alloc_tag.c
> > >> +++ b/mm/alloc_tag.c
> > >> @@ -804,6 +804,13 @@ static int vm_module_tags_populate(void)
> > >>                                      next_page, PAGE_SHIFT) < 0) {
> > >>                         release_pages_arg arg =3D { .pages =3D next_=
page };
> > >>
> > >> +                       /*
> > >> +                        * vmap_pages_range() only runs once all pag=
es were
> > >> +                        * allocated, and it may have installed some=
 mappings
> > >> +                        * before failing. Undo them.
> > >
> > > If vmap_pages_range() failed to map the range, why should we need to
> > > undo it? If it indeed leaves some partial mapping when failing then I
> > > would argue that vmap_pages_range() should be undoing these partial
> > > mappings itself before returning the error.
> > >
> > Yeah it does - none of the paths under vmap_pages_range() undo themselv=
es on error.
>
> Hmm. I wonder if this behavior is intentional or requires a fix. The
> only possible reason I can think of is performance but I can't imagine
> a failure to map is a performance-critical case.
>
> +David Hildenbrand (Red Hat), +Lorenzo Stoakes (Oracle) what do you

Huh, my gmail thinks you are still at your previous companies :)

> guys think? Shouldn't vmap_pages_range() undo its possible partial
> mapping when it fails?
>
>
> > pcpu_map_pages does perform cleanup on its own as well. There may be ot=
her similar sites.
> > https://elixir.bootlin.com/linux/v7.3-rc3/source/mm/percpu-vm.c#L255
> > so I did the same here.
> >
> > If we really want vmap_pages_range() to handle this cleanup internally,=
 I believe that would
> > be a relatively large change, and we would need to consider many more c=
ases. So I think we keep
> > the current behaviour for now.
>
> Yeah, I understand it would require a deeper cut but if that's the
> right way to handle this we might as well do that. Let's see what MM
> folks think.
>
> >
> > Thanks
> > Best Regards
> > Hao
> >
> > >> +                        */
> > >> +                       if (nr =3D=3D more_pages)
> > >> +                               vunmap_range(phys_end, phys_end + (n=
r << PAGE_SHIFT));
> > >>                         /* Clean up and error out */
> > >>                         release_pages(arg, nr);
> > >>                         return -ENOMEM;
> > >> @@ -947,6 +954,7 @@ static void *reserve_module_tags(struct module *=
mod, unsigned long size,
> > >>                 return ret;
> > >>
> > >>         if (module_tags.size < offset + size) {
> > >> +               unsigned long prev_size =3D module_tags.size;
> > >>                 int grow_res;
> > >>
> > >>                 module_tags.size =3D offset + size;
> > >> @@ -961,6 +969,8 @@ static void *reserve_module_tags(struct module *=
mod, unsigned long size,
> > >>                         shutdown_mem_profiling(true);
> > >>                         pr_err("Failed to allocate memory for alloca=
tion tags in the module %s. Memory allocation profiling is disabled!\n",
> > >>                                mod->name);
> > >> +                       release_module_tags(mod, false);
> > >> +                       module_tags.size =3D prev_size;
> > >
> > > Yes, this one is a valid fix. It fixes 0f9b685626da commit.
> > >
> > >>                         return ERR_PTR(grow_res);
> > >>                 }
> > >>         }
> > >> --
> > >> 2.25.1
> > >>

