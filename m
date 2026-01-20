Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 83A6FD2ECF7
	for <linux-mm@archiver.kernel.org>; Tue, 20 Jan 2026 13:05:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EB0C06B03EA; Tue, 20 Jan 2026 08:05:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E5B3B6B03EC; Tue, 20 Jan 2026 08:05:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D5D836B03ED; Tue, 20 Jan 2026 08:05:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id C3DA16B03EA
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 08:05:12 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6C88DC1ACA
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 13:05:12 +0000 (UTC)
X-FDA: 84352362864.04.A160673
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id AFAC480012
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 13:05:10 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jVGSgD5R;
	spf=pass (imf30.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768914310;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Rm1+TH9fC63RHVsLPRFocRZcBTCLYTOhVyDXox1xIhw=;
	b=4X0hfwSndgmxQ+u1f7WuAHLWa3jw/sZs5U+/D15bIS+6yQrg9PcFlNF1arW8qDElljTvL9
	b2eYBclTP1KhZwSM8Jc7vCG2w0UR32NSelgUbx0+NTOvMBba+QWXgUuqYz8h2+PHFES5/i
	wOtc60yVw21BJQsdenrwKD/QgBdkVKc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768914310; a=rsa-sha256;
	cv=none;
	b=hVAQ7du9IZSXgDGRHb64nb3ouyLHCXOyRCqA1y1h2dozTnGoj0gZaHKvT7dxra6va+uxbE
	D+JDD1U9y2gBnY3ihvNlno4iJqpx0kSNNEYj0QiHqpSS80Ek0mzwcS/+SkCzsBK3vwnMZ+
	UW1klMnMs+HUxRf7MrTmxtU5H7Ct/nY=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jVGSgD5R;
	spf=pass (imf30.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B97DE44136;
	Tue, 20 Jan 2026 13:05:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E89D1C16AAE;
	Tue, 20 Jan 2026 13:05:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768914309;
	bh=nLvy/n1nlxvVvAZe/tXcawkxy7YqzQ4rJIes0g8gIsM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jVGSgD5Rp1+S26FlKdh30mQwBmeaUSion/wrJY6TRn2CeLWpMfYSoIijBm3rZOtDn
	 B8NnkxN7gQPYUZSnhffWRW3+IjJgN25XZc0kWkdEt4saUjL70y6fJCeIylbEOlrZY9
	 Vn64zowOOPPCSxLjw8cVHRskMwr76wGxWYl7Ngcb65fJziF4r6RXv84mJC1eMjatdh
	 GRfsVQ+Tp8dVRCRq2zwU7TWyQMFfqtMVPm+HnrBXiy2n51kutFv6xWmSzmP72dxjPu
	 hXba3PzVdw+dTB3OvyUtkXg126TGuRvrW961FdYoQU4imDSKPhL69VMV5atQqwOKnQ
	 aP0c/0ccLqYBQ==
Date: Tue, 20 Jan 2026 15:05:03 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Alexander Graf <graf@amazon.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	kexec@lists.infradead.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Suren Baghdasaryan <surenb@google.com>
Subject: Re: [PATCH v2 2/2] kho: simplify page initialization in
 kho_restore_page()
Message-ID: <aW99f7WAAAGtCfx9@kernel.org>
References: <20260116112217.915803-1-pratyush@kernel.org>
 <20260116112217.915803-3-pratyush@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260116112217.915803-3-pratyush@kernel.org>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: AFAC480012
X-Rspam-User: 
X-Stat-Signature: 3uut1xuz1ct5amj558zuukmkm4ab7p3a
X-HE-Tag: 1768914310-154405
X-HE-Meta: U2FsdGVkX19+qehac9rv96B60lTvQs8PKe5wi1+/onfRzjtvdqqfZMhktv78n4rmTMDZBf3v0SXsb1pz/1Dqny49CKj9KPCP0voFCSIyDmuDbGZi7vqTznehYK7+bYJ5IQWCAUC5eFv0MWPWdvLaRM5WJ4nOFaCtBKNzvgCIv67pcoPx/Xau+u2M3Z3lIvehLLeT+Wi6gJmmnpLHSbTtKSGMP+M3MXWsnMQUZGIF+XVm2YnoJwA2m1dbRHdNx3m9WESCtdL/OmACpPAKj3lzZ13wgTCyZpTdzVGZbi/6H3pCjOfw1OA032u7mC+oGZAXJb0HugAI8m+dPwShkB2BJnO/mv7fG4jM1N1tlUKIR1z8Ewl77idnkadhf6YgP4E88WZ9MNw1AbgtEVNHyt4ByptyoB7zohbMSQ/FgYFN99+CTI/kBv7VvwDgsJEk+y1VJyhlzcHHUbysUZGc+Jf2sgmwd5TEYRMp73ZphbURvwh9J4bWkB06/Rr0Jsu/YS8tkGJmCX43egMFQCs4QiFUZcp/8YnS87LJTLOIs5tU46bqyyxXL4KvPi07ppuxBJIuhLLq0qjGjYmQ7dS4kZa3fpMxu2YkMuQwLQtIj3ont3HwX+/85cJNHqDjZSRNU0aIC7ef2crHbEiIhmO8R7wDz1fNCNlUGaJU/j6gDnLY28Vyt33Q+MilJqL8tj1K3lQ+Q5EMNDo8FPI0gfzZGXY2l9jza70qKHPWrwW22TAg6kFVVHG0AGEFSwZrSZHZe+KIrjHYq4wUWfnnAzBDK2903ZeW17bjTK/5rMmZIq6YymevfkMa/pwtiXoJAhsd8j2besetqvgVrsirn5eLEWE5numPNW+I35SZl0aFyB1wx3r8bsZoAYbqlIQn7r95URaja1aTnHbVfxouoShsdLn7la2xdVwwEt05Nh/suNAvyTRN+xs8eurWGVVvLvbrb0haTno9FhhdRMxUUs4Rj0A
 8Y6LiHW/
 mOQJmXYSeToCwInPCSP9PZLhQt8rpST6I/FsB9G1sHpOGgL5Qdv67UIza+UAYF6ZbvIwvlO6hCzDvO/0ZVsMdYZhBDsc0CHfg3t582j3M9Sei3wmruSxOkwagym7FUGVJRRl1HToxy27demVDaNi0ApRew659AECPjOq34lIpVYXiAtHP7pWD+br0YdpFieM240a5yUWC966WNjDEPvHHaJlKnddtN2hnKAkK8AYVzJY8xUL0Ogy1J33K0DHZ8fB5piZCA6nUBoys4+LHIdIAwUHTwz+v+Yy0EcVzDVqGg/etAySqUKn6RT2Dp+nPZhuW028n
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jan 16, 2026 at 11:22:15AM +0000, Pratyush Yadav wrote:
> When restoring a page (from kho_restore_pages()) or folio (from
> kho_restore_folio()), KHO must initialize the struct page. The
> initialization differs slightly depending on if a folio is requested or
> a set of 0-order pages is requested.
> 
> Conceptually, it is quite simple to understand. When restoring 0-order
> pages, each page gets a refcount of 1 and that's it. When restoring a
> folio, head page gets a refcount of 1 and tail pages get 0.
> 
> kho_restore_page() tries to combine the two separate initialization flow
> into one piece of code. While it works fine, it is more complicated to
> read than it needs to be. Make the code simpler by splitting the two
> initalization paths into two separate functions. This improves
> readability by clearly showing how each type must be initialized.
> 
> Signed-off-by: Pratyush Yadav <pratyush@kernel.org>

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
> 
> Changes in v2:
> - Use unsigned long for nr_pages.
> 
>  kernel/liveupdate/kexec_handover.c | 40 +++++++++++++++++++-----------
>  1 file changed, 26 insertions(+), 14 deletions(-)
> 
> diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
> index 709484fbf9fd..92da76977684 100644
> --- a/kernel/liveupdate/kexec_handover.c
> +++ b/kernel/liveupdate/kexec_handover.c
> @@ -219,11 +219,32 @@ static int __kho_preserve_order(struct kho_mem_track *track, unsigned long pfn,
>  	return 0;
>  }
>  
> +/* For physically contiguous 0-order pages. */
> +static void kho_init_pages(struct page *page, unsigned long nr_pages)
> +{
> +	for (unsigned long i = 0; i < nr_pages; i++)
> +		set_page_count(page + i, 1);
> +}
> +
> +static void kho_init_folio(struct page *page, unsigned int order)
> +{
> +	unsigned long nr_pages = (1 << order);
> +
> +	/* Head page gets refcount of 1. */
> +	set_page_count(page, 1);
> +
> +	/* For higher order folios, tail pages get a page count of zero. */
> +	for (unsigned long i = 1; i < nr_pages; i++)
> +		set_page_count(page + i, 0);
> +
> +	if (order > 0)
> +		prep_compound_page(page, order);
> +}
> +
>  static struct page *kho_restore_page(phys_addr_t phys, bool is_folio)
>  {
>  	struct page *page = pfn_to_online_page(PHYS_PFN(phys));
>  	unsigned long nr_pages;
> -	unsigned int ref_cnt;
>  	union kho_page_info info;
>  
>  	if (!page)
> @@ -241,20 +262,11 @@ static struct page *kho_restore_page(phys_addr_t phys, bool is_folio)
>  
>  	/* Clear private to make sure later restores on this page error out. */
>  	page->private = 0;
> -	/* Head page gets refcount of 1. */
> -	set_page_count(page, 1);
> -
> -	/*
> -	 * For higher order folios, tail pages get a page count of zero.
> -	 * For physically contiguous order-0 pages every pages gets a page
> -	 * count of 1
> -	 */
> -	ref_cnt = is_folio ? 0 : 1;
> -	for (unsigned long i = 1; i < nr_pages; i++)
> -		set_page_count(page + i, ref_cnt);
>  
> -	if (is_folio && info.order)
> -		prep_compound_page(page, info.order);
> +	if (is_folio)
> +		kho_init_folio(page, info.order);
> +	else
> +		kho_init_pages(page, nr_pages);
>  
>  	adjust_managed_page_count(page, nr_pages);
>  	return page;
> -- 
> 2.52.0.457.g6b5491de43-goog
> 

-- 
Sincerely yours,
Mike.

