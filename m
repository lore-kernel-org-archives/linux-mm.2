Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AD06BC79FB3
	for <linux-mm@archiver.kernel.org>; Mon,  5 Jan 2026 19:22:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DF02A6B0088; Mon,  5 Jan 2026 14:22:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D86236B008A; Mon,  5 Jan 2026 14:22:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB3006B0093; Mon,  5 Jan 2026 14:22:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B7D696B0088
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 14:22:55 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5CA141A8B93
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 19:22:55 +0000 (UTC)
X-FDA: 84298882710.26.24E812A
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf23.hostedemail.com (Postfix) with ESMTP id 4AFC0140002
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 19:22:53 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=XijhedJX;
	spf=none (imf23.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767640973; a=rsa-sha256;
	cv=none;
	b=StZF3MO9VaLSNyDaqrV8OEdulzR8968p8p3lYe6STgnYVp8wX4thvFZskXN7fLM3d/HoOZ
	opekMtGWmzXFSsnIJi7kOzZuM19TnRliQBs6a+U0MU+tjcJe/o32HkF8O7+fziXUWWxjzP
	aFG3Zyve1RMQvNmzVNwmKfN9bE2WUxU=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=XijhedJX;
	spf=none (imf23.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767640973;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nxsWQReWfrEsWRjo7BoK9R4qD+JXWnLHpt9ToOHJKpg=;
	b=iAYurUm2hoyRiFqujw41FMudU6xWFIULL+bbo7ubgNWytEeuFMnSH/Ermb+TqZ7ZkZTLlx
	SmAR2oReXgyRtm67PREvDaV1v1IE+B1S2OhHrI1kZF6ZomJBU4qCmouVgw91gwLl5mxdAm
	CRgMs9X4ByE/TfbqmVq+X7/5ylL3YCc=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=nxsWQReWfrEsWRjo7BoK9R4qD+JXWnLHpt9ToOHJKpg=; b=XijhedJXgdEChgR1jqcastK81F
	pYG6KQqkLkN/+LDQ8l4z/CHKDo/NtisMKIOfBLmhHs+T1sXX9e+DqnS+Xz04lTsdB3QMFj6X06v6S
	OU4oID84C3UsonqZLWUUCreEGScadhD2x5o2G/A8aBcKJWH+8ZvXOwSphJhl78FiajM/c9N5g/yA3
	y/b3wYyMdqgT4n9iJxXaUhOevP7ODDbgsKJIEv0HqG5hir5Lla+5kIDfQJf7AO/i+fOXK+bcJlgIc
	cPRjbHokwgbNNKgNMenzKY6DsatKbT7JG+S4AiJ0IH8Bsje3deqFg1hAK7jm9BeNNf1f8Mv3fzk+p
	eb0vVbJA==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vcqAE-0000000Amk6-1bx5;
	Mon, 05 Jan 2026 19:22:50 +0000
Date: Mon, 5 Jan 2026 19:22:50 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Calvin Owens <calvin@wbinvd.org>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: Re: [BUG next-20260105] khugepaged: kernel BUG at
 ./include/linux/xarray.h:1441
Message-ID: <aVwPii7dfR5owHbV@casper.infradead.org>
References: <aVvz3tYdu49TGkjI@mozart.vkv.me>
 <aVwB3t2wD6Dyt6yT@casper.infradead.org>
 <aVwHYFesgoSSbKmz@mozart.vkv.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aVwHYFesgoSSbKmz@mozart.vkv.me>
X-Rspam-User: 
X-Rspamd-Queue-Id: 4AFC0140002
X-Rspamd-Server: rspam04
X-Stat-Signature: 8t6r4dea5frzs3tfdnm4p1smkbgckpqj
X-HE-Tag: 1767640973-394169
X-HE-Meta: U2FsdGVkX19DKVOE6a32sGJ+4Kk7i0+5cOnWjvM//OCC6ocUplq0BnC33sF4Fl5TN0f9IQiW1/54WQxcAtTwCj4vTbkamkDBpq0NgyNtpWl0izGzVxtdygD8Odz+oDwc/p48N0Z3xR/K4d1ZArQ1apxNhdo+gctVhHvXxgKkJSoe7SPMrWSTYmfUcROaOaIVtvJ14ngFwc+VrGgPzdjf2uvyptu6VtJnV9+5Z2RjP+2SFDL8/8slBvOAr1JgriK3mn517cYyLmkAc2WQSJrAIhmbM3aoo3AE0jHhLaFakMel/7PY4izuysSIx/wJ8d39bomFbzBhMEcy07fualYrx/7age7LkmYeeIgsv59qfrAwzzcRJ6K1QvspGuCx9Z00Ey0Dml5yV1/1pUhXosk91PyVxQAOa5ZWwj8of8w3OJeBrS6XUWr0SEaEyLbDPsjJmkdy2zRFPcUESpNCjXBgvPXXvde3kpc7Il2SoOx+Cn9MIX2wF0+han0yoHLJ9NZV6sePROyqO47558tiaH4pvoKrZWrVgPzWikj57nzxmfIOvdb5Sr29M/vFfc+wgWAlFuu476epxkrlo61N5ztg+NhUGG4d/A3PY6yfim+rQ6b9m4dWZlX3JNEafQjw3q2X9ls0zS0leUrx7Qppo5BXdKlhM+jYT95hyCSxfTkWDKzPU873CmorLtODQAQ3XlYMW+UguTYSkFlmevnzRVmRNdhCw7u+mBwDFQu7xk2UBb1LZczxzKpu0G7GsbfxWeKEIrEofduCsfD/NIVZvYX82aMndZrqeXzcl+cqqVVXps/1N2EfmRSD1o0MPJHDlyx+45cC+z1e9hV1EQBxt+UCM2MBFa3uITC2HSHW6F3FcqUCVKDc6JuZSs9l4eIpIY9aSXlHRF00za91oKbmt/8IPDKEBodrBJ2ZIi5X71mLmMjYR9KxqKvIodPua9RtxW0YvRUWV5eZCc0FK4x8KlN
 aqexaF0U
 N8+dkcaxkf3IQXED8/Mn2RQLgZfKD9GEpnTZ1uEcHUPH+puPlnoKspAMRfv2ea9KEzUyJT0k5tap3lC6eO42D+naRN3KWYVlvQJXExpD44Wt/U+dhlA1R/9kebRwLm6Qn2l1PQHLs2KuT6o66BdrBoCXMzHrMX+RZkmMbqaT5fbPLdte7+vWVKbo9WvpiNrOnRD56fKKQ5MiCt0crTRhiB5yhLSk8yuXJ1lG1r4L4ljNvGvsfuZht1Ox/7A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jan 05, 2026 at 10:48:00AM -0800, Calvin Owens wrote:
> [   16.042275][   T58] RIP: 0010:hpage_collapse_scan_file (./include/linux/xarray.h:1441 mm/khugepaged.c:2042 mm/khugepaged.c:2389)

Perfect.  2389 is the call to collapse_file(), then 2042 is
xas_lock_irq().  And this is exactly the kind of thing we want to be
catching; we drop the lock, then reuse the xa_state.  In the meantime,
the xa_node might have been replaced, and the xa_state now has a pointer
to a dead node.  It *might* still be safe in this instance; I'll look
at this carefully for a bit and decide how best to fix it.


