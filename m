Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 05376CD98D2
	for <linux-mm@archiver.kernel.org>; Tue, 16 Jun 2026 20:41:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EDBE56B0096; Tue, 16 Jun 2026 16:41:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E8BB26B0098; Tue, 16 Jun 2026 16:41:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D7BB86B0099; Tue, 16 Jun 2026 16:41:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9BDC36B0096
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 16:41:25 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B15561C0E91
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 20:36:15 +0000 (UTC)
X-FDA: 84886933110.01.1EE1423
Received: from mail-ej1-f73.google.com (mail-ej1-f73.google.com [209.85.218.73])
	by imf29.hostedemail.com (Postfix) with ESMTP id C288C120004
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 20:36:13 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=G6hDL8aS;
	spf=pass (imf29.hostedemail.com: domain of 3bE4xagkKCCcWDUXQVDKXJRRJOH.FRPOLQXa-PPNYDFN.RUJ@flex--tarunsahu.bounces.google.com designates 209.85.218.73 as permitted sender) smtp.mailfrom=3bE4xagkKCCcWDUXQVDKXJRRJOH.FRPOLQXa-PPNYDFN.RUJ@flex--tarunsahu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781642173;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vEk+wmrFXeXruHfFEsfJwOEWHnGQlk3rAiCVWz123x8=;
	b=sLfrC6YZXA2anEzOKSaEQis3N8U1G+4ACUVOvzfa27ilWFNXyS/1wCELP3UoLQg1LXjkDC
	4gMH6vZZV5efFoZ/CuMuDxwHv1pZxYQRuzr2GctmxpgRwzElAkvzyR6LwbIrnWwszWvGe0
	1QtSDrUmv3SOmc8VkeUcuiKLxIcxXiE=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=G6hDL8aS;
	spf=pass (imf29.hostedemail.com: domain of 3bE4xagkKCCcWDUXQVDKXJRRJOH.FRPOLQXa-PPNYDFN.RUJ@flex--tarunsahu.bounces.google.com designates 209.85.218.73 as permitted sender) smtp.mailfrom=3bE4xagkKCCcWDUXQVDKXJRRJOH.FRPOLQXa-PPNYDFN.RUJ@flex--tarunsahu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781642173;
	b=3cb0llyaaLsiIxDfLU5DpqrO90e+7IZDISUf2pE5UlD5aMI0Cz/FuT9Dm/7UKX1lJCSXlE
	H0xwarHga/nXjdvY7j2YG+uWJ1S9GETWaH3MWpapa4KsKFG5ARRK6t+MNCam9io4AYfVZE
	uNBV7bq2vHGh0+fhu/y3DUtDODeIYcI=
Received: by mail-ej1-f73.google.com with SMTP id a640c23a62f3a-bec440e6b9fso434310766b.0
        for <linux-mm@kvack.org>; Tue, 16 Jun 2026 13:36:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781642171; x=1782246971; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=vEk+wmrFXeXruHfFEsfJwOEWHnGQlk3rAiCVWz123x8=;
        b=G6hDL8aSc98blG+j9bP0jH2YVzADUyytU2O6aSWr8vejOLZ7bMPYbW6Me5aYbJdNQG
         CegebMxyNLbeB+GLNzQKPkjdPtSSPbCDp5Ovnv6U0wMf73XN0WnZKv4R26ia7MKvLib2
         Vd5LXNllowqmln8smKkpKzUR1UAXVEUbuTWdvylNAjcSgQ0hERtah1TEvZZSaQQNrxdS
         RiShyES2hudw9gLOwGp1DnUiyhDu/3iNVk6T3heDyES/ZyiqTtzxC+LnmbXtKyVUnPv1
         Qwt6Rj7cm6r7XD896UFSOjedcheejr0ThAtNGe2Ym1zNhSOOs36igCrIuPS1/RYA7Bcj
         85Kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781642171; x=1782246971;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vEk+wmrFXeXruHfFEsfJwOEWHnGQlk3rAiCVWz123x8=;
        b=ZuTT6REN3q+6q3ofTEHrNaodcztnmI5U4Vcf4qCVPaV2bdMdIc6v/tRL6ykZIjT4wg
         1heOQq8KPI0gnwfBb6NstRyKcWcLbBW000vp6V7WwTuhXrzRqQsGvYu2aadJazcNocaS
         0nEvo5+JGq9BY6/OXj60dJvQKwVquX39T6ton8Sq9zOfQHhR1JbrveDwwRpcu7y+DRLP
         IoQdOnT/y099JZ7H/WSN1E8d7K1k6G2PyWlEEaa1WbdfzTI/vVcjEWx4GobBroocoDBa
         esd9Rfil62yPjNQpP7h6qAXUcO2RwPh2fI9ltLu8kxEDxQNt9Fxil1RXahdPaQ8s8AXD
         ueLg==
X-Forwarded-Encrypted: i=1; AFNElJ8HZhEzJCVZQVyG5SV+IiS9ZKg8eaHUnFnOK37et6JemvTp5joSa/x6PtvXDnJ8hji2VnwNPjTxNQ==@kvack.org
X-Gm-Message-State: AOJu0YzgrIhCtwVM5WhXQGWSvOJ+0N+FPGNw+TIrQEgTAM/djFjJbHPo
	S8KKyjKlkYmQGkHPrTGAWAz79YXnjDmDAIUM4EZXKSHBwCSL3hwJWXkgvJbFfch7+BPGWHELqBj
	L6trd1slx+WUJD32D1w==
X-Received: from wmbfp27.prod.google.com ([2002:a05:600c:699b:b0:490:b360:5841])
 (user=tarunsahu job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:a0c:b0:490:bb19:b110 with SMTP id 5b1f17b1804b1-490ec50a221mr256551145e9.27.1781616236229;
 Tue, 16 Jun 2026 06:23:56 -0700 (PDT)
Date: Tue, 16 Jun 2026 13:23:51 +0000
In-Reply-To: <cover.1781615759.git.tarunsahu@google.com>
Mime-Version: 1.0
References: <cover.1781615759.git.tarunsahu@google.com>
X-Mailer: git-send-email 2.54.0.1136.gdb2ca164c4-goog
Message-ID: <7dc691529948f688204f6c6e626723be88fbc578.1781615759.git.tarunsahu@google.com>
Subject: [PATCH v2 2/2] luo: Update serialized data to KHOSER_PTR
From: Tarun Sahu <tarunsahu@google.com>
To: Alexander Graf <graf@amazon.com>, Pratyush Yadav <pratyush@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	kexec@lists.infradead.org, Tarun Sahu <tarunsahu@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: C288C120004
X-Stat-Signature: 6rwzbw3oaf4yms47mrmme8ut57nfmasn
X-Rspam-User: 
X-HE-Tag: 1781642173-879603
X-HE-Meta: U2FsdGVkX1/j5DT8rVTmI1GouWvCI+qdDZtkkihVqYvDx1nKMc+triPyEoZxrOC91+HrAy5yi3UBQ5I5gwkhn6P5B0/v7WufOAuZ6SsIqtR4h8rhsZ2QfKf/xz74NyMi+4Dp2zcZSrWtu3Gttu6dgYED5M7BtYmr0Uel1iEVxXzVMlYGTYTNsK7qtRp5cZVzL3l62NfZb7V38bv3052vmTjmzSRTs/QSz/aQAi5HIJCOmVCyQUr6g/yDJ9z7Edy+i449ooEBClwWJHNwSbbzeb7n+8HTJ/sQEwfehlnCO6uIV4/R5To1vNw39LgQThyPwcFylhCv0VhaNb+Tw1nvC2oSRlAT0zqHwt15Avgn4dwDJIMh0Rayup4tSI32scngH0huwrWkUyF1tepHG/dcR/Ee0yOgN7i2VgOiFeI7FSqzJOEI18DI8geFVHdF3bdbDcRWAqr3uZtgjKLGXQxhvLfolYD3H8tBjmZCOTxa4N2O8VgDf/dtZOSl2zHsw+tvhezLacp2UuvRCJ8b3/BugGpnFDnjsmB3rmIZMjyFCNtxddrfBxhU8MP+q0vsvVjMhOlHDAhEC/xXvJRkHoOAzm8Zl0fL8s6SS2rrtMoYh3hz0dPTZ664YuM20zYtAbsJN8GmTl2OiAC4XcQj2t4+KVlomhLymup1li22su9zKLf0CEBHcOTyPyh+hW+9f2X+f478tL2EoP9BgOcPsLia2JIbWum9Ne9YzyPKBS5sA3BoZEebvClI4j06qJ5On0DrvGo2Mp1ESpt+BP78mHNaW5E5nqbteQF85knA+l211FEOtZGUymUHv10tubt8KdobbvNQO4UNS2Wt6jBhTnsNfOmJqh0OR2fFRJ7f2PKtrmhS/lnLqqITc9LfLkQteC1CSxux7flmEPVRZIQr68/mZXmrgA6DlLtCcaKXI2cIgaWSWNBFq5zYbSEzDeUXo5cB7eOSA7pjCD2xvT0PUig
 mhEHgWLj
 BOFdkJyJye36z3Z8MxhafWulhDNa8GWtBeMT6Hs1aEDpmMEwDCTQGQWS5WtxOC5C9rmejADAeCyCe4OzO/h/XqdeAZcJCz3nFGZ3lmC6+SxwPaf0tGmTO5OhYxHi1TtJu3oFkvMguwxUcehc9Hejj8Hea6hAGohqH8B5Vr1KayeaYkTec7lbxT/DXh7OGv0T1IQBVoDXw65fQuVqqBNfIEb+SlRgPx3jhJdfPj/cNqleGW+ZGTeK+17eQmjQ//+ffTOFw/9XoinK4vdbX5ylqJys1uIrNam9/OVuUOJP/KZdYJ+7cfVS0+tYS45VwWoDmakfeR9Yi38wBVoZQShT1JLvlitWw5pdvWi/QabFOZhieEq3GOvVlIsVaDd09y1hC3uNbrFeZuF5YH1YGN5fgDffbhsm5pxWe5bzqx5BvlbrIMXDI5uTOZp7n4o5lFKGRIVlF8Ree7y0Lma6GZeCfgEm38rGMpQ1biHBvbEYP6JWLPwFckOcY5+6Icw7GAD3sgjWs364LXOaGi0gGgdgyl0NmzUsrQPPJWveNpDuuB6iEtrUkvEBU1oR0PV37wuMlyPNIOEdn8fAToW+KXfwW6RX70fkkd707ObDgy8OeUEfCwyGx6QVsaI7LDAKEcKXfHu+p5Jw2XqR0dWTLaWzJ+eStUvEdBEqgqb2bT0L8GtkHNPApn2kDhVDnF9uK9IJ0uX6d
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently luo_file_ser, luo_file and liveupdate_file_op_args use the raw
serialized_data which stores the phys address of the serialized data. There
are two issues
1. It uses raw update, and there is not type safety check
2. user of liveupdate_file_op_args, uses virt_to_phys and phys_to_virt
   to convert the serializeable pointer to physical address and vice versa.
   User makes mistakes mistake to check the serializeable pointer/phys
   value check before converting like in memfd_luo.

Converting them to serializeable pointer enforce type safety check ( it has
its limitation as you can not have generic serializeable pointer for all
the subsystem. So only void * is the only choice, and updating it require
user to use KHOSER_COPY_TYPEUNSAFE) and the null value check.

This patch also updates the memfd_luo to use the newly introduced the
serializeable pointer. Which mitigates the issue of not checking
args->serialized_data pointer before using it.

Fixes: b3749f174d68 ("mm: memfd_luo: allow preserving memfd")
Signed-off-by: Tarun Sahu <tarunsahu@google.com>
---
 include/linux/kho/abi/luo.h  |  6 ++++--
 include/linux/liveupdate.h   |  4 ++--
 kernel/liveupdate/luo_file.c | 24 ++++++++++++------------
 mm/memfd_luo.c               | 18 +++++++++---------
 4 files changed, 27 insertions(+), 25 deletions(-)

diff --git a/include/linux/kho/abi/luo.h b/include/linux/kho/abi/luo.h
index 46750a0ddf88..6b08fbf7ad59 100644
--- a/include/linux/kho/abi/luo.h
+++ b/include/linux/kho/abi/luo.h
@@ -119,17 +119,19 @@
 
 #define LIVEUPDATE_HNDL_COMPAT_LENGTH	48
 
+#include <linux/kho/abi/kexec_handover.h>
+
 /**
  * struct luo_file_ser - Represents the serialized preserves files.
  * @compatible:  File handler compatible string.
- * @data:        Private data
+ * @serialized_data: Serializable pointer union for private data.
  * @token:       User provided token for this file
  *
  * If this structure is modified, LUO_SESSION_COMPATIBLE must be updated.
  */
 struct luo_file_ser {
 	char compatible[LIVEUPDATE_HNDL_COMPAT_LENGTH];
-	u64 data;
+	DECLARE_KHOSER_PTR(serialized_data, void *);
 	u64 token;
 } __packed;
 
diff --git a/include/linux/liveupdate.h b/include/linux/liveupdate.h
index 30c5a39ff9e9..8b3466801159 100644
--- a/include/linux/liveupdate.h
+++ b/include/linux/liveupdate.h
@@ -32,7 +32,7 @@ struct file;
  * @file:             The file object. For retrieve: [OUT] The callback sets
  *                    this to the new file. For other ops: [IN] The caller sets
  *                    this to the file being operated on.
- * @serialized_data:  The opaque u64 handle, preserve/prepare/freeze may update
+ * @serialized_data:  The serialized pointer union, preserve/prepare/freeze may update
  *                    this field.
  * @private_data:     Private data for the file used to hold runtime state that
  *                    is not preserved. Set by the handler's .preserve()
@@ -46,7 +46,7 @@ struct liveupdate_file_op_args {
 	struct liveupdate_file_handler *handler;
 	int retrieve_status;
 	struct file *file;
-	u64 serialized_data;
+	DECLARE_KHOSER_PTR(serialized_data, void *);
 	void *private_data;
 };
 
diff --git a/kernel/liveupdate/luo_file.c b/kernel/liveupdate/luo_file.c
index a0a419085e28..c50c8239a34d 100644
--- a/kernel/liveupdate/luo_file.c
+++ b/kernel/liveupdate/luo_file.c
@@ -130,7 +130,7 @@ static DEFINE_XARRAY(luo_preserved_files);
  * @file:          Pointer to the kernel's &struct file that is being preserved.
  *                 This is NULL in the new kernel until the file is successfully
  *                 retrieved.
- * @serialized_data: The opaque u64 handle to the serialized state of the file.
+ * @serialized_data: The serialized pointer union to the serialized state of the file.
  *                 This handle is passed back to the handler's .freeze(),
  *                 .retrieve(), and .finish() callbacks, allowing it to track
  *                 and update its serialized state across phases.
@@ -166,7 +166,7 @@ static DEFINE_XARRAY(luo_preserved_files);
 struct luo_file {
 	struct liveupdate_file_handler *fh;
 	struct file *file;
-	u64 serialized_data;
+	DECLARE_KHOSER_PTR(serialized_data, void *);
 	void *private_data;
 	int retrieve_status;
 	struct mutex mutex;
@@ -328,7 +328,7 @@ int luo_preserve_file(struct luo_file_set *file_set, u64 token, int fd)
 	if (err)
 		goto err_kfree;
 
-	luo_file->serialized_data = args.serialized_data;
+	KHOSER_COPY_TYPESAFE(luo_file->serialized_data, args.serialized_data);
 	luo_file->private_data = args.private_data;
 	list_add_tail(&luo_file->list, &file_set->files_list);
 	file_set->count++;
@@ -381,7 +381,7 @@ void luo_file_unpreserve_files(struct luo_file_set *file_set)
 
 		args.handler = luo_file->fh;
 		args.file = luo_file->file;
-		args.serialized_data = luo_file->serialized_data;
+		KHOSER_COPY_TYPESAFE(args.serialized_data, luo_file->serialized_data);
 		args.private_data = luo_file->private_data;
 		luo_file->fh->ops->unpreserve(&args);
 		luo_flb_file_unpreserve(luo_file->fh);
@@ -412,12 +412,12 @@ static int luo_file_freeze_one(struct luo_file_set *file_set,
 
 		args.handler = luo_file->fh;
 		args.file = luo_file->file;
-		args.serialized_data = luo_file->serialized_data;
+		KHOSER_COPY_TYPESAFE(args.serialized_data, luo_file->serialized_data);
 		args.private_data = luo_file->private_data;
 
 		err = luo_file->fh->ops->freeze(&args);
 		if (!err)
-			luo_file->serialized_data = args.serialized_data;
+			KHOSER_COPY_TYPESAFE(luo_file->serialized_data, args.serialized_data);
 	}
 
 	return err;
@@ -433,7 +433,7 @@ static void luo_file_unfreeze_one(struct luo_file_set *file_set,
 
 		args.handler = luo_file->fh;
 		args.file = luo_file->file;
-		args.serialized_data = luo_file->serialized_data;
+		KHOSER_COPY_TYPESAFE(args.serialized_data, luo_file->serialized_data);
 		args.private_data = luo_file->private_data;
 
 		luo_file->fh->ops->unfreeze(&args);
@@ -515,7 +515,7 @@ int luo_file_freeze(struct luo_file_set *file_set,
 
 		strscpy(file_ser[i].compatible, luo_file->fh->compatible,
 			sizeof(file_ser[i].compatible));
-		file_ser[i].data = luo_file->serialized_data;
+		KHOSER_COPY_TYPESAFE(file_ser[i].serialized_data, luo_file->serialized_data);
 		file_ser[i].token = luo_file->token;
 		i++;
 	}
@@ -621,7 +621,7 @@ int luo_retrieve_file(struct luo_file_set *file_set, u64 token,
 	}
 
 	args.handler = luo_file->fh;
-	args.serialized_data = luo_file->serialized_data;
+	KHOSER_COPY_TYPESAFE(args.serialized_data, luo_file->serialized_data);
 	err = luo_file->fh->ops->retrieve(&args);
 	if (err) {
 		/* Keep the error code for later use. */
@@ -655,7 +655,7 @@ static int luo_file_can_finish_one(struct luo_file_set *file_set,
 
 		args.handler = luo_file->fh;
 		args.file = luo_file->file;
-		args.serialized_data = luo_file->serialized_data;
+		KHOSER_COPY_TYPESAFE(args.serialized_data, luo_file->serialized_data);
 		args.retrieve_status = luo_file->retrieve_status;
 		can_finish = luo_file->fh->ops->can_finish(&args);
 	}
@@ -672,7 +672,7 @@ static void luo_file_finish_one(struct luo_file_set *file_set,
 
 	args.handler = luo_file->fh;
 	args.file = luo_file->file;
-	args.serialized_data = luo_file->serialized_data;
+	KHOSER_COPY_TYPESAFE(args.serialized_data, luo_file->serialized_data);
 	args.retrieve_status = luo_file->retrieve_status;
 
 	luo_file->fh->ops->finish(&args);
@@ -837,7 +837,7 @@ int luo_file_deserialize(struct luo_file_set *file_set,
 
 		luo_file->fh = fh;
 		luo_file->file = NULL;
-		luo_file->serialized_data = file_ser[i].data;
+		KHOSER_COPY_TYPESAFE(luo_file->serialized_data, file_ser[i].serialized_data);
 		luo_file->token = file_ser[i].token;
 		mutex_init(&luo_file->mutex);
 		list_add_tail(&luo_file->list, &file_set->files_list);
diff --git a/mm/memfd_luo.c b/mm/memfd_luo.c
index 59de210bee5f..daf2c4c3da35 100644
--- a/mm/memfd_luo.c
+++ b/mm/memfd_luo.c
@@ -257,6 +257,7 @@ static void memfd_luo_unpreserve_folios(struct kho_vmalloc *kho_vmalloc,
 
 static int memfd_luo_preserve(struct liveupdate_file_op_args *args)
 {
+	DECLARE_KHOSER_PTR(sd, struct memfd_luo_ser *);
 	struct inode *inode = file_inode(args->file);
 	struct memfd_luo_folio_ser *folios_ser;
 	struct memfd_luo_ser *ser;
@@ -309,7 +310,8 @@ static int memfd_luo_preserve(struct liveupdate_file_op_args *args)
 	inode_unlock(inode);
 
 	args->private_data = folios_ser;
-	args->serialized_data = virt_to_phys(ser);
+	KHOSER_STORE_PTR(sd, ser);
+	KHOSER_COPY_TYPEUNSAFE(args->serialized_data, sd);
 
 	return 0;
 
@@ -325,11 +327,10 @@ static int memfd_luo_freeze(struct liveupdate_file_op_args *args)
 {
 	struct memfd_luo_ser *ser;
 
-	if (WARN_ON_ONCE(!args->serialized_data))
+	ser = KHOSER_LOAD_PTR(args->serialized_data);
+	if (WARN_ON_ONCE(!ser))
 		return -EINVAL;
 
-	ser = phys_to_virt(args->serialized_data);
-
 	/*
 	 * The pos might have changed since prepare. Everything else stays the
 	 * same.
@@ -344,14 +345,13 @@ static void memfd_luo_unpreserve(struct liveupdate_file_op_args *args)
 	struct inode *inode = file_inode(args->file);
 	struct memfd_luo_ser *ser;
 
-	if (WARN_ON_ONCE(!args->serialized_data))
+	ser = KHOSER_LOAD_PTR(args->serialized_data);
+	if (WARN_ON_ONCE(!ser))
 		return;
 
 	inode_lock(inode);
 	shmem_freeze(inode, false);
 
-	ser = phys_to_virt(args->serialized_data);
-
 	memfd_luo_unpreserve_folios(&ser->folios, args->private_data,
 				    ser->nr_folios);
 
@@ -397,7 +397,7 @@ static void memfd_luo_finish(struct liveupdate_file_op_args *args)
 	if (args->retrieve_status)
 		return;
 
-	ser = phys_to_virt(args->serialized_data);
+	ser = KHOSER_LOAD_PTR(args->serialized_data);
 	if (!ser)
 		return;
 
@@ -522,7 +522,7 @@ static int memfd_luo_retrieve(struct liveupdate_file_op_args *args)
 	struct file *file;
 	int err;
 
-	ser = phys_to_virt(args->serialized_data);
+	ser = KHOSER_LOAD_PTR(args->serialized_data);
 	if (!ser)
 		return -EINVAL;
 
-- 
2.54.0.1136.gdb2ca164c4-goog


