Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 733EBC9833E
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 09:34:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 569B76B009F; Mon, 28 Sep 2026 05:34:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 51B686B00A0; Mon, 28 Sep 2026 05:34:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 345E96B00A1; Mon, 28 Sep 2026 05:34:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1243F6B009F
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 05:34:13 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9AD93120157
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 09:34:12 +0000 (UTC)
X-FDA: 85262659944.25.707CF7F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id E8BFC40007
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 09:34:10 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=N0E02JoM;
	spf=pass (imf11.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790588051;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=E1gVvDIreHP8ao0G8tKQqDlYq/j2WrsMakNo62d+qXY=;
	b=R7+LFbJ1lgpTghvysWK+M9fvrKN7/EKwnNGH7krod72m4xcM+Dy3ufPQ23SaiI0FHrOCEw
	lhtOAol2/CRgVa2MUak/WsQ4cvEfHI1NxO2t+nHEC6mrLx6VBIyiyOHF3Bi2d4v6nNkHnc
	PyVyLN6JAcKmYp09xyjLA1TplpKTDKg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790588051;
	b=TtB1YWM153LeHgVq6mYcpYF6G3LG/31qd1enN1/XItFlIdfYxEu+pUKl5Pvsmznk7fx7oK
	Xq89kAsrdNX/RRn+G20fwYiSwPgS0YjF19FUoTox7kFwQhl9deNaVfoTMQu9soeTNDpvtJ
	eF2dpIAd4XYPlVDo9aPwf6xRxDh7ja0=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=N0E02JoM;
	spf=pass (imf11.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 499264395F;
	Mon, 28 Sep 2026 09:34:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 560931F000FF;
	Mon, 28 Sep 2026 09:34:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790588050;
	bh=E1gVvDIreHP8ao0G8tKQqDlYq/j2WrsMakNo62d+qXY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=N0E02JoMH3PkLl6vfJjQIv/qRCFJeRXyUWyaMhsLe8Lf0M54ozhhKT0zfuzkSsacq
	 thmbBSFwAt4ZgGdjOCWYFgo25dhHtb3SMicMPvB05mOcfh3T+Sz09IfmFv6ex1zgpo
	 b2+e+Ovm7CM2tiZ0qrcGsTStwvQTHG427fnoVF54tDF1+GgVch6DK6792BnFjOWcXV
	 G0DxeYgSfNgHGOvxMzdVKCkoIzK7yr2vKc0l6hXhD7xH6zRVR9fEw8L1kKNiZzAq4m
	 y7SQSXNB1ER3U+EqQxwz6TMp/S8kHwGPjCA93MDQ7ziT9vYn+OA65VzORMfEP89nDh
	 zrkWzrOZqevoA==
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
Subject: [RFC PATCH v5 7/8] Docs/admin-guide/mm/damon/usage: update for quota goal complement file
Date: Mon, 28 Sep 2026 02:33:39 -0700
Message-ID: <20260928093342.16584-8-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260928093342.16584-1-sj@kernel.org>
References: <20260928093342.16584-1-sj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: e5rzetfksidpwcck3i87tzfdbr18gk4k
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: E8BFC40007
X-HE-Tag: 1790588050-223159
X-HE-Meta: U2FsdGVkX1/WMiyIuqH5TqmLl49EoxRCC8qRGZyBZhe8kpP9izRb/XfU+1JOmccnW9QiQt4X7MBAWGne9n8QoBMt2OyZ9eJuq0fuyx8YJ/sAVnHD0LQ93aqsZOoej1+M0HS3x8d66FjwGuIFtUQuY/GXMP+8yyEzT6sFpKH5PMY5fhfnCpaI+BjTlRLkzdBrN0bbdkEPEaGnHsHCmvHAm+kZccnpWF0HXt9msMqJ3/cX2HdDR8dz1hjNjC2OULDZ4LG3qukWeTO07HU6Vh1IhB4mQBrXtrbpiXtRlZeNOPSWzVClgkkSbPQkzQRQD0gkiV0Og7Ry3SwqfSz/NoQNpTSDc+gIn4DYFeToLy07VpR48vmExggVFh91LEA3+a6Y5ZvTLshdpLHYZALmKHiUOl7mG0QIyKGa+98RMcLkK0t+1sXNTfCwf5iYlh4KpKHgEaQpi8eSilEx+ZoV1HXHkLzaXwiAndxVrEwmPPmSv79/WmlKl0Xkv6o6f6rZfMDEx+10xogtz7MQ6lbxP3jgDyXl4ZeIRpOiXFl7MSZQZzyfZS/g29L+9o6rokTrb1P3Z3i4m202/f0x+JmNiuhasYv0oR8WF7TUkWkWNPZjttuqDARhq//+awmELu1KcgZUnjUmKRUKIfGII5eNxDs987psIUEjzgNfARoIqPmd1DI46pgLAPMjpJcGUhyliVFDOEHF4H+vVKiQoCYDKZJ2oCg4KjTM4kbC08e11cS9ZL7YR+ZijmPl8SJalIHB/fT+G0Nsw+Cx8uqRSRIB96mLi4UjexrmAAary1ELRM4pZgsHlLHQEdnz4gmCWOTsViAyEXbJ0myN5/ts3cVBelFghrc4puzyPHAKG1l7VtFwT3X8stTdkNqA13yuEDt7+OZ9T4oOdGnWNyp2mabPqrjCjuJSJReyOoD8Pn/4gLmcTmm/uZe5owO1Fr++L1ZSbiM06/j3/kh63dr99Oqjh8q
 zD6lA6aB
 1X3gzgSBC8Nki58OV8RXXnmJFhH2CC+Q6nelJvMFW6VYSWrDQlRNO9sWHr4l0XPYg8bZOA+S7NMwtucyLSBmEJ9KSWS+bwsMFIBTHHZdazPLOXPW9DAJyFlV1fEmvJinxoPnfYP/4TH5lFED+QLaDDogtLcDoKYN62JdQzS3OSwa5en41OeyNCmrd2cWwrEeYju4g/z6dcGbBc0F96DSEt0zQ14IdYXGfUoNogRvAsP2fearclWnk4fa3bFclLZSHA9xLunlPsuOpRkOyuvjSLb16G93iPl4R4VcTN71A/w4mkwnMCG/WVtv99A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update DAMON usage document for the newly added quota goal metric
complement sysfs file.

Signed-off-by: SJ Park <sj@kernel.org>
---
 Documentation/admin-guide/mm/damon/usage.rst | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/Documentation/admin-guide/mm/damon/usage.rst b/Documentation/admin-guide/mm/damon/usage.rst
index ba4725544856..3d43954c7046 100644
--- a/Documentation/admin-guide/mm/damon/usage.rst
+++ b/Documentation/admin-guide/mm/damon/usage.rst
@@ -98,7 +98,8 @@ comma (",").
     │ │ │ │ │ │ │     fail_charge_num,fail_charge_denom
     │ │ │ │ │ │ │ │ weights/sz_permil,nr_accesses_permil,age_permil
     │ │ │ │ │ │ │ │ :ref:`goals <sysfs_schemes_quota_goals>`/nr_goals
-    │ │ │ │ │ │ │ │ │ 0/target_metric,target_value,current_value,nid,path
+    │ │ │ │ │ │ │ │ │ 0/target_metric,complement,target_value,
+    │ │ │ │ │ │ │ │ │  current_value,nid,path
     │ │ │ │ │ │ │ :ref:`watermarks <sysfs_watermarks>`/metric,interval_us,high,mid,low
     │ │ │ │ │ │ │ :ref:`{core_,ops_,}filters <sysfs_filters>`/nr_filters
     │ │ │ │ │ │ │ │ 0/type,matching,allow,memcg_path,addr_start,addr_end,damon_target_idx,min,max
@@ -492,12 +493,12 @@ number (``N``) to the file creates the number of child directories named ``0``
 to ``N-1``.  Each directory represents each goal and current achievement.
 Among the multiple feedback, the best one is used.
 
-Each goal directory contains five files, namely ``target_metric``,
-``target_value``, ``current_value``, ``nid``, and ``path``.  Users can set and
-get the five parameters for the quota auto-tuning goals that specified on the
-:ref:`design doc <damon_design_damos_quotas_auto_tuning>` by writing to and
-reading from each of the files.  Because the kernel does not update
-``current_value``, reading it only makes sense when ``target_metric`` is
+Each goal directory contains six files, namely ``target_metric``,
+``complement``, ``target_value``, ``current_value``, ``nid``, and ``path``.
+Users can set and get the six parameters for the quota auto-tuning goals that
+specified on the :ref:`design doc <damon_design_damos_quotas_auto_tuning>` by
+writing to and reading from each of the files.  Because the kernel does not
+update ``current_value``, reading it only makes sense when ``target_metric`` is
 ``user_input``.  Note that users should further write
 ``commit_schemes_quota_goals`` to the ``state`` file of the :ref:`kdamond
 directory <sysfs_kdamond>` to pass the feedback to DAMON.
-- 
2.47.3

