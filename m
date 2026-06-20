Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6D07FCD98E4
	for <linux-mm@archiver.kernel.org>; Sat, 20 Jun 2026 17:14:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0D0986B008A; Sat, 20 Jun 2026 13:14:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 082106B008C; Sat, 20 Jun 2026 13:14:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EDB866B0092; Sat, 20 Jun 2026 13:14:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C721E6B008A
	for <linux-mm@kvack.org>; Sat, 20 Jun 2026 13:14:31 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3E27C1A01DA
	for <linux-mm@kvack.org>; Sat, 20 Jun 2026 17:14:31 +0000 (UTC)
X-FDA: 84900939942.18.40BEAA4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id C784240002
	for <linux-mm@kvack.org>; Sat, 20 Jun 2026 17:14:29 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=klcEEeG5;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781975669;
	b=cHaig/4RY/XmTcnxWFlkNQLQHW28i5fhotL4Yx4AeOIGe3KRD6urF79kbxRx3HT1uwW5nO
	IJBkQM/ECRq9fH1zA+E0e1NXFWBvfg8FgZrL+pP1IUCo9tJEpduwo7xi3dxxLHCUaOdXI/
	GlGYUbVKmnB97q8kgxu8ZuB5n9J9oP8=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=klcEEeG5;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781975669;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=a6OOm5mIlaO4OHi3hOERfzN/vc5dfThAoOyHWEebZLc=;
	b=j2Lv3Z0nTbFg3ewlrlFlxfbFM5WJhoYPPSQW5ucwUIzsK+OegaO3uRLNOhGnM/VH+LrCFc
	nO4OmFrgLBei4CsW4scKCTZmDna91nYH/OeDo1MRUwUrfqcnrLIrzkDfYqYhc7/wtBt2Le
	J2RSST5zUG1/VOO2kksvsyIoanzaJGI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 311AE601E1;
	Sat, 20 Jun 2026 17:14:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34B1B1F000E9;
	Sat, 20 Jun 2026 17:14:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781975668;
	bh=a6OOm5mIlaO4OHi3hOERfzN/vc5dfThAoOyHWEebZLc=;
	h=From:To:Cc:Subject:Date;
	b=klcEEeG5r26a752OnGHWbItqLU1kKKo46ac8VLwBGsFHh4YmfAP4a9hs3sNU1/D0W
	 6mrdpuhP7/fsUJRbDiyLfUw7Nd0McK5X6oSG92ohLLEwJQW0KvJE7nNA2RPxZPKKto
	 hBXzW7FlMVEnDmZyJatR5w1zD7cuecdayNSZ+yByNCElJFzudbZq2AuUIr1DluRMFn
	 pAdn5vGiJ1rZzu2G3WU/rT717w9D5dn4qaUYA1QVDS7R8ilTM7RhKw1K+iZrcCNDJy
	 6XGsDDxcvGusUf6ecl1W7tI6H4wnxf7NtAkDScQDOb9x3g5o88/TelXd3b+qt09XvQ
	 GTDiBkfHgY/Yg==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	"# 5 . 16 . x" <stable@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.1] mm/damon/core: handle zero intervals in damon_max_nr_accesses()
Date: Sat, 20 Jun 2026 10:14:12 -0700
Message-ID: <20260620171413.89555-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 78ff91akn7rrofnnt3qm13h89joaw5wq
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: C784240002
X-HE-Tag: 1781975669-242336
X-HE-Meta: U2FsdGVkX18VORnWAv5f0L+sLXp4GWjfwGuRP9O7ove3DrkB003RQXPJFYJQb2UTGPxWU6yp8GhkrWq4YFxNrN/XHvcG3AcR6tpUvpsVXgIVUb7QudTJ3+LmzYKU/x6jUon3ErDuQ5ObpD+zSwyWBeGVRuQz4zahgP+Il6wROogs5OrXCw8Zua2kAQwGBRQhCnbefpkjM0+qqwBt798Ggd92aMZ9HDxLSxWie08JzG/FyV2NSNnh4HAXJmCcfNGcGqCvv3jDVStHADQkxaFEdhoI/zZj4mGYrHAh4bAEo/Q3Yt9uK+h+jt+OlsWEjRBlkMC9rF4rvrJeSj0HXLEwLlHIo1v1k/Tck09XSU8YeWPv0wcL2EvL8YXvWUneNPkDuDzWSmsxfU1abomVl8OsNGq7wpp7pAx31gJKHoGwV77k/ie/19CmsS4lfkHtp5MZnHJiWDUiG+CZn3M6kBoUkzgRQ7L6wLYAD9vkuVh7I+mEzKwiuwXEkhRVWYkMRKACkSpLYp7ezXfYzshYu5waRVvUxADL8fbFWxG43bNeJj/T5ymuZ1vHn2H6iImF1v5x5ptpQsWa6IQGmBIASRDzz6/H58dvZQLYAiagyxrlMJT+nY9A4BwEkk/JKfdjNSIF/r+DZRWZTYMyVJG1jdpP/wWOYbd6Y2tJuTrxPkgtE5+JPuedcX3GR+k2qBo/rVzcuV+M+NqTeWnX+ZDZwIJDgAbBHdWOLc5jMdtTGMSL0WvIaElWOmKpEVW+IfWi02QjiVDiFw0iaym9oAZMkcISsfyfg46hsYP1p71mdXwsUlWNdj29dhXNiX3l6IemNI8pltUBxUZoPhRnHK3eDaMEteeRwSay6/J6yZXPyj70ZOGpg2VFdEe+moPPg+5RxaeE5gSp94XyvKOvpxCdxiObv41sAyCYR8Y0QeagT0UOEQ6y2pcPGFMwV+orpjIM1kQl48c13J2UnryF7q/ljTG
 WKO7aIUD
 tsP5yaCdn7m86K1MidIvuHSsvxtAq2jTVw1c7GmN8Pz6kOTBbHZnviOY9QYHtYCKGvenLNkIdd/PKs0jl50TTgD9Q/MRHkuWoh1V+J1tortT1zzuA12ufzshYlq9H/9QuAU3B2TU5lgx9prKO/5TiOTqByIYg8fmQZlQuThDNfvUMhYC68hOOdY2lX/BWiU4szQ8+XAPGe+rKnpzsRho1hR7HQo3oHvqRKXbk+AwltGci9AxA3Iu5YNfUlYaxQmHJoknaslVF/OXek+ecbf3DxPHPsA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_max_nr_accesses() causes a divide-by-zero if the sampling interval
is set to zero by the user.  If the aggregation interval is set to zero,
the function returns zero.  It is wrong, since the real maximum
nr_acceses in the setup should be one.  Worse yet, it can causes another
divide-by-zero from its caller, damon_hot_score(), since it uses
damon_max_nr_accesses() return value as a denominator.

Fix the problem by setting the denominator in the function as 1 when the
sampling interval is zero.  Also ensure the return value is always 1 or
greater.

The issue was dicovered [1] by Sashiko.

[1] https://lore.kernel.org/20260619202459.145010-1-sj@kernel.org

Fixes: 198f0f4c58b9 ("mm/damon/vaddr,paddr: support pageout prioritization")
Cc: <stable@vger.kernel.org> # 5.16.x
Signed-off-by: SeongJae Park <sj@kernel.org>
---
Changes from RFC v1
- rfc v1: https://lore.kernel.org/20260619205144.150664-1-sj@kernel.org
- Handle zero aggr_interval case.

 include/linux/damon.h | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index 64d75c78f4df4..02ac34537df9a 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -1066,9 +1066,13 @@ static inline bool damon_target_has_pid(const struct damon_ctx *ctx)
 
 static inline unsigned int damon_max_nr_accesses(const struct damon_attrs *attrs)
 {
-	/* {aggr,sample}_interval are unsigned long, hence could overflow */
-	return min(attrs->aggr_interval / attrs->sample_interval,
+	unsigned long sample_interval;
+	unsigned long max_nr_accesses;
+
+	sample_interval = attrs->sample_interval ? : 1;
+	max_nr_accesses = min(attrs->aggr_interval / sample_interval,
 			(unsigned long)UINT_MAX);
+	return max_nr_accesses ? : 1;
 }
 
 

base-commit: 7a58ae62cdf3c006a53b805bbb12079ab2621a07
-- 
2.47.3

