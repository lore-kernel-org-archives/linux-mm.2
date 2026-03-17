Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EBC3AFB5EA5
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 02:51:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 284C76B0089; Mon, 16 Mar 2026 22:50:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 25D5E6B008A; Mon, 16 Mar 2026 22:50:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F06936B008C; Mon, 16 Mar 2026 22:50:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id DF5586B0089
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 22:50:58 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9D2011604B4
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 02:50:58 +0000 (UTC)
X-FDA: 84554027796.06.EB98E03
Received: from mail-yw1-f174.google.com (mail-yw1-f174.google.com [209.85.128.174])
	by imf12.hostedemail.com (Postfix) with ESMTP id D21CE4000F
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 02:50:56 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=P5OCs0mP;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf12.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.128.174 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773715856;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YtIBMXQB5r0gT6fB7kIdzkfYk2CIFHQnbepfnHEfiSo=;
	b=UoqjXduVLUvArZ+2A+WA4eHwb8b0tJPSJhSz0Vcu1ryCFRTfjuhNF46Nsee1ePNspXqE8Y
	1/wrHhpgK2viCz2jaFmLsoGBwa7xfrNvPVQTLjggqTAiOqZOrGCwuTb8Tb2RGFvGaH8El+
	p3ponf+U2R8xB9lFJ1ATC7HjYhx7gt4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773715856; a=rsa-sha256;
	cv=none;
	b=AHKGJrJFyxzg3j5aDmCdKXETjC7ZbkkMH+q4WdtFGMxZ85fRh8AZ24hczt/2l3VtBfzzTr
	NYiHJrGxRjBUPYR4Gr/20a0ECLaidKMU8r5HmZ7jYq/Woel1Jw/DjWXX9pzBHIyGxM6zX1
	Pxc3LW1z+7KcV1cBj+y8V3ghtSkZXE4=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=P5OCs0mP;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf12.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.128.174 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
Received: by mail-yw1-f174.google.com with SMTP id 00721157ae682-79a51edef1fso5078617b3.1
        for <linux-mm@kvack.org>; Mon, 16 Mar 2026 19:50:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1773715856; x=1774320656; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YtIBMXQB5r0gT6fB7kIdzkfYk2CIFHQnbepfnHEfiSo=;
        b=P5OCs0mP7IKjkgGRQrshksRpTCfqJVgEzifN7vb8JTfNMfvS7mPSxiVH5sMIF9Zn51
         wIqRhMSV+OzmdKpmL2eBc2zpHAWtLK3zoa180lnuTN8trOqMzp1QHm2hiANxIo1Pl9ug
         3LM60MjLoGEfR1QVHBTw4FE+CxwuYp4ABSaLgxNdiuFlwpQV41+MugE9zxN7iqZKVuWy
         Y9cyUOzn36z4v18mJAICcd5iIrjK+SVDr7eAgeUE+kQ17wO4OeKOTBZr03iEF9m09ULl
         NpzONm4DE+DABaKGYgT35S1W8TWWs1hcujHZOhpa1644mRetE2vxrTgOzwHf6gmRHRWh
         57gQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773715856; x=1774320656;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=YtIBMXQB5r0gT6fB7kIdzkfYk2CIFHQnbepfnHEfiSo=;
        b=VqwDWA3sqwDNvzp28iDY/lOr4X9E9L0ieNsSpNXjXcpXUlgivnjii68U0Ard/+5fcs
         ED04b4rt0UWFcYuBZdWyR6xZaIV7YNwqkqfBEJITUs9kJA/cIP+GzNuwXY3B8FtRIVMN
         uFx9nO2bodKifpGgjg4n5NgPZrtCw324mWD2JQLF239PD0byXReUDR6WxHjk8utW8vM1
         /q0qq7Nyea9jQ1sJcsie0OxM61PnBOSU/Jv2rN1cYamQXcETnrfjYJUK30uDx0W8i1wF
         TpmyMu+zt9/hTFezBqg5huGm0ZC2XdQ6AiLWgJHmrWhfBwa+jP1dTBEs11vWYxekjD5p
         aJCA==
X-Forwarded-Encrypted: i=1; AJvYcCWu6T0UaGsH01lNV7CdbfRvc4eULYwbTQxSfDy2BBWWZxY/pJcm0ndVbSq9wSRNyxfouRWHsw/Dfg==@kvack.org
X-Gm-Message-State: AOJu0YynV0UFKizKN36G5T6uDklSOflXJpll9rYT9iZ68sucPifreWOb
	VGF7uYrs84EP2EuCRigEOV/mr7dEaJ/ZQieRQEQBvYUwuIhiOiY8ySEjfu4OyCn0wXY=
X-Gm-Gg: ATEYQzxufJgdZYHaorjcYETUrXFWGkxDilrvkCk5VPbNydI7VfFXpJ1ADxCsW8Q8QWQ
	Al1aWhF5AV85IxB0zYVRWDVFFmNxg+BK0ec0F3CELEnm0wAIrNfkxIsLCPcsiKAsYl9LLuEYvFM
	1OuX4l0P1MAjSaCMdyEnlWOJfyPzdYAyGHItU5nnLWy9pJ9p7RIAeX6iekvM9+DGVqrrw1hdjHe
	AoejDiA/sJxx5wyy3URik12Mk3rMxSJXE1UEdvvQ/KmRVJUU2zUbXVcedTty9B5kfmtknEDDIwc
	HGSldD1lsS/o3Fe440uSI5ltldF5BUEtMAHzpxfuRRWwG/QrbBhUh5eXgIhLzTwOLiPWtsg4k8H
	JR8g34E39z5eY9ZL6w2Gn+8DKBjNgdQmwb64/vzmdty/mZvp++WqlpiBaFRcceQylJxQ9t+G8fr
	CcVCCEP6/1gOJ7Qs9ZUFnHQmLKLkX6KcDETHjcfBgbyo9CZPgjncWWrsuJ27gkVj+9VEVrOLcgP
	JNgtSwws8PRIS21lWQFCdgJwTyC2id9sPdzhFkPjYXD1tpJUQ==
X-Received: by 2002:a05:690c:67c7:b0:796:335a:895 with SMTP id 00721157ae682-79a61789c43mr17250767b3.6.1773715855932;
        Mon, 16 Mar 2026 19:50:55 -0700 (PDT)
Received: from soleen.c.googlers.com.com (57.233.150.34.bc.googleusercontent.com. [34.150.233.57])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-79a5a866c85sm14951757b3.35.2026.03.16.19.50.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Mar 2026 19:50:55 -0700 (PDT)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: pasha.tatashin@soleen.com,
	rppt@kernel.org,
	pratyush@kernel.org,
	linux-kernel@vger.kernel.org,
	dmatlack@google.com,
	akpm@linux-foundation.org,
	linux-mm@kvack.org
Subject: [PATCH 2/6] liveupdate: Protect FLB lists with rwsem
Date: Mon, 16 Mar 2026 22:50:45 -0400
Message-ID: <20260317025049.494931-3-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.53.0.851.ga537e3e6e9-goog
In-Reply-To: <20260317025049.494931-1-pasha.tatashin@soleen.com>
References: <20260317025049.494931-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: D21CE4000F
X-Stat-Signature: th4z5g9ypb8dbtxmmrkbtemhocpogjfr
X-Rspam-User: 
X-HE-Tag: 1773715856-338668
X-HE-Meta: U2FsdGVkX1+LYMHNmUneVIxdGJOuKyrJCJyPRQKmi21RQGaaB6B+Jku3Bj62Z5qlCPY4XM8ZeUzavI6DhtU5sUo3fF3Ns9iIskrFh2wkNhAkLn4XAlH50wiRR2iSxS7wRE4nyHFRdgKodniuISnxHVMc3FJFZ5vy4DDbuyUT+1BbengGwMCPyg36HssIvGV0TFzeTjDob94K07mc6eKIsB6IbV9T7FlOPEIF4P03AWbOSP74JatJf2tMCT28BIcOwqO0LmCevifAdEEAXS8iVRGzOhmp1s96C8zXDPndNRA2exfsnFkaGcC0X22xphl1zIkxOk73VWUZ38cb9JRIuX+0k1GC6o3NZGnWhu+jkYG9KYO0KDeoRbpJiBM8lPtW1HP8Xt2Lqv1tXzZDcKSLts0CKOe35H+ysSbp+Ka5aRUeb+PneSAFEdfvrdvZw7A7M+yaty6wyxYwj+Al0CY/HXJwD7sVusf+UMQG+omysyIa/Aug9YdXmEko8GhYYQ2zXLHMdctiQeeCE2VeSw1CMGF+qX5PI7Viem8zCvV+5c3JV1j/eGPzDWVE8RIqTKahrkfIozQrxH3rdf21ljHpP9vQx07mVON6gNh+jrQRDTJO69xlZthmqxxyQhCvFbrMkl+FsEO1mq8PeKWojnTlmTrIW7aSrADT7Um/030YaoaNXk8MG/CyURhL7cNmAOmByfGTviQfJn0l8pfDq0HjoypIekNkQNmoEAYVOjGtIDrD6iANQasFTzO3aelXRey9uzzjLklFCHPhWJSZ38gKAfR33/2Yri6O6i/n+ZttWRNj9s/LbPcMzcsGNdswzDdcvvx52CniuwwqvgqHxouwKfx29GVbFR/U3luLY7Z8K4XY37caqu2s88RanbEFHjqW18/HojLu5cMPSuHAn5WgoVdZ7G8CNrsBrpEz8XKGOx6NcOC46DwdKQt+2u560qOEmTqtb/Ci7Z+3VdtVJJb
 F6/RFvtu
 aTnHDQQdE5W8e0KhBYNwokME7+/GodiLRiFzAZqrOx7CjE5/3IkZVc+O3axtsgvln+1mQABgebdPmNplJpI8/6mXeVw1SKOvqCAHHNoBqSa4TfU0LeiPQsyq64AQjaJQJuMTiChZ1h5nAcnYv3ej0ulvuZpOuDAPdBmMuSJAAKRviUYwJOXkQ1hkPpT60pnfzfJYq8Y4lYRsUbfX5fBeCBm2tdqgdp47mkiWfJy+iCsXG+7Mzw/BABfLcH0vcw4qLXfTsVdD56z8MyvliKWU1nVt7HxDMne2OjAA0e9SXS9+gWQwNi8bC0p/QHOg0PquONVBS3Xq3rSqm6XFisy+BErRrsZjC/T6SNNUQrJ+1vqCSmm8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Because liveupdate FLB objects will soon drop their persistent module
references when registered, list traversals must be protected against
concurrent module unloading.

Introduce two read-write semaphores to provide this protection:
1. A global luo_flb_lock protects the global registry of FLBs.
2. A per-handler flb_lock protects the handler's specific list of FLB
   dependencies.

Read locks are used during concurrent list traversals (e.g., during
preservation and serialization). Write locks are taken during registration
and unregistration. When both locks are required, the global luo_flb_lock
is strictly acquired before the per-handler flb_lock to prevent deadlocks.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 include/linux/liveupdate.h  |  3 +++
 kernel/liveupdate/luo_flb.c | 16 ++++++++++++++++
 2 files changed, 19 insertions(+)

diff --git a/include/linux/liveupdate.h b/include/linux/liveupdate.h
index dd11fdc76a5f..8394fb2d8774 100644
--- a/include/linux/liveupdate.h
+++ b/include/linux/liveupdate.h
@@ -12,6 +12,7 @@
 #include <linux/kho/abi/luo.h>
 #include <linux/list.h>
 #include <linux/mutex.h>
+#include <linux/rwsem.h>
 #include <linux/types.h>
 #include <uapi/linux/liveupdate.h>
 
@@ -107,6 +108,8 @@ struct liveupdate_file_handler {
 	struct list_head __private list;
 	/* A list of FLB dependencies. */
 	struct list_head __private flb_list;
+	/* Protects flb_list */
+	struct rw_semaphore __private flb_lock;
 };
 
 /**
diff --git a/kernel/liveupdate/luo_flb.c b/kernel/liveupdate/luo_flb.c
index f52e8114837e..91910d806d1d 100644
--- a/kernel/liveupdate/luo_flb.c
+++ b/kernel/liveupdate/luo_flb.c
@@ -49,6 +49,7 @@
 #include <linux/liveupdate.h>
 #include <linux/module.h>
 #include <linux/mutex.h>
+#include <linux/rwsem.h>
 #include <linux/slab.h>
 #include <linux/unaligned.h>
 #include "luo_internal.h"
@@ -70,6 +71,7 @@ struct luo_flb_global {
 	long count;
 };
 
+static DECLARE_RWSEM(luo_flb_lock);
 static struct luo_flb_global luo_flb_global = {
 	.list = LIST_HEAD_INIT(luo_flb_global.list),
 };
@@ -240,6 +242,8 @@ int luo_flb_file_preserve(struct liveupdate_file_handler *fh)
 	struct luo_flb_link *iter;
 	int err = 0;
 
+	guard(rwsem_read)(&ACCESS_PRIVATE(fh, flb_lock));
+
 	list_for_each_entry(iter, flb_list, list) {
 		err = luo_flb_file_preserve_one(iter->flb);
 		if (err)
@@ -272,6 +276,8 @@ void luo_flb_file_unpreserve(struct liveupdate_file_handler *fh)
 	struct list_head *flb_list = &ACCESS_PRIVATE(fh, flb_list);
 	struct luo_flb_link *iter;
 
+	guard(rwsem_read)(&ACCESS_PRIVATE(fh, flb_lock));
+
 	list_for_each_entry_reverse(iter, flb_list, list)
 		luo_flb_file_unpreserve_one(iter->flb);
 }
@@ -292,6 +298,8 @@ void luo_flb_file_finish(struct liveupdate_file_handler *fh)
 	struct list_head *flb_list = &ACCESS_PRIVATE(fh, flb_list);
 	struct luo_flb_link *iter;
 
+	guard(rwsem_read)(&ACCESS_PRIVATE(fh, flb_lock));
+
 	list_for_each_entry_reverse(iter, flb_list, list)
 		luo_flb_file_finish_one(iter->flb);
 }
@@ -355,6 +363,9 @@ int liveupdate_register_flb(struct liveupdate_file_handler *fh,
 	if (!luo_session_quiesce())
 		return -EBUSY;
 
+	guard(rwsem_write)(&luo_flb_lock);
+	guard(rwsem_write)(&ACCESS_PRIVATE(fh, flb_lock));
+
 	/* Check that this FLB is not already linked to this file handler */
 	err = -EEXIST;
 	list_for_each_entry(iter, flb_list, list) {
@@ -444,6 +455,9 @@ int liveupdate_unregister_flb(struct liveupdate_file_handler *fh,
 	if (!luo_session_quiesce())
 		return -EBUSY;
 
+	guard(rwsem_write)(&luo_flb_lock);
+	guard(rwsem_write)(&ACCESS_PRIVATE(fh, flb_lock));
+
 	/* Find and remove the link from the file handler's list */
 	list_for_each_entry(iter, flb_list, list) {
 		if (iter->flb == flb) {
@@ -638,6 +652,8 @@ void luo_flb_serialize(void)
 	struct liveupdate_flb *gflb;
 	int i = 0;
 
+	guard(rwsem_read)(&luo_flb_lock);
+
 	list_private_for_each_entry(gflb, &luo_flb_global.list, private.list) {
 		struct luo_flb_private *private = luo_flb_get_private(gflb);
 
-- 
2.53.0.851.ga537e3e6e9-goog


