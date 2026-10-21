Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BA5E360A2627
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 02:42:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=chromium.org header.i=@chromium.org header.a=rsa-sha256 header.s=google header.b=k0KvZFyG
Received: by kanga.kvack.org (Postfix)
	id 960716B05C1; Tue, 20 Oct 2026 22:42:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 911296B05C2; Tue, 20 Oct 2026 22:42:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 828616B05C3; Tue, 20 Oct 2026 22:42:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 556026B05C1
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 22:42:56 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 510B41603B5
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 02:42:55 +0000 (UTC)
X-FDA: 85345085910.01.12967DB
Received: from mail-dy1-f182.google.com (mail-dy1-f182.google.com [74.125.82.182])
	by imf02.hostedemail.com (Postfix) with ESMTP id 7F76380002
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 02:42:53 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=k0KvZFyG;
	spf=pass (imf02.hostedemail.com: domain of senozhatsky@chromium.org designates 74.125.82.182 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792550573;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YqvLnWab+0OyPrxtGw/AiXaMLQ8o5EGXMAvfXVZT4qc=;
	b=tHUqrl3xY4FiIlgHtCSlkwSKZ/oV920OOv14lprBYzYzNG2HPzfuhUFmx1ut5hwXHSHIg7
	7z+arR0ev7hRmAFhbzK/qXufGc+H06dKFUnnHeBlJDBTKZuoDWssO1H0TDTSP+ZMIkxcZp
	X7W/xwOYNhuXG91HTyJaelTCoGX3r5s=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=k0KvZFyG;
	spf=pass (imf02.hostedemail.com: domain of senozhatsky@chromium.org designates 74.125.82.182 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792550573;
	b=Otng+kXgj9lRTnu5tnHv4gjA5+/te6cZkK8U27AOIPetK/mNZjDFBNqi8umxRxpngTP/ad
	1EIlg3ksL3kkcGBlkd1Nso6rV3JtbXqVajWZIM68P8mcG27oOjslqVXc4Zk8ACNuB2GbLI
	jSmFuSSImoH/cyd3KIzZKzhgnQu4NfE=
Received: by mail-dy1-f182.google.com with SMTP id 5a478bee46e88-35cd4e8bdbdso447549eec.1
        for <linux-mm@kvack.org>; Tue, 20 Oct 2026 19:42:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1792550572; x=1793155372; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=YqvLnWab+0OyPrxtGw/AiXaMLQ8o5EGXMAvfXVZT4qc=;
        b=k0KvZFyGPlzTzxQPFV5LW3/JEHCHcehdLRRUZixaESuTEPS4iun6gMd7uWElpUF5AI
         u49MxQpC246+4ebb9dq6FwXL1GkfTbCQoNHB/MXDBuOsbvmkV8W9rNaChFkK2cFsKnYK
         Cd+Ndny6D7b/DOfdvAiuDelb1nGUtGrvAdddM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792550572; x=1793155372;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=YqvLnWab+0OyPrxtGw/AiXaMLQ8o5EGXMAvfXVZT4qc=;
        b=xovbb7nbABhuvSqQrQfChE4PR8vY3c4PFM/PB1QEbtx9DbUMecRd1GoO9OLRpb5xs5
         z8GDkChdZtMA0LKEuWzQhU+OSCr2pk1uwpwNs4dVhZ1CmUwQOU3Z2zDrXKfoO+fScTCS
         mnaMlhcrHeBbdS2nGVkvCreAkghYV/WButmxzK/U50OKJzI/fzdb2GzTD93053RaY91R
         mD4Ln4QzlV651/C13rVhNcuWulEQJc9fp7BKuGRqCi6W+kuLH3E52EFikzp4V4YVO9e+
         7LjFJV6OQjJxzrouvISHxeZZQFiHX9oq333rjJe71LDVB42SVx3uGIWUuChwrs2Gi3c1
         V4sw==
X-Forwarded-Encrypted: i=1; AKwUvBxbFXvD02xSNzd+XeBltGBicAiAleSfagmzsVh/U6XK2hCohBELp5gNgG+TZ703zssKlrtC48nMDA==@kvack.org
X-Gm-Message-State: AFq9FYL14/SIXbj+FoTehCVHNQ+0M+p6oWM/c5SdV1UdLj9+g4naNfcB
	+Fh24MuFcFZPhyZzADqy4B/wr3GqNtBwQRH1JZtW1B/xry4Y0Cj/95nJFg8nXQeuEQ==
X-Gm-Gg: AYBFou3evOsueSbGrwiNQiAeCaGCJzLkmgm7alwBT1XeLasEZdlNfTMKCJe2nwAFMI9
	oqcXI/cj3G224KeVa4jGHjgmXpELPvPL+KMWKgOiL/q4V09AyFV2ZFGO1Atk2Rf1y99fmvYC2mF
	NIJyo0M4eLfdThtVz9vfu+efpX4RpcK8R3VXz3JK2Zb4IX4vjKWQb0CgBcPtRSr72C85rSpl3Ye
	Eoc0b6t/MFTAgIWohql67oWjNa7IzOPYGatVSKn/++J+djpWZ6VhduWQe178cxSkmqMjWRbpAQO
	rk8xHWRcrX5N6VzOvvncxkaJ/YCwlhUg7WCDXQqfAvbf2MwGeWZl2cpnBuULJwtDOB2r2Lf9W3w
	DirAcSPkkxbcuhQFsU08Fiezdphx1+88SY/79Vx+rpBvuriBzlQNeOnOClQveJqqqTqwciDh1Qa
	OUb9tTPycvXFT+ReY/68ORpr8ZV7BWC+oJ6b71Ap9mkvcTnzimvVwVk+YZ1r3KXm8NA7eulFWtJ
	7sK4axsjnbR+F5/GME13w+qAFX+eGs9O6uA+GhsMC2HoFSf3xDJhwoZcbj551PreLUr3l3klW6q
	s4Bne/1RlSB4MgJMPHFf1kK8ymmY03dj+ugYH+hHZ3GB
X-Received: by 2002:a05:7022:f515:b0:155:7721:3a4c with SMTP id a92af1059eb24-190a660fd4fmr846137c88.35.1792550572267;
        Tue, 20 Oct 2026 19:42:52 -0700 (PDT)
Received: from tigeriii.tok.corp.google.com ([2a00:79e0:2031:6:97d1:a8be:236d:bf79])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-19035c0c9a6sm2392047c88.3.2026.10.20.19.42.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Oct 2026 19:42:51 -0700 (PDT)
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Brian Geffon <bgeffon@google.com>,
	Barry Song <baohua@kernel.org>,
	Bo Zhang <zhangbo0325@gmail.com>,
	Minchan Kim <minchan@kernel.org>,
	Richard Chang <richardycc@google.com>,
	linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-mm@kvack.org,
	Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: [PATCH v6 03/13] zram: reset writeback state in zram_reset_device()
Date: Wed, 21 Oct 2026 11:42:13 +0900
Message-ID: <20261021024236.1787884-4-senozhatsky@chromium.org>
X-Mailer: git-send-email 2.56.0.212.g129ede20d9-goog
In-Reply-To: <20261021024236.1787884-1-senozhatsky@chromium.org>
References: <20261021024236.1787884-1-senozhatsky@chromium.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 7F76380002
X-Stat-Signature: hened3h9dtoi5mdioiygddmzih1tg38y
X-Rspam-User: 
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1792550573-635553
X-HE-Meta: U2FsdGVkX1+UduvLRgWWCUIv+bjNPuFv1MsaD4IBqrRPla4cngfAzKI+F1PX16h3QEOxZH59uMHiayXdAPmVUUuSm3+ydh1FOtw+tWIQ3dL5MHgYNoJo8OJZDXP9HT31Ho8KzFjc/aFs1ckIpv1XDk/hOifjL+eVrfiSsZ84tCcRPFdLRR/0fC0yNahsGaRORTOozBE38xfqD3mIBEs9bRqLDfo06keYJ12Hvl7PILOtcpx0gVnqdIE1S/A6DEzuoKedjtzMc6ZMvQbYEzzydXmXphacLgr0ZHodq38jbFVSDaWqALMUCaOgXZl9EdEcCH2Wo4zSNwEH6Y9xTXLNQVBtsnC34XYovNczZHR0DRTl6Vhz28TcWgaJ1IZtdW2RFYjLO4YuDzmIkM2glf5PJaQww0lyYCJRDgB8VOyRYvAVSMZcEbKEePbn7m7OTtkbyagYHy8u1Ej2Ctfh++8gtebjcS4JS5+nelLJDQh8p+Q3RcNF5fftY8kWLZn57lS7jiUQQLoi/WhRt3Bgh+QWC9U8dlMiFgpY7tJq5mD03RUzA0cnojBlPnd9VccQC5FsRXRqmbu4MpKR22/kt8NPugsgTaED9VU9m9roEG5FVGKz6wqaOK2+xbnjSvMSDFbhK4NyePJx4AnrAC1prEohxHJHJhCLxxEQ79TciKTGntBM7WJb3RZ/plzUBJG7p6+yP2leNRW6ioO8AteGVBy9CyOl+IRqJ+qv13DKTeS7N9K+6qvoXAGcvuszhM3P15q/OaN1EUKWynJB8ONnTjShrz6JE1GAf7TRuw2Wv7JGaNs115iYjrDq+34/rXG0Gs4NboYvEnJXLvHfdUu4lPQ5pDOAvwKHtM6SPzAesL8JIZ7BX9ETLGi7nPXo4oMq/G4bjb9jNagPT2wRfsYf/5z+WK6utagLgqZZLx9xioqMZN03Q4RUzyoSUj9/a1AqSOaJFEKBwrrMlMaDKQvJ2iy
 vNN86czJ
 pbXVT7HzB2hR0G/hvg2ngsrglefN/rer2Vl4wQRijoql4MjFmsuqIuWIejjBYvwMQzcdNRZgdPwp7PVdwg/hEjasZ1t0c3wp3GE0Zh9YzsbByeUGiLSUteYGW/qd+ZNUslJPZ+Ors+eLt5gxF6xYqky8f5b+hqSm2CCWLUuIAA8hgqqd72zVSAwD4Ya0jLtjPkNS6w0wlORCmnZUc9EyvylMfIk+kz6GPViYruWijFxmenmHm7beT4b7cL3F9hP3yUywcZShVFtLrHGqI2RDlznf1QQPIToo+YK+I1RpU+UyFtkhXMcRhPOfWn5TF5XHf+0lYFiKiWXM+LzLgAaoaahamIlEzTLPb+Hz2mc5e9FZA7mgk3JbpbgJlpQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Reset all writeback state to its initial defaults on device reset.
We used to keep writeback related data in zram->stats, which
zram_reset_device() clears, but commit 1d69a3f8ae77 ("zram: idle
writeback fixes and cleanup") moved it (along with the newly added
wb_limit_enable) to struct zram, after which neither of them was
reset anymore.  wb_batch_size and compressed_wb, which were added
later, are not reset either.

The patch is more about just being pedantic.

Acked-by: Brian Geffon <bgeffon@google.com>
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
---
 drivers/block/zram/zram_drv.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index 593fa4ae47c4..0e1aa0da11aa 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -694,6 +694,7 @@ static void reset_bdev(struct zram *zram)
 	zram->disk->fops = &zram_devops;
 	kvfree(zram->bitmap);
 	zram->bitmap = NULL;
+	zram->nr_pages = 0;
 }
 
 static ssize_t backing_dev_show(struct device *dev,
@@ -2881,6 +2882,12 @@ static void zram_reset_device(struct zram *zram)
 	zram_destroy_comps(zram);
 	memset(&zram->stats, 0, sizeof(zram->stats));
 	reset_bdev(zram);
+#ifdef CONFIG_ZRAM_WRITEBACK
+	zram->wb_limit_enable = false;
+	zram->bd_wb_limit = 0;
+	zram->wb_batch_size = 32;
+	zram->compressed_wb = false;
+#endif
 }
 
 static ssize_t disksize_store(struct device *dev, struct device_attribute *attr,
-- 
2.56.0.212.g129ede20d9-goog


