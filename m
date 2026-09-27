Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 19801C9830E
	for <linux-mm@archiver.kernel.org>; Sun, 27 Sep 2026 22:03:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 14A306B0088; Sun, 27 Sep 2026 18:03:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0FAF96B008A; Sun, 27 Sep 2026 18:03:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 010036B008C; Sun, 27 Sep 2026 18:03:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D2AD16B0088
	for <linux-mm@kvack.org>; Sun, 27 Sep 2026 18:03:01 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3BA07120B02
	for <linux-mm@kvack.org>; Sun, 27 Sep 2026 22:03:01 +0000 (UTC)
X-FDA: 85260918162.26.D65F845
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 50FB0A000B
	for <linux-mm@kvack.org>; Sun, 27 Sep 2026 22:02:59 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=FPWknei9;
	dmarc=none;
	spf=pass (imf25.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790546579;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5AkcKF60Ps70Cr2izLfZr6VXCM5/oP84FSe9CK86mBk=;
	b=4SnPzUucb0upxFBa+Oi7Ndy5vitArdytB2SiL9tEAMP3qTotOUrgVGMdRv7aA2ykRxSay+
	zCA0ATsdfcJrXST46axaU/BVzPFoGgqj1p1Bq1tENVANkvN52XJSusPLjHg4ERbMD12jjj
	CJvK71UYsNdbKmuXILlHVIKlVUY3Jpc=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=FPWknei9;
	dmarc=none;
	spf=pass (imf25.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790546579;
	b=gBCU0CD8mD8c2ws/8NcX5ZLc9VnPU6BHi05bnRlhfQCA66R6m9d3ru15XocqSst3csUgKs
	oikz3x6LUZJ+Y4ABiFPSfgDuYw9vzL8IRez9roWb46E0AHj5LFTXsIbliobtqZSlEeRmMb
	EmB3pJou2eyZZsGDsMCPHwJg+2AKVsM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C0D0560204;
	Sun, 27 Sep 2026 22:02:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E1CE1F000FF;
	Sun, 27 Sep 2026 22:02:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790546578;
	bh=5AkcKF60Ps70Cr2izLfZr6VXCM5/oP84FSe9CK86mBk=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=FPWknei98AIXTxcK4IXGTSbYqX8bl0GY/tztGJ4AsjEYwnl/yS9iyESS1hiuL5A4S
	 YMiCQ13I+saVrqRIHyfyoDWNZCC1ApGVSGZFXcoYvuR5b8zXpOzK8M2BC8/W2kb8n1
	 iqkLcrbJzthnJXLI/tz4vJ+pnx4ZjIWwf/yXujJM=
Date: Sun, 27 Sep 2026 15:02:57 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Cc: Alexander Potapenko <glider@google.com>, David Hildenbrand
 <david@kernel.org>, Marco Elver <elver@google.com>, "Rafael J. Wysocki"
 <rafael@kernel.org>, Dmitry Vyukov <dvyukov@google.com>, Len Brown
 <lenb@kernel.org>, Pavel Machek <pavel@kernel.org>,
 kasan-dev@googlegroups.com, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, linux-pm@vger.kernel.org
Subject: Re: [PATCH v2 0/5] hibernation: make safe_copy_page more robust and
 remove debug_pagealloc support
Message-Id: <20260927150257.c9558f807114f2ce9c6675e0@linux-foundation.org>
In-Reply-To: <20260926-hibernation-v2-0-235f69f3ab2a@kernel.org>
References: <20260926-hibernation-v2-0-235f69f3ab2a@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 50FB0A000B
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: cii1wtwquz8fr8ayfjm5oudwt618moy1
X-HE-Tag: 1790546579-719922
X-HE-Meta: U2FsdGVkX189UV/nq5Ri4N6J70NSeS1dK3eE7VSL8UdmBd2QgKGDLIVMlGA2Tr4fF4hu3S5S/3VGHh3a8Lr2JZFz3qpJDq+42OclsNCtFrohtoB3orGJ/2vLdjzLOIKeKxNlGcP+YOr4w7z5UL9T7mxDjLJTh00lj2pupYWWn5d23tBkAAhRhyIBReqq+2CfPcXCEPN4+qKvk+uatOVbtk88hFYoatyo+zr6dtPyejm8weXxalLhdmVEoxTumWfyecxdBPV4rSV0sKEZbAU2p8sK0qDG8Km2/+4yVwNcUDRGVtLcZBNJFFbJuTpsHLEL931tvHWhk4HpmbHai+oxB714ObrL7DaniRi/DXBXKpd0nFWpMXNNdNYDtdXK3e01wJBv4OESfkibSzgieFh1xEGofr8kscABfsYgyK/dqSZPr3vGjMx7kHcoEBrH199Ah+tARSWMNasaxa/52aZjbOxca4jZMspNmWsp0lCMd4UWVwoho0BXlOksIyjXG/2yt6QV+sBHUET7Zo2HNnrtWXCFc/ufIc/IRBqvzNZuET9HPsWeWFDwsSSxy35bAohwaUIZYEikbO/rzk824VK0BCw61aGTqr3KIJk5aEWRs6RWHg0BBcGgL2mzuk9HsWwLpnMT6GT+MIT414M/CAeJ0YASVV13YkZUYqkqZaPDkqhde6ICmgKmduPOuQ7yLSoq54MkzlQWjGQcYnAKpu4vHbLKG2HWM2Mdw+JcsqWDvIPYD8t/Arpldq0kQpjyXMOc/deCk7a8HHfU6WK3L4xWbk4/R8MEdxMpQ/QiPDzaBx7dvho+CvOg0SvDTwhTR8AXZ5MiyyEwNT/MafpXIPqReSHS79pI60gA7fZHwt8UyCP0gFBK3kzeHItF2Rytq4EdtkOhZ6hFTDfzrp3PRoPGtgsMpyatFuj9Wf9tJt+9zWGrQmkg3x9uH6mj4onDtywwA7ZK+bXNkDBGUDQP2XY
 kUAk5Koz
 7PlYoo6n6Drg87ZxPqU4yQvv9+hSYxuOZup6UquMCeH1MuUyjB3e5+Zb0KroGlS2U4jZ9ycux9RFSK8jgQUl+kywcVLEhwRYqU5eI1HBQRjH3ahZQ8H3KnGAWAJX4c+GMSAsSh6MrLat7aFk5isID1YYwmEtDk1yrHIsjwRPLwemSSsSalM29xmxPHglq9QL2MX8CUo0cJj2v/SV9sHUuKlV6QPjcKwyM/RYoLYVsC0vlb0pauZRPtXO/iRHPGnkMxTJ6uZcwZ87qNT0AAiU0mYPHG+7xbq9T2DM1g34uhkKNsDp3f56iebH6/u3eYG4EwoGz
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 26 Sep 2026 12:26:29 +0300 "Mike Rapoport (Microsoft)" <rppt@kernel.org> wrote:

> When hibernation creates a memory image, it uses set_direct_map() APIs to
> temporarily map pages that are marked as not present in the kernel page
> tables.
> 
> Initially, this was intended to support debug_pagealloc along with
> hibernation on x86.
> 
> With the increasing desire to use set_direct_map APIs for hardening
> features and with their inconsistent implementations across architectures,
> using kernel_page_present() + set_direct_map_valid_noflush() to save
> non-present pages in the hibernation image is not very safe, to say the
> least.
> 
> Worse, some combinations of debug features, such as debug_pagealloc and
> PAGE_POISON cause a crash during restore.
> 
> Keeping debug_pagealloc compatible with hibernation requires a complex
> infrastructure for tracking free unmapped pages with a page flag/page type,
> verifying that it is actually a free page that hibernate_map_page() tries
> to remap and making sure there are no stale or failed page table updates.
> With init_on_{alloc,free} and/or PAGE_POISON on top, this also requires the
> ability to map and initialize these free pages on restore.
> 
> This complexity does not seem justified for a somewhat niche debugging
> scenario.
> 
> Instead of a complex fix to support hibernation with debug_pagealloc, make
> sure that copy_data_pages() and its helpers properly handle errors that may
> happen during page table updates, explicitly enable saving of KFENCE pages
> and disallow hibernation when debug_pagealloc is enabled.

Thanks.

> Mike Rapoport (Microsoft) (5):
>       hibernation: make swsusp_page helpers static
>       hibernation: ensure secretmem pages don't reach a snapshot
>       hibernate: handle potential errors in hibernate_{map,unmap}_page()
>       hibernation, KFENCE: explicitly map/unmap KFENCE pages
>       hibernation: make hibernation unavailable when debug_pagealloc is on
> 
>  include/linux/kfence.h   |  29 ++++++++++
>  include/linux/suspend.h  |   6 ---
>  kernel/power/hibernate.c |   6 +++
>  kernel/power/snapshot.c  | 137 +++++++++++++++++++++++++----------------------
>  mm/kfence/core.c         |  52 +++++++++++++++++-
>  5 files changed, 159 insertions(+), 71 deletions(-)

I'm not sure how to route this.  Rafael, wdyt?

