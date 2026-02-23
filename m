Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8D82EEC1130
	for <linux-mm@archiver.kernel.org>; Mon, 23 Feb 2026 20:47:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E99786B0093; Mon, 23 Feb 2026 15:47:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E477F6B0095; Mon, 23 Feb 2026 15:47:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CCA816B0096; Mon, 23 Feb 2026 15:47:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B57BB6B0093
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 15:47:06 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 76A058ABCC
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 20:47:06 +0000 (UTC)
X-FDA: 84476906052.03.DDA387E
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	by imf27.hostedemail.com (Postfix) with ESMTP id 7114F40012
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 20:47:04 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=sVmtgA2Q;
	spf=pass (imf27.hostedemail.com: domain of fvdl@google.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=fvdl@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771879624;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LLvPmAWJUbvsu9W27Db/ZOo45wfaEQF3rbARD4LQ3sw=;
	b=eY31VEDYdj/HWkypnZXseQc4uzx26XPRaXWS6E3VJNC+MlJ6KLbQKxh0Wb0v8j5Lt6Vn6L
	8qvPRc6cKIgSCylCHwGUgJX6D/VofFjAqluG3HW2viEFLgWZFc0IB1HkqezWQRDWcAo0u+
	LAiVFtGWm/OHvyrqoLBJPxwj70Bwnuo=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=sVmtgA2Q;
	spf=pass (imf27.hostedemail.com: domain of fvdl@google.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=fvdl@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1771879624; a=rsa-sha256;
	cv=pass;
	b=yh/r5OmkyjDh5kppw0/Ms/OW5eaRzE/w5iVQqMon+wUaXDZkSvaNjUc6sacH5/nj7mhFnO
	74Bt2pHDJF1r1v3Yg3h/mlcduEPP8kHN8u0QcfOs5uK4cwnSXZrnZ8BkmmSR02dCsbTUfR
	Jq0+Dk0fP+C9RDtRfOJLJfw13tYmMaA=
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-48371d2f661so555e9.1
        for <linux-mm@kvack.org>; Mon, 23 Feb 2026 12:47:04 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771879623; cv=none;
        d=google.com; s=arc-20240605;
        b=Cg0sjfR9pp0GXdv7ypb8vmmlqqUkSjllyzXZr+RqsQDlDPMcXViL1chotTbEAH7pka
         WajAmL8uIcPWTd+fJKfWAllBr6RUh812dCl+h2O9kpDg3kgedKyWDaGrablG282OaIpW
         KdELduhlMsQmtTfTvI1nHM1VApVuaX8Cgz1Z983eKec0j7FgxkikhQymmtL13qRJu8XY
         bovdbJxwKqd1BP7foKDrQIeZEVja1dCpTr5Yc9EZSMI0g9vni1IR46b4Fq1vmxYMHfat
         N95YtGgo1QcSZnC/BuAob3+EWIrmK8K8d47YUO0uY6hwxTekEpM0ilu3hz9gqMW18HfK
         vJbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=LLvPmAWJUbvsu9W27Db/ZOo45wfaEQF3rbARD4LQ3sw=;
        fh=PN9Af/qwa/tEApiPOYIa6yR+ALUl1fxDUZaMqsHMra0=;
        b=fPJfZVD/b7zWEZhAm8htUkyy+DIqefOOWJIJqFPiJQuiBgd8Lr1a8MC4oH4diRs8V/
         xHZYl82VqnCPIeOe9CnV1n74Jii1KVtf40NQUqoMcDIFxXw9rvaaPYx3lEbrlGdxyRqU
         8IlK63VbwhcxNWExpZhSudsFuLk0PzhefUxMjymqhXtHwtFVYCx/HtSNTsOuvLDv+Mr+
         DP1re86B9GU29+lB5eAaC3rgXa7nkxhbHKXhcbyoCkqOvEqz6bftcznkvv56nuBNxmTE
         AxFLCHJT9MOQJDnYEgphbWWthv+AhRimOn+6pIfQKVaxEnGtzEyUAZqaVsh5Ub23+Dw9
         h9+w==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771879623; x=1772484423; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LLvPmAWJUbvsu9W27Db/ZOo45wfaEQF3rbARD4LQ3sw=;
        b=sVmtgA2QxX4zfgYC1io00nBQjF/6D/tsODX4dN8qkiOsA3b15R3mktHmwvHzyV6KuQ
         sIRGhoGBbwVyrbAHi5llYgEJnqJkycXmPmDVAQ6sHeLYSOyvcVNp4pZ9Oy7jdCcLI3JT
         vpD0x5B0u+k4WP4AhnjcyZGqNyxwKQI1Kq67hEGIEK/HTckk4g7U8xBUnYGmJmpNsHlM
         WfPn5G11g26KDfaWqXfhYdGMtLLWt4EjpPiLK9JmDCO6hAxp8fGs3HXGg87HB2UXM+pk
         sMbjiN10SThXoKiRxW1Kg6z9wlchLuh4cAqIPZ7xHNCrK8bL3VfQyY86mJQSgDIrBirj
         a2sA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771879623; x=1772484423;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=LLvPmAWJUbvsu9W27Db/ZOo45wfaEQF3rbARD4LQ3sw=;
        b=rdO9tgS1Nkqfnp4+kavZVcdTAdrWsuWng+0hXR/+HYAKZaVim701ylKRESY9VyA+pA
         iDZUL4fBdKrZ1NKPl8lcPjHIlcWoN9CT6jbSlH/G1pYPaNimVilO2Z9YHqDkSVj2Rkwz
         itrhrNW7PgXb3rlCGhL7t992o2cH4dgOYZz1OekV8OjaX6iReIBHjPPE6xMEXvLPnjKD
         YAK1cx6OK2xbXIugVCuHJK/g2exQgYt7mki3RDDzQiB4yLpahYuw04NLNy3y+6+WlC4G
         es/qNnrTxXIu4Rt08b8otl2h3dOclUnxIJVMO0xgid1MHd/+LvLErqlEM4+QmlKakhMy
         Hl/Q==
X-Forwarded-Encrypted: i=1; AJvYcCVv20KQnynbebrWOeCbkAKLJ+Qxc8TuWgVGSrmmTnrHiSB3dp7d4gTpGSl3Ez0jBgIrjRsJLOoppw==@kvack.org
X-Gm-Message-State: AOJu0YzEf+6wj0IMlo8+FKEsgai6XxhAi0FyWsxwKADJapnwOP9gwMOX
	tHPtHsmCBR/AN+eq85Qc+lh03rQs/1U5HU0ckF1WjGNj2dsYhZUhxGLFWKnxX1MJs8iUH15a49F
	FTCSVQSf6x947sE+KHWbCe7F1l3YQFIvkJQENUd9W
X-Gm-Gg: AZuq6aLzBYYVOZAoansyQ7c4HPfzrqah2vAQBrezxCTFyCocBivoGdxk9KGYM6Dgi33
	Q0uuLOA5TffBUvF2nUTkQIBGAefAD/7vAbRC4Vq0ePNe+t+yyKo3OTU862w7EActKFEqm+j9vaH
	cKU/bEBr3cR9+zRq068eGapU9Ex/nGWRbT2kkwkgZuduyb+UWrsphgoTsT7n4Q5aKCY04hMkipU
	elEOiifN/cL3W/sHIK0YHd4qvlSnn8m78TmTA2MVrg+Mm3mFOU5ahsmMwRLRAuySosN0PbsLe4C
	xy2W9fA=
X-Received: by 2002:a05:600c:4454:b0:477:86fd:fb1b with SMTP id
 5b1f17b1804b1-483b878837emr163415e9.11.1771879622202; Mon, 23 Feb 2026
 12:47:02 -0800 (PST)
MIME-Version: 1.0
References: <20260202155634.650837-1-kas@kernel.org> <20260202155634.650837-9-kas@kernel.org>
 <aZJTLwV2SaaKu1k_@casper.infradead.org> <ec4a9a1e-8c08-4879-a787-3b9e0bc38160@kernel.org>
 <aZyZ2-7Xr-zUnInC@casper.infradead.org> <9a972701-00b4-440d-8bc2-24b8dc469843@kernel.org>
In-Reply-To: <9a972701-00b4-440d-8bc2-24b8dc469843@kernel.org>
From: Frank van der Linden <fvdl@google.com>
Date: Mon, 23 Feb 2026 12:46:50 -0800
X-Gm-Features: AaiRm53V0083kx17uKl1QJe6iH0-QHdntImophIuh0y8aAfRVd2RH3p-ebZ7RBQ
Message-ID: <CAPTztWbr7y0myXB17Vz5HEZTw8a3PJ4qaxRKgtZmt-qXx1ofeA@mail.gmail.com>
Subject: Re: [PATCHv6 08/17] mm: Make page_zonenum() use head page
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Matthew Wilcox <willy@infradead.org>, Kiryl Shutsemau <kas@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Muchun Song <muchun.song@linux.dev>, 
	Usama Arif <usamaarif642@gmail.com>, Oscar Salvador <osalvador@suse.de>, 
	Mike Rapoport <rppt@kernel.org>, Vlastimil Babka <vbabka@suse.cz>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>, Baoquan He <bhe@redhat.com>, 
	Michal Hocko <mhocko@suse.com>, Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, 
	Huacai Chen <chenhuacai@kernel.org>, WANG Xuerui <kernel@xen0n.name>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>, kernel-team@meta.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	loongarch@lists.linux.dev, linux-riscv@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Rspam-User: 
X-Rspamd-Queue-Id: 7114F40012
X-Stat-Signature: xs81nnw5w5sgk7ms44arewdxmjtyhem6
X-HE-Tag: 1771879624-347038
X-HE-Meta: U2FsdGVkX18tkdwVMbiNCT1B3f1zpwtnXuBdmrsOMtY77cnvtm5cngAfNNxIsAbUhLmnMFrOy9U45h3ndQNke6JmU+DI8f+Q8Gvl92ttS1C5VSJPPGEa+MDa7/FggA3xrKwmZjKiU/d+j7IFxm7IuyX5HIfCK5MwIrDLtdV9QMGYFnwj+RwHCYcGs7wVAxG3d3T77FAFbsIT59Jj7ZNWYqGSrwukYO/LCVMEDgSp4QdEq/hFta3/DHeFrhJetZJzICzXa+7oTlMxVh/K/3lEq3gw7vbr9UkigRnRxC5hYLiCWLrQLpP4uCyCPpeovz5MTBhzhMuVCnUzgHPVV9KSEgkduRapeeAUEDco8qtphK0niB1RNwjX2f2U7PRxxbwED3wapt2il7mc0kPmWJ/3A/wYD20k3o80M/FyAP/q6trhIxDr3700kDxrLVNFdz3SAJXZAmqdHd2TjVSzlGq6IW4L5xZugzJ3mIMjjqY4YuK1iws/9qJtlIQZMrCURLaxSOVINFex2adHdsydAgSohfRWJfkN8EfSIPFaiCOHpkpMYaDEweCFvPTtEadd02NmpPIVIKZh//q2vY5Wn45PUVUJtw7TJzZEKy4wFwApW64LAAujlgDKPUwROJWWlYyneZN/o5d6uVfFOP75NkT8S4Wd0ZL1mqikrV1WxLgYHHPOCkg56UCHY95L3cowQwn0rXiiHqy35K1mafZHM4Ol9B+/Gqw1pdIqDv0bOvl2LPkyfXp0ReDqCpri4AOmWZxh3qPh5hlwQ9E++0Y0bM6Pj57kpJhF6ey+Aevvfj+OkbQCIeQJvCCqvyQytJQn4SDB7adSIjtWyDT6116WuqFnHeQh1krJj3mGVQESyB5HPszAJD10s37aM+9eZA56DTP9inBg7B5OOMa6Xny3dhC4F+KCfavJqL66FOT08uV8n+/SX/ThVzx8+PVLOTQghgSfbPSqj/mdSgwrBKPZe3w
 tqTQVPLv
 ped5g4RHwqEEXdS8VABXmViTjuc47OguP+iXfX9Ld7KkFYWQ/EEEg9WsveWhsW6ZFTXoq+2YG4CP5Nmiqz9M72qJoLO9qAWAo+nD1WhPDfLG7Zz8+o0o6gnDqYB5E2yT1ZdptSkGRLyy/ZV5TjspQ9+viS3icj68rGPqI+yjBRG0pXSLWKmgDLuJ5qMhL6+A87Fv1foJqoAniEfkmPLBmpA1Ge0Y4BzszGkDMFFDpv+ogSW5gYDpZjaZPcsDH/+FQVcjIuqVgGROWKSsPj2Qh5pJQnnx6GKwKJj0nrop8LUC/WiPzQwfydTuPZg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Feb 23, 2026 at 11:32=E2=80=AFAM David Hildenbrand (Arm)
<david@kernel.org> wrote:
>
> On 2/23/26 19:18, Matthew Wilcox wrote:
> > On Mon, Feb 16, 2026 at 10:06:57AM +0100, David Hildenbrand (Arm) wrote=
:
> >> On 2/16/26 00:13, Matthew Wilcox wrote:
> >>>
> >>> You're right that different pages in the same folio can have differen=
t
> >>> zone number.  But does it matter ... or to put it another way, why is
> >>> returning the zone number of the head page the correct way to resolve
> >>> this?
> >>
> >> How can a folio cross zones?
> >
> > I thought 1GB pages in hugetlb could cross zones?  Maybe that used to b=
e
> > true and isn't any more, or maybe it was never true and I was just
> > confused.
>
> I recall that 1G folios could end up in ZONE_MOVABLE (comment in
> page_is_unmovable()), but my memory is fuzzy when it comes to crossing
> zones (ZONE_NORMAL -> ZONE_MOVABLE).
>
> Freeing+reinitializing the vmemmap for HVO with such folios would
> already be problematic I suppose: we would silently switch the zone for
> some of these pages.
>
> When freeing such (boottime) hugetlb folios to the buddy, we use
> free_frozen_pages(). In there we lookup the zone once.
>
> Likely also problematic :)

HugeTLB folios weren't supposed to cross zones, but they could do that
in some cases for bootmem (memblock) allocated pages, causing the
issue you describe.

I fixed that with 14ed3a595fa4 ("mm/hugetlb: check bootmem pages for
zone intersections"), so they won't cross zones anymore. The other
allocation methods used for HugeTLB folios, alloc_contig_pages() and
cma_alloc_folio, won't return anything that crosses a zone boundary by
their nature.

So I think that's all good.

- Frank

