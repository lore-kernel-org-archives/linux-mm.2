Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4B9F1C5DF9C
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 05:57:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 318C16B008C; Tue, 25 Aug 2026 01:57:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C9C16B0092; Tue, 25 Aug 2026 01:57:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B8556B0095; Tue, 25 Aug 2026 01:57:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E84E96B008C
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 01:57:13 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A5FFB802D2
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 05:57:11 +0000 (UTC)
X-FDA: 85138733862.01.1DA0CB5
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf17.hostedemail.com (Postfix) with ESMTP id 4FCCF40003
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 05:57:09 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=4hivPyVH;
	spf=none (imf17.hostedemail.com: domain of BATV+b87911c0b4807dbed12c+8402+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+b87911c0b4807dbed12c+8402+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787637430;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3n8sKxOLY9bY1Jljt7EDfRL2ryQR3dKEADtbegGl4j4=;
	b=sPlBlCNyqVbnbHKxP0dixv7B+OhxAPGOb7zXkxzlqXO5Qp6M9atmn4TvtSHtEYoHnUlNxC
	JY2wUwLKZ39boPagbcrHFOikez76JlB6rsCzaVLcQdH+4/stXmyKLQNhJbRYRN/rig8Lol
	qUzXB6pkrbWL2k/LF5Wcc5/gc/4csYo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787637430;
	b=ZZfXAcxrmM0wOjom6Qa54PfrEfsZy7V+qLMMZOk/gpo2WYHhsoTwWQmoWHYBBmcBI+oZEq
	lRBfZSyQXNtbVT6jfBTxKHE1XJchXn+n19GSe2b92pEuzn+4haZjpnkzhcpidKj9kcA3Zz
	w+MUNUDcwZVps5XkxLJT6nFNR9yRY/E=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=4hivPyVH;
	spf=none (imf17.hostedemail.com: domain of BATV+b87911c0b4807dbed12c+8402+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+b87911c0b4807dbed12c+8402+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=3n8sKxOLY9bY1Jljt7EDfRL2ryQR3dKEADtbegGl4j4=; b=4hivPyVH/E7aqxa198tsBYDhtT
	pheZRlehn97+Pn+qzZaamy4FMBMqTsG+w+pkWof61SjtSa9zehOQ74t1NrJjVEf9r/JJsmeqJyLa9
	fBTbTLLiYWmmi3cTiTHnpobC+AzmGunnKistH6FS80+HKogiTyOLdD1uCZEHaPATXdecv2Y3kzsNb
	/EBYP+I/hoJIhzQU4bobyba03Nfl/g65gyYRW0qqrdo2uJn8rvlut1397NlYgCBj9E6dLPWjKUzJg
	MUKlmO/qw1j5IIU9m55sC1Y4+KFkL4YbVaa1aXZC1jyurhvheXv+3OzXzdThqJMPuoxtd6icvr+DD
	05wedv1Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wyk9d-00000000Cqf-15be;
	Tue, 25 Aug 2026 05:57:01 +0000
Date: Mon, 24 Aug 2026 22:57:01 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Lance Yang <lance.yang@linux.dev>
Cc: pfalcato@suse.de, kas@kernel.org, usama.arif@linux.dev,
	hughd@google.com, akpm@linux-foundation.org, baohua@kernel.org,
	baolin.wang@linux.alibaba.com, david@kernel.org, dev.jain@arm.com,
	liam@infradead.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, ljs@kernel.org, nico.pache@linux.dev,
	ryan.roberts@arm.com, ziy@nvidia.com, nphamcs@gmail.com,
	hannes@cmpxchg.org, riel@surriel.com, shakeel.butt@linux.dev,
	kernel-team@meta.com, stable@vger.kernel.org
Subject: Re: [PATCH] mm/huge_memory: transfer the pmd dirty bit to the folio
 on zap
Message-ID: <ao0urQFF6IOFAorx@infradead.org>
References: <aoXYh9EPF6QnlvIK@pedro-suse.lan>
 <20260820061337.24669-1-lance.yang@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260820061337.24669-1-lance.yang@linux.dev>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspam-User: 
X-Stat-Signature: 7ei811xxjf81r6mwre61mfgwud5ug1oh
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 4FCCF40003
X-HE-Tag: 1787637429-192274
X-HE-Meta: U2FsdGVkX18gkPG0FThB+96qATjxiOlRBjG893L+5xPQf7wRs/qbOUKGl1EsriUjv4OiNMlA5psFV2/zbriqhZlKbfqnUqS2qZ6i0AGrpotZuVgmseJlT+GsSNTaVzKsRId129PjsOTk0gvNHp4IM3h+eBzIRT1vL/INXOfKGv8e+/CbsRvI1FRpigGtn4OO6tANdw2YGWt9tZtPZ1xSVBHG5Wu8EqhM6dZq6EAViUVdXJ4pn+J5nwKUMo1wUIV9pHPGxmQMJV0es8m55YJ3kTggXq+yO9QXg6TB9d0YmIvYN1c4SPtFlYgO4yE53ni5aCqun7kWmOCIpB+QR+jYqizicypfR37RZOL+9lYxUxszNg6x1WUWjPugV2yW6RvCNhjPjJRHXn2K/weaYYIH4VgnU9b9PwnjwCAA0VSzEJ1FVHsxz98R5mMuJg+mnDIX4pHfc/Dt0uy4QJpwLbiI6Q+s9xYwFuIEGFouCGL8mN/s4DR7beD8N8l+5573DP8UeX0gZH3Mbg1M5fS8XQ2Q/kmTliQPaIhqc4+Yu9WRRunHbFus7wqV8X9KjTc6/x5A2uU3np7Wym3V+W/eyVNMKXE7/yIHOFjqn+rvA03WnAJKcFGIUepavrwccPqMzSHX16IW9pcQWyLNUtpoB5Fbf/uM8Y57FGY4cgu+TV/sqG+XCWcHFo/ob2w0ycEKgdHQtMJwhVvpny4IQoiuTUxjbB3rRXuLOKjTIGyBuwtzdpUqNQ7LgA71sjsYFw9KUzN7f0e7UVxI++I38bX3hbq3IXImH8T5IDCEMYCNyiF/JToOLOUDLR+jcZ5Xw01z2Tg5OXaE3rRIOCACVIh+ievNJDWujsH8CnXX+53HF4imi26f8OoiT05VQYYpiRV52RHItABXSEquOmHl4Qvf3S6y+CQcPVsRW9IW/mWSW8jldagOLi06cKjcI13Ztl81IOfpDImAhNY5UoTTzFF8/um
 pXdoYUTJ
 2rA9eRDK+BkPug8fX8rX1EYpIVM8rWeLbUZfrA6DDLygLFOOgWpOnrHMxGd+8giJi3GAd/gnhUG/hbEh8brUJ4Gb0rY47jlqP7mcaUF05vKV9h89yPc0P3BjoD/h4itXyeRwRVf2Hg9Sv7SZroGa5Z+/UcqUkVbcr6To26jFvv6KaSG/wa/S+FUZ+NrbwidW0u4n5BM42WLQj2IMc51+3ML5EgpCbyTtcp3OiVs/lz7G7xK1OTUMbmQzpbG2VrVKQEKSNegQIYsDQ1I6ghujNYVMLrDX3327DuAUBdqaR298aGkFkj5wyD9cr7yGQXLzdSHSu4zyOJA+ot1IU6xbebmuV1CREjiLgw2spJmhys+WqVs7Mv3iEMut27KnGxQasXUm1IsWpNrdqnsDBImSFONgQwbbZ+gDHRCSECEOdeMNX4ADo58IEYf8PCALSUV4bJUlp7wC1UnJlkHAuwOGm4WW23P9kQuE4aLAIAPISVU584w5vyf4NFBEEGoBorc8LyqCwH5GtrfvlunUN2UtvBljeOkIz2ipOB5WAhGE7Ez52/f8L/oQ/DGs69uN99VhGw1RP6kWX9yCtcrM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 20, 2026 at 02:13:37PM +0800, Lance Yang wrote:
> XFS installs the huge-fault, regular-fault, and page_mkwrite callbacks
> in the same vm_ops:
> 
> static const struct vm_operations_struct xfs_file_vm_ops = {
> 	.fault		= xfs_filemap_fault,
> 	.huge_fault	= xfs_filemap_huge_fault,
> 	...
> 	.page_mkwrite	= xfs_filemap_page_mkwrite,
> 	...
> };
> 
> On the fallback path, handle_pte_fault() leaves an empty PMD without a
> PTE and calls do_pte_missing():

Just a reminder that it would be extremely helpful if we could refactor
the vm_operations_struct so that file systems could register one single
fault handler to cover all these (plus .pfn_mkwrite) to remove all
the annoying boilerplate code in the file system and the confusing
fallback logic in the VM.

