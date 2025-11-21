Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2FD17CFA766
	for <linux-mm@archiver.kernel.org>; Fri, 21 Nov 2025 09:58:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7A7E06B0062; Fri, 21 Nov 2025 04:58:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 758F26B007B; Fri, 21 Nov 2025 04:58:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 66EA86B0088; Fri, 21 Nov 2025 04:58:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 4C8176B0062
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 04:58:10 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id EC0FB130035
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 09:58:08 +0000 (UTC)
X-FDA: 84134163456.08.015E7F7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 4E21B14000A
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 09:58:07 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=zlEarTm1;
	spf=pass (imf23.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763719087;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=p3uSsQviajI5Wcec5YbGA4iSyEYKtu9q8vJRWq/p0fA=;
	b=KiTEo7KxR0V/k0VHqnxigh3yf0UuSOOVIA+IYd9dya8+e+MPoeJEO0k2VU6cb2Gqexbn+6
	TdxmcVgbdfPIcf91Z/Z7Xxg+6JALLXWE5+/sCASgc3EwUt2cGKRDBAtW5uWeziZfhFCEeq
	nNEJ06rW4UJJc1OULLkRi4baalcrsrk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763719087; a=rsa-sha256;
	cv=none;
	b=OYRuRdrnGaspcR4KPZrp/4gnkp4pP81hdmPvKa4sYgtEmHpmO0jrPNKtGM/0lkPDsE9kxk
	FO2oMS759Qnnad5HxlmAOmTF1+yt1OxfU8iKZaHEFfKUHiM4INrXzoz6QyFNI5LaYrIYi6
	dS5QjkYKpWZRucXbhw11qlJO7Cr2kbk=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=zlEarTm1;
	spf=pass (imf23.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 8E9A960239;
	Fri, 21 Nov 2025 09:58:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F207C116D0;
	Fri, 21 Nov 2025 09:58:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763719086;
	bh=wnYxFFffiRTRmegFpJ7WrqdMCOtU3eVKBCCcjthQkhI=;
	h=Subject:To:Cc:From:Date:In-Reply-To:From;
	b=zlEarTm1TNzDWDBIzfoHPLxhxFLKHgHYHi1XrZuc1Oe4mzdIr7JFbL5Ou361GSFpv
	 2/NoFZaDQ+uXUT4V7a9U4wIyzKXo7K2qCveJywVyrWANBHKhCgyJ6haNTVnbAc8geQ
	 W72Imp7qG42k4w+KSGX9qcg2zbuTMLtKM/IObk8I=
Subject: Patch "mm, percpu: do not consider sleepable allocations atomic" has been added to the 6.12-stable tree
To: akpm@linux-foundation.org,chenxinxin@xiaomi.com,cl@linux.com,dennis@kernel.org,fdmanana@suse.com,gregkh@linuxfoundation.org,linux-mm@kvack.org,mambaxin@163.com,mhocko@suse.com,tj@kernel.org,vbabka@suse.cz
Cc: <stable-commits@vger.kernel.org>
From: <gregkh@linuxfoundation.org>
Date: Fri, 21 Nov 2025 10:57:41 +0100
In-Reply-To: <20251117093604.551707-1-mambaxin@163.com>
Message-ID: <2025112141-kettle-handlebar-ee57@gregkh>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-stable: commit
X-Patchwork-Hint: ignore 
X-Stat-Signature: dojg7fib4dg4ucnwxeexdgd89b41huje
X-Rspam-User: 
X-Rspamd-Queue-Id: 4E21B14000A
X-Rspamd-Server: rspam01
X-HE-Tag: 1763719087-875781
X-HE-Meta: U2FsdGVkX19+zArSXJUkUVe4ICyc+uSxLzGxJJPZtRM9krpDIwLatHSzAOG5mplpglyQYwLFsKbBjc79fLeI8gMfMZ9sZH8ZS2MuhrVqv3o0ZDM1BcAwbnvjEMO6dQcumUxStXITesEdjKwWL30Srw6afhJ/ofgdaWcnuhfi1ek5mfsgLX+wgXkp6KM/QknrgZQ4Uu4PVRDN6k6VeOv3ONpk+eJUTrY2nIEZq4KHKWPWUN4Vn6JOlcovM6Ej7H7xmVaXaOpYTeQZcIeHOtjo6Utm8lUkEz6Cx88QoGtOqRpE9GtyeEwVo+zkaojwl2XwAR2YHDncjbd9Ef4w7swyjyAka0HJjj/asRog4LkJeY8nHuBEFt538+yh7So7bsmkt706xB4u2lKyJUfMYdtPJoaDIPK1IX4cBwjuJ6hebDMBbh1YU4f3v25kDQycQ7yrKU3zzGwRGKqkbRAK7VknTmh2XymKtKi3uxqNmW1ZTAwXsBaKIG4eL6T5rY3zDb9Gr9mongVRqzoOUoypvYj/pKWSrocPkvdaij24Lp/JN0gVnAtPl5WLIUTZfBFv6ZmRFUv54uc4MehPEvCdoTz1Qr1CYdX3d45mSGIbEK6jAnXn+EGyI93jO8bCgt/1CjuA2oDZuEgBHRzR2YaOTrDA/Vc6T8KT+p9I60Pn4XAjvgl4UEOR+ikE5eaFeaG/MEQbc14IZpljWUDqbFMD9xCsqabP+ST2HeUBgy0ACZvPs8AVB9b5chZlpmYepwpBm4mbNvbLwNauzL82VExymWA6SGAElkPm3ZtEABcKZx9ZtiRKFEXLia1gkiA7tyXEJIiA7qQNZUuATVDXd+mYw6zHrS5Ps5jllqNLdya2MDuHakqyAZcH07HJ4ygcRqDMoM8zhqaHPDE6tz0PK2Gn/gXxTH8/Hlvf9Ek/EuEgUqSto8DE/4H/qukBZzE/lUdsXgOMilu2NEQlBO+vT8Y0vaq
 W18F7xRh
 ts92DemKlXkY6e+5p9ksVKtKi0L9339RJFoTvz+Tnj3ANtsn/W+ZbsGBfkNTJXCWv9TrK/kx7opFd0mYj89htIwE36XjD4j34t+TnOdWS9RkJpLcxdtf/fCY74QQeOc/75K73gWsmRhPG3SDZTwVi8WBSH2gjvjZtQjHIWu7VE3Az7fWlU5BYW6vKr2kQTTEM/gY4a8lnxnAnrOeUDy/G9amL3GgT2hImbNouPaBHcQggF/g5ZISwoACh2p9rms/FdGxLBHiTdufbMWQ+Y21IUPht2QpjzuDdGvyfLtoVLWcjQuapFGWwwV/FJ0VQQ/Kou7H4na3iBeH9NAvxG8LTLVu8fWQvF8TaSNcDuwvEOWiR0v02KykdX3PBzTy/17+kMyy81CK7xxDV4ifLl/+xfsZtA2/DFlHh+806+qsHgythqka6f1Xe+0VPXYKwt6F1Ez1V3PTQpqQJubEA4UVlR0uDW3kJ080Cy90NWvuFhvbnaHdOacaBo4fip9UxMMzHfdu7X0E6F4MGs0NFbRJGMjA3B74IGeMUJL+d8H3rz5vly4WUCisXJbzY0YLGiV+2DSH87xNCWzMiX9Doc/xlHw/m/urh2ZZe0gtB/R/nQ44ggmR3w6S/0qvtmfiBJR7rQe+Gi1F8jlHKgWTnWZkjTTCyawzs0aMQkURcLXl3oZ6gzon97HQ7jEkkHDDYP2c9cyPFkCLp1mlb7U+3MkE1Og3Ogi6JtAdrwalACaOR5ngFCWs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


This is a note to let you know that I've just added the patch titled

    mm, percpu: do not consider sleepable allocations atomic

to the 6.12-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     mm-percpu-do-not-consider-sleepable-allocations-atomic.patch
and it can be found in the queue-6.12 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


From mambaxin@163.com Mon Nov 17 10:37:01 2025
From: mambaxin@163.com
Date: Mon, 17 Nov 2025 17:36:04 +0800
Subject: mm, percpu: do not consider sleepable allocations atomic
To: dennis@kernel.org, tj@kernel.org, cl@linux.com, akpm@linux-foundation.org, gregkh@linuxfoundation.org, mhocko@suse.com
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org, Vlastimil Babka <vbabka@suse.cz>, Filipe David Manana <fdmanana@suse.com>, chenxin <chenxinxin@xiaomi.com>
Message-ID: <20251117093604.551707-1-mambaxin@163.com>

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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: chenxin <chenxinxin@xiaomi.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/percpu.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -1758,7 +1758,7 @@ void __percpu *pcpu_alloc_noprof(size_t
 	gfp = current_gfp_context(gfp);
 	/* whitelisted flags that can be passed to the backing allocators */
 	pcpu_gfp = gfp & (GFP_KERNEL | __GFP_NORETRY | __GFP_NOWARN);
-	is_atomic = (gfp & GFP_KERNEL) != GFP_KERNEL;
+	is_atomic = !gfpflags_allow_blocking(gfp);
 	do_warn = !(gfp & __GFP_NOWARN);
 
 	/*
@@ -2203,7 +2203,12 @@ static void pcpu_balance_workfn(struct w
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
 
@@ -2214,6 +2219,7 @@ static void pcpu_balance_workfn(struct w
 
 	spin_unlock_irq(&pcpu_lock);
 	mutex_unlock(&pcpu_alloc_mutex);
+	memalloc_noio_restore(flags);
 }
 
 /**


Patches currently in stable-queue which might be from mambaxin@163.com are

queue-6.12/mm-percpu-do-not-consider-sleepable-allocations-atomic.patch

