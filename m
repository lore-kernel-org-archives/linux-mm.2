Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6E16EC531CC
	for <linux-mm@archiver.kernel.org>; Thu, 23 Jul 2026 17:37:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EFAB76B009B; Thu, 23 Jul 2026 13:36:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ED3646B009D; Thu, 23 Jul 2026 13:36:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DC10A6B009E; Thu, 23 Jul 2026 13:36:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 996BC6B009B
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 13:36:59 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 22B4D160108
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 17:36:59 +0000 (UTC)
X-FDA: 85020746958.19.729B0FC
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	by imf01.hostedemail.com (Postfix) with ESMTP id 3ABDF40006
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 17:36:57 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=b1h5ur96;
	spf=pass (imf01.hostedemail.com: domain of skinsburskii@gmail.com designates 209.85.210.175 as permitted sender) smtp.mailfrom=skinsburskii@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784828217;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/3EHZQlaXq9sLmhVgtuP5ODA2wxc36yvs54yemcncOc=;
	b=ZmrxmoAT9e7SPbr11R6MSIeqnCFPzJAtV2caVmngNAV7SzGxWoqr1kSLDL5o3rpcgh1Ajn
	1PHd1P/huDgKHjG+ND5m7TG/iXTNasHX/ayxT1mPvIhTbybFy6/Sj9JmBnV9fcx+wQb1y4
	ccawomFq2g7U8zRa3GGXdy3+OLuhsFw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784828217;
	b=E80duH0FSi+Q8woQZCs6EZrWx0deUPVXTeERAPoUkAa/fLyleSPk7gMXbrQyZ/cFIyo5ly
	rcr0j6VAKMLYqpIntPuksWrjrg2rDK7P+0wuvBpy5DtbpW0otJab/CgQy8BUDEa6G3t1/Z
	C3jXsOAlwCGBtzRsbf7iTaTjSsqTAHc=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=b1h5ur96;
	spf=pass (imf01.hostedemail.com: domain of skinsburskii@gmail.com designates 209.85.210.175 as permitted sender) smtp.mailfrom=skinsburskii@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-84536ecfc5bso1148288b3a.2
        for <linux-mm@kvack.org>; Thu, 23 Jul 2026 10:36:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784828216; x=1785433016; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=/3EHZQlaXq9sLmhVgtuP5ODA2wxc36yvs54yemcncOc=;
        b=b1h5ur96Kai4lFh148+RnI5H+RPODIMWrfylxTpIB5RslzgPVxnv6QguCTexVcvQoG
         v/pWb588SA1t+j/4hparyJu4LSk5wUulm6wtrIW1IAygXT49C4ZKcsls/w+gJ0uNULwT
         KYNpu1PC4vHfjIq5KRDFdQZ57N8y1WJe1Ea+zxbmwDGm1lCfKRhmKhWqT8JIe0J6Q0h2
         nIZ+y69Khlbtlj0NbYSGRabJgL64xTYLF9oqErJ1I0F1dGOgXEwzwLovWCITp8BIzqVR
         qRC3A8kpYkqJD4ZCFgI3bC/uzRpegYQVJO5ZC+GVpqpRw6C0YKY91NzDPZOvXKfvA8fd
         AwRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784828216; x=1785433016;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=/3EHZQlaXq9sLmhVgtuP5ODA2wxc36yvs54yemcncOc=;
        b=AsZUMWL3Zg31qoTDEW5r1ykQ+tOnFrDmaeJl1TZO70hUCYP487MJv+pYyr2eZOmYX0
         KJ+hPV3oJoiLh/UknZEGwRLlnQ5DcAUL545mIm6PrDWVeQJ8sgnylp7jPUHeS8sM2nFH
         MCtJcdmgVhq/kgehVXuYl/YK8Bgp6HzpIwwzClKz5LXIWhQfXg76eHG7v8kLxhmM2+ci
         AfkyJSKoRhgsmXTVUb3yhdT9II4FuTFZyZqve01Ct4JWLkJHhKgEVxgU2XdoIdbQoc7q
         9o0toc/uphT5NmULYtnoHdOnbJN4bFWQ+jSVfqUoXhuQgnj3ykOVv9yCy8v2IY4EhMao
         YJFA==
X-Gm-Message-State: AOJu0Yxe3A6zNZ1+LaS6IQwQeZczV86Skj5RA/D3b1CPN/Sub/zACHa1
	sffcAf5JW0mIsRZJde5/PNL555OgnQEpknNJ8IhB1lS6135MgwQiNddF
X-Gm-Gg: AR+sD12iiAvjIHQaUJQTyIPfk2zVgz6WF6nlAdtEwv5+ZHiEZvbo/XcwgpL5wIghrfm
	Ebd4oUVjGZ6VINJr0vp2UN7PJn2ZGPSs32ybb26a/VHZjiWxLSPNUznpen7GP763D4jiCoodU6V
	dzzZwQLijLK9vvC4gVGpFI+KWUxGsl1U9kdVKcAcF325ASH5siOyaYSFGrL4/QFhF5ODiCNXQao
	SXZ9j67NMSdym7Q38WAQjB26fVBXJBPBhVv1v83k5r6qyZFGmgZE6gF4k1iG6dKj09C5Y2lEU1a
	4B0TRUSvBNlXNP51++WFYcQbtQWLmqEvn8aHBCXPIcO9UkzJU8FMbQpSEUQIA78KexvzP3j66sx
	fPfISRzedK/9Fh58xw27lycJR/fabzgaLiNxIrcnLuf6J5KjkUia+MbCBYTKTFhXwMqqmfSO6Km
	oDNbpvvJDsRHRAfpbbJTaOZKAznhlV57S9zTHhTUzan2pKurTs
X-Received: by 2002:a05:6a00:4482:b0:848:47d3:47ec with SMTP id d2e1a72fcca58-84e2b8ab6d2mr4797080b3a.31.1784828216068;
        Thu, 23 Jul 2026 10:36:56 -0700 (PDT)
Received: from [192.168.0.160] (c-98-225-44-182.hsd1.wa.comcast.net. [98.225.44.182])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84e20622dedsm2691612b3a.11.2026.07.23.10.36.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jul 2026 10:36:55 -0700 (PDT)
From: Stanislav Kinsburskii <skinsburskii@gmail.com>
Date: Thu, 23 Jul 2026 10:36:39 -0700
Subject: [PATCH v11 7/8] accel/amdxdna: Use
 hmm_range_fault_unlocked_timeout() for range population
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260723-hmm-v10-v11-7-c55b003a4b61@gmail.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1784828202; l=2650;
 i=skinsburskii@gmail.com; s=20260722; h=from:subject:message-id;
 bh=Js9Z5fScNTLs9yZDEPq5MMQDWBFdccrrYdkvKMfBR0c=;
 b=UoKX2QEi16TQG/XSPiXepu/KONklG+8l1kn86LgWhqxQQe32BnNrpIu04JJYOeap8yhmhRNnI
 Xgchah8NIfnDwgLdxf/plAUECr/N2GDtTgg00z0Czhp7vw9hyXoBoqQ
X-Developer-Key: i=skinsburskii@gmail.com; a=ed25519;
 pk=bDpriHBYgeTdkIDweZDCemxsU93neJBOCn3YLIuJpnE=
X-Stat-Signature: jcs648sekjs7dzhjt6ye9bti8n1uuryn
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 3ABDF40006
X-HE-Tag: 1784828217-260299
X-HE-Meta: U2FsdGVkX1+kvpMsWcsfsgFaCVDBnMDu3C0JA6kU2K8W1A176YOElcdtrFbAI2bpIzlRIy6APdloJsPRP89YBHhevcUwJyNDTjZLz6T6qP3rnDDtegCsAOxQk6rSxekzGH8XOKtidxaXG3lDXqc5qbsG3GOeSSAp5W64YbqSBGLB/5HHhbERrnibD+ae7mEBodLYw2arIdRo+pTJVgCw7OUKNKFfvR+YOZY8jxALvNUTj8gToV/eeAphNDY3VXkeMkBXA5ablYPfgW2H/jJ0D8quhj6IXjOci1dJGShJ56sWEI9jKPbsNBqfS6I/cEK+ShY9yMolf9aTSku3SGn9R8Vi74HasP67b2L7b2T8TpoS/4IiARNKH3ojAcWRwQl/8H4uFi8AUL3TIUk9ovIvS3JxER7cDy6rVfnYuEr7lr6OcY63l3xSOIz5OGz5jCjEnNANu5U7T5YM26deXbNcoGZQXW6Ct/UySPQ14TQvo1CA5CuKWbd8a6wzN766tcpvM6qRp2NMvR51TgabSq33uZ/fmnru1FvgS0aWvLeTAjyNoi1a44KvOJjwAZF8P0075COhxoMV62bLEniErnfRnHGhk4KfXH/EMhrX+jqSfYPXR59mNS2eIsyTRTmIO25LPwii9ORBLAJcP4qlZjWfN5qSUjEJI+K+3DFrA4dS3OguitgSI5h5llSMBq8YFNaWbD4L0syB8x6GI84oYpQ/SGdoSd86kQr1ePlHtsqV4aWXZ7Ina4a6pOTblehwhtHyqBntcx0wsYWgPkdzE28xgr+eKVGOcIwaJTSoPZrRbN390DAVDB3kWXzycwec0RReN618j1koM+8VwytX3ptvf/dpKsbF1u7Jf0F+FV9kUUww4VciPqhPZtDwUFVUCz3u1Z60OHks9L8G79pKJfDkmQpBBaOWfZ74iKL7XuStNh0QOmmckc7NGIBDVCsHGxbvWA8OwKED+uS3l1HT3rp
 4YU6dzRK
 rycDCrMgb/hr4f6q0ISyFNAjbQr6KPrnH3lr8pVZzha37xxgBybsOwl+dF2U8Alk6z9chJY/GD7FianlrK9pTuWecki2qGbTVYQD/ldKPpSM0Wgfv8VAiQQsGgIDX3et9tDYq6mz0ucILfsAfXglDCqF8EE5e0oa7kSzO/Fc/fCNayDKaN6QXp42B7GBnSJDcpPw4xeXVDVFLSxMSI52UxZ/eIiPEGk7+RqSRU0YMcC++LP78TUZrft5kYqxBgOWoMUnwBPclQ5O0yPQ51nVRhz2LHbVHs4lN7CdBzM5xUi7N4IaI9UAbtcLQF+KFO9em6y7mhjch555ASMI1XvSqoxZXVUwz21Yt3UbbwMrUKtJvqQQzrVL6t+nnxfwWGPkPYPPx+LD4ioG+VTsc6NbQEn/EHOpUAEu0Y1eh7zfcjUhJ9ahFvAP0r1MFBCx9hoIC7loR6nDo1XxUwUbHHRe5Jdsmush1oRUvWx6QRSUY6x+xQchnBIWiKm85AcCWqNtJNGzNc/082cHxUZKbwYrzgZWjCeKuMXj5/64jeXQmPqKRV0c48VifLG2MUfc3OsyjXdDvm63JBRYbBjpV2eQDT+ojcP3M03ypcjZRg89O3XffaB9GxlNRYvroUg==
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


