Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E19A1606A325
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 02:24:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Nx1g8nk8
Received: by kanga.kvack.org (Postfix)
	id 4D0F96B05D4; Tue, 17 Nov 2026 21:22:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4A5A16B05D8; Tue, 17 Nov 2026 21:22:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 282796B05D6; Tue, 17 Nov 2026 21:22:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 06CF66B05D5
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 21:22:42 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 90C4BA064F
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 02:22:42 +0000 (UTC)
X-FDA: 85446641364.21.63D38B4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id E16DC120003
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 02:22:40 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Nx1g8nk8;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794968561;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W6sgrGq/PIPvl2dUtr0MUNu6vsfTRiTVsaaYrgPkigI=;
	b=HIhjuDmZ07IeDhZy4M9BQxoSr9t4OYShq1+0kC4YqRQv+UPG3McK7el0UIcoZa/Sh5KiEA
	5mvMjdFMS389bMssWv90drffSFbkq2qDFpmGEHwp7nm0rqjxDoKcDbjHNRIAWq9z3gXfYR
	PllKn3Bc7gZ8q47f/KPg3tCZWuYSLRs=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Nx1g8nk8;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794968561;
	b=S/5baTaru6Vqq+mEWKkww0uucNSfgTUM+hPWqIxWRzg+dF8u/l8sYO5+oDrg6YNsUONiIL
	u1gJOdIBISYJUVwQ6giEligJUWtwtZDiScL1EX/7vuWXzY+Cva7SdNokXmuve5hi+faYiS
	1WMR+xqn2oaHpenMBjnP1BeC/gI8WRQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id AF96B44641
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 02:22:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6765A1F0093B;
	Wed, 18 Nov 2026 02:22:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794968560;
	bh=W6sgrGq/PIPvl2dUtr0MUNu6vsfTRiTVsaaYrgPkigI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Nx1g8nk88w+k5bEx5XcdXAfwU+9OiWqJRGKxYuZmw0O53h5HDZbLdkvsj7gAgWvTA
	 4PeHAObfpdNB0wTN9BCXw131W7TDlYQ+A2kA6gsAMXBf9/rf9umgorg+50rgTTRA81
	 gdjI+9/mQs+LAjSPYmLXClCn/BbHfeZIaR4SV8hvNOpu+vZoaUjcIkHH4/FOW+WcMZ
	 3HnpKMPi5TU/jXej9S1C4m3BNPpz/oRIU+LUUf4fHmgADhdr56kfoRIyb4gpDBPi3E
	 Kou6Tde9TodAlqRDzff8jmYTiwgzwr/C1vigVzF9OBHgsGlm0UxIX+VhgJzMAd7xQf
	 Kw8xcSnK3aCKA==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2 24/27] selftests/damon/sysfs.sh: add basic tests for admin/reports/
Date: Tue, 17 Nov 2026 18:22:19 -0800
Message-ID: <20261118022225.100659-25-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261118022225.100659-1-sj@kernel.org>
References: <20261118022225.100659-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: E16DC120003
X-Stat-Signature: heuiagi6wnr68n4huta5jz94aypqcaje
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1794968560-177542
X-HE-Meta: U2FsdGVkX18o3o/e5r5JymTs4sTotegEB/2hcyDcCTVBR69bd5xBpOwKvQQyIGRGFZiJ6JrXx7bU+60YkbRKhM2WvAvdUeH4sfn2Qjdd7SQ1NwBnxrvNZSdd7N+N6eTC1Hv3q/zs8wxPtj95jVevVIXqAiNYo79Dn0Ksl3ppJ6vtu/+GgSoZVgvs5bSxRjTTqYWKlF4MiT1HWXqfbo2KuQYYKGdi4ganF0Qpbk1ImFVAqF/+KVZnchWhZPVjSk2ZL9irmOtzKCJywpLwHITFa1sZOR0aXew/geCfE0qB19LLxgDHnrIn9fzej9esGOs/uhVXw7QrGASfv3R1MY8drWHqtwFmvp/OA0kYjc+nQydRPfjWf2k3otiIxZ9xL0IQ4SdGhUKMmsnXIp6gSJlfC4DSbipFDVYOgL0z2+huZihlleUuRWm2GMi36X9jkj2+Iu5e6Y6RfceGcYgHIVOQsCIDxZai/zCkzXqgwXANvov3NenrZN3ZgCMyMSgzBe6z4D5Bkyof0v9ZwNP0LXnvJiTjyrIC2yu3kkZFmagZDiNxjZE2mUwzeTWNq9kFwdwW3AaXHNuXiK7BiZ/YnwH6Wzutsxd+z80vsRmJNox9Y9s2rzmxkFY9ZSLhZTZ3wtTi3Qg+G1am/Qu68p84zKLZc5VIjIuVwdvf5bEUk53CzPpmSKB70FK5/NwqiyogueNp8SCbXKUM2lYUsbXeT3XgU6QX0R1GbtwXvoRzNjczEDT3MIXzKYtsHQog8lCSVQ38rffoEdIgMUuc8IesKxcJ+58tP4G4CtaoQnkOaW2I7OMC9/ZNAMSZDjmHIRpljShaBe6/1KDWlf7ZfE5n35X+RmnPE87VyIiAUvqcmbDGYJetELSUNH2e6cM/78FTSryM3+3c9wrmiXa9PGW1CJG1NIpmZ8r4J3YHmUSpTw7hbJV8fqj5AwX/oljdJu9wRjnnengXCsQhJzJGQCVGMCJ
 QdTEjnRY
 FY+kOSOCI1oVVX71q/AJrjHm48BQBXD6bFW2l9h10upINRF4cIZpyUM+Kke7iQA+olJvun027XuOI1wyuGq+LpIHtedKIWvAzsdPrXRRZBv5FvHLeTtan6ENKLXO7szN08G1aWF2TXXQkWLGmb87v0W4qxdZAFwRLWPoJwl21+dtLCTpJdtCi38fn+/u4HYou+kKS+uTzDOUzsHyhKLFSIrg6WprAg9ZUP8b/ykA3ZQLNawfU5z1+9BZf94+m2VIYlb1+WKO+xQKG+PIf/hf5t1TAWfE18eMz0AFnGwgyLipvt2o=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Update sysfs.sh DAMON selftest to cover basic file operations for the
sysfs files under the admin/reports/ directory.

Signed-off-by: SJ Park <sj@kernel.org>
---
 tools/testing/selftests/damon/sysfs.sh | 52 ++++++++++++++++++++++++++
 1 file changed, 52 insertions(+)

diff --git a/tools/testing/selftests/damon/sysfs.sh b/tools/testing/selftests/damon/sysfs.sh
index 1cc7ab2d7e22f..577953ee4e631 100755
--- a/tools/testing/selftests/damon/sysfs.sh
+++ b/tools/testing/selftests/damon/sysfs.sh
@@ -510,6 +510,57 @@ test_kdamonds()
 	ensure_dir "$kdamonds_dir/1" "not_exist"
 }
 
+test_producer()
+{
+	producer_dir=$1
+	ensure_file "$producer_dir/report_type" "exist" "600"
+	ensure_write_succ "$producer_dir/report_type" "user_report" \
+		"valid input"
+	ensure_write_fail "$producer_dir/report_type" "foo" "invlid input"
+
+	ensure_file "$producer_dir/producer_state" "exist" "600"
+	ensure_write_succ "$producer_dir/producer_state" "on" "valid input"
+	ensure_write_succ "$producer_dir/producer_state" "submit" "valid input"
+	ensure_write_succ "$producer_dir/producer_state" "off" "valid input"
+	ensure_write_fail "$producer_dir/producer_state" "foo" "invalid input"
+
+	ensure_file "$producer_dir/addr_start" "exist" "600"
+	ensure_write_succ "$producer_dir/addr_start" 123 "valid input"
+	ensure_write_fail "$producer_dir/addr_start" foo "uinvalid input"
+	ensure_write_fail "$producer_dir/addr_start" "1.23" "uinvalid input"
+
+	ensure_file "$producer_dir/addr_end" "exist" "600"
+	ensure_write_succ "$producer_dir/addr_end" 123 "valid input"
+	ensure_write_fail "$producer_dir/addr_end" foo "uinvalid input"
+	ensure_write_fail "$producer_dir/addr_end" "1.23" "uinvalid input"
+}
+
+test_producers()
+{
+	producers_dir=$1
+	ensure_dir "$producers_dir" "exist"
+
+	ensure_file "$producers_dir/nr_producers" "exist" "600"
+
+	ensure_write_succ "$producers_dir/nr_producers" "1" "valid input"
+	test_producer "$producers_dir/0"
+
+	ensure_write_succ "$producers_dir/nr_producers" "2" "valid input"
+	test_producer "$producers_dir/0"
+	test_producer "$producers_dir/1"
+
+	ensure_write_succ "$producers_dir/nr_producers" "0" "valid input"
+	ensure_dir "$producers_dir/0" "not_exist"
+	ensure_dir "$producers_dir/1" "not_exist"
+}
+
+test_reports()
+{
+	reports_dir=$1
+	ensure_dir "$reports_dir" "exist"
+	test_producers "$reports_dir/producers"
+}
+
 test_damon_sysfs()
 {
 	damon_sysfs=$1
@@ -520,6 +571,7 @@ test_damon_sysfs()
 	fi
 
 	test_kdamonds "$damon_sysfs/kdamonds"
+	test_reports "$damon_sysfs/reports"
 }
 
 check_dependencies
-- 
2.47.3

