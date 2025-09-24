Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CE04DCAC5A5
	for <linux-mm@archiver.kernel.org>; Wed, 24 Sep 2025 17:40:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 21F248E000F; Wed, 24 Sep 2025 13:40:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1F60D8E0001; Wed, 24 Sep 2025 13:40:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 133698E000F; Wed, 24 Sep 2025 13:40:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 01B588E0001
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 13:40:43 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8EC6F5B9EF
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 17:40:43 +0000 (UTC)
X-FDA: 83924858766.30.FC9C78B
Received: from fanzine2.igalia.com (fanzine2.igalia.com [213.97.179.56])
	by imf23.hostedemail.com (Postfix) with ESMTP id 91DFD140002
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 17:40:41 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=N3MrS6ax;
	spf=pass (imf23.hostedemail.com: domain of mfo@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=mfo@igalia.com;
	dmarc=pass (policy=none) header.from=igalia.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758735642;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=AKqISWi5pFZ3HfusPO8StEZwUrSgKKkuNFc8w/cbCQM=;
	b=p/STJr/xHOhXs7rgsa24QVeKy5UAHNaSvLewiUnyE0Btdif8fFBRamW847GfEZh0VcxZ2o
	pZOY1OgYyEeAFjqgpCuk0/lfYpQouTS9HMuel6cKFIJyf5TbzJi/P2Fz2z0aLicRa/SvV4
	cs4ZFSPkkrgijmmgXUzYcbFo/a7z3i0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758735642; a=rsa-sha256;
	cv=none;
	b=pAQaGOzTEoXN1V5VD6UgUyL5A3euiP+VMAxCuWFDIeae5hC08upkQJbmaGhUkWiH1lneSS
	gvpdWTn5AyPeCyVeukYnTAqyCblAXfPY1aKdtcsqE4Z/tG5KpBXXCqwReyDYN2L4/NfKOz
	F8YSrYofHQIuWB2CvRIeOJ2meyDeq8M=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=N3MrS6ax;
	spf=pass (imf23.hostedemail.com: domain of mfo@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=mfo@igalia.com;
	dmarc=pass (policy=none) header.from=igalia.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
	s=20170329; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=AKqISWi5pFZ3HfusPO8StEZwUrSgKKkuNFc8w/cbCQM=; b=N3MrS6axRSCDgelm5aqIGeLCWJ
	f/IRkEr9n9u5Q4L1qne/Lkx8FAG7mLkbvfUOlA24oi6dYKPiCgVh/7OP0iyRCwqETWEYymQDWxE5g
	OiFmV3e4AqdS8592P53AQOa0W+9CtzWQ9GgUKGZrk8TPmZU+EKgRip+joyVJ9zavTqK5gkYY61KZs
	z/DcbChyrdhIXbgRs5qrbu2M8IhQeb2+MBhO1aHywbBUocJsfGTsfzgcePU5ISYziIi2G8IjJYtGJ
	EwunbGK1FINF4eops31fkn1YvkkRsDSpy2n/lgNpnT3gSOtf94JOmgL2VwFBi4VnPf8IT8MT1c1zp
	oP2g57LQ==;
Received: from [179.159.118.139] (helo=localhost.localdomain)
	by fanzine2.igalia.com with esmtpsa 
	(Cipher TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256) (Exim)
	id 1v1TTj-00Gz9Z-2r; Wed, 24 Sep 2025 19:40:31 +0200
From: Mauricio Faria de Oliveira <mfo@igalia.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@suse.cz>
Cc: Oscar Salvador <osalvador@suse.de>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-dev@igalia.com
Subject: [PATCH 0/3] mm/page_owner: add options 'print_handle' and 'print_stack' for 'show_stacks'
Date: Wed, 24 Sep 2025 14:40:20 -0300
Message-ID: <20250924174023.261125-1-mfo@igalia.com>
X-Mailer: git-send-email 2.48.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: cymi46suh4j1kzf48d9856nxhc3cdwya
X-Rspam-User: 
X-Rspamd-Queue-Id: 91DFD140002
X-Rspamd-Server: rspam10
X-HE-Tag: 1758735641-422460
X-HE-Meta: U2FsdGVkX182qvEo7hNcP3b4eiewglTzVpcUoPc0BR0+zNMBhgwKTth6aBlSLnFDznG+j5FQLONGtp1TsKlEOp1R9KDOXwGz66KOAPzhCECJ4ObjwRx/+vCT9Ay2Hk2P7raIDkyYrqR9CmmHrB9g145v+XTmqZUTsiUsZ5bIm1d6FVhYBNa9xN4tx7AZkHLvoflDQrJL12uAXsP93Yp2OQBDe7QF0o7MamyBNJdhMx77fM8Kj1sUzV4SIgABEIlrbjXZ17Cpah9J5Cgi3DZ3l51w7dAyplLHwnB24QmIi7gEcYRXxoL9lS2JUrQu9yWrmXqQiL6tVBM1gW3Lbk8MhYec3XckuYpqy+5YkrqQypioHXXKchc12EO/kmFZmuiv0FMxskHmtL4DtdzaWeODWgYhGNGFves2b4IevR5UsWEbxoBvVi2LGbO8zZ9JpWzktkdKwap19OwMLmq3CEJe14vpFpq3+zUxaojl6ghm2gygLvwgw+arKoRVmd1kO7zsx4GLGGoAcqAvoxhGnowZ54DAcTo3i57GN6HBCSTejh87a6fkCeXq70MFa4xFeQka2UTvQCeddYFTCt9KlOdaL/+oyufWqhgURa5mL6ngi7p7URFe2H4CbEYx90Tgh17CVeS3IEnQUXq2AuvbbM3wrJjHYXvsJql765bhQTI2tAbTSNy8ypGJqO91GXaBJLf+hkaBsltzgiSwLH5VW0fF/7ZafhY21gaj2sxVu+unZ5SABjAgAG6Q8MUkms3BJU9yPpiC0u0YO3wrGXrsqc/zR3p6H4CAJ8zb5qs7zmDXGSb36nZikbK/gXTj/vn3Elx8n1DPibojsAi2BHciXEQr8xFFOHIt026IVzqQfxMYslxf0xK5vlecvz2EKRxXEjXsIBYM1D1U/pvZpPWCmn006wrd3+tHTQn6rhQmbqevvZRmjV7/DCSCT542iF1zz9yCDu/ZulT5FRkA2ale6lD
 7oGRZfB5
 4sZzZmyEeRU6L3OBwWktxYlK//KGL9H4DiR7xVmsAZ848JouCfsx1gc+c1cfVFkksdBl/EruX59ptKv4v9hJ5/HVcV+apni4YItom3S4eH/5GjDJSg2ZUUbpimXc7R1tvzYfXF8yq6bxqvZYGmvjh0/nzFHidh4V3CdDLp+KrFsK9dQWdLkqftQ+zITxhUpwYIKvbtofN0sV+l/tKv9aJI2JaYDDYqiOiYukaIBbPvsV7dAenQ5YIbAA9WJMEE/5bSSVw
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Problem:

The use case of monitoring the memory usage per stack trace (or tracking
a particular stack trace) requires uniquely identifying each stack trace.

This has to be done for every stack trace on every sample of monitoring,
even if tracking only one stack trace (to identify it among all others).

Therefore, an approach like, for example, hashing the stack traces from
'show_stacks' for calculating unique identifiers can become expensive.

Solution:

Fortunately, the kernel can provide a unique identifier for stack traces
in page_owner, which is the handle number in stackdepot.

Additionally, with that information, the stack traces themselves are not
needed until the time when the memory usage should be associated with a
stack trace (say, to look at a few top consumers), using handle numbers.

This eliminates hashing and reduces filtering related to stack traces in
userspace, and reduces text emitted/copied by the kernel.

Changes:

This patchset adds 2 options to configure the output of 'show_stacks':
 - print_handle: print the handle number of the stack traces (disabled)
 - print_stack: print the stack traces (enabled)

Now, it is possible to sample with handles/without stacks, and do one last
sample with handles and stacks to associate the handles with their stacks.

Tested on next-20250922.

Results:

Numbers on a freshly booted system (gains should be higher after load,
as more stack traces would be present); average time of 10 runs:

 - Baseline: 
   average = 0.165
   # cat /sys/kernel/debug/page_owner_stacks/show_stacks >file

 - Enable handles:
   average = 0.165 (same)
   # echo 1 >/sys/kernel/debug/page_owner_stacks/print_handle
   # cat /sys/kernel/debug/page_owner_stacks/show_stacks >file

 - Enable handles, remove stack traces in userspace (example):
   average = 0.167 (+1.2%)
   # echo 1 >/sys/kernel/debug/page_owner_stacks/print_handle
   # grep -v '^ ' /sys/kernel/debug/page_owner_stacks/show_stacks >file

 - Enable handles, disable stack traces in kernel:
   average = 0.041 (-75.2%)
   # echo 1 >/sys/kernel/debug/page_owner_stacks/print_handle
   # echo 0 >/sys/kernel/debug/page_owner_stacks/print_stack
   # cat /sys/kernel/debug/page_owner_stacks/show_stacks >file

Mauricio Faria de Oliveira (3):
  mm/page_owner: add option 'print_handle' for 'show_stacks'
  mm/page_owner: add option 'print_stack' for 'show_stacks'
  mm/page_owner: update Documentation with print_handle and print_stack

 Documentation/mm/page_owner.rst | 15 ++++++++++++++-
 mm/page_owner.c                 | 18 ++++++++++++++----
 2 files changed, 28 insertions(+), 5 deletions(-)

-- 
2.48.1


