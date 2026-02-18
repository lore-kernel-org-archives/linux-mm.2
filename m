Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 51EC5E9A02C
	for <linux-mm@archiver.kernel.org>; Wed, 18 Feb 2026 00:26:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8A13A6B0088; Tue, 17 Feb 2026 19:26:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 84FAC6B0089; Tue, 17 Feb 2026 19:26:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 74DE86B008A; Tue, 17 Feb 2026 19:26:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5DD686B0088
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 19:26:24 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B48C01403C4
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 00:26:23 +0000 (UTC)
X-FDA: 84455685846.29.E2C703D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 245A840008
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 00:26:21 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bCov9miZ;
	spf=pass (imf04.hostedemail.com: domain of dgc@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=dgc@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771374382;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lp+G4L2JZgMAEzmPx561nXVu6uiQAwXm1567Nc04SCA=;
	b=H/cpj4BX8hLcUvA+uHBVd7X3dYIVH3p6M+MeZp0RZdPE2A7hKXZTu6ljFOnF9HrmjH1eV+
	f4a8buCJTy4dj0F8Vn5yDX8VttnaXbEJ5rQPclGvGinhtm2c6DUyfHVo3JPFGT/BhqxrbJ
	SrXXWxnT4pgQ7tkvAxHSvBjvCnU+gjM=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bCov9miZ;
	spf=pass (imf04.hostedemail.com: domain of dgc@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=dgc@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771374382; a=rsa-sha256;
	cv=none;
	b=i9dwIib7bV6EKy9jfW97qQ3pf3dl+F4WomEi1E8Hos5XXdyfjZgGt6qhiTHuc68JjwUVS/
	RRUCm1b3hqmU1sk8R8mk5RlKBCHEzrxvWQXsUnH6QhggxAJCsJZxy5ZGZyMB3HHYt4ANnb
	xhsvgXLnpkhTUD0OsKI74zm1O5VFMro=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 5C88F600AE;
	Wed, 18 Feb 2026 00:26:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D5C5C4CEF7;
	Wed, 18 Feb 2026 00:26:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771374381;
	bh=JboHkTUEpFKhTIugWR55+L+mSXwfGGmx5RWx7rWQmO0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=bCov9miZG+BJgHwbaa9A/3mI2mNgqV5H6jiwKBjZMR4s7Uc4HRs/90W0cHyCt0wUC
	 oJaKTwSbz0hKsm9K2C4/MXkajHdGBSHPNkW8zbFktAyK2CG7PAUj93YVPMYh4v8hd2
	 utrss9Pqt1DSCEKS/ExNIFOQQoQwPDD0haApo1qj3RSKlR78YxiaJCMoLFYJZG1EdV
	 JwsxKbSMRUNwEQjuuf6JuUH3H9+WjQ4jcTnwgwaKNWTDjaqaL/Eud2sm5ySWqZLeqz
	 ibmbwEPJDCD/GCVzzKSCPvkO78Nmt5bT6MxLg7ZFjQ8oIb1TQzd5XB8bCgs7MKcf72
	 GOexS+YBTVKkw==
Date: Wed, 18 Feb 2026 11:26:06 +1100
From: Dave Chinner <dgc@kernel.org>
To: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Cc: Jan Kara <jack@suse.cz>, Pankaj Raghav <pankaj.raghav@linux.dev>,
	linux-xfs@vger.kernel.org, linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org, lsf-pc@lists.linux-foundation.org,
	Andres Freund <andres@anarazel.de>, djwong@kernel.org,
	john.g.garry@oracle.com, willy@infradead.org, hch@lst.de,
	ritesh.list@gmail.com, Luis Chamberlain <mcgrof@kernel.org>,
	dchinner@redhat.com, Javier Gonzalez <javier.gonz@samsung.com>,
	gost.dev@samsung.com, tytso@mit.edu, p.raghav@samsung.com,
	vi.shah@samsung.com
Subject: Re: [Lsf-pc] [LSF/MM/BPF TOPIC] Buffered atomic writes
Message-ID: <aZUHHvNl6cQr-uwd@dread>
References: <d0c4d95b-8064-4a7e-996d-7ad40eb4976b@linux.dev>
 <aY8n97G_hXzA5MMn@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
 <w3vwdaygcz3prsxwv43blo4co666mragpdwaxihbirt5stl4vr@agyz4mnaxghj>
 <aZS18m1eIxjDmyBa@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aZS18m1eIxjDmyBa@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
X-Rspamd-Server: rspam05
X-Rspam-User: 
X-Rspamd-Queue-Id: 245A840008
X-Stat-Signature: gffnstqop3fkrf5xc5zm5jtaa3wzebif
X-HE-Tag: 1771374381-768646
X-HE-Meta: U2FsdGVkX1+r272uMBbl+v+IhXAeHsiOqQn7SmeikMmf+6wZHRFch8e8/13mUjlQ7OULedyVIW+MiFOtIc16wM1daDBhckd/D9Lq7gw3bUWRkVSfMKUOpp0UcOt3KGwf9dcrEINYsbM5Z/Tw5G2aQsliBL9YYofnMOhUMKKrqGEoJWTY/LvBMdmukuRXW6XR2ck2kDJsozzly48JgYQvTYyPpI60Ya0p7bc0z6NvpE0RcgrUyWAIl0vqHLNQUw/DIkvss6EjUhzjIYYVDthdwqp+wR4WJbv2juOeqlMAshc8CJ14q18Ttx8NK5y/3alNYTm6BiBaGdX+f60EoGg7gjbMylbzGF1MpeLCGbK7d7Xd/TQu2ZDGLMh5OxBTZyxPllf5h5gfm0aHvBkueFdhiyk9DGwZ1wzVnwMP0r/5j8ewapx/U7eLYqo0kMgFQmNP9AxOphDKkgqJUl915Tkme+wqOXc2BHV+Ixh1guya/6UY3RqwuWksQnsMV5gNTgJda53e21Ml/osndo3IcEU41knxBzSmPoEUYoedu5mHOD3RZha5hqlkSmvyiXoGYjA5nu6BOcooLGI2/gtxZ5fsixhCFhTECTRRHQaOhaUyERBCI+zxpRDc5iJWRY5q1zYGdDG1GbnstdI8mJxhPKvdIrSKF67R6npBfv32C3l5R6GZ4LT60Ol7htVKC0osLmHFeKkoOjcjono+MDRopvr+UybfeJwW/ZFDTQNAtntGPfvkntRWN7SbhJdCHIlPw+ZHttl3KruvEwAhYD19rnMOc2yTabDGwzX6U4kzmrF+TdIn+xd952EWKt+Vm/2k2y6Fh8Qt2zXg0HKgdDBcSeG5z7uKQswpEnwutmQIrHsDsdefniSSKAkNyjMxfCXMlGTFpiNjeYqFppxAkEIkFVDLEq8Y7gEQRxiKdl/qlpn4orKmwSQXMbJoNR0OS9AN0hcN+5Ib2YPobhVBVqe7TCp
 6Fz13hnx
 smeyrgzWOtTOfz2m1jhUEnIJVCBcEiX1HAvvLRzh/V62yHVMJ5+uuJliRjoO2kosXBOZRZuhehUWHzg5CfMvc38vCPnjP/fcas/zKqwNjyCmpWuTWZNak6tltQlqyMhwgLZBDV5P1Iui8qOq1+IGvHNWwicZxfDKC4nNsMbHmOqX8t7/8hPmBvzxNjh5041tPhoGrw6/vIiWFoB4H8swBAB8kIsmt7Xe1V66GyTycPudoz7FRM6pg6WhkZBT52nwE1VO2Q2EK5CafZuEACtEe4M7FzWknkoS0CY3Jdr6V84vJDQks12dlS1i0oCVQSYkxkfO2tWQTgHKqIbXm4bdfgLXpRvnhoOCoc7n1
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Feb 18, 2026 at 12:09:46AM +0530, Ojaswin Mujoo wrote:
> On Mon, Feb 16, 2026 at 12:38:59PM +0100, Jan Kara wrote:
> > Hi!
> > 
> > On Fri 13-02-26 19:02:39, Ojaswin Mujoo wrote:
> > > Another thing that came up is to consider using write through semantics 
> > > for buffered atomic writes, where we are able to transition page to
> > > writeback state immediately after the write and avoid any other users to
> > > modify the data till writeback completes. This might affect performance
> > > since we won't be able to batch similar atomic IOs but maybe
> > > applications like postgres would not mind this too much. If we go with
> > > this approach, we will be able to avoid worrying too much about other
> > > users changing atomic data underneath us. 
> > > 
> > > An argument against this however is that it is user's responsibility to
> > > not do non atomic IO over an atomic range and this shall be considered a
> > > userspace usage error. This is similar to how there are ways users can
> > > tear a dio if they perform overlapping writes. [1]. 
> > 
> > Yes, I was wondering whether the write-through semantics would make sense
> > as well. Intuitively it should make things simpler because you could
> > practially reuse the atomic DIO write path. Only that you'd first copy
> > data into the page cache and issue dio write from those folios. No need for
> > special tracking of which folios actually belong together in atomic write,
> > no need for cluttering standard folio writeback path, in case atomic write
> > cannot happen (e.g. because you cannot allocate appropriately aligned
> > blocks) you get the error back rightaway, ...
> 
> This is an interesting idea Jan and also saves a lot of tracking of
> atomic extents etc.

ISTR mentioning that we should be doing exactly this (grab page
cache pages, fill them and submit them through the DIO path) for
O_DSYNC buffered writethrough IO a long time again. The context was
optimising buffered O_DSYNC to use the FUA optimisations in the
iomap DIO write path.

I suggested it again when discussing how RWF_DONTCACHE should be
implemented, because the async DIO write completion path invalidates
the page cache over the IO range. i.e. it would avoid the need to
use folio flags to track pages that needed invalidation at IO
completion...

I have a vague recollection of mentioning this early in the buffered
RWF_ATOMIC discussions, too, though that may have just been the
voices in my head.

Regardless, we are here again with proposals for RWF_ATOMIC and
RWF_WRITETHROUGH and a suggestion that maybe we should vector
buffered writethrough via the DIO path.....

Perhaps it's time to do this?

FWIW, the other thing that write-through via the DIO path enables is
true async O_DSYNC buffered IO. Right now O_DSYNC buffered writes
block waiting on IO completion through generic_sync_write() ->
vfs_fsync_range(), even when issued through AIO paths.  Vectoring it
through the DIO path avoids the blocking fsync path in IO submission
as it runs in the async DIO completion path if it is needed....

-Dave.
-- 
Dave Chinner
dgc@kernel.org

