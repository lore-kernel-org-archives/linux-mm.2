Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6780FCD6E56
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 10:40:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 861CD6B0314; Mon,  1 Jun 2026 06:40:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 812766B0315; Mon,  1 Jun 2026 06:40:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 728326B0316; Mon,  1 Jun 2026 06:40:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 611E06B0314
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 06:40:14 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B471DC22BC
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 10:40:13 +0000 (UTC)
X-FDA: 84830999106.28.10AD58D
Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	by imf11.hostedemail.com (Postfix) with ESMTP id 0494C40008
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 10:40:11 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=FjACQjOW;
	spf=pass (imf11.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.174 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780310412;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+kxihP4QbZH/SbV81BhxMKE8qdk0EBh4QHfFzGdZZ1g=;
	b=aQ8vz37lUGRwyw6cxYfQLaoQBHAf44vZBrUq3ybCrTbKAb3axxJI/OXQWA0OtpXmio6jxQ
	50kLlJXI0O29oyasOi3L63GT2KD10fkbv2B5TqNqWjb14oAdqZJi67d5WN3d4nAzBCZOEe
	uWtDo0/RrRYv7PfIFBk1qdTIFhCqL1s=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=FjACQjOW;
	spf=pass (imf11.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.174 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780310412; a=rsa-sha256;
	cv=none;
	b=mPCHySW50CSahx8/HrsxzIy4GhQU/A1uXNJI3JiUbGWvwesgsjpOs/1oNe8cXVj9LAMl2+
	QJFnUiOvITnCE2KFV40z4C3mz9un/peWKr8X1SC2MaeADazz8x2V29piiNXo9sg7KMfZCD
	IhKEJh0GgNP7nsW98pJ1YDCx/I3kG0w=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780310409;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+kxihP4QbZH/SbV81BhxMKE8qdk0EBh4QHfFzGdZZ1g=;
	b=FjACQjOW1MOQtoUqCCNCGVBX+brPhDYVowfPvlbVuB2B7NGhsRgGhCegZQHJTQHw8+9xR4
	RSmQ4zKh26ma4ohTxjq+VqQQlcmn+ejFhVGkVvqdkz77SAZgJsdbfmBAJT/cwR8371K8MS
	iugrU/Lsa7XIbrkFN17aqtQjZ4L9hIU=
From: Lance Yang <lance.yang@linux.dev>
To: hannes@cmpxchg.org
Cc: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	shakeel.butt@linux.dev,
	mhocko@kernel.org,
	david@fromorbit.com,
	roman.gushchin@linux.dev,
	muchun.song@linux.dev,
	qi.zheng@linux.dev,
	yosry.ahmed@linux.dev,
	ziy@nvidia.com,
	liam@infradead.org,
	usama.arif@linux.dev,
	kas@kernel.org,
	vbabka@kernel.org,
	ryncsn@gmail.com,
	zaslonko@linux.ibm.com,
	gor@linux.ibm.com,
	baolin.wang@linux.alibaba.com,
	baohua@kernel.org,
	dev.jain@arm.com,
	lance.yang@linux.dev,
	npache@redhat.com,
	ryan.roberts@arm.com,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 9/9] mm: switch deferred split shrinker to list_lru
Date: Mon,  1 Jun 2026 18:39:47 +0800
Message-Id: <20260601103947.63923-1-lance.yang@linux.dev>
In-Reply-To: <20260527204757.2544958-10-hannes@cmpxchg.org>
References: <20260527204757.2544958-10-hannes@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: aho5nkiguadkkfu6ywwubfgakf3rugf9
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 0494C40008
X-HE-Tag: 1780310411-680463
X-HE-Meta: U2FsdGVkX1/n5sLjQx5cgGt+ZK99dElajS/xD0mqOyVeEhr/Jt5vQEbU/D81Y45k+qsLoq4/sXK5OnNXJT1Tvzioh3UipmjiKfPneVwwnuK2N4SbCGu04JqQvgbN7XLy+1X2hqP7aMxZKfuq90V36l2JE9lemMSKmEe/bIlMEKdkICze+iCqyfBxik1JBgym+rE9B7fyji2y/k3F59R4/yo1CE3BCC2hzRaUr45FS6gQkJrEnivs1JpR6CTjeTZ5V+OXypd0R2obPghYEWcXORyI3KB0Z1r3QadXnWCrVRE2YVwwPHqrff4bj5K/RMuyvy+W94rkVZpXWXFPmagzWH1+H4/Wpgfh7cxrxxmOVtC1MNrpvXbfqlNjTtH71pPqpGiKbfkPctqEmo/4kAIykm0dfiL9TtXf+zJlWutKBgqNQze9lEm35zDtf4IASnf/YUAGSXN0jFjIqBRGk/IayOg6JHi7xnvzc7wlsi4aEO18MDUdkIXuq5AsZNVjGZNleBXahbNeS5tddIxRv8AsDlM4qbnLruf6e6ivCpPLA8Qc3ImubbvWbFPmlsxBI0apDafdWQyD9slpY1hXdxLvPuEcxwEm6+IjyC/nVsTR9iFDPMRaoiOghELs2KLioQ+dS/bmu7cN6lKPaVK6dETrZXnfTQHPfWUHOkjBInjY7tzB0zJMWKJL9l6GwCh5sCv3TkZVZkn7AejqC75rMQbqK5a4S9m6BYfm7/2RviVzQK3NtoUIKJ6Lx0B/SZDVv4uy/I+/spyNJIt3BvhadYQepqoIuZO++8FWSHG+iWBBYerAipVnRh0jzY0d5pbHoXtwCWfAP8fftAytg3Ngh3Cl3FPwA/TqF5lxEoWqRO4E8/Phkz7iE9udYA/CSvT+2Fjxs4MD2mjY0njfMeRsPjzakfB2ZTzJKjcC4QtDRnD5fw4ZlVmEsVvTEm367iMBH/+73rv5NZ/O8bjhaU4hVxd
 frOHSwFv
 6c2QuME1WiCVgEZRVpqDmtqOzMdF9tTRQosCyr9Km2GeYyhphLPFWRegtblEdLchnmKFSM2m2SZCUfhB1OX7GkjL9zglzMUBWpW8dkvlGFBFL47aDtRS4GMNXpn8qOf4MWSgtB7XKDrezyCd1n1BKWsTm4tqSnsBAehty1oeQ8z0yvj3mKy+Ui+7zr+Q1+gyw3sfOb/b6vpXXru6V/SgtwNEvLdH7mvZDLIENH9XnaEKl2T2a5OhHHG8ROb06YANBQ/65KmrimJkbYAjL7cmrU5AVJwN8gyoxsqfZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Wed, May 27, 2026 at 04:45:16PM -0400, Johannes Weiner wrote:
[...]
>diff --git a/mm/memory.c b/mm/memory.c
>index 135f5c0f57bd..f22e61d8c8de 100644
>--- a/mm/memory.c
>+++ b/mm/memory.c
>@@ -5222,6 +5222,10 @@ static struct folio *alloc_anon_folio(struct vm_fault *vmf)
> 			folio_put(folio);
> 			goto next;
> 		}
>+		if (order > 1 && folio_memcg_alloc_deferred(folio)) {
>+			folio_put(folio);

Missing a MTHP_STAT_ANON_FAULT_FALLBACK bump here?

Since we jump straight to fallback and end up at order-0 :)

>+			goto fallback;
>+		}
> 		folio_throttle_swaprate(folio, gfp);
> 		/*
> 		 * When a folio is not zeroed during allocation
[...]

Cheers, Lance

