Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E1815CCD1AB
	for <linux-mm@archiver.kernel.org>; Wed, 22 Oct 2025 18:38:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4400E8E0002; Wed, 22 Oct 2025 14:38:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3EFF18E0010; Wed, 22 Oct 2025 14:38:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3058C8E0002; Wed, 22 Oct 2025 14:38:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 1A72C8E0010
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 14:38:29 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B15FB1A08D8
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 18:38:28 +0000 (UTC)
X-FDA: 84026610696.11.6469BDA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 4C2F3C0006
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 18:38:27 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=xdxcVq5i;
	dmarc=none;
	spf=pass (imf10.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761158307; a=rsa-sha256;
	cv=none;
	b=M1vFU193FOzIfFHgrKq1/zMly8KPNjDoKb/ILht5T/y2Rgb2/BlJDoNY2GCiRwd2QvpV6q
	qqXCWRwd6eRrF5Lel1yaorf2iOeGCfiA2hzQ0a+t6WdqrNXmvGc7osIYdQAHKmoVrs+BpG
	fEtBRTUEhynik2IjFZzuZqQACwkNQV4=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=xdxcVq5i;
	dmarc=none;
	spf=pass (imf10.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761158307;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KD8NfF+EBusv5OZy9MH4ENQVGQk8W3mam3rfe9vKT1M=;
	b=t+4FXZu9SOLdCE+DS611Ib/8nwFwIvWgTTEQmilzGStaAmI1TBqHf0uN/1oNTwkbkGQnGh
	r42FmQgG/mEAAKN5R5t20+hRwuxAqZN5jH+wtWqp3RVkE4E2t4mhj4amxI3WR00IvCkkWc
	FdrgY4vdxeSeIBqT6Ohx/oOU+d3IzjE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 94B5863DB4;
	Wed, 22 Oct 2025 18:38:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD5A1C4CEE7;
	Wed, 22 Oct 2025 18:38:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1761158306;
	bh=RqQlQORqCXLRUiL3vVHJ9CCKwIACu95r35ar8HrBFHk=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=xdxcVq5ibAI/IsUG0H8rVpGBwxOnQMNU7VqKSG7xATvkS/+qPe3WUCQBIASqQ0H0T
	 w/9dnj+Iidsy4zJM9DUPzjdnpM+mqQ4BLeH0R3gkfB4+Kv6DvvWJmiWOvYGneKiyq3
	 JG5YgmHEHV4rOSDrvoIt293Mfutg55DryndAMF3E=
Date: Wed, 22 Oct 2025 11:38:25 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, Carlos
 Maiolino <cem@kernel.org>, willy@infradead.org, dlemoal@kernel.org,
 hans.holmberg@wdc.com, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
 linux-xfs@vger.kernel.org
Subject: Re: allow file systems to increase the minimum writeback chunk size
 v2
Message-Id: <20251022113825.f9d0a2f3143929f9e1f2967d@linux-foundation.org>
In-Reply-To: <20251022053434.GA3729@lst.de>
References: <20251017034611.651385-1-hch@lst.de>
	<20251022053434.GA3729@lst.de>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: rszakxmd3gmmsb5prrtbzbnhkztkqydx
X-Rspamd-Queue-Id: 4C2F3C0006
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1761158307-674044
X-HE-Meta: U2FsdGVkX19RrEXr5su5ySthPpLdCwJYkwQ/o9VFPlgwuZsGUa9O66YO+e+bmrRrWtL8BwMiGN4FmkItzFAp16CAoueEx7QU79m9r0YPUyt7sXDzJx4Igwdro/CVadwbDqmerGY81nk+ygL633mc9kLIh/cFdnCTmXeahPNmyRskm7zHxDJVJh1NGDpd0NNDSI89LcnxdA0z0DPf3ylp3Vq/hK9b1gjlbLi+JrafJ2wIPRrIz73tD3O1u0Oyt//P5sTRO4b9TtKS8QVGRxzE4hKLq65Kjom0Ohx9v7gtvPY5bSobNdC6eqbNIffThGlEhQYnBRmjcyFY824usCVExAzNK92EsLqdgwGRGg38AvnDdKugDOJnxB0yn7hFY+YI1s7uwXtI7EI7PeNhYOjLalaklZkAUiFzm1o+KP0NSwWIViVZzB2dtwc9H2Z3LE/O+01w35ml2Jmj4sBkJ3JxubxWFgSb4w+m19kP4RV/QPH9FxhPhcsj3zVoL6yUOmb4LC6qCvmE8nMEv5QZltgx/uSl+382+NEAbZUQwKyS3ZQFwCxfX/ROzSHaRbz71WvW11xm23GjmfL0ZuJHiIzyaPRF/+EmyFm1QUtMS6XmQ1lcHlOoQLbnF5X6FMr3rxSIkiyzvQiRoymnM0uIUa92+rXh93UbKi1VwEwwH0Rp9Mu2+I3VXRsfmQh+pvq4LUgt7IlTV4OIS1DnCbaVmaN9zjdRE+7ynu8sKTtAHuLlJIdfcGiD/3h8rGfWzAm3Gmk8RpOzPvidFyIAliR/SdnuK+yaURFBuo4RoVjUJCep62s+O2+ngo8ffYRl0JEOffR6shUXkWcwkiCRkqxIiaIJ8+7K7NaX0EfQfXt7gKJpRmWm/SQJK1imBcR9y8S4UEUGKdhfc1hotiFA2WAEyz8j3EQPmW0PXwfD5961r31ntXo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 22 Oct 2025 07:34:34 +0200 Christoph Hellwig <hch@lst.de> wrote:

> Looks like everything is reviewed now, can we get this queued up
> as it fixes nasty fragmentation for zoned XFS?
> 
> It seems like the most recent writeback updates went through the VFS
> tree, although -mm has been quite common as well.

mpage, writeback, readahead, filemap, buffer.c  etc have traditionally
been MM tree things (heck, I basically wrote them all a mere 20 years
ago).

They're transitioning to being fs things nowadays, and that makes sense
- filesystems are the clients for this code.

But please do keep cc'ing linux-mm and myself on this work.

> >  fs/fs-writeback.c         |   26 +++++++++-----------------
> >  fs/super.c                |    1 +
> >  fs/xfs/xfs_zone_alloc.c   |   28 ++++++++++++++++++++++++++--
> >  include/linux/fs.h        |    1 +
> >  include/linux/writeback.h |    5 +++++

VFS tree, please.

