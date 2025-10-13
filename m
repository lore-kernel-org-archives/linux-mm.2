Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DBFDACCA476
	for <linux-mm@archiver.kernel.org>; Mon, 13 Oct 2025 07:41:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2A8EC8E0005; Mon, 13 Oct 2025 03:41:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2596C8E0002; Mon, 13 Oct 2025 03:41:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1217E8E0005; Mon, 13 Oct 2025 03:41:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id F11458E0002
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 03:41:25 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A895B1DF587
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 07:41:25 +0000 (UTC)
X-FDA: 83992295730.17.7459AE3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 0B5C2A0004
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 07:41:23 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="F/DFd5ZY";
	spf=pass (imf15.hostedemail.com: domain of dlemoal@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=dlemoal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760341284;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gjBd7ViABM92G5SbEPZDU6kQ3B1a97IO6iX9leLL3Kg=;
	b=kbmQ3FqhI/dW0VDn7my/m03vQtJRjCyZuRWFjeQYTK1h8EpBiFSc5vEaBse4hl3YQ4R0x8
	QFi3oX47HvaNyVBvyljrmHQxed1lYUc05CYgzmHJZL9d6yOsWYwvLQMoCcvAQA71tqKaDx
	9hyeXMiyMCytgcHMiMNy1me8hLxVKXA=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="F/DFd5ZY";
	spf=pass (imf15.hostedemail.com: domain of dlemoal@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=dlemoal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760341284; a=rsa-sha256;
	cv=none;
	b=mAGIAWa+sRf606kSNMaJoKwVPQ7phuiOGfSeB526H+RIiCUe4mtadhylvJa1h69tjeHiQm
	0+N1WiG8lZtr++vwnO6QHRXrA25fPVdXbyYajR59VdSVYCCjC6l4CK7QdOBAZeeWAVa5GC
	g8YGOWQfq7beVpbhAW35o7BFdn0ZfIk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 209AE604BE;
	Mon, 13 Oct 2025 07:41:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 445E3C4CEE7;
	Mon, 13 Oct 2025 07:41:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760341282;
	bh=9BuTDzaR1my5eKzXxHUiTDJrNndjS3jKSzq9fhN1ZZI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=F/DFd5ZYNP3J4xWwD4ImXWRAWOwNap/62bMhdThDYgc3/2IeAz5fOWHNeFTbdUa6W
	 JQMJl06Yc7WAUEse9bKwJr7KQXApDxR2fsQ/ZbQftiID6tJFy6Jnu2iQ2etXhYY/1y
	 fVXIyAHi8tj3743VeMDXBjLUUrv18KxGfykZwRfAP7rdEtulKKUOga9wIU4T24i89s
	 5cCRR1LLRSGWJkqeQgu66Dho0nOsRvXxAhZp39wGJg4Kw1XaJwc4WPhP67KOX4l0Nu
	 JYHMFDzA+2JaD+TLc2aws0RwskQ1TJFy11dVJWXXcBlGHq7DxG1Bl9to7qt0KVOyIG
	 RWBwZk7se8h2A==
Message-ID: <a1759d1c-08dc-46e3-96b2-9ae2d8258b22@kernel.org>
Date: Mon, 13 Oct 2025 16:41:17 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 01/10] mm: don't opencode filemap_fdatawrite_range in
 filemap_invalidate_inode
To: Christoph Hellwig <hch@lst.de>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Eric Van Hensbergen <ericvh@kernel.org>, Latchesar Ionkov
 <lucho@ionkov.net>, Dominique Martinet <asmadeus@codewreck.org>,
 Christian Schoenebeck <linux_oss@crudebyte.com>, Chris Mason <clm@fb.com>,
 David Sterba <dsterba@suse.com>, Mark Fasheh <mark@fasheh.com>,
 Joel Becker <jlbec@evilplan.org>, Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Josef Bacik <josef@toxicpanda.com>,
 Jan Kara <jack@suse.cz>, linux-block@vger.kernel.org, v9fs@lists.linux.dev,
 linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, jfs-discussion@lists.sourceforge.net,
 ocfs2-devel@lists.linux.dev, linux-xfs@vger.kernel.org, linux-mm@kvack.org
References: <20251013025808.4111128-1-hch@lst.de>
 <20251013025808.4111128-2-hch@lst.de>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20251013025808.4111128-2-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: ubk5sejdsio4ha4a4yjjfrokps1yw15e
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 0B5C2A0004
X-HE-Tag: 1760341283-389011
X-HE-Meta: U2FsdGVkX19rcwgdInLIS7SYpFqzqejyeT6DSzGtiiZf5HnwIafiQzIZ/UPWZI2YrmjMqvWrwg5mMvd+NDA7UpCDzbaYpNTVn0MnpNE1IAiaCoGtQ/D567sgi998EZ5fV5gMRW++eBGBQpR5P2P0oGQmibUc4OswQr0Kml40kYUdXL2mucBm6zeUvz6YAJrjGFaNvwVsXDntvjVjWSWtDkaiMVdtCRdcuAS/MN1m1ThytVzBgKcq3dlf2yrzkBKIdJgZ46u8PZZKUyC/istY42Ps1zVNAgX/FautNZEJXFVIFS/lXQ4gJGum3w9pXwlwpL/cxVG0J+I1gsXX1YZrF9aIqAtFSKIqAaLZNtAba+pw+5oRCltHz07Qe1/d5Ha4WvUmthx3MPZ6zshZZMDOWYkESyMF7bcGB2E3Y7TzQt1IURqG51uASb/1o9yLKHRB8KNG9rP493Pm/y9+q9JzqtxQOA5f3Y08FnqCnnavpiujab85DvYmXZcnI7ZT0ByDagZuoTZeyhT609rWoOELTGhYve/keF4hvzGb+mLRs1sI8WLfEwEypNjbc5eLxdUxvEOw6317G26MT5pxpPCQQ0+0d4/0mJaA4SxVF3N4t3HumTiUw8Yb6wh9u0h4bZvIRqQOZLQUJG+f3H7fjrB/sjol8j3sFxqgSR3Fs/Pgncz5iYjXYXCwZFhj3Fjp9ASxY1HpO17rr5hkgrAVYf2JEyNNOGwUz/86vYH1db3PSmjeYav2qm/p62FGDeXMRufpuUJvMDhvK/z46blOliePgq07cFTSwI1BroDzGpkYs5tGDq88YvmO/m/mnShmXEU4HsCk01AqQxjQJX586hsGn129jtUQBRghc/3N2blyczlPH0xQxIVCtqXsV8uH7fX9cQfIb3mm5TMhF7qh13a6fn6idRR2LDA3qtKzWSawBuxEDp1TiZSmoXLpTYrw5IH1zDfUqMcv+RBOybyknWX
 V0QUwlJA
 9hBFftN1MljkTmh9ZWJTfFtfi7Cl5bz+yOOTRefDCWkKSqXuWG4+I/cGA/u5rdyIgzIXMLL9/JTB+aAqeD3MgT8al3PlVqebmzqGjgpf313rxTahBvSZb+2vCpqZqdx+68uNQu9XI/Z8FmJTTsozuzKiX5Tu8/kw7XlSwF/UT1uTLHxhcQDUohPTjL9ZPO5Y7DMEI1pqRDsuskKuHIy4YgENwgBu0/PrvJVK2ccUtkkC1gvG/wk3Y4Ux0bT9kECuuH9dtL0Vt7aW9haSDTLYmXF39AdBujxW7mwWUVk33IYmNqNqRd5dlifp3AItJ7J43+VSPBT3Pisya8yNetp777QqNpNWXkS1L38ZrNOVhx/3MRc3k1QjJ7ThNlEG113Ea1wvQHAJKkhg5vY37AJMkq9RsMYq6pT8oP5U1kHwYL3ykg6Fb8NrYgFI4ByL17KEpcGxnA0FVgKReMfg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025/10/13 11:57, Christoph Hellwig wrote:
> Use filemap_fdatawrite_range instead of opencoding the logic using
> filemap_fdatawrite_wbc.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>


-- 
Damien Le Moal
Western Digital Research

