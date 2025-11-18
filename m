Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BA234CEBF97
	for <linux-mm@archiver.kernel.org>; Tue, 18 Nov 2025 07:30:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 241248E0022; Tue, 18 Nov 2025 02:30:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1F4228E0010; Tue, 18 Nov 2025 02:30:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 06BE88E0022; Tue, 18 Nov 2025 02:30:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E61138E0010
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 02:30:32 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9EA5113AC8E
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 07:30:32 +0000 (UTC)
X-FDA: 84122905104.01.BBD7C1D
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	by imf20.hostedemail.com (Postfix) with ESMTP id BE95A1C000D
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 07:30:30 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=YbZUc+IV;
	spf=pass (imf20.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.174 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763451030;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=spTZ0mW8CsK7UvPfRSf8MeqzEHevliS4YgLZ2IGrH9o=;
	b=z5GrrbydEU8g8RWUlQkWVYkjAk+mvGETm0fox6nQL7N2KkWptTb1pCroHH/avednCFzXmt
	WUmZ8Eb96dHFxo+wGK4V8FvoBRsHdk1VpekWw6SBGWwCft7L8gby+D0UQknPh/+4n1H7Wf
	2XC6FAtRrOIOl3FM6ViRjhnEFqhcfHA=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=YbZUc+IV;
	spf=pass (imf20.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.174 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763451030; a=rsa-sha256;
	cv=none;
	b=HUp9Pd58d3kTIsxQxAqXXBsM4LQpZmmC1zTasBrfZ3H3P0X2L1XkUEI3AYtQxUxdq5jcmS
	OAFEmxYOhfyCuu/Vkz7fsZIoPRMYewQdsPOTk+OcJMfM+XF4dRAmqMJi/irk5LJ433o6EP
	DRsGrotp5JmNhJ40aMF/YrKD+iPBrVw=
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2980d9b7df5so54373975ad.3
        for <linux-mm@kvack.org>; Mon, 17 Nov 2025 23:30:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1763451030; x=1764055830; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=spTZ0mW8CsK7UvPfRSf8MeqzEHevliS4YgLZ2IGrH9o=;
        b=YbZUc+IV25W/1z6L3Wn2RAcx2GY+dwT4cRB2VQRe5lipsbqNJSseXNMsacXS5SD50P
         kTe++eOCfPaMiGNQSbYAAvkGxjrQVOsW1MGOBo/5Qdap3tyUR77G2qYiliVlLMGN0hFu
         fM6iiM4ixvek9GCC1WmtAViIWq0VP5lremVOk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763451030; x=1764055830;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=spTZ0mW8CsK7UvPfRSf8MeqzEHevliS4YgLZ2IGrH9o=;
        b=jVLCqqRaD+PY+Wd9jfaoD9+VCsFoKeDF6CihXXJjSENy22DerPI33W61GCrR+jdiHG
         wusUEV2E2FjlmAU/lp66lTJBZt2Th1EynWqvhfju1JoBBtNs4v7zqbgeRPqVuuEc13nf
         +joNuwIvAtu0gQ8i7jHxek9IRUZSbwaJ1DpP4lIPZFvbqu1kJsrLXPO63Gta9Z27N6jf
         JCsVL5zd0qKjyvDI3xc6SUrMfs1BthnUxFFQ9nCD26LQ3AH4pgjZbpbH0ihhcbshCd2h
         ensidZPaGkk1KvXMpylEYy776Op052sheUvSlQP2neXS3uLltMqQkk602XUvaKe7H8Bu
         xR/Q==
X-Forwarded-Encrypted: i=1; AJvYcCVSbXEHzNtE7P6HBn5pDHb52+OLwwe40oBAYJ3YmMiRgD46NAaQKPvZNs6ZOoWtJguGwV58wuuiqw==@kvack.org
X-Gm-Message-State: AOJu0YzkuAg3ep2ieCAlbs2/5ibCxtIGGferJ3HIs55FB7kjVor9TjbK
	icgA2LJ52JHQd7b1LZxeWOX7ZizzLSABzbptgPDkOIw2yBQG5r63rpCtn7Kf2VZoxw==
X-Gm-Gg: ASbGncuwbJDjDaC1Ky0GwQpRjX/E6mxvYZQFTZWIxSm+Jrv4tsyYSnIQl3KP0o5xt9S
	R/Y5ttlpJ8u0FR4GuOR9lBP68GPgJeP854ygUWx7bviu4prKH7ZD7N8WPyuPvaEGLYkCaf944bH
	YLG4lQf/C73s11T3sFdr/8yzBrnGkgfu23J3m27GSKY6qKtrVCBPRRdj4LK6CsIljzylyVtqiph
	MOccvAl2EdnxNKxO7Gq28GkGzAJMTTsh+v19KPhD7XtxdwYEf4w63FkoxjoxJnsPZKIq4Xi1jt4
	fobEQ6pPwFNGk4FchR3e84Z9LrV1Y2WxyA5/3CtuGN6jMHjn9o5LLz1C5yhlbdb/8izvmHnLQrD
	YJpvoEqQEyoy15p5yc1SCF7ibd9l0+wK8Q+yuIzjgmHWiYzsP2YMO8Fsf1Wc7jmGRHMA7eOWmEU
	4gHxXyGIIN/iLcoxGzqNBsB3ludHkTS9fdlYTcIg==
X-Google-Smtp-Source: AGHT+IHfTiRsjOnMwAynan9LOvPqDmjC2nm6QOrpvZK/BiOoKhMq5MVjGe3vyD/jJGgU5d35MZnMsQ==
X-Received: by 2002:a17:903:19c3:b0:295:551b:4654 with SMTP id d9443c01a7336-2986a6ec988mr179562065ad.23.1763451029659;
        Mon, 17 Nov 2025 23:30:29 -0800 (PST)
Received: from tigerii.tok.corp.google.com ([2401:fa00:8f:203:beba:22fc:d89b:ce14])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2985c2568ccsm163926215ad.50.2025.11.17.23.30.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Nov 2025 23:30:29 -0800 (PST)
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
Subject: [PATCHv4 6/6] zram: read slot block idx under slot lock
Date: Tue, 18 Nov 2025 16:30:00 +0900
Message-ID: <20251118073000.1928107-7-senozhatsky@chromium.org>
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
In-Reply-To: <20251118073000.1928107-1-senozhatsky@chromium.org>
References: <20251118073000.1928107-1-senozhatsky@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: BE95A1C000D
X-Stat-Signature: phsmgxoie3s9oeozn43m7rowooush5j3
X-Rspam-User: 
X-HE-Tag: 1763451030-969959
X-HE-Meta: U2FsdGVkX1+QKX7XiAhGFaDAaQEdiOQwBsK9TNu7iOO0wYiia5Ka8XKL4pqR0BC6FSnIcz1SF7r8LytuX3N8GUYiUoKlkMUoGWal2ERMoffC8gVGo75w4gwaWl/A9aUFSEqUhaZkJ2GKRoKzln2StQ6xqXxq0J46unkGg3S3h9WyOeMLNBfLwGcbRLjg581sx9ylYpUZmo2ejym5nYPkNtjAckKuhXvmcPnOlUS16ePrvQMsddc5diXOqgYA5NedydG5qDf448IZVYgsBEuzQ7d30KATCKZA8BwrjLUFAvlB6JP2I+rACFdRcquN5LlsdCJnKEHB8EE5ODYJJaUANcuzXBEliaMyd95quxNzf5gyTIj4meCQCEXGQ96NBDkG153WAZqqDYTgjkfP9UaaueiZm1SFIuQKbaarusUqT5PKj4HFM5MsdGvSK5Strw7EOiU2pYS8S9KSwrC78Kxh1ch/s6mTO+R2VWit35ENJ2SpzkefNFWUfkAqfvPFdX72N3xT7OStGFQOWYyWizXooYGn+xtatB0tQ9lZ2myaW6iZCzee2KCSXYwHo1yIFfMEtxh5NEAGxHXWkpAu1ZefxMVROac2EL3oijRR6FqJSJ7y2CYfgcTSE1nAU1X8AGJp6S/pxHr1KLNzg+sDPFkW+UbbE7S3YMZBtPtzXKKwwUskNOoFqJ/jn1adbR61QpLR8r/I7fyiPCXDM8rYoXB5CA2Nb6Eq3LS7712wFrehTA+JVsQttX8rB+3VOPvrRvNY9JqcenzPnHvC0uo/gSR57ZvMPWiRjMcPE68eFlx9hH9IeLmnOHle8hhygyJfzcvBVX7sHI/Q3EGma4yUNTua6zC6ffN6JBYpfPC2EBTTdPou9wbV2tvL7tTiR/oQeOZd9WJkCe/8XUTbfEO9ETJIa8u3+fZ2DHgEI/0er1viFgCWXJEPo7ZS2RP14eRFUb0tHvqLwt7JT1gFv4piiuC
 xUMhLS6X
 DPDmrQBn0Ckji0xSMCCINMHR4rNB97+GAzvJzc+ub1zHq2+UIKZVQZoTsFtCuam0LGZcsaQzjh83jSGvYlMgIWPwxktn9JrOM+8zPkkv16iYHwWDrc6FfEQouJ/yZV/uREOaZLkPx8Ljyox/G88FTFLDBRJmlJbsWJv1MJhktSYyU0ADB481BlvFKsE7aoEKslGj3IB+RjuYS6ae89wTCiCMOKAXe6hHXrYzoYbGfZvjwZeFpUbQAYY3QHhwYkKRCCq2KgGW8NZhzmlBYOhq9uKRtS74/B63ebclGrbCkt12Iue1OneA7roWnaA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Read slot's block id under slot-lock.  We release the
slot-lock for bdev read so, technically, slot still can
get freed in the meantime, but at least we will read
bdev block (page) that holds previous know slot data,
not from slot->handle bdev block, which can be anything
at that point.

Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
---
 drivers/block/zram/zram_drv.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index 93365811781b..77d0e636e053 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -1980,14 +1980,14 @@ static int zram_read_page(struct zram *zram, struct page *page, u32 index,
 		ret = zram_read_from_zspool(zram, page, index);
 		zram_slot_unlock(zram, index);
 	} else {
+		unsigned long blk_idx = zram_get_handle(zram, index);
+
 		/*
 		 * The slot should be unlocked before reading from the backing
 		 * device.
 		 */
 		zram_slot_unlock(zram, index);
-
-		ret = read_from_bdev(zram, page, zram_get_handle(zram, index),
-				     parent);
+		ret = read_from_bdev(zram, page, blk_idx, parent);
 	}
 
 	/* Should NEVER happen. Return bio error if it does. */
-- 
2.52.0.rc1.455.g30608eb744-goog


