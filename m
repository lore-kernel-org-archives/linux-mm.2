Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 245D0D46C16
	for <linux-mm@archiver.kernel.org>; Thu, 29 Jan 2026 00:51:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 65F506B0088; Wed, 28 Jan 2026 19:51:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5E2AE6B0089; Wed, 28 Jan 2026 19:51:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4EE4D6B008A; Wed, 28 Jan 2026 19:51:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 40A516B0088
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 19:51:13 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id EC995D4109
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 00:51:12 +0000 (UTC)
X-FDA: 84383172384.19.189982E
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf20.hostedemail.com (Postfix) with ESMTP id A68C71C0002
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 00:51:10 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=HAPXbs6s;
	spf=none (imf20.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769647871;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=L4AF41OoN6wLW3Ksx7JAVR5WN6Ag2lRG6vH9W603dug=;
	b=bPEN/IruLrxETDnR8GJMzRoagA+UvJ8QhmehuHZqDdodPJe6Q9UWF/2Wa3GQOdDxmQdtI0
	p4pblcTtdD0C4Z2Pt6oJ8Ah3MemrMFamavXBKpTDI5jWGoOS4CZl+/bFzX6k6Eep+oo0rs
	qyd5egUCFSOrcwXotHTDKfBFOrWibcE=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=HAPXbs6s;
	spf=none (imf20.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769647871; a=rsa-sha256;
	cv=none;
	b=x4M/3Pprnf0ielOekk8ShVjxl9V4tcnNMyQh2wUVgAmQX8G3K/jM8hfFueIQHI9FKTaIS+
	novVGmJQQHwR53NOUYJJMV0JEJHLQ+xDfoosvdZTu+OT22CT7sn1m5ScFPFLveWskWjZp8
	fkSWleUtx2bw9sDeaB2DmSnngB49HVQ=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Transfer-Encoding:
	Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=L4AF41OoN6wLW3Ksx7JAVR5WN6Ag2lRG6vH9W603dug=; b=HAPXbs6s2IWE6aFzcSMFVOPGGx
	sjruUuR6CY9Tkjx5FJK2nuqwfY0Wzl2IljrOyBmn2usIZIOMcQyHUtNh+Pvuhx3iQNldFCogWMf2h
	FCcjY3qUu+8mWoF0c+j3uIYHTbOBiRJXM2mVL+dRYzO64Tkd17d6hJbZwwXYUXh87bAI2WtAR+vWq
	4siZF0VvXeq2NKXo1hhRBoJT+Y2uBsIQBMDuB6q9kuTsefjMh8gA8dMGuU04hLOGSFG5v1ir2vPuB
	4k1U0/JTmt4el78mf3TgwEbo274a5HtfJoRztmK0l7w43jxE+hhSxkVzuYSpy59/YvOeglsoY+Z3A
	6lw+J3UQ==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vlGFX-00000009qHX-0RQK;
	Thu, 29 Jan 2026 00:51:07 +0000
Date: Thu, 29 Jan 2026 00:51:06 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Brian Geffon <bgeffon@google.com>
Cc: Justin Green <greenjustin@chromium.org>, akpm@linux-foundation.org,
	linux-mm@kvack.org, david@kernel.org, lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org,
	surenb@google.com, mhocko@suse.com, linux-kernel@vger.kernel.org,
	greenjustin@google.com, rientjes@google.com, arjunroy@google.com
Subject: Re: [PATCH] mm: Refactor vma_map_pages to use vm_insert_pages
Message-ID: <aXqu-pe6kR4VDOnT@casper.infradead.org>
References: <20260128225648.2938636-1-greenjustin@chromium.org>
 <CADyq12wpDTjHVGs7CTQ3SPNMO_ovmMk-rN7L4i_AGvdoLYQLnA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CADyq12wpDTjHVGs7CTQ3SPNMO_ovmMk-rN7L4i_AGvdoLYQLnA@mail.gmail.com>
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: A68C71C0002
X-Stat-Signature: 9b1qf3gn8zf8oxa1bmp73yxtbnk4oy7y
X-Rspam-User: 
X-HE-Tag: 1769647870-958657
X-HE-Meta: U2FsdGVkX1+3yPN6d2Z1Zt/e+F9BkwF+fqmw34mLIm4MmZ9O/XE5xm7RImZK0bR/Z2i91xVGp/NexqGcw4zYbjGo7uKR7Duka87HJQz95SnZcvtKYHfuT+3Lfp3PHbf23+uhlsAVY0U9zA/BzENX7FXMpKZ6QHJAkXIkIJRyxxJAK77AOr9jadHkxX7X+Y3BTG+wMT/Ii0I1rOkDzzLGuVigWbYYryKceucoLdKvdv7BRICa2TQJVxwBklOQ5nApxdcJQeOFBOna8gX42jtIFCDgXFcTdzh+4yZfOhEL/4lvO7VLoWfFY91QRfj+u7fUP9IDE6I98pTSMJnwM9SNHUeMYPutAAXaoU2S9cISPZ3ISL9F7wHpX4qdMjK5L0E8ZjVPLI+dsrl4Q7744NaBUVo/O7Zs8/oLwyUD/LHGS8+YWyk9fJa9D9X1Vxu79ihMSsyybwTyx7wnHyg+bsubbhXdbzUNvfCR8tBw5/SkfBsEKsL4DUG5XgXGi8qoVjMbVEgTAYAa1m1T71/k+1S9+iqsG4ei7OBAKloSraAT2DMqSetoA0LFfpQeePiU+TbwUoINV5JF4Cy7MvdUvZBIBQpnt7nXzemnJN77X2Z7POp1fzzpNAOQEus5HqAF6zI4NvkwCTXVH/SZ0G37zSkhhXlOYBf0Zn7Z4TAotQOa7Oa0nT0njzcLW6RBWpQVjL+Tl1V0JDFCB35CEDniXgZq1r/B/rwhnyH+Znnr/G7zzcWzI373kkqEoQ7H7lLilYQug9M0h7W0fPQX4ATv2U9DNDty8zA8Hpm+aZpp6ZN1h6yvq3WUDkvFWVdEKhlyTq60l7inkX1rlM/FNfhayxCR8iqyPG6pz+biOl1MPu5NXtTVfUKo90jArRrvHwt8rweVrF45RmGZBshl28qqURqBW7YAPCaIxejVlvueWAWUNMik3OM5hG8Tdrk8eWRRdqyxk47H0lma04rbeDs2XJT
 Z8d4fFmD
 f7SrSNIKLATE5mb8xr7D5Wc1hF60SjJeUye62WeSOUVFiD0fh4kvDT40E2OuyhJiwhAJe5AXHssFOQAw6BFdOfYg8iEuw9fd0qvEltSOMQCdqW3aQ2/uHvwdCeENY1hA9SQkmmYTh5oQpQD+YSHQBLY+A3al3bUiDsh7j9Vv6ySPe8JgoSYj8QnX9p1cZyOxpLMa24snyC+zFE60xVUoT5qSIGzsv4xsqxIHbO1/n9IlHwPQxvnvXfn7RFAdr7N0cQovxTt/Ghsfws61z1sEX7CtdbeTIUzlY4GTGmZ1n+MoWdXS/+vpJFtg+SKdg0UuoT/UgaRGMuZSBz9qC71LneBhyxizqrtrq7GLo8CANraiBNQGIrHpZkdc0cxCynoC3DmC87CS99HsIxIo075asECuJrw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jan 28, 2026 at 05:59:12PM -0500, Brian Geffon wrote:
> On Wed, Jan 28, 2026 at 5:57 PM Justin Green <greenjustin@chromium.org> wrote:
> >
> > vma_map_pages currently calls vm_insert_page on each individual page in
> > the mapping, which creates significant overhead because we are
> > repeatedly spinlocking. Instead, we should batch insert pages using
> > vm_insert_pages, which amortizes the cost of the spinlock.
> 
> This makes sense, I wonder why this wasn't done previously?

That's always a good question, because it might reveal why this patch is
a bad idea ...

However in this case, it simply seems to be an oversight.
__vm_map_pages() was introduced in May 2019 and then vm_insert_pages()
was added in April 2020.

Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>

