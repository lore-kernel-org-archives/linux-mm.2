Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 44454FF885D
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 10:01:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A1F1C6B0088; Tue, 28 Apr 2026 06:01:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9F6556B008A; Tue, 28 Apr 2026 06:01:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 933886B008C; Tue, 28 Apr 2026 06:01:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 852326B0088
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 06:01:30 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 14DE91B95CB
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 10:01:30 +0000 (UTC)
X-FDA: 84707522340.29.CAD448B
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	by imf01.hostedemail.com (Postfix) with ESMTP id 2B9594001D
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 10:01:27 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=mUBcIS+V;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf01.hostedemail.com: domain of agarwal.vineet2006@gmail.com designates 209.85.214.180 as permitted sender) smtp.mailfrom=agarwal.vineet2006@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777370488; a=rsa-sha256;
	cv=none;
	b=ePjRJmDI7wD0hat44/Bxw1kBqieU6HsZMh6iMcugfB1DDa7DNLf2kkJSO0/CxOIE/2ykHr
	Urg6PXSJmK9A6hZCy7TBn9S5SxuUHcmf8dcVXjrad/oRDd5SOKIoijmDDK6Mr1VbF77Hk9
	dBdOMuwmzqVpWQely+y0zydiUd5q+Aw=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=mUBcIS+V;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf01.hostedemail.com: domain of agarwal.vineet2006@gmail.com designates 209.85.214.180 as permitted sender) smtp.mailfrom=agarwal.vineet2006@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777370488;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6QQkVdRIZwiZco7V8KN8H23FWv9G8K8ad5vKyiX7w88=;
	b=DqW5Faepju1A+ye//rEGzIVGNYvifpzWuufv5JPUs0R3o9CxxnTtBDu9SoWKrJO2RUuSfL
	dtsPjd2Kk1xpozhGKPyNfN5OO2HIsYPa2pozHS3jjoGPVfp3hrUUhxjrRlvZNIwvkCfEU/
	PN3+r6AAq3H8raDNUKfHDMHoXqJ/hJ0=
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2ad9a9be502so69699835ad.0
        for <linux-mm@kvack.org>; Tue, 28 Apr 2026 03:01:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777370487; x=1777975287; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6QQkVdRIZwiZco7V8KN8H23FWv9G8K8ad5vKyiX7w88=;
        b=mUBcIS+V/qBQMudGfqdG5PqZXSxhmeRIiSz/051d71CPpdLVpfkJJkuc8dBx87IgQA
         djTa9AKVmEcV/MQkpyHfkNAnaSq6QgO7XxHTduDANyhLtB1Y61Sx1i7RdCdvKPNtdSNS
         UnPq1Y1PBqlz1ggowuGs5+6cPvysFYXIBN5UIORzSscnbAWMp0rEcl8ADK33PzjDPUaV
         gbKSBckxw1KkHufm179DhsUprSAScDQGcI5eX1WSC1VvORukwwANkSSyDWgazHArbz4J
         R+uO/ZmIn6z2Sw7r335Cx/qHivLcDbN4Gh0a0fUmQbWL95XHvy5ThGpZrbUWC1VHq1Ya
         KkRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777370487; x=1777975287;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=6QQkVdRIZwiZco7V8KN8H23FWv9G8K8ad5vKyiX7w88=;
        b=QCbwSNCSLA/hj/VGx8bNfTMAwabcs13QqLTr0E47Vl21mQOMiGH8E3lAIb3IR/KQPu
         1DyJ6HLRLvGG/RQDjoWddFi7XnU+eHACk7co9kVlnkhhZSPaI552pAfNyfvaGwVOxLT9
         4ZjWxsPYjau9Lul6h1RFzwqiN7/pEnQDT+q1Mhowe3N5Yd4NqwsN2Nix6Nki+aT+t+wg
         QjQ+3oM0ke66LD1i0uMHDNaymtvlo3bguAhSEkuI4H8uLJcS/tPWbtVwuhM3grVQoJ/P
         bBsej2gPIhgYzxnjT24ZPaxi+Pk+lWRNS3cNta9/hpQBiSh5xBCxhC7RGbRBIuAjcETF
         MPUQ==
X-Gm-Message-State: AOJu0Yws+eR2ZEWbLLBPKhpHJH1+Xy03Zl5/95AQaL4IZM7jpKqbQdPG
	6tjHxe8zXqHuOaTzs7tGn7hEdgdHLkp8opFCLG2HXREQtU+G2PAkgPlX
X-Gm-Gg: AeBDieudWja/iLkyz93wNdd5h4MUPw5Nyf5N9xnsuZDAZKWXZLFRYG+mkEhZx4SnjnW
	1VBJB+gcgAFsnGJ66qaLyOqsWLf+B8lFSJawQZZn2PpwhJ99/FKZM0ewv1M5fqKOcnNDyQEgiWN
	f+Go0ebJt57Rps/hAvnZf3kKlrKMnXLmqnjoiKhQ89mLDIwVII5h6T9HVSk88cBcDrivPPbfNwU
	4TfrHZxC+8T6ynxYP3BS6/ABwLlCXRum51SyrjqlxblrH/mawZWjf8jn58TXWHYciIKXs5JFeGo
	oCzJlgEHPW/JCCRsD1mXtp9VwRZ9khpkhVXtnakCJBgZbVGxCCp2cMQiKdPqE390pxkLNeZxbx2
	6vD45zspogopmQnoGFrpLSZdsEwH4huulXRSkzk95KzuIVPFCx7TgV/oPHAp+n+SLNZK16bBCSk
	4loy0oXIJiV1HRCJAKzfgOvIUtkH5L2d9i33+YJGvT
X-Received: by 2002:a17:903:1904:b0:2b2:4fcc:2687 with SMTP id d9443c01a7336-2b97c47e638mr27098785ad.31.1777370482430;
        Tue, 28 Apr 2026 03:01:22 -0700 (PDT)
Received: from vini ([2401:4900:8fca:e7b6:f223:6319:a79e:7616])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b97aaafc9asm21801265ad.34.2026.04.28.03.01.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Apr 2026 03:01:21 -0700 (PDT)
From: Vineet Agarwal <agarwal.vineet2006@gmail.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	shuah@kernel.org
Cc: linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Vineet Agarwal <agarwal.vineet2006@gmail.com>
Subject: [PATCH v3] selftests/mm: khugepaged: initialize file contents via mmap
Date: Tue, 28 Apr 2026 15:30:58 +0530
Message-ID: <20260428100058.62554-1-agarwal.vineet2006@gmail.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <3abf09d8-a98e-4f1b-b8d9-77879a8a2733@kernel.org>
References: <3abf09d8-a98e-4f1b-b8d9-77879a8a2733@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 1671sic7ys1q8y94mihfcbjyp5ii3ksg
X-Rspam-User: 
X-Rspamd-Queue-Id: 2B9594001D
X-Rspamd-Server: rspam07
X-HE-Tag: 1777370487-390815
X-HE-Meta: U2FsdGVkX1+5lw12d0RoVHdiIl8RfyQeRLq66YnLpzc98dXCNHGxy09OnnJYYpE/Gu5+KhuY4H4m8TR3l8VActfM6P3jY9aSTcMW6gFTWJoCQ5Mpx4zM5CcatKI2GB4/lw/hqBF8AUlIgs7cf+VTEl+jqgXsIpywPKgW7XUlZf9ojp3fSkevyJOCTFVRgitlGlnScwnI1NSchnBJ6KB65+1gMM+LREbh8YgFGCbrJYNtls2xPqZqyJWOfeGJyMjBi6CQeVrpntU2546JOTwGMgePiYDUfR4YOdx2SItbxReSarnM7pl0yvfhoHlRe/P6/41bCyU+BiXuzO4UFXTU8pukwlLfjSGz8ZbEtuzNZ8wgWBDqShch9aNG0+qCMRGAEjQT4ZGCcq7QSA/rcGvhBVQlPpWe1UbJn/zZ/z+6si4Prom+9oPaR7dAY2dXqGdc43rBeOdbDXT1WDy4ImHYgf07QBnvdxWZX0aaIOO3KAeCNhJI91/WWybeAjmxABUA5KXze4SRI/ic0AzQjU+mVcYoCXNE+kJRDh+8hFXk0siR35tE3PGA4+MNcdAl+EIbP7ArgS/OnZyI2ayfcXuJs7QDdmC4gyZ6FX7RzWgwzVDYg6Pzh+ktt0OXD6rhmii80qeiq+fmWPUq3NbOq6+WyzOyZGRxwC4W5G7bKsfzJpJ+1dBgDM6hKJcM2Rt+Z8sfoiOUUQ0efiPAMngsYvJcBo3wIBujyRW2N+ZdiwZmb7jIBaISdqDK+f/KZY4sLSKu/Ug62+LP+L+J692snBMWQ+8hj5RkAxIZajSfGwF+hDKJbWucsdcvmmVhPt1m28smgim1USCvKOGepoIn81ZMcpOIOGQ22YFD+oDkyLrgOiOPgSWHPS0D4KYUj9/Q8iAwmQ8m69N/pW8dzTL4s9J2aOz0qlVv2qTAY/7i/PUBWkjH8xkp80v+ZdHpfntn4SPK/D+EloVXnYgslR04KsI
 rUlI65iS
 g4wPf+VPIlYKG7QUaqbkGg/PdWkTdvnSJyw1AkEHSIX9LRXfI0wmevgyYfAjGLaGIJLHoEU7Cjg/kUX1HTOgMPfc+y8Bys60qIgQa+lAMDV9zQ0Bp2XQGxywjU2jwXsF/086R0akSn3++swS1hBYpel1dv9jCYUaoDWx5JcQ5Z5twNNEXraaD84zEl/erayl7IWKaSqJR/ehPMIs6cB43KiNKLo8milQm/gab4R78YhBIie0svwTE82PcPSdPhlda2AijN0iRSQXfAKuxo4s/ZG0POjpCC1tkCQhpamiUE8X6pX7pDqkV5a8EonG/6G906xo6HE3N+XDexaoWgkBwHTEAsuyQuLub9F6KQe4jf5PmVBXCxLCbVSmCsZ/2oHt5Y0pzU4c6mkIotfNpt8NmXCaHppvZWSNMhVhWASbuxDCyGHtlMevMfUcoAUGGiX6trbkS9dhiNWQuv8s1xAbtG1kb+i/GvPRgmYA7Ny8nsp71M1mFTL8S+pCo7sHBKL2P2QGtnmkfQQcHbqNVr9z775kFVxeqpyObJ1KjhFA2Io8j/Oo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

file_setup_area() currently allocates anonymous memory, fills it,
and writes it into the backing file used for collapse testing.

Instead of copying data through write(), resize the file with
ftruncate(), map it directly with MAP_SHARED, and initialize the
mapped area in place.

This simplifies the setup path and avoids the need for explicit
partial write handling.

Signed-off-by: Vineet Agarwal <agarwal.vineet2006@gmail.com>
---
 tools/testing/selftests/mm/khugepaged.c | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/mm/khugepaged.c b/tools/testing/selftests/mm/khugepaged.c
index 3fe7ef04ac62..57ca4224bd5a 100644
--- a/tools/testing/selftests/mm/khugepaged.c
+++ b/tools/testing/selftests/mm/khugepaged.c
@@ -369,7 +369,6 @@ static void *file_setup_area(int nr_hpages)
 	int fd;
 	void *p;
 	unsigned long size;
-
 	unlink(finfo.path);  /* Cleanup from previous failed tests */
 	printf("Creating %s for collapse%s...", finfo.path,
 	       finfo.type == VMA_SHMEM ? " (tmpfs)" : "");
@@ -381,11 +380,21 @@ static void *file_setup_area(int nr_hpages)
 	}
 
 	size = nr_hpages * hpage_pmd_size;
-	p = alloc_mapping(nr_hpages);
+	if (ftruncate(fd, size)) {
+		perror("ftruncate()");
+		close(fd);
+		exit(EXIT_FAILURE);
+	}
+	p = mmap(BASE_ADDR, size, PROT_READ | PROT_WRITE,
+		MAP_SHARED, fd, 0);
+	if (p == MAP_FAILED || p != BASE_ADDR) {
+		perror("mmap()");
+		close(fd);
+		exit(EXIT_FAILURE);
+	}
 	fill_memory(p, 0, size);
-	write(fd, p, size);
-	close(fd);
 	munmap(p, size);
+	close(fd);
 	success("OK");
 
 	printf("Opening %s read only for collapse...", finfo.path);
-- 
2.54.0


