Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A79A3C44500
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 13:00:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AA1A56B00A2; Tue,  7 Jul 2026 09:00:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A53366B00A3; Tue,  7 Jul 2026 09:00:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 941826B00A4; Tue,  7 Jul 2026 09:00:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 587BF6B00A2
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 09:00:09 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E2F8C168A01
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 13:00:08 +0000 (UTC)
X-FDA: 84961988496.05.89A05F3
Received: from mail-pz2-f1.google.com (mail-pz2-f1.google.com [74.125.228.1])
	by imf01.hostedemail.com (Postfix) with ESMTP id E4FE44000C
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 13:00:06 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=MEb0BUlD;
	spf=pass (imf01.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.228.1 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783429206;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dRG4koxyQiwY5tLrrrfMaCr8tCYmTMxhC2SFHMMXrW4=;
	b=Vkvo6SSyen8SxiArX5BknFV46LG2uGy3y9oVZzN5jbOt4muxNlzz6EMTU88lnsQexZjiYF
	IFCIO6/czFIS/63RwyN8+Tq8QdXaef2O8UQYu73hqT40vXQAwBwjcjymaGbToazdIaTdU/
	GTfh/P124ki5ucvJmxHbw0jVO35xQh4=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=MEb0BUlD;
	spf=pass (imf01.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.228.1 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783429207;
	b=QhmTBFLHnfMyxRwr1Kf9r+vE7P5JcqTrYUo1my6vpcRBSOlyimTY9YEXcSErN0b/E2oFB6
	U0Z6T9tf3wQMGiqWriKPxvQGYJ6y2OPwjyzHJnE1iwxPvIJ5T7SzTl9W9uXzBB/E8knJ+/
	oTS1H+2H3i7dsgystO9j2jM2We7XT4M=
Received: by mail-pz2-f1.google.com with SMTP id 41be03b00d2f7-c9fe62e0da3so655866a12.1
        for <linux-mm@kvack.org>; Tue, 07 Jul 2026 06:00:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783429206; x=1784034006; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dRG4koxyQiwY5tLrrrfMaCr8tCYmTMxhC2SFHMMXrW4=;
        b=MEb0BUlDxog9n2hon9ir18TsoZM+vDV8GAtcPNG0s9iAT3iDoz+FJXFk9u/pFYZh2K
         /FgbV6DN1wQ6CJ/91nl2U+PMP8v4AYSffOnttx6VEQ0K6fy+bZVyuwEYsnZJg2sJ4XvV
         Hi1Worzu06efiJ6Vovb7kxj1ZXnchdj+lJEzl5wbOys9GmGqRvo2cu7d1pqhqRMXqsxR
         iAZZV+NlYLwG3E74Vhi7T1zYizQC5fjGaGac1w1cDwP4Q4A/nHWmitADHcSLa/yVzFYa
         RsyarKAsOHSeGI95mFrgzqmsZjNXO5OCxFopkZWQA+4689wbsYjQIPD+o5WvSbUHkpwm
         6Pvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783429206; x=1784034006;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=dRG4koxyQiwY5tLrrrfMaCr8tCYmTMxhC2SFHMMXrW4=;
        b=jTkgrIo7xMWoxpkYBwp/dr0gagnOWa+ZSwSKZ6/llhF2jMKQQNpSNTola2msniCWMU
         EdRhH8z1CR81xmWb2UqaaUgW5C2EG1vRMeYQToQcFiQwlMH8gmPXQU0tRJHupaYXV8gh
         p0u1GxqCGGkJqituiq/AIrxcr+rybj22kuWWajrADvTATUOOLGftoFT2kSX5Wx6rKByF
         bm1knJlSwGoSqRqQYW+MFuPWl651w7HxRYUvWbPUa8auw1uR924xjeCdqHp9DNCMaS/n
         wY/nolKqcDF8GI/hLG9JEuQf1RqwhD2FHYYRnAufpDKkFWAh+rzZcejHxS1hnSRjLCV3
         m0wg==
X-Forwarded-Encrypted: i=1; AHgh+Ro8QCKZHIpBxRhlcYcamRfsw0284gdvGBnCdeHshD9v4O3ZoqMXkxZ3vwkXa+nyELulgr3UX7K/9w==@kvack.org
X-Gm-Message-State: AOJu0YzFtqq2STC0tZKjnEAV4K8mBYglfRWhwcRJn45V8Y9gJZKR+zcZ
	XzsyxlMK0ca+4WDImK3WFMX4JLPBfMM5oRz04ip3ClJC/RadEMiqTDCy
X-Gm-Gg: AfdE7cmmeBf70PXoyYPODCjD3nJ6mAjzRcTcNquwq+c0UTPFGyben2LXtd0FbjUWpwZ
	8QQtuWMyhTtrMxrPMOjuVArYoqNv4wRI36Mmq67HgkdYXRO+t4/1bwih+ZQghtl9LxCIrDCSKgY
	jJ8Vu0G4op0KidR8SIkaYs7XcaWPkenKcmMU6kSlecfotN9eHJjHwedZMpgT1N2/jwJtrzdmWf0
	QFKXQZWFFMCuBsFNNCiSVJ34V8tJj/dEsLlZVYu0GD2+xh3bcl0YcoiAi4cEVBUp688E0Qqc08E
	Jh1OzlTEZdt8R724nZoRxhqmjgtKhGIBocg1Hxs2wEMJ45fv2Q6MOMsF8uPrZvLjQwO0Np8FZfJ
	SWZsBci4H2fKhMnjkdXCR3YfERKLvbRCnAirqLvptWY6Tr9WzGDJpvlICA4EKxBLzqntZgCWxUL
	1C33VFZ47h5c2pnNOvkYwxNr4INYNJ3sHXfKjS
X-Received: by 2002:a05:6a00:3d0f:b0:847:6ff4:da97 with SMTP id d2e1a72fcca58-84826e92efbmr4766809b3a.61.1783429205836;
        Tue, 07 Jul 2026 06:00:05 -0700 (PDT)
Received: from intel.company.local ([210.184.73.204])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-847f6b5e566sm5415983b3a.3.2026.07.07.05.59.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jul 2026 06:00:05 -0700 (PDT)
From: Wandun Chen <chenwandun1@gmail.com>
To: vbabka@kernel.org,
	david@kernel.org,
	rostedt@goodmis.org,
	mhiramat@kernel.org,
	Alexander.Krabler@kuka.com,
	hughd@google.com,
	fvdl@google.com,
	bigeasy@linutronix.de,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	linux-rt-devel@lists.linux.dev
Cc: akpm@linux-foundation.org,
	surenb@google.com,
	mhocko@suse.com,
	jackmanb@google.com,
	hannes@cmpxchg.org,
	ziy@nvidia.com,
	ljs@kernel.org,
	riel@surriel.com,
	liam@infradead.org,
	harry@kernel.org,
	jannh@google.com,
	lance.yang@linux.dev,
	mathieu.desnoyers@efficios.com,
	matthew.brost@intel.com,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	byungchul@sk.com,
	gourry@gourry.net,
	ying.huang@linux.alibaba.com,
	apopple@nvidia.com,
	pfalcato@suse.de
Subject: [PATCH v2 2/4] mm/mlock: wait for migration to finish when mlocking a folio
Date: Tue,  7 Jul 2026 20:59:23 +0800
Message-ID: <20260707125925.3725177-3-chenwandun1@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260707125925.3725177-1-chenwandun1@gmail.com>
References: <20260707125925.3725177-1-chenwandun1@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 848b8xfjhxt33bn7cgu7489hasrtgsjr
X-Rspamd-Queue-Id: E4FE44000C
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1783429206-761961
X-HE-Meta: U2FsdGVkX18Juft9j8/M9R2BuFkEWanUQbAEuGaU9HFCLeY6/0YMHSvuropfEaoG7fRUucrUi1jY5pWeStJl5Wn4Bhcpi+hnrr+jwryxbDI7Mm2gSuMormyvbHLSrjBzyIicgOGgl3YBFlsh8ZUD3UMyzaNahD4mHO7CPTA83AxpAbnzKZwSF6/zv4BVziMvlI/6AX1UfSwcCFbotQLESnCwFoCpHtgLddYoxbf6rEYMMxfTaIEbXYajCKtrntmCC4DSDWorZLU3d9NmUtqT5kEVZulSa0OLNoFITgOP+NmW1G7kl2eAHxsVUCFJtg/oKIQWV5iq1fsGuBUX9J3NRTjeLpJNCFNhvc4h83ebdQvBNymRtyUam1ctldv3ipyADTgto+8FnJ1Ox5+9G/9aLA0C1cxat0H8OPZiFpsZo/mHg1fi6jmdXmPXcF3tkyfsEz15rlvDdQAEpXXhQWwcf6R9vq8PhKYltSO6au+PcB9LH9pCOjcy8hUpdfiXwQmRqiQVZLW+CIRGXMddJjFvJ4u2np+auRdmr+BQEm6MuYkPT0ranlD0a34yyHTNQKwbHjN4qph17QQjHkINNO8MmBjRB637SWOCZi5iK25XSC0uTjNQ6QLNlHVY5trpzyn8J3B+UwD1VRc8QOf2Ldymc5F3P8IsG8ZpfROrrmipr69/tKWX1escqS2Xefje5bnPDvWkYroYLdprGHbtHOKJP+K3Ajh9a1il/4mMbDVzsHl05n5doJ6gdM5wsLXaG3wzxJQmZ/2zdmccmn7+BlRxCIwsWdPSNJyEK2V76EUKtzyXUKOkcl9GwdMTctkOPCnVpWl4iUW8gEWmPA6t5hIUBuhKAPGbqQwudTZ8NVP4WijuaiyHoe7d7MR5PEwJ56DUFkFnUj+mnm9CNyp7NPn4ka5mxNQDy25dQ8RVKRCeKCN7WAxbbhgpouUhkzDsf0TUQMixFUxDJ2ehZRtVA45
 IkFXfFQl
 zwR6hBCUvC/s7nqcCfv5SIijwtcOe+FsVNGqfy7I0EaDiCUS8r1jPAS2TPGPDLM1pXAv4lcUzSLu/UYCKweeL3Jjto4YNn210nh96XjO2Mj7T2ut0hvLypklx4yz4gVU/xTu7gRIk6fCv3bR9nmh35lRGixnrjdCpWCZ/pm4OevO10GaCPOt//Vwsb+6Tg9oGUY7bXAkuuwhdZQGsTX1jKo2GaizsV12pEeBBxKG9GA94W8VcvAWfnnUsMulBycS6g+BDgmGNhqD/w65KcVMnAohgf3PCxAzeULWMRFbKGIVlh7HmqTPXXq+udLyBYAe+f+8U6WeblNl7HTGyrSsnwLmACMVOzKFigXs8oUe0uCy5SxWePCc3vbRUkFy7AdLXlck3AEpgrZdgbcpcn4/3t9DQ2OFlb8CG6h2iiOiiuqxx/VyTjCPi5SLiZlQVjl+0SxgNhCeCgh8wW+m1/vuR+KcsRu1ECZH3dR7GPT41XHiKJZPL/58iOrcDq0Vdxx3R/uNpR82sGfhrsL80WGOxYa/ou8WfaRW0txS+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Wandun Chen <chenwandun@lixiang.com>

In RT kernels, sysctl_compact_unevictable_allowed is false by default,
when the mlock/mlockall system call try to lock all the present page,
the mlock_pte_range function skips non-present entries. If these
non-present entries are migration entries, and the migration is not
guaranteed to have completed before the mlock/mlockall, it may result
in a page fault on subsequent access, which then waits for the
migration to finish, causing spike latency in RT kernels.

Fix it by waiting for the migration to complete during the mlock/mlockall
syscall when sysctl_compact_unevictable_allowed is false.

Fixes: 90d07210ab55 ("mm: mlock: use folios and a folio batch internally")
Suggested-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Wandun Chen <chenwandun@lixiang.com>
Link: https://lore.kernel.org/lkml/c8793c0f-7156-4cb7-9e6e-7909397e2fff@kernel.org/#t
---
 mm/mlock.c | 23 +++++++++++++++++++++--
 1 file changed, 21 insertions(+), 2 deletions(-)

diff --git a/mm/mlock.c b/mm/mlock.c
index 97e49038d8d3..ac65de40b22b 100644
--- a/mm/mlock.c
+++ b/mm/mlock.c
@@ -25,6 +25,7 @@
 #include <linux/memcontrol.h>
 #include <linux/mm_inline.h>
 #include <linux/secretmem.h>
+#include <linux/compaction.h>
 
 #include "internal.h"
 
@@ -361,8 +362,17 @@ static int mlock_pte_range(pmd_t *pmd, unsigned long addr,
 
 	ptl = pmd_trans_huge_lock(pmd, vma);
 	if (ptl) {
-		if (!pmd_present(*pmd))
+		if (!pmd_present(*pmd)) {
+			if (unlikely((vma->vm_flags & VM_LOCKED) &&
+			    !compaction_allow_unevictable() &&
+			    softleaf_is_migration(softleaf_from_pmd(*pmd)))) {
+				spin_unlock(ptl);
+				pmd_migration_entry_wait(vma->vm_mm, pmd);
+				walk->action = ACTION_AGAIN;
+				return 0;
+			}
 			goto out;
+		}
 		if (is_huge_zero_pmd(*pmd))
 			goto out;
 		folio = pmd_folio(*pmd);
@@ -383,8 +393,17 @@ static int mlock_pte_range(pmd_t *pmd, unsigned long addr,
 
 	for (pte = start_pte; addr != end; pte++, addr += PAGE_SIZE) {
 		ptent = ptep_get(pte);
-		if (!pte_present(ptent))
+		if (!pte_present(ptent)) {
+			if (unlikely((vma->vm_flags & VM_LOCKED) &&
+			    !compaction_allow_unevictable() &&
+			    softleaf_is_migration(softleaf_from_pte(ptent)))) {
+				pte_unmap_unlock(start_pte, ptl);
+				migration_entry_wait(vma->vm_mm, pmd, addr);
+				walk->action = ACTION_AGAIN;
+				return 0;
+			}
 			continue;
+		}
 		folio = vm_normal_folio(vma, addr, ptent);
 		if (!folio || folio_is_zone_device(folio))
 			continue;
-- 
2.43.0


