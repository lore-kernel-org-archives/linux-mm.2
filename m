Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 29BED606A336
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 12:50:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nHR5/gGO
Received: by kanga.kvack.org (Postfix)
	id 48FE66B05B7; Tue, 17 Nov 2026 07:50:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 441036B05B8; Tue, 17 Nov 2026 07:50:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 292F96B05B9; Tue, 17 Nov 2026 07:50:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 02ED76B05B7
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 07:49:59 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7D4A41A0410
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 12:49:59 +0000 (UTC)
X-FDA: 85444593318.10.3F14563
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id E53AFA000C
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 12:49:57 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="nHR5/gGO";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794919798;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7CVx8eyIjx97gyeGE7phNgEBAaqqOaj/2GwlNjxj/eE=;
	b=iRxZFMtyGgipUH9LoFrFM0ns+6CCa1bdJoQJ/nxn85fKniUGQgdd/UBpi7R3JeAlSvZu01
	mRtVYtCF2nK29wONEfVzrUQMib4O7YgWPIBEsy9c0+oeRBsLOHDs/T+wokWVI87GzoD8N7
	aUczB/T+skAo6IXCByIYWvOI9JqIMew=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="nHR5/gGO";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794919798;
	b=LA+BSdjzX4jJ9DxSa9fFCS4QX+GOQxvkkr2vCxpHOP4hvYCQ0NmhzhtUHjX+Qm0UzaoJK/
	GKpadxL2zHuIPA1VYuO8xmajOPDvoOyiBMQyPtETHKESix5EkwpFkoSOYcJHr4/tsuOO7T
	OCGntbg0cHdLQLF9olNqe11xJQp9gEQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 835CA63465;
	Tue, 17 Nov 2026 12:49:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C0C41F000C4;
	Tue, 17 Nov 2026 12:49:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794919797;
	bh=7CVx8eyIjx97gyeGE7phNgEBAaqqOaj/2GwlNjxj/eE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=nHR5/gGOdyHdxADk6FZwYYLQIzKQYmaWc1L4sKKMje+wLIwC0ZuY2cZgZx+sxJ0HX
	 mEqYh9ThCpgdvwCqgHWGoy3rdOWgcIJg3lr7m/n2HxhMoS8hvrb4KYKPLZSNCDO87d
	 Gkto5GjULHIJ1uiY+0SYvhaiOnFM2K/TfOOQg6eV8zAtJ9dkMnTDWJeG17wdzWqalO
	 HEzGtExdpk299+RmXYgex6lMYttsllnKamiv1P4zKVw/TSk+nj50LTY0wcvC2uhxzN
	 ZHI+jXd/smWzX42uYPKQ2JyMogBAE9ZQZHeD02NtrEEESykVgcv7qHf/OJggNaTe+j
	 pXBISIqqnJn7Q==
Message-ID: <sashiko-outbox-218796@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 01/10] ARM: remove support for highmem on VIVT
Reply-To: sashiko-reviews@lists.linux.dev
To: "Arnd Bergmann" <arnd@kernel.org>, linux-mm@kvack.org
Cc: "Arnd Bergmann" <arnd@arndb.de>, "Andreas Larsson" <andreas@gaisler.com>, "Andrew
 Morton" <akpm@linux-foundation.org>, =?utf-8?b?Q2hyaXN0b3BoZSBMZXJveSAo?=
 =?utf-8?b?Q1MgR1JPVVAp?= <chleroy@kernel.org>, "Dave Hansen" <dave.hansen@linux.intel.com>,
 =?utf-8?b?RGF2aWQgSGlsZGVuYnJhbmQgKEFybSk=?= <david@kernel.org>, "H. Peter
 Anvin" <hpa@zytor.com>, "Ingo Molnar" <mingo@redhat.com>, "Jason Gunthorpe" <jgg@nvidia.com>, "Linus
 Walleij" <linusw@kernel.org>, =?utf-8?b?TG9yZW56byBTdG9ha2VzIChBUk0p?= <ljs@kernel.org>, "Lucas
 Stach" <l.stach@pengutronix.de>, "Madhavan Srinivasan" <maddy@linux.ibm.com>, "Malin
 Jonsson" <malin.jonsson@est.tech>, "Matthew Wilcox" <willy@infradead.org>, "Michael
 Ellerman" <mpe@ellerman.id.au>, "Michal Simek" <monstr@monstr.eu>, "Mike
 Rapoport" <rppt@kernel.org>, "Nicholas Piggin" <npiggin@gmail.com>, "Nishanth
 Menon" <nm@ti.com>, "Richard Weinberger" <richard@nod.at>, "Russell King" <linux@armlinux.org.uk>, "Thomas
 Gleixner" <tglx@linutronix.de>, x86@kernel.org
In-Reply-To: <20261116124832.662455-2-arnd@kernel.org>
References: <20261116124832.662455-1-arnd@kernel.org>
 <20261116124832.662455-2-arnd@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 17 Nov 2026 12:49:55 +0000
X-Rspamd-Queue-Id: E53AFA000C
X-Rspam-User: 
X-Stat-Signature: h1ig5zccwf1a3cougyrqnhzc4eyu66ih
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam02
X-HE-Tag: 1794919797-312743
X-HE-Meta: U2FsdGVkX19U1qenBDkhwWIr0Sp3sCD8ZzAJAcd2DkW+p9/eoY9i1SLpSuKp69SO5H6opBY6vJ3ToqxqxxfxIcXJirAq2twObpZvEQyQyY+0PrnltVGdDKFpvpquyXFQbkHpc+yxkgz8kS0nA4Dhjtmqe9GlYRBlNSt8g88P6v9yX5Kt9vN0+ZuAv6zQvpNKxmAKl5/zuAk6cjIUj2T15EmjoXOOn+0xA5Px0Utewd1TJmiEOknI+wHr1hr5V0lpb59K59tX1GN99StmRs83hjSq/FcMbvlu+dATj7YUZXiDUIJcMlfZWl017SzP4bRSNaUgJt0Bc6vKgwtlP4n/m1FtFJA+GbKCZQblac1PeRwCk1ZvnKl2iUhYLRAtrZl9kNb/sou0s7xQaHMNJ5q/klc01yJ1F5IMhWggET2zjX/Q+xXDNXJWPz4m7FYLHhVIaHnAj3bqbc4zAx2My8fo7/1+xMln5LoqMqVOxGr4QXovmL2+LHpanga6AqKV7vKq8SFQUtt8wzqZ1bc6uH+5nxvK4fng4n+6ZePzieRpU+j9J5gOTfITYqpbPGlnnPXs+odAA1n/ZQpRYJr4fPARC3fuHY2qYQ684ak+0+wbjAxI9N6e4lEJTojzg4+mm9M3r1hidOk1K9ET9yCpD9ZXdPkKLWo2alsLr8PmA1rlLWdO4Jh38vuA+ZWK6ySTEE2EaNrWEzuRNK4ipzlUuI69e1zD2+nR8QWoJXUFr6Lpj2bCaJkpWviXG0naI3YSCsvtWI/iXHE+SWnuZjQaCg5l8CCV9QsfYIgpUxlAa0wnc/kJhPrVFVzIy00eHp8rAiNXx0l0Qa9a7JURtXht0qv6rkvld5GCWdnf8enCSRb/ohRfNRdle5sby+3pBu9aREwJH6lrxp6/cuViyzSBYwrDgUZ1z+dcrvlTRqAQKU8k9Y0Mo6s2fg+DeMTlOFgNuk1ffb8koSGSxzAn2CBhB1z
 TdpZ4/hz
 n+Y5sXR7FuwtGVc2u4TkHvgPRIO1hli5nC72B2lRtko1kRbphSP7lLpS3OVCDK0ZLTi/iH8A/TJpv15TnOztL3LkwfjMu3ijq1RDFY9mcth2GW7jd4AINc2sxV5ozdqwgpJk6nRB49bbuCJ+GWdSkBzPwsrpPebwVlnj5gWAxycBHuzvtqcFiA+JuH6JKZMZPQ0kncdaqW9I5ooeQaRrduHWVngc/o5D7N9g3FKOrdWgFP+gCdjNp1dDEOYQdhZ9OGJvuHOI2QeMaZPpZUYGjrhFb/Sslm0ohT9O3COfIf1XJnsHSFxjqtgISBARurABFPgk3bgwzCsONV3rHGDaxXscEP1NUxOLX3S/izAPSlQ5/pWGstNTIAWVjbQFwPg9KNInlb/+YgKyyPi7wFoAWq6GqCJLVTEdted++tMoZGLGg24ZSNdHZtmHyJK2pTBdSoz2Dyg9I0Whr3R//wMEtMohOe/NAf+YU8mxpIaAG6R1BVDm4S+7p+IsRFA0GbIlkTppvQphEgA+ZB3HULIJYbi6+xl00SEl0WNgc+N2nkXtvdBvo61gBeL4qnAxWuvT6pdYKLk3DRlEUY0dmT4Hj6nTXKfOfMvQOCaAzcVZCRGq1C1SwQghkcsggdxibFbgbWn57mjb7/ZxsYIBZY1nZEAiVzg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential
issues to consider:
- [Low] ARM: dma-mapping: kmap_atomic_pfn() replaced in
  dma_cache_maint_page()
- [Low] ARM: cache-xsc3l2: dead vaddr =3D -1 in
  xsc3_l2_clean/flush_range()
--

commit f8716df5db2cf8798681c350ff9ec3e69d48df95
Author: Arnd Bergmann <arnd@arndb.de>

ARM: remove support for highmem on VIVT

This commit disables CONFIG_HIGHMEM when CONFIG_CPU_CACHE_VIVT is enabled
and removes highmem support paths specific to VIVT caches across ARM cache
and memory management code.

Link: https://lore.kernel.org/all/20251219171412.GG254720@nvidia.com/

> diff --git a/arch/arm/mm/cache-xsc3l2.c b/arch/arm/mm/cache-xsc3l2.c
> index d20d7af02d10f..4770773870391 100644
> --- a/arch/arm/mm/cache-xsc3l2.c
> +++ b/arch/arm/mm/cache-xsc3l2.c

[ ... ]

> @@ -135,13 +102,11 @@ static void xsc3_l2_clean_range(unsigned long start=
, unsigned long end)
> =20
>  	start &=3D ~(CACHE_LINE_SIZE - 1);
>  	while (start < end) {
> -		vaddr =3D l2_map_va(start, vaddr);
> +		vaddr =3D __phys_to_virt(start);
>  		xsc3_l2_clean_mva(vaddr);
>  		start +=3D CACHE_LINE_SIZE;
>  	}
> =20
> -	l2_unmap_va(vaddr);
> -
>  	dsb();
>  }
> =20
> @@ -178,14 +143,12 @@ static void xsc3_l2_flush_range(unsigned long start=
, unsigned long end)
> =20
>  	start &=3D ~(CACHE_LINE_SIZE - 1);
>  	while (start < end) {
> -		vaddr =3D l2_map_va(start, vaddr);
> +		vaddr =3D __phys_to_virt(start);
>  		xsc3_l2_clean_mva(vaddr);
>  		xsc3_l2_inv_mva(vaddr);
>  		start +=3D CACHE_LINE_SIZE;
>  	}
> =20
> -	l2_unmap_va(vaddr);
> -
>  	dsb();
>  }

[Severity: Low]
This isn't a bug, but both xsc3_l2_clean_range() and xsc3_l2_flush_range()
still initialize vaddr =3D -1 with the comment "to force the first mapping"
right above these loops.  With l2_map_va() and l2_unmap_va() gone, those
initializations are dead and could be dropped just like in
xsc3_l2_inv_range().

> diff --git a/arch/arm/mm/dma-mapping.c b/arch/arm/mm/dma-mapping.c
> index fb2eb0ed7bb87..917a546af0b90 100644
> --- a/arch/arm/mm/dma-mapping.c
> +++ b/arch/arm/mm/dma-mapping.c
> @@ -647,18 +647,10 @@ static void dma_cache_maint_page(phys_addr_t phys, =
size_t size,
>  			if (len + offset > PAGE_SIZE)
>  				len =3D PAGE_SIZE - offset;
> =20
> -			if (cache_is_vipt_nonaliasing()) {
> -				vaddr =3D kmap_atomic_pfn(pfn);
> +			vaddr =3D kmap_atomic(phys_to_page(phys));
> +			if (vaddr) {
>  				op(vaddr + offset, len, dir);
>  				kunmap_atomic(vaddr);
> -			} else {
> -				struct page *page =3D phys_to_page(phys);
> -
> -				vaddr =3D kmap_high_get(page);
> -				if (vaddr) {
> -					op(vaddr + offset, len, dir);
> -					kunmap_high(page);
> -				}
>  			}
>  		} else {
>  			phys +=3D offset;

[Severity: Low]
Should this keep the kmap_atomic_pfn(pfn) call and drop the if (vaddr)
check?

52c9aa1adc30 ("ARM: dma-mapping: Reduce struct page exposure in
arch_sync_dma*()") converted this path to kmap_atomic_pfn(pfn) so that
only the kmap_high_get() branch still needed phys_to_page(phys).  Using
kmap_atomic(phys_to_page(phys)) reintroduces a struct page round-trip, and
kmap_atomic_pfn() never returns NULL.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261116124832.6624=
55-1-arnd@kernel.org?part=3D1

