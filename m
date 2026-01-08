Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 07F4CD1D486
	for <linux-mm@archiver.kernel.org>; Thu,  8 Jan 2026 19:19:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 511C86B0089; Thu,  8 Jan 2026 14:19:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4BE276B0093; Thu,  8 Jan 2026 14:19:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C08F6B0095; Thu,  8 Jan 2026 14:19:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2703B6B0089
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 14:19:25 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CE714B7915
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 19:19:24 +0000 (UTC)
X-FDA: 84309760248.10.A596A01
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 06B7F40009
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 19:19:22 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=CVumgl5u;
	dmarc=none;
	spf=pass (imf07.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767899963; a=rsa-sha256;
	cv=none;
	b=oadLvJFRv+00zUAxHNIq1/M0rChUkrLmOQxAfMs/7Wph73afrwL+VqwQDn07tjbbCDRq1u
	4uWXyNsNSjT81hKUpKkE8ebfrE4zwS4T41t3fphetN4DpbD4IQ9rvBQr9NlrO44ZGDX4jg
	di7Ya2+M+fk7DbuTaqESU5A+R3/aTRk=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=CVumgl5u;
	dmarc=none;
	spf=pass (imf07.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767899963;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Tzrq+4BiaeS9zeQ5BXLg5bAaN9WKhQUuxGsqtXMKVv4=;
	b=Oy8Ela1YcsVs+7ILbf+XpOqtaHr4zNVNtdvSE7Tj08VPHzAMv1hnwxoABDtXLOge3XiaJA
	NVN4SywO+0M8vm+TPSODGd1CNd6m/t6VOv5LHX8ZyPRLjjPGY//E5wWrlef3cNKwHOhZJ1
	3TOYQx5ISg5Sdfc5GWQvwZKf09mKaac=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id DD4D240732;
	Thu,  8 Jan 2026 19:19:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEE9CC116C6;
	Thu,  8 Jan 2026 19:19:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1767899961;
	bh=fSg1rFUc7Lj8obCBDIiOBzwmsy2PDWnpS6aiVKuno6E=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=CVumgl5uYfQfaLqYgweLov8FT7OgO1ch7qHlwuZbONKicqb+bmGFoLIsYAxoWfRsr
	 6BxVTZH+QFJx2xSpWVk0NUrA2Ddxjwu2/Wcc1JG/gPIWft2fVjXp2CIt9nEHIpeVml
	 fnOoO4sO6q/7KPmJQudmyHeHcLC9E7nvlzSuO+ys=
Date: Thu, 8 Jan 2026 11:19:19 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: Klara Modin <klarasmodin@gmail.com>, Alex Shi <alexs@kernel.org>,
 Alexander Gordeev <agordeev@linux.ibm.com>, Andreas Larsson
 <andreas@gaisler.com>, Borislav Petkov <bp@alien8.de>, Brian Cain
 <bcain@kernel.org>, "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>, "David S. Miller"
 <davem@davemloft.net>, Dave Hansen <dave.hansen@linux.intel.com>, David
 Hildenbrand <david@kernel.org>, Dinh Nguyen <dinguyen@kernel.org>, Geert
 Uytterhoeven <geert@linux-m68k.org>, Guo Ren <guoren@kernel.org>, Heiko
 Carstens <hca@linux.ibm.com>, Helge Deller <deller@gmx.de>, Huacai Chen
 <chenhuacai@kernel.org>, Ingo Molnar <mingo@redhat.com>, Johannes Berg
 <johannes@sipsolutions.net>, John Paul Adrian Glaubitz
 <glaubitz@physik.fu-berlin.de>, Jonathan Corbet <corbet@lwn.net>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Lorenzo Stoakes
 <lorenzo.stoakes@oracle.com>, Magnus Lindholm <linmag7@gmail.com>, Matt
 Turner <mattst88@gmail.com>, Max Filippov <jcmvbkbc@gmail.com>, Michael
 Ellerman <mpe@ellerman.id.au>, Michal Hocko <mhocko@suse.com>, Michal Simek
 <monstr@monstr.eu>, Muchun Song <muchun.song@linux.dev>, Oscar Salvador
 <osalvador@suse.de>, Palmer Dabbelt <palmer@dabbelt.com>, Pratyush Yadav
 <pratyush@kernel.org>, Richard Weinberger <richard@nod.at>, Russell King
 <linux@armlinux.org.uk>, Stafford Horne <shorne@gmail.com>, Suren
 Baghdasaryan <surenb@google.com>, Thomas Bogendoerfer
 <tsbogend@alpha.franken.de>, Thomas Gleixner <tglx@linutronix.de>, Vasily
 Gorbik <gor@linux.ibm.com>, Vineet Gupta <vgupta@kernel.org>, Vlastimil
 Babka <vbabka@suse.cz>, Will Deacon <will@kernel.org>, x86@kernel.org,
 linux-alpha@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-csky@vger.kernel.org, linux-cxl@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-hexagon@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-m68k@lists.linux-m68k.org,
 linux-mips@vger.kernel.org, linux-mm@kvack.org,
 linux-openrisc@vger.kernel.org, linux-parisc@vger.kernel.org,
 linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
 linux-sh@vger.kernel.org, linux-snps-arc@lists.infradead.org,
 linux-um@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
 loongarch@lists.linux.dev, sparclinux@vger.kernel.org
Subject: Re: [PATCH 3.5] arm: make initialization of zero page independent
 of the memory map (was Re: [PATCH v2 22/28] arch, mm: consolidate
 initialization of nodes, zones and memory map)
Message-Id: <20260108111919.ac5f811132672e760f47fbab@linux-foundation.org>
In-Reply-To: <aVpWpLV4Dut5Muo2@kernel.org>
References: <20260102070005.65328-1-rppt@kernel.org>
	<20260102070005.65328-23-rppt@kernel.org>
	<aVhN2NgQEKe0yzva@soda.int.kasm.eu>
	<aVll339wim7dCIaQ@kernel.org>
	<aVlwOyicOLPB9SOa@parmesan.int.kasm.eu>
	<aVpWpLV4Dut5Muo2@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: r8qqrjrkkytowbm1kntsw5i7zb35yph4
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 06B7F40009
X-HE-Tag: 1767899962-570093
X-HE-Meta: U2FsdGVkX18fLVrdR8mIrFG5qnBHOBOan/lRas1uW18WtMuxuqAdYnB1wZ3iyzUfO2tghdgvFM+7gCcIZwDPFIWS0sQCNCnDcfB9vlvuhQsnwFkoQmBANUNvcluF8VyKLC9Cu/q3v06OwWn2uLsJMZFI8UGKdcNGDp3aIcemz8Y3QvJhAE6vonR959wtMXV+LNSf54MwYydWTMHTV1yEYHdvNhhWwY9N4gT9FQqpWMV3zcCOamascyDOORw8p+hogpJbcTC/AdeWu2HX7Kst+LAoU+d3mpE6NKV2Ua/m+4ZFIFbA6zsI3iIMeGJu+0LFL2BPgh5SQAIsa7LPff31CuftJ+hVJ4wt1SYmiqyd9dNsNbRPrYJ6H4OPkxIJ1I6YQ/lXHS7E61u+s+acGHxm2b86pHkKjgGH9O8ow8f1ZGtjWX6t99Baj6QNzZc+ggx69lFQrgsciiq2QIzS5ySnmaAJJvdh5B5HydxcNGeSLPRckLuPQi6CYadFFe2pDoM905oRcJmG/I9Jv8MgNgU91TI2+EL9/MUo3jolPe6b5jAxyEfqtGYNyp6V4Kf+usStv9tQlJGAVd/KrOjfU+OhXC/AV3gk2CG1qSVBsBhV99ciPMB9mFEVDLwXOiU7bxu5cnKY2ccasNXBFNOjU+kTD5LX6h0pnlTaoMJ1pCsWQXZaXVHXmMG1+g6La0CyVsDBk5TskJLdzSblmk23h0dChszNBIPWezCPCd2A8Hxb2P6J0rXVgEtWrTANft3bmc/M3pZ7/2UPtEgVX7VIbdCIxG8KudWUBV6w28jEautTceRwWgb6O4CXWOnTLgMGjcxA4TnjvSqni+NzjLA2zQbt/N6318XycFFB6ARRclG141HOVWKyBuqR7Q3iulFszxWndnslbYWA14py404BIRgeuUQ8I4ceEHobpJv3ohI/fssqe+FVKfHJTqyYVadoBjfzL4srpvzK/ZmNwTKNL5a
 oekKVi/f
 jqsYCFBB3+MRdCXUg5t2cZc4LTZLVLWX4W8SLeos/I2o0Hr/e/ulXDtOrlc3lAD1irFmxzAmOmPo+RdiPZuPEmOa/Rf3ICM8kGhUGBPFOoCmSI/bblge605J8/AlqARHPA8ERSlskJm0GBZBWkJeYLxje8mPABmy1JUSlgivWyqH6PaT5KV5vKb6em+deufJisO8k7G+jScuGU21pnSf8WL4NdDgD/ck5mO8tlnYYIfX36Djij0gKd2yY1tgHMaWQjl2c8XhlXMK+O9ldLxtHlQ9zu+EKQ5ODKmDodfHbirKWllKSuoRGjRevOjY/3Zx9mioGBRlkMKooK6k=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 4 Jan 2026 14:01:40 +0200 Mike Rapoport <rppt@kernel.org> wrote:

> Can you please stick this between patch 3 (arm: introduce
> arch_zone_limits_init()) and patch 4 (arm64: introduce
> arch_zone_limits_init())?

Did, thanks.  I made this a standalone patch rather than  a
squashable -fix.

> >From 35d016bbf5da7c08cc5c5547c85558fc50cb63aa Mon Sep 17 00:00:00 2001
> From: Klara Modin <klarasmodin@gmail.com>
> Date: Sat, 3 Jan 2026 20:40:09 +0200
> Subject: [PATCH] arm: make initialization of zero page independent of the
>  memory map
> 
> Unlike most architectures, arm keeps a struct page pointer to the
> empty_zero_page and to initialize it requires conversion of a virtual
> address to page which makes it necessary to have memory map initialized
> before creating the empty_zero_page.
> 
> Make empty_zero_page a stataic array in BSS to decouple it's
> initialization from the initialization of the memory map.
> 
> This also aligns arm with vast majorty of architectures.

Russell, can you please update us on your concerns with this change?

