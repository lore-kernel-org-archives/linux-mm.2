Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 799A8C982FA
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 18:30:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 371866B00A2; Tue, 22 Sep 2026 14:29:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 349636B00A4; Tue, 22 Sep 2026 14:29:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 25E116B00A5; Tue, 22 Sep 2026 14:29:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EC88B6B00A2
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 14:29:45 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6C307A655D
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 18:29:45 +0000 (UTC)
X-FDA: 85242236730.04.7F568C6
Received: from mail-qk2-f13.google.com (mail-qk2-f13.google.com [74.125.230.205])
	by imf19.hostedemail.com (Postfix) with ESMTP id AA3A81A0009
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 18:29:43 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=tEbZvuKd;
	dmarc=none;
	spf=pass (imf19.hostedemail.com: domain of gourry@gourry.net designates 74.125.230.205 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790101783;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qVt6tYIl/AHtUN/63hgHvGCs0fPV42UvfQxmNYHhn/o=;
	b=fIVC4LvjcF/IX0hVhXA6MdmpPy8Hxg8qj04wCWki6KDKbaAt6v9qiR3u9aZvIoMi7EbiR7
	1Ra0KGiDegqp2yb8u9uJ8iqbH3xts2k9I/STnxkhsXG2TCghDfUtNvQhZMsS3vf2hglq87
	UO370YNmHWh/Zgkr1RwsT5Z/EPdIMms=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=tEbZvuKd;
	dmarc=none;
	spf=pass (imf19.hostedemail.com: domain of gourry@gourry.net designates 74.125.230.205 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790101783;
	b=E3qZogNDhY9xjF+koQ6aAgSoYGZQyW4wOBKmBds68ZSx0+ZOioPe6qd2DeV35kaDuwG6qS
	XY03wyt15h5it0WHyZJ4MeewFh6OsMs5ekqLu2epmyAjqx0b1FJZ9D+5KRegB+taHoDGaf
	gMh4gQ26XVMPknxz/3ACQx5KwP6NUF4=
Received: by mail-qk2-f13.google.com with SMTP id af79cd13be357-93910cadeb0so14588785a.3
        for <linux-mm@kvack.org>; Tue, 22 Sep 2026 11:29:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1790101783; x=1790706583; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=qVt6tYIl/AHtUN/63hgHvGCs0fPV42UvfQxmNYHhn/o=;
        b=tEbZvuKdEvWOF5lddVQa3JJxcSmJ61fyKfcZz2k1vmX1ABvy+lV6Cz1LYmfOmwKRiJ
         rwuReAy1K3gvydho2LScoYYWg2cYOH1XU5lFlmDY7ZS8wfCZU/jKAYWy+EI16H37hIMp
         haWTtmAlvbMoifJZ2BJjNastLz81ge/TW/Hz5nzg0/mxGm6L822A60zuSXrLjEKKSmdm
         1UAuZqVhSBPp3MAgYM1jeRimoBl3nFsu2akemFcEy5q8MXljam74xP0qrr4gEYgpzQze
         5uPdwiwJgOgPEp4CxEhNj3673pzhuGenh7oDfIoEOH3uZap9Fmet1oGM19lk6sWLlCnR
         e3ZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790101783; x=1790706583;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=qVt6tYIl/AHtUN/63hgHvGCs0fPV42UvfQxmNYHhn/o=;
        b=uVu7yNnDciKrlKBgJ7BX4CyYXBd9gT0ZcBVXThNsRPyfcMiZxQGLulIUVHQUIymdDk
         2Fz4XC9+gkhdwaGnkR7kluRIDJPnBMzWevONxoZueybEu2SAyeT5XU8FWjwnr8Raz2/d
         aapLDACAmQoZIVbgEGcOL2RpH8AfdQsVG+TqEeF1GHL/VzW9BcFxQwS8pA/6mXv+GVJn
         sYdP50//GKe37Y+JRkUQ0YMJ1iba0OWJkLde24odgiN+0mw9vPFDM+elSgPpI3PqPb2T
         GnQ2IQ4Y0/F5Opzjs6NC1rpr0ajKFCDx8iC5XYCDfT1q0B3+mkzwx+loFLeDnqcD4stZ
         00sQ==
X-Gm-Message-State: AFuF++l+mWo3ctU9RUmyzfeeHr7sRZiXRo1fd4z/cDXejStAlxz0yY7E
	Vj+ML2GMH9ceIikl/+MZ8in0g9rIWh2C26cbsg936QLZW7TSXJSF3H98e0aVkJH1QORFZscJo1q
	lL3eVPVo=
X-Gm-Gg: AYBFou2SusWopyni83lnuNBITo/3ZcHpLScET9eoGLA/y8VJAIEvOVCbwKAI3wG3LF2
	HDkws9hRjb6x9FWtj+MdqeQSmcpPyk3NVILfVuYZxttys/HStfwt94i74gS54nrDXhVvbuIJQf5
	GDc0JzKBhRzULS0VVrxVzTFmyAaoeyVSlngRLA3kQfsmToPnUeoqvMtHdcJcAbDXKPwTyC5/d9b
	UU2OceDKA9RtpOePyNXm7g3YrM9xHVbXKYrdtweYO3gUKg+3CO+tlEYO7pyLVs4Bkg5Qyp6MzKM
	Y7yVnyremjryZtEzgqtMI+RiPPNmVMpJXdEvc3c0KoyS9Fwf3YiVKTLz0MKsyQ0XzH1HEdjokAe
	atxnUtdPkQKo7Ttc4u2M7NWNryneLsYd3nvWk5OPjio1L5lU0LXcKr4ENL2pmM3wpejb87FRzo9
	3Q3ki2LDdUvZvFuFSjwXhyBGju4h3GX0DoUTlJU85RUhj2mgIPmq4beXa+mmqJVt18MGdGnwHsm
	ZWmR/98ErOcRmu2rnvTLx12qynAs/VhlZ3hPm4xDav+gGto70Dm/GSSS2T2aA==
X-Received: by 2002:a05:620a:19a3:b0:930:9585:e08e with SMTP id af79cd13be357-93c25080ba2mr41386185a.10.1790101782763;
        Tue, 22 Sep 2026 11:29:42 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93c24889ac9sm37130085a.27.2026.09.22.11.29.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Sep 2026 11:29:42 -0700 (PDT)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	mingo@redhat.com,
	peterz@infradead.org,
	juri.lelli@redhat.com,
	vincent.guittot@linaro.org,
	dietmar.eggemann@arm.com,
	rostedt@goodmis.org,
	bsegall@google.com,
	mgorman@suse.de,
	vschneid@redhat.com,
	kprateek.nayak@amd.com,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	nico.pache@linux.dev,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	usama.arif@linux.dev,
	kas@kernel.org,
	matthew.brost@intel.com,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	byungchul@sk.com,
	gourry@gourry.net,
	ying.huang@linux.alibaba.com,
	apopple@nvidia.com,
	jannh@google.com,
	pfalcato@suse.de,
	hannes@cmpxchg.org,
	shy828301@gmail.com,
	raghavendra.kt@amd.com
Subject: [PATCH v3 6/7] mm: use BIT() for change_protection() flags
Date: Tue, 22 Sep 2026 14:29:27 -0400
Message-ID: <20260922182928.2199090-7-gourry@gourry.net>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260922182928.2199090-1-gourry@gourry.net>
References: <20260922182928.2199090-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: qsgpc68joqa1xxxfhyb7zhbgmdeu3qjp
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: AA3A81A0009
X-HE-Tag: 1790101783-630854
X-HE-Meta: U2FsdGVkX1/MtPVxU0RBSMTw9dUJg6DKJVBU76HyvIqNE6NXOFEJL7BKKsM67jFiPEpm//bSd7ns8wvZyMnIfzMOBXGMlYJNuvvXn6BHGhQZLfLITz2b4CnrUC5Gyh2qJRXgj7EqrKCAWx4Z/YaJx8MX9V3LZgUl/OVn8Bxd07liMshVfikxwVXiskKbarw8CvpGeMJsSrlT26xed5lCLK/xJBnPuusO/HUbObMiEoVGd5MpFhkw+OJB43g4DO2kV6rB4+ZC0lnDwKkRb0ggN9z/2ALWzTvwhu9RvTWqt2RiLmHFuBi6gxgCodl00Ycvi3Ge+7d2/W4x7KBnAJFhPY0ly+3jcsPs9YoCLv8yPrihl9TiWnLHvIt6JD+fhw6Kb0Y6keufz1VKwNsjHS9voKQOcIesVCOiy0oeK8G4l9Ct6napawftTNb1U8ZZ6rm/+QvUHe7b6jE6Jg5hA9LZoONHxCi1wGy17OKMHIVj+7bNOu3290kH0OH3luaHGlwXazAzCf26jkLLcrQHCQB02OblyswiyS7tj57NrCnFK5giE58fnyi4QEVevvUfiYZZcQyDRFd1auObLmio2Y371KNfbBd6Yzqk507iNlJXVLT6KDabnMqc8QQ9hEZXDDxPTZiJ8e9s2pPVCL9E+Elh+L2aK6k6az9npB79UWX4q6qbarf820IX0UuqJbr0UzSDdvxpwfMqQeKnSYB1TCyovgLWOrdAyGE9KxJ5dVBX9ZYEY63QaFqkTmHfQQNH9ZKnta/vCIw3JQ0xytYXu0mlhNgiVQ75rsotFkcHIJIHHAvjtriRVVIQJA5fX04Y+xTBJVcSiNnDHpvgRI8kJvqAr7VZaiJXo6Gd+VOlEQI+M6KFxs4aBZ8IsAbQqt4yTlP1SmqrIshil0OEgoHuqvEPB+aVdIBrK8zI0VZUI9gE/SvLYx4Ga7PplrOA6cAj3o96DEilLlEwKcy4aqk7iXx
 s8mT6yMA
 m4owhkHoV+eS8B7KPZ8Pmwt5RL1mKcHoHoKqDVPpKvvs8pKfwEeb9EyhIzfKaxh0aSiz0PP4mTYoHIgLDejUL8FGzS+4mCn37oaBj7MIjsg2XE4xG+tIX6mwVcwty1wbamzzAYwtWI6mnWTW2kGFmSK0waZtWWkEipLjPQhCcZBoneLCf9QeqFdfWB8sWbCHMptxZzxb3OsvDhew2vjc1Az9feWvAmKUwdDhJfSJeIvNS9j73Tw8D3nEH5wni9QQe03cbS9rT7F7eQKwnbyq0/LLvY0TbJUUcb3KDl1DizBrl6UumlfnviUimmq9dV7C1XVro2fhNCAW0ZE8lQZ8g3gkJ69H88jb0Y8phU5r8h7oJL5Py1THXJ7lFGIYpYnAVVmBKifKPenuePs9OwA95whMCXk9+J/PW9U76EQdjh7WoUSWX13UaMFQxbfUdrdRGqY5p
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Gregory Price (Meta)" <gourry@gourry.net>

The MM_CP_* flags are individual bits expressed as open-coded shifts.
Use BIT() consistently for the complete block.

No functional change intended.

Suggested-by: David Hildenbrand <david@kernel.org>
Link: https://lore.kernel.org/r/9b5e1573-6fd8-48a5-a274-a6e7ff83d2fe@kernel.org
Assisted-by: LLM
Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
---
 include/linux/mm.h | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 225ba26c9d503..c2ffba42019c0 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -3596,21 +3596,21 @@ int get_cmdline(struct task_struct *task, char *buffer, int buflen);
  * because something (e.g., COW, uffd-wp) blocks that from happening for all
  * PTEs automatically in a writable mapping.
  */
-#define  MM_CP_TRY_CHANGE_WRITABLE	   (1UL << 0)
+#define  MM_CP_TRY_CHANGE_WRITABLE	   BIT(0)
 /* Whether this protection change is for NUMA hints */
-#define  MM_CP_PROT_NUMA                   (1UL << 1)
+#define  MM_CP_PROT_NUMA                   BIT(1)
 /* Whether this change is for write protecting */
-#define  MM_CP_UFFD_WP                     (1UL << 2) /* do wp */
-#define  MM_CP_UFFD_WP_RESOLVE             (1UL << 3) /* Resolve wp */
+#define  MM_CP_UFFD_WP                     BIT(2) /* do wp */
+#define  MM_CP_UFFD_WP_RESOLVE             BIT(3) /* Resolve wp */
 #define  MM_CP_UFFD_WP_ALL                 (MM_CP_UFFD_WP | \
 					    MM_CP_UFFD_WP_RESOLVE)
 /* Whether this change is for uffd RWP */
-#define  MM_CP_UFFD_RWP                    (1UL << 4) /* do rwp */
-#define  MM_CP_UFFD_RWP_RESOLVE            (1UL << 5) /* resolve rwp */
+#define  MM_CP_UFFD_RWP                    BIT(4) /* do rwp */
+#define  MM_CP_UFFD_RWP_RESOLVE            BIT(5) /* resolve rwp */
 #define  MM_CP_UFFD_RWP_ALL                (MM_CP_UFFD_RWP | \
 					    MM_CP_UFFD_RWP_RESOLVE)
 /* Whether a MM_CP_PROT_NUMA change is for promotion only */
-#define  MM_CP_PROT_NUMA_PROMO_ONLY        (1UL << 6)
+#define  MM_CP_PROT_NUMA_PROMO_ONLY        BIT(6)
 
 bool can_change_pte_writable(struct vm_area_struct *vma, unsigned long addr,
 			     pte_t pte);
-- 
2.53.0-Meta


