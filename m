Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3F5AFC5B572
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 06:20:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 122E96B091A; Mon, 17 Aug 2026 02:20:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0D3A46B091B; Mon, 17 Aug 2026 02:20:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F2BC76B091C; Mon, 17 Aug 2026 02:20:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id CFAD46B091A
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 02:20:20 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 365B4C05DB
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 06:20:20 +0000 (UTC)
X-FDA: 85109761800.17.72D1CDE
Received: from mta0.migadu.com (out-13.mta0.migadu.com [91.218.175.13])
	by imf29.hostedemail.com (Postfix) with ESMTP id 0CD10120002
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 06:20:17 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ZtJjXG26;
	spf=pass (imf29.hostedemail.com: domain of hongfu.li@linux.dev designates 91.218.175.13 as permitted sender) smtp.mailfrom=hongfu.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786947618;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=+cJ6nRy02XdT7ao8SlW5vxrHYuGfqpb5ny+ypgftDbI=;
	b=X8n0L5lvUEd+EukTDvfd+10sODQfqN8wvnvuraUUzut11aUfKZD6IpYQ4VVnYnVXb0G6Ce
	31FsdH6LRApuAXFq1/nP4eAyz7ODLjkMYHqFJeutyvD3ixy/zzdVLV7ozO5PhcUO4KQmla
	G5amJFP2rtyNqRZQo/vGto6aBkS8keY=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ZtJjXG26;
	spf=pass (imf29.hostedemail.com: domain of hongfu.li@linux.dev designates 91.218.175.13 as permitted sender) smtp.mailfrom=hongfu.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786947618;
	b=MOMyFfX+/Cx26dvacsAIscqfweiaiOWMAZUXnnDxQ3GGzAnHJp/WVNodoMg4EiyvRFhSOx
	4JwlBE5sJSXit85gVrClMbIo5cNt7eHDkLUUAWJFCtHwa6RHbC/QD3rZzNoW/iiWA9g42u
	wg6Imye7ppx5CnQohVuEG7fOOEvSth4=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=k9Hg/Aix5bXOJ45/B31jl2pbqakUepn4Yh5kPod+wDU=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1786947616; v=1; x=1787552416;
 b=ZtJjXG26sMGVVKzxdBbJ8fIRgU3DCIobVeH8X8eRtvAr3xs+6Qcc7/0UNUEEGrUDB+INpLc8
 dfw1a55WGONBVbXZIikXTWcgFVc5ZyyX2BdOA4B4jfzF+9BkxXFb1KSGpoflcjlgee6aq1R1i+E
 wJCByBwYF43J/+WgSsUQCYI8=
X-Envelope-To: linux-mm@kvack.org
Received: from localhost.localdomain (223.70.159.239)
	by smtp.migadu.com with ESMTPS id 5bb4235a9e59466b;
	Mon, 17 Aug 2026 06:20:16 +0000
X-Migadu-Flow: FLOW_OUT
From: Hongfu Li <hongfu.li@linux.dev>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	liam@infradead.org,
	nico.pache@linux.dev,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	usama.arif@linux.dev,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	shuah@kernel.org
Cc: linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	hongfu.li@linux.dev,
	Hongfu Li <lihongfu@kylinos.cn>
Subject: [PATCH] selftests/mm: khugepaged: consolidate error exits via kselftest helpers
Date: Mon, 17 Aug 2026 14:19:55 +0800
Message-ID: <20260817061955.45454-1-hongfu.li@linux.dev>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 0CD10120002
X-Stat-Signature: j73unhzcjds4k3axshmu1dcdrr38678z
X-Rspam-User: 
X-HE-Tag: 1786947617-600655
X-HE-Meta: U2FsdGVkX1/r8o9WIvKH0xtN4+5DtK8Mn5ARUb7C+yM4J8MspDqdR/tDiGK5Wi/+Hr3IOAyQwXn/MT/Woj+fgeHDLFV1qyGJXrcjmm4/r27S7ukwvG7CDcLktzcDFgIhX7oLrkolZwaDgm3rN1BREfhtvcnQy+N3jXNMxrjVoQczt2478djE4Ke7PnvXelI+nWUqvHjg2DTEdAGjndA2TYIhh80LLT+yCnTKZ3P7/EbJZC99xXXqEWB9JACuNg6j4TNGU3i7N2VqQJrWGdDEGd5KlpH2qLzZYZukfv0Lwklki/ZhRXSPEoqvP5FeYgDMcMrgxuZK7o0MMenMzHDbL1lSeykh14tgq6NTDfTaxbO3/ClRwcs6EgCjiXx+c1RY/D0W8qkB7MFw0+/CTEgrESNPLb1ZfqAMVRFVM2IU14naZdU2rT0XZ2uEtAEl4RkGdFKzyW3E4r1pSbdbxXs9gpD1UgqO9fXOLBHalmMn8DIEHyQNayett3ebedHU13uLIJP3x2mMSnamT4HRcCPtRh3Q9mmJB0wz9JWh9tJTsUM6p5yZVKZ66tLpwv2w2QoJ2kd2CCGxH5o2AVb7KfwMJiLbKvxPeIRUSCvp3CpV2WNbxVhBZW9DuPz0gCrKL9ED14ynPYFaFQBjyinvDEqF5TDZ05Mc1gDIl/wE1V58JNXiBVyMCY3PI50bBdBzPW60Q1632sJ4omErVLH7UTZF8W0j4DiRbuSb/6MYn4/7njl8ECkIORGGG789c16ukcwPJ7NvNFBWDcOB4mxPxRA6+Ejmqp9ezy6giQhYJUKh0nVBZouJ/sqiUUnMPKbYLrjr5e2iXmon11Hqx1IWykrUIqiS7Z+C5gaAOY4/5LyPJOAuU8y8utbQFvxuTXST/DAEBtzobLAE4++T7hbwmRO3Quf9a9HFgjoJGdieFuNhGBXVvqcH9uZ+M/WypbdBQkTm1WSPIamRqQOEQQoG3IS
 cy2gHgxo
 rz2tWuNt9ZGLGUM4YC/pPgGPCjOpyHv4sCtYVYYvEtxS4hSPa18zkSJhbOU9A/dp6Ae5QfSis1shhkFAzaYF5dClrSFQpxub+R9wem16kYHMCoukFBTSkD+zqMVY6L6KuQPZwiW5pRWAs5MLtzAwSsqCj4Qlq0fya9ytAtLwcgrezJfc5Bb6868re/FBWuhRBJdFjM3tT+PmMw8Il2oSd6DCK3vI85+rNDuAK
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Hongfu Li <lihongfu@kylinos.cn>

Replace the perror()+exit(EXIT_FAILURE) pattern with
ksft_exit_fail_perror() so failures are reported through the
kselftest framework, consistent with the rest of the file.

Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>
---
 tools/testing/selftests/mm/khugepaged.c | 20 +++++++-------------
 1 file changed, 7 insertions(+), 13 deletions(-)

diff --git a/tools/testing/selftests/mm/khugepaged.c b/tools/testing/selftests/mm/khugepaged.c
index 0d6c71ed2fae..8d1b87f2195c 100644
--- a/tools/testing/selftests/mm/khugepaged.c
+++ b/tools/testing/selftests/mm/khugepaged.c
@@ -358,21 +358,15 @@ static void *file_setup_area_common(int nr_hpages, enum file_setup_ops setup)
 		ksft_exit_fail_perror("open()");
 
 	size = nr_hpages * hpage_pmd_size;
-	if (ftruncate(fd, size)) {
-		perror("ftruncate()");
-		exit(EXIT_FAILURE);
-	}
+	if (ftruncate(fd, size))
+		ksft_exit_fail_perror("ftruncate()");
 	p = mmap(BASE_ADDR, size, PROT_READ | PROT_WRITE,
 		MAP_SHARED, fd, 0);
-	if (p != BASE_ADDR) {
-		perror("mmap()");
-		exit(EXIT_FAILURE);
-	}
+	if (p != BASE_ADDR)
+		ksft_exit_fail_perror("mmap()");
 	fill_memory(p, 0, size);
-	if (msync(p, size, MS_SYNC)) {
-		perror("msync()");
-		exit(EXIT_FAILURE);
-	}
+	if (msync(p, size, MS_SYNC))
+		ksft_exit_fail_perror("msync()");
 	close(fd);
 	munmap(p, size);
 	success("OK");
@@ -447,7 +441,7 @@ static bool file_check_huge(void *addr, size_t len, int nr_hpages,
 	case VMA_SHMEM:
 		return check_huge_shmem(addr, len, nr_hpages, hpage_size);
 	default:
-		exit(EXIT_FAILURE);
+		ksft_exit_fail_msg("Unknown VMA type\n");
 		return false;
 	}
 }
-- 
2.54.0


