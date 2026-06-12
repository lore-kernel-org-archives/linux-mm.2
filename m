Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2BC3DCD98CF
	for <linux-mm@archiver.kernel.org>; Fri, 12 Jun 2026 15:37:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 45D336B0005; Fri, 12 Jun 2026 11:37:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 434C26B0088; Fri, 12 Jun 2026 11:37:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 34A946B008C; Fri, 12 Jun 2026 11:37:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 23E816B0005
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 11:37:54 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id BF1DD140199
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 15:37:53 +0000 (UTC)
X-FDA: 84871666026.28.7547319
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	by imf24.hostedemail.com (Postfix) with ESMTP id AB197180006
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 15:37:51 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Mq8klzxl;
	spf=pass (imf24.hostedemail.com: domain of fvdl@google.com designates 209.85.128.41 as permitted sender) smtp.mailfrom=fvdl@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781278671;
	b=Ha1KoIABCepfFje176HIL+mLBMIjLTyzF7pVQGPR3pAQ16CnsocmE+xf74PrRO0vl0aXFT
	QU8QoWYCiCOXb3gpxquaL+CaezChgNbpfO9NxgygFOCDPWxsrk/YOPx7+omH4K4Tgvzkwb
	WyNhq5vtwlIuk/RPyLrklZcVLX/eUKc=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Mq8klzxl;
	spf=pass (imf24.hostedemail.com: domain of fvdl@google.com designates 209.85.128.41 as permitted sender) smtp.mailfrom=fvdl@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781278671;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bSvLr/lAiEeyR05iNmyP4S5A6xbdgQJ1b2X7JVpkEig=;
	b=lu/C2Plt1KNVBcbzDwUBADifVIJFsReDwpHR4EuoKPE7Y2ai6znb69i/gU5/JnT5+M3Fkg
	xit1QQlVhKANIPWqcYMhw/iM+v0xiEYqr/KGNRCJz3KBOgMgW+FFomPmEo8jbfHxYZ3PVm
	8puv0Q1w0Bs20aL27emdnQdXmGse7Cw=
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4891b4934ffso78245e9.0
        for <linux-mm@kvack.org>; Fri, 12 Jun 2026 08:37:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781278670; cv=none;
        d=google.com; s=arc-20240605;
        b=RPKM+6PAp7D5xxRV8PgZYETT7r9pUJhyQl91CMYejHIR4+vAO4uMdBX3ivy48f/Jdu
         dts63yXGMsbTQG6w7mUPCjom3dMgiFslVATQX4GTWs2n++de/Fudz37f/OG8NPzdxQSF
         Rs+8848ribW5cMsXROuD5ALpdqh3UlTddxB03wFSyWyhOrgaz+SKTa2j9740GY6GTHVd
         KqkN6WYQFx7Hydz+xMj50M2uZl++/gU58K/JB1ZwFbI66ooNcpTnLnAznw7eI4oObYln
         Nc5hapPcrG/NqXeGRG7iWOhHFHM7HoCQIe//sL6VKZ++Rz22lV6uggUCzBaZi0+IxLj6
         r1rw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=bSvLr/lAiEeyR05iNmyP4S5A6xbdgQJ1b2X7JVpkEig=;
        fh=Dps1stLUWNKsUHUvCbdSkoRIwclI3QrT/iDncGAs8Dk=;
        b=iSSSFcFHwdYdK6dkJl34pXXW7/hlY2Nto0x9wOMDwjAohT2PR4AN78sJ5RyuTM2lOR
         WJIAzPDUouK4fXARwphRr2dRlZeceeEl4TrzbeKh9+UmEC8SLwRmjKL014ANBsbbsIdw
         dWg+uJY2gBTi4kO5PNC7R3sVcQtdzsAaHI/K03vE1NLnsBAtbCevWARwClaodjukOx7M
         phUGYyl2TFBWZp2NrOmv8nCmfJOnGLOhtfHP1tGSVhlGbqhsTH3wenJCug9jWGmr17GR
         J1FZsCspGrM/Fu209Y3kyWPgICWnd4QGR5lGXaaxPLKCcETCfeYPQMX4WAVKUHQKRhxe
         PWhg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781278670; x=1781883470; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bSvLr/lAiEeyR05iNmyP4S5A6xbdgQJ1b2X7JVpkEig=;
        b=Mq8klzxln2icGKJu7Fi3LQVVkZK3vWZaU0eXLVopuLgZDX9SHRL0/TMVUd+G/jLCfL
         DPPLOqOEsaTFxUf6Cf2Se52YWmIPGUTjdxNfpv/NAwdQ2b9R3/Dnq/9cn+ElkbgVZBnr
         A1AHS+MUZ1Gl5Ram0Lvg42Otb1OyzKm1FRmTjYSfW6ppAjIfuyjIJU0E67OEV26KqIcy
         Ao+6L0M/vieuZDhmGI6H8IXROgAudXri57pkeS1R0JxwvvNwsQd+fCegkv9NYnzFQ6x9
         KRvX97IzGFbgUr9tbjzVxi2oaPkAd7nMSDJAyZu9PPIFql3Soaf0LEkMbZ1QtERaSJPP
         NVig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781278670; x=1781883470;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=bSvLr/lAiEeyR05iNmyP4S5A6xbdgQJ1b2X7JVpkEig=;
        b=dEmP1MQrsERByCCSfUt8bHB5joBFI4zbYsTZ/3LkAOg+DLEFfRM5il5yDIC7zM8nBM
         R8DPIkCs+xI628F/SmuA8nPAywiGzmYf1f759Q5GfjUwGi9x+7XKDowk+UuWfZ5t5WVA
         /ZTqK4mD7WUKrVTxLNlxH8Iy8SK7lY4SmLGAZTnkoqkG0MhRIrlVIpGzYO1jO7kb87qG
         eiyazkg2dss1ADSYg9QrzXHO7X5CP914HZDaWmXxioxLE7qU8ZSoNlBJPotX8Ke7dD6M
         FcfW5378pwnPyCToh8S4elfs+IutKkPBzXOUsD3cJEGNgZTvCR/cJRJrvpCHKQMTdZG9
         dFdw==
X-Forwarded-Encrypted: i=1; AFNElJ+kjowGMVfo0Yp1/pl2MAYeQ4FREqvukDwRMP7t8gK1RPxunCv+Rht+1DYE4bSOs6ysn2Hg+NNdaA==@kvack.org
X-Gm-Message-State: AOJu0YxHBUNks3zRd3wC8UKfJL0s6lcS8Dehj/qN27cEcRP7leOGcBXe
	kYco6zWhLw39Iy5kV6Db6vWlNOtbN8puPw6rWI6ZFNscPJ6LHQOj/AvYkYqVQ14RdPRYr+TlRFZ
	L//F8lYgolGHounfvY8CbKE5HwbC8QlUR3YwYH9l2
X-Gm-Gg: Acq92OHCxCuOqLQFynQe0NZoL0J0EKyDSK3TxStqEZos1AhFpO/4rjrS9N/5WMPUYrA
	3CgyMLVfLXS+hCHARkR6iszwJVMQI7KXrrmhm8cJYqoKpNwEgcHyk7YLEwhsyTsJsOT25onfxa+
	7ZFPf/qy3Nce0ZMpEeMRSqDlUNDU/uiw8g6linP2saDxLs6dDiQqU87BUtssAleZqOr38lQzDDA
	fhUBPR0x4mKthQZgi3k4bDzwkEsSFq0RatGUVTF7Z6EKs8UXauSSoVyKXe31o5i86iGExgr9efs
	tv45F+0=
X-Received: by 2002:a05:600c:604f:b0:48a:623c:8859 with SMTP id
 5b1f17b1804b1-490eabf8ed1mr791455e9.7.1781278669647; Fri, 12 Jun 2026
 08:37:49 -0700 (PDT)
MIME-Version: 1.0
References: <20260612035903.2468601-1-songmuchun@bytedance.com> <20260612035903.2468601-3-songmuchun@bytedance.com>
In-Reply-To: <20260612035903.2468601-3-songmuchun@bytedance.com>
From: Frank van der Linden <fvdl@google.com>
Date: Fri, 12 Jun 2026 08:37:37 -0700
X-Gm-Features: AVVi8Cdc4B9DOI5h_B7aQcyBPFaEKb3BaqoI3DRKTY6Pl2XtpJFskCaA7xImrJI
Message-ID: <CAPTztWYx-_A8Jq=U+OGA4y0LUWkKWJxutOzyHJ6FeR+C2gj0JQ@mail.gmail.com>
Subject: Re: [PATCH v4 02/19] mm/hugetlb_vmemmap: Fix __hugetlb_vmemmap_optimize_folios()
To: Muchun Song <songmuchun@bytedance.com>
Cc: Oscar Salvador <osalvador@suse.de>, David Hildenbrand <david@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Madhavan Srinivasan <maddy@linux.ibm.com>, 
	Michael Ellerman <mpe@ellerman.id.au>, Muchun Song <muchun.song@linux.dev>, 
	Mike Rapoport <rppt@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R . Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Nicholas Piggin <npiggin@gmail.com>, 
	Christophe Leroy <chleroy@kernel.org>, Ritesh Harjani <ritesh.list@gmail.com>, 
	"Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>, linuxppc-dev@lists.ozlabs.org, 
	Mike Kravetz <mike.kravetz@oracle.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: AB197180006
X-Rspam-User: 
X-Stat-Signature: y6antd9w7qsgwjjmogxitm9fbqr56i3t
X-HE-Tag: 1781278671-169494
X-HE-Meta: U2FsdGVkX1/SCLvSHXA7RpGUtpserEzprx/x1Q4ed56tZbePBAV+R/oJXMFHJit4r03jZFNQfTzZEej5jA15RikmjbAR0fq4PoYqR6gkKX9PlZSV3DgsmEZZWSP3e1YGQXWJqqWK2+bfhPvn5AbKA4oto8LtVsceULmYjPaSANR+XRRfB/3nYSmeohM21/Szvnv+flBVogM6Hne1f0wyAp9r+tNWa+Uebt8LWJQunYx1lqI9Oc43A7OXQycOjT4hXVnCN6+Ib44XkXsPI91HgGKIVKLCOAowABGndXHRnTHaJF3xYGop2vEcbkIY2+UOLc8Oxs8fM8dBpoVRX4gzlsByEhojbtqdT3Shrv/tngqli/YeNjoCHqI/eVYmNqWcuwCp/bnAi2JWrf/t8euGLXwlyoPhZYVz038Y8k/c733M3rMEiHM7CPCD2HeDFTMU96ehTZXLHA4t8AU8idN0T0SAFaKWdaUEfbi/ZXkMZ/FKAKVTCp+cFPJPnoyRZqgR1Q7twukbVQwBTv9LMgJl2HTLxq9FK0ZJobn5iUylGp9fRo0EvT35+xw434hVuUtw4JPL9c1v7Mb/J4pU4K8DHRXvsrYp1LFExv7lKitDXAHuSBywqhP3IB/2W6tLZppd2RMfLpCZiwlz9Za6s32KUFPFI1EcjWdE+Vql3C6AVQXTTPVn70Nx88EWWuqjS2hreuK9XfevR1yihOjzeqHygbzf/k6b8zT4YO77Q3HksNzpkWRy7A6kmMNEMnORwz5qvguJ9lJ1akFnNAfdT/ZEW0RmG66H3CP+ISMW9NHa0uyV6ky8MIRO1R/uN5M/0TKoTqAnjJtQ7JTYXJC0OVhgOO3UZ7qaalSExdnnulpgYUe8BfoCucSgL9+2b9I43fsnEcCurYd+2fnCC+IyxbfYrze1kbME49PRt11BR1VdeQTTHAmKesmKUzzNz+sSK0uCBxbObXWrQGj/tFrZnIL
 h4QpL2JN
 vi4c3LVzo3OmXfd/5WIjJWMFYp+h+oXAhpRNWk4guteGLczFGOc59/2Hk9/NeRi0T901u1x7StgMERm29c6QlHH0ziwidlS3aG/7bIu8hJPvOJiIsjfDk36SVoI5ClT4qLMtT00GowMxmpLeC24+R4mEwtg+PzYYX5ani6Mw6lIW4kHkQ6LBD0a8naEIQJgz2FtgkcrFAlwC5bbAlFFUW+B6T2cy+1CIOMfBwjH0tNaOo6Ov3J0P6ZT9/iBzDnyF/mrdaSwaomXzKHOhPgW4xfph5KJvaqbPdp4EoPj252EMFMFpwCnvtZ1oAecZX8FVACuR+4Py7E3omTw1u3052m6n+N0djO2/oKHXNRvCUGr9x4H9bMQb9m1TLPlx6+TjjAlQTK9zR3ozAS5UCLb1QUtI/Uu3ey4POhGDXENUYZhDB2SUZZkKyPBaoTg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jun 11, 2026 at 8:59=E2=80=AFPM Muchun Song <songmuchun@bytedance.c=
om> wrote:
>
> __hugetlb_vmemmap_optimize_folios() uses incorrect arguments when handlin=
g
> bootmem HugeTLB folios.
>
> The section number passed to register_page_bootmem_memmap() is derived fr=
om
> the vmemmap virtual address of folio->page instead of the folio PFN, so t=
he
> bootmem memmap metadata can be registered against the wrong section. The
> helper is also given HUGETLB_VMEMMAP_RESERVE_SIZE even though it expects =
a
> page count, not a size in bytes. In addition, the write-protect range is
> based on pages_per_huge_page(h), which does not cover the full HugeTLB
> vmemmap area and can leave part of the shared tail vmemmap mapping writab=
le.
>
> Fix the section lookup to use folio_pfn(folio), use
> HUGETLB_VMEMMAP_RESERVE_PAGES when registering the reserved memmap pages,=
 and
> use hugetlb_vmemmap_size(h) for the write-protect range.
>
> Fixes: 752fe17af693 ("mm/hugetlb: add pre-HVO framework")
> Cc: stable@vger.kernel.org
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> Acked-by: Oscar Salvador <osalvador@suse.de>
> ---
>  mm/hugetlb_vmemmap.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
> index c713c0d2593a..ea6af85bfec1 100644
> --- a/mm/hugetlb_vmemmap.c
> +++ b/mm/hugetlb_vmemmap.c
> @@ -635,12 +635,12 @@ static void __hugetlb_vmemmap_optimize_folios(struc=
t hstate *h,
>                          * mirrored tail page structs RO.
>                          */
>                         spfn =3D (unsigned long)&folio->page;
> -                       epfn =3D spfn + pages_per_huge_page(h);
> +                       epfn =3D spfn + hugetlb_vmemmap_size(h);
>                         vmemmap_wrprotect_hvo(spfn, epfn, folio_nid(folio=
),
>                                         HUGETLB_VMEMMAP_RESERVE_SIZE);
> -                       register_page_bootmem_memmap(pfn_to_section_nr(sp=
fn),
> +                       register_page_bootmem_memmap(pfn_to_section_nr(fo=
lio_pfn(folio)),
>                                         &folio->page,
> -                                       HUGETLB_VMEMMAP_RESERVE_SIZE);
> +                                       HUGETLB_VMEMMAP_RESERVE_PAGES);
>                         continue;
>                 }
>

Thanks for fixing my mistakes!

Reviewed-by: Frank van der Linden <fvdl@google.com>

