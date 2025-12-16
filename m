Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F2270D5B87C
	for <linux-mm@archiver.kernel.org>; Tue, 16 Dec 2025 06:13:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5A8466B0005; Tue, 16 Dec 2025 01:13:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5803B6B0089; Tue, 16 Dec 2025 01:13:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 453C46B008A; Tue, 16 Dec 2025 01:13:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 32FDB6B0005
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 01:13:27 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CE00AB9730
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 06:13:26 +0000 (UTC)
X-FDA: 84224317212.02.E3B555F
Received: from mail-qk1-f179.google.com (mail-qk1-f179.google.com [209.85.222.179])
	by imf19.hostedemail.com (Postfix) with ESMTP id 01B1C1A0018
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 06:13:24 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=F1Frh3bm;
	spf=pass (imf19.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.179 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765865605; a=rsa-sha256;
	cv=none;
	b=4IgDmyVJ8Kte6WRki6m6RnKxeI9vELbyPSG6jRCDVOGZTaQod8DB9OTSCVwwB/0ORvER0Y
	CfkMXoBnCm1fPSSCwwse71OA80X4AvN0yNaNGc4Q6bpW/ubCjqijhVMhe9g3cJb36vOn/V
	tH2tfezOS0BiE2CtZ7Ez21WgOCzelZk=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=F1Frh3bm;
	spf=pass (imf19.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.179 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765865605;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fpcrV6Gs9Rs7AKrPPGb241PUAXg5TKgrbxOHH777fE8=;
	b=1SgcQZNCME+QPWYzdBLisGPa/hb7vbWXuy1LU2yOAdIFMi+meLWXmKcNxVTxo4H2bQZpvr
	b5+MhN94ZdeT3vlCoaB5wHqOObZBdTsyz6OGHWXzbwG2cGH0c/hcmn1pGWL+ra3aGHb4eH
	GD/+EFVbGyA4J06pI6PvOn2GH7hTWVg=
Received: by mail-qk1-f179.google.com with SMTP id af79cd13be357-8b9f73728e8so400605285a.0
        for <linux-mm@kvack.org>; Mon, 15 Dec 2025 22:13:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765865604; x=1766470404; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fpcrV6Gs9Rs7AKrPPGb241PUAXg5TKgrbxOHH777fE8=;
        b=F1Frh3bmAjXqb3OjU+fs529EiFi7EFgpjPQ+zBAcqfZYWd2pOKjG/tPSYtz0IuvBTD
         ozR4Hg+JOkiyNs0wrPyUjlptiVRDSj51pEAXi0rGMJXa05YiZp220Z5KuFIJ8oslz4Tw
         oT0VLZX9m0rr6KkGbyteu7nlOK36m1RqW4ea8gpEE/aBsLnisZGbNYr0mMnCMHVluiqq
         pEw1GnP80OrplctB0pKUO15OEt4PR/ixeNJD0BqacoHylwDmGKeoDh2bsKJ7GeRv3MZR
         ytFPj8sa9GCaDlntu4OGWjpjZHiETcgdCjiTadwvm/QKKxUvANRr6tO322poAS/2mSm4
         vvAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765865604; x=1766470404;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=fpcrV6Gs9Rs7AKrPPGb241PUAXg5TKgrbxOHH777fE8=;
        b=H0LvbTUcjfd0M6gpd6tITHf3iIuL4v4LkmWr0Q5KhQU3fXCw1EPtZ+/GI+2bqWc5Hw
         2Ht8Vxv1OdK8VB3EO78KAOJmVLvcIVfzOvOO5CHesUNbA1Krh2S2CNpmFIl6FZJLI+1W
         mywXASXOdHaiKoZHvu/htf5eNsZASl0ah9PwDbntlvZGslEcewBV6PMBY1B4SQgekbyz
         s6x3J1R5lggO2B782tV8L1u4N2S3hH+iHKyWEXIdypZOy2w2mbEINOKa9HISn6vat4+z
         xowICbuDCpzSU6Ks8WsUS6eY+SWYGjFUZZMoVry+X4yLFPlRGvu4/v9L/j9GKv0+R6vt
         9znQ==
X-Forwarded-Encrypted: i=1; AJvYcCWlNBsUzKuQX8op07JKlhHelOru/dS4b840r/+FsTw0G56aNaNzHQDGsvXSNqzQydRyMVcX9mXZBA==@kvack.org
X-Gm-Message-State: AOJu0YxtGdYEFdfs8ExUj5njy0ZqGIrI9nwEG+QIt3Q4+pRqpno21lcd
	Q6IARLovQqUeMMwod4Dz2cZoiXJDBGkRonp4MXGn1gRm62FCUc/GjBVHZVe3VnlNr58Ajae9EhB
	1Tgh/wnYcic6lxWdhneAlDSOz6sIKU9Y=
X-Gm-Gg: AY/fxX7TXHZl7Kee5rX0uVBmSYPN3td9OWrAeSuSEMNQYsI2k/L3YY9YufzNB5dHvnk
	YUFQGv9m9I84DITUEr9CLcTGS64aNydgEAqrrV9C6zKAlPG5G7F62QqUp/fxM1CqznKsbThMT0w
	S7vvxbyS9QWIWNCHuI3w7ST7quIVpVJkse8jmrFMvWLBSE3i2wlAplZ6NnzlsCi/oCLd1e/UBp3
	gA2khxlx4vwnZwn0IsyCYaYko8U8EYqYWt/CtmrXDaDabV1ro10r/8eZXFL2gLfrWNddHRkERCS
	ShW9
X-Google-Smtp-Source: AGHT+IE5g32thmfLBtxuBdsqZjsQzrm7jv/zeJKiwwmRNuWeM8EbP6APHwfatCpfOllkkm7FHIFIRBpSbf2VQHq1mV0=
X-Received: by 2002:ad4:5c48:0:b0:87f:fb1b:ef95 with SMTP id
 6a1803df08f44-8887e019d43mr193697176d6.8.1765865603718; Mon, 15 Dec 2025
 22:13:23 -0800 (PST)
MIME-Version: 1.0
References: <cover.1765439380.git.baolin.wang@linux.alibaba.com>
 <af330c9ea188bd0f28189b1e6e5803f6de9d2abe.1765439381.git.baolin.wang@linux.alibaba.com>
 <70d1dedc-b4fc-4eb6-baf6-9e54b6a62249@lucifer.local> <eb871ca2-47c8-4b10-a61d-321716f6c147@linux.alibaba.com>
In-Reply-To: <eb871ca2-47c8-4b10-a61d-321716f6c147@linux.alibaba.com>
From: Barry Song <21cnbao@gmail.com>
Date: Tue, 16 Dec 2025 14:13:12 +0800
X-Gm-Features: AQt7F2p3Kae-ArD6KnQi3aoTVGR5L0LuPLXxXyTnlSckAq7q46ac-khv4fOXPxg
Message-ID: <CAGsJ_4xp40A3u=N5_mw00Eo6bPmFvctD3j=1Qmy3vOo2EmX3hA@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] mm: rmap: support batched unmapping for file large folios
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, akpm@linux-foundation.org, david@kernel.org, 
	catalin.marinas@arm.com, will@kernel.org, ryan.roberts@arm.com, 
	Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, surenb@google.com, 
	mhocko@suse.com, riel@surriel.com, harry.yoo@oracle.com, jannh@google.com, 
	willy@infradead.org, linux-mm@kvack.org, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 01B1C1A0018
X-Rspamd-Server: rspam04
X-Stat-Signature: hek6e8648q981pdqd3aja7fxycw4twcy
X-HE-Tag: 1765865604-525242
X-HE-Meta: U2FsdGVkX18AemoURMRadkVvUPbs5Zt3qWVqYgcHUHn0bUiCwsXGRNAZa+JsC33iLKDHVD+5j7Fef1sZmhOvvQtCCOlyQeOdP4Fr99CMj2BjA3ufslPR5EzrD+TZtroYzLF/jHaxTw+Lg0S1uokqcQMBf4s0EDAXAlwD0obJLtaxJZ6NNlsmvPVNjM/9KDQRjmy9lmMTewldQwKRGS5mY06Gr0oWsbe4t34sgAQWAgNt0JPqDhcRM9/919dPTZWKKV2PSXnuptt0paieSoH0SnBkDPFjz3Rbav3Um+4kAeJ07myYyyQ5xu2wxer502XNt1KokXI1sPNh7N4D/nU1SRifhb91wQmREBJ36jJI5vOL0o5ApCfOdZyaHa8Hlq3M0b8P9duRFn0PBdOA9CWp39a1w2Vbfap7CRu1CZtt1MhsC+xAUxaqq+6zHV51uT8dw/bNWpNBxTmSiP4Qsrjqr6504Rfil6u9NYleZA8rGdVCESy5f+SocX1xB2oQ3sZzWTuOGQvCOK68Yn0J/bzKh2pVoAfpSh7FoiBvRGOv6ueh7XCoeipnhGTxZQG0ntvnabkiBy1a9LByTf8do26U1XTAe/tUcibZHIX7jyyKAHLS7KNhsHOCRrYFOtHsAwgFcg5EmDldTa4COTYj8sjmZ9Q7SgLtif7/u4TehZerDvfXxAuyPrvL49G7KcUHl13Ijf/Bvhlgvnhav6lxm0tGwz1pKvtPnyDHmxZYiTzvGSY3dwPqD9czG28GgXXKvIot3trU+3I3uuO1fSCWrgwdxnSVnN1/+AOtVfRrg1zJVC07W8dsUWKyJOLVESjyruNUs83b+TjD4LVoljQtzky14dxEZzXSTlifnv+no6aGFgwweHl6OQp07+fkuWQxtgIQ1nPMiDzvxlMusFo4oCjg+BpykH5VkZ2UcTGpQ4TqF20SvTYVw5He1rOHqMp3IqwhwiC3Nohu3vMOKiVmFiU
 UzqumlA0
 36VxmFKxPhHUP+QsCxmEq1xy6siSAPqQEuB34nXvGuBx43H0GTUlAtqE+ppj7A1fE53twAXs1srvYkVS4zz+z4skWt1d3cHFVqKn3SR8PEeB20zggxO0Sf83EuHOyStMCGRkwbRrg+HhkCEQI4h6kZlQP0ALpEvWBgB6rESwqU+21nO4Uo+7PWISJQJKWgFlatAk+pkHRtC2cK00Uc4A+z4nYi4rjlOMOc/4Cr7nGP+p3ZHkDL70dSO+xLvMIymBzvXZkgXglctMdgAxENCiPXHmBPaC3LtTPJBr+/iOyyCBIHEs7MWk9EO0uiQHknPXkEKTL7eZPwStHO4N1OXU80uzJN0qzDU4xv+MQJ1u7WrB1LorGBUM5xNQywg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> >>
> >> diff --git a/mm/rmap.c b/mm/rmap.c
> >> index ec232165c47d..4c9d5777c8da 100644
> >> --- a/mm/rmap.c
> >> +++ b/mm/rmap.c
> >> @@ -1855,9 +1855,10 @@ static inline unsigned int folio_unmap_pte_batc=
h(struct folio *folio,
> >>      end_addr =3D pmd_addr_end(addr, vma->vm_end);
> >>      max_nr =3D (end_addr - addr) >> PAGE_SHIFT;
> >>
> >> -    /* We only support lazyfree batching for now ... */
> >> -    if (!folio_test_anon(folio) || folio_test_swapbacked(folio))
> >> +    /* We only support lazyfree or file folios batching for now ... *=
/
> >> +    if (folio_test_anon(folio) && folio_test_swapbacked(folio))
> >
> > Why is it now ok to support file-backed batched unmapping when it wasn'=
t in
> > Barry's series (see [0])? You don't seem to be justifying this?
>
> Barry's series[0] is merely aimed at optimizing lazyfree anonymous large
> folios and does not continue to optimize anonymous large folios or
> file-backed large folios at that point.

Yep. At that time, I didn=E2=80=99t have an Android machine with a filesyst=
em
that supported large folios, so I focused on lazyfree. But I
agree that lazyfree anon folios and file folios are quite
similar.

>
> Subsequently, Barry sent out a new patch (see [1]) to optimize anonymous
> large folios. As for file-backed large folios, the batched unmapping
> support is relatively simple, since we only need to clear the PTE
> entries for file-backed large folios.

Yep. It is actually quite straightforward to go from lazyfree
anon folios to file folios. Swap-backed anon folios are much
more tricky, though.

>
> > [0]:https://lore.kernel.org/all/20250214093015.51024-4-21cnbao@gmail.co=
m/T/#u
>
> [1] https://lore.kernel.org/all/20250513084620.58231-1-21cnbao@gmail.com/

Thanks
Barry

