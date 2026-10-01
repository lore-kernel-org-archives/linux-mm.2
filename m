Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C24B0CA5FD4
	for <linux-mm@archiver.kernel.org>; Thu,  1 Oct 2026 15:43:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A51186B0093; Thu,  1 Oct 2026 11:43:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A021E6B0096; Thu,  1 Oct 2026 11:43:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 93F536B0098; Thu,  1 Oct 2026 11:43:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 70D956B0093
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 11:43:44 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E783FC0452
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 15:43:43 +0000 (UTC)
X-FDA: 85274477526.06.67316BB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 50F284000A
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 15:43:42 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="bl7lRu/y";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of kaloz@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kaloz@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790869422;
	b=DgtneRIarJcaTygfPOaCjGVYBb9FgEGL8NVmeMRBXUp6iNcfh6HjDlA1IlqgCTt4XR9fZK
	vlBvUrSXimt1IWe1CdOly0qKfnNUp6YwzmlQIV86+toWBSWPOKxBBQKn4maC6FmdFasdLK
	1DPF2jljhlcJkaGOnQMAa1X4q5gmCOA=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="bl7lRu/y";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of kaloz@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kaloz@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790869422;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lIp0N9ETA3Ja1lXBntUo6INabFxn7mCNqP7rfPsOXFQ=;
	b=bRy3eRjqyeo1jAGuRGxS0Tc2akK8ungRQxEFN0SxXnng/UgZ1Wgs3vpPGFKupAwobjsfGc
	B4xxmHgxhSkXU6GWQpoyd8wy3jKKB/6Fyd9ipbqPDqQZzszbJjN9tOuGj/ymxf4sxkiPYB
	NNnjhUwLwkoCsEPLV/n/BThION9yhy8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9B8C760A7A;
	Thu,  1 Oct 2026 15:43:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E2D21F008A7;
	Thu,  1 Oct 2026 15:43:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790869421;
	bh=lIp0N9ETA3Ja1lXBntUo6INabFxn7mCNqP7rfPsOXFQ=;
	h=Date:From:To:cc:Subject:In-Reply-To:References;
	b=bl7lRu/yIaxzsQ4nzU+OP+SPRjQnX6mk5j5X7Ft7Ob3u1RwRuDJS0GiMDVn/k3+vO
	 u0HIi3vLEMcgEdS5UrvmMZBFGaC6F34HMXVf/JnKpSXrnct6KSM0lPmmck3WbIpi+c
	 /mYxdOy98oklfeGmVuxMIraEjH/7/eLvfZG6yvz9cIxe+V/pyVZ0aIzMvFiK1iEWG9
	 PT7Ms/4wbxfi9kmAaFSlSJFFyQlJGYr33piDKPlitAOYh+iWv+8Og4udaKPkHsYF7z
	 coJL01mH+7EYIfe4nS6Xv4ihfMRg9dQWTtMI2yMJ9852DrKOSu6qxHLBq36EYNoOau
	 6hyA0ejP0z0Bg==
Date: Thu, 1 Oct 2026 17:42:36 +0200 (CEST)
From: Imre Kaloz <kaloz@kernel.org>
To: Harry Yoo <harry@kernel.org>
cc: Vlastimil Babka <vbabka@kernel.org>, 
    Andrew Morton <akpm@linux-foundation.org>, Hao Li <hao.li@linux.dev>, 
    Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
    Roman Gushchin <roman.gushchin@linux.dev>, Jann Horn <jannh@google.com>, 
    linux-mm@kvack.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] mm/slab: sample slab_state once in
 kmem_cache_destroy()
In-Reply-To: <ar5pESlkEMqNsgxv@thinkstation>
Message-ID: <aef97b97-0bd7-d720-7f59-8c0078747370@kernel.org>
References: <20260930195110.13296-1-kaloz@kernel.org> <ar5pESlkEMqNsgxv@thinkstation>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
X-Rspamd-Server: rspam06
X-Stat-Signature: ib7ikcxcytrmktmu89rcd7uk9pewcw1g
X-Rspam-User: 
X-Rspamd-Queue-Id: 50F284000A
X-HE-Tag: 1790869422-740556
X-HE-Meta: U2FsdGVkX18LlOywlvemfxW+taqw/lSkLWkIllidAA/vTK8T6NT7vdTaPdym6RQg6vtkbGIoKwOUVIAzGCFlWdawrzRmEjCryhsi1fPrPnxLek/pW0g4JISEqQXtHqLVaehFVhPNiSKMwbr4QYmUw/cSmIZlCBSIHS3hZE1e84sKUjG2Xaz5t+yuKExL/d6luWzh9HaQ5rMJmxjFdGTby84FWIEPy7+HLlJdwCtcot9qyKZpbuSnAr0DUKUx48Db4hzcfjkfEEsmQCBHCu+pSD9UvbYagpzwlMV9rNLtxCh3dyg4RMjKwHM3gkIIdHEYa2Tug690cufxKg54YGsU1kBeJNicEBgcYvWI/iqaLsLFRISlFwAuZNzrBEBP399VhNVjrNa9O99xIXcY8jSmGbGiWfvt+RzDhZtT0UDEPaFanfKmGgCb91W2NjqbIlqXLAEPc2fbb+st4CRp0riBJfzMjEg5JZbvzeVE8kp8VQP2s3z9Ab4I04RNWPR4I2L7EnvnEkSdwA6RCYpegybPb4ipkCXk9bgVqHCY1dkNoAPzgTtLl08jljfKzTFjywOwi+tjYqg6aRASb6iA2DRl/LEPmhAjWxO0b9cFIvBblqIXCA6W1i1wyNbkSQRa7QpI9LexrhNAUPtrulmXlso0iuVPgplF8gllOnp9jEcnD5xBr0Ygl/5v3/XJllKwnbR7myFKtCGF6sOXAVoUsQ3Qwcnsldw0qQiW2a22GBQs7fWhjk+6yZGHZdnYDOb5/eRs1vI2sxhsoy9BT7cdVkkO9IDEwJSpG59UAYo6ypF5NK3VNcrCiT6WtsUIAJz1gso/QzzhSOk6Ns4fGV0/BErcJtMyU1aMuLLyLrNiUx4SgFCoEKDFsQO0bNSaGvViVBawzeBrQQxkxRDiHUWUVSnra53PTt+u7/jeu+lY73HmnQEeal3eYjrxYxknWVqRbarZfYPSnERZLFqEFnoYue3
 gg1bIQnW
 Xep8EHTYyKwSCjD5kzCaNIJHtcGKj7AeRKHCy+IIPOPAg9uYdRGmI9vEBQoTqzj6K+9DMEWoyEVtyR2yLdC445c7ViShRwwmnxU1vSD/Hherbfspxlb3sIxI6b5RALGgZyny/2o1DJ/SD5h8Y1mJNwmV3uSyZx0fOnvgXuRhLPkerQxzCGSvlzG7YpyLkqvkT9AmXGWDhBoD81e+IgdbTY0I5z9wbQX01xOmu/KaRsrXKuCPkAibYRVsnJIgSJfM7RuoEfpNiZfLKXyqdgYlZK1Eio2g/SCyL0u6qVP7p6pJaQGs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Harry,

On Thu, 1 Oct 2026, Harry Yoo wrote:

> Hi Imre,
> Thanks for catching and fixing this!
>
> On Wed, Sep 30, 2026 at 09:51:09PM +0200, Imre Kaloz wrote:
>> kmem_cache_destroy() tests slab_state >= FULL for sysfs_slab_unlink()
>> and again in kmem_cache_release() for sysfs_slab_release(), with the
>> cache already off slab_caches in between. If slab_late_init() runs in
>> that gap it sets slab_state to FULL but never calls sysfs_slab_add() for
>> the unlinked cache, so kmem_cache_release() ends up in kobject_put() on
>> a kobject that was never initialized:
>>
>>   WARNING: lib/kobject.c:734 at kobject_put+0x64/0x2c0, CPU#1: kworker/u8:3/55
>>   kobject: '(null)' ((____ptrval____)): is not initialized, yet kobject_put() is being called.
>>   refcount_t: underflow; use-after-free.
>>   kobject_put+0x64/0x2c0
>>   sysfs_slab_release+0xc/0x20
>>   kmem_cache_destroy+0x104/0x1e0
>>   bioset_exit+0x13c/0x1e0
>>   disk_release+0x54/0x140
>>   put_disk+0x18/0x40
>>   floppy_async_init+0xbec/0xd10
>>
>> Seen on sparc64 at boot, where the asynchronous floppy init tears down
>> its bio slab while the late initcalls are running.
>>
>> Read slab_state once, under slab_mutex which slab_late_init() holds when
>> it sets FULL, and use the result for both the unlink and the release.
>> The kobject flags (state_initialized, state_in_sysfs) were considered as
>> the key instead, but slab_state is what cache creation and
>> slab_late_init() decide on.
>>
>> debugfs_slab_release() is not part of the race: it only looks the cache
>> up by name in the debugfs root and does nothing before that root exists.
>>
>> Fixes: 4ec10268ed98 ("mm, slab: unlink slabinfo, sysfs and debugfs immediately")
>
> Overall looks good to me, but could you please explain why it's
> not relevant before this commit? pre-4ec10268 still reads slab_state
> outside slab_mutex.
>

The outside-mutex read is older, yes. What 4ec10268ed98 changed is that
unlink and release no longer share it.

Before that commit, kmem_cache_release() did one test and used it for
both:

     if (slab_state >= FULL) {
         sysfs_slab_unlink(s);
         sysfs_slab_release(s);
     } else {
         slab_kmem_cache_release(s);
     }

So the two could not disagree. 4ec10268 moved sysfs_slab_unlink() into
kmem_cache_destroy(), after list_del() and after dropping slab_mutex,
and left a second slab_state test in kmem_cache_release() for
sysfs_slab_release(). The cache is already off slab_caches in between.

That is the window in the warning: the first test sees < FULL, so the
kobject is never linked; slab_late_init() then sets FULL under
slab_mutex and calls sysfs_slab_add() only for caches still on the
list; the second test sees FULL and kobject_put()s a kobject that
kobject_init() never ran on.

A single read cannot produce that split decision, which is why Fixes:
points at 4ec10268ed98.

There is a related older window: after list_del() and before that
single read, slab_sysfs_init() could set FULL, skip this cache, and
the single read would then call both unlink and release on an
uninitialized kobject. I have not hit that, and this patch does not
close it.


Best,
Imre

