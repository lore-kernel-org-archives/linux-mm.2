Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C9277CD3426
	for <linux-mm@archiver.kernel.org>; Mon,  4 May 2026 09:33:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E31C06B0005; Mon,  4 May 2026 05:33:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DE3266B008A; Mon,  4 May 2026 05:33:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD1AF6B008C; Mon,  4 May 2026 05:33:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id BC3546B0005
	for <linux-mm@kvack.org>; Mon,  4 May 2026 05:33:37 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6583440302
	for <linux-mm@kvack.org>; Mon,  4 May 2026 09:33:37 +0000 (UTC)
X-FDA: 84729224874.16.542F66D
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf07.hostedemail.com (Postfix) with ESMTP id 6C13D40005
	for <linux-mm@kvack.org>; Mon,  4 May 2026 09:33:35 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=CkF4Ur92;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=Ne2XaM9e;
	dmarc=pass (policy=none) header.from=linutronix.de;
	spf=pass (imf07.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777887215; a=rsa-sha256;
	cv=none;
	b=F1woFGBDekRyrjiu0XhM9KWz3pmTbF+s7IIpwArkUpZFHM3V5RWWHjXiJYLN+2QiNsfy6+
	Ys/KaMrnsRwDn1Cmgay798/DXsqwVhxPsOv/GJziNCTbLlLcYSVjjs3fGFRv3IMeNu0up7
	HumkO7H8g8EKWgOdjjby+tQjNbSjXJA=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=CkF4Ur92;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=Ne2XaM9e;
	dmarc=pass (policy=none) header.from=linutronix.de;
	spf=pass (imf07.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777887215;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=jiw5cliQjVOVd7Hg7M7qqHEcA53QLkykbCEMKUj9V/4=;
	b=XJD8efNopJGKDdCx85Avc9DA0rJClP9xKCE+haV3RFZ+CVxiTaBGxCd45LP/HpsnbO3kFL
	Eeo91+2fvrPl1NZ8qRbeKdfr/5CZ03NFE5SDDwB2NUU4VLJ5T4RS4TL1NluznGHAEgrs1I
	ayQO/dwoUPAqfNXZX71Yp1H+ZvHXaLs=
From: =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1777887213;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=jiw5cliQjVOVd7Hg7M7qqHEcA53QLkykbCEMKUj9V/4=;
	b=CkF4Ur92AwTZrXO/sv6QGR6uZ0gVg6WWgj6BnkXL6F5RbU98XwApIIYsadlvw5FwHBbUle
	KCUF8wrjD1nFAaEC+LP7e3ieNZnEFRlj4rPux9WT4dGihNf7DTiGa4MzTqQ0qBuK90HVtb
	eTTv5ceRJC+vx74zomg8a1zLuIIoDXNawlOsUXZJsJqVZHcfzOCyfqr7cmFOx0cqf2W1m3
	9Ke/DHoO6Xun0TBR2CGg5bs3lgbv5gqf//6/upZusSDIqVi3uGPe6WMezvqZvUFMXdTag3
	SM2WVhET9UGxbAAdANHBdE1hwKfbCD4LbHC9dK3KfulAGRKlA0V/mm/+OBxQzA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1777887213;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=jiw5cliQjVOVd7Hg7M7qqHEcA53QLkykbCEMKUj9V/4=;
	b=Ne2XaM9eh1DjfbRR/wisAzh5vD9LeAq/Wx1SZRdaT2Nkb1bs9RWaUWN2krijC8nFY8z9Cq
	hsCmlkBXoqVqPyDQ==
Subject: [PATCH v6 00/11] kunit: Introduce UAPI testing framework
Date: Mon, 04 May 2026 11:33:16 +0200
Message-Id: <20260504-kunit-kselftests-v6-0-712d3d526d97@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/3XQQWrDMBAF0KsErauiGc1Ypqveo2RhS+NGJDjBc
 kxK8N0rhYJLqi6/4D8N/66STFGSetvd1SRLTPE85tC87JQ/dOOn6BhyVmiQwADr43WMsz4mOQ2
 zpDlpbtDZ3pMhQpVrl0mGeHuQH/ucDzHN5+nr8cMC5bVgbBDsX2wBbXTXW2fbwB2DvJ/ieJ2n8
 xhvr0GK/1N2/5QJe2Ikb3vTPZXLNQtuF5CpIVgQJgASbN0QaojdkAaggtiMMIsNQK3vfVND6Be
 CTQWhcknrGsOWBhm4hvCGuOomXJA8igPwQfB50P26rt970M1eBQIAAA==
X-Change-ID: 20241015-kunit-kselftests-56273bc40442
To: Nathan Chancellor <nathan@kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>, Willy Tarreau <w@1wt.eu>, 
 =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <linux@weissschuh.net>, 
 Brendan Higgins <brendan.higgins@linux.dev>, Shuah Khan <shuah@kernel.org>, 
 Jonathan Corbet <corbet@lwn.net>, Nicolas Schier <nicolas.schier@linux.dev>, 
 Kees Cook <kees@kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
 Christoph Hellwig <hch@lst.de>, Luis Chamberlain <mcgrof@kernel.org>, 
 David Gow <david@davidgow.net>, Rae Moar <raemoar63@gmail.com>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, kunit-dev@googlegroups.com, 
 linux-doc@vger.kernel.org, workflows@vger.kernel.org, linux-mm@kvack.org, 
 linux-fsdevel@vger.kernel.org, 
 =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>, 
 Christophe Leroy <chleroy@kernel.org>, Nicolas Schier <nsc@kernel.org>, 
 Masahiro Yamada <masahiroy@kernel.org>
X-Developer-Signature: v=1; a=ed25519-sha256; t=1777887211; l=9871;
 i=thomas.weissschuh@linutronix.de; s=20240209; h=from:subject:message-id;
 bh=jjFMDKdhbjQLZ+fcrbaCzSYxbFlqAxUmrc8TwIq24gA=;
 b=qOGf/9JYWpejLSdzdJlFIjDSwMfYxKdIYhfx+3gP9+i2EIhD8YSa1FSioTUt/I6UX+Q5JWZRD
 LmSMw75cIUZA/0vVN9hOfjuYLJ0o3WWN/JB2wWfvSs0qp4L2PmW3rUL
X-Developer-Key: i=thomas.weissschuh@linutronix.de; a=ed25519;
 pk=pfvxvpFUDJV2h2nY0FidLUml22uGLSjByFbM6aqQQws=
X-Stat-Signature: cwc88fbsdrd1tunn5x43xrwy6dpafi37
X-Rspam-User: 
X-Rspamd-Queue-Id: 6C13D40005
X-Rspamd-Server: rspam07
X-HE-Tag: 1777887215-420057
X-HE-Meta: U2FsdGVkX18YPIWupz7HriFY/X3CJ0z+5+AWLqDTbOIlAS5ix2rwYrYkAbiUTceEkMKjx4Lt6324dXNxq1jAw6JW1EtEsH61oQkS6eep+aAmdD8Baovhl0a7ngl5cMceGPqNYEnbGd/FRFAUKnAzuVD63Mslso7iP+yCZIOSxRUE2xaJmAKVuEh5DuEEqjRLLrr8pgdyc/zVaS1t1vOSqYjXc8kFyWNfI0qiHJsMrA57UulP0HAWNOaRTbRW7JSJqIKJckgYDn6yGzZUXx366m0ap9/ZVOC5VLo3qLO+d7DjNEE3GJRl6TtSB+CCKUXPyiIo06WjGx3rWdoSVT3yy9/MFgXGSGmYUiUf/PNqcpWZkuWhcBlaEaXfloDwf0i3l0yNNMFPoWjEvaEhe8cr7QFP3HnqQ3UnqPemn9kWsGSv05mtayltp+KOar2o1bfppkn9IQgHZYv/h6E4DmN1aV0iS5fxRdATvMXKIqcz+1Q5Gjq6hdGguPiopjKtkey3phunDm7AdyjFyOmKxEJBy56BFkVw45Qn67Bd/28N5mcB/3FGzERh8xbaWVTN7bRMbvejKIuecknjctzejnDuzpp/8nXc6LIUh7W5Yx81+1r/GcDDIlvVMOePsKoBgszgrn3UVi837QtfGhZY5KKsjq1F5732Gs82sIdeFRyJP5lVbq3Ms+DgHVkrkUPl8JJCFxYaZ2eY8m0Wd/iCR/uB7q9+hW7JLKb4pjHSrKXR+C9zu6Tx1Wy05PLx/jbVSHLy9DRPDSiTA+fJWSRclzeW8x6qGIkINl3DCSFXJjRT7cWkfBc9pmMLpYwI+T58nWpZmk+pKBPiFACF22L0KrOGttjcgyTCaEsrB/0eKSkMay8/pARf3RjZHifEKrWoRwGXnulFgB/nn1lXsgPsNO0zGbqjn1mKWkkgnZY981ft5IPFGLvezneVExRHv3YcyX3wB7IKBVccxC8rBouMeXv
 andH16uP
 rl6MLmy6Ej2h2OS57FsAGVbRWjMCNEzV8inq2thNfO5zBhiR5TmkRveUhT1TtSWQolGG+qO5LUBK/sTwPlpxaFOIYtlxf8QxOUf1k9LI6q5u3gs9En+vAyfXRgvpiofBEv0h9t7ccRRQf39eaUa45JkvcZmzOgg6XQnFY+8b0QQDKGvDbsFKAwS/zQUpsG5C0KO3jYPZA/hyKWlnqRtOEkvXfoTyuLAhgllqJ03XLgHzpE4dYmim1tAth7CNC8FaaUPLulfSka8yYM+4vS/OAeg5JrwPfTbOr/bT13ntg97IdlP+vqC1+SzYFrH9R5KDR/R5jCxKpvBoWt95udwb7LU5rlSDgni9uRuP437iKr6YqPp/DXDsrZo9azhHTMf52RS1z2eAhIYG6U88Hi4Pg5kCzUZmjxDqSQ4i9QrfTvVGosVLxCN87Mw/ItxpVZnQ5kD0TI8we1daVGBKmZF1VwfS4noyoChA9EdmBj823LB+FFK6iX9M2f2q7s7wgdlM3zOwMZHhjV+Dahel8B+mtSUJ7DzOicDOZYyY6H4UlGtsykzl+jeNd9gcq4m6LPS30Dkr4OTfwFjQz2vzP+1rOvgEQiKdIJtcJ/lkOtwFNl3UZ2WrpZjWtwFjmbCEF3A7kxaoLr/CQL0PJrfIg8wLVcmSxG18ai3UqnJU2M8RGEKtjEqrBs8VANIxfcPLf/ldPV91LNOSjIxaf+0JQO1sKbg//QafuwSaLGW5/lUedtxIDHQLOh1lwH9f1ZuZQBEi40uV6WteLH2GQFurX20qiZkEATRywfMjtHEkp2kVcUm3rSmGqq/hk4s07q9tmiQiPTrm+4bV+4DDonHgj4JwqgeKAfleqwD1w9JONJIdAtvTdvK+Pbyl7kGstmzsAqb097ePhccXACOFjP+RzkU834Q2Ducf6/tjFMKFapT5Wc8iSOaei0gKTQS5u9mwsOY7KXM2V5LjrqIoJabk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently testing of userspace and in-kernel API use two different
frameworks. kselftests for the userspace ones and Kunit for the
in-kernel ones. Besides their different scopes, both have different
strengths and limitations:

Kunit:
* Tests are normal kernel code.
* They use the regular kernel toolchain.
* They can be packaged and distributed as modules conveniently.

Kselftests:
* Tests are normal userspace code
* They need a userspace toolchain.
  A kernel cross toolchain is likely not enough.
* A fair amout of userland is required to run the tests,
  which means a full distro or handcrafted rootfs.
* There is no way to conveniently package and run kselftests with a
  given kernel image.
* The kselftests makefiles are not as powerful as regular kbuild.
  For example they are missing proper header dependency tracking or more
  complex compiler option modifications.

Therefore kunit is much easier to run against different kernel
configurations and architectures.
This series aims to combine kselftests and kunit, avoiding both their
limitations. It works by compiling the userspace kselftests as part of
the regular kernel build, embedding them into the kunit kernel or module
and executing them from there. If the kernel toolchain is not fit to
produce userspace because of a missing libc, the kernel's own nolibc can
be used instead.
The structured TAP output from the kselftest is integrated into the
kunit KTAP output transparently, the kunit parser can parse the combined
logs together.

Further room for improvements:
* Call each test in its completely dedicated namespace
* Handle additional test files besides the test executable through
  archives. CPIO, cramfs, etc.
* Expose the blobs in debugfs
* Provide some convience wrappers around compat userprogs
* Figure out a migration path/coexistence solution for
  kunit UAPI and tools/testing/selftests/

Output from the kunit example testcase, note the output of
"example_uapi_tests".

$ ./tools/testing/kunit/kunit.py run --kunitconfig lib/kunit example
...
Running tests with:
$ .kunit/linux kunit.filter_glob=example kunit.enable=1 mem=1G console=tty kunit_shutdown=halt
[11:53:53] ================== example (10 subtests) ===================
[11:53:53] [PASSED] example_simple_test
[11:53:53] [SKIPPED] example_skip_test
[11:53:53] [SKIPPED] example_mark_skipped_test
[11:53:53] [PASSED] example_all_expect_macros_test
[11:53:53] [PASSED] example_static_stub_test
[11:53:53] [PASSED] example_static_stub_using_fn_ptr_test
[11:53:53] [PASSED] example_priv_test
[11:53:53] =================== example_params_test  ===================
[11:53:53] [SKIPPED] example value 3
[11:53:53] [PASSED] example value 2
[11:53:53] [PASSED] example value 1
[11:53:53] [SKIPPED] example value 0
[11:53:53] =============== [PASSED] example_params_test ===============
[11:53:53] [PASSED] example_slow_test
[11:53:53] ======================= (4 subtests) =======================
[11:53:53] [PASSED] procfs
[11:53:53] [PASSED] userspace test 2
[11:53:53] [SKIPPED] userspace test 3: some reason
[11:53:53] [PASSED] userspace test 4
[11:53:53] ================ [PASSED] example_uapi_test ================
[11:53:53] ===================== [PASSED] example =====================
[11:53:53] ============================================================
[11:53:53] Testing complete. Ran 16 tests: passed: 11, skipped: 5
[11:53:53] Elapsed time: 67.543s total, 1.823s configuring, 65.655s building, 0.058s running

---
Changes in v6:
- Use usermode helper framework
- Trim now unnecessary new module exports
- Report unhandled output line
- Add SUPERH to ARCH_HAS_NOLIBC
- Remove non-integral patches submitted elsewhere
- Drop CC_CAN_LINK_STATIC support. It is based on CC_CAN_LINK which is
  currently being reworked.
- Use more cleanup helpers
- Split stdout/stderr forwarding into its own patch
- Link to v5: https://lore.kernel.org/r/20250717-kunit-kselftests-v5-0-442b711cde2e@linutronix.de

Changes in v5:
- Initialize output variable of kernel_wait()
- Fix .incbin with in-tree builds
- Keep requirement of KTAP tests to have a number which was removed accidentally
- Only synthesize KTAP subtest failure if the outer one is TestStatus.FAILURE
- Use -I instead of -isystem in NOLIBC_USERCFLAGS to populate dependency files
- +To filesystem developers to all patches
- +To Luis Chamberlain for discussions about usage of usermodehelper
  (see patches 6 and 12)
- Link to v4: https://lore.kernel.org/r/20250626-kunit-kselftests-v4-0-48760534fef5@linutronix.de

Changes in v4:
- Move Kconfig.nolibc from tools/ to init/
- Drop generic userprogs nolibc integration
- Drop generic blob framework
- Pick up review tags from David
- Extend new kunit TAP parser tests
- Add MAINTAINERS entry
- Allow CONFIG_KUNIT_UAPI=m
- Split /proc validation into dedicated UAPI test
- Trim recipient list a bit
- Use KUNIT_FAIL_AND_ABORT() over KUNIT_FAIL()
- Link to v3: https://lore.kernel.org/r/20250611-kunit-kselftests-v3-0-55e3d148cbc6@linutronix.de

Changes in v3:
- Reintroduce CONFIG_CC_CAN_LINK_STATIC
- Enable CONFIG_ARCH_HAS_NOLIBC for m68k and SPARC
- Properly handle 'clean' target for userprogs
- Use ramfs over tmpfs to reduce dependencies
- Inherit userprogs byte order and ABI from kernel
- Drop now unnecessary "#ifndef NOLIBC"
- Pick up review tags
- Drop usage of __private in blob.h,
  sparse complains and it is not really necessary
- Fix execution on loongarch when using clang
- Drop userprogs libgcc handling, it was ugly and is not yet necessary
- Link to v2: https://lore.kernel.org/r/20250407-kunit-kselftests-v2-0-454114e287fd@linutronix.de

Changes in v2:
- Rebase onto v6.15-rc1
- Add documentation and kernel docs
- Resolve invalid kconfig breakages
- Drop already applied patch "kbuild: implement CONFIG_HEADERS_INSTALL for Usermode Linux"
- Drop userprogs CONFIG_WERROR integration, it doesn't need to be part of this series
- Replace patch prefix "kconfig" with "kbuild"
- Rename kunit_uapi_run_executable() to kunit_uapi_run_kselftest()
- Generate private, conflict-free symbols in the blob framework
- Handle kselftest exit codes
- Handle SIGABRT
- Forward output also to kunit debugfs log
- Install a fd=0 stdin filedescriptor
- Link to v1: https://lore.kernel.org/r/20250217-kunit-kselftests-v1-0-42b4524c3b0a@linutronix.de

To: Nathan Chancellor <nathan@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
To: Willy Tarreau <w@1wt.eu>
To: Thomas Weißschuh <linux@weissschuh.net>
To: Brendan Higgins <brendan.higgins@linux.dev>
To: David Gow <davidgow@google.com>
To: Rae Moar <rmoar@google.com>
To: Shuah Khan <shuah@kernel.org>
To: Jonathan Corbet <corbet@lwn.net>
To: Nicolas Schier <nicolas.schier@linux.dev>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: linux-kbuild@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-kselftest@vger.kernel.org
Cc: kunit-dev@googlegroups.com
Cc: linux-doc@vger.kernel.org
Cc: workflows@vger.kernel.org
To: Kees Cook <kees@kernel.org>
To: Alexander Viro <viro@zeniv.linux.org.uk>
To: Christian Brauner <brauner@kernel.org>
To: Jan Kara <jack@suse.cz>
To: Christoph Hellwig <hch@lst.de>
To: Luis Chamberlain <mcgrof@kernel.org>
Cc: linux-mm@kvack.org
Cc: linux-fsdevel@vger.kernel.org
Cc: Nicolas Schier <n.schier@avm.de>
Signed-off-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>

---
Thomas Weißschuh (11):
      kbuild: doc: add label for userprogs section
      exec: add dirfd parameter to kernel_execve()
      umh: add dirfd parameter
      mount: add support for __free(kern_unmount)
      init: add nolibc build support
      kunit: qemu_configs: loongarch: Enable LSX/LSAX
      kunit: Introduce UAPI testing framework
      kunit: uapi: Forward test executable output to KUnit log
      kunit: uapi: Add example for UAPI tests
      kunit: uapi: Introduce preinit executable
      kunit: uapi: Validate usability of /proc

 Documentation/dev-tools/kunit/api/index.rst   |   5 +
 Documentation/dev-tools/kunit/api/uapi.rst    |  14 +
 Documentation/kbuild/makefiles.rst            |   2 +
 MAINTAINERS                                   |  11 +
 fs/coredump.c                                 |   2 +-
 fs/exec.c                                     |   4 +-
 include/kunit/uapi.h                          |  77 ++++++
 include/linux/binfmts.h                       |   2 +-
 include/linux/mount.h                         |   2 +
 include/linux/umh.h                           |   3 +-
 init/Kconfig                                  |   2 +
 init/Kconfig.nolibc                           |  16 ++
 init/Makefile.nolibc                          |  13 +
 init/main.c                                   |   2 +-
 kernel/module/kmod.c                          |   2 +-
 kernel/umh.c                                  |   9 +-
 lib/kobject_uevent.c                          |   2 +-
 lib/kunit/Kconfig                             |  16 ++
 lib/kunit/Makefile                            |  26 ++
 lib/kunit/kunit-example-test.c                |  15 ++
 lib/kunit/kunit-example-uapi.c                |  22 ++
 lib/kunit/kunit-test-uapi.c                   |  51 ++++
 lib/kunit/kunit-test.c                        |  24 +-
 lib/kunit/kunit-uapi.c                        | 351 ++++++++++++++++++++++++++
 lib/kunit/uapi-preinit.c                      |  68 +++++
 security/keys/request_key.c                   |   2 +-
 tools/testing/kunit/qemu_configs/loongarch.py |   2 +
 27 files changed, 732 insertions(+), 13 deletions(-)
---
base-commit: 813d26ba48f9e3909d39966857421500faef508a
change-id: 20241015-kunit-kselftests-56273bc40442

Best regards,
--  
Thomas Weißschuh <thomas.weissschuh@linutronix.de>


