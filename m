Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1E396CFA466
	for <linux-mm@archiver.kernel.org>; Mon, 24 Nov 2025 07:55:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B64916B0024; Mon, 24 Nov 2025 02:55:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B3C426B0026; Mon, 24 Nov 2025 02:55:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A51AF6B0027; Mon, 24 Nov 2025 02:55:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 93B606B0024
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 02:55:01 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 116E7884B1
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 07:54:59 +0000 (UTC)
X-FDA: 84144739518.26.33947B7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 34F39140006
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 07:54:57 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JKU9yvDN;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763970897;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gObRouH2WG+lY8kBxKL1QaiaFFXA8aAER56oxA2QyF8=;
	b=as8xAOREw+UxgwqjUEZqbkBthqUYP01q5EOBqMu7Jmu9ni94NCUU2RrlZZgq80+FZkUeNr
	PBIjcj+UT8UU+4MvEunHPdJzvJSOnMMBWkvhcm38XgtV7kLPqpWiX+paJS8W+m1/WeK+2x
	stpTUgMQPGlVj98hEz6UH+6gKA91l7k=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763970897; a=rsa-sha256;
	cv=none;
	b=oI206jr92G/vClk2WvC1zqvbYoe7pEVQEju3jvZA1YnDc1VJeUG/ocKyehNBo+jNnYNJBh
	HOtUVsDZaxOLYDWj8IqkFJWQAqvhgu1/rmrwV9bt8wm296AgjXZrN0S+XO7ARbK3usqLkZ
	ZvTpT/5i0Skk9/hXF3ENYq/7IvqTPNo=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JKU9yvDN;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E49F8417D8;
	Mon, 24 Nov 2025 07:54:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AAE4C16AAE;
	Mon, 24 Nov 2025 07:54:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763970895;
	bh=GxSzjePlSmo3UxO8BdvyDyDiWI+1rs3wnEyy6hlkCKQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=JKU9yvDNDyvfFrDA4ZITWehj+Dvbr5qW/VQsPyzWFvprnRUDIeYiuqLGKZNjPunnV
	 /SBIit0kYksz6HfSeIuvx/iHGsw8XMEvIK83ZDQLzC4PmXh4V/D1CJqli0Ll6d4TkE
	 SAyMv2W8VZJhTeX6UACR6f9l6bfXZ/k/SERlaFnFCBT15urJkAZwAIAyPUJv4d+VHJ
	 JkZ4x6uJfsfbrd5lPMj3R4Op0ePl4EDCwbc3pmcP6FMsyjrwiPJOt7i6LQdWkyRm1b
	 RTC8818U6PATHeFjxMvtXNKivl+uMltoaFYd2CJcQuAW5cQYV+Jtml2HanqnEen8H+
	 A3UZeELgzIcTg==
Date: Mon, 24 Nov 2025 09:54:30 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: pratyush@kernel.org, jasonmiu@google.com, graf@amazon.com,
	dmatlack@google.com, rientjes@google.com, corbet@lwn.net,
	rdunlap@infradead.org, ilpo.jarvinen@linux.intel.com,
	kanie@linux.alibaba.com, ojeda@kernel.org, aliceryhl@google.com,
	masahiroy@kernel.org, akpm@linux-foundation.org, tj@kernel.org,
	yoann.congal@smile.fr, mmaurer@google.com, roman.gushchin@linux.dev,
	chenridong@huawei.com, axboe@kernel.dk, mark.rutland@arm.com,
	jannh@google.com, vincent.guittot@linaro.org, hannes@cmpxchg.org,
	dan.j.williams@intel.com, david@redhat.com,
	joel.granados@kernel.org, rostedt@goodmis.org,
	anna.schumaker@oracle.com, song@kernel.org, linux@weissschuh.net,
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-mm@kvack.org, gregkh@linuxfoundation.org, tglx@linutronix.de,
	mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
	x86@kernel.org, hpa@zytor.com, rafael@kernel.org, dakr@kernel.org,
	bartosz.golaszewski@linaro.org, cw00.choi@samsung.com,
	myungjoo.ham@samsung.com, yesanishhere@gmail.com,
	Jonathan.Cameron@huawei.com, quic_zijuhu@quicinc.com,
	aleksander.lobakin@intel.com, ira.weiny@intel.com,
	andriy.shevchenko@linux.intel.com, leon@kernel.org, lukas@wunner.de,
	bhelgaas@google.com, wagi@kernel.org, djeffery@redhat.com,
	stuart.w.hayes@gmail.com, ptyadav@amazon.de, lennart@poettering.net,
	brauner@kernel.org, linux-api@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, saeedm@nvidia.com,
	ajayachandra@nvidia.com, jgg@nvidia.com, parav@nvidia.com,
	leonro@nvidia.com, witu@nvidia.com, hughd@google.com,
	skhawaja@google.com, chrisl@kernel.org
Subject: Re: [PATCH v7 19/22] selftests/liveupdate: add test infrastructure
 and scripts
Message-ID: <aSQPNuFIv0rRr2tp@kernel.org>
References: <20251122222351.1059049-1-pasha.tatashin@soleen.com>
 <20251122222351.1059049-20-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20251122222351.1059049-20-pasha.tatashin@soleen.com>
X-Stat-Signature: rgupk7c7w5t7k77ba1h1n8agjrdnqzif
X-Rspam-User: 
X-Rspamd-Queue-Id: 34F39140006
X-Rspamd-Server: rspam10
X-HE-Tag: 1763970897-470699
X-HE-Meta: U2FsdGVkX19mZ9IGaRHC1fMFczpVcpRFWyOBWZh+7uKq3aDPVC3/Hu6lFLELb7wxL8ru3EtNEkfFtuUvMAus7mDM3Gd4/zd9771cMoyLHbNmcRdSQNvf10tqSmeEK2cPOPLb2foV+ag84VL8cD50VGxP/4fvIWtjMI7DRDuhGk3Hc7GXU6ycVD0N898ktTZV7aiX66Wi3M6xG5JLQXg6DkxhaPX6Bry9CL+ME/DHtQEFExokj8W+ag+91w8RZx8BJMTausUh3yWypSGvmzCeEAu0Kwc0P1Gu7k0gSTGe65tPv1jSHi2yIbULORnPmVvinmZbE+OyRoZlw0M7u+eqYJ1YocQVFaFOvZZ/27dibCzq3FnzcyaVyzR/fRI/KsdmEV34a0+yvvSL1uG1kxedLmkMwcKuKlpISmyJuEScNHzvxIA16/KSNh5o41FT6BtnjdQMDykr34MJ3GzJgjorODSiabQozvZwf1brFmbIvAmSaMGnzeSi+e6bw+3mEzgk6g0CnQRkVQIjHyUP3FLJJ19+CF6tmwZECf2c2cRQK60INbSXIQ4sgBDbnm3RdtK90lYeAnAk6xb8Ky7CGyMLea0Dl/AHmuIiOE3EhOVJgL8tu7XSxRC25Hvijyfs7qobbeP761EKW/x6lVUC/9TQfrL9WPQUQc5k50X75VwQFH6B5AkxVEbWTOVtGhVQoQghAUCQEFfkQlllo0YSmiTrOP1wXkx/Sh6ImITuLQyrDPajUZejjHWwI50TMGLylu+qM2IBRRszzsQqcpncOaxP/0nKqptm+k88F5lEOwVOINaOEOre7IiffCHu+IqMDZCIewA0Tk+DDKweYJbzQoTOpBUxiO1W+MrZLGMoxocu0TFINn6+Lt5LecHHuqlKRBC9TRZ61lwWEoy0mth6LYdTPTrPF6huKU73bxlq1paTYbP2bvBwpiTEXKLapS98Y4DthmqiH0XOHCjQ2IJv1n8
 wArZIjfQ
 Uos275ERgP+Wmxnxp9v3fncVeBvnK93ZhzZea7Rz/ZqX7vKif/RPRhuNlaDD02ooLn02gfUWbrrkX9R8xv7E/g855Ez/0QZdxm0MPGVyC8Cc/sLqgaZ4c1aucAr6MFHO4vIkjFCVJDRMAqK6+HvuJ2k47mnkRnnbfEQXCeZEeGfIBJc+L8Ajig7X/eQb6oovWz8GVGlfke1EXP6HqKVouKFYj7ZgMz3idJtnvB7G3lt1gMwgQ5Cike1KcqGJq14X7mZkKgv6l+FXZHeeG4Ll7eM/XvjBrtMDzk90CwY7wL1VkgUMBLygENRV+VTSgAynxwVtADAwQT0KS/i6kdg+xnBaIMkKkrrmxkmnx3BGp7sQZWy5FpRJQZVwVnmdwCLmWMtoBxjutmfagsVi/Bu8JUF9a9iLHu4wy/33I
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Nov 22, 2025 at 05:23:46PM -0500, Pasha Tatashin wrote:
> Subject: [PATCH v7 19/22] selftests/liveupdate: add test infrastructure and scripts

Maybe                                                ^ end to end

> Add the testing infrastructure required to verify the liveupdate
> feature. This includes a custom init process, a test orchestration
> script, and a batch runner.

And say here that it's end to end test.
 
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
> ---
>  tools/testing/selftests/liveupdate/init.c     | 174 ++++++++++
>  .../testing/selftests/liveupdate/luo_test.sh  | 296 ++++++++++++++++++
>  tools/testing/selftests/liveupdate/run.sh     |  68 ++++
>  3 files changed, 538 insertions(+)
>  create mode 100644 tools/testing/selftests/liveupdate/init.c
>  create mode 100755 tools/testing/selftests/liveupdate/luo_test.sh
>  create mode 100755 tools/testing/selftests/liveupdate/run.sh
> 

...

> +static int is_stage_2(void)
> +{
> +	char cmdline[COMMAND_LINE_SIZE];
> +	ssize_t len;
> +	int fd;
> +
> +	fd = open("/proc/cmdline", O_RDONLY);
> +	if (fd < 0)
> +		return 0;
> +
> +	len = read(fd, cmdline, sizeof(cmdline) - 1);
> +	close(fd);
> +
> +	if (len < 0)
> +		return 0;

Shouldn't we bail out of the test if read of command line failed?

> +
> +	cmdline[len] = 0;
> +
> +	return !!strstr(cmdline, "luo_stage=2");
> +}
> +

...

> +function cleanup() {
> +	local exit_code=$?
> +
> +	if [ -z "$workspace_dir" ]; then
> +		ktap_finished
> +		return
> +	fi
> +
> +	if [ $exit_code -ne 0 ]; then
> +		echo "# Test failed (exit code $exit_code)."
> +		echo "# Workspace preserved at: $workspace_dir"
> +	elif [ "$KEEP_WORKSPACE" -eq 1 ]; then
> +		echo "# Workspace preserved (user request) at: $workspace_dir"
> +	else
> +		rm -fr "$workspace_dir"
> +	fi
> +	ktap_finished

	exit $exit_code

> +}

...

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
> +	$make_cmd defconfig
> +
> +	local fragments=""
> +	if [[ -f "$common_conf" ]]; then
> +		fragments="$fragments $common_conf"
> +	fi

Without this CONFIG_LIVEUPDATE won't be set
> +
> +	if [[ -f "$arch_conf" ]]; then
> +		fragments="$fragments $arch_conf"
> +	fi
> +
> +	if [[ -n "$fragments" ]]; then
> +		"$kernel_dir/scripts/kconfig/merge_config.sh" \
> +			-Q -m -O "$build_dir" "$kconfig" $fragments >> /dev/null
> +	fi

I believe you can just

	cat $common_conf $fragments >  $build_dir/.config
	make olddefconfig

without running defconfig at the beginning
It will build faster, just make sure to add CONFIG_SERIAL_ to $arch_conf

> +	$make_cmd olddefconfig
> +	$make_cmd "$kimage"
> +	$make_cmd headers_install INSTALL_HDR_PATH="$headers_dir"
> +}
> +
> +function mkinitrd() {
> +	local build_dir=$1
> +	local kernel_path=$2
> +	local test_name=$3
> +
> +	# 1. Compile the test binary and the init process

Didn't find 2. ;-)
Don't think we want the numbering here, plain comments are fine

> +	"$CROSS_COMPILE"gcc -static -O2 \
> +		-I "$headers_dir/include" \
> +		-I "$test_dir" \
> +		-o "$workspace_dir/test_binary" \
> +		"$test_dir/$test_name.c" "$test_dir/luo_test_utils.c"

This will have hard time cross-compiling with -nolibc toolchains

> +
> +	"$CROSS_COMPILE"gcc -s -static -Os -nostdinc -nostdlib		\
> +			-fno-asynchronous-unwind-tables -fno-ident	\
> +			-fno-stack-protector				\
> +			-I "$headers_dir/include"			\
> +			-I "$kernel_dir/tools/include/nolibc"		\
> +			-o "$workspace_dir/init" "$test_dir/init.c"

This failed for me with gcc 14.2.0 (Debian 14.2.0-19):

/home/mike/git/linux/tools/testing/selftests/liveupdate/init.c: In function ‘run_test’:
/home/mike/git/linux/tools/testing/selftests/liveupdate/init.c:111:65: error: initializer element is not constant
  111 |             static const char *const argv[] = {TEST_BINARY, stage_arg, NULL};
      |                                                             ^~~~~~~~~

/home/mike/git/linux/tools/testing/selftests/liveupdate/init.c:111:65: note: (near initialization for ‘argv[1]’)
/home/mike/git/linux/tools/testing/selftests/liveupdate/init.c:113:37: error: passing argument 2 of ‘execve’ from incompatible pointer type [-Wincompatible-pointer-types]
  113 |                 execve(TEST_BINARY, argv, NULL);
      |                                     ^~~~
      |                                     |
      |                                     const char * const*
In file included from /home/mike/git/linux/tools/testing/selftests/liveupdate/init.c:16:
/usr/include/unistd.h:572:52: note: expected ‘char * const*’ but argument is of type ‘const char * const*’
  572 | extern int execve (const char *__path, char *const __argv[],
      |                                        ~~~~~~~~~~~~^~~~~~~~

> +
> +	cat > "$workspace_dir/cpio_list_inner" <<EOF
> +dir /dev 0755 0 0
> +dir /proc 0755 0 0
> +dir /debugfs 0755 0 0
> +nod /dev/console 0600 0 0 c 5 1

Don't you need /dev/liveupdate node?

> +file /init $workspace_dir/init 0755 0 0
> +file /test_binary $workspace_dir/test_binary 0755 0 0
> +EOF
> +
> +	# Generate inner_initrd.cpio
> +	"$build_dir/usr/gen_init_cpio" "$workspace_dir/cpio_list_inner" > "$workspace_dir/inner_initrd.cpio"
> +
> +	cat > "$workspace_dir/cpio_list" <<EOF
> +dir /dev 0755 0 0
> +dir /proc 0755 0 0
> +dir /debugfs 0755 0 0
> +nod /dev/console 0600 0 0 c 5 1

And here as well.

> +file /init $workspace_dir/init 0755 0 0
> +file /kernel $kernel_path 0644 0 0
> +file /test_binary $workspace_dir/test_binary 0755 0 0
> +file /initrd.img $workspace_dir/inner_initrd.cpio 0644 0 0
> +EOF
> +
> +	# Generate the final initrd
> +	"$build_dir/usr/gen_init_cpio" "$workspace_dir/cpio_list" > "$initrd"
> +	local size=$(du -h "$initrd" | cut -f1)
> +}
> +
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

Just pass both kvm and tcg and let qemu complain.

> +		fi
> +	fi
> +
> +	cmdline="$cmdline liveupdate=on panic=-1"
> +
> +	echo "# Serial Log: $serial"
> +	timeout 30s $qemu_cmd -m 1G -smp 2 -no-reboot -nographic -nodefaults	\
> +		  $accel							\
> +		  -serial file:"$serial"					\
> +		  -append "$cmdline"						\
> +		  -kernel "$kernel_path"					\
> +		  -initrd "$initrd"
> +
> +	local ret=$?
> +
> +	if [ $ret -eq 124 ]; then
> +		fail "QEMU timed out"
> +	fi
> +
> +	grep "TEST PASSED" "$serial" &> /dev/null || fail "Liveupdate failed. Check $serial for details."
> +}

-- 
Sincerely yours,
Mike.

