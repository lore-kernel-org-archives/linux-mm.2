Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 91386C5DF8C
	for <linux-mm@archiver.kernel.org>; Fri, 21 Aug 2026 18:58:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 00B726B00AE; Fri, 21 Aug 2026 14:58:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F004B6B00B1; Fri, 21 Aug 2026 14:58:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB43D6B00AE; Fri, 21 Aug 2026 14:58:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 90C7C6B00AF
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 14:58:22 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id EA612160221
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 18:58:21 +0000 (UTC)
X-FDA: 85126187202.18.98F022B
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf07.hostedemail.com (Postfix) with ESMTP id BB5BD40007
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 18:58:19 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=WGn09rux;
	spf=pass (imf07.hostedemail.com: domain of echanude@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=echanude@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787338699;
	b=cFzHCJIb0iEZp1bTdz8aY7uOSF+/oF/9O22DF0AlJVNge4Si0bXFHbUTuzykJ5LlW+sKeU
	FMopDcc+RrxbUyGnYTujZ8Ab2K9frreGcr69bBn14mJ26mR+0uw4AT4sGG/Sm7nhE+Vp9m
	5oYwpq05iVvGAUr1ZRcuNhdcrjGIIhU=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=WGn09rux;
	spf=pass (imf07.hostedemail.com: domain of echanude@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=echanude@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787338699;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jb8nkZgnYdLG8ktPFayByOUpa/ch44LcnfTYgPP/10M=;
	b=EmiaCVky/qaaJQSZVXR959Vh6ah88fM+vtPtrOTBOi8PJZHXEKgHa26Bi9US2tOcP+2hN5
	Zm84+09PFUl4bMP0f9t9s2tOez1tAoTP5Fjar1t2tzIXfebRVz7iX74AqDelljG7rS4p1W
	wC/DCrcV7Cw7HNcZnysFjYIkuaqdp4Q=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1787338699;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jb8nkZgnYdLG8ktPFayByOUpa/ch44LcnfTYgPP/10M=;
	b=WGn09ruxLARoiVw+dOCdZ/UgKxiaFEaBGheLFLpjIA8ELh4ENi23hdm8KA6JMj0/8JChCK
	s8ugd6PC03UQcYPZGjLuBXjxV9vvzSrE6oINgQZUzROMh71jjb4PTCzce1y1EpW3JGnHq3
	FukJ/kaOUKqZKX5nLDf87l95Ce+9NlI=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-435-xLmTUgbSOdaod-fjKDfx6g-1; Fri, 21 Aug 2026 14:58:12 -0400
X-MC-Unique: xLmTUgbSOdaod-fjKDfx6g-1
X-Mimecast-MFC-AGG-ID: xLmTUgbSOdaod-fjKDfx6g_1787338691
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-9368f2b7b2bso135911785a.0
        for <linux-mm@kvack.org>; Fri, 21 Aug 2026 11:58:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787338691; x=1787943491;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=jb8nkZgnYdLG8ktPFayByOUpa/ch44LcnfTYgPP/10M=;
        b=g85GjQqQA56Bj0it+KtN9tmniEsjLbc2MWIISAs+jdGC+pNo9jFiOXQ2eyuuoaegIM
         gE08d9PhlIacXXvghnjisZPSeC5TVHCiFaKTYTonwlCRTPeZa5qTepIIxmEjgcElIw7A
         TbWKMebKxkJwp9TwTL9SsYmkWklYyBgwzyj0ZgODWArhDe4hxIBcpC5jY/oKyEQn2WMC
         c7C2Yqy69HwwIO2FuDMuQU/7y+b8fPMcsE/uS0oBLD/4KyOIkTJ3HsGccNYt8sodGRcd
         rdKNPaSE/woiXOAw6yMkC14g4PCY5lvk4LZJciZ6YAopx+ZrmFJPboK4O0paYRN7PABK
         5aLg==
X-Gm-Message-State: AFuF++nyKl0HTGF19BxmNohaI1pehdvkRe7df/vvV55AivBZW2EpBAe6
	P7teDuWJDjvXxiASGGVdQZf6gyQ89mjR04Mzet6BgIn8KxLByNq9yHQbkIpL86KHIdcEj+zmH24
	cqDiJd27X1AShDcBXOp50Hm54bMCQVivIcIwNcpIV6JTGiBXRuZlS
X-Gm-Gg: AR+sD12A4nYZW4YarrNtkJXPVQTWXmvOIsreV5CBP3fqWyC520u4b9LARZH75E36E3f
	m6fzSAG4A6s0k9+39eWVl+vP9DHIFNdS2StH5tlI5n0v65aDVuGmtzGWx8jqhboBbv7wzcBJLvW
	2irdw6PNVrDpVqX6EOmn755Ygc3McMn8/ov8iL5lEvn++WYECOTYe0wH/egMWeD07tDM3g0TE11
	e1xVp5KADG1GMRbAfIrd5YBuyIkA+ePqYgjYMEDJZB9SY30EKFsp65zCV2AJ1ujh16EAuJWOnwv
	JfBQ/6+zUAlwFOPwplLAxIyDqZvLCIBCa2b5I1AQmOcRjvZskHsIm5A669el0zhIrmyC21maRv3
	j+JcJWSoDsIuAQrs4Xgh52qjj7caQdn2bWDUae0CHBrN/
X-Received: by 2002:a05:620a:6192:b0:915:9e84:85d1 with SMTP id af79cd13be357-9373952c7a5mr808448685a.23.1787338691134;
        Fri, 21 Aug 2026 11:58:11 -0700 (PDT)
X-Received: by 2002:a05:620a:6192:b0:915:9e84:85d1 with SMTP id af79cd13be357-9373952c7a5mr808442485a.23.1787338690612;
        Fri, 21 Aug 2026 11:58:10 -0700 (PDT)
Received: from localhost (pool-100-17-17-231.bstnma.fios.verizon.net. [100.17.17.231])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-937204b7b6bsm663030085a.20.2026.08.21.11.58.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Aug 2026 11:58:09 -0700 (PDT)
From: Eric Chanudet <echanude@redhat.com>
Date: Fri, 21 Aug 2026 14:57:01 -0400
Subject: [PATCH 09/11] selftests: cgroup: add a vmtest script for memcg
MIME-Version: 1.0
Message-Id: <20260821-cma-memcg-regions-v1-9-d21b165b8440@redhat.com>
References: <20260821-cma-memcg-regions-v1-0-d21b165b8440@redhat.com>
In-Reply-To: <20260821-cma-memcg-regions-v1-0-d21b165b8440@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Tejun Heo <tj@kernel.org>, 
 Johannes Weiner <hannes@cmpxchg.org>, 
 =?utf-8?q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
 Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
 Shuah Khan <shuah@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 cgroups@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, Maxime Ripard <mripard@redhat.com>, 
 Albert Esteve <aesteve@redhat.com>, Eric Chanudet <echanude@redhat.com>
X-Mailer: b4 0.14.3
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: fbN0TTyBzaBKWKjmw0-z6AnL4qlnibwDASXQJXh7YiQ_1787338691
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: BB5BD40007
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: ffd4xkmoxtwu4nyp3e179t3mmju17n39
X-HE-Tag: 1787338699-571385
X-HE-Meta: U2FsdGVkX1/qALT5Vq8jAQIjP0HZXtQzTHeQHNXn1b3KUa0KvgCGtEme2e4dkBXLTLKlf+vLct983y6kq3HztuYhQuh+dhguCDCJeitgqBQTp0QiqyPGHZuDV2kBgDXcX/fx8eyKhwajm3zVYxKU+Zi3RVMWUwRSeKjwNTsHwEYNhHZV9KoMrbXUGoM8/3so3ZDjF3EcDkq7p/vS2AzAEItDM+TBqdXikU07K3SAluip3SFAjqJiMVde2pl0FKcCxYi71i+Pskj1WSw7hItVNFIy+Bx4qMVFRAijURl2njl03ro7PFm3gbjaWnbs1N8M+nosNvArgmrewN9UL1R/jucZw8uzU9dGYQbswaq53UM5S6L6B0/ed9GMyyTHbP3NYerB9ePNMZsJQ3vM7ApF7ii8+rgQ560qljbpjweCbgx/tx5Pm4MjgHwPCdrjPMASXCKqV5+p+0NYTFTcJas6BqWyQFRv5JludhhFARRgpvoayptkenauANJvmtDHjyD6PxOzD9Ewxzylz5jkjQLUaheSDZ+S/Uz9AFgE7Z5kyuy4lhKR3b2x1iTIwTwK+MIx8ukFUfHVrUhir5x5ARJt18606Sl4VRLqldjzpQ2pd5gsFknnxn8TEb/gaPPPf9iQW0plRmYHdOArOQHRCy8gjGI82s+o2UGBMjeuiCYOMBGgItHvpyO68cMUgGB+d9nXUpi6UgBrJgRK9s4PEH98bpeXj91X7NVUqtJPvyo+K4F3s1hOC8NhAa7MPU7zq6Yq9qpgI3+QhFmKunZZrR6nVQQsKVxPMWbDkuAmhIQruWXY3rqKvm0KMBf3VzVVkymVfNfRbY/JuoxIYO2+axkayFAC/cPdvx+pR2LS5RWZNdEFf+Q/Ipnkuw9SO4AHFE8UxXnd8Z0/mTYkekR+UjMlarb1g6QJF4XDeZOGCEPMk0M8ClVR69Z+WkdZJMVFrz0T6Lt7t285oxkhdf9MriL
 QfmF2I5F
 c07OZ7sJiTfw+wiDXcCbjgVcr4XfLRrEWrEly+jnN9/A4M1N0+lUSKIe81wGUHCRFc3QzAMxZJgChquscMIHosJw31ghEMG5n9iI0WhWbVC8pm6gMzg0ixgC7uon/3LLMYhrZesvxzgXudEK4+XBauPXQQ8x6PYAqCiZslbYByJ+rlkJ2OckkzOUVKUOzZHD1ysbsa/lpZm76P4O4EIugZbFhAOWiL8T87zJTXFxWazWdSeKWRZsVXeUMTTA7InA7pZci92YD2Vh35bXtVNTHX6+To6VP1XJt1uy8LDxUiA9Yoom8QrWPdE3UiI8dtlG9ux7vhiviqizQzZ+Q2k2nVgeVbi9q3HkQhyytCDaorZ4iMstSa0n9y++kdGmEA9UpzCryxjNzwj4eTfg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Following dmem's example[1], add a vmtest-memcg.sh to provide a
repeatable VM workflow using virtme-ng for memcg tests.

Boot a VM using virtme-ng with cma=64M in its kargs and enable
memory_cma_accounting on cgroupfs, then run the cgroup tests inside the
guest.

Provide -b to build the kernel first, -q to use a different qemu binary,
-s to start a shell in the VM, and -v for verbose boot.

[1] https://lore.kernel.org/all/20260706-kunit_cgroups-v5-3-6c42c8753468@redhat.com/

Signed-off-by: Eric Chanudet <echanude@redhat.com>
---
 tools/testing/selftests/cgroup/vmtest-memcg.sh | 196 +++++++++++++++++++++++++
 1 file changed, 196 insertions(+)

diff --git a/tools/testing/selftests/cgroup/vmtest-memcg.sh b/tools/testing/selftests/cgroup/vmtest-memcg.sh
new file mode 100755
index 000000000000..b19b96731784
--- /dev/null
+++ b/tools/testing/selftests/cgroup/vmtest-memcg.sh
@@ -0,0 +1,196 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+#
+# Copyright (c) 2026 Red Hat, Inc.
+#
+# Run cgroup memory controller selftests inside a virtme-ng VM
+# Dependencies:
+#		* virtme-ng
+#		* busybox-static (used by virtme-ng)
+#		* qemu	(used by virtme-ng)
+
+set -euo pipefail
+
+readonly SCRIPT_DIR="$(cd -P -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
+readonly KERNEL_CHECKOUT="$(realpath "${SCRIPT_DIR}"/../../../../)"
+
+source "${SCRIPT_DIR}"/../kselftest/ktap_helpers.sh
+
+readonly SSH_GUEST_PORT="${SSH_GUEST_PORT:-22}"
+readonly WAIT_PERIOD=3
+readonly WAIT_PERIOD_MAX=80
+readonly WAIT_TOTAL=$((WAIT_PERIOD * WAIT_PERIOD_MAX))
+readonly QEMU_PIDFILE="$(mktemp /tmp/qemu_memcg_vmtest_XXXX.pid)"
+readonly QEMU_OPTS=" --pidfile ${QEMU_PIDFILE} "
+
+BUILD=0
+QEMU="qemu-system-$(uname -m)"
+VERBOSE=0
+SHELL_MODE=0
+GUEST_TREE="${GUEST_TREE:-$KERNEL_CHECKOUT}"
+
+usage() {
+	cat <<EOF
+$0 [OPTIONS]
+    -b        Build kernel from source tree before booting
+    -q <qemu> QEMU binary/path (default: $QEMU)
+    -s        Start interactive shell in VM
+    -v        Verbose output (vng boot logs on stdout)
+EOF
+	exit 1
+}
+
+die() {
+	echo "$*" >&2
+	exit "${KSFT_FAIL}"
+}
+
+cleanup() {
+	if [[ -s "$QEMU_PIDFILE" ]]; then
+		pkill -SIGTERM -F "$QEMU_PIDFILE" >/dev/null 2>&1 || true
+	fi
+
+	if [[ -e "$QEMU_PIDFILE" ]]; then
+		rm -f "$QEMU_PIDFILE"
+	fi
+}
+
+vm_ssh() {
+	stdbuf -oL ssh -q \
+		-F "$HOME/.cache/virtme-ng/.ssh/virtme-ng-ssh.conf" \
+		-l root "virtme-ng%$SSH_GUEST_PORT" \
+		"$@"
+}
+
+check_deps() {
+	for dep in vng "$QEMU" busybox pkill ssh; do
+		if ! command -v "$dep" >/dev/null 2>&1; then
+			echo "skip: dependency $dep not found"
+			exit "$KSFT_SKIP"
+		fi
+	done
+}
+
+handle_build() {
+	if [[ ! "$BUILD" -eq 1 ]]; then
+		return
+	fi
+
+	if [[ ! -d "$KERNEL_CHECKOUT" ]]; then
+		echo "-b requires $0 to be called from the kernel source tree" >&2
+		exit 1
+	fi
+
+	pushd "$KERNEL_CHECKOUT" &>/dev/null
+
+	if ! vng --kconfig --config "$SCRIPT_DIR"/config; then
+		die "failed to generate .config for kernel source tree ($KERNEL_CHECKOUT)"
+	fi
+
+	if ! make -j"$(nproc)"; then
+		die "failed to build kernel from source tree ($KERNEL_CHECKOUT)"
+	fi
+
+	popd &>/dev/null
+}
+
+vm_start() {
+	local logfile=/dev/null
+	local verbose_opt=""
+	local kernel_opt=""
+
+	if [[ "$VERBOSE" -eq 1 ]]; then
+		verbose_opt="--verbose"
+		logfile=/dev/stdout
+	fi
+
+	if [[ "$BUILD" -eq 1 ]]; then
+		kernel_opt="${KERNEL_CHECKOUT}"
+	fi
+
+	vng \
+		--run \
+		${kernel_opt} \
+		${verbose_opt} \
+		--qemu-opts="$QEMU_OPTS" \
+		--qemu="$(command -v "$QEMU")" \
+		--user root \
+		--ssh "$SSH_GUEST_PORT" \
+		--append "cma=64M" \
+		--rw &>"$logfile" &
+
+	local vng_pid=$!
+	local elapsed=0
+
+	while [[ ! -s "$QEMU_PIDFILE" ]]; do
+		kill -0 "$vng_pid" 2>/dev/null || \
+			die "vng exited early; failed to boot VM"
+		[[ "$elapsed" -ge "$WAIT_TOTAL" ]] && \
+			die "timed out waiting for VM boot"
+		sleep 1
+		elapsed=$((elapsed + 1))
+	done
+}
+
+vm_wait_for_ssh() {
+	local i=0
+	while true; do
+		vm_ssh -- true && break
+		i=$((i + 1))
+		[[ "${i}" -gt "$WAIT_PERIOD_MAX" ]] && \
+			die "timed out waiting for guest ssh"
+		sleep "$WAIT_PERIOD"
+	done
+}
+
+check_guest_requirements() {
+	vm_ssh -- "grep -q memory /sys/fs/cgroup/cgroup.controllers" \
+		|| die "memory controller not available (CONFIG_MEMCG?)"
+	vm_ssh -- "[[ -e /dev/dma_heap/default_cma_region ]]" \
+		|| die "CMA heap not available (CONFIG_DMABUF_HEAPS_CMA? cma= cmdline?)"
+}
+
+setup_guest_cma_accounting() {
+	vm_ssh -- "mount -o remount,memory_cma_accounting /sys/fs/cgroup" \
+		|| die "failed to enable memory_cma_accounting"
+	vm_ssh -- "echo +memory > /sys/fs/cgroup/cgroup.subtree_control" \
+		|| die "failed to enable memory controller"
+}
+
+run_test() {
+	vm_ssh -- "cd '$GUEST_TREE' && make -C tools/testing/selftests TARGETS=cgroup"
+	vm_ssh -- "cd '$GUEST_TREE' && make -C tools/testing/selftests TARGETS=cgroup run_tests"
+}
+
+while getopts ":hvq:sb" opt; do
+	case "$opt" in
+	v) VERBOSE=1 ;;
+	q) QEMU="${OPTARG}" ;;
+	b) BUILD=1 ;;
+	s) SHELL_MODE=1 ;;
+	h|*) usage ;;
+	esac
+done
+
+trap cleanup EXIT
+
+check_deps
+handle_build
+echo "Booting virtme-ng VM..."
+vm_start
+vm_wait_for_ssh
+echo "VM is reachable via SSH."
+
+if [[ "$SHELL_MODE" -eq 1 ]]; then
+	echo "Starting interactive shell in VM. Exit to stop VM."
+	vm_ssh -t -- "cd '$GUEST_TREE' && exec bash --noprofile --norc"
+	exit "$KSFT_PASS"
+fi
+
+check_guest_requirements
+setup_guest_cma_accounting
+
+echo "Running cgroup selftests in VM..."
+run_test
+echo "PASS: cgroup selftests completed"
+exit "$KSFT_PASS"

-- 
2.53.0


