Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 68598C43602
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 14:47:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CE0BB6B0092; Mon, 29 Jun 2026 10:46:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CB7806B00AF; Mon, 29 Jun 2026 10:46:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BCD8F6B00B2; Mon, 29 Jun 2026 10:46:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 950CC6B0092
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 10:46:57 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 19350140147
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 14:46:57 +0000 (UTC)
X-FDA: 84933227274.02.61BA1DA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 805874000D
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 14:46:55 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Yu34g0+O;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782744415;
	b=N+vABuwc7CpMqg/3VKjs4CqAmJmlW1SVozA9YuVk6m4N+rO8LkmS7XkamPxQYVKYupAXiZ
	FzrI/k8OgC3ILEHjqXQs0nms0HZ/Emc2PNqimyFXq1r2AO5H5S3NsaZGYcpkUvziHU8LcH
	Ra+2t+ddDuwutgj3N2dTttKjBrHYllw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782744415;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IAWztPSYLWcu2Vd7sgQJGKVU9DMgq6cTa1utFOkkV6E=;
	b=dcF2KNi4cfY924VpsBFvlw5SYisdKTPJZSURqqUNYVy5NAn2izyKP6fvumzZyqN1FtwwVJ
	vH3hdc+l/VG8eET/WcHywypdnB26QrDi6tqu1w7lZI/hJmTIncX1t1Bvh1mNBnIi+0jFi8
	YlG4VMtqeBP7jMg+LPOGqREOuT3sO/U=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Yu34g0+O;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E4FD7600AF;
	Mon, 29 Jun 2026 14:46:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39F5E1F00A3A;
	Mon, 29 Jun 2026 14:46:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782744414;
	bh=IAWztPSYLWcu2Vd7sgQJGKVU9DMgq6cTa1utFOkkV6E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Yu34g0+OosmK290GgyuQb1/d+G7QsfzCMdSuy82Ac6MvAdJ6tY+Luhadc40ml1Dho
	 w7mr0d5yx+TpfmEVneKK/hzkuwQo+swcuiR5LhkD4RQhzfKYV3/PFLhTItGfXsS6iK
	 b7CLa5ntbalPZn8Hw3I8BwMotfs7bos0rBI1D9aU/OiZXhiGN5IbrTHM82D0nGJxbf
	 3vyzhnRZT5OxMXxoWtGFAnaoHOAWN1Jv+gAwUThK/09hg+AIgqWgMS4dK9mv9LhmIf
	 oISgPHSlw7DrbZLvnxcqew3RrisIRjf8u30pzAcj5iSx2nXRJViSo+LnKipKR9Ia//
	 6Obpd3/gNpPtw==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Kunwu Chan <chentao@kylinos.cn>,
	SJ Park <sj@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	Wang Lian <lianux.mm@gmail.com>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v3 1/3] selftests/damon: prevent cross-context state pollution in DamonCtx
Date: Mon, 29 Jun 2026 07:46:44 -0700
Message-ID: <20260629144648.134092-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260629144648.134092-1-sj@kernel.org>
References: <20260629144648.134092-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 805874000D
X-Rspam-User: 
X-Stat-Signature: obdeog4ownjrudrqg6fr6sp5qexzkxnn
X-HE-Tag: 1782744415-15028
X-HE-Meta: U2FsdGVkX1++HY/C6sGb3PlGOuYn8wY5riVKFKWP+1JhILMZMmwSnBx+UbUG00atOvPEc585Qzd4vka4mJT0f7A1uSNA8TCKn1DyTx5GIUI7jsXpXlFhbL0h2Z3nTvCzWcIFYqvy1kDEe7lZNw21SbldZ2PIjgRg9IcktrnwV+eFVe5WmKxfUSu8/6CIWYBjgfhLopdgCpawPL0oBdnDu1SKb3qoRynEPQ6n0lXMN+qGLuVZttgIoDjbK9M4jRDWLKJ46HFQXvOZdJCl2powtxg6PTBOsgV8c/LND3E+qk8D9gQpdMbVJjW3Q51jYSwRNVAvNSV3td/3qGZuayIKRZwgBzjDUGzrsnMxrnG+hiBN2msiV8NzIcrAoi0XixeNH2dZ+7SFa2NGqATQjuQKiJjNzCziz8tjv2fCdYOSYiNT4nRs6OvZPCA/agULsq+KdAPf5iLebtP5KnrRHX64FbkILkrr0W9vxeslTqhdkOx45p5fcVR1WyhsMeGIZodB1JhSPIGKFSDXnKQOqP5drTQh497zAsaXN/HcR+rKsMuM0tnw7J1nwnse2+rRlghT6H+KGGYvXn8h+Bfn+12mMBObvCjaPeTSYCetaNvcPJlLWHuAy/3eQvqF/1rnrLfi8BALzHO3iDHirQCahwEv33Lsgidwj+9/9JaHTX2Y4okGDSgB9UoaE/9IngpYpJyYYUi35rkPrPsHdbtrXScS/JyoTXr6MnK2pgYiLaGKkz3CxY6QVog4K486g2PePq3QROs9hFfUTGklXVKXjvnrYuR1gv0QqufvdCuP4GJ9afhDuFrK/v7IKogJjkddWhl/jhAXgNQijPut8YOQS3XRP3gU3DZvAnA/beXFGDdos1bQQy7Ix/0Mk9I3rE6XMBXuzif0Q8F3Ub/LGuxPOZHklsLwfEvmBkC6PJZ4jxbee4nPDgaIPIjCN2G5GRIVnMqYmxzv62vrjvaI+I71q2A
 D1D5odU4
 sBkdqwNQl2VINrJMwT0dJBi031WXZla9+QvdVlPhQTfOIrTC6bE4hIJFMKkhsg5dw3xJghdhZo49rm8Ua5Tt0E6cuyjVgUTsPyeIbUQpadieADJWRQ37pRLeTBtpyw4cnWE9LIrPXFFqr1wPDdU8e9eNGOMv0fLrFMOH0CtxIi124uDVsuY3WN3dKoTCq4fdQP/Vhzd6T+2JzWhH9vIj0N+j+Tof6FR2+5BsvMGfPNzPG9g86cScXYPVTXATc4q2+ROK0tWNnERROwP0D6xnj9IwDF/L9kD0OnFhoQZdLyK/91BryBN9bU8b701pVUM9UCmxx6JrAI64JKyc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kunwu Chan <chentao@kylinos.cn>

DamonCtx.__init__() uses mutable default values for
monitoring_attrs, targets, and schemes.  In Python these are
evaluated once at function definition time, so multiple
DamonCtx instances can unintentionally share the same lists
and DamonAttrs instance.

Replace the mutable defaults with None sentinels and
initialize the objects when needed.

Link: https://lore.kernel.org/20260601032314.424013-2-kunwu.chan@linux.dev
Co-developed-by: Wang Lian <lianux.mm@gmail.com>
Signed-off-by: Wang Lian <lianux.mm@gmail.com>
Signed-off-by: Kunwu Chan <chentao@kylinos.cn>
Reviewed-by: SJ Park <sj@kernel.org>
Cc: Kunwu Chan <chentao@kylinos.cn>
Cc: Wang Lian <lianux.mm@gmail.com>
Signed-off-by: SJ Park <sj@kernel.org>
---
 tools/testing/selftests/damon/_damon_sysfs.py | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/damon/_damon_sysfs.py b/tools/testing/selftests/damon/_damon_sysfs.py
index 8b12cc0484405..2f6f2699db256 100644
--- a/tools/testing/selftests/damon/_damon_sysfs.py
+++ b/tools/testing/selftests/damon/_damon_sysfs.py
@@ -624,17 +624,23 @@ class DamonCtx:
     pause = None
     idx = None
 
-    def __init__(self, ops='paddr', monitoring_attrs=DamonAttrs(), targets=[],
-            schemes=[], pause=False):
+    def __init__(self, ops='paddr', monitoring_attrs=None, targets=None,
+            schemes=None, pause=False):
         self.ops = ops
+        if monitoring_attrs is None:
+            monitoring_attrs = DamonAttrs()
         self.monitoring_attrs = monitoring_attrs
         self.monitoring_attrs.context = self
 
+        if targets is None:
+            targets = []
         self.targets = targets
         for idx, target in enumerate(self.targets):
             target.idx = idx
             target.context = self
 
+        if schemes is None:
+            schemes = []
         self.schemes = schemes
         for idx, scheme in enumerate(self.schemes):
             scheme.idx = idx
-- 
2.47.3

