Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DDCBDC5CFCF
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 00:53:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9F3C36B0188; Wed, 12 Aug 2026 20:53:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9CB646B034F; Wed, 12 Aug 2026 20:53:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 90C0F6B0351; Wed, 12 Aug 2026 20:53:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 64A7E6B0188
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 20:53:52 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D15B6A04BF
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 00:53:51 +0000 (UTC)
X-FDA: 85094423862.26.711FCA7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 0CD5B1C0006
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 00:53:49 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PV8Momg1;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786582430;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LeV6WGN89B/waKpgKNo/ZZV0DBlkFR3/03Fp+Sb5An8=;
	b=Kaae6WR+hWL8jAxmIU+9fI/usB36vpLXAJ42n2mWgaHEDEMbGVqqPbdFsCMGHe2dvvNmq1
	aGNf05uqrxFvpbjWHPdCcBAp4HytFv2cei9hKhHVif4aSmqXO87jHy4f0I+ge6pf9JZwfJ
	fzd7ibgbwSgEPEfG2ou4NLaLO6J41xw=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PV8Momg1;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786582430;
	b=bnB/oj35A5cY7vZjIV8ifj5hJ/YWcD0cMSn/N+LsIVRjjakwsKZRVk2AMPm8z9rMY7us1y
	p8KG3BkqrsPDquEaYVXub9I8Zujtn55XSKrI0RCgwzXU58d/Znkcx6BrnN1PWdCu13tPOB
	RLgRaBd0fhakll3BcjbwjargyMLYcWU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A17EC60A61
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 00:53:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55D491F00ACF
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 00:53:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786582429;
	bh=LeV6WGN89B/waKpgKNo/ZZV0DBlkFR3/03Fp+Sb5An8=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=PV8Momg18sLDwfyFZa42qBgPM+zHSmbUtCdq+JoOfUaw5Yfmk/4UFH7Aze1Sa1K+E
	 qKxr9NUxZmDC/BK/928Z3/2CqA0cMGFUV9OV6vVWqYiEivfBvnwRhOFIeBVW74sz07
	 uCw6n3JIsimHcuBiUw9yrD1KU4DhphZn+/ywpyi4kTUge4d3HB/7oPHPbeyExM2ICr
	 nErQSnvMxqTGMKkoqTd1QCKsuR3OYtjOZRXuS9QEqjOUqiyMoBoD0v1nvvPmhOc0n2
	 cngiyeV+w1PGuBvTnHKJoDB0JQMgaPFAwICffM1f9N82FRqpJl9PN5Nk0bqKGUA3NT
	 /LQHCliNHFN9g==
Received: by mail-qk1-f179.google.com with SMTP id af79cd13be357-92e5c92c389so76871885a.3
        for <linux-mm@kvack.org>; Wed, 12 Aug 2026 17:53:49 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RpXgf2b+l+L6Tb25FMr6+kxu6EjvdKxT96igWUUt5EwWP1vO+PVNOdSiUkqMSDyv9lBkvDVXN2fYw==@kvack.org
X-Gm-Message-State: AOJu0YxJUAqkFB2MWdz2GHOxv59Ow1rzb4kNea5o/ojMytnTvsMGFzXN
	vifOP66mzzyhF20S1oL7iBMKtQrsUBKVpHyLKpvG3isaejlSNB++VEtQyBOdWjiRxl0eDVKv3rk
	J7iuMdDXboFMXs/Pwe3n6w8hSpvcPcoI=
X-Received: by 2002:a05:620a:4891:b0:92e:5297:108 with SMTP id
 af79cd13be357-936bf900649mr237348985a.14.1786582428680; Wed, 12 Aug 2026
 17:53:48 -0700 (PDT)
MIME-Version: 1.0
References: <20260812065933.103627-1-hui.zhu@linux.dev> <d18ed09c-52b7-40ac-95e8-c1530246e2af@linux.alibaba.com>
In-Reply-To: <d18ed09c-52b7-40ac-95e8-c1530246e2af@linux.alibaba.com>
From: Barry Song <baohua@kernel.org>
Date: Thu, 13 Aug 2026 08:53:37 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4wE7E2G8H4ugwSWbQMF+5ecx+mrYQxXa1U6HY3utuQz0w@mail.gmail.com>
X-Gm-Features: AUfX_mxXfVQYeqtnzDvbbAiQydRrX2QR3r1TS5OZIn6v6iw47oQsUt5hAzPNx8c
Message-ID: <CAGsJ_4wE7E2G8H4ugwSWbQMF+5ecx+mrYQxXa1U6HY3utuQz0w@mail.gmail.com>
Subject: Re: [PATCH] mm/mglru: Fix young counter undercount for large folios
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Hui Zhu <hui.zhu@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, 
	Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Lorenzo Stoakes <ljs@kernel.org>, Kairui Song <kasong@tencent.com>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Hui Zhu <zhuhui@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 0CD5B1C0006
X-Rspamd-Server: rspam07
X-Stat-Signature: dmpur1t6odaxzbnh8ost8dyoamb58ys1
X-HE-Tag: 1786582429-910639
X-HE-Meta: U2FsdGVkX1/4V7tqg6RjQ3jIQYLWH+TUPaxJxoK77v64IEHbAFE6t8/ZRvnRxrIJ/6fQSd5u2RbixIg4ML87EV4+h47lG9XVJ4M0F1t284Q2ibFRXyedqOZuvRkh2GiVEhBSL8OMY//0X6W4wZz34zZd5PpwVHiNYBfNPp5Axjb8ZNrPurSlIUSA+k1FXqvmGl9J+tg213GkWHVoZOkVMNQksQBfdl8t0zDsw3DTv3TKqTWCJjIvkKx3bnAgtE5tJQUBWNhnx+DbmQdvOrLBcTiEAiU8w+lkifJ6K/gfCSf3dRuPnS9M28TcEZAnmABCmfP8OhumNR+fIDyZgQ8uczZtk9yhN9wnIMZDVpiGC645V6di7XAaCu283FVD2HVPHZF9SIpBHBh046hxaY0jFy+YImvlLpkzR+sYi27uNUjTOomSJjUN8ZXZg/1hdDqTd+FcUYEPw3VuxyqK4SmaqrjnwIn9D+eB/ZiQphtgxRbunOmlWz6WonCQDxkwu5QyAsJ3NgV9mtyFOaBiPv85ii8+Q1G2KaSNezQrZ/3HTGK3fSL0ylAjwZ4rUJgte+0DgCwvTzTJUrT0bP47CKP91LkDN9PknZq6bKane0EV3kblDCR/aos0izVeyggI95STa+CocmnBGo83ZY15bZKuwjt+uNYHwnw32KluO2L3gsauEeD1FBwZqxo6mzPUDqrhaigmxeIAXogJIDDHiixtASHmNRb1ufjCrXCuZs/OtGwxkz/4klXCB5OyTtBZUTqxQ3Wz7plJXwYESEpSPrnUUYHJC4yuuxgiRQSMiX1KIDAqFcfMlIqwKddPgk7bAwkoWKgMaxE58Wl3HZXDhvvLUMhdYtWpvWLqyGfYu5/PYEkrlxA7WmfRrL/vYj4cNcaKUGz4e8v/aIiZOFBD/FLyEE/gL5uhSGk/cLEecK2PCqm6M2KJexfBnQhQqfQMlKG1G5z2PIRVNaSuojWhDWI
 VPdRroAd
 tmQ1qx7MmHeL8BnkIVZ5S3PDxh4YGXDS8vjZsE+pPoTsVgermZ+W9wsEgZVolmatX5TTdpwzbXqtJyhsHuYQf1aj4pImIEzYwrssHOWXybVZu+x0YNu1oeOl9X4XDdUwgpveojievqLl9vlQDBgW4OAJFnOUd184dZw6/Iul1tW8WcHXjujitic3fFs7tFGMh+WhSQ92IrLdKsCI1DAgWsCASFneKiwy4OHZDAzFB2Ma3wEhSwtisbIQxi1tSzkCDDlr9Vq/UAOWWVazsLGqlHWxsDCDWJj/A0Zze4APoy3astaIDLr5ExNJ9D8te9pylXTvcP4TUsuLwbfSufZXXTCvWeQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 12, 2026 at 6:17=E2=80=AFPM Baolin Wang
<baolin.wang@linux.alibaba.com> wrote:
>
>
>
> On 8/12/26 2:59 PM, Hui Zhu wrote:
> > From: Hui Zhu <zhuhui@kylinos.cn>
> >
> > In lru_gen_look_around(), the young counter tracks the number of young
> > PTEs.  The original folio's contribution is represented by the initial
> > value of young: test_and_clear_young_ptes_notify() is called on it at
> > function entry, and the function returns early if it is not young.  In
> > the subsequent loop, the original folio is skipped (its accessed bits
> > were already cleared), so it is not double-counted.
> >
> > However, young is initialized to 1 regardless of the folio size.  When
> > the original folio is a large folio with nr PTEs, its young count is
> > underestimated by nr - 1.  This inconsistency can cause
> > suitable_to_scan() to return false, preventing the PMD from being added
> > to the bloom filter and reducing aging accuracy for mTHP workloads.
> >
> > Initialize young to nr so the original folio is accounted the same way
> > as other young folios in the loop (young +=3D nr).
> >
> > Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
> > ---
>
> Good catch. Please also add the Fixes tag:
>
> Fixes: 56e5b60b2114 ("mm: support batched checking of the young flag for
> MGLRU")
>
> With that,
> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

Hi Baolin, Hui,

I am not convinced this is the correct patch. test_and_clear_young_ptes_not=
ify()
only indicates that there is at least one young PTE among the nr PTEs;
it does not mean that all of the PTEs are young.

Am I missing something?

bool contpte_test_and_clear_young_ptes(struct vm_area_struct *vma,
                unsigned long addr, pte_t *ptep, unsigned int nr)
{
        ...
        unsigned long end =3D addr + nr * PAGE_SIZE;
        bool young =3D false;

        ptep =3D contpte_align_addr_ptep(&addr, &end, ptep, nr);
        for (; addr !=3D end; ptep++, addr +=3D PAGE_SIZE)
                young |=3D __ptep_test_and_clear_young(vma, addr, ptep);

        return young;
}
EXPORT_SYMBOL_GPL(contpte_test_and_clear_young_ptes);

>
> >   mm/vmscan.c | 2 +-
> >   1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > index bc324e37c5f1..264017850a55 100644
> > --- a/mm/vmscan.c
> > +++ b/mm/vmscan.c
> > @@ -4192,7 +4192,7 @@ bool lru_gen_look_around(struct page_vma_mapped_w=
alk *pvmw, unsigned int nr)
> >       unsigned long end;
> >       struct lru_gen_mm_walk *walk;
> >       struct folio *last =3D NULL;
> > -     int young =3D 1;
> > +     int young =3D nr;
> >       pte_t *pte =3D pvmw->pte;
> >       unsigned long addr =3D pvmw->address;
> >       struct vm_area_struct *vma =3D pvmw->vma;
>

Thanks
Barry

