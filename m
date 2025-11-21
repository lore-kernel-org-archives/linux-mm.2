Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B0C60CFA76B
	for <linux-mm@archiver.kernel.org>; Fri, 21 Nov 2025 10:07:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E4D486B000A; Fri, 21 Nov 2025 05:07:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E24B36B0088; Fri, 21 Nov 2025 05:07:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D61756B008C; Fri, 21 Nov 2025 05:07:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C290B6B000A
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 05:07:02 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 76D0B13B322
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 10:07:02 +0000 (UTC)
X-FDA: 84134185884.22.ED66012
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id D0A00180005
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 10:07:00 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=2TaCtuuA;
	spf=pass (imf24.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763719620;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=Xxm0FqYsCPxjMJq/u2TJGbNdPHQbW2wmjgkyiCtumt8=;
	b=P3vk83L3QgECndrmeNF/LkGUb7DHsMAujpqxw2CjYCIAjKM9X8CPywNnve8z6/w1n9S8U0
	laMHb/hyWo6GLEVIsXmYTcTGABJR4wTWDVlswEGOF8XFATrCe0aexwUkFvtf61H4b/PE1U
	yZmz5CF3JAtwRr8vhjj7wFobiYZJOjw=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=2TaCtuuA;
	spf=pass (imf24.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763719620; a=rsa-sha256;
	cv=none;
	b=KSNU2S3z7Nhef3M46az7H3on2UTu4IV2HmmZHTbv1G+5bljIU7d+R4Ho1xmprKvxgSipnk
	8hERbeg4Tn5rvr3Duv+/Bpb+yRnyYJQVUBW+hl5kIXSXG+ybrYEIbF8NmBhXYhF6ml5wNT
	FoAqRwyLiSz9IAcKzBN3s5RrjaQXK0E=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 5126160232;
	Fri, 21 Nov 2025 10:07:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0295C4CEF1;
	Fri, 21 Nov 2025 10:06:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763719620;
	bh=onsZhPB7qEHvClhLPQIXSIwttEViaP3QujfHVQuBohw=;
	h=Subject:To:Cc:From:Date:In-Reply-To:From;
	b=2TaCtuuAbBNM8FB/3nnNVlB6W3BHpLQE9XT5oDFi/U6ttNaCY8hUiDMgGXHf622nK
	 Yf3GUJi7+ntWnA3jyL0BcDl63z9T67ioeVK5sbjzmkmOPZ8HiTmqxN4Vlms/RfkCyZ
	 AU+piMnr4bgjfy/YT5H9UD90WSTYmHsB0uP88YD8=
Subject: Patch "mm, percpu: do not consider sleepable allocations atomic" has been added to the 6.6-stable tree
To: akpm@linux-foundation.org,chenxinxin@xiaomi.com,cl@linux.com,dennis@kernel.org,fdmanana@suse.com,gregkh@linuxfoundation.org,linux-mm@kvack.org,mambaxin@163.com,mhocko@suse.com,tj@kernel.org,vbabka@suse.cz
Cc: <stable-commits@vger.kernel.org>
From: <gregkh@linuxfoundation.org>
Date: Fri, 21 Nov 2025 11:06:40 +0100
In-Reply-To: <20251117093013.545253-1-mambaxin@163.com>
Message-ID: <2025112140-charcoal-buffed-97bf@gregkh>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-stable: commit
X-Patchwork-Hint: ignore 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: D0A00180005
X-Stat-Signature: cscfznos7ispcifdypc5dsfi5et36ii9
X-Rspam-User: 
X-HE-Tag: 1763719620-512984
X-HE-Meta: U2FsdGVkX18guoS23Zq560y9rP3Kk6+bmuW6g87KBx1o9vibgnL1ZAvACzywalSNccr5tZUc7nRQEg8jOLv4CtfMzuzv/QGoUbTrxIkWmZFWxn27MPM3Io2v5TwCmU0LxfegIMfVnQkDTI4fULvp4VeyIB3sjHhPHp/2gYTfYIVqQ6cSFkREiPMyhC3P0JL0q8VcgxL2qCdGoR8ZeEMB8zBGTrGfVZFGKgz7+HZyPxMcqHeMRKSGVuzrj69zJ+TQ0wrE4Prhq0IuNC8kIGWuy6ZkgE46KNM/JZHfRpJJLuzpFMHeEWdDxjq/3C8Y5kkGolEDWWP3JRNDfvWMp+ei0XaTpTbLKELQB+X6o8Z7YZKvRCKUWMaOOuufZJmuNH1srQ0saalHeuzvOwPBGGiIhHK9jY1WmfLi9CZKMjaIRRj7PHYfRx83sQTx4dY65qvAzEBB0j2qG5nio2kpjk9JXKJo0VUlfeqN8KfVvhp2r9pogiYHnL+5d5FV0b410Zof1WVw1ZSJ/r1dS7To/p4JNbFhh1IShzmWq2L5hPfqu+AljcJxD/uCrSPf44LB935e1+Oqkp6/6dx9g9+SR+ksEHX7JdXdLeZ0mOeBVpIoG7WISAfly/RLm3V2gg3n5MJLf0vBcgwC1rODwQzdk0xkrJvXA6I0yEy1FCpeaUJHW5wguXDdybxg65ZYtbf6F1MH2rySXGaFPqQlQPKIooliFAWiwGCeGys4n/ckH0i1H5vr5elic3yp0jzq8CDbqmSGKj1C7iCHvi3ZAkqb/fDgb7oiq+lvQKJGP59gD28KwI1YtUNnapHnynCVwdursQukVKf8neMUx7+F6oLqUlq79s2iVcHZO1yJqSJ8d42ec8sw57YsaKtWpNmmfqLWMoULTIA7zgTQbfnmn1xmUncrFft/wftIuV166D/s3yhpFhQIQN3ygsy0BR39D9iSHuHCCKFddSLRq+VxjOYRiX0
 4blFT6ZI
 mlUd96/z7ilHYZgiUmsPZt5HdL88fBQQ6X//HcnFc3FEFYVKalj/ABqvaTvW5oomri8X+/6o3TEKAvp5G227dhH4s7wEsNguMVTpo0CmDvHki35u/suUhdWGn1AJHVYCORAw1eG0vlKT9hurzwOIyYFCia8i9NAj3ai+oFU1XyVeRm6rQcp2QZkC8dd+WuZh+aPPp9OVjAJOwUYAhxwJ8XXSzZzBTtzLZYuLlui/aWMQVEVjvpJqxVyYkizMLNsVlP13ArwiQkTBzVl5PlxNZY6DlG2mukRmMrMZONmB0rjC8RuzD5DUZTrt217MkhrWTeMJ6fZ1C8MfIPpblqwhzfjTUGPg12/TYQPwi52cDpD1sO0e4wwNy3EK3HqqFqJcKIukj2Sf1F/GCUIo3ALB7wUXjDkrPm9TgjqrcANyRfEh9E7BRTpjNUEqmw+tVPoHD4OFLgyLFAxuIxrZT+wVgMrXRLzl+ufMcY/A/sV7djlnIOrf6t4E13U5LJGHCp7lqZLf59JmnIQCNJX/2hO97HAYRwNEdxhRnd+rjogr0JIP6qJ7iUHHzR1TP2XgzBveUTB6pRh38ZftVL7WLt2zkJGDhEOECbW/IKeABIC2y+keztyioxK+J4N7SSEpaoahEx7IKbZMM2Zh7JRXOi0utb482DK7IR6o8xC+VL2f+5RIu5b07VltYukjluaWgOQkfzv4S3nW9MCpv6xBDSg3CR4GsGSw5o81X4payqr1FanlZ0a0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


This is a note to let you know that I've just added the patch titled

    mm, percpu: do not consider sleepable allocations atomic

to the 6.6-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     mm-percpu-do-not-consider-sleepable-allocations-atomic.patch
and it can be found in the queue-6.6 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


From stable+bounces-194942-greg=kroah.com@vger.kernel.org Mon Nov 17 10:31:20 2025
From: mambaxin@163.com
Date: Mon, 17 Nov 2025 17:30:13 +0800
Subject: mm, percpu: do not consider sleepable allocations atomic
To: dennis@kernel.org, tj@kernel.org, cl@linux.com, akpm@linux-foundation.org, gregkh@linuxfoundation.org, mhocko@suse.com
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org, Vlastimil Babka <vbabka@suse.cz>, Filipe David Manana <fdmanana@suse.com>, chenxin <chenxinxin@xiaomi.com>
Message-ID: <20251117093013.545253-1-mambaxin@163.com>

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
@@ -1734,7 +1734,7 @@ static void __percpu *pcpu_alloc(size_t
 	gfp = current_gfp_context(gfp);
 	/* whitelisted flags that can be passed to the backing allocators */
 	pcpu_gfp = gfp & (GFP_KERNEL | __GFP_NORETRY | __GFP_NOWARN);
-	is_atomic = (gfp & GFP_KERNEL) != GFP_KERNEL;
+	is_atomic = !gfpflags_allow_blocking(gfp);
 	do_warn = !(gfp & __GFP_NOWARN);
 
 	/*
@@ -2231,7 +2231,12 @@ static void pcpu_balance_workfn(struct w
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
 
@@ -2242,6 +2247,7 @@ static void pcpu_balance_workfn(struct w
 
 	spin_unlock_irq(&pcpu_lock);
 	mutex_unlock(&pcpu_alloc_mutex);
+	memalloc_noio_restore(flags);
 }
 
 /**


Patches currently in stable-queue which might be from mambaxin@163.com are

queue-6.6/mm-percpu-do-not-consider-sleepable-allocations-atomic.patch

