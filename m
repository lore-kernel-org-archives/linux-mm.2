Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 71CE5C43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 17:55:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 541856B00BD; Mon,  6 Jul 2026 13:55:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F2036B00BE; Mon,  6 Jul 2026 13:55:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 42FF56B00BF; Mon,  6 Jul 2026 13:55:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 05B356B00BD
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 13:55:27 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 81FEA1401B8
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 17:55:27 +0000 (UTC)
X-FDA: 84959103894.17.AB06919
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	by imf23.hostedemail.com (Postfix) with ESMTP id 9CBC014000B
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 17:55:25 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=DwLN1eBq;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf23.hostedemail.com: domain of skinsburskii@gmail.com designates 209.85.210.181 as permitted sender) smtp.mailfrom=skinsburskii@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783360525;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gda9EnNaq+fnHp+pBJqOcXDPF8q5yM+z5/crGMT/FCk=;
	b=D1stnbbFlFLHMenHfihR93t0LYpdksSE4I80ELxJmWouMjf2fwlq2Pk8EQWF+XIYUh6TWf
	qe+XRjOVd1zM9PAHobKmH6gQmqqK87W+YS8EHanH4sdVdxuObNnEo+8qE1Tp6EbQtiqx9i
	VkIrpBShPcB0C5H3o7RFH7HsqGGXaAo=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=DwLN1eBq;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf23.hostedemail.com: domain of skinsburskii@gmail.com designates 209.85.210.181 as permitted sender) smtp.mailfrom=skinsburskii@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783360525;
	b=LZw/NOrVJ9FTUcGQsXAbDpOqDnj/xbZ64eD+UbcZGwOhyyQdlVw+UvzTnMEBYK6++OlqMH
	nsyl0ChLYoMAiIk4uR1OUxWUhRccNExgK3A+dNX3/Ed2R9guqRkkwXqBB+AwX9UfowpKLk
	fvxMthjIvzXuMX+azqLncrLeoCfkC1o=
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-84592b55832so3256831b3a.3
        for <linux-mm@kvack.org>; Mon, 06 Jul 2026 10:55:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783360524; x=1783965324; darn=kvack.org;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:message-id:date:cc:to:from:subject:from:to:cc:subject
         :date:message-id:reply-to;
        bh=gda9EnNaq+fnHp+pBJqOcXDPF8q5yM+z5/crGMT/FCk=;
        b=DwLN1eBqMnUCT8WxV8iR5ppX6UR6byl2E+Qdj+/oTKZrysOJrLb0iNbV1unOOz72rR
         mPBPYlTKBFeD78N1WyxWx6ZZug0K+z34R0sHLMysK+1z53tRJ1rGsPgnjJ+Wd+S6Ik+T
         l61FaUOui2hfCgftny1wPGVYSfrDztRGK3k7kq7bqEmRmtQgPEvgaLENeruWAYySqmM9
         jfMNQy/twhBITDQdqJe4e+pvMlv0g4s2aULewle4soyB4Bk87u+s1JPY8zn8hIDW8BJu
         L4mdpImlZpjag7Lh8Qwxfcp6u9stVly413q7osISx2lDgzaAkdtEIcK9EYzwfkAhzzq0
         OWQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783360524; x=1783965324;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:message-id:date:cc:to:from:subject:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gda9EnNaq+fnHp+pBJqOcXDPF8q5yM+z5/crGMT/FCk=;
        b=DUYXHKl3rmHciuaSGKll1MtHy0441gTpGdUf8AKAqq7bcEtK4e4NsB0IhXDpelAV87
         sY6pTGTh1wPNldahV6GazPeRJ84Zg8IFhVwJzPzjW65CrJ3Gi3IgMC30Lbo57gaB9OiX
         NppzJg1iRJw9f2sfybKSmopYtudBP/S+iTcV/tlvo9LgimItWADoIaEFjfVUuJU2uz40
         I8wcUa+Xs1VOGHKZfZbG0HoWR8qE9NkO15C3uaz1Q3Zogj13kOUuBjRQ7rmc9H+KpqeM
         7ov6ZOmdOs4yuwE4FCH9XLP20n7Gn5WaP0FDzuh8epZYUU2jJ2mK5fsdN057ynd+0ysB
         YF+g==
X-Forwarded-Encrypted: i=1; AHgh+RoYeDhyG76LC2Nfjde+r1jfQuefa9XM6UKkiDePc1NBOstcezgdcJeAykBSEXVmx36jY2za4KElmQ==@kvack.org
X-Gm-Message-State: AOJu0Yx5QCEgi+JxyRjFLBb7JruoQxvcprXRQSaQUEoxgIQjEyrRt0PP
	QmxyygZEGs7GI0IN8lJAJJcph0NnbYQJ7ybwhhpl/f7DcMJnT0nWwzxg
X-Gm-Gg: AfdE7cmREfI3038muY8wprVwmnMNjH6gQioVQzOOqtN+vxxWK9OrsH5IKMPBLaoASUp
	K+9bXNKaWPrEqkgVfmGcMv0jPiBPakLqOnOLvfOaKdjXRuvenb7ZHvU1nJj613Pt+yHXbaMNtQN
	pjEgdrUxpFVCzdctYZwonb9HV3mK+7dFpWgED2eak2MyHiNwEZ1J4q0dFL8WRZECarBMdIstQTU
	qd5T13DKqbXc3uHmOzWXH2dbovd/WkSDveMTkaArnYZVn0gqX76hMNCdPNRCReyyR8bJxurTT7P
	GmmlwYLuNIgXXECk8BGU1xAKD/WIeEbIoWh9HC3H9ZgFZJLfstmx8F9EQBW6m+xkjE62CThREDC
	c9CBBLQJERP142r8qsJiJ7SZxfDoWUyzE/nBCTKlt1+94HnqR/T+gHy+xmid3bq0f5dEI5wQjBq
	8fZEcn7b6miqzx4rTOcHNvBI1QYphnNTvjqikRDx9IIlE4GSWCA3H1vVNMILw=
X-Received: by 2002:a05:6a00:2a08:b0:847:7ece:3426 with SMTP id d2e1a72fcca58-84826da830amr1487737b3a.58.1783360524459;
        Mon, 06 Jul 2026 10:55:24 -0700 (PDT)
Received: from [192.168.0.160] (c-98-225-44-182.hsd1.wa.comcast.net. [98.225.44.182])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-847f6b95c89sm4375268b3a.15.2026.07.06.10.55.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jul 2026 10:55:23 -0700 (PDT)
Subject: [PATCH v6 4/4] mshv: Use hmm_range_fault_unlocked() for region faults
From: Stanislav Kinsburskii <skinsburskii@gmail.com>
To: Liam.Howlett@oracle.com, akpm@linux-foundation.org,
 akpm@linux-foundation.org, david@kernel.org, jgg@ziepe.ca, corbet@lwn.net,
 leon@kernel.org, ljs@kernel.org, mhocko@suse.com, rppt@kernel.org,
 shuah@kernel.org, skhan@linuxfoundation.org, surenb@google.com,
 vbabka@kernel.org, skinsburskii@gmail.com, kys@microsoft.com,
 haiyangz@microsoft.com, wei.liu@kernel.org, decui@microsoft.com,
 longli@microsoft.com
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-mm@kvack.org, linux-hyperv@vger.kernel.org
Date: Mon, 06 Jul 2026 10:55:21 -0700
Message-ID: <178336052192.504354.1841795575701703197.stgit@skinsburskii>
In-Reply-To: <178336023903.504354.7500950448226027718.stgit@skinsburskii>
References: <178336023903.504354.7500950448226027718.stgit@skinsburskii>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 9CBC014000B
X-Stat-Signature: bz7gwpgho31sftyfr4oktijnh5emcwi3
X-HE-Tag: 1783360525-938851
X-HE-Meta: U2FsdGVkX1+whwMoGg54zS5S4DDX/FXKZo8K1hCVKguF7272tTs6FWo3Rcwm3mowuUFWnkpAcUI6Oy7fCtmijaYc3lvCC2vqVotAkgbQVNSkzPY2Et5iEg/H2jywrm8CPjL+hzXHJqr7281n1GNkvd1p0MpkMoRWnoPT91rhXSEVWnL0WHwHRQ3mWYCXf3G0tDo3oBvl9taTwp0UR2FWMy8oFhQ6WzPu8qem5X5G4BOlLG+lW62MV/ps92xLrSWLq+pWOah0CQ5xQcVB220pxwIQ3LRpQNh+kqk9S9B5pwfbCOKYv3wiNpuOWDsJQDWeqa7y6aEhQPBOCuEuk7balTE2GxY572ds2Mt8nHs+r3hKy46m1d5G5XcfN+lOAEEOPQ1Y9zkgjIPed/di5MqiBzjDyUXokfv8O7VFwLu8KkwfSkIzTiVFmsUn3ddxcSwaDL/qNZOylKu2ypzNmjs8gGg6rZFTAFcRo9C/+on2pRV2pxtxrDGqXD4lHmW6sB8i3YZAOvCftz5F/x7wje6wiFX9RILxW5+iSRWla76Go++0ZA1o0Cll+uBxg8XVKDJt+mwm2rvrGnLgY1QjxGjvj06Ly+YFpex6yN8oiuFN9etkc77TFOXPQ92m4yhwCwhvjt4SDsiOiezrWHKMulKkuD5HHXOjp4SNcO5nULB6bxC9koOVDuMf58z6zVxUt2FiT7FIS8MdOOb8NIsLJuIzOIp8KwxNHdKSt8MhV+hMfphEyFQPr+QFR65b4dIu8mf82jO/dxAvv/Joshl/Q+88pW+Z77FiDdrDWOs2KzXWz3Ex7OaH5cvNUgB+Lfrnq+111JuXTrd8zH7QCxwLLzWFUUyVcn67IvpYLA1Mv/cdrKTLVuYpEn70+RensSJplfD6RYGRrqqCMPjuteXIFNSSLcHp7AJk8bhPlZJmuVO+TQ2fqd4ziOQZmQbyzEthMoZPHKoebte6fBWRw0loOzs
 u8Mm5dkG
 6PYFBhoSvhiBgHjtU6sxX8JELCoYkIj52QwFSttIZ+iUyf4b41jF7DYmMJ9HfLRuloI//Z6xRUsVJhf8Rn8KNpMlY7Tk15a75v8C+nCkIXJ7R/vlpTRnPTQAaFxh/rCsRn0wFPU+W8DbthTjTgRG7xLcfUByVFPX2psxidUVMiytb0DOdIOl6/ioeLCdevG+x3dz2s7X1QxOFm2x97cafyJe+yaWrAOzXx+9KHV45kQICI3WQMmNpcLByIGQ3gfUngNM4E7GG9FvmvbOfkgdx/Tf0lD+uJTvfOXcWyGLMIM3Eh0wTQSy2x41SikCYlZ3rBCv3VFI1tVJ9ameEFioKfrNUPlTBCJvTZv+nxbj/Ijt6VetEPO0FETVBzwXXGxfzaj4Im2DzHedhsXPKyaOcXm4jOehZkiF1M/DZDfobt5EGD5+KxpUCF0PRaD3T8JGwGuYYSp659oQQRILggaT9y7/DBNnN3uXNMPN6A+ypQkREZ74B57x3uwnms6CTsuC574AnaADlw8vOq/axiO6HS2hdrhOwu7DMpq2E4iU6Qh335w/L7g8pEbWYZR0dCLmKk3GYWyvknqSwm+XPaLeKfLqOvQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Convert mshv_region_hmm_fault_and_lock() to use
hmm_range_fault_unlocked() instead of taking mmap_read_lock() around
hmm_range_fault() directly.

This lets the HMM helper own the mmap read lock and allows the MSHV fault
path to handle mappings whose fault handlers may drop mmap_lock, including
userfaultfd-backed VMAs. The existing caller already retries on -EBUSY
after refreshing the mmu_interval_notifier sequence, so no control flow
change is needed beyond using the unlocked helper.

Signed-off-by: Stanislav Kinsburskii <skinsburskii@gmail.com>
---
 drivers/hv/mshv_regions.c |   14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff --git a/drivers/hv/mshv_regions.c b/drivers/hv/mshv_regions.c
index 6d65e5b42152..04676f06c5c7 100644
--- a/drivers/hv/mshv_regions.c
+++ b/drivers/hv/mshv_regions.c
@@ -388,13 +388,11 @@ int mshv_region_get(struct mshv_mem_region *region)
  *
  * This function performs the following steps:
  * 1. Reads the notifier sequence for the HMM range.
- * 2. Acquires a read lock on the memory map.
- * 3. Handles HMM faults for the specified range.
- * 4. Releases the read lock on the memory map.
- * 5. If successful, locks the memory region mutex.
- * 6. Verifies if the notifier sequence has changed during the operation.
+ * 2. Handles HMM faults for the specified range.
+ * 3. If successful, locks the memory region mutex.
+ * 4. Verifies if the notifier sequence has changed during the operation.
  *    If it has, releases the mutex and returns -EBUSY to match with
- *    hmm_range_fault() return code for repeating.
+ *    hmm_range_fault_unlocked() so the caller retries the range fault.
  *
  * Return: 0 on success, a negative error code otherwise.
  */
@@ -404,9 +402,7 @@ static int mshv_region_hmm_fault_and_lock(struct mshv_mem_region *region,
 	int ret;
 
 	range->notifier_seq = mmu_interval_read_begin(range->notifier);
-	mmap_read_lock(region->mreg_mni.mm);
-	ret = hmm_range_fault(range);
-	mmap_read_unlock(region->mreg_mni.mm);
+	ret = hmm_range_fault_unlocked(range);
 	if (ret)
 		return ret;
 



