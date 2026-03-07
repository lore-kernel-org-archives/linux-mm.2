Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5C801F55101
	for <linux-mm@archiver.kernel.org>; Sat,  7 Mar 2026 16:24:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8B9D26B0092; Sat,  7 Mar 2026 11:24:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 867AB6B0093; Sat,  7 Mar 2026 11:24:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7732A6B0096; Sat,  7 Mar 2026 11:24:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 634BF6B0092
	for <linux-mm@kvack.org>; Sat,  7 Mar 2026 11:24:41 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 02A391B8A8D
	for <linux-mm@kvack.org>; Sat,  7 Mar 2026 16:24:40 +0000 (UTC)
X-FDA: 84519790362.12.AB5C13E
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf30.hostedemail.com (Postfix) with ESMTP id 30E8880003
	for <linux-mm@kvack.org>; Sat,  7 Mar 2026 16:24:38 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b="EI/k/aux"
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772900679;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3BNLcjJkZMBW12wECnG4ZYadEB66BxAZDl3NHar6Yso=;
	b=7hIHHqVhlKS3hAjEu8dIntGWWeyEsbOoS2G2lh+IYAf6S79gwKk809ESgId0F4ZYVIXPBm
	23reiG7A0AmEImmPp6rUJi0urHwq06G3dN90dXJhFKRuFzLNAtnL9jYvKJGABkXxmIboO9
	siiQSt5VDurfA1i6AJCCdm21tnbumpo=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b="EI/k/aux";
	spf=none (imf30.hostedemail.com: domain of leitao@debian.org has no SPF policy when checking 82.195.75.108) smtp.mailfrom=leitao@debian.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772900679; a=rsa-sha256;
	cv=none;
	b=2DG7yD4JNuvgeTdF1mX4wqtIdd2bPrsB6EM6SS3YbxPxIkM2PR88n5g5fjk83GrwjW98zv
	HQk5efUfxznJpw6jvrD10Jczsr0HxNcmZ1eKZ4B6SOpWc3xDXz0YOAVa3yfHrHTE1CbH0G
	5a2K+S+HNI4ULf5QuAET2DRpCXTxc4U=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:In-Reply-To:References:
	Message-Id:Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:
	From:Reply-To:Content-ID:Content-Description;
	bh=3BNLcjJkZMBW12wECnG4ZYadEB66BxAZDl3NHar6Yso=; b=EI/k/auxY1T02XN/UP4PqDzHrL
	slPATE+jk30i/S8biwszCh2iE4Zb9ARBGw3CwesLF2KbuWagwu2y6Ij5TVb5x+sF4ifvze9eXfOSV
	iDc13K6BCgrHCxqorCEn1VptlJ636ttS64jUZi8c5JHGOryv/v/dVLra6H1eQkapFGWlgnWp3WS41
	hzP8625taHtht+cUPTPSD4Z5vGBX3WdedzDYXjyDJhCxaIcQWx1iZWpW1WeED0/z8rsNsJNA0xvPz
	K0JG9XlVQ5kpMWDv7vnUwCOego5wQasxcOv8tPAZB/AxTnOnvfPSgl5K14QG67sM5H+Niuu4xRHCs
	Sq9yzDgw==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.94.2)
	(envelope-from <leitao@debian.org>)
	id 1vyuCv-000nEt-Hx; Sat, 07 Mar 2026 16:08:49 +0000
From: Breno Leitao <leitao@debian.org>
Date: Sat, 07 Mar 2026 08:08:07 -0800
Subject: [PATCH v3 3/4] mm: huge_memory: refactor enabled_store() with
 change_enabled()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260307-thp_logs-v3-3-a45d2c8f3685@debian.org>
References: <20260307-thp_logs-v3-0-a45d2c8f3685@debian.org>
In-Reply-To: <20260307-thp_logs-v3-0-a45d2c8f3685@debian.org>
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
 Breno Leitao <leitao@debian.org>, 
 "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
X-Mailer: b4 0.15-dev-363b9
X-Developer-Signature: v=1; a=openpgp-sha256; l=3425; i=leitao@debian.org;
 h=from:subject:message-id; bh=zlsaZ8kaCXcEEWIfMU8ynz2khbS/0r7SuYWkIjlj6TQ=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBprE14/7kDvB5SOmDe7Zro8AP41H6s3+3zeHxI+
 EMzX91akimJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCaaxNeAAKCRA1o5Of/Hh3
 bUytD/468PRW2gj7l60eHMlh0rUTgGs0T/PmzAmGB06mt60u9k2lCaZFJIkJb48s0st40J0Ayrk
 sEOPprlA5VYar59IcpJdlYNtT9w3y5XRYKM4b+KDdtiUq5I2Q5sP66AXoaN+NJ7tbKU0Wzn4Kl3
 pqtnSEzHF+Zt/AdlWunrLSj2MLYrGXl/9FWm2YJV4rWOD4MKQ+UYJ4UA9wFvdRO1h0JTjxQwwlS
 zZeoKNAYP3JznzCuKAgWwKcO+YtGwwXq7PjzW7U3zmFOZueCAHhpkPQrKSkjcVusWszmquhbQa6
 iAq90h29OzPM1mKC7pAgoMy65q82M3FLS9VtRdD2n/HS/eepPrVGioeD1fs1+RbBkESsRtL8jCB
 liFSaAXvCcnTG5kwcRwXZ19LYlzB0IlllVLwX4pHOIrVtASck9UwexFkSowU01AT3jPd2Wugkk7
 JT1TY1NUpFxPRRistC1Oz5oZEC2axEnRscDVkQGRrjAKVQ8o6CR6+VmbnfedB2SvZsZ/1ReP/bH
 7cQCszoDQXgkLAOftYf9PkK2YCrvUpIh3VOlosNdND1PbYpWFzGubSeDoBdfp4sbAPY/87GLdxi
 NufArKiPTDzlbNpkbq/THj1QonDLcwrrCKYOgY3FO+2bMMALJqUbHJeuFOOX//K5qybGHQ/gpmc
 0chCT0kx5PyeUXw==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao
X-Rspamd-Queue-Id: 30E8880003
X-Stat-Signature: n3p9w5sdm314hhtk1rijgs8585s7suyr
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1772900678-67245
X-HE-Meta: U2FsdGVkX1+YBwflwFkehdIj3aWpZhMChqCPolo6t5j2d3ZkZEpoDQtpv4iLGRD1JbohR3hmvs4GdDFwI5sY6N1TkpwNxLS5DRMGnMju7SMDJtxe27DwMI0rLBpyx5fJUKPl/K0sYlAwC1JSDgj6vFtu9F2LI8BEL7zPdwPHM6DAkabF2B/OLm885e9dY856yfilRdscEu1s1Uig1flcAY6pgYTp55lYSU/cE0NLMtPhzEgIt8Ng+pdPXaarsUrsJH8DO99zyndB8+l2Dw9y0OvQwcA7SGONrQdUNma3PEL6K4a+K/fxzGPBZ57+57kI0UrNph0nhqNjaNo2qobXAK/WTRO2IV9UdYwCG55A3WWIgnuskZFdbRUMpS/jjucU2KcChyyCNRaDznTIjZSkzUl7KLCHUnUW8jkdGKIWWHssyzUl/AWefOYi85xWOoW+0TVv/q27x1oie6Kul3ELd+CtcAnpKds2E5Q1JIVkRMI9HXXmEdzlq9R0wTwnbPQCKmvgkGY0bWt3nvtDTlAAkXlsSnpbIHbwaTMU8LjDFh135Lr9tA8HmPH8tx4F8lj2qdbZ2h34+85dkgGijMB/VlFLqgSyaDskxd5WkKpfB2O55bl4emQU9/gW8dFXDPk61MgTyI1THDiTx6xJXbiurgbAJiQ9XcBpOt1YgHJ/m7dddFyqLq5gXKSIIzRGJdh0/rV7lN2TkPyY2eU0P+nIHDBove0Q3qhjjVBrHA3c9zIaOVFSo28nSNSKPParTHbwLS/9F5z5aqHexHhlVhBIxUuiPB8mREK8EzKbioFC0oAXhr/fD5RmzBJWErWteI1LgB8nM0qynLYjT2WTz2qdjmHu1kC7Z1mYLZdXaoK7rMnmbwMXcbmrbGEjZJI/tCzusb+vM3lgc/4HhC9aKATUxqFNhJillyN28BJvaVtmedh+CLLHrC2uwJeW3hjbQwVlfOgvVfTHpJ8L1ocZboE
 s8D4DTD2
 fzCwZTzJxh1LbHkU1USl27mK2UnbupeU8cs67idhR1b32ticiBvlfXDCRimQTLZeM2K43sVz3gRIIe/YW3eQSHvFT1xfeuRWDgNQAo+4pmnHQ+6Ja5KPlf2Jyot2qNCSeL/Y1GhLA7rPfwlj+WCQ4gG7Up9OFkAtkjCMCo6N8SV3yVWDRpbcLHptUecOp79tTzZsKOs085keulcVWWrVGCfq60OYZmq/Va7vP
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

The helper uses the same loop pattern as change_anon_orders(),
iterating over an array of flag bit positions and using
test_and_set_bit()/test_and_clear_bit() to track whether the state
actually changed.

Signed-off-by: Breno Leitao <leitao@debian.org>
Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
---
 mm/huge_memory.c | 63 ++++++++++++++++++++++++++++++++++++++++++--------------
 1 file changed, 48 insertions(+), 15 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 17ce6a16702bf..c38c86e6d0c02 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -330,30 +330,63 @@ static const char * const anon_enabled_mode_strings[] = {
 	[ANON_ENABLED_NEVER]	= "never",
 };
 
+enum global_enabled_mode {
+	GLOBAL_ENABLED_ALWAYS,
+	GLOBAL_ENABLED_MADVISE,
+	GLOBAL_ENABLED_NEVER,
+};
+
+static const char * const global_enabled_mode_strings[] = {
+	[GLOBAL_ENABLED_ALWAYS]		= "always",
+	[GLOBAL_ENABLED_MADVISE]	= "madvise",
+	[GLOBAL_ENABLED_NEVER]		= "never",
+};
+
+static bool change_enabled(enum global_enabled_mode mode)
+{
+	static const unsigned long thp_flags[] = {
+		TRANSPARENT_HUGEPAGE_FLAG,
+		TRANSPARENT_HUGEPAGE_REQ_MADV_FLAG,
+	};
+	bool changed = false;
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(thp_flags); i++) {
+		if (i == mode)
+			changed |= !test_and_set_bit(thp_flags[i],
+						     &transparent_hugepage_flags);
+		else
+			changed |= test_and_clear_bit(thp_flags[i],
+						      &transparent_hugepage_flags);
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
+	if (change_enabled(mode)) {
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
2.47.3


