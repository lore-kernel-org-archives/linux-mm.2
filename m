Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3FF81CD6E4C
	for <linux-mm@archiver.kernel.org>; Sun, 31 May 2026 00:35:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6C8926B00CF; Sat, 30 May 2026 20:35:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 652A06B00D0; Sat, 30 May 2026 20:35:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 51A2F6B00D1; Sat, 30 May 2026 20:35:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3B9896B00CF
	for <linux-mm@kvack.org>; Sat, 30 May 2026 20:35:32 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E086E140337
	for <linux-mm@kvack.org>; Sun, 31 May 2026 00:35:31 +0000 (UTC)
X-FDA: 84825846462.22.FB29B08
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 4D3311C0007
	for <linux-mm@kvack.org>; Sun, 31 May 2026 00:35:30 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=d53H0TLH;
	spf=pass (imf20.hostedemail.com: domain of jaegeuk@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jaegeuk@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780187730;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=c8RBaPvCP6ZMekNwxeunAIbpIE5CulD2vhb0civMEuc=;
	b=QRn9KNRV0ySwNNk8dzbRLMlw6Luz5XdPqoSwl3FLndY6F1xlwrtw83SFVUq7zGKavGURWg
	+hgFuv/p6vkwu2MJlZ3aHYCy0GRUDaBnV+oL16x5G3IOTuDQdneGdPY2kj9iUAVNGrloVc
	3K1QAvicRtlZTPhV+2oQXUsAVSCFFIQ=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=d53H0TLH;
	spf=pass (imf20.hostedemail.com: domain of jaegeuk@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jaegeuk@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780187730; a=rsa-sha256;
	cv=none;
	b=zlnf4m8cfIZLUqA9lEmrhKPwXR6xyb9/k+eLQsM7aF0bfUMibsQ+67i8cZNL770EJCjfCr
	eXuOqLt07jMQSBnc52OTa83doFvLpWyHZ1fT428hHvSf2vqCSBkpIw3CSxPipIVkDwlWy0
	l6EBsSpDpr3EnCIWGil9VJzfl9gq+eM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id AD8356001A;
	Sun, 31 May 2026 00:35:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0179E1F00893;
	Sun, 31 May 2026 00:35:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780187729;
	bh=c8RBaPvCP6ZMekNwxeunAIbpIE5CulD2vhb0civMEuc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=d53H0TLHSiX4+p2qwlrpbYNSkQr89x9B3WOu78Q9gI0I8WEUkK4/F0Zh3HERksKXa
	 hg3haxL1FnZcxondubwZwSNMfqkYHFUlb1pVtumAOLYPxzg9iYQ0pDorDrMaBgKOD/
	 19SMFIXoJdy9v1FI3zZfF9v/cgA9sSj7H7cQk2XdS8zrPotiR+MuiE0Uv2MC7VN0Oj
	 D9qPYvBnffngDkemA2x1OvI+zzU9n1afjMGdGZN9X7wZzeaN3mSqLcp9+AZOQIZICx
	 RomPOo2yIKZt95Ctpt1mPpJrInk8xy5K7p3NidJmIZRd+riM76W06RmR+UlHx97mfR
	 4qsbhgJyW6jMA==
Date: Sun, 31 May 2026 00:35:27 +0000
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: Matthew Wilcox <willy@infradead.org>
Cc: Theodore Tso <tytso@mit.edu>, linux-api@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net,
	Christoph Hellwig <hch@infradead.org>, linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org,
	Akilesh Kailash <akailash@google.com>,
	Christian Brauner <christian@brauner.io>
Subject: Re: [f2fs-dev] [PATCH v2] f2fs: another way to set large folio by
 remembering inode number
Message-ID: <ahuCTzdbvhCBJzcl@google.com>
References: <ad_AVHe7RMnGrGTb@google.com>
 <ad_HwhzlNPUEKQi6@casper.infradead.org>
 <ag7HfNryTmQ-bVIS@infradead.org>
 <20260521155748.GA79343@macsyma-wired.lan>
 <ag_OVwPF49LSZ7rz@google.com>
 <20260522141115.GA8258@macsyma-wired.lan>
 <ahCNmWbcd_2lAJyk@google.com>
 <20260522224108.GA18663@macsyma-wired.lan>
 <ahTzHyHBL8t0iNBR@google.com>
 <ahiZRpE593n4blxn@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ahiZRpE593n4blxn@casper.infradead.org>
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 4D3311C0007
X-Stat-Signature: nzyg17h47gucy9pxtfgssuf46g3h4pxn
X-HE-Tag: 1780187730-305068
X-HE-Meta: U2FsdGVkX1+EpBvZ99Y4axMMkJ66v5GGZ7Wo1hnnBOzyBxM0oAgmD6apyo1ZL9yv4Xw8l9eivkvZua+Qf/NsO3y0IZdHYS3eqXyJetY9ldWIq7bxPshDvxbUxbgMKc7T9BJoAyUW1Txi9TKu4/29mJuaMZKTnB/02KMzndqsBSB7I9lVFToyNDKgN3H9Rxzb9te8ymfg8Ebc3eSqUDpw498Y3gi39x012kTXCsEsYjfH9bW0FcONTkfXdNGh/rYXWqnrmNjV/00+RnSUQEcSJk2CVIFHYmpLylGxgg3pPLVEUG8YfjOnl67kFxXQa8isk2jltRbxblHMC1JJlSk9Xo07f+OhpoZs8NrL5sr9OBSy0q62WaMruLLDYTu4r9qZpHaIPH7vLO/66DiZrgCCmTLnzm2ZqVQGiyzGfy18W0mN9g95WpUcoKAAjef6LKwNvF+IWV3CsTykgKHHQFrV3UNS1SDV8wCe+rUyt1je8JrvJcBeSMqnZmYU2y7YN16vj8ZQk85ljFUuPJGpJrxyT7SG623B5KsspBOBI07YCpr1xUlmcxPBvcBVlEeBlHm4DSe0faAHJZo3BU0RMO9kBo9WxGx5/Y0NcyQU3IQG77a9xGCsPC9XIyuGLUjTbnMZotLd3eSbZbybH9vIZyK4I/5CiZrb2Tua1mPFZsqvkNdw5g+UMZyWtjZ2OuHy2X8pamttfFKkmiT1mbKIGwWLPCShqg1xqVB5CKkjalEauBpd1Fex2LNz3DE4zhLD9Pc6HtnN4cYGhQB6zhbLZyk/srJ4EIyEwowEpDEhNL1ourxO3S5Jf/wmbkAwReBZKEQKfF+SRWx+FgUzBUmJNa5qzGypf7a8T2cuCK2bvDm7KuqivkkXFtlxvbYJDupq2pjSmvZan7KYAaAbUfs9c5V6rxe0zxmusvojuxwWl85YdQ1f6CFfzbmXSEVcIe/XL20UFo7G/suWVbxewpAC7Ge
 xds3eTMW
 qPOJF13LGQzJcCEynM+W3oe3a3ClLksh6/XOiLIobsuosCKQlO2NO2FgcqBac7ct+vB8hK/r7TgbcA6s/eSxk7A+7mXoiAi5qTbyn4hpdoMOEobz1mimYkzU6e3QNJEfTuYzz6sTCaC5MvIEynbACsOuxaMR3KP/+TwwTTb/Msdrn6NAtFSW6IxauGBNv8NULxPIWEN6nIYS7IXHe4QN5RQusmyUja/0OJgp0AUfluOrlHpKBs4Bnkw5qBTQcQbSVCusaythCCsmYHw31pZgX7dzKKBhDkyBjSwm0y/X0SiwQe38k3WyoRW01Ew==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 05/28, Matthew Wilcox wrote:
> On Tue, May 26, 2026 at 01:10:55AM +0000, Jaegeuk Kim wrote:
> > Background
> > ----------
> > The primary use case is accelerating AI model loading, which demands
> > exceptionally high sequential read speeds. In our benchmarks on embedded
> > systems:
> >  - Using high-order page allocations allows the system to saturate the
> >    Universal Flash Storage (UFS) bandwidth, reaching 4 GB/s even at
> >    medium-to-low CPU frequencies.
> >  - In contrast, standard small folios cap performance at 2 GB/s.
> > 
> > The performance doubling stems directly from reducing CPU cycle overhead during
> > memory allocation.
> 
> When you say "AI model loading", are you mmap()ing the file of weights,
> or are you calling read() to load the file into anonymous memory?
> 
> This matters because for the first operation, you need to allocate folios
> of PMD size in order to make best use of TLB entries.  For the second
> operation, it's more important to iterate through the file quickly,
> freeing folios behind you after you access them so they're available
> for the next batch.

We deal with multiple options tho, what I'm looking at is mostly a preloading
models by mmap(MAP_POPULATE) which takes the readahead path bumping up the order
by 2. Previously I also looked at fadvise(WILLNEED), but gave up due to the
broken interface. OTOH, we use RWF_DONTCACHE for read() case, but I don't
think it's ideal for the best loading performance.

> 
> 
> _______________________________________________
> Linux-f2fs-devel mailing list
> Linux-f2fs-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel

