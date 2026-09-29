Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4CB4FCA5FA1
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 08:01:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 626CF6B00B9; Tue, 29 Sep 2026 04:01:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5FDDC6B00BA; Tue, 29 Sep 2026 04:01:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4ED576B00BB; Tue, 29 Sep 2026 04:01:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2A6F36B00B9
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 04:01:41 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id ABC1FA0435
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 08:01:40 +0000 (UTC)
X-FDA: 85266055560.08.F6CBA77
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 19CA8100007
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 08:01:38 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lGFYRwab;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790668899;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=E1gVvDIreHP8ao0G8tKQqDlYq/j2WrsMakNo62d+qXY=;
	b=8fhGkIFrd2g7e2tpFfkumsFCDYF26hl/KvNI3RZFdtgocM8FSgxK8LwzoUFM4EDfl3EVcM
	yv0zTUzPdVrYogmpznRM9RhXTM+LRoSDkJH3cTbgOqAaKaeyKalAJk/nZTP0U3/SePs6oR
	CHy3opwa8iJ0xM/agRwNhjPW76hqMrI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790668899;
	b=qQ2qyl6RZ8NNNCrcYj80+P57lNw50BqUv+hOUPIA5CI2FIGqMw943fAQupl/fjyy/93hiO
	Ard5aAY2dt5b6YhUZes5MrdOlSwVgm4k9Iq9rCW8Etry4DIi5vQYmE3X6NKiLY3yZI+Ua5
	jW7ht+V9596giakFwpjNjcJeKoOcJt4=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lGFYRwab;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A71BC60A5E;
	Tue, 29 Sep 2026 08:01:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFE661F00893;
	Tue, 29 Sep 2026 08:01:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790668898;
	bh=E1gVvDIreHP8ao0G8tKQqDlYq/j2WrsMakNo62d+qXY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lGFYRwabYvUuJtk5Cjp2rfA8d7hpEVAuAPyF5FvMTlSaYv5oZ6dTwftRo9F9UkP8P
	 dY2J9oRTYT5YgnNAfqtUBLJfJjNJIl0SbBbLSvwzW3c39wqBybnJX16YU7wFltctqt
	 +f+6bzutPKhZgwaumNUZ9Hx5jang7R8sUT7+r7xRsrP0gAq1twO9BSJKNqt99FFc5Q
	 ro3gm5uNaMEmtZjG52gpS0QBLFj3wKaBEHrCD8gOgiHmW8JkKwuYFtLUht3kLm9z+o
	 rSUZ7O9l4sPW0xmel1oGsWTL5c07Vz76/jhpcMlud4xAq9JrUk5gszynHu82H3/7Bl
	 2q2cvhSLXqDzw==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
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
Subject: [PATCH 7/8] Docs/admin-guide/mm/damon/usage: update for quota goal complement file
Date: Tue, 29 Sep 2026 01:01:10 -0700
Message-ID: <20260929080113.41708-8-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260929080113.41708-1-sj@kernel.org>
References: <20260929080113.41708-1-sj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 19CA8100007
X-Stat-Signature: 9xaxmj8spzsfajbbuoyhh7b8pq3gkjah
X-Rspam-User: 
X-HE-Tag: 1790668898-156857
X-HE-Meta: U2FsdGVkX19Tum3LBv45miis5ovA4iihtVQ4Yl/CKSNo4I3jpnbToi7zhC1DQR/WST3EzXZkn/2YyhDvj/A0jhHxXPhpbbJZPqBWatFy2vJNfJ6EUcZSKHGrUDqjqywckR7GsWwH+c6R3Xh+1NkuyeXZy39Zlf4lYRooXlgPkhmUkNG9Snfm/l9dHxR9uJ9W8/JdT3GOjepGp+fiyXDYkgbcMTlp5PCXfXxvSnCmrV/zNurK5eegsKJl9GJaAIBnJ9CL/trm4RcYadllJ25J9E49PSPckt0zgtmP1ymVGwA0cCP/JNHGKcXBOzSvqswuJmWz62Dw/WyrzU2L7rbYXDj8giZml46XrzhKgMJd2AFLb1PDDJub38tThS4XVyBQ19KskX9ARPtjYaiVEdCRA72u27B5DiNfbCHkMB7KgaLGXnXW5l15Ue86+vYf824OhdHA0fEDywiEiFdWXW7YQ5Gi4pzGvJqdmkrCLLFDhfbfgkYc7eKb/Rvsw3cwTaQY0dGP4dR3sVrp4LHwuiNKK7k3ecAe4ONNa2k0tAYORRnNLeCrP4sjBxVSCz4w9cV+YgxRb3t+HfSA4xf571L9T2uWvwDtdSvsUWvNMlP4LSOUQb3VwkvM8iTmXNeJvf3AYN1HruHVN9279AWGso3NqE0FVGncUprlAnrmsyzW6zbIbHUfZmeaY5QYsHpvJ1LtDVIeonuyMa8Y+V109En/xr1X7RrT7NmKqsl7mXT5XEWTXj6ZsCPZy1ZSo6edo0xPvEsYj2xtVg7Soxjj4r4XKNUrNuan8Jy94piATqMS+8HN0kksCUGslKbCa/uHTWYEGhZgn2XAejWR7AlhrqssN2GfL0AatqI6n0n8ycwwWmM4NiO3bgHDlasCHrdwDmzmyJ7CQos3IN60KYFuLJBMJAY1RUuMQOvpbP7wlHpAuacZjtyljLUCaCZURm7pXiTPSZ8BMlp8P/0Unym8mnJ
 jWCymEYD
 mTg1+8/bp5wCiHcDbktVUqBExHu/yb1rhWyQ7BtaFC3rNoj4mDSbtL0vJOXFhkHCgMrmUhTlO992v4NwbbEQ/DmGZdD/9Khh6OV3oIKx6eqp45Zas7musupUpRf77MQWT+S6GY6vxb7KDhaXQgbECx8Kzjgl2Yn3K6mulk+deLr6iqATIoJndWod/WN0dmwQqE6T7TCa79xwMXrs79SmKmmPVA3iZICVdFhXkQDnVbXg8zmQfRMVqvrbHXFR0GxCC1GYa1IKlo58W7zFR1HYrTM7jx6V0P72OGxkPAANb78AC2TtdULo9ANYuVg==
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

