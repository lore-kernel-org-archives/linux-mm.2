Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 33AF9D3EE72
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 15:19:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4D74D6B020F; Thu, 22 Jan 2026 10:19:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 497A26B020E; Thu, 22 Jan 2026 10:19:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3AD896B020F; Thu, 22 Jan 2026 10:19:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 1C87F6B020C
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 10:19:02 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D1C3557CED
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 15:19:01 +0000 (UTC)
X-FDA: 84359957682.22.5D8CFF1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 424C81C0008
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 15:19:00 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="F2B/t0Bt";
	spf=pass (imf20.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769095140;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WCc/se3vP6IVUp9H5A8JAvUqt3vuVhT9ES2XwN2NrVQ=;
	b=WCm4I+u76r82HMH7MkDEmR6fpp/tJcj7W23xlyd9n8fJpbIZBMx1tPhHOFxvOgt8Jnf1DI
	RE5u2kJ7srq8qEv5APwFPny0I8CcqBZYsWV7CHp0qzM4Bw2RT7vuDN7YHCF8N4ZWYIIb4y
	Ga66Xx74eGWC2Phq3Pxohw2uz+gR9hg=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="F2B/t0Bt";
	spf=pass (imf20.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769095140; a=rsa-sha256;
	cv=none;
	b=MBvYVSeoWk0PWuEelGFj6R+SIsG0NUjUR10+kRHndump4NzVCTWMirA5RCU+ViC+r+S9pJ
	fke2W+2Fq6fNCaTpowYSmj5H9C953r3BP3D6xd2OAhqg91nh9B4BqMo+YDtKEyQMp5LLJH
	B4R+QviLIYXEeRwVczt/PKUPIAfyEsM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id B94C1600CB;
	Thu, 22 Jan 2026 15:18:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18692C4AF0B;
	Thu, 22 Jan 2026 15:18:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769095139;
	bh=272BvbxC7euhCsy4Z4uBhOtqpvh5RkKjXvXKDX/+ojY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F2B/t0BtpaipEuqECr6q2CJUfcQms0HLxJ1OR2GUvVK3VTqXTupSVgtZ393faJZS7
	 dQHSzB5HL5WVRoPI4ukuPgq0d/qGc7gxjesKU+pdoSlachfAsOmjvl5EJQtZvZ98cf
	 Gp2gxyG+vB+3v1oSUkc9y0Rh8oIjWfDS/aWB/NydQt1SjKfF7jsTWJZCSF9q4wDsww
	 7qizAlroyUkBBvubpL9dkVQsVt1+hSTdmt0fq6l7LUBAv8jv4z5PTv1UZZCFrnO2KG
	 Rp3XuvFMJSQIO+AGJDB+u0tQRtAgTYNvF4hTXVH0vo5/zcIP1tQMXwmuCIG/0JvOKV
	 Nn8gSvDHKY5+g==
From: Pratyush Yadav <pratyush@kernel.org>
To: Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Mike Rapoport <rppt@kernel.org>,
	Pratyush Yadav <pratyush@kernel.org>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] memfd: export alloc_file()
Date: Thu, 22 Jan 2026 16:18:39 +0100
Message-ID: <20260122151842.4069702-2-pratyush@kernel.org>
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
In-Reply-To: <20260122151842.4069702-1-pratyush@kernel.org>
References: <20260122151842.4069702-1-pratyush@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 424C81C0008
X-Stat-Signature: 14oja17ghceo9raysqwwhf3yentyg9fs
X-Rspam-User: 
X-HE-Tag: 1769095140-633626
X-HE-Meta: U2FsdGVkX18S2/sWBwikG/EcasBMhphCaIferTzBhjc2A4POzWMsLlmiwDaxnaB9/q7ni/XBYb6Kxg1XJPgshxZYIFkAfU4iZbZQX1g3KB3as6VP98orVtpF1gxccm3RNLvKhXh7n6D8FDPecq1xhDkjpzUefYGEqmT/nxs3r/TFMGBAg5vuEQa3Mfr2vzbptyHgtX1W2w4SPh9hQOk1kQkQvfolMNbQXoQq3aZRzz9B2PASUEOp7bxXZOKZNXvdcihSkaauSnKqXBgqHvh04vcAonkcM2VC8+VKB8vqFUTOJUdO4E0AEK98G7eDveSzbZQ+/ucEkO5vj6CNfEtEt54CPz4xzBawPz5DSxLt39nouE8TjcdtZq8IKZkYCNRydWsgZR9/9bfRx7L5CprwkfaBcmQZkXuOvg4XTkdcJh8+mfNWRWMEOsNeKvxE3Wf6im3scM5ub35P/Q6dcKQbI2F0yFuAuo3ydy2dEX33TaPBgqgJrPU1b4mDbkBHB3jcSB10oRR9hSAF0np4+kDWN1TPGPq+fXfor9DBDiCLU59rZGoptxhBXzwqUSgZZfVIfqlvJ5yVILNZRBm8bl19n9QK+U9m0gDJ/8vS1j1PsYjs8RLbso7pS2MU1r5kmVccTgxTPvIXkrXAb5AJocwhLxP17kr8/Zmnpy/0vUi+pVs6juZ3pAWaLhCOdX9eFGyB4Nb4iA2gS6xNo292rcqSBwQ3P6VbGW82OTvS6M60G+3lJAKZrluXKxuc0Rc5UlL2IZPvo9azQo5okPA8+YzbAWpp8QqcM7xTLKGks+ia1u3gJGB6NSyuEIA5qrTY1WCqW6Ezsezhsw86d4dYVdIJ0WY/tg8xkAu717kN/HYNBPcBTOpnxytU8ihwjI3m2lPVqDZufQl1xTfxlUf7L9//RvYWhm9PeC14PbnEo68mMuRrIvqEnGYeU97CgaV000qtmOfjcYP0LJP39hc2Qqb
 tRPR6I88
 QlNrXEeNpmxf/NzrZFMMMATHWzen34vr3xUM6Weu/seFDkNffNoPLKhAoC+21e8mRNk/vryiccUsTuSr0CIMyk1gUkNc5lGStqcn2rnIsv/EwLmXZvEaYRUSiJQuyfqqFP38W0i88tfiJaIYtGPhsEHO7mg6MU2mtJLhXy8dAN+ZZHfxxRGMnusOmYzgo5FL0IZRU9r9xa3TQ52FRzuIrm6j2L2iHWj4+xTdCxTvHPPUj1YXCTmPqO1JW73H5yjT0ytdJaFl+aMo2b1De9Mgr45H9FA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Pratyush Yadav (Google)" <pratyush@kernel.org>

The Live Update Orchestrator's (LUO) memfd preservation works by
preserving all the folios of a memfd, re-creating an empty memfd on the
next boot, and then inserting back the preserved folios.

Currently it creates the file by directly calling shmem_file_setup().
This leaves out other work done by alloc_file() like setting up the file
mode, flags, or calling the security hooks.

Export alloc_file() to let memfd_luo use it. Rename it to
memfd_alloc_file() since it is no longer private and thus needs a
subsystem prefix.

Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
---
 include/linux/memfd.h | 6 ++++++
 mm/memfd.c            | 4 ++--
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/include/linux/memfd.h b/include/linux/memfd.h
index cc74de3dbcfe..c328a7b356d0 100644
--- a/include/linux/memfd.h
+++ b/include/linux/memfd.h
@@ -17,6 +17,7 @@ struct folio *memfd_alloc_folio(struct file *memfd, pgoff_t idx);
  * to by vm_flags_ptr.
  */
 int memfd_check_seals_mmap(struct file *file, vm_flags_t *vm_flags_ptr);
+struct file *memfd_alloc_file(const char *name, unsigned int flags);
 #else
 static inline long memfd_fcntl(struct file *f, unsigned int c, unsigned int a)
 {
@@ -31,6 +32,11 @@ static inline int memfd_check_seals_mmap(struct file *file,
 {
 	return 0;
 }
+
+static inline struct file *memfd_alloc_file(const char *name, unsigned int flags)
+{
+	return ERR_PTR(-EINVAL);
+}
 #endif
 
 #endif /* __LINUX_MEMFD_H */
diff --git a/mm/memfd.c b/mm/memfd.c
index ab5312aff14b..f032c6052926 100644
--- a/mm/memfd.c
+++ b/mm/memfd.c
@@ -456,7 +456,7 @@ static char *alloc_name(const char __user *uname)
 	return ERR_PTR(error);
 }
 
-static struct file *alloc_file(const char *name, unsigned int flags)
+struct file *memfd_alloc_file(const char *name, unsigned int flags)
 {
 	unsigned int *file_seals;
 	struct file *file;
@@ -520,5 +520,5 @@ SYSCALL_DEFINE2(memfd_create,
 		return PTR_ERR(name);
 
 	fd_flags = (flags & MFD_CLOEXEC) ? O_CLOEXEC : 0;
-	return FD_ADD(fd_flags, alloc_file(name, flags));
+	return FD_ADD(fd_flags, memfd_alloc_file(name, flags));
 }
-- 
2.52.0.457.g6b5491de43-goog


