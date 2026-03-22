Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 28998FC72C4
	for <linux-mm@archiver.kernel.org>; Sun, 22 Mar 2026 15:57:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 33B916B0099; Sun, 22 Mar 2026 11:57:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 29DAC6B008C; Sun, 22 Mar 2026 11:57:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E37756B008C; Sun, 22 Mar 2026 11:57:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C107C6B0098
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 11:57:41 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8B6CBC2B53
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 15:57:41 +0000 (UTC)
X-FDA: 84574154322.27.EB6514B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 06F701A0007
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 15:57:39 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="eZa9dF/P";
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774195060;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CtSrqktECVSRTbIOnfAhYjfcjrVe2WKXIwFaQDv8qqc=;
	b=n6qZJ+AVBHdLwYH1cBBgscuVkjVIG9B3Oh4GOSufT0Ugl7qGVr+85yOtD255OvhKO5tRJZ
	m42HiQIjknMbDlWjpUVXnlRfKhvp6d6fTY4e02RLw4dsUnYsjl+70Sgs79yrd9/8l3Zlrn
	ccJyWCF+9nNuokRbqwDLkzFuWkDFwR0=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="eZa9dF/P";
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774195060; a=rsa-sha256;
	cv=none;
	b=zST3pLhA+mui6PAntSl7pUXSCyjr78GZ9AXwxSQVBu+Y2NTy0dpPD2Ujk2+ufDiKx7YkoO
	llPdaMJ9G+XblyPzxHUtfu5sozvuqFxi0eyxCp+4w0/L5PbBK/ZoO4b4kMTYnyWsmuUJI+
	s2wgiXqdRatDpTHB7lbkRWm60bgx4zA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 8899B6014B;
	Sun, 22 Mar 2026 15:57:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE4D9C2BCC4;
	Sun, 22 Mar 2026 15:57:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774195059;
	bh=O8n0uNGYuU+EcM7S/clzxsj2TzvWbNFjQtjX/Z2/CrA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eZa9dF/PTZqfcuuwERyLMtEKke04eXBoVy+mBACmc3MJoLG6xi34p5YRBfgvLS9Xf
	 rRmsN8yIbrBa69OTzlIZ4dTkX2Qszv+c3jagCu0H12ZBNz1u0wP9ggSbbziCFbSxR+
	 hv+RY5dRr9Wmld1wzLZ7XHbP+9EDkeDY9CoWPa9pH/w11DBTn8GIFWVEDJexZODQ24
	 bp5cY7V8LRby7fvQMh4Ac736jUYBF64WwU7SsrRNkS4Kxv0neyc5Ge602Oqtcyt+Y7
	 7Gs8xUpFo6x0HBqzkCu2fLAs4HwPaLakXbuF9QZhcEXQRtVA/+igIHpZu0EgHfvhOl
	 reWQzxtS+yrhw==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v4 04/10] Docs/admin-guide/mm/damon/usage: update for pause file
Date: Sun, 22 Mar 2026 08:57:18 -0700
Message-ID: <20260322155728.81434-5-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260322155728.81434-1-sj@kernel.org>
References: <20260322155728.81434-1-sj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 06F701A0007
X-Stat-Signature: x48igc7acio77ba8i81mm9qpc6ewud75
X-Rspam-User: 
X-HE-Tag: 1774195059-423781
X-HE-Meta: U2FsdGVkX19Q6NqtAp3FtmVAG1ifiQgIOtq8UQEi6x3mc0j3LVq8zvghUyuReH6esJ4E4h5GjqjaHWuukdBK9S+j0uT3p6Kc9AY4ddnSvpKlM3h+NaQRvAxTSc8ueCPmegF4jAeVrcc/q81aKRuhjCVXLzLmtwcrDHOV+RqnDe167BvQKoM5buZhQVMEXhd9RxtpGofhyn1VNyw7NzJwQ954r/Qi+jp2jxSlCCk7qXtyFH83Oqmh4HtMIjg2Z87ShUPqqFt1PVTkCE9oChgOrW789kyROeRuv3bK2zUDGaSRYo89J+De2fW0WGSO0l3SogpIP8cdY8/f5XdXDBqAV5uhi4YFurrYqw/e1cLnZYUzOUeJiAVqc4RQJxaljtED/6rFFDMoxLeHbVb46qnmG0QbNhnjdMMer1MMvKkI0TY1rq8XfWEFO99Lr7a4+1DBDJiuceftnTa7z4NO7WRw5Abant7HNQYlwMlz2RduVtxBYsDezrh+jO6fizyufDjMvuNsDhcw0dlefYBsat+LVIcElktOwSJiRiWFqQvvN7GUm3IVdBS1MueCeentriQum76sjEpHcr45xw0zcrTUDUERe9MHVVJxfVMzjFI6LuwJ5oKbhX+/HtZhVStB0pufhEnwrQYt3kyZ1nO57AkuPNUjsh+SILwC5u3fyLNDm0lRm1NbOT3vSEgJmZJ2jjsQkOJDRVi5FmDJEGRmumNTDLe5fR/krb9FpLHehD4ffKPR4E60zCPMaUQCMfl6406/bXPE8hZW63DgdGQ4y4Fh+bhJyunjHlHp5kHfeHGbjuvOPGe3jKMPUq/3lQV2UyAKOBxHtCKpxoGWU53u7dBaABIgcdKe6BX+8Rj8TTyN9vvfcBEWQo/+d5bWaZNG0Z+st4NckhY5qfYy+IVUu0C8qTSAB0wRDT2HEaJDbGUQHd/22SRYRchQqco5NjLpFMVzel18f+ERVKRVi3pu7Z3
 1fLsJZ4K
 LwQfzMT//fGpKqUVB5h2q+hLScCx9MWshx7Wj0GeHI7Gu6dxxJ/vIGoZY22gsP/rK/VlLh5vrfTFbatp6rlkozMbAit+Z0ydYXIx0lorP5O8VvnshXunKczNEYXMe1xwhmDYmaf0j+isp2PMQi0kNQ5Pt5xLu+1nNLajE4X8ucFsYZF/Y5OZa9UtGu7QNE1dq0cR8FK+bbG+SqQ6vrlVLxESPaIU/3bhUFFoZ0GqnYYaURcaIQgMdgIkb5JYgsGgopacc//qlMrnAfgU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update DAMON usage document for the DAMON context execution pause/resume
feature.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 Documentation/admin-guide/mm/damon/usage.rst | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/Documentation/admin-guide/mm/damon/usage.rst b/Documentation/admin-guide/mm/damon/usage.rst
index 534e1199cf091..bfdb717441f05 100644
--- a/Documentation/admin-guide/mm/damon/usage.rst
+++ b/Documentation/admin-guide/mm/damon/usage.rst
@@ -66,7 +66,8 @@ comma (",").
     │ :ref:`kdamonds <sysfs_kdamonds>`/nr_kdamonds
     │ │ :ref:`0 <sysfs_kdamond>`/state,pid,refresh_ms
     │ │ │ :ref:`contexts <sysfs_contexts>`/nr_contexts
-    │ │ │ │ :ref:`0 <sysfs_context>`/avail_operations,operations,addr_unit
+    │ │ │ │ :ref:`0 <sysfs_context>`/avail_operations,operations,addr_unit,
+    │ │ │ │   pause
     │ │ │ │ │ :ref:`monitoring_attrs <sysfs_monitoring_attrs>`/
     │ │ │ │ │ │ intervals/sample_us,aggr_us,update_us
     │ │ │ │ │ │ │ intervals_goal/access_bp,aggrs,min_sample_us,max_sample_us
@@ -194,9 +195,9 @@ details).  At the moment, only one context per kdamond is supported, so only
 contexts/<N>/
 -------------
 
-In each context directory, three files (``avail_operations``, ``operations``
-and ``addr_unit``) and three directories (``monitoring_attrs``, ``targets``,
-and ``schemes``) exist.
+In each context directory, four files (``avail_operations``, ``operations``,
+``addr_unit`` and ``pause``) and three directories (``monitoring_attrs``,
+``targets``, and ``schemes``) exist.
 
 DAMON supports multiple types of :ref:`monitoring operations
 <damon_design_configurable_operations_set>`, including those for virtual address
@@ -214,6 +215,9 @@ reading from the ``operations`` file.
 ``addr_unit`` file is for setting and getting the :ref:`address unit
 <damon_design_addr_unit>` parameter of the operations set.
 
+``pause`` file is for setting and getting the :ref:`pause request
+<damon_design_execution_model_and_data_structures>` parameter of the context.
+
 .. _sysfs_monitoring_attrs:
 
 contexts/<N>/monitoring_attrs/
-- 
2.47.3

