Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AB32CCD343F
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 21:05:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3AEC46B0099; Tue, 12 May 2026 17:05:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 338736B009B; Tue, 12 May 2026 17:05:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 24ECE6B009D; Tue, 12 May 2026 17:05:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0B5016B0099
	for <linux-mm@kvack.org>; Tue, 12 May 2026 17:05:39 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id AA2A8C21A5
	for <linux-mm@kvack.org>; Tue, 12 May 2026 21:05:38 +0000 (UTC)
X-FDA: 84759999156.09.7068A65
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf28.hostedemail.com (Postfix) with ESMTP id A4FA3C0007
	for <linux-mm@kvack.org>; Tue, 12 May 2026 21:05:36 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=jRW7CK7M;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf28.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778619937;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iNEyL3gLDyzG6nO2vSmePUfY2nRaePWVRT05beAUZoo=;
	b=kjyrfVzrQeuf5M88gQbFCKqPGZLdDK7ydP+/Bm+YB6qfOH+nv05MLMT+qypP2aXmSnlu1V
	JnbiDJh8Jy1TYQX1CfCE5VuaTO95/2xanjnbrRmDUKal7ob+phe+SiP7JwFDS/NcbGz+sm
	zKUCf2264R3uILAa2gFS6dtXrBTHOwg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778619937; a=rsa-sha256;
	cv=none;
	b=RX8kcJ8vU2l5g10NhX2oPQ9W89L+muA1mvbJ/kyEOm9yCWLi5L0w5eswv22sseUS29zgfQ
	5uI7l1TaUP5IaZWX+OWezU37nrHLNB1d/1q1GSGEMGhtNxUFHC/HyCGtdPk/GteAHKO1Xp
	r+VFsCfaWtoZlbvhrctfE+iQnbgaNsY=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=jRW7CK7M;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf28.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=iNEyL3gLDyzG6nO2vSmePUfY2nRaePWVRT05beAUZoo=; b=jRW7CK7MQ9ezHwr4s0cdjEQqJ4
	EFypHoSxXn8As6dsEPhav0BQSmoMJNbHuurNSp1XGGgbx0RNzuhKUH7WW2pFoxvnXQTJpzyFdJNbG
	XQOobEZTNuHrMkNHOc4MlULRrWfIkP285A2QPR4r5/2S5cP0D1CuDUKbX4/ivZ/8zG5cuC3DDbi8E
	x7xkdcO4ww0vLVS5YI5z5v6a6C+YhF9xc4c0AeBDWh5s5gVFT05JV2dOhQ/8ySyn0NdFHLxe0fnHG
	oscreJQhFeRrVIlQiT5NM1J9YwTyy93+PvMbHDHKZC5W1IO6UxlYVQLJBRUZD2yl15moRB/O7w9Ry
	hFZUYMKg==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wMuII-0000000APap-26GZ;
	Tue, 12 May 2026 21:05:34 +0000
Date: Tue, 12 May 2026 22:05:34 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Frederick Mayle <fmayle@google.com>
Cc: android-mm@google.com, kernel-team@android.com, Jan Kara <jack@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] mm/readahead: add kerneldoc for read_pages
Message-ID: <agOWHm00w2vlh1_o@casper.infradead.org>
References: <20260512203154.754075-1-fmayle@google.com>
 <20260512203154.754075-2-fmayle@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260512203154.754075-2-fmayle@google.com>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: A4FA3C0007
X-Stat-Signature: 4j49os66tqaip95kpfus436auo3u9st4
X-Rspam-User: 
X-HE-Tag: 1778619936-258916
X-HE-Meta: U2FsdGVkX19R6SFVCF+6r0GToptpxUyWwtbBrbFCF7iQc1Wyn558kL01bxOFg/5fRsocfnhruX/DpdWvYrHYVMjTGjavZAojrvbjr+4P7IgR4LYzl/28UHTc0YlgOIJDABDeG3IB/e3LDVcaj9zyK9LsCWezoznoxOC0Q7prltb3hMzc5SV6JyXpMQRthHa/Xoao2MKd9oNmL1rxLbuXBiyqGHNqJCkbknGCqPo4nMPAyG+cKmghVJQY+EQqnWWapHbMQeINfzPXHDpRfgV3ATNOjh8Zt2lp6BgyHUHc5BQjkdsSsHQUUVIZI2WPhH2IxafjS+Eq0fTly56Tdr0PGsXLGxT70uWJal8U5okNq8anztJngg2ez4T5dVFs2f4x1ggf+cQqeAdnlXNxGh2iVNHL+LEykGhS2NtsLA7+zKE5VqeXB7Csnf3oLhAOcXHcanG97Dc8GW2zpZS7YBpxMxx0Daru7IqWGuxpGK3WdBQbrlFJZufemqNwI875/luT40xQjCxtFYG4s2skAuFu8NTmB6bapTznoI6peC2s9hzpeNTJNEOAvPazqoAHxOQjzXgvjGmCYRlk0dNMAWAFCc6MgDdzQch8DYB3LP15SlPBOnQjscCH3pjzr189dDMbQWPnZWymfDXpPGxPFrBFYtX1zJKs+PmDKAlGalbxmjy1dFAYJfoUofBYOIWwxpI/lUzX/pM2tyDPom8P6YRijEG5v1T6cMcKpZma6QB7uAE6cjx1o51K/xKkGcZq5qm6iUKgy1E37W47YLDfqFZ+b8+zfmF+E5/45KUmLllC7PudC8HRMmkosMzCipk2NvRO876HbsAj/eRd/lBfdWfQFaSafa0ikToaxZJLniUgDzajGJ5qR0qH5Fzk5Dkprz5SArl8tndc4jjrkzhlG3gVZGFnJ9MNzJKJUPEBzXjhLinZw2bWZCPX2YjtlRekDjKytY3dhM6Lozl6STual10
 /3tEQ7MW
 qPORBcT+wQIzcSnFu9rKy2P/iSY7WPGiwqJLwlvVCdb96DL24TYQ5GxUjNdQM78O2YRngu9Y2zLeIkt4VW47EX+kK/7YSka08m0SuMq+NTpILhv798/UqWr9ndjl+ezog8S+/q9/nQokpXxoJ7pf1ZzeNBdIXC99D+4HjMzD9mzBpK/bUaQwE/wO+ZazrwWrX6adseWuOW20maBavpGbkb2ZOtsAsiujsnGWFDYdDj9GEfNOXWe7bSJI7Od1sIx7y130sfC9P14GahxkAC8YuxwsGtmcnkKpAAsUyGt6fYQ08qvE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, May 12, 2026 at 01:31:35PM -0700, Frederick Mayle wrote:
> Formalize one of the invariants provided by the current implementation
> so that callers can depend on it, as discussed in [1].

We don't normally write kerneldoc for static functions.  I'm not sure
why Andrew told you to do this.  I have no objection to adding
documentation, but I don't think it should be marked as kerneldoc.
And if it's not kerneldoc, it doesn't have to be written in such a
stifling style.

