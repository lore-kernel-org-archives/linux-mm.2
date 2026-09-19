Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 13861C982D8
	for <linux-mm@archiver.kernel.org>; Sat, 19 Sep 2026 00:25:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 138966B00AB; Fri, 18 Sep 2026 20:25:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E8AC6B00AC; Fri, 18 Sep 2026 20:25:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F1A126B00AD; Fri, 18 Sep 2026 20:25:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C64EF6B00AB
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 20:25:03 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5C0FDA2A04
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 00:25:03 +0000 (UTC)
X-FDA: 85228616886.08.B4437DB
Received: from fhigh-a2-smtp.messagingengine.com (fhigh-a2-smtp.messagingengine.com [103.168.172.153])
	by imf19.hostedemail.com (Postfix) with ESMTP id 754401A0007
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 00:25:01 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="j KbVWod";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=W3Vq72TC;
	spf=pass (imf19.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.153 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789777501;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Tvadg5PnjaO+JyB3jIAGCIC7KUlwEu9asx5MUc98HYY=;
	b=AzbGO+GnlF0FnMB7su+hbGaXcQIgSB/mrgSF/V+q4jU2q0CgsiiiCgCxB2m8Lq/TBrwtnr
	jzBtxK/RbGM4boUWK/lnAO/CKHs2Le4GRU3nPtE8Ecw6ig8oTQ3Dxzf9X9bkILF9rjF80g
	B0MSABuiU/ib0wdKUR13FyLVFkxlPcA=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="j KbVWod";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=W3Vq72TC;
	spf=pass (imf19.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.153 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789777501;
	b=TXsSVJjJaC0bI7ws/8DIR7HFAnfWq9Qk7xDny8BP5x6+A6tJpDBVu7kdZxdcQL3M36SRSK
	+Xzw48N6WRgJeevezCknU5oMpPgmympB5ZIt5XRVpq8Cij4i85FLQp+CBLRcpKHYlDVrCF
	PJj9oXEFCzqVoUntpFAbhY4xUiRMf7I=
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 05F8E1400165;
	Fri, 18 Sep 2026 20:25:01 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-03.internal (MEProxy); Fri, 18 Sep 2026 20:25:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1789777501; x=
	1789863901; bh=Tvadg5PnjaO+JyB3jIAGCIC7KUlwEu9asx5MUc98HYY=; b=j
	KbVWodSA+B/CqaEXHYWQuWCYcGqo9M4Z8QzBSskiHvSL+vAK22rlxDcR6KlkKdZ0
	QjoGrQMdnGTPPmsVtlHLQ1mcbd+rm8KIYeYWPc1MmzqNH59+m1ozFMVxDQeolm7/
	/+0+1ek1ORfB297uPiv2ek0DLoyJHuTHg4o1hPTcsrJSdkei8bKfqXlgVnvT6jmi
	CVWak6Rb7CC8mHovQhhQInfGDOCLCJooBCsAsywyeb6/iBjF69665h901bMDsGkr
	AgBVhGLwHa28J5ubVohSb1tg7/aOctt6anmUFY1SKh9H2hGwhR3s+fJUt4U32Fhq
	0gyOd23dGUkYv/1G7IuMg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm1; t=1789777501; x=1789863901; bh=T
	vadg5PnjaO+JyB3jIAGCIC7KUlwEu9asx5MUc98HYY=; b=W3Vq72TCPoDtcf1/9
	LO/wUW7jL+c4Ugac5akCOHVcS7Fl8zRMEp42qpXrNjduFd7GQgVTO0JvAEkCtdOx
	B1CSZtp/90GAB70U95KD1Cp8fpOrxw947yQyGNiD517UH1mn6fRFHhdRAVY/cH3I
	9aMBgD1CvE4j1OcuboSiOgsjURn8cgjbtOU138BPiXj1D62IxXR3Cm5rcFixswaY
	G7N6XQzJWNX5QSZSlmHCb2WUjfRt2IKyF8Pl8Az5WMzxNpXBup7Zm1K5Tx4gXDs7
	HwuAt78cyl+6yyGm/4zMYe7rBddiOLhp6jZB/9KtM+DZNynC3+550dThS5xTtouA
	clt4Q==
X-ME-Sender: <xms:XNataggQ2K1TYCtT6oMVlJoPUvwk7xbsWnCuE0_FuIP8brG9S3hB7Q>
    <xme:XNatahacCkXGSGks3T_YNvhNxPj38gT-c94Hah22HCdRu7nOQiwqtLItls1ePuXAo
    Z8VYM1pgsC26s6AlqOen8knz1ydYMe9p5nMWGdt4t1gwLetb6xlqRM>
X-ME-Received: <xmr:XNataqSRzBACeyT5jIzCtfzstpDmcYzYXYhbYDKpE5yNPRowGw_fB2fQVAQ>
X-ME-Proxy-Cause: dmFkZTFyC+XeKYnZ766rqTYe4SsoatN0doBd7ADemiperjFlmE10ggdkgYpZeWmNOU4aBc
    lm02WEvCO2QGG+A0SGXMzCjVWjDSVCQ5WJ/xmSMbLZJLqVjt5aEnrGd0hUbHPJ/ejcqjFa
    xrmYY/YNxh9EpvRrTjNMqslNp6oZ1XKAjj0b9YUD/U+Umt4HJhNRFStrIx7jR3Gf+CAD8k
    /TwEvtSve0+WgA7utVqBt9LeXDUSIUkf7dn/1M9JWIyORT8Kp2cNKrwYutOzK/Z35sBm5S
    qWNICJAq9yYROUOkEgx1cQSYtjkPP2DMZwKGXS3JxTiE+xMdBmJUepOSBHs3/DvnVTIMtw
    2JUZNzO3XtQf+ECyivU8gCQ3mPq0O/nR21ASeZ8wiqHq4vhuDkVDXyGnAP9iZreBgRlzge
    o8gf5broCgxBPTKv3nrKR50uDlFFuglaz1fGUy8vzBMvhz3CZ6OSlQypTWvSZzsEiaU/4o
    /vqHgwJ7B9CCZK13xRRxEzM5MMMxO6H/enQdxkRnQ7uikJj4CG+itPt52BaZ36xp8454wE
    FCFJzVqQiitn2P2x+lWUgCwtbCLkYRMilzmjYE27ZH7R1G1AJ0EWccBAuJRREaYof+HH3Z
    YheCIwHzJMTP5O55u6B1tUhiw0h1XUCcf4Ec6xZVdhKuxvXf112wOlIZ0bVw
X-ME-Proxy: <xmx:XNatapGMgV69beMW2fW16yM1uYC_i9h0MrRCXpSP-aHYSVHTqgTx1g>
    <xmx:XNatav2I8D6KGzdEL1bq_SvgdiLSk9ZTC0ifIE0KTwR2jFx9Fi0qhg>
    <xmx:XNatavsAydpkzlzE0olx0cgKIriJIg8hLbIRr_Fz4-yJqBnVw_nisg>
    <xmx:XNataumWzPNhr4Hew437PGmWmB5vIOEC2oK-icmZ5Q1flS2IbwmC2g>
    <xmx:XdatakIEQXXeE0mJRjx3MNfgJpvDBUnafU08Xc-Xrw9wwSI5WLeh9Goj>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 18 Sep 2026 20:25:00 -0400 (EDT)
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Andrew Morton <akpm@linux-foundation.org>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: "Kiryl Shutsemau (Meta)" <kas@kernel.org>,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Muhammad Usama Anjum <usama.anjum@arm.com>,
	Usama Arif <usama.arif@linux.dev>,
	"Nico Pache (Red Hat)" <nico.pache@linux.dev>,
	Zi Yan <ziy@nvidia.com>,
	Barry Song <baohua@kernel.org>,
	Dev Jain <dev.jain@arm.com>,
	Hugh Dickins <hughd@google.com>,
	Lance Yang <lance.yang@linux.dev>,
	"Liam R. Howlett" <liam@infradead.org>,
	Michal Hocko <mhocko@suse.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Shuah Khan <shuah@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	kernel-team@meta.com
Subject: [PATCH v6 02/19] selftests/mm: skip collapse_compound_extreme() where the PMD is too large
Date: Sat, 19 Sep 2026 01:24:32 +0100
Message-ID: <20260919002451.496763-3-kirill@shutemov.name>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260919002451.496763-1-kirill@shutemov.name>
References: <20260919002451.496763-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 754401A0007
X-Stat-Signature: za7jj9nh5kwznbtgmyupix7h3ck35nyz
X-Rspam-User: 
X-HE-Tag: 1789777501-89227
X-HE-Meta: U2FsdGVkX198Z/6sIIiQaj+hXhl7YmR7CGQV8VQ8TK+0Gx4zyLGEpf4M1qO3B6nxKht2VmINdtwDH8kHUiu7ThWs3BRx5js6OP8gDX5fQlqsx4kLyPhFFck+GbY+3tJneTI5iK78WiGKWeHnB8Vo0IFPDC6n3O1sU+/dMAQaQhqcwlvS1z6LHYqigHaX8YxTFy70gO1fs2xBZ2Icmf2xFiNZ5I9NZccXCPk1ja0/3wz2HybeAwgtjAPYpp1DEdEejr/jziO3TNJoPBt5YfNsEp24yy5/bQ9JfT+0jKOwrZ4eq1F3yd1Ny/nengCUNeQJxcTvvC7qLkbcNftnoTu8k6vJ8LIj/zxksdvGU0vHJG76ixFJxlIpI13oJj1AGSH39InTAzjMwIOB9g8Al4iq7DgGrN4bpYl7zXKTHNnqG58JyHAcckBpmH+O92fVUDCm50WvaWWAbWKnqv/6ndLEyRhM3im1BVutqEqn0BT9n/2TBjVJCrkua4VgyoHTC+1F0EmPplV7gRKu+6m9Mt63DaFvxijIBffyBmzQDdteNo+59ehi7HcBTrfQLM3nv2gyS62ClZnoXL+b5que3noiIVg/LwOKiCtgk/U4Z11/GYDth75q97YMZb25332ye1cj/H7jN5bhUfzaqEW219ZHrWGVe13zw4EJ/2Lwafjf8/1uSL/5dvO7AvbYYZDU24fdnkAXrOME0j2s63lilUZFdIvAbBWgzynf3LcuDKe+9AiRxcCQBLMvDqMA5nWuU7YtLQaJ4q/sHbeDs2Ck0NUH9ROyN+lWI40r7Ye7Ph91i5E7EvqxzbjxBpt4jFyXOA2i+VRcJlwg5LwuH9ALkxzeNYQ/GWbxDoWbkhgKPEwBjTwaLSQo0JvlpxrlPntESTAQCZqSIPs2gPMiyDVIPOGZlWSr2s/VG+l6eH7nmnnEIjviZlaBYSLLkaDdWiIh6iv7iJOPCk3UII1l9pMN9Nw
 aJrvTT24
 ok+PoR5Vn95SVBuRSSweGF0TAgoaHyT8i5ulu7Ot2YV/jSIEy5a7UxlrLYaQomdnKHERE0oYWWeOv4RR1XvxyKcUHcLg/UsSx+7hR0dmRYHaaw4Y5H67aWodBsYE0qZN0J0VldDUQJU35zum11qIMTef1xXSmS8xbCojOLTna5dT+JXZ+u+GkQ8cjn5ZDhMMexr9LHNN5XF3Io3rG9cSlQl5HeqKrzORlTtTqdpB/hocgbAi3nRfGoPnpB0OyjKjfeRpiyzLLS202EZYGnah/004cuREaCaSxP78RWhBG+HkKRS18i5fDIidFjTyTF3iimQsSO4+EpDRF7PUNmDws3g3qWY4j8mHEg/lxadrVuPgQ+3l7tGafTywspa3W607H6F6TQzq7OGawtEU32h+NHeZ6iAULRrd7soIQhqx9gOqK+j/XyoHHDQdco96vdEnbvN2DAeUZW2VdJEx0pCamHTDV0K5I2tgjH1tT/EOV/zoCd7IYhzgLK1P8I5FFsCCeCZLZNVq7RorC1aBRj+R0DNBYxUPsXAvYlI0MZ8GT49arUvl9FkFXev9v3/FcGhOlbGhCTRl37BhTBUI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

collapse_compound_extreme() builds a PTE table full of distinct PTE-mapped
compound pages by cycling hpage_pmd_nr fault-time THPs through mremap.  It
therefore needs hpage_pmd_nr PMD-order allocations in a row.  That is fine
at a 2M PMD (4K base pages) or a 32M one (16K).  A 512M PMD -- arm64 with
64K base pages -- makes each of those an order-13 allocation, which the
allocator cannot reliably hand out even once, let alone 8192 times.

The failure is not a quiet one: the case calls ksft_exit_fail_msg(), so the
whole binary stops and every case after it is lost.

Skip the case where the PMD is larger than 32M.  The MADV_COLLAPSE cases
still cover PMD-order collapse on those configurations, and 4K and 16K
PMDs are unaffected.

Assisted-by: LLM
Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 tools/testing/selftests/mm/khugepaged.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/tools/testing/selftests/mm/khugepaged.c b/tools/testing/selftests/mm/khugepaged.c
index c44bc18f7536..8a6d708026b7 100644
--- a/tools/testing/selftests/mm/khugepaged.c
+++ b/tools/testing/selftests/mm/khugepaged.c
@@ -940,6 +940,16 @@ static void collapse_compound_extreme(struct collapse_context *c, struct mem_ops
 	void *p;
 	int i;
 
+	/*
+	 * This needs hpage_pmd_nr PMD-order allocations in a row, which the
+	 * allocator will not supply if the PMD is very large.
+	 */
+	if (hpage_pmd_size > (32UL << 20)) {
+		ksft_test_result_skip("%s: PMD too large for fault-time THP construction\n",
+				      __func__);
+		return;
+	}
+
 	p = ops->setup_area(1);
 	ksft_print_msg("Construct PTE page table full of different PTE-mapped compound pages\n");
 	for (i = 0; i < hpage_pmd_nr; i++) {
-- 
2.54.0


