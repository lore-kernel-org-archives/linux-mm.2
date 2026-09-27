Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7E3BDC9830E
	for <linux-mm@archiver.kernel.org>; Sun, 27 Sep 2026 12:06:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A00DE6B0098; Sun, 27 Sep 2026 08:06:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9B0BD6B0099; Sun, 27 Sep 2026 08:06:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 878E66B009B; Sun, 27 Sep 2026 08:06:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 60D2C6B0098
	for <linux-mm@kvack.org>; Sun, 27 Sep 2026 08:06:00 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 73FFD1A0A0F
	for <linux-mm@kvack.org>; Sun, 27 Sep 2026 12:05:59 +0000 (UTC)
X-FDA: 85259413638.22.50BAD00
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id C55EA18000B
	for <linux-mm@kvack.org>; Sun, 27 Sep 2026 12:05:57 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="NoV1T2/k";
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790510757;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s7JRcQFcD/nLSCcRzyB24nV92nZBWi01kt7jJ+1f3Ug=;
	b=RQPm98xdP+l/qUemjk5p0Q3AEYNFN90NoJL0R9GEUnc5wIJ/vK7S3BuIeHLqX9+qBbtgvB
	2lvGyvaSAm0nBol8WMTZbjqWEDq2v1dJPNxfwTh+3nQgEOn5H2zQ6aM1BFSen2gQRaE9wD
	KfI67U5cvZ5IKxj+QSUAX3nsAxJQPrc=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="NoV1T2/k";
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790510757;
	b=IxJcPTuI5RDvZ8IpW8CbNd3UhBjfVlDAw1ndd/vm7+/kc/GGJEtzSrwYzTQdCtGDVG6qmL
	fwZoivlv75C+c2ab2qGB99vooWIBOm8gKC5hJ/yoXilW+zpGeM9PQDDA5ZvVSzeOl4B4Yv
	BDpg1R14k9oXLoKYwiqtA398sLD7A48=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1B47443C8B;
	Sun, 27 Sep 2026 12:05:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89DF41F0089B;
	Sun, 27 Sep 2026 12:05:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790510757;
	bh=s7JRcQFcD/nLSCcRzyB24nV92nZBWi01kt7jJ+1f3Ug=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NoV1T2/kpMtR6i5MRGmMyCsemTbSIZ8giQ7lc6UOEqNw99Ur0/hgciBBApfxySnOU
	 Ya4FlAUg5YWUPQBEFMOmmOO+cvi1gHWaIMBrxTUnx+ut0BN5Z9Rv+CSw2z/3rWWrng
	 vd+vo32WAVAssZyl5kPAtczL+Vgun269nM/cne6xN5Jm61ahQxntV2WVxcAXZmQOv+
	 FQ5M6HTHNyvW2LoEH45McbaY7ULV1iUE8eha4mzyNdZfgdpNCuOUG3AAN2077yVwHd
	 QKnLHSkC+Jo1GdB5LBFNl7sYA+w+Y/j6f+EG2csW/UvJky/V1UlAizEJ+/jacMUsrj
	 45gjVRsF+p6aQ==
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
Subject: [RFC PATCH v4 5/7] Docs/mm/damon/design: document damos quota goal complement flag
Date: Sun, 27 Sep 2026 05:05:29 -0700
Message-ID: <20260927120533.50484-6-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260927120533.50484-1-sj@kernel.org>
References: <20260927120533.50484-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: C55EA18000B
X-Rspam-User: 
X-Stat-Signature: hbnxz6tj17sd1x4fcp58kp8jemi1bpcs
X-HE-Tag: 1790510757-634068
X-HE-Meta: U2FsdGVkX1+vWPq2W8ICqV7ko3kBXmlKKbD78tbdWfRv6ZJGSQVK/F3Sm1BCS/MJRsxQ6EQmMmv/mDrYUCJ1oteyKTxuJNYg9gZCEmoSs3/eY6PUUyhGy8KKGNEKPpgDzz/ty7c1993iUPJ0Dlc5HGsqrReakHggPyVi0NFGcZMFwFhZNoVVDGnlNmn2KF6ghBaXoN2IcqFlTnsTu35Af+RaOqOrZus+Wx125ps8qVad/LKYUdH2lvUsKrA7ioVavaI1BH/dtbBndk2zmSDHVRh8y+dTKU9BolYFGA2umn5xA8Uvs3MAQyB9SPFw4T2/aqoWmFbjyXdFeb3yF47S1RdQ0iSMUZUq9pUZrt7x9oCB+oGtrLkBMAnFmEp4JBGm8qqyKY1z1ZVOgM/04AmbNGeIrtKzJGWRAC4EQ5baLaCYlt3A4UtYHRBiWWOZtmNzGn69SUW5MfMbZbEG/z9AfW6/bCt3eFKWlTnJP3e0F7piLWukd9LyzRvbo3hPqzO959OkAkjz25kmBR5N1OEbZbxeJJnFhZ4DRS4GIfNZ+mMeV8HixU0R0HoCRmj/5kUvZ+67vkmA0ElpSUf+LGeemkkn9rGHgXo2LzuiLuUNqSJ8ToS+CFGr/Dv/A80I8yMtSY+ESd6TUbp0Mz6bcwdMrsR8JPM+f8SOcou+l97Xm2jodf+yhTFLA2BpnjHmb2TLhbWvQFjBnltDlb+gwzbnEbBEuZX3uqOHeUfrleGT8h/EYwHWfYRMX6W2w4gh14pPHezKzMrw+pqKKyXsC1s4ewNav2Y8VgStre4AJej+IpaI6xQmmYIEGrDSJwR869g21aMClDOUsSUcUNxJrjVLx5dVA5HX/wrxzeRER4b383GMmWKWAkXK0iBE49r/gsc7mYTejChMkpFtXhjBnB8d+J/esgV7BZY/JQUH7e6ZdeAX3oNVtEx8NEmFXZ8YQ3nsvAgFm1xXRK1O+EfYxhs
 HJzyKzWB
 rzlzDyEpmN/ApnKt5BtjMMHvG5e3XrkTQD9x/e2bJKaUORNxBrusquFoTqa2H7UAAWKz0em3XaLlmnkVmhShOyHdPHemhm9PMnl/KfJhjVFEJyDMnjWU/AgIA9V/bs1PPihbwSUiTmeR1ICOx5BgpOf27zQ8kbsLIWk6tH5YpBauvpa8jR3bDve5xLQlGsxbN3Vl+FG1KZdTZ9FK6QZbezck/pDUZhDhA5ALGicig+LT5LrI=
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

