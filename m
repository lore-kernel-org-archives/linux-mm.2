Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 120E7FF885A
	for <linux-mm@archiver.kernel.org>; Mon,  4 May 2026 09:33:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1141A6B0092; Mon,  4 May 2026 05:33:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ECCEF6B0093; Mon,  4 May 2026 05:33:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D1F6E6B0096; Mon,  4 May 2026 05:33:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C1CD56B0092
	for <linux-mm@kvack.org>; Mon,  4 May 2026 05:33:39 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 89B5B1C0346
	for <linux-mm@kvack.org>; Mon,  4 May 2026 09:33:39 +0000 (UTC)
X-FDA: 84729224958.16.7218DF0
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf02.hostedemail.com (Postfix) with ESMTP id B5B8B80003
	for <linux-mm@kvack.org>; Mon,  4 May 2026 09:33:37 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=3gmgsHw5;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=9lPszCZn;
	spf=pass (imf02.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777887217;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=phMjACbbvuhJ46Y+Cb858pBZjegCvm4hvrrYxP3IpmE=;
	b=n/AWeiV2UttyITxnd7aKdz8CDWoxNYWyH4O8ywh6yV6vLq/D43ECS5dD0oM1a+M32aDjnE
	hobEAd9U+ExdpCxBbrC9/ZDD6J1jLPbIERa/kbniCR2vIAk3EbjNdeKkN1/R3ITcEf4LD+
	0rR74+RevAGqLzpxC0C26pGfDD3kAjg=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=3gmgsHw5;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=9lPszCZn;
	spf=pass (imf02.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777887217; a=rsa-sha256;
	cv=none;
	b=G7IwUy1Bj/4apOh3Xv/rshOKuqnxAG7CI+GGW3LhORr63tifFDLB3URwMKR6D+d2VfgC81
	dIgWOaZUfDk8cHSbEAzo2kqpKtM8mUmfUpRmeS/NuVdJrJFPRtohsZKdE/eHXfF0tYtnq2
	MBDXXtioljMsFODgw2NCskFBEo/nY/s=
From: =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1777887216;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=phMjACbbvuhJ46Y+Cb858pBZjegCvm4hvrrYxP3IpmE=;
	b=3gmgsHw5te80Dz/TZDbLGM3dFTERMqapPBJi/OXq2MSNASi9YNll/M+B5OTWWK62YV0UEu
	Eeaogq+Rxbz/jGTEZsfFPD3NIglGsy2FrE1flRqFlxTxaJgXCNKedyI0aegneiUvs+DURI
	o4gv590DTa2TNYCMso6RVAdXPCxhqKpPrJiTBEG/RpFF4sJAfTlHhEQNZDEWYZDW2/UG6i
	RRp+aey7vW1keVEQinPXv412qNAkCWtjC2mIn2P+7rOcV0Ho8shLQW1MqaDHjZPz9axJUu
	6q3wvVB8KW+sk5bnp0zn355b7G1Kxb9Oi0lP/A6ZjlXM4y1F4k3t9q0i2FWRQw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1777887216;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=phMjACbbvuhJ46Y+Cb858pBZjegCvm4hvrrYxP3IpmE=;
	b=9lPszCZn2QHEJUrwgxhj/VQdGyetnCTvE5dKW+y5m4uWQ9xMZJKk3F7DwsT388WsCS9kXv
	qKzeAJvoL9CdX+BQ==
Date: Mon, 04 May 2026 11:33:20 +0200
Subject: [PATCH v6 04/11] mount: add support for __free(kern_unmount)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260504-kunit-kselftests-v6-4-712d3d526d97@linutronix.de>
References: <20260504-kunit-kselftests-v6-0-712d3d526d97@linutronix.de>
In-Reply-To: <20260504-kunit-kselftests-v6-0-712d3d526d97@linutronix.de>
To: Nathan Chancellor <nathan@kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>, Willy Tarreau <w@1wt.eu>, 
 =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <linux@weissschuh.net>, 
 Brendan Higgins <brendan.higgins@linux.dev>, Shuah Khan <shuah@kernel.org>, 
 Jonathan Corbet <corbet@lwn.net>, Nicolas Schier <nicolas.schier@linux.dev>, 
 Kees Cook <kees@kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
 Christoph Hellwig <hch@lst.de>, Luis Chamberlain <mcgrof@kernel.org>, 
 David Gow <david@davidgow.net>, Rae Moar <raemoar63@gmail.com>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, kunit-dev@googlegroups.com, 
 linux-doc@vger.kernel.org, workflows@vger.kernel.org, linux-mm@kvack.org, 
 linux-fsdevel@vger.kernel.org, 
 =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>, 
 Christophe Leroy <chleroy@kernel.org>, Nicolas Schier <nsc@kernel.org>
X-Developer-Signature: v=1; a=ed25519-sha256; t=1777887211; l=942;
 i=thomas.weissschuh@linutronix.de; s=20240209; h=from:subject:message-id;
 bh=C3+WFuqmWwAWuvuhG3a2V6T0cnnllWx1wESAQzOgWr8=;
 b=v8qWN3CNL84w0W8dTXihmLZsAsWIE+x2wKIstna01FUjr0T/jkeNaar/aA60a1U9P56ywJEI4
 K6s10u66qsVD63S4sOtrFF++I7GIlzk8hZpWpMo88J4Is5p59tKF6VI
X-Developer-Key: i=thomas.weissschuh@linutronix.de; a=ed25519;
 pk=pfvxvpFUDJV2h2nY0FidLUml22uGLSjByFbM6aqQQws=
X-Stat-Signature: cmayxbf3ujmbhp5qfjnompcdpcff9y8d
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: B5B8B80003
X-Rspam-User: 
X-HE-Tag: 1777887217-396092
X-HE-Meta: U2FsdGVkX1/+sPS3QKiiSNpIX7ZtVIx16sK3mF8L7HnANvK7cGhBdgGTNJgi18lb4I9R+Pcb0uWIguctoD0XmLJ6t6Wq0jo2UnF4WtO3rsuKFggUTKsHus9fjWZLrJH7vLE0q3iZgmcOgyYJSsNIeOh2U4ltd/G388HKUQTGaquQq6l44ZyfFTWmzkdvBqauf1/TScGlPGgb/i6l08ywxPD7oVMzX1rA/OzXKCaoWW3cjGofmnL5NCVgMzYL5twAkjG0P+nWm7eK5J2aluE5b3V1AKC+W8w/e9UA//3Dk48jG8drIPrDxF6x+3sKKGAYltd9k20AcmX7DVkeb8RMQNh/2K+Ptvfjgk4aHT6H5LhwauExKXRg4xhocNowpB3jmfTv2bdoktJn7tAYud6UOEj4F+j+72rIndjfBGgmgTzRgGUohr0HcRmTgrane/m4tXPjFMHzNRomhQDuj5S6Cw3emcc9mxroDOc3fLwzNoK81RORHuajMIYRjDB1iKIAf6SXSOKhVvRHrp5jac29k9LiDPeGXEy/2hU2eYSfIBliV4AyhXCp35N9w5gzaRQIukKY7UwLeAHDQw/VpfpqI1QH1XfIfYq69vnODfB1DxaV3lZ0EWvwaL4i8YimL3KHwZI2AM+AUb7KRQNgRDKdZl2xap1tVzPUWc3v4mq/zy6jczfE5le4gWdLNLgyFxNDQZug7/UyqfHRbv64i7j7eU2w4zbBGQk693yolxwQYuKMXffYL6F+oK80/I9segyqBuKPgqOVqKLWmSLjFqHBUu4DHtHqeNacF3xxa1HNw5jzlwUVDXxDivZUeggfnUNTP/TcJNYKIPw5rRrBaATQ8Tpct2ywptQQUCYDgqc9fMRfK+JlWzRKW62tuOsm151HUyd2oV7mQc5CvIgrk6N0Db7jG/dp4utaMmeSOVXPhNqE+vWxOKImXrDhDfZp7+4yrCO8AU7WM7Tq47bB21V
 8djzuXN9
 ICOQIuMiP5yBP9m7RX6JLya1QihrdJRg5yzaKjNo8aPR8kk7e46Zo6MZV19CbcQug73haVxufLYhdVf6seWqWbdfnLXAdIdOmFQstaw2r0oDllv6zENky+Kf2Wk/kkFtKugp4p1y/vpkeWsX88yIUNzFDCuodSBAhGk5TKxOafP5asaYAxn6wauuPJ/wdxxVTxfYsTCVqIGYVlrenBw4KAYBd7metdusgM9UGCqxJN+Tyym5Ki/DVLfbgIwwH/htdde/bl72qDkRiyZkEdBCx5fvXC7xaNjhzZERS2rRU06QrE5HC40KZmbEgIcGlirD13O/hRcTBgotvXd12KUnq7row+M1TsH1bant9XeQ4IAQ5LPVujW6atE64oGVv+tyrBYRwvjRN8upirNlc5zqcLBLRfIMTddkn1j4wrZh1qErKRjsP0Q9nkzTEzNXT9SSzsVTp
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Allow usage of kern_unmount from the automatic __free cleanup logic.

Signed-off-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
---
 include/linux/mount.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/linux/mount.h b/include/linux/mount.h
index acfe7ef86a1b..d8689ce61a42 100644
--- a/include/linux/mount.h
+++ b/include/linux/mount.h
@@ -10,6 +10,7 @@
 #ifndef _LINUX_MOUNT_H
 #define _LINUX_MOUNT_H
 
+#include <linux/cleanup.h>
 #include <linux/types.h>
 #include <asm/barrier.h>
 
@@ -99,6 +100,7 @@ extern bool our_mnt(struct vfsmount *mnt);
 
 extern struct vfsmount *kern_mount(struct file_system_type *);
 extern void kern_unmount(struct vfsmount *mnt);
+DEFINE_FREE(kern_unmount, struct vfsmount *, if (_T) kern_unmount(_T));
 extern int may_umount_tree(struct vfsmount *);
 extern int may_umount(struct vfsmount *);
 int do_mount(const char *, const char __user *,

-- 
2.53.0


