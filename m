Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C7942CCF9E3
	for <linux-mm@archiver.kernel.org>; Wed,  5 Nov 2025 02:39:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1F40B8E0008; Tue,  4 Nov 2025 21:39:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A46E8E0002; Tue,  4 Nov 2025 21:39:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0E1FA8E0008; Tue,  4 Nov 2025 21:39:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F27BA8E0002
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 21:39:39 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7AC85160144
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 02:39:39 +0000 (UTC)
X-FDA: 84074997678.18.F20459B
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.4])
	by imf01.hostedemail.com (Postfix) with ESMTP id 9D4E04000C
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 02:39:36 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=IR9Kdhti;
	dmarc=pass (policy=none) header.from=163.com;
	spf=pass (imf01.hostedemail.com: domain of zeng_chi911@163.com designates 220.197.31.4 as permitted sender) smtp.mailfrom=zeng_chi911@163.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762310377; a=rsa-sha256;
	cv=none;
	b=F5qzLKextEp+XP8+iX1BDd3fxhQlTXeAQkdN7zdxHj6TzRF5AoHNJLPTHKKS0IJu6s5QtE
	eYgR7red9XgKPgAr7WO8ZfdDwG4IE3QwSFSQGydrMWM6Fs7Sm9p1NqnYZMM4J9CtV76chR
	mvgQ3avnxOgXLgx8R/EtXOuhGcUjBAo=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=IR9Kdhti;
	dmarc=pass (policy=none) header.from=163.com;
	spf=pass (imf01.hostedemail.com: domain of zeng_chi911@163.com designates 220.197.31.4 as permitted sender) smtp.mailfrom=zeng_chi911@163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762310377;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=BZpnaGngs562nOrD3YutHkLMT0eZNZA+nV/m/y76+ho=;
	b=WZ/i2eghk8mJdRaSEKmEAkJjHW1CGXMk/b3mNQlS7peV24Zk+Q2Q6l5hqXgXvPAwxRFnKX
	ovrGEf/9rvkbF8GeZT1E54D5mUori0VG/Kv4brzac2NyvDGyVPgjbinPjlb3Gi96g1efQO
	lK8/ySIYbcD3Oo1xApT+9RZd9lf9XJQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=BZ
	pnaGngs562nOrD3YutHkLMT0eZNZA+nV/m/y76+ho=; b=IR9KdhtikcbbuVqQ6A
	PGB/4WTyvNUzTln4jBqin4k1RNzDPVOmBwyyCqCUim0RcGb0QwiH5barC4TH0Zmy
	5SQO2yatcIVuGH80SydTyrUn2sFTfrwfS6u6M0mZUxPwbNfHnPz45CvdksIOrSZr
	NYDZUbl8kOLDwa40m4znHMHW4=
Received: from zengchi (unknown [])
	by gzga-smtp-mtada-g0-3 (Coremail) with SMTP id _____wDnb9vfuAppK7GSBg--.32612S2;
	Wed, 05 Nov 2025 10:39:28 +0800 (CST)
From: zeng_chi911@163.com
To: akpm@linux-foundation.org,
	surenb@google.com,
	kent.overstreet@linux.dev
Cc: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	zengchi@kylinos.cn
Subject: [PATCH] alloc_tag: Use %pe format specifier
Date: Wed,  5 Nov 2025 10:39:25 +0800
Message-Id: <20251105023925.1447482-1-zeng_chi911@163.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wDnb9vfuAppK7GSBg--.32612S2
X-Coremail-Antispam: 1Uf129KBjvdXoWruw4fuFW3Jw4ktr15trW8WFg_yoWDCFb_G3
	45Jr4v934DGF1v9FsYvrnYqryqkw1v9F4rCrn5uws3J3srGwn5Xr18Xrn8AF13Ar429FyD
	KwsxWr1vva1a9jkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IUnEfO5UUUUU==
X-Originating-IP: [116.128.244.169]
X-CM-SenderInfo: 52hqws5fklmiqr6rljoofrz/1tbiRwv8u2kKtTARfAABsB
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 9D4E04000C
X-Stat-Signature: bztandxbpyphkgg5154sjnekgqyjctm5
X-HE-Tag: 1762310376-754069
X-HE-Meta: U2FsdGVkX1/mlf/X3JkIQDXALWHHtVGmQljG3gdoTjTWXV7O8yKH5DmUd+f8q6nZGcdUdGtz0nShTJ9sqUcVp5upSvbX8E/KQ8XeeHmH7cM+AeXMm/ylV2mKDvc+JbdCX+Amw+NzEOyu0Ja6nz47YER3J/Yvo8BvPes0xBYrICgRGCOWrb7vhxdAttoz6kCFC81P0FYjd/XyxOepgJi7IUUicvimc3XRhJ0/YviOXHvQwEIMaMTq4xzqc/xTiHvTswhbV6Athh3RAyt2DUxC1xl7xUlHqj6y2ypp0iLGzaAvteA/Ly1X/ks+HV3nFCaHBe0YXpcSK0aNpb5bcejsgflryF09U6aNq0TSXV4Bs53r1maUYy1SeQpSpcQvyoFu3cEMx+iWXC+4sv212dadxEJi9yHoqiLf4BXNU2hm2LSCOktsziOwMGn4LzZWOuj9auMzsAmm304MjNT/rVgKK2jMzh0oUsxgKGbTq5v0YI7DVdADgzvUHxTbq/jbzqyYB22LroCGx2QqUdHCGMo4OheuYp6vvwtvL451Aum9aMyeSPPrKZiN3NlE8f4MAm2MLepaqCc4yJo/R6yDKFMHNvkBEnV2XPYC0Pl4K70iC8InrUNYQTOkDfO8MPf7m1I4I8Z+nHj/ImEWzmuNQVyQugwyl6/CyDoULcAri07L8Q3iIawdjhwSq40P3yL0+qWh1pKAdkhYtgppi4N09K8AETn9B7CgPy0yOQZ6y4lGGD1KffK6DGgI93lkRgZViKfLRUGRz3+4Y2xJQ9jS1wAVFP5QidQr80P6Qek5apH3xdmAAwh2AfWLEuffrQpTQS9OlZYS0tZumaYwTsHd3G4lEh0ql/6ynSVqMnNYcRAFBktdmh6r4MqqB+dN4iyRqtC0cI17rTLjwHZ0X2zb22pLJes8ADIcgGaP91fQ+deCLHdIDNLeQjykjN6p6K0d4VsGRFbfXebQSp0nneVR1ci
 e2r1+ZXk
 HB0Fupe2Sf6hu+ls1ohu7/+q0w0EgHWtl1/CUnnINxbWIMOfcp/ymBBj5nSdizi1jHp8D0MUReMSkdG8cSakaZF+dP1sa4OwWzFQCo8wyS4qXZd+nVM8iHLNTrXlTkrDikN4UBb6U/oXkW8nBclE6EmQhxztXe7VAuFkjrNcNCkmT8yycqPmF8tFxirr8Au3gBaat5asPYDrbjDBeMrv28CQSwjKLeJWqne/++BBzbgKjybA6GW4OOnlvf+D2cNOCdWZtB0vxe36IZ9RHdGEes65bRYQmEbO6euY/hNzFFjB1JkeEAcIsqwr1RZHFnvCFRQF76s3luQL3R0HOEnLkiaNiIlk2mHUfO4wWvdhJDavcjeUq2PMww0x0FNxNCfoX0Q1l
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Zeng Chi <zengchi@kylinos.cn>

The %pe format specifier is designed to print error pointers. It prints
a symbolic error name (eg. -EINVAL) and it makes the code simpler by
omitting PTR_ERR();

This patch fixes this cocci report:
lib/alloc_tag.c:776:63-70: WARNING: Consider using %pe to print PTR_ERR()

Signed-off-by: Zeng Chi <zengchi@kylinos.cn>
---
 lib/alloc_tag.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/alloc_tag.c b/lib/alloc_tag.c
index f26456988445..27fee57a5c91 100644
--- a/lib/alloc_tag.c
+++ b/lib/alloc_tag.c
@@ -845,7 +845,7 @@ static int __init alloc_tag_init(void)
 
 	alloc_tag_cttype = codetag_register_type(&desc);
 	if (IS_ERR(alloc_tag_cttype)) {
-		pr_err("Allocation tags registration failed, errno = %ld\n", PTR_ERR(alloc_tag_cttype));
+		pr_err("Allocation tags registration failed, errno = %pe\n", alloc_tag_cttype);
 		free_mod_tags_mem();
 		shutdown_mem_profiling(true);
 		return PTR_ERR(alloc_tag_cttype);
-- 
2.25.1


