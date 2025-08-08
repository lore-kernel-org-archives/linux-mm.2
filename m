Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B79DC87FCB
	for <linux-mm@archiver.kernel.org>; Fri,  8 Aug 2025 19:55:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C1F1F6B0099; Fri,  8 Aug 2025 15:55:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BF6D46B009A; Fri,  8 Aug 2025 15:55:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B0D486B009B; Fri,  8 Aug 2025 15:55:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 94C946B0099
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 15:55:56 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 47BEF115E83
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 19:55:56 +0000 (UTC)
X-FDA: 83754645912.15.80300E4
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	by imf14.hostedemail.com (Postfix) with ESMTP id 48F90100007
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 19:55:54 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Dl0lZn4N;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf14.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.210.175 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754682954; a=rsa-sha256;
	cv=none;
	b=QJzqDLhL2nYDEWKN2DaWZrch+jB5UdfnIjK81na9GdxXdJQliiJslkfDYwsai5Df2xqS2p
	91f47xKVIK2v+ryc3Cu3lnvK/iQ3Wpsk9IvCqDph4STYq0W3VxCr1JFJXFarDgTQ1y0Luu
	Duvk4lkqScwT5SgAVZLq917MAJH5k84=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Dl0lZn4N;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf14.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.210.175 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754682954;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=a7vLxCVUxl0MmGqdQtyLA8BfN4dqum9VMza52NtDYMw=;
	b=WrH/6k1+2LuIPAJ1iqGhMLWeWxY3DdPOz0w/H6btuaM1/p9BSX+0ccIleXoKlo1WFa13vh
	BR0rgfcSM+DQJv3fTTabcVPICYSX+G+ot0eNH+l/hd6O+4+N86tTYW6eAhe81FuujMfJbI
	N9/UWyZrtb0JvN265DLSGcPvqq6mAXA=
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-76aea119891so3675090b3a.1
        for <linux-mm@kvack.org>; Fri, 08 Aug 2025 12:55:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754682953; x=1755287753; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=a7vLxCVUxl0MmGqdQtyLA8BfN4dqum9VMza52NtDYMw=;
        b=Dl0lZn4No0JvJHSZqwesQlM2va9GH1P2eNblgwrF0oqh+o2jkP5zd7xZ3RJbDqQyE8
         RamfZPGmx/zuEHJCQkoH3UuseFlCDycMJYCns+tyICwv26Sl12FEx76R0tkWquQ4Lz5O
         KnRJsH2S79JvhS91b7c6cFq7lqibhdSgTnxwi+7T5uTqNw7ZV03TJgEcXkjvl8480DWg
         NxojtTkp60CQkeFemmtggTJWbWvHT09bhN7ZeXds8JAoQvguXmt/crjCCkAAydZ68jom
         CZsD16BmkkxdTufJb7IfJvmswb7hHrCeA+3cmCKAwjSt2CpLAjas7ke5reI6axB5CMwT
         w7UA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754682953; x=1755287753;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=a7vLxCVUxl0MmGqdQtyLA8BfN4dqum9VMza52NtDYMw=;
        b=FK06L3PEvQPcbAKV4RnDEVxKKaVaH0f1k+yzNEAj9sHuJoL91FbSxYkJynp4NT6f6w
         6LKEeHpoUFZij9e3H1x7v7qazxz849QZsJAMsnlACQZg3vnOk54OirQasPeGsrffr+Y1
         Ah+KmDqmPhAufL52SG+OJeMaGHRtY3cWRugLhoLFSYZ5JFz7msWOkigr3XnpAjP0WlUd
         jI6NwZc0HOOTURAMYa6hQXQ4fDDknZSVu3T3mMuYK2jTeXH5VC6Gw7jVj8VpwiH4Tdtb
         ZgoLAlRghYcHxh32tRzpjDSbMr6gwbghLCLkWxVHvhOKGXGwT2wN13wIbdWPGzVfk6cj
         cwOA==
X-Forwarded-Encrypted: i=1; AJvYcCUaFbG/w2jZ/QnFOAsAHUx5LKdrS3ixF+TyMRvMCj8PHtbj7fb4xZPgoqzzjndNqWd9pvtOR0wlsw==@kvack.org
X-Gm-Message-State: AOJu0YyZ5IuUGn8ywj7LJ5KN7dQ7xS2V913WyfQxG2Da4/h6iMrUKP4i
	WFhkiwOsOPM3fry7QpqoQqxNPR4C5uts15s0Qz9RHhpa0J/jvp6GbZ+8
X-Gm-Gg: ASbGnct1CugKhN+T9ilG/3IwlzsglkR9B4UVWErYB+TSgLWnUJkwa58NcMn6epFLPwY
	IHkb8MNODPI3Pal6X9MFqMtZHLBIwqbc/c6DChjjWfke82A/Y7G5FFDKZtkLSck79tlXk65ubOc
	ielGlnswJtJfOFADwj8sS9Xvd+EFvABe4qxgHE9tphSwlTldxbzK3ZUEbkBItA9MqVLdIGlLHrT
	ciAlPl25DJwYKXS7TciGoL3sw9TpVchKkKuBBeNsiP/PyzfbdrO6S9CX2oZ7pdiQNTOcxMYAwSC
	8IWNRPrn0KynYUahnmkUy9sdFUpYpV2UsmomZyO/4op7mOTxdETUL7PlEt2HfeAtnSUXCyZpXil
	3HnyGoA7cqOcFKdQd
X-Google-Smtp-Source: AGHT+IFvgJAy77kGnbT3cdwDVClhvfLI833n7irAibiQmz4OyK+ScQ5l1PmRRVtI6B/sOkH/p7c6MA==
X-Received: by 2002:a05:6a20:5491:b0:222:ca3f:199 with SMTP id adf61e73a8af0-240556ba06dmr7025722637.18.1754682953116;
        Fri, 08 Aug 2025 12:55:53 -0700 (PDT)
Received: from ubuntu.. ([110.9.142.4])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-76bcce8f911sm21201103b3a.47.2025.08.08.12.55.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Aug 2025 12:55:52 -0700 (PDT)
From: Sang-Heon Jeon <ekffu200098@gmail.com>
To: sj@kernel.org,
	honggyu.kim@sk.com
Cc: damon@lists.linux.dev,
	linux-mm@kvack.org,
	Sang-Heon Jeon <ekffu200098@gmail.com>
Subject: [PATCH 1/2] selftests/damon: test no-op commit broke DAMON status
Date: Sat,  9 Aug 2025 04:55:17 +0900
Message-ID: <20250808195518.563053-2-ekffu200098@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250808195518.563053-1-ekffu200098@gmail.com>
References: <20250808195518.563053-1-ekffu200098@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 48F90100007
X-Stat-Signature: y9di7wf9br9oeoz5udj48o33q5ix8h1c
X-Rspam-User: 
X-HE-Tag: 1754682954-819819
X-HE-Meta: U2FsdGVkX1++rrY4gOGbd3omY1QPUHfP6WYW88hvgh+FcdidMVXMi5LcbvTwHYSFM8Hn565t4vqaQfHKAIXFmiOY07uaV9nNLVYE/qmUnQI0Q/5PkHqPuucNQ3Br1Fgny0XP2O463BB7TZ6ummK8tIQurKjEBlyA9ugETBZcNFKL/NzIyLa6yuzR44j6t+BEGUVSDgU+Xf/eH/6PHn3UgiF5V1hA0zqZd967m+4M4m6mq/Zj5R6Y+unpzi0UBpaSnZSiXlp/BFx+5AWQoRufhNs5ws1S9tRrM8aMqO1nKWtUgExWVahdHDNaHT6QM09aD2nRNyOnT+EvzEkSd684NCGXgDfMUHgFZtdEhDrGMbFFVevUQBrW3VzNbYiipjhCy/+kstwBtThF41KV4KGJ17eQwpYeATUf4Fg0B1tixnIH/bGwwyEr4SJYlCo24qduz7+ZNX+FQoX4aR1vemNM1Wb0QCm+LHSAukMNQ+iBmf6STGEpF8ypgjYLcqSSjQt9Kq/p6hGUvjWLQkSXxH9qqbx2o2eMY9Cn6KJKayuIFPy5djvAhIU+bHogAcdkrVSoaPPif68Z6KmNZI4MPUrcHzExRR/kD7Phi0uiELD6H0Qga/TJWGrGWuSYALrAHx5IsasUZ2JUqjBIq2CEMO6FJIrpNsyHmS5Ys1HBm23afPiPGARBTA/u69mgs5cFceVKoOJGiy7Yki6JB9kd2ewouKL9KTwmcks0Kwg8pbSB7kvfd14lPhz6fs9YGIl6hGVByISO5XRoCeOrnIaxDRDfm4rkmTYTw2kFy1vmK2ZFD6Hxk2PXxW+3J/NTOR8TZcc2FrY0v40oaNmUQdpdl6+AY7QCyjeXc1XD+wL0g+acQh3/rpTVYyo8H5re8Da2X/HlYtf90vZlEqNFgkuXo4k+e1+5s0rS23QwUYCUHfacLCgejX4dXm631OEN22SJykAjEuWfV0nGmBIXbDrWOHA
 O2OCXlES
 19qgHwO88IDjuQCaML6/ENAB6LitM5QOUdogLWWKiDVCQ+nUe/NMGsxLilSflOErMdTa6iGoTbJrLMTnzrvIk2KVsqXxhKSQ306NdtbYz8kD0eDToyudmwvhNiGhvKryGcHjTz7sFarh7KKv/N2n6VB8qoSi34fDMBnlmmMBi81MahRuRW2Z8vaVdgyS7TqUeWfIspCjQmc8Q+qW6l0fjyej1dycwNVQ671UcPzXhX/Bxij9p8AIoYx5Af+E4wMtoYwyMO0uiXFauqW7x2qBkhqQYs2qu36LCoh/vRLomvRUZHtEIVTBYidfwTGMWnWBREfN4eWgGB7FX3a5HeaH0qJ3HXomJtCNf5GVRNR2abp6jD+SQOCLdbump1Yj5ruETzmBS6FwYl5Fd3hGyHBWFhHLHFQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add test to verify that DAMON status is not changed after a no-op
commit. Currently, it is failing. but after fix the bug it should be
success.

Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
---
 tools/testing/selftests/damon/Makefile        |  1 +
 .../damon/sysfs_no_op_commit_break.py         | 78 +++++++++++++++++++
 2 files changed, 79 insertions(+)
 create mode 100755 tools/testing/selftests/damon/sysfs_no_op_commit_break.py

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
index 000000000000..300cdbaa7eda
--- /dev/null
+++ b/tools/testing/selftests/damon/sysfs_no_op_commit_break.py
@@ -0,0 +1,78 @@
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
+        return None, f'drgn fail : return code({rc})'
+    try:
+        with open('damon_dump_output', 'r') as f:
+            return json.load(f), None
+    except Exception as e:
+        return None, 'json.load fail (%s)' % e
+
+def main():
+    # We can extend this test to change only the Given and reuse the When/Then.
+
+    # Given : setup filter with allow = True
+    proc = subprocess.Popen(['sleep', '10'])
+    kdamonds = _damon_sysfs.Kdamonds(
+        [_damon_sysfs.Kdamond(
+            contexts=[_damon_sysfs.DamonCtx(
+                targets=[_damon_sysfs.DamonTarget(pid=proc.pid)],
+                schemes=[_damon_sysfs.Damos(
+                    ops_filters=[
+                        _damon_sysfs.DamosFilter(type_='anon', matching=True, allow=True)
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
+    before_commit_status, err = dump_damon_status_dict(kdamonds.kdamonds[0].pid)
+    if err is not None:
+        print(err)
+        exit(1)
+
+    # When : No-op commit, it should not break anything
+    kdamonds.kdamonds[0].commit()
+
+    # Then : Check value with drgn
+    after_commit_status, err = dump_damon_status_dict(kdamonds.kdamonds[0].pid)
+    if err is not None:
+        print(err)
+        exit(1)
+
+    before_commit_dump = json.dumps(before_commit_status, sort_keys=True, indent=2)
+    after_commit_dump = json.dumps(after_commit_status, sort_keys=True, indent=2)
+    if before_commit_dump != after_commit_dump:
+        print("[TEST FAILED] : no-op commit break damon status")
+        print("===== before_commit =====")
+        print(before_commit_dump)
+        print("===== after_commit =====")
+        print(after_commit_dump)
+        exit(1)
+
+    kdamonds.stop()
+
+if __name__ == '__main__':
+    main()
-- 
2.43.0


