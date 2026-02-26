Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8876AFC591F
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 10:20:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E50DA6B0088; Thu, 26 Feb 2026 05:20:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DFEEF6B0089; Thu, 26 Feb 2026 05:20:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CCD186B008A; Thu, 26 Feb 2026 05:20:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B702A6B0088
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 05:20:22 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5AD21C34EB
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 10:20:22 +0000 (UTC)
X-FDA: 84486213084.03.A4A40FF
Received: from mail-qv1-f54.google.com (mail-qv1-f54.google.com [209.85.219.54])
	by imf18.hostedemail.com (Postfix) with ESMTP id 6303A1C000D
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 10:20:20 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=DD41KjmX;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf18.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.219.54 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772101220;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Z4C8n44UsFGj1TBvnNozK212ZBsA5dM/2a0jh371h7o=;
	b=fvJdAgiP1R+yHsFd0Y2NSpOqN8T8fJe2pWc0Ml0ux2uLmRbA/f8NUoz3mY2G9sR+QmZsVV
	ljNKxnpEHkL6lc7N1xiz+HZDdie29WsSUsgg9YLLPdeKyC9nf5XRgY879aEdLRZYV6lG2f
	nIv27uglg6pFV3MHSozesep5vXBvCNc=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772101220; a=rsa-sha256;
	cv=pass;
	b=cUt8VKqtPIoNdPDuwEo/CLkCNz0xOpSZCYtpGYmE1NMDf3qBW7siMHn0WcqtmdHNwGe51W
	Wt+NWAfhnee+cfMwnl7cxLNHZ9v0y3BZWfM9nChv07kSiUUpgrXSitOHOmAg6E0FpZivJZ
	hYThoVi2uO9SlK0AgwNoxIA5NilEumw=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=DD41KjmX;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf18.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.219.54 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-qv1-f54.google.com with SMTP id 6a1803df08f44-899a5db525cso6685766d6.3
        for <linux-mm@kvack.org>; Thu, 26 Feb 2026 02:20:20 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772101219; cv=none;
        d=google.com; s=arc-20240605;
        b=K5HtOIpSUff3TBrKyA3strQjaI8vAzKgJ5XF7E5epL61owiHMeNazyxnVeynQ2MjMA
         89ugRbCSHxEqA6onbqE/mAE9tM7OsIXnWA4yh+Qei2QqNm8RDbz2xwGnLn6FoS8Wu65W
         2zHlnA40grxvW2Cr2tUT3mFNNPeIgiYA9lW55HsZwbXZPZEG1ABVYyCZE7ssuaJneD8X
         BfShgsA7GCT72Yw8RqNp7j7DRCFTC1s3VYOVetdDxSyGE1PG1x2iAFrfFfzKAYE1amSO
         MuccVOUBL8DwTdwnJZUZHKWSQNFhCFudP/T+hPE9rgURjisEXSSQqjP4d8+gA2kyyirD
         GISg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Z4C8n44UsFGj1TBvnNozK212ZBsA5dM/2a0jh371h7o=;
        fh=9lUPpcGfP/F5aghlISHS9rQpO9oFhpRLatAQj294oiY=;
        b=FevX1S4Lsxf8YgvzD8HWvqacy68WhuzABPbJZqOyOymUdB1xVcdlbk8vDHnMRAgdu3
         HXgAzo92H0ECDGzIXDxnxdnQ8JJf+AKBCAOZuZWlRYpAzK7bighj1bKOhZyxUdoV697R
         vie3gD0LLqryUqc7LldcNqCpldEGHbgqFsuhH77OUFgmFMU8jeX7lpPEZkyC4srKyxv7
         Rc0BOJcniZbrB0JFGs18NpF5PsucnumRE5cyDLgMvjhCPC+50/4qdTGnLjzZt5QAS7WL
         F0c4bY6M0u3IQgyiA2xAt/7WV/tB0d+FMiI3zgN0//J7qaNW1OsQ3yPkE9mXXWgrBo4S
         UMmg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772101219; x=1772706019; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Z4C8n44UsFGj1TBvnNozK212ZBsA5dM/2a0jh371h7o=;
        b=DD41KjmXPOzwgulSQsKzcN69/3qAEhwjhLT7RpkKrVhcl3YNEIXv5TGTa9uTYkJW4+
         ZD/P85Ncwogsbf32EbKVAlxXRoYf9QmikD97iUEs7uu5XVzzHDK5xN9pIYNjazDDd3S7
         XxDOuWm8iSh7VKVZoCLmr1MGDKoTiaY2ZRthLiOGuSAvXFY1CoDZi54jdb1u3tf3mu7X
         bWHoiZQz0ENrVMenCHJPm9vcJ9vgM2VwgILs3b40H37M2PbwY5ad+oUriWJTUnvTE48T
         MNHtkgBXWNAJBK8v1hD9IPTLzh+ieGULg/n0AUmgUA3q/bQFgYSgoosgiOMgQOjGkZJ7
         IZgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772101219; x=1772706019;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Z4C8n44UsFGj1TBvnNozK212ZBsA5dM/2a0jh371h7o=;
        b=a7fvYpHSOWGjh2hvndrclGuXcuzr8oepRUIRfIwHdoG1s7bMrEmtvwSMM4yAdCdN4n
         Nr7CiQnr4m+rKvBN3Ftxy3CB1csPVxOCaEUlYTrHqsUNtP7jll0CZR7dKdb0LXAte4Cl
         txj4c9aRLDKjehJqS7Bs+2p+46dCT1WhmSCjp3NhxyYNxC3hh/2IRDCYc3GVaFecq2Af
         IAM3gbTdRfZPTOV+Nk/t0jUMucWvtnmE4mSbmYWpa2LuYBlxZCjexcEsAl9QDhN3vjyF
         atLgugTnpDsat9xH4IO0eDhiflKGE3v9uxOT7ojUkOkv4xc5WrvJDxHtW6S8aH78diDE
         lY8g==
X-Forwarded-Encrypted: i=1; AJvYcCXBm82doPtvWOeThrxfjG20/ibDDqdU+unVzss9j+wUKzPpWqxmekgiGSw5bCcR56TyQsqj5neRLQ==@kvack.org
X-Gm-Message-State: AOJu0Yw0mNOL43Ml6kXIx4W20cutoA6fyoCTmN3D+SB4N52L8S8DgCR5
	YOSbzM4uG6gdTz+Lu7dNFCs39TpIaRfTgfX8jyJoLlakosVF88jAKeti1Kp9f/Fjvdq6KE/Ua6m
	H+duClnp0xmmAJDyyGElDpBgN3jJqS4o=
X-Gm-Gg: ATEYQzzMc8P+lWZtqsrU60crYS/TCJm+Qg4iAEHWu7EET+KqvkmCJtOKoBGqQatiKGQ
	9X5bQf9vcLPRFJCHXUM44w1Rh/UJ/ys71ySTg8V5aAUJbdhOMpqEGupM+rLhsQ80kzHpuZYlnHQ
	gfZELoUbdFOPaK0oZ4Qk4WPoN8LwR+6f8T+JhMp+EKQld4XZpCYhGvFv/gyFh8Wx51FBNuVjdPM
	XhT3L4q0KQcqiSu0cmO9T+0I5Z1fd925rBpxZMrN85LvbSR3Fwuh79JgAkkYtNebPUH8ktQv2cy
	SzMYqg==
X-Received: by 2002:a05:6214:19e7:b0:896:fedd:6dd4 with SMTP id
 6a1803df08f44-899c7ea6e7cmr20251116d6.2.1772101218941; Thu, 26 Feb 2026
 02:20:18 -0800 (PST)
MIME-Version: 1.0
References: <20260224110934.881360-1-dev.jain@arm.com> <763ffcc5-8640-4b48-8ace-051ff0ccbdaf@lucifer.local>
 <61161337-0d0b-4597-aad6-b5a1aa1ad41f@lucifer.local> <36e676b4-dc6f-45f7-b885-8685227ac6a8@kernel.org>
 <CAGsJ_4x=n9BPHN9Eg9KYY40T68wWuNJUN1x8dokJqFXSKu3KyQ@mail.gmail.com> <bdfae0dc-b7f3-4c1e-b8ad-8a0cdf50c1e6@kernel.org>
In-Reply-To: <bdfae0dc-b7f3-4c1e-b8ad-8a0cdf50c1e6@kernel.org>
From: Barry Song <21cnbao@gmail.com>
Date: Thu, 26 Feb 2026 18:20:07 +0800
X-Gm-Features: AaiRm52sBIsg9Ji3aJt2VA7phfOOY4dGveh-0of0v4P4KWx9vnjEIHeVxEIWqh0
Message-ID: <CAGsJ_4x_ggrEs+TkxNpdyR4avPwcf7pyB_sUO=EOR7t53kCJXw@mail.gmail.com>
Subject: Re: [PATCH] mm/rmap: fix incorrect pte restoration for lazyfree folios
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Dev Jain <dev.jain@arm.com>, 
	akpm@linux-foundation.org, riel@surriel.com, Liam.Howlett@oracle.com, 
	vbabka@kernel.org, harry.yoo@oracle.com, jannh@google.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, stable <stable@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam09
X-Stat-Signature: 48iwqmp9p5qi8nfaxhgq68rqnf3kc4tk
X-Rspamd-Queue-Id: 6303A1C000D
X-Rspam-User: 
X-HE-Tag: 1772101220-351255
X-HE-Meta: U2FsdGVkX18VUIOM2fnwkFWDV24ltkWhbvpci1Vu2AuVeFKP6wTgpBOSZBgZXLeMAK5nihFwJKA/DMbX5RdaNYmO2/fgqkdpTJkRUVtCcsfb9yFsDjbGg5CGZ6rmWFLXXHlVDqwraB2xPU3qW4I7qUH2V+YQo1jO6YALRMli1lwvXVG/Y+DQzX23t6Fe2pwqLjWZCXp0mVEje3jlg27AnxX1/R0gTgX5rd8n7tYVYHyio0cBTKuX9HtCIWH2Ksa9lrJJ0X11V2+q4n0ynLKbE7mQvi/m+n+dnRo/wSPTSdCKJXwLeqRmsINEi1nMk19zOl0shO2iN+nEdWVrHfWJcZTfMU0NlGDOBIBcVZNgvv+meA04mNvU/V4Lna6LkKiWIj41sMxHNcE8Vv/BsQkBPHEIID9Qp0HYV1Fe25XXmAQskC/NqNrKFk3B3vemuNqYk8SEPuU47sV30sxyTZRWxd/6KvKXpVDbu0ABgrF74HzAW8kiGOvciJU/tDVo4L4JWMSqpmsnRfEgafzSVe2QkrXbkVJdW3J+RvidKeEEsewl5iZ3Q2cVayjsx4oL83Nd0rVkfYt31I75H3TT8WvOBYK+CpKdknB6ZwPU9IURpWRiPEHNx4CQOyibA8X1cqqvPn9wZV9hu8uhG+yFemCn8xtgrhUL64ZmCl7PbYgrXNUjmKRWkZco1WbtK8xv7Z73ZlVuz/oXYQfnyxX/oCsuJPxAuvS+fqDeQ7EmrPllnfPXqsz5nUcsV1shJOTEX3PBR6i82mD8ZqvX5VXcNGfti23bO7Jkj7x/7Mn5LfTlxUEkD21ftcNs+m5XLqaQGyb2rKPBAXnENhZPPVH2Hq6oW2wM6nrVAv31ZiAOTyTv7grcz1rKQbiOG9Nh47MCFyrCgIzoOR1fTZ4gYNzEsJnE36QuXBXnZ6E4n80nht48BCGzQC0k5uP3yf/s/C0ugZ+5F3fDNIEaCiIi2PfarlB
 HtMl0wWD
 TcJlNuGKC2lzHDepjvpMT0QUiMxkAGLNLa6usKiREgbl5ddTDZJo5kSCrOyEq+vh5gaWh84VhtHeflhhcYCOYICOYwmAaPV3WVHYnUUUsZgf5BBdF+SlkNj6Rz2OVGHDiqoL5f2xHKuSZl3gD9Y+/9sCnpp/UhSxWdQtjpc/A8r044+7NGQ+0qUWYE7BhS+zy531otMU0olzkGe2lPQmUgr47Y3U2AN/PAvwxC5qH2zdKKqdcgfdhlsVp82NcGIElv02rY4+B5AoCRbEul/HBAcN3LfMPAQNFecl8mm4YpYD4zBIRTqae8k8L5ZgNJo2UmTlwEqJiXoLUa+zeh7hp+k59tTQky5ybLpSIDjZfh/o1rHSP8aRGajrtOYWMt9g6Qc7WGzqw7IGnNC74cb1xfk7mkxQNXXpe5r6RN0ar2Jvuz3A=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Feb 26, 2026 at 6:09=E2=80=AFPM David Hildenbrand (Arm)
<david@kernel.org> wrote:
>
> On 2/26/26 08:01, Barry Song wrote:
> > On Wed, Feb 25, 2026 at 12:01=E2=80=AFAM David Hildenbrand (Arm)
> > <david@kernel.org> wrote:
> >>
> >> On 2/24/26 12:43, Lorenzo Stoakes wrote:
> >>>
> >>> Sorry I misread the original mail rushing through this is old... so t=
his is less
> >>> pressing than I thought (for some reason I thought it was merged last=
 cycle...!)
> >>> but it's a good example of how stuff can go unnoticed for a while.
> >>>
> >>> In that case maybe a revert is a bit much and we just want the simple=
st possible
> >>> fix for backporting.
> >
> > Apologies for the mess I caused, and thanks to Dev for catching this bu=
g.
> >
> >>
> >> Dev volunteered to un-messify some of the stuff here. In particular, t=
o
> >> extend batching to all cases, not just some hand-selected ones.
> >>
> >> Support for file folios is on the way.
> >>
> >>>
> >>> But is the proposed 'just assume wrprotect' sensible? David?
> >>
> >> In general, I think so. If PTEs were writable, they certainly have
> >> PAE set. The write-fault handler can fully recover from that (as PAE i=
s
> >> set). If it's ever a performance problem (doubt), we can revisit.
> >>
> >> I'm wondering whether we should just perform the wrprotect earlier:
> >>
> >> diff --git a/mm/rmap.c b/mm/rmap.c
> >> index 0f00570d1b9e..19b875ee3fad 100644
> >> --- a/mm/rmap.c
> >> +++ b/mm/rmap.c
> >> @@ -2150,6 +2150,16 @@ static bool try_to_unmap_one(struct folio *foli=
o, struct vm_area_struct *vma,
> >>
> >>                         /* Nuke the page table entry. */
> >>                         pteval =3D get_and_clear_ptes(mm, address, pvm=
w.pte, nr_pages);
> >> +
> >> +                       /*
> >> +                        * Our batch might include writable and read-o=
nly
> >> +                        * PTEs. When we have to restore the mapping, =
just
> >> +                        * assume read-only to not accidentally upgrad=
e
> >> +                        * write permissions for PTEs that must not be
> >> +                        * writable.
> >> +                        */
> >> +                       pteval =3D pte_wrprotect(pteval);
> >> +
> >>                         /*
> >>                          * We clear the PTE but do not flush so potent=
ially
> >>                          * a remote CPU could still be writing to the =
folio
> >>
> >>
> >> Given that nobody asks for writability (pte_write()) later.
> >>
> >> Or does someone care?
> >>
> >> Staring at set_tlb_ubc_flush_pending()->pte_accessible() I am
> >> not 100% sure. Could pte_wrprotect() turn a PTE inaccessible on some
> >> architecture (write-only)? I don't think so.
> >>
> >>
> >> We have the following options:
> >>
> >> 1) pte_wrprotect(): fake that all was read-only.
> >>
> >> Either we do it like Dev suggests, or we do it as above early.
> >>
> >> The downside is that any code that might later want to know "was
> >> this possibly writable" would get that information. Well, it wouldn't
> >> get that information reliably *today* already (and that sounds a bit s=
haky).
> >>
> >> 2) Tell batching logic to honor pte_write()
> >>
> >> Sounds suboptimal for some cases that really don't care in the future.
> >
> > I'm still curious what the downside would be to applying the
> > simple fix instead of introducing more "hacks". As I assume,
> > cases where a folio has both writable and non-writable PTEs
> > are not common?
>
> With "in the future" I thought about file folios, where I'd assume ti
> could happen more often.
>
> For lazyfree, I agree.
>
> In the end, batching as much as possible is nice, but obviously, once it
> gets too shaky in corner cases we might not care that much.

Assuming 90% of folios have consistent PTEs, perhaps we don=E2=80=99t
need to worry too much about the remaining 10% of inconsistent
folios. We=E2=80=99ve already gained performance benefits for the
consistent 90%, and while the remaining 10% may not receive the
full batch, they are still getting some batching.

I don=E2=80=99t have the exact number, but it=E2=80=99s likely 90% or highe=
r :-)

>
> >
> > diff --git a/mm/rmap.c b/mm/rmap.c
> > index bff8f222004e..48ad3435593a 100644
> > --- a/mm/rmap.c
> > +++ b/mm/rmap.c
> > @@ -1955,7 +1955,7 @@ static inline unsigned int
> > folio_unmap_pte_batch(struct folio *folio,
> >         if (userfaultfd_wp(vma))
> >                 return 1;
> >
> > -       return folio_pte_batch(folio, pvmw->pte, pte, max_nr);
> > +       return folio_pte_batch_flags(folio, NULL, pvmw->pte, &pte,
> > max_nr, FPB_RESPECT_WRITE);
> >  }
>
> If we already go for this approach assume we should then just set
> FPB_RESPECT_SOFT_DIRTY as well and have it all handled properly.

I would vote for this, as supporting those inconsistent PTE
cases could become an endless and painful task :-)

Thanks
Barry

