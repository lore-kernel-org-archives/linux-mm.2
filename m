Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B6C5606A31A
	for <linux-mm@archiver.kernel.org>; Fri, 30 Oct 2026 22:53:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=amacapital-net.20260707.gappssmtp.com header.i=@amacapital-net.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=CCp/1l/1
Received: by kanga.kvack.org (Postfix)
	id 805EC6B00EF; Fri, 30 Oct 2026 18:53:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7880A6B05B1; Fri, 30 Oct 2026 18:53:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 629426B05B2; Fri, 30 Oct 2026 18:53:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3367A6B00EF
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 18:53:48 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6844C120790
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 22:44:09 +0000 (UTC)
X-FDA: 85380772218.21.6BFD80B
Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com [209.85.167.41])
	by imf21.hostedemail.com (Postfix) with ESMTP id 618E91C0009
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 22:44:07 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=amacapital-net.20260707.gappssmtp.com header.s=20260707 header.b="CCp/1l/1";
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf21.hostedemail.com: domain of luto@amacapital.net designates 209.85.167.41 as permitted sender) smtp.mailfrom=luto@amacapital.net;
	dmarc=none
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793400247;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+vnvo88Pr3dQY7eSVbimo7vIzM+xuPPq1OrMINl+rL8=;
	b=IYUvxWNzMKNSU9t0DfTALnYIyD4ro6YWsRAA/f2KYFUtVyi4zbeYmUZcmrWTeMx5X9nmZ3
	+CG7PS7NhHsze/dU6ccyCLwI2wpWkrEGVWyNKfEn6z4iOddCfAvVXochc/kJTEbGujnGsp
	sszEs3Oay/D1fjkmqx9MDHrkwBD9il8=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=amacapital-net.20260707.gappssmtp.com header.s=20260707 header.b="CCp/1l/1";
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf21.hostedemail.com: domain of luto@amacapital.net designates 209.85.167.41 as permitted sender) smtp.mailfrom=luto@amacapital.net;
	dmarc=none
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793400247;
	b=VTlOh7RCm6lTe1l9pLCO5SDCueXEU1/50H5i2rTZ0/zD44dH14fTLG0GxzsIUrAsmfK+ss
	ltfXgFP2Ldu8hVFLOpPKVelRdCnbL64feWDsFHEI1/dK8jPmnzKmLx8ZHM27Yf/vpMVa3f
	S7NQUdxJlC5YPkay2H3LaqCi+o8FdCs=
Received: by mail-lf1-f41.google.com with SMTP id 2adb3069b0e04-5ba3fba0080so907608e87.1
        for <linux-mm@kvack.org>; Fri, 30 Oct 2026 15:44:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793400245; cv=none;
        d=google.com; s=arc-20260327;
        b=hm8SzjEYWtMW28u0aG+8hNyI3yD/hSwE7dwo3H1PGJStpy5Ca5RShZjsW8thiPIX+S
         Bwli14sdup9Siw7nLY3Ov45Zz9sE5YmY4xrNQE8VRY2KtSz9I62DkMx7hUVLbrP2hLgu
         T2LB88sYdwln2M5sB9/n0ZjLvf+zQuW5ksTA3clJ/c+gbVKFprPK98dolbSi6ivFl4bi
         dXuBmp/HH3Ck6jl2rUihAqmWPnPB6mvaahTJ1XtNF2236JcZlwTsJFbXQW8rnQjALafT
         MCY54kTruMv7q63TeuXRjVkbSuCc4TIN6istcddRIjOB8ae3EHPBSke4Hbs+Gn4BnHaa
         REGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=+vnvo88Pr3dQY7eSVbimo7vIzM+xuPPq1OrMINl+rL8=;
        fh=dp6kLjEuq/YbiANen5RkcizkPWpLXXblgS/Z/SLhZcE=;
        b=SMsyKRaXwfi+4oIE1xTMgDTPz6U8g5C1pWxVItRN5CmwewCbaGJPECSV5Tl4yVvfwC
         wULqzcUgFLrQmb6pTqif1EqtvH/ztcC761wlx1OMQG1vSKgl2KqdOF65WSnvIhy7TeMs
         NbHb8RFpz0l10npayE1pzo8TvYIdrI9uLZjqnKf2vCZrDt7yx0R6rLtnGwiR+7qU/Sdw
         AUKbsPLmlRsk/s3EqB0mAPqZlw1jBCq8FVcR/FDDnLcqWXEDsUWCmk5WNytsnHozI9N4
         I0sdD1PV2sdlhqscucvdPmqlHNmWJfEEJRk7z3FKmYKXsI9pLM5Jzk3oJbplHm0p6K+D
         JJYg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20260707.gappssmtp.com; s=20260707; t=1793400245; x=1794005045; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=+vnvo88Pr3dQY7eSVbimo7vIzM+xuPPq1OrMINl+rL8=;
        b=CCp/1l/1I/tZ/wMzd/o3MrLRAyb00RxyZSOOJfpxdfW++YIYVokykSJyxKSLtq8Vok
         jYuxu7+Ad4AplW8Y3gzkOsJeIPWJxwdBRULE2RYvWOw7FaCnbTe7kYhYfBYhBQYhq/uH
         zU25tGNhT8tq9QJSNqMQct03iRKp1tH2dUH3C1SlIfJ55tZucOaRTynu4dz80EHfbHMl
         R1tGE4lNzA8R4RegZQO7f1tvRbLGDPhnMW5dm/9stky6HC9gjHQIgb6FyDOe6L8yFRzi
         B5TOOop67/HNT17Acvoq22e9Opm37A8Ck/GXjbhrs15O04raq+fKjj60i1rSV5FMKzeX
         KOMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793400245; x=1794005045;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=+vnvo88Pr3dQY7eSVbimo7vIzM+xuPPq1OrMINl+rL8=;
        b=giwWbWk2RnhBgwQBroi/G4kkWZyzPorGcq10+vzL8Ta9Jk1NlV9w+eWmRhD8vSadC0
         J12DSSVzBGbRH2ZF797dz70mb8QPXvCcrYl+9A1hLoPoRZmuG+WNfTHeZe2IVf09dETj
         HjtK1Sb9dgZ875WH7nO8MPpm3F9hVz/cP3T1BfcKudmRyeBwk2nzvhaQi+vK8gh0/fC/
         5/HAlwl/R0Z/XgzpC9VQy0y7Wn4uR4MBB4VPPqhfcAmAVwfNWuYFacS/E52lrXCYVSr0
         TbX5QWdBn0qZSVgD93NjlRqVUiMpgPbaXVPONZqnW7jpHtYkQ0D4v2+zWQdp/H436FMw
         /Hig==
X-Forwarded-Encrypted: i=1; AKwUvBxK9Xd/qAtSWdhS6INEwW75D50un5ZMi2iTIlYWuxMkx85+68Us0sTamiEzrcni/8yfJdfyQ1ZZuw==@kvack.org
X-Gm-Message-State: AFq9FYIvA6ZPBH3xHNKPPt1Bl615u/IurGonD8m/qM5oszscDcu7Qkow
	gtte9icW2ku1RcqD+Qz1UVe0sdpWTQUDxt4g4NMsM7zk4LBPZJnCSbU9x6tJgdqXsqGyctXEo9P
	YivEpJKm5b1JgA74zXhzXINwxaAH7dRkjTt9pTqel
X-Gm-Gg: AYBFou0C2B/ErqT6J4mG/32dbGxHNx8i16Qj9f8IPccSj1JljZV3O6ZNzIj+nvnrl/H
	G4sgqJ/ekJ9JJODtxY59aELhoetJifNTnmGlX1yvKDLP9eMChDWfLUsyXXHdb8izIIvR6t5Q0jr
	GJVTO6DyxXorOnloBYJv1ABMgtYUkkPerwqCRwPXSiXlx964KPZoWcdcWe9EaxfPWpmhgMtePky
	gsZnMSVTVhxgwg9iv1ErEF+Oza4W9W9xrxGFupJfcUl2CFxUDPsMjvQrOgQWBsU4BQbKiQxGWmh
	s92ehNappd7ZZMK7/FmWuQCYOKxOklKGx/my8PveRdB4SD0tP7+mht3k9glr9kzeIPVim5BfCUp
	/12FrxaeCpkFEtFcn7RGautKT/onxwc+TcQ==
X-Received: by 2002:a05:6512:a94:b0:5bf:b246:87a2 with SMTP id
 2adb3069b0e04-5bfd957b610mr1268679e87.10.1793400245078; Fri, 30 Oct 2026
 15:44:05 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261026220546.3114241-1-skhawaja@google.com> <d4891333-43ea-4d74-9fb9-6ad8dac1a446@kernel.org>
 <20261030121113.GB3889730@ziepe.ca> <2c7aa5c1-3af3-4654-b244-1257d05c9d45@kernel.org>
 <auTR9SnDLsLVmnJ7@google.com>
In-Reply-To: <auTR9SnDLsLVmnJ7@google.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Fri, 30 Oct 2026 15:43:53 -0700
X-Gm-Features: AclHuK84pmgR6t7GwgKZ09yPCaz9JinHcZg2AVlK1zJKyqi05vBjmcmKbMe2QqI
Message-ID: <CALCETrV5eqg6d9=+BQhCpRwBNe3aCQiut8vxPBs8b7PToqjaHg@mail.gmail.com>
Subject: Re: [PATCH 0/2] mm/memfd: add F_SEAL_PUNCH_HOLE
To: Samiullah Khawaja <skhawaja@google.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, 
	Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Muchun Song <muchun.song@linux.dev>, 
	Oscar Salvador <osalvador@suse.de>, Jeff Layton <jlayton@kernel.org>, Chuck Lever <cel@kernel.org>, 
	Alexander Aring <alex.aring@gmail.com>, Shuah Khan <shuah@kernel.org>, 
	Gerd Hoffmann <kraxel@redhat.com>, Vivek Kasireddy <vivek.kasireddy@intel.com>, 
	Jeff Xu <jeffxu@google.com>, David Matlack <dmatlack@google.com>, 
	Pasha Tatashin <tatashin@google.com>, linux-mm@kvack.org, linux-api@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 618E91C0009
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Stat-Signature: uqi5yf7sicf4yi8i18qe75y1jrcepeq7
X-HE-Tag: 1793400247-673956
X-HE-Meta: U2FsdGVkX191WqZd7nLN1omw5hTfr6z/Z00CYO4KdLTbDSfJUVA6ngcC0hy1eI2mMhUPoK9zCAk92q1hr2UUkN/7OQ6+lQCyOCpV4p5KqyMTKnUVjTi+aNbjyRAcAz9b+OG/fEkkSgNpglK8eA9Unu7OMKNUI7J+MVA9DhbaL+aCZRbz4uKrNisFupBWmqA6xc3Y3YM6iPKBxchcit+DNTcMyBHFpYq3CstAO+p2QY62+okt9XKSqM8XWoZEosfNE8wVFzNXUiIuPBlmTsSasGPGo0SVrDUdVwkFg7p0FQe8/OqTl3Yss8dt03uyQD3XvPOKtM2+RcKROQrmWkWTrSP9Ss68rimGZXUQrId0UYW3p4nkzqhliv531JP59A5jWGwJi/qb+odpWFshIO5WCAX4Oz/n3gNfOiMBXKtTyqNkhJUGSogW1Dmtg8pQCbHUXU5I5Rd1TRnCymICVZ1UIGYEANcY6RpzRBeK0YoK4mXiUtzUPYJ0Le3nbiDcH8zWvoC2AjHaZhN4zaHPH0G0DnLyDSKAkb1bFFOBlDME4SpC0jAuXeSg7Ugaag+SH+0Q0M0jYzhPuic76Fth7m8rfq5momQKa/GepsnctVA20gfToiCW7PMt7m2HNuJZWQEdEVjP65n4m25gNdL3zOZGwScSkp2OkQDzk5rf3MAwbiUFJpgeOz0WJTTdAY+f+jMgI9jNc7c9HJ1OE1e6kJRLUa596AgYS6rpveHOWTs8TWdqKuFtoPRCDws0DN8AXdacLCmJe+bA0kfC8lf+fJAMTzbwHCBNxqxV1MbmIVhzLVehci4/6xvclfJDQU5my2zlyORj0sZSSz6UrYyIOcTPESA/tMppWeWzYhvSsCWng5BRbM38SIVwX2CLwHl2vK0TRNt83N+zNya9cL4+0w53SW9ffBbjvpnyleb3kSzvB+oHjrj4c/IqY5Tcxcu9Wcp+67SdW8iMSl59iAb17E6
 1L/8NHOW
 1f1nE2y4oJ6py70gw3lDLTZYfT4iEJ3W/7d+igDkgvKdx8Ew5WwUwpl/wC/EbdvCTzKWqtB0sRbpGSjahGhAv1n+bUtfVXC4ke4/iYvlUiPCC3H+h94jIn+KKHE24a8T2jMbrhtGVVVACtL+ypMZ82diQrCLhu/ksxOMzScZ9OJgTHkoNPvFEYLotCH7xbKqDLuzaI8OMrIBuAWoBJhSdj+/t5hNiOrJUj7gHk56Jl/JXEvL4ywxjybtWaREW4teJv7Y6iAbLdUVdubXZmF9nUT+nNRzdmkT1+Zvds7t7Hhu1JNV1HE7jfcpEbTLfhdczzgifd0QU3wI+cX4Tayw9VHQmucteQwZYCHdlb6DOz66Dv4vTl5QY5dojTB3oaqNYrHQZe7AviQnm/e12luEfCreQusi+GiASlem0RWcIwDNj/y+WxBch0JPwWAGCqkiMjGWzFa5PRrl8Grr3WurVAsykAOTsJkRfiNAD
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Oct 30, 2026 at 10:40=E2=80=AFAM Samiullah Khawaja <skhawaja@google=
.com> wrote:
>
> On Fri, Oct 30, 2026 at 03:39:40PM +0100, David Hildenbrand (Arm) wrote:
> >On 10/30/26 13:11, Jason Gunthorpe wrote:
> >> On Fri, Oct 30, 2026 at 11:20:30AM +0100, David Hildenbrand (Arm) wrot=
e:
> >>> On 10/26/26 23:05, Samiullah Khawaja wrote:
> >>>> This series introduces F_SEAL_PUNCH_HOLE, a new memfd seal that prev=
ents
> >>>> holes from being punched into a shmem or hugetlbfs memfd while leavi=
ng
> >>>> the file fully writable.
> >>>>
> >>>> Background
> >>>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >>>>
> >>>> Drivers such as udmabuf and iommufd (via IOMMU_IOAS_MAP_FILE) use
> >>>> memfd_pin_folios() to pin the folios backing a memfd and hand them t=
o a
> >>>> device for DMA. Pinning keeps those folios allocated, but it does no=
t
> >>>> keep them in the file. If userspace later calls
> >>>> fallocate(FALLOC_FL_PUNCH_HOLE) or madvise(MADV_REMOVE) on the range=
,
> >>>> the folios are dropped from the page cache while the device continue=
s
> >>>> to use them. The pin holder is never notified, and from that point o=
n
> >>>> the device and the file silently diverge.
> >>>
> >>> We have the exact same situation when userspace maps anonymous folios=
 into vfio
> >>> and then desides to MADV_DONTNEED the pages. Or any other memory back=
end that is
> >>> used for such purposes.
> >>>
> >>> User space must not zap/punch things that might be pinned elsewhere.
> >>>
> >>> That's not specific to memfd, udmabuf, iommufd or anything else.
> >>>
> >>> I don't see a reason to make userspace (that should not shoot itself =
into the
> >>> foot) a kernel feature it must activate itself to not shoot itself in=
to the foot.
>
> Agreed, for normal use this is userspace's problem. The seal was meant
> for the kernel to cheaply verify at preserve time that nothing was
> punched.
>
> >>
> >> The issue is live update doesn't preserve those background punched
> >> folios and now we have created an UAF attack on the kernel across
> >> kexec if you don't do something about it.
> >>
> >> There was some notion here that with the right sealing flags we could
> >> tell if everything was 'live update compatible' and then know that
> >> these attacks are impossible.
> >Just remember that there was any hole punch and refuse to live update th=
is instance.
> >
> >We could likely implement "we saw hole punch on a pinned folio" as well,=
 but I
> >don't think that's required initially.
>
> If I understand correctly, you mean recording on the memfd that a hole
> punch happened, and refusing the live update if it did? That would work
> and is much cheaper than what we do today, where iommufd walks all the
> mapped pages at preserve time. For truncate, the existing F_SEAL_SHRINK
> is enough or I can record that also on the memfd. I will send patches
> for this.

This entire situation continues to give me the willies.  After much
prodding and contemplating (in my own brain), I got a friendly LLM to
report:

--- begin AI output ---

IOMMU_IOAS_MAP_FILE uses memfd_pin_folios(). Collapse [MADV_COLLAPSE
or khugepaged] checks the old folio=E2=80=99s reference count, so a pin
acquired before that check makes collapse fail.

  The problematic interleaving is:

  1. collapse_file() locks and unmaps the old folio, then passes its
reference-count check (mm/khugepaged.c:2446).
  2. memfd_pin_folios() (mm/gup.c:3483) obtains the old folio from the
file=E2=80=99s XArray and pins it, without taking the folio lock.
  3. Collapse copies the contents and replaces the old cache entries
with the new huge folio. It does not repeat the reference check or
freeze the old count.
  4. IOAS retains the old physical pages; accesses through the file
use the new folio.

--- end AI output ---

Is this correct?  I haven't personally verified it.  But this whole
pinning-folios-doesn't-keep-them-in-the-mapping situation seems
*extremely* fragile.

--Andy

>
> >
> >No need for more shaky seals.
> >
> >--
> >Cheers,
> >
> >David
>
> Thanks for the feedback,
> Sami
>


--=20
Andy Lutomirski
AMA Capital Management, LLC

