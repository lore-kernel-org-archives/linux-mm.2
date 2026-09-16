Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E4B7EC982C1
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 16:32:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D24956B0092; Wed, 16 Sep 2026 12:32:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD4086B0093; Wed, 16 Sep 2026 12:32:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC3766B0095; Wed, 16 Sep 2026 12:32:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 88FDC6B0092
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 12:32:14 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D7FB21407E2
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 16:32:13 +0000 (UTC)
X-FDA: 85220167746.25.1D81188
Received: from mail-qk2-f12.google.com (mail-qk2-f12.google.com [74.125.230.204])
	by imf10.hostedemail.com (Postfix) with ESMTP id E001DC000C
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 16:32:11 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=G1BdhG4o;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf10.hostedemail.com: domain of surenb@google.com designates 74.125.230.204 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789576331;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tUDhjbftqgjAL9HivD9mk/nQ9a+7BLYF9Ygx6CAW0uc=;
	b=qruuv9uBjCq7t/o8kqc7TyLh9+09L929eBQqr4qaC5F1tHyRdy34FfL6ojdtB37/x7k3PQ
	2u5rzT6V2edWpikhQQAIwpd++Yftb2h3/kw9GnvmsvIZbeCfAD2Il8BswYbYgUSeJC2Jll
	A507sV7zphmOiU1Zs2LypYwVihlELRA=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789576331;
	b=Ps+NqnnwfVk33A6wex7s5WjQEO7ERqKqleHEM59Dkw8vsXg7Fo0ICjuccUdZBp+Mttyxr8
	bP7QUTmZDHA2kYyLEz7nYfzt6uLfF70cGeJiBEXNID1rpQ5pDeeAF+sMZxjLOqeVgPdqew
	G+yqTwBD1m61HB2WXo/anfA7lDlOLiM=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=G1BdhG4o;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf10.hostedemail.com: domain of surenb@google.com designates 74.125.230.204 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-qk2-f12.google.com with SMTP id d75a77b69052e-5306706e89dso323881cf.1
        for <linux-mm@kvack.org>; Wed, 16 Sep 2026 09:32:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789576331; cv=none;
        d=google.com; s=arc-20260327;
        b=eKe0mBIk/kZgFG8/zNWCYZ2m6lPgJpOZGuIO7AqXElTCdX3M84XdPfqBfe+xbiwq3P
         Ojyq/iE/qcKnVoeP/P+S1bZTDEd7xIiwMojd0NLRsawrHZ/aGfb/elXit6WNGFbDso+c
         ukrcd4nEPQEOzQ9lZ5Ztr4vEX8YRXVdqVc403+kOQYVSUx7C+t0pFzBuKUHhWDQKGiOR
         m3QLUlwP+t+2P0sVSM2lEUCaxtTo3/W+boB9lJT6FswjFVqKmnemW8xEyh5hdoZhK6ms
         Z4fwrBreDKLtNxLvAdxCX7///tzN8jbyJ28UZqgCi29JLQbiak+D7g4awT8K/d6Cutn1
         cBmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=tUDhjbftqgjAL9HivD9mk/nQ9a+7BLYF9Ygx6CAW0uc=;
        fh=qPt4kHMKVE0DdKwtNajBzqaBhkhMUPTE3gLqiCLiE+M=;
        b=eWq41WEBi+WLENJ30i8c21iuXWuvOqdEXFrfTgTLxPkKswpRIVnEaoQpw8Zvj/bdBu
         c6ThPy0Z+drUviIIq1XnLE9T9HGBNGCSykpIR7/zcsh/SKOLBKmPeS00qMMlnv124/iO
         zd5klSXBFE2SRCcpmqJ67z78HSc3FO5yjQ//o5RU98VrQyLg8mBIFWynKS1JyHx/hiVi
         Q3hzRYPfTe19TmwyhZqPH/7xmTSFwRgtdi1k/BpOiw2OLzcnfG5FLWcNrRHEBRyZ27rP
         n1BGYZtqa3be/UGj1+iAZatEKFypetbTzPBPo2Xn2P3++bmTE2IesvrGyh2DPhK6XJJ5
         g29w==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789576331; x=1790181131; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=tUDhjbftqgjAL9HivD9mk/nQ9a+7BLYF9Ygx6CAW0uc=;
        b=G1BdhG4otT8X4Y63pbgbnrRKLSyt18dta0blCOpuxHo3iiXE1A9E8doz05unC2IHpY
         Dkui+7ABSDgr4jldUXjPrVxgoDfnHYmYdJPhd96vqa+30RvU+HZQT6NJrmUw+jdHTmJ3
         qiX5E5NB967IQb8ykoZHclN8Ym2417UIBHyxrjbbjTnNdKsuyRfLP/hgA+Yhn6pG9+wU
         jd+pxUHFu0F8bG38+c3sdqiXFX5u8ZcnUmS6GCLOgAdrnI6Ro8VVI/63pckQ+ufG1vWZ
         5qzsbCKwgOoB43SRjn/6vPthQhteaCVgChlDzDJn/7Ww2B+ZSV97T7jy25pRJw21PTmG
         ui+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789576331; x=1790181131;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=tUDhjbftqgjAL9HivD9mk/nQ9a+7BLYF9Ygx6CAW0uc=;
        b=cR85B2VRoFCc+3DS2nJJYOrH+RyGWb4Fzvpk56b7HECKwPHgraDo92VOKmo/BcM20D
         jKSAdxmYoSrTxUv0sXJnx5Y4+LrvqzWJCL6Bs0ZxyKg7dxk/HjDc0RUlfP7erqPbHxOW
         UvxCNN85kaZRbo9KBQgWoLpAwnDuB9Fs7hv3ytjMOL6AQC8cGjU7hl5q3BpN4AFUsNLZ
         lVKQ9Tm6fkPMuhYveExwd2f4FEg6V/nosIOaeVvjCEK0JXFnttsWkbD5JYN6LCXzGJxQ
         voIr5Z6/YPZOO6uii1V7sVNyVpm3csJ4pWzHK1YWehVAc8icCPZ2GLntnpBbVQ6oafh/
         so6Q==
X-Forwarded-Encrypted: i=1; AKwUvBwm2i8P/QulITp0ZraIG5pk1s3xsDYaDwkv9VWVl42ka9C6P8N6yt9dBwGLeUlFKaq9ZnVKQzCySA==@kvack.org
X-Gm-Message-State: AFuF++kNx9ZrqsffBQKhqNdjtjUJth7f7LblWgKp3mCpCvzqIJVWd8JA
	8QkwQ3hM+zt90whtv8j3Hoac7NVd6AJ01Za9bicJIDbmNULIJVLAg7WMsdORmx6FZJcrQz3feD6
	H5Kp7joL17QkPd0qWas/gGTvjHbF4QCN9X3Obac4g
X-Gm-Gg: AYBFou35oFbgl6cq7fm2Ny5XKkFvkVQhfjdpAq9BZ9JScFF/ossHSo73wMvL8uQCzx1
	e6qAnWIs0lrlgvVltyY5EoMuia9CWLdVPuTzDVk4ppXsRRy7+j4qOvTRoGTNI5+4dxsglmItWIs
	cuDb94NE0tFfVy/zI4Br4xEnCErToyY/EdwrzHooSdyCTt7OMBZfn9eVeW38daILIla/gvNsgHY
	fC2R8BRGadl+2N9SSlP/u0TYQmz/5wDnREmZ0ftWzd1Ez3SwIkaC9p9Tsavw9OB3mm/9/pmCZM7
	xbvcncTyRXPfmEMY3jDoOaemepwvMYHXbyujYc4MPfySZ2XidliImPX3AShqUiaMxuvKxzNvSN0
	P66Qa+gQuqA==
X-Received: by 2002:ac8:594d:0:b0:530:e00f:7768 with SMTP id
 d75a77b69052e-5327eb6f730mr14653271cf.0.1789576329678; Wed, 16 Sep 2026
 09:32:09 -0700 (PDT)
MIME-Version: 1.0
References: <20260915070001.113559-1-hao.ge@linux.dev> <20260915070001.113559-3-hao.ge@linux.dev>
 <CAJuCfpHJSwNhgotMVpmjVvdv=m52_7Kvzpztf0WcN0AaoSeGGw@mail.gmail.com> <60642a7f-2949-428a-8290-40d69c989a77@linux.dev>
In-Reply-To: <60642a7f-2949-428a-8290-40d69c989a77@linux.dev>
From: Suren Baghdasaryan <surenb@google.com>
Date: Wed, 16 Sep 2026 09:31:57 -0700
X-Gm-Features: AcwNN1Ui51wqsB_O4pl6c8tWHX6Ce9XwML9-1bQ7rL4qQiN8F18j46JxhZ3BkmQ
Message-ID: <CAJuCfpG3d7n=z5WnUQYZsqvrt1pemF8TFvGiGyZGLO7ykVvqAQ@mail.gmail.com>
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
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: E001DC000C
X-Stat-Signature: 1k8s569x61otkh89ump4ytge4e8g89ny
X-HE-Tag: 1789576331-11554
X-HE-Meta: U2FsdGVkX1888ZuGaqwxscdqPW5PudVyqfQzDhNBIAHLKdWqcN5TtJNKic7syenslUwMf+CxBDmkAhQwj0309CX7ODMlT4ICeMMYHpYhk+xKqftIOZhp9i3Wz8Be060zn8N/yBfXhyA6f3/LtUC43VRLhe7ouHW3FLdEINZ6lgmi9z7UJAVjYzjCvFmC+4Fy+HFQK6GpP9uU5LZ9VRRGXbz8AM5LcTrLoo55i6js+bcSVbOBnwpAjwyjYF9aDkpeyyEp5vMxbFDQ6U9eEy9JiG5N85Ysb76kqKFn1/xqvc/i3AJzuOoBtqIT6F2rrNeS0fHQAPgzYYhxIqb1atyGaIJ4K2jTlKTX0b35aKXwxuRNMZZLfqQ1gDNZt42nBBSWKI6EjO3OVq6bv/QwSXuAR3Wju38TuGXDYULcSBXBJIL6qCq+/qSo9Zl++aHCRgqq4cPgOKZPav9bH7cQV5yXqFmaMLgIozotjudRkH03VEd8uD2VXkrtDphWzgpPV746chSwS/lTcrM6bjbCWDBHEcogJXE1r+oPAfQpmSERPgILsTlfIlCXYZh3Slu/yVYUKJWUJsTX+t4OJvkRCm7ERo96y6k6E5TIQ8ijmrUtwezzs2ah9p/nmRpREo/BFtVkYeeea1GGJ0re8/+qqNYyXZD4rd9wfEul1xnhII8rgMtETef9qFY9dbmNAi5rcArB6ibQeS583og1Q0vu8BucwC4RQokck7oJ21ADwCjbHWz63aJV9ctAhWgyBf6aX3jyLgmVEA5AyXQ6QosRCbWlZwCwzoKuc/EV6I5WFqynE+JcFxdtxkxXYwacI/qjVQHYXvuYsBudv3gM1OXROb3N/KwggDQIpNyYiqbn/ogg4D5LXAtY29DNTUZ7lkYTTCi8dY0jtHzyI66KOvy8c2yh+sA2JKMiLdEClJTebE9OzhD5T1r45P+YEQYoPJdJg8VpRFO11ir51rX4AaXo4PM
 +zVpK7hZ
 niVrUB/oNnO1LokSWPKhSrzhoH3waopF9k5K84QMFotyvT5xOlxOk3hAUFEOA7OYPZxqWdt3xals3qI3i4xfWjs8ptffCqKalCCUHKE5dgxeRt/WE2UyTz7wVAC5MD/32Hz/W5H9ZcT7mPz9uszsSw1HxO9YirCX+ihpiTA24erKc0Wi4MCZ2klze3zaXe0iKaaIjw4kPWZNiNftXkox/PIdPZXEkwo4bK7AVzEqTOpb2IFNoSaSy0UIUbCtXi+5C91JYpR1HtAopLIUiv4KRkmCaySOLxK8YfmYLGS5DmK1V8Hdl/jTcosoGI2XpLfU8hNuvV85DPNTICxVjuyAF3a01GLmsi+84wmhkddVOAeeGv3I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 15, 2026 at 11:00=E2=80=AFPM Hao Ge <hao.ge@linux.dev> wrote:
>
> Hi Suren
>
> Thanks for you review.
>
> On 2026/9/16 05:09, Suren Baghdasaryan wrote:
> > On Mon, Sep 14, 2026 at 11:59=E2=80=AFPM Hao Ge <hao.ge@linux.dev> wrot=
e:
> >>
> >> The reservation is already stored in the maple tree when
> >> vm_module_tags_populate() fails. A failed load never unloads the
> >> module, so nothing releases the entry. Release it and roll
> >> module_tags.size back. Without the rollback a concurrent load that
> >> already passed needs_section_mem() can reuse the freed gap, skip
> >> vm_module_tags_populate() and write to unmapped memory.
> >>
> >> vmap_pages_range() may have installed some PTEs before failing. A
> >> retry to populate the same range would BUG on them, so undo them,
> >> but only if vmap actually ran.
> >>
> >> Fixes: 4835f747d3ed ("alloc_tag: support for page allocation tag compr=
ession")
> >> Fixes: 0f9b685626da ("alloc_tag: populate memory for module tags as ne=
eded")
> >
> > If a patch fixes two other patches, it likely needs to be split so
> > that each part fixes one patch only. But read on please. I'm not sure
> > if one of the fixes is correct.
> >
>
> Kept them in one patch because they only make sense together.
>
> After a failed populate the reservation is released and the
> size rolled back, so the next load takes the same gap and calls
> vm_module_tags_populate() again, and that retry would trip over
> the PTEs the failed vmap left behind.
>
> Without the rollback a load that already passed needs_section_mem()
> just reuses the gap, skips populate and writes to unmapped memory.
> So splitting them leaves each half broken.

Yeah, that's why I think vmap_pages_range() cleanup should be a
completely separate patch with vmap_pages_range() doing cleanup
itself.

>
> >> Reported-by: Sashiko <sashiko-bot@kernel.org>
> >> Cc: stable@vger.kernel.org
> >> Signed-off-by: Hao Ge <hao.ge@linux.dev>
> >> ---
> >>  mm/alloc_tag.c | 10 ++++++++++
> >>  1 file changed, 10 insertions(+)
> >>
> >> diff --git a/mm/alloc_tag.c b/mm/alloc_tag.c
> >> index 2070e682fe10..95ddf5b743d0 100644
> >> --- a/mm/alloc_tag.c
> >> +++ b/mm/alloc_tag.c
> >> @@ -804,6 +804,13 @@ static int vm_module_tags_populate(void)
> >>                                      next_page, PAGE_SHIFT) < 0) {
> >>                         release_pages_arg arg =3D { .pages =3D next_pa=
ge };
> >>
> >> +                       /*
> >> +                        * vmap_pages_range() only runs once all pages=
 were
> >> +                        * allocated, and it may have installed some m=
appings
> >> +                        * before failing. Undo them.
> >
> > If vmap_pages_range() failed to map the range, why should we need to
> > undo it? If it indeed leaves some partial mapping when failing then I
> > would argue that vmap_pages_range() should be undoing these partial
> > mappings itself before returning the error.
> >
> Yeah it does - none of the paths under vmap_pages_range() undo themselves=
 on error.

Hmm. I wonder if this behavior is intentional or requires a fix. The
only possible reason I can think of is performance but I can't imagine
a failure to map is a performance-critical case.

+David Hildenbrand (Red Hat), +Lorenzo Stoakes (Oracle) what do you
guys think? Shouldn't vmap_pages_range() undo its possible partial
mapping when it fails?


> pcpu_map_pages does perform cleanup on its own as well. There may be othe=
r similar sites.
> https://elixir.bootlin.com/linux/v7.3-rc3/source/mm/percpu-vm.c#L255
> so I did the same here.
>
> If we really want vmap_pages_range() to handle this cleanup internally, I=
 believe that would
> be a relatively large change, and we would need to consider many more cas=
es. So I think we keep
> the current behaviour for now.

Yeah, I understand it would require a deeper cut but if that's the
right way to handle this we might as well do that. Let's see what MM
folks think.

>
> Thanks
> Best Regards
> Hao
>
> >> +                        */
> >> +                       if (nr =3D=3D more_pages)
> >> +                               vunmap_range(phys_end, phys_end + (nr =
<< PAGE_SHIFT));
> >>                         /* Clean up and error out */
> >>                         release_pages(arg, nr);
> >>                         return -ENOMEM;
> >> @@ -947,6 +954,7 @@ static void *reserve_module_tags(struct module *mo=
d, unsigned long size,
> >>                 return ret;
> >>
> >>         if (module_tags.size < offset + size) {
> >> +               unsigned long prev_size =3D module_tags.size;
> >>                 int grow_res;
> >>
> >>                 module_tags.size =3D offset + size;
> >> @@ -961,6 +969,8 @@ static void *reserve_module_tags(struct module *mo=
d, unsigned long size,
> >>                         shutdown_mem_profiling(true);
> >>                         pr_err("Failed to allocate memory for allocati=
on tags in the module %s. Memory allocation profiling is disabled!\n",
> >>                                mod->name);
> >> +                       release_module_tags(mod, false);
> >> +                       module_tags.size =3D prev_size;
> >
> > Yes, this one is a valid fix. It fixes 0f9b685626da commit.
> >
> >>                         return ERR_PTR(grow_res);
> >>                 }
> >>         }
> >> --
> >> 2.25.1
> >>

