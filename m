Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C4783C55196
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 19:13:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 859196B008A; Mon,  3 Aug 2026 15:13:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 82FFA6B0092; Mon,  3 Aug 2026 15:13:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 76E766B0093; Mon,  3 Aug 2026 15:13:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 49C3C6B008A
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 15:13:31 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id ABA16A07E6
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 19:13:30 +0000 (UTC)
X-FDA: 85060906980.27.569AA52
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf14.hostedemail.com (Postfix) with ESMTP id 5631E100002
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 19:13:28 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=A+8rchtB;
	spf=pass (imf14.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785784408;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nI0onuaG9wyqD8FHCDj8ZAQu5ZB6RKn93+hY53Lv48Q=;
	b=plGe+Wq2F/q5+a+PdA9FtxG2nM0BiwaE1AqWSe8iChBczdGnKDp/bklWjID+qdL6G3s9Nh
	yV1s2zw3ILMLqUL8P+Icp9WTkHzKBLozquITOsvK7bnLkAgySZeVGG4KPsxkFip+8UgBxc
	QbdOYcjyOIH43WuZw/q4FbtNzz9+WZw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785784408;
	b=faX9Bt2emtNM1kTP3IxmrvHD5sKabId8BlaoDLfx5b18vmsUKfE3h9dWmZ+GquyZTbQpfB
	bv2PJc8JEUzqeW71nJqoup1SnzRGwGYmpyIrHnuGTKIBb0djgfuzSnr5wAMUstWvug/nJg
	MhHcrWB1GZoNX2JtFtkximPuVT7O3IE=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=A+8rchtB;
	spf=pass (imf14.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1785784407;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nI0onuaG9wyqD8FHCDj8ZAQu5ZB6RKn93+hY53Lv48Q=;
	b=A+8rchtBGM15aCo72LPrHU8TufKlR54dqeKDVxcyabSNhoAwE/CDU2O2Lrzx0moJyYDz3t
	urkbRTFJ9gAETHLWbGrpc4zFF0lhRVLlBZ7wpH2cUhowLT1Ru/Os/PtJbsJEsxP7SfNAQB
	0MroqA1HRKhF6LYHAgPSJjDdGHa0mag=
Received: from mail-lj1-f200.google.com (mail-lj1-f200.google.com
 [209.85.208.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-153-sEkKnqEnP1OwgLlSs8hZjw-1; Mon, 03 Aug 2026 15:13:26 -0400
X-MC-Unique: sEkKnqEnP1OwgLlSs8hZjw-1
X-Mimecast-MFC-AGG-ID: sEkKnqEnP1OwgLlSs8hZjw_1785784405
Received: by mail-lj1-f200.google.com with SMTP id 38308e7fff4ca-39f6d16661aso14699201fa.0
        for <linux-mm@kvack.org>; Mon, 03 Aug 2026 12:13:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785784405; x=1786389205;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=nI0onuaG9wyqD8FHCDj8ZAQu5ZB6RKn93+hY53Lv48Q=;
        b=PjyVKUru6qd7woabTXQ3NAX69KE99unWAzxtXIqnIh5b84Vo03TbLwgnBkrt0hcqk1
         idOoOCkCGnZQDy5U4Z/otQl4q2trMDDojM/Rr8vwAWHstndFOn2cZknIxobd5vDk8uRJ
         8pg5jMGtytGY3pOtVb6/HbfFY6UH73Exy1RlzbJDbGp8KueqQCcfKjeXUoII+e2tpxWP
         /RTJ9qMgpfOx3xdsNSDHAWGckcygye7PIbzFALFVknmHl4HNGbga3wRSBXupyjmF9bil
         52lgVJVLfgX6D3a5TC5CGouByJTcrUkWFrPtJKv+iLNMdnJl2cLQyUX9y0f9bOholVq1
         Edyg==
X-Forwarded-Encrypted: i=1; AHgh+RqSpRBRi9lgdcPf2hCBi0/uQ/di2I3dF3dg5kk5yeI4X+f61tBnQi1TPnGLi34YL1eStWLqyRATYw==@kvack.org
X-Gm-Message-State: AOJu0Yxa2wEPGG6a7jlYqRfhxc8aDW/iVqIheQKP7fVtPeWOouCDNwgf
	xq+aTMJ7ndiYrVOH4w8IGOXWWgJ0Oluo2w0iQBuLgVbn8Mt+qdzWjtVhAAaUzD2Xz+rr/6XAD7m
	VKoGHCzzZUwVy5lM7NXDk7T1W6NIBwhLKblIWHX7CEh5iJc7ZQu73PlhX9NWzX7StSUHtwrOW3s
	jZcQcWLOujamvovgXW7bPczeZnudw=
X-Gm-Gg: AR+sD13OtlyuTT9zR/DXGDQXdjcuQYJAbyy6C/QRKBDIa2QgnAT1mNLKFgL3UKsbrHq
	Ww/7b1nzovHjS/6qoYW/GoECV8XAnSXi9D9HiDY5aP+NFNfobCwNeYr0VlnNxY9NwDAD+7cf9S5
	BfbkIyQZHMIssi7wAOOvrdukiSiUsZxnRrFBSDNezX3adyt6sS/UnSpF9RkA==
X-Received: by 2002:a05:651c:546:b0:39f:6885:ddcc with SMTP id 38308e7fff4ca-39f862f3e40mr21667721fa.24.1785784404764;
        Mon, 03 Aug 2026 12:13:24 -0700 (PDT)
X-Received: by 2002:a05:651c:546:b0:39f:6885:ddcc with SMTP id
 38308e7fff4ca-39f862f3e40mr21667551fa.24.1785784404363; Mon, 03 Aug 2026
 12:13:24 -0700 (PDT)
MIME-Version: 1.0
References: <20260715025941.1571316-1-npache@redhat.com> <20260715025941.1571316-3-npache@redhat.com>
 <ffb091ee-affe-41b2-939c-6437dd9cc13e@kernel.org> <20260730075217.qulyrc5s7olumqzp@master>
 <06b93266-d395-422a-9267-850c59b9f207@kernel.org>
In-Reply-To: <06b93266-d395-422a-9267-850c59b9f207@kernel.org>
From: Nico Pache <npache@redhat.com>
Date: Mon, 3 Aug 2026 13:12:57 -0600
X-Gm-Features: AUfX_mzLwaApnVm3544174r0RM6986sec5f6D1TWtNZFeSAY5qkb-whkHEOyvG8
Message-ID: <CAA1CXcA9cgQOvObiE2bECPaAV2=v84b-tDAwLY8UYrRVm1wqOQ@mail.gmail.com>
Subject: Re: [PATCH v2 2/7] mm/khugepaged: extract young page check into
 collapse_is_referenced() helper
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Wei Yang <richard.weiyang@gmail.com>, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Usama Arif <usama.arif@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: TcrsYr4WTj02dYfiLfA46MzsFWvfpOLBFspK8EPjZF0_1785784405
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 5631E100002
X-Stat-Signature: 95ibtarcgj5xs57amqzbt6wtyhja3i9d
X-Rspam-User: 
X-HE-Tag: 1785784408-967995
X-HE-Meta: U2FsdGVkX19oCzdmZyRLUB5zKe6jMXykP9eV9zzn45+rnQboUiVPMHv9Mvp7e3VnPOwhtxnNiUOvYX7fuqckf2StihAmem9ig1DyLqFrk2PJlJ71rfdzBpgZ79bdmW3JxiWRTkUdjH2DczEEBCAKRVfhrnJ5TqfbwRbIcuHK4BB9wmhQZd/JFPDVHWZcMXDJUrQzoJirF1R/EhacmSCO3+ymYlSOK5+aN5j0zZEH5eglKWyoYJDBfqwlXLVzS1y34NzpIq0jLOMLrCa82cadNtTOZwgpNHEXuPEdTUaE7TwOOueMqTM1e7xgn9mk750UDWw0SyCrvSaVZYDiqAW2sxVspVFPj40fbnxD1c3qmm2JqjFLICWFOiO8+shyuBAHam9rbM5H5J+oPlaRHoNQOZVRgl6IDZSGOXv/hL40Vx2ym2xwZaqSqviBpvmnW2c/MIULIUmIQ78bHN+M1Cb0IdaoYTg0cIH1L+qI1s+pQ1anL9lOBqFko32XcN57W84Gui9biIh9fNjDgNSlVHVLZO3H2Mqkd63C4eth8+QicgYFkNutz0oZPrOzOtQSdckG5UQrA76mXr4rlX9A3WoFOy2kIuKQAb30bnzCrMOa4UVQv7m/g2FE7sfGYGKoEoWEs0NhuyobuFFn4VRjuYm6zTwKarW/F3+NqhLotgzrXyrHf8ZDNSzS+9LG3NEycV/hZcjeP3visvop8SGfmVwaq6y+Qv4jjUPN6AadoSL9rdVnRobCDsMsgu4UiExb2dzkQC4PNghv+7vfH/mD00DIRMRvZk3VVD4frdGQeLUHkkSi0n36r2p6fNVx+uIbrCNDi6/U2jvgX7k9HQfoYhfGslONV4UrmV6PZFjR4dhixdPEE1flr7GOpVw5j7WWGqzUP8KAdidSReE966oibNZuk4YYWyoRUkP7dabjzOpQnPcxihyRmPQ8Q8Yw3RajfpBhTAeW/FB8V4v6qniCUxr
 LUTldmZB
 TJhwITl6S4DvU7NqVyNEg0Xo9IM3cPodPSfXVldCrG8qOu1JkbNDam33H7TR1BESbE4PvSWyxnBRH0Gcy2qPztOuQ0fhignmgY32RrnbPEL0h6jYpGRg9m5LF8LL2+4YzmncbA0AISkb0oANLNwOyOl9yWWOzs7AXbwnLE4tFvFMolGoPsGeCq5ivfWOnhxtZ9Ntrqz9fMQBs9R2evlkfXD1TMQ9WqLz+LkIH6lv2kwxjwTv72cKHjElVruneAqAUZ9ua6j0m71SVrewWtEMwEcj6jy7N1rthkKndUSLQbR0zTLHDl0pAZJQqTASdiH9U0Vq11iXOykMXOMT8CPpZMoQe9anJShVEy+6rZX56McZq1FTL+oD+GB5Teka7uxod6RSq
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 30, 2026 at 6:16=E2=80=AFAM David Hildenbrand (Arm)
<david@kernel.org> wrote:
>
> On 7/30/26 09:52, Wei Yang wrote:
> > On Wed, Jul 29, 2026 at 11:47:00AM +0200, David Hildenbrand (Arm) wrote=
:
> >> On 7/15/26 04:59, Nico Pache wrote:
> >>> This change deduplicates the "is this PTE/folio referenced enough to =
be
> >>> considered for a collapse" condition that was repeated in both
> >>> __collapse_huge_page_isolate() and collapse_scan_pmd(), extracting it=
 into
> >>> a single inline helper function.
> >>>
> >>> Also move the comment and use it as the function header. While we are=
 at
> >>> it, updated the comment to clarify that a young pte is a recently acc=
essed
> >>> one.
> >>>
> >>> Acked-by: Usama Arif <usama.arif@linux.dev>
> >>> Signed-off-by: Nico Pache <npache@redhat.com>
> >>> ---
> >>
> >> Also, do we really need this (badly named :) ) helper given that there=
 will only
> >> be a single invocation after #5?
> >>
> >
> > Hi, David
> >
> > I see collapse_is_referenced() is invoked by collapse_scan_pmd() and
> > __collapse_huge_page_isolate() after applying the whole series.
> >
> > I didn't see #5 refactor this out. Or I missed something?
>
> Looks like I was daydreaming when skimming #5 :D

Yeah it does get utilized twice :)

Regarding the naming, do you have a better suggestion? I had
collapse_is_young before...

Perhaps pte_is_referenced()? or _is_young()?

Cheers,
-- Nico

>
> --
> Cheers,
>
> David
>


