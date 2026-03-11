Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 042911049527
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 10:19:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 24FB76B0092; Wed, 11 Mar 2026 06:19:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D73B6B0093; Wed, 11 Mar 2026 06:19:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F034A6B0095; Wed, 11 Mar 2026 06:19:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C43866B0092
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 06:19:37 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6909D8C1BA
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 10:19:37 +0000 (UTC)
X-FDA: 84533385594.22.4068A32
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf22.hostedemail.com (Postfix) with ESMTP id 93529C0006
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 10:19:35 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=gbdGfQ72
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773224375;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MFthAOwBMbfcPyydbWyKKsxIBB7Wpv1CRiBxp3jBdA8=;
	b=627C5yeKhXlJSnRjeJy6D+LJ4CwrqOS5EmYkrXVHv7k8EABBch9ZNvizg6CVzNg3D/Rm32
	AAGjX9MpwyrMAUJK9v0JtQDEjZs79HLIfzFzXCe4/8m3KdCyB8FCnTAF3XU5G1Ja4iEC7q
	aIlk5FFnl5BLBGSar4oPW+sc13DDlDM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773224375; a=rsa-sha256;
	cv=none;
	b=S8idanwIDvniGN8oYt+5xI1CO8FiGSSveFdhLhr1nbJrW3Bx7lz00Y2OUOoxflUfaRzjd5
	so7Tw0hdQiFaVBSPhYyQSlVLG2xrm1sQSxwN/jfuegSHyiMb5ryfdbVhYKBsSMfLyKoaph
	XPajn18lghL53neuwKSpiraxepd7y4s=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=gbdGfQ72;
	spf=none (imf22.hostedemail.com: domain of leitao@debian.org has no SPF policy when checking 82.195.75.108) smtp.mailfrom=leitao@debian.org;
	dmarc=none
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:In-Reply-To:References:
	Message-Id:Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:
	From:Reply-To:Content-ID:Content-Description;
	bh=MFthAOwBMbfcPyydbWyKKsxIBB7Wpv1CRiBxp3jBdA8=; b=gbdGfQ72Pbj/yEZ+HcSy0He0BU
	THMv8H8sgx5QLH5+QNvjCwQ7O1bwTSV/Y/VtxS3fX29hK4Qd7jOdQwH1pP5p70wxrpvF/hBp++PVn
	uE/eSHxFSqxODC0Zjmx+e3pr+CVMWYiqw76MY0pMF5pUSJdC5hkX4NWfWLzNx+JILAntUY9LIfVBF
	mSPEHcEkz1NXVD4Z4mpmK5zeGr6qTXcfbUFPJB7tibAhEwV1ubTGdFenkKkAvLU7wf9VtovKdlj8O
	TyT7bfMtarLTr2qGC99g8v2xEK8od+ql8WRDTYxK7LvxmtPiREsS2BY2/bL4pFWw9r2NG2SrAocSQ
	uxcPo9Ow==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.94.2)
	(envelope-from <leitao@debian.org>)
	id 1w0Gf3-003hKl-6U; Wed, 11 Mar 2026 10:19:29 +0000
From: Breno Leitao <leitao@debian.org>
Date: Wed, 11 Mar 2026 03:17:49 -0700
Subject: [PATCH v6 3/4] mm: huge_memory: refactor enabled_store() with
 change_enabled()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260311-thp_logs-v6-3-421e30d881e0@debian.org>
References: <20260311-thp_logs-v6-0-421e30d881e0@debian.org>
In-Reply-To: <20260311-thp_logs-v6-0-421e30d881e0@debian.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
 Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>, 
 Johannes Weiner <hannes@cmpxchg.org>, Mike Rapoport <rppt@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 usamaarif642@gmail.com, kas@kernel.org, kernel-team@meta.com, 
 "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>, 
 Wei Yang <richard.weiyang@gmail.com>, Breno Leitao <leitao@debian.org>
X-Mailer: b4 0.15-dev-363b9
X-Developer-Signature: v=1; a=openpgp-sha256; l=3631; i=leitao@debian.org;
 h=from:subject:message-id; bh=EdbjNIc4MU4kE7FF3eW32wB/WCGu/OZa4I2oST0exss=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBpsUGZAPQLhkqPGTMyt0/1aIWw63IFWqb8fSKPJ
 0SODewov9iJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCabFBmQAKCRA1o5Of/Hh3
 bXU+D/9e57RxcBJQU/pf0opwkVMFvv5vy3sgdffVbMJgRkBmPaYK/7UJawozT2FS8nu+qdYqydL
 iFEPCb67wviiCZF5c0KPF0yxBNC/VugLcW7wXIgKOaAx/cv9EOS7M1sOwAp3VvLESblVIC/4xyO
 vdQqkQotDbrkA0VjaR+4Pd7b8M+OQquusCVPYCYbBCQfG8SK9zkkv36Rjw5fqNXMY6febQKijDD
 b1VN9k7rTxpP3yr9QZ4sGix6f4txLiDdSbJEhYLupIC3xMEsurgPHJo7GQq3dBeiO+VopPP3V3Q
 ios1pY9I6EmNkdhF7sGYbZbmDuiG6UPyCTnWvBA8ZLOvhjQmi0nfep3lvGa/Z+O3qGXGzqGAN/q
 i3KchWhMtTR5y0TA/Fm5ihINJZNeZzVLezfsBRdCKucit7o0Et8FUqc2PdkDqwL9SioSDIDziK8
 4g3ikHY3emF3En81FczhKlbY5KYkmKJFqP9SPJjrCaBUqUM3vSqv7PnW9mG9fEWsHjvoYZPlEqv
 NjutbbaEKmkfztuvnTcpnyaRRFDPGZDWlmfcIJAO4utF3iC5fX4nGPtQgwtUQb28gqadOjLc5fA
 5fWnpEUMP8zuq5HulJbyBvu4Lxpo0DMLuMWhyde7oxPcm5a+x89nmhCNkIzB+eG3VoySlzSkXhC
 o2gzwAQCYVRUs+g==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 93529C0006
X-Stat-Signature: 33sghiq5qz7nizk35x9crmd551xawmt3
X-Rspam-User: 
X-HE-Tag: 1773224375-556280
X-HE-Meta: U2FsdGVkX1/m/G+9V0m3QePzk54V8+zVRNTabasjX4DmOjH10vRnqKA2vrsNiBQNHariuV3dpIx6NLZMnvlDVj+yMJj/DwUzudGnajD+YXSZ/XpQYUnjUISQ6fQWbkYMv46Nhb7w6UNIAlm31plLrTFGLoewxHHi80fDhtMY6nE83lac7MNa5PzxSSPqynidvT9JM0Ee2sfUVChTuoO4ezXqwescOdznRObqYSD/Mp1ZjPzzZPEJuUjJmT+We2u/kDvz6l/naAb5HiSi2mgEpeTMa7zetRLNlBgTCJbQv6YgU7RlJK1fPF6+jUGJGMFW9YGzwuamyNAiqnxdKWChlR2IzkPrpUTIQgw7iQ00vbRNjt0ZMHU69ETXSDQx0bNL64dU5jikWQIrb5e/dZMSxKBphsyT+WWSrMlVMoasg1qdS4o8GkLKaCbJ7qExb/80tyZpzBzv8P3eYN82jV7chnJp/8JMUhcMLVnQ/iMBTGJlXL/no6IvTChZTQEmiHiJF8AjOhcTqHBAeAF1lIO7ongwg/fEtqUJ07mdRP2mTlvCyOes8rWkAIfOFsd5GuU99lS+v2Sj0d18fvi2YiDnk+7QI6k4jAWCd0cx/4Hn4KSOF889AhoqfVPI90PhWDNzRg13s0QTqwOMmO7mdfHtNGkz3r2guDHoLExyjWLlHoMgo+n1vg9/ibjPJMfGSgFqZq1n9V4SDIzefa9jCEPxdqENP7aUJJkVXRxtBSmsVuQEeUeVNkzZm7unMmCQdqkXqNKFovThkwxG68vK9z4zNP8WMAZIjTnb45yFqDpLCg/ocZVIV0mg9O8MhvJ9pMwKJTSkF9CPVmNycITBALhHsTtQzy4AR7Xkmgbhe2tpbUlxgQ7rXR5QMz/Kgn5Z++L+5w8bjWhQ6uisfI6R+CvhyP6WrCFLG5DegAhrtfPoet20tcm0PIlxS7SNfMxfTmTdgN6m5v/XnyYVkLZWXBW
 HHucCBKn
 pT+2QJWwxuZWq0cH6wxsszUB6LLgoMMBsX8dFUPL8CY891QXzHBmaF5CpfgJkHxoFmByejj2k5/ZzB9wrwR23IN2bg3fvObj9zcEWJj/qS5/4pRv3q3vynQeTHZLE+Z4B1kqvYXXKsIKQWUJF1M/g/Wuso1oPBierw6n59hzG5JHuJfzRHJIMp72xmT77ciJRcowtN+LvA1FWL21DpZuZuT5BGLikIUz4Gu/PCoD2M6HZiy63q6RmDOhATYCFpHxND9x4bQMod4jl16B92uRT+xAKihElz1mJY8K5mA74Lalsxn0Hb3iXQhrNgak6xmZQMJdbEhQdR3s/2WAPhrdHoZSFIton/75U8WrosnMAuCoMlsEjPOF7L3eMMA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Refactor enabled_store() to use a new change_enabled() helper.
Introduce a separate enum global_enabled_mode and
global_enabled_mode_strings[], mirroring the anon_enabled_mode
pattern from the previous commit.

A separate enum is necessary because the global THP setting does
not support "inherit", only "always", "madvise", and "never".
Reusing anon_enabled_mode would leave a NULL gap in the string
array, causing sysfs_match_string() to stop early and fail to
match entries after the gap.

The helper uses the same loop pattern as set_anon_enabled_mode(),
iterating over an array of flag bit positions and using
__test_and_set_bit()/__test_and_clear_bit() to track whether the state
actually changed.

Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
Signed-off-by: Breno Leitao <leitao@debian.org>
---
 mm/huge_memory.c | 63 ++++++++++++++++++++++++++++++++++++++++++--------------
 1 file changed, 48 insertions(+), 15 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index f6af90e6cf05d..8949393de7a51 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -330,30 +330,63 @@ static const char * const anon_enabled_mode_strings[] = {
 	[ANON_ENABLED_NEVER]	= "never",
 };
 
+enum global_enabled_mode {
+	GLOBAL_ENABLED_ALWAYS	= 0,
+	GLOBAL_ENABLED_MADVISE	= 1,
+	GLOBAL_ENABLED_NEVER	= 2,
+};
+
+static const char * const global_enabled_mode_strings[] = {
+	[GLOBAL_ENABLED_ALWAYS]		= "always",
+	[GLOBAL_ENABLED_MADVISE]	= "madvise",
+	[GLOBAL_ENABLED_NEVER]		= "never",
+};
+
+static bool set_global_enabled_mode(enum global_enabled_mode mode)
+{
+	static const unsigned long thp_flags[] = {
+		TRANSPARENT_HUGEPAGE_FLAG,
+		TRANSPARENT_HUGEPAGE_REQ_MADV_FLAG,
+	};
+	enum global_enabled_mode m;
+	bool changed = false;
+
+	for (m = 0; m < ARRAY_SIZE(thp_flags); m++) {
+		if (m == mode)
+			changed |= !__test_and_set_bit(thp_flags[m],
+						       &transparent_hugepage_flags);
+		else
+			changed |= __test_and_clear_bit(thp_flags[m],
+							&transparent_hugepage_flags);
+	}
+
+	return changed;
+}
+
 static ssize_t enabled_store(struct kobject *kobj,
 			     struct kobj_attribute *attr,
 			     const char *buf, size_t count)
 {
-	ssize_t ret = count;
+	int mode;
 
-	if (sysfs_streq(buf, "always")) {
-		clear_bit(TRANSPARENT_HUGEPAGE_REQ_MADV_FLAG, &transparent_hugepage_flags);
-		set_bit(TRANSPARENT_HUGEPAGE_FLAG, &transparent_hugepage_flags);
-	} else if (sysfs_streq(buf, "madvise")) {
-		clear_bit(TRANSPARENT_HUGEPAGE_FLAG, &transparent_hugepage_flags);
-		set_bit(TRANSPARENT_HUGEPAGE_REQ_MADV_FLAG, &transparent_hugepage_flags);
-	} else if (sysfs_streq(buf, "never")) {
-		clear_bit(TRANSPARENT_HUGEPAGE_FLAG, &transparent_hugepage_flags);
-		clear_bit(TRANSPARENT_HUGEPAGE_REQ_MADV_FLAG, &transparent_hugepage_flags);
-	} else
-		ret = -EINVAL;
+	mode = sysfs_match_string(global_enabled_mode_strings, buf);
+	if (mode < 0)
+		return -EINVAL;
 
-	if (ret > 0) {
+	if (set_global_enabled_mode(mode)) {
 		int err = start_stop_khugepaged();
+
 		if (err)
-			ret = err;
+			return err;
+	} else {
+		/*
+		 * Recalculate watermarks even when the mode didn't
+		 * change, as the previous code always called
+		 * start_stop_khugepaged() which does this internally.
+		 */
+		set_recommended_min_free_kbytes();
 	}
-	return ret;
+	return count;
 }
 
 static struct kobj_attribute enabled_attr = __ATTR_RW(enabled);

-- 
2.52.0


