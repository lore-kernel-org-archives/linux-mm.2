Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7532CCAC5BB
	for <linux-mm@archiver.kernel.org>; Thu,  2 Oct 2025 03:31:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C73638E000B; Wed,  1 Oct 2025 23:31:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BFF638E0002; Wed,  1 Oct 2025 23:31:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AEABF8E000B; Wed,  1 Oct 2025 23:31:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 9626B8E0002
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 23:31:49 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 56D9F1198A9
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 03:31:49 +0000 (UTC)
X-FDA: 83951749938.27.4A59E6A
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	by imf09.hostedemail.com (Postfix) with ESMTP id 8F36D140003
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 03:31:47 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=iYmkft9B;
	spf=pass (imf09.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.49 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759375907;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=Rufg8oIBNQHsD1pfje2BrG4IcAIpwo+nq+Bk3IAMT94=;
	b=bQ34Tho5p0zOZXswkBFx7MuWpGAvyScCXqMQZ9xKUZq2NkShtRo9CW6dLuuBo9zQeUXOMf
	gQ+lYdLlnghQWBRpEYuPIowkEsAfe47X9cEpMm4wV6n2WJC3rcwQYV4jZeaOJQCsVybJIv
	5m49QlvNRvnbEfWwUN9LUmoUlA+8Jqk=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=iYmkft9B;
	spf=pass (imf09.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.49 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759375907; a=rsa-sha256;
	cv=none;
	b=Sawf039JFWFNlawqUoG5r3JXTuRuwSB/Wk5phALdrbPOe8fOhNzUGxtZ28GN8VaZN+fSyr
	imjSCrWcyVMJliKXHsC71eMAw+nbCkuvH9VsZ42Wb2D0D/h+WKwZamth5dyaxMbj6+A/TO
	dGDkR7Q5vDxv6/necKzLi1S6k61f3HQ=
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-b40f11a1027so108018466b.2
        for <linux-mm@kvack.org>; Wed, 01 Oct 2025 20:31:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759375906; x=1759980706; darn=kvack.org;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Rufg8oIBNQHsD1pfje2BrG4IcAIpwo+nq+Bk3IAMT94=;
        b=iYmkft9Bm9eOc9RYWHlIwiE9n4QAWHe6I6ng15kwt94cRcz4I5ryAxLamel+ywPXxu
         ymR//Gl5cFE3qt5TO94H5y3ublTL/SywkfcuTL3jeB78GH+zWYcRENvJ97CI+iHJv44V
         dlmgngUiiNwn4yZMtkSnmULt+TOgEs1/qxykdJD4jlGca6Lc1WOSIbq3+MCQ5cCwrS2k
         8Zx0CDfiIYTYGn6PqzeT8W3nAlNIEc+1lAufxP8u+bgNhRsYTh3WLLjL+i91fhAqif/O
         wpKNK3S6t0P8eG2s1tDpOhy79VQRo/AQ24uW8ONUzcBnMgr9H/ZDOAmOkwZWdxVy/UtF
         Ywuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759375906; x=1759980706;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Rufg8oIBNQHsD1pfje2BrG4IcAIpwo+nq+Bk3IAMT94=;
        b=rlMAc05Ac/5u/nA6KmtjJYqO9/rLxpYZ1e9zHT7H+oySvKf1S0C1qcdgC4pe7iSB3z
         mUi2dglrMNsUd69/GpFDBK441yURZAnpv+w3VkYQMTYCEIvhNiRsYu4rNNS286H31y4c
         5simhF7x2JOJ33GIgGiuAvemaqfwv561ydPAGra0gN6o1eavx9xiZUm9LraVvgJXTqlR
         MMBQeBvXcQm4HnA5bnQLu1/pBerk+VoaHVTBNz7YRX4NHxXTGAAoS234rIbfXf/WGBg/
         h+Lgqb4YkN+euSQr+DwIcrWlhFAKx45w9EFSluYJ3ZzL3evl97AYX3dwMPR5OZNN2FGJ
         v6XA==
X-Gm-Message-State: AOJu0YxzkquZBeuVG3bnlegwOIIjc1WdVpMovkY9jtUdfctsttlx/Fxe
	wgJF7kX2udwVLtjX8alktPhIUH48JYN11aW1HBRIii6YquiE0zAO/GuH
X-Gm-Gg: ASbGncu5TdsjkoHZ+Gdm8ESbLmRdA2WCO3j1qRfQ2UtmVatncFwS83PpjQDGYx6QOlj
	ehpVoF9oB7Wimh2pVhKmsS7OzxFdfhcdev2aNFcvuM9E/FIRsYtZ9lSp/v9rtewx3enMI6VoFcL
	LxkVn5l0mIqiz7mtSzhx4ExW8X5Lxr7a2sW3t53OXZdrz4QvPcBiTNQikwP5aldWAt8x0ZFh3uP
	GXQ1caikvBuMkAAn1rQdNfr7to3FvwGHL7oyZXmt3PGZOYg5ynO9Av3X52QKJFOuwckJuBc5llb
	3DEDhXI16AIh7izM5YcSOze/8mF87tGzxVytOqdFKFkI0JAaxoNjvQ4SC8rAQxjgOZQqQBBYTdB
	MTOhi1sh+iDIgyYjua4YdB2iTdqT9QivzZ/m+FQTtJIyAlqDb9Q==
X-Google-Smtp-Source: AGHT+IFJqILO5ZG8t0gtkRLYTkkTle7jH7h5XXwswU4DH15BdPQrGEgjzMk7ANTqOp5tkMCc3qvafg==
X-Received: by 2002:a17:907:1c90:b0:b43:b740:b35d with SMTP id a640c23a62f3a-b46e9765d7cmr716205266b.33.1759375905889;
        Wed, 01 Oct 2025 20:31:45 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b4869c4f94asm101834166b.79.2025.10.01.20.31.45
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 01 Oct 2025 20:31:45 -0700 (PDT)
From: Wei Yang <richard.weiyang@gmail.com>
To: akpm@linux-foundation.org,
	vbabka@suse.cz,
	surenb@google.com,
	mhocko@suse.com,
	jackmanb@google.com,
	hannes@cmpxchg.org,
	ziy@nvidia.com,
	david@redhat.com,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	rppt@kernel.org,
	iamjoonsoo.kim@lge.com
Cc: linux-mm@kvack.org,
	Wei Yang <richard.weiyang@gmail.com>
Subject: [PATCH 1/2] mm/compaction: check the range to pageblock_pfn_to_page() is within the zone first
Date: Thu,  2 Oct 2025 03:31:39 +0000
Message-Id: <20251002033140.24462-2-richard.weiyang@gmail.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20251002033140.24462-1-richard.weiyang@gmail.com>
References: <20251002033140.24462-1-richard.weiyang@gmail.com>
X-Rspamd-Queue-Id: 8F36D140003
X-Stat-Signature: 8yajzmpo7nqomj4ow1nca4fu8ie7gxrb
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1759375907-135070
X-HE-Meta: U2FsdGVkX1+WV25GTtI7/ee1GpbGdJDfNpHX/Gtc5YcmIOx3MYhNIz2lacY5sBcTCTi7CWg4L6EL6iWlTDqkYncGXSNsgKdbCV+00zEFb7sHrMwufS1vbVmaoJ3DZ/Ob/bJgeLLUiYQlMj6NOKL6cA+wb6+Um2pULT3BkN7G4vR9FoZ5btlGk/ABOaMP1WxyDdVB5QJszG+OoJwEmu0iI5z7RqR+jHirrUcbUzu3xRJwrM32cD3XRUCTBeEJZGj42qT9tomAS1uMw6xDd1VQny8Hoi8Qf5ldQj2xJ0IEsHg9mIDp7iPceK53cvf9biRcsgxivdXiVLCbIK09OIrA8WqVxvre78EchjOonc8hyAOJ24lR0HV7idjWMD3XPOr2LlM660C12wPcdVw3cTBwc+UbvJjQUVlxC0fKibcpjSX9Shf+xU7d35CAfSh2DVncoZklV70d8PY2rHPv61z6fH/Z3rta+zsKx6ZUcr4vCkYNTzQScjvsazCHG84P2IVhNrMkZQMr1js5YDzAP5ONetbql9qfS/P24lY2Qycre/oHIAmswg26in7gqVAfDdxP4G/j4ckj1E304ZKj0qLe8B2sW9bw2gSZxL4EXpuOXjf3uqS7CBGjZgmBvksrzleW4QHw9doh8bgJt6xljfHPHJTJ+GTKZAZGNLyanHVR0PlXzOZMIyBzv3pSbbbeCV07dleKWYN3J0Jl9CUpGKdIGyZD73017RxWkZ9L04sepJvV8WBNZNJ+14otUc2MwtmmaIFAGeGGy0zFW78hUJcZkWQm/3XHz8bvjUMECKlnSqvhEDZfvRRmKAsfsjDv0oXik1++dJ/E6yg0AlqKUOLFLeN+4h9uBqmqQYX1TATv+erdADZODFRFYwUxcsdSlcDhW2mmCMu3izp9XM5WdjIhcf7RNJo0r64xe+B1yyK33/0FCviJXDpIGuQR0ZuwU6QBuvLdpyuPgVSdna5l8BW
 dzy9sivF
 vK3PSFWVXVWgex2JOTo3BAcZ9jtlYkWdEGXVxNEyuw9TmeWWlpOqEvHzDFwI/ciK6VsJ5v2XWtyMfQ7eN7TK+vnIPw+mN/V0IUHFv3WiENXQXqEbPUdrpO4YHD06IdgqK6XkHObe0mzzpUOVaCN2F1e8oFH7Psb1oVULdpyiQ4iZSawdnJWiug3vt7xMcD+U1HfB3UbueLOh4bb7lFABgxG/n3ttmtsrG+MjJWBdx8MJriiYGQD5Mbfc5XfjkYP/Lr87ltNutJC14p7uewlxgAe5RbuidsuN9W4wL8sNZTRqeB1fO+xS5zBqwXohig/TtGqYc2AsOBlTF+jUUqoSCBWTUG5tuEiuasz9t68vIjUzQ3vMRndADiJIWBIDadl0BdYnQiOPmecQ14BNkzXJdtrLODn+P6CvEcbQA5wRGnOnuDaNnynfj6GEz10X76NQHcC7UHloEXLNTzim+5jhDYouIE9IdtGw3k6Hp/JrugGM6nKctRZVQkqgcoFQ5eBK+3EfjoY/X6Zdd4npbGd8xWSf/0EKnmD/Q5RPisd0cJ6I2Zk3qKGMzb5+BnQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Function pageblock_pfn_to_page() is introduced by commit 7d49d8868336
("mm, compaction: reduce zone checking frequency in the migration scanner"),
where there is no requirement on start_pfn/end_pfn except they are in
the same pageblock.

So at that time, pageblock_pfn_to_page() would be passed with pfn
without compared with zone boundary.

But after commit 7cf91a98e607 ("mm/compaction: speed up
pageblock_pfn_to_page() when zone is contiguous"), pageblock_pfn_to_page()
would think the range is valid and in the same zone if zone->contiguous,
even the range doesn't belong to this zone.

For example, in fast_isolate_freepages(), min_pfn is assigned to
pageblock_start_pfn() and passed to pageblock_pfn_to_page() without
checking with zone_start_pfn. And mostly, the end_pfn is not checked
with zone_end_pfn() before using.

To make this function robust, check the range is within the zone first.

Fixes: 7cf91a98e607 ("mm/compaction: speed up pageblock_pfn_to_page() when zone is contiguous")
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
---
 mm/internal.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/mm/internal.h b/mm/internal.h
index 38607b2821d9..8e1a3819c9f1 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -724,6 +724,9 @@ extern struct page *__pageblock_pfn_to_page(unsigned long start_pfn,
 static inline struct page *pageblock_pfn_to_page(unsigned long start_pfn,
 				unsigned long end_pfn, struct zone *zone)
 {
+	if (start_pfn < zone->zone_start_pfn || end_pfn > zone_end_pfn(zone))
+		return NULL;
+
 	if (zone->contiguous)
 		return pfn_to_page(start_pfn);
 
-- 
2.34.1


