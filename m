Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F0213F8E499
	for <linux-mm@archiver.kernel.org>; Fri, 17 Apr 2026 04:03:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3B6A86B0089; Fri, 17 Apr 2026 00:03:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3673A6B008A; Fri, 17 Apr 2026 00:03:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 27D3F6B008C; Fri, 17 Apr 2026 00:03:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 169D86B0089
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 00:03:26 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id AD4338CB62
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 04:03:25 +0000 (UTC)
X-FDA: 84666703170.29.D6EFC9E
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf06.hostedemail.com (Postfix) with ESMTP id 683BC180003
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 04:03:23 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=JXNjbuDc;
	spf=none (imf06.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776398604;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4lWjRfIjCGyLGQglXl0+KvP7dWOHVwzR+Zz4odaMyd4=;
	b=APdD6Eq3bZWVzeAL7DqsDmHtOItWMJ5AuEaD4rPpTKGOHvKrmMaft2gxNWoq2TFMoqHZnk
	U91O0OZbfo5nGx5tIdbikWvRSLRaR326aT1R9clBWJu50CfF1PcRmhOgcDftAJKUVJD9E3
	CZAVZtxDhj7xAeL0pe+TT2eeJMSQ8CA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776398604; a=rsa-sha256;
	cv=none;
	b=rfgbrCX7cgwGuioTL2uJRnT1FMx8TTnmCyWGJkNEunWFOOePs88UIuQPXUke3A1zPAHjur
	fKalwBhC8++45mJSTDwOHXGA4R1nEn0MD/fxcgIUL3Gs3g3V4V5l2ytzblRMkex5OYxG01
	tYFJvbfO+dDC793D10hSXkIcGyzOla4=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=JXNjbuDc;
	spf=none (imf06.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=4lWjRfIjCGyLGQglXl0+KvP7dWOHVwzR+Zz4odaMyd4=; b=JXNjbuDcrKUZuZErpqDBQkZSg3
	wbt7gfY49yru7XIMpEiwLkKyWVBT82oQgPhJyfdVMJxHfkVnNexZzt0vWZK42BRuqwnJ9Kp+7sfyy
	Z2RQ1DfpGP3M+qTDykkAem82+5N4Wxw/bpqYZrB2AM8sSrKbKXKWjgbZNYLduJOakSb3vbs/71JmL
	vdeRe4v2MkY3ZTZPSSudI5szcdzPwZCla3X6uXpYHu9s4Cn0r6BONdRsdrSSXChhmUmnq+/g711dl
	INfbcBqpMJkm20MfSowsnzDoUj/DoQKVL2PBVGE+Epvz7Ze6C5+Mi+iZQMbVcd831pLo9fadZtpb5
	gr0L4Mog==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wDaQJ-00000002hmx-2VC6;
	Fri, 17 Apr 2026 04:03:19 +0000
Date: Fri, 17 Apr 2026 05:03:19 +0100
From: Matthew Wilcox <willy@infradead.org>
To: ZhengYuan Huang <gality369@gmail.com>
Cc: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org,
	Liam.Howlett@oracle.com, vbabka@kernel.org, rppt@kernel.org,
	surenb@google.com, mhocko@suse.com, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, baijiaju1990@gmail.com,
	r33s3n6@gmail.com, zzzccc427@gmail.com
Subject: Re: [PATCH] mm: prepare anon_vma before swapin rmap
Message-ID: <aeGxBwfWFlimkm-V@casper.infradead.org>
References: <20260417011606.1089985-1-gality369@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260417011606.1089985-1-gality369@gmail.com>
X-Stat-Signature: dij9mr5d6pbzh1c3rgfz61onpz4wzf66
X-Rspam-User: 
X-Rspamd-Queue-Id: 683BC180003
X-Rspamd-Server: rspam05
X-HE-Tag: 1776398603-718639
X-HE-Meta: U2FsdGVkX19zUsoVT35BM8W9aoMy4JbXaa7Kr6saxmR8fXUx4+pm7bEgSSEClNq3YP8DxYdY7MijkuOZQTjVwXS7IbNKPGfdH2xx9JhIhWXrALrFg7oLzIwHTY65w1BQJRwcHjvOmfo7B9HV2ftkFmg3UOYK4ARGOv1nvJJxPE6yJBtxoOG3y2f7YgvdXDMxD4lNNTRkdrtjl3ufSkf8op4fV+p0dhxfgGKkHI6WcYpyrZ8ZVi/DIR4OU2NH52iUeAzsyFQPpR3x+/b+AgZ867oit1LxwTHGiGeBqYdkWe5+ayqDkS/EvGNJEGQlP3V4wFj8HnEie7I9T9FMeRxu40TUtzZbZQKjhIomSJ3pY/UOVuq+7uoGyBnlonXQMAmQphqkwSTZu1NY0MjGHjilkwtBVWD69l9RxNyWZTucaTqjZ+gIfuDhpXXRTTUeLzWGe/2agvJoqOityacWsRtF63SPR8f0AaWalMt8LmaNrBOxa0N7kw4grbFYExSUq9G5ghAPacngoGlRmgGRAwV2Adsmo6NsxvjN011AiP1URsvEX2S+velLCPSMiwccda5QZFE4c3k3j2voxoOFERb1OXM0/NA0XoPffnq+a3vOMil+ZLAm2yseJo5MGfQJgB3jXWyTLuKrg59PCzKh9NAFMbcJaXqyusVJq6tRbmYdw897Fcen0ugC83Rir9+epXQX1g9cmu0hTkpr0O7Qp0fA86v9qWqwhr+pUekkTYjP0uD6x34EQut1BA0L4CXB2hTXd96YwVWTJW4cAcdmWJ/HLvF5WxuokisZ1Z+6H5NL/oXQHEOe/uvGaROQhvmEyN7c8omU0AGSw82t6+LcZMUE1nByxNegEeY6Abju9Vfcole6+6H6QfTbzBm4lFfWpVRDtH8m7sfbk05dMyR3C4MLU9e8NxpDqj0RVS/RXwDhkqC4CUBnfPVjTpmM/xmm/+0BKH64Xs/bhQ+cBitb1/5
 290oHLX8
 XOFTc2m9b+BylklioyIZrfofogHwBAeIlalQi0XvGJazo+qw3LK+syNb/zVNTBj3dC0zVtPQFJYmBSS8HTCaZylGAqKey58D1wlWH4I4bSR9dPUFFARHzgAyqxoI4AlQfWKYC+HqZ90FaLlqu7CKWQmGDP/7t8ylav8OEIcBWVSUeW8aspTHcZSJysUX2V47jFoznP02oY6aNr7qSGnFcaTNrlIS4TxaoRXbpbgfaEvqQi6bhFJyvi1L8fX4pwLlQAfEOBJbxIYrmNghHn3EBR6Z2YeXBMEC3rAdwd8D7Kfjp/EA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Apr 17, 2026 at 09:16:06AM +0800, ZhengYuan Huang wrote:
> Commit a373baed5a9d ("mm: delay the check for a NULL anon_vma") moved
> anon_vma preparation out of the generic fault path and into the fault
> handlers that actually need to install anonymous rmap state.
> 
> do_swap_page() was left behind. It can still restore anonymous mappings
> via folio_add_new_anon_rmap() or folio_add_anon_rmap_ptes(), but it does
> not call vmf_anon_prepare() first. On a VMA-lock fault this can leave
> vma->anon_vma NULL all the way down to __folio_set_anon(), which BUG_ONs
> on that violated invariant.

Huh.  Can you share your reproducer?  I wonder if there's an equivalent
problem with do_numa_fault().  And maybe the right solution might be
to put the call to vmf_anon_prepare() in handle_pte_fault() instead.

I'm asking because I don't quite understand how we get to this point
without an anon_vma being assigned to this VMA.  We should allocate one on
the first fault ... so we cannot have ever faulted, but if we've never
faulted, how does madvise() manage to swap out a page if none has been
allocated?

(also if you share your reproducer, perhaps someone will add it to the
self-tests and maybe it'll prevent another bug in the future)

