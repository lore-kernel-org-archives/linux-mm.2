Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A552606A8A7
	for <linux-mm@archiver.kernel.org>; Sun, 15 Nov 2026 14:03:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=K5ptMEvX
Received: by kanga.kvack.org (Postfix)
	id 64A196B05BF; Sun, 15 Nov 2026 09:02:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5ACD26B05C0; Sun, 15 Nov 2026 09:02:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 49BEC6B05C1; Sun, 15 Nov 2026 09:02:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1D3716B05BF
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 09:02:52 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 892E340755
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 14:02:51 +0000 (UTC)
X-FDA: 85437519342.12.96B21E9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id A9E9F100009
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 14:02:49 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=K5ptMEvX;
	spf=pass (imf05.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794751369;
	b=4jhdmnizVr7aIqQZbIMRXNQpB3/JdxFNlCYYx55S78SchoEAZbDz/TI63zuPFohate15+C
	al6brYpekmq/1at7QpZ/V+S5/cKN8+8oTH0OEPyPil4G4OeYOutG3kOyvOlaWHWJG0goqX
	dQeBvBrYGdVyuG5IYVmPUmahkLSVyO4=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=K5ptMEvX;
	spf=pass (imf05.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794751369;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oP5zIZCQTcMU9+CPrnID7f1P0LDTPtLFFjYPE0HeKnY=;
	b=XiSbQ0dFUahoK05AJCCejDwi4rtS2oRzHPJAVObMdUi5s4hzTBln9zZRS2GB/K4mxXgNQP
	dpIuT8FsH2AhRSVQDZRY5N5OsctYDDE0kcvAy8VTvflZqxXc32QQUR3AiT9oqXZdGGUjIC
	PGp245ufm3oHlS3oN9VreITi5yqvlts=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 427B3623C6;
	Sun, 15 Nov 2026 14:02:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A3F51F000C4;
	Sun, 15 Nov 2026 14:02:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794751369;
	bh=oP5zIZCQTcMU9+CPrnID7f1P0LDTPtLFFjYPE0HeKnY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=K5ptMEvXOFu9qpLLiVWzupBP0giX+aKB+gY5mvwLuKtilk1+JXMObMjAgnCUsISCU
	 2497YIWWQwd+8BSlRCera9VbFkT+iLV7OrAxD9xvA32qYgrG4GyHi9e0wpRENhkD8R
	 nPUxAuijTqPnVrbls6vpZ06JMNKW8CP0vOWqohnrnB1ow0wpTwR7hTFmZD7NpldVhi
	 3T7hENFpK/e3YaFEtIf4MfiZqPBE0pk16ewIH+JZi7c6nSNNWuxwKgNrNGWWQdbZNm
	 RFcJk0PGwXpT6ZV9Gg7UH4l6eS/vOydX1+K8aCZYSS3Oi4ZEhIfYmhFTdv+/eo8ABP
	 +EVy0uNQY+XuA==
From: Christian Brauner <brauner@kernel.org>
Date: Sun, 15 Nov 2026 15:01:42 +0100
Subject: [PATCH 12/13] selftests/ftrace: add uprobe tests on overlayfs
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261115-work-ovl-d_real-v1-12-ca155efbcb2e@kernel.org>
References: <20261115-work-ovl-d_real-v1-0-ca155efbcb2e@kernel.org>
In-Reply-To: <20261115-work-ovl-d_real-v1-0-ca155efbcb2e@kernel.org>
To: Amir Goldstein <amir73il@gmail.com>, linux-fsdevel@vger.kernel.org
Cc: Chris Down <chris@chrisdown.name>, Miklos Szeredi <mszeredi@redhat.com>, 
 linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
 bpf@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
 linux-integrity@vger.kernel.org, linux-security-module@vger.kernel.org, 
 linux-mm@kvack.org, "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=4013; i=brauner@kernel.org;
 h=from:subject:message-id; bh=xU8r7+QeQbm0YiMN28AhupsgwvIfGboboN38EplDOpw=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWT93B1rLux4aLX3tOn77I7tfTqN3eKmzWFbD1dmk1zHG
 YoZjyYJd5SyMIhxMciKKbI4tJuEyy3nqdhslKkBM4eVCWQIAxenAEzk1H9GhkkW83jiHk2dIez5
 x7dQd6vso67TTLpvnMzepxjJvlZ4dJ6RYYpxgVsM+315zvbbl9cw/TxuJZby4xvr37cujL+eHnN
 R5QMA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Stat-Signature: 38ne48p335j7jnznhemnb9kdjgt9o8t4
X-Rspamd-Queue-Id: A9E9F100009
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794751369-753793
X-HE-Meta: U2FsdGVkX1/wsORFHqszEuVl/g6joMRw1NLai7hd88xQ9ZYemI3QTYrdA1HUD5iDJr6p8+wU5xoQ34/oCmXusy62J7OTP9ivcTkybAqF4Kf4CSX8bp8KmPWrdMi9l6zq70p2fo539bY1/B8aAbrWIMl7etN5/WBUwK6tOU43a5KKTl5L3k/kJEIo2B8M9B5FdNiWRbudS9OJXtf+/KnQOnSb5x5Y3wPCN/Ho2gH+GmSleKRBNaZHlB0NL/XuHqcQ+mJ3Dk8Jba/gQDFsuspdrad+3RM2XPYer+tarwCyYGr4tRA3HV066YA82wI0lr/SDtbKSmI8Q6qz2DK7sn9RylNoxsGr/pH5TAquW69X0bVb0cA2MZhNNNo6LzljbVDJgdB0ejDWFElA7gFrnGIeBtBQqcOMb+FSWMSaPiMvuxKMp0+xRP2my6OWFuCekDO4ORdEu+vexlfUw2uuz5FVNzesnREFeHWQI+Lp4GjhALEkfglcUgKbnSG3FvUa86IjVGwklpa/rlP75ARU1NfVcEdLYamvClBCcGKN1p7pV/jh39ckzuxJDlOg85We5qd/dNm9vNMWD4TVxsok02KoZ5iqt0CJ17oI2o8X7wd+6u+8ZCkB2S/eLiXeEHLCAu4Ewa5Z8NSA1g/wojicJmyNLLOGp8dvNa80VfRzCYkPmnLlo/SBn8X0VCOPKV1rKKll+DjMjfE8gOH6AGh9evHilXOlyXGcDh5pmqt72Wcpe+eRhaUfDhNLT/gcHFhjFixiYB8x0A3P5969SNo6MS6UYWG83ufvQJU3NEcjqQ33EJua8sDVgHWUS6RHvMABe/rp8HMvM8ht4waxjJhqGoI4U9DbNxffu1+C6qLVwYXuA4Pr6zCfXHEHW1I8D7jB9wzh5WIlhAJ93/tXyygf2As5LZ1HCbjWFg9DN2JhptG3iN1C0h9tmKhCQeUy6nbT2dOyxNFAeMiadIqYsHmMuc+
 YV+JEEHE
 8u4/pg4BeetVk/UqVZNKxtm+iGtTmMnJip/ThSgrK11fFlvxppORoRo1SrsqB6ek096nemVSt5X0cMuK19H6Mh8I6VpI+jaAfC6NNNX5WPP06gVn/7CxHq+oC+8n3AWFl69bNv4Iktu7iOWtVEieYnLoQ4ceNloF0AQD6wzWVPywXbnXe11UR3aW0yD7gmNTZxprf54OgrBidlyt+3/niQH+aZRhlYbvy+3EklAhq/H9R+BbE7XANKaOiEw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Add uprobe tests on overlayfs with a data-only layer:

- a metacopy file whose redirect points at nothing: creating the probe
  fails, the error log has the new message and nothing gets tainted by a
  WARN

- a metacopy file whose data lives in the data-only layer: the data is
  looked up when the probe is created and the probe hits when the file
  is executed

None of the existing tests puts a uprobe on overlayfs.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 .../test.d/dynevent/add_remove_uprobe_overlayfs.tc | 92 ++++++++++++++++++++++
 1 file changed, 92 insertions(+)

diff --git a/tools/testing/selftests/ftrace/test.d/dynevent/add_remove_uprobe_overlayfs.tc b/tools/testing/selftests/ftrace/test.d/dynevent/add_remove_uprobe_overlayfs.tc
new file mode 100644
index 0000000000000..a4351e6a3b181
--- /dev/null
+++ b/tools/testing/selftests/ftrace/test.d/dynevent/add_remove_uprobe_overlayfs.tc
@@ -0,0 +1,92 @@
+#!/bin/sh
+# SPDX-License-Identifier: GPL-2.0
+# description: Generic dynamic event - add/remove uprobe events on overlayfs
+# requires: uprobe_events error_log setfattr:program readelf:program
+
+grep -qw overlay /proc/filesystems || modprobe overlay 2> /dev/null || :
+if ! grep -qw overlay /proc/filesystems; then
+  echo "No overlayfs support. skipped."
+  exit_unsupported
+fi
+
+echo 0 > events/enable
+echo > dynamic_events
+
+OVL=$TMPDIR/ovl
+mkdir $OVL
+mount -t tmpfs tmpfs $OVL
+
+cleanup() {
+  echo > uprobe_events
+  umount $OVL/merged 2> /dev/null || :
+  umount $OVL 2> /dev/null || :
+}
+trap cleanup EXIT
+
+mkdir $OVL/lower $OVL/data $OVL/merged
+
+# A metacopy file whose data lives in the data-only layer.
+REALBIN=`readlink -f /bin/sh`
+cp $REALBIN $OVL/data/sh
+truncate -s `stat -c %s $REALBIN` $OVL/lower/sh
+chmod 755 $OVL/lower/sh
+setfattr -n trusted.overlay.metacopy $OVL/lower/sh
+setfattr -n trusted.overlay.redirect -v /sh $OVL/lower/sh
+
+# A metacopy file whose data doesn't exist.
+touch $OVL/lower/broken
+setfattr -n trusted.overlay.metacopy $OVL/lower/broken
+setfattr -n trusted.overlay.redirect -v /missing $OVL/lower/broken
+
+mount -t overlay overlay -o lowerdir=$OVL/lower::$OVL/data $OVL/merged
+
+TAINT_WARN=512
+TAINTED=`cat /proc/sys/kernel/tainted`
+
+# The data of the broken file can't be resolved so the probe must fail
+# right away and not only when it is enabled.
+echo > error_log
+if echo "p:broken $OVL/merged/broken:0x0" >> uprobe_events; then
+  echo "uprobe on a file without data was created"
+  exit_fail
+fi
+grep -q "trace_uprobe: error: Failed to resolve the data of the given file" error_log
+! grep -q broken uprobe_events
+test ! -d events/uprobes/broken
+
+# Get the entry point virtual address from ELF header and convert it to
+# a file offset. See add_remove_uprobe.tc.
+ENTRY=`readelf -hW ${REALBIN} | grep "Entry point" | awk '{print $NF}'`
+ENTRY_DEC=$(printf '%d' "$ENTRY")
+OFFSET=$ENTRY
+while IFS= read -r line; do
+    set -- $line
+    [ "$1" = "LOAD" ] || continue
+    VA_DEC=$(printf '%d' "$3")
+    OFF_DEC=$(printf '%d' "$2")
+    FSZ_DEC=$(printf '%d' "$5")
+    if [ "$ENTRY_DEC" -ge "$VA_DEC" ] && [ "$ENTRY_DEC" -lt "$((VA_DEC + FSZ_DEC))" ]; then
+        OFFSET=$(printf '0x%x' "$((ENTRY_DEC - VA_DEC + OFF_DEC))")
+        break
+    fi
+done << EOF
+$(readelf -lW ${REALBIN} | grep LOAD)
+EOF
+
+# The data of the metacopy file is looked up when the probe is created.
+echo "p:myevent $OVL/merged/sh:${OFFSET}" >> uprobe_events
+grep -q myevent uprobe_events
+test -d events/uprobes/myevent
+
+echo 1 > events/uprobes/myevent/enable
+echo 'ls' | $OVL/merged/sh > /dev/null
+echo 0 > events/uprobes/myevent/enable
+grep -q myevent trace
+
+echo "-:myevent" >> uprobe_events
+! grep -q myevent uprobe_events
+
+# Nothing above may have warned.
+test $((`cat /proc/sys/kernel/tainted` & TAINT_WARN)) -eq $((TAINTED & TAINT_WARN))
+
+clear_trace

-- 
2.53.0


