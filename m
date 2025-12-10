Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6432BD3E781
	for <linux-mm@archiver.kernel.org>; Wed, 10 Dec 2025 22:46:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A3D316B0006; Wed, 10 Dec 2025 17:46:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9EE566B0007; Wed, 10 Dec 2025 17:46:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 903AB6B0008; Wed, 10 Dec 2025 17:46:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7F8316B0006
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 17:46:35 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4C627BAB6B
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 22:46:35 +0000 (UTC)
X-FDA: 84205047150.21.4C17FC5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 88D0510000F
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 22:46:33 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TlR9UQpf;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of alx@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=alx@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765406793; a=rsa-sha256;
	cv=none;
	b=6pn+hrbqH7Le0MJYu2DV3NN+bACjnlD6yVNH1f8c2KmYPi50i6LZjdUl/fPucTXYUoAnUV
	MhoDg4dluOAjY9YE4UaGL0N6SCBIBBqBs2DximiB7LBZ4KGMBn9KXRpkFkFby4gvG6/vgN
	yWsLDPGgWQDVSAyWkfgbYsaD7HomUkE=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TlR9UQpf;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of alx@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=alx@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765406793;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TJ673bVWTvIYL7YqmRgfM8ziJeMWCC2g4e40z1K/nWQ=;
	b=Bk498+DVUlvkyBP7izDKgM9SDfg0wi46j8pyPuAL4HF7gLDer/OI1rFHuxSPpDj9G6EX2p
	vC09cB+DsAmzk5Si4D4/9w/I/1Bac5otLhSblrGXBvkS97bP5ok69izgRHegEKScOrwMOH
	OjtAmw3eq1A5L6JWdesq87b0cIs7wWY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 334F1436F9;
	Wed, 10 Dec 2025 22:46:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25142C4CEF1;
	Wed, 10 Dec 2025 22:46:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765406792;
	bh=Fxnj/rAIkI6I++vejdH2wjowK+XQNikPUDfMZas4d6w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=TlR9UQpfL9LMzzpy3fDxNkAjdfGKRCUYtqdpteEirsFfXr64EbgHfwGbwACvH64h9
	 CDSgKKlGxilM5VF1noV5Bgrx/+vePd5GRelSM6Lel8nqyUvQb0kmVMLuPaawn4PRDR
	 VoMvm54tv/MGduxSkf4D6JSNwl6N2KK6xvV+Pguixkj/QQcF2ydJxkoKevk9Hx0DX6
	 EBMg9mapth1/ajySOnl141dLt2kg26C+NY4ufAUZ9WhSJxlbFMYgBke4ZXwCUdgaY4
	 KNpx7ur3diSmsvdB3id6B6TESC77qU4/5T7gFTzS9AcpZIs7D6vw2HN/xctIFozciy
	 8MK/p+tJmhmPw==
Date: Wed, 10 Dec 2025 23:46:27 +0100
From: Alejandro Colomar <alx@kernel.org>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Cc: Alejandro Colomar <alx@kernel.org>, Kees Cook <kees@kernel.org>, 
	Christopher Bazley <chris.bazley.wg14@gmail.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, 
	Marco Elver <elver@google.com>, Michal Hocko <mhocko@suse.com>, 
	Linus Torvalds <torvalds@linux-foundation.org>, Al Viro <viro@zeniv.linux.org.uk>, 
	Alexander Potapenko <glider@google.com>, Dmitry Vyukov <dvyukov@google.com>, Jann Horn <jannh@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, "Maciej W. Rozycki" <macro@orcam.me.uk>
Subject: [PATCH v5 0/4] Add ARRAY_END(), and use it to fix off-by-one bugs
Message-ID: <cover.1765406336.git.alx@kernel.org>
X-Mailer: git-send-email 2.51.0
References: <cover.1758806023.git.alx@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <cover.1758806023.git.alx@kernel.org>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 88D0510000F
X-Stat-Signature: bx3ctfrffzyzubdcwm4qhb6m7xpxns3f
X-Rspam-User: 
X-HE-Tag: 1765406793-170744
X-HE-Meta: U2FsdGVkX18KWygGdaBNlDiHEAxyKQDJP8froEfNuh/wGvbnobCuwuMGvQqlTnysFIZvId0c5JcsmHq7JtDn8WrlxyRrBgqzW+MBULnt3bBYC2C8unfFjIDCfkzuGXLdr0D+/fHUu+b7jvKzHT5UO7QuWqLOWi7EIA/fyuNWBwKvFZUgqmzTyeRGQrYRNTcsJsxq1srtQEY/2gOD8r1RmnEjvy+GmSIb3C2cJI1HNF6CVwPD+npfV9xkhJOCh08cwZkiNzlU/l/wGMdZqcosJQ8jeM0dsgXBHa+8idOZMOn1B7g7+T+isqGfsUt+po40E/T/dbocUca7TYU/bm7uS9tMztF2U1UdzsuxtNVV70WaZkPmHz1aEH9zcHIFIZxZxxIy6d9LCxzKM/FrVbCnw1HH3PI9YwyeoDkStmWhnlvSR/8ZPyoXM26hU26XDKvqfQm+0ri9ERe2UKDWMvElwrlvNkfq2Zv27uMlolaxBZSreX1vpmWqYg5g2z2cPY2YMTOLGMDMRWnI9qCP/duvuzke4qbF45jc4f4djGODhGUSyFDJIALslZJZjnw4rvG4gcLFb4knTxhyDlmI87GoGnQSmy5q3FI54swEFN7l1An5xEaiP4rBaa8TFyvVrgmmfAWrA6icpZqpxz4jNZo8S5Mw0TpPAa9idGQ5FzrJ75W/SNdptPkSPK/w68We2/VlUkgqYp3uO6sCgFY5qAlbdXp/7uFotX4IjWpmefr+gynB6q2uXE2ghyeaWA69zTDSw3/Z3LuM1W5WaQf4XIIB6Op3aBIrOHAaVWwIoUMCV39UK7KeTjosDIH+X2Mb7ub4RTF+wDECGaHoEGfl2kjREzMQbXdScwkSRANsvsxn2ajKbxjq4KJFIAoy1yyR153WnG8BdwSyfnz1242G3O2nAmOd5lv+WKpFxCA9GP/L1wiHu4sLJ5YBSOKmoGTd2lYUVXvNAa5PTTv2oEn0Tyw
 kLFc5qeT
 v5eC5YVgkFwVI72oIxe7SNJw+SDCxKfWleyw1pzoF0H3t78f2VVHhcjHdGkqiKKGjyklJiGSMOpQ44wUzFGsCqZgNVRA/br4P5Ffh4ifzTG/xnHHwCXHzuWpTpRhrj8DZEoBV1SBQ9YBCZ46/atlkw3s1arIvLLaK5lwWBVedUsddNNYbCUZRC76HYWDjcxrTkUojvNZqoutJ5ru9yFCXEPKvLOjRpIWRC7d1k+LkZJzPqqm0GXI9AV99iTUoVwDASd/I1f3tCprtUfVvHV9GXav+wGJxhtK/MF9NjXzay2ibDVNAbvqmFVj2MR5t7dz2+ydmFItkT8H5JD+guYcf8b4YwFQB+OihJHNK4S/k2wZxK9QDYqS9mwhXbJNNjstcAHhmQopT9zQ5JSEBzqQ1kuR1KJvlGDunvwGyrZIhuNhm/nR6vlm13nroZncTll9UsUEYdfNs/OHqQQqBlvfIQc03SmOpdaWJpYm8m23aAiE/KQS7xxhMPTDEh1U9+9Rq8mIgje67ykdj5dp+j2M5J3mqOziOurLuq2RzXG5uff4iD6QIdAiQhJ2tsY7pdMgETpNXeVAKebjdx6B5wdPvI+UqwNj2PFUAPUh54mHOh80pxoT6JC/xuO1i7nLGngCgjyGh6yeDLhOrjxM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add ARRAY_END(), and use it to fix off-by-one bugs

ARRAY_END() is a macro to calculate a pointer to one past the last
element of an array argument.  This is a very common pointer, which is
used to iterate over all elements of an array:

        for (T *p = a; p < ARRAY_END(a); p++)
                ...

Of course, this pointer should never be dereferenced.  A pointer one
past the last element of an array should not be dereferenced; it's
perfectly fine to hold such a pointer --and a good thing to do--, but
the only thing it should be used for is comparing it with other pointers
derived from the same array.

Due to how special these pointers are, it would be good to use
consistent naming.  It's common to name such a pointer 'end' --in fact,
we have many such cases in the kernel--.  C++ even standardized this
name with std::end().  Let's try naming such pointers 'end', and try
also avoid using 'end' for pointers that are not the result of
ARRAY_END().

It has been incorrectly suggested that these pointers are dangerous, and
that they should never be used, suggesting to use something like

	#define ARRAY_LAST(a)  ((a) + ARRAY_SIZE(a) - 1)

	for (T *p = a; p <= ARRAY_LAST(a); p++)
		...

This is bogus, as it doesn't scale down to arrays of 0 elements.  In the
case of an array of 0 elements, ARRAY_LAST() would underflow the
pointer, which not only it can't be dereferenced, it can't even be held
(it produces Undefined Behavior).  That would be a footgun.  Such arrays
don't exist per the ISO C standard; however, GCC supports them as an
extension (with partial support, though; GCC has a few bugs which need
to be fixed).

This patch set fixes a few places where it was intended to use the array
end (that is, one past the last element), but accidentally a pointer to
the last element was used instead, thus wasting one byte.

It also replaces other places where the array end was correctly
calculated with ARRAY_SIZE(), by using the simpler ARRAY_END().

Also, there was one drivers/ file that already defined this macro.  We
remove that definition, to not conflict with this one.

Cc: Kees Cook <kees@kernel.org>
Cc: Christopher Bazley <chris.bazley.wg14@gmail.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Marco Elver <elver@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Jann Horn <jannh@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: "Maciej W. Rozycki" <macro@orcam.me.uk>
In-Reply-To: <cover.1758806023.git.alx@kernel.org>

---

Hi,

I've rebased v5 on top of v6.18.  The patches are identical (see
range-diff below).  I've tested them again, to make sure they're fine,
although I'm not sure I have enabled all configs to build all of this
code.  Please make sure everything builds, or let me know if (and how)
I should test anything else.

Some details of the .config I used for testing:
	$ cat .config | grep KUNIT_TEST | grep -v -e ^# -e CRYPTO
	CONFIG_KCSAN_KUNIT_TEST=y
	CONFIG_KFENCE_KUNIT_TEST=y

From v6.18:
	$ sudo dmesg | grep -inC2 kfence | sed 's/^...//' > tmp/kfence_master;

From this branch:
	$ sudo dmesg | grep -inC2 kfence | sed 's/^...//' > tmp/kfence_endof;

Results:
	$ diff -U0 \
		<(cat tmp/kfence_master \
			| sed 's/0x[0-9a-f]*/0x????/g' \
			| sed 's/[[:digit:]]\.[[:digit:]]\+/?.?/g' \
			| sed 's/#[[:digit:]]\+/#???/g' \
			| sed 's/././') \
		<(cat tmp/kfence_endof \
			| sed 's/0x[0-9a-f]*/0x????/g' \
			| sed 's/[[:digit:]]\.[[:digit:]]\+/?.?/g' \
			| sed 's/#[[:digit:]]\+/#???/g' \
			| sed 's/././');
	--- /dev/fd/63	2025-12-10 23:45:12.512438818 +0100
	+++ /dev/fd/62	2025-12-10 23:45:12.516438854 +0100
	@@ -17 +17 @@
	-.-[  68?.?] allocated by task 2516 on cpu 21 at 68?.?s (?.?s ago):
	+.-[  68?.?] allocated by task 2515 on cpu 8 at 68?.?s (?.?s ago):
	@@ -31 +31 @@
	-.-[  68?.?] allocated by task 2516 on cpu 0 at 68?.?s (?.?s ago):
	+.-[  68?.?] allocated by task 2515 on cpu 1 at 68?.?s (?.?s ago):
	@@ -45 +45 @@
	-.-[  68?.?] allocated by task 2518 on cpu 10 at 68?.?s (?.?s ago):
	+.-[  68?.?] allocated by task 2517 on cpu 4 at 68?.?s (?.?s ago):
	@@ -59 +59 @@
	-.-[  68?.?] allocated by task 2518 on cpu 2 at 68?.?s (?.?s ago):
	+.-[  68?.?] allocated by task 2517 on cpu 4 at 68?.?s (?.?s ago):
	@@ -73 +73 @@
	-.-[  68?.?] allocated by task 2520 on cpu 10 at 68?.?s (?.?s ago):
	+.-[  68?.?] allocated by task 2519 on cpu 14 at 68?.?s (?.?s ago):
	@@ -87 +87 @@
	-.-[  68?.?] allocated by task 2522 on cpu 10 at 68?.?s (?.?s ago):
	+.-[  68?.?] allocated by task 2521 on cpu 14 at 68?.?s (?.?s ago):
	@@ -101 +101 @@
	-.-[  68?.?] allocated by task 2524 on cpu 10 at 68?.?s (?.?s ago):
	+.-[  68?.?] allocated by task 2523 on cpu 14 at 68?.?s (?.?s ago):
	@@ -115 +115 @@
	-.-[  68?.?] allocated by task 2526 on cpu 15 at 68?.?s (?.?s ago):
	+.-[  68?.?] allocated by task 2525 on cpu 18 at 68?.?s (?.?s ago):
	@@ -129 +129 @@
	-.-[  68?.?] allocated by task 2532 on cpu 8 at 68?.?s (?.?s ago):
	+.-[  68?.?] allocated by task 2531 on cpu 15 at 68?.?s (?.?s ago):
	@@ -143 +143 @@
	-.-[  68?.?] allocated by task 2534 on cpu 8 at 68?.?s (?.?s ago):
	+.-[  68?.?] allocated by task 2533 on cpu 15 at 68?.?s (?.?s ago):
	@@ -157 +157 @@
	-.-[  68?.?] allocated by task 2536 on cpu 8 at 68?.?s (?.?s ago):
	+.-[  68?.?] allocated by task 2535 on cpu 15 at 68?.?s (?.?s ago):
	@@ -171 +171 @@
	-.-[  68?.?] allocated by task 2538 on cpu 14 at 68?.?s (?.?s ago):
	+.-[  68?.?] allocated by task 2537 on cpu 15 at 68?.?s (?.?s ago):
	@@ -185 +185 @@
	-.-[  68?.?] allocated by task 2540 on cpu 8 at 68?.?s (?.?s ago):
	+.-[  68?.?] allocated by task 2539 on cpu 3 at 68?.?s (?.?s ago):
	@@ -199 +199 @@
	-.-[  68?.?] allocated by task 2540 on cpu 8 at 68?.?s (?.?s ago):
	+.-[  68?.?] allocated by task 2539 on cpu 3 at 68?.?s (?.?s ago):
	@@ -213 +213 @@
	-.-[  68?.?] allocated by task 2542 on cpu 8 at 68?.?s (?.?s ago):
	+.-[  68?.?] allocated by task 2541 on cpu 15 at 68?.?s (?.?s ago):
	@@ -227 +227 @@
	-.-[  68?.?] allocated by task 2542 on cpu 1 at 68?.?s (?.?s ago):
	+.-[  68?.?] allocated by task 2541 on cpu 1 at 68?.?s (?.?s ago):
	@@ -241 +241 @@
	-.-[  68?.?] allocated by task 2552 on cpu 23 at 68?.?s (?.?s ago):
	+.-[  68?.?] allocated by task 2551 on cpu 11 at 68?.?s (?.?s ago):
	@@ -255 +255 @@
	-.-[  68?.?] allocated by task 2554 on cpu 1 at 68?.?s (?.?s ago):
	+.-[  68?.?] allocated by task 2553 on cpu 5 at 68?.?s (?.?s ago):
	@@ -275 +275 @@
	-.-[  68?.?] allocated by task 2564 on cpu 9 at 68?.?s (?.?s ago):
	+.-[  68?.?] allocated by task 2563 on cpu 13 at 68?.?s (?.?s ago):
	@@ -289 +289 @@
	-.-[  68?.?] allocated by task 2566 on cpu 9 at 68?.?s (?.?s ago):
	+.-[  68?.?] allocated by task 2565 on cpu 15 at 68?.?s (?.?s ago):


Have a lovely night!
Alex


Alejandro Colomar (4):
  array_size.h: Add ARRAY_END()
  mm: Fix benign off-by-one bugs
  kernel: Fix off-by-one benign bugs
  mm: Use ARRAY_END() instead of open-coding it

 drivers/block/floppy.c     | 2 --
 include/linux/array_size.h | 6 ++++++
 kernel/kcsan/kcsan_test.c  | 4 ++--
 mm/kfence/kfence_test.c    | 4 ++--
 mm/kmemleak.c              | 2 +-
 mm/kmsan/kmsan_test.c      | 2 +-
 mm/memcontrol-v1.c         | 4 ++--
 7 files changed, 14 insertions(+), 10 deletions(-)

Range-diff against v4:
1:  9f87d6208a6c = 1:  5973cfb67419 array_size.h: Add ARRAY_END()
2:  ac55d92551e4 = 2:  9c38dd009c17 mm: Fix benign off-by-one bugs
3:  ca8dec7f5bc9 = 3:  b4a945a4d40b kernel: Fix off-by-one benign bugs
4:  980c8fe8a6de = 4:  e7bde864b039 mm: Use ARRAY_END() instead of open-coding it
-- 
2.51.0


