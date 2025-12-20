Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6816FE668A7
	for <linux-mm@archiver.kernel.org>; Sat, 20 Dec 2025 02:27:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CAD936B0089; Fri, 19 Dec 2025 21:27:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C851C6B008A; Fri, 19 Dec 2025 21:27:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BAE616B008C; Fri, 19 Dec 2025 21:27:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A9A426B0089
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 21:27:37 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 381EE139BD0
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 02:27:37 +0000 (UTC)
X-FDA: 84238263354.21.3FBB028
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 7A55B120006
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 02:27:35 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=chNtVVpz;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766197655; a=rsa-sha256;
	cv=none;
	b=xwyVsZ/MX991hCZffJRk/ChRpuu57Zjmzh9yOYKUBLvga4wpVvhLh9gcWH9hXSz+zmxAwT
	nrpGoK0T6/KarEuRbE2lGh/Mf3/GH0qcsSjKzkmrteWVU6TjK5cKHGJLbK8qWr0J+S74nW
	eUAKjiQsHlyzVkHNnoIIoPNkiDIauhE=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=chNtVVpz;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766197655;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zElPwkkKCTpgywLCxZoiTR8/3qzdGiW3Zx7g5xyPThE=;
	b=sOANGHDlW1h8o2xX7qClS/l+/inhYqeui1fw+0cdKB8YrebBSdCmxIRnaCeN1hg6ZjZ07S
	Lz0gqsdja/6t9TLO88/g0Ccy5t2MMiroxn75e7JP2V6nzIGF1vU5q0FHYvehCzCq3skkGm
	tQZXJZBb9IGtq4CtrgbVeebpwdS4F8Y=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id BB05B4369E;
	Sat, 20 Dec 2025 02:27:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A908FC4CEF1;
	Sat, 20 Dec 2025 02:27:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766197654;
	bh=8gJbQgrMoqDVTMXtu843sIWuj5pklhAvmPm/aifE1ko=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=chNtVVpzYpRYAj8/vIOo8wxb6sD4anNSHoDTf3VFoTfx2iuUoEfN7p/hOZ70kpLPJ
	 2tqiaWsvEBz4295hBXG+7i7rkrPyjhKHbz2aoWLFko7yBXGtgrri8NkQM/fyJXTwp+
	 aboma+arqiJoas03/CAS9S1b6A+yu1PBBOeW4xu6AWnYMpA4W1fvXyRA6DNEpORmFK
	 q9ZQVsgiqG4R1QYGIA8TIS23Izw7o1BmPziPcazKjwEmSK3M+VdEVhGDCrGFu30NNI
	 Np07K9faJCdOIwFse2aXsfKpmAGY/tXErS0HIazzb6FCMlJG7zCz4QgkvJlq56DD7J
	 woqh8h76j4HyQ==
From: Pratyush Yadav <pratyush@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Mike Rapoport <rppt@kernel.org>,  Evangelos Petrongonas
 <epetron@amazon.de>,  Pratyush Yadav <pratyush@kernel.org>,  Alexander
 Graf <graf@amazon.com>,  Andrew Morton <akpm@linux-foundation.org>,  Jason
 Miu <jasonmiu@google.com>,  linux-kernel@vger.kernel.org,
  kexec@lists.infradead.org,  linux-mm@kvack.org,
  nh-open-source@amazon.com
Subject: Re: [PATCH] kho: add support for deferred struct page init
In-Reply-To: <CA+CK2bDLkf=5Mk0XH2XvUFS1px4cROBRjO+eKd4zvgzrS=Z-xA@mail.gmail.com>
	(Pasha Tatashin's message of "Tue, 16 Dec 2025 10:51:57 -0500")
References: <20251216084913.86342-1-epetron@amazon.de>
	<aUFJH9xzJXYOt_X8@kernel.org>
	<CA+CK2bDGvgcGJijAtSSa2k_FWjnZXm2jRiFd6Z9-XjEQ-Y68DQ@mail.gmail.com>
	<aUF4fsWwD9BswkFh@kernel.org>
	<CA+CK2bB2mn5b0N9gs1UavYLUQhbpVvdo702oHZa15E9OaZkKWg@mail.gmail.com>
	<CA+CK2bDLkf=5Mk0XH2XvUFS1px4cROBRjO+eKd4zvgzrS=Z-xA@mail.gmail.com>
Date: Sat, 20 Dec 2025 11:27:29 +0900
Message-ID: <865xa1khv2.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 7A55B120006
X-Rspamd-Server: rspam10
X-Stat-Signature: 1s6mm84u96bwstmp4785u7q6at5zao8e
X-HE-Tag: 1766197655-465149
X-HE-Meta: U2FsdGVkX1/Zxkjbgiqd4Ik2NPdRs0gm7Ic4TbHTlJd0DN+axuSqo3rX45hoBTsYOQ62QJUS8EfOfHGrliyrGaFHlq504Uvdf23UcJaEOCkrzropiz45KaDUkfvVZxvRQyst5s2dUtIQsLMv3wn4r4DbyJO4op3xqH0uBPuB2XTlKyJJn/3vV0CNdKKcSLNzQ1QREf7cmgQ09OR43DetYy+IX7boxrRq9lND5w0TxTMgAvEumRd6OM536F/QfAkBvLsGgj5ugptyjJFDEdJqpvO56CBOyruoNRBu+i6zYjR4Kwi1TFnmOWhZxyZSH5JoQNrqdPCLI0ca8TLK1llw75ey4ULG1mx56rMLgIIfdDXQ4BD+34bWCSZbI+AJDnEuWiTpFVXwc/x4lnd8bw59yHp2XH9fP2Dx/IrXr8b75CtoxrFo+9JojfD99+kGIQLuMhP3q8IVRZdec902QxrAnkXRpMI4Vbd7JQnP4IKZhOAmRbwkR0E8bCeITRyNvjYEPKYLfTNLvVg6/Rf9U6GkHeRoIE9c0hR+L4ptugxdzdzxq6fAQc4TqsdKAdvEHR/VD4hLHrD1RogkEV1o6ruQ7iDZPDyKqNylHeQnMs07alT43Bz+1eAOyjMOdzVQcONSPFG+GVaW2V+P0Wu9+pMSQurVkOZJcNgWm+aEaB8UhRghkpWlqJANTBSLQFDBX06m6lekMzFquGZiFsPIEWCKHnpgK1IMwaTKtujN5R6NK/X5SEF/z38o0PVcpVw9/f27XAcMGn/1B4vycgmWI8LzQu3sR5M8zH5x/5zkd1ZjNvOr8MBKWMxneVnQFJdpsVDOiKSdo2TlJceASgvsmBpSLSHZvgOfl1JMrfEdNmcw+dfj2bUGgAAVx31iD0HHROR2lkzrXv++BV4B7MOWzbeFP/mt1umXIgNun83eKdkFG0umDUGYvxL7pM22DfXp45s6WFvPsqZNhkOGZFglyvY
 dQglS/wf
 EQ2YGeBXij7axFLy5+SIi46fCy6RKiTiQTFo1PpdH0y2iEY4lCUx7SO+JDmAqzoL0OyPK0tN0POCJY8LH8ZMJzAUUJHT/g66VsOLfFYvKP1+boXoQByycGM7XGQEygjuyAqVSppnUeDb2u2Aca4/q7Rk6FJUh7uSjX1Tf5iv57Q4EPZ5srVkItxyZ6gw7EtwmPIsE6TwLHNR/MWz1TUgu1y+p8yIznivjZHyFqdafn3DPp1BaifLuAf7wzK21lzkKdoC35220LMibX7YzUydCkUpalZGCkMsSpNqZLAp0zIDogPf8NiMxabdh4g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Dec 16 2025, Pasha Tatashin wrote:

> On Tue, Dec 16, 2025 at 10:36=E2=80=AFAM Pasha Tatashin
> <pasha.tatashin@soleen.com> wrote:
>>
>> On Tue, Dec 16, 2025 at 10:19=E2=80=AFAM Mike Rapoport <rppt@kernel.org>=
 wrote:
>> >
>> > On Tue, Dec 16, 2025 at 10:05:27AM -0500, Pasha Tatashin wrote:
>> > > > > +static struct page *__init kho_get_preserved_page(phys_addr_t p=
hys,
>> > > > > +                                               unsigned int ord=
er)
>> > > > > +{
>> > > > > +     unsigned long pfn =3D PHYS_PFN(phys);
>> > > > > +     int nid =3D early_pfn_to_nid(pfn);
>> > > > > +
>> > > > > +     for (int i =3D 0; i < (1 << order); i++)
>> > > > > +             init_deferred_page(pfn + i, nid);
>> > > >
>> > > > This will skip pages below node->first_deferred_pfn, we need to use
>> > > > __init_page_from_nid() here.
>> > >
>> > > Mike, but those struct pages should be initialized early anyway. If
>> > > they are not yet initialized we have a problem, as they are going to
>> > > be re-initialized later.
>> >
>> > Can say I understand your point. Which pages should be initialized ear=
lt?
>>
>> All pages below node->first_deferred_pfn.
>>
>> > And which pages will be reinitialized?
>>
>> kho_memory_init() is called after free_area_init() (which calls
>> memmap_init_range to initialize low memory struct pages). So, if we
>> use __init_page_from_nid() as suggested, we would be blindly running
>> __init_single_page() again on those low-memory pages that
>> memmap_init_range() already set up. This would cause double
>> initialization and corruptions due to losing the order information.
>>
>> > > > > +
>> > > > > +     return pfn_to_page(pfn);
>> > > > > +}
>> > > > > +
>> > > > >  static void __init deserialize_bitmap(unsigned int order,
>> > > > >                                     struct khoser_mem_bitmap_ptr=
 *elm)
>> > > > >  {
>> > > > > @@ -449,7 +466,7 @@ static void __init deserialize_bitmap(unsign=
ed int order,
>> > > > >               int sz =3D 1 << (order + PAGE_SHIFT);
>> > > > >               phys_addr_t phys =3D
>> > > > >                       elm->phys_start + (bit << (order + PAGE_SH=
IFT));
>> > > > > -             struct page *page =3D phys_to_page(phys);
>> > > > > +             struct page *page =3D kho_get_preserved_page(phys,=
 order);
>> > > >
>> > > > I think it's better to initialize deferred struct pages later in
>> > > > kho_restore_page. deserialize_bitmap() runs before SMP and it alre=
ady does
>> > >
>> > > The KHO memory should still be accessible early in boot, right?
>> >
>> > The memory is accessible. And we anyway should not use struct page for
>> > preserved memory before kho_restore_{folio,pages}.
>>
>> This makes sense, what happens if someone calls kho_restore_folio()
>> before deferred pages are initialized?
>
> I looked at your repo. I think what you're proposing makes sense, and
> indeed it will provide a performance boost if some of the folios are
> restored in parallel. Just kho_init_deferred_pages() should be using
> init_deferred_page() to avoid re-initializing the lower memory pages.
> Also, I am still wondering how it will work with HVO, but I need to
> take a look at Pratyuh's series for that.

The HVO optimization happens when the file is retrieved, after all the
folios are restored. So that is long after deferred page init. For my
series both approaches should work.

--=20
Regards,
Pratyush Yadav

