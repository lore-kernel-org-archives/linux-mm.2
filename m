Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B2D2E10BA421
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 03:34:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E303E6B00AB; Thu, 26 Mar 2026 23:33:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D91F46B00AC; Thu, 26 Mar 2026 23:33:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BBF296B00AF; Thu, 26 Mar 2026 23:33:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A162F6B00AB
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 23:33:50 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6B6BC13C338
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 03:33:50 +0000 (UTC)
X-FDA: 84590423820.22.8B8410F
Received: from mail-qv1-f54.google.com (mail-qv1-f54.google.com [209.85.219.54])
	by imf13.hostedemail.com (Postfix) with ESMTP id ABFDD20003
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 03:33:48 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=BT7hkm9T;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf13.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.219.54 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774582428; a=rsa-sha256;
	cv=none;
	b=IeRKhgv0T5hoRkdVs5tcBqw4EikfbxQB9UXBgJWBcJt2zN7hsT5R35NVIdIb8uT1lp2pfE
	fUep85qXLdwfipTotBNUzq7Z9jxN8zqtc+JvlrY27ij7+hgJKYigVrNvSF36YOYDvfTsU8
	mMepqXsx+PRG30zw12q4Wv2Y+S19+P4=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=BT7hkm9T;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf13.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.219.54 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774582428;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aADyeHO5XJu6ZrJPxM1LwlVH9QhmzTzIomzhTiemGHY=;
	b=ZH3wGiJOR8REiLe1JmeegOoE9erBY71kGdnKlfykEVdX9EzKXLs9OLqtqiohUqFOSKdapP
	yjqzPKRuexOdLGReCEPug0LNTGgRL00SxdWTxnNthEw2tmndaJKNopYZKOoa2XxGP2gwHt
	7PY4C0uxjsihNKKpx23PCO4SGLusvdk=
Received: by mail-qv1-f54.google.com with SMTP id 6a1803df08f44-89c4f7f8650so28458796d6.0
        for <linux-mm@kvack.org>; Thu, 26 Mar 2026 20:33:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1774582428; x=1775187228; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=aADyeHO5XJu6ZrJPxM1LwlVH9QhmzTzIomzhTiemGHY=;
        b=BT7hkm9TMpTJtJ4lZyGUsjvB2HcyLYUNql+rQrm1NF1tMQmqwxn+vfLQVyz7vUzULl
         TImiqIS5mAvqqhIDNrTzT5xkMN2bQgCLf1UmvBVrFBYMNv3qUE7PRKWcHEr4rmBf2j5S
         VAc9EsBawgnBsk5Ydt3iQC472hoInTKgsCC3aQVrh+mfEJG05K3PMZQng5CZLmSD+o5d
         9TcvqONxsONZKTCLiVPBdoj5DlvX9d4IiDFDx9wT6yNzOVBQ6kbx3N5JfV+DUsX+4Gyq
         jEgf61sobuA8DjSAtsvryMOirET0wI2KfdbleCOF7AjrceBBaxxI3fjucZvpXQAZa/Y0
         YyGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774582428; x=1775187228;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=aADyeHO5XJu6ZrJPxM1LwlVH9QhmzTzIomzhTiemGHY=;
        b=ReHbA1YldxCHVUyXg+KeqGeFmMD5KfX6zIeEvm/oSd7DNtK90GBYMPZPyrpBJTYzi0
         sAFble1nI8q011AbqdJtodgNy/n6n0cyYN+TJj+l8YEf9Bcpr+lA90cWuwB0yujtfvCn
         HTQ/NM2vEUcihDZ1w6jL2w0yYz8kuDlYwWEmxxxy1YExkW+YKpBsRGiXB7SAIofuybwx
         IJVq3Pwr37xafJOY/YdRl2xTC5zPUHcjlxV8WnJAJJRUkFAnq+4Vok27O7YZ3cjKWtyW
         o7KAMuUq7iFJsl/r3lZyNIkupBUoIEzoRp1M3bi6l39P18wtZPBVaisKD5IQiMo4WOeY
         aKnA==
X-Forwarded-Encrypted: i=1; AJvYcCUfE4U9N7rp/lySZk8m7XOszTBxFIVHXaCD8haqMTjAS42THV+3Qt3se0evEgF61YLH6WY/1Xtobg==@kvack.org
X-Gm-Message-State: AOJu0YxYWBFuoIEm2X1SH+n9DS7Y7/Mk34V5RjcxDmIl+IXSHOqmmETX
	oKTIkDy9kK/rnMZKHMpNmGo6QzHEFBM1xt+DCrXfEShz9UxfsTkF+pS0kcUphYhB6fw=
X-Gm-Gg: ATEYQzx8S9NsEzJBW5dNl6rkv5MAuwWAxpOBApNkgCqwU2nDpn8nYhVAUEUVk70gY3L
	DT7x/Y0kWYh45FAYKhRW7n6M+x4dPhaTq78aDECHNFb6y3qZZ/aHIx+hhibQ7Gt9KiKtW92z/V0
	dGtTh7xlRHPoREAWm+qAy/1KydknrkBqja7NnNGg29LDxoo1ZOge1tbVTL0BdIpIwGYQsD438N0
	QTwuvU6wIHaONKIMomDv73MbJXi62sJrGTzMKbzq7xWbN+saVjxNjEFguzIr+z0H9rUXcSCZpa2
	hPllTmofp0T3Fshb4kO4sPr+JUZBzqUx+owajXQ0UR6CQUD/YOBCTZjTFaCOcIu+cIdRbMBsEtU
	XeKhlqj69gdONT7WikifBCp4qZBXZOiggOvrYNeXivyIJKdqfLQTQmtMgp4oJ/4W10qVopls9xw
	9NAGR6BDv3Z2kSRnXFfzA1N1SGFKGFpJ3tGjN7TjkhWZiIBPx8S5xKLs41tWqSl/in4w==
X-Received: by 2002:a05:6214:4842:b0:89c:c685:f52d with SMTP id 6a1803df08f44-89ce8d2fb33mr10795416d6.15.1774582427783;
        Thu, 26 Mar 2026 20:33:47 -0700 (PDT)
Received: from plex.localdomain ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-89cd5a22711sm46519186d6.27.2026.03.26.20.33.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Mar 2026 20:33:47 -0700 (PDT)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: rppt@kernel.org,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	pasha.tatashin@soleen.com,
	dmatlack@google.com,
	pratyush@kernel.org,
	skhawaja@google.com
Subject: [PATCH v3 10/10] liveupdate: Defer file handler module refcounting to active sessions
Date: Fri, 27 Mar 2026 03:33:34 +0000
Message-ID: <20260327033335.696621-11-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260327033335.696621-1-pasha.tatashin@soleen.com>
References: <20260327033335.696621-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: grn3xgbetfxq81394k8uieksegmyd1qn
X-Rspamd-Queue-Id: ABFDD20003
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1774582428-866661
X-HE-Meta: U2FsdGVkX1/0UiWwIC7Ax1lWivGmbKHcMmQEruo/n/Hx2UXSEa0GRF97ZF0wnkr2d2WKFr6eXi6T81YXBMyEGmSpUkI62gKOEOoJRge9MYaW6LBwdLGnSPwmMolo/wn8hPl9huUCwBDgizjR0gkW+dIBjv2VtupqhrWlPXghh5O2ChMOOVS6txLLfZDwI1JD67sQFULCaKh9ZCVJVS4ZBsXL8hOjvpkcRSbnznaqws5miCdCm7LrVUIpEM41eCp+Nvr/7Jj2iqjkLLfWeXg7k625zQhyb1liqOxwWFt+Aw7Rr12eWCfr1tp0/tHDGEbZtJfkZ3PCst/z2HL132NMJEgNofkC73YTotJOAZfWkEJj414f+hkqw73VjkfJ3u8UvPcUCWa99kj+/tu1HyRs9Y2LbBubJpqlRCiuRc2o/MsUMpJdDl/PcQ05YQVp5RIK6CubJGI67yTVfIt1hxe2AXUS84+HozIuu4pKlHWN0Tndib7lknNq55wGotrYOeRoIrvsPIKFbLYN45dAhDwIgtBjUI9c1PL1SZMOqzMdIJk4XdbvELmjkJ1NWJSYKUdUW+k4LDholxTQ6FNICYlfCL7cuGgPu7MXTwJsB7RwlsuBWplu6ktE+PY2dFfvZVKzoCDTm5SfQdiJO65BHYkfxWhyoanngl/yrW60nP3nrZQRb20UwKp1/33jJnObECuiw5jEpPgm0WnIsIdAYH4ZHH+8bwtUJuYpX/0aW+r3cmq4WhKAqkp0WUHRBfd4dXxaUfgUWYujYqx0JG24z/GEcuLsFuRLJydpOXQeMGvU4HM3nUVCywP8VlEPOfcAMExBWFXTV/ZGKylGgToyLDAwnstuOiAbSPZ75OK1kwF6jC4scwIvHq2XL4CI6ZVjnCClCN0WEnQRIK4ws/AhQquD0qAnK0BX9ulfuNoQGH61XnCdwc9BoFZCPv0B8r4EY4ULB+a+mObvczdvqMeP+ZA
 A/jF5iib
 QRYhafZdfj/s6j04CbbMf/ffeve/0dq5GPqzLMZCuGuq//YEGkqpMzgPN6ex1LX2CiUCDsO9tofUNCjRsNKkxsPiyqzf82uUQ4aWQXPd/K3yI6UvLrLD4i9cybKM74dpGJ6OFo0CN5TBG4CKJCwlAwYHn9Wdutxgvn+SjD3tQ0BvXo8O/fel34Zng7eA7lyxji3EttYPUfW8LdZ50c8R04fIZ0EXL4OxfNB5xnX8ZcjHSTrCvmKDOND+FUpwAxN8hlBom+zJWUMKXvQCLL5e+CLfIVL7vV58m1NiC9lv75O106jTdnjSCOZtVPoj2PZSSBI1xqGw8hSl78kE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Stop pinning modules indefinitely upon file handler registration.
Instead, dynamically increment the module reference count only when a
live update session actively uses the file handler (e.g., during
preservation or deserialization), and release it when the session ends.

This allows modules providing live update handlers to be gracefully
unloaded when no live update is in progress.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 kernel/liveupdate/luo_file.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/kernel/liveupdate/luo_file.c b/kernel/liveupdate/luo_file.c
index 761e8f7cfc82..619465358798 100644
--- a/kernel/liveupdate/luo_file.c
+++ b/kernel/liveupdate/luo_file.c
@@ -280,7 +280,8 @@ int luo_preserve_file(struct luo_file_set *file_set, u64 token, int fd)
 	down_read(&luo_register_rwlock);
 	list_private_for_each_entry(fh, &luo_file_handler_list, list) {
 		if (fh->ops->can_preserve(fh, file)) {
-			err = 0;
+			if (try_module_get(fh->ops->owner))
+				err = 0;
 			break;
 		}
 	}
@@ -292,7 +293,7 @@ int luo_preserve_file(struct luo_file_set *file_set, u64 token, int fd)
 
 	err = luo_flb_file_preserve(fh);
 	if (err)
-		goto err_free_files_mem;
+		goto err_module_put;
 
 	luo_file = kzalloc_obj(*luo_file);
 	if (!luo_file) {
@@ -322,6 +323,8 @@ int luo_preserve_file(struct luo_file_set *file_set, u64 token, int fd)
 	kfree(luo_file);
 err_flb_unpreserve:
 	luo_flb_file_unpreserve(fh);
+err_module_put:
+	module_put(fh->ops->owner);
 err_free_files_mem:
 	luo_free_files_mem(file_set);
 err_fput:
@@ -364,6 +367,7 @@ void luo_file_unpreserve_files(struct luo_file_set *file_set)
 		args.private_data = luo_file->private_data;
 		luo_file->fh->ops->unpreserve(&args);
 		luo_flb_file_unpreserve(luo_file->fh);
+		module_put(luo_file->fh->ops->owner);
 
 		list_del(&luo_file->list);
 		file_set->count--;
@@ -648,6 +652,7 @@ static void luo_file_finish_one(struct luo_file_set *file_set,
 
 	luo_file->fh->ops->finish(&args);
 	luo_flb_file_finish(luo_file->fh);
+	module_put(luo_file->fh->ops->owner);
 }
 
 /**
@@ -782,7 +787,8 @@ int luo_file_deserialize(struct luo_file_set *file_set,
 		down_read(&luo_register_rwlock);
 		list_private_for_each_entry(fh, &luo_file_handler_list, list) {
 			if (!strcmp(fh->compatible, file_ser[i].compatible)) {
-				handler_found = true;
+				if (try_module_get(fh->ops->owner))
+					handler_found = true;
 				break;
 			}
 		}
@@ -796,8 +802,10 @@ int luo_file_deserialize(struct luo_file_set *file_set,
 		}
 
 		luo_file = kzalloc_obj(*luo_file);
-		if (!luo_file)
+		if (!luo_file) {
+			module_put(fh->ops->owner);
 			return -ENOMEM;
+		}
 
 		luo_file->fh = fh;
 		luo_file->file = NULL;
@@ -858,12 +866,6 @@ int liveupdate_register_file_handler(struct liveupdate_file_handler *fh)
 		}
 	}
 
-	/* Pin the module implementing the handler */
-	if (!try_module_get(fh->ops->owner)) {
-		err = -EAGAIN;
-		goto err_unlock;
-	}
-
 	INIT_LIST_HEAD(&ACCESS_PRIVATE(fh, flb_list));
 	INIT_LIST_HEAD(&ACCESS_PRIVATE(fh, list));
 	list_add_tail(&ACCESS_PRIVATE(fh, list), &luo_file_handler_list);
@@ -893,6 +895,4 @@ void liveupdate_unregister_file_handler(struct liveupdate_file_handler *fh)
 	guard(rwsem_write)(&luo_register_rwlock);
 	luo_flb_unregister_all(fh);
 	list_del(&ACCESS_PRIVATE(fh, list));
-
-	module_put(fh->ops->owner);
 }
-- 
2.43.0


