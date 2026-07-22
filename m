Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 09F06C44536
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 17:34:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F397B6B007B; Wed, 22 Jul 2026 13:34:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F113A6B0088; Wed, 22 Jul 2026 13:34:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DDA626B009B; Wed, 22 Jul 2026 13:34:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B56486B007B
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 13:34:20 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3E4791201F4
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 17:34:20 +0000 (UTC)
X-FDA: 85017111480.11.FA7AF2A
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf20.hostedemail.com (Postfix) with ESMTP id 0D0141C0010
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 17:34:16 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=I2wb8lkB;
	spf=pass (imf20.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784741658;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ffF1YtoR/cZxAVUPZ8SrWZR3GBHgYP9GM5ARzRAhO38=;
	b=HRKNzhxMZoR997J3tRmI3dFAeH6zNFzPTuiPQa+iZzFGI9CCDebA2Yh/4P19VwhdN2jRXp
	/jiYxnia6v/eqqamZwJm/jb9aGPf/YF3E5NInqwKKoOwG/7d5UsKsPPl/wlKbYvgugOSdm
	HgtZp81/4+SndV5gsZfcZxb7k1GmXNo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784741658;
	b=2rHXGM5G3TB7XgjaF42EA6gjDIT7qjm8rMjYW2R/OJ2CQBwtOiJeUS3FNVfdh1p724tDCF
	EuHd0nvOjQKCX7HS24TzHWl2hwvMJvccjmrx3IpzECecmBn7dDFLA2dkmnf5gNzr8lMI6U
	BlFPHGQbkDNSlpQRXX/c25cZLcvZQZQ=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=I2wb8lkB;
	spf=pass (imf20.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=MIME-Version:Content-Transfer-Encoding:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=ffF1YtoR/cZxAVUPZ8SrWZR3GBHgYP9GM5ARzRAhO38=; b=I2wb8lkB66vP/VbwkSxq7mxq4r
	aeer3+czdNVgGMs11RQYWgqHOI4/3a0jWRwchgIAgGaMP6ywwkdse2bqvB3NYD4COWIUfLWD6Cx7V
	0tFfGvkiSJR6H434UcYf5LIQvyFOUwRap+XfzbEQXPKWz916j84NrF0KfY+J1zIzxG6kLAP1xdNXx
	8BSYx7rVi2N1dLLqE3Qda7EsYmwpb/DqkWi4blWBh7fDzqia3m0bimO6c0Ppre+BBPDzFzkQQEWNb
	zH3LyltRswVnep+b2fLB074N7VdgEPDcmjqw/jLPoAIgirLPhyGrEIvdQf7+u+UMhoOhqT6Ei6JQU
	FoEK9ODg==;
Received: from fangorn.home.surriel.com ([10.0.13.7])
	by shelob.surriel.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.97.1)
	(envelope-from <riel@surriel.com>)
	id 1wmap3-000000004NY-2BGF;
	Wed, 22 Jul 2026 13:33:33 -0400
Message-ID: <8da92b565d7ec64ea4ab2db8155a250aed0aa88b.camel@surriel.com>
Subject: Re: [PATCH v3 0/6] mm: access remote process memory under the
 per-VMA lock
From: Rik van Riel <riel@surriel.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>, 
	linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Cc: kernel-team@meta.com, Lorenzo Stoakes <ljs@kernel.org>, "Liam R.
 Howlett"	 <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike
 Rapoport	 <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal
 Hocko	 <mhocko@suse.com>, linux-mm@kvack.org
Date: Wed, 22 Jul 2026 13:33:33 -0400
In-Reply-To: <cbecbce0-475e-4817-bdda-d1f4c89698d0@kernel.org>
References: <20260717170036.743149-1-riel@surriel.com>
	 <cbecbce0-475e-4817-bdda-d1f4c89698d0@kernel.org>
Autocrypt: addr=riel@surriel.com; prefer-encrypt=mutual;
 keydata=mQENBFIt3aUBCADCK0LicyCYyMa0E1lodCDUBf6G+6C5UXKG1jEYwQu49cc/gUBTTk33A
 eo2hjn4JinVaPF3zfZprnKMEGGv4dHvEOCPWiNhlz5RtqH3SKJllq2dpeMS9RqbMvDA36rlJIIo47
 Z/nl6IA8MDhSqyqdnTY8z7LnQHqq16jAqwo7Ll9qALXz4yG1ZdSCmo80VPetBZZPw7WMjo+1hByv/
 lvdFnLfiQ52tayuuC1r9x2qZ/SYWd2M4p/f5CLmvG9UcnkbYFsKWz8bwOBWKg1PQcaYHLx06sHGdY
 dIDaeVvkIfMFwAprSo5EFU+aes2VB2ZjugOTbkkW2aPSWTRsBhPHhV6dABEBAAG0HlJpayB2YW4gU
 mllbCA8cmllbEByZWRoYXQuY29tPokBHwQwAQIACQUCW5LcVgIdIAAKCRDOed6ShMTeg05SB/986o
 gEgdq4byrtaBQKFg5LWfd8e+h+QzLOg/T8mSS3dJzFXe5JBOfvYg7Bj47xXi9I5sM+I9Lu9+1XVb/
 r2rGJrU1DwA09TnmyFtK76bgMF0sBEh1ECILYNQTEIemzNFwOWLZZlEhZFRJsZyX+mtEp/WQIygHV
 WjwuP69VJw+fPQvLOGn4j8W9QXuvhha7u1QJ7mYx4dLGHrZlHdwDsqpvWsW+3rsIqs1BBe5/Itz9o
 6y9gLNtQzwmSDioV8KhF85VmYInslhv5tUtMEppfdTLyX4SUKh8ftNIVmH9mXyRCZclSoa6IMd635
 Jq1Pj2/Lp64tOzSvN5Y9zaiCc5FucXtB9SaWsgdmFuIFJpZWwgPHJpZWxAc3VycmllbC5jb20+iQE
 +BBMBAgAoBQJSLd2lAhsjBQkSzAMABgsJCAcDAgYVCAIJCgsEFgIDAQIeAQIXgAAKCRDOed6ShMTe
 g4PpB/0ZivKYFt0LaB22ssWUrBoeNWCP1NY/lkq2QbPhR3agLB7ZXI97PF2z/5QD9Fuy/FD/jddPx
 KRTvFCtHcEzTOcFjBmf52uqgt3U40H9GM++0IM0yHusd9EzlaWsbp09vsAV2DwdqS69x9RPbvE/Ne
 fO5subhocH76okcF/aQiQ+oj2j6LJZGBJBVigOHg+4zyzdDgKM+jp0bvDI51KQ4XfxV593OhvkS3z
 3FPx0CE7l62WhWrieHyBblqvkTYgJ6dq4bsYpqxxGJOkQ47WpEUx6onH+rImWmPJbSYGhwBzTo0Mm
 G1Nb1qGPG+mTrSmJjDRxrwf1zjmYqQreWVSFEt26tBpSaWsgdmFuIFJpZWwgPHJpZWxAZmIuY29tP
 okBPgQTAQIAKAUCW5LbiAIbIwUJEswDAAYLCQgHAwIGFQgCCQoLBBYCAwECHgECF4AACgkQznneko
 TE3oOUEQgAsrGxjTC1bGtZyuvyQPcXclap11Ogib6rQywGYu6/Mnkbd6hbyY3wpdyQii/cas2S44N
 cQj8HkGv91JLVE24/Wt0gITPCH3rLVJJDGQxprHTVDs1t1RAbsbp0XTksZPCNWDGYIBo2aHDwErhI
 omYQ0Xluo1WBtH/UmHgirHvclsou1Ks9jyTxiPyUKRfae7GNOFiX99+ZlB27P3t8CjtSO831Ij0Ip
 QrfooZ21YVlUKw0Wy6Ll8EyefyrEYSh8KTm8dQj4O7xxvdg865TLeLpho5PwDRF+/mR3qi8CdGbkE
 c4pYZQO8UDXUN4S+pe0aTeTqlYw8rRHWF9TnvtpcNzZw==
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2 (3.56.2-2.fc42) 
MIME-Version: 1.0
X-Rspamd-Queue-Id: 0D0141C0010
X-Stat-Signature: c85jsxy5zgmwano9s9ek15of3ispxt4x
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1784741656-76408
X-HE-Meta: U2FsdGVkX18Nlski3jSF0w3ucFRaU1I2zexUnIsuZtO2avuVhpGURzDQx43wXxDm8XEocUrS0nlNoHaJ0ImvOjFDVvIufF/A5gCEi4WY7J/wvllS31tTDmScMk3lr/93CYseTF0RrsogasWJwAAD/clDxqGtsNfq3hEtVAVNuEkqEom1OwXCXDD3ktCEU0RyLh+y4uthTKdAzDWVsAildzj7udAAMouW8GFH9a75fBqnI/WDLNj+knzdr45wKPg2fHOEOfFAvzukZklSICyOpDC1u8tfDCF34jX5xQIxB8h5Hy4kEgzwO5AbJ5O84jJhiSD7dygsQTQcxHWn+CxuXvath1tkCLoWXQgJkExztDF10gvxJndHFVWP5Ll1leML2rPZKc9JcWcmZuNDq2fZqprYjWmN805kBX14Hgv1YaLbXPbmN0Xt0HHgGHeTguaaZc65hWv1fYj8UU0hwrnlGZnSc4oZLxSs0GQfvxpBw3KzEbZmSrireKHQ1vbjULK3RJr/p9LxD8T6O3QWA3YRFTRiMiBoMizPiSo80Sc5o/KabrpIJBgR/Rj8xS3fWUDcc5L+1x4ChrS/X/XzxYi0a7Qb06t/y5ybYnrJ0l3RrXN2Qa06AcGqRNHLmCsfyMdkqrLQmzbjXYHiVRm23/AVk+DUhg7CqJH7I3szcUy8S6KMfOIEmN0gRI/GJ4gd6UfKNyQphSgpBZKA4GtNqy1av9tnvjyJESxDAXKNhyOAqMlHYZKeUD0y8ir2WuY9fKlcYkef7kMfEAfWTA0uqd4f7b2RNrRATrexJEKENjVc0uYMfxCUTx/4C8tYit3kObpR5JbH7jB5DqeZBwKC//UxhfVqLy8yN73KyyR8FXAM36COoB//o0jaViW9/YjG3pubXA20oyB2LCW1hVZFU18hbTguS725vf0ebTth8ZebeGC9JHz0vH8/Dl//6gyiEEwc05Bn6VzuDUnGqojX4LR
 Q5xgI/A7
 auL0dkIiQdF4FusIFufkAoAkdxBMs/r98Q1Ao8xVJ6esLFlqxQV7hcYZGzucAXlxgHhkwCvayG+NAo8b6uFG1YlkFqUeR/Uwzfu9YpdS4kal87Qx8ztyB/kX/46k6f5aJyVmz1iRMzAu9lqBUC/k1V0Kzs/QWOT69V//OGEwPePQQvMm4V13JMzyNo68khy87VL5EmjbnNk/R2SVN6L4qvAEK8+4rlA8Jo1We
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 2026-07-21 at 20:12 +0200, David Hildenbrand (Arm) wrote:
> On 7/17/26 19:00, Rik van Riel wrote:
>=20
> >=20
> > get_user_pages_remote() does not fit: it hard codes the mmap lock
> > and
> > re-derives the VMA. get_user_page_vma() walks the page tables,
> > faults a
> > missing page in, and returns it with a reference and the caller's
> > lock
> > still held.
>=20
> Agreed, and that can be tackled later.

I'll stop making this series (much) bigger, then ;)

I added a few things for v4, but I can save other
stuff for follow-ups.

>=20
> >=20
> > The per-VMA path also closes a pre-existing gap. A COWed page in a
> > VM_IO/VM_PFNMAP VMA has a struct page, but the old code routed it
> > to
> > ->access(), where generic_access_phys() ioremaps the PFN and
> > ioremap of RAM
> > is rejected, so the read came up short.
>=20
> Yep. The GUP code rejected VM_IO/VM_PFNMAP for, though, because it
> did not
> properly handle vm_normal_page_pmd() etc so far.
>=20
Do we ever do a PMD sized COW on VM_IO / VM_PFNMAP
VMAs?

In other words, is this something we should:
- leave out for now?
- fix now?
- fix later?

If we can fix it later, I'll add it to the list.

--=20
All Rights Reversed.

