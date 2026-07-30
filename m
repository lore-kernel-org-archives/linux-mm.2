Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 59EABC531D0
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 04:40:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 132D36B0096; Thu, 30 Jul 2026 00:40:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0480D6B0098; Thu, 30 Jul 2026 00:40:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E9FA36B0099; Thu, 30 Jul 2026 00:39:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BCB2F6B0096
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 00:39:59 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 557381208A2
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 04:39:59 +0000 (UTC)
X-FDA: 85044190518.15.BDDCEC2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id C1983C0002
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 04:39:57 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=C15s4Gyr;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785386397;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MtDpGEkDh7eFQBN1dloGGbcdOXn6qckrmCm8+BjUBow=;
	b=WOnFWd4bSfcovFCVdrh+lixEtUPmN0V9GauW7kwQauOMnYWrqsjFuH5qNQhMpeYgVtxjQo
	BqN+dXnsMRuV9QlZ/CsI4Dk7G63OJtGoIvN12i9rfDg9+vIz+da+Ul9CXnw3DEkty5IH33
	D5RE/9FyUltzXZFEnqlKWH40z6dSHBs=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=C15s4Gyr;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785386397;
	b=sXVZhytdeMSYWB7esyHvHfhg5TaK6RdJjzlRdSJ74QY295pSOaOW9ChjXjfYcAgCKuPEqH
	FC1hBhCXqn6GnLXzKB5iGC3u99STIeq2++4FFBQubg6XFmfMbbL1vdz/fFU+Zc2wm15sye
	DjRT74GvKRytVBPXNYxhg52j83fvzXc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 29B8F43D7E
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 04:39:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0A451F000E9;
	Thu, 30 Jul 2026 04:39:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785386397;
	bh=MtDpGEkDh7eFQBN1dloGGbcdOXn6qckrmCm8+BjUBow=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=C15s4GyrZLaZp5EvAou6ofPqODwYABlYCyBt7RTdsOQQC0sd0w/PZxIzr/5U0kkfa
	 CCb0w9WozQRJq8WWT0N3v4TjSK8QyXd9D/wdJ5zapv9KQq+pI97NWzLTrNsDLTL088
	 PEffDgnNSHONall4Zr80yuiUPyBbry4o35NlxGU9KsHRG3QFnELMkx67NgVxIjXdQc
	 W+fJQz4nEAN6P3QoWL0twr49PQFBS4aVlXWf8KiEPjk3ZQrm3Nv19jMxo/EoNgAGEd
	 ktJWgf/mctm4hgGzVxBpDe2F2kw/W4du1VweTELOqRq0Lvo1Uui4Qcmq5VTsRxmbz6
	 rBdmkSLrN2cow==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.1 4/6] selftests/damon/drgn_dump_damon_status: dump probes
Date: Wed, 29 Jul 2026 21:39:41 -0700
Message-ID: <20260730043944.146030-5-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260730043944.146030-1-sj@kernel.org>
References: <20260730043944.146030-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: C1983C0002
X-Stat-Signature: xfh4wmhxzbh4qsbzowamckxcuzdafw6n
X-HE-Tag: 1785386397-254479
X-HE-Meta: U2FsdGVkX1/wMM4lo4DohUlH7FBXdassj6RjZZJD08dIny4DMUOBf3IKuhmN39GfSn93g2nK2mjpLOFI/YmDudYAGh24pov26KiKp0949EsC/kPusugtaWOci9ci4goHanc8iTTgvjkYL6cnLd3joX0biJ/8sYT26mQtnm9lGUeXWw8++uG4kk8VxsFpHaXByucdVDBQ4HAGEegnXtMmPULp579UkoFlyhO0URvzIh7w+GNeLOgLqb7ikcrU0sJYmBavCMvtzrUrnaRNgRAyIgqfPpwfugoRzfwlL56UxV3PHyi0aD/bpRFO4d+C9jBgIPZaEHW7YkHUFe12247p3W3cShJz078XRWybj7TFuJotJ0O49Zd6SQcMTs/embCMXWlUInbNJaigJ8GrI1xj//WHTRzV0aN/stbGKRRn2WY7TXgC3TPYKx/MGK1nBtGcb9/ecxwnAFklRQsfciP9d/V6+SH0A8AeO8v/PPcVITqy7vQCYhedPTFlaDTIoRLTTK/3COgc4Ye7mzoAjTm12bmgizuxx/59bV8uSwdoN7ns6VMeyAd4vm9lTlqiZk50hCwKA3nXQzHr2tAttEf+P8+pudHzv5jRSi/zKoWLy/5Lz2d0EySSzoVDlvxUh/KQElNgcPpwhpR6JRIrkiiXBIAHKs7ln+T+HJjgaSc9I/lw8+IzX90AwqOyUhnVsoFCSiSWxXmpvCaAl2Z2+Sq0oaiYnsLSXkld2u3eGzDamClLRR8DnKE7crbqEouiBQlEIEKrddMT5escgySvnHf3LobJxaCkN5ZHtUPNFZSWBcG0GKz3cVJGC65tbjOnjnFqvsVFas+OdttCtZesc5l7t9oNhQn3gx7bWUAiJbR1gVwnzdnVsNO7anE9lTVpBX5blyTILjvuJYvL3syiuT6YJydfyYL8xtt/hKrgbCIdpbYZLvXORcuCKzNCna6ysw/iJNBALlqqnERaWr9cFsY
 fFen+Ewn
 JGEP+si0ItK0XIJ9v59yyCUIfIGT47hqFKdzCvbxnjW5rZjkJfk/dfXIerWCzpVDetlFtyzL3FgUXDx6GLlrZ4x/dk4J9lfAhNvr/jLNod76SOBbrN08+CEQC7UmjcdbkFOQT26bISvuOll64iqJuIpO9RQHRIXrmKpJhLqptlZWUuc7jG9gH78LCHZUNP2Mbx22y9ROomFU2wQ9D4HBP891KM516BGh/ti8yWivOLUoVeLPZT0xnh/UD8vbS1CALiz+1Dshy1TR/pwf/mEWZzz2gWGuDZhbJ5+WFgE+fEqaY+R7Uz5QqyjKGLX7aHdIkBFmnpRNAp8JTrNBrSMXxIfKmPgmrSi7Zl0jz
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

