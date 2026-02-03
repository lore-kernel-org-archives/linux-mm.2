Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4D379E87834
	for <linux-mm@archiver.kernel.org>; Tue,  3 Feb 2026 14:13:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5FA216B0089; Tue,  3 Feb 2026 09:13:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5A84C6B0096; Tue,  3 Feb 2026 09:13:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4AA4B6B0098; Tue,  3 Feb 2026 09:13:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3C4526B0089
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 09:13:18 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C1ED4B9B19
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 14:13:17 +0000 (UTC)
X-FDA: 84403337634.17.31D704F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 2F92C4000D
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 14:13:16 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GYRf9eFw;
	spf=pass (imf12.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770127996;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oXp4jrSH2XwDiO7w2shTKB1ArJVhQLnBW4ReeCuXryw=;
	b=KC/uzVNz3kXJ79ZmVojcHY4/xMvTRKrJBWgNUIqYi+8DhrEHQVxWZQbsANDT+NAeWJtN1x
	ZUGMeQPz9v722O/DFDbvnbFAHW8pSZHNG2FCyYT9gz1wu64IC6JFgnxvyhMyopyJ7OIVN/
	6OIgxPA4pYogEbUH9MC6l20m38Sj2MY=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GYRf9eFw;
	spf=pass (imf12.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770127996; a=rsa-sha256;
	cv=none;
	b=iUX9VDWBV3J3RiQP9tqcWeerszNq84BmT42avGCvv4ch1iLKdkQe5/E9kZbLAaY7RBVlEq
	NEtDo1zPxVBQ5AkXlKWwmmc0b0bpvLbCJley1XB0C/NqVF66647BzvM/iPnF5O4Ni/QWE/
	6PZQipNDeEczskg8ZUIGHhzD5tr1QLY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 49F8660132;
	Tue,  3 Feb 2026 14:13:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F802C116D0;
	Tue,  3 Feb 2026 14:13:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770127995;
	bh=ud6/qDTvHEv3JHnnq3Ok9bapKUCIHzeDxsblGDgexJM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=GYRf9eFwtLq8EBYcO6i1U7KkKaGBeE95DuVUY3g/j0bZkkLmB2U4Z34BKihIk/VHC
	 YRgPU7UoWxFTyl61mLAi5gfkVq0HOory4CuKYteEQFmN1XUlcG63nJWgXB/AEz19vK
	 fGUmCVAJwUebhWEq7EX6QoZE610YiQ4CNP0/8pwxCEwjjCf4WhvJUFOnf8RE0b/pEu
	 Jl66aOM49PVBQBnJIqSRtDbyFbczCvG5AvTM7iI1OzDbeYsNkUON+UlTm2fO+lHw0f
	 5G9tqtICTb6V9+2eqqF8NfbRCYNLnddApOybvh2TkP9zw+mXTrERoLdPzamAj1p6e4
	 unT6t6w/hNLAg==
Date: Tue, 3 Feb 2026 15:13:09 +0100
From: Christian Brauner <brauner@kernel.org>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Mateusz Guzik <mjguzik@gmail.com>, jack@suse.cz, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, hughd@google.com, 
	linux-ext4@vger.kernel.org, tytso@mit.edu, linux-mm@kvack.org
Subject: Re: [PATCH v3 0/3] symlink length caching
Message-ID: <20260203-reibt-bestnote-7da2affa6e26@brauner>
References: <20241120112037.822078-1-mjguzik@gmail.com>
 <20241121-blatt-akkubetrieben-ad5d655d184a@brauner>
 <20260203042052.GE3183987@ZenIV>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260203042052.GE3183987@ZenIV>
X-Stat-Signature: uka3uxycdsjmnnxowf7rrubigrqu5be1
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 2F92C4000D
X-HE-Tag: 1770127996-977725
X-HE-Meta: U2FsdGVkX1/GiupWVnGnlzWS+p+FFZNXeuHY6CkD4xP+p6IzpmIS8wmwfos/ayZ2YetPxmIvy7l2WcQuBHrjnKDvHpPMEP6gxAhiiGM49KuSPKQoeTuhEHYRWRC/mxcDqRxNslExVrnV8d9W0ipwYN21YJMnzYhggr4j99l2Rp8/HnaamFkrG8O2p2wol29DlaYtghAtCRI7HpBI+SGtjvBtthcvziCVrmc5TGmOZBIu78zO7s5B/O7XDawQ0eDqERg2GyJ8Xg1GQ2D8rUiloBYuvAZlZA54zY7QH9rxYtlgmoM4ZopwZfgVKMbxqQE7KrmhBd/p8mgeECsHykuvwHJ4LaEwi4pGecVfmOZx2gt/t/LYZuhEsn4SwPwe0E3BqAOY9FHD1efECW9uoyuf5z4g82kzLb0yrX5vwSK0Lcq48gcV3h48J3TlcgCN10zS78eOaDrHjYLTTWjBxYdLfldAMBX526SrXMCUY2G9oO8tp3Csw7uO/vD/nviipRD2CsTt6c1IWqXaYg+5+gF4Jb5rjPdSs9GnXQ99Orq+CHDBcskUQvTkK5YZdRfqLrVHjdu1kqSQsvf+ZhTvkITj057LmrwANBPVAZ3hYnmXjUwASJ81fj5X6Mmx91zOaTnJQ3jrDnwcrmGuNAITkfkfGWbllHBMLJrr8REvPHr1bfoVjc+ydpc8wlHEJAhY2scOp7jWYRqp/SqgRkf3nw4A+fnX+RzvjdmI1FA7sOIJd2QXU/XHuqljICON6+uQmJqy7qdvfilQX5QepV64hpFFE+s1rSuvbYO59Hz+zFKHnBd9sWR5t8pTDo3yh7VQlDJ0A3VN8kF1cT7m5gDyy/3VZ7IMOj4xFeg/aW7Ac7tWNJqNKjgdQogmNlxOLjE/QgIWe/8jy1/3wQnnIYycYzTUCZzTheRyJpXM95UWCboNYI2mIJW7q79XfwhoF0h3rWNQuMLMCk5d4kbVp6nJG/d
 zqP+kCNJ
 BRFQD5IqQka+8V0o1MAWSzOaRaWABJUS3DL/w5njL2pj1aUe4edlyCw4tmgF19/Fb4v8cuLKIPW6kdzphRlYl8WuDgmVsF5sAbKh1Ry+U++n9euP8cLa8GGtfJmAjkXVdxyOBCKNz29glF63CnRHH52UXxRm+kSY59hDFXbKOWG26VNE/MwzCpzmX1JP2k04r8w+ZEIhTkMHVmxCWZVL34xPq9FW5Qveh6sQ9CL1TWXoTkWV32aU9qegJLxiHgmPpQFSKTZSyz1VDSt7u7QShU7oSYOMRz6nZ7Yr1/YOJ3ZDqsJZ9MlYtr5DE9qZfVf/XrdYt
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Feb 03, 2026 at 04:20:52AM +0000, Al Viro wrote:
> On Thu, Nov 21, 2024 at 01:34:44PM +0100, Christian Brauner wrote:
> 
> > [1/3] vfs: support caching symlink lengths in inodes
> >       https://git.kernel.org/vfs/vfs/c/5cbb3c7e0051
> > [2/3] ext4: use inode_set_cached_link()
> >       https://git.kernel.org/vfs/vfs/c/740456f67017
> > [3/3] tmpfs: use inode_set_cached_link()
> >       https://git.kernel.org/vfs/vfs/c/30071e02c163
> 
> _Very_ belated note: that needs D/f/porting.rst chunk that would cover
> readlink_copy() calling conventions change.

No probs. I'll put something in there in a second.

