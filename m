Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AF9E1CCD184
	for <linux-mm@archiver.kernel.org>; Thu,  9 Oct 2025 21:21:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 49AAA8E00B6; Thu,  9 Oct 2025 17:21:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 35E918E0002; Thu,  9 Oct 2025 17:21:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 226FA8E00B6; Thu,  9 Oct 2025 17:21:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 05EFA8E0002
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 17:21:02 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B68C188350
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 21:21:01 +0000 (UTC)
X-FDA: 83979845922.14.1CE6E37
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id F118B20002
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 21:20:59 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=iwiq+z9N;
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760044860;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s7+EnUTWWgfJ/pmzIo0T9gVX4Hx7dnr79VbcE0j4jfo=;
	b=dyDackMEVg5ThT/qmycP0wDV7hf73O87kr8gHqSlRf/Ec9b4ND8W+EHWv/Jzb7Qjo5rE67
	KjhsuCWFEoCzupbRsP99X/FqzZeIPbkri5eYcLS19cXMZwvHG0lar/eb2gIu3KUi61S5Jd
	D1zhtTXkgGma/wD+h/i813TVpSSRAH4=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=iwiq+z9N;
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760044860; a=rsa-sha256;
	cv=none;
	b=K3uO5zoQyXIMQFRa5BxzPdDlim9Km2rlQ4fdVsld8KiVMJHZ5+TjhmCyP324oHAHRpYG9E
	5mGd+B8lEKwHN1fWombBTf90HcbNDjpmwCuCsvFHHMYphZJDgv+1tBj7xHBPb5w0sZP8QJ
	O9UsvEnCpOYL3pwEGwdN4p0K/4ByjII=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 184FF402F2;
	Thu,  9 Oct 2025 21:20:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C657DC4CEE7;
	Thu,  9 Oct 2025 21:20:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760044859;
	bh=c3w+jGZIkcFz1bj37NYQVYFms2ZoPQQJjnr1dqcqrzk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iwiq+z9N7k5zhBrw09Vtp1n2Tn6BSsrEl88mOt1tkYea/S5Gz33b45jExVLY/CrKj
	 pKuxINooLI4m/Lv8IX31vpMCFI6OjKRvt1RipEAUWpm93fEcMIQBBE/EtMWE0I7bov
	 hWbb8JxfaqLO8xWEJhFkDQz/C2WMrL0vwBHMZ/EEGKOABodFzOhqvN0UVon0AeQhWJ
	 lMxPpTDHRwBUwTBRS0t1DjxHlTGsFWHSA0pvijHwK7i2bUsHTFo7+G8UJanNqTjhNC
	 DAuW/Z7juLiVu5Mx45odTE4zN156Qf1tGcAEl8yylYfE0IN4CEhNeK3G9+nNJOM9ZS
	 2EZkYzxQ3ns7w==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	damon@lists.linux.dev,
	kernel-team@meta.com,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2 09/10] Docs/admin-guide/mm/damon/usage: document DAMOS quota goal path file
Date: Thu,  9 Oct 2025 14:20:41 -0700
Message-Id: <20251009212042.60084-10-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20251009212042.60084-1-sj@kernel.org>
References: <20251009212042.60084-1-sj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: F118B20002
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: 5rkdnjm7gzzuttwtwguaaewe33ftbamo
X-HE-Tag: 1760044859-966064
X-HE-Meta: U2FsdGVkX18bOMXLAwFDU7bbicR8YfPFVUoFbEJlfqZSzdQny+DLSSfcDtETs3OxoSPq1lPymxfyIRrs4zRSv2ehpLWF6MH5bwWElRP3tO+RmAZoqjBfNwvSp5DZ8ZofYwx87DUySCkmV5EZN29irpB9exFHaMWNIsPRUiRR8fYxvs+x1J3K8522OkJBC8LAvw8yvmh1igjP+9AOHAx/2Hrd9AxEGgxsR6vPCTwLvHrbMUWWxgswntB3ZAtGfkdeii77h3uu1OLz16CelWITHngVBDzf5fGN/bt0SiMAamUYf7k2VBAtssutLWD3xoET8MHbYyAw0az2fqSf95E3GPF49ReBJAAHQwKVTPZrc0+ZfulP8TR7kfs07h2t+BOse1+E0GXfowtt+kKtq0e48I2i19r6/OdeJEprpbAVn79NflZGn2rx7RVzB7LqFEGdb1dbj8vC+SwTrBQWtYs6e0eRirTEJ4TRIpRxdQhScHYz7GNXe680kIqg74uxD4RvmichsF+rEtMKHOOxgQCxnJfH2cSCogKJmclcZmTJmpDOjEdN/07g3ldI80gSGegV67T9Q2qL3yP48nu3CWcXg3mp+ll8Xj1NDmcJa0s7TZwHYzgMe1hh816ofBC9jhOOx+v5cM1OZrmlPgC49kX47+o+DhQyngB8sjtc96pN96qi+jbWha4F2Znn9nt9qp5oauXPVkOyaMrof1J4/mRflufdWI4hdikei0q/geeKItscDVGONNsIt1VtqfCshyM6ftrYoqCHrte06CfCFhXv6LGCwbDU1zdUauWdLDrjz8JWSlBKjAXsIu6tX4spyQcNS2nifwqR/31CCySOLAwbOelJx3fOScMPG7wza6/oVxiyto+/roFoQUQUleEi6X17g8jlTT2ahAN3RAQlxAViVHH8fsH742mWzeUo7ntxWPqjZzd5xQka4t+/oNmAHhVcTZqRfTFfXLV9iwaFjBs
 IFRHOcUR
 P0xXTQ9vfA2FnPm+q7meB1imPFGd0PgHqnExUcN58BfnUYEfDRcbKy1it1TDdr6Us7BilQNtCBZqDkFYqVdkDoqnqW/SmJRR0i7OMxUx4YY8BaC9jiFptDUbfKo9y7HHIKQFARNLPlQ8lbHaoKsbevJy4XedA2N8YPt8uZuV1kYQYDV1e7aYDGdM2Ww5fwKGa/dP1dRBKKQ3zusHUa/C+mYXW6F/oAnpzoZXbyZycdrI0YzimdtnJmsNSNFk32NnyXlPvPFQQObrGqDt1BYgx5/D/V2+VxdNqK68jYCUdp+6Fc+XcqzkgEAb+wg==
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
2.39.5

