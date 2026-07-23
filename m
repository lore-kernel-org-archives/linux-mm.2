Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 27FFAC531CC
	for <linux-mm@archiver.kernel.org>; Thu, 23 Jul 2026 08:18:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 897756B0141; Thu, 23 Jul 2026 04:18:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8201E6B0143; Thu, 23 Jul 2026 04:18:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 624C06B0144; Thu, 23 Jul 2026 04:18:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 365376B0141
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 04:18:51 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B9091A0413
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 08:18:50 +0000 (UTC)
X-FDA: 85019340420.21.1E3ECBA
Received: from smtpbguseast2.qq.com (smtpbguseast2.qq.com [54.204.34.130])
	by imf11.hostedemail.com (Postfix) with ESMTP id 906FF40004
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 08:18:47 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=uniontech.com header.s=onoh2408 header.b=UpkNsuCU;
	spf=pass (imf11.hostedemail.com: domain of gouhao@uniontech.com designates 54.204.34.130 as permitted sender) smtp.mailfrom=gouhao@uniontech.com;
	dmarc=pass (policy=none) header.from=uniontech.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784794728;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zyZoSgcSvPZa4Lztf92xnmwggXjnsZ8IVuTRvt3SQnI=;
	b=LqyuhdbnXblPwA5SVBHBmJdnoFPASYm6RtQKcf4TFhoMhXzcDl0V2/MkSw8ZSuenvXGPAM
	dJoQ6tfL9JBdHrQksC3BescSE6drL0ug0EXnK0RR/lbhjX444rWB4BiBI58uhmtpSgjUa0
	WzkZI7raMa127snwvkpB3QqDSn7U1J8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784794728;
	b=cLGh/9x9zbHuCWKAMlvsSQ7rdkR5rbSNROCjNKp+BNIgTjwCN0jRCIGXUXmkLvRfrGV3ZQ
	VLKgpllKcrW3lPlOk6uAjJ3fEC9i5xNr3ORNtYRsfkVZ7edHOwo1WmqRlA/P+UeHZRKC0+
	DYw7BXScmQ3XKpXI6hDUzWxtBXPUroE=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=uniontech.com header.s=onoh2408 header.b=UpkNsuCU;
	spf=pass (imf11.hostedemail.com: domain of gouhao@uniontech.com designates 54.204.34.130 as permitted sender) smtp.mailfrom=gouhao@uniontech.com;
	dmarc=pass (policy=none) header.from=uniontech.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1784794723;
	bh=zyZoSgcSvPZa4Lztf92xnmwggXjnsZ8IVuTRvt3SQnI=;
	h=From:To:Subject:Date:Message-Id:MIME-Version;
	b=UpkNsuCUtrtNudpTAFqYYFjn0FZe4td/SMjTodR80pOcU2sQKcDMFUa98iDdCPMIn
	 M8/eyilvb0SxB4M7sCUSQomwBbJajadvfcGaEOQGUxnCgDlfcPfNTx/JLaFsah6DUO
	 kpefZwivzLOZwqMGMHSormhyHBWEP0AMUZKlQqFQ=
X-QQ-mid: zesmtpip2t1784794708t1baceda8
X-QQ-Originating-IP: p0+WvO88PZWVCksv0PxY0bE07sYlxrtU4deG1JLaxR0=
Received: from localhost.localdomain ( [localhost])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Thu, 23 Jul 2026 16:18:25 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 8067794102828428792
EX-QQ-RecipientCnt: 26
From: Gou Hao <gouhao@uniontech.com>
To: maddy@linux.ibm.com,
	mpe@ellerman.id.au,
	npiggin@gmail.com,
	chleroy@kernel.org,
	maarten.lankhorst@linux.intel.com,
	mripard@kernel.org,
	tzimmermann@suse.de,
	airlied@gmail.com,
	simona@ffwll.ch,
	bharat@chelsio.com,
	jgg@ziepe.ca,
	leon@kernel.org,
	akpm@linux-foundation.org,
	ynorov@nvidia.com,
	namcao@linutronix.de,
	mkchauras@gmail.com,
	sshegde@linux.ibm.com,
	nilay@linux.ibm.com,
	kees@kernel.org
Cc: linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	linux-rdma@vger.kernel.org,
	linux-mm@kvack.org,
	gouhaojake@163.com,
	kernel@uniontech.com
Subject: [PATCH 2/4] drm: remove dead WARN_ON NULL check after GFP_NOFAIL allocation
Date: Thu, 23 Jul 2026 16:18:11 +0800
Message-Id: <20260723081813.176792-3-gouhao@uniontech.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20260723081813.176792-1-gouhao@uniontech.com>
References: <20260723081813.176792-1-gouhao@uniontech.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: zesmtpip:uniontech.com:qybglogicsvrgz:qybglogicsvrgz5b-2
X-QQ-XMAILINFO: MmpliBmRb3iC13xU5PAjuxpB7P4eH1mJRWxLd8qJ4fcdCKaY0os0jtpQ
	zzscv8ZDaIPlrLVN712BBimZ0dhJx4jgtDohAKWGi/PdTDOmshRcXmay6UYMNPIjZu/A149
	CJEbHxDgYtxcVORW69NaRKWBkDsDmL4S8l1yd/lu4Gq0aAdiAcuqYmTL4q3zTHZZSJZxTSV
	yrrs6oo5AyDTHMTJJBsme0/Ii0CotI3VSem2/cTF/0mKvEutu42T5m5cJKtvM+uIIe6BIMo
	+xx/5sIpNK0d4DO+e/BLK4ELWQ/drdqfq6C1qRfT5Mva97rwnCyH7UxhoUJDSiYEHytYdSc
	zNDt2zbOin9Ws4yrW94GWxO6u8G+g+7VQNz5OTpf3HWRqSg9fE0bmAAB3KYlrJSt9y3NabS
	Td3VqyAupEiws1oUqFhirjiSfNo3DsAZGCK7MoetANqsvSgdoFVfOv3gIu85CvaE6Ghn9aK
	k9UOaWi37Jyu//coqmMofLyIOmCE+YIo5vC80qi2YRKwRaixfEyf3dytycJk3DaSPdJfJQB
	3YS9wA/BomcYoc7K+M+F9zT88BkTlm9ILC+60ODlt7upzL98Z8PGWp+fCx1JMIa7SmASprf
	YKmodWq4tVEfzVL/RhHk5GM/65yvwCq9wOhwX+qrR6znLeeupzG9RyrXiQXUdfRW/J+rX51
	XX2MPe/i6+bLWcoU4s20+JUETjG+Z+2ZSl8QsU0/HfTv650j8SUMyCmaQXFGuIUSVLvUjZT
	a19Fa/r2Rg+dx1MnX7SeDcNd/VopvKYSfDku2MLgy4S8fKIhCBraX01B/IujLgFd+ekisFf
	e7z90B61lUu8Kxne31uJL8ta341PDm+bqWUcq0u+ZKrqCNuvUbRd4fDkzJq9NJV8RofFCVA
	cHi86IIF4JlkPxVuEc9uMQXbljUQIwIA4zirL8qem8NoEQ+LVtr2atEeohOPnogD4gFtVHG
	P+8JzqUwAiBsCF6UJiFUehQM4u+B6pDe4O+QEeZTx09cv9D9n9WXsnW6HhcB0WQ2ThaauFf
	rE153uVZ9drKP1SAvLdlqkjmKdsYu2NXC4lhM8z0FTcWSWhDXHcaPry3OchEbGdXBXuo7Ml
	A==
X-QQ-XMRINFO: M/715EihBoGS47X28/vv4NpnfpeBLnr4Qg==
X-QQ-RECHKSPAM: 0
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 906FF40004
X-Stat-Signature: 8w3jtzzuwusf7a1dc1pwuegt8kk4hpeh
X-HE-Tag: 1784794727-135245
X-HE-Meta: U2FsdGVkX1/D+tOhvy4AfAufIm0LrvVIJrXCvIF8WsDm8r11Z7dbdV49OmnISGBBuMPznDPC2XRzQ34juzGn6UHWHmtTfLVic2vknAXv+PDaqgZxmbqj7RedO2VtCvsYinmZ2FYGA+WCG1+/2I/Op8GmekbL9syYwFLR0q0qcp65iaeOp3cQvY+LkBouxe9KzGAeu1JQxTLUKd04fKJR8AXlEGoYElPm6HWiuMwFvu52dG4Lp3gS9MOfS6K7kqPa1wcuOu6oPyesUPGvm8OYGX86EbIXdSBJy8GJ3EyChalXhqABqflBw7BOCAF0FyRQbC/L7IxMrIB+GOCQvWvc+Z5501ywRjNGYfSaujxGpNXs0oB2g/NwX0PRd9B41Ts+tWC+LuNqJXOmKrZrbkcmy6wUxGGwVrOp2DuQ4h4tDqGiew/U2YILTOJdPyBLRElba8E4I0boHGH6UQ4vENrMmkCUVgnLJxfhj7MqmWXqUB6OMfXHSwVib/FYQeDQ2IvRUzoQ02P/K7EeeXTXPLTfZ8gEPf1l6yh2fSZW9+wiuZRB3hdGhg5vtjEf6Gy4uI7I1pt7oBcmCFSv7UCAJSh6HnmgbBobS3YEbnVECHBFTQ5dukYmtzlamUxDCDLfKogC3K5//08k7FUdDfSogFoyrRmacr+7VrHcS2mFA1dbUz6gIQvt3Si3rFjcBYkEpgvGBRP9YjfZnt29k8cQNJDBLyuzPkykTcfXpDELfGldR/W8PKznfHXR9U5VgnB/rWj1A4o7nah1DUa01bJ7APWXWznuTICQCRf6yGXf6cEa/M9IuqHywK9SEMLaMcDhdPlKoeZ7wMA3dCOMYyTof9fQ/hKFbnRqVclbYeIU9uhLBmXG8QyVOBPqFVJ5kUpnxowVOK6ZSNah2FSAysQ1fnZL2ahFMnOymjkQ8tfNT2sayllcD0N5GDf3MGksx+wIe0KTOOS/9TPs+h/yDDLcBCU
 nzBDQo8c
 6OMdLsW3Wu1JLKg3KJ0ck0n/bzokGtfiHLzjDMe/37VpIl/jH/pYrnVmepavvlsIcQkWxnR1v3J7Y9bAqRFLrgocZA67kNL16Pl+NR0Y9PRqoV6QPMyP5YXVPfUTswHEsybKMxGqYCHwuRjy2wkDrBTFGUG1WJOm3vR5VWgn/ba4xUxY09eHbCLmtxzJtxIPhyua0TPeJBdbh1IchmnjvuHjD3asG+JHexxNcdpE4rPEzK2dM2/93Rw3YtLEHiY7sJ15ttwSQ67Y3R/EXsi4Yn9bzZrPN7clhMyPoc+nuekZNbq25lRoJJDWybkDV46ERmujM8JnVnARmNDIcEjLyKcApwNh3jg4mMMU5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

kzalloc_obj with the __GFP_NOFAIL flag will never return NULL, so the
subsequent WARN_ON(!ctx) is unreachable dead code. Remove it.

Signed-off-by: Gou Hao <gouhao@uniontech.com>
---
 drivers/gpu/drm/drm_modeset_lock.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/gpu/drm/drm_modeset_lock.c b/drivers/gpu/drm/drm_modeset_lock.c
index 2c806b0146d6..e14814c30d8c 100644
--- a/drivers/gpu/drm/drm_modeset_lock.c
+++ b/drivers/gpu/drm/drm_modeset_lock.c
@@ -149,11 +149,7 @@ void drm_modeset_lock_all(struct drm_device *dev)
 	int ret;
 
 	ctx = kzalloc_obj(*ctx, GFP_KERNEL | __GFP_NOFAIL);
-	if (WARN_ON(!ctx))
-		return;
-
 	mutex_lock(&config->mutex);
-
 	drm_modeset_acquire_init(ctx, 0);
 
 retry:
-- 
2.20.1


