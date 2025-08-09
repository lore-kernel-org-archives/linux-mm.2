Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D197C87FCB
	for <linux-mm@archiver.kernel.org>; Sat,  9 Aug 2025 13:08:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 692506B009D; Sat,  9 Aug 2025 09:08:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 669FB6B009E; Sat,  9 Aug 2025 09:08:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 558C06B009F; Sat,  9 Aug 2025 09:08:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 44FEC6B009D
	for <linux-mm@kvack.org>; Sat,  9 Aug 2025 09:08:15 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B4AFF1A018C
	for <linux-mm@kvack.org>; Sat,  9 Aug 2025 13:08:14 +0000 (UTC)
X-FDA: 83757247308.16.D0291D4
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	by imf18.hostedemail.com (Postfix) with ESMTP id CCCC51C0003
	for <linux-mm@kvack.org>; Sat,  9 Aug 2025 13:08:12 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=MacuteJL;
	spf=pass (imf18.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.210.177 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754744892;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=U5iH9iV5VsYBnBlg9QnKRLf9bBCyT3yBhK5kP+dnWFA=;
	b=IwlWoRtxlKg5UQRpZro27k0WRt8d1h+uUgWT5QIf/u0riCduFvj80LNu4TbF+hI+QU1928
	Xm4bErVND8Dtn3BOIo7BKTfNpmnL56JvdcqkFmShFWckm/43Zm2LvoVQydka3VodVmOFGX
	dXjV/SNpgVFCIMGpeDJoBJf2z4K1W3M=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754744892; a=rsa-sha256;
	cv=none;
	b=V0cA0+qEQ7Glh5UGEpyz3toitsYXzvmBuoGdefCqIYqDRKXRP7Ozjx9BI4xToYD4rW5mKD
	0tMnmyr4HH2Vvi0uhkhfpcnmbRdp0OAf7w6MB4Uf9pqKBwrywrMQUNfbiyUV0rT2ZTWdbk
	1nLEipOZNhL4+J9Y29XkMxWH485SB2U=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=MacuteJL;
	spf=pass (imf18.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.210.177 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-76bd2b11f80so2814826b3a.3
        for <linux-mm@kvack.org>; Sat, 09 Aug 2025 06:08:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754744891; x=1755349691; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=U5iH9iV5VsYBnBlg9QnKRLf9bBCyT3yBhK5kP+dnWFA=;
        b=MacuteJL+87B7valNO5zMrfaPw289dhZbfOUdD/pASNTtTcV2BP45P8KR22BhXAI2A
         nNyTpX8LK3/HvW86jqLTmHrSApYgG00GMfvIwHRMiglZ5LrIhLar7VKT8Ry9TMVtYwFt
         IgvNtTioyL1s7pWST2oixWW40zK8U3OuCjdrV6idt+tXTonls7AfuMPd4g6PiBdFHrbh
         ww8adqKEp86r9HXHacq8LGkJTqghESRlYC7nBvMwDN1k4Nn3gCPlVU3+F66tm6VNMZjc
         0VdWXnuRbzjEY2bq37aB1aRQM//yf9LGN77kIQmRgZmysfdR59bT1wtmyq+ca62Ti55R
         X6ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754744891; x=1755349691;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=U5iH9iV5VsYBnBlg9QnKRLf9bBCyT3yBhK5kP+dnWFA=;
        b=oFVAuYyTI+t1O/CYk/v/07l86fZeNYNJXL3/ZbCccXrq9i3vM/E2qSOvA0X/cboDlT
         mQLmqQdCcBEMdfRPNxfVxR0q9m8wsryEzTlFmV44ST4S8iC6d3bxspQAXLZ94yTk29hx
         r6lCcvfQ3YTSxJAgvauzA/ifDDiH2gIo7yS/ZJpyyBSUH/8FLq+ogY57+vnY3ifJqPbn
         GIVttcN057NcP1VCIy5OdHxKZ2+SfVEg/7Ulllq/o9M/Hfs8Q9pFXDGoiJv0gC4hdHSC
         Hrfrhw6fZmVfdpM5d49AY90AyaPa5RsTygPIfzucJrjf8RZ/++rXElhm+aTzaMY4/9Nf
         TiVw==
X-Forwarded-Encrypted: i=1; AJvYcCXrDH6mBzeNDGpqAPfaODBQRKuf3b+o/xTTJW06nXFlbLf0V7436VVn0bbvrXzf1uJYQdJqgKrGpg==@kvack.org
X-Gm-Message-State: AOJu0Yxr9IXR13DTfQ7GQi7m3NbUk9jTPReBICRKV67WOwOrjjGl+TPN
	tWYt8/JpIpAGcTjG80SwJ2BQlmhQxYkFSBGLbVFjeSwkDpy3O95R81a4
X-Gm-Gg: ASbGnctoSTSNpFS3tne5bA+MAe8MMGOj2+nC8C/CdplV/0958VBD/NgnYUZZFcfUYBG
	XGqE7jE3CbCGjZQZziVsPbSS++0rB67bUEavZRmVtVQEySvzje3RAeczxEwx0BEAlN5FY6+8jhX
	qdI/aP+cjkO6Xr96XHeWzz7fDdCd3e4vvSj3zniFPP+naCs2/+bhmzzQh/YMfChOLe2kt9nniYP
	cINChwx2dvj1ZxArBTEbBJ865wpElpQubCbReB05gcVTh9rhuFpJvNSIBwBUidPe2Em71o6JzRu
	tHORO31LK8y8hKEI/DYz1eg7koRQV7gKq+TmegqaC6m6axq+pMC+ESt7jC30SGt2TzyobPVoFi/
	ooPKxUt0Bc8cKyjOdzl5NtzCPyuM=
X-Google-Smtp-Source: AGHT+IH1ZRbmHfcbnjxqSE/cWx/E98HxIo+TMBcEPKIJ/oKES8p1wHfnek7BsNybm9elxKdvynFtTA==
X-Received: by 2002:a05:6a00:1389:b0:736:54c9:df2c with SMTP id d2e1a72fcca58-76c46111288mr9692926b3a.15.1754744891501;
        Sat, 09 Aug 2025 06:08:11 -0700 (PDT)
Received: from ubuntu.. ([110.9.142.4])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-76bccfd8d70sm22567165b3a.105.2025.08.09.06.08.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 Aug 2025 06:08:11 -0700 (PDT)
From: Sang-Heon Jeon <ekffu200098@gmail.com>
To: sj@kernel.org,
	honggyu.kim@sk.com
Cc: damon@lists.linux.dev,
	linux-mm@kvack.org,
	Sang-Heon Jeon <ekffu200098@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH v2] mm/damon/core: fix commit_ops_filters by using correct nth function
Date: Sat,  9 Aug 2025 22:07:56 +0900
Message-ID: <20250809130756.637304-1-ekffu200098@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: CCCC51C0003
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: 6h3pqkwkpenkyfiay55afpyhmcxx5mcb
X-HE-Tag: 1754744892-262141
X-HE-Meta: U2FsdGVkX1/ThWv2cK30zTdsoMBEssVy2GLshc3AR4j06402CY/J2rTqF+UTonXNrLUljpQQJPZA9KRLhLbmxc9tUZo1euT9U8I5GlrtfOBtblMhIJF+2JYslv39hU7DWqvNyNnEIziBP2OSMliu1gUEiAy/4YFzOKrZDUZ16GrE8OYC1Ht9Jsdgru7hWNrN8xpncm9+IGEPeMTsqaF5bg+Qvef2UVlEEYX2TtVvFsEntUm0y/DhL9I1RpkDdUWPvxLH4CcMPLnO0aLrDyj33hmFB3KQ/A0reqipBDvNsWRRijdx0fwlk1ZZ2kEpNbTEUjoSAxyf5imcZCXVYJu6RiOyUXFxQLYzvOJ2C5qxAlNDPUE3mk0qTGHtJT/bHkc3v+JBITKZinb7LppihsyVDXwc0T70cN8FTLlBNTg+rUNhcauIzEoYtQlQrjNHaSci+4gJTUOEURvObJIP20NRQehuniaoJEp4Tz/rNNSS5nl7eshmKB4qeyJXBM8U2qPV1fon8h/jXvQrVi7DGFTnpmzHMB1OvFwb13DOBQ4TvHLa5VW+zNJWo7okC8UHd7yqFPOhdEx960zHArKeaqKP9sKvN7Hq1bxv5iXwTd7Hd59+KvF02HgMY0J5o0ibBa1VGpIL//5jMcmEJUkIq8Bsl2ujqyjKhwYsqNI02D2hQbY0v3sQqQjNtXO6XGx6btW96RQR6EMXVu+VMIlgVrvkWvZDKuo8kX9UmP2U2N1pZSFi9wI64LjLel9X1Ab+yDtZ6ezK+YiZBkXVQfsHJOOdo2pi/WQOvVw9p77T1ldAWy3+OiO0Lc5HQ2P9RvkKjKvo4tWkChQfqkF8KRudiqYjjXw1Dn0rQ1bVBab2RxlAi1EGVLbVNlTtRHAauSODz5hrVjakfVE/GGj+9vgGAa023XPeMJjushdLkG8VQIuP5umJ0Hby1IpLGtgswyv90JMPTpJNy/yj8Z6qIHngehS
 +89PYvp8
 ogRo6ekEGoKcMhDP/pltfcgAn49VOQ5/S9kpfQaeY6jfnQzVAdS8pEydpYcysn3QQEEXRnZYOx7ew7XTsNuee8hFZIAHc1R/aGRnSjpPhEHll30PziiZGsKBP/uIymTNWSUxMw3To9VHwcjo4gm10Vw25dRj6WE21patFC2gnLqEsSHimRfyhL2DD+hk815a8mTHkDNOfCv81LM4A+NIanUYmKxUljLlnIHwfvdBqD0nAdWIWzy+vzRhrcXFirJEGkeMPt4OEd4kpCEUPRWSfuVpalFIsGN5MMTo+ciwmzFHtV9vLtCzFzHFZg7YjAXAdIESUHY/aKcK3xFd1opYKG6ncZJmAmfMxn6yXdV4Cz9BEzm3sTIQRPmgIsm0Ir8Q0Srj3DUx7lwvT5WdlZ9u6gwAtt59mRnIi88wPjC4+FcaQaY7iB6suxzeROYlK6NgeZ+HCJIOOBHkQ1OqjqCynodwjmZ9yzGFBdNIX
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damos_commit_ops_filters() incorrectly uses damos_nth_filter() which
iterates core_filters. As a result, performing a commit unintentionally
corrupts ops_filters.

Add damos_nth_ops_filter() which iterates ops_filters. Use this function
to fix issues caused by wrong iteration.

Also, add test to verify that modification is right way.

Fixes: 3607cc590f18 ("mm/damon/core: support committing ops_filters") # 6.15.x
Cc: stable@vger.kernel.org
Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
---
Changes from v1 [1]:
1. Fix code and commit message style.
2. Merge patch set into one patch.
3. Add fixes and cc section for backporting.

[1] https://lore.kernel.org/damon/20250808195518.563053-1-ekffu200098@gmail.com/

---
I tried to fix your all comments, but maybe i miss something. Then
please let me know; I'll fix it as soon as possible.

---
 mm/damon/core.c                               | 14 +++-
 tools/testing/selftests/damon/Makefile        |  1 +
 .../damon/sysfs_no_op_commit_break.py         | 72 +++++++++++++++++++
 3 files changed, 86 insertions(+), 1 deletion(-)
 create mode 100755 tools/testing/selftests/damon/sysfs_no_op_commit_break.py

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 883d791a10e5..19c8f01fc81a 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -862,6 +862,18 @@ static struct damos_filter *damos_nth_filter(int n, struct damos *s)
 	return NULL;
 }
 
+static struct damos_filter *damos_nth_ops_filter(int n, struct damos *s)
+{
+	struct damos_filter *filter;
+	int i = 0;
+
+	damos_for_each_ops_filter(filter, s) {
+		if (i++ == n)
+			return filter;
+	}
+	return NULL;
+}
+
 static void damos_commit_filter_arg(
 		struct damos_filter *dst, struct damos_filter *src)
 {
@@ -925,7 +937,7 @@ static int damos_commit_ops_filters(struct damos *dst, struct damos *src)
 	int i = 0, j = 0;
 
 	damos_for_each_ops_filter_safe(dst_filter, next, dst) {
-		src_filter = damos_nth_filter(i++, src);
+		src_filter = damos_nth_ops_filter(i++, src);
 		if (src_filter)
 			damos_commit_filter(dst_filter, src_filter);
 		else
diff --git a/tools/testing/selftests/damon/Makefile b/tools/testing/selftests/damon/Makefile
index 5b230deb19e8..44a4a819df55 100644
--- a/tools/testing/selftests/damon/Makefile
+++ b/tools/testing/selftests/damon/Makefile
@@ -17,6 +17,7 @@ TEST_PROGS += reclaim.sh lru_sort.sh
 TEST_PROGS += sysfs_update_removed_scheme_dir.sh
 TEST_PROGS += sysfs_update_schemes_tried_regions_hang.py
 TEST_PROGS += sysfs_memcg_path_leak.sh
+TEST_PROGS += sysfs_no_op_commit_break.py
 
 EXTRA_CLEAN = __pycache__
 
diff --git a/tools/testing/selftests/damon/sysfs_no_op_commit_break.py b/tools/testing/selftests/damon/sysfs_no_op_commit_break.py
new file mode 100755
index 000000000000..fbefb1c83045
--- /dev/null
+++ b/tools/testing/selftests/damon/sysfs_no_op_commit_break.py
@@ -0,0 +1,72 @@
+#!/usr/bin/env python3
+# SPDX-License-Identifier: GPL-2.0
+
+import json
+import os
+import subprocess
+import sys
+
+import _damon_sysfs
+
+def dump_damon_status_dict(pid):
+    try:
+        subprocess.check_output(['which', 'drgn'], stderr=subprocess.DEVNULL)
+    except:
+        return None, 'drgn not found'
+    file_dir = os.path.dirname(os.path.abspath(__file__))
+    dump_script = os.path.join(file_dir, 'drgn_dump_damon_status.py')
+    rc = subprocess.call(['drgn', dump_script, pid, 'damon_dump_output'],
+        stderr=subprocess.DEVNULL)
+
+    if rc != 0:
+        return None, f'drgn fail: return code({rc})'
+    try:
+        with open('damon_dump_output', 'r') as f:
+            return json.load(f), None
+    except Exception as e:
+        return None, 'json.load fail (%s)' % e
+
+def main():
+    kdamonds = _damon_sysfs.Kdamonds(
+        [_damon_sysfs.Kdamond(
+            contexts=[_damon_sysfs.DamonCtx(
+                schemes=[_damon_sysfs.Damos(
+                    ops_filters=[
+                        _damon_sysfs.DamosFilter(
+                            type_='anon',
+                            matching=True,
+                            allow=True,
+                        )
+                    ]
+                )],
+            )])]
+    )
+
+    err = kdamonds.start()
+    if err is not None:
+        print('kdamond start failed: %s' % err)
+        exit(1)
+
+    before_commit_status, err = \
+        dump_damon_status_dict(kdamonds.kdamonds[0].pid)
+    if err is not None:
+        print(err)
+        exit(1)
+
+    kdamonds.kdamonds[0].commit()
+
+    after_commit_status, err = \
+        dump_damon_status_dict(kdamonds.kdamonds[0].pid)
+    if err is not None:
+        print(err)
+        exit(1)
+
+    if before_commit_status != after_commit_status:
+        print(f'before: {json.dump(before_commit_status, indent=2)}')
+        print(f'after: {json.dump(after_commit_status, indent=2)}')
+        exit(1)
+
+    kdamonds.stop()
+
+if __name__ == '__main__':
+    main()
-- 
2.43.0


