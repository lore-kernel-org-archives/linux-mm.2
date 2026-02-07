Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 271B0EE0AEC
	for <linux-mm@archiver.kernel.org>; Sat,  7 Feb 2026 22:02:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 197716B008A; Sat,  7 Feb 2026 17:02:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1453D6B0092; Sat,  7 Feb 2026 17:02:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 026806B0093; Sat,  7 Feb 2026 17:02:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E3B706B008A
	for <linux-mm@kvack.org>; Sat,  7 Feb 2026 17:02:05 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5B25D8BCE7
	for <linux-mm@kvack.org>; Sat,  7 Feb 2026 22:02:05 +0000 (UTC)
X-FDA: 84419034210.12.4019A0E
Received: from mail-qv1-f53.google.com (mail-qv1-f53.google.com [209.85.219.53])
	by imf02.hostedemail.com (Postfix) with ESMTP id 62C3280006
	for <linux-mm@kvack.org>; Sat,  7 Feb 2026 22:02:03 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=KN8c7I+M;
	spf=pass (imf02.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.219.53 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770501723;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=72LaZEhlR4SFYDd0BQ4rSPmROS1Q3FyBK2RxIdthUfk=;
	b=F7U1FoGturrfa+VjIolOpHITiIC2QRs+fkcQGpqc6Z/hN2PSOncO4tA15yXUjw/JSUB7MR
	ieQ2Om/WJ25fnOUVV0m31Gna9m2j0Qc6HO/2VRgaGarhuxp5sXnP/iaj6smUxOOhVvmetL
	7fDIuDNtAB0MntWxp5Py1c+9bAS5QBU=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=KN8c7I+M;
	spf=pass (imf02.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.219.53 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770501723; a=rsa-sha256;
	cv=pass;
	b=cGpqUqBtUkonOEkzL7fTyDB8r5czFxRZkPn+zteJQq6SXXY2rNXZ1zGnj3LoyGT8VmhF3U
	yikOrd+E6m8SE5HcTiKoBd9KpBVVRyxPRB5jQyA6Sn7I9SZsXgxrjVkqHMI1XEHmxCHqpz
	gbsVLeOoPMb6sKvyyVvqvQm0bsoN6R8=
Received: by mail-qv1-f53.google.com with SMTP id 6a1803df08f44-8954c9daaeaso9577226d6.1
        for <linux-mm@kvack.org>; Sat, 07 Feb 2026 14:02:03 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770501722; cv=none;
        d=google.com; s=arc-20240605;
        b=SDyz93FphFUFbE0IwjRuVNXHGCo6mqCVhbKp3ZtHXBwqr5ICWLt3ka8BCHQG8y0qbL
         SL+kKtdCC+d8ae5a9EhhusciQOYEEBcJ3l1YdE49vJv26djibA12MXdbmzAEWb7IUhJs
         r5oyfWetoMVDHICV9QuDcBg1nck7ybR2sY3qKN4HgW+1SvDbgYGxnSmu5td9TL60RG2W
         r3I0sfdp7HefyH2hpfe7Y4zF4iAVpTrw1yRdhPjPNXIUbxcpn++uxSNGkes0oCAOICb8
         5HQRnp5OYiqodjRVzE0XId4S09oxo1F87+s2FmiZEg5m7sd2LnxaX5ZOwG/oHMeNhlr/
         DSAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=72LaZEhlR4SFYDd0BQ4rSPmROS1Q3FyBK2RxIdthUfk=;
        fh=TxpVYlme5zIlhJL5L6puXvvq7/PygdOQ9EoMBWkrN2Q=;
        b=bVhvotjQ4sf8vXudqHaVFEG4PFM7LFHMnvJkOlG9mEuY/i6X7DFK4PhuIV1I+uGMa4
         aiVEplYdH7iPoHKsnHOgxcZb/3zjr3FQ0pSA8lFQP/Lju8yknHiS0Og3Rg65iD+1R+zl
         npsSjCZ4E3tMPI0vSwunRICXUG3o8zq8yxP9bsc2Y9EvmJ9Ponpm3/Nls2S4VOA4FAsx
         js9a6LNYkXww06Snm1AHf2dDLTsPssRUM6uovvQgMqFkS+Pm3e2MNWDSW8MDilnEhYjz
         XpPmU4LE/bbnLdWygAt1emsujM/cMkqIRODufnv/+fuQHVZeBQ/tKa19wqanpTaKu5ob
         lY1g==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770501722; x=1771106522; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=72LaZEhlR4SFYDd0BQ4rSPmROS1Q3FyBK2RxIdthUfk=;
        b=KN8c7I+Mxo1C1FcgDU2h4lQHXdszBJfnc2e766SompvDcvP+mA1a9FjOcNb5nsSO4I
         sK6x7HnsJsuln3U4XEszVCrmQqh5xxmGcBiToIn9CBBs1GcQ1Xvh/OXQ3TTgmyAwz0VX
         epp4cxnUJzbkYm/L4szG7B8MoNGqPBxVG1+4cnSw17nO5taIevS5Z+Zxw+HxhlZXDRNS
         Exlvj5l1JPdGxpZ01V3YcMuxNoOOOzHBnNJ6kH2Jd2wlv/Bryf2MXfRjUfY+h94GT90s
         wt6xktyhTIYXuEVsOOq4SxroDWv4x/TCVu6sx9PMF6qxJuBbjEvn1NUNhlcj1Iv0gdIW
         8S8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770501722; x=1771106522;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=72LaZEhlR4SFYDd0BQ4rSPmROS1Q3FyBK2RxIdthUfk=;
        b=m5QZFEWGt6LMxedIgwUSrSFDSzJVeOXkcP71Zh+/47G2RyqoAmjvPH3vZlXKkvROso
         72Pz1epqddo0xqt1aHIzuw/TyNY2ckh2DpC4tzpm/gKM7EekaHBJDnjrG3uFZ4ljwfUk
         nj8Njdg0hxhQOJ7i9j42CLgST6TI+39nWvQUMj04sjEgVtvfZPBshPRWJqaPEqbS3kdf
         Oy4YHWZkcQ41gUTcrXcDleDQ+O/eDsIGVdGKtFiXA9Ov/JONOjNqkhtTja1bOsf30UMO
         8neBUEr1fFFFqGgBHUnBteeXkrTD8WtaZp9kG9PhsM3Z05B20V3WiJZw3qQbLFpQG0IK
         AQ/w==
X-Forwarded-Encrypted: i=1; AJvYcCWd0T3yNNy6FBmOjAUhmiIKFucXAsT7zRJVZHciLezoFTNdMezav5l4njtXvelnPYKuyAAFnOdi+g==@kvack.org
X-Gm-Message-State: AOJu0Yy6dlrCRLITxiUmbkuabEnkgcdLG2aEmCSCGVc+0Y1FB3K+PEwX
	ey+pxQPFDdkbMg7wJSA2rag8tDyG6t80tLNGJI/0I0fU/qPNx0GVfdKjJqb5/3XZMHTksNFqvwu
	9JqnBx4Q+QokjTgLyvl9Iy9i9Bsi5gws=
X-Gm-Gg: AZuq6aLRa85r+BLNydazFGSM6omjcFGlbUYepqy+n4BIXi5Wy1Gs1QOWSxbzWORLFvl
	mpFVGIYtDlB2c5JBOXAJVpcYy4GD43VD+/LiQZwiZgu4tDyXaAO+HCWBFJgjK2Dn+7tcnnwBx2V
	SjVeL1sARxhGwAoq6cVGEJlNgVEJdh6mZZeKPDwV0wEwcZfXX+n5cPyrkVnW479cuaRH7n6Zp8L
	l7mh7Ayr1v5g+g9tol32Ux8bCPy5RMGSLSqKQ7kA+Ba8hHeyrFyG2Vjy9aC12/cJJoFfw==
X-Received: by 2002:ad4:5bef:0:b0:894:6ec3:b6fd with SMTP id
 6a1803df08f44-8953c8644c2mr107031546d6.31.1770501722238; Sat, 07 Feb 2026
 14:02:02 -0800 (PST)
MIME-Version: 1.0
References: <20260207081613.588598-1-vernon2gm@gmail.com> <20260207081613.588598-5-vernon2gm@gmail.com>
 <CAGsJ_4zxAmDS+FWzfX-670W3H3LM=nUZ-gGe3jMV9tYM0E_EaA@mail.gmail.com>
 <e106bb45-5563-4b9b-bcb5-defd6e204c79@linux.dev> <c1280171-b9e7-4f10-adb5-b6a8ed69e54b@kernel.org>
In-Reply-To: <c1280171-b9e7-4f10-adb5-b6a8ed69e54b@kernel.org>
From: Barry Song <21cnbao@gmail.com>
Date: Sun, 8 Feb 2026 06:01:51 +0800
X-Gm-Features: AZwV_QgPce1bCUEHns3zUuQ8364wtuGBGeBXMcxP3ODXddmta6QshNmytg7Voss
Message-ID: <CAGsJ_4yEfgipUe37_k5rArrYMPY_31JUKQGjRk+NNJTK9QhBWQ@mail.gmail.com>
Subject: Re: [PATCH mm-new v7 4/5] mm: khugepaged: skip lazy-free folios
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>, Vernon Yang <vernon2gm@gmail.com>, akpm@linux-foundation.org, 
	lorenzo.stoakes@oracle.com, ziy@nvidia.com, dev.jain@arm.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Vernon Yang <yanglincheng@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 62C3280006
X-Stat-Signature: cioqoo3x9b3x17be6xkttagaway85619
X-Rspam-User: 
X-HE-Tag: 1770501723-831712
X-HE-Meta: U2FsdGVkX194zVnDFaZUZ9p6l+bjrQHQIk4k2/UCe9BWQQ914RqYe2XreNrerS85c+rUCQWx/BdSvOw3S2/obg2b0NYZjSc5jj/co7EdZI9eXrmUDbW+dLjAgNofAdSdDWRIWe4cmRqz1RcY3Ob9uwZhk2Dt7UevPs9DFayw/QrvmSZ83GUuGtb+WDqKnQn4z0W3GzmGjRaL5pkxqO4g4N2PPqcqs35mH5fNODrPOQXGeuwpPWD6MEuvwTvVlq97BpXhCAvJVfBAV0rEcbrI6PyxICEB+WqiNKgptnY/QGxSg1YG99dpu/EzuhGMDDydT4EBTbpH+THuIhjqR3I9CyfHVx/W17N4M54KUCZhN9Ny5f7eN4i70MD6SDKShBwDc7Eg0DzxSfh2jchWD1ztF+Y5lL9lz2ljLfA2VvcqDsppLJ1uQZOyqkEuqB3d5mDtc/NWG88ZgCJFPSp6Tzx58xEAb4nei86V8Ie4r6aAzSTZtalsGBLMIiGDlasHNbghzPG0mT6iSi/+M6zQ485Vbv/HgYnpJc9pR3SQak91M4Hfjtp7Z6PYDVOBiQl53/tkDq/PDnDtiZmF2NR+5b87QN5Ob0y9XSYpR0cGZgM4db2SgR4DQLvSQZcIiaGkI/1iSD8eVhvohRT5E5Wiq492sgvoVnhU2kDBubRQOKg8IDmvb5d3dvtMBaCaH9lVj9gFrGLWKcTZNIcK2stvOjAisD7yrSc/N1FAMFhyNSKT0eIfFyIaCmVoe0NxwipIcEFcm+yzIx9HNhUH+TFmDn+AGy4cJAVKCF0g8E5eE250wVvYNzCujnGDZrkxqlM9cHU13xlYyilwnBpkqllEBFV4Ev+pbHl0U68Gtae7LBFdrfuAOV5lPlRYT9Bpiv0VcW3IQJV44cSmTA8pofogSo7UIAaaT5Di/Xwo8Ycr+LbFqj05UICS/85gTDNQY9mH9IlXazbZel+GefuCTgKO5ji
 qucZ6oP7
 4aDaM8FZf4Oegbn7vfTvXnVSNGOk4fj6W9d05pPmg7O7lplAUNT5nw6B8c68NN8A6Zk+I0p2YU9wRKFgrit1pjurWZq8PAqpODD5eYyjAssOAmYf1Pq4NCOjVzflARw4HLLfnnaDyRbY95yKanmeFoIk/Son1BzUKLRUe83DGWi6GDq33X5D6ByRvLPeB7i8QOpGi28mORWxKbZ+yg1bZ4JCvxFGhAW7Ie1njT3c4WKJE8A1nki8IkmjRYJP6E80qf8LUGAKc1/OTk7C+XeZwlSaNG1prm+1dh0oDb4/fxJhW2hTPHjxQEG4Hvt1XKPUaCCxGrBAPqqKAzRNYF9zb5imbHlvQxei8wVWEs0BS01fhDwIm4cdA1ZsNWToZEsCakfgaaH152xIxOP72I8PLFgK3Y0HvJ+0KQJHYWOpJJN4Xi4GD7an3qyHwzhdMwQEnTQib
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Feb 8, 2026 at 5:38=E2=80=AFAM David Hildenbrand (Arm) <david@kerne=
l.org> wrote:
>
> On 2/7/26 14:51, Lance Yang wrote:
> >
> >
> > On 2026/2/7 16:34, Barry Song wrote:
> >> On Sat, Feb 7, 2026 at 4:16=E2=80=AFPM Vernon Yang <vernon2gm@gmail.co=
m> wrote:
> >>>
> >>> From: Vernon Yang <yanglincheng@kylinos.cn>
> >>>
> >>> For example, create three task: hot1 -> cold -> hot2. After all three
> >>> task are created, each allocate memory 128MB. the hot1/hot2 task
> >>> continuously access 128 MB memory, while the cold task only accesses
> >>> its memory briefly and then call madvise(MADV_FREE). However, khugepa=
ged
> >>> still prioritizes scanning the cold task and only scans the hot2 task
> >>> after completing the scan of the cold task.
> >>>
> >>> And if we collapse with a lazyfree page, that content will never be n=
one
> >>> and the deferred shrinker cannot reclaim them.
> >>>
> >>> So if the user has explicitly informed us via MADV_FREE that this mem=
ory
> >>> will be freed, it is appropriate for khugepaged to skip it only, ther=
eby
> >>> avoiding unnecessary scan and collapse operations to reducing CPU
> >>> wastage.
> >>>
> >>> Here are the performance test results:
> >>> (Throughput bigger is better, other smaller is better)
> >>>
> >>> Testing on x86_64 machine:
> >>>
> >>> | task hot2           | without patch | with patch    |  delta  |
> >>> |---------------------|---------------|---------------|---------|
> >>> | total accesses time |  3.14 sec     |  2.93 sec     | -6.69%  |
> >>> | cycles per access   |  4.96         |  2.21         | -55.44% |
> >>> | Throughput          |  104.38 M/sec |  111.89 M/sec | +7.19%  |
> >>> | dTLB-load-misses    |  284814532    |  69597236     | -75.56% |
> >>>
> >>> Testing on qemu-system-x86_64 -enable-kvm:
> >>>
> >>> | task hot2           | without patch | with patch    |  delta  |
> >>> |---------------------|---------------|---------------|---------|
> >>> | total accesses time |  3.35 sec     |  2.96 sec     | -11.64% |
> >>> | cycles per access   |  7.29         |  2.07         | -71.60% |
> >>> | Throughput          |  97.67 M/sec  |  110.77 M/sec | +13.41% |
> >>> | dTLB-load-misses    |  241600871    |  3216108      | -98.67% |
> >>>
> >>> Signed-off-by: Vernon Yang <yanglincheng@kylinos.cn>
> >>> Acked-by: David Hildenbrand (arm) <david@kernel.org>
> >>> Reviewed-by: Lance Yang <lance.yang@linux.dev>
> >>> ---
> >>>   include/trace/events/huge_memory.h |  1 +
> >>>   mm/khugepaged.c                    | 13 +++++++++++++
> >>>   2 files changed, 14 insertions(+)
> >>>
> >>> diff --git a/include/trace/events/huge_memory.h b/include/trace/
> >>> events/huge_memory.h
> >>> index 384e29f6bef0..bcdc57eea270 100644
> >>> --- a/include/trace/events/huge_memory.h
> >>> +++ b/include/trace/events/huge_memory.h
> >>> @@ -25,6 +25,7 @@
> >>>          EM( SCAN_PAGE_LRU,
> >>> "page_not_in_lru")              \
> >>>          EM( SCAN_PAGE_LOCK,
> >>> "page_locked")                  \
> >>>          EM( SCAN_PAGE_ANON,
> >>> "page_not_anon")                \
> >>> +       EM( SCAN_PAGE_LAZYFREE,
> >>> "page_lazyfree")                \
> >>>          EM( SCAN_PAGE_COMPOUND,
> >>> "page_compound")                \
> >>>          EM( SCAN_ANY_PROCESS,
> >>> "no_process_for_page")          \
> >>>          EM( SCAN_VMA_NULL,
> >>> "vma_null")                     \
> >>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> >>> index 8b68ae3bc2c5..0d160e612e16 100644
> >>> --- a/mm/khugepaged.c
> >>> +++ b/mm/khugepaged.c
> >>> @@ -46,6 +46,7 @@ enum scan_result {
> >>>          SCAN_PAGE_LRU,
> >>>          SCAN_PAGE_LOCK,
> >>>          SCAN_PAGE_ANON,
> >>> +       SCAN_PAGE_LAZYFREE,
> >>>          SCAN_PAGE_COMPOUND,
> >>>          SCAN_ANY_PROCESS,
> >>>          SCAN_VMA_NULL,
> >>> @@ -583,6 +584,12 @@ static enum scan_result
> >>> __collapse_huge_page_isolate(struct vm_area_struct *vma,
> >>>                  folio =3D page_folio(page);
> >>>                  VM_BUG_ON_FOLIO(!folio_test_anon(folio), folio);
> >>>
> >>> +               if (cc->is_khugepaged && !pte_dirty(pteval) &&
> >>> +                   folio_test_lazyfree(folio)) {
> >>
> >> We have two corner cases here:
> >
> > Good catch!
> >
> >>
> >> 1. Even if a lazyfree folio is dirty, if the VMA has the VM_DROPPABLE
> >> flag,
> >> a lazyfree folio may still be dropped, even when its PTE is dirty.
>
> Good point!
>
> >
> > Right. When the VMA has VM_DROPPABLE, we would drop the lazyfree folio
> > regardless of whether it (or the PTE) is dirty in try_to_unmap_one().
> >
> > So, IMHO, we could go with:
> >
> > cc->is_khugepaged && folio_test_lazyfree(folio) &&
> >      (!pte_dirty(pteval) || (vma->vm_flags & VM_DROPPABLE))
>
> Hm. In a VM_DROPPABLE mapping all folios should be marked as lazy-free
> (see folio_add_new_anon_rmap()).
>
> The new (collapse) folio will also be marked lazy (due to
> folio_add_new_anon_rmap()) free and can just get dropped any time.
>
> So likely we should just not skip collapse for lazyfree folios in
> VM_DROPPABLE mappings?

Maybe change =E2=80=9Cjust not skip=E2=80=9D to =E2=80=9Cjust skip=E2=80=9D=
?

If the goal is to avoid the collapse overhead for folios that are
about to be dropped, we might consider skipping collapse for the
entire VMA=EF=BC=9F

>
> if (cc->is_khugepaged && !(vma->vm_flags & VM_DROPPABLE) &&
>      folio_test_lazyfree(folio) && !pte_dirty(pteval)) {
>         ...
> }

Thanks
Barry

