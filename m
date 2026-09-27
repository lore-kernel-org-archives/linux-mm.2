Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67A9EC9832F
	for <linux-mm@archiver.kernel.org>; Sun, 27 Sep 2026 12:06:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1E9C66B0099; Sun, 27 Sep 2026 08:06:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 14C786B009B; Sun, 27 Sep 2026 08:06:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F2F696B009D; Sun, 27 Sep 2026 08:06:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CFFCB6B0099
	for <linux-mm@kvack.org>; Sun, 27 Sep 2026 08:06:03 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4E219409ED
	for <linux-mm@kvack.org>; Sun, 27 Sep 2026 12:06:03 +0000 (UTC)
X-FDA: 85259413806.22.F108C77
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id AEF2C4000A
	for <linux-mm@kvack.org>; Sun, 27 Sep 2026 12:06:01 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=H0GqcVCk;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790510761;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=E1gVvDIreHP8ao0G8tKQqDlYq/j2WrsMakNo62d+qXY=;
	b=Z9Cj90nQZU99EiAqLqNXbRYxvmdPjrZrXuLwPq7cDTmJqrGRlV9BFM+4lsoEyfHvnbjCJk
	DQPBeBdEJsHqDY0OD2T32I0btm573Db4chVHxeFLUzU9lcTSZlaCwGuMv41ycFrwwqy5fX
	wDTOWznsaXON1JCUUehBGi7E+WUSrmo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790510761;
	b=o53xVZwVHjhHzK8BKtnVVwCCtgd7BjJTBMnlZWsH7BH3ydIX/LtgX8hlmis+Xnp9VM47Ax
	FwEgy8VV1pj68k4wWzWRiw3bvmahv7ONl9VHwk0VO/39Tv+pvCXHBYysaVpfbT4FJX1bxc
	ETi6XKDB+Mgqnbpj8ZpvhZENQST8aWU=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=H0GqcVCk;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4B66E60D78;
	Sun, 27 Sep 2026 12:06:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7628E1F000FF;
	Sun, 27 Sep 2026 12:05:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790510761;
	bh=E1gVvDIreHP8ao0G8tKQqDlYq/j2WrsMakNo62d+qXY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=H0GqcVCk2VyB18B47rOkzjOJvAqWtuVDdR65tyOxAUPOMYP5cfuu8IALwgPhgxgPO
	 oVe50yWpdaKZowdTvhm08iLQBtG9o0klkSwjJKDC8+yeD7CdFWSsF9SAsC9slH+ZBm
	 OYe6Xfis1fjBqg1htJK1i3PmtA4rU6HyNuDPfx1HPq+RoTlZDEkCM3GU4Tq1QCMa+/
	 l/W+2PxZPROPb6JmO1bwfggGRUvz+ZOO13akfFj+O2g1E3K1O51GfwsUx4snuHxvk0
	 VLgbjto0imKQSpah8qRVbx/HYhRN4lxkuNnSoK4y0dl13Sk4TtMbgEE6SG7o+wqerK
	 TFSvCtiwI30Ag==
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
Subject: [RFC PATCH v4 6/7] Docs/admin-guide/mm/damon/usage: update for quota goal complement file
Date: Sun, 27 Sep 2026 05:05:30 -0700
Message-ID: <20260927120533.50484-7-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260927120533.50484-1-sj@kernel.org>
References: <20260927120533.50484-1-sj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: AEF2C4000A
X-Stat-Signature: 73ebmptgfm6ujh1dax6o3ohgekr8y1up
X-Rspam-User: 
X-HE-Tag: 1790510761-389197
X-HE-Meta: U2FsdGVkX1+L06fM+aE72dRiAK/gZ2V7fgsJQD505874hSbDvGpgojb2A+rvdUvCXqtqTOjFqb/GvtrcFO+WPvVfik7UwZ9EYjw8IFFIMQwzme1dUsxOhgYxRP0Jnbzu5PSJnuhv24Ks7FDw5IgwsvfA7a6wcEy2woSWaZIsAfQIcf6ijDKRHRJy3ANN9XJ2OVd1VTGBYBPNcIMuHV+VtAhMkmzNMeMbTnmie9GuNoHiffg5wxA6/MFWCgReqn7/jdW7APg/ko/c+2+MGGlHyFjsOtK+jZSBEGp3u2pQiMX20jmK9ziXEh73SVjyHf2jaddcWgWU137GP6bTpxBNSFtboBgcxgLR+wSkuFN26EWuZHGsEzfxpFkQrrYr2q2b/H5KvHbo3+7t+5xPeFKzzH1Sf7ynjKSyWgnur3dZbxwk9TsoT3wnkLwBslcgMwbHOj7o8deSDpbtDnEvKoK6RsHaqvkcfKvp1IdJOTpEiVuc6/7d0A2AOqIZJkhli7eoy/4/hgueDLdt2uSD0xHZYNfwM0A3qKnO38mm18kVdwlaYeepxhlUtTfVrE+FmqGzHDa5CiRtOM9ShnX6gTyqdNbZUDkuhE3naxIxjLlImyBTXV8i7DOX4mcQuaOQ75KUi4CLQeL0q1tmFcCC+KW6U5dZ9Et9Vx5IKsTviiM2YopXr60YiaNaDQvpa5fjLj7fiuqIfMxMXr55LmSYeqMV6y4sPOkyQdSF6cqIGKTaPl5Jq4vcAZ1Ka+d3e2dF/7zD1X3tNC8Y36wG5e4Ddmk/X+0ABgVvooOY2oOJHD9uyX7y1XQCJUQyiUTZJC7OLeGnkBqTLxPbO9wfXysvPis9WEY+rDlRhHD4dBOmTAxvwXniib36HDJBL/Nbnxc/VV2wU9GNh2a1Lx7Z927jDp+M6IsyoDEhMGN27ud5AplCVQUyyygCg/CJ3oBXZi0lsUYnBEvMPJW3lty1E69P3Xq
 ztcqNXNV
 /Lo4uL5F72J9B25Vienr2lqEeKdJi7HutwS8zSU1OelpV/yTTKNW+27bbfgLxF4cufDDDndc4mkn2Qp+lPBFTZewPnhrctkZFNrVfUsaHarotZR8tilXIrXqmqOF+Y1Zd6eHSIAVfiPmUO0Vtew/carnyDGs3uuP/4QvAK8+5r6FoeVyCibi4TbULVHZSzKMyrW9CUhX6HRNylbmRH/Q10B+kTJrdLesL1D65UwRdCcp4y4ts3ghSmv7l5LHPNFsxAKt2QAAPgPzDmLrpBK9zsv6AeJKmKHZADGfWIdH2hm7VMoGUwjYOPyHj5A==
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

