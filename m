Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EB16DCD343F
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 02:52:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4A0DB6B0092; Tue, 12 May 2026 22:52:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4513D6B0093; Tue, 12 May 2026 22:52:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 340A06B0095; Tue, 12 May 2026 22:52:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 222F66B0092
	for <linux-mm@kvack.org>; Tue, 12 May 2026 22:52:08 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B0C531C0541
	for <linux-mm@kvack.org>; Wed, 13 May 2026 02:52:07 +0000 (UTC)
X-FDA: 84760872294.21.B0ECDE7
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf28.hostedemail.com (Postfix) with ESMTP id 9DC04C0002
	for <linux-mm@kvack.org>; Wed, 13 May 2026 02:52:04 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	spf=pass (imf28.hostedemail.com: domain of lihongfu@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lihongfu@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778640725;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=f6h7p1fOrvqWScgAydF53cBERC249L1mZ/1pk9f5oPE=;
	b=fMAS48d0TcjaBeQcnDVGSsdXgFl8Jd8kkzrC9QIAgOFhE9DT4KBXpeC3LjRmCdbZ8bwzCL
	vZ7fORY29w3E9fn2b6642EwEyt/T3TSW4z/xTk8j0Tj4Iofi/6RWQmmeNnBFCXRM9GkOFQ
	jRn76ptRy24V1h111I09vQ6pn8IprE0=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=none;
	spf=pass (imf28.hostedemail.com: domain of lihongfu@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lihongfu@kylinos.cn;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778640725; a=rsa-sha256;
	cv=none;
	b=shcWLN18ZqYrM24F7sE0+eMbGEy3imFDCBaf5VenntM754JbXurp7K8pxcJVmEB54wRTfV
	NzCNgoKFIu+CEN2pUJCQ3ODg2oAu4e+X5jbLBqQ90teRhzrt8+ceQs6x5BqfLikZx3vdJQ
	62Z4jxQyeUbc5e+/sTUhYReKLbIn0KU=
X-UUID: b501b84c4e7611f1aa26b74ffac11d73-20260513
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NAME, HR_CC_NO_NAME, HR_CTE_8B
	HR_CTT_MISS, HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME
	HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM, HR_SJ_PHRASE
	HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT, HR_TO_NO_NAME
	IP_TRUSTED, SRC_TRUSTED, DN_TRUSTED, SA_TRUSTED, SA_EXISTED
	SN_TRUSTED, SN_EXISTED, SPF_NOPASS, DKIM_NOPASS, DMARC_NOPASS
	CIE_GOOD, CIE_GOOD_SPF, GTI_FG_BS, GTI_RG_INFO, GTI_C_BU
	AMN_GOOD, ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:3893ce71-eea7-4218-96bc-e0da04ff880c,IP:10,
	URL:0,TC:0,Content:0,EDM:0,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:5
X-CID-INFO: VERSION:1.3.12,REQID:3893ce71-eea7-4218-96bc-e0da04ff880c,IP:10,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:5
X-CID-META: VersionHash:e7bac3a,CLOUDID:0bf957cb8a3a83ac8a9446aead074fd4,BulkI
	D:2605131051584BNAGW4A,BulkQuantity:0,Recheck:0,SF:17|19|38|66|78|102|127|
	850|898,TC:nil,Content:0|15|50,EDM:-3,IP:-2,URL:0,File:nil,RT:nil,Bulk:nil
	,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:
	0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: b501b84c4e7611f1aa26b74ffac11d73-20260513
X-User: lihongfu@kylinos.cn
Received: from localhost.localdomain [(223.70.159.239)] by mailgw.kylinos.cn
	(envelope-from <lihongfu@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 806173697; Wed, 13 May 2026 10:51:57 +0800
From: Hongfu Li <lihongfu@kylinos.cn>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	shuah@kernel.org
Cc: linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Hongfu Li <lihongfu@kylinos.cn>
Subject: [PATCH] selftests/mm: Fix incorrect mmap() error handling with NULL instead of MAP_FAILED
Date: Wed, 13 May 2026 10:52:23 +0800
Message-Id: <20260513025223.592766-1-lihongfu@kylinos.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 9DC04C0002
X-Rspamd-Server: rspam06
X-Stat-Signature: omp45pn34cprkso9kbkpa8apnwqpqcmw
X-HE-Tag: 1778640724-355447
X-HE-Meta: U2FsdGVkX1+/EwMPYc1oxNsVtxx1V/Jy7/OLYcOP6dRTF9oRFAM5FxOzzjHbWCnRqU3YEAYOMMVHgQM+4BJG16wGZa5OfnckXMX4m2oAmCinWq49xIHXZZ3jnQumpVmeB51//6J822fbh2SzMNpIcY1PjTbXH5FopbN7OlCotqjvXkZVt3PduZaZAkfKkSDyY8pe6VIaoLZ12+PNzyiTQ9E8AAeP0FErlYE01t9mgMFi58K0HozYKiALs6AdL+QENx8gKzxWL1djUtuVexDLGMYcUzXWSyGxFkbJBNUcxqRUmqx5zuDVwtRhEZHGImMTqagLHHC9eGaKK4JxV9sBbBd1D2Py48Cc+kRK+C5VsJMPEmGnxvMf1o39PfEWL3VDoSD0Ani7cWsLlVV1a/uzpTvbOhtJ4yCoOKoS/bEp2vfxbQCoC2ibETze1+dJ/J1wg/jcMmbZw1H8cW8fu9BRMPjcynniHdcmSknIPXknxseSxoLXSPa+oFU6s9ljIpcxxZxCuwmBcuLJ7hkD3DB4ii84AtG7BEQOGaNEPXm1SeiZTXOYw7iYGjJx2QJAyN8QVw7NQa3dnZT2ZSGa/fAS14MM9orIe4eY+w7rEP5AYeW6zGEh44J5P27HoOtjaiZERJt/TlSw0jZEooB8zIY/4uUwBEAfidj2t7WIRxz+dSki4fLrknWCj2aXonqHotXGf0XVHCfaCIrUUIJXud73//2qtjkD/LREzBH3hP8m0jRMl5v8FOXwnaYBf3xY0e/VplVKLf1RviTFnYy1+YWuK/SLjbjPQGQzud+mCTi6+6cj+hkAyWZj8KmUKheVPtlUYfGk+PYieEoZYWV74Gvx58LMbS6ndYBHbNfY35r9jwGCitNAfbs6OlMXPW9D9q74dGV1o2tU8WCGjmlmbio+ZAqZQnc0P6c+ootLq57/EKL4OdNM8GQt/lSsXpN56wvI7NX6S3D1hiePgxBf4NQ
 y7nEJoAt
 EacwdzAdeo/cTaL5AtIq2/jtsyny0FNDL/kxDQ6jR1vUkFU4UPkvEkSRvMQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

mmap() returns MAP_FAILED, which is defined as (void *)-1, on error,
not NULL.  Several selftests incorrectly check the return value of
mmap() using !ptr or ptr == NULL, which would erroneously treat
MAP_FAILED as a valid pointer since MAP_FAILED is non-zero and
non-NULL.  This can lead to segfaults when mmap() actually fails
under memory pressure.

Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>
---
 tools/testing/selftests/mm/ksm_tests.c     | 2 +-
 tools/testing/selftests/mm/madv_populate.c | 2 +-
 tools/testing/selftests/mm/soft-dirty.c    | 4 ++--
 tools/testing/selftests/mm/vm_util.c       | 2 +-
 4 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/mm/ksm_tests.c b/tools/testing/selftests/mm/ksm_tests.c
index a0b48b839d54..ed481f817282 100644
--- a/tools/testing/selftests/mm/ksm_tests.c
+++ b/tools/testing/selftests/mm/ksm_tests.c
@@ -174,7 +174,7 @@ static void  *allocate_memory(void *ptr, int prot, int mapping, char data, size_
 {
 	void *map_ptr = mmap(ptr, map_size, PROT_WRITE, mapping, -1, 0);
 
-	if (!map_ptr) {
+	if (map_ptr == MAP_FAILED) {
 		perror("mmap");
 		return NULL;
 	}
diff --git a/tools/testing/selftests/mm/madv_populate.c b/tools/testing/selftests/mm/madv_populate.c
index 88050e0f829a..7fce5d0b622b 100644
--- a/tools/testing/selftests/mm/madv_populate.c
+++ b/tools/testing/selftests/mm/madv_populate.c
@@ -34,7 +34,7 @@ static void sense_support(void)
 
 	addr = mmap(0, pagesize, PROT_READ | PROT_WRITE,
 		    MAP_ANONYMOUS | MAP_PRIVATE, 0, 0);
-	if (!addr)
+	if (addr == MAP_FAILED)
 		ksft_exit_fail_msg("mmap failed\n");
 
 	ret = madvise(addr, pagesize, MADV_POPULATE_READ);
diff --git a/tools/testing/selftests/mm/soft-dirty.c b/tools/testing/selftests/mm/soft-dirty.c
index bcfcac99b436..67c26c265880 100644
--- a/tools/testing/selftests/mm/soft-dirty.c
+++ b/tools/testing/selftests/mm/soft-dirty.c
@@ -143,7 +143,7 @@ static void test_mprotect(int pagemap_fd, int pagesize, bool anon)
 	if (anon) {
 		map = mmap(NULL, pagesize, PROT_READ|PROT_WRITE,
 			   MAP_ANONYMOUS|MAP_PRIVATE, -1, 0);
-		if (!map)
+		if (map == MAP_FAILED)
 			ksft_exit_fail_msg("anon mmap failed\n");
 	} else {
 		test_fd = open(fname, O_RDWR | O_CREAT, 0664);
@@ -155,7 +155,7 @@ static void test_mprotect(int pagemap_fd, int pagesize, bool anon)
 		ftruncate(test_fd, pagesize);
 		map = mmap(NULL, pagesize, PROT_READ|PROT_WRITE,
 			   MAP_SHARED, test_fd, 0);
-		if (!map)
+		if (map == MAP_FAILED)
 			ksft_exit_fail_msg("file mmap failed\n");
 	}
 
diff --git a/tools/testing/selftests/mm/vm_util.c b/tools/testing/selftests/mm/vm_util.c
index db94564f4431..63aaa2d9ec0b 100644
--- a/tools/testing/selftests/mm/vm_util.c
+++ b/tools/testing/selftests/mm/vm_util.c
@@ -463,7 +463,7 @@ bool softdirty_supported(void)
 	/* New mappings are expected to be marked with VM_SOFTDIRTY (sd). */
 	addr = mmap(0, pagesize, PROT_READ | PROT_WRITE,
 		    MAP_ANONYMOUS | MAP_PRIVATE, 0, 0);
-	if (!addr)
+	if (addr == MAP_FAILED)
 		ksft_exit_fail_msg("mmap failed\n");
 
 	supported = check_vmflag(addr, "sd");
-- 
2.25.1


