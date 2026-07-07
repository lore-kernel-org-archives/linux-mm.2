Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6306CC43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 23:51:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F335A6B009F; Tue,  7 Jul 2026 19:51:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F0A906B00A0; Tue,  7 Jul 2026 19:51:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E479D6B00A1; Tue,  7 Jul 2026 19:51:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B8F346B009F
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 19:51:47 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2AD8B168F14
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 23:51:47 +0000 (UTC)
X-FDA: 84963630654.06.C0ACDB1
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	by imf30.hostedemail.com (Postfix) with ESMTP id 6623B80003
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 23:51:45 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=hZlFI5ZY;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf30.hostedemail.com: domain of thehajime@gmail.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=thehajime@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783468305;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=xg1plK6yIX0LTs5KrUD1h414rIIh4WSWs4+c6LLldXs=;
	b=KXkMUnChGhr4C0gBv8neMBqQsf60U+pt0M4mUn0SYl8lst78geuJ+bA7aTxtqVWjDzDCNI
	abPEVG9hvijh3kfJoQB6Zd0QsbcDmJw8HArxwTZ+0SI/eTbIT8nlFPmwhlpSPLEyjYxIbS
	AqiauWckOk8Ug+L9urqOEagoHDjLP6c=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=hZlFI5ZY;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf30.hostedemail.com: domain of thehajime@gmail.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=thehajime@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783468305;
	b=KHAc0hx+H4Bk7OSMQxyEUCubSb3pO0osAEPy7lA0H+ueoPw/4SFZiIAe3M2oTOLccIJIPp
	qnx+RdodaDbX+6f8+xvKMywUkW4X4jRL9p9XiNAsZwpKEJZVe0HxWuP1RU1QTRPNkzpTRq
	hKK21KowhBYHAuR3DC9HFT+939VZSB8=
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2c7c61b5292so2566875ad.0
        for <linux-mm@kvack.org>; Tue, 07 Jul 2026 16:51:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783468304; x=1784073104; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=xg1plK6yIX0LTs5KrUD1h414rIIh4WSWs4+c6LLldXs=;
        b=hZlFI5ZYeFf10lBO7UBY3kn23X+s15EocWYss3UVBlN/lhv/J/TWw9OlX2yu2Q8RJT
         /J/n7wHi6rnphovddwDGwUSXfPJJdoiHYpOoFliCddgzgdX7vAGkyY6AUKI4v8meATsQ
         bpiufY6UTPMxBfIaW24WUUrYVuSqgaAv3Ieq9SBGmdC/RE3p4AmjJIbrKa54tZii6ATV
         CiESwg6hkNX9bskzCRjoLp0A98Y3ZwMNEUWybw0MIzNvigLbtz7hRDo/HdC+4ZJEFva/
         PC0sA0WYKcrYoPhBdAUmSIQY3QF7Q4COomtNqZEmVJl7OtI2Lnm2enBBDAloiV+93PP9
         O0zA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783468304; x=1784073104;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=xg1plK6yIX0LTs5KrUD1h414rIIh4WSWs4+c6LLldXs=;
        b=MeTqCikCurGKSX57poeIjTUqMnBIHhb7U9XoS4gX2PINMpxLCmTBWs9kmoIjDA+m1j
         xy0HbbSmD92j3sbnlr5HE/CjvjayFC0CnaqflINcJcJb1ADQAzyWRXZNScAr3Kcjl6Ve
         vGhWc5+FuB6mRL8KXPktB7ycjhvcO6cpDAJH1lbsaUcg5FLcKey3NtN6no97kcM6ikjO
         cl6zyEOmO9qpzi6HrZTOg8IMg9+UYrH01sllW98qLSu+TtGYkyLnPO6w+Qw0XFvnlzKn
         c13Ch/+vKrlSUCoM7BDpM66bh9eJlRZwwHdHUajZS5h1WgMCN6zANJyn1qaOzv3Vp2A4
         aP1A==
X-Forwarded-Encrypted: i=1; AHgh+RrroesZGSbW3MVhQuK9UC61BQnhMthdItbX5badU6kEuVPF4bKNtDhKk/TBrEz4cd0vFr06FIArdQ==@kvack.org
X-Gm-Message-State: AOJu0YxiauS9MpsYqdfk9HJ4lXMY0b9Rm7YYu/TOZI1EaNKFfWbzaldK
	ebr73YdnV/O6Bl7/+FEgZRqIRVds/Iica8ctun4OyFK0SI3Zj331L6en
X-Gm-Gg: AfdE7clZTzKLB8ZOMiefk6hJlC55Otg2UdR08hc7AfCkhdeQd5sj3Xp+Dq3hrtATddD
	bl17y6TE9xlkIbe6i2U+mV+BufLnoY1FX6Tl2rUy2WZU8Xu2OJwfi/pqHUaVR5qS/A8AESMq2/v
	YQhQfHuk5F3Dqg/UIjb9rQzNfpEs3Llx/JVXVtb+Db+DDfTj8evkkaprS6YLOf1+zVIX530jHj2
	IJ78jIdcXRX7olwDjoptmhvSduN0d5GB6nFBMyCCF3hjuF3bSzjYmxsvtJdAXKoNjrRvNiE2eJr
	u8wHEJGzh4+hLdSsYG+rGpBa4PNOYPcj1YvLzrJQrSN5APLSfa2/3fMeXNDDLIpunRR1Vre3xAU
	Yf3k3u41B6ZGFIMYxiOSP7AjqivIzuApGAnkgx8PZxIjv2v6oP59Yf5KP8j3mNAxLWor8Vpp39D
	ZQ4crmrxwZbMP2kGq9bIAWO8trnKlCBqK6gGsDx0+Uiob5yxJqHQdfFMj6yVk1d66CZG3Jps2rt
	DWNSFomGKcTIccwPA==
X-Received: by 2002:a17:902:e84c:b0:2cb:3f63:7c3e with SMTP id d9443c01a7336-2ccea36aec5mr1391525ad.35.1783468304300;
        Tue, 07 Jul 2026 16:51:44 -0700 (PDT)
Received: from ikb-h07-29-noble.in.iijlab.net ([202.214.97.5])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ccc9bdb9a3sm18882265ad.13.2026.07.07.16.51.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jul 2026 16:51:43 -0700 (PDT)
Received: by ikb-h07-29-noble.in.iijlab.net (Postfix, from userid 1010)
	id A319E148F31C; Wed,  8 Jul 2026 08:51:42 +0900 (JST)
From: Hajime Tazaki <thehajime@gmail.com>
To: akpm@linux-foundation.org,
	liam@infradead.org,
	ljs@kernel.org,
	vbabka@kernel.org,
	jannh@google.com,
	pfalcato@suse.de,
	linux-mm@kvack.org,
	geert@linux-m68k.org
Cc: linux-kernel@vger.kernel.org,
	Hajime Tazaki <thehajime@gmail.com>
Subject: [PATCH 1/2] mm: nommu: fix the error path when vma_iter_prealloc() fails
Date: Wed,  8 Jul 2026 08:51:36 +0900
Message-ID: <20260707235137.498738-1-thehajime@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 6623B80003
X-Stat-Signature: 413ewghghzozcigbjw69aktppygccgmm
X-HE-Tag: 1783468305-382717
X-HE-Meta: U2FsdGVkX1+rZssLTzSRLxir6qwPR4w50QArCdARYu/6gX3jC7DkIjDkCH0AgLB8t2gadqK9hVF+R5mFMB+pUopXNItSuWV34ZmC3SdaeqtP82NTPGVHjD+Li77EkkMh62GZgjTu+y9stPcFTTMLxRaQtQgFbPiUuqAFq1rq3YoxvAwGNo2EBD4/Rkx5JC3FtnbYZY6uFfEJurquEOJPcYhPQ/v6kWEzeY7NuwPcuE2kf0pvNnHnX5JEkXI3jLjucjy7xZuKqNDlA7VbJ8Pd5XvvuIo6a0QS7Yu5QdUq1U4uJardiDlhxg+2uXsLtbqErR3C9rq43SC2k2x9pIRySImLJWTeh4pVlEXplX51U63fWGzhMaQqc8vRzFFz9o3CNUJ9O4EYhGpp006NVc5qnpSUGYvKvXCPoaThGPzZlLlRY3k8CL60W/MhQaxSPrjH2CUiS5CbYzcfUaU2nq7VjSLuriaIZYUgzL8rayQH05TM18S/s66UH85IBcc3hrv6iB2/j0NrP5HUWpw4yFDO9Tcxc0xt7UZSFTcpE5WxjvVq/tFHRzJZ0h302FiaKbstBGEXqIDy5IdQ8Av38ZMhT6PJBl8wx1FvSkulPCtgAFbWK39GH8Pi8l1WN08fHiGb0wAVZatFJ3TD37CTl1dXrNNJ4cOJoKwccFxqdCNMiMeOE+SVgKWvaXP/UKcswb1kGeSaosq3tDbk24w3V2YtUym/Sz7XU/ebjdrMFiQnli1rA/EzxmtdffCZtJNEmlcX4k7tkWG5mN2ZQAytvpFcCpUxWbUxgTx162Y9BpGu2OR1o08j5clmkoz3RMC54RfJjopnuS1OkvU3CnyZGykDUpouZgz8hywBDHYbOOyi++/fdtfjEK8Lllek65dsr48/kkUiFYONAOF4P4B5tMaIY39Z/lAK2L7mmu+hKOQbC25dla1allQLbrUXP4NYx457XedOaED79DLynH8M1Ln
 PEXb1o1w
 JPLPdpQjxJtjr+DN3PPw4v9HdahlXK7bTPX7gAlilvEE3zp4coNgUk6MCAjNAPy0bmVoLmTwgSdwokJm3VKq2sVFdgZJt3ArpEIWNdIQ9pr7i1FeFm+j9e3G+vFSSGVc4KhIfAxaajK6QMowfw/SRUq6iA5B60BpB+5tHKAPSBmyFFRUEipNRsrhzI6u2yDfm9cGafZymNcIk7g3yO2nIRQ8cF9vBnZIWQ/ajs8RGLJm2T2IaVSbYM5wx46M5dSasMvc2S7BXzXvHpdhSdmiyD3iNNgDwvdXUqgku/xffDdLODcEtsHPPNM1ZlvhWyYLq6Biz7R0ntN8kjekHkAHeFaGI+HJU6EuSnzTUfxFMRzzuNLq6oFzxyjoZVpVIv0NJtvOZnjjejixw02LKMeBSzfKDaQw6NnFPsdu3o8+LlqXsA33xjO2xIKoCOSLom034g5Iq2mHazeQ3VA7EEzyYr1lXvMfSjssrzmfQ8wWz4OhXnS7Mafxc8vfQbzFkyRg96tAY0DbEh8EHuY4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When vma_iter_prealloc() fails in do_mmap(), it jumps to error_just_free
without updating ret to -ENOMEM, meaning do_mmap() will return 0 on
failure.

Additionally, this error path unconditionally frees the region struct.
Since the region was already added to the global nommu_region_tree via
add_nommu_region(), leaving it makes a potential dangling pointer in
the tree and may cause a use-after-free on the next tree walk.

This commit fixes those issues by introducing new jump
label, error_vma_iter_prealloc, to correctly handle the error case of
vma_iter_prealloc(), and move the region updates after the place that
the allocation is finished.

Those issues are discovered by Sashiko, linked below.

Link: https://sashiko.dev/#/patchset/20260702012830.667205-1-thehajime%40gmail.com
Signed-off-by: Hajime Tazaki <thehajime@gmail.com>
---
 mm/nommu.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/mm/nommu.c b/mm/nommu.c
index 815ebefddfae..ad619611e83f 100644
--- a/mm/nommu.c
+++ b/mm/nommu.c
@@ -1181,7 +1181,6 @@ unsigned long do_mmap(struct file *file,
 		ret = do_mmap_private(vma, region, len, capabilities);
 	if (ret < 0)
 		goto error_just_free;
-	add_nommu_region(region);
 
 	/* clear anonymous mappings that don't ask for uninitialized data */
 	if (!vma->vm_file &&
@@ -1199,7 +1198,9 @@ unsigned long do_mmap(struct file *file,
 	BUG_ON(!vma->vm_region);
 	vma_iter_config(&vmi, vma->vm_start, vma->vm_end);
 	if (vma_iter_prealloc(&vmi, vma))
-		goto error_just_free;
+		goto error_vma_iter_prealloc;
+
+	add_nommu_region(region);
 
 	setup_vma_to_mm(vma, current->mm);
 	current->mm->map_count++;
@@ -1235,6 +1236,12 @@ unsigned long do_mmap(struct file *file,
 	ret = -EINVAL;
 	goto error;
 
+error_vma_iter_prealloc:
+	up_write(&nommu_region_sem);
+	pr_warn("Failed vma_iter_prealloc()\n");
+	ret = -ENOMEM;
+	goto error;
+
 error_getting_vma:
 	kmem_cache_free(vm_region_jar, region);
 	pr_warn("Allocation of vma for %lu byte allocation from process %d failed\n",
-- 
2.43.0


