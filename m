Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5EB99D73E8C
	for <linux-mm@archiver.kernel.org>; Thu, 29 Jan 2026 21:26:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9BC886B00A0; Thu, 29 Jan 2026 16:26:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 963A56B00A1; Thu, 29 Jan 2026 16:26:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 650166B00A2; Thu, 29 Jan 2026 16:26:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 525B16B00A0
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 16:26:02 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E96918980E
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 21:26:01 +0000 (UTC)
X-FDA: 84386284122.23.E1955D2
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	by imf20.hostedemail.com (Postfix) with ESMTP id 350CF1C0003
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 21:26:00 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Rd3Npi+k;
	spf=pass (imf20.hostedemail.com: domain of 3ZtB7aQgKCEkoxl4wlnvrzzrwp.nzxwty58-xxv6lnv.z2r@flex--dmatlack.bounces.google.com designates 209.85.210.202 as permitted sender) smtp.mailfrom=3ZtB7aQgKCEkoxl4wlnvrzzrwp.nzxwty58-xxv6lnv.z2r@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769721960;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=idHpW3SDccKJdv6+7GcWw8jBEpKmDKEMPgP0EwwfxqU=;
	b=hOizF3sIA1x7dV9/XJtP7JIcNnLb/ud37DWvHQN+SUUfSwpVBclry1BEgsEq1+ft4pYUw2
	qYjj/xtw2mnTucnhxSg4im8kOnsaOExWk+qnDWse/fly0R2D5gjZT01b1rnYkKF8JtHDig
	U9yO6dp1RRXD01uDe9X8otw91AQuecE=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Rd3Npi+k;
	spf=pass (imf20.hostedemail.com: domain of 3ZtB7aQgKCEkoxl4wlnvrzzrwp.nzxwty58-xxv6lnv.z2r@flex--dmatlack.bounces.google.com designates 209.85.210.202 as permitted sender) smtp.mailfrom=3ZtB7aQgKCEkoxl4wlnvrzzrwp.nzxwty58-xxv6lnv.z2r@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769721960; a=rsa-sha256;
	cv=none;
	b=CsgL9F+8EIt/99gySpK2DlX5NArrCd4UwnuQk1j8Kfkq7AyhPIKwKem06VHF9CdcZ7kFAH
	vUkA2TWkIXzh7z4q2OQD6B4IU/zpachRUd2+SRrrFr8ngEmE5O7i5/MsNf5oiuIYqbXam9
	cVtooE7Rprzp3ZymhsmbHOgZPwmBE8M=
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-81f53036ac9so1263973b3a.3
        for <linux-mm@kvack.org>; Thu, 29 Jan 2026 13:25:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769721959; x=1770326759; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=idHpW3SDccKJdv6+7GcWw8jBEpKmDKEMPgP0EwwfxqU=;
        b=Rd3Npi+kDJVkuH0Id/wvWMZk2y5OLZSFlQ8Vp5dilevsU5qfkbVgAvTimpBZAbs82Y
         fXvw6Cx8Ay6j7G5oI/3OQeekG/x6OFl6hEl2fD838hkdj/TJVgBbvuawR69gdmSkFZmM
         Zxrw0y1m5B6i2/xG2OFwd9HU/PjiPDZNHJk4+IiLuqJmOTRPWMxJsjj0xDbLXS/SiiQK
         vzoiMb2lrN1Uu5wmeGK7q3DPe7Jv71axCOzd+kKXe7HYavqu8+mEUwKQS+1CG6kzWyu3
         k2XWoeqC84SsERKOtTzj4zuoNuhpx3dMgiYUsJi0hfBtmdZ2a7Lx7sVmUNXVntrvUE7g
         nGFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769721959; x=1770326759;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=idHpW3SDccKJdv6+7GcWw8jBEpKmDKEMPgP0EwwfxqU=;
        b=lPa5cQcnY93hUg59J0gAl3KW4OMzoEY+CXcyFXvkgUIvHqj/rJFHJhk3J5BPZGtw2+
         MsuAUa/FLN98z8UuD5UjsCp0IvW/1uiKVSi9FcAKHT82OUNz5Y6TkMnW2CSA8UPtYViZ
         AAB4n8H8TvOG5rrMX4lM9cfmVoKeKu8numS7D+/YjzrN52Ujzr11tcV3ZaSOIxhmhFNM
         S22/raTz1Yx2S0kmRyTG01kjnyRKxakr0QiGWtk7A1x83jy/IgkAxkTnmmhiaCk9hy0B
         FrVTjr4NjmPJ1fHvgRq+tE/287RgSMu0p+fg98B/MVNFvvCVoFFZAWAPZvl1TXNBIrKS
         GEMQ==
X-Forwarded-Encrypted: i=1; AJvYcCV+D1S24q3Hjzw4/dm3qrJCDTgVugqemdT7CN+LKlePPwh5VAVJRMYCdrVovhEMVSdZHsHsQTt1Ow==@kvack.org
X-Gm-Message-State: AOJu0YyhXKfcO2OKMmrwJKnz/KgVO6K9jPWJ6abnTwASTLEtSNjxATCD
	vZ71PncBhvRrm/ywHa05PjBihdMftWhHAcYWLYWNsgSYs4lA5PLPGfaBJvtN/ep/u0RiEBO7HoJ
	ycZYXC/F2GYZeNQ==
X-Received: from pgdj29.prod.google.com ([2002:a05:6a02:521d:b0:c5e:d16c:917e])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a21:3392:b0:366:581e:1a11 with SMTP id adf61e73a8af0-392e0148145mr472290637.57.1769721958852;
 Thu, 29 Jan 2026 13:25:58 -0800 (PST)
Date: Thu, 29 Jan 2026 21:25:00 +0000
In-Reply-To: <20260129212510.967611-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20260129212510.967611-1-dmatlack@google.com>
X-Mailer: git-send-email 2.53.0.rc1.225.gd81095ad13-goog
Message-ID: <20260129212510.967611-14-dmatlack@google.com>
Subject: [PATCH v2 13/22] selftests/liveupdate: Add helpers to
 preserve/retrieve FDs
From: David Matlack <dmatlack@google.com>
To: Alex Williamson <alex@shazbot.org>
Cc: Adithya Jayachandran <ajayachandra@nvidia.com>, Alexander Graf <graf@amazon.com>, 
	Alex Mastro <amastro@fb.com>, Alistair Popple <apopple@nvidia.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Ankit Agrawal <ankita@nvidia.com>, 
	Bjorn Helgaas <bhelgaas@google.com>, Chris Li <chrisl@kernel.org>, 
	David Matlack <dmatlack@google.com>, David Rientjes <rientjes@google.com>, 
	Jacob Pan <jacob.pan@linux.microsoft.com>, Jason Gunthorpe <jgg@nvidia.com>, 
	Jason Gunthorpe <jgg@ziepe.ca>, Jonathan Corbet <corbet@lwn.net>, Josh Hilke <jrhilke@google.com>, 
	Kevin Tian <kevin.tian@intel.com>, kexec@lists.infradead.org, kvm@vger.kernel.org, 
	Leon Romanovsky <leon@kernel.org>, Leon Romanovsky <leonro@nvidia.com>, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-mm@kvack.org, linux-pci@vger.kernel.org, Lukas Wunner <lukas@wunner.de>, 
	"=?UTF-8?q?Micha=C5=82=20Winiarski?=" <michal.winiarski@intel.com>, Mike Rapoport <rppt@kernel.org>, 
	Parav Pandit <parav@nvidia.com>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Pranjal Shrivastava <praan@google.com>, Pratyush Yadav <pratyush@kernel.org>, 
	Raghavendra Rao Ananta <rananta@google.com>, Rodrigo Vivi <rodrigo.vivi@intel.com>, 
	Saeed Mahameed <saeedm@nvidia.com>, Samiullah Khawaja <skhawaja@google.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, 
	"=?UTF-8?q?Thomas=20Hellstr=C3=B6m?=" <thomas.hellstrom@linux.intel.com>, Tomita Moeko <tomitamoeko@gmail.com>, 
	Vipin Sharma <vipinsh@google.com>, Vivek Kasireddy <vivek.kasireddy@intel.com>, 
	William Tu <witu@nvidia.com>, Yi Liu <yi.l.liu@intel.com>, Zhu Yanjun <yanjun.zhu@linux.dev>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Queue-Id: 350CF1C0003
X-Rspamd-Server: rspam07
X-Stat-Signature: hgtknq3kziz4i3tot8otj8m3zoutybhs
X-HE-Tag: 1769721960-573624
X-HE-Meta: U2FsdGVkX18TZyAemIaFITiBFfEMXAOkRZfrcGlxgejC6UsLGfrLTo82CncCMKtsML9G26L+/d6KoTjyOOTcV5bCjQvDgWMTH92jQGELfEGNeclEXu9I5ZyGeWfQB+SXnWoF8h9LbKPYeuVyKZBzkrFJ3qp0l23TTLZIA+LoqetbTbXg3kh+1YtILQLS7RE8ZsidrByfOpUQUsOn61YefgVN2/5DRLnIq+KT3v5jFf/MPVoGQcOvlE9SDQkXorxJm2lVwaUCuSYb/avHRsInDbytK0MNzBPj4iDu7svwwW+WZT4jU+E/tJmQtGZ/sASfm1Z0Ir+p1OhZCMn9iURacrbK4E7VOzBytwyays9Q2gDIifJ3mjz3l1Hew5cc0yNJVhslxNGxhPd6ExnZSw7BuborVRF83jKScxcj5arlIo7d+JXn/UzBXhCuN+K2AVSz437LbpR56vJQC/pgDSxuwURfcaFnfqGQcv3f1YGQ6HPAB/bHPUND42T4LxDA5vQsy/54KPURTRvNzQu3Ew3G/Iw8AkaM8iBsxNNZZTC0DNcEyj5gMGTJR6Q2Xf0rJUmNainDh4Yvfrc32eKGw9iMjV/rq0aAz42Ibvn97/z1yYgIRCmkzAwSUJqCCpWFQ3yAAU5BI9oYUpAgyqBFB+Lm/fo4hd3WQdSeJLJdR4hG5N+2RnOK0xih0IJ8U6rpqYuxDzYR5O3gSkJzrp2jUrSY26WmUEeieyimmsGe3M/C68623l4Lq37vvvrnOTLIQaOJ6vaoWzvOQFJhBkwlcJZ7f0jXBlBIiC0BC6/qu57cvJ7Z/GERjF3WybY6cASefeKNaxxauoZppHxxstQrMiOu0VpOXUn+DaKKEAeCIeE1/rbXauu6a447ElfqjJckZeUHvA8YpoRziNE/ZIXeC1x5Q1Qa56Z8HRedbyo4Pd4PwmseK0+3IM5Bp2wzCFUH6N20sgwvrfemruVThkL2peF
 +ZVikHLa
 /I//LFYBljHx3v34saz/3uwEIWXnqeR/33u0EahsQu0/SJiwyv2hEQIoTq5IXSfa4BGgSVovwyKu1fX3HhLggqRqqBHdrfQ/yVfzli1MJ4mySsSP3DVrPG+KGGg5HxYC7gDLsNRgqtalK96GURtE1GKt1rflwBofzj68qOFCq0wABItv5rX6U9nQ8tj+LYgBRSZeocIbCbV5GrhCyrd0pGCIXsYQDhc6XToR7Bhuv+3ujWzc0TMPyXLOuYn6zwpAIyxyPp295ol0YJPsgR4rUDFC/KftMVvXIfk7BNDxOt/bzstD4eDaWkMq5F/9TgCINlAE9wdHybfU89GVSac/guvab7btKiblz09e49J7qMzN2fS4CUBsOzzvMIZ0LhTbEyzM/+ODDKD13T+3WUFoWl94d3o5muXcV03GrtvOWowVH6jCf51m4gElJiR8Ij4W3rOyQW4fZQTNYl9SYZVR6uAXNBQ2F2xnEljzPvpQqY5gW4yfiKQ7KA/oSqHzIRlZqRry6cWtWYbdBPiPcbxF2Ueq1IefJQAS/YMk/t8jRiVV6iN4t0CUfWpt47A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
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
index 4390a2737930..4c93d043d2b3 100644
--- a/tools/testing/selftests/liveupdate/lib/include/libliveupdate.h
+++ b/tools/testing/selftests/liveupdate/lib/include/libliveupdate.h
@@ -26,6 +26,9 @@ int luo_create_session(int luo_fd, const char *name);
 int luo_retrieve_session(int luo_fd, const char *name);
 int luo_session_finish(int session_fd);
 
+int luo_session_preserve_fd(int session_fd, int fd, int token);
+int luo_session_retrieve_fd(int session_fd, int token);
+
 int create_and_preserve_memfd(int session_fd, int token, const char *data);
 int restore_and_verify_memfd(int session_fd, int token, const char *expected_data);
 
diff --git a/tools/testing/selftests/liveupdate/lib/liveupdate.c b/tools/testing/selftests/liveupdate/lib/liveupdate.c
index 60121873f685..9bf4f16ca0a4 100644
--- a/tools/testing/selftests/liveupdate/lib/liveupdate.c
+++ b/tools/testing/selftests/liveupdate/lib/liveupdate.c
@@ -54,9 +54,35 @@ int luo_retrieve_session(int luo_fd, const char *name)
 	return arg.fd;
 }
 
+int luo_session_preserve_fd(int session_fd, int fd, int token)
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
+int luo_session_retrieve_fd(int session_fd, int token)
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
2.53.0.rc1.225.gd81095ad13-goog


