Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B9549606A33E
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 03:20:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=DzkD/9kn
Received: by kanga.kvack.org (Postfix)
	id BB8B06B05BA; Sun,  8 Nov 2026 22:20:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B42C86B05BB; Sun,  8 Nov 2026 22:20:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9E30D6B05BC; Sun,  8 Nov 2026 22:20:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 677DB6B05BA
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 22:20:46 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id ECD371C3CA3
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 03:20:45 +0000 (UTC)
X-FDA: 85414128450.29.4AF2933
Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	by imf01.hostedemail.com (Postfix) with ESMTP id 052E240004
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 03:20:43 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="DzkD/9kn";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf01.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.44 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794194444;
	b=vqKohtNq/xAXlQF0f86605iwxku5b3zVjazV8pJlHa17St0G8y4eh48f+9J8f3faqe5Nqi
	ihyVcfbkGI8a9amlLfWPXL75cFQbL3w2fsrcs28Sn+W+aD0VevAMgz47LBZ+c0ukVIbR7P
	2u2A1S4lV5w+e9fWxt+P/oTjFghmLU0=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794194444;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sE/fNcXhZCFYoGckzt8mvo4VUCyVdxTAKOyI+l9fVSA=;
	b=RY1WNszBIkVA4BCZyXv04vqL3yFpk/QmAd4FVCSVTj/uKa7vQrPqmlIlBKHzMQEz49JxCu
	Vbke7v1NuQc1F4+oNf9MKjdSG7zrvuEbGQ8ED2Bakh5lii0IfsIyNIydxecg/HvvOz7GYz
	NICKysRqOBStqTWca3AJN7ndtO4in8I=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="DzkD/9kn";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf01.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.44 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-c4d5b2db4bbso74540366b.0
        for <linux-mm@kvack.org>; Sun, 08 Nov 2026 19:20:43 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794194442; cv=none;
        d=google.com; s=arc-20260327;
        b=Y3WqtYPVTiZ8qCYzcISxP6D+2bLREOwMsIlF49lRLPndmF/CxKt+0Mm+fejO20QJRU
         50VUJhnWyTyQ2Fwjyc70wEFT0Bft552hJSjUt+Fyp4CsBrvp3A0aEbfxmAJVmsnWQyCp
         /t05HYVWbdi7teV8S6K7jaRxKbheHQHJ4u2ELdmFRPDWV/GrbUTmFL8eH4rKOhFD0NcW
         3Ftq1xvIefGXCM47trE9MwCF7IrNEk3VdQef4z0chC8GXlFvfDdcs6DcoQNpRDVBIP+W
         fVxsnV7ioHnv7k9JurAVkhUONRZbL8nuD1VklodINMl5SvRVGJR+SkWdRtmSONpdTwbK
         /hoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=sE/fNcXhZCFYoGckzt8mvo4VUCyVdxTAKOyI+l9fVSA=;
        fh=BRswjrorPDJe59NAr7GLmCZa8wmOFuh7SgJhqrtZ+lE=;
        b=k3hqJC2hxv47/+GzrhWbxhTC3i6PpFBJPVxZe98a6xOR85GXKWH+7opM2lOHcBbtFj
         EWZyviuVOuOJQA/XeQBB8Lny7bveu04AU+FqARMLNYnbF55IBO46GueAyerak7Ma+E9v
         eHBj1TqaEHgCd2f1CVUDX+syFCO0ZTkD01CrIGhjCcg3EVzDOf3PA13KmiBLA+rFhDg2
         31hlPj9Ofnxn43FR8ntxtWSzkDkjv5AU4ERu9NI0VPbVDeCUPfPPxAwmpDtnb7wi7GaD
         PL3yroj6Mt1BmIp3nDTbODLes+q8ESBL/V1LeNs2ccMGjChUi+Gjo1P/rYlucYhfcSIB
         Oifg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794194442; x=1794799242; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=sE/fNcXhZCFYoGckzt8mvo4VUCyVdxTAKOyI+l9fVSA=;
        b=DzkD/9knQcFStdkl+gLfQNP4Xn1GcIghmxa3uQRW8SrNqeauqvERe1yzL3aCcj2HMm
         3qV9J53QPWuBoDWf/QC8+Q0Y34z4yvUpJL6kQWDuJ6H4g5vVrEZ0Shxr0JrjGY17E0pQ
         PJ48Q8Zez8vjWPg+356qLWhQJrxFzKzxDO2a8FGxuUFJ3DBpnEJXTqgNceqzab1ddL5M
         QqplrJ5OgX5GhijdtpGheAGGHcdSukLi1awZyyDKGwSpY/TlrN761Gxl/hAvbp7uflD0
         FOS8xO0juyeUNRBa/jNQNGKlZOTrN/Smz6eLf01smnsFQ/hEp8afzYPPloHUIO5zQgwO
         j6+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794194442; x=1794799242;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=sE/fNcXhZCFYoGckzt8mvo4VUCyVdxTAKOyI+l9fVSA=;
        b=eM7Yzw0WvBHNnT3zh7mGPw2UIIcNoLvgjDNviXmF3AM0kMudm4THsFdFc98K+aI19r
         c1m6rk58AgKzOUQQU84skIXtw0GEFVysaOAnoN/X/YPAaLUT1Fzxv4lOwtBKmkeVhGsv
         k+mT5yBDe/8rc2anjrwByOGDItSUJ5wAXGhqkcj1UnNiAhlTjxJqPl22QWtfwqXB49bv
         PaQjPrPLbyUjt8IrZS0Z3Yafn/77b3W1QLPXvj2eMYeEL3HsOttBVd1SWW6j47ekoLGr
         9Fh93NSGpz1fzaEr7wfBvfVORdf1CWbKpvmq2seMox4LIurUCqvE+NWCeY/4yHZ9FHTh
         8uZw==
X-Gm-Message-State: APuU4Z+xxnkTHN2a0J7S20l/RdSJugCbHnKEL1ML2OzuXNnBpVsITfef
	fELM3GNiQBLC3kXYxFxmzlA1rRMl38x7PdR+wTXDV+tglacL0TN8PZsfVHTpV0j34t7b/v6jLPp
	YUhl2iZwF0LbVxcqle28J2nrQbxuzHV4=
X-Gm-Gg: AYBFou1ktimMpUCSavMuV6oj4Xbpdrz89OZyYSre9P/81S2SxkEEl+74UZF0+QKRbip
	xr4YNZOcG7+BfsIhEkpSA5guVhAU7kCDtbsMYWVaq/Idq6Elp61WZYj2iKZCe0Qlcqc/nemGaya
	S+IDF3YouimFpZi/kb9y7DZ6ALJBW9OAV3hUl55gW5hOrm5MsKnwn7jBpBUKbyNyV+eY4Xp0SWX
	HetWogD5Kn7pv3XIZ5hk6VDZvQCqrJqqfZq4rp/mH09XMUcbfj48gTme57sfryec4FdE3zEBOnu
	PGSZtqEGXPr2nHUSp7HVMGMuYdP6l2+h5dDktgYM6uR/YTLCBPRb4v8AO/O8+/Ldld6S881ksRw
	vH/jjeXqE/TPkc+03hsUHEIgCV7XsDcR/u6rL0Lra52zTULDhycYqEizKftxFd84ZTAhH
X-Received: by 2002:a17:907:94c9:b0:c26:1cfd:4244 with SMTP id
 a640c23a62f3a-c4d525794f8mr366547266b.11.1794194442101; Sun, 08 Nov 2026
 19:20:42 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261016-mglru-fg-v4-0-2106750c0bfa@tencent.com>
 <20261016-mglru-fg-v4-12-2106750c0bfa@tencent.com> <CAGsJ_4y-7R07wFJTY2a8tMQ1xvG2kjuG0Q1rLjx8DOg4u3UwZA@mail.gmail.com>
In-Reply-To: <CAGsJ_4y-7R07wFJTY2a8tMQ1xvG2kjuG0Q1rLjx8DOg4u3UwZA@mail.gmail.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Mon, 9 Nov 2026 11:20:04 +0800
X-Gm-Features: AclHuK8iUb9Dq3WsbSIlLK65gh2Lc8G5m0UCp-qFnn41-FIR3YsEFvqlSwVsNTk
Message-ID: <CAMgjq7Cj3dvJf8JCkLacGP0=2bPv6WR1sjOD4Ese7XeGP5VhAA@mail.gmail.com>
Subject: Re: [PATCH v4 12/17] mm/huge_memory: mark folio as accessed more
 accurately on split
To: Barry Song <baohua@kernel.org>
Cc: linux-mm@kvack.org, "Liam R. Howlett" <liam@infradead.org>, SJ Park <sj@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Muchun Song <muchun.song@linux.dev>, Qi Zheng <qi.zheng@linux.dev>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Chris Li <chrisl@kernel.org>, 
	Baoquan He <baoquan.he@linux.dev>, Nico Pache <nico.pache@linux.dev>, 
	Usama Arif <usama.arif@linux.dev>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Youngjun Park <youngjun.park@lge.com>, Zi Yan <ziy@nvidia.com>, 
	Gregory Price <gourry@gourry.net>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Ryan Roberts <ryan.roberts@arm.com>, 
	Dev Jain <dev.jain@arm.com>, Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>, 
	David Rientjes <rientjes@google.com>, Yu Zhao <yuzhao@google.com>, 
	Vernon Yang <vernon2gm@gmail.com>, Zicheng Wang <wangzicheng@honor.com>, 
	Chen Ridong <chenridong@xiaomi.com>, Tal Zussman <tz2294@columbia.edu>, 
	Xiang Liu <liuxiang.277@bytedance.com>, Ehab Ababneh <ehab.ababneh@intel.com>, 
	zhaozhengzhuo <zhaozhengzhuo@uniontech.com>, Lian Wang <lianux.mm@gmail.com>, 
	Kunwu Chan <kunwu.chan@gmail.com>, linux-kernel@vger.kernel.org, 
	cgroups@vger.kernel.org, damon@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 052E240004
X-Rspamd-Server: rspam12
X-Stat-Signature: 3cyb5juntxx3ykzhm51qurnrntfb78t4
X-Rspam-User:
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1794194443-475222
X-HE-Meta: U2FsdGVkX1/icixDwamu0w/6VA0uzShoXzMEEEQwFJy7mATz/8ocy+jM+I/Gzly3gcaPzmGyHuP3xxmccKfqOdpVfj3gWSkBL2hJvWJQTXR7xMl7AExr/CF3Sc7OJB80QgklWtnspwuBmNBYk+TxA6Sf2F/YKTJrJf+Tx0W7uMOYzrCRY9cnvmgGmZdp9hh/VL6vfJJ29fyyPyRogiIv/l2S95md1DBfchgW6zGtmUwNwgd0ZO54EeSywZ9eOzr/0prS5aYOj9JhHNdZFZDMjN86dlsm4Gtv5eHODBzrDVnKL8Xqlf1l1L9+lXju+C+6niHDXHFS2SbHT6y4FD7nCTl3kSWgrCamSHRH2Hvl+n5eBa99NkpzE2xEmcjSK2iUA5919AbWFAm6pPczFgt3wfPq88W9F5vHvnZ5GB3ly2QX71dU7eBixW9T/XT3J1br7tsPC5Fm72e48ndsJPwObHAkg/L6bMf5YyDKjaIEsdOxYNpY28JQf3Ma47pcAfvlbku27kPZFkK7TjVmUHgizZE5NHgDUuobl315F/mlmKSkqCkNd3vHVp0RiGz2BzMwztdLvDwuIknu+M3OXg2AxmAyJ9g97/82YPhN9TK5B6suT2/Pdti2AQknopoeR4TtslHm0/xtuNP6tQ6V0ohOUg4vYQuM7/0lfCDQ0CDcml+Bgckl80oIs7vNnatfcRzjoE4PUCfsdMNJBXy62X0OIUj5jQxAZb4xri/LMhxLqHBJMO2VnE2w2Lp01/GiZYIev1pbj+rfN/qdq/5kYOEswPWhWhzIrT1YvDPlpk/sGK9xYpAdqpbi7zxTMQwu0HjpvHg7x/Ic5JivJqr0gzbLlHAm07IBEKqbM+82+unA1r0J07bqDhVKd9rEjj9X8i6xWaC6yD/B310YOr3aKEwfVpIpp1xgG2bftYWHgsAq2K60E7otsvlW/aEcKj+S0er6xXo0YFG2ysotHEtdHHA
 /qRRHfyc
 OrpUKnbB5pYITN6hbbREdIMAxby/21gTLHTd7ThwSlWIOK3lVcaHeqs2v1DlA8eYDXYN+yXvXzwvy1AThJK+MZajgkq0+bJNoejvda3hzmCrQH1zFK4Zc2gWOLl7ApY53+JEZvuLwlzmdCRvnArzLS5697VIKkbOANBnvitPobT0zvnsbUn68GzDEfUK2bLQcCMGdRJBTZz62OefOYA6QUUoQI++XyU3MhoBPsL2TO+pThNw5+ubJGz4rsJpu2gucnxQySavC05pfhkOKqTjR/+VQJH/7N+xyPh2OY1ItmdCHXMcZu/Mhf5qeCHmDJ1je79nEMQ+2Kx+nqpY9PQseLudjuBn6WQFTVFKqZqGEpRGR263nw+HgN7ak7iVGgXMsnMe+7jTfYyCIH+Rrq8ciWU6WwaQ3bTMD8RyLwzvQtjmJ6otZm5YYNkvrLRGata5iufjMsjlE9zreSJDJ9ngovqAG3sZxfLMPL3ueCS2+Ke3hSSurQWuYUkDspVa/Oqhn14MH8U6WwRLpuxk7sm34d0TZ59SAvEicSVuSwyWC5ctGPTFkeVPNc4k2fluX9zcQsycwtefcT/nv46BQBAweeU9E3968H+eKVRaoTfOr7JizYfz5xILTcByBhXGQe40gFL07MHmPHhuNmZhx/lBoaF0+Xq2N5dEpXZHKAdhTKhmhDkBUafcQoeejZUyVRTRwX4Ykcs2yLe6cGUA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 9, 2026 at 6:15=E2=80=AFAM Barry Song <baohua@kernel.org> wrote=
:
>
> On Fri, Oct 16, 2026 at 2:16=E2=80=AFAM Kairui Song via B4 Relay
> <devnull+kasong.tencent.com@kernel.org> wrote:
> >
> > From: Kairui Song <kasong@tencent.com>
> >
> > The behavior of updating the folio's access info isn't consistent for
> > huge mapping splitting or ordinary unmapping. The page table's young
> > flag has to be translated into folio's access info.
> >
> > Right now it only check and set folio's referenced flag, which isn't
> > enough since folio flags update on access have its rules. Ordinary
> > unmapping (zapping) calls folio_mark_accessed(), and it also checks
> > if the VMA has recency to avoid false updates.
>
> This might be a bit off-topic, but I once proposed
> recency fading for the zapping case in Android workloads:
>
> https://lore.kernel.org/linux-mm/20250514070820.51793-1-21cnbao@gmail.com=
/
>
> folio_mark_accessed() might not be ideal for Android
> apps that are being killed, as we expect them to be
> relaunched only after a long period of time.
>
> But for the splitting case, I guess there is no doubt
> that the accessed state should be set.

Hi Barry,

Thanks for the review.

I agree with these points. BTW that recency fading patch seems
interesting too, but perhaps we need something stronger than
folio_maybe_mapped_shared, maybe folio_maybe_shared, and do that when
"current's cgroup matches the folio's cgroup and have a ref count ~=3D
1"?

> > @@ -3216,8 +3216,8 @@ static void __split_huge_pmd_locked(struct vm_are=
a_struct *vma, pmd_t *pmd,
> >                         folio =3D page_folio(page);
> >                         if (!folio_test_dirty(folio) && pmd_dirty(old_p=
md))
> >                                 folio_mark_dirty(folio);
> > -                       if (!folio_test_referenced(folio) && pmd_young(=
old_pmd))
> > -                               folio_set_referenced(folio);
> > +                       if (pmd_young(old_pmd) && vma_has_recency(vma))
> > +                               folio_mark_accessed(folio);
>
> We now have two inc_refs paths:
>
> - folio_inc_lru_refs_walk() for mapped folios;
> - folio_inc_lru_refs() for syscall accesses, or possibly
>   mapped folios with the appropriate flags such as
>   LRU_REF_MAPPED, LRU_REF_EXEC, LRU_REF_FORCE, etc.
>
> The interface is:
>
> void folio_inc_lru_refs(struct folio *folio, unsigned int flags);
>
> Here we call folio_mark_accessed(folio), which is the
> syscall path with flags =3D 0:
>
> folio_inc_lru_refs(folio, 0);
>
> Are we somehow applying the syscall access policy to
> folios accessed through the page table?

Right at this point I'm just trying to stick with the current upstream
behavior, and not promote these folios aggressively. The results are
looking OK for end to end benchmarks so far, maybe they can be tweaked
further like a LRU_REF_MEAN so it won't promote them, just inc the
ref, I didn't find any oberable differenence at this point as THP
alloc success rate is very low when under pressure so sticking with
the current behavior seems not a bad idea.

