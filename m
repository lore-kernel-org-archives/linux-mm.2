Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 88D8EF531C3
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 18:51:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 629FD6B0098; Mon, 13 Apr 2026 14:51:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B4566B009F; Mon, 13 Apr 2026 14:51:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4F13D6B00A1; Mon, 13 Apr 2026 14:51:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3DCD16B0098
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 14:51:38 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id EEA5C139DEA
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 18:51:37 +0000 (UTC)
X-FDA: 84654426234.26.E65EB3B
Received: from mail-qk1-f172.google.com (mail-qk1-f172.google.com [209.85.222.172])
	by imf10.hostedemail.com (Postfix) with ESMTP id 1D635C0008
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 18:51:35 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b="LEujzF/2";
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf10.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.172 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776106296;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s51LS+4jC7M5tW3ZiOQ9JQLKwRmBqtdDOu+VdfBPYzE=;
	b=Fe/eadiDDxaGzUGXMMzjpoilfRssCoBLSDukqES+sL0++DeSpweOqEUzf3j5RLWDizXkb8
	7RhBycfpQTIuy2U9T+tl34L4NVZ0jp+Lc5LXONJgTF5p8XQMO5/NtKidZn6HmgDdCSPkbT
	Q6F6cvvZ9WeXfixh3ovG69i3BdyZmSk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776106296; a=rsa-sha256;
	cv=none;
	b=x8y3Qrrkl7zsjazKdhpLw6yAVYXlREybuQ8FOAyVgc1gaE/caBggjS6gU+TpDl4CgSFJyI
	loyUaGWYOvs4kJ9QK/xFaWJXMbYsFQoISYqZB6o5YEd1Y7UoEokvkpeCnPS6tzn6XmyAgn
	TPqh6NpcHGr6ryN2Tw/9FUoS6CMCk4s=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b="LEujzF/2";
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf10.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.172 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
Received: by mail-qk1-f172.google.com with SMTP id af79cd13be357-8cb5c9ba82bso730568685a.2
        for <linux-mm@kvack.org>; Mon, 13 Apr 2026 11:51:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1776106295; x=1776711095; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=s51LS+4jC7M5tW3ZiOQ9JQLKwRmBqtdDOu+VdfBPYzE=;
        b=LEujzF/2eIkbPdUEoGCNGgAHNaCcoETdlZ1azc3sCa+ShN5XBzO6PsbviZwYsU+buN
         AvACkb9FzDk52iK1/yohm7anVYN1z5MdVp/nVXo4d/dVMBE/VV13IOATm1/KTg2Awac5
         Ug3WVo8zEr4cn5L3sg28PBNHmfrmc4bmCh5gLosYonyR5kiRodFudosD6fVHB4AsdF3N
         7xRHu4eUd1AEY21vkWq9UK2pCtRGxsuhMmMRuWweumw7wnQBTy7fkE8mSHftJ0ZqvmO1
         FSrlHionn+eqXWOyjOi4sZhfvAV+n+2KqMnxKv2cEFiQkFiGQplyMUxBtfMK+eYbWYpc
         O3ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776106295; x=1776711095;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=s51LS+4jC7M5tW3ZiOQ9JQLKwRmBqtdDOu+VdfBPYzE=;
        b=fp9v+6lfVVvLFrSLrYRX+Z75ZICEAaXpFfq4pKE/4hw/L/pr69k5xPkF09uNNraRqr
         7Jqsxu2h+pjAssV5nJIJglsRoG6b7PjG+QxMsUG5BbrXvq9LDV9NEci6P0yUMr0DP+0J
         B9XPkd4NIe2u/CGFm5vf05+8cLJ7DHXJLnedeBajBrRVPM6rfHU92vEg7ywNtMJQ114K
         pzrYnFyI/ysY9817Ip3GNrOMyixGTZKGQFFDnmTfXk+7uxEKe9A7e1NlHXh5L8Hae48i
         HQ34DGera9JvdL+WxJ7WQWFfxb5rdp8p5HSKCg0yALq1+TKq+GvJz2nJ9TpQjlmUcJeX
         47Pw==
X-Forwarded-Encrypted: i=1; AFNElJ/+1nHxTvsEP/mltLoYuYDDWgjr7hLTkbRHGWFqGLoGQ1ONMUmM43axsTNcb4QheM03sb/p7LdK+Q==@kvack.org
X-Gm-Message-State: AOJu0YyOhdQTkJsIDMyRzR4xVFGWkYBULNjM1BKeYtIAD8PFeqEyuboU
	A/sMK5XbQc4Jwo/AwXdLSwEC6WVxVnhyzrPlHkvyMglS9n6gGz2V3MCPdb1e/mxk6GDxtNqiYr8
	jVDGA
X-Gm-Gg: AeBDievVcmLswFUrMHg6obeBf64VTKarNTMU2B0vMfKEAYzeR+hqOqcHIxU18RsbxGB
	aG4afqgImKnx3xGvYTfysjHWsa8SNolEGwL6UexHLxIwa6DM71lmInwxM5ZAqS/ZwsyDeGTF/NS
	Znw6M1dBz2kYr4Ah4zcs5uYKdgBxCTFTSiLVUGMDef5uMjI+7exaksZz/f5+D9v/8gBmx6lfzcX
	0KKDY8EtfYUPO6L7FwoXQWtyfw/cc6r+kgFYCTbpR9Pd8KA0tlEemJyYaUwQkNARv6lnaJt7h/H
	y+fyJ0hoI4shEk2dICvVcIsJO39IEqrgHB5L6zSKbEa3d0eyk3tHcDfbJQ4T83lRd2Ch/a+1sXL
	/DH5A2f8nJhOq8OGsonJWm1G4QVPv+ne5AgBjy8pQv2wgZ+CXxiG57Hw+flH6BAzgwPWpQRrH/Q
	5/jNWbEyCF4ruNGZehHkt3ZgbwrHnFMJptph6SH2nzB+dR2wAnBcZGBbdjOvLiovkZsw==
X-Received: by 2002:a05:620a:690f:b0:8cd:bffa:655 with SMTP id af79cd13be357-8ddcecbc94amr2252986585a.38.1776106295061;
        Mon, 13 Apr 2026 11:51:35 -0700 (PDT)
Received: from plex.localdomain ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8ddb6372790sm943206285a.12.2026.04.13.11.51.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Apr 2026 11:51:34 -0700 (PDT)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: rppt@kernel.org,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	pasha.tatashin@soleen.com,
	dmatlack@google.com,
	pratyush@kernel.org,
	skhawaja@google.com
Subject: [PATCH v4 04/11] liveupdate: Protect FLB lists with luo_register_rwlock
Date: Mon, 13 Apr 2026 18:51:20 +0000
Message-ID: <20260413185127.128180-5-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260413185127.128180-1-pasha.tatashin@soleen.com>
References: <20260413185127.128180-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 1D635C0008
X-Stat-Signature: rc6tuffa6umhq7jt73brwin5ekj7xbxz
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1776106295-915158
X-HE-Meta: U2FsdGVkX1/yb4AzU6Zf0uOe+3HAIzGP2VEU4H72uGhfZbH7w2GhqG35g2cNxy5zVe3JtnU1VTNYm+Q55xUgyCetzJ1Dw4LxuE3hi8Bj8in5SU44G3xeDDN8y0c12lx472fHO3/Eo/eJsW3Tf7Jjp6+QCOjhR8wBzzoUUA19L38Uodp16P/Yuolg8euXVRdd9mL0qwa/Rm1S1Ji/RRrktCI1DRyL7owVy72hQWOyUHEiBs/ElpvmC7QSdkSrxgmM2oT8+08WsVzQ4N4aa450AfKiJ1Jd5SYgiO3Vt8jjLfMaD1EtlY+uf/3q2TY3ECa2K58HDuq9+vih39OHggFuBK8V10HEbD46vCc30vw7tplRxRDQ+laeHUy+cT+NV+Oj0cjxbtGKkol/GcmT7NfHEP+kZskb9KNpSae4KRdsHqCqHIbKlEun9gmJ1ecmnpXkYrIWnyZS4Zmtn1Teqtgi1R4Hy47SFUqrPXDVHv7zS7irOLWngYf3VyITN55FGloXMBHdj2MmtKOPv0jQ006bfHrRvihTbA6rOetluaTBwymQHpE57ah4vfo++pkkhY3JAVd9dLHWLcGuk7xTZaZjez/MDzAHkGqiAPjQqO+f8efRKt43FZNdZu9lTGMZHUQO2rNF8U4THS+lsiT+yK4XsQ1YWNUs1xiaGv5LxGm5W69z66VtdgEsodzfbca6eTKzUT18npbiu8sJsPF3nUVOP5GEt+AnZlxQ4TBuY07Sa5TpwFut5UKNlIc4tnRJlLvCYq7FwYH0T3IGil3S0+cgzs6/o0WAJbrjbenPfI0bj2e2Xb0Z4G3K4PDkAYxfsq5EudtQQ/mLTrpy1EDN1QMsRXK3u2rutUK9yp+rWVzIxiyp+Ei3s6gHrXMKpyolh/CLO5Zynv/91sMIfP7bQz3mPUZ6HGOgT1Nkl26fIdJA/+l6UkdSp+e7Fi9Vl0cKWoLaSbePvjV4QSaeUlSXxk5
 SxNOuPy0
 OtRBMuEPl50sT5mxPQluyl2kqmq370xZQkMa+GjrZ3TIxre7E3XnCJeCjAlR+iSzsgX3g3sn0XaMPoRXCIMdVLcwdYpSQK9EJm4hbx514hJFiAtsPOxutDRntk/7ZcZDEh1GzYUOLQS6TvZsIvBhpqjh5a9LEHadGMRY9fVH0eh8N2CHvSHYHq/vAsYibjASJe2U5/T67LJTa0i1eEdOiBFxxgwUQejLWwYw6v9tlrUo/6m53lOOAR8XxxeHfPFd2u0nYtu0I+6XO3W+E0Y0365X15+QLpkJ+Fy7K/Ilbq6oQb0dssgFRwZoQTu0oK0TNwzSlyf2xnAy/6sOVQv8rULxTXVDdP1jZW0enZsl3tvga9DjfbyrDIRO98WtHxxZrqmw5Da0EvEKquKgh3PNKlFxW2jl/4VxAv6GnUeKWrq1u1wU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Because liveupdate FLB objects will soon drop their persistent module
references when registered, list traversals must be protected against
concurrent module unloading.

To provide this protection, utilize the global luo_register_rwlock.
It protects the global registry of FLBs and the handler's specific
list of FLB dependencies.

Read locks are used during concurrent list traversals (e.g., during
preservation and serialization). Write locks are taken during registration
and unregistration.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Reviewed-by: Pratyush Yadav (Google) <pratyush@kernel.org>
---
 include/linux/liveupdate.h  |  1 +
 kernel/liveupdate/luo_flb.c | 14 ++++++++++++++
 2 files changed, 15 insertions(+)

diff --git a/include/linux/liveupdate.h b/include/linux/liveupdate.h
index 61325ad26526..9c761d9bacf8 100644
--- a/include/linux/liveupdate.h
+++ b/include/linux/liveupdate.h
@@ -12,6 +12,7 @@
 #include <linux/kho/abi/luo.h>
 #include <linux/list.h>
 #include <linux/mutex.h>
+#include <linux/rwsem.h>
 #include <linux/types.h>
 #include <uapi/linux/liveupdate.h>
 
diff --git a/kernel/liveupdate/luo_flb.c b/kernel/liveupdate/luo_flb.c
index cf4a8f854c83..fdb274410e8f 100644
--- a/kernel/liveupdate/luo_flb.c
+++ b/kernel/liveupdate/luo_flb.c
@@ -245,17 +245,20 @@ int luo_flb_file_preserve(struct liveupdate_file_handler *fh)
 	struct luo_flb_link *iter;
 	int err = 0;
 
+	down_read(&luo_register_rwlock);
 	list_for_each_entry(iter, flb_list, list) {
 		err = luo_flb_file_preserve_one(iter->flb);
 		if (err)
 			goto exit_err;
 	}
+	up_read(&luo_register_rwlock);
 
 	return 0;
 
 exit_err:
 	list_for_each_entry_continue_reverse(iter, flb_list, list)
 		luo_flb_file_unpreserve_one(iter->flb);
+	up_read(&luo_register_rwlock);
 
 	return err;
 }
@@ -277,6 +280,7 @@ void luo_flb_file_unpreserve(struct liveupdate_file_handler *fh)
 	struct list_head *flb_list = &ACCESS_PRIVATE(fh, flb_list);
 	struct luo_flb_link *iter;
 
+	guard(rwsem_read)(&luo_register_rwlock);
 	list_for_each_entry_reverse(iter, flb_list, list)
 		luo_flb_file_unpreserve_one(iter->flb);
 }
@@ -297,6 +301,7 @@ void luo_flb_file_finish(struct liveupdate_file_handler *fh)
 	struct list_head *flb_list = &ACCESS_PRIVATE(fh, flb_list);
 	struct luo_flb_link *iter;
 
+	guard(rwsem_read)(&luo_register_rwlock);
 	list_for_each_entry_reverse(iter, flb_list, list)
 		luo_flb_file_finish_one(iter->flb);
 }
@@ -360,6 +365,8 @@ int liveupdate_register_flb(struct liveupdate_file_handler *fh,
 	if (!luo_session_quiesce())
 		return -EBUSY;
 
+	down_write(&luo_register_rwlock);
+
 	/* Check that this FLB is not already linked to this file handler */
 	err = -EEXIST;
 	list_for_each_entry(iter, flb_list, list) {
@@ -401,11 +408,13 @@ int liveupdate_register_flb(struct liveupdate_file_handler *fh,
 	private->users++;
 	link->flb = flb;
 	list_add_tail(&no_free_ptr(link)->list, flb_list);
+	up_write(&luo_register_rwlock);
 	luo_session_resume();
 
 	return 0;
 
 err_resume:
+	up_write(&luo_register_rwlock);
 	luo_session_resume();
 	return err;
 }
@@ -449,6 +458,8 @@ int liveupdate_unregister_flb(struct liveupdate_file_handler *fh,
 	if (!luo_session_quiesce())
 		return -EBUSY;
 
+	down_write(&luo_register_rwlock);
+
 	/* Find and remove the link from the file handler's list */
 	list_for_each_entry(iter, flb_list, list) {
 		if (iter->flb == flb) {
@@ -473,11 +484,13 @@ int liveupdate_unregister_flb(struct liveupdate_file_handler *fh,
 		module_put(flb->ops->owner);
 	}
 
+	up_write(&luo_register_rwlock);
 	luo_session_resume();
 
 	return 0;
 
 err_resume:
+	up_write(&luo_register_rwlock);
 	luo_session_resume();
 	return err;
 }
@@ -643,6 +656,7 @@ void luo_flb_serialize(void)
 	struct liveupdate_flb *gflb;
 	int i = 0;
 
+	guard(rwsem_read)(&luo_register_rwlock);
 	list_private_for_each_entry(gflb, &luo_flb_global.list, private.list) {
 		struct luo_flb_private *private = luo_flb_get_private(gflb);
 
-- 
2.43.0


