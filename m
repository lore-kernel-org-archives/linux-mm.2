Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9304C606A320
	for <linux-mm@archiver.kernel.org>; Sat, 21 Nov 2026 16:03:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ak006B3p
Received: by kanga.kvack.org (Postfix)
	id A7AB66B05B6; Sat, 21 Nov 2026 11:03:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A524D6B05B7; Sat, 21 Nov 2026 11:03:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9418E6B05B8; Sat, 21 Nov 2026 11:03:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5ED4B6B05B6
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 11:03:32 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C2A05C0562
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 16:03:31 +0000 (UTC)
X-FDA: 85459596222.03.CFF8342
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id E90B6180002
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 16:03:29 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ak006B3p;
	spf=pass (imf16.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795277010;
	b=20kifr0UowBJOwc9ML3j/kPB5gXXHqgk47+lmXtvZfW1EM3CbTO7+RK/rckprQrSs75ubU
	Cfdz7odMORqB4C2CXqn34cAH7GJYgYrzhlznxmLviF4BtzVveS2nKSxzOmxolMFPzUq95t
	MvV+Wh331rhhCmI4S8/FMQCgtiRyRPI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795277010;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gBgp43T//fAyhbIagABTzJUOBXpFMWAcovwgcCINvMY=;
	b=UDQel0TYrkwB31wPACxWoSwn400YErcKUpwx8ecwSDXv1TpJY0+UVeEHJ2N77XUMItYxQ4
	oUU3OpMRKCnBTZ+rD5KVQKEIBs81qsHuc/XD0w9V5KivDWshrgCBADvY/d0nPcNLb9481q
	Z2N43tJfhYL0qGc8qMCXfBGB6IIIYLM=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ak006B3p;
	spf=pass (imf16.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 43A2445A1F;
	Sat, 21 Nov 2026 16:03:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A69631F000C6;
	Sat, 21 Nov 2026 16:03:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795277009;
	bh=gBgp43T//fAyhbIagABTzJUOBXpFMWAcovwgcCINvMY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=ak006B3phr9aYX1dvUEK//5L6VTHWrdhu9WnRwm2fYmRWlUHoS1ePI+w4EvWAekDZ
	 pfEQvPaBb/8y9ySRdfFXJXiji/6965/4iQuc450ZgdpA4eRPkVIpJprJ9HPjsEWtWC
	 iBKyW7ogSWyQdjceZD02Gn6MoraSsAVHGzeVB9ko8IneoEbiQBjfigplDV+e5fjG/+
	 3+zuJ6HN5sRBsHvCed+BsSgeDlCcaPCic5jXJ+VS5HbniaOT+pJQ+d7wuPwCi7toWD
	 jHXyC9gdXzxbmCxy0knaNiUvWgZ05c1ax1L0TxPQIT4FV20+hcprMuTfgqkvQKAd32
	 ANfUwy2ENl7TQ==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Sat, 21 Nov 2026 16:02:29 +0000
Subject: [PATCH 3/7] mm/ksm: only interrupt unmerging on a fatal signal
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261121-some-more-ai-fixes-v1-3-236e925d9b64@kernel.org>
References: <20261121-some-more-ai-fixes-v1-0-236e925d9b64@kernel.org>
In-Reply-To: <20261121-some-more-ai-fixes-v1-0-236e925d9b64@kernel.org>
To: "Liam R. Howlett" <liam@infradead.org>, 
 Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@kernel.org>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Pedro Falcato <pfalcato@suse.de>, 
 David Hildenbrand <david@kernel.org>, Jann Horn <jannh@google.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 Kees Cook <kees@kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>, 
 Ollie Wild <aaw@google.com>, Adrian Bunk <bunk@stusta.de>, 
 Xu Xin <xu.xin@linux.dev>, Chengming Zhou <chengming.zhou@linux.dev>, 
 Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, 
 Hugh Dickins <hughd@google.com>, Joey Gouly <joey.gouly@arm.com>, 
 Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-mm@kvack.org, Chris Mason <mason@kernel.org>, 
 Josef Bacik <josef@toxicpanda.com>, 
 "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, stable@vger.kernel.org
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=2738; i=ljs@kernel.org;
 h=from:subject:message-id; bh=QhRySLL1rZVazQ5Q24cttAAXFpF2eDQxUeouxBVErqQ=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLIZD2x/fP3tM6svkwPnLRZP8HzoZMqlGCP06fyNO5E9K
 a5H1Sc6dpSyMIhxMciKKbI8/yK+P0gkbF7nBX83mDmsTCBDGLg4BWAiFb0M/x0a7duW1MstOBZ/
 N8aoe37L8vXVTZ3HODwMii7dfrt5y0FGhnee3bcnXz/C/8F1iR0f1/L62bVdd99mzj7/qtWuaon
 9Zi4A
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspam-User:
X-Rspamd-Queue-Id: E90B6180002
X-Stat-Signature: oi3mr6a1kff99eseesi4751dm6zmi5ib
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795277009-597813
X-HE-Meta: U2FsdGVkX18iZquReBT/Qn4kXGmeSZdF+Z3VaWZzAs69Gz2XFgy5lZHFi280u1XTRxveRoDfl6jpEJGFPXPzL721E6DVy9SqG61+Cdj6ExMpPTJV3+ix5NTA0gT0Ds6Ck1BWHwSuHA1fDKQ3znSen0jEGUjX0IlZyiuWIDaHWFvb21pk5t9BoLlU/9Q+t5Y4fHKinX+61EGdz1lZdVNzuT84IvvGaGC7VjLpT90gtNuycieQMHGiG+ix/6z8wjfUQ4gAWFn5eEX/dfWoXHjzDyJKnlammfKhN6M6rjXHRw1BsdulKA3505wXnv8DndLUBE1m39xfkuKxCLvhzwW5Eb6HaMWYirfZrDITjhTmmzLUqg9/wftg+LuBK58ikpizdlIAskxZXjQutx8G4KHmnyhbgDjzsfX1dlyxLelFOVQyg/FcmfjtBjmpkcUCLA73yAJwq3Q+kTM6UZp1oilDXmt8B1+jWGhWFqUbQXehX2E8OANmYIH7pbAI10W0kcUjiSgRj1jPaUYWlte51w6a2nEfBxFVLqKFi1LQcKKg9WALwSYQ4b/NI8ydAW4IUW9VuSOuCr83xENqmg+j50dSjWPtAD6C29p6lk4vd2i/8Uh1YubkOR2SSqU8/T86HYhoeW4aUY1b/brfsoUzVRTiJZEw9vauUMta6d+7E3Eit7aFxQiZYKzq/Yq0Wadr+tRJaSJOYCvZHz4HEc8wOVkD0h5vD/yr8oncSiukopVdbubWj6b79i+V8LNGCLJV91849F3I5Wg8lqgMpchtTZlbkSxXnuOQcTvUc4Q8HdxuuLx0XN0RRV3AMZ/xENKKzvcx3wE9lHbK+nyj/7Gk90SSZMvKvohdK3KiDXausPXgiNwYcCrEVOdvucdJIerN3zV928GKPzeJQlisX6wd5KwwKbMJo6llZC2ZbEDTWKJN/T6iWYjrkIh0c5GVGRM10lBsnUKrf5CkKicUeYgFKVB
 eYlHfwui
 pFiIrnehfehjvZii5suYZpKXS7+BJhmxZkOD+1HObMX2flnrYxlgL+9OghIK/09zETG/aS8VFRa9yWLX8V7anx6dWMwDmlRHmUassdoZlve0ZhEfeiAMUZ2gg0W8u0iM6KaBBJHmfNHyae8RXWE/kWdmgF49BNveuF+XFeXS2wpOvTv5NiBgTfZ/vcXeuANo0o/XgnQ6M5qyuXTODieaufcFfGjaodfkSnpIjDbmXpDZ/XC9y1XByN2GtSwD4v/V14OlIuic6mmmDo3931RQyJrMzQQVtwvnW6GV8CyhgKGC1JXTci4/12IGvgyON0kOAVVPPVXjZ5A5il67usbfv9C3kuCDXQ7+EFD9dP/CG1iwVP1CKoXAhSXIrGnunYSTYUbP2COylXQ5//ilUn3LmoD76UvXA9S4a3REfakDwf22dTcFqEaHpzC+b/9ygwqgBWQdaHZwh+qqC7T6UtlaCZ4vhjG+LPIyUmsDJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Commit d952b79136a6 ("ksm: fix endless loop on oom") added a check for
pending signals on KSM break, so that a lengthy unmerge could be
interrupted, with the system call then restarted via -ERESTARTSYS.

However, it assumes that the callers can always restart whatever system
call started it in the first place (the commit message questions whether
this was wise).

Well, it turns out that it was not wise, as this baked in an implicit
assumption about system call restartability, and it was and is not safe for
mremap().

mremap() holds an mmap write lock over the operation, which an -ERESTARTSYS
drops, meaning that the restart is not in a consistent state.

This was made considerably worse with commit d23cb648e365 ("mm/mremap:
permit mremap() move of multiple VMAs"), which can result in data loss if
you encounter this issue.

Consider an mremap() specifying MREMAP_FIXED | MREMAP_DONTUNMAP of two
KSM-mergeable VMAs, where a signal becomes pending part way through:

    first pass                          restart
    ==========                          =======
    unmap tgt1 range
    copy src1 to tgt1, move page tables
    unmap tgt2 range
    break_ksm(src2) = -ERESTARTSYS
                                        unmap tgt1 range, which now
                                          holds the data from src1
                                        copy the now-empty src1 to tgt1

This results in the user observing a successful mremap() but with src1's
data missing.

Without MREMAP_DONTUNMAP, remap_move() would find a gap at the start of the
range on restart and fail with -EFAULT there instead.

Fix the issue by only breaking out of an unmerge if a fatal signal is
pending, returning -EINTR when we do. This makes KSM unmerging consistent
with many other signal checks in mm.

Target commit d23cb648e365 ("mm/mremap: permit mremap() move of multiple
VMAs") for the fix as this made the issue significantly more impactful.

Reported-by: Chris Mason <mason@kernel.org>
Fixes: d23cb648e365 ("mm/mremap: permit mremap() move of multiple VMAs")
Cc: <stable@vger.kernel.org>
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 mm/ksm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/ksm.c b/mm/ksm.c
index 623a2cdb3924..5d320a200951 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -627,8 +627,8 @@ static int break_ksm_pmd_entry(pmd_t *pmdp, unsigned long addr, unsigned long en
 
 	if (ksm_test_exit(walk->mm))
 		return 0;
-	if (signal_pending(current))
-		return -ERESTARTSYS;
+	if (fatal_signal_pending(current))
+		return -EINTR;
 
 	start_ptep = pte_offset_map_lock(mm, pmdp, addr, &ptl);
 	if (!start_ptep)

-- 
2.56.0


