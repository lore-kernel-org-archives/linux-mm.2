Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A54E0C44529
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 04:54:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 197E16B007B; Tue, 21 Jul 2026 00:54:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 149116B008A; Tue, 21 Jul 2026 00:54:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F2C326B008C; Tue, 21 Jul 2026 00:54:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id CE6646B007B
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 00:54:23 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 36A3FC0387
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 04:54:23 +0000 (UTC)
X-FDA: 85011567606.03.05030E6
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by imf27.hostedemail.com (Postfix) with ESMTP id 9C87D4000A
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 04:54:21 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=none;
	spf=pass (imf27.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de;
	dmarc=pass (policy=none) header.from=lst.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784609661;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6tCUP2CV1NsegVnGlvyQV2Qutt929FX3i+gefAFRQ4U=;
	b=2mnDg4mtAbfgNh3qx8Mwx24XEH+rdCj0K0mOHg4L8IFOasQAK0Ow1W+HELTv1iyJbX42cg
	qAwVa3M+NZnQuJHEx1xL0/CF4K14PeuSZQ97nI/vd3YN9494eyaW4sO5yzB/jHWYwFrySo
	vQfbZqovAn7jEJjyJKIWpji3n8tpfNM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784609661;
	b=W57g/25FMi2JGFr/dz9chra4I5jiibiZ7J1X4W05QtefewMvxfp7Cki/AX2abblXBWWvLq
	7FyS7RhTtl5e8IlSch1AvP4WoE7aHZ71jhfNqwse6ocgPCzWPjjqhUhRETVmk2fyaWaklL
	pDEEM0KOPgjmaGoCbwTtG6E7xuCajCg=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=none;
	spf=pass (imf27.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de;
	dmarc=pass (policy=none) header.from=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id F3EED68C4E; Tue, 21 Jul 2026 06:54:16 +0200 (CEST)
Date: Tue, 21 Jul 2026 06:54:16 +0200
From: Christoph Hellwig <hch@lst.de>
To: Matthew Brost <matthew.brost@intel.com>
Cc: Christoph Hellwig <hch@lst.de>, Mark Brown <broonie@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Next Mailing List <linux-next@vger.kernel.org>,
	Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>, linux-mm@kvack.org
Subject: Re: linux-next: manual merge of the mm-unstable tree with the
 drm-misc-fixes tree
Message-ID: <20260721045416.GA6737@lst.de>
References: <al4jGBGNG_QACaNL@sirena.org.uk> <20260720144141.GA16699@lst.de> <al6aCizqqilqQGZ4@gsse-cloud1.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <al6aCizqqilqQGZ4@gsse-cloud1.jf.intel.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Stat-Signature: z9kd4yxqtth4drrherfirbmc73e5yyi9
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 9C87D4000A
X-HE-Tag: 1784609661-224821
X-HE-Meta: U2FsdGVkX19t0sqLLYI/bDaEKBysgWOE2WFZ28NV7qcOQsHN7az9y/GA6MhrWDDDLRBPHG9aJDNlKgO4ZG/wCqtgJCU5r9FjIyQPp8wZvW6eh1hUaMect2ewPgQU7W7N+wTR8+he2CBqUi7+T4E9seTI8ltaBIvWHEXG1qB17QzkeYRrsptPx3Xqe/fIXSIMVWp2+SI8TlyabNm7i3jyACJhjXDfgt01EZ+zhxJRxTzhiYJbRkHGOxNcCuD93+q8W+K10fKHKvFhWBt/3sznctXb27EUgZhhL3hDGJVQ6FottLDN2p0Q8vixUDZdkQTjrZI/uCNDBCNQA7kg4acicY2hK0Sh7kClJgcVdBFxCi6BSubJrHLjPrrwNpV0cMd7CSWtiR1+QzaUR5AxLKWImiMhMp62AG2cy9993axNDT6mkdt9LwGZIGhL7Dt/n+cIZG7N70jcj3TZUEe7ecb/VJ0CBFSdAD4EeWZC87k5hMsPRmdp4Xe42hVB3yLgdP36xMOq2gFQhJvNvzR6MzI/5KVBmvFkhtKr59iFy7tAYES3NgmsmEdD3ZkL0AoEqTZ7PCTFuDSd2YtRjtic+yhH+nr0K9C1qsy7wy7btdCBSgGIO9wwqjxlobOpZrdOz6YF1CO8wA5MFRIiQJhdSinDlYy57cghaiHVcpwBr0S8W/8bn4h+nTolbe/p6i6olIYHuIk8H5ygAnso3YrGRgMqssXWuVhTzP0dNgmrIb7T1kPSgrrHDfC3PTtPKLKajpoiPXTTQEPbIyz4zTIZuIQpPgTtGimJhX7Jeo8Qhr/M4DAx32PerXVddQt98GrjA4fo0X3OhbPz5XGMU3niOhpCUo673zu/3SCqwieJXQRb7KwAI+2ZYyCCiy90rOF8JWsLWcepvWQKFHvFLDWc0xA+T4E7dm7Loc15jWaO9r8WuywOfn0I54LkRyA7TNqNxR/Qa9KpKCCunOYyFt3DosG
 9GTCvaPr
 wE7Lbwh9vufyhPiH37rFFYwXUICyOiNy//8DwX3iWXjSP+GIW8wMM/RxzYXILPUnzgXrTba1eiujO9+qV5MIkWQhxDrxh8fWibQgY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 20, 2026 at 02:58:34PM -0700, Matthew Brost wrote:
> Do you have a suggestion of what parts to move over to shmem.c?
> 
> Pretty much all of this?

That's my first guess.  Basically when using a shmem folio to store
data we should have the code dealing with it contained in the shmem
code except for well-defined APIs.

> I can take a look at this in a follow up?

That would be great.

