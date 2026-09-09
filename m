Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 34647C79FB6
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 11:57:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0CBF16B008A; Wed,  9 Sep 2026 07:57:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 07C626B008C; Wed,  9 Sep 2026 07:57:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EACEA6B0092; Wed,  9 Sep 2026 07:57:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BBA336B008A
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 07:57:55 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0A8F914019D
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 11:57:55 +0000 (UTC)
X-FDA: 85194074910.11.45E3AEA
Received: from mail-pj2-f12.google.com (mail-pj2-f12.google.com [74.125.227.140])
	by imf22.hostedemail.com (Postfix) with ESMTP id 624F1C0005
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 11:57:53 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="eNngV/io";
	spf=pass (imf22.hostedemail.com: domain of trintaeoitogc@gmail.com designates 74.125.227.140 as permitted sender) smtp.mailfrom=trintaeoitogc@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788955073;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=skQiOQP7wKiwMIoirY/KNv9X3P0+d+Yd863CB9w3fDY=;
	b=4wFwKITMD9eNhP/xCAIGW8wMgLGSo0d5smeUV2iXEUbVAo7+zSgsabwagrJr8VEBFLC6AT
	pSr6QGbKKqF4fiwWhzErsl0M7aG5gV2knOJdiLUfLaJbydBX7X2rToYURX8PW9HmEsMM1E
	tNYOXcL8K1BYUCWp7RvyxGgHBylTu3c=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="eNngV/io";
	spf=pass (imf22.hostedemail.com: domain of trintaeoitogc@gmail.com designates 74.125.227.140 as permitted sender) smtp.mailfrom=trintaeoitogc@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788955073;
	b=D1u9v1nr/0a9k7RYabmRrypUdfbZvd+qsni+U5cSwpoM/YbZj+o2lCNhggHtsCiG5bJf5X
	fshV8MUg4mHu3N9uHAsSZEKvWNXmn6WE/lqCD/M+QFkKAfX4tZsI3YdTVmM6r6QKVx7pPR
	uwzy3GbTACEnvch4i91pbwPG7ufjqmM=
Received: by mail-pj2-f12.google.com with SMTP id 98e67ed59e1d1-39b9184fa80so114852a91.2
        for <linux-mm@kvack.org>; Wed, 09 Sep 2026 04:57:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788955072; x=1789559872; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=skQiOQP7wKiwMIoirY/KNv9X3P0+d+Yd863CB9w3fDY=;
        b=eNngV/iop9YjcqyD3svGD7dUxC/MVnkOOgDzoe9EiG0YQJKLVUpGQhEs9ruOmOeUmF
         79e7Wjv1dDQYJFB9/Pl5QMkN1/tJodhLaTG37FvRaZKUswHxG4T9+DiYNo550VZmIrhi
         QW7DMIP9rRFVKIxJHnQXhsDWZtWFCqcWg4G0DtfWCEJbvHgxiOm5OEfPUwZDcQDxf+yl
         W2mcCIpVRcXgXmTv5Y++51178OsXMXoOYVAHJ2b6VjZzZ0ijGKv2cTMTjdeqf8R5Jlqf
         RuKC4Fcf85wY9hupyLUUnboxmXAkUtS04cZ+weS91uonLMWmj+4YKZwDqdn48TR8V6YN
         naOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788955072; x=1789559872;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=skQiOQP7wKiwMIoirY/KNv9X3P0+d+Yd863CB9w3fDY=;
        b=CdffmstrsI+rkNhbjjkezpjlRwBkTRI9K1lvBYh0aaC1Vxa19/dBeJmMclxuNyyYeD
         QMDXbmQ2jvDp7qmAYmyGhjR3UlY9YVFCXr+hF53+1KW9TGMUs+3Zh52IHU0SlIfrF/en
         Tj7bVROtUFo3MEok3+d8Dr2X4xIFZaxwMN3AaNW890ihcr/bqgDmOMrkGEOK68qChN9u
         u9XlEzDbW+ytJ+NwDpkglPB3IUvDA+TsrukNP1Ddi6e9ICS9gYibyz/JRca3DW2YV6Pa
         aNYaN8CRBmAI16bDqncGjPK3LEW352xSWy57TkKf09DkKk0Ul+T1/cQFFfC1eXTxqOmr
         /HLg==
X-Gm-Message-State: AFuF++l6R7EbKw/k3896cV6zvj6q+yQiBbVuiRadxEKsYodLAK2EckDZ
	5SVbxUsuP4IRZ7hm+bhmUpnnDuiddpmTMEFc9nTdROgmE+2f29bl6c7I
X-Gm-Gg: AYBFou3ogsadctvDmH0Jfg+N15eXMtpVO0LSoNlStjOa0HMZXHmcIlx5c9n45ra9W2P
	aiZDItj6BvT61JBPLMh1KXhq91nCeUm5o67TYuRUy+YYii2A15BfkxNhalf/x72LJ+AhpF2bQuj
	/roci/RT04aekne/p+GimAbDoz07TC9u50gKEVOkOAXkLT0+4r6umu+6ais5YB5LQQ9YzNZvlfH
	rtLGLY5bK3/+u9JhTfpw8QoyGPlBBwOtJmYPVgZrLhAXIyRHCnVipjKrnAO+VVRLzV6glcm+BtN
	l8ZjRR/h6QIhpoIzgaDTEXqvxpY46J2RATMg2ZjoLdH5TYGQ/Lhl40M6WOYjuNSgCPn0xucEIPP
	UMIyUYeLF0/Zd0U0/Qo32FP3EQRm0K0gdyCDqEKo9rEDDWtTqoN8dKl960RFiPPa8AAXLNKPOYZ
	vanA52zmEUiDWtsWBA8UyDRzf51b6aMOz49qWQr0GbhnUfCTQooX0ZYPBhqDCWtu3M9N6yDI+ZU
	Y43JhhQ548jWx3j3YixyHh3xooAWBKEINm2Irku2YwQRHWeZj/CPc4Mso069s41
X-Received: by 2002:a17:90b:1d8c:b0:398:b46d:48c0 with SMTP id 98e67ed59e1d1-39d70baf4acmr444308a91.18.1788955072012;
        Wed, 09 Sep 2026 04:57:52 -0700 (PDT)
Received: from fedora ([177.21.143.191])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-143240d86c3sm39619067c88.0.2026.09.09.04.57.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Sep 2026 04:57:51 -0700 (PDT)
From: Guilherme Giacomo Simoes <trintaeoitogc@gmail.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	pfalcato@suse.de,
	willy@infradead.org,
	lance.yang@linux.dev
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Guilherme Giacomo Simoes <trintaeoitogc@gmail.com>
Subject: [PATCH] mm: bypass datarace check
Date: Wed,  9 Sep 2026 08:57:23 -0300
Message-ID: <20260909115723.528501-1-trintaeoitogc@gmail.com>
X-Mailer: git-send-email 2.52.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 624F1C0005
X-Stat-Signature: hugyzbmpaj8nau3huu47q9xni8ink8in
X-Rspam-User: 
X-HE-Tag: 1788955073-750713
X-HE-Meta: U2FsdGVkX18+Yrb73hUN9/tzOcYsgk21c7w/+bsQQ7GSdxz6C0XSaGheT7KVpPKNZedXEqAK+e6wjb0Ron7mXez34dQsG2fHyYCyUWVSK8+zIOQVWlV2hxZr22H71MXZ59bA0QzSGhnKyo+/ThqGXDod8K0Ps93a8Jhfx2FFp92JWTryuTZ5NXJwmNcPG18ngS7P32expFKaffgFFUSA6pzCo//gG2zncWBaf0Up7iP3vHFRC43NGx9Nsj4riOrINb9Xie5QWpnqgbjMUOhvgoifHempfwztAMfhfqZM70gGxxu0wpeSVbmyv5BtemwHEm+B0Gtw4d7VwZ09FhXoo2fnkVnn6p5+0XPOc4cMEOEAHjR/9orjEzVPPbeOY1m3aY5/8Pt5f+HXH1VXb1BdJA+SYstWarwyZqgIuhcjCFPdVwVkBdUICGJZftIAMRSbOM3fkFNw19f9t6p0in5mPEUbNJGAYNyo+e2yely5tLyDSWDw9mKeHPrQmPDjF7fYoqDV1YqYh+pnEZsG5ujPVXY/kQ1dTEbFH/5ON/vUSvYDkGaNscUIWmYUFn2AGF6+zxuHeguxzY3jlCALjJpwKe8qGrpsJx08FasH7/4fWT4V7TXDdknNW+LHNiaa0xrc4TOjVEey9+kM3F/f3D0/2oMfNkIA1lbNAU+LzWt1yAvWD+z5YA06JJsWT+M/T1HynhaKg1LnjpoLVI5RChn5yDsUUc9dl5E1VMNKFtszlV5Y7mEPuavSEgzfEC27iSqfD5Z1cvVl7qLnGGeSD0m628YDP76xWAMkM221+L9BHz81/JAAzi1dysvsqB+Ubc36RfDuwCQBldC9nhtOxdsIpnxVVaNK6yfZGs2uCSRIobhcH4Wxuny3o5o9PxGiklB7Cgn93ZiKf8mnJLOVoRcY2Kp0JKcwjvwS9jXE8/pdvVU+dyGsvpj4i4xEwDrISdnzDRsHQ3U4DRmeT8+PIaP
 JSigH6Te
 4n5u+UcUZMKqRBwwFq9TggWlFhaBZplvqciSE1x1quH/rjNzbslr1ifin4jx82oLK51/6M4YeUvtP5tGNEBACFubQul41hYohkbFm8Q4uoqXgszKi878yaRqWkHymw6eajh/2XQ6D/PzUlvvghmFom/yFCEC8WkadXPFOzJqs1fIB6dSWY41Ow11YHb7HlOhuZVGWRA5Q6+pb86mnxspVWA0Mi+NvNw1abFwo4fxW2XCiNH5P0ZFfxs9HnBJPBRqJDKedYiNEKKWVbBs++BTnfchK6zBYUK+qEktE2JT3qdQJ42Jqyez1QNBTOV/bVtttm4l72HbQKIAfYWZQm9DD9FxAONcKAzWBte5ma7GkdrKB89YEAZsrLkCqM3lWf3WF8DzJ5rh4XJuhJJiG2lxMlU4KSQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Despiste kcsan point to a possible race condition problem, this is a
safe race condition due the access memory ordering, since
spin_lock(&mm->page_table_lock) have ACQUIRE semantics and ensure the
ordering mapping.

Create a new function called vma_is_faulted(), that return a
data_race(vma->anon_vma) to bypass kcsan

Signed-off-by: Guilherme Giacomo Simoes <trintaeoitogc@gmail.com>
---
 mm/memory.c | 22 ++++++++++++++++++++--
 1 file changed, 20 insertions(+), 2 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index 6b8280cfc1db..d85d67927400 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -3800,6 +3800,25 @@ static inline vm_fault_t vmf_can_call_fault(const struct vm_fault *vmf)
 	return VM_FAULT_RETRY;
 }
 
+/**
+ * vma_is_faulted - check if a vma has been faulted
+ * @vma: the vma to check
+ *
+ * This is a lockless access that may race with __anon_vma_prepare().
+ * The race is safe because:
+ * - The fault handler ensures that the mapping of memory is ordered.
+ * - If we read NULL, the caller will re-check
+ * - The page_table_lock provides ACQUIRE semantics for memory ordering
+ *
+ * Return: true if vma->anon_vma is non-NULL, false otherwise
+ */
+static inline bool vma_is_faulted(const struct vm_area_struct *vma)
+{
+	/* Lockless check - safe because we re-validate under page_table_lock */
+	return data_race(vma->anon_vma);
+}
+
+
 /**
  * __vmf_anon_prepare - Prepare to handle an anonymous fault.
  * @vmf: The vm_fault descriptor passed from the fault handler.
@@ -3819,8 +3838,7 @@ vm_fault_t __vmf_anon_prepare(struct vm_fault *vmf)
 {
 	struct vm_area_struct *vma = vmf->vma;
 	vm_fault_t ret = 0;
-
-	if (likely(vma->anon_vma))
+	if (likely(vma_is_faulted(vma)))
 		return 0;
 	if (vmf->flags & FAULT_FLAG_VMA_LOCK) {
 		if (!mmap_read_trylock(vma->vm_mm))
-- 
2.52.0


