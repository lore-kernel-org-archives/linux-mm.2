Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5712C103E18F
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 14:17:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 732646B0253; Wed, 18 Mar 2026 10:17:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6BB0B6B0255; Wed, 18 Mar 2026 10:17:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4C1AB6B0253; Wed, 18 Mar 2026 10:17:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 15EB06B024E
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 10:17:08 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A2F311B8A41
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 14:17:05 +0000 (UTC)
X-FDA: 84559385610.18.AF43678
Received: from mail-yx1-f49.google.com (mail-yx1-f49.google.com [74.125.224.49])
	by imf29.hostedemail.com (Postfix) with ESMTP id B7692120018
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 14:17:03 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=fHu1fqzp;
	spf=pass (imf29.hostedemail.com: domain of pasha.tatashin@soleen.com designates 74.125.224.49 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773843423;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J4M6tHJH+NIswtfacOyFlweafgc3XAP5SglzYx4YyzE=;
	b=1mNCLREhsEanrYQuotP3va3D8c3/rsd22ytKoLGarxaQdMWktTUkv1rpDOnJ9+cz/8RxVy
	IVBEdMNcjog+mSZildM55cveCHjqEkgc4pf4zrlDUcLzPmCilBUY/0mvqOjOMGzlRIqYLI
	pTmC5kir8x3PPCPCxc2y/JShmZ7ywlk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773843423; a=rsa-sha256;
	cv=none;
	b=YLrhp1fhr3M1HOHeIVtbBMuXCRKJxmCG3YV25uvBkgdA9VHX69ehk+ID4esg+6///BaeH/
	lxhWxkOX0/tDHjtntPw2iU/4gy5fb9YCveyni5zHbbBC4CJ+6KqVNLKJUfiSRDFlkm760t
	qSBoEj4BzMG1npalVQkaxkmySdI4yu0=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=fHu1fqzp;
	spf=pass (imf29.hostedemail.com: domain of pasha.tatashin@soleen.com designates 74.125.224.49 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-yx1-f49.google.com with SMTP id 956f58d0204a3-64ca423ad53so7340586d50.0
        for <linux-mm@kvack.org>; Wed, 18 Mar 2026 07:17:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1773843423; x=1774448223; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=J4M6tHJH+NIswtfacOyFlweafgc3XAP5SglzYx4YyzE=;
        b=fHu1fqzpwpNzrqz5KfsmE9OocMV0+vmJkzzrkvkynfA9fBIT6Pz2bJC5ioBMQJKaWf
         cw2rZRtYmR0URwDgqYTnCaa/XjikHQNY0XzBBv9LEoGAJlrzBfZx9xbVS5o1/D5BLvYl
         1PPCTZ/Wq8erlYodJ4c8CgfjeVatSud+zLjm3xRHpqNpeUqEPiKz72SYrYitY4qM9TXW
         c7Wkv5qzpPbn27Ocxc9Jj5FBb965ie+QpTenW9INM9ezb63nCtQT3o3mY0aCkFEVaMWR
         oDcrFmX41vO/LWGcVVXKtxsLyJDqlJWu8kkfSiwk20nTc3awttR7Qr7Nx7EcyTxRcLvt
         tLDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773843423; x=1774448223;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=J4M6tHJH+NIswtfacOyFlweafgc3XAP5SglzYx4YyzE=;
        b=ArXreUhXahrfkieoAGZwJUzU9YWDgTAPUr9ne0YE+qCIoIDTbLi9sb3KfOkbDmncs+
         /fICL3hIrwyrrdj+p2YPvHpYK7TFA59+m+fS4vR+2HeCh6tInQMy1rlS7zghN5gaCZNF
         eMRGEv4kMXkeEXdTbh6ddh+cT9caQ5ZkUajqqbo52q1aU2W9YyAKdejGawJjMVaSTIHf
         Uxxt5tfTsd6eqPJeTqL0uwlxEbANarx2mABOAXpXxfGS4hUFVXENxM8YE6SU+YU/cKQf
         m+r1bIeKn3/gNFZZqEBRPqe45MtPCZ2wQMyq5YPMXAxmQuMbxY8jqBkR4wPdzlZeZ9Ch
         776A==
X-Forwarded-Encrypted: i=1; AJvYcCXukx7ZokSxtfWM3ZmmpVt0ETzQuChUHs1OWQJ1VWGvKZoEfbImaTaj/gbJZzQWSqk7UCoJ8dzlng==@kvack.org
X-Gm-Message-State: AOJu0Yx3grZ6KfhB85CHvysj7v8uiloIM7h/1MeCuSZE98KhNrApA6K1
	pWgNJ1L7V+vzCLKBoolKzBW17jQks2iOZzPPn5funMxvq4J/M1ZSt8bq/cgABrVs9kVxgaEiUyB
	JeiGC
X-Gm-Gg: ATEYQzyDtxNHI5JMTdm5af2QFwjRl3fzlqJP9dXw6fZDWOSi5nyWKLbo/WuBjysyUUI
	oHksx4NLejG64OZML/6w1QNf7DXdzPDwbaNT0wz2SN3YXohdqLSOzuca6jv7gZySMSbXcikk9Bz
	4lxaIWS2buW5rnevswYQI83Xi00B+ZOLuKUEQWGllqJ2akxB1ahvaQpj8b16vfuE9upgq7YlOGh
	DC4NQcLoYK1vJmet2gJWJ88ZXLFzDwEGB1UM1hxV5n8QoQ7Mo1+tVTwKO5vohjzDktgzZABt0ks
	5StEf9RlsY5RI9n7VgP30X3g6B7Kn0xNs6ZAgC6sveyrPLjjBamUBT/VMxGvMiO9YtsmIlYS8M9
	JsJI5cGNAgqH+KOkyjl26pAZ2WrcpfjKq0U/VTi9E1CIrm5hAvz8/qjeKZ0bBYWf5/hk/7OFrjg
	ELugSah2FNLyMD1mPEaCUbjidD7FOAvhDX4tiEAglCK3PM/46gk0638hjONFV4yHq+LRaOrZ2fV
	6tVVIbH+H2SXAwKIuFnMLV4Ye1IP20eh+nADqWqOSaJgEwMOA==
X-Received: by 2002:a53:ccc1:0:b0:64c:f90c:740b with SMTP id 956f58d0204a3-64e9133cc6cmr2802395d50.18.1773843422693;
        Wed, 18 Mar 2026 07:17:02 -0700 (PDT)
Received: from soleen.c.googlers.com.com (57.233.150.34.bc.googleusercontent.com. [34.150.233.57])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-64e91be0e91sm1672028d50.15.2026.03.18.07.17.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Mar 2026 07:17:01 -0700 (PDT)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: rppt@kernel.org,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	pasha.tatashin@soleen.com,
	dmatlack@google.com,
	pratyush@kernel.org
Subject: [PATCH v2 6/8] liveupdate: Auto unregister FLBs on file handler unregistration
Date: Wed, 18 Mar 2026 10:16:44 -0400
Message-ID: <20260318141637.1870220-16-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.53.0.851.ga537e3e6e9-goog
In-Reply-To: <20260318141637.1870220-10-pasha.tatashin@soleen.com>
References: <20260318141637.1870220-10-pasha.tatashin@soleen.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=6387; i=pasha.tatashin@soleen.com;
 h=from:subject; bh=EalrGmrqwRzzH6yUEQF0bva997eCnPDMp/i8mRFTvIA=;
 b=owEBbQKS/ZANAwAKAbt3KEzbc3reAcsmYgBpurPNTzeG4rxv/awumbGni4KwSHI8Znp/TwC3c
 +0LmOIOqaCJAjMEAAEKAB0WIQRBMaqT7LRvGvB/NmK7dyhM23N63gUCabqzzQAKCRC7dyhM23N6
 3kp7D/9rYKOXxrYJk2Vo8xunmH8iFfYAyW1VooFl+SuhHbwZjw1AkNif4cjY4Xf2ewk0ThMNTQ5
 7l987GROBYr+Z0JBaB15vSO79amsq+XsNBD1TbTm+9jRbfF6apyY0ul5pXw43lbV45CkDJ7LvNF
 sRia+95B/ECSas2//sdqLD/8UqD1R3fDMUBkdSguuoONWkgWfLBoC8fV9KOLr+E50PAAor1XYjw
 lEpaTVF58eKKeGAN4VGmKVfl7QdaQnd+vx/Zopnbh6L1H677NPE5YE0YXhmE+olW6opFlj4DYFH
 aQkrt4D2J0jx9QY6eMKGXoadD6ufLUxRDJF6XEEA+8CrZAmOWbNJycefp87udjAuU/pWIdr1FCh
 gMTLC9X3bwlqkZffir6BfwyCHbZ7zxR8Hhtwq4zYD3DCZo1QkkQrzz0ACo1JtHDGU2bB9/QhWZO
 I6nJLQVYAtReRso101qqMvsqWnGBcmkdRUPngcLoUzVJ3cGH8prwiLR5ik99jac8O3NEMsBvYMh
 83BUndZnaVme2f950b7mUDo7ufJJwxTYK3++gQ41Cupfa5216iaZZeU7MzLvSMzVhYuiodHQwFt
 7i7tBY0VF869IR1E6E8RaIan+ol65/ZJHYkfqd4aiVPoWlArw395OleHCAUbSOFfbn+jdvh5+gG uTeI/EbAK1ZhyBA==
X-Developer-Key: i=pasha.tatashin@soleen.com; a=openpgp; fpr=CAAAB722DD22A081F0D49F35633A6A993D43B569
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: wm9uszm1ambh3q1k95xn81cqyxfyt3d9
X-Rspamd-Queue-Id: B7692120018
X-Rspamd-Server: rspam03
X-HE-Tag: 1773843423-846714
X-HE-Meta: U2FsdGVkX187tw2hb2CYmqJ71pNg7nY5LYdxwKTVboJFN/ny3j0n8/kYKkshOaRPGrZXchl6fsNfpHPpdfgSzR/Z+ogg7mVPTy0f7u88Y8qzmCGzrLMcfa/DGQ0s234rCB5ATufdjqZ6Rms2GYFZtE1PA8ujRBzlpdZuAROIbceEil9fcIS9SXhYuHJrmzm6uv3kwX7FjaXC7AYtjhh5TLPfY4WcPiYrkVgtKCAh+ovFlWh1OfoqyKIWSZfn1Rxb0L/5/F9pjVYjadP43nvFHfILR/2TXUxIqEOBwizJjJIWzA+l/8eSheCaHOfLbl/91FkeZrco7MYnovlDfsknTM+/SNwdo5yuf8F9G6FJyYGbYkuzfPoqXRi//5wbk5Yc8+flwKbuER3GJcmNwUFROCEporAjbxzRKFwp+aq/fAoEmoPBKvOXZO8reP5rwOTthiyMTEutyb9jdaIrJqH9Ns3bX2TqOQxC1EQJfCnvY8wxwQpb18lZwb8mgD3Wm9zz71eoVcN/PRBLcfJrI+L+OAE1XkgLsEAmnQvWG8U9zizIBdWb7uG60WM6MzRyTIgADy9TxwLOc6sXg7ujSHI2YHyiqKZhE/WprJmMtrcPpwhTFV9OhvnaxHod9C2xLHWgVquIhbbR28wXDJ039FpQOT9RVlzkQVsmLTzsyZO7h1tRI9Fgx/hsTMc5VnWJUBDd3u2NDmHtghFxpL7GaM+ed96rhzGfXyrTzymHCOyxOyeoC+YqpiHN8RNiQhRAD0b3evnZ/2S/tiEpTQrj5qZ0Uh140+lw4UEkYS7lcmb/KKNjDjGEk1fcis6+fpK8TUnTNu3gIxcmDd7ncXDOFrQ0Wmmz6eZZlL+CTMdWmtnWUKj5lCE6diEjKxnDsKXC7Sow1IGXQY+OdaSYGe1YtIz+Orb5cYt31r8XCN03YoWB7IOcjuSblYDgLWOISlQhb5J2B4BsZ6xRDP6Vuuaj1Hi
 nIDkfcUY
 jM5kDCrInZk+vxt4tjrmt9Qtl5/cdq/S2onNpTK+HPSjfl1AYMth7X6t/rn+p8bVgV2rbsbgWq1gno5bfUUK3itSxL/dk0Tsx1EW3f/5IcebvnhZu15CThVoycXJXbr67ez2Gkojc4MU59cWiOpc2CXzvUXymnFbdAdKiQJ3SBCvuos/Kk+iUgJHwuSylIx/xGSwFlXIH7otf9VYD9jFeyuIs906KbfF1XAO9MXOYnaQ4BET2qL4GgOwxOWjAyDY9lth2y0kG/Il6y1GDMT67URAopkpQD1ng5BMrTe6Z4yUwMgO8+MPEuX6Q+GtQyhO8s+BE
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
---
 kernel/liveupdate/luo_file.c     | 17 +-----
 kernel/liveupdate/luo_flb.c      | 93 ++++++++++++++++++++------------
 kernel/liveupdate/luo_internal.h |  1 +
 3 files changed, 61 insertions(+), 50 deletions(-)

diff --git a/kernel/liveupdate/luo_file.c b/kernel/liveupdate/luo_file.c
index c0ce08d55747..b9ba1b8dce84 100644
--- a/kernel/liveupdate/luo_file.c
+++ b/kernel/liveupdate/luo_file.c
@@ -873,15 +873,6 @@ int liveupdate_register_file_handler(struct liveupdate_file_handler *fh)
  *
  * Unregisters the file handler from the liveupdate core. This function
  * reverses the operations of liveupdate_register_file_handler().
- *
- * It ensures safe removal by checking that:
- * No FLB registered with this file handler.
- *
- * If the unregistration fails, the internal test state is reverted.
- *
- * Return: 0 Success. -EOPNOTSUPP when live update is not enabled. -EBUSY A live
- * update is in progress, FLB is registred with
- * this file handler.
  */
 int liveupdate_unregister_file_handler(struct liveupdate_file_handler *fh)
 {
@@ -891,15 +882,9 @@ int liveupdate_unregister_file_handler(struct liveupdate_file_handler *fh)
 	liveupdate_test_unregister(fh);
 
 	scoped_guard(rwsem_write, &luo_file_handler_lock) {
-		if (!list_empty(&ACCESS_PRIVATE(fh, flb_list)))
-			goto err_register;
-
+		luo_flb_unregister_all(fh);
 		list_del(&ACCESS_PRIVATE(fh, list));
 	}
 
 	return 0;
-
-err_register:
-	liveupdate_test_register(fh);
-	return -EBUSY;
 }
diff --git a/kernel/liveupdate/luo_flb.c b/kernel/liveupdate/luo_flb.c
index 8bbe11a7286b..5b61c0844a49 100644
--- a/kernel/liveupdate/luo_flb.c
+++ b/kernel/liveupdate/luo_flb.c
@@ -316,6 +316,64 @@ void luo_flb_file_finish(struct liveupdate_file_handler *fh)
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
+	guard(rwsem_write)(&luo_flb_lock);
+	guard(rwsem_write)(&ACCESS_PRIVATE(fh, flb_lock));
+
+	list_for_each_entry_safe(iter, tmp, flb_list, list)
+		luo_flb_unregister_one(fh, iter->flb);
+}
+
 /**
  * liveupdate_register_flb - Associate an FLB with a file handler and register it globally.
  * @fh:   The file handler that will now depend on the FLB.
@@ -417,50 +475,17 @@ int liveupdate_register_flb(struct liveupdate_file_handler *fh,
  * the FLB is removed from the global registry and the reference to its
  * owner module (acquired during registration) is released.
  *
- * Context: This function ensures the session is quiesced (no active FDs
- *          being created) during the update. It is typically called from a
- *          subsystem's module exit function.
- * Return: 0 on success.
- *         -EOPNOTSUPP if live update is disabled.
- *         -EBUSY if the live update session is active and cannot be quiesced.
- *         -ENOENT if the FLB was not found in the file handler's list.
  */
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
 
 	guard(rwsem_write)(&luo_flb_lock);
 	guard(rwsem_write)(&ACCESS_PRIVATE(fh, flb_lock));
 
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
index ec949f91c8c1..730c3faa7616 100644
--- a/kernel/liveupdate/luo_internal.h
+++ b/kernel/liveupdate/luo_internal.h
@@ -101,6 +101,7 @@ void luo_file_set_destroy(struct luo_file_set *file_set);
 int luo_flb_file_preserve(struct liveupdate_file_handler *fh);
 void luo_flb_file_unpreserve(struct liveupdate_file_handler *fh);
 void luo_flb_file_finish(struct liveupdate_file_handler *fh);
+void luo_flb_unregister_all(struct liveupdate_file_handler *fh);
 int __init luo_flb_setup_outgoing(void *fdt);
 int __init luo_flb_setup_incoming(void *fdt);
 void luo_flb_serialize(void);
-- 
2.53.0.851.ga537e3e6e9-goog


