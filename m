Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0092ACCF9E3
	for <linux-mm@archiver.kernel.org>; Mon, 10 Nov 2025 13:47:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5CF0B8E0007; Mon, 10 Nov 2025 08:47:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 558838E0002; Mon, 10 Nov 2025 08:47:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 448138E0007; Mon, 10 Nov 2025 08:47:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 303678E0002
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 08:47:28 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id EE7C513C369
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 13:47:27 +0000 (UTC)
X-FDA: 84094824534.04.F88C16F
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf24.hostedemail.com (Postfix) with ESMTP id 4EC7518001A
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 13:47:26 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=Dw4eMTIO;
	spf=none (imf24.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762782446;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=goqVguA1QAyVzrtFHbWfsQhLgAORjRs2GF7ed8xJBeQ=;
	b=sVfY1lqJdn3fdJs1hWIErgv9vfa7AafARx4xr2AJYT5mawhhXqbg+AUJASPi1BXO0l4LMA
	agP2EXi2XNSpEewhMcK0TxfcT3IK2oNHodR5QqRqef6Z8yep3lEQRLsDW63sVT3c7sp97r
	6+Am5ILkRUu9OJtk6PtrrI6rP0u9Ksw=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=Dw4eMTIO;
	spf=none (imf24.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762782446; a=rsa-sha256;
	cv=none;
	b=bvBzpI+qIPpAyrhLv9eDPtpnM4KerAzBy8lVjXYOeCnBA9K6uQ6Y0pm6uMTv3pl+VnR+oR
	wzZ51FZ0oiB1LNuxtwkr/bGHsPTmXNOtcWVRPwCbY6xWwKyClwrpg2jTRoP+9JE+iSNuWs
	p5gQPiT/Qshd+92BzJ7gVf2sbt2qIq4=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=goqVguA1QAyVzrtFHbWfsQhLgAORjRs2GF7ed8xJBeQ=; b=Dw4eMTIOCLZh+8e9syvo8UvtPa
	85tzOjadzFjPNK67JGgZWaLk9mFqs6FCAYeNDGQcUOjfoKmcH0Dc1+UsYZRhQefp1lNPMF+KcsSWv
	mcc71dwR8/orCgUUbJuexZQPJXOHleDBpxxtJUjR6vyv7fLN2Zr6NC54Bc101vKVuIwv3ukE47a94
	rJWKPXG74Qp5cEHpAOOIDNKMemct5svlpimMhaKYksbPYhUWEfHtVzhGy/YItZqUlXeHGljJqWS0n
	sCzqjRkn3jZq1YZs5r9EJq7DzKAt943PB1l1TXhc52b03ha9DnU5PiYAOW6RJAv8LHKl2ztROgiOw
	LN9OlODg==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vISEg-0000000GSVV-41BN;
	Mon, 10 Nov 2025 13:47:11 +0000
Date: Mon, 10 Nov 2025 13:47:10 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Shivank Garg <shivankg@amd.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Zach O'Keefe <zokeefe@google.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
	Branden Moore <Branden.Moore@amd.com>
Subject: Re: [PATCH 1/2] mm/khugepaged: do synchronous writeback for
 MADV_COLLAPSE
Message-ID: <aRHs3pA2kOr_uD3k@casper.infradead.org>
References: <20251110113254.77822-1-shivankg@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251110113254.77822-1-shivankg@amd.com>
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 4EC7518001A
X-Stat-Signature: iy3udneoa8egqbsy3jf6s6pjw7eoptqu
X-Rspam-User: 
X-HE-Tag: 1762782446-438149
X-HE-Meta: U2FsdGVkX1+MEFdk0GlaazypI2ZdpaLyHmajyI+KlsvAwyP8Ia++5fXsVldEkshg6S+trWi7FfbrDuMm0v4DheYAEavuqDRLSb/10qWzIDEzMaMAAlg39/pmNFTU+AZc7npjqcYlV9mKENGFbK6YUPDZbKggHUKWtpi67N8+6xjOUNd20+/byAPT6xITNkVH/rr4fbny25q+9URCAPVhHCvdH4JECuYEpW40Ux9ztYGuAtL1UOKOJDnYp+W1936H687wpEmIiZWRB+Zlb2ZSV6h6+9cRJqHrJuE5nxPgQ0qzP5F+mgcQQN7LYFofP3j3pnfHS/+M7O6P18ubcFsFjxMcB3AnA5wBSmLJxigC8FrIby3gcNL8IYErWr/3OHbCCi2KDKuguPG4j7u0fFJxtoCysS/K5oRbnKdcgqWl7et3lBnvoipGY9HkQci4xkkNP84Gwp/U5Z+5yVWspag8Cr5vf8y9YAyxEBAaFvDvahtSSATl5z6NA78mHdGOpMBb2FxwHN+WEGXumeWOzfegCbiOrMhlihgrrp+vMQJGe046DzCosWfm22FWGgJ+zwuNnC8gQcEYFhU6+lvZfwVgas+yTiDV1b/tEWtydk/vvm7oeFmd0+gp1QtOLz56JZHHfpvBvbm/EpqUsPde207yVUk82JKvaNz16we8UX6HR1urNO+k7pO0/3jG4Z9tflsBmdJxt9qHxUj5njZJr4ZJicJK77ZTu5j23mbSbH8j2MLV8WBMcF5t+Pot8A/Ilgi8zjTRNfh7SgOYUhS7l6gDdgYF6FBy77nwaxhravYmVhZw/S8xHBs0L4DcsGbXpNJB2MV/p8kokdlluIlE4HUrjzRuC7TdLjd7+ruTHTS30kv3VXEdnuMSI2C70wKlaW79iDmcNC9NlHtJZhwFf8ZH9ozS4SGTmRvEGwVWTWSnkbjxMisBS5JTUDjHv7ZLk/9LArXnevAlWX7aeveUXmZ
 dlLXugOF
 z/e1zKuPlFFDCBVMnE0BgJr5SKTxXvlXhvBkXyRE2W1Aek4U1V5wx+uX8EtJ+6x1IQXTpIvYlbas6b6pbPA56NEUKaKkKQ4eiTp0+DpG1z2lo9Qh4AYmF0X3NUWNEjS6d+q3ZjRQ1wgQHkT902kcjZ/EaORgXxNq7xUgOsizzOXKsJMX1Mb1hHDSg7cb3g4HC2Qe7ctsL71QR86QlRsfLXgKuGx12gZjZl+GMKgu9xZrg4eVhQwxkF+b4/yNvcxHjeZnUClSCeYUUZgOIuBFAYUY9yDu9AxmSYsqW4jvJcrA8vBw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Nov 10, 2025 at 11:32:53AM +0000, Shivank Garg wrote:
> When MADV_COLLAPSE is called on file-backed mappings (e.g., executable
> text sections), the pages may still be dirty from recent writes. The

That explanation derails my brain entirely.  Text isn't writable!  How
can the pages be dirty and file-backed text?

