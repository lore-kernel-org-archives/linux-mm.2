Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 53DEBCD5BB0
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 13:31:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 98BF56B0093; Fri, 22 May 2026 09:31:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9631C6B0095; Fri, 22 May 2026 09:31:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8A0136B0096; Fri, 22 May 2026 09:31:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 763356B0093
	for <linux-mm@kvack.org>; Fri, 22 May 2026 09:31:49 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 09345408AC
	for <linux-mm@kvack.org>; Fri, 22 May 2026 13:31:49 +0000 (UTC)
X-FDA: 84795143538.23.6EE67DE
Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	by imf16.hostedemail.com (Postfix) with ESMTP id A59C1180005
	for <linux-mm@kvack.org>; Fri, 22 May 2026 13:31:45 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=GIrzlUjb;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf16.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779456707;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2aX7YTATscB3YXiocdTFPO2vOumI8d6GYdEj2aLitJg=;
	b=f3O7aYH4DYeih7GULooXtdTsOscFz0VADkbdnnMFuPsDnkUAq7Q1PV+s9Etdd5UcLirUMr
	zzayy6V85dhEOysE+pIM4UrC9M9o061FNQRummgKake7EUSm12OP6ESA8dLS3x+Fvch1nc
	sB7dEh/Qz9av7AKcIVbYDs/e0nQp8WA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779456707; a=rsa-sha256;
	cv=none;
	b=7+mSSgeazrtsc+GZ5yIvVgjGG1oiQ/+qVQBAHVu4hBt0lQdaR60nT7p9x16W1e5Wtejhwb
	qqlWomYH9o/VWBz36HKiC/0AsyvoQ872hZoPK80XOT/NBUt9eN0X7zUIzuotTThKBa4lDj
	+KmcWvlGD5yG9JxIrbWjbkEWbx3kT58=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=GIrzlUjb;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf16.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
Date: Fri, 22 May 2026 21:31:34 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779456703;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2aX7YTATscB3YXiocdTFPO2vOumI8d6GYdEj2aLitJg=;
	b=GIrzlUjb33kDORzzfNB2L4BpeXzhGweLYOk+bYw9UZAVFX7ISdpC1eftobrSbs33IB6TpG
	fg7dZsanztAotpvcPhWKsEO1+vdihkmMXklmX69qavndH3t7kl13yS9jeuDX/f7iQTiepc
	ge8y+jKlbYiay89uDSOy0qeNldRjx0Q=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Baoquan He <baoquan.he@linux.dev>
To: Christoph Hellwig <hch@lst.de>
Cc: akpm@linux-foundation.org, chrisl@kernel.org, usama.arif@linux.dev,
	kasong@tencent.com, nphamcs@gmail.com, shikemeng@huaweicloud.com,
	youngjun.park@lge.com, linux-mm@kvack.org
Subject: Re: RFC: better block swap batching and a different take on swap_ops
Message-ID: <ahBatit1UJyAyem1@MiWiFi-R3L-srv>
References: <20260515120019.4015143-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260515120019.4015143-1-hch@lst.de>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: A59C1180005
X-Stat-Signature: 6n7yy7fnn7i7hhrwg4zf3mr7gjjqpen8
X-Rspam-User: 
X-HE-Tag: 1779456705-507279
X-HE-Meta: U2FsdGVkX19oNAPMZ55ZNQwQ6QfqOFY6ivBH9EIninjq9dq5M4PCfVqKk7yGWHSCrqnNdQmN6XegFfHx7osQ1pCRLeDNqvcZWE15iKH1NIfcEiTcDWdkxrC0plQVKODJegI6nzMb5YMFNBOn4FNQqwNbfZP5l8tgDY446NCv+ZLWntHP3AgzqAaTzHAvJ56ua8xDd4ZIgt1FE/4v9iaUfVSFOz1KJ356t2NnNZzACy8P8G6s5IB2o3nyvOgRRAN2wGK/++73352lg6ZmqW0VdeOg8ze2wWDG63xTfXt+J8Bs1j3pp8/kWYi7yCL0y7vXYot3Znym9Iv4/vWjUvwrLace9PqUa/pTLf+Ked0Zep3GcFfQ1oT3SN96n6m2frQQ1owJR3571ZUiw+83HTmPX060NXXMuuVTYjrmiAhfUIeX73M1SGrUdAdrFLIaU/CgdFE6ts0JpU9W11oweIpILUX+WngK1jiegS5JTa2iQJk27cfQYmdLsJFl/xSVT7zjjNZi3ZOiRIeMdzFRuvazfkAc37D7EfZ8j3OqXU0Ncx1Leps9xjOVRcHFUmKnTTKaEx9Oyr3uccxMnbDLpIYp6mzVEYEZhB0ol5ERp2hSPUgFkEyMoP8TZZKAypFammapZy6cTx5wdq26wMPK9xKcbQuBSz2PsZB8rLkLwVS9EmhauhMHmEyYTWOE1VWH0fwFO+UeUdy5R5A6pbml5evDF6BTZ1vJpx6RFQNsP2pd7wbUsiisaAsUZ9MRXcoa6c3eWjxhNl0W8meM80O+Jo+yAlJ/uokwTE2GuMBJQz7NZ3YSYCR8L3+JlUXB6eeMAKnyHwrqEQKVW6bE43O02WY02TBOXfkG7F4eE4aWWZTKW8cN6HQMM5WUrhMvbidZRkicYVMoSjLdKZ9KJuBodjaI3Jx1OwjeAaaDwPd0WpqRUUKZrVc5o111hn2Whm/ZyGrPhMq2t/3VtwT04B4qHk9
 6Nh4PQKk
 28KyO2yMcUCRwI+D70E8r2Wr1MKfF2zQR+k7VZwTwKNmID9aqjaUmwnNlNuW2J6zTV7qPFQbCL13q4rjSDiZugKC3FEofAnWg31TEweDZnkJkqEMDz4BdG3eXcg1iPgz8IYTorIortObIV+vkaSWTrfXQojh5BjLOePaiuqSbplWW8JkZHsivSX6fq/ky273A/HIEwKIAsdTsO+CCmMEMh9r6WgD/kplfJk16SvvsgKblutWG9eGCZIvdaL/m2DRwv52hXs5Z9V0z4yAJiZqSTeB/N6cNN+ix2Cr1V2ndmGuIITQf07ZwR3DU8RFwhYo1hRCN
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 05/15/26 at 02:00pm, Christoph Hellwig wrote:
> Hi all,
> 
> this series makes use of the swap_iocb for block as well so that it
> doesn't do inefficient single-bio I/O, and then rebases the swap_ops
> from Baoquan on top of the now very different method structure.
> 
> This is very hot off the press and has only survived very basic testing.

This looks good, and worth a formal posting. That would be better if
stat number is pasted about efficiency promotion.

> 
> Diffstat:
>  Documentation/filesystems/locking.rst     |    5 
>  Documentation/filesystems/vfs.rst         |    4 
>  drivers/gpu/drm/i915/gem/i915_gem_shmem.c |    2 
>  drivers/gpu/drm/ttm/ttm_backup.c          |    2 
>  fs/nfs/file.c                             |    4 
>  fs/smb/client/file.c                      |    4 
>  include/linux/shmem_fs.h                  |    5 
>  include/linux/swap.h                      |    7 
>  mm/madvise.c                              |   16 
>  mm/page_io.c                              |  544 ++++++++++++++----------------
>  mm/shmem.c                                |   18 
>  mm/swap.h                                 |   52 +-
>  mm/swap_state.c                           |   40 +-
>  mm/swapfile.c                             |   11 
>  mm/vmscan.c                               |   88 ++--
>  15 files changed, 402 insertions(+), 400 deletions(-)

