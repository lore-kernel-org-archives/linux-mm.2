Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 37DE6D2502F
	for <linux-mm@archiver.kernel.org>; Sun, 11 Jan 2026 14:06:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 603996B0088; Sun, 11 Jan 2026 09:06:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B1356B0089; Sun, 11 Jan 2026 09:06:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4BC2D6B008A; Sun, 11 Jan 2026 09:06:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 3942E6B0088
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 09:06:30 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B29ED13BC4C
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 14:06:29 +0000 (UTC)
X-FDA: 84319858098.22.3D8E32D
Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	by imf24.hostedemail.com (Postfix) with ESMTP id E1FBB180004
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 14:06:27 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=NYDj2mlD;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf24.hostedemail.com: domain of yajun.deng@linux.dev designates 91.218.175.185 as permitted sender) smtp.mailfrom=yajun.deng@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768140388; a=rsa-sha256;
	cv=none;
	b=I4/Y4Ml3LQgjeF+GvfCOpSA8UjMGRPGfhr18ARqjf/3wxjOqX1AlvqotbTlIMs/gnVWmFI
	s+j+cqtAx7+O8FduNWuArvM5OZN9i9KnwhbR2rgUcnM4LmSxyyPcVwTByhfQ7jxPjzYHKf
	yFhy/knG503Bxgzo8WgC3XHpXd7k9YU=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=NYDj2mlD;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf24.hostedemail.com: domain of yajun.deng@linux.dev designates 91.218.175.185 as permitted sender) smtp.mailfrom=yajun.deng@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768140388;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/zAeMrvMFCoTLAYXTKyzPVZuey3oycGqRnCUj5YJWik=;
	b=OCrWt3qvFOWWzpsxU/mvgf34ck8cyeCp7r1Yup48FWysl1eT8TodnIZsK0uwlw2NJZEAFe
	s4YybXrnQaBiJwaYrTulO1JBqs7labUX3L/MeHHv34bHDNzysO6lcmFrgYKg4+3ADlI7QH
	bJhfVqd44+OYEzZiUMADifl7Q/rg70E=
Content-Type: text/plain;
	charset=utf-8
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768140385;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/zAeMrvMFCoTLAYXTKyzPVZuey3oycGqRnCUj5YJWik=;
	b=NYDj2mlDQ482dCgWZDLPO5rNZr0rVsfxAlCJRU27shpX8m830U3/7hjvz0QsW2Mr/HQkbU
	wLTXjYVExOfMStPPjcFQaEFfvOy/wz/L46daNV1C1pLUXVJJqIOLnMfaayuf3ffOwETYgQ
	P1kXyDTfDTocGqqsMNr62nIVsOA+cAA=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.200.121\))
Subject: Re: [PATCH] mm/page_alloc: Avoid duplicate NR_FREE_PAGES updates in
 move_to_free_list()
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yajun Deng <yajun.deng@linux.dev>
In-Reply-To: <20260110161048.0aa9c7e32af3e690a671ef8d@linux-foundation.org>
Date: Sun, 11 Jan 2026 22:05:40 +0800
Cc: vbabka@suse.cz,
 surenb@google.com,
 mhocko@suse.com,
 jackmanb@google.com,
 hannes@cmpxchg.org,
 ziy@nvidia.com,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <81F8212D-9C00-4AF2-8D04-79059283B47F@linux.dev>
References: <20260109105121.328780-1-yajun.deng@linux.dev>
 <20260110161048.0aa9c7e32af3e690a671ef8d@linux-foundation.org>
To: Andrew Morton <akpm@linux-foundation.org>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Stat-Signature: 996i9hjyxgqsqonysk1kdjb5n67qob6x
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: E1FBB180004
X-HE-Tag: 1768140387-227212
X-HE-Meta: U2FsdGVkX18A+4DPU4quSd8ZakVujsgoVackFynjSVKdlxHkVlh4isTeUI9zWj9LDjec6S3cXzMAid3AIhregKW2t2w4+1lCun8DtU1x8ytKihPiZLmQfomPhwi8E2+KBY6k74OJbMlPugXgWsQZ5ZXfPdZ+jqYVnIzx10C7WkB82EtGrX3SZzixbQ0zDogdaVK+dfOHzq6DUE5UUHx2ypYpE6+VwLtLvxqkMjmm3nY8ynNDXzYAhiDI4KzjO8fjqGDTtBY3jc5wBqgMF5mlrF97JSX6kb/g/cOt/6ZynizAEd14ajaPj06aTKlrlescoRfUm+0qoBlWGInDMpnQSsYYOBYui1cx8Xf/FhZBmf8A7E5jelwUv/HewsAkBE7fbplZD0bB0BVl5W9MAase+rWfzbg8NfMn5ZtFDde5ihYy8eYwrfgrC3kjIMdyYhYNcehNdJszmKUyMOGi5gC9U6aN5nwjACvMt2IWZvfaFFzLJn9NlnznvnZce/VJd5mOACS9jq4i1fsVWNInhOXPkJBE12uY4uggmp+FnBSWwc1KbJKVaTuo0rUA+Ll/jHayeVhaE+tzdb8TKybl3lFGFvhDniiDdITnQWAeO4EDCLx8cM9wyQEs4HjUHGIGXm3tj4swGgX51aWYRnENY8huzx2VRG7hNdFGUbjZN4WbvOQEz2Dg9X7OFlwV0QNh3lQmYTLXTfQSKiFzOvDpyHFsbLccOPdBB2pDX+HWfyRVqKTf9PCM1QObq2W2bktUbwYOx8qpI5/8ENEWw2VMe2CQIsQponhPTqNctxjQSc6Tdy9R3xm6jMnKfUWZK9IzTWmIsntas/7Ikc2AD+5H7nhTq2vbyDxqNdCm8Z4cpciZfOzB7CBmgLBgajIPsxsk4jcHaPdZ6M8+RY9VpYMMq5ThpwFFijkeribNG9Nqz6dz3QS2GqmsRdoFTiJesd9B2qgj8s2M2E6+g2M4FyaIkBj
 Z2/PF4YX
 VZrNG7tHm4c5GtTIIphLQJKlzPqqIig+n7F3K56o5AaA9RGck1vXvwLb+met7QU1tuFGToL9d4M5mvEYWv+CgqTw+MZ4Pc4CMu/Z8yCTu8f4FBcAqhFE48Kt7TNw9JzYPBwa/0hY7HYgZfTyRTE3bhitv8KBuH+mImq9aewb03a3wSRYN/NiaPJ2sFyEaJZqHwUyQKfWBx2vl4pRzUxWYvl+7c0KBdWoOxXchlZxSo5UyngLcvhacAENjtg5v+kqKmGTDGeNE480n3AjH1eiW1coCoUH/ojpOu2lUkeZtjsV5OqHLOLTMIzRaJdAzZIU0KVmmKAjLQgOp3vWHPbef6Mu5yQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> 2026=E5=B9=B41=E6=9C=8811=E6=97=A5 08:10=EF=BC=8CAndrew Morton =
<akpm@linux-foundation.org> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> On Fri,  9 Jan 2026 18:51:21 +0800 Yajun Deng <yajun.deng@linux.dev> =
wrote:
>=20
>> In move_to_free_list(), when a page block changes its migration type,
>> we need to update free page counts for both the old and new types.
>> Originally, this was done by two calls to account_freepages(), which
>> updates NR_FREE_PAGES and also type-specific counters. However, this
>> causes NR_FREE_PAGES to be updated twice, while the net change is =
zero
>> in most cases.
>>=20
>> This patch introduces a new function account_freepages_both() that
>> updates the statistics for both old and new migration types in one =
go.
>> It avoids the double update of NR_FREE_PAGES by computing the net =
change
>> only when the isolation status changes.
>>=20
>> The optimization avoid duplicate NR_FREE_PAGES updates in
>> move_to_free_list().
>=20
> Seems nice and LGTM.
>=20
>> +static inline void account_freepages_both(struct zone *zone, int =
nr_pages,
>> +  int old_mt, int new_mt)
>> +{
>> + lockdep_assert_held(&zone->lock);
>> +
>> + bool old_isolated =3D is_migrate_isolate(old_mt);
>> + bool new_isolated =3D is_migrate_isolate(new_mt);
>=20
> We do permit C99 definition ordering nowadays, but I do think our eyes
> and brains prefer the old-school style.
>=20
> So here I'd personally prefer
>=20
> bool old_isolated =3D is_migrate_isolate(old_mt);
> bool new_isolated =3D is_migrate_isolate(new_mt);
>=20
> lockdep_assert_held(&zone->lock);
>=20
>=20
> Or simply remove the assertion - it doesn't look useful to me.  If we
> aren't holding zone->lock here then the kernel is so screwed up we
> should all just go home.
>=20
>=20
Okay, I=E2=80=99ll remove the assertion.

Thanks.
>=20


