Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 99404FD065A
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 08:43:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 70EE36B0092; Wed, 11 Mar 2026 04:43:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 63D9A6B0093; Wed, 11 Mar 2026 04:43:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 50DAF6B0095; Wed, 11 Mar 2026 04:43:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2FFD66B0092
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 04:43:40 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D096C8C261
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 08:43:39 +0000 (UTC)
X-FDA: 84533143758.29.A6BBAB7
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	by imf29.hostedemail.com (Postfix) with ESMTP id 01483120003
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 08:43:37 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=lPdzoxWp;
	spf=pass (imf29.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.179 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773218618;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hu2NPW1VMt+KIrVk6gGv755cbgHa3Z7HVZzLA8AeCrE=;
	b=BxroM6A8FG+hvLMwBmnnZNXxukTyC0nojnf/g3/49u1Z1SACzEWhUmrvEgeoJvBpAH9sKq
	209wpUT9I4tx0njTbZS4R+fwk3KuHaQ1UFEfetR3IWNNHcZ5NGypcBozU18hZPXydeGOb+
	8mfqcdF1TVmsGUrv1y1AxYsxAycN6CI=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=lPdzoxWp;
	spf=pass (imf29.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.179 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773218618; a=rsa-sha256;
	cv=none;
	b=HuZlzcGVwioBZ7G1VedOk8f5pPf/SUgPwE98MlK40B6KQk3JiC11LkE93fYZUqQyid/OI1
	hsCr1vHzy5HK1AdiuuGc33C9dLJJaFFkPqq6cc245dvqyBeRAVNPFrkhmJDh7k84FST5x2
	m82SzQ36UvjJm6H4aKt/XahH6kNySb0=
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2adbfab4501so62426485ad.2
        for <linux-mm@kvack.org>; Wed, 11 Mar 2026 01:43:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1773218617; x=1773823417; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hu2NPW1VMt+KIrVk6gGv755cbgHa3Z7HVZzLA8AeCrE=;
        b=lPdzoxWpQlbCMEwlhh+azc+Ukakptd7yl/6CM8+faIXFSKR9LP0bh0eDfAkvqKWjda
         Pyi61UqW/yzudfuXI6drz7Wqg1RR3Quibh8hiH789LwhTSBn0iEVAQ2IgALqEgiV4o2n
         I2zGq5NJLnAp8E7+u5UwQyOiLHhrWBPp92zgU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773218617; x=1773823417;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=hu2NPW1VMt+KIrVk6gGv755cbgHa3Z7HVZzLA8AeCrE=;
        b=BUv38MtdlswazMBDP8lJ/ucEQlZmJSu6eBipRrL6hmbYuZONZZZdQ42Apyj67E2y2f
         fRIDiAL8GH+6QQiGCxwJstox7KG2eQuaeKqky/JhO742vwNCuFnspApQclR4BqJDdZcT
         etT0G/XR7GTkQT3L++2d0hxokkpyz29Yta2tZ/pen8vIOz217nOYQg6Rb2dhzXi1GHqj
         7W4DjRYhpJt1zXd8v+ZsI/6mdYryroOZjyy1vjvZihk3E99cMJkTtEIC5TZyZVSgLkLg
         1MuJobqy9OKo6vJ48GBJ45SfwYoYbYojtbAbLp9D9rVI+AnHs5LfqrNhN/fO/U9flipz
         e/6A==
X-Forwarded-Encrypted: i=1; AJvYcCV+hd7hGtuAJprK4v4qPBgTuHJ8ZJ30q+pa1IDVl2FKuNPZ6n30niDrpb36gbaMYfTHaBckWcz4AA==@kvack.org
X-Gm-Message-State: AOJu0Yz8A/DiJGT468hv8L9mjOM0capJaH5LQeqbjADIOVlt4Tj8RYQE
	rEmX4oTxDShYaOBxGt6kL2uGJDC/R9ZW1M388pCMqcdSQeCGH7M9TThtI+/bjBXgAw==
X-Gm-Gg: ATEYQzzEu2EYjtJ8Q7RGxTXQE3F6wFLZATIz8pIzFyvYmYzbzYHhJ5x3RG7OrpiQSmz
	bkFiQVW+cZIw4Z3CVxUNT+3U5FW7X+3VClO/kwakPMtjhUhBhE3HLZG2I8b1slUpdOZJAuwrwTM
	4T6SBBqExJJ93TsZQl4EdeCGGakxrpQ0UWt9A6ls3TfyuMUuJqUAujou4ovkU1WffqX8HegmnqF
	xDPeTr/mVW5SE92SW9vHqlKAQMKtirwFUd9maUxBdsLT2Y270uhHg8tCXiiQzSN55ltSn+G54Rb
	kcQVx9/ivayosq/oRY8G0p+dWVWQ3m+XLyv0XZ4O53ciz7orqNTTXLG4CuvztspRkV6ClsNqETX
	DPb9jY5Hn/36tkf+Wgwb/EQ0nOpessjcU1pilEIoy0Y5awlrjED6uWinfiqNMIQnQL8CTr+lVG5
	uOTHkCtDM7t4WSQnUIs2YKPvinaDHWcUULjeO9DqpDqBOskilt+cZeO/OCTCSXV2GrVhCSFGXTG
	qNmgwo0LmhRLw==
X-Received: by 2002:a17:902:e74f:b0:2ad:ab2c:d258 with SMTP id d9443c01a7336-2aeae7c8c56mr19757175ad.14.1773218616859;
        Wed, 11 Mar 2026 01:43:36 -0700 (PDT)
Received: from tigerii.tok.corp.google.com ([2a00:79e0:2031:6:93a4:8281:fe98:426a])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2aeae261077sm16062035ad.40.2026.03.11.01.43.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Mar 2026 01:43:36 -0700 (PDT)
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Minchan Kim <minchan@kernel.org>,
	Brian Geffon <bgeffon@google.com>,
	linux-block@vger.kernel.org,
	linux-mm@kvack.org,
	Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: [PATCH v2 4/6] zram: update recompression documentation
Date: Wed, 11 Mar 2026 17:42:47 +0900
Message-ID: <20260311084312.1766036-5-senozhatsky@chromium.org>
X-Mailer: git-send-email 2.53.0.473.g4a7958ca14-goog
In-Reply-To: <20260311084312.1766036-1-senozhatsky@chromium.org>
References: <20260311084312.1766036-1-senozhatsky@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 01483120003
X-Stat-Signature: m7er39hu6aou4byz8mbfnfotrxaknprx
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1773218617-393881
X-HE-Meta: U2FsdGVkX19/5RIicEXYGIAzaZKZ+uG/oDnIJrPTWef9oPjFH0i/fkWiX6msiJcFSUhqFiNfrvVhCWaBiUVucLF8DA0KuOArUinNIc6R1qiyjTSEdjhu2veeAglY+TAI78JS/TO07DzmDKhppEbdX9mepa5ARCLopLOEC2c07hjzL56i7Iptfq05Fv34KXfq5rgrvKvytn4QkxnlQ7+MpgP5uP4i9NnHk5K+qhZMPsvkn+lqN1OYu4y/OiLG07t4jSZjq7o5DXGBU/Wytop1fjr49HThcrrn66BCyZQeTh0e0IkIcBW1k2zHVZxAdxEGYw60hJE3akTL2ofsbpdy0q71ujEJg0x8bFBTaYwY4L0TtcrRSC5LhIR23YqEerHEIPQuGq01dOLR5vwbI+svtqNyaNTfEKqcSuQ/xCGDSWcWMsX2EqqQkYYJ2yNKhiaGBGS3d/ZQDL6IVZr4HI0DkpTUVZEVhdXitqA5GdTyeHHOqX9IKVvr1MYjzvH+F7G9y5zmdWqrd7S50R52KFgZMysCOJqhUG1MT6ZuycpLUKhMPvz3AgeyJBLy31mErTJWko6PVQOYq6cKoocjl5kHkpEXh7hDNlxsPsKHdyoLyjgXaYUznJaxft7dv+j5a1/30n9CjQ60az3oR7sT2QuHRBzMz7n7xi+zAYqjBu5PuMJa/eRDbE4RzqcIDolQlooPrxxfyp22YiYxjOLANgbWNqHGeLzNslFRgjPnrEA+ZPuylkiUY3D2tP/xUaHnlrSM1A33feAgZGyRNBk4dDvAdz6k/8LN4PTXUM8kYjhd2adHUCFp9KYNOi1Qo09yRzeeIRxDlI0+oIl5R0xTnsIJp8STXBrC7znRnEKB3bGfqjnZ1EafWq6sVFJXRi9z/Yf9AejxrGA/WT+Xwl+f9efcXkTifkA/hk94EO0QiUsB4WD74QFxflIKW1szet7r8uqK67KcdTcBExr70C/JA8r
 V3p02NCL
 R8M5AzE4aXTJslB/BU/LeCIn/caAJIqkGn2zFYuiUi6W8KC/NMOWQ4a0T/9Xv5SOEHxn9/q2448eqdoWMUwcRxu1+OHHxSGZecEGskaOSwme1PzPwrH91xu6Z5fTpS1z0ADe1VeEQISNxJEIm2WOvq5NQM/fTy0vLMvAR53JWLIjcORn5jqHh2HZMiP0FN5crx17nJW61ccfItXTmO4dsoekoeHkhkmTSTd/pfZoVKbK179jb1NAgGA/3PS5A26un2SzJ2audRvoXnkUCfKK7/LXZcbmXybrqtrXahzGex2/818k=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Emphasize usage of the `priority` parameter for recompression
and explain why `algo` parameter can lead to unexpected behavior
and thus is not recommended.

Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
---
 Documentation/admin-guide/blockdev/zram.rst | 40 ++++++++++-----------
 1 file changed, 18 insertions(+), 22 deletions(-)

diff --git a/Documentation/admin-guide/blockdev/zram.rst b/Documentation/admin-guide/blockdev/zram.rst
index 451fa00d3004..967b58c3aad2 100644
--- a/Documentation/admin-guide/blockdev/zram.rst
+++ b/Documentation/admin-guide/blockdev/zram.rst
@@ -462,7 +462,7 @@ know it via /sys/block/zram0/bd_stat's 3rd column.
 recompression
 -------------
 
-With CONFIG_ZRAM_MULTI_COMP, zram can recompress pages using alternative
+With `CONFIG_ZRAM_MULTI_COMP`, zram can recompress pages using alternative
 (secondary) compression algorithms. The basic idea is that alternative
 compression algorithm can provide better compression ratio at a price of
 (potentially) slower compression/decompression speeds. Alternative compression
@@ -471,7 +471,7 @@ that default algorithm failed to compress). Another application is idle pages
 recompression - pages that are cold and sit in the memory can be recompressed
 using more effective algorithm and, hence, reduce zsmalloc memory usage.
 
-With CONFIG_ZRAM_MULTI_COMP, zram supports up to 4 compression algorithms:
+With `CONFIG_ZRAM_MULTI_COMP`, zram supports up to 4 compression algorithms:
 one primary and up to 3 secondary ones. Primary zram compressor is explained
 in "3) Select compression algorithm", secondary algorithms are configured
 using recomp_algorithm device attribute.
@@ -495,34 +495,43 @@ configuration:::
 	#select deflate recompression algorithm, priority 2
 	echo "algo=deflate priority=2" > /sys/block/zramX/recomp_algorithm
 
-Another device attribute that CONFIG_ZRAM_MULTI_COMP enables is recompress,
+Another device attribute that `CONFIG_ZRAM_MULTI_COMP` enables is `recompress`,
 which controls recompression.
 
 Examples:::
 
 	#IDLE pages recompression is activated by `idle` mode
-	echo "type=idle" > /sys/block/zramX/recompress
+	echo "type=idle priority=1" > /sys/block/zramX/recompress
 
 	#HUGE pages recompression is activated by `huge` mode
-	echo "type=huge" > /sys/block/zram0/recompress
+	echo "type=huge priority=2" > /sys/block/zram0/recompress
 
 	#HUGE_IDLE pages recompression is activated by `huge_idle` mode
-	echo "type=huge_idle" > /sys/block/zramX/recompress
+	echo "type=huge_idle priority=1" > /sys/block/zramX/recompress
 
 The number of idle pages can be significant, so user-space can pass a size
 threshold (in bytes) to the recompress knob: zram will recompress only pages
 of equal or greater size:::
 
 	#recompress all pages larger than 3000 bytes
-	echo "threshold=3000" > /sys/block/zramX/recompress
+	echo "threshold=3000 priority=1" > /sys/block/zramX/recompress
 
 	#recompress idle pages larger than 2000 bytes
-	echo "type=idle threshold=2000" > /sys/block/zramX/recompress
+	echo "type=idle threshold=2000 priority=1" > \
+		/sys/block/zramX/recompress
 
 It is also possible to limit the number of pages zram re-compression will
 attempt to recompress:::
 
-	echo "type=huge_idle max_pages=42" > /sys/block/zramX/recompress
+	echo "type=huge_idle priority=1 max_pages=42" > \
+		/sys/block/zramX/recompress
+
+It is advised to always specify `priority` parameter.  While it is also
+possible to specify `algo` parameter, so that `zram` will use algorithm's
+name to determine the priority, it is not recommended, since it can lead to
+unexpected results when the same algorithm is configured with different
+priorities (e.g. different parameters).  `priority` is the only way to
+guarantee that the expected algorithm will be used.
 
 During re-compression for every page, that matches re-compression criteria,
 ZRAM iterates the list of registered alternative compression algorithms in
@@ -533,19 +542,6 @@ no secondary algorithms left to try. If none of the secondary algorithms can
 successfully re-compressed the page such a page is marked as incompressible,
 so ZRAM will not attempt to re-compress it in the future.
 
-This re-compression behaviour, when it iterates through the list of
-registered compression algorithms, increases our chances of finding the
-algorithm that successfully compresses a particular page. Sometimes, however,
-it is convenient (and sometimes even necessary) to limit recompression to
-only one particular algorithm so that it will not try any other algorithms.
-This can be achieved by providing a `algo` or `priority` parameter:::
-
-	#use zstd algorithm only (if registered)
-	echo "type=huge algo=zstd" > /sys/block/zramX/recompress
-
-	#use zstd algorithm only (if zstd was registered under priority 1)
-	echo "type=huge priority=1" > /sys/block/zramX/recompress
-
 memory tracking
 ===============
 
-- 
2.53.0.473.g4a7958ca14-goog


