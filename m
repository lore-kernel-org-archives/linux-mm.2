Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 48F98CAC59A
	for <linux-mm@archiver.kernel.org>; Fri, 19 Sep 2025 07:55:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3917728003E; Fri, 19 Sep 2025 03:55:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 368EF8E0022; Fri, 19 Sep 2025 03:55:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2574428003E; Fri, 19 Sep 2025 03:55:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 147F08E0022
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 03:55:30 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B5F8986BF2
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 07:55:29 +0000 (UTC)
X-FDA: 83905239978.09.E52CDE6
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf10.hostedemail.com (Postfix) with ESMTP id 5492DC0004
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 07:55:27 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=WSookrfd;
	spf=pass (imf10.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758268527;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=osse2QL84K0KAyQfQ6mkJcBclhUlpgaOVm2/yxp2Gk4=;
	b=Y1vzTNhNjRLW78+hyo1AzOPIsxwF37qAsvZZOwocRlmz/rTDPXVB5SFakz/PsnotQQg27P
	L7WzIkOhBccmQQnHvv3e69eN4nYhHbudrbNY009BXSEbN2xAPN/zQC8TE6g7WbRy18/cbk
	TmLKTus4y03HPxPku2VE4E1lwAXPT3o=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758268527; a=rsa-sha256;
	cv=none;
	b=3Vs5FiUDd4Hh3uefYexFsePAOmpDcFOgwfDN9saSLTHdkmBoYKlHowj5XRIovZTJwSA6l/
	WbuUfgJocXMCI23inSDwvXJNgI1NeZjuIdqdzoaCQkngMLdb8RwkxpoRDZGUorfLwviG0v
	ToQarIhm1DM+qgDLYdSWn4/tDLdMgeo=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=WSookrfd;
	spf=pass (imf10.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758268526;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=osse2QL84K0KAyQfQ6mkJcBclhUlpgaOVm2/yxp2Gk4=;
	b=WSookrfd+yQqnoDskxKKasg9nkT3Vq03hd9qu6qGUiUgbWC7Eab9F3sETjXaTq5VV3m01E
	QSbCoF5/JwWCZBYB61+ad9J99bfzl+HghyOue3cKinOF+yrtTKvK53qcMAL3kFw2YuoMD2
	nBPGWLvSylphthnjFWZ8Ta75kxDPu00=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-360-EvN15mscORyJWesv5W5O7w-1; Fri, 19 Sep 2025 03:55:23 -0400
X-MC-Unique: EvN15mscORyJWesv5W5O7w-1
X-Mimecast-MFC-AGG-ID: EvN15mscORyJWesv5W5O7w_1758268522
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3df07c967e9so948218f8f.2
        for <linux-mm@kvack.org>; Fri, 19 Sep 2025 00:55:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758268522; x=1758873322;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=osse2QL84K0KAyQfQ6mkJcBclhUlpgaOVm2/yxp2Gk4=;
        b=ozfVrsyPjG6hTVNfngXFWXnHBFFKlpjqCb4PyCC8Ok3KPQBS3OHLLX03RTkiAkItOV
         ofJjNbC7OiIRJ0uUwQ8oJqB1+up4Ty9C2kJGP4w8mXbOLnfMElknwlpx98v86i/Kp40D
         NsFbIEvRYeGc3e7NuLjBE9WQehA42qZxL1K+PKZ3OWzJHdmXPpBiuJQmeFbLL38US9dM
         FV6fN50USUMqcc+fVzR7RDFJcyNtKzatX4qcsOgX7kqji/0WV1X4EovJiUzVbkrBbrBX
         iiaDSPZKuJmTM6935EnhAfz+PPOFWko4ClQ1mvLVCJ+rRNN3GZXaLRCKRylMV21F70j+
         mTHA==
X-Forwarded-Encrypted: i=1; AJvYcCXUAQItS6L/tDFz6Z1SOsHUZKU58jyluzzXBSL22EODOMD0NFHpCKe07iPq8Sd4sO/V9uaxilIYEw==@kvack.org
X-Gm-Message-State: AOJu0YzjgQOP/vhSz2WekEU5cs1yClDLqqF5Nmgt1+WQUK0aK4VH7yr0
	aMr2PqU8pbsqMfTc5eevzCfjj0UXcjdyk7ysTdM/p4wdzbI2paWpyKmTiN0neZ9tsRH7srqpciR
	eO8ENZFN0HX3Fa/Z6vhBGTd/97pBYvW77r+hkRBOj00puQGDr+jca
X-Gm-Gg: ASbGncv6/w+pLVHXhuWGwl8Bd+QCvt4V/Me3kDr4/KFozoTzZ+Kb6coK/gU/Gr5zr0o
	1yVqLGq72lLMioko34T6s1ctmnKThc5F4WB+IXgtkNHvVK7IDl6oSp1uq4z2kqNfIikymVGq5o0
	jjeYAOIIETaQMl6e747gS7fxIfzMTDKIknlI9KH1U3ygotn8uKte9ZgWkcp70CKe5Y3yXJw/kQN
	aFpwXecRq4QXtrtrAkxj2c5cWNOHHFc4+h9ocaKN59sLBH1ubvDDdi9s0afa7iTqUj1VuV4CGsk
	fWAPwU03saYENfqLOvN2gyJzJHso1bOUO4IvXbPmmF+RcZwlrM+nZfGNuLN5dEYgT/1GTEcwerC
	XTJhR5VtwOPCM5EYwb05tOHFevaBmB1Nt5Z/N6ptaNAfbj1bihD8W8ukgVKqMAdwVONok
X-Received: by 2002:a05:6000:2910:b0:3ec:4fe:860 with SMTP id ffacd0b85a97d-3ee85b4a18dmr1762946f8f.46.1758268522058;
        Fri, 19 Sep 2025 00:55:22 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEmsOCk89rguq4xBcv0mHt16LvH4R5w4qPU2plvXNCKjIZCrWBP0TcUZNBN6vEsunOB08tPlQ==
X-Received: by 2002:a05:6000:2910:b0:3ec:4fe:860 with SMTP id ffacd0b85a97d-3ee85b4a18dmr1762914f8f.46.1758268521573;
        Fri, 19 Sep 2025 00:55:21 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f23:5600:727b:b2f6:94a1:a51b? (p200300d82f235600727bb2f694a1a51b.dip0.t-ipconnect.de. [2003:d8:2f23:5600:727b:b2f6:94a1:a51b])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3f02f332c31sm1086606f8f.45.2025.09.19.00.55.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Sep 2025 00:55:20 -0700 (PDT)
Message-ID: <9d2c3e3e-439d-4695-b7c9-21fa52f48ced@redhat.com>
Date: Fri, 19 Sep 2025 09:55:18 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 2/6] mm: remap unused subpages to shared zeropage when
 splitting isolated thp
To: Lance Yang <lance.yang@linux.dev>
Cc: =?UTF-8?B?UXVuLXdlaSBMaW4gKOael+e+pOW0tCk=?= <Qun-wei.Lin@mediatek.com>,
 "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
 "usamaarif642@gmail.com" <usamaarif642@gmail.com>,
 "linux-mm@kvack.org" <linux-mm@kvack.org>,
 "yuzhao@google.com" <yuzhao@google.com>,
 "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
 "corbet@lwn.net" <corbet@lwn.net>,
 =?UTF-8?B?QW5kcmV3IFlhbmcgKOaliuaZuuW8tyk=?= <Andrew.Yang@mediatek.com>,
 "npache@redhat.com" <npache@redhat.com>, "rppt@kernel.org"
 <rppt@kernel.org>, "willy@infradead.org" <willy@infradead.org>,
 "kernel-team@meta.com" <kernel-team@meta.com>,
 "roman.gushchin@linux.dev" <roman.gushchin@linux.dev>,
 "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
 "cerasuolodomenico@gmail.com" <cerasuolodomenico@gmail.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "ryncsn@gmail.com" <ryncsn@gmail.com>, "surenb@google.com"
 <surenb@google.com>, "riel@surriel.com" <riel@surriel.com>,
 "shakeel.butt@linux.dev" <shakeel.butt@linux.dev>,
 =?UTF-8?B?Q2hpbndlbiBDaGFuZyAo5by16Yym5paHKQ==?=
 <chinwen.chang@mediatek.com>,
 "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
 =?UTF-8?B?Q2FzcGVyIExpICjmnY7kuK3mpq4p?= <casper.li@mediatek.com>,
 "ryan.roberts@arm.com" <ryan.roberts@arm.com>,
 "linux-mediatek@lists.infradead.org" <linux-mediatek@lists.infradead.org>,
 "baohua@kernel.org" <baohua@kernel.org>,
 "kaleshsingh@google.com" <kaleshsingh@google.com>,
 "zhais@google.com" <zhais@google.com>,
 "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
References: <20240830100438.3623486-1-usamaarif642@gmail.com>
 <20240830100438.3623486-3-usamaarif642@gmail.com>
 <a7944523fcc3634607691c35311a5d59d1a3f8d4.camel@mediatek.com>
 <434c092b-0f19-47bf-a5fa-ea5b4b36c35e@redhat.com>
 <CABzRoyYWQMFTGYgfC7N=cWMnL_+5Y05=jrMhFjBf1aKOGxzq5g@mail.gmail.com>
 <ebedc478-7519-4e30-854e-f6616a7647b0@redhat.com>
 <120445c8-7250-42e0-ad6a-978020c8fad3@linux.dev>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <120445c8-7250-42e0-ad6a-978020c8fad3@linux.dev>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 0X9v9oR9B33ZOeaAkbGkTCBjLao87ldWcRlxWvMxXtg_1758268522
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 5492DC0004
X-Stat-Signature: 8updsjxaqwtiesfbibj6cgbhs6mpi9ds
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1758268527-405608
X-HE-Meta: U2FsdGVkX18iARr/XddNoPQWc6JqA/v+Sy/XFmSAluCSsHqOHGNAp+ZX6Naa3qAiJWQBMp7ixK/rerqdjRwOaT3cYMjZ9xGWeBcRd3P9Upzvytby1vQoiQnkaV+O13h0XvjayTGO8UuoUDbARGq8D0EojjaOe+rRYkqMfFXd4utESFPHQ6BNMVKsSOir9lM+CR0gR4iC+3RQs3xsYJcykeskhiomeM74JAldHj73TxfZHm9hZDPZuzxVOyfM8DyXcxM5xrXoPa3i11hqa+ljtVn/IpN/64VgP1eCq8g6ljyZWU7QqzVHisvqOG2R8nf08FUgp4wMf7rf7c1t5/VUZzTPTPtoSMg2h/GUEyrE+ovXh+TXCkAHGcSgfx8L/05itDe2DghEL9JoVUMhc/AyUXA5CIz0NmHtQPhjrGINTNO5UeXsuj8mYJ/eKJf5fYly/9UysDTx5WMzpn/JkKCE3m/SCdbbKWFz9jP/+qzmDX3DDjtJ+Wy5hiqsqLHHvLh3bT4HvWlUIcrvhtprSgMC4ZnhWtmcB1wog5Kt9OIEswtYEWRURBPsnX2YH8jrFCCQRi7hc06IGTvEMZA+wqEr5MLF9pIOuSoK0CVAqITElmxD8koy4xPldwL7KIUo1Ya42fQWq/G+yOE9DD2hNOIwvEXdWAMX87qmEVwI3G23aNXMe7gz8fz4mIp8UyIXGRR8ScKmojtLrYO8H3LhPjGREmq5YqZDMF3+ejcEfrUKiA6ewiYgs/3R+a+PphTrTj1bpjBHKqGuvWooc0Cj6cvrwZw+aL2ArCKojprXvo/7k9sxNxlhODpU6eDB1N/B664znkH4lwsJpX64CUjCetliqC6ZKATgI1cG2xJ4/5g5KleZh2VOXezPcZgbNmDUiA/jCpYpvNLHo6binNs38pWknEUF4hcGv38SbjwYF16h4Fv7RpskH390deUB+G2MW7BU7vIhpc/i4xD0c8EzDwy
 bPhiKK9Y
 9BElhH2iQgdS993KKA0fddLpU4HbsEDWe23r1XP18YiM7M5wP3C7uSmnWRWMckIbvVKErKmKENbaXwHKQxLdUfbmTlNdVTBATx7yuEjGKCnB9Ea8JczDPxj3NAfCyqpKFeddXZHDaQFY5SG2bdSgsdAxKRnsJ0qe2WMSa+AJXOHhkUsPmGyr/Ymgq87p/wJA19NQvDkDiGjG12VngOVpIsrKHtGNg3ztQcSUD6lN7YbuWaY9Ht+M1EsmI9PTucYGIzjapO1xVLcTepyT9w7q64RDkEZWow+8qkik9XcPGpLH+yGf0LSBdyI/q1DNdkxoZRPimd8ln6HmSKn65GCm+YuLjz9GKMp03qhJM1o3jSON5Df40lfFR0iZ4x7jNY7eMySvDOowWZri4KwmLvoqbYwehPpvOnPJEZ+wxAM7KW1rHPF9KqiV94U0dDQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>> I think where possible we really only want to identify problematic
>> (tagged) pages and skip them. And we should either look into fixing KSM
>> as well or finding out why KSM is not affected.
> 
> Yeah. Seems like we could introduce a new helper,
> folio_test_mte_tagged(struct
> folio *folio). By default, it would return false, and architectures like
> arm64
> can override it.

If we add a new helper it should instead express the semantics that we cannot deduplicate.

For THP, I recall that only some pages might be tagged. So likely we want to check per page.

> 
> Looking at the code, the PG_mte_tagged flag is not set for regular THP.

I think it's supported for THP per page. Only for hugetlb we tag the whole thing through the head page instead of individual pages.

> The MTE
> status actually comes from the VM_MTE flag in the VMA that maps it.
> 

During the rmap walk we could check the VMA flag, but there would be no way to just stop the THP shrinker scanning this page early.

> static inline bool folio_test_hugetlb_mte_tagged(struct folio *folio)
> {
> 	bool ret = test_bit(PG_mte_tagged, &folio->flags.f);
> 
> 	VM_WARN_ON_ONCE(!folio_test_hugetlb(folio));
> 
> 	/*
> 	 * If the folio is tagged, ensure ordering with a likely subsequent
> 	 * read of the tags.
> 	 */
> 	if (ret)
> 		smp_rmb();
> 	return ret;
> }
> 
> static inline bool page_mte_tagged(struct page *page)
> {
> 	bool ret = test_bit(PG_mte_tagged, &page->flags.f);
> 
> 	VM_WARN_ON_ONCE(folio_test_hugetlb(page_folio(page)));
> 
> 	/*
> 	 * If the page is tagged, ensure ordering with a likely subsequent
> 	 * read of the tags.
> 	 */
> 	if (ret)
> 		smp_rmb();
> 	return ret;
> }
> 
> contpte_set_ptes()
> 	__set_ptes()
> 		__set_ptes_anysz()
> 			__sync_cache_and_tags()
> 				mte_sync_tags()
> 					set_page_mte_tagged()
> 
> Then, having the THP shrinker skip any folios that are identified as
> MTE-tagged.

Likely we should just do something like (maybe we want better naming)

#ifndef page_is_mergable
#define page_is_mergable(page) (true)
#endif

And for arm64 have it be

#define page_is_mergable(page) (!page_mte_tagged(page))


And then do

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 1f0813b956436..1cac9093918d6 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -4251,7 +4251,8 @@ static bool thp_underused(struct folio *folio)
  
         for (i = 0; i < folio_nr_pages(folio); i++) {
                 kaddr = kmap_local_folio(folio, i * PAGE_SIZE);
-               if (!memchr_inv(kaddr, 0, PAGE_SIZE)) {
+               if (page_is_mergable(folio_page(folio, i)) &&
+                   !memchr_inv(kaddr, 0, PAGE_SIZE)) {
                         num_zero_pages++;
                         if (num_zero_pages > khugepaged_max_ptes_none) {
                                 kunmap_local(kaddr);
diff --git a/mm/migrate.c b/mm/migrate.c
index 946253c398072..476a9a9091bd3 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -306,6 +306,8 @@ static bool try_to_map_unused_to_zeropage(struct page_vma_mapped_walk *pvmw,
  
         if (PageCompound(page))
                 return false;
+       if (!page_is_mergable(page))
+               return false;
         VM_BUG_ON_PAGE(!PageAnon(page), page);
         VM_BUG_ON_PAGE(!PageLocked(page), page);
         VM_BUG_ON_PAGE(pte_present(ptep_get(pvmw->pte)), page);


For KSM, similarly just bail out early. But still wondering if this is already checked
somehow for KSM.

-- 
Cheers

David / dhildenb


