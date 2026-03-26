Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 845BC10AB808
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 19:21:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A1AC16B0005; Thu, 26 Mar 2026 15:21:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9CA916B0089; Thu, 26 Mar 2026 15:21:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E0B86B008A; Thu, 26 Mar 2026 15:21:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7C6BA6B0005
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 15:21:30 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4BDBAC3B17
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 19:21:30 +0000 (UTC)
X-FDA: 84589183140.03.DE1DD3B
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf30.hostedemail.com (Postfix) with ESMTP id 905FC8000B
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 19:21:27 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=hxPsbjEH;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf30.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774552888;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7gv3RRqjtCugysMfLD0330dJ+E6bzXxwyRRm5BMEPU8=;
	b=GPE4pAeZG7Y1Vqk74dB/k10hjdW6W82YscO+RcRmEw6ugNON1PSeUwGIWhtBdpbQw1vEgM
	v7YbSx0xuYWdhJ2RMGdlNQJJEsk+HrNCjgdSWN/dYRRIIF276Y8kWVVSRU4UrB5AfnpU+b
	uQW6fL8XuF7WnQyTcWMe+QwlnVOdrdo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774552888; a=rsa-sha256;
	cv=none;
	b=h4tD3lFX5BRzuKVjOtfTe+AQYxv9gDVPOP9j6hdOmD0YB34gg++mxh4RgUAShz8AV24pwi
	YqzXJrwxVvqxNqyqQZHYMGNNQm2QUBglQ5SeWxRnliVDIFCj7TDs3akPWJXR00DuZIrEBp
	5UayVrjNTNwzr9dNcQbDqIg+bxK9a+E=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=hxPsbjEH;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf30.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=7gv3RRqjtCugysMfLD0330dJ+E6bzXxwyRRm5BMEPU8=; b=hxPsbjEHxR1+gWzqYEyhseSoeE
	g1GTfN4qhjwZq9fUwHgkonFxe/cHMkO13ZSpTV18uOoi1CUBon6p/yG5bU6XbBA2B3QkzaN3Edd6v
	ksXQy/I2Ax4SAtLKU+AlQZG3TXybUEL4or53vB4Ot6N9hcHKzYRevMZx0AUCAqswRd9WPVpDNqpPF
	8R/UW3frNF0I/EQmoVHKT3P1p9CN0cBC4jLDo33VLl7Ep7hjlpJe8/zPPVM3NtmjP3sF+T9HKUDg0
	XT9M9NBC85mUxfq2E5RS43Ss2m6L5UiyEE+XH6ipdzqVMth9DqFjFPRZnDDQaj3tdpfgmNk4o4+IW
	h30qNMrQ==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w5qGf-00000000XBq-39sL;
	Thu, 26 Mar 2026 19:21:21 +0000
Date: Thu, 26 Mar 2026 19:21:21 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Gregory Price <gourry@gourry.net>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, hughd@google.com,
	david@kernel.org, ljs@kernel.org, Liam.Howlett@oracle.com,
	vbabka@kernel.org, rppt@kernel.org, surenb@google.com,
	mhocko@suse.com, baolin.wang@linux.alibaba.com,
	linux-kernel@vger.kernel.org, kernel-team@meta.com,
	stable@vger.kernel.org
Subject: Re: [PATCH] mm/shmem: use invalidate_lock to fix hole-punch race
Message-ID: <acWHMQ2MPFjOSq5T@casper.infradead.org>
References: <20260326162611.693539-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260326162611.693539-1-gourry@gourry.net>
X-Rspamd-Queue-Id: 905FC8000B
X-Stat-Signature: qnhsabot7owtj4r3optxk9681kjjb35h
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1774552887-76868
X-HE-Meta: U2FsdGVkX1/KwxZC21EXROWphYnhueycLJEsONlZUP/ZPjwo5jtnNObealovzQa7t+zydfg3VtLxqReJNpxfRiEJekBe57cDkp9ezvcOUFrkVf4GDaFCOwO0rqc40HFzvPsKz+C5YrIvQkt48t+BWPYkS4LmcOg4K+T/9DgDLaoJQOgJ+CeQ9P0SVVc3DhZ6SiHUDDWaRpPjL7xv7CzamZivRzgdD+skgTMSlWObXnAQrAOmU4fq9Fj8rRL8CXssUhdscaXXxkR8hQexCF3s+t9zdPsBw7bi0wDVV+8ogffW+bUFt5YjiClW5rIE6S3ki9p/RKPzehT6gvrZnu2djvGQ5q3KoQg+QnIZ8BUrHp+T1YNllWlRsWyuAWvI+ok3pikJq8vPjbicERHFwZerWqX/I9sX5X7MlF7N/j5+SM9GcBEnFdgINw3anRA445hoqS5B+4iTfAG1VZMqfdLxdyu99vB6wT6fqLI0GAJdDkwrRs//lGHnNPD3Pvq52CsEAZCWQVuYQaNquOWL3tKlD1wxJS34O9/g+1k7PS31OU/mT3d0tSb6lUp3PEEhq+OtWYd/fWSCnDpsVoUe/iDjMavX2jPE3bYQaIEUH7VLOwhY94KJLr9rWhfZ21b3RGisvOLsfoKQXp+NRiPCA/0ksb8E9FSP85SKC7PA/mql6eQt7kE/EWcIEZMXo0iVAq8XGLrYRigCRcOhRn9AUEq19hRCDJlP0xkyoOgYJYbBr0DRUP12sHFVM/zWxEmCHQ65u+D69JVPsxLTBnWNFG8k1mf3zkWVvPXymlO0iMmPId7HM57Rwi1QskdXLb3TykDUWpTOa1u1Q5x8sqV5ME95eFD3bsVUdLQVoA1HxNdlAwl9pBGTGZdbLalqfbHng96tj0WVuzzsfUje0AVbYQHcWqE0w9nqO7olVNmR9rzlWwTV3ulUDX7bQVOAxWBWvJvkhhey45h5K3HuW8eSaqc
 CsH93LEj
 NnTL1Oz31XAVrr5f5k6TKamqDgMypzYU6DoqPSIfAusYeJOy9m9o8zczEdgvICLUqdaMdZ64ZhrbZdppbz7uoh1uSDndH5ghPZnQUuhf8k5XiC1o07cJeOZpfkjmOyYW1BqMKB/4gj3OrJ33+3bmE1B1alQsRjoAJm0mTrxhjFZXyN9zAqmhsoXhjx4BQCzaygsdBtB2OufPLvWvJe1qwP1oZKYh9a9sKPlgWybmTf3NKc/RzG8hmmE/ay8My2/S8ty/dqo9byh3dawsgoWkmBN4WzOkIuINmUKHjuW+Y1wJOT2I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 26, 2026 at 11:26:11AM -0500, Gregory Price wrote:
> This also requires removing the rcu_read_lock() from
> do_fault_around() so that .map_pages may use sleeping locks.

NACK.

->map_pages() is called when VM asks to map easy accessible pages.
Filesystem should find and map pages associated with offsets from "start_pgoff"
till "end_pgoff". ->map_pages() is called with the RCU lock held and must
not block.  If it's not possible to reach a page without blocking,
filesystem should skip it. Filesystem should use set_pte_range() to setup
page table entry. Pointer to entry associated with the page is passed in
"pte" field in vm_fault structure. Pointers to entries for other offsets
should be calculated relative to "pte".


