Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F2201F3027F
	for <linux-mm@archiver.kernel.org>; Sun, 15 Mar 2026 23:07:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 090CA6B00E8; Sun, 15 Mar 2026 19:07:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0149B6B00E9; Sun, 15 Mar 2026 19:07:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E0EB56B00EA; Sun, 15 Mar 2026 19:07:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C95236B00E8
	for <linux-mm@kvack.org>; Sun, 15 Mar 2026 19:07:03 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 760821D69B
	for <linux-mm@kvack.org>; Sun, 15 Mar 2026 23:07:03 +0000 (UTC)
X-FDA: 84549834726.02.8F8E994
Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	by imf20.hostedemail.com (Postfix) with ESMTP id 772741C0004
	for <linux-mm@kvack.org>; Sun, 15 Mar 2026 23:07:01 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=KZzzEl54;
	spf=pass (imf20.hostedemail.com: domain of surenb@google.com designates 209.85.160.181 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773616021;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Hh22nL2hmMEFUrxwvQFcCzGFSdbPAraMrEXF5oyKKdU=;
	b=Vc7bj5dLzYi/VawVgmfD01U9qWx8pQltYiALfqf6yhQRqzVjPzhOGLLqB5tfgCvhTm3DWI
	WehSAEYG/TlhpdVCviVtAxJ/y6m2gnk8Bizp1CzVtdrlS/ieQlPccQMehSrxh0jwkPhYn/
	6iGZ0AsU+G0nf6F8v14Kz8Pn2HGweGI=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=KZzzEl54;
	spf=pass (imf20.hostedemail.com: domain of surenb@google.com designates 209.85.160.181 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773616021; a=rsa-sha256;
	cv=pass;
	b=hCvlo1CIG9NMrXK9tDyYKWsT/3h9qVprwcLtF3fPNoEYoRWhpxJzbqhwyGdtRUL1tyyWfq
	NZ4xuXXFXxu7al5Eq7yH7mIN5VacVWYzBMKFRlJ8CfeN4rZF1HDhMYYEwIHyHzD/HzoozV
	wzfmf0Igh+ovcM5g7LrVh/QyNzkmfhA=
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-509069a7a7fso756891cf.0
        for <linux-mm@kvack.org>; Sun, 15 Mar 2026 16:07:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773616020; cv=none;
        d=google.com; s=arc-20240605;
        b=CCh5Y4bsXCYozXPEPTAkB+azrrV3H7nIM735FGaHPV3JoEdbwk9wam2Xp5iAe7rVW9
         mauyyN5tMZTSP1V5+TtTxYlOm01vRKfmBEkbyXNG2jhjb08zYrtZ0PI7CxxRdPPsEUpx
         bXTD45wADmxJBC7zI5/70N2X0Gl4V2zf6ZrGKFllxhjlnXTmqBPHljKq2gn/EAP+Zt5N
         Iup/NmeOhKJnOolAiQe3SZ3dI4/ev09rOGAUZGDYdVNNhurUZnbXVsbaN3VLfsxEB3Cc
         fzABWZpz+QIx6f6+QdZC0MiM24m3Aa6JdrtDJbWn4LSiZeTXbrGkx1d+2wcM+RJIbFR9
         FsTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Hh22nL2hmMEFUrxwvQFcCzGFSdbPAraMrEXF5oyKKdU=;
        fh=IGD+d4ahtXEfpHPDG4W6VmCS9DphF9UM5VjkdiJBs4Y=;
        b=E3AoV4VCFOKjrK86o9iTw1KD2aFLgwE1tYnF0h6/6TO1NjBmQAN9GROi4XFqNRqkTa
         /yKS278OXVUhT43p1NN513eaDVE7CQksfBXlAxwwWw9wXFNWPE/wNAI6brqs6YfEbOdz
         UkL6FTUrMklKZAiuQVCQokEnbJHaQwY+VuBR6o1XJL9/s3jLx++KnGaQJnlm5hqutG5a
         7W9O9Ei1ICWfxj9U9qkBcdNylWgkYHl5hL3LJLiOj/OXu2Oz7bJbfIsNMBaVw9FRwkVj
         rO/DE7N9JeK51Qg0AM6oA+zMjdpzAo8xwE7hdELRRP4z/A4BYofXtucbWRyRihv2BExA
         ytkA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1773616020; x=1774220820; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Hh22nL2hmMEFUrxwvQFcCzGFSdbPAraMrEXF5oyKKdU=;
        b=KZzzEl54FaIIsNN7w1FmA/4scnVqgJyQNPOEWpun3NjKDuz+m5wiwIdGxj8fcPrYp4
         sm/MGCIF1+sHZplt8D5zkXXe1yCnSwYvADKabLBe1kINTvgZFKPop45+hT6dLqPTJfDn
         tVRCm+7fch8mGEvwsDM95BGk1GzEZRYy4WbXL3Wdsrrh9H+JQr5HePz3TuFRpItxJY2O
         ZlW1KI0RfEkD5qdEKYCAbjws8TnWdPBvxP9LKVvE5Xp/5S0qoP5T+wat/2cA8/NcPK15
         SmKfW+ptvGBDEebhjYH62C8fQQ7xLO4xi3HNcGytTQKnOcbG/+C1p5sqg3DY7k4zpOqd
         jQIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773616020; x=1774220820;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Hh22nL2hmMEFUrxwvQFcCzGFSdbPAraMrEXF5oyKKdU=;
        b=sLHjJxtsta1hSGK4QLr/5zZf0042KOutP4DQ/aOR49JlU2iDuOGdYLU7VhUrW0EPVH
         5agx7rfgE+5sPyknRvxmlRmutH3zq3zbiWth/rj85YqPxiTnEPPbOG+dJhnwU2+obZvY
         4ww7ry0FiBoElRIpX11PpnTnw0WFK5mtL6MbneljfSTPC6vjahNPi099jaRno1/rAppq
         fZjrdWl3DjQMnyWW+PG1S7Q9LAoGWo7R30FprwnkElxt6s3sUdqUd1fKXRil9JBiDddl
         1g97VwOdwRkYUeBys5B07wJEiSSFxoizYv1eVuoep7O/fgxLoHo2H2x7tpyESmOibQHo
         CH1A==
X-Forwarded-Encrypted: i=1; AJvYcCWm5eEqGJQXpTtPVKJM+zCdhAVv0EhitfcYn+IYJ9XfV26UvyjZSb1KNRHfhQvzp5z9JINbL+JEdQ==@kvack.org
X-Gm-Message-State: AOJu0YyXBX17wZyo0u0QT5paDskPo1gdoZdkQXUf+nqBFwe0+8GQVSxo
	xhIvtJrPblk60M5+SVLiz0KH87ATHCYq/qYOKR4ISX8TvDBr6hvAzLm8rax+yJ3DazJMdDl7ckh
	KT/WB0sqyj+Z9MsVqGCZA2yoiv5i6Yq2TACmEATWc
X-Gm-Gg: ATEYQzz1b7f+ieJmRX4RL+DgSkVZn7I8/NBMwP9vMSqDErvIQZcXTFjM1ATHlu9xASi
	FKQYbcjKLp3oYCRdyixyr+4GHnb8cOM87VKVszaemKMh92kWefI9Dd+TJLN/D3KEsC15vZomlrS
	TMEVkc1WQeQuajigkLuErQqkfspsNhhHnnmTc+dibyg/7lWieSo+l2bpf7p7U3zw5hnx0CLkQi5
	N6/f4AE6HRPi+n9Bih9XzQjVyWb/kk74qR7/4NSYXb4S9dBvPNtQ96c6ZzvFvPhqcSVLKggTPs1
	xRx19g==
X-Received: by 2002:a05:622a:120b:b0:509:1471:1bc2 with SMTP id
 d75a77b69052e-5096aa498a9mr17201381cf.17.1773616019620; Sun, 15 Mar 2026
 16:06:59 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1773346620.git.ljs@kernel.org> <56372fe273f775b26675a04652c1229e14680741.1773346620.git.ljs@kernel.org>
 <CAJuCfpEsCrFEYNkkTfRLGojGOYAAx1=WOojOhpBb_=WZBr6bnQ@mail.gmail.com>
In-Reply-To: <CAJuCfpEsCrFEYNkkTfRLGojGOYAAx1=WOojOhpBb_=WZBr6bnQ@mail.gmail.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Sun, 15 Mar 2026 16:06:48 -0700
X-Gm-Features: AaiRm528N1qqT5kapRSRN59l9MR0Mu1tnA4LnOTUgRsLLsulGwtoq5YjHKPeuow
Message-ID: <CAJuCfpHcjFU1r7ixiJM4b_a5HTesxBmW6DiCreaWpJ8DLM5haQ@mail.gmail.com>
Subject: Re: [PATCH 01/15] mm: various small mmap_prepare cleanups
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jonathan Corbet <corbet@lwn.net>, 
	Clemens Ladisch <clemens@ladisch.de>, Arnd Bergmann <arnd@arndb.de>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "K . Y . Srinivasan" <kys@microsoft.com>, 
	Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>, 
	Dexuan Cui <decui@microsoft.com>, Long Li <longli@microsoft.com>, 
	Alexander Shishkin <alexander.shishkin@linux.intel.com>, 
	Maxime Coquelin <mcoquelin.stm32@gmail.com>, Alexandre Torgue <alexandre.torgue@foss.st.com>, 
	Miquel Raynal <miquel.raynal@bootlin.com>, Richard Weinberger <richard@nod.at>, 
	Vignesh Raghavendra <vigneshr@ti.com>, Bodo Stroesser <bostroesser@gmail.com>, 
	"Martin K . Petersen" <martin.petersen@oracle.com>, David Howells <dhowells@redhat.com>, 
	Marc Dionne <marc.dionne@auristor.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, David Hildenbrand <david@kernel.org>, 
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, 
	Pedro Falcato <pfalcato@suse.de>, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-hyperv@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com, 
	linux-arm-kernel@lists.infradead.org, linux-mtd@lists.infradead.org, 
	linux-staging@lists.linux.dev, linux-scsi@vger.kernel.org, 
	target-devel@vger.kernel.org, linux-afs@lists.infradead.org, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	Ryan Roberts <ryan.roberts@arm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: hihfopcx9irpczy5gc7pwf6y8ei6mxy9
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 772741C0004
X-HE-Tag: 1773616021-697088
X-HE-Meta: U2FsdGVkX18TXFy0PWaz7Ir9Qeexn3rljCoE2HS6PPmEbDa6/fLMznzVjctSV4yOZ5NmuGOCg8mgR9lfqvxavyti+Qu9BdfaQjVvjpw3k0X9JZbhFFM2v2KyvvZE8b9DiAfl33pCUeoXnREltsxKzVILdmqMJMNfizPSW/WoCHG47Nyv5d7nmG9aMKM3eo+H7tpoVl3frmF4iAOfcNEvX/JS4Wq9CXZ4w/BRw1Sh59hIqsKKjallMIzExc/f1NTX1kcJ8ueQMEZ50yPXyfWK2unN0n6+6R38LChJ9uau++ra0fpNDW9vdiovL9d5ECLg32X+2f7xinjgd3EF/m0aHgYmgcSWbe1LTiomvAd5n/qQgAEe5ElpxQVoEPGjy6o3CGufQOFcKbcNcV83wx1lxQQ6D+UnmWbbLR4C9Hnfk2Awjyaz45FjtB9idTLgKXHACFShvR7ZifEzymwMiNaW2JP7Iwj4rkrOWACzp+z80RqHUmbW7RjwvjtTnlC+BQx7vwQLPlAIlXe4JYMHb00tW9UwI8ajud7zNtJ6mJ5C7eSfzXgP8N1qKu/7REGGA0AskfsWsgDaGe0U8cSBhO4vmrxuZwQ2CQiXuDsAwjBotht7JEIwySq4Nc75FjVnh5UM+bwPGghKzVf4l3Pad8s2ULrbLgtFSJwuA4olhzmH1D1q0ZCkJhbW2XidSOVsrqZ0/PRniAHnm5XCnt9VoH+avbVExxWg84LnRdVL5WsPts5UR1+yIyclX9qDHbba9T9QfWVUa0yO9jq0JCbLZTjdQnCrGi4ZyXGB46FKLW7PlYd/c/C5L6mpfpEPjr8uZGV9wo80qfG55TVWr0j4mk9At+w+ScF8d1rlYMA3p8PJRFc3hRrhHht36t2ddo44vxJ4ToQshFWiud4E1gps0J8cUwziNqKdLQSeU30st4Y0trkFc6fIXoeFsmW5iVEd9XhU9zLD70PPb0Zfm9U1ZFW
 H9TH8+XT
 vQfjM1yRzGwERaAA+y4k3YyPTaYHI2Isj5/NB6xhqPgd7YYRM0CjToAF7GsXpRFNkbeEMj8yi/ckX9ht9ZQboPg4Gq/6+WizwlAzkfsPLkj1Wc9hUGF2nDl1qP3HcXIRK+xdfYgWRMxFv9Hw5ZkAjmujiiHNNoCCkbPD92kZiOib77MuWDfjwm7kEngQc9WfFdN6uyDAJUQppyOU4vmR6m1lz4YT5MrCpmQwNwFhsskheLD5n7LiobprQfaSyiEI9e8X9BI/vrOW24V/Sb2LSv8hv84jNBOoLzFO9c/GZtMcdpgqfGdzV1Yau5hmVVhOOAU+VgG9I7+pz7rOZzlC3sJe6tGQCtwyKtzw1nAFEyWqoAidI3j8V3coSOiZB2/InMovgaU2SIqGj9uBA09w2uS6FYx9Ju4Og4uO4wISPHkPmSI0FJMHlPufSOA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Mar 15, 2026 at 3:56=E2=80=AFPM Suren Baghdasaryan <surenb@google.c=
om> wrote:
>
> On Thu, Mar 12, 2026 at 1:27=E2=80=AFPM Lorenzo Stoakes (Oracle) <ljs@ker=
nel.org> wrote:
> >
> > Rather than passing arbitrary fields, pass an mmap_action field directl=
y to
> > mmap prepare and complete helpers to put all the action-specific logic =
in
> > the function actually doing the work.
> >
> > Additionally, allow mmap prepare functions to return an error so we can
> > error out as soon as possible if there is something logically incorrect=
 in
> > the input.
> >
> > Update remap_pfn_range_prepare() to properly check the input range for =
the
> > CoW case.
>
> By "properly check" do you mean the replacement of desc->start and
> desc->end with action->remap.start and action->remap.start +
> action->remap.size when calling get_remap_pgoff() from
> remap_pfn_range_prepare()?
>
> >
> > While we're here, make remap_pfn_range_prepare_vma() a little neater, a=
nd
> > pass mmap_action directly to call_action_complete().
> >
> > Then, update compat_vma_mmap() to perform its logic directly, as
> > __compat_vma_map() is not used by anything so we don't need to export i=
t.
>
> Not directly related to this patch but while reviewing, I was also
> checking vma locking rules in this mmap_prepare() + mmap() sequence
> and I noticed that the new VMA flag modification functions like
> vma_set_flags_mask() do assert vma_assert_locked(vma). It would be
> useful to add these but as a separate change. I will add it to my todo
> list.
>
> >
> > Also update compat_vma_mmap() to use vfs_mmap_prepare() rather than cal=
ling
> > the mmap_prepare op directly.
> >
> > Finally, update the VMA userland tests to reflect the changes.
> >
> > Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
> > ---
> >  include/linux/fs.h                |   2 -
> >  include/linux/mm.h                |   8 +--
> >  mm/internal.h                     |  28 +++++---
> >  mm/memory.c                       |  45 +++++++-----
> >  mm/util.c                         | 112 +++++++++++++-----------------
> >  mm/vma.c                          |  21 +++---
> >  tools/testing/vma/include/dup.h   |   9 ++-
> >  tools/testing/vma/include/stubs.h |   9 +--
> >  8 files changed, 123 insertions(+), 111 deletions(-)
> >
> > diff --git a/include/linux/fs.h b/include/linux/fs.h
> > index 8b3dd145b25e..a2628a12bd2b 100644
> > --- a/include/linux/fs.h
> > +++ b/include/linux/fs.h
> > @@ -2058,8 +2058,6 @@ static inline bool can_mmap_file(struct file *fil=
e)
> >         return true;
> >  }
> >
> > -int __compat_vma_mmap(const struct file_operations *f_op,
> > -               struct file *file, struct vm_area_struct *vma);
> >  int compat_vma_mmap(struct file *file, struct vm_area_struct *vma);
> >
> >  static inline int vfs_mmap(struct file *file, struct vm_area_struct *v=
ma)
> > diff --git a/include/linux/mm.h b/include/linux/mm.h
> > index 4c4fd55fc823..cc5960a84382 100644
> > --- a/include/linux/mm.h
> > +++ b/include/linux/mm.h
> > @@ -4116,10 +4116,10 @@ static inline void mmap_action_ioremap_full(str=
uct vm_area_desc *desc,
> >         mmap_action_ioremap(desc, desc->start, start_pfn, vma_desc_size=
(desc));
> >  }
> >
> > -void mmap_action_prepare(struct mmap_action *action,
> > -                        struct vm_area_desc *desc);
> > -int mmap_action_complete(struct mmap_action *action,
> > -                        struct vm_area_struct *vma);
> > +int mmap_action_prepare(struct vm_area_desc *desc,
> > +                       struct mmap_action *action);
> > +int mmap_action_complete(struct vm_area_struct *vma,
> > +                        struct mmap_action *action);
> >
> >  /* Look up the first VMA which exactly match the interval vm_start ...=
 vm_end */
> >  static inline struct vm_area_struct *find_exact_vma(struct mm_struct *=
mm,
> > diff --git a/mm/internal.h b/mm/internal.h
> > index 95b583e7e4f7..7bfa85b5e78b 100644
> > --- a/mm/internal.h
> > +++ b/mm/internal.h
> > @@ -1775,26 +1775,32 @@ int walk_page_range_debug(struct mm_struct *mm,=
 unsigned long start,
> >  void dup_mm_exe_file(struct mm_struct *mm, struct mm_struct *oldmm);
> >  int dup_mmap(struct mm_struct *mm, struct mm_struct *oldmm);
> >
> > -void remap_pfn_range_prepare(struct vm_area_desc *desc, unsigned long =
pfn);
> > -int remap_pfn_range_complete(struct vm_area_struct *vma, unsigned long=
 addr,
> > -               unsigned long pfn, unsigned long size, pgprot_t pgprot)=
;
> > +int remap_pfn_range_prepare(struct vm_area_desc *desc,
> > +                           struct mmap_action *action);
> > +int remap_pfn_range_complete(struct vm_area_struct *vma,
> > +                            struct mmap_action *action);
> >
> > -static inline void io_remap_pfn_range_prepare(struct vm_area_desc *des=
c,
> > -               unsigned long orig_pfn, unsigned long size)
> > +static inline int io_remap_pfn_range_prepare(struct vm_area_desc *desc=
,
> > +                                            struct mmap_action *action=
)
> >  {
> > +       const unsigned long orig_pfn =3D action->remap.start_pfn;
> > +       const unsigned long size =3D action->remap.size;
> >         const unsigned long pfn =3D io_remap_pfn_range_pfn(orig_pfn, si=
ze);
> >
> > -       return remap_pfn_range_prepare(desc, pfn);
> > +       action->remap.start_pfn =3D pfn;
> > +       return remap_pfn_range_prepare(desc, action);
> >  }
> >
> >  static inline int io_remap_pfn_range_complete(struct vm_area_struct *v=
ma,
> > -               unsigned long addr, unsigned long orig_pfn, unsigned lo=
ng size,
> > -               pgprot_t orig_prot)
> > +                                             struct mmap_action *actio=
n)
> >  {
> > -       const unsigned long pfn =3D io_remap_pfn_range_pfn(orig_pfn, si=
ze);
> > -       const pgprot_t prot =3D pgprot_decrypted(orig_prot);
> > +       const unsigned long size =3D action->remap.size;
> > +       const unsigned long orig_pfn =3D action->remap.start_pfn;
> > +       const pgprot_t orig_prot =3D vma->vm_page_prot;
> >
> > -       return remap_pfn_range_complete(vma, addr, pfn, size, prot);
> > +       action->remap.pgprot =3D pgprot_decrypted(orig_prot);

I'm guessing it doesn't really matter but after this change
action->remap.pgprot will store the decrypted value while before this
change it was kept the way mmap_prepare() originally set it. We pass
the action structure later to mmap_action_finish() but it does not use
action->remap.pgprot, so this probably doesn't matter.

> > +       action->remap.start_pfn  =3D io_remap_pfn_range_pfn(orig_pfn, s=
ize);
> > +       return remap_pfn_range_complete(vma, action);
> >  }
> >
> >  #ifdef CONFIG_MMU_NOTIFIER
> > diff --git a/mm/memory.c b/mm/memory.c
> > index 6aa0ea4af1fc..364fa8a45360 100644
> > --- a/mm/memory.c
> > +++ b/mm/memory.c
> > @@ -3099,26 +3099,34 @@ static int do_remap_pfn_range(struct vm_area_st=
ruct *vma, unsigned long addr,
> >  }
> >  #endif
> >
> > -void remap_pfn_range_prepare(struct vm_area_desc *desc, unsigned long =
pfn)
> > +int remap_pfn_range_prepare(struct vm_area_desc *desc,
> > +                           struct mmap_action *action)
> >  {
> > -       /*
> > -        * We set addr=3DVMA start, end=3DVMA end here, so this won't f=
ail, but we
> > -        * check it again on complete and will fail there if specified =
addr is
> > -        * invalid.
> > -        */
> > -       get_remap_pgoff(vma_desc_is_cow_mapping(desc), desc->start, des=
c->end,
> > -                       desc->start, desc->end, pfn, &desc->pgoff);
> > +       const unsigned long start =3D action->remap.start;
> > +       const unsigned long end =3D start + action->remap.size;
> > +       const unsigned long pfn =3D action->remap.start_pfn;
> > +       const bool is_cow =3D vma_desc_is_cow_mapping(desc);
>
> I was trying to figure out who sets action->remap.start and
> action->remap.size and if they somehow guaranteed to be always equal
> to desc->start and (desc->end - desc->start). My understanding is that
> action->remap.start and action->remap.size are set by
> f_op->mmap_prepare() but I'm not sure if they are always the same as
> desc->start and (desc->end - desc->start) and if so, how do we enforce
> that.
>
> > +       int err;
> > +
> > +       err =3D get_remap_pgoff(is_cow, start, end, desc->start, desc->=
end, pfn,
> > +                             &desc->pgoff);
> > +       if (err)
> > +               return err;
> > +
> >         vma_desc_set_flags_mask(desc, VMA_REMAP_FLAGS);
> > +       return 0;
> >  }
> >
> > -static int remap_pfn_range_prepare_vma(struct vm_area_struct *vma, uns=
igned long addr,
> > -               unsigned long pfn, unsigned long size)
> > +static int remap_pfn_range_prepare_vma(struct vm_area_struct *vma,
> > +                                      unsigned long addr, unsigned lon=
g pfn,
> > +                                      unsigned long size)
> >  {
> > -       unsigned long end =3D addr + PAGE_ALIGN(size);
> > +       const unsigned long end =3D addr + PAGE_ALIGN(size);
> > +       const bool is_cow =3D is_cow_mapping(vma->vm_flags);
> >         int err;
> >
> > -       err =3D get_remap_pgoff(is_cow_mapping(vma->vm_flags), addr, en=
d,
> > -                             vma->vm_start, vma->vm_end, pfn, &vma->vm=
_pgoff);
> > +       err =3D get_remap_pgoff(is_cow, addr, end, vma->vm_start, vma->=
vm_end,
> > +                             pfn, &vma->vm_pgoff);
> >         if (err)
> >                 return err;
> >
> > @@ -3151,10 +3159,15 @@ int remap_pfn_range(struct vm_area_struct *vma,=
 unsigned long addr,
> >  }
> >  EXPORT_SYMBOL(remap_pfn_range);
> >
> > -int remap_pfn_range_complete(struct vm_area_struct *vma, unsigned long=
 addr,
> > -               unsigned long pfn, unsigned long size, pgprot_t prot)
> > +int remap_pfn_range_complete(struct vm_area_struct *vma,
> > +                            struct mmap_action *action)
> >  {
> > -       return do_remap_pfn_range(vma, addr, pfn, size, prot);
> > +       const unsigned long start =3D action->remap.start;
> > +       const unsigned long pfn =3D action->remap.start_pfn;
> > +       const unsigned long size =3D action->remap.size;
> > +       const pgprot_t prot =3D action->remap.pgprot;
> > +
> > +       return do_remap_pfn_range(vma, start, pfn, size, prot);
> >  }
> >
> >  /**
> > diff --git a/mm/util.c b/mm/util.c
> > index ce7ae80047cf..dba1191725b6 100644
> > --- a/mm/util.c
> > +++ b/mm/util.c
> > @@ -1163,43 +1163,6 @@ void flush_dcache_folio(struct folio *folio)
> >  EXPORT_SYMBOL(flush_dcache_folio);
> >  #endif
> >
> > -/**
> > - * __compat_vma_mmap() - See description for compat_vma_mmap()
> > - * for details. This is the same operation, only with a specific file =
operations
> > - * struct which may or may not be the same as vma->vm_file->f_op.
> > - * @f_op: The file operations whose .mmap_prepare() hook is specified.
> > - * @file: The file which backs or will back the mapping.
> > - * @vma: The VMA to apply the .mmap_prepare() hook to.
> > - * Returns: 0 on success or error.
> > - */
> > -int __compat_vma_mmap(const struct file_operations *f_op,
> > -               struct file *file, struct vm_area_struct *vma)
> > -{
> > -       struct vm_area_desc desc =3D {
> > -               .mm =3D vma->vm_mm,
> > -               .file =3D file,
> > -               .start =3D vma->vm_start,
> > -               .end =3D vma->vm_end,
> > -
> > -               .pgoff =3D vma->vm_pgoff,
> > -               .vm_file =3D vma->vm_file,
> > -               .vma_flags =3D vma->flags,
> > -               .page_prot =3D vma->vm_page_prot,
> > -
> > -               .action.type =3D MMAP_NOTHING, /* Default */
> > -       };
> > -       int err;
> > -
> > -       err =3D f_op->mmap_prepare(&desc);
> > -       if (err)
> > -               return err;
> > -
> > -       mmap_action_prepare(&desc.action, &desc);
> > -       set_vma_from_desc(vma, &desc);
> > -       return mmap_action_complete(&desc.action, vma);
> > -}
> > -EXPORT_SYMBOL(__compat_vma_mmap);
> > -
> >  /**
> >   * compat_vma_mmap() - Apply the file's .mmap_prepare() hook to an
> >   * existing VMA and execute any requested actions.
> > @@ -1228,7 +1191,31 @@ EXPORT_SYMBOL(__compat_vma_mmap);
> >   */
> >  int compat_vma_mmap(struct file *file, struct vm_area_struct *vma)
> >  {
> > -       return __compat_vma_mmap(file->f_op, file, vma);
> > +       struct vm_area_desc desc =3D {
> > +               .mm =3D vma->vm_mm,
> > +               .file =3D file,
> > +               .start =3D vma->vm_start,
> > +               .end =3D vma->vm_end,
> > +
> > +               .pgoff =3D vma->vm_pgoff,
> > +               .vm_file =3D vma->vm_file,
> > +               .vma_flags =3D vma->flags,
> > +               .page_prot =3D vma->vm_page_prot,
> > +
> > +               .action.type =3D MMAP_NOTHING, /* Default */
> > +       };
> > +       int err;
> > +
> > +       err =3D vfs_mmap_prepare(file, &desc);
> > +       if (err)
> > +               return err;
> > +
> > +       err =3D mmap_action_prepare(&desc, &desc.action);
> > +       if (err)
> > +               return err;
> > +
> > +       set_vma_from_desc(vma, &desc);
> > +       return mmap_action_complete(vma, &desc.action);
> >  }
> >  EXPORT_SYMBOL(compat_vma_mmap);
> >
> > @@ -1320,8 +1307,8 @@ void snapshot_page(struct page_snapshot *ps, cons=
t struct page *page)
> >         }
> >  }
> >
> > -static int mmap_action_finish(struct mmap_action *action,
> > -               const struct vm_area_struct *vma, int err)
> > +static int mmap_action_finish(struct vm_area_struct *vma,
> > +                             struct mmap_action *action, int err)
> >  {
> >         /*
> >          * If an error occurs, unmap the VMA altogether and return an e=
rror. We
> > @@ -1355,35 +1342,36 @@ static int mmap_action_finish(struct mmap_actio=
n *action,
> >   * action which need to be performed.
> >   * @desc: The VMA descriptor to prepare for @action.
> >   * @action: The action to perform.
> > + *
> > + * Returns: 0 on success, otherwise error.
> >   */
> > -void mmap_action_prepare(struct mmap_action *action,
> > -                        struct vm_area_desc *desc)
> > +int mmap_action_prepare(struct vm_area_desc *desc,
> > +                       struct mmap_action *action)
>
> Any reason you are swapping the arguments?
> It also looks like we always call mmap_action_prepare() with action =3D=
=3D
> desc->action, like this: mmap_action_prepare(&desc.action, &desc). Why
> don't we eliminate the action parameter altogether and use desc.action
> from inside the function?
>
> > +
>
> extra new line.
>
> >  {
> >         switch (action->type) {
> >         case MMAP_NOTHING:
> > -               break;
> > +               return 0;
> >         case MMAP_REMAP_PFN:
> > -               remap_pfn_range_prepare(desc, action->remap.start_pfn);
> > -               break;
> > +               return remap_pfn_range_prepare(desc, action);
> >         case MMAP_IO_REMAP_PFN:
> > -               io_remap_pfn_range_prepare(desc, action->remap.start_pf=
n,
> > -                                          action->remap.size);
> > -               break;
> > +               return io_remap_pfn_range_prepare(desc, action);
> >         }
> >  }
> >  EXPORT_SYMBOL(mmap_action_prepare);
> >
> >  /**
> >   * mmap_action_complete - Execute VMA descriptor action.
> > - * @action: The action to perform.
> >   * @vma: The VMA to perform the action upon.
> > + * @action: The action to perform.
> >   *
> >   * Similar to mmap_action_prepare().
> >   *
> >   * Return: 0 on success, or error, at which point the VMA will be unma=
pped.
> >   */
> > -int mmap_action_complete(struct mmap_action *action,
> > -                        struct vm_area_struct *vma)
> > +int mmap_action_complete(struct vm_area_struct *vma,
> > +                        struct mmap_action *action)
> > +
> >  {
> >         int err =3D 0;
> >
> > @@ -1391,23 +1379,19 @@ int mmap_action_complete(struct mmap_action *ac=
tion,
> >         case MMAP_NOTHING:
> >                 break;
> >         case MMAP_REMAP_PFN:
> > -               err =3D remap_pfn_range_complete(vma, action->remap.sta=
rt,
> > -                               action->remap.start_pfn, action->remap.=
size,
> > -                               action->remap.pgprot);
> > +               err =3D remap_pfn_range_complete(vma, action);
> >                 break;
> >         case MMAP_IO_REMAP_PFN:
> > -               err =3D io_remap_pfn_range_complete(vma, action->remap.=
start,
> > -                               action->remap.start_pfn, action->remap.=
size,
> > -                               action->remap.pgprot);
> > +               err =3D io_remap_pfn_range_complete(vma, action);
> >                 break;
> >         }
> >
> > -       return mmap_action_finish(action, vma, err);
> > +       return mmap_action_finish(vma, action, err);
> >  }
> >  EXPORT_SYMBOL(mmap_action_complete);
> >  #else
> > -void mmap_action_prepare(struct mmap_action *action,
> > -                       struct vm_area_desc *desc)
> > +int mmap_action_prepare(struct vm_area_desc *desc,
> > +                       struct mmap_action *action)
> >  {
> >         switch (action->type) {
> >         case MMAP_NOTHING:
> > @@ -1417,11 +1401,13 @@ void mmap_action_prepare(struct mmap_action *ac=
tion,
> >                 WARN_ON_ONCE(1); /* nommu cannot handle these. */
> >                 break;
> >         }
> > +
> > +       return 0;
> >  }
> >  EXPORT_SYMBOL(mmap_action_prepare);
> >
> > -int mmap_action_complete(struct mmap_action *action,
> > -                       struct vm_area_struct *vma)
> > +int mmap_action_complete(struct vm_area_struct *vma,
> > +                        struct mmap_action *action)
> >  {
> >         int err =3D 0;
> >
> > @@ -1436,7 +1422,7 @@ int mmap_action_complete(struct mmap_action *acti=
on,
> >                 break;
> >         }
> >
> > -       return mmap_action_finish(action, vma, err);
> > +       return mmap_action_finish(vma, action, err);
> >  }
> >  EXPORT_SYMBOL(mmap_action_complete);
> >  #endif
> > diff --git a/mm/vma.c b/mm/vma.c
> > index be64f781a3aa..054cf1d262fb 100644
> > --- a/mm/vma.c
> > +++ b/mm/vma.c
> > @@ -2613,15 +2613,19 @@ static void __mmap_complete(struct mmap_state *=
map, struct vm_area_struct *vma)
> >         vma_set_page_prot(vma);
> >  }
> >
> > -static void call_action_prepare(struct mmap_state *map,
> > -                               struct vm_area_desc *desc)
> > +static int call_action_prepare(struct mmap_state *map,
> > +                              struct vm_area_desc *desc)
> >  {
> >         struct mmap_action *action =3D &desc->action;
> > +       int err;
> >
> > -       mmap_action_prepare(action, desc);
> > +       err =3D mmap_action_prepare(desc, action);
> > +       if (err)
> > +               return err;
> >
> >         if (action->hide_from_rmap_until_complete)
> >                 map->hold_file_rmap_lock =3D true;
> > +       return 0;
> >  }
> >
> >  /*
> > @@ -2645,7 +2649,9 @@ static int call_mmap_prepare(struct mmap_state *m=
ap,
> >         if (err)
> >                 return err;
> >
> > -       call_action_prepare(map, desc);
> > +       err =3D call_action_prepare(map, desc);
> > +       if (err)
> > +               return err;
> >
> >         /* Update fields permitted to be changed. */
> >         map->pgoff =3D desc->pgoff;
> > @@ -2700,13 +2706,12 @@ static bool can_set_ksm_flags_early(struct mmap=
_state *map)
> >  }
> >
> >  static int call_action_complete(struct mmap_state *map,
> > -                               struct vm_area_desc *desc,
> > +                               struct mmap_action *action,
> >                                 struct vm_area_struct *vma)
> >  {
> > -       struct mmap_action *action =3D &desc->action;
> >         int ret;
> >
> > -       ret =3D mmap_action_complete(action, vma);
> > +       ret =3D mmap_action_complete(vma, action);
> >
> >         /* If we held the file rmap we need to release it. */
> >         if (map->hold_file_rmap_lock) {
> > @@ -2768,7 +2773,7 @@ static unsigned long __mmap_region(struct file *f=
ile, unsigned long addr,
> >         __mmap_complete(&map, vma);
> >
> >         if (have_mmap_prepare && allocated_new) {
> > -               error =3D call_action_complete(&map, &desc, vma);
> > +               error =3D call_action_complete(&map, &desc.action, vma)=
;
> >
> >                 if (error)
> >                         return error;
> > diff --git a/tools/testing/vma/include/dup.h b/tools/testing/vma/includ=
e/dup.h
> > index 5eb313beb43d..908beb263307 100644
> > --- a/tools/testing/vma/include/dup.h
> > +++ b/tools/testing/vma/include/dup.h
> > @@ -1106,7 +1106,7 @@ static inline int __compat_vma_mmap(const struct =
file_operations *f_op,
> >
> >                 .pgoff =3D vma->vm_pgoff,
> >                 .vm_file =3D vma->vm_file,
> > -               .vm_flags =3D vma->vm_flags,
> > +               .vma_flags =3D vma->flags,
> >                 .page_prot =3D vma->vm_page_prot,
> >
> >                 .action.type =3D MMAP_NOTHING, /* Default */
> > @@ -1117,9 +1117,12 @@ static inline int __compat_vma_mmap(const struct=
 file_operations *f_op,
> >         if (err)
> >                 return err;
> >
> > -       mmap_action_prepare(&desc.action, &desc);
> > +       err =3D mmap_action_prepare(&desc, &desc.action);
> > +       if (err)
> > +               return err;
> > +
> >         set_vma_from_desc(vma, &desc);
> > -       return mmap_action_complete(&desc.action, vma);
> > +       return mmap_action_complete(vma, &desc.action);
> >  }
> >
> >  static inline int compat_vma_mmap(struct file *file,
> > diff --git a/tools/testing/vma/include/stubs.h b/tools/testing/vma/incl=
ude/stubs.h
> > index 947a3a0c2566..76c4b668bc62 100644
> > --- a/tools/testing/vma/include/stubs.h
> > +++ b/tools/testing/vma/include/stubs.h
> > @@ -81,13 +81,14 @@ static inline void free_anon_vma_name(struct vm_are=
a_struct *vma)
> >  {
> >  }
> >
> > -static inline void mmap_action_prepare(struct mmap_action *action,
> > -                                          struct vm_area_desc *desc)
> > +static inline int mmap_action_prepare(struct vm_area_desc *desc,
> > +                                     struct mmap_action *action)
> >  {
> > +       return 0;
> >  }
> >
> > -static inline int mmap_action_complete(struct mmap_action *action,
> > -                                          struct vm_area_struct *vma)
> > +static inline int mmap_action_complete(struct vm_area_struct *vma,
> > +                                      struct mmap_action *action)
> >  {
> >         return 0;
> >  }
> > --
> > 2.53.0
> >

