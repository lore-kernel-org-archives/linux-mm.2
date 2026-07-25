Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C325BC531C9
	for <linux-mm@archiver.kernel.org>; Sat, 25 Jul 2026 18:26:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8C9BE6B00A6; Sat, 25 Jul 2026 14:26:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 853786B00A9; Sat, 25 Jul 2026 14:26:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 71B7D6B00AA; Sat, 25 Jul 2026 14:26:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3A6126B00A6
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 14:26:41 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A978AA13A6
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 18:26:40 +0000 (UTC)
X-FDA: 85028129760.17.18BC000
Received: from mail-wr2-f1.google.com (mail-wr2-f1.google.com [74.125.225.65])
	by imf29.hostedemail.com (Postfix) with ESMTP id DF37C120005
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 18:26:38 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=HJiW3awH;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of nsd.project.dev@gmail.com designates 74.125.225.65 as permitted sender) smtp.mailfrom=nsd.project.dev@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785003998;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=K0+z0feMX7JoKO2phMVBw4gbQDIWDzSyQ5EIA1ldW5E=;
	b=0gz2ffF7j6VXnEvQFWF2E94rf22X1QHXAaWh2ZNVhgdcRcPJeNHmnv28NKGhGZZGqxiOCu
	ItXlYCWIPmiH0zAYFIL7kNCcbhdrJ+ZFcxYCRVTSKrpCWrrpSTvNZqDCa1tl4EVv7cpO08
	THUI19ZzDM4TrnPBim0I7pYzOSRerUc=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=HJiW3awH;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of nsd.project.dev@gmail.com designates 74.125.225.65 as permitted sender) smtp.mailfrom=nsd.project.dev@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785003998;
	b=RjghyZ+JeoeL2zAK7nAwb9cUyC4hh+z2+Z7FGTv8X5RG2fRF3WsvwagjUlF26i+Hbu5uI9
	7fGVAjfqFClooLd809ZofKcc3nNJnN3rvUMn1XtUGzHgutWbGkS8IQWgoPyq5FL8uDVlrL
	4cwQsDscCDyHupoRAT8Cd4G5uRs4R2s=
Received: by mail-wr2-f1.google.com with SMTP id ffacd0b85a97d-473913157edso630280f8f.1
        for <linux-mm@kvack.org>; Sat, 25 Jul 2026 11:26:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785003997; x=1785608797; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=K0+z0feMX7JoKO2phMVBw4gbQDIWDzSyQ5EIA1ldW5E=;
        b=HJiW3awH6cjwJ2ptQQoTxuSSOCGpP9+Gexc0ZqAesEdtzMB//o0fJpdWICTWwJjAoa
         ZuEkia/PWn2jXpXr+8Abkb4FYWuwa9tO9g2DyF/rlvlEc0CwoymijwBokahgVgIYS3pl
         AzSh9ze7u5ddtXsWJy6P6OqdB53ebZoPCqlaPehW0ncFDS7X1aF3gXI0VzOIOoQVtNY2
         OJEnMAe/bHdxBSoIJwoZWdzb7meUReENziodrBMeyAeI5ExatFyeL5K/bxye+KnGvm34
         jY+6L87ldSZNTC+MK8l65WuExwXkj3eP0If/Nf1jdcyJqFDHP953XjjMK8xLXbNpLNVA
         yO4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785003997; x=1785608797;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=K0+z0feMX7JoKO2phMVBw4gbQDIWDzSyQ5EIA1ldW5E=;
        b=UO3uL/XKoRSEfqdjV1uwzd3Ls/RR2W9aFpubJXbOy3kBfB1hiwH91DXTiApUBEXlpO
         4+lxy8qeLTcCjjtdvCKQbt3PL7R00aMBsXzofnGg+wpn2b6nwdjW1A85ekqiFUGuA4cD
         Q4lN3MtXoof2BLcDgF+WNXp9nwFFUUchSXWkifObGYMY0Ka4uNxlc7t7oWh8ckRwSLpk
         Ou2WmGh93Qxrq/IwD4E/n1BzMlWjh/IgAaIkQXrLJBp1ldLgw1ieoNpgF4Dsd69y4wQd
         PKJfScqdNJChk1VI9nLz27sdxatDJ8dOBVf1zeHmlEHadBx3PlrZrDoh7GJrWS4wr8+D
         DHCA==
X-Forwarded-Encrypted: i=1; AHgh+Rq9Kj6RMBQAF+9zhkw9kSaVXq3RIk+NcofjHWdV5JAPvB5wTcE5qmaK/czdadap/Q4r0khqq7Fj5A==@kvack.org
X-Gm-Message-State: AOJu0YxO0oQ4vAqzsa//faxexEuMYSqTmX78vAmu+3pY742Mt+u7XJgJ
	aWCUTQ1X67sqETUIWEOaKSWL5wB3rg5frwt3d+hSYIa1BwfFs59WtsDq
X-Gm-Gg: AR+sD117fs0arRBgYdqySL9Gm4AfRy6e3fHfkcC/OJo4VEKk3f5FCVN3d2bzrJLn6OZ
	aUT5XILo7rwObw15agfST2xDqoB3tR9nt5LubAjtogmVY7SnA96LPjY7e4R/Gnw4Kth65PpRrbe
	gB9XXlGQr5rYKT/r172f6p3h9broJQ0gYhu9l73nDuRJUHesYYFOWjNSahymkD0v9UyENP113PH
	OWP1nvd9gbI/lrmgUkgDWjncldeorl7xCMgvsqKkR0lpqXzhnuUAV8Nm2JzER3aUx4Z79XyEYoQ
	thgkL8q1HZnAWaMkZebz//fwvNL0Lv5QYYtgT04nuMeIQzagTlQ0XftUlAUtL/vSS/VBPXEWh9J
	bWfx60zV9+CRaZfrO8QC6tPkSGpTXQjJwFlrXK71NBq5Kapemn6WtIeW21W/WPbnBT4cNYNxb6R
	alxmHDYwY=
X-Received: by 2002:a05:600c:35d5:b0:490:e5c1:b8bf with SMTP id 5b1f17b1804b1-496b56f385dmr37477295e9.13.1785003997454;
        Sat, 25 Jul 2026 11:26:37 -0700 (PDT)
Received: from localhost ([178.241.98.184])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-496b499c473sm84741065e9.11.2026.07.25.11.26.36
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 25 Jul 2026 11:26:37 -0700 (PDT)
From: Ayhan Aydin <nsd.project.dev@gmail.com>
To: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Cc: nsd.project.dev@gmail.com
Subject: [RFC PATCH 3/3] Documentation: Add NSD filesystem documentation
Date: Sat, 25 Jul 2026 21:26:28 +0300
Message-ID: <20260725182628.221603-4-nsd.project.dev@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260725182628.221603-1-nsd.project.dev@gmail.com>
References: <20260725182628.221603-1-nsd.project.dev@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: DF37C120005
X-Rspam-User: 
X-Stat-Signature: zncxhs8he83ztocw5sbcpjkbn87dwgq7
X-HE-Tag: 1785003998-166838
X-HE-Meta: U2FsdGVkX197Wkxx74A5J8MnciA6bxIW1wq1Dc4sKD1Blvhy5f2pbPjxmzvTXjX7WA4jK2UTelM2/dajkwpjCRhcE4v4a0iloJET3Jr3VE4IHvmjwnBFQ5LoGU5f9GgmDcnK8ZY7B9EswJiAyfyQIthdFpYK9UGEdEi1TOXg93UWNWhkzDaQ/cAn4HAwkjQAIKRnVtVOV58QSw9rgaJ6CzlihUrAs7Nq21/0PFcVSCyfJt3xXfGt4/9PUF6N/1IRX90P09tA+RhUvo2L29BKjDVxPLhRA1AzLBe6ZnFz5g0A8TCCSlYfsrhuEnVWxP+nAK3QYMUjyAicM2gqVCToH2BnDQtctxLbdGw7MdfR3MUJiNoqTgea8OoQrCFsYN4ZxSzedKKTzaYsifjPIKM698cXvsiaOxCVyKiQTCrP37XaY9uCOX9e4We6EL0jRu4A8HjmXT0JfgA//iuJ1KxMoVQllxxPUjP+jf2WMMjueeCKd+Nmi0O19AIiZ58SxA+CWvl6Bb27Q3vKhLSqQrJXxHN+DN19UeE6gHNLjkp9e+WFD2FlIQnXgtmfKUCCSjntVpJkQcVzmC/MqkgJS2k7b4Izoz2UzRLekYau2/vAqD5d0rfEe5Yq3TkjuokICZw0W2qQega781BIzTW7yUrhU+qHpYDRuuxLiuJsrebRxWNi6u9Cgekk5cKOSF+c/4VfZPoksNhw64GZkqgIB19BEpdlHfVWTxrF8WP8XC45hpXJbXZ0XbIZG3vItIp/XT03d6kLWHqyXnmVEvMVc/SCb1viMa8CHyLKRAqzV8+Co8YgNC/FAzKBKoHudQjLR7+QvJ6IxyClSoAzm0ILn0JF0Cs2gkfQ2HrBT+KTxE44zIInDAgO7UJtc4Pk8IToYjiuKwWFjznNPaS6doN3ZO6xZBO4QGXithZ3ZwXaGyTDbWGP/OKfZfc+pCeNMQJzts6hS1wK8mK2NiqMUy4DZQB
 tarEqA9R
 xzXTON7fiYmgIMCb5rBIz4qjuQ+1DFDq4sEFrN40IHasb6mJat3XnXDg8Jy39c1T8ggbr5+KWZr5E6lwVLr/YFO0Z8oLJT9ZRZkoxM4hNXCG3+HpdcK0bSDOc25lTveFj1g6O1PmrwlMFJanj26nfjqA5NkuYDoNymxr0V+oLIL161TKv3qaNcScNrXtKjIPrn+QWU7eBiN6rqWKkqtDT3DyaX+LbDafeR9nbyBabDiaGJtWHt6KQxnHCWXAtOQsBJBXWOSKAvEFB1g+wHx/oU+2JqOXVhDFSXtTDBcC7j6tKOwz9H5cUNhl+lmYNKtpzna10b6mkFMp//iOFX5P1i0larYljv7m1XW7fYLPcwcDLNG4JAZTOaBHHtOnaKnY+UQNz+uWVLTkelRe8ohj5ns9gApEkpg7cIAn/9VyNyMBA9ZKiANNjxG7vTC8xn5EPgHWKf36u9mh3NIs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add initial documentation for the Neural Storage Driver
covering architecture, sysfs interface, and performance.

Signed-off-by: Ayhan Aydin <nsd.project.dev@gmail.com>
---
 Documentation/filesystems/nsd.rst | 77 +++++++++++++++++++++++++++++++
 1 file changed, 77 insertions(+)
 create mode 100644 Documentation/filesystems/nsd.rst

diff --git a/Documentation/filesystems/nsd.rst b/Documentation/filesystems/nsd.rst
new file mode 100644
index 0000000..a78018a
--- /dev/null
+++ b/Documentation/filesystems/nsd.rst
@@ -0,0 +1,77 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+========================================
+Neural Storage Driver (NSD) - v1.0.0
+========================================
+
+Overview
+========
+NSD is a learning prefetcher for the Linux kernel page cache. It monitors
+I/O patterns via a hook in :c:func:`filemap_read` and prefetches pages
+ahead of the application using :c:func:`page_cache_sync_readahead`.
+
+Unlike the kernel existing readahead (fixed window), NSD builds
+a synaptic Markov chain model of access patterns at 4 KB region
+granularity. It detects sequential strides, repeating patterns, and
+learned transitions.
+
+Architecture
+============::
+
+    Application
+         |
+         v
+    filemap_read()  <-- NSD hook
+         |
+         +---> nsd_notify_read()
+                   |
+                   +---> Synaptic Table (Markov chain)
+                   |        |
+                   |        +---> Region hash + stride predictor
+                   |
+                   +---> Prefetch Worker
+                            |
+                            +---> page_cache_sync_readahead(WILLNEED)
+
+Sysfs Interface
+===============
+/sys/kernel/nsd/::
+
+  stats          Current statistics (hit rate, prefetch count, etc.)
+  observe_only   0=active, 1=observe-only (no prefetch)
+  penalty        Enable penalty weakening on waste
+  waste_track    Enable waste tracking
+
+Statistics fields::
+
+  prefetched    Total pages prefetched
+  used          Prefetched pages that were actually accessed
+  wasted        Prefetched pages never accessed
+  hit_rate_real Used / Prefetched ratio
+  stride_preds  Stride predictions made
+  chain_depth   Average chain prediction depth
+  synapse_ents  Current synapse table entries
+  ring_events   Pending ring buffer events
+
+Module Parameters
+=================
+  observe_only  Start in observe-only mode (default: false)
+  penalty       Enable penalty on waste (default: true)
+  waste_track   Enable waste tracking (default: false)
+
+Performance
+===========
+Tested on: x86_64, SATA SSD, kernel 7.0.0::
+
+  Workload                     Improvement
+  ---------------------------  -----------
+  SQLite FTS (4 GB table)      -18.8% query time
+  Sequential 64K buffered      +22.6% throughput
+  Random 4K buffered           +1.1% (noise)
+
+The prefetcher achieves 98% real hit rate on SSD workloads.
+
+See Also
+========
+Documentation/filesystems/fscache.rst
+Documentation/filesystems/squashfs.rst
\ No newline at end of file
-- 
2.43.0


