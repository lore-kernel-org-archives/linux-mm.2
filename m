Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C6974FC5904
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 07:06:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 119646B0096; Thu, 26 Feb 2026 02:06:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C4786B0095; Thu, 26 Feb 2026 02:06:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE1336B0096; Thu, 26 Feb 2026 02:06:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id DA75A6B008C
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 02:06:18 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 70E55160A08
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 07:06:18 +0000 (UTC)
X-FDA: 84485724036.10.6B48543
Received: from mail-dl1-f73.google.com (mail-dl1-f73.google.com [74.125.82.73])
	by imf17.hostedemail.com (Postfix) with ESMTP id CFCC94000A
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 07:06:16 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=FQFmCOPc;
	spf=pass (imf17.hostedemail.com: domain of 35_CfaQYKCJwOQNAJ7CKKCHA.8KIHEJQT-IIGR68G.KNC@flex--surenb.bounces.google.com designates 74.125.82.73 as permitted sender) smtp.mailfrom=35_CfaQYKCJwOQNAJ7CKKCHA.8KIHEJQT-IIGR68G.KNC@flex--surenb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772089576;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xfjM/VAc0stWw4WShx/yqMtIU9xXg0AJdwokX5oM15c=;
	b=7uaOcnJbg74Mv7U5CxrYErvW8POQYjIpS9Ha+NzGIYWZLZBMwwNKyV7K2S2G5cYhS3eqRw
	rrg/+Rxo1ErvqF1UjI4j191aCh5buyfN7yRsNxicOdGGw+5gT90hq1G7HDfJW9QE30/x9h
	f2dZy08RrJ3K6TsCbGn7tREEH4x6rYw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772089576; a=rsa-sha256;
	cv=none;
	b=BVcf2RRdJuaz2Sf57hnOSadWJsd71uDRO72at5kzWReArGQoS9d7TuMsCo+HlaR+Drk/SD
	hqtIcLI8IkkLpADAatOVQNEibKODeGs8T4XF/oqMLqSCe6lTmoPwZ3QOaaj03Sr8eV1kc4
	PCMbVYXyKUy2L84ajCm6WZ2N2pf++RA=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=FQFmCOPc;
	spf=pass (imf17.hostedemail.com: domain of 35_CfaQYKCJwOQNAJ7CKKCHA.8KIHEJQT-IIGR68G.KNC@flex--surenb.bounces.google.com designates 74.125.82.73 as permitted sender) smtp.mailfrom=35_CfaQYKCJwOQNAJ7CKKCHA.8KIHEJQT-IIGR68G.KNC@flex--surenb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-dl1-f73.google.com with SMTP id a92af1059eb24-1277896014fso13297149c88.1
        for <linux-mm@kvack.org>; Wed, 25 Feb 2026 23:06:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772089576; x=1772694376; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=xfjM/VAc0stWw4WShx/yqMtIU9xXg0AJdwokX5oM15c=;
        b=FQFmCOPclIB5MdctkOIBTKTwRb2dLklE68JmUQPRySJqibT9DEoqjXyH0gnum2Ffnx
         4Cf1VGKKCTHPzFA7kH737QB0m4/eI6W1ZZuHpf704pFTly/FlDcqx8fXYn427WLdDZoI
         PRf1eT9KgdWd1lh+K6FjGN/wJzUY72PmBo/czux292tf4thqDaRu+xTgW2HNHqaSHMLm
         JmZ5L952BFqmowsbG8nEhMfact1XAzN/ai6sfEuoGPXHWywCL7MhT1AbIFML+wabh3a3
         MzZZaf1gazY9oGQZnEpdwPl98+QX/J9Ay1na2dHpU8ad/Jyxl+NKiAbUrmEPsh2MD+yq
         6Htw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772089576; x=1772694376;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xfjM/VAc0stWw4WShx/yqMtIU9xXg0AJdwokX5oM15c=;
        b=tIJqKQe7nO9ZwFRpxmPm3i1zoUmp8KZLKsJDKeg/AW4k/LbPVxY+sYkIoWP5grQn+V
         jYVVi4ztZEaHqBylDQrACWfBcbWc4bZ9nFtiUz6GsYDUgIRAUHjWd8o1FFiR2XLHtu+q
         6OHH70k1XloGUayk33p6nHAsEXJPYPbaV5ICkXjuYCYOBlLM9mEjauD66EjQT3dfy7bP
         OaidsqdAPSQcJikvkN0hBvwl8qnuYRlhL6uFwjQsM91gCReIXe/F7dC8myiUuSbRXEPv
         PghINEaR5Tbl3ZN5JHIRQTgpQouEtIZ0huAHrjIgQaQkdnrasy406dDKi5Hirl/IsIuU
         EskQ==
X-Forwarded-Encrypted: i=1; AJvYcCVRmSSvipIdcum/4O3iDfvq5RE6woMWaouNxYu6+ugkgekV14mdvpY+TgkrzdwX29UUxq+LJc10MA==@kvack.org
X-Gm-Message-State: AOJu0YxpIPuk/QXOoYDPNpcGuukGJpQET4iIZFpBAHFzi3+VlaK1s71Q
	JPloNipFjKf3scZn/tQvFed1IDeKH9yMnTucPe1bGrqwo6OOT31sfzIGX5AQ9w0yuCwAEuKtiBs
	RALQ9Rw==
X-Received: from dlbvv2.prod.google.com ([2002:a05:7022:5f02:b0:124:a76e:bd23])
 (user=surenb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:7022:626:b0:123:345f:5d9c
 with SMTP id a92af1059eb24-1276acdaa5amr6463857c88.2.1772089575384; Wed, 25
 Feb 2026 23:06:15 -0800 (PST)
Date: Wed, 25 Feb 2026 23:06:07 -0800
In-Reply-To: <20260226070609.3072570-1-surenb@google.com>
Mime-Version: 1.0
References: <20260226070609.3072570-1-surenb@google.com>
X-Mailer: git-send-email 2.53.0.414.gf7e9f6c205-goog
Message-ID: <20260226070609.3072570-2-surenb@google.com>
Subject: [PATCH v3 1/3] mm/vma: cleanup error handling path in vma_expand()
From: Suren Baghdasaryan <surenb@google.com>
To: akpm@linux-foundation.org
Cc: willy@infradead.org, david@kernel.org, ziy@nvidia.com, 
	matthew.brost@intel.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com, 
	byungchul@sk.com, gourry@gourry.net, ying.huang@linux.alibaba.com, 
	apopple@nvidia.com, lorenzo.stoakes@oracle.com, baolin.wang@linux.alibaba.com, 
	Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com, 
	dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev, vbabka@suse.cz, 
	jannh@google.com, rppt@kernel.org, mhocko@suse.com, pfalcato@suse.de, 
	kees@kernel.org, maddy@linux.ibm.com, npiggin@gmail.com, mpe@ellerman.id.au, 
	chleroy@kernel.org, borntraeger@linux.ibm.com, frankja@linux.ibm.com, 
	imbrenda@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com, 
	agordeev@linux.ibm.com, svens@linux.ibm.com, gerald.schaefer@linux.ibm.com, 
	linux-mm@kvack.org, linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org, surenb@google.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam09
X-Stat-Signature: x49q99oh3o3t9moxefsp5izgai4th64r
X-Rspamd-Queue-Id: CFCC94000A
X-Rspam-User: 
X-HE-Tag: 1772089576-320114
X-HE-Meta: U2FsdGVkX1/u/s502dzHsg7HTbc63McXXmOB7L+NJ8Qpvs+1wy/ZUAIBg4fXORQSoDwqOW3F5MGWCAtJScHiYdKbi/g9tSzwRY2/XoxT4R2FTzolmcw1sExgQ7gnbgGpWkyPHZF53zEJCvGHph8Va3Ja8JXdl+N+rbPRiflKkK92LKCgI119oJSDTxETe/EDwKLyWaPnVEh1DRVc/8b5a42pRUU+z7hsZPBw8J6/AVR3oflvKYOSXrfenGe4xj2oX2NXP0wr9M541XsswrJ7ViAoCQaY3eQPYb49wnHyf273rHWFueMLjUZbfmYWXaCIOwLjac8xNWHxJdJNuenjtRRs+oJSnc6s1MQLSaE8aT0H+3Q9BaEQ+JxKtsptOlV03+IalzxGc/bJVI216Oy29APNQT4pn2Ld/gHFVRmyvsFkSWY+41XzAqLHcAOhxqzfIwmaCfWFJiwkEdoUL6vE3zXaoxcDQ75PJjavfsKlyz30BqqsQI3c1uSeStjdaEDWbv/FFfjQEb1InnKJBjPzS9BA3DC76KR/0dPzQR/3DOqVD8RqFfKNAu6FHZfWIOl3hxH1u70JMeH0Dn+YBRRVbBC5zLxGqjxDOen6qanNlyf3f8g+bVi/IwtZ6HI9850EFinEhE+6fDVr2CBuIlPZoqpcdTkhuY6dkLQykXzFXQ4s7EKHq19tM2xRhDndl4RprSYFjCFGH1NQbs08cfsa7wgAeUiV8018QVupZs8Y+2sCvdU8BOsgIvcRcZo3IyZ+4hvvfQ7Wofp2TVYpZ+S3UKoVAMhy1zjEPooMypSd8RQiedanyhejI+e5FQtHxraAnZTsTSnvVtxqE16Ip5ujt2IbwQTUVZgPRJLgyoh95a0HKx7n3tjXIwPJqnoTXqSgOqd8eE3+dy4mZ9LWGCeTXzFmdQT6ii9ff5yPsIxdWDumtWcsjvwP2EGZ/9Y8K2ccwdoYEXOkh3JTylJRiSE
 JwfnDtCZ
 YAyu0WW2RTlQ4LAQ8g913KPl2hRSljoa5hjFOBhbstMclXwh84/xrMck0eP2BE9xjtGuUJfpu5alDkvE85mdYI5vIQ6Fq6cvq+jPVjRZxYVdGZM2bm75aN/Z3ESApZtikknMXOQTwqnvJEIgt/s0c3cIhFYJ6yb09z4K+7KF0lu8/S32y+xnUpfTMsHN+jiAyXcjgh31HrTN3/c4iUiDcoTa8BoM6YAQIiel0zEv6StLCuX1hpFFmP7v/97Y5ORZK90lcLrUxS3QyEW+rI6X8owblok8rzhWR7sqfhQ2IKNpKwBRWnS4WlNJNVRGHgMSIvITTbeUe37vA5kAsR0usIe35nLBvOobTOvfz+dWSyWH78cxeW2viHIagZ42cQm0wjq5N5uIp277CRE+HoPtpZw5lBlmJ9FNCs90SABSWLSUT8imA4IakPs1br7UyBI5Fl7tA9n6ernhHCBU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

vma_expand() error handling is a bit confusing with "if (ret) return ret;"
mixed with "if (!ret && ...) ret = ...;". Simplify the code to check
for errors and return immediately after an operation that might fail.
This also makes later changes to this function more readable.

No functional change intended.

Suggested-by: Jann Horn <jannh@google.com>
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
---
 mm/vma.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/mm/vma.c b/mm/vma.c
index be64f781a3aa..bb4d0326fecb 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -1186,12 +1186,16 @@ int vma_expand(struct vma_merge_struct *vmg)
 	 * Note that, by convention, callers ignore OOM for this case, so
 	 * we don't need to account for vmg->give_up_on_mm here.
 	 */
-	if (remove_next)
+	if (remove_next) {
 		ret = dup_anon_vma(target, next, &anon_dup);
-	if (!ret && vmg->copied_from)
+		if (ret)
+			return ret;
+	}
+	if (vmg->copied_from) {
 		ret = dup_anon_vma(target, vmg->copied_from, &anon_dup);
-	if (ret)
-		return ret;
+		if (ret)
+			return ret;
+	}
 
 	if (remove_next) {
 		vma_start_write(next);
-- 
2.53.0.414.gf7e9f6c205-goog


