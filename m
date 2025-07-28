Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FEE4C87FCE
	for <linux-mm@archiver.kernel.org>; Mon, 28 Jul 2025 08:40:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B3BDA6B0092; Mon, 28 Jul 2025 04:40:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ABDB36B0096; Mon, 28 Jul 2025 04:40:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8739C6B0093; Mon, 28 Jul 2025 04:40:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 728036B0092
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 04:40:20 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id CE97C1401D5
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 08:40:19 +0000 (UTC)
X-FDA: 83713026558.19.8B02D59
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.4])
	by imf21.hostedemail.com (Postfix) with ESMTP id 47C521C0003
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 08:40:15 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=ZJj2Z5XR;
	spf=pass (imf21.hostedemail.com: domain of chizhiling@163.com designates 117.135.210.4 as permitted sender) smtp.mailfrom=chizhiling@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753692018; a=rsa-sha256;
	cv=none;
	b=mZGGTwZ1J5EDCjWKj03ZcQI2PHvk4TCpskpXRTsGMsYJPSKnSIQbvJIZP6VAvV0TUzhxwF
	gPFqjoE/yH3avEi1daj2QeX/mPvANhgIMBiGjXpSnK3Dcym761Fx297egDZCxqXCs0Ofnu
	juRCjv70BFtLeCbTcoVgwwHP6I/FUTc=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=ZJj2Z5XR;
	spf=pass (imf21.hostedemail.com: domain of chizhiling@163.com designates 117.135.210.4 as permitted sender) smtp.mailfrom=chizhiling@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753692018;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=7baTm4RT0cCPJTWk6j4MRTx8jPrvZrZ12u79os4rrsA=;
	b=frJSYkaREKQaTnUszxj/X2cdX1th9y0yDiyPV4ik2eDmBzSwvH6SjvUbEtKOUkdn+DGpqN
	Lz9xFMl2xVXyPOuAZgowpcAzfC4/u7ZhjnZRJGu8Co0YgXV7VJKaO1XFCM6zKQiangoMha
	HM4sMxD2JRgOBHdSqfTBzHaqvsPv6p4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=7b
	aTm4RT0cCPJTWk6j4MRTx8jPrvZrZ12u79os4rrsA=; b=ZJj2Z5XRWs9w7ov5HE
	xoaWDhRkHnDuC09HSoskX/XOL9KRXSm3tD5zP3qVH7rdHYncv5P3JsA73B3W1SZv
	6s3yjV6Cs+0XIamOfILcaxlcgRuyraPr1GayfqcQjLZATazvzSiFO+iiuSgrc/rI
	wJovMAn6TJ/gWZWIetBDi6pxI=
Received: from czl-ubuntu-pc.. (unknown [])
	by gzsmtp2 (Coremail) with SMTP id PSgvCgAH9a9hN4doAzUWCQ--.8415S2;
	Mon, 28 Jul 2025 16:40:02 +0800 (CST)
From: Chi Zhiling <chizhiling@163.com>
To: willy@infradead.org,
	akpm@linux-foundation.org
Cc: linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Chi Zhiling <chizhiling@kylinos.cn>
Subject: [PATCH v1 0/2] Tiny optimization for large read operations
Date: Mon, 28 Jul 2025 16:39:50 +0800
Message-ID: <20250728083952.75518-1-chizhiling@163.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PSgvCgAH9a9hN4doAzUWCQ--.8415S2
X-Coremail-Antispam: 1Uf129KBjvdXoW7Jr1UCw4fJr4fZw17GF4fAFb_yoWfCrc_ur
	WkZ34kGr42yFW3Ja1xAFZxXrZxt3yq9ryfZa40qFy3Gryjyrn7XFZ2kryfuF1UXr4xGFsx
	GanrXr93Zr17XjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IU83Ef5UUUUU==
X-Originating-IP: [116.128.244.169]
X-CM-SenderInfo: hfkl6xxlol0wi6rwjhhfrp/1tbiFBSUnWiBj9Y5uAABs5
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 47C521C0003
X-Stat-Signature: orjmws3t1xc7atzydpga41kmt9rz8iay
X-HE-Tag: 1753692015-587064
X-HE-Meta: U2FsdGVkX1+A6vxm/x3ESDIwR+S88pKL161+U5XrE6OQkp1RQz2deLghSBfh2rV2tovpO5QDKWuDFDSEyvwL+gpz0MxElkahF3ReVUpZqG2ZW2gEfuXqzgH960gGHkeLozrO3VEA/CtxVO52E+8ASPvEDJX6lFcjrg7wq9mYGF7TGIk7CsgoL1ClsO1D6ZW2J1tLPX6LmQDWOzvg1bWzpa9DUZ5d95jbLpwJZ9Cxr+iYkp9GMh+e5cZ2IlyIUkFci3XEiFQIF2VNz57OcnokaH8m1kPzE5MlZfqqJbQEJWL6BvtnK7umQJXX4CtKK9USHNpchqCXMLJLVeUVoQHcPT+1jDWoY+8fPyk8rKE81mzltIw60oFp4pLBcpQsoPHYdVylwsC2tI6YB1TVF0C0BuQFHfLmyDSnBYHzlVqooA3m6erANETXPG8kU63bLYs8sSrsPMieGSWtaYp5rSMpEaBCpe3GvMhvj2CaVuU8VuGq5hDC0TgXMffPRXKgODGUxws1yX0mITVrulnQXYVv8imRNNCoSX7VL06uJTOaq1i+s/J4lZUUwBUh7hObC9d6M43Gfcn6vW/eEqk8sl/s7INyoeHMIU8uH9c0D4vfJl28suwyLa34hzEw8AZeoKmRU34p/svW41QbRBNjCECtEvTJCWOpKwaiQrfn+wwj4teQA1ZIA+TD3AlvRDUSJzdIJf4xoaNeuDgcbYKaJlYErGrOrkTfQdk2W7HeUnBHFm64+QJJSZOk51UBZMZbp+c5+kecrIla7Xgb8psf7pVGf6diSOJTeRRTFFKUlBxpIsRRifgxKCAk9KkKEuQXRzuJ1dEA0wvz0bWi4o+z/bh2SVft6mPCPv9wsaMIWJhrkQWtg/PxkNEiPw8cr/jZ6SkqECP2cSpAKhaHoSw882eEbKDipy/VGz4D+OXuj0lzXUFf69Ap3fAdiwrGSznzqZSOBorAn3gi4Iuu0Dqnh4H
 BZeJVesD
 5Aq5UbCFLj/6JaWF/h8TUmSw6nJ+GYN5EjL3GG76A25zrglMTLPtAqMdsLSKDgseglbbHYgYCcPE0SPPztUgew49uEfO5GncspL6c96B7e3Zy7njMeNMJn8CoTFf4WvVY08iv0G+W7NbUlE91Do8M2HYrcRGvuSxRyHUyasjqF3TI9Ic+d4zLpGlgKXuyIySSxQ0c/dq1gzgf4dwOk/xl7N9md+DiBkKHOqYPS/Xx0P411AE0Do28+p99ROekUwLCLCF4SYq5MxZPCzfVxD0Z1RUYPTk15dG2Vp/t1F/SKPJkBwxacaNR5WmOK+5D8f7nk+Ss1jzq2wOxiH4DNjU6ohSHu1Z/yosqlnL/R7+4m929fOPKAzkSInBjYXAgvcpxH8a9rxsWJlQNQFoQHZFbdHlgpBon1MQHCs9+tdz2p0NYbZRB7IFG7EYtu3Q+7/aekETWOmMlWr8FzO+QQ9bc3cHVmQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Chi Zhiling <chizhiling@kylinos.cn>

This series contains two patches,

1. Skip calling is_partially_uptodate for entire folio to save time,
I have reviewed the mpage and iomap implementations and didn't spot any
issues, but this change likely needs more thorough review.

2. Skip calling filemap_uptodate if there are ready folios in the batch,
This might save a few milliseconds in practice, but I didn't observe
measurable improvements in my tests.

Changes from rfc:
- update commits
- switch to the new solution which provided by Matthew Wilcox.

rfc:
https://lore.kernel.org/linux-fsdevel/20250723101825.607184-1-chizhiling@163.com/

Chi Zhiling (2):
  mm/filemap: Do not use is_partially_uptodate for entire folio
  mm/filemap: Skip non-uptodate folio if there are available folios

 mm/filemap.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

-- 
2.43.0


