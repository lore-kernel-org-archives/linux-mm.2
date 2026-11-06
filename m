Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1BFB6606A32E
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 16:47:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=PxkzuLI/;
	dkim=temperror header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=3G8zjDyi;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=PxkzuLI/;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=3G8zjDyi
Received: by kanga.kvack.org (Postfix)
	id 1863E6B05B0; Fri,  6 Nov 2026 11:47:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 15E156B05B1; Fri,  6 Nov 2026 11:47:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0264C6B05B2; Fri,  6 Nov 2026 11:47:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B5D666B05B0
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 11:47:28 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2F2771A012E
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 16:47:28 +0000 (UTC)
X-FDA: 85405274976.04.DA24E4F
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf26.hostedemail.com (Postfix) with ESMTP id 1FB4A140009
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 16:47:25 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="PxkzuLI/";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=3G8zjDyi;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="PxkzuLI/";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=3G8zjDyi;
	spf=pass (imf26.hostedemail.com: domain of clopez@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=clopez@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793983646;
	b=dt7F//F6BoS4c6flWRb4HPpBIfr1nxgiL/z+deMS+iam8G7TatKXOQZ+UNnT+36/VCPgeQ
	mB6tCvBv+3L+VFQBnxNUfCEDDZ1cRI1Xd7w47j/J3zcJNm2TWl+CNfjznj0qSUYSfLjB9m
	mMlhbutmKCod6gypho+shhDtH6z1LQM=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="PxkzuLI/";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=3G8zjDyi;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="PxkzuLI/";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=3G8zjDyi;
	spf=pass (imf26.hostedemail.com: domain of clopez@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=clopez@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793983646;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=wPWOls+GsP/LZWvFejuggf19NK8Hy8dSKnoByaWSWbU=;
	b=ocrniX5vxy2DUzi0Pavf2g3DTpVEvHkJd0kS3BUc8okXe2JCEHHH4RfXANw+8A/z5NGo3g
	jNXBIlTxzRDW0lbfDmaRFpIw50kJq7s9YGWZn4iFBapeX9bDBUMPT62GYzmobbh+57cnsS
	LZ7aO5wAVzZsUmP7ay8I0pWvC1llFhc=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id B9E9F21FFC;
	Fri,  6 Nov 2026 16:47:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1793983643; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=wPWOls+GsP/LZWvFejuggf19NK8Hy8dSKnoByaWSWbU=;
	b=PxkzuLI/am9JnYTnTvuEijgDPYfeVBgSqbGO9O+MfngsRdJbzeo4biD6Plw7uupL+RkSYr
	Hq4PezkwWHm8Dpu0ed6ywBjWd/rVb1h/Z2eDZ7IDZYVHxWLl2xSQ1CmK98wTvhGLERcOqE
	zzN8n9ag1q/au621BObs+lVpZDXaLyA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1793983643;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=wPWOls+GsP/LZWvFejuggf19NK8Hy8dSKnoByaWSWbU=;
	b=3G8zjDyiDhO0L5LiKBTyzfNc2Apd4rvaT59qMkS2k2mY0+P4MMnyI2VnRcnFe70HH1YDf6
	Fs1bW31Ux15qoeBA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1793983643; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=wPWOls+GsP/LZWvFejuggf19NK8Hy8dSKnoByaWSWbU=;
	b=PxkzuLI/am9JnYTnTvuEijgDPYfeVBgSqbGO9O+MfngsRdJbzeo4biD6Plw7uupL+RkSYr
	Hq4PezkwWHm8Dpu0ed6ywBjWd/rVb1h/Z2eDZ7IDZYVHxWLl2xSQ1CmK98wTvhGLERcOqE
	zzN8n9ag1q/au621BObs+lVpZDXaLyA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1793983643;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=wPWOls+GsP/LZWvFejuggf19NK8Hy8dSKnoByaWSWbU=;
	b=3G8zjDyiDhO0L5LiKBTyzfNc2Apd4rvaT59qMkS2k2mY0+P4MMnyI2VnRcnFe70HH1YDf6
	Fs1bW31Ux15qoeBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id AA6F3132C9;
	Fri,  6 Nov 2026 16:47:22 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id uO5eHpoE7mo4BAAAD6G6ig
	(envelope-from <clopez@suse.de>); Fri, 06 Nov 2026 16:47:22 +0000
From: =?UTF-8?q?Carlos=20L=C3=B3pez?= <clopez@suse.de>
To: akpm@linux-foundation.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: dave.hansen@linux.intel.com,
	=?UTF-8?q?Carlos=20L=C3=B3pez?= <clopez@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Shuah Khan <shuah@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>,
	linux-kselftest@vger.kernel.org (open list:KERNEL SELFTEST FRAMEWORK)
Subject: [PATCH] selftests/mm: pkeys: wait for the child in become_child()
Date: Fri,  6 Nov 2026 17:46:39 +0100
Message-ID: <20261106164639.2959195-1-clopez@suse.de>
X-Mailer: git-send-email 2.51.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Spam-Score: -12.51
X-Spam-Level: 
X-Stat-Signature: rqnwauprcbwodx8mknhpujy3ne4hwkfq
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 1FB4A140009
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793983645-188472
X-HE-Meta: U2FsdGVkX1/jvRBpiVYkVAiDV+klWP8a7oSXnBeWE7wDOCehKJVj42KkyKgm2ft2+yPx4RfEQTmFWzR6iFTtx2Pdl0fhS2Vd9eyp5IL6DMdGF1lkOIhyTESPW0VuWXU/vTROaPhrRabGzslloLsFb6SkiISClxhlzsHB3BMgPcixXNRpxAF0RXD0P4DxDzGWw/ktfnRqXHsI7Bi4UvRlIAup7KGg7zqDmQNzvnUFGI/rLkhYaE4Mj9icEVx6Pqd0kTBvwYqOpmm2fY7WrGEavKKcDN6wVPzCKRO0kk48UadMRTnl3L0TG/tvFRF4EEaL8hJd+kR+0HBXlTMsqq7iELP/vFUmShHM+BkAGsSGlN3EVWPigPH8I9v3o8pRUjuU8ZaDLSKmggSHKvejBPWI9t7X+Vujfi69kmro2tDZf1jJziqgEZLgEZcPI0Xqll3tUprIYUCSoSsTtrVVFmOvf4+AUjlWqtVJwPFY8MIN/Y5soeEzXniubmm1U3a0dWK5wY4zGMVvjmYdxEEfatTFKiqL99q9HfRl/28N1/9NDRxVemJMJkTvS2wU1V2O/Nx3t3ZyX30X+6B1ShVOaMgmZPUv6T/SziQnM83Y/xFr76zNW0otC0fLVhHqodpL15XHde2jPGtQBLLPcXY0lTeN0oqKAZvc4hribR2AB7ZeUElw4znkH9H4dlad1EUPJZ39b+w4wYWDjTsLG8glZUF1ENz0Eqfff8lg4c7hUzgce9EIU3WeVGBY/VbL5+21UPAxC17VO2lm140Ye3DjJTeUW0t22SSrBDmnyTxwidVSwYUFUuBscPUILJy0ctIPfUDvPUKocFDXX0QVM/+wMfAteTphu8eQSe+UvL64F9SF05c/pDoQDqY1fcWK2mgiGcPkK17rmYRIjgfxV5Q6nQORgbzgsUQ9Ruaq34pnDCN2t0lt3vu3LcDyr7xZ5N5UPIIqZ8SeSFAVnA+sVoKjqEP
 PLalUBgi
 ecbl29s7R/ibsN6ZfxvPvd/CTZVlJMK2EEBpKht4EG/aWqMDAtCAxJ/Mrn7GpVBpPXG5aNjcWXKNapiMUZ0A9gIMBdgfTKJKkW0HAY80uNfN2EE4VWoWhnGBYMQFOvowv/aTWo9zRlMyMsaBTT9czURTDwP8zR7ecT3wvg5pvNc6DiwXgA01e1K792b3O1YHIN9NEhSGrLVDJ934Nl34JOxISnKAGNsyvuMdHDc/7ozA5Fx29P/u9OtyDQsebNhELdqQVCz1Z/Mmm0doMWE4Ew6Pf8prJ7NV3C47/rRPSvxt+x91JSaiL8FLxy0//LMnwyeS2MVfpLOmEnbXrci7oVysDCobd0gep1XA/5UXgbe6zdwxW58180rkvKOxRQsqFCPlRWdV+ESM7HbetCh1ZhfollUhRUQMx2OHSoM8FpSAVdncdAOZ4Zep7zaIe2ASuLLkGGFu+7kriC2c=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

become_child() forks during test_pkey_alloc_exhaust() and has the parent
exit, so that the remaining tests run in the child. However, the test
runner only waits for the original process, so it sees the test finish
early with a success status while the remaining tests keep running in
the background. Failures after the first fork are thus not reported in
the exit status, and the remaining tests overlap with the next selftest.

Fix this by waiting for the child in the parent and exiting with its
status. A previous fix avoided waiting, arguing that the parents would
keep holding their resources [1]. Particularly, the parent keeps the
hugetlb reservation of its test memory, so the child runs out of hugetlb
pages after a few iterations. Avoid this by freeing the test memory
before waiting.

Link: https://lore.kernel.org/all/20240419115027.3848958-1-usama.anjum@collabora.com [1]
Fixes: e1812933b17b ("x86/selftests/pkeys: Fork() to check for state being preserved")
Signed-off-by: Carlos López <clopez@suse.de>
---
 tools/testing/selftests/mm/protection_keys.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/mm/protection_keys.c b/tools/testing/selftests/mm/protection_keys.c
index b7882ab97683..5dece144ab95 100644
--- a/tools/testing/selftests/mm/protection_keys.c
+++ b/tools/testing/selftests/mm/protection_keys.c
@@ -1009,9 +1009,10 @@ static void test_pkey_syscalls_bad_args(int *ptr, u16 pkey)
 	pkey_assert(err);
 }
 
-static void become_child(void)
+static void become_child(int *ptr)
 {
 	pid_t forkret;
+	int status;
 
 	forkret = fork();
 	pkey_assert(forkret >= 0);
@@ -1021,7 +1022,16 @@ static void become_child(void)
 		/* in the child */
 		return;
 	}
-	_exit(0);
+
+	/*
+	 * Wait for the child to finish the tests and pass on its result.
+	 * Free the test memory first, as it may reserve pages from the
+	 * small hugetlb pool that the child needs.
+	 */
+	free_pkey_malloc(ptr);
+	if (waitpid(forkret, &status, 0) != forkret || !WIFEXITED(status))
+		_exit(KSFT_FAIL);
+	_exit(WEXITSTATUS(status));
 }
 
 /* Assumes that all pkeys other than 'pkey' are unallocated */
@@ -1060,7 +1070,7 @@ static void test_pkey_alloc_exhaust(int *ptr, u16 pkey)
 		 * preserved across fork().
 		 */
 		if (i == NR_PKEYS*2)
-			become_child();
+			become_child(ptr);
 	}
 
 	dprintf3("%s()::%d\n", __func__, __LINE__);

base-commit: 843c58022865a7b0f9743416c2b48bc2632da23c
-- 
2.51.0


