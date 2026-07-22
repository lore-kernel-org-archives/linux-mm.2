Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BC07AC4453A
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 21:45:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D8E686B00BA; Wed, 22 Jul 2026 17:45:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D3F806B00BC; Wed, 22 Jul 2026 17:45:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BDFEF6B00BD; Wed, 22 Jul 2026 17:45:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6BDA96B00BA
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 17:45:02 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DFD9F8026E
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 21:45:01 +0000 (UTC)
X-FDA: 85017743202.11.C81FDCB
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	by imf18.hostedemail.com (Postfix) with ESMTP id DFEA81C000F
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 21:44:59 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=BHaJmWo4;
	spf=pass (imf18.hostedemail.com: domain of skinsburskii@gmail.com designates 209.85.210.179 as permitted sender) smtp.mailfrom=skinsburskii@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784756699;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/3EHZQlaXq9sLmhVgtuP5ODA2wxc36yvs54yemcncOc=;
	b=lLr3kMbtv6yxX1T7vxRCLLrL21DWiBWFhhj69zMhKzgfUbkVlCUAKFS8aXHz1d6tPHagAD
	dAufg/yfRyj2xoJ7cZbg3cq49DiPungh8M4XJMxdnQbe54UOP0vxhLqRVyuVa2fwLkKLHa
	lBgz0T3dcgWhSdKMJXBr359vHlps9CE=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=BHaJmWo4;
	spf=pass (imf18.hostedemail.com: domain of skinsburskii@gmail.com designates 209.85.210.179 as permitted sender) smtp.mailfrom=skinsburskii@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784756699;
	b=f5jwVcUqmQUdvD24Y570bzBL4dSe3Ens/cx/+1hBhk4Irb+9n95j++LsvkAdQpL05dQmTg
	Fmt/KdY6HL0CS03WO/pmA52QiDXb25D2IBScUpZudnEtESFgpxmX0rR7oASvkBR1ocbdrU
	Ajr05t+xcu9JL30UlxJuBmqRWJ7vlZ8=
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-84862b0d5aeso14253822b3a.2
        for <linux-mm@kvack.org>; Wed, 22 Jul 2026 14:44:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784756699; x=1785361499; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=/3EHZQlaXq9sLmhVgtuP5ODA2wxc36yvs54yemcncOc=;
        b=BHaJmWo4nT1elo3/OQExQ6umldepn3Jsntdq4li5BH8Uz0XzS25iU1qLxEsPODdLAQ
         Fld5AvJCmTtJUw7VHFYurEbyfAvYRpZM5KF7wnuXUu2nnZAcRQk/lLwVgX/1+iv3n5o2
         dAXRl/jIbuvBHE7LQ+glRQeFiJrxtcNx/8C14Ef9AZ9S3Pj6p1TgIzzJgtehbyzNug1P
         cn1xKFDE9CUoX8KmQsxlcApsuOIaMt/HkeANU4nu04JA9I3+L7mucwLnOGG8CCJ3F2Vq
         kEXwg/d3xrijUVzG+84o6WVoVxLuKNdHXSE9pcW2C/nCMMaAIAOn98i+XUCIpVLHYxWn
         kvkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784756699; x=1785361499;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=/3EHZQlaXq9sLmhVgtuP5ODA2wxc36yvs54yemcncOc=;
        b=N5VH9h99pPWJFXYaGqZtt40PrW881QolWGWFOSWrRjGlYBAdK1sbHlZjKLGjay+qoT
         ll8/BPAl+Jmzh4xyWJOIu4/JBZjm5X9bzz7nl+Cj8ZA6eGHs0HnXe9C+wByYdULyqYJ1
         MvEhC0e3mdV/O/uglsfN7PBIY2h8yKnxD1HaSk+lziu+OTq0+yni+gWigiplq7qTe7aS
         thh2nWko+KNDxZdkJTT2BxfFfJyB3BMTtytDkLVsbFNO9/S/nsQK/ha/tuCIWN1TOHDy
         eDBUp9jvk3pY8/j72IOYkx0psLaE9A3Y/ddcUoWJKkjNu/ZxxjX9RmDtksgR0fS7evWb
         wamw==
X-Gm-Message-State: AOJu0YzaUajoM5dCOqesWPm0YPlDdOJhJsfmsWnhwb8TlsvsrmXG/KX7
	Buy5c7W+IaTTpqM6MonEyauuLHpzrwmQPCzP8VnywIh0G5NbFoIml9zK
X-Gm-Gg: AR+sD13TkJ3Ll7tcF3rXG4neoNYAwrKt6W/xEkBeH5uiGSIDnSrnerTZ+SpO4mZCZh9
	WqS+BNl8A+8haeN4aWLk+jQpzBiImdAe7NR6p9Sc6w3nHMUimVZ8upJMgX9xHAg/AcT3XrPt03L
	NSFsG5tT0MC+YhJqWUGqmnBc/I7W2lE5cD0GiYUZCfVHyvSxP7HJn3t2nGoSp5mAf5UsWITmr+k
	9QxPZ8wzX12keULs0iwO7BTvprd0BOxaMLM275xEx4RBmKjaf98raTRCggwhNhqx5YqzxDQSUpQ
	XIHEDhx47Ju9hBAMKTHP2N0Jl5vRQdvXshkGGyqmEKuL4IOxvWfqVEqp0yBbUtGi0XlNv7mDR8C
	OLEktdv+qpIL8kcm0G04GoyFpfLdNxkyIx8PNckfVTK8Oz/wcPCvFevarxJSsVTbRhTD3TcmQxI
	EXeuibx+f4BCtsfqDCFTqKBOaZD+4aJArexzobqqayAOUrjGs+
X-Received: by 2002:a05:6a00:2e21:b0:848:5ca1:bae0 with SMTP id d2e1a72fcca58-84e2bb3728fmr677188b3a.42.1784756698735;
        Wed, 22 Jul 2026 14:44:58 -0700 (PDT)
Received: from [192.168.0.160] (c-98-225-44-182.hsd1.wa.comcast.net. [98.225.44.182])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84e17237c3fsm1946297b3a.9.2026.07.22.14.44.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jul 2026 14:44:58 -0700 (PDT)
From: Stanislav Kinsburskii <skinsburskii@gmail.com>
Date: Wed, 22 Jul 2026 14:44:29 -0700
Subject: [PATCH v10 7/8] accel/amdxdna: Use
 hmm_range_fault_unlocked_timeout() for range population
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260722-hmm-v10-v1-7-606464dd601a@gmail.com>
References: <20260722-hmm-v10-v1-0-606464dd601a@gmail.com>
In-Reply-To: <20260722-hmm-v10-v1-0-606464dd601a@gmail.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1784756683; l=2650;
 i=skinsburskii@gmail.com; s=20260722; h=from:subject:message-id;
 bh=Js9Z5fScNTLs9yZDEPq5MMQDWBFdccrrYdkvKMfBR0c=;
 b=OvUAdAx0y7f+AZFnN5LSfteCYnBEUqdMQ1drzLwHbqAw6OKXvHLZibJ29BghZSxMaAsL2Igct
 7dhM0ZwBa4kCtizE7Rk+AH/sCkM9/0Xx1LPVtAK4e1kYz6EQ4qhx7vD
X-Developer-Key: i=skinsburskii@gmail.com; a=ed25519;
 pk=bDpriHBYgeTdkIDweZDCemxsU93neJBOCn3YLIuJpnE=
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: DFEA81C000F
X-Stat-Signature: i6rhgo7es35j7sabfzaqoh9a7xpm3k1r
X-HE-Tag: 1784756699-634396
X-HE-Meta: U2FsdGVkX1/BA0K5W5m+14RcvxotYAbo7yFTUieRdy4s48MfuP2dPo8ykNSjvAEZTtC+kX2ShaunmynJ2y5vCo/+WdtXqbsqUw/uoPoChoTGoE1yyQjoRGwyxxOFOkdB+Q7Zg68usmvWbWksQkF9K82XFZfuArWUjlfekRWstOh7pYOlwm4mwvQ7WnahyjwCa1CUp2MqP7NyreWRmku+7jf9pNmi2ZvP7FM2Q0WG0uxUueopQ0RoDC8r64JwPbUbqNp23DLxK411HuUe38SOSqu3dJe/OXqDI7fMI8aB5kFtrG1ylWTm99Hm9TLt2NDeJNJyl7RQHIuxMbcfOmR6OELU3ogby2yetS1cDyQVexg/TkEpXrsMNEOdDqttbLTADtAr94Rgsl9qnEPbbWLZ2I+zfVkk2JxpFa5xcbURSjWpzJyhbZmHpZSZmIxQWZA5H2JOVKHMeGsMreiAc1NvRjYe9jaadoC19gr91F9SWQjuDzcQoC+PDEjnIbQ1c/1/owvYHTpamMOW9kXJf/QFBmYekBPo+Mx3FhPYx3UK3ICLDXaj98tJv2y4qqo6ktxGIMXb11LddGNXqckCNj9l8/H4TjrSJGz1HLrdrWEIT3vzTO0qcDWvFDPVKBYcyWj2l1HcDi3BA/YVJAnxiO1qg0FBWgCemqOXQxrNNdBCaB1lHlDrNasUIdKWlghmxDmml0gNW0390zGlpXbCqBJ9/v9u3T6d1CWxrHvqr4XNB9C7GSNUdXR7dHoNLnH6mutLd2agTAmjHCB9kF5SZ7MyaxdxxBMJ87wQdYLun8aZULn0h6G72ZWMhswpzh9byCXZgEdbSw2jHUHJPfuNmFbj3q2OmD1TZGcSb944LIjqakVBE7CBzYiR7ietvtlUAZd5GhPvn2TNGr30+mWPYv9WT7OBEL6hnzXPL2jTETZTofOqvjJhTR0XkTE9Ugu1q0+FeArejqqzm8nGvUb+Fkp
 /0PwwJqC
 sonQ0KsJ8O2WAoVVrvQsvYGrROtblKtb9tbAv9QArgLw8sK1XHSvAE/z8BCBMpHf1AgFOh5GWEm8yjNKH+pwAZAAVaIwWGNVResUHVRVE57srgTx35+p+BHhXiCFhaRZDfMH1t1mij4JYvRe2EvsuxKe79R8s2C6iZjWQr1mo+h+IbDEGfnNRJZ0lDg4+I3KiEdDKn7tOgAuFzI0nF/onMRrLqreHUokX+DPFWx1hu77q50JKOHUfnAcxRvMfQwEfZtveL8XCMH7UiOdxYsUv03oHkMfBvwBOsGzuLl2LpV3fWz48K/djpzqj34sYrWs4YQot1VzE26QBIN7RatZn/vywRHUtJKamaLNkSQX8C5PPZ9maIFqiSFONAkoDt+q4CQU7cBCT8R2ny16k9G+Px8SibbcV2YHbgx0TwjG1es9OFGSIkWjh9YkPEcu3Th8Kn/s5Kg4jentJahqugzKmOsET9m/s5sbTJMJ0ezYGWkTL2OxBzvrP7MCZ4xrU1nQPYXVWkE4yJPKi913102C0j3H2k9eSzN4ZGznnzI0YoCneaw7MpaeQpJKGqWYbwntuJnifK7aTRnHhBg7cDF9VSKR03nEx/14p3KLKpXcEV2vrn0E=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

aie2_populate_range() takes mmap_read_lock() only around hmm_range_fault().
It also open-codes the mmu interval sequence setup before each HMM walk and
retries -EBUSY until HMM_RANGE_DEFAULT_TIMEOUT expires.

Use hmm_range_fault_unlocked_timeout() instead. The HMM helper now owns
the mmap lock and refreshes mapp->range.notifier_seq for its internal
retries, so the driver only needs to call the helper and then validate the
sequence before marking the mapping populated.

Pass HMM_RANGE_DEFAULT_TIMEOUT as the helper retry budget for each HMM
population attempt. This scopes the timeout to repeated HMM notifier
retries while preserving the existing outer loop that moves between invalid
mappings and restarts when the interval is invalidated before the driver
updates its mapping state.

Keep returning -ETIME when the HMM retry budget expires, matching the
driver's existing timeout error convention.

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Stanislav Kinsburskii <skinsburskii@gmail.com>
---
 drivers/accel/amdxdna/aie2_ctx.c | 23 ++++-------------------
 1 file changed, 4 insertions(+), 19 deletions(-)

diff --git a/drivers/accel/amdxdna/aie2_ctx.c b/drivers/accel/amdxdna/aie2_ctx.c
index 54486960cbf5..b5b4ca263002 100644
--- a/drivers/accel/amdxdna/aie2_ctx.c
+++ b/drivers/accel/amdxdna/aie2_ctx.c
@@ -1034,7 +1034,7 @@ static int aie2_populate_range(struct amdxdna_gem_obj *abo)
 	bool found;
 	int ret;
 
-	timeout = jiffies + msecs_to_jiffies(HMM_RANGE_DEFAULT_TIMEOUT);
+	timeout = msecs_to_jiffies(HMM_RANGE_DEFAULT_TIMEOUT);
 again:
 	found = false;
 	down_write(&xdna->notifier_lock);
@@ -1061,24 +1061,9 @@ static int aie2_populate_range(struct amdxdna_gem_obj *abo)
 		return -EFAULT;
 	}
 
-	mapp->range.notifier_seq = mmu_interval_read_begin(&mapp->notifier);
-	mmap_read_lock(mm);
-	ret = hmm_range_fault(&mapp->range);
-	mmap_read_unlock(mm);
-	if (ret) {
-		if (time_after(jiffies, timeout)) {
-			ret = -ETIME;
-			goto put_mm;
-		}
-
-		if (ret == -EBUSY) {
-			amdxdna_umap_put(mapp);
-			mmput(mm);
-			goto again;
-		}
-
+	ret = hmm_range_fault_unlocked_timeout(&mapp->range, timeout);
+	if (ret)
 		goto put_mm;
-	}
 
 	down_write(&xdna->notifier_lock);
 	if (mmu_interval_read_retry(&mapp->notifier, mapp->range.notifier_seq)) {
@@ -1096,7 +1081,7 @@ static int aie2_populate_range(struct amdxdna_gem_obj *abo)
 put_mm:
 	amdxdna_umap_put(mapp);
 	mmput(mm);
-	return ret;
+	return ret == -EBUSY ? -ETIME : ret;
 }
 
 int aie2_cmd_submit(struct amdxdna_hwctx *hwctx, struct amdxdna_sched_job *job, u64 *seq)

-- 
2.43.0


