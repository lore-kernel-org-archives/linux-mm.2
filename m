Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DB825C4453D
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 09:43:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 22AF76B0092; Wed, 22 Jul 2026 05:43:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1FF006B0095; Wed, 22 Jul 2026 05:43:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 116FF6B0099; Wed, 22 Jul 2026 05:43:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DA3986B0092
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 05:43:57 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5F84FA0EA9
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 09:43:57 +0000 (UTC)
X-FDA: 85015926114.19.6B72A4F
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by imf08.hostedemail.com (Postfix) with ESMTP id 83C63160006
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 09:43:55 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lst.de;
	spf=pass (imf08.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784713435;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Z/vnS3jKVr2U0OQlxBPo9zJ5nbDSq/qv2qcCFmNnSKs=;
	b=zpbR4hv5q5crvqujlllUAaNZf6J7ceTmJ8lT8BhPSvfJSIVep04PqcdRcyBW4TfDMzALJQ
	WuwpgRy/wSbfc88lFYmUqnLmWsSSN0Qfm6vvvXFtPQ9cLaKvp9R5e7aEgWm4FpAKHu6u6Y
	9Tei7wLNNNhRFBKNjHvHWCra58kF78E=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lst.de;
	spf=pass (imf08.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784713435;
	b=tC9P9p5iwKVmVRYi5++HsJd+JVY9ITk5NUes3Xk8nbwbPQGpFSCDIElvIX47/hfdUgNkYI
	3754eE20NqlniUh1k9wHy67HCbmC+A+16D7WbpR8Ky1JfGnnlrwZ1On7a2gh7V6YSyxwcP
	hF2PTHZFeUb6HYiyPVyYsY0gvDCuy5o=
Received: by verein.lst.de (Postfix, from userid 2407)
	id 88ADA68C4E; Wed, 22 Jul 2026 11:43:50 +0200 (CEST)
Date: Wed, 22 Jul 2026 11:43:50 +0200
From: Christoph Hellwig <hch@lst.de>
To: Matthew Brost <matthew.brost@intel.com>
Cc: intel-xe@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christian Koenig <christian.koenig@amd.com>,
	Huang Rui <ray.huang@amd.com>,
	Matthew Auld <matthew.auld@intel.com>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
	Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 1/2] mm/shmem: add shmem_backup_folio() helper
Message-ID: <20260722094350.GA1057@lst.de>
References: <20260721174723.1039395-1-matthew.brost@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260721174723.1039395-1-matthew.brost@intel.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 83C63160006
X-Stat-Signature: fu7uhdd1ihq7irxwtb8p3ypx9f8of4e6
X-HE-Tag: 1784713435-677739
X-HE-Meta: U2FsdGVkX1/lZpS42UldVeCDcXBI2yUV0/+VWx5ZKHjm6HBqkgqAu0KqkxIxy4I/r7ZxzlHk4BXx4VYxkWmMHUxK8/PBSucrsHojrgbDqJO6gGAvHpXS8kKOOJpU2dVGO1jnxmNOYnNjBy+TxSDfjm+7ZkXc6o7d3vXkxOuqLqriTfQO+lkDeYVhwzfMlZYvc+G6DZd3+q7s7w9/hFdYgn1/i4eV6VH4OEbP8wZsVL8FGdeR5ZBBxBngoTUyLgj6hbKwGR1XiDKupNV5Ub9Dff46rMVfKxNUeLqSGNTgAhjPHScd/+7Rq8MnocoDwVtcoEN1CU3ahbO6ORmAek5ezqUPuRWBzYDsIw+Ift8EGVPanJ5o1TpEWSeWFfvceEQRwvcEI+FQRYsD1BC6FbSu3HHmB43sCUwnR7knVye4w3NUZlXVseFb4qP2Uioi0ZHlfHQwTuYeRf2QmfCdXf5z04b0s9voPygUiyeiCxhSY+fPBHFYRVtU5U6jGB6XJo1kCgL2DX0g5yGurxf34DOBUOhhDdmxsbLHdROcXfWB6RsBHKG8qJbWxHi4dKOzzccww4EGFfCJvd8qm/1+QFlL2TKkyu2nL6/Ez1lgyCd+4ZBA9mgK81SW+FCQRZLhbTQs11BFP1Xre7q31fonygx7rm6TZX83rmkC6UNsXTyfexN3AerWoW38ISLnOENxNMqJS56wuItzKixhNVduC3NKq6nEjWR45hkoq9VAn0QAmECvzYy64PumESbMPgkYGL3RIX8/oT3QeUm2oGcecBLC4/EKgGo/lmZnlfGVBjgVWNNOOxC1jLwiWXrI5gzXknK+8oNr21mTZY4ynYRs6u8tXKEfUlBi+2ufB/ctq+BC76PHCGKGcsTNhtC1biHdxvc9PcXsTTBT5NiXxzI8dGCONbg6w01hTpXjfis0+MD0onqKctmEgtaJYyfzhK5MhYTvCIJfpVv+VZwRm/VyXfn
 uypVogY6
 RrgY0rRyDNrlcuhgm1wTgFas/xgRf9ltZXjtrjrasFJPE4oiVivy8nxtCMI+mwrHifpDlWiIIkLyPJVGThK6DAYZHs5NQ3gNlpIgyHUZTEBM/tmak0iOPqwjvCsnvK+Uj6N9rTW9Zu8fQQnQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 21, 2026 at 10:47:22AM -0700, Matthew Brost wrote:
> Add a new generic helper, shmem_backup_folio(), that copies the pages
> of an arbitrary source folio into a range of a shmem-backed file,
> optionally issuing writeback for each destination folio. It is
> extracted from drivers/gpu/drm/ttm's existing shmem-backup loop so
> that other subsystems (starting with TTM in a follow-up patch) can
> share the same implementation.

Hmm, what is the difference to just doing a ITER_BVEC write with a bvec
containing the folio for this the pure write to shmem part of this?

You'd probably want a kernel_write_iter helper wrapping
__kernel_write_iter for the writecount, but otherwise this sounds
like a normal write.

We'd want something for the writeback part, preferably a purely
range based API to be generic.

