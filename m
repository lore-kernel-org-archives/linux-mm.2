Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B4515FCB61D
	for <linux-mm@archiver.kernel.org>; Fri,  6 Mar 2026 16:08:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 25BE26B00AF; Fri,  6 Mar 2026 11:08:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 20F176B00B0; Fri,  6 Mar 2026 11:08:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 13BF16B00B1; Fri,  6 Mar 2026 11:08:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 001C26B00AF
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 11:08:17 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C5A7159B51
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 16:08:17 +0000 (UTC)
X-FDA: 84516120234.27.C5BB642
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf16.hostedemail.com (Postfix) with ESMTP id 70881180014
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 16:08:15 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=v4nZCreM;
	spf=none (imf16.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772813296;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9FEKyNDmEGt3OP13htzSGm2IuEkl/IqkUvpE3rhlHoY=;
	b=c56F6z4it3WMzSOD8oUJiLh9k+tJ89WfVvCzF+8G5c4r+8lQEOOSLqBIAF7foNmLSDa5vT
	ptLLh1Nl9T86WJSq+VS8Z2aKRux6rOJe9SUuxipL20aU+Bo4pdn8tj/8VT5+7Ebvlxt4xt
	cRxWiU1EW+/t5MfDEZupu5CK9QYDIuI=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=v4nZCreM;
	spf=none (imf16.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772813296; a=rsa-sha256;
	cv=none;
	b=toMp2wEToXIRhklBGj+HsTK117+fUZ66mc1jG/mJ1JKxLE1QChnMzD+J5Wqx46rknxEnA5
	3fvL43IgoEiUPzGyPiQN7Pr82Kw9SAHewmgDHQOxdEpabseEyWN6OuYOwkwoUjfQQN8R/5
	PVciyXD7u5z4NuzBwp2EayA4VB8s/Gc=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=9FEKyNDmEGt3OP13htzSGm2IuEkl/IqkUvpE3rhlHoY=; b=v4nZCreMicroY6XbV83cl2mlbS
	rLyy4FwfvrZ/WNNf2DqqXCBEIzz19hgJooqBXqAPMInVeeeMN6Xamqb2kuFMQRrqL1UH/8vhQD0zQ
	ltl0eUgugkV7cBEeRtZLUj+sIQg+KglPaj3vyrfWvP8epnVXHMz5ELuR4g1kDA6gNG+4sjNA5Sxwx
	7GEpArVAQKojBI6RiTvBkpW6gE2NTINNTNA+JeRxqTFIEB/PMAhewst2EYMxUrlIlWneMNGPghJ3a
	nu6EgaCjWXBQ3/7vLTjy5WVh7hTiJAe2XTH8ZMkevtrwxfpJjj6U5cizu9tkluJ3L9RttAx59uHzO
	5BL8gwOw==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vyXid-0000000Gxx9-2zeM;
	Fri, 06 Mar 2026 16:08:03 +0000
Date: Fri, 6 Mar 2026 16:08:03 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Usama Arif <usama.arif@linux.dev>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>, npache@redhat.com,
	ziy@nvidia.com, linux-mm@kvack.org, matthew.brost@intel.com,
	joshua.hahnjy@gmail.com, hannes@cmpxchg.org, rakie.kim@sk.com,
	byungchul@sk.com, gourry@gourry.net, ying.huang@linux.alibaba.com,
	apopple@nvidia.com, linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: Re: [PATCH] mm: migrate: requeue destination folio on deferred split
 queue
Message-ID: <aar740E8K7SOy1qJ@casper.infradead.org>
References: <20260306133556.2051251-1-usama.arif@linux.dev>
 <ab22e50d-3af0-4acd-9d7a-a0e86d0c4fbe@kernel.org>
 <64051a59-680f-40ae-b291-b884aeb7c77b@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <64051a59-680f-40ae-b291-b884aeb7c77b@linux.dev>
X-Rspamd-Queue-Id: 70881180014
X-Stat-Signature: 7w8tsk9gfcgcdtpyt17idfyxbb6dqarp
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1772813295-134711
X-HE-Meta: U2FsdGVkX18tN0zjpFqVxRjF7gry5nY7Ew2sY1HmChE5fPrMvtIdaevEjUBpbsLRwz/DF1+vLBmrhfNtCBQDzqKmyQBz3vBWXi1WgHaPX2618tAQrFkQaobNFUYLqj052UvxFvYFb11gzi/r87vpoDJ5QjUd73vZkhY6D49RHtWW/1nl5G1YJLzk0NpWnJkUM7RRDobigS78nEDMjqDAHHdM8gUu08Jlpf4q1XUQxQlj4x8iEqh2aCs2pUWmC6f+AS9sauZxMzoQh0lBGL/XRMH3QRzr9fnxeYmjZApTBRSVmAydhuLt+Z25bf95bwdXbN1iK3Vpoq2QP+4LCATsulXs91gn1WC7DGib2XxC4LZP3jGZEOdPxS0BUVRJriHmoVOHsUiYLCdZcaj4IQfzOVNMfLypP5JLsbWPoJLmhVb3Xnp9iBLxyrDxhv3Pjnp+fBtfPKe0XeBDahJNXjscuKpM/O4sIxzIbWnkZUEplDQc4rIHgSSHqD6/nlwia4lnmolmqlONn3esupo9R+XZgGuQmhA3PJ4YBl2L4pLzuqmPdCR+wTE7+82Z9CHehyJt15dpDWGfnwK8euAYN9VNcUWElMi0BlLgMb9x9BoYh98Ec4yreEYNydc1ARw5cSueGejATP0q9TBPjvDQhFrM73AmlVqjBxgCTH2pJhFJaygF5o/NBefKsmRyRLwjZStZ2fQP7311fTpBiFPsFXiNgcYkrqIL2p40IHW3/lPLQ1UDGm5jEJQOGkc6yK9Tq5l1Gwc70S0i9ChIX09h1KGULGy18j1t1WFbUFG/naEqPcejKUzVBkqF3BXaq72q6N1SQqC05qEY+TLB3nspp+l0Ku3jFeOkRwTyKFDXgQkBHHEHLVHlV/nscij7YmZWibDrLJ/CLRLuJ1OIHqsdzuJc7HFpJHY3jiyl52D31hGhgLKrY9t5CbzAw+FugkMUGLAsWJD29dtTDVGiqDdqIaP
 QNH3+CBn
 ln6wZ+CF2MKfZmpjMlWoBO9NTD8zN2OGlY4FnbUeFxDmVBAbN14KV2zBlk4IJwU3HvvL+fr9OC7mah/s1KMOgAy9oGyKNp+bQcf4SlnAcdBLnY4i/BtDQ6N0yU0tiY/xXjcpXFedzrewCvO+/ZIPUgBgMOCkGfcjdVbDhkIv/TdTVCZ+oihNu5dSSMMxA7a7xfm6yGMTGLKZnqwiHLrrzcWMEGLKgQxYzaLmkS04Qr38bEXbSF7FJwxx1sYeOj2AyuDcH3G8W6b54UjZ9MH9yp0JI2L3ZP8+vPd5FY+fmLFPsLDSbUNKqN/QtgSyVebR1pNlY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 06, 2026 at 05:12:38PM +0300, Usama Arif wrote:
> +       /*
> +        * Record whether the source folio is on the deferred split queue
> +        * before move_to_new_folio(), which unqueues it via
> +        * __folio_migrate_mapping().
> +        */
> +       if (folio_test_large(src) && folio_test_large_rmappable(src) &&
> +           !data_race(list_empty(&src->_deferred_list)))

Why do you need data_race() here?  list_empty() contains a READ_ONCE()
so shouldn't be necessary?

> +               old_page_state |= PAGE_WAS_ON_DEFERRED_SPLIT;

You've done a great job of the naming.  So much so that the comment
seems entirely unnecessary?

> +       /*
> +        * Requeue the destination folio on the deferred split queue if
> +        * the source was on the queue.  The source is unqueued in
> +        * __folio_migrate_mapping(), so we record and check the state
> +        * from before move_to_new_folio().
> +        */
> +       if (old_page_state & PAGE_WAS_ON_DEFERRED_SPLIT)
> +               deferred_split_folio(dst, false);

Again, I'm not sure the comment says anything that the code doesn't?

