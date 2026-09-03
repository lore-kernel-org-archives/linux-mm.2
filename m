Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B887BC61DD3
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 18:22:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C35836B0088; Thu,  3 Sep 2026 14:22:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE6E76B008A; Thu,  3 Sep 2026 14:22:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AFB1A6B008C; Thu,  3 Sep 2026 14:22:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 942A86B0088
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 14:22:55 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1E6DEC05DE
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 18:22:55 +0000 (UTC)
X-FDA: 85173272310.03.8DFE1D3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 51A7FC0003
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 18:22:53 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=wPq43bzI;
	spf=pass (imf28.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788459773;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BH9198rK799MJYuMQnII0Ud2Ndbo/vSNpauNbEwkaPY=;
	b=kHyV7kbZ+xldzOnswRSD6svuFQFf1NW90yQG9CU7dn2VoS/+nDaVShzCcwHLOyYiGz4w7a
	rc0uVBonOmDKP/Hf3vkk1NCvZMSRAnF/RultQrelx0Lm9j7WrfBMzDS53lxL4/B4iAbyDM
	O3OkRAIwO74aPBA9zEQx7n5V0RkHPFg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788459773;
	b=GBo2rZxiXYaf0XBt0XZAkMGvzCQY0n5k5o9bicVVQHyu5PYQvldfQmLWOuP/SaEJmdgQXP
	d0Go9LphHMRM0wcBXZuQsT9hRxkQYeeaJwiw6TqBSWPcNHozIP3SAMmwueq9pP8K0cVhAL
	5JtADpS3U89HuNkuByFK7pnNp8OaB24=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=wPq43bzI;
	spf=pass (imf28.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 30F0640A39;
	Thu,  3 Sep 2026 18:22:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6A1A1F000E9;
	Thu,  3 Sep 2026 18:22:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788459772;
	bh=BH9198rK799MJYuMQnII0Ud2Ndbo/vSNpauNbEwkaPY=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=wPq43bzInk5PeSp03yEN+aaBk6/3zIf+7JLmixWEffRb5kBY3W1GcGa93mnUjUzXg
	 Hz16ZsLD6o3bVbGZX4OZUfNz4QCUyhqGdY1anzkvlaOC2h+ggDk3KjZZ3hnvkpn+5y
	 lrk+hARIF5FuzcZ1IukI/fdIPXcztqFvwINX0ybI=
Date: Thu, 3 Sep 2026 11:22:51 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "syzbot" <syzbot@kernel.org>
Cc: syzkaller-bugs@googlegroups.com, Krystian Kaniewski
 <krystianmkaniewski@gmail.com>, <linux-fsdevel@vger.kernel.org>,
 <linux-mm@kvack.org>, "Matthew Wilcox" <willy@infradead.org>,
 linux-kernel@vger.kernel.org, syzbot@lists.linux.dev
Subject: Re: [PATCH] xarray: fix index jumping backwards in xas_find()
Message-Id: <20260903112251.6114f91af953412d2355e5b3@linux-foundation.org>
In-Reply-To: <2992424b-2120-489e-9010-f45f46ed52c8@mail.kernel.org>
References: <2992424b-2120-489e-9010-f45f46ed52c8@mail.kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: qquf6o4p5oxfgrfzo64f5ur4bk1rdybb
X-Rspamd-Queue-Id: 51A7FC0003
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1788459773-271804
X-HE-Meta: U2FsdGVkX18DQgmt7x2xCQVn/O2c2av+hcYWQ1f26dGB8pg1eUo3vdMzmYnV1vLNYK3RY58TwyeU/1XxlKIPwpZdC3Smy36REFd5hTZBD6ZoNto5LfNn+8a7lPyOdema/LSg1y0xx8sEdIwmqgzvL98Ez27PB/yuariFt1s2XNhC2n2bD+/ypPRmarwM8Kkz/EgBItlJNJPGYJJFk9e/hkQTrzRaF+GKGIKfcR8s9qLq4hQb3AcKPCRcXt/FTsVUuTi0nk1N9ZpJYK0AucTk6pXQjaVz3ri5ifuu8EfrHYAN4DIvV7smoyVCckpVzJNx8EHOJ7usQ/LSucolW/gt2jmy+IBfgA+dok+yN9wAxvqEoXr+Cy1J5F41LiM/QxSqzXbMUpcR5coZ8qE9NxVmoRe2GY5QHjDlFn6eKQTSt/fAGo6GLNlId5GEzWvcbcNzqlKpkty8xfguGU20KwqHyuJYIfd2lmdQyBjqzd1bWRBI3W/iu59uOdY3zdq0g3vyLB8RpeJskXpgoFWuG5NZR23w0E0q9I2GDPPgDk2zZrt6EDjMCqFudkX4thcbt1UJZeqQ3YBVZ/PeOjYFNS5PWQhh2T4/HtWMm2KQR3ksWhIn2c4VMPQJS0SaPKT4wbdAZEBPK1zzcZLNiD5my/WQZblxjdpD7A2b/8JkW3wBjlEGHVcqjnkkEBBxuVFdiDrAQJdphNpuivW9H1GPdUlp9Ex7lvryrWiHJEjJ6BF3JO1Y6H30Z8ZZK8JF+yE3vgf80LEvLX2okIO4lj+N/fwfWBqYfei6XVQ58OM6nPwpnh8nthp5aLdYdOdNIRntiK1ZvSlP55JvbZPXWERQjVlabgEkT1QuCzzG/HYkCVBeh87ii0RF+wZ9GtE5XgxLdG+52ixsLoe1wA9B9wQvnAT20b0FYIIXXbcwgnYE3EOhmBHhDNwlVaWofOabmwKiTag730aGngUv+V/JAVyW02z
 Hd1yyH1f
 uMlpiBGgWIqxKw+voA3LemaJLbAXtq8uYK/g4E/CCB2pZjYkoqRKdRSPDw6VF+36Yz8sP6PuQOFrDevhcXBVnApB7uDfT5AdH0lotKSJM6Dwez/iesvK7iqFvXBQwO+dOhLsSlMLSO4ZIa+DIZV7Eu3VTPFfAsfDJnueF/jplaiZGMT/mD/J2kcEdLO3xfyMRSitBN21hl34FDLGEeYftrdFr5/bDt6INzZzsRKyP3t0GHLBHHn7kGWHBMjMQMCIJ4I0AdXKgy5Px+RdtHyLioVn3ErFEtkaANNNcKlWwHAaZSOPyTD6Tc4JjYEjLSFfZyDCvdG6VqxfDxyGhkPkY/1RA0XpIyoToe5B/z7O211yVgQQ7gdMlaSRupRdEhYV3xSmFEQaWUpNXm0po/NG1ctflvBzzpvj1m12/YCdJdkmsWEn9c0aeHBBegB2Db2r1dHVPA4ol2BzguQ8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu,  3 Sep 2026 13:48:55 +0000 (UTC) "syzbot" <syzbot@kernel.org> wrote:

> From: Krystian Kaniewski <krystianmkaniewski@gmail.com>
> 
> A bug in the XArray iterator xas_find() causes the iterator's index
> (xas->xa_index) to jump backwards when iterating over a multi-index entry
> (like a THP) that resides in a non-leaf node and is concurrently split.
> 
> When iterating over a multi-index entry in a non-leaf node, xas_load() sets
> xas->xa_offset to the base offset of the entry, but leaves xas->xa_index at
> the requested index. When the caller subsequently wants to advance to the
> next entry, xas_find() is called. xas_find() attempts to synchronize
> xas->xa_offset with xas->xa_index before advancing. However, the fixup
> logic was incorrectly restricted to leaf nodes (!xas->xa_node->shift).
> Because the THP resides in a non-leaf node, the fixup is skipped.
> 
> As a result, xas_find() simply increments xas->xa_offset and recalculates
> xas->xa_index based on this new offset. This causes xas->xa_index to jump
> backwards. If the THP was concurrently split, the entry at the new offset
> is a node pointer, so xas_find() descends into it and returns the folio at
> the backwards index. The caller (filemap_map_pages()) then calculates the
> PTE pointer based on this backwards index, resulting in an invalid memory
> access such as an out-of-bounds read or use-after-free on a page-table page
> freed via tlb_remove_table_rcu().
> 
> To fix this, check if xas->xa_offset matches get_offset(xas->xa_index,
> xas->xa_node). If it does not and the node is a non-leaf node, set
> xas->xa_offset to get_offset(xas->xa_index, xas->xa_node) before advancing.
> Also add test cases in test_xarray to verify xas_find() behavior when
> iterating over and splitting multi-index entries.

Thanks.  But the changelog omits vital information: a description of
the userspace-visible runtime effects of the bug.

> Fixes: b803b42823d0 ("xarray: Add XArray iterators")
> Assisted-by: Gemini:gemini-3.7-flash syzbot
> Reported-by: syzbot+b72767277f29b6407083@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=b72767277f29b6407083

I see from there that it was a use-after-free, detected by KASAN.  I'll
update the changelog and I'll add cc:stable.

I'll queue the patch for testing while awaiting review input.

> Link: https://syzkaller.appspot.com/ai_job?id=a01c56bd-74d0-411c-afb4-ee6f0cb6cb61


