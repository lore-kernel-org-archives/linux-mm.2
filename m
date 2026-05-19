Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5F688CD4F5B
	for <linux-mm@archiver.kernel.org>; Tue, 19 May 2026 18:27:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 99FD16B0005; Tue, 19 May 2026 14:27:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 950056B0088; Tue, 19 May 2026 14:27:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 83F216B008A; Tue, 19 May 2026 14:27:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 73BFB6B0005
	for <linux-mm@kvack.org>; Tue, 19 May 2026 14:27:58 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 170A81201FA
	for <linux-mm@kvack.org>; Tue, 19 May 2026 18:27:58 +0000 (UTC)
X-FDA: 84785003436.18.6D8DC25
Received: from mail-vs1-f52.google.com (mail-vs1-f52.google.com [209.85.217.52])
	by imf04.hostedemail.com (Postfix) with ESMTP id 228624000E
	for <linux-mm@kvack.org>; Tue, 19 May 2026 18:27:55 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=gmrV84zK;
	spf=pass (imf04.hostedemail.com: domain of ackerleytng@google.com designates 209.85.217.52 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779215276;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KLhZDjfxLPsE7BEQ9RGgNDgnSYlNAbHM5K88RGWg8OY=;
	b=HwniATvkeLja/yVqwPauU/l4DGvrwTHYEamnQRJnkTMjGnTqECvh/JOX5nDDbJ7zDkKTF5
	BBbA0TYkNFB8zAUTzhN1TXhyV89IYjp4cmSK5FmYQ25AsSpwaj6J5+I1zYnWrYEA0+ig+K
	hRy32L4yepotGgVffE1qxU5QGaJB7P0=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=gmrV84zK;
	spf=pass (imf04.hostedemail.com: domain of ackerleytng@google.com designates 209.85.217.52 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1779215276; a=rsa-sha256;
	cv=pass;
	b=jS9u2UZz4/zATVusepFBMrSQy7EerjDa5qA5C/CRefHBL19J5DDuyAvupDe9h9pClQjvGM
	Ukbp4Nhue+GL+hhA+E5GRtQP9bH8X9fydgWNdqBqv11dtyGctTaa1FxOhctxuFBuBxRfi9
	JjCQaKVvF6+b1z5BXSG5sDh8YtTiX9c=
Received: by mail-vs1-f52.google.com with SMTP id ada2fe7eead31-631b313e3d0so1202620137.3
        for <linux-mm@kvack.org>; Tue, 19 May 2026 11:27:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779215275; cv=none;
        d=google.com; s=arc-20240605;
        b=Fd2/gmVEYxpiAdTNNOUFS8m4cL/RnwFpiPGzlYgk/WSrqswTlDqOx+H6GcMdnoDVdG
         MeLB7maajui9oAz3bPTsPfecOhj9Tnjdalkq5/z3RwHJYZco48xyUHpQnX+bA21JAtl7
         t+JuFqP0dynCfFIO32jmFKcGK6R9uX5BrO5Tlip3SjAB71x/Ghg5v/cKBZchwfoWIzeP
         SiKQYwpQgc9Mc+yTA+EHz0ewnKmgyMjgJ8VuVentHR70Rz4G14VGb0xrLx4x01P4f6bN
         qPTNBkz/d2q57obrKrQT1YZ5IfLUAO9hU7hc8QBYmxUxLTMznuVTmTSaswEsSwtCaL/P
         9hFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=KLhZDjfxLPsE7BEQ9RGgNDgnSYlNAbHM5K88RGWg8OY=;
        fh=8xi0pjBC43nXnQgdaDrvtpQi0urahaqTY0UjpG7u7Fg=;
        b=D2pjjDF3R+N8m2rtsVNb/hkaspJIcQJL60dFtK2cGrnDqclIgSPDZqxrwqKLAFbljI
         eUkWX2Nyc6kTQb3wmkdxZfn3ZqYb0dMq3+yDpuEq0PT7Ohr8jjJV8hXIoGioE/8zhhH3
         LbITxcStQG2rEKyHOEeBDUn7MYJpYO+s4riT//JbZ8Pg7lyPwJIb/we57LnYTYNWdeLy
         Dyg2ASyvL3ZBqEPv7sMgK3WuISq9nGTU02oY1AHz9sp5mjSTpGCjt0dEO1cYfK2ESChJ
         eXXn4odTQyD/bSX0aQ1oB2xQQ6WJlrP1fm6MWYqRB9jfSJekOxUOTFLi5Bhtis991uBw
         UNog==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779215275; x=1779820075; darn=kvack.org;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=KLhZDjfxLPsE7BEQ9RGgNDgnSYlNAbHM5K88RGWg8OY=;
        b=gmrV84zKUiMV+AIn0nW5uZmlFJjXzvGdn31XQJ5woLt6LrvB3vQiiLzjVmdY9bpRgP
         SKE9AOhIYWeGBP/+/QcygkEg1cxY4EdJ0TqfCsHrX82r+AX1SeKwRa/FW0tQyAg+2E5M
         RCZJadQrzOMM8hTIhrOmuxgZRI8H0HtTlhTQRGP+/aU/65bUE8tQDw+UJn66F4JbTbUO
         hjTd9wQoW/Cfql8pss8QFfQBd3mwTIj+xkU0q8f+dV0kXfFigQcgyy2dSfBvg9TawKwF
         5OUFWyLcFH3jDQt5cFqbuTgHhs5fObQrudTNMiDfiDChnXj0OoXwlV++ptff4tCD32b4
         F83Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779215275; x=1779820075;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KLhZDjfxLPsE7BEQ9RGgNDgnSYlNAbHM5K88RGWg8OY=;
        b=BAA/Au2TTqSJ8mcsgj/UFB2qQKPS76OF3Q/ku9piyQvls5gLkEWsoHtz3HOkz+BuDy
         x6jaR+OZlmM6GsGvaXtf5574732EJtqU8hLvIbdoftoQ3H0aMEtg0K3YUpc2xV63Ma2J
         yGapVLfyLnvbsa/ZKBeRbwNViP6g8EEbnB+ElE+5/RJv9SUbR0NWbMJX2v23rupvkQv9
         UuI1X5EkcjCoc4hGd8ZcWH/H8H210ILvKWAegIF2ICc782eUCUk/zQKpf2NdSK9kWTK3
         0Ss3QMrRaILXpgRBJwEfk9fHN9L71zktPbhWvumC/XimUIW9vyJYgE8Vh4AdSRDS7JKX
         UlPg==
X-Gm-Message-State: AOJu0YzaKyJ7ASSlT36C5VSC2UfT2iR/jz/eCUQKlxn9+tO1IjXHKwgv
	ja7/nft8iY0Y551eQn9FpAXP/eaNAytAOwqcsV7K97/C2Fhi1t9ckLDrnvKkWSbwyBleWHa7I2e
	tByrZZM2qhfbU459jH+B5MUNuInY0NQERIDpJ+CRm
X-Gm-Gg: Acq92OEXBPEzme0QeCjPjSkPJz9yveavs0FN/hia5i8wVsD8IOmtTQ5i3hrMuIBuz3r
	SyqXnLDBzLHAwq/WqHA5VsryVC7Q91y1bi29C9ZX2eQRDpX2ClmNJICwvqA6rF55Dk7MpcV7s2U
	SGm6ZrxIzbUH7NZdeB6bg+2k0t8SNr6GJudsksniRTSQy/baj2w5/F9tIKkjicFNS4FUs9jPvHy
	opiUwLJx1UyUB3+X6O+94SVDkoBq45CvRN85/b37NgM1uLNK9HDcY7oEW4fa105Q2f0u0ftY+xK
	lBp7y27kEFenDfbaUJU3ZHYAYM+JSXmHw07W4LtMfgYXR1TxpWTqOfAMiG8ZRMWhfxs2dDLISXo
	kqm4w
X-Received: by 2002:a05:6102:4420:b0:605:7a45:c7c5 with SMTP id
 ada2fe7eead31-63a3e86718amr10157487137.14.1779215274324; Tue, 19 May 2026
 11:27:54 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Tue, 19 May 2026 11:27:53 -0700
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Tue, 19 May 2026 11:27:53 -0700
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <20260518-hugetlb-open-up-v3-2-e14b302477f8@google.com>
References: <20260518-hugetlb-open-up-v3-0-e14b302477f8@google.com> <20260518-hugetlb-open-up-v3-2-e14b302477f8@google.com>
MIME-Version: 1.0
Date: Tue, 19 May 2026 11:27:53 -0700
X-Gm-Features: AVHnY4L4rBNm-E6jJLcLe8AsTEQUFTflqFktKFEWbaS7pXHkZmjoVn-j5gC5oqU
Message-ID: <CAEvNRgFKDq94oJftSAB=_dkwZSwUaEQa34kNFN_fuvAYSeT1MA@mail.gmail.com>
Subject: Re: [PATCH v3 2/6] mm: hugetlb: Move mpol interpretation out of alloc_buddy_hugetlb_folio_with_mpol()
To: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	David Hildenbrand <david@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, fvdl@google.com, 
	jiaqiyan@google.com, joshua.hahnjy@gmail.com, jthoughton@google.com, 
	mhocko@kernel.org, michael.roth@amd.com, pasha.tatashin@soleen.com, 
	pbonzini@redhat.com, peterx@redhat.com, pratyush@kernel.org, 
	rick.p.edgecombe@intel.com, rientjes@google.com, roman.gushchin@linux.dev, 
	seanjc@google.com, shakeel.butt@linux.dev, shivankg@amd.com, 
	vannapurve@google.com, yan.y.zhao@intel.com, Zi Yan <ziy@nvidia.com>, 
	Matthew Brost <matthew.brost@intel.com>, Rakie Kim <rakie.kim@sk.com>, 
	Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>, 
	Dan Williams <djbw@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: xpubm7yy4ytyhiarewzmoe7a5tbwiyzu
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 228624000E
X-Rspam-User: 
X-HE-Tag: 1779215275-184153
X-HE-Meta: U2FsdGVkX19xhU6Yn8fFapUL70u8WltKLwx6NGdyyRli2ZA/Y447w5vPtoyaHHV43SYCYevsMZAbxYjWEGw+nWDNZeIdxC7kX1RzPkc+nt/bqLfGSShBiyVXFQCHZ5mjk8iqSd/kvMv40QTC+2TjXJwH4ROxHZNJsNGTBfTmyiEm08rXUmf06hT12DMI/1Xko68wIGVoWe+CDAb5u1DpxBk2m61c0pFPB5ktw4JvV01SNsAGvq8glWVV8rWgdv+qpsA4p9oXNVk64K7qG8eWrm3dtsXIL3zS86yT0u3ZnsvtSG2uwYIC+A65Wp5dNMg3WrOY/OebQBgQzVwe/9n+2Lk2b7Z1s5cQOF7VR3hdp7fMxedQisVly1B8OflVW7MOh0qIKadPCuLUjTVjhUSBltvn/+rJCJJj2aZYD2O/HdoWKS3qCzx5eCqqG6WC8KBQg6/s4oowNY+qfMxHFHEQJS92/TGEqSnRQr6EGUH4+4ZFDmm8EL6GapJT2GQQWeGpj+bilcnUjfbTOC/7l4yG9bWBXYJFd0h1pXNgf9C7IS1BRdiJXe0scXwrZ65HVu+W0LXCN//2sqeC5YnITSxNjFqBYmx77KYleeUgw4Tuou3wzA+nTB7Dmpj6VBY4lgV6QS/pYLRoIKAd3nmL+jFhKjlZUW+wJBJExK/8KaWTq0pTOzYQJzANwREFvRsJ+FCFZTKT01reT7EgYZ/3q9Mo/yM6J/lSypQNfdXxk9YuCvdTgmbmTAq8NeeAo4DL4rNx3JLFjZEN8fxo6fJs5ZwT/DBgGiR4mtZjDB428QAOPN1F1cUls5tDVDbcXVzOy3+fjTHWOIHgL0zzoIw9TyTGCYrbTF3qoTqP5kcK2loDaZ1TRIZQGgXZvG6pxQi3lNKUGug7FjvtxregCQYoZYgzLW8oPpN6WwTDYjwNiu1gj3qc44fyCSNjZlDn8ALjTiwZ3JvSL4PkvpNzhJN2IV+
 d1IZUTRk
 n3CmKfJ/5/8cme3EeXtdhQ6+sjHwkjRD8GWB6OJkcg55kV1E3Am4bbw3BKU+d16mxOJIziHwoMCOv1tS0ttszElSQYw6iBgcWrF5BXc2CVQ6f4su2ZZbwUe/hp4ODMwg22qW2YdItAhEBpM2nu6LwYCfXyQSB/2nNLnYL63Ee0DtUkSNAEr62CmJO1oQWXRLVaBNvbjhAXNBjPGIRd2xZz6SWg4SHGFb3B5wkj9HWHEXtizfj9FwIYksKcbCDjZOzSQZBhODhsK1d3oH85iVmqPgAAN7GffazjAX4T/gjN4HkO9tcbsiYZcSxKmfHxr3yEZRMfR2C3wOlAjc0aZsATIvi9sZjytRrUAiyxsQtRnOr/h8bMWKHx9qFq8Z7UY0ga5urrijf5oUZ+M7lZfux5BMCTruszsTY/eW0Tt3/hrN8uNNhiM+Zn0sVZog9Goo3L5pm6vdmHwcBX15p7T+9yhxooA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
writes:

>
> [...snip...]
>
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index 190ab539a97d4..6a5f69b3b1cb4 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -1334,6 +1334,12 @@ static unsigned long available_huge_pages(struct hstate *h)
>  	return h->free_huge_pages - h->resv_huge_pages;
>  }
>
> +struct mempolicy_interpreted {
> +	int nid;
> +	nodemask_t *nodemask;
> +	enum mempolicy_mode mode;
> +};
> +
>
> [...snip...]
>
> @@ -2941,8 +2943,20 @@ struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
>  		folio = dequeue_hugetlb_folio_vma(h, vma, addr);
>
>  	if (!folio) {
> +		struct mempolicy_interpreted mpoli;
> +		struct mempolicy *mpol;
> +		nodemask_t *nodemask;
> +		int nid;
> +
>  		spin_unlock_irq(&hugetlb_lock);
> -		folio = alloc_buddy_hugetlb_folio_with_mpol(h, vma, addr);
> +		nid = huge_node(vma, addr, gfp, &mpol, &nodemask);
> +		mpoli = (struct mempolicy_interpreted){
> +			.nid = nid,
> +			.mode = mpol->mode,
> +			.nodemask = nodemask,
> +		};

This needs to take into account CONFIG_NUMA, so the next revision will
look something like this instead:

	mpoli = (struct mempolicy_interpreted){
		.nid = nid,
#ifdef CONFIG_NUMA
		.mode = mpol ? mpol->mode : MPOL_DEFAULT,
#else
		.mode = MPOL_DEFAULT,
#endif
		.nodemask = nodemask,
	};


> +		folio = alloc_buddy_hugetlb_folio(h, gfp, &mpoli);
> +		mpol_cond_put(mpol);
>  		if (!folio)
>  			goto out_uncharge_cgroup;
>  		spin_lock_irq(&hugetlb_lock);
>
> [...snip...]
>

