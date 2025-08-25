Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B24D8CA0FE7
	for <linux-mm@archiver.kernel.org>; Mon, 25 Aug 2025 14:58:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 03CDD8E003C; Mon, 25 Aug 2025 10:58:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 015038E0038; Mon, 25 Aug 2025 10:58:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E942A8E003C; Mon, 25 Aug 2025 10:58:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D8B248E0038
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 10:58:22 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 96CDE8403B
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 14:58:22 +0000 (UTC)
X-FDA: 83815585644.30.528D28D
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	by imf09.hostedemail.com (Postfix) with ESMTP id B579E14000C
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 14:58:20 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=J9QnIYlU;
	spf=pass (imf09.hostedemail.com: domain of linyongting@bytedance.com designates 209.85.210.172 as permitted sender) smtp.mailfrom=linyongting@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756133900; a=rsa-sha256;
	cv=none;
	b=4CObfrM7YbyI3jgEtIs5pimilXuim6r1n3snPoodgqCUOAGU03NgRL4uHS3ZJno0ix8Gjn
	4tDHxyCgLiBzuEjAQh0eK3hV83xqy9M9nRaKwVC0PBFjArIl6DY7n1cQbmJ6n0VX3yKir3
	c+f1RAKJGU5fUoYrjmee+oMU+bzg3k4=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=J9QnIYlU;
	spf=pass (imf09.hostedemail.com: domain of linyongting@bytedance.com designates 209.85.210.172 as permitted sender) smtp.mailfrom=linyongting@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756133900;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=S4tDabwrjUnjyF2pNuKY+D/uJFltgF7p2tl2gzeMXdU=;
	b=Ft387JULkkjuucKGqoyVeVqsfbkYgcmXzrqjBzWAPUA2KRpLSmbmNJIH5SQXA+42EjgrM6
	PQpNsoDp1V9sRPQuvSvunOlTV0m4WJnzH4vFxPQMHYi1lFbG7FTNxbyR/+9cEwLR3Uy1uf
	sT21MOIjvJ+T1MnaDYMprzybKZlE+wg=
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-77031d4638bso2500140b3a.1
        for <linux-mm@kvack.org>; Mon, 25 Aug 2025 07:58:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1756133900; x=1756738700; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=S4tDabwrjUnjyF2pNuKY+D/uJFltgF7p2tl2gzeMXdU=;
        b=J9QnIYlUnxm83bpyG+BXLrKqSZ1ugT7cuFjTJ6/EQE0AwGVOhgevlbSKe6VIg/RIct
         6iwrDbuJNrsdRhhI0VEwv9xskqeVjS95t1ewNFuq9aKRM0ERMeDfXgHcxg668NPfSSfn
         AExERiV55L4oPxFrHa7tzf9jdPMvtJMQWCQa5ZTBCgX5sQnDyCLfIKbHtP5479ahEktO
         S3VKS6TMqmxyCDrUfpLZkj+9c9LxvOWwLyN9B054a8at0qBViIoLGzQKTYFwwoMmx6zu
         TKvcAmKI94wTUyC8i8+GSK+MQ1MAbwdTqmZGy5dEbymvL+J9Hk5kzitQojm8/MdsIEBg
         g4EA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756133900; x=1756738700;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=S4tDabwrjUnjyF2pNuKY+D/uJFltgF7p2tl2gzeMXdU=;
        b=Zo3OLrLY6O/x4XOo+TphQzcDlGGpuTbndgluTejXY4k7Ta0q4KEDnfma3n83PBoCEb
         GtHnBgOoxekfzw7z+JsIsg4mx9q/kERGJlZmtMIT2oe7St+kg/ld5Y9dejGBtBu5hWqX
         +uDEAbtDj53ius78ECZrOF6aqO/996e+6war4+gU2swbUMma84ejSHgPHB2atoET4Y3o
         vq32clfOiGtbWFTjvI3TWGUEUriwTbRv1OkBcrpHDxRT493/iahJOBR90ewvgcd3V+DF
         MGDAkGPAoVs65YeErNsWgo9cUGyWADr/5K2VrXnyhudHeYHRvxv9Ez0XnVL0HDC2QtXT
         W+7g==
X-Forwarded-Encrypted: i=1; AJvYcCXtQTKDoXgcBCoC43d0Au8rOYiDMNRIPpPS6vUYEkr685yrZpeKIZ/HzHcEYrgCmP9iBpyFW1spEA==@kvack.org
X-Gm-Message-State: AOJu0YwvAI2VxbwJIxc3sclpkr1feZZ6fl3abqwzLT3GetRHoIYc4MSl
	G7TZBvJdrG5mxFnsG/CaMLV3gsU3Ooew2rrr+eFtXstHGCXeC920Ij4meXtwI0QJlgr9MNsfWKc
	TEPmuIvc=
X-Gm-Gg: ASbGncskFrOToFpTxtW4dIB+6RdiCTwzIVGFE0/81ZsqKJUueI3Nh150OQrXSGa49zc
	OB/B/4ypuJQvKOcMmNfnT19eR2/CkV7Fy0yIYKmxO9/NsbfXjeY9XF7mpuDgMyble+1DsAOdfLt
	gofchqEMh7rKKNeo/WD5IWcaPURAS7HavmPkxjUftwWGlOopjaX3XFF5b1tTwScTBCAEuopC2pQ
	3X2wxFyqAiNLkTGhggogAzQI3BLA2jTHhSE/HNXNiwcB9vPmZ/QEE8uwI0FSqSgGK7IfIQ/d3oy
	ewWsbyTLzKqNDY8x9ztq7eKhD2Bgdz6QWyvIiPldkY+SFPi2k6eEkgCMWlxnm5Ds1GkecTn1AHQ
	3zTtjyOI5zlYuliXmnfPSC4nAUFmKBkQTUp1zQvy97rpGjvl5d8EPEHKmxUUO
X-Google-Smtp-Source: AGHT+IE4HBpFp2FjPR/VhGO77A7Hf4iGpyorA58tgjMrbJX3zjiUolWr1Fp2pgViqY8L4woXW+eoFw==
X-Received: by 2002:a05:6a20:7345:b0:240:195a:8333 with SMTP id adf61e73a8af0-24340bff9bfmr20854855637.14.1756133899572;
        Mon, 25 Aug 2025 07:58:19 -0700 (PDT)
Received: from H3DJ4YJ04F.bytedance.net ([203.208.189.7])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-770401b190asm7803436b3a.74.2025.08.25.07.58.16
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 25 Aug 2025 07:58:19 -0700 (PDT)
From: Yongting Lin <linyongting@bytedance.com>
To: anthony.yznaga@oracle.com,
	khalid@kernel.org,
	shuah@kernel.org,
	linyongting@bytedance.com
Cc: linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	akpm@linux-foundation.org,
	linux-mm@kvack.org
Subject: [PATCH 5/8] mshare: selftests: Add test case ioctl unmap
Date: Mon, 25 Aug 2025 22:57:16 +0800
Message-Id: <20250825145719.29455-14-linyongting@bytedance.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
In-Reply-To: <20250825145719.29455-1-linyongting@bytedance.com>
References: <20250825145719.29455-1-linyongting@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: B579E14000C
X-Stat-Signature: hzw4ft5cmkgz1p9i5yajzw6k1n64gxyt
X-Rspam-User: 
X-HE-Tag: 1756133900-999777
X-HE-Meta: U2FsdGVkX1/Lc4j/x09E8wDWcpKiMJns/9glPlMrS4sAtbHKuQ5vTF+vh0b3crWv4HVuVRWyVRw46DDnTfH0nazTSJCy32koE+QBEPYQ5vVZCgKHP0W0UxgupM6V7eRJzCPnOD+ET2lZqocwzv61ZT1TXtA8ILaemQ+ys+opBlbBs0xpRCcbK3czXTWdCbKIR2zFqgw3bqYVWfUO2vbHb2uA6uT2a7PhvmWeHROjCIfHKoKa8zGIcEkoeKbSmOy3iQ+bBMa3QMRmCjMQUlln1rMAPMHy8vEh8H56p5M9IrMc24cl1JTt3XC42fLz0jMMGnJjZGQm9ko0fvGhN3rP/f69oBTlWYCtDpIrnYVv7lrtybERi+2KwILkJcuy/Du+t0cls+g/CmW5FkPBUsM64BY792LUWXIk+gEms8Za58lHKIQkfKyxMHPSrHtO/vVxZH+XT4yFfcVxoFB/Q3lE0LI9QNqfwpf2wHU5o9pOqf55jp/4XbZmc3hSiPWcv9OB3bI18Uz9YNCFjpBFPbSLZKI/QKCuYdE0d+JFq2Sinv4fxB9s3lP8BRi3hm5fRANoXKLf+bW2gttvQkObwYPpljoD1ry7IASfs76ne/v2vH8dyR0uj/UUfI/nEHiyK8KEaFgzAfIlevwv3ZZVgAWL5oBio3nxl1VFQImsUkgeXVofyZCbYW2crvRdmNBwdktsKHpul7+OcLHpxMiiDhjan/Yr4LA3ESE/m9TqfIbLTRdKSm7II8HR5uZpTcSo0lB3RnO6nqqXwUvnSX2rBqwIasxdESvjZsTzLIubk9u87cdjFb1imlqFKu27kHKZdruVXlU0oMp+ErOIstAxkMpCUhfySQ/KMjPODUuHk7NQSIcIkQl3tHIBF/eBr2FHURSVSmyja3ejyYZvTtyN7Gu3trnGgB4EUwQ0kqRTIA+g+YRL1sLwvY77F/AaSr8SvINPwOtsAF/uJw8ZG4/YP1X
 0RdUvXC1
 KQEEU1mbPGJ2Bu6HJoUSetwCSPii+e265xY/cXWHugLfw9OqR3hOsLT3DoFTsv9PELMOkIUOBxa/xgi72MJQmQfOQcVcSR9KxmU/PsNcmv8xkGOBja+Wzgse0DP0r1lN+doBmMQiVxlcqX3Oin1tw+S5PN3QSik7tyhybKjhHoQLIX24JlSle8MKbXX8tCBmzgoTxsFghR53GRfbJmW5IwOCt3ojf2PJZeQ5HAh1nQV3FvkHTH1a17fhINa23wWNj3fcEcFQdIDUSNATfro176FvbSGLCBZVv0EQPCv6MTpdwDFXJ2S3dsOaC3g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This test case aims to verify whether the process with guest mm will
segfault when VMA of host mm is unmaped via ioctl(MSHAREFS_UNMAP).

Signed-off-by: Yongting Lin <linyongting@bytedance.com>
---
 tools/testing/selftests/mshare/basic.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/tools/testing/selftests/mshare/basic.c b/tools/testing/selftests/mshare/basic.c
index 2347d30adfee..16d1f63c3ebe 100644
--- a/tools/testing/selftests/mshare/basic.c
+++ b/tools/testing/selftests/mshare/basic.c
@@ -85,4 +85,24 @@ TEST_F(basic, shared_mem)
 	ASSERT_EQ(memcmp(addr, STRING, sizeof(STRING)), 0);
 }
 
+TEST_F_SIGNAL(basic, ioctl_unmap, SIGSEGV)
+{
+	char *addr;
+	int fd;
+
+	fd = open(self->filename, O_RDWR, 0600);
+	addr = mmap(NULL, self->allocate_size, PROT_READ | PROT_WRITE,
+			MAP_SHARED, fd, 0);
+	ASSERT_NE(addr, MAP_FAILED);
+	addr[0] = 'M';
+
+	/* munmap vma for host mm */
+	mshare_ioctl_munmap(fd, self->allocate_size);
+	/*
+	 * Will generate SIGSEGV signal as ioctl has already cleaned
+	 * shared page table
+	 */
+	addr[0] = 'D';
+}
+
 TEST_HARNESS_MAIN
-- 
2.20.1


