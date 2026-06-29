Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A6185C43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 14:28:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 390566B00D2; Mon, 29 Jun 2026 10:28:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 319B26B00D3; Mon, 29 Jun 2026 10:28:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E12A6B00D6; Mon, 29 Jun 2026 10:28:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CE8FE6B00D2
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 10:28:38 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3F8801A014C
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 14:28:38 +0000 (UTC)
X-FDA: 84933181116.18.E3BA4E2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 6CF2D4000D
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 14:28:36 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=klYh+h+N;
	spf=pass (imf17.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782743316;
	b=6xpgPgQe3/pnjrWN/LcfOSik9RSexMlrD9UFznwcf1s4l6sTiqO0A9P13Zjaj8E+jwv5Og
	/vhbo2Sy37gvsU4QC5/i7AlrFRKAQNCRfHBxBByvXvREowSdLYcGSSN4TVCWWmz0ARh3zF
	Eo2b3GPjGisS+YjtlHih5uOevMaSFzc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782743316;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8JC0C0FVVaFQrsOmwXSu62JfKtEg4PNYqhPkdJ82cpY=;
	b=tbWmxXj8U3Nk8X2sqIdGrFJ3USj0Ys+FRTj9BABLfi5yrEG2zN1xva1kcAsFDvCKKHqxYb
	HsVSnAQky9jdx6rxZfTVt4ACBQbjll2NNOsNX1YOTtoywDWJIhY8GhFTIxdlNZsZ9do76B
	DCA1WINsSHwpR0XtVCUXWmrklMU6baM=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=klYh+h+N;
	spf=pass (imf17.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C25F46001D;
	Mon, 29 Jun 2026 14:28:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA1BE1F000E9;
	Mon, 29 Jun 2026 14:28:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782743315;
	bh=8JC0C0FVVaFQrsOmwXSu62JfKtEg4PNYqhPkdJ82cpY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=klYh+h+NCjpwB6o0nF2PE9VU7HROot7A/l/tv/vAa5i3AYwqhTAGp0lNFXv5ZnOls
	 /24b2uxy4GIOG146+tDnU4pb6yZrqHKsVaiHla6LTVnjYhwPAoF1pKIIRR7x/wmnyt
	 B9zGe02inWeG4xYGPgW0WbcIhm4zI4adsYmgUCqSs/40q8Xzl59W0RcYqVcPQo2Rvj
	 /8K9mq25xFhAw0q2W3h3tqH9nO4E3ThAajOiOV1OOJHN85LW0i9qNmXpGo7XtTtGYe
	 wHUbLcOD5rU5K1ewfN8O93ocsV+AU+43m//1LLmYPjumQlycrT2mCGcmIfPzSEb6Qj
	 GcykTGdQkOUPA==
Message-ID: <220774cb-ba5b-4a12-a649-955c83bfc704@kernel.org>
Date: Mon, 29 Jun 2026 16:28:30 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/4] mm/compaction: stop recording free page order in
 page->private
Content-Language: en-US
To: Zi Yan <ziy@nvidia.com>, Andrew Morton <akpm@linux-foundation.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Mike Rapoport <rppt@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260628-keep-subpage-private-zero-at-free-v1-0-f4ce3930d10f@nvidia.com>
 <20260628-keep-subpage-private-zero-at-free-v1-1-f4ce3930d10f@nvidia.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20260628-keep-subpage-private-zero-at-free-v1-1-f4ce3930d10f@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 6CF2D4000D
X-Stat-Signature: c4k68w9epw87ocbb484i3ftkkzb3h8r7
X-HE-Tag: 1782743316-581934
X-HE-Meta: U2FsdGVkX1+/UkU0G7Zj+sL7lz6rDMFM9W1P/jahsUmLJPt/3O9h+kXLrtvZu7czNGMWkqXaTo+DeBa96/heg9qrUZWjn879DSelSvdSA76OFuVxRtBeoI7k5m7DUgAamGGwP6+b1D8ohk2loRIGV8DXwdrEbzkVC7u4l3trQvyB1NJPJu28r6RIqvIQpnYWOoQP2PNKVZHN3aLYiN8IomF6nhhm1Enp+oGXresFEcE6Kl1oOdPSPitYtJwpKfV+UCso5pKXayDMIwPafp8tYLulE8/DbMSBQMNuU3Iuq6d9pCRqr6TJCzLxtQWAP7oLH7q0LBFr5czSOfVIpw6MIP57qcTRjsFFHFRUNH2ijr01PGk7dQ/dAqVSF9bYJpPPioRLD1dxJvkwAxNO1eNkgOoZQ/dbqICftbBJngmfW/FQOZKnAnIfM+RktYWN6VHZpksu1x9ZOcJd67TeZwhPcQ2iVPx9K7+CkpvluwA7bFDB8+H2lhvlymNxCBLqF3CEOu7ApoMfA3wDID/+E6GvV67eh9n36qYmcCBl8QTQW9KwcFHiUouTFuU3ebLKd632MbL5HDue9lxWXEDqru+g/157PISEGiWSBpkDcMUvvvpWStN06NbxP/+Fe3eommJPYkV1STlGQCellxXfkON/oeybn8CK2egto5CyaKHZmSIjZgjF35ilcCZavA8wF64D/iKXJ/Jhyk9YpNM/kD5BJuftMV2Bk1Wf8lw6JVJRnkb5lhVhtC8mGi5JEckqU4UZ5Y0l+T05rkOkRq/ZIw0grfNTJP+bUkJmuwcR9pyvOtyz2wZs5Wf2D+pKeVyqZZrZ/qd5avTLdkrx/4uTx3jOjs6HOvNjcbWnTAbU22i/duhnndJIBTBhgOUh5gnTFYoSuubo7p3mqrCRwqHVMEuFhwjIVyHO/zr0DePmYeJjjBSoHBHBPdcKqoqZQ+vAxfeciNc8xDtn1wYRGe1935+
 +3ehBWbx
 L5i6szU7OeYECmlGuZDcsa64saNXjdLy2R0wLXaj0fVcOKR77Wx4e8FoWHifAZjjxe+43WtDHqJJKAETB4DQ0bL2F2v6xTrjBfNY+xCZFiJaOtckA120kTeQJaaONUgBIzJuy0ti2GqV1RgDa1GZxwzcX5BQWRGg5UcbVIduA5kVEf73go9Cjyo6pzcqdqENeuRxCW1SF17s0+Ck7Zt8+B4ha07QLCiGkIUXRSN3I1VyOv+8A1GHJUA4O74DoD1Pwj9H7E7SGPSFOjgU3eRqAw6RPpV5OjFWLkdpX3+OJ0g9DQ+omdju6ukc08w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/29/26 04:56, Zi Yan wrote:
> Commit 733aea0b3a7bb ("mm/compaction: add support for >0 order folio
> memory compaction.") stores isolated free pages in an array indexed by free
> page orders, it is no longer needed to store the order in each page's
> ->private field. And there is no code using the stored order. Stop doing
> that.

Ah, great observation. Cool.

> It also prepares for an upcoming change that ensures subpage->private is
> zero at page free time and the removal of set_page_private(0) from
> prep_compound_tail(). In alloc_contig_frozen_range_noprof(),
> isolate_freepages_range() is used to grab free pages from buddy allocator
> and it leaves the aforementioned page->private set until
> either split_free_frozen_pages() or prep_new_page() is called. That
> triggers the upcoming subpage->private nonzero check along once
> set_page_private(0) is removed from prep_compound_tail(), which is called
> via prep_new_page().

I'm not sure it needs to be said here (or in such detail?)

> Signed-off-by: Zi Yan <ziy@nvidia.com>

Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

> ---
>  mm/compaction.c | 3 ---
>  1 file changed, 3 deletions(-)
> 
> diff --git a/mm/compaction.c b/mm/compaction.c
> index b776f35ad020..349838cc6c19 100644
> --- a/mm/compaction.c
> +++ b/mm/compaction.c
> @@ -644,7 +644,6 @@ static unsigned long isolate_freepages_block(struct compact_control *cc,
>  		isolated = __isolate_free_page(page, order);
>  		if (!isolated)
>  			break;
> -		set_page_private(page, order);
>  
>  		nr_scanned += isolated - 1;
>  		total_isolated += isolated;
> @@ -1617,7 +1616,6 @@ static void fast_isolate_freepages(struct compact_control *cc)
>  		/* Isolate the page if available */
>  		if (page) {
>  			if (__isolate_free_page(page, order)) {
> -				set_page_private(page, order);
>  				nr_isolated = 1 << order;
>  				nr_scanned += nr_isolated - 1;
>  				total_isolated += nr_isolated;
> @@ -1846,7 +1844,6 @@ static struct folio *compaction_alloc_noprof(struct folio *src, unsigned long da
>  		size >>= 1;
>  
>  		list_add(&freepage[size].lru, &cc->freepages[start_order]);
> -		set_page_private(&freepage[size], start_order);
>  	}
>  	dst = (struct folio *)freepage;
>  
> 


