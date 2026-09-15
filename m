Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 21C58C88E7B
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 11:35:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4722E6B00C3; Tue, 15 Sep 2026 07:35:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4493E6B00C4; Tue, 15 Sep 2026 07:35:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3862D6B00C5; Tue, 15 Sep 2026 07:35:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 178386B00C3
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 07:35:38 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 89EE4C03B4
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 11:35:37 +0000 (UTC)
X-FDA: 85215791514.19.271D278
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id AFE46140008
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 11:35:35 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QShSpSCR;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789472135;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4cyWZY3NqovxpRDY6IE9b0iFSwFNHI0DbK45a85UipQ=;
	b=Izlop0kgGZ8gNJ60g2+VCJENC+T2H6N358syPRWlg4ZcUst4vr+VpCky/yg2ejbLayC5Aa
	OsAD46l16sLuF+ddHAqYf7wJW5mAQYxk1ldbrq0DBsklQ1Ho4DzK76bYNhcb8mg5yRVgLE
	vnnWRcyi6oIeqcI+E2/BJ72KH/jRDkM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789472135;
	b=Vz+oOURVahucV+lmNyjf1Kbt7UxhU8AURhzFptR5HfaXTZ7G4DJnmf/TWL/Hewn3LPilSM
	d9G9hMnV6S367I0RKDxZ/K1OeP+DUOm531KFRVyS4EIofn43UnQoqN671G3xpoNt2zSZ03
	FlcnLxiQtO5Dt451GxDibWfPHuEheEY=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QShSpSCR;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 194BC41253;
	Tue, 15 Sep 2026 11:35:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 855EE1F000FF;
	Tue, 15 Sep 2026 11:35:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789472135;
	bh=4cyWZY3NqovxpRDY6IE9b0iFSwFNHI0DbK45a85UipQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=QShSpSCRD6Ol4MQvbWaGFCrC9D2hEvMMsqJVxbgperwaAzfDuHUwR651hhvjbuklD
	 V8TQMFUcMD9eSXSMuyAwgiWFzi0aqbkjT2ga+ukHQTd+ooSqbRR0w+8dklcQllx84s
	 J1vd1rrkg7W2xCcJFOtsGmjuUfysGb2g+4rZjFbqLWmyJ8Yf8Ww523QPYOM4gdlVYe
	 9qjw6VvRm1T5endGkraMKVYh3kIi8DvPoXM1B76VPl1ZetouR5ZWcWZs/UQmu4oEg/
	 QeIQWjAGAMnj1aiLn/FeAtI3+y0er7L+q8OA2u/+KtDir8seIk/RUJip7Wgf4oA2Ys
	 w5GYgWQdLMU4Q==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 15 Sep 2026 13:31:19 +0200
Subject: [PATCH RFC POC 33/50] io_uring/zcrx: install the exported
 descriptor when the request returns
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260915-work-fd-reserve-unify-folded-v1-33-4d5217d6b246@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1536; i=brauner@kernel.org;
 h=from:subject:message-id; bh=g4cMNX/82jJQalDLSwX1Nity2yqjS0J0NiJHAB23CT0=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWSt1Kk73H60xLL/uL9c1Ubz66I7n/6tuiXcUVn6/cZhl
 7opP+8pdJSyMIhxMciKKbI4tJuEyy3nqdhslKkBM4eVCWQIAxenAExk/weG/3mbVB0z75nsf+2g
 kJwuHDdbwrosi1P7+cq1bOytTdFl1gz/Y3eZWfw1evMxy/980nMezqvh6nqrq+2qsnZHrDSbM9O
 WEQA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: AFE46140008
X-Stat-Signature: 5hmcf9f3s8p4hztddsueybhysra4j7q8
X-HE-Tag: 1789472135-518953
X-HE-Meta: U2FsdGVkX1+byOajKD7TT5OIEWNkxSx3Xie4UrYi0P0dpIZBpzC2DS3ei4kV1nYBti7NXDTqhoHf1a6msNCyAnM5jqzC+fpz2hrngPa/OVBKkHFBPgVrCBSEtw67GoiwQY4SpVoCsXL+WEuKCsDpuQ7S/cRSwwXH3GQSuPV+vDG7WaNCZyC7XGL6GlJMOgH2i8cKsNoZM/N1wCGLXAT5n+oWtyh2aE+6aiBzqNzGzRvsPFnKWL2jqkFQHYGlZcgxEp9cb8mgsytjmFEEU31yrxzCeHbN+5/SvgjomMYCq3RfP8V6GPEEnkwidoh2Bop16Zya1pgLnS5knD+mrWIpWgunMQWsJRSv7nz8GNfZgMeXpYtgmy0hLAo9u+qQifSKkrKfGj/IzPi7eGmHyD3ugtyoL4lxaOECsPFHgz6poz/nKNF+9yWWvXs56CJGNTt8ezSwy9sRKhnAKpb+2KbsfhThwCPYOf550DLRvt/mrPZ3UMKJci0RErBuiK1nAhphxsHP3SNrvse5K2psSyXfNWVAk4W+U8BsOFWGNGhgFjMWKRQDV7gOP9zcBgGPTNw//aOomfxnVTVIuBIQohowT5FzSufL8hlLCOQxrYDeldtcT5xe4aHU74F1/c8sPEYsLpAlTSLGvfHZXJW6JUGCvTgar1u3i0dsj4qG5pcakP5sE0Vq9306ZFvckzDGpYru8ObBTJkJk0OcY9kcE7PKPNVlU/JAxopdLRgKRoOqd+TmVxqJw4N99pPSoSQUgtqRScLUlm09xpIQ/FyJmyDUX6Emzve52OJ9AUYTQrQdY/IjelFEQT/8sjsweBhtOwSFQnXufPfMkV239sBo70RJkicH+GrWch61ESDlUB2YIESBOb71ZIJ0ezPMQs90bxw4R8UbO+U6f/5YcVT/FCji1jTS5QAImU6tEkPG0ydhGQskpsOrDEojZWjMag+S3onIoLIhQ4jAR1Gl29alSB6
 ZW+bw5gs
 xNHJa7ksQ+KYLkjHWHFoMvZismkM2KrLEjqsmicbgNv2zHROSlU330zes5VS4Hx3D01JD0O7BZ8j+1HyPuxQ/HenJWhVquwzFv+ch3q09e/2sC+bhGdn6fjDryPmrQaZdFMAL809ojZ2+iSbmHNHXbV/ASYGs1G+roTh21QtPe3jb26utOGXcUu5jO7Dw71Hike7KMI6dT0mCLFfWT0dU6OCjC2ijWQQtYwsVBSC9xbS21s+MKlO46OORdnTwkkRU94TqxLvZaA0vehezEKwtJrzvK1LdNV7M4fDY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Rely on the fd exit path machinery.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 io_uring/zcrx.c | 25 +++++++------------------
 1 file changed, 7 insertions(+), 18 deletions(-)

diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index 1b3b11405dac..d458c614c765 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -795,8 +795,6 @@ static int zcrx_export(struct io_ring_ctx *ctx, struct io_zcrx_ifq *ifq,
 		       struct zcrx_ctrl *ctrl, void __user *arg)
 {
 	struct zcrx_ctrl_export *ce = &ctrl->zc_export;
-	struct file *file;
-	int fd;
 
 	if (!mem_is_zero(ce, sizeof(*ce)))
 		return -EINVAL;
@@ -804,27 +802,18 @@ static int zcrx_export(struct io_ring_ctx *ctx, struct io_zcrx_ifq *ifq,
 	refcount_inc(&ifq->refs);
 	refcount_inc(&ifq->user_refs);
 
-	file = anon_inode_create_getfile("[zcrx]", &zcrx_box_fops,
-					 ifq, O_CLOEXEC, NULL);
-	if (IS_ERR(file)) {
+	FD_PREPARE(fdf, O_CLOEXEC,
+		   anon_inode_create_getfile("[zcrx]", &zcrx_box_fops, ifq,
+					     O_CLOEXEC, NULL));
+	if (IS_ERR(fdf)) {
 		zcrx_unregister(ifq, NULL);
-		return PTR_ERR(file);
-	}
-
-	fd = get_unused_fd_flags(O_CLOEXEC);
-	if (fd < 0) {
-		fput(file);
-		return fd;
+		return PTR_ERR(fdf);
 	}
 
-	ce->zcrx_fd = fd;
-	if (copy_to_user(arg, ctrl, sizeof(*ctrl))) {
-		fput(file);
-		put_unused_fd(fd);
+	ce->zcrx_fd = fd_prepare_fd(fdf);
+	if (copy_to_user(arg, ctrl, sizeof(*ctrl)))
 		return -EFAULT;
-	}
 
-	fd_install(fd, file);
 	return 0;
 }
 

-- 
2.53.0


