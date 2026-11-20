Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B45260A2604
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 22:06:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=BcjHmvYh
Received: by kanga.kvack.org (Postfix)
	id 921546B00EF; Fri, 20 Nov 2026 17:06:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8D2226B05B0; Fri, 20 Nov 2026 17:06:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7C0E06B05B1; Fri, 20 Nov 2026 17:06:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 462176B00EF
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 17:06:31 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C7C171A01D2
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 22:06:30 +0000 (UTC)
X-FDA: 85456882140.18.5C320C1
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	by imf18.hostedemail.com (Postfix) with ESMTP id CFD8A1C0002
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 22:06:28 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=BcjHmvYh;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf18.hostedemail.com: domain of surenb@google.com designates 209.85.208.41 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795212388;
	b=2gjuImlInEGfk72m32JZ+DrxVHBDWtPwbTTU5M9Tp9SlFzaWK4PfoSfCcmEh5a4HiWuFu/
	4IZwrMBMK3IU64x6WBKKe0byeBIBCjs3LylSmFfpDbcV+oVdp2IvEo5wOaIbL3yVkEDYrz
	JsbNcYNSQ6Cs3+FRZ2BNWvhApu/dueo=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795212388;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Qp2BTPut4j9BWLU7kp/9R3u9IW0btPsFhc2WZOxCd1o=;
	b=oDAve68COlxqV7P+nuI//WxUsdNw9X2bTeInvAVoPloy5owytGuDeS7CX1GVrYCV/mAfdc
	thCc0Va/S11A/shL9c5+zA6JDxRB+HE+qxIKsN1iwUp1JOiYUE4k23Eo1su31xyTVm4bus
	I4q6X7YUi8nwUoWX3x/Tmolxl4UEZsg=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=BcjHmvYh;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf18.hostedemail.com: domain of surenb@google.com designates 209.85.208.41 as permitted sender) smtp.mailfrom=surenb@google.com
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-6ba2a448540so3548a12.0
        for <linux-mm@kvack.org>; Fri, 20 Nov 2026 14:06:28 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795212387; cv=none;
        d=google.com; s=arc-20260327;
        b=hmzqzxV5hHzuPruO/wGx52mOC84lvv6YJN3B45TLqHV7DoZ2DKOQCBc9rNpYu7vyPG
         lPyS0cOBdUK8V6uRi3zr1vL3/ydpY32hNmq+ulOW6Pdb1uW0icPx5zm2WOUhVSqGQGdN
         Q87Xw8RcHNs8EfMxXI8TKhNO1iMsN3tjDO8S8obEEEFbfEsqbrLIh3YU9NjTjxxf7ya+
         5CltNyAsWVmhx0PJKQs4emmNS55ATMGkyiKBE9LohijLbmc9MvVdXWjbQE/Nf8+NYvSt
         Wzrn7OIYC8C4rTQxFl6ByWzit3HDY/pvul5RaU6ZSzgtYUdEzautwUbfhvpFeiK+5oIF
         vn0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Qp2BTPut4j9BWLU7kp/9R3u9IW0btPsFhc2WZOxCd1o=;
        fh=yyii/4oJ98IYjf2JLflvc3K53qgHuNJ0vnpIJFLwhkw=;
        b=paw7WJRjRzE4XknWeTcYF7evdsW3NBZWlQHtT2Xy9DQk5LzD2RRWH+RyEpoP6TsZhY
         ffdBcWVif1SiWVWNsKPMLsMP6Hg+aLDvUVwLTTBdwnQk8kVu/lP7SIJ+pfr4o3TFRTLF
         0U63rltLojFYvL9VWklO15mA/4sqQ2uCuakLO3PeV4i8zRvfXpWuvSK8bZnQWJXOW6pn
         rH4ULuVLNfYPLWJzmKS6ZaCBpuSVA0u44/OPoFv5vP6pByn4X502fVTYGRDw1fzwbhou
         ZjXMBf0YcV+C04d2AGnu95bkWletlIxcCsAPI9wZCu102SrH8eoy/PbVfTjYkxGoPCMi
         CX5g==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795212387; x=1795817187; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Qp2BTPut4j9BWLU7kp/9R3u9IW0btPsFhc2WZOxCd1o=;
        b=BcjHmvYh+/i1ddFciw4FAUfOQuqwGfKdLtwULUnEguh5XS/xHIjEpXpU/CPC+0KpxU
         1KwROfN49RxPc3H1B8SIi7OmpgZRbLKEihIhwm/F3cF6T3wS3q5cF2c0TH+yW0wj1FSP
         PqMbYCH3D8lIagHmUZLgzVPnC9nBcHFIs6pXBb4S9F2WbtuWvQwvB4MwKng4r9ijiTQi
         P3rey4x5XeFgilLuNHnW3wFEywnmelqHb+SwYbmwYSpq0v7AsLnN5x+e8GIZesTDcEKq
         pFqjALGtU4xDbJyrtLU6KXaLxB0WqlzJU6knKpBaliM5mb2+vyI79eYhH3Iyk+g7/YDY
         PqBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795212387; x=1795817187;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Qp2BTPut4j9BWLU7kp/9R3u9IW0btPsFhc2WZOxCd1o=;
        b=t0ok7Q7mvcP8G4Lv3BhmvN29vJec3PVWbWgMoNODlM26ap7iUUbtIZrOzwRjts0XBe
         hoD0YAl72zNw6ypKvY0TU9+IlKCbo7EDa5vRLIlsGY2xTZvvNy41NZ4vK4z0kskP59DG
         b6tPm3FX+flY944/cI95OQOF9FyZzx+IJgfdN2OUm0pHT+RcNoTAeFtek0IRruk8QLAt
         IKfqJpIggzSWjDEp0OXczJ1YLe6KURque5ZjpLXN1X2P184OOoI7ZziLxq7n5FSd2QnL
         P31wD5CsB4ARzJgxtU5GV/uheNiUpM0BVZsgckjsUPV/Duj1YLpslozI2EbSWfVOC7lg
         zsiQ==
X-Forwarded-Encrypted: i=1; AL+hErEuNYzWchzJlv4I1ek03II6Pj5vI0us4amkKBIOOL23u/dp0gPu1LtockcHuKXR36rEoT7L31NC5w==@kvack.org
X-Gm-Message-State: APuU4Z/5lDFoSLQtfveeFzsMMGSWuymIbLU8/VL6w+sXq/DaSpdUE/mW
	anzkB66uIkWEnn0QMPKBL2+YEq2yUjIr+aMkq+NeWt2Qn2MxS3bSlMbDqgXd4EyfsByTXfcYqHi
	5znxH9sZbPGBol2RYgQU8r+N/j/kSzULXhJzxjG5wTS0zoRUOnGVUmT1Ig78=
X-Gm-Gg: AZFdTZc+PTy6pd9l2bToH4pzqxkYGmPd2OgMFxJ9AYLqJzboMaMYXd9jBMS0J9D3ARq
	GntRX7dQ22l9EGrw0kD7XkXYaYS4rbfzpU9cxJF+/cn2B2rtDfz41YJV4sPOBxE2Dvnxz4q1tW+
	ceeHaJKv6GDs4TCSUWNPj4zdFE6a/UnBQWPTAghfiCU4pHvNU77ij3Rv/hFhgJZWsEAt/ZTwFlz
	SlI6cauxO/DzPvaruuIJ5FfUnmCFrVtojkXeioydK6K7mv/LIdU0QdfUFuQUY83KAcC6JJcu01H
	O3fj/UX51owdu3iSlPmdswgBHT1rCyAQSa5DGD0ZaVuF435mYn2lQ5fRFxRy3zJ8/kzhHnsJq4v
	VFu+T/W/r4IQNWaxgzfNtXWQh7MRdl2Td0lSaYNa+Qoi5vf7sX9DNEHpn5xoU358L0SkYbOpFSX
	/iYsTdx4aqQ7wUgZjr5LCGtl/qM1NqRHb4UpmCLjtcZhOjdQ==
X-Received: by 2002:a05:6402:548c:b0:6ba:12d7:69a8 with SMTP id
 4fb4d7f45d1cf-6ba65a76fffmr24683a12.1.1795212386808; Fri, 20 Nov 2026
 14:06:26 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261116071325.263682-1-hao.ge@linux.dev> <20261116071325.263682-4-hao.ge@linux.dev>
 <av34JPIcIOVdF0kL@milan>
In-Reply-To: <av34JPIcIOVdF0kL@milan>
From: Suren Baghdasaryan <surenb@google.com>
Date: Fri, 20 Nov 2026 22:06:13 +0000
X-Gm-Features: Aa3M54pvZs5QUyjUwxPZUYW951y-yto_861ekfXrLaBmJJ2Uwz172HO5VdEMhNg
Message-ID: <CAJuCfpHOTq5OAQtWnYjtFqUL58nn1GxCXp-DtoK4MsfeLPcwMQ@mail.gmail.com>
Subject: Re: [PATCH v5 03/11] mm/vmalloc: reject an unaligned range in vmap_page_range()
To: Uladzislau Rezki <urezki@gmail.com>
Cc: Hao Ge <hao.ge@linux.dev>, Dev Jain <dev.jain@arm.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Madhavan Srinivasan <maddy@linux.ibm.com>, 
	Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>, 
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, 
	Shrikanth Hegde <sshegde@linux.ibm.com>, Alexander Potapenko <glider@google.com>, 
	Marco Elver <elver@google.com>, Dmitry Vyukov <dvyukov@google.com>, Dennis Zhou <dennis@kernel.org>, 
	Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>, linuxppc-dev@lists.ozlabs.org, 
	linux-kernel@vger.kernel.org, kasan-dev@googlegroups.com, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: CFD8A1C0002
X-Rspam-User:
X-Stat-Signature: 7jnc8mgdw8rsuseto33ysimz41a5uamr
X-Spam-Status: No, score=-23.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1795212388-264916
X-HE-Meta: U2FsdGVkX1/MLi3dyOqDxc0z193O+WSBlmFEVGWVaWgLrrqd0BUBOidXS3/l7QKELQC8bHZ/ZqUuaaZu7yKXqFXnhCm+1ejvAWbwCvc9/LHm6C09Nn2pkFHFPp/If+hipTI4VCJOeE7n17nkTGiFCUXkaViQeAA+XxtEHUJJLCZVPIDKeYQOYZSbmy7r/tlkpnJNYFsg4fv1JjrHuXOrGBS2K5lwqbNnra9DpCUhtA+jt40UjDpIPRVsETHCFPNc4J5YqJ+zS+N7Xa+lUcSU8104tbOlh3fKsKVgKQgwt5WzYAd0xZvMtOPPqnleQ7IKGzZXevcesHJQOiApI+AEowazsEZx/D4lJhmFTyhPEHTLGrmGtmEcZio2f/FllEhwMWX+EynJ+aCK8wb4rjRJOym3wbq+EJyuJBYqBuYkiJTP4qSjyG8jQhmkoGgZAWe+RUeVW/6Q1eDi1XG4XXX8LwaWESDRiXP17YrNfHPYFudERkCxP8Hd3ulFGiJImvS9Naa46+SMVVsqiI8kqoW3w7zRyUm2aHhvoca1cSgjHfb9b+B1J/np4mzjRbVOVbsAvwX1hU8GVJcDu18Rhx8yuUnX1b0sMB0kZaJICiGtqaz1xOu+qVJLl2+nSNIm+0oldlqmJ1aLprxpySv7sSbjO2uvBQEnKBhU36xbzUucZHA7hJnWkM3H/8ydFDP/vDJZMf6y5ko7jpZXLqZRJS/KC0dJ5Dg65IzeDugKJmaAUHd5Kdmvtgma9g+nt1R/GwohDlxs4iDE/rEuKQoLXIC92LIGBj3089Ws2OB42ILGF+t0/NySZwY8Xaj9m7xZ/IvXPFaDd4FXHciHjJONPy5MIEPzxclWniDAdA3e5aQKlljMUstl7eie1vxw/5Qi6aKDL0sEfpFqHBvR8zitGuJoKMvu0xP6jyEi5bLOWZ9MqNdAByk5wKpT3/ezcjJbzOSByu7uaM1q1npMbOBFogl
 FTBajdLh
 eUUq//oyOfFFISG/n2T2EJbaj/atLHHFSjcR+iDYpiGA26GLMT5jiRcpt2wNOQl1nmq64DCOpIh/F+5Kn1sHSozg0eJr/lZbM/6IVuK29j8/tIGP2LSi3Tzl17KOxlVqoYAl5bV84jbIUyyj7MG1hEUStYocJs0b5FiybzbgznUis2V6kJC5DaCs9HH8bVQ6326Bo9gQTL6TTJUMSTT1kYObCrCl4JFKPWow1UWB7J70/VydNHkhUwNgek+SqwfSm7TEH2gpUHLl78skkAJZBolNfAU2QcDkqWqymvXTWN/nCtklMYad2Jq4AC90+O+wu7KTIKaXhyQmCNsuIVPc8DZ2/dN3b4vb1LsUk9DVDzuBiGslYNSQTgaurlNKVJ/yaWtDdqM/2haCaB7IU+BP7uBj6GFmQ5+JQmuSdePQd84JNdIWGB/5iNz1ALJf1e6Ahi36tVSO2ubYpM7KmYOXcfNQ3eIQIiFrrDdSl0Fl0/nsCYX8QRWGKsQP6iQWi7ZLPnxJ1DViUHdEsDY5N5aPX7n2ioWs9vzrF7Lg25NFjaqXV5uGSxIUsytawfOlCb19o5Nd17KSxLM4/X88ZWmY/m2gav2zhx998bKunSvwH7jDz3JGda0KPjM3zZZe3urqkxG+GYRJJ8PF3p+hne/VgUg8RSShoYN6AX42ojVyhZNdnDBiFJbQa1f0JLw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 18, 2026 at 7:10=E2=80=AFPM Uladzislau Rezki <urezki@gmail.com>=
 wrote:
>
> On Mon, Nov 16, 2026 at 03:13:17PM +0800, Hao Ge wrote:
> > commit a739e6b557af ("mm: vmalloc: WARN_ON if mapping size is not
> > PAGE_SIZE aligned") put the check in vmap_pte_range(), which is too
> > late, because the upper levels may already have installed page tables
> > for a range that is rejected anyway.
> >
> > The pte loop maps whole pages and stops only when addr lands exactly
> > on end. An unaligned end lets addr jump over it and the loop keeps
> > mapping past the range. An unaligned start maps the page below the
> > range and usually misses end too. Such a range is never a legitimate
> > request.
> >
> > vmap_range_noflush() has a single caller, vmap_page_range(). Warn on
> > addr and end there and bail out with -EINVAL before any page table is
> > installed, and drop the check from vmap_pte_range().
> >
> > Suggested-by: Suren Baghdasaryan <surenb@google.com>
> > Suggested-by: Dev Jain <dev.jain@arm.com>
> > Signed-off-by: Hao Ge <hao.ge@linux.dev>
> > ---
> >  mm/vmalloc.c | 6 +++---
> >  1 file changed, 3 insertions(+), 3 deletions(-)
> >
> > diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> > index 3c0d9e69b886..a168f6f20f4f 100644
> > --- a/mm/vmalloc.c
> > +++ b/mm/vmalloc.c
> > @@ -125,9 +125,6 @@ static int vmap_pte_range(pmd_t *pmd, unsigned long=
 addr, unsigned long end,
> >       unsigned long size;
> >       unsigned int nr_pages;
> >
> > -     if (WARN_ON_ONCE(!PAGE_ALIGNED(end - addr)))
> > -             return -EINVAL;
> > -
> >       pfn =3D phys_addr >> PAGE_SHIFT;
> >       pte =3D pte_alloc_kernel_track(pmd, addr, mask);
> >       if (!pte)
> > @@ -369,6 +366,9 @@ int vmap_page_range(unsigned long addr, unsigned lo=
ng end,
> >  {
> >       int err;
> >
> > +     if (WARN_ON_ONCE(!PAGE_ALIGNED(addr) || !PAGE_ALIGNED(end)))
> > +             return -EINVAL;
> > +
> >       err =3D vmap_range_noflush(addr, end, phys_addr, pgprot_nx(prot),
> >                                ioremap_max_page_shift);
> >       flush_cache_vmap(addr, end);
> > --
> > 2.25.1
> >
> LGTM,
>
> Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>

Reviewed-by: Suren Baghdasaryan <surenb@google.com>

>
> --
> Uladzislau Rezki

