Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 15E2B606A31F
	for <linux-mm@archiver.kernel.org>; Fri, 27 Nov 2026 20:39:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=R7H03EBC
Received: by kanga.kvack.org (Postfix)
	id 0D9AA6B05B0; Fri, 27 Nov 2026 15:39:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 08A2C6B05B1; Fri, 27 Nov 2026 15:39:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E6FBC6B05B2; Fri, 27 Nov 2026 15:39:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7FFCE6B05B0
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 15:39:48 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 072C1C04D9
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 20:39:48 +0000 (UTC)
X-FDA: 85482065256.07.9118DCA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 85C5F1C0008
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 20:39:46 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=R7H03EBC;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795811986;
	b=wg1uur3L/5hFb906jdJOHcYDMknd6Y9CKIoIqpD20bH9GXnbFUnYw9bJA+PwGUSNBH/Xeo
	7oFxj2JCTxXGCZ5dy6n7Lz/kt9vOesLIVVAm4MxUHwIWbILy/xIb54hhRbDPBDP9dJcEYy
	eS7cntUO3yJgOmoMfQUzqKpxUPAa1UE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795811986;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=vmt/h+98quVGznsKJZsY/ImK2ypo6iML2/iEdcnVAoo=;
	b=UJmgqYncqNCNS4DBf8xPFSjRJbP7MXHtvNAyMgiahE+Ch3ydhTtVcVVIul9GaKf4AfyBNc
	LeAXUQGAZd66i0bgIUXRsY4yfpIRtjDJ2zahiDD8kPN3Gckzl1M3CAmXQCtDPqg4YpzqE4
	N9vIMwzzbbJZDfTwIF2p5gM51MKlYug=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=R7H03EBC;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 068BB60052;
	Fri, 27 Nov 2026 20:39:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BB391F000C1;
	Fri, 27 Nov 2026 20:39:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795811985;
	bh=vmt/h+98quVGznsKJZsY/ImK2ypo6iML2/iEdcnVAoo=;
	h=From:To:Cc:Subject:Date;
	b=R7H03EBChbVbrwQSrjrNCNuD0itWNBGvyWIwRLe9eT+DnCDFEY66kmlzxqkdjtSj+
	 PojwkufUvwEy/87dRB+S+r8W1vu1vu1DshpmMhsI30PVaFWFd+pFdJUpxn8nITVj8k
	 ZoSP12+W1hjKk0IcRhuFZn4jEPP/WsW9J374RCTuLf8d/YgjzP3du7rcp5fzk5dEPu
	 j4YOEoLqXyBgLHIZmBnDtwHKmTDcTcVzztV/cKd2xA2peEH+rivsdZtgVUdm9GW2B4
	 FILvjCStLES3qEmtjUTAXr2E1nx+pN3WK14IZXvnKuf8T/Q4uZIPtkU0qSrDRhoeJV
	 Orm1VsZvAYJlg==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	stable@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: [RFC PATCH mm-hotfixes-unstable] mm/damon/core: do not update stat for core filter rejecting region
Date: Fri, 27 Nov 2026 12:39:37 -0800
Message-ID: <20261127203938.94339-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 85C5F1C0008
X-Rspam-User:
X-Stat-Signature: efh111xs48mrzh6fnm9eiaipqn6r3unc
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795811986-937613
X-HE-Meta: U2FsdGVkX18gOIpL/v/6nWm47om6fYMlKaWgV/HheQT4G3oa0ixbkfbkRrHL3MxHeVuyB/KfTk0lfd/1xB+2wCR94msLxPSZTX3i63BKaIs5hjIuesdi6aN7WhKVrpgf0U7s0+5hP4sczP0/K8SRrl36zAJoSiWRmZCLro84cDwprf3nI7RjOtNCx2s/dwDMvtYmjB0OTI2QTEKUZfQXyORg5tyoRx0uzzXKSxMyBjS4j2n6N9ocz/L9u3KuiVJYyxFCjIdOw29eirvJinQRopEfCJZ+ZU8VyGIsye9R/uVDFNGbbejy5oEgnPy6yyxfAg+7LHAJw/sz6jPG4BRUi7ElasiNXkIUA8SDz91UXUKaVleWl15bg4uaPn662MBTuIltu1i3dMa9QF/l1AdKWLjOIWfzq2mhABdAxMKoV1bGxvB29AiBCS2wXwx6BAuQIl4qjS/O4NJuSqHBNqutOvBdX/cT2bwpJ5CRMzeUqqkKBxyhLk7hpJTPsZNFBdshDXPfyiB7wBtKiXUY+1YQ/IdWR3Z+HE/NRS335bDua6aGGjwiA4Mr6r9IYUSmu6qKr89jaJQsfhpnlTPwcp70DZe0U97IRGrvRi01/ZoI6iu1ZswH+lKEFIxVKu0MeXTkymMSG1AKQPQ1zTHKlev9JlxNkGEWNiZNwvykHmtcodEOmrHnLUbOH+a74dHsr6gPW+JebH8j81iWCSyX3ZPRLgV2Dtyup2rObM15D/6oYY8zt5+nHcLMMJHkfwN6d2SQMJk77pesHFZ918CvOw7YSZtp75tCRP+bUvhk7iTkhdEf9zZM1DQuo5UuIJZPoc5n90SS0dYuy4xgtCTFbUhA3mueU9STvHRsXO7IY/DokGAo5iG56Wt5PZozGu8mbKB3Kw6Hr+g8ojYWxS+kzAMkzyzBtMDD4xy8ZHO5kDaQnX/gwvd07MJev5nBaLmFevTLJBM0Yhp8I86j7fIp8k+
 pZCm1TkZ
 d0twOaE72jATneED1ETDG8qNfYkpr4W3ODQSNc5Zo4RK0Zx3/me1ImAOpFjt25t1Eo2M8C/a03tRnQlAvZ8Qn3+bjQ5hwrgmoFgNq4yoE/BHjN5nTi7ZVvJJctsVn78gNppZY97RhjZ2zJ5tCU7l0iVJtTSFtSX7YlHfwfiGhj5yIf/aKerD6XCu6CKBSd9ZC51CYi5DQG+j5VaAOoNjxyaSvKga+Pk59E+OG579dPLhdjKtbnxb5mcJbSbiGCETrfR9z2Tn2J8sZoeVKlRO8SKMJCbp9MTyaOnc5hQ5GDqcx6uQEIp1l+bmOVicXe4ZIkFDn6EWrngL0edtpfs1N5xwq5Z5XMldgB/EKOtARPFaR7G8jrAxGvIF02f2ohKJCPsklHwSfiW5wj/gmtyxXgUFWz9j4WCvYGFywh7drp31nMGnBtQK/OiOAnJMYXzg/UD9ToUgJJXfUKq/WslCNF6c0Q1Kwpidy9Lh76sG7Ditxzz06IzFdUy3N1qnC1TVLk8Ye
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

damos_apply_scheme() update stats for regions that were unable to apply
the scheme due to the quota.  Those are counted as tried and failed.  It
doesn't update stats for regions that were rejected by DAMOS core
filters.  Those are counted as not tried at all.

However, the DAMOS quota-driven failure is handled before DAMOS core
filters.  Regions that would be rejected by the core filter can, hence,
be accounted as tried and failed.  As a result, users could show
confusing stat changes.

Fix by handling core filters before quotas.

The user impact is not critical.  No crash or leak happens.  Only the
DAMOS stat could occasionally move in an unexpected way.

Fixes: ab9bda001b68 ("mm/damon/core: introduce address range type damos filter")
Cc: <stable@vger.kernel.org> # 6.6.x
closes: https://sashiko.dev/#/bug/linux-9c51890e-a25c-4534-afab-ef33f22a9557
Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 0e6b361f97ea..e0ea93de100d 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -2785,6 +2785,8 @@ static void damos_apply_scheme(struct damon_ctx *c, struct damon_target *t,
 	}
 
 	if (c->ops.apply_scheme) {
+		if (damos_core_filter_out(c, t, r, s))
+			return;
 		if (damos_quota_is_set(quota) &&
 				quota->charged_sz + sz > quota->esz) {
 			sz = ALIGN_DOWN(quota->esz - quota->charged_sz,
@@ -2794,8 +2796,6 @@ static void damos_apply_scheme(struct damon_ctx *c, struct damon_target *t,
 			if (damon_split_region_at(t, r, sz))
 				goto update_stat;
 		}
-		if (damos_core_filter_out(c, t, r, s))
-			return;
 		sz = damon_sz_region(r);
 		ktime_get_coarse_ts64(&begin);
 		trace_damos_before_apply(cidx, sidx, tidx, r, nr_accesses,

base-commit: daba53bdc1a54c453c2f4ced54a1cd52416c3f87
-- 
2.47.3

