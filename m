Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7A343FEA837
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 09:10:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DCD376B0089; Wed, 25 Mar 2026 05:10:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D7DC26B00A5; Wed, 25 Mar 2026 05:10:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C6D9E6B00A6; Wed, 25 Mar 2026 05:10:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id B143A6B0089
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 05:10:38 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6F0EB1A0811
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 09:10:38 +0000 (UTC)
X-FDA: 84584014956.12.1AA4DDC
Received: from mail-dy1-f176.google.com (mail-dy1-f176.google.com [74.125.82.176])
	by imf23.hostedemail.com (Postfix) with ESMTP id 7AA74140009
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 09:10:36 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=qAsF3NKq;
	spf=pass (imf23.hostedemail.com: domain of realwujing@gmail.com designates 74.125.82.176 as permitted sender) smtp.mailfrom=realwujing@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774429836;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=B65y17E56pZOCr9RDMC9jiTFzum1CPtoQPIrPMkYTbY=;
	b=vX29DjVo1qPF2KrmTb1mn2SO4bloR/l6oAxIV5BLN9G96IeUedp08u0hZrWzegOE6qowUP
	6c139S6FEJpren66yePO11KGSdZat/HXPEqugdUMrerko35XXISsA7bUWzaGlJFXQHY2++
	2AcEdcz0uKH4+9089x2HBRiIWyVC1No=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774429836; a=rsa-sha256;
	cv=none;
	b=8SWJ3rHXK6qpS21VTwQ5Fp1i/JQ2hoC0P2USjl3Cn1NLI0vnaUy1Wt4u1ULtt99U+hQTEa
	oMDsZ347aabBYFHSNvRWNqS34yFFwmW/VfOySWgjK/6OTwZmTSOf9vTI2MUXZyumPEKi6t
	U6ELRLiFD1GiLqggTyGy/MMU5v7VZUk=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=qAsF3NKq;
	spf=pass (imf23.hostedemail.com: domain of realwujing@gmail.com designates 74.125.82.176 as permitted sender) smtp.mailfrom=realwujing@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-dy1-f176.google.com with SMTP id 5a478bee46e88-2c107ef474fso5216782eec.0
        for <linux-mm@kvack.org>; Wed, 25 Mar 2026 02:10:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774429835; x=1775034635; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=B65y17E56pZOCr9RDMC9jiTFzum1CPtoQPIrPMkYTbY=;
        b=qAsF3NKqjulAhW1a8TtdfPibcJSYle933rz5m5sbuJCaBWr+Vpp53qCr13UB8W+QeT
         4zT5kaZdtW6tws2nUY0P2H5i4DS7i9tGSBjBHN4RCvdsI+u27m4rgYQMLnv+PfAzl3Kk
         kvchrRkwRW/Oxw4GEftGrxm6AwYsjZewgqAIDCZoDoy3aOT12NTrSKHcL4wlD4IHm5wg
         7gHZ8KQrV7suK4pM/plAup//TV8qWPwjXaps7tg68mXBEJDnK+TExB0+jGs9VSh8liuc
         nvj8Ffl/XgJO+NArSSp8j43DANM957dSMP3M2QpyG2TXZxpvzV2PgMaGPpvZIepDQR2j
         /twA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774429835; x=1775034635;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=B65y17E56pZOCr9RDMC9jiTFzum1CPtoQPIrPMkYTbY=;
        b=bsXg7hkvx13Qc+XRBQ5QyQHe7nsAWIOrPeNvUA7FLWHdk/DhsKKHVIYdmFuLBWHOc4
         GsdDH4Dr4YBfKf0hjiIC+/MJ5Z9YfSL/xKVf7mCte5IddTpY19sX1J/IgYmZE54rnQ6S
         7ntzCje1rQbXXLv2qduBOdZ4RB43FRZQ7rtunAR0eQYlLkpGk282gu7/k9aAOnfpVCkV
         cCHq/ViCQlKzZBk+k5HGTzQtgRbxc91jJqLEEK9jtN75stUnyJ4txXfeG9aWKPFluMlT
         Hc6dY/2XhOAueMt9bH2V7VRIds8Y/iazLbsnY9MtJKuPtl316TiY+/K4FMsw8fb17DzO
         PVWQ==
X-Forwarded-Encrypted: i=1; AJvYcCWxJTfBhD5b6Z14HwpU/uKLXbPp2ZKAUylwO4zt8EEY8lfNg0Df9broC1zv2KwCIkDF+Q5bTULqgw==@kvack.org
X-Gm-Message-State: AOJu0YzGGevXGbTA2oNQ3Vi93MF1/hf3yh2vJFrpXQnVjPJ7eDdNChuL
	4Ag1gTZEyBN20wiVRObe3tje0plo+GzXonpcufmDvEORAdsyna8SCffJ
X-Gm-Gg: ATEYQzwt5VV5HApWwq8rVLv8uDgxDDku/qZysTXUJP4BeOZgIH0eaHHEGEmrMkEN8XT
	fR3gEXqopiIUhPVt60HAI6AsOtu822BED2Y2SbzhESYeydaFchOIE4sWQwmLc4rwp5kYBSTnSin
	Bi8yCAaR5QPQ44z+EYXikF47wXxQN5aXVkXHu+RhgZA3ZXersritY0FQn2gyun+zrY77+MKmodi
	NXA6yHAOrB1Y9QevhwjPDMPsfx3ersrbNHRJWXbor21x8Bx4LPTtysPdSUnogGV1wy1ZqlK6Mqa
	nLka5JWIzCub6Nira6D44mPZ/zNTOQTPuP20n6WzIvq1qkBywCT62b67XBdZWtIFRs+zubwIOXA
	gveT1c9LK8gpZLMT7jWrZhEN7j8TiOMB+IEfFOBvEbLg7nGBPmDfYmnw6GcAKJtbY5HEch5WVUb
	RFEaaNqPqUmp94pobOGYEX4gnKxrs=
X-Received: by 2002:a05:7301:6592:b0:2bd:c8a2:954 with SMTP id 5a478bee46e88-2c15d41245bmr1419655eec.24.1774429835176;
        Wed, 25 Mar 2026 02:10:35 -0700 (PDT)
Received: from wujing. ([74.48.213.230])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2c159e25dc7sm2786389eec.27.2026.03.25.02.10.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Mar 2026 02:10:34 -0700 (PDT)
From: Qiliang Yuan <realwujing@gmail.com>
Date: Wed, 25 Mar 2026 17:09:38 +0800
Subject: [PATCH 07/15] watchdog: Allow runtime toggle of lockup detector
 affinity
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260325-dhei-v12-final-v1-7-919cca23cadf@gmail.com>
References: <20260325-dhei-v12-final-v1-0-919cca23cadf@gmail.com>
In-Reply-To: <20260325-dhei-v12-final-v1-0-919cca23cadf@gmail.com>
To: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, 
 Juri Lelli <juri.lelli@redhat.com>, 
 Vincent Guittot <vincent.guittot@linaro.org>, 
 Dietmar Eggemann <dietmar.eggemann@arm.com>, 
 Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, 
 Mel Gorman <mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>, 
 Thomas Gleixner <tglx@kernel.org>, "Paul E. McKenney" <paulmck@kernel.org>, 
 Frederic Weisbecker <frederic@kernel.org>, 
 Neeraj Upadhyay <neeraj.upadhyay@kernel.org>, 
 Joel Fernandes <joelagnelf@nvidia.com>, 
 Josh Triplett <josh@joshtriplett.org>, Boqun Feng <boqun.feng@gmail.com>, 
 Uladzislau Rezki <urezki@gmail.com>, 
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
 Lai Jiangshan <jiangshanlai@gmail.com>, Zqiang <qiang.zhang@linux.dev>, 
 Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
 Vlastimil Babka <vbabka@suse.cz>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>, 
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
 Anna-Maria Behnsen <anna-maria@linutronix.de>, 
 Ingo Molnar <mingo@kernel.org>, Shuah Khan <shuah@kernel.org>
Cc: linux-kernel@vger.kernel.org, rcu@vger.kernel.org, linux-mm@kvack.org, 
 linux-kselftest@vger.kernel.org, Qiliang Yuan <realwujing@gmail.com>
X-Mailer: b4 0.13.0
X-Rspamd-Server: rspam12
X-Stat-Signature: i6zdb9mr5psxs66qq9h5xyxfbzm9o4gh
X-Rspamd-Queue-Id: 7AA74140009
X-Rspam-User: 
X-HE-Tag: 1774429836-439444
X-HE-Meta: U2FsdGVkX1/ZNRnqBwezPoc+hoIMEmWpv4oaDdy5WTD+o5/Pos7QC0RDw6qAS9VH+BEEnmVhPmBf79HlSWyCfaHZSirFOwWTHkkmrtYk+Z0/AzdWjTRFDArw5Jx4a0EwA8vXx7Ga8totGDMVXDP51h5oV5+G/U9dQlde7JKxhilV/0LdqBvLTa6I2woVLzhCtj+NO3xu2uehnOKsStEy/4lXs0xPQHIcoRn8ntL8s5OBH0sm/UcC1W4VuUGS/5SXzV2wqCe9ZP/bIBMOb1tQJvM45OMXkEoFKI0bjhluIyqBFe9ymc7F2i/uVatkmvV3QdINI2Ey3KoSP1sIUhTqudr40OIW2AxdUYfhy3Z5QNUjFPmjILTIj++5kptgT/7TSZVXl2nCSzZCZa1gh7JyaFI1jhlNzQXy8nsXz1BPEPN8UdIg35g1TRyszVMQvjp0Ah+b/vqtDXLuRlzQppLNX9PIf1LpS440fBgrWYvtC/gfVfbY0Hr+FOebdxPM8ePxgayQkV3Wi93IEpe9GPZU4TfVsl0WRWGMV/cgBKG/j7Q2u/5pWGlQ53fjsSjZtfVEkTEx6B3vqjTTtEuhnzxXX3vZmL8+Jjy5lC0AFJ1H8RL1D/iYn17e1BOsitSPKDYhxZ9dm+kfGPS8ltiOHOeQzMruZgOfRkznWMFrejvKwHDQ1Uo3GfLpTb16+saL7Oo3pdvtfOi+pgCdPsZtDiA8YluS9iqIyiAH1rQgsT/84dFbOWFeARaIkicSIZ95kkblgxMgf70am8KezmnMAdxASiIrisQJdpdXAnHfHqvep7bypg09u7FL9bBYy1WwbOamwB01OC2F1Tu4Q/gAiPMNoD5MjAuIr3HAtwO/bS8cB/2MO6UfUff9IaAFE978JDx1qqvBOAwkUU7JwrPBMUzqy7CgceXVzv9FUai3ZIP+kCx41fwqsnwNMThe2Dl1lC/5o2FhaQlViO25QoZxUdU
 +9zDfKqp
 ry5IKuKNaNWxUEyijX6pmKT7SFIApXFLOPw405GIOXfDnRPDRdKiWbshAmnaJgIiAKYjAUh31cMj/YjonXBw0qUzmYYmqRh7By5d5lQDfW53YoXVnA2r26oWsaycHaX0zVmXPlzthJbeeQb1sIB8q8CmmNUNlEglMk761D1bej7Ad2udcrPIksbBYrOzqgYjLbJ8CD6+25qJqe40IZdY4ci/PHRsM+2OCtNePHUgcjMVvVe1+qCqnBWEenniNNLz339gQwNln53jD0SalEIjB5AMahtg2aSnWeZfxL3LQo6YlD+nihj8oly7PqN3/Sz4lzX5qxb3a8mL7hES4w+EpvhWjeEPIbPbSNvA3UGlxyDdUXjhVWOttfdr4VoPOV0oUKAHxgp9gZl+FddkTcxFTu06shzdz2Bzi0SF/MBJoLtPux7N7yTPM6OSDGyW56b7PWs3kY6gf0/F2yUh8RlcxjZYaxBr5f1LAs+lK7JmIZfrWaosTgxs8GjnKmeGY5j7gmFdKSdjtgvfgguzyPGp+/AW3csDmS/jal9OoP8GgtSFTFstyb2E/bGoE8A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The hardlockup detector threads are affined to CPUs based on the
HK_TYPE_TIMER housekeeping mask at boot. If this mask is updated at
runtime, these threads remain on their original CPUs, potentially
running on isolated cores.

Synchronize watchdog thread affinity with HK_TYPE_TIMER updates.

This ensures that hardlockup detector threads correctly follow the
dynamic housekeeping boundaries for timers.

Signed-off-by: Qiliang Yuan <realwujing@gmail.com>
---
 kernel/watchdog.c | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/kernel/watchdog.c b/kernel/watchdog.c
index 366122f4a0f87..ef93795729697 100644
--- a/kernel/watchdog.c
+++ b/kernel/watchdog.c
@@ -26,6 +26,7 @@
 #include <linux/sysctl.h>
 #include <linux/tick.h>
 #include <linux/sys_info.h>
+#include <linux/sched/isolation.h>
 
 #include <linux/sched/clock.h>
 #include <linux/sched/debug.h>
@@ -1359,6 +1360,29 @@ static int __init lockup_detector_check(void)
 }
 late_initcall_sync(lockup_detector_check);
 
+static int watchdog_housekeeping_reconfigure(struct notifier_block *nb,
+					    unsigned long action, void *data)
+{
+	if (action == HK_UPDATE_MASK) {
+		struct housekeeping_update *upd = data;
+		unsigned int type = upd->type;
+
+		if (type == HK_TYPE_TIMER) {
+			mutex_lock(&watchdog_mutex);
+			cpumask_copy(&watchdog_cpumask,
+				     housekeeping_cpumask(HK_TYPE_TIMER));
+			proc_watchdog_update(false);
+			mutex_unlock(&watchdog_mutex);
+		}
+	}
+
+	return NOTIFY_OK;
+}
+
+static struct notifier_block watchdog_housekeeping_nb = {
+	.notifier_call = watchdog_housekeeping_reconfigure,
+};
+
 void __init lockup_detector_init(void)
 {
 	if (tick_nohz_full_enabled())
@@ -1373,4 +1397,5 @@ void __init lockup_detector_init(void)
 		allow_lockup_detector_init_retry = true;
 
 	lockup_detector_setup();
+	housekeeping_register_notifier(&watchdog_housekeeping_nb);
 }

-- 
2.43.0


