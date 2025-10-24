Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B9CE1CCD1A5
	for <linux-mm@archiver.kernel.org>; Fri, 24 Oct 2025 08:54:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D497A8E0063; Fri, 24 Oct 2025 04:54:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D21208E0042; Fri, 24 Oct 2025 04:54:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C5DA98E0063; Fri, 24 Oct 2025 04:54:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B312E8E0042
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 04:54:07 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 65FCC8935C
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 08:54:07 +0000 (UTC)
X-FDA: 84032395734.07.76987CE
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	by imf26.hostedemail.com (Postfix) with ESMTP id 68E7B140008
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 08:54:05 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=VtS4NQ5k;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf26.hostedemail.com: domain of bagasdotme@gmail.com designates 209.85.218.43 as permitted sender) smtp.mailfrom=bagasdotme@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761296045;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l23pZA4MExPiJTUB2SAni5gcYgsT0Y++tSC//ed3phQ=;
	b=SojmbN75M3v3CHRp1j+1UfAlzpkH074n9iQbpAKZGyKiUaAZVLYUcerc1yLv7hAVtno4RC
	6TJivpvYEJ7qrpCCYAb5iBZwWf70tbRSmeum9oO+VDyn8H9rNLKtH8ceHvJxi1WhZiYtiE
	SprmGje2MweBOwxCFMbPgEYXw7ULfDc=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=VtS4NQ5k;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf26.hostedemail.com: domain of bagasdotme@gmail.com designates 209.85.218.43 as permitted sender) smtp.mailfrom=bagasdotme@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761296045; a=rsa-sha256;
	cv=none;
	b=ruN0/kHiPutL3j5bQRiC4FgBBOMwx4EonDBfQamTSkSIcBvfZ26y4f6rKoCSvvPZbaBMxm
	5QwyrOY0a9n9TKTwrvnhhHoWBkvw+t0NLSwYY003HOlUEXIpdpQqTlXf18vxL/8DUHu/sI
	BnPL8ZM0qiPGyVPgyxpviVV7CeHWJ7M=
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-afcb7ae6ed0so401369866b.3
        for <linux-mm@kvack.org>; Fri, 24 Oct 2025 01:54:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761296043; x=1761900843; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=l23pZA4MExPiJTUB2SAni5gcYgsT0Y++tSC//ed3phQ=;
        b=VtS4NQ5kkAHUfx2Zl+XXsn5UqHuJhvdKNE3vIrHzvyBSepJZ/+LWw8ibgFtWYmaXbz
         3VXAJJ1HIgUicWZdEJgIdSf08DEopRnhOfXxywyfTb6AcQPttoEBFgJLcsBAHu4YyU80
         upgFBtRXYmpjrxMlBceGiF+znKxgnUHX/nZZNav6INySDLWRi2r2sIXSktF4xOF9JJYl
         ZGR1DKzTfXuoPdMbKzdcykLzDokgFoIBeC6GjQ7uIIFpbHiYuPazvpia/LWv5zBeG3yQ
         xF8grYSjoU6x52V6ZVIX5DtwfFrpwYqALbQCqOzp0TFIGiiv+Ia7HJaIyIM4pbAqWoyj
         PEpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761296043; x=1761900843;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=l23pZA4MExPiJTUB2SAni5gcYgsT0Y++tSC//ed3phQ=;
        b=wOpAAmM5cu0K89OE2Ut5a1tnlh2EcHVkO/3bBB7wUaj9yDINMU9aPIWTHRA9tiOy7p
         IR8LObufVZ4LWGn7AQ/4mg/d/j6Vl3A0+BFnvCXSHZCLad7EkB9JZL6Ow5Onlbu4w6xS
         cbDVjZKxepG8M3fE40M2agdv1qKFn32gLEuG+PGnegog6parZtx70KxTAxBSbWzMAF7a
         TLvE+URBvkUklxXVy7PvNyhk+u7ZEtZM5QP0fSMXs/q0K0YGG3wq3xZLIwmyIrxBt9nS
         s4jW2qSIda85/Ta7ARfbZuLMJe5cg961MPyEbIo/VnOo/kVvD5xkXvQz8QzdRyRguh9o
         gErA==
X-Forwarded-Encrypted: i=1; AJvYcCWIYrIxaYB3InYEeMLMQKq4gtuMlzQsQsbgqT+P6jpNiqra6+idTMMwkilFpYufeX2zYTbVeEZSEA==@kvack.org
X-Gm-Message-State: AOJu0YwNehPa5TJj4YIRLGE/CbwEi9MYu+79LbpPiHifuDGLlScwc5RL
	gFJs0z1iF+090sdr95To27Mof/sU3E7fknqg2W7oElhcFfOz4eiCbSpSl2TBDj8b
X-Gm-Gg: ASbGnct72fDR5qguiucMcf7FaB/fzGX1yym4YZ/qTDzlSBvILMtU7/k8RXGPLYhEpSK
	O27oueVHkbkTV/33+YzhQVWJGGDg2YobseBGNJNkZgKkNbo5DOk98sRhW1RrCrYpJh1uSXsEz/r
	65KCrl1rPOjXwHMFPhESMVCMxeFexnnrEMolqevR8xT5JJPbcwD8/T4SrPaZCO3fMBk6GZoY5s6
	+T2Z+ziK5YdTLOS1I4tPeHrtP6RcBS80NknWDGmHnciqPFHUfq/VJDnCbTNvHLqZEPycDN/T1yB
	gGbG1WIPNTlLGW/EXGXsn5k3EH8jYPQp48Zvq+/KDzfmwBuJJu+Kk2W+3zOE28AWoJME6d9/mxa
	WsHJUWvzsCs4v0LxqLNXdI0gMZ32U+zhCo49edArMk7xpcFKuNumBk2P7mHXBIOkfGCTCCcdOvq
	St1Vh+uY/5qI4=
X-Google-Smtp-Source: AGHT+IG51f1FpuK/7izLWH/o5CbZofEfDgwdIaDaNy8TUmUIchs6Y2k+6E/W+IMWdugb6vY2wZ04BA==
X-Received: by 2002:a17:907:3f21:b0:b6d:6a44:5fd9 with SMTP id a640c23a62f3a-b6d6ffe1c8emr161940266b.48.1761296043130;
        Fri, 24 Oct 2025 01:54:03 -0700 (PDT)
Received: from archie.me ([210.87.74.117])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b6d51472215sm461035266b.74.2025.10.24.01.54.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Oct 2025 01:54:01 -0700 (PDT)
Received: by archie.me (Postfix, from userid 1000)
	id 168394206924; Fri, 24 Oct 2025 15:53:53 +0700 (WIB)
Date: Fri, 24 Oct 2025 15:53:53 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Biancaa Ramesh <biancaa2210329@ssn.edu.in>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Memory Management List <linux-mm@kvack.org>
Cc: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] spell check: Edited spelling errors
Message-ID: <aPs-oaYxarodr7fg@archie.me>
References: <20251021173614.48249-1-biancaa2210329@ssn.edu.in>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="Qr8t8CYE95nUS9XB"
Content-Disposition: inline
In-Reply-To: <20251021173614.48249-1-biancaa2210329@ssn.edu.in>
X-Rspam-User: 
X-Rspamd-Queue-Id: 68E7B140008
X-Rspamd-Server: rspam03
X-Stat-Signature: o5oy9f8xyg35y6zzrg71xx6fron8h87a
X-HE-Tag: 1761296045-752142
X-HE-Meta: U2FsdGVkX1/rwIcToCOayp1lAvWSssd3mUSzk3PfNGYfCWF266mFrff41kAoFMOR8keZROXcfWGUZdJ4oY9ZK3ipZE4eplk4EgiC5lg42/97c6dIzAuTODyYvgWKx08YJ+rC92yC1jdLbtZnjvOm4uQM1Gd80i1gwJz6Q8C9+R8kd+G/zJVIw5vcjRvGgk/DLpdOIYCMdpwTluLxVwYHi9OsnVsOsk7FtPtSqxt5JRPGwVvS5OAY3uoPBpW57e+dV8MgveV0dm2wK70E167GyKbDYhdSSb7mX8et4ozkmQ5FzWChItmoZWLNnj/kRaLXe1gFzeRxx/eGd9mMQTtLRX1nB0iG8Igv+mVA+8Q4SUXPSTw7kWgYZD+6lrizOqJz1SqRcMVcZl/9vwJyy/CHAvJcS7+bhxLKbdJFjcoYWAOZWu+MwS+jxoxQ1HtYqhaSkIIVn87/Oj02Vvu/AGVAYCAnvIYcLxZp5yZFKonyk6P2gmhZ+6+zI2tqBEu+M2Xh5YvC6y8wWYE5JIBzDd74tSjFBAK97e0FoGNQlFmbPsr6QsmUc5/Zlln7hPnwObYK4wKbjv6EMX9HI4mprkvqfMVJUSrWpzPO7l10mXmuuDkT8Z9uPxkxBb1p2q9FUTIJKrCUIv9E6EYo1rVZsS5UWgoSJ7mJXShX83epKPKadCtaPme1IGZuC2u/fDUTOMve5ebEjXw9q2H4hASBd76WMpCrr4AJn7djmh6tZIzYK+Ww983cQXyJ0aLQKGl5f06+bpIK4lOUGHu8texxVILqmF3QMePG0rrUBSRdetvJknyxww52qofPSjRu+Itnvhj3Bn2519a3z72wgJ21lblCPQ/RXkhI6IKMbmPgXEIcd531jLHq2HpMBdEKnsm82Fq2mx1G/sNfNOPB7aZm+Bqtyq2OdJM3lOtpfk+vpXcWv1hGz2ROgGd/YmRbqlmNO65pe7EszC5WwKTaaQEZbRg
 LG2Nc0el
 3noe1S4j7NVpMPrfS01iWw5rIGNshfHc3DhBK1L+nmDQRTuSU1gCGD+KggiGgvhvzFmls//8HwxAVNB4V5YlMMdRbSVIsDlV5NJL2SxSorPXVlCfxDpen0QeAEmgkTOr4I9LBeuk3FICibL7+tU/zUNVIszia6x2KKVQIa0+6WRjWQOVbAxwbzWLji8cTcalaxI07FIulsYcujlhrrJ6o2eNHUnyaw0oxK9UX5KSgUkMyDgX0L4lpmQoqNoEgufy3xWNA+dFxQqzCsbJka0UfEQ3SHbYfCOx2am3LKFc7JfFuPAOhiWSfHTghiv947DG1IkrIOQXbhmzADRqugKzMkA7PK35IhESFkwA4X1UEwVB2SBtTewQNykMoHalW88/iePLoKFU465LL+C13eXtbX1j9Phumz9K/yviOnu30JNXLmoE/xA3ZA3qUd9aEEQUp9BZdoOuKFPLyOx7exajeshB3mxLGJP8Rc9d36k8K+0asjZ//s+4sOygHLg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--Qr8t8CYE95nUS9XB
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 21, 2025 at 11:06:13PM +0530, Biancaa Ramesh wrote:
> Signed-off-by: Biancaa Ramesh <biancaa2210329@ssn.edu.in>

As others have pointed out in all your previous patches: make sure to descr=
ibe
your changes (in imperative mood) along with appropriate one-line patch tit=
le;
and most importantly: don't add any confidentality disclaimers.

> ---
>  mm/hugetlb.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
>=20
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index 795ee393eac0..1760fa39a3af 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -2934,7 +2934,7 @@ typedef enum {
>  	 * NOTE: This is mostly identical to MAP_CHG_NEEDED, except
>  	 * that currently vma_needs_reservation() has an unwanted side
>  	 * effect to either use end() or commit() to complete the
> -	 * transaction.	 Hence it needs to differenciate from NEEDED.
> +	 * transaction.	 Hence it needs to differentiate from NEEDED.
>  	 */
>  	MAP_CHG_ENFORCED =3D 2,
>  } map_chg_state;
> @@ -5983,7 +5983,7 @@ void __unmap_hugepage_range(struct mmu_gather *tlb,=
 struct vm_area_struct *vma,
>  			int rc =3D vma_needs_reservation(h, vma, address);
> =20
>  			if (rc < 0)
> -				/* Pressumably allocate_file_region_entries failed
> +				/* Presumably allocate_file_region_entries failed
>  				 * to allocate a file_region struct. Clear
>  				 * hugetlb_restore_reserve so that global reserve
>  				 * count will not be incremented by free_huge_folio.
> @@ -6007,7 +6007,7 @@ void __unmap_hugepage_range(struct mmu_gather *tlb,=
 struct vm_area_struct *vma,
>  	/*
>  	 * If we unshared PMDs, the TLB flush was not recorded in mmu_gather. We
>  	 * could defer the flush until now, since by holding i_mmap_rwsem we
> -	 * guaranteed that the last refernece would not be dropped. But we must
> +	 * guaranteed that the last reference would not be dropped. But we must
>  	 * do the flushing before we return, as otherwise i_mmap_rwsem will be
>  	 * dropped and the last reference to the shared PMDs page might be
>  	 * dropped as well.
> @@ -6211,7 +6211,7 @@ static vm_fault_t hugetlb_wp(struct vm_fault *vmf)
>  	 * In order to determine where this is a COW on a MAP_PRIVATE mapping it
>  	 * is enough to check whether the old_folio is anonymous. This means th=
at
>  	 * the reserve for this address was consumed. If reserves were used, a
> -	 * partial faulted mapping at the fime of fork() could consume its rese=
rves
> +	 * partial faulted mapping at the time of fork() could consume its rese=
rves
>  	 * on COW instead of the full address range.
>  	 */
>  	if (is_vma_resv_set(vma, HPAGE_RESV_OWNER) &&
> @@ -7193,7 +7193,7 @@ long hugetlb_change_protection(struct vm_area_struc=
t *vma,
>  		} else if (unlikely(is_pte_marker(pte))) {
>  			/*
>  			 * Do nothing on a poison marker; page is
> -			 * corrupted, permissons do not apply.  Here
> +			 * corrupted, permissions do not apply.  Here
>  			 * pte_marker_uffd_wp()=3D=3Dtrue implies !poison
>  			 * because they're mutual exclusive.
>  			 */

The wording itself LGTM, though.

Thanks.

--=20
An old man doll... just what I always wanted! - Clara

--Qr8t8CYE95nUS9XB
Content-Type: application/pgp-signature; name=signature.asc

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCaPs+lgAKCRD2uYlJVVFO
o0JLAQDZSp866h7184IdH9rd+xrIuOZv7tLHoHkMYaBJHTQTHAD/aBgrlv9lzDzO
mxhy6eDkdKH41KYOFwRD7tJQNElKfQo=
=Je8M
-----END PGP SIGNATURE-----

--Qr8t8CYE95nUS9XB--

