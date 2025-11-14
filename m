Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 84B94CDE018
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 13:17:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 72D438E0003; Fri, 14 Nov 2025 08:17:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 705048E0002; Fri, 14 Nov 2025 08:17:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 641DF8E0003; Fri, 14 Nov 2025 08:17:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 533AF8E0002
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 08:17:03 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 02E4412CBFF
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 13:17:02 +0000 (UTC)
X-FDA: 84109263126.15.3FE2252
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf14.hostedemail.com (Postfix) with ESMTP id 4B99310000C
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 13:17:00 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=uhTAacUV;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf14.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763126221; a=rsa-sha256;
	cv=none;
	b=4aqweLhXGcms00Xu44KMCpqmUIfK94adJLgyMXea7JRr5tCPhP/mhnnIuFaBnd0+qX7Hkb
	CVcz9KSNwuaJrXxrDv7o4Zmr/BQc9C9vfnD1LNdaSpR+Qh5fRKBV7hH9oFgomRxgSv0T8C
	JlarbPlqrhBlxj1YmrHmgWbE7Hnw068=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=uhTAacUV;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf14.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763126221;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Vo+N5YbzZDjZeiNvAhfJhGp+deegDT8E/3cOAOwzUvY=;
	b=5RSr3N/JMCp1u2G8hPU+DTtdEMfMoirXpTyRxkeirHsWgA39vpMNXgBUfbJ6glUCbbiaMu
	PIcgg04vUascly4JIrpjXr05YT2QrR4dHi99JbZ5L5Zf2PglP8/QqSVj7Luw4HmNP/gIAF
	Yxb2j16xfMxmWfrvpt1r/MgYRONLqD0=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Vo+N5YbzZDjZeiNvAhfJhGp+deegDT8E/3cOAOwzUvY=; b=uhTAacUV/flhXWxNQV5FeR3HnC
	dbisfExygmslgLyDpvLG+2/Hlg/pmt0VQFR60ENfWSheMwZ71gSfJvn5cpAz3jQ4C8GbW22mGZnvr
	IAvWXV16IcxEqXlj9aGECgc6jWa+TYNslUF/UG5UZnNeVmX9uCBtHkF3/PhZqpKloo53DY7lQjfBs
	aJlrIOpHrSuxqQ5zFLrpzFxS0hDURfOE1mKKnlaxrFAzISnDVMx2YoDYjEeGrpZfA+xmHgA5z4Aqa
	ikMn5lzxyvLtVuWvtU3KSheAYA6RnH67j72rXcCqX5yw2ewTbxE7qcEs/APRhRTTgydkga2huH2E1
	f93tK/uw==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vJtfX-00000009Mru-0lqh;
	Fri, 14 Nov 2025 13:16:51 +0000
Date: Fri, 14 Nov 2025 13:16:50 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Ritesh Harjani <ritesh.list@gmail.com>
Cc: Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	Christian Brauner <brauner@kernel.org>, djwong@kernel.org,
	john.g.garry@oracle.com, tytso@mit.edu, dchinner@redhat.com,
	hch@lst.de, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org, jack@suse.cz, nilay@linux.ibm.com,
	martin.petersen@oracle.com, rostedt@goodmis.org, axboe@kernel.dk,
	linux-block@vger.kernel.org, linux-trace-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 2/8] mm: Add PG_atomic
Message-ID: <aRcrwgxV6cBu2_RH@casper.infradead.org>
References: <cover.1762945505.git.ojaswin@linux.ibm.com>
 <5f0a7c62a3c787f2011ada10abe3826a94f99e17.1762945505.git.ojaswin@linux.ibm.com>
 <aRSuH82gM-8BzPCU@casper.infradead.org>
 <87ecq18azq.ritesh.list@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ecq18azq.ritesh.list@gmail.com>
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 4B99310000C
X-Stat-Signature: ar9tkftznjdiey9a5q9k94ud6szhdbso
X-Rspam-User: 
X-HE-Tag: 1763126220-879089
X-HE-Meta: U2FsdGVkX19MNoS6N+oYBuOFEWlxXR2DWtsGvs9G+4sEZXTiegVXV9qWhEcFBQKShYU7WsO8a3NwZxTfeUdMnYlKql5GqtNwtodfzOsJ6iOAsBpPWDztmD7ba/QYJu9G1zSXF2Be/5YvS+TC157gxHZ5mhWKZh/wstCTHtO1Mw3VtcwetI4AwCT9mBQag8QRBdcoIgsOCIhDjQ2IgLhfmkmeIgPVNE1cR/wQAGHVX5EealCAevHKs15gLxsGBcLzrheEXYJiK0pAZgitYKnWCRR0mETou0lk5kgAsfk/6KrdR6Zxv8DiLLb9iAmwdMqnuN2bC/rpXsJRsqDpOmdMRejDk8BgFw6trrM+Mel4GPifPcr25mAKPFmPuBjBveeeoOEP3KT6VSxeHbhd+0T/i1dPtzDkejWqxF9kAlv08w9E+Lz5fdb8Yf2wbnTzdVtruw15aq+dWkCUhkK3kYbiog4+nRIv6RDTedJq+qmOUHt1tLN37O6As8NmBxwE/2DGuX18qGe9zISaqWXcIg3tkSCu92c7IJl+vp2LiZ6w0upp2g/QrbQhHpgUQm/h3ekZxEdeLML9kLFGfedXcJDubBYOGwA7rujy+0wzPNJ2Tsg5QdspBl4rxwPphIk2zGDwXDiJqHDT4qqM/y3iektQvE0L/DSQJVIsFSRHiHt44jqwMIoBliUJ8Mc2rz5GRFEso5DUSs+XLdvNJYe8Q3vEBTujyB9bxhmOU7beM8KBEV4srDHtsaPawrFXv9AGbl89O9oNVL3dTGItze26fZCNP3JBCh2Rl7iLm+TU3EU3uC3xnv548/TFowP1ATEWbMizmvT4xKAVdUj81bnpr0A0SsDwn5GniVz17nFLGLc6pF4NmQjCfLHaW9XotvfDblAMgUuobUvrkWKwzwt3omdDnGcyGQJxP5C8SdSsRrGJh6y5T6BWWdy3Qz6H9Un6N999s8XZASO7pJL3jWem1Ib
 vz0tv2wx
 x2nspd5HrrcTLZ5Nmzer9qdri8+VoWL/wFNSpBUDubWTdHGVwz1D7VDpp5RKaQFjIPDOJzeqSw4Ho2vsbmpEkcL3ckmnSW/KHiGr5sTZkmk69Qww3HwCoGYv4KCE2HA3ahFbLrcYWuHgK3JSm9nXNt6kmuCXZLxvgct4QkQB+grrB69MuKJAz41CpWiGOX2eXsyWpja6eEKRDMb3N0ZKjE08mpZZlBbmagnu1eSxJdc3N2ZSILHqvhnqHDHzmm/eE33takKxLk2bVmJ5fIty/xHSA3wJFEN0AcX+lAgbNzzmw6xtVGNoMWHggHu1X5zG7C/2fTnJ/TAM3McY19nHXie7Ae0cw9ueUOKCFX3/tGzZgdc6gy5rHFtuP5Z5DoThlQjToznCImMTRU2wpUuVDxrfwDijV28OAAhElON6DHijuDkcQSaeOj0QLPzcs1m/i3Xp97oMtry4uLwY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Nov 14, 2025 at 10:30:09AM +0530, Ritesh Harjani wrote:
> Matthew Wilcox <willy@infradead.org> writes:
> 
> > On Wed, Nov 12, 2025 at 04:36:05PM +0530, Ojaswin Mujoo wrote:
> >> From: John Garry <john.g.garry@oracle.com>
> >> 
> >> Add page flag PG_atomic, meaning that a folio needs to be written back
> >> atomically. This will be used by for handling RWF_ATOMIC buffered IO
> >> in upcoming patches.
> >
> > Page flags are a precious resource.  I'm not thrilled about allocating one
> > to this rather niche usecase.  Wouldn't this be more aptly a flag on the
> > address_space rather than the folio?  ie if we're doing this kind of write
> > to a file, aren't most/all of the writes to the file going to be atomic?
> 
> As of today the atomic writes functionality works on the per-write
> basis (given it's a per-write characteristic). 
> 
> So, we can have two types of dirty folios sitting in the page cache of
> an inode. Ones which were done using atomic buffered I/O flag
> (RWF_ATOMIC) and the other ones which were non-atomic writes. Hence a
> need of a folio flag to distinguish between the two writes.

I know, but is this useful?  AFAIK, the files where Postgres wants to
use this functionality are the log files, and all writes to the log
files will want to use the atomic functionality.  What's the usecase
for "I want to mix atomic and non-atomic buffered writes to this file"?

