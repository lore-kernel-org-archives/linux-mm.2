Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B5AC6C44501
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 21:27:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CF4886B00DF; Fri, 10 Jul 2026 17:27:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C57766B00E1; Fri, 10 Jul 2026 17:27:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B46776B00E2; Fri, 10 Jul 2026 17:27:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 87FCD6B00DF
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 17:27:26 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 18D43A0168
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 21:27:26 +0000 (UTC)
X-FDA: 84974153292.21.CB45438
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	by imf30.hostedemail.com (Postfix) with ESMTP id 39FFF80005
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 21:27:24 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=KgZcCGyi;
	spf=pass (imf30.hostedemail.com: domain of skinsburskii@gmail.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=skinsburskii@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783718844;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9/L8xh2nQ4nR7e9MheG1BnxPJ3sCm51YBcPVud12DY4=;
	b=AUYRBrjL9lCvCl8a0c5hHsJTrxzgF5Zs9p/3lOGgBrmN4+HOGrzEPhEYMhl8/aaqU1wn4+
	4HnqhMZ760rUCgmpiMSOqFeuTWHKvhADsR1DU/YdROgcgoWPvPXPVR2u4+jW0CEvpaA0OZ
	AyIGMjnC01Pw8TAm31yUU589rzt1J/E=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=KgZcCGyi;
	spf=pass (imf30.hostedemail.com: domain of skinsburskii@gmail.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=skinsburskii@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783718844;
	b=IE8TVHvcg3dPQfTIxFa3Y8jlxAJKl1WdOT+Mi8kkPGqam8tI6TaIPrjK77yBXHAFM23q+c
	HYDTbERyzPKnZ7w6TPLi+rRyLZ6GhGevv4leTWTRojYupBCQapzRC3eCoTXfg9ekuLb6aQ
	kx3Yev41tKkgscc2uqmNFQUgcWM171g=
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2c7c61b5292so23797325ad.0
        for <linux-mm@kvack.org>; Fri, 10 Jul 2026 14:27:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783718843; x=1784323643; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:user-agent
         :references:in-reply-to:message-id:date:cc:to:from:subject:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=9/L8xh2nQ4nR7e9MheG1BnxPJ3sCm51YBcPVud12DY4=;
        b=KgZcCGyicGO1vOxl3DHMx8FMFNPbOYzNtqoKOi8SZvGHJE0GrUVZuZ/7UmG4joWh99
         0IVNcmvnpBsjDkPu83MHHrWxnQyPeaFpjojCKpIux1GaWG1LJlAx0SMeH7CbnujWHThR
         E14tBht36duss2MLLkRY8Wg1lMb3oanlxvefDlFPnf4xX476AdHIYIpMYtg9QM5rhVI5
         Bf+RZmUQ0mUHDcT51wAPQdYC/i4uo9fT1M2d4hmtzTJmryJZ8dypDSXBGviC9hGAzqmi
         aMwhsPccKOzgOfgHzI9DPLnOT+pR52eNJuc7a1Nr1f7nZwSSMgnR8loJQzumUyiI2+LV
         1g9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783718843; x=1784323643;
        h=content-transfer-encoding:content-type:mime-version:user-agent
         :references:in-reply-to:message-id:date:cc:to:from:subject:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=9/L8xh2nQ4nR7e9MheG1BnxPJ3sCm51YBcPVud12DY4=;
        b=g8zYDIFC+Z9L4dWMQQZScN0gPMKZBlecsQu2+Ygg16reaSMMdU6WT143E8ErZ4+Y7n
         YhdpnrK29QC8vLHg6pwv/MgNfGo/p4Wv0VlHVjNqYjc6VBtKJ6fP7RTPbw2WiEphNZyZ
         2R+/kxd0SJYTDokjPKeYYREFVmIBp6kpEw/l1mu3aXCUQ0tLxOg5EncFErCaQc6l5wZl
         0yFkFTCmKu/XLUCG6cw5LdUjD9dKEMxR86zsQlMG0Dpw+xlLRcVXD5L2RbesvcjF1VpT
         5W9WtUhOSDPfFpkCDjhLTdBLR0nDD4nCwFY3HVmO1sPNZ7GbGBttts33b2YxE7CGLsl8
         FZ0Q==
X-Forwarded-Encrypted: i=1; AHgh+RoU9/3JNkbXb5edrVGGC6iPEByF4loYJbB4LOQOFx/ixWuESeeB6Jd1XOoE917sauSoeeTi/RSL0Q==@kvack.org
X-Gm-Message-State: AOJu0Yxcm1c2PUh706BpC9olu9OYO3ce/yqLm5kVNHtRo1oMjHvUoOl1
	kAJFfAbKZitgCnopAFuJqDMeYeAF5XjBua4oGFGy6idTthmf+v8LeacJ
X-Gm-Gg: AfdE7clmZuTPdqxjNvy7CLGff9bop4ubddwVDMhH1oc6zCNy/dDFkfpx7EjZPLX33wf
	ZtBx2zChkkXipg9k4t8nNc5u7IQWpIEjnTq4CsqoYMn6xpoyv24KCRBCXpybQoTIafSUVur4rmX
	TMYHAQNSCHfFWhDJtFkDN1rhk9pSLJ6Nd3ueI0PaCkHxuJivmHbSArfagKLnO3wP4jy0CzcP+8F
	taBaz2EzZnMRrwmZZvYWaILA4KnqO5fTAb6qJv1x8ajSKzUpJ2rRxo8Pp4fKI+bycq5igB0H8Cd
	Egqc5TK27mvVmDC0xc9BFYoJjUDLIHx+dk3Q13VtQ2XyTABqkfAd6EMG//RgeCadNOs3u83TR5t
	xT+bl0qB/g33J4ZzQKo0zZtW74c3QBFv75CQAEXP6PTX75QPkUlXRktVKydjn3NSUNJtP501wYA
	rlANlHY4gau+tCpWUjMmUttIjMBLyknyXPWh601qeFqXwahEtlm1ngr5MPi8k=
X-Received: by 2002:a17:903:2b0d:b0:2ca:11af:5ee9 with SMTP id d9443c01a7336-2ce9ec0f0b4mr7098515ad.25.1783718843116;
        Fri, 10 Jul 2026 14:27:23 -0700 (PDT)
Received: from [192.168.0.160] (c-98-225-44-182.hsd1.wa.comcast.net. [98.225.44.182])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ccc9bf77e4sm65443035ad.22.2026.07.10.14.27.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jul 2026 14:27:22 -0700 (PDT)
Subject: [PATCH v8 8/8] drm/gpusvm: Use hmm_range_fault_unlocked_timeout() for
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
Date: Fri, 10 Jul 2026 14:27:19 -0700
Message-ID: <178371883977.900500.2198446134676328631.stgit@skinsburskii>
In-Reply-To: <178371866223.900500.12312667138651735591.stgit@skinsburskii>
References: <178371866223.900500.12312667138651735591.stgit@skinsburskii>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 39FFF80005
X-Stat-Signature: 8bc6t84t3fiipp68sxo7w1xqe1jjk73k
X-HE-Tag: 1783718844-192233
X-HE-Meta: U2FsdGVkX18bWRqAi/Gk7N0SiAdPU80l+fed2Nb8XHFIgOJTgOmEvoe+XlW9VpihJN2Jsmw09v4+beCgUfc9FwV95Wa/VvzbmoBhtZK8O6SAPFHn+PbNfCg1CRxuY22HE+Mt4JA7TLpWyRC5My6LEEjybsdWtPLWn66R+Y933NCOgyyqdA/OmZjCUl1+5FOdm9uJSvBUYMdhk82UwaScMNjp8uhsMC3QPH95lgu/nenaztTJT2wFSrRk2ISqxGkjXCQ52KoPQTaVeQ2BHkEqFSXhwNM3APmh0FGn5CvsGN5dDXkoRVgJw7KQYrwOsTBLxPUuFbl7FBGq/QKq2sp/7fue8B2NcZzFSwkNQ6hrplqMXSDiTxsDewa/rKfi/+f8tzRLrSWbIX6W72QWbS8pBIQK2HVtoLqYEES0tlRt+ggH1fnL1B6YXHTiHxtOwXfDuDr8T9UuwYr5ZJJIh0TMKUn/A4scJlF2l1N9BBC2KDxjcd2YswiJAmX6RrgoNmJtk8OEkNvU1Mu1X2xbjNoGW+ZsnUaiSniHDhjL5eH4CpDsyzDZOn7zJJspzp6hiNRFw9+oFkFp09IjNqOtMRItitpPYY8Xb0FrhbCkoM5o+qUeMtzLuC0QcNuFsnLZqIqA2j/Chc8NNAdycu+X2LC14EYtQ7sGBy+n6XG8mISMV9hKH6ytXDHEcGeFuiFd5HuL69QeR85WaLbGswWXNxwS7jex6YvtZyu7cFpMmfIlqWWMcW8KxEGPB9lP+HwGiXN4kcCFT0+PLNVNqV1DNLIOZTjZkLvgN9l6yv7iNbG3a/vxchGtj92NGS7WYSJRfwON+5aNE7FxG+JR+eQAyqQwcEKTEZOZ2tXBTbdPHfph9dEbhJWLUBpLNAAdcrhXccSLZyKLI6R+ivQhzwGuuRFypz4MyQCdv2Cs1tmr+zyXhVGKEkTGaA5hRrpdHlcjUwCfFp5SM8D4jfb45dhbDo8
 +yfiTgDp
 hXm9cjctzEUTCa32XFZGp5Ss5sfFkqawsJQGAvYAnG5NMlxH28MjPTPTeBxGizoybba2v+NPrKTpqyuJ9dmkKVrQDxe2iyi1LpMjyr4NrvWINb663pNT2Pn73Iw3sFnunqM67R9gYTZgcbkOiB8z/AEnjOOLa5Wdg3VLLfkpx5veJm7iwhH7Fclh7ZW7qhUUwd48D3KKWSl+2YrIi5D4C/xyYxcbjAKx1iWNQjktkhsMphDKR9Z4KU8eWB8X13OcsCv077OB8z+cVu8jVBTWyhk9HLDAAOXIz5tNFjUhPJuJKDCxoRmjQc2uFt7Av7HOn3yH8wTvICUYS+HtEdnA6lcnzgkTdYiM45q/PurQe0+TflJONi6xMP/nY+M4fHRl/x9gzYJy4aFX7AuxdF50ZjnC8PhIRYdsFey0WUWjkLPX751UhEqAKs7ATVxLtKgmfeJlywGzHitVDpPMUbPLo3SzSfQ5ezZMGoYNME6C/bwHBuFMImGhL2EwsTyWAVErdK6og+hRtUGo2+Jr0hukBKXwlucSgjCwGOKvh2vDdx7p1V7PnW2OJBeRGdE+X5CDWFrz3oT+DBkxCIDo=
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
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/gpu/drm/drm_gpusvm.c |   52 ++++++------------------------------------
 1 file changed, 7 insertions(+), 45 deletions(-)

diff --git a/drivers/gpu/drm/drm_gpusvm.c b/drivers/gpu/drm/drm_gpusvm.c
index 958cb605aedd..6b7a6eaebcd9 100644
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
+					       max(timeout - jiffies, 1L));
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
 



