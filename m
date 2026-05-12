Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D89DCCD4F26
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 07:20:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4A67D6B008C; Tue, 12 May 2026 03:20:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 47E726B0092; Tue, 12 May 2026 03:20:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3BB6E6B0093; Tue, 12 May 2026 03:20:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2C10D6B008C
	for <linux-mm@kvack.org>; Tue, 12 May 2026 03:20:30 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id DCD221203D2
	for <linux-mm@kvack.org>; Tue, 12 May 2026 07:20:29 +0000 (UTC)
X-FDA: 84757919778.05.4490A48
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by imf09.hostedemail.com (Postfix) with ESMTP id DF4F2140005
	for <linux-mm@kvack.org>; Tue, 12 May 2026 07:20:27 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lst.de;
	spf=pass (imf09.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778570428;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pMTiTFWiENQamzxHXmbPJRlT0qzqpOu+k05ZoAu8TSw=;
	b=E2lkBuTUt8/Dv32fOkg96oSd3LH4sjO7KmpSeSUi6E8Ng+gLwC0i/1AvafsZTVdJN5rvNv
	+wfok1DATN39ZiKkggk0KUoZLCc1+9h7zkXtioGs5IyfxB1zrKtIDYwPYu1OkdZzBBAdZc
	DWN9mu3lpl599yWM/d8yT8FslA4CE20=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778570428; a=rsa-sha256;
	cv=none;
	b=l76DMfyLAX3VjIVevpshIxbnMirbjuMmZp/KxNtT1k2ys8DTThjQbmrJnBFZIclvCM0MRJ
	v+xP0JOBgAhxnJ957m//7qokVBYixB5XE6yumNZtTYwYAKJgpv8qTYvJoxxfhJzV9qV77l
	zD+vZEOiK5bio2nf+NrR8uweoB2O+Lw=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lst.de;
	spf=pass (imf09.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id EB1E668B05; Tue, 12 May 2026 09:20:22 +0200 (CEST)
Date: Tue, 12 May 2026 09:20:22 +0200
From: Christoph Hellwig <hch@lst.de>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
	Christian Brauner <brauner@kernel.org>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Jens Axboe <axboe@kernel.dk>, David Sterba <dsterba@suse.com>,
	Theodore Ts'o <tytso@mit.edu>, Jaegeuk Kim <jaegeuk@kernel.org>,
	Chao Yu <chao@kernel.org>, Trond Myklebust <trondmy@kernel.org>,
	Anna Schumaker <anna@kernel.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Hyunchul Lee <hyc.lee@gmail.com>, Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Carlos Maiolino <cem@kernel.org>,
	Naohiro Aota <naohiro.aota@wdc.com>, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-mm@kvack.org, linux-block@vger.kernel.org,
	linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net, linux-nfs@vger.kernel.org,
	linux-cifs@vger.kernel.org
Subject: Re: [PATCH 01/12] swap: remove the maxpages variable in sys_swapon
Message-ID: <20260512072022.GA32622@lst.de>
References: <20260512053625.2950900-1-hch@lst.de> <20260512053625.2950900-2-hch@lst.de> <03dddf72-8755-4ebf-ba79-456377f0f25d@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <03dddf72-8755-4ebf-ba79-456377f0f25d@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: DF4F2140005
X-Stat-Signature: 6q38tde8g3cfqn89a9jekp6o1ss5wme1
X-Rspam-User: 
X-HE-Tag: 1778570427-564375
X-HE-Meta: U2FsdGVkX1/gDEiXlcTiKRmHOvSq4krYNIEzrHYkAhYywhdfqoHhZjfaI0vEOtgcJRo+e1go9DcI56p4DYeVEfRtHtzXjQoP6lEs48Fz1U4IOg8j6kaPUvsz4eoMCiXVw1k64OeZ7S3DubJQuEPqjVSrPBI4JlDy++B9qyxy2qSekVcMLLMCnw1YwvrkvVzPkkge3sDHDyEk4PnpKGdYvWyLZY2jkhdnH0HKdiblx4aMCIrgYf/GwP26nbdAurwcVdBtY52rjkjMr0ZFZkLZbBJ902oZ0Vzrm40gAX4/NGsjQuPtVRFhcAjBuilx+PzWMOgNE6YF407ScY8EUA6IzMopnO9EiwqP5Ox5Z2RgXcwNRj/8qMbyn/wpEZbbpr18ArTWK8/asP9PxuveZ1U7UXcHmrD6ug2qKmM0bpyzeRRo6RNYu65FEXRTSXMhhAb58eCxVJ3RcLYTTuNLj3chUxQ26FX3c/2pAD/iOpVrexcqLVsNhdRBv8qCHPQ0CII/iRDJh7kOR6VBhDsUiEj7crt298ZDINcs/tVbuDaDUT4yVGOVkWXF67IuZUK/YjbkvJwvEpG3CcsE0giA4Ulacq7T4Odd1LAdgP0KhsR3XillpyQ+NrnOjh3IKSoFjXRecYgqFvOfVwq9fq854GVuyj42Q5b/oqMAn9NlT8oQmA95zL5tTkjiD8aUV5wMgLoGWOhWCkoJ/wDws67P3AhmIqPWpOebS/EOeXqURNmezgicFM6EPjpL2yMfQBqfOyJuiy7QzB6FHho+fP5J205q1bGS0QdQ6+ocMFPawhabM+0SjU8fvY0mGKjLgkkrcNNE055KVMQBipxuiEo7ycabXbez4SKtKuIDGm7jrxlVyT/Sg9SYnjJKOLeQgmhYZj/by9LtMwJ2UCb0DT7MC6i+7ljKbbseYbWtqLHiTFnWCOD0NhbN2PBCCP6sDuaktMdTFW4rpnh86qCRrgXQHDV
 +N+Wsr4H
 UUr7KV8tI/5suLAFJEXRVujPZBwcMGu+2BjDrgJ1QWE/BkomYYOXI+st82jSM0u/gcWd6lYQl7KHQCBIDGryrLMFjWoMDE1q5ecI+ip0fyD/ymK9cNAdum4pYpek2TpoXOfgIEBIFHX2k744s4bpc3SapkKwfUpDRNx67YcUNZJq/hWxWKqR4E7RXcM2rh1La1ZFvq4Q0TbkWsOpKnmFOl1qR8Mb5gpa3mTX0GOh5hV/8cFQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, May 12, 2026 at 04:08:35PM +0900, Damien Le Moal wrote:
> On 5/12/26 14:35, Christoph Hellwig wrote:
> > Always use si->max which is updated setup_swap_extents instead of copying
> > into and out of maxpages.
> 
> Checking mm/swapfile.c, I see s->max being set only in swapon(). Is this a typo
> or am I misunderstanding this sentence ?

It is updated by the file system methods or the generic implementation
called by setup_swap_extents currently.  So the above is a bit imprecise.

The next patch then removes this confusing update.


