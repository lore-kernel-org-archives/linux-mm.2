Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D0FECCFC518
	for <linux-mm@archiver.kernel.org>; Sun, 23 Nov 2025 18:44:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C3CA76B009B; Sun, 23 Nov 2025 13:43:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BED456B0093; Sun, 23 Nov 2025 13:43:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A972D6B009D; Sun, 23 Nov 2025 13:43:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 850FB6B0092
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 13:43:50 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5E8461DF587
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 18:43:50 +0000 (UTC)
X-FDA: 84142745820.23.E0E161F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id A358F140008
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 18:43:48 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=iiM7b3dV;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763923428;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D9wQrkJ5b1Ofh27j+q7D2sfPqEa5Py/IFROhc3PXwtQ=;
	b=qXRJFwg30wW7wc7IrOTjczfOhtXM03xIJO5lsWUQG8X2P1FW8WIkOkU9qFoq/sl+c0ZDbw
	Vd634wcfrPxQCZgbtNNCL/tRgTU3VvCWXbFnCQNaLJ+olRdA/kbsv2XyekgAlEpBlXI3Dk
	55DTdDrga4By6HhfWvkwmOWeBSHYZKE=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=iiM7b3dV;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763923428; a=rsa-sha256;
	cv=none;
	b=10UrR0TB9m5IGypnYkypgq633/OWlXfdJ3fC8k2WfdZKfVJq/RY+Y2AP87G8MQafzf72o6
	S4DhbY2wMXNGCQFndmdrTP2NKb5dY/7tVMeJLvR7rTmgYL0Wjsy7vZXwSn5lN8c23yAiPO
	AGoJcnfvY7b/keMKVEL7HGB/NTn8WQg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id CB58B44365;
	Sun, 23 Nov 2025 18:43:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 571F6C113D0;
	Sun, 23 Nov 2025 18:43:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763923427;
	bh=ihzFy5TOJPnYv7zeqZ3FA4BsW8yTIpVlYGwomLZgsUk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iiM7b3dVNQ4X2OiyrZkf0LKuyuwDddtr10cyC02fxUSnJKk6aEKb0yrRfFh9PQHQ9
	 J165637B4tbSLIC4BlPYbwqLkm62A1Q2vuhmoKXxqi0favHEjmQyv5oiypoK1AsLC5
	 lq4hZZdFZUC9t6hTVHEC3fQPhak49Zylx2V05NvGw4Q28SGOTR/4wKjKshgWq5rLJR
	 6mx2lINXEmsh0AVIH/ulu6muPvzJRlSxS+N0PkvSNvXXxvkzAms0948oeBgls0AdSh
	 unjZM2AGydYVFcS1GQCKFYDk1NDwOAm9B6IhSz/8dAWNWg0nOO8MjU7SQ7r7FhmoVJ
	 g1LvJ8B+S016A==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
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
Subject: [RFC PATCH 10/12] Docs/admin-guide/mm/damon/usage: update for max_nr_snapshots
Date: Sun, 23 Nov 2025 10:43:24 -0800
Message-ID: <20251123184329.85287-11-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251123184329.85287-1-sj@kernel.org>
References: <20251123184329.85287-1-sj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: A358F140008
X-Stat-Signature: 1eq979cf6hiqc6474bw5ust6ey33qfn8
X-Rspam-User: 
X-HE-Tag: 1763923428-22098
X-HE-Meta: U2FsdGVkX18R2u2HRflLObaBUums8pfsBZBjGQesNgEYEFtjtgKQ7fvnsMKPfxhb5g84BU2djYsIFtz5VI5Zt8JoMK7ErQOS9F3AXRbpn2eHPyi6b28V6Zdf/tE8aeg1hcxvQKFSj4SmtETpRvs5T4iJrNVEkSoA+n/x2d7YJ9Yud9GA5mUoXXtWiC3neaviizr1cBvawlzv5kqK8TESMBaIytxROGMgdGxqMFfCMUAaY6uTIJKkKrG6I27Gy2rtf9TWWm9s8QJmtUHVN2t/wgyt0DOJT7rVspNRI/B93TUPYSZLD0Nl3kKV0yPTtP8QgQuWOF/exzBl0A1zFUKhF2LOjQ0OgXGrGoX0LlNwwpO+HkXnZ4W6SX/azCIKBsN8vJV41/cXqqcy06Wc4R1NhKxBMdQU6lFoZnzyeYibmSpWii6PUMePcIvBoJ6wJagWLPRtRCrN6ES2o61KTdZ2kA8w+fLwUuNBwUUb4R52Ane7b/gAwIofKWEYfS2Fpgr0jEU9c2YIrqFounrFg+jYOVNMFk/U5aym2LaEfHu/CKmqXnA2Uw8tZ92sdTO2xE1z9pCXHv0nHItmomiyT9B+gwyYY+0cmeEt7pGrjP5Pvs+P2EyVOINSDvuyVZQaSLd6tltaeRSIaKh8K0fftcVx37ZAQWA+p6U+jluM/RC5ILoY5CoUtj3yCZb9Fc6Fv0gbSmjn+WHqECRqqlLsHwubGh7vYCqmlxZ6t9TA2bQ8bgMDTRgX/6F8CF/JLOEhXVluuaeR+BVW6JwoSpQwAcKZdv5shJICiGM3TkxIIp/88nP3t2LMjz5hP0P/2ojZ7/TabyOEauC1PtfSObzyIP54DnvbS+sv99ebrzKFWTcxh0jsSLjYnsjJ5J6dLrVN4iP9JhtfkqHIxOInq6kfWnMQGrZuGHRihvmUoE4PsWnUiyPp8OY05np9IYTlpH4JAfGy8d12LeKAsWoNz80gdf9
 CRVW4qX8
 ++OAr8aeeJFnOx2zBuzWESnWtnWN7yYmuhLqbYjn8TIWoYdaf5PAJ5ex9RPOe3ywmX3y9h3peJW5UcZasDP9opdSP5b8Qoohkj7Z4fdOFB9Cm0M7tty2m22p+CSrRaXJgKwLhSepzoLMxv67lyKNr/F7cTdvolxDJym4J2u8cZNudYAE7psWI4TN1hLLzbnwQ/0tt/1gBOLJUdSRDn03QoJCyreQtBOFahMqd6RhSl7Ihi7x5PhWFOnZTDo6zStw7/kRBURjmsa8iyF5hfxG0v7eQ/acIucVYOOGd3M77jL5jjyb/3WD0bwEieKuvQ5+iqdg9tL3hszvUtZwnp/oQK+9VoQVawGsPpDUC
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update DAMON usage document for the newly added DAMON sysfs interface
file, max_nr_snapshots.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 Documentation/admin-guide/mm/damon/usage.rst | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/Documentation/admin-guide/mm/damon/usage.rst b/Documentation/admin-guide/mm/damon/usage.rst
index d0944bd78964..7da4c002cb39 100644
--- a/Documentation/admin-guide/mm/damon/usage.rst
+++ b/Documentation/admin-guide/mm/damon/usage.rst
@@ -87,7 +87,7 @@ comma (",").
     │ │ │ │ │ │ │ │ 0/type,matching,allow,memcg_path,addr_start,addr_end,target_idx,min,max
     │ │ │ │ │ │ │ :ref:`dests <damon_sysfs_dests>`/nr_dests
     │ │ │ │ │ │ │ │ 0/id,weight
-    │ │ │ │ │ │ │ :ref:`stats <sysfs_schemes_stats>`/nr_tried,sz_tried,nr_applied,sz_applied,sz_ops_filter_passed,qt_exceeds,nr_snapshots
+    │ │ │ │ │ │ │ :ref:`stats <sysfs_schemes_stats>`/nr_tried,sz_tried,nr_applied,sz_applied,sz_ops_filter_passed,qt_exceeds,nr_snapshots,max_nr_snapshots
     │ │ │ │ │ │ │ :ref:`tried_regions <sysfs_schemes_tried_regions>`/total_bytes
     │ │ │ │ │ │ │ │ 0/start,end,nr_accesses,age,sz_filter_passed
     │ │ │ │ │ │ │ │ ...
@@ -543,10 +543,11 @@ online analysis or tuning of the schemes.  Refer to :ref:`design doc
 
 The statistics can be retrieved by reading the files under ``stats`` directory
 (``nr_tried``, ``sz_tried``, ``nr_applied``, ``sz_applied``,
-``sz_ops_filter_passed``, ``qt_exceeds`` and ``nr_snapshots``), respectively.
-The files are not updated in real time, so you should ask DAMON sysfs interface
-to update the content of the files for the stats by writing a special keyword,
-``update_schemes_stats`` to the relevant ``kdamonds/<N>/state`` file.
+``sz_ops_filter_passed``, ``qt_exceeds``, ``nr_snapshots`` and
+``max_nr_snapshots``), respectively.  The files are not updated in real time,
+so you should ask DAMON sysfs interface to update the content of the files for
+the stats by writing a special keyword, ``update_schemes_stats`` to the
+relevant ``kdamonds/<N>/state`` file.
 
 .. _sysfs_schemes_tried_regions:
 
-- 
2.47.3

