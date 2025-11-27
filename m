Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 15EB2CFD2F6
	for <linux-mm@archiver.kernel.org>; Thu, 27 Nov 2025 14:52:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 595DB6B0030; Thu, 27 Nov 2025 09:52:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5460A6B009B; Thu, 27 Nov 2025 09:52:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 40E6A6B009E; Thu, 27 Nov 2025 09:52:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2D78E6B0030
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 09:52:04 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CD4A512927
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 14:52:03 +0000 (UTC)
X-FDA: 84156676926.27.3113650
Received: from mail-ot1-f47.google.com (mail-ot1-f47.google.com [209.85.210.47])
	by imf26.hostedemail.com (Postfix) with ESMTP id B13AB140004
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 14:52:01 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	spf=pass (imf26.hostedemail.com: domain of breno.debian@gmail.com designates 209.85.210.47 as permitted sender) smtp.mailfrom=breno.debian@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764255121;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references; bh=cAIzZlwt931JkoUZjg2FOr5ixA966v/JOvVIg0npcNI=;
	b=MfeU5VP2HGh369rykMhDMZXBobZ3FBaPHkfa5AMUnMoXSkbHuKNf3dOKS3KdbuvN4aiUsW
	LDx/rdCMn42tTRpE+iqc4kjOE8diDNI/vUF3/JrQqzi2AyQ+X8P8ybFg4X6qOkzgK+8PFj
	ppn3+lP5ux1yUSo3jX57EQtQImkPA60=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764255121; a=rsa-sha256;
	cv=none;
	b=6lGiAM804pSPwxxOb9xYMJXykJTEIe82L9UhyRCgwlIjEjv+p/auIjiOuJTmn9DmgxD4wm
	rthOQUfG84zOEI1+3V4Bw4D0Foi7A3NaRQDi8uXr46wn7URf0DCyjHNuWIZIrbbyUbFLbQ
	3psBs21y5y5IYZo/dm7EXbOY+XkHmDs=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=none;
	spf=pass (imf26.hostedemail.com: domain of breno.debian@gmail.com designates 209.85.210.47 as permitted sender) smtp.mailfrom=breno.debian@gmail.com;
	dmarc=none
Received: by mail-ot1-f47.google.com with SMTP id 46e09a7af769-7c7660192b0so664001a34.0
        for <linux-mm@kvack.org>; Thu, 27 Nov 2025 06:52:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764255120; x=1764859920;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cAIzZlwt931JkoUZjg2FOr5ixA966v/JOvVIg0npcNI=;
        b=vSKPMrZdaBMKLUAQcpxTV9q6ipZBqiXMhdVHIVVD9mj59TpbfIfROY7NACUtcT8dZI
         gw4rAJ2fzZQpfAArgIOotrS8a7rthqg/P2VTFDmCh3j90shzUfBhxnOFWWbCt+4/nZ31
         1A1S+6x4QRP+YDkoCFv//Kvicq3PruywXfHttIO1BHi1BMEAhoc2eQ/vkXnZ4gsUnP/V
         M6FeDsHpdzKo/s/oNi+62wYINHUwC9jXpzBRc5I6OSkMY3ZsjiSAQ2GdAReUbNwWRz7L
         zkFsNzLerwYVZeAHHYInU7zchA6NGN6bGZ1wFWGpSYOSP7cFpMfwIH3kGJ5O1GtXVR6E
         ZugA==
X-Forwarded-Encrypted: i=1; AJvYcCXhzdmf2+fTv2oiB7Nk/iee4r8JJydBhyQJrvEUO9fJPPXCQfpe9PSPmPQ35Y6OYTSS1cNLPthqCw==@kvack.org
X-Gm-Message-State: AOJu0YwHk2z2GreyZArIhFK81T3t+XhER6Zs1iO3m/HcgW/8bs+8mlab
	9v0a6HOqFMa/j4QXnIUztF8h5spParpnikhP4H+Yx1skzO0s4EtMZvE+
X-Gm-Gg: ASbGncuEvM2ztC+lI+5J/6VJM+NXsjrVYet8+5k+GhW8MQF3ve9VmAIMRVGmJLuIaoF
	fMCfCLCk/c9lBgOwafTnV82MbgPNmwfd6kb+xL34YTZnTl09RMBFg4mPID5/SCs2UkFxQkujknV
	JKIgjWONBKH1cpeKWLEXzJtlI28HzAFR19LnoOB+1pOSsdIVjEMFY8SZ53740nq1pUZcluzAc5i
	J8585KYlYEBRx/0W+Uy5EzKxvr9yPJhC6yXbRpkA6X5kkAAYzXOXP6ndp+pCBxvdwklunleO5Na
	jZZMCaACRgPx1ZL4I7QyP20zFZtGcQpPSsTSRu9tN0WDoQ4wf2LX82igxVgxtqb8Ge8LW2BAk95
	HkC5wdYv1KvvcZi0qSLq3OWE+5zB0GW1e2iQ82zu2zM2/xcMpIbRFUeq9iJBEPXkfZcX3r39kBi
	ttJovmVHhs0AQCJA==
X-Google-Smtp-Source: AGHT+IGjXOzX1/INjAxLcMiQb6vVvjsDvCY0JqSDikDDbIziJmMNiu2ppTrz8kRjx6Znh9+6s5DyAA==
X-Received: by 2002:a05:6808:21a4:b0:450:f45e:f4a9 with SMTP id 5614622812f47-45115a2eb3amr8969148b6e.19.1764255120607;
        Thu, 27 Nov 2025 06:52:00 -0800 (PST)
Received: from localhost ([2a03:2880:10ff:5b::])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-4531708e744sm431286b6e.11.2025.11.27.06.51.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Nov 2025 06:51:59 -0800 (PST)
From: Breno Leitao <leitao@debian.org>
Date: Thu, 27 Nov 2025 06:51:54 -0800
Subject: [PATCH v2] mm/kfence: add reboot notifier to disable KFENCE on
 shutdown
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251127-kfence-v2-1-daeccb5ef9aa@debian.org>
X-B4-Tracking: v=1; b=H4sIAIplKGkC/2XMsQ6CMBAA0F+53EyNVwRsJ//DMJT2gItJMa1pN
 KT/bmR1fcPbMXMSzmhhx8RFsmwRLegG0K8uLqwkoAXUZ90R6V49Zo6e1UV7085mas1gsAF8Jp7
 lfUT3sQFcJb+29DneQj/9KwopUp3rmcLg+yv5W+BJXDxtacGx1voFZj9m850AAAA=
X-Change-ID: 20251126-kfence-42c93f9b3979
To: Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>, 
 Dmitry Vyukov <dvyukov@google.com>, 
 Andrew Morton <akpm@linux-foundation.org>
Cc: kasan-dev@googlegroups.com, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, kernel-team@meta.com, stable@vger.kernel.org, 
 Breno Leitao <leitao@debian.org>
X-Mailer: b4 0.15-dev-a6db3
X-Developer-Signature: v=1; a=openpgp-sha256; l=3057; i=leitao@debian.org;
 h=from:subject:message-id; bh=La8G30hl9qem1PV0MHxUCDzheJkZdQA86wiUtuO0D5s=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBpKGWPOQkKx1HnYBIusPuWFSi1zEKgAagB3QQqt
 OCZwoLBZX6JAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCaShljwAKCRA1o5Of/Hh3
 bb5qD/sFLPYK6ITq6kgbAyxqkbZNfmJ60A+CPwbjNtm8XT727QN5Zu9W3ONIdtd4AasadA+qGOM
 qjDQscvF6Jqm8M5++IbkBuAb/dOGZ9TEiD5WtK8qwFeWFDdItO6H+pvFxUHj/hki3zstK70/9BA
 dB1ILdAJBqtzW0SM8zJ+mNN5uQCAIbh8QNamqioC6twnkJ7WoK9u39f9FfyC+ZCIQ2HL/mFGwtC
 EmKnY6+9hYwruwBF++2d44yCoaHTRjRnMHrFhsrJbhR2sYnhN3yC7M0G5OqwYhjserxdcmYVAxB
 oEm48SGyNmeK2r+9vcJOpSzh7yF3Yv+YMh70dZbY58he1kXuACNklOMwe+apkA1k3BT5nkRIu8l
 275PckhkwGZhlXVZkwqQ77hNYV6oJrkeh/CHHA8gfRbPysFcnlIn0z2E+cl2S58D6rEttEMJH7A
 QjPJT2prC0+KKql8M3EGoqhZ6l4zJlIbFhZLft1V1MypIsLIbgTzfd0pcdyEEDyTA3VvJO1Y9Ra
 UAjKln6TFsArkYDcZimLTeTVRxOAkvlgvhZDs49MGFtvyYCzBp53BCLXv+mV4+GnMfD3rqcF09+
 ktyKFkRGNqJEb/J+y2SaGlte+it0n37XphkvXKIjM7GYEQey9yI6ZWLGQtzULDou7EIeLx3l85Y
 Cbq0Nap2eYSJfPA==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: B13AB140004
X-Stat-Signature: tkexbfgjyzqjutdho54wdkgsgsp54gp6
X-HE-Tag: 1764255121-476110
X-HE-Meta: U2FsdGVkX18lr7oWp3j+dSoOcMXbWU0pJWoodHTevoVa2+HMsT2oT3jHhFAiCU7HVlZ6WLs25iBEguiJBMJKG8Lo2bLxeA+Gh/1Ig2E9ZO34NqrLiM5iMaNnXW1hvCTyooXdQsMsQeCJyhhE1YIJ6nFM2mC7wOHrWAPMyV7yEjGgqk7EKDzLoQ1dkbfOOXFz6w4AVly+VCpVvvYLu4cRZf/IVafXj6QMmDPzunlhYD04Xocm03c+QYR/wkG1TUG6/iErVeYBIbKC6H6TqCPjBnULCLcDjA7Nz+X4w0OpFMxjn6T0Wz6L+D7ORtK+7Rg02dRrUuCWeBOGkJdLRhaq6UyfKGmCn9yQuUlIz5fUbPqPNyGQ9l703OrAoq/N25Zqonh9/NKaG4db1w4g9+j3YL2alQbEa07RozKf4kDQGzjNughqdh1yjdOom1vbb02EY0kHpIrYJheSiTRqMS8m3Lj6E7H/Er4fKboifVaMh9FWyUBlVYj8/kwJtSMmwNHRlqBU7yekvv5cjm+pVUwQctWac7DNp7aUM8tMylD3zsadE4DoCjg+S4gobuom1DU69eLxfeFeDKTFnOrwzF1SqKK+Fl0ZFFfPnuuB/8SAIm1AHsFR6if6Zo1c5CJ9X1GdQO5Ly3hKdQresZ42GSQfW5ylvv8sqSr5G7xuzCm670cwwsOYBKvejCy/+gz3Jzs940eqk0liqjlCWMZXEpqZZZYJgj/FcZcgJFKKFC55NT4roIpj4aKwPwQXa9MKlwnl7/MjumsbGUIgB9A5j7VN72MFpR4lBrfM+kFwABiJDiiuV4awtCpGoJJIDyz0i5dsXV/sB5CQeyS+kvTFDNf7xuqKnh7zuHQHKs+b3vysv0VG5ieJ7C0XQIB2uphGAbVY7Am8Cnu6Nyq1+zEtphK2Ci7Li4DmfE2a+p7y4ns5Qn7KwxfWoAJzun0G18AW9Uv1mmwe87s8qipidkDfSeT
 rza4hzDj
 JJ9wvYDhWcIVDyQFqsoWPB8MBUBkUH/5BnnrGNrFRG/9Nn1rY7QuqtoK9ppQncvdR9zxJ73DIEileEml1fgbA2zR0buNdKPJUa5OgzTO6Hgm0FdkXw/W/5J1FJBo9EKsxJk9tNtT7jNyEBOLLJ6Dp82H5ng4U+Rdcqo3RP2Bgh1TclbrV4HXOxAhQWO9lsla1FzjJOAXNcoNLlrwolv4/TD7r2d3VAumoly6O5dVm6q+kEzrAeWNwS8yjbqtHvGXgdVDoQz2goHoeqhUCieBV6wba/2u6DRle5q+B34SiqRu16LbsqBmrg1ec7oS/Gz8cDp/VDcCP2nqmw0Sta5kmp/Or9TIKZ7KbHEqKkb9d2enmbHiYgTehx4+vCrGtkf7nX8XBfLV4YyIqkUeMvF6N5QT8nxp9p6OVYs/tRqAjWePcrGiPd3BvFc2fQKOI+cOJ6PE9PK9Dgp9p9lUbzWkuXFmFU5dVVOSjksw1Cgg2fVngAg215SWuqpOgGudqgn9dWA55djJQ+rqE4AVRM0gezANOYWf+NqDDOgyvvvNAPlbrvKrQItZE6Rk+0J1yTozQioCI3hxaP47+e/8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

During system shutdown, KFENCE can cause IPI synchronization issues if
it remains active through the reboot process. To prevent this, register
a reboot notifier that disables KFENCE and cancels any pending timer
work early in the shutdown sequence.

This is only necessary when CONFIG_KFENCE_STATIC_KEYS is enabled, as
this configuration sends IPIs that can interfere with shutdown. Without
static keys, no IPIs are generated and KFENCE can safely remain active.

The notifier uses maximum priority (INT_MAX) to ensure KFENCE shuts
down before other subsystems that might still depend on stable memory
allocation behavior.

This fixes a late kexec CSD lockup[1] when kfence is trying to IPI a CPU
that is busy in a IRQ-disabled context printing characters to the
console.

Link: https://lore.kernel.org/all/sqwajvt7utnt463tzxgwu2yctyn5m6bjwrslsnupfexeml6hkd@v6sqmpbu3vvu/ [1]

Cc: stable@vger.kernel.org
Signed-off-by: Breno Leitao <leitao@debian.org>
Reviewed-by: Marco Elver <elver@google.com>
Fixes: 0ce20dd84089 ("mm: add Kernel Electric-Fence infrastructure")
---
Changes in v2:
- Adding Fixes: tag and CCing stable (akpm)
- Link to v1: https://patch.msgid.link/20251126-kfence-v1-1-5a6e1d7c681c@debian.org
---
 mm/kfence/core.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/mm/kfence/core.c b/mm/kfence/core.c
index 727c20c94ac5..162a026871ab 100644
--- a/mm/kfence/core.c
+++ b/mm/kfence/core.c
@@ -26,6 +26,7 @@
 #include <linux/panic_notifier.h>
 #include <linux/random.h>
 #include <linux/rcupdate.h>
+#include <linux/reboot.h>
 #include <linux/sched/clock.h>
 #include <linux/seq_file.h>
 #include <linux/slab.h>
@@ -820,6 +821,25 @@ static struct notifier_block kfence_check_canary_notifier = {
 static struct delayed_work kfence_timer;
 
 #ifdef CONFIG_KFENCE_STATIC_KEYS
+static int kfence_reboot_callback(struct notifier_block *nb,
+				  unsigned long action, void *data)
+{
+	/*
+	 * Disable kfence to avoid static keys IPI synchronization during
+	 * late shutdown/kexec
+	 */
+	WRITE_ONCE(kfence_enabled, false);
+	/* Cancel any pending timer work */
+	cancel_delayed_work_sync(&kfence_timer);
+
+	return NOTIFY_OK;
+}
+
+static struct notifier_block kfence_reboot_notifier = {
+	.notifier_call = kfence_reboot_callback,
+	.priority = INT_MAX, /* Run early to stop timers ASAP */
+};
+
 /* Wait queue to wake up allocation-gate timer task. */
 static DECLARE_WAIT_QUEUE_HEAD(allocation_wait);
 
@@ -901,6 +921,10 @@ static void kfence_init_enable(void)
 	if (kfence_check_on_panic)
 		atomic_notifier_chain_register(&panic_notifier_list, &kfence_check_canary_notifier);
 
+#ifdef CONFIG_KFENCE_STATIC_KEYS
+	register_reboot_notifier(&kfence_reboot_notifier);
+#endif
+
 	WRITE_ONCE(kfence_enabled, true);
 	queue_delayed_work(system_unbound_wq, &kfence_timer, 0);
 

---
base-commit: ab084f0b8d6d2ee4b1c6a28f39a2a7430bdfa7f0
change-id: 20251126-kfence-42c93f9b3979

Best regards,
--  
Breno Leitao <leitao@debian.org>


