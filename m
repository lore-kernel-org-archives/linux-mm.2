Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2D776CFD318
	for <linux-mm@archiver.kernel.org>; Mon, 24 Nov 2025 06:17:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6BBD86B0011; Mon, 24 Nov 2025 01:17:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 66CE46B002C; Mon, 24 Nov 2025 01:17:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5828C6B002D; Mon, 24 Nov 2025 01:17:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 415BF6B0011
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 01:17:25 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1A6D7B756B
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 06:17:25 +0000 (UTC)
X-FDA: 84144493650.17.45A395D
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by imf15.hostedemail.com (Postfix) with ESMTP id 57E0CA0006
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 06:17:23 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lst.de;
	spf=pass (imf15.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763965043; a=rsa-sha256;
	cv=none;
	b=dEC9VVj9YMh/hZknvCuFtpAF4Yooju6iYNn58hLufPzXMjOmV8QTrCECp+967LB73Vaj6Y
	+pnlR39nQCJR8S3v5ZURIeUX79KpEesJWWC/rPf8Hq31D+1ZX19sApw7/LmDp0T6Q/PnqT
	Uu+UjMnH19DqxAN+R8BxGr7IUXOKK1U=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lst.de;
	spf=pass (imf15.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763965043;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=V7n1/6nm7ycrN2Qpvyy+IlEk5aqZlHeKTGHxnZjfBkM=;
	b=ifuKy28NKqPNWjWzvaFzeYmnD9TwGCzA01lS7hjD3sDixM/qjOus2euXXRp/deNPMgu1uI
	HMModg8an9s/3JtBZ12kNrS149aBV1DkPJpF1MTRDLUisdmUZFqN+/iZlCLnjnflaTZV3b
	7hAkN4IOEgHc9bR8lBs2LA6VBEY8QxE=
Received: by verein.lst.de (Postfix, from userid 2407)
	id E8D6968BFE; Mon, 24 Nov 2025 07:17:17 +0100 (CET)
Date: Mon, 24 Nov 2025 07:17:17 +0100
From: Christoph Hellwig <hch@lst.de>
To: Hugh Dickins <hughd@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>, Christoph Hellwig <hch@lst.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>, Zi Yan <ziy@nvidia.com>,
	Eric Biggers <ebiggers@kernel.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 06/11] mempool: factor out a mempool_alloc_from_pool
 helper
Message-ID: <20251124061717.GC16260@lst.de>
References: <20251113084022.1255121-1-hch@lst.de> <20251113084022.1255121-7-hch@lst.de> <a8a2c740-2208-5692-cfc6-f475ae0f7d45@google.com> <7b1265bc-835e-4c7d-af75-f237c46bc3a7@suse.cz> <566ce586-4d53-f2d8-50b6-1f884f44d2c9@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <566ce586-4d53-f2d8-50b6-1f884f44d2c9@google.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Rspamd-Queue-Id: 57E0CA0006
X-Rspamd-Server: rspam07
X-Stat-Signature: nsajkrth3p94inj71dc83kkbx36tj4og
X-Rspam-User: 
X-HE-Tag: 1763965043-5541
X-HE-Meta: U2FsdGVkX1/I7V+S+jA3LXzfTAHGmcAAauvrMsjvbQXuWH7w/SUPwvROQCmHLlh5hE1FZ8uIu5Qtiyf+ZdvoBVYpNEIsxfMHS5SqZls/mTWnPwow4s+GXRPGIUGdokE3aFNcQbWS/9bZJNarrn/7i8x8r2FUpTuVrIfLCJ4Unn1+kOry+WffCnMI35EKXu9XYPERSZI3X9LiDOHU8g4hzo2YC4rtZ2Sio1FB2wxDODtVeqxSiutgahGDkGMsvBSTaztYSPOg8w6RXslq5rpEGVU5s7v5R5qxqxMNmUl+7z8UxV4jaRIQ5HjeplxebluUeVDl8QFCwTFl+rmU1L4JR5ivtVsuIU4QAcRU24gaf81cunPItHCMNSCzu7dEeL3tkaNXbv2ZaOWZgnoECfnrZD9QlTKYLmCeokmYOYEZtgmhKsgku+BD1B6VXur0hV/i6MaXeF/7X83o7xm7qJEhleKwYoYvC9yFmbYkDztOmCjgTbXYRy2oV87xywGv5LTV01bY1Bn0HOf6B1fwAHrlirxiJhHlCuNJb9dc9Iee53LkiANADRGsn89ZsT/btCaHw4SXX6nfblpY8LSnOxENo8g7jJGF0hDjH7YoH6ZQfJ8zHjnnKSXZmDrH5c9wLeX/4pa8xLziuv+GlobG65FOppASbqnldNBxXE+hFpHPr+3sHE9I1aMvb9o9dxOWBjW/nvNUkM3dWHtjetKG461oYHqUoWzD64uo5js9wWoluzboK1S23HRCpRwA6t8sUb0Lzdz7FrNT+u6pisMG9TrtBejFgeQSAK7S/0n4ULB0ns0La3xM0zPFvZ4CRYOEN68q1L5VCzPVbBZU9+IUqXqMob26Af+HyQqGfbozdySuIiEf1FWWgiFggCd+W/9It0f4FFosd1KnlUm4FIpXltCvswWPElC7eHN/Wp2L6IdWVpQFSkA8liJ+yvE9Sb/WCBdBlobNHv+AdjGagl9FMN2
 mLlmCCZF
 W+IfWAse+C00VrSbMmD/71pxKGztIghZNqy6Wf3EH8T9e33rp+rnhDfXhedSSqYSSmiBu/gPm1sqsjU8jbYBYpLRPGkjvYrDvIrwtl6RUrDHIRbGQD4o9U3VQL8Lg8gA9CKhrZ5Vzr1pxGRY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Nov 23, 2025 at 09:49:08AM -0800, Hugh Dickins wrote:
> I agree it's confusing, and calls into question whether that was a good
> refactoring.

What part is confusing?

> (I also wondered if it's right to pool->alloc before alloc from mempool
> after the wait was for a mempool element to be freed: but that's how it
> was before, and I expect it's been proved in the past that a strict
> pool->alloc before alloc from mempool is the best strategy.)

In general given how good the allocator is at satisfying small request
you might get something from the general pool quicker than the
reserved lists, especially if the io_schedule timeout hits.


