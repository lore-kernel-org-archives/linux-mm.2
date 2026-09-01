Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 20DBAC624D4
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 13:26:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 89F2F6B01A3; Tue,  1 Sep 2026 09:25:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 850356B01A4; Tue,  1 Sep 2026 09:25:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6A2856B01A5; Tue,  1 Sep 2026 09:25:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3D41B6B01A3
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 09:25:24 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C9FBAA03B2
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 13:25:23 +0000 (UTC)
X-FDA: 85165264926.01.3DC2958
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 30A264000B
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 13:25:22 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cWAHzePq;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788269122;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Zxj0qXZlLFjv8Oo1ubEI7gb1ZBWWHlkx56zIdj50cXg=;
	b=4ULswYo/SPFASqg4BUPqW3SO/1rYZUUR6xA2OCJK5xGNsmB+3psFEDMraxdGjmVTzFXDq/
	H0kBLw5PVyqJUtBF+euyUgXuEgBKamc9GvTPCdee0FC/Fq+RQhbE5A4gspzzPb0fCoUqdN
	A6k9VKQIlN+q3YkSLbaPPomLU4TBJ5Q=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cWAHzePq;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788269122;
	b=L8Kk06CxRZaxpS79PTH2a3iJhcyqNACrfkmGmKYO38Hnh4/70sOtCF+nnwqJ+VgCSDdG3K
	Q96mfg42YzYKrObl4TjYY0/bWxWOl250huV1UBY0aAodXKucdEriCQagf89Ph/HF/lqb8H
	o/lly0NPcIhl4jztdt6xv0ocTX30Q+E=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C240C60515;
	Tue,  1 Sep 2026 13:25:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A0851F00A3F;
	Tue,  1 Sep 2026 13:25:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788269121;
	bh=Zxj0qXZlLFjv8Oo1ubEI7gb1ZBWWHlkx56zIdj50cXg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cWAHzePqxkYp0mQOl5mchlLIrWkjoVoUA56rKm/nitPJvcwqwOS/ikOO0f9dnYC7W
	 1FhMnWdS2tNxJFv5PK/FxkMOaxuZjA5xg3a4M9Wc1dlnMp7BIv9ji354EXVVfXqIXZ
	 omT/3TmcnE1B+x+rkFApZiKtd2URQhnb35VvEScPmWKnXlbtFYH+XNe31nQlIbHltv
	 fbDjO9EUzpJv6nhzRCsDz2dt3vHwMpXGD2J/HFyiM0KmAEe22duc8CNT9XuOjVYxeA
	 rDZaKaVdevlUdNP03jSyA4Aern5jgvlBDPX92E+fvmn2RHvDRXzoKDkgq0j6/FeM1N
	 kZyvKgZvrwqPQ==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v1.1 17/17] Docs/ABI/damon: document probe prep sysfs files
Date: Tue,  1 Sep 2026 06:25:04 -0700
Message-ID: <20260901132506.99243-18-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260901132506.99243-1-sj@kernel.org>
References: <20260901132506.99243-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: bxiw116y8nddbtqe9u37d8kf5p1gq6mn
X-Rspamd-Queue-Id: 30A264000B
X-HE-Tag: 1788269122-483225
X-HE-Meta: U2FsdGVkX1//80QY3m23FTqo9/x3BXHFzRQghuV319XfZiG4cRyqpZ+xZVxcLnQByThDjUSletoVbXz73iCJVSuGorlnTemSmtRc3rQZg9+VT65CpcF5o6MBZ0ICHI6QDE7Wxo+ZOm6jiYRWff0ozFOEc+y0QTP5TGD4mvNYaSZUMe371393XOByYjxOnuL/3w5+ntVTym9saOBSTBGBzPLwSFYSdJbNveUN2gixzzh8TgbdVlpDTA6BTWk38l/6GMo74JwOjbPcRonZ6A/8NwCjXF12LlGCusHo07n3nFovIjaPGXdpOi2vYQ5WQtEgqsLQEf8JYwijr0fqVVAox24LqUk8K9UEXfGXljP4WM7BEg5LsfhfJQDefTT/pOJvFvjYKRAK7S3tN1bVBv9GYziFHLKWLvu0IjL4mklctkU7fJ9JyXZwKrtQDpMLeaTvafjTjwv0AnesioDzzxkLd4DnOUuLYe7jpIcKThEGlozJkjTmuh5DNem15FLj9Pu+L2BO3aGhmSPJQaIEmq49VSzB3R2r0DSqZzOmYfORwJM6qcG6yDPw/1+AY77v6x2BI3KjWUa8XvV8tNMOLySfS2FCIozUl4ETkrfBHqX2YsOmzCk7GvWLpYVP7h7E7Zk/caj1jPqmOaoi5xpTaH92flF0Ka0SHkMH24TAVjY/IN0GKzwGrZXRC/rOcuJzmMsXmwDRDdw1f8Ia+EjpLtmBnDIsi+EXeo9pA4ihb8MUi2x8BdTCo1fF2+XYYWCi7salCjAIXbfiMHATmU/8zX3P289/NWlWIPQ0zZlx7N8RFU6KUeEmGVpTRnid9wyNsFpFSxvkmG/Ex2CXuVkiMSMS5gA7vkNXrVGS7x5wfXRXKFfC9rau7xWEf9oaBhZSTZgc/7/ecKEGj+Bp9S1WsDBDu4jU3H5xm2wrcMZgmeAaII8lj6aBOq6Xfb8i4dFFpLQiDsRf5KDiWNB/nLuqomt
 HQ70dp4p
 j/CxtthM7+lMLUicegfPT3gJ5ESxE0sCx24cp1HVd9r6PcRkFL+W6hrg1MXWTplnwkXikRioP/XFaUxG68wyxrE4oRapigEdqip3e6OWnK9tVxZv65ViFG+5DeJ7/30YgFD/hX3tpDEOvilPcXIU1W7uOxoc9MXO19RanFs1aS4VQL9Z5wv5TAZh6zacK89IW44we24vJS1DSOq18qe8+jJOatDl28V0CXxHHqYhTibv+xBBv/8ZPmR6t0tGpwt0GnjIo13I6a5mNkKg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update DAMON ABI document for the newly added DAMON probe prep sysfs
files.

Signed-off-by: SJ Park <sj@kernel.org>
---
 Documentation/ABI/testing/sysfs-kernel-mm-damon | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-kernel-mm-damon b/Documentation/ABI/testing/sysfs-kernel-mm-damon
index e675a57145e36..f8d2601e82904 100644
--- a/Documentation/ABI/testing/sysfs-kernel-mm-damon
+++ b/Documentation/ABI/testing/sysfs-kernel-mm-damon
@@ -173,6 +173,19 @@ Contact:	SJ Park <sj@kernel.org>
 Description:	Writing to and reading from this file sets and gets the
 		per-probe attribute weight.
 
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/monitoring_attrs/probes/<P>/preps/nr_preps
+Date:		Jun 2026
+Contact:	SJ Park <sj@kernel.org>
+Description:	Writing a number 'N' to this file creates the number of
+		directories for each DAMON probing preparation action named '0'
+		to 'N-1' under the preps/ directory.
+
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/monitoring_attrs/probes/<P>/preps/<R>/prep_action
+Date:		Jun 2026
+Contact:	SJ Park <sj@kernel.org>
+Description:	Writing to and reading from this file sets and gets the probing
+		preparation action.
+
 What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/monitoring_attrs/probes/<P>/filters/nr_filters
 Date:		May 2026
 Contact:	SJ Park <sj@kernel.org>
-- 
2.47.3

