Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6A2A2EFB7F9
	for <linux-mm@archiver.kernel.org>; Tue, 24 Feb 2026 08:04:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9F3976B0088; Tue, 24 Feb 2026 03:04:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9A1A46B0089; Tue, 24 Feb 2026 03:04:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 883586B008A; Tue, 24 Feb 2026 03:04:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 713BC6B0088
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 03:04:50 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D50F91604B9
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 08:04:49 +0000 (UTC)
X-FDA: 84478613898.17.80B0D6D
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	by imf01.hostedemail.com (Postfix) with ESMTP id CBBEB40008
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 08:04:47 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=lu3DYPtm;
	spf=pass (imf01.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.43 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771920287;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=drSksRq4NuWRvjnW2zeUkqenpzJUzAwBwFqniaqgFZg=;
	b=8fmIRB6QxwmUbXnrEN5gKUhjCeh8CBYFKzMjhd7ySY7P3AmFw2+6zZeMNBHhkYYViMT/Dx
	JDw/b9/9GTyTGM7Vovq55gQeGByyAXjUmAbGJcyhykhJtvI7vW0cHxDzpC26vgalknEtYh
	i3J3W7S/kPqB9A3nVHCK9DKbXEnBhwk=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=lu3DYPtm;
	spf=pass (imf01.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.43 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1771920287; a=rsa-sha256;
	cv=pass;
	b=oM3zQjPfCjGBo0IJxkms1mSUtrRlkPWvoCLXDTamYLoR/gkIZVMA6GQYVx0cWhulLHaoHZ
	pdXBj4thPr5jrGNiKbvt0bxXGmvF/Jlo4VermGoZq4+UcHU6BgfV7Qv9rQPJdueUnpbVLy
	3YGIZORWnB+Mh7gGHsM+ZJ+bpZQf5PA=
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-65a1970b912so9865149a12.1
        for <linux-mm@kvack.org>; Tue, 24 Feb 2026 00:04:47 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771920286; cv=none;
        d=google.com; s=arc-20240605;
        b=P8KAQZVLV7cQ2yMKHMXX/OKZ3oiwl67edlsq8gI6IbqeYGpUGs3VFZCjWLt6XQGQAt
         J6DmzHTOHmTAXaRPWJW/5IOC5j9n3It6rJ9uLMuRsmAoJnnZtIGr3xAgO1CgPf0UYVp4
         q74aRN2rTC2/WR5KJ0dwPyxu3OO96JlvP0aBFhMhfFroUDCPDBvIOJgWMTEPla/cLTka
         M0ZjA4ZiDDTGdo4QCJo8MNI0Dor48iUivHgf2Md0tamfz9HoV2fNuag14QwA4W5fsYub
         CqU3UkGU7sEYeq6RlEbVABKlsPc/7Tk1WY2zxNSwJDquSEKrPsBYF9CmZgSbVMuFEj91
         nOjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=drSksRq4NuWRvjnW2zeUkqenpzJUzAwBwFqniaqgFZg=;
        fh=WLpyzRRMovJBHSqoV7Wqy04tUq2ZvYvYpWxHTp+NZaM=;
        b=FNc+R4DkNI/mfFicB/Eo+GXFq06EAf+gWa+HDKX+siiqmiaT3k99IKzUncEZ3s4K6E
         l+3W6hvdmtcd31Dr1OfRjJMSFx1TcudBwxQ0h3O35iH3xd3UheP71w4qfNxiuvFwrN76
         /fFyQMahgBbbM/AmELBAbC+f0o25KibJi/lXFXJcwig/DVDPP84aVGJyKZJHFPurYsY1
         TzdjCdJDvSNPYDkLRsnGd9v8WU8LK7tLB5j+idKah4d6UWMLETR3kEPxfiVT+BAzOdcG
         vIjPLok/c2YHfb0vteVAwWTNjfiegfVHw9f6zfKEA5Le10q1J+XYGqQy0G2LEUhGvQYF
         /6eQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771920286; x=1772525086; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=drSksRq4NuWRvjnW2zeUkqenpzJUzAwBwFqniaqgFZg=;
        b=lu3DYPtm7PI6c9ZqFx+YnZ7WiU5pFK+i6p3qZO3SpD+zwAWYrxfIuLua5WHQFrVL25
         vKehBx5Cwk8796kgd9ALQUapa707cc+4nEsI6Rm+68sYqZlm9sEoO+6srTdKQBDeiWqh
         G7CZXQHAjFlW6JU7nh1LDltnwMwzUFEtye0/vBfb8f6TJeOqU+pesbOKwI8Qr6NSyuY5
         DQ2ofp3MWde6c9FP/1YPKhlrT4SwqLx5zipqj25oyZoktiZoFB2eLfGdvPkxnigvgARj
         spjM98zok3Dgc4Ab35bs3qYFVGr5B7ja99+d/WiGt6tVqQ0by7IlimC5Q9vfkzaUrd0E
         bfYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771920286; x=1772525086;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=drSksRq4NuWRvjnW2zeUkqenpzJUzAwBwFqniaqgFZg=;
        b=XyKeiut9T26dn+6R/DjBg0tennmMRB3o1YG0NAetRNsaTczLtWzDhzC5MdLG3ABPjF
         bWCotwL3X7BRFBsxs4KrXlFogph3yCBBCP507h0gByHR4MjoEbCnOEHVefwvnuoPfcQZ
         +QiAsNOmxYgc0VonwWyZ7sFF+6gkU7slpol5EQJT8YcXkJ3Q2ua+sVQsHUobaKysRHpy
         BBJHE1idxpCX93SunHWvdo22q3V1cyhApikFVm3AEPFjxO9H7AHR+Hq0pG7vR6XbKpYP
         pd3j35OGOH0DHNHq6nj+h4RkTttjOsAoFH4k0cjs/ajBzmKJQg12xEexzVAQ3zOenKKL
         eBCQ==
X-Gm-Message-State: AOJu0Yy8ojm0/BnGAv4/09DXCYt4PofQaYNCZwpnCXUKT/JfQGJO6gP0
	l/gi2VGWEQyHbGN6eLMiwSVw7yKgquW1zUDOKVaqsKOfENfLv/y7gvg34b+f2gGBDhPNsdI26YR
	sJXi5OkryoPkQQylE40tZfcGGlAO8yC0=
X-Gm-Gg: AZuq6aJ3rDjYNiPaDJ39/CEgP6aOjP9ODzyn7KQfXtmnJvlP/hw2I/QJKK9kg0z7PJ1
	rXNE4nmpNymYJVRvFkq+SVFziMgs9gCE3MRrSGjd92pkYcuPsLG+jtqefCPAJTk6g0ij35sZtu1
	abM43zPzN5sAWE7bhaweCXBJR8akS0sQYT9teCnbRG2Vo50BZMuJ6UifZrv8AA5CwtWjOxpylWp
	akuI5isetMN8BTLDbYQDPw8VUBnC88bo5pvjIucf5cLQAYANi67DkeFoUq0tU7pWSZl3ro3y+jE
	miMKsBE0lKwIcO6jW41h7EwLprA/FRO5vvLRfXZA
X-Received: by 2002:a17:907:3ea7:b0:b90:77bb:5aa3 with SMTP id
 a640c23a62f3a-b90810895b3mr612662066b.16.1771920285771; Tue, 24 Feb 2026
 00:04:45 -0800 (PST)
MIME-Version: 1.0
References: <20260216-hibernate-perf-v4-0-1ba9f0bf1ec9@tencent.com>
 <20260216-hibernate-perf-v4-1-1ba9f0bf1ec9@tencent.com> <aZ1X1OwbAUq1k+C6@yjaykim-PowerEdge-T330>
In-Reply-To: <aZ1X1OwbAUq1k+C6@yjaykim-PowerEdge-T330>
From: Kairui Song <ryncsn@gmail.com>
Date: Tue, 24 Feb 2026 16:04:07 +0800
X-Gm-Features: AaiRm51-aSztyUVcxT5UZHw9khAHxRhvCbDhyMjH-cHVvB6r2w9pZ5GYsuDWoj8
Message-ID: <CAMgjq7BeA4cr5DSjpdaTVRRmcb_Pq+68yGZiiDg21fNPfGUQNg@mail.gmail.com>
Subject: Re: [PATCH v4 1/3] mm, swap: speed up hibernation allocation and writeout
To: YoungJun Park <youngjun.park@lge.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Chris Li <chrisl@kernel.org>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, 
	Carsten Grohmann <mail@carstengrohmann.de>, "Rafael J. Wysocki" <rafael@kernel.org>, 
	linux-kernel@vger.kernel.org, 
	"open list:SUSPEND TO RAM" <linux-pm@vger.kernel.org>, taejoon.song@lge.com, 
	"hyungjun.cho@lge.com Carsten Grohmann" <carstengrohmann@gmx.de>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: CBBEB40008
X-Stat-Signature: 5dnz5tc6safdyytfryazfpzsruczfwt1
X-HE-Tag: 1771920287-656474
X-HE-Meta: U2FsdGVkX19a4ApjNy66o5ztQg6CJE6Ao7zBhQUQb8mIAfJU+7qDHX/Ooa0DGGCRcusghO28I39Z8a73dB0Fk3C3FlSSwRXtfgjdVSJaOJkE2T2eoNaf1sNa/FLKFXZBUzJTk+esHMnEcXCnOKjjTCqupNfVTgd2Z5W96lnos/UYTS6vGKqqod8nMUIoJpZhieN5Z2fPKV5IckK/Ck7kb3IUo0NUC2GhbhwbVaDmaMPNFpz6lOrv+tWVHFnKdc3356z7ji0AWuGtsNYHtbCYoO/ec36FkvlFYfZyCUFInzEg9++jNoVS4+Kpq/8jMJHTU61ZwY8hAHE1CQi1M5gBsLb1pPh3vGJKJWc3B56QT1kNPY0ilAdu/pqcleQRTmflihV5auoPUtVL2h9zz26LjMevMrenT8zc3+XTovt0ZvxTx21Y5pAUgcUQgGb1/YjpDEQuCIcpyNvqNSpZlADdyyjyNqWvN/v+kVIHMG91SQHn77JlX1qMtxqo7C1yw7QyhqblvsuXwKq/Vcb0pTGO+W886sXfIdT5eCjA70AYqFMTCDZlDth70DF33K03LVaH1vehvOlpKy+yqFI1Y0prT0eMwa3cQnbvy+sLcEI0PJJsU7vHuo76tmqwuGVosZrCX0u6EPuj3Ta9fvgSNENucAOhZqUoUWmq+s/wEJWTNkeTfxdZ6gWyXNWa8zHHWWD5ydvhdvWMmFfasBDG9NdhVCeR89ZEU+i5Q0kt7Ph7bhHTyOccMhUfctWWxzDMCzeUXk2ZKlFtqKMX/zu0e+37NjMBijZK+77OmKun7H9u597ABgKENqruDLfKvDX2+egRoO8XrtpFqwF9xIDVsfyxHZw65VXPPpzHSIrS6FIhjMh6yrNSACvqwYW/JISUorD6fjNkgR3JzY3RxlRbTkleZRvYe61UuZUVZJckhdytDyKQ8M12RG0ThNln4ozTmYielYOuw1jHvsYk8slJ7Hl
 RcSRmZaU
 5h7YBnt/MY2sBM+cLZCpP5wTMo4ZlsAU5ZwKV042RdB1bV6FXZbkaf0zRqhLXFDX3GFj/Wq9b4RxWGyZ6h2NGzTG/y3mbY0xPOGD/7JUcMuqzOA3+9myOQZxtLBpwYxHu2oHiiZlY3UEFzWUwImxe+vTvBuqO1xYGm/Fiqdlvblr9OD0IRkdmYEFiEVDvGaV87j98nyPy9HwOl90XLbFNwHAc91aeKHjjeH+VNalBi+lnQTbz8XB9KdPTW9t0VQlcy4kVimMFO02SEAtNflo7OI1AVxNDQfVjHy/5tIw1vb+m94aOTeTNEZCpMhgMjHO47edIqKzZUL/JdptM2EHmAonR8uEDU0EJE0rPqGQRAI0xWgmc+IZrJiu564DB+s9aNrbVJdD+vV1hdCuUOKUuBAfhzDwf5PIVznF0sTgNVlJt0ges+T9ZaIFQAVU3jybR9NvQ7jK9BjgZneX7AWz6fIBSBfSaXUpxnUTRvvdzHyfVw10/vJoS7mLX4v5X6lfT/MmUJZHUlL7vEF34OKM0oEcukA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Feb 24, 2026 at 3:50=E2=80=AFPM YoungJun Park <youngjun.park@lge.co=
m> wrote:
>
> On Mon, Feb 16, 2026 at 10:58:02PM +0800, Kairui Song via B4 Relay wrote:
> > From: Kairui Song &lt;kasong@tencent.com&gt;
> >
> > Since commit 0ff67f990bd4 ("mm, swap: remove swap slot cache"),
> > hibernation has been using the swap slot slow allocation path for
> > simplification, which turns out might cause regression for some
> > devices because the allocator now rotates clusters too often, leading t=
o
> > slower allocation and more random distribution of data.
> ...
> > diff --git a/mm/swapfile.c b/mm/swapfile.c
> > index c6863ff7152c..32e0e7545ab8 100644
> > --- a/mm/swapfile.c
> > +++ b/mm/swapfile.c
> > @@ -1926,8 +1926,9 @@ void swap_put_entries_direct(swp_entry_t entry, i=
nt nr)
> >  /* Allocate a slot for hibernation */
> >  swp_entry_t swap_alloc_hibernation_slot(int type)
> >  {
> > -     struct swap_info_struct *si =3D swap_type_to_info(type);
> > -     unsigned long offset;
> > +     struct swap_info_struct *pcp_si, *si =3D swap_type_to_info(type);
> > +     unsigned long pcp_offset, offset =3D SWAP_ENTRY_INVALID;
> > +     struct swap_cluster_info *ci;
> >       swp_entry_t entry =3D {0};
> >
> >       if (!si)
> > @@ -1937,11 +1938,21 @@ swp_entry_t swap_alloc_hibernation_slot(int typ=
e)
> >       if (get_swap_device_info(si)) {
>
> Hi Kairui :)
>
> Reading through the patch, I have some thoughts and review comments regar=
ding
> the hibernation slot allocation logic. I'd like to discuss potential
> improvements. (Somewhat long... lot of thoughts come up on my mind)
>
> First, regarding the race with swapoff and refcounting.
>
> The code identifies the swap type before allocation, so a swapoff could
> occur in between. It seems safer to acquire the reference when identifyin=
g
> the type (e.g., find_first_swap). Also, instead of repeating get/put for
> every slot (allocation and free), could we hold the reference once during
> the initial lookup and release it after the image load? This avoids
> overhead since swapoff is effectively blocked once hibernation slots are
> allocated.

Hi Youngjun,

Yes, that's definitely doable, but requires the hibernation side to
change how it uses the API, which could be a long term workitem.

>
> >               if (si->flags & SWP_WRITEOK) {
> >                       /*
> > -                      * Grab the local lock to be compliant
> > -                      * with swap table allocation.
> > +                      * Try the local cluster first if it matches the =
device. If
> > +                      * not, try grab a new cluster and override local=
 cluster.
> >                        */
> >                       local_lock(&percpu_swap_cluster.lock);
>
> Second, regarding local_lock:
>
> It seems mandatory now because distinguishing the lock context during swa=
p
> table allocation is tricky (e.g., GFP_KERNEL allocation assumes a local
> locked context). Have you considered modifying the swap table allocation
> logic to handle this specifically? This might allow us to avoid holding t=
he
> local_lock, especially if the device is not SWP_SOLIDSTATE.

I think you got this part wrong here. We need the lock because it will
call this_cpu_xxx operations later. And GFP_KERNEL doesn't assume a
lock locked context. Instead it needs to release the lock for a sleep
alloc if the ATOMIC alloc fails, and that could happen here.

But I agree we can definitely simplify this with some abstraction or wrappe=
r.

>
> > -                     offset =3D cluster_alloc_swap_entry(si, NULL);
> > +                     pcp_si =3D this_cpu_read(percpu_swap_cluster.si[0=
]);
> > +                     pcp_offset =3D this_cpu_read(percpu_swap_cluster.=
offset[0]);
> > +                     if (pcp_si =3D=3D si && pcp_offset) {
> > +                             ci =3D swap_cluster_lock(si, pcp_offset);
> > +                             if (cluster_is_usable(ci, 0))
> > +                                     offset =3D alloc_swap_scan_cluste=
r(si, ci, NULL, pcp_offset);
> > +                             else
> > +                                     swap_cluster_unlock(ci);
> > +                     }
> > +                     if (!offset)
> > +                             offset =3D cluster_alloc_swap_entry(si, N=
ULL);
> >                       local_unlock(&percpu_swap_cluster.lock);
> >                       if (offset)
> >                               entry =3D swp_entry(si->type, offset);
>
> Third, regarding cluster allocation:
>
> 1. If hibernation targets a lower-priority device, the per-cpu cluster
> usage might cause priority inversion (though minimal).

Right, the problem will be gone if we move the pcp cluster back to
device level. It's a trivial problem so I think we don't need to worry
about it now.

>
> 2. Have you considered treating clusters as a global resource for this
> case? For instance, caching next_offset in si(using union on global_clust=
er or new field) or allowing the
> allocator to calculate the next value directly, rather than splitting
> clusters per CPU.

I'm not sure how much code change it will involve and is it worth it.

Hibernation is supposed to stop every process, so concurrent memory
pressure is not something we are expecting here I think? Even if that
happens we are still fine.

>
> Finally, regarding readahead and freeing:
>
> Hibernation slots might be read during cluster-based readahead. Can we
> avoid this (e.g., by checking for a NULL fake shadow entry or adding a sp=
ecific
> check for hibernation slots)? If so, we could also avoid triggering
> try_to_reclaim when freeing these slots.

Definitely! I have a patch that introduced a hibernation / exclusive
type in the swap table. Remember the is_coutnable macro you commented
about previously? That's reserved for this. For hibernation type, it's
not countable (exclusive to hibernation, maybe I need a better name
though) so readahead or any accidental IO will always skip it. By then
this ugly try_to_reclaim will be gone.

> Thanks for your work!

And thanks for your review :)

