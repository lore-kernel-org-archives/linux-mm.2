Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ADC74606B1EA
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 15:38:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=Nd3pUylb
Received: by kanga.kvack.org (Postfix)
	id 9289A6B065C; Mon,  2 Nov 2026 10:37:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8D87F6B065D; Mon,  2 Nov 2026 10:37:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A0856B065E; Mon,  2 Nov 2026 10:37:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4798E6B065C
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 10:37:31 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CE69816016C
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:37:30 +0000 (UTC)
X-FDA: 85390583460.23.5798FC3
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com [209.85.214.197])
	by imf29.hostedemail.com (Postfix) with ESMTP id 1D9FD120006
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:37:28 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=Nd3pUylb;
	spf=pass (imf29.hostedemail.com: domain of 3N67oagcKCJQJ6D6BG54CC492.0CA96BIL-AA8Jy08.CF4@flex--vipinsh.bounces.google.com designates 209.85.214.197 as permitted sender) smtp.mailfrom=3N67oagcKCJQJ6D6BG54CC492.0CA96BIL-AA8Jy08.CF4@flex--vipinsh.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793633849;
	b=c5IWw4o4JpCQaIhD4NU/bkytrNEv0YSNVubsNDEP2gRkDu2s7Vc2Umz42rtQEfIFkgkS+x
	aWzsIc9AAiyX16Wyfsw5rqyoKz3uR6CB88hStU3UcWpTJB38XBZoOX4XhpbwqumbiH75un
	GRUAGjfFjCjK62nVNcUp7zAqm+CpgQA=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=Nd3pUylb;
	spf=pass (imf29.hostedemail.com: domain of 3N67oagcKCJQJ6D6BG54CC492.0CA96BIL-AA8Jy08.CF4@flex--vipinsh.bounces.google.com designates 209.85.214.197 as permitted sender) smtp.mailfrom=3N67oagcKCJQJ6D6BG54CC492.0CA96BIL-AA8Jy08.CF4@flex--vipinsh.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793633849;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nvnsa/W44mPMiR0xmzXgygBXbMEl9kAu534qF23MUJo=;
	b=X4cKSXX1DCOS5bB1psLsLHQBIw6Zj7Rk6CksixjClrjZnQiOQAdnuPwHkkN5thb0e6+4/a
	vFXhDZ77uBIPVoEoEOMqvjn8JofrAlYawec61/d2zR+Txo+Pu9QjK9KT/rW7Lu/tkAmZo7
	+v6GPf3exPvFEmxFwoB4XWAC1UMfieI=
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-2e93f266d20so51218315ad.3
        for <linux-mm@kvack.org>; Mon, 02 Nov 2026 07:37:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793633848; x=1794238648; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=nvnsa/W44mPMiR0xmzXgygBXbMEl9kAu534qF23MUJo=;
        b=Nd3pUylbIPgroo7C3DV749vjbme/5Er7hC6ZTNCX6YpQbuqvhA2uOsuMckVGB4Xlit
         Hhi1n0Q1ls5oMgPl8oPkobQFWC2xmxi9XhegRxBbhxWrnXymTgIh7+D7ogTevfgRGCNK
         HSyI/lABlKz9H/FCf+hrR4CCRppoODbTTz5msg+NDuBKPXkKyJvIh7wxPo1JF4/ZEeWy
         Wf2VuA0GZbDCKzXs80fCyEcC80KsdIkogtBQaYPiruuV7E1HviMEEM8XgUcm5j19B2a1
         D/C1AclEOazQr+00D5nSE+36WmeNh7UnOqih1F9JbyW0LxpqOlRf421tt7s0IFh1OmwD
         FgRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793633848; x=1794238648;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=nvnsa/W44mPMiR0xmzXgygBXbMEl9kAu534qF23MUJo=;
        b=Ar+8NthChM/JlhrcgvbGp84AmvGMYvDwB4P2l1fYJ3vSuSe8Y98agwX3LiGOFqlrpN
         eCnktocoS0hC/Z08aJHdMVzInhXOILeU4akr4ZtyNUrLJ/qbiVt5TNa7u3jTmbhHeigM
         5kwOnGmA6LyRYZvj/XvhNVshrcEHzyeQdCuWecC5A7I6SLiJAeJM3hXZlEKSq+BBI+by
         iz8iAy333XiQ2X19W+dvpG/TFhGHIi+5PZllWK7Bi53rWAD7KY0Deo2pAz+WODGwDBAA
         B0SspsWwAjYdp5A08TgeGHvOxVQj2ILAXaJeKqpfTe8iRxj+tXzvbaus140N3BB94f+X
         4BGg==
X-Forwarded-Encrypted: i=1; AKwUvBxdQuq8l7zpzJ6IaWMi7ebAbBlG8BSF8+pXiHEtmsxpWgiPPx/jtIaBSt38UNl3vPrYAjnifwEwhg==@kvack.org
X-Gm-Message-State: APuU4Z+0roPYR598p81A0R2CeumXPpb4PL05BiXHsSsJeZS2wFtJl68m
	HUiV+uwbo446uO40n3xTUCvZf2qe+dk/BAz2Q0edUkz0uqv3fqDsHOUcfzwE+KotseelHqf/RTf
	xFmXLohWt2A==
X-Received: from plbkl7.prod.google.com ([2002:a17:903:747:b0:2e9:dea5:138])
 (user=vipinsh job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:db01:b0:2d9:599e:df95
 with SMTP id d9443c01a7336-2eb3640503dmr101937705ad.3.1793633847651; Mon, 02
 Nov 2026 07:37:27 -0800 (PST)
Date: Mon,  2 Nov 2026 07:36:55 -0800
In-Reply-To: <20261102153656.1431701-1-vipinsh@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261102153656.1431701-1-vipinsh@google.com>
X-Mailer: git-send-email 2.56.0.317.g454f8302e1-goog
Message-ID: <20261102153656.1431701-27-vipinsh@google.com>
Subject: [PATCH v6 26/27] vfio: selftests: Verify that opening VFIO device
 fails during Live Update
From: Vipin Sharma <vipinsh@google.com>
To: kexec@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, kvm@vger.kernel.org, linux-mm@kvack.org, 
	linux-kselftest@vger.kernel.org, linux-pci@vger.kernel.org
Cc: ajayachandra@nvidia.com, alex@shazbot.org, amastro@fb.com, 
	ankita@nvidia.com, apopple@nvidia.com, bhelgaas@google.com, chrisl@kernel.org, 
	christian.koenig@amd.com, corbet@lwn.net, dmatlack@google.com, 
	graf@amazon.com, jacob.pan@linux.microsoft.com, jgg@nvidia.com, jgg@ziepe.ca, 
	jrhilke@google.com, julianr@linux.ibm.com, kees@kernel.org, 
	kevin.tian@intel.com, leon@kernel.org, leonro@nvidia.com, lukas@wunner.de, 
	mattev@meta.com, michal.winiarski@intel.com, parav@nvidia.com, 
	pasha.tatashin@soleen.com, praan@google.com, pratyush@kernel.org, 
	rananta@google.com, rdunlap@infradead.org, rientjes@google.com, 
	rodrigo.vivi@intel.com, rppt@kernel.org, saeedm@nvidia.com, 
	schnelle@linux.ibm.com, skhan@linuxfoundation.org, skhawaja@google.com, 
	vipinsh@google.com, vivek.kasireddy@intel.com, witu@nvidia.com, 
	yanjun.zhu@linux.dev, yi.l.liu@intel.com
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Queue-Id: 1D9FD120006
X-Stat-Signature: rh3ugobdmpwwf4oy1pe1xccgynkqw7wg
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=unavailable
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793633848-80910
X-HE-Meta: U2FsdGVkX1/y0RJFX0xViZZyKjIRpqBHfRjCI0BRCziJql2i7IisdCCDJKHAbS6YROA+dDdVWVg3/NHeSRtu2wjt7gFcz8HBXRWqaiiOv0ecBUWla9OYKyWu3abJHHzPzrEti0scsBB6891B2Dwn/T/MvRnJgVd09C9k1vkUWadJkhAeFXX8BfNVTw0qpIuEgUKbOXMRpDQ3Ltuqa9uzGPWX4y1ctgdjVmspliSyWfXhRQy3vfr1SlnzhTyGjKcXpKI14t4sYrViHgPQgOdfbJfbzKnT1/vaeeaBWQovG659vSWxHWfk8mJtZABFOV2RtBO8Q28t7bPFUUCDXdAS1YDQME+vFAoRN6bhZb75uQ6QxgZeG/sYzSh9jQmfZXIh6FSz2WARtVJ1fcjTSz65t5BSiOhDjjoH03H3+0iXjsHisThEgm24RuF8tVUFVEIs+QOnV+QMi7PwGbv9VLo8IeWabF2msSDtMSdzidyIEZN1N173vg17ZnItcdkXOxjRqEWDQfBSthBYTxJEApXa1jhuNjh7aY3SaRKwwtF3btKUgh8KOMD9onR+epWpgZEQqWvLv+Iz8lPlr1iUHQUs+jCayP/6HKsfeEKIrQBs9LN3+fm+CH7m7RTrDS23wYh7U98yADkGoGLqTo4c8G/rFktoE14wt7zuUWCKOP1Kp2MGCWruUBuN1U+//woK0eDjDz/dvzQhOtDFpxE1yBPR/KzO6R5M7jTp6uoeJHYriHPnFuHPoR9tgWG974ClETw+pBgUKrdxbddKnO06wkZTHcR4yGgW+f3IFkggSih54xW253IXNE5zSMBKz/z2BP0sR9hluE5F/wE4dvC8+Y++TJ2JG+jHAOVfTv/qFwygk6R4jLwDYcW4bZtfc/xuHWWi7PkN/NItnkzhNkpOah4lCsq6RH/iT7Jlgecdaqm/Auv8Ab620k3NKF3pjybLPbfTJ26Ar5LrE2usyU2QNYF
 DpE59tUQ
 S/BIIZc+jGY2nYDqUKMTie1qXAzqoC4hzhD9NnGWeh4S5QPnr21t63Mldno9b3YY+nu336keDaQEOtQdHdAn2TzmXpSFfcokCuSh1phl8zN7uLVyOYkvzYY8JfUlHLq764StqJB2KyIjlpkobTtbswq7DNssFRcpomLomgxQ68WNK7N5LjQtE2jhAoh6OG3+vV8FqoZNt2374OFNXo06/KwCuE00kkjWuiU1G+EuSxT0mflJjWflHZklMHLHJqeDBi8YpHLaY6JZh5XT8NC/9wnKHcLqhxrb8+s0gc0c4fWIiDuDXwLoNsV9Mkgoog+02ewKX49MOrHD8YqSIo+0Inf0brVj7siVTUljNR+2PTELEJoEW8tz5JqZWmMS/D5EUaCURuhz9B6UwymV/fyiTfNvxfz4va+jNXgYhoOYowLCQcPhm8HboscBn4m2QVmq4BUT2J0TNBrQvtb22miUDNvixPRHdWu1q4qDveMNJ0vWxMpt2BBiIru4Rd4Qrx5tKQoiIJyXv7wCO0nOKar9PO0EPxhlLM4NvDBJ/bW3VJ7rqjdJt/sb7NtnooJHzE1aic/SPbYFDIMrtvjxojUDyMkR+0UK3fTlYb1ACPbkX5wUw2tU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Verify that opening a VFIO device through its cdev file and via
VFIO_GROUP_GET_DEVICE_FD both fail with -EBUSY if the device was
preserved across a Live Update. When a device file is preserved across a
Live Update, the file must be retrieved from /dev/liveupdate, not from
VFIO directly.

Co-developed-by: David Matlack <dmatlack@google.com>
Signed-off-by: David Matlack <dmatlack@google.com>
Signed-off-by: Vipin Sharma <vipinsh@google.com>
---
 .../vfio/vfio_pci_liveupdate_kexec_test.c     | 38 +++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/tools/testing/selftests/vfio/vfio_pci_liveupdate_kexec_test.c b/tools/testing/selftests/vfio/vfio_pci_liveupdate_kexec_test.c
index 4919175c1173..9610fe593cf6 100644
--- a/tools/testing/selftests/vfio/vfio_pci_liveupdate_kexec_test.c
+++ b/tools/testing/selftests/vfio/vfio_pci_liveupdate_kexec_test.c
@@ -1,6 +1,9 @@
 // SPDX-License-Identifier: GPL-2.0-only
 
 #include <fcntl.h>
+#include <limits.h>
+#include <sys/ioctl.h>
+#include <linux/vfio.h>
 #include <libliveupdate.h>
 #include <libvfio.h>
 
@@ -56,6 +59,39 @@ static void before_kexec(int luo_fd)
 	daemonize_and_wait();
 }
 
+static void check_open_vfio_device_fails(void)
+{
+	const char *cdev_path = __vfio_pci_get_cdev_path(device_bdf, true);
+	char group_path[PATH_MAX];
+	int group_fd;
+	int group;
+	int ret;
+
+	VFIO_ASSERT_NOT_NULL(cdev_path);
+
+	ret = open(cdev_path, O_RDWR);
+	VFIO_ASSERT_EQ(ret, -1);
+	VFIO_ASSERT_EQ(errno, EBUSY);
+	free((void *)cdev_path);
+
+	if (__sysfs_iommu_group_get(device_bdf, &group))
+		return;
+
+	snprintf_assert(group_path, sizeof(group_path), "/dev/vfio/noiommu-%d",
+			group);
+	group_fd = open(group_path, O_RDWR);
+	if (group_fd < 0) {
+		VFIO_ASSERT_EQ(errno, ENOENT);
+		return;
+	}
+
+	ret = ioctl(group_fd, VFIO_GROUP_GET_DEVICE_FD, device_bdf);
+	VFIO_ASSERT_EQ(ret, -1);
+	VFIO_ASSERT_EQ(errno, EBUSY);
+
+	VFIO_ASSERT_EQ(close(group_fd), 0);
+}
+
 static void after_kexec(int luo_fd, int state_session_fd)
 {
 	struct vfio_pci_device *device;
@@ -64,6 +100,8 @@ static void after_kexec(int luo_fd, int state_session_fd)
 	int device_fd;
 	int stage;
 
+	check_open_vfio_device_fails();
+
 	restore_and_read_stage(state_session_fd, STATE_TOKEN, &stage);
 	VFIO_ASSERT_EQ(stage, 2);
 
-- 
2.56.0.317.g454f8302e1-goog


