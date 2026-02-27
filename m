Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E81FAFD530F
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 08:21:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5CABF6B0093; Fri, 27 Feb 2026 03:21:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5412D6B0092; Fri, 27 Feb 2026 03:21:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 306746B0093; Fri, 27 Feb 2026 03:21:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0F0846B008C
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 03:21:55 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C5B39BA201
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 08:21:54 +0000 (UTC)
X-FDA: 84489543348.14.D91FF5E
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	by imf18.hostedemail.com (Postfix) with ESMTP id E3D8A1C000D
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 08:21:52 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=K1INUZXv;
	spf=pass (imf18.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.177 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772180513;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hu2NPW1VMt+KIrVk6gGv755cbgHa3Z7HVZzLA8AeCrE=;
	b=CuEF4vXSk78+zNKyVqjVG198t9cVl74x9MsDrucf2b/Dj//tXwIMU0KzCJ0/awLm7/8HjI
	cL1z7zeFs1/kPcY4AhCqIRKKF28ofP8B/VzmBdIs5NRfdW1z2ayNODKPOV/U04LFJtKKQC
	5MPr2/03UDh2rRzY7vDqHlgZACoYbO4=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=K1INUZXv;
	spf=pass (imf18.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.177 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772180513; a=rsa-sha256;
	cv=none;
	b=4yhGtRDs94c/Q78EO5jb+9q/pcBSdRaczw8F9zas0T4o+pFimGQQAMxJQK0VYEOm3AoQpg
	8OtzXrqweenNd00RpNas9WqM+TXGpe4bV6Ri3IzWGBYMlq1hTSxiwao9TiLGqRHSmEfSqu
	3Bcm/UWVcKnKVP/fpO2ZO3/IskntHbY=
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2adae92249eso19765475ad.0
        for <linux-mm@kvack.org>; Fri, 27 Feb 2026 00:21:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1772180512; x=1772785312; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hu2NPW1VMt+KIrVk6gGv755cbgHa3Z7HVZzLA8AeCrE=;
        b=K1INUZXvFJ/qhEdXN4BDwtqijhBWXl1FKSIx5YIeRXvJazeShT88Lc59Z11sbVheaS
         0o6nBQEnU4YKiK0N3PTOflggbZrwLW6hwoxWNtNRNHkSK2hYVvHA9cCelR4DDJmKDK/y
         maKR3rwgC9IGXd55ww5qRUePhH4Qc4NFFkx6M=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772180512; x=1772785312;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=hu2NPW1VMt+KIrVk6gGv755cbgHa3Z7HVZzLA8AeCrE=;
        b=A9DEzNpyENAGW7hnfY6YAetHriT0Gpeo2WXL5CNMXYxLXXDV2zZrv6tFezM5mhy4u8
         kCbkiu310I/dRKlwF7jQxl+iwzVeKoTyHu3yxvXLArpL+eAKERGyE83n1wBcI8XRSJAM
         kkpHASRN48uGkwKPzEAWEQb9l/IlBicXh9u3qJwJnQCaKGKRbJFIEUakir9Ddrw9fZnE
         B63PBfTv79hz7jfxGrhLX25vj/Ncs3mVyV/ajkq+b9JHX4zt2nSXaPO7NhdzWEJxVYXm
         1cz9XF5f8en/g/PpfS0ub8n+7GCEl6IMkuU1YF355X5JlipjEAOHgqgCDpDDkSto7NMI
         lI8Q==
X-Forwarded-Encrypted: i=1; AJvYcCWVe13eiDJwjyF+iEBYkrZ+gUAFfHpQeGwH077tyOeL6Ck++rvtrUxsWEVrUTymvN0yxhS3Etc5pw==@kvack.org
X-Gm-Message-State: AOJu0Yyj7H/V73ql9+15dWFnaKz1fll2V/+mSzhLyXaCTRwrFqmcHpj2
	f2NIDkT/QjoX1bwZhTzIntSIpf9TN45+81bO0BRgXzvHk4gjkyLE2E/d9TycHT1H0A==
X-Gm-Gg: ATEYQzyBk6srN/dylX0ETehtB8/rFNAFhmw8jxtADQ7UHy+ggYu4cO17x9NTvylC1xB
	yxCht8hqnfEStVIdPy3ayv4c+tsk5B7BEq1uG9P7VoryDOuaiyV1XQgGP8kOwHPDM66Ue7h2g/h
	9JHZfdoJt/NXX0pFqORzWDJJ8hiA3eT71hDfcCfThsAP89jmW26T6W7uW+g4TI7Ly0Jd/kYY0zy
	D51NdaeYpV9hPMhM1l8RFRdk+LJ4dGyrECnZKahNmk3FUYM9Y2G77SZMe+zTE8hKJ5zOJV8rSBn
	GH7D7hJrlYF54iAcnGiQ2G8BUQq4kz63COaHKmkxF/Cp24eeUca/Yc8wyDFj1Tsk8jwvX4N6svf
	lzFFv86RCjCPqBzAHhHWltb4xrURIZbyYpE6z4osBjOrPWgZEXP0rSggPk6aBbLK27jmptOTfKG
	rZcrUYo3k931yby8596wZytwHLU8tE22yotS+2G1jSnwBpQmmclmTBVNUCBbzOW8My3G5u5p/je
	41x5ghECPPwzQ==
X-Received: by 2002:a17:902:da8f:b0:2ad:a9a9:4bde with SMTP id d9443c01a7336-2ae2e4b55f6mr20599095ad.40.1772180511746;
        Fri, 27 Feb 2026 00:21:51 -0800 (PST)
Received: from tigerii.tok.corp.google.com ([2a00:79e0:2031:6:280f:e47e:6718:7698])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2adfb69fa4fsm48796025ad.45.2026.02.27.00.21.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Feb 2026 00:21:51 -0800 (PST)
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Minchan Kim <minchan@kernel.org>
Cc: linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-mm@kvack.org,
	Brian Geffon <bgeffon@google.com>,
	Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: [PATCH 4/5] zram: update recompression documentation
Date: Fri, 27 Feb 2026 17:21:10 +0900
Message-ID: <0d9bdbb19a4a1511e8c73d1e91227c47912a8009.1772180459.git.senozhatsky@chromium.org>
X-Mailer: git-send-email 2.53.0.473.g4a7958ca14-goog
In-Reply-To: <8a5d53d19a8dbd51d7d81d153676895163e0735e.1772180459.git.senozhatsky@chromium.org>
References: <8a5d53d19a8dbd51d7d81d153676895163e0735e.1772180459.git.senozhatsky@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ry7ds5pywt36urir1r9s7awn91twito6
X-Rspamd-Queue-Id: E3D8A1C000D
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-HE-Tag: 1772180512-202484
X-HE-Meta: U2FsdGVkX1+M1BvWPjqOgDU+MPIB0X/JoBmnbp8vdt2U7ZYqjapz59YMfBrkRgpeO6r9fpK+OMxkHcfSuha8Ru4oDkicE16+ddC8vFUP/9AFsp1gwTa21H6fiGhE66lKdbeeIB0OrGKDcQAQNG3UW2uLz0ON+UgPWNrZwygbe8/shw8ubABbwCtK135jRIwqa4GqlvFgFKkXe4eadE7Px3HBj89KIS/W0EO0hyLI5zAydR3J41kq+1oRG1NxrvcgCvWNAiwb4NMtzeQARuP5eI6JU6/7UbzaVAOXcNY9RZroEp4bP+tkrjlArco9bw2B/Ww+6d/NEPe57wAZTOJ1/8+5zznVR7i2NH1ca/yKZphVDailND+4Eh7syPW9rifdewbuOd/N1gxIawiBYHGMVty65+RrHnNKuOIq/Wk/mEbzuhUNCAVtsZqxRLkg0x+Zzh7e6Jw8TYpwtvo7J/5xboDCygXg4XrElgPhi4hyQ6HyNlxxq0byHBA3vbcBtyGcNiRkqqmxHrGxoqijFiy5gf0tLKx7yDVYJUSet2s5GIexRm5JJAESs1GJFTKvjz8AXDKJTqty3ipVb1dzHv/eBtmdoodO029N/vxu7zY+3f5Rv4H48rpIe9WGwKl0i8bcOOy9RGGTRFeQuWRUdwrMdifgQzCzjJZh6OTmbB9OSdlYS9lVTWkYPW0jh69zDbwArKY9cLnTM10K/qRnmeTnYYsBSISM9CnWC3k/7Dg923lzOHGXGfotiq2P8brZfqEQtik4PMP3NtiTGkl3JphjDozZefCVuzbVPGnj85qFdFfJGeg/nP/Xma/iTzBf+fGWwTa0686IqMWiVXuLN0XVZNTcPaYOqFLBWdhM3wHqOyzZzPBtTHkph04yL4A05gu4LbSJIYVe708pRmqM0J2+ABNektw3miLwV68oZ85dBgmVBf4+AJyl59D2vj+3fPtEn0APz8uGrI2TCFmrzgz
 +2bv8CjI
 pL5yPXiNXJcN+fMLw5qmhrLZlRxmTz4w9iA/oIphryzKzGIan2QHwYh7OTrgwRWhKipHbNYLX1iPlhKCdRaXHKBdlka90tgqVtQlvD1AzrdDKWYGLANv8q9N6Siv65aROcF8KlY+33O0bbX3ZWmEM/IKPkhQiws69+QS0O42LKuXanHLPbjvV9jaJaOzQbAt8Wu2mft3dK4K/cAB+UyDzANwq76FKt3DvykdaEIFaPGeFAKYyqH3aZagSEeArYjJZRQ1e8IG/f+ilB4YJuJQMj5kGhGdX+pGRdQHTB15v59RzK83zw+L3MfPTQQ==
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


