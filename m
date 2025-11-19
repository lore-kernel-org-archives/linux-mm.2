Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 26D6ECF3186
	for <linux-mm@archiver.kernel.org>; Wed, 19 Nov 2025 09:48:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 80D056B00A0; Wed, 19 Nov 2025 04:48:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7E49F6B00AD; Wed, 19 Nov 2025 04:48:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 721C36B00AF; Wed, 19 Nov 2025 04:48:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 62B376B00A0
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 04:48:13 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 137E112EFD9
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 09:48:13 +0000 (UTC)
X-FDA: 84126880866.19.38FEB38
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	by imf26.hostedemail.com (Postfix) with ESMTP id 28006140007
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 09:48:10 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=iJdjnJDJ;
	spf=pass (imf26.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.216.51 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763545691;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UR0dfDTMswpSQF4eXghISgANheYUVrX89n8U4+Wjn9M=;
	b=BRrcB1mH0p6KjTrGfV0xLj3BnJxbK3lOcGBeGT48b/QZTfS8V6My7Y9JT4alQ57PYVzA6k
	5zHF8opxgdNdaKuUL9hNqFWVztfu+DstkEvziHxm8ttD8h5edPSJMKbuv6s4Sj2qnD1HJY
	P+icTNLZWxdWVJ4qFkYB9prDuLxxllw=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=iJdjnJDJ;
	spf=pass (imf26.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.216.51 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763545691; a=rsa-sha256;
	cv=none;
	b=ltiH4ASzXN8YOYTQtVvYvI5a0JN1T081X8UgbMpd+IE7866iQpomVzxLhc6AwHTv/YLomE
	6XTOl+UkhwZGF3K+la95SEHNzGDeW3LCFfsho4HprAN2Xzxmzs4WOHZtn8VPxhvBUH4nZG
	Ebk199kELZxhitqWJd8lif5i33mEX7o=
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-3436a97f092so8279976a91.3
        for <linux-mm@kvack.org>; Wed, 19 Nov 2025 01:48:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1763545690; x=1764150490; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UR0dfDTMswpSQF4eXghISgANheYUVrX89n8U4+Wjn9M=;
        b=iJdjnJDJsk8XMSNs/yjpW32Xfl6A3frpXt4Of+ygEh7yzhQA2SnlHdK0FtRe78kwzu
         eE+cWJFXEOhZKSqzVWghvoHuhEizTqqz3MdLCOd3yzM9hCnDIwmMstPJBQdU5lzHdGZ/
         EVTT5GEbk0HNnujlJsevRLjOi8wNA0HZsnuZM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763545690; x=1764150490;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=UR0dfDTMswpSQF4eXghISgANheYUVrX89n8U4+Wjn9M=;
        b=xBUxMu5VApq/h3EIu/enCzCvetrHcSs9BNlfmm2x6FtsEyv/9+UhucJJ2+XM7ZZ+YH
         X/+pB0E9QlRrK6pu3fE3tpOnVaw8NDFWy5NcNSwD79w5NaI2BhrWrYiQSdJzpTzQLPAq
         e8jlKpBM5fzVn/7/ahRlsR21fWeFKoMBG3XxvQNH4185p4TOBJFWn+P729KhoZ34GZjr
         6NF3MDUqLNZxit0I9TdzUF/b8ZMvguHgAEmyrCtn+Ibmb34OsYLyblEtUvsQsxZE/98/
         VdK6V1THa1H30Y1SWX1EFAXRgrqnhPcglym0CbHdA6rOclhukWPqbx23q6pyA5KWj3FU
         cvdw==
X-Forwarded-Encrypted: i=1; AJvYcCVhRflH9rmFgZm7ehQqwHATr82d532EmT0hLJ4XXwe50O0TQIAnGc5GbWrPclMj7EJKCYFkJ7FKEg==@kvack.org
X-Gm-Message-State: AOJu0YxoDlPzJe+SNAhVW99dD3IZvb2hZMqpYOprAk0Z4fxTdjlFUpQg
	QCi6tNbeyzJLHwsOcq9/Waxujlwg+GJIbtPbex+gHZA23YoiYKGu+QBM9K/M0rA1vQ==
X-Gm-Gg: ASbGncuPrm9aKIqceZJ/gDZmMtwxP84Dh18tR1QmUxZdoMPDq58DWjG8ULlhehJotQo
	Vuab9+q3kHKanj7IkXjv6lSDlnqLyki3fk1v98iAz0KGeVxrI7nj7BODAVh/YykXnAPHOWT+RxV
	5kLAigp6fLelxYcDL2WKVoSr1rfOQeiLlWRw+r8XWosChE6ISpzAzGQ1vsqPFYWBEMw1fUPp0ch
	dkMu0lBLjNDHOzivwRyFxFd0gBs0/FrE6c4plBnQAVMkBoJ/24dJbKnbBP0I504PVYDuy0ZziHy
	J6nGFK3dGb1frSvQ4oIoTGa0NYiHz9zF73GDEA27Yv8t5UYDwVHFYsThaJbr5KmcvTRJLb0bAiv
	fu37lpwXs5IsTaivX0sTApLcPGOBmdSft7hLsHmAVBJCOXg4hTnwpFaaRjnJfrvWtRm9dFg8n0t
	WQMLcoIpKkwexxJOpTAJ1Qtp0Jkv6K/IYa5b8=
X-Google-Smtp-Source: AGHT+IHe+ohlC0g/VEJ6nhinde8VQVU5BW1Ybldi/0rC52KS8PPwT3oJOJ8dI3Qwu8BJFpXqTOPhQQ==
X-Received: by 2002:a17:90b:1c06:b0:341:ae23:85fd with SMTP id 98e67ed59e1d1-343f9ea58damr25110607a91.11.1763545690022;
        Wed, 19 Nov 2025 01:48:10 -0800 (PST)
Received: from tigerii.tok.corp.google.com ([2401:fa00:8f:203:5505:c63:fd70:efb])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-345bbfc8d8esm2209498a91.2.2025.11.19.01.48.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Nov 2025 01:48:09 -0800 (PST)
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Minchan Kim <minchan@kernel.org>,
	Yuwen Chen <ywen.chen@foxmail.com>,
	Richard Chang <richardycc@google.com>,
	Brian Geffon <bgeffon@google.com>,
	Fengyu Lian <licayy@outlook.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-block@vger.kernel.org,
	Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: [PATCH] zram: fixup "introduce writeback bio batching support"
Date: Wed, 19 Nov 2025 18:46:53 +0900
Message-ID: <20251119094715.2447022-1-senozhatsky@chromium.org>
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
In-Reply-To: <20251118181235.4F5C4C2BCB5@smtp.kernel.org>
References: <20251118181235.4F5C4C2BCB5@smtp.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 28006140007
X-Stat-Signature: m8u5ci96r1uoow87acbjmz6nzdf7fe3p
X-Rspam-User: 
X-HE-Tag: 1763545690-266484
X-HE-Meta: U2FsdGVkX188xRPl8Gf9e/hyzS+cuSNUEfvfGTA0vJxdJUkTFNsOW4KZ9z/bCrEwg77sAu3KAaMIvFGn7smQVe+JE+Xhoxd56jQsqBHh+FxBNAbnkNmit8Cplfy8MMKhRRVbddor+vZy3q8tlyBYe2VNnuwzz1YwxbZ897hKMfzNuyW0ditIZZZw/5nn6uhlfdmBIrTvKs2rPN/5W28cLuaU7UcCdgwtGd5vWMKD5PNylAjSCsgKd0+827q4UZOZ9Us7aQBP69NmoDoFUS79+k5I68lpFnQbCV9Y5CH8xysvKEPqew8YSO+7V057xXFthVS/vqI8FLWeXzDVnFuwgF5kRFArQtUlQ549Q6ObtW3GsvyI9sNHoPZJJEAONqOsQo5vxGn97MhySpLG3o5jQENnShQIxCKbZ69CHamPYDFkwDK7eCSaifR2ZNOwYo6cd5XXa2iVEzHw2cnVcHZE1T5vwcCg115hHyE9ihbyKvlCyvDR+58ki8UMi9LVh6+NABKdzWBg5c1T5lktyzDOIsXONdlP7WU/a6Hv0X4pftMyEtcH4ZEsgLCntdzvkxfykDftiPeUy9R/Xc23Zqp3oXPaBC+pDK8bKd0msur9kAWcl/9RkkTGhXAfOe1dNbLQgGdkJJfzvDgf+aMDMQcPDo4MYLrIEV9NhUCcHh5fVxu8Ne3hBFPndQreOghr58/Z8xmWmORx0YFQzfIaHDzS3jzTQNoSEYfKncSz2odnp/Hf5aVdl6tBzD+ALMG66jcvGhGQ1qqUToIELuYb7w0VilKis3m2RnfHxO8C1VYfGrCX30Qla+8jfe5qv1QmCSjd22seqRs7IIARjw0p9R4cw4hCZHTf5oXGT0dt+S455CSieInePlyDssKrmg6ot4foDkkJaRk4j8g9IobUxXT1cqRqaA0bh/MTuBH7YySFU0MhYqnzZyDg7ko1Zy+yRgTF3XL2zKMW8hMsCkEjtMS
 DW3FfT6X
 10+ajIMpUhJ6GojbuP9Zmrm7Gf8WfVSGTWbhY9m3KLbhO0TZNIzJnmgpInGuqgr42Wa1IKigwHpRMNNor7SpqRHCc2oqRlJT6my+kB/IA4j1g4kye0h3gd4xUF3HFXH2mbHcZG0PJiLAmeeYxu/jQphBAE+hKrTOlwx8WVrDzDe3CkT87johiXnv0UvPZ41MEQwoiliv+y17msfxH2Xj+pOQWj/1hvah258I3QCgyQ4Zqe7rHjNIwHCPGT6xthKZD8r5hYRwpC0uz3/fYKm+PyQ01deElm9134gi1OH7luVsysUvfQAv9vCfymA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Dan Carpenter reported a missing NULL check.

Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
---
 drivers/block/zram/zram_drv.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index ea06f4d7b623..61b30c671a56 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -760,6 +760,9 @@ static void release_wb_req(struct zram_wb_req *req)
 
 static void release_wb_ctl(struct zram_wb_ctl *wb_ctl)
 {
+	if (!wb_ctl)
+		return;
+
 	/* We should never have inflight requests at this point */
 	WARN_ON(!list_empty(&wb_ctl->inflight_reqs));
 
-- 
2.52.0.rc1.455.g30608eb744-goog


