Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B42A2FEA838
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 09:10:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 25ABE6B009B; Wed, 25 Mar 2026 05:10:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E4A96B009D; Wed, 25 Mar 2026 05:10:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0ACB26B009E; Wed, 25 Mar 2026 05:10:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id EFDD06B009B
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 05:10:15 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 83240E0AA6
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 09:10:15 +0000 (UTC)
X-FDA: 84584013990.19.1230769
Received: from mail-dy1-f182.google.com (mail-dy1-f182.google.com [74.125.82.182])
	by imf25.hostedemail.com (Postfix) with ESMTP id 8EE7DA0002
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 09:10:13 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="YiPAvq/V";
	spf=pass (imf25.hostedemail.com: domain of realwujing@gmail.com designates 74.125.82.182 as permitted sender) smtp.mailfrom=realwujing@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774429813;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+zwKknmbpTRf8fr0/fDVF5xzUAulDUeqLVmO9Qgf9Ag=;
	b=YWPHYwpR2qa9PpAGwU2MMqJlU/nYsjONcvBIoul6H2nL1Muk5UWks0LbLSvlgzw0Chxe3K
	mq65EXu7R0XNxz8T+lWFLhm2v8nu+dGuHIY4ExcNm9sKjuLRQzFzd7yHi6UlSIApi6rABS
	tXtXV4aBMR3gHJsIAGuJgLCd2OG1m+c=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="YiPAvq/V";
	spf=pass (imf25.hostedemail.com: domain of realwujing@gmail.com designates 74.125.82.182 as permitted sender) smtp.mailfrom=realwujing@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774429813; a=rsa-sha256;
	cv=none;
	b=eOkNxCgU5/irzI5XVSiwl2SrZgVTSObYhLrUR/P3moxtXsS6fyszNQPcMIjDsUtvX9RIIb
	TqRW8wfcR+ERsUo495gDkLSG9Dw6jt5zsvo5s9ywylu/QPfF6ovk9LeJhTPeVCBxNVnKBq
	6JtdDEuSb5fyr0z6aNKaGSRUaWuQyQE=
Received: by mail-dy1-f182.google.com with SMTP id 5a478bee46e88-2c11c43aca0so544549eec.1
        for <linux-mm@kvack.org>; Wed, 25 Mar 2026 02:10:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774429812; x=1775034612; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+zwKknmbpTRf8fr0/fDVF5xzUAulDUeqLVmO9Qgf9Ag=;
        b=YiPAvq/VuLRrZ5n1tGZQnBpmBbP+fvVdimA1irm6fym1EgWtNaKaAe1Un7B8BmZ77i
         k5ZS3eOw5m7VZ3vyux3Su/pTbbB2ESz8u9TUkL9BErTF6HIJ8hxDYwuBESYJxc8wJpRq
         6b9EJHqDEdR0lExTFMR1BkhwM4tw/UOFb9c4qb+o4w3HffwX/KzNtyLupoxcPi2OEZdv
         NzDVvn/7iJvbtKjS9teEqgyRSAYa3a4XjqDDRFsarc75JM7mHGU9jtjkksluSz5GAYgg
         sOYbNO8hgxnCVy9H4EkJlUXKchLp7ki8xEtev9waMArTX3C2QIhxmDKd5y1jhq36InoS
         LM1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774429812; x=1775034612;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=+zwKknmbpTRf8fr0/fDVF5xzUAulDUeqLVmO9Qgf9Ag=;
        b=m2hKYj7DRCfAKm882DX2OHfPnHN0/p7TcRKTxovdugTJhEo3Fy6d8lZ3zIGaAEEQHU
         qLK5PbWwlS3xRRfJdCs4uBkobap6Vtspw6bzuaHr2mkRuRfHuIB5txE738pCq/FYDbSO
         CnTKedbUN5yMTHCK3B9pdnZVnPXnXkmQTIGuILHhVlV0KFllvf+rkyktL3zjkeodHOcv
         nOeQa0eyR3Zq7qbP3HYGUe2a7rmakiLR6KzBScKQzOABNwXRfAiZWjU1jKHMIb4FqP7J
         AyzkimT1EeVgdtLDTX/esBup9rBnXD8CybQRz8PbEHtc6/pfdSasSN4HtsTxge/n6ibb
         3N4Q==
X-Forwarded-Encrypted: i=1; AJvYcCWr2NOZcq/Rl1/jrQiZHnt/XjDK7JEAnIq0vFBgR8RJsjONy6DEOvcQuHV/TA3Nb2C1sINsCOYI/Q==@kvack.org
X-Gm-Message-State: AOJu0Ywxztq4JZWFknSuCwaRGQfL28IlFghSfOHPzZ5DSfSwHnJatNiX
	IZMrxeSOQS8DTzjUXcnYaL1QFqtlHWlHDvFQqFfTs1cUr+muE6SCXTeK
X-Gm-Gg: ATEYQzw6OASpUYQNYGJFi8DiQYbQtndKMBM2JECW/cCY9cYSgrbYqWOPWejTEf9MDGr
	zD80nzHIAx1DjN77guUfmbXmY5cNvS7zcReSY/+fylC8MjEvGqqtgj6bnPT/rtjbBCWgGrAmR5Z
	ENQg7SgKppM6KZu0e4XVQWl1Q4Sjfj3mdbZFC7Sb0+lmC3otoULAe5fXV1sDIJ1OL+1b26vFEdI
	9oaR4zPHX6lxfEYf7W/WEjhUf5ybiqfmxEOseeaVCtcGbS5HMwgFlrYTQZguTCBY/iXludJnylj
	74gkLpFRDx1lpCjjJA9bshnRP0voaqYIrYgBhqr5Sl8aHB/LXW6dHA+3/LIBpQ7OrzXYD3OwoNB
	sPxNqZAuuCRH5NHfIGwcgh7DpSlacsmrqgyPBp8HV9rpGk9rgrufoUfqYMnHqBo6jTWOHkaPPHP
	KoQjxgaB8oGEcccGm1
X-Received: by 2002:a05:7300:7fa7:b0:2c0:df3b:ec1e with SMTP id 5a478bee46e88-2c14b58eb90mr2643092eec.11.1774429812245;
        Wed, 25 Mar 2026 02:10:12 -0700 (PDT)
Received: from wujing. ([74.48.213.230])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2c159e25dc7sm2786389eec.27.2026.03.25.02.10.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Mar 2026 02:10:11 -0700 (PDT)
From: Qiliang Yuan <realwujing@gmail.com>
Date: Wed, 25 Mar 2026 17:09:35 +0800
Subject: [PATCH 04/15] genirq: Support dynamic migration for managed
 interrupts
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260325-dhei-v12-final-v1-4-919cca23cadf@gmail.com>
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
X-Rspamd-Queue-Id: 8EE7DA0002
X-Stat-Signature: qt4gif83mg1tifgyg4napjxgmcgon8km
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1774429813-439622
X-HE-Meta: U2FsdGVkX1+7leHxKYAFB6XLO8AsfqERujXtecNI57fari9Lo031lAXB8hZSQdvzwvNN3C3EeEDG0M1WLZ33u1SVbb7azZjkO6sy/xn95SwJbk7CwJxmnGcB7pq4l7XxOxUOeTqwjxAbCVGNV6k6sU5Sg4tr4PlUCSwgsmxSZQKNnO0NiL4gw9LU7KgIYm/TLJ1lOF5SsQYGiWGHq8LDXJfNR3zl6NybO6LdCJ6UMtiULSXjMYgDvM2XmNhf7o6KSGdqTQFgL1k3YS9CoTVUXkn5ygoOQP8mFX1yU2GiXkjvZTo6jIKtX9AOyAUo7/ualFZhMTCrAw0WHgt/ib+iaAJRs9SZNdEG8Udtpf+xpczX/f1hsuUcyhBbPj0tmKywkI1+cPbLpfXCXckZJzY8AqsuBzN/TYyUI829FmtZVotUF+GQhRPE79d7thnV+lELQ1woG0aOXXJBH0UiyEgQ/jyYXznAi+d8hHNgoOdihmDwfceR9NWS0HrA8q3aEidDUktjO3P84UTZrh7xjEvBBdhjsxP79QQ7CeOR+lyaE/9+7PjWUwwQ4fRMHRAmq52J9vYxmVWDhWLyywPB1X2VTx775VcQiEwr7e08a4V9QlRxgh2oUb5UZcIHjqp6QeM37xuI38NWOhK6MlnJWkqn4v00le7Nc+4CyJ3kz4bsOybGw25GpP7r3jgQ2xBzU7phM9mh1lHNQG3bDYcRRgE7Qi2OgFCx3Dnn+0Q+BtQ027fAhAiiKvuXq6rxaCO9E+wWpE6gEwhoUyydGRgcCW2N4zFhpaISn6q7xeoWPlXI/QFA06GRB/yEPUKicYALxuzN4fi7Ub3l0o6Y8gK6VUIaC27gqeO2zRerSLc7bk1Hy560Fh2AMRUj7gnnWzvWuxBD61de3XLLoNax2ehdQQifUx5AUZazyp9x0FLMCqogWHAPbbCcbA8beKm+iDbcGmA5nx3XyjWk+/5aRNCiJwZ
 dTGGgzW6
 p/chE8b3so85afOy0mRawIyoVJLb58SRPofzVSSmuRlPDeVT4G1BW5HEoj4DtVV9Pgegjrs/ikE+x8vjPuUxTu4ky3JiB0WzeKyFeAHrm1qQ5qKimstw7kokOtFrgffT3L7dInVh02w3Wmmw3al+YNF6R5/5O8b5oG/JtJTM6rA7S1ouzMeFmMkiFY4An5uiqqRF47s13XCk36yXOAzM/bhw/+Ral/LnvANoZtFw2ByG1c5V1BrMMGF5lG8D88t3TfjlashBcUWWghNw+S6QZS1jWop1gmzFbvfgIUxT+h+Cu+kS8PtaomzUHXRwMLxj0GTIEX8Hkg0nDiR/g+SSPDI1xCmAe03gQo5MsNQexBy1crBacabsjqVd1tbHVgUTVXwKikcZDGEbXYpKhxljDHMM2sRiMokuxoZUcMxDOuiCJKzS2Jbh24uOKGyfXblmsgiIwwY4+BlT7amLBdEM5kutvjJBDMgmfNiNY/f/hsU5YklpT1j32Tk/2Vg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Managed interrupts currently have their affinity determined once,
honoring boot-time isolation settings. There is no mechanism to migrate
them when housekeeping boundaries change at runtime.

Enable managed interrupts to respond dynamically to housekeeping updates.

This ensures that managed interrupts are migrated away from newly
isolated CPUs or redistributed when housekeeping CPUs are added.

Signed-off-by: Qiliang Yuan <realwujing@gmail.com>
---
 kernel/irq/manage.c | 49 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 49 insertions(+)

diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 349ae7979da0e..f2cba3d7ef624 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -2811,3 +2811,52 @@ bool irq_check_status_bit(unsigned int irq, unsigned int bitmask)
 	return res;
 }
 EXPORT_SYMBOL_GPL(irq_check_status_bit);
+
+#ifdef CONFIG_SMP
+static int irq_housekeeping_reconfigure(struct notifier_block *nb,
+				       unsigned long action, void *data)
+{
+	struct housekeeping_update *upd = data;
+	unsigned int irq;
+
+	if (action != HK_UPDATE_MASK || upd->type != HK_TYPE_MANAGED_IRQ)
+		return NOTIFY_OK;
+
+	irq_lock_sparse();
+	for_each_active_irq(irq) {
+		struct irq_data *irqd;
+		struct irq_desc *desc;
+
+		desc = irq_to_desc(irq);
+		if (!desc)
+			continue;
+
+		scoped_guard(raw_spinlock_irqsave, &desc->lock) {
+			irqd = irq_desc_get_irq_data(desc);
+			if (!irqd_affinity_is_managed(irqd) || !desc->action ||
+			    !irq_data_get_irq_chip(irqd))
+				continue;
+
+			/*
+			 * Re-apply existing affinity to honor the new
+			 * housekeeping mask via __irq_set_affinity() logic.
+			 */
+			irq_set_affinity_locked(irqd, irq_data_get_affinity_mask(irqd), false);
+		}
+	}
+	irq_unlock_sparse();
+
+	return NOTIFY_OK;
+}
+
+static struct notifier_block irq_housekeeping_nb = {
+	.notifier_call = irq_housekeeping_reconfigure,
+};
+
+static int __init irq_init_housekeeping_notifier(void)
+{
+	housekeeping_register_notifier(&irq_housekeeping_nb);
+	return 0;
+}
+core_initcall(irq_init_housekeeping_notifier);
+#endif

-- 
2.43.0


