Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 36B0CC531CC
	for <linux-mm@archiver.kernel.org>; Fri, 24 Jul 2026 02:31:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 09AA76B00A1; Thu, 23 Jul 2026 22:31:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 072346B00A3; Thu, 23 Jul 2026 22:31:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EF70A6B00A1; Thu, 23 Jul 2026 22:31:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C7F5A6B00A1
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 22:31:20 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 52CB740233
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 02:31:20 +0000 (UTC)
X-FDA: 85022093520.23.DE30548
Received: from smtpbgsg2.qq.com (smtpbgsg2.qq.com [54.254.200.128])
	by imf17.hostedemail.com (Postfix) with ESMTP id 36C7D40009
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 02:31:16 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=uniontech.com header.s=onoh2408 header.b=ImOl3V+3;
	spf=pass (imf17.hostedemail.com: domain of gouhao@uniontech.com designates 54.254.200.128 as permitted sender) smtp.mailfrom=gouhao@uniontech.com;
	dmarc=pass (policy=none) header.from=uniontech.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784860278;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OyqXJDBODKL4i9r4faSbxqKqbqbjK9rOASLwkWPXzB4=;
	b=tSDrKHhTCS1P0FgbIMXG0DdihMDimtgKQyaWz28N/mt2OZ+3KhH84MB3u1Zs2EgTJWlJ2F
	dou8jev/p+aMdNtSQacb6JsJbc4Jwcl17/VdFBojHWG+ggEm45rwRq6chI58UnjngiCwIe
	pbrRqgvM3++8G4l8dx6IK8fLimNyjwM=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=uniontech.com header.s=onoh2408 header.b=ImOl3V+3;
	spf=pass (imf17.hostedemail.com: domain of gouhao@uniontech.com designates 54.254.200.128 as permitted sender) smtp.mailfrom=gouhao@uniontech.com;
	dmarc=pass (policy=none) header.from=uniontech.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784860278;
	b=GQEgSmAfRh/7dtYbF52MIuys8hPqBFSl1wfDSBXjpkJtGDLnog3ALOj884eYqsj0OzZVmH
	zLGsZYbejW4v9paBl97PC9CbuFsLSA4voSxdd9CSDFBrPfNbAKZiwWJqofnj0zIOG9NsP1
	CveHeyx6cCst5+fIotjH+We0t/k9pOU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1784860168;
	bh=OyqXJDBODKL4i9r4faSbxqKqbqbjK9rOASLwkWPXzB4=;
	h=From:To:Subject:Date:Message-Id:MIME-Version;
	b=ImOl3V+3qmGjRisyVUVd9mh2AZ0NFSJDdEzDIqUpNvqoNTKhOzOi6KGDffGACMmtR
	 Ieie27rcygsxcHg/b5/K/9wRnsRHf46IlOy9eN5HlR7Vl9LPGQaDr1c7Xc6lm8x8IL
	 1q3YhVXJS2PN8fyIiZ8h9JL89x+DGRIhNn+dO7mU=
X-QQ-mid: zesmtpip4t1784860161t8fb1ed23
X-QQ-Originating-IP: aBJCglJ9q/YAKBS1d2e+RK0bytOzmdANKIZ+RTuS4uM=
Received: from localhost.localdomain ( [localhost])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Fri, 24 Jul 2026 10:29:19 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 645947347967007313
EX-QQ-RecipientCnt: 26
From: Gou Hao <gouhao@uniontech.com>
To: maddy@linux.ibm.com,
	mpe@ellerman.id.au,
	npiggin@gmail.com,
	chleroy@kernel.org,
	maarten.lankhorst@linux.intel.com,
	mripard@kernel.org,
	tzimmermann@suse.de,
	airlied@gmail.com,
	simona@ffwll.ch,
	bharat@chelsio.com,
	jgg@ziepe.ca,
	leon@kernel.org,
	akpm@linux-foundation.org,
	gouhao@uniontech.com,
	namcao@linutronix.de,
	ynorov@nvidia.com,
	sshegde@linux.ibm.com,
	nilay@linux.ibm.com,
	clg@kaod.org
Cc: linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	linux-rdma@vger.kernel.org,
	linux-mm@kvack.org,
	gouhaojake@163.com,
	kernel@uniontech.com
Subject: [PATCH v2 5/6] lib/test_hmm: remove dead NULL checks after GFP_NOFAIL allocations
Date: Fri, 24 Jul 2026 10:28:50 +0800
Message-Id: <20260724022851.466017-6-gouhao@uniontech.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20260724022851.466017-1-gouhao@uniontech.com>
References: <20260724022851.466017-1-gouhao@uniontech.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: zesmtpip:uniontech.com:qybglogicsvrgz:qybglogicsvrgz5b-2
X-QQ-XMAILINFO: NIUeOSCg5F57kgxr1lqCbn/SJBSqwA1IrTVEXu2ygEjwZckr9zVvzqCY
	/vD7LZoEIB8y7ROJCRgV1sIMNXGKXKXIv+HsYav3muF0liIZp6MXJ6EKPjCgLGxspq7nayb
	8HAu9cCNCyLaxh6c229GMr+9UGghqmVquqzk4LCKKeKeK3srMHF9MevpYo+ZSD05zw3Sj/O
	tEiwKU3zGRqK1HpAk6nM1uil5M+01McN4aNHBEu5zGtwTRBeiciMFzFjsmMJGwXs25Y0Tz6
	VnvLatJ5DmEdqogd4G+xyjlgKPRYIqKr90+xQlfLUyOPog2vy5JLMqU0fkjYdNZo3dwyuqb
	FNz6IDnm/2JmCzHvsK0geiBQIK56hkRgOTZeo1bAdLD2DvACycsbLBBrHeZDTiXDW39LylK
	gKMKN0gEkTAvsbRG+2tZE57cDCV+Q0iVBm0sKA6en5PcfmsEwjBpJ8FfXOX5hs0L+TPqwd4
	SlMTF+hP7hhJbEM1+h/zE/0znH3+podHWxcHmfyVmY/kHcg+tunLZ2rygaGxPKVmbmI1Xcr
	6vRiD+a6QjS24PDNglBLVXasFknlC5oGCJKzaNkT0CtLguh7DzF4UUGoy2OhHP/FZdcjJGe
	uGFC3di8m5OJ0qOHvRfSukBoB9TFc3QhfJovtEe6qC3RSOs4RtCrQ/D8Axr/KgYrHTQW+ir
	cBrbD05QTgqi0EB3VmKLq4/61QW8mVkbwb61KSdNaVSopDRw61mAEm5j/p5qYqZvtORXKOq
	WkmhtAtoiRVyrqGEZt2Hl6FmNXLk48icEJyodEFRganGyMoAX5iNyDaTpAQiBy7VJIl74tW
	zT8WRExQj9T0cX5uHxdqQDw0R1D2QqrTXltygM9TPW6qoSFJ1iW/+c/IyBfgNTiHzhPI1PY
	z2nbU9PyBJxbHWsoEuJv9nyWdngBUtEE2efmW5cRo2cY1zT8WJH5ZtPZB1R7ntvAZtmbVMq
	a3KaLNuFSmRwutssPOlmDuN5AnrBxdfRzFfOZzRfDL0GCODya98FsuCmGLsc0DLlUJXnZpN
	MVWCDutezrjfiNGDHO11qjuIDJBbfjc+oz+009+6cOwIvSbSpuOXXIavaY400=
X-QQ-XMRINFO: MSVp+SPm3vtSI1QTLgDHQqIV1w2oNKDqfg==
X-QQ-RECHKSPAM: 0
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 36C7D40009
X-Stat-Signature: meigccgaaozntuqu61ppmft8mro6mi94
X-HE-Tag: 1784860276-638774
X-HE-Meta: U2FsdGVkX1/1qV3K7XTs/eRK0mm0Caew7owLDkMq4fVuBTKG3FdRkWRR0NaBKRS2/fTXSKDFoO0HhBpt2o91HvYCP44sM3LmLIgOsHguiVxfeYWMvv6so5jXHCQfEgXBS+ISR/FM6KXGgXJZs5xq/buN+mrRGhAMsNj0TE6QFxVERpIEUXNqCrqKxGsVQPZmjUmnLifH/o+JlEO6njV2aZe94NWI7MSbmhj6yaKKTHoWFS+bBLJzig8iDVlUKdt1CqPTR+xl1uKgubZLdW1qpyvAD/8mzw5xA4f20Lw0ZebYG8YN79d1Fgos3ZfAupWW/39UaSmVVi+zfy7Ep0jdx/73RD10Q3Dyu8ZLR8nNWAeb1FgTqJSDxA3VbjN09rJ/I0iJghIWIwJ7N4PJMNidtF2wGpV2aVy+TANZJjE92ejlmiVKwKUth5WeFVIxXBV/w74Emfp73Bd8aIo7Ref5k0gGwYjkrfsiTvjpECrN6sTrbFp2uyoE84ha1b3liCdBgVT3XgKB1qvNIcOkV/KIJQtcX+6J+KDv4G/mgAVEp6hZcGZUxHYR3qJtBvnWliIcWqxpV8qgA2u9AIv7o0iTbqUEWn21IHEtow8c9zQ0wOT31JJKVc0STSF6u6aisB8gi+OhyAbIJA8Y9sth2kZiXrex7qg6HCa8iwCsnOQ9FEDyMoSbnxpXq60Xck2NfG+2OjEe1xtgsC4h4jYBhDlTYSnRnB6f0KZnjqJgT7PdKtwmkwpaAMfMuDdxs+LifHk9biSAiHDTwXVTUT1QAZt8L4dwAVCqrQRzMVro52vYek2Plmgbf2mMxvV/BlvSx6IAmZKMF9T4kUDQPoPYVT6KVSJU3obzS7azQElMGbQ8Z6DxecuTNAuFYrobInw+a7EQ5vBURojZ3M9oU8e+7rXy000sFhrkTK2J/M11Fnw3t6y/uEGRkop1Gym7jmMQghOj4mBRYF5PO7fFTCnIl0F
 4oJptZws
 uG+cKVh0UQlaNP/gjgPhJqnI8ASIYkYq6DSyo4RT8DiQApU7jjLHNjtJdBV+H7YdMojef6ETt8hyfUZ+9pLIb50tsbJI87Km2maXX9Vh9/py4ueJpPw8RvhtdXbxcKcAOvvzQi2sNW+1zWdRfhPLGmh0f7MzW00d12WSBKM9SM9UH/J+RZ+dA4eAH1Y8vH9mtzHHCVdHZPK9k74jAKu8FgrTCBf4m0DFl3yxP8t2U3l1UUaL+EP9YvBoASN2iUWS+9BXjjdvLqsw5LxN/KsM9LEZIOGRMuKLD7yQT8MYOIalzguwu7peGR2qxqQA8lribaWNjLOsH7tg4joJsiimlaOybLppegpUw6ZB1I2CmLFTS5Ng=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

kvcalloc with the __GFP_NOFAIL flag will never return NULL, so the
subsequent NULL checks are unreachable dead code. Remove them.

Signed-off-by: Gou Hao <gouhao@uniontech.com>
---
 lib/test_hmm.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/lib/test_hmm.c b/lib/test_hmm.c
index 9c59d1ceb5b57..d615e4e5fc447 100644
--- a/lib/test_hmm.c
+++ b/lib/test_hmm.c
@@ -1209,16 +1209,10 @@ static int dmirror_migrate_to_device(struct dmirror *dmirror,
 	if (!mmget_not_zero(mm))
 		return -EINVAL;
 
-	ret = -ENOMEM;
 	src_pfns = kvcalloc(PTRS_PER_PTE, sizeof(*src_pfns),
 			  GFP_KERNEL | __GFP_NOFAIL);
-	if (!src_pfns)
-		goto free_mem;
-
 	dst_pfns = kvcalloc(PTRS_PER_PTE, sizeof(*dst_pfns),
 			  GFP_KERNEL | __GFP_NOFAIL);
-	if (!dst_pfns)
-		goto free_mem;
 
 	ret = 0;
 	mmap_read_lock(mm);
-- 
2.20.1


