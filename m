Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2B3A2C44512
	for <linux-mm@archiver.kernel.org>; Thu, 16 Jul 2026 14:54:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BFB2A6B00F6; Thu, 16 Jul 2026 10:54:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BAA526B00F7; Thu, 16 Jul 2026 10:54:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A4AAB6B00F9; Thu, 16 Jul 2026 10:54:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5CB4A6B00F6
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 10:54:37 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 74720801CA
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 14:45:11 +0000 (UTC)
X-FDA: 84994912422.28.8BE0F61
Received: from sender4-op-o15.zoho.com (sender4-op-o15.zoho.com [136.143.188.15])
	by imf30.hostedemail.com (Postfix) with ESMTP id 8094A80004
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 14:45:09 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.beauty header.s=zmail header.b=mACiqZj1;
	dmarc=pass (policy=none) header.from=linux.beauty;
	arc=pass ("zohomail.com:s=zohoarc:i=1");
	spf=pass (imf30.hostedemail.com: domain of me@linux.beauty designates 136.143.188.15 as permitted sender) smtp.mailfrom=me@linux.beauty
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784213109;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qdqO/dqsF7yjZrH4mg7qpw1lf9OYQ69PUl21BjI0kUE=;
	b=wZySov1c+csqNL47fl/gRO/ugb2mSL4ILBMM5moOrtSW+nTftIUdRao2ag4jRIuvZIAkEY
	/IIy1ylAgw//p3t8sxzTxHwIoCAtPhwP3muCcmITu8ggFNwulywF6jVUz9U+K2D63vE/Mw
	iusK/VrqzZQvh1/ubQIxNgUgvwRk9kY=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.beauty header.s=zmail header.b=mACiqZj1;
	dmarc=pass (policy=none) header.from=linux.beauty;
	arc=pass ("zohomail.com:s=zohoarc:i=1");
	spf=pass (imf30.hostedemail.com: domain of me@linux.beauty designates 136.143.188.15 as permitted sender) smtp.mailfrom=me@linux.beauty
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1784213109;
	b=r3vUKBJ3xT+DsIuGleEV/qe6VCPvNYL8nWJVAbjE2AtRWq5qa0WMuFrZhU1FqHaeO9B9eB
	+d4DLrhUhbfBWsTEytjQ957hmshRgdoa8GBbFWaajxMNC+6ImOuQRnE9DI8/ZOZ+9IJD/z
	BM6Hb4iH5cEO26akruIw1AmNAIwfxGE=
ARC-Seal: i=1; a=rsa-sha256; t=1784212550; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=JduyLb3z7uuZZIJZ/tG0Z6jN9XDjUExC/qvVKxwFUtJdijdpmAGGXX2igRxnJRNtp1KiGWvbhfWiSGv8tQhUwPg4qXGgqLV9H1InoXgATIjl/B5ipwYI0t3obyv5YPyrcFPhhOoTpxj2lp2LQEuB0Tri13MWZdF/UWcgoFxaHig=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1784212550; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=qdqO/dqsF7yjZrH4mg7qpw1lf9OYQ69PUl21BjI0kUE=; 
	b=jcyjrgoqasGbc8y4GB6LkaqE3TWMjVAXvKl2dAy/eF0aoStzCvI1VFkqqZDdCltojGgg3nS0W+jUE2I/ky+w5wqf1ZnymFCgyota9rucOFwReqdn6iOwmqaKb4xdih9zN+SQe7b5cDSb40UcdyS2DYa9TD6UOiKPY27hK8LtuHw=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=linux.beauty;
	spf=pass  smtp.mailfrom=me@linux.beauty;
	dmarc=pass header.from=<me@linux.beauty>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1784212550;
	s=zmail; d=linux.beauty; i=me@linux.beauty;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-ID:In-Reply-To:MIME-Version:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=qdqO/dqsF7yjZrH4mg7qpw1lf9OYQ69PUl21BjI0kUE=;
	b=mACiqZj1Qjc+gUj8Ys01AfNp6e12wk1ed/pzwjDhkRJERJYp6TCmd38aQFgoTXgt
	kyLlaxBZCMWmXSPX3sLCXpJTjIUAoKqcaX75aVly9Erb10J1FRqk1O9OxLIIf7tDHjE
	TJVjevIqIMB4M+95XXLCggMqNK+q6HWCUq962sFQ=
Received: by mx.zohomail.com with SMTPS id 1784212547429642.3160082187562;
	Thu, 16 Jul 2026 07:35:47 -0700 (PDT)
From: Li Chen <me@linux.beauty>
To: Christian Brauner <brauner@kernel.org>
Cc: Kees Cook <kees@kernel.org>,
	Gabriel Krisman Bertazi <krisman@kernel.org>,
	Josh Triplett <josh@joshtriplett.org>,
	Mateusz Guzik <mjguzik@gmail.com>,
	Andy Lutomirski <luto@kernel.org>,
	John Ericson <mail@johnericson.me>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <shuah@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Oleg Nesterov <oleg@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Paul Moore <paul@paul-moore.com>,
	Eric Paris <eparis@redhat.com>,
	=?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>,
	=?UTF-8?q?G=C3=BCnther=20Noack?= <gnoack@google.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Jan Kara <jack@suse.cz>,
	linux-api@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-doc@vger.kernel.org,
	audit@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	linux-arch@vger.kernel.org,
	linux-mm@kvack.org,
	Li Chen <me@linux.beauty>
Subject: [RFC PATCH 22/24] pidfd: expose spawn builder system calls
Date: Thu, 16 Jul 2026 22:31:48 +0800
Message-ID: <08700c80bff699de86def3904a5b6e91d09ffe19.1784204592.git.me@linux.beauty>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <cover.1784204592.git.me@linux.beauty>
References: <cover.1784204592.git.me@linux.beauty>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Rspamd-Queue-Id: 8094A80004
X-Stat-Signature: f5z4mtz3y6iu1ptp9pnd1akutqj3xi1p
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1784213109-291035
X-HE-Meta: U2FsdGVkX1+wEQVYzH6MZmz//IAMIu7z/N+QdlLlSlWmbToLm7djHK8M/G66zT7oPFvUUPSYyJ3YDeL8GoNBFFDSfYXry7j/6MhiRakIw8AtHoJ9ol2dsMFo3b26ZrQq4ixFfOrREMXmLh9FNC4cwnJPiC8+rXw2XcHa6TYHAVqauHJ5dBwAORmFfEYOrpRzpNjIO9kViYaoveG2vxBpweLFAi3Rw0RUWC1mCIRbt7P8J0P3q5RswgJ97EU1akV80Yb+Z38tbjDylQznO2dIyH4GJ6+ox9EN8H06q2+/zQvoiEdPzEboWgNehvudArFR5f7pWKtydrBsCv1PU6NHhT1esx+646bF0ElfEfaAhEMPxxgwpt/vr3cZQCch68DSjoZO8KENEX83uGMo3NsmC9k2xLmjNoZ2v7JW031PBskpPnn7LNOK4RqC05qb9TWPmkXc4Tcb0ef4y8295eZq9NK5XqsCXgR5A4rOk+iRqjg8eH43jOpR4/8pK0P3916oPBMa9YlsAKeg151bKISVtX/6if2qGhwc/+s8AaU2fyWMEnw18P+LF6XOlObzo7ehHuojsa/kQRUH/Uq7Q4uL8ugV02qncjc7b71Y1TXEofjTWR4gs7h94cMNA1TQ3O+y1GhMox4fBNlxN/ktQLOQrGz0bYX6M55SLAJ8ohK2c1PiJ3b1esODAb+1NGX7wknKCIIvfIr22jK48K7F/0MtS/i75gaCK5lpYTQ/MWpICWm91bdckl/IrG4So+JyPk0xw6jaBu1sPSID1iugEF7RFL7H/Q/VHu3JHFU8GOMkGKwH8BY4HrhJuBvJEC0Z7hZ6odp0z5LhjzUlKbDaznFfyw0flTS6R3s06ozF5Sph+0wrDEKMmsCXOc7L6YBMoA+G45o5ip7I3yfjtm9I2r2cJdFljm0+jioOZIFKPXt2c/rSqyiFwzZlvHehI/7RQdXXT8aubDB3JqU8q8HEXDo
 puuVfXVb
 WOCeU4pnisRXIEEzXhyEHS+j2OBY/JsVdL9BPqc6eu6zVgJOzTBLIuq1QtNRiFlUrptzAiOnLmJUVGeym1uGhSFH0G0xkdDObvSnRJUzOkTY5f+LY0igsGOCwoxhV++/XHSAJJ1c99bdLfSjtkAqT1Ox1URnClQ182bWFTH9qNKuuHaxmokqNuMw5zsyVZjkn/+toglI4/t92UmNErJbWHBHhg7GbQFcp8GSTJ2JHEfIbRw22mVLxeya/4iKNCek2Q55B4H+w9772AgOIaHS5lfv6VLD/ZIdW9kOjsZgyPvqIBmFrjWqQJwQwRVRcoARMK4A0YC3ca3+6sLRxeMqd+6a4T2Ywx+WFSyqdnfzMAQKDceb/mn5o8fa0XocL0LGQzEQbLmGH6QbDcfQ5b2H/bB1EINViNvjZdabCtRr2JtW/4LMUw5f/9sIIfdL9TLqhiyOf
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The preceding commits define the future-pidfd lifetime, configuration, and
run state machine without making them reachable from userspace. Each
preparatory step therefore remains bisectable without exposing a partial
process builder.

Make pidfd_open(0, PIDFD_EMPTY) create a taskless future pidfd and expose
pidfd_config() and pidfd_spawn_run(). Add the syscall declarations and
table entries together so the complete initial interface becomes reachable
at one commit boundary. Synchronize the lagging arm64 AArch32 perf mirror
through the current syscall table while adding the builder entries.

Assisted-by: Codex:gpt-5.6-sol
Signed-off-by: Li Chen <me@linux.beauty>
---
 arch/alpha/kernel/syscalls/syscall.tbl        |  2 ++
 arch/arm/tools/syscall.tbl                    |  2 ++
 arch/arm64/tools/syscall_32.tbl               |  2 ++
 arch/m68k/kernel/syscalls/syscall.tbl         |  2 ++
 arch/microblaze/kernel/syscalls/syscall.tbl   |  2 ++
 arch/mips/kernel/syscalls/syscall_n32.tbl     |  2 ++
 arch/mips/kernel/syscalls/syscall_n64.tbl     |  2 ++
 arch/mips/kernel/syscalls/syscall_o32.tbl     |  2 ++
 arch/parisc/kernel/syscalls/syscall.tbl       |  2 ++
 arch/powerpc/kernel/syscalls/syscall.tbl      |  2 ++
 arch/s390/kernel/syscalls/syscall.tbl         |  2 ++
 arch/sh/kernel/syscalls/syscall.tbl           |  2 ++
 arch/sparc/kernel/syscalls/syscall.tbl        |  2 ++
 arch/x86/entry/syscalls/syscall_32.tbl        |  2 ++
 arch/x86/entry/syscalls/syscall_64.tbl        |  2 ++
 arch/xtensa/kernel/syscalls/syscall.tbl       |  2 ++
 include/linux/syscalls.h                      |  7 +++++++
 include/uapi/asm-generic/unistd.h             |  8 +++++++-
 kernel/pid.c                                  | 19 ++++++++++++++++++-
 scripts/syscall.tbl                           |  2 ++
 tools/include/uapi/asm-generic/unistd.h       |  8 +++++++-
 .../arch/alpha/entry/syscalls/syscall.tbl     |  2 ++
 .../perf/arch/arm/entry/syscalls/syscall.tbl  |  2 ++
 .../arch/arm64/entry/syscalls/syscall_32.tbl  | 11 +++++++++++
 .../arch/mips/entry/syscalls/syscall_n64.tbl  |  2 ++
 .../arch/parisc/entry/syscalls/syscall.tbl    |  2 ++
 .../arch/powerpc/entry/syscalls/syscall.tbl   |  2 ++
 .../perf/arch/s390/entry/syscalls/syscall.tbl |  2 ++
 tools/perf/arch/sh/entry/syscalls/syscall.tbl |  2 ++
 .../arch/sparc/entry/syscalls/syscall.tbl     |  2 ++
 .../arch/x86/entry/syscalls/syscall_32.tbl    |  2 ++
 .../arch/x86/entry/syscalls/syscall_64.tbl    |  2 ++
 .../arch/xtensa/entry/syscalls/syscall.tbl    |  2 ++
 tools/scripts/syscall.tbl                     |  2 ++
 34 files changed, 108 insertions(+), 3 deletions(-)

diff --git a/arch/alpha/kernel/syscalls/syscall.tbl b/arch/alpha/kernel/syscalls/syscall.tbl
index f31b7afffc345..8dd0b22a407c5 100644
--- a/arch/alpha/kernel/syscalls/syscall.tbl
+++ b/arch/alpha/kernel/syscalls/syscall.tbl
@@ -511,3 +511,5 @@
 579	common	file_setattr			sys_file_setattr
 580	common	listns				sys_listns
 581	common	rseq_slice_yield		sys_rseq_slice_yield
+582	common	pidfd_config			sys_pidfd_config
+583	common	pidfd_spawn_run			sys_pidfd_spawn_run
diff --git a/arch/arm/tools/syscall.tbl b/arch/arm/tools/syscall.tbl
index 94351e22bfcf7..9830c4600fc78 100644
--- a/arch/arm/tools/syscall.tbl
+++ b/arch/arm/tools/syscall.tbl
@@ -486,3 +486,5 @@
 469	common	file_setattr			sys_file_setattr
 470	common	listns				sys_listns
 471	common	rseq_slice_yield		sys_rseq_slice_yield
+472	common	pidfd_config			sys_pidfd_config
+473	common	pidfd_spawn_run			sys_pidfd_spawn_run
diff --git a/arch/arm64/tools/syscall_32.tbl b/arch/arm64/tools/syscall_32.tbl
index 62d93d88e0fef..9c3281b3612c2 100644
--- a/arch/arm64/tools/syscall_32.tbl
+++ b/arch/arm64/tools/syscall_32.tbl
@@ -483,3 +483,5 @@
 469	common	file_setattr			sys_file_setattr
 470	common	listns				sys_listns
 471	common	rseq_slice_yield		sys_rseq_slice_yield
+472	common	pidfd_config			sys_pidfd_config
+473	common	pidfd_spawn_run			sys_pidfd_spawn_run
diff --git a/arch/m68k/kernel/syscalls/syscall.tbl b/arch/m68k/kernel/syscalls/syscall.tbl
index 2489342571014..2db719475e061 100644
--- a/arch/m68k/kernel/syscalls/syscall.tbl
+++ b/arch/m68k/kernel/syscalls/syscall.tbl
@@ -471,3 +471,5 @@
 469	common	file_setattr			sys_file_setattr
 470	common	listns				sys_listns
 471	common	rseq_slice_yield		sys_rseq_slice_yield
+472	common	pidfd_config			sys_pidfd_config
+473	common	pidfd_spawn_run			sys_pidfd_spawn_run
diff --git a/arch/microblaze/kernel/syscalls/syscall.tbl b/arch/microblaze/kernel/syscalls/syscall.tbl
index 223d263036272..41ead93dba5c4 100644
--- a/arch/microblaze/kernel/syscalls/syscall.tbl
+++ b/arch/microblaze/kernel/syscalls/syscall.tbl
@@ -477,3 +477,5 @@
 469	common	file_setattr			sys_file_setattr
 470	common	listns				sys_listns
 471	common	rseq_slice_yield		sys_rseq_slice_yield
+472	common	pidfd_config			sys_pidfd_config
+473	common	pidfd_spawn_run			sys_pidfd_spawn_run
diff --git a/arch/mips/kernel/syscalls/syscall_n32.tbl b/arch/mips/kernel/syscalls/syscall_n32.tbl
index 7430714e2b8f8..b6bfca9ddedc6 100644
--- a/arch/mips/kernel/syscalls/syscall_n32.tbl
+++ b/arch/mips/kernel/syscalls/syscall_n32.tbl
@@ -410,3 +410,5 @@
 469	n32	file_setattr			sys_file_setattr
 470	n32	listns				sys_listns
 471	n32	rseq_slice_yield		sys_rseq_slice_yield
+472	n32	pidfd_config			sys_pidfd_config
+473	n32	pidfd_spawn_run			sys_pidfd_spawn_run
diff --git a/arch/mips/kernel/syscalls/syscall_n64.tbl b/arch/mips/kernel/syscalls/syscall_n64.tbl
index 630aab9e54259..229a1a5bff0e9 100644
--- a/arch/mips/kernel/syscalls/syscall_n64.tbl
+++ b/arch/mips/kernel/syscalls/syscall_n64.tbl
@@ -386,3 +386,5 @@
 469	n64	file_setattr			sys_file_setattr
 470	n64	listns				sys_listns
 471	n64	rseq_slice_yield		sys_rseq_slice_yield
+472	n64	pidfd_config			sys_pidfd_config
+473	n64	pidfd_spawn_run			sys_pidfd_spawn_run
diff --git a/arch/mips/kernel/syscalls/syscall_o32.tbl b/arch/mips/kernel/syscalls/syscall_o32.tbl
index 128653112284b..4ee804186e399 100644
--- a/arch/mips/kernel/syscalls/syscall_o32.tbl
+++ b/arch/mips/kernel/syscalls/syscall_o32.tbl
@@ -459,3 +459,5 @@
 469	o32	file_setattr			sys_file_setattr
 470	o32	listns				sys_listns
 471	o32	rseq_slice_yield		sys_rseq_slice_yield
+472	o32	pidfd_config			sys_pidfd_config
+473	o32	pidfd_spawn_run			sys_pidfd_spawn_run
diff --git a/arch/parisc/kernel/syscalls/syscall.tbl b/arch/parisc/kernel/syscalls/syscall.tbl
index c6331dad94613..ff6760df2dc51 100644
--- a/arch/parisc/kernel/syscalls/syscall.tbl
+++ b/arch/parisc/kernel/syscalls/syscall.tbl
@@ -470,3 +470,5 @@
 469	common	file_setattr			sys_file_setattr
 470	common	listns				sys_listns
 471	common	rseq_slice_yield		sys_rseq_slice_yield
+472	common	pidfd_config			sys_pidfd_config
+473	common	pidfd_spawn_run			sys_pidfd_spawn_run
diff --git a/arch/powerpc/kernel/syscalls/syscall.tbl b/arch/powerpc/kernel/syscalls/syscall.tbl
index 4fcc7c58a105d..021b334a8e1a0 100644
--- a/arch/powerpc/kernel/syscalls/syscall.tbl
+++ b/arch/powerpc/kernel/syscalls/syscall.tbl
@@ -562,3 +562,5 @@
 469	common	file_setattr			sys_file_setattr
 470	common	listns				sys_listns
 471	nospu	rseq_slice_yield		sys_rseq_slice_yield
+472	common	pidfd_config			sys_pidfd_config
+473	common	pidfd_spawn_run			sys_pidfd_spawn_run
diff --git a/arch/s390/kernel/syscalls/syscall.tbl b/arch/s390/kernel/syscalls/syscall.tbl
index 09a7ef04d9791..eea88f94a7624 100644
--- a/arch/s390/kernel/syscalls/syscall.tbl
+++ b/arch/s390/kernel/syscalls/syscall.tbl
@@ -398,3 +398,5 @@
 469	common	file_setattr			sys_file_setattr
 470	common	listns				sys_listns
 471	common	rseq_slice_yield		sys_rseq_slice_yield
+472	common	pidfd_config			sys_pidfd_config
+473	common	pidfd_spawn_run			sys_pidfd_spawn_run
diff --git a/arch/sh/kernel/syscalls/syscall.tbl b/arch/sh/kernel/syscalls/syscall.tbl
index 70b315cbe710c..37166286c4045 100644
--- a/arch/sh/kernel/syscalls/syscall.tbl
+++ b/arch/sh/kernel/syscalls/syscall.tbl
@@ -475,3 +475,5 @@
 469	common	file_setattr			sys_file_setattr
 470	common	listns				sys_listns
 471	common	rseq_slice_yield		sys_rseq_slice_yield
+472	common	pidfd_config			sys_pidfd_config
+473	common	pidfd_spawn_run			sys_pidfd_spawn_run
diff --git a/arch/sparc/kernel/syscalls/syscall.tbl b/arch/sparc/kernel/syscalls/syscall.tbl
index 7e71bf7fcd14f..70f2165b9cfb3 100644
--- a/arch/sparc/kernel/syscalls/syscall.tbl
+++ b/arch/sparc/kernel/syscalls/syscall.tbl
@@ -517,3 +517,5 @@
 469	common	file_setattr			sys_file_setattr
 470	common	listns				sys_listns
 471	common	rseq_slice_yield		sys_rseq_slice_yield
+472	common	pidfd_config			sys_pidfd_config
+473	common	pidfd_spawn_run			sys_pidfd_spawn_run
diff --git a/arch/x86/entry/syscalls/syscall_32.tbl b/arch/x86/entry/syscalls/syscall_32.tbl
index f832ebd2d79b0..b2eeddbe99be9 100644
--- a/arch/x86/entry/syscalls/syscall_32.tbl
+++ b/arch/x86/entry/syscalls/syscall_32.tbl
@@ -477,3 +477,5 @@
 469	i386	file_setattr		sys_file_setattr
 470	i386	listns			sys_listns
 471	i386	rseq_slice_yield	sys_rseq_slice_yield
+472	i386	pidfd_config		sys_pidfd_config
+473	i386	pidfd_spawn_run		sys_pidfd_spawn_run
diff --git a/arch/x86/entry/syscalls/syscall_64.tbl b/arch/x86/entry/syscalls/syscall_64.tbl
index 524155d655da1..f0952f34c10a5 100644
--- a/arch/x86/entry/syscalls/syscall_64.tbl
+++ b/arch/x86/entry/syscalls/syscall_64.tbl
@@ -396,6 +396,8 @@
 469	common	file_setattr		sys_file_setattr
 470	common	listns			sys_listns
 471	common	rseq_slice_yield	sys_rseq_slice_yield
+472	common	pidfd_config		sys_pidfd_config
+473	common	pidfd_spawn_run		sys_pidfd_spawn_run
 
 #
 # Due to a historical design error, certain syscalls are numbered differently
diff --git a/arch/xtensa/kernel/syscalls/syscall.tbl b/arch/xtensa/kernel/syscalls/syscall.tbl
index a9bca4e484dec..45dd80ab94cf9 100644
--- a/arch/xtensa/kernel/syscalls/syscall.tbl
+++ b/arch/xtensa/kernel/syscalls/syscall.tbl
@@ -442,3 +442,5 @@
 469	common	file_setattr			sys_file_setattr
 470	common	listns				sys_listns
 471	common	rseq_slice_yield		sys_rseq_slice_yield
+472	common	pidfd_config			sys_pidfd_config
+473	common	pidfd_spawn_run			sys_pidfd_spawn_run
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 874d9067a43b5..ec90454d01214 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -79,6 +79,7 @@ struct mnt_id_req;
 struct ns_id_req;
 struct xattr_args;
 struct file_attr;
+struct pidfd_spawn_run_args;
 
 #include <linux/types.h>
 #include <linux/aio_abi.h>
@@ -908,6 +909,12 @@ asmlinkage long sys_clock_adjtime32(clockid_t which_clock,
 asmlinkage long sys_syncfs(int fd);
 asmlinkage long sys_setns(int fd, int nstype);
 asmlinkage long sys_pidfd_open(pid_t pid, unsigned int flags);
+asmlinkage long sys_pidfd_config(int fd, unsigned int cmd,
+				 const char __user *key,
+				 const void __user *value, int aux);
+asmlinkage long sys_pidfd_spawn_run(int fd,
+				    const struct pidfd_spawn_run_args __user *uargs,
+				    size_t usize);
 asmlinkage long sys_sendmmsg(int fd, struct mmsghdr __user *msg,
 			     unsigned int vlen, unsigned flags);
 asmlinkage long sys_process_vm_readv(pid_t pid,
diff --git a/include/uapi/asm-generic/unistd.h b/include/uapi/asm-generic/unistd.h
index a627acc8fb5fe..9ab8ae5100ec1 100644
--- a/include/uapi/asm-generic/unistd.h
+++ b/include/uapi/asm-generic/unistd.h
@@ -863,8 +863,14 @@ __SYSCALL(__NR_listns, sys_listns)
 #define __NR_rseq_slice_yield 471
 __SYSCALL(__NR_rseq_slice_yield, sys_rseq_slice_yield)
 
+#define __NR_pidfd_config 472
+__SYSCALL(__NR_pidfd_config, sys_pidfd_config)
+
+#define __NR_pidfd_spawn_run 473
+__SYSCALL(__NR_pidfd_spawn_run, sys_pidfd_spawn_run)
+
 #undef __NR_syscalls
-#define __NR_syscalls 472
+#define __NR_syscalls 474
 
 /*
  * 32 bit systems traditionally used different
diff --git a/kernel/pid.c b/kernel/pid.c
index 010f80177cac8..a1d05ce10ac25 100644
--- a/kernel/pid.c
+++ b/kernel/pid.c
@@ -43,6 +43,7 @@
 #include <linux/sched/task.h>
 #include <linux/idr.h>
 #include <linux/pidfs.h>
+#include <linux/pidfd_spawn.h>
 #include <net/sock.h>
 #include <uapi/linux/pidfd.h>
 
@@ -715,10 +716,26 @@ SYSCALL_DEFINE2(pidfd_open, pid_t, pid, unsigned int, flags)
 	int fd;
 	struct pid *p;
 
+	/*
+	 * pidfd_open(0, PIDFD_EMPTY) is the spawn-builder entry point.
+	 * It creates a future pidfd instead of looking up pid 0.
+	 */
+	if (pid == 0) {
+		if (!(flags & PIDFD_EMPTY))
+			return -EINVAL;
+		if (flags & ~(PIDFD_EMPTY | PIDFD_NONBLOCK))
+			return -EINVAL;
+
+		return pidfd_empty_open(flags & PIDFD_NONBLOCK);
+	}
+
+	/* PIDFD_EMPTY is only meaningful for the pid == 0 builder form. */
+	if (flags & PIDFD_EMPTY)
+		return -EINVAL;
 	if (flags & ~(PIDFD_NONBLOCK | PIDFD_THREAD))
 		return -EINVAL;
 
-	if (pid <= 0)
+	if (pid < 0)
 		return -EINVAL;
 
 	p = find_get_pid(pid);
diff --git a/scripts/syscall.tbl b/scripts/syscall.tbl
index 7a42b32b65776..29248f0ac1a07 100644
--- a/scripts/syscall.tbl
+++ b/scripts/syscall.tbl
@@ -412,3 +412,5 @@
 469	common	file_setattr			sys_file_setattr
 470	common	listns				sys_listns
 471	common	rseq_slice_yield		sys_rseq_slice_yield
+472	common	pidfd_config			sys_pidfd_config
+473	common	pidfd_spawn_run			sys_pidfd_spawn_run
diff --git a/tools/include/uapi/asm-generic/unistd.h b/tools/include/uapi/asm-generic/unistd.h
index a627acc8fb5fe..9ab8ae5100ec1 100644
--- a/tools/include/uapi/asm-generic/unistd.h
+++ b/tools/include/uapi/asm-generic/unistd.h
@@ -863,8 +863,14 @@ __SYSCALL(__NR_listns, sys_listns)
 #define __NR_rseq_slice_yield 471
 __SYSCALL(__NR_rseq_slice_yield, sys_rseq_slice_yield)
 
+#define __NR_pidfd_config 472
+__SYSCALL(__NR_pidfd_config, sys_pidfd_config)
+
+#define __NR_pidfd_spawn_run 473
+__SYSCALL(__NR_pidfd_spawn_run, sys_pidfd_spawn_run)
+
 #undef __NR_syscalls
-#define __NR_syscalls 472
+#define __NR_syscalls 474
 
 /*
  * 32 bit systems traditionally used different
diff --git a/tools/perf/arch/alpha/entry/syscalls/syscall.tbl b/tools/perf/arch/alpha/entry/syscalls/syscall.tbl
index 74720667fe091..a20f81b950349 100644
--- a/tools/perf/arch/alpha/entry/syscalls/syscall.tbl
+++ b/tools/perf/arch/alpha/entry/syscalls/syscall.tbl
@@ -502,3 +502,5 @@
 570	common	lsm_set_self_attr		sys_lsm_set_self_attr
 571	common	lsm_list_modules		sys_lsm_list_modules
 572	common  mseal				sys_mseal
+582	common	pidfd_config			sys_pidfd_config
+583	common	pidfd_spawn_run			sys_pidfd_spawn_run
diff --git a/tools/perf/arch/arm/entry/syscalls/syscall.tbl b/tools/perf/arch/arm/entry/syscalls/syscall.tbl
index 94351e22bfcf7..9830c4600fc78 100644
--- a/tools/perf/arch/arm/entry/syscalls/syscall.tbl
+++ b/tools/perf/arch/arm/entry/syscalls/syscall.tbl
@@ -486,3 +486,5 @@
 469	common	file_setattr			sys_file_setattr
 470	common	listns				sys_listns
 471	common	rseq_slice_yield		sys_rseq_slice_yield
+472	common	pidfd_config			sys_pidfd_config
+473	common	pidfd_spawn_run			sys_pidfd_spawn_run
diff --git a/tools/perf/arch/arm64/entry/syscalls/syscall_32.tbl b/tools/perf/arch/arm64/entry/syscalls/syscall_32.tbl
index 9a37930d4e26f..9c3281b3612c2 100644
--- a/tools/perf/arch/arm64/entry/syscalls/syscall_32.tbl
+++ b/tools/perf/arch/arm64/entry/syscalls/syscall_32.tbl
@@ -474,3 +474,14 @@
 460	common	lsm_set_self_attr		sys_lsm_set_self_attr
 461	common	lsm_list_modules		sys_lsm_list_modules
 462	common	mseal				sys_mseal
+463	common	setxattrat			sys_setxattrat
+464	common	getxattrat			sys_getxattrat
+465	common	listxattrat			sys_listxattrat
+466	common	removexattrat			sys_removexattrat
+467	common	open_tree_attr			sys_open_tree_attr
+468	common	file_getattr			sys_file_getattr
+469	common	file_setattr			sys_file_setattr
+470	common	listns				sys_listns
+471	common	rseq_slice_yield		sys_rseq_slice_yield
+472	common	pidfd_config			sys_pidfd_config
+473	common	pidfd_spawn_run			sys_pidfd_spawn_run
diff --git a/tools/perf/arch/mips/entry/syscalls/syscall_n64.tbl b/tools/perf/arch/mips/entry/syscalls/syscall_n64.tbl
index 630aab9e54259..229a1a5bff0e9 100644
--- a/tools/perf/arch/mips/entry/syscalls/syscall_n64.tbl
+++ b/tools/perf/arch/mips/entry/syscalls/syscall_n64.tbl
@@ -386,3 +386,5 @@
 469	n64	file_setattr			sys_file_setattr
 470	n64	listns				sys_listns
 471	n64	rseq_slice_yield		sys_rseq_slice_yield
+472	n64	pidfd_config			sys_pidfd_config
+473	n64	pidfd_spawn_run			sys_pidfd_spawn_run
diff --git a/tools/perf/arch/parisc/entry/syscalls/syscall.tbl b/tools/perf/arch/parisc/entry/syscalls/syscall.tbl
index 66dc406b12e44..88311785913f8 100644
--- a/tools/perf/arch/parisc/entry/syscalls/syscall.tbl
+++ b/tools/perf/arch/parisc/entry/syscalls/syscall.tbl
@@ -461,3 +461,5 @@
 460	common	lsm_set_self_attr		sys_lsm_set_self_attr
 461	common	lsm_list_modules		sys_lsm_list_modules
 462	common	mseal				sys_mseal
+472	common	pidfd_config			sys_pidfd_config
+473	common	pidfd_spawn_run			sys_pidfd_spawn_run
diff --git a/tools/perf/arch/powerpc/entry/syscalls/syscall.tbl b/tools/perf/arch/powerpc/entry/syscalls/syscall.tbl
index 4fcc7c58a105d..021b334a8e1a0 100644
--- a/tools/perf/arch/powerpc/entry/syscalls/syscall.tbl
+++ b/tools/perf/arch/powerpc/entry/syscalls/syscall.tbl
@@ -562,3 +562,5 @@
 469	common	file_setattr			sys_file_setattr
 470	common	listns				sys_listns
 471	nospu	rseq_slice_yield		sys_rseq_slice_yield
+472	common	pidfd_config			sys_pidfd_config
+473	common	pidfd_spawn_run			sys_pidfd_spawn_run
diff --git a/tools/perf/arch/s390/entry/syscalls/syscall.tbl b/tools/perf/arch/s390/entry/syscalls/syscall.tbl
index 09a7ef04d9791..eea88f94a7624 100644
--- a/tools/perf/arch/s390/entry/syscalls/syscall.tbl
+++ b/tools/perf/arch/s390/entry/syscalls/syscall.tbl
@@ -398,3 +398,5 @@
 469	common	file_setattr			sys_file_setattr
 470	common	listns				sys_listns
 471	common	rseq_slice_yield		sys_rseq_slice_yield
+472	common	pidfd_config			sys_pidfd_config
+473	common	pidfd_spawn_run			sys_pidfd_spawn_run
diff --git a/tools/perf/arch/sh/entry/syscalls/syscall.tbl b/tools/perf/arch/sh/entry/syscalls/syscall.tbl
index 70b315cbe710c..37166286c4045 100644
--- a/tools/perf/arch/sh/entry/syscalls/syscall.tbl
+++ b/tools/perf/arch/sh/entry/syscalls/syscall.tbl
@@ -475,3 +475,5 @@
 469	common	file_setattr			sys_file_setattr
 470	common	listns				sys_listns
 471	common	rseq_slice_yield		sys_rseq_slice_yield
+472	common	pidfd_config			sys_pidfd_config
+473	common	pidfd_spawn_run			sys_pidfd_spawn_run
diff --git a/tools/perf/arch/sparc/entry/syscalls/syscall.tbl b/tools/perf/arch/sparc/entry/syscalls/syscall.tbl
index 7e71bf7fcd14f..70f2165b9cfb3 100644
--- a/tools/perf/arch/sparc/entry/syscalls/syscall.tbl
+++ b/tools/perf/arch/sparc/entry/syscalls/syscall.tbl
@@ -517,3 +517,5 @@
 469	common	file_setattr			sys_file_setattr
 470	common	listns				sys_listns
 471	common	rseq_slice_yield		sys_rseq_slice_yield
+472	common	pidfd_config			sys_pidfd_config
+473	common	pidfd_spawn_run			sys_pidfd_spawn_run
diff --git a/tools/perf/arch/x86/entry/syscalls/syscall_32.tbl b/tools/perf/arch/x86/entry/syscalls/syscall_32.tbl
index f832ebd2d79b0..b2eeddbe99be9 100644
--- a/tools/perf/arch/x86/entry/syscalls/syscall_32.tbl
+++ b/tools/perf/arch/x86/entry/syscalls/syscall_32.tbl
@@ -477,3 +477,5 @@
 469	i386	file_setattr		sys_file_setattr
 470	i386	listns			sys_listns
 471	i386	rseq_slice_yield	sys_rseq_slice_yield
+472	i386	pidfd_config		sys_pidfd_config
+473	i386	pidfd_spawn_run		sys_pidfd_spawn_run
diff --git a/tools/perf/arch/x86/entry/syscalls/syscall_64.tbl b/tools/perf/arch/x86/entry/syscalls/syscall_64.tbl
index 524155d655da1..f0952f34c10a5 100644
--- a/tools/perf/arch/x86/entry/syscalls/syscall_64.tbl
+++ b/tools/perf/arch/x86/entry/syscalls/syscall_64.tbl
@@ -396,6 +396,8 @@
 469	common	file_setattr		sys_file_setattr
 470	common	listns			sys_listns
 471	common	rseq_slice_yield	sys_rseq_slice_yield
+472	common	pidfd_config		sys_pidfd_config
+473	common	pidfd_spawn_run		sys_pidfd_spawn_run
 
 #
 # Due to a historical design error, certain syscalls are numbered differently
diff --git a/tools/perf/arch/xtensa/entry/syscalls/syscall.tbl b/tools/perf/arch/xtensa/entry/syscalls/syscall.tbl
index a9bca4e484dec..45dd80ab94cf9 100644
--- a/tools/perf/arch/xtensa/entry/syscalls/syscall.tbl
+++ b/tools/perf/arch/xtensa/entry/syscalls/syscall.tbl
@@ -442,3 +442,5 @@
 469	common	file_setattr			sys_file_setattr
 470	common	listns				sys_listns
 471	common	rseq_slice_yield		sys_rseq_slice_yield
+472	common	pidfd_config			sys_pidfd_config
+473	common	pidfd_spawn_run			sys_pidfd_spawn_run
diff --git a/tools/scripts/syscall.tbl b/tools/scripts/syscall.tbl
index 7a42b32b65776..29248f0ac1a07 100644
--- a/tools/scripts/syscall.tbl
+++ b/tools/scripts/syscall.tbl
@@ -412,3 +412,5 @@
 469	common	file_setattr			sys_file_setattr
 470	common	listns				sys_listns
 471	common	rseq_slice_yield		sys_rseq_slice_yield
+472	common	pidfd_config			sys_pidfd_config
+473	common	pidfd_spawn_run			sys_pidfd_spawn_run
-- 
2.52.0


