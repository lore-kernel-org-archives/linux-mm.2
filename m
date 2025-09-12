Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9C962CAC582
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 18:33:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E52138E000A; Fri, 12 Sep 2025 14:33:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E02268E0007; Fri, 12 Sep 2025 14:33:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D3F3B8E000A; Fri, 12 Sep 2025 14:33:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id BF7988E0007
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 14:33:20 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6AA265BB8A
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 18:33:20 +0000 (UTC)
X-FDA: 83881445760.06.2F83B31
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id AE0ECC000F
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 18:33:18 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MidjlJte;
	spf=pass (imf28.hostedemail.com: domain of acme@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=acme@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757701998;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LGdtVFgJ5T6sxMxrhDQUR2h5xDrtvZfKlGAOFUwEWlc=;
	b=RlUljWgoTl1zwfMRtanY6IZSWf7gvBQb6j64+i/9HTAbibNUk5kbnbKYaBGqUgpjBvBIXi
	0Yvqmaw1unxwHxr97DgR5vjGEXoG2LM9lIWjTp9Fs4GFcpgX1mdfQbS1XyeqOCkvKEbANE
	g4TCa3lonQ8FBu3nui2s1a+n35AVyaQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757701998; a=rsa-sha256;
	cv=none;
	b=FxEGRQ605u7s1N3Ry/DCx0jBlK8NLQ86zwX9NLqIzcRWGaqqpR0z958qcilecTsv4tlbhY
	QsUvaX+uOeBeR4zPQHaAQna95vFnT+zW4WtJd4VmlXt2PoKY2T6eV+mxKvxF8CMLcwMo4N
	qm/UPOSg9TNmFQdB6GYXbXukn4N40N8=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MidjlJte;
	spf=pass (imf28.hostedemail.com: domain of acme@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=acme@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3A3D7408FE;
	Fri, 12 Sep 2025 18:33:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98C56C4CEF1;
	Fri, 12 Sep 2025 18:33:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757701997;
	bh=KFlEUjBcWRsH4OTEaeOYJL8eDKrrcCJBALa8neJYRtY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=MidjlJtel7Cp/T9/t/kG+eRWK8OX8Bktd9X2t5+mf5Nxm8WSjzBE3ajxlLKHEH5HO
	 gA89BQNsNJYzWRV8ui0JzIU0bptIMIqv8PJK/fs/tgFttaRWXBox8emJ7hkZB1VzcO
	 6N5IlYHGCobFVhQUTEpe+8lQpPckEtozqsDX0M1FS6AARjyzw62J4WX/ulUWIkFqoh
	 T/9nEizFyDP79mlC1EDi8W74avUydLBmjNhv+Qg7ShJewUTFZVOSopzgOnYqTL8EJI
	 MCw8nfedCpbCT2ndHVTM48T13luMlojGZ6z3FjteNdacd4d9aSYTFCRsElqRpc4SvJ
	 l1QI4kNahO12g==
Date: Fri, 12 Sep 2025 15:33:14 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ankur Arora <ankur.a.arora@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org,
	akpm@linux-foundation.org, david@redhat.com, bp@alien8.de,
	dave.hansen@linux.intel.com, hpa@zytor.com, mingo@redhat.com,
	mjguzik@gmail.com, luto@kernel.org, peterz@infradead.org,
	namhyung@kernel.org, tglx@linutronix.de, willy@infradead.org,
	raghavendra.kt@amd.com, boris.ostrovsky@oracle.com,
	konrad.wilk@oracle.com
Subject: Re: [PATCH v6 00/15] mm: folio_zero_user: clear contiguous pages
Message-ID: <aMRnarU3w_XykRHG@x1>
References: <20250902080816.3715913-1-ankur.a.arora@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250902080816.3715913-1-ankur.a.arora@oracle.com>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: AE0ECC000F
X-Stat-Signature: 7wyygbjggz9pf34wtjobxc4ikmg1qx8q
X-Rspam-User: 
X-HE-Tag: 1757701998-923028
X-HE-Meta: U2FsdGVkX1/8R00kH73hoNAJt0F8jjmvNs34sgpXHuElVAc1e+oDaUNOxGFDeJkvkFKwyCEVTWJQ5UhknwpuktTYa6hdwKpRGyNtGVWraX8j5zYmgAphIWoVv7dO1s33wFbtxRqQ+iuphQZEWUxsTOmv72ZtZh9kl4hVnEJzl42Mw0F/7e9kv3mZg4jGV6HqL9LCUhGWYvbmpjQuWCJTXmPJgdccOgPZUGJ5Hw9pVUlRSqBdFFIUEmWaik+CfFxLSBC87GZVPuJoOqZ5Yxeo4/HAMen8Efd1NOZ9R8CUaANQeLaWR0TTNuSR0tHHViXCtX9CSQgmzTnCfa3XmatCVxujWAyAGixreMDHyWvuHbKNWZoKEWVdG9aNammF651rzP8kUYBPJ4ouT2OgNJUo/ntwHhGz+OPUZqC4aNydhxqNPeJXuY4T1j4kji6qn36FNwEsdDPBG3G9fscpGlHuK7T1GqhechvVYnq777BPcCJztcKTvRQUUaMEE7h2mV7y5C10b5HqtEhGELpd9pviP5CYDChIQhUILNlMPZXThenqsU775Y9IM1h3bjokSRDPMLxTnbGSuUmzrRFSU3G/YjnjOuFwji6F/oV+yXjGb3nRXmEdoYG1OMjoAA2lYUlr1WoF7/4y59/89nWwGGI8sDoW/wWZpIXKCLi66kpfSG3DI/18FrlXmxq3oBb83rIiKp8YVnD5WNMjr4WztKmDWu7l1uIhbNc9zNILOVi3dmRhBoZCDP/aCpU8rtKssHf3dJPmqWIYFBGG9zGh2YJMZDj7soC21fq0mIYL+o1hq2YiJhRyOWRm7IacPzBZCcvIYada6kxay9ZX+rBY2NBmk+eNz8NFIHzyTcxxt7CnA7GPktAIHcrtX/N00QodKfvyC91G+JBXgPcjX0+BTfWafzHCddljNclzgd8K3MTQ/w54P6JUtXnasc9GSV/qOYK3gJpjst9jOKoc0m5pqGz
 KtK7C3M4
 tIvVsCYpBblFMKz/3ddu2VvQlpmwrtyc2RLZEEgN5EWXxKBCQeo23tiHMnMQw4lLzPCofdzgYWdxQGrgkIuKJakJ/n57qDun2FAwGLQfoZ/lGcQnfA1PbJ50IjNddhibY4PaBi/b9nsCvbZqiornHcrZUAk+FjIAsFfxgB+GAeIzOMNslI6l6g+3qdZUz2n4rR/expu1T0jav9OQFsGjfCIsR6Mk1WFERB5pz4fFmOVFpQlNyhkG+R1kedJIwJbFSz/jhQ20QuZv9wpRYsa4UKdDBCmaZe2X3veXxzwa2Qp7QWgA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 02, 2025 at 01:08:01AM -0700, Ankur Arora wrote:
> This series adds clearing of contiguous page ranges for hugepages,
> improving on the current page-at-a-time approach in two ways:
> 
>  - amortizes the per-page setup cost over a larger extent
> 
>  - when using string instructions, exposes the real region size
>    to the processor.
> 
> A processor could use a knowledge of the extent to optimize the
> clearing.  AMD Zen uarchs, as an example, elide allocation of
> cachelines for regions larger than L3-size.
> 
> Demand faulting a 64GB region shows performance improvements:
> 
>  $ perf bench mem map -p $pg-sz -f demand -s 64GB -l 5

So, can I go ahead and pull the tools/perf/ bits into perf-tools-next,
Namhyung already reviewed it, the rest can go thru the relevant
channels, ok?

- Arnaldo

