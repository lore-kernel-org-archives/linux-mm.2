Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1EFBBC531F7
	for <linux-mm@archiver.kernel.org>; Thu, 23 Jul 2026 17:37:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5FA6D6B0099; Thu, 23 Jul 2026 13:36:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5D1946B009B; Thu, 23 Jul 2026 13:36:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3FEC36B009D; Thu, 23 Jul 2026 13:36:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0F9D56B0099
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 13:36:58 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8332B160124
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 17:36:57 +0000 (UTC)
X-FDA: 85020746874.06.2C5894E
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	by imf20.hostedemail.com (Postfix) with ESMTP id A428F1C0009
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 17:36:55 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=YyEyLYm+;
	spf=pass (imf20.hostedemail.com: domain of skinsburskii@gmail.com designates 209.85.210.176 as permitted sender) smtp.mailfrom=skinsburskii@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784828215;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Hwr2PA6k/yzOHBkhyRcV60oQVyvCsFMHOEQ+QEbH+Ag=;
	b=wMGoWHGwL3+qDhJnI7DiKqpKbJYXGOfgrVc7CYowKL4+FjRmusNFfSquf5SmpIyg68LMxL
	qjf1z3VBgd07HZC2ACvezFJ/PgBNPHSDqJrApn4rnQTtn1XQu1qYO8EETQdbkTta3tGU3u
	bY7pJ4cCrUISk6PWizKpSK8Ki9jxHJA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784828215;
	b=uvvI+MZvcxJy6cNPDp2XJ13ZfKb9JcsA40NPl3cRcgGzkl5CaQY7XoU3FyzOkrvjbNbDey
	7slstcXf5YEt7Qq4PWv30x9w+jVoGk0M9oe7I0N4YYVBkea4UR/igoBcLWBniwTr66B/5N
	rXoAKvHr76LgDV6dGOaDmfB4MgaVqIU=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=YyEyLYm+;
	spf=pass (imf20.hostedemail.com: domain of skinsburskii@gmail.com designates 209.85.210.176 as permitted sender) smtp.mailfrom=skinsburskii@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-8486672f03cso969628b3a.0
        for <linux-mm@kvack.org>; Thu, 23 Jul 2026 10:36:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784828214; x=1785433014; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Hwr2PA6k/yzOHBkhyRcV60oQVyvCsFMHOEQ+QEbH+Ag=;
        b=YyEyLYm+vSCdDOb5WGziI0YO+1v8elNqXSiD/okO8+d+jGu9F79U4me3uADnLha+NL
         0gchTXsTZjGM+bchHk6ggLmLh/zUZQnrm4cBLUIjqR8C4phrGFL3N+K1ZAYTPtrBhAYy
         DkBXYGNfVYTxenBmBRKTmpe0GjfeTJOhiQG5HlhH7keuX4F7Wn6TosVsBvNcsmEkUX7r
         QaxpfUMeBRMpP+lECSicU1tP5CIIWa6+SV+WVJBwsEJcBuppmRSEuvK5mNc1HbysMkZR
         nvqTPL2vI/Lxd0CtDEwkBwOiAYj6vDpqEze58wZsbmchaB8wwO4vzy+eaujeRroJd3zG
         X5Fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784828214; x=1785433014;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Hwr2PA6k/yzOHBkhyRcV60oQVyvCsFMHOEQ+QEbH+Ag=;
        b=svg3rNcWWODS2rGkSoPUrOsJPtF7mHgHkxp60EYroXguv4j1b8QGsEDItWJdwseR1L
         m6jXGBWydyNRXD8XlxppXP0adxzummx7sX+VyfCXD5qekUNiOoYfYWKsPsDcMcsvHUvo
         Yu7XMsWkkP6vBj81nyTNJTO70ts7ofxWoIvnp3U701pv/omdQvVO+5XzU62OQb+NecC2
         +hHre7/wZUcXLtG7TpOLUWoswYqvDQvq8O4qJbWKia/AvIachxrWd3YN6nrDUsa6zz21
         TDKEepf00ZeOLZ1qf94gRhw85Jwhtzm4avL9KPAL9h2/QGIKFJDL9++Q59wFENdCjVqI
         nQ/A==
X-Gm-Message-State: AOJu0YyjorSObFSIwkK90MOi5HHnm7E9A+6EeqLdOqh/wnP+2+4BoNkg
	UB6EzK0GVQTis/3U4rTjQquuhiBPBRAc6As8bh7b1K3005IXM5WK00EY
X-Gm-Gg: AR+sD13EDkA+1XxcHAEGL9R0pC0wzOkCYGe8YjcJ/Dl1SIAYpMFcDgW1JIv558tXexf
	lOIfTZx8Qz+fF0eab5DTCLVIOz/j1IyIGiNGJylkkgQaq0+wRXADc+qNz1nMBJ70YfJ0WjgYE09
	F6Wyu5Y1ha2b/hKSQ9HKke2D3sTvI8dzJFsuJKbVBSwQN8eYb6tu5y/0EsIx1zeq08vIADYHjg4
	KWYe0RtTpxXPvOFTwcmy+s8h+AIKlKYbemytCH271qr1nrOJixBNH2leuGmbja5/KYiMkk1SL75
	OwJjEs/Whjuh/WlSrY5lpTJ88s19N+S43w4hyMH36bOIIL57eeeaQwjjKSGC6kEdluAfzVnvXhF
	UuW/DJ9r1nwq4S6Ppv/P/j9J8uLYi25XdAiCoU1T0RW3FUEl9YsEBtppl5oMaHvG4h5kM9IdZgZ
	2bBHU4Y1idNcT3FMHDJ5Ar6KwK3gWrlkjiZn7HYKHN0GHFhY3S
X-Received: by 2002:a05:6a00:e88:b0:847:b16b:46d9 with SMTP id d2e1a72fcca58-84e2b8aa77bmr4617793b3a.34.1784828214639;
        Thu, 23 Jul 2026 10:36:54 -0700 (PDT)
Received: from [192.168.0.160] (c-98-225-44-182.hsd1.wa.comcast.net. [98.225.44.182])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84e20622dedsm2691612b3a.11.2026.07.23.10.36.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jul 2026 10:36:54 -0700 (PDT)
From: Stanislav Kinsburskii <skinsburskii@gmail.com>
Date: Thu, 23 Jul 2026 10:36:38 -0700
Subject: [PATCH v11 6/8] RDMA/umem: Use hmm_range_fault_unlocked_timeout()
 for ODP faults
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260723-hmm-v10-v11-6-c55b003a4b61@gmail.com>
References: <20260723-hmm-v10-v11-0-c55b003a4b61@gmail.com>
In-Reply-To: <20260723-hmm-v10-v11-0-c55b003a4b61@gmail.com>
To: Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>, 
 Shuah Khan <skhan@linuxfoundation.org>, Shuah Khan <shuah@kernel.org>, 
 "K. Y. Srinivasan" <kys@microsoft.com>, 
 Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>, 
 Dexuan Cui <decui@microsoft.com>, Long Li <longli@microsoft.com>, 
 Lyude Paul <lyude@redhat.com>, Danilo Krummrich <dakr@kernel.org>, 
 Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, 
 Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>, 
 David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, 
 Min Ma <mamin506@gmail.com>, Lizhi Hou <lizhi.hou@amd.com>, 
 Oded Gabbay <ogabbay@kernel.org>, skinsburskii@gmail.com
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 linux-hyperv@vger.kernel.org, dri-devel@lists.freedesktop.org, 
 nouveau@lists.freedesktop.org, linux-rdma@vger.kernel.org, 
 Jason Gunthorpe <jgg@ziepe.ca>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1784828202; l=2457;
 i=skinsburskii@gmail.com; s=20260722; h=from:subject:message-id;
 bh=wCDSwsZ/5jgwWzEqFja4q7w3SxWPNbitK21qCohy6H8=;
 b=gezzOLTGQ+6T3Wy5w3nFtel93rrT2Kd9eeZ0n6f5FEQw8Beb0IrNif+mDyjnRhH39tdmJbOsG
 yXEZFknqYwdCOt8awUKVwHYE2B6xTW+3MpwtLFeYQDVzLwrWkfuTvq6
X-Developer-Key: i=skinsburskii@gmail.com; a=ed25519;
 pk=bDpriHBYgeTdkIDweZDCemxsU93neJBOCn3YLIuJpnE=
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: A428F1C0009
X-Stat-Signature: mmoq7e49t7sqerbc68tedobft9k94c4s
X-Rspam-User: 
X-HE-Tag: 1784828215-184387
X-HE-Meta: U2FsdGVkX19mEwNwG8L6N8jgl+YuP8P5tyEF/23vfv5vzRIrBXdwdXMa3De5G9b0AOGuijmzHKScRPGsY9U2HDXOV6G2TtO9GaY+8gO0TqkOlBIqJrmpXv5Vt1AgZeVBgglQQ8aqy4aG3p/wjPXbyxH5BkLKoxAoEsIQiRxNUjFb6vtgiMrR6v0qtOV71XAIPh+NctC2y1QOxL+i/j8ZvqXP2QtBg0LZurj87BKrbPkRAWptNoYgjeiC+Zew6rD5N1KK6mCijDFbmC8r/PeJ3lohDXmHg4+qwvQReXB2EqGwnpNOTnES5GWi63/ZANJ/KMTmE1KrD0JlQmc8NQynGRF8km6fwO3mVRjdGsrtQdVkye1X6UkOnmeBmj/7fANayIhOXvOIMmnG35G3Qau88ymRtJQ618TQ0sz11OrAeCvzp7H/dAje5BrifIfIOmxvnddf9/CcbEdWQwC/2h57RmM8spSDNYgmBIB96+Um823S6qA4LvObBHEQsP1xu7ux7ibboAeoYZV8mnaQqMtGAuDIaO2IVFttLioQKDqyFfcTpYBNfqxcp8h4e2/khz0sigNuIKTi/6FDcMEKFFJ8y238tVYnal7WURDLv7WBjNK1Vxc25/WbgqH44xmpJDztaR3b1L5l+HGRCD42hyA7ryx4jbiFP53er34XTJm0knTHy4eX7bY2e+cKjcXF3P+GYEMqvd41GpMgD9ekEyeQs8D23zzvNi8/3WS8XC2+oJZ2hLHw3ewSHQmURjS3mp0fEo4wajQvmNhS/8crHRRV/1kJQwfYtqW0gPnqdT5aApAHiQcS2dbuyoTX40jC9oCzMsLQM5a6YgrMy1zaEqq6ip1Bx+zApf3K0tGqnta5suh/hIMqokoyxaNMNlt30xAYC4cfuTDuRLgMMWCSG4uwdP21mX4Tz6RheSjnBGJSxzQps4QaHPiEyvcJUgIQuYM0XbX9k7lKTRuG+rwSlK+
 n60O5nyQ
 iuv5c/TVEDRqqd+UzO9t14ACjxW6St7yFBAsJoPyp3fvrfoKqRC07quQhjgB0LC1cFrFLqF3i97AQGkkHTR6QGGS3/i9Tl+rgTYbJs9/ktCwcf/RTE//kfIWonRt75tHDswkXLBPpydq12+eJMlMPkcAm60VkCSUdT6mOhe+QMlHvZYyTgrRNKFei0u+SJtzGGtTWimCIqmqmRc3Hj0eSbgK0l1ds24Roh6HyHltCZe/iWjX9haQkDB5p7URo7PbGIwlGCuRfeLhMBUEYoyXheBG7vdD0eRQ4bn7fLrobj4TxSW8ttAdGZ8fsrDlPbQk0syZwIbPiemoJ3EoPGjYTH10AyhSg4wSzsSiJGCo32CeOfAXvTNl+03uqgXOxZ3v5Zk0fkrSVdVAiqEtBCEL8jI3r1WeJWVE9gEFbd3ml1wUSellQRUeTA7Y0YlTp2nRl83xzTa5sEpEIIASv5P0GzQw5TZDx+XuCXoUKiBKvI3v0iZO7ceWi1sUYmmGz6i/p32xkQ+Vg9jr4u/CYmCKO/o2MQ5qfEYIBKPDEPeqZv7ILlcAzY2ys+uI2L1/62+YLpoiO6L1VVKxVE7z1yPcxurMNMblKoyQnbuPfsEyRLDXTOud1l5QNJQkDcA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

ib_umem_odp_map_dma_and_lock() takes mmap_read_lock() only around
hmm_range_fault(), then retries -EBUSY until HMM_RANGE_DEFAULT_TIMEOUT
expires.

Use hmm_range_fault_unlocked_timeout() instead. The HMM helper now owns
the mmap lock and refreshes range->notifier_seq for its internal retries.
ODP keeps using HMM_RANGE_DEFAULT_TIMEOUT for each HMM fault attempt,
while interval invalidation retries continue to be handled by the existing
outer loop.

ODP still validates the interval notifier sequence while holding umem_mutex
before DMA mapping pages.

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Stanislav Kinsburskii <skinsburskii@gmail.com>
---
 drivers/infiniband/core/umem_odp.c | 18 +++++-------------
 1 file changed, 5 insertions(+), 13 deletions(-)

diff --git a/drivers/infiniband/core/umem_odp.c b/drivers/infiniband/core/umem_odp.c
index 404fa1cc3254..9cc21cd762d9 100644
--- a/drivers/infiniband/core/umem_odp.c
+++ b/drivers/infiniband/core/umem_odp.c
@@ -329,7 +329,7 @@ int ib_umem_odp_map_dma_and_lock(struct ib_umem_odp *umem_odp, u64 user_virt,
 	struct mm_struct *owning_mm = umem_odp->umem.owning_mm;
 	int pfn_index, dma_index, ret = 0, start_idx;
 	unsigned int page_shift, hmm_order, pfn_start_idx;
-	unsigned long num_pfns, current_seq;
+	unsigned long num_pfns;
 	struct hmm_range range = {};
 	unsigned long timeout;
 
@@ -363,26 +363,18 @@ int ib_umem_odp_map_dma_and_lock(struct ib_umem_odp *umem_odp, u64 user_virt,
 	}
 
 	range.hmm_pfns = &(umem_odp->map.pfn_list[pfn_start_idx]);
-	timeout = jiffies + msecs_to_jiffies(HMM_RANGE_DEFAULT_TIMEOUT);
+	timeout = msecs_to_jiffies(HMM_RANGE_DEFAULT_TIMEOUT);
 
 retry:
-	current_seq = range.notifier_seq =
-		mmu_interval_read_begin(&umem_odp->notifier);
-
-	mmap_read_lock(owning_mm);
-	ret = hmm_range_fault(&range);
-	mmap_read_unlock(owning_mm);
-	if (unlikely(ret)) {
-		if (ret == -EBUSY && !time_after(jiffies, timeout))
-			goto retry;
+	ret = hmm_range_fault_unlocked_timeout(&range, timeout);
+	if (unlikely(ret))
 		goto out_put_mm;
-	}
 
 	start_idx = (range.start - ib_umem_start(umem_odp)) >> page_shift;
 	dma_index = start_idx;
 
 	mutex_lock(&umem_odp->umem_mutex);
-	if (mmu_interval_read_retry(&umem_odp->notifier, current_seq)) {
+	if (mmu_interval_read_retry(&umem_odp->notifier, range.notifier_seq)) {
 		mutex_unlock(&umem_odp->umem_mutex);
 		goto retry;
 	}

-- 
2.43.0


