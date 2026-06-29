Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1476EC43602
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 16:38:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E5B106B0128; Mon, 29 Jun 2026 12:38:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DE4006B012C; Mon, 29 Jun 2026 12:38:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CFA9E6B012D; Mon, 29 Jun 2026 12:38:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9D66C6B0128
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 12:38:23 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 226A98C571
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 16:38:23 +0000 (UTC)
X-FDA: 84933508086.07.75EE7AC
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	by imf20.hostedemail.com (Postfix) with ESMTP id 64AB21C0009
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 16:38:21 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=MAU0BJlC;
	spf=pass (imf20.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.210.170 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782751101;
	b=pYVgOyy/8PABZ6gk08WUX8l3tMj4HLit1a6nK5kPyfyd1aM3pZkVz74/h7jAiCzPt9I93A
	9GN53OPRWMQRvYOiqsvnC/brB6eHju82RndtUMkPYUIfVaE+Rcu34DuXxQ0CkuwpIeckCZ
	Pfa2rGcL6FVP3taMWxFEwFoHJFIabu4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782751101;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PPX10qsMY++ER8afXSJu3F27jyGSgCeFMlyZg3pCc1s=;
	b=OyHE/pQsHTLca56XSuzU0NZzmzAQEL4lJeXAPp1o+VJPOCo15CIzXm+3HBIZ9FMbV5raZM
	IjPA4KfBo23msbwd7EXCX/Feyjetxp/Lj/OzjsRh/r6KV09sbfgFx/UcJirtx478SvE3F1
	Ly2+FcTWX/Vvt+TAJYLyY/pQTjKZ7To=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=MAU0BJlC;
	spf=pass (imf20.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.210.170 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-845b965c1c4so1763307b3a.3
        for <linux-mm@kvack.org>; Mon, 29 Jun 2026 09:38:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782751100; x=1783355900; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PPX10qsMY++ER8afXSJu3F27jyGSgCeFMlyZg3pCc1s=;
        b=MAU0BJlCRNImrKaPxjBaRxb/yVJWJ/hbWOitO7bS1tsLn2VLBdudZJ5U1X9UNC5uCg
         xB0/R7hm2IwR8ZMI/+ZG3YQ+MX/LBA8Zgus9pLejMA2ZdUdb5vUc93Gix2ZTLmcTLQrU
         iWCJOsKgPRh0ixMKBVfJW46EyjHtGqy3T0/Bf+hV9jyvxxmYPHavzwj96nEJwVdbKARM
         8oAR8nIxn2ScEehD93ItOWWMSKJy/+Cf22Zhpsr9NLBXlMhiTSiiLBleDc+lwQ2IkIbc
         NuOAC4jjcMSO8ePKsoS8LIopKK4UscY9s/HP9PiWYxxSaer4NylZwJ1DWlxSwnpZAhtg
         ScKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782751100; x=1783355900;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=PPX10qsMY++ER8afXSJu3F27jyGSgCeFMlyZg3pCc1s=;
        b=QL0q4OHSS+K6VS9CzMP5XL8Fgjf8IfarHrFlrPfa2vgjlv2CJsRUYtB/jwLNUZukkF
         Ct40kuIft09bFS0uUjFbX1yuZTC0lXZVTIDK6Tv6nMa6twLaKVVCiWShPJPWiQcL/Tjj
         QTGPGDYvTiP3QP1ogoYV940zPWgxMM8w+iTxYbVbGW8zcOns0AozVqgc1pjQwY2Qbj7T
         diU5u4Qo4jfxTGgvGIFr77Ly+mMGiIba7dyrPmWVaTAScN7mY/30Qe477PKI/e5HYeWf
         B/4Qwf5CdSPD3zB6m41BJR/GdEzeS6g5E3ITdseOiPoHCfy9FR84Wc+FyWmyo1XxNTZ8
         utQw==
X-Gm-Message-State: AOJu0YzVBKQsCHmza7X+J44wH4mvHVq3LL2ln+bTdEiF6dbS5a10Jpka
	Tw2hzEcSc+JEmPKer90Cl6PlHPknwMbZYUiCFqYLk7zeCNsRjoDUKwwL
X-Gm-Gg: AfdE7cn4R0pqRfKcrTtUHuX09kSpt70WmL1/caobRx4cn32UPpLKpfkGCLDIw6F6NEs
	RXCUlzJIw5x4e6WSmMw+PeZhCAm1CxQ+1i8owzi8/kXu6tyMbEdw1QJnyU8y0nLr1jxxdYXXzRZ
	50dLmLBZVHxRt4rEYmOg8nGuXLiBa6UgoEAvz9i+3sjgprdyTJxmvKY+YIJZ2gxSMStoZGeJ80Z
	fF5FkDhq6BM4OQVsdwWGGoBAMCODmSZLxJBwDVwmvC8llcgcyqNFO73aQiegRTcv8iEmzu7HPVn
	GH7jGVF6jfVZSZXfFeIzZrGSO5VTqwt1mEThUF0if8axQ7WAmvQPR4aWIjUk8+jSInb5ed1AsSH
	IfEwsxJl7lJDdODOEiCTR+iPp4w8vKxdjw71x/rf5P2Kcnxt+qdVP2IbXVVRLye+H2XHAzn3wgU
	hbbV1MdMU=
X-Received: by 2002:a05:6a00:190c:b0:842:4b88:20ee with SMTP id d2e1a72fcca58-8479f26c18dmr215091b3a.44.1782751100331;
        Mon, 29 Jun 2026 09:38:20 -0700 (PDT)
Received: from ubuntu.. ([110.9.142.4])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-847a02d41c0sm18474b3a.33.2026.06.29.09.38.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Jun 2026 09:38:19 -0700 (PDT)
From: Sang-Heon Jeon <ekffu200098@gmail.com>
To: rppt@kernel.org,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>
Cc: linux-mm@kvack.org,
	Sang-Heon Jeon <ekffu200098@gmail.com>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	linux-kernel@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	Nicholas Piggin <npiggin@gmail.com>
Subject: [PATCH v2 6/8] powerpc64/kasan: Remove unreachable invalid range check in kasan_init_phys_region()
Date: Tue, 30 Jun 2026 01:37:34 +0900
Message-ID: <20260629163736.1606688-7-ekffu200098@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260629163736.1606688-1-ekffu200098@gmail.com>
References: <20260629163736.1606688-1-ekffu200098@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 6hdm19qbgke9o1ai8nxs1i86cgrywxdb
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 64AB21C0009
X-HE-Tag: 1782751101-39776
X-HE-Meta: U2FsdGVkX1++muLwAXPK+QmW3VBdH53/xqWkAwzDq4yvW/so1jkAIanEJllZDe0W8bm/b3Xt8NHaDbgutjvjZGS4QHwTHLNiHh0uy+XuPZB+Xp0i5i3ETwJWHys+IsQBQ5XVyz7DJhFy8mbLso0/cvY/0O2wfvQy8cAmFJfkpJeCDjd/oTmjZ/SQB8qWS8cjttWH7hwVKz9US6qqcTauJ9SQu0mdKP0XiOgRkdwnnPdnKJ/r78RebpqaUiCPiYhlk4i7rvjNUydtb+Qyas0bhiHgucgceOkZJxCLIQ8b+lnCB5Ln8M2MPi5dfUZ2Tfpxp0AAH2nVUO8yKW/Oj065aiXR0LGjsST+royPj7X3l7z48crffoqlIkSgPuCDoq/zSNWRP6tC7JrIwAPEIKIipCkuoiZJa61k+lyETAfp3MRAh9hy25gyzZr+rqBESHl2w1nFG7pc1HB03bkQGtuk3QPmQLDOEFV+QBXnbyGOUKH2msFb0wu1OFXRg24jw4QZZuJUKZtkI5427E4q/Z2sHYNONUT0UDP/RHiQ9XnT4tX7Pa3AhRGNkyaP+YoBx+qRvpfPEcT+0+dtWAE5+m8183EqIC0FaCZxIe864/KpH/+6KbJtBcxa2FBlgKdRMpRuo0+oGkbi1W/VifY+JVwW9K6Nri/XuBmMAzaLYVPGvLFq05UKvAF6zRYvLNXapt3YmhByKKqf7iYrc4zRWhSaha4jryJn2b75b/WpEETpSa63vQTZERUiscnwujmNNOrzTrmwl/XwOfBnmLSrR2Ea2FSo5qmsUM5510AH5jSOFMqX96RFXrYqYMZgpzy7ShJ9mJBiD2xNp3ewqBo0ivWr2RTjkRqzGGiAAjqViMVOyLK5+YD3/A+EVk0smEchiIiGF+kgwgYGVaiKwzCwsP92vg8BSdnZNPl2qb7YcVFYPBsN78n3I112okOJIIH9CBccwvjPpSAq7mtfpREEpn9
 Cx0eif+W
 NZWHSAVrigN+X8gwhs6c7R1W7q2/RZEpT1BjUYqOXecBDNUrKRkAFl54mRvvFJUGr7q2UA0yYafRvzgGJSRRBsXDwREcjAKm+De5j/Zjtd8S/Xhv3RgaPQQvmhcHhATtv62iPHZ+pVVq6OFiK9hgONqUM8FwEi2t6jKc8xfnWd1hDwwmNtmQx+6TkjMnJO5rpw3jkoZS/iv5sUdu+03dYeuEFyRpJhuvgfFrrjWQcfJY7Dkg1HaPkkRHV6iSjf/1DgDHvmIuWEZAK5lNKspiBV6wwiFTYqjygi/j1LjTlLEj/CK9DyORQFaCvaFqIJBmJmZVUfSA7mufNbH/RhVmqxZJ8XP1b7hIBy9G47LrbK7d5rknIw9bAXKKkKx7JE5mYNTOaeOd9XXV7ERBeCaqsOjuSKL2A/dqIV5WPTMD9vwzdhKYl+9afxVfAZMrrqsDPa6hQ+jhCLx3+gUc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

kasan_init() maps each memblock region with for_each_mem_range() and passes
it to kasan_init_phys_region(), which does nothing when start >= end.
for_each_mem_range() never returns an invalid range, so start < end always.

Therefore the start >= end check is unreachable, so remove it.

No functional change.

Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
---
 arch/powerpc/mm/kasan/init_book3e_64.c | 3 ---
 arch/powerpc/mm/kasan/init_book3s_64.c | 3 ---
 2 files changed, 6 deletions(-)

diff --git a/arch/powerpc/mm/kasan/init_book3e_64.c b/arch/powerpc/mm/kasan/init_book3e_64.c
index 0d3a73d6d4b0..0ed372fb8b09 100644
--- a/arch/powerpc/mm/kasan/init_book3e_64.c
+++ b/arch/powerpc/mm/kasan/init_book3e_64.c
@@ -68,9 +68,6 @@ static void __init kasan_init_phys_region(void *start, void *end)
 	unsigned long k_start, k_end, k_cur;
 	void *va;
 
-	if (start >= end)
-		return;
-
 	k_start = ALIGN_DOWN((unsigned long)kasan_mem_to_shadow(start), PAGE_SIZE);
 	k_end = ALIGN((unsigned long)kasan_mem_to_shadow(end), PAGE_SIZE);
 
diff --git a/arch/powerpc/mm/kasan/init_book3s_64.c b/arch/powerpc/mm/kasan/init_book3s_64.c
index dcafa641804c..ccfbfb894637 100644
--- a/arch/powerpc/mm/kasan/init_book3s_64.c
+++ b/arch/powerpc/mm/kasan/init_book3s_64.c
@@ -24,9 +24,6 @@ static void __init kasan_init_phys_region(void *start, void *end)
 	unsigned long k_start, k_end, k_cur;
 	void *va;
 
-	if (start >= end)
-		return;
-
 	k_start = ALIGN_DOWN((unsigned long)kasan_mem_to_shadow(start), PAGE_SIZE);
 	k_end = ALIGN((unsigned long)kasan_mem_to_shadow(end), PAGE_SIZE);
 
-- 
2.43.0


