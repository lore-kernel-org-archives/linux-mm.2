Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0868AC53209
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 23:05:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E34EA6B007B; Mon, 27 Jul 2026 19:05:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DE5336B0088; Mon, 27 Jul 2026 19:05:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD46B6B0093; Mon, 27 Jul 2026 19:05:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8B07E6B007B
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 19:05:51 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 05E5480232
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 23:05:51 +0000 (UTC)
X-FDA: 85036090902.19.B09A316
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com [209.85.210.197])
	by imf26.hostedemail.com (Postfix) with ESMTP id 549C0140007
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 23:05:49 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=FKITNiTk;
	spf=pass (imf26.hostedemail.com: domain of 3S-RnagcKCA435o70ozu22uzs.q20zw18B-00y9oqy.25u@flex--pratmal.bounces.google.com designates 209.85.210.197 as permitted sender) smtp.mailfrom=3S-RnagcKCA435o70ozu22uzs.q20zw18B-00y9oqy.25u@flex--pratmal.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785193549;
	b=qVnlel+BDJWsFcLZn3NlsL2vSGstlPpWrkvVAwOk7K+a/PK8RkbqWG3571zfwioIbZZYQe
	/0biMlk/OJTQzYUov4lkIDOz3Lb7+NLac0WgAsk7PuYuuc9yIA2HGl9dA781dlY2hXH1b/
	nxyvi/c56eZ+2NUEwcAIHw7jSXVOhMA=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=FKITNiTk;
	spf=pass (imf26.hostedemail.com: domain of 3S-RnagcKCA435o70ozu22uzs.q20zw18B-00y9oqy.25u@flex--pratmal.bounces.google.com designates 209.85.210.197 as permitted sender) smtp.mailfrom=3S-RnagcKCA435o70ozu22uzs.q20zw18B-00y9oqy.25u@flex--pratmal.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785193549;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=lCgFliqJWz+M9tZQ5Il6O3npkwRo/L4rfW7GdWN7+m0=;
	b=dgzZ/zxtUyAZ109Lyxj4BZohxTvr27PtIUXbxGwK4v/bIRRbhkKXMD3TnZlztzaIazGmWm
	sJLqU3PV4MJBqW49sIb7lYns/DCcTvHLKS4DpUznJ681QoKBojTUv0tGIgcJVh1YNJekww
	NrvwwEf2d0YEtrpzi/VTfM1TqE6rU+A=
Received: by mail-pf1-f197.google.com with SMTP id d2e1a72fcca58-84885a4fcabso3727430b3a.3
        for <linux-mm@kvack.org>; Mon, 27 Jul 2026 16:05:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785193548; x=1785798348; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=lCgFliqJWz+M9tZQ5Il6O3npkwRo/L4rfW7GdWN7+m0=;
        b=FKITNiTk6RReG/N9tjzwb0R9hAQox/cJ/ZWRm687Dny3sewsSKvShiKatgDP+heq37
         R4kt0XoKNvmclKZAN81ie8AC/bt8dYdZgn3t0jOQ8oUFRF8cnJpGmJD7YNgsNIJmgIg9
         EZ5H2tqb64Z3uZoIKYBdGSZBsqmQrKvW/XvLOK+Yffo2AblWVO5rGM45EoyqpUH4nOdh
         oNS7lACjfMOiBbrE+vmefWHqha3zrk6/Y11YWbcp4jORF0S3EyUvPZm7UpSptj+EF9LP
         LCKOD9jw6bf0N9ThAFbDTEyPA/vr6Nx+U8TtuvbwN01OaXac63LQWO2jDoQh/TmhdWZn
         97sQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785193548; x=1785798348;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=lCgFliqJWz+M9tZQ5Il6O3npkwRo/L4rfW7GdWN7+m0=;
        b=HkAkfawBElLNSIeqF81P38fE59GKrcKe2OASwbfXOJyZE/SUAmsTk3pk59haAVkJWu
         UPnkNbjYRFRO9iWlVRA3GvKNt7hv9iHsiWEw7cmn1qP91aYb5718OfAlb8EAk1bQ4dEL
         MLjMHhZg1s7KGD5mDNNOaqloj7I8yKm3Ttwd65/GXuod0ZW0N8lw8h6LiBBv8A2H7cev
         ccYvp6pnkvut90kuV7o5KvXA6wlX20QTf3XIvdH4eeQIqEVg1jvbM8tBWcfLQu9TDsjx
         3efYBg8wQKPsvoEav5HCZshHZAqtyYC02IK84DZO8tn54hE7qt0ha4OoCBLnSAp1uNDy
         9Cmg==
X-Forwarded-Encrypted: i=1; AHgh+RpWHmNS7lXN/InRAE1BI88vuYJvZ3BrmcnfuBgBHGnCAQXInBBacqkgJfwLa68ONP1HpzR7QAlkJg==@kvack.org
X-Gm-Message-State: AOJu0YwReIwXhnck29WV8MfYaPCQbOTwYPwFAs+NZwEH9n+5MyZcrLJd
	igb0fW1U8PnzgX696h9nMoGTxoECEwBgrYRzMp+a/n382rUUCDAncDVp8wkFsinpg9sqEMWXMEB
	46Z4dCmMR5g==
X-Received: from dykm9.prod.google.com ([2002:a05:7300:1889:b0:311:4890:b1b9])
 (user=pratmal job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:b92:b0:3c3:6c90:65b3
 with SMTP id adf61e73a8af0-3c67dff9882mr9745829637.65.1785193547902; Mon, 27
 Jul 2026 16:05:47 -0700 (PDT)
Date: Mon, 27 Jul 2026 23:05:45 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.55.0.229.g6434b31f56-goog
Message-ID: <20260727230545.262579-1-pratmal@google.com>
Subject: [PATCH v3] mm/page_reporting: Add page_reporting_delay_ms module parameter
From: pratmal@google.com
To: akpm@linux-foundation.org, vbabka@kernel.org, david@kernel.org, 
	sj@kernel.org, corbet@lwn.net
Cc: skhan@linuxfoundation.org, anshuman.khandual@arm.com, gthelen@google.com, 
	surenb@google.com, mhocko@suse.com, jackmanb@google.com, hannes@cmpxchg.org, 
	ziy@nvidia.com, ljs@kernel.org, liam@infradead.org, rppt@kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	Pratyush Mallick <pratmal@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 549C0140007
X-Stat-Signature: ysz49j91r9dawb6gene9gezmfsjizjgz
X-Rspam-User: 
X-HE-Tag: 1785193549-808548
X-HE-Meta: U2FsdGVkX19NhSWdKRMQ/QKQV9ouN7jKna1c8RDjMA+4GATTJdmB+r2kQQlmpZm3MT4lXFDcxafksUm76HOuhNiHqWjw1nwmhhmZEcRZQOS3udhnlLq493FJYrcD2cIDoxOs9ifvq1pjQR+/TIRJtQiobx/DqLC6e+y52ZWhzC4w8IRG8DrmgRZy6ozx7PU8WECQZ3z1fQKnTZbOOLv14TmyeVsAWhkwqtEwt8fVPDnpdXD6v/vilYFTySSWku4ZaUQ6dAVEHhg88XLQPapbZbo1XGqKrBP6SVpImhHnvJ4IYsEPmxYmNQgsUZJ34bqmOcX87CGgvCkcD/QfnpU2mK55EwRNipc8he8BETjIPCB665VPVkpYkzL45kCqn566M/t2v9DBIm8uY28Tqa8CJlvOVfLHZS2xAe8VwitwakZyQ4+HWPJWCakHcgDqdqCQJzyrA8FCAlARRApEo5TuvRZ3OQvWHY8QkcmMVTAroUDlWEFYcmjLEJXc/JZv4Q0caZ2MU4du/GTd4npIhouyXrQ/Rc2O5hAjS6MS4HKrBJ2bHZhe0/F74F+H5fN2SCamw9DuM+ZM6YAj2dmBjyPCaXoNs5Bxvq5csa8JvwIC1e/jKmDVLNUKuVifv2PUOSdukyUVxC8ka78VMkaARrkpYolSlkeMHw7xDFU+HBqzMx3+lnEaCW44/iDzNrzN1QZECn26UjviYAPomfb4RKnDCwz0mySsDaNQYeh/htIgmjuEKr7KCJYLsIgyXwC3L8KN0lzZpf97n72vNmy0G4BTuW29dx1IebwC+pWMBcnKs0g4uEYym4IzRB8jrNoL4ZvTxmouEG/ImCIUcEfIi6Z6olrZeT/Pz+oDBwqguokdEHzSGK2NKkPeLxd0e1HlKf1TQAnejCs/TYuWD1kY/u1sUiCZ+Cjk+hncealjiG1Yw85GBoz9Czrr3WMr+vCz1HR5cLWR+AtpPSLTKqWFz7Y
 41FfJuR6
 h1Ki0X2n6KZpTVZPar8ZZPzrOwrWM5iadFH30oEezlRCwa7B+nRzbf4Keksb/uoxDEDEsyTghKOCuVm5GEaZZA7rmYKO4SMWjtltUktdGnPenAcbtKb0vuToV5ToPywGMRoW1i8231ph6Q+RcuqFx5X9ikaBPIVgPtUKimFT50QprQ/uebJy6z5lQkSFHpgIVcMUkq/HbmBRyL4CgzpIMI2tPqnN0luSVIO8ThaIvvtrLAneyqQQokKwkstSktyXzf66clYADuaAifDPBGzV8YsQqAxZ1QHU15RVqcYP7G+VKEjYiUz7RDJ1vDx95VXyRzfOxe7ThjT9N9axQpq+HUsiDwe5wNC5EywiQJzgzXNpIGvtxidganl1NuJT669JGWJor8EhBiSbuAKm/Xi/nqlBzFzori1ah2nkIUnRSMgcn2wLAyoBfNravt/vr2Fsvq3sujqzFU3OZmhuKslHmGEi/NZvbmgNNzsyv42/uSuHKGDZrQdYTnDZOX0Ri/9ikwwrNMZyBhmYs9PKdHEwDUk+R8KCaytAWqv3FGQiObIWjIh0GbN0cWkITwuuEVfY4YzRPJpE5os6DyUj30vJ+2LWXCu+R+uhrKNYWixPixXuvRkOfl3LV18ZhiYZyuc88G3sMVVWfQaFQEXoiXBTr9mg+Dg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Pratyush Mallick <pratmal@google.com>

Currently, the free page reporting uses a hardcoded delay of
(2 HZ) between reporting intervals. While this is a reasonable
default, it lacks the flexibility to adapt to varying guest workloads.

A low delay allows aggressive memory reclamation, returning unused
pages to the host as quickly as possible. However, during spiky
allocation/free churn, this immediate reporting can lead to a severe
performance penalty (nested page faults) as the guest re-allocates memory
that the host has just unmapped. In these scenarios, there is benefit
from increasing the delay to batch free pages over a longer window,
absorbing the churn without hypercall and re-fault overhead.

This patch exposes the delay as a module parameter:
/sys/module/page_reporting/parameters/page_reporting_delay_ms, measured
in milliseconds and defaults to 2000ms.

Signed-off-by: Pratyush Mallick <pratmal@google.com>
---
v3:
 - Converted page_reporting_delay_ms from a sysctl to a module parameter.
 - Dropped the max value cap (PAGE_REPORTING_DELAY_MS_MAX).
 - Documented page_reporting_delay_ms in kernel-parameters.txt.
 - Updated code comments in mm/page_reporting.c.
 - v2: https://lore.kernel.org/linux-mm/3da27fde-25dc-4cb8-8e05-74cd26fc2f7c@kernel.org/T/#t

v2:
 - Documented page_reporting_delay_ms in Documentation/admin-guide/sysctl/vm.rst.
 - v1: https://lore.kernel.org/linux-mm/20260722192935.1646848-1-pratmal@google.com/T/#u

v1: Fixed feedback from RFC.
 - Added lower and upper cap to sysctl value.
 - Reverted the reordering on page_reporting_delay_ms.
 - Dropped the mod_delayed_work() change.
 - RFC: https://lore.kernel.org/linux-mm/20260714171456.2350037-1-pratmal@google.com/T/#u
 .../admin-guide/kernel-parameters.txt         |  6 ++++++
 mm/page_reporting.c                           | 21 ++++++++++++-------
 2 files changed, 19 insertions(+), 8 deletions(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index b5493a7f8f22..364c2dce8e70 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -4810,6 +4810,12 @@ Kernel parameters
 			Adjust the minimal page reporting order. The page
 			reporting is disabled when it exceeds MAX_PAGE_ORDER.
 
+	page_reporting.page_reporting_delay_ms=
+			[KNL] Free page reporting delay in milliseconds
+			Format: <unsigned integer>
+			Adjust the delay in milliseconds between free page
+			reporting intervals. Default is 2000 (2 seconds).
+
 	panic=		[KNL] Kernel behaviour on panic: delay <timeout>
 			timeout > 0: seconds before rebooting
 			timeout = 0: wait forever
diff --git a/mm/page_reporting.c b/mm/page_reporting.c
index 942e84b6908a..a67311468204 100644
--- a/mm/page_reporting.c
+++ b/mm/page_reporting.c
@@ -47,7 +47,11 @@ MODULE_PARM_DESC(page_reporting_order, "Set page reporting order");
  */
 EXPORT_SYMBOL_GPL(page_reporting_order);
 
-#define PAGE_REPORTING_DELAY	(2 * HZ)
+static unsigned int page_reporting_delay_ms = 2 * MSEC_PER_SEC;
+module_param(page_reporting_delay_ms, uint, 0644);
+MODULE_PARM_DESC(page_reporting_delay_ms,
+		 "Set page reporting delay in milliseconds");
+
 static struct page_reporting_dev_info __rcu *pr_dev_info __read_mostly;
 
 enum {
@@ -76,11 +80,11 @@ __page_reporting_request(struct page_reporting_dev_info *prdev)
 		return;
 
 	/*
-	 * Delay the start of work to allow a sizable queue to build. For
-	 * now we are limiting this to running no more than once every
-	 * couple of seconds.
+	 * Delay the start of work to allow a sizable queue to build.
+	 * We limit this based on page_reporting_delay_ms.
 	 */
-	schedule_delayed_work(&prdev->work, PAGE_REPORTING_DELAY);
+	schedule_delayed_work(&prdev->work,
+			      msecs_to_jiffies(page_reporting_delay_ms));
 }
 
 /* notify prdev of free page reporting request */
@@ -335,12 +339,13 @@ static void page_reporting_process(struct work_struct *work)
 err_out:
 	/*
 	 * If the state has reverted back to requested then there may be
-	 * additional pages to be processed. We will defer for 2s to allow
-	 * more pages to accumulate.
+	 * additional pages to be processed. We will defer by
+	 * page_reporting_delay_ms to allow more pages to accumulate.
 	 */
 	state = atomic_cmpxchg(&prdev->state, state, PAGE_REPORTING_IDLE);
 	if (state == PAGE_REPORTING_REQUESTED)
-		schedule_delayed_work(&prdev->work, PAGE_REPORTING_DELAY);
+		schedule_delayed_work(&prdev->work,
+				      msecs_to_jiffies(page_reporting_delay_ms));
 }
 
 static DEFINE_MUTEX(page_reporting_mutex);
-- 
2.55.0.229.g6434b31f56-goog


