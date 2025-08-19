Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16D71CA0EED
	for <linux-mm@archiver.kernel.org>; Tue, 19 Aug 2025 09:15:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A842E8E0024; Tue, 19 Aug 2025 05:15:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A35028E0002; Tue, 19 Aug 2025 05:15:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 924C78E0024; Tue, 19 Aug 2025 05:15:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7E2778E0002
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 05:15:21 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2E31E83CEA
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 09:15:21 +0000 (UTC)
X-FDA: 83792948442.09.DD6CEEA
Received: from fhigh-b3-smtp.messagingengine.com (fhigh-b3-smtp.messagingengine.com [202.12.124.154])
	by imf05.hostedemail.com (Postfix) with ESMTP id 28FC710000D
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 09:15:19 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="g IDVPsX";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=joa3cD8D;
	spf=pass (imf05.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.154 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755594919;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dgchzZYWazF9bA9Qn52CgjOynPGZcFtDF4chSUl865s=;
	b=5xnyquLb5A3FSAU6h+Q6On2XQUPXrqVR6+INwcrH2I5mDBq06OVEL1Gl89sJHNhyu5LSaj
	DBPPRCP9iXbJr34XbLiI0ONHmN1Jhlde3fon8GgQ2+LjqFt6Z6oMN2oXklLXPhBJbzKWrx
	S+rpDl70pEZXuT0dzCMkSwkGUyYB2fs=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="g IDVPsX";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=joa3cD8D;
	spf=pass (imf05.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.154 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755594919; a=rsa-sha256;
	cv=none;
	b=rAqeqVcUmehIy/NT1mfKmX+mXxUgotf6b39ZvWUnK+700vUizkFblxn5lex2EkJkPRfb7s
	JAqyIs7R0hfjuWS6Bh1u4aqNC0vKZJsB6s3RQ9fWLLxivUvJuhPrOPVEoGXnmVeTKEpB7v
	IoIbSMlmuT4mbZKNDbpkSMjd/sCaogA=
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfhigh.stl.internal (Postfix) with ESMTP id CA2897A0283;
	Tue, 19 Aug 2025 05:15:17 -0400 (EDT)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-06.internal (MEProxy); Tue, 19 Aug 2025 05:15:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1755594917; x=
	1755681317; bh=dgchzZYWazF9bA9Qn52CgjOynPGZcFtDF4chSUl865s=; b=g
	IDVPsX8nnuo+iurEbpVYwhbWa/H1TFhJ+sVs4d4JHnwCzY6H6nJGgVkDi5mcUqia
	d11i6PpNCYYcrV1K4QVQpRrRqcsun7m1LnYVGPeh5nGHZA+6Dwl3AtpR67HZLgqV
	EUS2t66QYqCRk9Xdf9OVAcsHA1Ov77Lvqz/87+lTDthHodo9TPRMmLrYAcrIMWKN
	qqdY/9qqcdAAZy4s66v/rPbcRplDbNEIj/fymYCZxABIvwZ59NaHupu8ljWs9DGz
	KmlGomFt3fzFkm5YFmzR9Ks0uyMBqpISm6+/SZX8ZgxPKGy+gyUJG18ggV91JBUA
	OdwWqlsRazXYBpypq+uhw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1755594917; x=1755681317; bh=dgchzZYWazF9bA9Qn52CgjOynPGZcFtDF4c
	hSUl865s=; b=joa3cD8Dt9gEW3M5zysw7Lc89OexCKunQ+G/jXuzP1GDr3kviNa
	4Q/U3ysayzCpw/kF8lDkgXdC6aaNlLEYSUZlvasJQVOSoXr6dDKi4OYkEwIReoFW
	hGtKa1UZSlmtM9/ncLBPxn8pYBF3CP19GpTNRJUxL4CM6+WGUa4XRoaluCJ2R22I
	/eSRYGRs1tne3t3VP+9UuRAerKE0ko1ya7wofTrRSZYweO9lD+CZ6kTowPDm5cmG
	b4A/pK2x95ExE88QJLdzK7UvFs9LrQ8ljwOpb6YkHGa2piUam2MGA6pHfwTeOXnZ
	ey6dvFDD5V0qkOsVfIRQW8AfXwMwKRt1NaA==
X-ME-Sender: <xms:pECkaCbIZh3fDJ0gogqRxojcCyoWjLTQer_PIES9LduTvUwGH2mifQ>
    <xme:pECkaBEsQGBBXD2UbGZzju2z3d4BgNhl_aUl4lAqA4xdpyKOmIqtOtX7LvxfRD1YS
    i3NZL6KzqkYbXRusp0>
X-ME-Received: <xmr:pECkaHpi3pwuD9Kc7PAzKM0_1wQmiIoUSTArWgwV3hVKoSKL_ePtaZGjMQqI>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdefgdduheehudduucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkfhggtggujgesthdtsfdttddtvdenucfhrhhomhepmfhirhihlhcu
    ufhhuhhtshgvmhgruhcuoehkihhrihhllhesshhhuhhtvghmohhvrdhnrghmvgeqnecugg
    ftrfgrthhtvghrnhepjeehueefuddvgfejkeeivdejvdegjefgfeeiteevfffhtddvtdel
    udfhfeefffdunecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrh
    homhepkhhirhhilhhlsehshhhuthgvmhhovhdrnhgrmhgvpdhnsggprhgtphhtthhopedv
    gedpmhhouggvpehsmhhtphhouhhtpdhrtghpthhtohepjhhoshhhuhgrrdhhrghhnhhjhi
    esghhmrghilhdrtghomhdprhgtphhtthhopehhrghnnhgvshestghmphigtghhghdrohhr
    ghdprhgtphhtthhopegtlhhmsehfsgdrtghomhdprhgtphhtthhopegrkhhpmheslhhinh
    hugidqfhhouhhnuggrthhiohhnrdhorhhgpdhrtghpthhtohepvhgsrggskhgrsehsuhhs
    vgdrtgiipdhrtghpthhtohepshhurhgvnhgssehgohhglhgvrdgtohhmpdhrtghpthhtoh
    epmhhhohgtkhhosehsuhhsvgdrtghomhdprhgtphhtthhopehjrggtkhhmrghnsgesghho
    ohhglhgvrdgtohhmpdhrtghpthhtohepiihihiesnhhvihguihgrrdgtohhm
X-ME-Proxy: <xmx:pECkaFnRy_k1BUFjyXLYFT6Ko9xfMd02hv5QZFvKfJjtSREh50UgrQ>
    <xmx:pECkaMtYp-5RQJ5tcyakOdcVcXqRMCiRAU6vzuctwVIFOuLHOIJmsg>
    <xmx:pECkaEdBB0564ee_gKFqhU1-i4VfJghTmmhUp5WGT2_FvxXxVKlXuQ>
    <xmx:pECkaObn-EvuSUMyxAhRt0Hm_4SmVnJjghRZwh-PpHtNz73s9knTbw>
    <xmx:pUCkaGaUG8N80olSqYgicV5NIk9jbsDuPQkrgdxuR0gj3iFjpsMgPzv2>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 19 Aug 2025 05:15:15 -0400 (EDT)
Date: Tue, 19 Aug 2025 10:15:13 +0100
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Chris Mason <clm@fb.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Vlastimil Babka <vbabka@suse.cz>, 
	Suren Baghdasaryan <surenb@gogle.com>, Michal Hocko <mhocko@suse.com>, 
	Brendan Jackman <jackmanb@google.com>, Zi Yan <ziy@nvidia.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH] mm/page_alloc: Occasionally relinquish zone lock in
 batch freeing
Message-ID: <k6fpx5adh45t4jrxgiccq7acubwcgmi746crggxi6e4oihtvpt@thks5zrn53n3>
References: <20250818185804.21044-1-joshua.hahnjy@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250818185804.21044-1-joshua.hahnjy@gmail.com>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 28FC710000D
X-Stat-Signature: r9ns1kfwdwbq553ao31z7ykngtna8eec
X-Rspam-User: 
X-HE-Tag: 1755594919-851618
X-HE-Meta: U2FsdGVkX195AcS6JedAfKbjbnPEWVTSsbVqtzcp+7AcYJnh5WLdOMiGKUqemQo9EitLvBroLe1T6CNB0smUsKfhXCsUghEsUqhZLbpFxZ7jp9USBeEMJNPxQHsrl9iiiApWDHOb4XzmXqSKa4D9Ki6ZKBuumBmbox7uD4fIu9ulojs9u/I2HVMmZDqvjrZytl9WKl0BrkKuu+BThGxix4mPRfTLbmfTT5wradwJKMdSKBXWQe0n2e5WIhXadbDgXj/FOlR3Welt5agQHVhGMaP/1Pv4Iy3IFd6B7f+SfuPsfAujs+nIFvWAl6bCcZAFdf6GkC+Q4W6DJ7tqqQsZWv2d+/2MTtN49I6TL9Dp0/OYBDpECxJr8wEfj1AU5axhi9wuoxHnpr4w7gdgWoIvSZMElU4G+IhyEgpFjT3H3JSiW1XzSsEQdS0XsxHhVnXzbNAsPU/kcZZzl9O2B4kzjg4O0JETKsPSxgoj64WvOMQSWjn5Fmyvz+ouE+Z4GoOYIdBbBXkSqsx0oeBj775VkFx8xsKu4xqvzyB/vzzxKBEDA7vnIpGj9hLi78J9kM+BsLqHs8vfSNo75WEm0cDlAjgxbLoL27u77/zPVrgO2nh4rGnD9I3HeCnO9bbp7p7wZrN4BraIIpZlBGJPfv+SfV6qF9w+Xsd7OU5ThRlDIWOTZwV86esQ5ZJkmGUd5YuTQ6UWAB3GhcdUBZ87e+kd46iIlq8UldFFtLovF4+FWTUhUWoDxH6ecmZ2ttcG9vHSZz19hWeoB18tflgtRN6WsH7bfD0yswz6ph1lQVG1BGOKTMh3CNltpIdcX7dKXK7gUfXos859FwMsvOgDWyTWtBseMUnWBiMpHdzUZ1CpQao36Va6Feqdeq0oOudIqBk9OGbAavoUAV1xku2dC7W4fjDJQ3uGx+83WXMq3zadlxbYXkbmqthpMmaWrSmCel/z39XDu1rSSMRra20eol8
 9qDjfqle
 aw0NhZYYL2mm6fCbFjTLxvy/3whwwDC6pSOgAGujxDm+jPK/2Yp6uWucbh6vVm3pqMJnwVb7rcjJp17WIHVOWFk4C6Rd5QA3OiFK3M5H1K7Q02WWeqAlK9KRU3b7AwZMJ4HZ10KAn507WzJI6SLBuuQjAK+Szhy0erIGUGeroQr1rGyiawRAiV6Bu2NtAPaXPQ3tP664EFA33jButVRIvaeM1LwhNfxDRIgCPXDt5pV0FOZU2ANbhf6bC5TFCV0YDYz57+JbDBOBMy1F16kEyGDFoi2GFoKR6MJaBTf1rWNR13kqbNSd+Ra/VDLrSWnoax8SoBasjvvMqJSUCmh87USWS+sx18pQrXUpG3MmII1UfsHcihlIz2JM9h3pMhH5aLcwSiQ5sbMcDMz+qKf3axyeFWJcdIDOU7ZPu3gbzp6ijhDN/EMjxAJE3BvAQbuVtK4o3RZpHWDYRwsFaICuEEaeH6NPdoasaSyVIYaHJMuwiUM/IkaUnvuEzpMvfvxrXvVnOpG+S2SigimGReWsuoxhpm/fBwSXtA08LUz/YwuT0IRmBv6yhFLZJxNgnQvR0jDjGw0WThEDYHVVZtKKyvJqlNw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 18, 2025 at 11:58:03AM -0700, Joshua Hahn wrote:
> While testing workloads with high sustained memory pressure on large machines
> (1TB memory, 316 CPUs), we saw an unexpectedly high number of softlockups.
> Further investigation showed that the lock in free_pcppages_bulk was being held
> for a long time, even being held while 2k+ pages were being freed.
> 
> Instead of holding the lock for the entirety of the freeing, check to see if
> the zone lock is contended every pcp->batch pages. If there is contention,
> relinquish the lock so that other processors have a change to grab the lock
> and perform critical work.

Hm. It doesn't necessary to be contention on the lock, but just that you
holding the lock for too long so the CPU is not available for the scheduler.

> In our fleet, we have seen that performing batched lock freeing has led to
> significantly lower rates of softlockups, while incurring relatively small
> regressions (relative to the workload and relative to the variation).
> 
> The following are a few synthetic benchmarks:
> 
> Test 1: Small machine (30G RAM, 36 CPUs)
> 
> stress-ng --vm 30 --vm-bytes 1G -M -t 100
> +----------------------+---------------+-----------+
> |        Metric        | Variation (%) | Delta (%) |
> +----------------------+---------------+-----------+
> | bogo ops             |        0.0076 |   -0.0183 |
> | bogo ops/s (real)    |        0.0064 |   -0.0207 |
> | bogo ops/s (usr+sys) |        0.3151 |   +0.4141 |
> +----------------------+---------------+-----------+
> 
> stress-ng --vm 20 --vm-bytes 3G -M -t 100
> +----------------------+---------------+-----------+
> |        Metric        | Variation (%) | Delta (%) |
> +----------------------+---------------+-----------+
> | bogo ops             |        0.0295 |   -0.0078 |
> | bogo ops/s (real)    |        0.0267 |   -0.0177 |
> | bogo ops/s (usr+sys) |        1.7079 |   -0.0096 |
> +----------------------+---------------+-----------+
> 
> Test 2: Big machine (250G RAM, 176 CPUs)
> 
> stress-ng --vm 50 --vm-bytes 5G -M -t 100
> +----------------------+---------------+-----------+
> |        Metric        | Variation (%) | Delta (%) |
> +----------------------+---------------+-----------+
> | bogo ops             |        0.0362 |   -0.0187 |
> | bogo ops/s (real)    |        0.0391 |   -0.0220 |
> | bogo ops/s (usr+sys) |        2.9603 |   +1.3758 |
> +----------------------+---------------+-----------+
> 
> stress-ng --vm 10 --vm-bytes 30G -M -t 100
> +----------------------+---------------+-----------+
> |        Metric        | Variation (%) | Delta (%) |
> +----------------------+---------------+-----------+
> | bogo ops             |        2.3130 |   -0.0754 |
> | bogo ops/s (real)    |        3.3069 |   -0.8579 |
> | bogo ops/s (usr+sys) |        4.0369 |   -1.1985 |
> +----------------------+---------------+-----------+
> 
> Suggested-by: Chris Mason <clm@fb.com>
> Co-developed-by: Johannes Weiner <hannes@cmpxchg.org>
> Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
> 
> ---
>  mm/page_alloc.c | 15 ++++++++++++++-
>  1 file changed, 14 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index a8a84c3b5fe5..bd7a8da3e159 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -1238,6 +1238,8 @@ static void free_pcppages_bulk(struct zone *zone, int count,
>  	 * below while (list_empty(list)) loop.
>  	 */
>  	count = min(pcp->count, count);
> +	if (!count)
> +		return;
>  
>  	/* Ensure requested pindex is drained first. */
>  	pindex = pindex - 1;
> @@ -1247,6 +1249,7 @@ static void free_pcppages_bulk(struct zone *zone, int count,
>  	while (count > 0) {
>  		struct list_head *list;
>  		int nr_pages;
> +		int batch = min(count, pcp->batch);
>  
>  		/* Remove pages from lists in a round-robin fashion. */
>  		do {
> @@ -1267,12 +1270,22 @@ static void free_pcppages_bulk(struct zone *zone, int count,
>  
>  			/* must delete to avoid corrupting pcp list */
>  			list_del(&page->pcp_list);
> +			batch -= nr_pages;
>  			count -= nr_pages;
>  			pcp->count -= nr_pages;
>  
>  			__free_one_page(page, pfn, zone, order, mt, FPI_NONE);
>  			trace_mm_page_pcpu_drain(page, order, mt);
> -		} while (count > 0 && !list_empty(list));
> +		} while (batch > 0 && !list_empty(list));
> +
> +		/*
> +		 * Prevent starving the lock for other users; every pcp->batch
> +		 * pages freed, relinquish the zone lock if it is contended.
> +		 */
> +		if (count && spin_is_contended(&zone->lock)) {

I would rather drop the count thing and do something like this:

		if (need_resched() || spin_needbreak(&zone->lock) {
			spin_unlock_irqrestore(&zone->lock, flags);
			cond_resched();
			spin_lock_irqsave(&zone->lock, flags);
		}

> +			spin_unlock_irqrestore(&zone->lock, flags);
> +			spin_lock_irqsave(&zone->lock, flags);
> +		}
>  	}
>  
>  	spin_unlock_irqrestore(&zone->lock, flags);
> 
> base-commit: 137a6423b60fe0785aada403679d3b086bb83062
> -- 
> 2.47.3

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

