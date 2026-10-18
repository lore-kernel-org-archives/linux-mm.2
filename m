Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EF3FACCF2C4
	for <linux-mm@archiver.kernel.org>; Sun, 18 Oct 2026 03:52:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DD8366B009B; Sat, 17 Oct 2026 23:52:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D88FE6B009D; Sat, 17 Oct 2026 23:52:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C9FB06B009E; Sat, 17 Oct 2026 23:52:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3A1246B009B
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 23:52:16 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id BEC2E803AE
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 03:52:07 +0000 (UTC)
X-FDA: 85334373894.18.6EF0F20
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	by imf05.hostedemail.com (Postfix) with ESMTP id F3656100004
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 03:52:05 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=KQO6f0xP;
	spf=pass (imf05.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.216.53 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792295526;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6B418+SzCM2Ac+ZkuhfOdHoqL+9AUQAlnO0fG1JXa14=;
	b=P7vQjEdpwwxCXRFUdSWANTq8BNZwK0GbeR5nsuBbxlKi5cParO5PeyCSTHUg5cIP2rgw26
	oxWRccd0cTykVB/vfMzxO9aYYbT/Bk6XjYQeoKmnEw5e7CE7abGj8vUVUoSpF1oS71UMyD
	JbvaDLSB4G0CxUOAjbdvfkjMMD3Z7u8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792295526;
	b=kdDwKVKbOhyS6f7gBm2gFKNXlaEu7mlcySybELVTjwl3beY/R6P1MTuLNTAJUA3LymRd1z
	30f2T4aq5YkR8VPcdXcnDAhQ9ykJGy/ty+32llP3zhE0ThfVq8V05N0CYPTQUvvUSFupV/
	iAWkOsZOHxg5iuM012cWOS3N2bFjJoY=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=KQO6f0xP;
	spf=pass (imf05.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.216.53 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-3ac677668a9so932097a91.2
        for <linux-mm@kvack.org>; Sat, 17 Oct 2026 20:52:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1792295525; x=1792900325; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=6B418+SzCM2Ac+ZkuhfOdHoqL+9AUQAlnO0fG1JXa14=;
        b=KQO6f0xPRrE97DiowjkxlOV0XI+N22Of+dFZKzEKqSPckEwwin5dhjePRD0RQ7fwgu
         +yyep8n3io4aLtLEiPCNYRU9Az4nhDbDNJtMogBdN2UEGtX9tP9+clbd1c6+tPzy55ct
         ALiZ5SU04qxvYcu3dloFyPGUcExml20JYKenU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792295525; x=1792900325;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=6B418+SzCM2Ac+ZkuhfOdHoqL+9AUQAlnO0fG1JXa14=;
        b=dWx0KRjCsNfs9fZuntUdwGVVegzDCA9+lNXEQMCnOCynGeqhthqZQYcnIIHjKt5fiB
         cYNqhN+1Q/TUKKdR3QY4SFPix2R4JHVuDTLW+lq0sW9lflReNtEVPF0bWI1ej+Egmjg9
         HWMKrsSo/6IezmLR/oox2jl4X5xX6fKTqBV//9+yVTIV4g7iGrsvcxDs12DPuMFJRo0C
         42it/a0OAa4XgodxbbkOj2AM6Z8m0nDLX587NxVEjk0WfmsA6D2vv5+oFypg+Es5ivH6
         o4/sUbZDiFhtQomrl+ufClQ3ag+v6rQ3PUPg4b4IWWcsBrKhOlppPmJCLvUTSP7keZ+p
         g1+g==
X-Forwarded-Encrypted: i=1; AKwUvBzZuzxrHY9jv1EH9DnUvJj1I3Sqmwg2HM1mQMOUMYIqBSMVOLXvQDSUw8FS1tnXlkz5BjDaIAsVvw==@kvack.org
X-Gm-Message-State: AFq9FYKSgqpv+Y0YQV23sSLV6sw74o8zIksYGHHTLSKc1cuJ4HhUnYyB
	qXuPu/JzRWG9ACv/FJsBXObto86ArDlIw3SidxjPch7Cb/2vrQJeKlZb4M2d2tev0g==
X-Gm-Gg: AYBFou1sDkl4AJCeCcrUUI9zQLiSbTF+/mMJa1CJh3f+Mn+apB6LA6dBN46uMMQcCb+
	7Ns6fBAEuE6Ji5vjgobzOpu3tQJ5Jopx9cN1s5u5iADgzxqSuGP9mC8gS+Qa0vy/oaFDvh9r9JZ
	VWmG6ecFUoUpT8xXeutl/xo+y8GEcCBwyxoFx6gQkzR+wHZNwkTXxqa40ad0F59PyBSFA42LtUD
	4sG8n82wMTAQJprWd+cyOXjmTQFpNnUuYEIr3gWJo+Q93B0/OXqy0s+lzcLkD4h+vy18MUxuDJ/
	fbiuvfc3NfLZBXh21kAgg5f/1++HiGL7PhafdHr05RMDBqbtw3fiO49Wc1fcHEbR+EtYGAsm1I1
	DwNEZoKH7Wx9lqI+QYNpyOo6UQlAD0QuH3B/QGdeJ9R//zdg/gqqVkdDucFtJicWJVVy+2gnGza
	Fy1a3qCk/GUdc/Zi728nRBmBr4oxjy+Ppl1tQsrMmL6l373ordM8NIWjVUrHj5nhrkthb1UdLy8
	VpUOKuSDytWDtechocWsQMo/d1ktFsbi9fOEnJatEbzIwiwfiUn6uMmiVgEdhE=
X-Received: by 2002:a17:90b:2886:b0:3a0:9fe0:3aaf with SMTP id 98e67ed59e1d1-3acef3dc81cmr3308976a91.48.1792295524943;
        Sat, 17 Oct 2026 20:52:04 -0700 (PDT)
Received: from tigeriii.tok.corp.google.com ([2a00:79e0:2031:6:4569:b311:f3ea:5f8d])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ad25d5d1b4sm253024a91.16.2026.10.17.20.52.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 17 Oct 2026 20:52:03 -0700 (PDT)
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
Subject: [PATCH v5 08/13] zram: reset writeback state in zram_reset_device()
Date: Sun, 18 Oct 2026 12:51:10 +0900
Message-ID: <20261018035125.3120704-9-senozhatsky@chromium.org>
X-Mailer: git-send-email 2.56.0.176.g3575e65682-goog
In-Reply-To: <20261018035125.3120704-1-senozhatsky@chromium.org>
References: <20261018035125.3120704-1-senozhatsky@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 44j5nttez3w1o6srehwgfqowi3o1475r
X-Rspam-User: 
X-Rspamd-Queue-Id: F3656100004
X-Rspamd-Server: rspam10
X-HE-Tag: 1792295525-585005
X-HE-Meta: U2FsdGVkX1/fJ3TH+H5kIjMQjNNkt2uuQr1e23aw+Tdr7maubKdsZC+Ey0lyQb9UHaalfsCoL6Tsnh8e5Bo5jZSF2MD7KaFfeBnDpPfVGEye26Jgl8pWFdQGD4JBlSHAA8KtCTC2LYT4SbNWzPxDz9eyTO0f2vBLEINMx7rtZrImVijWa2+DXQ6Rdi5XCR3f0Pv6V84f0T+Hl6wRVUXqdrMk7UObsv0/kWa9Dv7ulUXiqtgIV1EeC8d4E/4rZtvgAX4MecJoxlCxkPcG2zWrplNWg7lbTf+wRA/MWTM+YzAUyN5uD0HpcJhySesiYsKEdgtVQSnZmcI0Kh9kagJmz9joAo9gbe9x+SUC5ca89a6FC3RHYx5/CHS7mcraS+XaEnWX2dQNjjRaRuMWNgd7UhJDxDZHcyKJ59Rvt4CorqCWZuG8TUnOJOnYnELLHgs6DJEpI+tJE1+DbmmxIcS3BDzFYd6U6hmlh7LCmNbqS21VqcZq0JQKImdlatj8a8hp/ZbWERNF9iqgOSYNlKKJlppxZsuA1ktDpW8Yh7c3FEFhd4ACMaPD+hS0uBxqIbGyjy/ndThVucSo4sn56ij4qVhekobg0uWG1NIFnASNOEvfz1VB8jEgd3WwSrY5tmhARu6n8j7k3ZAxbLca/rU15oHav4IzR0H/zTYaj1r099L4bp8s+PSQ578VsVNjDhhytnmiuNptkf6P6tvExfYcJ7MmkfMBJbBWLN9z7l14YWwUJPkzJcyUWani+C9et3kVHOllNU063V6dT75bdr0yS/cSE20gnaE+LGPhM3I1Piqii/41GWfmB8H+PppOLXuKVMZDK/uc+VXwt8xZL3ZoWU148FwhlauEaF2icVh/iMxTyd3PPfwEf0e+uA6neKssguxnT4MLp13Z0cn6H9B6Dnsaac9Ba+1XYrXZwAd8p/wT+Rcm8VaGj22EkbBTmjfVY65bvlcKvMN8AWNpjmo
 m2BCucgY
 IXGnImR7923lYGGZCYwnBoIBh3Wgn0mnjUDggoZ8kPL7F4fDKQa8A7/gxnISSaZyli2H06jqyLbciktZMHVNUw0bfof4UblRc8nmhGFHXnlrCmwluwuRhmUpMbDl+nCgtObFS2X1FpNrtTAiLw5ZPQ8tWYzVdHo3I0kqjPhGqWZ18D0/TZT8YJ4C+ZUg7HjjYYMsO72JtF6HxMYUg3+pikAn1CHHb9+jHQH4ZEG4VW2oU9t5bXuvmZCH02+DGAPmbUy9C8UU0QPYeYU/jN+IAjDPPb7rEWY1XKLABPebVcCMLLwWCfz24xRPHfwBONWTdoLMuY126XoMdIk/Bhok3krf3G1qjJVd3LHHH1GiKZvL0tIiZ9b6VbWMQyPe7vwIaeSb+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Reset all writeback state to its initial defaults on device reset.
We used to keep writeback related data in zram->stats, which
zram_reset_device() clears, but commit 1d69a3f8ae77 ("zram: idle
writeback fixes and cleanup") moved it (along with the newly added
wb_limit_enable) to struct zram, after which neither of them was
reset anymore.  wb_batch_size and compressed_wb, which were added
later, are not reset either.

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
2.56.0.176.g3575e65682-goog


