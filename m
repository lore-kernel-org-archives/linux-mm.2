Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 43CC7F433D4
	for <linux-mm@archiver.kernel.org>; Thu, 16 Apr 2026 01:19:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 85DAD6B0005; Wed, 15 Apr 2026 21:19:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7E7D36B0088; Wed, 15 Apr 2026 21:19:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6AE896B008A; Wed, 15 Apr 2026 21:19:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 549E36B0005
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 21:19:12 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E56968C281
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 01:19:11 +0000 (UTC)
X-FDA: 84662660502.05.314BC49
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 5B37340007
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 01:19:10 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=h4B7BqzB;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of jaegeuk@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jaegeuk@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776302350; a=rsa-sha256;
	cv=none;
	b=WgCTUkfWTgXwCLDrcuFsqMOpjVM1iPzB0De9FNrPViD5fQ0Hrd4D8iLbv0vpNz/+gHNR/M
	zunsXlZubfhbTbl/3ZH9L9cqUnjVQ+iWEVvRz+3Lp3zOHTw6sQkzf50SoKj11bDg/U0MAr
	JuJzEA3AvmCLe9WoYADZu2QwjKHhVkk=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=h4B7BqzB;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of jaegeuk@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jaegeuk@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776302350;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=17TjlCZCIXEN+7lApT284XqATffQCeo9XWg2qxpzwI0=;
	b=BXYSnk4BmOLNCKaUpq7ITTr8L+UZ+JS4cX67ILxqqIbhmTa3QMvpta26ZZKcd4KapxIX3+
	+NcKa212xONTZKIV2RlStS0PIedlW6aNvbrj+pMU5mBoNSz0afKPv0xe9T1taU0wDWhHtD
	0Ik57ijQEVpKZEXLo+ovT+8z/UZ9l3U=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 7E78960123;
	Thu, 16 Apr 2026 01:19:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2CC3C19424;
	Thu, 16 Apr 2026 01:19:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776302349;
	bh=sGPVhh1PMoxtSRZpRrI3iao9xw5DxpR7NnDEs0o9Kgw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=h4B7BqzBdmwkiQP3eic2DNPc5SfwzxkiQTs6gPXXav+LObOeFH7nkioxT7SaepznJ
	 tKeHtP/Q/R1rN+IYoojyUMD/9KImNkUeDlEZ5WlslsOlCvQ2KqZlW3coZcdxlw3RNz
	 3mCV7tjMjQ2OqsxWlPvw1ydH4/JIGVkdDmVKz1KpUuDTB5O8MyYUvD27sG0B+C9qgU
	 8jolvhM0TULMdqnl/LgRNrTYwCl5WgyWumi8qCF1q67v2K/cuqrhQNUhqaIazzxjtC
	 Apa5NTA7awDPIth5oapqjqZwGGydEyX8hC8yE+ut1WrXAhm2X/Ni0qm5cQBQ819JSR
	 jrW0S6CU0yzgQ==
Date: Thu, 16 Apr 2026 01:19:07 +0000
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Matthew Wilcox <willy@infradead.org>,
	Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net,
	Akilesh Kailash <akailash@google.com>,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linux-api@vger.kernel.org
Subject: Re: [PATCH v2] f2fs: another way to set large folio by remembering
 inode number
Message-ID: <aeA5C8byIpXWla7f@google.com>
References: <20260409134538.3692605-1-jaegeuk@kernel.org>
 <adhPZxtbZxgU-37v@google.com>
 <ad30g9xMs9wNJhFb@infradead.org>
 <ad_AVHe7RMnGrGTb@google.com>
 <ad_HwhzlNPUEKQi6@casper.infradead.org>
 <aeAK8mFxzgMOepmZ@google.com>
 <20260415234950.GC114184@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260415234950.GC114184@frogsfrogsfrogs>
X-Rspamd-Queue-Id: 5B37340007
X-Rspamd-Server: rspam12
X-Stat-Signature: on4mwqj1e9ffrxb8y7ti9taoqwz6hgxt
X-Rspam-User: 
X-HE-Tag: 1776302350-303030
X-HE-Meta: U2FsdGVkX18aIPAw9+860v99eLHJMMwT45m8xRmPVFAgxD3JRKdT3PMgejS/F/Nja4483pLu3IxbIisKhbBmQ3ac8YCOWYwBUWpwyA51ZkzZojsYdGzlOmWRyUaQzMkeiSpuO4Tq/V7+Ghxj3GaAYC+KlnZvlGEbhmIQ90DHeEplqQtnCpvQoeKHz6d7sLDgvpg1qVZAlVz8NLI3LFkTFu3fhKNMKeWcy3GO+lWCqVSQ//myGaYz30DWPKeZ5AYHl+kay0psfisruHclE2WVjj2atinnH1jZzEeXdmHxWiqAGHbLU2xntTZspxRbZ6P4dhIyqv4Kqdg7r4si89PIhCu5D8JXjeEkWmxPzl2XbF5HybiRSrtNKldtuNsxJh1Qh2QpXrr9aIs1moJHZr5/KhrMjNcAWLFTLlWYynfyay82tiQK0knTvLVlyKvOEC65nC/SjN6wP1hXySO1c/Jag1FWhmuHp7IkcbqWNCRkR0GIlJkOnhS21zBqlHfuetHYg7qhf4QWXifp3D7zTXHVufwl2jEJ3dOzlc8lZOA6HiKkmChcFQ7aad6CpphT6MyeZGfbpiNppDTjxN7m3qMT8ibAxQgobYZzNQvKM6JxmAKGB+82stopg2k6GAVtgLb4OAu4Ee7ZaW49HAam4mr+gNKM7OQMOCZu+b1iTCm3hIBsFjbYfh8yA7kwy/F5NvwrgiXXm87G2Tixzn5/kkvOJTjFR1jwbLdN1ItqFfsBmhiss0qWn2Xy7CngHtaftohQbM0wENl6w/e7pu+SreUVUHSyWTaQHHJ5rjB01HcBoyTB1eVHQj20jcs+wGDT3Wrf0eMJ5vrou58RsSefDPNzgPIeP60PtU3JczJMKeNvtpPOYGzL31KJIp+msprTP2nXqpvd9NtdQRAB2+vdT/bHZHyzLbf0Lq1xbP/mRDyNnFtghquwDeYCck5OnlKGGC4AyMnXZ7i5vFGnS873fH8
 RAuQY0zx
 BX67gJGOR214cNYY1nBimQeUpqxLyUqnXoJU6REtj2xoNjS+yggBstqvycAgyZOs90SQdnSNU8L3LGMOrySWKySL3Nn6ciASJpGujd7JvJ7UYWNA6kD+1gcTd4S28ZeSEHdAhRVCW+xyT5KDeQ8yByzcDb7Qsuuv5sGE7O0YLociJTphnCoKwjY0A9vX8be5k0jSce0nJiM7TAw/DAEapwH7fx6YtfwLGQDOGLaDySJKUb0KjotEJFI09Z8dLS8TEGBkJ7O3+GB0skj9a59vz8iILQdDhS4l3ZGvC
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 04/15, Darrick J. Wong wrote:
> On Wed, Apr 15, 2026 at 10:02:26PM +0000, Jaegeuk Kim wrote:
> > On 04/15, Matthew Wilcox wrote:
> > > On Wed, Apr 15, 2026 at 04:44:04PM +0000, Jaegeuk Kim wrote:
> > > > On 04/14, Christoph Hellwig wrote:
> > > > > Please add the relevant mailing lists when adding new user interfaces.
> > > > > 
> > > > > And I'm not sure hacks working around the proper large folio
> > > > > implementation are something that should be merged upstream.
> > > > 
> > > > Cc'ed linux-api and linux-fsdevel onto the patch thread with a proposal that
> > > > I'm not sure it's acceptable or not. 
> > > 
> > > You haven't sent a proposal.  This is a reply to a reply to a reply of a
> > > patch.  There's no justification for why f2fs is so special that it
> > > needs this.  What the hell is going on?  You know this is not the way to
> > > get code merged into Linux.
> > 
> > I added two ideas in that email. Have you even tried to understand?
> 
> You want to establish "user.fadvise" as an extended attribute containing
> a bitmask.  The sole bit defined in that attribute means "use large
> folios", but you also have to change the file mode and set the IMMUTABLE
> bit for it to actually do anything.

Partly yes. This path has nothing to do with IMMUTABLE bit, since I used to
activate the large folio with that bit, but hit a big pain which requires
clearing the bit whenever just deleting the file.

So, this gives a new way to activate the large folio by chmod(0400) and
setxattr("user.fadvise") only while providing quick inode eviction in order
to set mapping by iget, and allowing file deletion easily.

I feel the arguable points would be 1) the path to evict inode by calling
d_drop in release_file and returning 1 in drop_inode, 2) how to give the
hint between fadvise(FADV_LARGE_FOLIO) or setxattr(user.fadvise) by individual
file system.

> 
> Meanwhile, you can't actually persist any of the fadvise(2) advice
> flags, so the xattr name doesn't even make sense.  Maybe you meant to
> call it "user.madvise" since the closest thing I can think of is
> MADV_HUGEPAGE?
> 
> I've understood enough.  YUCK.

Thank you for taking the time to take a look.

> 
> --D

