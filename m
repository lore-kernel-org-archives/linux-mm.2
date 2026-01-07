Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6FF1BD0D163
	for <linux-mm@archiver.kernel.org>; Wed,  7 Jan 2026 18:50:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B81BF6B0092; Wed,  7 Jan 2026 13:50:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B2F9A6B0093; Wed,  7 Jan 2026 13:50:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A317B6B0095; Wed,  7 Jan 2026 13:50:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9386B6B0092
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 13:50:25 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 40B0313B0A8
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 18:50:25 +0000 (UTC)
X-FDA: 84306058410.08.6D2198B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 7424F1A0014
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 18:50:23 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=KklHRCGk;
	spf=pass (imf19.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767811823;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5rTpeQ7ID9oK4vA5Nrc1X0v88udSPQ3k3zt71EqBTcI=;
	b=5qRBwgaUzr8G0Hji3xNqHRxyzmKnGietRuEpA3ymizpcx13G4A+vNvQev7i3+TUwJDoQz0
	p3Kq33mlWh2tdP6P/1oBh4LudUWRavL78A9AUYKWnoJqFpRSks7UX5LcgzQgOPCicXGbuA
	e7YOp7Tc4z1OeU3wGGf4sIzUr2MzobY=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=KklHRCGk;
	spf=pass (imf19.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767811823; a=rsa-sha256;
	cv=none;
	b=hF6nWpUv77f8B+scMd3Dk/KKh489Qb44679IujGtJkpeztmEQfbxj+zsBodoFl8vLBaG65
	ymDboE9kgN3pzDovMbU5Za3mDWuYJ8Inpk4nNg5bkoNCy39hvEt+kXf58YJSeQTndswhn0
	lWwOJIxmEWxafwZVmPxhzG9fF8Xkp2Y=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id C99C060007;
	Wed,  7 Jan 2026 18:50:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B358C4CEF1;
	Wed,  7 Jan 2026 18:50:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1767811822;
	bh=Y4pLzVaa0SWeGLDBr0iKwv8zCtA9vbvF8t6Cep8sKOU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=KklHRCGkDUYjS72U1qRtDhtEg9UfMnt/kksbXXpetXl8xnJ/asICTAiAlAfinDn7G
	 1LQIdwKABYIdV7ZLQDfLnYXo4YZRBJjiMKYFA1WaIOxVJLwRsocB4+nZo6e45135aN
	 nOsz3ogmJ0GgEL+GeJaYUD9HSFx6qtqiq/05gDBY=
Date: Wed, 7 Jan 2026 10:50:21 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Mark Brown <broonie@kernel.org>
Cc: Claudiu Beznea <claudiu.beznea@tuxon.dev>, Kefeng Wang
 <wangkefeng.wang@huawei.com>, David Hildenbrand <david@redhat.com>, Oscar
 Salvador <osalvador@suse.de>, Muchun Song <muchun.song@linux.dev>,
 linux-mm@kvack.org, sidhartha.kumar@oracle.com, jane.chu@oracle.com, Zi Yan
 <ziy@nvidia.com>, Vlastimil Babka <vbabka@suse.cz>, Brendan Jackman
 <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Matthew Wilcox
 <willy@infradead.org>
Subject: Re: [PATCH v5 mm-new 0/6] mm: hugetlb: allocate frozen gigantic
 folio
Message-Id: <20260107105021.7ceb5bc13847e85385f69ef0@linux-foundation.org>
In-Reply-To: <13ad5888-2d53-40c8-9269-22bc6001754a@sirena.org.uk>
References: <20251230072422.265265-1-wangkefeng.wang@huawei.com>
	<4211be25-3fc0-4395-9b24-a5ff0b3caa34@tuxon.dev>
	<13ad5888-2d53-40c8-9269-22bc6001754a@sirena.org.uk>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Stat-Signature: eiq3tpmu4ru4bi96ruio1xaz8yxdqx6h
X-Rspam-User: 
X-Rspamd-Queue-Id: 7424F1A0014
X-HE-Tag: 1767811823-231226
X-HE-Meta: U2FsdGVkX19vBYeB7865nnW34RgTMrRqXMRpf6jgASOntzldnlzd0jT4CS8c+2TTnGHHtep+ucfDUL9abNfQjKIYIEz04ydSPpLeWsOe6GjzCSxmx86822Nm7R380DDM6ZJFLOmWZQXBCbSEHmZgZ332IOzIvGyLJUrdlqUi3x29RU5ePmGcWN8JTOfZq2GFZI7M5zZcpiB3MBlciIQ/sSL3HXW2xC2UtZlWZm7wBvGFfcUcURF5XfDtCeRNT8KiPoDbIwxKGTC0HRo6dKFDIvP90h1DpIWC9WY5p+7ATyE4xohlaEd2+5uCl50DD9wDOt0PuqLKmCC0WOgtL5zTHmwYa+Seas8S3YbxtI+bZaBJplMMDMyZgC+qOuaukkhivXB4laWHYeQ9MQoMfzv69Ykt/ZoVcovE3FmWMt0SihkH51dAYy3AcPEahuDRE4xQGvkcbQiIfSh2NdLvpJTQ7DSTp9O45ZSwQsRdOZb5cVK7Kzvi6Sd5r3ScR1u5Fo6me3VYO9qo1qVSNUxtfvoAJWt2nZLZronKxngnNnsTHX61kpt/F5al7N+dua7FU+qB3Cadbj2B2qnKiXhuwHOWcj8eTmlBIAeDpDWDQbRjuYh/nsot1sPQQtjLLf3XP06v1s4hJ+HefG0vvTT5FcqguajDglvkfkNRdb6bC0F1R+a2Xu0ZMGqYXZNDMHeLwbM79sxH9w0bTYCqrR4yQSStdVb5sDw5BUnaannnWjxJZwd8Gl/jLsXCsRYYjwisaRGs1RE3WOII3STN868L69J9syS96Ye+KubKFV4RuRj64CIW5uyPrbPwiwc2swMzmJWdPnuP1iHnK0Xn83nu+Fm63naApplJxEiGNkYVHZ4/fVUTSbwv8kjNyMJtR6zN4Z0Fu4MmeOTsGS0r8iAqQ+B1cW7itmL7eYmTn9r543BGDR6fgIIlZ5mV6LGLC6UntCPRlSYb388HWsNqvcl7CUx
 ehH8g/Ep
 jF5L1jASvdDJSpV0/5/SB/z8mIwzbTWmaMZSR1o8l+d/+O4nVxTrtn36/AvIlEZwfMok8ah0KB+rDo/yRwEYU695unKVkHX1ct01Eg5FWmnCQH+GX/HMlgm+ouLQKLP05oFyZm/RSafw6iS0YEcWHl1W6DVx6JmbPkRWmCRuxKPfnea577/LI2UNVS96QobszY11GC91wJ4fmtzAFoYAXEkMA9In63dS5a+0JfLybx+xravv1ncPKJD1dH5e8TOFrQ0Ep9QYEUV1iPjUoFcPVpM75xg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 7 Jan 2026 18:39:17 +0000 Mark Brown <broonie@kernel.org> wrote:

> On Wed, Jan 07, 2026 at 07:31:30PM +0200, Claudiu Beznea wrote:
> > On 12/30/25 09:24, Kefeng Wang wrote:
> 
> > > Introduce alloc_contig_frozen_pages() and cma_alloc_frozen_compound()
> > > which avoid atomic operation about page refcount, and then convert to
> > > allocate frozen gigantic folio by the new helpers in hugetlb to cleanup
> > > the alloc_gigantic_folio().
> > 
> > I'm seeing the following issues on the Renesas RZ/G3S SoC when doing suspend
> > to idle:
> > 
> > [  129.636729] Unable to handle kernel paging request at virtual address
> > dead000000000108
> > [  129.644674] Mem abort info:
> > [  129.647456]   ESR = 0x0000000096000044
> 
> This is also introducing OOMs when doing at least audio tests (I don't
> think these are super relevant) on Raspberry Pi 3B+ running NFS root
> (probably more relevant):
> 
> [   64.064256] Unable to handle kernel paging request at virtual address fffffdffc1000000

Thanks.  I'll fully drop this series from mm.git.

