Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 31DC6FF8870
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 06:24:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3D33E6B0088; Tue, 28 Apr 2026 02:24:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 383956B008A; Tue, 28 Apr 2026 02:24:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 273246B008C; Tue, 28 Apr 2026 02:24:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 15B356B0088
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 02:24:13 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A4B3F40498
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 06:24:12 +0000 (UTC)
X-FDA: 84706974744.26.51F9CA6
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	by imf18.hostedemail.com (Postfix) with ESMTP id E881E1C0009
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 06:24:10 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=oY4HDf+2;
	spf=pass (imf18.hostedemail.com: domain of agarwal.vineet2006@gmail.com designates 209.85.210.173 as permitted sender) smtp.mailfrom=agarwal.vineet2006@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777357451;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=dCR2byQYfe0lorBCX0yQhVcHegZI42GX5HyJDRNPA3c=;
	b=6F9Lxse6FQqvUbwdrTuIPV1lEbyvBQwrKjUSL3tEbBpF4AnVwcW5QpZUa5KRj6qPqTniZ8
	OcMtpVIpCvF3wzp6PYHk1xzR9Dz3YgfiUJtefUpFS95WHPby3j+DC/gbcHx0AY7mpsIztU
	EJg+tuMgBMRvjqX/BbCqvPSEUz/Nb7s=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=oY4HDf+2;
	spf=pass (imf18.hostedemail.com: domain of agarwal.vineet2006@gmail.com designates 209.85.210.173 as permitted sender) smtp.mailfrom=agarwal.vineet2006@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777357451; a=rsa-sha256;
	cv=none;
	b=aCHG3CPjSYzskpn/OL6WlLukQPZGmTl7fLN8lWjGAP5qynGPabpe3i5V5vPBPHJDqO4h22
	JIPkLOPSep0/Nee3KXMkQTO/1o6SYLRaN2DA3Wa6Z0K3pNYXt7W0j1QwX8XmDUfvgHmtXN
	T8dmgyMzsNDAe0sdHPQQY8RmDDNOniM=
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-82f4a53ae20so8050927b3a.3
        for <linux-mm@kvack.org>; Mon, 27 Apr 2026 23:24:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777357450; x=1777962250; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=dCR2byQYfe0lorBCX0yQhVcHegZI42GX5HyJDRNPA3c=;
        b=oY4HDf+2XcCzEZJ85w8iaq5pYE8I3BefVguN57g9TBKI9Aj7jo1x0j0khIgj7pz2vS
         x7fUijatIwI7pmXMHx934f2cXOf0Kt7Vqu4G59aYy2s1RKqsJUo3+pfNSdzuoq2fcgP5
         KjS5vEMeBnG2PjNQUxcRq+A1tlcEqVcVAQPR4Qo1jgV9OGvbZt+OPqi18TXoYwCq4VGa
         5NoqmfBbfKg8Zuyhw9IViFStYgfOZAG7HNVpWmaRwEPlQz15EzvxYHu5ak44ZL9AsFmi
         u3Rem5XXKgceYelgjLnIo4PvyQArv5uMeth4l6S7c74l5uIj2ayTQuT0nWA3qhPSoVEW
         Xb6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777357450; x=1777962250;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dCR2byQYfe0lorBCX0yQhVcHegZI42GX5HyJDRNPA3c=;
        b=CITKKfZlVjtOsv+ZcP3Id1CnGiQjWugfs8sgXR5PXCyVyQOaW9CwnbzDwWeMIBcTai
         4wjrwAKYA+fmhLaH7aS1Ef8xLQb7P7tCbo0okg2TT8/ZO0vmmpu9e963L/7QcJso7x1b
         EhS/ku0KNzhlkXNHuS2yV96BSAPG05bTlEARkpPon9egUwC2drEJdfUL4/8UoiJDlar9
         UZ8L+EDpmvpO+HbCl8pVpxMXLokFdWIytHNdQwjjA5VKSZZuUjcFSqc3oigxJZo6xIBS
         pmFYHNWzfW77CYJ2Xuc7ZWCABwIMNsprcZL5Scnw/Uj+DPI0x2b6mf5OXUyXlgxJ2LzT
         LtJA==
X-Gm-Message-State: AOJu0Yx9fjClFwhBDJSX57HAV1N5fJ+64Xjjz/RHqxooqqZuoDjF1ew0
	wCiwfAGNHasgAi+sPcXgBmOywOIcp2RLVyU7mSg32Gc5N6q+GkmW6qY4
X-Gm-Gg: AeBDievSM4DEASk1wlTnCHNI5Xz1upEhYYXJIN55RXXJ2Oww78utR2HJJcB2E2Z/8ij
	+FnMG5PaMjM6b5hHdBmWNq0U7ZurwSph/zPfwvJfh2w3gwqYn38fAFlfUpZwFRmcNUxEOjeMz7X
	MnhdeVIS/Ts3Db8a5F2CkDS58nsD6MaZYJYrmpgesGzKGiNKrYVdZSDkH4kAszaz9TI3Vd2b44d
	sAgQ5yjYhAHGcpImCmSn8g3WKiXDPKGBHcSTtG3M9coV/3j5A1hzVdr6F5Qc9SnEf+xHIUz1ZQe
	S9CunXcAy+3bso4XHnZ8JdDromWts/4k7xW6fqv6A4Xv44hFPW1Clq4vzCXBR3vPvxJHiChxNeV
	Nq7KD4FvfXU6gGXyrStiCLi3e7DDysh7xDGymlJSadZFDWZoTp0p1qcdiJ7ZRAYGH6ieb0zrR7P
	1UDVffahs9CZuSGnJNMYif5PrqjhM3T96iqRvUmCPh
X-Received: by 2002:a05:6a00:bd0d:b0:82c:247b:ffdc with SMTP id d2e1a72fcca58-834ddc2d14emr1807018b3a.29.1777357449562;
        Mon, 27 Apr 2026 23:24:09 -0700 (PDT)
Received: from vini ([2401:4900:8fca:e7b6:f223:6319:a79e:7616])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-834dae2249esm1514843b3a.21.2026.04.27.23.23.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Apr 2026 23:24:09 -0700 (PDT)
From: Vineet Agarwal <agarwal.vineet2006@gmail.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	shuah@kernel.org
Cc: linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Vineet Agarwal <agarwal.vineet2006@gmail.com>
Subject: [PATCH] selftests/mm: khugepaged: handle partial write in file_setup_area()
Date: Tue, 28 Apr 2026 11:53:22 +0530
Message-ID: <20260428062322.20417-1-agarwal.vineet2006@gmail.com>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: E881E1C0009
X-Rspam-User: 
X-Stat-Signature: kthswz7e5fxukbbguw1ruawrmf7rfxut
X-HE-Tag: 1777357450-357423
X-HE-Meta: U2FsdGVkX1/kRFsrPQfEuWw5+eR+vfdnt3s4xSG4bb9c9iWaP/JVkaNehG/AGHiQIW/EcIl3YMZQQHSzRboM02a13p5Zvfkey066EsuQhB5Q6YZAaiwo79nucIh9Lp54VKjDFoZhMNBMRzkxb8FRZHDGZh9LuEz+BqDF1utxuf+ibbptu+vrZAs3OaEUNEVYLWt/BYG+CECCU3gotws1CW02oiDTCEh01VMzxytvrAJN6GDjSNwyNjToD/pHWDhh/QbSorS7mwVQrWuA4S2JJrzLWrDozu0AXjEtOwGGGEwwDQreLyk/W1Ufg3XtgRfuOhwTIem/qmIsDYNKtoZBkXoq0LrUEFak6GXBXI97cFNxen8bystD/r4piqu3mnoaZp+mjdjIxkONO/WTspeWfbs0nkCJIEG9YL+nBnp5rItDyqqTK3BnND16sHgC6mzoiUYSFeSCXe9aj7+396pkTALWw7SuX+s27PLDj3GZYvDUaFm8xfgh5DOCX2hg/brezmAKtPHo7Om1Q3wYaCiC+grsIIkJoI/mwA7fpxNnRMMkmBlciAvlViDE1TuxrKjGSIWU9bAzJ9wHePofBsDlJ3zQZvmqzUvF9J+cO5RNeOJIklEjO1cJli6r73SaztNFTrPZss/uiZjjyAJ+DlTQovylKTuQt+bnJIG97F4lR7heNfePMz+Vb37OHuhY3YCJtt55DikX187ZwS53Qcnr+stH40Fc5NHAwO/buFBBzaWAa0JY5ReIc0KDBGAQJO6V+d7iC5AYCfHJmrjnnGcbX1Ha43eRH9uWRoWfHFmH7Z75L+jY8gemfV2egNSpJTJmWV5ILrz7lHp1W4j35cln9EaDxvLM8ujA93SNsFe8t0M5zQF0D8boGBqfoMU/yJriaD/TY19eJCDpwYShsoMftZbhRx5FCERbPuxqzgdr8yj9FeiPS23JQWgj26LsMTSjKWheOz8g+L6KuDlYcQ6
 ljha+9Nq
 U3c/IB9rABm/vfBtdcQ4qyKyT9QGCM8hjCSKxu8gXOaeMMloXz8bjhEVoktooeraaF5gNMpUsAv9OY8oOqzuYclm/01lH7fBZfoeSHoseokORxlSCbSKEsog3XhbTpv0MVmjy6mqhTOOb6MqFkWMWlX2hPRNijQm18cwyEf1ElE1xMdU6mB3XIh8TQXqs5/t2SciuhjjPXrJcxcxnFmmrbStYRmd0CnLfuSdES4MVxERFiU71aMLyN5PIffWlk5fgSfjpR/0BQd+NrYizeE4zau0qSb7cWgtQrQUWuWd8WZ79NJJb3+SHvCdHDyxd9vW7HRUWKGXGBgkD9TJUt+m+hGVvaW4NoFm1iy+uXbGZ1201/SZDu3kPV9E3vUAq4NS9OUOeOiQYspu8uIAFYq6+dqfifuvCWAt+nFVw8OhjhtvQ4+mOBFO4cs8mW7LGea5cO4sKqW7xwbRGf99mq2aCPTh+wytS1rU/Tsrp3fGdR6UIem8H3CeQya0wJeUq28a8F77zssOyJyIkuyZva2ZyeIVZNvZIjAF5DUjjaIoRZWLldELNBWOwM7HUOtCbTw9ImbmHGVly6T314t59tDjR39yCNw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

file_setup_area() writes initialized test data into the backing
file used for collapse testing, but it ignores the return value
from write().

If write() fails or completes only partially, the test continues
with incomplete file contents, which can lead to incorrect test
results and make failures harder to diagnose.

Handle partial writes by retrying until all data is written and
abort the test if write() fails.

Signed-off-by: Vineet Agarwal <agarwal.vineet2006@gmail.com>
---
 tools/testing/selftests/mm/khugepaged.c | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/mm/khugepaged.c b/tools/testing/selftests/mm/khugepaged.c
index 3fe7ef04ac62..c13f06758750 100644
--- a/tools/testing/selftests/mm/khugepaged.c
+++ b/tools/testing/selftests/mm/khugepaged.c
@@ -369,7 +369,9 @@ static void *file_setup_area(int nr_hpages)
 	int fd;
 	void *p;
 	unsigned long size;
-
+	size_t remaining;
+	ssize_t ret;
+	char *buf;
 	unlink(finfo.path);  /* Cleanup from previous failed tests */
 	printf("Creating %s for collapse%s...", finfo.path,
 	       finfo.type == VMA_SHMEM ? " (tmpfs)" : "");
@@ -383,7 +385,19 @@ static void *file_setup_area(int nr_hpages)
 	size = nr_hpages * hpage_pmd_size;
 	p = alloc_mapping(nr_hpages);
 	fill_memory(p, 0, size);
-	write(fd, p, size);
+	remaining = size;
+	buf = p;
+
+	while (remaining > 0) {
+		ret = write(fd, buf, remaining);
+		if (ret <= 0) {
+			close(fd);
+			munmap(p, size);
+			ksft_exit_fail_msg("write() failed while preparing test file\n");
+		}
+		buf += ret;
+		remaining -= ret;
+	}
 	close(fd);
 	munmap(p, size);
 	success("OK");
-- 
2.54.0


