Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C3468CCD199
	for <linux-mm@archiver.kernel.org>; Fri, 17 Oct 2025 21:27:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7F4CA8E005D; Fri, 17 Oct 2025 17:27:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 702D98E0084; Fri, 17 Oct 2025 17:27:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 30AD68E005E; Fri, 17 Oct 2025 17:27:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C36B98E005A
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 17:27:18 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8072D1602A5
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 21:27:18 +0000 (UTC)
X-FDA: 84008892156.25.E9BDEB2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id DCDA7180013
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 21:27:16 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BmDnI+Zp;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760736436;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DJ7rgVkzeelFFPQjQtdyCdthGWFMzT5Or2X8odlRjdY=;
	b=prymOA7wtqmaY+FIN8lKNW8VyCADrkp+WNHjP1Fzk9+YI/bMNygDies0W3vo7ars4ZPsdc
	fXON8uA9SkQvxyz1vTjRUcncvSr20hpbwSpU+aHPLW6TREFjQ/aDfqFwDLZ02l6r1OCGX9
	xWL5mYWmux+iKD9AJ6HVTI/cSr09hAA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760736436; a=rsa-sha256;
	cv=none;
	b=zl0c6ZiIgVjR9n+A4YQyiTGECWFCuhEbWdfEUzMbX5PqrKXvAi6xIvw/06peyFp3xnfQbg
	E2LNtExrF6x7d+NJRMDJZzs40dlSmhsHhlGFc+5Xd+fnjRczdsg640AWwzLJGzhBhVM1gf
	KsPYpCHZJB+R2/evgD+CKnlG89F5R5U=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BmDnI+Zp;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 66ECC645D2;
	Fri, 17 Oct 2025 21:27:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB1FCC4CEE7;
	Fri, 17 Oct 2025 21:27:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760736436;
	bh=host/mbZFT4OeHnIo2pSXmMweFfCPczlM3sHm3V1brI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BmDnI+ZpiNNPmsjHtEWSkv9ZcnwkWPozf2psauxop1e/pHt9eWGb85ceQ5fkLGlX6
	 LIbfkJ7IHB5rCN4/zZf3L8XpvpH6dGudQ9YXrd04Q5Shsz0yeSckPtbCpw6DLPdSLG
	 H2qgY2WsgsBlxXvsjsfgfLtBt82eEn9Fij+ojuhTkbZRY4ltkmaLB6BZ35rGL7q1WB
	 C77fXR7MQQMUZXq2aQevv7rTEtHZ8s0oxMZ6iQ5Dy2w1AjDYgiKBgAp886W74lLGnc
	 NjXCWCZqBmVSC351gDh7hTNUJhvmXqDbrwHvQnDjAW3vs/+r5lbUMtwyLRpzwMyV7e
	 iKQAsRf2zB57g==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	David Hildenbrand <david@redhat.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 09/10] Docs/admin-guide/mm/damon/usage: document DAMOS quota goal path file
Date: Fri, 17 Oct 2025 14:27:01 -0700
Message-ID: <20251017212706.183502-10-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251017212706.183502-1-sj@kernel.org>
References: <20251017212706.183502-1-sj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Stat-Signature: ractrsg1pzfcynthfm3w4d7dqkf18kz3
X-Rspam-User: 
X-Rspamd-Queue-Id: DCDA7180013
X-HE-Tag: 1760736436-507749
X-HE-Meta: U2FsdGVkX1+aO3Tpol9BhKZZmOA2aSpKD1nvYA8jCKgcfVj4EfpNMCVk8TdC5kQL9N6cbJJeyF3pkYiNukO+LssZPn2T3/OMX/1kcmHG5DHMe7+OT9ApL6ARwckIETyY1oA5cbi69UGrgAmTgiK7phSipHk8v8qMAL3UX3awh+8zk+P24lLGkB/06XqgsGx1eKEm/f2uUrRyjtltB5oucCACBDZcfM4CTAxxDu3cb/2Bo/ZyFHEEMXWjGXYwDjUELfxA6TXDAccyfl6IQBJ/Ee0H/vThbPrM8uPRkyoJ2Y/uPToFY+v3J178XvFGMXA+rcLyZoZabqLRnLS2tjxC3SbeD6eKTzN6aV5QoCeMoNl0EOG0nmCNyYvAuo6Lz9O2LcZTknZB9Nf4TFcLYxzD0A/mg7X/CdF9dZn0zspcRKQy2WJMf7rZpYuz29YAmn0oZDxI8IEElOW3gunLFbdzgjiT6GZKiZm0RuFg0+OKDmVsv9ycnCMeZKSCY3Lw1QmKhLrKHbb5NNhnFvsoKR73722+uWH67CLBmXG9eQgkE5MvhsXzAPIW504hr45f+jGs2YyZFIjNJPoypX+q+6goHnpY/n/Lzne4fPujpIyTgvEnOopmQjhYubTtJBdrZj7XcFlZHBJe8SNu3mZpTwt54OhOnKFuFwwIBZfL+HihkSgtMbzDiwlFHO6ieNDJoXB1sZ58vKtb2g8E6Ns2iIGERLLVykceS0MP3NT4gmytiKG0waxkFyQGScNNOsG0d5BiW7w2PS1ZpxEVTmfredfLwaOq4nbNf2C41LKedzxA0+9DlCabm6QXY9jKlrxEbxZwJ95XTIID4tK2tT7mDSPbbraKJYuGws7AFxuVKUQumpTzXtlQulD3kPcFVsTyXmWu+3Zm89+n9R1X4++QyGdrZdRIxvxSZM2YuIOijlqI165JjZmknZAenRQifMqGNe0G2f0pofnUY1p6bcilM9s
 /V+34gq4
 ePx8EE7e5XTFk0/cIu/YSf4dHzyi/R9C9p9TU2rZT/+5jQZ08uZMSFki15SbJPTQBwRG0mbLq7H4lq4b3gXDLRm+sBItttl0LBvCXGMKumLd3BsE04ZEXSOtryGGBIa4cEfz85lIKH92lXdSDCFkta7yC4M9dbJxnpG5lqkm6ryObs9Odo3DYVTQEqmUAw1dgSdRQQHrBqY6G/yijFqx/Bwg94FK6It9+YImmLwNmprD6XqNRKuQLpC8MQb1Jss6Z2lcyP4ZTfzxVkMgDERV2nDQGZIKomM3tZMm5Rr6RSQRK1Bn+cHVurk+n6Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A new DAMON sysfs interface file, namely 'path' has been added under
DAMOS quota goal directory, for specifying the cgroup for
DAMOS_QUOTA_NODE_MEMCG_{USED,FREE}_BP metrics.  Document it on the usage
document.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 Documentation/admin-guide/mm/damon/usage.rst | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/Documentation/admin-guide/mm/damon/usage.rst b/Documentation/admin-guide/mm/damon/usage.rst
index eae534bc1bee..98958975604d 100644
--- a/Documentation/admin-guide/mm/damon/usage.rst
+++ b/Documentation/admin-guide/mm/damon/usage.rst
@@ -81,7 +81,7 @@ comma (",").
     │ │ │ │ │ │ │ :ref:`quotas <sysfs_quotas>`/ms,bytes,reset_interval_ms,effective_bytes
     │ │ │ │ │ │ │ │ weights/sz_permil,nr_accesses_permil,age_permil
     │ │ │ │ │ │ │ │ :ref:`goals <sysfs_schemes_quota_goals>`/nr_goals
-    │ │ │ │ │ │ │ │ │ 0/target_metric,target_value,current_value,nid
+    │ │ │ │ │ │ │ │ │ 0/target_metric,target_value,current_value,nid,path
     │ │ │ │ │ │ │ :ref:`watermarks <sysfs_watermarks>`/metric,interval_us,high,mid,low
     │ │ │ │ │ │ │ :ref:`{core_,ops_,}filters <sysfs_filters>`/nr_filters
     │ │ │ │ │ │ │ │ 0/type,matching,allow,memcg_path,addr_start,addr_end,target_idx,min,max
@@ -402,9 +402,9 @@ number (``N``) to the file creates the number of child directories named ``0``
 to ``N-1``.  Each directory represents each goal and current achievement.
 Among the multiple feedback, the best one is used.
 
-Each goal directory contains four files, namely ``target_metric``,
-``target_value``, ``current_value`` and ``nid``.  Users can set and get the
-four parameters for the quota auto-tuning goals that specified on the
+Each goal directory contains five files, namely ``target_metric``,
+``target_value``, ``current_value`` ``nid`` and ``path``.  Users can set and
+get the five parameters for the quota auto-tuning goals that specified on the
 :ref:`design doc <damon_design_damos_quotas_auto_tuning>` by writing to and
 reading from each of the files.  Note that users should further write
 ``commit_schemes_quota_goals`` to the ``state`` file of the :ref:`kdamond
-- 
2.47.3

