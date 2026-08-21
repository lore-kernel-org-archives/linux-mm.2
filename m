Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AA20EC5DF7D
	for <linux-mm@archiver.kernel.org>; Fri, 21 Aug 2026 03:32:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 943376B00A0; Thu, 20 Aug 2026 23:32:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 91B6E6B00A1; Thu, 20 Aug 2026 23:32:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 80C436B00A2; Thu, 20 Aug 2026 23:32:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 555706B00A0
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 23:32:48 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9C2E98019D
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 03:32:47 +0000 (UTC)
X-FDA: 85123854774.02.340522C
Received: from mta1.migadu.com (out-142.mta1.migadu.com [95.215.58.142])
	by imf21.hostedemail.com (Postfix) with ESMTP id 934F11C0007
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 03:32:45 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Dbj129Ss;
	spf=pass (imf21.hostedemail.com: domain of hongfu.li@linux.dev designates 95.215.58.142 as permitted sender) smtp.mailfrom=hongfu.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787283166;
	b=FqIMrMDiFxEPGeKpHHCFUjjdsYWrztWnDcoc8baIX0rainVnkXJAi91hyQx7LydLmvQig1
	VR4sPWm/YJ7eWrpxfAr4lg1dIqYAF2uAzf4hifVUtZJ2lTUQLc+THsRf746K4ylB24RGAR
	CSSyI+pmGS1ScDKvqp9/gsIQ6GZn8A4=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Dbj129Ss;
	spf=pass (imf21.hostedemail.com: domain of hongfu.li@linux.dev designates 95.215.58.142 as permitted sender) smtp.mailfrom=hongfu.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787283166;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=9oMNm8JpJhy7x5J1ifi3yqhoqlyeELlD8kdI1iFUgBM=;
	b=nprWnoUHdTLTSyDhex3CzEPbxgj0Aw58avLup3+hS5FyH8LibIx2F4Tb9uvXGzBDLqsfPF
	Kod37TJHoh7fQPOjXzhVUNoO/fxXDTR6xsAQtDpVf2PTb/KPf+lRJUDNOFFkc9wRLdXCmw
	/TGE1nMsCi3vkbFEFghr0QXNNNM4V4s=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=kBdCSAyi4kONaeB6a0YcYCGt5al3Yd9yiIHm97HUMa4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787283162; v=1; x=1787887962;
 b=Dbj129SslkGBbU5+vvwfr3HoKJRZ/t3g0qi+hp8FMWiYhSSf+n0L8t1e8gZA8ySqFS6E82rv
 z7n0lYf+7XFpH+clitGV2DRQB2VianbwpVjgAzp5hWBF7RHB8O+FVG8QY92oMQG+Q0KqVdRO9X3
 iEfGz1ihWWCH3Z+8hLjxu1Xg=
X-Envelope-To: linux-mm@kvack.org
Received: from localhost.localdomain (223.70.159.239)
	by smtp.migadu.com with ESMTPS id 154a81432023c6b1;
	Fri, 21 Aug 2026 03:32:42 +0000
X-Mizu-Trace-ID: 154a81432023c6b1
X-Migadu-Flow: FLOW_OUT
From: Hongfu Li <hongfu.li@linux.dev>
To: rppt@kernel.org,
	akpm@linux-foundation.org
Cc: graf@amazon.com,
	pasha.tatashin@soleen.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	hongfu.li@linux.dev,
	Hongfu Li <lihongfu@kylinos.cn>
Subject: [PATCH] mm/memblock: simplify reserve_mem_init error handling
Date: Fri, 21 Aug 2026 11:32:30 +0800
Message-ID: <20260821033230.55210-1-hongfu.li@linux.dev>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 934F11C0007
X-Rspam-User: 
X-Stat-Signature: 5s6frjx7z6eazh667ckz1prpy7px9w7x
X-Rspamd-Server: rspam06
X-HE-Tag: 1787283165-565135
X-HE-Meta: U2FsdGVkX1/TI/w1aEopCRL1m2NsW3oiZ39vm7m6bbsa9LRPZRopyq7ZVH/43N71wCJKRtGKyFY+YebQnRl/JYcacWOcMgR1qmZYbMfM3wKKxvFOqFVQhwnSD86mpmoj+i1rawNGp10XkqiRdaf2K/d2FER0JKZrwUL0DfI9ibmcsgXq4dgaMozm/QgNiB95IPYdLh0NUV3NCGaooRpyi5n9NHwJzXDNrnG4X8Gm8fL1GbmAbN93hf9UmZkHho0DZll/rRcTVdWcUIzLGmMMHk0DL18v/q78iPNK5tIkOMqqLfT9ePao+CKqyIwpaNUUbFBN8gzkkmaO2u4XW8+M1rKBrmpX0e9mo8n2ql+6nBt3TfvRkyGiSMZW1Vko8QZ9uALiUiTsCPtcPD0YgayvzbKfbI4Cu5FMwe6YOqIzYmOK9hNSYvMyVP+fWT7+Ae4bwv1oVM+urYDv+7Z9/2HNZp8OpfASFkXG9FGNLRUUOZEsbZ9ajuBMlQqZ8yD2ivOqhGykY+6oarN29mOu2qlZ53XNAAM/JduZKMxbNeI2Wv79OPi7kkIxAdT4TB94DE2sE4gIAsDjI3jsIZnTO0DgFNMPW8M/E9fpc0iSF7+yb1uRDtArU3JKKbVLQRWtzceEp4UuP4ZO8176iMkH5u9y5YDsPWk8S2xUzhUI0wiYEZ9WjquOW931DNNj5ZcDZ+r6pQfVYKYxJdItM3uuth0glSFYfYhLPNo6vK0FNLWwDSF4Y60FK9uECFSRsxWe3esuxw0fCp/KNqkhlnerC/TzY9IfF/8h6Nx0Iaucs3m2H6NQdotJFrfFmvOLlQY2Oii/1dnaKqpsllzUBGQ4a4h4HQZFFe9YyJ8NRRFJhUIYQ6YfkgPw094pxBwmG6NxiIDsiMzrGr2A3WtvU6OwxaYFhwDobRM/DJhFIlfTdr56iyq1wL2KwnQ5PCVKrKFC3OrYRT2ULLo5+UVANR1s/yZ
 gqVij/Lb
 dd74UupRzZt5QxUEtT0t2Pb5QvX0ypAjAuJOdd2u6HNDU1JAPr3c0r3yrL1/4ICSM3qyOsTCOfy6UMtB6u9WoVBpDDDPjpp+0tWRebETEJY2Uma/7gIno4I2s3+aBsI4WrgkpApIuufzAj1Md8cIIEEX8Ix7kudoKE/I5Lqprt1jcb+TiR/lYBG7OA/rrPJHcB9wXsAjber1JswEVf35DoviKp2rrzSKqX3qyq9hIq83EL53YbLRtFJW95zAI5s1ueiID/JTB3zoOgy2iQx0T2ior7g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Hongfu Li <lihongfu@kylinos.cn>

Return prepare_kho_fdt() directly instead of assigning to a local and
returning it on both success and failure paths.

Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>
---
 mm/memblock.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/mm/memblock.c b/mm/memblock.c
index 777c69f05400..7079b93ec730 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -2616,15 +2616,10 @@ static int __init prepare_kho_fdt(void)
 
 static int __init reserve_mem_init(void)
 {
-	int err;
-
 	if (!kho_is_enabled() || !reserved_mem_count)
 		return 0;
 
-	err = prepare_kho_fdt();
-	if (err)
-		return err;
-	return err;
+	return prepare_kho_fdt();
 }
 late_initcall(reserve_mem_init);
 
-- 
2.54.0


