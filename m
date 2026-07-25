Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 71432C531C9
	for <linux-mm@archiver.kernel.org>; Sat, 25 Jul 2026 03:55:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BBD146B007B; Fri, 24 Jul 2026 23:55:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B45B76B0088; Fri, 24 Jul 2026 23:55:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A105A6B008A; Fri, 24 Jul 2026 23:55:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6FE1D6B007B
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 23:55:10 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B314316024F
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 03:55:09 +0000 (UTC)
X-FDA: 85025933538.05.4E7DB6A
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf08.hostedemail.com (Postfix) with ESMTP id 153A9160004
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 03:55:06 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=PzKn2Y8S;
	spf=pass (imf08.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784951708;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nFdW8Apb0lNay40VhfzizdVH02etiqNvRj5AEYt7aMk=;
	b=kjcRfvvrQl2axt5QaATQr2k4NlLjS8UZIWOMUB4RazYV2Yxs0kRJjATrnAbf3qb7ska+CK
	r06il8wrowYMgoRRu+KJSr6jBNs7P+8ING7eqNG9FnOPhu2EXvCPheNZFX6G7jnqAt5TV5
	ERS8j6DR43dC8PLNO1OuzPqnOvYgfZ8=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=PzKn2Y8S;
	spf=pass (imf08.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784951708;
	b=SMy5xvaBn848J3JxZVwrjoblX9D6iTDm9iGm2EbySywtE/wvj2bk1yatwrXJzHkARC2Qjv
	2tUA1WIClnk8O8FhVL0428IpvTUouItC4x84rUg/bO0EuO1YX6YYv50z7Q36CP9PaiV6cY
	l1pKlDtALV4M5e19cWLGAvieoNnSB0Q=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=nFdW8Apb0lNay40VhfzizdVH02etiqNvRj5AEYt7aMk=; b=PzKn2Y8SEq6X5iOWOyPiwAYTue
	g+9He0EYlQR5lEZMpSTfEKtG4pDe7N9+MxYmtTldz/iIb6N9C7gKsV0nJOuWXtG26wb065PEK0GpE
	OTxSZ7jPuP7AqTZ/XdbFy4GIBPs5y12Uaq+GqaXmWI5flM5yg55gz6eHGMgqSUyfSv65mzio+K96Q
	89Lt7/1PGQYn5Biivo5HB9DlOlsTA/+xp2GFvDnIXzm/z8AYY5yljz/lWCMn5BVR0Eb2txUyK+Boj
	E5xDsHAClQDzatZFDy7GygLc6dktx6PCTmwLe77d7nxkz6j6CEltm+OdcNUDTKVuXDqJonBYOp3DY
	VsstCmEQ==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wnTTS-00000005LGf-3LOs;
	Sat, 25 Jul 2026 03:54:54 +0000
Date: Sat, 25 Jul 2026 04:54:54 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Jiaqi Yan <jiaqiyan@google.com>
Cc: linmiaohe@huawei.com, ljs@kernel.org, ziy@nvidia.com, vbabka@kernel.org,
	osalvador@kernel.org, harry.yoo@oracle.com, osalvador@suse.de,
	jackmanb@google.com, hannes@cmpxchg.org, nao.horiguchi@gmail.com,
	david@kernel.org, william.roche@oracle.com, tony.luck@intel.com,
	wangkefeng.wang@huawei.com, jane.chu@oracle.com,
	akpm@linux-foundation.org, muchun.song@linux.dev,
	liam@infradead.org, rientjes@google.com, duenwen@google.com,
	jthoughton@google.com, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, vbabka@suse.cz, rppt@kernel.org,
	shuah@kernel.org, surenb@google.com, mhocko@suse.com,
	boudewijn@delta-utec.com
Subject: Re: [PATCH v6 1/5] mm/page_alloc: introduce
 __free_prepared_contig_range() with fpi_t
Message-ID: <amQzjkVKYBw4vf9t@casper.infradead.org>
References: <20260705180714.3708947-1-jiaqiyan@google.com>
 <20260705180714.3708947-2-jiaqiyan@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260705180714.3708947-2-jiaqiyan@google.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: 153A9160004
X-Rspamd-Server: rspam01
X-Stat-Signature: z1imut655rk95c7izf564m7x8bo3ipt5
X-HE-Tag: 1784951706-633043
X-HE-Meta: U2FsdGVkX19Uth5Cr3ObL/lK5YWyFxaomOoOYR6fzAHko917tuIJjUaBydr/QdYQpIH8PtfueP0sSjp9ZOO+QFC9h3VDpv+qHNCqDXq5uxoeho3dYXyOhHuxSg0K7cY7lM+klCN3QvS+Uk23shEVSDSQhlfxzKASocPQ/CyHm3M0MOU62Nb6hgDYKpnGD2YZZt95xUfShyr2mUnOJpRTXFawpdbYtKKssiFaDSPQcjuR9smn3+EdAv/szfiyr3KUjjc2WA1PG96l2eoKKxmdIRtYeg1ieyCg2lL993VVY9fXvpVYvvpnMYqIlEik0Aphecih3J8hbe0029aPfXT8YPwAMCbi0QoBFjwgKpiAapwIW5Fqpwx8ATv3WXgko/YWkR8ohOudgjSFC3kvdSEZjTkBMY5dtM0P/+PQuY0Og7fxZsrvwuwN8IP8jIOOATtba0vZ5HOkv3Nbar6JCIewD49tJiOL/HLSzX1T3zEVA9dtLrvaoX92bE91ouPSiQwntRF9SQ6Yyu27ko9sXKM/KXsMQcKFua2Cl7tRTJWGAWuiAD+a1x8T1TZnEQPn0BOD6iFIaOA/OPXEUbabuL54hetJ9xiQnOErlvkcwqAs+YqRtA/6bb1vJ41ONHQ6y6sKLvgyhetF6rjVqsknQGoY3Dnf4PUb+IPiebz9RvnSp+RyMUBsq87QtF0DvA95LwCVAIgg8YPRY4bDS5DscYuLqxtjCxdv9C0cA0Bl+w0W34hoaXk7yxg9TU6Zg3OIK6jZCmUMqoYT4kvcyNG1JHjRbDVyWPmoOohI3XyBLCGhIab9B5nS7vir6Q4FHE4u3f3EuJ8LM27Gd0trfd+VKYomIYa3VmG1SdKaq2tkqH0WKFp4z49N8d+hkKFaWXK3FmBPHpJE19MG4bg8ND5DExW3qPF7ECrzt6ghwBr8yeZ6OB7OAuw6ITpmaOtbggFWX0IeUPq/mqs8VtlBNtjQOOV
 5xjLr04f
 JKawpNwzvtEHwxcjw1d24bLewLS9//RLVE+GHU4b828gpJbvT85ehMgTYZesdhoCC21EuOXlrVjuT7IJSlBdcEKIAowSz/7O+I9gCtC5yUewlYRfN6YB0q5s6oiWaESiVgpIwjHL6AQDeptkHfNdI0ZtHlUt+UXgTo6wyr6D4+WHg1yfWPRSvW/kFDQ3DREGhIOtqa8+tVITIX0XO7u6t3Xngnqi3kwktzOrjzDqla8HLUGu8En1wskIWhfzyEuewgw0ZrtvJt2uVEhDUvIqd/6Ww+68CrHojd6EFCInTz0Jnptm7ilLg5QjZD4iIr2xZdgwirwipF2b0lfNch9DkkeA0tXvpLtKDSOKuos95Q68aaSkwaO2jYq38Kw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Jul 05, 2026 at 06:07:10PM +0000, Jiaqi Yan wrote:
> Rename the core logic to __free_prepared_contig_range() to accept
> an fpi_t argument. It bitwise ORs with the required FPI_PREPARED
> flag.

There are only three callers of free_prepared_contig_range(), all
in the same function.  It would seem like less effort to just
modify free_prepared_contig_range() to take an fpi_t than
introduce this wrapper.

