Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 301A0FF8868
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 09:44:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9B7E96B008A; Tue, 28 Apr 2026 05:44:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 98F336B008C; Tue, 28 Apr 2026 05:44:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8A54C6B0092; Tue, 28 Apr 2026 05:44:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 7AF466B008A
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 05:44:21 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 16BB1C1E22
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 09:44:21 +0000 (UTC)
X-FDA: 84707479122.10.FC53D68
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	by imf18.hostedemail.com (Postfix) with ESMTP id 4AD2C1C0007
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 09:44:19 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=hZ5W+eNM;
	spf=pass (imf18.hostedemail.com: domain of agarwal.vineet2006@gmail.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=agarwal.vineet2006@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777369459;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=C0tY05QQvlWHs+V2WEHsXr/YdchRNZ2bEMNFCy2QVF8=;
	b=cSE63hmZvUtxIPzGulBI59E/ucgjXGh9JW5WtkN/D00yNaG2g0zK5/SbUWqAx0InwI6fQt
	rqFEqt8rFhpb2UjsLoNvLihZNtWlxPzpPZp5roE6D3+dUqRwSKUpBnKWE5S6RImF28PGOg
	5nKz9zbASpAtS2WYDpm1Jq7fjfMMeLg=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=hZ5W+eNM;
	spf=pass (imf18.hostedemail.com: domain of agarwal.vineet2006@gmail.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=agarwal.vineet2006@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777369459; a=rsa-sha256;
	cv=none;
	b=D97Oy3Ycpego3wj0SeQKgUZJeb0pwKFcxNxeOgArC/RigqEEbiNk6k/U7rmzWA1sN4Hes+
	0Y4251Bq0XGh6eusrTiHmbGB2VtwBdtMZELeDxuukyipK1/MOL8dTRCr1IL8VQSYXtihCr
	KbsPYl3bLTEJUp6ybXTCGGD9GG7wtDY=
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-2b788a98557so56676725ad.2
        for <linux-mm@kvack.org>; Tue, 28 Apr 2026 02:44:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777369458; x=1777974258; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=C0tY05QQvlWHs+V2WEHsXr/YdchRNZ2bEMNFCy2QVF8=;
        b=hZ5W+eNMObtkW/y9DMwP+F+RX0BU4lL/iydtGxHxJ373ApMgcjZRHL+FWfVaxfL2s2
         ohYmvDjXrYq2oUZWRMFVek5n4lNdjpx8+erVNMg1rhskhJ6oQV/QJjX/p7c1Fj9Y8RvE
         +8h6qhjBdM9pHUoBKNeVi1w6rpzxxz++MFOme5WLwaVDKkTaDoBeedQqaHUyW2bYlqwE
         KuWR/mBDYuWPTXe+y0YK+PFkaQ4DN9EdJ3Lg7HgyWbiem6rd6+yrqtXWj7VHwlr3glSm
         /lylNJ2bXA84olRAzToAqlpu6P11B9mB20NKUpqH0JNwrxqlvHsZkKjREdIh9oum7GmY
         RAbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777369458; x=1777974258;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=C0tY05QQvlWHs+V2WEHsXr/YdchRNZ2bEMNFCy2QVF8=;
        b=r7VfvOWssOd1xSyyp5KkUWYeIgGPHwYtp6vA8WZcUje1MfTplqT15Xm1c/G5NtDy7M
         zsZnBV4efuCXDwg/fsst44gk32M0z0V3M44WmE19NRiSBW+uk7yuQXS8768oHX0kr0ph
         mf+9xTmY4LRUadMNo9KMdXD4pRbjzjVJeiskKehK2u2cXzqGvr/spE1/x95ZMyksjtaj
         KhKpEKcsAYTIX+YuEWJ5M4lfXrgnAvo9AfnphdgLLJ/kppjOQ7kLFnC9tq5iUI0b3XZx
         KM2SlAEKO6fqnVSVek3dR+TMHEH4CWa0xcSgMRCV5SrsFsdB7dxxiWygy3Z/HgWsW7VK
         rHFg==
X-Gm-Message-State: AOJu0YxJ/IA+gYBd9j6wPt8XEwnk5MerCdx07g9SPjYBvGCSkUQ92yrp
	g8K/bsGdI0lbQGVEv1qruAsUQnncXVMIqxoFIb1dB+mcQRb+J1po2hd1
X-Gm-Gg: AeBDiesT71MmUL5fjZjG7kAmuP0ko+yT/9okbocI9StxFU9ugg27lUUu0oAEPf/00BU
	KfD3DFq3G6IytwPV4QXpd865XpdtvZ3L+eq1I2vJKVjpxoBjQ3c6WkpSc4DtYdrenO3fnL+p9Fx
	CxqnRbRZd6yIYXMXXAoXIJ7B0Sk81x8xIe84aUq+Pqw1A84ycPSjl7UbTHCkJg+GwZrCg82Waln
	Z5hAlXe52jxLjOwGqYRuyeODLs552bHjDChR1pStrTUVPjJoEBWI2y7ld79xIjkrz7+RlOIp66N
	mqYF72SJpRjU78OrGTGgqz1rcPwJTKqtMbBIK/YdUePuMY6tyjKwnCjO++quMWsAE6nL8AYJpIS
	KETZYfzrTR1C5VBYmTYq0/vPD7csUBRWTTXvFWu8sjHsX05wrw8NU2m6ZJaNG9ugUDcb1bztFnv
	+j0oioTQT1JT6/eTOpneHkKS3+bJwb3shP5OI+x363
X-Received: by 2002:a17:903:c48:b0:2b0:b41e:c5c3 with SMTP id d9443c01a7336-2b97c47b448mr18768865ad.29.1777369457950;
        Tue, 28 Apr 2026 02:44:17 -0700 (PDT)
Received: from vini ([2401:4900:8fca:e7b6:f223:6319:a79e:7616])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b97aa9f410sm20403125ad.25.2026.04.28.02.44.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Apr 2026 02:44:17 -0700 (PDT)
From: Vineet Agarwal <agarwal.vineet2006@gmail.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	shuah@kernel.org
Cc: linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Vineet Agarwal <agarwal.vineet2006@gmail.com>
Subject: [PATCH v2] selftests/mm: khugepaged: initialize file contents via mmap
Date: Tue, 28 Apr 2026 15:13:56 +0530
Message-ID: <20260428094356.60415-1-agarwal.vineet2006@gmail.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <3abf09d8-a98e-4f1b-b8d9-77879a8a2733@kernel.org>
References: <3abf09d8-a98e-4f1b-b8d9-77879a8a2733@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 4AD2C1C0007
X-Stat-Signature: mdxdp9oc1uk1yqa1qfshxwcpudhz9fi7
X-HE-Tag: 1777369459-675670
X-HE-Meta: U2FsdGVkX18vHPJ1rCtEIrG/4okk2+IlkHS2GU2xFB5bG0oGpLLeTjlwawXJPDxiD5ekA0cdw2jtvggsVWxLgCg8RAkmml4zHrZz+pjONASe0ADdG2It5oHw0CQben+50dwmg+STIxv/Oi9g8S5Elv60x+YBfWHoyiYo1gUTc9uGtohyrZrBQhF8kkABHNvu3478u6qQgEnC1ddRosIjt7C7lKU9r2txlKCzzSLwkL2zQPCBd4HszJ6XcjLvPIbH+N27NPl2nRmXyV1PdimbeJHXFUxgUbVo1nsrMlrO5h1WcqMNX3ePatO71qk52g9ifuCtRoFcNdR0Uxx02P43y8M/kJLloTgWJxMvr49WsGzf9efw0XQjfEisetTYHGqWe+T9KeQ2fZxI/Q/oT9Plp3+IDti1smxLYTA6PcreA3wmhqq5HCnRQzaIcl8oCZSLL/eFfNIkkSxCgLLczRpqlyKydjMo/huXkxn3Jr8SulzB2JVZL5fHIA9HBtB+gjWl6e4cWUaLwUooT4MYF82TiiXCPkKt0o7pjgUZt84SPdLaNf8LpbnR1mbV3mmqWUn0efimO7Nm/gzApX9bXK/aytdyv/W5BFUASwB+blRgUzc+Rt/JcfMlFNcshbWwNOVPipJmaWOT0OQswb9FWZEMloRAn3pdyORCbuKf1sIPCYa62wjT9VxyeW1wI/EQZ6D0mWbj7MOl9f3NG+7PSGEiVWIR1TyPPenAXkmRSfeiIBKGjOTGIkvPkKSyXAib7fzLXHEcJpOm5zzOyIfhlRSQZV/qzHtMea4kjnnpH4AEJfYAfEbR6URYKl78NiKSyrT1Y6/k9Br4Z0Z6IVEzRXAmdmzS+Z4wZfyB+baZMzOzzcZoCWh5bXneRVB+VLyqjslnA2s5y158FSh66zw5apnsW9vAbdi8TWMRFyZpGqusIXXNwqzFoo4Vms3qwCAAWgk8TK97/XoCx5bKI2Y8kwh
 61IyhgsQ
 /SC6N1C66j/X8BbJK3ytN+X8jIuDbdPm70VaizAesBMWHFIdOZy32n/4Qa17FNZer/NYribHoLPU0+3oowG2sdmG+POfb+8KJUakhZtHeBKkoD0qYO4XDrI5xCgzqI1u0RfI6sbpF5UOqvrOS+9SIb46IV/YjozT2FbM1pptgetfVE3VegHw4vz6w9cAplpKzSR11bIdYkLH25y2gXMTb+EcXZV9Vwp5Lf7CvQOwbPq+/3y3BfsGrrjDgRJGKaxZfWxw7eZKro5N3UcURrmQJ5HTrbzuiY0aDReY3IBZCSu1GjwBB903cN6TlNrRgOmZNM845gnKQ0XVe9W63UpsthASDF0hZaqz/V/q0A6adQF/J3k34UUhG/X0tVE94R6iqLYTBOihLqvzscnT9an6CLnWMQ/Twb2C0Dhb+dPXk2YqlWYciebsz5+Pu+huMJKj5M7WapBDxMT9KOjrkR5efRF7wpQa4tO3Hp57UVpcyHoJcgCJNjDBK+D5C6U+EIAWCUAuF1Wx8eLQxVRKHG0mRGI9bKZf96K1p2FLyGaN0uJacQjM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

file_setup_area() currently allocates anonymous memory, fills it,
and writes it into the backing file used for collapse testing.

Instead of copying data through write(), map the file directly with
MAP_SHARED after resizing it with ftruncate(), initialize the mapped
area in place, and sync it with msync().

This simplifies the setup path and avoids the need for explicit
partial write handling.

Signed-off-by: Vineet Agarwal <agarwal.vineet2006@gmail.com>
---
 tools/testing/selftests/mm/khugepaged.c | 25 +++++++++++++++++++++----
 1 file changed, 21 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/mm/khugepaged.c b/tools/testing/selftests/mm/khugepaged.c
index 3fe7ef04ac62..f6e171e1da4f 100644
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
@@ -381,11 +380,29 @@ static void *file_setup_area(int nr_hpages)
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
+
+	if (msync(p, size, MS_SYNC)) {
+		perror("msync()");
+		munmap(p, size);
+		close(fd);
+		exit(EXIT_FAILURE);
+	}
+
 	munmap(p, size);
+	close(fd);
 	success("OK");
 
 	printf("Opening %s read only for collapse...", finfo.path);
-- 
2.54.0


