Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 35BF3C2A09B
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 16:16:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 19AF36B007B; Fri,  7 Aug 2026 12:16:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 14C336B0088; Fri,  7 Aug 2026 12:16:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 013B06B008A; Fri,  7 Aug 2026 12:16:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C325B6B007B
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 12:16:27 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 475D0A0478
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 16:16:27 +0000 (UTC)
X-FDA: 85074976014.12.D348F49
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id E3881140012
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 16:16:23 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RJyBP+6B;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786119383;
	b=e8MQA72QMqLnm5KIu/h47qIH8NjAQIj54QXHqHOVgmIz5mgylDHTZ/khcCz4eX8IYRj617
	FGmKkpX/bSUJYZ+FTPJt2SzjKmYC064Nx99Og7NRFVieGzRP0U/5m2J7wQmaxPukrr8Ug8
	jU7S6D/mxSkWZqCuGDRw1D4PPMUly4g=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RJyBP+6B;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786119383;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=G4M6WaWJHJkAgTKhvMBMOdrskvc3i17djUnErYhCZd0=;
	b=VzZP99WaayGD4V/QwVKd82iuyDtLNBY5JrJaE9+PEBxOyTi5AMUcDsH23igmI3O59CEGSa
	vermwj7nyz5V/RLALpLp0/NHniSwgGrppmVYDnHWw0Z20MKJ5F/p1m4aa/uhjZShu2IgXZ
	uHEe6uDqpr1OWW0SI2Ih1X7UN7gSKUI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6395E600B0;
	Fri,  7 Aug 2026 16:16:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF98F1F000E9;
	Fri,  7 Aug 2026 16:16:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786119383;
	bh=G4M6WaWJHJkAgTKhvMBMOdrskvc3i17djUnErYhCZd0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=RJyBP+6BN5+JrlhxCrfvrqnbQhrx+JvztZlUHBVIpV4LBQfuVGSj+B2zmoOm4Ro39
	 fODvJOTHaggB60ZlLgqnFkMyLOrDJ0Ff8JFO7jlqylAdHlT5F3TMAOpbdMouCK4JkK
	 5WBcoaAUPwB/DUm0zX5Zp8ba/0t6KTi6zN5PFiWqEx/WD7tfM9obOY7eLRGuviuNp/
	 OreKT0eZi1lCo4X5E9aBAxti/Sj7DFuc3sAp3OGmrf8K1ingGeVFR7IC1UHw0DltW+
	 uVqXjYI5xwtmMETVFNDfS66m4SfW94w12B0AM9KiVkM/kg77HrQULtMnME1OFFzqt4
	 9Qyg0lJpOWuMw==
Message-ID: <3b458c02-e836-4b24-a712-57fa8dd59e45@kernel.org>
Date: Fri, 7 Aug 2026 18:16:06 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 05/10] mm/cma: Allow dynamically creating CMA areas
To: Thierry Reding <thierry.reding@kernel.org>, Rob Herring
 <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>,
 Conor Dooley <conor+dt@kernel.org>, Jonathan Hunter <jonathanh@nvidia.com>,
 David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
 Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
 Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>,
 Sowjanya Komatineni <skomatineni@nvidia.com>,
 Luca Ceresoli <luca.ceresoli@bootlin.com>,
 Mikko Perttunen <mperttunen@nvidia.com>, Yury Norov <yury.norov@gmail.com>,
 Rasmus Villemoes <linux@rasmusvillemoes.dk>,
 Russell King <linux@armlinux.org.uk>,
 Alexander Gordeev <agordeev@linux.ibm.com>,
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Sven Schnelle <svens@linux.ibm.com>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Marek Szyprowski <m.szyprowski@samsung.com>,
 Robin Murphy <robin.murphy@arm.com>, Sumit Semwal <sumit.semwal@linaro.org>,
 Benjamin Gaignard <benjamin.gaignard@collabora.com>,
 Brian Starkey <Brian.Starkey@arm.com>, John Stultz <jstultz@google.com>,
 "T.J. Mercier" <tjmercier@google.com>,
 =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
 Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu
 <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Chun Ng <chunn@nvidia.com>
Cc: Thierry Reding <thierry.reding@gmail.com>, devicetree@vger.kernel.org,
 linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
 dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-s390@vger.kernel.org,
 linux-mm@kvack.org, iommu@lists.linux.dev, linaro-mm-sig@lists.linaro.org,
 linux-trace-kernel@vger.kernel.org, Thierry Reding <treding@nvidia.com>
References: <20260807-tegra-vpr-v4-0-5510d16af89e@nvidia.com>
 <20260807-tegra-vpr-v4-5-5510d16af89e@nvidia.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260807-tegra-vpr-v4-5-5510d16af89e@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: E3881140012
X-Stat-Signature: ddgbo78scwnk5xcc6dcyz51z8rpx93xr
X-Rspam-User: 
X-HE-Tag: 1786119383-898961
X-HE-Meta: U2FsdGVkX1/06ZfjJO1jjARPH7PLXTt5rh6KaKUUIp+7VurPGAh1UjIY1cPOSJVfdPPp0pcCISjXUipuztqJ1H0ELdor/mmG7lnnMhkJ0U7KYjE4vh82mPYcEynkKxXLdLjkR2G8dP9qo3hkL1tLII4YJqbJ+ohVDg7VRsSrFup+Pf8pMdPWWBNLRQ7JsjkG2GUl1SrQjkshBqqDgBvMqSVWwg4aKO++jQDgAY6powqNdeRGHg6WkWGKRH08qkGUfytRXXbf8eM2lHgYEtYaFshVML/okofxqqeZZxnTZdmyT51awy46G16WBDWcGuBPzNz4G5yvjAh8Sdo/GuZ4NxSaFNismq5FeEz34VBqXoClPc9S/hf8bdFq8KCGbKFE1o3Nd3RoKw3CwlXKIIOW0EO92v9oPJ0n/5nYcYPn7ZmhruByuYX2y2KXiyZbh9y2soQrDcB3vRqvngKgapHJgCgUeWpApFV5iPtzA52TLr5SrcyfTDR6rK+P5UT4Ypa1/rPDaZu8abo3DBMkDpBzPFrhULNF4cL+XS4os2PIR5qytXHb5/pBZQvw2g8HC1XtuyFHT7z73ywiJbw5/zA38mCzncEDkvRL/uw243CfN/+cTdJYHGaoARb1cOKqJbccyC+2x7IKzDiYfl032z1tl+mh+90iZI0nQBtIeQHPtvOb9V6RPsk4+TlL62psMShXW9nnFUAeMcYnkvbYF5QMIu8G5JxOm90eCE4Op4euHQo3r3o5FzqKWrzOSuVpBo+P8h1jcahfYXV8Zh113YrPgItdWXWMZfbVw6+HvadnJjr05xWxiI5d42T5GFUVoMxSo/QqHMwow3Jw4vrqa9+sdPRDdY79gs3ihS/aa4lwJPEZGMAFgHE9szuewddSzAK+2YFxkAWgMxQWDN5gv8sliyjw/E+WrMCwnJPYL0gXEPb0/EiAqQruf2rZp97tzpOfkfjMtvC+hcsQakTKncn
 LtcJbTCo
 RR4ER7+WmkMCitLxqWOjL18SMxCPIF0lsdldr01Dy4zWI/eJXRgk64IxgcDPymNILUIxs/SqXSMyZXf2WHonyndxcj2QoKkoybKY9tpdBIutyRPX4RelspDPF9RuFJP6RZiAOTCeM++Dvi7HQ6+v7E/2jAudtEYRoaWtTlv+mETuD1VEY+w+xPi81c9Tx2vLktYj0jV2c2yIshXIgg6oiE6V5zFObFQtPM2AhCnKvV8HgJRHe4+4VBeKDUCL9QDXXJPUXvMPrNMi2FnwIPd32rrM8TJ3JGu0Y6bgIlsZpkpzZykLrS51g5jr1vD+9GX6zumlt9GgyN09EeuwnyF7nKTzNMmXUudGbgbTtIiNngQAPvOG0sRmITlWAv8C2x13/qswDqbs0XWkmGW9muRMqpoMpmZoUANtAHb6F
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/7/26 17:54, Thierry Reding wrote:
> From: Thierry Reding <treding@nvidia.com>
> 
> There is no technical reason why there should be a limited number of CMA
> regions, so extract some code into helpers and use them to create extra
> functions (cma_create() and cma_free()) that allow creating and freeing,
> respectively, CMA regions dynamically at runtime.
> 
> The static array of CMA areas cannot be replaced by dynamically created
> areas because for many of them, allocation must not fail and some cases
> may need to initialize them before the slab allocator is even available.
> To account for this, keep these "early" areas in a separate list and
> track the dynamic areas in a separate list.
> 
> Signed-off-by: Thierry Reding <treding@nvidia.com>
> ---

Sorry that I didn't get to reply earlier to

	https://lore.kernel.org/all/anS0nxAwCXGWZRl9@orome/

But I am still not convinced why we shouldn't just have a single array that
grows dynamically.

"
After replying to T.J. I think this static array is actually a nice
feature in a way. It allows us to more easily make a distinction between
the regular CMA regions created from reserved-memory regions that
represent classic carveouts, and the more versatile CMA areas that could
be used for any purpose.

Telling the two types apart could obviously also be solved using some
kind of flag stored with the CMA area, but at this point I don't really
see a reason why the two lists would need to be unified.
"

Really, cma_for_each_early_area() + cma_for_each_area() is just nasty.

I'd strongly vote to unify unless there is a very good reason to do it
separately.

-- 
Cheers,

David

