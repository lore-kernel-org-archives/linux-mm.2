Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C0893C88E53
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 11:34:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D97356B00B7; Tue, 15 Sep 2026 07:34:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D6EA16B00B9; Tue, 15 Sep 2026 07:34:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C8D406B00B7; Tue, 15 Sep 2026 07:34:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A3FFE6B00B7
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 07:34:27 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 15B591203E9
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 11:34:27 +0000 (UTC)
X-FDA: 85215788574.30.267B94E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 3CDD8160003
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 11:34:25 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JyIhvS+J;
	spf=pass (imf08.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789472065;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KlocZhp7qjck9olR3klidY4UlF+C5OwdG3ef0fBmbDU=;
	b=hxrckquxP+DFkgDzdLC75vZPuSCPs30Y25URURXF6WVqHjhEbxGMX7tt16ibqEA8HuUBQS
	3YKSfjKbPqvBVtyoika+x7Inc/RrHf/tpdZqYiSf44xQRoDnza2JzlcRzDyBWsiuMm533Q
	yQC4CGVvPhuS7YbWo1qxRmeHOx2k8Jo=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JyIhvS+J;
	spf=pass (imf08.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789472065;
	b=qKP17U7fUOnysIWwll+mDOFF8YQKcShPa2SlLGBDuUT3lJxU2ImJsrGTlyk4ig9IaGZ4dS
	QByHJ6ZKIhk1BN7Zn7l6wiJaJwCUVdBZzLulYa0MAAe0zs0AcuryinxNaKH3COAteno+tN
	smMaNXce2z4gq/Qxiyht5P0toXVYHWY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9286F4187C;
	Tue, 15 Sep 2026 11:34:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 405011F000FF;
	Tue, 15 Sep 2026 11:34:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789472064;
	bh=KlocZhp7qjck9olR3klidY4UlF+C5OwdG3ef0fBmbDU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=JyIhvS+JT82mqNUDoQEI5NLWlLHGSvHqAL4SSQ1kt8SKfEf+HfcjXdwmraSKCHGE8
	 ZOy1pOhBVyA8CD8/PMtsr6/M5DyMiVViu2ENl+54eY1cvO87TiRTHmWjqOn6VYaBoZ
	 R+EwigxYuUkdDx++PpQix7gADr1dTufOLv25uLow4e3SSmRhk6Xa/nk8d3fLnQOYYC
	 Ydpt0fW4a/KY4J+ehGRp+fITQ9UnHopTKNJg1/CR1zut9A3qFE0J3crkfG5HDtEzwq
	 G8elLfwAFZ2cfYNwrhA3h2Y1eTB9tlgjFj5+2pZKNm3kY5rb7mp2PNhr6wwTmKvzYc
	 atFGIdRwNt4XQ==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 15 Sep 2026 13:31:10 +0200
Subject: [PATCH RFC POC 24/50] file: make FD_ADD() a standalone immediate
 install
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260915-work-fd-reserve-unify-folded-v1-24-4d5217d6b246@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2484; i=brauner@kernel.org;
 h=from:subject:message-id; bh=T3KSWcji/YSytHTghs9Kt5BT4n+B/RVkFjKfZEpUiUE=;
 b=kA0DAAoWkcYbwGV43KIByyZiAGqpLH2gnJPMvFkt0o4MjNDtgkqII7AmPHUY9LRg5JJdYim/g
 oh1BAAWCgAdFiEEQIc0Vx6nDHizMmkokcYbwGV43KIFAmqpLH0ACgkQkcYbwGV43KIfFQEAxyCZ
 bG8G/x+eu+vLdk6b9eKItI7HciqUsL6XwpabfYsA/1x0tYtG16iv2X3gSieaXgcMCW+XfqmAtez
 piRVBKO4N
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 3CDD8160003
X-Stat-Signature: ruk9qayq5syoef5dg4s13kgkbdgpwznr
X-Rspam-User: 
X-HE-Tag: 1789472065-199084
X-HE-Meta: U2FsdGVkX18Hne4uDzUkuogFgWPAYbTIWUQdLnaQun89dbJhVU8VD6A+1jjCFlCqXWDrxfYTvECjSYWNSqpCB+kW25mwV46rtvx2ttNyifbG/46KNBET81TIfvinHom1JZ+v7SFewSPebBkDSfppPp1PFwHbL5EKokuDb7QzZKl9ngkCHqHOyxxSDzWZcmYWKdIZ7CJ79o3veDhV9mYQ90e/NWZQGTtqSk6gPtYUctPlUULL3mclCzF2R7IxCtb2zvL0IvlwJ2kOGSkjeJvltBR+WuXwI5+uUhq7RsxxN+dPZQOpxynwhvoPT3sV898y9Mx+Powo0KsjIVfF9xZsrquduufvQd9NoISm24zh7aTSCpT4PodjKorpn0AMCxwCYgcqXikeGxjoSJr4AzInYwIcKa2FREHnTKvX2csTPZTS2QYhReG66dU1p5XY5Fszn7dY0+rXwJdSitzD72rRqKMAGKLDpyHE2gQMWI5gJzrSsO8/J8KHQZ2BAh7cQ5825CANwZO1XeOXgqb85s3edruIyNMLvuJ2UytwPmbueucuavu3NXLR+I9aFRy0AhRv7QVk8ZxxDnfmyhDGfUWzs1rkERK0VGdQXTtaBOz781N2/4WpU/IVJURbbrlrwEGf/1Z+YN9KrIZfwcAKpd6YRyMDZroz0CrLZwHDCVZ9Q+7V/1r661dbo67SE4c79vJQlHORSij8ROXc6lqAWEBBpNZotejp1AEzjAtIGNnvT6Z+5mQVB+C3aKbSqR8ptH3VTjPIuKe5J8uNyQE/GvRsp4N6PY7vKWC+HIQZBI1mIqa5oW2b8ugcfcJH7qLtqJkcIzataXXK04/bVvTYsQC3T4+5M6USkXPugg5ag+ZO+TTnOcuY5EpGt2GDVdUPbl7aS+7d2Mm6r5e3ctLoybSIhM8ctx+XKNglrxIYmUfwHiKrJJBa18zlEzBNTY1YxwhvSgJ4URnOlPYeix71EHv
 V6edLG6M
 VU5Ttgq4FzdZ5r+BNdQBKGX9GwZpR+/cidunEVYgFZhmOlxldL7JoRDH5DJd1qyNHcHCvBewN//bIzi6dEIV9UOXPPr9cHZO6mBRT1477rABS9ypfCAW8nAawjn/bwdnNaTqFjTuoY+6S1no+UIwri3/KDrlcocNSCvjLcT6qOUEEcSoyBUCU0ycpYN79yHePbEFf/aoqgs4GUw6UsyvOb6LZaLcvuWgPCGZr39EIOHV+2nRVsV7JEomKSIiOFkb0OQbr7vw9NqtvWqicoCRweSgScebJTs646eD8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

FD_ADD() was built on FD_PREPARE() + fd_publish(). Give it its own small
macro that allocates the descriptor so it stays an immediate one-shot
for the hot descriptor-is-the-result paths (open, socket, accept, memfd
etc.).

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 include/linux/file.h | 36 +++++++++++++++++++++---------------
 1 file changed, 21 insertions(+), 15 deletions(-)

diff --git a/include/linux/file.h b/include/linux/file.h
index 04dd85cdd9bf..1ee7f058a882 100644
--- a/include/linux/file.h
+++ b/include/linux/file.h
@@ -259,24 +259,30 @@ static inline int class_fd_prepare_lock_err(const struct fd_prepare *fdf)
 		take_fd(fdp->__fd);                            \
 	})
 
-/* Do not use directly. */
-#define __FD_ADD(_fdf, _fd_flags, _file_owned)            \
-	({                                                \
-		FD_PREPARE(_fdf, _fd_flags, _file_owned); \
-		s32 ret = _fdf.err;                       \
-		if (likely(!ret))                         \
-			ret = fd_publish(_fdf);           \
-		ret;                                      \
-	})
-
 /*
- * FD_ADD - Allocate and install an fd and file in one step.
+ * FD_ADD - allocate a descriptor, build the file and install it in one step.
  * @_fd_flags: flags for get_unused_fd_flags()
- * @_file_owned: struct file to take ownership of
+ * @_file_owned: struct file to take ownership of (can be an expression)
  *
- * Returns the allocated fd number, or negative error code on failure.
+ * The file expression is evaluated only after the descriptor is allocated, so
+ * a full table does not run its side effects. Drops the file and returns a
+ * negative errno on failure. Installs immediately: for anything more than a
+ * bare install-and-return (reporting the number, configuring the file,
+ * installing several descriptors) use fd_prepare()/fd_stage().
  */
-#define FD_ADD(_fd_flags, _file_owned) \
-	__FD_ADD(__UNIQUE_ID(fd_prepare), _fd_flags, _file_owned)
+#define FD_ADD(_fd_flags, _file_owned)					\
+({									\
+	int __fd = get_unused_fd_flags(_fd_flags);			\
+	if (likely(__fd >= 0)) {					\
+		struct file *__file = (_file_owned);			\
+		if (unlikely(IS_ERR_OR_NULL(__file))) {			\
+			put_unused_fd(__fd);				\
+			__fd = __file ? PTR_ERR(__file) : -ENOMEM;	\
+		} else {						\
+			fd_install(__fd, __file);			\
+		}							\
+	}								\
+	__fd;								\
+})
 
 #endif /* __LINUX_FILE_H */

-- 
2.53.0


