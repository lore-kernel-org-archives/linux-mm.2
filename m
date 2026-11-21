Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C4A14606A335
	for <linux-mm@archiver.kernel.org>; Sat, 21 Nov 2026 21:01:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RgqfAVce
Received: by kanga.kvack.org (Postfix)
	id CAA706B05BA; Sat, 21 Nov 2026 16:00:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C5A1C6B05BE; Sat, 21 Nov 2026 16:00:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A10646B05BA; Sat, 21 Nov 2026 16:00:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6A65F6B05BB
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 16:00:27 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C4F6C160589
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 21:00:26 +0000 (UTC)
X-FDA: 85460344452.26.C44D125
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 3854AC0008
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 21:00:25 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RgqfAVce;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795294825;
	b=wH0aEQiKUOSO6rEyfEvJ62STbdrIvnOZG5LXjP+Hj0vNr9BroP+fJmAEwE3xtS3dCf0K+7
	nvQNZLeeMTcYcTicUGlIphkQa8HBIMxMQ5rgOP3pao+xb3JiM7PGJ+rlXXT1L36aLuD1MT
	aUj+f/mot3WGWw6EyrvSearxS1V7Oug=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795294825;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+3VuRAkKYe8EHkp2JgLASOtjfe+EnSMbvCKOCwj6jzs=;
	b=E9Hk2B0EvPhRk2nbseRjrhQYy32tEg9NsDF4G+bLSnqRyQL1LcPQJHDYEMVEJKl1iywOY8
	Qusxo++JLaUBObqjcjcVAH7ISN7cUcH/ZAb/r8KOSQetXvfTQ+tVPjsjwmLQHw1eb74Pak
	D55aQ+xsHD72SSCCWaB+woTz6Oyelwo=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RgqfAVce;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id CE20361B73;
	Sat, 21 Nov 2026 21:00:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6085B1F000C4;
	Sat, 21 Nov 2026 21:00:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795294824;
	bh=+3VuRAkKYe8EHkp2JgLASOtjfe+EnSMbvCKOCwj6jzs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RgqfAVcef9VHKtexYMM4diHOxHUexB986bI5j8yqJk83roysvg7ymlzOefZUI77Jy
	 3PGMcM4V+MQLlUgI0Kt/jqn+8MCnv/Jn3D4ozAEZ55ICdTCEdKxTY3y5b6KexGN+J0
	 2TvYAzHOW7twWhbOCv/dK+zXmX3gFo3h/aeTsj64jinAsK2RL1ByiJzdW8cNP830Rw
	 6kGFY8BAa+WEkbKDbsYa5+zvwYxRjPllcIxYpTkomUKXdjRBWOG5VY0qzjbH8m0dBx
	 RO+BHvL5m/IqfMeE9TXrsT/pUG4k9ugZHLyzZa0W6AoGY2zC3JXIRz09+37uARKA13
	 BQ83nhnuvLTAg==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Randy Dunlap <rdunlap@infradead.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 10/27] Docs/admin-guide/mm/damon/usage: update for report producer sysfs
Date: Sat, 21 Nov 2026 12:59:54 -0800
Message-ID: <20261121210013.130397-11-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261121210013.130397-1-sj@kernel.org>
References: <20261121210013.130397-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 3854AC0008
X-Spam-Status: No, score=-23.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User:
X-Stat-Signature: x9z338swgyob1r5gb49kp78xzwybuot8
X-HE-Tag: 1795294825-291952
X-HE-Meta: U2FsdGVkX18Q9oguD7Wmw3NJRw1uAS8gLoE420UaXDNifnzZsSzoAtSXuEQe8hQeA8feOvC7yzWu6zX1+t2fnFGK4BMrSVSkz4d/dNZooGFro3EraTsXRTwRT7TjKg+Dnby1uGphcFIvQZSmhv6s0rgf6mpuAboxD4eoOwH+/uCSVuDBrvFNf5oDj4nwWjf3d5iWVHrgsqxHSlvb9FDUL0SUuRK0x+zlGl1srEwdD4Xq2f00KZt2AWx7Igd9ikuqz9yoj1oj38zrujHNDKwHKKY29/cGqb+QHX0bKNTEJWbw09P8CQkaeV+AvXNQPdh9fVvKl9FksaNEYiBw0wz2Xp0N/u42R3iqxuM0WW03Teds3qwEjPR+2tXljdKVrxMoD7C6XMgrWXZtruKsZJfTR45l0DhpJY7Yv0O0M7yhvvRDWbE0hBGYYH5/o42ICYcZ4Vn9GDveAEH+++psdvVZ3otAtFY21+PIVUI/w5GvsoDLSgkz4fX8Gn8ByY+YadjcvjTa9A81shFLN4UDlgo5CKx5H7N0y/o1bId34gToyYesCcH+UfqSlWXBDujed+wMIyoCJxzkyitXx5ZVxGgz17CFALL5g1wU7nTz6TvHjRHCXP59LfzNcqIOwoZ+++8bByHKx4noKTJYVkUZuNZmD7DV62TRPz3WxdqLImvSxXlSvDTgsdb456UwPzDjc/FlocTwTgJzXDP/mor8plb2BTfaP2/bGaLvFmivqVQd4gTX+KzEZwZwSPC3AYKyCYfsebT2Wr8pZC7mpBpiQ+evSkeA0QGubioRIv1cfVZsDvUTkJQQHKSt4I7kWUd4RV/BYI2LIJCM2QIt3LYAvBTMX+Q1hpH5Hs720f2QcMT89ZehCOib5LahN2c0UnVtwe1vPRW/AY8oJSGfUlh+3L73y44E3b+9IgnjNVAp/qubC/R0toFRSovhn7X4Re+22PgZJHujyb0F9xD9wrnRum/
 /pruj1+V
 j9DFhsJXkjv46wty/6t/pUDLl/CHt47z7CHvyWsKnG+799j235rizhY3E9vaGf9sJHUsh4fDrej7dXwqUYFy3AYWeTsxmYoJlk3PeZzj0hy7ExtcQzP4sHgaZZPqSSDrAheuT/BFi3A+OoMLEo2sN3EkD9YuWOEYGHFSczLjV62iozhBT3hjkUhuzpwz/Z/bOB+QNNEJrbGLN8QN8MsYwG/aZsHvw2wVUZHsXZd5gT0Xv0FSt56Usqsijkhk/wNMDxHwWM4C6oS0BKzQQBJS0DuU2Aq9cwkEi/Hsiue1sZEgulmyhCfx/GfWlcmJUsDIxYTPYzxQ5bIJDn5yTYex6NQhzwBbZh7OYCNrKzyh2HZ4+FxXGVmZYfOm+8HlYnhrPy+drMc9G8L/OZMNFzOpq8FNHEpG/gYGTbYGhfGe5lGa881UDN7+HcN91FmjvlMmsz3LBlns2sc+lIu+csQkx2mjS5ZQhQdiAHlNJ/WX6ivRPNJmESu3LSLaq43KUIb6MKgGabIx9VmvReAA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Update DAMON usage document for the newly added report producer control
sysfs files.

Signed-off-by: SJ Park <sj@kernel.org>
---
 Documentation/admin-guide/mm/damon/usage.rst | 35 ++++++++++++++++++++
 1 file changed, 35 insertions(+)

diff --git a/Documentation/admin-guide/mm/damon/usage.rst b/Documentation/admin-guide/mm/damon/usage.rst
index 6093b1c8fbfd9..644250c7bd681 100644
--- a/Documentation/admin-guide/mm/damon/usage.rst
+++ b/Documentation/admin-guide/mm/damon/usage.rst
@@ -115,6 +115,10 @@ comma (",").
     │ │ │ │ │ │ ...
     │ │ │ │ ...
     │ │ ...
+    │ reports/
+    │ │ producers/nr_producers
+    │ │ │ 0/report_type,producer_state
+    │ │ │ ...
 
 .. _sysfs_root:
 
@@ -729,6 +733,37 @@ Please note that it's highly recommended to use user space tools like `damo
 <https://github.com/damonitor/damo>`_ rather than manually reading and writing
 the files as above.  Above is only for an example.
 
+.. _damon_usage_sysfs_reports_producers:
+
+reports/producers/
+------------------
+
+Under the `admin/` directory, ``reports/producers/`` directory exists.  This
+directory is for configuring :ref:`DAMON report producers
+<damon_design_attr_reporting>`.  The file below exists in the directory.
+
+``nr_producers`` file is for generating report producers setup files.  Writing
+an integer ``N`` to the file creates the number of directories named ``0`` to
+``N-1``.  Each number-named directory is for configuring each report producer
+and called "producer directory".
+
+reports/producers/<N>/
+----------------------
+
+Files below exist in each producer directory.
+
+``report_type`` file is for setting the type of the report to produce.  Users
+can set the type by writing the type name to the file.  Reading the file shows
+the last successfully written input.  Refer to the :ref:`design document
+<damon_design_attr_reporting>` for the list of supported report types.
+
+``producer_state`` file is for reading and updating the state.  Reading it
+shows ``on`` or ``off`` if the producer is enabled or disabled, respectively.
+Users can write below keywords for the producer to the file.
+
+- ``on``: Enable the producer.
+- ``off``: Disable the producer.
+
 .. _tracepoint:
 
 Tracepoints for Monitoring Results
-- 
2.47.3

