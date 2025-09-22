Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2C6EDCA100F
	for <linux-mm@archiver.kernel.org>; Mon, 22 Sep 2025 21:23:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8AF0C8E000B; Mon, 22 Sep 2025 17:23:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8869F8E0001; Mon, 22 Sep 2025 17:23:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 79D758E000B; Mon, 22 Sep 2025 17:23:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 644038E0001
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 17:23:12 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id F22E6C068C
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 21:23:11 +0000 (UTC)
X-FDA: 83918161782.01.254C6BE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 69AA3180008
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 21:23:10 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=ua5mBLSK;
	spf=pass (imf06.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758576190;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0gCwGlZ8CY2A3FXzOeVy9OeKGn7L/VR3P2r+tlBERUc=;
	b=HoezitED/267jzq/68EVsiXYAFsYYcIZngsa9Z2Ee7f/H5ZU2ZGlR8KBDyyc8g0QW7azpW
	+6RbJDKstvbicNL6XoPBtUgB/7TPnOW9CS9kcfPlvjf0zhj80Joiejp3kK0vX1SdHSVmA2
	iA+82OlWwhr4tisrqB2G09++gx+Bzwk=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=ua5mBLSK;
	spf=pass (imf06.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758576190; a=rsa-sha256;
	cv=none;
	b=HlxyLJtPTt+xinAZekmLkLdVMiVBZxA91HAN5AjlT8e06j5iKULXBJrbCIy2YpvXYUYSEG
	Czkzagdcfhjdac1LIPM2k33GB2nx0XGpEFB0QtLicMC/DVe8cb0CklAp+qXi8euz+HkH0w
	Z6fHAeijrOlN5eY68VQkI5VoY7Ece7o=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 8700D60257;
	Mon, 22 Sep 2025 21:23:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5CE3C4CEF5;
	Mon, 22 Sep 2025 21:23:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758576189;
	bh=YIJZv7/h0GsyGJwWQh9Ro75daSezB/fib8mlDVLM5SY=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=ua5mBLSK2YXIEzSHlfOiL2ItM6FhaYpUTjODNC6xqEN+/kHfZMXMNfTrT4x9TXaZG
	 sJoR09urv+5Xy+T7xdnecDXvmczqPRKIYIJ77DgTz05TKWSSgIduHFMkfFu3wvgtcL
	 79YTB5bYcJ0ezc1l8FuqQe8Y9kGlPPShW0rwlPdU=
Date: Mon, 22 Sep 2025 14:23:08 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Mike Rapoport <rppt@kernel.org>, Alexander Graf <graf@amazon.com>,
 Baoquan He <bhe@redhat.com>, Changyuan Lyu <changyuanl@google.com>, Chris
 Li <chrisl@kernel.org>, Jason Gunthorpe <jgg@nvidia.com>, Pratyush Yadav
 <pratyush@kernel.org>, kexec@lists.infradead.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 3/4] kho: add support for preserving vmalloc
 allocations
Message-Id: <20250922142308.144ac7bd7bbcb9f5a68ac3a1@linux-foundation.org>
In-Reply-To: <CA+CK2bDFScwAwyKA2NNkQhvhrj5OsmHm4eTshw2B9e2muqBcvg@mail.gmail.com>
References: <20250921054458.4043761-1-rppt@kernel.org>
	<20250921054458.4043761-4-rppt@kernel.org>
	<CA+CK2bDFScwAwyKA2NNkQhvhrj5OsmHm4eTshw2B9e2muqBcvg@mail.gmail.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 3dzcxid6cffj65dkt3t8ysymtackb3qk
X-Rspam-User: 
X-Rspamd-Queue-Id: 69AA3180008
X-Rspamd-Server: rspam04
X-HE-Tag: 1758576190-164914
X-HE-Meta: U2FsdGVkX18MMDoaCJmhVr2gVih2zfdgmfHwPCAz1AvHvO1521kbI+X6sI8y3ocSCoe8jfnVkjueGlAfE3cSwRj4+QaDFL6WIgVckPNYxVU3RTFJhQ5xuT3vcy7Sr2bKrs2P5+qV19/zdDXNfASA6HkCyrQyF1HEI/MxU3pANfex67Zh2VxP2CC/5rmfpUH7U1wJoD95V5F99i8PK9lpwCZ2UzfHQPxqEHpIPWG/Z21xZDDPhOYtbb6fY7D6TsT9umG36OeZQK88NDsOvfBtTgz8LBUt8QFeSOCw/78rIyBqazABgtIAfXQ9G7Hd27HDm9evlnbUqFUQmjws1yajx7cgAQfm8w4/boP3YcxIX4Hq+3xDGbgtE2kN66VMkAL/0aIhpPW78zrKvnKN47CXPD0k7QTQooNqo5DyaOzEBCnbhIDiot0hKGQoVGOI5oQARKWMUd/GMqGmGzmKXJmp2H6Bnf9HSTRMxQrP5QDtkuTbZzerRNbTANqTK1dRK9KBs2N0iR79ujbGTJnVRsI9YFkMiqSKPyWiZYT8As+ZU6OS/AxSAIL0peZiHn5yxB6Yq2DWqKv7wERY4D4Up6/aSGSaL3dN/b9iRdpdXVQV6OxssMmE1FNjLQklL59rCt4MbQQgyVbtg8jJ4ePHz1XldBz+zIG/rKLHzFYbfsau4dRspSw9wh5uG6P+yka/3M5dckBPLhYwD3STTNcMH8HNZeY8J//KUY7/ftcOQ5ZuhkOJwH+xHWT/tJ3I3zkc1BdcdHvncHiV1qFmt2nhM1wkfRufAkaOOAClAXVnFqeRNARzm+HhQT5TMR4VacHs93GpeQ7k+9Yo+6SRFSnBaEXl5yniSywoO2pSP0u98ZvGQXP7jNFwnkeT6NcsJW/n7I3W
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 22 Sep 2025 10:17:56 -0400 Pasha Tatashin <pasha.tatashin@soleen.com> wrote:

> > +struct page *kho_restore_pages(phys_addr_t phys, unsigned int nr_pages)
> > +{
> > +       const unsigned long start_pfn = PHYS_PFN(phys);
> > +       const unsigned long end_pfn = start_pfn + nr_pages;
> > +       unsigned long pfn = start_pfn;
> > +
> > +       while (pfn < end_pfn) {
> > +               const unsigned int order =
> > +                       min(count_trailing_zeros(pfn), ilog2(end_pfn - pfn));
> > +               struct page *page = kho_restore_page(PFN_PHYS(pfn));
> 
> This line breaks linux-next build because, kho_restore_page has a prototype:
> void kho_restore_page(struct page *page, unsigned int order).

Thanks.  I think that's all fixed up in mm.git's current mm-nonmm-unstable branch.

