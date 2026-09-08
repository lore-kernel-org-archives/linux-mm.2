Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D5DD5C79FAA
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 14:48:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DCF856B0095; Tue,  8 Sep 2026 10:48:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D80556B0096; Tue,  8 Sep 2026 10:48:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C477A6B0098; Tue,  8 Sep 2026 10:48:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9F2BF6B0095
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 10:48:27 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 22D881206CB
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 14:48:27 +0000 (UTC)
X-FDA: 85190875854.21.DA28B1A
Received: from mail-wr2-f12.google.com (mail-wr2-f12.google.com [74.125.225.76])
	by imf14.hostedemail.com (Postfix) with ESMTP id 2E79E10000D
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 14:48:25 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=pwQdLTvA;
	spf=pass (imf14.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 74.125.225.76 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788878905;
	b=2CSrRrPjdS5ZMgAEuND3enh1Sdw+at+ldyiXtOkdICOa7NPmuvYsphOWOQVusgu7rhHqEq
	hMjSQKWByVB1ln39ox11HeuhweL8tRVbmXyCznwdxDZ8G5LQqnby8zTo2RkK0yJz11bdEm
	yAkfuHht4b1OtkdjSzptjI7hdnYAkEU=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=pwQdLTvA;
	spf=pass (imf14.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 74.125.225.76 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788878905;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3NYcqD9fW2oLParj8320kOSOxI0m9dJtpaA9HezT2S8=;
	b=QuO1qn3Mfg0OfTk5+FDR6wOtwUD5Z86ddLtUOuUd0rdYSDNHY77baeINcwLZPt01OdrNQ2
	j57XHlBwd7HU2oKRJ3lk4iUPai122ciSDGqYjv0bXkclJoInlJh+Ab0zBZVsxiEJg3Nm9N
	yUad0FgK0O3qPNnNX6n3RKol0WB7KZY=
Received: by mail-wr2-f12.google.com with SMTP id ffacd0b85a97d-4843178b1c8so391092f8f.0
        for <linux-mm@kvack.org>; Tue, 08 Sep 2026 07:48:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788878904; cv=none;
        d=google.com; s=arc-20260327;
        b=XJT9dhiauRGQtJ8JkYoJW8y7Lubsn5TeBrZQ5luZtV357QjlLsPrxcv6UXgXUUP4y9
         Xn2PZL7HCtqfthh7FdaoA4Lhstk7G4kWctZWNNiZsDVnASauZqiF77IN70yKCxLPmdCT
         HqFfWPm+UJWUYSKqScDE9FKJbV33DbAz8JeGZ1DhaH+ZuU67bnUnpOpfJDefk0h34vKh
         54d2hsyQANh2nQ5w0OTlwR5eNAwqXlD+WG/KfhsZuLqYJ/mLHGQ7jLAEl3G3nfgd6XlR
         fZcCOFgsQkPL9WrrNhV8sYOhm2nb5XU56QiUqXTWvyzipNtxZkneZ+CQuwV+E8r8rnKq
         qwVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=3NYcqD9fW2oLParj8320kOSOxI0m9dJtpaA9HezT2S8=;
        fh=unoZAcAnUrO3HNPiRBQp0Znzh2dldNoFpwnynsisBmw=;
        b=mPnUjVJMBybtvSFSuCEWxQhxtuOlqYiRKFZvMA9FOw7VMz06yHZn1iShIgVnhjIpSI
         Ix05PWTOohlvYN4hvr6wp0Lr1ScVsWIBNPMKMMo53H1ICnCCsjHDBICQpD8YWmzWPXtD
         FSSiaxDB18mltq6VrgaGGZSVTkfNtZ6+NdN+AXVEcLit/mzXtb0l7wxc/XfLE/1h7rIu
         Nr1cX7O1il/qjnEvu9azuTANnmm7MI11byjEndC2UJZ29eRRvlngwPmNSQCrBdy/F73o
         xisEnCe4EbyUNX4icEYFLR3oZ/wA7q88+pK7NFlsVLKPxDaCigRQMCv7JCxkRrKDIFcJ
         c9aQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788878904; x=1789483704; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=3NYcqD9fW2oLParj8320kOSOxI0m9dJtpaA9HezT2S8=;
        b=pwQdLTvA2Ib+gEDbsl1DxFaj/2EEu219izH1E5j3aBqv1IJjeTM5F7lZTBSCDGykIv
         F7s6+dsQ2aAuOBLTZ7Waa+INs7ureaiJ6jahWsz6zjGPLa/gF+uaxBS7GwYx4FzuHgYe
         7hO/BQlMACtvBxAQJoL3RdtvqSNJzYnGC/bAaPvGbZz8G9JQxXs9U0K7lcbTDPFsu0QF
         YpoIm6pbcUdEGc0JxzoahvTSWdV0+qfng4IXJkAwGVt4VVHI1+2ZGIeLl9pVMEtz2gy5
         iOwOb0Sdh9teGR+RBW2bC6e24zOzWxniz3lf8UwPKsRFpmhE6d5csohA4B+kx/UCYKTn
         gchg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788878904; x=1789483704;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=3NYcqD9fW2oLParj8320kOSOxI0m9dJtpaA9HezT2S8=;
        b=PuslgE2JOAkZySRTxU5gzbu6K0gSFtjZwTC43kIdj5FbCOaRUOia7Y21WufSP0dINg
         IMoYAkoLIzXdWs2H5prJ3a47QbI2JdNhpPBJo2iLXNO1vquTu2fRs4Qegr5Uv8DCfv+6
         BkfQvajyJ5Dwgu/rJi9sjdpoAX9KnLMVKN/jvgcqzwZhlE8kk/93OumsARStakd/vEpI
         lX9MJRDH7kH+//XPShoHG4jot6vvnezUWucHY5aHr1+LKYCpe3SS1NyDyqlq0G/NeNfF
         aPUJatoGSj8sQLRyZJls4DnD1OQ5AMEACfumevnv6LLq/UZgf18bUoASKQHlZAo8EDOz
         2tOw==
X-Forwarded-Encrypted: i=1; AKwUvBwM1bwpRTcWmnsnJ1cNgIsBlLPTlKpNyE7AsHw+5nsZkcJTYnrejQPhvgOc2dVpxGRODJjwrodjRg==@kvack.org
X-Gm-Message-State: AFuF++nYlMRsLXo9dY0QKphcYU6Dh0WBPhBxIrVPRrc+PHvPurJ7tE0j
	EE2VsbVlSHFfYLbib7kwHnj6AqnAG10hZYQ+PTpbORB35/+NahAiLctv2h5hydg1PXGzbhtm+a7
	OcNKaQmI0xZw7yDlN8XG6O/xaTBsk6Os=
X-Gm-Gg: AYBFou1t55B9xvrMobdoyAzcushyIEkYS6Anhh7sRH4sQKlVEwpHwz0T476XQynuL9G
	p+CL16TCeDUecvfHYwc1zyrA/09w6R7jN/wqGciLqVqEfD+YWewK481EZL29JVJs+ezdP6IT+ss
	So25U+ziEgTqY0WKSs44zgViVwZkcz45PMDANf/2edA8H/KLK+cGu9hLhoNAmlOF5INIme48EIQ
	/oI7qaBhUhQhUBIkIPS2yH1iGy/Pvdw97JYxyIwDALQ7o66frfeoZHsUcMjZvkCz4ih31qrbXMs
	LhfKp7o9g8YGCjEYA2yBdKyaWZ+PxePoH8RbY/LxJ3PkKWswG3qjvsGh5Az5PWARN3XMcnKaWDh
	Mas4G7a25OTD6p7F44436NB12JkUP97k=
X-Received: by 2002:a5d:5e0a:0:b0:484:3200:b7a6 with SMTP id
 ffacd0b85a97d-485907ec2c3mr20932696f8f.4.1788878903312; Tue, 08 Sep 2026
 07:48:23 -0700 (PDT)
MIME-Version: 1.0
References: <20260901151818.3191443-1-xueyuan.chen21@gmail.com>
 <20260901151818.3191443-2-xueyuan.chen21@gmail.com> <1d5ac9d7-48ce-4fee-b893-f646bade4a86@kernel.org>
In-Reply-To: <1d5ac9d7-48ce-4fee-b893-f646bade4a86@kernel.org>
From: Xueyuan Chen <xueyuan.chen21@gmail.com>
Date: Tue, 8 Sep 2026 22:48:11 +0800
X-Gm-Features: AcwNN1W4h4jJ4-flD89PVNlVIy_4xMFWj1BYld6srQf6ZceGKY-mFk9Pv3akMZI
Message-ID: <CA+qSx6yjiXJkQm=hi=F8=_=DU0x_usSuXnL_1yuy0fUU9UU-Zg@mail.gmail.com>
Subject: Re: [PATCH v7 1/3] mm: make persistent huge zero folio read-only
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: akpm@linux-foundation.org, ljs@kernel.org, usama.arif@linux.dev, 
	ziy@nvidia.com, baolin.wang@linux.alibaba.com, liam@infradead.org, 
	nico.pache@linux.dev, ryan.roberts@arm.com, dev.jain@arm.com, 
	baohua@kernel.org, lance.yang@linux.dev, kas@kernel.org, rppt@kernel.org, 
	catalin.marinas@arm.com, will@kernel.org, mark.rutland@arm.com, 
	linux-arm-kernel@lists.infradead.org, tglx@kernel.org, mingo@redhat.com, 
	bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, 
	luto@kernel.org, peterz@infradead.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 2E79E10000D
X-Rspam-User: 
X-Stat-Signature: gyc58qcs58ghru7pae568t45ze3mm4rt
X-HE-Tag: 1788878905-309244
X-HE-Meta: U2FsdGVkX196Ll1fN5ZLXO5FPrgf95ZLTylZD9rieOFsQ4bGbqw5m93ZvDlpi8EA1pNVstAiA0KQpefvzNmp5wHEeKltLlXPWt3Cmh47++Yu7MqjAUCYrO78QZzHu4Dvsl5LqXfFIgid+7ZOgW4XQ7zNeDsCwDI5hFqku4u/2Zo3DQxmzu18BnTugqG1ClaTrKw5mNnMIZkQNco0q5flgsjrjRHmSGJVSYt+psZr8NXBtxZ9Ap98qeI3GIP8aJkYk8w3AMtTFdWAGNafTqt/4ytEjVHqombYfO7J3oX7C2FFCqBQ7REGdIOxzzwQljo+WL00SJFqA1UfPEajL7QXRXA62WsO0WEa2wEGSgblO0ac7zB1WGWXdVnZ4abjoZDkfNUAlAt2+09n7we0iOy847vZWV1a0H3gAPdZ6aMIWHzkAl8Rg1gwyZsf7AZqNOzYRlyHWtwkI0pPoxdPJh5b51SOxv4D3xOIKogwHGng6WZQZa/1B/2ZfSahQwy1ZvIWCPYVUIpJqExo+49HoHnzcwvy+s61Ju6BC+4Gb34VHRmS7K/cVDSm17CSRUVw9B0gQjTtBcBvuwH5vD0mBFSS4L41qQo4MvRRigp02oETapCpYWJM0SrCjEwSZWHYT1VnkWSGeg1pLZ9Wwpd0qkNFZe5zJeTha/5U7avHFWyKauhLgsXR3oXYQR2v3xD+M55d5RL1JH2hKY2yPavWyqAVes4eoBkAaC9w5rJCyE/+atr/q6mAGTO/2l+a9Qtyn4jGqPMrC0QyH2R3SeE8UaJ8P+B0kbgRkfh2aXJvFcbPv6gLmbdQ3zAWrNck4+T7wksv/dG0q4nu8f+vljTXd+rWeCP6LOtwB1OEUkrBFrGxHvcZIwPZIMjZuqQafKzZzGWXLQmkJHBWMkXt60WajI3juRueK9gT6uNFuNUoh1pYxjtfo0izPdhIZJwlabyOwGpJaW++rxC0Xi3+Uu8FwiY
 STOdPQy4
 EUE5f+R8jCzr239Ye3RycZY8ufLl8tuIQ5UyQKSK1izmt7WoXuait/iMR7bvSmT4teUPTWuQ23IszQ8FG5qAKusT+Eni0nt/MXK14ZCC1cx3eydCHZlIbsm4tc7kspAFT4f3mp+izCrPRI7/uMcYk2jGw7Y+mw05LLf8PySkxRWXh9FQzuUnR+LtzI8kK8WicMuY4+sIvbFQ0JJNnodQLkLUpq4HV+36ORW/fKh++WUMTlQg1x1KZHCKlUHwLee5+fFToU9jJwqPLVKh7yhdJXJU6syK2dRvc9RlSIolZtBTYhDSycu3cGDiB7fC+7qspHwBybnUTX+ZBPK9/c6P1Hgbpq7UQ4Wg/W8mkAiIf2cVFECijJCkJy5Hs5yvM3mqg3focOyBcaOAxTA9cIgxIhQ4/cnJQFyqONFYPYfejfRmge0Bu3dXPL9O7Wq8WUO0qDdPVhwBTs8I53q5rFKqHY51PABG+JF3aGAMN
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 8, 2026 at 4:30=E2=80=AFPM David Hildenbrand (Arm) <david@kerne=
l.org> wrote:
>
> On 9/1/26 17:18, Xueyuan Chen wrote:
> > The persistent huge zero folio is shared globally and should stay zero
> > after initialization. As Jann Horn pointed out [1], kernel bugs have
> > ended up writing to pages that were meant to be read-only, including in
> > security-sensitive cases. Making the folio read-only in the direct map
> > turns such writes into faults instead of silent zero-page corruption.
> >
> > Add a page-based helper consistent with the existing direct-map interfa=
ces.
> > Handle TLB invalidation in the architecture implementation; unsupported
> > architectures retain their current behavior.
> >
> > Protect the folio after initialization. Skip highmem folios, which have=
 no
> > permanent direct-map mapping.
> >
> > Inspired by Jann Horn's read-only zero page work [1] and follow-up
> > discussion [3] with Yang Shi.
> >
> > Link: https://lore.kernel.org/r/20260508-ro-zeropage-v1-1-9808abc20b49@=
google.com [1]
> > Link: https://lore.kernel.org/r/0e5b23a6-4895-454a-9dfa-6dc21adc2991@ke=
rnel.org [2]
> > Link: https://lore.kernel.org/r/CAHbLzkrXXe7r3n3jXgDKtwZhRqj=3DjDx9E6dL=
OULohnhBguvi9A@mail.gmail.com [3]
> >
> > Suggested-by: David Hildenbrand <david@kernel.org>
> > Suggested-by: Usama Arif <usama.arif@linux.dev>
> > Co-developed-by: Lance Yang <lance.yang@linux.dev>
> > Signed-off-by: Lance Yang <lance.yang@linux.dev>
> > Signed-off-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
> > ---
> >  include/linux/set_memory.h | 17 +++++++++++++++++
> >  mm/huge_memory.c           | 13 ++++++++++---
> >  2 files changed, 27 insertions(+), 3 deletions(-)
> >
> > diff --git a/include/linux/set_memory.h b/include/linux/set_memory.h
> > index 3fe293cfed8c..ed9ce04b18a1 100644
> > --- a/include/linux/set_memory.h
> > +++ b/include/linux/set_memory.h
> > @@ -54,6 +54,23 @@ static inline bool can_set_direct_map(void)
> >  #endif
> >  #endif /* CONFIG_ARCH_HAS_SET_DIRECT_MAP */
> >
> > +#ifndef set_direct_map_ro
> > +/**
> > + * set_direct_map_ro - make a direct-map range read-only
> > + * @page: first page in the direct-map range
> > + * @nr: number of pages in the range
> > + *
> > + * Make the direct-map range starting at @page read-only and invalidat=
e stale
> > + * writable translations before returning.
> > + *
> > + * Return: 0 on success, or a negative error code on failure.
> > + */
> > +static inline int set_direct_map_ro(struct page *page, unsigned int nr=
)
> > +{
> > +     return 0;
> > +}
> > +#endif
> > +
> >  #ifdef CONFIG_X86_64
> >  int set_mce_nospec(unsigned long pfn);
> >  int clear_mce_nospec(unsigned long pfn);
> > diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> > index 54494c3fa983..742283b36d74 100644
> > --- a/mm/huge_memory.c
> > +++ b/mm/huge_memory.c
> > @@ -42,6 +42,7 @@
> >  #include <linux/pgalloc_tag.h>
> >  #include <linux/pagewalk.h>
> >  #include <linux/cleanup.h>
> > +#include <linux/set_memory.h>
> >
> >  #include <asm/tlb.h>
> >  #include "internal.h"
> > @@ -291,10 +292,16 @@ static int __init huge_zero_init(void)
> >       huge_zero_folio =3D alloc_huge_zero_folio();
> >       if (!huge_zero_folio) {
> >               pr_warn("Allocating persistent huge zero folio failed\n")=
;
> > -     } else {
> > -             huge_zero_pfn =3D folio_pfn(huge_zero_folio);
> > -             count_vm_event(THP_ZERO_PAGE_ALLOC);
> > +             return 0;
> >       }
> > +
> > +     huge_zero_pfn =3D folio_pfn(huge_zero_folio);
> > +     count_vm_event(THP_ZERO_PAGE_ALLOC);
> > +
> > +     /* Highmem folios have no permanent direct-map mapping to protect=
. */
> > +     if (!folio_test_highmem(huge_zero_folio))
> > +             set_direct_map_ro(folio_page(huge_zero_folio, 0), HPAGE_P=
MD_NR);
>
> Assuming we keep the page-based approach, can't we just move the highmem =
test in
> there?

Hi David,

We can move the check into set_direct_map_ro(). However, on x86,
set_direct_map_invalid_noflush() and set_direct_map_default_noflush()
also expect callers to exclude highmem pages.

Would it make sense to make highmem a documented no-op for those
helpers as well, so the direct-map APIs handle it consistently?

Thanks,
Xueyuan
>
> --
> Cheers,
>
> David

