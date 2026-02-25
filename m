Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8AF55EFD216
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 09:31:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EB0A36B00CB; Wed, 25 Feb 2026 04:31:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E67EE6B00CF; Wed, 25 Feb 2026 04:31:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D3C916B00D1; Wed, 25 Feb 2026 04:31:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BACDB6B00CB
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 04:31:45 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7474C8BEC7
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 09:31:45 +0000 (UTC)
X-FDA: 84482461770.19.0354901
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf26.hostedemail.com (Postfix) with ESMTP id 5AC7A14000D
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 09:31:43 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=MG1gMWB4;
	spf=pass (imf26.hostedemail.com: domain of ming.lei@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=ming.lei@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772011903;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GZZSjVez67bmnK2NRSU6UxlSzwwe3Q6UiGHwSsR6W2A=;
	b=7q8C8s33nSO/aTzCOEgi/b7vONHGxv3TV6hrlZrSoyrigSyWW6fBIwT6aBkLIkAvCL8+4W
	GrlCfzuXoRD0e+cIKlgKvxsVmb4CDaM2k2r8jxMxUe/PnRFrnhLpbEllhsnDfYo/HzFHqz
	huAQU5zpcwx5YhQJX2IXrgUUfpV4QQ8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772011903; a=rsa-sha256;
	cv=none;
	b=NGt5da3JaROJnNsAzu7rcOq2e0c4MzEn2JqTCj+BCsaXUAMPL6NdJGUQceuULy1C/YiVjF
	D5NADnkAtzlIPYINLsd+cnPaUwL/mh7CLZi6qmgjOMSCd49RixI1lqa7X+T1iUu5QG4e6U
	RgAxwadhWHiM925v4qsmPLG1DIesd6s=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=MG1gMWB4;
	spf=pass (imf26.hostedemail.com: domain of ming.lei@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=ming.lei@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1772011902;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=GZZSjVez67bmnK2NRSU6UxlSzwwe3Q6UiGHwSsR6W2A=;
	b=MG1gMWB4RnBO6CCuFuAbkbBPQFoO9Y+JzE3G0MgRlW2EYSYLEZOzyXEQtsu72xuINWFsQG
	PqftmoePo5fX/eWpXa28+DyUFNK4tMA2qSjizYhM1oAjnvDM5dPmP3Uir8Ya5i73CNK9BO
	58hbZsnarmAUbRRG+c3PQMf3bqhbBdQ=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-672-WT7Mkpl-O2ya_WKqO2WGQw-1; Wed,
 25 Feb 2026 04:31:41 -0500
X-MC-Unique: WT7Mkpl-O2ya_WKqO2WGQw-1
X-Mimecast-MFC-AGG-ID: WT7Mkpl-O2ya_WKqO2WGQw_1772011899
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 567DF195605F;
	Wed, 25 Feb 2026 09:31:39 +0000 (UTC)
Received: from fedora (unknown [10.72.116.18])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id AB2921955F43;
	Wed, 25 Feb 2026 09:31:31 +0000 (UTC)
Date: Wed, 25 Feb 2026 17:31:26 +0800
From: Ming Lei <ming.lei@redhat.com>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
	Harry Yoo <harry.yoo@oracle.com>, Hao Li <hao.li@linux.dev>,
	Christoph Hellwig <hch@infradead.org>
Subject: Re: [Regression] mm:slab/sheaves: severe performance regression in
 cross-CPU slab allocation
Message-ID: <aZ7BbosIr2FvZFAe@fedora>
References: <aZ0SbIqaIkwoW2mB@fedora>
 <5cf75a95-4bb9-48e5-af94-ef8ec02dcd4d@suse.cz>
 <724310c2-46a2-4410-8a5d-c69dcc8de35d@kernel.org>
MIME-Version: 1.0
In-Reply-To: <724310c2-46a2-4410-8a5d-c69dcc8de35d@kernel.org>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-MFC-PROC-ID: iAzU8kW_4WmhNdjSkNVjRKNtQkS_zdTE5oT-OwkmAaw_1772011899
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Queue-Id: 5AC7A14000D
X-Stat-Signature: 4urpxjjtoj765p465pf8b7kw9r5iighm
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1772011903-787397
X-HE-Meta: U2FsdGVkX1/p+dx3TPS2glkzDSqcpZM6VKXpnzphpeXkSK2UxkeQCjJRIlXcPaKifz20TzoNZJoZQz8XD5Kp1XX54C5ghf4AiguRv8PYon0GKo1AqDTd86ujkiTlWCqBMb+UxgWwiNbWSjhQOgqkTAwnfxYOl7TxES8hBjP/Vcoh6G0DECddgTYh0L7gADGpyAU7jkxgu/sdxPiyi9LuuC+Hnaq0LJ4rdi876TQ35hmX3YASr47mKlec7SCa7kJfp6oyTCwL+bvh8o4Lnd19ruDpaPCs3DGk0+cY+m9SwKHz96PRRCeNM76xfNVYEicjRQHAWDDOFv+Tj7AYrfp3vvtHbA1jcdszib7+dgZ6UfcEXlS+xQqNQceRJ3zl5zXMX1UGEByU0Ub47C3NxHjh8NBxWn4JNjO/z4OhMEMChuszzeQpDRM8bxfDxa+FNz5KCZze+lLNll/em7uiNzaCGe6ZiwZHHcBbleuOMrhYNuofN79OCXLqCkZ0dB4HAKAXdVnjHRPe/2AoSjKc0OIGgualIOQx0cwjxLnA8TYPZxJmQVLhcB6VT3iK5j4wZfML9Z/G3VsbNJ3YMG3PXkmaYzkG4mWKe+c22sZcOcIGguV6PXAa6nleI84lWXedYeqjGtCtI7IExb561XtnuVrDjKf5Xs598vbD/rAuSOi5A05i9dMRQZAvbs8ApHPU5w3xj+j8CKXyvivj192ZVL+Oq5QkM66IUlQ7sK7Aw6hElqu0Mdk+Gkc3fBh38SnNmaz6XS80rtTOgFS147ZjSiAA9NgBJBgcnk0599EA8LSNc9RFYYndJkq1P5rN32iTq7sgPEzoXe117uxWnwtnImn/N4QaAwBhYsZbejYqZdV2IZzYSyzu75Q4Vx8lqzHGFwz1/Ii9PnuUYPdf2zVi+8fdrxrWdN1AkAeRTwpKuyZTn/Os+2gLtjn2YgFfX3jyXFVND6rffTB8xuv0kUwTcM6
 c1mWOTzW
 gVyzb4G649wcmk9xuLJVt19l5WU+9AnSmapuUF9cjhX2TGPNz3ztmIZi2frfOAw1JlMmAPWVGKTootKOCCckK9NlAThMliVJPfr+86F17kTkmI6d/hb5gjpWUEoEiR/ji4eV/lG/XE5LVStGrWTyDbEqanVIaHptaclQ40ACQ0/VhzOGV6hRgDAgvnartSyfrVqJN2NMsdaic67iYzZjXN1lHT3i5WK4E9iMqCTamOIRlNgMyto4iXM/s/5Cp3hSiAnv8fKUuIBImYEqpYKqiw/+dBMWPvXCg1oBYTSE1evUX0xtIrbpe5QEwGl3/zoLhC1fc
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Vlastimil,

On Wed, Feb 25, 2026 at 09:45:03AM +0100, Vlastimil Babka (SUSE) wrote:
> On 2/24/26 21:27, Vlastimil Babka wrote:
> > 
> > It made sense to me not to refill sheaves when we can't reclaim, but I
> > didn't anticipate this interaction with mempools. We could change them
> > but there might be others using a similar pattern. Maybe it would be for
> > the best to just drop that heuristic from __pcs_replace_empty_main()
> > (but carefully as some deadlock avoidance depends on it, we might need
> > to e.g. replace it with gfpflags_allow_spinning()). I'll send a patch
> > tomorrow to test this theory, unless someone beats me to it (feel free to).
> Could you try this then, please? Thanks!

Thanks for working on this issue!

Unfortunately the patch doesn't make a difference on IOPS in the perf test,
follows the collected perf profile on linus tree(basically 7.0-rc1 with your patch):

```
04cb971e2d28 (HEAD -> master) mm:slab/sheaves: severe performance regression in cross-CPU slab allocation
a5a9cf3f020f mm: fix NULL NODE_DATA dereference for memoryless nodes on boot
7dff99b35460 (origin/master) Remove WARN_ALL_UNSEEDED_RANDOM kernel config option
551d44200152 default_gfp(): avoid using the "newfangled" __VA_OPT__ trick
6de23f81a5e0 (tag: v7.0-rc1) Linux 7.0-rc1
```

+   49.03%     2.00%  io_uring         [kernel.kallsyms]       [k] __blkdev_direct_IO_async
-   38.66%     1.16%  io_uring         [kernel.kallsyms]       [k] bio_alloc_bioset
   - 37.51% bio_alloc_bioset
      - 34.98% mempool_alloc_noprof
         - 34.87% kmem_cache_alloc_noprof
            - 33.82% ___slab_alloc
               - 30.25% get_from_any_partial
                  - 29.59% get_from_partial_node
                     - 28.42% __raw_spin_lock_irqsave
                          native_queued_spin_lock_slowpath
               + 2.16% allocate_slab
               + 0.60% alloc_from_new_slab
              0.51% __pcs_replace_empty_main
        1.58% bio_associate_blkg
   + 1.16% submitter_uring_fn
+   35.16%     0.30%  io_uring         [kernel.kallsyms]       [k] kmem_cache_alloc_noprof
+   35.13%     0.12%  io_uring         [kernel.kallsyms]       [k] mempool_alloc_noprof


Thanks,
Ming


