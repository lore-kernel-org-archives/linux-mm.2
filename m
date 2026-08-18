Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 367BEC5DF7D
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 22:59:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CDCFD6B0093; Tue, 18 Aug 2026 18:59:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CB44A6B0095; Tue, 18 Aug 2026 18:59:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BF1536B0096; Tue, 18 Aug 2026 18:59:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 973C86B0093
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 18:59:29 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 13F4280352
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 22:59:29 +0000 (UTC)
X-FDA: 85115908458.28.A126AE4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 81DEFA0009
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 22:59:27 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KxELYPG8;
	spf=pass (imf15.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787093967;
	b=drMHH6R3ikRjPzQoqOWUjX4SqbiE0SgmA+pVlh8pmZCRVEAyiGa/rzr9iAJ3Z6PVQIAOPB
	AzGqvvcTI4dXcpF4bOYszjfEirjxH2kAvdfMew2PnF9HvpD2Va3ySXZ+yI464f03lvX0vk
	bHXYlLYW45pTFGCuRSrg0VKiu6XZe3A=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KxELYPG8;
	spf=pass (imf15.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787093967;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yUofJYBF2fURCSwAJxaMXCKNOjPJX7Leg5CtfjoSIGM=;
	b=bKwTOtlc0q83R58grMibIs1R9LkwXL6Wr9q6ClJbnZy8Ai5nkJRr9S87XHUc6WAFGsP1Vo
	dT48cYXzPf7Scz+IWJB56vWmuemYC50IHO37Cpf7BwU4GgL2dJNYNOiLhY+R+L9kdj5M64
	sEONrL2BWGZT6Ae6P2BosRbUROHS8lE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1362F60A5D;
	Tue, 18 Aug 2026 22:59:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 253B41F00A3A;
	Tue, 18 Aug 2026 22:59:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787093966;
	bh=yUofJYBF2fURCSwAJxaMXCKNOjPJX7Leg5CtfjoSIGM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KxELYPG8qHof9ElVwEt5AvXIWstk4g2vuciaR9mz+HHHKZAevxhwpjn3PC7g+5b8u
	 idDhwphSoISj/ZtlrAzOg9bWnp4G0RCu8zsYDffKb0DboP5ViKLkO6cCETn7to87Zr
	 NanootF6LqHwSCIM1p4Rto2judFYjXHYmuKarh74Yqfc/9cM8WpI34vZ7thJbK5/yA
	 f69rD8w80OA6DT9AcwvGlMwKFFEZpMaDWV5nDb8DeSAl0ypHiEbeNzit20+cIYBp1R
	 xKllKcv8abq6uN1QYDJR5cPxORgjL07/2TTKOK8tjnFDAkSiun6UC0TYTzeqWT5EQ5
	 iIx2jSDEic36Q==
From: "Barry Song (Xiaomi)" <baohua@kernel.org>
To: akpm@linux-foundation.org,
	linux-mm@kvack.org
Cc: baolin.wang@linux.alibaba.com,
	david@kernel.org,
	dev.jain@arm.com,
	lance.yang@linux.dev,
	liam@infradead.org,
	linux-kernel@vger.kernel.org,
	ljs@kernel.org,
	mhocko@suse.com,
	npache@redhat.com,
	rppt@kernel.org,
	ryan.roberts@arm.com,
	surenb@google.com,
	vbabka@kernel.org,
	ziy@nvidia.com,
	hughd@google.com,
	ackerleytng@google.com,
	usama.arif@linux.dev,
	joannelkoong@gmail.com,
	hannes@cmpxchg.org,
	"Barry Song (Xiaomi)" <baohua@kernel.org>
Subject: [RFC PATCH v3 2/4] mm: improve large folio reuse for LRU-cached folios
Date: Wed, 19 Aug 2026 06:59:02 +0800
Message-Id: <20260818225904.55236-3-baohua@kernel.org>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20260818225904.55236-1-baohua@kernel.org>
References: <20260818225904.55236-1-baohua@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 81DEFA0009
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: 4j4d3cf9nqsb4q3u3ubgq8bw71ds35of
X-HE-Tag: 1787093967-271514
X-HE-Meta: U2FsdGVkX1/8Ns/by05r0dqibtl+Hzj5l+g03NFcPHTF+QekizNHHiNyIoigLBrXvB09tOH5ZFAvE/0aApBC88dhVsaCvFV1K4HmYV/4d8zmCHekNApyJJVvonwZX0NQy5oCKnhBXhtaikWdwAIF8KySDEjgg8jg/54vwlJ3ETe3xA24E8OG0RpnXBlMOKJmcPjUU6IPCqdlupkwWifaqjYdVT/aF/skSarlTPkBuvjZ+2qGw7X2NAMiL9yOTMj0WxLCRd8o/6mzSpVeLNzPYUlP2UNFGUtcQ5Uy1SZzZsoLbnflRowfZdwskizo93+pYiH8tOByjw52A1CaJTIgV1MbKzedFTZ6WfYzdD2huc/iiQ1j/P4TKy7SsfPW0oceBVIa0w3xAF3FMKedQHydsuFyOmv/GXPn6Rw6GeUnnmtbvJ75kpDeTRr95R/6T5oPQvjo2utYYS6C8ADxa9FD7MYZ0N19g2OAXwHKki+zOZXuWv7IB+hCGOzB+mcWoPoxTaFVN2U67Iije7aZ9Q28mS/ahi7nZPI/Sf7aFncYAsC6DSkEP6c03bkniNmi6YB4gCJ1r/duYahwKuMOoR8DBNL0s3Srl6m+ZD8tQ2JzSOFkB6n/4ZPl0zGX/Oj9N02G6kpVP8htZ6e6zDWngNqG4DAJoad2ZruQTkXPQdKxJFjz7Ubwr52UKaHif+odiUwvz1iDYcJvFf+cLfbeLDjls56G9eDBfqezcgUVokC6O7X2Ik8ATDboNF6GcxMgk4TtwinORH1XnySzHx5uKMZ6xlMedEFB6nI0IMuioqb8NeH4092SHGQ1X2LAwPPm+ylzH8SHKVNAUgIMBAsZITbWlNVS2KjdC2mHAMr7apQoCYZuaI8qHYpbUb4oXSRP7hmZodyjLtAw7cv+u0j8AlxotD/5PkWTLY5Tj1MUZBO0N/8BOSugMeXqetqEZ/cUHZG/vcFdmP1k6KqzkMmKNqM
 fnrNQ7Z9
 /yhNhmlLJAKxYYsm0eN+LYPR0vgtay0unRGY9y4mNLiPB08ZsJIdX/umUhHCsNiTRV8evFJdVxTJ2Dp075cFsuauWC1gx+ocuwwKvfbWs/Jzst5LVG1XiQ6LZ7+schU+JFV/KB8MthsN5nzMJOkyHakS6XNhFM15GDskJrsyqjvnuxUfKVsJ28agzyVKAbvoMzOMfpaPmMdpNcHAMURR0oNqHSTg66yXX94TgGGgRu9wFJtQ=
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
 mm/memory.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/mm/memory.c b/mm/memory.c
index 4134ac607ee0..efdf82b3c418 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -4275,6 +4275,12 @@ static bool __wp_can_reuse_large_anon_folio(struct folio *folio,
 		folio_unlock(folio);
 	}
 
+	if (folio_may_be_lru_cached(folio) && !folio_test_lru(folio)) {
+		if (folio_ref_count(folio) != folio_large_mapcount(folio) + 1)
+			return false;
+		lru_add_drain();
+	}
+
 	if (folio_large_mapcount(folio) != folio_ref_count(folio))
 		return false;
 
-- 
2.34.1


