Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B0044C4452B
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 02:38:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7258C6B00BB; Tue, 21 Jul 2026 22:38:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D7BC6B00BA; Tue, 21 Jul 2026 22:38:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 59FDD6B00BD; Tue, 21 Jul 2026 22:38:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 291D26B00BB
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 22:38:16 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6974D1A033A
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 02:38:15 +0000 (UTC)
X-FDA: 85014853350.08.5DC0ABD
Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	by imf01.hostedemail.com (Postfix) with ESMTP id EC24D40002
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 02:38:11 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=CHwvJqY9;
	spf=pass (imf01.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784687893;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xcXo/rp9lf5MHL56oBcTVaqzJO6EIK+nDvQX1m6EcZw=;
	b=DRcCcryNsb9AaRpXRARNb9kz/98Pda9ipMRFrVYDKRMao06cw+ZSntYPgybtPc4CA79c/s
	QwdT0eX+qAGlC4kMGdlVvpVwcFba+ZhhmUDUTvyyH4j1oxSbYoyrFmLJYXf6BfNsiiZyNF
	b4b+8quzXMcu6td1WlVpEf7gclduwKM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784687893;
	b=cCbtHCdiumH+aJnFmDUuxYqWwrwo22LSapFsh4ckTmQ6GxqjkOv0RkopVQzPG1/fHaQJeK
	GyDVkA3eJdf1i4FRXNlHcEUr3NlYH3LmDwq1D30TFvfjY3YzBILXCSrMQEWXsLeeDOOSZo
	jLh/jes3n0PvhS9ZeSPkruyzV1FubA4=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=CHwvJqY9;
	spf=pass (imf01.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784687890;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xcXo/rp9lf5MHL56oBcTVaqzJO6EIK+nDvQX1m6EcZw=;
	b=CHwvJqY9d1sj/rJecTZrAu3S91sbYI2+l89uTlpF79frfbvLnfz8w30Znc4r8nKthtKYRT
	LvKt9FQAJdtwZfTDGq9rODamsPUOSvapgHVlxYHymAijUfuzY7/zxi+gfM4zHZmlctCjet
	03JQyIo1FFq1IzmAZtl4RL5uUXnr9t4=
From: Ye Liu <ye.liu@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ye Liu <liuye@kylinos.cn>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] tools/mm/page_owner_sort: show available sort keys in usage text
Date: Wed, 22 Jul 2026 10:37:26 +0800
Message-Id: <20260722023726.600200-4-ye.liu@linux.dev>
In-Reply-To: <20260722023726.600200-1-ye.liu@linux.dev>
References: <20260722023726.600200-1-ye.liu@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: EC24D40002
X-Stat-Signature: b8nhyjpxcwxdxax7p6s4f48me3riu5pc
X-Rspam-User: 
X-HE-Tag: 1784687891-935214
X-HE-Meta: U2FsdGVkX18S7a630fPnQda7J4qwhGCoi68kVTba29EWJZl5XSt4C6HEI35LNLXNv9tQZjy+u4WedhEfDbRtPTkhNwrgO9Z8ZcSmAAJK0HzAVcLeV384X2n8YLaozdWieHTM8rIU9keJ98dBe9j5E2yNIcTIXrIv/pTnJRMEJ4yEn/W3V1YpEykAwr7wmTXgxZjxvoG4Wo1QmYbWMIB47/wRTBAvkyomXsFJ+PhjZCI9HFo8vwO09VxOxW061TdJrYUJr4mVxTFCEVCVhCFKU/oxvipPDAYI573lOwS+2+1wFunNG2w8oqGN/Kw30vF3GxOjdSJECJUY5yCVXkdGIMdJ2yLZIGobWAFuOLTjN6dyh6jr0Ipe62zmEaHG4uTEtOcxZfG2jYCtOVWM1k9tKyPCn+EWmJork+P0511tPmTWdlnKPmb+2df0/srSFpJ0mkO+rvMmKh8fQazacgg0YLm7e4lq9lqvz1PYE10yceLsU3jY73ESmOOnrEZHRIrjFY+JKmvgQFnAn7pRi8/l6vorfxJGQeiwRdbsiS6HeF5Ghlxs5PZM/ttU92TRSNqJpEDwXjdKNfIN9fYOT1wwc+Z5cAtTD2KX3LbwhJEsXXmcePHBWIVknlCngAR18xq6GaifGSoeEfDg5jeanWF3DRtZOrNHbVwbO7eIeHcrt7lTK8jJm6DVQIP0Cr+hROYBNCyhIFRoX022GuakKRNVYytO57XL2eGjFCsp9sMC8Z3+/+lkKh+K1g3J0/7gqw7qML6LB9UegDycWGzoPmt1rAZskemmjuTDPRf+TJMLu2Y9BlXw0E/sB+P3P+FqyXBf/G3BUBlVYAH+gamrgSPoXfu6q3Uzhk1rB3gVoONPsYCvHjfn0Y2fGnftmu3PZhsTPdbPTGsGka64nRnJaNNPEnzkvsl3ec+F0i5x1yvzTSG0p4KUuzEP6KmmyYdtGAebsR2bG4F7+nD5uHP1M6S
 p74NU6vY
 0mkHqUnV8sJ7mIM0U19EIiYR22mKnFG8gMp9W3lBk4FPMuFMdXqrjxMpVBFvpzpdxw9IUSj7eARzcvsR/xCpHEIPS5NAMJyBC8RkDul2sYLATNnGdg/pH1N0NG6hLUJcxWh1+Zdp+OHlA8e22TdHeYiSNyKsT36OCOp+3ywfTjGcesmMheNXdnZjHbEOeUpJqqRb0MfHsUqr4sLUW3lIPFGhwTZaC7/+C4y0sJXCH/FhoDkr/y/yf2bB6OQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ye Liu <liuye@kylinos.cn>

The --sort option accepts abbreviated or complete key names, but the
usage text never listed them.  Users had to read the source or the
documentation to discover valid keys.

List all available keys (full form and abbreviation) with a brief
description and examples directly in the --sort help section.

Signed-off-by: Ye Liu <liuye@kylinos.cn>
---
 tools/mm/page_owner_sort.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/tools/mm/page_owner_sort.c b/tools/mm/page_owner_sort.c
index 22e1761468d4..7a1bc054d295 100644
--- a/tools/mm/page_owner_sort.c
+++ b/tools/mm/page_owner_sort.c
@@ -762,6 +762,15 @@ static void usage(void)
 		"\t\t\targument in the form of a comma-separated list with some\n"
 		"\t\t\tcommon fields predefined (pid, tgid, comm, stacktrace, allocator, module)\n"
 		"--sort <order>\t\tSpecify sort order as: [+|-]key[,[+|-]key[,...]]\n"
+		"\t\t\tAvailable keys:\n"
+		"\t\t\t  pid(p), tgid(tg), name(n), stacktrace(st),\n"
+		"\t\t\t  txt(T), alloc_ts(at), allocator(ator), module(mod)\n"
+		"\t\t\tThe \"+\" is optional since default direction is\n"
+		"\t\t\tincreasing numerical or lexicographic order.\n"
+		"\t\t\tMixed use of abbreviated and complete-form is allowed.\n"
+		"\t\t\tExamples:\n"
+		"\t\t\t  --sort=n,+pid,-tgid\n"
+		"\t\t\t  --sort=mod,at\n"
 	);
 }
 
-- 
2.25.1


