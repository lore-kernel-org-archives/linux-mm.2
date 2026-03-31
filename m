Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C0199FF60DC
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 07:43:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 10E1D6B008C; Tue, 31 Mar 2026 03:43:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E4456B0098; Tue, 31 Mar 2026 03:43:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 021906B0099; Tue, 31 Mar 2026 03:43:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E42456B008C
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 03:43:10 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B140A13C0E8
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 07:43:10 +0000 (UTC)
X-FDA: 84605567340.30.C55FDD4
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	by imf06.hostedemail.com (Postfix) with ESMTP id DDC09180003
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 07:43:08 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=FOu7wqdx;
	spf=pass (imf06.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.210.177 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774942989;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=H4zrNQ1+hM10X372wm0lwqlhzeSkOK5YKY8PR2eVC/w=;
	b=JoH9fKlFUDA8oXhR/kGg0uegHQmVqkqCZUtsEkH//ukBNTzy/MXDbnPIEn0bWzuSXSdlxN
	mwZZVmAKpq8Zi6wxtsWhdJ169G5hZBwRWvGQMy7Nzd3q47olVhRU/6XiQOEyXBwhAvty/Q
	R6tI1L/YVGAfvGBcYWnaU7FmqvLnkzE=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=FOu7wqdx;
	spf=pass (imf06.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.210.177 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774942989; a=rsa-sha256;
	cv=none;
	b=b0rNHytjd1Na7ZbreaOE/l7PN1d3cVXrpOhryMt9wVAFVaUhOjsOcKeMkhytfspZYeUF00
	T3oSulWJcxBXyPQqzB8pifKaK7cB1HZ4tOuxwHgcj8ylMWf8ffmXiohhyWc5mwz5ZQcVR/
	xdyyfU4YzALYUv00ilIB83wW4UrFSCo=
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-827270d50d4so4809070b3a.3
        for <linux-mm@kvack.org>; Tue, 31 Mar 2026 00:43:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1774942988; x=1775547788; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=H4zrNQ1+hM10X372wm0lwqlhzeSkOK5YKY8PR2eVC/w=;
        b=FOu7wqdx463RujJ+QP57NLnlgjLd7/Z5kMCicyqwUPkrHIxB3pLqWmwt07K8Zk9z67
         2VO49BgYIZXrFsALrCpI6THh88ytpJC/0GLzURzqe27x2RwvFV74L1psc/SnuM0RDrWs
         m7kTn/E2ssAQsaPwuS+b7BFDlYuMQz8cgBuG8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774942988; x=1775547788;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=H4zrNQ1+hM10X372wm0lwqlhzeSkOK5YKY8PR2eVC/w=;
        b=qLZusu/cxipmpvmNZKJ7YRcxjFp3heUTS4DcsWOwFXONVWw2YKMfiW2WsLnjQInQeO
         91Y7AYkVZRymZtQGuKU41MtAPmdB6Nj3ozc8BWlaTlESSGcx6LZ5g8PkltVI57z1zftB
         uUbvcLMmuSRxNCwoK4z+AG+qLnNBzDpci5MtVqvdqPUyxQmvzqZ8L1GkwEZyr6RH0Vue
         Ux2LEkKsv/dgbakvYB2y4krAHgCa/I4oUD61Ez40n3Ebr/oFbUCaDqG/Jkh6vkHdx6Hh
         H8wJ2St3Z4SZ5ulML+WJCLwrVD2v/zCb7ZBWEwRMA56gDulBErGF0lLsDMYxnTHTdMyC
         4wAQ==
X-Forwarded-Encrypted: i=1; AJvYcCUa54C/fv9F6uaZgg2apUuSVQhFrilk/badyistA0XOg7jwYhSPxQo15E7YCwNuSBSRoJS5j8DQFA==@kvack.org
X-Gm-Message-State: AOJu0YxPVs+e6b6YvV27WkQqStt6UcuQ8W434Dfie1m/H8uh2EQ/z6fK
	8dqbBqM91opZ+TXoV7AtFMlqo+JhaRMWKmsjk8f+f0STMh4J1EhB+y0i9QK7Jrz40Q==
X-Gm-Gg: ATEYQzxIN0j3X5T+HH7hsinYWIdbTAl1YJJ3FpjgHSvt+s23Z7EsQ+ZedwuRPFDQKOA
	lnYyXQA/jJflGUIDM9LZBSXMqV6XnnNT8brHF2q5pcOdB1uwSfCP94rLnEgYK/LVn7L4W67Fu0M
	3/f78hMZxaRYNrJ/Vmv5T2wDlXwYeGny1B3wtEM1kQx1OJdVYlTkDy8Nz+56qCujWd38Gz2nNNE
	Zn8YbHWO0OxC2vp+qIAhsITgac58C3LSDoI/ew6f1GTZVOYOmLZCS1d8UMuJZEZ/0DiAfMXB7C7
	WFHymmE1HMEAoMtEBKsD7oGkXNHwlIdSBp6ghlTdjGA//1xVl0uCXsvn5f1MbMor0ezl9NXVq5B
	jdclOw79cVr7LheV3pgSakfE0kVzvPHj1iNsiwWWItnAD/nwBKLB2TuFnd1FfcGUxl4I4gDg7wf
	kSaJq5oFSqqjNyYlBWHZJ9Z9qRcriH0ZnD9/8Fk0lUA+w6ilMxTP5Mxz+bt21HVh0AWY23m1izy
	Rx4cOgNC212Bw==
X-Received: by 2002:a05:6a00:3486:b0:829:7d31:dd9a with SMTP id d2e1a72fcca58-82c96002073mr14909919b3a.51.1774942987629;
        Tue, 31 Mar 2026 00:43:07 -0700 (PDT)
Received: from tigerii.tok.corp.google.com ([2a00:79e0:2031:6:90ef:61f3:1679:56f5])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82ca846e08dsm9447759b3a.24.2026.03.31.00.43.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Mar 2026 00:43:06 -0700 (PDT)
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Minchan Kim <minchan@kernel.org>,
	Brian Geffon <bgeffon@google.com>,
	linux-block@vger.kernel.org,
	linux-mm@kvack.org,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Qu Wenruo <wqu@suse.com>,
	Avinesh Kumar <avinesh.kumar@suse.com>,
	Christoph Hellwig <hch@lst.de>
Subject: [PATCH v3] zram: do not forget to endio for partial discard requests
Date: Tue, 31 Mar 2026 16:42:44 +0900
Message-ID: <20260331074255.777019-1-senozhatsky@chromium.org>
X-Mailer: git-send-email 2.53.0.1018.g2bb0e51243-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: DDC09180003
X-Stat-Signature: y93s4rzmzpuwxx5dprf6cw1kxpsdmhmf
X-Rspamd-Server: rspam06
X-HE-Tag: 1774942988-316439
X-HE-Meta: U2FsdGVkX1875VE/zxdCWCK+3gvdXqKp/kxFPtBsoS73irQi5EQeQs7UWhe3sUq860bpkBcpA72g/iSt/Wcb1JjSUPfuTns0l0bkyvo9lUaFT89pxCXRoxDWfkSrtFb+CkXpyGMVeKIjofxQHlKxFjGDIp9OeH12f27ib7F2Un6lvB5Cx2/PC4Yo49e8NJf7/vj/zfYsv6Q5L/SMC9F9D+45Y/ygIPzWzNKNoSDBCC91jd/t06DjfUFammWYHkn2y2M1f+ZtG/qpvXuvMH1ZnuwvsqvLh6dP6eVi860w+b1pVP4UWNOBGAVZr+4dmoaWJbEtzxNvrzAxrI7Ldg5RfGdd2QgGw+BgLmbhCS4rbPxT1fG+5YqjOI7QSwOnh2LhpxqIhV/tWWJMy3edQLLIkJeB+mdgXDQIU13uEKLUrjVkfh2lsibg5pUgDcwEhocMeNLCATk1wh0SYUIL/1XLmHB78o/ILOrgECw8EpTakWfeJhN+iZh5O+x9AdR0W/eKztfpVp6LMrYL0AomGKSRY0YFnYdxe7PXIoM6IF2qNwcseFDOp0T3kEZClXNbL5iOfOuZ5XPZFfUfHvLN9HTnt9Czdopmdb5kOTv2Oi9UgS87aOiaTiNhC+tpVo+EsBXir0IvRIiq00nBKrACyETOe/qKRU78mrUpJs8R1VmONNv4q363kMQSZlmQGIt/d7ZdNSe4yDfhNeUQhJdXEm8be47ZfuRm5WUrk5rD7wqCgcXCS8MAg4IxqIW5gCO5FTT/E8qLlzDvtbBwOV6DM3obwH0pZ0//GQkm7clXAy8+GgUVlRQtaphuZXnWrvpjxEwtXjcDIGZ8XFoiRBL0fzkRwAC9/A1LtisAv7B0uqYUSPmsVlGnXOHU1W6uxlsRGou6w5I/puJhEhk5lTcH1bhl4q+AS8TV2bJywc0SYj4v3b2U7P1DBcw4ueo4HWB1qfM/8gwsXpATNZg+yLNjT1m
 S8FQD2en
 bNwM7jfnTC3wdOfSHsCThecHjhXUENR96scUWee4r/T+HnQsswZIL/oX6XsQEOKqBPTe/kW+FsSHSrEGCWB1cUiLD4tg5F8bi6heUew7ESR4GNkUPCpgynSMYHk2iWVbbX9S0/TadRoCUDRerdyO6l4ITwFa7/9Cc4FrEX+R+AEsmJ9Zsb/mSSRwGXMKRpIyypSqFjFnCea05XYMRvMCGmjrfA552O+LKwqC+SHU4Kj9LGbkjUa4Y+nrxhqKcQzog92iXdWPb4JD0YNNWJUSkOEU9RbNshgFtIaoZSRDsJSzBu3TYtouXEFrnIePmQMVBJErho0mwueOyviIPM2S4BivnWZakqvPbC182uWiFTp3iUusNeDq2yHXc+DTys2LmqcPN
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

As reported by Qu Wenruo, the following

 getconf PAGESIZE
 65536
 blkdiscard -p 4k /dev/zram0

takes literally forever to complete.  zram doesn't support
partial discards and just returns immediately w/o doing any
discard work in such cases.  The problem is that we forget
to endio on our way out, so blkdiscard sleeps forever in
submit_bio_wait().  Fix this by jumping to end_bio label,
which does bio_endio().

Fixes: 0120dd6e4e202 ("zram: make zram_bio_discard more self-contained")
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Reported-by: Qu Wenruo <wqu@suse.com>
Closes: https://lore.kernel.org/linux-block/92361cd3-fb8b-482e-bc89-15ff1acb9a59@suse.com
Test-by: Qu Wenruo <wqu@suse.com>
Cc: Avinesh Kumar <avinesh.kumar@suse.com>
Cc: Christoph Hellwig <hch@lst.de>
---

v2->v3:
- updated commit message and added Avinesh Kumar

 drivers/block/zram/zram_drv.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index dcea703a6766..aca67d7144e4 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -2684,7 +2684,7 @@ static void zram_bio_discard(struct zram *zram, struct bio *bio)
 	 */
 	if (offset) {
 		if (n <= (PAGE_SIZE - offset))
-			return;
+			goto end_bio;
 
 		n -= (PAGE_SIZE - offset);
 		index++;
@@ -2699,6 +2699,7 @@ static void zram_bio_discard(struct zram *zram, struct bio *bio)
 		n -= PAGE_SIZE;
 	}
 
+end_bio:
 	bio_endio(bio);
 }
 
-- 
2.53.0.1018.g2bb0e51243-goog


