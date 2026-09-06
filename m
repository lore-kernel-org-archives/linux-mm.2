Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 63E46C79F8C
	for <linux-mm@archiver.kernel.org>; Sun,  6 Sep 2026 17:50:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3152E6B008C; Sun,  6 Sep 2026 13:50:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 30FC56B008A; Sun,  6 Sep 2026 13:50:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 13C696B0092; Sun,  6 Sep 2026 13:50:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E3DC16B0088
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 13:50:20 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 785C8A0569
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 17:50:20 +0000 (UTC)
X-FDA: 85184076600.15.65BB6CE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id E5C67100005
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 17:50:18 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kckwBC9L;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788717018;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YFqbfbUKFKtPu4Tcg/+wjsywNqHMCK5UIyCPc9N/dhM=;
	b=wAS/TQD3L1oBNCqpSRCCj8scPosFjuHTunOQBILSgdNn6KPhWPv7U0KyGVa+E+QcjsWXbU
	v2uxYqxg80BG0qGLCl+oG0W2tXhU0vhmfc4RNc1xBPZ5gWDPwqrNHqVzmbaKPq9qBe/kzW
	AMCuksuMBqj+U5gZb9t2mn21OcYFzE0=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kckwBC9L;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788717018;
	b=vwsNYLfcOi33qE1uq8ntbhpximfhkV82WbuiNfegPfiFUtssCVKLUS2ofviNqAzqbZEkb3
	mntY3ZuKKF/G6uxH1Nv7dPDTEOPIXBEGi74YIp11iqxzOVq4JKsBwATPar3Gw3lbROUF1g
	fgolRGxTP4uh8CmH1Uv77Ej4ifjfRgo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9C38D60A6F
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 17:50:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CB631F00A3D;
	Sun,  6 Sep 2026 17:50:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788717017;
	bh=YFqbfbUKFKtPu4Tcg/+wjsywNqHMCK5UIyCPc9N/dhM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kckwBC9LDnSc9g5Qt9hX2Jg8RpnrPDawioOb7Ip3VrnszHtGfRL56TA9k5YmWynMS
	 WxHegJsm37AtALSqEafJvf+L1neyrMMv2zeh+CUJITuQV1XWhdGKXhKWbR+MbLsEbH
	 IT+pn7A5JQ4emDsCiEs7llAxFOdZrHi0bDjKAAM4lsqa5GIvkCRTWiGMmwaEn8icM1
	 Gf/Yob5fiQsRfeNv0ihDGTW5ODWLVILlLFTETmCw4RdO9wYdY2xzfuKfdyTemVuW+6
	 RJ1CLLIpqCXxiOF8OYN1FnrOnMdk9k2EUSI50cpaqfC6ffixedklo+MqfvW9wU1zyT
	 IEqu+nb23XWgA==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 1/5] mm/damon/api: introduce DAMON_FILTER_TYPE_PGIDLE_SET
Date: Sun,  6 Sep 2026 10:50:03 -0700
Message-ID: <20260906175009.93471-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260906175009.93471-1-sj@kernel.org>
References: <20260906175009.93471-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: p6a61k9skfff9ambw4q8t6z6ergpbha9
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: E5C67100005
X-Rspam-User: 
X-HE-Tag: 1788717018-86299
X-HE-Meta: U2FsdGVkX1+Pb37z/PS597Ft/L9E0M+znoReH1VnN+6gCk/V/mc+8xlTp1jv/XEG//9a9JZ/syJUfUf52b6IUW2o0+di1Zr3hcdu9qZy1wThfo9kxDZXOqNMJZzO+QOHJI7ytSQxJDYm4T2WzPFzSzGKWviWW2hy5j4mvI3Ymc3PP8cFlUYnoADncYhes2GrSkDyhzSa9yNYbPeFN0f237v18dYM87enfoYhj6ZUbaLjGKeQqG4QFZsSAvvLJaKVkGWBfShEcUfbrV5bh+PUxhN9T68jOVzafNys7hB/O+b5JAShM6rPPq7wFfJKiReyJhzUbQc42bMYBdHLcUhcwhoS36JwFfkP7CflAEGnfuGSTMckD70xfg9jgewD6gjAffa/4q4eZqfWID2UDOcZSXdw3TWa+vUYI/VG0LNJzn8wGwDcwc1MQWAP51q1j1kjt8M0PX9xyrh14YyNZEyZepKnb8lbQIvVd6GJZrXEgfGgm1oGExzNJvrwnSrBTHyn1EHN/QSLHljm1XOBqeg9RkOyadTB7/TXDbUAgNdd6fDb+1s/IcFs3x3TtjmUfSdh8+AWX10iGMDY39LVZvXZWWYwVVYqywj1EjeIN6DIMvbhg53AD7WMcxGFbk+hUjxbiZZH7PuAYEd4qFqQSlGCI/5Riv7HutjZZ0YF2ZL5Geag15PAk1yc/EaCd68XOSbyBPzFE9/GzL7XTn0TdUT/sty5qwc9GsIsvI3dkNmVYihpGFcan8EMDCt/S0QyLcbENieqCR6+Fj94BA8y4jIw6nXQXFO+nD4SgnT4Fqye1bf7HLuSpYjQ6r/hrY5N3Z6OSdhn1Pjr77Hv0bPAbks1ypte+C6MDqOJ7deRIGMIoW3Zyg9DC9h4QQRISGKSy2rzzOrFy0ZTR7YySGTovJeuAM1ylZF0/Bk69hvhub2gGaI+hXskcgWdHyVozhLTcBNhlrSscr231ENmntDm4OO
 9jPPU7wg
 ZUV+59UWiAmFIEittbDibuA2yxYNgy8TuQnQE2z6FjD00gQ2xlrxKQ4vtb3Uw+WwkSwg9f7YnVAt5yQp2XE460DRgUBm7dh0duIG7xsQrDVydprNSyt9AvN0QrTRe7WDdmRgbNDpm5tVQzod9rUr4Mrf64IKcDkWQIdvLqPB0lgCUCHN9cqCb2dSlffrx7e+ypgoCdV0RjOsRplGJe5+GQxzxEIEBe/5yhdboGIBKgNpID1xJ8i0uTf4KCW4WuHxZTEznx3yxcwHN1imPsTvAzXQLaVDTp0tF7tw8oFVmsPL1B4DvkH6aZ4PhdstV6PDfcKDjaLHuKuF7IZT9Lyklb8B2K1U6xPRg086Y
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMON_FILTER_TYPE_PGIDLE_UNSET matches only memory that was able to
confirm if it is marked as idle.  If the memory cannot be marked as
idle, it simply doesn't match.  Hence, finding memory that was marked as
idle with only DAMON_FILTER_TYPE_PGIDLE_UNSET is impossible.  Introduce
a new filter for the purpose, DAMON_FILTER_TYPE_PGIDLE_SET.

Signed-off-by: SJ Park <sj@kernel.org>
---
 include/linux/damon.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index 871d26adf6ae5..16800b3dc379b 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -774,11 +774,13 @@ struct damon_prep {
  * @DAMON_FILTER_TYPE_ANON:		Anonymous pages.
  * @DAMON_FILTER_TYPE_MEMCG:		Specific memcg's pages.
  * @DAMON_FILTER_TYPE_PGIDLE_UNSET:	Pgidle is unset.
+ * @DAMON_FILTER_TYPE_PGIDLE_SET:	Pgidle is set.
  */
 enum damon_filter_type {
 	DAMON_FILTER_TYPE_ANON,
 	DAMON_FILTER_TYPE_MEMCG,
 	DAMON_FILTER_TYPE_PGIDLE_UNSET,
+	DAMON_FILTER_TYPE_PGIDLE_SET,
 };
 
 /**
-- 
2.47.3

