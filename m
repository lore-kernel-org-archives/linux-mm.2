Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9754ECD4F54
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 10:33:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D23A36B0005; Wed, 20 May 2026 06:33:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD3EC6B0088; Wed, 20 May 2026 06:33:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC2E76B008C; Wed, 20 May 2026 06:33:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A608A6B0005
	for <linux-mm@kvack.org>; Wed, 20 May 2026 06:33:41 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id DB876C117C
	for <linux-mm@kvack.org>; Wed, 20 May 2026 10:33:40 +0000 (UTC)
X-FDA: 84787437000.14.2F492DE
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	by imf03.hostedemail.com (Postfix) with ESMTP id D4E7B2000C
	for <linux-mm@kvack.org>; Wed, 20 May 2026 10:33:38 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=YfGJbUz4;
	spf=pass (imf03.hostedemail.com: domain of qkrwngud825@gmail.com designates 209.85.218.43 as permitted sender) smtp.mailfrom=qkrwngud825@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779273218;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CuNkcUrfA5La6Ov2pSAQWUelqrEhmV3emRmHUdz7AgI=;
	b=TR9LR/nkFf52hMQkNe0GMhy0aFtPUp0IJlfHPSPMXkdz1W8sVpzKoBj8WsEMt+24Dgbf/D
	yEkxOjwrk0YioQvi1W1elGFkma91GYbn6ZajD1KrN6tQ9kKYDw94Tizmow33dPy0sJanXy
	+zDpYoEgClUVihVtgyc6hVtfOgupJPw=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=YfGJbUz4;
	spf=pass (imf03.hostedemail.com: domain of qkrwngud825@gmail.com designates 209.85.218.43 as permitted sender) smtp.mailfrom=qkrwngud825@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1779273219; a=rsa-sha256;
	cv=pass;
	b=PFdmOqpoXGnyigTXv66dPZJY6SHhlo0s+v9l2+AMETDRSMx04K0ootZpJGSskPidZ6kT38
	xTBLjel6tD97GIc+dZySoikpbi1G1AKUZSzqtS0MDAs7JWfF/3mv1ax/RDbBS+gPLbCSbT
	Hseg226qwafrlduSvDZUbCYDXJ2pkRM=
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-bd2e8931915so1140736566b.1
        for <linux-mm@kvack.org>; Wed, 20 May 2026 03:33:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779273217; cv=none;
        d=google.com; s=arc-20240605;
        b=FO6Ndw+2nqht1A4X6Ue9CvBIEwwvbwEkGqe602YFimB1jP8kzCm3EI18cHzvB8sNCw
         sxv5jgGjn+6KEzBKXsYxb4vT1oYwNlipdEfaR8wl1y0O2JZSWR4CEV4P34d7hA19pcT9
         oagSU2Cd/qtstAKs8p4I+7tUmFEZyQpbJHgpkyL8n/YkvM2LzwwOZBMjHusRm3vJ+xck
         UsuKR8iL9f6APF04Epsyiw7WJMpfwF7l9uptw48rm4gyl2Y2WG7A8W+IWkMH+5x3aQTI
         ilbvadW/fwKJzDikti0Lz4MZ1x7WDwfojbhJ+I6MXN44z6sv6F5zj1o+7Qa55aTuKq9a
         fd5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=CuNkcUrfA5La6Ov2pSAQWUelqrEhmV3emRmHUdz7AgI=;
        fh=Uplrmwu72TKmJOLgwV4nS+0O+3WiSbMt6w21kIZoJuE=;
        b=H4bvY1YaKTS/gO7Mjd+H9pIw7WrWYG/Hf/J4c2gbBaAZvUqRgOysVsS4UiDorLTYQh
         FUAUkXYgpONtV0VtjCLj3JAl6Othn7nbq7gRHnLHn4EOldAQOsamxdoHsFhRWasme2sC
         xPcdqfyfw27AmDNW1ybga7Nywx4PFOQV0A0zVsz7PojgyMkdNahNOOC+qRYYQB3bmd8B
         E7ESwoaqMCyrY7aOrwfuUPalnRc7qfsott8qKtSQeW9D3KILKDfx6P3bWDApa8n8H1D4
         ECZfcq62xSK2z0YenB9NoPcXBDEKOT1X3qO2MiAaMz1eN9aCXpl3yp5t+5q/JIbEgnoh
         TohA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779273217; x=1779878017; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CuNkcUrfA5La6Ov2pSAQWUelqrEhmV3emRmHUdz7AgI=;
        b=YfGJbUz4fKeXhkyQRxZ6e649ilgUahzvANe0dODwlDqnSMBy3RuLiggvWLZB/UwMPS
         9asaoqXJvmOQIvw16Mu5bm88RdDv9nY0kw+FVMyUytah3nnVlma+V3qztH0CBxMXuyOH
         viVw3rZMiE8pEfiLwLWp+APc6nWhBoIIIlHVZB7i5ZeUqH4vEkqIzUwLdVrp5X0sU4jT
         ZdZ6E9Q9UfWVBzU9dJM7MJQoGWi2wGsvcW5xXMgufN7QwtvJW+RJ5YdCGxmONjCwWjE9
         lgGoNtL1g5jfYNhPD6nZoxMIt7WQT8ItcEn1tQ9sOzh3WrDG6vuSeS9vfzUHVed8Nn1x
         jcOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779273217; x=1779878017;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=CuNkcUrfA5La6Ov2pSAQWUelqrEhmV3emRmHUdz7AgI=;
        b=ROho3cDlZ4EKk8f5vGqzmsWkrYZb5YFNzyS0jZQSuodc+BuUmtTF9T6kcb84jmiqkh
         P+v0rp9l4qQ7WzVTrpPHIWYXVeQCdc71LuSfaAzpxcBsMHtzWn2285LkNdLpBG0BAoY2
         9hgyuPEO06ySQURJSgjHrejGfFS6hdrAS0Z2Xd2Kfjk6UjfHHattAx4J8CU6zYrLb4os
         qXlCVZq7EURvQtAyuQcYvwvMamdl8FMz2/43anijsLxL6aACgs5fI1FEzOxu6WaDcK6z
         KAgL7mHVkB8lH7R6JsadB14qVYrxYL1FC+V6Xk/xswDmaDTlOdVUu4Q2VJ1ypQuh4cls
         Atmw==
X-Gm-Message-State: AOJu0YxE92Q0VLZ84StaFiaV8q41kCdZf/gZCymTVhbFBFy8zMH0ylke
	2Vmsb1TH5UWWnKWrke2HKZseshNyq8eIH8iwVf8H/AvKn83DsUiDSWgHj1ISQvenw1vpffkxSEx
	MhWh6Oav6Fgu6k82hlOYpgd2nBXaKK60=
X-Gm-Gg: Acq92OErxXAHeJCgj6bt8k0t+LUqA/GPNbvr0dItfMAqx8ExfaiOSm33qV1fxRAf6xD
	Gfg5NpODXMXmjVXjBCNQ1o7HkpWozDjJ09iUhZwvys9UDsK7VzsV0BPEPxXMHSs4vv4EnivdyMZ
	ln4XQ0vOgNj90O7qwqndlf3NKXhKRwrT3j4XwUZeYMSMZ+NffMzoPaGs990g+ROPDeATzaxpbOp
	VnYKc4/FaafeUFtgq6LKR1KVbYuk7kdUwQZzjw0aiPCXBDubb3TlbXbKBDppj/QUK8aDpEdVBD0
	pwK3IJBelNNi7M2GGTLERx2l7PBfNmzh8aecFOmw
X-Received: by 2002:a17:906:4fc4:b0:bcf:6ba7:4bf8 with SMTP id
 a640c23a62f3a-bd4f34bd118mr1396926266b.26.1779273217009; Wed, 20 May 2026
 03:33:37 -0700 (PDT)
MIME-Version: 1.0
References: <20260519151008.1399226-1-qkrwngud825@gmail.com> <e9a08bed-3d5f-4606-8d17-80a16a4c82f1@kernel.org>
In-Reply-To: <e9a08bed-3d5f-4606-8d17-80a16a4c82f1@kernel.org>
From: Juhyung Park <qkrwngud825@gmail.com>
Date: Wed, 20 May 2026 19:33:24 +0900
X-Gm-Features: AVHnY4IeL4rkcfGD6vJpoWHJPVsVY0mlOdz31w-7ieRtyfoF4Q7rZALT5Z8EpPQ
Message-ID: <CAD14+f316+wMZNm_sJF6ULRDUD9EbkdecdDwhGQKcsu70Bdp0w@mail.gmail.com>
Subject: Re: [PATCH] x86/mm: fix vmemmap leak on memory hot-remove
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-mm@kvack.org, stable@vger.kernel.org, 
	Lu Baolu <baolu.lu@linux.intel.com>, Jason Gunthorpe <jgg@nvidia.com>, 
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>, Oscar Salvador <osalvador@suse.de>, 
	Andrew Morton <akpm@linux-foundation.org>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dan Williams <djbw@kernel.org>, Dave Jiang <dave.jiang@intel.com>, 
	Vishal Verma <vishal.l.verma@intel.com>, linux-cxl@vger.kernel.org, 
	nvdimm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: naouqgpnqdq78r83e9eub1g69q6op111
X-Rspamd-Queue-Id: D4E7B2000C
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1779273218-398409
X-HE-Meta: U2FsdGVkX1+zZNNKOBHq/IbFzkk1kDhTQKSdhL0mYyYFjNk5YE/1jZCCcOmX42uXKCGC48J0PsVe+4Tvk47emjMg/sNTwgXiaCm+p3wcYH3ccBIykBYSqdMn0oy2i7S4zbm1/w/BZTJgzxgMRfO9LNzsusbwmGPBmT3yKuMAWeCISijHiMYxHvjylnNUjaXdinV0zLyxDfpD6xY6vUJ8FB17sIGUigXbhVCk73mXW5A3cAUY7FEi2nm7XCHXJ1lQzUV6H0UeDKs8daTzC4d90jnv5jk/n1dUD8MKtCD8LjbV4MfYnirs/5qptG38EdNjvTAp8yLE/fMMF4Q9JbNIEUXId85HBaue/CFhBmyhkxIiaiMKjFAHm6txhIhmzYvRTw63oy88CIyvF5bdRKDKmnNbD//xOnwvO7VNrHzreEH8kYhLCOM1gC+GXhZz//TVMK94uEVF32VBQfhtdKeZfIpw8dNq6TRfqHw8jeklO2fNeFb6gb6J43y6XzVGTUmEZ37S+QI/tWcDKq5Yu3dOUFlOJiHg5PtKoyyEktROXpaWs6nksZitDXgxMUHAkll7KnkoMyN7thIrLqpKjy7K2M2yg4Y/DK1+Ve2VB6ecooq2FcZhjp5uwmYTNF/yP+s8iayPFTUfGUpU9t2Z8dcmuxtfZtrxsxEytgWXwcF7x9/XsK2CCdGqioeBSEPi9pqRJz/+YXa9xURhvfkUi7PQ1SYRogw5Af8ZfL/7oC97q4HQDnufKd8BNfYKoH1xK9tEZuLNH3uV6/krrifo+bzlF7Aew09l6NOOymAPirdE6lj1hrZbCppKTldaH5uEzB1zeuFnv/XoKF8M2Yz5iaPsegDV0ymylsT7B1fjdCr8HGidgFVrw3CC7KK1FQoNzKaGqK8fLzQQxVKpLdNmccuYiC0g73rM5uoroejpDEHt1SOwuH3hkIRNQiz/HGe4q8sqg+CQKN1tjbGEDNZ0M/a
 dCMjhwjk
 4FE6rFmC/00TKj8iz7Hs8k+9Llg/2rrEUvZsKBPzneOwCyaxE8CbAxFo5laafM9+ofs0YImkERww+Cj3nFYCSYcWlX8/36ryzdE+L9wQ5YiCS6RHDx4e/tzJU+aTzAzJ5g9Wh8sl/9d/+ke+usHyhL57ejGX8eGaPzvExoRwh20hi/5/+E+pXcWWmUndox6zX7QvRIILrM7XEcXpk0J1f7yqsL3n7oMJ8+XiV018AJoszNBsaoORrRko1OGpGwamq7TLn+1TH/L3RkgPZKL2CSqTSlSkFMobtT7Migsugewd+xsxR7vdyP2EQwXyuzwLade+tE0WSfg2S2lRIxhGFCnVo2XJi3W3O5BpfCOl/UMRAfMrp2P8Si49mYcaLnaq+nbCxAhxS8b+DP5kS6OE54J4fO91rnrqfvyXXWHWeuTx0tSy/xeo3VvfYsWB8d/sW0uorrxF+4O/4Gm+0nXXy2hMv5sIzOLwVOGaAJnh8kyDwOUQM/N2WZcY9PiLrbfsDaUfVHN2KNux4Siqn60whRXkgLBZBDxL2vT5NylntObJAPH3y1q0gGb0r9IqVZJ1dUd/v2wNdWFqN2Kb6TdbVLf5VLh1IZSy2CVdrSjf8Pr3BAYASvAbtBmOorNSwHKnn0KTCs6WfomLBgLPr2IHzsae6QVpsDnEQ1a4CZ11hkDeJMeaWckzCq39kew==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Neat. Any sign of it getting merged?

Thanks.


On Wed, May 20, 2026 at 2:24=E2=80=AFPM David Hildenbrand (Arm)
<david@kernel.org> wrote:
>
> On 5/19/26 17:10, Juhyung Park wrote:
> > free_pagetable() is called via free_hugepage_table() with
> > get_order(PMD_SIZE) =3D 9 to free the 2 MB vmemmap PMD leaves that back
> > struct page arrays on x86_64. After commit bf9e4e30f353 ("x86/mm: use
> > pagetable_free()"), it goes through pagetable_free() instead of
> > __free_pages(), and pagetable_free() ultimately calls
> > __free_pages(page, compound_order()) which ignores the explicit order
> > argument and infers it from the page's compound metadata.
> >
> > The vmemmap PMD chunks are allocated by vmemmap_alloc_block() using
> > alloc_pages_node() without __GFP_COMP, so PG_head is not set and
> > compound_order() returns 0. Only the first of 512 pages of each PMD
> > chunk is returned to the buddy allocator on hot-remove; the remaining
> > 511 pages stay allocated and become unreachable. Generalized: roughly
> > 16 MB leaked per GB of hot-removed memory per cycle.
> >
> > The leak affects every memory hot-remove path on x86_64 when
> > memmap_on_memory=3DN (the default), including dax_kmem, virtio-mem,
> > balloon drivers, ACPI memory hotplug, and direct sysfs offline+remove.
> > memmap_on_memory=3DY avoids it because free_hugepage_table() then takes
> > the altmap branch and does not call free_pagetable().
> >
> > Reproduced with CXL memory toggled through DAX in a loop:
> >
> >   daxctl reconfigure-device --mode=3Dsystem-ram dax0.0 --force
> >   daxctl reconfigure-device --mode=3Ddevdax    dax0.0 --force
> >
> > Fixes: bf9e4e30f353 ("x86/mm: use pagetable_free()")
> > Cc: stable@vger.kernel.org
> > Cc: Lu Baolu <baolu.lu@linux.intel.com>
> > Cc: Jason Gunthorpe <jgg@nvidia.com>
> > Cc: David Hildenbrand <david@kernel.org>
> > Cc: Mike Rapoport (Microsoft) <rppt@kernel.org>
> > Cc: Oscar Salvador <osalvador@suse.de>
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > Cc: Dave Hansen <dave.hansen@linux.intel.com>
> > Cc: Andy Lutomirski <luto@kernel.org>
> > Cc: Peter Zijlstra <peterz@infradead.org>
> > Cc: Thomas Gleixner <tglx@kernel.org>
> > Cc: Ingo Molnar <mingo@redhat.com>
> > Cc: Borislav Petkov <bp@alien8.de>
> > Cc: Dan Williams <djbw@kernel.org>
> > Cc: Dave Jiang <dave.jiang@intel.com>
> > Cc: Vishal Verma <vishal.l.verma@intel.com>
> > Cc: linux-cxl@vger.kernel.org
> > Cc: nvdimm@lists.linux.dev
> > Assisted-by: Claude:claude-opus-4-7
> > Signed-off-by: Juhyung Park <qkrwngud825@gmail.com>
> > ---
> >  arch/x86/mm/init_64.c | 7 ++++++-
> >  1 file changed, 6 insertions(+), 1 deletion(-)
> >
> > diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
> > index df2261fa4f98..a2301bddb647 100644
> > --- a/arch/x86/mm/init_64.c
> > +++ b/arch/x86/mm/init_64.c
> > @@ -1024,7 +1024,12 @@ static void __meminit free_pagetable(struct page=
 *page, int order)
> >               free_reserved_pages(page, nr_pages);
> >  #endif
> >       } else {
> > -             pagetable_free(page_ptdesc(page));
> > +             /*
> > +              * Use __free_pages() to honor @order: vmemmap PMD leaves
> > +              * freed here are not compound pages, so pagetable_free()
> > +              * would lose leak 511 of 512 pages per 2 MB chunk.
> > +              */
> > +             __free_pages(page, order);
> >       }
> >  }
> >
>
> I sent a proper fix for this already:
>
> https://lore.kernel.org/all/20260429-vmemmap-v2-1-8dfcacffd877@kernel.org=
/
>
> --
> Cheers,
>
> David

