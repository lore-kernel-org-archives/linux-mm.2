Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 60D80C88E72
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 14:23:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3A8856B009E; Mon, 14 Sep 2026 10:23:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 28EE96B00A9; Mon, 14 Sep 2026 10:23:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 109846B00AA; Mon, 14 Sep 2026 10:23:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DF9A16B009E
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 10:23:39 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 24A0616010E
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 14:23:39 +0000 (UTC)
X-FDA: 85212586158.14.DC56288
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 92F5020009
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 14:23:37 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Kh0m6NXa;
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789395817;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SymGB/Aunbf5NpktH/MrAmxXwvCzvOB6NopidPvvPWo=;
	b=csDlURyEog4cVU7jt+8UnhVhI3IMyKogzIQiBqOtzRXCbZSFJK94Q/nTxMhhOKn0g/0BMm
	kme+T6kWgdXEokLpMWTjMBBVg7mB9N/VWrUHzuGqtWEXHN1ge6JnAuLqYmQx8bcqUow1/p
	HZa9lG8kgFbg3Hcbp6710Te6QSgtcfY=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Kh0m6NXa;
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789395817;
	b=1dcG36PcP4N9TuKcyLS6edM6eU9/3oe2sSKWfUiFVycLNwwtviCp1sz1+2xP+EGMTqBIMW
	6oVup5dAD4Kt2F+X2tIffwnFNJ6Zp0CcatWf+l4d2/TmRhynqI1b5KjZ3emrl7fDLauhbj
	Ak7AXPMJbWnsCZmyzrXIalJsW959hps=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4204760210;
	Mon, 14 Sep 2026 14:23:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8F791F0089C;
	Mon, 14 Sep 2026 14:23:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789395817;
	bh=SymGB/Aunbf5NpktH/MrAmxXwvCzvOB6NopidPvvPWo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Kh0m6NXajRuL3CuLqc5aJQNDFZ3RSvXdrkKyvR2jqMPtFkDWwdkniXPWWgcrnctzq
	 8Jewn5hAICL5YkGtDhBgQk/TGlMY2TwK6I6mqlqZFJSbLBkLzk/M+9060VTlcIRUF/
	 T+4rQk2mcjJVtIQQOkP2nKQUSyJ6kof8xGCz/Bm/j7h0bFIyYbjHIfHxPr81bQN8Ug
	 O/IXla/2RVPpFZN19noahFBlE2K4iOdNIfrPlH7sTtOW3XI1yqEH4gCmaNPbWwjewi
	 qfvn5visdXISBS4SmEM7y7wjxhhMTXruMeDi2Qf2Lqs8LcLRZOAeCv9ODieO53q6yv
	 T5trV7T1wBAPg==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 5/8] mm/damon/sysfs-schemes: drop centralized filter range arg validations
Date: Mon, 14 Sep 2026 07:23:22 -0700
Message-ID: <20260914142327.92510-6-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260914142327.92510-1-sj@kernel.org>
References: <20260914142327.92510-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 92F5020009
X-Stat-Signature: tniyo3dnuezt3kuk9k1nueu9cx38cdpw
X-Rspam-User: 
X-HE-Tag: 1789395817-372330
X-HE-Meta: U2FsdGVkX19iO4X1cVJm/kE0/mue96c5S9bXaFkodmqUB6jxOu2Eaa15oV15+RKVZ0+xUpgdYDUGChuuFxAoJLjRKI76GwQPj5RtXb40AyE3Pk3tYsoB4J3apJDt7LCDCkmu7Sv3R4n0HxaScMx80DCr5KJ3lr6HjrMBpeRuDqYxaFc8fXrxzbj6AUZMB9dAVFRQ9rgI/BNv/ojPc4Fc0OtA9owVEFXm4fbaZcFyRnl8GnPr5Qgc7rbNjiaGc09TZUBREOswkyHI7GFfzP7NgC9qhdblj444uecIAeJdFFwpKlkNdWO9zL1VKqOB2HfCy2pPCrLKIEItPkZMfpBElkij51djtu3rroQHy3bNvG/uChc7KQD7fHwleYPJ/Kezwlw750t6+QkW7OPRL4fLKQyRvDv6RNPqttrPrYYrUDsVICkBzv3y1RpWZj4BbiNESISyuQD0fYXcRtEIRW3GarsILuuHXHgWD60yZQRXzj+GIziC9MtSfn3c6F9jbRHEVJ8QFPK8vc/LtrjrnNFYsfcMNNfCf2w8uyDZozrBsek9LM8gylB0oJxbxKQM4cj6Xoxt1nsSvYqX1x0bukEQOt3hc7OmTC4x/isvIabzBU2Sj57HX5FXTz9tB0RPuy8BllqFmfGFPuiL/0pvZGMoa6azQu2DQANEG57k1zMVCPEYOFjGMEDvYFbUZGJG5PPJE0kYa2B/+MRbvkGgXk+kC36QApsdzzqFUkm6Eq3eutV3IxRXd+0GxhsleuSjFwbGt3rarmzcVIgdJj7w56aE9NhAo0qetWOAfJOCMK+0DxYE/tsHwIexvxlNV59LecNQnNdm11sA5iccWG4IGT4O1Q2Vp/Mo+x1lWCGgSTwEolGru7MImX0gQ3+nREPczVM1Wy7SdJlc/Y0amN29ihDIal3nYZVzcjLpov4ai0BuPK5k2fHcTuD01jtR/QUU7XuRPMipVsv8R7X2Jdv0A34
 s1eRV8/0
 BRsEc+fpE0T9H4w1O/q2v088hk3LRMPV5aRh5IzyTgwItkidUVqRkyebMeXQgby+wyv3q2zxJMDxbRC+DMkPAKMOSIkQfhNKdUT0pj0M7zUYS2EyUy8r3XR8AR6qSG1SIfv6VvvVzsCNHqLQJZ55q6/MzzAsaaPXhLDqwteh58+vO/ZcSvjKvIv9JNS3/L4ibrBGxbPj7CFcwtD7ktc45GYF+WLJCOK/TE6DrwhSS19Pmyn8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMON sysfs interface is validating wrong range arguments for DAMOS
filters.  Now the core layer is doing the same validation.  Drop the
duplicated validation in DAMON sysfs interface.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/sysfs-schemes.c | 13 -------------
 1 file changed, 13 deletions(-)

diff --git a/mm/damon/sysfs-schemes.c b/mm/damon/sysfs-schemes.c
index 8c8ab82c8facc..a4ec5d54cfbd1 100644
--- a/mm/damon/sysfs-schemes.c
+++ b/mm/damon/sysfs-schemes.c
@@ -2832,27 +2832,14 @@ static int damon_sysfs_add_scheme_filters(struct damos *scheme,
 			}
 		} else if (filter->type == DAMOS_FILTER_TYPE_ADDR) {
 			filter->addr_range = sysfs_filter->addr_range;
-			if (filter->addr_range.end <
-					filter->addr_range.start) {
-				damos_destroy_filter(filter);
-				return -EINVAL;
-			}
 		} else if (filter->type == DAMOS_FILTER_TYPE_TARGET) {
 			filter->target_idx = sysfs_filter->target_idx;
 		} else if (filter->type == DAMOS_FILTER_TYPE_HUGEPAGE_SIZE) {
 			filter->sz_range.min = sysfs_filter->range_min;
 			filter->sz_range.max = sysfs_filter->range_max;
-			if (filter->range_min > filter->range_max) {
-				damos_destroy_filter(filter);
-				return -EINVAL;
-			}
 		} else if (filter->type == DAMOS_FILTER_TYPE_PROBE_HITS_WSUM) {
 			filter->range_min = sysfs_filter->range_min;
 			filter->range_max = sysfs_filter->range_max;
-			if (filter->range_min > filter->range_max) {
-				damos_destroy_filter(filter);
-				return -EINVAL;
-			}
 		}
 
 		damos_add_filter(scheme, filter);
-- 
2.47.3

