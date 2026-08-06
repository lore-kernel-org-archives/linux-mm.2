Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9525AC56207
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 14:34:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8A1C26B0099; Thu,  6 Aug 2026 10:34:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 878D36B009B; Thu,  6 Aug 2026 10:34:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7B6D06B009D; Thu,  6 Aug 2026 10:34:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5C6986B0099
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 10:34:50 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0082AA07D8
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 14:34:49 +0000 (UTC)
X-FDA: 85071091140.14.5DF41CF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 683D8140003
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 14:34:48 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=f031x4F+;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786026888;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/s88DIFVEBP2T/uZKq+3U5KPJDCNDQTM2bhogMbtZ1Q=;
	b=EiBv/nVZIz9DRK50+X8zutX4LwrkWwFhnawEFwfpEJw0EoG1PfKV4iBKHNCh1m62pQ2cTJ
	0oLarZ8yCNyOsaZgKiRofm712L/2Pf/qOYiuXJ3V8v/3+LGRk4AKA0H8GWCFqq7UDVa+Xr
	ECXULpzVhC0C2kkgFCdhohL92vBVyx0=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=f031x4F+;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786026888;
	b=7i8dcn3TJnf6hE8e220/Ua7S8YH580XOwGTkGnQ8Vp4hL8H45br7BH418IXvLJr4G4EpyM
	W5ojS+kZtgQTcKbeSxMyyEeevxEM/3fuyVp6rUcbkZv1D6sNhWHzeGjfd4lUZVkdlYd4nU
	ElaCHP5Fjq087mL3MGVChiNgey/j3AA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D34C060A9D;
	Thu,  6 Aug 2026 14:34:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3371E1F000E9;
	Thu,  6 Aug 2026 14:34:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786026887;
	bh=/s88DIFVEBP2T/uZKq+3U5KPJDCNDQTM2bhogMbtZ1Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=f031x4F+s0KFN5tShrCm3AxXtnTVWfzYoRM3Yo0GEu7luofuotWTcMDKSZFigWelR
	 dq9VyOjfPvxZeyx2B9UuHNyfEsHIhOcxFpGa3CiTQvSjc7k7/LymF+hIBAGCWyZ9ex
	 tEyHnklSzH/ZovMF3wN4p+C7HntVKx/n1gscXtlZUvieb7KjXFXrY9u1YdNiNDAMZH
	 tNx8lloJueRo3K9czmBoR+Yoa30H51g51gKSr8P+DWBf9Ptfj9qSc84sZot4nganO0
	 z14VUcL2SOyVi9Ry+g0qLQIEeAGPyAPeR00lSI1bqJ+j5SbFediA4U8yrgUa+qnPYt
	 fYeFuqJQQpF9A==
Date: Thu, 6 Aug 2026 15:34:30 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Yunhui Cui <cuiyunhui@bytedance.com>, akpm@linux-foundation.org, 
	liam@infradead.org, vbabka@kernel.org, jannh@google.com, 
	00moses.alexander00@gmail.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Subject: Re: [PATCH v2] mm/madvise: avoid skipping pages after splitting
 large folios
Message-ID: <anSar_i8UjniSbML@lucifer>
References: <20260806055501.56761-1-cuiyunhui@bytedance.com>
 <anQyoZgi5Urnvvjw@lucifer>
 <919b804b-6f1d-417e-9c0c-d06f50d765d8@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <919b804b-6f1d-417e-9c0c-d06f50d765d8@kernel.org>
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 683D8140003
X-Stat-Signature: dyam64dozhq3us8fhza814m8rfiwxsms
X-Rspam-User: 
X-HE-Tag: 1786026888-12683
X-HE-Meta: U2FsdGVkX1+S0psKa7XVdXye86oniiEEweTrFcQMVTCpi5xnojeIcH9xfDHhMB+1FrMkgmUyK0quzMTlF1KxEXQSy1fgh/GWrzQGqYEd8pIEVfuM3wuY7PMh7el+57koE+AQdAA2QJUCDG+SNExKAdf3VqdwavVeodjdizPbZKnYBdJQUSPdZHP+vXbXUnZufH7kSBzB8Eu47AZbTRijKKZCjbCs7UkLpNSE+l2kq31btJWXi7doo1MsiK1bfTEIdGyV06gOXlArkWsBLJeQpIxwpUZZDh/bIxt/lcjFH2KeOUpOfib8mLIoifI6vMTh9WV+X+zNg4eayx9RSAd1cRFKq9KHrTkvIB1KTGz5CFsYh3k3lvvOYwO9VKDYraXeFRiaTIoMy5SVudnzOOGS9y0JA84AskkmfJE50YOtRjGHybZJwEjW4FM2zL5Yzhi03iJe4ACltX6xrAk4BELl9DjGCj9NoJdz+HcX9Vt/ZSaDeB+GYjwWw/5XWy4NI3A9+epwmskXStVZQ/FjIN8857sTlTG+u0qZoVNQGAg+oXL1xF3bAg+D138OZn78p/W70ZBOSuyFCqoHU3Y+20gbkb2OAnObCUdb2ScTmhJ8z/DxYFjLTe/UV60zjuA8WneUsMyR1txU+PpTAgWy9dVzDoBJrdb0dyzGhElf5c2WnOfgv3PSDkrUzy5OIcNJgRNplHGQq0M4/ex5vJ0FEDrIBeMLdIzVRiIuQ4rMYo6GkgW5vRMAYqstGQRICwTSg0a98EOPZzWoKLz5eswmW7PtUnCXX4SyWKDeKYD4CNcZzjZLqaaCwhdfFcwezluNiXIVzISGngN52fLK6moNIyT18tf8bazUfW6F/cTmDzu/g9tpwxCv0s0mmLlNaxCpZq/EeVBIWr8Xe6yn29T2LSKqRON9kIPGCT1zhtFARyCH9y64xw6facc2w7qq1dT034teDZoJqXoGtmaY5dGjTVl
 LRSspbwU
 Xtwf8zLDkHRibNv06NzGO+v19UGwC9fy93P1iaztH+rD3e6DsfCxC8vztoik66B3SCSDPiSjeh3rRy/QUYaOcL3C7p3tSfsByVOG3KhtwMgIsfqJdrdUlzZkGOAm8c3SCiU504EaOlycgcdepH6bncZjYk04GEacNB33Fr0wIVPoq8Ir8Ee11OWND4wXsOeJz7WMP39kIjxyaqAD7pL5Lai8U4XxnGHiAQ5iAAY6QAObDoYyEk8t1ked6khYg1yP1G5jOtjXhybduODXSqMH7rv0nW4LrrL5cdyuCK2hgVfWedSGgcJmMXhJZbTMWtD0jaLWc5bI9KkQJoJU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 06, 2026 at 01:35:30PM +0200, David Hildenbrand (Arm) wrote:
> >
> > Let's at least split out the folio check into a helper to make things
> > clearer:
> >
> > static bool poison_splits_folio(const struct folio *folio)
> > {
> > 	/* Hugetlb is, as always, a world unto itself. */
> > 	if (folio_test_hugetlb(folio))
> > 		return false;
> > 	/* Soft-offline errors out, hwpoison traverse DAX intact. */
> > 	if (folio_is_zone_device(folio))
> > 		return false;
> > 	return true;
> > }
> >
> > Then for your patch:
> >
> > -		size = PAGE_SIZE;
> > -		if (folio_test_hugetlb(folio) || folio_is_zone_device(folio))
> > -			size = folio_size(folio);
> > +		size = poison_splits_folio(folio) ? PAGE_SIZE : folio_size(folio);
> >
> > I tried writing something that was neater and nicer but AI kept pointing
> > out how it was totally broken and I really really hate this code (not your
> > fault :).
>
> No, I don't think any such special casing on folios is the right way to handle it.

I mean the issue here is the stride varies depending on whether the thing is
hugetlb or not (and some weird DAX thing), and the poisoning causes a split
otherwise so if you want to poison a range you have to account for that.

But I agree there's something wrong here.

At first I thought 'handle at a folio granularity and assume folio slide' but
stupidly this code allows you to poison partial large folio ranges (I don't
think it should and given it's debug/testing crap I think it's fine to change
that).

But then maybe the answer is to change the interface in general? But at the same
time poisoning happens at a pfn level...

It's kinda weird to allow such an open-ended debug thing. I'd prefer we just
disallowed hugetlb, or did a split right away if THP or something.

Anyway hwpoison is a swamp of neglect and hackery regardless.

>
> --
> Cheers,
>
> David

--
Cheers, Lorenzo

