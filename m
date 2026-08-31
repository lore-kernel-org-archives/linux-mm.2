Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 946D8C624A4
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 14:03:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 64AFF6B0096; Mon, 31 Aug 2026 10:03:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B48F6B0095; Mon, 31 Aug 2026 10:03:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4C3716B0092; Mon, 31 Aug 2026 10:03:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2F5966B0088
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 10:03:06 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A4CB6120147
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 14:03:05 +0000 (UTC)
X-FDA: 85161731130.21.EF1CDAB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id EC0F71C0006
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 14:03:03 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=h+1eIXDe;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788184984;
	b=8UI0ZPSlgiflo8fbWDn3QPz+8/cj99n9ePRbayUbU2gEtoLiMWo9IMBTIOyyUJ6Zh67ybg
	NRDGj2Kfi2Qk5o1urWucRjBU7h6X8K7qE3dBMFuWOBeBK574Yvm/UYTJh6j8AX306b23K5
	BvqRrPmXfwnjZvOlPo5zXOvWK06qoSw=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=h+1eIXDe;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788184984;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ccJR9KUzvn7k6BzhoDEjN3sQrL1C2MxY/yOiNOzvC90=;
	b=tDQcuvZT76rJrSBOWH+k8a1Cp4jP1k83xj06QAwdQDlGvX05vdeB2BG23/d6FpjhYZOyyN
	8WkwTvFwjnb+IS7YpinacVmldKJS3giLfslGVlM7MgYoVAs7hKhX/CvN3ry4s4+5vAGcFU
	cIxzLw+QYC1kmprOA8KWXWQKI9/xeTc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 114B24071A;
	Mon, 31 Aug 2026 14:03:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC6771F00A3F;
	Mon, 31 Aug 2026 14:03:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788184983;
	bh=ccJR9KUzvn7k6BzhoDEjN3sQrL1C2MxY/yOiNOzvC90=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h+1eIXDeQBAQUEQT+BHPoIt3p/SRP8E+YgRQDpNx0ek9JHPXbuwO0QBybw+PfjfrZ
	 hHRD5xsWcY4EoIhMgDT5cKTMNKxOib1aMBeU16mcgv74zbIVZWmtnqNJN7V06osC1H
	 fGo60DV1jRBKLrPXpVjoq7fpmZQixJNKqZrtZiyfvmDTetdnUjdoTkurf8aSfVAOC8
	 6R5+j/oVhpV9iY6JWJzQf9zH4CJCLSG+WS3q2Qyshrnr6PK/kv41ElGi8FUn6W/3lq
	 0CHnlRxIWF45bMsV6ZfHPw9oroitEgD6q9hNcqHfNa5f4YCvca5kLlfldmIZyoXVe6
	 oBDRf+zfa/ZXg==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	stable@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.2 1/8] mm/damon/core: skip applying scheme if region split for quota fails
Date: Mon, 31 Aug 2026 07:02:40 -0700
Message-ID: <20260831140254.72004-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260831140254.72004-1-sj@kernel.org>
References: <20260831140254.72004-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: EC0F71C0006
X-Stat-Signature: 4td5czy9cx7ogc77ywn9ah8mgyjoy84o
X-HE-Tag: 1788184983-364557
X-HE-Meta: U2FsdGVkX18OpIUUDwvpSZqw+jGHV2GCRWEh2K0PllmvbKZccz6/WxtD259xah/iZrxk8W9Y6Tu86rXL6XF3gbt9td/VVAhtAZD92zpRcpCmHHkwU9Jzoq5c1XWp8o8xKJZuRihYxhjqq11wRg81T50RcKOPmKTDe6tAaBC/TqSqFggWG/kFnNBp5iBZjhMv9+3it2DeiUPoY9SUVqv4R5AQzWGr4HrvX+R7KuB/kx0XU08y2FmhDVebo32CqEPtzUhNJYuEuRiV5I4luxYQ8xKow6Jts6FBYa50dpAZitBmF7vfINuKdTLhzll/mmODzm+vFaOBMEzA0j2xDuhfrFQ8DzF2wBJJZyqtWjILqrlhec7XaHGfesd5yo9FtbYCFqvwmkCaJr7ehqzZuJEgGyz2IxetkMRpfw9wGYd1VdqCHKc6v0QCdU4hTMssRdB9gs0ux/C+E9YhyL7nCZlseKSl4ZNma0+IKblji+N51E1/Qs3VhN+oPLb78x2647JVmau7aS8279Gtz/CwXJaND4t/5qCUHoi+aP0pxGgqe5A+0gFbhxg8m7Wv9W4d7WQVccGdFr0T5Rggzc9vNakju4JUc0HraZbgsEVmrsxlgb8bwAigR1YQs8PE1SwGF441/qXFNqIL8HWOsZ2rFOuOE0yVz/Ye54mrbWn98yraRuC/uldcUGcFDKm61B+sASTnDMnJsZLM2aUK4myeJGvjYgdfzHoD/PiNtLxKqLsJ1bhj57Ei0pw9v7o1yWrO/QDdRtmy4yhXBhGBrPU82ReCUe1w0tT7XmKqQRhCmZJsFDr9P8LBO6K81Y6z/44i/r7Las+pJKeiqrfh9Ir1Dm64KrYrYI9jOafWus8OHetSp37GHZQSeO/TLFwCis5SZ2xiTxJk4ZZFWlsX2orPzT7SMadU4eTp6e0kNDqOuz/i5b29dMMXz26obkBeJViioKvXgoWd8kIRHFw7Y/1RKvp
 fNZL6bEs
 HJV04rkt1/Tk56VfE8uRMRDwmF7OvsMpHNggLRt20gaKeJhbJYZxRjV2Ud94sTXiSF3XQum/j8/IwBUI2VSg89k5Z7JBkN4zJrqtBNwvXHiDEVGTuulsrzMINYcRansoMPcMuUJpamFHmzmGfbAIloAXX5LxJTQsnyc4XUzKJenkGpL/HBHlx7Ad1kBIW9dG3W5ZVqmmP8B6xUqHk6FiU3ezkAXvt2K22gKdREL10XNagNcU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damos_apply_scheme() splits a region and apply the action to the
subregion if it is needed for not violating the quota.  The split
operation (damon_split_region_at()) could fail for allocation failure.
In the case, the quota could be violated.  From the user's perspective,
DAMOS becomes more aggressive than expected under the extreme situation.
Handle the failure.

The user impact is not critical.  The failure of damon_split_region_at()
is unlikely since it is arguably too small to fail.  Also DAMOS being
aggressive is limited to the single region.  Users can set
min_nr_regions to set the maximum size of each region.  If it is
reasonably set, the transient overhead shouldn't be critical.

The issue was discovered [1] by Sashiko.

[1] https://lore.kernel.org/20260718171523.87547-1-sj@kernel.org

Fixes: 2b8a248d5873 ("mm/damon/schemes: implement size quota for schemes application speed control")
Cc: <stable@vger.kernel.org> # 5.16.x
Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 644daf5a16560..e2900d0c984c9 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -2613,7 +2613,8 @@ static void damos_apply_scheme(struct damon_ctx *c, struct damon_target *t,
 					c->min_region_sz);
 			if (!sz)
 				goto update_stat;
-			damon_split_region_at(t, r, sz);
+			if (damon_split_region_at(t, r, sz))
+				goto update_stat;
 		}
 		if (damos_core_filter_out(c, t, r, s))
 			return;
-- 
2.47.3

