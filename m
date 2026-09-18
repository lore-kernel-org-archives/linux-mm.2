Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4DF36C982D8
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 14:29:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3C0146B009B; Fri, 18 Sep 2026 10:28:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 370296B009D; Fri, 18 Sep 2026 10:28:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 238606B009E; Fri, 18 Sep 2026 10:28:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E2C246B009B
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 10:28:41 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2AA1EC067F
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 14:28:41 +0000 (UTC)
X-FDA: 85227114042.05.B5C2B50
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 8F2B82000D
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 14:28:39 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Bj3bNF3Y;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789741719;
	b=KiNmzuVzhyGMgJIkdCKbkDIgBbg3Lkus4J0vP9ZF8xVfqKrCCQSplxx+7QtxltbdMnbIwM
	VyQ6i2ksQQ3tWKCNx4a5N8KI1iewWoqG381cM7fAQgM48rexzMq5DnmihleWwbSm7cZGiU
	oA2na7HhwtvMAxM8uiVJ//R3wrI5GUY=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Bj3bNF3Y;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789741719;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=X1sX9mUyRN7/6GImxCu2dritOfCzk+oOrOznq8LURqo=;
	b=xXv13jhcqfa8feJzpBhSrdOsHPnTiUkbh4cxYoxs6IacaQPjC9GwriNEHBC1qjR+o9RDZZ
	jrtmr1aX3OT7vScOK4gwag/IN5hdJYPkMm1tIOjw1+tZaxP49MV85PJb3qWMku4HLhDr0R
	WW6JD2Ld+9SFJ3bljN1tuh7IFPqksnI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 213D460A64;
	Fri, 18 Sep 2026 14:28:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FA861F00899;
	Fri, 18 Sep 2026 14:28:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789741718;
	bh=X1sX9mUyRN7/6GImxCu2dritOfCzk+oOrOznq8LURqo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Bj3bNF3YnTkRyExK4aA81r+y4I01gJoc/vxkdx1RVsUyacvvlrZdyvJfIakTUMpJN
	 J3ox1PGyg+j89n1Yx7wpx6bi1eRAsmVr8GvhfrmcCtzsyu9DiuUy5KBwNg5k14Gg3J
	 N9Z0xEpgg2oQA+rjor9/eJ1diN2Ts7vLOjoOw4bYbxeuBIsEnuGcsXIRFrAbLJ671i
	 PpTyuwEyehc23uPdwc1OKBgr7Dvr5vu3583rZLiPTl/qTzta0e1QOm631IxhbPWLE9
	 aHW3zqDiahqQ8IE8yBsKAC3mrWwPFKVJi5GKmQKoH+RheG/AbGx5jXChAB0g80sb5f
	 wwE5m3Mqsfxvw==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 7/7] Docs/ABI/damon: update for quota goal metric complement sysfs file
Date: Fri, 18 Sep 2026 07:28:26 -0700
Message-ID: <20260918142827.85303-8-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260918142827.85303-1-sj@kernel.org>
References: <20260918142827.85303-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 8F2B82000D
X-Stat-Signature: egkxeo8g67r93hd4bufzfqa51dxfng5i
X-Rspam-User: 
X-HE-Tag: 1789741719-551282
X-HE-Meta: U2FsdGVkX199THVNniC/IChZCfL+Z6Wkvanx8j8hht4bGa3t6Vcswm4wOPFlwcF7MtDxlNCSW2b52Q+j/vq8EMhvWkXkQjj6QpoS8czFbRPwdW2eLmPmU59L+WWMyJxenVB7bHOT3SeYNhbFrPB9edWMbq9rUZRzUa5ME8Un/4queXoYr1q6+b92YspLtf3VOnT105POs3LbW0hM+3AYWkEo6Yiea9B33LVPdsI5Qoow4xpQ89I6ZPPwgksqvLfVuWAL3zSfgXZlNdqm+njiBfonXIREvVux1Kp64w4VENwH8lay5tzwPm0/QTyTx1VSgyjGKTBk4+PBlOK/ElHdu94ZSZHQtXdi/0z/sw/tXzp7Q1uCUl6T2QFx8gs9PNLbdmvJAuOBmSpXwMCQUTYroU64DUOzDiP+rN4XEHPoqo763fAiQ8wYuiVuOjMgwA8V9h/C00Vgluig/8EQ0Kan8k7EY55A0uCDKRm5ivGjcCIXjscp1kOTkWnvvFwfiYUo4gXqaF+ZYAO/QCictJwN9Ci8CY9E9cBuJkhilAcrXX2+f3DJBP9TRFak3jWRLRIe7GgnUlQkLWKL82pa400FLKd5BySxN+nPpr7vww51uy/7+BPl95XMgGBBGzTAASI1yjix5ODulShRPfOA37Q1hOpS0e8EmQiqbAbmuPW5n3NZQSH02v+q1nauFWZBIMbgIYkeq0TgYPcjhDmGO9cUqolSc58nYtHp6sjUguCk8zv52XcUsDWU3Hc9/KCBthgbDRP01xnrTUeeRjXsHukedzxyAu766GldLPmcgjvc8OvXLM8DJUdgqWxpeWNNfSyb3iH2Q5mfsX868TBQoYSxETeZvCDtWbH2N64B8jzZ1KSU9jRd7/0V1oNwDoJjPKhn4I/hcAzXX7bli1RrbOoggRVvtct3tNWL9LMwK+mRkjgHbF01N02lV37FkNEIn6B702Icsqfog1CAs/2xRWh
 dtGz4Ood
 H9Nqvl84JCiBWAVEF2BrpRMOJz6X4Qdl3doywDbbSi4BrPbBqRItgb7mDdDZBIKFPIsyUdJ/8Us39FzBkIEZMzX19YjP+8sSLLdI0Jzy6yF3leD2ohi5nQF2ugPmgacCYnfWB7D5pV+m25uTzvUB53SRAGrg4IexAcoTW+2M8uX94Jq62czHss7BbmgaP7PaXOTfbpScn2GgItE9fomJFGLSDJ7LH0ioklCIPss+Qt0QUTWiggQyP96ssa9tSsQUCFpADJTgGyFJpe80=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update DAMON ABI document for the newly added damos quota goal metric
complement sysfs file.

Signed-off-by: SJ Park <sj@kernel.org>
---
 Documentation/ABI/testing/sysfs-kernel-mm-damon | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-kernel-mm-damon b/Documentation/ABI/testing/sysfs-kernel-mm-damon
index 55df688ea596f..4acb2015c2f4f 100644
--- a/Documentation/ABI/testing/sysfs-kernel-mm-damon
+++ b/Documentation/ABI/testing/sysfs-kernel-mm-damon
@@ -375,6 +375,12 @@ Contact:	SJ Park <sj@kernel.org>
 Description:	Writing to and reading from this file sets and gets the quota
 		auto-tuning goal metric.
 
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/quotas/goals/<G>/complement
+Date:		Sep 2026
+Contact:	SJ Park <sj@kernel.org>
+Description:	Writing to and reading from this file sets and gets whether to
+		use the complement value of the quota auto-tuning goal metric.
+
 What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/quotas/goals/<G>/target_value
 Date:		Nov 2023
 Contact:	SJ Park <sj@kernel.org>
-- 
2.47.3

