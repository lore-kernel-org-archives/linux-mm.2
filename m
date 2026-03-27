Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E5F0010BA422
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 03:33:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4DE0A6B00A3; Thu, 26 Mar 2026 23:33:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3F4D96B00A4; Thu, 26 Mar 2026 23:33:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 29C276B00A5; Thu, 26 Mar 2026 23:33:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F31026B00A3
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 23:33:43 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C3F4C1B95B6
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 03:33:43 +0000 (UTC)
X-FDA: 84590423526.19.CB7F0FE
Received: from mail-qv1-f43.google.com (mail-qv1-f43.google.com [209.85.219.43])
	by imf20.hostedemail.com (Postfix) with ESMTP id 0490B1C0003
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 03:33:41 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=lIEFdQoR;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf20.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.219.43 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774582422;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Q2LKhamSzXfWrHIo8OAsnqwo5StsDAM8VnQ9PQ82pDM=;
	b=lv6RfS11HWF+m9oSTT9cum5up9Lq9jCyUuGM7yTu9smZ1QcRn1UYIGHtDWs03+7DnGGqvA
	iA7XUrnRJGHswtD6+JN4iL40GL9rAKLiXXtomdE35WFLISWL1OJbtJJqptTuUFGGnwvQsC
	rR783v8a2XtJil3Irpw9LQn9dxu2BDc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774582422; a=rsa-sha256;
	cv=none;
	b=R9slIhz7ibeq8pzfaNFXcqC18JGQxglkoAfQ5FnD6v4OzXUC2+Pd3apqA1R+jH5098XGP6
	e95gliA0yv6g7VO4+CiBlzdkKP7HyI5ZvKAB200F5I2kxgh1bx62xw3xGB51VKpYsa5/m+
	bSXpRf/iZdYC/zP9bVF1o+9pShJk4bM=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=lIEFdQoR;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf20.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.219.43 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
Received: by mail-qv1-f43.google.com with SMTP id 6a1803df08f44-89c5446f3caso20518416d6.2
        for <linux-mm@kvack.org>; Thu, 26 Mar 2026 20:33:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1774582421; x=1775187221; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Q2LKhamSzXfWrHIo8OAsnqwo5StsDAM8VnQ9PQ82pDM=;
        b=lIEFdQoRExQFIFYQT0zgdrAX3QQFKvNZfE4mJ22wwcDwjG02h7vNxCDy21A53n9dtY
         7hBnZsGO10Y/Bmmr3I6mRiWynPO/8Mf2+DgYf/CzpRP7FEIkzFWrrK9cROwxXSSAkwSF
         UJwclycd8zSeFeZY9MBX+EUbko41nQh0erMk/TpJVvT8hwqL3EREyXASxZK3fVTQd7E1
         gnF1SUZ44Ud/iD5oK8ur2FIUaevJGPXHdWY2o11z0+UcT2M+I+TRBhmCAbqx9cyz5qf0
         jpu2GjsK6ENOgM5L79E0m9pRzPKMUFUzvAXUz9YokAa5GUMoY7jvs0htON2uDrXfz5Mp
         U6tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774582421; x=1775187221;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Q2LKhamSzXfWrHIo8OAsnqwo5StsDAM8VnQ9PQ82pDM=;
        b=LikrhN+aHCi/OOtXbMdGmLINgWDQLASmyv5hWEv0FbXQsU02BQR+EuMM87I00AXPdr
         YsnoUra8XYoNUeZNlDZXQrpLMMltPhrAOdumWvkqkztLdUjgAbEsj09AUtT2+mHFoHgp
         Myb2KSoo5KbpxJpN3zjqJT94lTN04rWI2Y40qqNpKI56vHHLz+mn4hxUxwVY+A1IkKyR
         0jxGGuovP60VkQNUrWRSl9mllxYvOfM2Xeua150EGhKb5I2Ya09/YLdvyWTMQaKllaMb
         AXsw6zw0mynHhVQG47LzGJuws44yYNn2RHzCAGtVIzmZlOzqcTYMBzazGU3XB0uIV2oV
         XZcA==
X-Forwarded-Encrypted: i=1; AJvYcCUMBmIC4QC1wlwrM+RwNSyz8WYxB/NNGHwPRxm8cdOrav5uVultWz6cPx3gbbQ5Uw7K4HSvt9wUpw==@kvack.org
X-Gm-Message-State: AOJu0Yw1FTnADGVaHvOQ+puZVrEHIXwZeZGnZHK+okPfzc+E6/I8vT8n
	/rJP/a3BgcO+yt1FD6gpWJvrq6XEe3xu4Ju2wfgG7gf8H7917kddfQdnOU8BuBtXuL4NbdqiHCe
	C5Uci
X-Gm-Gg: ATEYQzyNlWSzyxaJMbqcVwYrr2BHPy9EaGDu83HAzqO6xyKGKxcy8WLXDaWBGK0KmDp
	HwTB1g3ub32PZPo97ohyXnU5pxlKl/QMBKVKFK8PDg1lfo6+S1VKoAr0oJsSPIyqBkleRr607K8
	xqhOwtLoLxbwOyGkZPPMoB0ZrivUwPuZJBtHuqvD9XsneexnAEwSZJOE4S6iVETwvXv74ef2cWv
	B3hj0FNMN3NK5Ex37pyOefUOMU0vBpqvMocLRvr7UTrn8B+/Ji/r9FT8oyTHkyqb5cimguHnUm6
	IcQLhImwksSjexLsLOAwm8zrfflKsqBIgr0a1/7VGgImEk4nyeSmdYewv+Q7m2ssnH0CmfZ5P7U
	fmAZFd4McH5u/9ndZfxB9qjBHXGupTZID4ypLh32Iihw0Xxfc9pmYYmbUC2g/OAyxBGhIECja8p
	RhWuOUHWEAIWalXOQIUOf48jWl8ujQiIt5uMvVMuA04HtMs49HyyqekyXaSf1nzfL2G2nhoWXx+
	Qd0
X-Received: by 2002:ad4:5ca5:0:b0:89a:2fe7:91d0 with SMTP id 6a1803df08f44-89ce8f5def7mr11945646d6.51.1774582421027;
        Thu, 26 Mar 2026 20:33:41 -0700 (PDT)
Received: from plex.localdomain ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-89cd5a22711sm46519186d6.27.2026.03.26.20.33.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Mar 2026 20:33:40 -0700 (PDT)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: rppt@kernel.org,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	pasha.tatashin@soleen.com,
	dmatlack@google.com,
	pratyush@kernel.org,
	skhawaja@google.com
Subject: [PATCH v3 04/10] liveupdate: Protect FLB lists with luo_register_rwlock
Date: Fri, 27 Mar 2026 03:33:28 +0000
Message-ID: <20260327033335.696621-5-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260327033335.696621-1-pasha.tatashin@soleen.com>
References: <20260327033335.696621-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 0490B1C0003
X-Stat-Signature: 9x6ddqwzqhyqgze4rbr7k48by4gap814
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1774582421-721500
X-HE-Meta: U2FsdGVkX1+qZLlWsLy1f5JvQRCP5JgA5+YKmN5kwJDzBeyM/Q3cPoGHK4s1ES9DvwJFMyv8IFM88D8a0VgBc8Uw35lwdlDlhUDYjzW31AHReY4eWRCJRJwF63h7oslxiDl4Jzn+LnNWF3dAJNEg/PfLRNkTpNmMyBMF9Wdbx+UnEU+gkrGd8xFONfKnSz/+UdbMV8c27i1w//rS4qxxlq4z+7lcYQXrjxqjhEqXUpeOe3pL8mmRpbc8TDHFeScd8YW8+a29+7bnnpOeASHKQzl29RSXxnkHlzB0RfWP27GvRR3nkcZGORXBMlMo6nwm9wVku5eGlisEpAeHNPqOVKR+a3QFxLC9LcrUZzQrTmGZKoRuDW6NBHJELP888PbrGPlk6y0yYOaF5EIVgm9EVNsthdZ9D/ri+Zk8KUwKETtBhhw8sohmHh9PGsLYg9yN8qiMeR5ehrK3MKZao0A77kB+9nsOEDkS20zmklgtImaZnMzzwacI6RBHLjTGFIyYtXuCyNoWCk/UTh+KH8nFqmUHd6WHC0LPO9VQqoo4bdSuPUKylsBLlDhmbaby25uQweRfsg4YhwGrSWnVH6k50gKIs23WOwLACjmnnj6n7CKBQurCEXf1u18PB+SqJA0f2lw/C6EUy8wuKH7U5r+wyhjaMzjySTQB57ioP5if0jHyhZn+b13jlbKCA4F2J/xT4qmfZimut9+yLpRTZXOXX8I2YXeVIO7KiEWgJu1aK2GN9rxDVgtJ19+KNE4tlLyL6C2agJNUPTKSjGq+8agofnaNPfJ3dZ0XUTzbmcVeruwIL57osNGLOpws3QeWnmijJFadg/tD0FivBPkAtKjchJk/aX7rQR2IFCEUWiUD9xRDwqjgeF5RbCsUE3pYNReK3dCO60XkqDlbnT/m79INnhKy8jAF3otBuGoAh32YL32mRSPf3UBTNG+alxC81Bq9SjzBdCsH3QyJyPpTwm4
 8X/EWrtt
 3uqodXW0KT4ATc2rRbj5e37iTINo/dJzJqAs66Xd0xT6+XMSMhcVNiL38TDclhJwFi6bDh6/0bC1GLPyM53A7ojJEFTf3thVezaXaPc9rIL6GR4xdYW+VIMzMt4QHz83uFA+ovreyUT6TKNkpHSPKnYBxdTA2puzqYTObmZKUHGvrkPtrSCn85C5p4zw/PK+wxuxDSWEeA6lgk7rSdKUiAfU532Ac47g1kc5wid/mUoW/i+ikMhYbzd6uYmt6lf2uxYSxKfmuBKaJTtjPwKuytxJifh11xdAiKDdTanfEbpDriPWWr6hnfBhG55D9okOsrnSXLitWhjjjvFjqs6Av7lFLzS4SZk2be2vrFsxwnSsdThmlOxOSYaLIQQRU6sStt6VCdsaOZ/bqdspV9uTTOaH5O7wIvqV0jerQuBPvwy/dxuwQEFinSVe6LBN3nA5tZYES
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
---
 include/linux/liveupdate.h  |  1 +
 kernel/liveupdate/luo_flb.c | 14 ++++++++++++++
 2 files changed, 15 insertions(+)

diff --git a/include/linux/liveupdate.h b/include/linux/liveupdate.h
index dd11fdc76a5f..73ca84de3eae 100644
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
index 317c02a94da5..3c91d0008eb1 100644
--- a/kernel/liveupdate/luo_flb.c
+++ b/kernel/liveupdate/luo_flb.c
@@ -262,17 +262,20 @@ int luo_flb_file_preserve(struct liveupdate_file_handler *fh)
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
@@ -294,6 +297,7 @@ void luo_flb_file_unpreserve(struct liveupdate_file_handler *fh)
 	struct list_head *flb_list = &ACCESS_PRIVATE(fh, flb_list);
 	struct luo_flb_link *iter;
 
+	guard(rwsem_read)(&luo_register_rwlock);
 	list_for_each_entry_reverse(iter, flb_list, list)
 		luo_flb_file_unpreserve_one(iter->flb);
 }
@@ -314,6 +318,7 @@ void luo_flb_file_finish(struct liveupdate_file_handler *fh)
 	struct list_head *flb_list = &ACCESS_PRIVATE(fh, flb_list);
 	struct luo_flb_link *iter;
 
+	guard(rwsem_read)(&luo_register_rwlock);
 	list_for_each_entry_reverse(iter, flb_list, list)
 		luo_flb_file_finish_one(iter->flb);
 }
@@ -377,6 +382,8 @@ int liveupdate_register_flb(struct liveupdate_file_handler *fh,
 	if (!luo_session_quiesce())
 		return -EBUSY;
 
+	down_write(&luo_register_rwlock);
+
 	/* Check that this FLB is not already linked to this file handler */
 	err = -EEXIST;
 	list_for_each_entry(iter, flb_list, list) {
@@ -418,11 +425,13 @@ int liveupdate_register_flb(struct liveupdate_file_handler *fh,
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
@@ -466,6 +475,8 @@ int liveupdate_unregister_flb(struct liveupdate_file_handler *fh,
 	if (!luo_session_quiesce())
 		return -EBUSY;
 
+	down_write(&luo_register_rwlock);
+
 	/* Find and remove the link from the file handler's list */
 	list_for_each_entry(iter, flb_list, list) {
 		if (iter->flb == flb) {
@@ -490,11 +501,13 @@ int liveupdate_unregister_flb(struct liveupdate_file_handler *fh,
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
@@ -660,6 +673,7 @@ void luo_flb_serialize(void)
 	struct liveupdate_flb *gflb;
 	int i = 0;
 
+	guard(rwsem_read)(&luo_register_rwlock);
 	list_private_for_each_entry(gflb, &luo_flb_global.list, private.list) {
 		struct luo_flb_private *private = luo_flb_get_private(gflb);
 
-- 
2.43.0


