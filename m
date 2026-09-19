Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 424AAC982DE
	for <linux-mm@archiver.kernel.org>; Sat, 19 Sep 2026 01:14:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3208D6B00F5; Fri, 18 Sep 2026 21:14:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2A31B6B00F8; Fri, 18 Sep 2026 21:14:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0F55D6B00F9; Fri, 18 Sep 2026 21:14:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D749C6B00F5
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 21:14:13 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3DCD516017A
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 01:14:13 +0000 (UTC)
X-FDA: 85228740786.23.E936ACB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 990A9180009
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 01:14:11 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dpaoMUZj;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789780451;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dykUrachf0u9bofU0mtE+nICAqd1iXPgIj01UxhVDRI=;
	b=NGoEBRLcnWoDFQeXYPJ8EeY8DEsiOGlKvDdDaMNNf0dFlAv4Ijug1xyhQ20Hvf08lZuGg7
	ijbozE+8nj6BKvn6HKw9sca2LtNaAjYQiISCzKVxJ+k8DHD9EvrDgezImN2SjRx6EHTYXR
	Qu86z0eY3CsiGssKbWDGSxxLM0AXl0E=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dpaoMUZj;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789780451;
	b=RLGZnVfbpr2pymLC4q7tckuV3yJ7wb2XH0MH9C8uCObZSltdYbvz64DDzrJnn8vlUTvqqd
	6OrglXHVVPntAIBJ7DR33kG36nW/pa+5DLaemFFctIcMAqHI2vx7o7jgVIBTH86NPNR5yg
	KojHefgQrebhZla0sesVwGyH1cYomZM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 36A0B60A5F;
	Sat, 19 Sep 2026 01:14:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D3011F008A2;
	Sat, 19 Sep 2026 01:14:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789780450;
	bh=dykUrachf0u9bofU0mtE+nICAqd1iXPgIj01UxhVDRI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dpaoMUZjsmfc/gRSWi3EkRqOcddy/QYjiD4soj42whor/9DMlYFcCo3gLyoL69r0f
	 Nj/qgW1TD2kUcui8NKjwYtwtHXHsI8uqaLA2gDqxA+xnoHRnSfJmw9L9z9Voh1+xoI
	 6pQwu32hNXK4dQg0Ain9vDo3qAMGAYrvO473unjqD1q7/DykNzexfCnRYX53d0Zc9f
	 dLxylJ2FOiyH6RnKZsHaJ2tHEstbqRh1qTwFUdFXHVrOg3bNNkJNylFa9JG+tkIuX5
	 EOuujj6WiaQCTg3LpHznuibP5Ern3L/tqaM1D0hB5yriLc6Dui2K3h7WR6p0TMA4FJ
	 nOQg/DnTNTXLA==
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
Subject: [RFC PATCH v2 6/7] Docs/admin-guide/mm/damon/usage: update for quota goal complement file
Date: Fri, 18 Sep 2026 18:13:55 -0700
Message-ID: <20260919011359.88921-7-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260919011359.88921-1-sj@kernel.org>
References: <20260919011359.88921-1-sj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 990A9180009
X-Stat-Signature: dn81sskjcsbtzyjehf7qzk15k1wp5ckj
X-Rspam-User: 
X-HE-Tag: 1789780451-854760
X-HE-Meta: U2FsdGVkX1+Z90Cvg8nuaYlDC9LkBDDAwYonhQx7bGhKibt8neuvuj9sry2Hh40L58UIPEr1vKrwduaVefBZrgT4T+6sWCA930rpgtRTYv477u00654YxQrJo/W6k2rRzykaoNYN8BRe/973vcwMGkB7pX0Fkd4w5dpFyO/ljPs5o4ZNbhr76hn4cgtLthM3qo4c8L5G6/4LqwQSA3RT0E7ZGnEsOi1RQz4n371GEXT6aFaISQSWRPYVNca5FOIaiOBB6FYDNakAmws6CyMHM9MtoiNhwJ4jgkEQSUyIxdPoiMR743tiaukEXH1kv78nVAa22zApJwT39bXCwTDJzezxY3dYzudGNZulZ2oByN5/VUA5sFPKCMmYJo3xJ2qz3iBsQJ2eOtN30CIv0lBPmsH4FBI4nQ7sfq1FfsJCRWEbkf9TwUp6PjnM4smO+t5vU8bPD9sozpYCCsqzjc3eUucre91kfPYv+ltdOXT6wzdCKdrsI/7CzZiNj5/drLU0u5RlVrRkgqAVjCSP4Edmfhm4j7a2v8Ekxf3JbQBIMymVCvTFdZVsVZRIx6e9+pjxnNmoCMAiasoq+3XomDDMpGIQcvGEXNW7pPW12LawZxCWFniNPEggs49EcqxjrEjQ37VkgC0fXUy4zVq69cs8vuptCkT2KMDh5MJ1a1g2/YaIPtGQDsH4XB06wMd8kETYP61fWNdYLiuiyZdmLPxbWGrnDscCz+dNUZ9d4qWrQ48Ap9FUzwuC/rcqb9xA9FBKsQ+jfRL+qG0WIY8uOKuXQ1KccZ51SX6Q+G73mT/ru5pNX5gWsTQ/yucH5ewgoLChZxoKe+vVJNXAG40i7Nw4iiuCfHsAjKRScplwajqz5AV7Bm5wPPtETZw8ZJv8aJMwUVDDygby7jI9WPg/XNnSYAEeQFWqQvA65J7vQtfSJqF0nVhaYfEx1bHElS1M13Pv3Z0YIBhjipfQ5ElAasc
 jihKoHYX
 nelxzAVF6mKOeKlP1hlvJWlD8xApOCEN9xFN8ZmmcRMgV/BcySNlNHpRLW93sFGQXtYVefGid/4o6t20HuxTfspXLjgLjAJOjs3jaVSIgq3ce3KJHRXLbd2C8jlmH6S7+HCWAm2w4vBjDPwfHEnME8BCLsb/3JW+ti40XQnA5lHpPp5KcOI0J8582wL04lQVEhkCAAPSfkqAr2PN61rXwI3I65dwY51zi8+1l4aJl2YF2C43cip4ggVD6NuDL+IrBbZxgELq9mfpJ0jAZEk2s3yDHB3nqxMP3CdmAiOfIJP+Qiekhtf3fI6Upsg==
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
index ba47255448564..3d43954c7046c 100644
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

