Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3C34AC43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 04:39:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 696E56B00A5; Tue,  7 Jul 2026 00:39:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 647C26B00A6; Tue,  7 Jul 2026 00:39:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 584776B00A7; Tue,  7 Jul 2026 00:39:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2AE1B6B00A5
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 00:39:16 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7F51C168B84
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 04:39:15 +0000 (UTC)
X-FDA: 84960726270.26.D16E8D1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id E22C5120006
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 04:39:13 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZWdxOzio;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783399153;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=of1I7i7VNy1H4HcbkZacjpj2gDgZKYHy4CXBT3cnzFM=;
	b=ume7deiTWhjPJuuOr/ORn2soDNzg0BlPBhSmTQBGVQny4AhzkwbZJ/JPcDI5BXtlm4Eo7I
	FEXZ1gVjJUKHfaZSnIamU2jd7g0JsQRyXl3LuI2G8qlDrxQ627ncJea379zJg4PYe3dqmX
	YQvsC2nq0e7vwHROclJ46K2PMIouJms=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZWdxOzio;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783399153;
	b=x1aPJBEe5mUjck54kR0i7gY8OXGBLuFDQrdCDwXjL8XsuivKnXxDU2n9Rc4erygCiLJc/o
	USG2RqY2FeiiKoOUrQtuc2vZ9XqqmUlJq7dIO1egd1ZoiC6pQO8RXhlEEwjEUz4bzC7w0O
	rxxekF7RTgmieC4Se6pjvj8M+QNy8Lk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3E34B404B0;
	Tue,  7 Jul 2026 04:39:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 143FB1F00A3A;
	Tue,  7 Jul 2026 04:39:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783399153;
	bh=of1I7i7VNy1H4HcbkZacjpj2gDgZKYHy4CXBT3cnzFM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZWdxOzioIELdvRfke6rCvGWUZw1AiBWozI4tuyAAqCyO9Impze1PvMdazc8wwPa9K
	 8uwNbmLaJ1knO4sUgxS6VUbUH/ORiSwLRDXJSEu0d9cocw9r9Q1HALpWwSxN7n6RCJ
	 sUib5lLoXtN/zFcvf++7cRTRYIYpgzPZS6GR5IW4ZU5bZdNtaoyaEhFDxodMz5qFzE
	 SCtrLZOdPi7P2LBzW3pm2TfAwSes9+K9OCj5wHZ+J3WpJYfC800l+x8f5FluVMjj8y
	 ZP0ju4KzGNRKX47eNsnD58a4HR0aHDXvyvwtRt7B0oZUINemNmOHZ0q7xL/LNgPVnn
	 VZwAIkkzt5IHw==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 6/6] mm/damon/core: handle unreset probe_hits in probe_hits_mvsum()
Date: Mon,  6 Jul 2026 21:38:26 -0700
Message-ID: <20260707043828.97900-7-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260707043828.97900-1-sj@kernel.org>
References: <20260707043828.97900-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: E22C5120006
X-Stat-Signature: n1qe1szuo67yzybdyyk3fo91pspfdzrc
X-HE-Tag: 1783399153-298798
X-HE-Meta: U2FsdGVkX1/roMlKN4zM7+H31FcJ6AFpyhSiivvHEhdOQNdk3w1jBFAsPqLtyEtSsT/CQJOyEOVD3leNznqmLtq7uZ5YUHvnu8OfnYLQAmTbIGvVK0wBHIsIuWlCd6Vv2yicZmK5bfNVT44relxe1feA1/f7quJP57eu9kATLctabhigyQ8b94k3gBPC35QIAio+/PPF3YKCygzfJiGzd70brIo9sTYeNP3aJkU0UQLC7vT5+anbv0PDiukZnDTKvk9hqKvQxFk8UpwTnzrjcbhN+vKhEwk//mQGyj/SPUeQuTFqinU2WILx9tyM3I0yA+lL9UXr6A1igejaVMl772woluW4TnvYVo8ktVVXBbWoAcVJxqiLwGAa3fpW//z8tjZkh4StdTpSQFEd3LB0Y/aOk8/upH5Cp+rvcbWKEf8PjcD0AUSBrL5rGDhe7JHIr1RYS3nQJZWeA+PRHUCpbU0KCBSr73YIDWryR+XxdwosIVCWHktyj9+vSyKnHNJoPcIYmjeI463AIgb3kGrZ/6yRPneVXzu9IUc9zNpCt6TzrAC2erH0ICo9wgCTvdVuP7CS8qiIwhuA/3wfkk4pjup+rZuNhTK29unoHurd8IuGIhYNqW21J/yQddnEoZDXqa0Kls9aFJ+jJuSmBSsEsxjfqoQwEsWgdSzZEpfVM89ZG53sEOC5JDT7ryVvJg1ufliqmWBoV3wPifbDmOeTYW0F8CoY1hKQObQ5VyNMqHZg3mzdZuL67WhFYDn94MIgHpZvsP03jBg1CucMjS7QRVUp32YOvO6BdHjewardiskbGql3+cS95iDaCaVGZ0aoTc1OvodGEqI2qqmUYUkFgiCv7G6aeJ1sOKbtuq+AuPL8d9anzh/1wDNv9q7CVuB2myRmB5OgNvkgxKLBcmsOQ4oC3To6UCo9irz/ORMn0+tBgavmm55rbpsdhc2U4tOPcK+dx9UAPkBvgLdQVld
 VgFI1kSJ
 eu8hINa0JLc8nnuv18+UXxoSGlZodk6IFgYpXQKRhIjSMJoemLjN64Da9kvka38OkDCpkQUOir6vd91xkbofboW+KIpqCo0ZSUZnxeXH9vfSGUrBhmxU9Bf8Dwbx3Kh6/dxO3p1+37Ha8F+We7c9+yvogTwuLGkLgHOK1LyYU3EOePbo3mVW6yPGeNcIsuMLoYVal4FI3j6jAmOGvVlK8afUjLYAjo8bUIVs3/XzYKZ3i03UQ+ky4O+24Ea7F4ABWHegdArxvFX/sz4nDAcaTYYqxGA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

If damon_update_monitoring_result() is called at the end of the
aggregation interval, probe_hits is not reset.  That's because the value
will be exposed to the user via damon_region_aggregated trace event.

Meanwhile, damon_probe_hits_mvsum() can be called in this state.  Due to
its logic, it will return a value that is incorrectly high.  This could
happen  if the user requested DAMOS schemes applied regions sysfs files
update exactly in the time sequence.

The impact is minor, but better to avoid.  Check the timing and simply
return the fully aggregated last_probe_hits, like
damon_nr_accesses_mvsum() also does.  It is not 100% accurate since it
is the last interval's aggregation.  But better than the value that is
completely reset.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/core.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 9a3ff0fe55a61..093da5c0b3693 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -290,6 +290,9 @@ unsigned char damon_probe_hits_mvsum(int probe_idx, struct damon_region *r,
 			ctx->passed_sample_intervals;
 	left_window_bp = mult_frac(left_window, 10000, window_len);
 
+	if (left_window_bp == 10000)
+		return r->last_probe_hits[probe_idx];
+
 	return damon_mvsum(r->probe_hits[probe_idx],
 			r->last_probe_hits[probe_idx], left_window_bp);
 }
-- 
2.47.3

