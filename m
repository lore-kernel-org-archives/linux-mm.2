Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD77760A2630
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 16:36:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=sYozmqnT
Received: by kanga.kvack.org (Postfix)
	id EDF016B05B0; Tue, 10 Nov 2026 11:36:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E76DF6B05B1; Tue, 10 Nov 2026 11:36:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D66E46B05B2; Tue, 10 Nov 2026 11:36:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B528F6B05B0
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 11:36:22 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 57399A09A4
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 16:36:22 +0000 (UTC)
X-FDA: 85419762204.26.118C060
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf06.hostedemail.com (Postfix) with ESMTP id 6C5BF180004
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 16:36:20 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=sYozmqnT;
	spf=pass (imf06.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794328580;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/2IklnXQ8VDOasmnc4s8LlsX94sJzF0TyhpWpFGrd40=;
	b=6xyPs448FX74BWfpXP85yQsxRKwIG4EuPPwVIKD8AsFNwYIImZCedwZDu+JgL+E3dn8WYz
	DFVMPuu4S6hQuQ/l/DaiiC0LcDwzFMva5EGLyZZMYYdCYQ2zPhyFfkh+lKmHVokO+A8Lxl
	06M8nDSlw9vcChV3lFuz6rDJDnpi1SQ=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=sYozmqnT;
	spf=pass (imf06.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794328580;
	b=VBWaPlFMNxd08eI+deWz8j96wRgVhk4BKVCCKtSLv+uKafFa9pXcCyYAyGqK3wvaaLuj8/
	aB8nj6GHFpOORhq+5a6OObtR0qADcWMa4z0cbUkLH0Lvdwuuj9nXusRMQ4vHT8rLoQnp1e
	RE5B7IhGQVmpCOsqlkWJLgXLkBeUwNs=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3924B1477;
	Tue, 10 Nov 2026 08:36:16 -0800 (PST)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 234893F85F;
	Tue, 10 Nov 2026 08:36:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1794328579; bh=W93zuHvv0B3GjuQYbnfR2B0hYUYTD/1HhAutAvOyHc8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=sYozmqnTmmj1HDyt+LmelivUTXfURzy4ZuotqpQSAnyER6/dyDFtKIFkVkn0SmpO+
	 O+RU5XZyaIzhycu65Pmw23utreNYCUqv9PnuZP1DrGLbr5D7k6uP7oHKi7dXqKJdYN
	 CbmlR/v3UEIQ3c8AHIpFUW0pKrLveLcUhkh7pNdA=
Date: Tue, 10 Nov 2026 16:36:12 +0000
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: Mark Brown <broonie@kernel.org>
Cc: Kevin Brodsky <kevin.brodsky@arm.com>, linux-hardening@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Ard Biesheuvel <ardb+git@google.com>,
	Andy Lutomirski <luto@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Jann Horn <jannh@google.com>, Jeff Xu <jeffxu@chromium.org>,
	Joey Gouly <joey.gouly@arm.com>, Kees Cook <kees@kernel.org>,
	Linu Cherian <linu.cherian@arm.com>,
	Linus Walleij <linusw@kernel.org>, Marc Zyngier <maz@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Maxwell Bland <mbland@motorola.com>,
	"Mike Rapoport (IBM)" <rppt@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Pierre Langlois <pierre.langlois@arm.com>,
	=?iso-8859-1?Q?Pierre-Cl=E9ment?= Tosi <ptosi@google.com>,
	Quentin Perret <qperret@google.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Vlastimil Babka <vbabka@kernel.org>, Will Deacon <will@kernel.org>,
	Yang Shi <yang@os.amperecomputing.com>,
	Yeoreum Yun <yeoreum.yun@arm.com>, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org,
	x86@kernel.org, Ira Weiny <iweiny@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>, Thomas Gleixner <tglx@kernel.org>
Subject: Re: [PATCH RFC v10 07/22] arm64: Initialize POR_EL1 register on
 cpu_resume()
Message-ID: <avNH_AdvK9AqvfF7@e129823.arm.com>
References: <20261109-kpkeys-v10-0-aa6c4d9603bc@arm.com>
 <20261109-kpkeys-v10-7-aa6c4d9603bc@arm.com>
 <be361be8-c5ad-4ff7-a6db-7b0815bfe1d0@sirena.org.uk>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <be361be8-c5ad-4ff7-a6db-7b0815bfe1d0@sirena.org.uk>
X-Stat-Signature: ck4i14u54h7yc8bq7jw4s37dpqp5ouan
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 6C5BF180004
X-HE-Tag: 1794328580-440432
X-HE-Meta: U2FsdGVkX19Wl+PmoUhu1jKZhpLFR42kFkgDj67kXsyzapP8gscJ2nmVsI+Cz4sQ6p3P2Q85h40R6EO1RrFC8tRA8diwd/w27bfAl3Ttfirv9H88UHu3vooXV4IMOJAwunWlQX8Z08CRDgPcsr8fncrrvv94JNHsyPJZZS04h1Uey7vUtl417zv5yiyHWxTdYrKdYhuJ1GhmW19kM+LEJYzWfSjt4Xp4mfnRU+Y3GZWloeohAR2RIZSq+WOyYRSpS2sgJRVO0W94noxJh3w81RS+T5nEw9OaVrXAigmwy2D02G/IPkYVHoX0guafnGWu7DXf1UNcjRXJqelRbuJLzmUHSSW3xGSAKkLoo4UaRmzwbTWG+2+YsPrbJAMr8Zyj8c+o/EqAc4/zpo8SHfxxpYbJxPvUuElh3Us9qodOd5vfPdAvCCu3Gz+U4fgxG8kgw9oIsURcxzkyL1WFnCl4v+cZP3rV7oWazl19fYHDRMoydOFMIjlTQTDhcEkaMOXPfRxLzfLXhEqLO0EUxCgN7ww9+RCDL28zF6WBq+poTh28IT7x/41hzStFrM9Txg6i1QToI3ypCmWeSiktEffdJdd/A5CbYhWKOOWtetH9bFKR0X9wsYQwgILGOu700THSHGO7NPDA1kdMxD9jcmy3bocOq2s67Op99POFZ6g3zIlQf25vO5rS1pxTyw+d+DCdLe9N4yULvvvl1oGLKgMsnpNtAbzmqmACggWnOYmlC+zGN6Ph0Z1NhhCCp1RcThvUgYWYm4MA4pdeBX7M0cTFRUgrhx/EyX5n4QPQQpdxZnvGTSdrUYvWTW+ne8T06igzRr+SE8xO1pUH3FfLCSSq5c4oJfOzqhwJK32kaXH9u5kVGQ3JqhODJtg351/HwIAgAxB2K5Alm1s62AcWZP28eHVP5QXT19xTfJ5YP13zgRL2rZnv/Ck3RPD/hMLGldghDY5M4QRHvvm0Hl16WXq
 8hSi9Lnf
 Pcv+J+bhwRo870NlFYspC1jjvPwozz7R8Yq8XXwE03R+xEcbM5mouSMd+p8CSNTQD7ez1Ygnb1lcyj5bLZ3TznE5g63suFf9ND817NCxEmYLPJHQFz1xvZmT7GxoGVTRrZrFyWfptjs97O84Uivj8Fd3wx5nrnqpQvZJ1z6mhy1f7Hcx+gNT8rPp/GQZqMcnMpz7RK1b0i0AviZ10g5FCiTJBhxvDhB/twBTXthSbZjxYo5fLncjhvJAGwi6dEIUmOyBSCDojTJ+oug8a3SBIgsZeGOsRlun35M+sE3FyR/mPJbgB6u49mt8QyghmBi5M9dvS/M9pNj0wpLVRXgcknXlcXj2BuGQvVXVqi5d1CRDcVqugy6Trpa4qEmg6AO8I124GVDyotMgn8kz5pOdrUL0cdGN65UhCexW8yw4hE/KG+xqC6akgi2KGEiQVD4CXj47M
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 10, 2026 at 03:53:30PM +0000, Mark Brown wrote:
> On Mon, Nov 09, 2026 at 03:58:32PM +0000, Kevin Brodsky wrote:
> > From: Yeoreum Yun <yeoreum.yun@arm.com>
> > 
> > The POR_EL1 register is reset to an unknown value after cpu_suspend().
> > Since POR_EL1 always holds POR_EL1_INIT when entering cpu_suspend(),
> > initialize POR_EL1 with POR_EL1_INIT before cpu_do_resume().
> > > +#ifdef CONFIG_ARM64_POE
> > +alternative_if_not ARM64_HAS_S1POE
> > +	b	.Lskip_por_set
> > +alternative_else_nop_endif
> > +	mov_q	x2, POR_EL1_INIT
> > +	msr_s	SYS_POR_EL1, x2
> > +	/* isb can be skipped since cpu_do_resume() will do it. */
> > +.Lskip_por_set:
> > +#endif /* CONFIG_ARM64_POE */
> 
> cpu_do_resume() will update TCR2_EL1 to enable POE again, a sufficiently
> unhelpful implementation could potentially decide to do that before this
> POR_EL1 value takes effect AFAICT given that there's no barriers.

Thanks. seems required to isb() after initialising SYS_POR_EL1.

-- 
Sincerely,
Yeoreum Yun

