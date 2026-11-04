Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 44EEF606A332
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 07:19:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=google header.b=j0W4uOzR
Received: by kanga.kvack.org (Postfix)
	id 597556B05B4; Wed,  4 Nov 2026 02:19:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5478C6B05B5; Wed,  4 Nov 2026 02:19:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 40F8B6B05B6; Wed,  4 Nov 2026 02:19:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 210956B05B4
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 02:19:54 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 999A41205F6
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 07:19:53 +0000 (UTC)
X-FDA: 85396587066.23.58E61F0
Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	by imf04.hostedemail.com (Postfix) with ESMTP id 3127B4000C
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 07:19:50 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=j0W4uOzR;
	spf=pass (imf04.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.46 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793776791;
	b=SPr7DD4l9uv5eD8IkxvdLTnh5gHMPvAypDFAb6y8NFM+9JA9/1Kfpe8usEq7vWFxdjiMek
	Lb/h9hbqr3Oca5rNRFIbrMkx4BRbAhmc96QW99h4fXl+OBEbeFY4hhVEq07jn65tuRATWM
	sQuwlCD0uv+sYDTKKDEK1eDCuLvtXRY=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=j0W4uOzR;
	spf=pass (imf04.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.46 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793776791;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=rrzBvJUH0m6X73oGrOP8Fx5drxVGiUnw51WPWWQEE/8=;
	b=GdJ1jIkWDNtWYAW66MYkOyRmJdJbIdxZhKb7MS/sShue9J9CqBvm43cOszWPz05m+ZUAW/
	SMnnwXNZoZBjSqcuSjHW8rSFnOpm3z1AnDnRcxGvBdUNWd8P7AS0nA7HxlgNzFXjpYAoFP
	rmuDK+dGsnKaDDLIb/Mj5d/kYnrR+30=
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-3b0a0d19a60so61669a91.0
        for <linux-mm@kvack.org>; Tue, 03 Nov 2026 23:19:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1793776789; x=1794381589; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=rrzBvJUH0m6X73oGrOP8Fx5drxVGiUnw51WPWWQEE/8=;
        b=j0W4uOzRUCaYKBHXETvCQWXJRKVD6mUHvvrUFU4ZbDc2kRGPGbo0I8WWaj2R77IidS
         72bUnmS4bz7vQJoZJ4D23CJE7RtuhrV0zBhkXEVA4rSUBREZ1PeibjTfBpkV33wrpVFo
         fCqTMLPvUn05YVKwQfJzSCCVkqaKTqbG9ghzhFa9rC/KlchCkvM0mUXYVRt8PVPDcXC2
         BV1iu7xSnlzO+W0zUNkd0BR68GqlQrSuHYQAukPoAneCGQAPsz9rdKdg3YOZ2JqpUQ9P
         NRV2nrVQ1zYAf4IIul/H3VIKw+lL60GMw5m/qlAt69LK3XmzA68KGCUeVPT5imwqL+ZE
         fpqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793776789; x=1794381589;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=rrzBvJUH0m6X73oGrOP8Fx5drxVGiUnw51WPWWQEE/8=;
        b=2dwcpnCEHGz3hJZp6tljzoUQG6nIEf6BU/geyaAcrO+n35dGSCIhiXIAvxhPhCnkyE
         ZUGgy2/5cHPttHgX3/2R1pQN1INPCxl1zJjabA2PGTSMVGVSZLmu9jkHCbjdeIVmYB9M
         4+dckIAn0bnjdr+W5TIVUflw6l70004uoYNZ0f9cElYTJZo9TqyM0AVxj9RJqZlFcnTH
         z680A2sVIpXxuwiLmqmcLfz2J0fdXqJPDKPgjRnS5W5r6qzAHF8w3MeFHFqPrFaV7uOi
         WqwKcB73AmMAHDQltJ5Z2pcOu3FF6Svn0kKEFIHrp3MIyd1U8SSNl6HnEXJklAgLf8Xz
         0IlA==
X-Forwarded-Encrypted: i=1; AKwUvBxjWEK/ggwMieqLyQBYwNkXKA3/F1/XcwGeBCYD/ha73qbrgYeKsZsTRSQZLhHeGyV4BfaVgoXrtA==@kvack.org
X-Gm-Message-State: APuU4Z+S4pDlc+quSxvVJiqCbpW7cYiXDq63I2k00xM5xniY4WLYeoUv
	XzwMfrJ/bHqDZc1u7AwQ/mRBnt5m4qMyuZ9Ge+mEJUv2ZGH9+MVlNK/ncUuN2LnUmf4=
X-Gm-Gg: AYBFou1Xnz0KoPuElbgM5ZDjnYbbbV4Z1TgQSF9rdLr40mdDF0xG5ep5K9EkRVoyIj0
	i5yO1IHJOyncXNJ0mELC70ZW1m180zF7AK0A17nPM1qPRtTZ/JqrrheLiwAF6Ofe1efMwcPwlxQ
	Ua6GIHN++6z/QtHkBRfKP6hWgaMo6OFBae2hfOVmAYtdbtTlHRRe2sFnydRzGVlZCgiRzdyBCJy
	d9pZpWyRdQv/vO2hpxGhgi36QKtQg6SW6jVC9Nod0G3ZmFLafzrHbX+KUt5P07dO0//23Hs/9tZ
	H9GRIlXR3MV0grMv9ggueGiSmBVHkwLIXGQ6ky6BcJEtTs2Qgd7iXEJLXlM3zeingj/2h3o26KN
	kFvUwf1eH8jxbfLIoIW/RrF6DrztcjEd/W8FSjttQULBJbF9yUe/9bjcxGAlX9MsPN2/nNDwY+O
	dngsITBvZo0mACTyMN0cI5XFY9WFo1Z1zeDxTg6vjfze/s7PlmjPKckHogMERIOETZUknjAAYRr
	74OKTybSQ7Q1VkBYcK0BHLD91ZkSyFfTYv0VgKetM6WTFTxjLBDndk7WElQp8M/MnhxiPRZ4vgv
	Ob31yoD1rnuR755AfLvS+rfzlshVXd4Vw5TZ21xGcFz5LLWM653kYWVzqyjGePoXkDs8I6zf
X-Received: by 2002:a17:90b:2691:b0:3ab:189b:6980 with SMTP id 98e67ed59e1d1-3ae89776111mr11952482a91.39.1793776788793;
        Tue, 03 Nov 2026 23:19:48 -0800 (PST)
Received: from n232-176-004.byted.org ([36.110.163.103])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b099189fb6sm1027403a91.2.2026.11.03.23.19.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 23:19:48 -0800 (PST)
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
Subject: [PATCH v2] mm/hugetlb: fix validation of unsupported HugeTLB orders
Date: Wed,  4 Nov 2026 15:18:57 +0800
Message-ID: <20261104071858.757793-1-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: cjjjhqhxuh8x9rrehqbjtn1egimqppms
X-Rspamd-Queue-Id: 3127B4000C
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793776790-175004
X-HE-Meta: U2FsdGVkX1+jFoRhvNuzYE/Bn5Jvs5rXcFqDzn6jrOck84IPZ2g5Z8AlRjnJQnPAm8XjTeybrjIOPBbjzqNMVP011QRZ4MacsMsFMMzcBiiOIywEI+dunFSsdTecwysDEBbaHA2aE+yCx628JCaBT1Puw9tQVtCS+UBgzXifpb0sZErXq7zG7M4gLcJ1o5UFx6F9Ftd4651a7Sj/1MiDoIkfwMAalAK5lt7As/5Sx6ZrrBLXcTDAZsfS97iD78LOU2Me6RsuSALmjysigc/RjR7lkYdWySDb9uxmZRJCEfPus1y/1BOkZDlYus5mh7YHUiDuXSHb8UuOQ0pNGEbo6ltt9TuNxrOUgs/3l3ZO5vMGnczxjl7ylDcs36dK9k4ADeR9lHYeXkdWIjnIp3IYOewvq+NiYnVFPJVYzPznyP5fFYnqAL0CFiReGsRnpbFQCE+pp+9aJeYCsA8Muw1kit8kWcF55rMdliUN3M6Wa+1nO+VBp51yhdlL3C89Z85gfGZqhEJ5t3vu+mcfDQ1Py1gGcu8wQYR6wpPCwONrI+7BM3BEnesw6tVR+Nv0zLm60YP/v8RYYLcopYyDxFEY5uicfwLvEHuBUCOmcaHXQoC9d7G5soznmPZniFXB0/FoAyXSWYdtx7sYjvpmztc+aPF1cCcXAOnweaZ1NZqV5mIC8QHmW7gOa//PRea9tCIIHEnTP5aIBNcF5vPdog6HVXRD2LVaI2851L6MLNeDgTpf26wgePYfB0lUO5SMkHZN+/URT+rVQx9A3v6zHrskNFXYtr0jVKMyW+EVEPqYOIDy8OHPLBleszYDNG1Xtlrgci1uSZxxHfhuBTTBojDdAOTSXYhrJYmhNwHBVjmZDiMxrdgygbDYhR54OmtN/9TLaBnT21GHGm6Qmeiw2Gy9ee8T/vt8aC0/f2n0NMCS0rttJKIG3pFo8tc2xbDXM1YfcXTR+H7zIhTFRQFuLhP
 WqJfVF/Z
 izWvuJFhM3UJIcu7Dwy3up8XoChdOgfRi3rbvR6ofF9M7tXsNxV/WEwQtWE+hOxYNeMFOH6ztBXhzNSvO/BypdjnA4r15WczUXAd/bsgYFCprJvlDVxxE9McmnIoTf+DCDBQAXmrykBUKWw3DLtNPqMZ52hiL0QU8s4r125JoXIKTpmAdEkWZppYj/xxsbcRwxicjoNcYnol534A+IsbeWUVenABfPAcrPXuk03jhltZS1uOLFgHWtgZmUdZvi2WN+rz0ji2gf40yQ+wjdffFN35y9udMLaLJl1E8dzefB90CtN+QoypZd6ZNQuoOeMEU70CTbHnluPADZ80=
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
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Suggested-by: Huacai Chen <chenhuacai@kernel.org>
---
v2:
- Move the order check after hugepages_supported() to avoid a false
  PowerPC BUG_ON() (suggested by Sashiko)
---
 mm/hugetlb.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 779b1de33c78..b49130eb7ad8 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -4197,7 +4197,6 @@ static int __init hugetlb_init(void)
 
 	BUILD_BUG_ON(sizeof_field(struct page, private) * BITS_PER_BYTE <
 			__NR_HPAGEFLAGS);
-	BUILD_BUG_ON_INVALID(HUGETLB_PAGE_ORDER > MAX_FOLIO_ORDER);
 
 	if (!hugepages_supported()) {
 		if (hugetlb_max_hstate || default_hstate_max_huge_pages)
@@ -4205,6 +4204,8 @@ static int __init hugetlb_init(void)
 		return 0;
 	}
 
+	MAYBE_BUILD_BUG_ON(HUGETLB_PAGE_ORDER > MAX_FOLIO_ORDER);
+
 	/*
 	 * Make sure HPAGE_SIZE (HUGETLB_PAGE_ORDER) hstate exists.  Some
 	 * architectures depend on setup being done here.

base-commit: 74d73ffcffe03804f97e9fb82301dadf75671282
-- 
2.54.0


