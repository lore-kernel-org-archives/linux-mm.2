Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2AA9FC55174
	for <linux-mm@archiver.kernel.org>; Sat,  8 Aug 2026 03:39:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E47B36B008C; Fri,  7 Aug 2026 23:39:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DF8686B0092; Fri,  7 Aug 2026 23:39:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CE78B6B0093; Fri,  7 Aug 2026 23:39:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A88186B008C
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 23:39:31 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id ADA4B1A027F
	for <linux-mm@kvack.org>; Sat,  8 Aug 2026 03:39:29 +0000 (UTC)
X-FDA: 85076697258.08.D02F998
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf10.hostedemail.com (Postfix) with ESMTP id 3921BC000A
	for <linux-mm@kvack.org>; Sat,  8 Aug 2026 03:39:26 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=Yo8nL7sX;
	spf=pass (imf10.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786160366;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zPdvXze8eJ+ip1RN4T5sK8ZVGUl8K7CRCIHKK0OEMsY=;
	b=gMSAnS5IY9vQaYy6uOfjxJ56t0fudJp+SEY4ULUWvJkkHi0tWAofvN523cay2xleuH74sK
	YRWB/XRJWSwQ5APywbWd4tKLyhmyl97I0SAwGKJ34wy6p8WBoyaUodGzYxPjWhVsGlx4pI
	z7BRXRDxUfXUnd3O0SEvi5lTvGkP8j8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786160366;
	b=MDEdLhvWp4+iQf7UrLmuac+YzMwLCp0UMCVIjgM/WA5z4SK0iC2aeAAWZcw6b/yhyASkHz
	Yb8haTgiquiTd0PSDxh9peSbN8/AT2dbHYIB0Gmlrqn1dvdMx2oQ86dn3ngt0Wazo0OOSx
	aWhXVD1jDW3XjPIQ7yzFQp3/A6NHQRY=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=Yo8nL7sX;
	spf=pass (imf10.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=zPdvXze8eJ+ip1RN4T5sK8ZVGUl8K7CRCIHKK0OEMsY=; b=Yo8nL7sXT8DRH38MZOCw9KMwkr
	FAGRqZvulhAtUjnuFQ/xUT7VCJP3ZAz6pmjW+4saebDg7NiH/RsA9+0Kpt/PWmkioG1+G35+7fCoS
	WxDFIETAP35cQ+2y3/Mi7493pxT5koC5/6xxcZJMI/Gc0ch+zQoaaHbikgQIzLBF5RmOoVYF4Ld1G
	EZApA0iQw3Ox2+EXHHsaLEdwbfC+tCEekT1PTPToUC3n6ZQaY5pBoQseiPCWf0LoGF4r42Xi5whKf
	5yH6lMKcuUhcIDYN9K4tRjP+3czgzJzw/I1lDa9qR8GKtcqdU6NGeWAY9a2d37wm7kbmtMK4OxqxX
	hm2Im+OQ==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wsVcI-0000000189D-1P0D;
	Sat, 08 Aug 2026 01:13:14 +0000
Date: Sat, 8 Aug 2026 02:12:50 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Suren Baghdasaryan <surenb@google.com>
Cc: akpm@linux-foundation.org, dave.hansen@linux.intel.com,
	Liam.Howlett@oracle.com, ljs@kernel.org, david@kernel.org,
	shakeel.butt@linux.dev, vbabka@kernel.org, jannh@google.com,
	aliceryhl@google.com, arve@android.com, cmllamas@google.com,
	christian@brauner.io, tkjos@android.com, dsahern@kernel.org,
	davem@davemloft.net, gregkh@linuxfoundation.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	netdev@vger.kernel.org
Subject: Re: [PATCH v4 1/5] mm: Make per-VMA locks available universally
Message-ID: <anaCkrk55EQoE2aS@casper.infradead.org>
References: <20260806200548.3124802-1-surenb@google.com>
 <20260806200548.3124802-2-surenb@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260806200548.3124802-2-surenb@google.com>
X-Rspamd-Queue-Id: 3921BC000A
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: r6rrpaczpf8dyqkafbh5a4hkd1fnze34
X-HE-Tag: 1786160366-801226
X-HE-Meta: U2FsdGVkX19nwY1qL8v0krLXXdGxQZqxARVxPsGF+8hS5z9t3DXQ48fZB/x57IIMa4ivj5DLHHquNaaZJvg+OSBR3Sr6o6htouOnLfQfPLgA2Z4j61xIEHDcLph+ClpBtBmmG6VgcgTRvZ//AUHZXvQkCEoySBxGbmuna1Eqrc2EIsqJxh5ePM6TIAZ5jQaSZzhW02H4CoZmRC6nrc/VpjR/zUQSw8xLwc5xJ38hok3Fv6g9eodJbKpxmRV1iikjpXzNIxCIGutjmF4tJek8ydox9MzYUohfY2rVVtXLjFZ2/GPdQfukT4W278ITZyXZvjeJiEdSUrxDuiJSsddJR3TCOKMcl0gOUyjh6dga2B12pxb04k65CHhaQtI5Nf7+c5kdsjb204DgB6tNWnnIbYi6ZF5V/PFmrwJs9Tk8Uafr2yD4SZafZN2fYpfPW1wUz3owJG03bIQ6aIwyVxtBZ/Fps6G22sSTP86HIjgMdoYYz9ry4cJ02YW+LAwwpN9ACD/6Ql8rbc7ndim3nm8jl9/opC9al3G8ZOiibkd3hgqI2MhVJOIJod+siBBCRp5IxMZ3L3fFhTSYEyEQigxaWCzKHM5B1Dj1OOJSM7NpqYusOhUq2LJ+erVmHnbyFlDZCuxHsEILHM4A6jpAzcwdTvrfOM5dUHn+I/kAAIigC1g6Au9ObPe0buTSlO/+SE2qe5RDTUXbsp/hvEGa60q16TdCZYBRCi4WgvbZKMFTxa/xP8clt6ULvd3d3viOscvNWSpjjZubpr38PF+kvPKTl8A6Y17GmEuW2nIMecqjl1L6a5UIy6XPX3uFDh/eXpoJDrtXTrkgzQ+ktbmNj9fgD2FpqfuBCB2h7SwOE5DprnEu7H8dZmwMpMHIQk1JEIWKMojq4VBq3xQ4r4HT6DvZ+aRRLGyJVuEixdzvthwOf2uhQ9ExX2voeIYUsWRRaoKI0fKEOLUSK6FUe1m54nm
 gAVcUqlN
 IkF9uT09YTftP3ose2ChZXpE06oSWqf+qOrTUeKHRAz8ZDWMilNX6eHeunwo5+4rlX/mEafFWK1E1QzACRv4vSxBi5Yuzuou/99j4OelE6rSQ+gu1VLvrWWR1bMDtUIEG8jHSpstqQuNreI8S9Wc3icc+jQ3LDBAWNBVeIsOProd99QUxsf3zY8qIOCgXdNFv7JtdCTduJDIn6PBucZ5rNuxcA98p0cFROjLaPvstae6b0kk76+V7xVCcgcWJWnUX+ATOOYXQgDzZq6qv5GPpheWoA/JLsZAiO20FZl0ZcplBE+RzJwfjmRZuxDmybVNXYWdX
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 06, 2026 at 01:05:44PM -0700, Suren Baghdasaryan wrote:
> +++ b/kernel/bpf/stackmap.c
> @@ -272,13 +272,8 @@ struct stack_map_vma_lock {
>  /*
>   * Acquire a stable read-side reference on the VMA covering @ip.
>   *
> - * With CONFIG_PER_VMA_LOCK=y this returns a VMA with its per-VMA read
> - * lock held and mmap_lock dropped, so the caller may sleep.
> - *
> - * With CONFIG_PER_VMA_LOCK=n it returns a VMA with mmap_lock still
> - * held; the caller must snapshot any fields it needs and pin vm_file
> - * with get_file() before stack_map_unlock_vma() drops mmap_lock, as
> - * the VMA may be split, merged, or freed after that.
> + * This returns a VMA with its per-VMA read lock held and mmap_lock
> + * dropped, so the caller may sleep.

I don't know if BPF is compatible with !MMU or not, but the comment
is inconsistent with the code.  How about:

 * On NOMMU configurations, returns with the mmap_lock held.  If the MMU
 * is enabled, the per-VMA lock will be held instead.  The lock
 * should be released with stack_map_unlock_vma() which will release the
 * appropriate lock.  Once the lock is released, the VMA may be freed.

>   * Returns NULL on failure, in which case no lock is held.
>   */
> @@ -288,7 +283,6 @@ stack_map_lock_vma(struct stack_map_vma_lock *lock, unsigned long ip)
>  	struct mm_struct *mm = lock->mm;
>  	struct vm_area_struct *vma;
>  
> -	/* noop under !CONFIG_PER_VMA_LOCK */
>  	vma = lock_vma_under_rcu(mm, ip);
>  	if (vma) {
>  		lock->vma = vma;
> @@ -308,21 +302,20 @@ stack_map_lock_vma(struct stack_map_vma_lock *lock, unsigned long ip)
>  		return NULL;
>  	}
>  
> -#ifdef CONFIG_PER_VMA_LOCK
> +#ifdef CONFIG_MMU
>  	if (!vma_start_read_locked(vma)) {
>  		mmap_read_unlock(mm);
>  		return NULL;
>  	}
>  	mmap_read_unlock(mm);
>  #endif
> -
>  	lock->vma = vma;
>  	return vma;
>  }

