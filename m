Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC304C87FCF
	for <linux-mm@archiver.kernel.org>; Sun, 10 Aug 2025 12:44:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2FD2B6B00A5; Sun, 10 Aug 2025 08:44:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 286E26B00A6; Sun, 10 Aug 2025 08:44:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 14F106B00A7; Sun, 10 Aug 2025 08:44:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id ED2F86B00A5
	for <linux-mm@kvack.org>; Sun, 10 Aug 2025 08:44:34 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B66F0160452
	for <linux-mm@kvack.org>; Sun, 10 Aug 2025 12:44:34 +0000 (UTC)
X-FDA: 83760816468.18.18A42FD
Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com [209.85.215.173])
	by imf20.hostedemail.com (Postfix) with ESMTP id 000981C0003
	for <linux-mm@kvack.org>; Sun, 10 Aug 2025 12:44:32 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="LCtez/AR";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf20.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.215.173 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754829873; a=rsa-sha256;
	cv=none;
	b=lNwWQgSfEzIlx4FK1x0ucqBL5gkc0V3LQgT6o300/WeM5KNn3ZMRvZXmjKUhoxxDaZV/SV
	ocU12bl+F+qmTJ56uwkh9bhrfG+k5g/UH6rhlN2CmJJs9EASiBuFWxOzxzZ1YxHYAz6iCx
	VjQ5ALW+JfDGbCZgVSV3YQ+GH1ESBMI=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="LCtez/AR";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf20.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.215.173 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754829873;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=FfOrnWM3dz1xxRzfbBuR+it2dfZAAWRE207h/Loxxew=;
	b=s+qbIcZsD47mfwBCoFdy5UYQGnhykK6adL43BYn6TU1YKr2rwc77bvJEXCcSYVEl9JdxpC
	hKO+/+cYkrMgWElGLh/Dw6YQM3b+gd+VDJXZncmAJbHT2nOSta28bbIZWeswdi0E6BYC07
	vI5NsA9j40aRU70LQ9Rj50mHnKecPuI=
Received: by mail-pg1-f173.google.com with SMTP id 41be03b00d2f7-b3f80661991so3224959a12.0
        for <linux-mm@kvack.org>; Sun, 10 Aug 2025 05:44:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754829872; x=1755434672; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=FfOrnWM3dz1xxRzfbBuR+it2dfZAAWRE207h/Loxxew=;
        b=LCtez/AR7lCdG8TkHkrH8oB4oRunChnWh8mYW24nqD6eFZ/7XiXMz9GH6jvl6Co2tI
         urT42YOJSILhvrgaUSCiNzujJMb9xQLWrKV/wfeackvOOhNmEu31rx9+5yyH3SB+lU/f
         3dM6fAPD2tLMYlJ5VQWXMPLNO3RhqjHmHSwYzmm2xqn83OE04uiWN/NIewv2nyWfckt2
         HnghmnHWuAmHMVC4U7THOUlT2INGw0xe6wVzs0+7KwHJbWxOjTOz0wqbflVXPy+Rjx1f
         N6W+GIplALZQt0RkYlqSPi/By/pJy6KGrxtbzXlJ5JbkaZOi+Ir2QqxjY5AAU/XjAcOA
         x9og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754829872; x=1755434672;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FfOrnWM3dz1xxRzfbBuR+it2dfZAAWRE207h/Loxxew=;
        b=ucM7/c3I41/+Y/UCrvA+oKOsiGttnM2DMo+NY8af89JEd8KthbGWsk7isbSMLPThCt
         ckJ+6TNpPZCl2ctuD7eET5tXmEN+49dZ7TZ6vqKQEvVcxUQGYzEgAfAZROKbarg2Kfz7
         Z4phj3Z9Gg7TzkSgFuMXfySyCDpfQFLr/0A7aABC5gSJ3wzDsrQ2PLUBfLqJNY7Dz51H
         zM+URPStX2zyqoAhJIDDAkLq2m2SQQRBqNeFuw/PjImBh9SBphaXA+SD7KooV4zrFlMP
         Kxoqyx4XA6Eg2b90GrdNekfg0C1iK13YNbhuDkegzjrUF38dKSba092f++Ib4Xmfr83x
         h52Q==
X-Forwarded-Encrypted: i=1; AJvYcCVg/QrtRDDnOG9KRWqMlnV0brg5GbnL5XeHodPdRHJPmIbtkXcaNv9hqWeEFUHLn2jwML9cH3+OZA==@kvack.org
X-Gm-Message-State: AOJu0YzMSJPG26sBVcB1nfmFziA3Bkv/N1EuDulxoTCjny0QZtJNgjNG
	yBIEhrDIj+qRphgxKOmlmZj2lOtmtGuQ52Kf2DaIvEl1CgBcMx+cFr2F
X-Gm-Gg: ASbGncvCliuCgm3IpZcG1Y+q5Vpf/geK11oMdDr5kfMIK/XDGqSKK3UeSNags4bXvjQ
	tJMWkx5seoDfbN/Rx3SmrnjMdZ+nYFpEWXdF4OM10Lw5vnFmEmpEvXnK2k9lWpkvZiV2AQR03AL
	vKVWcqqYa6DyeYVhb8nOyFjtSEfkMmxL4+6dqseGsI064k93ibZZCRl3ceH8n9HwwK2jfJRojat
	6LFn3CxVxoIAqlqGqeZlQWiXVXcU/l6TX6ZvsyXzZxmKa+P95jH34nCD6MVGxSCI9YcubLcd6Z7
	dFSt1dK9S4qmAuSdEOvNjRBt+W/bdnkhEnwLyokK/vKrpKZTkve8zBsT9QwtibCDLpBBrdeCh0Z
	4kHOYhkRJdsAATmcEnb5dRygcY80=
X-Google-Smtp-Source: AGHT+IHlnrDzNUlEjaspG6Ocwq4Tq6JJYSITlJZZRbXdmm5CCglSMHWLfgj2UX0ke4KZ9xBvqmGShQ==
X-Received: by 2002:a17:903:2ec4:b0:23f:c760:fe02 with SMTP id d9443c01a7336-242b0620e7amr206206465ad.9.1754829871651;
        Sun, 10 Aug 2025 05:44:31 -0700 (PDT)
Received: from ubuntu.. ([110.9.142.4])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-241d1f101e1sm248908915ad.58.2025.08.10.05.44.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 Aug 2025 05:44:31 -0700 (PDT)
From: Sang-Heon Jeon <ekffu200098@gmail.com>
To: sj@kernel.org,
	honggyu.kim@sk.com
Cc: damon@lists.linux.dev,
	linux-mm@kvack.org,
	Sang-Heon Jeon <ekffu200098@gmail.com>
Subject: [PATCH v3] selftests/damon: test no-op commit broke DAMON status
Date: Sun, 10 Aug 2025 21:43:54 +0900
Message-ID: <20250810124354.16456-1-ekffu200098@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 000981C0003
X-Stat-Signature: gccrfegcszh1eu49qg687whez3pi1gok
X-Rspam-User: 
X-HE-Tag: 1754829872-526202
X-HE-Meta: U2FsdGVkX186zFeaiEHg1FWCvFdLNl7W6fnmIcAAFg/Q2U+iXj2wn5PFQ00Rc4dkmiKGxajf7S4YgC4SKRP77Zef90fC+26COJ1fala563AsnWAlrybgS+ZlRxJ9kCgz7Ew6CGNyvZEINOuLVa1dc/dxU5P4gcqVZCq6deCjxA/l+YYqMipz2OSMHegUmnH1BI3dDYucY3IhpyE/yrBDzMCzulw2LcHIdXb+n6q7IOzkDMrubA0L976gx3ZH86psNFw3uZNOwfTFxuprt1FYTgfVShY1d/k+UIi97VDfaXe3np11A4oquAMidalnIqo/FOeTZAYNSP3ZRgPuJJaUWJFgP3PWjd33Rcq0rfYzdUNKadB9sjOS7/ofoQql57dlKLKKNvTBHcyCYzUBGHYOikcd4pCQ91fsTIO302FjvzK6k/1ywfwClLtFpXc+b506zmbNoGiOOzzbdOxRNu0ZqMga1h6gQx+9tWQYMjpBFP2Nji/wDY7FUQUdQkQnfi2n3CdLidVCI3c2jkfigDvx8q3kMBLc6ZhpBwomMoD00Kh5E8FtVHuFUYod7UJ2SaJpD8Ers/x8QsdJJPtLL/1wizyfEOLw/LWtMCe2WiVRcbTnnVTEtBSMwhLnIxGT1GY0/aQsQN7LKHKpQXjx0abfF1/9iybwMNnkIamSBXyeYy3TLLO2RmJxv1ZxEitqj8t7wp2JNccIC9/GDbnRGwRiFyNxSeB+rsHnY6/ndPE9j2tS69F+ONPw+cptIcwpA5lGsg2O+QAJsxf35Hii5ehdto+r+ja/Mnvjqu8ulQCTYXhtABb/8nk9/BrGyeg3y9S9oYCeg2Ur0TkOdX0SmNH8zpPP+80b8gX4kXPD02ii2pHfi3c0XZ4+WqM3DymqzOJd34TfXd1RC8e1zQ+cYeCtquAqqzqauM8dt6jfJPAC4PlysKu2Q4n/c3heaXcVJZGTrkrSJAyzlvXmi4Y/ciJ
 eqxhozXt
 gyJ/Fpncu86+SwJumuHhW6J4dEo4UUFaifrn+lVv1BVuL4TStfxoHjT3AO63qhXj/V1S6ApwAfZy4lIRdoOQExvRqAZt6/5phXOM9KhoqJo/EXo7SzML/O0LY/g0ShByf4FYnx4/qUUzN0bLQ5RyjyWjfUz/tfa0AhgA5GHk9/WybzZDJDTeIYwTglWcefuKPW6cQWhDiFOSMvej/nCsqNiaLSW6KveUZu0s775UUiM+Nlo8NmqQvNkrgCnjwGms6/S+Xjmxlnkx3IxnxQc60xjWDxMpZkcpu4+HCqpY+iYz+PWvJpceXaCEkkBzybIEk0TN330Z51rCr2v/d0/EI+0OeauQA9HIZWKJ3w/+pIbVb2gbRBKfJCk4W/ZvhRnWUoINC1I4h+7MYgE+hIQyN5U3GAA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add test to verify that DAMON status is not changed after a no-op
commit.

Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
---
 tools/testing/selftests/damon/Makefile        |  1 +
 .../damon/sysfs_no_op_commit_break.py         | 72 +++++++++++++++++++
 2 files changed, 73 insertions(+)
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
index 000000000000..f557587ebc81
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
+        print('before-commit status dump failed: %s' % err)
+        exit(1)
+
+    kdamonds.kdamonds[0].commit()
+
+    after_commit_status, err = \
+        dump_damon_status_dict(kdamonds.kdamonds[0].pid)
+    if err is not None:
+        print('after-commit status dump failed: %s' % err)
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


