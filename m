Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B108A10BA423
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 03:33:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 444486B00A6; Thu, 26 Mar 2026 23:33:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3D5146B00A8; Thu, 26 Mar 2026 23:33:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2962C6B00A9; Thu, 26 Mar 2026 23:33:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1582A6B00A6
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 23:33:47 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DF54A140AD2
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 03:33:46 +0000 (UTC)
X-FDA: 84590423652.07.09E1BDD
Received: from mail-qv1-f52.google.com (mail-qv1-f52.google.com [209.85.219.52])
	by imf30.hostedemail.com (Postfix) with ESMTP id 193EE8000E
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 03:33:44 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=Ctl70eOy;
	spf=pass (imf30.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.219.52 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774582425;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3hDiA51qt4kdhGsAF/wtP6SU35I33186MYzANJAE0/8=;
	b=gRGFmeEtpJ/eqqTLLgZ5ywUDItqGOkf33NFropPRX8wJAj3vmdFY2mHRO/VNfwly6A4qs5
	PH6OzABySmJKyG6gnk1MzS1B0c6/g4RApRRjYf1t1eKqp/Sc0fiLRtJGRXwluI8YA2Jaqv
	99sl9CHfjkINv2EnDmY1gFNYyFIgeow=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=Ctl70eOy;
	spf=pass (imf30.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.219.52 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774582425; a=rsa-sha256;
	cv=none;
	b=TRnfJss6DnZ0fv24+d6s6NKqSSF8MIQOI1RqTzrx4K3rya4JwmnVr7mGIOvwytdWwOs68Y
	EQuPmPulqHrh/BoC4YcTZ3qGTInp1sfyKX0dhxxcTn5sag/wNU9OhDbBs933OkYrykd0vU
	cixYFOxtYaTsQRrzp0Hm+Tr7N8EqeXA=
Received: by mail-qv1-f52.google.com with SMTP id 6a1803df08f44-89a1d7cc7f0so14216546d6.1
        for <linux-mm@kvack.org>; Thu, 26 Mar 2026 20:33:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1774582424; x=1775187224; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3hDiA51qt4kdhGsAF/wtP6SU35I33186MYzANJAE0/8=;
        b=Ctl70eOyPYIEfISWTzNWwg2sD7ZOR4/R9EvqaOI1oqLyTx2N+rYR4HFwQJNzhxAFGk
         S73w8gAU7wmzhCIs6GP4p702I1kfzkcr5lZrfE7+gQ/upZ9lXewMTY0YIbmy36iYufmO
         vtrp/7UVwy3+kYKiWDuYZLC4vpTjv8Hj4kcdJeh9t2rWgT4GTPVlSBWHXRiaBRvh3EDL
         Wp3pSau3TtKuIJcJK82Ry4eFfTzOns/ZYEEBsjZaiISCCTtRQADBIkGfL/6Coe5Al5Sj
         IAEElpCMkm7QxzmPybfNtSGUmezQ9SGoiGAQeFMVklEEYoJFOlW2iFS6bg1Ltnh8aZd2
         UQyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774582424; x=1775187224;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=3hDiA51qt4kdhGsAF/wtP6SU35I33186MYzANJAE0/8=;
        b=Q9B41NL/BTZO+o3f0+dRYxQB8Z9+TiXSR0n9USVSddyLRsD2A2objDdiZMPH7Uc83s
         cOqcIEtNzW8znRBikDq/hEGkbVDXLkVyj+hU8FCG5COjtzHeIUIqkv4nkYMKVjEsiPsM
         igBphbZcCrqaIxQvIrPN0iLDAAFuQIP3nOQFarRmlnv943RI1zfLIUWFueA1gb1gVq92
         8ORe+PQE8GaaVfvI5D1Sqzy2XB+xsSpghi8y+2c1/9WViL8TqnawjjDfG4vZX6j7SFJw
         KbV9s7nmCDnSu+3HcAVI2tkxeL9EOHwnH2eyJQiJmAlPAZ16Qh2Y3IeYMF1U6KBYQorA
         BSuQ==
X-Forwarded-Encrypted: i=1; AJvYcCX2iZMgK0YAX8336/H85aLk9HX6ff37cGnREhVJaC5/fifBzSgyU1jamPCZVsKnt2TQrpn+QfQhoA==@kvack.org
X-Gm-Message-State: AOJu0YwnlOScDMI3lj30hkxo8Rz1Jl5R+PN+9SybcHBN4W6/QSbxKxrk
	Hxs1jCBhXD2iZyqV7LqkdFziUd7dfmJo19ivS7AYotSFLlvpp67dv+K9aTaA0r0DkzQ=
X-Gm-Gg: ATEYQzxziMuhw0c3RD7EBr94ZgCJR3zwgQnoTjjQirufAcfLby6xJjrKl66cyZ2lcMu
	SmS7ELCxjAxrrg1tiNjcHNHTtGomWVKFhTR7eGHRZu2GumpRShi0dyWjACC5Rg59UihwLegMAwU
	+iz5f0+Gl2jqkeIrifR4z4u7VZmeW547s2K1ChV260UDpnyuqH6BKhHrrLmCRtvSXQuRHwMKo2h
	UcbWl6uQ07EhwY0LbRL+EMJcD3zVctNqSNmVsROwiMOOriB1e86tMoPcnWExyE2V9KIVOP/ZjiP
	J58bb+8Ip45Vg5maVYHaNEzGvH5p1h7Vv4LG5GEizcETrN/aYOq1asN16UzPg2oqNbnMX2LHrRu
	E+yZHjpuGaLDda0swQOGVZehu8f25I6jjoTQ1HyiQC92ZOXuQ8aIxF+r3Fe3wQiO8NE5hMN554F
	9D+HiZqgPP2YSqcb2xTRGr30uxigmLjhGUgGY/onEK+nR6W6fnXeYn1C2uxVqoDl3dLw==
X-Received: by 2002:a05:6214:d4e:b0:899:ea9e:31c4 with SMTP id 6a1803df08f44-89ce8f6abe6mr11258026d6.51.1774582424185;
        Thu, 26 Mar 2026 20:33:44 -0700 (PDT)
Received: from plex.localdomain ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-89cd5a22711sm46519186d6.27.2026.03.26.20.33.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Mar 2026 20:33:43 -0700 (PDT)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: rppt@kernel.org,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	pasha.tatashin@soleen.com,
	dmatlack@google.com,
	pratyush@kernel.org,
	skhawaja@google.com
Subject: [PATCH v3 07/10] liveupdate: Auto unregister FLBs on file handler unregistration
Date: Fri, 27 Mar 2026 03:33:31 +0000
Message-ID: <20260327033335.696621-8-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260327033335.696621-1-pasha.tatashin@soleen.com>
References: <20260327033335.696621-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 193EE8000E
X-Stat-Signature: hd91swqsacf46gc8dw4mf35gemkhfbo6
X-Rspamd-Server: rspam06
X-HE-Tag: 1774582424-313939
X-HE-Meta: U2FsdGVkX1+atcSIpV5JnWIaOi/o3OEniQ3Uqv75cA0KtgbvUm/hWDFSQSKCbryLnCLp/WgmNE5x8FGNHVLLen8RaMuVWNCJg32EVgOL27YF4zDGgtW+aMLaW3v4jmVa+di5Px0EmIQWcWl6g3ip0a1cI9ZBi/VnFb1z+cwU03PBsPASI0sTvLLR0qheRiztBYlxpvjrIGJRrOM399ggWt2eVxbI8iOQBMWUep2wblycxHueM4RfMfHwv/dC4kyGcJqGB4tr8Se5wN+njxTODtE/o7vaLjckPDqTOplqcyeCVIdVJ6U9cha6eOhyJHy+P3ClHgkrQRYUG5YXUQ+mS+RuId575EZOrigiI7B+RRUtRlXfYQfe3Bk265gL1EQ64xRgJLMouGKqTtGsoAZ4/TtcgPsfFR8i66x18WLAkp71ewKqUBxXlOoqxDeipoWItoXeZsdWCnVIeAQNaEnyGWKC13OVSICAsJU3U2196UxyzmcEV0dASGnRRERRlufEZ+izbsEalCqg3jnZJj2WRDrtIttQL5m1MHG0J5yXqsuzuS8znCPDn8fnGjdO9sZVYwCclcBndd8eeRPX02b/Js8gmVcAVAgvIDhDUUYDzITkrsUAO2OhdLuL5s0h5j5RLe/hmkdgkp6rNMZuvOyShZ2hnWffv8UEfQNqltJAXpWnRyISoqLwQ7YIzuG3xann9Rpp9JYebueMuPjIevBf0zHfI2Relv+/wmvvsFFSyJ8HNVLzQmylQSJPC2oO3s8x7usHLnMeejbRbflAj1SSRg/NEabb6FkPWhCjFfVlTkhgau92UHQMENvGft8fu6lppdJqW79YzgPejw7lzdK2+n1vngDSzZLN2XzoRhw50Dk9ipk3q8on6TH7Vu5AwXaTtPOfQw1lUQF+LAo8DSXBIplkkxTujqIU0kNYwPFgaQULJfL4q3oi8O1DkkEUzDF2F6NZak3h8tcPJ+vmolv
 rmlu34Cz
 Bo28baAOeVyY9BJrfj9LFtxmf7jFRnJ6bFkzwPFmqqYs/UOpTq7yK7eBjIkTjG99S1b1hP87x+77aX2Js9zRu5Sa73YJnCGYetJIS4B0toghKTu3sdWVVPxul5/eYmG2MwbJl78yqyLQIr/bEvCb8uVAqkjEv60/R/2JBFOq/BWF8hgVzDPLOYFUIKDX5Ma/nU97gs9GSFLJqykTjFjhdthPEIt6XrI/hjgRdRPLMbtcJx67Vis/ZIG2fFKyIGH+r8j9drsDtK3aCxkNM7UKmr8aPHtrJF/nhxX38Q6ZsMdCcqcc5leEvDoCnW13LXFqJoP/kU/fbM9kzvFWEtOQKM7zinPrhhcCfk/mYYHYon9wshhPyh5PW2RDy07Hu+PeUcSzCIwYF1XGWZBFHI6bHoBxih8Q7O5r0e2aO
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
 kernel/liveupdate/luo_file.c     | 14 +-----
 kernel/liveupdate/luo_flb.c      | 84 ++++++++++++++++++++++----------
 kernel/liveupdate/luo_internal.h |  1 +
 3 files changed, 60 insertions(+), 39 deletions(-)

diff --git a/kernel/liveupdate/luo_file.c b/kernel/liveupdate/luo_file.c
index 439177c10723..80f4e3b796a6 100644
--- a/kernel/liveupdate/luo_file.c
+++ b/kernel/liveupdate/luo_file.c
@@ -895,26 +895,16 @@ int liveupdate_register_file_handler(struct liveupdate_file_handler *fh)
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
index ac6fa5b34b43..f8348138de70 100644
--- a/kernel/liveupdate/luo_flb.c
+++ b/kernel/liveupdate/luo_flb.c
@@ -335,6 +335,62 @@ void luo_flb_file_finish(struct liveupdate_file_handler *fh)
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
+	lockdep_assert_held_write(&luo_register_rwlock);
+	list_for_each_entry_safe(iter, tmp, flb_list, list)
+		luo_flb_unregister_one(fh, iter->flb);
+}
+
 /**
  * liveupdate_register_flb - Associate an FLB with a file handler and register it globally.
  * @fh:   The file handler that will now depend on the FLB.
@@ -443,38 +499,12 @@ int liveupdate_register_flb(struct liveupdate_file_handler *fh,
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


