Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AFCCAFD4609
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 02:55:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1C5FA6B0089; Wed, 25 Feb 2026 21:55:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 170806B008A; Wed, 25 Feb 2026 21:55:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 073156B008C; Wed, 25 Feb 2026 21:55:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E77556B0089
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 21:55:38 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 847471C9CC
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 02:55:38 +0000 (UTC)
X-FDA: 84485092356.29.978AA11
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf20.hostedemail.com (Postfix) with ESMTP id F32751C000D
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 02:55:35 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="lT4z/kxJ";
	spf=none (imf20.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772074537;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YhcyepidlpHsmGgGlbRMBKJer3APQ37SWyjKz6GiydU=;
	b=JTUFKUBzeUp7BXeDhk5BN745kLzzvmbaX9inx0w7PY0QkTyMHD1WbgPSU9GMB/e1zn0o5C
	GcwW6DaT4eNFYDXpDAd8nBzBXfbZpXrRh3DozIp2GvV1KhukEq68mS3vtb3wBHfefaHIul
	71Y1xCfwa6kCmNnWLsRa88LWLBC8ERs=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="lT4z/kxJ";
	spf=none (imf20.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772074537; a=rsa-sha256;
	cv=none;
	b=5JwxNLthPHvuU36ZcsNOnlxKiBtPDVTGXAYjWVDFr37z/JRLF4TbIprjWEJQY5sBQ8SKYE
	q6mZbo5NVrpQ5m1dpCWEYk5gfYiipXObiohC5pp9XyJOSWur7F9sSITjtl9dAQphjVWXC3
	01HdT0EWdlBCk9PdBtC1pywKak7UfTg=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=YhcyepidlpHsmGgGlbRMBKJer3APQ37SWyjKz6GiydU=; b=lT4z/kxJOpRr2y8PL3itayYgJ3
	i7ZwoiMb1z2uyIxU40ivVgqHH9trh+os4979z2Zqho9027f2XMpjQwXu4WrFWsVhiC7TPeJPMFiWA
	gY5Nx0DUj/IlPs4LB5T3TQX9JwzlCZKXG/qNd44L3nFJxmZwkUt/c5d4yVFzQMVrqTMgiAckXiQQv
	VXSOgWR4lM/M5fbsc7o8/LNO/njgdgbDcnsTUTjWfa2X7I1OeE/KtKZWKBd50xC/8qWXOdJrRtHxa
	bjHSfDSEJawaj9ug3LKsibAnOPgnzmVmc7GOT2cW8fy/u0uTmIAJ5HciOQcjzplM+oJiP/C0Gl3mu
	rjc+CEBg==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vvRX9-000000024RA-1i48;
	Thu, 26 Feb 2026 02:55:23 +0000
Date: Thu, 26 Feb 2026 02:55:23 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Tal Zussman <tz2294@columbia.edu>,
	"Tigran A. Aivazian" <aivazian.tigran@gmail.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sungjong Seo <sj1557.seo@samsung.com>,
	Yuezhang Mo <yuezhang.mo@sony.com>,
	Dave Kleikamp <shaggy@kernel.org>,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	Viacheslav Dubeyko <slava@dubeyko.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Bob Copeland <me@bobcopeland.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	jfs-discussion@lists.sourceforge.net, linux-nilfs@vger.kernel.org,
	ntfs3@lists.linux.dev, linux-karma-devel@lists.sourceforge.net,
	linux-mm@kvack.org,
	"Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Subject: Re: [PATCH RFC v2 1/2] filemap: defer dropbehind invalidation from
 IRQ context
Message-ID: <aZ-2G_6lDZePLSyx@casper.infradead.org>
References: <20260225-blk-dontcache-v2-0-70e7ac4f7108@columbia.edu>
 <20260225-blk-dontcache-v2-1-70e7ac4f7108@columbia.edu>
 <c8078a80-f801-4f8a-b3cd-e2ccbfca1def@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c8078a80-f801-4f8a-b3cd-e2ccbfca1def@kernel.dk>
X-Rspam-User: 
X-Rspamd-Queue-Id: F32751C000D
X-Rspamd-Server: rspam02
X-Stat-Signature: 5shn7x7wsbbno8zy5croibgo5oyb5gr8
X-HE-Tag: 1772074535-533370
X-HE-Meta: U2FsdGVkX19LpbTE5JpAxpkXOHsKRJjTTicZYfaFOCuBOZB4XIkmGaI5o3T/5BrpMyuqPy4kZITyqgJLplMje3Wqai/d1fbvc1OxDHHdCT3wbh4PAzD/41LW0Lu+maiY+y0zHiniNYJMCBnOfpsfbi0MtfNNG542w9N00xieKo5aleJZFFFpfKu9Ptp8CTa7OYYt3DK0HceeeJuIGhhKLhRQbbPDXoPRzpx9AWNZJ9Q/ZNchSTlFhoeshpO6UXNn1Og/asShPGy2oIVBQOptA/2Uxvwo0/5MQe0A3XdGMBuOzOmdHhq93dJbvgkPHIeQviB3a+C5CixgBBvSfQnwIQgFL1TMJHNWrn3PItJQQCvyHkN3SfOtiyBfFOtRzkOfngrQO5KDTUKoXfz8lVtVC7II73uQc9Ij6lVTIlRkxFn1s5lezeoKom6TQXkbo3jECv8KVcj7LNZN2C9XCgxfJbmx0RfJHHRzCW7M+tJxesjlr8Ib7/x7riUEKrYL5ru98PYEzjVxeEsLYZGr+er+4S5X/K+jwy4IqRpyNupANsdOCgwTHMkSKlnnjxHyrUTdpMGKRF/ipfvpoZ5h8sDTyxrudqMxZxnOA37N/dmrXFzDIc61r05M1tv6KT08vYkaC4lq9wPxlNH7Z7wtBmhud1Yh9gGI4g2C314WT4V+lWkKgaQZdYKjTHM0V4F1UWduk/dSW990HEV2rijk7Y/e0lXbTh/0btboKdZZ9ZWbvXj2lAL67V6BZe1SsL6idyxGO9/8o/uAE/KseKmNaSAS9D9LjZeo1B3Jh3TOYod9ytA2OIsD58gMp8i0OViuGb2cGiKxbk4F0sNBvbyp3fuZm+h554jNGTVYmLG+ObrgpcojId4M9cSD2RhrbdW1EqDH/MUs1wIql/AXTz3eLGJHzrmE0mydz4TkyNa8zpLELbGIjAXyUNxe43mb+iGuPEGxr15Q6+wvy4oC6sN5J+R
 js++Eens
 5Chp83RjqoEhXdNdZbHOmL3+aEq2DsK6QoDZ23nV0AEsQmSyLN2GSibb/Oskuc0H9Bki8yna7pzrpQZ8TzDlh90AIDfVMHEwYAVLzAxTH4B9uPNCZKoHZ6j0K69fY3+pto32Q29vN8pETje0pQZaseeMcFPG9STcWaoy8a2S497TpgcM3QU4E7XPD9TEE+rsE0IGi6W4JhY5mbB5Re3+GGylDl0cSWGxFsVJaCZxz2tOLxjmK8Z7LyCHTK2dHv5BNF3tDEX8jhXd1blJauJtFA/yHhYMIvA/g4zd13CfnvvWGUnRHoBe2fMwEIAophr5L35o4FQ5IV1Ywvv4NQZgWZBxjxRODfbUqnUnZQZ9ZFdd47nvcKqYZLQYBUA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Feb 25, 2026 at 03:52:41PM -0700, Jens Axboe wrote:
> How well does this scale? I did a patch basically the same as this, but
> not using a folio batch though. But the main sticking point was
> dropbehind_lock contention, to the point where I left it alone and
> thought "ok maybe we just do this when we're done with the awful
> buffer_head stuff". What happens if you have N threads doing IO at the
> same time to N block devices? I suspect it'll look absolutely terrible,
> as each thread will be banging on that dropbehind_lock.
> 
> One solution could potentially be to use per-cpu lists for this. If you
> have N threads working on separate block devices, they will tend to be
> sticky to their CPU anyway.

Back in 2021, I had Vishal look at switching the page cache from using
hardirq-disabling locks to softirq-disabling locks [1].  Some of the
feedback (which doesn't seem to be entirely findable on the lists ...)
was that we'd be better off punting writeback completion from interrupt
context to task context and going from spin_lock_irq() to spin_lock()
rather than going to spin_lock_bh().

I recently saw something (possibly XFS?) promoting this idea again.
And now there's this.  Perhaps the time has come to process all
write-completions in task context, rather than everyone coming up with
their own workqueues to solve their little piece of the problem?

[1] https://lore.kernel.org/linux-block/20210730213630.44891-1-vishal.moola@gmail.com/

