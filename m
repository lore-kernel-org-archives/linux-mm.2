Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 74C39CA100F
	for <linux-mm@archiver.kernel.org>; Mon, 22 Sep 2025 21:34:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BAFC08E0008; Mon, 22 Sep 2025 17:34:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B85F88E0001; Mon, 22 Sep 2025 17:34:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AC2A48E0008; Mon, 22 Sep 2025 17:34:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9A6E48E0001
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 17:34:12 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id F1C3C160248
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 21:34:11 +0000 (UTC)
X-FDA: 83918189502.11.A5F9A52
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 33489180003
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 21:34:10 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=lD0HyuGA;
	spf=pass (imf24.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758576850;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fkzqONRP1JWZh8Hm3tY3m8ycHxfaI2bDYd+djXSxcQk=;
	b=yETZBWo0PgoMwJZBurUFEQpODZ8vIjlV8gInB57n/dQpMa/GbGsyZvlr+Vd2kJLsMIQe1S
	X5VcDkSz8cen0r3o9WjI6Ka3lPe7fRhXv8l+x4x1aCv6R1HhHt+ssJi19Zh/WWYQoiG97D
	cweZ8BfsF8aR9HR4lluOHZR5mTg+kT4=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=lD0HyuGA;
	spf=pass (imf24.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758576850; a=rsa-sha256;
	cv=none;
	b=RJeFh17N3IeRPK57V9qPewW9wqgmaSVunn6UbzLqAPAEANdHCipn6tAuUEDhOfRjBO3NXL
	6JUeEDI+PUidjoSC5JdJoHCiJnEQuVvjIkJhUKjd+WNY1qtVXXWBRq+GpjxnqykKJPZels
	XMHzF27PXAwTUhihG488j0lwfpLARVo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B058A403B5;
	Mon, 22 Sep 2025 21:34:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B04BC4CEF0;
	Mon, 22 Sep 2025 21:34:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758576848;
	bh=eJ5VtR70eO4BCYnBNWbIL5V8RzRuhAmch8nOpB/p+w4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=lD0HyuGAiwZT045i1LqSR7lGe85sOzhllEa5mANNVoQBlmcrWKihlL7PNnRI5ITQm
	 ayJAf7l5W/qL0Mm0zBsJHAHIQZuwhkR4wlQd9eerZM5G/5d0MWVyS+Uddor24T/2My
	 hOoSI+h02LD/otpDWssYUFft6+oM/zRtvMMahYv0=
Date: Mon, 22 Sep 2025 14:34:07 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Mike Rapoport <rppt@kernel.org>, Alexander Graf <graf@amazon.com>,
 Baoquan He <bhe@redhat.com>, Changyuan Lyu <changyuanl@google.com>, Chris
 Li <chrisl@kernel.org>, Pasha Tatashin <pasha.tatashin@soleen.com>,
 Pratyush Yadav <pratyush@kernel.org>, kexec@lists.infradead.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 3/4] kho: add support for preserving vmalloc
 allocations
Message-Id: <20250922143407.93e171f8b7c09eb21159a33e@linux-foundation.org>
In-Reply-To: <20250922131948.GX1391379@nvidia.com>
References: <20250921054458.4043761-1-rppt@kernel.org>
	<20250921054458.4043761-4-rppt@kernel.org>
	<20250922131948.GX1391379@nvidia.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 33489180003
X-Stat-Signature: ohrngkwbfww35ygdxexun74rdpasgt57
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1758576850-265408
X-HE-Meta: U2FsdGVkX18Ry7q9lke7y47Z2pCrLdbmlR7MlKZnnctbwznQZoie5JyMhMjCO2InsHeNRir97rZnr+t0+icm1nMPr/8SzlxrDWSn3dNcFjgbpdM+/V4e3OsH9gWeAY6W6nanyOQzcbBQiDLkpPR+kctZBxD2NdG1F+U9gsCOnHmLXUFewnqJNjEiSjws/PvoFmiY3S/MkIk/ymvQbanyrJRbyXjNbAXwyqZI0ISsAHGfQruC/sP6LuKvzZgJXkQbMoH8Y2fY7AtBV6kTwrM8UG/VQHj3TvQR5FsJBA1oPZHfNWcZpTeT3ifAX5ZVX8jnQOSPc3HgrKT1jl5vmOyUiMa2ebCZZ1C4ScDX0/cIakYNXZo940KoOJX0hC/OJ3CN5EgSvQXKxDA9ZJ+NjDFq8nrqF0JwyuD9uQ4EvJJCtzIqVnCTauFdLKhCDW6BhHFldjrMqtMmFx3VEih6oicdXnDOmwyzVLzFB3o92UbPCRS5xM4I6OhK//OvEe55+eT9MtGId5pn80a8s3in33mpECwLVduXE5dkrgRtkclVewUqFmIjdZ2L8aOrywdvII7nhQzRPe8RnxcZRLDsoRNbbnn/+TnXTqd63kA6hLXedfd+fMAPA2kMmFRIU5aqBJ5z2pdUh9YiJZqIJxsCxOUvGLX9mJfms0hfnRi59L1I5wZR4A+U2EDI5lJjvYzZoeztlkGQxRiSZ+z87Tk0VdlZPAXm5JERdX0jQNsmBs0uaa+K1OeTj0LZppeXqxnfOa2+ysb/svwT8CcEVqKMs3ND9BJaKzTe/KLHMsZNQSTlJG6jI8FMupl65P4liqo62g0nst7/w0NnZKDx0rUESlNSWItr+A92iqJwCaJs8x/U+XvZytBhaL90XG+vuZD92P9CqIrBEs/Ugj+Zd9O+6CGXp00gCOKVE3EZPjaScQLPLs8VcjYA/jCpc9QyTLIeRHvB3cwueyXzpUEbHQYSu8X
 Jyq9uASw
 rQQpOUjZKSMcvrYxxTAzTspPM9JCCwUa5EbcuscxcWV5K0r3T7cIcuzNRdA2Ac3kZCO9f/BrbQo3pOyCemyBEACf6S2dGbIo3FYOhJAa11huFhSavrhfkM7QPgb40fk/B0jEvFK8M2SpzCXSJT1B8rHLhlcwib1QURmxT7FdinnyswfguC4n5bRf+9tme99lz8H0K1ifRzWDt+2ND+DGXYnEEpBNUJ7rQuXxZ3YLiOYAv7cbonugye5djeZaAEs7VcFyz2i49hEywIsf1ZePJX5j4yg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 22 Sep 2025 10:19:48 -0300 Jason Gunthorpe <jgg@nvidia.com> wrote:

> > +static void kho_vmalloc_free_chunks(struct kho_vmalloc *kho_vmalloc)
> > +{
> > +	struct kho_vmalloc_chunk *chunk = KHOSER_LOAD_PTR(kho_vmalloc->first);
> > +
> > +	while (chunk) {
> > +		struct kho_vmalloc_chunk *tmp = chunk;
> > +
> > +		kho_vmalloc_unpreserve_chunk(chunk);
> > +
> > +		chunk = KHOSER_LOAD_PTR(chunk->hdr.next);
> > +		kfree(tmp);
> 
> Shouldn't this be free_page()?

Or vfree()?

Not sure why this code works - I'll suspend the series from linux-next
for now.



