Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4D76D6071841
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 01:23:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=Cs29LN2V
Received: by kanga.kvack.org (Postfix)
	id 0E2D56B05B7; Mon,  9 Nov 2026 20:23:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0BBBE6B05B8; Mon,  9 Nov 2026 20:23:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F3A436B05B9; Mon,  9 Nov 2026 20:23:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D2BB06B05B7
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 20:23:02 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 52BD0160149
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 01:23:02 +0000 (UTC)
X-FDA: 85417460604.09.2304923
Received: from mta1.migadu.com (out-21.mta1.migadu.com [95.215.58.21])
	by imf03.hostedemail.com (Postfix) with ESMTP id 475AA2000A
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 01:23:00 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Cs29LN2V;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf03.hostedemail.com: domain of vineet.gupta@linux.dev designates 95.215.58.21 as permitted sender) smtp.mailfrom=vineet.gupta@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794273780;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zDcWjEiuTeWEvpP/9tc/MwWduB+JGfUQadQax8dMPQY=;
	b=oDCIAmvUeOHBCaJtujm0Bz5FAR1bWPZIE/dopIN/rrUd3ppB0LcQolLkjEhMMb9ChIluAs
	XINxwqoLtuS8woiKa3Sml1BaXZ68bMuN9Jv8yE9PA2qpAVKZlIjCyszWM3IWUPylYQ+SIf
	PhSgZQEwdDjAnmQKAFy42ElvvUxvha4=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Cs29LN2V;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf03.hostedemail.com: domain of vineet.gupta@linux.dev designates 95.215.58.21 as permitted sender) smtp.mailfrom=vineet.gupta@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794273780;
	b=IpNqp9RrZ7bKPX2XnzfwL4lybHaqh8W5D+KERQqmUZrvMrrRayJAeRexPGRrrjffi9hsSI
	lAswl8oAP+TKsd3P16NmcthV2DQl2PZm6Ttf+ClJnTFbziSvRt6vJN2gI69UCy5msuwka4
	e2fxW4hJiTfHjvOIBz+luJ2U5dP5iv8=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=B8IHCXgmRdg1OYPmSUOl1x4rvW8jBb9fhzbRGWNLTsM=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794273779; v=1; x=1794878579;
 b=Cs29LN2VHlAOEjnMd3Gru4jSkSiDLqmKvlECKk9+WEUqQTAxpk0Ydjl1qntxQHcq0ojBh7R/
 GdkG3PuyxOiBui1dNP3zOp26WWCyg9Jvd2KNk4s1kGbOfXKMeUU9O/2VQajlimu98U7glguSp/A
 QUL3lHHpNQ+dAWDBtCFWHSOw=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 492985442f232e3a;
	Tue, 10 Nov 2026 01:22:58 +0000
X-Mizu-Trace-ID: 492985442f232e3a
X-Migadu-Flow: FLOW_OUT
From: Vineet Gupta <vineet.gupta@linux.dev>
To: dennis@kernel.org,
	tj@kernel.org,
	cl@gentwo.org,
	peterz@infradead.org,
	mingo@redhat.com,
	will@kernel.org,
	boqun@kernel.org
Cc: longman@redhat.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	bpf@vger.kernel.org,
	ast@kernel.org,
	andrii@kernel.org,
	daniel@iogearbox.net,
	acme@kernel.org,
	yonghong.song@linux.dev,
	eddyz87@gmail.com,
	martin.lau@linux.dev,
	nathan@kernel.org,
	ndesaulniers@google.com,
	morbo@google.com,
	justinstitt@google.com,
	llvm@lists.linux.dev,
	Vineet Gupta <vineet.gupta@linux.dev>
Subject: [RFC PATCH 2/2] local_lock: do not put btf_type_tag on the lock guard type
Date: Mon,  9 Nov 2026 17:22:35 -0800
Message-ID: <20261110012235.1024461-3-vineet.gupta@linux.dev>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261110012235.1024461-1-vineet.gupta@linux.dev>
References: <20261110012235.1024461-1-vineet.gupta@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 475AA2000A
X-Stat-Signature: jzt6xswppxtcppa1d8931aehwfm4r665
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794273780-258688
X-HE-Meta: U2FsdGVkX1+uSbD3bDESoK8lEdlXcfsoN/SMIWkhUbVdQzhx4g1USSY6wUEdnTNBMXuPT2BDtKvjjmDY0CuvHRgN4qFulM9ZAfIK//2mH+nYsyZL2RuDQjQPpKtXmB1JmtjYsKxEqxmVbvzN9Nkye28xr52HvBnc8yBGfAbPvMsn7e18XPW5lzfBSanpADxqFD2+vtD5zalAFyjkV+wUDkDSSbto7LCfjIwQjkV4IyYtqUYKkaz9n+dm9FRvFayaXnUXZ15+XklWbrjWp9RbNc/hg1rWzM9n2/2TQYCHYXP/7qiBcYCkAIPHYWWHcEBXiY1OyaxI9zz2gIMRq5keHKCT0Det+5hPTt///iXpwaGqVIZDdPJHHyz2eigQ1VpJlUsO59krP/39pXntNQnqNKihlds+jC/CkF5cNngxgOlhl9TEaGrwgR28DpyeuYHdET2U6g7MxHNiVxCA0JzsfMNgfK1/BK/U0kqi326MzZk+EHOYp5ikbOFavcb9MU6Yjt1tEQWQHtd0Oa00kZRZxT6hDDJUDCXWn6GTx+4mbCKxR4tzkP1EGgfrq3AvyXlPKLR7SM/N3MGwH2CeRMRRuxToAjAv1HfrUuf587/HfXU0T6IhN8XCS36yVTM9R2KJWJPs2UNXcArAVj7Th8w9x/LARJ8H6pp9SEMiaI/RFZ1JBUkNn2h34Uqb4+8jEjnbiGOby1LO97kQVgj2LeLirE+aCf+edl9mZFkKi/q3T65DHZhC9DrNbwWJ7h/zt+ae4cg5IJN6mRBRJyszKkjuB6G4qe1rXVurVGwR2zNeM/5JUdGzT8LTJD447knZXlsTTb1EOB/fiVrFRceOCIr3fqPK96dbn62ekplqeU2aj4qUyAsRFGmCLMIqRxbWl22S4ptwR4FftXZ+w6fZf75ZZbajP4xzr+VagRBB8dKwMRBdvB6zRrEzbSS+34tDwb4Oqw1EjTLsMKLWIhXzdj0
 hSNumCb2
 ULWHUidjLvRHVImml4mFPNIaO4QqaYd/MGwKGnF3eKoMrW4F3KbBLyXXYbsrCT/7g3TOTdMZzzsaYVcvHI2h2e8coKVSx5BrYI0GLRQBwqyU+bMdHWXEq95/yHMbtwcm2L/ZOtpQJxf5W3GTtNwWg25XYUXaDRaVcDE6HymZiNWfu1sHUk7hHJLuRYx4aoOFxDJSdttnIfinuwl6h8KAUEdzsM3BR30sBMY6ruMnd0pdtrYEWMDCiDy6bXVOYoszjJUDAXY2NW+UKMm+IYBDwNCvp7g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

local_lock.h applies __percpu the same way the per-cpu declarations do,
and hits the same problem as the previous patch:

	DEFINE_LOCK_GUARD_1(local_lock, local_lock_t __percpu,
			    local_lock(_T->lock),
			    local_unlock(_T->lock))

	local_lock.h:86:1: warning: ignoring attributes applied to
	'struct local_lock' after definition [-Wattributes]

which -Werror turns into a build failure, four times over: the same
pattern is repeated for local_lock_irq, local_lock_irqsave and
local_lock_nested_bh.

local_lock_t is a typedef of struct local_lock, and DEFINE_LOCK_GUARD_1()
hands its second argument to cleanup.h, which forms a typedef of it and a
guard struct holding a pointer to it. An x86 defconfig preprocesses the
line above to

	typedef local_lock_t __seg_gs
	__attribute__((btf_type_tag("percpu"))) lock_local_lock_t;

	typedef struct { local_lock_t __seg_gs
	__attribute__((btf_type_tag("percpu"))) *lock; } class_local_lock_t;

Both put the tag on local_lock_t, an aggregate: the first on a typedef of
it, the second on the pointee of the guard's member. Every variant of an
aggregate shares one DIE, so there is nowhere to record it, exactly as for
DECLARE_PER_CPU() of a struct. clang writes the annotation into DWARF
without complaint, but pahole does not translate it from that position,
so with today's toolchains it reaches BTF from neither compiler.

Use __percpu_var here too, which leaves

	typedef local_lock_t __seg_gs lock_local_lock_t;
	typedef struct { local_lock_t __seg_gs *lock; } class_local_lock_t;

Sparse keeps the __percpu address space, and the __releases() casts to
"local_lock_t __percpu **" further down are unchanged, so the pointer
spelling the tag exists for keeps it.

Unlike the per-cpu declarations this changes no BTF at all. A tag in that
position was never recorded, so there is nothing to remove, and the one
percpu TYPE_TAG that does reach a local_lock type comes from those casts,
which keep it. An x86 defconfig built with clang is identical with and
without this patch: 152551 BTF types and a 6828300 byte .BTF either way,
and .text is unchanged. The patch removes a GCC diagnostic and no more.

Signed-off-by: Vineet Gupta <vineet.gupta@linux.dev>
---
 include/linux/local_lock.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/linux/local_lock.h b/include/linux/local_lock.h
index b8830148a859..9d3d62e46007 100644
--- a/include/linux/local_lock.h
+++ b/include/linux/local_lock.h
@@ -83,13 +83,13 @@
 #define local_trylock_irqsave(lock, flags)			\
 	__local_trylock_irqsave(__this_cpu_local_lock(lock), flags)
 
-DEFINE_LOCK_GUARD_1(local_lock, local_lock_t __percpu,
+DEFINE_LOCK_GUARD_1(local_lock, local_lock_t __percpu_var,
 		    local_lock(_T->lock),
 		    local_unlock(_T->lock))
-DEFINE_LOCK_GUARD_1(local_lock_irq, local_lock_t __percpu,
+DEFINE_LOCK_GUARD_1(local_lock_irq, local_lock_t __percpu_var,
 		    local_lock_irq(_T->lock),
 		    local_unlock_irq(_T->lock))
-DEFINE_LOCK_GUARD_1(local_lock_irqsave, local_lock_t __percpu,
+DEFINE_LOCK_GUARD_1(local_lock_irqsave, local_lock_t __percpu_var,
 		    local_lock_irqsave(_T->lock, _T->flags),
 		    local_unlock_irqrestore(_T->lock, _T->flags),
 		    unsigned long flags)
@@ -100,7 +100,7 @@ DEFINE_LOCK_GUARD_1(local_lock_irqsave, local_lock_t __percpu,
 #define local_unlock_nested_bh(_lock)				\
 	__local_unlock_nested_bh(__this_cpu_local_lock(_lock))
 
-DEFINE_LOCK_GUARD_1(local_lock_nested_bh, local_lock_t __percpu,
+DEFINE_LOCK_GUARD_1(local_lock_nested_bh, local_lock_t __percpu_var,
 		    local_lock_nested_bh(_T->lock),
 		    local_unlock_nested_bh(_T->lock))
 
-- 
2.53.0-Meta


