Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F16ACCCA476
	for <linux-mm@archiver.kernel.org>; Mon, 13 Oct 2025 07:48:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 43F078E000B; Mon, 13 Oct 2025 03:48:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 416A28E0002; Mon, 13 Oct 2025 03:48:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 353518E000B; Mon, 13 Oct 2025 03:48:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 233AB8E0002
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 03:48:15 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id BFCCF1194ED
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 07:48:14 +0000 (UTC)
X-FDA: 83992312908.01.C8A7AF6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 00BCE8000A
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 07:48:12 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UPPmQkpy;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of dlemoal@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=dlemoal@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760341693;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=T5LTKgp9fwueJ2RgoRVhHKml4+wsGy+zdEi5rwXNdX4=;
	b=hDRMzum4x3K2nLwqbueJIhCeBNlQ6JtBazlFiDzaY2zo/MiAa2RxAiLbQRoX930UU9d8ai
	SKiUviOlbZpFqqTrg3bqVjTcD7CM/zA2oznvFCS9t88cTp+dl33uaJ7t8TFCm+8Jy0tfmN
	T4B2Fle23rONVzbWcLHcIqKAzfmsq/M=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760341693; a=rsa-sha256;
	cv=none;
	b=Q9DtmeB40cOCy8TpmFmW4asUubzM5sRYNtMuG3Lci8yCFgQin9uJfquTBDOmi9mgU7qyoK
	sY6uYTFBPXWeuGEh+K4opg7bx4PC528z57MFSw0QVzZzpOAy6rUHOFNeD2CaDQojbMtey9
	YbQfxETxaNDOMOlK/out/sOCx7NXQX8=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UPPmQkpy;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of dlemoal@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=dlemoal@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B2DB243A30;
	Mon, 13 Oct 2025 07:48:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14BB5C4CEE7;
	Mon, 13 Oct 2025 07:48:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760341691;
	bh=W5wcCFPexeGvn/sWSNJLJR9WixkS/7o9Gp49Ix6jPvE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=UPPmQkpyyYVS6SOITQIR/LEENy+jW+pKmV5ySk18gTKCucgkHN0dqQ7TKnMY+LaK6
	 EDi+sx9kCjZEUtwvd5w55ZndyNVIxgknDRmJrideQfFKgHVz4+9SsJr0m8x+PocrDm
	 xqQgWiOSWszxzHuvV5mYNWImqt0WlPe9/zd17OvqMXFiSSVNPF4hbTxbQtxUfaNPu6
	 Pt7OyMr8bHcfKmIpXX77KjuumNNIKfuiJY2Wy47C96vfDrxy5xH/bW0v/XnYk89arN
	 QPKWQwGZtw0c/lR0fFdRJuAU1uZSFpxzo20ZIF/pwbY9proseoAtFujC1htoxYXum+
	 4zIFMnJ01t21A==
Message-ID: <e7521bcc-ee24-479b-8384-a0d6e1de43b0@kernel.org>
Date: Mon, 13 Oct 2025 16:48:06 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 04/10] btrfs: use the local tmp_inode variable in
 start_delalloc_inodes
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
 <20251013025808.4111128-5-hch@lst.de>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20251013025808.4111128-5-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Stat-Signature: t3ef5cmoaf8y33cwdurtjc37sqquuipp
X-Rspam-User: 
X-Rspamd-Queue-Id: 00BCE8000A
X-HE-Tag: 1760341692-229389
X-HE-Meta: U2FsdGVkX195nrsJCbUyWNQmrEOnYvmpZG7qkzg051k/eni2GGyfSX6l4zblH9YXLvhIdGQS9J0CNp+vjbDL8FJFo6uuOKQ0PHmQgB9XazhpR1AD8hUbHRoBHsN9X+qtoinQiXmdg0fRiSuzZLtpRaih4pdqbOjH7YbUib0X9Q7+qJ0MUiqIpNFGjHrLZtqB4464U6yUhmq44fYLfuL3NQlwzPpsLazcS2Inpv7iZchE6R0WBG84sokFNZd+ZwychkIKLyJEzPLhdIRCWN7e//oPD+hzXkWRH4b0Pcz7UiFMNNhgsNLXyLNgqI/0WQ9wekUePybTezE8aAn08eenxq25NQCD5VPa1bbDeuxcnBuStVpY2S2SiQhgMeYW8S3jHQkny8jQJ3zYCC0xrH7TXBhDCn8oV+zUwJv9keHJUUHx2Nhqsce6CmFKGN00LdpVhwLLWVvv/M6OYbf/JGTm28CogNTUocyEq5yPOa5Pqc7/arSQyO8bYePn1Es46R5kuCTJ6y21rDD/zn3GQIlgwfE2tjWZ3Ny8DjWGE34W7QnhTV5ODRLpIsf4Bg/Nn/vvCAm4s5WR0tuXpdpsqAZtipribSPbiFujNf1Aw+azKSFaXmPmlBHJs3HOg2joNYHoWvO27v+xPlmO6Znj3SDatfkfVS75LSjKLJ7Ar/NfdnZRC4NPWXalw9bryQSca96WnXV65VnFWle/rmjmgLZPHe4vHAvu9wUJs0RH7/rSi8mUmROnGOXUFnAvi+iNBFJneTN+I77OGkhnwIsgT0eypdHqZtAA8P1D5HLWmHah3Xkrm2DQzDiW79NJV5PtUCKie9UmlnhxGZkcgW0qVmO9jGw8akTqugPgkz/iSgFSj1oQw9xh7AJ92xVduxAEWhAlp64+NQiPQwWaKQNQmmsjICJ031ML2mHSu2YP2oRD3tl6CHC1xiapPiKfQWmZYxAPJRXISvY4skT6Sf8YPPU
 arbyydtv
 iKcHL9rnx/iBElTRi0Qy7zcMtEb+SSei8SZS+LI7Btw+d2dB1vIqhXqZcuG1D608DK2k+vE8+wilQAfmQDF8JHeNN9rgc5nEV3+4AiBo/n4qUIyFlqfUGEWPtJmPc8mt8uiHIsyUzoyZm58dNlI2u+zsm5MuO7bqoP811xuB4Jg4KxOV6ku2majrEXur4pXfaFZlPap7xRdcBH9Fq6sb7flG44gFh7llrNCkDA4uyicjwl4XnF/F2DE+hDRo0Mi5XcVfjGZaF1C1asOt8qY9qBag6ipK0t1ensKNPhlibOEcMlLJ2v8yPPojj9zihMe5vqLVQ/iJtRrN9dRobQZTtLW1RG56OQ1tuL1ug85fKxCVweYA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025/10/13 11:57, Christoph Hellwig wrote:
> start_delalloc_inodes has a struct inode * pointer available in the
> main loop, use it instead of re-calculating it from the btrfs inode.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research

