Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7F732C4450B
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 20:13:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 88B8D6B00A1; Tue, 14 Jul 2026 16:13:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 863276B00A3; Tue, 14 Jul 2026 16:13:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7530F6B00A4; Tue, 14 Jul 2026 16:13:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4A2D56B00A1
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 16:13:44 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D0E6D1A04D6
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 20:13:43 +0000 (UTC)
X-FDA: 84988482726.26.6545CA7
Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	by imf02.hostedemail.com (Postfix) with ESMTP id F2F4480012
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 20:13:41 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=q07y3ggj;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf02.hostedemail.com: domain of skinsburskii@gmail.com designates 209.85.210.182 as permitted sender) smtp.mailfrom=skinsburskii@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784060022;
	b=5ITfVq5h1PXlwxwwWXrRItQrfkBYkeIVAs0N0Z+Fivqo6afHzJzVNULW3IoyOT7uEbk0a5
	kHaMA2sSCu+eEFEZuw///NQzdRIAyozbstLWefRM5pKTfs3Ky6Fa6nOpKQwTU49pLJAuR3
	TVK/ZrG/FeOCluXhnRR/UWv7iQj5Ulk=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=q07y3ggj;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf02.hostedemail.com: domain of skinsburskii@gmail.com designates 209.85.210.182 as permitted sender) smtp.mailfrom=skinsburskii@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784060022;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SKEncuDEb35sxzE1YTlJf1hRIKo4X4QhyOOQXqSLrW4=;
	b=iXifXAwYIBzlCY2vTZxYIiRPZIUU4hixN3SgPk90Pyt0ls7EAPNv7rfQd5uNB1BXORagLd
	FL46IV+W2uquPXdFhFMu9EN5BlaItfukM50BHgFzDGipNDdJZbNVPZr2gbrBYxR1MZEG2+
	NNgEF1/dtHQORJ6l9izGnLDCn8lqb30=
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-8487b7b4066so4657395b3a.1
        for <linux-mm@kvack.org>; Tue, 14 Jul 2026 13:13:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784060021; x=1784664821; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:user-agent
         :references:in-reply-to:message-id:date:cc:to:from:subject:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=SKEncuDEb35sxzE1YTlJf1hRIKo4X4QhyOOQXqSLrW4=;
        b=q07y3ggjFCE92Xi5a9aTsHbEIl8d6DjICeBdE3PhPdWcceKEDJHxbqr8KlkPH/5xHx
         bDFeo3Dj7wPRatGescZarwy5wv7mjmE+/7nCfy/N/rpKxxwsWs0V0o0ZIRlIV+x2qOeN
         SHdetYTs+SFLDpYLNlIytObQqnv1lAAk+5y1SX9OWLTxI3UMCD2ow0YJPAQgVASH/3Yc
         UvJyqBevQMJwHKusvo4FpvHtw7D3hJ3Q+RKh/K3F7UIhV8m2N7zGUer8G9DTamTgh3CV
         wsLCB6fmAsFAC53BpOXAy2rTJAMvyondB1SzOl4NgU63qzn6oRHaBzaFNT0AqO+0Qj1Q
         3PEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784060021; x=1784664821;
        h=content-transfer-encoding:content-type:mime-version:user-agent
         :references:in-reply-to:message-id:date:cc:to:from:subject:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=SKEncuDEb35sxzE1YTlJf1hRIKo4X4QhyOOQXqSLrW4=;
        b=mosxJzHULIKKvLVuR7Ellu0YgldXfQPFIFOjg/FYILcp97YTUcBoG3QDAvlkcNd5Y0
         1LaDXaXXHHd//IXcEipEDv8vShn6sPYM3F5B3FGFYlI7+UowqKFdL76I4ZItTDLi19Hr
         +K/eZ0aejPtjGSUBANtoPWMQQzLt0iOEAQP4KJcHhv7Zpr8BZWqPR0i5QWK931WUqlYe
         dQ6TWOXwtdcO3mSKqf2TPLK6r08RkA4oSUayXNjrmz4mg3xTqF51uLj8NbbUTRziMhCq
         2n6HONfASgAKgF1pfr/f1BktwcXpO5OHVPhUuIbsychvp8LUXHRdHB/j1EVArieLLFll
         EF1w==
X-Forwarded-Encrypted: i=1; AHgh+Rqs78yD9S5QEV+WmLcm7RVdf8gTFF4Ljm6C+EfJ78xIK0hcssH+ZJiFygmWTnr4uwv9d+yQrJiaiQ==@kvack.org
X-Gm-Message-State: AOJu0YxZECD7Kec/tPyhmMInF4AXajeWcY9I06fEtFSxsrkhTQ2xlDdk
	CMX6I1Vup0YUUGk4lmMmkF+v5lp8JNBNjFb/m2g3UmV1JsgrkfIDKmRf
X-Gm-Gg: AfdE7cnrdZQsWX7WbI2XeZfa+mwFvTBvGZj/khi7pofpQNL/n/cVjqz6sbyQbinSkwF
	gxL2SAWBdslWlZqxTaUJ9/tq8FN7sF+f9x6dMxfRu6BMABWLIjPaqgVAgSlmMzVlnlG2Q6guaGh
	GvSgwp3oNkAFbT4JFm89KSOUWFTCeH0y1XqKhknw8ai0OzHu/uKEvWNjtBQ18GVqLRPIq9RyCJ0
	oGHsHYdqUz9l1ia5CZNdUFEOtOAIDojKrakq+2NLBv/x5VqB+OAJYCIjXYoBxoZyHHLiyAhCfIW
	IPnhM1uAkROtEv1Y+UgvhRJZYU8nEfdbzWg5fZC0lTpheQTDOzdO6+qD2jAtR1Nnh70O4F/nIjq
	1qMBEXFlC3z9MXZpSjSTzKXGCUNGQxxqK4bAWy5lPu/SYiWdyewTkKcyms2ccOCkYE8tH6Fjkmv
	J449Jmzy8QGwMjYv/4lD4VmFAqjJeJaAuVJfTzH+8/9vA6HZ2Mla+/wLrA/s8=
X-Received: by 2002:a05:6a00:2e16:b0:846:f502:4cd4 with SMTP id d2e1a72fcca58-84a671da73cmr45857b3a.4.1784060020856;
        Tue, 14 Jul 2026 13:13:40 -0700 (PDT)
Received: from [192.168.0.160] (c-98-225-44-182.hsd1.wa.comcast.net. [98.225.44.182])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84a4f81d770sm1966491b3a.61.2026.07.14.13.13.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jul 2026 13:13:39 -0700 (PDT)
Subject: [PATCH 2/4] fixup! drm/nouveau: use
 hmm_range_fault_unlocked_timeout() for SVM faults
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
Date: Tue, 14 Jul 2026 13:13:38 -0700
Message-ID: <178406001808.1082778.17299764648397654220.stgit@skinsburskii>
In-Reply-To: <178405975214.1082778.5193079941156341151.stgit@skinsburskii>
References: <178405975214.1082778.5193079941156341151.stgit@skinsburskii>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: F2F4480012
X-Rspam-User: 
X-Stat-Signature: 9jue9e5bqfxegfnw8gatfak16nmkzqzn
X-Rspamd-Server: rspam03
X-HE-Tag: 1784060021-456233
X-HE-Meta: U2FsdGVkX1+3oadDGCdMcj7XnS4PhBYZ7QL/Wfl2U2SM3ntYFESziW24PWRSkCsd9vo0xWYSd04dz35GhfzATGSIhry3MdCxE/5zCaQ0h8T1v3l0SNAGQM7SKs/vHi15OFpgF3tOcBCiN7hNdoBmhYopCEzM1E2Yjp3IQgure4/MKGEy6C86+++pQcz5mddJqbhrfAJR5cI+LaT3Sp749yWgiSLNQHsFIOHavomwekXSV4pQ50BIaReI+ro9SpfldMAYoC/ix05xCMOERMAJEafmqFETnLDNQ3YmcPKhOodE8rhT6znvISlMNG0hH+VkvCdB3+Jx17zvyfltKPXInPHWARNsI+wYyth1DnCO4PYfChVdJHE0LnB8PPMSs3RSr5ZRZdpdijCGkzfdeNIMi+uNxxUNuQP15z5/l9QuJzplFhDtDp7LACevZ+JM+5nvTHMRQsvj7aVpv2ouHCG9u3X2hLtlACV934TBarCmShe6un8ypai2WOSIG6Le22Ep8ATV4mcmt4tLeQXbG2Js9/buYSiQsyWnxh5B13FkBTrCy8Pl36na3WS5YnkMMXsl3o7j0zZCoNcNEHZds64yTD06/9oQU1kQ5NrI6lSgedQI/Za1cfjSWUopWpS7CEqo+1h9nBqIXdoNMnB2FP6VrmOkoh1FLlKMAjrA5G9Dq+Mkjy0Si1babs7F1yoPepNwX8u6dH8OSNf5nDiX1QrkwBYFOMqzIv/TxR2ByT/xGgKlmLXzd8zOC07NQAfpxDw+qbhQ66ouySoFL1xdHcjOnAqkT6s/rco5m9wzcPidjcJuFGCkjnpzERJ839GsDH/rK12OiAttblCeQkNR9wIZM+fuWIy1yJw8xrKIzcgB0EaUOsjOcppryyq8HjkU04uSMXeG3kQ6POdThOsfCkRPyDpXLoqVtBl2WjWFToKaPH3IvjFx9KfYJOOpJmxnleo1fX/w+xgZAhZ5gBbx6Vd
 SBx/11C+
 ioL2D/nnUqj0iwRT3g/FqP2Mg7L0dDD4sMABJsUmCmfiMk5q97QlFPI6zUshf1IPa2jtbmFHhKOiWUi/NWlVFvlOfTe0sK56SVCByGmzPkJYwHN7mc3OzKflQ4nwDft4nJ7/7kUKnDZnKbq+qxGsl2hU7zGdnK2eWe1o8/L63sOdFeB2j0VRrDd73/yhwD7wchcpWxYH/EqNLmNHAHX+IZDYn6vkJeX36Fp9FYGtHhR8gIarOLAje0IGYI5lTqYmQwaGVw8AWOOFhKZ/nk7iawMDDZXXnxbyrQ14rJqHtuvHGp7pK3m7h+ONLU1fxprnPA2QJa/1PKwQcsp3/2Tq5u+Ys3YfCk3B9GKN6tGdrz3YTs6EhVnKwE+EEjllKeqvUj0AGd0cj6ETxFLZUJYFtEtvcqrdklBaxZGmINSA8+0/ZUIIflIXrrmzXVsYz4kdCW1+PdghRiE96xtmoSboi0g+RelLyL6ol8s15QK25X4wwWFWyyzVBMHyuauDs44ZWVHvr7pLHgWdaj5oebTlrTSL076jPdXkGwhctwxL2JrdyN1XRNjEKmIFwIQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

nouveau_range_fault() now uses hmm_range_fault_unlocked_timeout() for
the HMM fault path. The timeout passed to that helper is meant to bound
HMM's internal mmu-notifier retry loop, not the whole nouveau retry loop
around mmu_interval_read_retry().

Pass the full relative HMM_RANGE_DEFAULT_TIMEOUT value to
hmm_range_fault_unlocked_timeout() on each attempt, and retry from the
nouveau-side mmu_interval_read_retry() check with a fresh HMM retry
budget. This lets HMM continue when it has made progress, while still
preserving a timeout for repeated notifier invalidation retries inside
one HMM fault attempt.

This also removes the open-coded absolute deadline and remaining-time
calculation from nouveau_range_fault().

Signed-off-by: Stanislav Kinsburskii <skinsburskii@gmail.com>
---
 drivers/gpu/drm/nouveau/nouveau_svm.c |   30 ++++++++++--------------------
 1 file changed, 10 insertions(+), 20 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/nouveau_svm.c b/drivers/gpu/drm/nouveau/nouveau_svm.c
index 4cfb6eb7c771..b1415c2e49fc 100644
--- a/drivers/gpu/drm/nouveau/nouveau_svm.c
+++ b/drivers/gpu/drm/nouveau/nouveau_svm.c
@@ -655,8 +655,7 @@ static int nouveau_range_fault(struct nouveau_svmm *svmm,
 			       unsigned long hmm_flags,
 			       struct svm_notifier *notifier)
 {
-	unsigned long timeout =
-		jiffies + msecs_to_jiffies(HMM_RANGE_DEFAULT_TIMEOUT);
+	unsigned long timeout = msecs_to_jiffies(HMM_RANGE_DEFAULT_TIMEOUT);
 	/* Have HMM fault pages within the fault window to the GPU. */
 	unsigned long hmm_pfns[1];
 	struct hmm_range range = {
@@ -677,25 +676,16 @@ static int nouveau_range_fault(struct nouveau_svmm *svmm,
 	range.start = notifier->notifier.interval_tree.start;
 	range.end = notifier->notifier.interval_tree.last + 1;
 
-	while (true) {
-		if (time_after(jiffies, timeout)) {
-			ret = -EBUSY;
-			goto out;
-		}
-
-		ret = hmm_range_fault_unlocked_timeout(&range,
-						       max(timeout - jiffies,
-							   1L));
-		if (ret)
-			goto out;
+again:
+	ret = hmm_range_fault_unlocked_timeout(&range, timeout);
+	if (ret)
+		goto out;
 
-		mutex_lock(&svmm->mutex);
-		if (mmu_interval_read_retry(range.notifier,
-					    range.notifier_seq)) {
-			mutex_unlock(&svmm->mutex);
-			continue;
-		}
-		break;
+	mutex_lock(&svmm->mutex);
+	if (mmu_interval_read_retry(range.notifier,
+				    range.notifier_seq)) {
+		mutex_unlock(&svmm->mutex);
+		goto again;
 	}
 
 	nouveau_hmm_convert_pfn(drm, &range, args);



