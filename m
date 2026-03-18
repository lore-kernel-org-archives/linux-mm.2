Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 75B9F103E18D
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 14:17:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 891D46B020E; Wed, 18 Mar 2026 10:17:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7CD666B0213; Wed, 18 Mar 2026 10:17:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 66F0F6B0246; Wed, 18 Mar 2026 10:17:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4E35C6B020E
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 10:17:01 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id EA4235AC08
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 14:17:00 +0000 (UTC)
X-FDA: 84559385400.06.8D0C74F
Received: from mail-yx1-f50.google.com (mail-yx1-f50.google.com [74.125.224.50])
	by imf20.hostedemail.com (Postfix) with ESMTP id 13DCA1C0003
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 14:16:58 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=RYSK6RRm;
	spf=pass (imf20.hostedemail.com: domain of pasha.tatashin@soleen.com designates 74.125.224.50 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773843419;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iae6YsWSZF4NEuA9NS1+GhS3bfxbm2onYFzq2DhQW14=;
	b=yDr+ri9XxB0d3Pii2JV28xG3P5TEsP9szEGrqgeqp5xWlg/ChPZDbsCEPnDXMhubBBiWHJ
	wEx+IlE7sG6XT7LpPg/sFMcYKi4doT+X29PdyRGI0qd1QsLihPbzBgL/JOOp+wHx/VlJRL
	rnXLxpspo1Bh2NZcNTKAZHvYO+0ZKX0=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=RYSK6RRm;
	spf=pass (imf20.hostedemail.com: domain of pasha.tatashin@soleen.com designates 74.125.224.50 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773843419; a=rsa-sha256;
	cv=none;
	b=TryRZZCLHbz1rI+Kb73bBN6fhlbRkIWMyZ6Cf0CtfuMLutMuQlbEEs4/yKJSR2gY1a45HX
	0L/11s0P26tuzswUCyCbhOpY3huWHiSwPokSlE1Q3FBO4d6aMVjLJCB5ejGaiSyH2BpVHh
	PM0odk4Ezf8k3o9K3YjHxmI/3YRpq5Q=
Received: by mail-yx1-f50.google.com with SMTP id 956f58d0204a3-64ad9fabd08so7932046d50.2
        for <linux-mm@kvack.org>; Wed, 18 Mar 2026 07:16:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1773843418; x=1774448218; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=iae6YsWSZF4NEuA9NS1+GhS3bfxbm2onYFzq2DhQW14=;
        b=RYSK6RRmQyVHlQwXA3h66+ZbE1zIuP3y0PBzwS+EFm2wQsaujdBr5KfgehVMU0eF0G
         pBdWnMxiBXmSHLn4GMFWd+0SNt2KqTuR7wKHm5SyhXfsKTjZs5s9sJ8vBxR82/1BA+au
         8hPohn/fNWKiCVzUUkRJXkuZmoa6u45lVx7b8k6zPqfv5XLwmKWb8qGXlnuYho1G/Kl/
         suDYBPwDLSKctcLkZ8BfGbWgdvtv0ggfNdLlplOEbOBNSEhXI15jkUuUQxFwBueEzw7E
         qS9t2hVQfcvBNm/vAScWHZ9q1hkMv1vQVfkaOshdHTW2yc1H2YBSWms+Bv+ndRghabO4
         Rk8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773843418; x=1774448218;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=iae6YsWSZF4NEuA9NS1+GhS3bfxbm2onYFzq2DhQW14=;
        b=gIA52xPxpUDajlPsbsoiFgWAuZK1xCP9mK8OTbWLMSFtD30y5X5r7L+62EohHKXOwl
         vuLBG8G0ZvwW4D/qrA59nqDV9gwY/XeU2T7c2VjMBn+OpDOv4LDOZtI/1dUn/PiM8402
         OfIUc+t1JEW2iutFIg5uMmb4LfZZbpxVHZQ9NukWafL6+wiGbOPZjG4OzLmFnbLpXMo3
         1bEnpDNEqt+wl1GfH/iZ7vLt9DWCvetNSsa29GS1niOW9eiQXYolANxlxg1fV6/2OrG2
         BmNb43fUCXEAtLOUruNhBr01qq6O9zokxbglkbD5VgOa6SgkdZm/8e/DTaveNS8vty2I
         t4DQ==
X-Forwarded-Encrypted: i=1; AJvYcCXv3ywR0TEAKVBKYUrwfknrznGVg0MVxKOFceObvYGZ7bNI1O/T2YcT8tPOaHuDzpk9UIkMcbRAkQ==@kvack.org
X-Gm-Message-State: AOJu0Ywm+QC7t9Xit9DvNXND7HbT+MVBruNMw2ruvSBzx59SHKvqb7PW
	cwp2FVBwIrLR1fTgsjcPdU1jCCWONiRo86KNUNynzcFvoRqldCfTVaPj0MTt2TqTfb4=
X-Gm-Gg: ATEYQzzyi7KlVr/YMnZVExqOEHHkU81kSahZw0ByPfxQ6/Pyskvg9OuqZJPz0T/zUND
	V70D+EpRmYhKRzXWAQ2jIV6CeO2aIYJiPU/vZCLXCyu/UfX/jcc4SAn8FjMSMAtTG5MeNvNsGP3
	pUL//7VONG+d37QmJM6b+XU8GW+5lTvBGiA7TZ3+hcCEaW08YqO9bA9hqBb4WoDEQB11Br2d3YT
	iVgYBLcCF1ljuwOO/aztbEjlPfMisLI973k3sp5Z9TehObe2uv/B21mwmTrPopu5/6cAR7yCxNV
	mTmuPnexGoXQrX8OKZqIZTiFhkFZmykqqgKHakScc7N8tkwTQTC5cVW0Cyxc4RkK2iVGveRYnxS
	SLIIPbg4O0uidqL2Nhax5CEhYAuNirKo9Qgh1bePO2rMA45Xr7KY+HUAKMxfV9R4QMiT+0LnKoD
	LG19IuAamyIaAiay5HT2QfZVLoUkNySZvzIMCl3cVc3DOPyYp/9JjWV59miNaYRhExOXm5BmSjK
	w5PIopn5J8M+q/XOdszCvj2RRJGhilBOoCIKK3RC6jEanJQ9WYhoKunMoFo
X-Received: by 2002:a05:690e:1a03:b0:649:f272:4e71 with SMTP id 956f58d0204a3-64e915e9af0mr2899384d50.61.1773843417840;
        Wed, 18 Mar 2026 07:16:57 -0700 (PDT)
Received: from soleen.c.googlers.com.com (57.233.150.34.bc.googleusercontent.com. [34.150.233.57])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-64e91be0e91sm1672028d50.15.2026.03.18.07.16.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Mar 2026 07:16:57 -0700 (PDT)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: rppt@kernel.org,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	pasha.tatashin@soleen.com,
	dmatlack@google.com,
	pratyush@kernel.org
Subject: [PATCH v2 2/8] liveupdate: Protect FLB lists with rwsem
Date: Wed, 18 Mar 2026 10:16:40 -0400
Message-ID: <20260318141637.1870220-12-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.53.0.851.ga537e3e6e9-goog
In-Reply-To: <20260318141637.1870220-10-pasha.tatashin@soleen.com>
References: <20260318141637.1870220-10-pasha.tatashin@soleen.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=4697; i=pasha.tatashin@soleen.com;
 h=from:subject; bh=dkjsJaF9zS233/cIv2JZuqCsRBtr9t9nThiFjC9QTdU=;
 b=owEBbQKS/ZANAwAKAbt3KEzbc3reAcsmYgBpurPIEf2Hd/j/HyvzxGhdP66f5gdQf18OjzKVY
 0RUvUJ6F6uJAjMEAAEKAB0WIQRBMaqT7LRvGvB/NmK7dyhM23N63gUCabqzyAAKCRC7dyhM23N6
 3gGLD/44VIJY2e4gFWjXLJ68WeFLVVKrzyz58iPZAdSWRcT/aWoEVdIF4BQIzow+V+IIcH4NY/w
 Nn/LuiuTU89YdpPeiXb2E5HdyAbL+lDx26BgrQVWW6/mCe4iarCbKAd3OW5Xf7587w7g7+flKYQ
 zWYVKFpwv/yejr4B7xe+RSc6bpTOM7OM/4Fu2c8uGHW5UqJMiqMq6XYWBFyeg2Pi8Jizr9/5Bbb
 fOm1BU3MC1nFb352hGrjCfbWinbaSsVqEjRoGKqE3YyZAhSftlXlZkkf0Br82sasckGzKlH8dXt
 +lYELDGrBrAkBJs7t+3ufEkg+e5ZY8ZSZyeGcDO1oYbOv+N8J98uvHW5wBPxDeeVLOKNqBjiTY9
 pCGmfrAIesk6kLVQxW2NeSBHLkfDL5NBSjVWLSjVpMhyDJ1zbt3xycDw0EHKaNrNjsHxZm0asdO
 kJgdWoIVRxPqYwY1zOEJpTrRMqDCjkGV17YHvVEBoFjG7uFHjCn8HCoVbjcLSDT91WCIsjpQOin
 WERJJtUiOISYNRkuhQPOYSxvVQvlcbPlGUqjHIKkwranZ/A/Jma3IBdHAIn+3kFoWKhYHcbx3M7
 dDxIRtf7lFyjqve2kkaHJn7iNBsoQSu6VG2awJW+fLnAVTKgPbPB/ox3FZOz2A+sWuHt42Mq+Uy /rOdRqhXaQhTBCw==
X-Developer-Key: i=pasha.tatashin@soleen.com; a=openpgp; fpr=CAAAB722DD22A081F0D49F35633A6A993D43B569
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 13DCA1C0003
X-Stat-Signature: jok4b4wkr1pyh3jpik157ggmjntr4zyr
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1773843418-957637
X-HE-Meta: U2FsdGVkX19qENGEyCK/5xNOs7pNVrNJB8OzO6/Vd8sKcmu2TbX+hlmfx2HsSA5uCaiqa8uIqF3Q0gtqYnHuEpVTVd3bTYXxbzWofqL+Q4ntl6BZ9r80twm4P/x9ulK6uR5d82nBBBDYr5yVm3KZb1GQbESFUkEAnLhigXodTFrTpjOPkSYyl3C0mZW37KY6CRCQCm2tIpdmNANwFg4OlvAH6JJvHh825VQwbjHiqnPPh7xYidmp6/OECEaLgOkrovKupuOAtKAPvf7mOmIfT0JgA+70OJhvM0iPUznI1mwjr9wIrnpZWNSrQ/janvZMUNbTT9jvSuCMeZpQf0JK0vB9RgOAbnT5SvOrI6ZGCRDADyC0CMTORkWBSQNNnbrL4xSowfiLfo4hH3/Xd5zJ5d7yNeuMX5pPrbKh5FXyN9ylUhse8GID65DtBL2TE5UVgD8x/0wdzX87D5EcYo3MQ3lP6cz3wRny64UyU0b9+BFIpqaJGf+FxsZQHrw/0r/LMEf2OS+CufSksNZmCpfIpE0WbAGnXndt6bBvbrpg/8d70QrntjK3t38/XKGzR1lVJ9j0WJnQpO4UbUW6KcdZ7teiprU3r8vWYYgQcvKh3xdftppq7TtNMjnAuBDHxrX5DQ6oIHBwYbqEs7sD3L8tV8weBhAxQk+LktnTnG+jhN/3QAuE9j+ROniCIK0K8gqNol6+1vuHuOVaGYn2DS5JDlc9StTcXEzYmKtXr3w4OsMS26CpRShv3Jpz05oA1YjzTZoONiUJ86Pw9QQemIltzr6TH+vecBxBFCyVSLUoFcE0RTKMQH3rtETKZIZgt+Eb1uN7RJfpeTh6OHP0mrTafmEEJ0bqnPMFhr5+iEjQMggMyGb6Tis9tcLxTIKadrMHY4wbptg0QZ4r1G8/tlv4HH/pg9jYFBMs2yssVxDbOOcgphFYTVZm6RkeVG0xuVYFdnkqCPANLlloH39Baot
 89FtSQLy
 gRTEfUpD4G+MFlk24ea7Fk6wVLMmp01K/SfRuSvw5vHNYW86zaGPrTmRBhER2yqrIeCjnJGprPPoUKOK9rvpsmKQsBdJHQl65LSX3Xx5Kp5DgkVZ8mzLFCBXmKGykRiu3F08mDEmBLmrYVqMZ63ErZmk4P0MCIglS+HDFSCm9y3bsLNj1kFVc74uPORxU76nZwVZVZkHkIymndXWl+e8TvwLSnO2FVckCpCHyPx8BJhJnwljoTtvfcc3lUSnkQl1kb57rp8MdV5UMPNu2joF4SLBXwy4ea7C9Rp2e2VbvCTHEJPYo4n4qS6EWKjpfBZe9z21t9gRJnxXNPaSo/EpaQxZzXxx84Y1Mw7uPRkIC4Ld7ICk=
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
 include/linux/liveupdate.h   |  3 +++
 kernel/liveupdate/luo_file.c |  1 +
 kernel/liveupdate/luo_flb.c  | 16 ++++++++++++++++
 3 files changed, 20 insertions(+)

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
diff --git a/kernel/liveupdate/luo_file.c b/kernel/liveupdate/luo_file.c
index 6a0ae29c6a24..96fdd5790dcc 100644
--- a/kernel/liveupdate/luo_file.c
+++ b/kernel/liveupdate/luo_file.c
@@ -873,6 +873,7 @@ int liveupdate_register_file_handler(struct liveupdate_file_handler *fh)
 		}
 
 		INIT_LIST_HEAD(&ACCESS_PRIVATE(fh, flb_list));
+		init_rwsem(&ACCESS_PRIVATE(fh, flb_lock));
 		INIT_LIST_HEAD(&ACCESS_PRIVATE(fh, list));
 		list_add_tail(&ACCESS_PRIVATE(fh, list), &luo_file_handler_list);
 	}
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


