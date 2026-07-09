Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 90B16C43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 08:16:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 89EDD6B0098; Thu,  9 Jul 2026 04:16:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8503E6B0099; Thu,  9 Jul 2026 04:16:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 766396B009B; Thu,  9 Jul 2026 04:16:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 507DF6B0098
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 04:16:27 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D8E001A03FB
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 08:16:26 +0000 (UTC)
X-FDA: 84968531172.23.F620345
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 4787E1C0003
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 08:16:25 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KuxHGu1V;
	spf=pass (imf18.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783584985;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=be/KDcZu0XNj3r86q48lIBlT1klEYS3GusmySQe8xtY=;
	b=y3YzUfYm6i68Kpq/i1pxZUMkJg431px2rVqIaSVdcPeqdMwQLdtVPrqvkJ+pSuFuyvd5ws
	heAVojzIXqj3pdKGJkw5eA2fchDduo5B6TsDDKl6CVvjCJD/RCEUPy+DffY08qveERIWQi
	UyYeURSwdWHhKZSHb3prHqyxUUuVUCo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783584985;
	b=C3Gd9XFwPdDs4PW3ZvjFHKkqK5WIKiCDVMsbqW0Dyj13B+XO4jdCFK7ytrjNkBLepazHcU
	me+rQsngGjE15DS8jWZgUK8sjyzWw3gt+SwAsAFQzgY1jEk50FzlHkqE/qbHbVXZ6l5DWz
	t65c62y4SqQoe5u6tf+X9oyD9DCT59k=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KuxHGu1V;
	spf=pass (imf18.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8DC9B405EB;
	Thu,  9 Jul 2026 08:16:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 212BF1F000E9;
	Thu,  9 Jul 2026 08:16:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783584984;
	bh=be/KDcZu0XNj3r86q48lIBlT1klEYS3GusmySQe8xtY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KuxHGu1VTFKY9Gufa7FXu5TZuiSoVKqknBTVofwvkw3zGVItEc4ax6m8wXnEJOTWH
	 IgGbhXq+cVnzjp2bN2W9R91kwKs0h58Bwq5HYMcIRrqPBJki2G2j7ZXGpIgx1NpCYY
	 Ca5Oa71jcmCvcEAKRRju6p02fSwUVBKoFa8YgpYdcWpFCejYU2QqdxlVpVcXaxO30u
	 +617JyzyIyaM7Qa2DnZPh5LptRF9hdbvIJfqDZuwd8m297dpvpqEBMJbnUfq5ImuWr
	 lJjDBObAZVViWExBAXKaOsEXRYZMdqs7sL4Z/iro7YXR1ApIrlxm0jxwlMVW/hgk5V
	 Y0+VNRyFuNGyA==
From: "Barry Song (Xiaomi)" <baohua@kernel.org>
To: akpm@linux-foundation.org,
	david@kernel.org,
	linux-mm@kvack.org,
	ljs@kernel.org
Cc: baolin.wang@linux.alibaba.com,
	dev.jain@arm.com,
	lance.yang@linux.dev,
	liam@infradead.org,
	linux-kernel@vger.kernel.org,
	npache@redhat.com,
	ryan.roberts@arm.com,
	ziy@nvidia.com,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	"Barry Song (Xiaomi)" <baohua@kernel.org>
Subject: [RFC PATCH v2 2/2] mm: improve large folio reuse for LRU-cached folios
Date: Thu,  9 Jul 2026 16:15:36 +0800
Message-Id: <20260709081536.82768-3-baohua@kernel.org>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20260709081536.82768-1-baohua@kernel.org>
References: <20260709081536.82768-1-baohua@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 4787E1C0003
X-Stat-Signature: uk7rc4zr5i3sgm6wo8qjjkia6rqxhmi1
X-HE-Tag: 1783584985-312397
X-HE-Meta: U2FsdGVkX187Qq5WoSXnAq2BT+RLArOkkTovdw17PRFL1Zg0+pnGPNpnuUW2rzdo3AGr/VxmcpZeooZyZxOCvlOaYJlfw2T7vdtH3aG8fqoBdJ9S9GqTvFf1U75x54vxlyiK001xpm6rikb+n7P1S+Tsm9SBhqB5noHAcrrejdfYTkHDXUGkb0jGsz5T3XNYnUqVlqCYkqNf7xj/8R8Nof/4owoEoWbOOzBUp+yikkTV7afe/U4YmdF1zC1N7+90Ss5NL8XDFEBgi2lFIVE8lMi9eg+R3flp88SnB2TR+Dt8TKFHFoB2NEtVGy9rCYE2MqbtVVf07aatT+rbiVr+5G2nx4ynXq0NLDTpgt9H3M7UNAggV+XWd1zSKuv8delKa2V2EKJcnQNoH/uRzG6vENEkAprpYBxLr2Vr5Uzqd/FSPEgp59srs1HbbkWxkt3TpguC5StNC82F+PDVFMFm8yupJXBe1AIS2CMeiwOIVzPQuEFpQdzRksMyu30o6bHhe9R2N9Dv+zBrwbA/XCmqX8GIitjcJTEvWwtb2u4UAilvQMh2Kh2HT+kv4wxD3i81SxUsUfrxueRWPPz3/4mLYB4iRNFdpluRaXr3ONC8Z5xWzmzEn/yrDqimWaJO8ewvGp6mwhdxsJljFEy3uPfSjQPlzB/k7BuDZeUL18CYXhRPqhC4wQycxYX2BLCXuWJeopUPXsG0ofY4ieh6airX5WNLJULrLj6iEOew3Yncmskbgan5FJ5krr5khtBAkuuz/XI8NrHl4Rl1UUqxd232tiD2VxFh3OyFXnUTMgweoWYCJLmwQENCLpVPw+4IzRp94XVq5Ee0O5ymVqAtPBCWOICCLC6ujr/UOiISwVozhB42whIKIv1g3NqWQL25mdCxQcMVY1b6QsCrCFZNWGoem1+qK7aZ04tuUlqkC71dJvTyrqyhMJ6g/kb8ZgxXoD8hEb7iUGiVJzJXiIb7sut
 jnc63SIW
 IC34M4DiIjtPMzfkOAYFb+7lfIX/k6RHofL1wlXvGJUtJQoEJ8cuK/CJFST/bGOTns7D0RGKIRthbTmO+nol0TQ7xIzJq5EInrgpUfsN4b3b/7sHYuXqAl3vmHALiREsTHWRTU9kqWIiZ0nmvgk+pRXx5aRSO5GJB58YcuE2A6l4Nw5wvwaeSfKLa+OzNXB4ITcQ1p3EDbTBncZ4PqwG5Npl9cCSaawyX5CXkOwd0cTnIr2s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Large folios may now reside in the per-CPU LRU cache. Before
attempting to reuse them, drain the local LRU cache, which
can still be beneficial in cases where the folios are likely
to remain in this CPU's LRU cache:

int main(int argc, char *argv[])
{
    int i;
    while (1) {
        volatile int *p = mmap(0, SIZE, PROT_READ | PROT_WRITE,
                               MAP_PRIVATE | MAP_ANONYMOUS,
                               -1, 0);
        for (int i = 0; i < SIZE / sizeof(int); i++)
            p[i] = i;
        madvise((void *)p, SIZE, MADV_PAGEOUT);
        if (!fork())
            _exit(0);
        for (int i = 0; i < SIZE / sizeof(int); i++)
            p[i] = i;
        munmap((void *)p, SIZE);
    }
    return 0;
}

Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
---
 mm/memory.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/mm/memory.c b/mm/memory.c
index 5689b7cff76c..1d08ed5ba99b 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -4136,6 +4136,19 @@ static bool __wp_can_reuse_large_anon_folio(struct folio *folio,
 		folio_unlock(folio);
 	}
 
+	if (folio_may_be_lru_cached(folio) && !folio_test_lru(folio)) {
+		if (folio_ref_count(folio) > folio_large_mapcount(folio) + 1)
+			return false;
+		/*
+		 * A global LRU drain is too expensive, but a local drain
+		 * can still be beneficial. For example, large folios that
+		 * have just been swapped in and fall back from
+		 * do_swap_page() to do_wp_page() are likely still in this
+		 * CPU's LRU cache.
+		 */
+		lru_add_drain();
+	}
+
 	if (folio_large_mapcount(folio) != folio_ref_count(folio))
 		return false;
 
-- 
2.39.3 (Apple Git-146)


