Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A30C110BA423
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 03:33:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 469056B00A2; Thu, 26 Mar 2026 23:33:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 309C86B00A3; Thu, 26 Mar 2026 23:33:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 183FE6B00A4; Thu, 26 Mar 2026 23:33:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 021896B00A2
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 23:33:42 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id BD49E5D8AB
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 03:33:42 +0000 (UTC)
X-FDA: 84590423484.08.5488C0E
Received: from mail-qv1-f47.google.com (mail-qv1-f47.google.com [209.85.219.47])
	by imf28.hostedemail.com (Postfix) with ESMTP id 04FE3C0008
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 03:33:40 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=Gs9QupdM;
	spf=pass (imf28.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.219.47 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774582421; a=rsa-sha256;
	cv=none;
	b=e2oCs4AYBaP0nP5BU2fgV5xIJcLxmBQLE1UErRzOpMv9irnbAP+cMjK1CZRLZLn6kFrcBq
	q7MCievg0h0m7ug+CWph2vTp8rRLWKOOIhNcjPEAw2KXg6/q1kH6kRIGBmtWp3YDrSr05k
	F5H91/YrJ5dg9i9fojldXZFX8ymAbKI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774582421;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4wsuYjjRM0hOSuiSmqKTO5rWSTT9azGBUD//zIgxv50=;
	b=eMbGQzSM3FNaWIUMqIbl8uuN5t7Tk79+otcp6W7hqPSnqkl7C76dQqOoFxkJmImgLpIM0W
	0VnUlI5wwi4ymbz6fVX4Pe4PHqvzUqIY+/KpRLDXHeGOvVvAA5klZLhCdloVTqJgrdsTpC
	bh99KKyVrKgaTpC3yDyuKS1hsEX0AFo=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=Gs9QupdM;
	spf=pass (imf28.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.219.47 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-qv1-f47.google.com with SMTP id 6a1803df08f44-899e87b04d8so24049686d6.3
        for <linux-mm@kvack.org>; Thu, 26 Mar 2026 20:33:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1774582420; x=1775187220; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4wsuYjjRM0hOSuiSmqKTO5rWSTT9azGBUD//zIgxv50=;
        b=Gs9QupdMiJYioFqH/h9BgMRuiDHu2Kahp1tHM2mx9MYygs5kjXzqHrO1UmAT5h8Xft
         buKNdtVZvQRauot9gTnsxqJOX2DcBwcccAOnvnfQMFZNF3z9hELt/vYxPtkFPY+dtzSQ
         tWabr5iZpHRGptVPTx4pta7ioFX3ojOScRZoeIYG9KgIh51F+rauiw6nVUDeOLd3VTNm
         nXpS+b4wXT3dMjbGTGTf+DBPo7h7XV6PhEwTIreDZPMIKPF+m1Ye5009SRLxWHbIO07K
         Ukj143ff6aUhjmFGAXCCl+a5j27ltOaZ7lXw01YAn5lGUVHdZAr+Qt7zq9M95lMMPKW7
         SYrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774582420; x=1775187220;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=4wsuYjjRM0hOSuiSmqKTO5rWSTT9azGBUD//zIgxv50=;
        b=UK1UjbMMCWwC1x88azQwhU5E52RjILhLL82ErFFE1Eu2YXaXNMQrkgM0g4mOl7NMLL
         G9zvvhP77PvsCL7o4m65bo/YoA/+VL3fhYUqBMXGsXSMbmOAk8M5aJ/rhViHLes4x+mb
         bEmvUUD86pwntgdAP7GmM95UJjZKAZV/atN9AfAA+VF5uvSDiHSuie6IQOaLpZo4XsCU
         dpaJ38SbvJkM1IbL15YLz9XnzX7PGHPJ8CthNcJNsmnD7AoVE/ET/lQR9B2hc/x7hTEl
         mCcztBo8L+In/HA37JC9HLm0FKWrlc2ZONQ7ghkEKmhHX1iA7t/WFK35QBY1BIzI2Hub
         e4Lw==
X-Forwarded-Encrypted: i=1; AJvYcCVhQqwoRt0ynt3IRU0bba/Ebn0x9/Kn5oe3hKV4/D4Aa5LZ5diHeYlbibFPnqxrgRv+ePP7T1Rp3w==@kvack.org
X-Gm-Message-State: AOJu0YxT+Prmas1NtFPVetwFKL9k7078kgziGNYFJ/LO0+mr/1aFFONX
	g/iS7DWklxq88G4dumRaLkQHy1UCw0lyWzm1Spt1nFo2nrlsFYr4O+93hWIXlFsGv3c=
X-Gm-Gg: ATEYQzyB38CAJWzWCLLYSHu7VLpQLFFWPkKo01YlKl6ou6BerIUrflzazqOrA9tXmfW
	jKp4VrJjCg7mHEmLUtOlSFQNAiQ9mFEkJVuOMZiod3ddKX5EAzlOuR4kPoF5kVUTZ4OGXIgDdrF
	cW4F2HXyZcSUIWGAzGP3GNTdrGHUVdqzdxaTQtZ60YZ/h2QLP0EN6F2vXA2NFkpKukoxkFgWPli
	z8dFjWVmGlw6jUoPJiRryMiQO0tWkHUEE//jdbzCg5+rKY8VmIREiej4HSIU3RE6FkS4JlpyznW
	0ONorMy5HIufxbvD27DjMrsu3LeJ4/TxIcmoKu2jt3Brryf1MuLSV0ggBdg2BjqSo8+3iCL5+9F
	e4fHKe825EHg8EjbCre3mY+SWt2o1koDWIAfEdZ3l1vaVz5Czn3eUzFXiF3OczIaeZbgKs2UA4n
	rXLouii/xJPKuojwvjAAtKNbpsjVvFT0S6dNTDrLH2xRwbbE+UXfvRK0c8h4b0hJojpA==
X-Received: by 2002:a05:6214:2f0a:b0:896:f47e:fd53 with SMTP id 6a1803df08f44-89ce8d15897mr12694906d6.17.1774582420090;
        Thu, 26 Mar 2026 20:33:40 -0700 (PDT)
Received: from plex.localdomain ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-89cd5a22711sm46519186d6.27.2026.03.26.20.33.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Mar 2026 20:33:39 -0700 (PDT)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: rppt@kernel.org,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	pasha.tatashin@soleen.com,
	dmatlack@google.com,
	pratyush@kernel.org,
	skhawaja@google.com
Subject: [PATCH v3 03/10] liveupdate: Protect file handler list with rwsem
Date: Fri, 27 Mar 2026 03:33:27 +0000
Message-ID: <20260327033335.696621-4-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260327033335.696621-1-pasha.tatashin@soleen.com>
References: <20260327033335.696621-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 04FE3C0008
X-Stat-Signature: owj8gaac9zqmkfudhugz4kd9cgj9ec4z
X-HE-Tag: 1774582420-323459
X-HE-Meta: U2FsdGVkX18BsBimNkhbOX5RsYhPIvovDdkEBN5Vx6/tpXhfnhm3ao49YW7oZ5kgaoviTmkbqRCzpIZY/zfHCD016L2jQZS3yUy5Zp11c5ToNL1pApLu9htcXdcDDZEtHhJgmGFDkyBYurJ7+DTN38ZOWKHoQiJ59qUHnWbPSuBtSK/8uMerZAkSy5JWY800nJTgi4nMrl/fysFtZ8GQ7CsTf/wHh2NpQXAASUwV+ipJ/ESlZRzXhXa4sy0YDG2o/+3CmrD2GyPBAsuxmgzYu9joGBaOjHzzwwy7vX6WAZuiTUcqknlQBSkbKt0MTy5C5fs8CqE+OLyDDFWNIzrsoMgWLGsvdiL9vlTDS37i6RPmhuSq9NVc7yRAXMZhriMx8W74IoVctDt73mlFQsvmZ2iEa5nObdx6NY426ZAJD7JFG2mCTRP0EbmSeEQwSeJTgkc1Fnfu9H2Q1aMdVDB4+o6xoopUkMqS/eMCJne+nKJ8bbco6xdMbuKkJd/FtLNha5Vvyb92lJjC31l2F30UkaG7wI8KrAqCCXqyCzvrBViz6+WKpD8f9UvvfVxiwVO/c5SkHTY7PA3Rtu1d6vmaT83Knom7qX14ema9Am1DQY9r84YM1HTmdrtyHpsTn7VFLLpMVQoNU5a9ghgcHdyXOTpHa/BXUjzXkAKGQTueszyXWIhglet9zPyqO1lR6RM0GLO1MQRVvwVdQa68o/V6KajdGWGXE2JJ67rGQE8xs9Up6kMUdcgc+q5iymji2jnbGxJdoOVAnidGMAUBO0PhpWQcC0N22v9+mLAxdIK7XIWuHGRfrQBzeTxvcplHxbKM+HR2AY15RtmNClNCIQWAOpH4D/sgqxf2fQvaXjeTfyfEZPa8nrMeIfkpnM4e+VICYroI8KEsOJLd90wOojTaQiUEfJqlaCA5d8kdXwdi35hM7omUmD9LAeYG6FlRqq5r3+Skn8bqoWv5LZZ9phw
 8GeH6/+S
 18dhr1mj2TYw0PUr5SGMIP6dAoiMqHiimtV1ffF89yzNTAZQ2enz8KS4xs3zRX4nRNyyn6pm2C1tPUU0I60tPDdtBbQWqSEsLdffU4iXBbEBaWCmhbwj8dGliQt0bpoXtvEnm2+uJcWWrkYtXqO7JtJUvBnheL9+xyYO5iIvC1sfLq1PThyr/4p7w5LJ/Gmrsd+LGjDeowhvfAUI97NZHo7ySUueW6gRMC3sdvU3wY/RX5w/fsAo+ixS2JIUPLILj4Srdi7V66nV1CAM7VltP8eleSSO1F+urG0k/uM0hlgPU1YHmzHe3WITLzuCUh2JglLPbFp3X8mH1nrQEe+ejfMVpYWcijt/vt3peXA6dAlLaJlc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Because liveupdate file handlers will no longer hold a module reference
when registered, we must ensure that the access to the handler list is
protected against concurrent module unloading.

Utilize the global luo_register_rwlock to protect the global registry of
file handlers. Read locks are taken during list traversals in
luo_preserve_file() and luo_file_deserialize(). Write locks are taken
during registration and unregistration.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 kernel/liveupdate/luo_core.c     |  6 ++++++
 kernel/liveupdate/luo_file.c     | 22 +++++++++++++++++-----
 kernel/liveupdate/luo_internal.h |  2 ++
 3 files changed, 25 insertions(+), 5 deletions(-)

diff --git a/kernel/liveupdate/luo_core.c b/kernel/liveupdate/luo_core.c
index dda7bb57d421..f9ae9364a962 100644
--- a/kernel/liveupdate/luo_core.c
+++ b/kernel/liveupdate/luo_core.c
@@ -54,6 +54,7 @@
 #include <linux/liveupdate.h>
 #include <linux/miscdevice.h>
 #include <linux/mm.h>
+#include <linux/rwsem.h>
 #include <linux/sizes.h>
 #include <linux/string.h>
 #include <linux/unaligned.h>
@@ -68,6 +69,11 @@ static struct {
 	u64 liveupdate_num;
 } luo_global;
 
+/*
+ * luo_register_rwlock - Protects registration of file handlers and FLBs.
+ */
+DECLARE_RWSEM(luo_register_rwlock);
+
 static int __init early_liveupdate_param(char *buf)
 {
 	return kstrtobool(buf, &luo_global.enabled);
diff --git a/kernel/liveupdate/luo_file.c b/kernel/liveupdate/luo_file.c
index a6d98fc75d25..4aea17a94b4f 100644
--- a/kernel/liveupdate/luo_file.c
+++ b/kernel/liveupdate/luo_file.c
@@ -277,12 +277,14 @@ int luo_preserve_file(struct luo_file_set *file_set, u64 token, int fd)
 		goto  err_fput;
 
 	err = -ENOENT;
+	down_read(&luo_register_rwlock);
 	list_private_for_each_entry(fh, &luo_file_handler_list, list) {
 		if (fh->ops->can_preserve(fh, file)) {
 			err = 0;
 			break;
 		}
 	}
+	up_read(&luo_register_rwlock);
 
 	/* err is still -ENOENT if no handler was found */
 	if (err)
@@ -777,12 +779,14 @@ int luo_file_deserialize(struct luo_file_set *file_set,
 		bool handler_found = false;
 		struct luo_file *luo_file;
 
+		down_read(&luo_register_rwlock);
 		list_private_for_each_entry(fh, &luo_file_handler_list, list) {
 			if (!strcmp(fh->compatible, file_ser[i].compatible)) {
 				handler_found = true;
 				break;
 			}
 		}
+		up_read(&luo_register_rwlock);
 
 		if (!handler_found) {
 			pr_warn("No registered handler for compatible '%.*s'\n",
@@ -851,32 +855,36 @@ int liveupdate_register_file_handler(struct liveupdate_file_handler *fh)
 	if (!luo_session_quiesce())
 		return -EBUSY;
 
+	down_write(&luo_register_rwlock);
 	/* Check for duplicate compatible strings */
 	list_private_for_each_entry(fh_iter, &luo_file_handler_list, list) {
 		if (!strcmp(fh_iter->compatible, fh->compatible)) {
 			pr_err("File handler registration failed: Compatible string '%s' already registered.\n",
 			       fh->compatible);
 			err = -EEXIST;
-			goto err_resume;
+			goto err_unlock;
 		}
 	}
 
 	/* Pin the module implementing the handler */
 	if (!try_module_get(fh->ops->owner)) {
 		err = -EAGAIN;
-		goto err_resume;
+		goto err_unlock;
 	}
 
 	INIT_LIST_HEAD(&ACCESS_PRIVATE(fh, flb_list));
 	INIT_LIST_HEAD(&ACCESS_PRIVATE(fh, list));
 	list_add_tail(&ACCESS_PRIVATE(fh, list), &luo_file_handler_list);
+	up_write(&luo_register_rwlock);
+
 	luo_session_resume();
 
 	liveupdate_test_register(fh);
 
 	return 0;
 
-err_resume:
+err_unlock:
+	up_write(&luo_register_rwlock);
 	luo_session_resume();
 	return err;
 }
@@ -910,16 +918,20 @@ int liveupdate_unregister_file_handler(struct liveupdate_file_handler *fh)
 	if (!luo_session_quiesce())
 		goto err_register;
 
+	down_write(&luo_register_rwlock);
 	if (!list_empty(&ACCESS_PRIVATE(fh, flb_list)))
-		goto err_resume;
+		goto err_unlock;
 
 	list_del(&ACCESS_PRIVATE(fh, list));
+	up_write(&luo_register_rwlock);
+
 	module_put(fh->ops->owner);
 	luo_session_resume();
 
 	return 0;
 
-err_resume:
+err_unlock:
+	up_write(&luo_register_rwlock);
 	luo_session_resume();
 err_register:
 	liveupdate_test_register(fh);
diff --git a/kernel/liveupdate/luo_internal.h b/kernel/liveupdate/luo_internal.h
index 8083d8739b09..4bfe00ac8866 100644
--- a/kernel/liveupdate/luo_internal.h
+++ b/kernel/liveupdate/luo_internal.h
@@ -77,6 +77,8 @@ struct luo_session {
 	struct mutex mutex;
 };
 
+extern struct rw_semaphore luo_register_rwlock;
+
 int luo_session_create(const char *name, struct file **filep);
 int luo_session_retrieve(const char *name, struct file **filep);
 int __init luo_session_setup_outgoing(void *fdt);
-- 
2.43.0


