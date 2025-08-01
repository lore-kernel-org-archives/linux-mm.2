Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76949C87FCA
	for <linux-mm@archiver.kernel.org>; Fri,  1 Aug 2025 11:00:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E5D8B6B008A; Fri,  1 Aug 2025 07:00:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E35E46B008C; Fri,  1 Aug 2025 07:00:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D4BAC6B0092; Fri,  1 Aug 2025 07:00:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BEC156B008A
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 07:00:08 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2786ABB9A9
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 11:00:08 +0000 (UTC)
X-FDA: 83727894096.09.AA73F71
Received: from todd.t-8ch.de (todd.t-8ch.de [159.69.126.157])
	by imf21.hostedemail.com (Postfix) with ESMTP id 3F5F91C000D
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 11:00:06 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=weissschuh.net header.s=mail header.b=h5XcAc7o;
	dmarc=pass (policy=quarantine) header.from=weissschuh.net;
	spf=pass (imf21.hostedemail.com: domain of linux@weissschuh.net designates 159.69.126.157 as permitted sender) smtp.mailfrom=linux@weissschuh.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754046006;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kTioCqvPRy4Kr/yOeoSKJ6C7AGXie8DKEeVszAcKMBk=;
	b=TEWzlRcmvWcIKnBwvP2LUjcuwc/zOdayQibTe9/6UQSp60WAFqO8LFqMK7tRFoQJQ8KvWC
	VBlKnx/2WzaArM3r10kUaj2sdo9SdlQvNbNsqIP0wcjKxRnionF0Tm/J0e9sLcDdUD4uYb
	c1qdRh2NwGlB3JxGkZudwQQqlEoi0NU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754046006; a=rsa-sha256;
	cv=none;
	b=rb5+dZai3Utgtd4cyAhW5hheSgaCdehBogWeL+TCRxr9I/VBUqErf2Fye96ZfyBbW8L1aM
	IW4VNpwMI7fqFpLx0ZGN4dtLj8ixvJq6hVtSycsKst7cGQHpMH996gBMwkxIfjsnVXOsZw
	1yje2/UhWM447ZaO+sNhOxh6AybBkYM=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=weissschuh.net header.s=mail header.b=h5XcAc7o;
	dmarc=pass (policy=quarantine) header.from=weissschuh.net;
	spf=pass (imf21.hostedemail.com: domain of linux@weissschuh.net designates 159.69.126.157 as permitted sender) smtp.mailfrom=linux@weissschuh.net
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=weissschuh.net;
	s=mail; t=1754046003;
	bh=SrU/DgzHeB8T3HhnNHwe7Wv/zYSsrNNui/GdxVK0W4E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=h5XcAc7orQ0efweZPqsyH2aaYb5dB1Cm4NdBXX4yXTCC1YJcN0it9EzLj5fUOjdl7
	 1xJ43F93jc3ed/QfN/z3CSPwtFqMIqL5SuLReiJH9l4Ch+Hg2+hdLkAcv8TJTkBdDh
	 WvSMwyX2w3I5uBA8hz//tzkBvBSQ2qqOri7p2I6k=
Date: Fri, 1 Aug 2025 13:00:03 +0200
From: Thomas =?utf-8?Q?Wei=C3=9Fschuh?= <linux@weissschuh.net>
To: Mike Rapoport <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Alexander Graf <graf@amazon.com>, Changyuan Lyu <changyuanl@google.com>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Pratyush Yadav <pratyush@kernel.org>, 
	Shuah Khan <shuah@kernel.org>, kexec@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v2] kho: add test for kexec handover
Message-ID: <fae1936d-3f45-44d4-a9b0-43b29115d5ac@t-8ch.de>
References: <20250801100630.3473918-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250801100630.3473918-1-rppt@kernel.org>
X-Stat-Signature: 988n8uoioyuxr1q6aibet1sc76kn35wq
X-Rspamd-Queue-Id: 3F5F91C000D
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-HE-Tag: 1754046005-579785
X-HE-Meta: U2FsdGVkX18qj3yjQnz8h+M+4i+o/tZ2w/vDtqy2loGsw+VNEXPpI3hwt1P1O6Xs7KJXyoBQfGxOYZOeWSjCth6V5Kv9zief09Mjcrh8xoLP34/ne4spwa/jijDgWMEyJ2m49Cu0//adsvfsotkNcKZRuyJpIEz8hg5LjetBJly+L+GZeePtu1gTpAWbS9KPr+4YpyLr2bqu8rfqcGarPd83AtVwJh6jo7xbBOTyZ/NqnUNx0gmmZJ4YlEFc7FfFWkZH9RItVCY1rBWCjV4wZpovYOODdRO2JpFiegOgubEe7zR1tDZdjp4ZLVdHdWtBWiqoNzyxyyXvYWCUfb9kgW90n/H1bnvolvfByGbDO1wPYXcDk9KKHnFskVUEYYnEN1FPDvDwJqm2jJkXTbq8aldVdS3dGA1bxlkREIA87It16YAO1LDEvOrFzpSkZfy0rWfrUAmkbsUWDC5KV3GtmS2jak9uEDK/a49Z5iqokBso8miLcr7X3oomIoZ4y/bADK+4dP9/bxQLoTaJoCDKz+zX/33jyiBvLyOQ8Te/525giF7NDzrHQ4+1HjHeIro7zv8/41zGVtpcTqenGJ1g1sCnySZvzgmBI5+r2V/ygOWRwlhFGr6K7Yaig+hl/TdkOrIaQafuU2AfMHAg3/AyorHi5a6TmKJ2geOtQV3Qp+8Jwp5tHP6cRiCNPfyb9nl8DjiPugxnQsVDSlHIA8s4+AvxIiYpFGoRcI0nFhmUt0slHk3nhKRkbvAAaozCgbynPdpKvpo+m+s7NJrqXvfGMhsWfbj2hBMQsh2p7K/rH1noYPUWOVMZurH7XTr2ZQDFjlFs47qrkitdRPtzBMHIKvrC9DVMUIwAbNj8N7jzKrsJLK1ifJOoa1xfMOl3af4wF3v5RCEEJtYlbUnPDfr0eO5+6uPLD6+wsVAETLqIVFUATuFIqaQkD21GjM6dsN5ajsvBB1HmAYoJ/ua2EKu
 DLlGgeKK
 ojcmsOn/YhvbZdhWlPqJVdGr2A/SS+pSRaSCkC0lcF4CH1vJsCMcxJ0jljwSFev5bHQM9j+8QRMVfhdgk0dpa/eLqVfnVim0C5SFb0VYLb+S5RqXwBUabh+RjCYg8fJnZ6HtP892+6oofisFwGwHi/IYUHA29qN/oWRy+kp7WI5Sz1HXyq94q2s9GGPiZKgahv0hHpQdJgangKkhBmW79866WYEhEJEGR7828FCRMEux+XPe1jpkqOr/w1B+JYXirhZHZgy/NwFC3Y2k=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025-08-01 13:06:30+0300, Mike Rapoport wrote:
> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> 
> Testing kexec handover requires a kernel driver that will generate some
> data and preserve it with KHO on the first boot and then restore that
> data and verify it was preserved properly after kexec.
> 
> To facilitate such test, along with the kernel driver responsible for
> data generation, preservation and restoration add a script that runs a
> kernel in a VM with a minimal /init. The /init enables KHO, loads a
> kernel image for kexec and runs kexec reboot. After the boot of the
> kexeced kernel, the driver verifies that the data was properly
> preserved.
> 
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

Looking at it while awake brought up some more nitpicks.
In any case:
Reviewed-by: Thomas Weißschuh <linux@weissschuh.net> # for the nolibc usage

> diff --git a/tools/testing/selftests/kho/init.c b/tools/testing/selftests/kho/init.c
> new file mode 100644
> index 000000000000..8044ca56fff5
> --- /dev/null
> +++ b/tools/testing/selftests/kho/init.c
> @@ -0,0 +1,98 @@
> +// SPDX-License-Identifier: GPL-2.0
> +
> +#include <errno.h>

Not actually used.

> +#include <stdio.h>
> +#include <unistd.h>
> +#include <fcntl.h>
> +#include <sys/syscall.h>
> +#include <sys/mount.h>
> +#include <sys/reboot.h>
> +
> +/* from arch/x86/include/asm/setup.h */
> +#define COMMAND_LINE_SIZE	2048
> +
> +/* from include/linux/kexex.h */

"kexec.h"

> +#define KEXEC_FILE_NO_INITRAMFS	0x00000004

This is actually part of the UAPI headers, why not use it from there?

> +
> +#define KHO_FINILIZE "/debugfs/kho/out/finalize"

KHO_FINALIZE

> +#define KERNEL_IMAGE "/kernel"
> +
> +static int mount_filesystems(void)
> +{
> +	if (mount("debugfs", "/debugfs", "debugfs", 0, NULL) < 0)
> +		return -1;
> +
> +	return mount("proc", "/proc", "proc", 0, NULL);
> +}
> +
> +static int kho_enable(void)
> +{
> +	const char enable[] = "1";
> +	int fd;
> +
> +	fd = open(KHO_FINILIZE, O_RDWR);
> +	if (fd < 0)
> +		return -1;
> +
> +	if (write(fd, enable, sizeof(enable)) != sizeof(enable))
> +		return 1;
> +
> +	close(fd);
> +	return 0;
> +}
> +
> +static long kexec_file_load(int kernel_fd, int initrd_fd,
> +			    unsigned long cmdline_len, const char *cmdline,
> +			    unsigned long flags)
> +{
> +	return syscall(__NR_kexec_file_load, kernel_fd, initrd_fd, cmdline_len,
> +		       cmdline, flags);
> +}
> +
> +static int kexec_load(void)
> +{
> +	char cmdline[COMMAND_LINE_SIZE];
> +	ssize_t len;
> +	int fd, err;
> +
> +	fd = open("/proc/cmdline", O_RDONLY);
> +	if (fd < 0)
> +		return -1;
> +
> +	len = read(fd, cmdline, sizeof(cmdline));
> +	close(fd);
> +	if (len < 0)
> +		return -1;
> +
> +	/* replace \n with \0 */
> +	cmdline[len - 1] = 0;
> +	fd = open(KERNEL_IMAGE, O_RDONLY);
> +	if (fd < 0)
> +		return -1;
> +
> +	err = kexec_file_load(fd, -1, len, cmdline, KEXEC_FILE_NO_INITRAMFS);
> +	close(fd);
> +
> +	return err ? : 0;
> +}
> +
> +int main(int argc, char *argv[])
> +{
> +	if (mount_filesystems())
> +		goto err_reboot;
> +
> +	if (kho_enable())
> +		goto err_reboot;
> +
> +	if (kexec_load())
> +		goto err_reboot;
> +
> +	if (reboot(RB_KEXEC))
> +		goto err_reboot;
> +
> +	return 0;
> +
> +err_reboot:
> +	reboot(RB_AUTOBOOT);
> +	return -1;
> +}
> diff --git a/tools/testing/selftests/kho/vmtest.sh b/tools/testing/selftests/kho/vmtest.sh
> new file mode 100755
> index 000000000000..3f6c17166846
> --- /dev/null
> +++ b/tools/testing/selftests/kho/vmtest.sh

(...)

> +function mkinitrd() {
> +	local kernel=$1
> +
> +	"$CROSS_COMPILE"gcc -s -static -Os -nostdinc -nostdlib \
> +			-fno-asynchronous-unwind-tables -fno-ident \
> +			-I "$headers_dir/include" \
> +			-I "$kernel_dir/tools/include/nolibc" \
> +			-o "$tmp_dir/init" "$test_dir/init.c"

You could build this as a userprog as part of kbuild.
Then it will also work automatically with clang.

> +
> +	cat > "$tmp_dir/cpio_list" <<EOF
> +dir /dev 0755 0 0
> +dir /proc 0755 0 0
> +dir /debugfs 0755 0 0
> +nod /dev/console 0600 0 0 c 5 1
> +file /init $tmp_dir/init 0755 0 0
> +file /kernel $kernel 0644 0 0
> +EOF
> +
> +	"$build_dir/usr/gen_init_cpio" "$tmp_dir/cpio_list" > "$initrd"

This could also be hooked up to kbuild.

> +}

(...)

