Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BCC2A606A88C
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 09:45:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=B97HKY2P
Received: by kanga.kvack.org (Postfix)
	id 04D5F6B05C0; Mon, 16 Nov 2026 04:45:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF16F6B05C1; Mon, 16 Nov 2026 04:45:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DB9DE6B05C2; Mon, 16 Nov 2026 04:45:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 975B66B05C0
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 04:45:19 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 08BAE160783
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 09:45:19 +0000 (UTC)
X-FDA: 85440499158.20.BF6DAF6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 47489180004
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 09:45:17 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=B97HKY2P;
	spf=pass (imf24.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794822317;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JZBbr+KpgKvtf5CdfCyTEA2njHiE84oBk+6E/JibmWY=;
	b=if5JQERfOtYELHkpgybNU7El5JAFMd+r33Ora15TazGE0QWb/xT8IZY4QrgX2xnT66XSil
	ZlsVUueQQStLVHNvk7Kn/8cjqc+IqXZaNRVvDDFnbzJltnODNPpjzPyZ0K/o/4fBbSVUPP
	L0n0idEX+WpUSM1UUP3o5Q1lfY2aGIM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794822317;
	b=RUZFcZxPXcSisF5qhnLzr8NKQdy1QA+z0dTN7DzWRK/7cy3x/WRBTjy8wVXqvkNM2VFFxx
	VlbSkOGb13Q4/CEwULCMcxhLOZySaBM3Jj+yAkDeAXjhr6q5Y3jDXB7DDRtu4UA/MnUTwK
	SMqzvI9TNr1P1bUfhQ77w0apFHqX+cM=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=B97HKY2P;
	spf=pass (imf24.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9CC29400AC;
	Mon, 16 Nov 2026 09:45:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7B121F000CE;
	Mon, 16 Nov 2026 09:45:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794822316;
	bh=JZBbr+KpgKvtf5CdfCyTEA2njHiE84oBk+6E/JibmWY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=B97HKY2PGKEGnNZWH+9w9+0VaaDTFjZeYetWFj6uCjbfmrTo7DbHvFCFzkFFczhnR
	 HEATw/pGVvMAd4PbreaA6tlPFV+ioe9bWLZlVkGN3Jnc3bu5KhIG9mB2APdMMyEexJ
	 qxpM2ebSt4BGJesPkEI+dbqVN8D0hh/YnHLDpejcYCUUwCdQtNushOG5qn43SoZCBZ
	 T7YkZnNrFsMd+FsKCzi0JonosAYo6jife3TfunFHCnFnuoehPzuyK6NruLLkOO/ofc
	 Fxaa96qcnNpctrcitMhsV1ZgLI/30L4SF5Cp7PNJbK8wcHujVu3YfUMZIPb1LEgfhy
	 eKAjdrUPsId1g==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 16 Nov 2026 10:44:09 +0100
Subject: [PATCH v2 12/13] selftests/ftrace: add uprobe tests on overlayfs
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261116-work-ovl-d_real-v2-12-90564c4ae347@kernel.org>
References: <20261116-work-ovl-d_real-v2-0-90564c4ae347@kernel.org>
In-Reply-To: <20261116-work-ovl-d_real-v2-0-90564c4ae347@kernel.org>
To: Amir Goldstein <amir73il@gmail.com>, linux-fsdevel@vger.kernel.org
Cc: Chris Down <chris@chrisdown.name>, Miklos Szeredi <mszeredi@redhat.com>, 
 linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
 bpf@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
 linux-integrity@vger.kernel.org, linux-security-module@vger.kernel.org, 
 linux-mm@kvack.org, "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=4861; i=brauner@kernel.org;
 h=from:subject:message-id; bh=tgbFOzNYWl27oUOBkSLrcjFal3oWf5TeuDFachZqNjU=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWT9ulDDvKxedjtHwJmjQZoOpw2Mm44FvtkYPCW/YvU0t
 +O7P/zU6ShlYRDjYpAVU2RxaDcJl1vOU7HZKFMDZg4rE8gQBi5OAZjIkdcM//0D5/bEbj/Euaou
 YZqiyh79ScKHDTVunEj884yvMcWzYyYjw2Lpzs0njulOu2m2mKF03+NF2rasHl9jlc5KXNv6aJp
 1FTMA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 47489180004
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: dec5dppmdr1jcib5h3ads6bnpxpp1iiy
X-Rspam-User: 
X-HE-Tag: 1794822317-642020
X-HE-Meta: U2FsdGVkX186Yf5MvHtWwLKqh8GZxHMykeP9FFt8dp/6VL+gSAn4/bCvI2RcEPvGb9dgAfixAaGU6ucpTobHCivCiKVmqiGRcvEZr63ORbGk8aQ1/7deEaqHH0BarhUAk+nOUuRctdl2mku+F/Y2smbrJLWHJ4r8PNi+0nl+r4Tf+LtLXXxws/HAGLVao5hjviTNEfcs98FgmM2virBeI8T5zR9NPlmPq/YM7fIBY/WMr7cy6kb6rQRGn5JIux3igDECvE37BruNh11hMICI3o776mEfcOcCd8okOeEDwmr5HvPrFlzAsJFe0PApPtpfVghvaQsZGgCkd11NsVI/iGLa1WanQHSgzdo3CAQyowKt1dTSjBLEQEqomurUSW2LsdQBntp/iaSJDo1Ysl9TqjVqYXUYlbLQDFRzheFQfjkcVMx6CIpqbwIhbLoepmTnzNCXP5U/kZTRYVyinIa8bGE/8DrzIBFOEHcyeeFaI11UeDMRLFsjZgQZtGdDH8ypNEOpNVonK9xsxRxnM6bK01XInTE0Uw1nmE6yp62hnYqTjnZjMjE/XtmnHdYkifWV1AZwE8tYdwiuuqLhhwlH4vub3oLJzGtHFIsXy1Dc5dUZJrHAdriUu5s6PMPCg5cYtBvjNQCe21tHSN+/k8C8kwHXHnyeLJi1sMcIRqRq1WDUJdz55N7YDkTUaOdLwQPry/TQFDj81xAkR0CEv4tVQDnChvTK9TytHODtI8yZ+yGRivxZpBRFImUusCZgcx3A4PRj226RKsyedWlOtMOfb6IQm14XvEfyIVmcuDpJZogTQ1H57WTazPhz6uDCW6HGVM3IlWTXTkv6lOZT61vc8N0x74Ithp4Tvhmqn0H6nc5U7MfJ+uC4hmpXHYWRIAQAlmJ+7Ly+WUTVF6Eb4fgSnWrUzXjtbfbiImhs7VmHgEdeG8KVYBCDItMgNQBcFDTJvkDi53jHy1/0BUjXETY
 S9jBoyJD
 9yRyLxepflH0hNgf+QhkzH8jK7uLV217mZf5uNt9uQU9g0Ew726ax530Szc773VM++l/tttgCSNXNIUl5Trkh8JyRXsZHPP8UFH/YMd0+UGEkFjWi0akKGmPJRZiWj16QFebBQ+Ph6vzah6lUNooiWi+OmI8bnTgPZPHgLJPdO7MnbWCgVAz1CFziVdjVxWUqm04xRpW9T9o92WRqxm4NX/YCwaxETUZPbguNs8Xq/HIf9AteJJYxpvKRLA==
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
 tools/testing/selftests/ftrace/config              |  3 +
 .../test.d/dynevent/add_remove_uprobe_overlayfs.tc | 96 ++++++++++++++++++++++
 2 files changed, 99 insertions(+)

diff --git a/tools/testing/selftests/ftrace/config b/tools/testing/selftests/ftrace/config
index 29f05f7c6e2ce..05325737e4a5f 100644
--- a/tools/testing/selftests/ftrace/config
+++ b/tools/testing/selftests/ftrace/config
@@ -19,6 +19,7 @@ CONFIG_KPROBE_EVENTS=y
 CONFIG_MAGIC_SYSRQ=y
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
+CONFIG_OVERLAY_FS=y
 CONFIG_PREEMPTIRQ_DELAY_TEST=m
 CONFIG_PREEMPT_TRACER=y
 CONFIG_PROBE_EVENTS_BTF_ARGS=y
@@ -30,6 +31,8 @@ CONFIG_SAMPLE_TRACE_PRINTK=m
 CONFIG_SCHED_TRACER=y
 CONFIG_STACK_TRACER=y
 CONFIG_SYNTH_EVENTS=y
+CONFIG_TMPFS=y
+CONFIG_TMPFS_XATTR=y
 CONFIG_TRACER_SNAPSHOT=y
 CONFIG_UPROBES=y
 CONFIG_UPROBE_EVENTS=y
diff --git a/tools/testing/selftests/ftrace/test.d/dynevent/add_remove_uprobe_overlayfs.tc b/tools/testing/selftests/ftrace/test.d/dynevent/add_remove_uprobe_overlayfs.tc
new file mode 100644
index 0000000000000..a29065dd76900
--- /dev/null
+++ b/tools/testing/selftests/ftrace/test.d/dynevent/add_remove_uprobe_overlayfs.tc
@@ -0,0 +1,96 @@
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
+  echo 0 > events/enable
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
+if ! setfattr -n trusted.overlay.metacopy $OVL/lower/sh; then
+  echo "No tmpfs xattr support. skipped."
+  exit_unsupported
+fi
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


