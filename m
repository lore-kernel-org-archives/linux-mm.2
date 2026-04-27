Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 35944FF8860
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 11:30:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 47E326B0088; Mon, 27 Apr 2026 07:30:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 42EF46B008A; Mon, 27 Apr 2026 07:30:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3445E6B008C; Mon, 27 Apr 2026 07:30:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 1F2BA6B0088
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 07:30:11 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9A4501C00B2
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 11:30:10 +0000 (UTC)
X-FDA: 84704116980.22.EA30F24
Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	by imf12.hostedemail.com (Postfix) with ESMTP id ADE674000F
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 11:30:07 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gondor.apana.org.au header.s=h01 header.b=AAiSRxe+;
	spf=pass (imf12.hostedemail.com: domain of herbert@gondor.apana.org.au designates 180.181.231.80 as permitted sender) smtp.mailfrom=herbert@gondor.apana.org.au;
	dmarc=pass (policy=quarantine) header.from=apana.org.au
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777289409;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qafNQ0xEOY5qhlm+wLT4AEic9YBI56O7zFUIfvV0p/E=;
	b=hGY7HUgllPTlLyweL5SecMFb3KLeSQ/otV8oEaePmQCCPptx2fgeyNI1ANssPW45+2hzGm
	doUd+Oo+xg8FBU8UTFwjUA/h0XcgENKms6wcV0hTfFbZ7lW/bn4vT5uDptyrXZZRjvvP19
	PP6r0imk2FnkXtSgvOIJZVTAmGUKzR0=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gondor.apana.org.au header.s=h01 header.b=AAiSRxe+;
	spf=pass (imf12.hostedemail.com: domain of herbert@gondor.apana.org.au designates 180.181.231.80 as permitted sender) smtp.mailfrom=herbert@gondor.apana.org.au;
	dmarc=pass (policy=quarantine) header.from=apana.org.au
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777289409; a=rsa-sha256;
	cv=none;
	b=MYLEKqj08XmPc+5IFv5fO0JBVSpg/x5oAtQxAKQijSbBuDZ0qumH7tb7epwDPBItDSyzj8
	QjvAAVzB3K/4EEoev3ba6hYkoNifSn3I1BJnEt5xkNv1dMj0E6u7bGr293yS3Gsm9m8u+U
	0aZu92inLNOcQVbB18Yu/GnjNaopeec=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=qafNQ0xEOY5qhlm+wLT4AEic9YBI56O7zFUIfvV0p/E=; 
	b=AAiSRxe+Slb3G7C+CaAuCw0FXEVNvwsBQ5tm+1rxXjTmJezECU9MP+te1CnAd7PwvYGN3H1ZPEO
	d8M6OBgz+KeYafzYp8kC1xPZZ/+UBkxcG14qFJc3ekbqnoiiCt8lbT1q6s+tJ0VFy+W9LcjZLcrMY
	sRV6aAtnbjcvcYxmI882TVG8T/c9UMPgSYYb9lUukuL4vILYND3Z0oSaUIJ9buLtGhnrvH85Es/Lt
	qWv2HYZfGrqE5uLkt5lFjDUD5PDd4sljV7TcfHkBqf57DgNrwtXcV8Xr75pgtcODOorrAP0IOdxqq
	4frAdohppS82LZeOpi1g/pqi+4V3H4piRsig==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1wHKA2-00993v-0I;
	Mon, 27 Apr 2026 19:29:59 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 27 Apr 2026 19:29:58 +0800
Date: Mon, 27 Apr 2026 19:29:58 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Christian Brauner <brauner@kernel.org>
Cc: Thomas Graf <tgraf@suug.ch>, Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
	syzbot+5af806780f38a5fe691f@syzkaller.appspotmail.com,
	Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	"Darrick J . Wong" <djwong@kernel.org>,
	linux-crypto@vger.kernel.org
Subject: Re: [PATCH] rhashtable: give each instance its own lockdep class
Message-ID: <ae9ItoKFvB12Qimn@gondor.apana.org.au>
References: <20260427-work-rhashtable-lockdep-v1-1-f69e8bd91cb2@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260427-work-rhashtable-lockdep-v1-1-f69e8bd91cb2@kernel.org>
X-Rspam-User: 
X-Rspamd-Queue-Id: ADE674000F
X-Rspamd-Server: rspam06
X-Stat-Signature: cop78jjcebnusopznmjbabz6uu6c3u8y
X-HE-Tag: 1777289407-889116
X-HE-Meta: U2FsdGVkX1+DQvLZOAb7JjC/reTuOeUyyYNwSMzIqjNgPwblCsQF402vOz3Lj4KQLgFv/TBTEOYKbbi3tEhGq7hvRObctnF6S5Mdlpp9V9RKGisvSvEkc2qi90hn3QwU5nTXQKjVMhNds5ih0aw3lGI9/a8QFphu+OH5excBbJb3l+A6s1wlEFs3oZY6sI1mD8ItZX1XFqwSfIksnklrBp2ciJZgUrO2tVSzbWQQI0BTXsDkIYaegvsW0sE3FgrkxPuj6PEPkP08IMI+IT/pjCOCXI1gMY3w/prSnZJUi+mH37Nq31qLW86cMi3L8sisdLIgLfV0u/NsTA8Mzc7zUu2griW+mmdKqPgACxm1+m2GinM87nEyJ/UW9F+FAXImL2/5T1ry95twkd6fDjuAhBcfVvWdCBNsUAbalSrxPxtHpiEd5E7XQrwFt3FuoVtFLwYepguM8pA7zOs4w0dyWf3oM8fts2KF6hapCG0W0jrbN1gVNAcXlHXIQjWQeL4ak6YRTOK9k3kc2veSSCGMX7Q9d2yK90uFe2ApTk0SQRLDBnMGB+Gvc0py219DY1Qp0D7RPt3XcFM4HKCBGHohmdngqE3MMjWg8pv6BPR+30Jc5HTwFCLqqrFP8pLiCz4mEFUjZzrdJ7R15VA6m+S73HV4MxAN0JbFcHe7mlv9hIyxT6xhw/8/JUeCoCiBzNUIS4qmUrw/OhFJmXXMMGWJEAyS0a4UfMBpLfqfHEphoQoMiCzWupjib36cyLkDuV9q0i2aF+YQ5VA6py0l8EYEF2/NFBdMJcURNj8lYurkLgxtbyqP1jorSMtl2F3tpti9m6J24oi8FVU45wvKwrPFt7w9+HYaFpFR44lemKUeClk8nXBsM+vxEnLJYQNR7tbpMmHZcOxzmWKjU+l9JyRuOVHJvI5Xxs2E9RYUeKq7MTEcnQEBHHKB7ilzqQIVcO3zF4+Po2E5aYIZTPyarJd
 tcM6k5kw
 MPtitekVQy4IOGlnYrsYjiVJPd0lELR7f5VrBBf4+ysfz8v+gV8NfbPhpox16CG4Cu4OP1pF+1+sSu+a7IXoIe0VmRpCqF1YHgniH216qpOAYvlKS5hZLy3ZKbtodd0X/TKo9zRmsMvroXywBRUXZc5h8gSEQG/ZZC0F9/Elqcd+w7+/HTYAzjjupfHsC4wxQMC5FMIDbYw6n4Fv7XUJaqCi1c1Apbp57Ny7gZOxqTArcw8ipFhuB5SfzPfak/a+dx7NhPlRMYla8EejO0597jy9XmLW5XkJFHiMaiprLs4B/LEVmXaw7kRpDYHgbRlpBtJPYgNOd/7iRynu1JUqKfkGvCBUzlDfn04Fjdy0Ra7XcXuT8ywhtB7FIcJ+EJotXTjfjNzH3xWgYLwssLh+Qf4JK7t3l6klMuiimZiLbscSp4NrlatNBpJxZRXdNej+VXLFzuBiNQeyKRdOQe8tmMsjNvKuydZiSC2nxgc1SIEdmteqjkFcHZgSBHsspVafZR85jZ7aqiIaKnQE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Apr 27, 2026 at 01:09:57PM +0200, Christian Brauner wrote:
> syzbot reported a possible circular locking dependency between
> &ht->mutex and fs_reclaim:
> 
>   CPU0 (kswapd0)                    CPU1 (kworker)
>   --------------                    --------------
>   fs_reclaim                        ht->mutex
>     shmem_evict_inode                 rhashtable_rehash_alloc
>       simple_xattrs_free                bucket_table_alloc(GFP_KERNEL)
>         rhashtable_free_and_destroy       __kvmalloc_node
>           mutex_lock(&ht->mutex)            might_alloc -> fs_reclaim
> 
> The two halves of the splat refer to two different events on
> &ht->mutex.
> 
> The kswapd0 path is unambiguous: shmem_evict_inode at mm/shmem.c:1429
> calls simple_xattrs_free(), which calls rhashtable_free_and_destroy()
> on the per-inode simple_xattrs rhashtable being torn down with the
> inode.
> 
> The previously-recorded ht->mutex -> fs_reclaim edge comes from
> rht_deferred_worker -> rhashtable_rehash_alloc ->
> bucket_table_alloc(GFP_KERNEL) -> __kvmalloc_node ->
> might_alloc -> fs_reclaim. That stack stops at generic library code:
> there is no subsystem-specific frame above rht_deferred_worker, so
> the splat does not identify which rhashtable's worker recorded the
> edge -- only that some rhashtable in the system did.
> 
> Whether or not that recording happened on the same simple_xattrs ht
> that is now being destroyed, the predicted deadlock cannot occur:
> rhashtable_free_and_destroy() does cancel_work_sync(&ht->run_work)
> before taking ht->mutex, so the deferred worker cannot be running on
> the instance being torn down. If the recording was on a different
> rhashtable instance, the two ht->mutex acquisitions are on distinct
> mutex objects and cannot deadlock either.
> 
> Lockdep flags a cycle regardless because mutex_init(&ht->mutex) lives
> on a single source line in rhashtable_init_noprof(), so every
> ht->mutex in the kernel shares one static lockdep class. Lockdep
> matches by class, not by instance, and collapses all of these into
> one node.
> 
> Lift the lockdep key out of rhashtable_init_noprof() and into the
> caller. The user-visible rhashtable_init_noprof() /
> rhltable_init_noprof() identifiers become macros that declare a
> per-call-site static lock_class_key.
> 
> Reported-by: syzbot+5af806780f38a5fe691f@syzkaller.appspotmail.com
> Closes: https://lore.kernel.org/69e798fe.050a0220.24bfd3.0032.GAE@google.com
> Signed-off-by: Christian Brauner <brauner@kernel.org>
> ---
>  include/linux/rhashtable-types.h | 22 ++++++++++++++++++----
>  lib/rhashtable.c                 | 17 ++++++++++-------
>  2 files changed, 28 insertions(+), 11 deletions(-)

Thanks for the patch.

But could you please try this patch and see if it also fixes
your problem?

https://patchwork.kernel.org/project/linux-crypto/patch/20260422213349.1345098-2-mikhail.v.gavrilov@gmail.com/

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

