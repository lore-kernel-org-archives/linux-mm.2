Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67C7EF4613F
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 23:16:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 18E826B0095; Mon, 23 Mar 2026 19:15:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 07B796B0098; Mon, 23 Mar 2026 19:15:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EAC366B0099; Mon, 23 Mar 2026 19:15:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id CB2206B0095
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 19:15:47 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 914E95CECD
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 23:15:47 +0000 (UTC)
X-FDA: 84578887134.09.BB7ED46
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id EAC6718000F
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 23:15:45 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NQ3wtS4V;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774307746;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=n7zkmJLFhrZtgZb5xv0tfELwAXDyT6rXUNKl5w+JrAw=;
	b=C6Dm6+T2dqZSn+rQBYHMabj7UosmK7qL7pxCxkFZw90thkSG5hKirTLx8PFeW7xh6x74SJ
	NYa/TnYWIQ9D+IXFumj5q3O6kFHWlYAoZ0mFnfYCfj3fVbBfdJfoccvt96exYXn5A6ARBr
	w3pYSAew0rlYmzgZfeO3TzPfzEK4fDw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774307746; a=rsa-sha256;
	cv=none;
	b=AWYylNsFhHhz2KCJc5ELyEUFtncv/H9aGZolRIwtODIV/zYWmKFYsZ398htQG54eBKulQO
	QRL14H1NPnZBZb1dddwm1x1oSENkv2JDC+Q6yTT6hifAp+x0V0pBI7BWi9yqmmHshoOfdc
	iBmyEmavMzMA5hOYr7k4uPGNFZQjm+s=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NQ3wtS4V;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id DDE5B44563
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 23:15:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98B5FC4CEF7;
	Mon, 23 Mar 2026 23:15:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774307744;
	bh=9O26QoN+V9tNeSexEgjKx5Rwm+ySmwIIy3Pdsz7ovf4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NQ3wtS4VHYPZf66jO1csQvp/LpE0Ybl8w5Hd466GHvql3tGqyF+A5aWR7fuXZgxQ1
	 ThbRkyMmVCeDuYOQzSJynT4T1Dk49A2ePSevU4ezpCk79vD3QjdVPbIMLoskqDibj6
	 15pxS4BxUZ22m77hfPXgBUV/ySrdFqNNAobvLzbmCeAzYA60umafO8Bx2Rt0Z5batU
	 gL8YysbsUrtKBJszNQ4AZMbR8fYelrEXd5LOnA+M1yx8AiAwQ5UvVQ71iyVDi0pVXr
	 yP5/R3F0jzixczBsV2atHVSqka9fnMCY59M3xMVdRobs6otmCQUlwQxBV7IpDAdQcb
	 R8bAJGnnI1HXg==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v5 08/10] selftests/damon/drgn_dump_damon_status: dump pause
Date: Mon, 23 Mar 2026 16:15:33 -0700
Message-ID: <20260323231538.84452-9-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260323231538.84452-1-sj@kernel.org>
References: <20260323231538.84452-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: EAC6718000F
X-Stat-Signature: 584fifhoftuo9qkxjkema4hy3xmehzwg
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1774307745-65316
X-HE-Meta: U2FsdGVkX19hhDG+vEazfZAasCK3xN660pMKWQlNqg/nDv7LgvtBTXXnUy7yM4HvVm00CDx3fVF7dyMMvBVVWZzK0JpGzTIZbbEmR9Bm1BtBEXNlqnTd3VB4BlBXiND6Am/lKI7ZnZmUqfIImSO1UPyr1a5D3ZM38R0AFJtgXW60G/Z5VJ8Js1w8PBm0j5hJiH7XCkrFaizlarnHNLysPYFNLBpxnyoM1P315KKrFfPwkgiC0IbcChkpMD0OlnGuygNw9V2BkhcQyCzlxjTUPYBRelYSOXXswaxAUx87LmRnHcYvfaHMKfX7/h6CRqHkqFpztlaygJM4q983p/+KZvytZSeM5Eo6D+4FDGxpqvJghjoYXyh+a7szSqJ+xFow6SvjaQybm/rj5PB55ZRvP7/+emia9Cjzc+/p5Bs/HVy1WYFRsgC/XWvmnfLkFCcGH287PHBCvQlDtcnfbhBI6QpNwgagkzn9Y7FD4o7SJGtzKLrKNlBMNFYtaRbS6MK0tVelpxDk/QJEiAPTJ4tH1PnhSnYVFezMibwrxH0vjuRgDQbrwYAoD9za29m51l64ZQrZ/AerUmzvDcJ+sgq/Uh0YaRYmhuR8AAEnAHuUA7b0lX/5MOWJVKJIn5NBEqNCpAP/T6zxSS333UjajBH0WVKh6pGa6MZ0P1oz2mLfYzzXM86M8OFsPQz9FxE8NST30xB1KdjVc/bIpQFVJmyqKPmwR+L6cwYcR28ub8mTOO1N6MxnvwPVv0ur14XBnjxh2Oj3ikR0V1XHdBOmi6acqXwEfwlcNMY94DxsNfjwJAZz7Vzgf/I2kIgkTsgr3MrNtxof+RWpk/vAjbDsfPctK7+h8V1BCSiSYd1SDf6RJKxfmunzWShZU9NwOJqdUet9vnCWO8Bg9NTzaS3oXAusQLPwTRVoTEWl/J0HB3lBtQzR1SMhvtuhVWMFFGY+BIg7g1e7o0faJObKoQj+aCe
 ePdzxIP8
 YQQWNj7UObopg7wWbf/S7SY26MBMaMJyZwYz0BszoRfEuvYzhS+exzDrlMic31SGiuzbD//G7Wng8xVGPkbRMy0DAs6IS6aKkCRQBTCRgRY6aeZRHZ+QA3fNyQ29e0wO67zuAWRPH9X2fDPfiGMj7zP/wx4jePcjnOQBfwL6UyRmPufOI0owxZrAnLa3Jd/Fn/j2keut+uomNrwqL2MnraP2UcNQRn50he58o4r4Kd2JwHbzohX+B696yjlGPGEoElxKkRVKcFbXVLBiG7xbczgLF4oyQB133jwdR4m71r2rAhI8FHAS9DRKncoHB4Dzii2pzo5837giqdk6tobBR++lxR5YMyLpx2Q9L
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

