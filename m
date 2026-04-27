Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DB51DFF8868
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 15:24:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4D4366B0092; Mon, 27 Apr 2026 11:24:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4842F6B009B; Mon, 27 Apr 2026 11:24:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 39AAE6B009D; Mon, 27 Apr 2026 11:24:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 24C2E6B0092
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 11:24:55 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 820094150F
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 15:12:17 +0000 (UTC)
X-FDA: 84704676714.04.1B0F638
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id ACD8B140019
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 15:12:15 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=VNchfyn7;
	dmarc=none;
	spf=pass (imf26.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777302735; a=rsa-sha256;
	cv=none;
	b=3zmgsE59bTfVw+2zNnuduqBYsxrAl9j6YICRDQqC0n/OLgOlvtfKvth2EFtkQJWhQ0uJZZ
	5e3O7KXJsnp0IfxfuXBdFtojgdzsEYZKxg1jPJ/1fWlqp0aQgsl3Q3HRWhfTWt0ivAtdWK
	BfNUvAaVlQKP7E0brlshGdGOOo17HYo=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=VNchfyn7;
	dmarc=none;
	spf=pass (imf26.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777302735;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CVZHlnzs+kswBHtGk+WOZgjHGfxWhEUMUXQQ+xo269A=;
	b=bERd1iJpkyNnQE4hsWTD8midcBq5uUDL6/TXRxl+PJHOqEBRruPjXJsWwr3NBycRFrDDy4
	IpD/hEeWoWPJG/LunbwgJnBXzwhCieJK9/7sNsvKVjzTBH+NuYaPWI0VHMTctan62WrN+g
	ituXO536r5xlgAhzMpwFD9jLh556wtM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id F2B5760126;
	Mon, 27 Apr 2026 15:12:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CEB2C19425;
	Mon, 27 Apr 2026 15:12:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777302734;
	bh=F2b+BgWCQCTOwW+URnNYXQvaoDUWLyTfvwHMkvbYs0g=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=VNchfyn7ZVBpAYLhBCWBxxtf0e8OoTwEBd51jJaR8jYrXt0vHVBmMe98eAc6u8FU0
	 79ycQm6zD0OO+mwLfVS4YzPpa3yHKHU+tkO7nBYNEoxytZPzIL0SgGnqzLZZnmyg1P
	 HM/5VD2jpeuI4A4eaSuNg+d1vExW0Pq7k2ZdC98Y=
Date: Mon, 27 Apr 2026 08:12:13 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Catherine <enderaoelyther@gmail.com>
Cc: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 David Hildenbrand <david@kernel.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/hugetlb: fix subpool accounting after cgroup charge
 failure
Message-Id: <20260427081213.7935edd49d96622b08e81643@linux-foundation.org>
In-Reply-To: <20260427145247.84157-2-enderaoelyther@gmail.com>
References: <20260427145247.84157-2-enderaoelyther@gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: b9xwp74ow79n8wa9g64e494r8u1f6emg
X-Rspam-User: 
X-Rspamd-Queue-Id: ACD8B140019
X-Rspamd-Server: rspam07
X-HE-Tag: 1777302735-693220
X-HE-Meta: U2FsdGVkX1/s9c+n+gj8oyRw0oMFZ07aoe4pXo56C7vCg24BAzNoBsKb4sMzxjSr6V6JrElQCQgH2DVdSpvXNsRGetDOoIkuJwrLD9NmEA1o2Q/0bagWcTtD+KQESVnO4mxCUJQsyZPodB1HGFpOCEbx9RjLBTcTe52EXhZBMlku+8VtiUSNad903XcFjTncer1XdvjIkAVLwxk0NX5OskAJCn5aAhfp/4gxCLjZHzfnzcbanlJu60jxInBQwRsOCl5JTYkb8EhnZkQpWR1Yy09QuMB2TBl8ZaDjF9KW3pL0o8Inp5YRMAX+51GdlDixiWRbCKi7Y/dhHjRusUeAUEKo52IR8XtrQCOgEYPKixCDNRy/HGOziv+3LT5QfRPwCwl/yuo2K7yNFZTJPV9PXPAnDidItH2i1Ge0jAVNnlWRbNJeIvuxGFV/xXaXJaapqppLEaF683Wh2m6PUgMFQzJ0LFbSS5YVI5xwpV+Z6MAzd6x9gqm1HNbaGsRQ973yt2uXSB5smiSuBcWqhc+qwUN+8rpANBNwvO7/hXUAbQ5XEuQNAp8J7cr+aaeE62IdMwMBFPfQn+Me3YKAHHXEaJJGzXtxu2vYFIN3ue9T1E5MLiIvEx0tFdhcHXM/+a/TPiDnfreZlLiRAEdqhg0LMFmqHcNmVxJhS0rPkJA2JBoqyRluQRCSky9G1EJF6cCMC3H2t4C1TbZSW2rldzyPcLIK+bffPO8sJKgAzVRnQjwlhMzHyBfB5Deia79TPiRfBUFeBRrdSFqSQ23uZxg6VLfkmk42YneHYjuDH0ZHMTqVM9VmIokhkfl1UjjxsuMS285Kj27aHg4ROWJ+HIlqRwXlepQyTDBFZxj0o1KvEErpKA17jlf38ibHZ5UdLDlM/vL2z9/HokmDKabCz1Czv0DQl1vr2SubhrAniDOVdmiuOJPBkXAZVI8spSaJfjwpLcIBY3LgndFq5gXoJbb
 8zK7GhtO
 j+v6l66FT5EPfwyHnsBZh1zd5hIo8GzWnWSXner5PMK+knJ+wxNiuJzc2orGXHbD8lzUfcigGJRA0V+Jd9UjaYamYI5X1MkAduyz3ZRIx3eg2uRzJnL0ucJcrmQ+dcLCQsyYFdWYYMKHZuadsjZCt+RHeaOabvJT9N98kMk/+aFAU7KX+OAjlETI+ZoEoMOhhd6btnPfiLThPKdrIf7j7w+kvbm7c7fY/e1zDG7sNOmts7lk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 27 Apr 2026 22:52:48 +0800 Catherine <enderaoelyther@gmail.com> wrote:

> alloc_hugetlb_folio() calls hugepage_subpool_get_pages() when map_chg
> is set.  For subpools with max_hpages, that increments used_hpages even
> when the returned gbl_chg is positive.
> 
> If a later hugetlb cgroup charge fails, the cleanup currently calls
> hugepage_subpool_put_pages() only for !gbl_chg.  The gbl_chg > 0 path
> therefore leaks one used_hpages charge per failure.
> 
> Always undo the subpool charge after a successful subpool get.  Keep the
> global reservation accounting under !gbl_chg, because only that path
> consumed a reservation from the subpool.

Thanks.

We do prefer full, real names for kernel alterations.  Can you please
provide that?


