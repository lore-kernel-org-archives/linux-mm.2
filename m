Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AE17BC88E56
	for <linux-mm@archiver.kernel.org>; Sat, 12 Sep 2026 19:18:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EA73D6B0099; Sat, 12 Sep 2026 15:18:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E30EC6B009E; Sat, 12 Sep 2026 15:18:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D47EC6B009D; Sat, 12 Sep 2026 15:18:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B63776B0099
	for <linux-mm@kvack.org>; Sat, 12 Sep 2026 15:18:20 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5A5B81C24EF
	for <linux-mm@kvack.org>; Sat, 12 Sep 2026 19:18:18 +0000 (UTC)
X-FDA: 85206071076.26.A00257F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id B115010000A
	for <linux-mm@kvack.org>; Sat, 12 Sep 2026 19:18:16 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IIQlp3wz;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789240696;
	b=v1oPNgat42w9KgvRD6L37h6CfKLHJW/AvXcvI1d8RRcxv7TCGulewn44/kgtPwQ0nCumLn
	ePVZYD1uYpMYYlmO2AV4D+VvX0rxatdfnhECsZFYwpe0F5UcDTLfPvtaPtWkOwvkoGxy8w
	YYUwIeYnB+XAtOzK6Rk63lcjPMvyEk4=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IIQlp3wz;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789240696;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=umQcJFGrr068QYat6Lud6jcAzEmAFL/l4IbhvroBRbM=;
	b=0Vm6rxCOIMqhJeQDeB5DJx3CyPPsmaEZ/rqWDS0/Icom5tRhmjNZOOVBEZn9bDkz+BqF8s
	qTaskEiZH6RBrKJF9xf0wrQj+qlEPPFBI9oiFSOEyG5iEJ7D+lkrlx2BQdPzR+2cdd8QYF
	ckJhCWXmoK1XuheQrUGYAPjmEarqNNA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E561543F82;
	Sat, 12 Sep 2026 19:18:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DA9A1F000FF;
	Sat, 12 Sep 2026 19:18:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789240695;
	bh=umQcJFGrr068QYat6Lud6jcAzEmAFL/l4IbhvroBRbM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IIQlp3wzKOpey5hFACaYAcYubZeCZzpy4jW7JRvFX3EnDFe19Wvhlod6m6w33Z7tV
	 PXgT8/PVZay2PbPBjwmT0xoWGGMaih9DU0VSOl0CW0QXU7WC4/4gpqYN1KiJXVWcYY
	 xqxOQDJXROO4+1DOsXOWDlwSL7FzgkJ6tJvi7phI46CLd5/dn9fToOmI7MCBkXhj0e
	 4FkwB1RGgH94d1WaxXUW4sYYGs717WsRxtzyl5ICdKtdkuGIZVxl5Bz1gKBy94pxwS
	 8GMs+z/oOmOvqQ3/OTosoAUHFHiMx225mjE0LXBhVE7aA4M3I2O9dNcJs9cKhD2/p0
	 5vG77Ph2DAHpA==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	stable@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 1/8] mm/damon/sysfs-schemes: read sysfs_filter->addr_range only once
Date: Sat, 12 Sep 2026 12:17:59 -0700
Message-ID: <20260912191807.138502-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260912191807.138502-1-sj@kernel.org>
References: <20260912191807.138502-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: B115010000A
X-Stat-Signature: 41i4qphor6wfb6bbed8g4be79z3pi73s
X-HE-Tag: 1789240696-465121
X-HE-Meta: U2FsdGVkX18kbguBk5B9mViDzcU0CmjOK9uJ+Phw0aHi8byX2lkXONMmvKnNLChV2/ZchAraVvSmd2eX+uRFLq16RamhaS1lG+6TxKkw+P9H3/O86fqqzMEkDdcK13W2yByjKerV4LbI3GZzpM0qOMqjLmZrvXx6jG+55nJV9ux7S2fYUUnVlEOtxtOssql+K42m7Tu8+Ndpa3SPVAQgLUCYDYIPMuOX2lsZN3uSRf8nFWLy14172y7JNxycQTv28QeOKvHuMNKgn/Kj/qmJn71IwX5+Pt/kvG9Xu7+ucIIhmap6jIRRzX6kVIGLRx3b2dNoVOa0wU5p8HlB02rpNrhBKuvL3aw5yYjncaSh+5pU0P+A750Z8LX9LxAheIAxn2nTLuS6vULXcHMqqBfljN/hA0Ft+HrUILmVkcTjp6JZKvjY3dWrWEyz/Uci9VI1x51NhgY9NbdR+EAfCalycxS1MYrdbBdZnUZFtr8RDBRGSWLehwppWcV/FH70dl4IkSRBSpBXG+ZgcHWQzRfIokbXa9cOjTxeW/Ul86/DO0kyxbL9ldXfUeQagswrLlgZXccSCQ79HDCboo+aXOHTYiw9YmqbaXQa0653TRvEaGsI0K0LgJJ6BjGRfC7n4g2CtwTVltn1Z0zdurHhcPGeqKWWp0IS2g+CiZEifuPFZMJsas/JarOMITpiN2BXJQJ6rPALINlp6kPMJpG2hZvKFGIXbwigQeETCyQkxjLzo45HwiId0toaezkuS5/MWDsBJLeZ+fhgCXFR1LnFZPqk0Wu62ZzYpZrdnYCnTpFGnCOTz5y2aIV3RuDC6Oro5/lds90fh2C/GxY914a5rz6WEmSRUcf1ryr9QcQ/hsuHnbiRiwSOVdwD7xqnITxvoGPONXGXLxp6Mmk/QUvEf+N2ChDtirhErK3W1FDp5ZlqsaEbtEidsGmqSsBI1JWfKdZjx+FzCGia3RNyuGpQ0HI
 i/iEmiZm
 rk3VXvY1aFP3Ounzg0X9zqJ2ABSunr3nw/RGfirVz36GTokQt9Dj5Dp+1nN9zjoWG2yQ/PthGArQh+pT072gNAjU79oavJzayyjeb76MtAIDYgvtp9O/CxwpGaG86GTj9llcnLZ55gSQuPxK5xGgas+SsMsBDzWKyOw5OQBXrFIJVsAZKYdZvXo1vmNsB0BriaVteoNdIpsT4jCx/ymPYZSFE9BN2wDTGdSIFH6Fl2ia7tOY8+755vgmjn77unkrmcdJx1rFyw8fDQLIHJi+uHl/TYA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMON sysfs interface reads the user-provided address range arguments
for addr type DAMOS filter twice.  Once for validation, and once again
for assignments to the variable that will be passed to the core
layer. If the user updates the argument in parallel, an invalid address
range could be passed to the core layer.  Avoid it by doing the
assignments first, and then validating the assigned variables before
passing those to the core layer.

User impact of the bug should be trivial.  From the core layer's
perspective, the invalid address range is not really invalid.  It just
works as having a weird address range.  No critical issues such as a
crash or a leak could happen.  And sane users ain't do such parallel
arguments update anyway.  If they do, such racy behavior is arguably
somewhat expected and deserved.  That said, there is no reason to keep
such races.

Fixes: 2f1abcfccd86 ("mm/damon/sysfs-schemes: support address range type DAMOS filter")
Cc: <stable@vger.kernel.org> # 6.6.x
Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/sysfs-schemes.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/damon/sysfs-schemes.c b/mm/damon/sysfs-schemes.c
index 3de4d804e049f..3c1c1cb387fec 100644
--- a/mm/damon/sysfs-schemes.c
+++ b/mm/damon/sysfs-schemes.c
@@ -2831,12 +2831,12 @@ static int damon_sysfs_add_scheme_filters(struct damos *scheme,
 				return err;
 			}
 		} else if (filter->type == DAMOS_FILTER_TYPE_ADDR) {
-			if (sysfs_filter->addr_range.end <
-					sysfs_filter->addr_range.start) {
+			filter->addr_range = sysfs_filter->addr_range;
+			if (filter->addr_range.end <
+					filter->addr_range.start) {
 				damos_destroy_filter(filter);
 				return -EINVAL;
 			}
-			filter->addr_range = sysfs_filter->addr_range;
 		} else if (filter->type == DAMOS_FILTER_TYPE_TARGET) {
 			filter->target_idx = sysfs_filter->target_idx;
 		} else if (filter->type == DAMOS_FILTER_TYPE_HUGEPAGE_SIZE) {
-- 
2.47.3

