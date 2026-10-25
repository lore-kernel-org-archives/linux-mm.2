Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 73CA7606A31B
	for <linux-mm@archiver.kernel.org>; Sun, 25 Oct 2026 16:47:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=f5b5Tin9
Received: by kanga.kvack.org (Postfix)
	id 72D6A6B05B2; Sun, 25 Oct 2026 12:47:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6DE326B05B3; Sun, 25 Oct 2026 12:47:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5F5466B05B4; Sun, 25 Oct 2026 12:47:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2670F6B05B2
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 12:47:26 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 85430A812A
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 16:47:25 +0000 (UTC)
X-FDA: 85361729250.04.6D1E643
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id E48D8140005
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 16:47:23 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=f5b5Tin9;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of sashal@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashal@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792946844;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=VKSqiYoNV2dByJKpxVMj7QeloSi8EsWCiTvTbPWvl+0=;
	b=wYwTEEPWpBCYgGzoKegjMpaXmxC6e83/EPUIQXeP9ImaSY8dL01ujS56atmhNLEeW903+n
	e32s0oS4pMWVfP/hKhFmPz1ierRrjBXbPBdB0m365nB4EljZ6e8pVOwdnvun632Xhrd5Jh
	u8zfVxtciKwpser1uYtVVqInPmoBhnI=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=f5b5Tin9;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of sashal@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashal@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792946844;
	b=fMG1iZnGF2nN6KBxlNYmx/IFdfP34xOMZKATGJ765ZjA0eH1fg25YZqDpHa7NrxmKL4ENf
	hbS5K9aD2kucuU7PTmrdIuY6g3pEj9OA/090WcTPa7H69G3tu4kQOWRP+ByhWBHTm81h7Y
	T9V1vqB5zm3r49NhE9q9+gZVNTiHd+0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id CA57B409C1;
	Sun, 25 Oct 2026 16:47:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F4E51F01825;
	Sun, 25 Oct 2026 16:47:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792946842;
	bh=VKSqiYoNV2dByJKpxVMj7QeloSi8EsWCiTvTbPWvl+0=;
	h=From:To:Cc:Subject:Date;
	b=f5b5Tin9u2Wpyny2CDyLlZaIlurlFe2XXMxLakNe+IPOrn4Y+19ADTdhEUpoU+LrM
	 bIfLv+Yob6sndJJJx+MRVaZS1hhH4m3bed/pU161JpQVPldd38sAOPxnNu4MrS1JES
	 xWRxAqIlNavZlXlmUBaPVq7FDd+A+q/nAW1js5khsevfP0zmUUX1YbP93Z+6PJfhOe
	 nsIFcrjNt9TkGcd+bwQ54H61xakInzU2jsst8wYritKNi0RE8kmz7xYvYYOIC52zlg
	 4HS3FX914Z+C5z89uDVOih834gZUeEtX/1I2J7nuPxxk1md7gW9gBlVmZRpd2i/IfL
	 8cLSosHxbjNVw==
From: Sasha Levin <sashal@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Sasha Levin <sashal@kernel.org>,
	linux-kernel@vger.kernel.org,
	linux-api@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kbuild@vger.kernel.org,
	linux-doc@vger.kernel.org,
	Christian Brauner <brauner@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Nathan Chancellor <nathan@kernel.org>,
	Nicolas Schier <nsc@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [GIT PULL] Kernel API specification framework for v7.4
Date: Sun, 25 Oct 2026 12:47:19 -0400
Message-ID: <20261025164719.1831477-1-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: E48D8140005
X-Stat-Signature: nd8t5ixsunxxxy4mr8up57wpk6gquymj
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-24.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792946843-789826
X-HE-Meta: U2FsdGVkX1/huN/oX52IdrnALx48lO2FZQBsPkN7eUd3W8ftapU8KeZkRxMMQByx7NeNROAeFTVTFLSBEPpk/SXMQyT88YmbZxy+adryD5r6epVHHxWzQ0ULY7IBGW/MsPr8rNar9Io0mvt7RxPeqIvan39OTDdhS0DzhRcmahgGBCdsVIAhVX6c9loH10j88EBwkJ0/ZF5zjWzC4gsL3YDPgfZcuPB7IvsIIS+M1Tpxv/x82naJ+KKVCJMFV4iRV0Z8Vwrrv1vCkMm52yAaTBDmiVBMY//IA7V5v/fVuctZLg+/mN7uMyRc3ZgCaimhZ+Zin5vs32qVPOIogbqxELZ8N8iE1S7Dldlv7mOx7HqaQcWnwU5ha4d8WrCAm3E1MOKoK/19vAlfL6DIAZVTO8Pr4Px9g8gBv2PQGAEZbnc+yC85HTfDHzQtemAMznLvvrn5uTpSuafCjz9/+xAFJ9XiSlrgiNpvTmWULoDi08FbXps4lkYLmcr7a8fn2nNRSaU0ZQVkdsG/0Un8yxfPnPR2sUnRwI85vQ3KVG7Kztt3PuzWN8Hmxf9KEyEvo3iYbXE0DjJRMmbERC0zYqItJHA1BdpOw2bFHX05qLUnqiWdkcynEa20r5fT2dt/EVnszmIglVGEarra62WQmLktL9epY8+ftI6jD27IdjpV2+GH4vRvTtHWLlLmSiVUyfVxMmy07hklzptzHZ063T06FooTKS7xAabQZpBluNEdkUuYSZpIZbItguS6eYFvmmg0dspbLP+zKx2Z2XW4AGz1E4cq1ZZHdB1zZWl9PSk6Yam4WXQpzq3EYTDd1hjDQ/+/5BD4ydOuyPYIHYkwTHrxkBU921aSJUB4s57hzecm8R6Mz4Ef0TzQ62RRvNGZY8CdAFUOq6gJf4Cb2I6ZZkk8ZEEkSAn1htClDdlLvbHeEscv2OCqpdeCYbI9ZcDP8abeQc8Nbl1fng3taACB2sh
 DmA7cI2h
 dQeBmkGLTUyLMxaQ46lIpoR7ZExy59lc7EqGp7GFdJMEGYeph3ULazi3epPHidfr1G+U8ImAVJQK6UwlGWlgywAp7GWWwZQ+2lp73oxZHoKnIv31yRIsGoioEKlYJbXTtEcjsuC02n/UArlOMl45af2wMe0RG2K3oJ8loPu9seUZbVzzLsEEExmeDPUMdINrPrP0CoB4hYcSo9p1C3kdLznjXOzvCZa02ExVICrkvA3RkU1g=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Linus,

Please consider pulling the kernel API specification framework. It has
been discussed on the lists for over a year: five RFC rounds starting in
June 2025, then v1 through v5 this year, the last on October 8:

  https://lore.kernel.org/all/20261008084956.2911790-1-sashal@kernel.org/

The branch has been in linux-next since next-20261009. I held off on
sending this until the first week of the merge window was over, to let
things calm down.

There are two conflicts with what you already merged. linux-next resolved
both the same way:

 - Makefile: kbuild added '*.header-check' to the clean rule at the same
   spot where this adds '*.apispec.h'. Keep both lines.

 - fs/open.c: vfs added filp_close_sync() just above sys_close(), which is
   where this adds the sys_close() kerneldoc. Keep filp_close_sync(), then
   the new kerneldoc, then the existing "Careful here!" comment and
   SYSCALL_DEFINE1(close).

The following changes since commit a90ee4305c4a5df72c11b31dacfdc76e00fcf78a:

  Linux 7.3-rc6 (2026-10-04 13:45:25 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/sashal/kapi.git tags/kapi-7.4

for you to fetch changes up to ef777ef05ebcc5ea5393b4bd5af6fc3ad1b3aec9:

  kernel/api: add syscall enter/exit tracepoints (2026-10-07 18:26:44 -0400)

----------------------------------------------------------------
Kernel API specification framework for v7.4

The contract of a kernel interface (which arguments are valid, which errors
come back and why, what context it can be called from, what it locks and
what it changes) only exists as prose in man pages and comments, which
tools cannot check. This adds a way to write that contract down in a form
that tools can consume, next to the code it describes.

A spec is structured kerneldoc covering parameter types and constraints,
return values and error codes, execution context, locking, signals,
capabilities and side effects. At build time kernel-doc turns it into C
data in a dedicated section of vmlinux. From there a spec can be:

 - checked against syscall arguments and return values at runtime by
   CONFIG_KAPI_RUNTIME_CHECKS, a DEBUG_KERNEL option for x86 and arches
   without syscall wrappers; a call that violates its spec fails with
   -EINVAL before the handler runs
 - read as JSON from debugfs
 - extracted from vmlinux, debugfs or the source with tools/kapi, which
   emits JSON, RST or plain text
 - followed with the kapi_syscall_enter/exit tracepoints

The first specs cover open, close, read, write and madvise, with a KUnit
suite and a selftest in tools/testing/selftests/kapi.

Everything is behind CONFIG_KAPI_SPEC, which defaults to off. With it off
the syscall definition macros expand as before, kernel-doc output is
unchanged, and the only change to fs/ and mm/ is the kerneldoc text.

----------------------------------------------------------------
Sasha Levin (11):
      kernel/api: introduce kernel API specification framework
      kernel/api: enable kerneldoc-based API specifications
      kernel/api: add debugfs interface for kernel API specifications
      tools/kapi: add kernel API specification extraction tool
      kernel/api: add API specification for sys_open
      kernel/api: add API specification for sys_close
      kernel/api: add API specification for sys_read
      kernel/api: add API specification for sys_write
      kernel/api: add runtime verification selftest
      kernel/api: add API specification for sys_madvise
      kernel/api: add syscall enter/exit tracepoints

 .gitignore                                       |    1 +
 Documentation/dev-tools/index.rst                |    1 +
 Documentation/dev-tools/kernel-api-spec.rst      |  648 +++++
 MAINTAINERS                                      |   13 +
 Makefile                                         |    1 +
 arch/x86/include/asm/syscall_wrapper.h           |    3 +-
 fs/open.c                                        |  557 ++++
 fs/read_write.c                                  |  710 +++++
 include/asm-generic/vmlinux.lds.h                |   14 +
 include/linux/kapi_syscall.h                     |   35 +
 include/linux/kernel_api_spec.h                  | 1226 ++++++++
 include/linux/syscalls.h                         |   42 +-
 include/trace/events/kapi.h                      |   74 +
 init/Kconfig                                     |    2 +
 kernel/Makefile                                  |    1 +
 kernel/api/Kconfig                               |   74 +
 kernel/api/Makefile                              |   13 +
 kernel/api/internal.h                            |   25 +
 kernel/api/kapi_debugfs.c                        |  553 ++++
 kernel/api/kapi_kunit.c                          |  720 +++++
 kernel/api/kernel_api_spec.c                     | 1470 ++++++++++
 mm/madvise.c                                     |  549 ++++
 scripts/Makefile.build                           |   26 +
 tools/docs/kernel-doc                            |   12 +-
 tools/kapi/.gitignore                            |    3 +
 tools/kapi/Cargo.lock                            |  679 +++++
 tools/kapi/Cargo.toml                            |   20 +
 tools/kapi/Makefile                              |   33 +
 tools/kapi/README.md                             |   33 +
 tools/kapi/src/extractor/debugfs.rs              | 1704 +++++++++++
 tools/kapi/src/extractor/kerneldoc_parser.rs     | 3335 ++++++++++++++++++++++
 tools/kapi/src/extractor/mod.rs                  |  442 +++
 tools/kapi/src/extractor/source_parser.rs        |  531 ++++
 tools/kapi/src/extractor/vmlinux/binary_utils.rs |  461 +++
 tools/kapi/src/extractor/vmlinux/mod.rs          | 1160 ++++++++
 tools/kapi/src/formatter/json.rs                 |  659 +++++
 tools/kapi/src/formatter/mod.rs                  |  220 ++
 tools/kapi/src/formatter/plain.rs                |  679 +++++
 tools/kapi/src/formatter/rst.rs                  |  802 ++++++
 tools/kapi/src/main.rs                           |  123 +
 tools/lib/python/kdoc/kdoc_apispec.py            | 1391 +++++++++
 tools/lib/python/kdoc/kdoc_files.py              |   12 +-
 tools/lib/python/kdoc/kdoc_parser.py             |  101 +-
 tools/testing/selftests/Makefile                 |    1 +
 tools/testing/selftests/kapi/.gitignore          |    2 +
 tools/testing/selftests/kapi/Makefile            |    7 +
 tools/testing/selftests/kapi/kapi_test_util.h    |   31 +
 tools/testing/selftests/kapi/test_kapi.c         | 1163 ++++++++
 48 files changed, 20350 insertions(+), 12 deletions(-)
 create mode 100644 Documentation/dev-tools/kernel-api-spec.rst
 create mode 100644 include/linux/kapi_syscall.h
 create mode 100644 include/linux/kernel_api_spec.h
 create mode 100644 include/trace/events/kapi.h
 create mode 100644 kernel/api/Kconfig
 create mode 100644 kernel/api/Makefile
 create mode 100644 kernel/api/internal.h
 create mode 100644 kernel/api/kapi_debugfs.c
 create mode 100644 kernel/api/kapi_kunit.c
 create mode 100644 kernel/api/kernel_api_spec.c
 create mode 100644 tools/kapi/.gitignore
 create mode 100644 tools/kapi/Cargo.lock
 create mode 100644 tools/kapi/Cargo.toml
 create mode 100644 tools/kapi/Makefile
 create mode 100644 tools/kapi/README.md
 create mode 100644 tools/kapi/src/extractor/debugfs.rs
 create mode 100644 tools/kapi/src/extractor/kerneldoc_parser.rs
 create mode 100644 tools/kapi/src/extractor/mod.rs
 create mode 100644 tools/kapi/src/extractor/source_parser.rs
 create mode 100644 tools/kapi/src/extractor/vmlinux/binary_utils.rs
 create mode 100644 tools/kapi/src/extractor/vmlinux/mod.rs
 create mode 100644 tools/kapi/src/formatter/json.rs
 create mode 100644 tools/kapi/src/formatter/mod.rs
 create mode 100644 tools/kapi/src/formatter/plain.rs
 create mode 100644 tools/kapi/src/formatter/rst.rs
 create mode 100644 tools/kapi/src/main.rs
 create mode 100644 tools/lib/python/kdoc/kdoc_apispec.py
 create mode 100644 tools/testing/selftests/kapi/.gitignore
 create mode 100644 tools/testing/selftests/kapi/Makefile
 create mode 100644 tools/testing/selftests/kapi/kapi_test_util.h
 create mode 100644 tools/testing/selftests/kapi/test_kapi.c

-- 
Thanks,
Sasha

