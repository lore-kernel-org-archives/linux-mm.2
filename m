Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8E1C2CCF9E9
	for <linux-mm@archiver.kernel.org>; Wed, 29 Oct 2025 08:55:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EC1C08E003F; Wed, 29 Oct 2025 04:55:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E98E38E0002; Wed, 29 Oct 2025 04:55:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DFCB78E003F; Wed, 29 Oct 2025 04:55:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id CF4618E0002
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 04:55:35 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 72F1449D6F
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 08:55:35 +0000 (UTC)
X-FDA: 84050543430.01.F5B8991
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by imf09.hostedemail.com (Postfix) with ESMTP id 904B3140003
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 08:55:33 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lst.de;
	spf=pass (imf09.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761728134;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xT4pORLfqaLby9rFuKhU+xXPmsubSSO5lJI7u2+zXvQ=;
	b=B/BDvv+UGEJagh88BZ0j82FwZbpb/EkvK/qRZZVLNnl0v4VlvH7UIIBQ6ACrCLQm172isN
	D6wjAp/f+QBmuhqQrpIyuLKU6ZL2uvOI47hxWoXRQtpEz9Jp6DmwS60VaNnMFNpNX41bcW
	7Z+94GBkydl3NcdrQHZNWIhX1yY4DEg=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lst.de;
	spf=pass (imf09.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761728134; a=rsa-sha256;
	cv=none;
	b=bjJ7WTGjDyCA5axCjBVy9qF8IcAJzJXFiHDkigRQ/jgPd8FIb8OSDN/QVcwBCKQtwYF5V2
	QQMre1v9FpLwJzmb+bMjTlSFon+czyRX69ovtw6m7aZd/StMW/iuMeRLRld1NQ7qyX96Ac
	BQCqc2c431TIlWcrZSTi3Drx4Af7uUQ=
Received: by verein.lst.de (Postfix, from userid 2407)
	id AEDD8227A88; Wed, 29 Oct 2025 09:55:26 +0100 (CET)
Date: Wed, 29 Oct 2025 09:55:26 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Kundan Kumar <kundan.kumar@samsung.com>, Christoph Hellwig <hch@lst.de>,
	Dave Chinner <david@fromorbit.com>, jaegeuk@kernel.org,
	chao@kernel.org, viro@zeniv.linux.org.uk, brauner@kernel.org,
	jack@suse.cz, miklos@szeredi.hu, agruenba@redhat.com,
	trondmy@kernel.org, anna@kernel.org, akpm@linux-foundation.org,
	willy@infradead.org, mcgrof@kernel.org, clm@meta.com,
	amir73il@gmail.com, axboe@kernel.dk, ritesh.list@gmail.com,
	dave@stgolabs.net, wangyufei@vivo.com,
	linux-f2fs-devel@lists.sourceforge.net,
	linux-fsdevel@vger.kernel.org, gfs2@lists.linux.dev,
	linux-nfs@vger.kernel.org, linux-mm@kvack.org, gost.dev@samsung.com,
	anuj20.g@samsung.com, vishak.g@samsung.com, joshi.k@samsung.com
Subject: Re: [PATCH v2 00/16] Parallelizing filesystem writeback
Message-ID: <20251029085526.GA32407@lst.de>
References: <CGME20251014120958epcas5p267c3c9f9dbe6ffc53c25755327de89f9@epcas5p2.samsung.com> <20251014120845.2361-1-kundan.kumar@samsung.com> <aPa7xozr7YbZX0W4@dread.disaster.area> <20251022043930.GC2371@lst.de> <e51e4fb9-01f7-4273-a363-fc1c2c61954b@samsung.com> <20251029060932.GS4015566@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251029060932.GS4015566@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Stat-Signature: igf74myuzcx3sqtfdquwrb4czd94pr85
X-Rspamd-Queue-Id: 904B3140003
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1761728133-913733
X-HE-Meta: U2FsdGVkX1/ntoOwECWh6NFZqD/NoQFgLtnjrjz4wAYxhIx7BquaXJcuBsbR6jklQD07efL07+Eog41wqo/2zDy3RtTElWZDQadgnNtVE1ydp60htHQ+rpwCL+wI2UlOxBqvNi9y62nYPvl62UOVX05s80URM098m2vdUfNJE8sSqgI6C6GSdpVm043ef5VobuhQk7pJ9RydPRG4Dr5WyJib4+0wKk5Ha4M/z3NdLPWNrk0+YK6z0+EMTDFT6aNtdiLqYbmDNkdeRqq0L4kZ4vERAL3ZGGyMTYMUJ8UmWMT7e/3vtAnk8bm/V9Vubs8eYsIkmJcLPPf1PTSgE/6TONdNp2xIH9tpd/EaXk4rczqloy4M1M5Y9etxQ5LFkL6xswTD5uFBZekfvmBaTSmp92aeKFClmkjb6w3pKyFKHkcPSC/p86cRRZD2fcF34NKhdP3NWLFz/BW9nB8e32MIrfqx6bAjIRmMENqI/DMz2+U5Vbqye6gxfTTz2OhL/xcrsj5XAtXXXscqIV1FuLg+n3sLMm8S+7YFEBbsBhrefY57I7lA90sf3r4ZtfPfVIgGppjroaWMDzzlkfRBpYyRJU6JlAyfZoDB7/R0p7Msn7sVi/6dgoAycl8cmS6olN55u9z3FeXIBADaAvTmERyY9VGIvAdJal5o7Qn66xvztQ9BJ149btGkWkFRvRcCRuJZbyYHGs5F4nIhJrrVaH7Jf3v1kjVRQCpQPgUXjOr7tOksoRoPkoBuHTCm6FHf2uIfwSdw/KsI19vcpHgors64u9lOiH3nMBhd9riY0JCKgBgBApM76zQQBxHx7PuNCo2NAACU/fcYUZAvvOkIwziIRfoqnqwaoYPVPW3yiewhbCYnf743tJHcuhWzyknLuOtLEDk9nca4eWT1LxbjWEDOYf1n5fifsbSf/BMI8JS2jNzCkpy6pILeS3sH+Gp9B9+EComtemSK1yb1YCSr+4N
 Oe/DljJn
 qX0uTuT9UOKCGRnafMOZPYRndb79/azM0NjSD5TMCqgfZ9vGLEVFLBCge7j78EGb3wpO0Q8PPr3qVy3obzcBWSQiOR3RZWkz/BnGnWxzruV1ewmVlR996HP/RKzBUAFZNATjtciGQ3aXbC5y9YccIEQl2TlolmDK7PKQ7CjHb5bgFAr4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 28, 2025 at 11:09:32PM -0700, Darrick J. Wong wrote:
> Was that with or without rtgroups?  metadir/rtgroups aren't enabled by
> default yet so you'd have to select that manually with mkfs.xfs -m
> metadir=1.
> 
> (and you might still not see much change because of what hch said)

The real problem here is that even the inode number to AG association
is just a hint, and will often go wrong on an aged file system.

Now for the zoned RT device we could probably do a thread per open
zone, as that is a very logical association.  The problem with that
right now is that we only pick the zone to write to once doing
writeback, but there might be ways to lift it up.  Then again
zoned writeback is so little code that I can't see how it would
saturate a single thread.

> 
> --D
---end quoted text---

