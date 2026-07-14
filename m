Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C7F43C44507
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 20:13:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CD37F6B00A5; Tue, 14 Jul 2026 16:13:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CAA916B00A6; Tue, 14 Jul 2026 16:13:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC1336B00A7; Tue, 14 Jul 2026 16:13:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 953696B00A5
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 16:13:58 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 22A7B14046E
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 20:13:58 +0000 (UTC)
X-FDA: 84988483356.19.90D51FC
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	by imf21.hostedemail.com (Postfix) with ESMTP id 44F4B1C0004
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 20:13:56 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Ntl7D80G;
	spf=pass (imf21.hostedemail.com: domain of skinsburskii@gmail.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=skinsburskii@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784060036;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EUZJ2b06rpE59kyPt/lRc7T/ATHNB4Peeih6JEYSOE8=;
	b=C8L/QS502I0DYJHn7R5LmONDndwgDM/yKXOvGX8UJmR+9R1Yts2TxnZ4tB8XQ5gV8n76qI
	p6v5TKvDy0biGXqWetuBKhSHO1+JdBbgRz+6iYNVzP91Bg+Tkf8ny8SCxYepzdTxdTtU7k
	JYYfzX0Vei0OSQCRSt3LBvV/EbEY5Cw=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Ntl7D80G;
	spf=pass (imf21.hostedemail.com: domain of skinsburskii@gmail.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=skinsburskii@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784060036;
	b=geo/DNymCfqfH/DvAmEDQFxoiu0cCaX+3m4CP1PPd6POqf9dGTEwafqd0WaQCHwYotYMKv
	Hwh8r3DKE9ChLVJJSe/wfODy/8IgrHfEUSjxJh/g8o4rSzaebEbialPoB2plMrYNVDoLbS
	h3JdqbhiBGMEX4cJfKKI0TLimPjzFcs=
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2cac59f8b64so53028285ad.0
        for <linux-mm@kvack.org>; Tue, 14 Jul 2026 13:13:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784060035; x=1784664835; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:user-agent
         :references:in-reply-to:message-id:date:cc:to:from:subject:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=EUZJ2b06rpE59kyPt/lRc7T/ATHNB4Peeih6JEYSOE8=;
        b=Ntl7D80G63AQOxstc7gi7w0gB3UHtowaDyQzcHZ7Rjdd4x93AOdjBrEvf3m9kYPKVy
         gX4oLcBVUVZ+YLAV0nCtyvMAdi4oD+KPr7SMW+dO+ykjZFRCZXw2A4QH01nxDk8w2j4O
         QNOgAvLgxwLZa2qKXp8CVpIz5DH0oPTsRN4biCDnonRoDDO/FtKXp+wBac+UBbMlFMWA
         QjHmDvs9nZ2ON6cBKr0vDv5OMgqTO69jDp87OiMLVDFPYH4zU7FfoFp1LIkhaneL7YOp
         q5lExaPbXIB5W0vHKdNnFcLOUGrzHOwKA28+sgCqeKVVqUdHACUzNlSU0SFjk/ikQftg
         ZbGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784060035; x=1784664835;
        h=content-transfer-encoding:content-type:mime-version:user-agent
         :references:in-reply-to:message-id:date:cc:to:from:subject:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=EUZJ2b06rpE59kyPt/lRc7T/ATHNB4Peeih6JEYSOE8=;
        b=NRajdm9pR3fNjJ1un/s/9IxVstGljyEsdC0I8EbqcbDMEI2zV/Fn4SVnlfk9RiA/+N
         ehoN++OHuUKOquXWSDcDT0sutJFV+S9kYtdtR5o8r5mPwu8awpNJ1LZgsfa9J92TkdEl
         zDxiLtO2Lji2KyeWu76gBnHfpYKPkQA6sAU3kyyNdKyNF6rTIB5mILfJSOEgEXfEH7us
         efH1kUBW1WuqBkVN0aJC0lN2BLfuH3vdIa73hNf8t/Lwlc+Q7tE7WMKk62U73Xoe1Qmf
         p9IRqJTcssXX4QOO9/BmzD27xc2/frfxUVE+GcxQJ8XryX7Kv2JZkSjWD3F7X9WQ95Mx
         lo1A==
X-Forwarded-Encrypted: i=1; AHgh+RquHGyrhAF8S+9qvbgUrlGy8FTEmfYYzNsq4fUmLauJ/0DYw7AbllGHYLZD+0wKCjQJBiF1ytMAxA==@kvack.org
X-Gm-Message-State: AOJu0YxM2KC4+6EPB/kTdQLkAO6fgaH1DGcsd1PVa3HOs1QlOV72DaRx
	Wdx4EwrxXCdhgUAt0tW49oRf7KWwQwttIIFCIgTRwfgeEM35Ct1uiMHbclA9SMVM
X-Gm-Gg: AfdE7ckS4dNxGvSckDayyVju50K7FYJK4R0exPHqDAk3ID+0DjS56tjZ9nNMfl5JgDJ
	H4D+llIt2iQrHEjTEulHtHaP9AxGwFvXqZ+qEMVpvF368MJCrt3pg+5DssY8ekeWpJdkLeAQ1Mn
	tIPNy/R1TTqT6ynOBtgrlVtBSiQSSnbL93xRtwfSzAipnS1zffpFcWJH/2xZMp/O988ZXt+aZI/
	teh912+3N3NreAcetQXAhMqSOgt3s0gSYaSbPmucku+t/t0QM64DWsMOCUZ4ZvLlIn7l4Tj78Pc
	r1ZRNaxDeJ9zoqTKu9QFUEoTpQw79mYYWe4O73YB3kS+/JMImkHvws5cI7IfSO/BwLEmWv5W8Um
	mSmUjGl+3/S4QJjxPtYast2J0DD0dLtKh/HUnUdJnFi2u+vSQySoQ4X+KwC5ZU7JGOwZFu7sW24
	bzGAIVXdroyUSMobzrsRxi0EsuGJ6GkSiE6hmy8uxAUR8zGoMvSOQ+qxhWm/5r3MQJ0UiAqA==
X-Received: by 2002:a17:902:fc8f:b0:2c9:97a8:afe5 with SMTP id d9443c01a7336-2ce9f27e6dbmr139524545ad.40.1784060035193;
        Tue, 14 Jul 2026 13:13:55 -0700 (PDT)
Received: from [192.168.0.160] (c-98-225-44-182.hsd1.wa.comcast.net. [98.225.44.182])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ccc9bdb877sm120937885ad.14.2026.07.14.13.13.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jul 2026 13:13:54 -0700 (PDT)
Subject: [PATCH 4/4] fixup! drm/gpusvm: use hmm_range_fault_unlocked_timeout()
 for range faults
From: Stanislav Kinsburskii <skinsburskii@gmail.com>
To: airlied@gmail.com, akhilesh@ee.iitb.ac.in, akpm@linux-foundation.org,
 corbet@lwn.net, dakr@kernel.org, david@kernel.org, jgg@ziepe.ca,
 kees@kernel.org, leon@kernel.org, liam@infradead.org, lizhi.hou@amd.com,
 ljs@kernel.org, lyude@redhat.com, maarten.lankhorst@linux.intel.com,
 mamin506@gmail.com, mhocko@suse.com, mripard@kernel.org,
 nouveau@lists.freedesktop.org, ogabbay@kernel.org, oleg@redhat.com,
 rppt@kernel.org, shuah@kernel.org, simona@ffwll.ch,
 skhan@linuxfoundation.org, skinsburskii@gmail.com, surenb@google.com,
 tzimmermann@suse.de, vbabka@kernel.org
Cc: dri-devel@lists.freedesktop.org, linux-mm@kvack.org,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-rdma@vger.kernel.org
Date: Tue, 14 Jul 2026 13:13:53 -0700
Message-ID: <178406003318.1082778.16211328573488321338.stgit@skinsburskii>
In-Reply-To: <178405975214.1082778.5193079941156341151.stgit@skinsburskii>
References: <178405975214.1082778.5193079941156341151.stgit@skinsburskii>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 44F4B1C0004
X-Stat-Signature: 1ukqgeesomfqx9ioo1x4cmf76e3bpk74
X-HE-Tag: 1784060036-314905
X-HE-Meta: U2FsdGVkX19cDZk2MzHUMvHpYRnzmrsRU/Eq53I24I7+DqkTZH+wktMK0Xdqv1wLN/xNlnb0E7DrMMYv6l34CpK0ZWtiWBuN9/pifRHnKbhD5NZQ6qJ9zxwnPK0KYnYUxUUBFuIpWdT4KPw/FCYmM6BrkVZGtAHn4wq+8hnmrTtZVZ/IaMaMJQ+Op/DoU5YY7eZBWgGFCbrb2IOeLQYxUlv3zPmhea4G92GGaFLvd1YdSyUHQC9xsmtLTjh+l9x5Ns8iRfZq7iZLlDrgRIyL+YWnuZXx7CQbyGfF/PotIqrSrMxxQ41VVonnN5PsbLDqkspKKwPxV6fY1hN84H5PvQLUswwvfq6lvCpcRDaxykYq8kvxuHEjAb8/z1nA/wzWlEUO1D4kqkNUbpcQ0Y+YJFH2c4CX4hmloK+FDfeC4gPeLxDiswUZPv/NAuG40WbnaXIW6DMZfQ6wKCrmOyLPuz3hLiQNLP1Nmac4WHlY7vcBgikoHPNX+ZfpVSodMO0MsyoqC6uAL7rqt2083EPDVd/1Z0AHRVSVfRTuClAYMXP6JWrCAb7y4Bu23CticFs+AVLngvtNEgFL7kglCIlBuZ5iB45DBsNy0Eeuk43ts3+IMNVCjWuo7rIsHXn+CXjMxK9EkAYhQ7+gZgGNxXxyNVorCl/JXmoY94s2Z+8QFo2pomqh3wYoREdrFXzfbAUDn0xkl+isQkB9hXpWsDH+2vlZwHX2vDmV/pavlSqXbOSDMJjanyP98QW2s4WSrPToiy30eUbtnVqvOZ81/rCbpeo5kl2TmkNajN82XNc4mIzDll5fKutteShpZCfO/dU99FpclQUnn1KnGgHYHhgdY6uSSgy//2fKa8gfLMD8bUhlpMmbVNITtK8polFyklywfBLCA8+B+zmyyMn3zFmiijp7HKe++Bi/KfT+Q6VLVDuszG9SGU1migA4BxdUJPWAgYAh2p3l6+cxw2ajZB8
 iDzwyoil
 vMLLG81lkgpRwjUn+n3HwePiZj+e+BsAosbqFBqI6xp9zSAKoioLkAKCXDuBSv/ZTgvVn0VncRXWvvDSrNNKNSiWTrKUg7mWnuqVJoiMh53oD5rSnTHh0QEL1VUf95HUGJbvk1FLI42iEb0ArSQxV2G1JCM22nvv7I5OqwupdRn9EX2ZBwa/Vbl8zt63rBnPCkMUu+SCZog0AnE3hAUk6gV2L7GTa5jEDPy64syRI5Kzxw55BE7fg4LKwWStJyRnxs5OkQ47pHt5afyDPkkrAIVL0j04feBGkzI8iQ1sqcw5YjZz+7q/Db2wR8sSQHHOo6LabGHI0F1QZWeGiAzobpGHIWk0w0Sh0HxQQtgVNo4AA3VKdt4+euJ9wjy9SrMMeaAp5vUknBJ95NPPHhAj2wqkc9HT41EO1QyxbfvFmnxbNFEjpM5cVOVJjyegdWfiAiCuIQiPQV5KfX1h53g9NOJJfpoEy2qkrGG7ew98Hj8ufZb8QtekFmmqdF6fKhvX21AfPZAqX1TCLPpCA4Xd5UNNQ0GTJiYeRGoeqAbJBIoNjyOLZTb1ZJvbc2A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The timeout passed to hmm_range_fault_unlocked_timeout() is a relative
retry budget for HMM's internal mmu-notifier retry loop. drm_gpusvm was
still keeping an absolute deadline around the outer driver retry logic
and passing the remaining time into HMM.

Pass HMM_RANGE_DEFAULT_TIMEOUT directly to
hmm_range_fault_unlocked_timeout() on each HMM fault attempt instead.
If HMM succeeds but the later drm_gpusvm-side mmu_interval_read_retry()
check observes an invalidation, retry with a fresh HMM retry budget.

This keeps the timeout focused on repeated notifier retries inside HMM,
while avoiding an outer deadline that also accounts unrelated driver-side
work after HMM has made progress.

Signed-off-by: Stanislav Kinsburskii <skinsburskii@gmail.com>
---
 drivers/gpu/drm/drm_gpusvm.c |   21 ++++++---------------
 1 file changed, 6 insertions(+), 15 deletions(-)

diff --git a/drivers/gpu/drm/drm_gpusvm.c b/drivers/gpu/drm/drm_gpusvm.c
index b8f2dd9982f5..76e8a0028c7f 100644
--- a/drivers/gpu/drm/drm_gpusvm.c
+++ b/drivers/gpu/drm/drm_gpusvm.c
@@ -852,8 +852,7 @@ enum drm_gpusvm_scan_result drm_gpusvm_scan_mm(struct drm_gpusvm_range *range,
 		.end = end,
 		.dev_private_owner = dev_private_owner,
 	};
-	unsigned long timeout =
-		jiffies + msecs_to_jiffies(HMM_RANGE_DEFAULT_TIMEOUT);
+	unsigned long timeout = msecs_to_jiffies(HMM_RANGE_DEFAULT_TIMEOUT);
 	enum drm_gpusvm_scan_result state = DRM_GPUSVM_SCAN_UNPOPULATED, new_state;
 	unsigned long *pfns;
 	unsigned long npages = npages_in_range(start, end);
@@ -867,8 +866,7 @@ enum drm_gpusvm_scan_result drm_gpusvm_scan_mm(struct drm_gpusvm_range *range,
 	hmm_range.hmm_pfns = pfns;
 
 retry:
-	err = hmm_range_fault_unlocked_timeout(&hmm_range,
-					       max(timeout - jiffies, 1L));
+	err = hmm_range_fault_unlocked_timeout(&hmm_range, timeout);
 	if (err)
 		goto err_free;
 
@@ -1459,8 +1457,7 @@ int drm_gpusvm_get_pages(struct drm_gpusvm *gpusvm,
 		.dev_private_owner = ctx->device_private_page_owner,
 	};
 	void *zdd;
-	unsigned long timeout =
-		jiffies + msecs_to_jiffies(HMM_RANGE_DEFAULT_TIMEOUT);
+	unsigned long timeout = msecs_to_jiffies(HMM_RANGE_DEFAULT_TIMEOUT);
 	unsigned long i, j;
 	unsigned long npages = npages_in_range(pages_start, pages_end);
 	unsigned long num_dma_mapped;
@@ -1478,9 +1475,6 @@ int drm_gpusvm_get_pages(struct drm_gpusvm *gpusvm,
 		return -EINVAL;
 
 retry:
-	if (time_after(jiffies, timeout))
-		return -EBUSY;
-
 	hmm_range.notifier_seq = mmu_interval_read_begin(notifier);
 	if (drm_gpusvm_pages_valid_unlocked(gpusvm, svm_pages))
 		goto set_seqno;
@@ -1495,8 +1489,7 @@ int drm_gpusvm_get_pages(struct drm_gpusvm *gpusvm,
 	}
 
 	hmm_range.hmm_pfns = pfns;
-	err = hmm_range_fault_unlocked_timeout(&hmm_range,
-				max_t(long, timeout - jiffies, 1));
+	err = hmm_range_fault_unlocked_timeout(&hmm_range, timeout);
 	mmput(mm);
 	if (err)
 		goto err_free;
@@ -1718,8 +1711,7 @@ int drm_gpusvm_range_evict(struct drm_gpusvm *gpusvm,
 		.end = drm_gpusvm_range_end(range),
 		.dev_private_owner = NULL,
 	};
-	unsigned long timeout =
-		jiffies + msecs_to_jiffies(HMM_RANGE_DEFAULT_TIMEOUT);
+	unsigned long timeout = msecs_to_jiffies(HMM_RANGE_DEFAULT_TIMEOUT);
 	unsigned long *pfns;
 	unsigned long npages = npages_in_range(drm_gpusvm_range_start(range),
 					       drm_gpusvm_range_end(range));
@@ -1734,8 +1726,7 @@ int drm_gpusvm_range_evict(struct drm_gpusvm *gpusvm,
 		return -ENOMEM;
 
 	hmm_range.hmm_pfns = pfns;
-	err = hmm_range_fault_unlocked_timeout(&hmm_range,
-				max_t(long, timeout - jiffies, 1));
+	err = hmm_range_fault_unlocked_timeout(&hmm_range, timeout);
 
 	kvfree(pfns);
 	mmput(mm);



