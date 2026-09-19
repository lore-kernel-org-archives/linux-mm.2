Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B3D62C982D8
	for <linux-mm@archiver.kernel.org>; Sat, 19 Sep 2026 00:25:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 864026B00B8; Fri, 18 Sep 2026 20:25:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 815A86B00B9; Fri, 18 Sep 2026 20:25:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 667D06B00BA; Fri, 18 Sep 2026 20:25:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3A1B86B00B8
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 20:25:24 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A495E40151
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 00:25:23 +0000 (UTC)
X-FDA: 85228617726.20.9B4516D
Received: from fout-a1-smtp.messagingengine.com (fout-a1-smtp.messagingengine.com [103.168.172.144])
	by imf25.hostedemail.com (Postfix) with ESMTP id B06B7A0007
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 00:25:21 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="f P3GmIi";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=bhpMb4fE;
	dmarc=none;
	spf=pass (imf25.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.144 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="f P3GmIi";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=bhpMb4fE;
	dmarc=none;
	spf=pass (imf25.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.144 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789777521;
	b=Au+CkSne//Wt0WdqWg8UZQGc0HXt+tOkWcTIulQJ/vY8budcNTVpu4zciN6gcCICdb8VCH
	YpoPOv20avKuLbJ/23yfrCIasutHUVYGKIZHTdkcp/15BA6iymR2NNqL+RvqBHNCroMZTg
	s+xzL1Dha4XPsVFtchYuKr2uL7yEdBM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789777521;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=woAtTKSUrAOJywezkPjP/PLaIChkiihi6VKhVfSPERI=;
	b=8GcOJHpcKbj6QG8TH3Kk5mVj+9sgtoG1jf2YjFlxeWSAt3XGjjEh/otKpQa1Ilega3K2sU
	Y7aBRAo3qc3xmNskIgVAAiIvm5f6NddqRVlRJ9ts4Xff5nROhqTMikWJwzHWMEs9R36ltp
	/CBJFiZ4DTBAMKNXyi4IwjzCHr5OAtE=
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfout.phl.internal (Postfix) with ESMTP id 50048EC0198;
	Fri, 18 Sep 2026 20:25:21 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-06.internal (MEProxy); Fri, 18 Sep 2026 20:25:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1789777521; x=
	1789863921; bh=woAtTKSUrAOJywezkPjP/PLaIChkiihi6VKhVfSPERI=; b=f
	P3GmIiBK6HZ5fGIcXGDIUODVSOcL3LT8XoaXdTMNuubaa/Qjxlum0+xGM0OBxsSi
	6jBfVNsTabaUnVA3uDuZAwm7nZh168ozs3/hM/lQe64SogUKSeWsEqE9Ds4XdcQu
	X+iIRvRdiidDvM/029MXNvpgBihgvuJT7Cy6KlCymZ+TPQggaPBkYsso5h72KEZP
	Dpb/NMgYdfkPHFwYTwBBGK4T8kZiZR38LSEKKapXFxeQuTQwegCzeSIVk+AjyA8v
	OJ7Jv1i+BHDcgegmQeom/1EUWZCTs+fZxUhRgfzko/Tz9zhusEap/mwGsSq8TJLR
	egJaZyUZqRm8i3otAidPg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm1; t=1789777521; x=1789863921; bh=w
	oAtTKSUrAOJywezkPjP/PLaIChkiihi6VKhVfSPERI=; b=bhpMb4fEi+7Sz9LZv
	A39GMVPwJcBjPP4KIjaqnyhb+Mw81Xzt3EcZ/kGZKzJH4cgJLfrt4uMyjd4F/tF4
	oh/u+IUIxWvXZ6i6gbtAgrUAMlcGECDs0wPlEqNE39OS52lrI7qCJPDU8PcYGBLw
	cUmJ9VwdKTVNUYfWy7T/SI26ZBNnnLmGfxLYn0TDWVbDdVthuds5yA9bdgEFqUa/
	f7Xz89aX7bFwMYjqd1EDofwI+eRi1kpFAOpIUHJyXItwbVF81Sk98IvsyjMnCWEs
	HYpL/QIZSvdSZjGzaeU3WmY4mU4ONFqL3eybrIhuKg05BvSszWiseuNtR9QFymts
	uN03w==
X-ME-Sender: <xms:cdataiVCUOpL6mZ7CM44hKh4N7UqJqzc08jeQ-lYDn6cJLkYkI5h7Q>
    <xme:cdatam8A-lnAxVdqQpkDZNz9o-G9-D_DBLr-_vhkw0d07yZ1lMXE6M1hJZk090QD9
    7O0NNZDQiwAT4waLAgq4u8kH9qKfD0AIrvPtVzYz4gCTXdaCPbM2p2q>
X-ME-Received: <xmr:cdataolB7r5mB7htWrnsaRBPHUNVwr3Pqta5a_fsX3JspznRAg52ZMFJ8q8>
X-ME-Proxy-Cause: dmFkZTFyC+XeKYnZ766rqTYe4SsoatN0doBd7ADemiperjFlmE10ggdkgYpZeWmNOU4aBc
    lm02WEvCO2QGG+A0SGXMzCjVWjDSVCQ5WJ/xmSMbLZJLqVjt5aEnrGd0hUbHPJ/ejcqjFa
    xrmYY/YNxh9EpvRrTjNMqslNp6oZ1XKAjj0b9YUD/U+Umt4HJhNRFStrIx7jR3Gf+CAD8k
    /TwEvtSve0+WgA7utVqBt9LeXDUSIUkf7dn/1M9JWIyORT8Kp2cNKrwYutOzK/Z35sBm5S
    qWNICJAq9yYROUOkEgx1cQSYtjkPP2DMZwKGXS3JxTiE+xMdBmJUepOSBHs3/DvnVTIMBw
    QQND7SieWtt/aXz5uKT9DiEHRhvYRwDLjNMrZi9QZALZ/12AZ3Zf4NPQaM79q8yJXhO5D4
    mgydrB4dpKv6oFpVFxvKxTxzuzkzF6JzHSfyfPOE/W2C8Ho6P08KlQEN5muATVcjHH/zY1
    fe7odX8BguwojpsMGHN4w0lhDpxTXbH+2bMpQs1mlkdAPd+xnvCJg/Sdle46ItJw+HmJ/A
    BoNbGTbzr371oySzuTVZvONAaXSjwrSB47KlvqxJxbd/6f6gASMpVlCZ11o/leCgCgUkpP
    A+2GeiX63HVUrzXdmDcz4kER+634TQWkynYMIc9RDoAJuY0Bif+jfDP05mUQ
X-ME-Proxy: <xmx:cdatahIv_YN-9HOcpG8EocjHHsiuItf0vVHzsh0cYkveTaA6jkqz4w>
    <xmx:cdatauqfgPU_t3vr_zrz4SMBP9VvLdHLxlv2n1ze0yVz94yRqJjHEg>
    <xmx:cdatauSxN7POkfoIlBSu3l8ufS86_XlV3OJ5nl7OZ2KIZMz-x6_f3g>
    <xmx:cdatah5Aq7KU4TofOTyTg4Y6m2ZKAZHPVL4xLzVp8LdHND2FbhCtZA>
    <xmx:cdatakM2SDSrCJcpy3wWGUF1WbJu2jf2nZ3e7wfXLO3Ppi1mMUvNjJLh>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 18 Sep 2026 20:25:20 -0400 (EDT)
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
Subject: [PATCH v6 12/19] selftests/mm: parameterize the mixed-source collapse case by source order
Date: Sat, 19 Sep 2026 01:24:42 +0100
Message-ID: <20260919002451.496763-13-kirill@shutemov.name>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260919002451.496763-1-kirill@shutemov.name>
References: <20260919002451.496763-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: B06B7A0007
X-Stat-Signature: ty5zw8fknqk89sggqm3nqrmpoaooq73w
X-Rspamd-Server: rspam01
X-HE-Tag: 1789777521-676196
X-HE-Meta: U2FsdGVkX19/kaKgatZHM60PmZH5XzI/XI2nCwkXADxn+k0W+n+MHkTmNryct2oV6ik7wvIGQWIUWujiipNOvFZs+cs6JdmmxXNzLPB3aX9tztHeifE8nViKDRkqBe3WtZimiPpRtpf7GbDkbJPRcDSii8w3tiDpRRPviQq4TNj9xvxI2XsnDk0y4c9EYC6BATonHZDVBxgoJZPu0xByy4DoAcKvLUfYwjkrTvq1PoNcfs0lcfTgLsDoml04P6otL8IAgX02DPIgEdbdGVUhNabUI47YlSh7cvDuo2674oou6UCv3FqOiJcIJsIyhHWehdrBAh25ppK/QieVzx1Jr4fb6N8YhnZDka8F2benSXpiQv+aSEA6qp/NPjB6C3YACsPwaYgHAdqSI1sQH4OBwjrnBc7vrKoGPdlsP2sAApyD8COHPCyzEB5hI87V1qSsFH2VKENQ+d4ipkJnqKyUWitm0T9oYwTLMxmAuzD3+9ldeySsENPvhyDIC2afEvhme1iOwnI5o7EJ360nqi6jKtI2Ag3ySu2duUoej34KwncNEWyIoi7ETzLtZSusEYAf6or65jQWfgBIzCmf+Yv8S2a5rCtJW6wo+7uAJccA7raaU57tImYYgL1GTlladnzTbNIgAYxfh5FdNk2BHge34l9sYtNCTbNjH/08eSjtiEQsujLjJHRma/qAjmrI21bfCdHZ2JwIzb3Zom57WWpbf2M86uvKjbsFRvJ0pPPl94YU6bvLT1zzB1lFNVXDpHBNEoodzy1tjNXLMjUe3dikImbPXKe5KE9gn9ECpNHOSdAZ6CsJ3bA3eAzPMMpmkABS0MwvJTa+GUXLI+EQ0MhbYreQN3/rS/hRLQM0E54pL+NS0I35gbnHpdjOyMTGNFQ4ycRea0yQz09jqpVZ+C2scrr4ngG0+LddJSqH+3CmgEbBDP7Ps3o0iJ3y8jvr1H5wptgRrWtU5JyDeOV+Kg2
 afS3A44t
 RTERs+Wym0q1zP5Y3KN/ApO/zovYpG7QrJW1EGAVzi9nnQZhp7SdAK3CBJyLpq8LdYtzFuZ5O36L6uYOCAmUyt1Hc2XgDF8oZVD1bS67dp2VneWvkiBTAN1VQOxME3vOtESkNOTfPMn3n/QXllQOaY42sJGomTPcNfw7yac1ieqjbZ7mXZ0lHE7YFqcZ682nPBgL279zfz0zCl+kvGpo46OE52hwvDerC5FFOmHeALNwoKctuERI3EMoEdSypG3PjW7tfq/aGl3lMYmTYC+qHMdfkRRVqZmHKMk7ZAlTssHI9a/sgAdqADv0RszR/fp3hwudoiMfZeXmWnWQmq9dIoqCafrjI233AwqT8soxeYvPHBDhgz/ObZR5JahfADmng8RMOdq3KbmRx2Bu5KH7Fn8Xr/LP/r96vREsGqZRUvHFS2f26TITvwkhqueiID9dNZb/cXhR52kh1hqbAi0KwRUNfKnANNsGocD99D4Jzfp3SqWrp4cXei0o5C4oBvVDSyvYR
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

collapse_order_mixed_sources() faults its region as order-2 folios and
collapses them to the -c target.  Order 2 is below the contpte size on
every arm64 page size, so nothing in this suite collapses a contpte-mapped
source on purpose.

Let -s name the source order alongside -c.  The case then faults at that
order, keeping order 2 when -s is absent, and the source order has to be a
supported mTHP order below the target.  The other mTHP cases are
unaffected: mthp_push_target_order() enables only the target order.

A -c at or below -s is refused before any case runs: the sources would
already be the size being asked for.  Without the check the generic cases
fail on that one by one instead of saying why.

"-s 5 -c 7" on arm64/64K then collapses contpte-mapped sources into a
larger mTHP.

Assisted-by: LLM
Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 tools/testing/selftests/mm/khugepaged.c | 20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/tools/testing/selftests/mm/khugepaged.c b/tools/testing/selftests/mm/khugepaged.c
index 51bda01446cd..9d1c47bd5013 100644
--- a/tools/testing/selftests/mm/khugepaged.c
+++ b/tools/testing/selftests/mm/khugepaged.c
@@ -1354,11 +1354,13 @@ static void collapse_order_max_ptes_none(struct collapse_context *c,
 static void collapse_order_mixed_sources(struct collapse_context *c,
 					 struct mem_ops *ops)
 {
+	int source_order = anon_order ? anon_order : MIN_MTHP_ORDER;
 	struct thp_settings settings;
 	void *p;
 
-	if (collapse_order <= MIN_MTHP_ORDER) {
-		ksft_test_result_skip("%s: no source order below target\n",
+	if (source_order >= collapse_order ||
+	    !(thp_supported_orders() & (1UL << source_order))) {
+		ksft_test_result_skip("%s: no supported source order below target\n",
 				      __func__);
 		return;
 	}
@@ -1366,7 +1368,7 @@ static void collapse_order_mixed_sources(struct collapse_context *c,
 	mthp_push_target_order();
 
 	settings = *thp_current_settings();
-	settings.hugepages[MIN_MTHP_ORDER].enabled = THP_ALWAYS;
+	settings.hugepages[source_order].enabled = THP_ALWAYS;
 	thp_push_settings(&settings);
 	p = ops->setup_area(1);
 	ops->fault(p, 0, hpage_pmd_size);
@@ -1376,10 +1378,9 @@ static void collapse_order_mixed_sources(struct collapse_context *c,
 	 * The allocator can fall back to smaller folios under fragmentation;
 	 * having nothing to collapse from is not a failure.
 	 */
-	if (!is_range_backed_by_order(p, hpage_pmd_size, MIN_MTHP_ORDER,
+	if (!is_range_backed_by_order(p, hpage_pmd_size, source_order,
 				      pagemap_fd, kpageflags_fd)) {
-		ksft_print_msg("No order-%d sources to collapse...",
-			       MIN_MTHP_ORDER);
+		ksft_print_msg("No order-%d sources to collapse...", source_order);
 		skip("Skip");
 		ops->cleanup_area(p, hpage_pmd_size);
 		thp_pop_settings();
@@ -1389,7 +1390,8 @@ static void collapse_order_mixed_sources(struct collapse_context *c,
 
 	if (madvise(p, hpage_pmd_size, MADV_HUGEPAGE))
 		ksft_exit_fail_perror("madvise(MADV_HUGEPAGE)");
-	ksft_print_msg("Collapse region backed by smaller large folios...");
+	ksft_print_msg("Collapse region backed by order-%d sources...",
+		       source_order);
 	if (!khugepaged_full_pass(MTHP_PASS_TIMEOUT_S))
 		fail("Timeout");
 	else if (all_windows_at_order(p, hpage_pmd_size))
@@ -1420,6 +1422,7 @@ static void usage(void)
 	fprintf(stderr,	"\t\t-s: mTHP size, expressed as page order.\n");
 	fprintf(stderr,	"\t\t    Defaults to 0. Use this size for anon or shmem allocations.\n");
 	fprintf(stderr,	"\t\t-c: collapse order for mTHP collapse, expressed as page order.\n");
+	fprintf(stderr,	"\t\t    -s, if set, is the source order for the mixed-source case.\n");
 	exit(1);
 }
 
@@ -1575,6 +1578,9 @@ int main(int argc, char **argv)
 	    !(thp_supported_orders() & (1UL << collapse_order)))
 		ksft_exit_skip("Order %d is not a supported anon THP order\n",
 			       collapse_order);
+	if (mthp_khugepaged_context && collapse_order <= anon_order)
+		ksft_exit_skip("-c %d needs a source order below it, -s says %d\n",
+			       collapse_order, anon_order);
 
 	if (mthp_khugepaged_context) {
 		pagemap_fd = open("/proc/self/pagemap", O_RDONLY);
-- 
2.54.0


