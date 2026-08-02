Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 624A0C55162
	for <linux-mm@archiver.kernel.org>; Sun,  2 Aug 2026 19:54:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 66D436B00A2; Sun,  2 Aug 2026 15:53:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 645396B00A3; Sun,  2 Aug 2026 15:53:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5346D6B00A4; Sun,  2 Aug 2026 15:53:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EA8B66B00A2
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 15:53:28 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 75897804D7
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 19:53:28 +0000 (UTC)
X-FDA: 85057378896.21.8CE7D2D
Received: from fout-a6-smtp.messagingengine.com (fout-a6-smtp.messagingengine.com [103.168.172.149])
	by imf29.hostedemail.com (Postfix) with ESMTP id A02CB120004
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 19:53:26 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="s xFVV3C";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=NSpTRmU+;
	spf=pass (imf29.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.149 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785700406;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RZMR9To8koVR0ozlGuqUF74GOHYuMZBcuhN135RFhM8=;
	b=LaRYSAW+lr6fnWUSAWUad34mgNf4N89mnReeCIMgfO630eVAySF/UEtSF5huimw0ackgIn
	I7ea9OVRqTMgKJ7C8u26uMGMcH9BqEi3fN77p1Fq2cfXFc0kWQKkTGTjLmpNZa3V2mlI8I
	b2QIVdHMaXW/P8PRlQX4vd9BqFU/4QE=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="s xFVV3C";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=NSpTRmU+;
	spf=pass (imf29.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.149 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785700406;
	b=huhfFTWzKh0uTwhtzzzu8omzrR5DQkb5iSW5UU2nEqTgfhZ+37yjfUay8hK6yG6NT/n4VN
	aWQkggSYTohSNbXPMRaeEojwksGtXAyCTIcwY0X/Gn80BI/F/jVxkueo+oCch/2mT8F02I
	3QkRUXbCFyQJTLfnQURMrF9w+gznNmQ=
Received: from phl-compute-12.internal (phl-compute-12.internal [10.202.2.52])
	by mailfout.phl.internal (Postfix) with ESMTP id 4833EEC001F;
	Sun,  2 Aug 2026 15:53:26 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-12.internal (MEProxy); Sun, 02 Aug 2026 15:53:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm1; t=1785700406; x=
	1785786806; bh=RZMR9To8koVR0ozlGuqUF74GOHYuMZBcuhN135RFhM8=; b=s
	xFVV3Civr8W4Sm6v+k3T1ur/Fehmz1wu5+YEs+OpJ/CjQP6xVH3rakZYf9WeAo4T
	mpaXBGKHwickFAr1eQELYW1hije+5eRjlQhRhGDJfhuiyPqLLyQXCjZe/G7tOO0p
	gBiU96CIqHs1ReDrG53/8Vo+zj3t0qXFqhJviGYQaFmuMatMBRjntEufRxQCzBWG
	My0pDO9bCBrDxFYkP97sSu8F/4yVmcwE096XsDsMgBleOVHKR8pfGhJsdHeg0wQa
	b8JwzOSkP/c3n+Efd5txCrXHzN3xWWbH0kJ9Ks+iS2xSZPt1KV/4a//ZN+j+hk1p
	PJVJVLEAGm+586YH6E7Qw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm3; t=1785700406; x=1785786806; bh=R
	ZMR9To8koVR0ozlGuqUF74GOHYuMZBcuhN135RFhM8=; b=NSpTRmU+uLh3MB/6E
	507fh5YAKwvX1CTAqfZF7pk1rlEcSCvw+uJeAooRjkT4ZO2qZlNZhg6/cYblmQVY
	4HMMAEVj6apavFviqf1y85SjYu6sS3E2hijwzob2Sf9emcclpR0UacENRGiwh10M
	UudXIVgEwBGmR8T64b74LUc17PJETnbDjvaM8vZxzuJvptZDOmtlLQ1liH41y0rO
	PXRQfJEY9W4wWmPFhaSamIi6oMbfEREYB7jq35p9SHYGC4fh4R7Q7sNVav7SQ4ig
	eYDyfh+2VW3w79FFFipn/Mo8guczxv9i5B6IE94OP/1x4AQIr7A+tnR76DGh95n7
	8fUFA==
X-ME-Sender: <xms:NaBvattvY-GWTUXdf8CYQUG-am2-yQWorrIzyxgFHDQp0LcYyU9eLw>
    <xme:NaBvag8KdQDB6yOLNoW70LJCl91HoN8s-co_IDGwD-CXAtetn8YiWd5_-5MBWvXtv
    KA-IwlLvA20UjvS4rXrrWTdGllNSvMTgdNPNOjxngCZDnLmZamLG8eq>
X-ME-Received: <xmr:NaBvattf2Oa5XvUiEOGPV9OkY03VKJHtSs0ShhlK-6kdfLd44qgU_tLkmjE>
X-ME-Proxy-Cause: dmFkZTFcbv35QwNbwWPHQBcJdrWasH4YRFOBaNWig98oa0GgLD3LmQrthvyDgK5JnDhp96
    dBkNywOXlTP9Hby+cm0vRQHofuB4BhsdtVcBrMer/A2AOpegfr9Hr7RYzI6OqquxWhxeXC
    aB5bOw4cR5G6EDzO4v2r94SJnXRDYvi2NMwyCB/quID+suEuw0TjLUMYjjQ5pFm1F3OqpQ
    Ctej7rOharBpUeBz9hjZojzUlseCYYYMV+BulSa6+jD3O5m4ZOeULsSyQlLb9bciCyrhiP
    bT+z0cGYr8PFizBGTpPnPZCe+jZkx/DQlEsoaoSV2SjHlZpE6q2+n/t1AcZaLqu1qPGmpu
    ip4XUMH5XVLjzf0IyhU7nep9P+nlGRQBRreBEgwvXRs67QkZeK9Gmz2zBZg2RKa00u3uu6
    7gC+UVdjdeDtkGj/sLdBd8qs7uz4dTfnFPvj0zAUyAP+4VcH0urtzCzw0jnvCmOiKBLy/g
    edZwSCB6w7MNUYSIQ5swxIIWQlFKG4xU0V9NepiEx72r9KQHpctpYaXVpJB6jHPOSTM82e
    oKhkRKZBvWXX9WwcxxS/+dKTUnFPDX9Ea6K5zIbNOLFFpVlXMrdNegc7GaNlEk2RFEBhnq
    ogxJ1urSAV0BPpw5IKope93csKKmM4b05PqDvET00/uOjtX+g50OCOI+SZLw
X-ME-Proxy: <xmx:NaBvam5ZkBNp-1Gk_0DppdhZYsUmsN1DSRr_QKiDtL0YD5Xv1oxZTw>
    <xmx:NaBvamMr9a7ioiWcJyq2zndixAx42wiUz-quP5IGlQrtbFHPc9M18w>
    <xmx:NaBvaiLC2rL5RhMGnbipaOtlvu245C4H4AMdUbS8viqpy-wtzyb2nw>
    <xmx:NaBvahytnhxLabM4A7wjnohwR0cWiCKXn2IknASGWjR9SchE_GsFXw>
    <xmx:NqBvaild5nx4mfXbAr8VlomjVW51pjy_-RKDJd3XuXHKndSe-JO7q3e7>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 2 Aug 2026 15:53:25 -0400 (EDT)
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Nico Pache <nico.pache@linux.dev>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>,
	Barry Song <baohua@kernel.org>,
	Dev Jain <dev.jain@arm.com>,
	Hugh Dickins <hughd@google.com>,
	Lance Yang <lance.yang@linux.dev>,
	"Liam R. Howlett" <liam@infradead.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Shuah Khan <shuah@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Usama Arif <usama.arif@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	"Kiryl Shutsemau (Meta)" <kas@kernel.org>
Subject: [PATCH 13/16] selftests/mm: parameterize the mixed-source collapse case by source order
Date: Sun,  2 Aug 2026 20:52:45 +0100
Message-ID: <20260802195254.1937477-14-kirill@shutemov.name>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260802195254.1937477-1-kirill@shutemov.name>
References: <20260802195254.1937477-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: A02CB120004
X-Stat-Signature: eq148aa53a4bxi4zc8w1uhomndjhe8q6
X-HE-Tag: 1785700406-184864
X-HE-Meta: U2FsdGVkX18IMf+nIvrmyX+MZQ2cfIX+AB7wGI1C56+w4Wer6neB1CuI4N/JesbrjoZiXnJErp+fuiKusxTXKbsxX8mWg3IcGaqZRTopRxwYB2i5OFa93DMcrvbBYDj/+HTkdxYuw1oGrtb0U+Ma6JgSeEz6VgsfUljFkurVizjdElCvSEaFaDeZc0hVeiH3n4AxD7pVlE8oqcTuPfsdF1hSp/ZNWUZZsdnWZs0T8CkqCsYPS325Nf7N/ct4PyP00WUwg3aKv76D2KNweHkR37pB56NUKCBugklRuff+nHl8AoimdAAwThROLpyMtzs9LQjAmyivD+OkOJXF7nQiqIOsBctMxQpEcrC7rWACUYW+IOelY60JJ8MbNwu5RputkSdnDfPzjzmmolqBUoVcoXjrSEStuvi/m8go/rI4uLTwIdDF7Y83WE1n3XQE69DWB6tik5ovQP2BBg/jE6E068hMQFYAQnfSQmhB/C29tdU5emFLtdCn0h0bxcGZ7IYqNoDO47i1/Jix2afkJfv6n6KmdBq9DY0F0hTkYsVJHFogrGAT2jM6+nl4mxOQ5Gzza4Ps8dil7knNp2HwmGOUOu/3YW2GfHxSQF2nJgTPe8U7O+v6BV9Y38K5J9U+Nf9cG/z2oB90hI/1udYD6c2nAWb/aTcLmtmB8NFa55L+XbLyVS57ViT7PTd79Ik4UTJDD/LsS2gTHJzTcmC9gA3OSpOCBF7GDPyCQsr3cqJLcQ6tgLgD6++dws3vfKre2Q549MltJAzQsiUW1n2Do5dm9EumsDNyP6WC2pTXF7h+81IsYbsZuXrT5EhVKuDun1G4dZ6mma2xvMfgGhft0INFseSb66E8b9IkAxFGf5AoXrmLBrbWcxuWDpGEhffbT68NBKKZaR+jT7CiRD6SpXjf+xompXeMRZNHosDJiH1DDMMNO9RaYlK2GCjGgXx6ER+uV6X4LH30eXxgpUoAcEu
 HhNud31a
 s3+dobBMiiLhqQm2cJ6KiMh8DvMSmppSBcWn7vYE9VgY+iivyvZQeViTffUcvCx7OHXJLfrfppUc6opNwLTgsdC66UmnecxNI7R1MX+6C+4oPKDeMEPutc6JflSqgtLqsAlMVd4tkdSaGGfvORQKAPHXNiuyyc6rJdEKe+hRmhNfwSTU2BkmIY9FVZfBkxwQL3nuL8q6rl7LtL2cyZUyzSHrmVrT4paPvW8G44QFm4t6WPAilvlCxzXp2WH7P/PCB4hZ4S3n8UNsC0UWGcY2EpqSv1jc2WCFYwAgSF/LBuvOk1O+OZ78AxgJsoQQH2VrSYTxSVGOOdf1EgmpawW+7oT+NIjjh4wVauRrxpLv5rNb01ejWDJFtglNd9HbguC/hYlk1qrgle5c3eXzaq0kXRWiYE4ZM5rvJZZhRwoEKmb7eqVwZY5/LD9l+2f7zMKIdZ9+CyS+9QoE4i0o=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

collapse_order_mixed_sources faults its region as order-2 folios and
collapses them to the -o target, covering collapse of sources that are
already large folios of an order below the target. But it only ever tests
one source order, and order 2 sits below the contpte threshold on both
arm64 page-size configs -- so a source-side contpte unfold is never
exercised deterministically by this suite.

Let -s name the source order when combined with -o (it was rejected
before): the mixed-source case then faults at order @anon_order instead of
the fixed order 2, keeping order 2 as the default when -s is absent. -s
stays constrained to a supported mTHP order strictly below the target; the
other order-parameterized cases keep their order-0 sources (the source
order is enabled locally, not globally), so -s under -o is a knob on the
mixed-source case alone.

This makes e.g. -s 5 -o 7 on arm64/64K collapse contpte-mapped sources
into a larger mTHP, covering the source-unfold path directly.

Assisted-by: Claude-Code:claude-opus-5
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 tools/testing/selftests/mm/khugepaged.c | 42 +++++++++++++++++++------
 1 file changed, 32 insertions(+), 10 deletions(-)

diff --git a/tools/testing/selftests/mm/khugepaged.c b/tools/testing/selftests/mm/khugepaged.c
index b074b005b62f..21a8fb24dc43 100644
--- a/tools/testing/selftests/mm/khugepaged.c
+++ b/tools/testing/selftests/mm/khugepaged.c
@@ -1363,28 +1363,32 @@ static void collapse_order_mixed_sources(struct collapse_context *c,
 					 struct mem_ops *ops)
 {
 	struct thp_settings settings = *thp_current_settings();
+	int source_order = anon_order ? anon_order : MIN_MTHP_ORDER;
 	void *p;
 
-	if (anon_target_order <= MIN_MTHP_ORDER) {
+	/* Sources must be a supported mTHP order strictly below the target. */
+	if (source_order >= anon_target_order ||
+	    !(thp_supported_orders() & (1UL << source_order))) {
 		ksft_test_result_skip("%s: no source order below target\n",
 				      __func__);
 		return;
 	}
 
-	/* Fault the whole region as order-MIN_MTHP_ORDER folios. */
-	settings.hugepages[MIN_MTHP_ORDER].enabled = THP_ALWAYS;
+	/* Fault the whole region as order-@source_order folios. */
+	settings.hugepages[source_order].enabled = THP_ALWAYS;
 	thp_push_settings(&settings);
 	p = ops->setup_area(1);
 	ops->fault(p, 0, hpage_pmd_size);
 	thp_pop_settings();
 
-	if (!is_range_backed_by_folio_orders(p, hpage_pmd_size, MIN_MTHP_ORDER,
+	if (!is_range_backed_by_folio_orders(p, hpage_pmd_size, source_order,
 					     pagemap_fd, kpageflags_fd))
 		ksft_exit_fail_msg("Region not backed by order-%d folios after fault\n",
-				   MIN_MTHP_ORDER);
+				   source_order);
 
 	madvise(p, hpage_pmd_size, MADV_HUGEPAGE);
-	ksft_print_msg("Collapse region backed by smaller large folios...");
+	ksft_print_msg("Collapse region backed by order-%d sources...",
+		       source_order);
 	if (!khugepaged_wait_full_pass())
 		fail("Timeout");
 	else if (range_collapsed(p, hpage_pmd_size))
@@ -1414,7 +1418,9 @@ static void usage(void)
 	fprintf(stderr,	"\t\t    Defaults to 0. Use this size for anon or shmem allocations.\n");
 	fprintf(stderr,	"\t\t-o: collapse target order for khugepaged:anon.\n");
 	fprintf(stderr,	"\t\t    Runs the order-parameterized collapse cases instead\n");
-	fprintf(stderr,	"\t\t    of the PMD cases. Cannot be combined with -s.\n");
+	fprintf(stderr,	"\t\t    of the PMD cases.\n");
+	fprintf(stderr,	"\t\t    With -s, -s names the mTHP source order for the\n");
+	fprintf(stderr,	"\t\t    mixed-source case (source order below the target).\n");
 	exit(1);
 }
 
@@ -1438,7 +1444,15 @@ static void parse_test_type(int argc, char **argv)
 		}
 	}
 
-	if (anon_target_order && anon_order)
+	/*
+	 * -s and -o compose: -s then names the mTHP source order for the
+	 * mixed-source case, which needs a source strictly below the
+	 * target (and at or above the smallest mTHP order). Alone, -s is
+	 * the source order for the default PMD suite; alone, -o is the
+	 * collapse target for the order-parameterized suite.
+	 */
+	if (anon_target_order && anon_order &&
+	    (anon_order < MIN_MTHP_ORDER || anon_order >= anon_target_order))
 		usage();
 
 	argv += optind;
@@ -1573,9 +1587,17 @@ int main(int argc, char **argv)
 	default_settings.khugepaged.max_ptes_shared = hpage_pmd_nr / 2;
 	default_settings.khugepaged.pages_to_scan = hpage_pmd_nr * 8;
 	default_settings.hugepages[hpage_pmd_order].enabled = THP_INHERIT;
-	default_settings.hugepages[anon_order].enabled = THP_ALWAYS;
 	default_settings.shmem_hugepages[hpage_pmd_order].enabled = SHMEM_INHERIT;
-	default_settings.shmem_hugepages[anon_order].enabled = SHMEM_ALWAYS;
+	/*
+	 * Under -o the order-parameterized cases want order-0 sources by
+	 * default; the mixed-source case enables its own (possibly -s
+	 * selected) source order locally. Enabling it globally here would
+	 * make every case fault that order.
+	 */
+	if (!anon_target_order) {
+		default_settings.hugepages[anon_order].enabled = THP_ALWAYS;
+		default_settings.shmem_hugepages[anon_order].enabled = SHMEM_ALWAYS;
+	}
 
 	if (anon_target_order) {
 		/*
-- 
2.54.0


