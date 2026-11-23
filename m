Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DC146606A31A
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 15:13:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=P5dj3Mb9
Received: by kanga.kvack.org (Postfix)
	id 57E626B05BC; Mon, 23 Nov 2026 10:13:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4B9B06B05BF; Mon, 23 Nov 2026 10:13:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3A7BE6B05C6; Mon, 23 Nov 2026 10:13:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0CE1D6B05BF
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 10:13:25 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id EF9E740942
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 15:13:23 +0000 (UTC)
X-FDA: 85466727486.22.00E2D13
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 53CFE80008
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 15:13:22 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=P5dj3Mb9;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795446802;
	b=4QqF4TTADrX91WaEzJM9lvJ0ZBvFdFJeTCeyPbVNIOrBhs5nG4H7qO22vtLSnaXs6W0bmn
	zdH1oaw//vBQU+Rb7zch6ElGQmkM5d8nAKB99VWyFLi73TbgAraoh5g69E0owoTPwFleR3
	UJAhAhWEbwv1QLEz0tzcj+e4TDLv8B0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795446802;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1mpej1tSUVKVbZbXvgjSwlFMXCUxn0nEZS2E76PYIAw=;
	b=mOIBbTK/eY88Xyq6RpByAwpnR1z43TmLx6tyDMHNpXr0gNgHqF8gdAbi9gPVREyLJ8MAtE
	EqqKCiTluAhs5YIGUyIiTjYeuF2mpJZTijfcvxkeZDIXpagtmAa4hOYLl0fSTpPPnST9js
	Svkf0M6XuDgDhu9GGc7RKY5pa9f5+qE=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=P5dj3Mb9;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A3C2243D2F;
	Mon, 23 Nov 2026 15:13:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1F811F000D8;
	Mon, 23 Nov 2026 15:13:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795446801;
	bh=1mpej1tSUVKVbZbXvgjSwlFMXCUxn0nEZS2E76PYIAw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=P5dj3Mb9YWClwC82+rDqHgCQ33jNWa7Vvlfns1t1x+yApnSZEe8Cn+sbz9CcuPPEL
	 dog5VHj2S7+aI/2KdHDBLpIjfCF75PK/pW++N9nAEFePFQiVtZbN6ZuDJ+rtMb11XA
	 WtvkcRp2Hk6Nq4xceQbrlwpqgvVo+I5VYoV7Nj9rqgkGEArzxYcyn9KlBEeLiqpaGC
	 Q9A1KJ2D5YupU3sr+pr5iEnxGdkLIkI+tYkxKOjk+7/SYVSJ8wx/Zg6fSp6doT2jC4
	 sNe9jeulUe6KvHjsq3nBDjyTFHRQk9qTC95drVPZWV400b8OXqNNfGbyeoYLEn5Eyt
	 oj0kz4TyjjXrA==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mattathias Pinchover <mattathias.pinchover@uber.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Randy Dunlap <rdunlap@infradead.org>,
	SJ Park <sj@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v3 5/6] Docs/admin-guide/mm/damon/usage: update for sz_ops_filter_passed_last
Date: Mon, 23 Nov 2026 07:13:06 -0800
Message-ID: <20261123151309.82675-6-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261123151309.82675-1-sj@kernel.org>
References: <20261123151309.82675-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: f9cquzsxr14ax7u6mzh3j3nhuk9x5ks1
X-Rspam-User:
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 53CFE80008
X-HE-Tag: 1795446802-928710
X-HE-Meta: U2FsdGVkX19g2Kvre4cQiW7IAOHFZFPFJULjqGh3UVeBl3z67YMDjbnCi8z2Le1bp+GbAh4/at3w+PmjjNRF/hGjmFS/meivGY/MFyild2fulE0PBF9mr5dKDdiJqWAgDWjRdeu3PhYyGcnGvYJ97UBfSm/Hyji/eTXF2n5WLHCyOomqiw9AYe0sV40aJVLpGYpwyw8vVZazkkeZJiU/TCumVyT3pCzyYRlX3CGJeKBZOq+tE+u0Zzm2GOu9jWmOXdxLAdjoK7/4wReW43gcwlNEMDjfl5MBBkUdpTgACAg0Jlwlq/wTNBj+iFiCajkTgo1IklDzNO9+GuqJZUHx89/TM+JONZOOK8wmmY4KhSmdTIXZzQkAi4zDR01dNlRCUlnLN/dxKg6aONo45KgjCHIdM+566JRt01MbW1+A03pOE7GMCJXXrskWglPGY+IlIYqqoO9BIAk+9F+qdV6NlBt+am0Ydx8mmm/wAq0pmvNlZg0UBKEZG6Jebx/qoCziZF7gxBZ3fbgqi5nhWA52z2gXYHRPKZ5GZB1nsFj2AbHovnfyyJiTwoI+KpqAv7ThL5mO7FlzqGlQAdd8/nSzow88INKXzH5XivGP8hApO6pQ+eF+M6p4tReev10xckLWlushjiTySLyrLTgwRT/Vcch9K4vOmXHQ5+Ud1VTFbKlWZhV1JckGz1XwAyyDBcUQqa/FgQed3vx5WAQWp7KNL+lxdYglRGCPt3aY6vxsqtjZ6Cngv2DfoJcQNXt3zPuXVJ8DZnzKcP+YHrtncRisNBNnc5ARO1cna20RJwiHOVdBFpER2Tf7booH1cXqaSobc0vvI1SAwIL7JVah/qs7YDyyuZ9uVPRnEelrzpSUbRUKUF5xKyjiUK5uUiYxRMDrNu6Ogq8BurnM+y0NdF9Y/3/QK//3291xZEbEavaZWphzJkagOgNLHHfOO2i3HbIjXUiKGjKrcSBPJ67zMru
 cgOlnUSy
 jNiXu5mHhhGBgLc5aTbfgO79u9YYNX8uBrAY2Tt2GuZNuK9aCLXOHrkJgtyyb1ta+sojzX0XJffCLJiOiIzeAEroBB+di8fAPXSGDivijKgeTqxb6nitovrElZlQxWTTTOz9IWdZuSGQS699c5pt3G45YFC+5JGlCAWLo7D9ASnvcemUEQSHpyQ2Y1IZjoD2EMWVy2YeGvK3smFSL/s2Ogh1j3Gg4icsNcZOvSqcllbmkAhvrerasweuptio0eCzS6ArI+XYqBebJrlldonHquuhFZ0PYJoNMMWpJMQMOMvXnfga3CVdaJDdCTztScjfxWsx9cae+AiJTJcaWTGwYEVHFC244FoCN9IVDiwNYRyaKExacU2KsdwTNtG+QnVmh/cxBU6h7MmYY9Pgat6yjeXMZ8nBb7Hztz+spO5tXOB2THeNwPUvq2F+6ujhQ2irC+S4EL1/OD0PJJ08zP3KpRBIMhVTIVEs9YuoR5nHGNqmA104TPalhRLwaNMTaZc2npdvmTzCDnouWmeB+9l9nB/YQTLc8xZb7Z3eg4Dy4rzkF0WE1qGJmxdx5MaLUnAnOoww9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Mattathias Pinchover <mattathias.pinchover@uber.com>

Update DAMON usage document for the newly added DAMOS stat file,
sz_ops_filter_passed_last.

Assisted-by: Claude:claude-opus-5-5
Signed-off-by: Mattathias Pinchover <mattathias.pinchover@uber.com>
Reviewed-by: SJ Park <sj@kernel.org>
Signed-off-by: SJ Park <sj@kernel.org>
---
 Documentation/admin-guide/mm/damon/usage.rst | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/Documentation/admin-guide/mm/damon/usage.rst b/Documentation/admin-guide/mm/damon/usage.rst
index 6093b1c8fbfd9..51c4909f1a8b2 100644
--- a/Documentation/admin-guide/mm/damon/usage.rst
+++ b/Documentation/admin-guide/mm/damon/usage.rst
@@ -105,7 +105,10 @@ comma (",").
     │ │ │ │ │ │ │ │ 0/type,matching,allow,memcg_path,addr_start,addr_end,damon_target_idx,min,max
     │ │ │ │ │ │ │ :ref:`dests <damon_sysfs_dests>`/nr_dests
     │ │ │ │ │ │ │ │ 0/id,weight
-    │ │ │ │ │ │ │ :ref:`stats <sysfs_schemes_stats>`/nr_tried,sz_tried,nr_applied,sz_applied,sz_ops_filter_passed,qt_exceeds,nr_snapshots,max_nr_snapshots
+    │ │ │ │ │ │ │ :ref:`stats <sysfs_schemes_stats>`/nr_tried,sz_tried,
+    │ │ │ │ │ │ │     nr_applied,sz_applied,sz_ops_filter_passed,
+    │ │ │ │ │ │ │     sz_ops_filter_passed_last,qt_exceeds,nr_snapshots,
+    │ │ │ │ │ │ │     max_nr_snapshots
     │ │ │ │ │ │ │ :ref:`tried_regions <sysfs_schemes_tried_regions>`/total_bytes
     │ │ │ │ │ │ │ │ 0/start,end,nr_accesses,age,sz_filter_passed
     │ │ │ │ │ │ │ │ │ probes
@@ -631,8 +634,8 @@ online analysis or tuning of the schemes.  Refer to :ref:`design doc
 
 The statistics can be retrieved by reading the files under ``stats`` directory
 (``nr_tried``, ``sz_tried``, ``nr_applied``, ``sz_applied``,
-``sz_ops_filter_passed``, ``qt_exceeds``, ``nr_snapshots`` and
-``max_nr_snapshots``), respectively.
+``sz_ops_filter_passed``, ``sz_ops_filter_passed_last``,
+``qt_exceeds``, ``nr_snapshots`` and ``max_nr_snapshots``), respectively.
 
 The files are not updated in real time by default.  Users should ask DAMON
 sysfs interface to periodically update those using ``refresh_ms``, or do a one
-- 
2.47.3

