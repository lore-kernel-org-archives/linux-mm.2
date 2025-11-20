Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 81733CF8865
	for <linux-mm@archiver.kernel.org>; Thu, 20 Nov 2025 15:22:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E0EE26B00D1; Thu, 20 Nov 2025 10:22:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CF2716B00D8; Thu, 20 Nov 2025 10:22:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BE18D6B00D6; Thu, 20 Nov 2025 10:22:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A94ED6B00D5
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 10:22:19 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 22EBC5643C
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 15:22:17 +0000 (UTC)
X-FDA: 84131351514.14.EE87A29
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	by imf14.hostedemail.com (Postfix) with ESMTP id 29A4B10001E
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 15:22:14 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=kLEayVaS;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf14.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.210.172 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763652135;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f8KDeSPboQyenPsR88PS7oH+E8JUyOLPtZOOBoNoQpo=;
	b=Tuh843/vypa0Hk68vVt1+A7qPvDv7/wznxcrMbCKXgv5vG0cDS4GwaN97DI/F9ke9RtRm+
	p0xJ9avy2eNXggQqM3/4c52Q6ckpPpHoKnxZwhqczjw6QXZvXFYQKP1YRQlGKYZBWw7HdN
	AsKyj1+vqZzkAKD6KX0lL/CnjQ4vqWk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763652135; a=rsa-sha256;
	cv=none;
	b=v4P5PJepQ5NFDjr01goF4QEQGfXiUFahGhJrWdKH2BYwag8zQplNDRuF3JUmmsuP4acqfh
	wJYP76IxYHET5ouqHMW37Wn0WwDFY+PD09zopjxub1MJ0QBHGo7hy/aEq1/Un/otyTwIW3
	cnFhnDa14e+h/nmRJer41sXKo+6kzuo=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=kLEayVaS;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf14.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.210.172 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-7b80fed1505so1100794b3a.3
        for <linux-mm@kvack.org>; Thu, 20 Nov 2025 07:22:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1763652134; x=1764256934; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=f8KDeSPboQyenPsR88PS7oH+E8JUyOLPtZOOBoNoQpo=;
        b=kLEayVaSQUjIUtLYHQvk6NzprdqGoAWI1nHBPOU5PRKdtt+d4+dZAvTMVpjABjjb+x
         XHabz4UdjZUCG97n1yov6jyrMmrll4pReN8mHepljPlOamOkGFMXVe1b33Kqld0GjCw+
         czWb1+kHw0jCJn5TXKJQwCoXMqx7PNFyReAgQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763652134; x=1764256934;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=f8KDeSPboQyenPsR88PS7oH+E8JUyOLPtZOOBoNoQpo=;
        b=Gx7pBQsFRyB1VFcGRBCbzOUVC3hwqmelMs3ZMGv0m5Q2ZGkslRuTpwvhYhGONK0MgE
         Q71KwWebzDZj0cGB7keaXtfRnxFDS2SzDdMW9THwBktgGIY46Aw9neyTCuwIe5r3vhyS
         0WYxG5Rn/INt7h6+W9gIAIJMyY8PBFdvSY78PQvrj7M8aeFtNJ8biHTo3b+Ai+Fla78T
         j9Idx7Zv8AqTsDvj5uw1zsMaWr2EkxWM6LGTTlyMY1rCC6owzmgzk1+u7hiIkZyW11CF
         +FxXWsBS3r4MyQiv1+pVj7aIFZRVM4C4GpaMz8jAd/xr7dCLzbAYCjtiPexmsDOz6OyH
         pIsg==
X-Forwarded-Encrypted: i=1; AJvYcCV7NkQVEHA+yMTPX0z29yp8snS6XbrdFp3qTv51YHTgHxQZgSqqc2acEM3zczX16yH+hRjNODrJbA==@kvack.org
X-Gm-Message-State: AOJu0YxkGRgO1A1YiG7YkWR0eRQ8phlWAyHJ+vdWMmJ+SI/2Rq/iUEvi
	KZNudFdF087ZLqopY9i2NHrtkUfdgddSpV1x0NIg/FXakFGJa+HkKInP5nWPwP5g1A==
X-Gm-Gg: ASbGncscxK2xDoNE6b7oAZeV6toftW3rWdlB30c/nRXJ5HWjDsCvkcUG++tF0cfEt3y
	yKHT7EDehmb7+htEnLvcmC+KDtD5lz8jnZyUzXqdpRPGUVTPri+zmuc0gudCx3dTGk5RXRAvVe8
	UO8t0CgXWpyFgDFpzlJ6Fo4NIRhvctOLw2U31GgyYx1hwEz/2OZIEp0JrvUxglFS1s1kQHIt1dg
	xJpVg+zfpkbO4iF4Beboi2TyGv3qB63psuyNyPQnKzhpuUBWtgXrODV3L7ioeb5VH2TwFgJix5w
	f0TNLKbcGdI/Mnqt0J2tpBc3rl05vFsouxVpknrkiscJm7V1o1OheoU9nn+UVMs4eml8OHRIjMK
	QmImfLA9VqhBMuiKXfoN6LOjyuV3v15XV0fv5xteQRakDeUQSswd8L9D2e6UWdwgns9WCyRu432
	Rwzos6FJcbbNjrjc9gssg9Y+F+e6Uphp/sICrv0w==
X-Google-Smtp-Source: AGHT+IG2i3ZVAyerpko0bG5HQErQy5GRVNKpfeYhSDmo+oadwIZX5NPw7Ys6zkScWliwVzH5YQeGVg==
X-Received: by 2002:a05:6a00:3a0d:b0:7ab:6fdb:1d1f with SMTP id d2e1a72fcca58-7c3f7695779mr4532606b3a.29.1763652133881;
        Thu, 20 Nov 2025 07:22:13 -0800 (PST)
Received: from tigerii.tok.corp.google.com ([2401:fa00:8f:203:6762:7dba:8487:43a1])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7c3f023f968sm3179642b3a.38.2025.11.20.07.22.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Nov 2025 07:22:13 -0800 (PST)
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Minchan Kim <minchan@kernel.org>,
	Yuwen Chen <ywen.chen@foxmail.com>,
	Richard Chang <richardycc@google.com>
Cc: Brian Geffon <bgeffon@google.com>,
	Fengyu Lian <licayy@outlook.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-block@vger.kernel.org,
	Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: [RFC PATCHv5 3/6] zram: take write lock in wb limit store handlers
Date: Fri, 21 Nov 2025 00:21:23 +0900
Message-ID: <20251120152126.3126298-4-senozhatsky@chromium.org>
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
In-Reply-To: <20251120152126.3126298-1-senozhatsky@chromium.org>
References: <20251120152126.3126298-1-senozhatsky@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 19cq7f4u68yg65ixbnbey87cj9srkgus
X-Rspam-User: 
X-Rspamd-Queue-Id: 29A4B10001E
X-Rspamd-Server: rspam10
X-HE-Tag: 1763652134-408843
X-HE-Meta: U2FsdGVkX1/Q6PcJ1SlYtJqyfrX5NLnk6bx+zQYVSbGCcu5NkLaGI0lBSK9UL8D+8XTzNF+TUucvgo2ejXjxpfKMv85Po7pN0gSiMkNuZizNwblVN7BgwKivcBlvhKmdS61qEg4bA2Mb9nUKCge1gj6ZZ0so42AI7UWiB3bpsGEV8goLNAx/F6l/MYPAyu7IIQeLVtDa8AYHcxxuI53YmYSeJrz/Gm1/J3mZAQQae/pDIKbMAX/4q7RdGVWmfzV4XRr1YApFxQkHHspiRwGPJL+HrDEEgUmh2hQYGu7E/Mnny4wovVJqUmG0OZM5ChIyC1EmrQYumh4sjwlmhTuezLeRuTh/ZHHM8jF2H9uOMcpBD+2Lc+W3k2IBfNKhcE+oDchf1bDS5k0ZUw9i6WQAskwu1JuJdc+NZlA6lYa6FORmWKi26B2CcxAzQT8l39eUrWONsxQxQBxcGmkZTEVjeSLsbnLjCfTuWbDVaZzZxhjmcxoUCZLtICzLl9tWGLkt6sSLDQshTfsiohVBT1FrWg5jqrqseR91L4jZDyTcZeGVLEQFWqEo9NRmnNatJTepDrRHWvX8o3WDM7hKGuzVObacNpZ2yQyVsD04Vp3oPTOBiBzQgGD54Py9c97LCp3vtIfikFN3R6RFwCbh95/7psk4UOCLIvZQfjfcPti5qRA1bmjLDhvEQi3kAeUN4uxecARd5lpCtdg4TKWmFYeZ+5vQGt+PXVinTonm8fbUYPwu1BVit3wnJu8PieFDa2Zby8xIBef4RFQE9uyooOIedBQT6X0rEQixI8xaq74kx5ZOB+r5xd+6A7tjdDICoGdzaRI+6Lkn1GuLfqhY5WibpAjNEUkb58763cgcbSKXdNy9GumYKL6GzYRk//VkzWFAesrtlQ/wJgwF4SySZ2K0c1KWKAk6ZAZxlf3WuO8etNChBL7taElV5OFvduvOOJuP70ERWAEPwBTp/5VmLNq
 TW1FD7Ff
 QkF6E7iId5yWPg3BUP76F2sAO4sSkIam2jGYTg1rxXI31c7za4SWOW/y+RfajNDAo0CpRFw/c29iwiVfD9yDHJoASoGT5/t3T3Z4Q8RZicuMFk+d4JApr+mY02kEUteN0QaKqIIOkzrHZJWCAAc31yJkvTHaH2cbhh/GsjAO5NQCNWpwyEuP66i1yQsRROomXTTWUMB31sDbd8c6WYO4YBF6XprA4Ykw4795arp7dmz2Fioq5jVaU7ySFJEjMlKyYmeFoMD5ltwlo6XNxUFP3TkYFs6eyByN7ac6UxoWpb7yxUStSdracKwiuyw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Write device attrs handlers should take write zram init_lock.
While at it, fixup coding styles.

Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
---
 drivers/block/zram/zram_drv.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index 7904159e9226..71f37b960812 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -519,7 +519,8 @@ struct zram_wb_req {
 };
 
 static ssize_t writeback_limit_enable_store(struct device *dev,
-		struct device_attribute *attr, const char *buf, size_t len)
+					    struct device_attribute *attr,
+					    const char *buf, size_t len)
 {
 	struct zram *zram = dev_to_zram(dev);
 	u64 val;
@@ -528,18 +529,19 @@ static ssize_t writeback_limit_enable_store(struct device *dev,
 	if (kstrtoull(buf, 10, &val))
 		return ret;
 
-	down_read(&zram->init_lock);
+	down_write(&zram->init_lock);
 	spin_lock(&zram->wb_limit_lock);
 	zram->wb_limit_enable = val;
 	spin_unlock(&zram->wb_limit_lock);
-	up_read(&zram->init_lock);
+	up_write(&zram->init_lock);
 	ret = len;
 
 	return ret;
 }
 
 static ssize_t writeback_limit_enable_show(struct device *dev,
-		struct device_attribute *attr, char *buf)
+					   struct device_attribute *attr,
+					   char *buf)
 {
 	bool val;
 	struct zram *zram = dev_to_zram(dev);
@@ -554,7 +556,8 @@ static ssize_t writeback_limit_enable_show(struct device *dev,
 }
 
 static ssize_t writeback_limit_store(struct device *dev,
-		struct device_attribute *attr, const char *buf, size_t len)
+				     struct device_attribute *attr,
+				     const char *buf, size_t len)
 {
 	struct zram *zram = dev_to_zram(dev);
 	u64 val;
@@ -563,11 +566,11 @@ static ssize_t writeback_limit_store(struct device *dev,
 	if (kstrtoull(buf, 10, &val))
 		return ret;
 
-	down_read(&zram->init_lock);
+	down_write(&zram->init_lock);
 	spin_lock(&zram->wb_limit_lock);
 	zram->bd_wb_limit = val;
 	spin_unlock(&zram->wb_limit_lock);
-	up_read(&zram->init_lock);
+	up_write(&zram->init_lock);
 	ret = len;
 
 	return ret;
-- 
2.52.0.rc1.455.g30608eb744-goog


