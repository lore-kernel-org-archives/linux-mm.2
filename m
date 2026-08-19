Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 77E28C5DF6D
	for <linux-mm@archiver.kernel.org>; Wed, 19 Aug 2026 07:06:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 887936B00A3; Wed, 19 Aug 2026 03:06:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 837FE6B00A5; Wed, 19 Aug 2026 03:06:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 74D9E6B00A6; Wed, 19 Aug 2026 03:06:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 480E96B00A3
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 03:06:03 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C17A340367
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 07:06:02 +0000 (UTC)
X-FDA: 85117134564.06.08E0FD7
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com [209.85.216.72])
	by imf08.hostedemail.com (Postfix) with ESMTP id 14480160002
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 07:06:00 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=AUWEHtdQ;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf08.hostedemail.com: domain of 311WFaggKCPIdUmihgcoaiiafY.Wigfchor-ggepUWe.ila@flex--jasonmiu.bounces.google.com designates 209.85.216.72 as permitted sender) smtp.mailfrom=311WFaggKCPIdUmihgcoaiiafY.Wigfchor-ggepUWe.ila@flex--jasonmiu.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787123161;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ts4aq9qFq6CIZlsiXvQuHpSHiQajqVM1hB12vxK4HZs=;
	b=YrPQ3yv1xSOk6dQqUMGvNR6M0nLFehgxN8OKrI2Jwh9ycW868SHo/dRqJ19GYF/Ib3+l4T
	HRQLC7v+3ThZDJBYjzvf4dpNqSJiwb3nngnDjA1RVCcU5crTBUW7bN7BIfSrm/RL9WrfV/
	r+y4/rQ0vmfqBWwBZg28uCCRWkro2CA=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=AUWEHtdQ;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf08.hostedemail.com: domain of 311WFaggKCPIdUmihgcoaiiafY.Wigfchor-ggepUWe.ila@flex--jasonmiu.bounces.google.com designates 209.85.216.72 as permitted sender) smtp.mailfrom=311WFaggKCPIdUmihgcoaiiafY.Wigfchor-ggepUWe.ila@flex--jasonmiu.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787123161;
	b=MhOSsIzIj/Ug2fWTH14U5C9HjHuGURhyKmH/f/3+RazX8ZiBl3WFPaRL2QlWPF8O+qGUGR
	SMt41zn6M7XkxSTjyo/wkyhbdIR1crqlXgDHf+lZRNUD3ZFj+iwZI9ykFfPiIfJgZUd+vo
	b39XXW7OFWyRUDg9pdST3WuP7ID0q74=
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-38e4758ab46so1304347a91.0
        for <linux-mm@kvack.org>; Wed, 19 Aug 2026 00:06:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787123160; x=1787727960; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ts4aq9qFq6CIZlsiXvQuHpSHiQajqVM1hB12vxK4HZs=;
        b=AUWEHtdQa4NQq9MbqtVDzODaN58GALVfyfgtReXGXAtIP0qHe7vqdPGP233BvdrIsl
         8F3v9xjVlHO7P1lWm/5gm2fmbNkWPKjsbveU7HtDGHEIyyS3VYf+f3Jk0z3ZuglbNIoZ
         yBYc6QctQgaf3iz3hWC8Bgp0qVvGQpT4QnSBEdTNanoi8Q5FyfIMCqCn6+UpVKHO2IP1
         64yUCpJlv7N7rEv2uDzkH4jNjtQBFIBRcs3qU39Dsi+cj4BnsvFH04jyJPOetnFU7Cbw
         je91covdGSI7S6/5e2aBmKu8DPJQIoq+vMB2qUS563x9LrPYK+eLiJ+ANto7ooR1UYM5
         V+NQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787123160; x=1787727960;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ts4aq9qFq6CIZlsiXvQuHpSHiQajqVM1hB12vxK4HZs=;
        b=qe5lO87NisfsM3iDtxIIwx2b6KsrsLiSJsPAjREU1YrMOzKrSA20KDolKjBRscKDXa
         IUUNmgJPUE5WFmHpBzRHJ4ulCk3Qll3YUApL2KTE6WPvA/8LbVxZ5OGH42sPi4xKqbNP
         yEmzB2EHMLRmH2yboxdx6STqc/xhxxbZJMvCWQb7B9UIXlkJhV12qeB5oP4kTXkkF/k4
         xJWq51GcCr9Q7fBYhO8yi64A/kWsdLhmfGbnLWMvaWLp/WRCy4T7lc/vxJ0lwIhv9bRr
         YUIgwpr0ysOPdd838ILqvXO7B4OZIt24tQeuzzX59Ol9BYdUZ4qRVPAgn5FAiH43+gTO
         vDtw==
X-Forwarded-Encrypted: i=1; AHgh+RpuomS+2I7mKM0NGJSN8aj/EPmK/R4y658cFARKN3DzpsXR6ksVGQzkqibvHKFUJWp3tUNoi6tsSg==@kvack.org
X-Gm-Message-State: AOJu0YySQThFnROvAG5wIr8Ip/vBSHVpp19Js1Xbs+TMow6bwh1qY+db
	kPkYU7nbZTvObtVrOFLIZuyYo3y9FtmX0PEakVMuyIqkzlfFHA4HEejCfuBU+F+gpIRlkRgKatb
	GtaqPs6ZkVQJ4lA==
X-Received: from dyjt7.prod.google.com ([2002:a05:7300:7b07:b0:311:7d79:c37f])
 (user=jasonmiu job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:4c8d:b0:38e:ad9d:1151 with SMTP id 98e67ed59e1d1-39580a4c6aamr4886911a91.4.1787123159758;
 Wed, 19 Aug 2026 00:05:59 -0700 (PDT)
Date: Wed, 19 Aug 2026 00:05:38 -0700
In-Reply-To: <20260819070538.2404983-1-jasonmiu@google.com>
Mime-Version: 1.0
References: <20260819070538.2404983-1-jasonmiu@google.com>
X-Mailer: git-send-email 2.55.0.737.g08866a6d13-goog
Message-ID: <20260819070538.2404983-4-jasonmiu@google.com>
Subject: [PATCH 3/3] selftests: mm: add script for memory allocation stall test
From: Jason Miu <jasonmiu@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Shuah Khan <shuah@kernel.org>, David Rientjes <rientjes@google.com>, 
	Shakeel Butt <shakeel.butt@linux.dev>
Cc: Lorenzo Stoakes <ljs@kernel.org>, "Liam R . Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Greg Thelen <gthelen@google.com>, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-kselftest@vger.kernel.org, Jason Miu <jasonmiu@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Stat-Signature: z9ymmckpdu7upf6b6xhx4nwpinwda186
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 14480160002
X-HE-Tag: 1787123160-780223
X-HE-Meta: U2FsdGVkX1+gNo8vBWlzOUD+kueOSbug/f3jGqvdMz17/Dme6kQyYj/sk48YO8LNDyZQyCYml8dZcZcXeagpt11uNhRTWvrvhB6jMAlqgD0tBaru3qMG/7qy2A25a+nUPLsoe8h9pqf59trPEF0ih1eLq8vOgn1GKj21smIzSxAzbly0RlncPq3O3XyTBvlPz4lLimeyh5D+Lg/U9aFmdSETk6yb5By9ZTuBhCwPIOgq7bfpf8qmy95lE8Sf3CxaaTmu7w6iuCr0AEM9Ry53pSGzcBNXCGtegZL7SqHIb7eZRCUrREfiQcLpfWfzAzFqDM0C7pGWT1mUal9E3jO6kaV7aNgNvSzlEIge36qsG7QoRYU5vH9fo1is2k1hLhOv38CiK8kuEfFjiEYhGi+C4BgEstqNpFRXFluGNyB8MgklgYt8AEsyt8nsUn7fzRyrYovYGytY+vQxAI0KUhqnz8a29EbQyX69PNK3eVpM8m/ZSxU8bmEem0l1DW+lCh358GFE5xqMjl1V43/jiHxDHRo2y2AQF4hmD7uPFzpC9SONLUgZSi6e3IvuKJ7ovwGS55gliIPE9wwve7AUHO5m9ZynXi7O2TSkWter0WEbBEMLmXyQAtTMP4opRZYZVtmzCmint1u1b6bBQ97FBEZUE2LPJaqTeNexauuV4cQ63NJIw+0twymwj3DBbp/KsjPnDMI3TEzXQI6X2C2/aL2NPHY0ybeHZDTRczPBAPot8pR+JSa2lwvG6tCzCE48cdXMc2BTG9WZr95JCkSXCm6N0eCD0BljIvcMcujJVtCmOXCtFOP3t7G9qgS4xahOvJuRejcSFMCD9Bhu7oF0kz2yx1GI/6EZLmqqEN3Zh2/eSlf/3CQ0Ma1V4CS6frdde5f3e0KK/ui98CYwyNoDu0aJtZ+F/t7fumCO362ZB7tOQlFvsCiQz0lXJOyJ7PdshCjEUFt5/oobJyhM7q6yHZA
 A9MAt7Pv
 7L2KVqhPN4vsfydbZT4PLs2umLLxp3VI9OoJ/ggvydMaM6VBGUOibsUSALg5WJ5RFyFq+0Xv73LvkENJv4I8EU1FzpKegDnTzuOAusQw+CgRhz6QxQXU8kctqelEHyeCkwzbFyoVdixf++BHFzXBuHB05O1WZZfSzVyJ86FPW7uRVmV47UP4DPrqomNutN0hpsEmJm1TUl9aMpDMihUXdo3/HIYrKzR7j3yljmkEpryxj64I0b0Z0KLUbYL1lGhJ8GOV726v3A5dMMaUG0xt3cyQBBjKAz2EZtocZOfL55IOxvbMO72fOBu9lb0BUx8pAykiBgc0O2lPn98iHW3hoCmAgzLACfYwSzWJkdHwR13+6GMZCzOY1QkFzVE7qoxL7ITE74wj+GIyg9GEyyWxV0nTa708DtK/lMaBdfSptRsC5mwtwVhL8XHEej3ldE5wDRmIcurMvzYPRnv5uSnWjAC0f1Ac+HOj5lY+rLbYJqGh0QWzX2F6jXDA0PTDc/rht8NPPtACRfayW7rxTfiTP1JE2r7eycjE6dgJhG+wJ3PoayCrKpZPYwoTVlVgIdRZXWZXlawBnLOpdEh2ObPPK1AZYFQfpqIm+D1GZm2XlKLy5jfF6WnUCNHedww==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Integrate page_alloc_stall.sh, a script to synchronize userspace and
kernelspace workloads to reproduce page allocation stalls.

Provision a synthetic loopback zswap block device, inject the
test_mempress_timer.ko module to generate atomic page allocations
inside kernel timers, and execute the page_alloc_stall_pressure.py
payload to induce system-wide swap activity.

Signed-off-by: Jason Miu <jasonmiu@google.com>
---
 .../testing/selftests/mm/page_alloc_stall.sh  | 80 +++++++++++++++++++
 1 file changed, 80 insertions(+)
 create mode 100644 tools/testing/selftests/mm/page_alloc_stall.sh

diff --git a/tools/testing/selftests/mm/page_alloc_stall.sh b/tools/testing/selftests/mm/page_alloc_stall.sh
new file mode 100644
index 000000000000..3ece026fd680
--- /dev/null
+++ b/tools/testing/selftests/mm/page_alloc_stall.sh
@@ -0,0 +1,80 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+#
+# page_alloc_stall.sh
+#
+# Orchestrator script to generate concurrent userspace and kernelspace
+# memory allocation pressure over a synthetic zswap backing block device
+# to artificially induce systemic memory contention.
+#
+# Dependencies:
+# - External memtoy binary (Source: https://github.com/kosaki/memtoy)
+#
+# Usage:
+# ./page_alloc_stall.sh [hog_percent=80] [workers=64] [overcommit=2.5] \
+#                       [swap_gb=10%_RAM] [memtoy_path="memtoy/memtoy"]
+
+set -e
+
+SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
+PYTHON_CMD=${PYTHON_CMD:-python3}
+
+HOG_PERCENT=${1:-80}
+NUM_WORKERS=${2:-64}
+OVERCOMMIT=${3:-2.5}
+TARGET_SWAP_GB=$4
+MEMTOY_PATH=${5:-"memtoy/memtoy"}
+
+function total_mem_gb()
+{
+    awk '/MemTotal/ {print int($2 / 1024 / 1024)}' /proc/meminfo
+}
+
+function enable_zswap_file()
+{
+    local swap_size_gb=$1
+
+    fallocate -l ${swap_size_gb}G "$SCRIPT_DIR/swap.img"
+
+    LOOP_DEV=$(losetup -f --show "$SCRIPT_DIR/swap.img")
+    mkswap $LOOP_DEV
+    swapon $LOOP_DEV
+
+    echo 1 > /sys/module/zswap/parameters/enabled
+}
+
+function cleanup()
+{
+    echo "Tearing down the test..."
+    if lsmod | grep -q test_mempress_timer; then
+        rmmod test_mempress_timer || echo "Failed to rmmod mempress_timer"
+    fi
+
+    # Check if loop dev was actually created before trying to destroy it
+    if [ -n "$LOOP_DEV" ]; then
+        swapoff $LOOP_DEV 2>/dev/null || true
+        losetup -d $LOOP_DEV 2>/dev/null || true
+    fi
+    rm -f "$SCRIPT_DIR/swap.img"
+}
+
+trap cleanup EXIT
+
+if [ -z "$TARGET_SWAP_GB" ]; then
+    # use 10% of the total mem for zswap file by default.
+    TARGET_SWAP_GB=$(($(total_mem_gb) / 10))
+fi
+
+enable_zswap_file $TARGET_SWAP_GB
+
+KROOT=$(cd "$SCRIPT_DIR/../../../.." && pwd)
+KO_PATH="$KROOT/lib/test_mempress_timer.ko"
+
+if [ "$KO_PATH" ]; then
+    insmod "$KO_PATH"
+else
+    echo "WARNING: $KO_PATH not found! Aborting the test."
+    exit 1
+fi
+
+"$PYTHON_CMD" "$SCRIPT_DIR/page_alloc_stall_pressure.py" $HOG_PERCENT $NUM_WORKERS $OVERCOMMIT $MEMTOY_PATH
-- 
2.55.0.691.gc56d675ccc-goog


