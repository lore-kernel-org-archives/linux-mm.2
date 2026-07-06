Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4A079C43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 09:51:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0EF6A6B00FC; Mon,  6 Jul 2026 05:51:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C7636B00FE; Mon,  6 Jul 2026 05:51:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EF93E6B0101; Mon,  6 Jul 2026 05:51:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CE02E6B00FC
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 05:51:27 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5C13D1C1893
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 09:51:27 +0000 (UTC)
X-FDA: 84957884214.16.E7F86E3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 85EBAC0005
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 09:51:25 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RfZJSKVp;
	spf=pass (imf22.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783331485;
	b=rNVh4jLz+dOKv3YleIC8x9WBHa9zwz68LXCP7G8ji2mZhG3C9XM5yMM03CcoJaZlEGzecI
	nx6pZRctoOAlc0rGwElvqr2AM3HH21Xn9/riIjOEJY+jnUz0LBoHsvB8sXvwwxpJh6SztE
	pacDa7HS9ExuEjRps9/3LpoiBPAcf2o=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RfZJSKVp;
	spf=pass (imf22.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783331485;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TjOPabIpVHZF6THKPpmek2EAm48A1E2bAPw3H3Ei5BQ=;
	b=Tl7luHphgkbGYCj6vQYs8Gc63aTArqI47cMYVyXIwi94YFcT1ONIB9amFneSakJXxYNQul
	K+DFH47ekvTPTAVK+GKXKHJFl0fkb6HaEZCMPw5SuxkD7kx1dPDP9EWlUJtMpHxZuYzgO/
	OGGXMU45H/OT/IfOWpFxXqvyxN6HBt0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 049FF600C3
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 09:51:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFF641F00A3A
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 09:51:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783331484;
	bh=TjOPabIpVHZF6THKPpmek2EAm48A1E2bAPw3H3Ei5BQ=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=RfZJSKVpm/nBFUSS8uKjWpce6No14ruD5EzUfqIJ0oiCYl58EWT/Vx4vfwP2YrtJF
	 vMk61kGi2ZibTincbII3twoANITqjWL7FC3AUWgh4I28nre10bplligU8/In1AenMX
	 tO27acwfPjakcJMaq+pP2sIvmAsI7qmkcSdBsTBvFiysQerkTnzBESWAUqOF2HgBpL
	 jiTQV9GM0ahDoPgKsdqfio1tfTbjsvDOA4BezQUsveNwF18MTDHR3dNmmlDy/oc0i2
	 IMjzVxdlAUxdC8ss7YmjEtpU8MuTZpPVWjkjVFU1wip2p7nlAjhjnQns9RvV3b2TyL
	 RYNe89R53QDGw==
Received: by mail-qk1-f169.google.com with SMTP id af79cd13be357-92e501244f5so120526485a.1
        for <linux-mm@kvack.org>; Mon, 06 Jul 2026 02:51:24 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RoTuqZbn6ahKjHIkHvscpPiLTqw7KfP8YYutrbsIKar6g68pUWtgzYkJAV0MjL1I3GPfaxsnGuUTQ==@kvack.org
X-Gm-Message-State: AOJu0Yxz36A37JEk59JBj+U38wqcO5WKOHdHXZE454P36QGNEFSGEoVJ
	dmnbpZE3Fwww1ijgX0tQSzU92PRGP73EHF66z0fzHtGooxpEr2UWMeuu33GPB+JcYDInwtWuHtj
	/0IT+IMAIzHBlOhffknBPkKoqdVJvYr0=
X-Received: by 2002:a05:620a:178b:b0:90e:2f56:2f0b with SMTP id
 af79cd13be357-92e9a34676amr1317152585a.7.1783331484041; Mon, 06 Jul 2026
 02:51:24 -0700 (PDT)
MIME-Version: 1.0
References: <20260702122342.26721-1-baohua@kernel.org> <6a81273c-6d5c-4811-a6a6-e1e8a3a47b97@kernel.org>
In-Reply-To: <6a81273c-6d5c-4811-a6a6-e1e8a3a47b97@kernel.org>
From: Barry Song <baohua@kernel.org>
Date: Mon, 6 Jul 2026 17:51:10 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4zc5ysg3naD4YV9z07-e3P0WX8bVvxuXuDZ+VmJBGUu=g@mail.gmail.com>
X-Gm-Features: AVVi8CcH83WM7a7sDLHeciaiAOkhefzLZ13MFQ713HeTWHV8hUcR_lrFl4AxFfE
Message-ID: <CAGsJ_4zc5ysg3naD4YV9z07-e3P0WX8bVvxuXuDZ+VmJBGUu=g@mail.gmail.com>
Subject: Re: [RFC PATCH] mm: allow smaller large folios to use lru_cache
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Lorenzo Stoakes <ljs@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R . Howlett" <liam@infradead.org>, 
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Lance Yang <lance.yang@linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 85EBAC0005
X-Stat-Signature: km9o8jco3xa6fcktksouiw1cpqh6ukf3
X-HE-Tag: 1783331485-996728
X-HE-Meta: U2FsdGVkX1/sgejkSZkGp9cYdFgubR27s+MGCf6ULRwLnZO8k5Y8go74IBnBZ+vwWR1sdLOVPC6Gff1G9uBgS4JhZSQtj+7dA7V6FUaCuGPaFiycQTLloRrVfmiUMPPNviXMvCSkNbs5E7NS6Ouj4KUrXmMFrrMS84GAn5m165Zy0S3OYF52fBrojdT1IH2YcG/8eDR9hGdwo4pOoHOihNHXl8vRf1Ds+2XZ6/ziYzf7vGRMw/6qLNY9Y1rM5cUv2+dgB7LOA6uqTRmOrQ8BPzO2SFX5VnbIC+/Y44VlhLDJmqSB/WiBYhbSc3PBB70A7ucUEF1XS/guHhBXalWyngwiYVR9mOGs2ONGUmQe+7gbwHzjE6jE8wkmH++9zr53/heeEkVW1p52vOQ8nTxER80Z0yr+p9L2CWFGtV5toFmUmvEJdWKjyUSmC/zEKrNEMNXUVkXhXvCT8bbm44en7YhbawZ6HW9mLi0IeG1WnHzxWwBYCXgC8WpcaV56SureDtRAsxch1TEa2vMUbkIo79h83C3uISeTGj40AkS+4loJgVEd13DuOj13Nddf86gbIJBYntrGMmjbYv4D7OZF3kI49LMS5CdjBunYqVrykqBzrjnpUbwvNENatohtU8rCmUoFRyB0V+en0gzRFnbLihVi5XXasg2WesP4uTtsupiKKtnzNOedoACmBDyimcrInvqD5nzlkJxI4NnMVtMz2C8Qqjwz/dytRAXeUlTrQR9MxLk32+1kQ3IAKiRgM939OZV5NKErwvcYe4sfZ97c4Vsa5i4Wefs9O+9euyQ2B9KHhdq2Bkeb5J7A6uFyylFZZSlWQdWIojGAmeW2Nehxtjfyfmff9oCkt4Yp+x+Fk7s2gR6oiv2SmS8KLZ/3lU1JZZ3xE0I/xxylSaffNCBmtp+4eoMoh4ch8F3faHubp4RhhhUgGzmVHz3g4XiXK6GC/KoeOdyb4v9f5ZyBiuA
 AwfjEKVQ
 Pjk6GHYyfGd38aXIV+MnfwZhE9LM7wKDA7NXLUHdJJr4DZTTIg8S4gd6Vyminw49WXAaA7ncyl8fzUziARhWqno3CRkKs381upWTbCTcXZZV2ZY7XHG1Ns3bmna69UagAHfXQesPLKExhu3NUGhF+saKqSxaQ899D7yekBKF4lYiM3AkSBNM30YdD0Ox6hi5/UbGoDG1+qImGAFrRRNuSxpyYh2zDTIUSQ0i0zoBryoFfL05Pnr4+AvcPeQYiKLv0cExZTbhdpP2prQ2pIINB2usuEwk647vvNDBO7/NE2PwkALVoQcAWyELmMnudhz+IziQIcHPtqIg5b78w7Bkc8li9pVLXU3x96ud6
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 2, 2026 at 9:00=E2=80=AFPM David Hildenbrand (Arm) <david@kerne=
l.org> wrote:
[...]
> > diff --git a/include/linux/swap.h b/include/linux/swap.h
> > index 8f0f68e245ba..fce1d84aa2c8 100644
> > --- a/include/linux/swap.h
> > +++ b/include/linux/swap.h
> > @@ -322,9 +322,9 @@ static inline bool folio_may_be_lru_cached(struct f=
olio *folio)
> >       /*
> >        * Holding PMD-sized folios in per-CPU LRU cache unbalances accou=
nting.
> >        * Holding small numbers of low-order mTHP folios in per-CPU LRU =
cache
> > -      * will be sensible, but nobody has implemented and tested that y=
et.
> > +      * will be sensible.
> >        */
> > -     return !folio_test_large(folio);
> > +     return folio_order(folio) < PAGE_ALLOC_COSTLY_ORDER;
> >  }
> >
> >  extern atomic_t lru_disable_count;
>
> Not that __wp_can_reuse_large_anon_folio() currently assumes that large f=
olios
> are not in the LRU cache.

Thanks for pointing this out. I assume we could do something
similar to wp_can_reuse_anon_folio(). It won't always help
drain lru_cache, but it could help in some cases?

diff --git a/mm/memory.c b/mm/memory.c
index a29cd38ad547..db82ac8057ac 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -4143,6 +4143,12 @@ static bool
__wp_can_reuse_large_anon_folio(struct folio *folio,
                folio_unlock(folio);
        }

+       if (folio_may_be_lru_cached(folio) && !folio_test_lru(folio)) {
+               if (folio_ref_count(folio) > folio_large_mapcount(folio) + =
1)
+                       return false;
+               lru_add_drain();
+       }
+
        if (folio_large_mapcount(folio) !=3D folio_ref_count(folio))
                return false;

Best Regards
Barry

