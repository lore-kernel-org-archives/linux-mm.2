Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 24001C56205
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 19:07:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 319316B00AF; Thu,  6 Aug 2026 15:07:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2F0866B00B2; Thu,  6 Aug 2026 15:07:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 231176B00B4; Thu,  6 Aug 2026 15:07:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 03AD56B00AF
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 15:07:53 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8BB67140179
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 19:07:53 +0000 (UTC)
X-FDA: 85071779226.30.4D54348
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id DF96AC0007
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 19:07:51 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CfDkMLMz;
	spf=pass (imf28.hostedemail.com: domain of dakr@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=dakr@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786043271;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xSIBxESI2LsoRGEYRs0/9j6hglmt3A0LXyVRlu9kWmA=;
	b=cwQLN27pWxzI5n7wm7bVtBSpegjHb/o5qYwWQ0VGT9tmMq+ifgJW+yIezgYoVVyJg5WbEp
	6PWenG65mxEmxVmjAA1jNujL3P1x4sp7ugjLG0GC7FDv+SleUDkIrd/V4Z/HD47wUwftCt
	rTAuGvb5cPDPENaHgLtP3WMbAjagT98=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786043272;
	b=ykohODCYzcu2eCyqUyW4oLpMhLtclF/eb+Z+AMganWl/BU4E5coGJkt7YFABI0FQLpcXqC
	mV6KPe0BuayenDf7cn33k5UODRWnvHgbHTXYFW+h42swtqOHOVtuOPxQfnYRcwdaEe3RnL
	rgqmIhcBLPeS5TgqoPyFs7nleiAyz9Y=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CfDkMLMz;
	spf=pass (imf28.hostedemail.com: domain of dakr@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=dakr@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1A0B64182B;
	Thu,  6 Aug 2026 19:07:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38D4A1F000E9;
	Thu,  6 Aug 2026 19:07:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786043271;
	bh=xSIBxESI2LsoRGEYRs0/9j6hglmt3A0LXyVRlu9kWmA=;
	h=Date:Subject:Cc:To:From:References:In-Reply-To;
	b=CfDkMLMzLkdPHXnqlLhKxkA5MeUXehC8NdKjRJBzoZmebvdfnnhwObhxkBqNlM0wW
	 rFocRMiNewSiN8UT1BNMlYNaCW6FazoO0n+VUsaknt/d6/gbAt8fXwozs541gOl1Qc
	 F2YXl+HPKcLs9sJiQln6F5qYu39DSoVlaakxAxDHetlYuVUSG3ATDF8n/1bPEXxH+1
	 CFCqY9SH4AzZkR0uXmXdtSfa3IfxxheRp4+K1ySCezNOtEc1Q0msqsWU/XODkmmOVx
	 DJtHDUFJ4vI4riMV9qziNdXdv4qWhHQhy6yNM72ba6yIA8DlKp1S0mLrG3SxlbawtX
	 FK0lteBG7yUhA==
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Thu, 06 Aug 2026 21:07:45 +0200
Message-Id: <DKI3HX8TBEH0.336LUXTWQJL70@kernel.org>
Subject: Re: [PATCH] drivers/base, mm: move arch_numa.c to mm/
Cc: "Andrew Morton" <akpm@linux-foundation.org>, "Albert Ou"
 <aou@eecs.berkeley.edu>, "Alexandre Ghiti" <alex@ghiti.fr>, "Catalin
 Marinas" <catalin.marinas@arm.com>, "David Hildenbrand" <david@kernel.org>,
 "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>, "Liam R. Howlett"
 <liam@infradead.org>, "Lorenzo Stoakes" <ljs@kernel.org>, "Michal Hocko"
 <mhocko@suse.com>, "Palmer Dabbelt" <palmer@dabbelt.com>, "Paul Walmsley"
 <pjw@kernel.org>, "Rafael J. Wysocki" <rafael@kernel.org>, "Suren
 Baghdasaryan" <surenb@google.com>, "Vlastimil Babka" <vbabka@kernel.org>,
 "Will Deacon" <will@kernel.org>, <driver-core@lists.linux.dev>,
 <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
 <linux-mm@kvack.org>, <linux-riscv@lists.infradead.org>
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
From: "Danilo Krummrich" <dakr@kernel.org>
References: <20260806-arch-numa-v1-1-968ec128121e@kernel.org>
In-Reply-To: <20260806-arch-numa-v1-1-968ec128121e@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: DF96AC0007
X-Stat-Signature: kn9g9k8h6wte1uycy8gogy7o55ipkeay
X-HE-Tag: 1786043271-903343
X-HE-Meta: U2FsdGVkX18zvaMnpkpdTB/o4jDCN/gwVNTH5QSK2JIEbQKYwQRcSEDWYVWxBK87ipHhTNEgTuxhsdbdS2xhD2ubt9IEeERtt6yRfSr5MMNFHZofqwWk5O3gI0F11oie3sUucb/08EOK98R0T3ZWbuw5gcT5gB9Y/0QycGG/2rmrLUI/n7QGKWQ2hqfCm1fFnT3KSNdln7dNpi62cjibGKL10eLv2rjl2lF5rhAofJwjEyQE8FvHs2NPBagQLQqwtQhgwl/FEYceN3t4ticzCmhhOJwwJ8W4yXtEFomtNIbr1dZfHxGU43cAyjqvu0AbNqoquIfkplMsKN8YwQyOZBmUgfXZC3Qd8wmm5uoaJEw4yaHYpqwxkzJaXqBKZEM1ZxQckMIkvUbj+j7vPcKlULEAq9wKAiKSjxBGHYDI4ddndmwoGVjc+GbsF77DkmSmS+dwtw0o7Opw76BEEhntEVeqowvbwuGVdw9JyS+qJPZ+59IZfkyvJNW4zfjYMCNo7NyEU9WZARFFnCT3/hp88lhjxiGxfMHr815GcDddK+tQ2QswMfOgz7Tm46VZy6e8FSn9gRNAUz1URSO0qw6CQS4AjpVrcuHr2/xr3lwd9Ea4TvFOqUeD1VKueumaoVdh6gVQ602GOABTzzim9JBc26+OcEOINU+sp5Ac8tURNm1e8u7hUrSumWrgz3RQjWrDuyh8CzB8pizv/tJLBoNqY+/2icQVAqo+nHLbvhz+aRF6P+Glx0lR85xNpmVdYkDvPaKJdUqJM7pWrPa2dx2r8jguZf6f/W/2EsQecakS4Jh1OZN/i23KeB7EgQc/FtFL/8CZywfb1ILPG/s0e9j9sAyHnTMgUNxQ0quFZLbleuLboT+4W9Ohp6cCCmKEqfv8jPGVwAME19pK18iHTo+BBRIlstKEXqqk/fRaTtWA1yC1QkfkmEnynAWBIPohhqd9esypY4kIuHF4Gp7+6yd
 ZqT3gOfn
 0MkagZPKWSf2HCpcoh6wnhArsPtvbZccpeDHMdNzk7DBU832rK9ANwnpB2s4XSk/O4R7jlih7c49ay3zrWLvTf8c6RxLo/JKjmJnyrHgATY3zBIx8vw4XX5/f05xS/Oa8/eQIS+sWSdesZIgqGuXaCHxLn6GEyrFgHC29dcDlfBfO0axN65DYSKX14t0cyY3d28IDQLtPOagNK760MeCBKlCE226uyVD3rMF2k+deoE43xRvQHQf7dhVGGlxVvGt5vt4HWViiJL0FzpBdYmcVibCaLBLjlgi6021byeXJEM1cBOzU+GYSYi1l4YzvgiovHnQ+dQB61qmsK9DQtnILuwRzoPS6xDYkd7TJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu Aug 6, 2026 at 8:58 AM CEST, Mike Rapoport (Microsoft) wrote:
> arch_numa.c implements boot time discovery and initialization of NUMA
> topology on architectures that select GENERIC_ARCH_NUMA (currently arm64
> and riscv).
>
> Since this is step in the initialization of the memory management
> subsystem, it's logical to have arch_numa.c in mm/ alongside numa.c,
> numa_memblks.c and numa_emulation.c.
>
> Move arch_numa.c to mm/ and add its F: entry to "MEMBLOCK AND MEMORY
> MANAGEMENT INITIALIZATION" in MAINTAINERS.
>
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

Acked-by: Danilo Krummrich <dakr@kernel.org>

