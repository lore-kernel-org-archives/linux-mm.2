Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9DB49C55173
	for <linux-mm@archiver.kernel.org>; Fri, 31 Jul 2026 19:37:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 929056B0088; Fri, 31 Jul 2026 15:37:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8D9626B008A; Fri, 31 Jul 2026 15:37:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A1F76B008C; Fri, 31 Jul 2026 15:37:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3B3616B0088
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 15:37:11 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B03BB1C0075
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 19:37:10 +0000 (UTC)
X-FDA: 85050080220.12.8F3326D
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com [209.85.215.197])
	by imf13.hostedemail.com (Postfix) with ESMTP id 2067820010
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 19:37:09 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Xj8cyCm6;
	spf=pass (imf13.hostedemail.com: domain of 3Y_lsagcKCGQRTCVOCNIQQING.EQONKPWZ-OOMXCEM.QTI@flex--pratmal.bounces.google.com designates 209.85.215.197 as permitted sender) smtp.mailfrom=3Y_lsagcKCGQRTCVOCNIQQING.EQONKPWZ-OOMXCEM.QTI@flex--pratmal.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785526629;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=vECLUKzXFGOEzwlGZwpZ/IhaB1EZugqHi458H7aGCEg=;
	b=EobrZew5yQPzHhgLKnFGjOH1ZwwnKM/ezLfKtRJTalTIZi/LEEXG/dy1pulk1uf0qpM+Ct
	IluwHj07QvjiGl6OMVgLXEt/kBAjg0U8JBGymQK7evFWxCAzrUyPZyXINY/mH0hx24ifoc
	+UxSYovYNnJVkxiOb/aFI65XLplQfBE=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Xj8cyCm6;
	spf=pass (imf13.hostedemail.com: domain of 3Y_lsagcKCGQRTCVOCNIQQING.EQONKPWZ-OOMXCEM.QTI@flex--pratmal.bounces.google.com designates 209.85.215.197 as permitted sender) smtp.mailfrom=3Y_lsagcKCGQRTCVOCNIQQING.EQONKPWZ-OOMXCEM.QTI@flex--pratmal.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785526629;
	b=rABCYJ3lbMGBW/H8YyKx6iOuONS8DZqzEYl3W3Jrbmwd7Uc7csthjpzgkb1hDuq1EChH4h
	uexUNiDgFWYEUV33qxQXhwqdW1CvbDKdVtoD7fQuQHAUAiwuoJN5VkPrVXCagPZXfgRG6z
	jUZrx1hPn0tatbIFkj6dWyemX1drE+I=
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-ca6bd8a190cso1662238a12.0
        for <linux-mm@kvack.org>; Fri, 31 Jul 2026 12:37:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785526628; x=1786131428; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=vECLUKzXFGOEzwlGZwpZ/IhaB1EZugqHi458H7aGCEg=;
        b=Xj8cyCm6oRR98gzA3Jplq7qDZWowz7/KYPgGQ5AfrrK5eWMpervoGDC+ntlT08c11P
         HS8bLNVHtbky5VeqfX2aJ9NXD4d30KgyoxZZ7adYNFtpn2Ka1/06iI0Q0pFQfJ03PAvL
         h3lMw2qGbSdz+50ug6CbO4aQ85/PambGqS1qly8yMBCq9ceTnzTOVITf/XBcfzReoHHi
         033ko+44c/W6yZ3jCg2+46yM+lQUkHgMZGVbNrU1Mns1ZttCyeXjy4Hl5YxkUIX/J8p4
         ezQ/gYM7DzMLNz1tzdsSz3tIsRadxVuxNNqjNdbNet3WwzZ8ymN28NnXdtEhZ88o4qIT
         vPpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785526628; x=1786131428;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=vECLUKzXFGOEzwlGZwpZ/IhaB1EZugqHi458H7aGCEg=;
        b=EeK0IRymkiYfq4pwMGWcMpf8ljkjrZkxxyivE1QSI//b+tIdVF8olhXfma9w+4zb0p
         yrVNM3Mjb/flQTHtA7jyUF9GzV+vVfUyyPSftQAxcI6fuSSOy1g9ronZoVMyjP5L9662
         DrWEANABjFaoMOtJGP24fgnFPy5CnA8ixrdmdJ8W/1+GpX3ZCz7nQ8hw7jx38zvFIcqZ
         53qsejLmqmN8pEGFtLMzblo0XAsH3fJjgpbyioVw+xvwqAVK2P0D16CoKSGqwq20xPyH
         vz5dtk2+Ix20If+Pmatx2cKpbwlUcns0JM78hgibfIJy/g7LDaC8q5RnIfHVJT/xeNXM
         95lg==
X-Forwarded-Encrypted: i=1; AHgh+Rr+QH1/Dx2fktpChbnlI0GUM7muR4x+jOLXNq6ozPU6MqhIVIsEZ+veXDFqfkf07+ENLfWqWNmIdQ==@kvack.org
X-Gm-Message-State: AOJu0YzPKohlROUszbNc5maaGbwA/ND1CaEKQeYVGM35VsVQ/lLr0nDh
	EsQWHbKpL9a7H/IGA696LcEtdBqJUVq1BQnAwxxLDYeIULKbZrckQEzgu5aGxV+D3rMcbEXVO1J
	jqvyY8NagUg==
X-Received: from dybb18.prod.google.com ([2002:a05:693c:6092:b0:311:cbf9:7438])
 (user=pratmal job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:7007:b0:3c6:3c5b:f2e4
 with SMTP id adf61e73a8af0-3c92a8f460fmr957909637.60.1785526627519; Fri, 31
 Jul 2026 12:37:07 -0700 (PDT)
Date: Fri, 31 Jul 2026 19:37:05 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.55.0.508.g3f0d502094-goog
Message-ID: <20260731193705.2902728-1-pratmal@google.com>
Subject: [PATCH v4] mm/page_reporting: Add page_reporting_delay_ms module parameter
From: pratmal@google.com
To: akpm@linux-foundation.org, vbabka@kernel.org, david@kernel.org, 
	sj@kernel.org, corbet@lwn.net, ljs@kernel.org
Cc: skhan@linuxfoundation.org, anshuman.khandual@arm.com, gthelen@google.com, 
	surenb@google.com, mhocko@suse.com, jackmanb@google.com, hannes@cmpxchg.org, 
	ziy@nvidia.com, liam@infradead.org, rppt@kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	Pratyush Mallick <pratmal@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 2067820010
X-Stat-Signature: 3zg5n3fwn4e8o9rnb6e53yz6mifginym
X-HE-Tag: 1785526629-732296
X-HE-Meta: U2FsdGVkX18icH9XzsF3aA1iCOaR4r1Jfu0byrocc4oNYyEoR4fjbTygdUDoRy9MP4yMWuDlc2JXp32weLj2iOscqsgpyR0NkUGlRWu58LbKjYXf5eYnltQtGChsGNU8cLGVixZQtMhfBdRo25kj69HhiINGMibaaptSbGI33tvGEKzjflUw8d1nU0bVNG508HIjJTNYJRXvis9nXbjEKnfftaXq2+lY3/a4drkEvkLq3nLvuB31NzNLoij1cRNwsCvD2kRb4xwtag/uTUXAqMPseaKtWfD4l86zfrIJT6xNpKZuqIhFyW2RG1MeKbOFJsXQgNKaViVw41RGsTig2j4aKl1Lu88eqkKMvRotfqLEDgkKfAM+jS0tPNV1nK6covFtelxGafDO+kN9kpt01RyVXQWCSWscnzMe6F3xczCi+z/U8xXwvUT5avnNaafrh8pR6XdatRKHkgXs+gNSrq1lzPB74Hc+fYXak3L3ZrWcHAMFQQ4VnfmQ9OfmsqvWJK9t1TbCufKQ0G9i9bgdhPPvCugR9wEa1lRf+aNEOmVzrUb5e5X0ZJfvjYigrJ+5rq9BL9orQEMrEeHlk+xyCNVxIVe9x3q9j82B8GUOBcGWY+FCZM64txtK5uoMbwL/aRyxBveZcUltLvI34md1ip6Q8J55Anbq3a4cSIARFS8X5c8vQM04hUaliq5H+V8Qu4vdFG1x1QknRq1g5tBwjsXJmhor+uBmy7hmkhbhmn/4Yxnz0ZAfkbu3Af/WSR42wLsGGGJviOjWgsb9De5aILvfOXkWeUD27lirBT0B7wGi8Q6Q3/Q5hzHFBK2S1h+zX8TjP0pIZFE8jUZa8cEiv/Rftk1Cpez06f55MECIl2KcKzoX0EYrU5vocGHm0LyEdaozVdcuJiCAz5IjS93EeE8e5Rvfiil6tCjC9ezWsDVybMVHiNrBBqqMOjH/0eRSyDYJdRGPpfV+uRD50py
 kpfoW2/p
 GeklRMYhp2zKh+eflZ4EHO6n+J1KMVZHhxE3JV7nCXmcMAqQoT6JuNrMbse3iFkImfbEGtU6WtOef8N92B5bH1IRFOFCiN6bKETtDmFNyBCx2lA3bXKiWCg4MAG1qIAbQ2RjZdq58viv3h7nMfSljYbs+qDaw8oXigcV1bq+F99b4Cs+qZj3S4hjQn07GRLTvndu06lbAFyadQxd/oUpRB8fOvls60bYw2y5ODaCCKuUsSuliLTf5JV0eQtX4RRDIYzy+EhK47PMCsHC2Fuuamig7YqsAz88mXWyr8vXOi1h8oxHZR3zCga0MjYFCqm1jzJT/B7h5irmH+LaEqPS8eqc4eMc3k0Pr8gi/PODfLJZsxHi5ZELdtqjd27UgAa7UYM9LohPZGYr+oGI1od/+z6JejuBvEH8ZYtWxKB4SBOYXwbhCXIRXKewk91pR3XdaM2CPctlo7nm3sDAUR+23mfYq0r+nFPwJ/EFZ1NKQdceupl55V65BbX9chOBV4/zOkKCX+A3n5X76Ge+pwFICxK0sMOpBY4wq9upd2iM7td7ym0M2U1fPkMVMqOiv/fXfNIhB/MUJfGcGP5Ni9bJ09bKvhV+HMaXSI/tbHlU5en066S/pcsZvHOCkL+3JjCHRk09P6Sio0UYZHKSuy50If5y2jg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Pratyush Mallick <pratmal@google.com>

Free page reporting currently hardcodes a 2-second interval between
reports. This rigid delay cannot accommodate diverse guest workloads.

This patch introduces a module parameter, page_reporting_delay_ms
(default: 2000), allowing users to tune the reporting rate:
 - Lower values enable aggressive memory reclamation by returning unused
   pages to the host immediately.
 - Higher values help batch pages during spiky allocation/free churn,
   reducing hypercalls and nested page fault overheads.

Setting the delay to 0 is safe and execution is strictly gated by:
 - reporting is only triggered by high-order page frees.
 - expensive hypercalls are bounded by a slot capacity watermark check
   before proceeding.

Signed-off-by: Pratyush Mallick <pratmal@google.com>
---
v4:
 - Added a helper function for schedule_delayed_work().
 - Updated the commit message.
 - v3: https://lore.kernel.org/linux-mm/amiPTPKfTOEpgetH@lucifer/T/#t
v3:
 - Converted page_reporting_delay_ms from a sysctl to a module parameter.
 - Dropped the max value cap (PAGE_REPORTING_DELAY_MS_MAX).
 - Documented page_reporting.page_reporting_delay_ms in Documentation/admin-guide/kernel-parameters.txt.
 - Updated code comments in mm/page_reporting.c to reflect dynamic parameterization.
 - v2: https://lore.kernel.org/linux-mm/3da27fde-25dc-4cb8-8e05-74cd26fc2f7c@kernel.org/T/#t
v2:
 - Documented page_reporting_delay_ms in Documentation/admin-guide/sysctl/vm.rst.
 - v1: https://lore.kernel.org/linux-mm/20260722192935.1646848-1-pratmal@google.com/T/#u
v1: Fixed feedback from RFC.
 - Added lower and upper cap to sysctl value.
 - Reverted the reordering on page_reporting_delay_ms.
 - Dropped the mod_delayed_work() change.
 - RFC: https://lore.kernel.org/linux-mm/20260714171456.2350037-1-pratmal@google.com/T/#u
 .../admin-guide/kernel-parameters.txt         |  6 +++++
 mm/page_reporting.c                           | 26 +++++++++++++------
 2 files changed, 24 insertions(+), 8 deletions(-)

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
index 942e84b6908a..c01aa3af80f3 100644
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
@@ -56,6 +60,13 @@ enum {
 	PAGE_REPORTING_ACTIVE
 };
 
+/* schedule work for page reporting */
+static void page_reporting_schedule_work(struct page_reporting_dev_info *prdev)
+{
+	schedule_delayed_work(&prdev->work,
+			      msecs_to_jiffies(page_reporting_delay_ms));
+}
+
 /* request page reporting */
 static void
 __page_reporting_request(struct page_reporting_dev_info *prdev)
@@ -76,11 +87,10 @@ __page_reporting_request(struct page_reporting_dev_info *prdev)
 		return;
 
 	/*
-	 * Delay the start of work to allow a sizable queue to build. For
-	 * now we are limiting this to running no more than once every
-	 * couple of seconds.
+	 * Delay the start of work to allow a sizable queue to build.
+	 * We limit this based on page_reporting_delay_ms.
 	 */
-	schedule_delayed_work(&prdev->work, PAGE_REPORTING_DELAY);
+	page_reporting_schedule_work(prdev);
 }
 
 /* notify prdev of free page reporting request */
@@ -335,12 +345,12 @@ static void page_reporting_process(struct work_struct *work)
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
+		page_reporting_schedule_work(prdev);
 }
 
 static DEFINE_MUTEX(page_reporting_mutex);
-- 
2.55.0.508.g3f0d502094-goog


