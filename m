Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6AB2BCD5BC9
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 02:31:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 05E906B009B; Mon, 25 May 2026 22:31:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 037506B009E; Mon, 25 May 2026 22:31:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EB65B6B00A2; Mon, 25 May 2026 22:31:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D82D46B009B
	for <linux-mm@kvack.org>; Mon, 25 May 2026 22:31:27 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id AE7711C0FBB
	for <linux-mm@kvack.org>; Tue, 26 May 2026 02:31:27 +0000 (UTC)
X-FDA: 84807994614.02.37E29C0
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf15.hostedemail.com (Postfix) with ESMTP id EA535A0002
	for <linux-mm@kvack.org>; Tue, 26 May 2026 02:31:24 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=KBdxftb+;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf15.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779762686;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7WoZ2cyGDEh4C+rPTk20iaEyGOoLnozfqobsmxrDxEA=;
	b=IiiJL4JesTt5iWqAOAGYb7Uo05fC6OsMDZ6F/g0YiIlwvLES+1mvdhAfkyhCC8SfrVE639
	AYYuBRFhLtBXmSSLy+pUkEbyLlTAb35cuv+qodFzSt31TPRig6xDvSAkUlEJ7DgRCeS7Bb
	dNbYH3yMLDqQYrilgEozcRQJieLTez4=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=KBdxftb+;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf15.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779762686; a=rsa-sha256;
	cv=none;
	b=5iwn7Qb6BsWIrrKd9H1IYdpT/Kxg+m6Mi3NqeVk79NX4rSyV4K3J4KsuRL9JXZzo9aRj1j
	ZPSCZj0nlECEFp+kRbmSi9lWuzdSDO6Fvn4z3KleNEUoigA4dhtO/2Gn0DLVwPsj6mDdQO
	15nMGgaKKKmjYX9atL9AMlSbk9e8uQg=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=7WoZ2cyGDEh4C+rPTk20iaEyGOoLnozfqobsmxrDxEA=; b=KBdxftb+8CA/+k7KI5B/ScG2FL
	8ZvUhLI8xh1fqvDOdwK7pqbj7GlR8B0Epltbqi/c8aHTTUdjjYvFO1IjvIz6lMv7ZuED+UYQINCDu
	0MQdSnPS1GR3HJoJKoEAqGsxqXAGvYPovq9sV775oqHUxcE3U2bvfpC0ji6vcJeZvD0XvkjpXLilN
	yhVAgOzUf2dBZiAXSZSqzgjzyS+G4b1UXYiJys28F80FUehltLcRfxN7xUwVwPlNY0BIkaFppmKjs
	dEiVT6To83P6+jogDRT/MRw47QYIngN/6Fvc2IfBzCc+jHJD8doYNZFYylfiMHC/js3Iu60jiFQX2
	aCNpCStg==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wRhZU-00000000WP9-2Sjw;
	Tue, 26 May 2026 02:31:08 +0000
Date: Tue, 26 May 2026 03:31:08 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Jaegeuk Kim <jaegeuk@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, Theodore Tso <tytso@mit.edu>,
	linux-api@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net, linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org,
	Akilesh Kailash <akailash@google.com>,
	Christian Brauner <christian@brauner.io>
Subject: Re: [f2fs-dev] [PATCH v2] f2fs: another way to set large folio by
 remembering inode number
Message-ID: <ahUF7HqSKFJ422bU@casper.infradead.org>
References: <ad_AVHe7RMnGrGTb@google.com>
 <ad_HwhzlNPUEKQi6@casper.infradead.org>
 <ag7HfNryTmQ-bVIS@infradead.org>
 <20260521155748.GA79343@macsyma-wired.lan>
 <ag9D6_7dttbDGHZ6@casper.infradead.org>
 <ag_UsW_OrlXD9dWX@google.com>
 <ahBSXyOi9b1jxNkX@casper.infradead.org>
 <ahBii6bk0KbK_NHV@google.com>
 <ahPffhaOi2CBtWof@infradead.org>
 <ahT1nT3xsMGkyJab@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ahT1nT3xsMGkyJab@google.com>
X-Stat-Signature: 9uxmysnkowr4ay4btomp4gdqerc4h5kg
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: EA535A0002
X-Rspam-User: 
X-HE-Tag: 1779762684-866887
X-HE-Meta: U2FsdGVkX1/2Y3Nuzj3LQsiQ1x7Q0YaUMAMVdxTOtHJMU98TPGJHqsY7LXrgpKTfAeWiIBRcczYrlrUSW0tP9oaf1QONOBYCxsI0TaLIUdAqgWGkkqh6//cw+5FiULT9TH/TupT4pEg8Uq8F7xtMemakeRANucw9TguzVUdszcOM9aK1i7xRjDMy6dPtsnOBdCKaarJkIyFJ2NPJGfUUV+HBgQA/bpW8WufGk1mhoBQFE5MYMSip57AOJSa42hGfZ3wDhquG1SbPWZov2RZYlyfpHfuuIzWXY9oth7OEmhMBjteo9XgxKEQr/uJpaVgk56gzIg22FShHfTa+HVUiHrZoNvCAML/KlUHiFfY33MbSMAOI75Sdg8q6pFSgbo1yB02WPOZvdxcJ02UzP2YXJa6MODn4AOkF08R4VN1yEKN31jEp7YwAJ3+EUuWtGCPhoR0i6oBxNUT8ec1mI4+pRoLBHsSi1RDBfDTm1osCdBdZA8pTUFN9OQmNQORnVQj0Ot7+AUzcST/kkWwOn8rWHs3kH24fEQcuXjCP/mqCHGAC8IxHgHIrDaLuiqdUPJI6As1S/JxXjbKxeh842R9A9Zu5zi+6iMtcRG1k0u6HgY1+Oyj1J8qqF/EaHuKJpnC7Y2h20bqD1AuiXulUgJDhjb5+a4JeoNw+el8nPRLRkg4GpIdtOy9HzB4CnHrXSo50IuYqnYVDAl2aG6q76DbkEBlnvR4aM4URaw+7HTfhtdfppUAPf90dih2DUfal+BcvSUdPaY5+2obXadknhDfZjM22ZGH17l5l4NIgRsZyxRn9F4P/BE9h/hqZP1gMkOKgh9p73oxFg8z8cP69ZxiWY/xNe5mbi0Rb8ZGmiZEojH1Wrl5v36ZtdtbE6E5UzmuYrgirlaYxVl/xp4TwHhuvCs6MIOScAEZE+wvUFcjiJFBRFbS9cbXrj2Cc3PN27+yNaGRAyqgydjYzXmiFgd1
 V/tdVhs9
 XNoPC/01SWdKp66gp/MohQqTGaIucpETzft05rxDwWTNQlnvc/wEL7YW7G0Gg3qJvN+KKJghh5wjjW5agE2HFLlWlzXjbMXxCF1Z8yQmy8agkcJFwPFM/9eHPSK5cYLm5MD9y4BpirgbP18ngtxIfirNtPbtZFVTMlFVtgIJBMGR1TzCFy1JhnUUhJBDrA1mufKnlLciS5CV2EO4XYAs3KNy9C+qMHWu+PbYngABPkv9yLCjB3eKVIXnoHg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, May 26, 2026 at 01:21:33AM +0000, Jaegeuk Kim wrote:
> On 05/24, Christoph Hellwig wrote:
> > On Fri, May 22, 2026 at 02:04:59PM +0000, Jaegeuk Kim wrote:
> > > This was a quick buddyinfo right after booting the device.
> > > 
> > > Before:
> > > Node 0, zone   Normal  22684  42284  28704  16901   9515   4566   1854    673    181     36    758
> > > 
> > > After disabling EROFS large folio:
> > > Node 0, zone   Normal   8486   4732   2175   1161    697    272     82     19      3      1    856
> > 
> > And what are you trying to say us with that?
> 
> This means, high-order pages were used up by EROFS which sets large folio by
> default. So, I wanted to say the concern was based on actual data which was what
> Mattew asked.

This isn't that though.  What you actually need is to show that high order
allocations are _failing_.  The MM is far more complicated than you seem
to understand.  There isn't a fixed number of large folios available;
when we try to allocate memory, we do reclaim.  And if there's large
folios on the LRU list, you'll get them.

If what you want is large folios readily available, then what you want
is large folios used _everywhere_ because then they're easy to get!
If there's small folios in use, you need to reclaim a lot of memory in
order to reassemble large folios (it's the birthday paradox, similar to
the hash collision problem).

