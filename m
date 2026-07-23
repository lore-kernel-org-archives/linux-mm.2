Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ADA2BC531C7
	for <linux-mm@archiver.kernel.org>; Thu, 23 Jul 2026 08:18:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B07716B0143; Thu, 23 Jul 2026 04:18:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A90F76B0145; Thu, 23 Jul 2026 04:18:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 97FFC6B0146; Thu, 23 Jul 2026 04:18:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6D4C76B0143
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 04:18:57 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id ECB5C1203F2
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 08:18:56 +0000 (UTC)
X-FDA: 85019340672.09.1FFA54F
Received: from smtpbgbr2.qq.com (smtpbgbr2.qq.com [54.207.22.56])
	by imf01.hostedemail.com (Postfix) with ESMTP id 9E2BC40009
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 08:18:52 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=uniontech.com header.s=onoh2408 header.b=KP83hjKi;
	spf=pass (imf01.hostedemail.com: domain of gouhao@uniontech.com designates 54.207.22.56 as permitted sender) smtp.mailfrom=gouhao@uniontech.com;
	dmarc=pass (policy=none) header.from=uniontech.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784794734;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5Ru4P6jK+Inu2P6W3ZLj3pcMa86MCoNiZGSUv0GMeE8=;
	b=B/mqv+brwiMRVTCJ/Jn2CChsF6X0+odOu/PADtXvyg1zG5YPi9YUnzT0nU3LZqQwL73wLB
	0QhiUz6KZWBCkINli+WHmrqyA4azS0/E3nZenxw8WNTWUCnXAE1qlY09RIhJc2GCBPF8zI
	wsZpsUngBDduMIGPZg5pH2deeTLtF2Y=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=uniontech.com header.s=onoh2408 header.b=KP83hjKi;
	spf=pass (imf01.hostedemail.com: domain of gouhao@uniontech.com designates 54.207.22.56 as permitted sender) smtp.mailfrom=gouhao@uniontech.com;
	dmarc=pass (policy=none) header.from=uniontech.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784794734;
	b=Xxx4AnB+vcxkPH4SeH+ugqM7+rJTiTUfXB3GSF4DNafuPjr+q+YTrfI3eE0HQuvNvOegxZ
	xhPU86NCtM7MWG9eYAP/zYcSqv4erwr/sMT5N93+Sqn89c1Vn9aV02iY85qgQAQikI/C0o
	hDZ+rsHjftNvRYbCFN5kDV+pWtAKLHE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1784794729;
	bh=5Ru4P6jK+Inu2P6W3ZLj3pcMa86MCoNiZGSUv0GMeE8=;
	h=From:To:Subject:Date:Message-Id:MIME-Version;
	b=KP83hjKil/SmJrYZ5/iIEYTE3DrEA6GsB7ByM2glqh/oQT6OqGmtlq+uGjrHQmIZV
	 dT6U39CZC2KgMsJl+hJCNbbLkLUs7srnxl312yHHiH1Mu4VLZFmaFoDCGBiLfgrfR/
	 Zgmc1+0VR+hCqXMHLDjKXqcz+owLTXx1oYyojaqo=
X-QQ-mid: zesmtpip2t1784794713t01a6cdde
X-QQ-Originating-IP: HMKwZheqtj88lyEjppGtB8zm5VBw5QQ/hPZB97lqyKU=
Received: from localhost.localdomain ( [localhost])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Thu, 23 Jul 2026 16:18:30 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 15366830240286596552
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
	ynorov@nvidia.com,
	namcao@linutronix.de,
	mkchauras@gmail.com,
	sshegde@linux.ibm.com,
	nilay@linux.ibm.com,
	kees@kernel.org
Cc: linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	linux-rdma@vger.kernel.org,
	linux-mm@kvack.org,
	gouhaojake@163.com,
	kernel@uniontech.com
Subject: [PATCH 3/4] lib/test_hmm: remove dead NULL checks after GFP_NOFAIL allocations
Date: Thu, 23 Jul 2026 16:18:12 +0800
Message-Id: <20260723081813.176792-4-gouhao@uniontech.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20260723081813.176792-1-gouhao@uniontech.com>
References: <20260723081813.176792-1-gouhao@uniontech.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: zesmtpip:uniontech.com:qybglogicsvrgz:qybglogicsvrgz5b-2
X-QQ-XMAILINFO: NMGzQWUSIfvTvSXQnv4dTfLWtXVh6PenXGnt8zE6EU6MX80y0VndNyQs
	PfqMr8GJjxwwHFHUcrjnJNpA3AQywqrfkZ3V4LOphc6+JUnw2CzUZwd9V9TmD6ifDeuhioN
	7HkSsEh5pLs3mB6UyCpHRO+m0TODohppIVMNyXS3oYOM9RJcHhaGmKoidwZtFFYMMWXLMn4
	J7Q2pPIzGyS/8ChCNrL4CoWdTKkK/YW5ceql3sCWLnaOfq5IBU3B+E0PVSlBeDyboMiUwYq
	KYpV6CeLzDlQzPshZPf4tUdI0TRq/iimcs2hzfBaLyVXSRoSAfCj8SmkxutJ/5WVoq9b0dw
	4SZbOTHbl7HGw+NXmRkXV0najhrIBt/Wj/dc2OZ1drRlEm4BO0nN/iaeJT2bHza3QFM0t9U
	oHPmwmHg7oKASvCEUX94mzDaM5GzvbbsLcxdekCpQaxWPqqIp/F/xw625PBBlPPuhBsiOON
	jjGkEAMpb6P6ZuF2c7zjWeAtbtqH8eYa+nfiyL8Xto9ODOqzFfdoJg1wf34vCvbg/gHB/uN
	/+irb7bOc3BstDQmW8EfJf5iIjQ+NGtIkgp/bzleMPI784M9gRm39N8ssN8io0KD7ghXCcb
	FjlQO67HEPvUAQw8lseL+4AUSMVUpTu2brx3NLYsfoZS2v3CTf1+WN8lmCraS8FtZPkTkVy
	RCc0JEVOPSlOVyAc9PurJeTLxbV0Wti1D1LRxXtUQFo+0ABhGmnLoX0fP5YcRRgUmX26C0j
	kmDhAGKUutH9YQb0k6FzX9EH9tiCcpSE0qIPnEs/G8eGxuLAoFkCCMfsW9VY+73yHbuebTO
	ARpK/kmY1jd5fqYYbZxbaEm0zOfeKe8BayyMnfwrWA1iD46IXm0mjxPGuGjh4CZHKnpFrxH
	idf6SxpiQEx2sjjdVQxkNWdL8RZVGuA395uSqGQiXtKye5CDggyoZH86Vg6fnPvpslG5PNx
	75s2vtb2R5mWAUhcnEIgtJndik4j8hZ1XxPBVm/68IjTl3McSyEuKW3ZZ2sPqlEbZeFmXfI
	lnOXtKto5juQ/NZmAjLHxaCpvjKMebMD6iHYOyGun6MG+ynMlC
X-QQ-XMRINFO: NS+P29fieYNwqS3WCnRCOn9D1NpZuCnCRA==
X-QQ-RECHKSPAM: 0
X-Rspamd-Queue-Id: 9E2BC40009
X-Rspam-User: 
X-Stat-Signature: 5mxfwx6ejythjcmah79njjp41sm5st67
X-Rspamd-Server: rspam04
X-HE-Tag: 1784794732-82216
X-HE-Meta: U2FsdGVkX1/vnrsHR3m3yB8mtbyt51DwdSning6jOhUVNiw2aeNRxmKL42VL3meSMH2bE8qarfFPrb0WLO05fPl1t1gwAQCIiYEx4x2LRTRYtzQm8g4Eq/fqkIkIKYDVfLkzdT9f7aQntSHxBgQDu+1QivWcnLcbNWiYfvNT0/ckMnrgX+OZOr0f5vvGyKrOMPWVD1AWDgIcm8Rt+4zBgtF51BpCrFGO8f9I/TXc9IS8gYjKS1DTAYIPi/BD9Ib+BQ8c9msuExOzu2qS/P2NZL1gAkcYwOgBoA8jg9IT25/2sEeJI+u7mr86d00dlN3yogyGVRj+v+WlfzNXD4Smxewm49PvUE8gMwbwYlKO1+2RUKDt12Ab7v9TdxN7+V/zsKh4iQo4Ht5WJEMYUST/d6DYrgC1aL1iwYtW/pH3oM1CA9oOaX/OxT+4DdgHOk3lxSdGjDH/B4HBFF5cPbBsTzUTMpu8ZE0+onBF1Qk8psTnGtG5dHnbHJKH3Q+scrMkeAFgTyrPU0jrq8cYrsNc/0ZjegcPyRRtFdmyN1aT7MboMH9XTuWEOY/eZa6iudvNdksAREEI5TOy+On38d0NKJdf4/FGS6GLfVYhP5cT6OwOEEMOMDzaH9lMntbItZknbUuhojzIIu9wAaPhOVcWbwPFEfAOiXBv0nvzZP3ZfjevXp9/jgPlut2eeSl6q5tsRiKm+7sBapvSESE+C10tVphuNAimYcEk4avdRSYkeO8Y21RtJRBQhyDX9D9IprRsqAh5LafaGHMn+MC50OpDOlz3Rgar54yZ5gz2InerbJB7VUrCQBfqYVsOzUym9CL7EzBDexazsJ9tPoZGXjrrYCnnwRy/UG0pw8+ZMkPBSujDJ3jbA52NdDlu1vSPkzuEp6MQE8E4uewUNqeZL9pc0liR39OuRns/8nn0cQw2y7VbrZ7dwyLnBeBjZ9wefrApsmwOs8Z99o+fCY97Ugo
 1c08YN2/
 0L2S7jx9+Fas8iAn1muL2/libyK7NukEcjiW5SW3eymCFblrcNyu0FcIMaSnGJQIUknfQIugFVO4blvDvolSYIPZxxQd8RNOmlUREiFOCq9OBP8a7wObx8SzBUFOCG4r6H7zqMWWVQ31SoYfQv8vK8oE09umLyh3DX7m7wV7CiGobz4eWx6ren7/1c6Ie6Rkqg9IdNYkA61SBbxOOYzb05jYkPHdDku7n86AlGUrbBZzq3ST01HcHy8jYxyd3pKkJlwnAU6OYags+LVOdIXfMMlxWjeLt4LCr+OkHLBaDIuMPjvo7PlTM+5Is5he4Z3CSndpfTvKS4kv0yaKWdvZtRYxCTf7BcTU4FwrQ
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
index 9c59d1ceb5b5..d615e4e5fc44 100644
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


