Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2F87F606DA38
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 09:17:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BW8cSBu5
Received: by kanga.kvack.org (Postfix)
	id 57E5A6B05C4; Tue, 10 Nov 2026 04:17:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 555B66B05C5; Tue, 10 Nov 2026 04:17:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 46B3F6B05C6; Tue, 10 Nov 2026 04:17:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 27C2C6B05C4
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 04:17:09 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 97408A83F2
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 09:17:08 +0000 (UTC)
X-FDA: 85418655336.13.85114DE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id CF8542000C
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 09:17:06 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BW8cSBu5;
	spf=pass (imf31.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794302226;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZmsVWE65gHf0tYCZOotZ2fbgGfTg77o991kqs+Fgm8I=;
	b=qSVQTjiAMC0ZVW3l/JN+OVznhPMgs7qo83IjjwrYHlTaB43sy/oYwyvDszvt32tlIFy11p
	fA/HTwu7MY4tXwjJ9uTdgzKAi5/7iWnubsSTvhlFBIneaRVd2Dg6zXwjPqmrRVx2qS2H9m
	3BS7LqR+Kegzjfsqcujz8hrLjjuSS2k=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794302226;
	b=KRSLgDA2FlsnM5g/FoO5VWPJ1F+actnJizni+64tGDepxKJPFh8QvFn4yF1cVB82xJr4Ak
	tA22eWQW3WDP34yzAHVkUZIJ4JQLofwmMW2KKQ2HUvBt5cNe3c5YUlmowkqqFcvyNAWTNf
	sxLGBfskMTvjGZnP4s2D9ZQ0nuPgFh4=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BW8cSBu5;
	spf=pass (imf31.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5851463803;
	Tue, 10 Nov 2026 09:17:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 977E81F008A3;
	Tue, 10 Nov 2026 09:16:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794302226;
	bh=ZmsVWE65gHf0tYCZOotZ2fbgGfTg77o991kqs+Fgm8I=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=BW8cSBu5u5r410tEcT+zMEpXHphJlFpdpAvRKAvEiKkqyi0xID6vk2b0Tbjr4F3K7
	 awaBsefdY+MBphndwr9KbPvoSGcCvsFqAgttwi2fLxH3+R18Qt4275it2lfQHkFKW3
	 UWJSti38mAmdmLS3tX3vRlC5H3kzbz/lg2YywjKPfSIrMY163nLZvxRzgh12Gfu740
	 fCVYcWuwLy19s6iKyC6ZAEcLuBFbK0G08kyGDUPlYe/7HLPPSEk9rvbQ36ZpaFxa7H
	 vhskSHci2E1kOmUw3DCi+DzAu6HlXgBa1yUahbo2TZ2iHpM1c2csxa56tO5nlkWHht
	 owe5/3f9zcJNw==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 10 Nov 2026 10:14:26 +0100
Subject: [PATCH RFC 10/41] nullfs: use fc_init_pseudo()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261110-work-loop-pseudo-v1-10-4c998976c6c7@kernel.org>
References: <20261110-work-loop-pseudo-v1-0-4c998976c6c7@kernel.org>
In-Reply-To: <20261110-work-loop-pseudo-v1-0-4c998976c6c7@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Jann Horn <jannh@google.com>, Chris Mason <mason@kernel.org>, 
 Josef Bacik <josef@toxicpanda.com>, Christoph Hellwig <hch@lst.de>, 
 linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-nvme@lists.infradead.org, Alexander Viro <viro@zeniv.linux.org.uk>, 
 Jan Kara <jack@suse.cz>, linux-scsi@vger.kernel.org, 
 target-devel@vger.kernel.org, driver-core@lists.linux.dev, 
 linux-mm@kvack.org, bpf@vger.kernel.org, 
 linux-security-module@vger.kernel.org, selinux@vger.kernel.org, 
 apparmor@lists.ubuntu.com, linux-nfs@vger.kernel.org, 
 netdev@vger.kernel.org, fuse-devel@lists.linux.dev, 
 linux-efi@vger.kernel.org, xen-devel@lists.xenproject.org, 
 ocfs2-devel@lists.linux.dev, linux-s390@vger.kernel.org, 
 linuxppc-dev@lists.ozlabs.org, linux-usb@vger.kernel.org, 
 Amir Goldstein <amir73il@gmail.com>, linux-erofs@lists.ozlabs.org, 
 linux-kselftest@vger.kernel.org, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=901; i=brauner@kernel.org;
 h=from:subject:message-id; bh=sE5h4xDpaVEC2u2QAThbBNjL9uzfl1yRVOrJAX0MUt4=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWR9ejD//EYdt1/rJsiFfvkoZ/8qOqx4q8M6HwH1m6/ZZ
 AI224nydZSyMIhxMciKKbI4tJuEyy3nqdhslKkBM4eVCWQIAxenAEykdCnDPxurz9VH1LyPmPhq
 vwyuY532xsvTcZ32qt+q1sFHglVuuzD8D18Z213yU2Sl5aU3uX8PWyTKlr/7O0218syUZaL+TwX
 WcgEA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Stat-Signature: 7i8tjuznggiq6fsf9jbifih496hyawoh
X-Rspamd-Queue-Id: CF8542000C
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794302226-996954
X-HE-Meta: U2FsdGVkX190plPKFDDEDMrr5pGQ/QMtZALNorDadL8t5tsi8jFDxLqDnoUV+wzFEojdGQFnQ+S33h5+cflNjsdl6tVsJ2rCg0oBqywJmixcStBXr5cFPPeUfp3MSR1Y7PGFMDzOvW1qy3PRRsp8wcTtmJaD6ALF6odRA07xNMUsU2ucSznvnhTrYGGSHmcQPe9rpeOAyIKvRuYP1TEUOTKtDIOKs/RmU/QTYCnaer4Ox0wp3RikLwix4APVjYO8eqfEBjSMG32Bdx02w5/J4M3Kvda419bvkwEmGz4DjVI8xOfyVuc0IMfkTsiOTt912nehgSaKA0OCiuvFTk7k/6dj+5JDavQcmI6TY/jp1oUfHXjxHf4AR1mAwxUpDD6c6X/S2xq8q2Z3n1veV4fsYxKwMH+DRrJ5enauQJ4GWpQ0G+j+1xJaW1PsE9wts/iNBB3mxmS57hnZ28vIrwfM0QqHycMCKR7XR2pxoKwB7WU5yVHAmg/BEBn/OwNo2F2fwGcXRFvvb9LghAnRuzxqbQRGH3Kge12Eb4jzlWW0Eswp1WPFlr612T9TWWbFisztT6++JPs373o6ckCtxFBYggT7HRazfEqr4utSsVM8aIFt63jPRkl0rNW7mttpP2QDeF9YJ/0WWNA/j8lALG+UQtBQXcEjhFNT3cseEhhh2gobW70MxorBRLGjJcZyHu60HAuUeHXNEWrQAH3FXJQCSXq1OrjMIzojNFP9qprDnXRXMB9R1ypSK9Entm+RxuOHPZxk94whotZcHEkqRx98EaKrd1TXX7uekbrcMaqHTIfCAqbwIKNiHs8stJFTGrixUvxc21ccO+fQ6myhAYX7NPBwbNh9xlp/2u/VrFURBNaCOJfxKKa6L4gKnV7tFgSK8yFS2o8735MW+Jyf3bTwwKpz1QI8fDuWMAvws38mURtjR2taNptCGNxJT+09Q97Lh77zOhLVH9Itj3I9HR3
 cxVHojW7
 TJKalCdHvxWi1FsIAApvZ4vyQULy0RB+0FzrY8yO7QXXTDgkoPK9UulOqr5JZXJRr8nevX12ikG5RW5jknVHzKHTxmjvy5/2F7ieSiLQ20nn3ENjS9Qhy0F6TYgA7kpezrzBMrNvbD+qNFFrZoro4nxjILQXQmsr64NX1fRM1lMvffS8l9s2AFcvQtocl9aRkF5YGQsLB3oLJrvuRUzQyf9Xvg6LQ2XGPA6Ph1Kw5mukh4cYY2ibh87JdaNsObZ95vA5HA3VpPDammDMI+tGF/1zPgUj33bIhkLoKsJUmRO2STIwxEqM/T8527Mj5sVB9JRAGLnPp5Bkd81M=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Initialize nullfs as a pseudo filesystem instead of raising
SB_I_NOEXEC and SB_I_NODEV by hand. This adds SB_I_PSEUDO.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/nullfs.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/nullfs.c b/fs/nullfs.c
index 319c2f5c5a67..2fe24cb97160 100644
--- a/fs/nullfs.c
+++ b/fs/nullfs.c
@@ -2,6 +2,7 @@
 /* Copyright (c) 2026 Christian Brauner <brauner@kernel.org> */
 #include <linux/fs/super_types.h>
 #include <linux/fs_context.h>
+#include <linux/pseudo_fs.h>
 #include <linux/magic.h>
 #include <linux/splice.h>
 #include <linux/uio.h>
@@ -174,7 +175,7 @@ static int nullfs_init_fs_context(struct fs_context *fc)
 {
 	fc->ops		= &nullfs_fs_context_ops;
 	fc->sb_flags	|= SB_NOUSER;
-	fc->s_iflags	|= SB_I_NOEXEC | SB_I_NODEV;
+	fc_init_pseudo(fc);
 	return 0;
 }
 

-- 
2.53.0


