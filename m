Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6283FC5AC67
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 19:12:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 65A866B007B; Tue, 11 Aug 2026 15:12:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6326C6B0092; Tue, 11 Aug 2026 15:12:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 571F46B0093; Tue, 11 Aug 2026 15:12:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 33B416B007B
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 15:12:29 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B9A93C0167
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 19:12:28 +0000 (UTC)
X-FDA: 85089934776.02.358F4CE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id EBCD6180008
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 19:12:26 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=I69u3zkO;
	spf=pass (imf24.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786475547;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+i5G5eQtKFOjTqpeKl14Jk+BOvdz+qV6fk5uL70Mp/c=;
	b=5eJJnAOy444MA/gbYwDbFCoqB1Ew5NRRD2omc7FRlTxynE8ODkrT23Pkl4b5mWnsP0xyUK
	GNPne3+AhSCkwlnhOodxZrnky0+1XP7zuBSzbcdhBCIUz/YKoQ2fyIT+pu7hB0uQkHsLT1
	43TBRLswIp/IprvaqpDE+dtRCjZLEiA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786475547;
	b=ltELoU1wpmyC5S+byq/7+9Lw/72sHgsjDuHXiGKIqy/1TlVm4UsL41zQc3n41oFSsOyBJx
	n/tBJJfQ3QBhOeD0R/NQgmJLCK0PX3dk/lc154aVXve0LcIiMJ8RzqvAlHAOXbNJ55oAFL
	dLS9owaU4bq/3WBJ5Z2RL2gFPT/yEiw=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=I69u3zkO;
	spf=pass (imf24.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2617B411EF;
	Tue, 11 Aug 2026 19:12:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 976B71F000E9;
	Tue, 11 Aug 2026 19:12:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786475546;
	bh=+i5G5eQtKFOjTqpeKl14Jk+BOvdz+qV6fk5uL70Mp/c=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=I69u3zkOHUBjUDeB0DWHA0jCm2xjNPzE7+QZF55ijRPURIVRy+1o3KcJtn2E9csd8
	 hDwI6dEoJioia6AIvlSyCDXVLScUtTIPm2zGiT7j6e12dtF6tERmywhYwFrj7lV0EB
	 HMWu/jeWefrEldBAlwg9vxNfnx3+5LR1PP0cmMt4=
Date: Tue, 11 Aug 2026 12:12:25 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Vernon Yang <vernon2gm@gmail.com>
Cc: david@kernel.org, ljs@kernel.org, nico.pache@linux.dev,
 ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
 lance.yang@linux.dev, usama.arif@linux.dev, zokeefe@google.com,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, Vernon Yang
 <yanglincheng@kylinos.cn>, stable@vger.kernel.org
Subject: Re: [PATCH] mm: khugepaged: don't pass swap entry value to
 trace_mm_khugepaged_scan_file()
Message-Id: <20260811121225.fe45676262404b82270843a1@linux-foundation.org>
In-Reply-To: <20260811133655.267739-1-vernon2gm@gmail.com>
References: <20260811133655.267739-1-vernon2gm@gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: o1p1jjjxtqikca1iizxabspe3piz3ct3
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: EBCD6180008
X-HE-Tag: 1786475546-279437
X-HE-Meta: U2FsdGVkX19YfI5egthuHHVaCksahhDe0U9ZGokpdotl1uAB8gzUC4yF/qhLbQ6ojaEM/DxDAlq6Sk96JZYNCNe+8BY+13+LeB+/+lTS0Lu5Knkz/CMie+9nRdGc5+IZthCJ8hISE1aZr7LCrG0ZghiN/WFo/KKpoTHtKW3wQJjAAR9cFREgUvrVoF8fG2+MWMcFT1ioyq9oT2bDwl5lHvd5MNhSdyxllBE1tFRid1IRZK+nwoxzU6e8nrU+jkDxUFziWuazi2ZLOiPnziQUY9zoduTgErowci57NdetGhXOxUL5Scm6ZIPjKwHfnsnQYQ2oXFp8uarYsggssOI2vl2WnW+VpFLdxqTaYJAZ9pKzHkA++8GVvOl5v6TZovrtsOqEbDT6Ym768f001ReFejvjFU7m8E9SvjQaHXN4cfSLHtyhdKbH8kDTvRdLb5R/GjfVCxDWLcbnr1tgO2+hf8KwaNKXOwRVPcXS/Yb2j7+2wYUJ1FLXgZw2NzurxIiinbW2sQdVSwUf8rP98X8Mj0MgMpF1t+ZBp3NkDgwDbtZUbkeqFJvnevlJQNShQ5OJT6W/9TTeaeaG9Bchi7BUHBXQw9zJNifT5nQ8LiK5qcjJUCzCFFYRtXlOYv5NfyPimAA/5zvK2LbPkENBz0mHTiEootcTOgNRDu21cXpXy8YwOIfKeR7+bzXfe15XptJXDzhXPEwn5csmtQ+ZiXr/+kXl0ugsyEYMwLahoekehhaMNJKVyvxDK2I8E2NZfmXvMdVTXXSXD9ZjYTzAqw04ppeu5HeEBVamC3JPg2x9GQqgORmnXTfQgWBMY9AB7vSOQ89aPKoMu5Kjbq5XhDRjFrQ6xHPRUoDQCBJTBbw+KiAHj9/GhvYoGgmqmvdoPV/ADgUdX1yyrYl6/uks6Ql9Lg16Rb03zXdrWhIQ0mFJZ+TCveCPbBnrxOFl1dJI3Uh17rZAhBKM8m9oY/0CF3J
 WRatux5o
 1qweCwS0qNFe828Ldtc/7Ars0RCWCenx2RPElFKCG1rH0iRdhFosxwhY0g+t2LRZiv/zPDKReAyDgtLEyhtQIF5rCR0W8TsxTyqmtVkSEQdXbz1vSGcQzvaUbdU5i+7w9LLMnzErwVzbFnpdv+aTM1bHSMeLLjDDD3smkCH425eAUAdM34Y7vK6EVkdc1VmjYFSKkIAIa++Lj+D8CtEwAHDJebU98pvWTjK0kU3Cr+yWn/AbiLh6Fv6sMm58gKJCGoC0HofxJEL4NJYZlt+qz2BLtJ8hJ/ulk4bvAq9FXyo6U29PzjqneP9MH8A8S2rYbe9vbtcPeJx2e9Yrv6lp2MXgY1Y64pjakcVXbA0XnZyljR1tGvrRO/BQiUSRH+U8+8tiC
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 11 Aug 2026 21:36:55 +0800 Vernon Yang <vernon2gm@gmail.com> wrote:

> When the swap entries found exceed max_ptes_swap, the loop is left via
> break with folio still holding the xarray value that encodes the swap
> entry, not valid folio pointer.
> 
> That value is passed to trace_mm_khugepaged_scan_file(), which feeds it
> to folio_pfn(). On FLATMEM and SPARSEMEM_VMEMMAP, the page_to_pfn() is
> plain pointer arithmetic, so the trace event merely prints bogus
> scan_pfn. On classic SPARSEMEM, the page_to_pfn() reads page->flags,
> dereferencing the tiny encoded integer and oopsing khugepaged whenever
> the trace event is enabled.
> 
> So set folio to NULL before breaking out, the tracepoint maps NULL to
> scan_pfn of -1, just like exhausted scan naturally.
> 
> Fixes: d41fd2016ed0 ("mm/khugepaged: add tracepoint to hpage_collapse_scan_file()")

Added in 2022.  Why so long - do people not use tracing?

Sashiko might have a found a couple of other tracing bugs in this code,
which I suggest are on-topic for your patch:

	https://sashiko.dev/#/patchset/20260811133655.267739-1-vernon2gm@gmail.com


Also a possible bug mapping large folios which straddle i_size, which
is a separate thing.


