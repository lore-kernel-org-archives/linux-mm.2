Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A7AB6D2FEC5
	for <linux-mm@archiver.kernel.org>; Tue, 27 Jan 2026 17:33:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 02F966B0088; Tue, 27 Jan 2026 12:33:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F1BDE6B0089; Tue, 27 Jan 2026 12:33:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E1E856B008A; Tue, 27 Jan 2026 12:33:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id D001E6B0088
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 12:33:47 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 815B01A02F8
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 17:33:47 +0000 (UTC)
X-FDA: 84378441294.23.3BEF159
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id B4BA1140002
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 17:33:45 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=l+tYxf3v;
	spf=pass (imf09.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769535225;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=e2nQvrt9lI5xsNl7Oj+J5HucULIjVJ8qTrWRxidRDUs=;
	b=U61rHal7H98YMiBS4R2nAsi49q7ynSjQuC/Kp9L/pAaHEu94QrqZnsALxLeniiyOTD2Z8Y
	3hqHQqXuzliLSWD8jqNw6ZUZB9KC0xg59A11XDzgQ+O4OlgcqJtVHmC8+ireXsj253Zc9o
	b6TQYEz1S7C+qGqv84r6T1j+sQjS+ag=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=l+tYxf3v;
	spf=pass (imf09.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769535225; a=rsa-sha256;
	cv=none;
	b=D4a0rHqZ3tx7HQk46N3xrkPn6UA9E056eZ7MbrfGbNiWIpUZVnHwFcPt4b7bHddRMkkN4f
	+vLQbhCOWarGUGhpxZeN3S7UdGNjOHyOzhL7eF9SvdphBTyfttbw+i6NTVErxxM21Lx1Wg
	b1G2/5ew2v3XSJK8WsR6D3eChx1Hb38=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 5C80F4184B;
	Tue, 27 Jan 2026 17:33:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C901C116C6;
	Tue, 27 Jan 2026 17:33:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769535224;
	bh=VDV2QejitxZbWNUSVskuQWM0XB9UIqnmcALjTMWgxQk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=l+tYxf3vzAca8Xogv+g7mmnaMlmF04ptpPYfY7GkSkENIJRMAcm2Cil8usilEF5Q0
	 +88RfhhTjYC9a+2f9Tr9t7UGFQbl4x1FGmsXfNBxQveqYqy/UJBQF2FnZg3WKdm+PS
	 c1g7tV4jZznlfJHofw8QqjoTSrc40CqIARIQsc9g2pgqrQ6LIQZXusfTygvVztGUVh
	 FiPk79QAtwl0kmjs0mNafqC/L1Xl9pKwgyrz7eqv1GxVZIHz39qxjSnEn0bMhAl6eR
	 4qQRcD2uVYbiGGMY3nGlMGw8Aysd65OZK7Kikim9DDX20dRRvljlo7ik9m2SHRwDk8
	 84rRtOWaiW7tw==
Date: Tue, 27 Jan 2026 19:33:37 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Jordan Richards <jordanrichards@google.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>, Shuah Khan <shuah@kernel.org>,
	Jason Miu <jasonmiu@google.com>,
	David Matlack <dmatlack@google.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH] selftests/liveupdate: add end to end test infrastructure
 and scripts
Message-ID: <aXj28ZAsPhp7s5sm@kernel.org>
References: <20260122214427.3568647-1-jordanrichards@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260122214427.3568647-1-jordanrichards@google.com>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: B4BA1140002
X-Stat-Signature: 8fiytehw6o46mh5uc4qewb6ybpuopwsw
X-Rspam-User: 
X-HE-Tag: 1769535225-234475
X-HE-Meta: U2FsdGVkX1+MDBGftXU0GzayIAPJaBitHo0R5SZDz8y/l5PeqXOStaPBNh6b2qB4ZfcALAFX5/L3fjnEk1+puIFhBQh4wvOtDWaJ1vapJuL4aJVM0MuVg1qIUs5u2PGi945WddCz+YnKxNFb3EWdqB2R25LvMOBQKW3boKUuOlJBwReNF3PgIAoI4asWuZBxQLPpkAVBJz3cdPTfE47DsYW/+H8QRQMY/PIW/o/Rhmx2zQDjGaeBiG5LouRG2cY/mBnTZNPbGiSgbL/RckrdK4wBLoOGsj5OYcg4zrRGnw10aeGBIcjzyxA6tm2gCfBIOVCA1XY0zioCII/0EndPs4Bfzc+1uDFLKWDOsBZEL7Pf1IjDX/MzkACv0VSNKnJF1Ox9qSTNFrBMHpJcnrB0JiVQh6Yhad1K36G1yAqljrs+st4P1GOj6pYArKA9jUGfD8J22b6D/X2kmhTOZmciClQ/B6fJeiUvwJqsQXHN0kRE9i6XJHsZ3gZyHIK1+rNmFriFoK2ZZdk3ritPLuOvnpjSISJCOB1110TYJ99ovfhBQS47bmxDHMhe4DA1SWUlpPDs5J0qPNCQL935/58D7uouOoHrL0YDDe+uK/H57slJGXwGHKkCkiH107EOLkEEm0+KOEX7FedlHtUYQ0otqMlKbTHfW8CVWpuwa8oCvy0CSNaBACPdvrjmhV66iGrMjjFHQJQEGMkeGGD9BH9JC9pUWdbP4lUsV7z3PPgyIlD9MeuSrrmeUMXT/NH9GB2JgiwCJP/Imhk8YOyeNMQYVQANNF605/5YIHsxPAVK1pUKo4cHMIbzOg9g4EQdXKxht+APAQJyeK6YoZ/b+vLhVOG55WDoED5f9wvSRvy7GpIVaCl/jNoHNXZUZvCMTLCcSuOXTm9ha7VkoE4FcsmEdOdK/he2vs8pimugZ5Q2t5pJbzLYdPKPYVryeOrvlvu3BxnZYmdVIoiPGrzreqY
 G6IkOTf+
 V4TP76sfbgeRzaYjiThDVP55qnhH6adwsTuwCN+Ji5Xg+fpl/d5eRg8iSZ1oa1YHJeGzppSsaN6uXTKfNmw09+crCNhcoyFNHn7qWFEHrxbQGI1dqNvIKsohuW0VtvpV8Rc46jZiqcoopSa9hCywhyqK6JZtAogKRHLpSwoz+mV2zbVNK/m5tilrP0zxxpQHiWTRMEqfPsABjJ9ZDATZkAxFLKGXZ+MYDJF3D7nGMBc7Mz1O+Rz6cKUHNKGJ+a19DiB4eDIiZ+/mPmdFeyqzaMc2TtTAuSkbqTb5VjmxhxjFG8HwoyA6r4YgqEj4H4FGaE4pkszJosxQUK1y2vGihk6x4VmmRLvTegn+Lj3wTpK7BQiM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jan 22, 2026 at 09:44:27PM +0000, Jordan Richards wrote:
> From: Pasha Tatashin <pasha.tatashin@soleen.com>
> 
> Add the end to end testing infrastructure required to verify the
> liveupdate feature. This includes a custom init process, a test
> orchestration script, and a batch runner.
> 
> The framework consists of:
> 
> init.c:
> A lightweight init process that manages the kexec lifecycle.
> It mounts necessary filesystems, determines the current execution
> stage (1 or 2) via the kernel command line, and handles the
> kexec_file_load() sequence to transition between kernels.
> 
> luo_test.sh:
> The primary KTAP-compliant test driver. It handles:
> - Kernel configuration merging and building.
> - Cross-compilation detection for x86_64 and arm64.
> - Generation of the initrd containing the test binary and init.
> - QEMU execution with automatic accelerator detection (KVM, HVF,
>  or TCG).
> 
> run.sh:
> A wrapper script to discover and execute all `luo_*.c`
> tests across supported architectures, providing a summary of
> pass/fail/skip results.
> 
> Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> Co-developed-by: Jordan Richards <jordanrichards@google.com>
> Signed-off-by: Jordan Richards <jordanrichards@google.com>
> ---
> Changelog since luo v7 [1]:
> - Build test binaries with `-nostdlib -nostdinc`
> - Use minimal per-arch config instead of defconfig
> - Unhandled test errors now cause the test to fail instead of skip
> 
> [1] https://lore.kernel.org/all/20251122222351.1059049-20-pasha.tatashin@soleen.com/

...

> diff --git a/tools/testing/selftests/liveupdate/.gitignore b/tools/testing/selftests/liveupdate/.gitignore
> index 661827083ab6..7dc1e8aec44c 100644
> --- a/tools/testing/selftests/liveupdate/.gitignore
> +++ b/tools/testing/selftests/liveupdate/.gitignore
> @@ -6,4 +6,6 @@
>  !*.sh
>  !.gitignore
>  !config
> +!config.aarch64
> +!config.x86_64
>  !Makefile

Hmm, I missed it when tools/testing/selftests/liveupdate/ was posted.
I'm not a huge fun of negative logic in .gitignore.
Why can't we just exclude the patterns we don't want to track?

> +static int kexec_load(void)
> +{
> +	char cmdline[COMMAND_LINE_SIZE];
> +	int kernel_fd, initrd_fd, err;
> +	ssize_t len;
> +	int fd;
> +
> +	fd = open("/proc/cmdline", O_RDONLY);
> +	if (fd < 0) {
> +		fprintf(stderr, "INIT: Failed to read /proc/cmdline\n");
> +
> +		return -1;
> +	}
> +
> +	len = read(fd, cmdline, sizeof(cmdline) - 1);
> +	close(fd);
> +	if (len < 0)
> +		return -1;
> +
> +	cmdline[len] = 0;
> +	if (len > 0 && cmdline[len - 1] == '\n')
> +		cmdline[len - 1] = 0;
> +
> +	strncat(cmdline, " luo_stage=2", sizeof(cmdline) - strlen(cmdline) - 1);
> +
> +	kernel_fd = open(KERNEL_IMAGE, O_RDONLY);
> +	if (kernel_fd < 0) {
> +		fprintf(stderr, "INIT: Failed to open kernel image\n");
> +		return -1;
> +	}
> +
> +	initrd_fd = open(INITRD_IMAGE, O_RDONLY);
> +	if (initrd_fd < 0) {
> +		fprintf(stderr, "INIT: Failed to open initrd image\n");
> +		close(kernel_fd);
> +		return -1;
> +	}
> +
> +	err = kexec_file_load(kernel_fd, initrd_fd, strlen(cmdline) + 1,
> +			      cmdline, 0);
> +
> +	close(initrd_fd);
> +	close(kernel_fd);
> +
> +	return err ? : 0;

Just return err?

> diff --git a/tools/testing/selftests/liveupdate/luo_test.sh b/tools/testing/selftests/liveupdate/luo_test.sh
> new file mode 100755
> index 000000000000..90ecb16e87bb
> --- /dev/null
> +++ b/tools/testing/selftests/liveupdate/luo_test.sh

...

> +function detect_cross_compile() {
> +	local target=$1
> +	local host=$(uname -m)
> +

This function works fine if you run luo_test.sh directly or have cross
compilers named the way it expects in $PATH.

But if I run
CROSS_COMPILE=~/cross/gcc-13.2.0-nolibc/aarch64-linux/bin/aarch64-linux- ./run.sh
on x86, x86 tests fail

> +	if [ -n "$CROSS_COMPILE" ]; then
> +		return
> +	fi
> +
> +	[[ "$host" == "arm64" ]] && host="aarch64"
> +	[[ "$target" == "arm64" ]] && target="aarch64"
> +
> +	if [[ "$host" == "$target" ]]; then
> +		CROSS_COMPILE=""
> +		return
> +	fi
> +
> +	local candidate=""
> +	case "$target" in
> +		aarch64) candidate="aarch64-linux-gnu-" ;;
> +		x86_64)  candidate="x86_64-linux-gnu-" ;;
> +		*)       skip "Auto-detection for target '$target' not supported. Please set CROSS_COMPILE manually." ;;
> +	esac
> +
> +	if command -v "${candidate}gcc" &> /dev/null; then
> +		CROSS_COMPILE="$candidate"
> +	else
> +		skip "Compiler '${candidate}gcc' not found. Please install it (e.g., 'apt install gcc-aarch64-linux-gnu') or set CROSS_COMPILE."
> +	fi
> +}
> +
> +function build_kernel() {
> +	local build_dir=$1
> +	local make_cmd=$2
> +	local kimage=$3
> +	local target_arch=$4
> +
> +	local kconfig="$build_dir/.config"
> +	local common_conf="$test_dir/config"
> +	local arch_conf="$test_dir/config.$target_arch"
> +
> +	echo "# Building kernel in: $build_dir"
> +
> +	local fragments=()
> +
> +	if [[ -f "$common_conf" ]]; then
> +		fragments+=("$common_conf")
> +	fi
> +
> +	if [[ -f "$arch_conf" ]]; then
> +		fragments+=("$arch_conf")
> +	fi

I think the common and arch config fragments are required and we can just
assign fragments directly and run merge_config.sh.

> +
> +	if [[ ${#fragments[@]} > 1 ]]; then
> +		echo $fragments
> +		"$kernel_dir/scripts/kconfig/merge_config.sh" \
> +			-Q -m -O "$build_dir" "${fragments[@]}" >> /dev/null
> +	else
> +		cp ${fragments[0]} $kconfig
> +	fi
> +	cat $kconfig
> +
> +	$make_cmd olddefconfig
> +	$make_cmd "$kimage"
> +	$make_cmd headers_install INSTALL_HDR_PATH="$headers_dir"
> +}

...

> +function run_qemu() {
> +	local qemu_cmd=$1
> +	local cmdline=$2
> +	local kernel_path=$3
> +	local serial="$workspace_dir/qemu.serial"
> +
> +	local accel="-accel tcg"
> +	local host_machine=$(uname -m)
> +
> +	[[ "$host_machine" == "arm64" ]] && host_machine="aarch64"
> +	[[ "$host_machine" == "x86_64" ]] && host_machine="x86_64"
> +
> +	if [[ "$qemu_cmd" == *"$host_machine"* ]]; then
> +		if [ -w /dev/kvm ]; then
> +			accel="-accel kvm"
> +		fi
> +	fi

Do we care that much about qemu warnings about invalid accelerator to have
this logic here?

-accel kvm -accel hvf -accel tcg 

seems to cover all bases.

> +
> +	cmdline="$cmdline liveupdate=on panic=-1"
> +

...

> diff --git a/tools/testing/selftests/liveupdate/luo_test_utils.c b/tools/testing/selftests/liveupdate/luo_test_utils.c
> index 3c8721c505df..7ee80b6ed4cb 100644
> --- a/tools/testing/selftests/liveupdate/luo_test_utils.c
> +++ b/tools/testing/selftests/liveupdate/luo_test_utils.c
> @@ -13,6 +13,7 @@
>  #include <getopt.h>
>  #include <fcntl.h>
>  #include <unistd.h>
> +#include <sys.h>

This breaks running normal make:

luo_test_utils.c:16:10: fatal error: sys.h: No such file or directory
   16 | #include <sys.h>
      |          ^~~~~~~

NOLIBC specific includes and calls should be guarded with #ifdef NOLIBC

>  #include <sys/ioctl.h>
>  #include <sys/syscall.h>
>  #include <sys/mman.h>
> @@ -21,8 +22,20 @@
>  #include <errno.h>
>  #include <stdarg.h>
> 
> +#include <linux/unistd.h>
> +
>  #include "luo_test_utils.h"
> 
> +int sys_ftruncate(int fd, off_t length)
> +{
> +	return my_syscall2(__NR_ftruncate, fd, length);
> +}
> +
> +int ftruncate(int fd, off_t length)
> +{
> +	return __sysret(sys_ftruncate(fd, length));
> +}

These should be added to nolibc I suppose.

> +

,,,

> diff --git a/tools/testing/selftests/liveupdate/run.sh b/tools/testing/selftests/liveupdate/run.sh
> new file mode 100755
> index 000000000000..3f6b29a26648
> --- /dev/null
> +++ b/tools/testing/selftests/liveupdate/run.sh
> @@ -0,0 +1,68 @@
> +#!/bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +
> +OUTPUT_DIR="results_$(date +%Y%m%d_%H%M%S)"

I don't think that putting the results in the current directory rather than
in SCRIPT_DIR or in an explicitly named directory is a good idea.

> +SCRIPT_DIR=$(dirname "$(realpath "$0")")
> +TEST_RUNNER="$SCRIPT_DIR/luo_test.sh"
> +
> +TARGETS=("x86_64" "aarch64")
> +
> +GREEN='\033[0;32m'
> +RED='\033[0;31m'
> +YELLOW='\033[1;33m'
> +NC='\033[0m'
> +
> +PASSED=()
> +FAILED=()
> +SKIPPED=()
> +
> +mkdir -p "$OUTPUT_DIR"
> +
> +TEST_NAMES=()
> +while IFS= read -r file; do
> +    TEST_NAMES+=("$(basename "$file" .c)")
> +done < <(find "$SCRIPT_DIR" -maxdepth 1 -name "luo_*.c" ! -name "luo_test_utils.c")

I don't like name based detection of tests. Listing them explicitly seems a
viable option.

> +
> +if [ ${#TEST_NAMES[@]} -eq 0 ]; then
> +    echo "No tests found in $SCRIPT_DIR"
> +    exit 1
> +fi
> +

-- 
Sincerely yours,
Mike.

