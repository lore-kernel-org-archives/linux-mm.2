Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 88FB6FC72CE
	for <linux-mm@archiver.kernel.org>; Sun, 22 Mar 2026 15:57:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DE8D26B008A; Sun, 22 Mar 2026 11:57:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D9F116B0098; Sun, 22 Mar 2026 11:57:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BEC5E6B0095; Sun, 22 Mar 2026 11:57:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 886186B008A
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 11:57:42 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 587C913BB66
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 15:57:42 +0000 (UTC)
X-FDA: 84574154364.17.00EE112
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id C9BB0C0004
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 15:57:40 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="j/v77JDa";
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774195060;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=n7zkmJLFhrZtgZb5xv0tfELwAXDyT6rXUNKl5w+JrAw=;
	b=sushIPpZ2lT8ZJm5UwXf7alDwm2H76ZW1A8UMFSLK61WGcJY7JHa7BZIFXbCdLMrunDlB+
	J7bEKVsZduF/TRdRSPb/opduNOI3i4CD2CR6wObY+eJnlrMy9bLEBfGZw6k8jyCMfV+a5o
	q9uU0wVFFHifl2c5Ug15OJ0OafKEkRo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774195060; a=rsa-sha256;
	cv=none;
	b=h2bPsuY2p377dSJEie5/5MpjUQjD8Mg+DDJRMQVnf8Aqr/uBbgn5lzEFnTCnpInBvcrI9K
	G0NVEyq5aQpw5J45qL/IycI+6L/cXH0sp85WQJGRXaHV8PzpownvjzklOv3q0+Lg9kIX7r
	HO2aeD0jW45Te3xHW+gDnc5SvTm8hTE=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="j/v77JDa";
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 570996013A
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 15:57:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D302C19424;
	Sun, 22 Mar 2026 15:57:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774195060;
	bh=9O26QoN+V9tNeSexEgjKx5Rwm+ySmwIIy3Pdsz7ovf4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j/v77JDa6gOV0lKhY/HqDDAGc1NKfWFTNAZfuguz6CCxPJmvyDQVRt9oFIHTZZr/P
	 vj3HzRacvDG+drDY7jd6OZz7cb52PzTKso4PlOROx9wBAyrX9oforAuK3jXCL1+Cdq
	 G0x1Bjm0b5I8rTP3lSSVGraBs6jZQy7uFKgwldR+B/6UFwKcZKrUFlH3lAO3jpH24d
	 AE8iGXzMnZGgY3lxI3GD7GYDKAkaQ5rIQG/2E8JRWsVgRoa64+6uoi6TeEdvHUjoi8
	 Oolrva4ykbCNVDA+9HmgbaSaeFl96aqjokbB7nnK0mXs9vtwcKmTEIOf6FSUjDqG7V
	 J28pqhmX6kJpA==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v4 08/10] selftests/damon/drgn_dump_damon_status: dump pause
Date: Sun, 22 Mar 2026 08:57:22 -0700
Message-ID: <20260322155728.81434-9-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260322155728.81434-1-sj@kernel.org>
References: <20260322155728.81434-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: h8ne6hs33mj4p8min8is4gnumhxs76g4
X-Rspamd-Queue-Id: C9BB0C0004
X-Rspamd-Server: rspam03
X-HE-Tag: 1774195060-857143
X-HE-Meta: U2FsdGVkX1+LjPek7YPk6BKQXz9/ArZhDvvonvAcC1Y8WM1Fe1TsgIOQsk92suNbqLAwjSJ5ZZ1Vjd1hRIqTsWfQ3G6eoIwwYgsDxLzKPqexZ0eXxgTHWPe/aoGty79UA5+yx2+phWSB8ZuDM1uD/TPoezEhJ7/5Y2E9x8NlJ/9L9SWD6qoozIPDnKApMcqGC0nhly4xAfOxXsQXJXJj4BNg1Tr9qxqV40xBKMB8VJ9SXkxta/3p+DHC17+i/RuXo+zW7HvI2IOojutc82DDnVBCYd2pQhNnZmB31+SUR3he16u0bJodCx2S/ziBKvI/mHY9Mkgo5V4RPQEQh48miqUnbg3QAZ62O2Mczfa5uYdhm0zghWLjKsC/JJkvwsHz/v7P+z+QFEBboJsJ3QTSAZMS9mnOZbeDDy1HqH/RkU8ntl3q9ZqyjDsLRsQBTjSdvv3wGRrXcihr8rSLsWqKc/S0SdbUpBtAzUpTi8QUtlsJTheqrOHm5fDeGVY8gWdnBgCH6Kj5Y7lmT8Jwvxqdn/TfwdwRai3N3cSamtZm0GfPfmRC9lQIEQLUR3UpyCSV27S3X6rV5KRNCb5gt6oNPLpUQW+p82tugql8cdrWePd9lB8ucuhxfpyiWS7+qMtSYInXcZZtZDRce9arjvtmcpJ1kGSDu7HQo8N/9m6qFtx6IuteHvfBoISw53WUx+vC5NdQZO8kIuwGQmSIbsX36nIpoLEsSCsd+2S6bHJm+nTQ6Z6Hhk8YXz1oS2n3+66s7Q+Vz5zuDru6nfancy6QHT9VqAVc5VTQJsr9TjVlUNEswwLSnzlSik8iLUAzxmDKEu668FHXEiygyjq//9eZTTjW+6xwYiiOyEM4VcaVmasJf8n/Tt9Iwut99LbUWbKgdleF3YuZxLwykmqOY2ZJilEolXc/9NpiDqE4pU0cdU+DrnlJIaUuuKKhwBqpmNuiXe/B3nDYOytunQcYNET
 LszlI2Rp
 Ky65MYRh9SdaKMizFn2+ieW+K2u3vJpyB/5TnIHlZOe9MpoFTrVE7hyX+B2qWBxZ8z6Z8Mapn+U8wbTGXXCQxbsKbvnfCDjpd63O6Gnc6bgu5d2zajJnfB6fbOYTljz27PjkAxSsRJHmtI9mWyq0cOVeL/GvA6yExQ+fb0CM5f5sj5e8YFbgn4197CdL1fwV1cxgZUtiEXcT2lUO/QmlNS1HJyG9/1900w4JrZHyfkkcZLNpBUV/Bjbbwc3trUf0oQWyJ/sJzYjtl5X+mCOf6vIsu5FCQYJ5sebEPYt/BvZ8mXYgPo6pdxtf7bq9/kji5VZ5S+rp3+Vmq9BgIglaGM0APAqCGkzvRbgG5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

drgn_dump_damon_status is not dumping the damon_ctx->pause parameter
value, so it cannot be tested.  Dump it for future tests.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 tools/testing/selftests/damon/drgn_dump_damon_status.py | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/damon/drgn_dump_damon_status.py b/tools/testing/selftests/damon/drgn_dump_damon_status.py
index af99b07a4f565..5b90eb8e7ef88 100755
--- a/tools/testing/selftests/damon/drgn_dump_damon_status.py
+++ b/tools/testing/selftests/damon/drgn_dump_damon_status.py
@@ -200,6 +200,7 @@ def damon_ctx_to_dict(ctx):
         ['attrs', attrs_to_dict],
         ['adaptive_targets', targets_to_list],
         ['schemes', schemes_to_list],
+        ['pause', bool],
         ])
 
 def main():
-- 
2.47.3

