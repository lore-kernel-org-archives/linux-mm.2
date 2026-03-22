Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 56FDAD58CA3
	for <linux-mm@archiver.kernel.org>; Sun, 22 Mar 2026 21:43:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 95D906B0005; Sun, 22 Mar 2026 17:43:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 90EDB6B0088; Sun, 22 Mar 2026 17:43:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 824D56B0089; Sun, 22 Mar 2026 17:43:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 74F2D6B0005
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 17:43:39 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0624CBBA9E
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 21:43:39 +0000 (UTC)
X-FDA: 84575026158.22.26A9327
Received: from sender-of-o55.zoho.eu (sender-of-o55.zoho.eu [136.143.169.55])
	by imf26.hostedemail.com (Postfix) with ESMTP id ABD96140002
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 21:43:36 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=objecting.org header.s=zmail header.b=VFViA9ye;
	spf=pass (imf26.hostedemail.com: domain of objecting@objecting.org designates 136.143.169.55 as permitted sender) smtp.mailfrom=objecting@objecting.org;
	arc=pass ("zohomail.eu:s=zohoarc:i=1");
	dmarc=pass (policy=quarantine) header.from=objecting.org
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774215817;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=Yd2jmjR07bIuf6kL6KzUQ4C2XuJusyaCQ+MvK4c3VRI=;
	b=c+IoFb3u87wT6rO3W4RxxI3BROr2325BUYV5Fmuf8EIGd+neOou5EqIJouPI2mRhzTZ5/K
	zkwIGiA+lXGXqz3ZtS6XVsaGC/JmayObv7XatP7yb04ABLzJkcAYHh1aSuwOP2t7Am4uyv
	DNUTuFrzNK75jG+LJaBpgfWGCkF9p9A=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774215817; a=rsa-sha256;
	cv=pass;
	b=P3ABGaIODf0nqxPwcWM6jmgQA9NsuhRlISlIegyXT8bExQlpvdOyawk4El/sVSTZNC25kV
	66RQ1Ddq8k7QITXvDM3pc/ly9LXamy2bRL1ciIsmcuPr4px+ZUTQ96n1LeeqgoHxTskpsx
	FkjJDy9QjiC3mysy6xmO23qHAZ6ISnU=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=objecting.org header.s=zmail header.b=VFViA9ye;
	spf=pass (imf26.hostedemail.com: domain of objecting@objecting.org designates 136.143.169.55 as permitted sender) smtp.mailfrom=objecting@objecting.org;
	arc=pass ("zohomail.eu:s=zohoarc:i=1");
	dmarc=pass (policy=quarantine) header.from=objecting.org
ARC-Seal: i=1; a=rsa-sha256; t=1774215806; cv=none; 
	d=zohomail.eu; s=zohoarc; 
	b=G1FORsx21FlaLlrJlmWEQOWMt8Qjsww9G/CXKr/bP6W68g2OGSr4As1pYzn5ZG+ogj28z3R/jWjEFbfYKCgom6+QnKby7VSyyGJ02DN3I1CCyVbPRHpTPjXJMS8Gi+jqkMq684QSCf/KbEQSGVIUcWwlMxqrHwHvjqlmwDNGdSc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
	t=1774215806; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:MIME-Version:Message-ID:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=Yd2jmjR07bIuf6kL6KzUQ4C2XuJusyaCQ+MvK4c3VRI=; 
	b=jok2fEBgVv7HZ3ICJcOKbz+7mIy3BfiZzUvbnEl83mJnCTJG9Ilu4o9PyhfBkQr1rbuu8vA0eziThl4Bfe4gh4XBurLToAVPV0or02mPBoSfYZKaabOH00b3aXxVYz8ZSf2qrb24Zzx3ja8dCp58RkTrSQFTSpnpT0SqvzpOJds=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
	dkim=pass  header.i=objecting.org;
	spf=pass  smtp.mailfrom=objecting@objecting.org;
	dmarc=pass header.from=<objecting@objecting.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1774215806;
	s=zmail; d=objecting.org; i=objecting@objecting.org;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-Id:Message-Id:MIME-Version:Content-Transfer-Encoding:Reply-To;
	bh=Yd2jmjR07bIuf6kL6KzUQ4C2XuJusyaCQ+MvK4c3VRI=;
	b=VFViA9yeCN6ITvIYwQ7UNJa96wS70A7og/Eadhz2z8GGXbw8/mw7Z1d/neqFY9gv
	yfpASvJ272WutR9I2t8yUNGFdFWc3Mz2tBiHvTD5OqNQuFVYJkRpfSlnq9R5AxKVwx7
	Dru5aJ8jUPqelQbXA61n0RLgjqjboHenlJ8W5RI8=
Received: by mx.zoho.eu with SMTPS id 177421580593959.57310327386517;
	Sun, 22 Mar 2026 22:43:25 +0100 (CET)
From: Josh Law <objecting@objecting.org>
To: sj@kernel.org,
	akpm@linux-foundation.org
Cc: damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Josh Law <objecting@objecting.org>
Subject: [PATCH v3 0/2] mm/damon/core: Performance optimizations for the kdamond hot path
Date: Sun, 22 Mar 2026 21:43:23 +0000
Message-Id: <20260322214325.260007-1-objecting@objecting.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: ABD96140002
X-Stat-Signature: 7nf6q7xqnz1qc3i95zmefy5yg8qbq4tf
X-Rspam-User: 
X-HE-Tag: 1774215816-915988
X-HE-Meta: U2FsdGVkX1+UxhW8lxYJeEWSu0c+Ai9ozm3GA79YA8nzNOJJNx27N8wRC6wZdBIaB0esN6w4ukRO/yB6LNTZzRYnFYRGd2+gKIHk2PxMn/ADDV3zUahuexYt4kp6z6bPfhlFWOl32Neapbw2xJ2QstZRqYGsBuTkpJPSriicxCXN6jFUA1HSeGNn1fUUDU0kCrLd49NIcGreL71TDu8ix9Mrpdjv52FULOpuckjxgDUCB549NldEtYYB5jsfIrOSHACrdWGa2FvBbqi3EL2z3u4GiHkfuNiXhC4G7aCGg+2gTBlmiqxSWbcJnYe6/FY+1SJKhLFAntdG+PgycJExEVq9TjzhQqofBx97h7ubYM87/NDgZNIet8Jbfbc1aGRDKuFA5PsAfJYONtHAqod52RFWYhpPYOfPSkYu5EPU/m5So5WuxtMN3u9pHnkLar3NQMmSiVybpdF/3P24LK38SpaBjoBO5MW5DNgOS2aME1+Pw5fofSmRfUnmzysbJULDAE66GDo7sQCbBYaBIZuspy9D5dYRE59NutwgSp08S6Jae9Or/mBny6Lu109b5Qx4IUAUOBl2IaGPQHbKoz1tFXgi3c4EqesO/TGWhjLCKNwor4anLqiaGQO447zOZ5oZ6as4GtB4mOnuol0xlh6exf54LoJ84YbjyUmmpSo7DMDH8j7RPMqfqev7swtpHZKFsbOoqWWQJV5ocG9OqFIq5KU/b+9niSchuuCWjIOQZEjVzOJc1ceCOyoDiFk5AoSkUs0n1MWk277I8Zn0S0A5i5PI4bP1xBZCeMx1qhsnd0Ohqx/KG1jfMEY+xoH1Jx20J0tyuQZ05QTffTvy1jR4OuWbaml6mzlFD6tjkt5/3xQsGYvKIo7fNYZGwNEVS06Iqluy3K/NcM7Z47SPOZMp6F2YRTSrArDOlUT0RsgnGRhLnH4zx2yXEc+hCfEEeIFCBVNB1V15i56UDwNtziO
 HblyYgv5
 /FbC5FA5aDMRsPlE9pXFpCqeRsG5MFd/47cHviB8T9pnV2K16yMyojnIRgD7XfqzDbmUEAOrXCIVS6zzkIvsUHalbYBv29oHwSBTi1HyneCN0JL6QVM5eoCkRXbRxxy1wo4c2L2nRZX1396go2MljdUYiQQ+VhaHM5zNSiBPpN4/DTwSUAnPAyPmQCbnbfhmGoPURrZtfVdQ/HOdk/F5Fuw8/MTFYDMFxZswKSzwdSj6MTyct+uuOtT4+6XrYRAMgNh4iZOrV8BazZEASHqfgN8xB2G6eZIEOqpFrWT1I9BBkmTB7sgYqRo2SxnOE0RAMDhfm
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

This patch series provides two performance optimizations for the DAMON
core, specifically targeting the hot paths in kdamond.

The first patch optimizes kdamond_apply_schemes() by inverting the loop
order. By iterating over schemes first and regions second, we can
evaluate scheme-level invariants (like activation status and quotas)
once per scheme rather than for every single region. This significantly
reduces CPU overhead when multiple schemes are present or when quotas
are reached.

The second patch eliminates a hardware integer division in
damon_max_nr_accesses() by using the pre-cached aggr_samples value.
Since this function is called once per region per sampling interval,
removing the division provides a measurable reduction in CPU cycles
spent in the access rate update path.

Changes from v2:
- Fix multi-line if statement alignment in the first patch to satisfy
  checkpatch --strict.

Changes from v1:
- Use min_t(unsigned long, ...) in damon_max_nr_accesses() to satisfy
  checkpatch warnings and improve readability.

Josh Law (2):
  mm/damon/core: optimize kdamond_apply_schemes() by inverting scheme
    and region loops
  mm/damon/core: eliminate hot-path integer division in
    damon_max_nr_accesses()

 include/linux/damon.h |  3 +-
 mm/damon/core.c       | 68 ++++++++++++++++++-------------------------
 2 files changed, 29 insertions(+), 42 deletions(-)

-- 
2.43.0

