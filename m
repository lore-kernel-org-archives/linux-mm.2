Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7ACFACCA46C
	for <linux-mm@archiver.kernel.org>; Fri, 16 Oct 2026 12:55:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 59E096B0098; Fri, 16 Oct 2026 08:55:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 56DA66B0099; Fri, 16 Oct 2026 08:55:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 484DA6B009B; Fri, 16 Oct 2026 08:55:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 237936B0098
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 08:55:03 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A4B0F14038D
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 12:55:02 +0000 (UTC)
X-FDA: 85328484444.12.C05D5F2
Received: from mail-dy1-f170.google.com (mail-dy1-f170.google.com [74.125.82.170])
	by imf07.hostedemail.com (Postfix) with ESMTP id C01444000B
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 12:55:00 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="F62l/+zZ";
	spf=pass (imf07.hostedemail.com: domain of odys.yuan@gmail.com designates 74.125.82.170 as permitted sender) smtp.mailfrom=odys.yuan@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792155300;
	b=nwjG7BYRkSHYE9P/wH0NM5xkCBckk4a2+3Hrazxsyn/wAEXja79Thzk3n1R2pz63YUXJr+
	sZbbJvIQeMrtKe+qTGKu4UBQZiztJ+JppJUrGbeNvJddubHm8mOUq1Dn2UEcH+Lly0CdDf
	J0NADQs5sO977iKNvBb/iJXqiSXOaGE=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="F62l/+zZ";
	spf=pass (imf07.hostedemail.com: domain of odys.yuan@gmail.com designates 74.125.82.170 as permitted sender) smtp.mailfrom=odys.yuan@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792155300;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=E95YYQwjstxiJyP2LILlZnMWy7pjKVcdUHQn5hEnhWY=;
	b=sFvl0LHCNfUV5vpkr705xhIsHYrbL78zJQSr9xb9b0fZacOe+R2wP5gLC+gEpTZRtiVECi
	im3kX01IuH28tKcuQSHuNmoUUmMJeloK/tIEqmCjghsSe97X2zjA28K9ftf69T3zJbCMdY
	pSnCZLLgTw+qRleVzR0ygrUSllj/yS8=
Received: by mail-dy1-f170.google.com with SMTP id 5a478bee46e88-35c76e9614aso4863036eec.0
        for <linux-mm@kvack.org>; Fri, 16 Oct 2026 05:55:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792155299; x=1792760099; darn=kvack.org;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=E95YYQwjstxiJyP2LILlZnMWy7pjKVcdUHQn5hEnhWY=;
        b=F62l/+zZCkQwnpRVisnHTVjrMbgybhC8spEeMX37zWumtV/Ah3uZmaI4viSR+U06Wn
         uceVpWaqSPnbMMM5ZGWUQ3aY+Cm1Nx5g7jG4ppdOoh41izmrs70EA+/cZvRbkXeIV4oW
         YrXlkM2HYXGkSI3A943o2e1MsVWR6Cyai9bLclAQfp2G1guaJjaTyrK9nMWGfxafxgGR
         MVkJWkzF02R1tZMW+XZHG4JlbT40P+Az4wNGWl3ZopK3q0uveg3sxJwqaVE2U+76iCP4
         9faPftE6kWnanX03IoZ5xlFFrE4hmgknLwlLN7TX4RRQzIaPgprofvfxQ1z4uAkI1TPG
         kprQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792155300; x=1792760100;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=E95YYQwjstxiJyP2LILlZnMWy7pjKVcdUHQn5hEnhWY=;
        b=yvnqBffEnlB/XsXw5a0GAG6T2qfdTjq7urziu7eoA6CDC7JTS1WsKpmF6oFwoegNeG
         u7/CRwFjmeqnqT1EiPKFuwTfPbtpqaIVJWf6VqUeWLzZekLffZ5N+boEBxYna0hoFZjN
         PXhFGdDAJZ4aoiD2CT56fOUwzh32Q853K1lduyHuPA9k2Wf1uAlbKSHJB8/vA8j4/t5f
         EhvcynmeE/sP6VjLkulX/H0L1Aia3LQi32lAbwpzrBAFL6ubKvBnJP7ikmQpm95GYR/D
         t5inhNs1T215dmkSQQdEjZED8rhBwYhU2mVIU45CcpNFnoKV4TV04SoLJ3UCCImS24vm
         +/9A==
X-Gm-Message-State: AFq9FYIS/cQSbtJNsxy0GDfweZ18G4Ls2KhpWpQBl8YsHeGalHA+p5/N
	VhbUmq9p3FriZ9irj5cs2v+/j8iqEn8eHLYSp08Cy9Uaekm5wkIT2Yn7
X-Gm-Gg: AYBFou0AIwaZJ8JXFHrXGMgq4S2svGQ9qrEwZkGGZIikGrJANF9VpcCqYV/DlwhlFaB
	NBA6eCHGAZ8b/aQwKCPwZviBH5xVp1CVaGRTgOHHL1eL7bn8FmqT6tT2v7pJ4QwwJqQD5ngM9lw
	KwE6l8L0/qamCCAekho8Cf91HiEPE5Ff/MBHh7cRqE+oIf/wIIRxsHrZvuJmahj5uciVFIuHUc6
	cPLj1F1W9b2TogWdo26q0Q5MZJ+/rXOrJgJCypB3ZM7gTjuxpYBta5ilJtUc/tZHmJdmv+DUdT6
	UfNduou9sR7VVvx3l59Gyl3IjBCjU0a6KofffRvvqEQ3xiTiL7ua+mvxQ/fv3HOgG3wZuST3K7l
	FeAWPg6EKquN+hIDCtN53wDcYjfyULU7RZCDmPDbFBaJbX7MGwZRe9Kivq6q6cbJV403K6sHAQe
	TJa+uVvyDi9KZ5g0fPPA9gfR4G9lZkjBNLRz06GeQ7FfKcfYs+KnsMg7zmlPORKJ0s4e/K2VP9/
	Weo
X-Received: by 2002:a05:7300:d58d:b0:360:73dc:1e13 with SMTP id 5a478bee46e88-36073dc22cdmr3045198eec.17.1792155299332;
        Fri, 16 Oct 2026 05:54:59 -0700 (PDT)
Received: from [127.0.1.1] ([23.254.208.9])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36081fa5a6esm6974508eec.16.2026.10.16.05.54.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Oct 2026 05:54:58 -0700 (PDT)
From: Qiliang Yuan <odys.yuan@gmail.com>
Date: Fri, 16 Oct 2026 20:54:48 +0800
Subject: [PATCH] selftests/mm: skip hugetlb cgroup v2 tests without the
 needed controllers
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261016-bug-selftests-mm-hugetlb-cgroup2-skip-v1-1-7c78883a67b4@gmail.com>
X-B4-Tracking: v=1; b=H4sIAJce0moC/x3NTQrDIBBA4auEWXdATbGhVyldJHY0Q/7E0RAIu
 Xuky2/z3glCiUng3ZyQaGfhba3Qjwbc2K+BkH/VYJSxWmmLQwkoNPtMkgWXBccSKM8DupC2Eg3
 KxBFf3qlW22dnvYHaiok8H//P53tdN27F2oZ3AAAA
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>, 
 Mina Almasry <almasrymina@google.com>, Muchun Song <muchun.song@linux.dev>, 
 Oscar Salvador <osalvador@suse.de>
Cc: linux-mm@kvack.org, linux-kselftest@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Qiliang Yuan <odys.yuan@gmail.com>
X-Mailer: b4 0.13.0
X-Stat-Signature: yj3fxqjg9ssspp93kbyfr6boyuxk1axy
X-Rspamd-Queue-Id: C01444000B
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1792155300-8566
X-HE-Meta: U2FsdGVkX18Za357z4ltm1lXvjOxw9tx2gC8kvOWDJ4bJLH+gQe/IMBKlePDp3XNxX5bqiz0kw7EdN5KSL747GJRI7NiacSzz9Av+ySEHbVkDHmZnbgqqq6EBEZbYOS8r16Wb3Se/GaHEb8fPdIszPadskHMOkyaAWU1DhTB/yCyHWOOfkAo8fljpYqPJ0DljML8aKsRayzEBAMxeujRcUiw/0BQ0fAa4+Y63ibo3u5M5oS0+Dbz2TG1v86JhhD7GSgAj52oTJ/OAuKLgvbWCadggkMCXTSl6+QJx6yUSTNBZQhXw5/yKNVqj+mvkRXGxtdZxIpnUBciAzjO4rIMQ5Fbyh3NjtKnvTZEbwVwDhjCXPKj21XAE8UltjRWJ4i6do/X+Bg+TACCVu4GHQjNf84sR5kXFyBEzzMy2Zo+ypfqdV8PP1Ij8tws9q8dYjwwfCSAR6sHeya48XOINgqgXkPd86HwD8W3tkakNNMyxtDBrPTandSf8CsY58c+oX2jx4q5OwZOhOnZwpXg1VGwbJReZmRqtge6FfNqiw+ZFuE+s+gjAxeFEx2u46jdcCvaF2L3nVaaf7ukE12DTWfZhmqBqIOJYKuds9VQtAoouYY8w/OkGVGKfDumP6uVUW8F/LZ6/3uElgtsIyyJ4ONgsBhgxH/VYtclOi3ZUnKq+jOyq9E039RahVB5EhNfv5xa1V4baMUljxw28e/F7SlKjc/J2KIRZnkjq5/9cEB2wIuHp1cN6yzrz6UKvXhP2CINCes3XrcDxs81SQqGNw8EwxxcooDnu4Isy6u24RWzNWh3SaMQ44xS61CDUC7TzEd6poqNqPG93tyEXfUE2nboB5R4D0Q5zde+Z8/+8FyansWw3T8mc/AJQfz/JmqqwSnhFwwN0q26ETWNg9377yj4DrgPIInz2dWckEBxibbFQZLrVBFnfbcJfw3Mk2Gszt/6MrD0S9mhtBaNEVJpw8J
 a8bTrWPK
 SOiGbDoi78LPJHDL2Yd9NazUuXtD4gYbaXdJ/ftGVDrKzmS9Vd8wIxefnzw54EoguGjGtb2wWo+x2JS6gRt687anc8E7G8FT/HJpYbzSsI1DFHCu8dnVBSJVByEV4LTZ8W2alPtK3MeqW9sh0PMDkFqM26C2ERFh50VKrY6rBOJS5SLC/ucnIijh6f/3ZtbX/979E8G7M5L4afF1VprVnHVaISW0Yl8mf1vFj4Ua1oPZkJOtPEuuchZ3WQ1Q34zybtne8BVOMHJbQATnhEScPDE2QLp3zd7t6DlN9GQwAt9Xo8Li7Jaq5NZloogUF5f4uOJuQ3CaQ6Ohw+Kl7QBJN6x/N8KNlKUhFzr0QhPu8npZ9yALvKoRsMfwSgjhMRJZZFEMDV9wZQeKWWTgCAqo5wZFkd+awlSYsDiuykc36Q1RYlzIG12+qswu71HBSov/I2ohqkdflE8pn8RPp0WCLR4pMsKmY4RnP3V1qSdQE/N4uXLmKrl2TZBMoTQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

With -cgroup-v2, charge_reserved_hugetlb.sh and
hugetlb_reparenting_test.sh mount a cgroup2 hierarchy on a temporary
directory when none is mounted and enable the hugetlb controller
(hugetlb_reparenting_test.sh also enables memory) in its
cgroup.subtree_control.

On a system that still binds these controllers to cgroup v1, they are
not available in the new hierarchy. Writing to cgroup.subtree_control
fails with ENOENT, "set -e" aborts the script, the test is reported as
failed, and the temporary cgroup2 mount is left behind.

Check cgroup.controllers first, and skip the test when a controller is
missing, after unmounting the hierarchy and removing the directory the
script created.

With hugetlb and memory bound to cgroup v1, per script:

                                before      after
  result                        fail        skip
  cgroup2 mounts left behind       1           0

Fixes: 29750f71a9b4 ("hugetlb_cgroup: add hugetlb_cgroup reservation tests")
Signed-off-by: Qiliang Yuan <odys.yuan@gmail.com>
---
 tools/testing/selftests/mm/charge_reserved_hugetlb.sh  |  8 ++++++++
 tools/testing/selftests/mm/hugetlb_reparenting_test.sh | 10 ++++++++++
 2 files changed, 18 insertions(+)

diff --git a/tools/testing/selftests/mm/charge_reserved_hugetlb.sh b/tools/testing/selftests/mm/charge_reserved_hugetlb.sh
index a1cfd3a349db6..65065b1377b24 100755
--- a/tools/testing/selftests/mm/charge_reserved_hugetlb.sh
+++ b/tools/testing/selftests/mm/charge_reserved_hugetlb.sh
@@ -39,6 +39,14 @@ if [[ $cgroup2 ]]; then
     mount -t cgroup2 none $cgroup_path
     do_umount=1
   fi
+  if ! grep -qw hugetlb $cgroup_path/cgroup.controllers; then
+    echo "hugetlb controller not available in cgroup v2. Skipping..."
+    if [[ $do_umount ]]; then
+      umount $cgroup_path
+      rmdir $cgroup_path
+    fi
+    exit $ksft_skip
+  fi
   echo "+hugetlb" >$cgroup_path/cgroup.subtree_control
 else
   cgroup_path=$(mount -t cgroup | grep ",hugetlb" | awk '{print $3}')
diff --git a/tools/testing/selftests/mm/hugetlb_reparenting_test.sh b/tools/testing/selftests/mm/hugetlb_reparenting_test.sh
index 95f517c3bd167..811912ae7d975 100755
--- a/tools/testing/selftests/mm/hugetlb_reparenting_test.sh
+++ b/tools/testing/selftests/mm/hugetlb_reparenting_test.sh
@@ -29,6 +29,16 @@ if [[ $cgroup2 ]]; then
     mount -t cgroup2 none $CGROUP_ROOT
     do_umount=1
   fi
+  for ctrl in hugetlb memory; do
+    if ! grep -qw $ctrl $CGROUP_ROOT/cgroup.controllers; then
+      echo "$ctrl controller not available in cgroup v2. Skipping..."
+      if [[ $do_umount ]]; then
+        umount $CGROUP_ROOT
+        rmdir $CGROUP_ROOT
+      fi
+      exit $ksft_skip
+    fi
+  done
   echo "+hugetlb +memory" >$CGROUP_ROOT/cgroup.subtree_control
 else
   CGROUP_ROOT=$(mount -t cgroup | grep ",hugetlb" | awk '{print $3}')

---
base-commit: 437a7e839def0f505277022622fc59a8b071d6cf
change-id: 20261016-bug-selftests-mm-hugetlb-cgroup2-skip-7fc0316486f2

Best regards,
-- 
Qiliang Yuan <odys.yuan@gmail.com>


