Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 85C99C54F51
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 14:48:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9BC166B0112; Wed, 29 Jul 2026 10:47:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 924376B0113; Wed, 29 Jul 2026 10:47:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 799906B0115; Wed, 29 Jul 2026 10:47:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0AAA86B0112
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 10:47:47 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9403316071B
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 14:47:46 +0000 (UTC)
X-FDA: 85042093332.13.A3D800C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id 12B3A2000C
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 14:47:44 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fKYKFRM1;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785336465;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MtDpGEkDh7eFQBN1dloGGbcdOXn6qckrmCm8+BjUBow=;
	b=gRVrY1LcWlD764IpIh+i5rDFoDgFMvC1R0K3hg/55S1eE1nHpzvAalu+Oze9Jr1QxhkxHP
	oSsx4zznOLkTf9UCav2MiMbsYY3Qq92GC9aSIV2WspqFSTmTss6LPa0NnH0d8wXVKfF0TQ
	jlbh3e9/Ey71yTVSzzeBkAiOix6apIc=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fKYKFRM1;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785336465;
	b=Hp08+ETiu5BPYWMItxn7HpnWn6Oit2YUZJDLk8v1zKLHfbwSdTb6ei38xJxtpU1a23lwoT
	NNp8K7ipGwPaHCf86rfe5JvuQCUNWJOic/sZKae/o/LVM5bTX0oHb9uNfCPv28EBqxCq7c
	jPybHLjYk+dl/JqsRMI3QMB+EGBCDvQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A6A76600C8
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 14:47:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B20A1F00ADB;
	Wed, 29 Jul 2026 14:47:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785336464;
	bh=MtDpGEkDh7eFQBN1dloGGbcdOXn6qckrmCm8+BjUBow=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fKYKFRM1R/OCPGoBU0BaoGq5cV55Eouhc7kW5fvTzrjoeWnw8oGVfX+lv7uNM0mZx
	 myBMSUGwVzIeXaC/JNHrEzKyxK4zU7SX7y9ZIY+Qnc+pl705brcx9LdRU7kuim0A+9
	 MKvsuXs/1j1DkoIEkuIUYjhgTVxQAhFmxTziyPxA374uAbpu8v+89AD5XP7zOrz+Hi
	 z9OaJle3nahczWGdsxGqfpB84eqEvkXd3XCCKEQwzZu9fB8xWH4hRvMsK2FmYUa2Ne
	 DDh1AQP6GTWFWRWXeUN/fDrC6VKMwoXjYLd2Lvd7ilJBNNkb9N6jZ4ka0mwSelx9a+
	 E/Ev/kw7oFB0Q==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 4/6] selftests/damon/drgn_dump_damon_status: dump probes
Date: Wed, 29 Jul 2026 07:47:35 -0700
Message-ID: <20260729144738.90895-5-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260729144738.90895-1-sj@kernel.org>
References: <20260729144738.90895-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 12B3A2000C
X-Rspam-User: 
X-Stat-Signature: abx5qtt7d39jdphgpfw19ow4xpkw3ict
X-HE-Tag: 1785336464-135080
X-HE-Meta: U2FsdGVkX1+rIN/bP/p478KRVXFGWD8gM7Rkmu2r54CEHSHqgVi0vJa2AvdL71VYMOBHht0z+CNKEtzlE/bkOJfaMydCQiNrAeDCKfItngY83G9VmoTsjhNZeNt4jhcxRYRR8gIW8OPx/61d2YQeAOmmtfr1IP5FCNLsI2CdUay2f0KyVUzCI369xxCMtGszNyc+GCmSRmWY4Ah6fVUbvZE/0wscR0oCif7vdGZ5Sfhfph0kG+7F7dxn6IqumlgQTg55w/Y4lgMEcDsCZXvM4/+0SHhqwgSH+X1qG/4SJ1Mcbj/pWZBQAMYgNHWVKgqtkN5moCXZRT3/QBMjMKlNQXSzcrQkr5s5Xdze41V75aWMQOuof3cGKBp+30tuJ/hQgKKjo5xq8vJY/XgP1aTQlLadqbHl+55KbqiCDTkl+hwZglsKgEh97YQcZyAWpfaSvA87nngdMTkDtrdvxKX3FXS+95/0alh24X8MhWj8Nib3/k8d1wBcIjWf0hid8oJk8x0iN78h8WOpNZ0xCXR+8K7FKJxjeGbV63MlsTOtFabR0mQB9CJfQ8HAbgCjWi7RQJ/in5go0KXfsrHcpxJRuhrcoL8dum4WW47T5kcAwxfd11JpWPi60UDMjtNj3OZWwnEzemvxqkzYtbBNyz4x27QS6zRdsipKY4rrdxdzIMUSvRoUtFDmNS1m5GWVwfR/qHqbNaU7K+kvfhRoyZuJg+AGL8WGRSGH061p245x5FTPnzefMrURzAZiD72x93zWNjoLfXotsZVH/jxS3faISNFL6gRNKyB/L9SvOko+zb8e9Q9ft9326/wJoUaJ8+BtG7EMgh2ygS0YEaj9C/2qpuztSeS2cYm4BscBQ2wDB29BtS7NQ4ZQUcnZF4/AKqY6+iWOB4imjrbcM9+rS/nWXg2MS3CrxdHDsqgtnmH7qGvDcMf3e3deDGclILoIXHks/rscmUuyFxKli5LUFxR
 IHlymG0I
 ZIbitWktJkwDa5WLOWDGW7ooSbuw3SA4sQXx8r9qlk1T64fpdj4eadDT4AmzbVxqPaiXra8kFyQmIHYZZ2u1qCbiMz6kj45EkyZNZyOKyF5osjPYvdPkKqrUWV3R/r5Q+aZJKxp/ZvO+xDEgbIQhCOWzdpn1u4A5gaIdnjuiXEjy96nf30PC2pw3MTNYSCplGJQX1z6TLloOiVeZr+n9KBvU5qaT2REkIUs1FsQjkLL1/9nnWxjJRKUHH1YszJfgyoWDblC9eEL+oKaKm/iMnEF+VYw54sTf+krHo17Qh39lCh+TI/qrOk5Du3o//yanPr7NbwzwdtKDJdjJorgdWxhktYg==
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

