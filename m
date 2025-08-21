Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B266CA0EEB
	for <linux-mm@archiver.kernel.org>; Thu, 21 Aug 2025 11:46:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 82CBC8E0049; Thu, 21 Aug 2025 07:46:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7DD858E0048; Thu, 21 Aug 2025 07:46:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6CC8D8E0049; Thu, 21 Aug 2025 07:46:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 58E308E0048
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 07:46:58 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 220E913807C
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 11:46:58 +0000 (UTC)
X-FDA: 83800588116.01.2EE33A8
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	by imf27.hostedemail.com (Postfix) with ESMTP id E2C2740004
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 11:46:55 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="P6p/ayHK";
	spf=none (imf27.hostedemail.com: domain of thomas.hellstrom@linux.intel.com has no SPF policy when checking 192.198.163.17) smtp.mailfrom=thomas.hellstrom@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755776816;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eFIiyMprlR2MmnJeRX4zDdHUb7dx4/70XTTETptWuPA=;
	b=5VJEkkGbaEsFwDR7IqONxl559Q2i+oRgnGl/gQ8+ErBsKeRszQEYpAb4GHUSYaG+Jc+SxB
	QWw/neqfRL1gYWigqrtK5nU88DX+5JI2RcD84v9YDwoEV3O51m8Qj5zOgmigbxn5mkyb1/
	rxjqCVw7fG1ueB0BAW4dmwkDtxfPCx8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755776816; a=rsa-sha256;
	cv=none;
	b=UoHOTYRROh5wJO9NkEoTwnBxDuowVbZ821NxhXV5TIXSCW6Zsp43nBu6Ru7xUa36D+XrBj
	M6/9S4QrksrojAmX8wJb8Vq8qBMLg0L9GGvly4jzyq8iKcZ5PfLYsfai/dgGWd9LsXlFSW
	Tm0He22HotWTfpx9dfwE0+r4hDs/kiY=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="P6p/ayHK";
	spf=none (imf27.hostedemail.com: domain of thomas.hellstrom@linux.intel.com has no SPF policy when checking 192.198.163.17) smtp.mailfrom=thomas.hellstrom@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755776816; x=1787312816;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=zG9D5IJGziXZh5X5/ZDBlNBPklZZ3+iRqN2cmyda1XA=;
  b=P6p/ayHKWIOsGsiiZs0/jFO2i9hCmWlVCsaeIntVpBXoa7S3o+a79Zmn
   2mJjvtrl560bx2HKyxrFRB40lVhg95KMXQSIgwof4sbPkUG1M95OyujdR
   67ltos0SwsFipaU5ysVHlv0eYafPSdpMqImT/JLrtr44NzICKx9G/xJRL
   v171mt1K+NH4+lKthwBaTgyXTwiT/H+MAKbxbS4grAulke83nTJXRWDAa
   7Gw7cII3AUHQik6yNXN4QnE7ep/GcVmh0UAUEN6K4lDQaT4gh1OPrF3+m
   27CHbTMYe+GzFVnrQ/r8molb6gAuFk6rQm7Aopuvlr8sJrDa/xgUeBGQl
   Q==;
X-CSE-ConnectionGUID: BTv8+0P8QO+3oJr56DuZ+A==
X-CSE-MsgGUID: RyQmtu22TTyYuzx/T7calA==
X-IronPort-AV: E=McAfee;i="6800,10657,11527"; a="57989462"
X-IronPort-AV: E=Sophos;i="6.17,306,1747724400"; 
   d="scan'208";a="57989462"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Aug 2025 04:46:56 -0700
X-CSE-ConnectionGUID: qdZ++VWhTXucPh8rN3toAg==
X-CSE-MsgGUID: 4lMvbybTQVaYaBlBGfqb/w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,306,1747724400"; 
   d="scan'208";a="172613641"
Received: from johunt-mobl9.ger.corp.intel.com (HELO fedora) ([10.245.245.201])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Aug 2025 04:46:53 -0700
From: =?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>
To: intel-xe@lists.freedesktop.org
Cc: Matthew Brost <matthew.brost@intel.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	dri-devel@lists.freedesktop.org,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Andrew Morton <akpm@linux-foundation.org>,
	Simona Vetter <simona.vetter@ffwll.ch>,
	Dave Airlie <airlied@gmail.com>,
	Alistair Popple <apopple@nvidia.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 3/6] drm/gpusvm: Add drm_gpusvm_in_notifier_* helpers
Date: Thu, 21 Aug 2025 13:46:23 +0200
Message-ID: <20250821114626.89818-4-thomas.hellstrom@linux.intel.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250821114626.89818-1-thomas.hellstrom@linux.intel.com>
References: <20250821114626.89818-1-thomas.hellstrom@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: E2C2740004
X-Stat-Signature: b1pydr4m7nt5db9ad8yce4ptinjusequ
X-HE-Tag: 1755776815-519226
X-HE-Meta: U2FsdGVkX1/udhyHTAZm72RlJtsBJBtpEhfXv9q8LcRhwLCFyBPgWyCSyMwRfcHsQQsGy8SOQnGuCgUP39QSWMK29umI5KL40Z3oU4TnynDCfa4G8oZFbfU+v8crNOtbJvZcYZpcOnUir4QjQQt2MX1PSAsdE1voZNAPls37SM7KXMfxZZAgxOxY0DwCm6CJwM6jWlN7zgGVU9G3z3aXflI+wODzHuHDaGCZVxO6M2na3XDFWlwUyDRfCUtQKSAnna1GtWNOVPiGOvTspu3bT0qCnW944sBdtn2M28FiDGrP72z0LBaXhSWd64/rPbvwlOLT1O8wBrN5uREtG4bmp2bFtwKaaIB/LnsPCA4KeA96ZgmA0Ykll7eWMGqzV1/qJI9G6AonJWaNwD3DPdCOJ/POt9AVUABw5pyLECHrlD4tuQ/cU09knZtslL0uxRO5sSWAeKZWAGXdZrkOW3BSptJyrGsxAt8cmyrEJ24xcrxWAnjLCsaHg1y9fW/LKC+eLNS0fmYL3LqINKM/cWkILlBKUw0boVgeQP1taBdW0FE0pSl084pAae/SYd6348+wtyC8GRB58RrAanMd+OiNdiYVtUOKe0GztKeqOIfNWqlwX0O4ye/IDXZt6E2HJuJfJ8Yyf4IIB1ESVqAMhoPnF/LjjjqSxD0afDYGspSsJ4J57BjMqi2RdSEgIOlSZasQSanp1A2t/ZTcRBeE79Ju9Nxg/uAX5c9/VxDH5Aympz2E1Hn22rueuOXcUtpPYuz9Z6EmsfiQmcSXlQKS+CBmNktuQRp7apnTT0Ii2vDTsCnIWzObaiHxJpDqupeo0qHRujQEJcRAqps/Mf2mLQj9yVxPwV+Cx+Z/rjP/XWuWI4AQVY7TlFLgA4otmbMeHoCzETCgN+wqtO4CmDZ3RJ7ayD4C4qXXYI5LbBwLk86Q+TyvuDhMHPdm3S3nWU3n6utDfxJ7l/xBpMGFSt19tS1
 qeELpanq
 K8IydYTtRUKUfjKnqPyupNxwZ3rSdC+uVs7kfk7nU9b06r7LCR4yVVCgiFBE7YJjTJOc6ThqnxScsclQdJBb7f8aBxZ+E+pkekkpWi4VIS34jKFqzZCFqwGMRThPikgzEpt+Ry8hLp6z54zKDjGNto4AOImDwAJwBbuJRWeQK3VaFHa2EVMcJyihcugTOYWj0TKOGb7SYtrXAmIyiNDEkcyQLpUUVOHLsvIAxSa+iLfvpiouFkRIeEaeovPgrGROoJnQa+m2hdGFampEPcuSTpIsMegs/Do5Iq4EDh2LeC1usGjsyuRvtDhI03t7jN4nw20LWN9TXG54b+oS+JPnDZoyZ3mIBs2mE3yvPxNXXZbgU9Ps2Ozodu7UKpg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Matthew Brost <matthew.brost@intel.com>

Abstract drm_gpusvm_in_notifier_lock/unlock with helpers. Intended usage
is a client side 2nd pass of a MMU notifier.

Signed-off-by: Matthew Brost <matthew.brost@intel.com>
---
 include/drm/drm_gpusvm.h | 22 ++++++++++++++++++++--
 1 file changed, 20 insertions(+), 2 deletions(-)

diff --git a/include/drm/drm_gpusvm.h b/include/drm/drm_gpusvm.h
index 48b90c44849b..eb3f5f9396e2 100644
--- a/include/drm/drm_gpusvm.h
+++ b/include/drm/drm_gpusvm.h
@@ -313,7 +313,7 @@ void drm_gpusvm_range_set_unmapped(struct drm_gpusvm_range *range,
 #endif
 
 /**
- * drm_gpusvm_notifier_lock() - Lock GPU SVM notifier
+ * drm_gpusvm_notifier_lock() - Lock GPU SVM notifier, client side
  * @gpusvm__: Pointer to the GPU SVM structure.
  *
  * Abstract client usage GPU SVM notifier lock, take lock
@@ -322,7 +322,7 @@ void drm_gpusvm_range_set_unmapped(struct drm_gpusvm_range *range,
 	down_read(&(gpusvm__)->notifier_lock)
 
 /**
- * drm_gpusvm_notifier_unlock() - Unlock GPU SVM notifier
+ * drm_gpusvm_notifier_unlock() - Unlock GPU SVM notifier, client side
  * @gpusvm__: Pointer to the GPU SVM structure.
  *
  * Abstract client usage GPU SVM notifier lock, drop lock
@@ -330,6 +330,24 @@ void drm_gpusvm_range_set_unmapped(struct drm_gpusvm_range *range,
 #define drm_gpusvm_notifier_unlock(gpusvm__)	\
 	up_read(&(gpusvm__)->notifier_lock)
 
+/**
+ * drm_gpusvm_in_notifier_lock() - Lock GPU SVM notifier, in notifier
+ * @gpusvm__: Pointer to the GPU SVM structure.
+ *
+ * Abstract in notifier (2nd pass) usage GPU SVM notifier lock, take lock
+ */
+#define drm_gpusvm_in_notifier_lock(gpusvm__)	\
+	down_write(&(gpusvm__)->notifier_lock)
+
+/**
+ * drm_gpusvm_in_notifier_unlock() - Unlock GPU SVM notifier, in notifier
+ * @gpusvm__: Pointer to the GPU SVM structure.
+ *
+ * Abstract in notifier (2nd pass) GPU SVM notifier lock, drop lock
+ */
+#define drm_gpusvm_in_notifier_unlock(gpusvm__)	\
+	up_write(&(gpusvm__)->notifier_lock)
+
 /**
  * drm_gpusvm_range_start() - GPU SVM range start address
  * @range: Pointer to the GPU SVM range
-- 
2.50.1


