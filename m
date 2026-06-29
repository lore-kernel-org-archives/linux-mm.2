Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D7B35C43638
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 14:48:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0FCE56B010E; Mon, 29 Jun 2026 10:48:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0D41E6B0110; Mon, 29 Jun 2026 10:48:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EB66C6B0113; Mon, 29 Jun 2026 10:48:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B674B6B010E
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 10:48:19 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 11A144011B
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 14:48:19 +0000 (UTC)
X-FDA: 84933230718.04.B099AAF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 69CFA140017
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 14:48:17 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jXkWB0xC;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782744497;
	b=2Ob798+UI1k7tm9aqsom7IVpKJeweX9fLHTqu1V1C+DWtOOmyvBfFG9JScb0Mwkm49P/j0
	Nqd3S8I2o2gULMlYRWT+AR4N8J9Ir5qXECDPj6WcloEb+ZBeR5bG+Kvg/4WjYUqWraH3mU
	THmue4aHEatwXVMqcbj/jJna0GIb77Y=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782744497;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Rgh/etwyJrwwwa/GAcWsO5WdxICD4nfXcQRavERHHxY=;
	b=cIO83jfIkkeG35WpfgvUdnUXBGwGRnNvkDLpZXw/xMfdS5xUmM8nNIIoKf55l459WeqegZ
	ImnerXQJ8e02kVD6YfxhN40qgYc4EYtt8GkBXGyQvwfMHMx6OQhvkMwWmtl9fx6SKoO+Rr
	avSWuFoWe+/SO7232fJ/HMRYR+uBnYg=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jXkWB0xC;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B27A14078D;
	Mon, 29 Jun 2026 14:48:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 561161F00A3E;
	Mon, 29 Jun 2026 14:48:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782744496;
	bh=Rgh/etwyJrwwwa/GAcWsO5WdxICD4nfXcQRavERHHxY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jXkWB0xC3cSzu+Z6WW/1irg/KU2cjpWLLGnPr07TWbBo25fkh8xNK6DyomKSngTQ9
	 vcLWLmQfs9DG40Xn9wGIaBHd+H+07ZDKRGjMm0gxbjq1QNBvorP1DbXDUeCTAb7ss0
	 zF7PXfeqinjJPqW68u2q5Gf9MdobGyPteJUYtBilRfd9U0f/nUEPOcUdDG1Adbjrxa
	 sXnfe+qVqDSFCELJXJ8uWuI/oIuYdgJZbnf/pNoHN4/AH6ZyGltY+3w9yBMn9lMje/
	 m7tE3rIqvHQPQmhpnbjOUZTnkOQ/6jHBrlYUFjNYHvXciBslJanTUmF5dhoatJhuiX
	 7J6ATfdtXNevA==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Cheng Nie <niecheng1@uniontech.com>,
	SJ Park <sj@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v5 2/2] selftests/damon/sysfs.py: validate memcg_path staging readback
Date: Mon, 29 Jun 2026 07:48:11 -0700
Message-ID: <20260629144812.134159-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260629144812.134159-1-sj@kernel.org>
References: <20260629144812.134159-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 4xb77sgu78whkeqxbbrbbgero8k6wun9
X-Rspam-User: 
X-Rspamd-Queue-Id: 69CFA140017
X-Rspamd-Server: rspam02
X-HE-Tag: 1782744497-36679
X-HE-Meta: U2FsdGVkX1+OhF1eIJgXRM4OiOUrKlJ6qQN5+uRYwhHNHpwbqhkPpvZ8Mhzc+tcUJ15s9/dRqoOUfcLhKVtVwQtF5kNnIVIQa802aTZ59bsY+1ZnMpv2s2s6Au2AhuKwBpqTLMWz6irNyfPRvx57Lu7YCaucPzvS2CdSOaTOXQ5XwXNGMQK6qJvscz1Q+4FZENpTG+LOxZHfT/uogaY2Q10h+8E23eoopCOD9FJ5cvpupu4nZiCExTeKtMmARJpI4yguN16Z96UPbfSoFvYzJRWiawXle286MUvxm7IjPYsQMLykJRAhR7NkkTiJL0lAOrQQPlpcDJffC0qxrwbpYlysD6RczBrMi+mWlNplgfstOTRDjDsAziPKtkOCoNM6IPGTE7mEvvaVhXfQWf1Ak9Bfw2ZmNNBYBY3ah8bUN5XH871Y0UYCuS+toBcTYXiUVDwxIjHfa1awEyBnXJXD2yUvr6U+TK6ClN7w1l2w3opqHYUW4DQI9yoqtcrVa8K+r8caEU+nkajMVHOqDe443pg5ltJOMp4txwRkfNIGh+iz7R/KecbWzhgl8v0fuvceI5WXJzJj2YeW0SzMAxDRH3AFYXZaV8iRluu4vSawSeMu73k2ggBRF8QkazLXhHaVZNxENrmzQZPovj/DO0w9dSVONpykE3XhN/HHkLBPGsUY5cTF/CSNTvPfu18qSng30vGIdQkRSL8k3P7Rcw2cjP7/Mf1V9IopL/PtmwsI7StaXvcY5A6ySlhiki7KfOtYJrZnEZLcrF8zsA4EdAtkp8yB6imF5OrecD0XH0OYkp2SYJzq+xoQiSGuznBoeWtsvPF2SvGA6Wbt5gFByAXFt84cie3JzICW90G+5BLO5sPZGGQ6sdZm71CyJ7ShDoiXf7d3aP9+7ZkI83Lf++eMyabo2AgsJgNwrYwKazz+TGOg1ogXoEazNBlufWSkqUN6arG1QyMJuNnWk0bgldp
 KMrSh6+j
 IlXacTcp7MypK2+UFZ3JgABO+3ia1z4LLXLBfbxExFxsl4hg8tE8DkTaSOM1bCpl/v65OgcyqOzz8SuurZPk+3LKeInuBJKdsYko833np5MaEgwfUWHcKfcTrf1NrjmZrrPIIjPaFlJseF0+iYELU72CDMOFFzwsEuox4e19ydYC3aV7J5M/WsVwZgNS90nywvgOOZzBBSbxvDdPKAt2y3kPc/hfsg8fBXwqFNg2GY08y11Pk+l76D7ueGx0QUBzuuhs5wXFWFb85ausStl4G57QnsNOpdmYlKblDOfvoTuC1zM1Zx3LT6ijImj0NmD2JUe7uNvHC1Shkux5dSR2r4/fC5A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Cheng Nie <niecheng1@uniontech.com>

Add a dedicated test at the end of main() that stages memcg_path via
sysfs and verifies its readback.  Configure the memcg filter before
start(), do not call commit(), and ignore start() failures so the test
does not depend on CONFIG_MEMCG or cgroup layout.  Call stop() for
cleanup without checking its return value.

Link: https://lore.kernel.org/D2B37130D38E09AC+20260601090634.241864-1-niecheng1@uniontech.com
Signed-off-by: Cheng Nie <niecheng1@uniontech.com>
Reviewed-by: SJ Park <sj@kernel.org>
Signed-off-by: SJ Park <sj@kernel.org>
---
 tools/testing/selftests/damon/sysfs.py | 31 ++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/tools/testing/selftests/damon/sysfs.py b/tools/testing/selftests/damon/sysfs.py
index 99412f0d31f37..3ffa054b63867 100755
--- a/tools/testing/selftests/damon/sysfs.py
+++ b/tools/testing/selftests/damon/sysfs.py
@@ -250,6 +250,35 @@ def assert_ctxs_committed(kdamonds):
             if ctx in ctxs_paused_for_dump:
                 ctx.pause = False
 
+def test_memcg_filter_memcg_path_staging():
+    global kdamonds
+    memcg_filter = _damon_sysfs.DamosFilter(
+            type_='memcg', matching=True, allow=True, memcg_path='/')
+    kdamonds = _damon_sysfs.Kdamonds(
+            [_damon_sysfs.Kdamond(
+                contexts=[_damon_sysfs.DamonCtx(
+                    targets=[_damon_sysfs.DamonTarget(pid=-1)],
+                    schemes=[_damon_sysfs.Damos(
+                        ops_filters=[memcg_filter])],
+                    )])])
+    kdamonds.start()
+
+    shown, rd_err = _damon_sysfs.read_file(
+            os.path.join(memcg_filter.sysfs_dir(), 'memcg_path'))
+    if rd_err is not None:
+        print('memcg_path staging: sysfs read (%s)' % rd_err)
+        kdamonds.stop()
+        exit(1)
+    if shown.rstrip('\n') != memcg_filter.memcg_path:
+        print('memcg_path staging: memcg_path readback '
+              '(shown=%s, expected=%s)' %
+              (shown.rstrip('\n'), memcg_filter.memcg_path))
+        kdamonds.stop()
+        exit(1)
+
+    kdamonds.stop()
+    kdamonds = None
+
 def main():
     global kdamonds
     kdamonds = _damon_sysfs.Kdamonds(
@@ -356,5 +385,7 @@ def main():
     assert_ctxs_committed(kdamonds)
     kdamonds.stop()
 
+    test_memcg_filter_memcg_path_staging()
+
 if __name__ == '__main__':
     main()
-- 
2.47.3

