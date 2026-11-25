Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E8F09606A332
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 17:32:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cs.unc.edu header.i=@cs.unc.edu header.a=rsa-sha256 header.s=google header.b=ZYK+jp7S
Received: by kanga.kvack.org (Postfix)
	id F170B6B0A8F; Wed, 25 Nov 2026 12:32:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EA0D96B0A91; Wed, 25 Nov 2026 12:32:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D685A6B0A92; Wed, 25 Nov 2026 12:32:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AC0E56B0A8F
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 12:32:18 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B306C1C4B6D
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 17:32:17 +0000 (UTC)
X-FDA: 85474335114.01.33122BA
Received: from mail-yw1-f176.google.com (mail-yw1-f176.google.com [209.85.128.176])
	by imf12.hostedemail.com (Postfix) with ESMTP id DA26740003
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 17:32:15 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=cs.unc.edu header.s=google header.b=ZYK+jp7S;
	dmarc=pass (policy=quarantine) header.from=cs.unc.edu;
	spf=pass (imf12.hostedemail.com: domain of hengyul@cs.unc.edu designates 209.85.128.176 as permitted sender) smtp.mailfrom=hengyul@cs.unc.edu
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795627936;
	b=J6rt/vLLr+WnAKvoxQFKKi5bzydXR5wotTRK4LiOJptWQYJWYprFEPfKZ/iRxjXg/ZUJwr
	aarPRw2P0NEuauSPGQe5opdsK498jiGdJ6scum46BK2mShO6Bc/gEPc5kr+Ha0oIH+7JmT
	ucgwFQMClyU1EhAlj3xH9Nf9iR1EHeI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795627936;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=0HkGUAt0TkownVkXwCMu1x41EkVyymRWNHmR1Em1gck=;
	b=HJ+wAG+Ux8HjcM5ocpt7c2g9JOpQhMUuM6qd4WlF9JLxHsGuEjIBfDEbvPtbWFv8S+AxZZ
	thpiJZV2o6/TQRCxD0S0k1f7lGLEb1CW7NjsmKIq2aY4vFrOowZ3cDuoH7eIWeFits76KQ
	KdMk4cVbNsVz//yAE1foTX/ealeXuvM=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=cs.unc.edu header.s=google header.b=ZYK+jp7S;
	dmarc=pass (policy=quarantine) header.from=cs.unc.edu;
	spf=pass (imf12.hostedemail.com: domain of hengyul@cs.unc.edu designates 209.85.128.176 as permitted sender) smtp.mailfrom=hengyul@cs.unc.edu
Received: by mail-yw1-f176.google.com with SMTP id 00721157ae682-8b4d543b6b6so35345937b3.3
        for <linux-mm@kvack.org>; Wed, 25 Nov 2026 09:32:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cs.unc.edu; s=google; t=1795627935; x=1796232735; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=0HkGUAt0TkownVkXwCMu1x41EkVyymRWNHmR1Em1gck=;
        b=ZYK+jp7SiFE00Z8D3r5R4pF2jLKwAr3v0CegP7bM1U0w33/mQ48LLY4nlVtviVCuo9
         mTYtvS2OHvhoEXOaFI/PBKo0ZJM6AlweDc6okhUe7MTiMf01AMXc0ZII6509F+SysmNs
         TSg6t8naSjITiHDxakKhB54BGoEIMlWm63OEIfXlWEZSCTZhwb4IsPvoKUz8IeGzu6Yb
         4nfVcrApKEPS3gawMP1ywvO/oTqCCSKrlKKrQCUwGAChc0J/IugSeTqDEqArz8oYSco1
         j41ntcG4M6k5U8Ffpr0cf5ZxyrmqY2gQGpfGTNiwQmfVlC3fpSJiJIKp8uuU8HH1n9/r
         vvqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795627935; x=1796232735;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=0HkGUAt0TkownVkXwCMu1x41EkVyymRWNHmR1Em1gck=;
        b=2nhe9G/yds6fcvQt/cFRIIW4kkk9qLy/vAmwnaB0P2fT9qAHIYqDMJXOwyH7KtSeqk
         zkm0e3fp9cTsJxU+NgnexSfYeoiJEMsAvhPFTmPQl4+kPzw8S6d+XRcgY4CfPAHuWfZ/
         /1aGVl3FNazly+T3n+Dhoop75xS/9FfjW/dKUKYLokuoEiS4qXZ3v2YHaElyvj9sf6Is
         wR1mdaxtKC+6IatTOaaCLKWcQAE0ht/ANOCamVZz3cvqjeMJ8fWtA3V/ZH8BTONWeGn1
         aGgjw1qk1yeT2fM6QPjNTF13z3AaM03BlSAQ2O7KG+QfDDwirB7tNfrLWlILWv0otcdA
         PyGA==
X-Forwarded-Encrypted: i=1; AL+hErGAJKDR4bm3d8tJ+PT9UeO3lO0l0Np/jri87+MYeNDDenCf8sBRGPQAlgQk2TSSV5rdQzeVfoVmuw==@kvack.org
X-Gm-Message-State: APuU4Z9g/nqVWdO6mTOH37ZzhcRL7npq1MEsKfS6ZeOkhtOS9zH70kEH
	HY4/LA5CNAPVORXYMQ2kogvhtNqLMj2B0thLTDs96bmoA28VGnzJ9+ul6tpxx3/iWA==
X-Gm-Gg: AZFdTZeAXwoNZOjY1bRA15xumwJ+kMg4i22tov94mMJKtssaUzg/JP5ge2QEYZK0WTa
	OfCID4tlDGmL8opnZEmICzRlcbypjTODCZB/Rk8zB1SP6AaPZ95xljwSy9XqzWkYmtyCIFgWmXw
	rhwKgyKdEq+UUJ/JFw93dk9kn9qOfxM0i84+4jMoI67+Df0aHksiQUok1rhI/PKJkuqERX0LDJQ
	nkvpBnrj3js75pqO6Cym7nUJOazSUCTwyXJuHvycBKGSpDlbhTmXEb99Iq3wnbVE+skaVhLaYEX
	sG7K+jslhFXFuNn3ilxkGRo6HkmBV1tQmlLBlbgcLJ5vJVzKE2+PDmfc5L2xTroqHoJTbB0xedh
	WY7hlaJAcMQLtkW2RjBLdZZupQ9YfFcRw6glxb3n/1/qmvuWqK1UXjln23kbvf7FlCfYzodqwLS
	eDQWt1gU6I7pDbg5P5NnnPqbLIFIpOCJl0YYt0eewd3h115bGiyTullWIDd5H4Obrd/ZNaAGbtP
	oUZlVwXmrkOMSUzat32KYUg1a1Yj8PHbhoMVgORACjVGKG2ED9wlO2/JRO/9iOb7S2Ay6wR8OoZ
	LiTORTXzWKRSD5nXOfi1pNdv2fhWhUEdLGm6DZpuwQhblVBpU86u
X-Received: by 2002:a05:690c:6988:b0:8b1:70be:d4d0 with SMTP id 00721157ae682-8b52047d511mr73732187b3.48.1795627934796;
        Wed, 25 Nov 2026 09:32:14 -0800 (PST)
Received: from cobra01.cs.unc.edu (cobra01.cs.unc.edu. [152.2.130.143])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8b52030d5c3sm75406057b3.32.2026.11.25.09.32.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Nov 2026 09:32:14 -0800 (PST)
From: Hengyu Liang <hengyul@cs.unc.edu>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Cc: Baoquan He <baoquan.he@linux.dev>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	John Hubbard <jhubbard@nvidia.com>,
	Peter Xu <peterx@redhat.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH] mm/gup: fault in ranges that start at address 0
Date: Wed, 25 Nov 2026 12:32:02 -0500
Message-ID: <20261125173202.3636133-1-hengyul@cs.unc.edu>
X-Mailer: git-send-email 2.53.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User:
X-Stat-Signature: q4hpkfn9uqkkfai1cr1i7dceo7f4ahob
X-Rspamd-Queue-Id: DA26740003
X-Rspamd-Server: rspam10
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795627935-118852
X-HE-Meta: U2FsdGVkX19SNwSYiZBMhVmHQbO/SScIphUXrc/5CrHAclWcm5e7GhfpkB2S0wK9MIpJmUGnOn9Bh7mTA4p3UrfpFSbNfZNhB5nuHq1AzwUmEx4YAS8a8qyrKfaBNIKbl/WN/j5SIM2w5ZK2yFqpTFXjGnVHSYKd3RPAicrZ4k8wpry0f+XqXOP4UgUzsWoZwhx+UqJrWQSA60Z+k+CO65DKyfxQsMk6mNoH+JVpt/ft6lxiJxKZAMjoY8gH0vikeBvQnaY3WzQZNadvGZBpm/V9OUy65nA8GqqrJjQREObA1OMklsYY5eoLFkAjIs9hmvouBac4xwunslvxOmPXT8+t2ydORySEXgrU6DxHEdkSpTm7gGmD2gImWDnldOMeTL2dqS4pGmBOwpf6AXvwQ3JuthpKM/u6m7vP+qez3OvAR//Heh4SyLeF+7SGUkR27eeHYQcwArJfW0UIdVn0lYe8kL6RKuBrTLMEPhdIXOUQEnKflVPe3mLsqm453zHdjAFoKNbKaCZf9+4KHs7JyuuTot94hwviIYfGXxaWxWRQWJe4a8+ezaPUhDfhIY3Tr2BWuRNhYZwBDGcBNcL3R8rqIhJXUFoHbkMYJ7LHnHVtYrfL4wGIq8RVlE33DoBy5oxs0C4HuDv3o8CNbxSfNxNoJ95mo8tRanmmeENXRxjkGjCmq6O1npMLY/Gval+mj3xAxE7iJeZXUKqko7Xs7SydVR3d+ZnH88n0C9dOoND7IsKT40UpOago6783mClh2mLfMJ8sw+c244yLQAnuF1AfUNI8edGsyrq9ywrwl3eCc7B3TOJQtEPCrNS31qgKx/+tw+pPoZXCXF9SfY9F4Otz6r5FlWYLUfvlcO15wLSePyYHEvsH/tr4idhphLEZsFcYvC+GEEqJJfW2sE3G9Y2fMqRzO+88AGSpSMVYjbHLqudVQM9aBb1WKunu28LQkDp56WTK6QIvQNbAw/d
 2vmYtYKd
 KIzq4wr/fk8bqfzwXjJyIZnvvZMMr2/Ta+2NgQpGl2gmsoyqtRiaDPltcy/iYlYC0wFJSxiIjY7SyDtnx6ZVytE8YXO7KYNkALK2amLoT4Gn0HAJKBlTady2Aa15YZ+iWhCDqODfwZhhDuDr2293Z+tYjI2xQxzVGgol6cZQFv/nb6fBx8dSqAkVqMyfWVk3FUQorzPITan/fm0WjbYkmQ5GqqyppKe1SVpVX6claQ6IEsG/3NrTpFWul5ewORnbz7L4bW/4lfJuEbx+To4s5UUrEymxi0k///3vjLYkYeGlvSfcObAB+SPMp/Xhkq9G3p1XT311xxsgrZ5lD3kiUT8Ddi8FGdN92X6mTIB+NYoo/ZfPq8lpmWN4C9RbThm0O8v+Ig5NPEEEnE5FKFmClTWREw4dBChHO6gbKFj1N4TLCyLdnYv9QqvS8WvSTlH1ihrgXP+BOn0ghC9JBOH3OGC7jz2CzPai0LpCmQzpYZlk84t+RUN2apT8ROk6r6L7zJNMhdA2tfkF+nO4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Commit a7797e74bd39 ("mm/gup: clean up codes in fault_in_xxx()
functions") made the loops of fault_in_readable(), fault_in_writeable()
and fault_in_safe_writeable() stop when the current address is 0, to
detect an overflow.

However, the loops then do not run at all for a range that starts at
address 0, and the functions report that nothing was faulted in. As of
now, a write() from a buffer at address 0 fails with EFAULT when the
page is mapped but not present yet.

The issue can be reproduced with this program, run as root:

    #include <fcntl.h>
    #include <stdio.h>
    #include <sys/mman.h>
    #include <unistd.h>

    int main(void)
    {
            int fd = open("file", O_WRONLY | O_CREAT, 0644);

            mmap(NULL, 4096, PROT_READ | PROT_WRITE,
                 MAP_PRIVATE | MAP_ANONYMOUS | MAP_FIXED, -1, 0);
            printf("%zd\n", write(fd, NULL, 7));
            return 0;
    }

Before commit a7797e74bd39 ("mm/gup: clean up codes in fault_in_xxx()
functions"), the result is:

    7

After that commit, the result is:

    -1

With this patch, the result is the same as before that commit.

This patch will stop the loops when the current address is below the
start address instead, which is only the case after an overflow.

Fixes: a7797e74bd39 ("mm/gup: clean up codes in fault_in_xxx() functions")
Cc: stable@vger.kernel.org # v6.16
Signed-off-by: Hengyu Liang <hengyul@cs.unc.edu>
---
I found this while comparing the behavior of different kernel versions.
I used an LLM to analyze the problem and to draft the patch and this
message, and I analyzed the result myself.

Tested on v7.4-rc3 with KASAN and lockdep: with the buffer at address 0
and at 0x10000, on ext4, tmpfs and xfs, write(), pwritev() and O_DIRECT
reads and writes give the same results as before commit a7797e74bd39.

 mm/gup.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/gup.c b/mm/gup.c
index 2b405cce2ca5..a174e93327e9 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -2074,7 +2074,7 @@ size_t fault_in_writeable(char __user *uaddr, size_t size)
 		return size;
 
 	/* Stop once we overflow to 0. */
-	for (cur = start; cur && cur < end; cur = PAGE_ALIGN_DOWN(cur + PAGE_SIZE))
+	for (cur = start; cur >= start && cur < end; cur = PAGE_ALIGN_DOWN(cur + PAGE_SIZE))
 		unsafe_put_user(0, (char __user *)cur, out);
 out:
 	user_write_access_end();
@@ -2144,7 +2144,7 @@ size_t fault_in_safe_writeable(const char __user *uaddr, size_t size)
 
 	mmap_read_lock(mm);
 	/* Stop once we overflow to 0. */
-	for (cur = start; cur && cur < end; cur = PAGE_ALIGN_DOWN(cur + PAGE_SIZE))
+	for (cur = start; cur >= start && cur < end; cur = PAGE_ALIGN_DOWN(cur + PAGE_SIZE))
 		if (fixup_user_fault(mm, cur, FAULT_FLAG_WRITE, &unlocked))
 			break;
 	mmap_read_unlock(mm);
@@ -2176,7 +2176,7 @@ size_t fault_in_readable(const char __user *uaddr, size_t size)
 		return size;
 
 	/* Stop once we overflow to 0. */
-	for (cur = start; cur && cur < end; cur = PAGE_ALIGN_DOWN(cur + PAGE_SIZE))
+	for (cur = start; cur >= start && cur < end; cur = PAGE_ALIGN_DOWN(cur + PAGE_SIZE))
 		unsafe_get_user(c, (const char __user *)cur, out);
 out:
 	user_read_access_end();

base-commit: aebb7274476403040d582c61478df8f4a7bf9cd3
-- 
2.53.0


