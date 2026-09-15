Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E2138C88E7F
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 11:34:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 078396B00B4; Tue, 15 Sep 2026 07:34:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 04EEB6B00B6; Tue, 15 Sep 2026 07:34:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E774C6B00B4; Tue, 15 Sep 2026 07:34:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C81A26B00B4
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 07:34:19 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 62F811403DA
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 11:34:19 +0000 (UTC)
X-FDA: 85215788238.01.186590D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 8D0021C0006
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 11:34:17 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lOHGXy8c;
	spf=pass (imf21.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789472057;
	b=zOznUubnUQa7PJptspIeoIkbDZpbDQuBakv9PuxSqpHkJOx2MOJDAIcAXJpFS/kJiqzODW
	5BBZs8MpsCVdl3n31p/VYt0NclLiqR0UvCWkEOXDAxYUdjtzBSIySzzoIM6NxUfUEw1yQH
	ZUdl0Slaqmvw0i1Z8eD0vNHqF6JLGYU=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lOHGXy8c;
	spf=pass (imf21.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789472057;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bA4ynAEQWzLS8TLe1OyiMNmBCpxqZtxYswH6/3xEJn0=;
	b=69rTJqSoQykshO9cL4GSYD17UmGcn3N86RL3YzsRQqH1C81r9hWsIy4yffXlocF1snhKnh
	5umxRC6PpYxnxyaUKg43Gy4v22TAqq2ga16rDfigMnVxRJp8zu3/rMC2MA+pxFIFMKw1eN
	PZoHG1KLIC6XUvzsaSCkVO/nl418Gx4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id DD73B42A92;
	Tue, 15 Sep 2026 11:34:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F2821F0089A;
	Tue, 15 Sep 2026 11:34:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789472056;
	bh=bA4ynAEQWzLS8TLe1OyiMNmBCpxqZtxYswH6/3xEJn0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=lOHGXy8cA8jMMGugeuqOHZsHNH9R6NCpiW1SGzSqk2TyhtRX4C5vLan9jF9Lg4sJM
	 A2A2QCI68wPGNuvnvsrzBxBe+YzlBhd/5q0D0YjdRbOCeZ4h8kXDe3U7+UuYQS9gSN
	 nEwgErx77J2ER2m1k0BupFTZUzEnThzBPGlrZZvpU1Un3NXwFxcQXOSeuFbFE3Jgku
	 eXAGNFsAkifaZ03d/z3uqPrGplip5My3/DUaiek0wZjCAPE/m4YXJ55H3MQW+eeCW6
	 5funLtKEK3ijtyLwLxFdU4Hr4SHgxA1Jfy6H6zqgczgxiU00tDcHkC1P9UYL1yAfe1
	 +SqeWUaLUrpuA==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 15 Sep 2026 13:31:09 +0200
Subject: [PATCH RFC POC 23/50] file: open-code receive_fd()'s immediate
 install
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260915-work-fd-reserve-unify-folded-v1-23-4d5217d6b246@kernel.org>
References: <20260915-work-fd-reserve-unify-folded-v1-0-4d5217d6b246@kernel.org>
In-Reply-To: <20260915-work-fd-reserve-unify-folded-v1-0-4d5217d6b246@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Jann Horn <jannh@google.com>, 
 Jan Kara <jack@suse.cz>, Ingo Molnar <mingo@redhat.com>, 
 Peter Zijlstra <peterz@infradead.org>, linux-fsdevel@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 Oleg Nesterov <oleg@redhat.com>, linux-alpha@vger.kernel.org, 
 linux-snps-arc@lists.infradead.org, linux-arm-kernel@lists.infradead.org, 
 linux-csky@vger.kernel.org, linux-hexagon@vger.kernel.org, 
 linux-m68k@lists.linux-m68k.org, linux-mips@vger.kernel.org, 
 linux-openrisc@vger.kernel.org, linux-parisc@vger.kernel.org, 
 linux-sh@vger.kernel.org, sparclinux@vger.kernel.org, 
 linux-um@lists.infradead.org, Jens Axboe <axboe@kernel.dk>, 
 io-uring@vger.kernel.org, netdev@vger.kernel.org, 
 linuxppc-dev@lists.ozlabs.org, linux-gpio@vger.kernel.org, 
 linux-arm-msm@vger.kernel.org, dri-devel@lists.freedesktop.org, 
 bpf@vger.kernel.org, David Airlie <airlied@redhat.com>, 
 virtualization@lists.linux.dev, kvm@vger.kernel.org, 
 kexec@lists.infradead.org, linux-hyperv@vger.kernel.org, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.17-dev-db0b7
X-Developer-Signature: v=1; a=openpgp-sha256; l=1378; i=brauner@kernel.org;
 h=from:subject:message-id; bh=9JAnV65R8KRKKJ6YuAvXjbfOJ9otGL1j9hOaIwPGraE=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWSt1KllfvjTfp2zVVTgt9NTTlxN9shpKt3NzyD6qO520
 LPPTxYs7yhlYRDjYpAVU2RxaDcJl1vOU7HZKFMDZg4rE8gQBi5OAZjI1CCG/yUL4597uxz9uSVv
 B5MCM+uUS19mlk6c3GQWOy8v+s8XQzOGv5ILE+KOSk0/EKpzUmdZprjQ2jqtG2qZb/98t1fIsHn
 zhgcA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 8D0021C0006
X-Stat-Signature: ptyes59sz9kuaoghmd5rz6wif845tuhq
X-HE-Tag: 1789472057-908985
X-HE-Meta: U2FsdGVkX1/OHu6OfecVRb1hzArHEouMbW1UiqQb7eJbj1eVPByHYR0yl7ytXaC6YfmzO9Fg5/v2iRh9Z8fb1HHye458K7Pm2uDCDZn581I2s0jCnmzdbdEC9D5bZqbMxbsIEP4AgVOeRKHDhFCG/wJiGIdHfn5BvAJraiWj3gfIOr2sNSiizhkiFwtNVEBRxNtODz3hVCH3xT/88+l69rMxY6UbN7NvdUBIAcQTZYiin1N0stTRIS/tHAtHvYDvd3y/+9dSa++T1UQ1jVrplvMhxXjl+lk3NuCdRZfEngjZqZj3pDZ+kcUTK702ptoqFBx8gf6AtH9MbyzMxTsWhcgeJbSScuJSEUMz05eD05ThZW5KTJZyOcDUKanL0yS9LcNbveEUf2AV/yAAiI6zkLzuRGe5YQ4IcCkWrUzB2OopoT3FILRxGVw+6TDgpS4ArOetG9iNzoA8zsl1xBdb+cLNj2PILGAOcSDd8/kcxKmT7ERMMIQFvKET+hqZQX7HoHOf7DbAxzwi+pnng1Urty3o/TXFgOJ7+ZK4UB8VTo1UCQ47RvE4Fo9kzjhxRn0DEsjGdxeJiASR/NhSn2Y9tF3DvEItcbONC+NMDKISzVcXABNIr2bZJ7F9JKOMMP3hXP4v7qDcyiFm7PuRW5FfZ2P+E/xZEdmovZ/5zsrcRArQDM/yg4pbubE77EThz/RJjxa4p/4PNtb0n0AlLeqanU5pmXBDFzVLkQJ+nwpnNJqyYbZ1oOnleDDxvmib/rWtAFwciH4h9ONa4rToRytcVzl04FTM6PjdxIGf363vuiQYeKMhdlMX06aY3/STLEZd6d/1GqdDHu4LYpUaAeni0vuTGsHafVVZdlAEvoIxvArkD3BxBCsEP0gOpcYAQ02hWZfmaEEEdypffZ7BNOU0v6jc1b8ocfgxqbrB8ZC3QFB155PITkqaKRp56YFN3ZlilGJJ8B53zC8z8cgH51I
 HT6ljCMa
 Y5Skd7JEonh+bFOoQjN1TQ55GYhZynJV4BDFbqEkBHZUCc/+Yokcv51bX+b8Cawqq0YVxrt4LddUkH8c2sNvCgqRc7G03cJ09FS7W0TrRDXk32ZUZN7iI/qq39EnfX9t89RVjwOjAmb+Q17Fw2+3O2mrbWuyv4bELGH6Hn8s/wojlehQXNIGrgXnLam3ktEPl/RW6qQWLkeckxyT5yk/TsNMbr4XAfD0KE9CQZSVuE5chF+2QYDg07yjnjaABousgneY+JL6PXCilcXL1AV8M/38NaCCJOE+YB8t2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

receive_fd() cannot defer to syscall exit as SECCOMP_IOCTL_NOTIF_ADDFD
installs into the target task and hands the number to the supervisor
and IORING_OP_FIXED_FD_INSTALL runs from an io_uring op. Open-code the
get_unused_fd_flags() + fd_install() it did through FD_PREPARE().

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/file.c | 20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/fs/file.c b/fs/file.c
index 2b041b45f225..1f06d0c846c2 100644
--- a/fs/file.c
+++ b/fs/file.c
@@ -1607,25 +1607,27 @@ int replace_fd(unsigned fd, struct file *file, unsigned flags)
  */
 int receive_fd(struct file *file, int __user *ufd, unsigned int o_flags)
 {
-	int error;
+	int fd, error;
 
 	error = security_file_receive(file);
 	if (error)
 		return error;
 
-	FD_PREPARE(fdf, o_flags, file);
-	if (fdf.err)
-		return fdf.err;
-	get_file(file);
+	fd = get_unused_fd_flags(o_flags);
+	if (fd < 0)
+		return fd;
 
 	if (ufd) {
-		error = put_user(fd_prepare_fd(fdf), ufd);
-		if (error)
+		error = put_user(fd, ufd);
+		if (error) {
+			put_unused_fd(fd);
 			return error;
+		}
 	}
 
-	__receive_sock(fd_prepare_file(fdf));
-	return fd_publish(fdf);
+	__receive_sock(file);
+	fd_install(fd, get_file(file));
+	return fd;
 }
 EXPORT_SYMBOL_GPL(receive_fd);
 

-- 
2.53.0


