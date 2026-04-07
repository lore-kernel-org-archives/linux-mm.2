Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 76532FEEF55
	for <linux-mm@archiver.kernel.org>; Tue,  7 Apr 2026 21:48:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8E4D76B0088; Tue,  7 Apr 2026 17:48:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8960E6B0089; Tue,  7 Apr 2026 17:48:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 784E06B008A; Tue,  7 Apr 2026 17:48:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 66CD06B0088
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 17:48:03 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id EB6CF16098F
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 21:48:02 +0000 (UTC)
X-FDA: 84633098004.30.527662C
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf04.hostedemail.com (Postfix) with ESMTP id B2EF340009
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 21:48:00 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=pmWQgkHj;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=xv+MegjU;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="pf/oVFrX";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=wmetIu8h;
	spf=pass (imf04.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775598481;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=A0WdEE2sofiVhBLyKr3CUDsGmwnWEPkI4p70h7A90Dg=;
	b=RbLXzx2RoVfpaQfZXi54131hB9IgOB6nLoXHzRLQiv2jNzllhmR3K3IaiiIkqFb7K1Kth2
	T8JqBeG2lDSIxa4oxEPd+Xfm0KE/4Ki5Q2wjZUGOr2uomVvC+RUm/+2EY2E6T6leGL9P0/
	xJauK4tuZnGOu6tZl7HBbTHGGCHIVvw=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=pmWQgkHj;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=xv+MegjU;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="pf/oVFrX";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=wmetIu8h;
	spf=pass (imf04.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775598481; a=rsa-sha256;
	cv=none;
	b=ktqykLVq4Yor8ZDct6Xc7ZgoZFR5yd3VwbUbiEWO1biIi0CHDW9n5UooRsM+vBa5rqtQqU
	9P4/xMidfEG/8W+SSkrNj0i5qCfVtYkW4+iDv4HMwbrlAAl9rH/2ZYDOjIQRoIlTS+/nm1
	r+WuRosFOUOoImkFSwcorHDJLPJIkGs=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id BFE9E5BD51;
	Tue,  7 Apr 2026 21:47:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1775598479; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=A0WdEE2sofiVhBLyKr3CUDsGmwnWEPkI4p70h7A90Dg=;
	b=pmWQgkHjmko9fi36qMFD2dcdJy+suAXLE80dCtjd9AXWiX81eu55S5bP8WoH3lIC79AHVY
	sUe4B7ZMgNhBT9w1dad7yHqzXd+KhFsQZBCJ6g09xO8xjUZHcBtx8MDRpebV3WgLyFwWaw
	F06vLHiIhCUqe7QRUNxpRkryyODuVEc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1775598479;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=A0WdEE2sofiVhBLyKr3CUDsGmwnWEPkI4p70h7A90Dg=;
	b=xv+MegjULAnyn9cY+7UGn2GhJJ5GN9YvHfmY4jqdDfVNTSm2hGROadMMTSZHHEIHgny1nJ
	/XLAEGQ9MdmLzaDQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1775598477; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=A0WdEE2sofiVhBLyKr3CUDsGmwnWEPkI4p70h7A90Dg=;
	b=pf/oVFrXDhaxZA8+Ov37+7idTlMU24lZt6V7roZlDF79wXhnS/00ZY18zGkuHCk+VmMYh/
	C1ODS+uKUy2GxGk/OJk0Bmbfo/UZQ1yJ+QY2e30elNJJmzMZZROrMYCIgsjc2UrvW34V/s
	ZQi5UUupD/cmg+6fuuAMRtJDUPoGzrg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1775598477;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=A0WdEE2sofiVhBLyKr3CUDsGmwnWEPkI4p70h7A90Dg=;
	b=wmetIu8hAI2rVJUNivRPkMr0eU0xcf0qGr3sbzUVs/uQE1SExMrc7JrAVkQEsQQcjaAwfn
	SMiCG4qvUzCTySBQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id CA3B24A0B0;
	Tue,  7 Apr 2026 21:47:56 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id DMWFLYx71WkxRwAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Tue, 07 Apr 2026 21:47:56 +0000
Date: Tue, 7 Apr 2026 22:47:55 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: Joseph Salisbury <joseph.salisbury@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, 
	Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, 
	Barry Song <baohua@kernel.org>, linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] mm: stress-ng --mremap triggers severe lruvec lock
 contention in populate/unmap paths
Message-ID: <k2ldf7rk6mogzhoe3r7a2hpcc62x2uqqpnwk3czbet4shpirs5@sqfzsqpdc3fk>
References: <a3474fcf-9f20-47ee-9d15-233e5c7e3f83@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a3474fcf-9f20-47ee-9d15-233e5c7e3f83@oracle.com>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: B2EF340009
X-Stat-Signature: uen6jch7zefz5uqowssjohaqe4ojx47k
X-Rspam-User: 
X-HE-Tag: 1775598480-146479
X-HE-Meta: U2FsdGVkX18NaxsjzH3L2mvu/riKlSB0iGuiotHNoos5iljaGDxZ0tH6utRhWaEGr4UCYgRLTlIzSoj8I6fUZx9wTMWSsBGDBuJOf/umfolUqfgIhf2QfysCTwuJXtxx+LXxQjaEPFC3+fbwCmIFHx4U0wzkz19oQqiZzHYaQ0UN6zZTLkRP5s47ntXCH2VYpJ9+zUHU9IM/kY0EOnWLSkVOiKQqe8fx5X+lYgN6PMIK0j+EVZ3hPepXSQw7NiaENgYeL/W6e//Q1RS4LtRwM/OGsk3YCyu/J6jBzHdL8VgDJy/m1XnjNEdIEwa9BsFbwqBBXiHDGAFj/wVIkh6r76r2lusT4vkuydsBVoeHr/FtS+bsKVxWn8u1V279Jm4aA1Rjo+YqcWyQ+Yy/HpQ/l4LUhK/9i3dsuRe5+QsSYYDfyPmdX3b3GRNEbE8D84Ku+yMQSBkRwTefMqNXk8FbNIxpogUtSRZ2oMp0cF5m47KQ1cxHk1Z6t+DSODDdUUTqsXVHaS3Q15/rq7wWLsvUkai4AlZWA8aC1yyedvQOoHZl6Yvn2juw72ckSMR9jqLQSr/k6pR4uC252MN8jTRR0QIeaMGhI3F2bwThctshJBtoJbJ5/uXimnntY+3DZApjTASipEeJPYvCpTx+6TRVYpJ+QwFifVs0AmYA25SlH68VdbMgATVVf/vYNeVmJfnX2FMCBpe0hTfW1j9P4HD7hXFE7ehjIF/MAX6aKqwh29pO4izrRJWK76cfQCfv3rZQYvjDwmt+L8SmthHdE8QH/Zycre3zHiMDKtbNFziVC3yE1bXYXy4NmOjbsukI2sh37Bfcg71uqMcFDfXoU4fHvFKh8rFDysqDIRklW4ItobZbTdboofRcAaM3nEy8wuduyRpeAuSxwbwjNxp4IS8fKgOLEnu4EvHyuDCetae4L5JMYUZojL0vCgeRD2aQ6eAOFjwpnmcOySHHqxKzKRj
 wCCnKFP2
 Lyy7/jPgHagDDtDVhZvoy8NkZ0mObSz1/rYZXjC2cCrwzZXhSsel1DbDjmomMV5CvKXjlSvpYlHasSGtZyxbcxu4nDijbG1Jx7mB6nCBybyaMTC/XwQWtITcRuLV0fnMoxccEQWCV46jzdWNpPsvA0Tuyefhi2LHFOcptyIpHoAxXS7Gz9Fw+rMKVHS6fvdtYjJ+KwM2GO0OSKrxWklq4AEoZdziy2SHIaeFERw5UB7LbFocas7sSQXXQ+wc+OqhgErwJTiT+ljfZYJTd0dcULURyURTZ8FkFt5T99is+X+ipXSjIHxDmUJAX2fRyv1fGRyHLV3QBp4G8M2o=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

On Tue, Apr 07, 2026 at 04:09:20PM -0400, Joseph Salisbury wrote:
> Hello,
> 
> I would like to ask for feedback on an MM performance issue triggered by
> stress-ng's mremap stressor:
> 
> stress-ng --mremap 8192 --mremap-bytes 4K --timeout 30 --metrics-brief
> 
> This was first investigated as a possible regression from 0ca0c24e3211 ("mm:
> store zero pages to be swapped out in a bitmap"), but the current evidence
> suggests that commit is mostly exposing an older problem for this workload
> rather than directly causing it.
> 
> 
> Observed behavior:
> 
> The metrics below are in this format:
>     stressor       bogo ops real time  usr time  sys time   bogo ops/s   
>  bogo ops/s
>                              (secs)    (secs)    (secs)   (real time)
> (usr+sys time)
> 
> On a 5.15-based kernel, the workload behaves much worse when swapping is
> disabled:
> 
>     swap enabled:
>       mremap 1660980 31.08 64.78 84.63 53437.09 11116.73
> 
>     swap disabled:
>       mremap 40786258 27.94 15.41 15354.79 1459749.43 2653.59
> 
> On a 6.12-based kernel with swap enabled, the same high-system-time behavior
> is also observed:
> 
>     mremap 77087729 21.50 29.95 30558.08 3584738.22 2520.19
> 
> A recent 7.0-rc5-based mainline build still behaves similarly:
> 
>     mremap 39208813 28.12 12.34 15318.39 1394408.50 2557.53
> 
> So this does not appear to be already fixed upstream.
> 
> 
> 
> The current theory is that 0ca0c24e3211 exposes this specific
> zero-page-heavy workload.  Before that change, swap-enabled runs actually
> swapped pages.  After that change, zero pages are stored in the swap bitmap
> instead, so the workload behaves much more like the swap-disabled case.
> 
> Perf data supports the idea that the expensive behavior is global LRU lock
> contention caused by short-lived populate/unmap churn.
> 
> The dominant stacks on the bad cases include:
> 
>     vm_mmap_pgoff
>       __mm_populate
>         populate_vma_page_range
>           lru_add_drain
>             folio_batch_move_lru
>               folio_lruvec_lock_irqsave
>                 native_queued_spin_lock_slowpath
> 
> and:
> 
>     __x64_sys_munmap
>       __vm_munmap
>         ...
>           release_pages
>             folios_put_refs
>               __page_cache_release
>                 folio_lruvec_relock_irqsave
>                   native_queued_spin_lock_slowpath
> 


Yes, this is known problematic. The lruvec locks are gigantic and, despite
the LRU cache in front, they are still problematic. It might be argued that the
current cache is downright useless for populate as it's too small to contain
a significant number of folios. Perhaps worth thinking about, but not trivial
to change given the way things are structured + the way folio batches work.

You should be able to see this on any workload that does lots of page faulting
or population (not dependent on mremap at all, etc)

> 
> 
> It was also found that adding '--mremap-numa' changes the behavior
> substantially:

"assign memory mapped pages to randomly selected NUMA nodes. This is
disabled for systems that do not support NUMA."

so this is just sharding your lock contention across your NUMA nodes (you
have an lruvec per node).

> 
> stress-ng --mremap 8192 --mremap-bytes 4K --timeout 30 --mremap-numa
> --metrics-brief
> 
> mremap 2570798 29.39 8.06 106.23 87466.50 22494.74
> 
> So it's possible that either actual swapping, or the mbind(...,
> MPOL_MF_MOVE) path used by '--mremap-numa', removes most of the excessive
> system time.
> 
> Does this look like a known MM scalability issue around short-lived
> MAP_POPULATE / munmap churn?

Yes. Is this an actual issue on some workload?

-- 
Pedro

