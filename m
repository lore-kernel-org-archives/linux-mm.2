Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1D92CF532C0
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 23:59:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A5D596B00B1; Mon, 23 Mar 2026 19:59:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A33A86B00B3; Mon, 23 Mar 2026 19:59:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9491B6B00B4; Mon, 23 Mar 2026 19:59:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7706F6B00B1
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 19:59:07 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 34781160CF2
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 23:59:07 +0000 (UTC)
X-FDA: 84578996334.19.79A5424
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	by imf18.hostedemail.com (Postfix) with ESMTP id 5DFC21C000F
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 23:59:05 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=PgzFxwB7;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf18.hostedemail.com: domain of 3x9PBaQgKCMot2q91qs0w44w1u.s421y3AD-220Bqs0.47w@flex--dmatlack.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=3x9PBaQgKCMot2q91qs0w44w1u.s421y3AD-220Bqs0.47w@flex--dmatlack.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774310345; a=rsa-sha256;
	cv=none;
	b=AScKrYNfIfw9AAWUZVF0WUkTrhvz0pDDNsA3lqjxXHmWRQH48UGGl06osVvN1BFmgjllZJ
	8mZ0n3H+3P0mlPP9bQwA1q+i2I522YE9yOKGU6QmdaQ5IWxmLcOBcwS8R88Jt1IseEmfmc
	4U9whTUI/V+DHXFTd1NFdW5gLj1HTXM=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=PgzFxwB7;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf18.hostedemail.com: domain of 3x9PBaQgKCMot2q91qs0w44w1u.s421y3AD-220Bqs0.47w@flex--dmatlack.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=3x9PBaQgKCMot2q91qs0w44w1u.s421y3AD-220Bqs0.47w@flex--dmatlack.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774310345;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=d5dX1H4XkIVUdogReT0P+xEIybXWqypp015VM5/RpRc=;
	b=Fx7Z7DS+bpBEQaN/LZoRW6mrxiWmbTddR5NVAQSm1qqJPrxA52oZ4paGZWf+wD1CvWTbSJ
	xvHYSzfqgyMqcabZV9Y1FkF7uWAWrNuA9ZPciO40qHpyvsPB738U23rNLt1nKtgTXZehNA
	YU7tly7Cq4zErUvDPe82ieNcLcBKuL4=
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2b0601ff3d9so12987695ad.2
        for <linux-mm@kvack.org>; Mon, 23 Mar 2026 16:59:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774310344; x=1774915144; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=d5dX1H4XkIVUdogReT0P+xEIybXWqypp015VM5/RpRc=;
        b=PgzFxwB7ippZMKD5hmc7Pf7TG9MQBB9NqCnM0FnwX5lzloRSn7k17gpvOkasVYpPZY
         em+dNdeG/53jv3tqd6kIwp2QDascaFtn4SJHl/G3TEwbmsF9hHfPd0S/inid5pJC0Zoa
         V1e0cSpXlezqg3N6U5W4vr50BT95tVAy1xbUO0n9GDHfJMnMttAwizZIrGTQ5NXTpMrR
         mqm9Nx5PQIxX1GVEQF2qQQBhlP8fZVUR1QsDEfSLfPsW1rCCicF/+mzm1BJSCvXuYu6i
         tW1rqweF1eDO1LwVJOnQRWYWCobEeJu1b0QDAHjl2WNLY1XZoeWgCHW77CWWPYm/2eT6
         4phQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774310344; x=1774915144;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=d5dX1H4XkIVUdogReT0P+xEIybXWqypp015VM5/RpRc=;
        b=sHoRW59P6jY9S+UanVwAojfyvEmL54Mk8/upE9TcH0wpBeayR5OY6up6y8b3mW5P/W
         doLRMou9g/S+w0npYJ7cEp7f0uu+G0hualvhgbsmoDPERYMq48jvMMg+UxRyVDz4AOum
         QDfzrVmM7O/MZ0DuCrSDAZgZqiTBhwTtzp9uPtsVDzU2suPqK42czfg+kYDhqdqzYEQE
         JVqINPEd2oFT87LvSxwqHNIeNw4QQzNgFt5tTeZ90U9veUSK+VzCKkZDAHrK4CkgQ5ux
         vXJ6gpsLCJ/GwPSUlY1m6WOHlmskpBD3FoBZc8luRNyGSMryXhf6MeDcseiEAKmgmMOD
         g+eg==
X-Forwarded-Encrypted: i=1; AJvYcCUusMS3eWqxTWFvsiytE82rCGse/rUc7mKQS7K6voKpVGMoqTgPIMELwki3SKq89W9r9mMOPnHHmQ==@kvack.org
X-Gm-Message-State: AOJu0YyHkzndYssGRp94gSyAZS7nNkXI7Lkl0LKheXsvIsQt1GtMGdSq
	UJaBlv/esilWRMkIWifeMQwSRNldlZP4q5m6bTAhKvu5dvV4sVQ2MnafOwdH4U7ig/H9is1ohIm
	4qoOa4cRk9bmKnQ==
X-Received: from plpn15.prod.google.com ([2002:a17:902:968f:b0:2ae:c5aa:fcd7])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:903:124f:b0:2b0:54dc:62c with SMTP id d9443c01a7336-2b0827c9a7cmr151447295ad.48.1774310343811;
 Mon, 23 Mar 2026 16:59:03 -0700 (PDT)
Date: Mon, 23 Mar 2026 23:58:07 +0000
In-Reply-To: <20260323235817.1960573-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20260323235817.1960573-1-dmatlack@google.com>
X-Mailer: git-send-email 2.53.0.983.g0bb29b3bc5-goog
Message-ID: <20260323235817.1960573-16-dmatlack@google.com>
Subject: [PATCH v3 15/24] selftests/liveupdate: Add helpers to
 preserve/retrieve FDs
From: David Matlack <dmatlack@google.com>
To: Alex Williamson <alex@shazbot.org>, Bjorn Helgaas <bhelgaas@google.com>
Cc: Adithya Jayachandran <ajayachandra@nvidia.com>, Alexander Graf <graf@amazon.com>, 
	Alex Mastro <amastro@fb.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Ankit Agrawal <ankita@nvidia.com>, Arnd Bergmann <arnd@arndb.de>, Askar Safin <safinaskar@gmail.com>, 
	"Borislav Petkov (AMD)" <bp@alien8.de>, Chris Li <chrisl@kernel.org>, Dapeng Mi <dapeng1.mi@linux.intel.com>, 
	David Matlack <dmatlack@google.com>, David Rientjes <rientjes@google.com>, 
	Feng Tang <feng.tang@linux.alibaba.com>, Jacob Pan <jacob.pan@linux.microsoft.com>, 
	Jason Gunthorpe <jgg@nvidia.com>, Jason Gunthorpe <jgg@ziepe.ca>, Jonathan Corbet <corbet@lwn.net>, 
	Josh Hilke <jrhilke@google.com>, Kees Cook <kees@kernel.org>, Kevin Tian <kevin.tian@intel.com>, 
	kexec@lists.infradead.org, kvm@vger.kernel.org, 
	Leon Romanovsky <leon@kernel.org>, Leon Romanovsky <leonro@nvidia.com>, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-mm@kvack.org, linux-pci@vger.kernel.org, 
	Li RongQing <lirongqing@baidu.com>, Lukas Wunner <lukas@wunner.de>, Marco Elver <elver@google.com>, 
	"=?UTF-8?q?Micha=C5=82=20Winiarski?=" <michal.winiarski@intel.com>, Mike Rapoport <rppt@kernel.org>, 
	Parav Pandit <parav@nvidia.com>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	"Paul E. McKenney" <paulmck@kernel.org>, Pawan Gupta <pawan.kumar.gupta@linux.intel.com>, 
	"Peter Zijlstra (Intel)" <peterz@infradead.org>, Pranjal Shrivastava <praan@google.com>, 
	Pratyush Yadav <pratyush@kernel.org>, Raghavendra Rao Ananta <rananta@google.com>, 
	Randy Dunlap <rdunlap@infradead.org>, Rodrigo Vivi <rodrigo.vivi@intel.com>, 
	Saeed Mahameed <saeedm@nvidia.com>, Samiullah Khawaja <skhawaja@google.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, Vipin Sharma <vipinsh@google.com>, 
	Vivek Kasireddy <vivek.kasireddy@intel.com>, William Tu <witu@nvidia.com>, Yi Liu <yi.l.liu@intel.com>, 
	Zhu Yanjun <yanjun.zhu@linux.dev>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: q6p8kj1d87kxc49orhg8wfg7d63dmwwf
X-Rspamd-Queue-Id: 5DFC21C000F
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1774310345-934297
X-HE-Meta: U2FsdGVkX1/2VzNR45LgbdAFpjvLLe406JjpZDnQU8sZMeO1PlT4xi080njGOXBZE6VtdUPMnJp6a9rcal5VaYceNPSk+28xHC+SZnVJSsh6RLQPtVGcpWm8Wwy9q2/R2fS3YB7+OpKyHqQMJ5WXP4NdTluocH3FB/OGwNFJ+vPOe+JbQdseYkbWcWvcOGaDrkequHdKhgcI4/n6OjpG8IZb2ViIIuQfjkXDaYD4gBGrWeeUPzebDFgvQS9a4qLSuJyFWDniOn3YYffTVQogaXme6hv68dq0PtGDVbIYRqLhNqFUzDAgQlpMyF66V1HeMo72Uku25NVvntLEB5gDxkf27pYVYdj2gZrJCtoxr7iVkVkv3y+L7HQEwetdORCzQpbwoNhXJ+5EOzhcZJY+d+dkc+rjXg8N3OBt5CLc+wEdsxhxGhK0k7l/WRbVL0SGnjWtkvyGO6oJj+O4C9Rc6kn5gEm9cWXiSYPyLdQjMA0U8tqG5lvd2RmloEMar26pPdPK9qaJlkIR13bkWOR2zZGqqml1fWfKtUQyksJgql1OEyK8XYzGp4Zi1RjSO4iVviqB9lkNOoIA2CqHRwAWAV98Q5xc1s9xMUUffc+vxUwmdoDnAeI9Ly7cgjr6kq0y5FC7trvrhMGUYHpUaV6J1E271jDdV9DI4+o7Hs8Do1u8QrufxypKql3YRcCNGwupBsmjhHfSsgUgpmo+p6eG9LCSsZgdglDwrevPx89AbBx97//fygCc2iuK82RYTplJJ7rs7TW/S6tPyEoIH3BEcJMVXF4BrZxacUk6LwGNImujaMMyJW/C1ypvKL5y3g75M8rVx1130TjKtT+5j0rxsoBmsklLSE+mDzCCBSe7UTGJ7OYcYHmdGNx7e5Hz7O81mW3rTHc5bBLX63Y4IVCC2cymRuDw7JDIGsG19ZJ8AEL29SlZCEBXqCVxHJ/1v0dGLIo8kWeyH/j6P3d/T60
 9oPXbRSB
 1MDwtItJFHMUI9n2NdYAIkurCzoXJZTQrqBKc/L3FIvqV7ZyKy6FLx+yXhZ8xHczFAxK0+ef4LCfjE8AaWBXzA+YjOMdoDhcK7/kJRpHH5maDnM/jIAdoaKqLOD3VUYWHAhRQ9WdP3DvuAavGi7eU46QU97I1nnUTTMQKYUBm7qIyczJ5XG6bgNAw59Bb1gW4Td39RikGK/QP3bzHQZfdObVjAMblyGSAtzIR1GwJKPSBr7HkM+oJGgiU70BZGcSM7nauPRr87UPGEZgiPkiXTFExJZpcwrLVPDtEUeHtjXrvQQ2LJk2qryn2r7X9mSiR4cmMxdZ9CrTJGjrby01grLZoyUhEe6ePXbn5stP7ZXyQ7I5smlhLYG6B7ibs1OHP/yRbOJjWXzVryOYg0VpFZLmCScd1D7aDjeFl9AbD7ixM0tTVc8PDYyZm6dEBQVl/a3oCf3XUPYZIWdarLCfo5jeJ/wRybsJA7JyrBVRGxcZMyWgyB9FG3qRlaTEYA+oyeNZrkjlAU4O/X5t5QKdEVK4SW36IYY8jqLZPXZpl2WGCJ41BbpjgA7Ap8A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Vipin Sharma <vipinsh@google.com>

Add helper functions to preserve and retrieve file descriptors from an
LUO session. These will be used be used in subsequent commits to
preserve FDs other than memfd.

No functional change intended.

Signed-off-by: Vipin Sharma <vipinsh@google.com>
Co-developed-by: David Matlack <dmatlack@google.com>
Signed-off-by: David Matlack <dmatlack@google.com>
---
 .../liveupdate/lib/include/libliveupdate.h    |  3 ++
 .../selftests/liveupdate/lib/liveupdate.c     | 41 +++++++++++++++----
 2 files changed, 35 insertions(+), 9 deletions(-)

diff --git a/tools/testing/selftests/liveupdate/lib/include/libliveupdate.h b/tools/testing/selftests/liveupdate/lib/include/libliveupdate.h
index 4390a2737930..2b04b3256382 100644
--- a/tools/testing/selftests/liveupdate/lib/include/libliveupdate.h
+++ b/tools/testing/selftests/liveupdate/lib/include/libliveupdate.h
@@ -26,6 +26,9 @@ int luo_create_session(int luo_fd, const char *name);
 int luo_retrieve_session(int luo_fd, const char *name);
 int luo_session_finish(int session_fd);
 
+int luo_session_preserve_fd(int session_fd, int fd, __u64 token);
+int luo_session_retrieve_fd(int session_fd, __u64 token);
+
 int create_and_preserve_memfd(int session_fd, int token, const char *data);
 int restore_and_verify_memfd(int session_fd, int token, const char *expected_data);
 
diff --git a/tools/testing/selftests/liveupdate/lib/liveupdate.c b/tools/testing/selftests/liveupdate/lib/liveupdate.c
index 60121873f685..3e070975a3ec 100644
--- a/tools/testing/selftests/liveupdate/lib/liveupdate.c
+++ b/tools/testing/selftests/liveupdate/lib/liveupdate.c
@@ -54,9 +54,35 @@ int luo_retrieve_session(int luo_fd, const char *name)
 	return arg.fd;
 }
 
+int luo_session_preserve_fd(int session_fd, int fd, __u64 token)
+{
+	struct liveupdate_session_preserve_fd arg = {
+		.size = sizeof(arg),
+		.fd = fd,
+		.token = token,
+	};
+
+	if (ioctl(session_fd, LIVEUPDATE_SESSION_PRESERVE_FD, &arg))
+		return -errno;
+
+	return 0;
+}
+
+int luo_session_retrieve_fd(int session_fd, __u64 token)
+{
+	struct liveupdate_session_retrieve_fd arg = {
+		.size = sizeof(arg),
+		.token = token,
+	};
+
+	if (ioctl(session_fd, LIVEUPDATE_SESSION_RETRIEVE_FD, &arg))
+		return -errno;
+
+	return arg.fd;
+}
+
 int create_and_preserve_memfd(int session_fd, int token, const char *data)
 {
-	struct liveupdate_session_preserve_fd arg = { .size = sizeof(arg) };
 	long page_size = sysconf(_SC_PAGE_SIZE);
 	void *map = MAP_FAILED;
 	int mfd = -1, ret = -1;
@@ -75,9 +101,8 @@ int create_and_preserve_memfd(int session_fd, int token, const char *data)
 	snprintf(map, page_size, "%s", data);
 	munmap(map, page_size);
 
-	arg.fd = mfd;
-	arg.token = token;
-	if (ioctl(session_fd, LIVEUPDATE_SESSION_PRESERVE_FD, &arg) < 0)
+	ret = luo_session_preserve_fd(session_fd, mfd, token);
+	if (ret)
 		goto out;
 
 	ret = 0;
@@ -92,15 +117,13 @@ int create_and_preserve_memfd(int session_fd, int token, const char *data)
 int restore_and_verify_memfd(int session_fd, int token,
 			     const char *expected_data)
 {
-	struct liveupdate_session_retrieve_fd arg = { .size = sizeof(arg) };
 	long page_size = sysconf(_SC_PAGE_SIZE);
 	void *map = MAP_FAILED;
 	int mfd = -1, ret = -1;
 
-	arg.token = token;
-	if (ioctl(session_fd, LIVEUPDATE_SESSION_RETRIEVE_FD, &arg) < 0)
-		return -errno;
-	mfd = arg.fd;
+	mfd = luo_session_retrieve_fd(session_fd, token);
+	if (mfd < 0)
+		return mfd;
 
 	map = mmap(NULL, page_size, PROT_READ, MAP_SHARED, mfd, 0);
 	if (map == MAP_FAILED)
-- 
2.53.0.983.g0bb29b3bc5-goog


