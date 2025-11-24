Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F1FB2CFD313
	for <linux-mm@archiver.kernel.org>; Mon, 24 Nov 2025 18:08:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5CEA36B0005; Mon, 24 Nov 2025 13:08:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5A6916B0028; Mon, 24 Nov 2025 13:08:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4EA296B0027; Mon, 24 Nov 2025 13:08:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3CA0B6B0027
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 13:08:20 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E5C151A04E0
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 18:08:19 +0000 (UTC)
X-FDA: 84146285118.17.D1A9D36
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 3B777180012
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 18:08:18 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Rez6gWyt;
	spf=pass (imf16.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764007698;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1EDndxfXQbvOqPBlz8NrS7Ws7lhc2QHJjs8Zhx0VmNg=;
	b=N0GEWqzgbehwdkRwfD5SA1pSBydFeMqSqMvwr/gUmZtQD7N/O7vt0UcDl17LdCuKkcCXZp
	fTpSmJ0oClahnDJnjj/WYV5UarzwiFk/Dzbzi8Ym4/30DqcA1pN5HGi1labEpY28FpoZs0
	t182KPl/iCLJlKrWZsDBWm16XzrE6fo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764007698; a=rsa-sha256;
	cv=none;
	b=54sDGrRszhdAM5A9+GCLYkGp8yziZj4B+JQBdalZRcO9WY30FCRslaqct5sV18o5dv+WKS
	5QGxDArsQPCqYtR3ErOI+lZTgpfljrwWtYyKxVn8A0uSMVqJjMcEd1vMv3WxJTIZq5FWMO
	ufP5ihdpReqShzdjsicUVYJQxhWMFFg=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Rez6gWyt;
	spf=pass (imf16.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 47C6F43D99;
	Mon, 24 Nov 2025 18:08:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2090C4CEF1;
	Mon, 24 Nov 2025 18:08:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1764007697;
	bh=IlF6JklCMMnUUMN0qCEJlEyZPZI/K4AomTLbC+Ab6gE=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=Rez6gWytpa46FR5MaQj+eFH7x+37KxShAIV9jQ4YyOYt6s8w5g8GgQtNu940wrHOX
	 hnpReiw6vr9TsK2VaGWJKo0vSkacJRDktv8nbsI6CRaDG16Vp01fkHT93/GaR4sjQp
	 agbeoqpaPFI82E5mBj4t0emDIiJs7SwLNBrasu8E=
Date: Mon, 24 Nov 2025 10:08:16 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: Balbir Singh <balbirs@nvidia.com>, Catalin Marinas
 <catalin.marinas@arm.com>, "David Hildenbrand (Red Hat)"
 <davidhildenbrandkernel@gmail.com>, Jan Polensky <japo@linux.ibm.com>,
 linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org, will@kernel.org
Subject: Re: [PATCH] mm/huge_memory: restrict __GFP_ZEROTAGS to HW tagging
 architectures
Message-Id: <20251124100816.a4f16b6a84bae7c97dfc21fb@linux-foundation.org>
In-Reply-To: <e83945be-056a-443c-b140-e3301c2109c5@kernel.org>
References: <20251031170133.280742-1-catalin.marinas@arm.com>
	<20251109003613.1461433-1-japo@linux.ibm.com>
	<690ce196-58cb-4252-ab72-967e1e1574cf@gmail.com>
	<aRG05VS-IIxV2y_C@li-276bd24c-2dcc-11b2-a85c-945b6f05615c.ibm.com>
	<fbca7868-6f68-4b98-a2f2-e39eb46b7f12@gmail.com>
	<aRIEkLw7BofLjOWs@arm.com>
	<9ab7f5c8-a2fd-497b-a32e-4def84e0be26@nvidia.com>
	<e83945be-056a-443c-b140-e3301c2109c5@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 3B777180012
X-Stat-Signature: 1nh1p8w6u5um5b961bz4pc48hn1cgiic
X-Rspam-User: 
X-HE-Tag: 1764007698-679452
X-HE-Meta: U2FsdGVkX19uhqo4HjFUA94ttGmFplD30UH+t2ujQBWuTFipbc4+3NHtpZMfThh/sv56DWLO1RIwzCCHpH4qHKItEYKEH9Pxi9O7nHiE3W3NAVR7e1VmZVZcZCeEraZbIDZczsejKNadtSU1DPNRuE3/dX9V7jJlc4Gjx+WqdngcGD3Irgm9dEYOUkJZqvh2JpXBa9hXzAtej1iJhd9AcOMuUoZo5hy8xAf6fV0iGRYZc4LY2umLv1FTos4WNlL7e/U5AxzrEfPVTGU7xcOGwQ4+bAVQ3Byg45rSPGk8BNqeqPZTevKMiiW8B9fDyuKEMJuTCV+Q20V07UNlax0Gz3H54JpEv4D5MOJ9dHiMJJM/5cE8cXswNUCG08iMDwfWP/1KONKFPg4ixik1MFe85tCcS5wvG+AZTewPA0AU2Kn7HlXqoe6wjPNSgbeCvmSbzVn26JDyY4zfRWSQGGwfIaiDaGpXeA6RnJHakyJqkcVZQPGX7/T9kHQPd8pJ6mqqjF0L4/WAjXkCKCPg+5K7eql5dWLoT6x7vvWbik22xFvG9sKMaVkRTzApT8nkEkfRNJDdChyGiIGuO4FSngS6lrFP1SIUdH5foLysFFkFzyl9/beqZ5OBL6kUuQzQS3JpcpdN0QWWFaowEYRyPnt6DhFjjbGZGYGFGXuD+QVkurvtM1aYkm/+p6s3739+u8WKiKoOFzIHDq4l9+y7jSuIbWxn/ValE6Irvx8qf0t4X/NjB6k4hhF5qXiyzRJAVRa0HyZM1t5N/oAn8x2ObohILnyrO9ncIx+FePAVZANaCb1ImyyshRVNZC2gxhzYIqUQEToA5JyDxZRpWZsoe2m06tRjtol/cZd1jvwv1hc7h9Y7OquvAO4/uLeJAlPqQSDu7yJ7quX782+VSqz4Ifh06DmXk5DO1rwI4s6+lhoxRkHywlD8xAhiL9OQECony9dxLUIYC+EGF9swFbJv4lI
 kAkA/5pX
 durK1JXfqGrv7Qdm9sP03djoiOyNCzjHxXayDJHheuxJBKNbiIE8pPqtV9LGj6A92NcCle/XYr/I32R6f95WKFINZjh+2/p6uXVlBEyjO5yabI9MkS4KrWISEEx5QyumDPNerUX9RimyTxQH0XUe2iAJH5fbYHGHFdNXZAFwN9/6iEyNqcRllX6uxhGWrBoi62wYazstbXi4gR2Qo6bEuuGmAG6yG6izeftarRWMSw3SgS12MNxrFjLq4WaNdsfbQe29h6mEN0dUK1Yc6T34UzuxLYeh+K7fon/1rAo4iUn7LN0cyJgfzXIWcijIRhMmfC1z4nvYpks+4qJb7h9tN4EtTyk3Fz+hXvQB0S6N+e3LD4azSuUxX3XoD1IvzV9CH1ERl
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 24 Nov 2025 11:57:09 +0100 "David Hildenbrand (Red Hat)" <david@kernel.org> wrote:

> > I've run into the issue where due to init being set to false if zero_tags was set,
> > the system does not clear the zero_folio. I just spent a lot of time debugging it :)
> > 
> > Catalin, were you going to send out this patch as a fix to be included in mm-unstable?
> > I've for now reverted your __GFP_ZEROTAGS change to get_huge_zero_folio() for my testing
> > 
> > I am on the current mm-new branch.
> 
> We have a fix upstream now:
> 
> commit 5bebe8de19264946d398ead4e6c20c229454a552
> Author: Linus Torvalds <torvalds@linux-foundation.org>
> Date:   Tue Nov 18 08:21:27 2025 -0800
> 
>      mm/huge_memory: Fix initialization of huge zero folio
> 
> 
> Andrew could consider picking it up as well temporarily to fix the issue 
> until we rebase on top of the new kernel.

Sure, I added 5bebe8de19264946d398ead4e6c20c229454a552 to mm-new as a
temp thing.

