Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 68556EB28D0
	for <linux-mm@archiver.kernel.org>; Fri,  6 Feb 2026 06:46:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B59AF6B0093; Fri,  6 Feb 2026 01:46:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B06886B0099; Fri,  6 Feb 2026 01:46:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A08926B009D; Fri,  6 Feb 2026 01:46:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8EB736B0093
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 01:46:54 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5B1BA1606BD
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 06:46:54 +0000 (UTC)
X-FDA: 84413099148.12.1D26703
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by imf01.hostedemail.com (Postfix) with ESMTP id A841040005
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 06:46:52 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=none;
	spf=pass (imf01.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de;
	dmarc=pass (policy=none) header.from=lst.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770360412;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+tnuxDSSl50an0JQnugWdXkx+eM1BaO7HwBaoqHDouM=;
	b=X94exthHS6fPijEm10B8BCvUPeQ+OyKmASSKAEb77GNUi/afYFIvje1C4IeuSvWm503vpz
	9j31fuB2+bA7z58X98FYv2UDavjG4+tpbAy1dBwC+2kAXrxN0NEXp4PJTYA3+x+5V+FW5a
	FZV7bo+taISG8oMu4xrkq0gq7YTtMOI=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=none;
	spf=pass (imf01.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de;
	dmarc=pass (policy=none) header.from=lst.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770360412; a=rsa-sha256;
	cv=none;
	b=eviG2yETQ3Sei3J9WVcSzFuBSiFbF4VcgrPTe2b5exgbB2B4trEXNZiAbuoMjqgI2Lo++T
	ynNZ5uIrdVQ6j7bIUJUY/gdGZogbUwDt2Y34EOAhZo8BGLc0fkbd2C75lu5Oj3QwjIIHcm
	7o2uoYaxbXpmLonoMfwgHHtrE+y5WG4=
Received: by verein.lst.de (Postfix, from userid 2407)
	id 7638568D0E; Fri,  6 Feb 2026 07:46:47 +0100 (CET)
Date: Fri, 6 Feb 2026 07:46:46 +0100
From: Christoph Hellwig <hch@lst.de>
To: Kundan Kumar <kundan.kumar@samsung.com>
Cc: viro@zeniv.linux.org.uk, brauner@kernel.org, jack@suse.cz,
	willy@infradead.org, mcgrof@kernel.org, clm@meta.com,
	david@fromorbit.com, amir73il@gmail.com, axboe@kernel.dk,
	hch@lst.de, ritesh.list@gmail.com, djwong@kernel.org,
	dave@stgolabs.net, cem@kernel.org, wangyufei@vivo.com,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linux-xfs@vger.kernel.org, gost.dev@samsung.com,
	anuj20.g@samsung.com, vishak.g@samsung.com, joshi.k@samsung.com
Subject: Re: [PATCH v3 5/6] xfs: add per-AG writeback workqueue
 infrastructure
Message-ID: <20260206064646.GA26533@lst.de>
References: <20260116100818.7576-1-kundan.kumar@samsung.com> <CGME20260116101259epcas5p1cfa6ab02e5a01f7c46cc78df95c57ce0@epcas5p1.samsung.com> <20260116100818.7576-6-kundan.kumar@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260116100818.7576-6-kundan.kumar@samsung.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Rspamd-Server: rspam12
X-Stat-Signature: wr3uxtczj5gb6riqnh5ekuk1gnico5zz
X-Rspamd-Queue-Id: A841040005
X-Rspam-User: 
X-HE-Tag: 1770360412-858586
X-HE-Meta: U2FsdGVkX18XXEZrPOR5WhgkKEFcIi3wyeIz+l01w2XCEDLjSAU1JhAe7O8uqejYQZcrRH1quo7QuJH0yEJLgwbjJ6oRS+o4PBKNSZg9Fs7N06ee3JqQp5fdsQjowSUMaBD9KWOM1x7kfCMxPR8fDWmeZIuhVFD8fLt71eLdqIMExaRqk/AFmYVAnLM8GGkYfEN11Se9v3o2CX9GOX+E5CZ1bQBB7nJbzpXQ5M4/5vebquxQacjjTxRdhaAB4cIukh6kLZcIMTCBEjAgz4sOp3KbxA50D4Xf71zVQVns5fl/oY04Ow0KZcYOtNPH71gqvwpc9y+62z17TqMoeKvqA8B49h5oHxYlgWfRA+FXPXXHEyR8xxNaG462h/lKHbeOLcjxmKFHrPbZG7zoXWuVHxHfR2fcwodJzwkQDXXzK93tK6Lxx+lPSMVUYbXviLRB2K9iTyRU0oKXSmU9btLzGYQYDj/PKT45ZSCF/Nr/am+LSKo9fP8qEAiiZUAcskvWlsQbNgaGi5cy3Vht23WLmOeS3ayiIGVNRNdg8kbmlcmGu80GrgQqn4K+sY8d1+1l7Y4bufV7Qu4woqqm93ZyOjpQ8DkAnh0XaxK5A2JyGQ4BxAb25wMOL/oDfEw6gtlU78H9h1gxGzTAIhK2lDp4SMQO7xTcjdZEAIwSg1/C3b4jvHc4JGKy7iVkdYQ3Z4QhPvvx40BlXSlNyRCZzqE+OezfI/y7qv6KdwWCM/4YUCpOpmMu+qNzMz7qpZ9K5z/YMEIsywPSqKvDBKIotaYoThNsXQJU2nTUp6862uMaSc1A6ZVfV4FvNU058CnRuti5vn6vMoFLHm/vi961lz1lMMVPKguK6bfmANqTOpNlz2RX4P4UjV7+iGWbArnPGIX88JuDiz8kLdtMManZw5cMkb4ZwZ/vEkyl7Ox89sFeyfDHYh6IihLDOxuL2rZ2ZqeH69AVYbypf158b5MdXnK
 /3Jn+0Ys
 G0P2ICzXI9e4E10sYo5ICqKI/Pggj+hQZEeJwxIRKSt4WwJFkz7+epGtCPmo6OjbjgDvwRcUn+s1ZgUu5e7Yr5N5BAbuJcqvNGnC6ev7Ksm0FRWQulheSM+l7pW4CRB3Xv/mTPRFYCjaThDukL2eHbCMpUQG6Qaags/61ZUSZXnEJ9n0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jan 16, 2026 at 03:38:17PM +0530, Kundan Kumar wrote:
> Introduce per-AG writeback worker infrastructure at mount time.
> This patch adds initialization and teardown only, without changing
> writeback behavior.

We really should not be adding extra writeback threads in the file
system.  btrfs has done this and created a lot of madness.


