Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 72CE8C43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 05:43:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 400186B0088; Tue,  7 Jul 2026 01:43:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3B06E6B009D; Tue,  7 Jul 2026 01:43:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 27A3B6B009E; Tue,  7 Jul 2026 01:43:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EF3686B009D
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 01:43:07 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 75B088D136
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 05:43:07 +0000 (UTC)
X-FDA: 84960887214.03.ECF34F3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id D736080002
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 05:43:05 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XqTYmHll;
	spf=pass (imf30.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783402985;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vb6vk/n76+X1N8wujPagIhXsh+0Jn+z6BBJscyH3Kl4=;
	b=ytuHl4R7IoVC/7z9vfksmp2cZsCGpMeALf6V2a+Ja2V8c9YfPucSJ7hQfrnV4dswWVrfZS
	ZlsmwQldsdhdtOX0a8Ug2M7gKUb2sGoDzT/IwPG7CABQCyxeyHDOdEqHeZnt/aeru7Urvk
	O29DVWXUaLMbuJ1KR5tN7DIJHm9OW/E=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XqTYmHll;
	spf=pass (imf30.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783402985;
	b=oCtMHlvMtTX+pAklx3MhtPnsZCZtpBHxw0zwwJA6sJBhfR26fk7UWs5J8vgsXBPllu9Be4
	GL0rh70uhQyot9MQ1wf+1NBt4jonKbkg5eZWYfSJu8qqWZsZ/zeTIDEKp+myP4eUo/UVtu
	s0cCHYn2uD/d1uJyoBlkO+KAGSD59yk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4D95C61897;
	Tue,  7 Jul 2026 05:43:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B811A1F000E9;
	Tue,  7 Jul 2026 05:42:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783402985;
	bh=vb6vk/n76+X1N8wujPagIhXsh+0Jn+z6BBJscyH3Kl4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=XqTYmHllZ0LJ4hsvf5fsczmCcUsgkjVWF1LHalZ/skJ7cfyXlAnfBFj9raJC9eN64
	 oONp8nsZazVNONEMYm9ZlPrSoGFxDDMeivRgQJbXL4RZrlO36mzvE/emvT2eC/hOXG
	 /6yMd/smKmHl9FqKIKFc8l/Y5I7vf/ElU1eowglhmxSnerHk7R3OPLidhvQe4W5nXf
	 kDChojB1FUmaplF14wvMSsBFTzMx4ioRwWlHuKttNgdITmT08gqOu6/LFoHwmozJqu
	 N8pxqjFdUUhwAbvJf3hGFx2O2jCYPujZEUpsYUwitMCmQnqKlijP0lHr/3Ea9SpUs8
	 lb4se/5Nv1lBA==
Date: Tue, 7 Jul 2026 08:42:56 +0300
From: Mike Rapoport <rppt@kernel.org>
To: "Rafael J. Wysocki (Intel)" <rafael@kernel.org>
Cc: Sang-Heon Jeon <ekffu200098@gmail.com>, akpm@linux-foundation.org,
	linux-mm@kvack.org, Andy Lutomirski <luto@kernel.org>,
	Borislav Petkov <bp@alien8.de>, Danilo Krummrich <dakr@kernel.org>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Huacai Chen <chenhuacai@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
	linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
	Rob Herring <robh@kernel.org>,
	Saravana Kannan <saravanak@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>
Subject: Re: [PATCH v2 2/9] ACPI: NUMA: remove redundant numa_nodes_parsed
 node_set()
Message-ID: <akyR4OFOb8qLlVra@kernel.org>
References: <20260703041329.2797584-1-ekffu200098@gmail.com>
 <20260703041329.2797584-3-ekffu200098@gmail.com>
 <CAJZ5v0iq+SjMvFVwsfwh0Zyp+h5MUJ7eeejQAOir8ssSu7yO3Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJZ5v0iq+SjMvFVwsfwh0Zyp+h5MUJ7eeejQAOir8ssSu7yO3Q@mail.gmail.com>
X-Stat-Signature: jgzyx8bg6okpocjm4mizqyec1ugu69cf
X-Rspamd-Queue-Id: D736080002
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1783402985-381789
X-HE-Meta: U2FsdGVkX19z9PExOS4pL+1SV92WlVHv2jqh0EVXNfdFJpMZgAqktKphEu9o6Sk6bQu6LRHQz6QOXmufCEIe6C39wlDywhGP33C0nQFvkMCfomj2ROiRlGbOp/BagICJ6ZzVHIGzGjYAEiU2E7Xym/d90Q+Ic3d/Xt7D58zRrO1ApI7Obs3xTqSLgXI5wosdIxVFHArtSkIuV+qtYbxSFvH+YAHww8T5yiyBnVwHtSVZG+J225qG7eF5ljrqswryg3Qz2clpqIeA6YqueWR7QXtl74QjeMTZzFlnX9Nzb9jZ/rIzcrNF4S69Tr13GXrKuhJxiUHSP2bcExQznvGgeP3ZyPYocFJ1A1DmcCq7dlLXiPpaGRucESoVY9gwCi20utrUDNcMZbmHUPyE4zVmd0qDodQYGp9hJTt6GCLY3UCFuOY6l40RQiHy2+eCTyEe26PYED4bqIzz1nvkX3GrM2gVU5ahACaXjyO+PoD559Bp6kDmkD337AGbGTo5i19l+5otr2smMG7RzTT4NjQ5+Q+KrGJDAyh2SYs/o47wsGBvgKLEPTfWYyXRJsO++Pid3GdqrXpuDVR4SADufW5YHnrryGzlg7IiBk4LHca7+/uwmCYIF3qEdgVEin6M54nK7jMWAJuihhAX383RjS2Zbxxv9UvW7hszSS+rq6gG2y4ZjJyZpTSaTZYiDSXWP4eQUPs9uxIwnxIt/X4RRFYUJXoOd5mbI4oVtQK4TyBMV2ya1ly/GhRj8OogVh44n01FGaepAWyl6B3T6Ip8XaZIlxj6DquxYjv+qkzIqVsGlJdvAQvmDblu8AX/xNyTJ58MIs/D5ccFIWHF4afz8xNUEyTrLV3wF1UWgojk31yX9sGcfAFsL/5T7eVLucNgtbe9gGqDtPHckCzMUlBti03xpx/jzhgHiU/ldF05eZJyJXStfL4HZS5DZgKujMZgK5H8HV3ZhdcDnl3KiQUjel+
 c77ku1OV
 QykSqBKhcX3QwpTwDXizK3wnHqA4OjLULedqDJuYrsG5C8lcocRd7IBVOtch6lNzGXWZeFjq4Brda4Lrew3OdLinCzPMnMV9WK5Olp5SOvukwNx9s6J/VJP/F/PHIWvGN5wun4FJ5jcIotbhO6z3X5DubpLDBscbijQB5J8c/STaWKAkbZ5E1h8Rxn6r69fTULyqKtVqwpI+8fnJU0ZCay6umMSHF3EeXzafHK9E8hn3lqShDoeN0ByYALqFy+6EeqDC7k3ASQOsZ1LQGhxoTlCHkiGDow+nusbF0bcese0FLg0caV3sRDOxK9Lf6ng6Kmr99APlbIS9qMp+f5kj4pX0W703sKRokVS/+q8JAR0owzI2rPPx1DDum7g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Rafael,

On Mon, Jul 06, 2026 at 07:57:55PM +0200, Rafael J. Wysocki (Intel) wrote:
> On Fri, Jul 3, 2026 at 6:14 AM Sang-Heon Jeon <ekffu200098@gmail.com> wrote:
> >
> > numa_add_memblk() now sets the node in numa_nodes_parsed itself, so the
> > caller's own node_set() is redundant.  Remove it.
> >
> > No functional change.
> >
> > Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
> > ---
> >  drivers/acpi/numa/srat.c | 2 --
> >  1 file changed, 2 deletions(-)
> >
> > diff --git a/drivers/acpi/numa/srat.c b/drivers/acpi/numa/srat.c
> > index 62d4a8df0b8c..5c407dc6401e 100644
> > --- a/drivers/acpi/numa/srat.c
> > +++ b/drivers/acpi/numa/srat.c
> > @@ -399,8 +399,6 @@ acpi_parse_memory_affinity(union acpi_subtable_headers *header,
> >                 goto out_err_bad_srat;
> >         }
> >
> > -       node_set(node, numa_nodes_parsed);
> > -
> >         pr_info("SRAT: Node %u PXM %u [mem %#010Lx-%#010Lx]%s%s\n",
> >                 node, pxm,
> >                 (unsigned long long) start, (unsigned long long) end - 1,
> > --
> 
> Applied as 7.3 material, thanks!

This depends on patch 1 in the series, so I think it's better to keep the
series together and merge via the memblock tree so I took it there a few
days ago:

https://lore.kernel.org/all/178306815065.2173096.9480193260074524906.b4-ty@b4

Would you like me to add your tag for this patch?

-- 
Sincerely yours,
Mike.

