Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6B7CC109447F
	for <linux-mm@archiver.kernel.org>; Sat, 21 Mar 2026 14:43:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D422A6B00BB; Sat, 21 Mar 2026 10:43:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D1F0A6B00C1; Sat, 21 Mar 2026 10:43:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C56DC6B00C3; Sat, 21 Mar 2026 10:43:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B332B6B00BB
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 10:43:44 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7D7ABC1AC7
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 14:43:44 +0000 (UTC)
X-FDA: 84570339168.01.2572C85
Received: from hillsboro-edge.smtp.mymangomail.com (hillsboro-edge.smtp.mymangomail.com [5.78.130.219])
	by imf07.hostedemail.com (Postfix) with ESMTP id 55FC84000C
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 14:43:42 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gerlicz.space header.s=mango-1 header.b=UOeGJKtx;
	spf=pass (imf07.hostedemail.com: domain of oskar@gerlicz.space designates 5.78.130.219 as permitted sender) smtp.mailfrom=oskar@gerlicz.space;
	dmarc=pass (policy=quarantine) header.from=gerlicz.space
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774104222;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=h+HanHTyFc9rRinieUfKka3/7aq/7tvNhr3nQ0O56VQ=;
	b=0A+U0ln5IcXdG+/6Xc3ghD3MavwrBYTAi97HGreEFisf20TXGik6tbVW0Xw0DVFSsCUa31
	GzJlfmaDxjTbNWCMmwgMNhZHA9yXQUgqRfRMPmCFqfj+FqtYE66p2wG8ssln02xLErZdWB
	k9UBUNDnxDka8qDhrWAHZ5mEK5fQgtk=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gerlicz.space header.s=mango-1 header.b=UOeGJKtx;
	spf=pass (imf07.hostedemail.com: domain of oskar@gerlicz.space designates 5.78.130.219 as permitted sender) smtp.mailfrom=oskar@gerlicz.space;
	dmarc=pass (policy=quarantine) header.from=gerlicz.space
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774104222; a=rsa-sha256;
	cv=none;
	b=VIjCj0Dtp17qUHGq0xpswD0EnPj82qUlIslayg7nzcqxsKpj4z5UKI1vuXQEmPazPvkvpy
	nDq3CP7kDtB8W0VIiCq8y1DISAemG+alO25xfj2Z1TvrIKehlJLrqmO5de0OJYAB/xDse3
	z6zjlO9lg1XvRuMCfCW59Gg+C9RheTM=
Received: from smtp.mymangomail.com (localhost [127.0.0.1])
	by smtp.mymangomail.com (Mango Mail) with ESMTP id 0A4B14162F;
	Sat, 21 Mar 2026 10:43:30 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gerlicz.space;
	s=mango-1; t=1774104210;
	bh=iijof/0zlMIHD/7/fVF2LLJM8239N8q06Cog8S4qnEA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UOeGJKtxlJtcUM3CqUoQVPwcUk2Z32Ql85ogfV/JiPVLPt6qlXIjjxgBGds10Ch5B
	 VrMv0s7Cwpce9/yg5zCRq+OmlcRD56mIt+SDiE0YH/XR2H8egsMNAlnx/Vpg0MI7Z3
	 I7AW64pBdCpxPGCrVvqSBRf5OKN+WI/X2Ti9DPIg=
X-Mango-Origin: 1
X-Mango-Origin: 1
X-Mango-Origin: 1
X-Mango-Origin: 1
X-Mango-Origin: 1
X-Mango-Origin: 1
X-Mango-Origin: 1
X-Mango-Origin: 1
X-Mango-Origin: 1
Received: from authenticated-user (smtp.mymangomail.com [205.185.121.143])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits)
 server-digest SHA256)
	(No client certificate requested)
	by smtp.mymangomail.com (Mango Mail) with ESMTPSA id C666141627;
	Sat, 21 Mar 2026 10:42:26 -0400 (EDT)
From: Oskar Gerlicz Kowalczuk <oskar@gerlicz.space>
To: Pasha Tatashin <pasha.tatashin@soleen.com>,
	Mike Rapoport <rppt@kernel.org>,
	Baoquan He <bhe@redhat.com>
Cc: Pratyush Yadav <pratyush@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org,
	kexec@lists.infradead.org,
	linux-mm@kvack.org,
	Oskar Gerlicz Kowalczuk <oskar@gerlicz.space>
Subject: [PATCH v3 5/5] liveupdate: harden FLB lifetime and teardown paths
Date: Sat, 21 Mar 2026 15:36:42 +0100
Message-ID: <20260321143642.166313-5-oskar@gerlicz.space>
In-Reply-To: <20260321143642.166313-4-oskar@gerlicz.space>
References: <20260321143642.166313-1-oskar@gerlicz.space>
 <20260321143642.166313-2-oskar@gerlicz.space>
 <20260321143642.166313-3-oskar@gerlicz.space>
 <20260321143642.166313-4-oskar@gerlicz.space>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 55FC84000C
X-Stat-Signature: yxujeefpj467pns6thkerxhbtj33s7rk
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1774104222-15554
X-HE-Meta: U2FsdGVkX19ouyq+lZc2w6jYmzOLO+D6IQ9XCoLjgbSqrEML+gklrntZHxW+HSmBsq3qTeTR/0lWkXrgOciK+yUAVkfI69pRd3leN7Xr8U29BpjugLSj8PUNbsZsZi8q2SL7BE49BYmKVesKoc6ydPk8qnapqtZHbFLYkn71kOT460sqZ4dzhhIaUyo+RABCxG4iQNVdQrapOMnowpFETFqbVgXxBLs4M1pKwFeN0OMRY9yiKhn1nFBrpmb3f+fF/td0zHRblVrKPnkZXi8Wr2N5270/IvfFqC8X/+kETgRsHwbA+2koqCtBHSaZlvxkOllCcOa2EZMTChgfMRIiFSoj54zBVWeKhWMp054ta8IU0lCMAo98JM15IPXVMb61fmilfC+fx7IXxUdXznA2a8JPnSRofOlt7c0evRHPYA7fObvxbjpBRkFf9Ck2SZx5E0vhoeh2bh5rnQTcR3vCkITIj0/shzFIWlnAiffMBFNnRD8HKq963/ffJrIyV1FwjLFK425kFFv5Wqkh6iMslYaMLOb5DpCWW6Xeo7StepLSQszoyP+GbAQRRF8D6tw0aFpClKA0CxwqZegxtM9dT7t9Du7PpGisLvJjLFXrpPNYHFbK6FuiYzEH84phK23vIgcERBLaVYziE4tUw6mimkC2wXit3Lg3IDnQ4aeitVRuWpt8h7hfAzDTkfe7IVHaD5tVXrjG19cpLSJh7QpMCDPXdiWXGEUWhCiU/ruOKc2xSw8NIHXCWlZ346Hs22TF0oewnCXjTT2n3AJ/9v+Uk8WplDTgpCWB+iu4DGlQVd9PXORFxQlbsvvbDPIAUyM7RMuwbyY2bpDHP7Ei+Y1lgTdM3iFcmphTUzBhoEs6ea+dN/+2dynUj2Pm/+LYPsRIDd1OgoQhf1Db4GBK8gDFqKbFWUjAF14gDYpKlNmiGwxBCs45810yrRrwo6VuXj41ZoFhaJLwAvTkVtlhKuI
 1LpSfr0i
 DbEwTUU7+8lmrUZ7ngManCddpPd+1Tj9rdqNIs+wicrhIrhePgrEQcHGFp5JjMy9vmaeWIxVO8lzE20nkoAFBJaZTrFxaGa08Udxfh2kAXMeFIVKns8jc/5yLy3h97RgkCAofHYSKQmxZfp0V45KTZN2y0/EUGalxl8O+YM+0q6a1Ei6t7ALKuu1DAm+t+lAqc6CpYzzpOUvLUqYilcBldjh5HnmQYKDmmByFx+qicL/HxiAARk1QjSLPNDfC1vLhfvzte9BsRhaEpaDwbQiyvyQCRuGRWp/okmsZ89Dpk/cGJaPcKnHglHy11Ylnh3oizcxOsuf9du2RV8i/EN/msn7E2n/Ev6wz6CeizxB2CerISf4+W4Ua7D0D/g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The remaining FLB teardown paths still had a few lifetime holes. Incoming
counters could underflow, the returned incoming object was not pinned
against concurrent finish, and copied incoming FLB metadata could be
freed while another thread was still scanning it.

That makes incoming FLB teardown racy and can leave callers with stale
objects or freed metadata.

Guard the FLB counters, make liveupdate_flb_get_incoming() hold the
incoming FLB lock until the caller releases it, and serialize access to
the copied incoming FLB metadata while it is being retrieved or
discarded.

Fixes: 8c31961065ee ("liveupdate: harden FLB and incoming teardown paths")
Signed-off-by: Oskar Gerlicz Kowalczuk <oskar@gerlicz.space>
---
 include/linux/liveupdate.h       |  5 ++
 kernel/liveupdate/luo_flb.c      | 78 ++++++++++++++++++++++++--------
 kernel/liveupdate/luo_internal.h |  1 +
 lib/tests/liveupdate.c           |  2 +
 4 files changed, 66 insertions(+), 20 deletions(-)

diff --git a/include/linux/liveupdate.h b/include/linux/liveupdate.h
index 611907f57127..dd34587a9c4e 100644
--- a/include/linux/liveupdate.h
+++ b/include/linux/liveupdate.h
@@ -240,6 +240,7 @@ int liveupdate_unregister_flb(struct liveupdate_file_handler *fh,
 			      struct liveupdate_flb *flb);
 
 int liveupdate_flb_get_incoming(struct liveupdate_flb *flb, void **objp);
+void liveupdate_flb_put_incoming(struct liveupdate_flb *flb);
 int liveupdate_flb_get_outgoing(struct liveupdate_flb *flb, void **objp);
 
 #else /* CONFIG_LIVEUPDATE */
@@ -286,6 +287,10 @@ static inline int liveupdate_flb_get_incoming(struct liveupdate_flb *flb,
 	return -EOPNOTSUPP;
 }
 
+static inline void liveupdate_flb_put_incoming(struct liveupdate_flb *flb)
+{
+}
+
 static inline int liveupdate_flb_get_outgoing(struct liveupdate_flb *flb,
 					      void **objp)
 {
diff --git a/kernel/liveupdate/luo_flb.c b/kernel/liveupdate/luo_flb.c
index cdd293408138..2cd5864c8b26 100644
--- a/kernel/liveupdate/luo_flb.c
+++ b/kernel/liveupdate/luo_flb.c
@@ -70,6 +70,8 @@ struct luo_flb_global {
 	long count;
 };
 
+static DEFINE_MUTEX(luo_flb_incoming_lock);
+
 static struct luo_flb_global luo_flb_global = {
 	.list = LIST_HEAD_INIT(luo_flb_global.list),
 };
@@ -128,6 +130,9 @@ static void luo_flb_file_unpreserve_one(struct liveupdate_flb *flb)
 	struct luo_flb_private *private = luo_flb_get_private(flb);
 
 	scoped_guard(mutex, &private->outgoing.lock) {
+		if (WARN_ON_ONCE(!private->outgoing.count))
+			return;
+
 		private->outgoing.count--;
 		if (!private->outgoing.count) {
 			struct liveupdate_flb_op_args args = {0};
@@ -161,22 +166,24 @@ static int luo_flb_retrieve_one(struct liveupdate_flb *flb)
 	if (private->incoming.retrieved)
 		return 0;
 
-	if (!fh->active)
-		return -ENODATA;
-
-	for (int i = 0; i < fh->header_ser->count; i++) {
-		if (strnlen(fh->ser[i].name, sizeof(fh->ser[i].name)) ==
-		    sizeof(fh->ser[i].name))
-			return -EINVAL;
+	scoped_guard(mutex, &luo_flb_incoming_lock) {
+		if (!fh->active)
+			return -ENODATA;
 
-		if (!strcmp(fh->ser[i].name, flb->compatible)) {
-			if (!fh->ser[i].count)
+		for (int i = 0; i < fh->header_ser->count; i++) {
+			if (strnlen(fh->ser[i].name, sizeof(fh->ser[i].name)) ==
+			    sizeof(fh->ser[i].name))
 				return -EINVAL;
 
-			private->incoming.data = fh->ser[i].data;
-			private->incoming.count = fh->ser[i].count;
-			found = true;
-			break;
+			if (!strcmp(fh->ser[i].name, flb->compatible)) {
+				if (!fh->ser[i].count)
+					return -EINVAL;
+
+				private->incoming.data = fh->ser[i].data;
+				private->incoming.count = fh->ser[i].count;
+				found = true;
+				break;
+			}
 		}
 	}
 
@@ -201,8 +208,12 @@ static void luo_flb_file_finish_one(struct liveupdate_flb *flb)
 	struct luo_flb_private *private = luo_flb_get_private(flb);
 	u64 count;
 
-	scoped_guard(mutex, &private->incoming.lock)
+	scoped_guard(mutex, &private->incoming.lock) {
+		if (WARN_ON_ONCE(!private->incoming.count))
+			return;
+
 		count = --private->incoming.count;
+	}
 
 	if (!count) {
 		struct liveupdate_flb_op_args args = {0};
@@ -303,6 +314,17 @@ void luo_flb_file_finish(struct liveupdate_file_handler *fh)
 		luo_flb_file_finish_one(iter->flb);
 }
 
+void luo_flb_discard_incoming(void)
+{
+	struct luo_flb_header *fh = &luo_flb_global.incoming;
+
+	guard(mutex)(&luo_flb_incoming_lock);
+	kfree(fh->header_ser);
+	fh->header_ser = NULL;
+	fh->ser = NULL;
+	fh->active = false;
+}
+
 /**
  * liveupdate_register_flb - Associate an FLB with a file handler and register it globally.
  * @fh:   The file handler that will now depend on the FLB.
@@ -490,7 +512,8 @@ int liveupdate_unregister_flb(struct liveupdate_file_handler *fh,
  * @objp: Output parameter; will be populated with the live shared object.
  *
  * Returns a pointer to its shared live object for the incoming (post-reboot)
- * path.
+ * path. The returned pointer remains valid until
+ * liveupdate_flb_put_incoming() is called.
  *
  * If this is the first time the object is requested in the new kernel, this
  * function will trigger the FLB's .retrieve() callback to reconstruct the
@@ -508,17 +531,30 @@ int liveupdate_flb_get_incoming(struct liveupdate_flb *flb, void **objp)
 	if (!liveupdate_enabled())
 		return -EOPNOTSUPP;
 
-	if (!private->incoming.obj) {
+	if (!READ_ONCE(private->incoming.obj)) {
 		int err = luo_flb_retrieve_one(flb);
 
 		if (err)
 			return err;
 	}
 
-	guard(mutex)(&private->incoming.lock);
+	mutex_lock(&private->incoming.lock);
+	if (!private->incoming.obj)
+		goto err_unlock;
 	*objp = private->incoming.obj;
 
 	return 0;
+
+err_unlock:
+	mutex_unlock(&private->incoming.lock);
+	return -ENODATA;
+}
+
+void liveupdate_flb_put_incoming(struct liveupdate_flb *flb)
+{
+	struct luo_flb_private *private = luo_flb_get_private(flb);
+
+	mutex_unlock(&private->incoming.lock);
 }
 
 /**
@@ -640,9 +676,11 @@ int __init luo_flb_setup_incoming(void *fdt_in)
 	if (!header_copy)
 		return -ENOMEM;
 
-	luo_flb_global.incoming.header_ser = header_copy;
-	luo_flb_global.incoming.ser = (void *)(header_copy + 1);
-	luo_flb_global.incoming.active = true;
+	scoped_guard(mutex, &luo_flb_incoming_lock) {
+		luo_flb_global.incoming.header_ser = header_copy;
+		luo_flb_global.incoming.ser = (void *)(header_copy + 1);
+		luo_flb_global.incoming.active = true;
+	}
 
 	return 0;
 }
diff --git a/kernel/liveupdate/luo_internal.h b/kernel/liveupdate/luo_internal.h
index 4842c7dbeb63..e4d1919370f1 100644
--- a/kernel/liveupdate/luo_internal.h
+++ b/kernel/liveupdate/luo_internal.h
@@ -113,6 +113,7 @@ void luo_flb_file_unpreserve(struct liveupdate_file_handler *fh);
 void luo_flb_file_finish(struct liveupdate_file_handler *fh);
 int __init luo_flb_setup_outgoing(void *fdt);
 int __init luo_flb_setup_incoming(void *fdt);
+void luo_flb_discard_incoming(void);
 void luo_flb_serialize(void);
 
 #ifdef CONFIG_LIVEUPDATE_TEST
diff --git a/lib/tests/liveupdate.c b/lib/tests/liveupdate.c
index 496d6ef91a30..620cefd52229 100644
--- a/lib/tests/liveupdate.c
+++ b/lib/tests/liveupdate.c
@@ -105,6 +105,8 @@ static void liveupdate_test_init(void)
 			pr_err("liveupdate_flb_get_incoming for %s failed: %pe\n",
 			       flb->compatible, ERR_PTR(err));
 		}
+		if (!err)
+			liveupdate_flb_put_incoming(flb);
 	}
 	initialized = true;
 }
-- 
2.53.0


