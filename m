Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0EB93C624D3
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 14:04:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 039BF6B00B6; Wed,  2 Sep 2026 10:03:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0105B6B00B7; Wed,  2 Sep 2026 10:03:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E8F006B00B8; Wed,  2 Sep 2026 10:03:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C02A36B00B6
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 10:03:43 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C09EC80200
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 14:03:41 +0000 (UTC)
X-FDA: 85168990242.16.9EE66C2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 1DD6720005
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 14:03:39 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ep7T5umy;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788357820;
	b=b0oW3bxIj6UxO2KdST55MdRLe02He/L8ZZuICAzz3/V8T/HDxcgG4lkx3PfzWQ312eUZjy
	5/WXO3T2ikUx74ZCqvDAbRSyw54FRXrzu0fbV3sKeeqslQKaFocjp7T5HSn1c+zbrBjATS
	WWBimnrdieMajYqqcgsqxX/NxteeiHU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788357820;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MtDpGEkDh7eFQBN1dloGGbcdOXn6qckrmCm8+BjUBow=;
	b=M2R73fAQd2ftEDTmpjs5lMD2PB32BllWfPnpv9m/ySQuNk4q+x3BbJnh0qvFIhX3WpCkDn
	4WjYuZzFDcGCRXYEOFYWU+/CeGeYNEuAzkj5eh/AG5nfBHYhJucuMQSkaikJf1Nf45arx0
	CvNwUN11m3z2qlbPdmYgLRFndIkeSZU=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ep7T5umy;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id AE14C602A8;
	Wed,  2 Sep 2026 14:03:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D26E1F00AC4;
	Wed,  2 Sep 2026 14:03:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788357819;
	bh=MtDpGEkDh7eFQBN1dloGGbcdOXn6qckrmCm8+BjUBow=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ep7T5umyQPsaQIuxBEjumOhQlbQ6KcBV9dQNiJD3+3dTJb2dztfr3aHL5vmczrWjA
	 cXBm21+OWPnSjsnD8FIij3l8BzZ2UKed60ObsRunCyGG5YXeP6Q5L28a1PMsvqKGSu
	 P0zGLpDTUXqFttIyEsqNQYcPr/ObNSLd8gOd3SFBTuqsl+24UxLiEnu066WYvWhDPS
	 EYitdTC6bVj7x6LwAGAFVbiP5EVx9bSFL/wR4vMRJr6oRq1DWuDQkjxaqqc8QH7y1L
	 d1z1XZ0AsRckAlxG0qoGawcypHeIaCh8jJ4RYxA5eCpij96/ZDZeTnyKMvN2k2cUhG
	 juLQnHGGMFIZQ==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 4/6] selftests/damon/drgn_dump_damon_status: dump probes
Date: Wed,  2 Sep 2026 07:03:10 -0700
Message-ID: <20260902140313.85983-5-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260902140313.85983-1-sj@kernel.org>
References: <20260902140313.85983-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 1DD6720005
X-Stat-Signature: zkry4fqkshsza3c3ycgruy6kzjisqkye
X-HE-Tag: 1788357819-121716
X-HE-Meta: U2FsdGVkX1/soxPLR6Fjw1P8pyAQI8LMqSX2wcRamprs4M7kv7/mO/zY91jq0QrWU6BXX4phlA9RGBremsPChbMnSEgZUnXkuOMTW+CA/Z6rcBoWQZsf4BtJxn9x395X88mxOTNdcG1QgVPgfHOJHWjv2hpvoicZV8P6bnj1qqC533+SKt4V09q+lzjkq324O1E0jG/j8oUWHeV/ox+KTS9cVNPMM46cROcxW6Rw30knxPFhlkAyidZvMXDpZb6IO4wrbDLkBjUuq4bzVUtE7WHnA/TAt7+zhcVzWXdFoX5YsiEDhLA3WJ8PQ4Wqx0as6bpY+qDbnIBQXJmZSlrCgkCJaZKODdHmhivBgOfDhcR1nYR7q9f7FrwnsgZjhUu5ilIG+DgQKaCeBsR22JOEs3VtjpGcXmrd48/TphrYG8f3eo1179ULJoDVolNGZ2cBo+7Ww6zvFGQyb8xgDN4rXCevKppyxZbbzqkOVhCaSkc9GqVq0U6i+196RGnYtWlp/b9B/AmTyvoUCI7BZVMqHeuzQL73OcuxsHOyiObqPaCBC5/CXAG90108niv3sxA2XCjmLSMon9FHj0JcwSD1wOYHJw82f+x2rPe3QcMVT1gbkMeXxkzYuj9dXe4kN8MlVlhR/cwgkkuIR2NoRI4akqh8tjQUCAM9Sq19xAbbRq6R20r+yXABFrc+TTiG9lv/E674exYiT5VEwGMmHuvJ2PAXLfoK0I37Il/z0MfPHBxW+0/QtZH3+OrWVmgKf/IJeVscNqkXnabsD959yOF5Tw1GnkueeJJIpG4h0vV5TUx6fGthyg0JwBNUAnkssXHdsWeG7GEiVRcI69nTWQ4Md+b76PfPjX65GuryjZhwp4PJyODSQZQqmObJdrdFbCOh49ppQkHOPfD7w5NiZMpTwUsKvA4FHPvyMbmjoh29CU3ybCyEyOoHAta8a/SKcI9DZDgdUx5v7jF7GDDa0JW
 D0/FVUTv
 B6oTXiyD5Dab1A3zyaKwEX4ujUNJWT/BOizs64strJku4FYQy8CjXOD+tnHjDCG+w1uu9rWv/Ss2eQbXOLtHwvQ+e5b+0zsiRknApnAHUyLhuliu2KwwDJFUOKC6lVoqM/deWPW0NlWQ+QyYWQGBJ7975A4TW/6HGubGd9LQE0AT7hC0wUE2nm/VydSJwSmF7ZZKGiu1EqwsQFCkCw43cyKN319RLvyb4a2AgjjQHu+t8+W55AP4lHXejy+/ufBjKg1DcEVDLPKOmBaZojS/TpxXFvA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Extend drgn_dump_damon_status.py to dump damon_ctx->probes.  It will be
used to see if in-kernel DAMON status are changed as the user sets the
probes via sysfs.

Signed-off-by: SJ Park <sj@kernel.org>
---
 .../selftests/damon/drgn_dump_damon_status.py | 32 +++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/tools/testing/selftests/damon/drgn_dump_damon_status.py b/tools/testing/selftests/damon/drgn_dump_damon_status.py
index 09552e91bc782..4622046fd0118 100755
--- a/tools/testing/selftests/damon/drgn_dump_damon_status.py
+++ b/tools/testing/selftests/damon/drgn_dump_damon_status.py
@@ -48,6 +48,37 @@ def attrs_to_dict(attrs):
         ['max_nr_regions', int],
         ])
 
+def filter_to_dict(damon_filter):
+    filter_type_keyword = {
+            0: 'anon',
+            1: 'memcg',
+            }
+    dict_ = {
+            'type': filter_type_keyword[int(damon_filter.type)],
+            'matching': bool(damon_filter.matching),
+            'allow': bool(damon_filter.allow),
+            }
+    type_ = dict_['type']
+    if type_ == 'memcg':
+        dict_['memcg_id'] = int(damon_filter.memcg_id)
+    return dict_
+
+def filters_to_list(filters):
+    return [filter_to_dict(f)
+            for f in list_for_each_entry(
+                'struct damon_filter', filters.address_of_(), 'list')]
+
+def probe_to_dict(probe):
+    return to_dict(probe, [
+        ['weight', int],
+        ['filters', filters_to_list],
+        ])
+
+def probes_to_list(probes):
+    return [probe_to_dict(p)
+            for p in list_for_each_entry(
+                'struct damon_probe', probes.address_of_(), 'list')]
+
 def addr_range_to_dict(addr_range):
     return to_dict(addr_range, [
         ['start', int],
@@ -199,6 +230,7 @@ def damon_ctx_to_dict(ctx):
     return to_dict(ctx, [
         ['ops', ops_to_dict],
         ['attrs', attrs_to_dict],
+        ['probes', probes_to_list],
         ['adaptive_targets', targets_to_list],
         ['schemes', schemes_to_list],
         ['pause', bool],
-- 
2.47.3

