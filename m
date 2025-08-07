Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7EE51C87FCA
	for <linux-mm@archiver.kernel.org>; Thu,  7 Aug 2025 18:24:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0A5276B0093; Thu,  7 Aug 2025 14:24:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 07BEC6B00A3; Thu,  7 Aug 2025 14:24:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EAE0A6B00A6; Thu,  7 Aug 2025 14:24:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DAE9C6B0093
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 14:24:25 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 86ADA140A4A
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 18:24:25 +0000 (UTC)
X-FDA: 83750786490.11.9CE5E3B
Received: from mail-io1-f51.google.com (mail-io1-f51.google.com [209.85.166.51])
	by imf01.hostedemail.com (Postfix) with ESMTP id B494E4000A
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 18:24:23 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=lSacQuRH;
	spf=pass (imf01.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.166.51 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754591063;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zNuzWmTNPffaFCHaXEeQ0GR/T7nQZcXvwlguy7B/4dM=;
	b=oT016xCvV9RYnvdTsNzmLuwDmv/Hi3b3nOmo0CgP/c9cwXcyyn19e6JbOH9ElGLaF+G/pK
	KOR7PnxljJrreCxv5K8RE8iO93G/JjgNlLQx22WsiPO2jn/tKddvs3ToE3/8KZqarR3y+O
	XnsoVBD2CkMtfx4OchWZxPBZpcDOE+8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754591063; a=rsa-sha256;
	cv=none;
	b=69mYBDYgTtnNoEUgrRrqZELI74JdZb+fbzF0yKg+06SvfeRqfhTqV97RD5knU26EMg0XAr
	3hAaEDWmybEkGozrlkkCsYkFYW+BDhnYG3YUAhWrEZC5+BJDxtzOZ4aRZGuDdVmRPcm1bI
	AlLKZ4PJN9zqselajhTZ+wFIiIKOdxE=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=lSacQuRH;
	spf=pass (imf01.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.166.51 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-io1-f51.google.com with SMTP id ca18e2360f4ac-875acfc133dso41280439f.1
        for <linux-mm@kvack.org>; Thu, 07 Aug 2025 11:24:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754591063; x=1755195863; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zNuzWmTNPffaFCHaXEeQ0GR/T7nQZcXvwlguy7B/4dM=;
        b=lSacQuRHl2AtL3bIOOLtSv8w4P8OJ6+cOQC8HmKFm9WnrTI1yQ/UfUVUty4kzBFx2e
         OcZmWxD5FiNZ1eOquybVAkiBK2MSa6sIlQXhdxNePAZT+swy1YOTvIUyS50tieP8L62U
         PXkgiC/9DNQ+fSHJnytQ42QO5qt4wQTiMnmrwp7su3suarjiq5uoo0oprEBiUZvidmpM
         WMBoPqqkYiMH1B+KS/51hGNWH+o50fh/vSTKeF2Zica3Lhx1q0K0aQXuE05AJOmcOB9r
         uv+wvOepv3YsL0AOjUNMrGjYSn1kP28g9RoSxeEPRxTjvS6xfLggle/yuIMlWRBGYJ/i
         dFgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754591063; x=1755195863;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zNuzWmTNPffaFCHaXEeQ0GR/T7nQZcXvwlguy7B/4dM=;
        b=bErozYqYBoxhMuymJMZbFq3PqW6RsudgU0UIG+tvxma4/lU5PzIDcqJjviYzwF6yzJ
         oqqmIMSeILTlhyqLsfCq79C8f5yFyXl+jwBWUnCJ0rtD/wNOlg4q2York5uMvD7c83Qf
         3vPT1XgYi8rOllmTVzIpyVIHZpqELpkJNutXf3gikxpT/Yt45YE/Xnb6zdeU3yRCNWfP
         YdgpnwxQnERAWrTkZ4E4v7d0HABs1hbkiCnoLNLR+Sx8Q5qXArnu5KuzpUUY/tBzcGoL
         gdL1ThJvC1ZsWhEwZqZnLxelFTNr4iEt5BzU4C9hZlXwqRhuPt7vY6xLx1p2jc6UB5al
         uUIA==
X-Gm-Message-State: AOJu0YyXSRxrFvraLrGGnbl+82/SsPpH0RnvC/OKffwDQAM5TvhoNIcA
	utCEE11XGlDolFjDPIGVbjKLGNlsXX9iP0hggkQicJDFHU+/pjmSsP6L8AxEaDyhi7LsKn5WPvM
	7OhBskV8G3/ghhsx0ZGTjaY7MyseiSpg=
X-Gm-Gg: ASbGncs6gewe5/SBqMpH2u4hWepKWmB/hU/JEwiqJStY8nwawQAQ1wCh2q6GGxs1ww5
	CPOmVXWsAgNPw5J2U/cfcDA3SPIaBcwXVSouu9xzcP2JjnmX8cEvmcMN9Vao9sORREYZnerSLPj
	4JVa6vDBY/SnYe1uGcBleEErrJr7cL/gWcBzZr8MtwbO+hJ2vTZVXMyjUsSzR0MY0uMmsWdiDj6
	2hV5tnbTq2085mNLA==
X-Google-Smtp-Source: AGHT+IHDtBVpeNVW47eT+EtH0KXWBMHn8A3N/MioH4ziUa6CKaP1TmvVbhFwJqCtq97d1u9GWnhfVRaRyjGhmkj4DYA=
X-Received: by 2002:a05:6e02:178f:b0:3e3:fe52:e576 with SMTP id
 e9e14a558f8ab-3e5330d9169mr2324415ab.9.1754591062511; Thu, 07 Aug 2025
 11:24:22 -0700 (PDT)
MIME-Version: 1.0
References: <20250807152720.62032-1-ryncsn@gmail.com> <20250807152720.62032-2-ryncsn@gmail.com>
 <CAKEwX=P8Qh4mOdv68UfXv-YBSnuZJkhEeuRJezZucbX7sysWvg@mail.gmail.com>
In-Reply-To: <CAKEwX=P8Qh4mOdv68UfXv-YBSnuZJkhEeuRJezZucbX7sysWvg@mail.gmail.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Fri, 8 Aug 2025 02:23:43 +0800
X-Gm-Features: Ac12FXwPvhPQJSzfZunKBjvVg2gy2SZePr5hJx--Wv6DiFAlNkDn_0ZycFRYpjs
Message-ID: <CAMgjq7CRdX3vpphUboHruO3wxRhph6SsPmBXnjtHuc4nzRczsQ@mail.gmail.com>
Subject: Re: [RFC PATCH 1/3] mm/mincore, swap: consolidate swap cache checking
 for mincore
To: Nhat Pham <nphamcs@gmail.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	Matthew Wilcox <willy@infradead.org>, Hugh Dickins <hughd@google.com>, 
	David Hildenbrand <david@redhat.com>, Chris Li <chrisl@kernel.org>, Barry Song <baohua@kernel.org>, 
	Baoquan He <bhe@redhat.com>, Kemeng Shi <shikemeng@huaweicloud.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: B494E4000A
X-Stat-Signature: 6oh9twbbgtriysnggp65i4pm1mtukhc3
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1754591063-449335
X-HE-Meta: U2FsdGVkX1+x0BnPDn2tN2xwlOFu82DPFYdjT3+xBv3hPdWCS0shxW3m6ZxuWY9Sb/oFFvE7iWOL1PZ21E96rmpizdQGOTZjytGap9C2U4TPOeCmyN2cfObIkNbrAdiklQZ5VthNngH81ewSTpF2hIGNLtBkFW2E9jQVP+fXJuYippjRV3SZysIsFD/vtCRgHGVLUsrzIrifKZnZ/3tcKS9qhWoaJimtM3CdAFIvyBG2mGbjy3nqHdNJWewNyEl503k7oIFhaQMIPFvmym5v8mfDetUjl1/9O4Kr8uCvLY6y6sE5S7Wh+/Nrv/uTUp6S54JCpWR9FyWJFBfOZgDMOdQ/38UmYFgRpSRJjvp/H93mNymYv+DvYPVfl7pvPoLy7kjdUIi6eveAVEi/jjcIVPBqflIar3uUmvVqL3nwq4CXSrcp3oewihODRzY7UeKMa2UJkrMG9OynW7vANHWjj2sQ16ElTceXngTQqO32RCYa1YYZcb3ZhOZCpshNn8ZxwLifa9aMZoBWmwy2Jk07fbWXNj+oiC3CVz3XPzTSZ6YZRu7dBQNJgxANhTlQH1Es92YSS1s2eCTnUz4cWckZDHdQBbD1yS01A657TkRCBYcFIoDOP8NJ9qycSHIT9vIP60YdRJTmQ4agFZJ+ll266mGMJ734IprsNNIY5AOT0o4CYEbOY27Y8E/zVw4S+A9GHIfh6V8jHFwXUa50JiTlDxQ3q5YkmeFzCJshsIqzUV3A2zspDbfu261QVfbLbBMVvoue7oxA5djGp8VDxIs1Zmi7D/GXF+pPr7r3LgIeCunPWYeeqRlm+kgGo94cjrB2m0/fFJdk1DVfb8yFx4kbJtWf/harXnI7iQ/O58Q2Cyf3gB20n0qN9ijOskb2hpczNVIbkCXed47rtyYYJ9lPQYU/z0O/V0U9cwGpR+p8UiBgYG2/Cj6lK0AQ747YtCiqfsFyOG6qO0t/9ZRGLYj
 I5r4REQH
 A5GGwGNmCpzJxvCD9kNffgMn1p3GK5tFWOg28NPW1gt5U2tF3qEhdXZF6JgsK4uW7kqamU9/QIeBqKRJOsujKDNxqnHnghwbvEfmkFbv4pJ2uy4yXRFQ8T6KHoVD42+pp2X71LrcACy6I6sMBfWdR5IMkRmSMjUe52NhQUbrMpfgNNrkAJNMzidCuhBHgnWwRS1+kcVDe8ykTfaClh28jsm+dzr3YdEZz+KmjDLi/+6Kq9/C36EY/ftXbM628NiZVvLxeO/SYGdApDiCHxZjzExTLFrlcpNvAHR1tuonWZ4UKrRgQi7ot/cA4wRpK9yJyd2PqKaHJ+VVXPU1aPBTyqsxa/brdB5vgc0y+76aiiQS55eYaXF3v5a4rt8Z4lxD64u6b7ut80y7zPWSGI0Nx0czVGQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 8, 2025 at 2:07=E2=80=AFAM Nhat Pham <nphamcs@gmail.com> wrote:
>
> On Thu, Aug 7, 2025 at 8:27=E2=80=AFAM Kairui Song <ryncsn@gmail.com> wro=
te:
> >
> > From: Kairui Song <kasong@tencent.com>
> >
> > The filemap_get_incore_folio (previously find_get_incore_page) helper
> > was introduced by commit 61ef18655704 ("mm: factor find_get_incore_page
> > out of mincore_page") to be used by later commit f5df8635c5a3 ("mm: use
> > find_get_incore_page in memcontrol"), so memory cgroup charge move code
> > can be simplified.
> >
> > But commit 6b611388b626 ("memcg-v1: remove charge move code") removed
> > that user completely, it's only used by mincore now.
> >
> > So this commit basically reverts commit 61ef18655704 ("mm: factor
> > find_get_incore_page out of mincore_page"). Move it back to mincore sid=
e
> > to simplify the code.
> >
> > Signed-off-by: Kairui Song <kasong@tencent.com>
>
> Seems reasonable to me for the most part - just a couple of questions bel=
ow.
>
> > ---
> >  mm/mincore.c    | 29 +++++++++++++++++++++++++++--
> >  mm/swap.h       | 10 ----------
> >  mm/swap_state.c | 38 --------------------------------------
> >  3 files changed, 27 insertions(+), 50 deletions(-)
> >
> > diff --git a/mm/mincore.c b/mm/mincore.c
> > index 10dabefc3acc..f0d3c9419e58 100644
> > --- a/mm/mincore.c
> > +++ b/mm/mincore.c
> > @@ -64,8 +64,33 @@ static unsigned char mincore_page(struct address_spa=
ce *mapping, pgoff_t index)
> >          * any other file mapping (ie. marked !present and faulted in w=
ith
> >          * tmpfs's .fault). So swapped out tmpfs mappings are tested he=
re.
> >          */
> > -       folio =3D filemap_get_incore_folio(mapping, index);
> > -       if (!IS_ERR(folio)) {
> > +       if (IS_ENABLED(CONFIG_SWAP) && shmem_mapping(mapping)) {
>
> Do we need CONFIG_SWAP check here? I suppose if !CONFIG_SWAP we'll
> never end up with an ordinary swap entry stored here right?

Yes, and in the next patch I'd like to introduce a WARN_ON if we see
swap entries with !CONFIG_SWAP. That means the memory is corrupted.

>
> Saves a couple of cycles, I suppose. No strong opinions.

Before 61ef18655704 it used a `#ifdef CONFIG_SWAP`, I used
IS_ENABLED(CONFIG_SWAP) here, same thing, the compiler will optimize
out the unused branch. Just with fewer lines of code and I personally
think this looks prettier.

>
> > +               folio =3D filemap_get_entry(mapping, index);
> > +               /*
> > +                * shmem/tmpfs may return swap: account for swapcache
> > +                * page too.
> > +                */
> > +               if (xa_is_value(folio)) {
> > +                       struct swap_info_struct *si;
> > +                       swp_entry_t swp =3D radix_to_swp_entry(folio);
> > +                       /* There might be swapin error entries in shmem=
 mapping. */
> > +                       if (non_swap_entry(swp))
> > +                               return 0;
> > +                       /* Prevent swap device to being swapoff under u=
s */
> > +                       si =3D get_swap_device(swp);
> > +                       if (si) {
> > +                               folio =3D filemap_get_folio(swap_addres=
s_space(swp),
> > +                                                         swap_cache_in=
dex(swp));
> > +                               put_swap_device(si);
> > +                       } else {
> > +                               return 0;
> > +                       }
> > +               }
> > +       } else {
> > +               folio =3D filemap_get_folio(mapping, index);
> > +       }
> > +
> > +       if (folio) {
>
> Should this check be "if (!IS_ERR(folio))"? Seems like that's how we
> inspect the output of filemap_get_folio() in other locations (for e.g,
> in filemap_fault()).

Yeah you are right, actuall should be IS_ERR_OR_NULL here as it uses
both filemap_get_entry and filemap_get_folio.
I wanted to change to always use filemap_get_entry in the next patch
for better performance, but somehow forgot it...
Will fix it.

>
> >                 present =3D folio_test_uptodate(folio);
> >                 folio_put(folio);
> >         }
>

