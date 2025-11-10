Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 47BAACCFA13
	for <linux-mm@archiver.kernel.org>; Mon, 10 Nov 2025 14:17:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7BCCF8E000D; Mon, 10 Nov 2025 09:17:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 76CF58E0002; Mon, 10 Nov 2025 09:17:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 634C78E000D; Mon, 10 Nov 2025 09:17:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 4FA948E0002
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 09:17:52 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DEAD1140126
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 14:17:51 +0000 (UTC)
X-FDA: 84094901142.13.C7DC1DB
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf03.hostedemail.com (Postfix) with ESMTP id DB27520016
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 14:17:49 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="FK5/Drkh";
	spf=none (imf03.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762784270;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W6YiZUPiMldDbZBiOiBNFbkvDbr2B7fQ67wc4kW4+s4=;
	b=oDKWQ2Q79bya7v+aakiKNMvKZiQk6tHn+xUzcLKLBo48solYT+qLYjbhzpY07XeUAsy0G1
	u266Ia5pirs94jOla6TlLWg9tLaGWQem4ysVk6a7hVN4opp+D2vAjOCcTxI/ayRG4e6fuK
	yuljPT/jYr9OdCQm3c4ttVo8RnGnIFY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762784270; a=rsa-sha256;
	cv=none;
	b=toh/Fdc+uvl6bOo/PuGJ7zidwECewz9UYZ5jddQDWg8g8Q4FL3PsTkd0CBylmmqw6GLbS+
	cOZKoCsGZ7TFogcFBNbwk/6tU2liQ/OH94KkONbD1MFNhH4SfskOZsjrjjyNr9VkRERYsw
	LqBib/f3sOSSjVEKdtzeL0JAauwjlwU=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="FK5/Drkh";
	spf=none (imf03.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=W6YiZUPiMldDbZBiOiBNFbkvDbr2B7fQ67wc4kW4+s4=; b=FK5/DrkhPSNaY5Y1lv3Qbw3peA
	kHgYT7Z6hGlnUjTQ9CKx2OOfYddM6ZkFV1xofLnq3yeC45RN0EXvJ5nCIeZ52NPHja4WFu6WU3D7S
	fjmTYVL23H+18iIxjrS3Fo2MhxmBcn+T/nBf1XHVDVh7EaLtLHM2Uso44v2nzYNyGAKh4F9mf++uL
	yjaRujDRYXROsRcF0Q77LDkUHzomisnPSavyPOVGZv/MR+1FGGMZOHFw5aTOIf/Os3FH6YtEBntDH
	dE014QtcupcatIpKw2A0fvjK4eZf1RphHQdl9qcY2hV6Y99GTpK99uEsxvt2kLJaY8YiplIU4Q48g
	e9H795Ug==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vISi8-0000000H256-34vg;
	Mon, 10 Nov 2025 14:17:36 +0000
Date: Mon, 10 Nov 2025 14:17:36 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Shivank Garg <shivankg@amd.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>, Zi Yan <ziy@nvidia.com>,
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
Message-ID: <aRH0ANHpP8VN1j9r@casper.infradead.org>
References: <20251110113254.77822-1-shivankg@amd.com>
 <aRHs3pA2kOr_uD3k@casper.infradead.org>
 <b7313a45-c36e-4390-a0b8-46f412474f86@lucifer.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b7313a45-c36e-4390-a0b8-46f412474f86@lucifer.local>
X-Stat-Signature: ojws81e96y74pma1ys3ap175ront1qb5
X-Rspam-User: 
X-Rspamd-Queue-Id: DB27520016
X-Rspamd-Server: rspam01
X-HE-Tag: 1762784269-501013
X-HE-Meta: U2FsdGVkX1/6vwNTBgPbe3Vw5mZVQx2yNFgUK9XwxDuvK9nDlSImbtrBhHH4UHuTk/IYBb7vjy1ncNxftlNBcfXfnITjRoJwOoArguI4UxafwHYoeC5RZTUrOa5Vqfp0OsJSNEfGDTSrHL996hAru57WbNV8NFjZO7BP9vmMvsR+ISsggAE8K7nBgczvDRUDfANB45DVtnYu0R4E3YRcKZrl3idAEQZRvitYFtybB0JcqtdnvKJanQWiaR6XCBpkl6a25eIWETTUlQPFw70zDC3Z5OFVVyBMZ6e+jSDzgL7YwFAwQRuT6vkPewXcCU5xaMPNlCWx9EW3cSgbSZwo/Ayov8KMl4Z4r5b6YwugzFNG9ajo7ikjUjVx/k9oNUQwWBCOAZwu4nm75dNF9vnEsm0QxduA5IjXOIHZxUdfsaB0IwYdHYLcPijTAplJGvCSvSassE8anIuG1qcwzoKm8D8zIC1gageZr5MjFfkS0PsCfJXcfhLnQRhdOJoRHJgB6Baqq6Loktji3floSfhDNYS5ERlWseFM0R954+6uXfB3TyM6dOZenydIH3OxG0EXBt++pQYaRpP4TOQ2Fh4YwdpO1v6qwUoccM7XRDOw3d5COProOmw93dHauDm1426CWW72svjl1H9y2O/w4DPAB5bz0xOxgSf2hSNzod8JSSc2JLQl3o6wFgQ8BR4WB3n/dCg0fZ/3uAM64sBY59bVA0h2ci1L056tNOdqjKFJNnIoMInqqlWsSTQ96vPawvO3C7VfmXmpqO11KJXkbpBWpyi/gbqFJcpT7O3oQ/TEzhTmG57SpBc9s1U6fnxZAOC2vPjezqvlw3cLuPIbnfEIRtD1w1wl+Diip7i0vH3I6CKjwppx1QuqhHXK5uuqBpJuz1SLf90wR78ztz60oDsNK46ERyHU+fZte/t5hVWt/fpK4KRfpSdH/tsUQUff3MpDow81tjreamQakeQ0sYd
 X79DM+Tb
 Nj3y8YZPwj8YzuOUb5/kuBXGQyYXibovMZRsE9ZBGzJBP5JW3pcHI4TKGaCniheE6q8vuJtzGZ6JTrduvyCT+H0pRsWliGu/Yyoy44RQtdBm2uvscAVS7tyYwOIRzv1bRcNCcig/539Ij/0SsNDZs2qvAOfNigBtnDqaxJxAtt7fPApzvxDRQeN3yU46PLflDV/CCo8/RLlSy96xVOPYDgK1BJ4MyptS/iacABEL96WPPFTrVKONw2h/9ZW+e51BnX4sHvAJ9mAQNv8mkpiFObL00g4a7yAJz3cxtx++dizAReahd1EgZzbmMt1DrLtEphlHc
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Nov 10, 2025 at 01:52:46PM +0000, Lorenzo Stoakes wrote:
> On Mon, Nov 10, 2025 at 01:47:10PM +0000, Matthew Wilcox wrote:
> > On Mon, Nov 10, 2025 at 11:32:53AM +0000, Shivank Garg wrote:
> > > When MADV_COLLAPSE is called on file-backed mappings (e.g., executable
> > > text sections), the pages may still be dirty from recent writes. The
> >
> > That explanation derails my brain entirely.  Text isn't writable!  How
> > can the pages be dirty and file-backed text?
> 
> Because they just compiled it and it's not been written back to disk yet :)

So we can avoid these patches simply by changing userspace to call
fsync()?  Cool!

