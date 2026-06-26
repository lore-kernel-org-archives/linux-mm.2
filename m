Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 669B7CDE008
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 00:17:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 809F36B00E8; Thu, 25 Jun 2026 20:17:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 76BE06B00EA; Thu, 25 Jun 2026 20:17:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6A8E76B00EB; Thu, 25 Jun 2026 20:17:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3C5516B00E8
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 20:17:14 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B67A840338
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 00:17:13 +0000 (UTC)
X-FDA: 84920149146.11.E89FCF5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 2E40940007
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 00:17:12 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jJo+Od0z;
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782433032;
	b=URKrzvxSX2NVC4CZO8xdPDadQOulubTiKtGRmtOYvIAdhqgWNn4lNbCYoWYEN0pYVv8B1s
	tCawEedLg3mjVzR8KZVOyG8N6TqQiPnEGLKLiP9zVtkA7p5QboKwvHj80zp1ZAHSp2mRLn
	XRzCr7nZtb7YPZSvXt3k2109eP27DQU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782433032;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J66HJiTvNrVHrkrUjTA08Y7jf1bcSRDPMBd43t60n5w=;
	b=K+Y0H2mtyJfYwsbGKl2l0yg5591QVGbhz87eX3wUatJGNQnK/5+tQHtIVcmGkuTiGtn85Q
	OCuTFPSAymPh4955M5bIoMR5cSCiapaijvZlbLCtxKB9X6GjbN1zK3i4WhTO9+0fyYfLDo
	uYa3l+WwyM3dqAeqwLm1srSVetq5OE0=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jJo+Od0z;
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C5D5B6012A
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 00:17:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E3191F00A3A;
	Fri, 26 Jun 2026 00:17:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782433031;
	bh=J66HJiTvNrVHrkrUjTA08Y7jf1bcSRDPMBd43t60n5w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jJo+Od0zWitDtwwpCn4mP2LcyUeaYrd3K8v+melNtZ6/8f2m0oVagJv1OEwVWESNf
	 AogvKgCLmmkbCs95QYANYPGLKvJVWDa4DU3k8+s3gCS6nSxqBomuFU2TXlT269610l
	 liUidd3QzVwr+bPs9MY93hcTfiqRk0oqSS7KUGGVHdVzgxkF1sgNLc1Zivj07mVZ/N
	 Pg5WDUHyN4vwb2B4dUP209Of30wgoDgZmchwcuvSqlPLQ3DYlR+gdt8ua1n46JnhJV
	 AgTWiIwIa+9Re9cO/sxuafJm4yh4n8Kcd2a+2F7+HCnKGknr6IRFGqeoXj1G65z4kb
	 E76l7/Ccffu5g==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.3 07/11] selftests/damon/sysfs.sh: test all files in quota goal dir
Date: Thu, 25 Jun 2026 17:16:38 -0700
Message-ID: <20260626001644.85825-8-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260626001644.85825-1-sj@kernel.org>
References: <20260626001644.85825-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: pqo84dzam7udxpi9wptowh4cdze7rfm8
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 2E40940007
X-HE-Tag: 1782433032-178951
X-HE-Meta: U2FsdGVkX19SBdhAvCplaGIQlMFX3Qw35p63kYnXVKm/WIo5KwIO5GOQQddlw6wM5nWpvOfN8vCCPR2cz91NF24zerZk12kmYHo/zWbRWX4OCJXdpSzvbkX+CRpDRgnCw+pybNmQ7n0TwAiqibCeRPm5oHqyClTQjMFur5vqkOWNvXnK4O3gTNzIspMRSQuJEGRgCpW7ZU9sjjfvBAalm6YWs8kizEGh7Iy0UnhZMYHCsgM16a7Z733vJNjAElMmwN2l/TbvpDbembScZZKxREaGtb3EFgEuUCylsly7jf7NzusNtsKBE9ABrNT73sNpQUVFiKGeDAX8x/9C6XyYfKfv7g6H5AeldDPtCZzU79EPaAB1wteBJxRZkKQksrta8nATrnY0iZ/CcH0WT/X6AReo1Z1JpYtXVcGvPCCTUdQSQg3Dxq0zkgtVpKkPWAdqh4XcfJy4euDL1GXN1mi2Hm4pxWBcGZiOw4sGbNhPqpZCEWaTkiOgZP1Sy7pdzHVb0CNv/4R5lhJXqMuzTVOXyQhrg6PO9KzKDUDh/83F/qrvN/aYrUl9CLsAU5rGl8KuUuqzpgIFY+O8o1Hkl5+ak93IyzHy5oKhEMkNZOz2bnv5797ZX+Q93H3d5cVfZxrNIPPD95ilWAwqNsA0tft14UzxsqrcVm65kwR9TV5U74QzFsDxl/AYVCu+kqMucMVAJQLpU02UXJBDM0cz23MwiMrzvVArCwsBp84BQlX4rXEh4fJ+jFj/guoRb/nqAtcsBLAmtasZ+XqjKp6fFtAoxzrSM1I+TZQgQ6Q/rbRFwNr32DxScKwDTzpaFY39bw9zolV8vzFjuQyJJsiFRJLzS4P2e8dE4nD8ycQ8xeoL+C+klxWk5rO8FbwS93XN3nAoHa6ctQwyIU95TFjkaumxwNrJHKtxpNs+6zvD4H2sA1s1qhrQMEEJdscyIgBHkiAQr1iSc3H4lqRpgfn17ue
 KLyTLRTe
 ENHXyGP+Eg/EhUIBuS5g6CH5+8HLALV1uJmJNodt7AbCiSYhH2h7B5gEPjHQgSKHU113JNz7K9VaTZ+nneqtDwgPBleC7YahW2MJ+Qz0gOC/tLjxfWKx9+cLC7+X4PPv5h3Sc7nSSKv/bUlW800GcWmB/SVBpQdkRSgYZd6cu/b2bcL29EGPJ+nWMbTKk0huzFwa/w4OIYS/P1PmYFNC65+NJyYssX6LweunDNPoCjL7AIUTF1zXOUeh/GE6y253/J6iXBgozMQOolEa/VTskOGTll828zgO6sODUPISvZ+2S5n8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMON sysfs interface for DAMOS quota has quite extended since its
initial introduction.  The test case for that in DAMON sysfs interface
essential file operations test (sysfs.sh) has not accordingly extended,
though.  Extend the test case to test all existing files.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 tools/testing/selftests/damon/sysfs.sh | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/tools/testing/selftests/damon/sysfs.sh b/tools/testing/selftests/damon/sysfs.sh
index b88bf7b98d7f7..811173cb89449 100755
--- a/tools/testing/selftests/damon/sysfs.sh
+++ b/tools/testing/selftests/damon/sysfs.sh
@@ -199,6 +199,20 @@ test_goal()
 	ensure_dir "$goal_dir" "exist"
 	ensure_file "$goal_dir/target_value" "exist" "600"
 	ensure_file "$goal_dir/current_value" "exist" "600"
+	ensure_file "$goal_dir/target_metric" "exist" "600"
+	local fpath="$goal_dir/target_metric"
+	ensure_write_succ "$fpath" "user_input" "valid input"
+	ensure_write_succ "$fpath" "some_mem_psi_us" "valid input"
+	ensure_write_succ "$fpath" "node_mem_used_bp" "valid input"
+	ensure_write_succ "$fpath" "node_mem_free_bp" "valid input"
+	ensure_write_succ "$fpath" "node_memcg_used_bp" "valid input"
+	ensure_write_succ "$fpath" "node_memcg_free_bp" "valid input"
+	ensure_write_succ "$fpath" "active_mem_bp" "valid input"
+	ensure_write_succ "$fpath" "inactive_mem_bp" "valid input"
+	ensure_write_succ "$fpath" "node_eligible_mem_bp" "valid input"
+	ensure_write_fail "$fpath" "foo" "invalid input"
+	ensure_file "$goal_dir/nid" "exist" "600"
+	ensure_file "$goal_dir/path" "exist" "600"
 }
 
 test_goals()
-- 
2.47.3

