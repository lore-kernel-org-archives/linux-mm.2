Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 253CBCD98CC
	for <linux-mm@archiver.kernel.org>; Fri, 12 Jun 2026 04:52:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 441B76B00AA; Fri, 12 Jun 2026 00:52:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3F8266B00AC; Fri, 12 Jun 2026 00:52:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3088D6B00AD; Fri, 12 Jun 2026 00:52:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1F91A6B00AA
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 00:52:23 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A3F5C4098C
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 04:52:22 +0000 (UTC)
X-FDA: 84870039324.28.D40FC9C
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf08.hostedemail.com (Postfix) with ESMTP id 74D3E16000B
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 04:52:20 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="Hzo/2U9i";
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf08.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781239941;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=N6jDQipfklx8sT9vuAFUiLeqya7GBesDua+a98Rir/4=;
	b=io3roT7mwBthSMttYfrql22H3DjFZET3d7IJsIKlQ+P3Hz7InH7zKn2WcPL50x6JJPBKlJ
	kiT/+mTbS8uiVkVqSvPSjhgYXUxHjuokTiudACs2WZqj+2dMBwX0LkGovLHQkDrhHmIP6h
	mWnScCKQD3EzJ30rXGbnH33k7/X85No=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="Hzo/2U9i";
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf08.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781239941;
	b=cO4CROUDbSmVC/PRyGqMf6kWpUCfhtCBuuWV3IH86LDTOkDwO1OGmztMW12uMuSBUK39Sv
	6SipdwnU1uDY/hGA62mybkhKUA7/saR5dwylEoLwb428myZ54/sfLWIqJUpsVB6yg/DpcU
	L7Y4ra13SWLlfsHy/LcXshVb5HuasHU=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=N6jDQipfklx8sT9vuAFUiLeqya7GBesDua+a98Rir/4=; b=Hzo/2U9iqHtAMuL4j25AVlPO+T
	n9gUg1uIzvHpoJoRj8dL06imfPuzi7DzFLZEFX+78LmSdhgT0h5QyTaS59Wp76UKwJdZMy8jKi3xr
	pyfkg+0IJhm3jeWi3VcMPb9mLDrv3lrRYfcFottGU1x+u6AO1Ar9kLmr2EDBjopiYRPxd7vrS86i0
	A53emHdz1ZhB36ec5Rh+myxevklERHhgIH+orUlNUHrqpf03+26AYn+xKX6pb6JbkQAnxv3fKhq7D
	TlXuFR/AiZNTL0jpG1JPheFZ3lcLSIe7C67Ov84vSIwOn2keZkgle5UC2Id6lAdpaupzcZN7InWvs
	XPzOhFbw==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wXtsN-000000038tu-12nq;
	Fri, 12 Jun 2026 04:52:15 +0000
Date: Fri, 12 Jun 2026 05:52:15 +0100
From: Matthew Wilcox <willy@infradead.org>
To: David Carlier <devnexen@gmail.com>
Cc: akpm@linux-foundation.org,
	syzbot+fd95a72470f5a44e464c@syzkaller.appspotmail.com,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Kevin Tian <kevin.tian@intel.com>,
	Jason Gunthorpe <jgg@ziepe.ca>, Lu Baolu <baolu.lu@linux.intel.com>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: pgtable: protect lockless kernel page table walks
 with RCU
Message-ID: <aiuQf99mqhQRVzC8@casper.infradead.org>
References: <20260612043828.23558-1-devnexen@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260612043828.23558-1-devnexen@gmail.com>
X-Rspamd-Queue-Id: 74D3E16000B
X-Rspam-User: 
X-Stat-Signature: t7f1sa4g3oawuw71czajpmpx9eeu9mxs
X-Rspamd-Server: rspam09
X-HE-Tag: 1781239940-975022
X-HE-Meta: U2FsdGVkX19086c7m+BZKk5r1LMRhYnN4iWRmCbV1kS+6kwlKDK/upcfyVfXP2ormemVPKV050MVfG9fUDpVUvO7l9m6ztM4irZPJjK2dyU3VaMU4P0dx07XTHJtxOJRxmTvQPPhMazofPv1lEnBLSRxsJ7UcEITpdvNDSjNhtP7qZaT7KtG+VebI9s3KPNOUVUACvGUM1EpZ5tVRwOQnGUiRWgApPShGgEB9ZwK+uMZipq87cxop8VMk9LQIJjyBx3h6rcIAATG6TRGZE9NhXb5TrdH4UCNWWYMM3mEMp1KoqNk+TBlL/0WZyQn7Fd+d6nI+Rpfd7AFvDXw/ecitgV5CDPwUHOOQjJMkBjvMMItexC2T+jlWev/4cbbuWQPHUrnIWkpM3I3pxh9T6/V4iVj/jZFadNRGm0RGzI1Qef04bvOzMW8QkPa7zwo7swAnF4AX2jAM6eI2hrXEjBeMu448tIvHSUhT1pPFfLEFZRmoSSs5+W9XRn6XtIm6VyoD/u7WQhUlz1UpokQtvssYNRiQNuJ2EoVbEDgRjwJkAsdEvsWMNiRKS7uFNgMMv8QCac1hS/Nz0v1mdhMeV+vbkVHWo2xL9NTfptPkY+94PkTWMJrQVNZE3Lbxt+Jvk8Nm7sTPq+V3DxbGUOMyfJuGdco7jK6IZbfiPrH0JLLlGCvaLIga5DU79clKKO54de045bwWGSY/ctRmWrEjLiGrhIVBZdxvHZt9iNQRTNoP3+kMBUT9Anl84Xqz+/mhgMy0l8vB8uBxUFERSHsT25vEhH13z7tFEOntQC0s9SdhzOtoBrcgVbRwPOCF8Sd66EEsrnl/uFgaiUiOuFztxd2q/CU5j+cu0wS46zxJrIEviETkFXOeysMKkpcudNN9vctfZr/VRgKnMNoHOk7GcgHSwABzgD9CHUlkpbwKc2VH7fxRp0oeEKC0U2GVUxviJQd7PaoNGU8IkzPpOCls+J
 Sq8QUrku
 Xf7UDv6qdnobvVjNjeB49NvynSwgEhG8/XJQHPBpH/grLVmb947/5CyYcVd6D+OY6qGZiGgEVQyQEfTry3IV4ACAXddkvZtJ1sNEp90JmMzQzFBujl+IWK4bzJzD4g2buZi2m1DZ2pRK+D0YZUSueW3z+7t1l7M5kQodxwrNlTUQRwfUdEd6Th2Q6qEbDNzWqDgnXlT+KkQ+k8g402MV2iz9bNt5NyC25UIXLYE+VIcbx9r264aPAsDN/DkT+p4QVFU02p8Iooq7OifP5J/WO9BgP++x0U07cRQHMuc1V7OA/0UovE9ERAjwP6NNhrThMnqk0EA2yr0c/76o269eFbZxZRqj8p51bLNMyg7YK7YnRWQ1PYdyNdvrbjHwwXXfmmGP0ryn/e9v9axpRWKarVOrFog==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jun 12, 2026 at 05:38:27AM +0100, David Carlier wrote:
> @@ -434,6 +434,14 @@ static void kernel_pgtable_work_func(struct work_struct *work)
>  	spin_unlock(&kernel_pgtable_work.lock);
>  
>  	iommu_sva_invalidate_kva_range(PAGE_OFFSET, TLB_FLUSH_ALL);
> +
> +	/*
> +	 * Lockless kernel page table walkers (ptdump, and any other user of
> +	 * walk_kernel_page_table_range_lockless()) dereference these pages
> +	 * under rcu_read_lock(). Wait for a grace period so no walker can
> +	 * still be reading a page we are about to free.
> +	 */
> +	synchronize_rcu();
>  	list_for_each_entry_safe(pt, next, &page_list, pt_list)
>  		__pagetable_free(pt);

synchronize_rcu() is rather expensive.  Can't you rcu-free the page
tables instead?  There's an rcu head in struct page.

