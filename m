Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 62862CD37B6
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 06:56:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8AA746B008C; Wed, 13 May 2026 02:56:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8809A6B0092; Wed, 13 May 2026 02:56:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7BDD76B0093; Wed, 13 May 2026 02:56:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6AF416B008C
	for <linux-mm@kvack.org>; Wed, 13 May 2026 02:56:15 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C9AC18E172
	for <linux-mm@kvack.org>; Wed, 13 May 2026 06:56:14 +0000 (UTC)
X-FDA: 84761487468.17.A9AE914
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by imf10.hostedemail.com (Postfix) with ESMTP id F06D2C0005
	for <linux-mm@kvack.org>; Wed, 13 May 2026 06:56:12 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lst.de;
	spf=pass (imf10.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778655373;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Dbax/n2PuXSr1L7VYwyXeeuH0mEbfBGTLmPkem6T8y0=;
	b=2JZZPK7lB6dvWrlSz//UVSW2UFdj0VyVwViw0qmAaKnkiLx1dy3DPQMg0UvpZmDBSkkBaY
	3zD3+G3IXagWkBpYGfk7+/jY0W6xBrueHExWmR1qy4pVXYC3dWebdWDZ7nH67QzOux3MlG
	NsvJACk4GQ68vxT/kN1ZGjJ2PtVOong=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lst.de;
	spf=pass (imf10.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778655373; a=rsa-sha256;
	cv=none;
	b=d6BdOWYsc4U8V2zxRUijOsiyEEqqVtWScAktIP8FA/26rFBcH+3ycSfjj6+tY8gdYW2sPA
	sExMKagPCWo7lKOL5BADJALu6mvmGg52OQWAvyswX3mt2WvMjIA/LP7Bz2oK2oFZWO3n24
	yZVYQ2Dn4ZW3FQg3m6YI+DDvUK4jGr4=
Received: by verein.lst.de (Postfix, from userid 2407)
	id 82B0768B05; Wed, 13 May 2026 08:56:08 +0200 (CEST)
Date: Wed, 13 May 2026 08:56:08 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
	Christian Brauner <brauner@kernel.org>,
	Jens Axboe <axboe@kernel.dk>, David Sterba <dsterba@suse.com>,
	Theodore Ts'o <tytso@mit.edu>, Jaegeuk Kim <jaegeuk@kernel.org>,
	Chao Yu <chao@kernel.org>, Trond Myklebust <trondmy@kernel.org>,
	Anna Schumaker <anna@kernel.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Hyunchul Lee <hyc.lee@gmail.com>, Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Carlos Maiolino <cem@kernel.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	Naohiro Aota <naohiro.aota@wdc.com>, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-mm@kvack.org, linux-block@vger.kernel.org,
	linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net, linux-nfs@vger.kernel.org,
	linux-cifs@vger.kernel.org
Subject: Re: [PATCH 08/12] swap,iomap: simplify iomap_swapfile_iter
Message-ID: <20260513065608.GA2250@lst.de>
References: <20260512053625.2950900-1-hch@lst.de> <20260512053625.2950900-9-hch@lst.de> <20260512170204.GI9555@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260512170204.GI9555@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: F06D2C0005
X-Stat-Signature: 43cjs6nw1f84kutgz4pbrqzoipwd68pu
X-HE-Tag: 1778655372-971172
X-HE-Meta: U2FsdGVkX18dDuBM2wYW/zcuLFyZic68aYVhITXJ3njyyG0vFdDQ/BMColroQC006BkDWYI0pYdZIJjHkKN3mOk+RIGZ7BlGDLTLWTiihyZpRK+WQeM8/dsY3P60ay4drewZD8eE0dLlonJo3m4d5Yx3Pz5tNq4X3LzeQ2mEzpwnghxr708LRP41eL6T4iAZ6LgEVQXFjzEeKaCbUBjin/+Y3i5dhbjgIlb/WXiT6+On7ZRLGyATTU6gMVKekv9quyBJAn4YsUtwInqWo/BjoN3ZbGyBJN9Bs8JIbGnvUTPKViWt362rjz7qXlzxaSM0GsH723jNfHsqonjZ+vQuo2CtRGdmfeC7MskS/KBwXhyiDNXAmvCV1libVVYNBMANHcdbS8ktQGfdqgzfgm5fHpS/+hWaCf7v7jhztx75wqrrRmEyKA1kszGyqdpIJVgYUp82JHIIqJBRBQkarFdWviBhVqn13sPW0Hn8ZxJ5aAJfYeHwMxAnsLBFs4d3x9G4dEUhuBqjjSSTYtWtz/oy5kXUX9WTM2l1MP/32TrRXi5JRoyU1IKxn2AhnW/bWGBrfVV+ZrzK3/OsrB9hxABqcHvNGTOSAWzALQ3j/JLfmPxbMLA8VKmjqsyPVpI2sv+yrBj2T5HCavqyZZCfGnrDjjjQv888vTskLFxLngHUu8u9+K2frxAODMQl+q8m4s7gRjsTXeKTZ9izWc7R297muktE88wUV1XCOAqL7VmROlqWCJ+tWgpksq9E1IffncIFYtHLnYstWWK1/jqYxizSGkd00m8afPsWWlLry6cbOOwC6iQPtrC3dO7TCjQS3DLABOQbaAfNGeErTAlukg/rLVC3JGWvZauC91q0O2y9xboZzYu4otyWZpi9U058Ake9qfO7obUXnRy5Gt6llNnz3CyNk2epqwc6FuJQq2G+clnWt3BLpJk4EuZu4lzbPyBsuFEMorCHrZ53r7tFU5O
 rFEzIJfW
 hs7Mn7PVHGOpeGWkyv3Ul3LjUHqphGlbT9PId1QVwJKnDY0wu7R96hJLpkghkeld8n1Scl2zQa4ZfaapUQq5+0fZ6cMDb2U4LLvoo0OwFwdOR+bd1Be8SgHHfvAAZ7zwXfG6RS8fCaMKZJ48fn2dtQ1RgnkdI95/5t6rMZBjGrpZOmB4D0KFxYaFsKAF4OCk7JNm94izDQUulNn1Til7mGXllFw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, May 12, 2026 at 10:02:04AM -0700, Darrick J. Wong wrote:
> OH.  Now I remember why -- it's to handle contiguous mixed mappings
> better.
> 
> Let's say that you have a 1k fsblock filesystem and 4k base pages.  You
> fallocate an 8G swap file and then mkswap it.  The first mapping is a 1k
> written mapping at offset 0 for the swap header, followed by an 8388607k
> unwritten mapping at offset 3k.
> 
> The PAGE_SIZE rounding code in iomap_swapfile_add_extent will round the
> end of that first mapping down to zero and ignore it.  The second
> mapping will be treated as if it were a 8388604k mapping starting at
> offset 4096.  Now the page counts are wrong and the swapon fails.

Do we care about this use case?  I guess you did as you implemented
his, but still?

> 
> A more generic solution to this would be to change add_swap_extent to
> take sector_t addr and length values and use them to construct a bitmap
> representing contiguous physical space on the bdev, accounting of course
> for PAGE_SIZE alignment.  Except for the swap header page, every other
> contiguously set page-aligned region in the bitmap gets added to the
> swap extent map.

You don't even need a bitmap, just do basically the same checks as
the iomap code when moving to a new swap extent after moving to use
the sector_t.  And it really should anyway, as the current abuse of
sector_t to store a disk offset in PAGE_SIZE units is pretty gross.


