Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BE6A3C55167
	for <linux-mm@archiver.kernel.org>; Fri, 31 Jul 2026 08:39:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6281E6B0098; Fri, 31 Jul 2026 04:39:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 58BD46B0099; Fri, 31 Jul 2026 04:39:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4792B6B009B; Fri, 31 Jul 2026 04:39:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1A18D6B0098
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 04:39:27 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A8627160348
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 08:39:26 +0000 (UTC)
X-FDA: 85048422732.03.65A29C1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 237D880005
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 08:39:25 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UxGQuFi+;
	spf=pass (imf30.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785487165;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=As8NSXV13y2cGJLUhiwyYLHOUPaX+4YofgJJNeeFOg4=;
	b=Lb9DUrFO7zskrHjMOKWCMubqoGchQOuEEqngmADNQuHmz9TR7+w47Blm+m4dIlTgpU8+xP
	Z1kDBvfFmuELe8ApfkJLHDuMsekb3nQlqAR8kMpDTDSyW9x4p778zChZlvcnNDE8Y4d1Tx
	7njLDSzVQDp4ruO5n99p/TFJNVTm9Gc=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UxGQuFi+;
	spf=pass (imf30.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785487165;
	b=Kfs67lKoWtUEu2NS4VeSvnplwNFEwDjIplvyxq+HyrebForlvmf34mbRPvsgB5nAguyY+/
	KdPutN5dFIPIe4iugPUdHJO6AOMqWNfnMBb7FeHTObySGnj8/LnKl16n6A1UR2FGfzErmG
	ZugKLJ5Pf+447TFIdhaURZBG4XGtsSU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6432143D5D;
	Fri, 31 Jul 2026 08:39:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBC061F000E9;
	Fri, 31 Jul 2026 08:39:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785487164;
	bh=As8NSXV13y2cGJLUhiwyYLHOUPaX+4YofgJJNeeFOg4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UxGQuFi+56gUrbDHVKPXs43VOxdya1Luqh1HeFxSpNC80syWtNsjRod7vsh0Wo2WX
	 HUv1IU7w3c4TuyxRhs9tvfOXiMAJWSEoNn+PbFJcnRfH9TO56WvA/9w/Ig3mKrmpjg
	 O13c6Vo82grMUU9qJkIX81Wi6O9zRStciEOObMIE5Kkyrp20NaI0HRJoMSgx36aEXa
	 D3vUuTOQleM1h5p1/Qw+gO7ZOk9W2agKzkzPYqScmpFj2u0jQTkOKUdicqf+qHrjXZ
	 mpM1NJlXFJWX8T3EJKGAs6kgovzm34R7Y8dmAiWAlY0km6mnaPtal8w/1p6e3kbHF+
	 DFoISSHaeyFmQ==
From: "Barry Song (Xiaomi)" <baohua@kernel.org>
To: akpm@linux-foundation.org,
	linux-mm@kvack.org
Cc: axelrasmussen@google.com,
	david@kernel.org,
	hannes@cmpxchg.org,
	kasong@tencent.com,
	linux-kernel@vger.kernel.org,
	ljs@kernel.org,
	lyugaofei@xiaomi.com,
	mhocko@kernel.org,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	stevensd@chromium.org,
	weixugc@google.com,
	yuanchu@google.com,
	chenridong@xiaomi.com,
	zhangbo56@xiaomi.com,
	wangzicheng@honor.com,
	lianux.mm@gmail.com,
	"Barry Song (Xiaomi)" <baohua@kernel.org>
Subject: [RFC PATCH v3 6/6] mm: mglru: run aging if the preferred type has no folios in reclaimable gens
Date: Fri, 31 Jul 2026 16:38:43 +0800
Message-Id: <20260731083843.37811-7-baohua@kernel.org>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20260731083843.37811-1-baohua@kernel.org>
References: <20260731083843.37811-1-baohua@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 237D880005
X-Rspam-User: 
X-Stat-Signature: z7a98nsh91aehkp56xxdd74b347dyidq
X-Rspamd-Server: rspam04
X-HE-Tag: 1785487164-967501
X-HE-Meta: U2FsdGVkX18XQil0EL3jxDf825fVNTJz5kMQ44mTxI8kt6TddHuZ06wHJ72REuMhprQmQ6XKPmTiaQE/Rpa4k6QLC4RIu37VmRjMR4Tg2FsEzyfRNQgYkTLr008huWL0srsxviHNWH4yRBwnFPjXU0z2048ZJyOhls/QY0nsQAWvmQo8oObfkibYmFTHJt83pbfYzKKhkiajBGeM/ialBQN5xU865DQFI6nqvUzUSwVlZa/Vzcz28kHolDjFDmCzyZN87c6o1NdoViTEXfv+yhJcVCLNXFcfqxsqr8y1eXvqAWHjGLeODhHXwTJltwvBF94helS5E2OKe6jWVnRcXpRfQa91LRC97AwK6RvoQU95UZQS5hGAUCMBi7d6Pfuknix0xXm8IAaRV3wX2CNLFqmMToJyu6dXQ5H05wxBucyvpFq1MSEnkAPdmj3prA38+aLuQXgVCUj8MoU7Cbs76kPc7cxs83Y9Bsyjml3vtuTFs9rtd9zM9cObo/fAbLbENjVpobgtKFBhlEZPdAEBE5hiRpjA7z6eafqC/NbZzTjQxVU/9jyLCE48Gx7+ZFNCSPCdeMT6cFDq2oqFhyeK7sNimOuTnC8LEljWUni9iV8DtCYJL4qE3LWnG+ccTPrfuBXufg7/NUQGckvFzwIl75uRfqPPexYC5Xbokg6V5/ZFrUkPRPiKIXdNyyfD5/FlIXlLMLSaiEYDGUTqKaoLp1poAzz3lU9Eeu6NHTT364QHtgIm4i9goum/JDmL70t2czSNuHhGnaXTG9pDpWEEd1RLwHxCVkxixYynKdN9sCUSCqslkfMFp2xSI+g5RY3K4Kx2bGb3p/E/S3uRC9jxMk/qoNJBlBIMlWpr73DkGuA1IbAWfBy7mCsCefny8U/Nr07xysyZWEJsvt5kP7n/eBcwvRsoRLRzh1tMYqcgvFl4pRvroGq++9viqbsWBvO1h+GOQXxhJ5ZGeV4p7Oq
 9O2Dpi7d
 3xDPSYPdsSm49CYdohTg3Ql49jJPGObuSb2wE9WlCKnCb+vkT2SKEfGr06YBZsaGu1NYKm9R24Kq+C8W0xFLXvVk1X0LIYPsOKTQQNDFZ1feY3l4nNsTnnqgePTeZ18W45BmIoYs7vo+GgiOHmpTUiwch5R/fI7GVBT5G3Jr/C1frGTkSeIQq2dbJavpxJzUvddsSDj9yPcVsI4hrIGJ16pYpiVF+TZkMHS1IMAWj2p1dM59RtvskyZoVeHVP+j3LwGPIohIXHm1fH3iHO336xTRh+3tvolXlWZQtYKqybZ1DyDVZn15V7FE3qQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Respect the type selected by positive_ctrl_err(). If there are no
reclaimable generations left for that type, run aging.

For balanced swappiness values near the middle, still allow gentle
reclaim since the swappiness bias is less of a concern, while the
slightly increased aging overhead might become a problem.

Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
---
 mm/vmscan.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 98fd2fac90ac..902d85afc5f6 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -5035,6 +5035,10 @@ static bool should_run_aging(struct lruvec *lruvec, unsigned long max_seq,
 	if (evictable_min_seq(min_seq, swappiness) + MIN_NR_GENS > max_seq)
 		return true;
 
+	/* run aging if the preferred type is exhausted for extreme swappiness */
+	if (min_seq[type] + MIN_NR_GENS > max_seq && !swappiness_is_balanced(swappiness))
+		return true;
+
 	/* try to avoid aging, do gentle reclaim at the default priority */
 	if (sc->priority == DEF_PRIORITY)
 		return false;
-- 
2.34.1


