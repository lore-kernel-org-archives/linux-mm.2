Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 80923F53D65
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 15:20:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D63DD6B02DF; Mon, 16 Mar 2026 11:20:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D3B946B02E0; Mon, 16 Mar 2026 11:20:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C308A6B02E1; Mon, 16 Mar 2026 11:20:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AFC976B02DF
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 11:20:12 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5193013A5EF
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 15:20:12 +0000 (UTC)
X-FDA: 84552287064.23.50D6FD8
Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	by imf17.hostedemail.com (Postfix) with ESMTP id 7FBB940011
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 15:20:10 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="YMC/RDqk";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf17.hostedemail.com: domain of kartikey406@gmail.com designates 209.85.216.46 as permitted sender) smtp.mailfrom=kartikey406@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773674410;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=W09BwawQXBw7qZlw0AhGoZ1ZZiQnOnbL7dJOy6IZMDo=;
	b=OFD4XCB+tanjSaKZAU6G7iepMksMNC+CMNNPBuDontWxI3Wyr5Sgln6aI47o61z2e91vC4
	gX8k8oKaoKWhgM947SGF8DnvWQQG/nrH1PZQPJuX/9mMYsq9bCsciOHwGraw575dei0L2w
	4/Q0+pzCOMhaY/Jbb0+Xq8xgB4oLcN4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773674410; a=rsa-sha256;
	cv=none;
	b=I5+Hkqvw8orWCkvntiEBkokFXAWJR7C6W+GzJfFZGV6OFcNB0j2EDHKTPbAJoI8oxey+NN
	BgalZTuURETqAnkqMkEbRTTZN4+WEhhIKOI/OkjD/IAQAgHkbG4x5quPuG9qThQj1PqdvA
	xK9ZWCoXkzb5Wi41/DcA8lAHWeaNZF0=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="YMC/RDqk";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf17.hostedemail.com: domain of kartikey406@gmail.com designates 209.85.216.46 as permitted sender) smtp.mailfrom=kartikey406@gmail.com
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-35a1230c60eso2429598a91.3
        for <linux-mm@kvack.org>; Mon, 16 Mar 2026 08:20:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773674409; x=1774279209; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=W09BwawQXBw7qZlw0AhGoZ1ZZiQnOnbL7dJOy6IZMDo=;
        b=YMC/RDqkMAvH7l52vitZID2V5uqjFJAiHSnSb1M6/4syLeDs/kQ/GT3U0AFp0KK8zy
         McE2EtpMfL39TQapsPM/XrxhQPXIdGhhjSL50DTye8SIdlFKZR05jQfve7hlcuTabjgB
         0vAT5B5Et81fU6yloqKO5cfBPMGosNWfg8nEwtpPKVZu5KVSimaZSRJOUL8jEaLch+lK
         Bs2xsxbYB440jxzIMhPcyieNZUcvzH3eOyTCXWIqPXh4eSqIx2qAEBOlc8ftGqA7IBZA
         QuqqpvmQzz5yKS4S1Yf3vjEuGpyg1ETjrT8bvQnueBV96uZUhpykeJ/ABJsypS9YitQJ
         TS0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773674409; x=1774279209;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=W09BwawQXBw7qZlw0AhGoZ1ZZiQnOnbL7dJOy6IZMDo=;
        b=W63g2vp7CB56KtYgfa8ZRs+lwhtDnjtPbe3Yy0BTpYssw/YR1IigY6P6crpLTw3AYw
         SX0qx7A1DOjqo34S05Xoozj8PgMOV5iPOIr3q6/n5z7ICKvV9Tz//9h02REXiC6SzU42
         9F7X02hdKVlaVQ6Pm7jxlD1ElGnwo86ATEQrf1qv9gXvgf7Qhb5bdXOHnf+ijXlBc38F
         POLj6RDSMrpv2ywUzv6e22dPHMp6gVcbI7mNS7gN2xoQvEwTCo96nhf+cgZJ6CsjNZfs
         d/0yDMElCsy37Ldhk9RO+OOO/VuleMaAYhScSzMv9y6vskpagGT+rSQLS+nW8VsodQTb
         Q+kQ==
X-Forwarded-Encrypted: i=1; AJvYcCW0RHFy+xdql4lESTYEMvDOB+x1vtgUGIoZ0A30PVfYoshYqFddZfQ/kkabBakbj7u+Wz7Uyfb0mA==@kvack.org
X-Gm-Message-State: AOJu0Yz5OzR5TBqYAAgDQj9CjkHWD+7lVzhVXNykFBB5DqK9Ci+qUKKZ
	15UB0mrJgGS1DeeVFE0ohNnsCDioN4dsnBOIJqvV0IgQKOLIZZK73TxJ
X-Gm-Gg: ATEYQzxCwwVbMmklwVfb5VDkPT0ia877ZbCVD3bjyqWp+pWwNofpwQQ7QsNMJG5UNHk
	LSxybEDN+LmkwfOlwvjuK1lbo0he17+K48CDJtvoY5md1wVUb5IiIUqSbn9ohEA+zWBn13Gt7dw
	ZtTRcpOCN1Znr1BD7Lw0R9ET8jGqn2TkQPqyx/X/dZalfznT72Z/Z41y3GztgOcG2g+hFDZx9Qg
	4opgh/Tg355EPF/YgR9v7kb1E7rxoXkBq1Nptzj08VJ9DWHujBr1d1SKKQZgCKGQfneKO64Yeiy
	mtRrt/kTQqXfrtvpzkyzUOWEGM4myu03aMqz0GbTSgi6Ms0/Wvvg+BFZCn5t51t4gu1NxAw1qwk
	JmqTys9k1GwQL87Mq/mVqtbbex1S5pViyXYk1OXZFVsTUhe1a/7oxEZVwMEdwe2BI+Rag0/r0vD
	+B+n/5TT9ESDobtffRcEnkT6Wi+6GO07RBBC2ab+DXbSgJF/C4mBTxBQvCIbZ2dgYzrw3fBaPpy
	nshp3I=
X-Received: by 2002:a17:90a:d408:b0:35b:a9f3:62ee with SMTP id 98e67ed59e1d1-35ba9f36aa5mr978278a91.27.1773674409030;
        Mon, 16 Mar 2026 08:20:09 -0700 (PDT)
Received: from deepanshu-kernel-hacker.. ([2405:201:682f:389d:52ce:671a:31ef:56a1])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c7400000532sm4626033a12.27.2026.03.16.08.20.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Mar 2026 08:20:08 -0700 (PDT)
From: Deepanshu Kartikey <kartikey406@gmail.com>
To: mingo@redhat.com,
	peterz@infradead.org,
	juri.lelli@redhat.com,
	vincent.guittot@linaro.org,
	dietmar.eggemann@arm.com,
	rostedt@goodmis.org,
	bsegall@google.com,
	mgorman@suse.de,
	vschneid@redhat.com,
	kees@kernel.org,
	akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	Liam.Howlett@oracle.com,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	brauner@kernel.org,
	oleg@redhat.com
Cc: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Deepanshu Kartikey <kartikey406@gmail.com>,
	syzbot+bbe6b99feefc3a0842de@syzkaller.appspotmail.com,
	Deepanshu Kartikey <Kartikey406@gmail.com>
Subject: [PATCH v3] kernel/fork: validate exit_signal in kernel_clone()
Date: Mon, 16 Mar 2026 20:49:56 +0530
Message-ID: <20260316151956.563558-1-kartikey406@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 7FBB940011
X-Stat-Signature: i9a4oempr55o4kcnyg9i9iuabdnx5uon
X-Rspam-User: 
X-HE-Tag: 1773674410-76236
X-HE-Meta: U2FsdGVkX1/rNrVRBnx+/uV3aCy4Qb7WscDA3T7x3ioGxmw47aaf/d0+xhBX84u3PyKB1bVhBAHcK3LTwEvYZjKly+I6PutWMN1yVP1q2GS6qdfVeDEzD1Fd+DX/M2FvRw+d0oPWU6OoInn5mOhuBxpAZ53hZfN02vUIevr6zw2RVXgQuDEb0IKXXDd5Em/dIjdzVE1KBIzZAqDxlZIcGDpNBBbwC5h9ywpe8lBwsh+vhLZBJGCRp7J+Rb9o01OILIUcIyznpSkVS9Yn/Sz6ibCwLnOdko3tbl008Afeg2Z8houmjDZtmQSEp/Uu4hdiM4qTFNexG2lhtqVv7ym/SDXPX0IN9NT01/Lp3pIYcVaVw4Vs1pMfu0ldBZ6HaOvKgsxedWEw+hF5ViGO5lC3qvb0vxK1ygYZCeE7ubN2bffhL+f1pXJkKHebE6saL8M1ZLOKYnGmz3Tq/WtIUu4nNtN8BuQL3isX0xbx2/Tp56tbm1UgGBV/Dn+/om2YfzQY2ePiDdYJpJDMg0MEYIoFM9dkuhT9cd6X7FjZCPOvEWhHIkS6Zpg2vt+wLvxN2lAmMLTMqkTlhFYCfmUgI93ThKtjRMQZYhYe3s8SFr4ZPdwJhD0F8JQv+BdhMQ7fwero/ZsqcuNDhzRfVSyLbinfNxcmDdmxyYBKZXrc3jJx/RMkKl5ai0At+/bSDAtkjEYYJgRqXPFiQiCZqPXi7dK/tyHxtSP/m8MLodrkutmUYRm/ZP6tO4wtpDmtWVh5IPKWKKqeiviyaPTZJgEqIszHlvLHst5meS48XblXlk16/LxvvszsugeDB4KYaWWML1ftJD3uPmaKyn9OJZShxdl2bD+rSwu60fdQ4KZc3qzT/AvyZc5KkCQgHRDYjN86l2ZTDP3Qsf1VWBueZbEVA7KGt/nTbY8eHQgcu2kGDc2RWLz3B0zOiKzpz3vx4A0lNdz+vLj/Mc01UqrxIxrTd8P
 8tGB6lyp
 Rmj07zALFETNU/f/LyGPK6RRPiEesL+12d2GdcRtAkktsGqLIW72bXTdyZ2zhU8KWIZmiavQkK+0/jVXVIt4osvv95kOwYhd8hjeIi0qt+rja3zzSIgkScJ+aQiQw68O1k59BNs+7ITrlTFp5dMsmXgO+nbR3Uwoydi+9QvEwFhUO/Puwu1veC8nljmMdq1f5cPuq9GUmOd7AB6l8B/ov2La0cPkxpK8bibBcRZfhKLYMe7/tGCZ9tNZsusZltRfRHd4M+sOh1DxyuVLXMdXM2ZoMHNfHsuWpUb/TUiTQnIdDxtRPjY74Gb6ZB0hd2GTytmJF/koQ8y9cq8BXyIWW1C5O0SvCgZMjNeoGjXiKm0xUxPagqhUWufCPXXqDwzOcrU6f8X3pINWIObuV0iBGflyytmlHstzO6s+1+geLLzqcEv6T0Nh5wrywkGLVqJuRgG/je+lVF0w74imyD4DzPVufLpNvtVuaapUEQaVadSE5125rpW+bta4OnEgV8LKhkyrN0DTLqFPOwGJo+4cyQiNITx79ZQBHDt1UIkWfdqQ8aXl/eGLUt4wXv0lqEaT+Im1p7SZ1j7GF7Acpg5tqwcaUnRRkssx/+Kax9NpYI1JjnCzLjnw/avTHe4fQPMoXI4nIKJTe7M36pvKRQmZL13wisRMiQxxqgMkIlqRXcreZ3Jh67DZ4Fshd4KZ4Jd/VhkCb1x4uJQYFWwHt8h5HqvZB3WKhOS3loGUU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When a child process exits, it sends exit_signal to its parent via
do_notify_parent(). The clone() syscall constructs exit_signal as:

(lower_32_bits(clone_flags) & CSIGNAL)

CSIGNAL is 0xff, so values in the range 65-255 are possible. However,
valid_signal() only accepts signals up to _NSIG (64 on x86_64). A
non-zero non-valid exit_signal acts the same as exit_signal == 0:
the parent process is not signaled when the child terminates.

The syzkaller reproducer triggers this by calling clone() with
flags=0x80, resulting in exit_signal = (0x80 & CSIGNAL) = 128, which
exceeds _NSIG and is not a valid signal.

The v1 of this patch added the check only in the clone() syscall
handler, which is incomplete. kernel_clone() has other callers such
as sys_ia32_clone() which would remain unprotected. Move the check
to kernel_clone() to cover all callers.

Since the valid_signal() check is now in kernel_clone() and covers
all callers including clone3(), the same check in
copy_clone_args_from_user() becomes redundant and is removed. The
higher 32bits check for clone3() is kept as it is clone3() specific.

Note that this is a user-visible change: previously, passing an invalid
exit_signal to clone() was silently accepted. The man page for clone()
does not document any defined behavior for invalid exit_signal values,
so rejecting them with -EINVAL is the correct behavior. It is unlikely
that any sane application relies on passing an invalid exit_signal.

Reported-by: syzbot+bbe6b99feefc3a0842de@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=bbe6b99feefc3a0842de
Tested-by: syzbot+bbe6b99feefc3a0842de@syzkaller.appspotmail.com
Link: https://lore.kernel.org/all/20260307064202.353405-1-kartikey406@gmail.com/T/ [v1]
Link: https://lore.kernel.org/all/20260316104536.558108-1-kartikey406@gmail.com/T/ [v2]
Fixes: 3f2c788a1314 ("fork: prevent accidental access to clone3 features")
Signed-off-by: Deepanshu Kartikey <Kartikey406@gmail.com>
---
v3:
  - Remove now redundant valid_signal() check from
    copy_clone_args_from_user() since kernel_clone() now covers
    all callers including clone3()
  - Update changelog to remove WARN_ON mention and describe
    actual bug behavior instead

v2:
  - Move valid_signal() check from clone() syscall handler to
    kernel_clone() to cover all callers including sys_ia32_clone()
  - Update changelog to document user-visible behavior change
---
 kernel/fork.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/kernel/fork.c b/kernel/fork.c
index 947a8dbce06a..73f7fe958a30 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -2687,6 +2687,9 @@ pid_t kernel_clone(struct kernel_clone_args *args)
 	    (args->pidfd == args->parent_tid))
 		return -EINVAL;
 
+	if (!valid_signal(args->exit_signal))
+		return -EINVAL;
+
 	/*
 	 * Determine whether and which event to report to ptracer.  When
 	 * called from kernel_thread or CLONE_UNTRACED is explicitly
@@ -2885,11 +2888,9 @@ static noinline int copy_clone_args_from_user(struct kernel_clone_args *kargs,
 		return -EINVAL;
 
 	/*
-	 * Verify that higher 32bits of exit_signal are unset and that
-	 * it is a valid signal
+	 * Verify that higher 32bits of exit_signal are unset
 	 */
-	if (unlikely((args.exit_signal & ~((u64)CSIGNAL)) ||
-		     !valid_signal(args.exit_signal)))
+	if (unlikely(args.exit_signal & ~((u64)CSIGNAL)))
 		return -EINVAL;
 
 	if ((args.flags & CLONE_INTO_CGROUP) &&
-- 
2.43.0


