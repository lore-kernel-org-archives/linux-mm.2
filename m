Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E96BEF531C3
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 18:51:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3E0076B00A1; Mon, 13 Apr 2026 14:51:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2CF616B00A2; Mon, 13 Apr 2026 14:51:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1BD016B00A3; Mon, 13 Apr 2026 14:51:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0C4886B00A1
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 14:51:42 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CC0591A02D5
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 18:51:41 +0000 (UTC)
X-FDA: 84654426402.28.8E28B10
Received: from mail-qk1-f181.google.com (mail-qk1-f181.google.com [209.85.222.181])
	by imf30.hostedemail.com (Postfix) with ESMTP id 074788000E
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 18:51:39 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=Rpw6h6wB;
	spf=pass (imf30.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.181 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776106300;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3yRh7amP+FpWvXP+5yjdJzcKbkg1zLQsfC2/lVN1Vw0=;
	b=nf7UGv2efqo5mjefzVW6TlJJEFvdwmxC/PhPyTAamWs8xIbz+5nm7M3lnUh0EZMxE5KuPq
	OmbwxPup+nF+uVDCyJNqiVkd1vIMBZF/NuQxAI8s+nMWEcGjo2lAzlwpQk+yDjP1s+Aynq
	8AvJQ950J4j2yhdSxc+OddMUD/M6MaA=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=Rpw6h6wB;
	spf=pass (imf30.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.181 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776106300; a=rsa-sha256;
	cv=none;
	b=T5HDBtBU9+foIdWZZVeX7vrQSFoIP25HMPA0mWi8d/N9dvzUHmXvvqgPBi0jVoIhi8DYun
	uWqQvjvoefXG5GKgQppEjEOp+YZxoQ6hG2yVlgxUhQ8xglfBLusZcoa6ZtlR/9mez57Cyv
	cDUjwgnAMrxzDt3wZofiIfJpDTRbYiM=
Received: by mail-qk1-f181.google.com with SMTP id af79cd13be357-8cb38e86cf2so430088885a.1
        for <linux-mm@kvack.org>; Mon, 13 Apr 2026 11:51:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1776106299; x=1776711099; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3yRh7amP+FpWvXP+5yjdJzcKbkg1zLQsfC2/lVN1Vw0=;
        b=Rpw6h6wBMg9t9+So1mAawO2d5V3uxIfTpAgPJBTe9X8N7yHhO3j0SwlF6lQDLiX45c
         s0SFUW52rXUko9LqlxdItxIow4Cp1rCjlKFMZx0C+p72WsanlSG3HZzeNMk/zXYbkus+
         c78iJFVXzqBOGFRVtAKR30EGEgzsSDyhB5dqpkGDuXdNxMaYlFUtYDV4nV5+W00Quafp
         q7b7HMEkaOoo1nfTpyqLJGV2agyLJfOYJ5h5JIF7sBQbGNkcMEB/F+Z9z+1HnhlwLeK/
         MoWgpX2McX74MOABQb9ucAe6/i7loWsl9lZqvbQmLYej0rO5JAOAiOONmdR0lvsww1go
         2TRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776106299; x=1776711099;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=3yRh7amP+FpWvXP+5yjdJzcKbkg1zLQsfC2/lVN1Vw0=;
        b=KqCeR8U8LzaiOthUi3lalnJveByMPWqHuNqiQ9QNde4PnYBDUltAmecaKtoXKLadvg
         WkHNEsls0mYMsR1FVCHR4eFpLRVj+oL4HCoMEkq4UGkj7m/cf134ehCAuUAO1FzQ8Ki9
         /88vqQ+sSFknIXSXlT9daLy5WfzQ9fajmZgpsowhXbeJk+rB9sSCUpUDIGf+IcSefp3M
         SCRL4oyw4Sb8L0lmXoS5eCtb9MTqmGn9rOJdPb/f3Cs2dYUmgoGmIN/TVqsV1h8NJD81
         cRZvVxJl+U8+kEp5ItHXWN/AtLa7eC/NkcTlY4Njx+lRK6XTy6AANMvQJL/6dcEcxyRW
         DiZg==
X-Forwarded-Encrypted: i=1; AFNElJ/MJu9tcEK0Cfoszuc/QV6NMZEZ8JX76s1wtnLfjeyeYrihjRpq7LtGJJSHGi5xHPwCwtLm9dj6dQ==@kvack.org
X-Gm-Message-State: AOJu0YxZ+ERT9Bv/mOpTj++lmg0aPpSxdUTQzuNJNeT1RcArh0jzciaX
	OfTJxT72WBF8AOpcYkSSisxOTg8BInQQXJItLYq1Ts6AuGYCXwOlgUGPexmIgWHcDss=
X-Gm-Gg: AeBDieu94g12YIjGa7NHExb5xMVrchC5qawE1pJSxxCo5x71AwtBqBDU3we5LwEq4Vu
	Bcy8hfcBZVvTggpez2Qhq+2CSDZdYoWZiAaivyK+T5gxW+G8N8gIa1sdEWqqmmHpLgUVBdXqIEC
	vXx/1X0V14j97XbjpE8wtcmD64nqYaYAUqNSn44XW5WtMwaYZCq/Oy+GpxWBinc6XE51FoIo15g
	RC3OtnJZRQzcSAhzeJTfmiWdFMNAj/vdqa/AX9ceCqPeULRRuOFueNDbk7CU8AMLbWyn4HPUYG9
	yA8hoKmPboOZKpv/oykj5vdTVSl+8pZBGN6nbrUidVxYKzBMbfJUDbeUfcL8E7yx8ByveYYv+wE
	/lPyuMMoo/27lfno0VsUntvYjMRGTPCjDYYJ4y6DZQdTUlXbgmRLqfWxdZ/H7/E2zgLEX9o9W+S
	FtVMN5MMAlsfry1/9g5ENRU3Jx0+UIUWMWwuiNgfUrIJs69Z2rV9c0ZBmqVZGrcCvGlg==
X-Received: by 2002:a05:620a:40d4:b0:8cd:93b7:ec10 with SMTP id af79cd13be357-8ddd06966afmr2127489385a.64.1776106298953;
        Mon, 13 Apr 2026 11:51:38 -0700 (PDT)
Received: from plex.localdomain ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8ddb6372790sm943206285a.12.2026.04.13.11.51.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Apr 2026 11:51:38 -0700 (PDT)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: rppt@kernel.org,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	pasha.tatashin@soleen.com,
	dmatlack@google.com,
	pratyush@kernel.org,
	skhawaja@google.com
Subject: [PATCH v4 07/11] liveupdate: Auto unregister FLBs on file handler unregistration
Date: Mon, 13 Apr 2026 18:51:23 +0000
Message-ID: <20260413185127.128180-8-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260413185127.128180-1-pasha.tatashin@soleen.com>
References: <20260413185127.128180-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: sqp8ecid6gtfubojkny31b47kthpeh9d
X-Rspamd-Queue-Id: 074788000E
X-Rspamd-Server: rspam09
X-HE-Tag: 1776106299-687335
X-HE-Meta: U2FsdGVkX19DZt9WVHVYhL7hXlEHg4G20yikZWkzshlqeWM+6uQ8r9XLIL0mVp55WHpagGVG1my4U4HXQ9aoo6Tt3ejm90ATgTfEQG4aCA4Lq9eCgpgXB7ckoTkjpm4ffQa1ftHF+3FRy56nEbbGoonNXx+Mf1/+f0cmaI7vDbfWdihORTQneL4/ixrxOC7oXj6mBwv5ayKzcikMTkhWjuUpTbd+JeHeuYNj0JKJy55Gd93Gix1uz6Gj/98Np6PJVmk0+eYbxjaVyYzcS/BlNKtPjSwuQxL7NcJ/qjBg8k1b1hZkIJjvV1l52bfE7NWwtnhvToMCGk2GZlghEfln+nFTaaWmvH7B1kTRitXV7GMTKP5yOCOwt8V2HCox/Oo7B+wpfsDluVkP8QZX48bejkwjHQC7VLrc1V96JBogigQylhhruR6hFV6QdUO6iY+fjoflRxpl8dF3opilT17smghiZaM6Ntf/Mi6ABFamEqMZaJZJSCyo686S551YiMci/gz1ZSNTglBHnl/3aRAwrgUV2RiuxeHRyFXh0Q6FdCk78D0Pz4bTqbjAdwiJuyUpOE3xJloDPevuNMOsdzzGKwYZIQbuiqliB68gOjtfFsenbw7TCGNa+Yv9VIo5hXjXGfPhpYvEBZ3lBbc+TAnVyLZSY1eyAI3YK0aXWL9DJ2O3S2j8KACRPQnGEjWi7kUXFiUNbhWBphvZPH1PbnJjjwuiieo9ST0UR0uEKdRlhu2fEBfz43YL2HLivW6mZgGEGFvq2qfgOoqV35f9ghe0gxBLPKlZPZHYN+hTylbgR17hyaNrs14k992gjvByse043k9Ki83KVR5ClqoBHK6N1ZpKHcFe/2H8xH5GV70rWysDykp1X7UekhRI/Y+aOS4vBstjm8H85otJX7DZ479FqOwiFALlfWQYqjuqJAU7EMpdHy+pD5MsZkrc5R1aXneg9+w6GnQtOQvjvqSNwFN
 kPOFwjB2
 qs7V+mS7+0czXChW/x6SNnYVbbMtix69yfH+gFKiWI6Z2fGyZj6tXwTCoKXfLTKjCuadKiXnHZ49df6PquuUVG2zw/Gio8/kGcCIhkPIVOJx9tGlDmd5klkjUyPeyCasGQVXKixsEOtMjB6ORc/lc9UcmS2rlnAlgyyOVCzs0cpvUbQSVmT5qGq2suVZtjaBNlV/pKId7jf0dWUwBoqlDwgnDbNeP9ePYhlK96Z4kroRAReGfKDP0xTOGHOsIXWvZ9NU1u0SSCr/8TEMMV9njdCEJMpSCXkikYSzFpAiXXavGi1Z2fGtWST5d6wK7g29iMepyGTE/+QFv9WveTxg35emaY0I65AlR2Hbn
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

To ensure that unregistration is always successful and doesn't leave
dangling resources, introduce auto-unregistration of FLBs: when a file
handler is unregistered, all FLBs associated with it are automatically
unregistered.

Introduce a new helper luo_flb_unregister_all() which unregisters all
FLBs linked to the given file handler.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Reviewed-by: Pratyush Yadav (Google) <pratyush@kernel.org>
---
 kernel/liveupdate/luo_file.c     | 14 +-----
 kernel/liveupdate/luo_flb.c      | 85 ++++++++++++++++++++++----------
 kernel/liveupdate/luo_internal.h |  1 +
 3 files changed, 61 insertions(+), 39 deletions(-)

diff --git a/kernel/liveupdate/luo_file.c b/kernel/liveupdate/luo_file.c
index 63ddcf6dcddb..b37bd79974ce 100644
--- a/kernel/liveupdate/luo_file.c
+++ b/kernel/liveupdate/luo_file.c
@@ -926,26 +926,16 @@ int liveupdate_register_file_handler(struct liveupdate_file_handler *fh)
  */
 int liveupdate_unregister_file_handler(struct liveupdate_file_handler *fh)
 {
-	int err = -EBUSY;
-
 	if (!liveupdate_enabled())
 		return -EOPNOTSUPP;
 
 	liveupdate_test_unregister(fh);
 
-	down_write(&luo_register_rwlock);
-	if (!list_empty(&ACCESS_PRIVATE(fh, flb_list)))
-		goto err_unlock;
-
+	guard(rwsem_write)(&luo_register_rwlock);
+	luo_flb_unregister_all(fh);
 	list_del(&ACCESS_PRIVATE(fh, list));
-	up_write(&luo_register_rwlock);
 
 	module_put(fh->ops->owner);
 
 	return 0;
-
-err_unlock:
-	up_write(&luo_register_rwlock);
-	liveupdate_test_register(fh);
-	return err;
 }
diff --git a/kernel/liveupdate/luo_flb.c b/kernel/liveupdate/luo_flb.c
index 13f96d11ecc9..b9f5d452a998 100644
--- a/kernel/liveupdate/luo_flb.c
+++ b/kernel/liveupdate/luo_flb.c
@@ -318,6 +318,63 @@ void luo_flb_file_finish(struct liveupdate_file_handler *fh)
 		luo_flb_file_finish_one(iter->flb);
 }
 
+static void luo_flb_unregister_one(struct liveupdate_file_handler *fh,
+				   struct liveupdate_flb *flb)
+{
+	struct luo_flb_private *private = luo_flb_get_private(flb);
+	struct list_head *flb_list = &ACCESS_PRIVATE(fh, flb_list);
+	struct luo_flb_link *iter;
+	bool found = false;
+
+	/* Find and remove the link from the file handler's list */
+	lockdep_assert_held_write(&luo_register_rwlock);
+	list_for_each_entry(iter, flb_list, list) {
+		if (iter->flb == flb) {
+			list_del(&iter->list);
+			kfree(iter);
+			found = true;
+			break;
+		}
+	}
+
+	if (!found) {
+		pr_warn("Failed to unregister FLB '%s': not found in file handler '%s'\n",
+			flb->compatible, fh->compatible);
+		return;
+	}
+
+	private->users--;
+
+	/*
+	 * If this is the last file-handler with which we are registred, remove
+	 * from the global list.
+	 */
+	if (!private->users) {
+		list_del_init(&private->list);
+		luo_flb_global.count--;
+	}
+}
+
+/**
+ * luo_flb_unregister_all - Unregister all FLBs associated with a file handler.
+ * @fh: The file handler whose FLBs should be unregistered.
+ *
+ * This function iterates through the list of FLBs associated with the given
+ * file handler and unregisters them all one by one.
+ */
+void luo_flb_unregister_all(struct liveupdate_file_handler *fh)
+{
+	struct list_head *flb_list = &ACCESS_PRIVATE(fh, flb_list);
+	struct luo_flb_link *iter, *tmp;
+
+	if (!liveupdate_enabled())
+		return;
+
+	lockdep_assert_held_write(&luo_register_rwlock);
+	list_for_each_entry_safe(iter, tmp, flb_list, list)
+		luo_flb_unregister_one(fh, iter->flb);
+}
+
 /**
  * liveupdate_register_flb - Associate an FLB with a file handler and register it globally.
  * @fh:   The file handler that will now depend on the FLB.
@@ -426,38 +483,12 @@ int liveupdate_register_flb(struct liveupdate_file_handler *fh,
 int liveupdate_unregister_flb(struct liveupdate_file_handler *fh,
 			      struct liveupdate_flb *flb)
 {
-	struct luo_flb_private *private = luo_flb_get_private(flb);
-	struct list_head *flb_list = &ACCESS_PRIVATE(fh, flb_list);
-	struct luo_flb_link *iter;
-	int err = -ENOENT;
-
 	if (!liveupdate_enabled())
 		return -EOPNOTSUPP;
 
 	guard(rwsem_write)(&luo_register_rwlock);
 
-	/* Find and remove the link from the file handler's list */
-	list_for_each_entry(iter, flb_list, list) {
-		if (iter->flb == flb) {
-			list_del(&iter->list);
-			kfree(iter);
-			err = 0;
-			break;
-		}
-	}
-
-	if (err)
-		return err;
-
-	private->users--;
-	/*
-	 * If this is the last file-handler with which we are registred, remove
-	 * from the global list.
-	 */
-	if (!private->users) {
-		list_del_init(&private->list);
-		luo_flb_global.count--;
-	}
+	luo_flb_unregister_one(fh, flb);
 
 	return 0;
 }
diff --git a/kernel/liveupdate/luo_internal.h b/kernel/liveupdate/luo_internal.h
index 40a011bdfa55..22f6901f89ed 100644
--- a/kernel/liveupdate/luo_internal.h
+++ b/kernel/liveupdate/luo_internal.h
@@ -103,6 +103,7 @@ void luo_file_set_destroy(struct luo_file_set *file_set);
 int luo_flb_file_preserve(struct liveupdate_file_handler *fh);
 void luo_flb_file_unpreserve(struct liveupdate_file_handler *fh);
 void luo_flb_file_finish(struct liveupdate_file_handler *fh);
+void luo_flb_unregister_all(struct liveupdate_file_handler *fh);
 int __init luo_flb_setup_outgoing(void *fdt);
 int __init luo_flb_setup_incoming(void *fdt);
 void luo_flb_serialize(void);
-- 
2.43.0


