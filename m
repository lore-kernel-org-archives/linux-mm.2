Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7BFCA606A321
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 15:13:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=X6IPU5uk
Received: by kanga.kvack.org (Postfix)
	id 4E7DF6B05B3; Mon, 23 Nov 2026 10:13:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 46BE36B05B5; Mon, 23 Nov 2026 10:13:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 35A2F6B05B6; Mon, 23 Nov 2026 10:13:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 149C76B05B3
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 10:13:21 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A4C22A0942
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 15:13:20 +0000 (UTC)
X-FDA: 85466727360.22.6896082
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 0C70CA000A
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 15:13:18 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=X6IPU5uk;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795446799;
	b=wUjMcMW1bijO0pjyQFmBwXExix/A6UYH9zqRbinaWqgGwWzapCiWa7OL6kwP/vuLERYsSm
	KAwArQmqA2Vp0zAy1nEdRrEtNw1iXV+EnpyB7ZkMV73Cc6lM51S/DPo1laIAMfK9kS+uxm
	nZc4on4+95OpZhEl7164RIe4/YNP3sc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795446799;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mLxLJ8l0Ff3sL09Q96DcxX0CNZnNS+MEVi4Fs2AfUmE=;
	b=FbDgKO03wEWXlnkyZtIYNU7ZGOFm3Wl2g4AdBzMP8DuvEPWfL/HhdsYL7DjwZKOZh68x0S
	4TCaDNwCIA4rMChK+N5rPPvi9r9EJl7ovwH3FhcYjHalRHp6tvyL3Y5XfuIwk7y94DVlZJ
	zMQxT+AOoIBioS1phimuNVgZOhB4UPI=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=X6IPU5uk;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3EE3C61413;
	Mon, 23 Nov 2026 15:13:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C3361F000D0;
	Mon, 23 Nov 2026 15:13:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795446797;
	bh=mLxLJ8l0Ff3sL09Q96DcxX0CNZnNS+MEVi4Fs2AfUmE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=X6IPU5ukO3vA+LUlcrhEnvvQFNumCquDdR3nGXDG/Y0gkprdJ/DBsdGnG4gh0F1+F
	 WaJN3CXG7bUCxnBU+ERr3gBF1epY0/BGg/VxqbfnpvnBXTCss8U7/3JNEk7YtsRFR9
	 6nVk1KGyUqv0AfAhDQ1EIxEZlWSdsCTIC6RK8xLwHd3i7Ka4+Srw/IaT+lAzdrOxVi
	 hkSeTnq/v9BjNpJWDe+dTwP7tU7boOOWbl3uKXFNwMQD/y7Ly70R3USNGy896mZBs/
	 j0IrXfWIJ6p3/xoGUTcNzQUb7FDLcpQ2j6uEh46pI15AcZItAHIHIiCEbvhjcNA2NE
	 WMmdYt5/Za/rQ==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mattathias Pinchover <mattathias.pinchover@uber.com>,
	SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: [PATCH v3 1/6] mm/damon/core: introduce sz_ops_filter_passed_last stat
Date: Mon, 23 Nov 2026 07:13:02 -0800
Message-ID: <20261123151309.82675-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261123151309.82675-1-sj@kernel.org>
References: <20261123151309.82675-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 0C70CA000A
X-Stat-Signature: dxpa69etc9qaq5diug4b56hspxm4oxao
X-Rspam-User:
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam06
X-HE-Tag: 1795446798-605693
X-HE-Meta: U2FsdGVkX1+g/zlNYNQh6IytzsqM+5qLbNXxtHAKS1RaM2daH//3FrgybMVozl6ug3r28Wt+7R97MzNmnEI0lpwaCUXGTvqbME6A20FND6oXC6g7Zl1KyUhd63vt2cwkbX4qMlFNgvj1Udofid8xQgw/O0XPaOjJEv5lV2f7p7oFJLi56E7zTdUSX+mWOXcvemEy2fVmGlz15s8bTDYxAnolYydmUqQq5SttEvp3z9ouBePJMimk9g9wioNcVWQClUmnv36zzwLGgrKuygwZSoi9Pmbjb+FPMYprjDTtfTCqJ4gBWrPacuhvfWFr0FXG1nSuiPujSQQHTAOf5/L1DGUQf25oz3H0fP2baZsuXnEA8jMdpUMXCcQP+TswSOruQf5jZevVDBdqsgmR1I1ryalqtF6mFPN40atw0jqNqbegMViJfsfiAzBJjo0lOvvJN2d92iacOOr5b/y7opW34Mx2DDKtPTwH+zlVpDscuKp4KJN3BsVkGY5Fd4aMYozayO9nbHf4Bq9EUNBDO61LewpmKDKj+2hzEyUFJsm3SxgQ2LpAfx55jvGC6f2w7C9TREvUtOd1b79idBr8pmc99gTpARKAUMiYJDg9uSq5U/S06Y/mlBjmOsV3b2NWqShs8FIKe2TnSe6Ch4fnVl+sZouNOEM5HYY4hBBhFkY219njl7hYN2vF2Pt1+ypQ4U5BLHDXaNdyJzMnDV9/nJptutryAXV/qUm/IHq3Z+GS7BUvPgcEI4DGY5j2DXYfYZaJXTEPlfe4v5PZjciZMxrkUar4y+Lhn4km8Ebmc4vEmwtUHD9sQVObjdQTdtQ0FEGeA/XXVKALD9WIPk5+Iku0sO03DNeZ0LDJ+LdP4A12w2YcspmHaGTrSSkamyJC7+X74EbcIhmFoxxJup8MQb+SvJC1UyHKY+D2K/kd8rEmcjrdmYmWZrNQdCRLNQiM/U3CrRYsFooVfepPOQsfgS0
 5+hetb0A
 guDJZasSdxMy/PMNIirGATjRh0X7lAJJaP1VilSSpKGDmjL8nCDLUl8Qa4Ejm3TGdsfzU8S6VJbENQNFvnIrPDplhfgsUocfCNk64Mr1WHXeMFJcCnINcdwX9/NocrF5vmWtyAdyu96TCMF99T3/fUHgdbOUhU+kGHq4qDs9YGYMK6dTWjoKlCfxqAOd+T8sJ42tKejrbZEpdBKXTn9Lyun/eJW9UW7PsFJK7SjFAyB9MOA1VXH+41i2Mrhd551cuH61B1k7v+nrhUfs66Fm0x2ayW78nwpvG4S+b4Sn8V32zbKgrUXOujQmhrp8qu2wLcA1LS6aV+s+jmNqhjQCGd3xNZK0t2lXACbUzg6Fib8bvQnRdRsR0h8vtkb0qkCSLcaONWM1qDRlXHeyMUXgl9OVZBCcdcsUxBBMJv8HDZ3bEk2mho1h7Md/Vx8F6cpNQkHTntZ4pYfUySOz0oBflX4f3i8UjftRh43LJ3VRPeS1XeqebkRvPrInZPl2bOPK2ga3ESNM3XrPcOMpAAqNrEnSsOA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Mattathias Pinchover <mattathias.pinchover@uber.com>

DAMOS stat sz_ops_filter_passed shows the total bytes that passed
operations layer-handled DAMOS filters, accumulated from the beginning of
the scheme's execution.  Users who want the amount for only the latest
apply interval, e.g., the size of a workload's anonymous memory that is
cold as of now, need to keep the previous values in user space and
compute the difference with the help of nr_snapshots.  Because
nr_snapshots is increased once per target per apply interval, the
computation is complicated and error-prone, especially for contexts
having multiple targets.

Introduce a new DAMOS stat, sz_ops_filter_passed_last.  It is
updated at the end of each apply interval of the scheme with the amount
of sz_ops_filter_passed increase in the interval.

Assisted-by: Claude:claude-opus-5-5
Signed-off-by: Mattathias Pinchover <mattathias.pinchover@uber.com>
Reviewed-by: SJ Park <sj@kernel.org>
Signed-off-by: SJ Park <sj@kernel.org>
---
 include/linux/damon.h | 6 ++++++
 mm/damon/core.c       | 5 +++++
 2 files changed, 11 insertions(+)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index 06bd92981af21..3aff5c525132b 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -351,6 +351,9 @@ struct damos_watermarks {
  * @sz_applied:	Total size of regions that the scheme is applied.
  * @sz_ops_filter_passed:
  *		Total bytes that passed ops layer-handled DAMOS filters.
+ * @sz_ops_filter_passed_last:
+ *		Bytes that passed ops layer-handled DAMOS filters in the last
+ *		apply interval.
  * @qt_exceeds: Total number of times the quota of the scheme has exceeded.
  * @nr_snapshots:
  *		Total number of DAMON snapshots that the scheme is completely
@@ -379,6 +382,7 @@ struct damos_stat {
 	unsigned long nr_applied;
 	unsigned long sz_applied;
 	unsigned long sz_ops_filter_passed;
+	unsigned long sz_ops_filter_passed_last;
 	unsigned long qt_exceeds;
 	unsigned long nr_snapshots;
 };
@@ -578,6 +582,8 @@ struct damos {
 	 * @action
 	 */
 	unsigned long next_apply_sis;
+	/* @stat.sz_ops_filter_passed at the start of the current apply interval */
+	unsigned long sz_ops_filter_passed_at_start;
 	/* informs if ongoing DAMOS walk for this scheme is finished */
 	bool walk_completed;
 	/*
diff --git a/mm/damon/core.c b/mm/damon/core.c
index 986404b547ebd..a99663f1f7ef0 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -769,6 +769,7 @@ struct damos *damon_new_scheme(struct damos_access_pattern *pattern,
 	 * or damon_attrs are updated.
 	 */
 	scheme->next_apply_sis = 0;
+	scheme->sz_ops_filter_passed_at_start = 0;
 	scheme->walk_completed = false;
 	INIT_LIST_HEAD(&scheme->core_filters);
 	INIT_LIST_HEAD(&scheme->ops_filters);
@@ -3532,6 +3533,10 @@ static noinline_for_stack void kdamond_apply_schemes(struct damon_ctx *c)
 		if (time_before(c->passed_sample_intervals, s->next_apply_sis))
 			continue;
 		damos_walk_complete(c, s);
+		s->stat.sz_ops_filter_passed_last =
+			s->stat.sz_ops_filter_passed -
+			s->sz_ops_filter_passed_at_start;
+		s->sz_ops_filter_passed_at_start = s->stat.sz_ops_filter_passed;
 		damos_set_next_apply_sis(s, c);
 		s->last_applied = NULL;
 		damos_trace_stat(c, s);
-- 
2.47.3

