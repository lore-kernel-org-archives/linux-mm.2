Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CB590C44532
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 16:13:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 813A56B007B; Tue, 21 Jul 2026 12:13:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7C3E66B008A; Tue, 21 Jul 2026 12:13:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B2766B008C; Tue, 21 Jul 2026 12:13:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 44B896B007B
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 12:13:17 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id BBDF21C0110
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 16:13:16 +0000 (UTC)
X-FDA: 85013278392.25.AA6E009
Received: from lgeamrelo12.lge.com (lgeamrelo12.lge.com [156.147.23.52])
	by imf31.hostedemail.com (Postfix) with ESMTP id 9E4DE20008
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 16:13:13 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=none;
	spf=pass (imf31.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.23.52 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784650395;
	b=tUrt7CvyGEj2QOR0134qY9rAbNlR6q4NKEvFD9JfSPlNflfKa3Q3U1+TIBsq3h3PUanPQe
	V6v3NkBduy1IAwZYVb94VLovsOewouM1NohN7F/H63lAC/CMs2QKqLYgNHzFtLGFcdO86y
	Fyc4HnPdzOjZZLLkvwNySKlUp81z5qA=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=none;
	spf=pass (imf31.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.23.52 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784650395;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Im2LCtJAt3fUOoHKRg2yc+oApLbaNb8Ya7UVW6LfXwI=;
	b=j8c++0R2EL/yxcVq2SA/8R9Da5oHVu9a16mHGTQ6y9GNnVLQF0NjgasHKyJA2OEgtxRQtY
	jNZFvZENeV5nMRuZ9LuOaTSLvuhWrpXyIQP2sC7mJTBwRMmst7J/i0h1JBE3GoiTmeCO57
	77PQqhdEfTs3wzO3usl0/YZAQCYHi4w=
Received: from unknown (HELO lgemrelse6q.lge.com) (156.147.1.121)
	by 156.147.23.52 with ESMTP; 22 Jul 2026 01:13:10 +0900
X-Original-SENDERIP: 156.147.1.121
X-Original-MAILFROM: youngjun.park@lge.com
Received: from unknown (HELO yjaykim-PowerEdge-T330) (10.177.112.156)
	by 156.147.1.121 with ESMTP; 22 Jul 2026 01:13:09 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
Date: Wed, 22 Jul 2026 01:13:09 +0900
From: Youngjun Park <youngjun.park@lge.com>
To: Xueyuan Chen <xueyuan.chen21@gmail.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
	baohua@kernel.org, zhaonanzhe@xiaomi.com, hannes@cmpxchg.org,
	mhocko@kernel.org, roman.gushchin@linux.dev, shakeel.butt@linux.dev,
	muchun.song@linux.dev, chrisl@kernel.org, kasong@tencent.com,
	shikemeng@huaweicloud.com, nphamcs@gmail.com, bhe@redhat.com,
	david@kernel.org, ljs@kernel.org, liam@infradead.org,
	vbabka@kernel.org, rppt@kernel.org, surenb@google.com,
	qi.zheng@linux.dev, axelrasmussen@google.com, yuanchu@google.com,
	weixugc@google.com, baolin.wang@linux.alibaba.com, hughd@google.com
Subject: Re: [RFC PATCH v3 2/4] mm: distinguish large folio swap allocation
 failures
Message-ID: <al+alXxG/8XRCM3y@yjaykim-PowerEdge-T330>
References: <20260717122514.51514-1-xueyuan.chen21@gmail.com>
 <20260717122514.51514-3-xueyuan.chen21@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260717122514.51514-3-xueyuan.chen21@gmail.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 9E4DE20008
X-Stat-Signature: jcs6upozze5tuh83f467ftk3b7q835hz
X-Rspam-User: 
X-HE-Tag: 1784650393-901800
X-HE-Meta: U2FsdGVkX19WnFgQtqqiBIigWCPggFpmFERI5mO/nD2ztyrBLa/rVNkYC+J+VfMZiL5xajtY/MFi88e3Zcc4B93Pm/0ip6WcNzInooJJKJffq2J5APzI4O27FAkKThGQARFBbZEJyojpJuKYy/HLBN8+XZN2EQXQSCWPqBHqEOYvbzVpV8LIkXWj+AD2WR8Ajmxm/UvxIKYXNk28JacFaf37OJ/1GMTkCilyVH9dHgmlBb/4MBQHmIdfIoryMSln/Hx3HzRUu31vtWIttRDurVCKY5NwPQgx0CiVRyBo83rLX2kkUfYnG+YyW4MfkcMPS6v3eHhAhop4cPL+8z1jlbeRm1+CMv3oXaCHJsSlQOvtGwvtyIysb3v22VET6PhwqfroJ0KM5V/wvZ+Y3aspYCkq6xuoEbhr4xmliS8c5FDQy2zN6GQDFfuxpv4CgryhYoxHhSxNFjziSPRiptSVeqTgvqMq8/Fct3pofWgM2je6fVu5VHm10q/YRJT+3IQmdY6+sfs1MmXpnwsKjYvIORzN2JZYEcqxY9MhR4WTmKsm0RNQ+GdAyHYrdYA94xX6QfpVvc5zhvUYyGpdbutxUhgZE9DWzbnRG1G8Py4Ehy/j6mzc+uBO/P34zEjbYT5Zwk6dGz0pTVom0hTGu6DGe/Mu2FhOjFRLk9/cZquBMw7nBpmdccA10Im7wrYqZQMSwVlijVDI5ukI4SPfNERIAI2ok7kwKlovBD5VVnkUDFyxDWkKbpKSsvEv0rC6fso7XfK5/KMEDHOH5MThDL4tasOmK40EHKiC7GFD2pofB/17ZUGz58SAb0W7jytxgQ11nw2OQL8HSj7uB7cyZC4XgTHJzAwtn+ErdHjQDvCfF0P+lVPxNgz2dJKJV8xRooWBHRnOkzLiq64cD9VVorw2T0/EpJfMs8mRE25d/RkWM9c1lRMwetVJL6Lgova4rZ4ltLN4CyZ7XWSSOOcAkrr
 TCwfxrM1
 /EfWP8j4bucgzILnyl2pmTjH9HABBEc34HeJuuFSAuSJ4eyL7165ne9iirqMcXNdiGTRWbJHlXClp5+K3taktnrz8fuQqv2O1tHhmhTj5/BI9fHRHesB2efT6P7xOPKGFZHa3JL1U38ldZLZRjyoLLSDJXc+TMQfN3MtvJWRMIp5AWXE/94MYh63l/ggzOvY+/Innz4rGykhN+KiO54V3FzBJBzmEB0nSUgxT/2njUGGSaM+ldEFhCs0utMVV2m5wpzRA
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 17, 2026 at 08:25:12PM +0800, Xueyuan Chen wrote:
...
>  	local_lock(&percpu_swap_cluster.lock);
>  	if (!swap_alloc_fast(folio))
> @@ -1730,11 +1734,16 @@ int folio_alloc_swap(struct folio *folio)
>  	}
>  	/* Need to call this even if allocation failed, for MEMCG_SWAP_FAIL. */
> -	if (unlikely(mem_cgroup_try_charge_swap(folio, folio->swap)))
> +	if (unlikely(mem_cgroup_try_charge_swap(folio, folio->swap,
> +						&nr_swap_pages))) {
>  		swap_cache_del_folio(folio);

IMHO,
If we get here the allocation succeeded and only the charge failed, so
we already know global swap space exists.
(And also swap_cache_del_folio right above even puts the slots back, 
so nr_swap_pages goes up again)

Could we just take the margin and decide -E2BIG or -ENOMEM from that?

Youngjun

