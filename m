Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5EB45CD6E55
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 19:26:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3B0AE6B04A8; Mon,  1 Jun 2026 15:26:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 361536B04A9; Mon,  1 Jun 2026 15:26:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2775E6B04AA; Mon,  1 Jun 2026 15:26:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 15EBC6B04A8
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 15:26:33 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id ADB4B40751
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 19:26:32 +0000 (UTC)
X-FDA: 84832325424.26.7DC23D8
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf04.hostedemail.com (Postfix) with ESMTP id 8358F40008
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 19:26:30 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=pVr3UK6T;
	spf=pass (imf04.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780341991;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=c1KJ2Wwe3ucfE/pLWnGUXc+3brG6sd+o4SoK+rDcOrQ=;
	b=Tp+/3L1w/1aPqnFYfRjzppIDNMOp6imXPVF9Z/TkJbEE5bKDbud4+yNnJwqAPI/NUWNENJ
	NX2piUWcO6xEiII/rsZ585uU53ewE01I6kzGmXxMI/Dj9OcKKJMM5z97Kd1ZtqTxz4ENsf
	zKrceFQz/MdCm2AeKvhliRSCTHP9qoc=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=pVr3UK6T;
	spf=pass (imf04.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780341991;
	b=vP96BuWz4A9A6D0eE2xG/VVQ0fSHOIkP1U/S+fkDdC/nPbP2NZAEoXgkJINQ6V1PWFl0S4
	OCSy3/UcE7SGR7XzG43LoudfNkRpW1EN1qji626ZwFx0W6ahvw0mstmnjkw1p010jLccG/
	NDTOXT4KAneyTzZU9Ya37zpfbJa1DvA=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=c1KJ2Wwe3ucfE/pLWnGUXc+3brG6sd+o4SoK+rDcOrQ=; b=pVr3UK6T4h/0D/X6PEhDowRZa5
	3ke529BHpmBOlsRCOIjeWqpJ9ab1sK9cou2vPuLa0cUlOYI5k2QNwesxuG3PyqArcPJvHXCZmo6ov
	tA/AY9SR8sTEupLocLlYOedX7BPHxxA95xPDIDI/Bd9fFOcH122EfKvj45HqZFMnWNOijyMnTJ/Kj
	XpoAy+c/JMoXxsqEK2xLdJHAJ9dH81XlDCG8TE0a5CGrvidhGvMbuwQNUiwn5W9dfrz2yjlk+rxge
	ywR2bKppyST5x97vdb8Q9DkU+U665N/hTmf0XOYyjCNUV4xszCsapTojGOpby7Q9wX6bcsohpnq/8
	TrOqUVWg==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wU8HM-00000000dEa-0cW4;
	Mon, 01 Jun 2026 19:26:28 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 3/3] mm: Remove __folio_index
Date: Mon,  1 Jun 2026 20:26:22 +0100
Message-ID: <20260601192626.150804-4-willy@infradead.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260601192626.150804-1-willy@infradead.org>
References: <20260601192626.150804-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 8358F40008
X-Stat-Signature: go4whgn4oa9rm3da4oji9kbrfcu8ugid
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1780341990-911350
X-HE-Meta: U2FsdGVkX1881a6RhmMGPvQyjtliFL6sRNl+Lr4M/OZvi4VIbgx5yvjw96vVvZ+ze1TEWiZaBlFZd6smqoJfJxfsGemupIixuHxJsiK/dUgDZ46pQy2gHE4Lw9eGf/XeIRjut2xNJKEyCmvVAmRdeTO9DDwQ6lgoipw3CxjU06vunpxg98cH781Mc2wwPZZ1PjM4zg7zbov328ln0fJL5z4Pag9p7O4esQcrsNCpmRzt6VgQWvcy5f/Xb3qZjSkyNWbTzQP1JDSpQzXf7NqFv8k20ozDrI13ePlO4Q33mmIWIW2rLXz4++so6cb3BInTG2wQoubWgnDnLOQqZX5ahMsapvR+HyZ+loIyjmaA3feRqzfSf08CzLQB+T/Hv8xmfaaVb/68yeSySloJwRlj6y1f8+CVd9hw4ZY5nYdgTNcdKORjNXkbmZ3GPuB5tl8P/44vqXYhT+ZGdMybUtH3UL1yCUSMuAsRX7I1tJIIgELjntGDi12MDu9DEozoAtVkuD9h1UAscol/NY5PY0Lp2EHyQQbvaLeXY02D/9guyApnlDMJdmFQf4OYUAy68UcQLj1Y6rRD68zyLN1KaKDyihocIdjddh2Wdmdyah4lxD5zDwR4b2ZqY+rB59UJ7yPfHqo6YhjoSeSzOkD7hUp/Iksnhi0j2Zf9drzzTKXgCftWR3tTAM0Nx1Fwj3n8cG3N9IN7ikewcTtHzAjzDFAy6EZqnLXu+tUlCSFVSqJTJJAcYwG880YXfFr8EtzQzzckj2d/oeZjJUU/GWg1FoWDysMb9gv6EQcuknk+EE+gS4FHpvU17MnLHJxSHLGuqwBoMnpnh4+yvf7pvOaaIps9MAuFDEO8t9o+BTm2NJa7e3ahRhAS9Fs02mw21LKdVUcUbGsC21vVsRBFqYDL6AULI9nx70tAtFVlteZgmPDpnY+ipHWWMIKWVmPOEYuxsB+/9x8ZK+LDUwIwD0ukj1K
 jKxx+oKl
 oGGKlbA7/Lhgrip1hbm+rsPPsfwPfFDujqK8F/wBTPON0fZpHlnnif3MloYpJeN6xnGAi9gtD2nrImgTDQ+ev1E9XQCf8Mam5fBRusHLWSPxdL/vif1XuvIWzrEcnN1rMlXxMLO3RU9R6W+tthV+jNBwUL9AmprNe92Z6tOIB8jpnxFwAQ0MAafiTepUHUOCIgPW9rcNBPJ8yYu8SuYGwsTD2sOIbUKLsf/wykwnTkeSXX9K5paxtX+9Mcn9SpgnFc2HBJln4e71KgpboeGydDmwLK5oeAOKBbkFgGrPJZq8wewU7Pd75goJPd6OPm2z+N8GsuVnplrOr85s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

People have been abusing the existence of __folio_index.  Since that was
too subtle for them, use a bigger hammer to make it unusable.  That also
makes it unusable for the FOLIO_MATCH, TABLE_MATCH and ZPDESC_MATCH
macros, but that's OK, since we don't care what fields these fields alias.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 include/linux/mm_types.h | 9 +++------
 mm/zpdesc.h              | 2 --
 2 files changed, 3 insertions(+), 8 deletions(-)

diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index a308e2c23b82..8f8687bb80d9 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -101,10 +101,9 @@ struct page {
 				struct llist_node pcp_llist;
 			};
 			struct address_space *mapping;
-			union {
-				pgoff_t __folio_index;		/* Our offset within mapping. */
-				unsigned long share;	/* share count for fsdax */
-			};
+#define DO_NOT_USE(x)	x ## __LINE__
+			unsigned long DO_NOT_USE(_pad);
+#undef DO_NOT_USE
 			/**
 			 * @private: Mapping-private opaque data.
 			 * Usually used for buffer_heads if PagePrivate.
@@ -511,7 +510,6 @@ FOLIO_MATCH(flags, flags);
 FOLIO_MATCH(lru, lru);
 FOLIO_MATCH(mapping, mapping);
 FOLIO_MATCH(compound_info, lru);
-FOLIO_MATCH(__folio_index, index);
 FOLIO_MATCH(private, private);
 FOLIO_MATCH(_mapcount, _mapcount);
 FOLIO_MATCH(_refcount, _refcount);
@@ -612,7 +610,6 @@ TABLE_MATCH(flags, pt_flags);
 TABLE_MATCH(compound_info, pt_list);
 TABLE_MATCH(compound_info, _pt_pad_1);
 TABLE_MATCH(mapping, __page_mapping);
-TABLE_MATCH(__folio_index, pt_index);
 TABLE_MATCH(rcu_head, pt_rcu_head);
 TABLE_MATCH(page_type, __page_type);
 TABLE_MATCH(_refcount, __page_refcount);
diff --git a/mm/zpdesc.h b/mm/zpdesc.h
index b8258dc78548..194392afd3a7 100644
--- a/mm/zpdesc.h
+++ b/mm/zpdesc.h
@@ -54,8 +54,6 @@ struct zpdesc {
 ZPDESC_MATCH(flags, flags);
 ZPDESC_MATCH(lru, lru);
 ZPDESC_MATCH(mapping, movable_ops);
-ZPDESC_MATCH(__folio_index, next);
-ZPDESC_MATCH(__folio_index, handle);
 ZPDESC_MATCH(private, zspage);
 ZPDESC_MATCH(page_type, first_obj_offset);
 ZPDESC_MATCH(_refcount, _refcount);
-- 
2.47.3


