Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BB394CD3445
	for <linux-mm@archiver.kernel.org>; Sat,  9 May 2026 18:08:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7AF766B0005; Sat,  9 May 2026 14:08:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 760DA6B0088; Sat,  9 May 2026 14:08:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6763E6B008A; Sat,  9 May 2026 14:08:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 560F96B0005
	for <linux-mm@kvack.org>; Sat,  9 May 2026 14:08:46 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id CB4EE8C200
	for <linux-mm@kvack.org>; Sat,  9 May 2026 18:08:45 +0000 (UTC)
X-FDA: 84748667010.25.07C3C19
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 1AC52140004
	for <linux-mm@kvack.org>; Sat,  9 May 2026 18:08:43 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=f1F4N4Yt;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778350124;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jJ98ZLYKUzyDL+xs7lNtTANHycku3bPTtGa/gUCvaUg=;
	b=Be9DnQYdyHCZRZzhtbK4iy3bmWRKCec+qJeotMMuVSmMIVQL4PKVBqFAAz9aI6QIdmuODU
	dhOni3iko9PJteLBeWJKbvjHZ8g4/SCgAwPSPr6c1WPFO4E0EdX42NnH4/pSVmCZ3e+G6I
	N/FdiiLvxSkJzflw8SlOw+BmzILfeB8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778350124; a=rsa-sha256;
	cv=none;
	b=UN3RQtRevL7OwSDeZtioyW5maVnZNqup0RFa9z4EjPg2BdwJesIfm3rf6RRZdtwHrE+git
	zFwDQDRikcpNdoVT8PrCSdlQSuVxylmWD0ye9ASqdAVV45RduCdBDq8iAvnyaOXNRGiwK/
	NfOWfPDryT3t/r7YlG6SoTjeQrlGSd8=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=f1F4N4Yt;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C0BB243CBA;
	Sat,  9 May 2026 18:08:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 783FAC2BCB2;
	Sat,  9 May 2026 18:08:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778350122;
	bh=Xue2kNTph1DeSV3TcWxLD18s+ANHdngAml/KOCEpdGg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f1F4N4YtSoMiyOp/83BbhtnxXh4UyvdPh3gXp7IVv6tw2KpNQV3TLMyRbht5Yseoj
	 hRA3Sm9oBUbglj2zJjVJO3lFdOzySnQoKfWy085vV8H4frku7c4NfIqE3MQzxQEWzD
	 fh4MZpK0fbBSNo8wRs7Ey2bVfUEvrrg0VTBQx7ir6HNMCfwiZsEs1zk1RnHxZKhbT5
	 NRCrXI/j55tYRLi/wnawIZnqnxowSV238zNDmfukSjqglIZ81Jcn21Rp61Vc8iFEbl
	 +vUOI1e2XwjkchbT8qCjWBooJ3Mw1f9R6f4izaQrGwCzE5kWFF33BYyCFpz5JSG3O1
	 H+gUqKninmj9A==
From: SeongJae Park <sj@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [RFC PATCH 08/19] mm/damon/paddr: support data attributes monitoring
Date: Sat,  9 May 2026 11:08:34 -0700
Message-ID: <20260509180835.90078-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260426205222.93895-9-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 1AC52140004
X-Rspamd-Server: rspam04
X-Stat-Signature: y33khtcyawdeopmg3e66ia81gi65y8k1
X-HE-Tag: 1778350123-954891
X-HE-Meta: U2FsdGVkX1+INdMkaxJGIQ3hf4d1CLK7Z6ToCpwHVFIVhfXZ6vVMz/0jRgCvjmm+GNbJvuJEMV/rVyTsp+Y4uyymC3wvUzl8XpR4VHSA4kmS1hREEx5aVG7/p5YnsxTG7ROaFBCs1GCzlJrT2Z/mA/WCXqSFoonYfb0uOJVAzIs42xrdXo8MU3rYfVemxr13MWnnvnavWvERk4r97tzXm0XC2Q+IEd5MDOKSvlwrlWyaeX3/xZzTXGNmjSDY2SoLfiHOhSWxhNZIwwHnQoT7b2qcVYCReDXZ1o7dxrq4l55qHhxTCkdl7U42LjUonoRHtj1YtMu75j4oBFugINkKYYdpkrE96oYgTiKurZ6lBtJ5BdrNpvSwxVRWhGuek1TJZzjQ0GJXy+atzd+tOGiz+E5RQsfLNPCCr8EH8tJbXG8avhlDoXDrEpAlx33PAllZ2XE92uHarL0nGNM/Qu81SyAy2oQbWjwwJbY90n43nPNoEC0vDT+p+o/Pas6uT2t9wgE67iJ6ySl57FpCtITyvvzgLW+bDsilF3U/JAEtUcTKdKGF4ZUuKq6r0vfdzf2BE2Hnm8x2M+QOLdUwyGaKex+Ps0NKpEWtka68JMVyPWl0TLw7+BxiKDOXibpPnBnnzjplf6eRrol9j3qFsA0UzKgutNnzfGCcQT0kjg3/Y4Cq4U4Q3SosesuGY/ru5ebYUb+v+kuU2Gi2QbIH0loRIgkesH6WXdm0WKr0nI8vjqvYyK1a6im8fWPob2U35BcOWIQPPC6ln1lIRs8W9nkZCaELWqGHIDFFjqyi3oM8/qL8R4RquhKWLStqhuS0HZXOay4KGQE1uBcvPAiHMdSUJFd/F+A69LotJ03DiHLwAgEj8Lsxb+eoQKPQ9743Pxr0kMd+WnOH0wcygh9S0SNsU2kLPgU81Tc0DG64saWH6InqmuoXytEiU/ScciZYOr8ZxDj7Gqk+68X/c7WCYlg
 ZnvI/6tr
 7Saymqm4+MSsVQD3K2Lo/IG/u0+FGXtEFMZskA3ImLGH9qcehnsAasuO+HTFr9ao/0dj/r0VWZ8QFnSL+eyRTu/H8P8KmQP34OFU6VP5vorseHIaXaB0hBFGJbFzK8vBw7Tc0H1zbMR3J/ga3CCEufNP3coqgUMVA9u5RR+wkMV7B/zoFKqicZScPnmi2/UzTYYU4YTbJIwnQgYk4Vd7dwSZbIU7yws3f81igzKD9vwR/XBQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 26 Apr 2026 13:52:09 -0700 SeongJae Park <sj@kernel.org> wrote:

> Implement and register damon_operations->apply_probes() callback to
> support data attributes monitoring.
> 
> Signed-off-by: SeongJae Park <sj@kernel.org>
> ---
>  mm/damon/paddr.c | 45 +++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 45 insertions(+)
> 
> diff --git a/mm/damon/paddr.c b/mm/damon/paddr.c
> index 5cdcc5037cbc1..cacfbf774ca4f 100644
> --- a/mm/damon/paddr.c
> +++ b/mm/damon/paddr.c
> @@ -120,6 +120,50 @@ static unsigned int damon_pa_check_accesses(struct damon_ctx *ctx)
>  	return max_nr_accesses;
>  }
>  
> +static bool damon_pa_filter_pass(phys_addr_t pa, struct damon_probe *p)
> +{
> +	struct damon_filter *f;
> +	bool default_pass = true;
> +
> +	damon_for_each_filter(f, p) {
> +		bool matched = false;
> +
> +		if (f->type == DAMON_TEST_TYPE_ANON) {
> +			struct folio *folio = damon_get_folio(PHYS_PFN(pa));
> +
> +			if (folio)
> +				matched = folio_test_anon(folio);
> +		}

This code is leaking the folio.  I will add folio_put() in the next revision.

> +		if (matched)
> +			return f->allow;
> +		default_pass = !f->allow;
> +	}
> +	return default_pass;
> +}


Thanks,
SJ

[...]

