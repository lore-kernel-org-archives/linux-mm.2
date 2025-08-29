Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C85FCCA0FF0
	for <linux-mm@archiver.kernel.org>; Fri, 29 Aug 2025 19:19:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 193CE8E0002; Fri, 29 Aug 2025 15:19:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 144578E0001; Fri, 29 Aug 2025 15:19:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 00B5C8E0002; Fri, 29 Aug 2025 15:19:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id DD7548E0001
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 15:19:01 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 706CB1DECEA
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 19:19:01 +0000 (UTC)
X-FDA: 83830757682.12.09030E2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 62DADC0002
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 19:18:59 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qa4Kyefw;
	spf=pass (imf22.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756495139;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ESsrZ5iyKLaLrRSVWCPt9e4j6U4QDLfrUwAH/qOglFI=;
	b=isjYckdvk76A/JOigcsDD4C6ekO4ytc13QKJoZBAraIbw0+xlrC77I97nFjblNQrNIGiLQ
	s3qJj6NKqkRU1aemEnIneuenwYDwAtpZP5RmueOzjJuEwVjlOM26gfEzY5FqlUb+wwzF+C
	+ucOy6UoU6218iUzI0kf8PIB16qSw2g=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756495139; a=rsa-sha256;
	cv=none;
	b=4EyLLqjHDvlPuQZUercJmVvR/rXFJvN5E+seSUrnTphYeYjoCbE+kKETWQYDT8THmndxsU
	KIS3VCepPlCClzD7OP41ppMkACLgcUHdif82DdJN4fFDpHPzBex8OeBvFTmxsHGoPm808z
	Itdkbf+/aRI8VVyxz6CsvCQslFln7FU=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qa4Kyefw;
	spf=pass (imf22.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E6811456F8
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 19:18:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD961C4CEFD
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 19:18:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756495137;
	bh=SfwuYXV0KU6eJVhKE0IPfVFe3B6ROS9QbY1dk+JP8m4=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=qa4KyefwEM+eignqWU370eptpCu7x6iSqxGWzbU+gdoLfpIG5dR8luhNBvK11Qvpe
	 WupEHPuUELuYVVjLhgDuu2qKuXFb5hlCUMLB9SIPV6Ktjg3pg9eUUoKuUBZ4E2NNk6
	 6KsSu2aIQcm5sFMEUGaDlEupO/t6Wf2Fs5Bhjq8a4FuRO/gmbh/IF1xshxmXPScdZc
	 p6hV/6jBHai1mC7xep/QL08bKqM6nqC767rO5llT1/S9DtkC0P/THYx+86WkPMY7DP
	 cdEwNQsMtrN8kWrXDdrMrvYZAC/4JBNdd7f906drihUiUx9FPO1ooqChThHroFv+M1
	 9s8+nydfAAHtg==
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-45b72f7f606so5535e9.1
        for <linux-mm@kvack.org>; Fri, 29 Aug 2025 12:18:57 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCUI/NEr0CxQsEghm7LegM8rocPos3jnareicvCDM4eAAqcS9PLeA69q1i8mqbBsVedYF+eiGPD5iQ==@kvack.org
X-Gm-Message-State: AOJu0YytucrlxK0q2aqFY6bG5MbDgQjwvDwTmaUk0qQ9BTbqYPa/Hs8E
	RJ6GM1ZTctgOSJCJV6bopeUmYIvCx/0Qm1lL8dssJfV2QarMRutGDGdxJR+IVu7psTifGf2pHSk
	uQAoJthj+DBnlwcWlHA7H3vp3vSb2dhZ8xtpI6LAD
X-Google-Smtp-Source: AGHT+IGwYizH5N431wsmMZe4RCeN+XM22BnJRX3a9bmzFsCySK9GHB8zxV4r/939VLJDfuuUh2SvN3//dXotftQ5t5k=
X-Received: by 2002:a05:600c:a101:b0:45b:74f7:9d30 with SMTP id
 5b1f17b1804b1-45b84ae2495mr141155e9.1.1756495135682; Fri, 29 Aug 2025
 12:18:55 -0700 (PDT)
MIME-Version: 1.0
References: <20250807014442.3829950-1-pasha.tatashin@soleen.com>
 <20250807014442.3829950-30-pasha.tatashin@soleen.com> <20250826162019.GD2130239@nvidia.com>
In-Reply-To: <20250826162019.GD2130239@nvidia.com>
From: Chris Li <chrisl@kernel.org>
Date: Fri, 29 Aug 2025 12:18:43 -0700
X-Gmail-Original-Message-ID: <CAF8kJuPaSQN04M-pvpFTjjpzk3pfHNhpx+mCkvWpZOs=0TF3gg@mail.gmail.com>
X-Gm-Features: Ac12FXwg_LGboIxDPBDuUZE0PAjtgg9g5mIDqFcbL5uMlL902h2DZN1Mi-6Fu0Y
Message-ID: <CAF8kJuPaSQN04M-pvpFTjjpzk3pfHNhpx+mCkvWpZOs=0TF3gg@mail.gmail.com>
Subject: Re: [PATCH v3 29/30] luo: allow preserving memfd
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>, pratyush@kernel.org, jasonmiu@google.com, 
	graf@amazon.com, changyuanl@google.com, rppt@kernel.org, dmatlack@google.com, 
	rientjes@google.com, corbet@lwn.net, rdunlap@infradead.org, 
	ilpo.jarvinen@linux.intel.com, kanie@linux.alibaba.com, ojeda@kernel.org, 
	aliceryhl@google.com, masahiroy@kernel.org, akpm@linux-foundation.org, 
	tj@kernel.org, yoann.congal@smile.fr, mmaurer@google.com, 
	roman.gushchin@linux.dev, chenridong@huawei.com, axboe@kernel.dk, 
	mark.rutland@arm.com, jannh@google.com, vincent.guittot@linaro.org, 
	hannes@cmpxchg.org, dan.j.williams@intel.com, david@redhat.com, 
	joel.granados@kernel.org, rostedt@goodmis.org, anna.schumaker@oracle.com, 
	song@kernel.org, zhangguopeng@kylinos.cn, linux@weissschuh.net, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-mm@kvack.org, 
	gregkh@linuxfoundation.org, tglx@linutronix.de, mingo@redhat.com, 
	bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, 
	rafael@kernel.org, dakr@kernel.org, bartosz.golaszewski@linaro.org, 
	cw00.choi@samsung.com, myungjoo.ham@samsung.com, yesanishhere@gmail.com, 
	Jonathan.Cameron@huawei.com, quic_zijuhu@quicinc.com, 
	aleksander.lobakin@intel.com, ira.weiny@intel.com, 
	andriy.shevchenko@linux.intel.com, leon@kernel.org, lukas@wunner.de, 
	bhelgaas@google.com, wagi@kernel.org, djeffery@redhat.com, 
	stuart.w.hayes@gmail.com, ptyadav@amazon.de, lennart@poettering.net, 
	brauner@kernel.org, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	saeedm@nvidia.com, ajayachandra@nvidia.com, parav@nvidia.com, 
	leonro@nvidia.com, witu@nvidia.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 62DADC0002
X-Stat-Signature: g9diipoqitoix5f6qxn85umuq7csehxr
X-Rspam-User: 
X-HE-Tag: 1756495139-38541
X-HE-Meta: U2FsdGVkX1/wRd7JcQgaAIiwlnLnNaILadEql+sfJ1M0u3YVRDSTfE6IK2XMcimzbg7EamrlTiXZx/ShBaXh75AIngKMth3djh84AVLvCBMyHuPTOLwfUxGZCUSpHPWbli1ieZEwP2SdYmvSUHp0v2uVjbZols0h+Sc6ae1Boc6gWt0zJZaEjvra9FMaoNWPu6pzCk3r2Ft8Zc8AbuJWgr41qhQj870lS21l8d4mv4EzEXYaJCgMBs6cS0UpsaF4dLVriEWF7iaes+2yiTctI2KcD6A6ydcnIlWn28+l4/dAAOY6kcd8kS5TzrXpeamLbfSrl60IkMJQkkF7Utyks9lCfRPePDUfWzmTpvN5kaOhciQT+rnAsYkC3a9yChQ3kcNsaHoh1dKp4y6F9MO62amYTdNk8D44U4+Ynn/9X7XCfR0MMEQLkdnHvo/u/88I6VEvLOz1cDthHWqqaEI6UzhGv8HCT0hXtc8ys/ubpTx0BSGo9dfm+Sk9nU2SUOOlHgCgWYhLi6XSOx4VfepB96eipVDfB5aJvY2evXCnZ5qPLVUq5IVTQz5fcyTR5IhNZOYL6jvvfZ30XG35fNihA12LRoKp7b8eC8t9qLV6Jx2nefJkPwu8dsQ7F933sp1JjtXL+m1imnEBZViaQBAmNt+PjbBuPgWUzTXybLbbJwuMceFkJHIKxU54NmXrrjzHXjOHAsiyqv9H8hP90f8oBW2kgNcJ6ul51z9JlzxdsSZTUG59zqA899pQleFPAOl/UsEKO1+6UA1GyvhRMzlgt1o3L/qwv1vSZ9L7QFZY4FOH3ahxGG8wWttejoW0Hy8ipdXbp7+Nf2z99GcFDOcxxGW8ZV9KeG6Kf5kyczzzlBBcRapr9j6EhkHOMr1opojsDcDYnGYaszO8BFc6Wo07IpKH9R4VKKfY8dvDeUBwNeH6iREJXALrugIMmd7DgkB++EZUTJwfXUToKOGQ304
 NP75H9yi
 RxDxMIIE8+sFMREkLAvsHPa2cGSRU1L8dniD77XQteKoYJbUwn9d5/fsl7oCNGchbO1/NZPz7UhH/XldTrAtoynq1IvGJ9926zKJnGapRn6E7yQ2dDI0LuTtY3eyU2elfECZU84gjU0Ffu4PWyM171EENywhBcczk3bwrdg25mJTNmT6qkeSeJteN9Zg/drfpxzTUrBTbMoy/27INPjtlMCPW3qyh1Ixm1gLN3p56j3VKlPkdL2oXt4wOdt7+mI+jD9utiZ+YpA4t145ho68LswqIejiuX0J9218wpKR4R3GjfooYISdpp0EymkfpgHH+mXXQUKAA1q+4+pn223/iO7SPtOzr6WsVV5bJ0XA6mnhC2NK3aPmZ1jFDTQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 26, 2025 at 9:20=E2=80=AFAM Jason Gunthorpe <jgg@nvidia.com> wr=
ote:
>
> On Thu, Aug 07, 2025 at 01:44:35AM +0000, Pasha Tatashin wrote:
>
> > +     /*
> > +      * Most of the space should be taken by preserved folios. So take=
 its
> > +      * size, plus a page for other properties.
> > +      */
> > +     fdt =3D memfd_luo_create_fdt(PAGE_ALIGN(preserved_size) + PAGE_SI=
ZE);
> > +     if (!fdt) {
> > +             err =3D -ENOMEM;
> > +             goto err_unpin;
> > +     }
>
> This doesn't seem to have any versioning scheme, it really should..
>
> > +     err =3D fdt_property_placeholder(fdt, "folios", preserved_size,
> > +                                    (void **)&preserved_folios);
> > +     if (err) {
> > +             pr_err("Failed to reserve folios property in FDT: %s\n",
> > +                    fdt_strerror(err));
> > +             err =3D -ENOMEM;
> > +             goto err_free_fdt;
> > +     }
>
> Yuk.
>
> This really wants some luo helper
>
> 'luo alloc array'
> 'luo restore array'
> 'luo free array'

Yes, that will be one step forward.

Another idea is that having a middle layer manages the life cycle of
the reserved memory for you. Kind of like a slab allocator for the
preserved memory. It allows bulk free if there is an error on the live
update prepare(), you need to free all previously allocated memory
anyway. If there is some preserved memory that needs to stay after a
long term after the live update kernel boot up, use some special flags
to indicate so don't mix the free_all pool.
>
> Which would get a linearized list of pages in the vmap to hold the
> array and then allocate some structure to record the page list and
> return back the u64 of the phys_addr of the top of the structure to
> store in whatever.
>
> Getting fdt to allocate the array inside the fds is just not going to
> work for anything of size.
>
> > +     for (; i < nr_pfolios; i++) {
> > +             const struct memfd_luo_preserved_folio *pfolio =3D &pfoli=
os[i];
> > +             phys_addr_t phys;
> > +             u64 index;
> > +             int flags;
> > +
> > +             if (!pfolio->foliodesc)
> > +                     continue;
> > +
> > +             phys =3D PFN_PHYS(PRESERVED_FOLIO_PFN(pfolio->foliodesc))=
;
> > +             folio =3D kho_restore_folio(phys);
> > +             if (!folio) {
> > +                     pr_err("Unable to restore folio at physical addre=
ss: %llx\n",
> > +                            phys);
> > +                     goto put_file;
> > +             }
> > +             index =3D pfolio->index;
> > +             flags =3D PRESERVED_FOLIO_FLAGS(pfolio->foliodesc);
> > +
> > +             /* Set up the folio for insertion. */
> > +             /*
> > +              * TODO: Should find a way to unify this and
> > +              * shmem_alloc_and_add_folio().
> > +              */
> > +             __folio_set_locked(folio);
> > +             __folio_set_swapbacked(folio);
> >
> > +             ret =3D mem_cgroup_charge(folio, NULL, mapping_gfp_mask(m=
apping));
> > +             if (ret) {
> > +                     pr_err("shmem: failed to charge folio index %d: %=
d\n",
> > +                            i, ret);
> > +                     goto unlock_folio;
> > +             }
>
> [..]
>
> > +             folio_add_lru(folio);
> > +             folio_unlock(folio);
> > +             folio_put(folio);
> > +     }
>
> Probably some consolidation will be needed to make this less
> duplicated..
>
> But overall I think just using the memfd_luo_preserved_folio as the
> serialization is entirely file, I don't think this needs anything more
> complicated.
>
> What it does need is an alternative to the FDT with versioning.
>
> Which seems to me to be entirely fine as:
>
>  struct memfd_luo_v0 {
>     __aligned_u64 size;
>     __aligned_u64 pos;
>     __aligned_u64 folios;
>  };
>
>  struct memfd_luo_v0 memfd_luo_v0 =3D {.size =3D size, pos =3D file->f_po=
s, folios =3D folios};
>  luo_store_object(&memfd_luo_v0, sizeof(memfd_luo_v0), <.. identifier for=
 this fd..>, /*version=3D*/0);
>
> Which also shows the actual data needing to be serialized comes from
> more than one struct and has to be marshaled in code, somehow, to a
> single struct.
>
> Then I imagine a fairly simple forwards/backwards story. If something
> new is needed that is non-optional, lets say you compress the folios
> list to optimize holes:
>
>  struct memfd_luo_v1 {
>     __aligned_u64 size;
>     __aligned_u64 pos;
>     __aligned_u64 folios_list_with_holes;
>  };
>
> Obviously a v0 kernel cannot parse this, but in this case a v1 aware
> kernel could optionally duplicate and write out the v0 format as well:
>
>  luo_store_object(&memfd_luo_v0, sizeof(memfd_luo_v0), <.. identifier for=
 this fd..>, /*version=3D*/0);
>  luo_store_object(&memfd_luo_v1, sizeof(memfd_luo_v1), <.. identifier for=
 this fd..>, /*version=3D*/1);

Question: Do we have a matching FDT node to match the memfd C
structure hierarchy? Otherwise all the C struct will lump into one FDT
node. Maybe one FDT node for all C struct is fine. Then there is a
risk of overflowing the 4K buffer limit on the FDT node.

I would like to get independent of FDT for the versioning.

FDT on the top level sounds OK. Not ideal but workable. We are getting
deeper and deeper into complex internal data structures. Do we still
want every data structure referenced by a FDT identifier?

> Then the rule is fairly simple, when the sucessor kernel goes to
> deserialize it asks luo for the versions it supports:
>
>  if (luo_restore_object(&memfd_luo_v1, sizeof(memfd_luo_v1), <.. identifi=
er for this fd..>, /*version=3D*/1))
>     restore_v1(&memfd_luo_v1)
>  else if (luo_restore_object(&memfd_luo_v0, sizeof(memfd_luo_v0), <.. ide=
ntifier for this fd..>, /*version=3D*/0))
>     restore_v0(&memfd_luo_v0)
>  else
>     luo_failure("Do not understand this");
>
> luo core just manages this list of versioned data per serialized
> object. There is only one version per object.

Obviously, this can be done.

Is that approach you want to expand to every other C struct as well?
See the above FDT node complexity.

I am getting the feeling that we are hand crafting screws to build an
airplane. Can it be done? Of course. Does it scale well? I am not
sure. There are many developers who are currently hand-crafting this
kind of screws to be used on the different components of the airplane.

We need a machine that can stamp out screws with our specifications,
faster. I want such a machine. Other developers might want one as
well.

The initial discussion of the idea of such a machine is pretty
discouraged. There are huge communication barriers because of the
fixation on hand crafted screws. I understand exploring such machine
ideas alone might distract the engineer from hand crafting more
screws, one of them might realize that, oh, I want such a machine as
well.

At this stage, do you see that exploring such a machine idea can be
beneficial or harmful to the project? If such an idea is considered
harmful, we should stop discussing such an idea at all. Go back to
building more batches of hand crafted screws, which are waiting by the
next critical component.

Also if such a machine can produce screws up to your specification,
but it has a different look and feel than the hand crafted screws. We
can stamp out the screw faster.  Would you consider putting such a
machined screw on your most critical component of the engine?

Best Regards,

Chris

