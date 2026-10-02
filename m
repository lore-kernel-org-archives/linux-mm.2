Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 17D2DCA5FC4
	for <linux-mm@archiver.kernel.org>; Fri,  2 Oct 2026 10:52:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C5CB06B0088; Fri,  2 Oct 2026 06:52:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C0D656B008A; Fri,  2 Oct 2026 06:52:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B227F6B008C; Fri,  2 Oct 2026 06:52:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 92ABE6B0088
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 06:52:32 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id AF616C06EC
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 10:52:31 +0000 (UTC)
X-FDA: 85277372502.17.0133284
Received: from mta1.migadu.com (out-207.mta1.migadu.com [95.215.58.207])
	by imf17.hostedemail.com (Postfix) with ESMTP id 83F9240008
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 10:52:29 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=QtbFyhaq;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf17.hostedemail.com: domain of brendan.jackman@linux.dev designates 95.215.58.207 as permitted sender) smtp.mailfrom=brendan.jackman@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790938349;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SE0QJc8eprV/QOkhdmZ5tpcHsbeqKD2W7iTlkASNaCs=;
	b=4XnNdymFrBoPjPWba3hAu/CUKmYM/WirfbVmZl19f66jSMFLKdG0rHJ8ATAviB1hBXNAMR
	O6BvcVj2advDxEg+kTUxTLFAU2F62wdrrIrH4ewpC/fHD5JRN3CzSsLm3rJo3f5P486dim
	sSUcOmpWO9abhw9cobW5DunL8QIRSsQ=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=QtbFyhaq;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf17.hostedemail.com: domain of brendan.jackman@linux.dev designates 95.215.58.207 as permitted sender) smtp.mailfrom=brendan.jackman@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790938349;
	b=V3cUhFixVlzq8kt9TUwO6/dNAqD8hf9uhlYK7OEEkbzZJ9bjqRGHSNhEN3SXgf4PF580Qd
	T2DQvQ4uUpaH+2MAPOIHHOrEiVCwe8OamHK9dQQ303IOmZFydM3QQ79hbzdk8CHsgJqsgl
	dRIq+S74DWwcMhI2ocWYYbG0w30gMp8=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=2D44/9zUPSKPVqBDTTqQTwAsiNBVg+7q3Q67Op/M820=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790938348; v=1; x=1791543148;
 b=QtbFyhaq6lpw2b/wi358vHULtBCIvXBb2moEhnglY0kwC6Okmr+W8ObtW8mKmR24uyBQRV7E
 Os8ufvOpLzKBrhnaFHn4REPK/WvcD1jY4y88K6dtG7B0O6qJUa8kZfBkl9uBtvGIdBBOWU0j8b8
 umnyub5z3hntPwoL0ALKIFr0=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id ff74b3509b06fa11;
	Fri, 02 Oct 2026 10:52:28 +0000
X-Mizu-Trace-ID: ff74b3509b06fa11
X-Migadu-Flow: FLOW_OUT
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Fri, 02 Oct 2026 11:52:22 +0100
Message-Id: <DLUANOHBUP9C.14W0G57BHYIMF@linux.dev>
Cc: <linux-kernel@vger.kernel.org>, <kernel-team@meta.com>,
 <akpm@linux-foundation.org>, <vbabka@kernel.org>, <surenb@google.com>,
 <mhocko@suse.com>, <hannes@cmpxchg.org>, <ziy@nvidia.com>,
 <david@kernel.org>, <ljs@kernel.org>, <liam@infradead.org>,
 <rppt@kernel.org>, <baolin.wang@linux.alibaba.com>, <nico.pache@linux.dev>,
 <ryan.roberts@arm.com>, <dev.jain@arm.com>, <baohua@kernel.org>,
 <lance.yang@linux.dev>, <usama.arif@linux.dev>, <kas@kernel.org>,
 <matthew.brost@intel.com>, <joshua.hahnjy@gmail.com>, <rakie.kim@sk.com>,
 <byungchul@sk.com>, <ying.huang@linux.alibaba.com>, <apopple@nvidia.com>
Subject: Re: [PATCH] mm/page_alloc: let the bulk and folio allocators carry
 alloc_flags
From: "Brendan Jackman" <brendan.jackman@linux.dev>
To: "Gregory Price" <gourry@gourry.net>, <linux-mm@kvack.org>,
 <brendan.jackman@linux.dev>
X-Mailer: aerc 0.21.0
References: <20260914155115.439742-1-gourry@gourry.net>
 <aqgjUJWVUS_nx20i@gourry-fedora-PF4VCD3F>
In-Reply-To: <aqgjUJWVUS_nx20i@gourry-fedora-PF4VCD3F>
X-Rspam-User: 
X-Stat-Signature: kbnipnpfdsxgyk17ibi9x9rsd7hxmcit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 83F9240008
X-HE-Tag: 1790938349-267573
X-HE-Meta: U2FsdGVkX1/j8NsoQfQkRxxYsre4S66oy9PZ/kHjck8+H/r2Ni7MnG/UWYl+bQMzY+L419T0NLiWJnIqg6ZIv2ynZ1SAbPE2lucjLGUQDNlBSxplV7LN9L2taCN+1LXdWsUPsRy27n6OUYcgSDKi/Dk2CumPrjDjYTelozU176pQl7Cy47RiQmTnyTAFQq27el2jnFPGOywZQiFNtMZOMIX5aSqzUB3f9hU8GQKw/sKdWqWaiu1nBE6veDQzIGeK02B9UWOHyY/PXIv4OQ+jbMyLjAQ157kHxVdGgqUu36C7jPjkIxjgoXRD0T9Yp2Wq58l+smzw1/YTYyrUAupI/k8N2FCNCm5+fEVLB+JXK30TS+UFSMoD3pHCpBTexEo50jWdEyjRohsFqs6q5e3vNOP25mcs/hEnvCETqD7dYX5D3Jb8YWk0vjYHnKGpSnIPm8LT4y/PM8QPxsLQKRlu29DAt+vHVN+JflCD3EI0MoP3vIcfWwQkWO5kMM2u+2kUuHTMfHolcck/GqH3UaRHXuJ0iMUiQm0bJPGYxYNZUFJlTWTT1TDYDh5Esw3wLRr4f5CwcCa8ZQziEseKEEJA019OasRz60esT5wxMLSdde1E981JT7vzYqQ0puG8x1JZae7C06opxBauMXcXUzVTYJ+JwskeN6yEBsBeCMgaRG6cnqPEjvOQz6LfkGdGqHwhLcxt9nIO0sl3xVO+93xKd68sgwHhfR/di4ly2II6GWcurkHqWDl3HIJ8MOKurXBhWIHuee+59cAxhsrb8icKeBgb13aP5XQce5TwKs80Y6YeryzBUIEV+wCJzTuZkNBs+3AbQhA3yL416HeXLum7AzW5DFkAwlNhVnt+LiQuBSa2nbV27ktThqv/IoAptR+B4JoOxYQkTDXujVzJzXpg5wgTWXhDrK9ahDqlqrVeu5h5z4auFO/jsz65mrWmS79HifGMPYifiyMjwBKaLWV
 MBUFNvTu
 D5STEuy9ReIrhK1jT2wj+ZifRu+9IjKC7qL0XzIcSIEv2DlKCWuI9lfEHHkQQVv/FomAxW7vCUyJRi1vaKpyLGOlXy9pwycp5+wUAAYKS3Kn1YzWNjvyM/mowQP0VG9a9hbo5+Oxv3QATr3zPc298+k6Zv+HKe7oiAVCAFNjOb2My3L3ak3qVhGqF+YfpatuZEigi3lzb3enRLPXm5wXwhgqnD8L2cybURMJkVkLP4f0GpKSio6RXTd5QnXNdLq3KRdOogsCXfjPNeqvRWuIPinZXlO+MqLroQGukOaYeVI7VHT2gzL5gnJwrZQd3hs9ai658LkFKF8HOmlq7k5Pk6MfvzijiQNA9zmIa6nipwOd9D8jfD4kF2e4nuA40f82RZmu4RVfq7A12RDTB7ypN4C6NdLuQ/A8DIBVklylg+cqobaUMT8WXZqBxk/+5M3u0OnxxP7Sr2546hod8uep4oLPzQvMwzQtIwrZ7IThsssnk41c=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon Sep 14, 2026 at 5:54 PM BST, Gregory Price wrote:
> On Mon, Sep 14, 2026 at 11:51:14AM -0400, Gregory Price wrote:
>> __alloc_pages_noprof() takes an explicit alloc_flags, but the bulk and
>> folio entry points do not, so callers cannot select allocator behaviour
>> (e.g. an alternate zonelist) through them.
>>=20
>> Thread alloc_flags through both, matching __alloc_pages_noprof(), and
>> keep the flag-carrying primitives mm-internal (page_alloc.h) so the
>> public gfp.h wrappers stay flag-free:
>>=20
>>  - add __alloc_pages_bulk_noprof(gfp, ..., alloc_flags) in page_alloc.h
>>    alloc_pages_bulk_noprof() becomes a wrapper passing ALLOC_DEFAULT
>>=20
>>  - give __folio_alloc_noprof() an alloc_flags parameter and moves
>>    __folio_alloc_node_noprof() moves into page_alloc.h
>>    __folio_alloc_noprof() is no longer exported
>>=20
>> No functional change: every caller passes ALLOC_DEFAULT.
>>=20
>> Cc: Brendan Jackman <brendan.jackman@linux.dev>
>> Signed-off-by: Gregory Price <gourry@gourry.net>
>> ---
>>=20
>> Brendan this will conflict mildly with your ALLOC_UNMAPPED work,
>> because you add an init_alloc_flags call in alloc_pages_bulk_noprof :
>> https://lore.kernel.org/linux-mm/20260726-page_alloc-unmapped-v3-20-6f57=
29aa9832@google.com/
>>=20
>> I wanted to pull this out ahead to try to deal with the conflict.
>>=20
>
> Sashiko pointed out some issues that arise from rebasing on the recent
> ALLOC_NOLOCK work, and in a quick review I found a similar slow-path
> fallback issue with the NOBLOCK patch separate of this patch.
>
> Brendan, if you're alright with it, can I pull the NOBLOCK patch out
> ahead into a 2-commit series and I'll add the small fixups?

Hey, sorry about the silence I let LKML pile up rather badly, it's been
quite a month..

Yes I am totally alright with this (glad to see you went ahead).

