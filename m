Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4355EC98302
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 02:27:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0126C6B008C; Tue, 22 Sep 2026 22:27:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F05A46B0092; Tue, 22 Sep 2026 22:27:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E1D106B0093; Tue, 22 Sep 2026 22:27:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BF88D6B008C
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 22:27:30 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2F29C80672
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 02:27:30 +0000 (UTC)
X-FDA: 85243440660.12.F73E140
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 6B47D1C0007
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 02:27:28 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=dqYl3tM1;
	dmarc=none;
	spf=pass (imf21.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790130448;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9n316uGecMdSl/OJIOHSGu5fcSAJzdq/4iqnK+s/yDU=;
	b=CZYm55F1gBsjKCXc3JW+yLxvlpULjQzPEEs6csXUhkh5uAbKMH81ZooZqlXMpebu0g33Ye
	coZUdvluFmHBM3WdF0nOOUl1Ymq2SxNrlYEWIT9PqiYJxPXXMcvVLb/GJMSOC/Iw2IR1DJ
	i99pwTZ+TFR8J2RTYzO9vjtdWdnhiJw=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=dqYl3tM1;
	dmarc=none;
	spf=pass (imf21.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790130448;
	b=FsuMHelEVAqZRbJ3ov4Tuc/IXSjOGoUJRFyBLKdMLIP3xX95OC2FdiPw/VgwCRBhfVZ1QC
	5QsUyJvdXJp3uW64TTP9RW4wCwjEVvUHsEv3R+D2CsBpBAzk2VOSY87m7uaSV5WUsXDMhB
	vYeq8dnCIloeDXqNMAmpw/jtz47qUPA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 94421400DA;
	Wed, 23 Sep 2026 02:27:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D312D1F000FF;
	Wed, 23 Sep 2026 02:27:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790130447;
	bh=9n316uGecMdSl/OJIOHSGu5fcSAJzdq/4iqnK+s/yDU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=dqYl3tM1PxcISjSSdtgTTqJjrirf3epW9pDLwiuQdqVC4Zqsi/WBXp3y/B9nFxTMQ
	 vzUFv4T5o2ZTZy9ls1cEVG7Mokxmt21cH9zUM+7Gsow7VY3b9bkrjTcsNvugC3Ktnj
	 LsXDZADWi5gTTWcK36SOI4Mso2AcMelK6H+Op9u4=
Date: Tue, 22 Sep 2026 19:27:26 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: mpenttil@redhat.com
Cc: linux-mm@kvack.org, dri-devel@lists.freedesktop.org,
 intel-xe@lists.freedesktop.org, linux-kernel@vger.kernel.org, David
 Hildenbrand <david@kernel.org>, Jason Gunthorpe <jgg@nvidia.com>, Leon
 Romanovsky <leonro@nvidia.com>, Alistair Popple <apopple@nvidia.com>,
 Balbir Singh <balbirs@nvidia.com>, Zi Yan <ziy@nvidia.com>, Matthew Brost
 <matthew.brost@intel.com>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan
 <surenb@google.com>, Michal Hocko <mhocko@suse.com>
Subject: Re: [PATCH 00/12] [PATCH v14 00/12] migrate on fault for device
 pages
Message-Id: <20260922192726.90dec3c4c77b8c9063dbf218@linux-foundation.org>
In-Reply-To: <20260922053421.4092027-1-mpenttil@redhat.com>
References: <20260922053421.4092027-1-mpenttil@redhat.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: 584o7b6ghf4xczcfnk8xtpfwga8x6hwu
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 6B47D1C0007
X-HE-Tag: 1790130448-145803
X-HE-Meta: U2FsdGVkX1+1OggRzT4zMGBvfbCdSsTllBndfEnRuyhVuiqse/G/F21zChjD3ufVWre8Ou1vz8617wy6hHOm/nYcm60B6AjJxDR5si57rsISQUqpTV0BiASUl5DSltTmNgigkY4yWaaq9g6WyCuMDL4wo6L6MG3/HjwespANWh1X4cNBPLHGKJMwq/1bAkqRVERg8KXhh3dbPc1rae9oYKw0BW/KtDueLeXsMFog937Vf5ptBchf82KOroBn0bUVqPipHaYEdSq0JVfcMKQVxknUKx0k9d+pnD2VoEkHfG87LmwSibXQd7q/nWtAeHRFxhDc0khiccZMoYJ8VqA9A/ScES/7m54nSlouOEPeTUlT8qHmUd0S546cr6GlD/02TzOy40QhCbD5z61e/7WJX+aF2IbHMsG4MZGAawSLt1ZybBt/aZ2lue9RUy43VomSB+p1adEhyRMMsGZ6x9+D9o0cY5cp5fktcKX83kzqjKtM8WAHcdD3lZ+tZIUvwyWb9wuO2dJqpKUwPvVaJJN1WhoMd2xodZN/KuUTS9PVXhew8cSRNfULjo49gl/qt6wyDDX5Oa2rV9QegtOuVDNmzRUNCWPxJS7I946ppncQrRtLjlZDERlzThSbGsYjCXTX+5VgXAroFYKSmKTl2PwZkkxcdINMCLvvxoJfJFtotfzRjskFHx2ntKn7BTtJlmAN9TyIkgyLZacYezV214wHPh6XeFbedw2sHesD8dhuj37MlrUbiyO5za/SZ4YNkS6a3k5K+TWGhft5dtImd7REOEEppfEW6UhaNpHAJ3E4hsh0PJWRF6WxtmvbYJNyWA6cSlXDtNEkWdGdBDIsGaE2BPTMrT5EjcsXVG+SeiONjqiDjfcZ7xkoCYwx/DclFQEMY79o1+cJSwVLX9YH9juabeLHea220kLx/x3hHkaJNFe+Hghjz38aM97GPihLpxCHbQ47hObEgFh0hLImmeE
 qI9RGAM8
 Kh2SUCwpHtPc96FGJtWDQuD2GtyCqyCJxjbcQqxBc4KI7e1LY4mT0a+qo4EtsoWAmA4t8LQeUwsgr9vSf1Dtl9IKKAJPBwQrQhheUne+vZwLYqam4h9xpK3KsIPTTiFduk99l8U9Ih7VU629psqzXqnBGti9xzg8uwcrNS29gBEcKm+qvJIjtw8ojql+Tp4RuyBgIYcvc8o1cb8pIr8aH5Ij6g2X9UPmdcFObHcmI/aDUFOS+tlQ1szttR5+wSECF7GXMPuHaCzWYl82hStAM5Ljuh5/D1sRcEkDmfSOAtmOw3hb8nAC/FTNq3GBG9JV78ipIRcxPC602TyNvn6Z3OlC1QVuS1jIX3lRf
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 22 Sep 2026 08:34:09 +0300 mpenttil@redhat.com wrote:

> From: Mika Penttil=E4 <mpenttil@redhat.com>
>=20
> Currently, the way device page faulting and migration works
> is not optimal, if you want to do both fault handling and
> migration at once.
>=20
> Being able to migrate not present pages (or pages mapped with incorrect
> permissions, eg. COW) to the GPU requires doing either of the
> following sequences:
>=20
> 1. hmm_range_fault() - fault in non-present pages with correct permission=
s, etc.
> 2. migrate_vma_*() - migrate the pages
>=20
> Or:
>=20
> 1. migrate_vma_*() - migrate present pages
> 2. If non-present pages detected by migrate_vma_*():
>    a) call hmm_range_fault() to fault pages in
>    b) call migrate_vma_*() again to migrate now present pages
>=20
> The problem with the first sequence is that you always have to do two
> page walks even when most of the time the pages are present or zero page
> mappings so the common case takes a performance hit.
>=20
> The second sequence is better for the common case, but far worse if
> pages aren't present because now you have to walk the page tables three
> times (once to find the page is not present, once so hmm_range_fault()
> can find a non-present page to fault in and once again to setup the
> migration). It is also tricky to code correctly. One page table walk
> could costs over 1000 cpu cycles on X86-64, which is a significant hit.
>=20
> We should be able to walk the page table once, faulting
> pages in as required and replacing them with migration entries if
> requested.

Sounds sensible.

> Tested in X86-64 VM with HMM test device, passing the selftests.
> For performance, the migrate throughput tests from the selftests
> show similar numbers (within error margin) as unmodified kernel.

But no performance benefits are demonstrated?



