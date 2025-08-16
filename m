Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80F14CA0ED1
	for <linux-mm@archiver.kernel.org>; Sat, 16 Aug 2025 00:50:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F1AE08E022B; Fri, 15 Aug 2025 20:50:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EA45C8E0008; Fri, 15 Aug 2025 20:50:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DE1B38E022B; Fri, 15 Aug 2025 20:50:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id CF3968E0008
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 20:50:47 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 844CB138054
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 00:50:47 +0000 (UTC)
X-FDA: 83780790534.01.38FAADF
Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	by imf27.hostedemail.com (Postfix) with ESMTP id BC75B40002
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 00:50:45 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=i0lOVaBK;
	spf=pass (imf27.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755305446;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JYBQzGDsedWj5iS2Ox4ruwlLXhsJn8Up52SCqrZu26M=;
	b=xPGp9NRNW79s8ULsW1rMhwg2xqbRDv7V1O4a4+14efRS8Jm0140YhwMWljPu2PH6paEXOO
	dyUj+vDsg88KvPl1ITl8iWr995+f8J7HH7jlfw35mj5eID7iSZKt/OqczxrP8unTJa86sh
	88RHIfU1mTOevX9PJ2j6Ub3YLF4Oyuk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755305446; a=rsa-sha256;
	cv=none;
	b=8bySyus+EWoKtuGAXmJSbG1T8YK+uGeU2wEeUbMLOzskitC+DCftakaLYFiJep9M3t17fh
	WOH/3hUgC2wqQlX7/jAoPHrGRpy2MiOYm0dnKt0UgLHUbBOxV22L0XM4u7zEXCl1NbUJnj
	RHXQs1VGBCs+f/0F6mqLmpv2h1OZS5g=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=i0lOVaBK;
	spf=pass (imf27.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Date: Fri, 15 Aug 2025 17:50:28 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1755305444;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=JYBQzGDsedWj5iS2Ox4ruwlLXhsJn8Up52SCqrZu26M=;
	b=i0lOVaBKU/KtRy5RzOuMa+9ztCY5xKPzokqbgv0c5rfXlz0ju2FitYrkJSKPEa04WUvNVW
	3Z3QZxn9GT6+kmc3Buh4o9m2Bsj5woiXutsudPxwLmroN7utFdFyI8vkrXaUKS7vXFbDnl
	qM6IGgXhuydH1vqKEqay57nkoZ1OUXI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Boris Burkov <boris@bur.io>
Cc: linux-btrfs@vger.kernel.org, linux-mm@kvack.org, 
	linux-fsdevel@vger.kernel.org, kernel-team@fb.com, wqu@suse.com, willy@infradead.org
Subject: Re: [PATCH v2 3/3] btrfs: set AS_UNCHARGED on the btree_inode
Message-ID: <mlfxq3ocdmnzvpykzo3zmeebdv5rpohk64aevx3fbwvmj6xitb@ebxlwsd72utx>
References: <cover.1755300815.git.boris@bur.io>
 <786282400115bf7701d7f9c6b00a9549f67e29f7.1755300815.git.boris@bur.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <786282400115bf7701d7f9c6b00a9549f67e29f7.1755300815.git.boris@bur.io>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: BC75B40002
X-Stat-Signature: kmriaz6eiy5us6oyxc8wk4wjqcpos9et
X-HE-Tag: 1755305445-219295
X-HE-Meta: U2FsdGVkX18JlZEGWMksJfxZwHKoMDc1fOVaQKJOnLlhkIeE3drmDReOsinR+glaSa5CB/b51uOHJYu/DiP+lq5gaYhYcGciNDE7GmgAkXZwiggqUCjCwcwW1dcoaNcSnMH01WW3rTstRWbofuDTJlDPDiEvoRU6p2IwQxb90xbFeDQ4TT8eT1L2BcPi6uhEYK/6xceKiA7+jaM/7aS3wr46J7V9nui4dLXJL95wLOC7M4qmwE7ruHuF9b3RfX+n9OmwOKlJ7i1sVnqf1qNSU4AtYpH6iUOKxNrlMhzp2P+4paoseG2zOqpatCqblUsZQGKNXHMkkUaZnTb2N1qq0XjEHmUtqAybLiavubexLzS/oNIe2h2aSiHrW+auvsxHR/IFbv+jtAYZ/oiELXl43ozmyX/S/rBLTUznZ41fqd6qRwkkRTTY9zq42cEagV/bR6P9QqxFFNaU+KjyaVZMrFgYBUf1ATXlDMJ1l7xH820eVlCMahyA8V2cZ1+528yjdJlwpJrU2ZLuPeKRfYF7NScWEzX8IoxpmGyPUBb27ky1beZiO7eWHSj24ygPb/NB1LGSTPg5NaYvubUHBNhqrIc1qtY2cW7X3hLWZdPGVz0BgMVZYmdfyxTkWfw7CCabSXh6po6JARGf0GjN687w4bNpmYZyz0EIvG8jHdz5XwVnZ2fhHcjqb53lG3yc1YNUv4yjZ3PifaqLfZ4Unzv80z2ww1fNJVLQOSmL/koP1Fp/qeCNVi+K3Mk1tUNxdyHmqAJp7qxrxABHh6Ou7yuf6RS09HH6nIZ1xU5QfZG6JSMElgMpKipXLNA5IX+Da6nvhyfwpVGr0hSM2mYYAmaTr176/nZeFVgdZtLB6AKiQHROA4HkU4VJXc9eh97JeLek8l6hnCYpXmswW4LWND1JXgWCprQfL+tnjxDnsFmexQuNHC/IB5IWfeAxAC3SCqhxff52g8Q2teyTb+r7qVy
 ty7PqzVD
 U3rd27tvZIl0WC3tls6MahngaTbc2HAzZsLoN3OqOrbpnW/xL8YzzmbjC+cChxoqnb6izvls/eHkVIYZHywad4C4aJ5hl0rj61VAsJCXVQO/t/gQ+H9R6sNHh7VSzW5vqiQ2swZab+1qf6UxrzmednLin7KAlSwclVB1zHEX9KpKEm4/FCSEMinvfR+UKtrWf0CbU9g7bbOB7ZOwdSoQQlaauvmBnV/129svpB5sB9N8Th/YZSjEGoFhGJVhFhcM6uqP/
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 15, 2025 at 04:40:33PM -0700, Boris Burkov wrote:
> extent_buffers are global and shared so their pages should not belong to
> any particular cgroup (currently whichever cgroups happens to allocate
> the extent_buffer).
> 
> Btrfs tree operations should not arbitrarily block on cgroup reclaim or
> have the shared extent_buffer pages on a cgroup's reclaim lists.
> 
> Signed-off-by: Boris Burkov <boris@bur.io>

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>

I think mm-tree is better for this series.


