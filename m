Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 16BF4C79FB6
	for <linux-mm@archiver.kernel.org>; Sat, 12 Sep 2026 10:38:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 92AB16B0092; Sat, 12 Sep 2026 06:38:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8B4446B0093; Sat, 12 Sep 2026 06:38:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 77B736B0095; Sat, 12 Sep 2026 06:38:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 558E06B0092
	for <linux-mm@kvack.org>; Sat, 12 Sep 2026 06:38:38 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 86D02140437
	for <linux-mm@kvack.org>; Sat, 12 Sep 2026 10:38:37 +0000 (UTC)
X-FDA: 85204761474.28.C8ADDF0
Received: from mail-qv2-f12.google.com (mail-qv2-f12.google.com [74.125.230.140])
	by imf15.hostedemail.com (Postfix) with ESMTP id C1825A0004
	for <linux-mm@kvack.org>; Sat, 12 Sep 2026 10:38:35 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=kAmEVmi6;
	spf=pass (imf15.hostedemail.com: domain of gourry@gourry.net designates 74.125.230.140 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789209515;
	b=NnZ7OjcMpE2xaHjdRNYv43SR3vsbFqYrOakellXrnQ1reeyM6PgFVpiVTXc+RlBoopkpno
	/WaS/AvFSKlwiHir2HfK/GOvS4HRxiXLS0mrFLFoc5nBXeVYfT3066W5Eg1pU4f5lPLxrc
	y4kYWa7p0YLwtE2FaspxpOTARDELpXo=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=kAmEVmi6;
	spf=pass (imf15.hostedemail.com: domain of gourry@gourry.net designates 74.125.230.140 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789209515;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f/CrlY1PVfKWoR2jguJZAgonMbE0XWHPet0laqBWYc0=;
	b=A6jJfgZ8a4bUWBTg+rA31QWowTwU349lUfpuMZXoktfKupAwxDBA6qteTT5sNqaQpjntSm
	Uz7Q4bTsovTshIiPeVO5a8GBPBKRmDYynniX+l88P5zQ64dQzU10HW38iD2hVG6cYHhyEt
	NUwYu/oyUOgtskOvbHgS4YNs3OCuQ5o=
Received: by mail-qv2-f12.google.com with SMTP id 6a1803df08f44-90cdfcbe20aso6452326d6.2
        for <linux-mm@kvack.org>; Sat, 12 Sep 2026 03:38:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1789209515; x=1789814315; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=f/CrlY1PVfKWoR2jguJZAgonMbE0XWHPet0laqBWYc0=;
        b=kAmEVmi6R75IhN15s89LcQEDjGNYz9Zx+o7zVOFyxDMfGxiLcVBlmb9dzELwCcZoUl
         1m3CAWSn+rFgIFurVQcUjc2v1/AMjwFUTTQU8UwlTLFQSdVLrOEMP/Q7tnuT5amE0qPq
         tt0eefj5euSq+4sp4T4HKePtfBN7nzdfehnDQilQZRNbCHHNEj/OHNm91l/fcWB6DZ8O
         Ax1dpVnZamViCoDbsKVuqnuOt9lnRD8w6La1TLlzG7QmWlbjn7IA/Lx75nyVIH+LHWyQ
         T+dgk5cZtPNcO2gB5HgqLcxr6ca88tYs6hGAd1vZMtBDafXRWDp4meAF1pFChJo/9Oxy
         h+pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789209515; x=1789814315;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=f/CrlY1PVfKWoR2jguJZAgonMbE0XWHPet0laqBWYc0=;
        b=P6eMG33KVWYPPlY5kjRKhNDZXkDhP94T3Jo/160Unc5sl/t3g3jRj22OGJR7rPBup0
         Nrr1mFG24va2WPdA5vkUPCn3dMioXzpnxRxpsQwpTlHf0iQwxRLV9bm4TtogG5tGuVyI
         53RpahKk/57sH9xEVTNCVgaXGe63locGqfolbUwXbte7lWWbN7TKdrLxRv3x0QS9Vbzv
         irZe3Sfu1PQwJ6Pq0WMx4SFwjq8VG5Rpf3wEGvyQ9D8B35psb5rzcJ3gw+LZ9RjsvWbn
         YmWnQedJe2gAa1b+6kWREvqu6v+fvgfOKx/lhu+AO3edbPfA9HpZ5/NcgsIk+sQ3PVuc
         WTCA==
X-Gm-Message-State: AFuF++kxjLTIJP+MBTqH1yDOLJJHvF/KhX4wVpZH0Iuhgybj9Lp3kx/P
	PO5ckyfpkr8EnSwfXd1D8CLFRxZlGXSAGzPVMvLnvrDt+5jCZWK3wZU6misnU0SrBkA=
X-Gm-Gg: AYBFou0GbgcIV7gHQvbU9H2j6aU2rpVC9R2pwEYwiFwtswYsPFpIso3Pqqfkw3wI3q+
	S/V30KmNLpDKmixZwNfuVc0DB3CzHmjNs9nEok8L1unrmTO6ZLzINSuOAtmm2pEY9dPAHYD7l1q
	OkTO3J4+WzKL9gn1qCWTktJIyp2hUxwdfSXkzQW/8qnIBeCXaoRf1WUlqAAhAF20bP9xEW5xQ6E
	SjJqrH0rWbiF/3anbC5UcpGCgu0mmnU8AUClgiehboSn346Gw+XZy8X8ZsrQ1/F2XZQScHBl8mr
	hbNQr5uTZES1e+SDb6IbPIN54dLpHGF2q+N3fGruO21eE18J+9zfKruuIJn7JMno2EbkmJD2Xbq
	we0QP2+Iuw5pn9aV7UsS03jlINvWIRFWgg8/bQ2lGN1XS5y2nPfPocew+waMO39EMldzhfIJsF9
	Cu9rJlH47YPSIkIXANkSF9L2mFXdLd2v/Ad75NRyFhnz9QNoqjZv4/WvbEsOIcm2BfiJ5jX358w
	lclWTSxJb/rynAqOiiq+0y0+rKB7Gw2i6kW5BnYwYfKc2efvBM0Fjw=
X-Received: by 2002:a05:620a:4450:b0:939:7d8b:93e0 with SMTP id af79cd13be357-93a0360887amr311772985a.18.1789209514912;
        Sat, 12 Sep 2026 03:38:34 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-939ebda519bsm407605685a.26.2026.09.12.03.38.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 12 Sep 2026 03:38:34 -0700 (PDT)
Date: Sat, 12 Sep 2026 06:38:32 -0400
From: Gregory Price <gourry@gourry.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com, 
	liam@infradead.org, ljs@kernel.org, david@kernel.org, vbabka@kernel.org, 
	jannh@google.com, ziy@nvidia.com, matthew.brost@intel.com, joshua.hahnjy@gmail.com, 
	rakie.kim@sk.com, byungchul@sk.com, ying.huang@linux.alibaba.com, 
	apopple@nvidia.com, peterx@redhat.com, jgg@ziepe.ca, 
	sashiko-bot <sashiko-bot@kernel.org>
Subject: Re: [PATCH v2 0/2] mm: stop calling pmd_folio() on special PMDs
Message-ID: <aqUra5h3YrYwoDe9@gourry-fedora-PF4VCD3F>
References: <20260912034833.2952750-1-gourry@gourry.net>
 <20260911212503.bcf8461db17ebbf51233826a@linux-foundation.org>
 <aqUqefve3AEiJiPq@gourry-fedora-PF4VCD3F>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aqUqefve3AEiJiPq@gourry-fedora-PF4VCD3F>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: C1825A0004
X-Stat-Signature: 1xywwcdh6sdit9b8cnbccb5b7u7w4t84
X-Rspam-User: 
X-HE-Tag: 1789209515-366925
X-HE-Meta: U2FsdGVkX19qcHxyAWqGXpkbKmTVmTXXH2vTuAW5VMyTt7BBf3H2eAxpy2XdNK9KC/foUpzgLCVVkDgkeZQpenJnhtNZN9fqzHrJ1cfZKpc6ZJ9NZxNGkQdRtm7CDPXH186AyO2UPfqZ8CY9qTSeplM/qwctz8bo54LexI44keEWzSWizsw9pfWoacIvNf+Iq7mU4TG+Gf8jJiNNnQfbjQpKODdy1ud/c0szfklxHb3GTxMeFdgZFj75ECfiWQjtWUVT2LkTqWInIdB9WlN77YrW76vnMdfAaSkIUZYTsNHUJRLVbGp4455en4qSQBT4NNeDCe4Os1wS+tad0qbrRTORKMo9PVXVuFRqoTnVa7v/u6ZQw9fb0HmB7U6w8auga6BvKZWlYw99p/T10tBOKmhG5z6jEO98jKlq11vDhVhMuP3Z1s41OKJnuO6NmfCCCwJmomUTEeVDQ1hL/4NvnxlNC/TY1rq22vGKPjk4/r+b1ITBEgf/8R92NktCeROV6HAVUYVaTLzLfA1WcYf56aTHhnQriwuGhbmHcjpFUYam6EU6mOm39XA/Hnh/FRBOmbZGLD1hgnFfgFdb+SnVIvfbwJGZcdfvPCnCnLxhR+YhppB8E5dT5cVLMAdQ/WTnH1yw2AxBIzaRlEcrOIn+HWf0WYbPkZ8pz4phSWnxHoTMD3XPQ2RCGrmWVuSiEJdm/fuO8ptCNhr1wUtx1YmERzLqff5Mi2XjT0eN8eK/Lhr6ncT2JhM8BRLo3K8+q66PaPNEdnKqCEs6cDk1IugfVlh9+iJw5hUsfpwnnduGq30Y8Ad7XE7yXAaj+Xl60j9J6eugMNm2ILRYxeZ3bd5Swc9KIOKanl5XZ7DgxPbsu4IGJSSDFl64Gd0X8vpetAUiSIev/NoS7PgrQbobWzQH9VufCzFyfMJ9MUrvinmFDugafkJCaAOpwRD6naImJ7yqMWxfBlWlG37aYl/3sZP
 6KJP064+
 VwzuQVlHBE9x0eYpcY3WMXdCrlkziR5QDTRr0y7DJK0J/QEHUt9tFbH5CIQo9gPsg8O+3ZIPck569cd66mSK7ogpPauQefB3xPZRqk18j2CZWJteMquFO2GkY3pNq2jRvk5pP59opLxEozsHUhIowXq4ItW+VGVn1DXmFle9um5YBj3hjFz9ZR7LvN0rIZDqDzLxYtk0HcpEBpdnp0Zoz3O3M4OYbMc+QVZ7u+N02bGuJWKsP/JbZerBnFfTuKS8vrxTlELWMwIeqp+kHngmqcVGQZC4kF5UAPQT3ai6HvvzGPnJnCxtwvwmV7x/qTBqJ3UD1acqvIOR5zsMlaARZbmhXUtshLL3Sk1PgZYulnNFoPPd39UZtBR7//nPLn2SZemd9SIlDQqYkEEvoBL6zcKuJ7c58FcaYc2Ofra0HeNPy/NYRRUZLmMhm/+o2IchXtg/om79IvHkd4RRriL9iKMzhYLftFhmSTSPYvmRTzqdAB9J5cuYlxHyqUI7KRvzZylUm
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Sep 12, 2026 at 06:35:08AM -0400, Gregory Price wrote:
> On Fri, Sep 11, 2026 at 09:25:03PM -0700, Andrew Morton wrote:
> > On Fri, 11 Sep 2026 23:48:31 -0400 Gregory Price <gourry@gourry.net> wrote:
> > 
> > > Reproducer
> > > ==========
> > > 
> > > No hardware needed.  An out of tree module stands in for the drivers above:
> > > three misc devices, each with a ->huge_fault calling vmf_insert_pfn_pmd(),
> > > plus VM_HUGEPAGE so the fault path takes the PMD branch.
> > 
> > I take it there's no known way of triggering this in current mainline?
> 
> As far as I can tell there are no in-tree modules that reach this state,
> at least not obviously.  
> 

Ah - sashiko did report a similar issue in fs/proc/task_mmu.c though, so
I'm going to take a run at doing a larger detection run for this
problem.  These patches are good to go though.

~Gregory

