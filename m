Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7019ECCA470
	for <linux-mm@archiver.kernel.org>; Tue,  7 Oct 2025 22:34:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8BFAF8E000D; Tue,  7 Oct 2025 18:34:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8707B8E0002; Tue,  7 Oct 2025 18:34:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7AD468E000D; Tue,  7 Oct 2025 18:34:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 685CD8E0002
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 18:34:28 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 163F2586B1
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 22:34:28 +0000 (UTC)
X-FDA: 83972773416.09.1470F91
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 592B28000B
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 22:34:26 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=swC7I8sH;
	dmarc=none;
	spf=pass (imf02.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759876466; a=rsa-sha256;
	cv=none;
	b=A803xfiE5n07ooc36CHcrScnk+zuU1jG9RamiUhO+e7Lfuqrfgl4ZX7SRMhohx0JInYhpw
	zbulYlN1E5nstFUpCRZsTAD22cxtH3KqCfZdF0R6uezTzMuskk0LQvEhbI2iITsf2lmzYQ
	BI9tCVKLz4yh87sl1HsxkZmqa8XObeQ=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=swC7I8sH;
	dmarc=none;
	spf=pass (imf02.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759876466;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=G6cX6SLs2dhLvJpmkX/eK4MzDvKkOKzae/G89jQ0UFw=;
	b=6QD1sqh0HsMdR6XSp29wVTdKQmGTlxBjtd9DvuXKbzog08SabWaRTfjQ3h4zjw/kupndnZ
	1T9PCth7IdJNgkCEnffKdJC0O+O1YYVAieiWWppF4rslG5NR0hdUP1yWrR/cXcFwuYjYc9
	MR5ctmSX2Pl25hofhGV0VcUbDtCl5Zs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D818344FD4;
	Tue,  7 Oct 2025 22:34:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89D0EC4CEF1;
	Tue,  7 Oct 2025 22:34:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1759876464;
	bh=jhp6SV6anK/PGrNJeEzIoxrnja1H0V2Sd5G7xaZKuWI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=swC7I8sHM52a/RUTuobaO6U2Z4PX35vJoB46A8XLLwChLLWdb+tjlShuHSqhLQq/B
	 3lJAyXE2QD23pkR+FfzBmPgbomh2ciDvXhc3eqHLuJ76BcmmIRLytZA6MWtU5Q0LVp
	 fg8Jt7Ecc9lQGppPfBliHnBE7PK8ug2SG3MSgpKU=
Date: Tue, 7 Oct 2025 15:34:24 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Roman Gushchin <roman.gushchin@linux.dev>
Cc: linux-kernel@vger.kernel.org, "Matthew Wilcox (Oracle)"
 <willy@infradead.org>, Jan Kara <jack@suse.cz>, Dev Jain
 <dev.jain@arm.com>, linux-mm@kvack.org
Subject: Re: [PATCH v3] mm: readahead: make thp readahead conditional to
 mmap_miss logic
Message-Id: <20251007153424.1b46a4018e17d5dafd7fb126@linux-foundation.org>
In-Reply-To: <20251006175106.377411-1-roman.gushchin@linux.dev>
References: <20251006175106.377411-1-roman.gushchin@linux.dev>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: qgxizfbadbcyqwic6pz7yg9cwbw7kjcz
X-Rspamd-Queue-Id: 592B28000B
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1759876466-918145
X-HE-Meta: U2FsdGVkX1/jR1YUND67QmasW3GCVSEqMbSGMOffbJMm1EqVSFf8nzdyIUSZIjdzQamkHhX9XzDtsjTOxr6UsqHOO2gtv4UUdSom/RJ82iO+cpiRVgeaqdl1xHHBxMV0++NCoGZ6BQU4ERwAJOCe0kD5cpb9nygOSaQBPel/73tVv0UZZGExZ5oiIMjCp7z0O/wNK9CSQcVENYp+YfiFmhXe3j9LC7sJrODcKd9kJeaSTYVHba/dqb2H5rnfgFSQLrvwEXcY6A/w0efp9ZNiwNa1clg93fy02dnvAp6VYNym5GrZCPE6KIbki/BKAL77tJy9IKWKoJL2+gK5Y5NI3KjIIgRL9Y2wj7WtjxMqP4vdRln5DaSScw64oO5wNRmykhoYSm9Afs5B8HBW9ZCnBBlcCd21G+IZcWTmZhyWZzf7GCiX9KkvhJcivC6OAn8e5Ojp4TErfRjwwlPc/5Wy3Pm/XqszKVkEC1nMzj78bMcFJ9CnM9fxVLZzE1gjoQuTAsx2w5MKtdbbABHXJ1s+aQDa4CxbjWiZqSRYaDo68oW4z1ykWZcjSYM5tQ1M6hyeyoc+VyhvsSOe3+Qbp5+/aEJGCHgQUtkpl9XwwvXDf+GAjibbp8rvCwMBlvxjWfY8b00gla+wpcTt3/Wytq8aNiAsbieyfbJ+b/XdrMd5r0nkK5Q2flCvW24ANlrXDqz5moRmXej9dcdYhHsdu9ORGoCfwUuZSZR6u17bHHOLmgzZGATl0HlLWCh0KyWm2mcbMkpY2So3nukC9uSSdJAgxvzCOJ8ykujS4hynP+LuxJG9Kgk3zkjCHlZFDAPyvA9km23uCrKSFMV0486AjOU3EZFniI8xv3l7jCkD6cUa1xGT1/oR1OMxG2QbBixYSBonMCv06pbDt8Mw25xqYav4AAbGMFs6cT2jXKtlLC880a+vdM787gO3i79C0VzMDR4bYmKIR09yTPaocwiUuLw
 sbh58wrA
 PSYVepZP60oi9mpikPNDRGoL6W68e2qAbrbiLMdE/7RqkJWLyvu8vWth0I+ICaMZXCz+P/gua1WmdnSzpWwIiPwXEIq+nXAsPERrUghRuM25Srq2QZ63C7mLszVzaWxcnjdhT8RCE8Na5LX96GYZOCAGh90M/NzDn8KSIq+gq5B1NZik0f9PfUql4Qu7m+21+0MPJ3omhahRkPDnJ14KVIfwQSmh0NZxdZYfvmxaa4R3uq3sopKcaY+/GLX8/5Gn/cg+lVC6LPllDhAp/dsfX/SYnkiNmoP763vbKfz/Q6ij5PD9jRcFVJmzr78bND2SipLu1fhQZt9Zev7jOAWOK+ar9d0mrMshpufrkQeFFKFw/5ttux09YlRYd4/0wfkIV9bT5Q/sM4qa8uafz82k+3TdH06zaZc5GPqWt
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon,  6 Oct 2025 10:51:06 -0700 Roman Gushchin <roman.gushchin@linux.dev> wrote:

> Commit 4687fdbb805a ("mm/filemap: Support VM_HUGEPAGE for file mappings")
> introduced a special handling for VM_HUGEPAGE mappings: even if the
> readahead is disabled, 1 or 2 HPAGE_PMD_ORDER pages are
> allocated.

Three years ago.

> This change causes a significant regression

So no backport suggested?  I guess reasonable given how long 4687fdbb805a has
been in tree.

>
> ...
>

> for containers with a
> tight memory.max limit, if VM_HUGEPAGE is widely used. Prior to this
> commit, mmap_miss logic would eventually lead to the readahead
> disablement, effectively reducing the memory pressure in the
> cgroup. With this change the kernel is trying to allocate 1-2 huge
> pages for each fault, no matter if these pages are used or not
> before being evicted, increasing the memory pressure multi-fold.
>
> ...
>
> Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
> Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
> Cc: Jan Kara <jack@suse.cz>
> Cc: Dev Jain <dev.jain@arm.com>

But I'll slap the Fixes: in there, it might help someone.

