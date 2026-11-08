Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 21B0F606A322
	for <linux-mm@archiver.kernel.org>; Sun,  8 Nov 2026 19:16:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DWRYdLW0
Received: by kanga.kvack.org (Postfix)
	id E29D16B05B8; Sun,  8 Nov 2026 14:16:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D65236B05B5; Sun,  8 Nov 2026 14:16:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BB6A46B05B6; Sun,  8 Nov 2026 14:16:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8A9FC6B05B2
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 14:16:27 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4EBD41C3CF4
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 19:16:26 +0000 (UTC)
X-FDA: 85412907972.24.51434C3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id B089440003
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 19:16:24 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DWRYdLW0;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794165384;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hDPWmvInaWp2wgeM0od2Li5jTmlC0VSnDu9Tp3ujlp4=;
	b=S+sszYIi9fUxedWYCEHNwTUiIk0by3wEa5mG5SB2lH7t8JoRus0QtDb0tn2QnhY22hjhJG
	7IK3/la65qOuQicPvPROJuDl+gpYTbw8nU7d5bcQzUjNKcnL6HMYfDJunab1y+GKwdFxur
	REIUsFvA/bDH8nMDxpytWmrX0kseNDs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794165384;
	b=ATlCLtno4xRXCKylS9cQsX/P/slmK0vv9aXCd6esyZ7O/u7N/H61oHyMU6i+8i5Q/Ct2/l
	2laLhAoxTGW78Thazspe075nEJZIEh1BAkrWLadVRs/HWRNiv6D+Fo5m/r8/S755fR5CL8
	9im6l3+r4GLuJeO5GYxIntDGGX8lb+I=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DWRYdLW0;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id EC15944464;
	Sun,  8 Nov 2026 19:16:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB0B51F008A1;
	Sun,  8 Nov 2026 19:16:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794165383;
	bh=hDPWmvInaWp2wgeM0od2Li5jTmlC0VSnDu9Tp3ujlp4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DWRYdLW03GiWffLovga+Iq0EPnZ9NHj2rUQxCvGN/uZLj1mfIAYRrpUl63hEZLGh1
	 De44HsD471r11Pex1jM0Ayr9muj5myH/MAjuPC317KyAjisdknFpw7azOJP8AZrScv
	 3f1GsSNjhIF6kfVuSSMSXHRFSgP9J9DBZZlYmxKp/f1Umm7+e6icYYu91JAaHFl+DC
	 JthQKu6mwILUWW+7kI6FRkmGeGZImX7V32AtlPxZCAZl1VsX00VVxSPFXJboSKZWRM
	 mVGQvffWVcr8T2vQ06WF83ogzi7Cl1xsteTA5hpkKK2FwrJXvt4bB061o6p1q3bqpP
	 kGG21wZE41Unw==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 2/4] mm/damon/ops-common: implement DAMON_FILTER_TYPE_ACTIVE operation
Date: Sun,  8 Nov 2026 11:16:12 -0800
Message-ID: <20261108191615.113362-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261108191615.113362-1-sj@kernel.org>
References: <20261108191615.113362-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: irfh9m814tqe63c3i6qrhjg5fychisqk
X-Rspamd-Queue-Id: B089440003
X-Rspam-User: 
X-HE-Tag: 1794165384-303658
X-HE-Meta: U2FsdGVkX1/0W/VSPY6CNn/vM0XA2AXb6UzVPHqgvMqHoErUxh6CBhC02MJ51pUV374iuF5bmJjOy7dcNQ7R1YpUjEhY7nE/4aTfnOMb0xKCtaQz/pfXhaBdhZiEIJNIQNtixHi3+xcIGfJ4P9+Xis50KUsZCwAshNZFG3UJaUkextqzPQyKToR6EhENKesjAzCXr4NQ2pqxa8lI1IoujCfRvZjrnXGtxsHMl+QHgoZiOzKBaKjiuOOVSUPPtNdUUw7oNm+pcR55mkdQbpJHpaZUPY5MZOCQUfZkegUP+el6GzNpQIYTJ5XtZpAECiDUvMjeNIOLh5nOkYM6SJo32FboY4F6DFnjeJ6AA6FtgRowp9MQQcV1S9zYoNkg/IqSi7PF87PFxzsM4ymVyODuy4sf/ytyIhpCwJuRv1gyQHYPl78wbH2yRIo9rruOJUtannBsLMtV9Oh/WODFQSB6vU076Zt+7zroSQ3UiqsHdX6On5JdJraj89CwybjTsTpH4f6T2s1/662iFK1ZRNxoJQDIrC910ByYiTFl3q+tsV2hT+QN+Q2IW74mPqVcKnoCxtOqu3/dIfOquOMEp9kMmEiZYiRU3YG+we/Sn1jz/d3ukh+BDcpKN0Y/nGgCCvEJD9Gc6blQ/c5aNh/QlxCEmYQYIhuYG8YnyZusFW/qDS7De3jSZAR0RIcyph3TH7FQnQyJQnVXS73o2MziCymTKF9ZjgQUtgsALc5mkjDIrkYO+VBVdvfqj039z5o3pwkTlSdOllERTrc7xC7Cty3shFwpdAY9he1o0O5TS+1o5+8FYjbtkSvxF2qHJFyjvQLmRAw1CBnQV5wun4FijfCs69KfSgJ3mm0bEOXjSYO9NtzOfCRVQZGYiPXwEd9TnJv1hXGkJqgv/TGBYoi5OECohB8GeZD9D9JkxdOg77CmMK9KqliZMIM85DwkBE+lVsOwW3L8cyttdRv1zOhBEuS
 ot5MJ6pu
 rssPcZq14b3xcQ29SdAFlM91w2tO2yCQTaSfiTL9ns7ydtmYVzpgPdwo9zFsh+ghVHorcTn1vDeCeAldKq4E+9A4AG9nkLgbXdQqSEWnsIsjl7ct51kWJpdyOhKthnnS81PGJCYKpC2iRCkjv5cv7ZcOSUXw8m9ApqerJPbwNmUt9E3B0aJj7T8Jzb5QQ31elCIQUk38OgTulNueNdKauKV/2zFe+V5Fr5qNh0RK6NIocgmksYvTydrhoVpbT4yzBFF+8NHdFdQxUW4NQsyUauTJtjQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Implement DAMON_FILTER_TYPE_ACTIVE operation.  Use folio_test_active()
to show if the folio of the given memory is on an active LRU list.  The
implementation is made on ops-common, so both vaddr and paddr gain the
support of the filter type.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/ops-common.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/mm/damon/ops-common.c b/mm/damon/ops-common.c
index b9571f53e538c..2216a0023154f 100644
--- a/mm/damon/ops-common.c
+++ b/mm/damon/ops-common.c
@@ -574,6 +574,13 @@ bool damon_ops_filter_match(struct damon_filter *filter, struct folio *folio)
 		matched = filter->range_min <= folio_sz &&
 			folio_sz <= filter->range_max;
 		break;
+	case DAMON_FILTER_TYPE_ACTIVE:
+		if (!folio) {
+			matched = false;
+			break;
+		}
+		matched = folio_test_active(folio);
+		break;
 	default:
 		break;
 	}
-- 
2.47.3

