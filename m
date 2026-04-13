Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6A44CEBFD10
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 07:43:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B15A16B008A; Mon, 13 Apr 2026 03:43:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AEDEA6B0092; Mon, 13 Apr 2026 03:43:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A042F6B0093; Mon, 13 Apr 2026 03:43:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9251E6B008A
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 03:43:48 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 354D21B9374
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 07:43:48 +0000 (UTC)
X-FDA: 84652743336.02.229B059
Received: from mail-dl1-f42.google.com (mail-dl1-f42.google.com [74.125.82.42])
	by imf27.hostedemail.com (Postfix) with ESMTP id 4B94D4000E
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 07:43:46 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=noT4DQ1F;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf27.hostedemail.com: domain of realwujing@gmail.com designates 74.125.82.42 as permitted sender) smtp.mailfrom=realwujing@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776066226; a=rsa-sha256;
	cv=none;
	b=jYPfxiVuu/mKlVLc5qJPYQUrzliYMBW6m4N3NQKXYX9GscMjaIDyb1rl3my2D3zeFfh843
	6PYKR5vFSzeo1H1rZoaiZ073/Ex6TWl/tVlsMktunVVCcE5cWXkg2Vd4b5utXJM7Lbq3IM
	AJKkHEdzOleW6gie4ww2QjruXAS3jXY=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=noT4DQ1F;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf27.hostedemail.com: domain of realwujing@gmail.com designates 74.125.82.42 as permitted sender) smtp.mailfrom=realwujing@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776066226;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LuagEmmraWwH0d8g+cKuhFh1+5bCP0hdNVypbGGgG6g=;
	b=Uqs/EJvEL80MRMGZWY87QeEBwSQPuVejp6k14Nz3SxS6OXZ1rlH1upW7FKcrrjshvRuY5B
	xzd2KyiwJrBfoIj/FtoVAeenflTUxO/TwtTPYuivj79IJtLIzh6nRA1P7ljcTD+jWSYfk+
	rsIAORCCjVYiszUv/iYt5kng2QSmAvU=
Received: by mail-dl1-f42.google.com with SMTP id a92af1059eb24-12c20010f10so10473490c88.0
        for <linux-mm@kvack.org>; Mon, 13 Apr 2026 00:43:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776066225; x=1776671025; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LuagEmmraWwH0d8g+cKuhFh1+5bCP0hdNVypbGGgG6g=;
        b=noT4DQ1FjT3B7KYcgs+/YMmcRK4sdw4Ltjqurj6n7E4oMlBy+CE/DcwSmVmKuD/44u
         y+8tyecADfsHrm5nHx7Td8ko7xDsnURCOgc6t9wnu7z6XzClWlIGn4PYWfbAPbGrF/fr
         tvc7LAX4YoadTfiEv9vcNiCjU2eWEq6T4YC6IIXUHyNQP5ZIZ70zWOcB2TvjN/ltSCnk
         O4XUZTC5UfxSgU0M55e46itC2gcnEgaJwy1SIGhNySveM/CKg9qvdAw4u9SkYzPg89HZ
         Q5zTiQFXsxQDJan85PzBzEntb4qS/GPlPWEGUSPdjJj0mk5PMemMw/5BnxXI0LJKrcna
         cyJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776066225; x=1776671025;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=LuagEmmraWwH0d8g+cKuhFh1+5bCP0hdNVypbGGgG6g=;
        b=q3esv9rKTJJqAHPKeUR7nzoCxuIBXAK02VkgNDSSfuQBKaivDDQmuCkuJQSrxLcW0B
         56PpyJW6awn4SLDIfOGNLSgujRZKtjC4cNAt+WucfjLzg+UpdzbDAp0UiPWeutcaozB4
         24SQeD+TmL+PyySURM5FxAVmQuth3uLbGbdyi8Dy9TpDR0mh2QS4H48oKRrKWJdeGN2K
         KvTmgbcMY3zuDO3+C6gS3qYwNGvlO7Tc99fdz22pv7OhbqRRTu5uAKYUNW/ayU2t/rty
         KIIkHmZGsl/CUnr6g9YFTGWxlulT2Ff9yPBLQGyYaHrCuUZmbPCQkD72tGhu1pF/ldbt
         2PFw==
X-Forwarded-Encrypted: i=1; AFNElJ/98L32Hc978Cz/I+1j5HlQYcrb61CvDx4KtIZUsfBVWSKxsUu5t0kVuzIvpeBbqzNC3O7xkBzuuQ==@kvack.org
X-Gm-Message-State: AOJu0Yy9xuqG+s18BK1nCVXhBeaTJCrheRgdMfaBTzkDmQppGGvMf7lJ
	h0jtzgVKa2eSOm8Y0q+0yzdr8OSGTQAsTpTwwn6vGyQ5i0BdoEVxkwDcxIydh99J
X-Gm-Gg: AeBDieuX3wX5TY1mIv9QyKdsRObluioBwhDpHa9He5AAMYCbbnVI4r0oOY04se2oKXh
	cg83IIvCgysMk5b+a1BZYH9umS3mEPH9qieG+3/0DRhk8iZZTrguIgaJOVuaVL0HLGj55uPQgXQ
	w17HDm0BBqbiGuaQ1VY9Tsj6uwt/MrLpRjbjYb7jaeVm4bUAWxRDb2v00ZzakJISzvRubwF33Av
	SUrGZgUP/dRelAuiwDbD32n8CrEuJPHTZUfFsPfp+B7Xgxyjzgar43xZutCP68NPUnRpjeXNqL7
	q+2caDqpaVW+iCTSQwh42t3jLAvZZ2GgTIr9wuavdhzzp6A21jftrpY1xek4J1tGcrN8agNXDec
	f8m8QcQYrm0NxE8pf7yq8tY0GT8WygqOrJCWVX2y2jzGHHZQXwyAyhRe2XeFHJuBURcqp0ki/Oy
	NfhLv/W7cbD4sQLbvE
X-Received: by 2002:a05:7022:2528:b0:127:33e0:ea44 with SMTP id a92af1059eb24-12c34eec8d0mr7477882c88.29.1776066224747;
        Mon, 13 Apr 2026 00:43:44 -0700 (PDT)
Received: from wujing. ([74.48.213.230])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-12c347fa2c9sm12884610c88.15.2026.04.13.00.43.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Apr 2026 00:43:44 -0700 (PDT)
From: Qiliang Yuan <realwujing@gmail.com>
Date: Mon, 13 Apr 2026 15:43:08 +0800
Subject: [PATCH v2 02/12] sched/isolation: Introduce housekeeping notifier
 infrastructure
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260413-wujing-dhm-v2-2-06df21caba5d@gmail.com>
References: <20260413-wujing-dhm-v2-0-06df21caba5d@gmail.com>
In-Reply-To: <20260413-wujing-dhm-v2-0-06df21caba5d@gmail.com>
To: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, 
 Juri Lelli <juri.lelli@redhat.com>, 
 Vincent Guittot <vincent.guittot@linaro.org>, 
 Dietmar Eggemann <dietmar.eggemann@arm.com>, 
 Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, 
 Mel Gorman <mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>, 
 "Paul E. McKenney" <paulmck@kernel.org>, 
 Frederic Weisbecker <frederic@kernel.org>, 
 Neeraj Upadhyay <neeraj.upadhyay@kernel.org>, 
 Joel Fernandes <joelagnelf@nvidia.com>, 
 Josh Triplett <josh@joshtriplett.org>, Boqun Feng <boqun@kernel.org>, 
 Uladzislau Rezki <urezki@gmail.com>, 
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
 Lai Jiangshan <jiangshanlai@gmail.com>, Zqiang <qiang.zhang@linux.dev>, 
 Anna-Maria Behnsen <anna-maria@linutronix.de>, 
 Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@kernel.org>, 
 Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>, 
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
 Waiman Long <longman@redhat.com>, Chen Ridong <chenridong@huaweicloud.com>, 
 =?utf-8?q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
 Shuah Khan <shuah@kernel.org>
Cc: linux-kernel@vger.kernel.org, rcu@vger.kernel.org, linux-mm@kvack.org, 
 cgroups@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, Qiliang Yuan <realwujing@gmail.com>
X-Mailer: b4 0.13.0
X-Rspamd-Queue-Id: 4B94D4000E
X-Stat-Signature: 46m9sag5tzmt8mqkm1hkgprjd31yhb8x
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1776066226-834739
X-HE-Meta: U2FsdGVkX19pg9j+LqBF76mMkNCuvdYfCxDnaz4ZAfmTPsF/RsfPaQekpe4531ZKbzw8GekwHViyiEVO3FmY/LcocEBwUZqT9ogWzGYWc5j2hHiq0/f3xm0/dVbBsEOC2ANdNNlOZuKYwldJwjcKae8S4++GIdaOgkYdy2138+ArA5BfickH/Xy883vopwpU+OQ0AeypOWEASnotmjJ0OtrTCo4PwvzDWSTY+Q+1EOjPSi/2H1T8rR/xUWZ7BcZ5V2sGpzE/NLs7mmIawLacZXIFN+rOctrbjAMlQJpMNTILmbA84dBU88EGWRoos1RLfcsc8vz0IFAEEQjPbcJxhBWU1SwwK0VwRbCaN/b9qCOWqey1gRM/OlWvkgVSpUIUOenEv8G+DL+599dQwOF3YGGCfWvliwcfhz3Jdx/281nJ8q0XUeAcRo8ruu90QqZzsstDY0xEG7ZAj0zKF6RwKa2iN/oejRPCDk3MWyYoLQzz74f0Mvl3TjXK+BIp4LSQr82jfN6ukqK+fM4pldDMUe9wP02ELyAyditVio7Jc1pGgimGCyqNu2fW7VtjXqqpM7d4cz73b5pZHSKZUiH4K2BdERaCu2k6qvXqNCTb8fJokcwWYMNwc/9yDscCeVVPq/sZODokOtg8n410mQY7pZN/jfFNCJcXVIvYrYErpKj2xIKC/CRQjaSJ9CRX9idQpxgwcHxJgGqkKhmqUf3LB2Y7TnBUQKYyRZva3hZAC7B17vVGlQvmNqvSG5YkYx/f51GrZFW2miQ602YHjo3iFXurjsAaPbCokurqUBKIar4dFkD4w3SO2EW2DKoqcC7se5Z0FGvfDjAOIRHa00uCk3JtLxk4F2G9/bBYve+wQeHpV4oOWDV/rW15hMoThO2vuquAv4BVaYDxctlXzVJfDftLXyIA4zmeT4Ok2nmD6CRnAPiLwrn7f44kIO60JYcGBgoaquMUilvZBpsbOef
 8+CmBxqC
 qSFJqvxvHnp0ZFwHwicc0NHZ8YWXwCAzsLLkfwGON5v/r6J9JiCJzxix+QU/38OjzMowVamt1F23Vd4cZU7BKlNmstzigy8xfCDhS5ZmSbWKl+VDlqwi3j5G4ZyxNfWti8pHNdotn7/EHO/EmQeuMG7mc86eXrip7aUhesDaLiN6IdJzYwlS1g8uF24tuP/Gq22aBLpj2cRx6h8nDHkzQdyjESr8Oxy62KthoB8/ur/8y7nHYdroK3qnFO5D7O4vzMiA1J8jvv+lSEmsdkfnEBGUW5BAQdecHIASGUMInX8fgwQpaeag9agwryN8E+90JTZqBpL3jhgwq+8Q+DylErpG934wPnqw2gDFCNZwmciXZKMS5SpWqhB5WcAbbRCxe3Y4lc8tZaj8n3ktRm4kAXichXO9xcjy3VJ3y1j5FOxTw21NeoMpc/RW+2aekvTr6GRxeR0T8oJmQDMVLlieTX0un6J0glJ+Wjs8400G0YWIxTIQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Subsystems currently rely on static housekeeping masks determined at
boot. Supporting runtime reconfiguration (DHM v2) requires a mechanism
to broadcast mask changes to affected kernel components.

Implement a blocking notifier chain for housekeeping mask updates. This
infrastructure enables subsystems like genirq, workqueues, and RCU to
react dynamically to isolation changes triggered by cpusets.

Signed-off-by: Qiliang Yuan <realwujing@gmail.com>
---
 include/linux/sched/isolation.h | 21 +++++++++++++++++++++
 kernel/sched/isolation.c        | 26 ++++++++++++++++++++++++++
 2 files changed, 47 insertions(+)

diff --git a/include/linux/sched/isolation.h b/include/linux/sched/isolation.h
index b9a041247565c..aea1dbc4d7486 100644
--- a/include/linux/sched/isolation.h
+++ b/include/linux/sched/isolation.h
@@ -4,6 +4,7 @@
 #include <linux/cpumask.h>
 #include <linux/init.h>
 #include <linux/tick.h>
+#include <linux/notifier.h>
 
 enum hk_type {
 	/* Inverse of boot-time isolcpus= argument */
@@ -28,6 +29,13 @@ enum hk_type {
 
 #define HK_TYPE_KERNEL_NOISE HK_TYPE_TICK
 
+struct housekeeping_update {
+	enum hk_type type;
+	const struct cpumask *new_mask;
+};
+
+#define HK_UPDATE_MASK	0x01
+
 #ifdef CONFIG_CPU_ISOLATION
 DECLARE_STATIC_KEY_FALSE(housekeeping_overridden);
 extern int housekeeping_any_cpu(enum hk_type type);
@@ -38,6 +46,9 @@ extern bool housekeeping_test_cpu(int cpu, enum hk_type type);
 extern int housekeeping_update(struct cpumask *isol_mask);
 extern void __init housekeeping_init(void);
 
+extern int housekeeping_register_notifier(struct notifier_block *nb);
+extern int housekeeping_unregister_notifier(struct notifier_block *nb);
+
 #else
 
 static inline int housekeeping_any_cpu(enum hk_type type)
@@ -65,6 +76,16 @@ static inline bool housekeeping_test_cpu(int cpu, enum hk_type type)
 
 static inline int housekeeping_update(struct cpumask *isol_mask) { return 0; }
 static inline void housekeeping_init(void) { }
+
+static inline int housekeeping_register_notifier(struct notifier_block *nb)
+{
+	return 0;
+}
+
+static inline int housekeeping_unregister_notifier(struct notifier_block *nb)
+{
+	return 0;
+}
 #endif /* CONFIG_CPU_ISOLATION */
 
 static inline bool housekeeping_cpu(int cpu, enum hk_type type)
diff --git a/kernel/sched/isolation.c b/kernel/sched/isolation.c
index e05ed5118e651..0462b41807161 100644
--- a/kernel/sched/isolation.c
+++ b/kernel/sched/isolation.c
@@ -10,6 +10,7 @@
 #include <linux/sched/isolation.h>
 #include <linux/pci.h>
 #include "sched.h"
+#include <linux/notifier.h>
 
 enum hk_flags {
 	HK_FLAG_DOMAIN_BOOT	= BIT(HK_TYPE_DOMAIN_BOOT),
@@ -26,6 +27,8 @@ enum hk_flags {
 #define HK_FLAG_KERNEL_NOISE (HK_FLAG_TICK | HK_FLAG_TIMER | HK_FLAG_RCU | \
 			      HK_FLAG_MISC | HK_FLAG_WQ | HK_FLAG_KTHREAD)
 
+static BLOCKING_NOTIFIER_HEAD(housekeeping_notifier_list);
+
 DEFINE_STATIC_KEY_FALSE(housekeeping_overridden);
 EXPORT_SYMBOL_GPL(housekeeping_overridden);
 
@@ -170,6 +173,29 @@ int housekeeping_update(struct cpumask *isol_mask)
 	return 0;
 }
 
+int housekeeping_register_notifier(struct notifier_block *nb)
+{
+	return blocking_notifier_chain_register(&housekeeping_notifier_list, nb);
+}
+EXPORT_SYMBOL_GPL(housekeeping_register_notifier);
+
+int housekeeping_unregister_notifier(struct notifier_block *nb)
+{
+	return blocking_notifier_chain_unregister(&housekeeping_notifier_list, nb);
+}
+EXPORT_SYMBOL_GPL(housekeeping_unregister_notifier);
+
+int housekeeping_update_notify(enum hk_type type, const struct cpumask *new_mask)
+{
+	struct housekeeping_update update = {
+		.type = type,
+		.new_mask = new_mask,
+	};
+
+	return blocking_notifier_call_chain(&housekeeping_notifier_list, HK_UPDATE_MASK, &update);
+}
+EXPORT_SYMBOL_GPL(housekeeping_update_notify);
+
 void __init housekeeping_init(void)
 {
 	enum hk_type type;

-- 
2.43.0


