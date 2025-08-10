Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81D5EC87FDA
	for <linux-mm@archiver.kernel.org>; Sun, 10 Aug 2025 19:26:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 747726B00C5; Sun, 10 Aug 2025 15:26:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F86E6B00C6; Sun, 10 Aug 2025 15:26:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 635406B00C7; Sun, 10 Aug 2025 15:26:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4F89F6B00C5
	for <linux-mm@kvack.org>; Sun, 10 Aug 2025 15:26:00 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B712CB8D54
	for <linux-mm@kvack.org>; Sun, 10 Aug 2025 19:25:59 +0000 (UTC)
X-FDA: 83761828038.08.ECCFB48
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
	by imf29.hostedemail.com (Postfix) with ESMTP id 35F0212000D
	for <linux-mm@kvack.org>; Sun, 10 Aug 2025 19:25:58 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uxUn9Yoa;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754853958;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=h305VlshYKh+Vd5nKwOxiGnLuAg5/oCgYo9LoXrtREQ=;
	b=tyc5Q8VwQ83ej9amCyDEiwniDQVTF7e3WBj9Bx0JAB6XZkX/hunUTOjACnTw2IWwM2lQji
	LzesYpV9v11xq0F6v7830gV93zgTNrPAvr4KTX7wSoPPLNTNloXJAu01I7hFpZE1RV4Swd
	t6NApZzrbO2NlcOHYH6AIjLncKqjGXU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754853958; a=rsa-sha256;
	cv=none;
	b=2LthD3W6/TMXdwhuyrGMPIY92dH6+PsHgqJ1BXJ7DAX5tu3n5mCPBOEHlXGgAEkOjmyohy
	OqWBEOmWyKI1AvteXNyhNc4hjanw4UKSwBKsc+2KO/Wsi0J5g2pZgeshxmENBkA2Klhede
	g3U2S8lLPW5KFqa+ZQ/htUwHcPuoMLM=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uxUn9Yoa;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by dfw.source.kernel.org (Postfix) with ESMTP id 2B1835C578F;
	Sun, 10 Aug 2025 19:25:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABAAFC4CEF1;
	Sun, 10 Aug 2025 19:25:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754853956;
	bh=WyO8PtQO+3C+ZYPrF+e4+P/lETANCz26Qlp1GXs3gLk=;
	h=From:To:Cc:Subject:Date:From;
	b=uxUn9Yoag0uQmngugzY8heUDdXJBQMyMWguEvZk9gszM5AtoVS+y0oL+HbQ4/muuR
	 Pg7scW8udvbYhVhnK+3ZGYmDb806r/ZJKHJARJ1B40yQ6+VociJGe6n9fu5SX7U+63
	 IA+YoqnbBBJd0SROziim8ay5KbxWpcCTTMM1WnHEcxjO5yEQyCzo1xCf+W0IgrHfdx
	 NSSiMR1YXFTdBpIp63FPJJRXMf6323/Nm6ABuOTO2XgcU8xTlFXuqdh2/PKwirzDgM
	 49BhiUbqus2eqDET0C2W6ZbqoJsxtNtPh9XdyZimG1CCw1zQshAVl6K4fMwdgFRNM6
	 PSb4p27OEDAtA==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Sang-Heon Jeon <ekffu200098@gmail.com>,
	sj@kernel.org,
	kernel-team@meta.com,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	Dev Jain <dev.jain@arm.com>,
	Honggyu Kim <honggyu.kim@sk.com>
Subject: [PATCH v2] docs/mm/damon/design: fix typo: s/sz_trtied/sz_tried/
Date: Sun, 10 Aug 2025 12:25:47 -0700
Message-ID: <20250729144414.31958-1-ekffu200098@gmail.com>
X-Mailer: git-send-email 2.39.5
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 35F0212000D
X-Stat-Signature: cndw7fp88yspdg3ibocmrwus68dgxuxj
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1754853958-938015
X-HE-Meta: U2FsdGVkX18WpjS5FM5HWX9l7tyMEyPPONX9j9HnEguXEWWfeU+E4pJljRxPQPlmDIj0eNDcuYljkUalYetFCDdm+4Ja/06yOX/rcgcjmsep7AooG+R2FTDdiHY0WHRJk1EdhxD3jBob50HU1DjFYOgom3MXyeqXZbcUjGdXNZxQi6AQSRn1C37zic3GoTy7k9h86qXcXJWcq6SVfh0rclIWjZFwPab/IwB+aYDoNWo5Rj99fUgX6Km7SZWLdd+BkFC4Izeakz6l6abIkERVHFDKnxrqITektcvR2LooiWdJpD2fI7zzDUMZiKUE+Vcol87YCGjsRu3DnuMTDmgsvVR3/9BjU9mSeNfdw/gYho/EVJO7tcqPbVIhFU4tUtcZGHHcjVzWcOUy76PvsOH/MeKQDgrI8/HH/b333RgSHYmdcYa0pUkgazpKkBvZCOn+EqIHY9/yLZ3l545vsHWuTZd7a3LWoWZFTU8pEHxLx2me0fq1WKZlo8ZFIJRHQpLSJnZefgJTPV3lgnc8l4f0Ht+oLdk0jP4A0QsImjPcGRpMhGO559JU+LzOPWMvIn9rxHkZwL5oou/f4z05MsoDOac9Ri21NaXr3+t+PjPnmTl7flOSDp3Bh/Rd/vsqNI/V5/UyoGWj+ZhJit1oDvCyP5xFIznFjIzSLypwIMyCbE0MmqM+NuIELXB8F6Svv3C6g2/SCM6yyAQC6M4BauE93XU0bfmSF2izl+2B5TLE0lY43sxI0JN3GuGQD7wwk6gaoYGHLP21qvlFOe2U9dIyAS9DQI3n+idpRLGgiaM9NEv1C1/C3zBm2uvwMxQlMS/9glX0KvO7GZTUxz439BjaVWkW4gb1jbAo0HVu9bv6uEdL6jUJvx9j+YmFizaJmj4tlMjkSGTmrfYs6PaCCWFip7bJxtejb3fuAMhHxsoEB/DupPxoQHM+6KYPqRbhHIWxo59JKj/KwuFGOOemlVs
 dGUcc7rn
 W6EV+EwYXz1voxWf/VSuh7k0f/UAuhQF64CeQ2OD7+E0f6pl2ePI4UbHC4e0tlPW/f2FNkZzpGNUvaeVyOASL7UZNNeejvOk2P2i0Ioydk+T2MWIe7uwJM4urV+KQsdgbZ1I9JD62O+Iej5Or6hi2+zirVNbvFvhfkkSSEtvZDI7W532Sn9NFduF7VbsbLzrbdSvgH6VsP+JsE5uS0kQx6+iMQRj2DHPP3Mjg6Hu3nMfjrOUx0527QRB91wWYNNTQVVDzN8Gj8nD6xHh9K4Z5tatrTHVYxL/KmlZ915GxE86e5dxPlKPNa/g8buklNgPShfFQSNw8XwiKiIgA7KrV02nKvg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>
Message-ID: <20250810192547.EBiQB9ySC4qrfPKDm3ZAnpZjcspLULWSW5_d6tRICbk@z>

From: Sang-Heon Jeon <ekffu200098@gmail.com>

There are some typo in statistics section of DAMON design docs
- sz_trtied -> sz_tried

Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Reviewed-by: Honggyu Kim <honggyu.kim@sk.com>
Signed-off-by: SeongJae Park <sj@kernel.org>
---
Changes from v1
(https://lkml.kernel.org/r/20250729144414.31958-1-ekffu200098@gmail.com)
- update the subject to be more specific

 Documentation/mm/damon/design.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/mm/damon/design.rst b/Documentation/mm/damon/design.rst
index 03f8137256f5..2f6ba5c7f4c7 100644
--- a/Documentation/mm/damon/design.rst
+++ b/Documentation/mm/damon/design.rst
@@ -689,7 +689,7 @@ DAMOS accounts below statistics for each scheme, from the beginning of the
 scheme's execution.
 
 - ``nr_tried``: Total number of regions that the scheme is tried to be applied.
-- ``sz_trtied``: Total size of regions that the scheme is tried to be applied.
+- ``sz_tried``: Total size of regions that the scheme is tried to be applied.
 - ``sz_ops_filter_passed``: Total bytes that passed operations set
   layer-handled DAMOS filters.
 - ``nr_applied``: Total number of regions that the scheme is applied.
-- 
2.43.0


