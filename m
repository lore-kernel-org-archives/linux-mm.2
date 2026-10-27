Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E5FBC606A326
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 17:38:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=XkRWrYMi
Received: by kanga.kvack.org (Postfix)
	id E18286B086F; Tue, 27 Oct 2026 13:38:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DF0D46B0871; Tue, 27 Oct 2026 13:38:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB66C6B0872; Tue, 27 Oct 2026 13:38:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 995CE6B086F
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 13:38:42 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 317D81A0A9A
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 17:38:42 +0000 (UTC)
X-FDA: 85369116084.03.425E682
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	by imf02.hostedemail.com (Postfix) with ESMTP id 4560380004
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 17:38:40 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=XkRWrYMi;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf02.hostedemail.com: domain of surenb@google.com designates 209.85.208.47 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793122720;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AYi2YiR3kh+gzZk6CrM84tIidytqPHRNR76c45jsmXI=;
	b=5MGkIFkTLVK60TzX2JO9WkHnmS3vSVm0NJpmCd0+VDkXu+am4rgYQf0UBp9jAWBdxd9S49
	uVzN+R0+zS4mjZMdhTewsp4Pi9qngH8Dm2PFA3wrqunH1i3EJmYpBDswkan5VeOLBOjcJM
	Bqz48TYMdXqWVJwJqeEJIRYYsTw2PqU=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=XkRWrYMi;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf02.hostedemail.com: domain of surenb@google.com designates 209.85.208.47 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793122720;
	b=JCAMw1Q/uOkUh9ho8IUVTNacmWxcwq/Yq5t9gXp6aPltvpUYct/EnpqXg2EWPE6Cr9C7TL
	myaglIMOKYgualTc1gI3r23v6b2WMsxe/uUU+xdB9lpfbJ3pSAq6o/qmK14wg24MUSW20Z
	tyYIQTXe7TeD6ogQYA/yC2ZQ7Mwp9Vk=
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-6afac79b3a3so625a12.1
        for <linux-mm@kvack.org>; Tue, 27 Oct 2026 10:38:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793122719; cv=none;
        d=google.com; s=arc-20260327;
        b=VzXSNCoSOJdzUA6gaU32qzRKrK8QLtR4PsfjoWSWVQyMqh4vlsqLc37Z+x/WBg/iL9
         98Mkk1ykK8tuDCrhfprmTg3BFM5fjjQcPs8u6ew23wW8IP/WxCviYv9fgRyJK88HqQGp
         wCy+5XSmCiLh7NUIOeLMt89LAKKCTapixpIo9yeyyz7P0OB/noP/EQ8zRV/x9N61aCmX
         jpb/f4/2ayI6O8S6froYiw6it0wxRgfrLKxdxD8Z+4V17isCP/sf2uF2yviwJ1xvRB37
         XGHZAbwhRiJGP3M4XO47RuKjA6FJAE8e+jqIdvTv023C6ZKAjgmDmmzHGVhtDn/IkBWc
         F9Ew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=AYi2YiR3kh+gzZk6CrM84tIidytqPHRNR76c45jsmXI=;
        fh=Z19PUsK/xI6HeIw0qpBLxJpppNKtNSbT8K/udh3VF1U=;
        b=TYCJKe3tx4Cuoq2CTfKsUQL0pK3dBRb/D47la9C/0h55Q1qD5QVfsSoFgH3icxx2Nz
         yEoa0Kkx8yustuoA2zTpcaIau3MvEXWalpO797/xjB1TcJaEzy9LnPgN8pGa5zuLqfOL
         8qPlwDhC7aEpYq7ZNqu2JFFOPvhfXeKdBWO+A/CSeI7dKRxlCGF6uNS3dMBQmtyVqc63
         py7JT5+v7Fa3A8Ud8mhm16nfHTBAGzz6mhVudjGiKPocyN7ZXJvT4slHRCNuaTSVpgEv
         YpsZBWQcmPKwK+q2BDcwQ1wxdA13yljidw8VYAyuCXFERDO6P6IESJViMtJwDZHiHPpM
         /bMw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793122719; x=1793727519; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=AYi2YiR3kh+gzZk6CrM84tIidytqPHRNR76c45jsmXI=;
        b=XkRWrYMiKzgQoX2h2/ogZvSZ6y/MXHfZ72wrlRgHsBb8yZoFIWVw4P7pIxei+v4iLB
         27MwHf8DUJyV4udpbrZTHDFQ0gGbuPjaZDWWQsdtnr5VG60G0b4eGAkEESeVgLq/IVCf
         JcO8jQs/Dz9sNeTc0zFPg0ERrmg7F8tJRw3iwOz0YHqVh+CB/+FMkmQUDqUPPrVKymNa
         hE499D6OQHEOWWNy3GFUS2x3GST8knyfQJVZ7QtNP8SA67iBumHdeIxsYDkimKWOE5zf
         M/P8ReXJRG0hWPT+Kp1jKnW+UAyTwkboyTs6OBWWHLKG4acjzzKOQ9CsGbHsWAkCBoLF
         GXcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793122719; x=1793727519;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=AYi2YiR3kh+gzZk6CrM84tIidytqPHRNR76c45jsmXI=;
        b=qGwfNhA+e8Zsr8Bh3J1YO0kg/+Tl9ezMH5L8cymNqX+xxnIeBMtb+1wBUamHSEmvZL
         Wk0iSjlDAb7pJzh8Z8agZIoa1roFCUTBq9YXWRZ7sjiHD0SDpTXpDvax0MSAw8d0NXiz
         ThH3WErYj+6hrhgBMVFKRMTc/nzpTnYuFVoROV9Q+1m1pkIwyxRoqY0uy4npjt37o2cE
         wrCTpVZiJbzuvD+labhCrRl2ySdMcmdzxVebHBgEWIinyKn1xV9PurEmex0gm2CLTVqG
         piDLl3q5FK6UslSwvs+95z7jIRjCzj94T3O7fhHr1xcYuzKT5qDc37ZGvcysljAF9sRa
         wc7Q==
X-Forwarded-Encrypted: i=1; AKwUvBx7LYmDYkQzukbBdq91d30Vbn7N11t2GT4/tjW5SIaS9iyvMIE6HjZXeIFesoQ/zExNK5Oj4PLmMw==@kvack.org
X-Gm-Message-State: AFq9FYLehkPIggeogjaooxss74WJhAQDOPf1MB7h/HcBxcSVzwQb1VdN
	zNeNGFC+sxizBNr/OWD+CFO1X4GpoaHngU+N4WK1J4bRLgFuhVkRrJzWfEDb0xkQ16gX6b5oBe2
	i1ZemMi+R4kBuIOsH43uJkuNkiw8HASRZgr11dl/O
X-Gm-Gg: AYBFou3dnKKZL4ckadu3eE7q3BBP/BFVqbVtjyB3/iXxcB7A1NaNkdnZdHWMnwPo8C9
	u6F+vriErOAku0tNMk1qIqFSOxvlGVLVmKJmErozlTlBwDnhm52XoektRSjVXD/i7QB+QR3fzqr
	c4DWdkdutKHJ+x4USSBTEiGRNjWZTuFalunMgJmxvi5C5q+72MHURPeHScDyRrwDLWTvzQHTqTH
	zb2hAA/4Slb8vltlERPz6DrqccqSxVIEPK36jog4Ix+ANE/Ga1hepSUZNhNGkUaxLf4Ho+c0dxs
	jqS+GQQCD7DS4oFj4uBjudrXBl02FBDiTwkuz5TYEy0ZXpjVaJ/Yp0hxqObu+rCazVA0AokB/gh
	1wcBdwgXoNcFJ2xyGaOnFgH2qtjgX/20nw2YV+l8U6J4YrJk2h1eKLKFHm844vMOVAw==
X-Received: by 2002:a05:6402:a2cf:10b0:6b4:597f:50ed with SMTP id
 4fb4d7f45d1cf-6b4994c5b30mr2214a12.5.1793122718174; Tue, 27 Oct 2026 10:38:38
 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261027-fixes_core-v1-0-6f74bec9a5bb@kernel.org>
 <20261027-fixes_core-v1-23-6f74bec9a5bb@kernel.org> <auBityGTDQjXURWg@gremlin>
In-Reply-To: <auBityGTDQjXURWg@gremlin>
From: Suren Baghdasaryan <surenb@google.com>
Date: Tue, 27 Oct 2026 10:38:22 -0700
X-Gm-Features: AclHuK8I8xcfhrxH9JH4rYz28CrMoohsxda9QortkIHbiI93aH5ozWron9iLPAM
Message-ID: <CAJuCfpHEHPNj9DKOGbVHYCUsmLf==-XkhzBAR94gNt_ErhdnnA@mail.gmail.com>
Subject: Re: [PATCH 23/46] mm/userfaultfd: write-lock the VMA before waking
 waiters when unregistering
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Kairui Song <kasong@tencent.com>, 
	Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Baoquan He <baoquan.he@linux.dev>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Michal Hocko <mhocko@suse.com>, Kees Cook <kees@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, Hugh Dickins <hughd@google.com>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Pratyush Yadav <pratyush@kernel.org>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, Zi Yan <ziy@nvidia.com>, 
	Lance Yang <lance.yang@linux.dev>, Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>, 
	Alistair Popple <apopple@nvidia.com>, Nico Pache <nico.pache@linux.dev>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
	Matthew Brost <matthew.brost@intel.com>, John Hubbard <jhubbard@nvidia.com>, 
	Peter Xu <peterx@redhat.com>, Will Deacon <will@kernel.org>, 
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, Nick Piggin <npiggin@gmail.com>, 
	Oscar Salvador <osalvador@suse.de>, Minchan Kim <minchan@kernel.org>, 
	Muchun Song <muchun.song@linux.dev>, Xu Xin <xu.xin@linux.dev>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Chris Li <chrisl@kernel.org>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
	Youngjun Park <youngjun.park@lge.com>, Gregory Price <gourry@gourry.net>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Jason Gunthorpe <jgg@ziepe.ca>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, kexec@lists.infradead.org, 
	linux-fsdevel@vger.kernel.org, linux-arch@vger.kernel.org, 
	linux-cxl@vger.kernel.org, stable@vger.kernel.org, 
	Josef Bacik <josef@toxicpanda.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 4560380004
X-Stat-Signature: wkbpcxq54wgu1ur9qj8rfwgn3bzznbcc
X-Rspam-User: 
X-Spam-Status: No, score=-23.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793122720-416649
X-HE-Meta: U2FsdGVkX1/nHqyvxh53vev32pFmN8kkh/9ZQfaShhPi0hdlX7Lpxd09gkAa2ADNyR42f8upy8HSdTHsJAeuoFV9PyUDAkIaBGzPTuveXS8SKwmd1uerW5ibtrZjHCZHNIf8ylnAfuryK/M8eJwLm5ZJtbePErkOqBzsfaU9QRdmX6XOTjfai6/ESWfZDH3pOHfaB4W6Tb8NwdWeeV0blgDAlbGsRKLxeuuzf0fNmy2SVhnf5QRZVRNlhGtyh1bP9TjmRDAtX+Vm35m3pg2JJZ0YJd/Xlh4kbwzzTMC1DRvqt7uhh09lrqG1mo3pMeelOgp2FWvBfGl38tlB312be3zJG9jHlrZnyR7F19YIXayBBUG9Bdkdq2tplr3Dj2vAzhL2mFZVb2377n/P2FywQJt9aZYPDE5ffoYCpaFphlkGrJWO8rg1m6C6zcjvXRMrRvs5BPdOjACoop11ax0eIV+JFc4ImnC7KHW7HOgVgkrsJPyBSrpYGlXzDrERCVQZx8aCYEng3LCQLOyl0AMI4ajor5/AhcJ9dxGL9cKE8TfnsnrTla1UnohFsGX6MYOczSmcSu49UVvSr0sY8f90a8xsEZl4eN3IwpoZoeXepHId6IopXxs/yXdgtAYxnZjZ8As2mdYeejsPTDseYQ+nWIfmgiBc50lb3mWdVBymS6DEUWGTsPkr0Kr5ZNjh9oj8Ck0TOr8CmyDNcHvpggWYed6PW4K1AifEEj9GrvVm/CfvM/+e0ax6o6jsK0nved1KA+yA/tx4k4j/xULpsppzrzgy5qRz+jtjeDxtHN5BMTHNfON1cPlzmOhl7fTNgzsSwSHSet/cMnPUfyIFEn7z/axtQ4St3su2cfJPSbFMR9WBWYpVt/oz7pDgr3CsTzokX1gduaMTSoqh0BRlD9ZdJrATYOUc9Q9V6k0j1bA037xpsf5jC+qYwPf9l/K1UyqCJkZ5Rm2h/8j4S5gPSAk
 nVPAC9F/
 ymOFcknDrohUWkd4xPs79rU757NtXEJRrY0FB6AyzFNPtV/0A/ISQOUjnhaA2h8lM4ZF6VqHpf4r5TZOMt3xHzhEcjgCPJsGSzvPdIw7yqFNEk4aqLOOCVXujtX0LuYr6iNFs2cqPNDeP1Inxpmz3OgIeLzbpcPMhzD2hzo4Va5mNFD+ct/QSFJr0UildOwCKglcwh0X3v76crpbMqUqQEggKqzx+nH6Zkgv1frWDSOb5+V9obAXr4k1rH7jpkG/5N3czXXbhBpXBHgoHKmzJQWR74ANpcOwEc9afZaupT++GDfXBkrN6Kd94uKt1d0x0wBJ7jLwAuG/obyAWvvoRyMhdNf4wWhonTof/EkHrk4jdLbxfg8YLfPZO1DIZBzQQw4UcqRf6cfi21MUJCWCL+dqmhbLimkdDkh1o
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Oct 27, 2026 at 1:43=E2=80=AFAM Lorenzo Stoakes (ARM) <ljs@kernel.o=
rg> wrote:
>
> On Tue, Oct 27, 2026 at 12:17:43AM +0100, David Hildenbrand (Arm) wrote:
> > userfaultfd_unregister() wakes pending missing faults before clearing t=
he
> > VMA's userfaultfd registration. With per-VMA fault locking, holding
> > mmap_lock for write does not prevent another fault from queuing after
> > the wakeup but before userfaultfd_clear_vma() write-locks the VMA. That
> > waiter can then remain asleep indefinitely.
>
> Oof.
>
> I guess userfaultfd_clear_vma() only implicitly takes the VMA write lock =
via
> vma_modify_flags_uffd().
>
> >
> > Call vma_start_write() before waking waiters. Existing fault handlers
> > queue themselves before dropping the VMA read lock, and new readers are
> > excluded until mmap_write_unlock().
>
> Clearly an oversight from the VMA locks work. I guess was always a Hercul=
ean
> task to catch every single point at which there is an implicit assumption=
 that
> mmap write lock ~ readers (esp. faults) excluded.
>
> >
> > Fixes: 29a22b9e08d7 ("mm: handle userfaults under VMA lock")
> > Cc: stable@vger.kernel.org
> > Reported-by: Josef Bacik <josef@toxicpanda.com>
> > Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
>
> Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Reviewed-by: Suren Baghdasaryan <surenb@google.com>

Thanks!

>
> > ---
> >  mm/userfaultfd.c | 3 +++
> >  1 file changed, 3 insertions(+)
> >
> > diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
> > index 669f71d485d02..7e30b5ff17be1 100644
> > --- a/mm/userfaultfd.c
> > +++ b/mm/userfaultfd.c
> > @@ -3991,6 +3991,9 @@ static int userfaultfd_unregister(struct userfaul=
tfd_ctx *ctx,
> >                       start =3D vma->vm_start;
> >               vma_end =3D min(end, vma->vm_end);
> >
> > +             /* Prevent new userfaults from being queued after the wak=
eup. */
> > +             vma_start_write(vma);
> > +
> >               if (userfaultfd_missing(vma)) {
> >                       /*
> >                        * Wake any concurrent pending userfault while
> >
> > --
> > 2.43.0
> >
>
> --
> Cheers, Lorenzo

