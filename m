Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4C8A7CD5BC9
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 01:21:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1F1A56B0005; Mon, 25 May 2026 21:21:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A3036B008A; Mon, 25 May 2026 21:21:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0BAD46B008C; Mon, 25 May 2026 21:21:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EA9806B0005
	for <linux-mm@kvack.org>; Mon, 25 May 2026 21:21:37 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8D24E1A0259
	for <linux-mm@kvack.org>; Tue, 26 May 2026 01:21:37 +0000 (UTC)
X-FDA: 84807818634.26.D24D623
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 10E52C0006
	for <linux-mm@kvack.org>; Tue, 26 May 2026 01:21:35 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=n0aBwEs0;
	spf=pass (imf22.hostedemail.com: domain of jaegeuk@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jaegeuk@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779758496;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=K08IF8WJnEk+HHOzE8UXb7WzEnURtUvmOtiXBoUticQ=;
	b=lnWYT1/Qvi3w6R1Oo1mbb7/DGFuWNydvIwcfo0tUIkUPd6eRWvzgeViE8VhLQEN0WEBLgE
	YB8yUM8rploN9yX8R/mSC250w22JbW5wBcLt8ykN8v1ZN7VG0M9IKwYggWVRcIIAOzxZZQ
	oY5yxp1GRs5mF7ge4AZ27d7jgt12iu0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779758496; a=rsa-sha256;
	cv=none;
	b=DyTHkFyqQ1OqmvzXF4iEp1movXzEevin/yGbCwtK4gMtn8KBkTvXr1/1ICcyVTAXMSNtVw
	6wqPUZOcA84UghpnQBkXwmDEBzYcPMWeIg1ozXeRQuCuWYe+PTnEK7zJesXinh4nbemLkN
	6/QvxfuudEzUPQ09OLFqE54dKMRKmAk=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=n0aBwEs0;
	spf=pass (imf22.hostedemail.com: domain of jaegeuk@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jaegeuk@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8D1BC6008A;
	Tue, 26 May 2026 01:21:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEC0D1F000E9;
	Tue, 26 May 2026 01:21:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779758495;
	bh=K08IF8WJnEk+HHOzE8UXb7WzEnURtUvmOtiXBoUticQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=n0aBwEs0x5kOqgOGmfUYYQ9pJ4qZYr13caDsJNheuSxzlcgldJfVTK5poT02FgMBr
	 NwwPAddG/4BDkWWsJV7ldW85k/uSYyh+2C3X+q2lF9QrvKVRtxz93mIBkSqArTl53G
	 8Kt+2kJg1gIz3ua5R6yoqVSdQchm5ka34qy2JKKa/YfuxJAHwX4WoeG/MiPeFy8WWR
	 EpMEBen6Oyd4wWZ7R7L5WeMRH2Fxh6Vslu9ypoHIa8LiC+D2g5hButVboP1RRpw0Zm
	 h//Q4aUcFBi4PkmMMfxqvmNluuiVym4t4ZBVAEzv/gFG9DymNyS9IaTN41kRRR7A6L
	 xz/CO9YO/xZKg==
Date: Tue, 26 May 2026 01:21:33 +0000
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Theodore Tso <tytso@mit.edu>, linux-api@vger.kernel.org,
	linux-kernel@vger.kernel.org, Matthew Wilcox <willy@infradead.org>,
	linux-f2fs-devel@lists.sourceforge.net, linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org,
	Akilesh Kailash <akailash@google.com>,
	Christian Brauner <christian@brauner.io>
Subject: Re: [f2fs-dev] [PATCH v2] f2fs: another way to set large folio by
 remembering inode number
Message-ID: <ahT1nT3xsMGkyJab@google.com>
References: <ad30g9xMs9wNJhFb@infradead.org>
 <ad_AVHe7RMnGrGTb@google.com>
 <ad_HwhzlNPUEKQi6@casper.infradead.org>
 <ag7HfNryTmQ-bVIS@infradead.org>
 <20260521155748.GA79343@macsyma-wired.lan>
 <ag9D6_7dttbDGHZ6@casper.infradead.org>
 <ag_UsW_OrlXD9dWX@google.com>
 <ahBSXyOi9b1jxNkX@casper.infradead.org>
 <ahBii6bk0KbK_NHV@google.com>
 <ahPffhaOi2CBtWof@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ahPffhaOi2CBtWof@infradead.org>
X-Rspam-User: 
X-Rspamd-Queue-Id: 10E52C0006
X-Stat-Signature: tmpc41xijacr1m9mo3pybzbwbk4z74t5
X-Rspamd-Server: rspam06
X-HE-Tag: 1779758495-490391
X-HE-Meta: U2FsdGVkX18Il0r9ZsCjqNdlgA6FPT04FsNXOKC3toIRbFzx4Nxo8n1o0jCeE/f7xOrRZZarpNHWEbAOob2S6cc9+2eA3NErpRelUniyRmeaqzmvsoXYoEmPzoOkE8Szp9IW/nwO4j1lRt1+kx8uYSeKrFCCafnRyLBDjpy6Yp8WB0k5+4Gjyg8fgloTNteVkkXwtEcSeFctJFxrjhQDMzYio6xUgdGBYHGNvxeW9VfPGgiR6WAcKgerTA3H0z61rJPsvH+p3X7zq4CnZWcVmIyyeLgHOWVtAtQSEFhGN5tE4iZMxf28XZdMywji8CjtLxlGcL6URshjXPW9ARcx8lJa+ZbigccvIRXkH5BkvVkKYxrEkrLxNEeYE4XtVGVbxUafXtDDn9JVzLv0ozsk7kuiGAib4H95PzVwkSoySC+4oAV7Jb+UD/dCpuIx7NcCTh0OEfVFa7OkUH48Yjkj655Q0MiZ15+ZD9Pdr3PQbN0I/7KuFL3HIfiGEjczpDhDHG3LCsvPOI1AHDT9kZsUozJctIM9WPEvhb43vCHk0MIWqmKI5Ya68jelsCc44iiBBETXCX2TjbvCfciW5oM4W8mcAR+Q9ETmR0DxL3R6GJJ0ruZqQY2P/COIjwa9/G53GohSV/xfxjbSB1CUpClkzN9JnLulMMA1YfLZ7hVcS6gN5alSaBYx2OLDIbb9VCi2INkZhB+KRO7o0Mm7/LlbcZgowILxMLjGqMFv+ushcYQMH4j5t0ruWv9cPzFmj+LNjLcXXGn3kC81OsWQx23s5BKcJGenNyiA7mkKPEKZ1cNHfiy/3MaISulPneqi1VG2X+E7tseOw9hBRDRGf9oJZcBeTPIEiqGG+bIJ1+J7Zh39mK7k6n9YJzVr6sBxpeFyuORb6L2JmCewG3ljDJe/yWg/0bzs+sxKN3zeGciGfeO3+ziM9rHMF/5tzFsD9PHAk5TkLT2y6ppfYwoN5re
 k0e7sUE+
 RJWe4dKnjGgRaiAelNjyYmztkg2C48C95mCuStqj5bmKkW+Du3YvGR76Jj66BlM6HT9NYl7Ogg8v6Ln7cTqxTR/YCXFgUXvr+U0D9NlWKjimzkJvBkYI/lFKy0wogVjAEEzd8gEIsOFFvMgHWp8ldK/nHrGEX/BoCwmfIS0/m6cRez4/lZBFVISV9xAulQSWAQk9qF9UgltwgIYvcGnmjLxhgaBRHYWTT0gZxYLPZ7gZZsb5ComJR+CzzMMQOdI0RcHT7SvsHzdQwoNHLgph3qvXK1JpflasqvWO5/xPQOdy3izgh15R+6hvZQA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 05/24, Christoph Hellwig wrote:
> On Fri, May 22, 2026 at 02:04:59PM +0000, Jaegeuk Kim wrote:
> > This was a quick buddyinfo right after booting the device.
> > 
> > Before:
> > Node 0, zone   Normal  22684  42284  28704  16901   9515   4566   1854    673    181     36    758
> > 
> > After disabling EROFS large folio:
> > Node 0, zone   Normal   8486   4732   2175   1161    697    272     82     19      3      1    856
> 
> And what are you trying to say us with that?

This means, high-order pages were used up by EROFS which sets large folio by
default. So, I wanted to say the concern was based on actual data which was what
Mattew asked.

> 
> 
> 
> _______________________________________________
> Linux-f2fs-devel mailing list
> Linux-f2fs-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel

