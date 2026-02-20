Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B2D24C53213
	for <linux-mm@archiver.kernel.org>; Fri, 20 Feb 2026 05:15:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1DCE56B0088; Fri, 20 Feb 2026 00:15:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 15FDF6B0089; Fri, 20 Feb 2026 00:15:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 06C506B008A; Fri, 20 Feb 2026 00:15:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E5A006B0088
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 00:15:24 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 10E50C32F7
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 05:15:24 +0000 (UTC)
X-FDA: 84463671768.14.4E0BBB5
Received: from gate.crashing.org (gate.crashing.org [63.228.1.57])
	by imf14.hostedemail.com (Postfix) with ESMTP id 6FB5A100003
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 05:15:22 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	spf=pass (imf14.hostedemail.com: domain of benh@kernel.crashing.org designates 63.228.1.57 as permitted sender) smtp.mailfrom=benh@kernel.crashing.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771564522;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=d0zkO+y4iqdeqMSNtIam0kHt8Eofw4JgBEiI/LcyCg8=;
	b=BlkppKdSe6hpYRxBhR+a3bmnBxGV4rpvLOvrxb9nLIG9n4NB92EbhL1r6s4O/bnj/nuiGm
	O3QOdsXPijsuB7JWu01IJ+mLpWJYkbI5rqF6atAaYyxXubHiLT6jiGWT0kM+t6nWZ0Bh+2
	XMymjxf6pzLacvhJN/sUkMURZA3MKKI=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf14.hostedemail.com: domain of benh@kernel.crashing.org designates 63.228.1.57 as permitted sender) smtp.mailfrom=benh@kernel.crashing.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771564522; a=rsa-sha256;
	cv=none;
	b=8BntfzZdgP3mYjTYqPxsPixd/STMBO8vkHBn1OwIGBWDAYxIB4yxgmvUN/xDQUbryyJd3K
	jdlh7t4NpHpmCcEbcVpKCI/5QBWA+EOqEnez5Y0JkntPE03YGQOqmiZMJK/ct+5kXtaRLm
	EDoJLxW+aX0mPWyLfrBT8UWDu92JBuQ=
Received: from [IPv6:::1] (localhost [127.0.0.1])
	by gate.crashing.org (8.18.1/8.18.1/Debian-2) with ESMTP id 61K5F5fe646911;
	Thu, 19 Feb 2026 23:15:19 -0600
Message-ID: <09f60d028c040f144195e6076d453e6deaec8318.camel@kernel.crashing.org>
Subject: Re: [PATCH v2] mm: Fix memblock_free_late() when using deferred
 struct page
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: linux-mm@kvack.org
Date: Fri, 20 Feb 2026 16:15:05 +1100
In-Reply-To: <aZbjCFqlqdFwKSHR@kernel.org>
References: 
	<ec2aaef14783869b3be6e3c253b2dcbf67dbc12a.camel@kernel.crashing.org>
	 <bbffd0db46460cebd604f5c1e6668984fd4cc435.camel@kernel.crashing.org>
	 <14295eba34f10f5896e6cb7d3e1abd36199cd918.camel@kernel.crashing.org>
	 <4d93284349178a783725539b66dca25725fa779d.camel@kernel.crashing.org>
	 <aZVyxKVS8y-rqwrK@kernel.org>
	 <6453da0558ba20d5c87e730bdfedd47966977931.camel@kernel.crashing.org>
	 <aZbjCFqlqdFwKSHR@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.3-0ubuntu1.1 
MIME-Version: 1.0
X-Rspamd-Server: rspam05
X-Rspam-User: 
X-Rspamd-Queue-Id: 6FB5A100003
X-Stat-Signature: jspabbnjh7wwe76ojxdk55teougmzy59
X-HE-Tag: 1771564522-704318
X-HE-Meta: U2FsdGVkX18gd9tsryhyl4rYGyNlItpr+yrfLwjb0vpbSqTYHXB6Z6B8S0gMZH12iphh+hVCo8fkgjOnek4XCXqb4O1Bp8Zr63bWBuJQB2TfKh6MHO0VHA2+WBaopVSB4CWlM5E0HSq1LfNbJMlgrnCWEbifN0BHP37diJdem1mZ5g9s26oqvicL5Kwk9qc0sUz7Qd5aXXalY6v9eT6SpsJVygjtJkfCp5qgm6W7/z8AGy6IiKVN4iAvmI/t2gSxlFGFuNtOsOomrockMbLEtbks/rSDkY+dxBMl7h7YaMDlXDdrvpWEpBN8s0MWBfrHRzRjDseYoexYX8XBaQWeSp2QHYiJrCxLlr2zH1R8wOzo+nz8KhGnD9G/12xIgK6eXHNlTllTpW8EMAxabnD3iwMk3BWnDSlVOYhy69LYvJ/6+Nm7XaK1pnidWzxnLaTBImP+KszANBRu5btyk28eL1htD26xxCuP4/eflX0RwVrXDgsC3fBDbIY9gv0KtReffBzsIycBJ3jNPnPf3SMSLamApJRt16PCF9/YuNBeOyjP4EGb4vVt+GAeWgCCbhCPmemrJd4ng7OfP4ptrVY4Cc85ZBY/UOz06ILn/ilCNHxpKZE2iS21Cay5yqtvtP2TAmfCpfQpI11Q+8TO+5Oi06Fy+m1czObIoMhkQUbJLDp+x9ZlH172DIOWLKESSAGwiklvG3+mv/oM5dy53C+diXY4Kfogt9y7XUQ0Tf77aPoKVPpzyL5Mo3ENF3cWjG1SbA2P7w5Rc60Vb9EeWpPZcxk61Yu7FqRQIuQCbJE0woRMJCXRQm9jv52z0RYJqxZgCYnvgPECJkuEIL3q0oM7D+tQ7tm5/7I7g2E4oPeD/JWdKC9+sIzL4L6nIbPFfd0PkK8elmxiippFg6a3hvaSNGhlWs8dgSG+9QxONUyVcSZnkvh2Gtt0sl57/RSHVuLUdc9b6g/DMOR1bimtqfr
 Y5f5pnGv
 ZTFjew/u9A1xUACReAMUYiL0tEfbYAtHwUBLgDlfvVTPtCoV6MDoYe2+4TBWR5PLrQS820aUQ8lFirEL2ikGjoCD0h9+bZB0IO//7E39JrZM8QXaW08ZvG5bW3g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 2026-02-19 at 12:16 +0200, Mike Rapoport wrote:
> static struct efi_freeable_range *ranges_to_free;

 __initdata ?

> +static int __init efi_free_boot_services_memory(void)
> +{
> +	struct efi_freeable_range *range =3D ranges_to_free;
> +

	if (!range)
		return 0;

IE. We might not even be running UEFI or we might have hit the

 	if (efi_enabled(EFI_DBG))
 		return;

test and thus not allocated the table.

> +	while (range->start) {
> +		void *start =3D phys_to_virt(range->start);
> +		void *end =3D phys_to_virt(range->end);
> +
> +		free_reserved_area(start, end, -1, NULL);
> +		range++;
> +	}
> +	kfree(ranges_to_free);
> +	return 0;
> +}


