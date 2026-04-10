Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8EE92F36BAB
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 04:43:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F15746B008C; Fri, 10 Apr 2026 00:43:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EC5F76B0092; Fri, 10 Apr 2026 00:43:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DDBC46B0093; Fri, 10 Apr 2026 00:43:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CC8726B008C
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 00:43:23 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6D26B140218
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 04:43:23 +0000 (UTC)
X-FDA: 84641402286.08.07A9F13
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	by imf05.hostedemail.com (Postfix) with ESMTP id 932AA100005
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 04:43:21 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=qQjYm2I4;
	spf=pass (imf05.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.210.178 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775796201;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=shK6Y8ANhI6+xigEaYbBRBX53EjdBBu/dLtteAqBvF4=;
	b=ABY53uhsj8KyDNYTl0bK8ENyuIcqYqHE+NgLMEs7nFmTj3W7RNzZ2ZhVpvM1/l+gTICRnT
	GAkDz7T7kBklYk8MkL4ZRq7pwu1wESRK+2tSg7XWlljoArkpIzKzQvu177SEUzGsllWiJj
	bbGGjQx515pAQF4rJ4gi5fodqq+BO8k=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=qQjYm2I4;
	spf=pass (imf05.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.210.178 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775796201; a=rsa-sha256;
	cv=none;
	b=i8c6DXMnClW5Ji9prDr49IXVeK54qV+2FZ1VBAUYfRiZwTsESlbkpEgPWzhGtqNTJtuLLY
	hIeETKXjmhr1xt/TwpnndPvpyQVGUO751cewtKwYKGix+JWpNtweGPaSfWDbr8+F/6YzN3
	ESWVIkMx0vMtzlUy93efLkjbT279OB4=
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-82ce09b4197so839025b3a.2
        for <linux-mm@kvack.org>; Thu, 09 Apr 2026 21:43:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775796200; x=1776401000; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=shK6Y8ANhI6+xigEaYbBRBX53EjdBBu/dLtteAqBvF4=;
        b=qQjYm2I4CJCUxcglZswXXIXo9w39C+xOhv9TX8OTJ/y9qA5lfJN8vPua31PdT2evK5
         ckQTuF7KiXPZ2AjDp2AAxgup9pPeIj6Iwt+4xMubqlP62x9rTWxc/NJFSwOxnaaFOAGt
         5wtod0ZAlIB2HSqVgxqy7fp5jX3Y2uc/Bw/bQi6MYS7zSWF69YaOXnUG3LeadNKH8wpP
         jHTEmU5xZg6z2HrQWS3w8s86R6oFYA3zzh9CdLZpUH5SnLKemCx2WevpSXF2KLmlZWUZ
         gs4iIfLjKUIJAdzDWXDrsRSuteaoHMVIAXNccSr/hhH5vh869fO2rMMn8sXi5/joHap1
         l9nA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775796200; x=1776401000;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=shK6Y8ANhI6+xigEaYbBRBX53EjdBBu/dLtteAqBvF4=;
        b=m/YtkPJirfOS8we9+SqyUNzGvLlJ0IEuSMgL5hiyGXnsezgmHtiyxOB3ivhLo+DuPX
         1uTDuG5k3loEK14NO5+7s0L/XazLB+cX8S3eiqGh/g3qnQsCvIb948l1tf4+8eue8jYn
         SQ+ATMysjTsaB0wd0jxLuV27vR4Qc+H/2ZR6kX73FS2aA/oFU0r1Am/upSh/hSz0ruvj
         YoXd3vPZt0k9grYMOuy6fpsny8HDpgxiNbpwJmI5modWKrQE1nDr1wkOKYtK9F3peutA
         qcpUDEic9io1SbZlHZrrwD2Fwmqp9bOSBS93k18uYFPtbbZGzyQ7L8YVNJBGP1X5ag52
         x5lw==
X-Forwarded-Encrypted: i=1; AJvYcCVjyd/MJMFTyggZTrv343kfhf6q+2PKhMigh9fCAKdZZhByrKnr1OOKpxg1eM8WL9h9wCSfJ2NHZQ==@kvack.org
X-Gm-Message-State: AOJu0YzdEQjvrrF/p2L34ysXpfsAThXpbldsxpd19gNWANwGDo2BGipD
	6+Hl0RtIqKPZSxPmvd8Q/1t+F7MCznKS0lBzikHhHA3voOkiTqyJpLMB
X-Gm-Gg: AeBDieu+NZy9/eDvVIhsSDvbK675mz4Ej6D8E4g+z83qtBbWDx2h1aDusGcdWrYZv77
	joTiOUYGjwysLu7E1lhQ7grwB/6PNvWqGb4acrCFoC1Kc2/sGU0WxQNpEiRDOyzp5bDAF4iEIBf
	I3aSguR90YhPrUh6ytoumI4kIyOA6/IwlbI7TKDvVrNxwzEkS5FwIGIstcxx0JLQWCv10KQbH5U
	/ZlaTao0zxMBvsxjbP9lRsuFDWYGOejlI/y8AEakpVkjqREfTYsdUKetI1saufrrToIYqGCm91p
	76mFJd/3EHkSS9edJl7KqtPi2TsWX/cjrhWo61SUHeeBu9Xuc2SLfMFVrOznQID032iOSZw8Au7
	P4pimw42JaSaMwno4Z/jdDV+CgG7cb6vp+NR5cgIXzhq5xC2zFP/Y2fTZuXGeRLzWlovgg6J2q0
	rTZsD+WtShIxsaXWJ6Yk4pDxf0X58=
X-Received: by 2002:a05:6a00:170c:b0:82c:ddbb:7db3 with SMTP id d2e1a72fcca58-82f0c21d396mr1954892b3a.25.1775796200399;
        Thu, 09 Apr 2026 21:43:20 -0700 (PDT)
Received: from celestia ([2402:1980:898b:301c:d085:a35:99e7:ffec])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82f0c30e7besm1200109b3a.5.2026.04.09.21.43.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Apr 2026 21:43:20 -0700 (PDT)
From: Liew Rui Yan <aethernet65535@gmail.com>
To: SeongJae Park <sj@kernel.org>
Cc: Quanmin Yan <yanquanmin1@huawei.com>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	Liew Rui Yan <aethernet65535@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH v4 2/2] mm/damon/reclaim: validate min_region_size to be power of 2
Date: Fri, 10 Apr 2026 12:42:59 +0800
Message-ID: <20260410044259.95877-3-aethernet65535@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260410044259.95877-1-aethernet65535@gmail.com>
References: <20260410044259.95877-1-aethernet65535@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: z3bns74yrpztgecgrwje95djqky8r5db
X-Rspamd-Queue-Id: 932AA100005
X-Rspamd-Server: rspam09
X-HE-Tag: 1775796201-108142
X-HE-Meta: U2FsdGVkX18k48plRIhuNGqifIs+B6+636MMIlbcTlr7l9pEDdWclSbYWgK5A7jZg755zxudjyYy+hitJdY1B5n0JjyLD2RzWkf3Cg/IJSCEW6eB4WIiObkEN7o4PboiAxdG5BVWQIW+iEhn+IWCmiGAH2q6WXlXeLMSZzw6u8G9q4lCXR3R/gB/A92VexaOpYf4Em3MhYpf7lM8aX66JsXnuriKqPXb1jBAK0eWT9S2qZ096Au6TIOqY3FAND8WV2xW20j8ctARJ8EiQ/JSfB2ImDT652xIOn0Ni31/ox/BX4uF3V0ypkQz4gcEmkvW0RWJ1UrKa1yjbwBBQH6B2rZhykswKIZRbx4fIopx4sRpx20YoAZmi1jv4NE+aDTSpB2unMFI/GSOEnpAVCj1bMDtNwPO8lLSeasCcM4nC+xXlSSfsS9NkvnPYy3YF7UcgAm0NrdnZymXOvbTtVlFih9P67jaP6zhe/MGtBXEVZftLlzWJ1coopgt77KBF4zotKyY8/LuNZLzIY6pAx8TcwToLQDuwsSdgsWuTkgFPZSrxqzl7H7Me3WzLJUGUSCdHJonDHdumLLFf3kRam9VLqaOaFTAHQBzsPYz7SWFztLbdcCHroboG0Hwpzsox7oBo5UP9DLI+QR14nKtPKWJDaFvZ1ESNVxL+r7oQdzYTVF72X4sCyRVX3I07HlHN8Xdhsx9jRRQxMP8dWYZsXIxmvrd/7WrGQHjmRpjFgXI8v00xFAWKvkeGgmYi8bV7azHIhAs6JygAe9kLVjkvqOnUoUMl1HWRczkFNEDo2O93AaRHK55CPwr9kBUV0cftQY2SAlgUd5xJaTAna8fZ36iWuXPwBTwIk72vx7wAVek9TQBCEtfrXMampyqGGLmCdJyoXBGbNghgm15Vc2S9RwBiFHZESRrC4qwSLmI12zx19O4D7XcS7sRwTRZSS68ErYD1jqm9oTqXjhiUtGUs2N
 aDliSaCe
 asVudeXVzU8k+07BZZb83JrDzgZxjH2lb+JGcRDvJ7mMeOLZopYEgCfkS6ceCnRu1hQ4d5+L8RlqCLizn7GQMwrIWOudRW9E4eF3gf4I6kw8rBewC/zYtsVAXd5RSsIkzadgYKlnoqaYPV51P6SSKFyVnaxtJcLkcEUMLjxNmp03019VezU1+//mq0Y0XzN7V1ObeZVIRJHkLp6wV6tNsh1tSks4S1YHQ+DZdCYCJHxuv2QOkg38Gqnu8gtAjTfM51dPJ0kMFpxWOrzGIU/iDgLO0JWaSU/kIHRFh3hVNIIx9ITU9gxYouX1AqR4zwICnaZMfEPSRlNGC7R5NfInPjUdGes5QEsjH/ynJC+vvs1KOWOvXwbEXEB/Qs9fLIqQ4zCGCYxvWp5HMBIz+lBMWNJRNzZlkUKlNvK7n3KOMveWdnXCkJU/QiscQo7N2kX3mHtXKasSkyKEmY/tZYJEJ6BXsR5WwLvsGprsXA+GuuCp06bY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Problem
=======
When a user sets an invalid 'addr_unit' (e.g., 3) via
DAMON_RECLAIM, 'min_region_sz' becomes a non-power-of-2
value. This value eventually reaches damon_commit_ctx(), which does:

    dst->maybe_corrupted = true;
    if (!is_power_of_2(src->min_region_sz))
        return -EINVAL;

Although -EINVAL is returned, 'maybe_corrupted' is already set. The
running kdamond observers this flag and terminates unexpectedly.

"Unexpected termination" here means the kdamond exits without any user
request (e.g., not by writing 'N' to 'enabled').

User Impact
===========
Once kdamond terminates this way, it cannot be restarted via sysfs
because:

1. DAMON_RECLAIM is built into the kernel, so it cannot be unloaded and
   reloaded at runtime.
2. Writing 'N' to 'enabled' fails because kdamond no longer exists;
   Writing 'Y' does nothing, as 'enabled' is already Y.

Reproduction
============
1. Enable DAMON_RECLAIM
2. Set addr_unit=3
3. Commit inputs via 'commit_inputs'
4. Observe kdamond termination

Solution
========
Add an early validation in damon_reclaim_apply_parameters() to check
'min_region_sz' before any state change occurs. If it is non-power-of-2,
return -EINVAL immediately, preventing 'maybe_corrupted' from being set.

Fixes: 7db551fcfb2a ("mm/damon/reclaim: support addr_unit for DAMON_RECLAIM")
Cc: <stable@vger.kernel.org> # 6.18.x
Signed-off-by: Liew Rui Yan <aethernet65535@gmail.com>
---
 mm/damon/reclaim.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/mm/damon/reclaim.c b/mm/damon/reclaim.c
index 86da14778658..2747eef5919d 100644
--- a/mm/damon/reclaim.c
+++ b/mm/damon/reclaim.c
@@ -204,6 +204,11 @@ static int damon_reclaim_apply_parameters(void)
 	param_ctx->addr_unit = addr_unit;
 	param_ctx->min_region_sz = max(DAMON_MIN_REGION_SZ / addr_unit, 1);
 
+	if (!is_power_of_2(param_ctx->min_region_sz)) {
+		err = -EINVAL;
+		goto out;
+	}
+
 	if (!damon_reclaim_mon_attrs.aggr_interval) {
 		err = -EINVAL;
 		goto out;
-- 
2.53.0


