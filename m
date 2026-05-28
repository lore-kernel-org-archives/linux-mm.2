Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DB7FACD5BD1
	for <linux-mm@archiver.kernel.org>; Thu, 28 May 2026 09:58:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1B2406B00B4; Thu, 28 May 2026 05:58:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1636F6B00B6; Thu, 28 May 2026 05:58:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0A10A6B00B7; Thu, 28 May 2026 05:58:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EBF996B00B4
	for <linux-mm@kvack.org>; Thu, 28 May 2026 05:58:38 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C56941C1DA4
	for <linux-mm@kvack.org>; Thu, 28 May 2026 09:58:38 +0000 (UTC)
X-FDA: 84816379116.27.FA74861
Received: from sender4-op-o15.zoho.com (sender4-op-o15.zoho.com [136.143.188.15])
	by imf15.hostedemail.com (Postfix) with ESMTP id E08D0A0002
	for <linux-mm@kvack.org>; Thu, 28 May 2026 09:58:36 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.beauty header.s=zmail header.b=hs9jAnFc;
	arc=pass ("zohomail.com:s=zohoarc:i=1");
	spf=pass (imf15.hostedemail.com: domain of me@linux.beauty designates 136.143.188.15 as permitted sender) smtp.mailfrom=me@linux.beauty;
	dmarc=pass (policy=none) header.from=linux.beauty
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1779962317; a=rsa-sha256;
	cv=pass;
	b=U9PlZ08r8oyjzVcNKF6Eh4F98xV5XzkD2lQQhWlAk3x1atczJ+NzjPkuy2i3WLTg9sW9Wl
	JezwpUZ8wIV3mT/PekMv2vbXg6kXOl5LW4+/WcSONA7MQFA5FCmPKb51CcJPMx61i4TgS8
	gv60yUkmtRsTcuZBU8zSdXERcM5PIMU=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.beauty header.s=zmail header.b=hs9jAnFc;
	arc=pass ("zohomail.com:s=zohoarc:i=1");
	spf=pass (imf15.hostedemail.com: domain of me@linux.beauty designates 136.143.188.15 as permitted sender) smtp.mailfrom=me@linux.beauty;
	dmarc=pass (policy=none) header.from=linux.beauty
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779962317;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LBP3jruN2RkIXP5r6tCnATnUH33LnY6Ig4uYaIj36zY=;
	b=nlUl0yRjcrfJYkfzX6h/Rf7CA1BRwLk4s3veZamhtVhnjq0m0EbsBlyN25MJY4xBaqQ5Nu
	9Fg6vL+QGYnjuzCNCWHH8cfKTpUt2SKTtNQSZqZeZcPeA/E7LpvruoqyclLNBp9joIsoad
	1m9WnjPNKpRo8b5s5OdkV4+DhMUw+PA=
ARC-Seal: i=1; a=rsa-sha256; t=1779962078; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=W0w/mn2J1AYfM3IS7vZfMX0gJ8ZaymQK2XDEVIjpTpvOwgMEYhvZLwobodhV5irOmS8XeUKpxQfYjDUJIVqUB2STeoXKQYIai/08OX5v/5YaeyHDG6HdfNJMqG/CrlNQ5bbUIBEQdNIjhxZDHpU7XvDI0/CjZ7T/fG8z0cLkbxM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1779962078; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=LBP3jruN2RkIXP5r6tCnATnUH33LnY6Ig4uYaIj36zY=; 
	b=FnNdIqrmJXESp6ZdHOgHw7hif7sa6TuZIIpNebGnePeOrG8CiOZubbu0gMUo5fcjwkbLIJkzBWfYg54nVwE+8RvVYJRaIkFuH3cI9vrlNvR8d+FuiG9NrfchomBszf2xtYQcMNqKXRmnLL31MPkcg02cts6MI7MmtHCdyy4EstE=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=linux.beauty;
	spf=pass  smtp.mailfrom=me@linux.beauty;
	dmarc=pass header.from=<me@linux.beauty>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1779962078;
	s=zmail; d=linux.beauty; i=me@linux.beauty;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-ID:In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=LBP3jruN2RkIXP5r6tCnATnUH33LnY6Ig4uYaIj36zY=;
	b=hs9jAnFcSis+pCZhFYCvTa0bWXgdCxYbVdlMupKZJ8yIlMw7s6ao28m9iC0adpex
	kxSyjfM4rCkyLSSGivfV3lc0J6qF85zRgXHX6GkmKKCPsUq+en4GUudCpv7v3oT21VC
	+m4xFhBxhOqNUd9SgBpgmr2mxUcTzWwh8/8Q/fwM=
Received: by mx.zohomail.com with SMTPS id 1779962074218341.93123023468877;
	Thu, 28 May 2026 02:54:34 -0700 (PDT)
From: Li Chen <me@linux.beauty>
To: Christian Brauner <brauner@kernel.org>,
	Kees Cook <kees@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org,
	linux-api@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-arch@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	x86@kernel.org,
	Arnd Bergmann <arnd@arndb.de>,
	Andy Lutomirski <luto@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Jan Kara <jack@suse.cz>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Li Chen <me@linux.beauty>
Subject: [RFC PATCH v1 12/13] syscalls: add generic spawn template entries
Date: Thu, 28 May 2026 17:52:33 +0800
Message-ID: <20260528095235.2491226-13-me@linux.beauty>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260528095235.2491226-1-me@linux.beauty>
References: <20260528095235.2491226-1-me@linux.beauty>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: E08D0A0002
X-Stat-Signature: nejtb1sqnkb6wkfhirhs7ts95ej73g1q
X-HE-Tag: 1779962316-163578
X-HE-Meta: U2FsdGVkX18zE5KF89dByl0Wafj3U/prPLnIFkVYPPu3e2W001ScHguO8wfy5v8geAkAJXa6I68r1cRDyLxrIZ1QVH0covuSsAJdS3ACSVQ7sT9pKnwfD6gfAhmocvfhfA3AWO/h4+OK3Qf3q70v3i/tzSdijwmWj0r2QIAnqR2ihw6NG9Joa3YR3YJzU0IIgT4Idq2Ma8AQCfayi+dWwhp0qNKFuZkeRZ3KWkh7rTwYgjMErjmvVRYHo2Dr3BYwxGALNjaNlOJNxsVhPRc2cs8dUZBCuph1uLUGnIRNf38vlr+l7dhHSibbRhgSw3hvhwfCmv/KwgitZ6tHn9wBskyuvnNjhjCuKdYCI9xiu3iWmoGPd2bDRBhGkv3Lc2wmSlnvLd4AmR7F87rlq40xgw4rN7MxvW7jvt+ZC4yXPH62EXaKU1d1u2OLs67oZPIxYMi6j4w+aSqSXg+F7+ejKAk7bnghs6PSoViRcoXExvrfWEX+yLyeY7qyGcwp8Am5jtuzHoOBhgiOhWR0i86TsrLISyCNywrr1SqoYaWaVjMRM1AorUf58V/4B9cIJOXwRQJcci7zj1WcXwWzn7Dpb7NaVTPj3YsvkU1EdEr7zHMcn32RqojEwnhJ8tzgYMFU06Klhwz6LNm+T9eY3hLi+xPeX75has1RgCSHbUCvCYZFOmrd/Z6DMFn1/iOboiv6XOohIjsopXKBhrrEYftopL7NmqEN16u+SC4WU4vQdl8WcktAYXYk2xxGGr1uEmwuGjkm7SHrqY8K6XTqcQAaluOHt5gHT7uE6OwF79I8XlbZ/xEq+Jbo+smt83gjr//Nc4aNotqAmGHg3QJJ/o+/LtStmK4pZNhR5drdpBuZK2VoaFOnSD3oBl+x2QfXijgTKF6VZSm0U6z+JYT+fx27ppuylrM5oPydF1sR26gjXk6MJxda4MInX4AB4ZoScbs/yLcw/zhjJrVd6+FEEeT
 YoUQklW1
 iiy28p5KdutQ7WdgI2Jo9kICRwppVIIFnr4l68JvpEfNrYiLGK+BDNFyK2nBMJgd7LdWY8rmO53yW4DZC2/tamhqP/ur2s/IIWQ3ApXB5YqFBWaviAVQ1u2rRLQ+LPgRlbPs2NFj9Yv6oZ3MBloJflqAIWXET5v05ZSE5T4tlg8bRvo52fwa3YEaDXkpJwTVVPmSGNTczoufaNQS5eVgLcEWkzQvKNbPp3jBVYVGIAHl47dKXTKdIWSCo8VcR/UJAVyjEMecz8kDUETKuJAlyhLCgEgPSzPK2U5ATzQPbFZhu29dt7kH659HzVcSQunlgD0qaH3QHGdcxtnRboz/AUC7r++MlWJ2obUMQcmqmI70hkzYtNJK1llsXHeVCEKN+hEZfh5WN6NPj2Q7UOY65/K1uMyV4SJY3pSgmDA+Py79XgPmqNDgORZT7i7uU9frnK0Up
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add spawn_template_create() and spawn_template_spawn() to the generic
syscall table and asm-generic UAPI numbering. This lets architectures
using the generic table pick up the spawn-template ABI instead of
leaving the mechanism x86-only.

Signed-off-by: Li Chen <me@linux.beauty>
---
 arch/x86/entry/syscalls/syscall_64.tbl | 2 ++
 include/uapi/asm-generic/unistd.h      | 7 ++++++-
 scripts/syscall.tbl                    | 2 ++
 3 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/arch/x86/entry/syscalls/syscall_64.tbl b/arch/x86/entry/syscalls/syscall_64.tbl
index d6c1667e8f3b8..e9dcfc6de79bc 100644
--- a/arch/x86/entry/syscalls/syscall_64.tbl
+++ b/arch/x86/entry/syscalls/syscall_64.tbl
@@ -396,6 +396,8 @@
 469	common	file_setattr		sys_file_setattr
 470	common	listns			sys_listns
 471	common	rseq_slice_yield	sys_rseq_slice_yield
+472	64	spawn_template_create	sys_spawn_template_create
+473	64	spawn_template_spawn	sys_spawn_template_spawn
 #
 # Due to a historical design error, certain syscalls are numbered differently
 # in x32 as compared to native x86_64.  These syscalls have numbers 512-547.
diff --git a/include/uapi/asm-generic/unistd.h b/include/uapi/asm-generic/unistd.h
index a627acc8fb5fe..8589f2b9696a7 100644
--- a/include/uapi/asm-generic/unistd.h
+++ b/include/uapi/asm-generic/unistd.h
@@ -863,8 +863,13 @@ __SYSCALL(__NR_listns, sys_listns)
 #define __NR_rseq_slice_yield 471
 __SYSCALL(__NR_rseq_slice_yield, sys_rseq_slice_yield)
 
+#define __NR_spawn_template_create 472
+__SYSCALL(__NR_spawn_template_create, sys_spawn_template_create)
+#define __NR_spawn_template_spawn 473
+__SYSCALL(__NR_spawn_template_spawn, sys_spawn_template_spawn)
+
 #undef __NR_syscalls
-#define __NR_syscalls 472
+#define __NR_syscalls 474
 
 /*
  * 32 bit systems traditionally used different
diff --git a/scripts/syscall.tbl b/scripts/syscall.tbl
index 7a42b32b65776..7f8e74e866e48 100644
--- a/scripts/syscall.tbl
+++ b/scripts/syscall.tbl
@@ -412,3 +412,5 @@
 469	common	file_setattr			sys_file_setattr
 470	common	listns				sys_listns
 471	common	rseq_slice_yield		sys_rseq_slice_yield
+472	common	spawn_template_create		sys_spawn_template_create
+473	common	spawn_template_spawn		sys_spawn_template_spawn
-- 
2.52.0


