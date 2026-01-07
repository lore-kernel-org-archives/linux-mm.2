Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5AC9AD0D171
	for <linux-mm@archiver.kernel.org>; Wed,  7 Jan 2026 21:30:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C40D06B0005; Wed,  7 Jan 2026 16:30:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C016E6B0093; Wed,  7 Jan 2026 16:30:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B20B86B0095; Wed,  7 Jan 2026 16:30:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id A610F6B0005
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 16:30:42 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 417B1B852E
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 21:30:42 +0000 (UTC)
X-FDA: 84306462324.30.67C20A8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 8D0F8C0017
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 21:30:40 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=G1cutN57;
	spf=pass (imf10.hostedemail.com: domain of will@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=will@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767821440;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M0F0ykQRUzmX7vtto5Og3xAc6u94UP2lfAAPfJJnqjk=;
	b=XhgBdZxHcMGOo5esijO86n8Z5CNcpP1Tx7FHFzbTYp1N5SIug/NcyxEXtem7m5donTJ3SZ
	Nx0BFSdJGzCChbk7xl7+Lh3Ihl4ihuyusXYySvLL+R5JYxYrsLEPelJHESeP6vRXB3QgAS
	iqQ1J6gWMExaqVI22dXFJAtuj2Bn66U=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767821440; a=rsa-sha256;
	cv=none;
	b=xDSA9Ncv5PU4Dt3z9/+fLXr7TgFd1kWC0oQ3UQBt6klpfFBZ1SiFj4Y6GnBS/x/aYjj4qF
	rU3xuw7034NsYP9hZoumkXtn+VnJ3HKZkPQ7dWurXaiAGZmu9AxD42RlwGRGSOGaPC+2io
	GpdfUNgDp10vK/h20YkxuocyKFtkTgU=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=G1cutN57;
	spf=pass (imf10.hostedemail.com: domain of will@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=will@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 846BB42CBF;
	Wed,  7 Jan 2026 21:30:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D15EC19423;
	Wed,  7 Jan 2026 21:30:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767821439;
	bh=FFWQa2LcrHTSBnqZDDDWTX3L98Pi6EsBlHPLyGqAVZg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=G1cutN5774l/i6VO06Cm6RgMyY0ZBloUGp+vUZeYRcQ7s0hozsw0D2ZxzN7z/AjaF
	 C/cKv2nvlGtySI61wwT+MHVNR02xCzPnbwIa498UgguWOGUaaMcS9VuORG8G+LtTbL
	 jj7L4GMNKZHwztql++qSkaaMRYPAoy0nqp6EdTowwwfbJCANzn7EjyL1iNU8331eef
	 mk/ILH2wnz9SesYAu5iRljZXGS1BI1BeM6eSDbyohPWwkqYEEbim3D8GNw4avWKGdE
	 qs5Scd+uDIbKQwXDbJcKVdl8tVqnMZomYBLHBIqrqY4rXLAhpCOt2sy7GXEPFkaOCF
	 fH987XZrxdvAw==
Date: Wed, 7 Jan 2026 21:30:33 +0000
From: Will Deacon <will@kernel.org>
To: Wei Yang <richard.weiyang@gmail.com>
Cc: aneesh.kumar@kernel.org, akpm@linux-foundation.org, npiggin@gmail.com,
	peterz@infradead.org, hca@linux.ibm.com, gor@linux.ibm.com,
	agordeev@linux.ibm.com, borntraeger@linux.ibm.com,
	svens@linux.ibm.com, arnd@arndb.de, linux-arch@vger.kernel.org,
	linux-mm@kvack.org, linux-s390@vger.kernel.org,
	"David Hildenbrand (Red Hat)" <david@kernel.org>
Subject: Re: [PATCH] mm/mmu_gather: remove @delay_remap of
 __tlb_remove_page_size()
Message-ID: <aV7QefpA5aYIfUGT@willie-the-truck>
References: <20251231030026.15938-1-richard.weiyang@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251231030026.15938-1-richard.weiyang@gmail.com>
X-Stat-Signature: zn33ypyf4zxdcm1d6tk8d7ixbydpwiih
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 8D0F8C0017
X-Rspam-User: 
X-HE-Tag: 1767821440-2434
X-HE-Meta: U2FsdGVkX1/Js3p1XlOBb4F3AOCszXUz7amwYnF4Xhly8tvPvR5/qQ7pfCRhjvWC67hkiTq7yz88dPkkV0ZL/nNewKPWpK6EfXc9G9zc8GxKAMafUmDsMu0GaJY7FLaF6hTKCEG6QrbToQIBhrrD8z6GUlBlZgc+1UCXneymWQhNRyrvXu4ld6OlDA22wwun7DE5sZA0oz+p5rBwZMKV5CZv8g9M2u42c8G8vyCVUNYXbjmheFCkqKb5ea3/D01z5Own27YIHH5tOzeh1/XtyBF+WjJAwKYUHPNzORJSubmYOIhxSZF6eqT39ap36eG0LwEpU24Fw+cU0VeAdg2Es5A92532RY8gUtiW9i551t/GOoR29AVWc6k6/mQ3UJbMF0UhQxbkFBILyZKFpY9PySXi95fpdcjQ2nIarDiqPFcQMc4rJLABnvhsrNznHkdWh9e0XXCZWdFRMxTjuk1/ZFOaHRVZ86z8SdR+3p4G6lVRKrO5ZYlyXbZU/GMkkeCVAMQVspXXgIPKgn1NxCZmjUXmpKwEQS68xSao04JchLJL/0/7QAuCJFTXL+12xJVjbLWKsLK2hyJGC9Z3nU1Onhw2GkfH/X5OER91kEb7S03DZpTWKGpGqo1mzTHasKwCH1zxh7pyZG/pfeZwhBjPvSQ4jju/N9d4TMS7gmeluKjaQ8n+cNcSj5AUfKR7+092zDGiDeMU2MrrVIRzWDrcCuo+Ge20vywCdxYbs8Queft2tsfsoSUdT+PjxJBV19x2LrXITfTSuh2GCBzH3Jzh8iMmQfqIJ59oGONqNinulKdFdjZrgxUU/0DdT/Ut9WqK0q/6vrlCfPWp3IsklCLmOoAXncTSvnuX5JL4QmUyFTGsAG8Te5JsnNJcFwsWhL0Lm2sE9Ocnp7qZj5H2+fOyq/wlad3TkxI/QzL4Dr4GK4KgphaTW0or/TcWwvc1Br3IEPbJhOdZSAyMugW0y4r
 w+C7SRbQ
 8dEmgrQp2iWOSKoTm+tQ6ubmQI5HEjQ74UK0o3iZkjGx/7kFla+Me7D8j+QQ8ImTfIy/eEGbWnntPz6k/t5LkduZdiiQOmaKs9if7mxMxnud/sEIZ28jg+RgbhJbf/yKnFPuSjwkS2JW2V9Q3rof0XyTOWnoaO5SQ4qkAXmTTzI0ZbVTiFr0/DnoAmEXGUVHlquKujJ49KQx9LSav2p+800TAiWkA1hY2KyOW8Qx/KQYHYNd4V+94UlnUF5DkpipRDWKsRPWJPBMdJCeMSPe/g3vZLWkbd1tzoaykRjr5dJE8X+hCJ41X4sMi79PQ+rYpmVwxKH9SGoORtqQDnWtNnmkjs9ohwJA93BG/eerRYVEy3VKjjR8LPSHyMwJ1a9kWR0rUujpxXZHs8Mz+MWCaoZYKwiGtvvOhVeA7
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Dec 31, 2025 at 03:00:26AM +0000, Wei Yang wrote:
> Functioin __tlb_remove_page_size() is only used in
> tlb_remove_page_size() with @delay_remap set to false and it is passed
> directly to __tlb_remove_folio_pages_size().
> 
> Remove @delay_remap of __tlb_remove_page_size() and call
> __tlb_remove_folio_pages_size() with false @delay_remap.
> 
> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
> Cc: "David Hildenbrand (Red Hat)" <david@kernel.org>
> ---
>  arch/s390/include/asm/tlb.h | 6 ++----
>  include/asm-generic/tlb.h   | 5 ++---
>  mm/mmu_gather.c             | 5 ++---
>  3 files changed, 6 insertions(+), 10 deletions(-)

Makes sense to me:

Acked-by: Will Deacon <will@kernel.org>

Will

