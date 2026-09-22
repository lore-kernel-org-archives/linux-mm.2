Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A4BE8C982FF
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 09:51:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 63BB46B009F; Tue, 22 Sep 2026 05:51:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5ECBF6B00A0; Tue, 22 Sep 2026 05:51:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5297D6B00A4; Tue, 22 Sep 2026 05:51:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 301AB6B009F
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 05:51:53 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B0A12C040E
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 09:51:52 +0000 (UTC)
X-FDA: 85240931664.22.3264787
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf23.hostedemail.com (Postfix) with ESMTP id BDB1B140006
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 09:51:50 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=BM48WV7h;
	spf=pass (imf23.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790070711;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+rvjHLqwJcdhV8DxzzAFDMYRptYiWAuZYPint/Blr1U=;
	b=2aanilrsiq01veuujPnrMI5L7Qx5tsTK7Wg0N1oFnqLGImrhNAWNSL+D9ESGrqykFTnKuq
	WuzWYeJtt9r6hVVv7q0nzuljrMDLxOz2NjUaHVeNZcbwbMWQEfPjqdh1IFs/Q5hF8cpnPw
	eAst5ZmOGIgu8dQ2njUPk8THoQsA1Iw=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=BM48WV7h;
	spf=pass (imf23.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790070711;
	b=RiQQfeObpBXXuqV/de340mO1njHWhH5BMgOm2GveGRLOkVRD2dWLecJGuE2Mq6cb9QDxPB
	yhYD0pxQlvYpej4wiuN4mNUxO0jpEu3j+9JkZAxfgjFagziWa8q+CQeu6GWk2SlcsGX8bg
	yuRlx8Bf5wwrso7HL1/NuNr2nxsf01A=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3AF371576;
	Tue, 22 Sep 2026 02:51:46 -0700 (PDT)
Received: from arm.com (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 05C843F528;
	Tue, 22 Sep 2026 02:51:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790070709; bh=m8dsVUe9VmybSB8L2iZwJ4I5m2KEM3g6YTnaSnesjQY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=BM48WV7hYmWiUmnDxQ3oRew/uliRrgx0D0KZyCHyPfwsttd7dkn2czRr/XktATdY2
	 DkRKudakyQe/pHVQAnqysUhYelbsKoNTuC+5yy+NCSgn85p6n6Y8rGFsA7/W9m97jd
	 FOBKjpSZGGN10bSF/gAGt0+nT8zKt7skFxE/pgUI=
Date: Tue, 22 Sep 2026 10:51:46 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Breno Leitao <leitao@debian.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH 2/2] mm: kmemleak: scan the struct page array in
 MAX_SCAN_SIZE batches
Message-ID: <arJPsqUSHGiitXQR@arm.com>
References: <20260921-b4-kmemleak-page-scan-v1-0-fb97d4801b3a@debian.org>
 <20260921-b4-kmemleak-page-scan-v1-2-fb97d4801b3a@debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260921-b4-kmemleak-page-scan-v1-2-fb97d4801b3a@debian.org>
X-Rspam-User: 
X-Stat-Signature: 4g5e3fwezdwo3xfesk9f5dpse3mft6r5
X-Rspamd-Queue-Id: BDB1B140006
X-Rspamd-Server: rspam07
X-HE-Tag: 1790070710-628189
X-HE-Meta: U2FsdGVkX1+88Mc01MY1/5tFLNkxfkmVaLNheJyf9vX2k7JCRdKWE33p4nxBXrOuOnTk23WOISxdDFkbgV8YzZDZwto4GvXVgoPVFon7F598P0Aj7UGewPru0GmJwSLDWTtj8wKs2WSSdLAPvS1RpLWd84W8BKPsSnTomVZwFTANmXkPE19cVu/T2y8dJnVaxh69uFY/CLdze/B9hTCxtoh+WmvRd+qEaBkyEgiiuW7h6GHreOakUGAiF17XtO4gG1jTuo9hFEwoY44UU88Iows8t8+8VW+siMqzAYzZxC/QOkwT6cOuf+2JS0q9GIYlvmkWQXfmy8ednOMxcNYer5Y+TuuiYgEMgdHOMkLkqthCO+EY7QaSjmnFNS6S/zEoUUM7GD3VgTZ9QB1gDEgrEFjn4wZufqeH7O1IFcar6mQ1UhT5RocoyZRrfd2kN7lrj5A6nMUKxeICljMHMANg9ktRCPTdQlE1N+swAsqZnj8iHCqrP27Pn/1wQ0b7Spe8vT8qg2w8L0p9kQ+3NtIXyyOV6J1sbvR5oTwNzPHIiI37xJJs0DdopHQF4j/fVJbIXENLsOvvZTkn5hZnyvw6l+2UTsSzuMZD+Yu8K/KDV6gMl1MX5ztq8k74uoWjcrZEfGVU/uTAZmLWVcBCUy7SeCau7ClvKp8XzzRCwrddYciLDFc9VXzrtUnL/FF5GXef60zGbdfDCR4JIE5wmLTWND+EWrqZ+Ad8LHx3q6mImfkiWjoMYlO3evqzUWY8U2Cq1z9BhJUI5L5B+Mhsh62F6uYVbA9r4jguOVAA4F1UkIWlJeTtHesqnFovFvEAgx/80MpSynGNGXU3vKMt973aMdunJbQ1wLdPMy1TG/3QIzkfQ3wodyijiwKoKF54mbvuhSmFdVTnxyBSSMoZGcbVNFIZnUqSZc2NphpCCQR5XF7j1dfKmefUG1UyzmbLbkIHdE71pG4FdSQTJZh0g5u
 P9UwnESL
 8JS4DxbYfVBEH9QkW7FQbmrs1l9FTie6XyBZ3RhCfZKd7hK5YQ6mu1JB1LFEJKP0uzm/dy8HsW+POPuyRWV1OOx3gHmWGxVQNjns+A46fioMP/bs7+AXdxlNuh+qwLMefXdgFmkJg6+sBfxN2EINygvEJOzuSgFHkvdNdr9ZHJmARKhxSIIO4aKK1uSVS9/EU2W1y7xqi2lQjbuUA5AXjRexdoOMdCFdNGDkljFCRStstg47fBsW87PcNIsgxFkhpYcplotBKPaE+vZdb3UeT59YYjigIfLBi5BR4N93y7qwR3ssEHbzaGCi/iZc+gjBMH5X1yQeNZI/qEX0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 21, 2026 at 05:30:27AM -0700, Breno Leitao wrote:
> scan_zone_pages() scans the struct page array one page per scan_block()
> call:
> 
> 	if (scan_block(page, page + 1, NULL))
> 
> scan_block() takes kmemleak_lock with interrupts disabled for the
> duration of the call, so this acquires the lock once per online PFN to
> scan a single struct page.
> 
> Gather runs of adjacent eligible struct pages and pass each run to
> scan_block() in one call, capped at MAX_SCAN_SIZE.
> 
> The longest kmemleak_lock is now held is MAX_SCAN_SIZE worth of words,

Remove an 'is'. Also, MAX_SCAN_SIZE worth of bytes rather than words.

Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>

