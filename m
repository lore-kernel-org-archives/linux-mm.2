Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BF264FCC9C4
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 06:04:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8ECF56B0088; Tue, 10 Mar 2026 02:04:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 870CC6B0089; Tue, 10 Mar 2026 02:04:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7524E6B008A; Tue, 10 Mar 2026 02:04:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 5FF676B0088
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 02:04:21 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B38C013AF9D
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 06:04:20 +0000 (UTC)
X-FDA: 84529113480.05.CAB6046
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	by imf11.hostedemail.com (Postfix) with ESMTP id DDBDE4000C
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 06:04:18 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=Ks6qJjM+;
	spf=pass (imf11.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.210.170 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773122659;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=TcMkfkqcCmjFUwCLyfQBIcEGfJ4AtjBgCr7uCX9+Zgs=;
	b=OzQUjA2mo4mSr7AWiMoVLMu8gLX8qqigBXEmMSJVPgp2jRl3NILZFxWxByh6/ZsqFBeNF0
	6IM4xubWmsxukaCVwMcrps9rNkLOf0IloswsYksXQiei9nNqRkdtqYe1Js2eqJsb8Gk3vv
	lHbdovp7plJFBzQTpFvXQO1jNnc9EMo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773122659; a=rsa-sha256;
	cv=none;
	b=kLotHiU8fFbQ+ZnowdjuBm0Nn9EfD5xWNztWf3seSNH+4VdiiSnDmkLq2nfeLi7Pat9tF7
	g6oZPPc00ZRkkTBlBJlVGG64CrLXgk55oOg0k26leI7V044Wk6cpHH1DVQucv+MfZRtpDr
	S6ywu907aPxcZNSrpLqW7LyW/WTdi64=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=Ks6qJjM+;
	spf=pass (imf11.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.210.170 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-82748257f5fso6881346b3a.1
        for <linux-mm@kvack.org>; Mon, 09 Mar 2026 23:04:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1773122657; x=1773727457; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=TcMkfkqcCmjFUwCLyfQBIcEGfJ4AtjBgCr7uCX9+Zgs=;
        b=Ks6qJjM+ZktQQrlHwwYjtnwtxBy8H1+ZB87qLQLF5gjpJQjI26CNluKgR+nWcO+kmk
         R99Jv1K8UEhX9H9bb4yAwANSLfGE+RcLA7CjV3uSkfuLamRlJ3Qe0FJmYcKetee9Uwyb
         WqEGWgCGqmUBZ4UDGyumsTXICl48q5z0hUdeg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773122657; x=1773727457;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TcMkfkqcCmjFUwCLyfQBIcEGfJ4AtjBgCr7uCX9+Zgs=;
        b=fCTbHBxo2at0gBxTJO4cfvT8TzWQ2kHdqoLPS+PT1X/q95pR+gs389hnUvY1L/9WXg
         4Do67HSN8MLaRUMGefxsCRtBZ/gRmZ44uER93BewKrS7Of/gS+D19WchN40od3zM87l8
         Alo4uDDETgEV8kbAfcni1JYkcZlvsLdw2tPNxEIyJtL5yCHJNUvusFfargqB+Xqnz02q
         jpXbQfZz1Ptvq6CSXcXhOoXWWrVd4CN9yaMvQc7FDzehzPO6S/6IT/ysYJVYwjz904op
         KauYrYeyzdc2UCO0YjhqLOvqjNRtYaLE/9jFXbIp8s861Gslw959oVXf7WxKvppWrBZn
         hUmQ==
X-Forwarded-Encrypted: i=1; AJvYcCUAfyvLThcqrZpEaSAwW3za84y8bIdQgWVpzAoR+h0hAMbiVa5AfTsCE5d3kWd1H/Z80lg77t3ogA==@kvack.org
X-Gm-Message-State: AOJu0YylbJURhJwhF5LU2Fv1LUArHOJp6ESB61HbPs1QmJ3hm+huszO4
	gsL7DI1mIczM4QqljnqX1Z4FlI8cA4a0FmQQ0eO/5Cfgr/E+3ZUuTKxDRGtuf3yqcg==
X-Gm-Gg: ATEYQzzHJK//fLmkD66pB6nmcNkIsggteJPNTxt5xoQqRz/ci95xz3jid7z6ZkoGtap
	Yu+Hto/88RB3tSjYUX5q/Ry6Zz/IbWjSBvJn+NKJxZSw4NUABeQ50l1U4WEOFw5aWsCn1BADbtL
	76sgnMR/kvMM0sd+HZZLDrnsRLMlxx1/3Rh2gWCpJjSLj/zYIT5VhkE8lV4yPmJrMdyatk/IjNo
	1d3lZzS9NRpIrtmqyMNCPPhAdgMYh0q06FjJZwRYAJh8cKYd19KxMcQTScRSJXn3Cmmh2tj8BTj
	1eUeTw8uOIUh19tCTV1TVfetP1wNU61gV2dLvxKjeBXRgbrMSv6x90TlcqVdCIDl9+Dk1AjCW4d
	LXejhNuSNambcTyITy43eZO+Glx85CvIqO1fQv05truiITyXBeDhbsBEL27hncndOqUDTb9UFj2
	3nRcfS0wF+/NmS7+p/mbjr9vcHfZ39KQ/2rgUQ/0tPqcbOpBpYq/BuNUljyzPKRNNhOHOjcFixc
	u3UWJQAmWn98Q==
X-Received: by 2002:a05:6a20:9150:b0:394:4d99:ff56 with SMTP id adf61e73a8af0-398ab2dde40mr2134777637.11.1773122657543;
        Mon, 09 Mar 2026 23:04:17 -0700 (PDT)
Received: from tigerii.tok.corp.google.com ([2a00:79e0:2031:6:5620:959c:240f:eb2a])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-829a465b702sm12184581b3a.20.2026.03.09.23.04.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Mar 2026 23:04:17 -0700 (PDT)
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Minchan Kim <minchan@kernel.org>,
	Brian Geffon <bgeffon@google.com>,
	linux-block@vger.kernel.org,
	linux-mm@kvack.org,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	gao xu <gaoxu2@honor.com>
Subject: [PATCH] zram: do not permit params change after init
Date: Tue, 10 Mar 2026 15:01:41 +0900
Message-ID: <20260310060407.1133800-1-senozhatsky@chromium.org>
X-Mailer: git-send-email 2.53.0.473.g4a7958ca14-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: DDBDE4000C
X-Stat-Signature: wabbpirxeqky7exmni941gmass4dt6ms
X-HE-Tag: 1773122658-801149
X-HE-Meta: U2FsdGVkX198WJazZdELmB9Q+XurlApBtRgjWILzm0HzfJfdW6879UhmxAJ+RrVWCA747Ir3SiRrUspNQDdqylovzKXs+Ev6wEJeXRUmxNER/8upg3CT0aY5qGgIBqWwM5ataLlsNwniRTzW0sT7aDRYgi3Xyq0ZNbb/rjIriwKNln3P3QaKgoO3bZAdbvPkWIpiQ4f+GbXdos0R1Ynz5WVmRdDPVGGAO6UhxwenobGxX4Mcg/CZWYPYRGN/q5LLKFD94TZSxj4JJliKFoEj6RGymo21NurgoFpVSm1DCUJ64VWSdcYhOjscu9f8Mm/6fD5iz0gawAHLorrtM+ju++TGTgBo+gulBEESEWTBGMY/Bm2xlsMLa4cgz9WCmL1voJremAtLRFniWljJZAX5Qh6kLslLltjdKGEuxjRjhcbifF3NnU4DPTPvF3OBUutzFa/nrfXy/jh/IuzjPLAdN3t4IUsUcapT5Hd/sQWl1ETNFLF+5pSNLmXkhA6b9pIWZKLPojDU0kC1FIizbxhwcpkf0nW/Z05AvUFCq6Rnnp7Vjzdn6fy9KbHPAY9UVtOJv96UD69S5+pDkfYbAfaf3R4h3eLDh78EgT22Ln7rVB3dg3g71kX6jimroUUDL5L+XdZpOMbS0m/fEkHKuOxSDe9C/Ge5z3KW4WKAjtsK+mcrdGgrws5bPMXdkpagfrb+OJxc//BifGHfko1Ar8bYlzwKl2WK9vBaz+Dha+FSr+RoiQSpNWDTYlJS4q4MQCfwzEoETkY1DD+kHiMHoevfUvjnZtmS09AENyU03SI8GjdrJsCRlzvhABoOz4p1fh/z+B9+B3VgBfhAftjryZdq2BoN02ClOgxT6NRszENrXePuk99Ym7+FW2j9JXCYtmYTWYVRKPX3aMipaoDWBxp9rwQVcdfLQ7G7nmhN6PV5j4OsPKmk22UOHWD1ENnEdGbsDfuZrzOy60PmQiNniDm
 6gJEjZem
 jOiS3DCu1DrlKc1w/70AEDouf419lAi5WlynsEkhpd4zqJYrVVYB34yGIbBCgQokPdekeHC9LsgEm4xN0LYlVXP6cm3IwSiACtN2ymxqz+2NbUilWtwedsXQ4rTNuP+0jaYQBVtMPygJT3fZ5WYDrAVIygCA4uOdd8nXxMmWhQExT+nzD1OcWrLR7XCHa5SOdAkr1KTMckLt8H7OWeGh21nXVDwjb4pA3Ju6qTcmFl6edYWZidWlDcHQ3HZ1BAXnVeTrmLINVArBeJt1DolKw5QvEqmeEfdINdcph7/anb5Xc7svbyIknuLMeR/GqFoFMbP2DgxYIpK1ai07qQSIcEtZKmTdLslPrD/YikfjKpqor4kM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

First, algorithm_params_store(), like any sysfs handler,
should grab device init lock.

Second, like any write() sysfs handler, it should grab
device init lock in exclusive mode.

Third, it should not permit change of algos' parameters
after device init, as this doesn't make sense - we cannot
compress with one C/D dict and then just change C/D dict
to a different one, for example.

Fixes: 4eac932103a5d ("zram: introduce algorithm_params device attribute")
Cc: gao xu <gaoxu2@honor.com>
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
---
 drivers/block/zram/zram_drv.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index c41e1257243f..7551c5e664a9 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -1769,6 +1769,10 @@ static ssize_t algorithm_params_store(struct device *dev,
 	if (prio < ZRAM_PRIMARY_COMP || prio >= ZRAM_MAX_COMPS)
 		return -EINVAL;
 
+	guard(rwsem_write)(&zram->dev_lock);
+	if (init_done(zram))
+		return -EBUSY;
+
 	ret = comp_params_store(zram, prio, level, dict_path, &deflate_params);
 	return ret ? ret : len;
 }
-- 
2.53.0.473.g4a7958ca14-goog


