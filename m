Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E3028EA3C51
	for <linux-mm@archiver.kernel.org>; Thu,  9 Apr 2026 11:20:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1CF936B0005; Thu,  9 Apr 2026 07:20:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1807C6B0088; Thu,  9 Apr 2026 07:20:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 096066B008A; Thu,  9 Apr 2026 07:20:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EF7CE6B0005
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 07:20:24 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 745DE1A0606
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 11:20:24 +0000 (UTC)
X-FDA: 84638773968.27.606ABF0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id EAC5E180005
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 11:20:22 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IWgByLzq;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775733623; a=rsa-sha256;
	cv=none;
	b=Bg5uHc6FCDDqtlvz1QOGcYOyervlt3hwhAg9d9tytxiQ+/GmqCSv7bnVDX3gogSKQq+kOo
	mDsFcYOBzRqJEDT3d+sUeGTsR907G+vHoU3RCEg02h6SOHfI6POBjIYb+RUiQi7CHza7sM
	HtLc75tZx8fXoXF4lPFQ6d0sc2/fV1k=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IWgByLzq;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775733623;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LKOxg1CILqlUP770TOGbKhP3GRm9Ln0anknmjMk/RmQ=;
	b=gOuwx0fGTlQKXdwRP7ceHTImXfhIZouyhYVs2wiHgNVwibM7h6q8q/bHOHLUkRWz772Ylz
	mOC1KYv0TgMq5pw3iFMM+YqU0cydL46d603u/8i38HSMubFuOvap5gQ2strHx396zp6sqa
	W74vj1mogmtnm1w0LU52UgxrbZySwmU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C5D0140137;
	Thu,  9 Apr 2026 11:20:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40755C19424;
	Thu,  9 Apr 2026 11:20:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775733621;
	bh=/o2Kzq4IdBBIeCMTS+ThAJwQJ3UP87vmStNfXO+BE+A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=IWgByLzqdhdkhrcG2Xyw13/qx7xftZQnzpDqm3VXJGen68ZDTYJSCxuK0JhaFNyTX
	 41fmJuKHAOrF/0t3MxHNPi2G+ntpxdPsuzOGFjQ+n3H0AtnI4N4Gtw0t6FVZvn6xRI
	 1yLtLjsnd3DHzWYgu/s8MF/F+pKug+dZiz3/MnoUCQwqnJeeg1p4YapTgpWexN57Ra
	 qFX8fLNo01+pDPaJa7b8IzBrvVfYUL6mGjYaWPL8RvVop19eZIa+7lro05C8GVPJj7
	 e9kxgBfRyiNOPjWnKFf2dAQEO9VvhN2vhZUkoJTdBPOhPj1DhbJE2sIS4QAgN+GelV
	 9TWWMYfi8llhw==
Date: Thu, 9 Apr 2026 14:20:15 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Peter Xu <peterx@redhat.com>
Cc: David CARLIER <devnexen@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>
Subject: Re: [PATCH v4] mm/userfaultfd: detect VMA replacement after copy
 retry in mfill_copy_folio_retry()
Message-ID: <adeLb5G3PgE_zuct@kernel.org>
References: <20260331134158.622084-1-devnexen@gmail.com>
 <20260331200148.cc0c95deaf070579a68af041@linux-foundation.org>
 <aczOCqrCx7Xd5HIF@kernel.org>
 <CA+XhMqzdQLZD4YWzyZfTwd_+sDnLqj24APqBRgum97_=8EcM2Q@mail.gmail.com>
 <ac04ZeFdz7yvByRp@x1.local>
 <CA+XhMqz083g8D5xQ5bWNrWguwdBhFv9miMooDhDf1+862ggzNg@mail.gmail.com>
 <ac1wW6LHzzkXBeSl@x1.local>
 <ac3qYA40OW29ibbq@kernel.org>
 <ac5vVFXgyqODXaab@x1.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ac5vVFXgyqODXaab@x1.local>
X-Stat-Signature: 5csem8k6448jxzh5af19zcaf4d1r877o
X-Rspamd-Queue-Id: EAC5E180005
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1775733622-848418
X-HE-Meta: U2FsdGVkX19g/lhoqyTtUw/6ns0ZHnpfKXRdOTg4XkAq1O59Y5aL94+Rccybtr/dYVpIKtG8UROW8JI3hUy+Pjg4qZ+wLtropZbN/erwJz/yPSFEzHy+oVoUG7wyrUCZ0uBoe4fhZ3prcUHjQ8i/qQZiU5hcG1T9I8tNjphsNfP8ZyaRdKOuZLU2jlIfkjQLXVSWkDbc4OJYCF4TLMWL12TmnWC1gvRj+FQyeuUb4z9bQMZiHM96jOZ440XOYeAJF3cbW925avoiZoOrCzJ0OyAE4Vy64oroFnHKelzb1XSft9tRN/7DEDIiQSA1RRGY7GmMFZlzvalSJLFD7ylH3SZcGd41SZw/gGAJ4YW5/GxOoxUTrA90pHiiYFesCTQZha5AfyjJ+Ji5wdHd/KWHqujG413Q4+HEi9jkyDZ4jR7sx3KFuVehnukJQ2oDcMub+lwrgE7/i0gNCEj8bJy4zjsOemjYFujDjJs3635LxNxfdrDRVoxlZtR9XX8Fd0lkPQxEhq+U9I90/bmp4moChVZ9DpZ+gs+RiWNyPBwVS1P9RpMp0bikAXqloU22nFCLbP4lTKlIS0EY9eKbBcMzXeyeJbZnLc3onGB6dTF9xwJFXHAEmYqfj5H7jKnJ7yr+Ohu6Z2ivolIFf9SVCuYxF0OVizL1CCC9knD61WB03IvpEH96nKtb6avL9cEfBg62zwSSxwSZwvo3pbxiUHSSMrTqzBRBYe4fV1Mp7SgUN3JVAauAlLL7MOZDYY6qr4RDapckky3z5HVKmJ7PPWD57FhPt9vATghbU6jYwFZcWqkVN20kAcvTHmWCc+Q8a3IuTIfl2KHgXCkSoJdM0FZqcV8/cIyRuTftHkB/xCWAy/ht4D6CjkgfbiBLNUjHHbYLiAN534eUM8FagNu2IS8P/zH+FFZa/dmDT4nA4hGkmaFdUtwMAIEDUCmtY9f6sK+i6P15ljvB/w6Gp2Q4OhJ
 EdVds6gN
 I2Nhh
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 02, 2026 at 09:29:56AM -0400, Peter Xu wrote:
> Hi, Mike,
> 
> On Thu, Apr 02, 2026 at 07:02:40AM +0300, Mike Rapoport wrote:
> > On Wed, Apr 01, 2026 at 03:22:03PM -0400, Peter Xu wrote:
> > >
> > > The other thing is I just noticed the err code was changed to -EINVAL for
> > > snapshot changed cases, sorry I didn't follow previously as closely on the
> > > discussion.  I think it should be -EAGAIN.  It's because the userapp can't
> > > resolve -EINVAL failures and app will crash.  In a VMA change use case, we
> > > should return -EAGAIN to imply the app to retry, rather than crashing.
> > 
> > No. The return value should express that the VMA is invalid. -EINVAL could
> > work, but looking now at the manual -ENOENT would be even better:
> > 
> >        ENOENT (since Linux 4.11)
> >               The faulting process has changed its virtual memory layout
> >               simultaneously with an outstanding UFFDIO_COPY operation.
> 
> The VMA changed, but it doesn't mean the UFFDIO_COPY becomes illegal, am I
> right?

I don't think that "munmap + mmap + userfault_register"
during an outstanding UFFDIO_COPY to the same range is, hmm, the smartest
thing to do, and I think aborting the outstanding UFFDIO_COPY in such case
is better than allowing it to continue.
 
> For example, I wonder if it's possible someone runs soft-dirty concurrently
> with userfaultfd, we shouldn't fail the userapp if there's a concurrent
> thread collecting dirty information, which IIUC can cause VMA flag changes,
> and should be benign, and I think there can be other things causing the
> interruption too.

Right, we shouldn't fail if some of the VMA flags changed, but we are
talking about of complete change of the mapping, with potentially
completely different backing store.
 
> Thanks,
> -- 
> Peter Xu

-- 
Sincerely yours,
Mike.

