Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A3EC7C9833E
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 09:34:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1986C6B009D; Mon, 28 Sep 2026 05:34:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0D4716B009E; Mon, 28 Sep 2026 05:34:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EDE8F6B009F; Mon, 28 Sep 2026 05:34:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C87CF6B009D
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 05:34:08 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 449CF140166
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 09:34:08 +0000 (UTC)
X-FDA: 85262659776.14.7C3FE74
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 951B0A000A
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 09:34:06 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Injtth2z;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790588046;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s7JRcQFcD/nLSCcRzyB24nV92nZBWi01kt7jJ+1f3Ug=;
	b=vbA2PljGeWiyfwp0swfHVXb9ofSyj51WW76xF6ThZyheJiZhLHwEj5PEGGPJVhrvD8F1NL
	lZqEmNMPneLhsecwNJ2a+mFoLLVsxN5kkGckPZjoxEcfEYbKCy+2+42hwGgJggjItVO864
	CrAZ6SDAnz1cPpVzou2Py5r74RjBX4E=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Injtth2z;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790588046;
	b=G4Tmb7raBLzNkM6yYXJoNXWiCLlOQ0gSFRrPYg+wXCL/mz8fpdyq8rae3bfUdLtd+T3laU
	p7JbhaYvNaR8hA4ewtnAHEsLJ3lqtrFuk+MpCeN9WD8BeYlgtljSds0vkq4lKyquL0ZfXj
	4y7Icl/0J25uTCPLuA5xBvG9E3UhMlQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D18E443D5C;
	Mon, 28 Sep 2026 09:34:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D1751F00893;
	Mon, 28 Sep 2026 09:34:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790588045;
	bh=s7JRcQFcD/nLSCcRzyB24nV92nZBWi01kt7jJ+1f3Ug=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Injtth2ze0z9yQyo0jMYhTnxbbBYaoHhP7ruFI3z+AthM2hh5XaeP0j5e/1UBurzz
	 gRQW5fB1AGbdoTYsj1hPu2mgo3mn4gDPdMeDd1RvDeqByz3y4K44D9/RllwnkEYOrR
	 qpB6KT1d+TsM5qocQ1UFSb5+9ppyPZ4s26oy/hkq6dPJICyMcxNiAQjfDoW8S0/7Pw
	 d5mFsW0WTv2VwmQkRtHKibEZterqlp0jZZmS4DvIw0dFqXtyR2XRVFk2GHGVQC6nbR
	 wHF4wKG7dNyTBLDPfRJXY0Q5PkqDF0N4DuQJXMxq01vST+0WR3o9HJzoZye79b6q/3
	 Ser6yPY5Euaqg==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v5 6/8] Docs/mm/damon/design: document damos quota goal complement flag
Date: Mon, 28 Sep 2026 02:33:38 -0700
Message-ID: <20260928093342.16584-7-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260928093342.16584-1-sj@kernel.org>
References: <20260928093342.16584-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 951B0A000A
X-Stat-Signature: no33hdr53e37838o71gyoaomm5agrtnp
X-HE-Tag: 1790588046-328227
X-HE-Meta: U2FsdGVkX1/fin70ibr5bxiTokG01ylkMvpCT1PKJ8DliaRso/GwcwThpD2pGAPdCIY2rU4SCN8DZ9E+GmoifnIvxOhZZhZQL79e1S7axWP4S+o+bJ5WTT07UfJv4TW1btg9cdJKPmy//TGWjbYMN7MJUWlwmILDInaYvQuMWc+f/AqaRXMAMZde2aniRnMjMzWd2upoyegEfzoJgXcYzd5s+kIf84vB4oPS+oSyk/ybpycxHofZk36AFSR2kSgo5Juw7qiSd4g77Y1zEAhA850Sv/Gf/DftcG80myMGAhzpdIU/8BJvxTYfI5UmBgwe3pcWaqONY6rcS9t9lY5OXvKuHo6PMSgWNvFOzpmzZzHmCanlrhCl1it2ir+lRIYo9U49x7mKM92wLaRLF1G1t5K8Xj7pJ6feOOI9MMnhZPUVlaEfsvetgpjFTN4+L7tPNhqvlaEsf/FIANATbmVarPCi4TSzMNfqInLNXtWaE0qkWuWKAoZQ/RKNchMDnBiS9GLh6EE29JZzWrvb/+LtSfnklhSzpNdJ9aCWhrQuK+H16UG+o/mXfJNHPSmKxzm78ncGEk/ar4c7kSZZxmgU71BMAd+lWDbTqQa8Fi49HzeLhVT60DeM8hYcb/iwU6OJBrr9tfoftyS7gOS+Y5cdRuTrRXOTCzp6wkKE4o+fIQcthNSlzegV/TEgrBWNHt6D88Ob0aNZyG0doeCyurLyeMHqlFhIZgo5MUqQ1Lxxmbx8TwculXt4UQCN+g72SThHHdr1qRv6ZUCkvUHGDomuTxzmxmiDo4qpDwGC8cAzTnxQRb7DOytjr6lqaeeZtOlq2hQkDAgUF32Is1gEUG3QMICAk5Xg0Q/lv7hyCngmrhJPoCmZFln779ahEnuEebioUqxmjJn7dTuTdcqHR+sSaDF7R98q8T27Xv45ra0aBaGf6LLHbw+nOKGAibtlI5PrbT8dUIdGevgy9A1HgYW
 w7TQNVVA
 GUDIc0tkPOsR7YKxsHaIHgp98Nlpm9a2eHANS1yK09ZTBo6WSee/fivoPaFpXOqQDNDlp0gd52KaghGmJ9SqN8V8cU/1oi3QIOn29TtjxfeqGqpXXYPimM5yJCEXc+ykOd7acw1cdmKTeospq4UVMY9RNu91ADNugrPtz5MSF0CotJr/MmKP/kP4xGrqIt94ZELKHX5QyxDSjbQh40/wCGnZgq997hXRMudvgJuRjDQNhvzU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update DAMON design document for the newly added damos quota goal metric
value complement flag.

Signed-off-by: SJ Park <sj@kernel.org>
---
 Documentation/mm/damon/design.rst | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/Documentation/mm/damon/design.rst b/Documentation/mm/damon/design.rst
index e82390e77a70..5cd651b1b7aa 100644
--- a/Documentation/mm/damon/design.rst
+++ b/Documentation/mm/damon/design.rst
@@ -702,10 +702,10 @@ There are two such tuning algorithms that users can select as they need.
   that the zero quota is a valid quota, and therefore ``qt_exceeds`` :ref:`stat
   <damon_design_damos_stat>` will keep increasing in this case.
 
-The goal can be specified with five parameters, namely ``target_metric``,
-``target_value``, ``current_value``, ``nid`` and ``path``.  The auto-tuning
-mechanism tries to make ``current_value`` of ``target_metric`` be same to
-``target_value``.
+The goal can be specified with six parameters, namely ``target_metric``,
+``complement``, ``target_value``, ``current_value``, ``nid`` and ``path``.  The
+auto-tuning mechanism tries to make ``current_value`` of ``complement``-ed
+``target_metric`` be same to ``target_value``.
 
 - ``user_input``: User-provided value.  Users could use any metric that they
   has interest in for the value.  Use space main workload's latency or
@@ -733,6 +733,13 @@ mechanism tries to make ``current_value`` of ``target_metric`` be same to
 - ``hugepage_mem_bp``: Total huge page to total used memory ratio in bp
   (1/10,000).
 
+``complement`` is a boolean parameter that determines whether to use
+complemented value of the target metric.  For example, if ``complement`` is set
+and target metric is ``active_mem_bp``, it is effectively same to
+``inactive_mem_bp``.  ``complement`` is no-op when the target metric type is
+``user_input``.  For the metric type, the user should be able to emit
+complemented metric values on their own.
+
 ``nid`` is optionally required for ``node_mem_used_bp``, ``node_mem_free_bp``,
 ``node_memcg_used_bp``, ``node_memcg_free_bp`` and ``node_eligible_mem_bp`` to
 point the specific NUMA node.
-- 
2.47.3

