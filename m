Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0022ED73EA9
	for <linux-mm@archiver.kernel.org>; Fri, 30 Jan 2026 00:48:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 26B1B6B0005; Thu, 29 Jan 2026 19:48:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 235DE6B0088; Thu, 29 Jan 2026 19:48:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 16CAF6B0089; Thu, 29 Jan 2026 19:48:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 061866B0005
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 19:48:21 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9E6D5C1C44
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 00:48:20 +0000 (UTC)
X-FDA: 84386793960.23.5A3A36F
Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	by imf21.hostedemail.com (Postfix) with ESMTP id AFB391C000D
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 00:48:18 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=NfitKoMr;
	spf=pass (imf21.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.180 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769734099;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3A7pdALAafDL6kVov9I53Tgt62PET1/OP4Y8CWDvMKY=;
	b=7EIEGzFDRhg9r9Fw/C+1y1nJqIHSAC6KQ6aOjZhtBvLsraxe2UM/Z73dUF/os8IyHukFtL
	yTfxw0+Dngyeda+kp9uOpYW2uPKumIWgSJOFQEYQI9n/HHMmsWcOPHz3YRwzr5U9JIJ0O7
	0ZmwjMTfzr9Gh4zA2J8hsNMUGlt//EQ=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=NfitKoMr;
	spf=pass (imf21.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.180 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769734099; a=rsa-sha256;
	cv=none;
	b=iDQBKGLO8BldDmaHqGA9X55jUx1A+HLLMZWlmSv1ksrxLiPDv1OYY3PZ5F94QVFHasLgdY
	e+k2/lSt/uGvNk09SA6wNPZQSvDHioRR7AVLNzvfM41qyehz/OvcXw+6oYWTZS4w67TmlP
	U0b/AjV8O1nCUcGZGuumoifTXVQIjqs=
Date: Thu, 29 Jan 2026 16:47:52 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1769734094;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=3A7pdALAafDL6kVov9I53Tgt62PET1/OP4Y8CWDvMKY=;
	b=NfitKoMrfWHJEnK3FhKbb+oShyVAZTBfjwr8XLV9TIyZokJxCNMF4keXeuZcm+Q1s3ZApR
	e0DX89ObAsutfv9yR9T+itV6cEKczkWp7+oz69T01XjFU4hWx10VmRx2m9MHnEtzVaek3r
	ZdzYZNot83emT4Xfld8CCUaVEqEFJBo=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Matthew Wilcox <willy@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Rik van Riel <riel@surriel.com>, 
	Song Liu <songliubraving@fb.com>, Kiryl Shutsemau <kas@kernel.org>, 
	Usama Arif <usamaarif642@gmail.com>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R . Howlett" <Liam.Howlett@oracle.com>, 
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Meta kernel team <kernel-team@meta.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: khugepaged: fix NR_FILE_PAGES accounting in
 collapse_file()
Message-ID: <aXv_HI8JM9mZCr4-@linux.dev>
References: <20260129184054.910897-1-shakeel.butt@linux.dev>
 <aXvjdArhPpUNF8BI@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aXvjdArhPpUNF8BI@casper.infradead.org>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: AFB391C000D
X-Stat-Signature: xhr51pcnewy7caywko8ohcn9tnd6z8aq
X-Rspam-User: 
X-HE-Tag: 1769734098-275401
X-HE-Meta: U2FsdGVkX18UyGlkxQpq+VeehtDS3YxVNmUwc1Axu50X5nbvPBwYtacZcmU5jIi6RB3OXMOiuLoBczrlIdSJyRMIo2X8+pXVjBhlQ224uvBtdFSkMZGXOKrXst/27lFeVIjTKMtW3jGm0JiWh/CanL9m6xzE9wil4RrlIXHmZLODEIaotFZh8arHkqj1oob1jrC+NZ1zATpUGlVBm2Bzo20CczXn5tZ+VOWz30tlE6mW8ly7sOLMQxobszkmgB9Bst9xi7B6oOLo6ML0JQt4+2o6cXCZpBc5uzsviGXmfyIn6COpSjQVjNxoKv2aeTo8lj0aVIPUffr5IDrfDD8WK6rurULOQzj+BCwNDTkgh0/sHDoi5lsNe5+dmqKzxqtGZ6TlMAOLD4gYe5WPts9ezbloV/+5Utfh//Bkbuc0vMd/JEnREzSJKxDAoFQtMzTSmPRdR0bmEJvVggZloBew1S2KVQrXY8gvRg7T+e0vT0dLXtaAoAMqpXptt7fbXg1bpFqJAjDiwsYpF6b9Vgl56noBH5f+4BwXNUhs2XavfZ0oIq75qsjWxXLRB3e/Mzl1jCkEgofv9uP27lC09eUydZR7d8w+CZiDkJwjpjh7uTTV04PfjdtFpG+W4qiKWvOKcSxLfbMygrDpypm+rIQfp+ox+71aVPDyMtWEhK8shVl5O3q9VwNIuLgqoBOlM2m7uaIGN15uIyUYY4AWEEec7sHnQDEJFqFCqlDXNlT22EDKlKJYnGebpfte6www5KZgNyweP2PmCKiFv/ukj9hwUnwGZYCLA0hTJrINMPhGyC//TjOuBxbT9OxzIXibMsV/6FLpqq9L0q2xXkYNM6jEKx0O9cDv8ynL+O+Y9oaERAFlVs9HNJIoQCxMhdblihCYQ9lb90EDRhhSEVh/CGuvfJ9NwQtr5aIZZNAZsvnZW8rmnXF49UiXATth6jDjcHTU/30PHr6HA2rxAQnKHFi
 mPkw+ONq
 BAmcrcj20Z2k1X3eAoVuutlIpGlckuRpwGYZRD2kzuk3hhfYZn2n58BuLWQFeL90YmfYkFM+UFWG7JzRWcuwjIgON+iwMmkovO9O2grUUlfpBGD4PHvgAcUSoG3wb1LEJec39cM0hb+yPgu8FR60JoXAaPqoOhgfbOFvvZP9tBfu1awVQqHhaOYrj16FFk16lflHIF5ZsRfFKDcJO9XNkKskkXjVv7aId+4nHJo1wXuPjHQ5i1OTg3e4Ef9Fq1CuzySxO
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jan 29, 2026 at 10:47:16PM +0000, Matthew Wilcox wrote:
> On Thu, Jan 29, 2026 at 10:40:54AM -0800, Shakeel Butt wrote:
> > Fixes: 99cb0dbd47a1 ("mm,thp: add read-only THP support for (non-shmem) FS")
> 
> Are you sure this is the right Fixes?  99cb0dbd47a1 wasn't cgroup
> aware:
> 
>         if (nr_none) {
>                 struct zone *zone = page_zone(new_page);
> 
>                 __mod_node_page_state(zone->zone_pgdat, NR_FILE_PAGES, nr_none);
> -               __mod_node_page_state(zone->zone_pgdat, NR_SHMEM, nr_none);
> +               if (is_shmem)
> +                       __mod_node_page_state(zone->zone_pgdat,
> +                                             NR_SHMEM, nr_none);
>         }
> 
> b8eddff8886b added cgroup support:
> 
>         if (is_shmem)
> -               __inc_node_page_state(new_page, NR_SHMEM_THPS);
> +               __inc_lruvec_page_state(new_page, NR_SHMEM_THPS);
>         else {
> -               __inc_node_page_state(new_page, NR_FILE_THPS);
> +               __inc_lruvec_page_state(new_page, NR_FILE_THPS);
>                 filemap_nr_thps_inc(mapping);
>         }
> 
> which would seem like the right Fixes: to me?
> 

b8eddff8886b is about different stats NR_SHMEM_THPS & NR_FILE_THPS.
However as Johannes responded this code was broken even before memcg
awareness for NR_FILE_PAGES and NR_SHMEM.

I will send v2 with correct handling of NR_SHMEM as well.


