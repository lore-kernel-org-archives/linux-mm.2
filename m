Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 855E8606A32D
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 02:38:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=google header.b=Kcm6Ujkb
Received: by kanga.kvack.org (Postfix)
	id 7C0496B00EF; Mon,  2 Nov 2026 21:38:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 770846B05B3; Mon,  2 Nov 2026 21:38:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 65FBE6B05B4; Mon,  2 Nov 2026 21:38:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 32DFE6B00EF
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 21:38:46 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 86DAD1402E7
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 02:38:45 +0000 (UTC)
X-FDA: 85392249810.20.E97154A
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	by imf04.hostedemail.com (Postfix) with ESMTP id 204EF40009
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 02:38:42 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=Kcm6Ujkb;
	spf=pass (imf04.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793673523;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=rd65ofZ2aECwr5oPP9wkqS7GgVjXVfKOSh6kNluRLhU=;
	b=uyVKsOb4KqiGCdYXce8AsG4OsWMSBEdUaVxIu1m0IoussYcaXjFvyLJDL4TU+7ds76PPbm
	7FnkwnOMCxUj41uxmee1Iqkves4IxDBKFqD+JL0u/ajC5EKKpM44Cc010kdfeK1F2WvS0W
	5dFMJCeLAvUd+lYMw5onSiL+ZnH4qCI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793673523;
	b=CA80YI//KfRob4Gc89alnjaHx3AaYxpb1Li9Rf8XDhHwXfo4ZMkw7MgvD+4yBVAffPrrVb
	Q/gz2Bg9AicRrcULPzLqM+PJQDD3wNCrRnJzU+U9YtmlQzwq31R1B1SPlADdBDaX2Rm0ba
	M1xyUdj1rOS+Dr3RAsAENsbxX4JYEy4=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=Kcm6Ujkb;
	spf=pass (imf04.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2e831e86ebfso22232505ad.1
        for <linux-mm@kvack.org>; Mon, 02 Nov 2026 18:38:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1793673522; x=1794278322; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=rd65ofZ2aECwr5oPP9wkqS7GgVjXVfKOSh6kNluRLhU=;
        b=Kcm6UjkbH9LNoKX5hXYaWOfHwCcRj+iWk29iIIVyICtBlzwagRjVq/2lSk70mcnkjW
         TaBRCeOfgc3sN0X0y4Fi60kFCdOyjQ54kcbVpO1Q2ZluY0TDPPtdi64BHsXny6aQyKwj
         QhEgjqAUGx99swTN2bTNjFW25vO9Gw5KAt9sUwvW4ixa3pSh5Lr8SjhIqNObq+v9BPh1
         OCjNuu7gIV9R7CyKaISLRv1G+epH9iDXFeVp/9u3TxLvpyVNcL1DkDrPshaJIMRZUyr6
         rK7K7eqfMmDxCUWasGr1LnxWVl1/2XScbLPjt77KZOwbZ63VbebOQ4iwT6WXhCUnEAU1
         w9ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793673522; x=1794278322;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=rd65ofZ2aECwr5oPP9wkqS7GgVjXVfKOSh6kNluRLhU=;
        b=vK/jcrM57Gh9vqnK9IFEui7ELhC64l6L7kRUjKIaZuLB3PSM4QVSt4saWA3+MTQT2t
         PjDQNA9aJHAgqWGVEb26Q08GCqbvQtCwGt1umo3nfDlq/LzK3X2k2s8Z7yWqfc9geSlt
         /Z4d9XvKYdB/qexW5tVTYaQZnTfQ1yaT6NwHHJKb98/xsIRLJ3wLaGX4o0iKgm0iz/Ei
         UrKlUeUYRJVodrRZHak7DAzA3EtV7VPAySDIYr/6eJ2FcW2dkbQxUsRJmS5swI4y5YNs
         tPLLBpH5bqOReZeH+DlsWYvND2W2FTklnc4h3HAGAP6DKHVRgunfqqAzDHwBpgUfrhJB
         9MiA==
X-Forwarded-Encrypted: i=1; AKwUvBy3RBkot1jK0TIPWfQN0IDIDyKu5bB2mBUcLwK/+dLGQGFmnwtbUf3pRQS+mCYiG76emmp8zdSKZA==@kvack.org
X-Gm-Message-State: APuU4Z9PhrHqH1xerzljujR7wU6XWa+JM08kE48kAjPeaRl35ygrlqjd
	p5WgJ/9hNGI9Pcl8OO/3nQMEabul3HLzTuWpk0QXgE4/bkuMYZJ/LcwNjykoF/5CpH4=
X-Gm-Gg: AYBFou3L88VtQPqs6bZV0Hy89hM9e3RKd/LuN3hKtkUNajCJO0+gf4J6LFOKn0jA0rC
	fqJgxRjGAXlmne2Q+iJy1NSZcQbt7IVLJ+axJG7Z9iHlvLker8wMd2i6aim+ayzFZg1RmX2ahMh
	ogrnvRrSv0qIZPaA7AXFF2+zCFMQb7PJDGKgAxJQE6TT29CgthXGVPATS/qIuYXhZ0VpZDC+vD8
	47lnOjJ68GESM3QdJEY2E9t7CK2reOPRdkg1Ro6QB7p0OR/obxwNp5dLapR8LNJb9Sj3z+kifTe
	+MrkfJLgqH1+JCXfL13Pipwdzf6/Q4RrxIg+5FRTCL+RUQ/eax2e2hvBApM2+SIMqdBZHFtp933
	0u9ZWbPoh1rqCsMVt1ffK/mANQxES6FTuBB8Lb0P49D3FsHVwEYKQNylYNHQnIZd7gbpcg/Z8Se
	FUvVDJVzAS//6qzv8iFPdEH7cMrGX/jAX7rXxh0YC0BT0w1KU4e2OOpFjnQatJZdHfO/hzXvwZy
	d7+KKE/Snih9RZ1v+8w4sqIn8Z0lswC3d5QSt3AUyQtZUPF8aPaRovohFZdsI7N260httj9VaEp
	chLy0IpZCgWJrYCnHJJ8n21r0YbVsuQdj9arkmjdi0gSKlwfcw==
X-Received: by 2002:a17:903:1cc:b0:2e5:6158:b9c1 with SMTP id d9443c01a7336-2eb364e0730mr116286165ad.47.1793673521548;
        Mon, 02 Nov 2026 18:38:41 -0800 (PST)
Received: from n232-176-004.byted.org ([36.110.163.98])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2eb39298329sm33194135ad.61.2026.11.02.18.38.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2026 18:38:40 -0800 (PST)
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Oscar Salvador <osalvador@suse.de>
Cc: Muchun Song <muchun.song@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	Kiryl Shutsemau <kas@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Huacai Chen <chenhuacai@kernel.org>,
	WANG Xuerui <kernel@xen0n.name>,
	Sashiko <sashiko-bot@kernel.org>,
	linux-mm@kvack.org,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH] mm/hugetlb: fix validation of unsupported HugeTLB orders
Date: Tue,  3 Nov 2026 10:38:31 +0800
Message-ID: <20261103023831.1805473-1-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: fb39t9cgfyafbpysbwed6xbkfbbtuarz
X-Rspamd-Queue-Id: 204EF40009
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793673522-330116
X-HE-Meta: U2FsdGVkX1/M7DYht7nKKVkdWJtFqnsfFV59b6DObahipvN4+sRqEc1Fh5Ozs3WM5UwXcuRigL7uTKbWimIU8T8MRW+Hk23MNNvuRdeVKZo1uQvqZFMAZDP5XEinofKB4Uo9itIklCf6QLPfXLy2XBBJe6hrFCwcN/QOwEHtWWATqOO2QuHYdp3MhtTbSorcZDlK0SJyHFpsBfO6Aw5rG9S14W007SlKzS+3Xd511fe+rpGlQtCRA47NLUCffY1ADI//M6Ir9g6wCgFhtwDuc3q+7lVIZsID9wlpf7Sphl09zK/4WNS4q6WUnPVNnciWSIFHjxbomAsqCDG4Da73zJcIqveeFc2hc6JN4FdwSbf79odmDKDhyoYW0ec0rAoT3pdcOtInvqzqpKoWtC2Jt8ykRiVDc2E4+7jcQwCk/lATP1BBr2IgxvYcZAAwihTbLH3ZKAx3POpxsjPVMuTY/m87Z7M6jv4ihPnOOgg6W5KkeC66TzfLM8QQCcCVPBxZDVtoQbEfivfPlRQnfXCiZI+drZSrsRLoa/4YPPgnh0M48nhbXRyLZ0ng/nwIBJf6K0zcbe170FqLUz+347fTRVk/AExbID4JR+nUUdeuSeOvLIQE6OAszWLHj6VV/WGY7CpCfFdPXoLMUsxQ2apGiJ8C/6cXMwqp8F1xxUgyvAxHqR9SYb4Wi6IJXmRkXQGlKcZ2cFbuvu/WvNF1hkXxHDLzKh8W/gRf93UDzMg2ZZc5Po41gxOqNXb2vVcQlQTcg8rJZqzgM5weuVRce5qGsaR67dSVdW64wbsJuz6UGx8imI1UULB4f3gHrKGixsEZIdgDCmpWTFLLiOAI6u2ED45xNRY4xZBSzkGliLVDGPcbRLA8P885BJT8TS20deA6S3mr3tvEY+n+OupV7QsjYF4vVsSQHTds2BI5o1Fx5Z08NoQutBAjVHJshY6dPCFchdL1gFhJJb6XcSbg1QR
 481MpU97
 JIAM4BCxodsdiwg2metu4tsmsQyIkQ8HqKGWQeA9T0FnqzgSMt4yTYGFI5wqXfk5EmsldDek1zRGDBbkWKSX0xs/NYWq7cBpJ2rO9jdJlOa0OJoJZD+mQXcEChNjkCa+DoyCaMp7nBIFl2ytQSsSjogE4A5Q0hwaOiZKDPidrHJWk+9eL3QsvqnIWrH15S/w3lBk2zEcyZEMu3xCG8B8C36NNy0kr9SCBZE/t/F+VPXKp5SaecQsgSo6kDqTUCQWHeD/JnljhgNxZ0t4/BjC+6PwdnlT3qrHk7uXpwS9BawJwXLxttYsEAyKk2ufAgJGOMVBvjDXWjldoIdk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Commit 7ce6048d3a7d ("loongarch: drop ranges for definition of
ARCH_FORCE_MAX_ORDER") removed the ARCH_FORCE_MAX_ORDER ranges for
LoongArch. Besides dropping unreasonable upper limits, this allowed
values below the architecture defaults.

With 16KB pages, LoongArch defaults ARCH_FORCE_MAX_ORDER to 11,
matching HUGETLB_PAGE_ORDER. Forcing it to 10 while enabling HugeTLB
permits order-11 HugeTLB folios even though MAX_FOLIO_ORDER is 10.
LoongArch does not select ARCH_HAS_GIGANTIC_PAGE, so this violates the
generic MM assumption that folios cannot exceed MAX_PAGE_ORDER.

This invalid configuration is accepted by Kconfig.
BUILD_BUG_ON_INVALID() does not reject it either because it only checks
whether the expression is valid and never evaluates the comparison.
Detection is left to the runtime warning in hugetlb_add_hstate(), after
earlier boot paths may already have used the invalid configuration.

When an invalid HugeTLB order can be identified at build time, reject it
there. Otherwise, reject it at runtime before the mismatch propagates
further. Use MAYBE_BUILD_BUG_ON() so constant violations fail the build
while dynamically determined orders are checked at runtime.

Fixes: 7ce6048d3a7d ("loongarch: drop ranges for definition of ARCH_FORCE_MAX_ORDER")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://lore.kernel.org/sashiko-outbox-192874@kernel.org/
Suggested-by: Huacai Chen <chenhuacai@kernel.org>
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 mm/hugetlb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index ff9dbfbc7a96..e21ac667694b 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -4181,7 +4181,7 @@ static int __init hugetlb_init(void)
 
 	BUILD_BUG_ON(sizeof_field(struct page, private) * BITS_PER_BYTE <
 			__NR_HPAGEFLAGS);
-	BUILD_BUG_ON_INVALID(HUGETLB_PAGE_ORDER > MAX_FOLIO_ORDER);
+	MAYBE_BUILD_BUG_ON(HUGETLB_PAGE_ORDER > MAX_FOLIO_ORDER);
 
 	if (!hugepages_supported()) {
 		if (hugetlb_max_hstate || default_hstate_max_huge_pages)

base-commit: d42dfde37af766d1c272467352c0a56d3169ee58
-- 
2.54.0


