Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 73EB4C5DF66
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 15:18:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5DAE96B010C; Mon, 17 Aug 2026 11:18:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B1A76B02B2; Mon, 17 Aug 2026 11:18:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4C8EC6B053D; Mon, 17 Aug 2026 11:18:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2DAFE6B010C
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 11:18:23 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id BCD30407E2
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 15:18:22 +0000 (UTC)
X-FDA: 85111117644.08.F2BCB3E
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf25.hostedemail.com (Postfix) with ESMTP id 19A46A000E
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 15:18:19 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=lAMVwdUD;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf25.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786979901;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nlKiBmDFzuD5Cz1o0uCr0b99TcOu+kZtAzlsbE3jv7A=;
	b=GIaNPWcBxR70OyjeEG+5WdkK8tirSIEec8MYv8oY86SWdXKXTTI+1ixFNaOX2g/O7ahlLW
	A8zC58XQU7yo/3uRWk0Fn3dvKvyrL12JN12vz5MMzPSBF78AHxoM6tim2Ian+F3ARxrstR
	nybt6LJRRCbbbyH16FrDywakaBWKkNw=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=lAMVwdUD;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf25.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786979901;
	b=EVXg6bgSExwgU+g3QjYY/zSeyivyxZvGLIjJlwygwoZHwqDbCNVys8eXBnCzxK5fdzv7bA
	1pb3y4Eg2lXfAvV5I3KocIeByxY9uEwY8NUDX6Pftwp3Oi36IdX0o2yCaP66nPpsOLZR48
	yuyJ/mmdaGeZjeRCBmppwt603bJ91NE=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=nlKiBmDFzuD5Cz1o0uCr0b99TcOu+kZtAzlsbE3jv7A=; b=lAMVwdUDSOhmDS6oBwpYR2AEgJ
	OoHsZ4rdgC6szU4s4HMFl91LROD0w5lzFlRQ9/R5j+fnr1YHUQsB2SZjWsspqjbQS468g9PBtXqfJ
	Qo2iZRSk+Gvyltdb7UmKvRkIXVIWsAafgROBx3Q2n0+64nAcSXljmiMOtU8i9trc7YcWvowE7YFmZ
	0mmQ5qLYDrOUxhkl//8kR41uxmD80/JxkFk/KHn7PUbk+WyIYSKVZcDsARl3xJ+kKpCyaKs5a98sk
	Qcr9MWSLqlZe4NwU3KFEhSQ9lnCoSCkqZQndOJxTtl5qvVP5v+HMlGb9Jb2b7vb6kCQxZQHdQvIfu
	wVzVNKBw==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wvz6O-0000000AIc4-2P0r;
	Mon, 17 Aug 2026 15:18:16 +0000
Date: Mon, 17 Aug 2026 16:18:16 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Jan Kara <jack@suse.cz>
Cc: vova tokarev <vladimirelitokarev@gmail.com>,
	Christian Brauner <brauner@kernel.org>,
	Pedro Falcato <pfalcato@suse.de>, akpm@linux-foundation.org,
	security@kernel.org, linux-mm@kvack.org,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Kees Cook <kees@kernel.org>, linux-fsdevel@vger.kernel.org
Subject: Re: Fwd: BadBunny: UFFDIO_COPY shmem killpriv bypass leading to
 local privilege escalation
Message-ID: <aoMmOHjLMRyUXhys@casper.infradead.org>
References: <CAGBKPgOm8q-8_rwyRPEmSj8JXdh_GaK1Q8vpJ=j-+yA0SgcNQw@mail.gmail.com>
 <CAGBKPgPPALX_5CQJAKUNjwi2fD28pBeS5pRuwQgePU93pOy8EA@mail.gmail.com>
 <anXnHMInq_JLYbWc@pedro-suse.lan>
 <CAGBKPgOfbMJruqcegJca6BBpEtpd91s5ASF_VU+gucWsjwp8WA@mail.gmail.com>
 <ancYCBUT8aB0qHwz@pedro-suse.lan>
 <anlOGOmO1HWVCMdF@casper.infradead.org>
 <20260811-knieprobleme-holten-palmen-4d42742b1962@brauner>
 <CAGBKPgPanzn8WuHK1hm44FLCXwJcnk7W=J6b17D9UzScWW7SJQ@mail.gmail.com>
 <trv2wwdwprrebu4s6i2ufepk5a5ir4edz3tnttv7ivlkzihx3e@zq6lt67oplc5>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <trv2wwdwprrebu4s6i2ufepk5a5ir4edz3tnttv7ivlkzihx3e@zq6lt67oplc5>
X-Stat-Signature: nt8d7swieahjeh9qqekahk9gq988j5bt
X-Rspamd-Queue-Id: 19A46A000E
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1786979899-953813
X-HE-Meta: U2FsdGVkX18ZDMsnyU9BtZNkF55C+hp3dG9ESm932pdoSmWHdw8uVda3xRGQRQQeKyTbeD+p2nTwnFdsT3ilB9eMeXDJYALHaywelUdDsNvYB2PVaylP/xlxkqycq0pID0TKQTIeVLbSrzcUZHKoTwddtgetXlxXSArsOdQKFD9kacI1VyS2kgN2PmuzveSza5iihoEcU7m2P1D2PgrXriLVI9qjBi9k+QZ/AEiQQmw9UgwE662tqNap4YWZByS3HfLE1vL6nsLJD1IWEwQia8hPzpDx61kVSdItmNMPqVcutPZisqn+9jvoa3z0XRkuSVuw1s4D8fSfQLEMrDNbuUAk12MES4ZvR0hndpszjL+AQ8F9ntZKnNOO9dP1ltzWqx25wj5Wf/0etRI2j19Di5ww1gxPvHV4Bxbo3tn3bRQnJtmL6MDKo2IicMX7lCaUQ5yQ479RLiLAXGFqH88DhxWRQ2EyyUko1kdGBRPk1XxT0TO6GOnGdZKLRjTMSmohpiT2hhJkkDDLf6mwmn/KMsVLssA0EUp3g+AVy0Ft7tIcA1C4fX+XXX750wYrUB3tQOA/YHG2ZaXzI1QwemNw9Sq8yCO0lBu6EQq8cEDiZEE2XGzQAJlOzdwNSJ1Jm6f+dJQ2nUYQxdH/aNSPaGCw057mG5BIi420wya/ytgtBBGWzZElr5BDtqau5tLkBUtEj3dW5zTvL0PFWr6YC7mgHfQXUNtU9p4JD5WN+ugIj9li9AoPt0qPOwsr5wYV4zIvUMHkHEGfsgM9c5TllPACFM56Mm6ROjHeaYUIGIseFKFUcMWmpX234SJ+CsOQFLj+q+Utiuy7ClBmZ+X3HBfPFCeW92XBzulCkN6iOzPMhEX/qBYDTX8fibn/fUPrAx2pgRCnILzQ6+aMfMlCluK906fBLe+bjPpOxcB2/773Kq7sn796aZDa3yQ5XAmX430mAiCWGlnrV6fsthaN/lX
 50J5bHEq
 c6V9mWeWVjW5MIZn13Up/6DRUCq3sTh0c+WYyqTLB8GFMO5Hx59BAD80qs2T+j4SYhxTOYMyetUNiYn8VyrwW3S36GQ5x2w2MFybTzG4p00lWG5ah0U1+PTm1S8go7yJQw6adFGMJbIaUdeTdCcZUH5aw0BNCtOY4bjeWfL0ao6mojtedFyoaEvrBBQUAx35ayqyJMMPZV3os5InXW53DLbUuWy8Zk2on8dRnERxO8A3ruFkZx5aE+7R3gP6pER5H85EFQgUavxH8DWYlJqSxQ1ehskPcc4Y4ce/3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 17, 2026 at 04:53:08PM +0200, Jan Kara wrote:
> On Tue 11-08-26 14:16:31, vova tokarev wrote:
> > Matthew, Christian, Pedro,
> > 
> > Lol - fair point, I'll keep the reggaeton references out of future
> > commit messages.
> > 
> > Agreed on severity - but this is a
> > killpriv invariant violation, and the kernel has treated those as
> > security fixes worth backporting before.
> 
> I tend to agree this would be good to fix for consistency as much as I also
> don't think this is a particularly serious issue. Removing SUID bits on
> write is more of a hardening measure than serious security guarantee and is
> there mostly for historical reasons AFAIK from the old Unix days.  POSIX
> for write(2) mentions this as: "Upon successful completion, where nbyte is
> greater than 0, write() shall mark for update the st_ctime and st_mtime
> fields of the file, and if the file is a regular file, the S_ISUID and
> S_ISGID bits of the file mode may be cleared." truncate(), chmod(), chown()
> have similar notes. No mention of this when handling mmap BTW :).
> 
> Anyway, the problem with calling __file_remove_privs() when writing through
> mmap is with the implementation - in particular the locking. To be able to
> call __file_remove_privs() we need to hold i_rwsem and that ranks above VMA
> locks / mmap_lock we hold during the page fault. Now that I'm speaking
> about it I even have a vague recollection this has already come up in the
> past and we've just decided to leave it alone due to these technical
> difficulties.

Perhaps we could just do it at mmap() time rather than waiting for the
first fault?  Obviously only for MAP_SHARED / PROT_WRITE.  I could see
an unenlightened interpreter doing unnecessary MAP_SHARED / PROT_WRITE
mappings, so that might not fly.

We could also do it within filemap_fault() (and shmem_fault()).  If the
fault is a write and the suid bit is set, drop the locks, clear the suid
bit and return VM_FAULT_RETRY.  We already do that if we need to do
readahead, so it's a well-tested path.

