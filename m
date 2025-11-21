Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 98AAECFA76C
	for <linux-mm@archiver.kernel.org>; Fri, 21 Nov 2025 10:15:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F210F6B0028; Fri, 21 Nov 2025 05:15:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ED17F6B002E; Fri, 21 Nov 2025 05:15:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E0E606B00A2; Fri, 21 Nov 2025 05:15:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id CE1906B0028
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 05:15:31 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7AC4C4DAF9
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 10:15:31 +0000 (UTC)
X-FDA: 84134207262.09.2069F78
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id A5A551A0008
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 10:15:29 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=ApJRgqOo;
	spf=pass (imf19.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763720129;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=MT8eVZBoyeK8TutawHJm21yh1Xc0EZm5T3y3L+Zky/4=;
	b=N5fRb3zx3hPAqLe/mm1QpVuPsLUbc+/8T9JZ+4ODIW1zwyeO1cVVVAlFSfm58Ctm0z2yv+
	8XvjspAqbht1HzvruWT28Xe2mXnM3Le3IOUU669NTA6nwuI7c11okJHuF8H/Yqh3HqPOUp
	HjBPQZP5IzyZU0Ln6pgj2QdqKqDFKaw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763720129; a=rsa-sha256;
	cv=none;
	b=H86ib9vUAeVCKY8Vy8rliIIUwOMXBZ1VpZNSQ6aSlw7klJcSKBC1fSaeOL7FTGcgh1liso
	1ixGPB2IOlWT85HazaBEaJHljs5MGOz9vySmvDbcPwdeI+C53VCs2JaBO+YTs7s6CYdJ0A
	M7LDphWwBjfGJQWnvBnW0+0hHBT7KmE=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=ApJRgqOo;
	spf=pass (imf19.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B87BE439C5;
	Fri, 21 Nov 2025 10:15:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35DADC4CEF1;
	Fri, 21 Nov 2025 10:15:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763720128;
	bh=+lOvK5Gef3aWIdihyE3CvtYqrG7U5mJvM07HnZGdpw8=;
	h=Subject:To:Cc:From:Date:In-Reply-To:From;
	b=ApJRgqOodTIbFXJch1ISnI79QIjOyIb30+sIMhKRAX8Z3w2RdnE+Qf8h30GtnTpcm
	 yDgWqqtHBMisq7tlOTO/Yoo2l4kufDKAAa3VlM3RnfNAB1OdOp7K/HQBk72/9jcJ9Z
	 /IURnUgsZUNNWpAjmfQnn80u7p9HZdCkD2pALNhc=
Subject: Patch "mm, percpu: do not consider sleepable allocations atomic" has been added to the 6.1-stable tree
To: akpm@linux-foundation.org,chenxinxin@xiaomi.com,cl@linux.com,dennis@kernel.org,fdmanana@suse.com,gregkh@linuxfoundation.org,linux-mm@kvack.org,mambaxin@163.com,mhocko@suse.com,tj@kernel.org,vbabka@suse.cz
Cc: <stable-commits@vger.kernel.org>
From: <gregkh@linuxfoundation.org>
Date: Fri, 21 Nov 2025 11:15:15 +0100
In-Reply-To: <20251117085922.508060-1-mambaxin@163.com>
Message-ID: <2025112115-stoppage-sulfite-1700@gregkh>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-stable: commit
X-Patchwork-Hint: ignore 
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: A5A551A0008
X-Stat-Signature: dboe54iyg4a7exjqjbouhanr47rxgeqd
X-HE-Tag: 1763720129-206587
X-HE-Meta: U2FsdGVkX18EsWlZ1w+fYDaKTd5TiD5osq53Hb/f1vRnXeTYYX7/GxXV+KU/Y3jyRVCah8W/4Ls9HhQqGydcMSf4uHsUEaVlN1eu25lYQvOdv/F/34JZoVSb94FOY+XPlpZZl29EG+Au8Wmnq0m00aUXDnuXxN8v7KF2qn9XRcW8o273o/IWBuECYxUZNqloq+LiMMKrXihIHIIx0Uw2thk57PE57J0u/LWfBBghnTGcztCOv42reJCE9vHzlktJJ+ZbZyrHaVAYEM3bM2V9xeFZU5EIYCVEvFQpcQUCxQf/js2vo9hlL/eHWQjTcMRKCNAsWDOWoYSAM31VIItp9FgpMNSe4wtWWXkp+2KKjFzaCelV22+lA0OItsRo2M9ooW96z3qyc8Ni0RBVlVdxgb1H22vJPHaVCWzZVSZ907FRuvqDt6SZecoNsbMksC7pgoFk8af5V8T+lf4DNYmaWjtslvbFO/KXllnNvxDOKT3uhSV/Wg9j8LVvCRhTJRI0szEiTeS0CQHAYFQRbcFIZ5Cj63o/av2gP/TNP2/sY94eyKhMq9lS7DAbwCvFn7uMTTjcNzIM5g8jnrSw1UVnVw1y9qZaEXVFX8kzYuV4Z6kufxhP+HfaODv9qM7eMEV0tOtWKgNe9SIzTneLH7ESq4HxExngjwDZp2nR8USHEbPa6h378mKb7KJYDcWaPKG6mmmRAbY5XUO9rhxIeJQ5Hqt+vU0ZUdiv6N7IKRSk5BPgdKGDbRQKQJM0TPmBFZRcOD/nvn0ShRvTCwAUoPlTD7tSxW6Kc9P6oATEQPcOEfagRbumHOE3o9piUGkvZ0ezQjs/yaPuHuJRYjtqLGBLu9UFP+tEn5z0JDgAiJ+DffXdoA5HeqEDKjlY3rP8ecX+b6jHEt0kMsvpUkiImCt0+wnT3rNvtRodZ7Sy2Mh+GLffk8qIL/igWF7supZHFG8wKxAKjITaDxUCBv9azu7
 ZCX3KJvZ
 U9GqOxM6btN+pwuiWYavdVE1quxDQ3zXB4F+u0+k2XdQXzIi2EAVf4sOMqCL6I6sglaDNcDWbaUlE+GjqMm7mfBKsM8KAdZo2c6l5L6fanx28BeMl2NFq+ym14PpX0/1ouLY4YFc74Qfv37BydTjiE0k6s6fTohJc5sVx4jqppUY4j3DV8/McXlNelLlWPIp93Ph7b/gs1OozjdtpfUaa4fyRRNvrFetEGHmdCD9sov6SixLn1vzmn+DLp9hJTyOU5QNHRraL+T6ibAv3gPkCu8vDNq/w0RA7fAE1hF2A4JPvmuf1KMZdS1Xd1SomaXIdvq21Dh5scqxFUpvXMQvpYucz/EW66fQbJyyLr5ky4gp5OM5SpTO6N7pn+pliFV1P1LqBeRjhoQn1gUp4LY7lHT7MFhSA7RyDd+kylRsTgaZOJzEQljA9dAPGpph8QS5ubab7BZUkKBMGn8P9f7XrSK/KecMG+rhvPjwzCmIZx22Xw3lYjfGZkieDXVGeRjmPydrweT6GFB6q5mV+2Q5Cr6X9Zl0HW+edsmKyFTwlBmkkhj9aLAORhga9rC2DkMaO7GfIInYRK1zv9ZTGr2QBEOeRyazL2ydD5PVBGn3eOhH5RVxujgccNFbZNFCUjWkjb/7gxvPzZ3woB+vX0fYMn4Kl2FJe91j88Ig7ExtrRLJYkrF8sbZj6cXQenEw3+zhjmGgUOVC12SbPqi7O4rOf1uMSBsUREkzcRMFrZYRhPXv8EI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


This is a note to let you know that I've just added the patch titled

    mm, percpu: do not consider sleepable allocations atomic

to the 6.1-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     mm-percpu-do-not-consider-sleepable-allocations-atomic.patch
and it can be found in the queue-6.1 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


From stable+bounces-194937-greg=kroah.com@vger.kernel.org Mon Nov 17 10:02:24 2025
From: mambaxin@163.com
Date: Mon, 17 Nov 2025 16:59:22 +0800
Subject: mm, percpu: do not consider sleepable allocations atomic
To: dennis@kernel.org, tj@kernel.org, cl@linux.com, akpm@linux-foundation.org
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org, mhocko@suse.com, Vlastimil Babka <vbabka@suse.cz>, Filipe David Manana <fdmanana@suse.com>, chenxin <chenxinxin@xiaomi.com>
Message-ID: <20251117085922.508060-1-mambaxin@163.com>

From: Michal Hocko <mhocko@suse.com>

[ Upstream commit 9a5b183941b52f84c0f9e5f27ce44e99318c9e0f ]

28307d938fb2 ("percpu: make pcpu_alloc() aware of current gfp context")
has fixed a reclaim recursion for scoped GFP_NOFS context.  It has done
that by avoiding taking pcpu_alloc_mutex.  This is a correct solution as
the worker context with full GFP_KERNEL allocation/reclaim power and which
is using the same lock cannot block the NOFS pcpu_alloc caller.

On the other hand this is a very conservative approach that could lead to
failures because pcpu_alloc lockless implementation is quite limited.

We have a bug report about premature failures when scsi array of 193
devices is scanned.  Sometimes (not consistently) the scanning aborts
because the iscsid daemon fails to create the queue for a random scsi
device during the scan.  iscsid itself is running with PR_SET_IO_FLUSHER
set so all allocations from this process context are GFP_NOIO.  This in
turn makes any pcpu_alloc lockless (without pcpu_alloc_mutex) which leads
to pre-mature failures.

It has turned out that iscsid has worked around this by dropping
PR_SET_IO_FLUSHER (https://github.com/open-iscsi/open-iscsi/pull/382) when
scanning host.  But we can do better in this case on the kernel side and
use pcpu_alloc_mutex for NOIO resp.  NOFS constrained allocation scopes
too.  We just need the WQ worker to never trigger IO/FS reclaim.  Achieve
that by enforcing scoped GFP_NOIO for the whole execution of
pcpu_balance_workfn (this will imply NOFS constrain as well).  This will
remove the dependency chain and preserve the full allocation power of the
pcpu_alloc call.

While at it make is_atomic really test for blockable allocations.

Link: https://lkml.kernel.org/r/20250206122633.167896-1-mhocko@kernel.org
Fixes: 28307d938fb2 ("percpu: make pcpu_alloc() aware of current gfp context")
Signed-off-by: Michal Hocko <mhocko@suse.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: Filipe David Manana <fdmanana@suse.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: chenxin <chenxinxin@xiaomi.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/percpu.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -1737,7 +1737,7 @@ static void __percpu *pcpu_alloc(size_t
 	gfp = current_gfp_context(gfp);
 	/* whitelisted flags that can be passed to the backing allocators */
 	pcpu_gfp = gfp & (GFP_KERNEL | __GFP_NORETRY | __GFP_NOWARN);
-	is_atomic = (gfp & GFP_KERNEL) != GFP_KERNEL;
+	is_atomic = !gfpflags_allow_blocking(gfp);
 	do_warn = !(gfp & __GFP_NOWARN);
 
 	/*
@@ -2237,7 +2237,12 @@ static void pcpu_balance_workfn(struct w
 	 * to grow other chunks.  This then gives pcpu_reclaim_populated() time
 	 * to move fully free chunks to the active list to be freed if
 	 * appropriate.
+	 *
+	 * Enforce GFP_NOIO allocations because we have pcpu_alloc users
+	 * constrained to GFP_NOIO/NOFS contexts and they could form lock
+	 * dependency through pcpu_alloc_mutex
 	 */
+	unsigned int flags = memalloc_noio_save();
 	mutex_lock(&pcpu_alloc_mutex);
 	spin_lock_irq(&pcpu_lock);
 
@@ -2248,6 +2253,7 @@ static void pcpu_balance_workfn(struct w
 
 	spin_unlock_irq(&pcpu_lock);
 	mutex_unlock(&pcpu_alloc_mutex);
+	memalloc_noio_restore(flags);
 }
 
 /**


Patches currently in stable-queue which might be from mambaxin@163.com are

queue-6.1/mm-percpu-do-not-consider-sleepable-allocations-atomic.patch

