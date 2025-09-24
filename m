Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 05610CAC5A5
	for <linux-mm@archiver.kernel.org>; Wed, 24 Sep 2025 23:09:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 40DCE8E0008; Wed, 24 Sep 2025 19:09:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3BDFB8E0001; Wed, 24 Sep 2025 19:09:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2D3F38E0008; Wed, 24 Sep 2025 19:09:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 17F7B8E0001
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 19:09:50 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B9F6F118A26
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 23:09:49 +0000 (UTC)
X-FDA: 83925688098.28.563077E
Received: from gentwo.org (gentwo.org [62.72.0.81])
	by imf30.hostedemail.com (Postfix) with ESMTP id 17EB28000A
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 23:09:47 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gentwo.org header.s=default header.b=WLrJDxT8;
	dmarc=pass (policy=reject) header.from=gentwo.org;
	spf=pass (imf30.hostedemail.com: domain of cl@gentwo.org designates 62.72.0.81 as permitted sender) smtp.mailfrom=cl@gentwo.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758755388; a=rsa-sha256;
	cv=none;
	b=YJWPfKrNt/lAqGQDXJbyBE9mUe+7nGJAEm99UcCpyex/3ftX+npAlTjLQEI1hFgSKpinJF
	jRhiR5OrPbfwX0HU4UVSdrKMFDckTrgyF6c+ElDZImGLsZjYGUsbWQ3MQBIr1kAH19LyzI
	61MCCXTkE7Lt4FJYcTwZjQjw6ehAdAg=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gentwo.org header.s=default header.b=WLrJDxT8;
	dmarc=pass (policy=reject) header.from=gentwo.org;
	spf=pass (imf30.hostedemail.com: domain of cl@gentwo.org designates 62.72.0.81 as permitted sender) smtp.mailfrom=cl@gentwo.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758755388;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KDm7q+MIJNTRpl7BCOFoPDj04yz/4t+34tin/l+vess=;
	b=2ppjORBBDV8szd9TWuPorQGzTyHbdKeYDNJTACBUcNzmup7cvpwXcMieGX6QppZq8hXHi6
	HvUlFxcecToOsP8bZENAaf1hu7F6Z48mDT4wjZLDcaVKUWC/ZViTCEcAd6FZ6mgsqcF8Bq
	QnsQ8pxC0Kdvj5rEimgnNLcAbsGIsjA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gentwo.org;
	s=default; t=1758755387;
	bh=KDm7q+MIJNTRpl7BCOFoPDj04yz/4t+34tin/l+vess=;
	h=Date:From:To:cc:Subject:In-Reply-To:References:From;
	b=WLrJDxT8W9UBbmk/+FKsjVXtd0LFDGdTEyb9WOSSMPMhYaMfNN0HyHARKw9zaTiQe
	 qQfTIwcYtqT+Q/x2bKM2QE828TSZG18Qc3kv3y7k4Wtv5V67C2aEgPvYZ9yU89Hg/5
	 tRv0Tm/h+V3KqyMEXOt+LhR56U3/S+mlwA1a2uP4=
Received: by gentwo.org (Postfix, from userid 1003)
	id 0ABC540293; Wed, 24 Sep 2025 16:09:47 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
	by gentwo.org (Postfix) with ESMTP id 0805F4028E;
	Wed, 24 Sep 2025 16:09:47 -0700 (PDT)
Date: Wed, 24 Sep 2025 16:09:47 -0700 (PDT)
From: "Christoph Lameter (Ampere)" <cl@gentwo.org>
To: Joshua Hahn <joshua.hahnjy@gmail.com>
cc: Andrew Morton <akpm@linux-foundation.org>, 
    Johannes Weiner <hannes@cmpxchg.org>, Chris Mason <clm@fb.com>, 
    Kiryl Shutsemau <kirill@shutemov.name>, 
    Brendan Jackman <jackmanb@google.com>, Michal Hocko <mhocko@suse.com>, 
    Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@suse.cz>, 
    Zi Yan <ziy@nvidia.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
    kernel-team@meta.com
Subject: Re: [PATCH v2 2/4] mm/page_alloc: Perform appropriate batching in
 drain_pages_zone
In-Reply-To: <20250924204409.1706524-3-joshua.hahnjy@gmail.com>
Message-ID: <a84ede7d-60ad-3df9-77ae-cd0dbc545b85@gentwo.org>
References: <20250924204409.1706524-1-joshua.hahnjy@gmail.com> <20250924204409.1706524-3-joshua.hahnjy@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 17EB28000A
X-Stat-Signature: th7f8hj78q53uwkdqwz8gqjxasrbwckx
X-Rspam-User: 
X-HE-Tag: 1758755387-303152
X-HE-Meta: U2FsdGVkX19Es6VgRRap/IBZa4ppX25NzEgO625hRN/yAsR0SlQvUlqGsmPJ+c+qQDoytvym+09a7LHM+OZjjgm6bhHPT31xhrOSR3nhk0XMRoxpsGT4+desNiKDXIcvAADVlQwoDeaLE05PNCTbUpHV4SdoSxAZ7mRgWd7LdifSX2mHRNnTb7nuAa7fOciTsLmBx6h3KMYXTNGqZ8Q5O0nrZ/aNfmI3PmdO6hkvGeAuuQzaLu7UcoADupX3JWlvYM/N3yYjl5EdJRvZPGh8wzA2sdFCXNHqsbUQPBmsHOW8DGBQXkTuyUUQWBO/izyYDL1nkToCrEQXMV1Ue3F+hJs6Z8mvwT2U4g9z2S4Un98pOCwVj/btFQreDCDfTAGZ1xFuVPIoYFunwwo9mYXY+6iJb3bKD7YYWRZyIp7yCzQY7QbXe815B8na53cvwSQuDTDnYBZYFknNoTIN4Uud9bEQlGDcYwRX0lz9cHEtn0m8wIXVZL+aJTbIA3XsOoGvibHkYoefsmmwKQ7RBnVwUOBxZ0Yvq00FH0iwW+bDKOSXy/TKpB5x0MvPXFdFWvKMFGVQa5/NHFpmcueKGqu/JD0xL0doUS8dUrey4L5aaxhM02FVK9O9YazdL7laUC76dgNuIfzNSfeo45uc2RkIUFhBKyOw4+7l457AsLp7pTa9Z+RfiSnyAuaJL3qufXfXwdHoGeEe/F3JA+XZSxI3EWpqIiKWf42vnkkzACL4CzMK5kTYacQ+wZYDSyoJjMMsepl5A/hMHuKKb3EDpQBRsF9A2FVubEhXD1IFqfRW8bwMBrAnXsZkB9IVST3fDZiUQmMXNl3vKqIplY6JkeCNlANdlED/TuA5Q+U7ywGSkT5sdUX6TFJFeB2gm9Jc2rfEa5vyDAUgDzL3LxEG9ZbSm/tAmSt91kok8QfoUnTtqi3Jj23xkg0LHtzsrF/bKCJCGnjNUA9+9CZiu89TbKN
 cKLsLpiT
 K/G3//vZPmDb5YetJX386TrSFWQYGa0ARgGfV64p8xoMLzGYNjcYqla31/8V8fF7nasjoREmnrsXwFpZJlAoQeKYlQ9NhrsieJsOhE6c/QF1Ecy0qT+TYapGk3C2AkyjliLt23YBXrdrDfWWS2uaJcgE8Sl42z6/W2PtHym64wWC1+7expxcJxBjMIAnBprsmbWWKoTK1AOr7OY0mji3nGRyei2S6a2UfmDyu9P0StH1QQAg5JMvvTss594DjTQ5Y2g17P+jO3MDsaFmZszWNCPWFaOzg8uG/uTQKBRz0f2BK1tjl3ERgNV56NdjUcssUQdyQKSK1tTvLPiY5MyFVmNsgl6jkUJpXYESbiWo8CrpzfHYt+bekpG2nZQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 24 Sep 2025, Joshua Hahn wrote:

> drain_pages_zone completely drains a zone of its pcp free pages by
> repeatedly calling free_pcppages_bulk until pcp->count reaches 0.
> In this loop, it already performs batched calls to ensure that
> free_pcppages_bulk isn't called to free too many pages at once, and
> relinquishes & reacquires the lock between each call to prevent
> lock starvation from other processes.


drain_pages_zone() operates on a lock in a percpu area. The lock is
specific to a cpu and should not be contended in normal operatons unless
there is significant remote access to the per cpu queues.

This seems to be then from __drain_all_pages() running on multiple cpus
frequently. There is no point in concurrently draining the per cpu pages
of all processors from multiple remote processors and we have a
pcpu_drain_mutex to prevent that from happening.

So we need an explanation as to why there is such high contention on the
lock first before changing the logic here.

The current logic seems to be designed to prevent the lock contention you
are seeing.


