Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 882FF606A320
	for <linux-mm@archiver.kernel.org>; Sun, 25 Oct 2026 02:19:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=chromium.org header.i=@chromium.org header.a=rsa-sha256 header.s=google header.b=RVJVBulc
Received: by kanga.kvack.org (Postfix)
	id 0CC426B05B6; Sat, 24 Oct 2026 22:18:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 09DF66B05B7; Sat, 24 Oct 2026 22:18:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA6D76B05B8; Sat, 24 Oct 2026 22:18:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B3B966B05B6
	for <linux-mm@kvack.org>; Sat, 24 Oct 2026 22:18:55 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 43D2DA80A5
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 02:18:55 +0000 (UTC)
X-FDA: 85359540630.03.138B7AF
Received: from mail-dy1-f173.google.com (mail-dy1-f173.google.com [74.125.82.173])
	by imf29.hostedemail.com (Postfix) with ESMTP id 7C290120002
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 02:18:53 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=RVJVBulc;
	spf=pass (imf29.hostedemail.com: domain of senozhatsky@chromium.org designates 74.125.82.173 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792894733;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NnTIHT+TXV1eKkVYDiQUUSu10XDJ/e0uYyNb5Fs1tYM=;
	b=cqc1F0bCrQbAwomhugYrZT1sWfjyHAWjmyY9q718/Lsn4hPYTfYJQ4c1x36Ya8l3t/KP/4
	9Ks74qPFbw34rkTfKidWJWvEgsw0igVhhTQAUT4YF2YPqmfTjNHIfiu37XtY+HhfRnELng
	FO6We6G4tOuyUS1ZPwZZdlYj6VwvzLw=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=RVJVBulc;
	spf=pass (imf29.hostedemail.com: domain of senozhatsky@chromium.org designates 74.125.82.173 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792894733;
	b=LCFppEQ2aImakWlP+BFQEzIuuslC0dp/DEh3CF1bYuqsbWO7VNL8A3Zariz5EDw3PGkuP5
	er3wFI4xiQ8s+0ysb8ZMSC1titYSX18VNeisKdBeee1bPYiluk59gAbLzaOGHCwvTdqd4S
	yL7swcFqx34EwETK5FBJUXlHs8Kahiw=
Received: by mail-dy1-f173.google.com with SMTP id 5a478bee46e88-35cd4e8bdbdso3500612eec.1
        for <linux-mm@kvack.org>; Sat, 24 Oct 2026 19:18:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1792894732; x=1793499532; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=NnTIHT+TXV1eKkVYDiQUUSu10XDJ/e0uYyNb5Fs1tYM=;
        b=RVJVBulc+i94jIy1TL5eGe3iFHpiZpaxsGIR+Xdx0kKZT5OeNjcAn5NpivEqdufXRm
         2cOdmffKwLxc65wDbXmZrvDbibVXWQpD4rRR6k/V/rXYSeHzHritPLmIrwKdhwX+QnUa
         6B/jjhD5I8gqCTJR0yX3CyS5rtrHg0eI1FCWo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792894732; x=1793499532;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=NnTIHT+TXV1eKkVYDiQUUSu10XDJ/e0uYyNb5Fs1tYM=;
        b=THHl9Rhw8F3QBD2dMJlWQHsdzFBYaUXS1HZ6m2RGKdOMdwKnyOit9ufCe0SpD7oJwI
         MvGk11R/5kXaIqsei+860swplsDewSaz1NLHGOOZWc0KFx3X5vPpLW/uWKQwdlxMIWJ9
         A0NGssTqMgWJex6xN82xG3qo8J54CbYpfM7+7VcE254d9QvNFsixv+jdNBGY1Nuo0vf2
         c2Y3MTrzX+DmYJmANRiSYeC4X5NAZ/ybYItYaj7WdhglrwzUbuZEQp5fGv3gwvgts5Ui
         bzylB3glimYX29WoKIMWMS9sRvcLoMr0tyZxvPCINQILel1U96xqVx3oRzyoJHMrKjQx
         Xj8Q==
X-Forwarded-Encrypted: i=1; AKwUvBypoRkSrsvPPg7NCvW9tgfVSj0lryz5UxBwnLKkMCsxgPzjrsEKlkw4sbvde8I+4RTncGaYhq1RUQ==@kvack.org
X-Gm-Message-State: AFq9FYLBe/cthr2w8vcvUSBVuQ4439ReXGT3CYcM+eH1H6Y6Dl41GGVR
	GrGUh7bCJnc+I3NgXnVaT5ej1xURWV9nrpMGaAZYAKQYpIsr8pLs57uPcrwL1/Y53g==
X-Gm-Gg: AYBFou1FtZf5n6p5576ggJkWTrIDj/1Erv4xf36W4ZMiGigOh9GaC49+Y93rzPOE280
	5taFuGkmTeu9weMTp/eOIh6x0j71+HMi0U4IRKr7USesTyt7NMiO5TucxzsKFHFdEV9IV3VGLWK
	I8si/gvf4H1Tq/w2GUbgUhn7bGz6czQw66UDICRN3VCx6/rnwO4W0rwx/b/GXa0owNx6xITnZAA
	wPsFh5ojsxzcULqgxGTj1BMwBSbauGDd8ge1PDcKq2otvEeAIWd7qN8XwBW6J4FHZFcvB22kE04
	qTx96s4NNlnF9WgZPzZj1iUnuw3Ywkn1xndN1wbzARiXgfjJEvYnSMfaFkYGaLo+i9aQmTZaaNB
	8tsD5+XU1fv8ad5ThFsYmmmcHZ/KAfHeOvtFDyg/pDcGvLVSHbUD5L5keumu0+y6oIyj1KRrCs/
	ecsPE8NW50gEq4C9VuuzZSSohCuN2RFS/Suj5UDcEHDh4PsFWG2KIp4mvw4xOJB/MmhYmDEiJqS
	UNn0ij/Rcqa0sdZPf4bIp3EYLuXyl/eUHIiC5HDQ65fwH80+csw4tVgPuDjYSI00YY8CaGh9O/Q
	tOUFpvKg6fryLJs1S0/KrnMtg3+wGUOc0EcLCv9C/yXA
X-Received: by 2002:a05:701b:4306:20b0:184:1898:add2 with SMTP id a92af1059eb24-19935625958mr3965718c88.26.1792894732162;
        Sat, 24 Oct 2026 19:18:52 -0700 (PDT)
Received: from tigeriii.tok.corp.google.com ([2a00:79e0:2031:6:9f87:66fc:8c85:11bb])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1989ff2ee5asm10387242c88.8.2026.10.24.19.18.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 24 Oct 2026 19:18:51 -0700 (PDT)
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
Subject: [PATCH v7 03/15] zram: reset writeback state in zram_reset_device()
Date: Sun, 25 Oct 2026 11:18:19 +0900
Message-ID: <20261025021839.1542805-4-senozhatsky@chromium.org>
X-Mailer: git-send-email 2.56.0.257.gf7497c7d27-goog
In-Reply-To: <20261025021839.1542805-1-senozhatsky@chromium.org>
References: <20261025021839.1542805-1-senozhatsky@chromium.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 7C290120002
X-Stat-Signature: rcfpguiuts3wjmqdohjqm1cqxafejh71
X-Rspam-User: 
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1792894733-335540
X-HE-Meta: U2FsdGVkX19s4y2aJ+9+F2cw2wd8eLqWGGZQkwHsCyVFJ+vX/WCTsIOUAeC9xlCBGfuNzTX8Z9yHDrqavA0J/ISaptbglHq5UEKHOMKmJ/oMxCP5Rj5jCaeT6sLKnGAbibXpaa40Pwz11/oKDzZ5Y4uhlrTwwERIhgKhddTkDyEykZlcjcV8K9LC11fqzXB1yjr2RQ8ErVtaWHYg4pn7HT9iNpgG4Gq2McDOuOp0nry0F5TFnMcLnxsEfFHSmXtCZ5CzlGTQW3jC0hqI3ByXYVMiXh+alYSooG8tU1B2e9TggdYdQo4Qt9utNz33hAHINfYxzK2/My9aP7dckqAmTzfxIgjGe6JBI1ZYye6UzHt8NIGAlDaXSDavSML4aKUXwJTeqqtwy4NY+GadUr0S8SF+Iqo/O9yUYxOE0nxGeGIqj8O4RUctneqc8kXJxEoOZrAQsGA3SYllQPAVBKnhBLxtHy4w2xZaQ2aa6yuESK/z9of0ZPmPNUENWJpZtAyhkfBnFXXs+De7j7FE6lHqUMJAD3CpcrK/8jr5f6GYx/E9UtWBRQGfZ+W9FMo92GcsEqyQdXaQp0HJ6spoInebBbXV9uKIXI/VMkIjWU9ZG4euolnHyitmGSdL3gx9Q9BQX38MlQImOuAQbmCKGuswLV1dUiFykjpQWi+b8TYW9KQYSQMRi1PIhmg4ro/GQg2s+h6xLc35kGCQsA7IeeXbAExaqYCuDaJ428TexS7OIzmcBLhQ+uxZFQc9f1PvT5f2bHq0d/9frHVgH5OFZuvDa2KiigslrhQP/MEf1FqNrgb98HCMM2bpSWQxJhi86u7XvH+7CIGuGazAzDgCrEc+76w8uffe3MMdg0RNFoWoinCL3cOhcVOOUoLFL+jNkcVGv1Dd8Q5I/g8rjRP1fRUZiutfZmpxYCiu3bvqp2+slkzi36DrQdSskO9zqf5zCV5c3Ye2Rx84dY7CMYecOrg
 MYrgPF/E
 Vcza2i/BXoM505sA/h6xjqYKl4zzOzTqolgPwXJjL3iBSnLiF0/3iQfbJ9RHfURkpuT3PvCyG6r6BsNnUdj/0YwsLLypMM9oII2BF1yayN9IgVOJQbhG5P71SpWGDbwOgmFoUJxNfkRs+HfSTdILjxKXZ6Q/Kv7Hksgwe8tKCkLZYEVK0XsBBV9C8lcUQOwg3X3RZGki1qPhl/Km46P8KY19//sNE46TEPU+ZlnbCkwelzAzY4pMvlw5Xvgo4e5D0oScTW9ozgPiPAQCPQ2Xir5wuxYCJ53rmEbgaGgIKAEJpLSHlARw97FhYhismdG0HhRxbAeTDBkz0gP7BIee9KcqCVnWuzCTTKVIQCaViuHpHR+d3V0G0lec0yw==
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
2.56.0.257.gf7497c7d27-goog


