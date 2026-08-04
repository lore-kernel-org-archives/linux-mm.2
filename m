Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6F60DC5518F
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 14:39:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 76C706B00D9; Tue,  4 Aug 2026 10:39:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 743C26B00E1; Tue,  4 Aug 2026 10:39:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6594F6B00E5; Tue,  4 Aug 2026 10:39:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 402716B00D9
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 10:39:37 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8F1DAC0117
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 11:03:13 +0000 (UTC)
X-FDA: 85063300266.17.6F5E9A0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id E19181C0010
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 11:03:11 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=C1CFIKAx;
	spf=pass (imf18.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785841392;
	b=tFHgPRWoY1yeMM3JCfQfQwZ2VWsZCrtY+5LKj9z2zYsmSk9AITXcz5P0EOpeAHYdg1iah4
	htWqAEgIsNThPaWJsRtnYcMT7Tptn/1TyiZUDmlE3ClW7QfzS0VVzrsEzKZ2Win4quEZdb
	Xs5n41Vf2HA7USrXAlIU6EXVXMy9ijg=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=C1CFIKAx;
	spf=pass (imf18.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785841392;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iXDxYwSV7g9rYp8p++FwfQHg69A92970L1sFpqaFceo=;
	b=qg81roz4U7EPcqaABSCDV2sIhJPLNu24WVk6Dis8G09HXcsfCFFTW45pRV3CHel99vhtni
	/0iJV9aOeca/EsJeO/H4I4VhdIudXlsq4MQZgUenHZC0AyMflIDv0bKYWXdtD6b8NDi8Wp
	29iImDpW7Iw5ga4EhM5BmgvXUjCgtDo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 01E4C400C6;
	Tue,  4 Aug 2026 11:03:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8397F1F000E9;
	Tue,  4 Aug 2026 11:03:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785841390;
	bh=iXDxYwSV7g9rYp8p++FwfQHg69A92970L1sFpqaFceo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=C1CFIKAxTrKJZVBjPFRcEhLN7GNjDCw/br30yzoAZTvVgSaOOk4tglexKWkvwX04i
	 4rm/a8Nq9zIxpxfupCXwKSTmzNs5iC/TLUg50TnsOG/27O/spRwljupOB1A3tAjjgK
	 GqDLuHJJwigJC+Md/pZUAcodmGDJfFMUo2HeuDlD9O+/rUsIMSS7AuShfNBkFExFC/
	 xAqLprQ9A+UR/BpWx7o2cMemDAkFhJ+KYHhW3q4UV7nIreJJwbTGIo6K/nnuUt+qEi
	 Xx9D76OxLKhR0eF/1XMdE4qRuNnRGleZ+Lw0esdYH50cYlpT3jAJZfOXASatQTL3bX
	 17+St3fDz7dUg==
Date: Tue, 4 Aug 2026 12:02:50 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Brendan Jackman <brendan.jackman@linux.dev>, Zi Yan <ziy@nvidia.com>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, 
	Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>, 
	Uladzislau Rezki <urezki@gmail.com>, Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Subject: Re: [PATCH] mm: add some missing includes to mm-local headers
Message-ID: <anHDNwlcBlIfC-Hv@lucifer>
References: <20260804-fix-some-local-headers-v1-1-a7beb173c116@kernel.org>
 <8179be78-a35c-4d0f-8034-27f3154db0e7@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8179be78-a35c-4d0f-8034-27f3154db0e7@kernel.org>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: E19181C0010
X-Stat-Signature: g65681zi8rwunpj5ze4h4upb47gsy4m3
X-Rspam-User: 
X-HE-Tag: 1785841391-873149
X-HE-Meta: U2FsdGVkX1/iwaQgRShxKT5GzDcMAfzKQVX28A5HvZNgZN6v23s6pAQVbP4znJ5gqE1PkLMeop01v7t/+I3jR6FSy3O+nzprm8Iw0hNPVz0V3IyyEE1fRR1n/aaidal97Ui7jx+8EiGPzpWgzY1d4A7bvNmH8wjZYP3ONlImGegrGHJtHLf5QL63ydh8yyukpPP7Dz46C4HDAZKmiv++rqu+wdIS807fTbg22A5/7qgpdCjvG+GT/IhjRo8C1DmycbeA/S7azBOLURNpGJF3gtt4qGKxCdSWtSUJ7GWso2YYoLELfT740F32JL3xgPozLiO2YnJcU0wxufI0VbLV4jQHy3gslGhSKcEexQ5z1QcXDR41xTHxqYky9r64tMvRlrFkzK0rnL1rUuyhtRd8uQDMD9zttTzyrTQ8z1+9HwbDMWcpQKURzYn55dBePZVuqkYaRK50HyrcB33tbC6y9sYOGZyVFb5Gc6647TVmvHon7aF0+EKYbKOaLTmJEMgq/CPryid6xYA0zL/X0dFmHJbCgivJVVMyVft+MoePAs6rud3m46IJPbG5ZUT9LqCoTjb+CshdyFzaRwzRc2IacHq1u5TQDC9VE4O/dZIT6bEqoxhgXyPDV0regZUyL1eR4pZiH/ex7Gh+kIcKhGjMG/OG7FSOAoy1ZtIsYmPR8TLhxfhya0wuSd5gdHxV/RNpQ0W3RT8p3l9WNM8h2ke/7fDAmv3FZY4Pi7yqBr4ZH3dCQBa7rzHj9rCwNrbXjhmctVskUjagnZAxJewhQlgS3AL7wWvdKw/+eAYvFSprcNdUs4Oa44ywj23jPSxglgthF81qwv2DztIR7KYG8L5jbgHRKYemBYBefVBB0WpaDfN6f3S2jYYNqmCd0Mv87JDueuKVFBFOOdW8oO6m2eB8acB8XWCina96l18tdiH7ZO9RDTRqnqA5IJUCsQes6hO6KYYJcBKrq6amAInO2Sv
 tNH3QbXK
 ZZ+xsRxKAL3IgE+YKJXBupkI8PBAP8CJfz4IRF88tIUUYqB3QJq1A0cbeY6cz0u1eLipm6ZEctFhJft7h/xBZg6X8BKZML9jgM6k+uorIBog+kZNnLxl4vcqh9PRsCI49kkp5ovbWZYf2cXy5Qbcbq4DA7l8kuPLlKmzisygpFtT/4INjjikGBbGCxiFs/HkcMNTpab4jCjbWOs7XKw73Iey3Py/16k8oTIWap7lv6v3v1idY+pUuTaer/TFTOp7SR8lr
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 04, 2026 at 12:45:22PM +0200, David Hildenbrand (Arm) wrote:
> On 8/4/26 12:08, Lorenzo Stoakes (ARM) wrote:
> > There are a number of internal headers local to mm/ which reference
> > functions and data types without including the relevant headers.
> >
> > mm/vma.h is a special case that intentionally does not include additional
> > headers, but the others are not.
> >
> > This breaks tooling like clangd (which is where I noticed this), though the
> > build is OK due to the C files including the headers happening to include
> > required dependencies.
> >
> > It's better to be explicit about dependencies anyway, so add the missing
> > includes and fix clangd as a bonus.
>
> I'm curious, how did you identify these? The mm/vmalloc.h is rather easy, but I wonder about
> e.g., mm/shuffle.h including mmzone.h.

Well I got AI to look them up ;) but I pared down what it gave me to a simpler
subset and checked everything so I don't consider myself in a state of
slopper-sin :)

[this kind of check ideas, look things up stuff I don't consider warrants an
Assisted-by tag btw].

The headers for everything but shuffle.h are obvious, so that's the tricky one -
it's for pg_data_t and struct zone specifically.

How I discovered this with clangd initially was - Do something like 'C-c l g r' or
'C-c l g g' in emacs via LSP and it reports 'no symbols' for something I _know_ is
compiled in.

>
> --
> Cheers,
>
> David

--
Cheers, Lorenzo

