Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 96630C624D3
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 14:04:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 430316B00B5; Wed,  2 Sep 2026 10:03:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 407BF6B00B6; Wed,  2 Sep 2026 10:03:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F7F46B00B7; Wed,  2 Sep 2026 10:03:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 098C26B00B5
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 10:03:43 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9C9A08020D
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 14:03:42 +0000 (UTC)
X-FDA: 85168990284.18.A7EE986
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 055F6160010
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 14:03:40 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RgwqaSXI;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788357821;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PRRcJRQPR3buBmMaDcVwulWeVM6qSbo735r2+CfQnW4=;
	b=F4KDYrcEIZ7WkjbLywPzGwtBErOD273SRn8N1x8zGJZybO87Ai2AbPbhvd17ht20Qgue90
	TvbUGhL2EBpCYTVZaSwEANSDjjktRyZ8EX02R+Xq8H9c4fWjdnBNkvfUccvwJB73e9bLsS
	HnnlhbGhcF9n+5lGKGw/xgbjwDORFVU=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RgwqaSXI;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788357821;
	b=AVRs5nQtjZQjvPcdcRYMcr5LBiq+9BXlaTvbyeFg2t51uBgJmaG0TNUsAfvxeSkkCN4Y1h
	H4ywuMi6WD1rSzykKfoD88Ioo24oXXHTr/TusGrvFlGEf6OYTPTDXikM8iKT0z0OnVuRuL
	8GtqoVtVatziPmPQmkWhJC3U4bMXalo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 43C1D43F25;
	Wed,  2 Sep 2026 14:03:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5C021F00A3D;
	Wed,  2 Sep 2026 14:03:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788357820;
	bh=PRRcJRQPR3buBmMaDcVwulWeVM6qSbo735r2+CfQnW4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RgwqaSXIkQEz1vhxnOdulppt/3ZaMvLIuJSzXNSWE/ZfH967bovgdPQb/0nZnVAG4
	 cfTdVa1PDTrmh1cSX7ZjjiPQ0096HP07TeGLh8/ly6NFcy2N9q/AvlV3H4i7UvVfon
	 /AWvQwkrn+fNg2fSDniyehiKIXpdKiPrpcQ0hQx1FbRcX1ArfliGyazuyQSJXOTbXF
	 I2xcXb3UYH3FGJ7TzxEXEmR3za8dhbaNTrdZYs+E8K/J3OQ1x/nDd84LdqGtOMJM7I
	 BZLtNaIb0ArjuSoJx4HbPtj9H3KG3iyHU4ZC/oWaVz03bmklD+zoMWSVjOGmDAUoFu
	 +27Dy6+sQ87vw==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 6/6] selftests/damon/sysfs.py: test damon probes
Date: Wed,  2 Sep 2026 07:03:12 -0700
Message-ID: <20260902140313.85983-7-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260902140313.85983-1-sj@kernel.org>
References: <20260902140313.85983-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 055F6160010
X-Stat-Signature: qo4zbcmezrsax16yxrpusjos7goqwzmw
X-Rspam-User: 
X-HE-Tag: 1788357820-782109
X-HE-Meta: U2FsdGVkX1/MzSyhdqHMwBI26V5wclgY8ZmTmobGjCPO+h8w7QnO2VLLGoZSpcM200NfMhETAgx0+OsoLYNaTV/Q+n4d2k6SuP7uWHG9P/MMS2o7F41yfjL6yRt12FBJqlfKjshfZgVdtuy8+Q3QKJa7v9Y7clPpLfdJqy8vuyZyEEl9ddCGzn4XrDW6Db17JynWfUfRDbArXLs+IC9N5YmNOyrc4eCF1NO9ij+BGUyFaBo6owvlPStPni9TszY0+3bdypSCGKU4HpUsW5KmKc3yjTJTYabAhTicZyZDc+VmO8yfCj9JEl2ypd8oLHtG4yR+gxoNAeuhrEEoTN4+JCJQ2XruMl52v5aCILem0YJAmB3B3pBA13IWcqTJozhS3xFv37IEQyIMrmLNL/Mrwt0uFTyYI0lZDfxh+trGZKoxuXyafHr58MW78kmZr1U76Xrl6AH0td23auxIU9zukXqANkglPXf1UECI4DPKlFRvBQzUFI1yxdG99r7ifz3bztwX/PKxqhHr1Z93koD+ugkWk4C1VL1CtWwQReSZxkdO6lyT+hZcKum4jj3B+pCOm5uNlUA95T9uOxpAsdWf5YgmnWNS0YxMhnPj85qZaWkSW9eWBpXgkYcDvd7FlNxXCAYqYoAM8+fVBWgNlEER3jcAi1XEYrGrkizV46C8hkUgSKx0y0rYwxV2JatzdXGgKoinHKVGYdBMaMF2P8kMUoFN5W/fsmQiQix07c38DK1erwUAiLSg/0b4Kc5T0NLk5juFAzl109djNQLhP0lgCI56iKSDQBjPs8HxCdpkFulsHSxlKMxK6r+2GkU9W3l33atA+tmfp29/qMaw3i6DFqkoAxILsTr8Ud7usNz0V81x/2uVedeeUenHiMMjDs4lDLzfmvQJN2pz32yMSBYHBcB8CF5hpJ4BgR7oYrBxrTNua3sREdNHmSVYSqnIt9WIATOGWQdJ/T8x15Dhw9C
 i9exJdUX
 ZcKGcppNMBP1A3fPUbDQKFCmwPhN2vXQ5G8GeqZx0Eh8egRDp5FMpqv/fgGlJtnvp5xUe5yAufUFIi0eTh7T2V+4d7BlrGng0WmYr1eJQBzEJZy9+58TpjYAYD855qojmjhGjMYhh1+26HFm+y4S8cpctwXrtBRX6EIBxUUrfNgEe4RsGyx/kuvg1yJORNIKXQ1zdCSj/Vx8uIq29WEJSjlLYjHO5jOpeCsReOxioA8lTKPk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Extend sysfs.py to commit DAMON probes via sysfs, and see if it changed
in-kernel DAMON status as expected using drgn.

Signed-off-by: SJ Park <sj@kernel.org>
---
 tools/testing/selftests/damon/sysfs.py | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/damon/sysfs.py b/tools/testing/selftests/damon/sysfs.py
index 159cbeac067f8..66c826189320d 100755
--- a/tools/testing/selftests/damon/sysfs.py
+++ b/tools/testing/selftests/damon/sysfs.py
@@ -319,7 +319,21 @@ def main():
                 intervals_goal=_damon_sysfs.IntervalsGoal(
                     access_bp=400, aggrs=3, min_sample_us=5000,
                     max_sample_us=10000000),
-                update_us=2000000),
+                update_us=2000000,
+                probes=_damon_sysfs.DamonProbes(
+                    probes=[_damon_sysfs.DamonProbe(
+                        weight=42,
+                        filters=_damon_sysfs.DamonFilters(
+                            filters=[
+                                _damon_sysfs.DamonFilter(
+                                    type_='anon',
+                                    matching=True,
+                                    allow=True,
+                                    ),
+                                ]),
+                            ),
+                            ]),
+                    ),
             schemes=[_damon_sysfs.Damos(
                 action='pageout',
                 access_pattern=_damon_sysfs.DamosAccessPattern(
-- 
2.47.3

