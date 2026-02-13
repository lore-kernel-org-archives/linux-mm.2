Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D4666EDF154
	for <linux-mm@archiver.kernel.org>; Fri, 13 Feb 2026 11:28:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A88D66B0005; Fri, 13 Feb 2026 06:28:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A0C206B0089; Fri, 13 Feb 2026 06:28:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 90B0D6B008A; Fri, 13 Feb 2026 06:28:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 7C9BA6B0005
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 06:28:46 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 092F0B97FC
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 11:28:46 +0000 (UTC)
X-FDA: 84439211052.25.A772D07
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	by imf02.hostedemail.com (Postfix) with ESMTP id 19EE88000B
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 11:28:43 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b=BOls9PRu;
	spf=none (imf02.hostedemail.com: domain of peterz@infradead.org has no SPF policy when checking 90.155.92.199) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770982124;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KpBATvyUAudtytvAlcHemdrq+UOedXGW0Hm3b+ZGJoU=;
	b=D48cnXtXl5WQ4AmCkIm2QDMlNWF/Z9APtaFsV9Vh+HTR3jmsWhLm7rroIYp4ZQJSax0KNJ
	wlOZkr5mydWd2CpuRKvMGB3XGATzvtRMFRIJmlzbCU6Q7TeXz/z8sespEx4jDK0ICqSb/J
	8y81HDgb2HkXLYjfC/Cz+p5KG7x9UhE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770982124; a=rsa-sha256;
	cv=none;
	b=lgQBjW/RMkj7WGTmdqqxQ3zO1fPfrCZf5QY5G+USC+UxwmWMrHl2/VkeS0rqlUkKL2s6r+
	juSQTIubGSWU4JTpuQkbf0xWRWPncmjbU9EYUnLcjA43R+ar/QaoFeHXQrp7dnTjXJxyy9
	85bDQotJ8w2a7SMgnw3GCacaUHEouJ0=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b=BOls9PRu;
	spf=none (imf02.hostedemail.com: domain of peterz@infradead.org has no SPF policy when checking 90.155.92.199) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=KpBATvyUAudtytvAlcHemdrq+UOedXGW0Hm3b+ZGJoU=; b=BOls9PRuXV6GCVYN1d7wQHi8st
	iYyUBnkCXJ+QW3EOy509S0xSyRwUzgMSB0DGXAXqpIAx3mBMfdM4IkM0vY7H3AlFWqB4VCnPtSIG9
	3FWP68gO22M1EKM0SxQj55uexoM6A8Ys0ZpPRRbzvZaOgbpCCzpdSqHIk6nbm6YTjo7Agy0i0c+gT
	DqTZJSgW/8mlDx6LIyWFoH1px2YKSZgMqetgVECUckttOHFEv9WKkc4JxI6gi1DK7S5GI7piRYQCH
	HKiSWNKVG5NuuN51N/LudYCBmxlx/4HkNVo6vzOnhVVo9838iWwV99WE3iGSkEj+r0qM5zeTKkZ0j
	vj0Fc0Tg==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vqrLi-0000000CAyu-3eIB;
	Fri, 13 Feb 2026 11:28:39 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id B45663007B5; Fri, 13 Feb 2026 12:28:37 +0100 (CET)
Date: Fri, 13 Feb 2026 12:28:37 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Andreas Hindborg <a.hindborg@kernel.org>
Cc: Alice Ryhl <aliceryhl@google.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun.feng@gmail.com>,
	Gary Guo <gary@garyguo.net>,
	=?iso-8859-1?Q?Bj=F6rn?= Roy Baron <bjorn3_gh@protonmail.com>,
	Benno Lossin <lossin@kernel.org>, Trevor Gross <tmgross@umich.edu>,
	Danilo Krummrich <dakr@kernel.org>, Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>, linux-mm@kvack.org,
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] rust: page: add byte-wise atomic memory copy methods
Message-ID: <20260213112837.GT2995752@noisy.programming.kicks-ass.net>
References: <20260213-page-volatile-io-v3-1-d60487b04d40@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260213-page-volatile-io-v3-1-d60487b04d40@kernel.org>
X-Rspamd-Queue-Id: 19EE88000B
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: 4e4a6icgiab1sf6z3y8swu117636qh1z
X-HE-Tag: 1770982123-656289
X-HE-Meta: U2FsdGVkX18RqMMN7I9Uh8A7eRKpisWn7eQ6/qmUGnyMhyNkLxQXkNJb+0wsnS/ka/ZvCi+icT4INa/ds0DlcRxHJZmWiFlLLNJUdUYwtt1PFfvDt3d2HLMLA04XjnS4podqnLhHwRDvml/uhf6/02q2ODNcER+QpVAYbjNrvi867azeal3gXa0m5CcexRRugDpyXX+tcpPCvLvghTxTDHz/zCc9UHMqiJfyKDy3viNLzHnUfWf2SVahXsccgVRu7UelymwHER3DpnfLah8pjmpmoU/qPO9zFURIJ0AcPuviXVBvOSH873rROURMLNdfUHf8RvaeV4EX2DumV/liiXZK46iXaR8LDe3xKbW0zPHSDgzn3WX2q3TnWrX5jkqf5l8oIu+0/YZyirLJO5Th8HiojqJxu7+IzKib2HFxamK2uhZcKFGYDK+ZWDi3pvZIqayuYG4ivJ0rIH/CwIUEF1sbdjaXCrHmtYSoX2L/BT7wYNPrghW2g6IEFcmxFZYLbh3/7i5F+dRKECRdmzT8kXsuaHJ0SOh2jmmFQHp3hK3FresSWvq628x4jhFvf6zm2V1/mfI557Zzsz7sjhvKZErkaRWGsd94azX+xxT/Vf9jh6fOLsJMmOuTJkBrpi4k26HWITIdm+L7rV2aUA97wgt670r6VQDnuQ9ddYuc9Hb26Vwfcu7skGKNPVwzKG6Ee3FoR3MZkza1fxOQyM52g7aWXhSPhJIVvqUhUELPKZDLYKQ9tc7qLBWPFHhnnPOderkrvHWEG/UwUsCAvyV2V1m1wu8SvZb7P9MphHKsdFGps5JHlZ+zRCztrSuosjdlv8R1Ee3qPp7wPJsCAx8Ii718YriAiIzB2xk30S9YFW2HZW61w25pqv2bSfhOIUGhLVd7+mFrpfmcd8qNghkOW31awH8FS8rGXrRuayl+k52peisTf+lKbbGNziBNvN2VUECLe3LyuK30hwQDWpz
 87n6bL6K
 nRAV2Ob6kMomURO5P4OI86p1i74sRlHK0kRuqdtTI2llTORuWnHeldA10niyFKKiw4DJJ6bg8M2DLuHvw5ij/DMoPB271XCkwh4HyQZ9hqjkrd7CAML3XUuCtgkRUFAJdmg+0xQTCwYOXLj8De/XSJsK6PKLzXrOqYX3hb8p/xsLPey2/nSl0+QrSKxQlDwIsA5KsByOzkbHzPxamBRonqAjzHtsfMQywHp0n0V+f+OesM0T/fay0DtX5ReCYYLYFGrHYGoUO3llQCOTIEPrcRKmovjeqZ5xz8Dnn
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Feb 13, 2026 at 07:42:53AM +0100, Andreas Hindborg wrote:
> When copying data from buffers that are mapped to user space, it is
> impossible to guarantee absence of concurrent memory operations on those
> buffers. Copying data to/from `Page` from/to these buffers would be
> undefined behavior if no special considerations are made.
> 
> Add methods on `Page` to read and write the contents using byte-wise atomic
> operations.
> 
> Also improve clarity by specifying additional requirements on
> `read_raw`/`write_raw` methods regarding concurrent operations on involved
> buffers.


> +    /// - Callers must ensure that this call does not race with a write to the source page that
> +    ///   overlaps with this read.

Yeah, but per the bit above, its user mapped, you *CANNOT* ensure this.

And same comment as for v2, none of this makes sense. Byte loads are not
magically atomic. And they don't actually fix anything.

NAK

