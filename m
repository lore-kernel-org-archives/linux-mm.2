Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D44BBEA4E21
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 15:16:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 303D96B0098; Mon,  2 Mar 2026 10:16:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 29ABE6B0099; Mon,  2 Mar 2026 10:16:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 15BFA6B009B; Mon,  2 Mar 2026 10:16:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 033156B0098
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 10:16:01 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id AB45E1A01D9
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 15:16:00 +0000 (UTC)
X-FDA: 84501473280.19.1ED0C55
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 090FC1A0018
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 15:15:58 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="UuShyuh/";
	spf=pass (imf19.hostedemail.com: domain of sashal@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772464559;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=795qb2XPmTikXRuI9wWh/wmdX65Q+l1P/vz+K2y8gWw=;
	b=8EgVw60WoAIlpL2I89BS20Yrhgmz/xaUXVnSSnqXBk+MQ+qf4RjWYGxmMQJSEsUoPjYge5
	PTSDhMJPDF8JcSjgdsmTs5LkLc92Z7FzbuUiM3xDUBelykSzRlo5Ti+4svOJqVRiWr3iZW
	iVlWQDvNtOS0GHblw/JCB3kaPNuGKso=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772464559; a=rsa-sha256;
	cv=none;
	b=iflfKhP+ea/EII/yn3wqP4jBoMA6npSDbqtCt4k2mfL4TfCGyx23JeFEyJDQ9reqUyQaue
	pqHdaqr4BjBEeg3L4FXVquDoW9TgJ8+U9jQJ32Y3eRxRVKeIOloMebekSj6/2QFTaNoCRE
	ne5BEfzUzSYMPf7JAilk0zjntUCatZk=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="UuShyuh/";
	spf=pass (imf19.hostedemail.com: domain of sashal@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 090F343E2C;
	Mon,  2 Mar 2026 15:15:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED769C19423;
	Mon,  2 Mar 2026 15:15:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772464557;
	bh=3+JOWRGzFxXHP0onO2qJa4UBvnD923gCutsUvkicEeE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UuShyuh/ZlJhCyQkAT1EPymurTXjiIysMRaTjzwDcOxWociXs+dpYDhw0peM3Dysz
	 uEYoKK0FO4GH9fLb3l0EkO0ZHj0SjUrZSdBnjHyBaraORA31jbBkSawjcnBykVb23q
	 8RZHTeYPuUcA+HIhPCUt6q8dg2en+j/mWcoJF3ynGGQIQkE7v0bWJ6ECq9NkY+44L1
	 n15gBNY2gTSVTk+k0B1WMcMOH18NEOhzuzb8OQCueeDnYI44PjYcQgTfPRrN2GnBwR
	 vhgd2f7rqEwXU4r/hgFOyjjPNrROq36ugiJcWIb3RsSwHzR85DI58Tl5U2HbYQNlsj
	 hjYSrURkPJxWQ==
From: Sasha Levin <sashal@kernel.org>
To: lorenzo.stoakes@oracle.com
Cc: akpm@linux-foundation.org,
	david@kernel.org,
	gavinguo@igalia.com,
	hughd@google.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	sashal@kernel.org,
	ziy@nvidia.com
Subject: [WIP] mm/vma: clear dst->anon_vma on anon_vma_clone() failure in dup_anon_vma()
Date: Mon,  2 Mar 2026 10:15:47 -0500
Message-ID: <20260302151547.2389070-1-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <9e273ce7-8471-495c-a344-d9bf61cb808c@lucifer.local>
References: <9e273ce7-8471-495c-a344-d9bf61cb808c@lucifer.local>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 090FC1A0018
X-Stat-Signature: fo77mduiyq319ydcegnqcg3mzkak4mok
X-Rspam-User: 
X-HE-Tag: 1772464558-11934
X-HE-Meta: U2FsdGVkX1+I3F4pW6cWhpEr49XNmEX2O23oYGDqI5o433+HhZ21IktvqXvhoGMK88PpH/YPpUaTc4HNDpFpBFHPTiQReM+4+xJIjJtLfYcqGhcvROUIub/WO1loKOwGhkQ4WgB1ebgXNFOyTToty2RRXT6DxtS5p1ZKmxOWG44ll4WGx3tQfgFYbYFqxNFbQN9ML9kj8obPc1UdBaFRSyFb93jQJjr5SHtgM3t91igEr/yv4e0teVhOLIxUHXZcAhW/F7dY+5p8pidfJxIXtE66ESofc9GaqX6F/+f/IDPV36270k60062/bqRbej3xsRz24FOVrkCzMs7ikDSyaEEsqWL1AclTSZ5TYEyluXw0H3Ztpn49Edei0xhHJ2VrSugFiXRi5BSfi6g5YHIkH+zmD+c6ZIxUm9+/3C25svQ9Zo693qs042IOmxFR3kLCaVezR9gUHiWxOLGsb5rV4iLkwDOOY0Ka1R0gOlZdA/2lrj9orGuNvfxFw+Gjs/VfE4IlR9NuHR8/z6Us9Nt61SnSmSTRVDB6UicjKJZPttCoadfZf7eNm1bLtmfGSqyPOwyIoll6CltGsjBh0DypQIGktAhTYz4VPJXBx8ZJOM5W4b7QfO66cPD2JwRwCMk/W5pK5/hMvAchfTcKBTAu47zM6/qBke/1v817wH1xoyiYZVBES1zHTZnTZ3sZcwS69wlEI5SW8zfl9N8uPCkMiUIBW1WaeT9mHHpfBavP6DosBsF6ccR6sP3xyuXdXAG3uDuqyWcLB6YhdnA5G9VE0sKmFGc9zqOOXqtlqVr+wP1dLlLw32XPKzjKd6ko7lHGxZYsS5mQSEWQIrsFaYk4fWT1SUf9DEfCnY4UDfjITXbyDX1qJB8PP1N7CfHaVaoNCvZ6E4nbQ+cRun4XdaGjlHUOXWRR+FIUhDBD/McJx6f5cmHNXuh3xnWDJUBXEi7wxwE6fAreCaHt6LnmlVa
 T8MsVFUR
 WhWtjkWWQhoCsZOF5udIi2NluDS54gK/pRMJkfFu66+e5jlOXR7VZnu+BfDnvgkuQW+vCByqU2vCvRvmcJp+1ZEUYKhXG0OdoySnrukPw9dKIByW/KM0wUMsHP7Qccn6oiaBqZXrVMOxK2GmBkdZIiyNTlvPdETUG24KHdOxyFH+4Vthu8/pOZlsjIGv/VarQW/jJg4vAF2QKPQKWlzTVOghTMLHpe09q+GLmKUWmb9Y95AjccuwFKGFhXyUkca4otnzGQ3YDheqkUuQU6mmI3dbfiw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When dup_anon_vma() calls anon_vma_clone() and it fails with -ENOMEM,
dst->anon_vma is left pointing at src->anon_vma without a corresponding
num_active_vmas increment (which only happens on the success path).

The internal cleanup_partial_anon_vmas() correctly frees partially-
allocated AVCs but does not clear dst->anon_vma. Later, when the VMA is
torn down during process exit, unlink_anon_vmas() sees a non-NULL
vma->anon_vma and decrements num_active_vmas without a prior matching
increment, causing an underflow. This eventually triggers:

  WARNING: mm/rmap.c:528 at unlink_anon_vmas+0x68e/0x900 mm/rmap.c:528

First, fault injection in the mlock2 syscall path:

  FAULT_INJECTION: forcing a failure.
  name failslab, interval 1, probability 0, space 0, times 0
  CPU: 3 PID: 4261 Comm: syz.6.96
  Call Trace:
   should_fail_ex.cold+0xd8/0x15d
   should_failslab+0xd4/0x150
   kmem_cache_alloc_noprof+0x60/0x630
   anon_vma_clone+0x2ed/0xcf0
   dup_anon_vma+0x1cb/0x320
   vma_modify+0x16dd/0x2230
   vma_modify_flags+0x1f9/0x350
   mlock_fixup+0x225/0xe10
   apply_vma_lock_flags+0x249/0x360
   do_mlock+0x269/0x7f0
   __x64_sys_mlock2+0xc0/0x100

Followed by the WARNING on the same task during exit:

  WARNING: mm/rmap.c:528 at unlink_anon_vmas+0x68e/0x900
  CPU: 3 PID: 4261 Comm: syz.6.96
  Call Trace:
   free_pgtables+0x312/0x950
   exit_mmap+0x487/0xa80
   __mmput+0x11b/0x540
   exit_mm
   do_exit+0x7b9/0x2c60

Fix this by clearing dst->anon_vma on clone failure, restoring the VMA
to its original unfaulted state. This ensures unlink_anon_vmas() will
correctly bail out early at the !active_anon_vma check.

Other callers of anon_vma_clone() are unaffected: VMA_OP_SPLIT/REMAP
free the dst VMA on error, and VMA_OP_FORK explicitly sets anon_vma to
NULL before cloning.

Fixes: 542eda1a83294 ("mm/rmap: improve anon_vma_clone(), unlink_anon_vmas() comments, add asserts")
Assisted-by: Claude:claude-opus-4-6
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/vma.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/mm/vma.c b/mm/vma.c
index be64f781a3aa7..4cf6a2a05c10a 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -629,8 +629,10 @@ static int dup_anon_vma(struct vm_area_struct *dst,
 		vma_assert_write_locked(dst);
 		dst->anon_vma = src->anon_vma;
 		ret = anon_vma_clone(dst, src, VMA_OP_MERGE_UNFAULTED);
-		if (ret)
+		if (ret) {
+			dst->anon_vma = NULL;
 			return ret;
+		}
 
 		*dup = dst;
 	}
-- 
2.51.0


