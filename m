Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AC083CDE002
	for <linux-mm@archiver.kernel.org>; Wed, 24 Jun 2026 14:20:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2A41A6B00A3; Wed, 24 Jun 2026 10:20:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 22C746B00A6; Wed, 24 Jun 2026 10:20:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 11CA26B00A7; Wed, 24 Jun 2026 10:20:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CEE176B00A3
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 10:20:37 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3EC321201EA
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 14:20:37 +0000 (UTC)
X-FDA: 84915016914.09.AA69E5A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 9DB9640012
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 14:20:35 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DyfqY9FG;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782310835;
	b=13XnAL7yWv3N0HCcP2iW/cs+4oGEz6UBkNdSFoaduEHqKEI06mBUis2yuPKs4i5FClMe76
	Xkabs2aUiZNUcMnMHGxNA9KB1U/5dhgO+EjrjWkSrmSNXNHEjL9V18Wym2jRqdyb6rc2FK
	REEIxW0giB2Y589epBXy9/wrYgILmaY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782310835;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EUjYA4YKs65xmCeOj45MTc/zAzF9jp3SHtMdBi79Pxo=;
	b=4ehTPzSRegK99VhPVDpGc8T1RjaVgJu/1TZKvTI6lmUdn+PfeZRxcBMMTfPYhD/STbgg/C
	oudDhKC+DqTcm+IK2NxlxF35QFfY+kHFadzS6s7R8gsuHIKbaFMNOgjrdWIydhMXklxNSY
	ipYXhwmikBDTtHLzq8eSiq0JFERvLpg=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DyfqY9FG;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 37CA2601FA;
	Wed, 24 Jun 2026 14:20:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55AA91F000E9;
	Wed, 24 Jun 2026 14:20:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782310834;
	bh=EUjYA4YKs65xmCeOj45MTc/zAzF9jp3SHtMdBi79Pxo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DyfqY9FGL34hmvkr50EjzNCE03Mzek6Y95cn6oNRfig2AXRzDllUwH3aAcoCgCxpq
	 Pi/hx1N11V6IwhN4szDSPNzOQoJeWyPUTFkKmC705pNubTx6Bcrg6iBFAnXw2rnw50
	 qC9QfxBw9FbDh/t0SHhBFQCirZQpoNwMm4FPMwJvzHe3Zi2S9Hz0ZsFXyv17vWYNBW
	 /kC7N2xKGa8C430pW8n4nGUlJilTXGp3JZMRA4clWvh7NpLCqXlYwthBsXgABZkerF
	 5Vpj47B50r+czaKNstGy0zGJGfBmB9vVErCVF5s1Q63xn4CRS3KUiTk4f5RVUyrmXD
	 tanr1ikilfjVg==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 09/11] mm/damon/sysfs: split probe setup function out
Date: Wed, 24 Jun 2026 07:20:05 -0700
Message-ID: <20260624142008.87180-10-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260624142008.87180-1-sj@kernel.org>
References: <20260624142008.87180-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 9DB9640012
X-Rspam-User: 
X-Stat-Signature: u4i6cadyqsuxu3cu3o4ew4giofwbdarn
X-HE-Tag: 1782310835-196508
X-HE-Meta: U2FsdGVkX1+dk++tOBjvV0K3McMLfqoXuAcynVMwVnG6kYqJBfBueNPTaC3p/tOAC+fzjVIaz0TCxuPI2ttMa3SZyNDU1+1rHJ6E2aW4qHfu2RUM7BYJv6lwFqeGRQJGkzp/3FT+I56aChhBXAeq5NNVUoIG5jrREX7eAW+9MhTJi32O4ybzJB5RVNZVjI4mCwuFEJe6a29GEtaFh/rLRiQHnNayalnQAwKwmMDA7e69EzM4vM8whzx0GWFK56wHB/Eoq33vNLcl6iamd+eCnv+S+GAAdh2ksl6C5u8/psdt0b5057jJpCgz2XFFYvaoQxQTxGosRIC8o0t1wlOmJI26/bM4sC5cMmwM66zBEBCV/7jH/72e+Ohl0nxLCKiUb8mDr6JOFIZrfm8DRmTVF5mUlyS/LsOp1BpQ1cb0s6HENFJGy+j/Rp9dF8csCPbiAltMtM9lyS3KyNnKckOCm7Lu3cPJ2OdGfjYBMOULcggbhQNnDD3kXazb2XDnsY5W/l4ld1HXs5BEnBY4oXZRbqFXRz9+8i9abLFWP+2/gaiHLzmQjn1+lPs77NalyJndhM4/CGfdVirZB5f8zcwinkhpfQM1v1h0Th4GVmA4AWmgj0k24EwV90z4MIWjkBraP4ra9nfIFunmvdEPTnbCtQ87Ngg7p51YW6rtBdH306rgwwWPd5PDIgQgTgMKiU5RqQZadjCzmHgUrQXUbH2BTSzlxi0m9dX4FsxQgNtuwMcWl6FD/42gvQV078tCp/zhCNXZySvEBwMleLglfs44wKIT6Xf57eah99bFrTAn2Kz3BW/MSCsf6H0mvv0KYEc7OiTZ2F9UST2ZMySnZtZduZizvcsrmzG3kD+88T4vHNQeITqtCatocZmszOHaZOlqudGrNkSJy+lWM/IwZJiIWhxOoklwztwQRmpbdpYdxTKAICpguT71ry+4dHK/tFcpA++eslFI0BhsgCU2ofU
 nqo61SBP
 LRsQOc53mwBTQaPQSHfF07gPf5jYrC0yeoOw6Ow3WJDovQyCZU7fyjiT2no2KqUyn98CtdocDLpF1uTH0Cu8n8ETjW6HF/SLHPZ00kOnoKMw3EcQbnObiNUzGhgWliL3nUNQPHkzcXZldTF/aZy1UG412hBAhb5qsz6pkXhPw9ltPpUg6Yrk2N87IbbJn8YxidYNlWpM2IrxWBiQ54yImQXQPbkbmkTQplbfJ9F0DFSmc1rk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_sysfs_set_probes() function is relatively long.  It has two nested
loop for setting two nested entities, namely probe and filter.  Split
out the probe level setup for readability.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/sysfs.c | 80 ++++++++++++++++++++++++++++--------------------
 1 file changed, 46 insertions(+), 34 deletions(-)

diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index ffbc99411f53b..b662afd41791d 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -1911,47 +1911,59 @@ static int damon_sysfs_set_attrs(struct damon_ctx *ctx,
 	return damon_set_attrs(ctx, &attrs);
 }
 
-static int damon_sysfs_set_probes(struct damon_ctx *ctx,
-		struct damon_sysfs_probes *sys_probes)
+static int damon_sysfs_set_probe(struct damon_probe *probe,
+		struct damon_sysfs_probe *sys_probe)
 {
+	struct damon_sysfs_filters *sys_filters;
 	int i;
 
-	for (i = 0; i < sys_probes->nr; i++) {
-		struct damon_sysfs_filters *sys_filters =
-			sys_probes->probes_arr[i]->filters;
-		struct damon_probe *c;
-		int j;
+	sys_filters = sys_probe->filters;
+	if (!sys_filters)
+		return 0;
 
-		if (!sys_filters)
-			continue;
-		c = damon_new_probe();
-		if (!c)
+	for (i = 0; i < sys_filters->nr; i++) {
+		struct damon_sysfs_filter *sys_filter =
+			sys_filters->filters_arr[i];
+		struct damon_filter *filter;
+
+		filter = damon_new_filter(sys_filter->type,
+				sys_filter->matching,
+				sys_filter->allow);
+		if (!filter)
 			return -ENOMEM;
-		damon_add_probe(ctx, c);
-
-		for (j = 0; j < sys_filters->nr; j++) {
-			struct damon_sysfs_filter *sys_filter =
-				sys_filters->filters_arr[j];
-			struct damon_filter *filter;
-
-			filter = damon_new_filter(sys_filter->type,
-					sys_filter->matching,
-					sys_filter->allow);
-			if (!filter)
-				return -ENOMEM;
-			if (filter->type == DAMON_FILTER_TYPE_MEMCG) {
-				int err;
-
-				err = damon_sysfs_memcg_path_to_id(
-						sys_filter->path,
-						&filter->memcg_id);
-				if (err) {
-					damon_destroy_filter(filter);
-					return err;
-				}
+		if (filter->type == DAMON_FILTER_TYPE_MEMCG) {
+			int err;
+
+			err = damon_sysfs_memcg_path_to_id(
+					sys_filter->path,
+					&filter->memcg_id);
+			if (err) {
+				damon_destroy_filter(filter);
+				return err;
 			}
-			damon_add_filter(c, filter);
 		}
+		damon_add_filter(probe, filter);
+	}
+	return 0;
+}
+
+static int damon_sysfs_set_probes(struct damon_ctx *ctx,
+		struct damon_sysfs_probes *sys_probes)
+{
+	int i, err;
+
+	for (i = 0; i < sys_probes->nr; i++) {
+		struct damon_sysfs_probe *sys_probe;
+		struct damon_probe *p;
+
+		p = damon_new_probe();
+		if (!p)
+			return -ENOMEM;
+		damon_add_probe(ctx, p);
+		sys_probe = sys_probes->probes_arr[i];
+		err = damon_sysfs_set_probe(p, sys_probe);
+		if (err)
+			return err;
 	}
 	return 0;
 }
-- 
2.47.3

