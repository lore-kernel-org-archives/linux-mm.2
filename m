Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D36B4C43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 19:47:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C87D76B00B2; Tue,  7 Jul 2026 15:47:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C5FA56B00B4; Tue,  7 Jul 2026 15:47:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B76426B00B5; Tue,  7 Jul 2026 15:47:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 829DA6B00B2
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 15:47:49 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D5FD8C396B
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 19:47:48 +0000 (UTC)
X-FDA: 84963015816.26.09820AF
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	by imf15.hostedemail.com (Postfix) with ESMTP id 08DCCA0004
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 19:47:46 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=FywJQfKm;
	spf=pass (imf15.hostedemail.com: domain of skinsburskii@gmail.com designates 209.85.210.171 as permitted sender) smtp.mailfrom=skinsburskii@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783453667;
	b=E9iUZ2b1Ovc0scVDBN7XSUcn3lq8+QNNPYBD2dmhGqa1y7iq1HV8NTZImkOwrmAG86xmIx
	TLWBnldDljnbTB/UT0xMPzYz9ftR2eE4FFBjsFxxt4AyYzZhZqG1TDARf0E/7hv2rodfWL
	HsbJc+4WJ1Imm37mz4/zPH6qb3YLnlc=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=FywJQfKm;
	spf=pass (imf15.hostedemail.com: domain of skinsburskii@gmail.com designates 209.85.210.171 as permitted sender) smtp.mailfrom=skinsburskii@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783453667;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CyXJGY0usHae+LXmamNtPRV/qmWOdkzAleKaxE3NMCI=;
	b=WYBIXywAear14iHkeI5SJb3+fgVJEkp7gSj9EcejHInbo3K51AgUK5Y84qOBxWOGw98kM7
	c4yAENOpWf4MzISf1hNSi5yQaY4qihmbkNFcl5CrAOINbyk6Vvx8N7rz86x7SzeoUoWP0s
	f2SUkA/a777iX/U8hg6elmj+TEM/wCw=
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-8453427d3f4so4419447b3a.3
        for <linux-mm@kvack.org>; Tue, 07 Jul 2026 12:47:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783453666; x=1784058466; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:user-agent
         :references:in-reply-to:message-id:date:cc:to:from:subject:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=CyXJGY0usHae+LXmamNtPRV/qmWOdkzAleKaxE3NMCI=;
        b=FywJQfKmwsYDj6yNCbTSoX0M+aTWQOU3n6ZI0C8iee9ShDSyFnDtyjIWBtwb8RXtZv
         vHDHT3lOmEhWEqkWPJZf3ccLKeYMOIKKjw8/3RGJUakWqWrW88msMD5n7R4MN9z3jVF5
         BY9NwOGQ37S5hSNc1uXXBp5oU7kSF3ChMrk5dp2RJ9T6eVRPO13+FACEVfVEkjmK6g99
         l2bASGo+PsDh040LikLffcoovKmuqn4a3AOMjjQdVPg1PdCYareY9HQBiLYriFq0B/J/
         9r7D77HEfFMSJVdKwFGMgXGn9wNQly+iujQghvA4kysyuWmykF41V5/kVqOssAII9Zpr
         124w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783453666; x=1784058466;
        h=content-transfer-encoding:content-type:mime-version:user-agent
         :references:in-reply-to:message-id:date:cc:to:from:subject:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=CyXJGY0usHae+LXmamNtPRV/qmWOdkzAleKaxE3NMCI=;
        b=R9iUoJA7imNLimfPV9XkKgiszfMhaaYPcTN264lFH1VyZk6BNvVwSwd0L16PrhqY2k
         3NGS1A5RrmO/nPq4fs84byznUe7a4mPYDFAnxy4cEHYIKQVIQdfw+wZ8ppt7gW4yS4yZ
         w6QciEkZaVMB9alQ9pBg2xFcjZTzJrMWIgTaxSDdBz6SmjygPejsunbi6TYcQ7oRjJVu
         7SA9YDKsIn56m2adnFxxI+aoCLBUsPg5SdXjl4P3+2//0xnt9pm4MYTqEPf5Fd0FJQsj
         KydJ5S6fK3+c3nuAEdzla5zlh1bPa7imrHYVeCnrUMrbqYLlrTu6t3af/c3tosyc06tK
         rG1w==
X-Forwarded-Encrypted: i=1; AHgh+RoLgQnwAPo9AIQjnx7JqdRomgFilmfr01Z+vWxXwxVLMZxngDl2iVrFIatgtUrsLMIhOJOUQ9xClg==@kvack.org
X-Gm-Message-State: AOJu0YwkstkVjUz0Uvro8kESLW+85eEiQIiUkRP9N5yzNC34UQg61NIY
	Ew0siQZh2oCaHUToFHDwH7YwHJJG6LeWjxBbcpJ7reXhrCc00l2PFXGc
X-Gm-Gg: AfdE7cl/PZ7nY/rhIUmfAoN8PzHAjSSFl5fZbx6dsI3oGQYBLW54C3IB+QKmUxqdXOQ
	yJYKvx+h/ljCfORxAxzHK6bm2A4uJJFPtvE9ytExSASFLXA3mwx2f6Fxq6QlKHFPveee9PIQ3pW
	iokTVwegV3GJu3jV3/uEUYiBXZAJAi1C9IcNuRkUMRR12GM5aOLYNZZ3AbNmdoMwFP6SR1AD/+x
	dc6yGsN0EWw3UpXlKPSSTPC5QgKGmRszATiOFg5W2h09muXAjhpo8ernPD1lvcXuuJ4J2VY7mBN
	40YKZBRlewyF1iJgQT1n51PrioJrFp2LMKkyObM1WPuVJQNtTnw4TwHrjozbdOLSnPPcGdTFE5D
	E5jgSqg/O8D2wfCcmEk3F5XvBH1LymC44896/WtWb+d+T07SbRbjk6zsLoxzRVbzbX1HdDd9JrX
	mGtEDXwW4NJqu/myy7BiScz5Utj487UqMiRWT/OecvASjiVtzaJK9wEd9aTII=
X-Received: by 2002:a05:6a00:b89:b0:845:cf73:c1d8 with SMTP id d2e1a72fcca58-84826c09c93mr6251882b3a.14.1783453665761;
        Tue, 07 Jul 2026 12:47:45 -0700 (PDT)
Received: from [192.168.0.160] (c-98-225-44-182.hsd1.wa.comcast.net. [98.225.44.182])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8483dc66f2asm280202b3a.24.2026.07.07.12.47.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jul 2026 12:47:45 -0700 (PDT)
Subject: [PATCH v7 8/8] drm/gpusvm: Use hmm_range_fault_unlocked_timeout() for
 range faults
From: Stanislav Kinsburskii <skinsburskii@gmail.com>
To: airlied@gmail.com, akhilesh@ee.iitb.ac.in, akpm@linux-foundation.org,
 corbet@lwn.net, dakr@kernel.org, david@kernel.org, decui@microsoft.com,
 haiyangz@microsoft.com, jgg@ziepe.ca, kees@kernel.org, kys@microsoft.com,
 leon@kernel.org, liam@infradead.org, lizhi.hou@amd.com, ljs@kernel.org,
 longli@microsoft.com, lyude@redhat.com, maarten.lankhorst@linux.intel.com,
 mamin506@gmail.com, mhocko@suse.com, mripard@kernel.org,
 nouveau@lists.freedesktop.org, ogabbay@kernel.org, oleg@redhat.com,
 rppt@kernel.org, shuah@kernel.org, simona@ffwll.ch,
 skhan@linuxfoundation.org, skinsburskii@gmail.com, surenb@google.com,
 tzimmermann@suse.de, vbabka@kernel.org, wei.liu@kernel.org,
 skinsburskii@gmail.com
Cc: dri-devel@lists.freedesktop.org, linux-mm@kvack.org,
 linux-doc@vger.kernel.org, linux-hyperv@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-rdma@vger.kernel.org
Date: Tue, 07 Jul 2026 12:47:43 -0700
Message-ID: <178345366389.660027.12986386801605494596.stgit@skinsburskii>
In-Reply-To: <178345345668.660027.2952911919681614557.stgit@skinsburskii>
References: <178345345668.660027.2952911919681614557.stgit@skinsburskii>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 08DCCA0004
X-Stat-Signature: qfu6zgi1aa71j8pareqshqmnxz7pd7qy
X-HE-Tag: 1783453666-608348
X-HE-Meta: U2FsdGVkX1/d4NLSdnM8xSv6rp9B4p75JULgxzeE4Ejg2cl/STE9wBUXcUNI56mUasn3SHQ4WWXwFoBXxPIYw6eQZfH3QUBymC7ormaVppvHSzbfOB5Gd9mdxFX2KaT1aiSDF0Dd9MCsgClGMPwcT+lB1Xj6XJOHKQCZzSFqYw4dYeP+73Z3T2767FlQoUagkhIAN/iVITy5L+VNBSeLFVq9B72Qfyg+cMZlyNqGjPc32klHI5P6MNr9oHUBqU0OfvK3/7HfqfD/DSENtuKiMI6aLFGQhfaAX08kI04Z5FWlMLONtYNh1Cd9xy7AIzEUmNM2ZZR1wIFW1OhfIIwd1v2Y81v41CfGI5m85yK1mQM5J3cJ+UYffpxCoY3gBIIJNhkiBkaCte/P0DW3SmxNY8881aLSiMgvUlOzdPTEKHbBrvtQ7SOQ0nsV47P1BJh6VW4+HbO1jq+fspzzxD/MhrAJYPbehvuSLYP5Tq8r4OQG5FI3Gr6TxzAqCqTbksWJ9G/Rc2Xeyjb3RFO2RoHX4kJy0S0iZfVN5EZreifHv/fnGejxrpEdmWcA1plX7h0zgN26myMITJtD9f3yI4cFC+S17ScmRCIIgDNRqo6YSw9bqFl5LqjjS+RMAY4xZDG+hSAOc72Uu5JPkwYH9x+9rw2D5YGmrvnSNtsZ1iWJMk004EZZB+tDKyUFBVmKGqXYkJ8Htt+aIJNWjqy9KCLsSoYrILT5loC5EoHMtu4Bw3+qESZZlYTAXAZOEL1JowFetiTV08B6ggHh3yRq+QLndPAscu/hveox1+KeEvjltODpb6mS/3R9DHh6NvM2kYyGglAawxehBssKNGaS/4Cbl5PDdDvSHvTTB+Fg7CYUfbut7xU1yceJkF0DNHkRlhyRL6mfDyiBayssF7mhEuvvuK7GmHCaBEdzzjByhRzFQawVTr7s5PuTKj5ywj72FTaAGQCWg5LK9rKy51V7+Yk
 GEb2ojSU
 3N440TvUQ/VLjqz6D2fId736MmEeeBEFxO01ijx6LBKAEP7zJEdfkgRcub+gnqBEENExDZaoFQw/Q9t264vWx1+wUKyVZIijnCpi1jBkb6TJrRW+x9TFUxAxRp6Ol0tWVIEocrzlIgHIbY9K9GNOvMx599u7Y6zqiT8ySrew4eIagXo02y7yAee/dD/C6RDm5EQXypKUjm9vojMRNwxLicOA25UJglOlZgOIp24W52BRgUJjf+/FYJOboJPZKQSIyKijw2zk5AN0kx2Qyvmcnu6gJFFlEkrrkNbf62oW23SZ6f03SaPZOyoFVsSBYIJfWwKBXBaUxFqEuJoopPsKBpb0/TharxrzdEx/bjrLbOK0UBt4RGA2G40CcIw55ufzisRltRxSQLYRIzTwK5N5z1gkruARyrHqQqZpkEZJUTUe4d5RYFSQkhnmfI+JJB7J6AKsmc916xnTfrKnUngfK9U3nDlOuWr809p2/uHCWExlp6U8ykdzfxfpW1SkDBmBJFk7pMjDHe9BeSQCeWeZX6/srjNM0FvAtcbE7o8BEiFVWtV4r2dPNK+eX9w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Several GPU SVM paths take mmap_read_lock() only to call hmm_range_fault(),
then retry -EBUSY until HMM_RANGE_DEFAULT_TIMEOUT expires. Those paths use
MMU interval notifiers whose mm matches the mm that was locked for the HMM
fault.

Use hmm_range_fault_unlocked_timeout() for those faults and pass the
remaining retry budget to HMM. The helper owns mmap_lock acquisition and
refreshes range->notifier_seq internally for each retry, while GPU SVM
keeps its existing driver-lock validation with mmu_interval_read_retry()
after a successful fault.

Leave drm_gpusvm_check_pages() on hmm_range_fault() because that path is
called with the mmap lock already held by its caller.

Signed-off-by: Stanislav Kinsburskii <skinsburskii@gmail.com>
---
 drivers/gpu/drm/drm_gpusvm.c |   52 ++++++------------------------------------
 1 file changed, 7 insertions(+), 45 deletions(-)

diff --git a/drivers/gpu/drm/drm_gpusvm.c b/drivers/gpu/drm/drm_gpusvm.c
index 958cb605aedd..2601b793428c 100644
--- a/drivers/gpu/drm/drm_gpusvm.c
+++ b/drivers/gpu/drm/drm_gpusvm.c
@@ -788,22 +788,8 @@ enum drm_gpusvm_scan_result drm_gpusvm_scan_mm(struct drm_gpusvm_range *range,
 	hmm_range.hmm_pfns = pfns;
 
 retry:
-	hmm_range.notifier_seq = mmu_interval_read_begin(notifier);
-	mmap_read_lock(range->gpusvm->mm);
-
-	while (true) {
-		err = hmm_range_fault(&hmm_range);
-		if (err == -EBUSY) {
-			if (time_after(jiffies, timeout))
-				break;
-
-			hmm_range.notifier_seq =
-				mmu_interval_read_begin(notifier);
-			continue;
-		}
-		break;
-	}
-	mmap_read_unlock(range->gpusvm->mm);
+	err = hmm_range_fault_unlocked_timeout(&hmm_range,
+				max_t(long, timeout - jiffies, 1));
 	if (err)
 		goto err_free;
 
@@ -1439,21 +1425,8 @@ int drm_gpusvm_get_pages(struct drm_gpusvm *gpusvm,
 	}
 
 	hmm_range.hmm_pfns = pfns;
-	while (true) {
-		mmap_read_lock(mm);
-		err = hmm_range_fault(&hmm_range);
-		mmap_read_unlock(mm);
-
-		if (err == -EBUSY) {
-			if (time_after(jiffies, timeout))
-				break;
-
-			hmm_range.notifier_seq =
-				mmu_interval_read_begin(notifier);
-			continue;
-		}
-		break;
-	}
+	err = hmm_range_fault_unlocked_timeout(&hmm_range,
+				max_t(long, timeout - jiffies, 1));
 	mmput(mm);
 	if (err)
 		goto err_free;
@@ -1736,24 +1709,13 @@ int drm_gpusvm_range_evict(struct drm_gpusvm *gpusvm,
 		return -ENOMEM;
 
 	hmm_range.hmm_pfns = pfns;
-	while (!time_after(jiffies, timeout)) {
-		hmm_range.notifier_seq = mmu_interval_read_begin(notifier);
-		if (time_after(jiffies, timeout)) {
-			err = -ETIME;
-			break;
-		}
-
-		mmap_read_lock(mm);
-		err = hmm_range_fault(&hmm_range);
-		mmap_read_unlock(mm);
-		if (err != -EBUSY)
-			break;
-	}
+	err = hmm_range_fault_unlocked_timeout(&hmm_range,
+				max_t(long, timeout - jiffies, 1));
 
 	kvfree(pfns);
 	mmput(mm);
 
-	return err;
+	return err == -EBUSY ? -ETIME : err;
 }
 EXPORT_SYMBOL_GPL(drm_gpusvm_range_evict);
 



