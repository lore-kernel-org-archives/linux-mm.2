Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4464FC624D2
	for <linux-mm@archiver.kernel.org>; Sun, 22 Feb 2026 08:50:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A0E7E6B00B8; Sun, 22 Feb 2026 03:50:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9F9536B00BB; Sun, 22 Feb 2026 03:50:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8CE026B00BC; Sun, 22 Feb 2026 03:50:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 74C256B00B8
	for <linux-mm@kvack.org>; Sun, 22 Feb 2026 03:50:17 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3D1C313B3BE
	for <linux-mm@kvack.org>; Sun, 22 Feb 2026 08:50:17 +0000 (UTC)
X-FDA: 84471470874.21.BBD5D79
Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	by imf19.hostedemail.com (Postfix) with ESMTP id 4A4DF1A000D
	for <linux-mm@kvack.org>; Sun, 22 Feb 2026 08:50:15 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=MVUF4pfr;
	spf=pass (imf19.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.170 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771750215;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HqXt+gXrz4jwbWr1GpuXze54uGQtZjiwIpwqUhqliWw=;
	b=QkSz0T/l8KrK6vI3wD9IstvhXL4Iiq0SDv5DbBaZgj55DlYpy+Xgy8nVt7+qg2VvCcEm/U
	Jc38RTU4/TA8npYqpMI8dAzqYkfVMCLQ2r3BhT4TCaMxuGckRNnNJsB2pTpuXJAGAJCh9I
	j4d/ROjImhNi32LtxYBNa1RnLmrj68o=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=MVUF4pfr;
	spf=pass (imf19.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.170 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771750215; a=rsa-sha256;
	cv=none;
	b=HGbaDV9sjKSxzOWmCY9DQf0nu7OmvY0DQ6JieWHN5lZJ4RkfkPVovB76MxFpVX/2QTbXLg
	gPEGuBSU0fS/SmdPXp+rk1En3UA3da1uX337jZnGX9oPprymFY+kiiVu3sm2F12uTBlqcz
	sNKuzWKD2WLGBxCAj7WcdTNPRs0MdbM=
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-506a019a7f3so43594621cf.3
        for <linux-mm@kvack.org>; Sun, 22 Feb 2026 00:50:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1771750214; x=1772355014; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HqXt+gXrz4jwbWr1GpuXze54uGQtZjiwIpwqUhqliWw=;
        b=MVUF4pfrmN4qb395D9gUb1Nkpt2tnuEJgl51D8gxqcmHzJAobVyBqOdEMofLRkyFqO
         VEpyf5lxNpKwOW9OE6T36+5qg1zaRanKj5kyZbyKUgUrcEYMjdLG4qVw0MOaxK4KAEg5
         TklVoEkIenCLhHXFpQCMsI++OhKj3q6xD5hpIr2uEVTBS2IaCBX+sZ6ul7hlABjeNvOv
         z/A7Bj749b2a2TrPiI4lwKEPON6ElLV8e3lnzk7BXAy8jmCO4qVee9JAXCkXTMu35ljF
         dYK4WBYtKIlUtEWH4zINdk0Nmo8MtPXFDXMrjSbOZwz68InKhlhoGW8fWAJK42HJVAr1
         t9qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771750214; x=1772355014;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=HqXt+gXrz4jwbWr1GpuXze54uGQtZjiwIpwqUhqliWw=;
        b=JhOnIXA5l841gHg09jsG9PboePEWWdFNlCg6Gl0u7gM+eTGrv0csebWV24nB7WnEB3
         oPNfxmwzoAEzr/ILhjT7V0Ksu4YOeuYoYUg9j+LkMpC+SXn/ldWBxDtgeHoNage6EXYW
         SRzc+BK9xzXcdMsUNbwlEJYdy/Jhiv+4mECLiYGXjXi0fP/fCkN6lKJXWSyMBIXbojPt
         68hEX/3B5Y//3+XQp784kFgbReQ+c7mFiAxgCVJyJMcswOlcht8Q6h73uz+i/3O9IAuJ
         EJN4PWjU34u9xZGXQkSHRaRPx3Vdu8AvRpPoMk3R1efgxIDFuxnnXRUUyWtQe4D3fU5/
         lu1g==
X-Forwarded-Encrypted: i=1; AJvYcCW0O4L3Er5P0SOSKVeeRk5vhukvMP1skbiDSl4nNl0DuKO6fDW0f0DzKT//lRSAzAZbTFzdmv/kHg==@kvack.org
X-Gm-Message-State: AOJu0YzPnh6QFO//MFJ7Dgcb9XfvfrAMa4DxNadyqz4zOv8psaGxMpgN
	monhms/dWBTkZ4gUkjR7nL/6MbtCPpnCE3552+6tspE52b58FGJqnLicaFkYxJU9xbc=
X-Gm-Gg: AZuq6aJKGq1EQqlL3xFldHIzYk54HeF/3AVcoOApf6201x/scFpPdwwMbUyiXZTCq2o
	IT1BTq50FayAInMlC9cKcBq3Fs2aSAf0X843dhnmGtIiKNzV96YEv0lGziUG9XPHspAGB00ng8R
	yKSSP1AqSS3opIFc4vRNJP/VBwdQuqKjbTQYAnGxR5pcb3n8RIcKGXBTlkS3DICHiMJk8uUhRmR
	NJuOXfdQVGvuvJozNTqB+GI/h/3KEw2UOTMXqhdedEePJSI+Dg4E6Rcnf5YQvrT/QYCM4IirL/O
	hDRjSr0aJyqMjxx70hpqkNlNYPcGTlJZuV22mVFZ3JsauZwy2fB/UB+dO7VvR6eZsqfoy674rtz
	e9lY2dwm74yRNYlT77HyZ83ZMougCYJPL33NvfX4i3NMe8hbf63G9WIRR2ha64oxj8RUKG+aDZo
	QSGpfsxCTVoO/nddk0rlSwT8iCVUGRG1kG29B0Zxkjuc44wOPtd8wzc9Yi7HeJYQZ3Y4CdNHbTn
	e2FcdFXoynkRq0=
X-Received: by 2002:ac8:58c3:0:b0:501:4b96:466d with SMTP id d75a77b69052e-5070bc97e29mr62373271cf.50.1771750214354;
        Sun, 22 Feb 2026 00:50:14 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F.lan (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-5070d53f0fcsm38640631cf.9.2026.02.22.00.50.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Feb 2026 00:50:14 -0800 (PST)
From: Gregory Price <gourry@gourry.net>
To: lsf-pc@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org,
	linux-cxl@vger.kernel.org,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org,
	damon@lists.linux.dev,
	kernel-team@meta.com,
	gregkh@linuxfoundation.org,
	rafael@kernel.org,
	dakr@kernel.org,
	dave@stgolabs.net,
	jonathan.cameron@huawei.com,
	dave.jiang@intel.com,
	alison.schofield@intel.com,
	vishal.l.verma@intel.com,
	ira.weiny@intel.com,
	dan.j.williams@intel.com,
	longman@redhat.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	osalvador@suse.de,
	ziy@nvidia.com,
	matthew.brost@intel.com,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	byungchul@sk.com,
	gourry@gourry.net,
	ying.huang@linux.alibaba.com,
	apopple@nvidia.com,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	yury.norov@gmail.com,
	linux@rasmusvillemoes.dk,
	mhiramat@kernel.org,
	mathieu.desnoyers@efficios.com,
	tj@kernel.org,
	hannes@cmpxchg.org,
	mkoutny@suse.com,
	jackmanb@google.com,
	sj@kernel.org,
	baolin.wang@linux.alibaba.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	muchun.song@linux.dev,
	xu.xin16@zte.com.cn,
	chengming.zhou@linux.dev,
	jannh@google.com,
	linmiaohe@huawei.com,
	nao.horiguchi@gmail.com,
	pfalcato@suse.de,
	rientjes@google.com,
	shakeel.butt@linux.dev,
	riel@surriel.com,
	harry.yoo@oracle.com,
	cl@gentwo.org,
	roman.gushchin@linux.dev,
	chrisl@kernel.org,
	kasong@tencent.com,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	bhe@redhat.com,
	zhengqi.arch@bytedance.com,
	terry.bowman@amd.com
Subject: [RFC PATCH v4 21/27] mm/memory-failure: add memory_failure callback to node_private_ops
Date: Sun, 22 Feb 2026 03:48:36 -0500
Message-ID: <20260222084842.1824063-22-gourry@gourry.net>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260222084842.1824063-1-gourry@gourry.net>
References: <20260222084842.1824063-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: smhmdms9tkh5yk5xihrnwq814gnptzkh
X-Rspam-User: 
X-Rspamd-Queue-Id: 4A4DF1A000D
X-Rspamd-Server: rspam01
X-HE-Tag: 1771750215-237224
X-HE-Meta: U2FsdGVkX1+YFS5bKQdShncIZOv2hQ5Q+mbQVg0gfq+uiQJCbdOzSrv0Xr2JE9Ow+IzW3YEbolquloxhhuORCZnS5RDhmLlNNjDBxmQ7dBqGHL1rEFkcb+LuXgLVBoVbaGB7OacGrHZVzBCATquG0nGqaSjit9JRBIQBj6Sux2M8KcJzYlnWCUJNa6qduVzCOJJeC65+nUKGp0+BpKyZRYBLcRuC51vVkS28T/w/5VbbmiOHIt6jZsH9HXq0LomypXtLQ0ZQvRiU6bsjPEsl6SKtRJwHJfxtK7r4s7I6eB7yp1w9puDzXZEWt5B2RLlq5tdl9V5zVKdk924NRgMdPFur8OGNKjxovoDe3xuShXfA+lVMj3TYjzTAfr2nZ1MTIMBqT2MqwKsnVU0ocHMZokofW7i30d2QZSVlT1n220kn67c5Ywzp9iRikLMk0zUyrQXqHm+tl9D2N6zJcqqSAD54KLVceomkvEV3l1tOWy0C2HLrltfuypE5KdaJiPxR33RYryM5Sw4Q+zIOkHUAmZ4p6Z5Zcib/F4/uBfVL5ZH7280kUe5HojkdtVPPfqdv4ijLoAfFiL04pbNoPgZDNcApWZnJ2HKTrUJ30bQk0Yv5zRWYbbl6j6UYV9mX6d6Ua1NIkjBxcmiEGVJE9QW5yNuEmaLs/Z1EMgSQW1lbZCNzvXzQItwqAh6hzn4g7ihr31V3RxZXMEw5miW9/3wTRotI6YKBAjR/2xK6dC1EuyoTetL+ZR4YxqFaXIvp/wX+fQKtErvYzMSdmX3DqSMcpr4TGiOYUBgRnRBr+pA/ksOcj32gX9nwBhm2WqZDxWLKhBkY5EHVC726GCejD1vh7twDj3Zi0TMWSs0gmdhEZOnJpJpU2kZgh3Tzu9RAW6hgFuRmRUCsEyW62TLWDYuTNQfeO2NvVPlL5wP+0ej0b6eovIea2jRyN2Rt3ajh7S/IZn2UoiRW4ARBVLxvAz4
 s2bUw4tb
 fb30u4JQ+/9ifC//9D5oUKNZyzF9/jQ0CzHLohBfBqEvPMfkIzt6focTEUF8UZHR04dNRew7CxumJse9SyPHaIk4TnlvjfGxCNuqA6Gt5FaXijEWA+28RCKCDV4CvLsj7POpirjRbErjyDc+nZNqs49SC8OE2x1AjIPsgEv4Pk92XfRSk7fqaY6Dhr0xiDC3HBqzRQ3dOEohWpJsu3oJLnVnyNKYwFHKO9BXi/gJa8B1IP4ImdE81wT7dW67tZSdhUxf3j06wNvl8VM01VzMhl3N8ZohTZ+dmNsBTyOtPxWeYleWVzXixCMDPrKydtV2bqmdKjIojHAVC1dRaOdsDnTRrl2dvoczUPlfM2AH0S+BuLqMsE+EGUT6RM1Yx+AqFknZSHQpVpOswKmJ2HI9SlZNCBJ3npfkSIfH5FlDZ3EABPvM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a void memory_failure notification callback to struct
node_private_ops so services managing N_MEMORY_PRIVATE nodes notified
when a page on their node experiences a hardware error.

The callback is notification only -- the kernel always proceeds with
standard hwpoison handling for online pages.

The notification hook fires after TestSetPageHWPoison succeeds and
before get_hwpoison_page giving the service a chance to clean up.

Signed-off-by: Gregory Price <gourry@gourry.net>
---
 include/linux/node_private.h |  6 ++++++
 mm/internal.h                | 16 ++++++++++++++++
 mm/memory-failure.c          | 15 +++++++++++++++
 3 files changed, 37 insertions(+)

diff --git a/include/linux/node_private.h b/include/linux/node_private.h
index 7a7438fb9eda..d2669f68ac20 100644
--- a/include/linux/node_private.h
+++ b/include/linux/node_private.h
@@ -113,6 +113,10 @@ struct node_reclaim_policy {
  *   watermark_boost lifecycle (kswapd will not clear it).
  *   If NULL, normal boost policy applies.
  *
+ * @memory_failure: Notification of hardware error on a page on this node.
+ *   [folio-referenced callback]
+ *   Notification only, kernel always handles the failure.
+ *
  * @flags: Operation exclusion flags (NP_OPS_* constants).
  *
  */
@@ -127,6 +131,8 @@ struct node_private_ops {
 	vm_fault_t (*handle_fault)(struct folio *folio, struct vm_fault *vmf,
 				   enum pgtable_level level);
 	void (*reclaim_policy)(int nid, struct node_reclaim_policy *policy);
+	void (*memory_failure)(struct folio *folio, unsigned long pfn,
+			       int mf_flags);
 	unsigned long flags;
 };
 
diff --git a/mm/internal.h b/mm/internal.h
index db32cb2d7a29..64467ca774f1 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1608,6 +1608,22 @@ static inline void node_private_reclaim_policy(int nid,
 }
 #endif
 
+static inline void folio_managed_memory_failure(struct folio *folio,
+						unsigned long pfn,
+						int mf_flags)
+{
+	/* Zone device pages handle memory failure via dev_pagemap_ops */
+	if (folio_is_zone_device(folio))
+		return;
+	if (folio_is_private_node(folio)) {
+		const struct node_private_ops *ops =
+			folio_node_private_ops(folio);
+
+		if (ops && ops->memory_failure)
+			ops->memory_failure(folio, pfn, mf_flags);
+	}
+}
+
 struct vm_struct *__get_vm_area_node(unsigned long size,
 				     unsigned long align, unsigned long shift,
 				     unsigned long vm_flags, unsigned long start,
diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index c80c2907da33..79c91d44ec1e 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -2379,6 +2379,15 @@ int memory_failure(unsigned long pfn, int flags)
 		goto unlock_mutex;
 	}
 
+	/*
+	 * Notify private-node services about the hardware error so they
+	 * can update internal tracking (e.g., CXL poison lists, stop
+	 * demoting to failing DIMMs).  This is notification only -- the
+	 * kernel proceeds with standard hwpoison handling regardless.
+	 */
+	if (unlikely(page_is_private_managed(p)))
+		folio_managed_memory_failure(page_folio(p), pfn, flags);
+
 	/*
 	 * We need/can do nothing about count=0 pages.
 	 * 1) it's a free page, and therefore in safe hand:
@@ -2825,6 +2834,12 @@ static int soft_offline_in_use_page(struct page *page)
 		return 0;
 	}
 
+	if (!folio_managed_allows_migrate(folio)) {
+		pr_info("%#lx: cannot migrate private node folio\n", pfn);
+		folio_put(folio);
+		return -EBUSY;
+	}
+
 	isolated = isolate_folio_to_list(folio, &pagelist);
 
 	/*
-- 
2.53.0


